unit uFrmEnviaNFCe;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,pcnConversao,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ACBrBase, ACBrDFe, ACBrNFe,ACBrDFeSSL,blcksock,
  Vcl.ExtCtrls,pcnConversaoNFe,NFCeController,NFCePendente,System.Generics.Collections;

type
  TfrmEnviaNFce = class(TForm)
    lblEnvia: TLabel;
    ACBrNFe1: TACBrNFe;
    tmEnviarXML: TTimer;
    procedure FormShow(Sender: TObject);
    procedure tmEnviarXMLTimer(Sender: TObject);
  private
    FNCM: string;
    procedure InicializarNFCe;
    procedure EnviarNFCes;
    procedure EnviarXML(nfce:TNFcePendente);
  public
  var
    listaXML:TObjectList<TNFCePendente>;

    class procedure enviar(xmlList: TObjectList<TNFCePendente>);
    class procedure enviarComNCM(xmlList: TObjectList<TNFCePendente>; ncm: string);
  end;

var
  frmEnviaNFce: TfrmEnviaNFce;


implementation
uses Classe.variaveis;

{$R *.dfm}

{ TfrmEnviaNFce }

class procedure TfrmEnviaNFce.enviar(xmlList: TObjectList<TNFCePendente>);
begin
  if xmlList.Count = 0 then raise Exception.Create('Lista Vazia Selecione as notas !');

  frmEnviaNFce := TfrmEnviaNFce.Create(nil);
  frmEnviaNFce.listaXML := xmlList;
  frmEnviaNFce.ShowModal;
  frmEnviaNFce.Free;
end;

class procedure TfrmEnviaNFce.enviarComNCM(xmlList: TObjectList<TNFCePendente>; ncm: string);
begin
  if xmlList.Count = 0 then raise Exception.Create('Lista Vazia Selecione as notas !');

  frmEnviaNFce := TfrmEnviaNFce.Create(nil);
  frmEnviaNFce.listaXML := xmlList;
  frmEnviaNFce.FNCM := ncm;
  frmEnviaNFce.ShowModal;
  frmEnviaNFce.Free;
end;

procedure TfrmEnviaNFce.EnviarNFCes;
var
  xml:TNFCePendente;
begin
  tmEnviarXML.Enabled := false;
  for xml in listaXML do
  begin
    if xml.retorno = 'ENVIADO' then continue;
    
    lblEnvia.Caption := 'Enviando XML:';
    EnviarXML(xml);

    Application.ProcessMessages;
  end;


  close;
end;

procedure TfrmEnviaNFce.EnviarXML(nfce: TNFcePendente);

  function ConsultarChave(const AChave: string): Integer;
  begin
    Result := 0;

    try
      ACBrNFe1.WebServices.Consulta.NFeChave := AChave;
      ACBrNFe1.WebServices.Consulta.Executar;

      Result := ACBrNFe1.WebServices.Consulta.cStat;

    except
      on E: Exception do
      begin
        nfce.retorno := E.Message;
        NFCe_Controller.atualizarRetorno(nfce);
      end;
    end;
  end;

var
  i: Integer;
  cStat: Integer;
  chave: String;
  restante: Integer;
  pendente: TNFcePendente;

begin
  restante := 0;
  for pendente in listaXML do
    if pendente.retorno <> 'ENVIADO' then
      Inc(restante);

  lblEnvia.Caption := Format('Enviando XML... Faltam %d', [restante]);
  Application.ProcessMessages;

  ACBrNFe1.NotasFiscais.Clear;
  ACBrNFe1.NotasFiscais.LoadFromString(nfce.xml);
  if FNCM <> '' then
  begin
    for i := 0 to ACBrNFe1.NotasFiscais.Items[0].NFe.Det.Count - 1 do
    begin
      ACBrNFe1.NotasFiscais.Items[0]
        .NFe.Det.Items[i]
        .Prod.NCM := FNCM;
    end;
      try
    // transmite o XML ORIGINAL da conting�ncia
    ACBrNFe1.Enviar(1, True, True);
  except
    on E: Exception do
    begin
      nfce.retorno := E.Message;
      NFCe_Controller.atualizarRetorno(nfce);
    end;
  end;

  end;

  try
    ACBrNFe1.Consultar();
    except
    on E:Exception do
    begin
//    ShowMessage(e.Message);
    end;
  end;

    chave := StringReplace(ACBrNFe1.NotasFiscais.Items[0].NFe.infNFe.ID,'NFe','',[rfReplaceAll,rfIgnoreCase]);
    cStat := ACBrNFe1.WebServices.Consulta.cStat;
case cStat of
  // =========================
  // AUTORIZADA
  // =========================
  100, 150:
  begin
    nfce.chave   := chave;
    nfce.retorno := 'ENVIADO';

    NFCe_Controller.atualizarRetorno(nfce);
  end;

  // =========================
  // DUPLICIDADE
  // =========================
  204:
  begin
    nfce.chave   := chave;
    nfce.retorno := 'ENVIADO';
    NFCe_Controller.atualizarRetorno(nfce);
  end;

  // =========================
  // DIVERG�NCIA
  // =========================
  539:
  begin
    nfce.chave   := chave;
    nfce.retorno := 'ENVIADO';
    NFCe_Controller.atualizarRetorno(nfce);
  end;

  // =========================
  // CHAVE DIVERGENTE
  // =========================
  613:
  begin
    nfce.chave   := chave;
    nfce.retorno := 'ENVIADO';
    NFCe_Controller.atualizarRetorno(nfce);
  end;

else
  begin
    nfce.retorno :=
      Format(
        'ERRO AO ENVIAR NFC-E | cStat: %d',
        [cStat]
      );

    NFCe_Controller.atualizarRetorno(nfce);
  end;
end;
end;

procedure TfrmEnviaNFce.FormShow(Sender: TObject);
begin
  InicializarNFCe;
  tmEnviarXML.enabled := true;
end;

procedure TfrmEnviaNFce.InicializarNFCe;
begin
  with VariaveisSrv.oConfiguracoes.NFCe do
  begin
    ACBrNFe1.Configuracoes.Geral.SSLLib        := TSSLLib(1);
    ACBrNFe1.Configuracoes.Geral.SSLCryptLib   := TSSLCryptLib(1);
    ACBrNFe1.Configuracoes.Geral.SSLHttpLib    := TSSLHttpLib(3);
    ACBrNFe1.Configuracoes.Geral.SSLXmlSignLib := TSSLXmlSignLib(4);
    ACBrNFe1.Configuracoes.Geral.IdCSC         := IdToken;
    ACBrNFe1.Configuracoes.Geral.CSC           := Token;
    ACBrNFe1.Configuracoes.Geral.FormaEmissao  := teNormal; // padr�o
    ACBrNFe1.SSL.SSLType := TSSLType(0);
    ACBrNFe1.Configuracoes.Certificados.ArquivoPFX := diretorio;
    ACBrNFe1.Configuracoes.Certificados.Senha      := senha;
  end;
end;

procedure TfrmEnviaNFce.tmEnviarXMLTimer(Sender: TObject);
begin
EnviarNFCes;
end;

end.
