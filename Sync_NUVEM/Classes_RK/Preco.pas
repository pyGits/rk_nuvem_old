unit Preco;
interface
uses
  system.SysUtils,Funcoes,system.JSON,rest.json;
 type TPreco = class
  private
    Fpreco: Real;
    Fmarkup: Real;
    Fcusto: Real;
    Fcodigo_produto: string;
    Foferta: Real;
    procedure Setcodigo_produto(const Value: string);
    procedure Setcusto(const Value: Real);
    procedure Setmarkup(const Value: Real);
    procedure Setpreco(const Value: Real);
    procedure Setoferta(const Value: Real);
  public
  property codigo_produto:string read Fcodigo_produto write Setcodigo_produto;
  property preco:Real read Fpreco write Setpreco;
  property markup:Real read Fmarkup write Setmarkup;
  property custo:Real read Fcusto write Setcusto;
  property oferta:Real read Foferta write Setoferta;

  function JsonToPreco(const AJson: string): TPreco;
end;
implementation

{ TPreco }

function TPreco.JsonToPreco(const AJson: string): TPreco;
var
  LJsonObj: TJSONObject;
  LPreco: TPreco;
begin
  LJsonObj := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
  try
    LPreco := TJson.JsonToObject<TPreco>(AJson);
    LPreco.preco := StrToFloat(LJsonObj.GetValue('preco').Value);
    LPreco.markup := StrToFloat(LJsonObj.GetValue('markup').Value);
    LPreco.custo := StrToFloat(LJsonObj.GetValue('custo').Value);
    LPreco.codigo_produto := LJsonObj.GetValue('codigo_produto').Value;

    Result := LPreco;
  finally
    LJsonObj.Free;
  end;
end;

procedure TPreco.Setcodigo_produto(const Value: string);
var
  CodigoBarras : string;
begin
  if (Value = '') then
  begin
    raise Exception.Create('Código de barras não pode ser em branco!');
  end;
  if Length(value)> 14 then
  begin
    raise Exception.Create('Limite de 14 caracteres!');
  end;

  CodigoBarras := Value;
  CodigoBarras := removeLetras(CodigoBarras);
  CodigoBarras := zeroEsquerda(CodigoBarras,6);

  Fcodigo_produto := CodigoBarras;
end;

procedure TPreco.Setcusto(const Value: Real);
begin
  Fcusto := Value;
end;

procedure TPreco.Setmarkup(const Value: Real);
begin
  Fmarkup := Value;
end;

procedure TPreco.Setoferta(const Value: Real);
begin
  Foferta := Value;
end;

procedure TPreco.Setpreco(const Value: Real);
begin
  Fpreco := Value;
end;

end.
