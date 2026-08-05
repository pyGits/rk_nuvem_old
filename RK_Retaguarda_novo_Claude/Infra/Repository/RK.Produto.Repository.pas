unit RK.Produto.Repository;

interface
uses Produto,System.Generics.Collections,RKConnection,System.SysUtils,FireDAC.Comp.Client,Produto.RK.Adapter,CodigoAuxiliar;

type TProdutoRepository =class

  procedure bulkInsert(produtoList:TObjectList<TProduto>);
  procedure bulkUpdate(produtoList:TObjectList<TProduto>);
  procedure deleteAll;
  function getByCodigoBarras(codigo:string):TProduto;
  function getByCodigoAuxiliar(codigo:string):TProduto;
  function getAll:TObjectList<TProduto>;

end;
var
  RK_PRODUTO_REPO:TProdutoRepository;


implementation


{ TProdutoRepository }

procedure TProdutoRepository.bulkInsert(produtoList: TObjectList<TProduto>);
var
i:integer;
begin
if produtoList.Count <= 0 then exit;

RKConn.bulkQuery := TFDQuery.Create(nil);
RKConn.bulkQuery.Connection := RKConn.FConn;


RKConn.bulkQuery.SQL.Text :=
  'UPDATE OR INSERT INTO PRODUTO (' +
  'CODIGO, CODIGO_BARRAS, DESCRICAO, GRUPO, SUBGRUPO, FORNECEDOR, TRIBUTACAO, NCM, CEST, VALIDADE, ' +
  'BALANCA, FRACIONADO, CUSTO, PRECO, MARGEM, ESTOQUE, UNIDADE, INATIVO, DIVERSOS, DATA_CADASTRO, ' +
  'DATA_ALTERADO, PENDENTE, ESTOQUE_MINIMO, ESTOQUE_MAXIMO, OBSERVACAO,PRECO2,PRECO2_QTD,PRECO3,PRECO3_QTD) ' +
  'VALUES (' +
  ':CODIGO, :CODIGO_BARRAS, :DESCRICAO, :GRUPO, :SUBGRUPO, :FORNECEDOR, :TRIBUTACAO, :NCM, :CEST, :VALIDADE, ' +
  ':BALANCA, :FRACIONADO, :CUSTO, :PRECO, :MARGEM, :ESTOQUE, :UNIDADE, :INATIVO, :DIVERSOS, :DATA_CADASTRO, ' +
  ':DATA_ALTERADO, :PENDENTE, :ESTOQUE_MINIMO, :ESTOQUE_MAXIMO, :OBSERVACAO,:PRECO2,:PRECO2_QTD,:PRECO3,:PRECO3_QTD)';

RKConn.bulkQuery.Params.ArraySize := produtoList.Count;
//
for i := 0 to RKConn.bulkQuery.Params.ArraySize-1 do
begin
with produtoList[i] do
begin
   RKConn.bulkQuery.ParamByName('CODIGO').AsStrings[i] := Codigo;
   RKConn.bulkQuery.ParamByName('CODIGO_BARRAS').AsStrings[i] := CodigoBarras;
   RKConn.bulkQuery.ParamByName('DESCRICAO').AsStrings[i] := Descricao;
   RKConn.bulkQuery.ParamByName('GRUPO').AsStrings[i] := Grupo;
   RKConn.bulkQuery.ParamByName('SUBGRUPO').AsStrings[i] := Subgrupo;
   RKConn.bulkQuery.ParamByName('FORNECEDOR').AsStrings[i] := Fornecedor;
   RKConn.bulkQuery.ParamByName('Tributacao').AsStrings[i] := Tributacao;
   RKConn.bulkQuery.ParamByName('NCM').AsStrings[i] := NCM;
   RKConn.bulkQuery.ParamByName('CEST').AsStrings[i] := CEST;
   RKConn.bulkQuery.ParamByName('Validade').AsStrings[i] := Validade;//
   RKConn.bulkQuery.ParamByName('BALANCA').AsIntegers[i] := getBalanca;
   RKConn.bulkQuery.ParamByName('Fracionado').AsIntegers[i] := getFracionado;
   RKConn.bulkQuery.ParamByName('INATIVO').AsIntegers[i] := getInativo;
   RKConn.bulkQuery.ParamByName('DIVERSOS').AsIntegers[i] := getDiversos;
   RKConn.bulkQuery.ParamByName('CUSTO').AsFloats[i] := Custo;
   RKConn.bulkQuery.ParamByName('PRECO').AsFloats[i] := Preco;
   RKConn.bulkQuery.ParamByName('MARGEM').AsFloats[i] := Margem;
   RKConn.bulkQuery.ParamByName('ESTOQUE').AsFloats[i] := Estoque;
   RKConn.bulkQuery.ParamByName('Unidade').AsStrings[i] := Unidade;
   RKConn.bulkQuery.ParamByName('DATA_ALTERADO').asDates[i] := date;
   RKConn.bulkQuery.ParamByName('DATA_CADASTRO').asDates[i] := date;
   RKConn.bulkQuery.ParamByName('PENDENTE').AsIntegers[i] := 1;
   RKConn.bulkQuery.ParamByName('OBSERVACAO').AsStrings[i] := observacao;

   RKConn.bulkQuery.ParamByName('PRECO2').AsFloats[i] := Preco2;
   RKConn.bulkQuery.ParamByName('PRECO2_QTD').AsFloats[i] := QtdMinPreco2;
   RKConn.bulkQuery.ParamByName('PRECO3').AsFloats[i] := Preco3;
   RKConn.bulkQuery.ParamByName('PRECO3_QTD').AsFloats[i] := QtdMinPreco3;
