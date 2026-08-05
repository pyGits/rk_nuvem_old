unit Classe.Funcoes;

interface
  uses INIFiles, Winapi.Windows ,vcl.forms,System.SysUtils,System.classes,System.Character,System.Math;




    function Ret_Numero(Key: Char; Texto: string; EhDecimal: Boolean = False): Char;
    // Remove todas as letras em string, retornando somente numeros
    function removeLetras(valor : string):string;
    // remove acentos de string
    function RemoveAcento(const pText: string): string;
    // Acrescenta 0 a esquerda em strings ex 123 00000123
    function zeroEsquerda(valor : string;qtde:integer):string;
    function removeZeroEsquerda(numero:string):string;
    // Gravar e ler arquivos ini
    function LerIni(sArquivo, Secao, Linha: string; Def: string): string;
    procedure GravaIni(sArquivo, Secao, Linha, Valor: string);
    //Função explit separar por delimitador
    function Split(Expression:string; Delimiter:string): TArray<String>;overload;
    // Criptograva string, C = Criptogravar D = Descriptogravar
    Function Cript(Action, Src: String): String;

    //RETORNA QUANTIDADE
    function retornaQuantidade(sCodigo:string):double;
    function ContarLetras(Str: String): integer;

    // data
    function diferencaDias(data1,data2:tdatetime):integer;
    function adicionarDiasData(data:TDate;dias:Integer):TDate;
    function validarData(data:string):Boolean;


    // Criar string do código de cupom
    function codifica_cupom(NumeroCupom:string): string;
    function codifica_item(item: Integer;numeroCupom:string): string;
    function codifica_forma(idForma: Integer;numeroCupom:string): string;
    function codifica_crediario(idPrestacao: Integer;numeroCupom:string): string;
    function codifica_crediario_pagamento(idPrestacao: Integer;numeroCupom:string): string;
    function codifica_prevenda_item(item: Integer;numeroCupom:string): string;


    // Funções de conversão
    function converterStringFloat(sString: string): Double;
    function converterFloatString(rFloat: real): string;

    function IntToBool(aValue : integer):Boolean;
    function BoolToInt(aValue : boolean):integer;

    // Gravar log em txt
    procedure criaLog(log: string);
    Function CompletaStr(Conteudo, Caractere: string; Tamanho: Integer): string;
    Function ReplicaString(C: string; Tamanho: Integer): string;


    // validação
  function ValidaCNPJ(pCNPJ:string):Boolean;
  function ValidaCPF(pCPF:string):Boolean;




implementation
{ TFuncoes }

function adicionarDiasData(data:TDate;dias:Integer):TDate;
begin
  result := data + dias;
end;

function diferencaDias(data1, data2: tdatetime): integer;
begin
  result:=Round(data2-data1)+1;
end;

function ValidaCPF(pCPF:string):Boolean;
var  dig10, dig11: string;
    s, i, r, peso: integer;
begin
// length - retorna o tamanho da string (pCPF é um número formado por 11 dígitos)
  if ((pCPF = '00000000000') or (pCPF = '11111111111') or
      (pCPF = '22222222222') or (pCPF = '33333333333') or
      (pCPF = '44444444444') or (pCPF = '55555555555') or
      (pCPF = '66666666666') or (pCPF = '77777777777') or
      (pCPF = '88888888888') or (pCPF = '99999999999') or
      (length(pCPF) <> 11))
     then begin
              result := false;
              exit;
            end;

// try - protege o código para eventuais erros de conversão de tipo na função StrToInt
  try
{ *-- Cálculo do 1o. Digito Verificador --* }
    s := 0;
    peso := 10;
    for i := 1 to 9 do
    begin
// StrToInt converte o i-ésimo caractere do pCPF em um número
      s := s + (StrToInt(pCPF[i]) * peso);
      peso := peso - 1;
    end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11))
       then dig10 := '0'
    else str(r:1, dig10); // converte um número no respectivo caractere numérico

{ *-- Cálculo do 2o. Digito Verificador --* }
    s := 0;
    peso := 11;
    for i := 1 to 10 do
    begin
      s := s + (StrToInt(pCPF[i]) * peso);
      peso := peso - 1;
    end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11))
       then dig11 := '0'
    else str(r:1, dig11);

{ Verifica se os digitos calculados conferem com os digitos informados. }
    if ((dig10 = pCPF[10]) and (dig11 = pCPF[11]))
       then result := true
    else result := false;
  except
    result := false
  end;
end;

