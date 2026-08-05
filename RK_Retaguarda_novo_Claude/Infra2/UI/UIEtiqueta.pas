unit UIEtiqueta;

interface
uses ProdutoModel,EtiquetaLayoutModel,System.Generics.collections;
type IUIEtiqueta = interface
  ['{054BE9F3-59DF-429B-ACC7-019FC927D4F3}']
  procedure CarregarProduto(Produto:TProdutoModel);
  procedure AtualizarInterface(FilaImpressao:TObjectList<TProdutoModel>);
  procedure Abrir(ListaEtiquetasModelo:TObjectList<TEtiquetaLayoutModel>;codigoEtiquetaPadrao:string);
end;


type TUIEtiquetaFake = class(TInterfacedObject,IUIEtiqueta)

  public
    procedure CarregarProduto(Produto: TProdutoModel);
    procedure AtualizarInterface(FilaImpressao:TObjectList<TProdutoModel>);
    procedure Abrir(ListaEtiquetasModelo: System.Generics.Collections.TObjectList<EtiquetaLayoutModel.TEtiquetaLayoutModel>;codigoEtiquetaPadrao:string);


end;

implementation

{ TUIEtiquetaFake }

procedure TUIEtiquetaFake.Abrir;
begin

end;

procedure TUIEtiquetaFake.AtualizarInterface(FilaImpressao:TObjectList<TProdutoModel>);
begin

end;

procedure TUIEtiquetaFake.CarregarProduto(Produto: TProdutoModel);
begin

end;

end.
