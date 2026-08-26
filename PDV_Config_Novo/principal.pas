unit principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,modulo, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMetropolis, dxSkinMetropolisDark, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinOffice2016Colorful,
  dxSkinOffice2016Dark, dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic,
  dxSkinSharp, dxSkinSharpPlus, dxSkinSilver, dxSkinSpringTime, dxSkinStardust,
  dxSkinSummer2008, dxSkinTheAsphaltWorld, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxMaskEdit, cxSpinEdit, cxDBEdit, cxTextEdit, Vcl.DBCtrls,
  Data.DB, Vcl.ExtCtrls, Vcl.Buttons, sBitBtn, AdvGlowButton, Vcl.StdCtrls,
  Vcl.Samples.Spin, sPageControl, Vcl.ComCtrls, RzBtnEdt, Vcl.Mask, RzEdit,Uni,pcnConversao,pcnConversaoNFe,ACBrDFeSSL,blcksock,System.TypInfo,
  ACBrBase, ACBrDFe, ACBrNFe,unit2,acbrutil,ACBrSATClass,ACBrPosPrinter,System.Win.Registry,INIFiles,Vcl.Printers;

type
  TfrmPrincipal = class(TForm)
    DataSource1: TDataSource;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel5: TPanel;
    pgConfigFiscal: TPageControl;
    tsSAT: TTabSheet;
    tsNFCe: TTabSheet;
    lSSLLib: TLabel;
    lCryptLib: TLabel;
    lHttpLib: TLabel;
    lXmlSign: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    lSSLLib1: TLabel;
    cbSSLLib: TComboBox;
    cbCryptLib: TComboBox;
    cbHttpLib: TComboBox;
    cbXmlSignLib: TComboBox;
    gbCertificado: TGroupBox;
    Label18: TLabel;
    Label57: TLabel;
    sbtnCaminhoCert: TSpeedButton;
    Label58: TLabel;
    sbtnGetCert: TSpeedButton;
    btnSerie: TSpeedButton;
    edtCaminho: TEdit;
    edtSenha: TEdit;
    edtNumSerie: TEdit;
    edtIdToken: TEdit;
    edtToken: TEdit;
    cbSSLType: TComboBox;
    btnAvancar: TAdvGlowButton;
    btnCancelar: TAdvGlowButton;
    sPageControl1: TsPageControl;
    sTabSheet4: TsTabSheet;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    sTabSheet6: TsTabSheet;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    edtEmitenteCNPJ: TEdit;
    edtEmitenteIE: TEdit;
    edtEmitenteIM: TEdit;
    sTabSheet7: TsTabSheet;
    Label22: TLabel;
    Label23: TLabel;
    edtSWHouseCNPJ: TEdit;
    edtSWHouseAC: TEdit;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    lblFortesNome: TLabel;
    edtFortesLarg: TSpinEdit;
    edtFortesTopo: TSpinEdit;
    edtFortesFundo: TSpinEdit;
    edtFortesEsq: TSpinEdit;
    edtFortesDir: TSpinEdit;
    Button2: TButton;
    cbUsarFortes: TRadioButton;
    chkPreview: TCheckBox;
    AdvGlowButton1: TAdvGlowButton;
    btnDefinirImpr: TsBitBtn;
    GroupBox2: TGroupBox;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    BitBtn1: TBitBtn;
    rdUsarEscPos: TRadioButton;
    cbEscPosModelo: TComboBox;
    cbEscPosPorta: TComboBox;
    cbEscPosPagCod: TComboBox;
    edtEscPosCol: TSpinEdit;
    edtEscPosEspacLin: TSpinEdit;
    edtEscPosLinPular: TSpinEdit;
    chkEscPos1Linha: TCheckBox;
    ComboGuilhotina: TComboBox;
    Label44: TLabel;
    ComboImpressora: TComboBox;
    lbl1: TLabel;
    EditQtdLinhas: TSpinEdit;
    lbl2: TLabel;
    CheckHabGuilhotina: TCheckBox;
    CheckReimpressao: TCheckBox;
    btn1: TAdvGlowButton;
    Panel1: TPanel;
    rdLocalGaveta: TRadioGroup;
    cb_bal_modelo: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cb_bal_baudrate: TComboBox;
    Label38: TLabel;
    cb_bal_stop: TComboBox;
    cb_bal_porta: TComboBox;
    Label3: TLabel;
    Label37: TLabel;
    cb_bal_hand: TComboBox;
    Label40: TLabel;
    cb_parity: TComboBox;
    cb_bal_time_out: TEdit;
    Label39: TLabel;
    Label6: TLabel;
    cb_bal_databits: TComboBox;
    Panel20: TPanel;
    Label43: TLabel;
    Panel21: TPanel;
    EditQtdDigitos: TSpinEdit;
    chkLeituraAutomatica: TCheckBox;
    chk2Etiqueta: TCheckBox;
    Panel2: TPanel;
    Panel3: TPanel;
    ed_server: TRzEdit;
    ed_base: TRzButtonEdit;
    Label10: TLabel;
    ed_base_local: TRzButtonEdit;
    Label12: TLabel;
    TabSheet4: TTabSheet;
    Panel7: TPanel;
    Label13: TLabel;
    Panel8: TPanel;
    Panel25: TPanel;
    Panel29: TPanel;
    Panel4: TPanel;
    edtNumCaixa: TRzEdit;
    Label19: TLabel;
    ACBrNFe1: TACBrNFe;
    OpenDialog1: TOpenDialog;
    rdTipoPDV: TRadioGroup;
    cbSATModelo: TComboBox;
    edtSATCaminhoDLL: TRzEdit;
    edtSATUF: TRzEdit;
    edtSATCodigo: TRzEdit;
    edtSATVersao: TRzEdit;
    cbChamadaDLL: TComboBox;
    chkSATValida: TCheckBox;
    ACBrPosPrinter1: TACBrPosPrinter;
    checkImpressao: TCheckBox;
    chkInformarVendedor: TCheckBox;
    chkVendaInicio: TCheckBox;
    edtLimiteDiversos: TRzNumericEdit;
    chkDescSub: TCheckBox;
    chkJanelas: TCheckBox;
    chkCod99: TCheckBox;
    chkPerguntaImprimir: TCheckBox;
    edtSerie: TSpinEdit;
    edtNNFce: TEdit;
    Label14: TLabel;
    Label20: TLabel;
    edtViasSanFun: TSpinEdit;
    Label21: TLabel;
    edtLogoMarca: TRzEdit;
    SpeedButton2: TSpeedButton;
    Label26: TLabel;
    edtConfigAnt: TAdvGlowButton;
    chkGavInvertida: TCheckBox;
    Label30: TLabel;
    edtCodigoDiversos: TRzEdit;
    PrintDialog1: TPrintDialog;
    chkClienteAvulso: TCheckBox;
    chkExibeFechamento: TCheckBox;
    chkClienteIdentificaCompleto: TCheckBox;
    Label61: TLabel;
    edtHoraVirada: TRzEdit;
    procedure FormShow(Sender: TObject);
    procedure cbSSLLibChange(Sender: TObject);
    procedure cbCryptLibChange(Sender: TObject);
    procedure cbHttpLibChange(Sender: TObject);
    procedure cbXmlSignLibChange(Sender: TObject);
    procedure sbtnCaminhoCertClick(Sender: TObject);
    procedure btnSerieClick(Sender: TObject);
    procedure btnAvancarClick(Sender: TObject);
    procedure rdUsarEscPosClick(Sender: TObject);
    procedure cbUsarFortesClick(Sender: TObject);
    procedure cbSATModeloChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure rdTipoPDVClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure ed_base_localClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure edtConfigAntClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnDefinirImprClick(Sender: TObject);
    procedure ed_baseButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
  function BoolToInt( aValue : Boolean) : Integer;
  function IntToBool(aValue : integer):Boolean;

    procedure lerparametrosNFCe;
    procedure lerparametrosSAT;
    procedure AtualizaSSLLibsCombo;


    procedure GravarConfiguracoes;
    procedure LerConfiguracoes;

    Function LerIni(sArquivo, Secao, Linha: String; Def: String): String;
    function HoraViradaNormalizada(out AHora: string): Boolean;
    procedure GarantirColunaHoraVirada;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.AtualizaSSLLibsCombo;
