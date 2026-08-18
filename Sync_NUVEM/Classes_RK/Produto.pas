unit Produto;

interface
uses Vcl.Dialogs,system.JSON,rest.json;
type
  TProduto = class
    private
    FDescricao : string;
    FCodigo: string;
    FCodigoBarras: string;
    FGrupo: string;
    FSubgrupo: string;
    FFornecedor: string;
    FFabricante: string;

    FNCM: string;
    FCEST: string;
    FObservacao: string;
    FValidade: string;
    FBalanca: Boolean;
    FFracionado: Boolean;
    FCusto: Real;
    FPreco: Real;
    FMargem: Real;
    FUnidade: String;
    FInativo: Boolean;
    FDiversos: Boolean;
    FEstoque: Real;
    FDataCadastro: TDate;
    FDataAlterado: TDate;
    FTributacao: String;
    FestoqueMinimo: real;
    FestoqueMaximo: Real;
    FestoqueAnterior: Real;
    FPreco2: Real;
    FPreco2_Qtd: real;
    FCodigosAuxiliares: TArray<string>;
    procedure SetDataAlterado(const Value: TDate);
    procedure SetestoqueAnterior(const Value: Real);
    procedure SetPreco2(const Value: Real);
    procedure SetPreco2_Qtd(const Value: real);
    procedure SetCodigosAuxiliares(const Value: TArray<string>);






    public
    constructor create;
    destructor destroy;override;
    function getDescricao: string;
    function getCodigo: string;
    function getBalanca : Integer;
    function getFracionado : integer;
    function getInativo : integer;
    function getDiversos : integer;

    procedure SetDataCadastro(const Value: TDate);
    procedure SetValidade(const Value: string);
    procedure setDescricao(const Value: string);
    procedure SetCodigo(const Value: string);
    procedure SetCodigoBarras(const Value: string);
    procedure SetGrupo(const Value: string);
    procedure SetSubgrupo(const Value: string);
    procedure SetFornecedor(const Value: string);
    procedure SetFabricante(const Value: string);

    procedure SetTributacao(const Value: String);
    procedure SetNCM(const Value: string);
    procedure SetCEST(const Value: string);
    procedure SetObservacao(const Value: string);
    procedure SetEstoque(const Value: Real);

    procedure SetBalanca(const Value: Boolean);
    procedure SetFracionado(const Value: Boolean);
    procedure SetInativo(const Value: Boolean);
    procedure SetDiversos(const Value: Boolean);

    procedure SetCusto(const Value: Real);
    procedure SetPreco(const Value: Real);
    procedure SetMargem(const Value: Real);
    procedure SetUnidade(const Value: string);

    procedure SetestoqueMaximo(const Value: Real);
    procedure SetestoqueMinimo(const Value: real);


    function getBoolBalanca(valor : string):boolean;
    function getBoolFracionado(valor : string):boolean;
    function getBoolInativo(valor : string):boolean;
    function getBoolDiversos(valor : string):boolean;

    property Descricao      : string read FDescricao write setDescricao;
    property Codigo         : string read FCodigo write SetCodigo;
    property CodigoBarras   : string read FCodigoBarras write SetCodigoBarras;
    property Grupo          : string read FGrupo write SetGrupo;
    property Subgrupo       : string read FSubgrupo write SetSubgrupo;
    property Fornecedor     : string read FFornecedor write SetFornecedor;
    property Fabricante     : string read FFabricante write SetFabricante;
    property Tributacao     : string read FTributacao write SetTributacao;
    property NCM            : string read FNCM write SetNCM;
    property CEST           : string read FCEST write SetCEST;
    property Observacao     : string read FObservacao write SetObservacao;
    property Validade       : string read FValidade write SetValidade;
    property Balanca    :Boolean read FBalanca write SetBalanca;
    property Fracionado :Boolean read FFracionado write SetFracionado;
    property Custo      :Real read FCusto write SetCusto;
    property Preco      :Real read FPreco write SetPreco;
    property Margem     :Real read FMargem write SetMargem;
    property Estoque    :Real read FEstoque write SetEstoque;
    property Unidade    :string read FUnidade write SetUnidade;
    property Inativo    :Boolean read FInativo write SetInativo;
    property Diversos   :Boolean read FDiversos write SetDiversos;
    property DataCadastro :TDate read FDataCadastro write SetDataCadastro;
    property DataAlterado :TDate read FDataAlterado write SetDataAlterado;
    property estoqueMinimo :real read FestoqueMinimo write SetestoqueMinimo;
    property estoqueMaximo:Real read FestoqueMaximo write SetestoqueMaximo;
    property estoqueAnterior:Real read FestoqueAnterior write SetestoqueAnterior;
    property Preco2:Real read FPreco2 write SetPreco2;
    property Preco2_Qtd:real read FPreco2_Qtd write SetPreco2_Qtd;
    // Codigos de barras extras do produto (1 produto -> N EANs). Deve ser
    // atribuida DEPOIS de CodigoBarras: o setter descarta o auxiliar que for
    // igual ao codigo de barras principal.
    property CodigosAuxiliares:TArray<string> read FCodigosAuxiliares write SetCodigosAuxiliares;


    function JsonToProduto(const AJson: string): TProduto;
    function generateInsert:string;


  end;

