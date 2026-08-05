unit CodigoAuxiliar;

interface
uses Classe.funcoes;
type TCodigoAuxiliar = class
  private
    Fcodigo_barras: string;
    Fcodigo_auxiliar: string;
    Fcodigo: string;
    procedure Setcodigo(const Value: string);
    procedure Setcodigo_auxiliar(const Value: string);
    procedure Setcodigo_barras(const Value: string);
  public
  property codigo:string read Fcodigo write Setcodigo;
  property codigo_barras:string read Fcodigo_barras write Setcodigo_barras;
  property codigo_auxiliar:string read Fcodigo_auxiliar write Setcodigo_auxiliar;
end;

implementation

{ TCodigoAuxiliar }

procedure TCodigoAuxiliar.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TCodigoAuxiliar.Setcodigo_auxiliar(const Value: string);
var
  CodigoBarras : string;
begin
  CodigoBarras := Value;
  CodigoBarras := removeLetras(CodigoBarras);
  CodigoBarras := zeroEsquerda(CodigoBarras,14);

//  free;
  Fcodigo_auxiliar := CodigoBarras;
end;

procedure TCodigoAuxiliar.Setcodigo_barras(const Value: string);
begin
  Fcodigo_barras := Value;
end;

end.
