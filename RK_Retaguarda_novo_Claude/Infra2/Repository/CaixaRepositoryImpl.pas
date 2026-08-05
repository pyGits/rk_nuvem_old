unit CaixaRepositoryImpl;

interface
uses System.Generics.Collections,CaixaModel,uConexaoPDV,FireDAC.Comp.Client,uConexao;
type ICaixaRepository = interface
  ['{DF76491A-519F-481F-AF17-EF001D9ECE3C}']
  function getAll:TObjectList<TCaixaModel>;
end;

type TCaixaRepositoryFirebird = class(TInterfacedObject,ICaixaRepository)

  public
    function getAll: TObjectList<TCaixaModel>;
end;

implementation

{ TCaixaRepositoryFirebird }

function TCaixaRepositoryFirebird.getAll: TObjectList<TCaixaModel>;
var
  Query:TFdQuery;
begin
Query := TConexao.GetInstance.ExecQuery('SELECT * FROM CAIXA');

result := TObjectList<TCaixaModel>.Create(true);
while not Query.eof do
begin
  RESULT.Add(TCaixaModel.create);
  result.Last.codigo := Query.FieldByName('CODIGO').AsString;
  result.Last.nome := Query.FieldByName('NOME').AsString;
  result.Last.ip := Query.FieldByName('IP').AsString;
  Query.Next;
end;

end;

end.
