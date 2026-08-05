unit uFrmRelProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, Vcl.StdCtrls, Vcl.Mask,
  JvExMask, JvToolEdit, Vcl.ExtCtrls, AdvSmoothPanel, AdvSmoothExpanderPanel,Classe.Relatorio,Classe.Variaveis,
  Vcl.Menus,uFrmLocGrupo,Classe.Grupo, Vcl.ComCtrls,Classe.Subgrupo,uFrmLocSubGrupo,Classe.Fornecedor,Classe.Produto,uFrmLocProduto,classe.funcionario,Classe.Finalizadora,
  uFrmLocFun,uFrmLocFinalizadora;

type
  TfrmRelProduto = class(TForm)
    AdvSmoothExpanderPanel1: TAdvSmoothExpanderPanel;
    Label53: TLabel;
    pnl1: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    dtInicio: TJvDateEdit;
    dtFinal: TJvDateEdit;
    cmbTipo: TComboBox;
    btnVis: TAdvGlowButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    edtCaixa: TEdit;
    Label4: TLabel;
    Label1: TLabel;
    edtSecao: TEdit;
    Label6: TLabel;
    edtSubGrupo: TEdit;
    Label8: TLabel;
    edtFornecedor: TEdit;
    edtSecaoDesc: TEdit;
    edtSubgrupoDesc: TEdit;
    edtFornecedorDesc: TEdit;
    PopupMenu1: TPopupMenu;
    P1: TMenuItem;
    StatusBar1: TStatusBar;
    rdOrdem: TRadioGroup;
    rdOrder: TRadioGroup;
    Label7: TLabel;
    edtProduto: TEdit;
    edtProdutoDesc: TEdit;
    edtProdutoCod: TEdit;
    FileSaveDialog1: TFileSaveDialog;
    Label9: TLabel;
    edtVendedor: TEdit;
    edtVendedorDesc: TEdit;
    Label12: TLabel;
    edtFormaPagamento: TEdit;
    edtFormaPagamentoDesc: TEdit;
    procedure btnVisClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dtInicioKeyPress(Sender: TObject; var Key: Char);
    procedure dtFinalKeyPress(Sender: TObject; var Key: Char);
    procedure P1Click(Sender: TObject);
    procedure edtSecaoExit(Sender: TObject);
    procedure edtSecaoKeyPress(Sender: TObject; var Key: Char);
    procedure edtSubGrupoExit(Sender: TObject);
    procedure edtSubGrupoKeyPress(Sender: TObject; var Key: Char);
    procedure edtFornecedorExit(Sender: TObject);
    procedure edtFornecedorKeyPress(Sender: TObject; var Key: Char);
    procedure edtProdutoClick(Sender: TObject);
    procedure edtProdutoExit(Sender: TObject);
    procedure edtProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure edtVendedorExit(Sender: TObject);
    procedure edtFormaPagamentoExit(Sender: TObject);
    procedure edtFormaPagamentoKeyPress(Sender: TObject; var Key: Char);
    procedure edtVendedorKeyPress(Sender: TObject; var Key: Char);
    procedure edtFormaPagamentoEnter(Sender: TObject);
    procedure edtSecaoEnter(Sender: TObject);
    procedure edtSubGrupoEnter(Sender: TObject);
    procedure edtFornecedorEnter(Sender: TObject);
    procedure edtVendedorEnter(Sender: TObject);
  private
    procedure localizarGrupo;
    procedure localizarSubGrupo;
    procedure localizarFornecedor;
    procedure localizarProduto;
    procedure localizarVendedor;
    procedure localizarPagamento;
  public
    { Public declarations }
  end;

var
  frmRelProduto: TfrmRelProduto;

implementation
uses
  Classe.Funcoes;
{$R *.dfm}

procedure TfrmRelProduto.btnVisClick(Sender: TObject);
var
  oRelatorio :TRelatorio;
begin
  oRelatorio := TRelatorio.Create;
   with oRelatorio do
  begin
  listaString1[0] := edtSecao.Text;
  listaString1[1] := edtSubGrupo.Text;
  listaString1[2] := edtFornecedor.Text;
  listaString1[3] := edtProdutoCod.Text;
  listaString1[4] := edtVendedor.Text;
  listaString1[5] := edtFormaPagamento.Text;
  caixa := edtCaixa.Text;


  periodoInicial := dtInicio.date;
  periodoFinal := dtFinal.date;

  itemIndex := rdOrdem.ItemIndex;
  itemIndex1 := rdOrder.ItemIndex;


  end;

