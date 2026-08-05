unit uFrmRelFuncComissao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvSmoothPanel,
  AdvSmoothExpanderPanel, Vcl.Mask, JvExMask, JvToolEdit, AdvGlowButton,
  Vcl.ExtCtrls, classe.variaveis,Classe.Relatorio,Classe.Funcionario,Classe.funcoes,uFrmLocFun;

type
  TfrmRelFuncComissao = class(TForm)
    AdvSmoothExpanderPanel1: TAdvSmoothExpanderPanel;
    Label53: TLabel;
    pnl1: TPanel;
    Label5: TLabel;
    cmbTipo: TComboBox;
    btnVis: TAdvGlowButton;
    Label3: TLabel;
    Label10: TLabel;
    dtInicio: TJvDateEdit;
    Label11: TLabel;
    dtFinal: TJvDateEdit;
    edtCodFuncionario: TEdit;
    edtNomeFuncionario: TEdit;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnVisClick(Sender: TObject);
    procedure edtCodFuncionarioKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodFuncionarioClick(Sender: TObject);
    procedure edtCodFuncionarioExit(Sender: TObject);
    procedure edtCodFuncionarioKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure carregarFuncionario;
  public
    { Public declarations }
  end;

var
  frmRelFuncComissao: TfrmRelFuncComissao;

implementation

{$R *.dfm}

procedure TfrmRelFuncComissao.btnVisClick(Sender: TObject);
var
  oRelatorio : TRelatorio;
begin
  oRelatorio := TRelatorio.Create;
  try
    oRelatorio.periodoInicial := dtInicio.Date;
    oRelatorio.periodoFinal := dtFinal.date;
    oRelatorio.listaString1[0] := edtCodFuncionario.Text;

    VariaveisSrv.oRelatorioController.RelatorioComissaoFuncionario(oRelatorio);


  finally
    oRelatorio.destroy;
  end;


end;

procedure TfrmRelFuncComissao.carregarFuncionario;
var
  oFuncionario:TFuncionario;
begin
edtCodFuncionario.Text := zeroEsquerda(edtCodFuncionario.text,6);
oFuncionario := TFuncionario.create;
oFuncionario.Codigo := edtCodFuncionario.Text;

if VariaveisSrv.oFuncionarioController.CarregarFuncionario(oFuncionario) and (edtCodFuncionario.Text <> '000000') then
begin
edtCodFuncionario.Text := oFuncionario.Codigo;
edtNomeFuncionario.Text := oFuncionario.Pessoa.Nome;
end
else
begin
  edtCodFuncionario.Text := '000000';
  edtNomeFuncionario.Text := 'TODOS';
  edtCodFuncionario.SelectAll;
end;

end;

procedure TfrmRelFuncComissao.edtCodFuncionarioClick(Sender: TObject);
begin
edtCodFuncionario.SelectAll;
end;

procedure TfrmRelFuncComissao.edtCodFuncionarioExit(Sender: TObject);
begin
carregarFuncionario;
end;

procedure TfrmRelFuncComissao.edtCodFuncionarioKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
if key = VK_F2 then
begin
edtCodFuncionario.Text := TfrmLocFun.Exibe;
carregarFuncionario;
end;
end;

procedure TfrmRelFuncComissao.edtCodFuncionarioKeyPress(Sender: TObject;
  var Key: Char);
begin
if key =#13 then
begin
btnVis.SetFocus;
end;


end;

procedure TfrmRelFuncComissao.FormShow(Sender: TObject);
begin
dtInicio.Date := Now();
dtFinal.date := Now();
end;


end.
