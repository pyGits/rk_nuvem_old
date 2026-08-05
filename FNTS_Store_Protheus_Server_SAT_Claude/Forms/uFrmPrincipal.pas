unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,uCupomController,
  RzTray, Vcl.AppEvnts,uDmConexaoServer, Vcl.Mask, JvExMask, JvToolEdit,uStorageController,
  Vcl.Menus;

type
  TfrmPrincipalNovo = class(TForm)
    pnPrincipal: TPanel;
    memLog: TMemo;
    lblIP: TLabel;
    lblBanco: TLabel;
    tm_Sincronizar: TTimer;
    ApplicationEvents1: TApplicationEvents;
    tm_reinciarConexao: TTimer;
    TrayIcon1: TTrayIcon;
    btnRSincronizar: TButton;
    edtFim: TJvDateEdit;
    edtInicio: TJvDateEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label5: TLabel;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    procedure tm_SincronizarTimer(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure tm_reinciarConexaoTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure btnRSincronizarClick(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    var
      oCupomController:TCupomController;
      oStorageController:TStorageController;
  end;

var
  frmPrincipalNovo: TfrmPrincipalNovo;

implementation

{$R *.dfm}

procedure TfrmPrincipalNovo.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
memLog.Lines.Add('Erro : '+E.Message);
oStorageController.WriteLog(e.Message);
tm_reinciarConexao.Enabled := true;
end;

procedure TfrmPrincipalNovo.btnRSincronizarClick(Sender: TObject);
begin
//  oCupomController := TCupomController.Create;
//memLog.Lines.add('Sincronizando vendas antigas, aguarde...');
//tm_Sincronizar.Enabled := false;
//if oCupomController.SincronizarVendasAntigas(edtInicio.date,edtFim.date) then
//begin
//  tm_Sincronizar.Interval := 500;
//  tm_Sincronizar.enabled := True;
//end
//else
//begin
//  tm_Sincronizar.Interval := 5000;
//  tm_Sincronizar.enabled := True;
//end;
//
//    oCupomController.destroy;
//
tm_Sincronizar.Enabled := false;
oCupomController := TCupomController.create;
oCupomcontroller.SincronizarVendasBackup;
end;

procedure TfrmPrincipalNovo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := CaNone;
  Self.Hide;
  Self.WindowState := wsMinimized;
  TrayIcon1.visible :=True;
  TrayIcon1.Animate :=True;

end;
procedure TfrmPrincipalNovo.FormCreate(Sender: TObject);
begin
oStorageController:=TStorageController.create;
end;

procedure TfrmPrincipalNovo.S1Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TfrmPrincipalNovo.tm_reinciarConexaoTimer(Sender: TObject);
begin
  if dmConexaoServer.IniciarConexaoServer(lblIP,lblBanco) then
  begin
  tm_reinciarConexao.Enabled := false;
  tm_Sincronizar.enabled := True;
  Close;
  end
  else
  begin
  tm_reinciarConexao.Enabled := true;
  lblIP.Caption := 'Tentando conectar...';
  lblBanco.Caption := '';
  end;
end;

procedure TfrmPrincipalNovo.tm_SincronizarTimer(Sender: TObject);
begin
  oCupomController := TCupomController.Create;

  if tm_reinciarConexao.enabled = false then
  begin
  tm_Sincronizar.Enabled := False;

  oCupomController.SincronizarVendaServidor(memLog);


  tm_Sincronizar.Enabled := true;
  end;
    oCupomController.destroy;
end;

procedure TfrmPrincipalNovo.TrayIcon1DblClick(Sender: TObject);
begin
  TrayIcon1.Visible := False;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

end.
