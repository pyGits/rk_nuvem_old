
unit uFrmValidade;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Mask,
  JvExMask, JvToolEdit, Vcl.ExtCtrls, AdvGlowButton, Vcl.Grids, Vcl.DBGrids,Classe.Produto,Classe.Variaveis,Classe.Relatorio,
  System.ImageList, Vcl.ImgList,Classe.Validade,uFrmValidadeIncluir,uFrmLocProduto,
  MemDS, DBAccess, Uni, sPanel, JvBaseEdits, Vcl.Buttons, frxClass, frxDBSet,uDmValidade;

type
  TfrmValidade = class(TForm)
    GridValidade: TDBGrid;
    Panel1: TPanel;
    lblProdutoValidade: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    btnIncluirValidade: TAdvGlowButton;
    rdSituacao: TRadioGroup;
    btnConferir: TAdvGlowButton;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    edtVencInicio: TJvDateEdit;
    edtVencFim: TJvDateEdit;
    btnLocalizar: TAdvGlowButton;
    btnSelecionarTodos: TAdvGlowButton;
    btnPesquisarTodos: TAdvGlowButton;
    dsValidade: TDataSource;
    ImageList1: TImageList;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    edtCodigoBarras: TEdit;
    edtProduto: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtCodigo: TEdit;
    sPanel1: TsPanel;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    edtId: TEdit;
    Label7: TLabel;
    edtVenc: TJvDateEdit;
    Label11: TLabel;
    edtQtd: TJvCalcEdit;
    Label4: TLabel;
    edtLote: TEdit;
    AdvGlowButton1: TAdvGlowButton;
    edtDtEntrada: TJvDateEdit;
    Label5: TLabel;
    btnExcluir: TAdvGlowButton;
    btnImprimir: TBitBtn;
    dbValidade: TfrxDBDataset;
    frxReport1: TfrxReport;
    cbFiltro: TComboBox;
    Label8: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnPesquisarTodosClick(Sender: TObject);
    procedure btnLocalizarClick(Sender: TObject);
    procedure GridValidadeDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure GridValidadeDblClick(Sender: TObject);
    procedure GridValidadeKeyPress(Sender: TObject; var Key: Char);
    procedure btnSelecionarTodosClick(Sender: TObject);
    procedure btnConferirClick(Sender: TObject);
    procedure btnIncluirValidadeClick(Sender: TObject);
    procedure edtCodigoBarrasKeyPress(Sender: TObject; var Key: Char);
    procedure GridValidadeTitleClick(Column: TColumn);
    procedure dsValidadeDataChange(Sender: TObject; Field: TField);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure edtCodigoBarrasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
  procedure FiltrarPorStatus;

    procedure selecionarLinhaGrid;
    procedure preencherCampos(oProduto:TProduto);
  public
    oProduto:TProduto;
    codigoProduto:string;
  end;

var
  frmValidade: TfrmValidade;

implementation

{$R *.dfm}

{ TfrmValidade }

procedure TfrmValidade.AdvGlowButton1Click(Sender: TObject);
var
  oValidade:TValidade;
begin
if edtId.Text = '' then
begin
  raise Exception.Create('Selecione uma validade para editar !');
end;

try
oValidade := TValidade.Create;
oValidade.id :=StrToInt(edtId.Text);
oValidade.DataVencimento := edtVenc.Date;
oValidade.Quantidade := edtQtd.Value;
oValidade.DataEntrada := edtDtEntrada.Date;
oValidade.lote := edtLote.Text;
if VariaveisSrv.oValidadeController.atualizarValidade(oValidade) then
begin
  showmessage('Validade atualizada com sucesso !');
  btnPesquisarTodos.Click;
end;
finally

end;


end;

procedure TfrmValidade.btnConferirClick(Sender: TObject);
var
  oValidade:TValidade;
begin
try
dsValidade.DataSet.First;
oValidade := TValidade.Create;

  while not dsValidade.DataSet.Eof do
  begin
    if dsValidade.DataSet.FieldByName('ID').AsString <> '' then
    begin
      oValidade.Codigo := dsValidade.DataSet.FieldByName('ID').AsString;

      if dsValidade.DataSet.FieldByName('SELECIONADO').AsString  = '1' then
      begin
      VariaveisSrv.oValidadeController.conferirValidade(oValidade);
      end;
    end;

    dsValidade.DataSet.Next;
  end;
