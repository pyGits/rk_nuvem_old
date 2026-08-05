unit HostService;

interface
uses IdIcmpClient,System.SysUtils,System.classes,Winapi.Windows,Winapi.ShellAPI;
type IHostService = interface
  ['{4547568D-5BFF-43DA-9FBD-B83CC5807189}']
  function HostDisponivel(const AIP: string;TimeoutMs: Integer): Boolean;
end;
type THostService = class(TInterfacedObject,IHostService)

  public
    function HostDisponivel(const AIP: string; TimeoutMs: Integer): Boolean;
end;

implementation

{ THostService }

function THostService.HostDisponivel(const AIP: string;
  TimeoutMs: Integer): Boolean;
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  CmdLine: string;
  ExitCode: DWORD;
begin
  Result := False;
  ZeroMemory(@SI, SizeOf(SI));
  SI.cb := SizeOf(SI);
  ZeroMemory(@PI, SizeOf(PI));

  // Monta o comando ping -n 1 -w TimeoutMs IP
  CmdLine := Format('cmd.exe /C ping -n 1 -w %d %s', [TimeoutMs, AIP]);

  if CreateProcess(nil, PChar(CmdLine), nil, nil, False,
                   CREATE_NO_WINDOW, nil, nil, SI, PI) then
  begin
    WaitForSingleObject(PI.hProcess, TimeoutMs + 100);
    GetExitCodeProcess(PI.hProcess, ExitCode);
    CloseHandle(PI.hProcess);
    CloseHandle(PI.hThread);

    Result := ExitCode = 0;
  end;
end;

end.
