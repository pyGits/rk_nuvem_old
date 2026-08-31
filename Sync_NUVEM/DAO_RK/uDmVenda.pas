unit uDmVenda;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Generics.Collections,
  Conexao, Data.DB, MemDS, DBAccess, Uni, Cupom, VCL.dialogs, Estoque, NaoFiscal,
  Fechamento;

type
  TEtapaSincronizacao = function: Boolean of object;

  TdmVenda = class(TDataModule)
    qrCupomSincroniza: TUniQuery;
    qrCupomUpdate: TUniQuery;
    qrCupomItemSincroniza: TUniQuery;
    qrCupomItemUpdate: TUniQuery;
    qrCupomFormaSincroniza: TUniQuery;
    qrCupomFormaUpdate: TUniQuery;
    qrEstoqueSincroniza: TUniQuery;
    qrEstoqueUpdate: TUniQuery;
    qrNaoFiscalSincroniza: TUniQuery;
    qrNaoFiscalUpdate: TUniQuery;
    qrFechamentoSincroniza: TUniQuery;
    qrFechamentoUpdate: TUniQuery;
    qrFechamentoFormaSincroniza: TUniQuery;
    qrFechamentoFormaUpdate: TUniQuery;
  private
    FHouveFalha: Boolean;
    // se alguma etapa do ciclo tinha registro para subir
    FTeveTrabalho: Boolean;

    procedure executaEtapa(const nomeEtapa: string; etapa: TEtapaSincronizacao);
    procedure prepararSQL(qr: TUniQuery; const sql: string);
    procedure emTransacaoCurta(const nomeEtapa: string; total: integer;
      const marcar: TFunc<Integer>);
    function enviarPendentes(const nomeEtapa: string; total: integer;
      const enviarLote: TFunc<TList<Integer>, Boolean>;
      const enviarUm: TFunc<Integer, Boolean>;
      aceitos: TList<Integer>): Boolean;

    function sincronizaCupom:Boolean;
    function sincronizaCupomItem:boolean;
    function sincronizaCupomForma:boolean;
    function sincronizaEstoqueMovimentacao:Boolean;
    function sincronizaNaoFiscal:Boolean;
    function sincronizaFechamento:Boolean;
    function sincronizaFechamentoForma:boolean;

    function encerrarSubidaCupom(oCupom:TCupom):Integer;
    function encerrarSubidaCupomItem(oCupomItem:TCupomItem):Integer;
    function encerrarSubidaCupomForma(oCupomForma:TCupomForma):Integer;
    function encerrarSubidaEstoqueMovimentacao(oEstoqueMovimentacao:TEstoqueMovimentacao):Integer;
    function encerrarSubidaNaoFiscal(oNaoFiscal:TNaoFiscal):Integer;
    function encerrarSubidaFechamento(oFechamento:TFechamento):Integer;
    function encerrarSubidaFechamentoForma(oFechamentoForma:TFechamentoFin):Integer;
    function reenviarTabela(const tabela, colunaData: string;
      dtInicio, dtFim: TDate): Integer;
  public
    function sincronizaVenda:Boolean;
    function marcarPeriodoParaReenvio(dtInicio, dtFim: TDate): Integer;
    procedure liberarConexao;
  end;

var
  dmVenda: TdmVenda;

implementation
uses uAPIRequest, uLogErro;
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

const
  // Registros lidos por etapa em cada ciclo do timer. O que sobrar continua
  // com NUVEM = 0 e volta no ciclo seguinte: um cliente com meses de backlog
  // nao pode segurar o agente num unico ciclo interminavel.
  LOTE_LEITURA = 500;

  // Tentativas da fase de marcacao quando o Firebird devolve conflito de lock.
  // Com a transacao curta isso praticamente nao acontece; fica como rede de
  // seguranca para o instante em que o PDV grava exatamente a mesma linha.
  TENTATIVAS_MARCACAO = 3;

  // De quantos em quantos registros o envio unitario avisa a tela. Sem isso o
  // caminho registro a registro passa minutos sem dar sinal de vida.
  PASSO_PROGRESSO = 25;

{ TdmVenda }

// O SQL de cada query e fixo. Trocar o texto invalida o prepared statement, e
// o codigo anterior refazia isso a cada linha - a cada 5 segundos, o dia todo.
procedure TdmVenda.prepararSQL(qr: TUniQuery; const sql: string);
begin
  if qr.SQL.Text = sql then Exit;

  qr.Close;
  qr.SQL.Text := sql;
end;

function ehConflitoDeLock(E: Exception): Boolean;
var
  msg: string;
begin
  msg := LowerCase(E.Message);
  Result := (Pos('deadlock', msg) > 0) or
            (Pos('lock conflict', msg) > 0) or
            (Pos('update conflicts', msg) > 0);
end;

