unit Classe.Cupom;

interface
uses System.Classes, VCL.Dialogs,Classe.Consumidor,System.SysUtils,Classe.Produto,pcnConversao,
  System.Generics.Collections,System.Contnrs,Classe.Funcoes,ACBrUtil;

  type

  TCupom = class;

  TDetCrediario = class;

  TCupomItem =class;
  TCupomForma = class;
  TCupomConsumidor = class(TConsumidor);
  TCupomTributacao = class;
  TCupomCrediario = class;



  TCupom = class(TObject)
  private
    FCrediario: TCupomCrediario;
    Fvalor_total_cupom: real;
    Fhora_cupom: TDateTime;
    Freimpressao_cupom: integer;
    FXML_TELA_cupom: integer;
    Fcancelado_cupom: integer;
    Fcliente_cupom: integer;
    Fqtd_item_cupom: integer;
    Fcodigo_cupom: string;
    FCOMPARTILHADO_cupom: integer;
    Fcaixa_cupom: integer;
    Fvendedor_cupom: integer;
    Fnuvem_cupom: integer;
    Fnumero_cupom: string;
    FXML_CFE_cupom: STRING;

    FConsumidor: TCupomConsumidor;
    FForma: TCupomForma;
    Fvalor_produto_cupom: real;
    Fcupom_aberto_cancelamento_cupom: integer;
    Fccf_cupom: string;
    Fvalor_acrescimo_cupom: real;
    Fvalor_desconto_cupom: real;
    Fdata_cupom: TDate;
    FSAT_cupom: integer;
    Fex_cupom: integer;
    FCFE_CANCELADO_cupom: integer;

    FListaItem : array[1..999] of TCupomItem;
    FListaFinalizacao: array[1..100] of TCupomForma;
    FListaContasReceber : array[1..999] of TCupomCrediario;
    Fxml_chave_cupom: string;
    Fxml_chave_cancelamento_cupom: string;
    Fvalor_custo_total: Real;


    procedure Setcaixa_cupom(const Value: integer);
    procedure Setcancelado_cupom(const Value: integer);
    procedure Setccf_cupom(const Value: string);
    procedure SetCFE_CANCELADO_cupom(const Value: integer);
    procedure Setcliente_cupom(const Value: integer);
    procedure Setcodigo_cupom(const Value: string);
    procedure SetCOMPARTILHADO_cupom(const Value: integer);
    procedure SetConsumidor(const Value: TCupomConsumidor);
    procedure SetCrediario(const Value: TCupomCrediario);
    procedure Setcupom_aberto_cancelamento_cupom(const Value: integer);
    procedure Setdata_cupom(const Value: TDate);
    procedure Setex_cupom(const Value: integer);
    procedure SetForma(const Value: TCupomForma);
    procedure Sethora_cupom(const Value: TDateTime);
    procedure Setnumero_cupom(const Value: string);
    procedure Setnuvem_cupom(const Value: integer);
    procedure Setqtd_item_cupom(const Value: integer);
    procedure Setreimpressao_cupom(const Value: integer);
    procedure SetSAT_cupom(const Value: integer);
    procedure Setvalor_acrescimo_cupom(const Value: real);
    procedure Setvalor_desconto_cupom(const Value: real);

    procedure Setvalor_produto_cupom(const Value: real);
    procedure Setvalor_total_cupom(const Value: real);

    procedure Setvendedor_cupom(const Value: integer);
    procedure SetXML_CFE_cupom(const Value: STRING);
    procedure SetXML_TELA_cupom(const Value: integer);

    function GetListaItem(AIndex: Integer): TCupomItem;
    procedure SetListaItem(AIndex: Integer; const Value: TCupomItem);
    function GetListaFinalizacao(AIndex: Integer): TCupomForma;
    procedure SetListaFinalizacao(AIndex: Integer; const Value: TCupomForma);
    procedure Setxml_chave_cupom(const Value: string);
    procedure Setxml_chave_cancelamento_cupom(const Value: string);
    function GetListaContasReceber(AIndex: integer): TCupomCrediario;
    procedure SetListaContasReceber(AIndex: integer;
      const Value: TCupomCrediario);
    procedure Setvalor_custo_total(const Value: Real);

  public
  property codigo_cupom:string read Fcodigo_cupom write Setcodigo_cupom;
  property numero_cupom:string read Fnumero_cupom write Setnumero_cupom;
  property data_cupom:TDate read Fdata_cupom write Setdata_cupom;
  property hora_cupom:TDateTime read Fhora_cupom write Sethora_cupom;
  property qtd_item_cupom:integer read Fqtd_item_cupom write Setqtd_item_cupom;
  property valor_desconto_cupom:real read Fvalor_desconto_cupom write Setvalor_desconto_cupom;
  property valor_acrescimo_cupom:real read Fvalor_acrescimo_cupom write Setvalor_acrescimo_cupom;
  property valor_total_cupom:real read Fvalor_total_cupom write Setvalor_total_cupom;
  property valor_custo_total:Real read Fvalor_custo_total write Setvalor_custo_total;


  property cliente_cupom:integer read Fcliente_cupom write Setcliente_cupom;
  property cancelado_cupom:integer read Fcancelado_cupom write Setcancelado_cupom;
  property vendedor_cupom:integer read Fvendedor_cupom write Setvendedor_cupom;
  property ex_cupom:integer read Fex_cupom write Setex_cupom;
  property caixa_cupom:integer read Fcaixa_cupom write Setcaixa_cupom;
  property nuvem_cupom:integer read Fnuvem_cupom write Setnuvem_cupom;
  PROPERTY xml_chave_cupom:string read Fxml_chave_cupom write Setxml_chave_cupom;
  PROPERTY xml_chave_cancelamento_cupom:string read Fxml_chave_cancelamento_cupom write Setxml_chave_cancelamento_cupom;

  property Consumidor :TCupomConsumidor read FConsumidor write SetConsumidor;
  property Crediario :TCupomCrediario read FCrediario write SetCrediario;

  property ListaItem[AIndex:Integer] :TCupomItem read GetListaItem write SetListaItem;
  property ListaFinalizacao[AIndex:Integer] :TCupomForma read GetListaFinalizacao write SetListaFinalizacao;
  property ListaContasReceber[AIndex:integer]:TCupomCrediario read GetListaContasReceber write SetListaContasReceber;

  function countListaItem:Integer;
  function countListaFinalizacao:Integer;
  function countListaContasReceber:integer;


  constructor Create;
  destructor destroy;override;



  end;


 // ITEM DO CUPOM
  TCupomItem = class(TCupom)
    private
    FProduto: TProduto;
    Fvalor_acrescimo_item: real;
    Fvalor_desconto_item: real;
    Fex_item: integer;
    Fcodigo_produto_item: string;
    Fvalor_unitario_item: Real;
    Fvalor_total_item: real;
    Fcodigo_cupom_item: string;
    Fcancelado_item: integer;
    Fcodigo_item: string;
    FTributacao: TCupomTributacao;
    Fqtde_item: real;
    FItem_item: integer;
    Funidade_item: string;
    Fcodigo_barras_item: string;
    Fvalor_movimentacao_item: real;
    Fvalor_custo: real;
    Fvalor_custo_total: real;
    Fdata_item: TDate;
    Fmotivo_cancelamento: string;

    procedure Setcancelado_item(const Value: integer);
    procedure Setcodigo_cupom_item(const Value: string);
    procedure Setcodigo_item(const Value: string);
    procedure Setcodigo_produto_item(const Value: string);
    procedure Setex_item(const Value: integer);
    procedure SetItem_item(const Value: integer);
    procedure SetProduto(const Value: TProduto);
    procedure Setqtde_item(const Value: real);
    procedure SetTributacao(const Value: TCupomTributacao);
    procedure Setunidade_item(const Value: string);
    procedure Setvalor_acrescimo_item(const Value: real);
    procedure Setvalor_desconto_item(const Value: real);
    procedure Setvalor_total_item(const Value: real);
    procedure Setvalor_unitario_item(const Value: Real);
    procedure Setcodigo_barras_item(const Value: string);
    procedure Setvalor_movimentacao_item(const Value: real);
    procedure Setvalor_custo(const Value: real);
    procedure Setvalor_custo_total(const Value: real);
    procedure Setdata_item(const Value: TDate);
    procedure Setmotivo_cancelamento(const Value: string);

    public
    property codigo_item:string read Fcodigo_item write Setcodigo_item;
    property codigo_cupom_item:string read Fcodigo_cupom_item write Setcodigo_cupom_item;
    property codigo_barras_item:string read Fcodigo_barras_item write Setcodigo_barras_item;
    property codigo_produto_item:string read Fcodigo_produto_item write Setcodigo_produto_item;
    property Item_item:integer read FItem_item write SetItem_item;
    property unidade_item:string read Funidade_item write Setunidade_item;
    property qtde_item:real read Fqtde_item write Setqtde_item;
    property valor_unitario_item:Real read Fvalor_unitario_item write Setvalor_unitario_item;
    property valor_desconto_item:real read Fvalor_desconto_item write Setvalor_desconto_item;
    property valor_acrescimo_item:real read Fvalor_acrescimo_item write Setvalor_acrescimo_item;
    property valor_total_item:real read Fvalor_total_item write Setvalor_total_item;
    property valor_movimentacao_item:real read Fvalor_movimentacao_item write Setvalor_movimentacao_item;
    property valor_custo:real read Fvalor_custo write Setvalor_custo;
    property valor_custo_total:real read Fvalor_custo_total write Setvalor_custo_total;
    property data_item:TDate read Fdata_item write Setdata_item;
    property motivo_cancelamento:string read Fmotivo_cancelamento write Setmotivo_cancelamento;

    property cancelado_item:integer read Fcancelado_item write Setcancelado_item;
    property ex_item:integer read Fex_item write Setex_item;

    property Produto: TProduto read FProduto write SetProduto;
    property Tributacao:TCupomTributacao read FTributacao write SetTributacao;


    constructor create;
    destructor destroy;override;
  end;

  // CUPOM FORMA
  TCupomForma = class(TObject)
    private
    Fvalor: real;
    Fcodigo: string;
    Fprestacao: integer;
    Fforma: string;
    Ftipo: string;
    Fex: integer;
    Fvalor_troco: real;
    Fdata_forma: TDate;
    Fcaixa_forma: integer;
    Fcancelado: integer;
    Fcodigo_cupom: string;

    procedure Setcodigo(const Value: string);
    procedure Setex(const Value: integer);
    procedure Setforma(const Value: string);
    procedure Setprestacao(const Value: integer);
    procedure Settipo(const Value: string);
    procedure Setvalor(const Value: real);
    procedure Setvalor_troco(const Value: real);
    procedure Setcaixa_forma(const Value: integer);
    procedure Setdata_forma(const Value: TDate);
    procedure Setcancelado(const Value: integer);
    procedure Setcodigo_cupom(const Value: string);

    public
    property codigo :string read Fcodigo write Setcodigo;
    property forma :string read Fforma write Setforma;
    property valor :real read Fvalor write Setvalor;
    property prestacao :integer read Fprestacao write Setprestacao;
    property tipo :string read Ftipo write Settipo;
    property ex :integer read Fex write Setex;
    property valor_troco:real read Fvalor_troco write Setvalor_troco;
    property caixa_forma:integer read Fcaixa_forma write Setcaixa_forma;
    property data_forma:TDate read Fdata_forma write Setdata_forma;
    property cancelado:integer read Fcancelado write Setcancelado;
    property codigo_cupom:string read Fcodigo_cupom write Setcodigo_cupom;


    constructor Create;
    destructor destroy;override;

  end;


  TCupomTributacao = class(TObject)
    private
    FCST: TpcnCSTIcms;
    procedure SetCST(const Value: TpcnCSTIcms);


    public
    property CST: TpcnCSTIcms read FCST write SetCST;


  end;

  TDetCrediario = class(TObjectList)
  private
    function GetForma(Index: Integer): TCupomCrediario;
    procedure SetForma(Index: Integer; Value: TCupomCrediario);
  public
    function Add: TCupomCrediario; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a função New'{$EndIf};
    function New: TCupomCrediario;
    property Items[Index: Integer]: TCupomCrediario read GetForma write SetForma; default;
  end;

  TCupomCrediario = class(TObject)
  private
    FValor: Real;
    FHora: TDateTime;
    FDescricao: string;
    FCliente: string;
    FVencimento: TDate;
    FNumero: string;
    Fprestacao: integer;
    FData: Tdate;
    FEx: Integer;
    Fdet: TDetCrediario;
    Fcodigo: string;
    procedure SetCliente(const Value: string);
    procedure SetData(const Value: Tdate);
    procedure SetDescricao(const Value: string);
    procedure SetEx(const Value: Integer);
    procedure SetHora(const Value: TDateTime);
    procedure SetNumero(const Value: string);
    procedure Setprestacao(const Value: integer);
    procedure SetValor(const Value: Real);
    procedure SetVencimento(const Value: TDate);
    procedure Setdet(const Value: TDetCrediario);
    procedure Setcodigo(const Value: string);
  public
  property codigo:string read Fcodigo write Setcodigo;
  property Data:Tdate read FData write SetData;
  property Hora:TDateTime read FHora write SetHora;
  property Cliente:string read FCliente write SetCliente;
  property Vencimento:TDate read FVencimento write SetVencimento;
  property Valor:Real read FValor write SetValor;
  property Descricao:string read FDescricao write SetDescricao;
  property Ex:Integer read FEx write SetEx;
  property prestacao:integer read Fprestacao write Setprestacao;
  property Numero:string read FNumero write SetNumero;
  property det :TDetCrediario read Fdet write Setdet;

  constructor create;
  destructor destroy;override;


  end;




