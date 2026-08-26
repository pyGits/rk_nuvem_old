unit SubidaContaReceberUseCase;

interface
uses CaixaRepository, CaixaModel, System.Generics.Collections,
     ContaReceberPDVRepository, ContaReceber;

type TSubidaContaReceberUseCase = class
  private
  FCaixaRepository:ICaixaRepository;
  FContaReceberPDVRepository:IContaReceberPDVRepository;
  public
  procedure Executar;
  constructor create;
end;

implementation

uses System.SysUtils, uAPIRequest, uLogErro;

{ TSubidaContaReceberUseCase }

constructor TSubidaContaReceberUseCase.create;
begin
  FCaixaRepository := TCaixaRepository.create;
  FContaReceberPDVRepository := TContaReceberPDVRepository.create;
end;

// Sobe os titulos de convenio de cada PDV. Mesmo contrato das demais subidas:
// le o que esta com NUVEM = 0, envia, e so marca NUVEM = 1 quando a nuvem
// confirma - se o POST falhar, o titulo volta no proximo ciclo.
procedure TSubidaContaReceberUseCase.Executar;
var
  caixas:TObjectList<TCaixaModel>;
  caixa:TCaixaModel;
  titulos:TObjectList<TContaReceber>;
  titulo:TContaReceber;
begin
  caixas := FCaixaRepository.getAll;
  try
    // uma caixa fora do ar nao pode impedir a subida das demais
    for caixa in caixas do
    begin
      try
        FContaReceberPDVRepository.garantirColunaNuvem(caixa);

        titulos := FContaReceberPDVRepository.getPendentes(caixa);
        try
          for titulo in titulos do
          begin
            // cupom orfao (sem o cabecalho gravado) nao tem COD_CAIXA: usa o
            // caixa que esta sendo lido.
            if Trim(titulo.caixa) = '' then
              titulo.caixa := caixa.codigo;

            if uAPIRequest.postContaReceber(titulo) then
              FContaReceberPDVRepository.marcarEnviado(caixa, titulo.codigo);
          end;
        finally
          titulos.Free;
        end;
      except
      on E:Exception do
      begin
        uLogErro.LogErro('SUBIDA_CONTA_RECEBER_PDV',
          Format('Caixa %s (%s) | %s: %s', [caixa.codigo, caixa.ip, E.ClassName, E.Message]));
      end;
      end;
    end;
  finally
    caixas.Free;
  end;
end;

end.
