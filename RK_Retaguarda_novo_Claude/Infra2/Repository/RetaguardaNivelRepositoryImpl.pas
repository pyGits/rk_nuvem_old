unit RetaguardaNivelRepositoryImpl;

interface
uses RetaguardaNivelModel,uConexao,FireDAC.Comp.Client;
type IRetaguardaNivelRepository = interface
  ['{E92A5D84-8543-4C57-9F9F-96C97B671E98}']
  function get(codigo:string):TRetaguardaNivelModel;
  procedure insert(nivel:TRetaguardaNivelModel);
end;

type TRetaguardaNivelRepositoryFirebird = class(TInterfacedObject,IRetaguardaNivelRepository)

  public
    function get(codigo: string): TRetaguardaNivelModel;
    procedure insert(nivel: TRetaguardaNivelModel);
end;

implementation

{ TRetaguardaNivelRepositoryFirebird }

function TRetaguardaNivelRepositoryFirebird.get(
  codigo: string): TRetaguardaNivelModel;
  var
    query:TFDQuery;
begin
result := nil;

query := TConexao.GetInstance.CreateQuery('SELECT * FROM RETAGUARDA_NIVEL WHERE CODIGO = :CODIGO');
query.ParamByName('CODIGO').AsString := codigo;
query.Open();


if query.RecordCount = 0 then exit;


result := TRetaguardaNivelModel.Create;
Result.codigo := query.FieldByName('CODIGO').AsString;
result.descricao := query.FieldByName('FUNCDESC').AsString;
result.categoria := query.FieldByName('FUNCCAT').AsString;
result.nivel := query.FieldByName('FUNCNIV').AsString;
end;

procedure TRetaguardaNivelRepositoryFirebird.insert(
  nivel: TRetaguardaNivelModel);
var
    query:TFDQuery;
begin
query := TConexao.GetInstance.CreateQuery('INSERT INTO RETAGUARDA_NIVEL(CODIGO,FUNCDESC,FUNCCAT,FUNCNIV,FUNCSOLIC) VALUES (:CODIGO,:FUNCDESC,:FUNCCAT,:FUNCNIV,:FUNCSOLIC)');
query.params.ParamByName('CODIGO').AsString := nivel.codigo;


query.Params.ParamByName('FUNCDESC').AsString := nivel.descricao;
query.Params.ParamByName('FUNCCAT').AsString := nivel.categoria;
query.Params.ParamByName('FUNCNIV').AsString := nivel.nivel;
query.Params.ParamByName('FUNCSOLIC').AsInteger := 0;

query.ExecSQL;
end;

end.
