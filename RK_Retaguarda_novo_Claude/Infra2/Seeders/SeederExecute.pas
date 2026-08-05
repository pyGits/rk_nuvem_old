unit SeederExecute;

interface
uses RetaguardaNivelSeeder,GrupoSeeder,FornecedorSeeder,SubgrupoSeeder;
type ISeeder = interface
  ['{4F9401D4-7830-41E6-B6C9-524B15DA086F}']
  procedure execute;
end;
type TSeeder = class(TInterfacedObject,ISeeder)
  private
  FRetaguardaNivelSeeder:TRetaguardaNivelSeeder;
  FGrupoSeeder:TGrupoSeeder;
  FFornecedorSeeder:IFornecedorSeeder;
  FSubgrupoSeeder:ISubgrupoSeeder;
  public
  constructor create;
    procedure execute;
end;

implementation

{ TSeeder }

constructor TSeeder.create;
begin
  FRetaguardaNivelSeeder:=TRetaguardaNivelSeeder.create;
  FGrupoSeeder:=TGrupoSeeder.create;
  FFornecedorSeeder := TFornecedorSeeder.create;
  FSubgrupoSeeder := TSubgrupoSeeder.create;
end;

procedure TSeeder.execute;
begin
FRetaguardaNivelSeeder.Execute;
FGrupoSeeder.execute;
FFornecedorSeeder.execute;
FSubgrupoSeeder.execute;
end;

end.
