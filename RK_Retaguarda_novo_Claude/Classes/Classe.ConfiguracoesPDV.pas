unit Classe.ConfiguracoesPDV;

interface
type TConfiguracoesPDV = class
  private
    Flimite_desconto_perc: Real;
    procedure Setlimite_desconto_perc(const Value: Real);
  published
  property limite_desconto_perc:Real read Flimite_desconto_perc write Setlimite_desconto_perc;
end;

implementation

{ TConfiguracoesPDV }

procedure TConfiguracoesPDV.Setlimite_desconto_perc(const Value: Real);
begin
  Flimite_desconto_perc := Value;
end;

end.
