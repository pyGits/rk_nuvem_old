unit Classe.Fornecedor;

interface
uses Classe.Funcoes,Classe.Pessoa,Classe.Endereco;

type TFornecedor = class
  private
    Fcodigo: string;
    Fnome: string;
    FPessoa: TPessoa;
    FEndereco: TEndereco;
    FObservacao: string;
    FIM: string;
    FContato2: string;
    FIE: string;
    FContato1: string;
    procedure Setcodigo(const Value: string);
    procedure Setnome(const Value: string);
    procedure SetEndereco(const Value: TEndereco);
    procedure SetPessoa(const Value: TPessoa);
    procedure SetContato1(const Value: string);
    procedure SetContato2(const Value: string);
    procedure SetIE(const Value: string);
    procedure SetIM(const Value: string);
    procedure SetObservacao(const Value: string);
  public
  constructor create;
  destructor destroy;override;
  property codigo : string read Fcodigo write Setcodigo;
  property Pessoa :TPessoa read FPessoa write SetPessoa;
  property Endereco:TEndereco read FEndereco write SetEndereco;
  property IE:string read FIE write SetIE;
  property IM:string read FIM write SetIM;
  property Observacao:string read FObservacao write SetObservacao;
  property Contato1:string read FContato1 write SetContato1;
  property Contato2:string read FContato2 write SetContato2;

end;

implementation

{ TFornecedor }

constructor TFornecedor.create;
begin
  Pessoa := TPessoa.Create;
  Endereco := TEndereco.Create;
end;

destructor TFornecedor.destroy;
begin
  Pessoa.Destroy;
  Endereco.Destroy;
  inherited;
end;

procedure TFornecedor.Setcodigo(const Value: string);
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

procedure TFornecedor.SetContato1(const Value: string);
begin
  FContato1 := Value;
end;

procedure TFornecedor.SetContato2(const Value: string);
begin
  FContato2 := Value;
end;

procedure TFornecedor.SetEndereco(const Value: TEndereco);
begin
  FEndereco := Value;
end;

procedure TFornecedor.SetIE(const Value: string);
begin
  FIE := Value;
end;

procedure TFornecedor.SetIM(const Value: string);
begin
  FIM := Value;
end;

procedure TFornecedor.Setnome(const Value: string);
begin
  Fnome := Value;
end;

procedure TFornecedor.SetObservacao(const Value: string);
begin
  FObservacao := Value;
end;

procedure TFornecedor.SetPessoa(const Value: TPessoa);
begin
  FPessoa := Value;
end;

end.
