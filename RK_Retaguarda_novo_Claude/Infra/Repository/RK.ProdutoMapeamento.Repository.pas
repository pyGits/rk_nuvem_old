unit RK.ProdutoMapeamento.Repository;

interface
uses System.Generics.Collections,MapeamentoProduto,Produto,RKConnection,FireDAC.Comp.Client,System.SysUtils;

type TRKProdutoMapeamento = class


  public
    procedure bulkInsert(mapeamento:TObjectList<TMapeamentoProduto>);
    function getAll:TObjectList<TMapeamentoProduto>;
    function getLastSequencial:integer;
end;

var
  RK_PRODUTO_MAPEAMENTO_REPO :TRKProdutoMapeamento;

implementation

{ TRKProdutoMapeamento }


function TRKProdutoMapeamento.getAll: TObjectList<TMapeamentoProduto>;
var
  query:TFDQuery;
  map:TMapeamentoProduto;
begin
try
result := TObjectList<TMapeamentoProduto>.create(true);
query := RKConn.GetQuery('SELECT * FROM MAPEAMENTO_PRODUTO');
query.open;
while not query.eof do
begin
  map:=TMapeamentoProduto.Create;
  map.codigo := query.FieldByName('CODIGO').AsString;
  map.codigo_externo := query.FieldByName('CODIGO_EXTERNO').AsString;
  Result.Add(map);
  query.Next;
end;
finally
  query.Free;
end;

end;

{ TRKProdutoMapeamento }

function TRKProdutoMapeamento.getLastSequencial: integer;
var
  query:TFDQuery;
begin
try
  result := 0; // Define valor padrão como 0
  query := RKConn.GetQuery('select max(codigo) as max_codigo from codigo_auxiliar');
  query.open;
  if not query.Fields[0].IsNull then  // Verifica se o resultado não é nulo
    result := query.FieldByName('max_codigo').AsInteger;
finally
  query.Free;  // Garante que a query será liberada
end;
end;

procedure TRKProdutoMapeamento.bulkInsert(mapeamento:TObjectList<TMapeamentoProduto>);
var
  i:integer;
  map:TMapeamentoProduto;
begin
if mapeamento.Count > 0 then
begin
try
  RKConn.bulkQuery := TFDQuery.Create(nil);
  RKConn.bulkQuery.Connection := RKConn.FConn;

  RKConn.bulkQuery.SQL.Text :=
    'UPDATE OR INSERT INTO MAPEAMENTO_PRODUTO (' +
    'CODIGO, CODIGO_EXTERNO ) ' +
    'VALUES (:CODIGO, :CODIGO_EXTERNO )';

  RKConn.bulkQuery.Params.ArraySize := mapeamento.Count;

  for i := 0 to RKConn.bulkQuery.Params.ArraySize-1 do
  begin
    with mapeamento[i] do
    begin
       RKConn.bulkQuery.ParamByName('CODIGO').AsStrings[i] := inttostr(i);
       RKConn.bulkQuery.ParamByName('CODIGO_EXTERNO').AsStrings[i] := mapeamento[i].codigo_externo;
    end;
  end;


  RKConn.bulkQuery.Execute(RKConn.bulkQuery.Params.ArraySize,0);

finally
  RKConn.bulkQuery.Free;
end;

end;

end;

initialization
  RK_PRODUTO_MAPEAMENTO_REPO := TRKProdutoMapeamento.Create;


end.
