unit PDV_Connection;

interface
uses FireDAC.Comp.Client,FireDAC.Comp.UI,System.SysUtils;

type
  TPDV_Connection = class
  public
  constructor Create(caminhoBanco:string);
  destructor Destroy; override;
  function GetQuery(query:string):TFDQuery;
  function UpdateQuery(query:string):TFDQuery;

var
    FConn: TFDConnection;
    FDWaitCursor: TFDGUIxWaitCursor;
    query:TFDQuery;
    bulkQuery:TFDQuery;

end;

implementation

{ TPDV_Connection }

constructor TPDV_Connection.Create(caminhoBanco:string);
begin
try
  if not(FileExists(caminhoBanco)) then exit;

  FConn := TFDConnection.Create(nil);
  FDWaitCursor := TFDGUIxWaitCursor.Create(nil);
  // Configuração da conexão com o Firebird
  FConn.DriverName := 'IB';
  FConn.Params.DriverID := 'IB'; // Define o driver Firebird
  FConn.Params.Database := '127.0.0.1:'+ caminhoBanco;
  FConn.Params.UserName := 'sysdba'; // Usuário padrão
  FConn.Params.Password := 'masterkey'; // Senha padrão


  query := TFDQuery.Create(nil);
  query.Connection := FConn;

  bulkQuery := TFDQuery.Create(nil);
  bulkQuery.Connection := FConn;

  FConn.Connected := True;

except
on E:Exception do
begin
raise Exception.Create(e.Message);

end;

end;
end;

destructor TPDV_Connection.Destroy;
begin
  FConn.Free;
  inherited;
end;

function TPDV_Connection.GetQuery(query: string): TFDQuery;
begin
  result := TFDQuery.Create(nil);
  result.Connection := FConn;
  Result.SQL.clear;
  result.SQL.Add(query);
end;

function TPDV_Connection.UpdateQuery(query: string): TFDQuery;
begin
  result := TFDQuery.Create(nil);
  result.Connection := FConn;
  Result.SQL.clear;
  result.SQL.Add(query);
  result.execsql;
end;

end.
