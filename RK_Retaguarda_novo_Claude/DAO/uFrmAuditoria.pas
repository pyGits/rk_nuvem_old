unit uFrmAuditoria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, NxColumns, NxColumnClasses,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Vcl.ComCtrls,
  Vcl.StdCtrls, AdvGlowButton, Vcl.ExtCtrls, Vcl.Menus,Classe.Variaveis,
  Data.DB, Vcl.Grids, Vcl.DBGrids,Conversao;

type
  TfrmAuditoria = class(TForm)
    func: TPopupMenu;
    S1: TMenuItem;
    I1: TMenuItem;
    g1: TMenuItem;
    C1: TMenuItem;
    E1: TMenuItem;
    a1: TMenuItem;
    Panel6: TPanel;
    Label4: TLabel;
    pcAuditoria: TPageControl;
    tsLista: TTabSheet;
    ds: TDataSource;
    grid: TDBGrid;
    btnVisualizar: TButton;
    dtInicial: TDateTimePicker;
    dtFinal: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    cbTipo: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure gridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnVisualizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAuditoria: TfrmAuditoria;

implementation

{$R *.dfm}

procedure TfrmAuditoria.btnVisualizarClick(Sender: TObject);
begin
 VariaveisSrv.oAuditoriaController.PreencherGrid(ds,dtInicial.DateTime,dtFinal.dateTime,TAuditoria(cbTipo.ItemIndex));
end;

procedure TfrmAuditoria.FormShow(Sender: TObject);
begin
dtInicial.Date := Date();
dtFinal.Date := Date();
VariaveisSrv.oAuditoriaController.PreencherGrid(ds,Date(),Date(),tpTodos);
end;

procedure TfrmAuditoria.gridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var R : TRect;

begin
 R:=Rect;
 Dec(R.Bottom,2);
 if Column.Field=ds.DataSet.FieldByName('ALTERADO') then
  begin
   if not (gdSelected in State) then
    grid.Canvas.FillRect(Rect);
   grid.Canvas.TextRect(R,R.Left,R.Top,
   ds.DataSet.FieldByName('ALTERADO').AsString);
  end;
end;

end.
