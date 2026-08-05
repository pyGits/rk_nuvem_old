unit uFrmProprio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  AdvGlowButton, Vcl.ExtCtrls, Vcl.Menus,Conversao,Classe.Proprio,Classe.Variaveis,Classe.Funcoes,
  ACBrBase, ACBrSocket, ACBrCEP,uFrmLocIBGE;

type
  TfrmProprio = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    btnAlterar: TAdvGlowButton;
    btnCancelar: TAdvGlowButton;
    btnGravar: TAdvGlowButton;
    pcGrupo: TPageControl;
    tsDetalhe: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    edtCodigo: TEdit;
    edtDescricao: TEdit;
    Label3: TLabel;
    edtFantasia: TEdit;
    Label12: TLabel;
    edtCPFCNPJ: TEdit;
    edtIE: TEdit;
    edtCEP: TEdit;
    Label8: TLabel;
    Label5: TLabel;
    edtEndereco: TEdit;
    Label6: TLabel;
    edtNumero: TEdit;
    Label7: TLabel;
    edtComplemento: TEdit;
    Label9: TLabel;
    edtBairro: TEdit;
    cbUF: TComboBox;
    Label11: TLabel;
    Label10: TLabel;
    cbCidade: TComboBox;
    Label15: TLabel;
    edtEmail: TEdit;
    Label16: TLabel;
    edtTelefone1: TEdit;
    Label18: TLabel;
    edtCelular: TEdit;
    Label13: TLabel;
    func: TPopupMenu;
    S1: TMenuItem;
    g1: TMenuItem;
    C1: TMenuItem;
    a1: TMenuItem;
    ACBRCep1: TACBrCEP;
    edtIbge: TEdit;
    Label14: TLabel;
    btnLocalizarIBGE: TButton;
    procedure S1Click(Sender: TObject);
    procedure g1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure a1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure edtDescricaoKeyPress(Sender: TObject; var Key: Char);
    procedure edtCEPKeyPress(Sender: TObject; var Key: Char);
    procedure ACBRCep1BuscaEfetuada(Sender: TObject);
    procedure cbUFChange(Sender: TObject);
    procedure btnLocalizarIBGEClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure HabilitarControles(aOperacao :TOperacao);
    procedure PreencherCampos(oProprio:TProprio);
    procedure Alterar;
    procedure Gravar;
    procedure Cancelar;
  end;

var
  frmProprio: TfrmProprio;
  FOperacao:TOperacao;

implementation

{$R *.dfm}

procedure TfrmProprio.a1Click(Sender: TObject);
begin
if btnAlterar.Enabled then
begin
  btnAlterar.Click;
end;
end;

procedure TfrmProprio.ACBRCep1BuscaEfetuada(Sender: TObject);
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

procedure TfrmProprio.Alterar;
var
  oProprio:TProprio;
begin
  oProprio := TProprio.Create;
  with oProprio do
  begin
    Codigo := edtCodigo.text;
    Pessoa.Nome := edtDescricao.text;
    Pessoa.Apelido := edtFantasia.Text;
    Pessoa.Telefone1 := edtTelefone1.text;

    pessoa.Celular1 := edtCelular.text;
    Pessoa.Email := edtEmail.text;
    Pessoa.CPFCNPJ := edtCPFCNPJ.text;

    IE :=edtIE.text;
    IBGE :=edtIbge.text;


    Endereco.Endereco := edtEndereco.Text;
    Endereco.Numero := edtNumero.Text;
    Endereco.Bairro := edtBairro.Text;
    Endereco.Cidade := cbCidade.Text;
    Endereco.UF := cbUF.Text;
    Endereco.CEP := edtCEP.Text;
    Endereco.Complemento := edtComplemento.Text;

    VariaveisSrv.oProprioController.alterarProprio(oProprio);
  end;

  oProprio.Destroy;

end;

procedure TfrmProprio.btnAlterarClick(Sender: TObject);
begin
  HabilitarControles(opAlterar);
end;

