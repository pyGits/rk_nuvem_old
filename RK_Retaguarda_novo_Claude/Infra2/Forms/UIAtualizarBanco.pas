unit UIAtualizarBanco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,UIAtualizarBancoInterface,
  Vcl.ComCtrls;

type
  TfrmUIAtualizarBanco = class(TForm,IAtualizarBanco)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    Panel2: TPanel;
    Label3: TLabel;
    lblScriptAtual: TLabel;
    Panel3: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    Shape1: TShape;
    Memo1: TMemo;
  public
    procedure AtualizarProgresso(atual: Integer; total: Integer;sql:string);
    procedure IniciarAtualizacao(versaoDB: Integer);
    procedure Abrir;
    procedure ExibirMensagem(msg: string);
    procedure Finalizar;






  end;

var
  frmUIAtualizarBanco: TfrmUIAtualizarBanco;

implementation

{$R *.dfm}

{ TForm1 }

procedure TfrmUIAtualizarBanco.Abrir;
begin
Self.Show;
Application.ProcessMessages;
end;

procedure TfrmUIAtualizarBanco.AtualizarProgresso(atual, total: Integer;sql:string);
begin
  if total <= 0 then Exit;
  ProgressBar1.Min := 0;
  ProgressBar1.Max := total;
  ProgressBar1.Position := atual;

  lblScriptAtual.Caption := 'Executando Script ' + IntToStr(atual) + '/'+IntToStr(total);

  memo1.Lines.Add(sql);

  Application.ProcessMessages;
end;



procedure TfrmUIAtualizarBanco.ExibirMensagem(msg: string);
begin
ShowMessage(msg);
end;

procedure TfrmUIAtualizarBanco.Finalizar;
begin
ShowMessage('Atualização Finalizada !');
Self.Close;
end;

procedure TfrmUIAtualizarBanco.IniciarAtualizacao(versaoDB: Integer);
begin
label7.Caption := inttostr(versaoDB);
Memo1.Lines.Clear;
end;

end.
