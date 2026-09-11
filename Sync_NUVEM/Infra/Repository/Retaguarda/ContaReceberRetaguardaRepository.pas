unit ContaReceberRetaguardaRepository;

interface
uses System.Generics.Collections, System.SysUtils, FireDAC.Comp.Client,
     uConexaoRetaguarda, ContaReceber;

// Le os titulos de convenio de CONTAS_RECEBER, no banco do servidor.
//
// Ate aqui isso era lido caixa a caixa, em CUPOM_CREDIARIO, dentro do banco de
// cada PDV - o unico ponto em que a subida saia do servidor. A regra passou a
// ser uma so: o agente sobe do servidor e nada mais. Quem leva o titulo do PDV
// para la e o RK_Sync, pela procedure ST_CONTAS_RECEBER, o mesmo caminho que ja
// traz CUPOM e CUPOM_FORMA.
//
// O que se ganha e nao depender de cada caixa estar ligado e na rede a cada
// ciclo. O que se paga e a latencia do RK_Sync: o titulo so aparece aqui depois
// que ele passa.
//
// CONTAS_RECEBER nao e identica a CUPOM_CREDIARIO, e duas diferencas mudam o
// que sobe:
//   - nao existe coluna PRESTACAO. A parcela esta dentro do proprio CODIGO,
//     que e o codigo do cupom seguido dos tres digitos da parcela
//     (...23649 + 001). Codigo fora desse formato vira parcela 1.
//   - nao existe DESCRICAO. Sobe vazia, que e o que o PDV grava na pratica.
type IContaReceberRetaguardaRepository = interface
  ['{A4E1C7D2-3B56-4F98-8C10-5D2E9B7A6C34}']
  function getPendentes: TObjectList<TContaReceber>;
  // A PK e (CODIGO, COD_CUPOM): o codigo sozinho nao identifica a linha.
  procedure marcarEnviado(const codigo, codigoCupom: string);
  procedure garantirColunaNuvem;
  function marcarPeriodoParaReenvio(dtInicio, dtFim: TDate): Integer;
end;

type TContaReceberRetaguardaRepository = class(TInterfacedObject,IContaReceberRetaguardaRepository)
  private
    // a coluna so precisa ser verificada uma vez por execucao do agente
    FColunaVerificada:Boolean;
    function prestacaoDoCodigo(const codigo, codigoCupom: string): integer;
  public
    function getPendentes: TObjectList<TContaReceber>;
    procedure marcarEnviado(const codigo, codigoCupom: string);
    procedure garantirColunaNuvem;
    function marcarPeriodoParaReenvio(dtInicio, dtFim: TDate): Integer;
end;

implementation

const
  // Titulos lidos por ciclo. O que sobrar continua pendente e volta no ciclo
  // seguinte - mesmo criterio das etapas de venda: um cliente com anos de
  // crediario atrasado nao pode segurar o agente num ciclo interminavel.
  LOTE_LEITURA = 500;

{ TContaReceberRetaguardaRepository }

// A retaguarda do cliente nao atualiza junto com o agente. Sem isso, um
// servidor ainda sem a coluna faria o SELECT estourar "Column unknown: NUVEM"
// a cada ciclo. O bloco e idempotente e so roda DDL se a coluna faltar.
procedure TContaReceberRetaguardaRepository.garantirColunaNuvem;
begin
  if FColunaVerificada then Exit;

  TConexao.GetInstance.ExecSQL(
    'EXECUTE BLOCK AS BEGIN ' +
    '  IF (NOT EXISTS(SELECT 1 FROM RDB$RELATION_FIELDS ' +
    '                 WHERE RDB$RELATION_NAME = ''CONTAS_RECEBER'' ' +
    '                   AND RDB$FIELD_NAME = ''NUVEM'')) THEN ' +
    '    EXECUTE STATEMENT ''ALTER TABLE CONTAS_RECEBER ADD NUVEM INTEGER DEFAULT 0''; ' +
    'END');

  FColunaVerificada := true;
end;

// A parcela nao tem coluna propria: ela e o que sobra do CODIGO depois do
// codigo do cupom. Codigo que nao comeca pelo cupom, ou cujo resto nao e
// numero, vira parcela 1 - que e o que a nuvem ja assume em titulo de parcela
// unica.
function TContaReceberRetaguardaRepository.prestacaoDoCodigo(const codigo,
  codigoCupom: string): integer;
var
  sufixo:string;
begin
  Result := 1;

  if (codigoCupom = '') or (Pos(codigoCupom, codigo) <> 1) then Exit;

  sufixo := Copy(codigo, Length(codigoCupom) + 1, MaxInt);
  Result := StrToIntDef(sufixo, 1);

  if Result <= 0 then
    Result := 1;
end;

