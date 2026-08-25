unit uFrmAtualizarBanco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, dbcClasses,
  dbcSQL_Exec, dbcIBSQLExec, dbcDBComparer, dbcDBStructure,
  dbcCustomScriptExtract, dbcIBScriptExtract, dbcIBDatabaseExtract,
  Vcl.ExtCtrls, Data.DB, MemDS, DBAccess, Uni,IBDataModule,Registry, DAScript,
  UniScript, UniProvider, InterBaseUniProvider;

type
  TfrmAtualizarBanco = class(TForm)
    MemoExtr: TRichEdit;
    MemoResult: TMemo;
    Label1: TLabel;
    Timer1: TTimer;
    DBComparer1: TDBComparer;
    DBStructure1: TDBStructure;
    DBStructure2: TDBStructure;
    IBDBExtract1: TIBDBExtract;
    IBDBExtract2: TIBDBExtract;
    IBScriptExtract1: TIBScriptExtract;
    IBScriptExtract2: TIBScriptExtract;
    IBSQLExec: TIBSQLExec;
    qrAjusteDel: TUniQuery;
    qrAjustePesq: TUniQuery;
    ExecAjusta: TIBSQLExec;
    IBSQLExec1: TIBSQLExec;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function ExeAndWait(ExeNameAndParams: string; ncmdShow: Integer = SW_SHOWNORMAL): Integer;
    procedure atualizar;
    procedure execAjustes;
    procedure execAjustesPre;
  public
    function FirebirdIniciar(bStart: Boolean): Boolean;
    function backupBanco:boolean;
    procedure ExtractTargetDatabase();
    procedure ExtractMasterDatabase();
    procedure ExtrairBancoAtualizado;
    const BANCO = 'c:\system_rk\server\bd\banco.fdb';
    const BANCO_ATUALIZADO = 'c:\system_rk\server\atualizacao\ATUALIZACAO.FBX';
    const diretorio = 'c:\system_rk\server\atualizacao';
  end;

var
  frmAtualizarBanco: TfrmAtualizarBanco;

implementation

{$R *.dfm}

procedure TfrmAtualizarBanco.atualizar;
begin
//try
//  try
//    // extrair banco de dados na pasta /atualizacao
//    if FileExists (BANCO) then
//    begin
//    ExtrairBancoAtualizado;
//    ExtractTargetDatabase();
//    ExtractMasterDatabase();
//    MemoExtr.Lines.Add('< Extract finished. >');
//
//    MemoResult.Lines.Clear;
//    try
//      DBComparer1.CompareDatabases();
//      MemoResult.Lines.BeginUpdate();
//      DBComparer1.SQLExec.GetScript(MemoResult.Lines);
//      MemoResult.Lines.EndUpdate();
//      if (MemoResult.Lines.Count > 4) then
//      begin
//        If  MessageDlg('Atualização do banco de dados detectada deseja atualizar ?, Importante fechar o RK PDV e o RK Sync antes de clicar em Sim',mtConfirmation,[mbyes,mbno],0)=mryes then
//        begin
//          FirebirdIniciar(false);
//          FirebirdIniciar(true);
//          // fazer backup do banco de dados atual
//          if backupBanco then
//          begin
//            execAjustesPre;
//            // atualizar
//            IBSQLExec.ExecuteScript();
//            execAjustes;
//          end;
//        end;
//      end;
//    except on E: Exception do begin
//      ShowMessage(E.Message);
//      MemoResult.Lines.Add('Error: '+E.Message);
//    end end;
//    MemoExtr.Lines.Add('< Compare finished. >');
//    end;
//  except
//  on E:Exception do
//  begin
//  FirebirdIniciar(true);
//  close;
//    raise Exception.Create('Erro ao atualizar banco de dados :'+ E.Message);
//  end;
//
//  end;
//
//finally
//  FirebirdIniciar(true);
//  Close;
//end;
end;

function TfrmAtualizarBanco.backupBanco: boolean;
var
data : String;
hora : string;
dir:string;
begin
data := FormatDateTime('ddmmyyyy',date);
hora := FormatDateTime('hhMMss', Now);
result :=false;

dir := diretorio+'\BACKUP'+data+hora+'.FDB';

try
if CopyFile(BANCO, PWideChar(dir), True) then
begin
  if FileExists(dir) then
  begin
  result := true;
  end;
end
else
begin
  result := false;
end;
except
on E:Exception do
begin
  raise Exception.Create('Erro ao criar backup : '+ E.message);
  result := false;
end;
end;

end;

function TfrmAtualizarBanco.ExeAndWait(ExeNameAndParams: string;
  ncmdShow: Integer): Integer;
var
    StartupInfo: TStartupInfo;
    ProcessInformation: TProcessInformation;
    Res: Bool;
    lpExitCode: DWORD;
