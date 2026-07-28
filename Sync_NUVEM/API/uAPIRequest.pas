unit uAPIRequest;

interface

uses
  System.SysUtils, System.Classes, IdHTTP, VCL.dialogs,uJsonUtils,utils,IdSSLOpenSSL,Cupom,Estoque,NaoFiscal,Fechamento,uLogErro;

function APIGet(route:string): string;
function APIPost(const route:string;const AJSON: string): string;

function Login(user:string;password:string):Boolean;

function verificaCargaPendente:string;
function finalizaCargaPendente:boolean;

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
  RequestBody := TStringStream.Create(AJSON, TEncoding.UTF8);
  IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
  try
    IdHTTP.Request.ContentType := 'application/json';
    IdSSL.SSLOptions.Method := sslvTLSv1_2; // configura para usar a versão 1.2 do protocolo TLS
    IdHTTP.IOHandler := IdSSL; // atribui o handler SSL/TLS para o TIdHTTP
    IdHTTP.Request.CustomHeaders.Add('x-access-token: '+TOKEN);
    Result := IdHTTP.Post(API_URL+route, RequestBody);
  except
  on E:Exception do
  begin
    raise Exception.Create(e.Message);
  end;
//    IdSSL.Free; // libera o handler SSL/TLS após o uso
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
    uLogErro.LogErro('POST_VENDA',
      Format('Cupom %s caixa %s | resposta inesperada: %s',
        [cupom.codigo, cupom.caixa, jsonResponse]));
  end;
  except
  on E:Exception do
  begin
  result := false;
  uLogErro.LogErro('POST_VENDA',
    Format('Cupom %s caixa %s | %s',
      [cupom.codigo, cupom.caixa, DescreveErro(E)]));
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
    uLogErro.LogErro('POST_VENDA_ITEM',
      Format('Cupom %s item %d caixa %s | resposta inesperada: %s',
        [cupomItem.codigo_cupom, cupomItem.item, cupomItem.caixa, jsonResponse]));
  end;
  except
  on E:Exception do
  begin
  result := false;
  uLogErro.LogErro('POST_VENDA_ITEM',
    Format('Cupom %s item %d caixa %s | %s',
      [cupomItem.codigo_cupom, cupomItem.item, cupomItem.caixa, DescreveErro(E)]));
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
    uLogErro.LogErro('POST_VENDA_FORMA',
      Format('Cupom %s forma %s caixa %s | resposta inesperada: %s',
        [cupomForma.codigo_cupom, cupomForma.finalizadora, cupomForma.caixa, jsonResponse]));
  end;
  except
  on E:Exception do
  begin
  result := false;
  uLogErro.LogErro('POST_VENDA_FORMA',
    Format('Cupom %s forma %s caixa %s | %s',
      [cupomForma.codigo_cupom, cupomForma.finalizadora, cupomForma.caixa, DescreveErro(E)]));
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
      uLogErro.LogErro('POST_FECHAMENTO',
        Format('Fechamento %s caixa %d | resposta inesperada: %s',
          [fechamento.codigo, fechamento.codCaixa, jsonResponse]));
    end;
    except
    on E: Exception do
    begin
//      showmessage(e.Message);
      result := false;
      uLogErro.LogErro('POST_FECHAMENTO',
        Format('Fechamento %s caixa %d | %s',
          [fechamento.codigo, fechamento.codCaixa, DescreveErro(E)]));
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
      uLogErro.LogErro('POST_FECHAMENTO_FORMA',
        Format('Fechamento %s finalizadora %s caixa %d | resposta inesperada: %s',
          [fechamentoForma.id, fechamentoForma.Finalizadora, fechamentoForma.codCaixa, jsonResponse]));
    end;
    except
    on E: Exception do
    begin
      result := false;
      uLogErro.LogErro('POST_FECHAMENTO_FORMA',
        Format('Fechamento %s finalizadora %s caixa %d | %s',
          [fechamentoForma.id, fechamentoForma.Finalizadora, fechamentoForma.codCaixa, DescreveErro(E)]));
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
      uLogErro.LogErro('POST_NAO_FISCAL',
        Format('Documento %s caixa %d | resposta inesperada: %s',
          [naoFiscal.codigo, naoFiscal.caixa, jsonResponse]));
    end;
    except
    on E:Exception do
    begin
    result := false;
    uLogErro.LogErro('POST_NAO_FISCAL',
      Format('Documento %s caixa %d | %s',
        [naoFiscal.codigo, naoFiscal.caixa, DescreveErro(E)]));
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
    uLogErro.LogErro('POST_ESTOQUE_MOVIMENTACAO',
      Format('Cupom %s item %d produto %s | resposta inesperada: %s',
        [estoqueMovimentacao.codigo_cupom, estoqueMovimentacao.item,
         estoqueMovimentacao.codigo_produto, jsonResponse]));
  end;
  except
  on E:Exception do
  begin
  result := false;
  uLogErro.LogErro('POST_ESTOQUE_MOVIMENTACAO',
    Format('Cupom %s item %d produto %s | %s',
      [estoqueMovimentacao.codigo_cupom, estoqueMovimentacao.item,
       estoqueMovimentacao.codigo_produto, DescreveErro(E)]));
  end;

  end;
end;
end.

