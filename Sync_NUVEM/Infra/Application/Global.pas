unit Global;

interface
uses CargaPDVUseCase,SubidaContaReceberUseCase;

var
  CargaPDVUseCase:TCargaPDVUseCase;
  SubidaContaReceberUseCase:TSubidaContaReceberUseCase;


implementation

initialization
  CargaPDVUseCase:=TCargaPDVUseCase.create;
  SubidaContaReceberUseCase:=TSubidaContaReceberUseCase.create;

finalization
  CargaPDVUseCase.Free;
  SubidaContaReceberUseCase.Free;

end.
