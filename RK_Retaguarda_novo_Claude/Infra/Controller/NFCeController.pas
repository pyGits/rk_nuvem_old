unit NFCeController;

interface
uses System.Generics.Collections,NFCePendente,NFcePendenteRepository;
type TNFceController = class
  function getAllNFCePendente(dtEmissaoInicio:TDate;dtEmissaoFim:TDate;status:string):TObjectList<TNFCePendente>;
  procedure atualizarRetorno(nfce:TNFCePendente);
end;
  var
    NFCe_Controller:TNFceController;

implementation

{ TNFceController }

procedure TNFceController.atualizarRetorno(nfce: TNFCePendente);
begin
NFCePendente_Repository.AtualizarRetorno(nfce);
end;

function TNFceController.getAllNFCePendente(dtEmissaoInicio,
  dtEmissaoFim: TDate;status:string): TObjectList<TNFCePendente>;
begin
result := NFCePendente_Repository.ObterNFCePendente(dtEmissaoInicio,dtEmissaoFim,status);
end;

initialization
    NFCe_Controller:=TNFceController.Create;
end.
