unit Classe.Marca;

interface
uses Classe.Funcoes;
type TMarca = class
  private
    Fcodigo: string;
    Fnome: string;
    procedure Setcodigo(const Value: string);
    procedure Setnome(const Value: string);
  public
  property codigo :string read Fcodigo write Setcodigo;
  property nome   :string read Fnome write Setnome;
end;

implementation

{ TMarca }

procedure TMarca.Setcodigo(const Value: string);
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

procedure TMarca.Setnome(const Value: string);
begin
  Fnome := Value;
end;

end.
