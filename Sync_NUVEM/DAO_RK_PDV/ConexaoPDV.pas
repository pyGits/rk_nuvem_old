unit ConexaoPDV;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Uni, UniProvider,
  InterBaseUniProvider, DASQLMonitor, UniSQLMonitor, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client;

type
  TuDmConexaoPDV = class(TDataModule)
    ConexaoPDV: TUniConnection;
    InterBaseUniProvider1: TInterBaseUniProvider;
    UniSQLMonitor1: TUniSQLMonitor;
    FDConnection1: TFDConnection;
  private
    { Private declarations }
  public
    function configurarIP(IP:string):Boolean;
  end;

var
  uDmConexaoPDV: TuDmConexaoPDV;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

function TuDmConexaoPDV.configurarIP(IP: string): Boolean;
begin
try
ConexaoPDV.Server := IP;
except

end;
end;

end.
