unit Classe.Consumidor;

interface

uses system.classes,System.SysUtils;

type
  TConsumidor = class;
  TConsumidorEndereco = class;


  TConsumidor = class(TObject)
    private
    FCNPJCPF: string;
    FNome: string;
    FEndereco: TConsumidorEndereco;
    procedure SetCNPJCPF(const Value: string);
    procedure SetEndereco(const Value: TConsumidorEndereco);
    procedure SetNome(const Value: string);
    public
    property CNPJCPF : string read FCNPJCPF write SetCNPJCPF;
    property Nome : string read FNome write SetNome;
    property Endereco:TConsumidorEndereco read FEndereco write SetEndereco;
    constructor create;
    destructor Destroy;override;

  end;

  TConsumidorEndereco = class(TObject)
    private
    FFone: string;
    FBairro: string;
    FUF: string;
    FNumero: string;
    FcodigoMunicipio: string;
    FEndereco: string;
    FComplemento: string;
    FCidade: string;
    FCEP: integer;
    procedure SetBairro(const Value: string);
    procedure SetcodigoMunicipio(const Value: string);

    procedure SetFone(const Value: string);
    procedure SetMunicipio(const Value: string);
    procedure SetNumero(const Value: string);
    procedure SetUF(const Value: string);
    procedure SetEndereco(const Value: string);
    procedure SetComplemento(const Value: string);
    procedure SetCidade(const Value: string);
    procedure SetCEP(const Value: integer);
    public
    property CEP:integer read FCEP write SetCEP;
    property Endereco : string read FEndereco write SetEndereco;
    property Fone : string read FFone write SetFone;
    property Numero : string read FNumero write SetNumero;
    property Bairro : string read FBairro write SetBairro;
    property codigoMunicipio : string read FcodigoMunicipio write SetcodigoMunicipio;
    property UF:string read FUF write SetUF;
    property Complemento:string read FComplemento write SetComplemento;
    property Cidade:string read FCidade write SetCidade;

  end;





implementation

{ TConsumidorEndereco }



procedure TConsumidorEndereco.SetBairro(const Value: string);
begin
  FBairro := Value;
end;


procedure TConsumidorEndereco.SetCEP(const Value: integer);
begin
  FCEP := Value;
end;

procedure TConsumidorEndereco.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TConsumidorEndereco.SetcodigoMunicipio(const Value: string);
begin
  FcodigoMunicipio := Value;
end;



procedure TConsumidorEndereco.SetComplemento(const Value: string);
begin
  FComplemento := Value;
end;

procedure TConsumidorEndereco.SetEndereco(const Value: string);
begin
  FEndereco := Value;
end;

procedure TConsumidorEndereco.SetFone(const Value: string);
begin
  FFone := Value;
end;



procedure TConsumidorEndereco.SetMunicipio(const Value: string);
begin

end;

procedure TConsumidorEndereco.SetNumero(const Value: string);
begin
  FNumero := Value;
end;

procedure TConsumidorEndereco.SetUF(const Value: string);
begin
  FUF := Value;
end;

{ TConsumidor }

constructor TConsumidor.create;
begin
Endereco := TConsumidorEndereco.create;
end;

destructor TConsumidor.Destroy;
begin
  FreeAndNil(FEndereco);
  inherited;
end;

procedure TConsumidor.SetCNPJCPF(const Value: string);
begin
  FCNPJCPF := Value;
end;

procedure TConsumidor.SetEndereco(const Value: TConsumidorEndereco);
begin
  FEndereco := Value;
end;

procedure TConsumidor.SetNome(const Value: string);
begin
  FNome := Value;
end;

end.
