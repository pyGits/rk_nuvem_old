unit ContaReceberRepositoryImpl;

interface
uses ContaReceberModel,FireDAC.Comp.Client,uConexao,ContaReceberItemModel,ProdutoRepositoryImpl;
type IContaReceberRepository = interface
  ['{9E1295B9-453F-47C1-9F83-4EFB7AF745CF}']
  function getByCodigo(codigo:string):TContaReceberModel;
end;

type TContaReceberRepositoryFirebird = class(TInterfacedObject,IContaReceberRepository)
  private
  FProdutoRepository:IProdutoRepository;
  public
    constructor create;
    function getByCodigo(codigo: string): TContaReceberModel;
end;

implementation

{ TContaReceberRepositoryFirebird }


constructor TContaReceberRepositoryFirebird.create;
begin
FProdutoRepository := TProdutoRepositoryFirebird.Create;
end;

function TContaReceberRepositoryFirebird.getByCodigo(
  codigo: string): TContaReceberModel;
var
  query:TFDquery;
begin
result := nil;

query := TConexao.GetInstance.CreateQuery('SELECT * FROM CONTAS_RECEBER WHERE CODIGO = :CODIGO');
query.ParamByName('CODIGO').AsString := codigo;
query.Open;


if query.RecordCount = 0 then exit;

  result := TContaReceberModel.Create;
  result.codigo := query.FieldByName('CODIGO').AsString;
  result.cod_cupom := query.FieldByName('COD_CUPOM').AsString;
  result.cod_vendedor := query.FieldByName('COD_VENDEDOR').AsInteger;
  result.cod_caixa := query.FieldByName('COD_CAIXA').AsInteger;
  result.cod_cliente := query.FieldByName('COD_CLIENTE').AsString;
  result.data_emissao := query.FieldByName('DATA_EMISSAO').AsDateTime;
  result.data_vencimento := query.FieldByName('DATA_VENCIMENTO').AsDateTime;
  result.data_pagamento := query.FieldByName('DATA_PAGAMENTO').AsDateTime;
  result.valor := query.FieldByName('VALOR').AsFloat;
  result.valor_pago := query.FieldByName('VALOR_PAGO').AsFloat;
  result.valor_desconto := query.FieldByName('VALOR_DESCONTO').AsFloat;
  result.valor_acrescimo := query.FieldByName('VALOR_ACRESCIMO').AsFloat;
  result.valor_restante := query.FieldByName('VALOR_RESTANTE').AsFloat;
  result.cancelado := query.FieldByName('CANCELADO').AsInteger;
  result.status := query.FieldByName('STATUS').AsInteger;


// ITENS

query := TConexao.GetInstance.CreateQuery('SELECT * FROM CUPOM_ITEM WHERE COD_CUPOM = :COD_CUPOM');
query.ParamByName('COD_CUPOM').AsString := result.cod_cupom;
query.Open;

  while not query.Eof do
  begin
    result.items.Add(TContaReceberItemModel.create);
    result.items.Last.seq := query.FieldByName('ITEM').AsInteger;
    result.items.Last.unidade := query.FieldByName('UNIDADE').AsString;
    result.items.Last.qtd := query.FieldByName('QTDE').AsFloat;
    result.items.Last.vlr_unitario := query.FieldByName('VALOR_UNITARIO').AsFloat;
    result.items.Last.vlr_desconto := query.FieldByName('VALOR_DESCONTO').AsFloat;
    result.items.Last.vlr_total:= query.FieldByName('VALOR_TOTAL').AsFloat;
    result.items.Last.produto := FProdutoRepository.getByCodigo(query.FieldByName('COD_PRODUTO').AsString);
    query.Next;
  end;



end;

end.
