unit ErroPDVRepository;

interface
uses System.SysUtils, System.Generics.Collections, System.Generics.Defaults,
     FireDAC.Comp.Client, CaixaModel, uConexaoPDV, ErroPDV;

// Le a tabela ERROS de cada PDV e marca o que ja subiu.
//
// Mesmo contrato da subida de convenio: le NUVEM = 0, envia, e so marca
// NUVEM = 1 quando a nuvem confirma - erro que falhou no envio volta no ciclo
// seguinte em vez de se perder.
type IErroPDVRepository = interface
  ['{7B3E9A15-4C62-4D08-9F71-2A6C5D3E84B0}']
  procedure garantirColunas(caixa:TCaixaModel);
  function getPendentes(caixa:TCaixaModel):TObjectList<TErroPDV>;
  procedure marcarEnviado(caixa:TCaixaModel; codigo:integer);
end;

type TErroPDVRepository = class(TInterfacedObject,IErroPDVRepository)
  private
    FColunaVerificada:TDictionary<string,Boolean>;
  public
    constructor create;
    destructor Destroy; override;
    procedure garantirColunas(caixa:TCaixaModel);
    function getPendentes(caixa:TCaixaModel):TObjectList<TErroPDV>;
    procedure marcarEnviado(caixa:TCaixaModel; codigo:integer);
end;

implementation

const
  // Um caixa com problema cronico geraria milhares de linhas; o resto sobe no
  // ciclo seguinte.
  LOTE_LEITURA = 200;

{ TErroPDVRepository }

constructor TErroPDVRepository.create;
begin
  FColunaVerificada := TDictionary<string,Boolean>.Create;
end;

destructor TErroPDVRepository.Destroy;
begin
  FColunaVerificada.Free;
  inherited;
end;

// A frota de PDVs nao atualiza toda no mesmo dia: um caixa ainda sem as colunas
// faria o SELECT estourar a cada ciclo. Idempotente e enviado uma vez por caixa
// em cada execucao do agente.
procedure TErroPDVRepository.garantirColunas(caixa: TCaixaModel);
begin
  if FColunaVerificada.ContainsKey(caixa.ip) then Exit;

  TConexaoPDV.GetInstance(caixa.ip).ExecSQL(
    'EXECUTE BLOCK AS BEGIN ' +
    '  IF (NOT EXISTS(SELECT 1 FROM RDB$RELATION_FIELDS ' +
    '                 WHERE RDB$RELATION_NAME = ''ERROS'' AND RDB$FIELD_NAME = ''NUVEM'')) THEN ' +
    '    EXECUTE STATEMENT ''ALTER TABLE ERROS ADD NUVEM INTEGER DEFAULT 0''; ' +
    '  IF (NOT EXISTS(SELECT 1 FROM RDB$RELATION_FIELDS ' +
    '                 WHERE RDB$RELATION_NAME = ''ERROS'' AND RDB$FIELD_NAME = ''ID'')) THEN ' +
    '    EXECUTE STATEMENT ''ALTER TABLE ERROS ADD ID INTEGER''; ' +
    '  IF (NOT EXISTS(SELECT 1 FROM RDB$RELATION_FIELDS ' +
    '                 WHERE RDB$RELATION_NAME = ''ERROS'' AND RDB$FIELD_NAME = ''ORIGEM'')) THEN ' +
    '    EXECUTE STATEMENT ''ALTER TABLE ERROS ADD ORIGEM VARCHAR(60)''; ' +
    '  IF (NOT EXISTS(SELECT 1 FROM RDB$RELATION_FIELDS ' +
    '                 WHERE RDB$RELATION_NAME = ''ERROS'' AND RDB$FIELD_NAME = ''COD_CAIXA'')) THEN ' +
    '    EXECUTE STATEMENT ''ALTER TABLE ERROS ADD COD_CAIXA INTEGER''; ' +
    '  IF (NOT EXISTS(SELECT 1 FROM RDB$RELATION_FIELDS ' +
    '                 WHERE RDB$RELATION_NAME = ''ERROS'' AND RDB$FIELD_NAME = ''COD_OPERADOR'')) THEN ' +
    '    EXECUTE STATEMENT ''ALTER TABLE ERROS ADD COD_OPERADOR INTEGER''; ' +
    'END');

  FColunaVerificada.Add(caixa.ip, true);
end;

function TErroPDVRepository.getPendentes(caixa: TCaixaModel): TObjectList<TErroPDV>;
var
  Query:TFDQuery;
begin
  // COALESCE porque o ALTER TABLE ADD ... DEFAULT nao preenche linha existente:
  // erro anterior a atualizacao fica com NUVEM NULL, e NULL = 0 nao e verdade.
  // Sem isso o historico do caixa nunca subiria.
  //
  // ID nulo tambem e historico (gravado antes da coluna existir) e fica de
  // fora: sem ele nao ha como marcar a linha depois do envio.
  Query := TConexaoPDV.GetInstance(caixa.ip).ExecQuery(
    'SELECT FIRST ' + IntToStr(LOTE_LEITURA) + ' ID, DATA, HORA, ERRO, ORIGEM, ' +
    '       COD_CAIXA, COD_OPERADOR ' +
    '  FROM ERROS ' +
    ' WHERE COALESCE(NUVEM, 0) = 0 AND ID IS NOT NULL ' +
    ' ORDER BY ID');
  try
    result := TObjectList<TErroPDV>.Create(true);

    while not Query.Eof do
    begin
      result.Add(TErroPDV.Create);

      result.Last.codigo   := Query.FieldByName('ID').AsInteger;
      result.Last.data     := Query.FieldByName('DATA').AsDateTime;
      result.Last.hora     := FormatDateTime('hh:nn:ss', Query.FieldByName('HORA').AsDateTime);
      result.Last.erro     := Query.FieldByName('ERRO').AsString;
      result.Last.origem   := Query.FieldByName('ORIGEM').AsString;
      result.Last.operador := Query.FieldByName('COD_OPERADOR').AsInteger;

      // O caixa gravado pode estar zerado em erro antigo; nesse caso vale o
      // caixa que esta sendo lido.
      result.Last.caixa := Query.FieldByName('COD_CAIXA').AsInteger;
      if result.Last.caixa = 0 then
        result.Last.caixa := StrToIntDef(caixa.codigo, 0);

      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

procedure TErroPDVRepository.marcarEnviado(caixa: TCaixaModel; codigo: integer);
var
  Query:TFDQuery;
begin
  Query := TConexaoPDV.GetInstance(caixa.ip).CreateQuery;
  try
    Query.SQL.Text := 'UPDATE ERROS SET NUVEM = 1 WHERE ID = :ID';
    Query.ParamByName('ID').AsInteger := codigo;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.