implementation
{ TCupom }




function TCupom.countListaContasReceber: integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(FListaContasReceber) to High(FListaContasReceber) do
    if FListaContasReceber[I] <> nil then
      Inc(Result);
end;

function TCupom.countListaFinalizacao: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(FListaFinalizacao) to High(FListaFinalizacao) do
    if FListaFinalizacao[I] <> nil then
      Inc(Result);
end;

function TCupom.countListaItem: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(FListaItem) to High(FListaItem) do
    if FListaItem[I] <> nil then
      Inc(Result);
end;

constructor TCupom.Create;
begin
Consumidor := TCupomConsumidor.create;
//Crediario := TCupomCrediario.Create;
end;



destructor TCupom.destroy;
begin
  FreeAndNil(FConsumidor);
  inherited;
end;





function TCupom.GetListaContasReceber(AIndex: integer): TCupomCrediario;
begin
Result := FListaContasReceber[AIndex];
end;

function TCupom.GetListaFinalizacao(AIndex: Integer): TCupomForma;
begin
Result := FListaFinalizacao[AIndex];
end;

function TCupom.GetListaItem(AIndex: Integer): TCupomItem;
begin
Result := FListaItem[AIndex];
end;

procedure TCupom.Setcaixa_cupom(const Value: integer);
begin
  Fcaixa_cupom := Value;
