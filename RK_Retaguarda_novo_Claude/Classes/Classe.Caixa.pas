unit Classe.Caixa;

interface

uses
  System.SysUtils;
  type
  TCaixa = class
    private
    Fcodigo: string;
    FDescricao: string;
    FIP: string;
    procedure Setcodigo(const Value: string);
    procedure SetDescricao(const Value: string);
    procedure SetIP(const Value: string);



    public
    property Codigo: string read Fcodigo write Setcodigo;
    property Descricao: string read FDescricao write SetDescricao;
    property IP:string read FIP write SetIP;


  end;

implementation
uses
Classe.funcoes;

{ TNCM }


{ TCaixa }

procedure TCaixa.Setcodigo(const Value: string);
var
  codigo : string;
begin
  if (Value = '') or (Value = '000000') then
  begin
    CODIGO := '000000';
  end;

  codigo := zeroEsquerda(Value,6);

  Fcodigo := Codigo;
end;

procedure TCaixa.SetDescricao(const Value: string);
begin
  if Length(Value)>30 then
  begin
    raise Exception.Create('Limite de 30 letras');
  end;

  FDescricao := Value;
end;

procedure TCaixa.SetIP(const Value: string);
begin
  FIP := Value;
end;

end.