function ValidaCNPJ(pCNPJ:string):Boolean;
var
  v: array[1..2] of Word;
  cnpj: array[1..14] of Byte;
  I: Byte;
begin
  Result := False;

  { Verificando se tem 11 caracteres }
  if Length(pCNPJ) <> 14 then
  begin
    Exit;
  end;

  { Conferindo se todos dígitos são iguais }
  if pCNPJ = StringOfChar('0', 14) then
    Exit;

  if pCNPJ = StringOfChar('1', 14) then
    Exit;

  if pCNPJ = StringOfChar('2', 14) then
    Exit;

  if pCNPJ = StringOfChar('3', 14) then
    Exit;

  if pCNPJ = StringOfChar('4', 14) then
    Exit;

  if pCNPJ = StringOfChar('5', 14) then
    Exit;

  if pCNPJ = StringOfChar('6', 14) then
    Exit;

  if pCNPJ = StringOfChar('7', 14) then
    Exit;

  if pCNPJ = StringOfChar('8', 14) then
    Exit;

  if pCNPJ = StringOfChar('9', 14) then
    Exit;

  try
    for I := 1 to 14 do
      cnpj[i] := StrToInt(pCNPJ[i]);

    //Nota: Calcula o primeiro dígito de verificação.
    v[1] := 5*cnpj[1] + 4*cnpj[2]  + 3*cnpj[3]  + 2*cnpj[4];
    v[1] := v[1] + 9*cnpj[5] + 8*cnpj[6]  + 7*cnpj[7]  + 6*cnpj[8];
    v[1] := v[1] + 5*cnpj[9] + 4*cnpj[10] + 3*cnpj[11] + 2*cnpj[12];
    v[1] := 11 - v[1] mod 11;
    v[1] := IfThen(v[1] >= 10, 0, v[1]);

    //Nota: Calcula o segundo dígito de verificação.
    v[2] := 6*cnpj[1] + 5*cnpj[2]  + 4*cnpj[3]  + 3*cnpj[4];
    v[2] := v[2] + 2*cnpj[5] + 9*cnpj[6]  + 8*cnpj[7]  + 7*cnpj[8];
    v[2] := v[2] + 6*cnpj[9] + 5*cnpj[10] + 4*cnpj[11] + 3*cnpj[12];
    v[2] := v[2] + 2*v[1];
    v[2] := 11 - v[2] mod 11;
    v[2] := IfThen(v[2] >= 10, 0, v[2]);

    //Nota: Verdadeiro se os dígitos de verificação são os esperados.
    Result := ((v[1] = cnpj[13]) and (v[2] = cnpj[14]));
  except on E: Exception do
    Result := False;
  end;
end;

function validarData(data:string):Boolean;
begin
  try
    StrToDate(data);
    result := True;
  except
    result := false;
  end;
end;
function Ret_Numero(Key: Char; Texto: string; EhDecimal: Boolean = False): Char;
begin
  if  not EhDecimal then

    begin

      { Chr(8) = Back Space }

      if  not ( Key in ['0'..'9', Chr(8)] ) then

          Key := #0



    end

  else

    begin

      if  Key = #46 then

          Key := Formatsettings.DecimalSeparator;


      if  not ( Key in ['0'..'9', Chr(8), Formatsettings.DecimalSeparator] ) then

          Key := #0

      else

        if  ( Key = Formatsettings.DecimalSeparator ) and ( Pos( Key, Texto ) > 0 ) then

            Key := #0;

      ;

    end

  ;


  Result := Key;
end;

function RemoveAcento(const pText: string): string;
type
  USAscii20127 = type AnsiString(20127);
begin
  Result := string(USAscii20127(pText));
end;

function removeLetras(valor: string): string;
var
I: integer;
S: string;
begin
  S := '';
  for I := 1 To Length(valor) Do
  begin
  if (valor[I] in ['0'..'9']) then
  begin
  S := S + Copy(valor, I, 1);
  end;
  end;
  result := S;
end;

function zeroEsquerda(valor: string;qtde:integer): string;
begin
  // Remove vírgula e ponto, se existirem
  valor := StringReplace(valor, ',', '', [rfReplaceAll]);
  valor := StringReplace(valor, '.', '', [rfReplaceAll]);

  // Completa com zeros à esquerda até atingir o tamanho desejado
  while Length(valor) < qtde do
    valor := '0' + valor;

  Result := valor;