end;

procedure TCupom.Setcancelado_cupom(const Value: integer);
begin
  Fcancelado_cupom := Value;
end;

procedure TCupom.Setccf_cupom(const Value: string);
begin
  Fccf_cupom := Value;
end;

procedure TCupom.SetCFE_CANCELADO_cupom(const Value: integer);
begin
  FCFE_CANCELADO_cupom := Value;
end;

procedure TCupom.Setcliente_cupom(const Value: integer);
begin
  Fcliente_cupom := Value;
end;

procedure TCupom.Setcodigo_cupom(const Value: string);
begin
  Fcodigo_cupom := Value;
end;

procedure TCupom.SetCOMPARTILHADO_cupom(const Value: integer);
begin
  FCOMPARTILHADO_cupom := Value;
end;

procedure TCupom.SetConsumidor(const Value: TCupomConsumidor);
begin
  FConsumidor := Value;
end;

procedure TCupom.SetCrediario(const Value: TCupomCrediario);
begin
  FCrediario := Value;
end;

procedure TCupom.Setcupom_aberto_cancelamento_cupom(const Value: integer);
begin
  Fcupom_aberto_cancelamento_cupom := Value;
end;

procedure TCupom.Setdata_cupom(const Value: TDate);
begin
  Fdata_cupom := Value;
