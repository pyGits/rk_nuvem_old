unit uConexaoPDV;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.DApt;

type
  TConexaoPDV = class
  private
    class var FInstance: TConexaoPDV;
    FConexao: TFDConnection;
    constructor CreatePrivate;

    function GetConexao: TFDConnection; // <-- getter
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    class function GetInstance(const AIP:string): TConexaoPDV;

    procedure SetIP(const AIP: string);

    function ExecQuery(const ASQL: string): TFDQuery;
    function CreateQuery:TFDQuery;
    function ExecSQL(const ASQL: string): Integer; // insert/update/delete

    property Conexao: TFDConnection read GetConexao; // <-- usa getter
  end;

implementation

{ TConexaoPDV }

constructor TConexaoPDV.Create;
begin
  raise Exception.Create('Use GetInstance para obter a conexão.');
end;

constructor TConexaoPDV.CreatePrivate;
begin
  FConexao := TFDConnection.Create(nil);
  FCONEXAO.DriverName := 'IB';
  FCONEXAO.Params.DriverID := 'IB'; // Define o driver Firebird
  with FConexao.Params do
  begin
//    FConexao.DriverName := 'IB';
//    DriverID := 'IB';



    Database := 'C:\System_RK\PDV\BD\SAT_DATPDV.FDB';
    UserName := 'SYSDBA';
    Password := 'masterkey';
    Values['Server'] := '127.0.0.1'; // valor inicial padrão
    Values['Port']   := '3050';
  end;

  FConexao.LoginPrompt := False;
end;

function TConexaoPDV.CreateQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConexao;
end;

destructor TConexaoPDV.Destroy;
begin
  FConexao.Free;
  inherited;
end;

class function TConexaoPDV.GetInstance(const AIP: string): TConexaoPDV;
begin
  if not Assigned(FInstance) then
    FInstance := TConexaoPDV.CreatePrivate;

  // se o IP passado for diferente, troca
  if FInstance.FConexao.Params.Values['Server'] <> AIP then
    FInstance.SetIP(AIP);

  Result := FInstance;
end;

procedure TConexaoPDV.SetIP(const AIP: string);
var
  LIP: string;
begin
  if FConexao.Connected then
    FConexao.Connected := False;

  if Trim(AIP) = '' then raise Exception.Create('IP Inválido ! : '+ AIP);


  LIP := AIP;

  FConexao.Params.Values['Server'] := LIP;
  FConexao.Connected := True;
end;

function TConexaoPDV.GetConexao: TFDConnection;
begin
  Result := FConexao;
end;

function TConexaoPDV.ExecQuery(const ASQL: string): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConexao;
  Result.SQL.Text := ASQL;
  Result.Open;
end;

function TConexaoPDV.ExecSQL(const ASQL: string): Integer;
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

