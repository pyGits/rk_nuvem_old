unit Global;

interface
uses CargaPDVUseCase;

var
  CargaPDVUseCase:TCargaPDVUseCase;


implementation

initialization
  CargaPDVUseCase:=TCargaPDVUseCase.create;

finalization
  CargaPDVUseCase.Free;

end.
