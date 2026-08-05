unit ProdutoController;

interface
uses Produto,System.Generics.Collections,RK.Produto.Repository,System.SysUtils;
type TProdutoController = class
  function get(codigo:string):TProduto;


  function gerarCodigoBarras:string;

end;
var
  Produto_Controller:TProdutoController;

implementation

{ TProdutoController }


{ TProdutoController }

function TProdutoController.gerarCodigoBarras: string;
var
  CodigosNumericos: TList<Integer>;
  Produto: TProduto;
  I: Integer;
  CodigoInt: Integer;
  Produtos: TObjectList<TProduto>;
begin
  Produtos := RK_PRODUTO_REPO.getAll;
  CodigosNumericos := TList<Integer>.Create;
  try
    // Extrai somente os codigos de barras numéricos
    for Produto in Produtos do
    begin
      if TryStrToInt(Trim(Produto.CodigoBarras), CodigoInt) then
        CodigosNumericos.Add(CodigoInt);
    end;

    // Procura o menor número não utilizado, começando de 1
    for I := 1 to CodigosNumericos.Count + 1 do
    begin
      if not CodigosNumericos.Contains(I) then
      begin
        Result := Format('%.5d', [I]); // retorna como string, ex: '00001'
        Exit;
      end;
    end;

    // Se todos estiverem preenchidos sequencialmente
    Result := Format('%.5d', [CodigosNumericos.Count + 1]);
  finally
    CodigosNumericos.Free;
  end;
end;


function TProdutoController.get(codigo: string): TProduto;
begin
result := RK_PRODUTO_REPO.getByCodigoBarras(codigo);
if result.Codigo <> '' then Exit;
result := RK_PRODUTO_REPO.getByCodigoAuxiliar(codigo);
if result.Codigo <> '' then exit;


if result.Codigo = '' then raise Exception.Create('Produto Não Encontrado !');

end;

initialization
  Produto_Controller:=TProdutoController.Create;
end.
