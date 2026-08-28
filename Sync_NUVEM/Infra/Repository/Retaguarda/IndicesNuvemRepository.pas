unit IndicesNuvemRepository;

interface
uses System.SysUtils, System.Classes, uConexaoRetaguarda;

// A subida de venda le "WHERE NUVEM = 0" em sete tabelas a cada ciclo do
// timer. Sem indice isso e uma varredura completa de CUPOM, CUPOM_ITEM e
// companhia a cada poucos segundos - e em base de cliente com anos de
// movimento essa varredura sozinha ja custa mais que o envio.
//
// O indice e composto (NUVEM + as colunas do ORDER BY) de proposito: assim o
// Firebird resolve o filtro e a ordenacao pelo mesmo indice e o SELECT FIRST
// para de ler assim que completa o lote, em vez de ordenar o backlog inteiro
// para descartar quase tudo.
//
// O PDV ja faz o mesmo em CUPOM_CREDIARIO (Migrations.inc); aqui a criacao
// fica com o proprio agente porque e ele quem depende dela, e assim nao e
// preciso esperar o cliente atualizar a retaguarda.
type IIndicesNuvemRepository = interface
  ['{2F5B8C41-9A73-4D26-B0E8-7C3D14A9F582}']
  procedure garantirIndices;
  // Se ainda falta algum, vale chamar garantirIndices de novo mais tarde.
  function faltamIndices: Boolean;
end;

type TIndicesNuvemRepository = class(TInterfacedObject,IIndicesNuvemRepository)
  private
    // 'TABELA;INDICE;COLUNAS' dos que ainda nao foram criados. Some da lista
    // quando o banco confirma, entao a retentativa nunca repete trabalho.
    FPendentes:TStringList;
    // Indices cuja falha ja foi registrada. Sem isso a retentativa encheria o
    // arquivo de log com a mesma linha de hora em hora.
    FFalhaAvisada:TStringList;
    FMontado:Boolean;
    // So a primeira passada fala na tela: nas seguintes o agente esta no meio
    // do expediente e o memo e do usuario, nao do diagnostico.
    FPrimeiraPassada:Boolean;
    procedure montarPendentes;
    function criarIndice(const tabela, indice, colunas:string):Boolean;
  public
    destructor Destroy; override;
    procedure garantirIndices;
    function faltamIndices: Boolean;
end;

implementation

uses uLogErro;

{ TIndicesNuvemRepository }

destructor TIndicesNuvemRepository.Destroy;
begin
  FPendentes.Free;
  FFalhaAvisada.Free;
  inherited;
end;

procedure TIndicesNuvemRepository.montarPendentes;
begin
  if FMontado then Exit;
  FMontado := true;
  FPrimeiraPassada := true;

  FPendentes := TStringList.Create;
  FFalhaAvisada := TStringList.Create;

  FPendentes.Add('CUPOM;IDX_CUPOM_NUVEM;NUVEM, COD_CAIXA, CODIGO');
  FPendentes.Add('CUPOM_ITEM;IDX_CUPOM_ITEM_NUVEM;NUVEM, COD_CAIXA, CODIGO');
  FPendentes.Add('CUPOM_FORMA;IDX_CUPOM_FORMA_NUVEM;NUVEM, COD_CAIXA, CODIGO');
  FPendentes.Add('ESTOQUE_MOVIMENTACAO;IDX_ESTOQUE_MOV_NUVEM;NUVEM, COD_CUPOM, ITEM');
  FPendentes.Add('NAO_FISCAL;IDX_NAO_FISCAL_NUVEM;NUVEM, COD_CAIXA, CODIGO');
  FPendentes.Add('FECHAMENTO;IDX_FECHAMENTO_NUVEM;NUVEM, COD_CAIXA, CODIGO');
  FPendentes.Add('FECHAMENTO_FINALIZADORA;IDX_FECH_FIN_NUVEM;NUVEM, COD_CAIXA, ID_FECHAMENTO');
end;

function TIndicesNuvemRepository.faltamIndices: Boolean;
begin
  montarPendentes;
  Result := FPendentes.Count > 0;