//  while length(valor) < qtde do
//    valor := '0' + valor;
//  Result := valor;
end;
function removeZeroEsquerda(numero:string):string;
var i : integer;
begin
   while numero[ 1 ] = '0' do
      Delete( numero, 1, 1 );

result := numero;
end;

function LerIni(sArquivo, Secao, Linha: string; Def: string): string;
var
  Ini: TIniFile;
begin

  Ini := TIniFile.Create(sArquivo);
  Result := Ini.ReadString(Secao, Linha, Def);
  Ini.Free;
end;

procedure GravaIni(sArquivo, Secao, Linha, Valor: string);
var
  Ini: TIniFile;
  Arquivo: string;
begin

  Arquivo := sArquivo;
  Ini := TIniFile.Create(Arquivo);
  Ini.WriteString(Secao, Linha, Valor);
  Ini.Free;

end;
function Split(Expression:string; Delimiter:string): TArray<String>;
      var
  Res:        TArray<String>;
  ResCount:   DWORD;
  dLength:    DWORD;
  StartIndex: DWORD;
  sTemp:      string;
begin
dLength := Length(Expression);
  StartIndex := 1;
  ResCount := 0;
  repeat
    sTemp := Copy(Expression, StartIndex, Pos(Delimiter, Copy(Expression, StartIndex, Length(Expression))) - 1);
    SetLength(Res, Length(Res) + 1);
    SetLength(Res[ResCount], Length(sTemp));
    Res[ResCount] := sTemp;
    StartIndex := StartIndex + Length(sTemp) + Length(Delimiter);
    ResCount := ResCount + 1;
  until StartIndex > dLength;
  Result := Res;
end;

function Cript(Action, Src: String): String;
Label Fim;
var
  KeyLen: Integer;
  KeyPos: Integer;
  OffSet: Integer;
  Dest, key: String;
  SrcPos: Integer;
  SrcAsc: Integer;
  TmpSrcAsc: Integer;
  Range: Integer;
begin
  if (Src = '') Then
  begin
    Result := '';
    Goto Fim;
  end;
  key := 'YUQL23K1PIUF90AERVNNMKH02NMIHJ12042 E18XM01HIBQAS150AVDOUYQA90UD1APSA12POIENC1K3210N0419RTIKJ';

  Dest := '';
  KeyLen := length(key);
  KeyPos := 0;
  SrcPos := 0;
  SrcAsc := 0;
  Range := 256;
  if (Action = UpperCase('C')) then
  begin
    Randomize;
    OffSet := Random(Range);
    Dest := Format('%1.2x', [OffSet]);
    for SrcPos := 1 to length(Src) do
    begin
      application.ProcessMessages;
      SrcAsc := (Ord(Src[SrcPos]) + OffSet) Mod 255;
      if KeyPos < KeyLen then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;
      SrcAsc := SrcAsc Xor Ord(key[KeyPos]);
      Dest := Dest + Format('%1.2x', [SrcAsc]);
      OffSet := SrcAsc;
    end;
  end
  Else if (Action = UpperCase('D')) then
  begin
    OffSet := StrToInt('$' + Copy(Src, 1, 2));
    SrcPos := 3;
    repeat
      SrcAsc := StrToInt('$' + Copy(Src, SrcPos, 2));
      if (KeyPos < KeyLen) Then
        KeyPos := KeyPos + 1
      else
        KeyPos := 1;
      TmpSrcAsc := SrcAsc Xor Ord(key[KeyPos]);
      if TmpSrcAsc <= OffSet then
        TmpSrcAsc := 255 + TmpSrcAsc - OffSet
      else
        TmpSrcAsc := TmpSrcAsc - OffSet;
      Dest := Dest + Chr(TmpSrcAsc);
      OffSet := SrcAsc;
      SrcPos := SrcPos + 2;
    until (SrcPos >= length(Src));
  end;
  Result := Dest;
Fim:
end;

function codifica_cupom(numeroCupom:string): string;
begin
  Result := zeroEsquerda('', 20) + // numero de serie do ecf
    zeroEsquerda('', 3) + // numero do caixao do ecf
    zeroEsquerda(numeroCupom, 12); // numero do cupom fiscal
end;
function codifica_item(item: Integer;numeroCupom:string): string;
begin
  Result := zeroEsquerda('', 20) + // numero de serie do ecf
    zeroEsquerda('', 3) + // numero do caixao do ecr
    zeroEsquerda(numeroCupom, 12) + // numero do cupom fiscal
    zeroEsquerda(inttostr(item), 3); // numero do item