procedure TfrmProprio.btnCancelarClick(Sender: TObject);
begin
Cancelar;
end;

procedure TfrmProprio.btnGravarClick(Sender: TObject);
begin
Gravar;
end;

procedure TfrmProprio.btnLocalizarIBGEClick(Sender: TObject);
begin
 edtIbge.Text := frmLocIbge.Exibe;
end;

procedure TfrmProprio.C1Click(Sender: TObject);
begin
if btnCancelar.Enabled then
begin
  btnCancelar.Click;
end;
end;

procedure TfrmProprio.Cancelar;
begin
HabilitarControles(opNavegar);
end;

procedure TfrmProprio.cbUFChange(Sender: TObject);
begin
VariaveisSrv.oUtilsController.PreencheCidade(cbUF.Text,cbCidade);
end;

procedure TfrmProprio.edtCEPKeyPress(Sender: TObject; var Key: Char);
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

procedure TfrmProprio.edtDescricaoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmProprio.FormShow(Sender: TObject);
begin
HabilitarControles(opNavegar);
end;

procedure TfrmProprio.g1Click(Sender: TObject);
begin
if btnGravar.Enabled then
begin
  btnGravar.Click;
end;
end;

procedure TfrmProprio.Gravar;
begin
      case FOperacao of
      opAlterar: Alterar;
    end;
      HabilitarControles(opNavegar);
end;

procedure TfrmProprio.HabilitarControles(aOperacao: TOperacao);
var
  oProprio:TProprio;
begin
try
  case aOperacao of
      opAlterar:begin
        try
        edtCodigo.Enabled := false;
        tsDetalhe.Enabled := true;
        pcGrupo.ActivePage := tsDetalhe;
        // botoes
        btnAlterar.Enabled := false;
        btnCancelar.Enabled := true;
        btnGravar.Enabled := true;

        oProprio := TProprio.Create;
        oProprio.Codigo := '000001';
        VariaveisSrv.oProprioController.CarregarProprio(oProprio);
        PreencherCampos(oProprio);
        FOperacao := opAlterar;
        edtDescricao.setFocus;
        finally
        FreeAndNil(oProprio);
        end;
      end;

      opNavegar:begin
        tsDetalhe.Enabled := false;
        // botoes
        btnAlterar.Enabled := true;
        btnCancelar.Enabled := false;
        btnGravar.Enabled := false;

        oProprio := TProprio.Create;
        VariaveisSrv.oProprioController.CarregarProprio(oProprio);
        VariaveisSrv.oUtilsController.PreencheUF(cbUF);
        PreencherCampos(oProprio);

        FOperacao := opNavegar;
        freeandnil(oProprio);

      end;




    end;



finally

end;




end;




procedure TfrmProprio.PreencherCampos(oProprio: TProprio);
begin
 with oProprio do
  begin
  edtCodigo.text:=Codigo;
  edtDescricao.text:=Pessoa.Nome;
  edtFantasia.Text:=Pessoa.Apelido;
  edtTelefone1.text:=Pessoa.Telefone1;
  edtCelular.text:=pessoa.Celular1;
  edtEmail.text:=Pessoa.Email;
  edtCPFCNPJ.text:=Pessoa.CPFCNPJ;

  edtIE.text:=IE;

  edtEndereco.Text:=Endereco.Endereco;
  edtNumero.Text:=Endereco.Numero;
  edtBairro.Text:=Endereco.Bairro;
    cbUF.ItemIndex := cbUF.Items.IndexOf(Endereco.UF);
    VariaveisSrv.oUtilsController.PreencheCidade(cbUF.Text,cbCidade);
    cbCidade.ItemIndex :=   cbCidade.Items.IndexOf(RemoveAcento(endereco.Cidade));
  edtCEP.Text:=Endereco.CEP;
  edtComplemento.Text:=Endereco.Complemento;
  edtIbge.text := IBGE;

  end;
end;

procedure TfrmProprio.S1Click(Sender: TObject);
begin
Close;
end;

end.