if cmbTipo.ItemIndex = 0 then
begin
variaveissrv.oRelatorioController.RelatorioCurvaABC(oRelatorio);
end;
if cmbTipo.ItemIndex = 1 then
begin
if FileSaveDialog1.Execute then
begin
variaveissrv.oRelatorioController.relatorioListarProduto(oRelatorio,FileSaveDialog1.FileName);
end;
end;
if cmbTipo.ItemIndex = 2 then
begin
variaveissrv.oRelatorioController.relatorioProdutosCancelados(oRelatorio);
  //itens cancelados
end;


oRelatorio.destroy;
end;

procedure TfrmRelProduto.dtFinalKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
btnVis.SetFocus;
end;
end;

procedure TfrmRelProduto.dtInicioKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  dtFinal.setfocus;
end;
end;

procedure TfrmRelProduto.edtFormaPagamentoEnter(Sender: TObject);
begin
edtFormaPagamento.SelectAll;
end;

procedure TfrmRelProduto.edtFormaPagamentoExit(Sender: TObject);
begin
localizarPagamento;
end;

procedure TfrmRelProduto.edtFormaPagamentoKeyPress(Sender: TObject;
  var Key: Char);
begin
if key = #13 then
begin
  edtFormaPagamentoExit(nil);
  btnVis.SetFocus;
end;
end;

procedure TfrmRelProduto.edtFornecedorEnter(Sender: TObject);
begin
edtFornecedor.SelectAll;
end;

procedure TfrmRelProduto.edtFornecedorExit(Sender: TObject);
begin
localizarFornecedor;
end;

procedure TfrmRelProduto.edtFornecedorKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  edtVendedorExit(nil);
  edtVendedor.SetFocus;
end;
end;

procedure TfrmRelProduto.edtProdutoClick(Sender: TObject);
begin
edtProduto.SelectAll;
end;

procedure TfrmRelProduto.edtProdutoExit(Sender: TObject);
begin
localizarProduto;
end;


procedure TfrmRelProduto.edtProdutoKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  edtProdutoExit(nil);
  edtSecao.SetFocus;
end;
end;

procedure TfrmRelProduto.edtSecaoEnter(Sender: TObject);
begin
edtSecao.SelectAll;
end;

procedure TfrmRelProduto.edtSecaoExit(Sender: TObject);
begin
localizarGrupo;
end;

procedure TfrmRelProduto.edtSecaoKeyPress(Sender: TObject; var Key: Char);
begin
if key =#13 then
begin
  edtSecaoExit(nil);
  if edtSubGrupo.enabled then
  begin
  edtSubGrupo.SetFocus;
  end
  else
  begin
    edtFornecedor.SetFocus;
  end;

end;
end;

procedure TfrmRelProduto.edtSubGrupoEnter(Sender: TObject);
begin
edtSubGrupo.SelectAll;
end;

procedure TfrmRelProduto.edtSubGrupoExit(Sender: TObject);
begin
localizarSubGrupo;
end;

procedure TfrmRelProduto.edtSubGrupoKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  edtSubGrupoExit(nil);
  edtFornecedor.SetFocus;
end;
end;

procedure TfrmRelProduto.edtVendedorEnter(Sender: TObject);
begin
edtVendedor.SelectAll;
end;

procedure TfrmRelProduto.edtVendedorExit(Sender: TObject);
begin
localizarVendedor;
end;

procedure TfrmRelProduto.edtVendedorKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  edtVendedorExit(nil);
  edtFormaPagamento.SetFocus;
end;
end;

procedure TfrmRelProduto.FormShow(Sender: TObject);
begin
dtInicio.date := date;
dtFinal.date := date;
end;

procedure TfrmRelProduto.localizarFornecedor;
var
  oFornecedor:TFornecedor;
begin
try
oFornecedor := TFornecedor.Create;
oFornecedor.Codigo := edtFornecedor.Text;
edtFornecedor.Text := zeroEsquerda(edtFornecedor.Text,6);
VariaveisSrv.oFornecedorController.CarregarFornecedor(oFornecedor);

edtFornecedor.text := oFornecedor.codigo;
edtFornecedorDesc.Text := oFornecedor.Pessoa.Nome;

if edtFornecedor.Text = '000000' then
begin
  edtFornecedorDesc.Text := 'TODOS';
//  btnVis.SetFocus;
end
else
begin
//  btnVis.SetFocus;
end;
finally
oFornecedor.Destroy;
end;
end;

procedure TfrmRelProduto.localizarGrupo;
var
  oGrupo:TGrupo;
begin
try
oGrupo := TGrupo.Create;
oGrupo.Codigo := edtSecao.Text;
edtSecao.Text := zeroEsquerda(edtSecao.Text,6);
VariaveisSrv.oGrupoController.CarregarGrupo(oGrupo);

edtSecao.text := oGrupo.Codigo;
edtSecaoDesc.Text := oGrupo.Descricao;

