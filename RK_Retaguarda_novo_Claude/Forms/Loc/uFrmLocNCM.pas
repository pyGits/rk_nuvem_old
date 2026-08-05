unit uFrmLocNCM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls,
  NxColumns, NxColumnClasses, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid,Classe.Variaveis,Conversao, Data.DB, Vcl.Grids,
  Vcl.DBGrids;

type
  TfrmLocNCM = class(TForm)
    Panel6: TPanel;
    lblNCM: TLabel;
    Label124: TLabel;
    edtLoc: TEdit;
    cbPesq: TComboBox;
    func: TPopupMenu;
    S1: TMenuItem;
    Grid: TDBGrid;
    ds: TDataSource;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    procedure S1Click(Sender: TObject);
    procedure edtLocChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure gridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
    procedure edtLocKeyPress(Sender: TObject; var Key: Char);
    procedure GridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    class function Exibe:string;
  end;

var
  frmLocNCM: TfrmLocNCM;
  NCM:string;



implementation

{$R *.dfm}

procedure TfrmLocNCM.edtLocChange(Sender: TObject);
begin
  if cbPesq.ItemIndex = 0 then
  begin
      VariaveisSrv.oNCMController.PreencherGrid(edtloc.text,grid,nome);
  end
  else
  begin
      VariaveisSrv.oNCMController.PreencherGrid(edtloc.text,grid,codigo);
  end;
end;

procedure TfrmLocNCM.edtLocKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  Grid.SetFocus;
end;
end;

class function TfrmLocNCM.Exibe: string;
var
  frm :TfrmLocNCM;

begin
     frm := TfrmLocNCM.Create(nil);

  try
     frm.Visible := False;
     frm.ShowModal;
     result := NCM;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmLocNCM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
ncm := grid.Fields[0].AsString;
end;

procedure TfrmLocNCM.FormShow(Sender: TObject);
begin
       VariaveisSrv.oNCMController.PreencherGrid('',Grid,nome);
       edtLoc.SetFocus;
end;

procedure TfrmLocNCM.gridCellDblClick(Sender: TObject; ACol, ARow: Integer);
begin
Close;
end;

procedure TfrmLocNCM.GridDblClick(Sender: TObject);
begin
close;
end;

procedure TfrmLocNCM.gridKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  Close;
end;
end;

procedure TfrmLocNCM.S1Click(Sender: TObject);
begin
Close;
end;

end.
