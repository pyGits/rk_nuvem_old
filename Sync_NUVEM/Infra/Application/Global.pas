unit Global;

interface
uses CargaPDVUseCase,SubidaContaReceberUseCase,SubidaErroPDVUseCase,IndicesNuvemRepository,
     ReenvioPeriodoUseCase,ModoNuvemRepository,CaixaIniRepository;

var
  CargaPDVUseCase:TCargaPDVUseCase;
  SubidaContaReceberUseCase:TSubidaContaReceberUseCase;
  SubidaErroPDVUseCase:TSubidaErroPDVUseCase;
  ReenvioPeriodoUseCase:TReenvioPeriodoUseCase;
  IndicesNuvem:IIndicesNuvemRepository;
  ModoNuvem:IModoNuvemRepository;
  // Caixas que recebem a carga, cadastrados no proprio agente (config.ini).
  Caixas:ICaixaIniRepository;


implementation

initialization
  CargaPDVUseCase:=TCargaPDVUseCase.create;
  SubidaContaReceberUseCase:=TSubidaContaReceberUseCase.create;
  SubidaErroPDVUseCase:=TSubidaErroPDVUseCase.create;
  ReenvioPeriodoUseCase:=TReenvioPeriodoUseCase.create;
  IndicesNuvem:=TIndicesNuvemRepository.create;
  ModoNuvem:=TModoNuvemRepository.create;
  Caixas:=TCaixaIniRepository.create;

finalization
  CargaPDVUseCase.Free;
  SubidaContaReceberUseCase.Free;
  SubidaErroPDVUseCase.Free;
  ReenvioPeriodoUseCase.Free;

end.
