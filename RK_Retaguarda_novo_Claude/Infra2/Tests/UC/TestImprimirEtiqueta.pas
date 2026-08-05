unit TestImprimirEtiqueta;

interface
uses
  DUnitX.TestFramework,DatabaseUseCase,UIAtualizarBancoInterface,EtiquetaUseCase,ConfiguracaoRepositoryImpl,ProdutoRepositoryImpl,EtiquetaRepositoryImpl,UIEtiqueta,CodigoAuxiliarRepositoryImpl,EtiquetaPrinter;

type

  [TestFixture]
  TMyTestObject = class(TObject)
  FEtiquetaUseCase:TEtiquetaUseCase;
  public
    [Setup]
    procedure Setup;
    [Test]
    procedure TestAdicionarProdutoSyspdvProcod;
    [Test]
    procedure TestCarregarProduto;
    [Test]
    procedure TestCarregarInterface;
    [Test]
    procedure TestImprimirEtiqueta;

  end;

implementation


{ TMyTestObject }

procedure TMyTestObject.Setup;
begin
//FEtiquetaUseCase := TEtiquetaUseCase.create(
//TEtiquetaRepositoryFirebird.Create,
//TUIEtiquetaFake.create,
//TEtiquetaPrinterFake.Create
//);
end;

procedure TMyTestObject.TestAdicionarProdutoSyspdvProcod;
begin
//FEtiquetaUseCase.AdicionarProduto('881',1);
end;

procedure TMyTestObject.TestCarregarInterface;
begin
//FEtiquetaUseCase.Abrir;
end;

procedure TMyTestObject.TestCarregarProduto;
begin
//FEtiquetaUseCase.CarregarProduto('881');
end;

procedure TMyTestObject.TestImprimirEtiqueta;
begin
//FEtiquetaUseCase.imprimirEtiqueta('1','1');
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
