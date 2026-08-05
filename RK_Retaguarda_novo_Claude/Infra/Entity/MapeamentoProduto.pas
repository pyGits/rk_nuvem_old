unit MapeamentoProduto;

interface
uses
System.Generics.Collections,Produto,CodigoAuxiliar,System.sysutils;


type TMapeamentoProduto = class
  private
    Fcodigo_externo: string;
    Fcodigo: string;
    procedure Setcodigo(const Value: string);
    procedure Setcodigo_externo(const Value: string);
  public
  property codigo:string read Fcodigo write Setcodigo;
  property codigo_externo:string read Fcodigo_externo write Setcodigo_externo;
end;

type TMapeamentoProdutoList = class
  class function PreencherCodigoProduto(produtoList:TObjectList<TProduto>;mapeamentoList:TObjectList<TMapeamentoProduto>;ultimoSeq:integer):TObjectList<TMapeamentoProduto>;
  class function PreencherCodigoProdutoAuxiliar(produtoList:TObjectList<TCodigoAuxiliar>;mapeamentoList:TObjectList<TMapeamentoProduto>):TObjectList<TMapeamentoProduto>;

  class function getProdutosSemMapeamento(produtoList:TObjectList<TProduto>;mapeamentoList:TObjectList<TMapeamentoProduto>):TObjectList<TProduto>;

end;

implementation

{ TMapeamentoProduto }

procedure TMapeamentoProduto.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TMapeamentoProduto.Setcodigo_externo(const Value: string);
begin
  Fcodigo_externo := Value;
end;

{ TMapeamentoProdutoList }





class function TMapeamentoProdutoList.getProdutosSemMapeamento(
  produtoList: TObjectList<TProduto>; mapeamentoList:TObjectList<
  TMapeamentoProduto>): TObjectList<TProduto>;
  var
  produto:TProduto;
  map:TMapeamentoProduto;
  encontrado:boolean;
begin
  // Inicializa a lista de produtos sem mapeamento
  Result := TObjectList<TProduto>.Create;

  // Percorre todos os produtos na lista produtoList
  for produto in produtoList do
  begin
    encontrado := False;

    // Verifica se o produto existe na lista de mapeamento
    for map in mapeamentoList do
    begin
      // Se o codigo_externo no mapeamento corresponder ao codigobarras do produto, ele tem mapeamento
      if map.codigo_externo = produto.codigobarras then
      begin
        encontrado := True;
        Break;  // Sai do loop se encontrar o mapeamento
      end;
    end;

    // Se não foi encontrado um mapeamento para o produto, adiciona na lista de retorno
    if not encontrado then
      Result.Add(produto);
  end;
end;

class function TMapeamentoProdutoList.PreencherCodigoProduto(
  produtoList: TObjectList<TProduto>;mapeamentoList:TObjectList<TMapeamentoProduto>;ultimoSeq:integer):TObjectList<TMapeamentoProduto>;
var
  mapeamentoDict: TDictionary<string, TMapeamentoProduto>;
  Produto: TProduto;
  MapeamentoItem: TMapeamentoProduto;
  sequencial:integer;
begin
  sequencial := ultimoSeq+1;
  // Inicializa o dicionário
  mapeamentoDict := TDictionary<string, TMapeamentoProduto>.Create;
  try
    // Preenche o dicionário com os mapeamentos
    for MapeamentoItem in mapeamentoList do
    begin
      if not mapeamentoDict.ContainsKey(MapeamentoItem.codigo_externo) then
      begin
      mapeamentoDict.Add(MapeamentoItem.codigo_externo, MapeamentoItem);
      end;
    end;

    // Percorre cada produto da lista de produtos
    for Produto in produtoList do
    begin
      // Tenta encontrar o mapeamento pelo codigo_externo no dicionário
      if mapeamentoDict.TryGetValue(Produto.CodigoBarras, MapeamentoItem) then
      begin
        // Se encontrar o mapeamento correspondente, preenche o campo codigo
        Produto.codigo := MapeamentoItem.codigo;
      end
      else
      begin
        Produto.Codigo := IntToStr(sequencial);
        MapeamentoItem := TMapeamentoProduto.Create;
        MapeamentoItem.codigo := IntToStr(sequencial);
        MapeamentoItem.codigo_externo := produto.CodigoBarras;
        mapeamentoList.Add(MapeamentoItem);
        sequencial := sequencial +1;
      end;
    end;
  finally
    // Libera o dicionário, não é necessário liberar os itens, apenas o dicionário
    mapeamentoDict.Free;
  end;
end;

class function TMapeamentoProdutoList.PreencherCodigoProdutoAuxiliar(
  produtoList: TObjectList<TCodigoAuxiliar>;
  mapeamentoList: TObjectList<TMapeamentoProduto>): TObjectList<TMapeamentoProduto>;
var
  mapeamentoDict: TDictionary<string, TMapeamentoProduto>;
  Produto: TCodigoAuxiliar;
  MapeamentoItem: TMapeamentoProduto;
begin
  // Inicializa o dicionário
  mapeamentoDict := TDictionary<string, TMapeamentoProduto>.Create;
  try
    // Preenche o dicionário com os mapeamentos
    for MapeamentoItem in mapeamentoList do
    begin
     if not mapeamentoDict.ContainsKey(MapeamentoItem.codigo_externo) then
     begin
      mapeamentoDict.Add(MapeamentoItem.codigo_externo, MapeamentoItem);
     end;
    end;

    // Percorre cada produto da lista de produtos
    for Produto in produtoList do
    begin
      // Tenta encontrar o mapeamento pelo codigo_externo no dicionário
      if mapeamentoDict.TryGetValue(Produto.codigo_barras, MapeamentoItem) then
      begin
        // Se encontrar o mapeamento correspondente, preenche o campo codigo
        Produto.codigo := MapeamentoItem.codigo;
      end
//      else
//      begin
//
//        result.Add(MapeamentoItem);
//      end;
    end;
  finally
    // Libera o dicionário, não é necessário liberar os itens, apenas o dicionário
    mapeamentoDict.Free;
  end;
end;

end.
