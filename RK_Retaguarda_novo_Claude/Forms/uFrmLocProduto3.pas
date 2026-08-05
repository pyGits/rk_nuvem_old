unit uFrmLocProduto3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids,
  Vcl.StdCtrls, Vcl.ExtCtrls, global, ProdutoModel,GrupoModel,
  System.Generics.Collections, ListarProdutosUseCase;

type
  TFrmLocProduto3 = class(TForm)
    pnlTop: TPanel;
    edtBusca: TEdit;
    cbTipoBusca: TComboBox;
    btnBuscar: TButton;
    pnlGrid: TPanel;
    gridProdutos: TStringGrid;
    pnlBottom: TPanel;
    btnConfirmar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cbGrupo: TComboBox;
    btnSelecionarTodos: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure gridProdutosDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure gridProdutosDblClick(Sender: TObject);
    procedure gridProdutosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnLimparSelecaoClick(Sender: TObject);
    procedure edtBuscaKeyPress(Sender: TObject; var Key: Char);
    procedure edtBuscaEnter(Sender: TObject);
    procedure gridProdutosKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnSelecionarTodosClick(Sender: TObject);

  private
    FConfirmado: Boolean;
    FSelecionados: TDictionary<string, Boolean>;

    procedure SelecionarLinha(linha: Integer);

    procedure CarregarGrupos;
  public
    class function Exibe: TDictionary<string, Boolean>;
  end;

var
  frmlocproduto3: TFrmLocProduto3;

implementation

{$R *.dfm}

{ EXIBE }

class function TFrmLocProduto3.Exibe: TDictionary<string, Boolean>;
var
  frm: TFrmLocProduto3;
begin
  frm := TFrmLocProduto3.Create(Application);
  try
    frm.ShowModal;
    result := frm.FSelecionados;
  finally
    frm.Free;
  end;
end;

{ CREATE / DESTROY }

procedure TFrmLocProduto3.FormCreate(Sender: TObject);
begin
  FSelecionados := TDictionary<string, Boolean>.Create;

  Color := clWhite;
  pnlTop.Color := $00F0F0F0;
  pnlBottom.Color := $00F0F0F0;

  cbTipoBusca.Items.Clear;
  cbTipoBusca.Items.Add('Nome');
  cbTipoBusca.Items.Add('Código');
  cbTipoBusca.Items.Add('Categoria');
  cbTipoBusca.ItemIndex := 0;

  gridProdutos.ColCount := 4;
  gridProdutos.RowCount := 2;
  gridProdutos.DefaultRowHeight := 28;
  gridProdutos.FixedColor := $00E8E8E8;

  gridProdutos.Options := [goHorzLine, goVertLine, goRowSelect];

  gridProdutos.OnDrawCell := gridProdutosDrawCell;
  gridProdutos.OnDblClick := gridProdutosDblClick;

  gridProdutos.Cells[0,0] := ' ';
  gridProdutos.Cells[1,0] := 'Código Barras';
  gridProdutos.Cells[2,0] := 'Nome do Produto';
  gridProdutos.Cells[3,0] := 'Preço Venda';

  gridProdutos.ColWidths[0] := 40;
  gridProdutos.ColWidths[1] := 150;
  gridProdutos.ColWidths[2] := 350;
  gridProdutos.ColWidths[3] := 120;

  btnConfirmar.Caption := '✔ Confirmar Seleção (F9)';
  btnConfirmar.Font.Style := [fsBold];
end;

procedure TFrmLocProduto3.FormDestroy(Sender: TObject);
begin
  FSelecionados.Free;
end;

procedure TFrmLocProduto3.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = vk_f9 then btnConfirmar.Click;
end;

procedure TFrmLocProduto3.FormShow(Sender: TObject);
begin
CarregarGrupos;
end;

{ BUSCAR }

procedure TFrmLocProduto3.btnBuscarClick(Sender: TObject);
var
  i: Integer;
  produtos: TObjectList<TProdutoModel>;
  produto: TProdutoModel;
  filtro: TProdutoFiltro;
  grupo:TGrupoModel;
begin
  case cbTipoBusca.ItemIndex of
    0:
      begin
        filtro.Tipo := tfNome;
        filtro.Valor := edtBusca.Text;
      end;

    1:
      begin
        filtro.Tipo := tfCodigoBarras;
        filtro.Valor := edtBusca.Text;
      end;
  else
    filtro.Tipo := tfTodos;
  end;




  if Trim(edtBusca.Text) = '' then
    filtro.Tipo := tfTodos;

  if (cbGrupo.ItemIndex >= 0) then
  begin
    grupo := TGrupoModel(cbGrupo.Items.Objects[cbGrupo.ItemIndex]);

    if (grupo <> nil) and (grupo.codigo <> '000000') then
    begin
      filtro.Tipo := tfCategoria;
      filtro.Valor := grupo.codigo;
    end;
  end;

  produtos := GListarProdutosUseCase.Execute(filtro);

  if produtos.Count = 0 then
  begin
  edtBusca.SetFocus;
  raise Exception.Create('Nenhum Produto Encontrado !');
  end;

  gridProdutos.RowCount := produtos.Count + 1;

  i := 1;

  for produto in produtos do
  begin
    gridProdutos.Cells[1,i] := produto.CodigoBarras;
    gridProdutos.Cells[2,i] := produto.getDescricao;
    gridProdutos.Cells[3,i] := FormatFloat('R$ 0.00', produto.Preco);

    if FSelecionados.ContainsKey(produto.CodigoBarras) then
      gridProdutos.Cells[0,i] := '✔'
    else
      gridProdutos.Cells[0,i] := '';

    Inc(i);
  end;

  gridProdutos.Invalidate;

  gridProdutos.Row := 1;
  gridProdutos.SetFocus;