end;

// Devolve true quando nao ha mais nada a fazer com este indice: foi criado
// agora, ja existia, ou a tabela nem tem a coluna NUVEM. False significa
// "tente de novo mais tarde".
//
// Idempotente: nao roda DDL se o indice ja existir, e nao tenta criar nada em
// tabela que ainda nao tenha a coluna NUVEM.
function TIndicesNuvemRepository.criarIndice(const tabela, indice,
  colunas: string): Boolean;
begin
  // Numa base com anos de movimento o CREATE INDEX leva minutos, e roda na
  // thread principal: sem esse aviso a janela fica parada e parece travada.
  if FPrimeiraPassada then
  begin
    uLogErro.Progresso(Format('   indice de %s...', [tabela]));
    uLogErro.Atividade(Format('Verificando indice de %s...', [tabela]));
  end;

  try
    TConexao.GetInstance.ExecSQL(
      'EXECUTE BLOCK AS BEGIN ' +
      '  IF (EXISTS(SELECT 1 FROM RDB$RELATION_FIELDS ' +
      '             WHERE RDB$RELATION_NAME = ''' + tabela + ''' ' +
      '               AND RDB$FIELD_NAME = ''NUVEM'') ' +
      '      AND NOT EXISTS(SELECT 1 FROM RDB$INDICES ' +
      '                     WHERE RDB$INDEX_NAME = ''' + indice + ''')) THEN ' +
      '    EXECUTE STATEMENT ''CREATE INDEX ' + indice + ' ON ' + tabela +
      ' (' + colunas + ')''; ' +
      'END');

    // So avisa quando o indice vinha falhando: no caso normal ele ja existe e
    // nao ha novidade nenhuma para contar.
    if FFalhaAvisada.IndexOf(indice) >= 0 then
    begin
      FFalhaAvisada.Delete(FFalhaAvisada.IndexOf(indice));
      uLogErro.Progresso(Format('Indice %s criado.', [indice]));
      uLogErro.LogErro('INDICE_NUVEM',
        Format('%s criado em %s apos as tentativas anteriores', [indice, tabela]));
    end;

    Result := true;
  except
  on E:Exception do
  begin
    Result := false;

    // CREATE INDEX precisa de acesso exclusivo a tabela. A CUPOM fica em uso
    // pelo RK_Sync e pelos PDVs o expediente inteiro, entao a tentativa unica
    // da inicializacao falhava todo dia com "object CUPOM is in use" e o
    // indice nunca saia. Aqui a falha nao e o fim: o indice continua na lista
    // e o agente tenta de novo, ate pegar a base parada.
    //
    // Uma linha por indice, e nao uma por tentativa, senao a retentativa
    // periodica enche o arquivo de log.
    if FFalhaAvisada.IndexOf(indice) < 0 then
    begin
      FFalhaAvisada.Add(indice);
      uLogErro.LogErro('INDICE_NUVEM',
        Format('Nao foi possivel criar %s em %s, vai continuar tentando | %s: %s',
          [indice, tabela, E.ClassName, E.Message]));
    end;
  end;
  end;
end;

procedure TIndicesNuvemRepository.garantirIndices;
var
  i:integer;
  partes:TStringList;
begin
  montarPendentes;
  if FPendentes.Count = 0 then Exit;

  if FPrimeiraPassada then
    uLogErro.Progresso('Verificando indices de subida (pode demorar na primeira vez)...');

  partes := TStringList.Create;
  try
    partes.Delimiter := ';';
    partes.StrictDelimiter := true;

    // De tras para frente porque a lista encolhe durante o laco.
    for i := FPendentes.Count - 1 downto 0 do
    begin
      partes.DelimitedText := FPendentes[i];
      if partes.Count < 3 then Continue;

      if criarIndice(partes[0], partes[1], partes[2]) then
        FPendentes.Delete(i);
    end;
  finally
    partes.Free;
  end;

  if FPrimeiraPassada then
  begin
    uLogErro.Progresso('Indices de subida verificados.');
    uLogErro.Atividade('');
    FPrimeiraPassada := false;
  end;
end;

end.
