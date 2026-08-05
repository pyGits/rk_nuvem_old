unit CodigoAuxiliarRepositoryImpl;

interface
uses CodigoAuxiliarModel,System.SysUtils,Helpers,FireDAC.Comp.Client,uConexaoSyspdv,uConexaoSyspdvSQL,uConexao;
type ICodigoAuxiliarRepository = interface
  ['{89048FB5-7F22-4EE5-9134-76DF0D3C3FAD}']
  function getByCodigoAuxiliar(codigo:string):TCodigoAuxiliarModel;
end;

type TCodigoAuxiliarRepositoryFirebird = class(TInterfacedObject,ICodigoAuxiliarRepository)
  private
  query:TFDQuery;

  public
    function getByCodigoAuxiliar(codigo: string): TCodigoAuxiliarModel;
end;

type TCodigoAuxiliarRepositorySyspdv = class(TInterfacedObject,ICodigoAuxiliarRepository)
  private
    query:TFDQuery;
    FConexao:TConexaoSyspdv;
  public
    constructor create(Conexao:TConexaoSyspdv);
    function getByCodigoAuxiliar(codigo: string): TCodigoAuxiliarModel;
end;

type TCodigoAuxiliarRepositorySyspdvSQL = class(TInterfacedObject,ICodigoAuxiliarRepository)
  private
    query:TFDQuery;
    FConexao:TConexaoSyspdvSQL;
  public
    constructor create(Conexao:TConexaoSyspdvSQL);
    function getByCodigoAuxiliar(codigo: string): TCodigoAuxiliarModel;
end;

implementation

{ TCodigoAuxiliarRepositoryFirebird }

function TCodigoAuxiliarRepositoryFirebird.getByCodigoAuxiliar(
  codigo: string): TCodigoAuxiliarModel;
  var
    query:TFDQuery;
begin
result := nil;
query:= TConexao.GetInstance.CreateQuery('SELECT * FROM CODIGO_AUXILIAR WHERE CODIGO_AUXILIAR = :CODIGO_AUXILIAR ');
query.Params.ParamByName('CODIGO_AUXILIAR').AsString := codigo.ZeroEsquerda(14);
query.open;
if query.RecordCount = 0 then Exit;

result.codigo := query.FieldByName('CODIGO').AsString;
Result.codigo_barras := query.FieldByName('CODIGO_BARRAS').AsString;
result.codigo_auxiliar := query.FieldByName('CODIGO_AUXILIAR').AsString;
end;

{ TCodigoAuxiliarRepositorySyspdv }

constructor TCodigoAuxiliarRepositorySyspdv.create(Conexao: TConexaoSyspdv);
begin
FConexao := Conexao;
end;

function TCodigoAuxiliarRepositorySyspdv.getByCodigoAuxiliar(
  codigo: string): TCodigoAuxiliarModel;
  var
    query:TFDQuery;
begin
result := nil;
query := FConexao.CreateQuery('select * from produtoaux where PROCODAUX = :PROCODAUX');
query.Params.ParamByName('PROCODAUX').AsString := codigo.ZeroEsquerda(14);
query.Open();


if query.RecordCount = 0 then exit;

result := TCodigoAuxiliarModel.Create;
Result.codigo_barras := query.FieldByName('PROCOD').AsString;
Result.codigo_auxiliar :=  query.FieldByName('PROCODAUX').AsString;
end;

{ TCodigoAuxiliarRepositorySyspdvSQL }

constructor TCodigoAuxiliarRepositorySyspdvSQL.create(Conexao: TConexaoSyspdvSQL);
begin
FConexao := Conexao;
end;

function TCodigoAuxiliarRepositorySyspdvSQL.getByCodigoAuxiliar(
  codigo: string): TCodigoAuxiliarModel;
  var
    query:TFDQuery;
begin
result := nil;
query := FConexao.CreateQuery('select * from produtoaux where PROCODAUX = :PROCODAUX');
query.Params.ParamByName('PROCODAUX').AsString := codigo.ZeroEsquerda(14);
query.Open();


if query.RecordCount = 0 then exit;

result := TCodigoAuxiliarModel.Create;
Result.codigo_barras := query.FieldByName('PROCOD').AsString;
Result.codigo_auxiliar :=  query.FieldByName('PROCODAUX').AsString;
end;

end.
