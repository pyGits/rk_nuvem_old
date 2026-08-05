unit Syspdv.CodigoAuxiliar.Repository;


interface
uses CodigoAuxiliar,System.Generics.Collections,SyspdvConnection,FireDAC.Comp.Client,ProdutoSyspdvAdapter,System.SysUtils;

type TCodigoAuxiliarSyspdvRepository = class
  public
    function getAll:TObjectList<TCodigoAuxiliar>;
end;

type TCodigoAuxiliarSQLSyspdvRepository = class
  public
    function getAll:TObjectList<TCodigoAuxiliar>;
end;

var
  SYSPDV_CODIGO_AUXILIAR_REPO:TCodigoAuxiliarSyspdvRepository;
  SYSPDV_SQL_CODIGO_AUXILIAR_REPO:TCodigoAuxiliarSQLSyspdvRepository;

implementation

{ TProdutoSyspdvRepository }

function TCodigoAuxiliarSyspdvRepository.getAll: TObjectList<TCodigoAuxiliar>;
var
  query:TFDQuery;
  codigoaux:TCodigoAuxiliar;

begin
try
result := TObjectList<TCodigoAuxiliar>.create(true);
query := SyspdvConn.ExecuteQuery('select * from PRODUTOAUX');
while not query.Eof do
begin
  codigoaux := TCodigoAuxiliar.Create;
  codigoaux.codigo := inttostr(query.RecNo);
  codigoaux.codigo_barras := query.FieldByName('PROCOD').AsString;
  codigoaux.codigo_auxiliar := query.FieldByName('PROCODAUX').AsString;
  result.Add(codigoaux);
  query.Next;
end;
finally
  query.Free;
end;

end;


{ TCodigoAuxiliarSQLSyspdvRepository }

function TCodigoAuxiliarSQLSyspdvRepository.getAll: TObjectList<TCodigoAuxiliar>;
var
  query:TFDQuery;
  codigoaux:TCodigoAuxiliar;
begin
try
result := TObjectList<TCodigoAuxiliar>.create(true);
query := SyspdvConnSQL.ExecuteQuery('select * from PRODUTOAUX');
while not query.Eof do
begin
  codigoaux := TCodigoAuxiliar.Create;
  codigoaux.codigo := inttostr(query.RecNo);
  codigoaux.codigo_barras := query.FieldByName('PROCOD').AsString;
  codigoaux.codigo_auxiliar := query.FieldByName('PROCODAUX').AsString;
  result.Add(codigoaux);
  query.Next;
end;
finally
  query.Free;
end;
end;

initialization
SYSPDV_CODIGO_AUXILIAR_REPO := TCodigoAuxiliarSyspdvRepository.Create;
SYSPDV_SQL_CODIGO_AUXILIAR_REPO := TCodigoAuxiliarSQLSyspdvRepository.Create;
end.
