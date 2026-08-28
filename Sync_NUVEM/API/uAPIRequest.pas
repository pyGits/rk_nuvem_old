unit uAPIRequest;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, IdHTTP, VCL.dialogs,uJsonUtils,utils,IdSSLOpenSSL,Cupom,Estoque,NaoFiscal,Fechamento,ContaReceber,uLogErro;

function APIGet(route:string): string;
function APIPost(const route:string;const AJSON: string): string;

function Login(user:string;password:string):Boolean;

function verificaCargaPendente:string;
function finalizaCargaPendente:boolean;
// Alimenta a barra de progresso do painel. E opcional: a carga funciona
// igual se a nuvem nao conhecer essa rota.
procedure informaProgressoCarga(const etapa:string; indice, total:integer);

function getLoja:TStringList;
function getProdutos(alterados:boolean):TStringList;
function getPrecos(alterados:boolean):TStringList;
function getTributacoes(alterados:boolean):TStringList;
function getFinalizadoras(alterados:boolean):TStringList;
function getFuncionarios(alterados:Boolean):TStringList;
function getClientes(alterados:boolean):TStringList;

function postVenda(cupom:TCupom):Boolean;
function postVendaItem(cupomItem:TCupomItem):Boolean;
function postVendaForma(cupomForma:TCupomForma):Boolean;

// Titulo de convenio lido do CUPOM_CREDIARIO de cada PDV.
function postContaReceber(contaReceber:TContaReceber):Boolean;

function postEstoqueMovimentacao(estoqueMovimentacao:TEstoqueMovimentacao):Boolean;
function postNaoFiscal(naoFiscal:TNaoFiscal):Boolean;
function postFechamento(fechamento:TFechamento):boolean;
function postFechamentoForma(fechamentoForma:TFechamentoFin):boolean;

// Subida em lote. Um cupom com 15 itens custa hoje mais de 45 requisicoes
// HTTPS, cada uma com seu handshake TLS; em lote sao 3. Cada funcao devolve em
// 'aceitos' os indices (na lista recebida) que a nuvem confirmou - o agente so
// marca NUVEM = 1 desses.
//
// Result = false significa que o servidor ainda nao tem a rota de lote (404) e
// o chamador deve usar o envio unitario, que continua valendo. E o que permite
// atualizar o agente antes do backend, ou o contrario.
function postVendaLote(cupons:TObjectList<TCupom>; aceitos:TList<Integer>):Boolean;
function postVendaItemLote(itens:TObjectList<TCupomItem>; aceitos:TList<Integer>):Boolean;
function postVendaFormaLote(formas:TObjectList<TCupomForma>; aceitos:TList<Integer>):Boolean;
function postEstoqueMovimentacaoLote(movimentacoes:TObjectList<TEstoqueMovimentacao>; aceitos:TList<Integer>):Boolean;
function postNaoFiscalLote(documentos:TObjectList<TNaoFiscal>; aceitos:TList<Integer>):Boolean;
function postFechamentoLote(fechamentos:TObjectList<TFechamento>; aceitos:TList<Integer>):Boolean;
function postFechamentoFormaLote(formas:TObjectList<TFechamentoFin>; aceitos:TList<Integer>):Boolean;

const
//  API_URL = 'http://localhost:3000/api';
//  API_URL = 'http://vps47862.publiccloud.com.br:3000/api';
  API_URL = 'https://rknuvem.com.br:3000/api';
//  API_URL = 'http://localhost:3000/api';
//  API_URL = 'https://rk-nuvem-back.vercel.app/api';
var
  TOKEN:string = '';
  USER:string = '';
  PASS:string = '';
  codLoja:string = '';
  nomeLoja:string = '';


implementation

const
  // registros por requisicao nas rotas de lote
  LOTE_ENVIO = 200;

