unit uFrmValidadeIncluir;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,Classe.Validade,
  Vcl.Mask, JvExMask, JvToolEdit, JvBaseEdits, AdvGlowButton,System.DateUtils,Classe.Variaveis,Classe.Produto,
  Vcl.Menus,uFrmLocProduto;

type
  TfrmValidadeIncluir = class(TForm)
    Panel6: TPanel;
    Panel1: TPanel;
    edtDiasVenc: TEdit;
    edtQtd: TJvCalcEdit;
    edtVenc: TJvDateEdit;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnGravar: TAdvGlowButton;
    btnCancelar: TAdvGlowButton;
    PopupMenu1: TPopupMenu;
    G1: TMenuItem;
    C1: TMenuItem;
    Label1: TLabel;
    edtCodBarras: TEdit;
    Label6: TLabel;
    edtDesc: TEdit;
    edtCodigo: TEdit;
    Label3: TLabel;
    edtLote: TEdit;
    Label7: TLabel;
    procedure FormShow(Sender: TObject);
    procedure edtDiasVencExit(Sender: TObject);
    procedure edtDiasVencKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnGravarClick(Sender: TObject);
    procedure edtLocalizacaoKeyPress(Sender: TObject; var Key: Char);
    procedure edtQtdKeyPress(Sender: TObject; var Key: Char);
    procedure edtVencKeyPress(Sender: TObject; var Key: Char);
    procedure edtVencExit(Sender: TObject);
    procedure edtDiasVencKeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelarClick(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure edtCodBarrasKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodBarrasExit(Sender: TObject);
    procedure edtLoteKeyPress(Sender: TObject; var Key: Char);
  private
    procedure Gravar;
    procedure preencherCampos(oProduto:TProduto);
    procedure alterarDataVencimento;
    procedure calcularDiasVencimento;
    procedure alterarDiasVencimento;

  public
    class function Exibe(oProduto:TProduto):Boolean;
  end;

var
  frmValidadeIncluir: TfrmValidadeIncluir;
  sProdutoVal:string;

implementation
  uses Classe.Funcoes;
{$R *.dfm}

{ TfrmValidadeIncluir }



{ TfrmValidadeIncluir }



procedure TfrmValidadeIncluir.alterarDataVencimento;
begin
if validarData(edtVenc.text) then
  begin
  edtDiasVenc.Text := IntToStr(diferencaDias(Now,edtVenc.Date));
  end
  else
  begin
  edtVenc.Text := '';
  edtDiasVenc.Text := '';
  end;
end;

procedure TfrmValidadeIncluir.alterarDiasVencimento;
begin
  if edtDiasVenc.Text <> '' then
  begin
  edtVenc.Date := adicionarDiasData(now,StrToInt(edtDiasVenc.text));
  end;
end;

procedure TfrmValidadeIncluir.btnCancelarClick(Sender: TObject);
begin
Close;
end;

procedure TfrmValidadeIncluir.btnGravarClick(Sender: TObject);
begin
Gravar;
end;

procedure TfrmValidadeIncluir.C1Click(Sender: TObject);
begin
btnCancelar.Click;
end;

procedure TfrmValidadeIncluir.calcularDiasVencimento;
begin
  if edtDiasVenc.Text <> '' then
  begin
  edtVenc.Date := IncDay(Now(),StrToInt(edtDiasVenc.Text));
  end;
end;

procedure TfrmValidadeIncluir.edtCodBarrasExit(Sender: TObject);
var
  oProduto:TProduto;
begin
oProduto := TProduto.create;
oProduto.CodigoBarras := edtCodBarras.Text;

if VariaveisSrv.oProdutoController.CarregarProduto(oProduto) then
begin    // preencher
  preencherCampos(oProduto);

end
else
if (VariaveisSrv.oProdutoController.CarregarProduto(oProduto,edtCodBarras.Text)) then
begin
  preencherCampos(oProduto);
end
else
begin
edtCodBarras.Text :=  TfrmLocProduto.Exibe;
edtCodBarras.SetFocus;
end;

//if VariaveisSrv.oProdutoController.CarregarProduto(oProduto) then
//begin
//  preencherCampos(oProduto);
//end
//else
//begin
//  edtCodBarras.Text :=  TfrmLocProduto.Exibe;
//  edtCodBarras.SetFocus;
//end;
end;

procedure TfrmValidadeIncluir.edtCodBarrasKeyPress(Sender: TObject;
  var Key: Char);
begin
if Key = #13 then
begin
  edtVenc.SetFocus;
end;
end;

procedure TfrmValidadeIncluir.edtDiasVencExit(Sender: TObject);
begin
calcularDiasVencimento;
end;

procedure TfrmValidadeIncluir.edtDiasVencKeyPress(Sender: TObject;
  var Key: Char);
begin
if key =#13 then
begin
alterarDiasVencimento;
edtQtd.SetFocus;
end;
end;

procedure TfrmValidadeIncluir.edtDiasVencKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
alterarDiasVencimento;
end;

procedure TfrmValidadeIncluir.edtLocalizacaoKeyPress(Sender: TObject;
  var Key: Char);
begin
if key = #13 then
begin
  edtQtd.SetFocus;
end;
end;

procedure TfrmValidadeIncluir.edtLoteKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  btnGravar.SetFocus;
end;
end;

procedure TfrmValidadeIncluir.edtQtdKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
edtLote.SetFocus;
end;
end;

procedure TfrmValidadeIncluir.edtVencExit(Sender: TObject);
begin
alterarDataVencimento;
end;

procedure TfrmValidadeIncluir.edtVencKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  edtDiasVenc.SetFocus;
end;
end;

class function TfrmValidadeIncluir.Exibe(oProduto:TProduto): Boolean;
var
  frm :TfrmValidadeIncluir;

begin
     frm := TfrmValidadeIncluir.Create(nil);
  try
    if oProduto.Codigo <> '000000' then
    begin
     frm.edtCodigo.Text := oProduto.Codigo;
     frm.edtCodBarras.Text := oProduto.CodigoBarras;
     frm.edtDesc.Text := oProduto.Descricao;
     frm.ShowModal;
    end
    else
    begin
     frm.edtCodigo.Enabled := true;
     frm.edtCodigo.ReadOnly := true;
     frm.edtCodBarras.Enabled := true;

     frm.ShowModal;
    end;

  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;


procedure TfrmValidadeIncluir.FormShow(Sender: TObject);
begin
if edtCodigo.Text <> '' then
begin
edtVenc.SetFocus;
end
else
begin
edtCodBarras.SetFocus;
end;
edtVenc.Date := IncMonth(now, 1 );
alterarDataVencimento;
end;

procedure TfrmValidadeIncluir.G1Click(Sender: TObject);
begin
btnGravar.Click;
end;

procedure TfrmValidadeIncluir.Gravar;
var
  oValidade:TValidade;
begin
try
  oValidade := TValidade.Create;

  oValidade.Codigo := edtCodigo.Text;
  oValidade.Quantidade := edtQtd.Value;
  oValidade.DataVencimento := edtVenc.Date;
  ovalidade.DiasVencimento := StrToInt(edtDiasVenc.Text);
  ovalidade.lote := edtLote.Text;


  if VariaveisSrv.oValidadeController.inserirValidade(oValidade) then
  begin
    ShowMessage('Inserido com sucesso !');
    Close;
  end;

finally
  oValidade.Destroy;
end;


end;

procedure TfrmValidadeIncluir.preencherCampos(oProduto: TProduto);
begin
with oProduto do
begin
  edtCodigo.text := Codigo;
  edtCodBarras.Text := CodigoBarras;
  edtDesc.Text := Descricao;
end;
end;

end.
