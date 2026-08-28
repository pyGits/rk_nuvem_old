unit ContaReceberPDVRepository;

interface
uses System.Generics.Collections, System.SysUtils, FireDAC.Comp.Client,
     uConexaoPDV, CaixaModel, ContaReceber;

// Le os titulos de convenio direto do banco de cada PDV. E o unico caminho que
// existe: CUPOM_CREDIARIO nao passa pela retaguarda antes de subir, e o cupom
// que ja sobe (CUPOM/CUPOM_FORMA) nao carrega cliente, vencimento nem parcela.
type IContaReceberPDVRepository = interface
  ['{6A2D77B1-4E0B-4C1E-9D2F-1B6E5C8A47D3}']
  function getPendentes(caixa:TCaixaModel):TObjectList<TContaReceber>;
  procedure marcarEnviado(caixa:TCaixaModel; const codigo:string);
  procedure garantirColunaNuvem(caixa:TCaixaModel);
end;

type TContaReceberPDVRepository = class(TInterfacedObject,IContaReceberPDVRepository)
  private
    // caixas ja verificados nesta execucao, para nao repetir a checagem da
    // coluna a cada ciclo do timer
    FColunaVerificada:TDictionary<string,Boolean>;
  public
    constructor create;
    destructor Destroy; override;
    function getPendentes(caixa:TCaixaModel):TObjectList<TContaReceber>;
    procedure marcarEnviado(caixa:TCaixaModel; const codigo:string);
    procedure garantirColunaNuvem(caixa:TCaixaModel);
end;

implementation

{ TContaReceberPDVRepository }

constructor TContaReceberPDVRepository.create;
begin
  FColunaVerificada := TDictionary<string,Boolean>.Create;
end;

destructor TContaReceberPDVRepository.Destroy;
begin
  FColunaVerificada.Free;
  inherited;
end;

// A frota de PDVs nao atualiza toda no mesmo dia. Sem isso, um caixa ainda sem
// a coluna faria o SELECT estourar "Column unknown: NUVEM" a cada ciclo. O
// bloco e idempotente: nao roda DDL se a coluna ja existir, e so e enviado uma
// vez por caixa em cada execucao do agente.
procedure TContaReceberPDVRepository.garantirColunaNuvem(caixa: TCaixaModel);
begin
  if FColunaVerificada.ContainsKey(caixa.ip) then Exit;

  TConexaoPDV.GetInstance(caixa.ip).ExecSQL(
    'EXECUTE BLOCK AS BEGIN ' +
    '  IF (NOT EXISTS(SELECT 1 FROM RDB$RELATION_FIELDS ' +
    '                 WHERE RDB$RELATION_NAME = ''CUPOM_CREDIARIO'' ' +
    '                   AND RDB$FIELD_NAME = ''NUVEM'')) THEN ' +
    '    EXECUTE STATEMENT ''ALTER TABLE CUPOM_CREDIARIO ADD NUVEM INTEGER DEFAULT 0''; ' +
    'END');

  FColunaVerificada.Add(caixa.ip, true);
end;

// Caixa, numero da venda e vendedor ficam no CUPOM; o CPF vem do cadastro local
// de clientes, para a nuvem casar o titulo mesmo quando o codigo do cliente so
// existe na retaguarda.
function TContaReceberPDVRepository.getPendentes(
  caixa: TCaixaModel): TObjectList<TContaReceber>;
var
  Query:TFDQuery;
begin
  Query := TConexaoPDV.GetInstance(caixa.ip).ExecQuery(
    'SELECT CR.CODIGO, CR.COD_CUPOM, CR.PRESTACAO, CR.DATA, CR.VENCIMENTO, ' +
    '       CR.VALOR, CR.DESCRICAO, CR.CANCELADO, CR.COD_CLIENTE, ' +
    '       C.NUMERO, C.COD_CAIXA, C.COD_VENDEDOR, CL.CPF AS CPF_CLIENTE ' +
    '  FROM CUPOM_CREDIARIO CR ' +
    '  LEFT JOIN CUPOM   C  ON C.CODIGO  = CR.COD_CUPOM ' +
    '  LEFT JOIN CLIENTE CL ON CL.CODIGO = CR.COD_CLIENTE ' +
    // COALESCE, e nao "NUVEM = 0" puro: no Firebird o ALTER TABLE ADD com
    // DEFAULT nao preenche as linhas que ja existiam - elas ficam NULL. E
    // NULL = 0 nao e verdadeiro, entao todo titulo de convenio anterior a
    // criacao da coluna ficava invisivel para a subida, para sempre.
    ' WHERE COALESCE(CR.NUVEM, 0) = 0 ' +
    ' ORDER BY CR.DATA, CR.COD_CUPOM, CR.PRESTACAO');
  try
    result := TObjectList<TContaReceber>.Create(true);

    while not Query.Eof do
    begin
      result.Add(TContaReceber.Create);

      result.Last.codigo          := Query.FieldByName('CODIGO').AsString;
      result.Last.codigo_cupom    := Query.FieldByName('COD_CUPOM').AsString;
      result.Last.numero          := Query.FieldByName('NUMERO').AsString;
      result.Last.prestacao       := Query.FieldByName('PRESTACAO').AsInteger;
      result.Last.caixa           := Query.FieldByName('COD_CAIXA').AsString;
      result.Last.data_emissao    := Query.FieldByName('DATA').AsDateTime;
      result.Last.data_vencimento := Query.FieldByName('VENCIMENTO').AsDateTime;
      result.Last.valor           := Query.FieldByName('VALOR').AsFloat;
      result.Last.codigo_cliente  := Query.FieldByName('COD_CLIENTE').AsString;
      result.Last.cpf_cliente     := Query.FieldByName('CPF_CLIENTE').AsString;
      result.Last.descricao       := Query.FieldByName('DESCRICAO').AsString;
      result.Last.vendedor        := Query.FieldByName('COD_VENDEDOR').AsString;
      result.Last.cancelado       := Query.FieldByName('CANCELADO').AsInteger;

      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

// CODIGO e a PK de CUPOM_CREDIARIO, entao o WHERE nao precisa do cupom.
procedure TContaReceberPDVRepository.marcarEnviado(caixa: TCaixaModel;
  const codigo: string);
var
  Query:TFDQuery;
begin
  Query := TConexaoPDV.GetInstance(caixa.ip).CreateQuery;
  try
    Query.SQL.Text := 'UPDATE CUPOM_CREDIARIO SET NUVEM = 1 WHERE CODIGO = :CODIGO';
    Query.ParamByName('CODIGO').AsString := codigo;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.
