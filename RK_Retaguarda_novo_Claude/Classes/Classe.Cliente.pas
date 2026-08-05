unit Classe.Cliente;

interface
uses Classe.Funcoes,Classe.Pessoa,Classe.Endereco,System.SysUtils,system.DateUtils;

type TCliente = class
  private
    Fcodigo: string;
    FPessoa: TPessoa;
    FEndereco: TEndereco;
    FObservacao: string;
    FDataCadastro: TDate;
    FLimiteCredito: real;
    FUtilizadoCredito: Real;
    FDataNascimento: TDate;
    FUtilizaPreco2: boolean;
    FPercDesconto: real;

    procedure Setcodigo(const Value: string);
    procedure SetPessoa(const Value: TPessoa);
    procedure SetEndereco(const Value: TEndereco);
    procedure SetDataCadastro(const Value: TDate);
    procedure SetObservacao(const Value: string);
    procedure SetLimiteCredito(const Value: real);
    procedure SetUtilizadoCredito(const Value: Real);
    procedure SetUtilizaPreco2(const Value: boolean);
    procedure SetPercDesconto(const Value: real);


  public
  constructor create;
  destructor destroy;override;
  property codigo : string read Fcodigo write Setcodigo;
  property Pessoa :TPessoa read FPessoa write SetPessoa;
  property Endereco :TEndereco read FEndereco write SetEndereco;
  property Observacao:string read FObservacao write SetObservacao;
  property DataCadastro:TDate read FDataCadastro write SetDataCadastro;
  property LimiteCredito:real read FLimiteCredito write SetLimiteCredito;
  property UtilizadoCredito:Real read FUtilizadoCredito write SetUtilizadoCredito;
  property UtilizaPreco2:boolean read FUtilizaPreco2 write SetUtilizaPreco2;
  property PercDesconto:real read FPercDesconto write SetPercDesconto;





end;

implementation

{ TCliente }

constructor TCliente.create;
begin
  Pessoa := TPessoa.Create;
  Endereco := TEndereco.Create;
  FUtilizadoCredito :=0;
end;

destructor TCliente.destroy;
begin
  Pessoa.Destroy;
  Endereco.Destroy;
  inherited;
end;

procedure TCliente.Setcodigo(const Value: string);
var

  codigo : string;
begin

  if (Value = '') or (Value = '000000') then
  begin
    CODIGO := '000000';
  end;

  codigo := zeroEsquerda(Value,6);

  Fcodigo := Codigo;
end;

procedure TCliente.SetDataCadastro(const Value: TDate);
begin
  FDataCadastro := Value;
end;



procedure TCliente.SetEndereco(const Value: TEndereco);
begin
  FEndereco := Value;
end;

procedure TCliente.SetLimiteCredito(const Value: real);
begin
  if Value < 0 then
  begin
    raise Exception.Create('Valor n�o pode ser negativo');
  end;
  FLimiteCredito := Value;
end;

procedure TCliente.SetObservacao(const Value: string);
begin
  FObservacao := Value;
end;

procedure TCliente.SetPessoa(const Value: TPessoa);
begin
  FPessoa := Value;
end;

procedure TCliente.SetUtilizadoCredito(const Value: Real);
begin
  FUtilizadoCredito := Value;
end;

procedure TCliente.SetUtilizaPreco2(const Value: boolean);
begin
  FUtilizaPreco2 := Value;
end;

procedure TCliente.SetPercDesconto(const Value: real);
begin
  FPercDesconto := Value;
end;

end.
