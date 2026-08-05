unit Global;

interface
uses CargaUseCase,ContaReceberUseCase,DatabaseUseCase,UIAtualizarBanco,EtiquetaUseCase,ProdutoRepositoryImpl,EtiquetaRepositoryImpl,System.SysUtils,EtiquetaPrinterFast,ConfiguracaoRepositoryImpl,NFCeUseCase
,NFcePendenteRepositoryImpl,NFCeService,ImportarIBPTUseCase,ListarProdutosUseCase,GrupoRepositoryImpl,ListarGruposUseCase;

var
  CargaUseCase:TCargaUseCase;
  ContaReceberUseCase:TContaReceberUseCase;
  DatabaseUseCase:TDatabaseUseCase;
  EtiquetaUseCase:TEtiquetaUseCase;
  NFCeUseCase:TNFceUseCase;
  ImportarIBPTUseCase:TImportarIBPTUseCase;

  GListaGruposUseCase:TListarGruposUseCase;
  GListarProdutosUseCase : TListarProdutosUseCase;


implementation
uses uFrmEtiqueta,uFrmNFCePendente;

procedure Carregar;
var
  produtoRepository:IProdutoRepository;
  grupoRepository:IGrupoRepository;
begin
  produtoRepository := TProdutoRepositoryFirebird.Create;
  grupoRepository := TGrupoRepositoryFirebird.create;

  GListaGruposUseCase:=TListarGruposUseCase.Create(grupoRepository);



  DatabaseUseCase:=TDatabaseUseCase.create(TfrmUIAtualizarBanco.Create(nil));
  DatabaseUseCase.UpdateDatabase;

  FConfiguracaoRepositoryFirebird := TConfiguracaoRepositoryFirebird.create;

  CargaUseCase:=TCargaUseCase.create;
  ContaReceberUseCase:=TContaReceberUseCase.create;
  EtiquetaUseCase := TEtiquetaUseCase.create(TEtiquetaRepositoryFirebird.create,TFrmEtiqueta.create(nil),TEtiquetaPrinterFast.create);
  ImportarIBPTUseCase:=TImportarIBPTUseCase.create;

  GListarProdutosUseCase := TListarProdutosUseCase.create(produtoRepository);

//  NFCeUseCase := TNFceUseCase.create(TNFcePendenteRepositoryFirebird.create,TNFceService.create);
end;

initialization
Carregar;

finalization
  CargaUseCase.Free;
  ContaReceberUseCase.Free;
  DatabaseUseCase.Free;
  EtiquetaUseCase.Free;
  NFCeUseCase.Free;
  ImportarIBPTUseCase.Free;

end.
