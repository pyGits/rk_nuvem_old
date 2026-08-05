unit uFrmRelSaldoEstoque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls,
  AdvGlowButton, Vcl.Mask, JvExMask, JvToolEdit, AdvSmoothPanel,
  AdvSmoothExpanderPanel,Classe.Relatorio,Classe.Variaveis,Conversao,Classe.Fornecedor,Classe.Grupo,Classe.Subgrupo,
  Vcl.DBCtrls, Vcl.ComCtrls, uFrmLocFornecedor;

type
  TFrmRelSaldoEstoque = class(TForm)
    AdvSmoothExpanderPanel1: TAdvSmoothExpanderPanel;
    Label53: TLabel;
    pnl1: TPanel;
    Label5: TLabel;
    cmbTipo: TComboBox;
    btnVis: TAdvGlowButton;
    PopupMenu1: TPopupMenu;
    F1: TMenuItem;
    Label1: TLabel;
    cbOrdenar: TComboBox;
    cbUN: TComboBox;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    chkPositivo: TCheckBox;
    chkNegativo: TCheckBox;
    chkReposicao: TCheckBox;
    chkZerado: TCheckBox;
    GroupBox2: TGroupBox;
    edtFornecedor: TEdit;
    edtSecao: TEdit;
    edtGrupo: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    edtFornecedorDesc: TEdit;
    edtGrupoDesc: TEdit;
    edtSecaoDesc: TEdit;
    p1: TMenuItem;
    btnLocalizar: TAdvGlowButton;
    rdQuebra: TRadioGroup;
    procedure F1Click(Sender: TObject);
    procedure btnVisClick(Sender: TObject);
    procedure chkZeradoClick(Sender: TObject);
    procedure chkReposicaoMouseActivate(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, HitTest: Integer;
      var MouseActivate: TMouseActivate);
    procedure edtFornecedorClick(Sender: TObject);
    procedure edtSecaoClick(Sender: TObject);
    procedure edtGrupoClick(Sender: TObject);
    procedure edtFornecedorExit(Sender: TObject);
    procedure edtFornecedorKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure p1Click(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
    procedure edtSecaoExit(Sender: TObject);
    procedure edtSecaoKeyPress(Sender: TObject; var Key: Char);
    procedure edtGrupoExit(Sender: TObject);
    procedure edtGrupoKeyPress(Sender: TObject; var Key: Char);

  private
  public
    { Public declarations }
  end;

var
  FrmRelSaldoEstoque: TFrmRelSaldoEstoque;
  tipo:array[0..2] of boolean;

implementation

{$R *.dfm}

procedure TFrmRelSaldoEstoque.btnLocalizarClick(Sender: TObject);
begin
P1.Click;
end;

procedure TFrmRelSaldoEstoque.btnVisClick(Sender: TObject);
var
  oRelatorio :TRelatorio;
begin
  btnVis.SetFocus;
  oRelatorio := TRelatorio.create;
  oRelatorio.tipo := relEstoque;
  oRelatorio.filtro1 := cbUN.Items[cbUN.ItemIndex];
  oRelatorio.ordenar := TOrdenarRelatorio(cbOrdenar.ItemIndex);

  // tipos
  oRelatorio.listaCheckBox1[0] := chkPositivo.Checked;
  oRelatorio.listaCheckBox1[1] := chkNegativo.Checked;
  oRelatorio.listaCheckBox1[2] := chkReposicao.Checked;
  oRelatorio.listaCheckBox1[3] := chkZerado.Checked;


  // filtros
  oRelatorio.listaString1[0] := edtFornecedor.Text;
  oRelatorio.listaString1[1] := edtSecao.Text;
  oRelatorio.listaString1[2] := edtGrupo.Text;


  // quebra
  oRelatorio.itemIndex := rdQuebra.ItemIndex;



  VariaveisSrv.oRelatorioController.RelatorioSaldoEstoque(oRelatorio);


  oRelatorio.Destroy;

end;


procedure TFrmRelSaldoEstoque.chkReposicaoMouseActivate(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y, HitTest: Integer;
  var MouseActivate: TMouseActivate);
begin
 chkPositivo.Checked := false;
chkNegativo.Checked := False;
chkZerado.Checked := false;
end;

procedure TFrmRelSaldoEstoque.chkZeradoClick(Sender: TObject);
begin
chkReposicao.Checked := false;
end;

procedure TFrmRelSaldoEstoque.edtFornecedorClick(Sender: TObject);
begin
edtFornecedor.SelectAll;
end;

procedure TFrmRelSaldoEstoque.edtFornecedorExit(Sender: TObject);
var
  oFornecedor : TFornecedor;
begin
try
  oFornecedor := TFornecedor.create;
  oFornecedor.codigo := edtFornecedor.Text;
  edtFornecedor.Text := oFornecedor.codigo;

    if not (VariaveisSrv.oFornecedorController.CarregarFornecedor(oFornecedor)) then
    begin
      edtFornecedor.SelectAll;
      edtFornecedor.SetFocus;
      ShowMessage('Fornecedor não encontrado');
    end
    else
    begin
      edtFornecedorDesc.Text := oFornecedor.Pessoa.Nome;
    end;

finally
  oFornecedor.Destroy;
end;
end;

procedure TFrmRelSaldoEstoque.edtFornecedorKeyPress(Sender: TObject;
  var Key: Char);
begin
if key = #13 then
begin
  edtSecao.SetFocus;
end;
end;

procedure TFrmRelSaldoEstoque.edtGrupoClick(Sender: TObject);
begin
edtGrupo.SelectAll;
end;

procedure TFrmRelSaldoEstoque.edtGrupoExit(Sender: TObject);
var
  oSubgrupo:TSubgrupo;
begin
  oSubgrupo := TSubgrupo.Create;
  oSubgrupo.codigo := edtGrupo.Text;
  oSubgrupo.codigoGrupo := edtSecao.Text;


  if not VariaveisSrv.oSubGrupoController.CarregarSubGrupo(oSubgrupo) then
  begin
    edtGrupo.Text := '000000';
    edtGrupoDesc.Text := 'TODOS';

    edtGrupo.SelectAll;
    edtGrupo.SetFocus;

    ShowMessage('Subgrupo não encontrado');
  end
  else
  begin
  edtGrupo.Text := oSubgrupo.codigo;
  edtGrupoDesc.Text := oSubgrupo.Descricao;
  end;

end;

procedure TFrmRelSaldoEstoque.edtGrupoKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  btnVis.SetFocus;
end;
end;

procedure TFrmRelSaldoEstoque.edtSecaoClick(Sender: TObject);
begin
edtSecao.SelectAll;
end;

procedure TFrmRelSaldoEstoque.edtSecaoExit(Sender: TObject);
var
  oGrupo : TGrupo;
begin
try
  oGrupo := TGrupo.create;
  oGrupo.codigo := edtSecao.Text;

    if not VariaveisSrv.oGrupoController.CarregarGrupo(oGrupo) then
    begin
      edtSecao.Text := '000000';
      edtSecaoDesc.Text := 'TODOS';
      edtSecao.SelectAll;
      edtSecao.SetFocus;
      ShowMessage('Grupo não encontrado');

    end
    else
    begin
      edtSecao.Text := oGrupo.codigo;
      edtSecaoDesc.Text := oGrupo.Descricao;
    end;

finally
  oGrupo.Destroy;
end;
end;

procedure TFrmRelSaldoEstoque.edtSecaoKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  edtGrupo.SetFocus;
end;
end;

procedure TFrmRelSaldoEstoque.F1Click(Sender: TObject);
begin
Close;
end;

procedure TFrmRelSaldoEstoque.FormShow(Sender: TObject);
begin
edtFornecedor.SetFocus;
end;

procedure TFrmRelSaldoEstoque.p1Click(Sender: TObject);
begin
if edtFornecedor.Focused then
begin
frmLocFornecedor := TfrmLocFornecedor.Create(self);
frmLocFornecedor.ShowModal;
end;
end;

end.
