unit GrupoRepositoryImpl;

interface
uses GrupoModel,uConexao,FireDAC.Comp.Client,system.Generics.collections;
type IGrupoRepository = interface
  ['{4A2876E5-D9ED-44FB-9559-85073BCBB68A}']
  function get(codigo:string):TGrupoModel;
  function getAll:TObjectList<TGrupoModel>;
  procedure insert(grupo:TGrupoModel);
end;

type TGrupoRepositoryFirebird = class(TInterfacedObject,IGrupoRepository)
  public
    function getAll:TObjectList<TGrupoModel>;
    function get(codigo: string): TGrupoModel;
    procedure insert(grupo: TGrupoModel);
end;

implementation

{ TGrupoRepositoryFirebird }

function TGrupoRepositoryFirebird.get(codigo: string): TGrupoModel;
  var
    query:TFDQuery;
begin
result := nil;

query := TConexao.GetInstance.CreateQuery('SELECT * FROM GRUPO WHERE CODIGO = :CODIGO');
query.ParamByName('CODIGO').AsString := codigo;
query.Open();

if query.RecordCount = 0 then exit;

result := TGrupoModel.Create;
Result.codigo := query.FieldByName('CODIGO').AsString;
result.descricao := query.FieldByName('GRUPO').AsString;
end;

function TGrupoRepositoryFirebird.getAll: TObjectList<TGrupoModel>;
var
 Query:TFDQuery;
begin
  try
    Query := TConexao.GetInstance.ExecQuery('SELECT * FROM GRUPO order by 1 asc');
    result := TObjectList<TGrupoModel>.Create(true);

    while not Query.Eof do
    begin
      Result.Add(TGrupoModel.create);
      result.Last.codigo := Query.FieldByName('CODIGO').AsString;
      result.Last.descricao := Query.FieldByName('GRUPO').AsString;
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

procedure TGrupoRepositoryFirebird.insert(grupo: TGrupoModel);
var
    query:TFDQuery;
begin
query := TConexao.GetInstance.CreateQuery('INSERT INTO GRUPO(CODIGO,GRUPO)VALUES (:CODIGO,:GRUPO)');
query.params.ParamByName('CODIGO').AsString := grupo.codigo;
query.Params.ParamByName('GRUPO').AsString := grupo.descricao;
query.ExecSQL;
end;

end.
