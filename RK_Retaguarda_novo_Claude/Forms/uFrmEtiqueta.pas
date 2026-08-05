unit uFrmEtiqueta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, RzEdit, Vcl.Mask, JvExMask, JvSpin,Classe.Variaveis,Classe.Produto,uFrmLocProduto,
  AdvGlowButton, Vcl.Samples.Spin, AdvSpin, frxClass, frxBarcode, frxDBSet,
  JvToolEdit, Vcl.Menus,Classe.Relatorio,ProdutoController,Produto,EtiquetaController,UIEtiqueta,ProdutoModel,Global,EtiquetaLayoutModel,System.Generics.Collections,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, frxPreview,uFrmLocProduto3;

type
  TfrmEtiqueta = class(TForm,IUIEtiqueta)
    pnCabecalho: TPanel;
    Label4: TLabel;
    grid: TDBGrid;
    edtCodigo: TEdit;
    Label41: TLabel;
    Label43: TLabel;
    edtDescricao: TEdit;
    Label42: TLabel;
    edtUn: TEdit;
    Label45: TLabel;
    Label44: TLabel;
    edtValor: TRzNumericEdit;
    btnImprimir: TBitBtn;
    btnImprimirTodos: TBitBtn;
    btnAdd: TBitBtn;
    pnLateral: TPanel;
    bexcluir: TAdvGlowButton;
    btnExcluirTodos: TAdvGlowButton;
    btnAlterados: TAdvGlowButton;
    ds: TDataSource;
    edtQtd: TAdvSpinEdit;
    PopupMenu1: TPopupMenu;
    S1: TMenuItem;
    btnLocalizar: TBitBtn;
    Label3: TLabel;
    cmbLayout: TComboBox;
    chkImprimirLote: TCheckBox;
    gridEtiqueta: TNextGrid;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    Button2: TButton;
    pnAlterados: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    edtInicio: TJvDateEdit;
    edtFim: TJvDateEdit;
    btnPesquisar: TButton;
    cbUnidade: TComboBox;
    Button1: TButton;
    I1: TMenuItem;
    Panel1: TPanel;
    p1: TMenuItem;

    procedure edtCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure btnAddClick(Sender: TObject);
    procedure bexcluirClick(Sender: TObject);
    procedure btnExcluirTodosClick(Sender: TObject);
    procedure edtQtdKeyPress(Sender: TObject; var Key: Char);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnImprimirTodosClick(Sender: TObject);
    procedure btnAlteradosClick(Sender: TObject);
    procedure edtInicioKeyPress(Sender: TObject; var Key: Char);
    procedure edtFimKeyPress(Sender: TObject; var Key: Char);
    procedure fecharPanelAlterados;
    procedure btnPesquisarClick(Sender: TObject);
    procedure cmbLayoutChange(Sender: TObject);
    procedure chkImprimirLoteClick(Sender: TObject);
    procedure edtCodigoEnter(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
    procedure gridEtiquetaCellClick(Sender: TObject; ACol, ARow: Integer);
    procedure edtCodigoClick(Sender: TObject);
    procedure p1Click(Sender: TObject);
    private
    procedure AbrirPainelAlterados;
    procedure CarregarLayoutEtiquetas(ListaEtiquetasModelo:TObjectList<TEtiquetaLayoutModel>;codigoEtiqueta:string);
    function ObterLayoutSelecionado:TEtiquetaLayoutModel;
  public
    procedure CarregarProduto(Produto: TProdutoModel);
    procedure Abrir(ListaEtiquetasModelo: System.Generics.Collections.TObjectList<EtiquetaLayoutModel.TEtiquetaLayoutModel>;codigoEtiquetaPadrao:string);
    procedure AtualizarInterface(FilaImpressao: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>);







  end;

var
  frmEtiqueta: TfrmEtiqueta;

implementation
  uses Classe.Funcoes;
{$R *.dfm}



procedure TfrmEtiqueta.Abrir(
  ListaEtiquetasModelo: System.Generics.Collections.TObjectList<EtiquetaLayoutModel.TEtiquetaLayoutModel>;codigoEtiquetaPadrao:string);
var
  frm:TfrmEtiqueta;
begin


  self.CarregarLayoutEtiquetas(ListaEtiquetasModelo,codigoEtiquetaPadrao);
Self.Show;

end;

procedure TfrmEtiqueta.AbrirPainelAlterados;
begin
pnAlterados.Visible := true;
edtInicio.SetFocus;
pnLateral.Enabled := false;
pnCabecalho.Enabled := false;
grid.Enabled := false;
edtInicio.date := date;
edtFim.date := date;
end;



procedure TfrmEtiqueta.AtualizarInterface(
 FilaImpressao: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>);
 var
  produto:TProdutoModel;
begin
gridEtiqueta.ClearRows;
if FilaImpressao = nil then exit;

for produto in FilaImpressao do
  begin
    gridEtiqueta.AddRow(1);
    gridEtiqueta.Cells[0,gridEtiqueta.LastAddedRow] := produto.Codigo;
    gridEtiqueta.Cells[1,gridEtiqueta.LastAddedRow] := produto.CodigoBarras;
    gridEtiqueta.Cells[2,gridEtiqueta.LastAddedRow] := produto.Descricao;
    gridEtiqueta.Cells[3,gridEtiqueta.LastAddedRow] := produto.Unidade;
    gridEtiqueta.Cells[4,gridEtiqueta.LastAddedRow] := FloatToStr(produto.Preco);
    gridEtiqueta.Cells[5,gridEtiqueta.LastAddedRow] := produto.Validade;
    gridEtiqueta.Cells[6,gridEtiqueta.LastAddedRow] := produto.Observacao;
  end;

end;

procedure TfrmEtiqueta.bexcluirClick(Sender: TObject);
begin
EtiquetaUseCase.DeletarItem(gridEtiqueta.Cells[0,gridEtiqueta.SelectedRow]);
gridEtiqueta.SelectLastRow;
end;

procedure TfrmEtiqueta.btnAlteradosClick(Sender: TObject);
begin
AbrirPainelAlterados;
end;

procedure TfrmEtiqueta.btnAddClick(Sender: TObject);
begin
EtiquetaUseCase.AdicionarProduto(edtCodigo.Text,edtQtd.value);
EtiquetaUseCase.Preview(edtCodigo.Text,ObterLayoutSelecionado,Panel1);
end;

procedure TfrmEtiqueta.btnExcluirTodosClick(Sender: TObject);
begin
EtiquetaUseCase.DeletarTodosItens;
end;

procedure TfrmEtiqueta.btnImprimirClick(Sender: TObject);
begin
EtiquetaUseCase.CarregarProduto(edtCodigo.Text);
EtiquetaUseCase.ImprimirEtiqueta(edtCodigo.text,ObterLayoutSelecionado.codigo);
edtCodigo.SelectAll;

end;

procedure TfrmEtiqueta.btnImprimirTodosClick(Sender: TObject);
begin
EtiquetaUseCase.ImprimirFilaEtiqueta(ObterLayoutSelecionado.codigo);
end;

procedure TfrmEtiqueta.btnLocalizarClick(Sender: TObject);
var
  codigos: TDictionary<string, Boolean>;
  codigo: string;
begin
  codigos := TFrmLocProduto3.Exibe;

  for codigo in codigos.Keys do
  begin
    EtiquetaUseCase.AdicionarProduto(codigo,1);
  end;

//edtCodigo.Text := TfrmLocProduto.Exibe;
end;

procedure TfrmEtiqueta.btnPesquisarClick(Sender: TObject);
begin
  EtiquetaUseCase.AdicionarItensAlterados(edtInicio.Date,edtFim.Date,cbUnidade.text);
  fecharPanelAlterados;
end;

procedure TfrmEtiqueta.Button1Click(Sender: TObject);
begin
fecharPanelAlterados;
end;

procedure TfrmEtiqueta.Button2Click(Sender: TObject);
begin
EtiquetaUseCase.EditarLayout(ObterLayoutSelecionado);
end;

procedure TfrmEtiqueta.CarregarLayoutEtiquetas(
  ListaEtiquetasModelo: TObjectList<TEtiquetaLayoutModel>;
  codigoEtiqueta: string);
  var
  layout: TEtiquetaLayoutModel;
  i: Integer;
begin
  if ListaEtiquetasModelo = nil then Exit;
  
  self.cmbLayout.Items.Clear;

  // carrega todos os layouts no ComboBox
  for layout in ListaEtiquetasModelo do
    self.cmbLayout.Items.AddObject(layout.nome, layout);

  // procura o layout com o código igual ao padrão
  for i := 0 to cmbLayout.Items.Count - 1 do
  begin
    layout := TEtiquetaLayoutModel(cmbLayout.Items.Objects[i]);
    if Assigned(layout) and (layout.codigo = codigoEtiqueta) then
    begin
      cmbLayout.ItemIndex := i;  // seleciona o layout padrão
      Break;
    end;
  end;

  // se não encontrou nenhum, seleciona o primeiro
  if cmbLayout.ItemIndex < 0 then
    cmbLayout.ItemIndex := 0;
end;

procedure TfrmEtiqueta.CarregarProduto(Produto: TProdutoModel);
begin
  with Produto do
  begin
    edtDescricao.text := Descricao;
    edtValor.Value := Preco;
    edtUn.Text := Unidade;
    edtQtd.Value := 1;
  end;
end;

procedure TfrmEtiqueta.chkImprimirLoteClick(Sender: TObject);
begin
GravaIni('./Preferencias.ini','Etiqueta','ImprimirLote',BoolToStr(chkImprimirLote.Checked));
end;

procedure TfrmEtiqueta.cmbLayoutChange(Sender: TObject);
begin
EtiquetaUseCase.SelecionarLayout(TEtiquetaLayoutModel(cmbLayout.Items.Objects[cmbLayout.ItemIndex]));
EtiquetaUseCase.Preview(edtCodigo.Text,ObterLayoutSelecionado,Panel1);
end;

procedure TfrmEtiqueta.edtCodigoClick(Sender: TObject);
begin
edtCodigo.SelectAll;
end;

procedure TfrmEtiqueta.edtCodigoEnter(Sender: TObject);
begin
edtCodigo.SelectAll;
end;

procedure TfrmEtiqueta.edtCodigoKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
try
EtiquetaUseCase.CarregarProduto(edtCodigo.Text);
edtQtd.SetFocus;
except
on E:Exception do
begin
CarregarProduto(TProdutoModel.create);
edtCodigo.SelectAll;
ShowMessage(e.message);
end;
end;
end;
end;

procedure TfrmEtiqueta.edtFimKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  btnPesquisar.SetFocus;
end;
end;

procedure TfrmEtiqueta.edtInicioKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  edtFim.SetFocus;
end;
end;

procedure TfrmEtiqueta.edtQtdKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
btnAdd.Click;
edtCodigo.SetFocus;
end;
end;


procedure TfrmEtiqueta.fecharPanelAlterados;
begin
pnLateral.Enabled := true;
pnCabecalho.Enabled := true;
grid.Enabled := true;
pnAlterados.Visible := false;
end;



procedure TfrmEtiqueta.gridEtiquetaCellClick(Sender: TObject; ACol,
  ARow: Integer);
begin
EtiquetaUseCase.Preview(gridEtiqueta.Cells[1,gridEtiqueta.SelectedRow],ObterLayoutSelecionado,Panel1);
end;

procedure TfrmEtiqueta.I1Click(Sender: TObject);
begin
btnImprimirTodos.Click;
end;

function TfrmEtiqueta.ObterLayoutSelecionado: TEtiquetaLayoutModel;
begin
    result := TEtiquetaLayoutModel(cmbLayout.Items.Objects[cmbLayout.ItemIndex]);
end;

procedure TfrmEtiqueta.p1Click(Sender: TObject);
begin
btnLocalizar.Click;
end;

procedure TfrmEtiqueta.S1Click(Sender: TObject);
begin
btnImprimir.Click;
end;

end.
