unit modulo;

interface

uses
  System.SysUtils, System.Classes, Data.DB, UniProvider, InterBaseUniProvider,
  MemDS, DBAccess, Uni, DASQLMonitor, UniSQLMonitor;

type
  TdmConfiguracoes = class(TDataModule)
    conexao: TUniConnection;
    qrConfiguracaoPDV: TUniQuery;
    InterBaseUniProvider1: TInterBaseUniProvider;
    qrConfiguracaoPDVID: TIntegerField;
    qrConfiguracaoPDVCAIXA: TStringField;
    qrConfiguracaoPDVTIPOPDV: TIntegerField;
    qrConfiguracaoPDVNFCE_SSLLIB: TIntegerField;
    qrConfiguracaoPDVNFCE_CRYPTLIB: TIntegerField;
    qrConfiguracaoPDVNFCE_HTTPLIB: TIntegerField;
    qrConfiguracaoPDVNFCE_XMLSIGNLIB: TIntegerField;
    qrConfiguracaoPDVNFCE_SSLTYPE: TIntegerField;
    qrConfiguracaoPDVNFCE_CERTCAMINHO: TStringField;
    qrConfiguracaoPDVNFCE_CERTSENHA: TStringField;
    qrConfiguracaoPDVNFCE_NUMSERIE: TStringField;
    qrConfiguracaoPDVNFCE_IDTOKEN: TStringField;
    qrConfiguracaoPDVNFCE_TOKEN: TStringField;
    qrConfiguracaoPDVPERIFERICO_USAGAVETA: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_USAESCPOS: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_PORTA: TStringField;
    qrConfiguracaoPDVPERIFERICO_ESCPOS_1LINHA: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_ESCPOS_MODELO: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_ESCPOS_COLUNAS: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_ESCPOS_ESPACOLIN: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_ESCPOS_LINPULAR: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_ESCPOS_PAGCOD: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_FORTES_LARG: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_FORTES_TOPO: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_FORTES_FUNDO: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_FORTES_ESQ: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_FORTES_DIR: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_FORTES_PREV: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_FORTES_NOME: TStringField;
    qrConfiguracaoPDVEMITENTE_CNPJ: TStringField;
    qrConfiguracaoPDVEMITENTE_IE: TStringField;
    qrConfiguracaoPDVSWHOUSE_CNPJ: TStringField;
    qrConfiguracaoPDVSWHOUSE_AC: TMemoField;
    qrConfiguracaoPDVCFE_MODELOSAT: TIntegerField;
    qrConfiguracaoPDVCFE_CAMINHODLL: TStringField;
    qrConfiguracaoPDVCFE_CODIGOATIVACAO: TStringField;
    qrConfiguracaoPDVCFE_CODUF: TIntegerField;
    qrConfiguracaoPDVCFE_VERSAO: TStringField;
    qrConfiguracaoPDVCFE_TIPODLL: TIntegerField;
    qrConfiguracaoPDVCFE_VALIDASAT: TIntegerField;
    qrConfiguracaoPDVUpdate: TUniQuery;
    UniSQLMonitor1: TUniSQLMonitor;
    qrConfiguracaoPDVPERIFERICO_ESCPOS_PORTA: TStringField;
    qrConfiguracaoPDVEMITENTE_IM: TStringField;
    qrConfiguracaoPDVPERIFERICO_GER_LINFIN: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_GER_MARCA: TStringField;
    qrConfiguracaoPDVPERIFERICO_GER_HGUILHO: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_GER_HREIM: TIntegerField;
    qrConfiguracaoPDVPERIFERICO_GER_HIMP: TIntegerField;
    qrConfiguracaoPDVBALANCA_MODELO: TIntegerField;
    qrConfiguracaoPDVBALANCA_BAUDRATE: TIntegerField;
    qrConfiguracaoPDVBALANCA_STOPBITS: TIntegerField;
    qrConfiguracaoPDVBALANCA_HANDSHAKE: TIntegerField;
    qrConfiguracaoPDVBALANCA_PARIDADE: TIntegerField;
    qrConfiguracaoPDVBALANCA_DATABITS: TIntegerField;
    qrConfiguracaoPDVBALANCA_TIMEOUT: TIntegerField;
    qrConfiguracaoPDVBALANCA_DIGITO: TIntegerField;
    qrConfiguracaoPDVBALANCA_HLEITURA: TIntegerField;
    qrConfiguracaoPDVBALANCA_HDIGITO2: TIntegerField;
    qrConfiguracaoPDVBD_PDV: TStringField;
    qrConfiguracaoPDVBD_IPSERVIDOR: TStringField;
    qrConfiguracaoPDVBD_SERVIDOR: TStringField;
    qrConfiguracaoPDVVENDEDOR_INFORMAR: TIntegerField;
    qrConfiguracaoPDVVENDEDOR_INFORMARCLI: TIntegerField;
    qrConfiguracaoPDVPARAMETROS_LIMDIVERSOS: TFloatField;
    qrConfiguracaoPDVPARAMETROS_DESCSUBTOTAL: TIntegerField;
    qrConfiguracaoPDVPARAMETROS_JANELAS: TIntegerField;
    qrConfiguracaoPDVPARAMETROS_COD99: TIntegerField;
    qrConfiguracaoPDVLOGIN_USUARIO: TStringField;
    qrConfiguracaoPDVLOGIN_SENHA: TStringField;
    qrConfiguracaoPDVPARAMETROS_HPERGUNTAIMPRIMIR: TIntegerField;
    qrConfiguracaoPDVNFCE_SERIE: TIntegerField;
    qrConfiguracaoPDVNFCE_NUMERO: TStringField;
    qrConfiguracaoPDVBALANCA_PORTA: TStringField;
    qrConfiguracaoPDVPARAMETROS_VIASSF: TIntegerField;
    qrConfiguracaoPDVPARAMETROS_LOGO: TStringField;
    qrConfiguracaoPDVPERIFERICO_GAVETA_INVERTIDO: TIntegerField;
    qrConfiguracaoPDVPARAMETROS_CODIGODIVER: TStringField;
    qrConfiguracaoPDVUSA_CLIENTE_AVULSO: TIntegerField;
    qrConfiguracaoPDVPARAMETROS_EXIBE_FECHAMENTO: TIntegerField;
    qrConfiguracaoPDVPARAMETROS_HORA_VIRADA: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmConfiguracoes: TdmConfiguracoes;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

// A conexao abre AQUI, e nao pelo Connected = True gravado no .dfm. Com o
// flag no dfm, o proprio RAD Studio conectava no banco de producao toda vez
// que o DataModule era aberto em tempo de projeto - e a conexao ficava presa
// no IDE, segurando o .FDB e impedindo renomear/restaurar o arquivo.
// Com OldCreateOrder = False este OnCreate roda depois de todo o dfm ser
// lido, entao as queries ja existem quando a conexao sobe.
procedure TdmConfiguracoes.DataModuleCreate(Sender: TObject);
begin
  conexao.Connected := True;
end;

end.