var
  // Cliente reaproveitado entre as chamadas. Criar e destruir um TIdHTTP por
  // requisicao, como era feito antes, obriga a um handshake TCP+TLS a cada
  // registro - o que custa centenas de milissegundos por linha e e a maior
  // parte do tempo de subida de uma venda. Mantendo a instancia viva, a
  // conexao TLS e negociada uma vez e reusada.
  FClienteHTTP: TIdHTTP = nil;

  // Servidor que ainda nao tem as rotas de lote responde 404. Uma vez
  // detectado, o agente para de tentar e vai direto ao envio unitario, senao
  // seriam sete requisicoes inuteis a cada ciclo do timer.
  FSemRotaDeLote: Boolean = false;

  // Ultima falha mostrada na tela pela consulta de carga, para nao repetir a
  // mesma linha no memo a cada tique do timer.
  FUltimaFalhaCarga: string = '';

  // Idem para a resposta: o memo mostra a consulta de carga so quando ela muda
  // de resposta, senao seriam doze linhas por minuto sem nenhuma informacao.
  FUltimaRespostaCarga: string = '';

function ObterCliente: TIdHTTP;
var
  IdSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  if not Assigned(FClienteHTTP) then
  begin
    FClienteHTTP := TIdHTTP.Create(nil);
    // O IdSSL pertence ao IdHTTP (Create(FClienteHTTP)), entao sai junto com ele.
    IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(FClienteHTTP);
    IdSSL.SSLOptions.Method := sslvTLSv1_2;
    FClienteHTTP.IOHandler := IdSSL;
    FClienteHTTP.Request.ContentType := 'application/json';
    FClienteHTTP.Request.Connection := 'keep-alive';
    FClienteHTTP.ConnectTimeout := 15000;
    FClienteHTTP.ReadTimeout := 120000;
  end;

  // Values, e nao Add: numa instancia reaproveitada o Add empilharia um
  // x-access-token novo a cada requisicao.
  FClienteHTTP.Request.CustomHeaders.Values['x-access-token'] := TOKEN;

  Result := FClienteHTTP;
end;

procedure DescartarCliente;
begin
  FreeAndNil(FClienteHTTP);
end;

function APIGet(route:string): string;
var
  tentativa: integer;
begin
  tentativa := 0;

  while true do
  begin
    try
      Result := ObterCliente.Get(API_URL+route);
      Exit;
    except
    on E: EIdHTTPProtocolException do
      raise;
    on E: Exception do
    begin
      // A conexao reaproveitada pode ter sido fechada do outro lado enquanto
      // estava ociosa. Descarta o cliente e refaz uma unica vez.
      DescartarCliente;
      Inc(tentativa);
      if tentativa > 1 then
        raise;
    end;
    end;
  end;
end;

function APIPost(const route:string;const AJSON: string): string;
var
  RequestBody: TStringStream;
  tentativa: integer;
begin
  tentativa := 0;

  while true do
  begin
    RequestBody := TStringStream.Create(AJSON, TEncoding.UTF8);
    try
      try
        // A excecao original sobe intacta de proposito. O "raise Exception.Create
        // (E.Message)" que existia aqui trocava a EIdHTTPProtocolException por uma
        // Exception generica e descartava o ErrorMessage - que e onde vem o corpo
        // da resposta. Num 400 o corpo e o proprio motivo da recusa ({"error":...}
        // devolvido pela API), a unica informacao util para saber por que o
        // registro nao subiu.
        Result := ObterCliente.Post(API_URL+route, RequestBody);
        Exit;
      except
      on E: EIdHTTPProtocolException do
        raise;
      on E: Exception do
      begin
        DescartarCliente;
        Inc(tentativa);
        if tentativa > 1 then
          raise;
      end;
      end;
    finally
      RequestBody.Free;
    end;
  end;
end;

// Detalha a excecao para o arquivo de log. Erros de protocolo do Indy trazem o
// status HTTP e o corpo da resposta, que e onde a API informa o motivo real.
function DescreveErro(E: Exception): string;
begin
  if E = nil then
  begin
    Result := 'Erro desconhecido';
    Exit;
  end;

  if E is EIdHTTPProtocolException then
    Result := Format('HTTP %d - %s | resposta: %s',
      [EIdHTTPProtocolException(E).ErrorCode, E.Message,
       EIdHTTPProtocolException(E).ErrorMessage])
  else
    Result := E.ClassName + ': ' + E.Message;