implementation

uses
  System.SysUtils, Funcoes;

// Le uma chave do json sem quebrar quando ela vem ausente ou nula.
// Sem isso, chave ausente causa Access Violation (aborta a carga inteira) e
// chave nula devolve a string literal 'null', que acaba gravada no PDV.
function ValorTexto(json: TJSONObject; const chave: string; const padrao: string = ''): string;
var
  valor: TJSONValue;
begin
  Result := padrao;

  if not Assigned(json) then
    Exit;

  valor := json.GetValue(chave);
  if (not Assigned(valor)) or (valor is TJSONNull) then
    Exit;

  Result := valor.Value;
end;

// Mesma leitura, para os campos numericos: texto vazio ou invalido vira o padrao
// em vez de derrubar a carga com um erro de conversao.
function ValorNumero(json: TJSONObject; const chave: string; const padrao: Double = 0): Double;
var
  texto: string;
begin
  texto := Trim(ValorTexto(json, chave));

  if (texto = '') or (texto = 'null') then
    Exit(padrao);

  if not TryStrToFloat(texto, Result) then
    Result := padrao;
end;

// Le uma chave que vem como array de strings (ex: codigos_barras_auxiliares).
// Chave ausente, nula ou de outro tipo devolve lista vazia em vez de erro.
function ValorLista(json: TJSONObject; const chave: string): TArray<string>;
var
  valor: TJSONValue;
  item: TJSONValue;
  lista: TJSONArray;
  i: Integer;
begin
  Result := nil;

  if not Assigned(json) then
    Exit;

  valor := json.GetValue(chave);
  if (not Assigned(valor)) or (not (valor is TJSONArray)) then
    Exit;

  lista := TJSONArray(valor);
  SetLength(Result, lista.Count);

  for i := 0 to lista.Count - 1 do
  begin
    item := lista.Items[i];
    if (not Assigned(item)) or (item is TJSONNull) then
      Result[i] := ''
    else
      Result[i] := item.Value;
  end;
end;

{ TProduto }

constructor TProduto.create;
begin
  Unidade := 'UN';
  Tributacao := 'F00';
  DataCadastro := Date();
  DataAlterado := Date();
end;

destructor TProduto.destroy;
begin
  inherited;
end;

function TProduto.generateInsert: string;
begin
Result := '';
end;

function TProduto.getBalanca: Integer;
var
  balanca :integer;
begin
  if FBalanca = true then
  begin
    balanca := 1;
  end
  else
  begin
    balanca := 2;
  end;

  Result := balanca;
end;

function TProduto.getBoolBalanca(valor: string): boolean;
var
  balanca :boolean;
begin
  // true
  if valor = 'S' then
  begin
    balanca := True;
  end
  else
  begin
    balanca := False;
  end;

  Result := balanca;
end;

function TProduto.getBoolDiversos(valor: string): boolean;
var
  balanca :boolean;
begin
  // true
  if valor = 'S' then
  begin
    balanca := True;
  end
  else
  begin
    balanca := False;
  end;

  Result := balanca;
end;

function TProduto.getBoolFracionado(valor: string): boolean;
var
  balanca :boolean;
begin
  // true
  if valor = 'S' then
  begin
    balanca := True;
  end
  else
  begin
    balanca := False;
  end;

  Result := balanca;
end;

function TProduto.getBoolInativo(valor: string): boolean;
var
  balanca :boolean;
begin
  // true
  if valor = 'N' then
  begin
    balanca := True;
  end
  else
  begin
    balanca := False;
  end;

  Result := balanca;
end;

function TProduto.getCodigo: string;
begin
  Result := FCodigo;