//
end;


end;
try
RKConn.bulkQuery.Execute(RKConn.bulkQuery.Params.ArraySize,0);
finally
  RKConn.bulkQuery.Params.Clear;
  RKConn.bulkQuery.Free;
end;
end;



procedure TProdutoRepository.bulkUpdate(produtoList: TObjectList<TProduto>);
var
  i: Integer;
begin
  RKConn.bulkQuery.SQL.Text :=
    'UPDATE PRODUTO SET ' +
    'CODIGO_BARRAS = :CODIGO_BARRAS, ' +
    'DESCRICAO = :DESCRICAO, ' +
    'GRUPO = :GRUPO, ' +
    'SUBGRUPO = :SUBGRUPO, ' +
    'FORNECEDOR = :FORNECEDOR, ' +
    'TRIBUTACAO = :TRIBUTACAO, ' +
    'NCM = :NCM, ' +
    'CEST = :CEST, ' +
    'VALIDADE = :VALIDADE, ' +
    'BALANCA = :BALANCA, ' +
    'FRACIONADO = :FRACIONADO, ' +
    'CUSTO = :CUSTO, ' +
    'PRECO = :PRECO, ' +
    'MARGEM = :MARGEM, ' +
    'ESTOQUE = :ESTOQUE, ' +
    'UNIDADE = :UNIDADE, ' +
    'INATIVO = :INATIVO, ' +
    'DIVERSOS = :DIVERSOS, ' +
    'DATA_CADASTRO = :DATA_CADASTRO, ' +
    'DATA_ALTERADO = :DATA_ALTERADO, ' +
    'PENDENTE = :PENDENTE, ' +
    'ESTOQUE_MINIMO = :ESTOQUE_MINIMO, ' +
    'ESTOQUE_MAXIMO = :ESTOQUE_MAXIMO, ' +
    'OBSERVACAO = :OBSERVACAO ' +
    'WHERE CODIGO_BARRAS = :CODIGO_BARRAS';

  RKConn.bulkQuery.Params.ArraySize := produtoList.Count;

  for i := 0 to RKConn.bulkQuery.Params.ArraySize - 1 do
  begin
    with produtoList[i] do
    begin
      RKConn.bulkQuery.ParamByName('CODIGO_BARRAS').AsStrings[i] := CodigoBarras;
      RKConn.bulkQuery.ParamByName('DESCRICAO').AsStrings[i] := Descricao;
      RKConn.bulkQuery.ParamByName('GRUPO').AsStrings[i] := Grupo;
      RKConn.bulkQuery.ParamByName('SUBGRUPO').AsStrings[i] := Subgrupo;
      RKConn.bulkQuery.ParamByName('FORNECEDOR').AsStrings[i] := Fornecedor;
      RKConn.bulkQuery.ParamByName('TRIBUTACAO').AsStrings[i] := Tributacao;
      RKConn.bulkQuery.ParamByName('NCM').AsStrings[i] := NCM;
      RKConn.bulkQuery.ParamByName('CEST').AsStrings[i] := CEST;
      RKConn.bulkQuery.ParamByName('VALIDADE').AsStrings[i] := Validade;
      RKConn.bulkQuery.ParamByName('BALANCA').AsIntegers[i] := getBalanca;
      RKConn.bulkQuery.ParamByName('FRACIONADO').AsIntegers[i] := getFracionado;
      RKConn.bulkQuery.ParamByName('INATIVO').AsIntegers[i] := getInativo;
      RKConn.bulkQuery.ParamByName('DIVERSOS').AsIntegers[i] := getDiversos;
      RKConn.bulkQuery.ParamByName('CUSTO').AsFloats[i] := Custo;
      RKConn.bulkQuery.ParamByName('PRECO').AsFloats[i] := Preco;
      RKConn.bulkQuery.ParamByName('MARGEM').AsFloats[i] := Margem;
      RKConn.bulkQuery.ParamByName('ESTOQUE').AsFloats[i] := Estoque;
      RKConn.bulkQuery.ParamByName('UNIDADE').AsStrings[i] := Unidade;
      RKConn.bulkQuery.ParamByName('DATA_ALTERADO').AsDates[i] := date;
      RKConn.bulkQuery.ParamByName('DATA_CADASTRO').AsDates[i] := date;
      RKConn.bulkQuery.ParamByName('PENDENTE').AsIntegers[i] := 1;
      RKConn.bulkQuery.ParamByName('OBSERVACAO').AsStrings[i] := observacao;
    end;
  end;

  RKConn.bulkQuery.Execute(RKConn.bulkQuery.Params.ArraySize, 0);
