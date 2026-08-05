unit ProdutoPDVImplRepository;

interface
uses ProdutoModel,System.Generics.Collections,uConexaoPDV,Firedac.comp.client,CaixaModel;
type IProdutoPDVRepository = interface
  ['{C107B761-A252-4745-9CED-899B8CEAC2D2}']
  procedure InsertBulk(produtos:TObjectList<TProdutoModel>; caixa:TCaixaModel);
end;

type TProdutoPdvImplFirebirdRepository = class(TInterfacedObject,IProdutoPDVRepository)

  public

    procedure InsertBulk(produtos: TObjectList<ProdutoModel.TProdutoModel>; caixa:TCaixaModel);
end;
implementation

{ TProdutoPDVImplRepository }


{ TProdutoPdvImplFirebirdRepository }



procedure TProdutoPdvImplFirebirdRepository.InsertBulk(
  produtos: TObjectList<ProdutoModel.TProdutoModel>; caixa:TCaixaModel);
var
  Query:TFDquery;
  I:integer;
begin
  Query := TConexaoPDV.GetInstance(caixa.ip).CreateQuery;

Query.SQL.Text :=
  'UPDATE OR INSERT INTO ESTOQUE (' +
  'CODIGO, COD_BARRA, NOME, UNIDADE, PRECO_VENDA, PRECO_PROMOCAO, INICIO_PROMOCAO, FINAL_PROMOCAO, ' +
  'CST, ALIQUOTA, DESCONTO_MAXIMO, ST, ESTOQUE, IAT, IPPT, SITUACAO, REFERENCIA, TAMANHO, COR, ' +
  'DESCRICAO_COR, DESCRICAO_MARCA, NCM, ALIQIMPORTADO, ALIQNACIONAL, CFOP, CSOSN, USA_BALANCA, ' +
  'PRECO_PROMOCAO_XY, QTDE_PROMOCAO_XY, HABILITA_XY, PRECO_VENDA1, PRECO_VARIAVEL, CUSTO, CEST, ' +
  'QTD_ATACADO1, PRECO_VENDA2, QTD_ATACADO2, TRIBUTACAO, OBSERVACAO,PRECO2,PRECO2_QTD) ' +
  'VALUES (' +
  ':CODIGO, :COD_BARRA, :NOME, :UNIDADE, :PRECO_VENDA, :PRECO_PROMOCAO, :INICIO_PROMOCAO, :FINAL_PROMOCAO, ' +
  ':CST, :ALIQUOTA, :DESCONTO_MAXIMO, :ST, :ESTOQUE, :IAT, :IPPT, :SITUACAO, :REFERENCIA, :TAMANHO, :COR, ' +
  ':DESCRICAO_COR, :DESCRICAO_MARCA, :NCM, :ALIQIMPORTADO, :ALIQNACIONAL, :CFOP, :CSOSN, :USA_BALANCA, ' +
  ':PRECO_PROMOCAO_XY, :QTDE_PROMOCAO_XY, :HABILITA_XY, :PRECO_VENDA1, :PRECO_VARIAVEL, :CUSTO, :CEST, ' +
  ':QTD_ATACADO1, :PRECO_VENDA2, :QTD_ATACADO2, :TRIBUTACAO, :OBSERVACAO , :PRECO2,:PRECO2_QTD) MATCHING(CODIGO)';

  query.Params.ArraySize := produtos.Count;


  for i := 0 to query.Params.ArraySize-1 do
  begin
    with produtos[i] do
    begin
     Query.ParamByName('CODIGO').AsStrings[i]        := produtos[i].Codigo;
    Query.ParamByName('COD_BARRA').AsStrings[i]    := produtos[i].CodigoBarras;
    Query.ParamByName('NOME').AsStrings[i]         := produtos[i].Descricao;
    Query.ParamByName('Tributacao').AsStrings[i]   := produtos[i].Tributacao;
    Query.ParamByName('NCM').AsStrings[i]          := produtos[i].NCM;
    Query.ParamByName('CEST').AsStrings[i]         := produtos[i].CEST;
    Query.ParamByName('USA_BALANCA').AsIntegers[i] := produtos[i].getFracionado;
    Query.ParamByName('SITUACAO').AsIntegers[i]    := produtos[i].getInativo;
    Query.ParamByName('PRECO_VARIAVEL').AsIntegers[i] := produtos[i].getDiversos;
    Query.ParamByName('CUSTO').AsFloats[i]        := produtos[i].Custo;
    Query.ParamByName('PRECO_VENDA').AsFloats[i]  := produtos[i].Preco;
    Query.ParamByName('ESTOQUE').AsFloats[i]      := produtos[i].Estoque;
    Query.ParamByName('Unidade').AsStrings[i]     := produtos[i].Unidade;
    Query.ParamByName('IAT').AsStrings[i]         := 'T';
    Query.ParamByName('IPPT').AsStrings[i]        := 'T';
    Query.ParamByName('OBSERVACAO').AsStrings[i]  := produtos[i].Observacao;
    Query.ParamByName('PRECO2').AsFloats[i]  := produtos[i].preco2;
    Query.ParamByName('PRECO2_QTD').AsFloats[i]  := produtos[i].preco2_qtd;
    end;
  end;




  query.Execute(query.Params.ArraySize,0);

end;

end.
