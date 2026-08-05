unit ConfiguracaoRepository;

interface
  uses Configuracao,RKConnection,Firedac.comp.client,System.SysUtils,vcl.dialogs;


type TConfiguracaoRepository = class
  public
    function CarregarConfiguracao:TConfiguracao;
end;

var
  Configuracao_Repository : TConfiguracaoRepository;

implementation


{ TConfiguracaoRepository }

function TConfiguracaoRepository.CarregarConfiguracao: TConfiguracao;
var
  query:TFDQuery;
begin
try
query := RKConn.GetQuery('SELECT VALIDADE_DIAS_ALERTA FROM CONFIGURACOES');
query.Open;
result := TConfiguracao.Create;
result.validade_dias_notificacao := query.FieldByName('VALIDADE_DIAS_ALERTA').AsInteger;
except
on E:Exception do
begin
  showmessage('Erro ao carregar configurações: '+e.message);
end;

end;




end;

initialization
  Configuracao_Repository := TConfiguracaoRepository.Create;

end.
