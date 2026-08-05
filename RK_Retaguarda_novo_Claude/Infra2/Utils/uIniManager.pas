unit uIniManager;

interface

uses
  System.SysUtils, System.IniFiles;

type
  TIniManager = class
  private
    class var FInstance: TIniManager;
    FIniFile: TIniFile;
    constructor CreatePrivate(const APath: string);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    class function GetInstance(const APath: string = ''): TIniManager;

    function ReadString(const Section, Key, Default: string): string;
    procedure WriteString(const Section, Key, Value: string);
  end;

implementation

{ TIniManager }

constructor TIniManager.Create;
begin
  raise Exception.Create('Use GetInstance para obter a instância.');
end;

constructor TIniManager.CreatePrivate(const APath: string);
begin
  if not FileExists(APath) then
    raise Exception.CreateFmt('Arquivo INI não encontrado: %s', [APath]);

  FIniFile := TIniFile.Create(APath);
end;

destructor TIniManager.Destroy;
begin
  FIniFile.Free;
  inherited;
end;

class function TIniManager.GetInstance(const APath: string = ''): TIniManager;
begin
  if not Assigned(FInstance) then
  begin
    if APath = '' then
      raise Exception.Create('Informe o caminho do INI na primeira chamada.');
    FInstance := TIniManager.CreatePrivate(APath);
  end;
  Result := FInstance;
end;

function TIniManager.ReadString(const Section, Key, Default: string): string;
begin
  Result := FIniFile.ReadString(Section, Key, Default);
end;

procedure TIniManager.WriteString(const Section, Key, Value: string);
begin
  FIniFile.WriteString(Section, Key, Value);
end;

end.

