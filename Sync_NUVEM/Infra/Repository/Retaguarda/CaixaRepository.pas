unit CaixaRepository;

interface
uses System.Generics.Collections,CaixaModel,uConexaoRetaguarda,Firedac.comp.client;
type ICaixaRepository = interface
  ['{C1EF9691-63B2-46F5-8F06-4ED03DEF1EAC}']
  function getAll:TObjectList<TCaixaModel>;
end;

type TCaixaRepository = class(TInterfacedObject,ICaixaRepository)

  public
    function getAll: TObjectList<CaixaModel.TCaixaModel>;
end;

implementation

{ TCaixaRepository }



function TCaixaRepository.getAll: TObjectList<CaixaModel.TCaixaModel>;
var
  Query:TFdquery;
begin
try
  Query := TConexao.GetInstance.ExecQuery('select * from caixa');
  result := TObjectList<TCaixaModel>.Create(true);

  while not Query.Eof do
  begin
    result.Add(TCaixaModel.create);

    result.Last.codigo := Query.FieldByName('CODIGO').AsString;
    result.Last.nome := Query.FieldByName('NOME').AsString;
    result.Last.ip := Query.FieldByName('IP').AsString;
    Query.Next;
  end;
finally
  Query.Free;
end;
end;

end.
