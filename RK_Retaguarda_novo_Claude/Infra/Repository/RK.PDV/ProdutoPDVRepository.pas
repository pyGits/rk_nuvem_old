unit ProdutoPDVRepository;

interface
uses
  ProdutoList,PDVConnectionList,Firedac.comp.client,Produto;

type
  TProdutoPDVRepository = class
  public
    function CarregarTodosProdutos:TProdutoList;
end;

var
  ProdutoPDV_Repository: TProdutoPDVRepository;

implementation

{ TProdutoPDVRepository }

function TProdutoPDVRepository.CarregarTodosProdutos: TProdutoList;
var
  query:TFdQuery;
begin
result := TProdutoList.create;
query := PdvConnection_List.import_connection.GetQuery('SELECT * FROM ESTOQUE');
query.open;

while not query.eof do
begin
  result.Add(TProduto.create);
  result.getItems.Last.Codigo := query.FieldByName('CODIGO').AsString;
  result.getItems.Last.CodigoBarras := query.FieldByName('COD_BARRA').AsString;
  result.getItems.Last.Descricao := query.FieldByName('NOME').AsString;
  result.getItems.Last.Unidade := query.FieldByName('UNIDADE').AsString;
  result.getItems.Last.Preco := query.FieldByName('PRECO_VENDA').AsFloat;
  result.getItems.Last.Estoque := query.FieldByName('ESTOQUE').AsFloat;
  result.getItems.Last.NCM := query.FieldByName('NCM').AsString;
  result.getItems.Last.SetBalancaBoolean(query.FieldByName('USA_BALANCA').AsInteger);
  result.getItems.Last.SetDiversosBoolean(query.FieldByName('PRECO_VARIAVEL').AsInteger);
  result.getItems.Last.Custo := query.FieldByName('CUSTO').AsFloat;
  result.getItems.Last.CEST := query.FieldByName('CEST').AsString;
  result.getItems.Last.Tributacao := query.FieldByName('TRIBUTACAO').AsString;
  result.getItems.Last.Observacao := query.FieldByName('OBSERVACAO').AsString;
  query.Next;
end;

end;

initialization
  ProdutoPDV_Repository := TProdutoPDVRepository.Create;

end.
