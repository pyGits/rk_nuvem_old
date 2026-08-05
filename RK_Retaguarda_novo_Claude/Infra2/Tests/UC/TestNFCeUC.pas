unit TestNFCeUC;

interface
uses
  DUnitX.TestFramework,NFCeUseCase,NFCeModel,System.Generics.Collections,System.Classes,NFcePendenteRepositoryImpl;

type

  [TestFixture]
  TMyTestObject = class(TObject)
  FNFceUseCase:TNFCeUseCase;
  public
    [Setup]
    procedure Setup;

    [Test]
    procedure TestRegerarNFCe;
  end;

implementation


{ TMyTestObject }

procedure TMyTestObject.Setup;
begin
FNFceUseCase := TNFceUseCase.Create(TNFcePendenteRepositoryFirebird.Create);
end;

procedure TMyTestObject.TestRegerarNFCe;
var
  ListaNFCe:TStringList;
begin
ListaNFCe := TStringList.Create;
ListaNFCe.Add('35251137845756000141650010000000469000000470');


FNFceUseCase.RegerarNFCe(ListaNFCe,'19059090');
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
