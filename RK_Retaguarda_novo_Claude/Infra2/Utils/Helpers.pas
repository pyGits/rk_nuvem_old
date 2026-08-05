unit Helpers;

interface

type
  TIntegerHelper = record helper for Integer
  public
    function ZeroEsquerda(totalLength: Integer): string;
  end;

  TStringHelper = record helper for string
  public
    function ZeroEsquerda(totalLength: Integer; padChar: Char = '0'): string;
    function ParaInteiro:integer;
    function ParaFloat: Double;

    function RemoveLetras:string;
    function Corta(totalLength: Integer): string;
  end;

implementation

uses System.SysUtils;

function TStringHelper.Corta(totalLength: Integer): string;
begin
  if totalLength <= 0 then
    Exit('');

  if Length(Self) <= totalLength then
    Result := Self
  else
    Result := Copy(Self, 1, totalLength);
end;

function TIntegerHelper.ZeroEsquerda(totalLength: Integer): string;
begin
  Result := Format('%.*d', [totalLength, Self]);
end;

function TStringHelper.ParaFloat: Double;
var
  FS: TFormatSettings;
  S: string;
begin
  S := Trim(Self);

  // normaliza decimal vindo de CSV / API (13.45)
  if Pos('.', S) > 0 then
    S := StringReplace(S, '.', ',', [rfReplaceAll]);

  FS := TFormatSettings.Create;
  FS.DecimalSeparator := ',';

  if not TryStrToFloat(S, Result, FS) then
    Result := 0;
end;

function TStringHelper.ParaInteiro: integer;
begin
  if not TryStrToInt(Trim(Self), Result) then
    Result := 0;
end;

function TStringHelper.RemoveLetras: string;
var
I: integer;
S: string;
begin
  S := '';
  for I := 1 To Length(self) Do
  begin
  if (self[I] in ['0'..'9']) then
  begin
  S := S + Copy(self, I, 1);
  end;
  end;
  result := S;
end;

function TStringHelper.ZeroEsquerda(totalLength: Integer; padChar: Char = '0'): string;
begin
  if Length(Self) >= totalLength then
    Result := Self
  else
    Result := StringOfChar(padChar, totalLength - Length(Self)) + Self;
end;

end.

