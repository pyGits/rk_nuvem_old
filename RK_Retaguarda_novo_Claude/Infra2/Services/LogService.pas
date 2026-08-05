unit LogService;

interface

uses
  System.SysUtils, System.Classes;

type
  ILogService = interface
    ['{13B4D5E6-334D-4BCE-8A3A-3FAF03B62BE6}']
    procedure WriteLog(const FileName, Msg: string);
    procedure ClearLog(const FileName: string); // <-- novo método
  end;

  TLogServiceTxt = class(TInterfacedObject, ILogService)
  public
    procedure WriteLog(const FileName, Msg: string);
    procedure ClearLog(const FileName: string); // <-- implementação
  end;

implementation

{ TLogServiceTxt }

procedure TLogServiceTxt.WriteLog(const FileName, Msg: string);
var
  LogFilePath: string;
  LogFile: TextFile;
  Timestamp: string;
begin
  LogFilePath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + FileName;
  Timestamp := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);

  AssignFile(LogFile, LogFilePath);
  if FileExists(LogFilePath) then
    Append(LogFile)
  else
    Rewrite(LogFile);

  try
    Writeln(LogFile, Timestamp + ' - ' + Msg);
  finally
    CloseFile(LogFile);
  end;
end;

procedure TLogServiceTxt.ClearLog(const FileName: string);
var
  LogFilePath: string;
  LogFile: TextFile;
begin
  LogFilePath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + FileName;

  // Abre em modo Rewrite para zerar o conteúdo
  AssignFile(LogFile, LogFilePath);
  Rewrite(LogFile); // isso apaga todo o conteúdo
  CloseFile(LogFile);
end;

end.

