unit ConfiguracaoModel;

interface
type TConfiguracaoNFCe = class
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
type TConfiguracaoModel =class
  private
    Fporta_impressora: string;
    Fetiqueta_modo_importacao: integer;
    Fsyspdv_ip: string;
    FNFCe: TConfiguracaoNFCe;
    procedure Setporta_impressora(const Value: string);
    procedure Setetiqueta_modo_importacao(const Value: integer);
    procedure Setsyspdv_ip(const Value: string);
    procedure SetNFCe(const Value: TConfiguracaoNFCe);

  public
  constructor create;
  destructor destroy;override;
  property porta_impressora:string read Fporta_impressora write Setporta_impressora;
  property etiqueta_modo_importacao:integer read Fetiqueta_modo_importacao write Setetiqueta_modo_importacao;
  property syspdv_ip:string read Fsyspdv_ip write Setsyspdv_ip;
  property NFCe:TConfiguracaoNFCe read FNFCe write SetNFCe;

end;

implementation

{ TConfiguracaoModel }

constructor TConfiguracaoModel.create;
begin
FNFCe := TConfiguracaoNFCe.Create;
end;

destructor TConfiguracaoModel.destroy;
begin
  FNFCe.Free;
  inherited;
end;

procedure TConfiguracaoModel.Setetiqueta_modo_importacao(const Value: integer);
begin
  Fetiqueta_modo_importacao := Value;
end;

procedure TConfiguracaoModel.SetNFCe(const Value: TConfiguracaoNFCe);
begin
  FNFCe := Value;
end;

procedure TConfiguracaoModel.Setporta_impressora(const Value: string);
begin
  Fporta_impressora := Value;
end;

procedure TConfiguracaoModel.Setsyspdv_ip(const Value: string);
begin
  Fsyspdv_ip := Value;
end;

{ TConfiguracaoNFCe }

procedure TConfiguracaoNFCe.Setdiretorio(const Value: string);
begin
  Fdiretorio := Value;
end;

procedure TConfiguracaoNFCe.SetidToken(const Value: string);
begin
  FidToken := Value;
end;

procedure TConfiguracaoNFCe.Setsenha(const Value: string);
begin
  Fsenha := Value;
end;

procedure TConfiguracaoNFCe.Settoken(const Value: string);
begin
  Ftoken := Value;
end;

end.
