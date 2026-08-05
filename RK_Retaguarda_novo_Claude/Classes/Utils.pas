unit Utils;

interface
uses System.SysUtils,Data.DB,Uni;
type TUtils = class


public
procedure CreateCSVFromQuery(const FileName: string; Query: TUniQuery);
class function MascaraDinheiro(Valor: Double): string;


end;

implementation

{ TUtils }

procedure TUtils.CreateCSVFromQuery(const FileName: string; Query: TUniQuery);
var
  CSVFile: TextFile;
  Col: TField;
  Row: Integer;
begin
  AssignFile(CSVFile, FileName);
  Rewrite(CSVFile);

  try
    // Escreve os cabeçalhos das colunas
    for Col in Query.Fields do
    begin
      Write(CSVFile, Col.FieldName);
      if Col <> Query.Fields[Query.FieldCount - 1] then
        Write(CSVFile, ';'); // separador de coluna
    end;
    Writeln(CSVFile); // nova linha

    // Escreve os dados
    Query.First;
    while not Query.Eof do
    begin
      for Col in Query.Fields do
      begin
        Write(CSVFile, Col.AsString);
        if Col <> Query.Fields[Query.FieldCount - 1] then
          Write(CSVFile, ';'); // separador de coluna
      end;
      Writeln(CSVFile); // nova linha
      Query.Next;
    end;
  finally
    CloseFile(CSVFile);
  end;
end;

class function TUtils.MascaraDinheiro(Valor: Double): string;
begin
  Result := FormatFloat('#,##0.00', Valor);
end;

end.
