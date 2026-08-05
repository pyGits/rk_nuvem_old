unit EnderecoModel;

interface

type TEndereco = class
  private
    FBairro: string;
    FUF: string;
    FCEP: string;
    FNumero: string;
    FComplemento: string;
    FCidade: string;
    FEndereco: string;
    procedure SetBairro(const Value: string);
    procedure SetCEP(const Value: string);
    procedure SetCidade(const Value: string);
    procedure SetComplemento(const Value: string);
    procedure SetEndereco(const Value: string);
    procedure SetNumero(const Value: string);
    procedure SetUF(const Value: string);

  public
    property Endereco:string read FEndereco write SetEndereco;
    property Numero:string read FNumero write SetNumero;
    property Bairro:string read FBairro write SetBairro;
    property Cidade:string read FCidade write SetCidade;
    property UF:string read FUF write SetUF;
    property CEP:string read FCEP write SetCEP;
    property Complemento:string read FComplemento write SetComplemento;


end;

implementation

{ TEndereco }




{ TEndereco }

procedure TEndereco.SetBairro(const Value: string);
begin
  FBairro := Value;
end;

procedure TEndereco.SetCEP(const Value: string);
begin
  FCEP := Value;
end;

procedure TEndereco.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TEndereco.SetComplemento(const Value: string);
begin
  FComplemento := Value;
end;

procedure TEndereco.SetEndereco(const Value: string);
begin
  FEndereco := Value;
end;

procedure TEndereco.SetNumero(const Value: string);
begin
  FNumero := Value;
end;

procedure TEndereco.SetUF(const Value: string);
begin
  FUF := Value;
end;

end.