// Abre uma transacao apenas para marcar o que ja subiu e a fecha em seguida.
//
// E aqui que o deadlock morre. Antes, o UPDATE ... NUVEM = 1 acontecia dentro
// do laco, com o cursor do SELECT ainda aberto e um POST HTTPS entre uma linha
// e outra: a transacao de escrita ficava viva por minutos segurando as linhas
// de CUPOM, e o RK_Sync/PDV, que grava na mesma tabela em paralelo, batia
// nesses locks. Como efeito colateral a OAT do Firebird tambem ficava presa e
// o garbage collection parava, degradando a base.
//
// Agora a conversa com a nuvem acontece sem nenhuma transacao aberta, e a
// janela em que as linhas ficam travadas passa a ser de milissegundos.
// 'marcar' devolve quantas linhas o UPDATE realmente afetou. Esse numero e a
// unica prova de que o registro nao vai voltar no proximo ciclo: um UPDATE que
// nao casa com nenhuma linha, ou uma transacao que nao commita, nao levantam
// excecao nenhuma - a subida simplesmente refaz os mesmos registros para
// sempre.
procedure TdmVenda.emTransacaoCurta(const nomeEtapa: string; total: integer;
  const marcar: TFunc<Integer>);
var
  conexao: TUniConnection;
  tentativa: integer;
  marcados: integer;
begin
  conexao := dmConexao.ConexaoServer;
  tentativa := 0;

  uLogErro.Atividade(Format('Marcando %s como enviado...', [nomeEtapa]));

  while true do
  begin
    try
      if not conexao.InTransaction then
        conexao.StartTransaction;

      try
        marcados := marcar();
        // Commit incondicional: o UniDAC costuma deixar uma transacao
        // implicita viva depois de um Open, e condicionar o commit a "fui eu
        // que abri" deixava os UPDATE ... NUVEM = 1 sem nunca serem gravados.
        // O agente e uma thread so, com os timers desligados durante o ciclo,
        // entao nao existe transacao de outra rotina nesta conexao.
        conexao.Commit;
      except
        if conexao.InTransaction then
          conexao.Rollback;
        raise;
      end;

      if marcados < total then
      begin
        FHouveFalha := true;
        uLogErro.Progresso(Format(
          '%s: ATENCAO - %d de %d subiram mas nao foram marcados; vao ser reenviados',
          [nomeEtapa, total - marcados, total]));
        uLogErro.LogErro('MARCA_NUVEM',
          Format('Etapa %s | UPDATE afetou %d de %d linhas - conferir a chave da tabela',
            [nomeEtapa, marcados, total]));
      end;

      Exit;
    except
    on E: Exception do
    begin
      Inc(tentativa);

      if (tentativa >= TENTATIVAS_MARCACAO) or (not ehConflitoDeLock(E)) then
      begin
        FHouveFalha := true;
        // O registro subiu mas nao foi marcado: volta no proximo ciclo e a
        // nuvem reconhece pela chave, sem duplicar.
        uLogErro.LogErro('MARCA_NUVEM',
          Format('Etapa %s | %s: %s', [nomeEtapa, E.ClassName, E.Message]));
        Exit;
      end;

      Sleep(200 * tentativa);
    end;
    end;
  end;
end;

// Envio comum as sete etapas: tenta o lote e, se o servidor ainda nao tiver a
// rota, refaz registro a registro. Concentra tambem o que e mostrado na tela.
function TdmVenda.enviarPendentes(const nomeEtapa: string; total: integer;
  const enviarLote: TFunc<TList<Integer>, Boolean>;
  const enviarUm: TFunc<Integer, Boolean>;
  aceitos: TList<Integer>): Boolean;
var
  i: integer;
begin
  FTeveTrabalho := true;

  uLogErro.Progresso(Format('%s: %d pendente(s)', [nomeEtapa, total]));
  uLogErro.Atividade(Format('Enviando %s (%d)...', [nomeEtapa, total]));

  if not enviarLote(aceitos) then
  begin
    uLogErro.Progresso(Format('%s: nuvem sem a rota de lote, enviando registro a registro', [nomeEtapa]));

    for i := 0 to total - 1 do
    begin
      if enviarUm(i) then
        aceitos.Add(i);

      if (((i + 1) mod PASSO_PROGRESSO) = 0) or (i = total - 1) then
      begin
        uLogErro.Progresso(Format('   %s: %d de %d', [nomeEtapa, i + 1, total]));
        uLogErro.Atividade(Format('Enviando %s: %d de %d...', [nomeEtapa, i + 1, total]));
      end;
    end;
  end;

  Result := aceitos.Count = total;

  if aceitos.Count < total then
    uLogErro.Progresso(Format('%s: %d de %d aceito(s) - o restante volta no proximo ciclo',
      [nomeEtapa, aceitos.Count, total]))
  else
    uLogErro.Progresso(Format('%s: %d enviado(s)', [nomeEtapa, aceitos.Count]));
end;

function TdmVenda.encerrarSubidaCupom(oCupom: TCupom): Integer;
begin
  prepararSQL(qrCupomUpdate,
    'UPDATE CUPOM SET NUVEM = 1 WHERE CODIGO = :CODIGO AND COD_CAIXA = :COD_CAIXA');

  qrCupomUpdate.ParamByName('CODIGO').AsString := oCupom.codigo;
  qrCupomUpdate.ParamByName('COD_CAIXA').AsString := oCupom.caixa;
  qrCupomUpdate.ExecSQL;

  Result := qrCupomUpdate.RowsAffected;
end;

