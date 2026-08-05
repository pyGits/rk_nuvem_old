unit uFrmRelPerformanceProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Mask, JvExMask, JvToolEdit, AdvGlowButton, Vcl.ExtCtrls, AdvSmoothPanel,
  AdvSmoothExpanderPanel,system.DateUtils,Classe.Relatorio,uFrmLocProduto,Classe.Produto;

type
  TfrmRelPerformanceProduto = class(TForm)
    AdvSmoothExpanderPanel1: TAdvSmoothExpanderPanel;
    Label53: TLabel;
    pnl1: TPanel;
    Label5: TLabel;
    Label3: TLabel;
    btnVis: TAdvGlowButton;
    edtCodProduto: TEdit;
    edtProduto: TEdit;
    StatusBar1: TStatusBar;
    PopupMenu1: TPopupMenu;
    F1: TMenuItem;
    p1: TMenuItem;
    edtMes1: TEdit;
    Edit2: TEdit;
    edtAno1: TEdit;
    edtMes2: TEdit;
    Edit3: TEdit;
    edtAno2: TEdit;
    edtMes3: TEdit;
    Edit6: TEdit;
    edtAno3: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnVisClick(Sender: TObject);
    procedure p1Click(Sender: TObject);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure edtCodProdutoKeyPress(Sender: TObject; var Key: Char);
  private
    procedure preencherProduto(oProduto:TProduto);
      procedure inicializarForm;
  public
    { Public declarations }
  end;

var
  frmRelPerformanceProduto: TfrmRelPerformanceProduto;

implementation
  uses Classe.Variaveis,Classe.funcoes;

{$R *.dfm}

procedure TfrmRelPerformanceProduto.btnVisClick(Sender: TObject);
var
  oRelatorio:TRelatorio;
begin
try
  oRelatorio := TRelatorio.Create;
  oRelatorio.listaString1[0] := edtMes1.Text;
  oRelatorio.listaString1[1] := edtMes2.Text;
  oRelatorio.listaString1[2] := edtMes3.Text;

  oRelatorio.listaString1[3] := edtAno1.Text;
  oRelatorio.listaString1[4] := edtAno2.Text;
  oRelatorio.listaString1[5] := edtAno3.Text;

  oRelatorio.listaString1[6] := edtCodProduto.Text;


  variaveissrv.oRelatorioController.relatorioPerformanceProduto(oRelatorio);
finally
  oRelatorio.Destroy;
end;
end;

procedure TfrmRelPerformanceProduto.edtCodProdutoExit(Sender: TObject);
var
  oProduto:TProduto;
begin
edtCodProduto.Text := zeroEsquerda(edtCodProduto.Text,6);

if edtCodProduto.Text <> '000000' then
begin
  try
    oProduto := TProduto.create;
    oProduto.Codigo := edtCodProduto.Text;
    if VariaveisSrv.oProdutoController.CarregarProduto(oProduto) then
    begin
      preencherProduto(oProduto);
      btnVis.SetFocus;
    end
    else
    begin
    ShowMessage('Produto não encontrado pressione F2 para pesquisar');
    oProduto.Codigo := '000000';
    oProduto.Descricao := 'TODOS';
    preencherProduto(oProduto);
      
    end;
  finally
    oProduto.Destroy;
  end;
end
else
begin
  edtProduto.Text := 'TODOS';
end;
end;

procedure TfrmRelPerformanceProduto.edtCodProdutoKeyPress(Sender: TObject;
  var Key: Char);
begin
if key = #13 then
begin
  btnVis.SetFocus;
end;
end;

procedure TfrmRelPerformanceProduto.FormShow(Sender: TObject);
begin
inicializarForm;
end;

procedure TfrmRelPerformanceProduto.inicializarForm;
begin
edtMes3.Text := Inttostr(Monthof(now));
edtAno3.Text := Inttostr(YearOf(now));

edtMes2.Text := Inttostr(Monthof(now)-1);
edtAno2.Text := Inttostr(YearOf(now));

edtMes1.Text := Inttostr(Monthof(now)-2);
edtAno1.Text := Inttostr(YearOf(now));
end;

procedure TfrmRelPerformanceProduto.p1Click(Sender: TObject);
var
  codigo:string;
  oProduto:TProduto;
begin
if edtCodProduto.Focused then
begin
  codigo:= TfrmLocProduto.Exibe;
  try
    oProduto := TProduto.create;
    oProduto.CodigoBarras := codigo;
    VariaveisSrv.oProdutoController.CarregarProduto(oProduto);
    preencherProduto(oProduto);
  finally
    oProduto.Destroy;
  end;
end;
end;

procedure TfrmRelPerformanceProduto.preencherProduto(oProduto:TProduto);
begin
with oProduto do
begin
  edtCodProduto.Text := Codigo;
  edtProduto.Text := Descricao;
end;
end;

end.
