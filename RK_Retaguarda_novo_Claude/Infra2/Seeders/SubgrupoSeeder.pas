unit SubgrupoSeeder;

interface

uses
  SubgrupoModel, SubgrupoRepositoryImpl;

type
  ISubgrupoSeeder = interface
    ['{2D6F4F7B-AC41-47E7-8F5E-67C9F6F7A891}']
    procedure Execute;
  end;

  TSubgrupoSeeder = class(TInterfacedObject, ISubgrupoSeeder)
  private
    FSubgrupoSeeder: TSubgrupoModel;
    FSubgrupoRepository: ISubgrupoRepository;
  public
    constructor Create;
    procedure Execute;
  end;

implementation

{ TSubgrupoSeeder }

constructor TSubgrupoSeeder.Create;
begin
  FSubgrupoRepository := TSubgrupoRepositoryFirebird.Create;
  FSubgrupoSeeder := TSubgrupoModel.Create;
  FSubgrupoSeeder.codigo := '000000';
  FSubgrupoSeeder.codigoGrupo := '000000';
  FSubgrupoSeeder.descricao := 'SEM SUBGRUPO';
end;

procedure TSubgrupoSeeder.Execute;
begin
  if (FSubgrupoRepository.Get(FSubgrupoSeeder.codigo,FSubgrupoSeeder.CodigoGrupo) = nil) then
  begin
    FSubgrupoRepository.Insert(FSubgrupoSeeder);
  end;
end;

end.

