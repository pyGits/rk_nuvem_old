unit uFrmContasReceber;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  AdvToolBar, AdvGlowButton, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, RzEdit,
  RzBtnEdt,Classe.Variaveis, Vcl.ComCtrls, Vcl.DBCtrls,Math,uFrmContasReceber_pgto,Conversao,Classe.Cliente,
  System.ImageList, Vcl.ImgList, JvExMask, JvToolEdit, JvBaseEdits,uFrmLocCliente,GLobal;

type
  TfrmContasReceber = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    Label1: TLabel;
    edtClienteCod: TRzButtonEdit;
    edtClienteDesc: TEdit;
    Label23: TLabel;
    cbSituacao: TComboBox;
    Panel2: TPanel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    Bevel19: TBevel;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton3: TAdvGlowButton;
    bliquidar: TAdvGlowButton;
    breceber: TAdvGlowButton;
    bexcluir: TAdvGlowButton;
    bextornar: TAdvGlowButton;
    brelatorios: TAdvGlowButton;
    brenegociar: TAdvGlowButton;
    bfuncoes: TAdvGlowButton;
    ds: TDataSource;
    pgContas: TPageControl;
    tsContas: TTabSheet;
    tsProdutos: TTabSheet;
    tsPagamentos: TTabSheet;
    grid: TDBGrid;
    gridProduto: TDBGrid;
    dsProduto: TDataSource;
    gridPagamento: TDBGrid;
    ImageList1: TImageList;
    Panel1: TPanel;
    FlatPanel2: TPanel;
    btnImprimir: TAdvGlowButton;
    dsPagamento: TDataSource;
    Panel3: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Bevel1: TBevel;
    edtVlrDesconto: TJvCalcEdit;
    edtVlrAPagar: TJvCalcEdit;
    edtVlrPago: TJvCalcEdit;
    edtVlr: TJvCalcEdit;
    lblCliente: TLabel;
    lblCPFCNPJ: TLabel;
    lblEndereco: TLabel;
    lblTelefone1: TLabel;
    lblTelefone2: TLabel;
    lblCelular: TLabel;
    lblLimite: TLabel;
    lblLimiteUtilizado: TLabel;
    procedure gridCellClick(Column: TColumn);
    procedure gridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
    procedure breceberClick(Sender: TObject);
    procedure cbSituacaoChange(Sender: TObject);
    procedure edtClienteCodKeyPress(Sender: TObject; var Key: Char);
    procedure edtClienteCodExit(Sender: TObject);
    procedure bliquidarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtClienteCodButtonClick(Sender: TObject);
    procedure bextornarClick(Sender: TObject);
    procedure bexcluirClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
  private
    procedure AtualizarGrid;
//    procedure AtualizarGridValores;
    procedure PreencherGridCliente(oCliente:TCliente);
  public
    { Public declarations }
  end;

var
  frmContasReceber: TfrmContasReceber;
  status:TContasReceberStatus;

implementation

{$R *.dfm}

procedure TfrmContasReceber.AtualizarGrid;
var
  oCliente: TCliente;
  Vlr, VlrPago, VlrAPagar, VlrDesconto: Extended;
begin
  oCliente := TCliente.Create;
  try
    oCliente.codigo := edtClienteCod.Text;

    if VariaveisSrv.oClienteController.CarregarCliente(oCliente) then
      PreencherGridCliente(oCliente);
  finally
    oCliente.Free;
  end;

  // Preenche o grid
  VariaveisSrv.oContasReceberController.PreencherGrid(
    ds,
    status,
    edtClienteCod.Text,
    Vlr,
    VlrPago,
    VlrAPagar,
    VlrDesconto
  );




  // Atualiza a tela
  edtVlr.Value         := Vlr;
  edtVlrPago.Value     := VlrPago;
  edtVlrAPagar.Value   := VlrAPagar;
  edtVlrDesconto.Value := VlrDesconto;
end;

