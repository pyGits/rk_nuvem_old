unit uFrmConfiguracoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGlowButton,
  Vcl.ExtCtrls, Vcl.ComCtrls,Vcl.Printers,Vcl.FileCtrl,Conversao,Classe.Configuracoes,Classe.Variaveis,Classe.Funcoes,
  frxClass,uFrmEtiquetaConfigurar, Vcl.Menus, Vcl.Mask, JvExMask, JvToolEdit,
  JvBaseEdits, Vcl.Buttons,Global,ConfiguracaoModel,ConfiguracaoRepositoryImpl;

type
  TfrmConfiguracoes = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    btnAlterar: TAdvGlowButton;
    btnCancelar: TAdvGlowButton;
    btnGravar: TAdvGlowButton;
    pcGeral: TPageControl;
    tsLista: TTabSheet;
    GroupBox1: TGroupBox;
    chkCargaAut: TCheckBox;
    GroupBox2: TGroupBox;
    edtBalancaDir: TEdit;
    Label1: TLabel;
    PrintDialog1: TPrintDialog;
    btnDirBal: TButton;
    OpenDialog1: TOpenDialog;
    frxEtiqueta: TfrxReport;
    GroupBox4: TGroupBox;
    edtPreVendaTerminal: TEdit;
    PopupMenu1: TPopupMenu;
    E1: TMenuItem;
    C1: TMenuItem;
    g1: TMenuItem;
    GroupBox5: TGroupBox;
    chkEstoqueMinimo: TCheckBox;
    tsValidade: TTabSheet;
    GroupBox6: TGroupBox;
    edtValidadeDias: TEdit;
    Label2: TLabel;
    btnZerarBD: TButton;
    edtQtdDigitosBal: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtPortaCom: TEdit;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    tsPDV: TTabSheet;
    edtLimiteDescPerc: TJvCalcEdit;
    Label71: TLabel;
    tsNFCe: TTabSheet;
    Label59: TLabel;
    edtIdToken: TEdit;
    edtToken: TEdit;
    Label60: TLabel;
    edtCaminho: TEdit;
    Label18: TLabel;
    sbtnCaminhoCert: TSpeedButton;
    edtSenha: TEdit;
    Label57: TLabel;
    tsEtiqueta: TTabSheet;
    GroupBox3: TGroupBox;
    lblImpressora: TLabel;
    Label3: TLabel;
    chkETQTela: TCheckBox;
    btnImpressoraETQ: TButton;
    btnEditor: TButton;
    cbImpressaoEtiqueta: TComboBox;
    Label8: TLabel;
    edtIpServidorSyspdv: TEdit;
    Label9: TLabel;
    btnImportarIBPT: TButton;
    procedure btnImpressoraETQClick(Sender: TObject);
    procedure btnDirBalClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnEditorClick(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure g1Click(Sender: TObject);
    procedure btnZerarBDClick(Sender: TObject);
    procedure sbtnCaminhoCertClick(Sender: TObject);
    procedure btnImportarIBPTClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure HabilitarControles(aOperacao :TOperacao);
    procedure PreencherCampos(oConfiguracoes:TConfiguracoes);
    procedure Alterar;
    procedure Gravar;
    procedure Cancelar;
  end;

var
  frmConfiguracoes: TfrmConfiguracoes;
  FOperacao:TOperacao;

implementation

{$R *.dfm}

procedure TfrmConfiguracoes.btnImportarIBPTClick(Sender: TObject);
begin
  OpenDialog1.Filter := 'Arquivos CSV (*.csv)|*.csv';
  OpenDialog1.DefaultExt := 'csv';
  OpenDialog1.Options := OpenDialog1.Options + [ofFileMustExist];

  if OpenDialog1.Execute then
  begin
    ImportarIBPTUseCase.Execute(OpenDialog1.FileName);
  end;
  ShowMessage('Tabela IBPT Importada com sucesso !');
end;

procedure TfrmConfiguracoes.btnImpressoraETQClick(Sender: TObject);
begin
  if PrintDialog1.Execute then
    lblImpressora.Caption := Printer.Printers[Printer.PrinterIndex] ;
end;

procedure TfrmConfiguracoes.btnZerarBDClick(Sender: TObject);
begin
//para excluir o registro do BD:
  If  MessageDlg('Você tem certeza que deseja zerar o banco de dados, FAÇA BACKUP ANTES ? ',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
    if InputBox('Senha','Digite a senha técnica','') = 'rk26281356' then
    begin
      VariaveisSrv.oUtilsController.zerarBD;
      showmessage('Zerado com sucesso !');
    end
    else
    begin
      ShowMessage('Senha incorreta !');
    end;

  end;
end;

procedure TfrmConfiguracoes.Alterar;
var
  config:TConfiguracaoModel;
begin
  config := TConfiguracaoModel.create;
  config.porta_impressora := edtPortaCom.Text;
  config.etiqueta_modo_importacao := cbImpressaoEtiqueta.ItemIndex;
  config.syspdv_ip := edtIpServidorSyspdv.Text;

  with VariaveisSrv.oConfiguracoes do
  begin
    Etiqueta.VisualizarImpressao := chkETQTela.checked;
    Etiqueta.Impressora := lblImpressora.caption;
    Produto.UtilizarCargaAutomatica := chkCargaAut.Checked;
    Balanca.DiretorioBalanca := edtBalancaDir.text;
    terminalNumero := edtPreVendaTerminal.Text;
    Validade.alertaDias := StrToInt(edtValidadeDias.Text);
    balanca.QtdDigitos := StrToInt(edtQtdDigitosBal.Text);
    impressora_porta := edtPortaCom.Text;
    PDV_Limite_Desconto_Perc := edtLimiteDescPerc.Value;

    NFCe.idToken := edtIdToken.Text;
    nfce.token := edtToken.Text;
    nfce.diretorio := edtCaminho.Text;
    nfce.senha := edtSenha.Text;


    ETIQUETA_MODO_IMPORTACAO := cbImpressaoEtiqueta.ItemIndex;
    SYSPDV_IP := edtIpServidorSyspdv.Text;


    VariaveisSrv.oUtilsController.GravarConfiguracoesBD(VariaveisSrv.oConfiguracoes);

    FConfiguracaoRepositoryFirebird.SalvarConfig(config);

  end;

  showmessage('Configuração Atualizada com sucesso !');

end;

procedure TfrmConfiguracoes.C1Click(Sender: TObject);
begin
if btnCancelar.Enabled then
begin
  btnCancelar.Click;
end;
end;

procedure TfrmConfiguracoes.Cancelar;
begin
HabilitarControles(opNavegar);
end;

procedure TfrmConfiguracoes.E1Click(Sender: TObject);
begin
if btnAlterar.Enabled then
begin
  btnAlterar.Click;
end;
end;

procedure TfrmConfiguracoes.FormShow(Sender: TObject);
begin
HabilitarControles(opNavegar);
end;

procedure TfrmConfiguracoes.g1Click(Sender: TObject);
begin
if btnGravar.Enabled then
begin
  btnGravar.Click;
end;
end;

procedure TfrmConfiguracoes.Gravar;
begin
      case FOperacao of
      opAlterar: Alterar;
    end;
      HabilitarControles(opNavegar);
end;

procedure TfrmConfiguracoes.HabilitarControles(aOperacao: TOperacao);
begin
try
  case aOperacao of
      opAlterar:begin
        try
        tsLista.Enabled := true;
        tsValidade.Enabled := true;
        tsPDV.Enabled := true;
        tsNFCe.Enabled := true;
        tsEtiqueta.enabled := true;

        pcGeral.ActivePage := tsLista;
        // botoes
        btnAlterar.Enabled := false;
        btnCancelar.Enabled := true;
        btnGravar.Enabled := true;

        VariaveisSrv.oUtilsController.CarregarConfiguracoesBD(VariaveisSrv.oConfiguracoes);
        PreencherCampos(VariaveisSrv.oConfiguracoes);
        FOperacao := opAlterar;
        finally

        end;
      end;

      opNavegar:begin
        pcGeral.ActivePage := tsLista;
        tsLista.Enabled := false;
        tsValidade.Enabled := false;
        tsPDV.Enabled := false;
        tsNFCe.Enabled := false;
                tsEtiqueta.enabled := false;
        // botoes
        btnAlterar.Enabled := true;
        btnCancelar.Enabled := false;
        btnGravar.Enabled := false;

        VariaveisSrv.oUtilsController.CarregarConfiguracoesBD(VariaveisSrv.oConfiguracoes);
        PreencherCampos(VariaveisSrv.oConfiguracoes);

        FOperacao := opNavegar;

      end;




    end;



finally

end;


end;

procedure TfrmConfiguracoes.PreencherCampos(oConfiguracoes: TConfiguracoes);
begin
  with VariaveisSrv.oConfiguracoes do
  begin
  lblImpressora.caption := Etiqueta.Impressora;
  chkETQTela.Checked := Etiqueta.VisualizarImpressao;
  chkCargaAut.Checked := Produto.UtilizarCargaAutomatica;
  edtBalancaDir.Text := Balanca.DiretorioBalanca;
  edtPreVendaTerminal.Text := terminalNumero;
  edtValidadeDias.Text :=   IntToStr(Validade.alertaDias);
  edtQtdDigitosBal.Text := IntToStr(balanca.QtdDigitos);
  edtPortaCom.Text := impressora_porta;
  edtLimiteDescPerc.Value := PDV_Limite_Desconto_Perc;

  edtIdToken.Text := NFCe.idToken;
  edtToken.Text := NFCe.token;
  edtCaminho.text := nfce.diretorio;
  edtSenha.Text := nfce.senha;


    cbImpressaoEtiqueta.ItemIndex := ETIQUETA_MODO_IMPORTACAO;
     edtIpServidorSyspdv.Text := SYSPDV_IP;
  end;
end;

procedure TfrmConfiguracoes.sbtnCaminhoCertClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione o Certificado';
  OpenDialog1.DefaultExt := '*.pfx';
  OpenDialog1.Filter := 'Arquivos PFX (*.pfx)|*.pfx|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ExtractFileDir(application.ExeName);
  if OpenDialog1.Execute then
  begin
    edtCaminho.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmConfiguracoes.btnAlterarClick(Sender: TObject);
begin
  HabilitarControles(opAlterar);
end;

procedure TfrmConfiguracoes.btnCancelarClick(Sender: TObject);
begin
Cancelar;
end;

procedure TfrmConfiguracoes.btnDirBalClick(Sender: TObject);
var
  diretorio : string;
begin
  // Ask the user to select a required directory, starting with C:
  if selectdirectory('Selecione o diretorio de exportação', 'C:\', diretorio)
  then edtBalancaDir.text := diretorio;


end;

procedure TfrmConfiguracoes.btnEditorClick(Sender: TObject);
var
  uFrmEtiquetaConf :TfrmEtiquetaConfig;
begin
  uFrmEtiquetaConf := TfrmEtiquetaConfig.Create(self);
  uFrmEtiquetaConf.ShowModal;
end;

procedure TfrmConfiguracoes.btnGravarClick(Sender: TObject);
begin
Gravar;
end;

end.