begin
cbSSLLib.ItemIndex := Integer( ACBrNFe1.Configuracoes.Geral.SSLLib );
 cbCryptLib.ItemIndex := Integer( ACBrNFe1.Configuracoes.Geral.SSLCryptLib );
 cbHttpLib.ItemIndex := Integer( ACBrNFe1.Configuracoes.Geral.SSLHttpLib );
 cbXmlSignLib.ItemIndex := Integer( ACBrNFe1.Configuracoes.Geral.SSLXmlSignLib );

 cbSSLType.Enabled := (ACBrNFe1.Configuracoes.Geral.SSLHttpLib in [httpWinHttp, httpOpenSSL]);
end;

function TfrmPrincipal.BoolToInt(aValue: Boolean): Integer;
begin
  if aValue then result := 1 else result := 0;
end;

procedure TfrmPrincipal.btn1Click(Sender: TObject);
var
  I: Integer;
  F: TEXTFILE;
begin

  AssignFile(F, ComboImpressora.Text);
  rewrite(F);
  writeln(F, 'RK Sistema - TESTE DE IMPRESSAO - 1');
  writeln(F, 'RK Sistema - TESTE DE IMPRESSAO - 2');
  writeln(F, 'RK Sistema - TESTE DE IMPRESSAO - 3');
  writeln(F, 'RK Sistema - TESTE DE IMPRESSAO - 4');

  for I := 0 to EditQtdLinhas.Value do
  begin
    writeln(F, '');
  end;

  closefile(F);
end;

procedure TfrmPrincipal.btnAvancarClick(Sender: TObject);
begin
GravarConfiguracoes;
LerConfiguracoes;
ShowMessage('Salvo com sucesso');
end;

procedure TfrmPrincipal.btnCancelarClick(Sender: TObject);
begin
Close;
end;

procedure TfrmPrincipal.btnDefinirImprClick(Sender: TObject);
begin
  if PrintDialog1.Execute then
    lblFortesNome.Caption := Printer.Printers[Printer.PrinterIndex];
end;

procedure TfrmPrincipal.btnSerieClick(Sender: TObject);
var
  I: Integer;
  ASerie: String;
  AddRow: Boolean;
begin
  frSelecionarCertificado := TfrSelecionarCertificado.Create(Self);
  try
    ACBrNFe1.SSL.LerCertificadosStore;
    AddRow := False;

    with frSelecionarCertificado.StringGrid1 do
    begin
      ColWidths[0] := 220;
      ColWidths[1] := 250;
      ColWidths[2] := 120;
      ColWidths[3] := 80;
      ColWidths[4] := 150;
      Cells[ 0, 0 ] := 'Num.S�rie';
      Cells[ 1, 0 ] := 'Raz�o Social';
      Cells[ 2, 0 ] := 'CNPJ';
      Cells[ 3, 0 ] := 'Validade';
      Cells[ 4, 0 ] := 'Certificadora';
    end;

    For I := 0 to ACBrNFe1.SSL.ListaCertificados.Count-1 do
    begin
      with ACBrNFe1.SSL.ListaCertificados[I] do
      begin
        ASerie := NumeroSerie;
        if (CNPJ <> '') then
        begin
          with frSelecionarCertificado.StringGrid1 do
          begin
            if Addrow then
              RowCount := RowCount + 1;

            Cells[ 0, RowCount-1] := NumeroSerie;
            Cells[ 1, RowCount-1] := RazaoSocial;
            Cells[ 2, RowCount-1] := CNPJ;
            Cells[ 3, RowCount-1] := FormatDateBr(DataVenc);
            Cells[ 4, RowCount-1] := Certificadora;
            AddRow := True;
          end;
        end;
      end;
    end;

    frSelecionarCertificado.ShowModal;

    if frSelecionarCertificado.ModalResult = mrOK then
      edtNumSerie.Text := frSelecionarCertificado.StringGrid1.Cells[ 0,
                            frSelecionarCertificado.StringGrid1.Row];

  finally
     frSelecionarCertificado.Free;
  end;
end;

procedure TfrmPrincipal.cbCryptLibChange(Sender: TObject);
begin
  try
    if cbCryptLib.ItemIndex <> -1 then
      ACBrNFe1.Configuracoes.Geral.SSLCryptLib := TSSLCryptLib(cbCryptLib.ItemIndex);
  finally
    AtualizaSSLLibsCombo;
  end;
end;

procedure TfrmPrincipal.cbHttpLibChange(Sender: TObject);
begin
  try
    if cbHttpLib.ItemIndex <> -1 then
      ACBrNFe1.Configuracoes.Geral.SSLHttpLib := TSSLHttpLib(cbHttpLib.ItemIndex);
  finally
    AtualizaSSLLibsCombo;
  end;
