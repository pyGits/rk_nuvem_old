unit Classe.Finalizadora;

interface
uses Classe.Funcoes,pcnConversao;
type TFinalizadora = class
  private
    Fespecie: integer;
    Fdescricao: string;
    Fcodigo: string;
    Ftipo: string;
    Fcod99: integer;
    FListaFinalizadora:array[1..99] of TFinalizadora;
    FEspecieACBR: TpcnCodigoMP;

    procedure Setcod99(const Value: integer);
    procedure Setcodigo(const Value: string);
    procedure Setdescricao(const Value: string);
    procedure Setespecie(const Value: integer);
    procedure Settipo(const Value: string);
    function GetListaFinalizadora(AIndex: Integer): TFinalizadora;
    procedure SetListaFinalizadora(AIndex: Integer; const Value: TFinalizadora);
    procedure SetEspecieACBR(const Value: TpcnCodigoMP);

  public
  property codigo:string read Fcodigo write Setcodigo;
  property descricao:string read Fdescricao write Setdescricao;
  property especie:integer read Fespecie write Setespecie;
  property tipo:string read Ftipo write Settipo;
  property cod99:integer read Fcod99 write Setcod99;

  property EspecieACBR:TpcnCodigoMP read FEspecieACBR write SetEspecieACBR;

  property ListaFinalizadora[AIndex:Integer]: TFinalizadora read GetListaFinalizadora write SetListaFinalizadora;

  function CountListaFinalizadora:integer;

  constructor create;
  destructor destroy;override;


end;

implementation

{ TFinalizadora }


function TFinalizadora.CountListaFinalizadora: integer;
var
  I: Integer;
begin
  Result := 0;
  for I := Low(FListaFinalizadora) to High(FListaFinalizadora) do
    if FListaFinalizadora[I] <> nil then
      Inc(Result);
end;

constructor TFinalizadora.create;
begin

end;

destructor TFinalizadora.destroy;
begin

  inherited;
end;

function TFinalizadora.GetListaFinalizadora(AIndex: Integer): TFinalizadora;
begin
Result := FListaFinalizadora[AIndex];
end;

procedure TFinalizadora.Setcod99(const Value: integer);
begin
  Fcod99 := Value;
end;

procedure TFinalizadora.Setcodigo(const Value: string);
var
  CODIGO:string;
begin
  CODIGO := zeroEsquerda(Value,3);
  FCODIGO := CODIGO;
end;

procedure TFinalizadora.Setdescricao(const Value: string);
begin
  Fdescricao := Value;
end;

procedure TFinalizadora.Setespecie(const Value: integer);
begin
case value of
1:begin
  EspecieACBR := mpDinheiro;
end;
4:begin
  EspecieACBR := mpCartaodeDebito;
end;
3:begin
  EspecieACBR := mpCartaodeCredito;
end;
5:begin
  EspecieACBR := mpCreditoLoja;
end;
10:begin
  EspecieACBR := mpValeAlimentacao;
end;
else begin
  EspecieACBR := mpDinheiro;
end;


end;
  Fespecie := Value;
end;

procedure TFinalizadora.SetEspecieACBR(const Value: TpcnCodigoMP);
begin
  FEspecieACBR := Value;
end;

procedure TFinalizadora.SetListaFinalizadora(AIndex: Integer;
  const Value: TFinalizadora);
begin
FListaFinalizadora[AIndex] := Value;
end;

procedure TFinalizadora.Settipo(const Value: string);
begin
  Ftipo := Value;
end;

end.