end;

function TProduto.getDescricao: string;
begin
  Result := FDescricao;
end;

function TProduto.getDiversos: integer;
var
  diversos :integer;
begin
  if FDiversos = true then
  begin
    diversos := 1;
  end
  else
  begin
    diversos := 2;
  end;

  Result := diversos;
end;

function TProduto.getFracionado: integer;
var
  fracionado :integer;
begin
  if FFracionado = true then
  begin
    fracionado := 1;
  end
  else
  begin
    fracionado := 2;
  end;

  Result := fracionado;
end;

function TProduto.getInativo: integer;
var
  inativo :integer;
begin
  if FInativo = true then
  begin
    inativo := 1;
  end
  else
  begin
    inativo := 0;
  end;

  Result := inativo;
end;

function TProduto.JsonToProduto(const AJson: string): TProduto;
var
  LJsonObj: TJSONObject;
  LProduto: TProduto;

begin
  Result := nil;

  if AJson = '' then Exit;

  // o json chega escapado corretamente (ParseJsonArray usa ToJSON), entao nao
  // se mexe mais no texto: trocar '\' por espaco quebrava os escapes validos.
  LJsonObj := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
  if not Assigned(LJsonObj) then Exit;

  try
    LProduto := TJson.JsonToObject<TProduto>(AJson);
    try
    LProduto.codigo := ValorTexto(LJsonObj, 'codigo');
    LProduto.CodigoBarras := ValorTexto(LJsonObj, 'codigo_barras');
    // depende do CodigoBarras ja preenchido (ver comentario da property)
    LProduto.CodigosAuxiliares := ValorLista(LJsonObj, 'codigos_barras_auxiliares');
    LProduto.descricao := ValorTexto(LJsonObj, 'descricao');
    LProduto.grupo := ValorTexto(LJsonObj, 'secao');
    LProduto.subgrupo := ValorTexto(LJsonObj, 'grupo');
    LProduto.unidade := ValorTexto(LJsonObj, 'unidade', 'UN');
    LProduto.Fracionado := getBoolFracionado(ValorTexto(LJsonObj, 'forma_venda'));
    LProduto.ncm := ValorTexto(LJsonObj, 'ncm');
    LProduto.cest := ValorTexto(LJsonObj, 'cest');
    LProduto.tributacao := ValorTexto(LJsonObj, 'tributacao', 'F00');
    LProduto.balanca := getBoolBalanca(ValorTexto(LJsonObj, 'balanca'));
    LProduto.Validade := ValorTexto(LJsonObj, 'balanca_validade');
    LProduto.diversos := getBoolDiversos(ValorTexto(LJsonObj, 'diversos'));
    LProduto.Inativo := getBoolInativo(ValorTexto(LJsonObj, 'ativo'));

    // ajustar
//    LProduto.DataCadastro := Iso8601ToDateOnly(LJsonObj.GetValue('created_at').Value);
//    LProduto.DataAlterado := Iso8601ToDateOnly(LJsonObj.GetValue('updated_at').Value);
    LProduto.DataCadastro := now;
    LProduto.DataAlterado := now;

    LProduto.preco := ValorNumero(LJsonObj, 'preco');
    LProduto.Margem := ValorNumero(LJsonObj, 'markup');
    LProduto.custo := ValorNumero(LJsonObj, 'custo');
    LProduto.preco2 := ValorNumero(LJsonObj, 'preco2');
    LProduto.preco2_qtd := ValorNumero(LJsonObj, 'preco2_qtd');
    except
      // setter que valida (codigo de barras, ncm, descricao...) derruba o
      // registro: libera aqui, senao cada produto recusado vaza um TProduto
      LProduto.Free;
      raise;
    end;

    Result := LProduto;
  finally
    LJsonObj.Free;
  end;
end;

procedure TProduto.SetBalanca(const Value: Boolean);
var
  balanca : boolean;
begin
  FBalanca :=Value;
end;

procedure TProduto.SetCEST(const Value: string);
var
  CEST :string;
begin


  if Length(value)> 7 then
  begin
    raise Exception.Create('Limite de 7 caracteres!');
  end;

  CEST := Value;
  CEST := removeLetras(CEST);
  if CEST <> '' then
  begin
  CEST := zeroEsquerda(CEST,7);
  end;


//  free;

  FCEST := CEST;
end;

procedure TProduto.SetCodigo(const Value: string);
var

  Codigo :string;
