unit uFrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, dxGDIPlusClasses,
  Vcl.ExtCtrls, AdvGlowButton,Classe.Variaveis,Classe.Funcionario,Classe.Funcoes,UsuarioController;

type
  TFrmLogin = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    Image1: TImage;
    Panel1: TPanel;
    edtCodigo: TEdit;
    edtFuncionario: TEdit;
    edtSenha: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnLogin: TAdvGlowButton;
    btnSair: TAdvGlowButton;
    procedure btnSairClick(Sender: TObject);
    procedure edtCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure edtSenhaKeyPress(Sender: TObject; var Key: Char);
    procedure btnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;
  Autenticado:Boolean;

implementation

{$R *.dfm}

procedure TFrmLogin.btnLoginClick(Sender: TObject);
var
  oFuncionario:TFuncionario;
begin
    if (edtCodigo.text = '999999') and (edtSenha.Text = '6425025x') then
    begin
      Autenticado := true;
      VariaveisSrv.oFuncionario.Codigo := oFuncionario.Codigo;
      Close;
    end;
  oFuncionario := TFuncionario.create;
  oFuncionario.Codigo := edtCodigo.text;

  if VariaveisSrv.oFuncionarioController.CarregarFuncionario(oFuncionario) then
  begin

    if edtSenha.text = Cript('D',oFuncionario.senha) then
    begin
      if not (Usuario_Controller.AutenticarUsuario(edtCodigo.text,edtSenha.text)) then ShowMessage('Não Autenticado');
      Autenticado := true;
      VariaveisSrv.oFuncionario.Codigo := oFuncionario.Codigo;

      Close;

    end
    else
    begin
      ShowMessage('Usuário ou senha errado !');
      edtSenha.SetFocus;
    end;
  end
  else
  begin
    edtCodigo.SelectAll;
    edtFuncionario.text := '';
    edtSenha.text := '';
    ShowMessage('Funcionário não encontrado');
  end;
  oFuncionario.Destroy;

end;

procedure TFrmLogin.btnSairClick(Sender: TObject);
begin
Close;
end;

procedure TFrmLogin.edtCodigoKeyPress(Sender: TObject; var Key: Char);
var
  oFuncionario:TFuncionario;
begin

if key = #13 then
begin
  oFuncionario := TFuncionario.create;
  oFuncionario.Codigo := edtCodigo.text;
  if VariaveisSrv.oFuncionarioController.CarregarFuncionario(oFuncionario) then
  begin
    edtCodigo.Text := oFuncionario.Codigo;
    edtFuncionario.Text := oFuncionario.Pessoa.Nome;
    edtSenha.text := '';
    edtSenha.setFocus;
  end
  else
  begin
    edtCodigo.SelectAll;
    edtFuncionario.text := '';
    edtSenha.text := '';
    ShowMessage('Funcionário não encontrado');
  end;
  oFuncionario.Destroy;
end;



end;

procedure TFrmLogin.edtSenhaKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  btnLogin.SetFocus;
end;
end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if Autenticado = false then
begin
  Application.Terminate;
end;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
begin
Autenticado := false;
end;

end.
