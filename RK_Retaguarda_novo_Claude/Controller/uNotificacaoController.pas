unit uNotificacaoController;

interface
uses classe.Notificacao,uDmNotificacao,System.Generics.collections;
type TNotificacaoController = class
  private
    function notificacaoEstoque:TObjectList<TNotificacao>;
  public
    function retornarTodasNotificacoes(diasValidadeAlertar:integer):TObjectList<TNotificacao>;
  constructor create;
  destructor destroy;override;
end;

implementation

{ TNotificacaoController }

constructor TNotificacaoController.create;
begin
  dmNotificacao := TdmNotificacao.Create(nil);
end;

destructor TNotificacaoController.destroy;
begin
  dmNotificacao.Destroy;
  inherited;
end;

function TNotificacaoController.notificacaoEstoque: TObjectList<TNotificacao>;
begin
  result := dmNotificacao.notificacaoEstoque;
end;

function TNotificacaoController.retornarTodasNotificacoes(diasValidadeAlertar:integer): TObjectList<TNotificacao>;
var
  noti:TNotificacao;
  notiList:TObjectList<TNotificacao>;
begin
//  notiList := ;

  result := TObjectList<TNotificacao>.create;
  for noti in dmNotificacao.notificacaoEstoque do
  begin
    Result.Add(noti);
  end;

  for noti in dmNotificacao.notificacaoValidade(diasValidadeAlertar) do
  begin
    Result.Add(noti);
  end;


end;

end.
