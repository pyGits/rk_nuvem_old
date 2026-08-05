unit Classe.Subgrupo;

interface
uses Classe.Funcoes,Classe.Grupo;
type TSubgrupo = class(TGrupo)

private
    Fcodigo: string;
    FcodigoGrupo: string;
    FDescricao: string;
    procedure Setcodigo(const Value: string);
    procedure SetcodigoGrupo(const Value: string);
    procedure SetDescricao(const Value: string);

public
  property codigo :string read Fcodigo write Setcodigo;
  property codigoGrupo : string read FcodigoGrupo write SetcodigoGrupo;
  property Descricao : string read FDescricao write SetDescricao;

end;

implementation

{ TSubgrupo }

procedure TSubgrupo.Setcodigo(const Value: string);
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

procedure TSubgrupo.SetcodigoGrupo(const Value: string);
var

  codigo : string;
begin
  if (Value = '') or (Value = '000000') then
  begin
    CODIGO := '000000';
  end;

  codigo := zeroEsquerda(Value,6);

  FcodigoGrupo := Codigo;
end;

procedure TSubgrupo.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

end.
