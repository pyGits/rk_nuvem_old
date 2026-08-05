unit IBDataModule;

interface

uses
  System.SysUtils, System.Classes, DASQLMonitor, UniSQLMonitor, UniProvider,
  InterBaseUniProvider, Data.DB, DBAccess, Uni, dbcDBEngine,
  dbcConnection_UniDAC, DAScript, UniScript, MemDS;

type
  TDataMd = class(TDataModule)
    DBCConnection1: TDBCConnectionUniDAC;
    DBCConnection2: TDBCConnectionUniDAC;
    UniConnection1: TUniConnection;
    UniConnection2: TUniConnection;
    InterBaseUniProvider1: TInterBaseUniProvider;
    UniSQLMonitor1: TUniSQLMonitor;
    inserirAjuste: TUniQuery;
    procedure DBCConnection1BeforeConnect(Sender: TObject);
    procedure DBCConnection2BeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataMd: TDataMd;

implementation
uses uFrmAtualizarBanco;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataMd.DBCConnection1BeforeConnect(Sender: TObject);
begin
  UniConnection1.ProviderName := 'InterBase';
  UniConnection1.Username := 'SYSDBA';
  UniConnection1.Password := 'masterkey';
  UniConnection1.Database := frmAtualizarBanco.BANCO_ATUALIZADO;
end;

procedure TDataMd.DBCConnection2BeforeConnect(Sender: TObject);
begin
  UniConnection2.ProviderName := 'InterBase';
  UniConnection2.Username := 'SYSDBA';
  UniConnection2.Password := 'masterkey';
  UniConnection2.Database := frmAtualizarBanco.BANCO;
end;

end.