function TdmVenda.encerrarSubidaCupomForma(oCupomForma: TCupomForma): Integer;
begin
  prepararSQL(qrCupomFormaUpdate,
    'UPDATE CUPOM_FORMA SET NUVEM = 1 WHERE CODIGO = :CODIGO AND COD_CAIXA = :COD_CAIXA');

  qrCupomFormaUpdate.ParamByName('CODIGO').AsString := oCupomForma.codigo;
  qrCupomFormaUpdate.ParamByName('COD_CAIXA').AsString := oCupomForma.caixa;
  qrCupomFormaUpdate.ExecSQL;

  Result := qrCupomFormaUpdate.RowsAffected;
end;

function TdmVenda.encerrarSubidaCupomItem(oCupomItem: TCupomItem): Integer;
begin
  prepararSQL(qrCupomItemUpdate,
    'UPDATE CUPOM_ITEM SET NUVEM = 1 WHERE CODIGO = :CODIGO AND COD_CAIXA = :COD_CAIXA');

  qrCupomItemUpdate.ParamByName('CODIGO').AsString := oCupomItem.codigo;
  qrCupomItemUpdate.ParamByName('COD_CAIXA').AsString := oCupomItem.caixa;
  qrCupomItemUpdate.ExecSQL;

  Result := qrCupomItemUpdate.RowsAffected;
end;

function TdmVenda.encerrarSubidaEstoqueMovimentacao(
  oEstoqueMovimentacao: TEstoqueMovimentacao): Integer;
begin
  prepararSQL(qrEstoqueUpdate,
    'UPDATE ESTOQUE_MOVIMENTACAO SET NUVEM = 1 WHERE COD_CUPOM = :CODIGO AND ITEM = :ITEM');

  qrEstoqueUpdate.ParamByName('CODIGO').AsString := oEstoqueMovimentacao.codigo_cupom;
  qrEstoqueUpdate.ParamByName('ITEM').AsInteger := oEstoqueMovimentacao.item;
  qrEstoqueUpdate.ExecSQL;

  Result := qrEstoqueUpdate.RowsAffected;
end;

function TdmVenda.encerrarSubidaFechamento(oFechamento: TFechamento): Integer;
begin
  prepararSQL(qrFechamentoUpdate,
    'UPDATE FECHAMENTO SET NUVEM = 1 WHERE CODIGO = :CODIGO AND COD_CAIXA = :CAIXA');

  qrFechamentoUpdate.ParamByName('CODIGO').AsString := oFechamento.codigo;
  qrFechamentoUpdate.ParamByName('CAIXA').AsInteger := oFechamento.codCaixa;
  qrFechamentoUpdate.ExecSQL;

  Result := qrFechamentoUpdate.RowsAffected;
end;

function TdmVenda.encerrarSubidaFechamentoForma(
  oFechamentoForma: TFechamentoFin): Integer;
begin
  prepararSQL(qrFechamentoFormaUpdate,
    'UPDATE FECHAMENTO_FINALIZADORA SET NUVEM = 1 ' +
    ' WHERE ID_FECHAMENTO = :CODIGO AND COD_CAIXA = :CAIXA AND FZCOD = :FZCOD');

  qrFechamentoFormaUpdate.ParamByName('CODIGO').AsString := oFechamentoForma.id;
  qrFechamentoFormaUpdate.ParamByName('CAIXA').AsInteger := oFechamentoForma.codCaixa;
  qrFechamentoFormaUpdate.ParamByName('FZCOD').AsString := oFechamentoForma.Finalizadora;
  qrFechamentoFormaUpdate.ExecSQL;

  Result := qrFechamentoFormaUpdate.RowsAffected;
end;

function TdmVenda.encerrarSubidaNaoFiscal(oNaoFiscal: TNaoFiscal): Integer;
begin
  prepararSQL(qrNaoFiscalUpdate,
    'UPDATE NAO_FISCAL SET NUVEM = 1 WHERE CODIGO = :CODIGO AND COD_CAIXA = :CAIXA');

  qrNaoFiscalUpdate.ParamByName('CODIGO').AsString := oNaoFiscal.codigo;
  qrNaoFiscalUpdate.ParamByName('CAIXA').AsInteger := oNaoFiscal.caixa;
  qrNaoFiscalUpdate.ExecSQL;

  Result := qrNaoFiscalUpdate.RowsAffected;
end;

// As sete etapas seguem o mesmo contrato de tres fases:
//   1. le os pendentes para memoria e FECHA o cursor;
//   2. envia, sem nenhum dataset ou transacao aberta no Firebird;
//   3. marca NUVEM = 1 numa transacao curta, so do que a nuvem confirmou.
// A ordenacao do SELECT tambem importa: deadlock exige duas transacoes pegando
// locks em ordens opostas, e uma ordem fixa elimina esse cenario.

function TdmVenda.sincronizaCupom: Boolean;
var
  pendentes: TObjectList<TCupom>;
  aceitos: TList<Integer>;
  oCupom: TCupom;
