unit Classe.CEST;

interface

uses
  System.SysUtils;
  type
  TCEST = class
    private
    FDescricao: string;
    FCEST: string;
    FNCM: string;
    procedure SetCEST(const Value: string);
    procedure SetDescricao(const Value: string);
    procedure SetNCM(const Value: string);

    public
    property CEST:string read FCEST write SetCEST;
    property NCM:string read FNCM write SetNCM;
    property Descricao:string read FDescricao write SetDescricao;

  end;

implementation
uses
Classe.funcoes;

{ TCEST }



{ TCEST }

procedure TCEST.SetCEST(const Value: string);
var
  CEST:string;
begin
  CEST := zeroEsquerda(Value,7);
  FCEST := CEST;
end;

procedure TCEST.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TCEST.SetNCM(const Value: string);
var
  NCM:string;
begin
  NCM := zeroEsquerda(Value,8);
  FNCM := NCM;
end;

end.
