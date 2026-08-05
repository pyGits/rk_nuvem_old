unit uFrmLocGrupo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, NxColumns,
  NxColumnClasses, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,Classe.Variaveis,Conversao,
  Vcl.Menus;

type
  TfrmLocGrupo = class(TForm)
    grid: TNextGrid;
    NxNumberColumn1: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    Panel6: TPanel;
    Label4: TLabel;
    Label124: TLabel;
    edtLoc: TEdit;
    cbPesq: TComboBox;
    func: TPopupMenu;
    S1: TMenuItem;
    procedure edtLocChange(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure gridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    class function Exibe:string;
  end;

var
  frmLocGrupo: TfrmLocGrupo;
  grupo:string;

implementation

{$R *.dfm}

procedure TfrmLocGrupo.edtLocChange(Sender: TObject);
begin
  if cbPesq.ItemIndex = 0 then
  begin
      VariaveisSrv.oGrupoController.PreencherGrid(edtloc.text,grid,nome);
  end
  else
  begin
      VariaveisSrv.oGrupoController.PreencherGrid(edtloc.text,grid,codigo);
  end;
end;

class function TfrmLocGrupo.Exibe: string;
var
  frm :TfrmLocGrupo;

begin
     frm := TfrmLocGrupo.Create(nil);

  try
     frm.Visible := False;
     frm.ShowModal;
     result := grupo;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmLocGrupo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if (grid.RowCount > 0) then
begin
  grupo := grid.Cell[0,grid.SelectedRow].AsString;
end;
end;

procedure TfrmLocGrupo.FormShow(Sender: TObject);
begin
      VariaveisSrv.oGrupoController.PreencherGrid('',grid,nome);
      if grid.RowCount > 0 then
      begin
        grid.SelectFirstRow();
      end;
end;

procedure TfrmLocGrupo.gridCellDblClick(Sender: TObject; ACol, ARow: Integer);
begin
Close;
end;

procedure TfrmLocGrupo.gridKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  Close;
end;
end;

procedure TfrmLocGrupo.S1Click(Sender: TObject);
begin
grupo := '000000';
Close;
end;

end.
