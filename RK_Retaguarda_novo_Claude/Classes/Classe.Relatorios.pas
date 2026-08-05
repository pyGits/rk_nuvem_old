unit Classe.Relatorios;



interface
uses
  classe.funcoes;
type TRelatorio = class
  private
    Fcaixa: string;
    FperiodoFinal: Tdate;
    FperiodoInicial: Tdate;

    Fdetalhado: Boolean;
    Fcancelado: Boolean;
    procedure Setcaixa(const Value: string);
    procedure SetperiodoFinal(const Value: Tdate);
    procedure SetperiodoInicial(const Value: Tdate);

    procedure Setdetalhado(const Value: Boolean);
    procedure Setcancelado(const Value: Boolean);
  public
  property caixa:string read Fcaixa write Setcaixa;
  property periodoInicial:Tdate read FperiodoInicial write SetperiodoInicial;
  property periodoFinal:Tdate read FperiodoFinal write SetperiodoFinal;
  property detalhado:Boolean read Fdetalhado write Setdetalhado;
  property cancelado:Boolean read Fcancelado write Setcancelado;
end;

implementation

{ TRelatorios }

procedure TRelatorio.Setcaixa(const Value: string);
var
  caixa:string;
begin
  caixa := Value;
  zeroesquerda(caixa,3);
  Fcaixa := caixa;
end;

procedure TRelatorio.Setcancelado(const Value: Boolean);
begin
  Fcancelado := Value;
end;

procedure TRelatorio.Setdetalhado(const Value: Boolean);
begin
  Fdetalhado := Value;
end;

procedure TRelatorio.SetperiodoFinal(const Value: Tdate);
begin
  FperiodoFinal := Value;
end;

procedure TRelatorio.SetperiodoInicial(const Value: Tdate);
begin
  FperiodoInicial := Value;
end;


end.
