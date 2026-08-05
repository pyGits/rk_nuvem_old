unit uFrmRelFechamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls,
  AdvGlowButton, Vcl.Mask, JvExMask, JvToolEdit, Vcl.ExtCtrls, AdvSmoothPanel,
  AdvSmoothExpanderPanel,Classe.Variaveis,Classe.Relatorio,CLasse.funcionario,uFrmLocFun;

type
  TFrmRelFechamento = class(TForm)
    AdvSmoothExpanderPanel1: TAdvSmoothExpanderPanel;
    Label53: TLabel;
    pnl1: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label3: TLabel;
    dtInicio: TJvDateEdit;
    dtFinal: TJvDateEdit;
    btnVis: TAdvGlowButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    edtCaixa: TEdit;
    PopupMenu1: TPopupMenu;
    P1: TMenuItem;
    edtOperador: TEdit;
    Label5: TLabel;
    edtOperadorDesc: TEdit;
    procedure btnVisClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtOperadorClick(Sender: TObject);
    procedure edtOperadorKeyPress(Sender: TObject; var Key: Char);
    procedure edtOperadorExit(Sender: TObject);
    procedure edtCaixaKeyPress(Sender: TObject; var Key: Char);
    procedure dtInicioKeyPress(Sender: TObject; var Key: Char);
    procedure dtFinalKeyPress(Sender: TObject; var Key: Char);
  private
    procedure localizarOperador;
  public
    { Public declarations }
  end;

var
  FrmRelFechamento: TFrmRelFechamento;

implementation

{$R *.dfm}

procedure TFrmRelFechamento.btnVisClick(Sender: TObject);
var
  oRelatorio:TRelatorio;
begin
oRelatorio := TRelatorio.create;
oRelatorio.caixa := edtCaixa.Text;
oRelatorio.periodoInicial := dtInicio.Date;
oRelatorio.periodoFinal := dtFinal.Date;
oRelatorio.filtro1 := edtOperador.Text;
VariaveisSrv.oRelatorioController.RelatorioFechamentoCaixa(oRelatorio);
end;

procedure TFrmRelFechamento.dtFinalKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  btnVis.SetFocus;
end;
end;

procedure TFrmRelFechamento.dtInicioKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  dtFinal.SetFocus;
end;
end;

procedure TFrmRelFechamento.edtCaixaKeyPress(Sender: TObject; var Key: Char);
begin
if Key = #13 then
begin
  edtOperador.SetFocus;
end;
end;

procedure TFrmRelFechamento.edtOperadorClick(Sender: TObject);
begin
edtOperador.SelectAll;
end;

procedure TFrmRelFechamento.edtOperadorExit(Sender: TObject);
begin
localizarOperador;
end;

procedure TFrmRelFechamento.edtOperadorKeyPress(Sender: TObject; var Key: Char);
begin
if key =#13 then
begin
  edtOperadorExit(nil);
end;
end;

procedure TFrmRelFechamento.FormShow(Sender: TObject);
begin
edtCaixa.Text := '0';
edtOperadorDesc.Text := 'TODOS';
edtOperador.Text := '000000';
dtInicio.Date := Now();
dtFinal.Date := Now();
end;

procedure TFrmRelFechamento.localizarOperador;
var
  oFuncionario:TFuncionario;
begin
try
oFuncionario := TFuncionario.Create;
oFuncionario.Codigo := edtOperador.Text;
if not (VariaveisSrv.oFuncionarioController.CarregarFuncionario(oFuncionario)) then
begin
    oFuncionario.Codigo := TfrmLocFun.Exibe;
end;

edtOperador.Text := oFuncionario.Codigo;
edtOperadorDesc.Text := oFuncionario.Pessoa.Nome;
if edtOperador.Text = '000000' then
begin
  edtOperadorDesc.Text := 'TODOS';

end;

  btnVis.SetFocus;
finally
oFuncionario.Destroy;
end;
end;

end.