end;

// Uma falha de envio so e diagnosticavel com as tres pontas: qual registro era,
// o que o servidor respondeu e o JSON que saiu daqui. O payload vai truncado
// porque um cupom grande encheria o arquivo sem acrescentar nada.
procedure LogFalhaEnvio(const contexto, identificacao, payload, motivo: string);
begin
  uLogErro.LogErro(contexto,
    identificacao + ' | ' + motivo + ' | enviado: ' + Copy(payload, 1, 500));
end;

function Login(user:string;password:string):Boolean;
var
  jsonResponse:string;
begin
try
  jsonResponse := APIPost('/loginCarga','{"user":"'+user+'", "password":"'+password+'"}');
  TOKEN := GetJsonValue(jsonResponse,'tokenInfinity');
  UTILS.WriteIniString('LOGIN','USER',USER);
  UTILS.WriteIniString('LOGIN','PASS',PASS);
  utils.WriteIniString('TOKEN','TOKEN',TOKEN);
  result := true;
except
on E:Exception do
begin
  result := false;
  uLogErro.LogErro('LOGIN', DescreveErro(E));
  ShowMessage('Usuário ou senha incorreto !' + E.Message);
end;

end;
end;

function getLoja:TStringList;
var
  jsonResponse:string;
begin
  try
    jsonResponse := APIGet('/lojas');
    result := ParseJsonArray(jsonResponse);
  finally

  end;
end;


function getProdutos(alterados:boolean):TStringList;
var
  jsonResponse:string;
begin
  try
    if(alterados) then
    begin
    jsonResponse := APIGet('/produtosComPrecos?alterados=true&loja='+codLoja);
    end
    else
    begin
    jsonResponse := APIGet('/produtosComPrecos?loja='+codLoja);
    end;

    result := ParseJsonArray(jsonResponse);
  finally

  end;

end;

function getPrecos(alterados:boolean):TStringList;
var
  jsonResponse:string;
begin
  try
    if(alterados) then
    begin
    jsonResponse := APIGet('/precos?alterados=true&loja='+codLoja);
    end
    else
    begin
    jsonResponse := APIGet('/precos?loja='+codLoja);
    end;
    result := ParseJsonArray(jsonResponse);
  except
  on E:Exception do
  begin
    raise Exception.Create('Erro'+e.message);
  end;

  end;

end;
function getFinalizadoras(alterados:boolean):TStringList;
var
  jsonResponse:string;
begin
  try
    if(alterados) then
    begin
    jsonResponse := APIGet('/finalizadoras?alterados=true');
    end
    else
    begin
    jsonResponse := APIGet('/finalizadoras');
    end;
    result := ParseJsonArray(jsonResponse);
  finally

  end;

end;
function getTributacoes(alterados:boolean):TStringList;
var
  jsonResponse:string;
begin
  try
    if(alterados) then
    begin
    jsonResponse := APIGet('/tributacao?alterados=true');
    end
    else
    begin
    jsonResponse := APIGet('/tributacao');
    end;
    result := ParseJsonArray(jsonResponse);
  finally

  end;

end;
function getFuncionarios(alterados:boolean):TStringList;
var
  jsonResponse:string;
begin
  try
    if(alterados) then
    begin
    jsonResponse := APIGet('/funcionarios?alterados=true');
    end
    else
    begin
    jsonResponse := APIGet('/funcionarios');
    end;
    result := ParseJsonArray(jsonResponse);
  finally

  end;
end;

function getClientes(alterados:boolean):TStringList;
var
  jsonResponse:string;
begin
  try
    if(alterados) then
    begin
    jsonResponse := APIGet('/clientes');
    end
    else
    begin
    jsonResponse := APIGet('/clientes');
    end;
    result := ParseJsonArray(jsonResponse);
  finally

  end;
end;

function verificaCargaPendente:string;
var
  jsonResponse:string;
  resposta:string;