begin
  Result := true;

  pendentes := TObjectList<TCupom>.Create(true);
  aceitos := TList<Integer>.Create;
  try
    prepararSQL(qrCupomSincroniza,
      'SELECT FIRST ' + IntToStr(LOTE_LEITURA) + ' * FROM CUPOM ' +
      ' WHERE NUVEM = 0 ORDER BY COD_CAIXA, CODIGO');

    uLogErro.Atividade('Procurando pendentes em CUPOM...');
    qrCupomSincroniza.Open;
    try
      while not qrCupomSincroniza.Eof do
      begin
        oCupom := TCupom.Create;
        pendentes.Add(oCupom);

        with qrCupomSincroniza do
        begin
          oCupom.codigo := FieldByName('CODIGO').AsString;
          oCupom.numero := FieldByName('NUMERO').AsString;
          oCupom.data := FieldByName('data').AsDateTime;
          oCupom.hora := FieldByName('hora').AsDateTime;
          oCupom.caixa := FieldByName('COD_CAIXA').AsString;
          oCupom.qtde_item := FieldByName('qtde_item').AsInteger;
          oCupom.valor_desconto := FieldByName('valor_desconto').AsFloat;
          oCupom.valor_acrescimo := FieldByName('valor_acrescimo').AsFloat;
          oCupom.valor_total := FieldByName('valor_total').AsFloat;
          oCupom.codigo_cliente := FieldByName('COD_CLIENTE').AsString;
          oCupom.cancelado := FieldByName('cancelado').AsInteger;
          oCupom.cpf_consumidor := FieldByName('cpf_consumidor').AsString;
          oCupom.nome_consumidor := FieldByName('nome_consumidor').AsString;
          oCupom.vendedor := FieldByName('COD_VENDEDOR').AsString;
          oCupom.xml_venda := FieldByName('XML_CHAVE').AsString;
          oCupom.xml_cancelamento := FieldByName('XML_CHAVE_CANCELAMENTO').AsString;
          oCupom.valor_custo := FieldByName('VALOR_CUSTO').AsFloat;

          Next;
        end;
      end;
    finally
      qrCupomSincroniza.Close;
    end;

    if pendentes.Count = 0 then Exit;

    Result := enviarPendentes('CUPOM', pendentes.Count,
      function(confirmados: TList<Integer>): Boolean
      begin
        Result := uAPIRequest.postVendaLote(pendentes, confirmados);
      end,
      function(indice: Integer): Boolean
      begin
        Result := uAPIRequest.postVenda(pendentes[indice]);
      end,
      aceitos);

    if aceitos.Count = 0 then Exit;

    emTransacaoCurta('CUPOM', aceitos.Count,
      function: Integer
      var
        j: integer;
      begin
        Result := 0;
        for j := 0 to aceitos.Count - 1 do
          Inc(Result, encerrarSubidaCupom(pendentes[aceitos[j]]));
      end);
  finally
    aceitos.Free;
    pendentes.Free;
  end;
end;

function TdmVenda.sincronizaCupomItem: boolean;
var
  pendentes: TObjectList<TCupomItem>;
  aceitos: TList<Integer>;
  oCupomItem: TCupomItem;
begin
  Result := true;

  pendentes := TObjectList<TCupomItem>.Create(true);
  aceitos := TList<Integer>.Create;
  try
    prepararSQL(qrCupomItemSincroniza,
      'SELECT FIRST ' + IntToStr(LOTE_LEITURA) + ' * FROM CUPOM_ITEM ' +
      ' WHERE NUVEM = 0 ORDER BY COD_CAIXA, CODIGO');

    uLogErro.Atividade('Procurando pendentes em CUPOM_ITEM...');
    qrCupomItemSincroniza.Open;
    try
      while not qrCupomItemSincroniza.Eof do
      begin
        oCupomItem := TCupomItem.Create;
        pendentes.Add(oCupomItem);

        with qrCupomItemSincroniza do
        begin
          oCupomItem.codigo := FieldByName('CODIGO').AsString;
          oCupomItem.codigo_cupom := FieldByName('COD_CUPOM').AsString;
          oCupomItem.item := FieldByName('ITEM').AsInteger;
          oCupomItem.unidade := FieldByName('UNIDADE').AsString;
          oCupomItem.qtde := FieldByName('QTDE').AsFloat;
          oCupomItem.valor_unitario := FieldByName('VALOR_UNITARIO').AsFloat;
          oCupomItem.valor_desconto := FieldByName('VALOR_DESCONTO').AsFloat;
          oCupomItem.valor_acrescimo := FieldByName('VALOR_ACRESCIMO').AsFloat;
          oCupomItem.valor_total := FieldByName('VALOR_TOTAL').AsFloat;
          oCupomItem.cancelado := FieldByName('CANCELADO').AsInteger;
          oCupomItem.data := FieldByName('DATA').AsDateTime;
          oCupomItem.caixa := FieldByName('COD_CAIXA').AsString;
          oCupomItem.codigo_produto := FieldByName('COD_PRODUTO').AsString;
          oCupomItem.valor_custo := FieldByName('VALOR_CUSTO').AsFloat;
          oCupomItem.valor_custo_total := FieldByName('VALOR_CUSTO_TOTAL').AsFloat;

          Next;
        end;
      end;
    finally
      qrCupomItemSincroniza.Close;
    end;

    if pendentes.Count = 0 then Exit;

    Result := enviarPendentes('CUPOM_ITEM', pendentes.Count,
      function(confirmados: TList<Integer>): Boolean
      begin
        Result := uAPIRequest.postVendaItemLote(pendentes, confirmados);
      end,
      function(indice: Integer): Boolean
      begin
        Result := uAPIRequest.postVendaItem(pendentes[indice]);
      end,
      aceitos);

    if aceitos.Count = 0 then Exit;

    emTransacaoCurta('CUPOM_ITEM', aceitos.Count,
      function: Integer
      var
        j: integer;
      begin
        Result := 0;
        for j := 0 to aceitos.Count - 1 do
          Inc(Result, encerrarSubidaCupomItem(pendentes[aceitos[j]]));
      end);
  finally
    aceitos.Free;
    pendentes.Free;
  end;
