unit DatabaseUseCase;

interface
uses System.Generics.Collections,DatabaseRepositoryImpl,LogService,MigrationModel,system.SysUtils,UIAtualizarBancoInterface,SeederExecute;
type TDatabaseUseCase = class
  private
  FDatabaseRepository:IDatabaseRepository;
  FLogService:ILogService;
  FUIAtualizarBanco:IAtualizarBanco;
  FSeeder:ISeeder;
  public
  constructor create(frmAtualizarBanco:IAtualizarBanco);
  procedure UpdateDatabase;
end;

implementation

{ TDatabaseUseCase }

constructor TDatabaseUseCase.create(frmAtualizarBanco:IAtualizarBanco);
begin
FDatabaseRepository := TDatabaseRepositoryFirebird.create;
FSeeder := TSeeder.create;
FLogService := TLogServiceTxt.Create;
FUIAtualizarBanco := frmAtualizarBanco;
end;

procedure TDatabaseUseCase.UpdateDatabase;
var
  databaseVersion:integer;
  migrations:TMigrationList;
  migration:TMigrationModel;
  atualizacaoPendente:boolean;
begin
  FLogService.ClearLog('LogAtualiza.txt');
  databaseVersion := FDatabaseRepository.getVersion;
  migrations := FDatabaseRepository.getMigrations;

  atualizacaoPendente := migrations.Total > databaseVersion;

  if not(atualizacaoPendente) then exit;

  FUIAtualizarBanco.Abrir;

  FUIAtualizarBanco.IniciarAtualizacao(databaseVersion);

  for migration in migrations.Items do
  begin
    if migration.versao >= databaseVersion then
    begin
    FLogService.WriteLog('LogAtualiza.txt',IntToStr(migration.versao)+ ' - ' +migration.sql);
    FUIAtualizarBanco.atualizarProgresso(migration.versao,migrations.Total,migration.sql);
    FDatabaseRepository.executeMigration(migration);
    end;
  end;

  FSeeder.execute;
  FUIAtualizarBanco.Finalizar;
end;

end.