begin
  try
    result := '';
    resposta := APIGet('/carga/'+codLoja);
    jsonResponse := uJsonUtils.GetJsonValue(resposta,'message');
    result := jsonResponse;

    // Mostra a loja consultada junto da resposta crua. A pergunta e feita por
    // codigo de loja e o servidor procura a carga por esse mesmo codigo: se os
    // dois nao baterem o resultado e um CARGA_NADA eterno, indistinguivel de
    // "nao ha carga pedida" - e sem ver o codigo nao da para saber qual dos
    // dois esta acontecendo.
    if FUltimaRespostaCarga <> resposta then
    begin
      FUltimaRespostaCarga := resposta;
      uLogErro.Progresso(Format('Consulta de carga (loja %s): %s',
        [codLoja, resposta]));
      // Vai para o arquivo tambem, e nao so para o memo: e no arquivo que da
      // para conferir depois se a consulta chegou a acontecer. Sem esta linha,
      // "o timer nao dispara" e "o servidor respondeu CARGA_NADA" ficam
      // indistinguiveis para quem le so o log. So na mudanca de resposta.
      uLogErro.LogErro('CARGA_CONSULTA',
        Format('Loja %s | %s', [codLoja, resposta]));
    end;

    if FUltimaFalhaCarga <> '' then
    begin
      FUltimaFalhaCarga := '';
      uLogErro.Progresso('Consulta de carga voltou a responder.');
    end;
  except
  on E:Exception do
  begin
    result := '';
    uLogErro.LogErro('VERIFICA_CARGA_PENDENTE',
      'Loja ' + codLoja + ' | ' + DescreveErro(E));

    // So no arquivo de log a falha passava despercebida: na tela o agente
    // parecia saudavel (subindo venda normalmente) enquanto a nuvem esperava
    // uma carga que nunca era buscada. Avisa so na mudanca de estado, senao
    // encheria o memo a cada tique.
    if FUltimaFalhaCarga <> E.Message then
    begin
      FUltimaFalhaCarga := E.Message;
      FUltimaRespostaCarga := '';
      uLogErro.Progresso('[ERRO] consulta de carga (loja ' + codLoja + '): ' +
        E.Message);
    end;
  end;

  end;
end;
function finalizaCargaPendente:boolean;
var
  jsonResponse:string;
begin
  try
    result :=false;
    jsonResponse := APIGet('/carga/finalizaCarga?loja='+codLoja);
    result :=True;

  except
  on E:Exception do
  begin
    result := false;
    uLogErro.LogErro('FINALIZA_CARGA_PENDENTE',
      'Loja ' + codLoja + ' | ' + DescreveErro(E));
  end;

  end;
end;

procedure informaProgressoCarga(const etapa:string; indice, total:integer);
var
  jsonResponse:string;
begin
  // Todas as etapas da carga passam por aqui, entao e o ponto unico para a
  // tela do agente acompanhar tambem - nao so o painel da nuvem.
  uLogErro.Progresso(Format('CARGA %d/%d: %s', [indice, total, etapa]));
  uLogErro.Atividade(Format('Carga %d/%d: %s...', [indice, total, etapa]));

  try
    jsonResponse := APIGet('/carga/progresso?loja=' + codLoja +
                           '&etapa=' + etapa +
                           '&indice=' + IntToStr(indice) +
                           '&total=' + IntToStr(total));
  except
    // Progresso e so informativo: se a nuvem nao responder a carga segue, e o
    // painel volta a mostrar o andamento generico.
  end;
end;

function postVenda(cupom:TCupom):Boolean;
var
  venda:string;
  jsonResponse:string;
begin
  try
  cupom.loja := codLoja;
  venda := uJsonUtils.DelphiObjectToJson(cupom);


  jsonResponse := APIPost('/venda',venda);

  if jsonResponse = '{"message":"SINCRONIZADO"}' then
  begin
  result := true;
  end
  else
  begin
    result := false;
    LogFalhaEnvio('POST_VENDA',
        Format('Cupom %s caixa %s', [cupom.codigo, cupom.caixa]),
        venda, 'resposta inesperada: ' + jsonResponse);
  end;
  except
  on E:Exception do
  begin
  result := false;
  LogFalhaEnvio('POST_VENDA',
      Format('Cupom %s caixa %s', [cupom.codigo, cupom.caixa]),
      venda, DescreveErro(E));
  end;

  end;