end;

function TdmVenda.sincronizaCupomForma: boolean;
var
  pendentes: TObjectList<TCupomForma>;
  aceitos: TList<Integer>;
  oCupomForma: TCupomForma;
begin
  Result := true;

  pendentes := TObjectList<TCupomForma>.Create(true);
  aceitos := TList<Integer>.Create;
  try
    prepararSQL(qrCupomFormaSincroniza,
      'SELECT FIRST ' + IntToStr(LOTE_LEITURA) + ' * FROM CUPOM_FORMA ' +
      ' WHERE NUVEM = 0 ORDER BY COD_CAIXA, CODIGO');

    uLogErro.Atividade('Procurando pendentes em CUPOM_FORMA...');
    qrCupomFormaSincroniza.Open;
    try
      while not qrCupomFormaSincroniza.Eof do
      begin
        oCupomForma := TCupomForma.Create;
        pendentes.Add(oCupomForma);

        with qrCupomFormaSincroniza do
        begin
          oCupomForma.codigo := FieldByName('CODIGO').AsString;
          oCupomForma.codigo_cupom := FieldByName('COD_CUPOM').AsString;
          oCupomForma.prestacao := FieldByName('PRESTACAO').AsInteger;
          oCupomForma.data := FieldByName('DATA').AsDateTime;
          oCupomForma.caixa := FieldByName('COD_CAIXA').AsString;
          oCupomForma.valor := FieldByName('VALOR').AsFloat;
          oCupomForma.finalizadora := FieldByName('FORMA').AsString;
          oCupomForma.tipo := FieldByName('TIPO').AsInteger;
          oCupomForma.valor_troco := FieldByName('VALOR_TROCO').AsFloat;
          oCupomForma.cancelado := FieldByName('CANCELADO').AsInteger;

          Next;
        end;
      end;
    finally
      qrCupomFormaSincroniza.Close;
    end;

    if pendentes.Count = 0 then Exit;

    Result := enviarPendentes('CUPOM_FORMA', pendentes.Count,
      function(confirmados: TList<Integer>): Boolean
      begin
        Result := uAPIRequest.postVendaFormaLote(pendentes, confirmados);
      end,
      function(indice: Integer): Boolean
      begin
        Result := uAPIRequest.postVendaForma(pendentes[indice]);
      end,
      aceitos);

    if aceitos.Count = 0 then Exit;

    emTransacaoCurta('CUPOM_FORMA', aceitos.Count,
      function: Integer
      var
        j: integer;
      begin
        Result := 0;
        for j := 0 to aceitos.Count - 1 do
          Inc(Result, encerrarSubidaCupomForma(pendentes[aceitos[j]]));
      end);
  finally
    aceitos.Free;
    pendentes.Free;
  end;
end;

function TdmVenda.sincronizaEstoqueMovimentacao: Boolean;
var
  pendentes: TObjectList<TEstoqueMovimentacao>;
  aceitos: TList<Integer>;
  oMovimentacao: TEstoqueMovimentacao;
begin
  Result := true;

  pendentes := TObjectList<TEstoqueMovimentacao>.Create(true);
  aceitos := TList<Integer>.Create;
  try
    prepararSQL(qrEstoqueSincroniza,
      'SELECT FIRST ' + IntToStr(LOTE_LEITURA) + ' * FROM ESTOQUE_MOVIMENTACAO ' +
      ' WHERE NUVEM = 0 ORDER BY COD_CUPOM, ITEM');

    uLogErro.Atividade('Procurando pendentes em ESTOQUE_MOVIMENTACAO...');
    qrEstoqueSincroniza.Open;
    try
      while not qrEstoqueSincroniza.Eof do
      begin
        oMovimentacao := TEstoqueMovimentacao.Create;
        pendentes.Add(oMovimentacao);

        with qrEstoqueSincroniza do
        begin
          oMovimentacao.codigo_produto := FieldByName('CODPRODUTO').AsString;
          oMovimentacao.qtde := FieldByName('QTDE').AsFloat;
          oMovimentacao.data := FieldByName('DATA').AsDateTime;
          oMovimentacao.hora := FieldByName('HORA').AsDateTime;
          oMovimentacao.codigo_cupom := FieldByName('COD_CUPOM').AsString;
          oMovimentacao.item := FieldByName('ITEM').AsInteger;
          oMovimentacao.codigo_funcionario := FieldByName('COD_FUNCIONARIO').AsString;
          oMovimentacao.origem := FieldByName('ORIGEM').AsString;

          Next;
        end;
      end;
    finally
      qrEstoqueSincroniza.Close;
    end;

    if pendentes.Count = 0 then Exit;

    Result := enviarPendentes('ESTOQUE_MOVIMENTACAO', pendentes.Count,
      function(confirmados: TList<Integer>): Boolean
      begin
        Result := uAPIRequest.postEstoqueMovimentacaoLote(pendentes, confirmados);
      end,
      function(indice: Integer): Boolean
      begin
        Result := uAPIRequest.postEstoqueMovimentacao(pendentes[indice]);
      end,
      aceitos);

    if aceitos.Count = 0 then Exit;

    emTransacaoCurta('ESTOQUE_MOVIMENTACAO', aceitos.Count,
      function: Integer
      var
        j: integer;
      begin
        Result := 0;
        for j := 0 to aceitos.Count - 1 do
          Inc(Result, encerrarSubidaEstoqueMovimentacao(pendentes[aceitos[j]]));
      end);
  finally
    aceitos.Free;
    pendentes.Free;
  end;
