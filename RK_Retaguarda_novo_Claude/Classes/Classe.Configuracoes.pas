unit Classe.Configuracoes;


interface

uses
  System.SysUtils;
  type
  TConfiguracoes = class;
  TConfEtiqueta = class;
  TConfProduto = class;
  TConfBalanca = class;
  TConfValidade = class;
  TConfNFCe = class;

  TConfiguracoes = class
    private
    FterminalNumero: string;
    FEtiqueta: TConfEtiqueta;
    FProduto: TConfProduto;
    FBalanca: TConfBalanca;
    FValidade: TConfValidade;
    Fimpressora_porta: string;
    FPDV_Limite_Desconto_Perc: real;
    FNFCe: TConfNFce;
    FSYSPDV_IP: string;
    FETIQUETA_MODO_IMPORTACAO: Integer;
    procedure SetterminalNumero(const Value: string);
    procedure SetEtiqueta(const Value: TConfEtiqueta);
    procedure SetProduto(const Value: TConfProduto);
    procedure SetBalanca(const Value: TConfBalanca);
    procedure SetValidade(const Value: TConfValidade);
    procedure Setimpressora_porta(const Value: string);
    procedure SetPDV_Limite_Desconto_Perc(const Value: real);
    procedure SetNFCe(const Value: TConfNFce);
    procedure SetETIQUETA_MODO_IMPORTACAO(const Value: Integer);
    procedure SetSYSPDV_IP(const Value: string);
    public
    property terminalNumero : string read FterminalNumero write SetterminalNumero;
    property Etiqueta:TConfEtiqueta read FEtiqueta write SetEtiqueta;
    property Produto:TConfProduto read FProduto write SetProduto;
    property Balanca:TConfBalanca read FBalanca write SetBalanca;
    property Validade:TConfValidade read FValidade write SetValidade;
    property NFCe:TConfNFce read FNFCe write SetNFCe;
    property impressora_porta:string read Fimpressora_porta write Setimpressora_porta;
    property PDV_Limite_Desconto_Perc:real read FPDV_Limite_Desconto_Perc write SetPDV_Limite_Desconto_Perc;


    property ETIQUETA_MODO_IMPORTACAO:Integer read FETIQUETA_MODO_IMPORTACAO write SetETIQUETA_MODO_IMPORTACAO;
    property SYSPDV_IP:string read FSYSPDV_IP write SetSYSPDV_IP;
    constructor Create;
    destructor Destroy;override;



  end;

  TConfEtiqueta = class
    private
    FVisualizarImpressao: Boolean;
    FImpressora: string;
    procedure SetImpressora(const Value: string);
    procedure SetVisualizarImpressao(const Value: Boolean);
    public
    property VisualizarImpressao:Boolean read FVisualizarImpressao write SetVisualizarImpressao;
    property Impressora:string read FImpressora write SetImpressora;

  end;

  TConfProduto = class
    private
    FUtilizarCargaAutomatica: Boolean;
    procedure SetUtilizarCargaAutomatica(const Value: Boolean);

    public
    property UtilizarCargaAutomatica:Boolean read FUtilizarCargaAutomatica write SetUtilizarCargaAutomatica;

  end;

  TConfBalanca = class
    private
    FDiretorioBalanca: string;
    FQtdDigitos: integer;
    procedure SetDiretorioBalanca(const Value: string);
    procedure SetQtdDigitos(const Value: integer);
    public
    property DiretorioBalanca:string read FDiretorioBalanca write SetDiretorioBalanca;
    property QtdDigitos:integer read FQtdDigitos write SetQtdDigitos;
  end;

  TConfValidade = class
  private
    FalertaDias: integer;
    procedure SetalertaDias(const Value: integer);
    public
    property alertaDias:integer read FalertaDias write SetalertaDias;
  end;

  TConfNFCe = class
    private
    FidToken: string;
    Fdiretorio: string;
    Ftoken: string;
    Fsenha: string;
    procedure Setdiretorio(const Value: string);
    procedure SetidToken(const Value: string);
    procedure Setsenha(const Value: string);
    procedure Settoken(const Value: string);

    public
    property idToken:string read FidToken write SetidToken;
    property token:string read Ftoken write Settoken;
    property diretorio:string read Fdiretorio write Setdiretorio;
    property senha:string read Fsenha write Setsenha;

  end;

implementation
uses
Classe.funcoes;

{ TNCM }


{ TConfiguracoes }

constructor TConfiguracoes.Create;
begin
FEtiqueta := TConfEtiqueta.Create;
FProduto := TConfProduto.Create;
FBalanca := TConfBalanca.Create;
FValidade := TConfValidade.Create;
FNFce := TConfNFCe.create;
end;

destructor TConfiguracoes.Destroy;
begin
FreeAndNil(FEtiqueta);
FreeAndNil(FProduto);
FreeAndNil(FBalanca);
FreeAndNil(FNFce);

  inherited;
end;

procedure TConfiguracoes.SetBalanca(const Value: TConfBalanca);
begin
  FBalanca := Value;
end;

procedure TConfiguracoes.SetEtiqueta(const Value: TConfEtiqueta);
begin
  FEtiqueta := Value;
end;

procedure TConfiguracoes.SetETIQUETA_MODO_IMPORTACAO(const Value: Integer);
begin
  FETIQUETA_MODO_IMPORTACAO := Value;
end;

procedure TConfiguracoes.Setimpressora_porta(const Value: string);
begin
  Fimpressora_porta := Value;
end;

procedure TConfiguracoes.SetNFCe(const Value: TConfNFce);
begin
  FNFCe := Value;
end;

procedure TConfiguracoes.SetPDV_Limite_Desconto_Perc(const Value: real);
begin
  FPDV_Limite_Desconto_Perc := Value;
end;

procedure TConfiguracoes.SetProduto(const Value: TConfProduto);
begin
  FProduto := Value;
end;

procedure TConfiguracoes.SetSYSPDV_IP(const Value: string);
begin
  FSYSPDV_IP := Value;
end;

procedure TConfiguracoes.SetterminalNumero(const Value: string);
var
  terminal:string;
begin
  terminal := Value;
  terminal := zeroEsquerda(Value,3);

  FterminalNumero := terminal;
end;

procedure TConfiguracoes.SetValidade(const Value: TConfValidade);
begin
  FValidade := Value;
end;

{ TConfEtiqueta }

procedure TConfEtiqueta.SetImpressora(const Value: string);
begin
  FImpressora := Value;
end;

procedure TConfEtiqueta.SetVisualizarImpressao(const Value: Boolean);
begin
  FVisualizarImpressao := Value;
end;


{ TConfBalanca }

procedure TConfBalanca.SetDiretorioBalanca(const Value: string);
begin
  FDiretorioBalanca := Value;
end;

procedure TConfBalanca.SetQtdDigitos(const Value: integer);
begin
  FQtdDigitos := Value;
end;

{ TConfProduto }

procedure TConfProduto.SetUtilizarCargaAutomatica(const Value: Boolean);
begin
  FUtilizarCargaAutomatica := Value;
end;

{ TConfValidade }

procedure TConfValidade.SetalertaDias(const Value: integer);
begin
  FalertaDias := Value;
end;

{ TConfNFCe }

procedure TConfNFCe.Setdiretorio(const Value: string);
begin
  Fdiretorio := Value;
end;

procedure TConfNFCe.SetidToken(const Value: string);
begin
  FidToken := Value;
end;

procedure TConfNFCe.Setsenha(const Value: string);
begin
  Fsenha := Value;
end;

procedure TConfNFCe.Settoken(const Value: string);
begin
  Ftoken := Value;
end;

end.

