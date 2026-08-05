unit uFrmRelExtratoEstoque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, AdvGlowButton, Vcl.ExtCtrls,
  Vcl.StdCtrls, AdvSmoothPanel, AdvSmoothExpanderPanel, Vcl.Mask, JvExMask,
  JvToolEdit, Vcl.ComCtrls,uFrmLocFun,uFrmLocProduto,Classe.Variaveis,Classe.Produto,Classe.Funcionario,Classe.Relatorio;

type
  TfrmExtratoEstoque = class(TForm)
    AdvSmoothExpanderPanel1: TAdvSmoothExpanderPanel;
    Label53: TLabel;
    pnl1: TPanel;
    btnVis: TAdvGlowButton;
    PopupMenu1: TPopupMenu;
    F1: TMenuItem;
    p1: TMenuItem;
    edtDtInicio: TJvDateEdit;
    Label5: TLabel;
    edtDtFim: TJvDateEdit;
    Label1: TLabel;
    edtCodFuncionario: TEdit;
    edtFuncionario: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtCodProduto: TEdit;
    edtProduto: TEdit;
    StatusBar1: TStatusBar;
    edtCodProduto2: TEdit;
    edtCaixa: TEdit;
    Label4: TLabel;
    procedure p1Click(Sender: TObject);
    procedure edtCodProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure edtCodProdutoClick(Sender: TObject);
    procedure edtCodFuncionarioClick(Sender: TObject);
    procedure edtCodFuncionarioExit(Sender: TObject);
    procedure edtCodFuncionarioKeyPress(Sender: TObject; var Key: Char);
    procedure edtDtInicioKeyPress(Sender: TObject; var Key: Char);
    procedure edtDtFimKeyPress(Sender: TObject; var Key: Char);
    procedure btnVisClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtCaixaKeyPress(Sender: TObject; var Key: Char);
  private
    procedure preencherProduto(oProduto:TProduto);
    procedure preencherFuncionario(oFuncionario:TFuncionario);
  public
    { Public declarations }
  end;

var
  frmExtratoEstoque: TfrmExtratoEstoque;


implementation
  uses Classe.Funcoes;

{$R *.dfm}

procedure TfrmExtratoEstoque.btnVisClick(Sender: TObject);
var
  oRelatorio:TRelatorio;
begin
try
  oRelatorio := TRelatorio.Create;
  oRelatorio.periodoInicial := edtDtInicio.Date;
  oRelatorio.periodoFinal := edtDtFim.Date;

  oRelatorio.listaString1[0] := edtCodFuncionario.Text;
  oRelatorio.listaString1[1] := edtCodProduto2.Text;

  oRelatorio.caixa := edtCaixa.Text;

  VariaveisSrv.oRelatorioController.RelatorioExtratoEstoque(oRelatorio);
finally
  oRelatorio.Destroy;
end;
end;

procedure TfrmExtratoEstoque.edtCaixaKeyPress(Sender: TObject; var Key: Char);
begin
if key =#13 then
begin
  btnVis.SetFocus;
end;
end;

procedure TfrmExtratoEstoque.edtCodFuncionarioClick(Sender: TObject);
begin
edtCodFuncionario.SelectAll;
end;

procedure TfrmExtratoEstoque.edtCodFuncionarioExit(Sender: TObject);
var
  oFuncionario:TFuncionario;
begin
try
  edtCodFuncionario.Text := zeroEsquerda(edtCodFuncionario.text,6);
  oFuncionario := TFuncionario.create;
  if (edtCodFuncionario.Text <> '000000') then
  begin

    oFuncionario.Codigo := edtCodFuncionario.Text;
    if VariaveisSrv.oFuncionarioController.CarregarFuncionario(oFuncionario) then
    begin
      // encontrou funcionario
      preencherFuncionario(oFuncionario);
    end
    else
    begin
      oFuncionario.Codigo := frmLocFun.Exibe;
      VariaveisSrv.oFuncionarioController.CarregarFuncionario(oFuncionario);
      preencherFuncionario(oFuncionario);
    end;
  end
  else
  begin
    edtFuncionario.Text := 'TODOS';
  end;
finally
  oFuncionario.Destroy;
end;
end;

procedure TfrmExtratoEstoque.edtCodFuncionarioKeyPress(Sender: TObject;
  var Key: Char);
begin
if key = #13 then
begin
  edtCodProduto.SetFocus;
end;
end;

procedure TfrmExtratoEstoque.edtCodProdutoClick(Sender: TObject);
begin
edtCodProduto.SelectAll;
end;

procedure TfrmExtratoEstoque.edtCodProdutoExit(Sender: TObject);
var
  oProduto:TProduto;
begin
try
  edtCodProduto.Text := zeroEsquerda(edtCodProduto.text,14);
  oProduto := TProduto.create;
  if (edtCodProduto.Text <> '00000000000000') then
  begin

    oProduto.CodigoBarras := edtCodProduto.Text;
    if VariaveisSrv.oProdutoController.CarregarProduto(oProduto) then
    begin
      // encontrou produto
      preencherProduto(oProduto);
    end
    else
    begin
      oProduto.CodigoBarras := frmLocProduto.Exibe;
      VariaveisSrv.oProdutoController.CarregarProduto(oProduto);
      preencherProduto(oProduto);
    end;
  end
  else
  begin
    edtProduto.Text := 'TODOS';
    edtCodProduto2.Text := '000000';
  end;
finally
  oProduto.Destroy;
end;

end;

procedure TfrmExtratoEstoque.edtCodProdutoKeyPress(Sender: TObject;
  var Key: Char);
begin
if Key = #13 then
begin
  edtDtInicio.SetFocus;
end;
end;

procedure TfrmExtratoEstoque.edtDtFimKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  edtCaixa.SetFocus;
end;
end;

procedure TfrmExtratoEstoque.edtDtInicioKeyPress(Sender: TObject;
  var Key: Char);
begin
if key = #13 then
begin
  edtDtFim.SetFocus;
end;
end;

procedure TfrmExtratoEstoque.FormShow(Sender: TObject);
begin
edtDtInicio.Date := Now();
edtDtFim.Date := Now();
end;

procedure TfrmExtratoEstoque.p1Click(Sender: TObject);
var
  oProduto:TProduto;
begin
// evento F2
if edtCodProduto.Focused then
begin
try
  oProduto := TProduto.create;
  oProduto.CodigoBarras := frmLocProduto.Exibe;
  VariaveisSrv.oProdutoController.CarregarProduto(oProduto);
  preencherProduto(oProduto);
finally
  oProduto.Destroy;
end;
end;

end;

procedure TfrmExtratoEstoque.preencherFuncionario(oFuncionario: TFuncionario);
begin
  with oFuncionario do
  begin
    edtCodFuncionario.Text := Codigo;
    edtFuncionario.Text := Pessoa.Nome;
  end;
end;

procedure TfrmExtratoEstoque.preencherProduto(oProduto: TProduto);
begin
  with oProduto do
  begin
  edtCodProduto2.Text := Codigo;
    edtCodProduto.Text := CodigoBarras;
    edtProduto.Text := Descricao;
  end;
end;

end.