end;

function postVendaItem(cupomItem:TCupomItem):Boolean;
var
  venda:string;
  jsonResponse:string;
begin
  try
  cupomItem.loja := codLoja;
  venda := uJsonUtils.DelphiObjectToJson(cupomItem);

  jsonResponse := APIPost('/vendaItem',venda);

  if jsonResponse = '{"message":"SINCRONIZADO"}' then
  begin
  result := true;
  end
  else
  begin
    result := false;
    LogFalhaEnvio('POST_VENDA_ITEM',
        Format('Cupom %s item %d caixa %s', [cupomItem.codigo_cupom, cupomItem.item, cupomItem.caixa]),
        venda, 'resposta inesperada: ' + jsonResponse);
  end;
  except
  on E:Exception do
  begin
  result := false;
  LogFalhaEnvio('POST_VENDA_ITEM',
      Format('Cupom %s item %d caixa %s', [cupomItem.codigo_cupom, cupomItem.item, cupomItem.caixa]),
      venda, DescreveErro(E));
  end;

  end;
end;
function postVendaForma(cupomForma:TCupomForma):Boolean;
var
  venda:string;
  jsonResponse:string;
begin
  try
  cupomForma.loja :=codLoja;
  venda := uJsonUtils.DelphiObjectToJson(cupomForma);

  jsonResponse := APIPost('/vendaForma',venda);

  if jsonResponse = '{"message":"SINCRONIZADO"}' then
  begin
  result := true;
  end
  else
  begin
    result := false;
    LogFalhaEnvio('POST_VENDA_FORMA',
        Format('Cupom %s forma %s caixa %s', [cupomForma.codigo_cupom, cupomForma.finalizadora, cupomForma.caixa]),
        venda, 'resposta inesperada: ' + jsonResponse);
  end;
  except
  on E:Exception do
  begin
  result := false;
  LogFalhaEnvio('POST_VENDA_FORMA',
      Format('Cupom %s forma %s caixa %s', [cupomForma.codigo_cupom, cupomForma.finalizadora, cupomForma.caixa]),
      venda, DescreveErro(E));
  end;

  end;
end;

function postContaReceber(contaReceber:TContaReceber):Boolean;
var
  titulo:string;
  jsonResponse:string;
begin
  try
  contaReceber.loja := codLoja;
  titulo := uJsonUtils.DelphiObjectToJson(contaReceber);

  jsonResponse := APIPost('/contaReceber',titulo);

  if jsonResponse = '{"message":"SINCRONIZADO"}' then
  begin
  result := true;
  end
  else
  begin
    result := false;
    LogFalhaEnvio('POST_CONTA_RECEBER',
        Format('Titulo %s cupom %s prestacao %d caixa %s',
          [contaReceber.codigo, contaReceber.codigo_cupom, contaReceber.prestacao, contaReceber.caixa]),
        titulo, 'resposta inesperada: ' + jsonResponse);
  end;
  except
  on E:Exception do
  begin
  result := false;
  LogFalhaEnvio('POST_CONTA_RECEBER',
      Format('Titulo %s cupom %s prestacao %d caixa %s',
        [contaReceber.codigo, contaReceber.codigo_cupom, contaReceber.prestacao, contaReceber.caixa]),
      titulo, DescreveErro(E));
  end;

  end;
end;

function postFechamento(fechamento: TFechamento): Boolean;
var
  venda: string;
  jsonResponse: string;
begin
  try
    fechamento.loja := codLoja;
    venda := uJsonUtils.DelphiObjectToJson(fechamento);

    jsonResponse := APIPost('/fechamento', venda);
    if jsonResponse = '{"message":"SINCRONIZADO"}' then
    begin
      result := true;
    end
    else
    begin
      result := false;
      LogFalhaEnvio('POST_FECHAMENTO',
        Format('Fechamento %s caixa %d', [fechamento.codigo, fechamento.codCaixa]),
        venda, 'resposta inesperada: ' + jsonResponse);
    end;
    except
    on E: Exception do
    begin
