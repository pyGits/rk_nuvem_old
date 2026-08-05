unit FornecedorSeeder;

interface
uses FornecedorRepositoryImpl,FornecedorModel;
type IFornecedorSeeder = interface
  ['{3529FA7F-BE93-4D80-B19E-A41434D08E63}']
  procedure execute;
end;
type TFornecedorSeeder = class(TInterfacedObject,IFornecedorSeeder)
  private
  FFornecedorRepository:IFornecedorRepository;
  FFornecedorSeeder:TFornecedorModel;

  public
    constructor create;
    procedure execute;
end;

implementation

{ TFornecedorSeeder }

constructor TFornecedorSeeder.create;
begin
  FFornecedorRepository:=TFornecedorRepositoryFirebird.create;
  FFornecedorSeeder := TFornecedorModel.Create;
  FFornecedorSeeder.Codigo := '000000';
  FFornecedorSeeder.Nome := 'TODOS';
end;

procedure TFornecedorSeeder.execute;
begin
if (FFornecedorRepository.get(FFornecedorSeeder.codigo) = nil) then
begin
  FFornecedorRepository.insert(FFornecedorSeeder);
end;
end;

end.
