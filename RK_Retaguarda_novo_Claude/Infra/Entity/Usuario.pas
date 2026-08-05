unit Usuario;

interface
uses Pessoa,Helper;
type TUsuario = class
  private
    FPessoa: TPessoa;
    Fcodigo: string;
    Fcomissao: real;
    Fsenha: string;
    Fcargo: integer;
    procedure Setcargo(const Value: integer);
    procedure Setcodigo(const Value: string);
    procedure Setcomissao(const Value: real);
    procedure SetPessoa(const Value: TPessoa);
    procedure Setsenha(const Value: string);
    public
    constructor create;
  published
    property Codigo: string read Fcodigo write Setcodigo;
    property cargo:integer read Fcargo write Setcargo;
    property senha:string read Fsenha write Setsenha;
    property comissao:real read Fcomissao write Setcomissao;
    property Pessoa:TPessoa read FPessoa write SetPessoa;

    function Autenticar(senha_digitada:string):boolean;
end;

var
  UsuarioLogado:TUsuario;

implementation
{ TUsuario }

function TUsuario.Autenticar(senha_digitada: string): boolean;
var
  cript:string;
begin
  cript := Helper_Utils.Cript('D',FSenha);
    result := senha_digitada = cript;
end;

constructor TUsuario.create;
begin
FPessoa := TPessoa.Create;
end;

procedure TUsuario.Setcargo(const Value: integer);
begin
  Fcargo := Value;
end;

procedure TUsuario.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TUsuario.Setcomissao(const Value: real);
begin
  Fcomissao := Value;
end;

procedure TUsuario.SetPessoa(const Value: TPessoa);
begin
  FPessoa := Value;
end;

procedure TUsuario.Setsenha(const Value: string);
begin
  Fsenha := Value;
end;

initialization
  UsuarioLogado := TUsuario.Create;

end.
