unit uDmConexaoServer;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Uni, DASQLMonitor,
  UniSQLMonitor, UniProvider, InterBaseUniProvider, Registry, Winapi.Windows,VCL.Forms,Vcl.StdCtrls;

type
  TdmConexaoServer = class(TDataModule)
    InterBaseUniProvider1: TInterBaseUniProvider;
    monitor: TUniSQLMonitor;
    sqlConexaoServerFirebird: TUniConnection;
  private
    { Private declarations }
  public
    function IniciarConexaoServer(lblServer,lblBanco:TLabel):Boolean;
  end;

var
  dmConexaoServer: TdmConexaoServer;

implementation
uses Classe.Funcoes;
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmConexaoServer }

function TdmConexaoServer.IniciarConexaoServer(lblServer,lblBanco:TLabel): Boolean;
var IP,Banco:string;
begin
try
    IP := LerIni(ExtractFilePath(Application.ExeName) + '\RK_Sync.Ini' , 'cfg', 'IP','127.0.0.1');
    banco := LerIni(ExtractFilePath(Application.ExeName) + '\RK_Sync.Ini' , 'cfg', 'BANCO','c:\system_rk\server\bd\banco.fdb');

    sqlConexaoServerFirebird.Connected := false;
    sqlConexaoServerFirebird.Database := Banco;
    sqlConexaoServerFirebird.Server := IP;
    lblServer.caption := 'IP: '+IP;
    lblBanco.caption  := 'Banco: '+banco;


    sqlConexaoServerFirebird.Connected := true;
    sqlConexaoServerFirebird.Connect;

    result :=true;

except
   ON E:EXCEPTION DO
   begin
    Result := false;
   end;

end;
end;

end.