end;

procedure TCupom.Setex_cupom(const Value: integer);
begin
  Fex_cupom := Value;
end;

procedure TCupom.SetForma(const Value: TCupomForma);
begin
  FForma := Value;
end;

procedure TCupom.Sethora_cupom(const Value: TDateTime);
begin
  Fhora_cupom := Value;
end;

procedure TCupom.SetListaContasReceber(AIndex: integer;
  const Value: TCupomCrediario);
begin
FListaContasReceber[AIndex] := Value;
end;

procedure TCupom.SetListaFinalizacao(AIndex: Integer; const Value: TCupomForma);
begin
FListaFinalizacao[AIndex] := Value;
end;

procedure TCupom.SetListaItem(AIndex: Integer; const Value: TCupomItem);
begin
FListaItem[AIndex] := Value;
end;

procedure TCupom.Setnumero_cupom(const Value: string);
begin
  Fcodigo_cupom := codifica_cupom(Value);
  Fnumero_cupom := Value;
end;

procedure TCupom.Setnuvem_cupom(const Value: integer);
begin
  Fnuvem_cupom := Value;
end;

procedure TCupom.Setqtd_item_cupom(const Value: integer);
begin
//  if Value <= 0 then
//  begin
//    raise Exception.Create('Quantidade de itens não pode ser zerada');
//  end;
  Fqtd_item_cupom := Value;
