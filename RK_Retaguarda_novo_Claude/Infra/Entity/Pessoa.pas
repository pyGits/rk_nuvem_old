unit Pessoa;

interface
type TPessoa = class
  private
    FtipoPessoa: integer;
    FRG: string;
    FdataNascimento: TDate;
    FEmail: string;
    FApelido: string;
    FCPFCNPJ: string;
    FTelefone2: string;
    FCelular2: string;
    FTelefone1: string;
    FCelular1: string;
    FSexo: string;
    FNome: string;
    procedure SetApelido(const Value: string);
    procedure SetCelular1(const Value: string);
    procedure SetCelular2(const Value: string);
    procedure SetCPFCNPJ(const Value: string);
    procedure SetdataNascimento(const Value: TDate);
    procedure SetEmail(const Value: string);
    procedure SetNome(const Value: string);
    procedure SetRG(const Value: string);
    procedure SetSexo(const Value: string);
    procedure SetTelefone1(const Value: string);
    procedure SetTelefone2(const Value: string);
    procedure SettipoPessoa(const Value: integer);
  published
    property Nome:string read FNome write SetNome;
    property Apelido:string read FApelido write SetApelido;
    property RG:string read FRG write SetRG;
    property CPFCNPJ:string read FCPFCNPJ write SetCPFCNPJ;
    property Telefone1:string read FTelefone1 write SetTelefone1;
    property Telefone2:string read FTelefone2 write SetTelefone2;
    property Celular1:string read FCelular1 write SetCelular1;
    property Celular2:string read FCelular2 write SetCelular2;
    property Email:string read FEmail write SetEmail;
    property Sexo:string read FSexo write SetSexo;
    property tipoPessoa:integer read FtipoPessoa write SettipoPessoa;
    property dataNascimento:TDate read FdataNascimento write SetdataNascimento;
end;

implementation

{ TPessoa }

procedure TPessoa.SetApelido(const Value: string);
begin
  FApelido := Value;
end;

procedure TPessoa.SetCelular1(const Value: string);
begin
  FCelular1 := Value;
end;

procedure TPessoa.SetCelular2(const Value: string);
begin
  FCelular2 := Value;
end;

procedure TPessoa.SetCPFCNPJ(const Value: string);
begin
  FCPFCNPJ := Value;
end;

procedure TPessoa.SetdataNascimento(const Value: TDate);
begin
  FdataNascimento := Value;
end;

procedure TPessoa.SetEmail(const Value: string);
begin
  FEmail := Value;
end;

procedure TPessoa.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TPessoa.SetRG(const Value: string);
begin
  FRG := Value;
end;

procedure TPessoa.SetSexo(const Value: string);
begin
  FSexo := Value;
end;

procedure TPessoa.SetTelefone1(const Value: string);
begin
  FTelefone1 := Value;
end;

procedure TPessoa.SetTelefone2(const Value: string);
begin
  FTelefone2 := Value;
end;

procedure TPessoa.SettipoPessoa(const Value: integer);
begin
  FtipoPessoa := Value;
end;

end.