//      showmessage(e.Message);
      result := false;
      LogFalhaEnvio('POST_FECHAMENTO',
      Format('Fechamento %s caixa %d', [fechamento.codigo, fechamento.codCaixa]),
      venda, DescreveErro(E));
    end;

  end;
end;
function postFechamentoForma(fechamentoForma:TFechamentoFin):boolean;
var
  venda: string;
  jsonResponse: string;
begin
  try
    fechamentoForma.loja := codLoja;
    venda := uJsonUtils.DelphiObjectToJson(fechamentoForma);

    jsonResponse := APIPost('/fechamentoForma', venda);
    if jsonResponse = '{"message":"SINCRONIZADO"}' then
    begin
      result := true;
    end
    else
    begin
      result := false;
      LogFalhaEnvio('POST_FECHAMENTO_FORMA',
        Format('Fechamento %s finalizadora %s caixa %d', [fechamentoForma.id, fechamentoForma.Finalizadora, fechamentoForma.codCaixa]),
        venda, 'resposta inesperada: ' + jsonResponse);
    end;
    except
    on E: Exception do
    begin
      result := false;
      LogFalhaEnvio('POST_FECHAMENTO_FORMA',
      Format('Fechamento %s finalizadora %s caixa %d', [fechamentoForma.id, fechamentoForma.Finalizadora, fechamentoForma.codCaixa]),
      venda, DescreveErro(E));
    end;

  end;
end;

function postNaoFiscal(naoFiscal:TNaoFiscal):Boolean;
var
  venda:string;
  jsonResponse:string;
begin
  try
    naoFiscal.loja := codLoja;
    venda := uJsonUtils.DelphiObjectToJson(naoFiscal);

    jsonResponse := APIPost('/naoFiscal',venda);

    if jsonResponse = '{"message":"SINCRONIZADO"}' then
    begin
    result := true;
    end
    else
    begin
      result := false;
      LogFalhaEnvio('POST_NAO_FISCAL',
        Format('Documento %s caixa %d', [naoFiscal.codigo, naoFiscal.caixa]),
        venda, 'resposta inesperada: ' + jsonResponse);
    end;
    except
    on E:Exception do
    begin
    result := false;
    LogFalhaEnvio('POST_NAO_FISCAL',
      Format('Documento %s caixa %d', [naoFiscal.codigo, naoFiscal.caixa]),
      venda, DescreveErro(E));
    end;

  end;
end;

function postEstoqueMovimentacao(estoqueMovimentacao:TEstoqueMovimentacao):Boolean;
var
  venda:string;
  jsonResponse:string;
begin
  try
  estoqueMovimentacao.loja := codLoja;
  venda := uJsonUtils.DelphiObjectToJson(estoqueMovimentacao);

  jsonResponse := APIPost('/estoqueMovimentacao',venda);

  if jsonResponse = '{"message":"SINCRONIZADO"}' then
  begin
  result := true;
  end
  else
  begin
    result := false;
    LogFalhaEnvio('POST_ESTOQUE_MOVIMENTACAO',
        Format('Cupom %s item %d produto %s', [estoqueMovimentacao.codigo_cupom, estoqueMovimentacao.item, estoqueMovimentacao.codigo_produto]),
        venda, 'resposta inesperada: ' + jsonResponse);
  end;
  except
  on E:Exception do
  begin
  result := false;
  LogFalhaEnvio('POST_ESTOQUE_MOVIMENTACAO',
      Format('Cupom %s item %d produto %s', [estoqueMovimentacao.codigo_cupom, estoqueMovimentacao.item, estoqueMovimentacao.codigo_produto]),
      venda, DescreveErro(E));
  end;

  end;
end;

// ---------------------------------------------------------------------------
// Subida em lote
// ---------------------------------------------------------------------------

