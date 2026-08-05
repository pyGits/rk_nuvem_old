unit Configuracao;

interface
type TConfiguracao = class
  private
    Fvalidade_dias_notificacao: integer;
    Fcaminho_banco_pdv: string;
    procedure Setvalidade_dias_notificacao(const Value: integer);
    procedure Setcaminho_banco_pdv(const Value: string);
  public
    property  validade_dias_notificacao:integer read Fvalidade_dias_notificacao write Setvalidade_dias_notificacao;
    property caminho_banco_pdv:string read Fcaminho_banco_pdv write Setcaminho_banco_pdv;
end;
var
  Configuracoes:TConfiguracao;

implementation

{ TParametros }

procedure TConfiguracao.Setcaminho_banco_pdv(const Value: string);
begin
  Fcaminho_banco_pdv := Value;
end;

procedure TConfiguracao.Setvalidade_dias_notificacao(const Value: integer);
begin
  Fvalidade_dias_notificacao := Value;
end;

initialization

  Configuracoes := TConfiguracao.Create;


end.
