unit uFrmLocSubGrupo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls,
  NxColumns, NxColumnClasses, NxScrollControl, NxCustomGridControl,Classe.Variaveis,
  NxCustomGrid, NxGrid,Conversao;

type
  TfrmlocSubGrupo = class(TForm)
    grid: TNextGrid;
    NxNumberColumn1: TNxTextColumn;
    NxTextColumn1: TNxTextColumn;
    Panel6: TPanel;
    Label4: TLabel;
    func: TPopupMenu;
    S1: TMenuItem;
    NxTextColumn2: TNxTextColumn;
    procedure S1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure gridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure gridKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    class function Exibe(grupo:String):string;
  end;

var
  frmlocSubGrupo: TfrmlocSubGrupo;
  locgrupo:string;
  subGrupo:string;

implementation

{$R *.dfm}

class function TfrmlocSubGrupo.Exibe(grupo:String): string;
var
  i: Integer;
  frm :TfrmlocSubGrupo;

begin
     frm := TfrmlocSubGrupo.Create(nil);

  try
     frm.Visible := False;
     locgrupo := grupo;
     frm.ShowModal;
     result := subgrupo;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmlocSubGrupo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if (grid.RowCount > 0) then
begin
  subgrupo := grid.Cell[0,grid.SelectedRow].AsString;
end;
end;

procedure TfrmlocSubGrupo.FormShow(Sender: TObject);
begin
      VariaveisSrv.oSubGrupoController.PreencherGrid(locgrupo,grid,codigo);
      if grid.RowCount > 0 then
      begin
        grid.SelectFirstRow();
      end;
end;

procedure TfrmlocSubGrupo.gridCellDblClick(Sender: TObject; ACol, ARow: Integer);
begin
Close;
end;

procedure TfrmlocSubGrupo.gridKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  Close;
end;
end;

procedure TfrmlocSubGrupo.S1Click(Sender: TObject);
begin
subgrupo := '000000';
Close;
end;

end.
