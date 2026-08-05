unit ProdutoList;

interface
uses system.Generics.collections,produto;

type
  TProdutoList = class
  FList:TList<TProduto>;
  public
  constructor create;
  procedure Add(AProduto:TProduto);
  function getItems:TList<TProduto>;
end;



implementation


{ TProdutoList }

procedure TProdutoList.Add(AProduto: TProduto);
begin
FList.Add(AProduto);
end;

constructor TProdutoList.create;
begin
FList := TList<TProduto>.create;
end;

function TProdutoList.getItems: TList<TProduto>;
begin
result := FList;
end;

end.
