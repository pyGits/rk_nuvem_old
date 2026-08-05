unit NFCeUseCase;

interface
uses System.Generics.Collections,System.Classes,NFCeModel,NFcePendenteRepositoryImpl,NFCeService,System.Rtti;
type TNFceUseCase = class
  private
    FNFcePendenteRepository:INFcePendenteRepository;
    FNFceService:INFCeService;
  public
  constructor create(NFcePendenteRepository:INFcePendenteRepository;NFCeService:INFceService);
  procedure RegerarNFCe(listaChaves:TStringList;ncm:string);
end;

implementation

{ TNFceUseCase }
procedure TNFceUseCase.RegerarNFCe(listaChaves: TStringList;ncm:string);
var
  chave:string;
  nfcePendente:TNFceModel;
begin
  for chave in listaChaves do
  begin
    nfcePendente := FNFcePendenteRepository.GetByChave(chave);

    if nfcePendente.status <> 'PE' then Continue;

    FNFceService.RegerarNFCe(nfcePendente.xml,ncm);

//    FNFcePendenteRepository.AtualizarStatus()
  end;
end;

{ TNFceUseCase }

constructor TNFceUseCase.create(
  NFcePendenteRepository: INFcePendenteRepository;NFCeService:INFceService);
begin
FNFcePendenteRepository  := NFcePendenteRepository;
FNFceService := NFCeService;
end;



end.
