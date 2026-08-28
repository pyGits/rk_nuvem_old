unit Global;

interface
uses CargaPDVUseCase,SubidaContaReceberUseCase,SubidaErroPDVUseCase,IndicesNuvemRepository;

var
  CargaPDVUseCase:TCargaPDVUseCase;
  SubidaContaReceberUseCase:TSubidaContaReceberUseCase;
  SubidaErroPDVUseCase:TSubidaErroPDVUseCase;
  IndicesNuvem:IIndicesNuvemRepository;


implementation

initialization
  CargaPDVUseCase:=TCargaPDVUseCase.create;
  SubidaContaReceberUseCase:=TSubidaContaReceberUseCase.create;
  SubidaErroPDVUseCase:=TSubidaErroPDVUseCase.create;
  IndicesNuvem:=TIndicesNuvemRepository.create;

finalization
  CargaPDVUseCase.Free;
  SubidaContaReceberUseCase.Free;
  SubidaErroPDVUseCase.Free;

end.