//procedure TfrmContasReceber.AtualizarGridValores;
//var
//  i:integer;
//begin
//  i:=1;
//  ds.DataSet.First;
//  edtVlr.value := 0;
//  edtVlrPago.Value := 0;
//  edtVlrAPagar.VALUE := 0;
//  edtVlrDesconto.VALUE := 0;
//  while not ds.DataSet.Eof do
//  begin
//    edtVlr.value := edtVlr.value + ds.DataSet.FieldByName('VALOR').AsFloat;
//    edtVlrPago.Value := edtVlrPago.Value + ds.DataSet.FieldByName('VALOR_PAGO').AsFloat;
//    edtVlrAPagar.VALUE := edtVlrAPagar.VALUE + ds.DataSet.FieldByName('VALOR_RESTANTE').AsFloat;
//    edtVlrDesconto.VALUE := edtVlrDesconto.VALUE + ds.DataSet.FieldByName('VALOR_DESCONTO').AsFloat;
//
//    ds.DataSet.Next;
//    Application.ProcessMessages;
//  end;
//end;

procedure TfrmContasReceber.bexcluirClick(Sender: TObject);
begin
if MessageDlg('Tem certeza que deseja excluir todas as contas selecionadas ?',mtWarning,[mbYes,mbNo],0)= mrYes then
begin
VariaveisSrv.oContasReceberController.ExcluirContas;
AtualizarGrid;
end;

end;

procedure TfrmContasReceber.bextornarClick(Sender: TObject);
begin
if MessageDlg('Tem certeza que deseja estornar o valor de todas as contas selecionadas ?',mtWarning,[mbYes,mbNo],0)= mrYes then
begin
VariaveisSrv.oContasReceberController.EstornarContas;
AtualizarGrid;
end;
end;

procedure TfrmContasReceber.bliquidarClick(Sender: TObject);
var
  i:integer;
begin
  i:=1;
  // marcar todas contas
  ds.DataSet.First;
  while not ds.DataSet.Eof do
  begin
    if (grid.Fields[0].AsString = '0') or(grid.Fields[0].AsString = '')  then
    begin
      gridDblClick(grid);
    end;

    ds.DataSet.Next;
  end;

TfrmContasReceberPgto.Exibe(VariaveisSrv.oContasReceberController.CarregarValorTotalAReceber);

AtualizarGrid;
end;

procedure TfrmContasReceber.breceberClick(Sender: TObject);
begin
  // marcar conta selecionada
  if grid.Fields[0].AsString = '0' then
  begin
    gridDblClick(grid);
  end;


TfrmContasReceberPgto.Exibe(VariaveisSrv.oContasReceberController.CarregarValorTotalAReceber);

AtualizarGrid;
end;

procedure TfrmContasReceber.btnImprimirClick(Sender: TObject);
begin
ContaReceberUseCase.ImprimirContaReceber(ds.DataSet.FieldByName('CODIGO').AsString);
end;

procedure TfrmContasReceber.cbSituacaoChange(Sender: TObject);
begin
case cbSituacao.ItemIndex of
0 :begin
status := crAbertas;
end;
1 :begin
status := crVencer;
end;
2 :begin
status := crRecebido;
end;
3 :begin
status := crTodas;
end;
end;

atualizargrid;
end;

procedure TfrmContasReceber.edtClienteCodButtonClick(Sender: TObject);
begin
edtClienteCod.text := TfrmLocCliente.Exibe;
end;

procedure TfrmContasReceber.edtClienteCodExit(Sender: TObject);
var
  oCliente:TCliente;
begin
  if edtClienteCod.text <> '' then
  begin
  oCliente := TCliente.create;
  oCliente.codigo := edtClienteCod.text;

  if VariaveisSrv.oClienteController.CarregarCliente(oCliente) then
  begin

    grid.SetFocus;
    edtClienteCod.text := oCliente.codigo;
    edtClienteDesc.text := oCliente.Pessoa.Nome;

  end
  else
  begin
    edtClienteCod.Button.Click;
    oCliente.codigo := edtClienteCod.text;
    VariaveisSrv.oClienteController.CarregarCliente(oCliente);
    edtClienteCod.text := oCliente.codigo;
    edtClienteDesc.text := oCliente.Pessoa.Nome;
    edtClienteCod.SetFocus;
  end;
    PreencherGridCliente(oCliente);
    oCliente.destroy;
  end;


    atualizargrid;



