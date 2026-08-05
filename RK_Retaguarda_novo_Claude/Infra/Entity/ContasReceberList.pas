unit ContasReceberList;

interface

uses
  System.Generics.Collections, ContasReceber;

type
  TContasReceberList = class
  private
    FItems: TList<TContasReceber>; // Lista interna de contas a receber
    function GetItems: TList<TContasReceber>; // Getter para a propriedade Items
  public
    constructor Create; // Constructor para inicializar a lista internamente
    destructor Destroy; override; // Destructor para liberar a memória da lista

    procedure Add(contaReceber: TContasReceber); // Método para adicionar uma conta
    procedure lancarPagamento(vlrPagamento,vlrDesconto,vlrAcrescimo:real;formaPagamento:string);

    function qtdItems:integer;
    property Items: TList<TContasReceber> read GetItems;
  end;

implementation

{ TContasReceberList }

constructor TContasReceberList.Create;
begin
  inherited Create; // Chama o constructor da classe ancestral
  FItems := TList<TContasReceber>.Create; // Inicializa a lista internamente
end;

destructor TContasReceberList.Destroy;
begin
  FItems.Free; // Libera a memória da lista
  inherited Destroy; // Chama o destructor da classe ancestral
end;

procedure TContasReceberList.Add(contaReceber: TContasReceber);
begin
  FItems.Add(contaReceber); // Adiciona uma conta à lista
end;

function TContasReceberList.GetItems: TList<TContasReceber>;
begin
  Result := FItems; // Retorna a lista interna
end;

procedure TContasReceberList.lancarPagamento(vlrPagamento, vlrDesconto,
  vlrAcrescimo: real; formaPagamento: string);
var
  contaReceber: TContasReceber;
  desconto: real;
  acrescimo: real;
  restante: real;
begin
  desconto := vlrDesconto / qtdItems;
  acrescimo := vlrAcrescimo / qtdItems;
  restante := vlrPagamento; // Valor total disponível para pagamento

  for contaReceber in FItems do
  begin
    if (contaReceber.cancelado = 0) and(contaReceber.valor_restante > 0) and (restante > 0) then
    begin
      contaReceber.valor_desconto := desconto;
      contaReceber.valor_acrescimo := acrescimo;

      // Calcula o valor real a ser pago nesta conta
      if restante >= contaReceber.valor then
      begin
        contaReceber.valor_pago := contaReceber.valor;
        restante := restante - contaReceber.valor;
        contaReceber.valor_parcela := contaReceber.valor_restante;
      end
      else
      begin
        contaReceber.valor_pago := contaReceber.valor_pago + restante;
        contaReceber.valor_parcela := restante;
        restante := 0; // Todo o pagamento foi utilizado
      end;

      // Atualiza o valor restante da conta
      contaReceber.valor_restante := (((contaReceber.valor - contaReceber.valor_desconto)
                                      + contaReceber.valor_acrescimo)
                                      - contaReceber.valor_pago);
    end;

end;
end;

function TContasReceberList.qtdItems: integer;
var
  contaReceber:TContasReceber;
begin
result := 0;
for contaReceber in FItems do
begin
  if contaReceber.cancelado = 0 then
  begin
    result := result +1;
  end;

end;

end;

end.
