unit uDmCodigoAuxiliar;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,Classe.CodigoAuxiliar;

type
  TdmCodigoAuxiliar = class(TDataModule)
    qrCodigoAuxiliarPesq: TUniQuery;
    getCodigoAuxiliar: TUniQuery;
  private
    { Private declarations }
  public
    function ObterCodigoAuxiliar(codigo_barras:string):TCodigoAuxiliar;
  end;

var
  dmCodigoAuxiliar: TdmCodigoAuxiliar;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmCodigoAuxiliar }





function TdmCodigoAuxiliar.ObterCodigoAuxiliar(
  codigo_barras: string): TCodigoAuxiliar;
begin
result := TCodigoAuxiliar.Create;
Result.codigo_auxiliar := codigo_barras;
with getCodigoAuxiliar do
begin
  close;
  sql.Clear;
  sql.Add('SELECT * FROM CODIGO_AUXILIAR WHERE CODIGO_AUXILIAR = :CODIGO');
  ParamByName('CODIGO').AsString := Result.codigo_auxiliar;
  Open;


  if getCodigoAuxiliar.RecordCount > 0 then
  begin
    result.codigo := FieldByName('CODIGO').AsString;
    result.codigo_barras := FieldByName('CODIGO_BARRAS').AsString;
    result.codigo_auxiliar := FieldByName('CODIGO_AUXILIAR').AsString;
  end;
end;
end;


end.
