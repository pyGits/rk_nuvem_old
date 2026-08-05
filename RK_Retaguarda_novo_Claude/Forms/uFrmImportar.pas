unit uFrmImportar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, Vcl.ExtCtrls,
  Vcl.StdCtrls,uDmConexaoIntegracao,uFrmImportarPersonalizado,Classe.Funcoes,ImportarController,Firedac.Stan.Async;

type
  TfrmImportar = class(TForm)
    Panel1: TPanel;
    btnImportarCompleto: TAdvGlowButton;
    cbImportar: TComboBox;
    Label1: TLabel;
    memLog: TMemo;
    procedure btnImportarCompletoClick(Sender: TObject);
    procedure btnImportarAlteradoClick(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure chkImportarCompletoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbImportarChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure loadForm;
  end;

var
  frmImportar: TfrmImportar;

implementation

{$R *.dfm}

procedure TfrmImportar.AdvGlowButton1Click(Sender: TObject);
begin
 try
   dmConexaoIntegracao := TdmConexaoIntegracao.Create(self);
   dmConexaoIntegracao.ImportarSyspdvFracionado(memLog);
except
on E:Exception do
begin
  raise Exception.Create('Erro ao tentar importar' + e.Message);
end;

end;
end;

procedure TfrmImportar.btnImportarAlteradoClick(Sender: TObject);
var
  dmConexaoIntegracao:TdmConexaoIntegracao;
begin
if cbImportar.ItemIndex = 0 then
begin
try
  Application.ProcessMessages;

   dmConexaoIntegracao := TdmConexaoIntegracao.Create(self);
   dmConexaoIntegracao.ImportarSyspdvAlterado(memLog);
except
on E:Exception do
begin
  raise Exception.Create('Erro ao tentar importar' + e.Message);
end;

end;
end;

end;

procedure TfrmImportar.btnImportarClick(Sender: TObject);
var
  frmImportar:TfrmImportarPersonalizado;
begin
  frmImportar:=TfrmImportarPersonalizado.create(nil);
  frmImportar.ShowModal;
end;

procedure TfrmImportar.btnImportarCompletoClick(Sender: TObject);
begin
if cbImportar.ItemIndex = 0 then
begin
  if not FileExists('c:\syspdv\syspdv_srv.fdb') then
  begin
    raise Exception.Create('Banco de dados do syspdv não encontrado !');
  end;

  Importar_Controller.ImportarSyspdv(memLog);
end;

if cbImportar.ItemIndex = 1 then
begin
memLog.Lines.Clear;
memLog.Lines.Add('Importando do banco de dados do caixa !');

Importar_Controller.ImportarRKPdv;
end;
if cbImportar.ItemIndex = 2 then
begin
  Importar_Controller.ImportarSyspdvSQL(memLog);
end;

end;

procedure TfrmImportar.cbImportarChange(Sender: TObject);
begin
GravaIni('./Preferencias.ini','Importar','Tipo',IntToStr(cbImportar.ItemIndex));
end;

procedure TfrmImportar.chkImportarCompletoClick(Sender: TObject);
begin
//GravaIni('./Preferencias.ini','Importar','ImportarCompleto',BoolToStr(chkImportarCompleto.Checked));
//loadForm;
end;

procedure TfrmImportar.FormShow(Sender: TObject);
begin
loadForm;
end;

procedure TfrmImportar.loadForm;
begin
cbImportar.ItemIndex :=StrToInt(LerIni('./Preferencias.ini','Importar','Tipo','1'));
//chkImportarCompleto.Checked := LerIni('./Preferencias.ini','Importar','ImportarCompleto','-1').ToBoolean();
//if chkImportarCompleto.checked then btnImportarCompleto.Visible := true;
//if not(chkImportarCompleto.checked) then btnImportarCompleto.Visible := false;
end;

end.