end;


procedure TProdutoRepository.deleteAll;
begin
RKConn.UpdateQuery('delete from produto');
end;

function TProdutoRepository.getAll: TObjectList<TProduto>;
var
  query:TFDQuery;
begin
  result := TObjectList<TProduto>.create;
  query := RKConn.getquery('SELECT * FROM PRODUTO');

  query.open;

  while not query.eof do
  begin
    result.add(TProduto.create);
    result.last.codigobarras := query.fieldbyname('CODIGO_BARRAS').asstring;
    query.next;
  end;
end;

function TProdutoRepository.getByCodigoAuxiliar(codigo: string): TProduto;
var
  query:TFDQuery;
  codigoAuxiliar:TCodigoAuxiliar;
begin
result := TProduto.create;
codigoAuxiliar := TCodigoAuxiliar.Create;
codigoAuxiliar.codigo_auxiliar := codigo;

query := RKConn.GetQuery('SELECT * FROM CODIGO_AUXILIAR WHERE CODIGO_AUXILIAR = :CODIGO_AUXILIAR');
query.ParamByName('CODIGO_AUXILIAR').AsString := codigoAuxiliar.codigo_auxiliar;
query.Open;
if query.RecordCount = 0 then exit;

codigoAuxiliar.codigo := query.FieldByName('CODIGO').AsString;
codigoAuxiliar.codigo_auxiliar := query.FieldByName('CODIGO_AUXILIAR').AsString;
codigoAuxiliar.codigo_barras := query.FieldByName('CODIGO_BARRAS').AsString;


query := RKConn.GetQuery('select * from produto where codigo_barras = :CODIGO_BARRAS ');
query.parambyname('CODIGO_BARRAS').asstring := codigoAuxiliar.codigo_barras;
query.Open;

if query.RecordCount = 0  then Exit;

result := TProdutoRKAdapter.toDomain(query);
end;

function TProdutoRepository.getByCodigoBarras(codigo: string): TProduto;
var
query:TFDQuery;
begin
result := TProduto.create;
result.codigoBarras := codigo;
query := RKConn.GetQuery('select * from produto where codigo_barras = :CODIGO_BARRAS ');
query.parambyname('CODIGO_BARRAS').asstring := result.codigoBarras;
query.Open;

if query.RecordCount = 0  then Exit;
result := TProdutoRKAdapter.toDomain(query);
end;

initialization
  RK_PRODUTO_REPO := TProdutoRepository.Create;
end.
