unit TestContaReceberUC;

interface
uses
  DUnitX.TestFramework,ContaReceberUseCase;

type

  [TestFixture]
  TMyTestObject = class(TObject)
  private
  FContaReceberUseCase:TContaReceberUseCase;
  public
  [Setup]
   procedure Setup;
  [Test]
  procedure TestImprimirContaReceber;
  end;

implementation


{ TMyTestObject }

procedure TMyTestObject.Setup;
begin
FContaReceberUseCase := TContaReceberUseCase.create;
end;

procedure TMyTestObject.TestImprimirContaReceber;
begin
//FContaReceberUseCase.ImprimirContaReceber('00000000000000000000000000000024609001');
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
