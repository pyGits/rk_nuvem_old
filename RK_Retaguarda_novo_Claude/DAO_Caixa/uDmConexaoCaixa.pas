unit uDmConexaoCaixa;

interface

uses
  System.SysUtils, System.Classes, DASQLMonitor, UniSQLMonitor, UniProvider,
  InterBaseUniProvider, Data.DB, DBAccess, Uni;

type
  TdmConexaoCaixa = class(TDataModule)
    conexaoCaixa: TUniConnection;
    InterBaseUniProvider1: TInterBaseUniProvider;
    UniSQLMonitor1: TUniSQLMonitor;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmConexaoCaixa: TdmConexaoCaixa;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
