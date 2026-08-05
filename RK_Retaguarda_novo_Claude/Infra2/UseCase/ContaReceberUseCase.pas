unit ContaReceberUseCase;

interface
uses ContaReceberModel,ContaReceberRepositoryImpl,System.SysUtils,ContaReceberPrinter;
type TContaReceberUseCase = class
private
  FContaReceberRepository:IContaReceberRepository;
  FContaReceberPrinter:IContaReceberPrinter;

  public
  constructor create;
  procedure ImprimirContaReceber(codigo:string);
end;

implementation

{ TContaReceberUseCase }

constructor TContaReceberUseCase.create;
begin
FContaReceberRepository := TContaReceberRepositoryFirebird.Create;
FContaReceberPrinter := TContaReceberPrinter.create;
end;

procedure TContaReceberUseCase.ImprimirContaReceber(codigo: string);
var
  conta:TContaReceberModel;
begin
  conta := FContaReceberRepository.getByCodigo(codigo);
  if conta = nil then raise Exception.Create('Conta Não Encontrada !');

  FContaReceberPrinter.Imprimir(conta);
end;

end.