end;

procedure TfrmPrincipal.cbSATModeloChange(Sender: TObject);
begin
  if cbSATModelo.Items[cbSATModelo.ItemIndex] = 'Gertec' then
  begin
    edtSATCaminhoDLL.Text := ExtractFilePath(Application.ExeName)+'dllSat\Gertec\dllsat.dll';
    edtSATCodigo.Text := '123456789';
    edtSATVersao.Text := '0.07';
    cbChamadaDLL.ItemIndex := 1;
  end
  else
  if cbSATModelo.Items[cbSATModelo.ItemIndex] = 'Control ID' then
  begin
    edtSATCaminhoDLL.Text := ExtractFilePath(Application.ExeName)+'dllSat\Control ID\libsatid.dll';
    edtSATCodigo.Text := '123456789';
    edtSATVersao.Text := '0.07';
    cbChamadaDLL.ItemIndex := 1;
  end
  else
  begin
    edtSATCaminhoDLL.Text := ExtractFilePath(Application.ExeName)+'dllSat\'+cbSATModelo.Text+'\dllsat.dll';
    edtSATCodigo.Text := '123456789';
    edtSATVersao.Text := '0.07';
    cbChamadaDLL.ItemIndex := 2;
  end;
end;

procedure TfrmPrincipal.cbSSLLibChange(Sender: TObject);
begin
  try
    if cbSSLLib.ItemIndex <> -1 then
      ACBrNFe1.Configuracoes.Geral.SSLLib := TSSLLib(cbSSLLib.ItemIndex);
  finally
    AtualizaSSLLibsCombo;
  end;
end;

procedure TfrmPrincipal.cbUsarFortesClick(Sender: TObject);
begin
  rdUsarEscPos.Checked := False;
end;

procedure TfrmPrincipal.cbXmlSignLibChange(Sender: TObject);
begin
  try
    if cbXmlSignLib.ItemIndex <> -1 then
      ACBrNFe1.Configuracoes.Geral.SSLXmlSignLib := TSSLXmlSignLib(cbXmlSignLib.ItemIndex);
  finally
    AtualizaSSLLibsCombo;
end;
end;

procedure TfrmPrincipal.edtConfigAntClick(Sender: TObject);
var
ArqINI: string;
INI: TIniFile;
  Registro: TRegistry;
begin

  ArqINI := 'C:\Antigo_System_RK\PDV\RK_Pdv.ini';
  INI := TIniFile.Create(ArqINI);
  try
    cbChamadaDLL.ItemIndex    := INI.ReadInteger('SAT','Modelo',0);
    edtCaminho.Text         := INI.ReadString('SAT','NomeDLL','C:\SAT\SAT.DLL');
    edtSATCodigo.Text := INI.ReadString('SAT','CodigoAtivacao','123456');
    edtSATUF.Text          := INI.ReadString('SAT','CodigoUF','35');
    edtNumCaixa.Text    := INI.ReadString('SAT','NumeroCaixa','1');
    edtSATVersao.Text      := FloatToString( INI.ReadFloat('SAT','versaoDadosEnt', cversaoDadosEnt) );

    cbEscPosModelo.ItemIndex := INI.ReadInteger('PosPrinter', 'Modelo', Integer(ACBrPosPrinter1.Modelo));
    cbEscPosPorta.Text := INI.ReadString('PosPrinter','Porta',ACBrPosPrinter1.Porta);
    cbEscPosPagCod.ItemIndex := INI.ReadInteger('PosPrinter','PaginaDeCodigo',Integer(ACBrPosPrinter1.PaginaDeCodigo));
    ACBrPosPrinter1.Device.ParamsString := INI.ReadString('PosPrinter','ParamsString','');
    edtEscPosCol.Value := INI.ReadInteger('PosPrinter','Colunas',ACBrPosPrinter1.ColunasFonteNormal);
    edtEscPosEspacLin.Value := INI.ReadInteger('PosPrinter','EspacoLinhas',ACBrPosPrinter1.EspacoEntreLinhas);
    edtEscPosLinPular.Value := INI.ReadInteger('PosPrinter','LinhasEntreCupons',ACBrPosPrinter1.LinhasEntreCupons);
    chkEscPos1Linha.Checked := INI.ReadBool('EscPos','ImprimirItemUmaLinha',false);

    edtEmitenteCNPJ.Text := INI.ReadString('Emit','CNPJ','');
    edtEmitenteIE.Text   := INI.ReadString('Emit','IE','');
    edtEmitenteIM.Text   := INI.ReadString('Emit','IM','');

    edtSWHouseCNPJ.Text       := INI.ReadString('SwH','CNPJ','11111111111111');
    edtSWHouseAC.Text := INI.ReadString('SwH','Assinatura','');

    cbUsarFortes.Checked   := INI.ReadBool('Fortes','UsarFortes', True) ;
    edtFortesLarg.Value        := INI.ReadInteger('Fortes','Largura',0);
    edtFortesTopo.Value     := INI.ReadInteger('Fortes','MargemTopo',0);
    edtFortesFundo.Value    := INI.ReadInteger('Fortes','MargemFundo',0);
    edtFortesEsq.Value := INI.ReadInteger('Fortes','MargemEsquerda',0);
    edtFortesDir.Value  := INI.ReadInteger('Fortes','MargemDireita',0);
    chkPreview.Checked      := INI.ReadBool('Fortes','Preview',True);

    lblFortesNome.Caption := INI.ReadString('Printer','Name','');


    CheckReimpressao.Checked := INI.ReadBool('REIMPRESSAO','HABILITA',CheckReimpressao.Checked);
    // ===================================================================================


  if LerINI('C:\Antigo_System_RK\PDV\Cfg\cfg_sat.ini','SAT','VALIDASAT','1') = '1' then
  begin
    chkSATValida.checked := True;
  end
  else
  if LerINI('C:\Antigo_System_RK\PDV\Cfg\cfg_sat.ini','SAT','VALIDASAT','1') = '0' then
  begin
    chkSATValida.checked := False;
  end;

  rdTipoPDV.ItemIndex := StrToInt(LerIni('C:\Antigo_System_RK\PDV\Cfg\cfg_sat.ini','CONFIGURACOES','FISCAL','0'));
  rdLocalGaveta.ItemIndex := StrToInt( LerIni('C:\Antigo_System_RK\PDV\Cfg\cfg_sat.ini','GAVETA','LOCAL','0'));
  ComboImpressora.Text  := LerIni(  'C:\Antigo_System_RK\PDV\Cfg\cfg_sat.ini','IMPRESSORA','impnaof','LPT1');

  chkLeituraAutomatica.Checked := StrToBool(LerIni('C:\Antigo_System_RK\PDV\Cfg\cfg_sat.ini','BALANCA','LAUTO',''));
  chk2Etiqueta.Checked := StrToBool(LerIni('C:\Antigo_System_RK\PDV\Cfg\cfg_sat.ini','BALANCA','2ETQ',''));

  cbSATModelo.ItemIndex  := StrToInt(LerIni('C:\Antigo_System_RK\PDV\Cfg\cfg_sat.ini','SAT','Modelo','1'));
  chkVendaInicio.checked := StrToBool(LerIni('C:\Antigo_System_RK\PDV\Cfg\cfg_sat.ini','ADICIONAL','INFORMA_CLIENTE_INICIO','false'));
  chkJanelas.Checked :=StrToBool(LerIni('C:\Antigo_System_RK\PDV\Cfg\cfg_sat.ini','ADICIONAL','PERMITE_SISTEMA_JANELAS','false'));

  //============================================================================================
  // BALANCA
  Registro            := TRegistry.Create;
  Registro.RootKey    := HKEY_LOCAL_MACHINE;
  if Registro.OpenKey('SOFTWARE',false) then
  begin
     if Registro.OpenKey('S7',false) then
     begin
       if Registro.openkey('PDV',false) then
       begin
         (*************** BALANCA ******************)
         if Registro.OpenKey('Balanca',false) then
         begin
           cb_bal_modelo.ItemIndex := strtoint(Registro.ReadString('Modelo'));
           // Modelos --> 0 --> Nenhum , 1 --> Filizola, 2 --> Toledo
            cb_bal_baudrate.ItemIndex := StrToInt(Registro.ReadString('Baudrate'));
            cb_bal_databits.ItemIndex := StrToInt(Registro.ReadString('Databits'));
            cb_bal_porta.ItemIndex := cb_bal_porta.Items.IndexOf(Registro.ReadString('Porta'));
            cb_bal_time_out.Text := Registro.ReadString('Timeout');

         end
         else
         begin
