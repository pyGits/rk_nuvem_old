unit TestDatabaseUC;

interface
uses
  DUnitX.TestFramework,DatabaseUseCase,UIAtualizarBancoInterface;

type

  [TestFixture]
  TMyTestObject = class(TObject)
  FDatabaseUseCase:TDatabaseUseCase;
  public
    [Setup]
    procedure Setup;
    [Test]
    procedure TestUpdateDatabaseFirebird;

  end;

implementation


{ TMyTestObject }

procedure TMyTestObject.Setup;
begin
FDatabaseUseCase := TDatabaseUseCase.create(TUIAtualizarBancoFake.create);
end;

procedure TMyTestObject.TestUpdateDatabaseFirebird;
begin
FDatabaseUseCase.UpdateDatabase;
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
