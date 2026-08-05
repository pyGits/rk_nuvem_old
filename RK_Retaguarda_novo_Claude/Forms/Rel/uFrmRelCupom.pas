unit uFrmRelCupom;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  AdvGlowButton, Vcl.Mask, JvExMask, JvToolEdit, AdvSmoothPanel,
  AdvSmoothExpanderPanel,Classe.Relatorio,Classe.Variaveis, Vcl.Menus,
  JvBaseEdits, Classe.Funcionario, Classe.Finalizadora, uFrmLocVendedor, uFrmLocFormaPagamento, Classe.Funcoes;

type
  TfrmRelCupom = class(TForm)
    AdvSmoothExpanderPanel1: TAdvSmoothExpanderPanel;
    Label53: TLabel;
    pnl1: TPanel;
    Label2: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    dtInicio: TJvDateEdit;
    dtFinal: TJvDateEdit;
    edtCaixa: TEdit;
    cmbTipo: TComboBox;
    btnVis: TAdvGlowButton;
    analitico: TRadioGroup;
    rgCancelado: TRadioGroup;
    cbCupom: TComboBox;
    PopupMenu1: TPopupMenu;
    F1: TMenuItem;
    GroupBox1: TGroupBox;
    cbFiltro: TComboBox;
    edtValor: TJvCalcEdit;
    Label72: TLabel;
    edtVendedor: TEdit;
    edtVendedorDesc: TEdit;
    edtFormaPagamento: TEdit;
    edtFormaPagamentoDesc: TEdit;
    Label12: TLabel;
    Label9: TLabel;
    P1: TMenuItem;
    Label13: TLabel;
    edtCpfCnpj: TEdit;
    procedure btnVisClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dtInicioKeyPress(Sender: TObject; var Key: Char);
    procedure dtFinalKeyPress(Sender: TObject; var Key: Char);
    procedure F1Click(Sender: TObject);
    procedure edtVendedorExit(Sender: TObject);
    procedure edtVendedorKeyPress(Sender: TObject; var Key: Char);
    procedure edtVendedorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtVendedorEnter(Sender: TObject);
    procedure edtFormaPagamentoExit(Sender: TObject);
    procedure edtFormaPagamentoKeyPress(Sender: TObject; var Key: Char);
    procedure edtFormaPagamentoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtFormaPagamentoEnter(Sender: TObject);
    procedure P1Click(Sender: TObject);
  private
    { Private declarations }
    procedure localizarVendedor;
    procedure localizarPagamento;
    procedure abrirLocalizacaoVendedor;
    procedure abrirLocalizacaoPagamento;
  public
    { Public declarations }
  end;

var
  frmRelCupom: TfrmRelCupom;

implementation

{$R *.dfm}

procedure TfrmRelCupom.btnVisClick(Sender: TObject);
var
  oRelatorio :TRelatorio;
begin
oRelatorio := TRelatorio.create;
case cmbTipo.ItemIndex of
0:begin
//Agrupado por finalizadora
  with oRelatorio do
  begin
//  Tipo := 0;
  caixa := edtCaixa.Text;
  periodoInicial := dtInicio.date;
  periodoFinal := dtFinal.date;
  filtro1 := cbFiltro.Text;
  valor1 := edtValor.Value;
  listaString1[0] := edtVendedor.Text;
  listaString1[1] := edtFormaPagamento.Text;
  listaString1[2] := Trim(edtCpfCnpj.Text);

  itemIndex := rgCancelado.ItemIndex;

    case analitico.ItemIndex of
    0:begin
    //Simples
    detalhado := false;
    end;
    1:begin
    detalhado := true;
    end;
  end;
    oRelatorio.Fiscal := cbCupom.ItemIndex;

    variaveissrv.oRelatorioController.RelatorioCupom(oRelatorio);

  end;



end;

end;
oRelatorio.Destroy;
end;

procedure TfrmRelCupom.dtFinalKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  btnVis.SetFocus;
end;
end;

procedure TfrmRelCupom.dtInicioKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  dtFinal.setFocus;
end;
end;

procedure TfrmRelCupom.F1Click(Sender: TObject);
begin
Close;
end;

procedure TfrmRelCupom.FormShow(Sender: TObject);
begin
dtInicio.date := date;
dtFinal.date := date;
edtVendedor.Text := '000000';
edtVendedorDesc.Text := 'TODOS';
edtFormaPagamento.Text := '000';
edtFormaPagamentoDesc.Text := 'TODOS';
end;

procedure TfrmRelCupom.localizarVendedor;
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
end
else
begin
end;
finally
oFuncionario.Destroy;
end;
end;

procedure TfrmRelCupom.P1Click(Sender: TObject);
begin
if edtVendedor.Focused then
begin
  abrirLocalizacaoVendedor;
end;
if edtFormaPagamento.Focused then
begin
  abrirLocalizacaoPagamento;
end;
end;

procedure TfrmRelCupom.localizarPagamento;
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
end
else
begin
end;
finally
oFinalizadora.Destroy;
end;
end;

procedure TfrmRelCupom.edtVendedorEnter(Sender: TObject);
begin
edtVendedor.SelectAll;
end;

procedure TfrmRelCupom.edtVendedorExit(Sender: TObject);
begin
localizarVendedor;
end;

procedure TfrmRelCupom.edtVendedorKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  localizarVendedor;
  edtFormaPagamento.SetFocus;
end;
end;

procedure TfrmRelCupom.edtVendedorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
if Key = VK_F2 then
begin
  abrirLocalizacaoVendedor;
  Key := 0;
end;
end;

procedure TfrmRelCupom.edtFormaPagamentoEnter(Sender: TObject);
begin
edtFormaPagamento.SelectAll;
end;

procedure TfrmRelCupom.edtFormaPagamentoExit(Sender: TObject);
begin
localizarPagamento;
end;

procedure TfrmRelCupom.edtFormaPagamentoKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  localizarPagamento;
  btnVis.SetFocus;
end;
end;

procedure TfrmRelCupom.edtFormaPagamentoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
if Key = VK_F2 then
begin
  abrirLocalizacaoPagamento;
  Key := 0;
end;
end;

procedure TfrmRelCupom.abrirLocalizacaoVendedor;
begin
edtVendedor.text := TfrmLocVendedor.Exibe;
localizarVendedor;
end;

procedure TfrmRelCupom.abrirLocalizacaoPagamento;
begin
//edtFormaPagamento.text := TfrmLocFormaPagamento.Exibe;
//localizarPagamento;
end;

end.
