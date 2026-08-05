unit Classe.Funcoes;

interface
  uses INIFiles, Winapi.Windows ,vcl.forms,System.SysUtils,System.classes,System.Character;

    // Remove todas as letras em string, retornando somente numeros
    function removeLetras(valor : string):string;
    // Acrescenta 0 a esquerda em strings ex 123 00000123
    function zeroEsquerda(valor : string;qtde:integer):string;
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


    // Criar string do código de cupom
    function codifica_cupom(NumeroCupom:string): string;
    function codifica_item(item: Integer;numeroCupom:string): string;
    function codifica_forma(idForma: Integer;numeroCupom:string): string;
    function codifica_crediario(idPrestacao: Integer;numeroCupom:string): string;


    // Funções de conversão
    function converterStringFloat(sString: string): Double;
    function converterFloatString(rFloat: real): string;

    function IntToBool(aValue : integer):Boolean;
    function BoolToInt(aValue : boolean):integer;

    // Gravar log em txt
    procedure criaLog(log: string);
    Function CompletaStr(Conteudo, Caractere: string; Tamanho: Integer): string;
    Function ReplicaString(C: string; Tamanho: Integer): string;





implementation

{ TFuncoes }



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
  while length(valor) < qtde do
    valor := '0' + valor;
  Result := valor;
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