if edtSecao.Text = '000000' then
begin
  edtSubGrupo.Enabled := false;
  edtSecaoDesc.Text := 'TODOS';
//  edtFornecedor.SetFocus;
end
else
begin
  edtSubGrupo.Enabled := true;
//  edtSubGrupo.SetFocus;
end;
finally
oGrupo.Destroy;
end;
end;

procedure TfrmRelProduto.localizarPagamento;
var
  oFinalizadora:TFinalizadora;
begin
try
oFinalizadora := TFinalizadora.Create;
oFinalizadora.Codigo := edtFormaPagamento.Text;
edtFormaPagamento.Text := zeroEsquerda(edtFormaPagamento.Text,3);
VariaveisSrv.oFinalizadoraController.CarregarFinalizadora(oFinalizadora);

edtFormaPagamento.text := oFinalizadora.codigo;
edtFormaPagamentoDesc.Text := oFinalizadora.descricao;

if edtFormaPagamento.Text = '000' then
begin
  edtFormaPagamentoDesc.Text := 'TODOS';
//  btnVis.SetFocus;
end
else
begin
//  btnVis.SetFocus;
end;
finally
oFinalizadora.Destroy;
end;
end;

procedure TfrmRelProduto.localizarProduto;
var
  oProduto:TProduto;
begin
try
oProduto := TProduto.Create;
oProduto.CodigoBarras := edtProduto.Text;
edtProduto.Text := zeroEsquerda(edtProduto.Text,14);
if (VariaveisSrv.oProdutoController.CarregarProduto(oProduto)) then
begin
  edtProduto.text := oProduto.CodigoBarras;
  edtProdutoCod.Text := oProduto.Codigo;
  edtProdutoDesc.Text := oProduto.Descricao;

  if edtProduto.Text = '00000000000000' then
  begin
    edtProdutoDesc.Text := 'TODOS';
    edtSecao.SetFocus;
  end;
end
else
begin
  if edtProduto.Text <> '00000000000000' then
  begin
  edtProduto.Text := TfrmLocProduto.Exibe;
  end
  else
  begin
  edtProdutoCod.text := '000000';
  edtProduto.Text := '00000000000000';
  edtProdutoDesc.Text := 'TODOS';
  end;
end;
finally
oProduto.Destroy;
end;
end;

procedure TfrmRelProduto.localizarSubGrupo;
var
  oSubgrupo:TSubgrupo;
begin
  try
    oSubgrupo := TSubgrupo.Create;

    oSubgrupo.codigoGrupo := edtSecao.Text;
    oSubgrupo.codigo := edtSubGrupo.Text;

    VariaveisSrv.oSubGrupoController.CarregarSubGrupo(oSubgrupo);

    edtSubGrupo.Text := oSubgrupo.codigo;
    edtSubGrupoDesc.Text := oSubgrupo.Descricao;

    if edtSubGrupo.Text = '000000' then
    begin
      edtSubgrupoDesc.Text := 'TODOS';
    end;

//    edtFornecedor.SetFocus;

  finally
     oSubgrupo.Destroy;

  end;
end;

procedure TfrmRelProduto.localizarVendedor;
var
  oFuncionario:TFuncionario;
begin
try
oFuncionario := TFuncionario.Create;
oFuncionario.Codigo := edtVendedor.Text;
edtVendedor.Text := zeroEsquerda(edtVendedor.Text,6);
VariaveisSrv.oFuncionarioController.CarregarFuncionario(oFuncionario);

edtVendedor.text := oFuncionario.codigo;
edtVendedorDesc.Text := oFuncionario.Pessoa.Nome;

if edtVendedor.Text = '000000' then
begin
  edtVendedorDesc.Text := 'TODOS';
//  btnVis.SetFocus;
end
else
begin
//  btnVis.SetFocus;
end;
finally
oFuncionario.Destroy;
end;
end;

procedure TfrmRelProduto.P1Click(Sender: TObject);
begin
if edtSecao.Focused then
begin
edtSecao.Text := TfrmLocGrupo.Exibe;
localizarGrupo;
end;

if edtProduto.Focused then
begin
  edtProduto.Text := TfrmLocProduto.Exibe;
  edtProdutoExit(nil);
end;

if edtSubGrupo.focused then
begin
  edtSubGrupo.Text := TfrmlocSubGrupo.Exibe(edtSecao.Text);
  edtSubGrupoExit(nil);
end;


if edtVendedor.Focused then
begin
  edtVendedor.Text :=TFrmLocFun.Exibe;
  edtVendedorExit(nil);
end;

if edtFormaPagamento.Focused then
begin
  edtFormaPagamento.Text := TfrmLocFinalizadora.Exibe;
  edtFormaPagamentoExit(nil);
end;


end;



end.
