unit Classe.ModoNuvem;

// Sistema em nuvem: a partir do momento em que a loja passa a usar o site,
// quem manda nos cadastros e a nuvem. O RK_Sync liga CONFIGURACOES.UTILIZA_NUVEM
// no banco da retaguarda na primeira carga que desce (ModoNuvemRepository, no
// Sync_NUVEM) e o retaguarda para de abrir as telas de cadastro: o que fosse
// digitado aqui seria sobrescrito pela proxima carga.
//
// Instalacao que nao usa nuvem nunca recebe carga, entao a flag fica em 0 e
// nada muda - o nivel de acesso continua mandando sozinho.

interface

uses Classe.Variaveis;

const
  // Categoria da RETAGUARDA_NIVEL que deixa de ser editada localmente.
  CATEGORIA_CADASTRO = 'CADASTRO';

  // "Proprio" sao os dados da propria loja, cadastro local que nao vem da
  // nuvem - continua liberado mesmo em modo nuvem.
  NIVEL_PROPRIO = '000010';

  MSG_MODO_NUVEM = 'Sistema em nuvem ativado, cadastre através do sistema WEB rknuvem.com.br';

function ModoNuvemAtivo: Boolean;

// Recebe a categoria e o codigo do registro da RETAGUARDA_NIVEL do menu que
// esta sendo aberto.
function BloqueadoPeloModoNuvem(const categoria, codigoNivel: string): Boolean;

implementation

uses System.SysUtils;

function ModoNuvemAtivo: Boolean;
begin
  Result := false;

  if not Assigned(VariaveisSrv) then Exit;
  if not Assigned(VariaveisSrv.oConfiguracoes) then Exit;

  if VariaveisSrv.oConfiguracoes.UtilizaNuvem then
  begin
    // Uma vez em nuvem nao se volta atras sozinho: nao ha por que reconsultar.
    Result := true;
    Exit;
  end;

  // A configuracao e lida uma vez, na abertura do retaguarda, mas quem liga a
  // flag e o RK_Sync no meio do expediente. Sem esta releitura o retaguarda so
  // respeitaria a nuvem na proxima vez que fosse aberto.
  if not Assigned(VariaveisSrv.oUtilsController) then Exit;

  Result := VariaveisSrv.oUtilsController.ModoNuvemAtivoBD;
  VariaveisSrv.oConfiguracoes.UtilizaNuvem := Result;
end;

function BloqueadoPeloModoNuvem(const categoria, codigoNivel: string): Boolean;
begin
  // Categoria antes de ModoNuvemAtivo de proposito: so o cadastro e bloqueado,
  // e assim relatorio, exportacao e o resto do menu nem chegam a consultar o
  // banco enquanto a loja nao for nuvem.
  Result := SameText(Trim(categoria), CATEGORIA_CADASTRO) and
            (Trim(codigoNivel) <> NIVEL_PROPRIO) and
            ModoNuvemAtivo;
end;

end.
