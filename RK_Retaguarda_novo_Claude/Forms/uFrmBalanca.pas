unit uFrmBalanca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,Classe.Variaveis,Conversao,
  Vcl.Menus;

type
  TfrmBalanca = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    btnCargaCompleta: TSpeedButton;
    rdModelo: TRadioGroup;
    memBal: TMemo;
    Label1: TLabel;
    PopupMenu1: TPopupMenu;
    F1: TMenuItem;
    lblDiretorio: TLabel;
    procedure btnCargaCompletaClick(Sender: TObject);
    procedure F1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rdModeloClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBalanca: TfrmBalanca;

implementation
  uses Classe.Funcoes;

{$R *.dfm}

procedure TfrmBalanca.btnCargaCompletaClick(Sender: TObject);
begin
if rdModelo.ItemIndex = 0 then
begin
VariaveisSrv.oProdutoController.ExportarProdutosBalanca(baltoledo,label1,memBal,lblDiretorio.caption);
end
else
if rdModelo.ItemIndex = 1 then
begin
VariaveisSrv.oProdutoController.ExportarProdutosBalanca(balFilizola,label1,memBal,lblDiretorio.caption);
end
else
if rdModelo.ItemIndex = 2 then
begin
VariaveisSrv.oProdutoController.ExportarProdutosBalanca(balUPX,label1,memBal,lblDiretorio.caption);
end;
if rdModelo.ItemIndex = 3 then
begin
VariaveisSrv.oProdutoController.ExportarProdutosBalanca(balItensMGV,label1,memBal,lblDiretorio.caption);
end;
ShowMessage('Concluído !');
end;

procedure TfrmBalanca.F1Click(Sender: TObject);
begin
Close;
end;

procedure TfrmBalanca.FormShow(Sender: TObject);
begin
lblDiretorio.caption := VariaveisSrv.oConfiguracoes.Balanca.DiretorioBalanca;
rdModelo.ItemIndex := StrToInt(LerIni('./Preferencias.ini','Balanca','Modelo','0'));
end;

procedure TfrmBalanca.rdModeloClick(Sender: TObject);
begin
GravaIni('./Preferencias.ini','Balanca','Modelo',IntToStr(rdModelo.ItemIndex));
end;

end.
