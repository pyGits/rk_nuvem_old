unit Global;

interface
uses CargaPDVUseCase,SubidaContaReceberUseCase,SubidaErroPDVUseCase,IndicesNuvemRepository,
     ReenvioPeriodoUseCase;

var
  CargaPDVUseCase:TCargaPDVUseCase;
  SubidaContaReceberUseCase:TSubidaContaReceberUseCase;
  SubidaErroPDVUseCase:TSubidaErroPDVUseCase;
  ReenvioPeriodoUseCase:TReenvioPeriodoUseCase;
  IndicesNuvem:IIndicesNuvemRepository;


implementation

initialization
  CargaPDVUseCase:=TCargaPDVUseCase.create;
  SubidaContaReceberUseCase:=TSubidaContaReceberUseCase.create;
  SubidaErroPDVUseCase:=TSubidaErroPDVUseCase.create;
  ReenvioPeriodoUseCase:=TReenvioPeriodoUseCase.create;
  IndicesNuvem:=TIndicesNuvemRepository.create;

finalization
  CargaPDVUseCase.Free;
  SubidaContaReceberUseCase.Free;
  SubidaErroPDVUseCase.Free;
  ReenvioPeriodoUseCase.Free;

end.
