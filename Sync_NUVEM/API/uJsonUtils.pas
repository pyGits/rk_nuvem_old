unit uJsonUtils;


interface
uses
System.Classes,System.Rtti,System.SysUtils,System.Generics.Collections,VCL.dialogs;

function GetJsonValue(const AJson: string; const AKeyName: string): string;
function ParseJsonArray(JsonArray: string): TStringList;

function DelphiObjectToJson(obj: TObject): string;
function ConverterDecimalPTBRParaAmericano(const Valor: string): string;

// Suporte a subida em lote: monta o array que vai no corpo da requisicao e le
// de volta os indices que a nuvem confirmou.
function JuntarJsonArray(const itens: TStringList): string;
function GetJsonIndices(const AJson, AKeyName: string; destino: TList<Integer>): Boolean;
function GetJsonRaw(const AJson, AKeyName: string): string;
implementation

uses
  System.JSON;

  function ConverterDecimalPTBRParaAmericano(const Valor: string): string;
var
  novoValor:string;
begin
  novoValor := StringReplace(Valor,',','.',[rfReplaceAll,rfIgnoreCase]);
  result := novoValor;
end;

function GetJsonValue(const AJson: string; const AKeyName: string): string;
var
  JSONValue: TJSONValue;
  JSONPair: TJSONPair;
begin
  Result := '';
  JSONValue := TJSONObject.ParseJSONValue(AJson);
  try
    if JSONValue <> nil then
    begin
      JSONPair := (JSONValue as TJSONObject).Get(AKeyName);
      if JSONPair <> nil then
      begin
        Result := JSONPair.JsonValue.Value;
      end;
    end;
  finally
    JSONValue.Free;
  end;
end;


function ParseJsonArray(JsonArray: string): TStringList;
var
  JArray: TJSONArray;
  I: Integer;
begin
  Result := TStringList.Create;
  JArray := TJSONObject.ParseJSONValue(JsonArray) as TJSONArray;
  if not Assigned(JArray) then Exit;
  try
    for I := 0 to JArray.Count - 1 do
    begin
      // ToString so escapa aspas: barra invertida no texto (ex: "SLIM 35\36")
      // saia crua e o item virava json invalido no proximo parse. ToJSON
      // reserializa escapando \, aspas e controles.
      Result.Add(JArray.Items[I].ToJSON);
    end;
  finally
    JArray.Free;
  end;
end;




function DelphiObjectToJson(obj: TObject): string;
var
  ctx: TRttiContext;
  objType: TRttiType;
  prop: TRttiProperty;
  propValue: TValue;
  jsonObj: TJSONObject;
begin
  jsonObj := TJSONObject.Create;
  try
    objType := ctx.GetType(obj.ClassType);

    for prop in objType.GetProperties do
    begin
      propValue := prop.GetValue(obj);

      if propValue.IsObject then
      begin
        jsonObj.AddPair(prop.Name, TJSONString.Create(DelphiObjectToJson(propValue.AsObject)));
      end
      else if propValue.IsArray then
      begin
        // Not supported in this example
      end
      else
      begin
        if propValue.IsEmpty then
          jsonObj.AddPair(prop.Name, TJSONNull.Create)
        else
        begin
          if (prop.PropertyType.ToString = 'Real') then
          begin
            jsonObj.AddPair(prop.Name, ConverterDecimalPTBRParaAmericano(propValue.ToString));
          end
          else
          begin
            // Campos de outros tipos (como string) permanecem inalterados
            jsonObj.AddPair(prop.Name, propValue.ToString);
          end;
        end;
      end;
    end;

    Result := jsonObj.ToString;
  finally
    jsonObj.Free;
  end;
end;

// Cada item ja e um objeto json pronto, vindo do DelphiObjectToJson. Aqui so
// se monta o array, sem reserializar nada.
function JuntarJsonArray(const itens: TStringList): string;
var
  sb: TStringBuilder;
  i: integer;
begin
  sb := TStringBuilder.Create;
  try
    sb.Append('[');
    for i := 0 to itens.Count - 1 do
    begin
      if i > 0 then
        sb.Append(',');
      sb.Append(itens[i]);
    end;
    sb.Append(']');

    Result := sb.ToString;
  finally
    sb.Free;
  end;
end;

// Le um array de inteiros da resposta ("aceitos":[0,1,2]). Devolve false
// quando a chave nao existe ou nao e um array - a resposta nao e a esperada e
// o chamador nao pode marcar nada como enviado.
function GetJsonIndices(const AJson, AKeyName: string; destino: TList<Integer>): Boolean;
var
  JSONValue: TJSONValue;
  JSONPair: TJSONPair;
  JSONArray: TJSONArray;
  numero: integer;
  i: integer;
begin
  Result := false;

  JSONValue := TJSONObject.ParseJSONValue(AJson);
  if not Assigned(JSONValue) then Exit;

  try
    if not (JSONValue is TJSONObject) then Exit;

    JSONPair := TJSONObject(JSONValue).Get(AKeyName);
    if not Assigned(JSONPair) then Exit;
    if not (JSONPair.JsonValue is TJSONArray) then Exit;

    JSONArray := TJSONArray(JSONPair.JsonValue);
    for i := 0 to JSONArray.Count - 1 do
      if TryStrToInt(JSONArray.Items[i].Value, numero) then
        destino.Add(numero);

    Result := true;
  finally
    JSONValue.Free;
  end;
end;

// Devolve o valor de uma chave como json cru, para registrar no log o que a
// nuvem recusou sem precisar interpretar campo a campo.
function GetJsonRaw(const AJson, AKeyName: string): string;
var
  JSONValue: TJSONValue;
  JSONPair: TJSONPair;
begin
  Result := '';

  JSONValue := TJSONObject.ParseJSONValue(AJson);
  if not Assigned(JSONValue) then Exit;

  try
    if not (JSONValue is TJSONObject) then Exit;

    JSONPair := TJSONObject(JSONValue).Get(AKeyName);
    if Assigned(JSONPair) then
      Result := JSONPair.JsonValue.ToJSON;
  finally
    JSONValue.Free;
  end;
end;

end.