begin


  if (Value = '')then
  begin
    raise Exception.Create('Código não pode ser em branco!');
  end;
  if Length(value)> 6 then
  begin
    raise Exception.Create('Limite de 6 caracteres!');
  end;

  Codigo := Value;
  Codigo := removeLetras(Codigo);
  Codigo := zeroEsquerda(Codigo,6);

//  free;
  FCodigo := Codigo;
end;

procedure TProduto.SetCodigoBarras(const Value: string);
var

  CodigoBarras : string;
begin


  if (Value = '') then
  begin
    raise Exception.Create('Código de barras não pode ser em branco!');
  end;
  if Length(value)> 14 then
  begin
    raise Exception.Create('Limite de 14 caracteres!');
  end;

  CodigoBarras := Value;
  CodigoBarras := removeLetras(CodigoBarras);
  CodigoBarras := zeroEsquerda(CodigoBarras,14);

//  free;
  FCodigoBarras := CodigoBarras;
end;

// Normaliza a lista de codigos auxiliares no mesmo formato do codigo de barras
// principal (so digitos, 14 posicoes com zero a esquerda), que e como o PDV
// grava e pesquisa em ESTOQUE.COD_BARRA.
// Codigo invalido e descartado em silencio, sem exception: o backend ja valida
// o formato no cadastro, e derrubar o produto inteiro por causa de um auxiliar
// ruim faria a carga perder o produto.
procedure TProduto.SetCodigosAuxiliares(const Value: TArray<string>);
var
  i, j, total: Integer;
  codigo: string;
  repetido: Boolean;
  lista: TArray<string>;
begin
  SetLength(lista, Length(Value));
  total := 0;

  for i := 0 to High(Value) do
  begin
    codigo := removeLetras(Trim(Value[i]));

    // vazio, so letras ou maior que a coluna do PDV
    if (codigo = '') or (Length(codigo) > 14) then
      Continue;

    codigo := zeroEsquerda(codigo, 14);

    // ja vai gravado em ESTOQUE.COD_BARRA
    if codigo = FCodigoBarras then
      Continue;

    repetido := False;
    for j := 0 to total - 1 do
      if lista[j] = codigo then
      begin
        repetido := True;
        Break;
      end;

    if repetido then
      Continue;

    lista[total] := codigo;
    Inc(total);
  end;

  SetLength(lista, total);
  FCodigosAuxiliares := lista;
end;

procedure TProduto.SetCusto(const Value: Real);
var
  Custo : Real;
begin
  Custo := Value;
  if Custo < 0 then
  begin
    raise Exception.Create('Custo não pode ser negativo!');
  end;

  FCusto := Custo;
end;

procedure TProduto.SetDataAlterado(const Value: TDate);
begin
  FDataAlterado := Value;
end;

procedure TProduto.SetDataCadastro(const Value: TDate);
begin
  FDataCadastro := Value;
end;

procedure TProduto.setDescricao(const Value: string);
var
  desc:string;
begin
  desc := value;

  if (desc = '') then
  begin
    raise Exception.Create('Descrição não pode ser em branco!');
  end;
  if Length(desc)>100 then
  begin
    raise Exception.Create('Limite de 100 caracteres!');
  end;
  desc := RemoveAcento(desc);

  FDescricao := desc;
end;



procedure TProduto.SetDiversos(const Value: Boolean);
begin
  FDiversos := Value;
end;

procedure TProduto.SetEstoque(const Value: Real);
begin
  FEstoque := Value;
end;

procedure TProduto.SetestoqueAnterior(const Value: Real);
begin
  FestoqueAnterior := Value;
end;

procedure TProduto.SetestoqueMaximo(const Value: Real);
begin
  if Value < FestoqueMinimo then
  begin
    raise Exception.Create('Estoque máximo não pode ser menor que estoque mínimo');
  end;
  FestoqueMaximo := Value;
end;

procedure TProduto.SetestoqueMinimo(const Value: real);
begin
  if FEstoqueMaximo < value then
  begin
    raise Exception.Create('Estoque mínimo não pode ser maior que estoque máximo');
  end;
  FestoqueMinimo := Value;
end;

procedure TProduto.SetFabricante(const Value: string);
var

  Fabricante :string;
begin

  Fabricante := Value;

  if (Fabricante = '')then
  begin
    Fabricante := '000000';
  end;
  if Length(Fabricante)> 6 then
  begin
    raise Exception.Create('Limite de 6 caracteres!');
  end;


  Fabricante := removeLetras(Fabricante);
  Fabricante := zeroEsquerda(Fabricante,6);

