unit uFrmNotificacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Menus,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ExtCtrls, NxColumns,
  NxColumnClasses, NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid,System.Generics.Collections,NotificacaoController,Notificacao,FormController;

type
  TfrmNotificacao = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    btnVisualizar: TButton;
    pcAuditoria: TPageControl;
    tsLista: TTabSheet;
    func: TPopupMenu;
    S1: TMenuItem;
    I1: TMenuItem;
    g1: TMenuItem;
    C1: TMenuItem;
    E1: TMenuItem;
    a1: TMenuItem;
    grid: TNextGrid;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    cbFiltroCategoria: TComboBox;
    Label1: TLabel;
    NxTextColumn1: TNxTextColumn;
    procedure btnVisualizarClick(Sender: TObject);
    procedure cbFiltroCategoriaChange(Sender: TObject);
    procedure gridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure FormShow(Sender: TObject);
  private
    procedure PreencherGrid;

  public

  end;

var
  frmNotificacao: TfrmNotificacao;
  Lista_Notificacao:TNotificacaoList;
implementation

{$R *.dfm}

{ TfrmNotificacao }

procedure TfrmNotificacao.btnVisualizarClick(Sender: TObject);
begin
PreencherGrid;
end;

procedure TfrmNotificacao.cbFiltroCategoriaChange(Sender: TObject);
begin
PreencherGrid;
end;

procedure TfrmNotificacao.FormShow(Sender: TObject);
begin
PreencherGrid;
end;

procedure TfrmNotificacao.gridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
begin
if (grid.Cell[2,ARow].AsString) = 'Produto' then Form_Controller.AbrirFormulario(FRM_Produto,grid.Cell[1,ARow].AsString);
if (grid.Cell[2,ARow].AsString) = 'Validade' then Form_Controller.AbrirFormulario(FRM_Validade,grid.Cell[1,ARow].AsString);
end;

procedure TfrmNotificacao.PreencherGrid;
var
  notificacao:TNotificacao;
begin
  grid.ClearRows;
  for Notificacao in Notificacao_Controller.ObterNotificacoesDetalhada(cbFiltroCategoria.Text) do
  begin
    grid.AddRow(1);
    grid.Cell[0,grid.LastAddedRow].AsString := notificacao.mensagem;
    grid.Cell[1,grid.LastAddedRow].AsString := notificacao.codigo;
    grid.Cell[2,grid.LastAddedRow].AsString := notificacao.formulario;
  end;

end;

end.