end;

procedure TCupom.Setreimpressao_cupom(const Value: integer);
begin
  Freimpressao_cupom := Value;
end;

procedure TCupom.SetSAT_cupom(const Value: integer);
begin
  FSAT_cupom := Value;
end;

procedure TCupom.Setvalor_acrescimo_cupom(const Value: real);
begin
  Fvalor_acrescimo_cupom := Value;
end;

procedure TCupom.Setvalor_custo_total(const Value: Real);
begin
  Fvalor_custo_total := Value;
end;

procedure TCupom.Setvalor_desconto_cupom(const Value: real);
begin
  Fvalor_desconto_cupom := Value;
end;

procedure TCupom.Setvalor_produto_cupom(const Value: real);
begin
  Fvalor_produto_cupom := Value;
end;

procedure TCupom.Setvalor_total_cupom(const Value: real);
var
  vlr:Real;
begin
vlr := Value;
vlr := RoundABNT(Value,2);
  Fvalor_total_cupom := vlr;
end;

procedure TCupom.Setvendedor_cupom(const Value: integer);
begin
  Fvendedor_cupom := Value;
end;

procedure TCupom.SetXML_CFE_cupom(const Value: STRING);
begin
  FXML_CFE_cupom := Value;
end;

procedure TCupom.Setxml_chave_cancelamento_cupom(const Value: string);
begin
  Fxml_chave_cancelamento_cupom := Value;
end;

procedure TCupom.Setxml_chave_cupom(const Value: string);
begin
  Fxml_chave_cupom := Value;
end;

