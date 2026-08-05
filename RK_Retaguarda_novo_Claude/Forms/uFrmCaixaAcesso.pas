unit uFrmCaixaAcesso;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGlowButton,
  Vcl.ComCtrls, Vcl.ExtCtrls,Classe.Variaveis,Classe.AcessoPDV;

type
  TfrmCaixaAcesso = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    tv: TTreeView;
    Panel1: TPanel;
    AdvGlowButton1: TAdvGlowButton;
    GroupBox1: TGroupBox;
    chkOp: TCheckBox;
    chkFis: TCheckBox;
    chkGer: TCheckBox;
    GroupBox2: TGroupBox;
    chkSolic: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure tvChange(Sender: TObject; Node: TTreeNode);
    procedure AdvGlowButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCaixaAcesso: TfrmCaixaAcesso;

implementation
uses Classe.Funcoes;
{$R *.dfm}

procedure TfrmCaixaAcesso.AdvGlowButton1Click(Sender: TObject);
var
  vlrFunc: string;
    oAcessoPDV:TAcessoPDV;
begin
  oAcessoPDV := TAcessoPDV.Create;
  vlrFunc := '';
  if chkOp.Checked = true then
  begin
    vlrFunc := vlrFunc + '0;';
  end;
    if chkFis.Checked = true then
  begin
    vlrFunc := vlrFunc + '1;';
  end;
    if chkGer.Checked = true then
  begin
    vlrFunc := vlrFunc + '2;';
  end;

  oAcessoPDV.FuncaoNivel := vlrFunc;
  oAcessoPDV.funcaoSolicitaSenha := BoolToStr(chkSolic.Checked);
  oAcessoPDV.Descricao := tv.selected.Text;

  VariaveisSrv.oUtilsController.AtualizarNivelAcesso(oAcessoPDV);

  oAcessoPDV.Destroy;


  VariaveisSrv.oUtilsController.preencherTreeView(tv);
  ShowMessage('Função atualizada, envie uma carga de alterados ! ');

end;

procedure TfrmCaixaAcesso.FormShow(Sender: TObject);
begin
VariaveisSrv.oUtilsController.preencherTreeView(tv);
end;

procedure TfrmCaixaAcesso.tvChange(Sender: TObject; Node: TTreeNode);
var
  oAcessoPDV:TAcessoPDV;
  arrayNiv: TArray<string>;
  I:integer;
begin
if Assigned(tv.Selected) then
begin
  oAcessoPDV := TAcessoPDV.Create;
  oAcessoPDV.Descricao := tv.selected.text;
  VariaveisSrv.oUtilsController.preencherNivelAcesso(oAcessoPDV);
  // inicializar variaveis
  I := 0;
  chkOp.Checked := false;
  chkFis.Checked := false;
  chkGer.Checked := false;
  // array para verificar nivel de acesso

   arrayNiv := Split(oAcessoPDV.FuncaoNivel,';');

  chkSolic.Checked := StrToBool(oAcessoPDV.funcaoSolicitaSenha);

  while I <= Length(arrayNiv)-1 do
  begin
    if arrayNiv[I] = '0' then
    begin
    chkOp.Checked := true;
    end;
        if arrayNiv[I] = '1' then
    begin

    chkFis.Checked := true;
    end;
        if arrayNiv[I] = '2' then
    begin

    chkGer.Checked := true;
    end;

    I:= I + 1;

  end;



  oAcessoPDV.Destroy;
end;
end;

end.
