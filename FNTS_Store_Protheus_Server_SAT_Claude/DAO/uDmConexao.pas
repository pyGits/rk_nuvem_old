unit uDmConexao;

interface

uses
  System.SysUtils, System.Classes, DASQLMonitor, UniSQLMonitor, UniProvider,
  InterBaseUniProvider, Data.DB, DBAccess, Uni;

type
  TdmConexao = class(TDataModule)
    sqlConexaoFirebird: TUniConnection;
    InterBaseUniProvider1: TInterBaseUniProvider;
    monitor: TUniSQLMonitor;
  private
    { Private declarations }
  public
  end;

var
  dmConexao: TdmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmConexao }




end.
