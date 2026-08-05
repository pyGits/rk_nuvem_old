unit uFrmLocCEST;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Menus, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls,Classe.Variaveis,conversao;

type
  TfrmLocCEST = class(TForm)
    Panel6: TPanel;
    lblNCM: TLabel;
    Grid: TDBGrid;
    func: TPopupMenu;
    S1: TMenuItem;
    ds: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure S1Click(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    class function Exibe(sNCM:string):string;
  end;

var
  frmLocCEST: TfrmLocCEST;
  ncm:string;
  cest:string;

implementation

{$R *.dfm}

{ TfrmLocCEST }

class function TfrmLocCEST.Exibe(sNCM:string): string;
var
  frm :TfrmLocCEST;

begin
     frm := TfrmLocCEST.Create(nil);

  try
      ncm := sNCM;
     frm.Visible := False;
     frm.ShowModal;
     result := CEST;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmLocCEST.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CEST := grid.Fields[0].AsString;
end;

procedure TfrmLocCEST.FormShow(Sender: TObject);
begin
VariaveisSrv.oCESTController.PreencherGrid(ncm,ds,nome)
end;

procedure TfrmLocCEST.GridDblClick(Sender: TObject);
begin
Close;
end;

procedure TfrmLocCEST.GridKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  Close;
end;
end;

procedure TfrmLocCEST.S1Click(Sender: TObject);
begin
Close;
end;

end.
