unit ListarGruposUseCase;

interface
uses GrupoModel,system.Generics.collections,GrupoRepositoryImpl;
type TListarGruposUseCase = class
  public
  FGrupoRepository:IGrupoRepository;

  constructor create(grupoRepository:IGrupoRepository);
  function execute:TObjectList<TGrupoModel>;
end;

implementation

{ TListarGruposUseCase }

constructor TListarGruposUseCase.create(grupoRepository: IGrupoRepository);
begin
FGrupoRepository := grupoRepository
end;

function TListarGruposUseCase.execute: TObjectList<TGrupoModel>;
begin
result := FGrupoRepository.getAll;
end;

end.
