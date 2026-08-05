unit uFrmRelPagamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,Classe.Relatorio,
  AdvGlowButton, Vcl.Mask, JvExMask, JvToolEdit, AdvSmoothPanel,Classe.Variaveis,
  AdvSmoothExpanderPanel;

type
  TFrmRelPagamento = class(TForm)
    AdvSmoothExpanderPanel1: TAdvSmoothExpanderPanel;
    Label53: TLabel;
    pnl1: TPanel;
    Label2: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    dtInicio: TJvDateEdit;
    dtFinal: TJvDateEdit;
    edtCaixa: TEdit;
    cmbTipo: TComboBox;
    btnVis: TAdvGlowButton;
    analitico: TRadioGroup;
    cbCupom: TComboBox;
    chkcancelado: TCheckBox;
    procedure btnVisClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dtInicioKeyPress(Sender: TObject; var Key: Char);
    procedure dtFinalKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmRelPagamento: TFrmRelPagamento;

implementation

{$R *.dfm}

procedure TFrmRelPagamento.btnVisClick(Sender: TObject);
var
  oRelatorio:TRelatorio;
begin
  oRelatorio := TRelatorio.Create;
 case cmbTipo.ItemIndex of
0:begin
//Agrupado por finalizadora
  with oRelatorio do
  begin
//  Tipo := 0;
  caixa := edtCaixa.Text;
  periodoInicial := dtInicio.date;
  periodoFinal := dtFinal.date;

  oRelatorio.cancelado := chkcancelado.Checked;

    case analitico.ItemIndex of
    0:begin
    //Simples
    detalhado := false;
    end;
    1:begin
    detalhado := true;
    end;

  end;

    oRelatorio.Fiscal := cbCupom.ItemIndex;
    variaveissrv.oRelatorioController.RelatorioFinalizadora(oRelatorio);

end;



end;
1:begin end;

end;
  oRelatorio.Destroy;
end;

procedure TFrmRelPagamento.dtFinalKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
btnVis.SetFocus;
end;
end;

procedure TFrmRelPagamento.dtInicioKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
dtFinal.SetFocus;
end;
end;

procedure TFrmRelPagamento.FormShow(Sender: TObject);
begin
dtInicio.date := date;
dtFinal.date := date;
end;

end.
