unit CaixaModel;

interface
type TCaixaModel = class
  private
    Fcodigo: string;
    Fip: string;
    Fnome: string;
    procedure Setcodigo(const Value: string);
    procedure Setip(const Value: string);
    procedure Setnome(const Value: string);
  published
  property codigo:string read Fcodigo write Setcodigo;
  property nome:string read Fnome write Setnome;
  property ip:string read Fip write Setip;
end;

implementation

{ TCaixaModel }

procedure TCaixaModel.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TCaixaModel.Setip(const Value: string);
begin
  Fip := Value;
end;

procedure TCaixaModel.Setnome(const Value: string);
begin
  Fnome := Value;
end;

end.
