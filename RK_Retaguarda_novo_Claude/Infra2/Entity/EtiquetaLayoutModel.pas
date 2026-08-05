unit EtiquetaLayoutModel;

interface
type TEtiquetaLayoutModel = class
  private
    Fcodigo: string;
    Farquivo: string;
    Fnome: string;
    procedure Setarquivo(const Value: string);
    procedure Setcodigo(const Value: string);
    procedure Setnome(const Value: string);
  published
  property codigo:string read Fcodigo write Setcodigo;
  property nome:string read Fnome write Setnome;
  property arquivo:string read Farquivo write Setarquivo;
end;

implementation

{ TEtiquetaLayoutModel }

procedure TEtiquetaLayoutModel.Setarquivo(const Value: string);
begin
  Farquivo := Value;
end;

procedure TEtiquetaLayoutModel.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TEtiquetaLayoutModel.Setnome(const Value: string);
begin
  Fnome := Value;
end;

end.
