unit Classe.Grupo;

interface

uses
  System.SysUtils;
  type
  TGrupo = class
    private
    Fcodigo: string;
    FDescricao: string;
    procedure Setcodigo(const Value: string);
    procedure SetDescricao(const Value: string);



    public
    property Codigo: string read Fcodigo write Setcodigo;
    property Descricao: string read FDescricao write SetDescricao;


  end;

implementation
uses
Classe.funcoes;

{ TNCM }


{ TGrupo }

procedure TGrupo.Setcodigo(const Value: string);
var
  codigo : string;
begin
  if (Value = '') or (Value = '000000') then
  begin
    CODIGO := '000000';
  end;

  if Length(Value) > 6 then
  begin
  raise Exception.Create('Código não pode ser maior que 6 dígitos !');
  end;
  codigo := zeroEsquerda(Value,6);

  Fcodigo := Codigo;
end;

procedure TGrupo.SetDescricao(const Value: string);
begin
  if Length(Value)>40 then
  begin
    raise Exception.Create('Limite de 30 letras');
  end;
  
  FDescricao := Value;
end;

end.
