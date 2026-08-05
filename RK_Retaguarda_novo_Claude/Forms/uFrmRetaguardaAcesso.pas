unit uFrmRetaguardaAcesso;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvGlowButton,
  Vcl.ComCtrls, Vcl.ExtCtrls,Classe.Variaveis,Classe.AcessoRetaguarda;

type
  TfrmAcessoRetaguarda = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    tv: TTreeView;
    Panel1: TPanel;
    btnGravar: TAdvGlowButton;
    GroupBox1: TGroupBox;
    chkOp: TCheckBox;
    chkFis: TCheckBox;
    chkGer: TCheckBox;
    GroupBox2: TGroupBox;
    chkSolic: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure tvChange(Sender: TObject; Node: TTreeNode);
    procedure btnGravarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAcessoRetaguarda: TfrmAcessoRetaguarda;

implementation
  uses Classe.Funcoes;

{$R *.dfm}

procedure TfrmAcessoRetaguarda.btnGravarClick(Sender: TObject);
var
  vlrFunc: string;
    oAcessoRetaguarda:TAcessoRetaguarda;
begin
  oAcessoRetaguarda := TAcessoRetaguarda.Create;
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

  oAcessoRetaguarda.FuncaoNivel := vlrFunc;
  oAcessoRetaguarda.funcaoSolicitaSenha := BoolToStr(chkSolic.Checked);
  oAcessoRetaguarda.Descricao := tv.selected.Text;

  VariaveisSrv.oUtilsController.AtualizarNivelAcessoRetaguarda(oAcessoRetaguarda);

  oAcessoRetaguarda.Destroy;


  VariaveisSrv.oUtilsController.preencherTreeViewRetaguarda(tv);
  ShowMessage('Função atualizada ! ');
end;

procedure TfrmAcessoRetaguarda.FormShow(Sender: TObject);
begin
VariaveisSrv.oUtilsController.preencherTreeViewRetaguarda(tv);
end;

procedure TfrmAcessoRetaguarda.tvChange(Sender: TObject; Node: TTreeNode);
var
  oAcessoRetaguarda:TAcessoRetaguarda;
  arrayNiv: TArray<string>;
  I:integer;
begin
if Assigned(tv.Selected) then
begin
  try
    oAcessoRetaguarda := TAcessoRetaguarda.Create;
    oAcessoRetaguarda.Descricao := tv.Selected.Text;
    VariaveisSrv.oUtilsController.preencherNivelAcessoRetaguarda(oAcessoRetaguarda);

 // inicializar variaveis
  I := 0;
  chkOp.Checked := false;
  chkFis.Checked := false;
  chkGer.Checked := false;
  // array para verificar nivel de acesso

   arrayNiv := Split(oAcessoRetaguarda.FuncaoNivel,';');

  chkSolic.Checked := StrToBool(oAcessoRetaguarda.funcaoSolicitaSenha);

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






  finally

    oAcessoRetaguarda.Destroy;

  end;
end;
end;

end.
