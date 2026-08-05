unit Classe.NCM;


interface

uses
  System.SysUtils;
  type
  TNCM = class
    private
    FNCM: string;
    FdescricaoNCM: string;
    procedure SetdescricaoNCM(const Value: string);


    public
    procedure SetNCM(const Value: string);
    property NCM : string read FNCM write SetNCM;
    property descricaoNCM : string read FdescricaoNCM write SetdescricaoNCM;

  end;

implementation
uses
Classe.funcoes;

{ TNCM }

procedure TNCM.SetdescricaoNCM(const Value: string);
begin
  FdescricaoNCM := Value;
end;

procedure TNCM.SetNCM(const Value: string);
var
  NCM:string;
begin
  NCM := zeroEsquerda(Value,8);
  FNCM := NCM;
end;

end.