finally
oValidade.Destroy;

ShowMessage('Produtos conferidos ! ');
btnPesquisarTodos.Click;


end;
end;

procedure TfrmValidade.btnExcluirClick(Sender: TObject);
begin
if edtId.Text = '' then
begin
  raise Exception.Create('Selecione uma validade para editar !');
end;

try
if VariaveisSrv.oValidadeController.deletarValidade(StrToInt(edtId.text)) then
begin
  showmessage('Validade deletada com sucesso !');
end;
finally
  btnPesquisarTodos.Click;
end;
end;

procedure TfrmValidade.btnImprimirClick(Sender: TObject);
begin
  frxReport1.LoadFromFile('\System_RK\server\relatorios\relValidade.fr3');
  frxReport1.ShowReport;
end;

procedure TfrmValidade.btnIncluirValidadeClick(Sender: TObject);
var
  oProduto:TProduto;
begin
//
  try

  oProduto := TProduto.create;
  if edtCodigo.Text <> '' then
  begin
  oProduto.Codigo := edtCodigo.Text;
  end;
  VariaveisSrv.oProdutoController.CarregarProduto(oProduto);
  TfrmValidadeIncluir.exibe(oProduto);
  btnPesquisarTodos.Click;

  finally
  oProduto.Destroy;

  end;


end;

procedure TfrmValidade.btnLocalizarClick(Sender: TObject);
var
  oRelatorio :TRelatorio;
begin
try
  oRelatorio := TRelatorio.Create;
  oRelatorio.periodoInicial := edtVencInicio.Date;
  oRelatorio.periodoFinal := edtVencFim.Date;
  oRelatorio.itemIndex := rdSituacao.ItemIndex;
  oRelatorio.itemIndex1 := cbFiltro.ItemIndex;
  VariaveisSrv.oValidadeController.carregarGridValidade(dsValidade,edtCodigo.text,oRelatorio);
  FiltrarPorStatus;

finally
  oRelatorio.Destroy;
end;
end;

procedure TfrmValidade.btnPesquisarTodosClick(Sender: TObject);
begin
  if codigoProduto <> '' then
  begin
  VariaveisSrv.oValidadeController.carregarGridValidade(dsValidade,oProduto.Codigo);
  end
  else
  begin
  VariaveisSrv.oValidadeController.carregarGridValidade(dsValidade);
  end;
end;

procedure TfrmValidade.btnSelecionarTodosClick(Sender: TObject);
begin
dsValidade.Edit;
dsValidade.DataSet.First;
while not dsValidade.DataSet.Eof do
begin
  dsValidade.Edit;
  if dsValidade.DataSet.FieldByName('SITUACAO').AsInteger <> 1 then
  begin
  dsValidade.DataSet.FieldByName('SELECIONADO').AsInteger := 1;
  end;
    dsValidade.DataSet.Next;
end;
end;

procedure TfrmValidade.dsValidadeDataChange(Sender: TObject; Field: TField);
var
  validade:TValidade;
  id:integer;
begin
  if not dsValidade.DataSet.IsEmpty then
  begin
  id := dsValidade.DataSet.FieldByName('ID').AsInteger;
  validade := VariaveisSrv.oValidadeController.carregarValidade(id);

  edtId.Text := validade.id.ToString();
  edtVenc.Date := validade.DataVencimento;
  edtQtd.Value := validade.Quantidade;
  edtLote.Text := validade.lote;
  edtDtEntrada.Date := validade.DataEntrada;
  end;
end;

procedure TfrmValidade.edtCodigoBarrasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = VK_F2 then
begin
edtCodigoBarras.Text :=  TfrmLocProduto.Exibe;
edtCodigoBarras.SetFocus;
end;
end;

procedure TfrmValidade.edtCodigoBarrasKeyPress(Sender: TObject; var Key: Char);
var
  oProduto:TProduto;
begin