begin
    with StartupInfo do //you can play with this structure
    begin
        cb := SizeOf(TStartupInfo);
        lpReserved := nil;
        lpDesktop := nil;
        lpTitle := nil;
        dwFlags := STARTF_USESHOWWINDOW;
        wShowWindow := ncmdShow;
        cbReserved2 := 0;
        lpReserved2 := nil;
    end;
    Res := CreateProcess(nil, PChar(ExeNameAndParams), nil, nil, True,
        CREATE_DEFAULT_ERROR_MODE
        or NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInformation);
    while True do
    begin
        GetExitCodeProcess(ProcessInformation.hProcess, lpExitCode);
        if lpExitCode <> STILL_ACTIVE then
            Break;
        Application.ProcessMessages;
    end;
    Result := Integer(lpExitCode);
end;

procedure TfrmAtualizarBanco.execAjustes;
var
  sNivel:TStrings;
begin
// nivel acesso
with qrAjustePesq do
begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM RETAGUARDA_NIVEL');
  Open;                                   
  if qrAjustePesq.RecordCount = 0 then
  begin
    sNivel := TStringList.Create;
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000001'+chr(39)+', NULL, '+chr(39)+'Produto'+chr(39)+', '+chr(39)+'CADASTRO'+chr(39)+', '+chr(39)+''+chr(39)+', '+chr(39)+'0'+chr(39)+');       ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000002'+chr(39)+', NULL, '+chr(39)+'Grupo'+chr(39)+', '+chr(39)+'CADASTRO'+chr(39)+', '+chr(39)+''+chr(39)+', '+chr(39)+'0'+chr(39)+');         ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000003'+chr(39)+', NULL, '+chr(39)+'Subgrupo'+chr(39)+', '+chr(39)+'CADASTRO'+chr(39)+', '+chr(39)+''+chr(39)+', '+chr(39)+'0'+chr(39)+');      ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000004'+chr(39)+', NULL, '+chr(39)+'Funcionário'+chr(39)+', '+chr(39)+'CADASTRO'+chr(39)+', '+chr(39)+''+chr(39)+', '+chr(39)+'0'+chr(39)+');   ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000006'+chr(39)+', NULL, '+chr(39)+'Cliente'+chr(39)+', '+chr(39)+'CADASTRO'+chr(39)+', '+chr(39)+''+chr(39)+', '+chr(39)+'0'+chr(39)+');       ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000007'+chr(39)+', NULL, '+chr(39)+'Fornecedor'+chr(39)+', '+chr(39)+'CADASTRO'+chr(39)+', '+chr(39)+''+chr(39)+', '+chr(39)+'0'+chr(39)+');    ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000008'+chr(39)+', NULL, '+chr(39)+'Tributação'+chr(39)+', '+chr(39)+'CADASTRO'+chr(39)+', '+chr(39)+''+chr(39)+', '+chr(39)+'0'+chr(39)+');    ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000009'+chr(39)+', NULL, '+chr(39)+'Finalizadora'+chr(39)+', '+chr(39)+'CADASTRO'+chr(39)+', '+chr(39)+''+chr(39)+', '+chr(39)+'0'+chr(39)+');  ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000010'+chr(39)+', NULL, '+chr(39)+'Próprio'+chr(39)+', '+chr(39)+'CADASTRO'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', '+chr(39)+'0'+chr(39)+');       ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000011'+chr(39)+', NULL, '+chr(39)+'Carga PDV'+chr(39)+', '+chr(39)+'EXPORTAR'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', '+chr(39)+'0'+chr(39)+');     ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000012'+chr(39)+', NULL, '+chr(39)+'Carga Balança'+chr(39)+', '+chr(39)+'EXPORTAR'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', '+chr(39)+'0'+chr(39)+'); ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000013'+chr(39)+', NULL, '+chr(39)+'Pré Venda'+chr(39)+', '+chr(39)+'VENDAS'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', 0);                          ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000014'+chr(39)+', NULL, '+chr(39)+'Contas a Receber'+chr(39)+', '+chr(39)+'FINANCEIRO'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', 0);               ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000015'+chr(39)+', NULL, '+chr(39)+'Caixa>Finalização'+chr(39)+', '+chr(39)+'RELATORIO'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', 0);               ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000016'+chr(39)+', NULL, '+chr(39)+'Caixa>Produto'+chr(39)+', '+chr(39)+'RELATORIO'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', 0);                   ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000017'+chr(39)+', NULL, '+chr(39)+'Caixa>Cupom'+chr(39)+', '+chr(39)+'RELATORIO'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', 0);                     ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000018'+chr(39)+', NULL, '+chr(39)+'Caixa>Saldo Estoque'+chr(39)+', '+chr(39)+'RELATORIO'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', 0);             ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000019'+chr(39)+', NULL, '+chr(39)+'Caixa>Gráfico de Vendas'+chr(39)+', '+chr(39)+'RELATORIO'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', 0);         ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000020'+chr(39)+', NULL, '+chr(39)+'Funcionários>Comissão'+chr(39)+', '+chr(39)+'RELATORIO'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', 0);           ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000021'+chr(39)+', NULL, '+chr(39)+'Etiqueta'+chr(39)+', '+chr(39)+'IMPRIMIR'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', '+chr(39)+'0'+chr(39)+');      ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000022'+chr(39)+', NULL, '+chr(39)+'Auditoria'+chr(39)+', '+chr(39)+'CONFIGURACOES'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', 0);                   ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000023'+chr(39)+', NULL, '+chr(39)+'Configurações'+chr(39)+', '+chr(39)+'CONFIGURACOES'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', 0);               ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000024'+chr(39)+', NULL, '+chr(39)+'Nível Acesso > PDV'+chr(39)+', '+chr(39)+'CONFIGURACOES'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', 0);          ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000025'+chr(39)+', NULL, '+chr(39)+'Nível Acesso > Retaguarda'+chr(39)+', '+chr(39)+'CONFIGURACOES'+chr(39)+', '+chr(39)+'0;1;2;'+chr(39)+', 0);   ');
    sNivel.Add('INSERT INTO RETAGUARDA_NIVEL (CODIGO, ACFUNC, FUNCDESC, FUNCCAT, FUNCNIV, FUNCSOLIC) VALUES ('+chr(39)+'000026'+chr(39)+', NULL, '+chr(39)+'Importar'+chr(39)+', '+chr(39)+'CADASTRO'+chr(39)+', '+chr(39)+''+chr(39)+', 0);   ');
    IBSQLExec.LoadScript(sNivel);
    IBSQLExec.ExecuteScript();
  end;
