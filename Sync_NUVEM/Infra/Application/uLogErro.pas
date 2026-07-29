unit uLogErro;

// Registro em arquivo das falhas de sincronizacao.
// A pasta "Logs" e o arquivo do dia so sao criados quando ocorre a primeira
// falha - se a sincronizacao rodar sem erro, nada e gravado em disco.
//
// Para o log nao ocupar disco indefinidamente existem duas protecoes:
//   1) arquivos com mais de DIAS_RETENCAO dias sao apagados (uma vez por dia);
//   2) o arquivo do dia para de crescer ao atingir MAX_BYTES_ARQUIVO.

interface

uses
  System.SysUtils, System.Classes, System.SyncObjs;

const
  // quantos dias de log ficam guardados na pasta
  DIAS_RETENCAO = 7;
  // teto do arquivo do dia (5 MB) - evita que um erro em loop encha o HD
  MAX_BYTES_ARQUIVO = 5 * 1024 * 1024;

procedure LogErro(const contexto, mensagem: string); overload;
procedure LogErro(const contexto: string; E: Exception); overload;

function PastaLogErro: string;
function ArquivoLogErro: string;

implementation

var
  trava: TCriticalSection;
  dataUltimoExpurgo: TDate = 0;
  dataLimiteAtingido: TDate = 0;

function PastaLogErro: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Logs';
end;

function ArquivoLogErro: string;
begin
  Result := IncludeTrailingPathDelimiter(PastaLogErro) +
            'sync_erros_' + FormatDateTime('yyyy-mm-dd', Now) + '.txt';
end;

// Apaga os arquivos de log fora da janela de retencao. Roda no maximo uma vez
// por dia, mesmo que a sincronizacao fique dias no ar sem ser reiniciada.
procedure ExpurgaLogsAntigos;
var
  pasta: string;
  busca: TSearchRec;
  limite: TDateTime;
begin
  if dataUltimoExpurgo = Date then
    Exit;
  dataUltimoExpurgo := Date;

  pasta := IncludeTrailingPathDelimiter(PastaLogErro);
  if not DirectoryExists(pasta) then
    Exit;

  limite := Date - DIAS_RETENCAO;

  if FindFirst(pasta + 'sync_erros_*.txt', faAnyFile, busca) = 0 then
  try
    repeat
      if ((busca.Attr and faDirectory) = 0) and (busca.TimeStamp < limite) then
        DeleteFile(pasta + busca.Name);
    until FindNext(busca) <> 0;
  finally
    FindClose(busca);
  end;
end;

procedure GravaLinha(const linha: string);
var
  arquivo: string;
  stream: TFileStream;
  bytes: TBytes;
  arquivoNovo: Boolean;
begin
  // o arquivo do dia ja bateu o teto - nada mais e gravado ate virar o dia
  if dataLimiteAtingido = Date then
    Exit;

  arquivo := ArquivoLogErro;

  if not DirectoryExists(PastaLogErro) then
    ForceDirectories(PastaLogErro);

  ExpurgaLogsAntigos;

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

    if stream.Size >= MAX_BYTES_ARQUIVO then
    begin
      dataLimiteAtingido := Date;
      bytes := TEncoding.UTF8.GetBytes(
        Format('[%s] [LOG] Limite de %d MB atingido - as demais falhas de hoje ' +
               'nao serao gravadas.',
               [FormatDateTime('dd/mm/yyyy hh:nn:ss', Now),
                MAX_BYTES_ARQUIVO div (1024 * 1024)]) + sLineBreak);
      stream.WriteBuffer(bytes[0], Length(bytes));
      Exit;
    end;

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
  try
    // limpa o que ficou de execucoes anteriores, mesmo que hoje nao haja erro
    ExpurgaLogsAntigos;
  except
    // o expurgo nunca pode impedir o sistema de subir
  end;

finalization
  trava.Free;

end.
