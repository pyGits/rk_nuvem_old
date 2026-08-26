unit uAPIRequest;

interface

uses
  System.SysUtils, System.Classes, IdHTTP, VCL.dialogs,uJsonUtils,utils,IdSSLOpenSSL,Cupom,Estoque,NaoFiscal,Fechamento,ContaReceber,uLogErro;

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

function APIGet(route:string): string;
var
  IdHTTP: TIdHTTP;
  IdSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  IdHTTP := TIdHTTP.Create(nil);

  try
    IdHTTP.Request.ContentType := 'application/json';
    IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
    IdSSL.SSLOptions.Method := sslvTLSv1_2; // configura para usar a versão 1.2 do protocolo TLS
    IdHTTP.IOHandler := IdSSL; // atribui o handler SSL/TLS para o TIdHTTP

    IdHTTP.Request.CustomHeaders.Add('x-access-token: '+TOKEN);
    Result := IdHTTP.Get(API_URL+route);
  finally
    IdHTTP.Free;
  end;
end;

function APIPost(const route:string;const AJSON: string): string;
var
  IdSSL: TIdSSLIOHandlerSocketOpenSSL;
  IdHTTP: TIdHTTP;
  RequestBody: TStringStream;
begin
  IdHTTP := TIdHTTP.Create(nil);
  try
    RequestBody := TStringStream.Create(AJSON, TEncoding.UTF8);
    try
      // O IdSSL pertence ao IdHTTP (Create(IdHTTP)), entao sai junto com ele.
      IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
      IdHTTP.Request.ContentType := 'application/json';
      IdSSL.SSLOptions.Method := sslvTLSv1_2; // configura para usar a versão 1.2 do protocolo TLS
      IdHTTP.IOHandler := IdSSL; // atribui o handler SSL/TLS para o TIdHTTP
      IdHTTP.Request.CustomHeaders.Add('x-access-token: '+TOKEN);

      // A excecao original sobe intacta de proposito. O "raise Exception.Create
      // (E.Message)" que existia aqui trocava a EIdHTTPProtocolException por uma
      // Exception generica e descartava o ErrorMessage - que e onde vem o corpo
      // da resposta. Num 400 o corpo e o proprio motivo da recusa ({"error":...}
      // devolvido pela API), a unica informacao util para saber por que o
      // registro nao subiu.
      Result := IdHTTP.Post(API_URL+route, RequestBody);
    finally
      RequestBody.Free;
    end;
  finally
    // O codigo anterior nao liberava nem o stream nem o IdHTTP: cada POST
    // vazava os dois, e o agente fica postando o dia inteiro.
    IdHTTP.Free;
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
begin
  try
    result := '';
    jsonResponse := APIGet('/carga/'+codLoja);
    jsonResponse := uJsonUtils.GetJsonValue(jsonResponse,'message');
    result := jsonResponse;
  except
  on E:Exception do
  begin
    result := '';
    uLogErro.LogErro('VERIFICA_CARGA_PENDENTE',
      'Loja ' + codLoja + ' | ' + DescreveErro(E));
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
end.

