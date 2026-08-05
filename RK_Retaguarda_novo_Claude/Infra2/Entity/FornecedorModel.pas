unit FornecedorModel;

interface

type
  TFornecedorModel = class
  private
    FObservacao: string;
    FEmail: string;
    FBairro: string;
    FIM: string;
    FUF: string;
    FCodigo: string;
    FContato2: string;
    FCNPJCPF: string;
    FCEP: string;
    FIE: string;
    FNumero: string;
    FContato1: string;
    FTelefone2: string;
    FComplemento: string;
    FTelefone1: string;
    FNome: string;
    FCidade: string;
    FEndereco: string;
    FNomeFantasia: string;
    FCelular: string;
    procedure SetBairro(const Value: string);
    procedure SetCelular(const Value: string);
    procedure SetCEP(const Value: string);
    procedure SetCidade(const Value: string);
    procedure SetCNPJCPF(const Value: string);
    procedure SetCodigo(const Value: string);
    procedure SetComplemento(const Value: string);
    procedure SetContato1(const Value: string);
    procedure SetContato2(const Value: string);
    procedure SetEmail(const Value: string);
    procedure SetEndereco(const Value: string);
    procedure SetIE(const Value: string);
    procedure SetIM(const Value: string);
    procedure SetNome(const Value: string);
    procedure SetNomeFantasia(const Value: string);
    procedure SetNumero(const Value: string);
    procedure SetObservacao(const Value: string);
    procedure SetTelefone1(const Value: string);
    procedure SetTelefone2(const Value: string);
    procedure SetUF(const Value: string);
  public
    property Codigo: string read FCodigo write SetCodigo;
    property Nome: string read FNome write SetNome;
    property NomeFantasia: string read FNomeFantasia write SetNomeFantasia;
    property Endereco: string read FEndereco write SetEndereco;
    property Numero: string read FNumero write SetNumero;
    property Bairro: string read FBairro write SetBairro;
    property Cidade: string read FCidade write SetCidade;
    property UF: string read FUF write SetUF;
    property CEP: string read FCEP write SetCEP;
    property Complemento: string read FComplemento write SetComplemento;
    property Telefone1: string read FTelefone1 write SetTelefone1;
    property Telefone2: string read FTelefone2 write SetTelefone2;
    property Celular: string read FCelular write SetCelular;
    property Email: string read FEmail write SetEmail;
    property CNPJCPF: string read FCNPJCPF write SetCNPJCPF;
    property IE: string read FIE write SetIE;
    property IM: string read FIM write SetIM;
    property Observacao: string read FObservacao write SetObservacao;
    property Contato1: string read FContato1 write SetContato1;
    property Contato2: string read FContato2 write SetContato2;
  end;

implementation

{ TFornecedorModel }

procedure TFornecedorModel.SetBairro(const Value: string);
begin
  FBairro := Value;
end;

procedure TFornecedorModel.SetCelular(const Value: string);
begin
  FCelular := Value;
end;

procedure TFornecedorModel.SetCEP(const Value: string);
begin
  FCEP := Value;
end;

procedure TFornecedorModel.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TFornecedorModel.SetCNPJCPF(const Value: string);
begin
  FCNPJCPF := Value;
end;

procedure TFornecedorModel.SetCodigo(const Value: string);
begin
  FCodigo := Value;
end;

procedure TFornecedorModel.SetComplemento(const Value: string);
begin
  FComplemento := Value;
end;

procedure TFornecedorModel.SetContato1(const Value: string);
begin
  FContato1 := Value;
end;

procedure TFornecedorModel.SetContato2(const Value: string);
begin
  FContato2 := Value;
end;

procedure TFornecedorModel.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

procedure TFornecedorModel.SetEndereco(const Value: string);
begin
  FEndereco := Value;
end;

procedure TFornecedorModel.SetIE(const Value: string);
begin
  FIE := Value;
end;

procedure TFornecedorModel.SetIM(const Value: string);
begin
  FIM := Value;
end;

procedure TFornecedorModel.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TFornecedorModel.SetNomeFantasia(const Value: string);
begin
  FNomeFantasia := Value;
end;

procedure TFornecedorModel.SetNumero(const Value: string);
begin
  FNumero := Value;
end;

procedure TFornecedorModel.SetObservacao(const Value: string);
begin
  FObservacao := Value;
end;

procedure TFornecedorModel.SetTelefone1(const Value: string);
begin
  FTelefone1 := Value;
end;

procedure TFornecedorModel.SetTelefone2(const Value: string);
begin
  FTelefone2 := Value;
end;

procedure TFornecedorModel.SetUF(const Value: string);
begin
  FUF := Value;
end;

end.