if key = #13 then
begin
  try
    oProduto := TProduto.create;
    if edtCodigoBarras.Text <> '' then
    begin

      oProduto.CodigoBarras := edtCodigoBarras.Text;

      if VariaveisSrv.oProdutoController.CarregarProduto(oProduto) then
      begin    // preencher
        preencherCampos(oProduto);
        btnLocalizar.Click;
      end
      else
      if (VariaveisSrv.oProdutoController.CarregarProduto(oProduto,edtCodigoBarras.Text)) then
      begin
        preencherCampos(oProduto);
        edtQtd.SetFocus;
      end
      else
      begin
        edtCodigoBarras.Text :=  TfrmLocProduto.Exibe;
        edtCodigoBarras.SetFocus;
      end;
    end
    else
    begin
      // todos
      preencherCampos(oProduto);
      btnPesquisarTodos.Click;
    end;

  finally
    oProduto.Destroy;
    edtCodigoBarras.SetFocus;
    edtCodigoBarras.SelectAll;
  end;
end;
end;

procedure TfrmValidade.FiltrarPorStatus;
var
  Filtro: string;
begin
  
end;

procedure TfrmValidade.FormShow(Sender: TObject);
begin
try
  oProduto := TProduto.create;
  edtVencInicio.Date :=IncMonth(now,-12);
  edtVencFim.Date := IncMonth(now,24);
  if codigoProduto <> '' then
  begin
    // cadastro produto
  oProduto.Codigo := codigoProduto;
  VariaveisSrv.oProdutoController.CarregarProduto(oProduto);

  edtCodigo.Enabled := false;
  edtCodigoBarras.Enabled := false;
  edtProduto.Enabled := false;
  VariaveisSrv.oValidadeController.carregarGridValidade(dsValidade,oProduto.Codigo);
  end
  else
  begin
    // se não tiver código traz todos
  VariaveisSrv.oValidadeController.carregarGridValidade(dsValidade);
  edtCodigoBarras.Enabled := true;
  edtProduto.Enabled := true;
  edtCodigo.Enabled := true;
  end;
  preencherCampos(oProduto);
finally


end;
end;

procedure TfrmValidade.GridValidadeDblClick(Sender: TObject);
begin
selecionarLinhaGrid;
end;

procedure TfrmValidade.GridValidadeDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
if dsValidade.DataSet.FieldByName('SELECIONADO').AsInteger = 1 then
begin

  GridValidade.Canvas.Brush.Color := $004080FF;
  gridvalidade.Canvas.FillRect(Rect);
  gridvalidade.DefaultDrawColumnCell(Rect, DataCol, Column, State);

end;
//
   if Column.FieldName = 'PROXIMO_VENCIMENTO' then
   begin
     GridValidade.Canvas.Brush.Color := clWhite;
     GridValidade.Canvas.Font.color := clWhite;
     GridValidade.Canvas.FillRect(Rect);
     GridValidade.DefaultDrawDataCell(Rect, GridValidade.columns[datacol].field, State);

     GridValidade.Canvas.FillRect(Rect);
     if Column.Field.Text = 'OK' then
     begin
      ImageList1.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 2)
     end
     else
     if Column.Field.Text = 'ALERTA' then
     begin
     ImageList1.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 4);
     end;
     if Column.Field.Text = 'NEGATIVO' then
     begin
     ImageList1.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 3);
     end;
     if Column.Field.Text = 'A_CONFERIR' then
     begin
     ImageList1.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 1);
     end;

   end;

end;

procedure TfrmValidade.GridValidadeKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then
begin
selecionarLinhaGrid
end;
end;

procedure TfrmValidade.GridValidadeTitleClick(Column: TColumn);
begin
VariaveisSrv.oValidadeController.ordenarGrid(column);
end;

procedure TfrmValidade.preencherCampos(oProduto: TProduto);
begin
with oProduto do
begin
edtCodigo.Text := Codigo;
edtCodigoBarras.Text := CodigoBarras;
edtProduto.Text := Descricao;
end;
end;

procedure TfrmValidade.selecionarLinhaGrid;
begin
dsvalidade.Edit;
if (dsValidade.DataSet.FieldByName('ID').AsString <> '') and (dsValidade.DataSet.FieldByName('SITUACAO').AsInteger <> 1) then
begin
  if dsValidade.DataSet.FieldByName('SELECIONADO').AsInteger  = 0 then
  begin
  dsValidade.DataSet.FieldByName('SELECIONADO').AsInteger := 1;
  end
  else
  begin
  dsValidade.DataSet.FieldByName('SELECIONADO').AsInteger := 0;
  end;

end;
GridValidade.Refresh;
end;

end.
