unit SubgrupoRepositoryImpl;

interface

uses
  SubgrupoModel, uConexao, FireDAC.Comp.Client;

type
  ISubgrupoRepository = interface
    ['{B4D1C9B3-89A1-4D4B-9F1E-2A4B77D69E8E}']
    function Get(codigo: string;codigoGrupo:string): TSubgrupoModel;
    procedure Insert(subgrupo: TSubgrupoModel);
  end;

  TSubgrupoRepositoryFirebird = class(TInterfacedObject, ISubgrupoRepository)
  public
    function Get(codigo: string;codigogrupo:string): TSubgrupoModel;
    procedure Insert(subgrupo: TSubgrupoModel);
  end;

implementation

{ TSubgrupoRepositoryFirebird }

function TSubgrupoRepositoryFirebird.Get(codigo: string;codigogrupo:string): TSubgrupoModel;
var
  query: TFDQuery;
begin
  Result := nil;

  query := TConexao.GetInstance.CreateQuery('SELECT * FROM SUBGRUPO WHERE CODIGO = :CODIGO AND CODIGO_GRUPO = :CODIGO_GRUPO');
  query.ParamByName('CODIGO_GRUPO').AsString := CodigoGrupo;
  query.ParamByName('CODIGO').AsString := codigo;
  query.Open();

  if query.RecordCount = 0 then
    Exit;

  Result := TSubgrupoModel.Create;
  Result.codigo := query.FieldByName('CODIGO').AsString;
  result.CodigoGrupo := query.FieldByName('CODIGO_GRUPO').AsString;
  Result.descricao := query.FieldByName('SUBGRUPO').AsString;
end;

procedure TSubgrupoRepositoryFirebird.Insert(subgrupo: TSubgrupoModel);
var
  query: TFDQuery;
begin
  query := TConexao.GetInstance.CreateQuery(
    'INSERT INTO SUBGRUPO (CODIGO,CODIGO_GRUPO, SUBGRUPO) VALUES (:CODIGO, :CODIGO_GRUPO,:SUBGRUPO)'
  );
  query.Params.ParamByName('CODIGO').AsString := subgrupo.codigo;
  query.Params.ParamByName('CODIGO_GRUPO').AsString := subgrupo.CodigoGrupo;
  query.Params.ParamByName('SUBGRUPO').AsString := subgrupo.descricao;
  query.ExecSQL;
end;

end.