//           application.messagebox('Houve falha na leitura do resgistro da Balan�a!'+
//           ' Favor contactar o suporte!','Erro',mb_ok+mb_iconerror);
         end;
         Registro.CloseKey;
       end
       else
       begin
//          application.messagebox('Houve falha na leitura do resgistro do PDV!'+
//          ' Favor contactar o suporte!','Erro',mb_ok+mb_iconerror);
       end;
     end
     else
     begin
//       application.messagebox('Houve falha na leitura do registro de configura��es!'+
//       ' Favor contactar o suporte!','Erro',mb_ok+mb_iconerror);

     end;
  end
  else
  begin
//    application.messagebox('Houve falha na leitura do registro de configura��es!'+
//    ' Favor contactar o suporte!','Erro',mb_ok+mb_iconerror);
  end;
  Registro.Free;


  finally

  end;

end;

procedure TfrmPrincipal.ed_baseButtonClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione o banco';
  OpenDialog1.DefaultExt := '*.fdb';
  OpenDialog1.Filter := 'Arquivos FDB (*.FDB)|*.FDB|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ExtractFileDir(application.ExeName);
  if OpenDialog1.Execute then
  begin
    ed_base_local.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmPrincipal.ed_base_localClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione o banco';
  OpenDialog1.DefaultExt := '*.fdb';
  OpenDialog1.Filter := 'Arquivos FDB (*.FDB)|*.FDB|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ExtractFileDir(application.ExeName);
  if OpenDialog1.Execute then
  begin
    ed_base_local.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
// OPCOES EM COMBOBOX
lerparametrosNFCe;
lerparametrosSAT;
LerConfiguracoes;
PageControl1.TabIndex := 0;
end;

// A coluna da hora de virada e nova. O PDV a cria na sua propria rotina de
// atualizacao de banco, mas o Config pode ser aberto antes disso - e a query
// tem campos persistentes, entao sem a coluna nem a tela abriria.
procedure TfrmPrincipal.GarantirColunaHoraVirada;
var
  qry: TUniQuery;
begin
  qry := TUniQuery.Create(nil);
  try
   try
    qry.Connection := dmConfiguracoes.conexao;
    qry.SQL.Text := 'SELECT 1 FROM RDB$RELATION_FIELDS ' +
                    'WHERE RDB$RELATION_NAME = ''CONFIGURACOES_PDV'' ' +
                    'AND RDB$FIELD_NAME = ''PARAMETROS_HORA_VIRADA''';
    qry.Open;
    if qry.IsEmpty then
    begin
      qry.Close;
      qry.SQL.Text := 'ALTER TABLE CONFIGURACOES_PDV ADD PARAMETROS_HORA_VIRADA VARCHAR(5)';
      qry.ExecSQL;
    end;
   except
    // Sem escrever no schema o Open logo abaixo reclama sozinho, com a
    // mensagem real do banco. Nao vale abortar a tela aqui.
    on E:Exception do ;
   end;
  finally
    qry.Free;
  end;
end;

// Devolve a hora da virada pronta para o banco: vazio (virada a meia-noite,
// que e o padrao de todos os clientes) ou no formato HH:MM.
function TfrmPrincipal.HoraViradaNormalizada(out AHora: string): Boolean;
var
  hora: TDateTime;
begin
  AHora := Trim(edtHoraVirada.Text);
  Result := True;
  if AHora = '' then
    Exit;
  Result := TryStrToTime(AHora, hora);
  if Result then
    AHora := FormatDateTime('hh:nn', hora);
end;

procedure TfrmPrincipal.GravarConfiguracoes;
var
    Registro: TRegistry;
    sHoraVirada: string;
