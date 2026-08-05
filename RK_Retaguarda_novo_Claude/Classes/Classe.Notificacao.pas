unit Classe.Notificacao;

interface

type TNotificacao = class
  private
    Ftipo: string;
    Fmensagem: string;
    Fcodigo: string;
    procedure Settipo(const Value: string);
    procedure Setmensagem(const Value: string);
    procedure Setcodigo(const Value: string);
  published
  property tipo:string read Ftipo write Settipo;
  property mensagem:string read Fmensagem write Setmensagem;
  property codigo:string read Fcodigo write Setcodigo;

end;

implementation

{ TNotificacao }

procedure TNotificacao.Setcodigo(const Value: string);
begin
  Fcodigo := Value;
end;

procedure TNotificacao.Setmensagem(const Value: string);
begin
  Fmensagem := Value;
end;

procedure TNotificacao.Settipo(const Value: string);
begin
  Ftipo := Value;
end;

end.