end;

function TdmVenda.sincronizaNaoFiscal: Boolean;
var
  pendentes: TObjectList<TNaoFiscal>;
  aceitos: TList<Integer>;
  oNaoFiscal: TNaoFiscal;
begin
  Result := true;

  pendentes := TObjectList<TNaoFiscal>.Create(true);
  aceitos := TList<Integer>.Create;
  try
    prepararSQL(qrNaoFiscalSincroniza,
      'SELECT FIRST ' + IntToStr(LOTE_LEITURA) + ' * FROM NAO_FISCAL ' +
      ' WHERE NUVEM = 0 ORDER BY COD_CAIXA, CODIGO');

    uLogErro.Atividade('Procurando pendentes em NAO_FISCAL...');
    qrNaoFiscalSincroniza.Open;
    try
      while not qrNaoFiscalSincroniza.Eof do
      begin
        oNaoFiscal := TNaoFiscal.Create;
        pendentes.Add(oNaoFiscal);

        with qrNaoFiscalSincroniza do
        begin
          oNaoFiscal.codigo := FieldByName('CODIGO').AsString;
          oNaoFiscal.data := FieldByName('DATA').AsDateTime;
          oNaoFiscal.indice := FieldByName('INDICE').AsString;
          oNaoFiscal.Descricao := FieldByName('DESCRICAO').AsString;
          oNaoFiscal.Valor := FieldByName('VALOR').AsFloat;
          oNaoFiscal.Hora := FieldByName('HORA').AsDateTime;
          oNaoFiscal.Vendedor := FieldByName('CODVENDEDOR').AsInteger;
          oNaoFiscal.fzcod := FieldByName('FZCOD').AsString;
          oNaoFiscal.caixa := FieldByName('COD_CAIXA').AsInteger;

          Next;
        end;
      end;
    finally
      qrNaoFiscalSincroniza.Close;
    end;

    if pendentes.Count = 0 then Exit;

    Result := enviarPendentes('NAO_FISCAL', pendentes.Count,
      function(confirmados: TList<Integer>): Boolean
      begin
        Result := uAPIRequest.postNaoFiscalLote(pendentes, confirmados);
      end,
      function(indice: Integer): Boolean
      begin
        Result := uAPIRequest.postNaoFiscal(pendentes[indice]);
      end,
      aceitos);

    if aceitos.Count = 0 then Exit;

    emTransacaoCurta('NAO_FISCAL', aceitos.Count,
      function: Integer
      var
        j: integer;
      begin
        Result := 0;
        for j := 0 to aceitos.Count - 1 do
          Inc(Result, encerrarSubidaNaoFiscal(pendentes[aceitos[j]]));
      end);
  finally
    aceitos.Free;
    pendentes.Free;
  end;
end;

function TdmVenda.sincronizaFechamento: Boolean;
var
  pendentes: TObjectList<TFechamento>;
  aceitos: TList<Integer>;
  oFechamento: TFechamento;
