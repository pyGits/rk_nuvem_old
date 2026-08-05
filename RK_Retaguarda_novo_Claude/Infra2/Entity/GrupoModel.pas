unit GrupoModel;

interface
type TGrupoModel = class
  private
    Fdescricao: string;
    Fcodigo: string;
    procedure Setcodigo(const Value: string);
    procedure Setdescricao(const Value: string);
  public
    property codigo:string read Fcodigo write Setcodigo;
    property descricao:string read Fdescricao write Setdescricao;
end;

implementation

{ TGrupoModel }

procedure TGrupoModel.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TGrupoModel.Setdescricao(const Value: string);
begin
  Fdescricao := Value;
end;

end.
