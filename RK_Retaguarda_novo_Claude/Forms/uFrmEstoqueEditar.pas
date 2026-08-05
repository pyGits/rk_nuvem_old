unit uFrmEstoqueEditar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, AdvGlowButton, JvToolEdit,
  Vcl.Mask, JvExMask, JvBaseEdits, Vcl.StdCtrls, Vcl.ExtCtrls,Classe.Produto,uFrmValidadeIncluir,Classe.Validade;

type
  TfrmEstoqueEditar = class(TForm)
    Panel6: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    edtCodigo: TEdit;
    edtAdcEstoque: TJvCalcEdit;
    Panel1: TPanel;
    btnGravar: TAdvGlowButton;
    btnCancelar: TAdvGlowButton;
    PopupMenu1: TPopupMenu;
    G1: TMenuItem;
    C1: TMenuItem;
    Label1: TLabel;
    edtEstoqueAtual: TJvCalcEdit;
    Label4: TLabel;
    edtDimEstoque: TJvCalcEdit;
    edtProdutoDesc: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtCodBarras: TEdit;
    grpValidade: TGroupBox;
    Label7: TLabel;
    edtVenc: TJvDateEdit;
    Label8: TLabel;
    edtDiasVenc: TEdit;
    edtEstoqueAnterior: TJvCalcEdit;
    chkValidade: TCheckBox;
    edtQtdAlterada: TJvCalcEdit;
    Label9: TLabel;
    procedure btnEditarEstoqueClick(Sender: TObject);
    procedure edtAdcEstoqueKeyPress(Sender: TObject; var Key: Char);
    procedure edtAdcEstoqueExit(Sender: TObject);
    procedure edtDimEstoqueExit(Sender: TObject);
    procedure edtDimEstoqueKeyPress(Sender: TObject; var Key: Char);
    procedure btnGravarClick(Sender: TObject);
    procedure edtEstoqueAtualKeyPress(Sender: TObject; var Key: Char);
    procedure edtDiasVencKeyPress(Sender: TObject; var Key: Char);
    procedure edtDiasVencKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtVencExit(Sender: TObject);
    procedure chkValidadeClick(Sender: TObject);
    procedure edtEstoqueAtualExit(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    procedure calcularEstoqueFuturo;
    procedure alterarDiasVencimento;
    procedure alterarDataVencimento;
    procedure Gravar;

  public
    class function exibe(oProduto:TProduto):Boolean;
  end;

var
  frmEstoqueEditar: TfrmEstoqueEditar;


implementation
  uses classe.variaveis,classe.funcoes;

{$R *.dfm}

{ TfrmEstoqueEditar }



procedure TfrmEstoqueEditar.alterarDataVencimento;
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

procedure TfrmEstoqueEditar.alterarDiasVencimento;

begin
  if edtDiasVenc.Text <> '' then
  begin
  edtVenc.Date := adicionarDiasData(now,StrToInt(edtDiasVenc.text));
  end;

end;

procedure TfrmEstoqueEditar.btnCancelarClick(Sender: TObject);
begin
close;
end;

procedure TfrmEstoqueEditar.btnEditarEstoqueClick(Sender: TObject);
var
  frmValidade:TfrmValidadeIncluir;
begin
  frmValidade := TfrmValidadeIncluir.Create(self);
  frmValidade.ShowModal;
end;

procedure TfrmEstoqueEditar.btnGravarClick(Sender: TObject);

begin
Gravar;
end;

procedure TfrmEstoqueEditar.C1Click(Sender: TObject);
begin
btnCancelar.Click;
end;

procedure TfrmEstoqueEditar.calcularEstoqueFuturo;
begin
edtEstoqueAtual.Value := edtEstoqueAtual.Value + edtAdcEstoque.Value;
edtEstoqueAtual.Value := edtEstoqueAtual.Value - edtDimEstoque.Value;
edtAdcEstoque.Value := 0;
edtDimEstoque.Value := 0;
edtQtdAlterada.Value := edtEstoqueAtual.Value - edtEstoqueAnterior.Value;
end;

procedure TfrmEstoqueEditar.chkValidadeClick(Sender: TObject);
begin
if chkValidade.Checked then
begin
  grpValidade.Enabled := true;
  edtVenc.Enabled := true;
  edtDiasVenc.Enabled := true;
end
else
begin
  edtVenc.Text := '';
  edtDiasVenc.Text := '';
  grpValidade.Enabled := false;
  edtVenc.Enabled := false;
  edtDiasVenc.Enabled := false;
end;
end;

procedure TfrmEstoqueEditar.edtAdcEstoqueExit(Sender: TObject);
begin
calcularEstoqueFuturo;
end;

procedure TfrmEstoqueEditar.edtAdcEstoqueKeyPress(Sender: TObject;
  var Key: Char);
begin
if key = #13 then
begin
  calcularEstoqueFuturo;
end;
end;

procedure TfrmEstoqueEditar.edtDiasVencKeyPress(Sender: TObject; var Key: Char);
begin
if key =#13 then
begin
alterarDiasVencimento;
end;
end;

procedure TfrmEstoqueEditar.edtDiasVencKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
alterarDiasVencimento;
end;

procedure TfrmEstoqueEditar.edtDimEstoqueExit(Sender: TObject);
begin
calcularEstoqueFuturo;
end;

procedure TfrmEstoqueEditar.edtDimEstoqueKeyPress(Sender: TObject;
  var Key: Char);
begin
if key = #13 then
begin
  calcularEstoqueFuturo;
end;
end;

procedure TfrmEstoqueEditar.edtEstoqueAtualExit(Sender: TObject);
begin
calcularEstoqueFuturo;
end;

procedure TfrmEstoqueEditar.edtEstoqueAtualKeyPress(Sender: TObject;
  var Key: Char);
begin
if key = #13 then
begin
  edtAdcEstoque.SetFocus;
end;
end;

procedure TfrmEstoqueEditar.edtVencExit(Sender: TObject);
begin
alterarDataVencimento;
end;

class function TfrmEstoqueEditar.exibe(oProduto: TProduto): Boolean;
var
  frm :TfrmEstoqueEditar;

begin
     frm := TfrmEstoqueEditar.Create(nil);

  try
     frm.edtCodigo.Text := oProduto.Codigo;
     frm.edtCodBarras.Text := oProduto.CodigoBarras;
     frm.edtProdutoDesc.Text := oProduto.Descricao;
     frm.edtEstoqueAtual.Value := oProduto.Estoque;
     frm.edtEstoqueAnterior.Value := oproduto.estoqueAnterior;

     frm.Visible := False;
     frm.ShowModal;
  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmEstoqueEditar.G1Click(Sender: TObject);
begin
Gravar;
end;

procedure TfrmEstoqueEditar.Gravar;
var
  oValidade:TValidade;
  qtdValidade:Real;
begin
 try
  qtdValidade := edtQtdAlterada.Value;




  if chkValidade.Checked then
  begin
    if qtdValidade <= 0 then
    begin
      raise Exception.Create('Quantidade alterada não pode ser zero ou negativo para inserir validade !');
    end
    else
    begin
      oValidade := TValidade.Create;
      oValidade.DataVencimento := edtVenc.Date;
      oValidade.Quantidade := qtdValidade;
      oValidade.Codigo := edtCodigo.Text;
      VariaveisSrv.oValidadeController.inserirValidade(oValidade);
      oValidade.Destroy;
      close;
    end;


  end;

    if VariaveisSrv.oEstoqueController.atualizarSaldo(edtEstoqueAnterior.Value,edtEstoqueAtual.Value,edtCodigo.Text) then
    begin
      ShowMessage('Atualizado com sucesso !');
    end;



finally



end;

end;

end.
