unit Classe.Proprio;

interface

uses
  System.SysUtils,Classe.Pessoa,Classe.Endereco;
  type
  TProprio = class
    private
    Fcodigo: string;
    FDescricao: string;
    FPessoa: TPessoa;
    FEndereco: TEndereco;
    FIE: String;
    FIBGE: string;
    procedure Setcodigo(const Value: string);
    procedure SetDescricao(const Value: string);
    procedure SetEndereco(const Value: TEndereco);
    procedure SetPessoa(const Value: TPessoa);
    procedure SetIE(const Value: String);
    procedure SetIBGE(const Value: string);



    public
    property Codigo: string read Fcodigo write Setcodigo;
    property Pessoa:TPessoa read FPessoa write SetPessoa;
    property Endereco:TEndereco read FEndereco write SetEndereco;
    property IE:String read FIE write SetIE;
    property IBGE:string read FIBGE write SetIBGE;
    constructor create;
    destructor destroy;override;


  end;

implementation
uses
Classe.funcoes;

{ TNCM }


{ TProprio }

constructor TProprio.create;
begin
FPessoa := TPessoa.Create;
FEndereco := TEndereco.Create;
end;

destructor TProprio.destroy;
begin
  FPessoa.Destroy;
  FEndereco.Destroy;
  inherited;
end;

procedure TProprio.Setcodigo(const Value: string);
var
  codigo : string;
begin
  CODIGO := '000001';


  codigo := zeroEsquerda(Value,6);

  Fcodigo := Codigo;
end;



procedure TProprio.SetDescricao(const Value: string);
begin

end;

procedure TProprio.SetEndereco(const Value: TEndereco);
begin
  FEndereco := Value;
end;

procedure TProprio.SetIBGE(const Value: string);
begin
  FIBGE := Value;
end;

procedure TProprio.SetIE(const Value: String);
begin
  FIE := Value;
end;

procedure TProprio.SetPessoa(const Value: TPessoa);
begin
  FPessoa := Value;
end;

end.