// Numero da venda e CPF saem por subconsulta, e nao por JOIN, para garantir uma
// linha por titulo: a PK de CUPOM e (CODIGO, DATA, COD_CAIXA), entao juntar so
// pelo codigo do cupom multiplicaria o titulo quando o mesmo codigo existe em
// mais de um caixa.
//
// O CPF vem do cadastro de clientes para a nuvem casar o titulo mesmo quando o
// codigo do cliente e local.
function TContaReceberRetaguardaRepository.getPendentes: TObjectList<TContaReceber>;
var
  Query:TFDQuery;
  codigo, codigoCupom:string;
begin
  Query := TConexao.GetInstance.ExecQuery(
    'SELECT FIRST ' + IntToStr(LOTE_LEITURA) +
    '       CR.CODIGO, CR.COD_CUPOM, CR.DATA_EMISSAO, CR.DATA_VENCIMENTO, ' +
    '       CR.VALOR, CR.CANCELADO, CR.COD_CLIENTE, CR.COD_CAIXA, CR.COD_VENDEDOR, ' +
    '       (SELECT FIRST 1 C.NUMERO FROM CUPOM C ' +
    '         WHERE C.CODIGO = CR.COD_CUPOM AND C.COD_CAIXA = CR.COD_CAIXA) AS NUMERO, ' +
    '       (SELECT FIRST 1 CL.CNPJCPF FROM CLIENTE CL ' +
    '         WHERE CL.CODIGO = CR.COD_CLIENTE) AS CPF_CLIENTE ' +
    '  FROM CONTAS_RECEBER CR ' +
    // COALESCE, e nao "NUVEM = 0" puro: no Firebird o ALTER TABLE ADD com
    // DEFAULT nao preenche as linhas que ja existiam - elas ficam NULL. E
    // NULL = 0 nao e verdadeiro, entao todo titulo anterior a criacao da
    // coluna ficaria invisivel para a subida, para sempre.
    ' WHERE COALESCE(CR.NUVEM, 0) = 0 ' +
    ' ORDER BY CR.DATA_EMISSAO, CR.COD_CUPOM, CR.CODIGO');
  try
    result := TObjectList<TContaReceber>.Create(true);

    while not Query.Eof do
    begin
      codigo      := Query.FieldByName('CODIGO').AsString;
      codigoCupom := Query.FieldByName('COD_CUPOM').AsString;

      result.Add(TContaReceber.Create);

      result.Last.codigo          := codigo;
      result.Last.codigo_cupom    := codigoCupom;
      result.Last.numero          := Query.FieldByName('NUMERO').AsString;
      result.Last.prestacao       := prestacaoDoCodigo(codigo, codigoCupom);
      result.Last.caixa           := Query.FieldByName('COD_CAIXA').AsString;
      result.Last.data_emissao    := Query.FieldByName('DATA_EMISSAO').AsDateTime;
      result.Last.data_vencimento := Query.FieldByName('DATA_VENCIMENTO').AsDateTime;
      result.Last.valor           := Query.FieldByName('VALOR').AsFloat;
      result.Last.codigo_cliente  := Query.FieldByName('COD_CLIENTE').AsString;
      result.Last.cpf_cliente     := Query.FieldByName('CPF_CLIENTE').AsString;
      result.Last.descricao       := '';
      result.Last.vendedor        := Query.FieldByName('COD_VENDEDOR').AsString;
      result.Last.cancelado       := Query.FieldByName('CANCELADO').AsInteger;

      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

procedure TContaReceberRetaguardaRepository.marcarEnviado(const codigo,
  codigoCupom: string);
var
  Query:TFDQuery;
begin
  Query := TConexao.GetInstance.CreateQuery;
  try
    Query.SQL.Text :=
      'UPDATE CONTAS_RECEBER SET NUVEM = 1 ' +
      ' WHERE CODIGO = :CODIGO AND COD_CUPOM = :COD_CUPOM';
    Query.ParamByName('CODIGO').AsString := codigo;
    Query.ParamByName('COD_CUPOM').AsString := codigoCupom;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

// Devolve para a fila o convenio de um periodo que ja subiu.
//
// So mexe em quem esta com NUVEM = 1: o que ainda esta pendente ja vai subir
// sozinho, e reescrever essas linhas so criaria disputa de lock com o RK_Sync
// gravando no mesmo banco.
//
// Reenviar nao duplica nada na nuvem - a rota /contaReceber faz upsert pela
// chave (tenant, loja, codigo), com os recebimentos lancados no web intactos.
function TContaReceberRetaguardaRepository.marcarPeriodoParaReenvio(dtInicio,
  dtFim: TDate): Integer;
var
  Query:TFDQuery;
begin
  garantirColunaNuvem;

  Query := TConexao.GetInstance.CreateQuery;
  try
    Query.SQL.Text :=
      'UPDATE CONTAS_RECEBER SET NUVEM = 0 ' +
      ' WHERE COALESCE(NUVEM, 0) = 1 AND DATA_EMISSAO BETWEEN :INICIO AND :FIM';
    Query.ParamByName('INICIO').AsDate := dtInicio;
    Query.ParamByName('FIM').AsDate := dtFim;
    Query.ExecSQL;
    Result := Query.RowsAffected;
  finally
    Query.Free;
  end;
end;

end.
