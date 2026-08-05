unit CodigoAuxiliarModel;

interface
type TCodigoAuxiliarModel = class
  private
    Fcodigo_barras: string;
    Fcodigo: string;
    Fcodigo_auxiliar: string;

    procedure Setcodigo(const Value: string);
    procedure Setcodigo_barras(const Value: string);
    procedure Setcodigo_auxiliar(const Value: string);
  public
  property codigo:string read Fcodigo write Setcodigo;
  property codigo_barras:string read Fcodigo_barras write Setcodigo_barras;
  property codigo_auxiliar:string read Fcodigo_auxiliar write Setcodigo_auxiliar;

end;

implementation

{ TCodigoAuxiliar }


procedure TCodigoAuxiliarModel.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TCodigoAuxiliarModel.Setcodigo_auxiliar(const Value: string);
begin
  FCodigo_auxiliar := Value;
end;

procedure TCodigoAuxiliarModel.Setcodigo_barras(const Value: string);
begin
  Fcodigo_barras := Value;
end;

end.