procedure TCupom.SetXML_TELA_cupom(const Value: integer);
begin
  FXML_TELA_cupom := Value;
end;

{ TCupomItem }

constructor TCupomItem.create;
begin
FProduto := TProduto.create;
end;

destructor TCupomItem.destroy;
begin
FreeAndNil(FProduto);
  inherited;
end;


procedure TCupomItem.Setcancelado_item(const Value: integer);
begin
  Fcancelado_item := Value;
end;

procedure TCupomItem.Setcodigo_barras_item(const Value: string);
var
  Codigo:string;
  iPosicao:integer;
  sErro:string;
begin
  codigo := value;
    // verifica se quantidade nao esta setada no registra item
//    if Fqtde_item = 0 then
//    begin
      // verifica se contem multiplicação no código de barras
      if (pos('X', ansiuppercase(codigo)) > 0) or(pos('*', ansiuppercase(codigo)) > 0) then
      begin
        iPosicao := pos('X', ansiuppercase(codigo));
        if iPosicao = 0 then
          iPosicao := pos('*', ansiuppercase(codigo));
        try
          // alimenta a varivel de qtde
          Fqtde_item := Strtofloat(copy(codigo, 1, iPosicao - 1));
          // copia apenas a parte que contem a informacao da busca do produto
          codigo := copy(codigo, iPosicao + 1, 99);
        except
          // retornou erro, zera a qtde e deixa a referencia como estah.
          Fqtde_item := 1;
        end;

      end
      else
      begin
          // se não tiver multiplicação
          Fqtde_item := 1;
          // balanca

      end;
//    end;
    // carrega produto
  Codigo := Trim(codigo);
  Codigo := removeLetras(Codigo);
  Codigo := zeroEsquerda(Codigo,14);
  FProduto.codigoBarras := Codigo;
  Fcodigo_barras_item := Codigo;
end;

procedure TCupomItem.Setcodigo_cupom_item(const Value: string);
begin
  Fcodigo_cupom_item := Value;
end;

procedure TCupomItem.Setcodigo_item(const Value: string);
begin
  Fcodigo_item := Value;
end;

procedure TCupomItem.Setcodigo_produto_item(const Value: string);
begin
  Fcodigo_produto_item := Value;
end;


procedure TCupomItem.Setdata_item(const Value: TDate);
begin
  Fdata_item := Value;
end;

procedure TCupomItem.Setex_item(const Value: integer);
begin
  Fex_item := Value;
end;

procedure TCupomItem.SetItem_item(const Value: integer);
begin
  FItem_item := Value;
end;

procedure TCupomItem.Setmotivo_cancelamento(const Value: string);
begin
  Fmotivo_cancelamento := Value;
end;

procedure TCupomItem.SetProduto(const Value: TProduto);
begin
  FProduto := Value;
end;

procedure TCupomItem.Setqtde_item(const Value: real);
begin
//  if value <= 0 then
//  begin
//    raise Exception.Create('Peso não pode ser zerado ou negativo');
//  end;
  Fqtde_item := Value;
end;

procedure TCupomItem.SetTributacao(const Value: TCupomTributacao);
begin
  FTributacao := Value;
end;

procedure TCupomItem.Setunidade_item(const Value: string);
begin
  Funidade_item := Value;
end;

procedure TCupomItem.Setvalor_acrescimo_item(const Value: real);
begin
  Fvalor_acrescimo_item := Value;
end;

procedure TCupomItem.Setvalor_custo(const Value: real);
begin
  Fvalor_custo := Value;
end;

procedure TCupomItem.Setvalor_custo_total(const Value: real);
begin
  Fvalor_custo_total := Value;
end;

procedure TCupomItem.Setvalor_desconto_item(const Value: real);
var
  Valor:real;
begin
  valor := Value;
  if Valor < 0 then
  begin
    ShowMessage('Valor não pode ser negativo');
    Valor := 0;
  end;

  Fvalor_desconto_item := valor;
