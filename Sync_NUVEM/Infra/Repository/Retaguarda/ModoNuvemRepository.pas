unit ModoNuvemRepository;

interface
uses System.SysUtils, Data.DB, FireDAC.Comp.Client, uConexaoRetaguarda;

// A retaguarda nao tem como saber sozinha que a loja virou nuvem: quem sabe e
// o agente, que e quem fala com o site. Entao e ele quem liga
// CONFIGURACOES.UTILIZA_NUVEM no banco da retaguarda, e so quando a carga
// chega - antes disso a loja ainda cadastra localmente e nada deve mudar.
//
// Com a flag ligada o retaguarda para de abrir as telas de cadastro
// (Classe.ModoNuvem, no RK_Retaguarda_novo_Claude): o que fosse digitado la
// seria sobrescrito pela proxima carga.
type IModoNuvemRepository = interface
  ['{7E4C1D82-3B6A-4F51-9C0D-2A8F5B71E934}']
  // True quando a flag esta gravada. Idempotente: grava uma vez por execucao.
  function marcarModoNuvem: Boolean;
end;

type TModoNuvemRepository = class(TInterfacedObject, IModoNuvemRepository)
  private
    FMarcado: Boolean;
    // Retaguarda desatualizado nao tem a coluna. Sem isso o agente repetiria a
    // mesma linha no log a cada carga.
    FFalhaAvisada: Boolean;
    function colunaExiste: Boolean;
  public
    function marcarModoNuvem: Boolean;
end;

implementation

uses uLogErro;

{ TModoNuvemRepository }

function TModoNuvemRepository.colunaExiste: Boolean;
var
  q: TFDQuery;
begin
  q := TConexao.GetInstance.ExecQuery(
    'SELECT 1 FROM RDB$RELATION_FIELDS ' +
    'WHERE RDB$RELATION_NAME = ''CONFIGURACOES'' ' +
    '  AND RDB$FIELD_NAME = ''UTILIZA_NUVEM''');
  try
    Result := not q.IsEmpty;
  finally
    q.Free;
  end;
end;

function TModoNuvemRepository.marcarModoNuvem: Boolean;
begin
  if FMarcado then Exit(true);

  Result := false;
  try
    // A coluna entra na atualizacao do banco da retaguarda. Enquanto ela nao
    // tiver rodado nao ha o que ligar - e tambem nao ha bloqueio nenhum do
    // outro lado, entao isto nao e erro, e so um aviso no log.
    if not colunaExiste then
    begin
      if not FFalhaAvisada then
      begin
        FFalhaAvisada := true;
        uLogErro.LogErro('MODO_NUVEM',
          'CONFIGURACOES.UTILIZA_NUVEM nao existe no banco da retaguarda. ' +
          'Atualize o retaguarda para que ele passe a bloquear os cadastros locais.');
      end;
      Exit;
    end;

    // UPDATE OR INSERT porque a CONFIGURACOES pode estar vazia em instalacao
    // nova: o registro da retaguarda e sempre o 000001.
    TConexao.GetInstance.ExecSQL(
      'UPDATE OR INSERT INTO CONFIGURACOES (ID, UTILIZA_NUVEM) ' +
      'VALUES (''000001'', 1) MATCHING (ID)');

    FMarcado := true;
    Result := true;
  except
  on E:Exception do
  begin
    if not FFalhaAvisada then
    begin
      FFalhaAvisada := true;
      uLogErro.LogErro('MODO_NUVEM',
        Format('Nao foi possivel marcar a retaguarda como sistema em nuvem | %s: %s',
          [E.ClassName, E.Message]));
    end;
  end;
  end;
end;

end.
