unit ProdutoSyspdvAdapter;

interface
uses
Produto,FireDAC.comp.client,System.Sysutils,System.hash;

type TProdutoSyspdvAdapter = class
private


public
  class function ProdutoSyspdv(query:TFDQuery):TProduto;
end;

implementation

{ TProdutoSyspdvAdapter }


{ TProdutoSyspdvAdapter }


class function TProdutoSyspdvAdapter.ProdutoSyspdv(query: TFDQuery): TProduto;
var
  bFracionado:boolean;
  bBalanca:Boolean;
begin
result := TProduto.Create;
with result,query do
  begin

  bFracionado := false;
  bBalanca := false;

//  Codigo := GerarHashDeSeisDigitosNumeros( IntToStr(query.RecNo));
  CodigoBarras := FieldByName('PROCOD').AsString;
  if FieldByName('PROPESVAR').AsString = 'S' then
  begin
    bFracionado := true;
  end;

  if FieldByName('PROENVBAL').AsString = 'S' then
  begin
    bBalanca := True;
  end;

  Descricao := FieldByName('PRODES').AsString;
  Tributacao := FieldByName('TRBID').AsString;
  Unidade := FieldByName('PROUNID').AsString;
  Inativo := false;
  Grupo :=FieldByName('SECCOD').AsString;
  Subgrupo :=FieldByName('GRPCOD').AsString;
  Margem := FieldByName('PROMRG1').AsFloat;

  if FieldByName('PROPRCOFEVAR').asfloat > 0 then
  begin
    Preco := FieldByName('PROPRCOFEVAR').AsFloat;
  end
  else
  begin
    Preco := FieldByName('PROPRCVDAVAR').AsFloat;
  end;


  Preco2 := FieldByName('PROPRCVDA2').AsFloat;
  QtdMinPreco2 := FieldByName('proqtdminprc2').AsFloat;

  Preco3 := FieldByName('PROPRCVDA3').AsFloat;
  QtdMinPreco3 := FieldByName('proqtdminprc3').AsFloat;

  Custo := FieldByName('PROPRCCST').AsFloat;
  Validade := FieldByName('PROVLD').AsString;
  NCM := FieldByName('PRONCM').AsString;
  cest := FieldByName('PROCEST').AsString;
  Fracionado := bFracionado;
  Balanca := bBalanca;

  end;
end;

end.
