unit Utils;

interface

uses
  System.IniFiles, System.SysUtils,VCL.forms;

function ReadIniString( Section, Ident, Default: string): string;
procedure WriteIniString( Section, Ident, Value: string);
function Cript(Action, Src: String): String;


implementation
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
function ReadIniString( Section, Ident, Default: string): string;
var
  IniFile: TIniFile;
  FileName:string;
begin
  FileName := ExtractFilePath(Application.ExeName)+'/config.ini';
  IniFile := TIniFile.Create(FileName);
  try
    Result := Cript('D',IniFile.ReadString(Section, Ident, Default));
  finally
    IniFile.Free;
  end;
end;

procedure WriteIniString( Section, Ident, Value: string);
var
  IniFile: TIniFile;
  FileName:string;
begin
  FileName := ExtractFilePath(Application.ExeName)+'/config.ini';
  IniFile := TIniFile.Create(FileName);
  try
    IniFile.WriteString(Section, Ident, Cript('C', Value));
  finally
    IniFile.Free;
  end;
end;

end.

