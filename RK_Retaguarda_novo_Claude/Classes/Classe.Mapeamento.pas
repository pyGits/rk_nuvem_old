unit Classe.Mapeamento;

interface
type TMapeamento = class
  private
    Fcodigo_sistema: string;
    Fcodigo_interno: string;
    procedure Setcodigo_interno(const Value: string);
    procedure Setcodigo_sistema(const Value: string);
  published
  property codigo_sistema:string read Fcodigo_sistema write Setcodigo_sistema;
  property codigo_interno:string read Fcodigo_interno write Setcodigo_interno;
end;

implementation

{ TMapeamento }

procedure TMapeamento.Setcodigo_interno(const Value: string);
begin
  Fcodigo_interno := Value;
end;

procedure TMapeamento.Setcodigo_sistema(const Value: string);
begin
  Fcodigo_sistema := Value;
end;

end.