begin
  Result := true;

  pendentes := TObjectList<TFechamento>.Create(true);
  aceitos := TList<Integer>.Create;
  try
    prepararSQL(qrFechamentoSincroniza,
      'SELECT FIRST ' + IntToStr(LOTE_LEITURA) + ' * FROM FECHAMENTO ' +
      ' WHERE NUVEM = 0 ORDER BY COD_CAIXA, CODIGO');

    uLogErro.Atividade('Procurando pendentes em FECHAMENTO...');
    qrFechamentoSincroniza.Open;
    try
      while not qrFechamentoSincroniza.Eof do
      begin
        oFechamento := TFechamento.Create;
        pendentes.Add(oFechamento);

        with qrFechamentoSincroniza do
        begin
          oFechamento.codigo := FieldByName('CODIGO').AsString;
          oFechamento.operador := FieldByName('OPERADOR').AsString;
          oFechamento.dataAbertura := FieldByName('DATA_ABERTURA').AsDateTime;
          oFechamento.dataFechamento := FieldByName('DATA_FECHAMENTO').AsDateTime;
          oFechamento.horaAbertura := FieldByName('HORA_ABERTURA').AsDateTime;
          oFechamento.horaFechamento := FieldByName('HORA_FECHAMENTO').AsDateTime;
          oFechamento.codOperador := FieldByName('COD_OPERADOR').AsInteger;
          oFechamento.codCaixa := FieldByName('COD_CAIXA').AsInteger;

          oFechamento.vendaBruta := FieldByName('VENDA_BRUTA').AsFloat;
          oFechamento.cancelamentoCupom := FieldByName('CANCELAMENTO_CUPOM').AsFloat;
          oFechamento.cancelamentoItem := FieldByName('CANCELAMENTO_ITEM').AsFloat;
          oFechamento.descontoItem := FieldByName('DESCONTO_ITEM').AsFloat;
          oFechamento.descontoCupom := FieldByName('DESCONTO_CUPOM').AsFloat;
          oFechamento.acrescimoCupom := FieldByName('ACRESCIMO_CUPOM').AsFloat;
          oFechamento.vendaLiquida := FieldByName('VENDA_LIQUIDA').AsFloat;
          oFechamento.fundoCaixa := FieldByName('FUNDO_CAIXA').AsFloat;
          oFechamento.sangria := FieldByName('SANGRIA').AsFloat;
          oFechamento.totais := FieldByName('TOTAIS').AsFloat;

          oFechamento.qtdCuponsEfetivados := FieldByName('QTD_CUPONS_EFETIVADOS').AsInteger;
          oFechamento.qtdCuponsCancelados := FieldByName('QTD_CUPONS_CANCELADOS').AsInteger;

          Next;
        end;
      end;
    finally
      qrFechamentoSincroniza.Close;
    end;

    if pendentes.Count = 0 then Exit;

    Result := enviarPendentes('FECHAMENTO', pendentes.Count,
      function(confirmados: TList<Integer>): Boolean
      begin
        Result := uAPIRequest.postFechamentoLote(pendentes, confirmados);
      end,
      function(indice: Integer): Boolean
      begin
        Result := uAPIRequest.postFechamento(pendentes[indice]);
      end,
      aceitos);

    if aceitos.Count = 0 then Exit;

    emTransacaoCurta('FECHAMENTO', aceitos.Count,
      function: Integer
      var
        j: integer;
      begin
        Result := 0;
        for j := 0 to aceitos.Count - 1 do
          Inc(Result, encerrarSubidaFechamento(pendentes[aceitos[j]]));
      end);
  finally
    aceitos.Free;
    pendentes.Free;
  end;
end;

function TdmVenda.sincronizaFechamentoForma: boolean;
var
  pendentes: TObjectList<TFechamentoFin>;
  aceitos: TList<Integer>;
  oFechamentoForma: TFechamentoFin;
begin
  Result := true;

  pendentes := TObjectList<TFechamentoFin>.Create(true);
  aceitos := TList<Integer>.Create;
  try
    prepararSQL(qrFechamentoFormaSincroniza,
      'SELECT FIRST ' + IntToStr(LOTE_LEITURA) + ' * FROM FECHAMENTO_FINALIZADORA ' +
      ' WHERE NUVEM = 0 ORDER BY COD_CAIXA, ID_FECHAMENTO, FZCOD');

    uLogErro.Atividade('Procurando pendentes em FECHAMENTO_FINALIZADORA...');
    qrFechamentoFormaSincroniza.Open;
    try
      while not qrFechamentoFormaSincroniza.Eof do
      begin
        oFechamentoForma := TFechamentoFin.Create;
        pendentes.Add(oFechamentoForma);

        with qrFechamentoFormaSincroniza do
        begin
          oFechamentoForma.id := FieldByName('ID_FECHAMENTO').AsString;
          oFechamentoForma.Finalizadora := FieldByName('FZCOD').AsString;
          oFechamentoForma.valorLiquido := FieldByName('VALOR_LIQUIDO').AsFloat;
          oFechamentoForma.valorEntrada := FieldByName('VALOR_ENTRADA').AsFloat;
          oFechamentoForma.valorTroco := FieldByName('VALOR_TROCO').AsFloat;
          oFechamentoForma.valorReforco := FieldByName('VALOR_REFORCO').AsFloat;
          oFechamentoForma.valorSangria := FieldByName('VALOR_SANGRIA').AsFloat;
          oFechamentoForma.codCaixa := FieldByName('COD_CAIXA').AsInteger;

          Next;
        end;
      end;
    finally
      qrFechamentoFormaSincroniza.Close;
    end;

    if pendentes.Count = 0 then Exit;

    Result := enviarPendentes('FECHAMENTO_FINALIZADORA', pendentes.Count,
      function(confirmados: TList<Integer>): Boolean
      begin
        Result := uAPIRequest.postFechamentoFormaLote(pendentes, confirmados);
      end,
      function(indice: Integer): Boolean
      begin
        Result := uAPIRequest.postFechamentoForma(pendentes[indice]);
      end,
      aceitos);

    if aceitos.Count = 0 then Exit;

    emTransacaoCurta('FECHAMENTO_FINALIZADORA', aceitos.Count,
      function: Integer
      var
        j: integer;
      begin
        Result := 0;
        for j := 0 to aceitos.Count - 1 do
          Inc(Result, encerrarSubidaFechamentoForma(pendentes[aceitos[j]]));
      end);
  finally
    aceitos.Free;
    pendentes.Free;
  end;
