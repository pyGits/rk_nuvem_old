unit Classe.Funcionario;

interface

uses
  System.SysUtils,Classe.Pessoa,Classe.Endereco;
  type
  TFuncionario = class
    private
    Fcodigo: string;
    Fsenha: string;
    Fcargo: integer;
    FPessoa: TPessoa;
    Fcomissao: real;


    procedure Setcodigo(const Value: string);
    procedure Setcargo(const Value: integer);
    procedure Setsenha(const Value: string);
    procedure SetPessoa(const Value: TPessoa);
    procedure Setcomissao(const Value: real);


    public
    property Codigo: string read Fcodigo write Setcodigo;
    property cargo:integer read Fcargo write Setcargo;
    property senha:string read Fsenha write Setsenha;
    property comissao:real read Fcomissao write Setcomissao;
    property Pessoa:TPessoa read FPessoa write SetPessoa;


    constructor create;
    destructor destroy;override;




  end;

implementation
uses
Classe.funcoes;

{ TFuncionario }

constructor TFuncionario.create;
begin
  Pessoa:= TPessoa.Create;
end;

destructor TFuncionario.destroy;
begin
  Pessoa.destroy;
  inherited;
end;

procedure TFuncionario.Setcargo(const Value: integer);
begin
  Fcargo := Value;
end;

procedure TFuncionario.Setcodigo(const Value: string);
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
procedure TFuncionario.Setcomissao(const Value: real);
begin
  Fcomissao := Value;
end;

procedure TFuncionario.SetPessoa(const Value: TPessoa);
begin
  FPessoa := Value;
end;

procedure TFuncionario.Setsenha(const Value: string);
var
  senha:string;
begin
  // cript
  Fsenha := Value;
end;

end.
