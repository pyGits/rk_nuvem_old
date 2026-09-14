unit CadastroCaixas;

// Cadastro dos caixas que recebem a carga. A lista fica no config.ini
// (CaixaIniRepository); aqui so entra a tela.

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls,
  System.Generics.Collections, CaixaModel;

type
  TfrmCadastroCaixas = class(TForm)
    lblAjuda: TLabel;
    gridCaixas: TStringGrid;
    btnAdicionar: TButton;
    btnRemover: TButton;
    btnSalvar: TButton;
    btnFechar: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure gridCaixasSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    procedure carregar;
    procedure renumerar;
    function ipRepetido(const ip: string; linha: integer): Boolean;
  public
  end;

var
  frmCadastroCaixas: TfrmCadastroCaixas;

implementation

{$R *.dfm}

uses Global, CaixaIniRepository;

const
  COL_NUMERO = 0;
  COL_NOME = 1;
  COL_IP = 2;

  // Linha 0 e o cabecalho, entao o caixa 1 e a linha 1.
  LINHA_CAIXA_LOCAL = 1;

procedure TfrmCadastroCaixas.FormShow(Sender: TObject);
begin
  gridCaixas.ColWidths[COL_NUMERO] := 60;
  gridCaixas.ColWidths[COL_NOME] := 230;
  gridCaixas.ColWidths[COL_IP] := 190;

  gridCaixas.Cells[COL_NUMERO, 0] := 'Caixa';
  gridCaixas.Cells[COL_NOME, 0] := 'Nome';
  gridCaixas.Cells[COL_IP, 0] := 'IP';

  carregar;
end;

procedure TfrmCadastroCaixas.carregar;
var
  caixas: TObjectList<TCaixaModel>;
  i: integer;
begin
  caixas := Global.Caixas.getAll;
  try
    gridCaixas.RowCount := caixas.Count + 1;

    for i := 0 to caixas.Count - 1 do
    begin
      gridCaixas.Cells[COL_NUMERO, i + 1] := caixas[i].codigo;
      gridCaixas.Cells[COL_NOME, i + 1] := caixas[i].nome;
      gridCaixas.Cells[COL_IP, i + 1] := caixas[i].ip;
    end;
  finally
    caixas.Free;
  end;
end;

procedure TfrmCadastroCaixas.renumerar;
var
  i: integer;
begin
  for i := 1 to gridCaixas.RowCount - 1 do
    gridCaixas.Cells[COL_NUMERO, i] := IntToStr(i);
end;

function TfrmCadastroCaixas.ipRepetido(const ip: string; linha: integer): Boolean;
var
  i: integer;
begin
  Result := false;

  for i := 1 to gridCaixas.RowCount - 1 do
  begin
    if i = linha then Continue;
    if SameText(Trim(gridCaixas.Cells[COL_IP, i]), ip) then
    begin
      Result := true;
      Exit;
    end;
  end;
end;

// O IP do caixa 1 e fixo: e o PDV desta maquina, que toda instalacao tem. O
// nome dele continua editavel.
procedure TfrmCadastroCaixas.gridCaixasSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if (ARow = LINHA_CAIXA_LOCAL) and (ACol = COL_IP) then
    gridCaixas.Options := gridCaixas.Options - [goEditing]
  else
    gridCaixas.Options := gridCaixas.Options + [goEditing];
end;

procedure TfrmCadastroCaixas.btnAdicionarClick(Sender: TObject);
var
  linha: integer;
begin
  gridCaixas.RowCount := gridCaixas.RowCount + 1;
  linha := gridCaixas.RowCount - 1;

  gridCaixas.Cells[COL_NUMERO, linha] := IntToStr(linha);
  gridCaixas.Cells[COL_NOME, linha] := Format('Caixa %d', [linha]);
  gridCaixas.Cells[COL_IP, linha] := '';

  gridCaixas.Row := linha;
  gridCaixas.Col := COL_IP;
  gridCaixas.SetFocus;
end;

procedure TfrmCadastroCaixas.btnRemoverClick(Sender: TObject);
var
  i: integer;
begin
  if gridCaixas.Row = LINHA_CAIXA_LOCAL then
  begin
    ShowMessage('O caixa 1 e o PDV desta maquina: ele sempre existe e nao pode ser removido.');
    Exit;
  end;

  if gridCaixas.RowCount <= 2 then Exit;

  // TStringGrid nao remove linha: as de baixo sobem e o grid encolhe.
  for i := gridCaixas.Row to gridCaixas.RowCount - 2 do
    gridCaixas.Rows[i].Assign(gridCaixas.Rows[i + 1]);

  gridCaixas.RowCount := gridCaixas.RowCount - 1;
  renumerar;
end;

procedure TfrmCadastroCaixas.btnSalvarClick(Sender: TObject);
var
  caixas: TObjectList<TCaixaModel>;
  i: integer;
  ip: string;
begin
  caixas := TObjectList<TCaixaModel>.Create(true);
  try
    for i := 1 to gridCaixas.RowCount - 1 do
    begin
      ip := Trim(gridCaixas.Cells[COL_IP, i]);

      if ip = '' then
      begin
        ShowMessage(Format('Informe o IP do caixa %d.', [i]));
        gridCaixas.Row := i;
        gridCaixas.Col := COL_IP;
        Exit;
      end;

      // Dois caixas no mesmo IP fariam a carga rodar duas vezes no mesmo PDV.
      if ipRepetido(ip, i) then
      begin
        ShowMessage(Format('O IP %s esta cadastrado em mais de um caixa.', [ip]));
        gridCaixas.Row := i;
        gridCaixas.Col := COL_IP;
        Exit;
      end;

      caixas.Add(TCaixaModel.Create);
      caixas.Last.codigo := IntToStr(i);
      caixas.Last.nome := Trim(gridCaixas.Cells[COL_NOME, i]);
      caixas.Last.ip := ip;
    end;

    Global.Caixas.salvar(caixas);
  finally
    caixas.Free;
  end;

  carregar;
  ShowMessage('Caixas salvos. A proxima carga ja usa esta lista.');
end;

procedure TfrmCadastroCaixas.btnFecharClick(Sender: TObject);
begin
  Close;
end;

end.
