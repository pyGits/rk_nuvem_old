unit uFrmProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, Vcl.ExtCtrls,
  NxColumnClasses, NxColumns, NxScrollControl, NxCustomGridControl,
  NxCustomGrid, NxGrid, Vcl.ComCtrls, Vcl.StdCtrls, JvExMask, JvToolEdit,
  JvBaseEdits, RzDBEdit, Vcl.Mask, RzEdit, RzDBBnEd, NxEdit,Classe.Variaveis,Classe.Produto,Classe.Funcoes,Conversao,
  Vcl.Menus,Classe.Grupo,uFrmLocGrupo,Classe.Subgrupo,uFrmLocSubGrupo,uFrmLocNCM,
  Data.DB, Vcl.Grids, Vcl.DBGrids, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, cxTextEdit, cxDBEdit, Vcl.DBCtrls,uFrmLocCEST,
  dxGDIPlusClasses,uFrmPDVCarga,Classe.NCM,Classe.CEST,uFrmLocProduto,Classe.Fornecedor,uFrmLocFornecedor,Classe.Validade,uFrmValidadeIncluir,
  Datasnap.DBClient, System.ImageList, Vcl.ImgList,Classe.Relatorio,uFrmEstoqueEditar,uFrmValidade,ProdutoController;
type
  TfrmProduto = class(TForm)
    Panel6: TPanel;
    btnAlterar: TAdvGlowButton;
    btnExcluir: TAdvGlowButton;
    btnIncluir: TAdvGlowButton;
    btnCancelar: TAdvGlowButton;
    btnGravar: TAdvGlowButton;
    pcProduto: TPageControl;
    tsLista: TTabSheet;
    tsDetalhe: TTabSheet;
    edtCodigo: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    edtCodigoBarras: TEdit;
    edtDescricao: TEdit;
    Label2: TLabel;
    Label36: TLabel;
    edtGrupoDes: TEdit;
    edtGrupo: TNxButtonEdit;
    Label68: TLabel;
    edtSubgrupo: TNxButtonEdit;
    edtSubgrupoDes: TEdit;
    Label69: TLabel;
    edtFornecedor: TNxButtonEdit;
    edtFornecedorDes: TEdit;
    GroupBox2: TGroupBox;
    Label108: TLabel;
    Label56: TLabel;
    Label107: TLabel;
    Label73: TLabel;
    lblcfop: TLabel;
    RzDBButtonEdit7: TRzDBButtonEdit;
    cbTributacao: TComboBox;
    edtNCM: TNxButtonEdit;
    edtCEST: TNxButtonEdit;
    GroupBox7: TGroupBox;
    Label71: TLabel;
    Label72: TLabel;
    Label117: TLabel;
    AdvGlowButton1: TAdvGlowButton;
    edtCusto: TJvCalcEdit;
    edtMargem: TJvCalcEdit;
    edtPreco: TJvCalcEdit;
    GroupBox22: TGroupBox;
    Label115: TLabel;
    chkFracionado: TCheckBox;
    chkBalanca: TCheckBox;
    edtValidade: TEdit;
    GroupBox23: TGroupBox;
    Label118: TLabel;
    AdvGlowButton8: TAdvGlowButton;
    edtEstoque: TJvCalcEdit;
    Label4: TLabel;
    edtLoc: TEdit;
    Label124: TLabel;
    GroupBox1: TGroupBox;
    cbUN: TComboBox;
    Label8: TLabel;
    chkInativo: TCheckBox;
    chkDiversos: TCheckBox;
    Label5: TLabel;
    edtDataCadastro: TJvDateEdit;
    Label30: TLabel;
    edtDataAlterado: TJvDateEdit;
    cbPesq: TComboBox;
    func: TPopupMenu;
    S1: TMenuItem;
    I1: TMenuItem;
    g1: TMenuItem;
    C1: TMenuItem;
    E1: TMenuItem;
    a1: TMenuItem;
    Grid: TDBGrid;
    t1: TMenuItem;
    ds: TDataSource;
    Image1: TImage;
    C2: TMenuItem;
    StatusBar1: TStatusBar;
    Label6: TLabel;
    edtEstoqueMin: TJvCalcEdit;
    edtEstoqueMax: TJvCalcEdit;
    Label7: TLabel;
    btnEditarEstoque: TAdvGlowButton;
    Label11: TLabel;
    edtEstoqueAnterior: TJvCalcEdit;
    tsVencimento: TTabSheet;
    edtObservacao: TEdit;
    Label9: TLabel;
    timerEditar: TTimer;
    editEditar: TEdit;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure edtLocChange(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
    procedure pcProdutoChange(Sender: TObject);
    procedure edtCodigoBarrasKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodigoBarrasExit(Sender: TObject);
    procedure edtDescricaoKeyPress(Sender: TObject; var Key: Char);
    procedure edtGrupoKeyPress(Sender: TObject; var Key: Char);
    procedure edtSubgrupoKeyPress(Sender: TObject; var Key: Char);
    procedure edtFornecedorKeyPress(Sender: TObject; var Key: Char);
    procedure edtEstoqueKeyPress(Sender: TObject; var Key: Char);
    procedure edtCustoKeyPress(Sender: TObject; var Key: Char);
    procedure edtMargemKeyPress(Sender: TObject; var Key: Char);
    procedure edtPrecoKeyPress(Sender: TObject; var Key: Char);
    procedure edtNCMKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure btnExcluirClick(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure g1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure a1Click(Sender: TObject);
    procedure edtGrupoExit(Sender: TObject);
    procedure edtSubgrupoExit(Sender: TObject);
    procedure edtGrupoButtonDown(Sender: TObject);
    procedure edtSubgrupoButtonClick(Sender: TObject);
    procedure gridSelectCell(Sender: TObject; ACol, ARow: Integer);
    procedure edtNCMButtonClick(Sender: TObject);
    procedure t1Click(Sender: TObject);
    procedure GridCellClick(Column: TColumn);
    procedure edtCESTButtonClick(Sender: TObject);
    procedure edtCESTKeyPress(Sender: TObject; var Key: Char);
    procedure edtNCMExit(Sender: TObject);
    procedure edtLocKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtCESTExit(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure edtFornecedorExit(Sender: TObject);
    procedure edtFornecedorButtonClick(Sender: TObject);
    procedure btnIncluirValidadeClick(Sender: TObject);
    procedure btnEditarEstoqueClick(Sender: TObject);
    procedure timerEditarTimer(Sender: TObject);
    procedure edtGrupoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtSubgrupoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtFornecedorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtSubgrupoClick(Sender: TObject);
    procedure edtGrupoClick(Sender: TObject);
    procedure edtFornecedorClick(Sender: TObject);
  private
    procedure CarregarTabValidade;
    procedure HabilitarControles(aOperacao :TOperacao);
    procedure PreencherCampos(oProduto:TProduto);
    procedure setProduto(oProduto:TProduto);
    procedure Alterar;
    procedure Incluir;
    procedure Gravar;
    procedure Cancelar;
    procedure Excluir;

    procedure calcularMarkup;
  public

  class procedure AbrirForm(codigo:string);
  end;

var
  FOperacao :TOperacao;
  frmProduto: TfrmProduto;

implementation

{$R *.dfm}

{ TfrmProduto }

procedure TfrmProduto.a1Click(Sender: TObject);
begin
if btnAlterar.Enabled then
btnAlterar.Click;
end;

class procedure TfrmProduto.AbrirForm(codigo: string);
var
    frm :TfrmProduto;
    oProduto:TProduto;
begin
  frm := TfrmProduto.Create(nil);
  try
    frm.Visible := False;
    frm.editEditar.Text := codigo;
    frm.timerEditar.Enabled := true;
    frm.showmodal;


  finally
    if (frm<>nil) then
      FreeAndNil(frm);
  end;
end;

procedure TfrmProduto.Alterar;
var
  oProduto:TProduto;
begin
  try
    oProduto := TProduto.Create;
    setProduto(oProduto);
    VariaveisSrv.oProdutoController.AlterarProduto(oProduto);
    VariaveisSrv.oEstoqueController.atualizarSaldo(oProduto.estoqueAnterior,oProduto.Estoque,oProduto.Codigo);

    ShowMessage('Produto alterado com sucesso !');

  finally
  FreeAndNil(oProduto);
  end;
end;

procedure TfrmProduto.btnAlterarClick(Sender: TObject);
begin
  HabilitarControles(opAlterar);
end;

procedure TfrmProduto.btnCancelarClick(Sender: TObject);
begin
Cancelar;
end;

procedure TfrmProduto.btnEditarEstoqueClick(Sender: TObject);
var
  oProduto:TProduto;
begin
  try
  oProduto := TProduto.create;
  setProduto(oProduto);
  TfrmEstoqueEditar.exibe(oProduto);
  VariaveisSrv.oProdutoController.CarregarProduto(oProduto);


  PreencherCampos(oProduto);
  finally
  oProduto.Destroy;

  end;

end;

procedure TfrmProduto.btnExcluirClick(Sender: TObject);
begin
excluir;
end;

procedure TfrmProduto.btnGravarClick(Sender: TObject);
begin
  ActiveControl := nil; // ou para outro controle qualquer
  Application.ProcessMessages; // força processamento do evento OnExit
Gravar;
end;

procedure TfrmProduto.btnIncluirClick(Sender: TObject);
begin
HabilitarControles(opNovo);

end;

procedure TfrmProduto.btnIncluirValidadeClick(Sender: TObject);
var
  oProduto:TProduto;
begin
  try
  oProduto := TProduto.create;
  setProduto(oProduto);
  TfrmValidadeIncluir.exibe(oProduto);
  VariaveisSrv.oProdutoController.CarregarProduto(oProduto);



  PreencherCampos(oProduto);
  finally
  oProduto.Destroy;

  end;

end;

procedure TfrmProduto.C1Click(Sender: TObject);
begin
if btnCancelar.Enabled then
btnCancelar.Click;
end;

procedure TfrmProduto.C2Click(Sender: TObject);
var
  oProduto:TProduto;
begin
if FOperacao = opNavegar then
begin
  if MessageDlg('Deseja cadastrar a partir do produto: '+ds.DataSet.FieldByName('DESCRICAO').AsString,mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin
      HabilitarControles(opNovo);
      oProduto := TProduto.Create;
      oProduto.Codigo := grid.Fields[0].AsString;
      VariaveisSrv.oProdutoController.CarregarProduto(oProduto);
      oProduto.codigo := edtCodigo.text;
      oProduto.Estoque := 0;
      PreencherCampos(oProduto);
      edtCodigoBarras.text := '';
      oProduto.Destroy;


  end;
end;

end;

procedure TfrmProduto.calcularMarkup;
begin
  if (edtPreco.Value > 0) and (edtCusto.Value >0) then
  begin
  edtMargem.Value := ((edtPreco.Value - edtCusto.Value) / edtCusto.Value) *100;
  end;
end;

procedure TfrmProduto.Cancelar;
begin
HabilitarControles(opNavegar);
end;

procedure TfrmProduto.CarregarTabValidade;
var
  frmValidade:TfrmValidade;
begin
try
  frmValidade := TfrmValidade.Create(self);
  frmValidade.Parent := tsVencimento;
  frmvalidade.Align := alClient;
  frmValidade.codigoProduto := edtCodigo.Text;
  frmvalidade.Show;
except

end;
end;

procedure TfrmProduto.E1Click(Sender: TObject);
begin
if btnExcluir.Enabled then
btnExcluir.Click;
end;

procedure TfrmProduto.edtCESTButtonClick(Sender: TObject);
begin
edtCEST.text := frmLocCEST.Exibe(edtNCM.text);
end;

procedure TfrmProduto.edtCESTExit(Sender: TObject);
var
  oCest :TCest;
begin
  oCest := TCEST.Create;
  oCest.NCM := edtNCM.Text;
  oCest.CEST := edtCEST.Text;
  if VariaveisSrv.oCESTController.ValidaCEST(oCest) then
  begin
    //cest validado
    edtCEST.text := oCest.cest;
  end
  else
  begin
    edtCEST.text := '';
  end;


  oCest.destroy;
end;

procedure TfrmProduto.edtCESTKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  btnGravar.SetFocus;
end;
end;

procedure TfrmProduto.edtCodigoBarrasExit(Sender: TObject);
VAR
  oProduto:TProduto;
begin
  if edtCodigoBarras.Text = '' then
  begin
  edtCodigoBarras.text := zeroEsquerda(edtCodigo.text,14);
  end
  else
  begin
  edtCodigoBarras.text := zeroEsquerda(edtCodigoBarras.text,14);
  end;

  oProduto := TProduto.create;
  oProduto.CodigoBarras := edtCodigoBarras.text;
  if VariaveisSrv.oProdutoController.CarregarProduto(oProduto) then
  begin
    // ja existe cadastrado
      If  MessageDlg('Já existe um produto cadastrado com esse código de barras, deseja visualizar ?',mtConfirmation,[mbyes,mbno],0)=mryes then
      begin
        PreencherCampos(oProduto);
        HabilitarControles(opAlterar);
      end
      else
      begin
      tsDetalhe.SetFocus;
      end;


  end;


  oProduto.Destroy


end;

procedure TfrmProduto.edtCodigoBarrasKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
  // permitir apenas numeros
  Key := Ret_Numero(Key,edtCodigoBarras.text);
end;

procedure TfrmProduto.edtCodigoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmProduto.edtCustoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    calcularMarkup;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmProduto.edtDescricaoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmProduto.edtEstoqueKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    edtCusto.SetFocus;
  end;

end;

procedure TfrmProduto.edtFornecedorButtonClick(Sender: TObject);
begin
    edtFornecedor.Text := frmLocFornecedor.Exibe;
end;

procedure TfrmProduto.edtFornecedorClick(Sender: TObject);
begin
edtFornecedor.SelectAll;
end;

procedure TfrmProduto.edtFornecedorExit(Sender: TObject);
var
  oFornecedor:TFornecedor;
begin
  if FOperacao in [opNovo,opAlterar] then
  begin
  oFornecedor := TFornecedor.Create;
  oFornecedor.Codigo := edtFornecedor.Text;

  if VariaveisSrv.oFornecedorController.CarregarFornecedor(oFornecedor) then
  begin
    // encontrou grupo
    edtFornecedor.text := oFornecedor.Codigo;
    edtFornecedorDes.text := oFornecedor.Pessoa.Nome;
  end
  else
  begin
    // tela de localizar rapido
//    oFornecedor.Codigo := frmLocFornecedor.Exibe;
//    VariaveisSrv.oFornecedorController.CarregarFornecedor(oFornecedor);
    // encontrou grupo
//    edtFornecedor.text := oFornecedor.Codigo;
//    edtFornecedorDes.text := oFornecedor.Pessoa.Nome;
    edtFornecedor.Text := '000000';
    edtFornecedorDes.Text := 'TODOS';

  end;

  oFornecedor.Destroy;
  end;

end;

procedure TfrmProduto.edtFornecedorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = vk_f2 then
begin
edtFornecedor.Text := frmLocFornecedor.Exibe;
end;
end;

procedure TfrmProduto.edtFornecedorKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    edtEstoque.setFocus;
  end;
  // permitir apenas numeros
  Key := Ret_Numero(Key,edtFornecedor.text);
end;

procedure TfrmProduto.edtGrupoButtonDown(Sender: TObject);
begin
 edtGrupo.Text := frmLocGrupo.Exibe;
end;

procedure TfrmProduto.edtGrupoClick(Sender: TObject);
begin
edtGrupo.SelectAll;
end;

procedure TfrmProduto.edtGrupoExit(Sender: TObject);
var
  oGrupo:TGrupo;
begin
  if FOperacao in [opNovo,opAlterar] then
  begin
  oGrupo := TGrupo.Create;
  oGrupo.Codigo := edtGrupo.Text;

  if VariaveisSrv.oGrupoController.CarregarGrupo(oGrupo) then
  begin
    // encontrou grupo
    edtGrupo.text := oGrupo.Codigo;
    edtGrupoDes.text := oGrupo.Descricao;
  end
  else
  begin
    // tela de localizar rapido
//    oGrupo.Codigo := frmLocGrupo.Exibe;
    VariaveisSrv.oGrupoController.CarregarGrupo(oGrupo);
    // encontrou grupo
    edtGrupo.text := oGrupo.Codigo;
    edtGrupoDes.text := oGrupo.Descricao;


  end;
  edtSubgrupoDes.Text := '';
  edtSubgrupo.Text := '';
  oGrupo.Destroy;
  end;

end;

procedure TfrmProduto.edtGrupoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if Key = VK_F2 then
begin
edtGrupo.Text :=  frmLocGrupo.Exibe;
end;
end;

procedure TfrmProduto.edtGrupoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;

  // permitir apenas numeros
  Key := Ret_Numero(Key,edtGrupo.text);
end;

procedure TfrmProduto.edtLocChange(Sender: TObject);
begin
  if cbPesq.ItemIndex = 0 then
  begin
      VariaveisSrv.oProdutoController.PreencherGrid(edtloc.text,ds,nome);
  end
  else
  begin
      VariaveisSrv.oProdutoController.PreencherGrid(edtloc.text,ds,codigo);
  end;

end;

procedure TfrmProduto.edtLocKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
  Grid.SetFocus;
end;
end;

procedure TfrmProduto.edtMargemKeyPress(Sender: TObject; var Key: Char);
var
  vlrMargem: double;
  vlrVenda: double;
begin
  if Key = #13 then
  begin
    if (edtMargem.Value > 0) and (edtCusto.Value > 0) then
    begin
      vlrMargem := (edtMargem.value * edtCusto.Value / 100);
      vlrVenda := vlrMargem + edtCusto.value;
      edtPreco.Value := vlrVenda;
    end;


    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;

end;

procedure TfrmProduto.edtNCMButtonClick(Sender: TObject);
begin
  edtNCM.text := frmLocNCM.Exibe;
end;

procedure TfrmProduto.edtNCMExit(Sender: TObject);
var
  oNCM:TNCM;
begin
  oNCM := TNCM.Create;
  edtCEST.Text := '';
  oNCM.NCM := edtNCM.text;

  if VariaveisSrv.oNCMController.ValidarNCM(oNCM) then
  begin
    // ncm validado
    edtNCM.Text := oNCM.NCM;
  end
  else
  begin
    edtNCM.setFocus;
    ShowMessage('NCM Não encontrado !');
  end;

  oNCM.Destroy;
end;

procedure TfrmProduto.edtNCMKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if edtNCM.text = '' then
    begin
    edtNCMButtonClick(self);
    end;
    Key := #0;
    edtCEST.SetFocus;
  end;


end;

procedure TfrmProduto.edtPrecoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
//    Key := #0;
    calcularMarkup;
    edtNCM.SetFocus;
  end;
end;

procedure TfrmProduto.edtSubgrupoButtonClick(Sender: TObject);
begin
 edtSubgrupo.Text := frmlocSubGrupo.Exibe(edtGrupo.text);
end;

procedure TfrmProduto.edtSubgrupoClick(Sender: TObject);
begin
edtSubgrupo.SelectAll;
end;

procedure TfrmProduto.edtSubgrupoExit(Sender: TObject);
var
  oSubGrupo:TSubGrupo;
begin
  if FOperacao in [opNovo,opAlterar] then
  begin
  oSubGrupo := TSubgrupo.Create;
  oSubGrupo.Codigo := edtSubgrupo.Text;
  oSubGrupo.codigoGrupo := edtGrupo.Text;

  if VariaveisSrv.oSubGrupoController.CarregarSubGrupo(oSubGrupo) then
  begin
    // encontrou grupo
    edtSubgrupo.text := oSubGrupo.Codigo;
    edtSubgrupoDes.text := oSubGrupo.Descricao;
  end
  else
  begin
    // tela de localizar rapido
//    oSubGrupo.Codigo := frmLocSubgrupo.Exibe(oSubGrupo.codigoGrupo);
    VariaveisSrv.oSubGrupoController.CarregarSubGrupo(oSubGrupo);
    // encontrou grupo
    edtSubgrupo.text := oSubGrupo.Codigo;
    edtSubgrupoDes.text := oSubGrupo.Descricao;


  end;

  oSubGrupo.Destroy;
  end;
end;

procedure TfrmProduto.edtSubgrupoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = vk_f2 then
begin
edtSubgrupo.Text := frmLocSubgrupo.Exibe(edtGrupo.Text);
end;
end;

procedure TfrmProduto.edtSubgrupoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PERFORM(WM_NEXTDLGCTL, 0, 0);
  end;
  // permitir apenas numeros
  Key := Ret_Numero(Key,edtSubgrupo.text);
end;

procedure TfrmProduto.Excluir;
var
  oProduto:TProduto;
begin
    If  MessageDlg('Tem certeza que deseja excluir o produto: '+grid.Fields[1].AsString + '  ?!' ,mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
      oProduto:= TProduto.Create;
      oProduto.codigo := grid.Fields[0].AsString;
      VariaveisSrv.oProdutoController.ExcluirProduto(oProduto);
      HabilitarControles(opNavegar);
      oProduto.Destroy;
    end;

end;

procedure TfrmProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if VariaveisSrv.oConfiguracoes.Produto.UtilizarCargaAutomatica then
begin
  TfrmPDVCarga.EnviarCargaAlterados;
end;
end;

procedure TfrmProduto.FormShow(Sender: TObject);
var
  oProduto:TProduto;
begin
  HabilitarControles(opNavegar);
  VariaveisSrv.oTributacaoController.PreencherComboBox(cbTributacao);

end;

procedure TfrmProduto.g1Click(Sender: TObject);
begin
if btnGravar.Enabled then
btnGravar.Click;
end;

procedure TfrmProduto.Gravar;
begin
    case FOperacao of
      opNovo: Incluir;
      opAlterar: Alterar;
    end;
      HabilitarControles(opNavegar);
end;

procedure TfrmProduto.GridCellClick(Column: TColumn);
var
  oProduto:TProduto;
  oValidade:TValidade;
begin
  if FOperacao = opNavegar then
  begin
      oProduto := TProduto.Create;
      oProduto.Codigo := grid.Fields[0].AsString;
      VariaveisSrv.oProdutoController.CarregarProduto(oProduto);



      PreencherCampos(oProduto);
      oProduto.Destroy;
  end;
end;

procedure TfrmProduto.gridDblClick(Sender: TObject);
begin
if btnAlterar.enabled then
btnAlterar.Click;
end;

procedure TfrmProduto.gridSelectCell(Sender: TObject; ACol, ARow: Integer);
var
  oProduto:TProduto;
begin
  if FOperacao = opNavegar then
  begin
      oProduto := TProduto.Create;
//      oProduto.Codigo := grid.Cell[0, grid.SelectedRow].AsString;
      VariaveisSrv.oProdutoController.CarregarProduto(oProduto);
      PreencherCampos(oProduto);
      oProduto.Destroy;
  end;
end;

procedure TfrmProduto.HabilitarControles(aOperacao: TOperacao);
var
  oProduto:TProduto;
begin
try
  case aOperacao of
    opNovo:begin
      edtCodigoBarras.Enabled := true;
      // foco pagina
      tsDetalhe.Enabled := true;
      tsVencimento.Enabled := true;
      pcProduto.ActivePage := tsDetalhe;
      // botoes
      btnAlterar.Enabled := false;
      btnExcluir.Enabled := false;
      btnIncluir.Enabled := false;
      btnCancelar.Enabled := true;
      btnGravar.Enabled := true;
      edtLoc.Enabled := false;
      // grid
      oProduto := TProduto.Create;
      oProduto.Codigo := VariaveisSrv.oUtilsController.RetornaSequencial('PRODUTO','CODIGO');
      oProduto.CodigoBarras := Produto_Controller.gerarCodigoBarras;
      PreencherCampos(oProduto);
      freeandnil(oProduto);
      //
      edtCodigoBarras.SetFocus;

      FOperacao := opNovo;
    end;
    opAlterar:begin

      if edtCodigo.Text <> '' then
      begin
        try
        edtCodigoBarras.Enabled := true;
        tsDetalhe.Enabled := true;
        tsVencimento.Enabled := true;

        pcProduto.ActivePage := tsDetalhe;
        // botoes
        btnAlterar.Enabled := false;
        btnExcluir.Enabled := false;
        btnIncluir.Enabled := false;
        btnCancelar.Enabled := true;
        btnGravar.Enabled := true;
        edtLoc.Enabled := false;

        oProduto := TProduto.Create;
        oProduto.Codigo := edtCodigo.Text;
        VariaveisSrv.oProdutoController.CarregarProduto(oProduto);
        PreencherCampos(oProduto);
        FOperacao := opAlterar;
        edtDescricao.SetFocus;
        finally
          FreeAndNil(oProduto);
        end;
      end;



    end;

    opNavegar:begin
      pcProduto.ActivePage := tsLista;
      tsDetalhe.Enabled := false;
      tsVencimento.Enabled := false;
      // botoes
      btnAlterar.Enabled := true;
      btnExcluir.Enabled := true;
      btnIncluir.Enabled := true;
      btnCancelar.Enabled := false;
      btnGravar.Enabled := false;
      edtLoc.Enabled := true;

      VariaveisSrv.oProdutoController.PreencherGrid('',ds,nome);

      oProduto := TProduto.Create;
      VariaveisSrv.oProdutoController.CarregarProduto(oProduto);
      PreencherCampos(oProduto);

      FOperacao := opNavegar;
      freeandnil(oProduto);

    end;
  end;
finally

end;
end;

procedure TfrmProduto.I1Click(Sender: TObject);
begin
if btnIncluir.Enabled then
btnIncluir.Click;
end;

procedure TfrmProduto.Incluir;
var
  oProduto:TProduto;
begin
  try
    oProduto := TProduto.Create;
    setProduto(oProduto);


    VariaveisSrv.oProdutoController.InserirProduto(oProduto);

    ShowMessage('Produto inserido com sucesso !');

  finally
  FreeAndNil(oProduto);
  end;
end;

procedure TfrmProduto.pcProdutoChange(Sender: TObject);
var
  frmvalidade :TFrmValidade;
begin
  if (pcProduto.ActivePage = tsLista) and ((FOperacao = opAlterar) or (FOperacao = opNovo)) then
  begin
    If  MessageDlg('Deseja sair do processo de cadastro ? o produto não sera salvo',mtConfirmation,[mbyes,mbno],0)=mryes then
    begin
    btnCancelar.Click;
    pcProduto.ActivePage := tsLista;
    end
    else
    begin
    pcProduto.ActivePage := tsDetalhe;
    end;

  end;
  CarregarTabValidade;

end;

procedure TfrmProduto.PreencherCampos(oProduto: TProduto);
var
  oSubGrupo:TSubgrupo;
  oFornecedor:TFornecedor;
begin
    // produto
   with oProduto do begin
   edtDescricao.text  := Descricao;
   edtCodigo.text        := Codigo;
   edtCodigoBarras.text  := CodigoBarras;
   edtGrupo.text  := Grupo;
   edtsubGrupo.text  := Subgrupo;
   edtFornecedor.text  := Fornecedor;

   cbTributacao.ItemIndex := cbTributacao.Items.IndexOf(Tributacao);
   cbUN.ItemIndex := cbUN.Items.IndexOf(Unidade);

   edtNCM.text  := NCM;
   edtCEST.text  := CEST;
   edtValidade.text  := Validade;

   chkBalanca.checked  := Balanca;
   chkFracionado.checked  := Fracionado;
   chkInativo.checked  := Inativo;
   chkDiversos.checked  := Diversos;

   edtCusto.Value  := Custo;
   edtPreco.Value  := Preco;
   edtMargem.Value  := Margem;
   edtEstoque.value := Estoque;

   edtDataAlterado.Date := DataAlterado;
   edtDataCadastro.Date := DataCadastro;

   edtEstoqueMin.Value := estoqueMinimo;
   edtEstoqueMax.Value := estoqueMaximo;
   edtEstoqueAnterior.Value := Estoque;
   edtObservacao.Text := Observacao;
   end;
   // grupo e subgrupo
  oSubGrupo := TSubgrupo.Create;
  // grupo
  TGrupo(oSubGrupo).Codigo := edtGrupo.text;
  VariaveisSrv.oGrupoController.CarregarGrupo(oSubGrupo);
  edtGrupoDes.Text := TGrupo(oSubGrupo).Descricao;
  // subgrupo
  oSubGrupo.codigo := edtSubgrupo.text;
  oSubGrupo.codigoGrupo := edtGrupo.text;
  VariaveisSrv.oSubGrupoController.CarregarSubGrupo(oSubGrupo);
  edtSubgrupoDes.Text := oSubGrupo.Descricao;

  // fornecedor
  oFornecedor := TFornecedor.Create;
  oFornecedor.Codigo := edtFornecedor.text;
  VariaveisSrv.oFornecedorController.CarregarFornecedor(oFornecedor);
  edtFornecedorDes.Text := oFornecedor.Pessoa.Nome;

end;

procedure TfrmProduto.S1Click(Sender: TObject);
begin
Close;
end;



procedure TfrmProduto.setProduto(oProduto: TProduto);
begin
  if edtCodigo.Text <> '' then
  begin
    oProduto.SetValidade(edtValidade.text);
    oProduto.setDescricao(edtDescricao.text);
    oProduto.SetCodigo(edtCodigo.text);
    oProduto.SetCodigoBarras(edtCodigoBarras.text);
    oProduto.SetGrupo(edtGrupo.text);
    oProduto.SetSubgrupo(edtSubgrupo.text);
    oProduto.SetFornecedor(edtFornecedor.text);
    oProduto.SetTributacao(cbTributacao.items[cbTributacao.ItemIndex]);
    oProduto.SetUnidade(cbUN.items[cbUN.ItemIndex]);
    oProduto.SetNCM(edtNCM.text);
    oProduto.setCEST(edtCEST.Text);

    oProduto.SetCusto(edtCusto.value);
    oProduto.SetPreco(edtPreco.value);
    oProduto.SetMargem(edtMargem.value);

    oProduto.SetEstoque(edtEstoque.value);
    oProduto.estoqueAnterior := edtEstoqueAnterior.Value;

    oProduto.SetDataCadastro(Date());

    oProduto.SetInativo(chkInativo.Checked);
    oProduto.SetDiversos(chkDiversos.Checked);

    oProduto.SetBalanca(chkBalanca.checked);
    oProduto.SetFracionado(chkFracionado.checked);

    oProduto.SetestoqueMaximo(edtEstoqueMax.Value);
    oProduto.SetestoqueMinimo(edtEstoqueMin.Value);
    oProduto.SetObservacao(edtObservacao.text);
  end;
end;

procedure TfrmProduto.t1Click(Sender: TObject);
begin
HabilitarControles(opNavegar);
end;

procedure TfrmProduto.timerEditarTimer(Sender: TObject);
var
  oProduto:TProduto;
begin

    oProduto := TProduto.Create;
    oProduto.codigo := editEditar.Text;
    VariaveisSrv.oProdutoController.CarregarProduto(oProduto);
    PreencherCampos(oProduto);
    btnAlterar.Click;
    timerEditar.Enabled := false;

end;

end.
