unit uDmStorage;

interface

uses
  System.SysUtils, System.Classes, Vcl.Dialogs, System.IOUtils,System.StrUtils;

type
  TdmStorage = class(TDataModule)
  private

  public
    function getRestoreScript:TStringList;
    function ListFilesInSubdirectories(const Directory, Extension: string): TStringList;
    function ReadTextFileLines(const FileName: string): TStringList;
    procedure WriteLog(const msg:string);
  end;

var
  dmStorage: TdmStorage;

implementation

const LOG_FILE_NAME = 'RK_SYNC.LOG';

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmStorage }

function TdmStorage.ReadTextFileLines(const FileName: string): TStringList;
var
  StreamReader: TStreamReader;
  Lines: TStringList;
begin
  Lines := TStringList.Create;
  try
    if not FileExists(FileName) then
      raise Exception.CreateFmt('O arquivo "%s" não existe.', [FileName]);

    StreamReader := TStreamReader.Create(FileName, TEncoding.ANSI);
    try
      while not StreamReader.EndOfStream do
        Lines.Add(StreamReader.ReadLine);
    finally
      StreamReader.Free;
    end;

    Result := Lines;
  except
    Lines.Free;
    raise;
  end;
end;



procedure TdmStorage.WriteLog(const msg: string);
var
  LogFile: TextFile;
  TimeStamp: string;
begin
  AssignFile(LogFile, LOG_FILE_NAME);
  try
    if FileExists(LOG_FILE_NAME) then
      Append(LogFile)
    else
      Rewrite(LogFile);

    TimeStamp := FormatDateTime('dd/mm/yyyy hh:nn:ss', Now);
    Writeln(LogFile, TimeStamp + ' - ' + Msg);
  finally
    CloseFile(LogFile);
  end;
end;

function TdmStorage.getRestoreScript: TStringList;
var
  directoryFiles: TStringList;
  fileDirectory: string;
  fileContent: TStringList;
  allContent: TStringList;
  line:string;
begin
  result := TStringList.Create;
  directoryFiles := ListFilesInSubdirectories('C:\System_RK\PDV\Backup', 'SQL');
  allContent := TStringList.Create;
  for fileDirectory in directoryFiles do
  begin
    fileContent := ReadTextFileLines(fileDirectory);
    for line in fileContent do
    begin

      if AnsiStartsStr('INSERT INTO CUPOM',line) then
      begin
        RESULT.Add(line);
      end;
    end;
  end;

end;

function TdmStorage.ListFilesInSubdirectories(const Directory, Extension: string): TStringList;
var
  SearchRec: TSearchRec;
  FileList: TStringList;
  DirList: TStringList;
  i: Integer;
  FileExt: string;
begin
  FileList := TStringList.Create;
  DirList := TStringList.Create;
  FileExt := '.' + Extension;
  try
    // Lista todos os arquivos no diretório atual com a extensão desejada
    if FindFirst(IncludeTrailingPathDelimiter(Directory) + '*' + FileExt, faAnyFile and not faDirectory, SearchRec) = 0 then
    try
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          if (SearchRec.Attr and faDirectory) = 0 then
            FileList.Add(IncludeTrailingPathDelimiter(Directory) + SearchRec.Name);
        end;
      until FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;

    // Lista os subdiretórios no diretório atual
    if FindFirst(IncludeTrailingPathDelimiter(Directory) + '*.*', faDirectory, SearchRec) = 0 then
    try
      repeat
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') and
           ((SearchRec.Attr and faDirectory) <> 0) then
        begin
          DirList.Add(IncludeTrailingPathDelimiter(Directory) + SearchRec.Name);
        end;
      until FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;

    // Para cada subdiretório, lista os arquivos dentro dele com a extensão desejada
    for i := 0 to DirList.Count - 1 do
    begin
      FileList.AddStrings(ListFilesInSubdirectories(DirList[i], Extension));
    end;

    Result := FileList;
  except
    FileList.Free;
    DirList.Free;
    raise;
  end;
end;

end.

