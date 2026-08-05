unit SubgrupoModel;

interface
type TSubgrupoModel = class
  private
    FCodigoGrupo: string;
    Fdescricao: string;
    Fcodigo: string;
    procedure Setcodigo(const Value: string);
    procedure SetCodigoGrupo(const Value: string);
    procedure Setdescricao(const Value: string);
  published
  property codigo:string read Fcodigo write Setcodigo;
  property CodigoGrupo:string read FCodigoGrupo write SetCodigoGrupo;
  property descricao:string read Fdescricao write Setdescricao;
end;

implementation

{ TSubgrupoModel }

procedure TSubgrupoModel.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TSubgrupoModel.SetCodigoGrupo(const Value: string);
begin
  FCodigoGrupo := Value;
end;

procedure TSubgrupoModel.Setdescricao(const Value: string);
begin
  Fdescricao := Value;
end;

end.