end;

// Cada etapa e isolada: se uma falhar (query, conexao, rede) as demais ainda
// tentam subir, e o motivo da falha fica registrado no arquivo de log.
procedure TdmVenda.executaEtapa(const nomeEtapa: string; etapa: TEtapaSincronizacao);
begin
  try
    if not etapa() then
      FHouveFalha := true;
  except
  on E:Exception do
  begin
    FHouveFalha := true;
    uLogErro.LogErro('SINCRONIZA_VENDA', 'Etapa ' + nomeEtapa + ' | ' +
      E.ClassName + ': ' + E.Message);
  end;
  end;
end;

// Solta a transacao que o UniDAC deixa viva depois de um Open. Enquanto ela
// existe a conexao do agente conta como "usando" CUPOM e companhia, e um
// CREATE INDEX nessas tabelas falha com "object is in use" - inclusive quando
// quem esta tentando criar o indice e o proprio agente.
procedure TdmVenda.liberarConexao;
var
  conexao: TUniConnection;
begin
  conexao := dmConexao.ConexaoServer;
  try
    if conexao.InTransaction then
      conexao.Commit;
  except
  on E: Exception do
    uLogErro.LogErro('LIBERA_CONEXAO', Format('%s: %s', [E.ClassName, E.Message]));
  end;
end;

// Devolve para a fila a venda de um periodo que ja subiu: zera o NUVEM das tres
// tabelas do cupom e deixa o ciclo normal do timer fazer o resto. Nao existe
// caminho paralelo de envio - o que muda e so o que esta pendente.
//
// So mexe em NUVEM = 1. O que ainda esta pendente ja vai subir sozinho, e
// reescrever essas linhas so criaria disputa de lock com o PDV gravando venda.
//
// Reenviar nao duplica na nuvem: /venda, /vendaItem e /vendaForma fazem upsert
// pela chave de negocio, tanto no envio unitario quanto no de lote.
//
// A leitura continua limitada a LOTE_LEITURA por ciclo, entao um periodo longo
// escoa aos poucos, sem segurar o agente num unico ciclo interminavel.
function TdmVenda.reenviarTabela(const tabela, colunaData: string;
  dtInicio, dtFim: TDate): Integer;
var
  qr: TUniQuery;
begin
  // Query propria, criada na hora: as do datamodule tem SQL fixo e prepared, e
  // trocar o texto delas por causa de uma acao manual invalidaria o prepared
  // statement que o ciclo usa a cada cinco segundos.
  qr := TUniQuery.Create(nil);
  try
    qr.Connection := dmConexao.ConexaoServer;
    qr.SQL.Text := Format(
      'UPDATE %s SET NUVEM = 0 WHERE COALESCE(NUVEM, 0) = 1 AND %s BETWEEN :INICIO AND :FIM',
      [tabela, colunaData]);
    qr.ParamByName('INICIO').AsDate := dtInicio;
    qr.ParamByName('FIM').AsDate := dtFim;
    qr.Execute;
    Result := qr.RowsAffected;
  finally
    qr.Free;
  end;
end;

function TdmVenda.marcarPeriodoParaReenvio(dtInicio, dtFim: TDate): Integer;
var
  afetados: Integer;
begin
  afetados := 0;

  // total = 0 porque aqui nao existe "quantos deviam ter sido marcados": o
  // numero e justamente o que se quer descobrir. O que vale de emTransacaoCurta
  // e a transacao curta com retry de conflito de lock.
  emTransacaoCurta('REENVIO_PERIODO', 0,
    function: Integer
    begin
      Result := reenviarTabela('CUPOM', 'DATA', dtInicio, dtFim) +
                reenviarTabela('CUPOM_ITEM', 'DATA', dtInicio, dtFim) +
                reenviarTabela('CUPOM_FORMA', 'DATA', dtInicio, dtFim);
      afetados := Result;
    end);

  uLogErro.LogErro('REENVIO_PERIODO',
    Format('%s a %s | %d linha(s) devolvidas para a fila',
      [DateToStr(dtInicio), DateToStr(dtFim), afetados]));

  Result := afetados;
end;

function TdmVenda.sincronizaVenda: Boolean;
var
  inicio: Cardinal;
begin
FHouveFalha := false;
FTeveTrabalho := false;
inicio := GetTickCount;

executaEtapa('CUPOM', sincronizaCupom);
executaEtapa('CUPOM_ITEM', sincronizaCupomItem);
executaEtapa('CUPOM_FORMA', sincronizaCupomForma);
executaEtapa('ESTOQUE_MOVIMENTACAO', sincronizaEstoqueMovimentacao);
executaEtapa('NAO_FISCAL', sincronizaNaoFiscal);
executaEtapa('FECHAMENTO', sincronizaFechamento);
executaEtapa('FECHAMENTO_FINALIZADORA', sincronizaFechamentoForma);

// So conta o ciclo na tela quando houve trabalho: um ciclo vazio a cada 5
// segundos encheria o memo sem dizer nada.
if FTeveTrabalho then
  uLogErro.Progresso(Format('Subida concluida em %.1f s',
    [(GetTickCount - inicio) / 1000]));

uLogErro.Atividade('');

result := not FHouveFalha;
end;

end.
