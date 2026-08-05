unit EtiquetaPrinterFast;

interface

uses
  System.Generics.Collections,
  EtiquetaPrinter,
  frxClass,
  frxDBSet,
  ProdutoModel,
  EtiquetaLayoutModel,
  ConfiguracaoRepositoryImpl,
  FireDAC.Comp.Client,
  System.SysUtils,
  Data.DB,
  frxDMPClass,
  VCL.forms,
  vcl.controls,
  Vcl.ExtCtrls,
  frxPreview,
  frxDesgnCtrls;

type
  TEtiquetaPrinterFast = class(TInterfacedObject, IEtiquetaPrinter)
  private
    frxEtiqueta: TfrxReport;
    frxDataset: TfrxDBDataset;
    memProduto: TFDMemTable;

    procedure VincularTodosAoDataset(const Obj: TfrxComponent);
  public
    constructor Create;
    procedure Imprimir(produto: TProdutoModel; layout: TEtiquetaLayoutModel);

    procedure EditarLayout(layout: TEtiquetaLayoutModel);
    procedure ImprimirFila(ListaProdutos: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
      layout: TEtiquetaLayoutModel);

    procedure Preview(produto: TProdutoModel; layout: TEtiquetaLayoutModel; ParentPanel: TPanel);

  end;

implementation

{ TEtiquetaPrinterFast }

constructor TEtiquetaPrinterFast.Create;
begin
  frxEtiqueta := TFrxReport.Create(nil);

  // Dataset em memória
  memProduto := TFDMemTable.Create(nil);
  memProduto.FieldDefs.Add('CODIGO_BARRAS', ftString, 50);
  memProduto.FieldDefs.Add('PRODUTO', ftString, 255);
  memProduto.FieldDefs.Add('UNIDADE', ftString, 3);
  memProduto.FieldDefs.Add('OBSERVACAO', ftString, 255);
  memProduto.FieldDefs.Add('PRECO', ftFloat);
  memProduto.FieldDefs.Add('PRECO2', ftFloat);
  memProduto.FieldDefs.Add('PRECO2_QTD', ftFloat);
  memProduto.CreateDataSet;

  // Cria dataset para o FastReport
  frxDataset := TfrxDBDataset.Create(nil);
  frxDataset.DataSet := memProduto;
  frxDataset.UserName := 'gridEtiqueta';
  frxEtiqueta.DataSets.Add(frxDataset);
end;

// ==========================================================
// Vincula recursivamente todos os objetos ao dataset correto
// ==========================================================
procedure TEtiquetaPrinterFast.VincularTodosAoDataset(const Obj: TfrxComponent);
var
  i, j: Integer;
  SubRpt: TfrxSubreport;
  AlreadyAdded: Boolean;
begin
  // MasterData, DataBand
  if Obj is TfrxMasterData then
    TfrxMasterData(Obj).DataSet := frxDataset;

  if Obj is TfrxDataBand then
    TfrxDataBand(Obj).DataSet := frxDataset;

  // MemoView: sempre vincula
  if Obj is TfrxMemoView then
    TfrxMemoView(Obj).DataSet := frxDataset;

  // Subreport
  if Obj is TfrxSubreport then
  begin
    SubRpt := TfrxSubreport(Obj);
    if Assigned(SubRpt.Report) then
    begin
      // Verifica se o dataset já foi adicionado
      AlreadyAdded := False;
      for j := 0 to SubRpt.Report.DataSets.Count - 1 do
      begin
        if SubRpt.Report.DataSets[j].DataSet = frxDataset then
        begin
          AlreadyAdded := True;
          Break;
        end;
      end;

      if not AlreadyAdded then
        SubRpt.Report.DataSets.Add(frxDataset);

      // Vincula recursivamente objetos dentro do subreport
      VincularTodosAoDataset(SubRpt.Report);
    end;
  end;

  // Processa objetos filhos recursivamente
  for i := 0 to Obj.Objects.Count - 1 do
    VincularTodosAoDataset(Obj.Objects[i]);
end;

// ==========================================================
// Editar layout
// ==========================================================
procedure TEtiquetaPrinterFast.EditarLayout(layout: TEtiquetaLayoutModel);
var
  i: Integer;
