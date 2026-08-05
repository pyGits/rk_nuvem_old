program TestsRetaguarda;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  TestContaReceberUC in 'UC\TestContaReceberUC.pas',
  ContaReceberUseCase in '..\UseCase\ContaReceberUseCase.pas',
  CaixaModel in '..\Entity\CaixaModel.pas',
  ContaReceberModel in '..\Entity\ContaReceberModel.pas',
  ProprioModel in '..\Entity\ProprioModel.pas',
  CaixaRepositoryImpl in '..\Repository\CaixaRepositoryImpl.pas',
  ContaReceberRepositoryImpl in '..\Repository\ContaReceberRepositoryImpl.pas',
  ProprioRepositoryImpl in '..\Repository\ProprioRepositoryImpl.pas',
  uConexao in '..\Repository\uConexao.pas',
  uConexaoPDV in '..\Repository\uConexaoPDV.pas',
  uIniManager in '..\Utils\uIniManager.pas',
  uStringUtils in '..\Utils\uStringUtils.pas',
  uTxtManager in '..\Utils\uTxtManager.pas',
  HostService in '..\Services\HostService.pas',
  ImpressoraService in '..\Services\ImpressoraService.pas',
  ContaReceberPrinter in '..\Printer\ContaReceberPrinter.pas',
  PessoaModel in '..\Entity\PessoaModel.pas',
  EnderecoModel in '..\Entity\EnderecoModel.pas',
  ContaReceberItemModel in '..\Entity\ContaReceberItemModel.pas',
  ProdutoModel in '..\Entity\ProdutoModel.pas',
  CodigoAuxiliarModel in '..\Entity\CodigoAuxiliarModel.pas',
  ProdutoRepositoryImpl in '..\Repository\ProdutoRepositoryImpl.pas',
  ConfiguracaoRepositoryImpl in '..\Repository\ConfiguracaoRepositoryImpl.pas',
  ConfiguracaoModel in '..\Entity\ConfiguracaoModel.pas',
  TestDatabaseUC in 'UC\TestDatabaseUC.pas',
  DatabaseUseCase in '..\UseCase\DatabaseUseCase.pas',
  uConexaoTeste in '..\Repository\uConexaoTeste.pas',
  MigrationModel in '..\Entity\MigrationModel.pas',
  DatabaseRepositoryImpl in '..\Repository\DatabaseRepositoryImpl.pas',
  LogService in '..\Services\LogService.pas',
  UIAtualizarBancoInterface in '..\UI\UIAtualizarBancoInterface.pas',
  Helpers in '..\Utils\Helpers.pas',
  RetaguardaNivelSeeder in '..\Seeders\RetaguardaNivelSeeder.pas',
  RetaguardaNivelModel in '..\Entity\RetaguardaNivelModel.pas',
  RetaguardaNivelRepositoryImpl in '..\Repository\RetaguardaNivelRepositoryImpl.pas',
  SeederExecute in '..\Seeders\SeederExecute.pas',
  GrupoSeeder in '..\Seeders\GrupoSeeder.pas',
  GrupoModel in '..\Entity\GrupoModel.pas',
  GrupoRepositoryImpl in '..\Repository\GrupoRepositoryImpl.pas',
  FornecedorSeeder in '..\Seeders\FornecedorSeeder.pas',
  FornecedorRepositoryImpl in '..\Repository\FornecedorRepositoryImpl.pas',
  FornecedorModel in '..\Entity\FornecedorModel.pas',
  SubgrupoSeeder in '..\Seeders\SubgrupoSeeder.pas',
  SubgrupoRepositoryImpl in '..\Repository\SubgrupoRepositoryImpl.pas',
  SubgrupoModel in '..\Entity\SubgrupoModel.pas',
  TestImprimirEtiqueta in 'UC\TestImprimirEtiqueta.pas',
  EtiquetaUseCase in '..\UseCase\EtiquetaUseCase.pas',
  EtiquetaRepositoryImpl in '..\Repository\EtiquetaRepositoryImpl.pas',
  uConexaoSyspdv in '..\Repository\uConexaoSyspdv.pas',
  uConexaoLocal in '..\Repository\uConexaoLocal.pas',
  UIEtiqueta in '..\UI\UIEtiqueta.pas',
  CodigoAuxiliarRepositoryImpl in '..\Repository\CodigoAuxiliarRepositoryImpl.pas',
  uConexaoSyspdvSQL in '..\Repository\uConexaoSyspdvSQL.pas',
  EtiquetaLayoutModel in '..\Entity\EtiquetaLayoutModel.pas',
  EtiquetaPrinter in '..\Printer\EtiquetaPrinter.pas',
  TestNFCeUC in 'UC\TestNFCeUC.pas',
  NFCeUseCase in '..\UseCase\NFCeUseCase.pas',
  NFCeModel in '..\Entity\NFCeModel.pas',
  NFcePendenteRepositoryImpl in '..\Repository\NFcePendenteRepositoryImpl.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
