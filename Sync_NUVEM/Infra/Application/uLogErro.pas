unit uLogErro;

// Registro em arquivo das falhas de sincronizacao.
// A pasta "Logs" e o arquivo do dia so sao criados quando ocorre a primeira
// falha - se a sincronizacao rodar sem erro, nada e gravado em disco.

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs;

procedure LogErro(const contexto, mensagem: string); overload;
procedure LogErro(const contexto: string; E: Exception); overload;

function PastaLogErro: string;
function ArquivoLogErro: string;

implementation

var
  trava: TCriticalSection;

function PastaLogErro: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Logs';
end;

function ArquivoLogErro: string;
begin
  Result := IncludeTrailingPathDelimiter(PastaLogErro) +
            'sync_erros_' + FormatDateTime('yyyy-mm-dd', Now) + '.txt';
end;

procedure GravaLinha(const linha: string);
var
  arquivo: string;
  stream: TFileStream;
  bytes: TBytes;
  arquivoNovo: Boolean;
begin
  arquivo := ArquivoLogErro;

  if not DirectoryExists(PastaLogErro) then
    ForceDirectories(PastaLogErro);

  arquivoNovo := not FileExists(arquivo);

  if arquivoNovo then
    stream := TFileStream.Create(arquivo, fmCreate or fmShareDenyWrite)
  else
    stream := TFileStream.Create(arquivo, fmOpenWrite or fmShareDenyWrite);
  try
    if arquivoNovo then
    begin
      bytes := TEncoding.UTF8.GetPreamble;
      stream.WriteBuffer(bytes[0], Length(bytes));
    end
    else
      stream.Seek(0, soEnd);

    bytes := TEncoding.UTF8.GetBytes(linha + sLineBreak);
    if Length(bytes) > 0 then
      stream.WriteBuffer(bytes[0], Length(bytes));
  finally
    stream.Free;
  end;
end;

procedure LogErro(const contexto, mensagem: string);
begin
  trava.Enter;
  try
    try
      GravaLinha(Format('[%s] [%s] %s',
        [FormatDateTime('dd/mm/yyyy hh:nn:ss', Now), contexto, mensagem]));
    except
      // uma falha ao gravar o log nunca pode derrubar a sincronizacao
    end;
  finally
    trava.Leave;
  end;
end;

procedure LogErro(const contexto: string; E: Exception);
begin
  if Assigned(E) then
    LogErro(contexto, E.ClassName + ': ' + E.Message)
  else
    LogErro(contexto, 'Erro desconhecido');
end;

initialization
  trava := TCriticalSection.Create;

finalization
  trava.Free;

end.