end;

procedure TfrmContasReceber.edtClienteCodKeyPress(Sender: TObject;
  var Key: Char);
begin
if key = #13 then
begin
  pgContas.ActivePageIndex := 0;
  grid.SetFocus;
end;
end;

procedure TfrmContasReceber.FormCreate(Sender: TObject);
begin
atualizargrid;
end;

procedure TfrmContasReceber.FormShow(Sender: TObject);
begin
pgContas.ActivePageIndex := 0;

end;

procedure TfrmContasReceber.gridCellClick(Column: TColumn);
begin
if ds.DataSet.RecNo > 0 then
begin
tsPagamentos.TabVisible := true;
tsProdutos.TabVisible := true;
VariaveisSrv.oContasReceberController.preencherGridProduto(dsProduto,ds.DataSet.FieldByName('COD_CUPOM').AsString);
VariaveisSrv.oContasReceberController.preencherGridPagamento(dspagamento,ds.DataSet.FieldByName('COD_CUPOM').AsString);
end;
end;

procedure TfrmContasReceber.gridDblClick(Sender: TObject);
begin
  if ((Sender as TDBGrid).DataSource.Dataset.IsEmpty) then
    Exit;

  (Sender as TDBGrid).DataSource.Dataset.Edit;

  (Sender as TDBGrid).DataSource.Dataset.FieldByName('SELECAO').AsInteger :=
    IfThen((Sender as TDBGrid).DataSource.Dataset.FieldByName('SELECAO').AsInteger = 1, 0, 1);

  (Sender as TDBGrid).DataSource.Dataset.Post;
end;

procedure TfrmContasReceber.gridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Check: Integer;
  R: TRect;
begin
  inherited;

  if ((Sender as TDBGrid).DataSource.Dataset.IsEmpty) then
    Exit;

  // Desenha um checkbox no dbgrid
  if Column.FieldName = 'SELECAO' then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    if ((Sender as TDBGrid).DataSource.Dataset.FieldByName('SELECAO').AsInteger = 1) then
    begin
      Check := DFCS_CHECKED;
    end
    else
    begin
      Check := 0;
    end;


    R := Rect;
    InflateRect(R, -2, -2); { Diminue o tamanho do CheckBox }
    DrawFrameControl(TDBGrid(Sender).Canvas.Handle, R, DFC_BUTTON,
      DFCS_BUTTONCHECK or Check);

//    Grid.Canvas.FillRect(Rect);
//    grid.DefaultDrawDataCell(Rect, grid.columns[datacol].field, State);

  end;

  if Column.FieldName = 'STATUS' then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    if ((Sender as TDBGrid).DataSource.Dataset.FieldByName('STATUS').AsInteger = 0) then
    begin
      // abertas
    ImageList1.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 1);
    end;
    if ((Sender as TDBGrid).DataSource.Dataset.FieldByName('STATUS').AsInteger = 1) then
    begin
      // recebidas
    ImageList1.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 2);
    end;

  end;

end;

procedure TfrmContasReceber.PreencherGridCliente(oCliente: TCliente);
begin
with oCliente do
begin
lblCliente.Caption := Pessoa.Nome;
lblCPFCNPJ.caption := pessoa.CPFCNPJ;
lblEndereco.Caption := Endereco.Endereco;
lblTelefone1.Caption := Pessoa.Telefone1;
lblTelefone2.Caption := pessoa.Telefone2;
lblCelular.Caption := Pessoa.Celular1;
lblLimite.Caption := 'Limite: ' + FormatFloat('###,###,##0.00',LimiteCredito);
lblLimiteUtilizado.Caption := 'Limite Utilizado: ' +FormatFloat('###,###,##0.00',UtilizadoCredito);

end;
end;

end.
