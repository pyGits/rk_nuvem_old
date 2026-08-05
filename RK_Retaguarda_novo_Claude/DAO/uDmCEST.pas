unit uDmCEST;

interface

uses
  System.SysUtils, System.Classes,uDmConexao,Conversao, Data.DB, MemDS,
  DBAccess, Uni,Classe.CEST;

type
  TdmCEST = class(TDataModule)
    qrGridCEST: TUniQuery;
    qrGridCESTCEST: TStringField;
    qrGridCESTNCM: TStringField;
    qrGridCESTDESCRICAO: TMemoField;
    qrCESTPesquisar: TUniQuery;
    StringField1: TStringField;
    StringField2: TStringField;
    MemoField1: TMemoField;
    procedure qrGridCESTDESCRICAOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
  public
    function PreencherGrid(sNCM:string;ds:TDataSource;tipo:TPesquisar):Boolean;
    function ValidaCEST(oCest:TCest):Boolean;
  end;

var
  dmCEST: TdmCEST;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmCEST }

function TdmCEST.PreencherGrid(sNCM: string; ds: TDataSource;
  tipo: TPesquisar): Boolean;
begin
with qrGridCEST do
begin
  ds.DataSet := qrGridCEST;
  sNCM := StringReplace(sNCM,Chr(39),'',[rfReplaceAll,rfIgnoreCase]);
  Close;
  SQL.Clear;
  SQL.Add('SELECT  * FROM CEST');
  SQL.Add('where ncm = :NCM');
  ParamByName('NCM').AsString := sNCM;


Open;

end;
end;

procedure TdmCEST.qrGridCESTDESCRICAOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if (DisplayText) then
    Text := Sender.AsString;
end;

function TdmCEST.ValidaCEST(oCest: TCest): Boolean;
begin
with qrCESTPesquisar do
begin
  Close;
  SQL.Clear;
  SQL.add('SELECT * FROM CEST WHERE NCM = :NCM AND CEST = :CEST');
  ParamByName('NCM').AsString := oCest.NCM;
  ParamByName('CEST').AsString := oCest.CEST;
  Open;

  if qrCESTPesquisar.RecordCount > 0 then
  begin
    Result := True;
  end
  else
  begin
    Result := false;
  end;

end;
end;

end.
