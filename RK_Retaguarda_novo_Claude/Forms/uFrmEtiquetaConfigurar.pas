unit uFrmEtiquetaConfigurar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  AdvGlowButton, AdvSmoothPanel, AdvSmoothExpanderPanel, frxClass;

type
  TfrmEtiquetaConfig = class(TForm)
    AdvSmoothExpanderPanel1: TAdvSmoothExpanderPanel;
    Label53: TLabel;
    pnl1: TPanel;
    btnVis: TAdvGlowButton;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    cmbTipo: TComboBox;
    btnGravar: TButton;
    btnExcluir: TButton;
    edtNome: TEdit;
    edtArquivo: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnNovo: TButton;
    btnCancelar: TButton;
    btnEditar: TButton;
    frxEtiqueta: TfrxReport;
    procedure FormShow(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure cmbTipoChange(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
  private
    procedure Limpar;
    procedure loadForm;
    procedure carregarEtiqueta;
  public
    { Public declarations }
  end;

var
  frmEtiquetaConfig: TfrmEtiquetaConfig;
  etiqueta:array [0..2] of string;

  modo:string;
implementation
  uses Classe.Variaveis,Classe.Funcoes;

{$R *.dfm}

procedure TfrmEtiquetaConfig.btnNovoClick(Sender: TObject);
begin
btnGravar.Enabled := True;
btnCancelar.Enabled := true;
btnNovo.Enabled := false;
btnExcluir.Enabled := false;
btnEditar.Enabled := false;

cmbTipo.enabled := false;

edtNome.Enabled := true;
edtArquivo.Enabled := true;

Limpar;
modo := 'NOVO';
end;

procedure TfrmEtiquetaConfig.carregarEtiqueta;
var
  etiquetaSplit:TArray<string>;
  etiquetaReturn:TArray<string>;
begin
etiquetaSplit := Split(cmbTipo.Items[cmbTipo.ItemIndex],'-');

etiqueta[0] := etiquetaSplit[0];

etiquetaReturn := VariaveisSrv.oUtilsController.carregarEtiqueta(etiqueta);
edtNome.Text := etiquetaReturn[1];
edtArquivo.Text := etiquetaReturn[2];


end;

procedure TfrmEtiquetaConfig.cmbTipoChange(Sender: TObject);
begin
  Limpar;
carregarEtiqueta;

end;

procedure TfrmEtiquetaConfig.btnCancelarClick(Sender: TObject);
begin
btnNovo.Enabled := true;
btnGravar.Enabled := false;
btnCancelar.Enabled := false;
btnExcluir.Enabled := true;
btnEditar.Enabled := true;

cmbTipo.enabled := true;

edtNome.Enabled := false;
edtArquivo.Enabled := false;


modo := 'VISUALIZAR';


end;

procedure TfrmEtiquetaConfig.btnEditarClick(Sender: TObject);
begin
  if edtArquivo.Text <> '' then
  begin
    frxEtiqueta.LoadFromFile('\System_RK\Server\Etiquetas\'+EdtArquivo.Text);
    frxEtiqueta.DesignReport;
  end
  else
  begin
    ShowMessage('Nenhum layout selecionado !');
  end;

end;

procedure TfrmEtiquetaConfig.btnExcluirClick(Sender: TObject);
begin
if modo = 'VISUALIZAR' then
begin
  carregarEtiqueta;
  if VariaveisSrv.oUtilsController.DAOEtiqueta('EXCLUIR',etiqueta) then
  begin
    ShowMessage('Excluído !');
  end;

  loadForm;

  btnCancelar.Click;
  Limpar;

end;
end;

procedure TfrmEtiquetaConfig.btnGravarClick(Sender: TObject);
begin
if modo = 'NOVO' then
begin
  etiqueta[1] := edtNome.Text;
  etiqueta[2] := edtArquivo.Text;
  VariaveisSrv.oUtilsController.DAOEtiqueta('INSERIR',etiqueta);

  loadForm;

  btnCancelar.Click;

end;
end;


procedure TfrmEtiquetaConfig.FormShow(Sender: TObject);
begin
loadForm();

Limpar;

modo := 'VISUALIZAR';
end;

procedure TfrmEtiquetaConfig.Limpar;
begin
edtNome.Text := '';
edtArquivo.Text := '';
cmbTipo.Text := '';
end;

procedure TfrmEtiquetaConfig.loadForm;
begin
VariaveisSrv.oUtilsController.carregarEtiquetaLista(cmbTipo);
end;

end.
