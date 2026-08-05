unit uFrmPopUpNotificacao;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Winapi.Windows, System.Generics.Collections;

type
  TFrmPopUpNotificacao = class(TForm)
    lblMensagem: TLabel;
    TimerFechar: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TimerFecharTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    class var NotificacoesAtivas: TList<TFrmPopUpNotificacao>;
    procedure AjustarPosicao;
  public
    procedure MostrarNotificacao(const Msg: string);
    class procedure FecharTodasNotificacoes;
  end;

var
  frmPopUpNotificacao: TFrmPopUpNotificacao;

procedure ExibirNotificacao(const Mensagem: string);
procedure FecharTodasNotificacoes;

implementation

{$R *.dfm}

uses
  Vcl.Graphics;

{ TFrmPopUpNotificacao }

class procedure TFrmPopUpNotificacao.FecharTodasNotificacoes;
var
  Notificacao: TFrmPopUpNotificacao;
begin
  if Assigned(NotificacoesAtivas) then
  begin
    for Notificacao in NotificacoesAtivas do
      Notificacao.Close;
    NotificacoesAtivas.Clear;
  end;
end;

procedure TFrmPopUpNotificacao.FormCreate(Sender: TObject);
begin
  Self.Width := 250;
  Self.Height := 80;
  Self.Color := clInfoBk;
  Self.BorderStyle := bsNone;

  lblMensagem.Align := alClient;
  lblMensagem.Alignment := taCenter;
  lblMensagem.Layout := tlCenter;
  lblMensagem.Font.Size := 10;

  if NotificacoesAtivas = nil then
    NotificacoesAtivas := TList<TFrmPopUpNotificacao>.Create;
end;

procedure TFrmPopUpNotificacao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if Assigned(NotificacoesAtivas) then
    NotificacoesAtivas.Remove(Self);
end;

procedure TFrmPopUpNotificacao.AjustarPosicao;
var
  WorkArea: TRect;
  OffsetY: Integer;
  I: Integer;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @WorkArea, 0);

  OffsetY := 0;

  // Calcula a altura total das notificações já abertas
  if Assigned(NotificacoesAtivas) then
  begin
    for I := 0 to NotificacoesAtivas.Count - 1 do
    begin
      if (NotificacoesAtivas[I] <> Self) and NotificacoesAtivas[I].Visible then
        Inc(OffsetY, NotificacoesAtivas[I].Height + 5); // 5px de espaçamento
    end;
  end;

  Self.Left := WorkArea.Right - Self.Width - 10;
  Self.Top := WorkArea.Bottom - Self.Height - 10 - OffsetY;

  // Força a notificação a ficar visível na tela
  if Self.Top < WorkArea.Top then
    Self.Top := WorkArea.Top;
end;

procedure TFrmPopUpNotificacao.TimerFecharTimer(Sender: TObject);
begin
  Close;
end;

procedure TFrmPopUpNotificacao.MostrarNotificacao(const Msg: string);
begin
  lblMensagem.Caption := Msg;
  AjustarPosicao;
  TimerFechar.Interval := 3000;
  TimerFechar.Enabled := True;

  if Assigned(NotificacoesAtivas) then
    NotificacoesAtivas.Add(Self);

  Show;
end;

procedure ExibirNotificacao(const Mensagem: string);
var
  Notificacao: TFrmPopUpNotificacao;
begin
  Notificacao := TFrmPopUpNotificacao.Create(nil);
  try
    Notificacao.MostrarNotificacao(Mensagem);
  except
    Notificacao.Free;
    raise;
  end;
end;

procedure FecharTodasNotificacoes;
begin
  TFrmPopUpNotificacao.FecharTodasNotificacoes;
end;

initialization

finalization
  TFrmPopUpNotificacao.FecharTodasNotificacoes;
  FreeAndNil(TFrmPopUpNotificacao.NotificacoesAtivas);

end.
