unit Global;

interface
uses CargaPDVUseCase,SubidaContaReceberUseCase,IndicesNuvemRepository;

var
  CargaPDVUseCase:TCargaPDVUseCase;
  SubidaContaReceberUseCase:TSubidaContaReceberUseCase;
  IndicesNuvem:IIndicesNuvemRepository;


implementation

initialization
  CargaPDVUseCase:=TCargaPDVUseCase.create;
  SubidaContaReceberUseCase:=TSubidaContaReceberUseCase.create;
  IndicesNuvem:=TIndicesNuvemRepository.create;

finalization
  CargaPDVUseCase.Free;
  SubidaContaReceberUseCase.Free;

end.
