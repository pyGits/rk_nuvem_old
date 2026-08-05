unit NotificacaoController;

interface
uses NotificacaoRepository,System.Generics.collections,Notificacao,NotificacaoService;
type TNotificacaoController = class
  private
  public
  procedure ExibirNotificacoes;
  function ObterNotificacoesDetalhada(filtro:string):TList<TNotificacao>;
end;

var
  Notificacao_Controller:TNotificacaoController;
implementation

{ TNotificacaoController }

procedure TNotificacaoController.ExibirNotificacoes;
var
  Notificacao_List :TList<TNotificacao>;
  Notificacao:TNotificacao;
begin
Notificacao_List := Notificacao_Repository.CarregarTodasNotificacoes;
//Notificacao_Gateway.ShowNotificationList(Notificacao_List);
end;

function TNotificacaoController.ObterNotificacoesDetalhada(filtro:string): TList<TNotificacao>;
begin
result := TList<TNotificacao>.create;
result := Notificacao_Repository.CarregarTodasNotificacoesDetalhadas.filtrarPorFormulario(filtro);
end;

initialization
  Notificacao_Controller := TNotificacaoController.create;
end.
