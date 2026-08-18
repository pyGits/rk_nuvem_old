unit uFrmCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls, AdvGlowButton, Vcl.ExtCtrls,Classe.Cliente,Conversao,Classe.Variaveis,Classe.Funcoes,
  ACBrBase, ACBrSocket, ACBrCEP, Vcl.Mask, JvExMask, JvToolEdit, JvBaseEdits;

type
  TfrmCliente = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    Label124: TLabel;
    btnAlterar: TAdvGlowButton;
    btnExcluir: TAdvGlowButton;
    btnIncluir: TAdvGlowButton;
    btnCancelar: TAdvGlowButton;
    btnGravar: TAdvGlowButton;
    edtLoc: TEdit;
    cbPesq: TComboBox;
    pcCliente: TPageControl;
    tsLista: TTabSheet;
    tsDetalhe: TTabSheet;
    func: TPopupMenu;
    S1: TMenuItem;
    I1: TMenuItem;
    g1: TMenuItem;
    C1: TMenuItem;
    E1: TMenuItem;
    a1: TMenuItem;
    Grid: TDBGrid;
    edtCEP: TEdit;
    edtComplemento: TEdit;
    cbUF: TComboBox;
    edtBairro: TEdit;
    edtNumero: TEdit;
    edtDescricao: TEdit;
    edtCodigo: TEdit;
    edtEndereco: TEdit;
    edtApelido: TEdit;
    edtCelular: TEdit;
    edtTelefone2: TEdit;
    cbCidade: TComboBox;
    edtObservacao: TEdit;
    edtTelefone1: TEdit;
    edtCPFCNPJ: TEdit;
    edtEmail: TEdit;
    Label8: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label17: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label18: TLabel;
    Label15: TLabel;
    Label12: TLabel;
    Label11: TLabel;
    dtCadastro: TDateTimePicker;
    Label13: TLabel;
    ds: TDataSource;
    cbTipo: TComboBox;
    Label14: TLabel;
    ACBRCep1: TACBrCEP;
    edtLimite: TJvCalcEdit;
    Label72: TLabel;
    Label20: TLabel;
    edtCreditoUtilizado: TJvCalcEdit;
    Label21: TLabel;
    Label22: TLabel;
    edtDtNascimento: TDateTimePicker;
    edtPercDesconto: TJvCalcEdit;
    Label23: TLabel;
    procedure S1Click(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure g1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure a1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure edtDescricaoKeyPress(Sender: TObject; var Key: Char);
    procedure cbUFChange(Sender: TObject);
    procedure edtCPFCNPJKeyPress(Sender: TObject; var Key: Char);
    procedure edtCEPKeyPress(Sender: TObject; var Key: Char);
    procedure ACBRCep1BuscaEfetuada(Sender: TObject);
    procedure GridCellClick(Column: TColumn);
    procedure GridDblClick(Sender: TObject);
    procedure pcClienteChange(Sender: TObject);
    procedure edtLocChange(Sender: TObject);
    procedure edtCPFCNPJExit(Sender: TObject);
    procedure edtLimiteKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    procedure HabilitarControles(aOperacao :TOperacao);
    procedure PreencherCampos(oCliente:TCliente);
    procedure Alterar;
    procedure Incluir;
    procedure Gravar;
    procedure Cancelar;
    procedure Excluir;
  end;

var
  frmCliente: TfrmCliente;
  FOperacao:TOperacao;

implementation

{$R *.dfm}

procedure TfrmCliente.a1Click(Sender: TObject);
begin
if btnAlterar.enabled then
btnAlterar.Click;
end;

procedure TfrmCliente.ACBRCep1BuscaEfetuada(Sender: TObject);
var
   i : integer;
begin
    for I := 0 to ACBrCEP1.Enderecos.Count -1 do
    begiN
    edtEndereco.Text := ACBrCEP1.Enderecos[i].Logradouro;
    edtComplemento.Text := ACBrCEP1.Enderecos[i].Complemento;
    cbUF.ItemIndex := cbUF.Items.IndexOf(ACBrCEP1.Enderecos[i].UF);
    VariaveisSrv.oUtilsController.PreencheCidade(cbUF.Text,cbCidade);
    cbCidade.ItemIndex :=   cbCidade.Items.IndexOf(RemoveAcento(ACBrCEP1.Enderecos[i].Municipio));
    edtBairro.Text := ACBrCEP1.Enderecos[i].Bairro;

    end;
end;

procedure TfrmCliente.Alterar;
var
  oCliente:TCliente;
begin
  oCliente := TCliente.Create;
  with oCliente do
  begin
    Codigo := edtCodigo.text;
    Pessoa.Nome := edtDescricao.text;
    Pessoa.Apelido := edtApelido.Text;
    Pessoa.Telefone1 := edtTelefone1.text;
    Pessoa.Telefone2 := edtTelefone2.text;
    pessoa.Celular1 := edtCelular.text;
    Pessoa.Email := edtEmail.text;
    Pessoa.CPFCNPJ := edtCPFCNPJ.text;
    Pessoa.tipoPessoa := cbTipo.ItemIndex;
    Pessoa.dataNascimento := edtDtNascimento.Date;

    DataCadastro := dtCadastro.date;
    Observacao := edtObservacao.text;

    Endereco.Endereco := edtEndereco.Text;
    Endereco.Numero := edtNumero.Text;
    Endereco.Bairro := edtBairro.Text;
    Endereco.Cidade := cbCidade.Text;
    Endereco.UF := cbUF.Text;
    Endereco.CEP := edtCEP.Text;
    Endereco.Complemento := edtComplemento.Text;
    LimiteCredito := edtLimite.Value;
    UtilizadoCredito := edtCreditoUtilizado.Value;
    PercDesconto := edtPercDesconto.Value;
    VariaveisSrv.oClienteController.alterarCliente(oCliente);
  end;

  oCliente.Destroy;

end;

procedure TfrmCliente.btnAlterarClick(Sender: TObject);
begin
  HabilitarControles(opAlterar);
end;

procedure TfrmCliente.btnCancelarClick(Sender: TObject);
begin
Cancelar;
end;

procedure TfrmCliente.btnExcluirClick(Sender: TObject);
begin
excluir;
end;

procedure TfrmCliente.btnGravarClick(Sender: TObject);
begin
Gravar;
end;

procedure TfrmCliente.btnIncluirClick(Sender: TObject);
begin
HabilitarControles(opNovo);
end;

procedure TfrmCliente.C1Click(Sender: TObject);
begin
if btnCancelar.enabled then
btnCancelar.Click;
end;

procedure TfrmCliente.Cancelar;
begin
  HabilitarControles(opNavegar);
end;

procedure TfrmCliente.cbUFChange(Sender: TObject);
begin
VariaveisSrv.oUtilsController.PreencheCidade(cbUF.Text,cbCidade);
end;

procedure TfrmCliente.E1Click(Sender: TObject);
begin
if btnExcluir.enabled then
btnExcluir.Click;
end;

procedure TfrmCliente.edtCEPKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  if edtCEP.text <> '' then
  begin
    ACBrCEP1.BuscarPorCEP(edtCEP.text);
  end;
  edtEndereco.SetFocus;
end;
end;

procedure TfrmCliente.edtCPFCNPJExit(Sender: TObject);
var
  oCliente:TCliente;
begin
  if FOperacao = opNovo then
  begin
    oCliente := TCliente.Create;
    oCliente.Pessoa.CPFCNPJ := edtCPFCNPJ.text;
    if VariaveisSrv.oClienteController.VerificaCliente(oCliente) then
    begin

        // ja existe Cliente cadastrado com esse cnpj
        If  MessageDlg('J� existe um Cliente cadastrado com esse CNPJ/CPF, deseja visualizar ?',mtConfirmation,[mbyes,mbno],0)=mryes then
        begin
          PreencherCampos(oCliente);
          HabilitarControles(opAlterar);
        end
        else
        begin
          btnCancelar.Click;
        end;


    end;

    oCliente.Destroy;
  end;

end;

procedure TfrmCliente.edtCPFCNPJKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  // cnpj
  if Length(edtCPFCNPJ.text) = 14 then
  begin
    cbTipo.ItemIndex := 1;
  end
  else
  begin
    cbTipo.ItemIndex := 0;
  end;
  edtDescricao.setfocus;


end;
end;

procedure TfrmCliente.edtDescricaoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmCliente.edtLimiteKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
btnGravar.SetFocus;
end;
end;

procedure TfrmCliente.edtLocChange(Sender: TObject);
begin
  if cbPesq.ItemIndex = 0 then
  begin
      VariaveisSrv.oClienteController.PreencherGrid(edtloc.text,ds,nome);
  end
  else
  begin
      VariaveisSrv.oClienteController.PreencherGrid(edtloc.text,ds,codigo);
  end;

end;

procedure TfrmCliente.Excluir;
var
  oCliente:TCliente;
begin
    If  MessageDlg('Tem certeza que deseja excluir o Cliente: '+grid.Fields[1].AsString   ,mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
      oCliente:= TCliente.Create;
      oCliente.codigo := grid.Fields[0].AsString;
      VariaveisSrv.oClienteController.ExcluirCliente(oCliente);
      HabilitarControles(opNavegar);
      oCliente.Destroy;
    end;
end;

procedure TfrmCliente.FormShow(Sender: TObject);
begin
HabilitarControles(opNavegar);
end;

procedure TfrmCliente.g1Click(Sender: TObject);
begin
if btnGravar.enabled then
btnGravar.Click;
end;

procedure TfrmCliente.Gravar;
begin
     case FOperacao of
      opNovo: Incluir;
      opAlterar: Alterar;
    end;
      HabilitarControles(opNavegar);
end;

procedure TfrmCliente.GridCellClick(Column: TColumn);
var
  oCliente:TCliente;
begin
  if FOperacao = opNavegar then
  begin
      oCliente := TCliente.Create;
      oCliente.Codigo := grid.Fields[0].AsString;
      VariaveisSrv.oClienteController.CarregarCliente(oCliente);
      PreencherCampos(oCliente);
      oCliente.Destroy;
  end;
end;

procedure TfrmCliente.GridDblClick(Sender: TObject);
begin
if btnAlterar.Enabled then
btnAlterar.Click;
end;

procedure TfrmCliente.HabilitarControles(aOperacao: TOperacao);
var
  oCliente:TCliente;
begin
try
  case aOperacao of
    opNovo:begin
      edtCodigo.Enabled := true;
      // foco pagina
      tsDetalhe.Enabled := true;
      pcCliente.ActivePage := tsDetalhe;
      // botoes
      btnAlterar.Enabled := false;
      btnExcluir.Enabled := false;
      btnIncluir.Enabled := false;
      btnCancelar.Enabled := true;
      btnGravar.Enabled := true;
      edtLoc.Enabled := false;
      // grid
      oCliente := TCliente.Create;
      oCliente.Codigo := VariaveisSrv.oUtilsController.RetornaSequencial('Cliente','CODIGO');
      oCliente.DataCadastro := Date;
      PreencherCampos(oCliente);
      freeandnil(oCliente);
      //
      edtCPFCNPJ.setfocus;

      FOperacao := opNovo;
    end;
    opAlterar:begin
          if edtCodigo.Text <> '' then
      begin
        try
        edtCodigo.Enabled := false;
        tsDetalhe.Enabled := true;
        pcCliente.ActivePage := tsDetalhe;
        // botoes
        btnAlterar.Enabled := false;
        btnExcluir.Enabled := false;
        btnIncluir.Enabled := false;
        btnCancelar.Enabled := true;
        btnGravar.Enabled := true;
        edtLoc.Enabled := false;



        oCliente := TCliente.Create;
        oCliente.Codigo := grid.Fields[0].AsString;
        VariaveisSrv.oClienteController.CarregarCliente(oCliente);
        PreencherCampos(oCliente);
        FOperacao := opAlterar;
        finally
          FreeAndNil(oCliente);
        end;
      end;




    end;

    opNavegar:begin
      FOperacao := opNavegar;
      pcCliente.ActivePage := tsLista;
      tsDetalhe.Enabled := false;
      // botoes
      btnAlterar.Enabled := true;
      btnExcluir.Enabled := true;
      btnIncluir.Enabled := true;
      btnCancelar.Enabled := false;
      btnGravar.Enabled := false;
      edtLoc.Enabled := true;

      oCliente := TCliente.Create;
      PreencherCampos(oCliente);
      VariaveisSrv.oClienteController.PreencherGrid('',ds,nome);
      VariaveisSrv.oUtilsController.PreencheUF(cbUF);


      oCliente.Destroy;

    end;
  end;
finally

end;
end;

procedure TfrmCliente.I1Click(Sender: TObject);
begin
if btnIncluir.enabled then
btnIncluir.Click;
end;

procedure TfrmCliente.Incluir;
var
  oCliente:TCliente;
begin
  oCliente := TCliente.Create;
  with oCliente do
  begin
    Codigo := edtCodigo.text;
    Pessoa.Nome := edtDescricao.text;
    Pessoa.Apelido := edtApelido.Text;
    Pessoa.Telefone1 := edtTelefone1.text;
    Pessoa.Telefone2 := edtTelefone2.text;
    pessoa.Celular1 := edtCelular.text;
    Pessoa.Email := edtEmail.text;
    Pessoa.CPFCNPJ := edtCPFCNPJ.text;
    Pessoa.tipoPessoa := cbTipo.ItemIndex;
    Pessoa.dataNascimento := edtDtNascimento.Date;

    Observacao := edtObservacao.text;

    Endereco.Endereco := edtEndereco.Text;
    Endereco.Numero := edtNumero.Text;
    Endereco.Bairro := edtBairro.Text;
    Endereco.Cidade := cbCidade.Text;
    Endereco.UF := cbUF.Text;
    Endereco.CEP := edtCEP.Text;
    Endereco.Complemento := edtComplemento.Text;
    LimiteCredito := edtLimite.Value;
    PercDesconto := edtPercDesconto.Value;

    VariaveisSrv.oClienteController.InserirCliente(oCliente);
  end;

  oCliente.Destroy;
end;

procedure TfrmCliente.pcClienteChange(Sender: TObject);
begin
if (pcCliente.ActivePage = tsLista) and ((FOperacao = opAlterar) or (FOperacao = opNovo)) then
begin
If  MessageDlg('Deseja sair do processo de cadastro ? o Cliente n�o sera salvo',mtConfirmation,[mbyes,mbno],0)=mryes then
begin
btnCancelar.Click;
pcCliente.ActivePage := tsLista;
end
else
begin
pcCliente.ActivePage := tsDetalhe;
end;
end;
end;

procedure TfrmCliente.PreencherCampos(oCliente: TCliente);
begin
  with oCliente do
  begin
  edtCodigo.text:=Codigo;
  edtDescricao.text:=Pessoa.Nome;
  edtApelido.Text:=Pessoa.Apelido;
  edtTelefone1.text:=Pessoa.Telefone1;
  edtTelefone2.text:=Pessoa.Telefone2;
  edtCelular.text:=pessoa.Celular1;
  edtEmail.text:=Pessoa.Email;
  edtCPFCNPJ.text:=Pessoa.CPFCNPJ;
  edtDtNascimento.Date := Pessoa.dataNascimento;

  edtObservacao.text:=Observacao;
  dtCadastro.date := DataCadastro;
  cbTipo.ItemIndex := Pessoa.tipoPessoa;
  edtEndereco.Text:=Endereco.Endereco;
  edtNumero.Text:=Endereco.Numero;
  edtBairro.Text:=Endereco.Bairro;
  cbUF.ItemIndex := cbUF.Items.IndexOf(Endereco.UF);
  VariaveisSrv.oUtilsController.PreencheCidade(cbUF.Text,cbCidade);
  cbCidade.ItemIndex :=   cbCidade.Items.IndexOf(RemoveAcento(endereco.Cidade));
  edtCEP.Text:=Endereco.CEP;
  edtComplemento.Text:=Endereco.Complemento;
  edtLimite.Value := LimiteCredito;
  edtCreditoUtilizado.Value := UtilizadoCredito;
  edtPercDesconto.Value := PercDesconto;

  end;
end;

procedure TfrmCliente.S1Click(Sender: TObject);
begin
Close;
end;

end.
