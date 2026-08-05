unit uFrmPreVenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGlowButton,
  Vcl.ExtCtrls, Data.DB, Vcl.Mask, JvExMask, JvToolEdit, JvBaseEdits, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, dxGDIPlusClasses,uFrmLocProduto,Classe.Produto,Classe.Variaveis,Classe.Cliente,uFrmLocCliente,uFrmLocFun,Classe.Funcionario,Conversao,Classe.Prevenda,uFrmPrevenda_pgto,
  Vcl.Menus,uFrmLocPreVenda,uFrmImpressao, Vcl.Buttons;

type
  TFrmPreVenda = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    btnAlterar: TAdvGlowButton;
    btnExcluir: TAdvGlowButton;
    btnIncluir: TAdvGlowButton;
    btnCancelar: TAdvGlowButton;
    btnGravar: TAdvGlowButton;
    Image1: TImage;
    pcPreVenda: TPageControl;
    tsLista: TTabSheet;
    tsDetalhe: TTabSheet;
    gridItem: TDBGrid;
    statusItem: TStatusBar;
    Label2: TLabel;
    Label3: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    edtCEP: TEdit;
    edtComplemento: TEdit;
    edtBairro: TEdit;
    edtNumero: TEdit;
    edtDescricao: TEdit;
    edtCodigo: TEdit;
    edtEndereco: TEdit;
    edtApelido: TEdit;
    edtCelular: TEdit;
    edtTelefone2: TEdit;
    edtObservacao: TEdit;
    edtTelefone1: TEdit;
    edtCPFCNPJ: TEdit;
    edtEmail: TEdit;
    dtCadastro: TDateTimePicker;
    edtLimite: TJvCalcEdit;
    edtUF: TEdit;
    edtCidade: TEdit;
    pnl_codigo_prod: TPanel;
    Label5: TLabel;
    edtProdCodigo: TEdit;
    btnLocalizarProduto: TAdvGlowButton;
    Label6: TLabel;
    edtProdDescricao: TEdit;
    pnl_inf_venda: TPanel;
    Label124: TLabel;
    edtLocFun: TEdit;
    btnLocalizarFuncionario: TAdvGlowButton;
    edtLocFunDesc: TEdit;
    edtLocCLi: TEdit;
    Label1: TLabel;
    btnLocalizarCliente: TAdvGlowButton;
    edtLocCliDesc: TEdit;
    edtPreVendaCod: TEdit;
    btnLocalizarPreVenda: TAdvGlowButton;
    Label27: TLabel;
    dsItem: TDataSource;
    btnIncluirItem: TAdvGlowButton;
    edtProdDesconto: TJvCalcEdit;
    btnTipoDesconto: TSpeedButton;
    edtProdEst: TJvCalcEdit;
    edtProdQtd: TJvCalcEdit;
    edtProdUN: TEdit;
    edtProdVlrTotal: TJvCalcEdit;
    edtProdVlrUn: TJvCalcEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label7: TLabel;
    Label72: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    btnFinalizar: TAdvGlowButton;
    btnExcluirItem: TAdvGlowButton;
    func: TPopupMenu;
    S1: TMenuItem;
    I1: TMenuItem;
    g1: TMenuItem;
    C1: TMenuItem;
    E1: TMenuItem;
    a1: TMenuItem;
    btnImprimir: TButton;
    procedure btnLocalizarProdutoClick(Sender: TObject);
    procedure edtProdQtdExit(Sender: TObject);
    procedure edtLocCLiExit(Sender: TObject);
    procedure edtLocCLiKeyPress(Sender: TObject; var Key: Char);
    procedure edtProdQtdKeyPress(Sender: TObject; var Key: Char);
    procedure edtProdCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure btnLocalizarClienteClick(Sender: TObject);
    procedure btnLocalizarFuncionarioClick(Sender: TObject);
    procedure edtLocFunExit(Sender: TObject);
    procedure edtLocFunKeyPress(Sender: TObject; var Key: Char);
    procedure btnIncluirClick(Sender: TObject);
    procedure edtProdDescontoKeyPress(Sender: TObject; var Key: Char);
    procedure btnIncluirItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtProdCodigoExit(Sender: TObject);
    procedure edtProdVlrUnKeyPress(Sender: TObject; var Key: Char);
    procedure btnExcluirItemClick(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtPreVendaCodKeyPress(Sender: TObject; var Key: Char);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnLocalizarPreVendaClick(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure g1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure a1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure edtLocCLiEnter(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnTipoDescontoClick(Sender: TObject);
  private
    procedure PreencherProduto(oProduto:TProduto);
    procedure PreencherCliente(oCliente:TCliente);
    procedure AtualizarValorTotal;
    procedure HabilitarControles(aOperacao :TOperacao);
    procedure PreencherPreVenda(oPrevenda:TPrevenda);
    procedure HabilitarProduto;
    procedure AtualizarStatusBar;

    procedure IncluirItemTemp;
    procedure ZerarProduto;
    procedure ZerarCliente;

    function CarregarPreVenda:boolean;

    procedure Gravar;
    procedure Cancelar;
    procedure Incluir;
    procedure Excluir;
  public
    { Public declarations }
  end;

var
  FrmPreVenda: TFrmPreVenda;
  I:integer;
  FOperacao:TOperacao;
  oPreVenda:TPrevenda;
  FDescontoTipo: string; // P=Percentual, V=Valor

implementation

{$R *.dfm}


procedure TFrmPreVenda.a1Click(Sender: TObject);
begin
if btnAlterar.Enabled then
btnAlterar.CLick;
end;

procedure TFrmPreVenda.AtualizarStatusBar;
begin
  if oPreVenda <> nil then
  begin
  oPreVenda.valorTotal :=0;
  oPreVenda.valorDesconto :=0;
  end;
    // CARREGAR BARRA ITENS ITENS
  dsItem.DataSet.First;
  while not dsItem.DataSet.Eof do
  begin
    oPreVenda.valorTotal := oPreVenda.valorTotal + dsItem.DataSet.FieldByName('VALOR_TOTAL').AsFloat;
    oPreVenda.valorDesconto := oPreVenda.valorDesconto + dsItem.DataSet.FieldByName('VALOR_DESCONTO').AsFloat;
    dsItem.DataSet.Next;
  end;

  if oPrevenda <> nil then
  begin
  statusItem.Panels[0].Text := 'Itens:   '+ IntToStr(dsItem.DataSet.RecordCount);
  statusItem.Panels[1].Text := 'Valor Desconto:   '+ FormatFloat('###,###,##0.00',oPreVenda.valorDesconto);
  statusItem.Panels[2].Text := 'Valor Total:   '+ FormatFloat('###,###,##0.00',oPreVenda.valorTotal);
  end
  else
  begin
  statusItem.Panels[0].Text := '';
  statusItem.Panels[1].Text := '';
  statusItem.Panels[2].Text := '';
  end;


end;

procedure TFrmPreVenda.AtualizarValorTotal;
begin
if edtProdQtd.Value < 0 then
begin
  ShowMessage('Quantidade não pode ser negativa !');
end;

if edtProdVlrUn.Value < 0 then
begin
  ShowMessage('Valor unitário não pode ser negativo !');
end;

if edtProdDesconto.Value < 0 then
begin
  ShowMessage('Desconto não pode ser negativo !');
end;

  if FDescontoTipo = 'P' then
    edtProdVlrTotal.value := (edtProdQtd.value * edtProdVlrUn.Value) - ((edtProdQtd.value * edtProdVlrUn.Value) * (edtProdDesconto.value / 100))
  else
    edtProdVlrTotal.value := (edtProdQtd.value * edtProdVlrUn.Value) - edtProdDesconto.value;
end;

procedure TFrmPreVenda.BitBtn1Click(Sender: TObject);
var
  nPrevenda:string;
  nTerminal:string;
begin
nPrevenda:= edtPreVendaCod.Text;
nTerminal := VariaveisSrv.oConfiguracoes.terminalNumero;
TfrmImpressao.Imprimir_Prevenda_Completo(nPrevenda,nTerminal);
end;

procedure TFrmPreVenda.btnCancelarClick(Sender: TObject);
begin
Cancelar;
end;

procedure TFrmPreVenda.btnExcluirClick(Sender: TObject);
begin
CarregarPreVenda;
If  MessageDlg('Tem certeza que deseja Excluir Pr� Venda N�: '+edtPreVendaCod.text,mtConfirmation,[mbyes,mbno],0)=mryes then
begin
  VariaveisSrv.oPreVendaController.DeletarPreVenda(oPreVenda);
  HabilitarControles(opNavegar);
end
else
begin
  HabilitarControles(opNavegar);
end;


end;

procedure TFrmPreVenda.btnExcluirItemClick(Sender: TObject);
begin
If  MessageDlg('Voc� tem certeza que deseja excluir o item :?'+dsItem.DataSet.FieldByName('PRODUTO').AsString,mtConfirmation,[mbyes,mbno],0)=mryes then
begin
dsItem.DataSet.Delete;
AtualizarStatusBar;
end;
end;

procedure TFrmPreVenda.btnFinalizarClick(Sender: TObject);
begin
TfrmPreVendaPgto.Exibe(edtPreVendaCod.text)
end;

procedure TFrmPreVenda.btnGravarClick(Sender: TObject);
begin
Gravar;
end;

procedure TFrmPreVenda.btnIncluirClick(Sender: TObject);
begin
HabilitarControles(opNovo);
end;

procedure TFrmPreVenda.btnIncluirItemClick(Sender: TObject);
begin
IncluirItemTemp;
end;

procedure TFrmPreVenda.btnLocalizarClienteClick(Sender: TObject);
begin
edtLocCLi.text := TfrmLocCliente.Exibe;
edtLocCLi.SetFocus;
end;

procedure TFrmPreVenda.btnLocalizarFuncionarioClick(Sender: TObject);
begin
edtLocFun.text := TFrmLocFun.Exibe;
edtLocFun.SetFocus;
end;

procedure TFrmPreVenda.btnLocalizarPreVendaClick(Sender: TObject);
begin
edtPreVendaCod.text := TfrmLocPreVenda.Exibe;
edtPreVendaCod.SelectAll;
end;

procedure TFrmPreVenda.btnLocalizarProdutoClick(Sender: TObject);
begin
edtProdCodigo.text := TfrmLocProduto.Exibe;
end;

procedure TFrmPreVenda.btnTipoDescontoClick(Sender: TObject);
begin
  if FDescontoTipo = 'P' then
  begin
    FDescontoTipo := 'V';
    btnTipoDesconto.Caption := 'R$';
    Label10.Caption := 'Desconto (R$):';
  end
  else
  begin
    FDescontoTipo := 'P';
    btnTipoDesconto.Caption := '%';
    Label10.Caption := 'Desconto (%):';
  end;
  edtProdDesconto.Value := 0;
  AtualizarValorTotal;
end;

procedure TFrmPreVenda.btnImprimirClick(Sender: TObject);
var
  nPrevenda:string;
  nTerminal:string;
begin
nPrevenda:= edtPreVendaCod.Text;
nTerminal := VariaveisSrv.oConfiguracoes.terminalNumero;
TfrmImpressao.Imprimir_Prevenda_Completo(nPrevenda,nTerminal);
end;

procedure TFrmPreVenda.C1Click(Sender: TObject);
begin
if btnCancelar.Enabled then
btnCancelar.Click;
end;

procedure TFrmPreVenda.Cancelar;
begin
HabilitarControles(opNavegar);
end;

function TFrmPreVenda.CarregarPreVenda:boolean;
begin
  if oPreVenda = nil then
  begin
    oPreVenda := TPrevenda.Create;
  end;
  oPreVenda.codigo := edtPreVendaCod.Text;
  oPreVenda.terminal := VariaveisSrv.oConfiguracoes.terminalNumero;
  edtPreVendaCod.text := oPreVenda.codigo;

  if VariaveisSrv.oPreVendaController.CarregarPreVendaTela(oPreVenda) then
  begin

  VariaveisSrv.oPreVendaController.CarregarItensPreVenda(dsItem);
  atualizarStatusBar;
  // sequencial�
  I := dsItem.DataSet.FieldByName('ITEM').AsInteger +1;
  ZerarProduto;
  result := True;

  end
  else
  begin
    result := false;
  end;
end;

procedure TFrmPreVenda.E1Click(Sender: TObject);
begin
if btnExcluir.Enabled then
btnExcluir.Click;
end;

procedure TFrmPreVenda.edtLocCLiEnter(Sender: TObject);
begin
edtLocCLi.SelectAll;
end;

procedure TFrmPreVenda.edtLocCLiExit(Sender: TObject);
var
  oCliente:TCliente;
begin
oCliente := TCliente.Create;
oCliente.codigo := edtLocCLi.text;
if VariaveisSrv.oClienteController.CarregarCliente(oCliente) then
begin
  edtLocCLi.text := oCliente.codigo;
  PreencherCliente(oCliente);
end
else
begin

  if edtLocCLi.text <> '000000' then
  begin
  btnLocalizarCliente.Click;
  edtLocCLi.SetFocus;
  end
  else
  begin
    edtLocCliDesc.text := 'N�O INFORMADO';
  end;
end;

end;

procedure TFrmPreVenda.edtLocCLiKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  HabilitarProduto;
end;
end;

procedure TFrmPreVenda.edtLocFunExit(Sender: TObject);
var
  oFuncionario:TFuncionario;
begin
oFuncionario := TFuncionario.Create;
oFuncionario.codigo := edtLocFun.text;
if VariaveisSrv.oFuncionarioController.CarregarFuncionario(oFuncionario) then
begin
  edtLocFun.text := oFuncionario.codigo;
  edtLocFunDesc.text := oFuncionario.Pessoa.Nome;
end
else
begin
  edtLocFun.text := oFuncionario.Codigo;
  if edtLocFun.text <> '000000' then
  begin
  // validou
  btnLocalizarFuncionario.Click;
  edtLocFun.SetFocus;
  end
  else
  begin
    edtLocFunDesc.text := 'N�O INFORMADO';
  end;
end;

end;

procedure TFrmPreVenda.edtLocFunKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
edtLocCLi.SetFocus;
end;
end;

procedure TFrmPreVenda.edtPreVendaCodKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
HabilitarControles(opAlterar);
end;
end;

procedure TFrmPreVenda.edtProdCodigoExit(Sender: TObject);
var
  oProduto:TProduto;
begin
      if edtProdCodigo.text <> '' then
      begin
        oProduto := TProduto.Create;
        oProduto.CodigoBarras := edtProdCodigo.text;
        oProduto.calcularCodigoBalanca(VariaveisSrv.oConfiguracoes.Balanca.QtdDigitos);
        if VariaveisSrv.oProdutoController.CarregarProduto(oProduto) then
        begin
          edtProdQtd.Value := oProduto.calcularQtdEtiqueta(edtProdCodigo.Text);
          PreencherProduto(oProduto);
          AtualizarValorTotal;

          edtProdQtd.SetFocus;
        end
        else
        begin
          edtProdCodigo.SetFocus;
          btnLocalizarProduto.Click;

        end;
      end;

end;

procedure TFrmPreVenda.edtProdCodigoKeyPress(Sender: TObject; var Key: Char);

begin
  if key = #13 then
  begin

          edtProdQtd.SetFocus;
  end;


end;

procedure TFrmPreVenda.edtProdDescontoKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  btnIncluirItem.setFocus;
end;
end;

procedure TFrmPreVenda.edtProdQtdExit(Sender: TObject);
begin
AtualizarValorTotal;
end;

procedure TFrmPreVenda.edtProdQtdKeyPress(Sender: TObject; var Key: Char);
begin
if Key = #13 then
begin
edtProdVlrUn.setfocus;
end;
end;

procedure TFrmPreVenda.edtProdVlrUnKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
edtProdDesconto.setfocus;
end;
end;

procedure TFrmPreVenda.Excluir;
begin

end;

procedure TFrmPreVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if FOperacao in [opNovo,opAlterar] then
begin
  If  MessageDlg('Tem certeza que deseja sair, o processo de finaliza��o da Pr� Venda n�o foi conclu�do?',mtConfirmation,[mbyes,mbno],0)= mrNo then
  begin
    Action := caNone;
  end;
end;
end;

procedure TFrmPreVenda.FormShow(Sender: TObject);
begin
FDescontoTipo := 'P'; // Padrão: desconto percentual
HabilitarControles(opNavegar);
end;

procedure TFrmPreVenda.g1Click(Sender: TObject);
begin
if btnGravar.Enabled then
btnGravar.Click;
end;

procedure TFrmPreVenda.Gravar;
begin
  if gridItem.DataSource.DataSet.RecordCount = 0 then
  begin
    raise Exception.Create('Nenhum item adicionado !');
  end;

     case FOperacao of
      opNovo: Incluir;
      opAlterar: Incluir;
    end;
      HabilitarControles(opNavegar);
end;

procedure TFrmPreVenda.HabilitarControles(aOperacao: TOperacao);
begin
try
  case aOperacao of
    opNovo:begin
      btnAlterar.Enabled := false;
      btnExcluir.Enabled := False;
      btnIncluir.Enabled := false;
      btnCancelar.Enabled := true;
      btnGravar.Enabled := true;
      btnImprimir.Enabled := false;

      pnl_inf_venda.Enabled := true;

      edtLocFun.SetFocus;

      // cria pre venda vazia
      oPreVenda := TPrevenda.Create;
      oPreVenda.codigo := VariaveisSrv.oUtilsController.RetornaSequencial('PREVENDA','CODIGO');
      oPreVenda.funcionario := VariaveisSrv.oFuncionario.Codigo;

      PreencherPreVenda(oPreVenda);

      edtPreVendaCod.ReadOnly := true;
      btnLocalizarPreVenda.Enabled :=false;

      FOperacao := opNovo;
    end;
    opAlterar:begin
      FOperacao := opAlterar;
      VariaveisSrv.oPreVendaController.DeletarPreVendaItemTemp;

      if CarregarPreVenda then
      begin
      PreencherPreVenda(oPreVenda);
      btnImprimir.Enabled := true;
      btnAlterar.Enabled := false;
      btnExcluir.Enabled := False;
      btnIncluir.Enabled := false;
      btnCancelar.Enabled := true;
      btnGravar.Enabled := true;

      pnl_inf_venda.Enabled := true;
      HabilitarProduto;
      edtLocFun.SetFocus;
      edtPreVendaCod.ReadOnly := true;
      btnLocalizarPreVenda.Enabled :=false;

      end
      else
      begin
        ShowMessage('Pré Venda não localizada !');
        edtPreVendaCod.SelectAll;
      end;

    end;

    opNavegar:begin
      // index do sequencial item
      I :=1;
      // deletar itens na tabela temporaria
      VariaveisSrv.oPreVendaController.DeletarPreVendaItemTemp;
      // controle botoes
      btnAlterar.Enabled := true;
      btnExcluir.Enabled := true;
      btnIncluir.Enabled := True;
      btnCancelar.Enabled := false;
      btnGravar.Enabled := false;

      if oPreVenda <> nil then
      begin
        FreeAndNil(oPrevenda);
      end;

      VariaveisSrv.oPreVendaController.CarregarItensPreVenda(dsItem);
      atualizarStatusBar;
      ZerarProduto;
      ZerarCliente;
      edtPreVendaCod.Text := '';
      edtPreVendaCod.SetFocus;

      edtLocCLi.text := '000000';
      edtLocFun.text := '000000';
      edtLocCliDesc.Text := '';
      edtLocFunDesc.Text := '';
      pnl_inf_venda.Enabled := false;
      pnl_codigo_prod.Enabled := false;


      edtPreVendaCod.ReadOnly := false;
      btnLocalizarPreVenda.Enabled :=true;
      FOperacao := opNavegar;
    end;
  end;
    pcPreVenda.ActivePageIndex := 0;
finally

end;
end;

procedure TFrmPreVenda.HabilitarProduto;
begin
  pnl_codigo_prod.Enabled := True;
  pcPreVenda.ActivePageIndex := 0;
  edtProdCodigo.SetFocus;
end;

procedure TFrmPreVenda.I1Click(Sender: TObject);
begin
if btnIncluir.Enabled then
btnIncluir.Click;
end;

procedure TFrmPreVenda.Incluir;
var
  nPrevenda:string;
  nTerminal:string;
begin
  with oPrevenda do
  begin
    codigo := edtPreVendaCod.text;
    codigoCupom := '';
    funcionario := edtLocFun.Text;
    data := Date;
    cliente := edtLocCli.Text;
    valorAcrescimo := 0;
    terminal := VariaveisSrv.oConfiguracoes.terminalNumero;
    cancelado := 0;
    status := 'A';
    VariaveisSrv.oPreVendaController.InserirPrevenda(oPreVenda);
    ShowMessage('Pré Venda criada com sucesso !');

    If  MessageDlg('Deseja imprimir o cupom de Pr� Venda ?',mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
    nPrevenda:= edtPreVendaCod.Text;
    nTerminal := VariaveisSrv.oConfiguracoes.terminalNumero;
    TfrmImpressao.Imprimir_Prevenda_Completo(nPrevenda,nTerminal);

    end;

  end;
end;

procedure TFrmPreVenda.IncluirItemTemp;
var
  oPreVendaItem:TPrevendaItem;
  pvCodigo:string;

begin
  oPreVendaItem := TPrevendaItem.Create;
  with oPreVendaItem do
  begin
  pvCodigo := edtPreVendaCod.text;



  codigo := pvCodigo + IntToStr(I);
  codigoPrevenda := pvCodigo;
  item := I;
  codigo_barras := edtProdCodigo.text;
  valorUnitario := edtProdVlrUn.Value;
  if FDescontoTipo = 'P' then
    valorDesconto := (edtProdQtd.value * edtProdVlrUn.Value) * (edtProdDesconto.value / 100)
  else
    valorDesconto := edtProdDesconto.Value;
  qtde          := edtProdQtd.value;
  unidade       := edtProdUN.Text;
  terminal      := VariaveisSrv.oConfiguracoes.terminalNumero;
  valorTotal    := edtProdVlrTotal.Value;

  VariaveisSrv.oPreVendaController.InserirPreVendaItemTemp(oPreVendaItem);


  Inc(I);
  end;

  VariaveisSrv.oPreVendaController.CarregarItensPreVenda(dsItem);


  oPreVendaItem.Destroy;

  atualizarStatusBar;

  ZerarProduto;
  edtProdCodigo.SetFocus;

end;

procedure TFrmPreVenda.PreencherCliente(oCliente: TCliente);
begin
  with oCliente do
  begin
    edtLocCliDesc.Text := Pessoa.Nome;
    edtCodigo.text:=Codigo;
    edtDescricao.text:=Pessoa.Nome;
    edtApelido.Text:=Pessoa.Apelido;
    edtTelefone1.text:=Pessoa.Telefone1;
    edtTelefone2.text:=Pessoa.Telefone2;
    edtCelular.text:=pessoa.Celular1;
    edtEmail.text:=Pessoa.Email;
    edtCPFCNPJ.text:=Pessoa.CPFCNPJ;

    edtObservacao.text:=Observacao;
    dtCadastro.date := DataCadastro;

    edtEndereco.Text:=Endereco.Endereco;
    edtNumero.Text:=Endereco.Numero;
    edtBairro.Text:=Endereco.Bairro;
    edtUF.Text := Endereco.UF;
    edtCidade.text :=   endereco.Cidade;
    edtCEP.Text:=Endereco.CEP;
    edtComplemento.Text:=Endereco.Complemento;
    edtLimite.Value := LimiteCredito;

  end;
end;

procedure TFrmPreVenda.PreencherPreVenda(oPrevenda: TPrevenda);
var
  oCliente:TCliente;
  oFuncionario:TFuncionario;
begin
  with oPrevenda do
  begin
    edtPreVendaCod.text := codigo;

    oCliente := TCliente.Create;
    oFuncionario := TFuncionario.Create;

    oCliente.codigo := Cliente;
    oFuncionario.Codigo := Funcionario;

    VariaveisSrv.oFuncionarioController.CarregarFuncionario(oFuncionario);
    VariaveisSrv.oClienteController.CarregarCliente(oCliente);


    edtLocFun.text := oFuncionario.Codigo;
    edtLocCLi.text := oCliente.codigo;


    edtLocFunDesc.text := oFuncionario.Pessoa.Nome;
    edtLocCliDesc.text := oCliente.Pessoa.Nome;

    oFuncionario.Destroy;
    oCliente.Destroy;
  end;

end;

procedure TFrmPreVenda.PreencherProduto(oProduto: TProduto);
begin
  with oProduto do
  begin
    edtProdCodigo.text := CodigoBarras;
    edtProdEst.value := Estoque;
    edtProdDescricao.text := Descricao;
    edtProdVlrUn.value := Preco;
    edtProdUN.text := Unidade;
  end;
end;

procedure TFrmPreVenda.S1Click(Sender: TObject);
begin
Close;
end;

procedure TFrmPreVenda.ZerarCliente;
begin
    edtLocCliDesc.Text :='';
    edtCodigo.text:='';
    edtDescricao.text:='';
    edtApelido.Text:='';
    edtTelefone1.text:='';
    edtTelefone2.text:='';
    edtCelular.text:='';
    edtEmail.text:='';
    edtCPFCNPJ.text:='';

    edtObservacao.text:='';
    dtCadastro.date := 0;

    edtEndereco.Text:='';
    edtNumero.Text:='';
    edtBairro.Text:='';
    edtUF.Text := '';
    edtCidade.text :=   '';
    edtCEP.Text:='';
    edtComplemento.Text:='';
    edtLimite.Value := 0;
end;

procedure TFrmPreVenda.ZerarProduto;
begin
    edtProdCodigo.text := '';
    edtProdQtd.Value := 1;
    edtProdEst.value := 0;
    edtProdDescricao.text := '';
    edtProdVlrUn.value := 0;
    edtProdDesconto.Value := 0;
    edtProdUN.text := '';
    edtProdVlrTotal.Value := 0;
end;

end.