end;
end;

procedure TfrmAtualizarBanco.execAjustesPre;
begin
with qrAjustePesq do
begin
  Close;
  SQl.Clear;
  SQl.Add('UPDATE RDB$RELATION_FIELDS SET RDB$NULL_FLAG = 1 WHERE RDB$FIELD_NAME = '+Chr(39)+'COD_CAIXA'+Chr(39)+' AND RDB$RELATION_NAME = '+Chr(39)+'FECHAMENTO'+Chr(39));
  ExecSQL;
end;

with qrAjustePesq do
begin
  Close;
  SQl.Clear;
  SQl.Add('UPDATE RDB$RELATION_FIELDS SET RDB$NULL_FLAG = 1 WHERE RDB$FIELD_NAME = '+Chr(39)+'COD_CAIXA'+Chr(39)+' AND RDB$RELATION_NAME = '+Chr(39)+'FECHAMENTO_FINALIZADORA'+Chr(39));
  ExecSQL;
end;


end;

procedure TfrmAtualizarBanco.ExtractMasterDatabase;
var
  ErrFlg : Boolean;
begin
  with DataMd do begin
    ErrFlg := False;
    try
      DBCConnection1.Connected := True;
    except on E: Exception do begin
      ShowMessage(E.Message);
      MemoExtr.Lines.Add('Error: '+E.Message);
      ErrFlg := True;
      UniConnection1.Connected := false;
    end end;
    if ErrFlg then exit;
    MemoExtr.Lines.Add('Database: '+ BANCO_atualizado +' open.');
    DBStructure1.Clear;
    IBDBExtract1.ExtractDatabase;
    DBCConnection1.Connected := False;
  end;
end;

procedure TfrmAtualizarBanco.ExtractTargetDatabase;
var
  ErrFlg: Boolean;
begin
  with DataMd do begin

    ErrFlg := False;
    try
      DBCConnection2.Connected := True;
    except on E: Exception do begin
      ShowMessage(E.Message);
      MemoExtr.Lines.Add('Error: '+E.Message);
      ErrFlg := True;
      UniConnection2.Connected := false;
    end end;
    if ErrFlg then exit;
    MemoExtr.Lines.Add('Database: '+BANCO+' open.');
    DBStructure2.Clear;
    IBDBExtract2.ExtractDatabase;
    DBCConnection2.Connected := False;
  end;
end;

procedure TfrmAtualizarBanco.ExtrairBancoAtualizado;
var
  fs: TFileStream;
  rs: TResourceStream;
  s : string;
begin
  if not DirectoryExists(diretorio) then
  begin
    CreateDir(diretorio);
  end;

  rs := TResourceStream.Create(hInstance, 'BANCO', RT_RCDATA);
  s  := DIRETORIO+'\ATUALIZACAO.FBX';
  fs := TFileStream.Create(s,fmCreate);
  rs.SaveToStream(fs);
  fs.Free;

end;

function TfrmAtualizarBanco.FirebirdIniciar(bStart: Boolean): Boolean;
var
  szBuff: String;
begin
  with TRegistry.Create do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    Result := OpenKey('SOFTWARE\Firebird Project\Firebird Server\Instances', False);
    if Result then
    begin
      szBuff := ReadString('DefaultInstance') + 'bin\instsvc.exe';
      Result := FileExists(szBuff);
      if Result then
      case bStart of
      True: ExeAndWait(szBuff + ' -s start', 0);
      False: ExeAndWait(szBuff + ' -s stop', 0);
      end;
      CloseKey;
    end;
    Free;
  end;
end;

procedure TfrmAtualizarBanco.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action := caFree;
FreeAndNil(DataMd);
end;

procedure TfrmAtualizarBanco.FormCreate(Sender: TObject);
begin
DataMd := TDataMd.Create(self);
end;

procedure TfrmAtualizarBanco.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled := false;
atualizar;
end;

end.
