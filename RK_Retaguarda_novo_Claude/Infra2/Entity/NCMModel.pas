unit NCMModel;

interface
type TNCMModel = class
  private
    Festadual: real;
    Fdescricao: string;
    Fnacional: real;
    Fncm: string;
    procedure Setdescricao(const Value: string);
    procedure Setestadual(const Value: real);
    procedure Setnacional(const Value: real);
    procedure Setncm(const Value: string);
  public
  property ncm:string read Fncm write Setncm;
  property descricao:string read Fdescricao write Setdescricao;
  property nacional:real read Fnacional write Setnacional;
  property estadual:real read Festadual write Setestadual;
end;

implementation
uses system.SysUtils,helpers;

{ TNCMModel }

procedure TNCMModel.Setdescricao(const Value: string);
begin
  Fdescricao := Value.Corta(100);
end;

procedure TNCMModel.Setestadual(const Value: real);
begin
  Festadual := Value;
end;

procedure TNCMModel.Setnacional(const Value: real);
begin
  Fnacional := Value;
end;

procedure TNCMModel.Setncm(const Value: string);
var
  NCM: string;
begin
  if Value.RemoveLetras() = '' then
    raise Exception.Create('NCM não pode estar em branco!');

  NCM := Value.RemoveLetras.ZeroEsquerda(8);

  if Length(NCM) <> 8 then
    raise Exception.Create('NCM deve ter exatamente 8 dígitos!');

  Fncm := NCM;
end;

end.