end;

{ SELEÇÃO }

procedure TFrmLocProduto3.SelecionarLinha(linha: Integer);
var
  codigo: string;
begin
  if linha = 0 then Exit;

  codigo := Trim(gridProdutos.Cells[1, linha]);
  if codigo = '' then Exit;

  if FSelecionados.ContainsKey(codigo) then
  begin
    FSelecionados.Remove(codigo);
    gridProdutos.Cells[0, linha] := '';
  end
  else
  begin
    FSelecionados.Add(codigo, True);
    gridProdutos.Cells[0, linha] := '✔';
  end;

  gridProdutos.Invalidate;
end;

{ EVENTOS }

procedure TFrmLocProduto3.gridProdutosDblClick(Sender: TObject);
begin
  SelecionarLinha(gridProdutos.Row);
end;

procedure TFrmLocProduto3.gridProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_SPACE then
    SelecionarLinha(gridProdutos.Row);
end;

procedure TFrmLocProduto3.gridProdutosKeyPress(Sender: TObject; var Key: Char);
begin
if key = #27 then edtBusca.SetFocus;
end;

procedure TFrmLocProduto3.gridProdutosDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if ARow = 0 then
    gridProdutos.Canvas.Brush.Color := $00E8E8E8
  else if gdSelected in State then
    gridProdutos.Canvas.Brush.Color := $00FFD8A8
  else if Odd(ARow) then
    gridProdutos.Canvas.Brush.Color := $00F7F7F7
  else
    gridProdutos.Canvas.Brush.Color := clWhite;

  gridProdutos.Canvas.FillRect(Rect);

  gridProdutos.Canvas.TextOut(Rect.Left + 5, Rect.Top + 6,
    gridProdutos.Cells[ACol, ARow]);
end;

{ CONFIRMAR }

procedure TFrmLocProduto3.btnConfirmarClick(Sender: TObject);
begin
  if FSelecionados.Count = 0 then
  begin
    ShowMessage('Selecione pelo menos um produto!');
    Exit;
  end;

  // 🔥 valida quantidade
  if FSelecionados.Count > 100 then
  begin
    if MessageDlg(
      Format('Você selecionou %d produtos. Deseja continuar?', [FSelecionados.Count]),
      mtConfirmation,
      [mbYes, mbNo],
      0
    ) = mrNo then
      Exit;
  end;

  ModalResult := mrOk;
end;

{ LIMPAR SELEÇÃO }

procedure TFrmLocProduto3.btnLimparSelecaoClick(Sender: TObject);
var
  i: Integer;
begin
  // 🔥 limpa estado interno
  FSelecionados.Clear;

  // 🔥 limpa visual do grid
  for i := 1 to gridProdutos.RowCount - 1 do
    gridProdutos.Cells[0, i] := '';

  gridProdutos.Invalidate;
end;

procedure TFrmLocProduto3.btnSelecionarTodosClick(Sender: TObject);
var
  i: Integer;
  codigo: string;
begin
  for i := 1 to gridProdutos.RowCount - 1 do
  begin
    codigo := Trim(gridProdutos.Cells[1, i]);

    if codigo = '' then
      Continue;

    // adiciona no dicionário se ainda não existir
    if not FSelecionados.ContainsKey(codigo) then
      FSelecionados.Add(codigo, True);

    // marca no grid
    gridProdutos.Cells[0, i] := '✔';
  end;

  gridProdutos.Invalidate;
end;

procedure TFrmLocProduto3.CarregarGrupos;
var
  grupos:TObjectList<TGrupoModel>;
  grupo:TGrupoModel;
begin
cbGrupo.Items.Clear;
grupos := GListaGruposUseCase.execute;
for grupo in grupos do
  begin
    cbGrupo.Items.AddObject(grupo.descricao, grupo);
  end;
end;

procedure TFrmLocProduto3.edtBuscaEnter(Sender: TObject);
begin
edtBusca.SelectAll;
end;

procedure TFrmLocProduto3.edtBuscaKeyPress(Sender: TObject; var Key: Char);
begin
if key = #13 then btnBuscar.SetFocus;
if key = #27 then close;

end;

end.
