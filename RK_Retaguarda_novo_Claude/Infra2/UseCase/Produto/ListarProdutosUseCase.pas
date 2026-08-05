unit ListarProdutosUseCase;

interface

uses
  ProdutoRepositoryImpl,
  ProdutoModel,
  System.Generics.Collections,
  System.SysUtils;

type
  TTipoFiltroProduto = (tfTodos, tfNome, tfCodigoBarras, tfCategoria, tfAlterados);

  TProdutoFiltro = record
    Tipo: TTipoFiltroProduto;
    Valor: string;
    DataInicio: TDate;
    DataFim: TDate;
    Unidade: string;
  end;

  TListarProdutosUseCase = class
  private
    FProdutoRepository: IProdutoRepository;
  public
    constructor Create(produtoRepository: IProdutoRepository);

    function Execute(const Filtro: TProdutoFiltro): TObjectList<TProdutoModel>;
  end;

implementation

constructor TListarProdutosUseCase.Create(produtoRepository: IProdutoRepository);
begin
  FProdutoRepository := produtoRepository;
end;

function TListarProdutosUseCase.Execute(const Filtro: TProdutoFiltro): TObjectList<TProdutoModel>;
var
  todos: TObjectList<TProdutoModel>;
  produto: TProdutoModel;
begin
  case Filtro.Tipo of

    tfTodos:
      Result := FProdutoRepository.getAll;

    tfAlterados:
      Result := FProdutoRepository.getProdutosAlterados(
        Filtro.DataInicio,
        Filtro.DataFim,
        Filtro.Unidade
      );

    tfCodigoBarras:
      begin
        Result := TObjectList<TProdutoModel>.Create(True);

        produto := FProdutoRepository.getByCodigoBarras(Filtro.Valor);

        if produto <> nil then
          Result.Add(produto);
      end;

    tfNome:
      begin
        // 🔥 filtro em memória
        Result := TObjectList<TProdutoModel>.Create(True);

        result := FProdutoRepository.getAllByDescricao(Filtro.Valor);
      end;

    tfCategoria:
      begin
        Result := TObjectList<TProdutoModel>.Create(True);

        result := FProdutoRepository.getAllByGrupo(Filtro.Valor);
      end;

  else
    raise Exception.Create('Filtro inválido');
  end;
end;

end.
