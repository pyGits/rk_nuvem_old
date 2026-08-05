unit uDmCaixa;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni;

type
  TdmCaixa = class(TDataModule)
    qrGridCaixa: TUniQuery;
  private
    { Private declarations }
  public
    function PreencherGrid(ds:TDataSource):Boolean;
  end;

var
  dmCaixa: TdmCaixa;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmCaixa }

function TdmCaixa.PreencherGrid(ds: TDataSource): Boolean;
begin
with qrGridCaixa do
begin
ds.DataSet := qrGridCaixa;
Close;
SQL.Clear;
SQL.Add('SELECT * FROM Caixa');
SQL.Add('ORDER BY 1');

Open;

end;
end;

end.
