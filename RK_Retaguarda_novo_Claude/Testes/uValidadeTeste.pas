unit uValidadeTeste;

interface
uses
  DUnitX.TestFramework,Classe.Variaveis,uDmConexao;

type

  [TestFixture]
  TMyTestObject = class(TObject)
  private
    uDmConexao :TdmConexao;
    uVariaveis:TVariaveis;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

implementation

procedure TMyTestObject.Setup;
begin
uDmConexao := TdmConexao.Create(nil);
VariaveisSrv := TVariaveis.create;

end;

procedure TMyTestObject.TearDown;
begin
end;


initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
