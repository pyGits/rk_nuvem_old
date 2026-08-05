unit Classe.Relatorio;



interface
uses
  classe.funcoes,conversao;
type TRelatorio = class
  private
    Fcaixa: string;
    FperiodoFinal: Tdate;
    FperiodoInicial: Tdate;

    Fdetalhado: Boolean;
    Fcancelado: Boolean;
    Ftipo: TTipoRelatorio;
    Ffiscal: integer;
    Fordenar: TOrdenarRelatorio;
    Ffiltro1: string;
    FListaCheckBox1 : array[0..10] of Boolean;
    FListaString1 : array [0..10] of string;
    FitemIndex: Integer;
    FitemIndex2: Integer;
    FitemIndex1: Integer;
    Fvalor1: Currency;

    procedure Setcaixa(const Value: string);
    procedure SetperiodoFinal(const Value: Tdate);
    procedure SetperiodoInicial(const Value: Tdate);

    procedure Setdetalhado(const Value: Boolean);
    procedure Setcancelado(const Value: Boolean);
    procedure Settipo(const Value: TTipoRelatorio);
    procedure Setfiscal(const Value: integer);
    procedure Setordenar(const Value: TOrdenarRelatorio);
    procedure Setfiltro1(const Value: string);
    function GetlistaCheckBox1(iIndex: integer): Boolean;
    procedure SetlistaCheckBox1(iIndex: integer; const Value: Boolean);
    function GetlistaString1(iIndex: integer): string;
    procedure SetlistaString1(iIndex: integer; const Value: string);
    procedure SetitemIndex(const Value: Integer);
    procedure SetitemIndex1(const Value: Integer);
    procedure SetitemIndex2(const Value: Integer);
    procedure Setvalor1(const Value: Currency);

  public
  property tipo :TTipoRelatorio read Ftipo write Settipo;
  property caixa:string read Fcaixa write Setcaixa;
  property periodoInicial:Tdate read FperiodoInicial write SetperiodoInicial;
  property periodoFinal:Tdate read FperiodoFinal write SetperiodoFinal;
  property detalhado:Boolean read Fdetalhado write Setdetalhado;
  property cancelado:Boolean read Fcancelado write Setcancelado;
  property fiscal:integer read Ffiscal write Setfiscal;
  property ordenar:TOrdenarRelatorio read Fordenar write Setordenar;

  property filtro1:string read Ffiltro1 write Setfiltro1;
  property valor1:Currency read Fvalor1 write Setvalor1;
  property itemIndex:Integer read FitemIndex write SetitemIndex;
  property itemIndex1:Integer read FitemIndex1 write SetitemIndex1;
  property itemIndex2:Integer read FitemIndex2 write SetitemIndex2;


  property listaCheckBox1[iIndex:integer] : Boolean read GetlistaCheckBox1 write SetlistaCheckBox1;
  property listaString1[iIndex:integer] : string read GetlistaString1 write SetlistaString1;
end;

implementation
uses
System.SysUtils;

{ TRelatorios }

function TRelatorio.GetlistaCheckBox1(iIndex: integer): Boolean;
begin
Result := FListaCheckBox1[iIndex];
end;

function TRelatorio.GetlistaString1(iIndex: integer): string;
begin
Result := FListaString1[iIndex];
end;

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

procedure TRelatorio.Setfiltro1(const Value: string);
begin
  Ffiltro1 := Value;
end;

procedure TRelatorio.Setfiscal(const Value: integer);
begin
  Ffiscal := Value;
end;

procedure TRelatorio.SetitemIndex(const Value: Integer);
begin
  FitemIndex := Value;
end;

procedure TRelatorio.SetitemIndex1(const Value: Integer);
begin
  FitemIndex1 := Value;
end;

procedure TRelatorio.SetitemIndex2(const Value: Integer);
begin
  FitemIndex2 := Value;
end;

procedure TRelatorio.SetlistaCheckBox1(iIndex: integer; const Value: Boolean);
begin
FListaCheckBox1[IIndex] := Value;
end;

procedure TRelatorio.SetlistaString1(iIndex: integer; const Value: string);
begin
FListaString1[iIndex] := Value;
end;

procedure TRelatorio.Setordenar(const Value: TOrdenarRelatorio);
begin
  Fordenar := Value;
end;

procedure TRelatorio.SetperiodoFinal(const Value: Tdate);
begin
  if value < FPeriodoInicial then
  begin
    raise Exception.Create('Data final menor que data inicial');
  end;
  
  FperiodoFinal := Value;
end;

procedure TRelatorio.SetperiodoInicial(const Value: Tdate);
begin
  FperiodoInicial := Value;
end;


procedure TRelatorio.Settipo(const Value: TTipoRelatorio);
begin
  Ftipo := Value;
end;

procedure TRelatorio.Setvalor1(const Value: Currency);
begin
  Fvalor1 := Value;
end;

end.
