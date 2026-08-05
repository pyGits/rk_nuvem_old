unit NFcePendenteRepository;

interface
uses NFCePendente,System.Generics.collections,RKConnection,FireDAC.Comp.Client;
type TNFcePendenteRepository = class
  function ObterNFCePendente(dtInicio:TDate;dtFim:TDate;status:string):TObjectList<TNFcePendente>;
  procedure AtualizarRetorno(nfce:TNFCePendente);
end;

var
  NFCePendente_Repository:TNFcePendenteRepository;

implementation

{ TNFcePendenteRepository }

procedure TNFcePendenteRepository.AtualizarRetorno(nfce: TNFCePendente);
var
  query:TFDQuery;
begin
query := RKConn.GetQuery('update nfce_pendente set retorno = :retorno , status = :status,chave=:chave where chave= :chave');
query.ParamByName('retorno').AsString := nfce.retorno;
query.ParamByName('chave').AsString := nfce.chave;

if nfce.retorno = 'ENVIADO' then
begin
query.ParamByName('status').AsString := 'OK';
end
else
begin
query.ParamByName('status').AsString := 'PE';
end;


query.ExecSQL;
end;

function TNFcePendenteRepository.ObterNFCePendente(dtInicio,
  dtFim: TDate;status:string): TObjectList<TNFcePendente>;
var
  query:TFDQuery;
  qr:string;
begin
qr := 'select * from nfce_pendente inner join cupom on cupom.codigo= nfce_pendente.codigo_cupom and cupom.cancelado = 0 where nfce_pendente.data >= :dtInicio ';
qr := qr + 'and nfce_pendente.data <= :dtFim and nfce_pendente.status=:status order by nfce_pendente.data, nfce_pendente.hora desc';
query := RKConn.GetQuery(qr);
query.ParamByName('dtInicio').AsDate := dtInicio;
query.ParamByName('dtFim').AsDate := dtFim;
query.ParamByName('status').AsString := status;
query.Open;
result := TObjectList<TNFCePendente>.create;

while not query.eof do
begin
  with query do
  begin
  Result.Add(TNFCePendente.create);
  result.Last.codigo_cupom := FieldByName('CODIGO_CUPOM').AsString;
  result.Last.cod_caixa := FieldByName('COD_CAIXA').AsInteger;
  result.Last.data := FieldByName('data').AsDateTime;
  result.Last.hora := FieldByName('HORA').AsDateTime;
  result.Last.xml := FieldByName('XML').asstring;
  result.Last.status := FieldByName('STATUS').AsString;
  result.Last.chave := FieldByName('chave').AsString;
  result.Last.total := FieldByName('TOTAL').AsFloat;
  result.Last.retorno := FieldByName('RETORNO').AsString;
  query.Next;
  end;
end;
end;
initialization
  NFCePendente_Repository:=TNFcePendenteRepository.Create;

end.
