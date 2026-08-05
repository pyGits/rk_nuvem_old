unit Classe.Emitente;

interface
Uses System.SysUtils;
type
 TEmitente = class;
 TEnderecoEmit = class;

TEmitente = class(TObject)
  private
    FRG: string;
    FCNPJ: string;
    FEmail: string;
    FFax: string;
    FIM: string;
    FCPF: string;
    FResponsavel: string;
    FIE: string;
    FNome: string;
    FEndereco: TEnderecoEmit;
    FNomeFantasia: string;
    FCelular: string;
    FTelefone: string;
    procedure SetCelular(const Value: string);
    procedure SetCNPJ(const Value: string);
    procedure SetCPF(const Value: string);
    procedure SetEmail(const Value: string);
    procedure SetEndereco(const Value: TEnderecoEmit);
    procedure SetFax(const Value: string);
    procedure SetIE(const Value: string);
    procedure SetIM(const Value: string);
    procedure SetNome(const Value: string);
    procedure SetNomeFantasia(const Value: string);
    procedure SetResponsavel(const Value: string);
    procedure SetRG(const Value: string);
    procedure SetTelefone(const Value: string);
  public
  property CNPJ: string read FCNPJ write SetCNPJ;
  property Nome:string read FNome write SetNome;
  property NomeFantasia:string read FNomeFantasia write SetNomeFantasia;
  property IE:string read FIE write SetIE;
  property IM:string read FIM write SetIM;
  property Endereco: TEnderecoEmit read FEndereco write SetEndereco;
  property Email:string read FEmail write SetEmail;
  property Responsavel:string read FResponsavel write SetResponsavel;
  property Celular:string read FCelular write SetCelular;
  property Fax:string read FFax write SetFax;
  property CPF:string read FCPF write SetCPF;
  property RG:string read FRG write SetRG;
  property Telefone:string read FTelefone write SetTelefone;
  constructor create;
  destructor destroy;override;


end;


TEnderecoEmit = class
private
    FBairro: string;
    FCidadeCodigo: string;
    FUF: string;
    FCEP: integer;
    FNumero: string;
    Fcomplemento: string;
    FCidade: string;
    FEndereco: string;
    FTelefone: string;
    FIBGE: string;
    FcodIBGE: string;
    procedure SetBairro(const Value: string);
    procedure SetCEP(const Value: integer);
    procedure SetCidade(const Value: string);
    procedure SetCidadeCodigo(const Value: string);
    procedure Setcomplemento(const Value: string);
    procedure SetEndereco(const Value: string);
    procedure SetNumero(const Value: string);
    procedure SetTelefone(const Value: string);
    procedure SetUF(const Value: string);
    procedure SetcodIBGE(const Value: string);
    procedure SetIBGE(const Value: string);
public
  property Endereco:string read FEndereco write SetEndereco;
  property Bairro:string read FBairro write SetBairro;
  property Cidade:string read FCidade write SetCidade;
  property CidadeCodigo:string read FCidadeCodigo write SetCidadeCodigo;
  property UF:string read FUF write SetUF;
  property CEP:integer read FCEP write SetCEP;
  property Telefone:string read FTelefone write SetTelefone;
  property Numero:string read FNumero write SetNumero;
  property complemento:string read Fcomplemento write Setcomplemento;
  property codIBGE:string read FcodIBGE write SetcodIBGE;
  property IBGE:string read FIBGE write SetIBGE;
end;
implementation

{ TEmitente }

constructor TEmitente.create;
begin
FEndereco := TEnderecoEmit.create;
end;

destructor TEmitente.destroy;
begin
  FreeAndNil(FEndereco);
  inherited;
end;

procedure TEmitente.SetCelular(const Value: string);
begin
  FCelular := Value;
end;

procedure TEmitente.SetCNPJ(const Value: string);
begin
  FCNPJ := Value;
end;

procedure TEmitente.SetCPF(const Value: string);
begin
  FCPF := Value;
end;

procedure TEmitente.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

procedure TEmitente.SetEndereco(const Value: TEnderecoEmit);
begin
  FEndereco := Value;
end;

procedure TEmitente.SetFax(const Value: string);
begin
  FFax := Value;
end;

procedure TEmitente.SetIE(const Value: string);
begin
  FIE := Value;
end;

procedure TEmitente.SetIM(const Value: string);
begin
  FIM := Value;
end;

procedure TEmitente.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TEmitente.SetNomeFantasia(const Value: string);
begin
  FNomeFantasia := Value;
end;

procedure TEmitente.SetResponsavel(const Value: string);
begin
  FResponsavel := Value;
end;

procedure TEmitente.SetRG(const Value: string);
begin
  FRG := Value;
end;

procedure TEmitente.SetTelefone(const Value: string);
begin
  FTelefone := Value;
end;

{ TEnderecoEmit }

procedure TEnderecoEmit.SetBairro(const Value: string);
begin
  FBairro := Value;
end;

procedure TEnderecoEmit.SetCEP(const Value: integer);
begin
  FCEP := Value;
end;

procedure TEnderecoEmit.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TEnderecoEmit.SetCidadeCodigo(const Value: string);
begin
  FCidadeCodigo := Value;
end;

procedure TEnderecoEmit.SetcodIBGE(const Value: string);
begin
  FcodIBGE := Value;
end;

procedure TEnderecoEmit.Setcomplemento(const Value: string);
begin
  Fcomplemento := Value;
end;

procedure TEnderecoEmit.SetEndereco(const Value: string);
begin
  FEndereco := Value;
end;

procedure TEnderecoEmit.SetIBGE(const Value: string);
begin
  FIBGE := Value;
end;

procedure TEnderecoEmit.SetNumero(const Value: string);
begin
  FNumero := Value;
end;

procedure TEnderecoEmit.SetTelefone(const Value: string);
begin
  FTelefone := Value;
end;

procedure TEnderecoEmit.SetUF(const Value: string);
begin
  FUF := Value;
end;

end.