begin
  // Hora invalida abortaria a gravacao inteira no banco: valida antes.
  if not HoraViradaNormalizada(sHoraVirada) then
  begin
    ShowMessage('Hora da virada do dia invalida. Use o formato HH:MM (ex: 05:00) ou deixe em branco.');
    try
      PageControl1.ActivePage := TabSheet4;
      edtHoraVirada.SetFocus;
    except
      on E:Exception do ;
    end;
    Abort;
  end;
  edtHoraVirada.Text := sHoraVirada;

  with dmConfiguracoes.qrConfiguracaoPDVUpdate do
  begin
    ParamByName('ID').AsInteger := 1;
    ParamByName('CAIXA').asstring := edtNumCaixa.text;
    ParamByName('TIPOPDV').AsInteger := rdTipoPDV.ItemIndex;

    ParamByName('NFCE_SSLLIB').AsInteger := cbSSLLib.ItemIndex;
    ParamByName('NFCE_CRYPTLIB').AsInteger := cbCryptLib.ItemIndex;
    ParamByName('NFCE_HTTPLIB').AsInteger := cbHttpLib.ItemIndex;
    ParamByName('NFCE_XMLSIGNLIB').AsInteger := cbXmlSignLib.ItemIndex;
    ParamByName('NFCE_SSLTYPE').AsInteger := cbSSLType.ItemIndex;

    ParamByName('NFCE_CERTCAMINHO').AsString := edtCaminho.texT;
    ParamByName('NFCE_CERTSENHA').AsString := edtSenha.text;
    ParamByName('NFCE_NUMSERIE').AsString := edtNumSerie.text;
    ParamByName('NFCE_IDTOKEN').AsString := edtIdToken.text;
    ParamByName('NFCE_TOKEN').AsString := edtToken.text;


    // IMPRESS�O FISCAL

    ParamByName('PERIFERICO_USAGAVETA').AsInteger := rdLocalGaveta.ItemIndex;
    ParamByName('PERIFERICO_USAESCPOS').AsInteger := BoolToInt(rdUsarEscPos.Checked);
    ParamByName('PERIFERICO_GAVETA_INVERTIDO').AsInteger := BoolToInt(chkGavInvertida.Checked);
    ParamByName('PERIFERICO_ESCPOS_PORTA').AsString := cbEscPosPorta.Text;
    ParamByName('PERIFERICO_ESCPOS_1LINHA').AsInteger := BoolToInt(chkEscPos1Linha.checked);
    ParamByName('PERIFERICO_ESCPOS_MODELO').AsInteger := cbEscPosModelo.ItemIndex;
    ParamByName('PERIFERICO_ESCPOS_COLUNAS').AsInteger := edtEscPosCol.Value;
    ParamByName('PERIFERICO_ESCPOS_ESPACOLIN').AsInteger := edtEscPosEspacLin.Value;
    ParamByName('PERIFERICO_ESCPOS_LINPULAR').AsInteger := edtEscPosLinPular.Value;
    ParamByName('PERIFERICO_ESCPOS_PAGCOD').AsInteger := cbEscPosPagCod.ItemIndex;


    ParamByName('PERIFERICO_FORTES_LARG').AsInteger := edtFortesLarg.Value;
    ParamByName('PERIFERICO_FORTES_TOPO').AsInteger := edtFortesTopo.value;
    ParamByName('PERIFERICO_FORTES_FUNDO').AsInteger := edtFortesFundo.value;
    ParamByName('PERIFERICO_FORTES_ESQ').AsInteger := edtFortesEsq.value;
    ParamByName('PERIFERICO_FORTES_DIR').AsInteger := edtFortesDir.value;
    ParamByName('PERIFERICO_FORTES_PREV').AsInteger := BoolToInt(chkPreview.Checked);
    ParamByName('PERIFERICO_FORTES_NOME').AsString := lblFortesNome.caption;


    // SAT

    ParamByName('CFE_MODELOSAT').AsInteger := cbSATModelo.ItemIndex;
    ParamByName('CFE_CAMINHODLL').AsString := edtSATCaminhoDLL.Text;
    ParamByName('CFE_CODIGOATIVACAO').AsString := edtSATCodigo.Text;
    ParamByName('CFE_CODUF').AsString := edtSATUF.Text;
    ParamByName('CFE_VERSAO').AsString := edtSATVersao.Text;
    ParamByName('CFE_TIPODLL').AsInteger := cbChamadaDLL.ItemIndex;
    ParamByName('CFE_VALIDASAT').AsInteger :=  BoolToInt( chkSATValida.checked);

    ParamByName('EMITENTE_CNPJ').AsString := edtEmitenteCNPJ.text;
    ParamByName('EMITENTE_IE').AsString := edtEmitenteIE.text;
    ParamByName('EMITENTE_IM').AsString := edtEmitenteIM.text;

    ParamByName('SWHOUSE_CNPJ').AsString := edtSWHouseCNPJ.Text;
    ParamByName('SWHOUSE_AC').AsString := edtSWHouseAC.text;

    // N�O FISCAL
    ParamByName('PERIFERICO_PORTA').AsString := ComboImpressora.Text;
    ParamByName('PERIFERICO_GER_MARCA').AsString := ComboGuilhotina.Text;
    ParamByName('PERIFERICO_GER_LINFIN').AsInteger := EditQtdLinhas.Value;
    ParamByName('PERIFERICO_GER_HGUILHO').AsInteger := BoolToInt(CheckHabGuilhotina.Checked);
    ParamByName('PERIFERICO_GER_HREIM').AsInteger := BoolToInt(CheckReimpressao.checked);
    ParamByName('PERIFERICO_GER_HIMP').AsInteger := BoolToInt(checkImpressao.checked);


    // BALAN�A
    ParamByName('BALANCA_MODELO').AsInteger := cb_bal_modelo.ItemIndex;
    ParamByName('BALANCA_BAUDRATE').AsInteger := StrToInt(cb_bal_baudrate.Text);
    ParamByName('BALANCA_STOPBITS').AsInteger := cb_bal_stop.ItemIndex;
    ParamByName('BALANCA_PORTA').AsString := cb_bal_porta.Text;
    ParamByName('BALANCA_HANDSHAKE').AsInteger := cb_bal_hand.ItemIndex;
    ParamByName('BALANCA_PARIDADE').AsInteger := cb_parity.ItemIndex;
    ParamByName('BALANCA_DATABITS').AsInteger := StrToInt(cb_bal_databits.text);
    ParamByName('BALANCA_TIMEOUT').AsInteger := StrToInt(cb_bal_time_out.Text);

    ParamByName('BALANCA_DIGITO').AsInteger := EditQtdDigitos.value;
    ParamByName('BALANCA_HLEITURA').AsInteger := BoolToInt(chkLeituraAutomatica.Checked);
    ParamByName('BALANCA_HDIGITO2').AsInteger := BoolToInt(chk2Etiqueta.Checked);

    ParamByName('BD_PDV').AsString := ed_base_local.Text;
    ParamByName('BD_IPSERVIDOR').AsString := ed_server.Text;
    ParamByName('BD_SERVIDOR').AsString := ed_base.Text;

    // VENDEDOR
    ParamByName('VENDEDOR_INFORMAR').AsInteger := BoolToInt(chkInformarVendedor.Checked);
    ParamByName('VENDEDOR_INFORMARCLI').AsInteger := BoolToInt(chkVendaInicio.Checked);

    //parametros
    ParamByName('PARAMETROS_DESCSUBTOTAL').AsInteger := BoolToInt(chkDescSub.Checked);
    ParamByName('PARAMETROS_JANELAS').AsInteger := BoolToInt(chkJanelas.Checked);
    ParamByName('PARAMETROS_LIMDIVERSOS').AsFloat := edtLimiteDiversos.Value;
    ParamByName('PARAMETROS_COD99').AsInteger := BoolToInt(chkCod99.Checked);
    ParamByName('PARAMETROS_HPERGUNTAIMPRIMIR').AsInteger := BoolToInt(chkPerguntaImprimir.Checked);
    ParamByName('PARAMETROS_VIASSF').AsInteger := edtViasSanFun.value;
    ParamByName('PARAMETROS_logo').AsString := edtLogoMarca.text;
    ParamByName('PARAMETROS_EXIBE_FECHAMENTO').AsInteger := BoolToInt(chkExibeFechamento.Checked);

    ParamByName('NFCE_SERIE').AsInteger := edtSerie.value;
    ParamByName('NFCE_NUMERO').AsString := edtNNFce.text;
    ParamByName('PARAMETROS_CODIGODIVER').AsString := edtCodigoDiversos.text;

    ParamByName('USA_CLIENTE_AVULSO').AsInteger := BoolToInt(chkClienteAvulso.checked);
    ParamByName('CLIENTE_IDENTIFICA_COMPLETO').AsInteger := BoolToInt(chkClienteIdentificaCompleto.Checked);
    ParamByName('PARAMETROS_HORA_VIRADA').AsString := sHoraVirada;




    ExecSQL;




    Registro := TRegistry.Create;
    Registro.RootKey := HKEY_LOCAL_MACHINE;
    if Registro.OpenKey('SOFTWARE', false) then
    begin
      Registro.CreateKey('S7');
      Registro.OpenKey('S7', true);
      Registro.CreateKey('PDV');
      Registro.OpenKey('PDV', true);
      Registro.CreateKey('Dados');

      if Registro.OpenKey('Dados', true) then
      begin
        Registro.WriteString('Local_Base', ed_base_local.Text);
        Registro.WriteString('Servidor_Ativo', 'SIM');
        Registro.WriteString('Servidor_Base', ed_base.Text);
        Registro.WriteString('Servidor_Host', ed_server.Text);

      end;

    END;
    Registro.Free;
  end;