//  free;

  FFabricante := Fabricante;
end;

procedure TProduto.SetFornecedor(const Value: string);
var

  Fornecedor :string;
begin

  Fornecedor := Value;

  if (Fornecedor = '')then
  begin
    Fornecedor := '000000';
  end;
  if Length(Fornecedor)> 6 then
  begin
    raise Exception.Create('Limite de 6 caracteres!');
  end;

  Fornecedor := removeLetras(Fornecedor);
  Fornecedor := zeroEsquerda(Fornecedor,6);

//  free;
  FFornecedor := Fornecedor;
end;

procedure TProduto.SetFracionado(const Value: Boolean);
begin
  FFracionado := Value;
end;

procedure TProduto.SetGrupo(const Value: string);
var
  Grupo :string;
begin

  Grupo := Value;

  if (Grupo = '')then
  begin
    Grupo := '000000';
  end;
  if Length(Grupo)> 6 then
  begin
    raise Exception.Create('Limite de 6 caracteres!');
  end;


  Grupo := removeLetras(Grupo);
  Grupo := zeroEsquerda(Grupo,6);

//  free;
  FGrupo := Grupo;
end;

procedure TProduto.SetInativo(const Value: Boolean);
begin
  FInativo := Value;
end;

procedure TProduto.SetMargem(const Value: Real);
var
  Margem : Real;
begin
  Margem := Value;
  if Margem < 0 then
  begin
    raise Exception.Create('Margem não pode ser negativo!');
  end;

  FMargem := Margem;
end;

procedure TProduto.SetNCM(const Value: string);
var

  NCM :string;
begin


  if (Value = '')then
  begin
    raise Exception.Create('NCM não pode estar em branco!');
  end;
  if Length(value)> 8 then
  begin
    raise Exception.Create('Limite de 8 caracteres!');
  end;

  NCM := Value;
  NCM := removeLetras(NCM);
  NCM := zeroEsquerda(NCM,8);

//  free;

  FNCM := NCM;

end;

procedure TProduto.SetObservacao(const Value: string);
begin
  if Length(value)> 100 then
  begin
    raise Exception.Create('Limite de 100 caracteres!');
  end;
  FObservacao := Value;
end;

procedure TProduto.SetPreco(const Value: Real);
var
  Preco : Real;
begin
  Preco := Value;
//  if Preco <= 0 then
//  begin
//    raise Exception.Create('Preço não pode ser zerado ou negativo!');
//  end;

  FPreco := Preco;
end;

procedure TProduto.SetPreco2(const Value: Real);
begin
  FPreco2 := Value;
end;

procedure TProduto.SetPreco2_Qtd(const Value: real);
begin
  FPreco2_Qtd := Value;
end;

procedure TProduto.SetSubgrupo(const Value: string);
var

  Subgrupo :string;
begin

  Subgrupo := Value;

  if (Subgrupo = '')then
  begin
    Subgrupo := '000000';
  end;
  if Length(Subgrupo)> 6 then
  begin
    raise Exception.Create('Limite de 6 caracteres!');
  end;


  Subgrupo := removeLetras(Subgrupo);
  Subgrupo := zeroEsquerda(Subgrupo,6);

//  free;
  FSubgrupo := Subgrupo;
end;


procedure TProduto.SetTributacao(const Value: String);
begin
  if Value = '' then
  begin
    raise Exception.Create('Tributação não pode ser vazia');
  end;
  if Length(value) > 3 then
  begin
    raise Exception.Create('Tributação não pode ter mais que 3 letras');
  end;

  FTributacao := Value;
end;

procedure TProduto.SetUnidade(const Value: string);
begin
  if Value = '' then
  begin
    raise Exception.Create('Unidade não pode ser vazia');
  end;
  if Length(value) > 2 then
  begin
    raise Exception.Create('Unidade não pode ter mais que 2 letras');
  end;

  FUnidade := Value;
end;

procedure TProduto.SetValidade(const Value: string);
var

  Validade :string;
begin


  if Length(value)> 3 then
  begin
    raise Exception.Create('Limite de 3 caracteres! Colocar quantidade de dias EX: Ira vencer em 3 dias = 3');
  end;
  Validade := Value;
  Validade := removeLetras(Validade);

//  Free;
  FValidade := Validade;
end;


end.

