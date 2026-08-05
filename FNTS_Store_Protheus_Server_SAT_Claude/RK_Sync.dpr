program RK_Sync;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  Windows,
  Forms,
  principal in 'principal.pas' {frmPrincipal},
  IServidorRK1 in 'IServidorRK1.pas',
  Classe.Consumidor in 'Classes\Classe.Consumidor.pas',
  Classe.Cupom in 'Classes\Classe.Cupom.pas',
  Classe.Funcoes in 'Classes\Classe.Funcoes.pas',
  Classe.Produto in 'Classes\Classe.Produto.pas',
  uDmConexao in 'DAO\uDmConexao.pas' {dmConexao: TDataModule},
  uDmConexaoServer in 'DAO_Servidor\uDmConexaoServer.pas' {dmConexaoServer: TDataModule},
  uDmCupom in 'DAO\uDmCupom.pas' {dmCupom: TDataModule},
  uDmCupomServidor in 'DAO_Servidor\uDmCupomServidor.pas' {estoqu: TDataModule},
  uServidorCupomController in 'Controller_Servidor\uServidorCupomController.pas',
  uFrmPrincipal in 'Forms\uFrmPrincipal.pas' {frmPrincipalNovo},
  uCupomController in 'Controller\uCupomController.pas',
  Classe.NaoFiscal in 'Classes\Classe.NaoFiscal.pas',
  Classe.Movimentacao in 'Classes\Classe.Movimentacao.pas',
  Classe.Fechamento in 'Classes\Classe.Fechamento.pas',
  uDmStorage in 'DAO\uDmStorage.pas' {dmStorage: TDataModule},
  uStorageController in 'Controller\uStorageController.pas',
  Classe.NFCePendente in 'Classes\Classe.NFCePendente.pas';

var
  Hand : THandle;

{$R *.res}

begin
  Hand := FindWindow('TApplication', 'RK System Server');
  if Hand = 0 then
  begin
  Application.Initialize;
  Application.Title := 'RK System Server';
  Application.CreateForm(TdmConexaoServer, dmConexaoServer);
  Application.CreateForm(TdmConexao, dmConexao);
  Application.CreateForm(TfrmPrincipalNovo, frmPrincipalNovo);
  Application.CreateForm(TdmCupom, dmCupom);
  Application.CreateForm(TdmStorage, dmStorage);
  Application.Run;
  end;


end.