end;

function TfrmPrincipal.IntToBool(aValue: integer): Boolean;
begin
  if aValue = 1 then result := true else result := false;
end;

procedure TfrmPrincipal.LerConfiguracoes;
var Registro: TRegistry;
begin
  GarantirColunaHoraVirada;
  with dmConfiguracoes.qrConfiguracaoPDV do
  begin
    close;
    Open;
    edtNumCaixa.Text := FieldByName('CAIXA').AsString;
    rdTipoPDV.ItemIndex := FieldByName('TIPOPDV').AsInteger;

    cbSSLLib.ItemIndex := FieldByName('NFCE_SSLLIB').AsInteger;
    cbCryptLib.ItemIndex := FieldByName('NFCE_CRYPTLIB').AsInteger;
    cbHttpLib.ItemIndex := FieldByName('NFCE_HTTPLIB').AsInteger;
    cbXmlSignLib.ItemIndex := FieldByName('NFCE_XMLSIGNLIB').AsInteger;
    cbSSLType.ItemIndex := FieldByName('NFCE_SSLTYPE').AsInteger;

    edtCaminho.Text := FieldByName('NFCE_CERTCAMINHO').AsString;
    edtSenha.Text := FieldByName('NFCE_CERTSENHA').AsString;
    edtNumSerie.Text := FieldByName('NFCE_NUMSERIE').AsString;
    edtIdToken.Text := FieldByName('NFCE_IDTOKEN').AsString;
    edtToken.Text := FieldByName('NFCE_TOKEN').AsString;

    // IMPRESS�O FISCAL
    rdLocalGaveta.ItemIndex := FieldByName('PERIFERICO_USAGAVETA').AsInteger;
    chkGavInvertida.Checked := IntToBool(FieldByName('PERIFERICO_GAVETA_INVERTIDO').AsInteger);
    rdUsarEscPos.Checked := IntToBool(FieldByName('PERIFERICO_USAESCPOS').AsInteger);
    if IntToBool(FieldByName('PERIFERICO_USAESCPOS').AsInteger) = False then
    begin
    cbUsarFortes.Checked := true ;
    end;

    cbEscPosPorta.Text := FieldByName('PERIFERICO_ESCPOS_PORTA').AsString;
    chkEscPos1Linha.checked := IntToBool(FieldByName('PERIFERICO_ESCPOS_1LINHA').AsInteger);
    cbEscPosModelo.ItemIndex := FieldByName('PERIFERICO_ESCPOS_MODELO').AsInteger;
    edtEscPosCol.Value := FieldByName('PERIFERICO_ESCPOS_COLUNAS').AsInteger;
    edtEscPosEspacLin.Value := FieldByName('PERIFERICO_ESCPOS_ESPACOLIN').AsInteger;
    edtEscPosLinPular.Value := FieldByName('PERIFERICO_ESCPOS_LINPULAR').AsInteger;
    cbEscPosPagCod.ItemIndex := FieldByName('PERIFERICO_ESCPOS_PAGCOD').AsInteger;


    edtFortesLarg.Value := FieldByName('PERIFERICO_FORTES_LARG').AsInteger;
    edtFortesTopo.value := FieldByName('PERIFERICO_FORTES_TOPO').AsInteger;
    edtFortesFundo.value := FieldByName('PERIFERICO_FORTES_FUNDO').AsInteger;
    edtFortesEsq.value := FieldByName('PERIFERICO_FORTES_ESQ').AsInteger;
    edtFortesDir.value := FieldByName('PERIFERICO_FORTES_DIR').AsInteger;
    chkPreview.Checked := IntToBool(FieldByName('PERIFERICO_FORTES_PREV').AsInteger);
    lblFortesNome.caption := FieldByName('PERIFERICO_FORTES_NOME').AsString;



    // SAT

    cbSATModelo.ItemIndex := FieldByName('CFE_MODELOSAT').AsInteger;
    edtSATCaminhoDLL.Text := FieldByName('CFE_CAMINHODLL').AsString;
    edtSATCodigo.Text := FieldByName('CFE_CODIGOATIVACAO').AsString;
    edtSATUF.Text := FieldByName('CFE_CODUF').AsString;
    edtSATVersao.Text := FieldByName('CFE_VERSAO').AsString;
    cbChamadaDLL.ItemIndex := FieldByName('CFE_TIPODLL').AsInteger;
    chkSATValida.checked := IntToBool(FieldByName('CFE_VALIDASAT').AsInteger);

    edtEmitenteCNPJ.text := FieldByName('EMITENTE_CNPJ').AsString;
    edtEmitenteIE.text := FieldByName('EMITENTE_IE').AsString;
    edtEmitenteIM.text := FieldByName('EMITENTE_IM').AsString;

    edtSWHouseCNPJ.Text := FieldByName('SWHOUSE_CNPJ').AsString;
    edtSWHouseAC.text := FieldByName('SWHOUSE_AC').AsString;


    // N�O FISCAL
    ComboGuilhotina.ItemIndex := ComboGuilhotina.Items.IndexOf(FieldByName('PERIFERICO_GER_MARCA').AsString);
    EditQtdLinhas.Value := FieldByName('PERIFERICO_GER_LINFIN').AsInteger;
    CheckHabGuilhotina.Checked := IntToBool(FieldByName('PERIFERICO_GER_HGUILHO').AsInteger);
    CheckReimpressao.checked := IntToBool(FieldByName('PERIFERICO_GER_HREIM').AsInteger);
    checkImpressao.checked := IntToBool(FieldByName('PERIFERICO_GER_HIMP').AsInteger);
    ComboImpressora.Text := FieldByName('PERIFERICO_PORTA').AsString;

    // BALAN�A
    cb_bal_modelo.ItemIndex := FieldByName('BALANCA_MODELO').AsInteger;
  cb_bal_baudrate.ItemIndex := cb_bal_baudrate.Items.IndexOf(IntToStr(FieldByName('BALANCA_BAUDRATE').AsInteger));

    cb_bal_stop.ItemIndex := FieldByName('BALANCA_STOPBITS').AsInteger;
