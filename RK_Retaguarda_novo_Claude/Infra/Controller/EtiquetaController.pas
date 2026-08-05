unit EtiquetaController;

interface
uses Produto,RK.Produto.repository,System.SysUtils,RK.Etiqueta.Repository,ProdutoController;
type TEtiquetaController = class
  private
  public
  procedure inserirProdutoEtiqueta(codigo:string);
end;

var
  Etiqueta_Controller:TEtiquetaController;
implementation

{ TEtiquetaController }

procedure TEtiquetaController.inserirProdutoEtiqueta(codigo:string);
var
  produto:TProduto;
label
  InserirEtiqueta;
begin
produto := RK_PRODUTO_REPO.getByCodigoBarras(codigo);
if produto.Codigo <> '' then goto InserirEtiqueta;
produto := RK_PRODUTO_REPO.getByCodigoAuxiliar(codigo);
if produto.Codigo <> '' then goto InserirEtiqueta;

if produto.Codigo = '' then raise Exception.Create('Produto Não Encontrado !');


InserirEtiqueta:
  RK_ETIQUETA_REPO.insert(produto,codigo)

end;
initialization
  Etiqueta_Controller:=TEtiquetaController.Create;

end.
