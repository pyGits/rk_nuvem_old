unit RK.CodigoAuxiliar.Repository;

interface
uses CodigoAuxiliar,System.Generics.Collections,RKConnection,System.SysUtils,FireDAC.Comp.Client;

type TCodigoAuxiliarRepository =class

  procedure bulkInsert(codigoAuxiliarList:TList<TCodigoAuxiliar>);
  procedure deleteAll;

end;
var
  RK_CODIGO_AUXILIAR_REPO:TCodigoAuxiliarRepository;

implementation


{ TCodigoAuxiliarRepository }

procedure TCodigoAuxiliarRepository.bulkInsert(codigoAuxiliarList: TList<TCodigoAuxiliar>);
var
i:integer;
begin
if codigoAuxiliarList.Count = 0 then exit;

RKConn.bulkQuery := TFDQuery.Create(nil);
RKConn.bulkQuery.Connection := RKConn.FConn;


RKConn.bulkQuery.SQL.Text :=
  'UPDATE OR INSERT INTO CODIGO_AUXILIAR (' +
  'CODIGO, CODIGO_BARRAS, CODIGO_AUXILIAR) ' +
  'VALUES (:CODIGO, :CODIGO_BARRAS, :CODIGO_AUXILIAR)';

RKConn.bulkQuery.Params.ArraySize := codigoAuxiliarList.Count;
//
for i := 0 to RKConn.bulkQuery.Params.ArraySize-1 do
begin
with codigoAuxiliarList[i] do
begin
   RKConn.bulkQuery.ParamByName('CODIGO').AsStrings[i] := Codigo;
   RKConn.bulkQuery.ParamByName('CODIGO_BARRAS').AsStrings[i] := codigo_barras;
   RKConn.bulkQuery.ParamByName('CODIGO_AUXILIAR').AsStrings[i] := codigo_auxiliar;
end;


end;
try
RKConn.bulkQuery.Execute(RKConn.bulkQuery.Params.ArraySize,0);
finally
  RKConn.bulkQuery.Params.Clear;
  RKConn.bulkQuery.Free;
end;
end;



procedure TCodigoAuxiliarRepository.deleteAll;
begin
RKConn.UpdateQuery('delete from CODIGO_AUXILIAR');
end;

initialization
  RK_CODIGO_AUXILIAR_REPO := TCodigoAuxiliarRepository.Create;
end.
