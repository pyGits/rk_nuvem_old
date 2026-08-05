unit Notificacao;


interface
uses System.Generics.collections;

type TNotificacao = class
  private

    Fmensagem: string;
    Ftitulo: string;
    Fformulario: string;
    Fcodigo: string;

    procedure Setmensagem(const Value: string);
    procedure Settitulo(const Value: string);
    procedure Setformulario(const Value: string);
    procedure Setcodigo(const Value: string);
  public
  property titulo:string read Ftitulo write Settitulo;
  property mensagem:string read Fmensagem write Setmensagem;
  property codigo:string read Fcodigo write Setcodigo;
  property formulario:string read Fformulario write Setformulario;
end;

type TNotificacaoList = class
  private
    FLista:TList<TNotificacao>;
  public
    constructor create;
    procedure adicionar(ANotificacao:TNotificacao);
    procedure adicionarLista(ANotificacaoLista:TList<TNotificacao>);

    function lista:TList<TNotificacao>;
    function filtrarPorFormulario(AFormulario:string):TList<TNotificacao>;

end;

implementation

{ TNotificacao }


procedure TNotificacao.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TNotificacao.Setformulario(const Value: string);
begin
  Fformulario := Value;
end;

procedure TNotificacao.Setmensagem(const Value: string);
begin
  Fmensagem := Value;
end;

procedure TNotificacao.Settitulo(const Value: string);
begin
  Ftitulo := Value;
end;

{ TNotificacaoList }

procedure TNotificacaoList.adicionar(ANotificacao: TNotificacao);
begin
FLista.Add(ANotificacao);
end;

procedure TNotificacaoList.adicionarLista(
  ANotificacaoLista: TList<TNotificacao>);
begin
FLista.AddRange(ANotificacaoLista);
end;

constructor TNotificacaoList.create;
begin
FLista := TList<TNotificacao>.create;
end;

function TNotificacaoList.filtrarPorFormulario(
  AFormulario: string): TList<TNotificacao>;
  var
    notificacao:TNotificacao;
begin
  result := TList<TNotificacao>.create;
  for notificacao in FLista do
  begin
    if (notificacao.formulario = AFormulario) or (AFormulario = 'Todos') then
    begin
      result.Add(notificacao);
    end;
  end;

end;

function TNotificacaoList.lista: TList<TNotificacao>;
begin
result := FLista;
end;

end.
