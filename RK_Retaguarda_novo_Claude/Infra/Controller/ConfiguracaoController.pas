unit ConfiguracaoController;

interface
uses ConfiguracaoRepository,Configuracao;
type TConfiguracaoController = class
private
public
  constructor create;
  procedure CarregarConfiguracoes;
end;
var
  Configuracao_Controller :TConfiguracaoController;

implementation

{ TConfiguracaoController }


procedure TConfiguracaoController.CarregarConfiguracoes;
begin
Configuracoes := Configuracao_Repository.CarregarConfiguracao;
end;

constructor TConfiguracaoController.create;
begin
CarregarConfiguracoes;
end;

initialization
  Configuracao_Controller :=TConfiguracaoController.create;
end.
