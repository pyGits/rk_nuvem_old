unit uTxtManager;

interface

uses
  System.SysUtils, System.Classes;

type
  TTxtManager = class
  private
    FFileName: string;
  public
    constructor Create(const AFileName: string);

    // Lê todo o conteúdo do arquivo
    function ReadAll: string;

    // Escreve no arquivo (sobrescreve)
    procedure Write(const AText: string);

    // Adiciona conteúdo ao final do arquivo
    procedure Append(const AText: string);

    // Verifica se o arquivo existe
    function Exists: Boolean;

    procedure Clear;
  end;

implementation

{ TTxtManager }

procedure TTxtManager.Clear;
begin
  Write(''); // sobrescreve o arquivo com vazio
end;

constructor TTxtManager.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
end;

function TTxtManager.ReadAll: string;
var
  SL: TStringList;
begin
  Result := '';
  if not FileExists(FFileName) then Exit;
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FFileName, TEncoding.UTF8);
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

procedure TTxtManager.Write(const AText: string);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.Text := AText;
    SL.SaveToFile(FFileName, TEncoding.UTF8);
  finally
    SL.Free;
  end;
end;

procedure TTxtManager.Append(const AText: string);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    if FileExists(FFileName) then
      SL.LoadFromFile(FFileName, TEncoding.UTF8);
    SL.Add(AText);
    SL.SaveToFile(FFileName, TEncoding.UTF8);
  finally
    SL.Free;
  end;
end;

function TTxtManager.Exists: Boolean;
begin
  Result := FileExists(FFileName);
end;

end.

