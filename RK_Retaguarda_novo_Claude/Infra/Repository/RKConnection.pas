unit RKConnection;

interface

uses
  System.SysUtils, FireDAC.Comp.Client,Firedac.phys.IB, FireDAC.Phys.FB, FireDAC.Phys.IBBase,FireDAC.Stan.Def, FireDAC.DApt,Firedac.ui.Intf,FireDAC.VCLUI.Wait,FireDAC.Comp.UI,  UniLoader, Uni,classe.funcoes,vcl.forms;

type
  TFirebirdConnection = class
  private

  public
    constructor Create;
    destructor Destroy; override;
    function GetQuery(query:string):TFDQuery;
    function UpdateQuery(query:string):TFDQuery;

    var
    FConn: TFDConnection;
    query:TFDQuery;
    bulkQuery:TFDQuery;
  end;

  var

    RKConn:TFirebirdConnection;
    FDWaitCursor: TFDGUIxWaitCursor;
    FDDriver:TFDPhysFBDriverLink;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;

implementation

{ TFirebirdConnection }

constructor TFirebirdConnection.Create;

var
IP:string;
begin
try
  FConn := TFDConnection.Create(nil);
  FDWaitCursor := TFDGUIxWaitCursor.Create(nil);
  IP := LerIni(ExtractFilePath(Application.ExeName) + '\Retaguarda.Ini' , 'cfg', 'IP','127.0.0.1');
  // Configuração da conexão com o Firebird
  FConn.DriverName := 'IB';
  FConn.Params.DriverID := 'IB'; // Define o driver Firebird
  FConn.Params.Database := IP+':'+'C:\System_RK\Server\BD\banco.fdb';
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

destructor TFirebirdConnection.Destroy;
begin
  FConn.Free;
  inherited;
end;

function TFirebirdConnection.GetQuery(query: string): TFDQuery;
begin
  result := TFDQuery.Create(nil);
  result.Connection := FConn;
  Result.SQL.clear;
  result.SQL.Add(query);
end;


function TFirebirdConnection.UpdateQuery(query: string): TFDQuery;
begin
  result := TFDQuery.Create(nil);
  result.Connection := FConn;
  Result.SQL.clear;
  result.SQL.Add(query);
  result.execsql;
end;

initialization
  RKConn := TFirebirdConnection.Create;

end.
