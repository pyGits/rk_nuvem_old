unit GrupoSeeder;

interface

uses
  GrupoModel, GrupoRepositoryImpl;

type
  IGrupoSeeder = interface
    ['{3E0B08A8-E7CC-436E-A97B-9421DBD7B671}']
    procedure execute;
  end;

type
  TGrupoSeeder = class(TInterfacedObject, IGrupoSeeder)
  private
    GrupoSeeder: TGrupoModel;
    FGrupoRepository: IGrupoRepository;
  public
    constructor create;
    procedure execute;
  end;

implementation { TGrupoSeeder }

constructor TGrupoSeeder.create;
begin
  FGrupoRepository := TGrupoRepositoryFirebird.create;
  GrupoSeeder := TGrupoModel.create;
  GrupoSeeder.codigo := '000000';
  GrupoSeeder.descricao := 'SEM GRUPO';
end;

procedure TGrupoSeeder.execute;
begin
  if (FGrupoRepository.get(GrupoSeeder.codigo) = nil) then
  begin
    FGrupoRepository.insert(GrupoSeeder);
  end;
end;

end.

