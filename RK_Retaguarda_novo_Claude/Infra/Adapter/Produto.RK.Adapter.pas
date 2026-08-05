unit Produto.RK.Adapter;


interface
uses
Produto,FireDAC.comp.client,System.Sysutils;

type TProdutoRKAdapter = class
  class function toDomain(query:TFDQuery):TProduto;
end;

implementation

{ TProdutoRKAdapter }

class function TProdutoRKAdapter.toDomain(query: TFDQuery): TProduto;
begin
  Result := TProduto.create;
  with result do
  begin
  Codigo       := query.FieldByName('CODIGO').AsString;
  CodigoBarras := query.FieldByName('CODIGO_BARRAS').asstring;
  Descricao    := query.FieldByName('DESCRICAO').asstring;
  Grupo        := query.FieldByName('GRUPO').asstring;
  Subgrupo     := query.FieldByName('SUBGRUPO').asstring;
  Fornecedor   := query.FieldByName('FORNECEDOR').asstring;
  Tributacao   := query.FieldByName('Tributacao').AsString;
  NCM          := query.FieldByName('NCM').AsString;
  CEST         := query.FieldByName('CEST').AsString;
  Validade     := query.FieldByName('Validade').AsString;
  Unidade      := query.FieldByName('Unidade').AsString;

  Custo        := query.FieldByName('CUSTO').AsFloat;
  Preco        := query.FieldByName('PRECO').AsFloat;
  Margem       := query.FieldByName('MARGEM').AsFloat;
  Estoque      := query.FieldByName('Estoque').AsFloat;
  DataCadastro := query.FieldByName('DATA_CADASTRO').AsDateTime;
  DataAlterado := query.FieldByName('DATA_ALTERADO').AsDateTime;
  Balanca      := getBoolBalanca(query.FieldByName('BALANCA').AsInteger);
  Fracionado   := getBoolFracionado(query.FieldByName('Fracionado').AsInteger);
  Inativo      := getBoolInativo(query.FieldByName('INATIVO').AsInteger);
  Diversos     := getBoolDiversos(query.FieldByName('DIVERSOS').AsInteger);
  estoqueMaximo := query.FieldByName('ESTOQUE_MAXIMO').AsFloat;
  estoqueMinimo := query.FieldByName('ESTOQUE_MINIMO').AsFloat;
  OBSERVACAO := query.FieldByName('OBSERVACAO').ASSTRING;
  end;
end;

end.
