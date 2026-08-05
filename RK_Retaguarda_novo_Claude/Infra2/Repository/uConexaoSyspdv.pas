unit uConexaoSyspdv;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,VCL.dialogs,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.DApt;

type
  TConexaoSyspdv = class
  private
    class var FInstance: TConexaoSyspdv;
    FConexao: TFDConnection;
    constructor CreatePrivate(const AIP: string);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    class function GetInstance(const AIP: string): TConexaoSyspdv;

    function ExecQuery(const ASQL: string): TFDQuery;
    function CreateQuery(const ASQL: string): TFDQuery;
    function ExecSQL(const ASQL: string): Integer; // insert/update/delete
  end;

implementation

{ TConexaoSyspdv }

constructor TConexaoSyspdv.Create;
begin
  raise Exception.Create('Use GetInstance(IP) para obter a conexão.');
end;

constructor TConexaoSyspdv.CreatePrivate(const AIP: string);
begin
try
  FConexao := TFDConnection.Create(nil);
  with FConexao do
  begin
    Params.DriverID := 'FB';
    Params.Database := 'C:\syspdv\syspdv_srv.fdb';  // caminho fixo do banco
    Params.UserName := 'SYSDBA';
    Params.Password := 'masterkey';
    Params.Values['Server'] := AIP;              // usa o IP passado
    Params.Values['Port'] := '3050';
    LoginPrompt := False;
    Connected := True;
  end;
except
on E:Exception do
begin
//  raise Exception.Create('Erro ao se conectar no Syspdv Firebird: '+AIP);
  showmessage('Erro ao se conectar com o Syspdv Firebird no IP: '+AIP+ ' - ' +e.Message);
  Exit;

end;

end;
end;

destructor TConexaoSyspdv.Destroy;
begin
  FConexao.Free;
  inherited;
end;

class function TConexaoSyspdv.GetInstance(const AIP: string): TConexaoSyspdv;
begin
  // Cria a conexão se ainda não existir
  if not Assigned(FInstance) then
    FInstance := TConexaoSyspdv.CreatePrivate(AIP);

  Result := FInstance;
end;

function TConexaoSyspdv.ExecQuery(const ASQL: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConexao;
  Result.SQL.Text := ASQL;
  Result.Open;
end;

function TConexaoSyspdv.CreateQuery(const ASQL: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConexao;
  Result.SQL.Text := ASQL;
end;

function TConexaoSyspdv.ExecSQL(const ASQL: string): Integer;
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

