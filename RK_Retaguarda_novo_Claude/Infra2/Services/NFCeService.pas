unit NFCeService;

interface
uses ACBrNFe,ACBrDFeSSL,blcksock,ConfiguracaoRepositoryImpl,ConfiguracaoModel,pcnConversao,System.SysUtils;
type INFCeService = interface
  ['{7E8D177D-9D8D-4296-BD62-AEC6B6622976}']
  procedure RegerarNFCe(xml:string;ncm:string);
end;
type TNFceService = class
  private
    FACbrNFE:TAcbrNFE;
    FConfiguracaoRepository:IConfiguracaoRepository;
    procedure LerConfiguracao;
  public
    constructor create;
//    function RegerarNFCe(xml:string;ncm:string):DTORespostaNFce;
end;

implementation

{ TNFceService }

constructor TNFceService.create;
begin
  FACbrNFE := TACBrNFe.Create(nil);
  FConfiguracaoRepository := TConfiguracaoRepositoryFirebird.create;
end;

procedure TNFceService.LerConfiguracao;
var
  config:TConfiguracaoModel;
begin
  config := FConfiguracaoRepository.Obter;

  FACbrNFE.Configuracoes.Geral.SSLLib := TSSLLib(1);
  FACbrNFE.Configuracoes.Geral.SSLCryptLib := TSSLCryptLib(1);
  FACbrNFE.Configuracoes.Geral.SSLHttpLib := TSSLHttpLib(3);
  FACbrNFE.Configuracoes.Geral.SSLXmlSignLib := TSSLXmlSignLib(4);

  FACbrNFE.Configuracoes.Geral.IdCSC            := config.NFCe.IdToken;
  FACbrNFE.Configuracoes.Geral.CSC              := config.NFCe.Token;
  FACbrNFE.Configuracoes.WebServices.Ambiente := taProducao;
  FACbrNFE.SSL.SSLType := TSSLType(0);

  FACbrNFE.Configuracoes.Certificados.ArquivoPFX  := config.NFCe.diretorio;
  FACbrNFE.Configuracoes.Certificados.Senha       := config.NFCe.senha;
end;

//function TNFceService.RegerarNFCe(xml, ncm: string);
//var
//  i:integer;
//begin
//Self.LerConfiguracao;
//FACbrNFE.NotasFiscais.Clear;
//FACbrNFE.NotasFiscais.LoadFromString(xml);
//
//for i := 0 to FACBrNFe.NotasFiscais.Items[0].NFe.Det.Count - 1 do
//begin
//  FACBrNFe.NotasFiscais.Items[0].NFe.Det.Items[i].Prod.NCM := ncm;
//end;
//
//FACbrNFE.Enviar('1',true,true);
//end;

end.
