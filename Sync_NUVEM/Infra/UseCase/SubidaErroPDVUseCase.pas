unit SubidaErroPDVUseCase;

interface
uses CaixaRepository, CaixaModel, System.Generics.Collections,
     ErroPDVRepository, ErroPDV;

type TSubidaErroPDVUseCase = class
  private
  FCaixaRepository:ICaixaRepository;
  FErroPDVRepository:IErroPDVRepository;
  // Ultimo resumo mostrado, para nao repetir a mesma linha a cada ciclo.
  FUltimoResumo:string;
  public
  procedure Executar;
  constructor create;
end;

implementation

uses System.SysUtils, uAPIRequest, uLogErro;

{ TSubidaErroPDVUseCase }

constructor TSubidaErroPDVUseCase.create;
begin
  FCaixaRepository := TCaixaRepository.create;
  FErroPDVRepository := TErroPDVRepository.create;
end;

// Sobe os erros registrados em cada PDV. Mesmo contrato das demais subidas: le
// o que esta com NUVEM = 0, envia, e so marca NUVEM = 1 quando a nuvem
// confirma - erro que falhou no envio volta no proximo ciclo.
//
// Existe para o suporte enxergar a falha sem depender de alguem no caixa
// perceber e avisar.
procedure TSubidaErroPDVUseCase.Executar;
var
  caixas:TObjectList<TCaixaModel>;
  caixa:TCaixaModel;
  erros:TObjectList<TErroPDV>;
  erro:TErroPDV;
  total:integer;
  enviados:integer;
  resumo:string;
begin
  total := 0;
  enviados := 0;

  caixas := FCaixaRepository.getAll;
  try
    // Um caixa fora do ar nao pode impedir a leitura dos demais.
    for caixa in caixas do
    begin
      try
        FErroPDVRepository.garantirColunas(caixa);

        erros := FErroPDVRepository.getPendentes(caixa);
        try
          Inc(total, erros.Count);

          if erros.Count > 0 then
            uLogErro.Atividade(Format('Enviando erros do caixa %s (%d)...',
              [caixa.codigo, erros.Count]));

          for erro in erros do
          begin
            if uAPIRequest.postErroPDV(erro) then
            begin
              FErroPDVRepository.marcarEnviado(caixa, erro.codigo);
              Inc(enviados);
            end;
          end;
        finally
          erros.Free;
        end;
      except
      on E:Exception do
      begin
        uLogErro.LogErro('SUBIDA_ERRO_PDV',
          Format('Caixa %s (%s) | %s: %s', [caixa.codigo, caixa.ip, E.ClassName, E.Message]));
      end;
      end;
    end;

    // So aparece quando ha o que contar, e so quando muda: no dia a dia esta
    // etapa fica em zero e nao pode encher o memo.
    if total > 0 then
    begin
      resumo := Format('ERRO_PDV: %d encontrado(s), %d enviado(s)', [total, enviados]);
      if resumo <> FUltimoResumo then
      begin
        FUltimoResumo := resumo;
        uLogErro.Progresso(resumo);
      end;
    end;
  finally
    caixas.Free;
  end;
end;

end.
