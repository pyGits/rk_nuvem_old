unit uStringUtils;

interface
type TStringUtils = class
  class function PreencherEspacos(const ATexto: string; Tam: Integer): string;
end;

implementation

{ TStringUtils }

class function TStringUtils.PreencherEspacos(const ATexto: string;
  Tam: Integer): string;
begin
  if Length(ATexto) >= Tam then
    Result := Copy(ATexto, 1, Tam)       // pega só os primeiros Tam caracteres
  else
    Result := ATexto + StringOfChar(' ', Tam - Length(ATexto)); // completa com espaços
end;

end.
