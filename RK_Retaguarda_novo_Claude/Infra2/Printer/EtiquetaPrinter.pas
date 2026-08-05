unit EtiquetaPrinter;

interface
uses ProdutoModel,EtiquetaLayoutModel,ConfiguracaoRepositoryImpl,System.Generics.collections,Vcl.ExtCtrls;
type IEtiquetaPrinter = interface
  ['{62B37DD1-97F6-48D6-AE98-3EF177AD97AB}']
  procedure Imprimir(produto:TProdutoModel;layout:TEtiquetaLayoutModel);
  procedure ImprimirFila(ListaProdutos:TObjectList<TProdutoModel>;layout:TEtiquetaLayoutModel);
  procedure EditarLayout(layout:TEtiquetaLayoutModel);
  procedure Preview(produto: TProdutoModel; layout: TEtiquetaLayoutModel; ParentPanel: TPanel);
end;



implementation


end.