begin
  frxEtiqueta.LoadFromFile('\System_RK\Server\Etiquetas\' + layout.arquivo);

  // Limpa datasets antigos
  for i := frxEtiqueta.DataSets.Count - 1 downto 0 do
    frxEtiqueta.DataSets.Delete(i);

  // Adiciona dataset em memória
  frxEtiqueta.DataSets.Add(frxDataset);

  // Vincula todos objetos do relatório ao dataset correto
  VincularTodosAoDataset(frxEtiqueta);

  frxEtiqueta.DesignReport;
end;

// ==========================================================
// Imprimir layout
// ==========================================================
procedure TEtiquetaPrinterFast.Imprimir(produto: TProdutoModel; layout: TEtiquetaLayoutModel);
var
  i: Integer;
begin
  frxEtiqueta.LoadFromFile('\System_RK\Server\Etiquetas\' + layout.arquivo);

  // Limpa datasets antigos
  for i := frxEtiqueta.DataSets.Count - 1 downto 0 do
    frxEtiqueta.DataSets.Delete(i);

  // Adiciona dataset em memória
  frxEtiqueta.DataSets.Add(frxDataset);

  // Vincula todos objetos do relatório ao dataset correto
  VincularTodosAoDataset(frxEtiqueta);

  // Popula os dados
  memProduto.DisableControls;
  memProduto.EmptyDataSet;
  memProduto.Append;
  memProduto.FieldByName('CODIGO_BARRAS').AsString := produto.codigobarras;
  memProduto.FieldByName('PRODUTO').AsString := produto.descricao;
  memProduto.FieldByName('UNIDADE').AsString := produto.Unidade;
  memProduto.FieldByName('OBSERVACAO').AsString := produto.Observacao;
  memProduto.FieldByName('PRECO').AsFloat := produto.preco;
  memProduto.FieldByName('PRECO2').AsFloat := produto.preco;
  memProduto.FieldByName('PRECO2_QTD').AsFloat := produto.preco;
  memProduto.Post;
  memProduto.EnableControls;

  frxEtiqueta.PrintOptions.Printer := FConfiguracaoRepositoryFirebird.Obter.porta_impressora;
  frxEtiqueta.PrintOptions.ShowDialog := True;
  frxEtiqueta.PrepareReport;
  frxEtiqueta.ShowReport;
end;

procedure TEtiquetaPrinterFast.ImprimirFila(
  ListaProdutos: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
  layout: TEtiquetaLayoutModel);
var
  i: Integer;
  produto:TProdutoModel;
begin
  if ListaProdutos = nil then raise Exception.Create('Fila De Impressão Vazia !');

  frxEtiqueta.LoadFromFile('\System_RK\Server\Etiquetas\' + layout.arquivo);

  // Limpa datasets antigos
  for i := frxEtiqueta.DataSets.Count - 1 downto 0 do
    frxEtiqueta.DataSets.Delete(i);

  // Adiciona dataset em memória
  frxEtiqueta.DataSets.Add(frxDataset);

  // Vincula todos objetos do relatório ao dataset correto
  VincularTodosAoDataset(frxEtiqueta);

  // Popula os dados
  memProduto.DisableControls;
  memProduto.EmptyDataSet;

  for produto in ListaProdutos do
    begin
      memProduto.Append;
      memProduto.FieldByName('CODIGO_BARRAS').AsString := produto.codigoBarras;
      memProduto.FieldByName('PRODUTO').AsString := produto.descricao;
      memProduto.FieldByName('UNIDADE').AsString := produto.Unidade;
      memProduto.FieldByName('OBSERVACAO').AsString := produto.Observacao;
      memProduto.FieldByName('PRECO').AsFloat := produto.preco;
      memProduto.FieldByName('PRECO2').AsFloat := produto.preco;
      memProduto.FieldByName('PRECO2_QTD').AsFloat := produto.preco;
      memProduto.Post;
      memProduto.EnableControls;
    end;

  frxEtiqueta.PrintOptions.Printer := FConfiguracaoRepositoryFirebird.Obter.porta_impressora;
  frxEtiqueta.PrintOptions.ShowDialog := True;
  frxEtiqueta.PrepareReport;
  frxEtiqueta.ShowReport;

end;

procedure TEtiquetaPrinterFast.Preview(produto: TProdutoModel;
  layout: TEtiquetaLayoutModel; ParentPanel: TPanel);
var
  Preview: TfrxPreview;
  tmpReport: TfrxReport;
begin
  if ParentPanel = nil then
    raise Exception.Create('É necessário informar um TPanel para o preview');

  // Cria componente de preview dentro do painel
  Preview := TfrxPreview.Create(ParentPanel);
  Preview.Parent := ParentPanel;
  Preview.Align := alClient;
  Preview.BorderStyle := bsSingle;
  Preview.ZoomMode := zmPageWidth;

  // Cria relatório temporário e associa o preview como owner
  tmpReport := TfrxReport.Create(Preview);
  try
    tmpReport.LoadFromFile('\System_RK\Server\Etiquetas\' + layout.arquivo);

    // Limpa datasets antigos
    tmpReport.DataSets.Clear;

    // Adiciona dataset em memória
    tmpReport.DataSets.Add(frxDataset);

    // Vincula todos os objetos ao dataset
    VincularTodosAoDataset(tmpReport);

    // Popula os dados
    memProduto.DisableControls;
    memProduto.EmptyDataSet;
    memProduto.Append;
    memProduto.FieldByName('CODIGO_BARRAS').AsString := produto.CodigoBarras;
    memProduto.FieldByName('PRODUTO').AsString := produto.descricao;
    memProduto.FieldByName('UNIDADE').AsString := produto.Unidade;
    memProduto.FieldByName('OBSERVACAO').AsString := produto.Observacao;
    memProduto.FieldByName('PRECO').AsFloat := produto.preco;
    memProduto.FieldByName('PRECO2').AsFloat := produto.preco;
    memProduto.FieldByName('PRECO2_QTD').AsFloat := produto.preco;
    memProduto.Post;
    memProduto.EnableControls;

    // Associa o relatório ao preview
    tmpReport.Preview := Preview;

    // Prepara e mostra
    tmpReport.PrepareReport;
    Preview.Show;

    // tmpReport não precisa ser liberado explicitamente; será liberado quando Preview for destruído

  except
    tmpReport.Free;
    raise;
  end;
end;

end.

