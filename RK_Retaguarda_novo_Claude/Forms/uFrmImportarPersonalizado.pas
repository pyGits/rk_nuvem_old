unit uFrmImportarPersonalizado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  NxScrollControl, NxCustomGridControl, NxCustomGrid, NxGrid, Data.DB, DBAccess,
  Uni, MemDS, UniProvider, InterBaseUniProvider, Vcl.Grids,Classe.Importar,XLSToGrid,
  JvgStringGrid,Importar;

type
  TfrmImportarPersonalizado = class(TForm)
    gridPlanilha: TStringGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    abrirPlanilha: TOpenDialog;
    cbTabela: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    cbColuna: TComboBox;
    Label3: TLabel;
    procedure gridPlanilhaSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure gridPlanilhaDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Button1Click(Sender: TObject);
    procedure cbTabelaChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure carregarColunas;
  public
    { Public declarations }
  end;

var
  frmImportarPersonalizado: TfrmImportarPersonalizado;
  importar : TImportar;

implementation

{$R *.dfm}



procedure TfrmImportarPersonalizado.Button1Click(Sender: TObject);
begin
  if abrirPlanilha.Execute then
    TXlsToGrid.XlsToStringGrid(gridPlanilha, abrirPlanilha.FileName);
end;


procedure TfrmImportarPersonalizado.carregarColunas;
var
  tabela:string;
begin
cbColuna.Items.Clear;
tabela := cbTabela.Text;
if tabela = 'CLIENTE' then
begin
cbColuna.Items.Add('Código');
cbColuna.Items.Add('CNPJCPF');
cbColuna.Items.Add('TIPO_PESSOA');
cbColuna.Items.Add('NOME');
cbColuna.Items.Add('APELIDO');
cbColuna.Items.Add('CEP');
cbColuna.Items.Add('ENDERECO');
cbColuna.Items.Add('NUMERO');
end;

end;

procedure TfrmImportarPersonalizado.cbTabelaChange(Sender: TObject);
begin
CarregarColunas;
end;

procedure TfrmImportarPersonalizado.FormCreate(Sender: TObject);
begin
importar := TImportar.create;
end;

procedure TfrmImportarPersonalizado.gridPlanilhaDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if aCol = gridPlanilha.Col then
  begin
    gridPlanilha.Canvas.Brush.Color := clYellow; // Cor de fundo
    gridPlanilha.Canvas.FillRect(Rect);
    gridPlanilha.Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2, gridPlanilha.Cells[aCol, aRow]);
  end;
end;

procedure TfrmImportarPersonalizado.gridPlanilhaSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  i: Integer;
  linha :TLinha;
begin
  gridPlanilha.Invalidate;
  linha := TLinha.Create;
  linha.coluna := cbColuna.Text;
  linha.tabela := cbTabela.Text;
  linha.indice_grid := aCol;
  importar.adicionar(linha);
end;

end.