//    cb_bal_porta.ItemIndex := FieldByName('BALANCA_PORTA').AsInteger;
    cb_bal_porta.ItemIndex := cb_bal_porta.Items.IndexOf(FieldByName('BALANCA_PORTA').AsString);
    cb_bal_hand.ItemIndex := FieldByName('BALANCA_HANDSHAKE').AsInteger;
    cb_parity.ItemIndex := FieldByName('BALANCA_PARIDADE').AsInteger;
//    cb_bal_databits.ItemIndex := FieldByName('BALANCA_DATABITS').AsInteger;
//      cb_bal_databits.ItemIndex := cb_bal_baudrate.Items.IndexOf(IntToStr(FieldByName('BALANCA_DATABITS').AsInteger));
cb_bal_databits.ItemIndex := cb_bal_databits.Items.IndexOf(IntToStr(FieldByName('BALANCA_DATABITS').AsInteger));

    cb_bal_time_out.Text := FieldByName('BALANCA_TIMEOUT').AsString;

    EditQtdDigitos.value := FieldByName('BALANCA_DIGITO').AsInteger;
    chkLeituraAutomatica.Checked := IntToBool(FieldByName('BALANCA_HLEITURA').AsInteger);
    chk2Etiqueta.Checked := IntToBool(FieldByName('BALANCA_HDIGITO2').AsInteger);

    ed_base_local.Text := FieldByName('BD_PDV').AsString;
    ed_server.Text := FieldByName('BD_IPSERVIDOR').AsString;
    ed_base.Text := FieldByName('BD_SERVIDOR').AsString;

    //parametros

    chkInformarVendedor.Checked := IntToBool(FieldByName('VENDEDOR_INFORMAR').AsInteger);
    chkVendaInicio.Checked := IntToBool(FieldByName('VENDEDOR_INFORMARCLI').AsInteger);

    chkDescSub.Checked := IntToBool(FieldByName('PARAMETROS_DESCSUBTOTAL').AsInteger);
    chkJanelas.Checked := IntToBool(FieldByName('PARAMETROS_JANELAS').AsInteger);
    edtLimiteDiversos.Value := FieldByName('PARAMETROS_LIMDIVERSOS').AsFloat;
    chkCod99.Checked :=   IntToBool(FieldByName('PARAMETROS_COD99').AsInteger);
    chkPerguntaImprimir.Checked := IntToBool(FieldByname('PARAMETROS_HPERGUNTAIMPRIMIR').AsInteger);
    chkExibeFechamento.Checked := IntToBool(FieldByname('PARAMETROS_EXIBE_FECHAMENTO').AsInteger);

    edtSerie.value := FieldByName('NFCE_SERIE').AsInteger;
    edtNNFce.text := FieldByName('NFCE_NUMERO').AsString;
    edtViasSanFun.value :=     FieldByName('PARAMETROS_VIASSF').AsInteger;
    edtLogoMarca.text :=     FieldByName('PARAMETROS_logo').AsString;
    edtCodigoDiversos.Text := FieldByName('PARAMETROS_CODIGODIVER').AsString;

    chkClienteAvulso.Checked := IntToBool(FieldByName('USA_CLIENTE_AVULSO').AsInteger);
    chkClienteIdentificaCompleto.Checked := IntToBool(FieldByName('CLIENTE_IDENTIFICA_COMPLETO').AsInteger);
    edtHoraVirada.Text := Trim(FieldByName('PARAMETROS_HORA_VIRADA').AsString);




   Registro := TRegistry.Create;
    Registro.RootKey := HKEY_LOCAL_MACHINE;
    if Registro.OpenKey('SOFTWARE', false) then
    begin
      if Registro.OpenKey('S7', false) then
      begin
        if Registro.openkey('PDV', false) then
        begin
           (************** BANCO DE DADOS *************)
          if Registro.OpenKey('Dados', false) then
          begin
           try
              try
                  ed_base_local.text := Registro.ReadString('LOCAL_BASE');
                  ed_base.text := Registro.ReadString('Servidor_Base');
                  ed_server.text := Registro.ReadString('Servidor_HOST');
              except

              end;
            except
