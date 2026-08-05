unit uFrmLocIBGE;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.Menus,Classe.Variaveis;

type
  TfrmLocIbge = class(TForm)
    func: TPopupMenu;
    S1: TMenuItem;
    Grid: TDBGrid;
    Panel6: TPanel;
    lblNCM: TLabel;
    Label124: TLabel;
    edtLoc: TEdit;
    cbPesq: TComboBox;
    ds: TDataSource;
    procedure S1Click(Sender: TObject);
    procedure edtLocChange(Sender: TObject);
    procedure edtLocKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
class function Exibe:string;
  end;

var
  frmLocIbge: TfrmLocIbge;
  IBGE:string;

implementation

{$R *.dfm}

procedure TfrmLocIbge.edtLocChange(Sender: TObject);
begin
      VariaveisSrv.oUtilsController.PreencherGridIBGE(edtloc.text,ds);
end;

procedure TfrmLocIbge.edtLocKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  grid.SetFocus;
end;
end;

class function TfrmLocIbge.Exibe: string;
var
  frm :TfrmLocIbge;

begin
     frm := TfrmLocIbge.Create(nil);

  try
     frm.Visible := False;
     frm.ShowModal;
     result := IBGE;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmLocIbge.FormClose(Sender: TObject; var Action: TCloseAction);
begin
IBGE := grid.Fields[0].AsString;
end;

procedure TfrmLocIbge.FormShow(Sender: TObject);
begin
       VariaveisSrv.oUtilsController.PreencherGridIBGE('',ds);
end;

procedure TfrmLocIbge.GridDblClick(Sender: TObject);
begin
cLOSE;
end;

procedure TfrmLocIbge.GridKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  Close;
end;
end;

procedure TfrmLocIbge.S1Click(Sender: TObject);
begin
Close;
end;

end.
