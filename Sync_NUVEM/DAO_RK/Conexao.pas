unit Conexao;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Uni, UniProvider,
  InterBaseUniProvider, DASQLMonitor, UniSQLMonitor, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client;

type
  TdmConexao = class(TDataModule)
    ConexaoServer: TUniConnection;
    InterBaseUniProvider1: TInterBaseUniProvider;
    UniSQLMonitor1: TUniSQLMonitor;
    FDConnection1: TFDConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmConexao: TdmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