//              Application.MessageBox
//                (pwidechar('N�o foi poss�vel conectar ao banco de dados local!' +
//                #13 + 'Caminho: ' + Registro.ReadString('Local_Base') + #13 +
//                ' O sistema ser� finalizado!'), 'Erro', mb_ok + mb_iconerror);
//              Application.Terminate;
              exit;
            end;


          end
          else
          begin
//            application.messagebox('Houve falha na leitura do resgistro do banco de dados!' +
//              ' O sistema ser� finalizado!', 'Erro', mb_ok + mb_iconerror);
//            Application.Terminate;
            exit;
          end;


        end
        else
        begin
//          application.messagebox('Houve falha na leitura do registro do PDV!' +
//            ' Favor contactar o suporte!', 'Erro', mb_ok + mb_iconerror);
        end;
      end
      else
      begin
//        application.messagebox('Houve falha na leitura do registro de configura��es!' +
//          ' Favor contactar o suporte!', 'Erro', mb_ok + mb_iconerror);
//        application.Terminate;
      end;
    end
    else
    begin
//      application.messagebox('Houve falha na leitura do registro de configura��es!' +
//        ' Favor contactar o suporte!', 'Erro', mb_ok + mb_iconerror);
//      application.Terminate;
    end;
  end;


end;

function TfrmPrincipal.LerIni(sArquivo, Secao, Linha, Def: String): String;
var
  Ini: TIniFile;
begin

  Ini := TIniFile.Create(sArquivo);
  Result := Ini.ReadString(Secao, Linha, Def);
  Ini.Free;


end;

procedure TfrmPrincipal.lerparametrosNFCe;
var
 T : TSSLLib;
 I : TpcnTipoEmissao;
 J : TpcnModeloDF;
 K : TpcnVersaoDF;
 U: TSSLCryptLib;
 V: TSSLHttpLib;
 X: TSSLXmlSignLib;
 Y: TSSLType;
begin
 cbSSLLib.Items.Clear;
  For T := Low(TSSLLib) to High(TSSLLib) do
    cbSSLLib.Items.Add( GetEnumName(TypeInfo(TSSLLib), integer(T) ) );
  cbSSLLib.ItemIndex := 0;

  cbCryptLib.Items.Clear;
  For U := Low(TSSLCryptLib) to High(TSSLCryptLib) do
    cbCryptLib.Items.Add( GetEnumName(TypeInfo(TSSLCryptLib), integer(U) ) );
  cbCryptLib.ItemIndex := 0;

  cbHttpLib.Items.Clear;
  For V := Low(TSSLHttpLib) to High(TSSLHttpLib) do
    cbHttpLib.Items.Add( GetEnumName(TypeInfo(TSSLHttpLib), integer(V) ) );
  cbHttpLib.ItemIndex := 0;

  cbXmlSignLib.Items.Clear;
  For X := Low(TSSLXmlSignLib) to High(TSSLXmlSignLib) do
    cbXmlSignLib.Items.Add( GetEnumName(TypeInfo(TSSLXmlSignLib), integer(X) ) );
  cbXmlSignLib.ItemIndex := 0;

  cbSSLType.Items.Clear;
  For Y := Low(TSSLType) to High(TSSLType) do
    cbSSLType.Items.Add( GetEnumName(TypeInfo(TSSLType), integer(Y) ) );
  cbSSLType.ItemIndex := 0;

end;

procedure TfrmPrincipal.lerparametrosSAT;
var
I : TACBrSATModelo ;
J : TpcnTipoAmbiente ;
K : TpcnRegTribISSQN ;
L : TpcnindRatISSQN ;
M : TpcnRegTrib ;
N: TACBrPosPrinterModelo;
O: TACBrPosPaginaCodigo;

begin
  cbChamadaDLL.Items.Clear ;
  For I := Low(TACBrSATModelo) to High(TACBrSATModelo) do
     cbChamadaDLL.Items.Add( GetEnumName(TypeInfo(TACBrSATModelo), integer(I) ) ) ;


  cbEscPosModelo.Items.Clear ;
  For N := Low(TACBrPosPrinterModelo) to High(TACBrPosPrinterModelo) do
     cbEscPosModelo.Items.Add( GetEnumName(TypeInfo(TACBrPosPrinterModelo), integer(N) ) ) ;

  cbEscPosPagCod.Items.Clear ;
  For O := Low(TACBrPosPaginaCodigo) to High(TACBrPosPaginaCodigo) do
     cbEscPosPagCod.Items.Add( GetEnumName(TypeInfo(TACBrPosPaginaCodigo), integer(O) ) ) ;

  cbEscPosPorta.Items.Clear;
  ACBrPosPrinter1.Device.AcharPortasSeriais( cbEscPosPorta.Items );
end;

procedure TfrmPrincipal.rdTipoPDVClick(Sender: TObject);
begin
if rdTipoPDV.ItemIndex = 0 then
begin
  // sat
  pgConfigFiscal.Pages[0].Enabled := true;
  pgConfigFiscal.ActivePage := tsSAT;
  pgConfigFiscal.Pages[1].Enabled := false;

end
else
if rdTipoPDV.ItemIndex = 1 then
begin
  // nfce
  pgConfigFiscal.Pages[1].Enabled := true;
  pgConfigFiscal.ActivePage := tsNFCe;
  pgConfigFiscal.Pages[0].Enabled := false;

end
else
begin
  pgConfigFiscal.Pages[1].Enabled := false;
  pgConfigFiscal.Pages[0].Enabled := false;
end;
end;

procedure TfrmPrincipal.rdUsarEscPosClick(Sender: TObject);
begin
  cbUsarFortes.Checked := False;
end;

procedure TfrmPrincipal.sbtnCaminhoCertClick(Sender: TObject);
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

procedure TfrmPrincipal.SpeedButton1Click(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a DLL';
  OpenDialog1.DefaultExt := '*.dll';
  OpenDialog1.Filter := 'Arquivos DLL (*.DLL)|*.DLL|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ExtractFileDir(application.ExeName);
  if OpenDialog1.Execute then
  begin
    edtSATCaminhoDLL.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmPrincipal.SpeedButton2Click(Sender: TObject);
begin
   OpenDialog1.Title := 'Selecione a Imagem';
  OpenDialog1.DefaultExt := '*.jpg';
  OpenDialog1.Filter := 'Arquivos JPG (*.JPG)|*.JPG|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ExtractFileDir(application.ExeName);
  if OpenDialog1.Execute then
  begin
    edtLogoMarca.Text := OpenDialog1.FileName;
  end;
end;

end.
