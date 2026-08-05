unit uConexaoSyspdvSQL;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,VCL.dialogs,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.DApt;

type
  TConexaoSyspdvSQL = class
  private
    class var FInstance: TConexaoSyspdvSQL;
    FConexao: TFDConnection;
    constructor CreatePrivate(const AIP: string);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    class function GetInstance(const AIP: string): TConexaoSyspdvSQL;

    function ExecQuery(const ASQL: string): TFDQuery;
    function CreateQuery(const ASQL: string): TFDQuery;
    function ExecSQL(const ASQL: string): Integer; // insert/update/delete
  end;

implementation

{ TConexaoSyspdvSQL }

constructor TConexaoSyspdvSQL.Create;
begin
  raise Exception.Create('Use GetInstance(IP) para obter a conexão.');
end;

constructor TConexaoSyspdvSQL.CreatePrivate(const AIP: string);
begin
try
  FConexao := TFDConnection.Create(nil);
  with FConexao do
  begin
    // Driver do FireDAC para SQL Server
    Params.DriverID := 'MSSQL';
    Params.Database := 'syspdv';          // nome do banco no SQL Server
    Params.UserName := 'sa';              // usuário padrão (ajuste conforme necessário)
    Params.Password := 'masterkey';       // senha do usuário
    Params.Values['Server'] := AIP;       // IP ou nome do servidor
    Params.Values['Port'] := '1433';      // porta padrão do SQL Server
    Params.Values['OSAuthent'] := 'No';   // desativa autenticação do Windows
    LoginPrompt := False;
    Connected := True;
//    showmessage('conectado com sucesso !');
  end;
except
on E:Exception do
begin
ShowMessage(E.message);
Exit;
  raise Exception.Create(e.Message);
end;

end;
end;

destructor TConexaoSyspdvSQL.Destroy;
begin
  FConexao.Free;
  inherited;
end;

class function TConexaoSyspdvSQL.GetInstance(const AIP: string): TConexaoSyspdvSQL;
begin
  if not Assigned(FInstance) then
    FInstance := TConexaoSyspdvSQL.CreatePrivate(AIP);

  Result := FInstance;
end;

function TConexaoSyspdvSQL.ExecQuery(const ASQL: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConexao;
  Result.SQL.Text := ASQL;
  Result.Open;
end;

function TConexaoSyspdvSQL.CreateQuery(const ASQL: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConexao;
  Result.SQL.Text := ASQL;
end;

function TConexaoSyspdvSQL.ExecSQL(const ASQL: string): Integer;
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FConexao;
    Q.SQL.Text := ASQL;
    Q.ExecSQL;
    Result := Q.RowsAffected;
  finally
    Q.Free;
  end;
end;

end.

