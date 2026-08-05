unit ConfiguracaoRepositoryImpl;

interface
uses ConfiguracaoModel,uConexao,FireDAC.Comp.Client,System.SysUtils;

type IConfiguracaoRepository = interface
  ['{0C659502-E93A-498F-962E-78F19D5DA58A}']
  function Obter:TConfiguracaoModel;
  procedure CarregarConfig;
  procedure SalvarConfig(config:TConfiguracaoModel);
end;


type TConfiguracaoRepositoryFake = class(TInterfacedObject,IConfiguracaoRepository)
  public
    procedure CarregarConfig;
    function Obter: TConfiguracaoModel;
    procedure SalvarConfig(config: TConfiguracaoModel);



end;

type TConfiguracaoRepositoryFirebird = class(TInterfacedObject,IConfiguracaoRepository)
  private
    FGlobalConfig: TConfiguracaoModel;
    query:TFDQuery;
    procedure SetGlobalConfig(const Value: TConfiguracaoModel);
    property GlobalConfig:TConfiguracaoModel read FGlobalConfig write SetGlobalConfig;
  public
    constructor create;
    function Obter: TConfiguracaoModel;
    procedure CarregarConfig;
    procedure SalvarConfig(config: TConfiguracaoModel);
end;

var
  FConfiguracaoRepositoryFirebird :IConfiguracaoRepository;

implementation

{ TConfiguracaoRepositoryFirebird }

procedure TConfiguracaoRepositoryFirebird.CarregarConfig;
begin
query := TConexao.GetInstance.ExecQuery('SELECT * FROM CONFIGURACOES');

FGlobalConfig := TConfiguracaoModel.Create;
FGlobalConfig.porta_impressora := query.FieldByName('IMPRESSORA_PORTA').AsString;
FGlobalConfig.etiqueta_modo_importacao := query.FieldByName('ETIQUETA_MODO_IMPORTACAO').AsInteger;
FGlobalConfig.syspdv_ip := query.FieldByName('SYSPDV_IP').AsString;
FGlobalConfig.NFCe.idToken := query.FieldByName('NFCE_IDTOKEN').AsString;
FGlobalConfig.NFCe.token := query.FieldByName('NFCE_TOKEN').AsString;
FGlobalConfig.NFCe.diretorio := query.FieldByName('NFCE_DIRETORIO').AsString;
FGlobalConfig.NFCe.senha := query.FieldByName('NFCE_SENHA').AsString;

end;

constructor TConfiguracaoRepositoryFirebird.create;
begin
self.CarregarConfig;
end;

function TConfiguracaoRepositoryFirebird.Obter: TConfiguracaoModel;
begin
result := FGlobalConfig;
end;

procedure TConfiguracaoRepositoryFirebird.SalvarConfig(
  config: TConfiguracaoModel);
begin
query := TConexao.GetInstance.CreateQuery('UPDATE CONFIGURACOES SET IMPRESSORA_PORTA=:IMPRESSORA_PORTA, ETIQUETA_MODO_IMPORTACAO=:ETIQUETA_MODO_IMPORTACAO,SYSPDV_IP=:SYSPDV_IP');
query.Params.ParamByName('IMPRESSORA_PORTA').AsString := config.porta_impressora;
query.Params.ParamByName('ETIQUETA_MODO_IMPORTACAO').AsInteger := config.etiqueta_modo_importacao;
query.Params.ParamByName('SYSPDV_IP').AsString := config.syspdv_ip;
query.ExecSQL;
Self.CarregarConfig;
end;

procedure TConfiguracaoRepositoryFirebird.SetGlobalConfig(
  const Value: TConfiguracaoModel);
begin
  FGlobalConfig := Value;
end;


{ TConfiguracaoRepositoryFake }

procedure TConfiguracaoRepositoryFake.CarregarConfig;
begin

end;

function TConfiguracaoRepositoryFake.Obter: TConfiguracaoModel;
begin
result := TConfiguracaoModel.Create;
result.etiqueta_modo_importacao := 1;
result.syspdv_ip := '127.0.0.1';
end;

procedure TConfiguracaoRepositoryFake.SalvarConfig(config: TConfiguracaoModel);
begin

end;


end.
