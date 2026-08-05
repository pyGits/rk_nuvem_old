unit uFrmRelPainel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, VCLTee.TeEngine,
  VCLTee.Series, Vcl.StdCtrls, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart,Classe.Variaveis,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, NxColumns,
  NxColumnClasses, Vcl.ComCtrls,Classe.Relatorio,Conversao, Vcl.Menus;

type
  TfrmRelPainel = class(TForm)
    chtCupom: TChart;
    Series1: TBarSeries;
    Panel6: TPanel;
    Label4: TLabel;
    Panel1: TPanel;
    btnVisualizar: TButton;
    Panel2: TPanel;
    gridValores: TNextGrid;
    coluna1: TNxTextColumn;
    coluna2: TNxNumberColumn;
    coluna3: TNxNumberColumn;
    dtInicio: TDateTimePicker;
    Label1: TLabel;
    dtFim: TDateTimePicker;
    Label2: TLabel;
    cbTipo: TComboBox;
    Label3: TLabel;
    func: TPopupMenu;
    S1: TMenuItem;
    NxNumberColumn1: TNxNumberColumn;
    procedure btnVisualizarClick(Sender: TObject);
    procedure dtInicioKeyPress(Sender: TObject; var Key: Char);
    procedure S1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  frmRelPainel: TfrmRelPainel;

implementation

{$R *.dfm}

procedure TfrmRelPainel.btnVisualizarClick(Sender: TObject);
var
  oRelatorio:TRelatorio;
begin
  oRelatorio := TRelatorio.Create;
  oRelatorio.periodoInicial := dtInicio.Date;
  oRelatorio.periodoFinal := dtFim.Date;
  oRelatorio.tipo := TTipoRelatorio(cbTipo.ItemIndex);

  VariaveisSrv.oRelatorioController.RelatorioGraficoCupom(oRelatorio,chtCupom,gridValores);
  orelatorio.Destroy;

end;

procedure TfrmRelPainel.dtInicioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmRelPainel.FormShow(Sender: TObject);
begin
dtInicio.date := date;
dtFim.date := date;
end;

procedure TfrmRelPainel.S1Click(Sender: TObject);
begin
Close;
end;

end.
