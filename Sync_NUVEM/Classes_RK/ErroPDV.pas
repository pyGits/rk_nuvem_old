unit ErroPDV;

interface

// Erro registrado na tabela ERROS de um PDV, enviado para a nuvem para o
// suporte enxergar de fora sem precisar entrar no caixa.
//
// Mesmas regras de serializacao do TContaReceber (uJsonUtils.DelphiObjectToJson):
// data e TDate, nunca string - o RTTI emite dd/mm/yyyy, que e o formato que o
// backend converte.
type TErroPDV = class
  private
    Floja: string;
    Fcodigo: integer;
    Fcaixa: integer;
    Foperador: integer;
    Fdata: TDate;
    Fhora: string;
    Ferro: string;
    Forigem: string;
    procedure Setloja(const Value: string);
    procedure Setcodigo(const Value: integer);
    procedure Setcaixa(const Value: integer);
    procedure Setoperador(const Value: integer);
    procedure Setdata(const Value: TDate);
    procedure Sethora(const Value: string);
    procedure Seterro(const Value: string);
    procedure Setorigem(const Value: string);
  published
    property loja: string read Floja write Setloja;
    // Identifica a linha no PDV para o agente marcar NUVEM = 1 depois do envio.
    property codigo: integer read Fcodigo write Setcodigo;
    property caixa: integer read Fcaixa write Setcaixa;
    property operador: integer read Foperador write Setoperador;
    property data: TDate read Fdata write Setdata;
    property hora: string read Fhora write Sethora;
    property erro: string read Ferro write Seterro;
    property origem: string read Forigem write Setorigem;
end;

implementation

{ TErroPDV }

procedure TErroPDV.Setloja(const Value: string);
begin
  Floja := Value;
end;

procedure TErroPDV.Setcodigo(const Value: integer);
begin
  Fcodigo := Value;
end;

procedure TErroPDV.Setcaixa(const Value: integer);
begin
  Fcaixa := Value;
end;

procedure TErroPDV.Setoperador(const Value: integer);
begin
  Foperador := Value;
end;

procedure TErroPDV.Setdata(const Value: TDate);
begin
  Fdata := Value;
end;

procedure TErroPDV.Sethora(const Value: string);
begin
  Fhora := Value;
end;

procedure TErroPDV.Seterro(const Value: string);
begin
  Ferro := Value;
end;

procedure TErroPDV.Setorigem(const Value: string);
begin
  Forigem := Value;
end;

end.