end;


procedure TCupomItem.Setvalor_movimentacao_item(const Value: real);
begin
  Fvalor_movimentacao_item := Value;
end;

procedure TCupomItem.Setvalor_total_item(const Value: real);
begin
  Fvalor_total_item := RoundABNT(Value,2);
end;

procedure TCupomItem.Setvalor_unitario_item(const Value: Real);
begin
  Fvalor_unitario_item := Value;
end;

{ TCupomForma }

constructor TCupomForma.Create;
begin
end;

destructor TCupomForma.destroy;
begin
  inherited;
end;

procedure TCupomForma.Setcaixa_forma(const Value: integer);
begin
  Fcaixa_forma := Value;
end;

procedure TCupomForma.Setcancelado(const Value: integer);
begin
  Fcancelado := Value;
end;

procedure TCupomForma.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;



procedure TCupomForma.Setcodigo_cupom(const Value: string);
begin
  Fcodigo_cupom := Value;
end;

procedure TCupomForma.Setdata_forma(const Value: TDate);
begin
  Fdata_forma := Value;
end;

procedure TCupomForma.Setex(const Value: integer);
begin
  Fex := Value;
end;

procedure TCupomForma.Setforma(const Value: string);
begin
  Fforma := Value;
end;

procedure TCupomForma.Setprestacao(const Value: integer);
begin
  Fprestacao := Value;
end;

procedure TCupomForma.Settipo(const Value: string);
begin
  Ftipo := Value;
end;

procedure TCupomForma.Setvalor(const Value: real);
begin
  Fvalor := Value;
end;


procedure TCupomForma.Setvalor_troco(const Value: real);
var
vlrTroco:real;
begin
  vlrTroco := Value;
  if vlrTroco < 0 then
  begin
    vlrTroco := 0;
  end;
  Fvalor_troco := vlrTroco;
end;

{ TCupomTributacao }

procedure TCupomTributacao.SetCST(const Value: TpcnCSTIcms);
begin
  FCST := Value;
end;

{ TCupomCrediario }

constructor TCupomCrediario.create;
begin
  det := TDetCrediario.create;
end;

destructor TCupomCrediario.destroy;
begin
  FreeAndNil(FDet);
  inherited;
end;

procedure TCupomCrediario.SetCliente(const Value: string);
var
  codigo:string;
begin
  codigo := Value;
  codigo := zeroEsquerda(codigo,6);
  FCliente :=codigo;
end;

procedure TCupomCrediario.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TCupomCrediario.SetData(const Value: Tdate);
begin
  FData := Value;
end;

procedure TCupomCrediario.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TCupomCrediario.Setdet(const Value: TDetCrediario);
begin
  Fdet := Value;
end;

procedure TCupomCrediario.SetEx(const Value: Integer);
begin
  FEx := Value;
end;

procedure TCupomCrediario.SetHora(const Value: TDateTime);
begin
  FHora := Value;
end;

procedure TCupomCrediario.SetNumero(const Value: string);
begin
  FNumero := Value;
end;

procedure TCupomCrediario.Setprestacao(const Value: integer);
begin
  Fprestacao := Value;
end;

procedure TCupomCrediario.SetValor(const Value: Real);
begin
  FValor := Value;
end;

procedure TCupomCrediario.SetVencimento(const Value: TDate);
begin
  FVencimento := Value;
end;

{ TDetCrediario }

function TDetCrediario.Add: TCupomCrediario;
begin
   Result := Self.New;
end;

function TDetCrediario.GetForma(Index: Integer): TCupomCrediario;
begin
  Result := TCupomCrediario(inherited GetItem(Index));
end;

function TDetCrediario.New: TCupomCrediario;
begin
   Result := TCupomCrediario.Create;
  Self.Add(Result);
end;

procedure TDetCrediario.SetForma(Index: Integer; Value: TCupomCrediario);
begin
  inherited SetItem(Index, Value);
end;

end.
