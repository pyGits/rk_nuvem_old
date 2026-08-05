unit NotificacaoRepository;

interface

uses System.Generics.Collections, Notificacao,RKConnection,FireDAC.Comp.Client,System.SysUtils,Configuracao;
type TNotificacaoRepository = class
  private
  function NotificacaoNFCe:TNotificacao;
  function NotificacaoEstoque:TNotificacao;
  function NotificacaoValidade:TNotificacao;
  function NotificacaoClienteAniversario:TNotificacao;

  function NotificacaoEstoqueDetalhada:TList<TNotificacao>;
  function NotificacaoValidadeDetalhada:TList<TNotificacao>;
  function NotificacaoAniversarioClienteDetalhada:TList<TNotificacao>;

  public

  function CarregarTodasNotificacoes:TList<TNotificacao>;
  function CarregarTodasNotificacoesDetalhadas:TNotificacaoList;
end;
  var
    Notificacao_Repository : TNotificacaoRepository;
implementation

{ TNotificacaoRepository }

function TNotificacaoRepository.CarregarTodasNotificacoes: TList<TNotificacao>;
begin
  result := TList<TNotificacao>.create;
  Result.Add(NotificacaoNFCe);
  Result.Add(NotificacaoEstoque);
  Result.Add(NotificacaoValidade);
  Result.Add(NotificacaoClienteAniversario);
end;

function TNotificacaoRepository.CarregarTodasNotificacoesDetalhadas: TNotificacaoList;
begin
  result := TNotificacaoList.create;
  Result.adicionarLista(NotificacaoEstoqueDetalhada);
  result.adicionarLista(NotificacaoValidadeDetalhada);
  Result.adicionarLista(NotificacaoAniversarioClienteDetalhada);
end;

function TNotificacaoRepository.NotificacaoAniversarioClienteDetalhada: TList<TNotificacao>;
var
  query:TFdQuery;
begin
  result := TList<TNotificacao>.create;
  query := RKConn.GetQuery('SELECT * FROM cliente WHERE EXTRACT(DAY FROM data_nascimento) = EXTRACT(DAY FROM CURRENT_DATE)  AND  EXTRACT(MONTH FROM data_nascimento) = EXTRACT(MONTH FROM CURRENT_DATE)');
  query.Open;
  while not query.Eof do
  begin
    result.Add(TNotificacao.create);
    Result.Last.titulo := 'Data Aniversário';
    Result.Last.mensagem := 'Cliente: '+ query.FieldByName('CODIGO').AsString +' - '+ query.FieldByName('NOME').AsString+  ' Faz aniversário hoje !';
    result.Last.formulario := 'Cliente';
  result.Last.codigo :=query.FieldByName('CODIGO').AsString ;
    query.Next;
  end;
end;

function TNotificacaoRepository.NotificacaoClienteAniversario: TNotificacao;
var
  query:TFdQuery;
begin
  result := TNotificacao.create;
  query := RKConn.GetQuery('SELECT count(*) FROM cliente WHERE EXTRACT(DAY FROM data_nascimento) = EXTRACT(DAY FROM CURRENT_DATE)  AND  EXTRACT(MONTH FROM data_nascimento) = EXTRACT(MONTH FROM CURRENT_DATE)');
  query.Open;
  result.mensagem := 'Existem '+ query.fieldbyname('COUNT').asstring + ' Clientes com aniversário hoje ! ';
  result.titulo := 'Aniversário Cliente';
  result.formulario := 'Form_Cliente';
end;

function TNotificacaoRepository.NotificacaoEstoque: TNotificacao;
var
  query:TFdQuery;
begin
  result := TNotificacao.create;
  query := RKConn.GetQuery('select count(*) from produto where estoque <= estoque_minimo');
  query.Open;
  result.mensagem := 'Existem '+ query.fieldbyname('COUNT').asstring + ' Produtos com estoque mínimo';
  result.titulo := 'Estoque Mínimo';
  result.formulario := 'Form_Produto';
end;

function TNotificacaoRepository.NotificacaoEstoqueDetalhada: TList<TNotificacao>;
var
  query:TFdQuery;
begin
  result := TList<TNotificacao>.create;
  query := RKConn.GetQuery('select * from produto where estoque <= estoque_minimo');
  query.Open;
  while not query.Eof do
  begin
    result.Add(TNotificacao.create);
    Result.Last.titulo := 'Estoque Mínimo';
    Result.Last.mensagem := 'Produto: '+ query.FieldByName('CODIGO').AsString + ' com estoque mínimo';
    result.Last.formulario := 'Produto';
    result.Last.codigo :=query.FieldByName('CODIGO').AsString ;
    query.Next;
  end;
end;

function TNotificacaoRepository.NotificacaoNFCe: TNotificacao;
var
  query:TFdQuery;
begin
  result := TNotificacao.create;

  query := RKConn.GetQuery('SELECT count(*) FROM nfce_pendente WHERE status = :status');
  query.ParamByName('status').AsString := 'PE';
  query.Open;

  result.mensagem := 'Existem '+ query.fieldbyname('COUNT').asstring + ' Notas Pendentes De Envio !';
  result.titulo := 'Notas Fiscais';
end;

function TNotificacaoRepository.NotificacaoValidade: TNotificacao;
var
  query:TFdQuery;
begin
  result := TNotificacao.create;

  query := RKConn.GetQuery('SELECT count(*) FROM validade WHERE validade <= CURRENT_DATE+'+inttostr(Configuracoes.validade_dias_notificacao));
  query.Open;

  result.mensagem := 'Existem '+ query.fieldbyname('COUNT').asstring + ' Produtos próximos ao vencimento';
  result.titulo := 'Validade';
  result.formulario := 'Validade';
end;

function TNotificacaoRepository.NotificacaoValidadeDetalhada: TList<TNotificacao>;
var
  query:TFdQuery;
begin
  result := TList<TNotificacao>.create;

  query := RKConn.GetQuery('SELECT * FROM validade WHERE validade <= CURRENT_DATE+'+inttostr(Configuracoes.validade_dias_notificacao));
  query.Open;

  while not query.Eof do
  begin
  result.Add(TNotificacao.create);
  result.last.mensagem := 'Produto: '+ query.FieldByName('CODIGO_PRODUTO').AsString + ' Próximo ao vencimento !';
  result.last.titulo := 'Validade';
  result.last.formulario := 'Validade';
  result.Last.codigo :=query.FieldByName('CODIGO_PRODUTO').AsString ;
  query.Next;
  end;


end;

initialization
  Notificacao_Repository := TNotificacaoRepository.create;

end.
