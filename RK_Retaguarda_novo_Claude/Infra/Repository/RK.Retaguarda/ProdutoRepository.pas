unit ProdutoRepository;

interface
uses ProdutoList,Produto,RKConnection,Firedac.comp.client,System.Sysutils;

type
  TProdutoRepository = class
  procedure InserirListaProdutos(AProdutoLista:TProdutoList);
end;

var
  Produto_Repository: TProdutoRepository;

implementation

{ TProdutoRepository }

procedure TProdutoRepository.InserirListaProdutos(AProdutoLista: TProdutoList);
var
i:integer;
begin
if AProdutoLista.getItems.Count <= 0 then exit;

RKConn.bulkQuery := TFDQuery.Create(nil);
RKConn.bulkQuery.Connection := RKConn.FConn;


RKConn.bulkQuery.SQL.Text :=
  'UPDATE OR INSERT INTO PRODUTO (' +
  'CODIGO, CODIGO_BARRAS, DESCRICAO, GRUPO, SUBGRUPO, FORNECEDOR, TRIBUTACAO, NCM, CEST, VALIDADE, ' +
  'BALANCA, FRACIONADO, CUSTO, PRECO, MARGEM, ESTOQUE, UNIDADE, INATIVO, DIVERSOS, DATA_CADASTRO, ' +
  'DATA_ALTERADO, PENDENTE, ESTOQUE_MINIMO, ESTOQUE_MAXIMO, OBSERVACAO) ' +
  'VALUES (' +
  ':CODIGO, :CODIGO_BARRAS, :DESCRICAO, :GRUPO, :SUBGRUPO, :FORNECEDOR, :TRIBUTACAO, :NCM, :CEST, :VALIDADE, ' +
  ':BALANCA, :FRACIONADO, :CUSTO, :PRECO, :MARGEM, :ESTOQUE, :UNIDADE, :INATIVO, :DIVERSOS, :DATA_CADASTRO, ' +
  ':DATA_ALTERADO, :PENDENTE, :ESTOQUE_MINIMO, :ESTOQUE_MAXIMO, :OBSERVACAO)';

RKConn.bulkQuery.Params.ArraySize := AProdutoLista.getItems.Count;
//
for i := 0 to RKConn.bulkQuery.Params.ArraySize-1 do
begin
with AProdutoLista.getItems[i] do
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

initialization
  Produto_Repository := TProdutoRepository.Create;

end.
