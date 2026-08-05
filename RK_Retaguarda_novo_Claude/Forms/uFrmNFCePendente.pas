unit uFrmNFCePendente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, dxGDIPlusClasses,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls,System.Generics.Collections,NFCePendente,NFCeController,
  NxColumns, NxColumnClasses, NxScrollControl, NxCustomGridControl,UIRegerarNFCe,
  NxCustomGrid, NxGrid,uFrmEnviaNFCe,Global;

type
  TfrmNFCePendente = class(TForm)
    Panel6: TPanel;
    Label4: TLabel;
    btnEmitir: TAdvGlowButton;
    GroupBox1: TGroupBox;
    edtDtEmissaoInicio: TDateTimePicker;
    edtDtEmissaoFim: TDateTimePicker;
    Label1: TLabel;
    btnLocalizar: TAdvGlowButton;
    grid: TNextGrid;
    NxTextColumn1: TNxTextColumn;
    NxTextColumn2: TNxTextColumn;
    NxTextColumn3: TNxTextColumn;
    NxTextColumn4: TNxTextColumn;
    NxTextColumn5: TNxTextColumn;
    NxCheckBoxColumn1: TNxCheckBoxColumn;
    NxTextColumn6: TNxTextColumn;
    NxTextColumn7: TNxTextColumn;
    AdvGlowButton1: TAdvGlowButton;
    GroupBox2: TGroupBox;
    cbStatus: TComboBox;
    AdvGlowButton2: TAdvGlowButton;
    procedure btnLocalizarClick(Sender: TObject);
    procedure gridCellDblClick(Sender: TObject; ACol, ARow: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnEmitirClick(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
  private
    NFCesPendentes:TObjectList<TNFCePendente>;
    procedure carregarInterface;
    procedure carregarNFCes;
    function ObterXmlsSelecionadas:TStringList;
  public
    class procedure abrir;
  end;

var
  frmNFCePendente: TfrmNFCePendente;

implementation
uses Utils;

{$R *.dfm}

{ TfrmNFCePendente }

class procedure TfrmNFCePendente.abrir;
begin
frmNFCePendente := TfrmNFCePendente.Create(nil);
frmNFCePendente.ShowModal;
frmNFCePendente.Free;
end;

procedure TfrmNFCePendente.AdvGlowButton1Click(Sender: TObject);
var
  i: Integer;
  Marcar: Boolean;
  ColCheck: Integer;
begin
  ColCheck := 0; // �ndice da coluna de checkbox (ajuste conforme necess�rio)

  if grid.RowCount > 0 then
    Marcar := not grid.Cell[ColCheck, 0].AsBoolean
  else
    Marcar := True;

  for i := 0 to grid.RowCount - 1 do
    grid.Cell[ColCheck, i].AsBoolean := Marcar;
end;

procedure TfrmNFCePendente.AdvGlowButton2Click(Sender: TObject);
var
  i: Integer;
  ListaNFCe: TObjectList<TNFCePendente>;
begin
try
  ListaNFCe := TObjectList<TNFCePendente>.Create;

  for i := 0 to grid.RowCount - 1 do
  begin
    if grid.Cell[0, i].AsBoolean then
    begin
      ListaNFCe.Add(TNFCePendente.Create);
      ListaNFCe.Last.data := grid.Cell[1, i].AsDateTime;
      ListaNFCe.Last.hora := grid.Cell[2, i].AsDateTime;
      ListaNFCe.Last.cod_caixa := grid.Cell[3, i].AsInteger;
      ListaNFCe.Last.chave := grid.Cell[4, i].AsString;
      ListaNFCe.Last.xml := grid.Cell[6, i].AsString;
      ListaNFCe.Last.RETORNO := grid.Cell[7, i].AsString;
    end;
  end;

  TfrmUIRegerarNFCe.Abrir(ListaNFCe);

finally
  carregarNFCes;
  carregarInterface;
  ListaNFCe.Free;
end;
end;

procedure TfrmNFCePendente.btnEmitirClick(Sender: TObject);
var
  i: Integer;
  ListaNFCe:TObjectList<TNFCePendente>;
begin
try
  ListaNFCe:=TObjectList<TNFCePendente>.create;

  for i := 0 to grid.RowCount - 1 do
  begin
    // Supondo que a coluna 0 seja TNxCheckBoxColumn
    if grid.Cell[0, i].AsBoolean then
    begin
      ListaNFCe.Add(TNFCePendente.create);
      ListaNFCe.Last.data := grid.Cell[1, i].AsDateTime;
      ListaNFCe.Last.hora := grid.Cell[2, i].AsDateTime;
      ListaNFCe.Last.cod_caixa := grid.Cell[3, i].AsInteger;
      ListaNFCe.Last.chave := grid.Cell[4, i].AsString;
      ListaNFCe.Last.xml := grid.Cell[6, i].AsString;
      ListaNFCe.Last.RETORNO := grid.Cell[7, i].AsString;
    end;
  end;

TfrmEnviaNFce.enviar(ListaNFCe);

finally
  carregarNFCes;
  carregarInterface;
  ListaNFCe.free;
end;
end;

procedure TfrmNFCePendente.btnLocalizarClick(Sender: TObject);
begin
carregarNFCes;
carregarInterface;
end;

procedure TfrmNFCePendente.carregarInterface;
var
  nfce:TNFCePendente;
begin
grid.ClearRows;

for nfce in NFCesPendentes do
  begin
    grid.AddRow(1);
    grid.Cells[1,grid.LastAddedRow] := DateToStr(nfce.data);
    grid.Cells[2,grid.LastAddedRow] := TimeToStr(nfce.hora);
    grid.Cells[3,grid.LastAddedRow] := IntToStr(nfce.cod_caixa);
    grid.Cells[4,grid.LastAddedRow] := nfce.chave;
    grid.Cells[5,grid.LastAddedRow] := TUtils.MascaraDinheiro(nfce.total);
    grid.Cells[6,grid.LastAddedRow] := nfce.xml;
    grid.Cells[7,grid.LastAddedRow] := nfce.retorno;
  end;

end;

procedure TfrmNFCePendente.carregarNFCes;
var
  status:string;
begin
if cbStatus.ItemIndex = 0  then status := 'PE';
if cbStatus.ItemIndex = 1  then status := 'OK';


NFCesPendentes := NFCe_Controller.getAllNFCePendente(edtDtEmissaoInicio.Date,edtDtEmissaoFim.Date,status);
end;

procedure TfrmNFCePendente.FormCreate(Sender: TObject);
begin
NFCesPendentes := TObjectList<TNFCePendente>.create;
end;

procedure TfrmNFCePendente.FormDestroy(Sender: TObject);
begin
NFCesPendentes.Free;
end;

procedure TfrmNFCePendente.FormShow(Sender: TObject);
begin
carregarInterface;
edtDtEmissaoInicio.Date := now();
edtDtEmissaoFim.Date := now();
end;

procedure TfrmNFCePendente.gridCellDblClick(Sender: TObject; ACol,
  ARow: Integer);
var
  CheckColIndex: Integer;
begin
  // �ndice da coluna de checkbox (ex: 0, se for a primeira)
  CheckColIndex := 0;
  Grid.Cell[CheckColIndex, ARow].AsBoolean := not Grid.Cell[CheckColIndex, ARow].AsBoolean;
end;

function TfrmNFCePendente.ObterXmlsSelecionadas: TStringList;
var
  i:integer;
begin
  result := TStringList.Create;
  for i := 0 to grid.RowCount - 1 do
  begin
    // Supondo que a coluna 0 seja TNxCheckBoxColumn
    if grid.Cell[0, i].AsBoolean then
    begin
      Result.Add(grid.Cell[4, i].AsString);
    end;
  end;
end;

end.
