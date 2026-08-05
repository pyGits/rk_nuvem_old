unit uConexaoLocal;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.DApt,
  FireDAC.Phys.FB, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef;

type
  TTipoBanco = (tbFirebird, tbSQLServer);

  TConexaoLocal = class
  private
    class var FInstance: TConexaoLocal;
    FConexao: TFDConnection;
    constructor CreatePrivate(const AIP, ABanco: string; ATipoBanco: TTipoBanco);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    class function GetInstance(const AIP, ABanco: string; ATipoBanco: TTipoBanco): TConexaoLocal;

    function ExecQuery(const ASQL: string): TFDQuery;
    function CreateQuery(const ASQL: string): TFDQuery;
    function ExecSQL(const ASQL: string): Integer;

    function GetConnection: TFDConnection;

    property Connection: TFDConnection read GetConnection;
  end;

implementation

{ TConexaoLocal }

constructor TConexaoLocal.Create;
begin
  raise Exception.Create('Use GetInstance para obter a conexão.');
end;

constructor TConexaoLocal.CreatePrivate(const AIP, ABanco: string; ATipoBanco: TTipoBanco);
begin
  FConexao := TFDConnection.Create(nil);
  FConexao.LoginPrompt := False;

  case ATipoBanco of
    tbFirebird:
      begin
        FConexao.Params.DriverID := 'FB';
        FConexao.Params.Database := ABanco;
        FConexao.Params.UserName := 'SYSDBA';
        FConexao.Params.Password := 'masterkey';
        FConexao.Params.Values['Server'] := AIP;
        FConexao.Params.Values['Port'] := '3050';
      end;

    tbSQLServer:
      begin
        FConexao.Params.DriverID := 'MSSQL';
        FConexao.Params.Values['Server'] := AIP;
        FConexao.Params.Database := ABanco;
        FConexao.Params.UserName := 'sa';
        FConexao.Params.Password := '123456';
      end;
  end;

  try
    FConexao.Connected := True;
  except
    on E: Exception do
      raise Exception.CreateFmt('Erro ao conectar ao banco [%s]: %s', [ABanco, E.Message]);
  end;
end;

destructor TConexaoLocal.Destroy;
begin
  FConexao.Free;
  inherited;
end;

class function TConexaoLocal.GetInstance(const AIP, ABanco: string; ATipoBanco: TTipoBanco): TConexaoLocal;
begin
  if not Assigned(FInstance) then
    FInstance := TConexaoLocal.CreatePrivate(AIP, ABanco, ATipoBanco);

  Result := FInstance;
end;

function TConexaoLocal.GetConnection: TFDConnection;
begin
  Result := FConexao;
end;

function TConexaoLocal.CreateQuery(const ASQL: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConexao;
  Result.SQL.Text := ASQL;
end;

function TConexaoLocal.ExecQuery(const ASQL: string): TFDQuery;
begin
  Result := CreateQuery(ASQL);
  Result.Open;
end;

function TConexaoLocal.ExecSQL(const ASQL: string): Integer;
var
  Q: TFDQuery;
begin
  Q := CreateQuery(ASQL);
  try
    Q.ExecSQL;
    Result := Q.RowsAffected;
  finally
    Q.Free;
  end;
end;

end.