end;
function codifica_prevenda_item(item: Integer;numeroCupom:string): string;
begin
  Result := zeroEsquerda('', 20) + // numero de serie do ecf
    zeroEsquerda('', 3) + // numero do caixao do ecr
    zeroEsquerda(numeroCupom, 12) + // numero do cupom fiscal
    zeroEsquerda(inttostr(item), 3); // numero do item
end;
function codifica_forma(idForma: Integer;numeroCupom:string): string;
begin
  Result := zeroEsquerda('', 20) + // numero de serie do ecf
    zeroEsquerda('', 3) + // numero do caixao do ecr
    zeroEsquerda(numeroCupom, 12) + // numero do cupom fiscal
    zeroEsquerda(inttostr(idForma), 3); // numero do item
end;
function codifica_crediario(idPrestacao: Integer;numeroCupom:string): string;
begin
  Result := zeroEsquerda('', 20) + // numero de serie do ecf
    zeroEsquerda('', 3) + // numero do caixao do ecr
    zeroEsquerda(numeroCupom, 12) + // numero do cupom fiscal
    zeroEsquerda(inttostr(idPrestacao), 3); // numero do item
end;
function codifica_crediario_pagamento(idPrestacao: Integer;numeroCupom:string): string;
begin
  Result :=  // numero de serie do ecf
    numeroCupom + zeroEsquerda(inttostr(idPrestacao), 3); // numero do item
end;

function converterStringFloat(sString: string): Double;
begin
  try
    Result := StrToFloat(sString);
  except
  on E:Exception do
  begin
    Crialog('Erro na conversão de string para float: '+ E.Message);
    Result := 0;
  end;
  end;
end;
function converterFloatString(rFloat: real): string;
begin
  try
    Result := FloatToStr(rFloat);
  except
  on E:Exception do
  begin
    Crialog('Erro na conversão de float para string: '+ E.Message);
    Result := '0';
  end;
  end;
end;

procedure criaLog(log: string);
var
    txtLog : TextFile;
begin
  AssignFile(txtLog,ExtractFilePath(Application.ExeName) + '\logPdv.txt');
    if FileExists(ExtractFilePath(Application.ExeName) + '\logPdv.txt') then
    begin
        Append(txtLog);
        Writeln(txtLog, FormatDateTime('dd/mm/YY hh:mm:ss - ', now) + log);
        CloseFile(txtLog);
    end

    else
    begin
        Rewrite(txtLog);
    Writeln(txtLog, FormatDateTime('dd/mm/YY hh:mm:ss - ', now) + log);
    CloseFile(txtLog);
    end;


end;
    function IntToBool(aValue : integer):Boolean;
    begin
    if aValue = 1 then result := true else result := false;
    end;
    function BoolToInt(aValue : boolean):integer;
    begin
    if aValue = true then result := 1 else result := 0;
    end;

    function retornaQuantidade(sCodigo:string):double;
    var
      iPosicao: integer;
    begin

    if (pos('X', ansiuppercase(sCodigo)) > 0) or(pos('*', ansiuppercase(sCodigo)) > 0) then
    begin
      iPosicao := pos('X', ansiuppercase(sCodigo));
      if iPosicao = 0 then
        iPosicao := pos('*', ansiuppercase(sCodigo));
      try
        // alimenta a varivel de qtde
        result := Strtofloat(copy(sCodigo, 1, iPosicao - 1));
        // copia apenas a parte que contem a informacao da busca do produto
        sCodigo := copy(sCodigo, iPosicao + 1, 99);
      except
        // retornou erro, zera a qtde e deixa a referencia como estah.
        result := 1;
      end;

    end
    else
    begin
        result := 1;
    end;

    end;
    Function ReplicaString(C: string; Tamanho: Integer): string;
    var
      Conteudo: string;
      Contar: Integer;
    begin
      Conteudo := '';
      for Contar := 1 to Tamanho do
      begin
        Conteudo := Conteudo + C;
        Application.ProcessMessages;
      end;
      ReplicaString := Conteudo;
    end;

    Function CompletaStr(Conteudo, Caractere: string; Tamanho: Integer): string;
    begin
      Result := Copy(Conteudo, 1, Tamanho) + ReplicaString(Caractere,
        (Tamanho - length(Conteudo)));
    end;

    function ContarLetras(Str: String): integer;
var
  umChar: char;
begin
  result := 0;
  for umChar in Str do
    if IsLetter(umChar) then
      Inc(result);
end;
end.

