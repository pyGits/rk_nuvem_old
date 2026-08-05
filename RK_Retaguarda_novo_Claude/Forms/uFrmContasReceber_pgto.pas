unit uFrmContasReceber_pgto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  JvExMask, JvToolEdit, JvBaseEdits, Vcl.Menus,Classe.Variaveis,Classe.Finalizadora,uFrmLocFinalizadora;

type
  TfrmContasReceberPgto = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    Panel1: TPanel;
    lblTipoDesconto: TLabel;
    edtDesconto: TJvCalcEdit;
    lblTipoAcrescimo: TLabel;
    edtAcrescimo: TJvCalcEdit;
    Panel2: TPanel;
    lblVlrTotal: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    edtVlrPagamento: TJvCalcEdit;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    A1: TMenuItem;
    edtCodFin: TEdit;
    edtDescFin: TEdit;
    procedure A1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtDescontoKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodFinExit(Sender: TObject);
    procedure edtVlrPagamentoKeyPress(Sender: TObject; var Key: Char);
    procedure edtDescontoExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtAcrescimoExit(Sender: TObject);
  private
    procedure InicializarValores;
  public
    class function Exibe(vlrAPagar:Real):Boolean;
  end;

var
  frmContasReceberPgto: TfrmContasReceberPgto;
  vlrPagar:real;
  vlrDesconto:real;
  vlrAcrescimo:real;

implementation

{$R *.dfm}

procedure TfrmContasReceberPgto.A1Click(Sender: TObject);
begin
if edtDesconto.Focused then
begin
  // alterar forma desconto
  if lblTipoDesconto.caption = 'Desconto (R$) :' then
  begin
    lblTipoDesconto.caption := 'Desconto (%) :';
  end
  else
  begin
    lblTipoDesconto.caption := 'Desconto (R$) :';
  end;

end;

if edtAcrescimo.Focused then
begin
  // alterar forma desconto
  if lblTipoAcrescimo.caption = 'Acréscimo (R$) :' then
  begin
    lblTipoAcrescimo.caption := 'Acréscimo (%) :';
  end
  else
  begin
    lblTipoAcrescimo.caption := 'Acréscimo (R$) :';
  end;

end;
end;

procedure TfrmContasReceberPgto.edtAcrescimoExit(Sender: TObject);
begin
    if lblTipoAcrescimo.caption = 'Acréscimo (%) :' then
    begin
      // desconto percentual
      edtAcrescimo.Value := (vlrPagar * edtAcrescimo.Value) / 100;
      lblTipoDesconto.caption := 'Acréscimo (R$) :';
    end;




    vlrAcrescimo := edtAcrescimo.value;

    InicializarValores;

end;

procedure TfrmContasReceberPgto.edtCodFinExit(Sender: TObject);
var
  oFinalizadora:TFinalizadora;
begin
  oFinalizadora := TFinalizadora.Create;
  oFinalizadora.codigo := edtCodFin.Text;
  if VariaveisSrv.oFinalizadoraController.CarregarFinalizadora(oFinalizadora) then
  begin
    edtCodFin.text := oFinalizadora.codigo;
    edtDescFin.text := oFinalizadora.descricao;
  end
  else
  begin
    edtCodFin.Text := TfrmLocFinalizadora.Exibe;
    edtCodFin.SetFocus;
  end;
  oFinalizadora.Destroy;

end;

procedure TfrmContasReceberPgto.edtDescontoExit(Sender: TObject);
begin
    if lblTipoDesconto.caption = 'Desconto (%) :' then
    begin
      // desconto percentual
      edtDesconto.Value := (vlrPagar * edtDesconto.Value) / 100;
      lblTipoDesconto.caption := 'Desconto (R$) :';
    end;


  if edtDesconto.value >= vlrPagar then
  begin
    raise Exception.Create('Valor de desconto maior ou igual ao valor de pagamento');
  end
  else
  begin

    vlrDesconto := edtDesconto.value;

    InicializarValores;

  end;
end;

procedure TfrmContasReceberPgto.edtDescontoKeyPress(Sender: TObject;
  var Key: Char);
begin

  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmContasReceberPgto.edtVlrPagamentoKeyPress(Sender: TObject;
  var Key: Char);
begin
if key = #13 then
begin
VariaveisSrv.oContasReceberController.LancarPagamento(edtVlrPagamento.Value,edtDesconto.value,edtAcrescimo.Value,edtCodFin.text);
close;
end;

end;

class function TfrmContasReceberPgto.Exibe(vlrAPagar: Real): Boolean;
var
  frm :TfrmContasReceberPgto;

begin
     frm := TfrmContasReceberPgto.Create(nil);

  try
    vlrPagar := vlrAPagar;
     frm.Visible := False;
     frm.ShowModal;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmContasReceberPgto.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
vlrDesconto := 0;
vlrAcrescimo := 0;
end;

procedure TfrmContasReceberPgto.FormShow(Sender: TObject);
begin
InicializarValores;
edtCodFin.SetFocus;
end;

procedure TfrmContasReceberPgto.InicializarValores;
begin
edtVlrPagamento.Value := (vlrPagar - vlrDesconto)+ vlrAcrescimo;
lblVlrTotal.caption := 'Valor total: '+ FormatFloat('###,###,##0.00',vlrPagar - vlrDesconto + vlrAcrescimo);
end;

end.
