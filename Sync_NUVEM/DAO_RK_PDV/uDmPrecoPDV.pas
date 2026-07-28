unit uDmPrecoPDV;

interface

uses
  System.SysUtils, System.Classes,ConexaoPDV, Data.DB, MemDS, DBAccess, Uni,Preco,System.Generics.collections,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDmPrecoPDV = class(TDataModule)
    qrPreco: TFDQuery;
  private
    { Private declarations }
  public
  function updatePreco(listPreco: TObjectList<TPreco>):boolean;
  end;

var
  DmPrecoPDV: TDmPrecoPDV;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

function TDmPrecoPDV.updatePreco(listPreco: TObjectList<TPreco>): boolean;
var
  i:integer;
  oPreco:TPreco;
begin
  i :=0;
  qrPreco.Params.ArraySize := listPreco.Count;
  for oPreco in listPreco do
  begin
    if oPreco.oferta > 0 then
    begin
    qrPreco.ParamByName('PRECO_VENDA').AsFloat := oPreco.oferta;
    end
    else
    begin
    qrPreco.ParamByName('PRECO_VENDA').AsFloat := oPreco.preco;
    end;
    qrPreco.ParamByName('CODIGO').AsString := oPreco.codigo_produto;
    qrPreco.ParamByName('CUSTO').AsFloat := oPreco.custo;

      qrPreco.ExecSQL;


  end;

end;

end.
