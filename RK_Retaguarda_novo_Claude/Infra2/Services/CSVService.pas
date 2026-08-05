unit CSVService;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  TCSVRow = TArray<string>;

  TCSVService = class
  private
    FDelimiter: Char;
    FHasHeader: Boolean;

    function ParseLine(const Line: string): TCSVRow;
    procedure AddField(var ARow: TCSVRow; const Value: string);
  public
    constructor Create(
      ADelimiter: Char = ';';
      AHasHeader: Boolean = True
    );

    function ReadAll(const FileName: string): TList<TCSVRow>;
    function ReadHeader(const FileName: string): TCSVRow;
  end;

implementation

{ TCSVService }

constructor TCSVService.Create(
  ADelimiter: Char;
  AHasHeader: Boolean
);
begin
  FDelimiter := ADelimiter;
  FHasHeader := AHasHeader;
end;

procedure TCSVService.AddField(var ARow: TCSVRow; const Value: string);
var
  Len: Integer;
begin
  Len := Length(ARow);
  SetLength(ARow, Len + 1);
  ARow[Len] := Value;
end;

function TCSVService.ParseLine(const Line: string): TCSVRow;
var
  I: Integer;
  InQuotes: Boolean;
  Current: string;
  Ch: Char;
begin
  InQuotes := False;
  Current := '';
  SetLength(Result, 0);

  for I := 1 to Length(Line) do
  begin
    Ch := Line[I];

    if Ch = '"' then
    begin
      InQuotes := not InQuotes;
    end
    else if (Ch = FDelimiter) and (not InQuotes) then
    begin
      AddField(Result, Current);
      Current := '';
    end
    else
    begin
      Current := Current + Ch;
    end;
  end;

  // último campo
  AddField(Result, Current);
end;

function TCSVService.ReadAll(const FileName: string): TList<TCSVRow>;
var
  SL: TStringList;
  I: Integer;
  StartIndex: Integer;
begin
  if not FileExists(FileName) then
    raise Exception.Create('Arquivo CSV não encontrado: ' + FileName);

  Result := TList<TCSVRow>.Create;
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName);

    StartIndex := 0;
    if FHasHeader then
      StartIndex := 1;

    for I := StartIndex to SL.Count - 1 do
      Result.Add(ParseLine(SL[I]));
  finally
    SL.Free;
  end;
end;

function TCSVService.ReadHeader(const FileName: string): TCSVRow;
var
  SL: TStringList;
begin
  if not FileExists(FileName) then
    raise Exception.Create('Arquivo CSV não encontrado: ' + FileName);

  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName, TEncoding.UTF8);

    if SL.Count = 0 then
      raise Exception.Create('Arquivo CSV vazio');

    Result := ParseLine(SL[0]);
  finally
    SL.Free;
  end;
end;

end.