// Envia um bloco ja serializado. Preenche 'aceitos' com os indices confirmados
// (relativos ao bloco) e informa em 'houveFalha' se o bloco nao chegou.
// Result = false apenas quando o servidor nao conhece a rota (404).
function enviarBloco(const rota, corpo, contexto: string; aceitos: TList<Integer>;
  var houveFalha: Boolean): Boolean;
var
  jsonResponse: string;
  rejeitados: string;
begin
  Result := true;
  houveFalha := false;

  try
    jsonResponse := APIPost(rota, corpo);

    if not uJsonUtils.GetJsonIndices(jsonResponse, 'aceitos', aceitos) then
    begin
      // a rota existe mas nao respondeu no formato combinado: nada pode ser
      // marcado como enviado, ou a venda se perde em silencio
      houveFalha := true;
      LogFalhaEnvio(contexto, 'lote', corpo, 'resposta inesperada: ' + jsonResponse);
      Exit;
    end;

    rejeitados := uJsonUtils.GetJsonRaw(jsonResponse, 'rejeitados');
    if (rejeitados <> '') and (rejeitados <> '[]') then
    begin
      houveFalha := true;
      uLogErro.LogErro(contexto, 'recusados pela nuvem: ' + Copy(rejeitados, 1, 1000));
    end;
  except
  on E: EIdHTTPProtocolException do
  begin
    if E.ErrorCode = 404 then
    begin
      if not FSemRotaDeLote then
      begin
        FSemRotaDeLote := true;
        uLogErro.LogErro('SUBIDA_LOTE',
          'Servidor sem a rota ' + rota + ': a subida segue registro a registro. ' +
          'Atualize a nuvem para ganhar o envio em lote.');
      end;

      Result := false;
      Exit;
    end;

    houveFalha := true;
    LogFalhaEnvio(contexto, 'lote', corpo, DescreveErro(E));
  end;
  on E: Exception do
  begin
    houveFalha := true;
    LogFalhaEnvio(contexto, 'lote', corpo, DescreveErro(E));
  end;
  end;
end;

// Quebra a lista em blocos e devolve os indices confirmados, ja convertidos
// para a posicao na lista original.
function postLote(const rota: string; itens: TStringList; aceitos: TList<Integer>;
  const contexto: string): Boolean;
var
  inicio, fim, i: integer;
  bloco: TStringList;
  aceitosBloco: TList<Integer>;
  houveFalha: Boolean;
begin
  if FSemRotaDeLote then
  begin
    Result := false;
    Exit;
  end;

  Result := true;
  inicio := 0;

  while inicio < itens.Count do
  begin
    fim := inicio + LOTE_ENVIO - 1;
    if fim > itens.Count - 1 then
      fim := itens.Count - 1;

    bloco := TStringList.Create;
    aceitosBloco := TList<Integer>.Create;
    try
      for i := inicio to fim do
        bloco.Add(itens[i]);

      uLogErro.Progresso(Format('   enviando %d-%d de %d para %s ...',
        [inicio + 1, fim + 1, itens.Count, rota]));

      if not enviarBloco(rota, uJsonUtils.JuntarJsonArray(bloco), contexto, aceitosBloco, houveFalha) then
      begin
        // servidor sem a rota de lote: o chamador refaz tudo pelo caminho
        // unitario, entao nada do que veio ate aqui pode ser aproveitado
        aceitos.Clear;
        Result := false;
        Exit;
      end;

      for i := 0 to aceitosBloco.Count - 1 do
        aceitos.Add(inicio + aceitosBloco[i]);

      // Bloco inteiro sem nenhum aceite e sinal de nuvem fora do ar ou
      // recusando: insistir nos blocos seguintes so gasta o ciclo. O que
      // sobrou continua com NUVEM = 0 e volta no proximo.
      if houveFalha and (aceitosBloco.Count = 0) then
        Exit;
    finally
      aceitosBloco.Free;
      bloco.Free;
    end;

    inicio := fim + 1;
  end;
end;

function postVendaLote(cupons:TObjectList<TCupom>; aceitos:TList<Integer>):Boolean;
var
  itens: TStringList;
  i: integer;
