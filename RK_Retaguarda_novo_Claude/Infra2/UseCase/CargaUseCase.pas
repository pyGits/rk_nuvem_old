unit CargaUseCase;

interface
uses ProdutoRepositoryImpl,ProdutoModel,System.Generics.Collections,CaixaModel,ProdutoPDVImplRepository,CaixaRepositoryImpl,HostService,vcl.forms;

type TCargaUseCase = class
  FProdutoRepository:IProdutoRepository;
  FProdutoPDVRepository:IProdutoPDVRepository;
  FCaixaRepository:ICaixaRepository;
  FHostService:IHostService;
  constructor create;
  procedure EnviarCargaPDV;
end;

implementation

{ TCargaUseCase }

constructor TCargaUseCase.create;
begin
FProdutoRepository := TProdutoRepositoryFirebird.Create;
FProdutoPDVRepository := TProdutoPdvImplFirebirdRepository.create;
FCaixaRepository := TCaixaRepositoryFirebird.Create;
FHostService := THostService.create;
end;

procedure TCargaUseCase.EnviarCargaPDV;
var
  produtos:TObjectList<TProdutoModel>;
  caixas:TObjectList<TCaixaModel>;
  caixa:TCaixaModel;
begin
  produtos := FProdutoRepository.getAll;
  caixas := FCaixaRepository.getAll;

  for caixa in caixas do
  begin
//    if not (FHostService.HostDisponivel(caixa.ip,1)) then Continue;

    FProdutoPDVRepository.insertBulk(produtos,caixa);
    Application.ProcessMessages;
  end;


end;

end.
