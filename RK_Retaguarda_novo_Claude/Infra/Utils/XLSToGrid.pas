unit XLSToGrid;


interface
uses
vcl.grids,System.Win.comobj,System.SysUtils,System.Variants;
type TXlsToGrid = class
  public
    class function XlsToStringGrid(AGrid: TStringGrid; AXLSFile: string): Boolean;
end;

implementation

{ TXlsToGrid }

class function TXlsToGrid.XlsToStringGrid(AGrid: TStringGrid;
  AXLSFile: string): Boolean;
const
  xlCellTypeLastCell = $0000000B;
var
  XLApp, Sheet: OLEVariant;
  RangeMatrix: Variant;
  x, y, k, r: Integer;
begin
  Result := False;
  //Cria Excel- OLE Object
  XLApp := CreateOleObject('Excel.Application');
  try
    //Esconde Excel
    XLApp.Visible := False;
    //Abre o Workbook
    XLApp.Workbooks.Open(AXLSFile);
    Sheet := XLApp.Workbooks[ExtractFileName(AXLSFile)].WorkSheets[1];
    Sheet.Cells.SpecialCells(xlCellTypeLastCell, EmptyParam).Activate;
    //Pegar o número da última linha
    x := XLApp.ActiveCell.Row;
    //Pegar o número da última coluna
    y := XLApp.ActiveCell.Column;
    //Seta Stringgrid linha e coluna
    AGrid.RowCount := x;
    AGrid.ColCount := y;
    //Associaca a variant WorkSheet com a variant do Delphi
    RangeMatrix := XLApp.Range['A1', XLApp.Cells.Item[x, y]].Value;
    //Cria o loop para listar os registros no TStringGrid
    k := 1;
    repeat
      for r := 1 to y do
        AGrid.Cells[(r - 1), (k - 1)] := RangeMatrix[k, r];
      Inc(k, 1);
    until k > x;
    RangeMatrix := Unassigned;
  finally
    //Fecha o Excel
    if not VarIsEmpty(XLApp) then
    begin
      XLApp.Quit;
      XLApp := Unassigned;
      Sheet := Unassigned;
      Result := True;
    end;
  end;
end;

end.
