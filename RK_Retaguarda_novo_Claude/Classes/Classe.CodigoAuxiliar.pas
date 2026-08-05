unit Classe.CodigoAuxiliar;

interface
type TCodigoAuxiliar = class
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
uses Classe.Funcoes;

{ TCodigoAuxiliar }


procedure TCodigoAuxiliar.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TCodigoAuxiliar.Setcodigo_auxiliar(const Value: string);
begin
  FCodigo_auxiliar := Value;
  FCodigo_auxiliar := removeLetras(FCodigo_auxiliar);
  FCodigo_auxiliar := zeroEsquerda(FCodigo_auxiliar,14);
end;

procedure TCodigoAuxiliar.Setcodigo_barras(const Value: string);
begin
  Fcodigo_barras := Value;
  Fcodigo_barras := removeLetras(Fcodigo_barras);
  Fcodigo_barras := zeroEsquerda(Fcodigo_barras,14);
end;

end.
