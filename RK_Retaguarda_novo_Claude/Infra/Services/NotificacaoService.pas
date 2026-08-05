unit NotificacaoService;

interface

uses
  Notificacao, System.Generics.Collections,
  Vcl.Forms, System.Classes, System.SysUtils, Vcl.Dialogs,System.Notification;

type
  TNotificacaoService = class
  private
    FNotificationCenter: TNotificationCenter;
    procedure NotificationClicked(Sender: TObject; ANotification: TNotification);
  public
    constructor Create;
    procedure ShowNotification(Notificacao: TNotificacao);
    procedure ShowNotificationList(NotificationList: TList<TNotificacao>);
  end;

//var
//  Notificacao_Gateway: TNotificacaoService;

implementation
uses uFrmNotificacao;

{ TNotificacaoService }

constructor TNotificacaoService.Create;
begin
  inherited;
  FNotificationCenter := TNotificationCenter.Create(nil);
  FNotificationCenter.OnReceiveLocalNotification := NotificationClicked;
end;

procedure TNotificacaoService.ShowNotification(Notificacao: TNotificacao);
var
  Notification: TNotification;
begin
  Notification := FNotificationCenter.CreateNotification;
  try
    Notification.Name := Notificacao.formulario; // Identificador único
    Notification.Title := Notificacao.Titulo;
    Notification.AlertBody := Notificacao.Mensagem;
    Notification.EnableSound := True;

    // Exibe a notificação
    FNotificationCenter.PresentNotification(Notification);
  finally
    Notification.Free;
  end;
end;
//
procedure TNotificacaoService.ShowNotificationList(NotificationList: TList<TNotificacao>);
var
  Notificacao: TNotificacao;
begin
  for Notificacao in NotificationList do
    ShowNotification(Notificacao);
end;
//
// Evento acionado ao clicar na notificação
procedure TNotificacaoService.NotificationClicked(Sender: TObject; ANotification: TNotification);
begin
TfrmNotificacao.Create(nil).ShowModal;

end;

initialization
//  Notificacao_Gateway := TNotificacaoService.Create;

end.
