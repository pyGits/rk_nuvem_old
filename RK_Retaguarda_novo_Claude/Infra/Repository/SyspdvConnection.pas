unit SyspdvConnection;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, FireDAC.Phys.MSSQL, FireDAC.Stan.Def,
  FireDAC.DApt, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI;

type
  TFirebirdConnection = class
  private
    FConn: TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;
    function ExecuteQuery(query: string): TFDQuery;

    var
      query: TFDQuery;
  end;

  TSqlServerConnection = class
  private
    FConn: TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;
    function ExecuteQuery(query: string): TFDQuery;

    var
      query: TFDQuery;
  end;

var
  SyspdvConn: TFirebirdConnection;
  SyspdvConnSQL: TSqlServerConnection;
  FDWaitCursor: TFDGUIxWaitCursor;

implementation

{ TFirebirdConnection }

constructor TFirebirdConnection.Create;
begin
  if not FileExists('C:\syspdv\syspdv_srv.fdb') then exit;


  try
    FConn := TFDConnection.Create(nil);
    FDWaitCursor := TFDGUIxWaitCursor.Create(nil);

    FConn.DriverName := 'FB';
    FConn.Params.DriverID := 'FB';
    FConn.Params.Database := 'C:\syspdv\syspdv_srv.fdb';
    FConn.Params.UserName := 'sysdba';
    FConn.Params.Password := 'masterkey';

    query := TFDQuery.Create(nil);
    query.Connection := FConn;

    FConn.Connected := True;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao Firebird: ' + E.Message);
  end;
end;

destructor TFirebirdConnection.Destroy;
begin
  FConn.Free;
  inherited;
end;

function TFirebirdConnection.ExecuteQuery(query: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConn;
  Result.SQL.Clear;
  Result.SQL.Add(query);
  Result.Open;
end;

{ TSqlServerConnection }

constructor TSqlServerConnection.Create;
begin
//  if not FileExists('C:\syspdv\syspdv_srv.fdb') then exit;
//  try
//    FConn := TFDConnection.Create(nil);
//    FDWaitCursor := TFDGUIxWaitCursor.Create(nil);
//
//    FConn.DriverName := 'FB';
//    FConn.Params.DriverID := 'FB';
//    FConn.Params.Database := 'C:\syspdv\syspdv_srv.fdb';
//    FConn.Params.UserName := 'sysdba';
//    FConn.Params.Password := 'masterkey';
//
//    query := TFDQuery.Create(nil);
//    query.Connection := FConn;
//
//    FConn.Connected := True;
//  except
//    on E: Exception do
//      raise Exception.Create('Erro ao conectar ao Firebird: ' + E.Message);
//  end;
  try
    FConn := TFDConnection.Create(nil);
    FDWaitCursor := TFDGUIxWaitCursor.Create(nil);

    // Configuração da conexão com o SQL Server
    FConn.DriverName := 'MSSQL';
    FConn.Params.DriverID := 'MSSQL';
    FConn.Params.Values['Server'] := 'localhost'; // altere conforme seu servidor
    FConn.Params.Values['Database'] := 'syspdv'; // nome do banco
    FConn.Params.Values['User_Name'] := 'sa'; // usuário SQL Server
    FConn.Params.Values['Password'] := 'masterkey'; // senha do SQL Server
    FConn.Params.Values['MARS'] := 'Yes'; // múltiplos resultados ativos (recomendado)

    query := TFDQuery.Create(nil);
    query.Connection := FConn;

    FConn.Connected := True;
  except
    on E: Exception do
    begin
//      raise Exception.Create('Erro ao conectar ao SQL Server: ' + E.Message);
    end;
  end;
end;

destructor TSqlServerConnection.Destroy;
begin
  FConn.Free;
  inherited;
end;

function TSqlServerConnection.ExecuteQuery(query: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConn;
  Result.SQL.Clear;
  Result.SQL.Add(query);
  Result.Open;
end;

initialization
  SyspdvConn := TFirebirdConnection.Create;
  SyspdvConnSQL := TSqlServerConnection.Create;

end.