begin
  itens := TStringList.Create;
  try
    for i := 0 to cupons.Count - 1 do
    begin
      cupons[i].loja := codLoja;
      itens.Add(uJsonUtils.DelphiObjectToJson(cupons[i]));
    end;

    Result := postLote('/venda/lote', itens, aceitos, 'POST_VENDA_LOTE');
  finally
    itens.Free;
  end;
end;

function postVendaItemLote(itens:TObjectList<TCupomItem>; aceitos:TList<Integer>):Boolean;
var
  corpos: TStringList;
  i: integer;
begin
  corpos := TStringList.Create;
  try
    for i := 0 to itens.Count - 1 do
    begin
      itens[i].loja := codLoja;
      corpos.Add(uJsonUtils.DelphiObjectToJson(itens[i]));
    end;

    Result := postLote('/vendaItem/lote', corpos, aceitos, 'POST_VENDA_ITEM_LOTE');
  finally
    corpos.Free;
  end;
end;

function postVendaFormaLote(formas:TObjectList<TCupomForma>; aceitos:TList<Integer>):Boolean;
var
  corpos: TStringList;
  i: integer;
begin
  corpos := TStringList.Create;
  try
    for i := 0 to formas.Count - 1 do
    begin
      formas[i].loja := codLoja;
      corpos.Add(uJsonUtils.DelphiObjectToJson(formas[i]));
    end;

    Result := postLote('/vendaForma/lote', corpos, aceitos, 'POST_VENDA_FORMA_LOTE');
  finally
    corpos.Free;
  end;
end;

function postEstoqueMovimentacaoLote(movimentacoes:TObjectList<TEstoqueMovimentacao>; aceitos:TList<Integer>):Boolean;
var
  corpos: TStringList;
  i: integer;
begin
  corpos := TStringList.Create;
  try
    for i := 0 to movimentacoes.Count - 1 do
    begin
      movimentacoes[i].loja := codLoja;
      corpos.Add(uJsonUtils.DelphiObjectToJson(movimentacoes[i]));
    end;

    Result := postLote('/estoqueMovimentacao/lote', corpos, aceitos, 'POST_ESTOQUE_MOVIMENTACAO_LOTE');
  finally
    corpos.Free;
  end;
end;

function postNaoFiscalLote(documentos:TObjectList<TNaoFiscal>; aceitos:TList<Integer>):Boolean;
var
  corpos: TStringList;
  i: integer;
begin
  corpos := TStringList.Create;
  try
    for i := 0 to documentos.Count - 1 do
    begin
      documentos[i].loja := codLoja;
      corpos.Add(uJsonUtils.DelphiObjectToJson(documentos[i]));
    end;

    Result := postLote('/naoFiscal/lote', corpos, aceitos, 'POST_NAO_FISCAL_LOTE');
  finally
    corpos.Free;
  end;
end;

function postFechamentoLote(fechamentos:TObjectList<TFechamento>; aceitos:TList<Integer>):Boolean;
var
  corpos: TStringList;
  i: integer;
begin
  corpos := TStringList.Create;
  try
    for i := 0 to fechamentos.Count - 1 do
    begin
      fechamentos[i].loja := codLoja;
      corpos.Add(uJsonUtils.DelphiObjectToJson(fechamentos[i]));
    end;

    Result := postLote('/fechamento/lote', corpos, aceitos, 'POST_FECHAMENTO_LOTE');
  finally
    corpos.Free;
  end;
end;

function postFechamentoFormaLote(formas:TObjectList<TFechamentoFin>; aceitos:TList<Integer>):Boolean;
var
  corpos: TStringList;
  i: integer;
begin
  corpos := TStringList.Create;
  try
    for i := 0 to formas.Count - 1 do
    begin
      formas[i].loja := codLoja;
      corpos.Add(uJsonUtils.DelphiObjectToJson(formas[i]));
    end;

    Result := postLote('/fechamentoForma/lote', corpos, aceitos, 'POST_FECHAMENTO_FORMA_LOTE');
  finally
    corpos.Free;
  end;
end;

initialization

finalization
  // fecha a conexao reaproveitada quando o agente encerra
  DescartarCliente;

end.

