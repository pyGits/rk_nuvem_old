program Retaguarda;



uses
  Winapi.Windows,
  Vcl.Forms,
  uFrmPrincipal in 'Forms\uFrmPrincipal.pas' {frmPrincipal},
  Classe.CEST in 'Classes\Classe.CEST.pas',
  Classe.Configuracoes in 'Classes\Classe.Configuracoes.pas',
  Classe.Emitente in 'Classes\Classe.Emitente.pas',
  Classe.Estoque in 'Classes\Classe.Estoque.pas',
  Classe.Finalizadora in 'Classes\Classe.Finalizadora.pas',
  Classe.Fornecedor in 'Classes\Classe.Fornecedor.pas',
  Classe.Funcoes in 'Classes\Classe.Funcoes.pas',
  Classe.Grupo in 'Classes\Classe.Grupo.pas',
  Classe.Marca in 'Classes\Classe.Marca.pas',
  Classe.NCM in 'Classes\Classe.NCM.pas',
  Classe.Produto in 'Classes\Classe.Produto.pas',
  Classe.Relatorio in 'Classes\Classe.Relatorio.pas',
  Classe.Subgrupo in 'Classes\Classe.Subgrupo.pas',
  Classe.Tributacao in 'Classes\Classe.Tributacao.pas',
  Classe.Variaveis in 'Classes\Classe.Variaveis.pas',
  uFrmProduto in 'Forms\uFrmProduto.pas' {frmProduto},
  uDmConexao in 'DAO\uDmConexao.pas' {dmConexao: TDataModule},
  uDmProduto in 'DAO\uDmProduto.pas' {dmProduto: TDataModule},
  uProdutoController in 'Controller\uProdutoController.pas',
  uDmUtils in 'DAO\uDmUtils.pas' {dmUtils: TDataModule},
  uUtilsController in 'Controller\uUtilsController.pas',
  Conversao in 'Classes\Conversao.pas',
  uFrmGrupo in 'Forms\uFrmGrupo.pas' {frmGrupo},
  uDmGrupo in 'DAO\uDmGrupo.pas' {dmGrupo: TDataModule},
  uGrupoController in 'Controller\uGrupoController.pas',
  uDmSubgrupo in 'DAO\uDmSubgrupo.pas' {dmSubgrupo: TDataModule},
  uSubGrupoController in 'Controller\uSubGrupoController.pas',
  uFrmSubGrupo in 'Forms\uFrmSubGrupo.pas' {frmSubGrupo},
  uFrmTributacao in 'Forms\uFrmTributacao.pas' {frmTributacao},
  uDmTributacao in 'DAO\uDmTributacao.pas' {dmTributacao: TDataModule},
  uTributacaoController in 'Controller\uTributacaoController.pas',
  uDmNCM in 'DAO\uDmNCM.pas' {dmNCM: TDataModule},
  uNCMController in 'Controller\uNCMController.pas',
  uDmCEST in 'DAO\uDmCEST.pas' {dmCEST: TDataModule},
  uCESTController in 'Controller\uCESTController.pas',
  uFrmFuncionario in 'Forms\uFrmFuncionario.pas' {frmFuncionario},
  Classe.Funcionario in 'Classes\Classe.Funcionario.pas',
  uDmFinalizadora in 'DAO\uDmFinalizadora.pas' {dmFinalizadora: TDataModule},
  uFinalizadoraController in 'Controller\uFinalizadoraController.pas',
  uFrmFinalizadora in 'Forms\uFrmFinalizadora.pas' {frmFinalizadora},
  Classe.Endereco in 'Classes\Classe.Endereco.pas',
  Classe.Pessoa in 'Classes\Classe.Pessoa.pas',
  uDmFornecedor in 'DAO\uDmFornecedor.pas' {dmFornecedor: TDataModule},
  uFornecedorController in 'Controller\uFornecedorController.pas',
  uFrmFornecedor in 'Forms\uFrmFornecedor.pas' {frmFornecedor},
  uDmCliente in 'DAO\uDmCliente.pas' {dmCliente: TDataModule},
  Classe.Cliente in 'Classes\Classe.Cliente.pas',
  uClienteController in 'Controller\uClienteController.pas',
  uFrmCliente in 'Forms\uFrmCliente.pas' {frmCliente},
  uDmFuncionario in 'DAO\uDmFuncionario.pas' {dmFuncionario: TDataModule},
  uFuncionarioController in 'Controller\uFuncionarioController.pas',
  uFrmPDVCarga in 'Forms\uFrmPDVCarga.pas' {frmPDVCarga},
  uDmCaixa in 'DAO\uDmCaixa.pas' {dmCaixa: TDataModule},
  Classe.Caixa in 'Classes\Classe.Caixa.pas',
  uCaixaController in 'Controller\uCaixaController.pas',
  uDmConexaoCaixa in 'DAO_Caixa\uDmConexaoCaixa.pas' {dmConexaoCaixa: TDataModule},
  uDmCargaPDV in 'DAO\uDmCargaPDV.pas' {dmCargaPDV: TDataModule},
  uDmCargaCaixa in 'DAO_Caixa\uDmCargaCaixa.pas' {dmCargaCaixa: TDataModule},
  uCargaController in 'Controller\uCargaController.pas',
  uFrmProprio in 'Forms\uFrmProprio.pas' {frmProprio},
  Classe.Proprio in 'Classes\Classe.Proprio.pas',
  uDmProprio in 'DAO\uDmProprio.pas' {dmProprio: TDataModule},
  uProprioController in 'Controller\uProprioController.pas',
  uFrmBalanca in 'Forms\uFrmBalanca.pas' {frmBalanca},
  uFrmRelPainel in 'Forms\Rel\uFrmRelPainel.pas' {frmRelPainel},
  uDmRelCupom in 'DAO\uDmRelCupom.pas' {dmRelCupom: TDataModule},
  uRelatorioController in 'Controller\uRelatorioController.pas',
  uFrmRelCupom in 'Forms\Rel\uFrmRelCupom.pas' {frmRelCupom},
  uFrmRelProduto in 'Forms\Rel\uFrmRelProduto.pas' {frmRelProduto},
  uDmRelProduto in 'DAO\uDmRelProduto.pas' {dmRelProduto: TDataModule},
  uFrmRelPagamento in 'Forms\Rel\uFrmRelPagamento.pas' {FrmRelPagamento},
  uDmRelFinalizadora in 'DAO\uDmRelFinalizadora.pas' {dmRelFinalizadora: TDataModule},
  uFrmConfiguracoes in 'Forms\uFrmConfiguracoes.pas' {frmConfiguracoes},
  uFrmEtiqueta in 'Forms\uFrmEtiqueta.pas' {frmEtiqueta},
  uFrmLogin in 'Forms\uFrmLogin.pas' {FrmLogin},
  uFrmCaixaAcesso in 'Forms\uFrmCaixaAcesso.pas' {frmCaixaAcesso},
  uDmCaixaAcesso in 'DAO\uDmCaixaAcesso.pas' {dmCaixaAcesso: TDataModule},
  Classe.AcessoPDV in 'Classes\Classe.AcessoPDV.pas',
  uFrmRelSaldoEstoque in 'Forms\Rel\uFrmRelSaldoEstoque.pas' {FrmRelSaldoEstoque},
  uDmRelEstoque in 'DAO\uDmRelEstoque.pas' {dmRelEstoque: TDataModule},
  uFrmContasReceber in 'Forms\uFrmContasReceber.pas' {frmContasReceber},
  uDmContasReceber in 'DAO\uDmContasReceber.pas' {dmContasReceber: TDataModule},
  uContasReceberController in 'Controller\uContasReceberController.pas',
  uFrmContasReceber_pgto in 'Forms\uFrmContasReceber_pgto.pas' {frmContasReceberPgto},
  uDmAuditoria in 'DAO\uDmAuditoria.pas' {dmAuditoria: TDataModule},
  uAuditoriaController in 'Controller\uAuditoriaController.pas',
  uFrmAuditoria in 'DAO\uFrmAuditoria.pas' {frmAuditoria},
  uFrmPreVenda in 'Forms\uFrmPreVenda.pas' {FrmPreVenda},
  Classe.Prevenda in 'Classes\Classe.Prevenda.pas',
  uDmPreVenda in 'DAO\uDmPreVenda.pas' {dmPreVenda: TDataModule},
  uPreVendaController in 'Controller\uPreVendaController.pas',
  uFrmPreVenda_pgto in 'Forms\uFrmPreVenda_pgto.pas' {frmPreVendaPgto},
  uFrmRelFuncComissao in 'Forms\Rel\uFrmRelFuncComissao.pas' {frmRelFuncComissao},
  uDmRelFuncionario in 'DAO\uDmRelFuncionario.pas' {dmRelFuncionario: TDataModule},
  uFrmRetaguardaAcesso in 'Forms\uFrmRetaguardaAcesso.pas' {frmAcessoRetaguarda},
  Classe.AcessoRetaguarda in 'Classes\Classe.AcessoRetaguarda.pas',
  uFrmEtiquetaConfigurar in 'Forms\uFrmEtiquetaConfigurar.pas' {frmEtiquetaConfig},
  Classe.Validade in 'Classes\Classe.Validade.pas',
  uDmValidade in 'DAO\uDmValidade.pas' {dmValidade: TDataModule},
  uValidadeController in 'Controller\uValidadeController.pas',
  uFrmValidadeIncluir in 'DAO\uFrmValidadeIncluir.pas' {frmValidadeIncluir},
  uFrmEstoqueEditar in 'Forms\uFrmEstoqueEditar.pas' {frmEstoqueEditar},
  uDmEstoque in 'DAO\uDmEstoque.pas' {dmEstoque: TDataModule},
  uEstoqueController in 'Controller\uEstoqueController.pas',
  uFrmValidade in 'Forms\uFrmValidade.pas' {frmValidade},
  uFrmRelExtratoEstoque in 'Forms\Rel\uFrmRelExtratoEstoque.pas' {frmExtratoEstoque},
  uFrmRelPerformanceProduto in 'Forms\Rel\uFrmRelPerformanceProduto.pas' {frmRelPerformanceProduto},
  uFrmAtualizarBanco in 'Forms\uFrmAtualizarBanco.pas' {frmAtualizarBanco},
  IBDataModule in 'DAO_Banco_Atualizar\IBDataModule.pas' {DataMd: TDataModule},
  uFrmRelFechamento in 'Forms\Rel\uFrmRelFechamento.pas' {FrmRelFechamento},
  uFrmImportar in 'Forms\uFrmImportar.pas' {frmImportar},
  uDmConexaoIntegracao in 'DAO_Integracao\uDmConexaoIntegracao.pas' {dmConexaoIntegracao: TDataModule},
  uFrmImportarPersonalizado in 'Forms\uFrmImportarPersonalizado.pas' {frmImportarPersonalizado},
  Classe.Importar in 'Classes\Classe.Importar.pas',
  Utils in 'Classes\Utils.pas',
  Classe.Impressao.Prevenda in 'Classes\Classe.Impressao.Prevenda.pas',
  uFrmImpressao in 'Forms\uFrmImpressao.pas' {frmImpressao},
  uDmCodigoAuxiliar in 'DAO\uDmCodigoAuxiliar.pas' {dmCodigoAuxiliar: TDataModule},
  Classe.CodigoAuxiliar in 'Classes\Classe.CodigoAuxiliar.pas',
  ProdutoSyspdvAdapter in 'Infra\Adapter\ProdutoSyspdvAdapter.pas',
  RK.CodigoAuxiliar.Repository in 'Infra\Repository\RK.CodigoAuxiliar.Repository.pas',
  RK.Produto.Repository in 'Infra\Repository\RK.Produto.Repository.pas',
  RK.ProdutoMapeamento.Repository in 'Infra\Repository\RK.ProdutoMapeamento.Repository.pas',
  RKConnection in 'Infra\Repository\RKConnection.pas',
  Syspdv.CodigoAuxiliar.Repository in 'Infra\Repository\Syspdv.CodigoAuxiliar.Repository.pas',
  Syspdv.Produto.Repository in 'Infra\Repository\Syspdv.Produto.Repository.pas',
  SyspdvConnection in 'Infra\Repository\SyspdvConnection.pas',
  ImportarController in 'Infra\Controller\ImportarController.pas',
  ProdutoController in 'Infra\Controller\ProdutoController.pas',
  EtiquetaController in 'Infra\Controller\EtiquetaController.pas',
  Produto.RK.Adapter in 'Infra\Adapter\Produto.RK.Adapter.pas',
  RK.Etiqueta.Repository in 'Infra\Repository\RK.Etiqueta.Repository.pas',
  XLSToGrid in 'Infra\Utils\XLSToGrid.pas',
  uDmContasReceberPagamento in 'DAO\uDmContasReceberPagamento.pas' {dmContasReceberPagamento: TDataModule},
  ConfiguracaoController in 'Infra\Controller\ConfiguracaoController.pas',
  NivelAcessoRetaguardaController in 'Infra\Controller\NivelAcessoRetaguardaController.pas',
  NivelAcessoRetaguardaRepository in 'Infra\Repository\RK.Retaguarda\NivelAcessoRetaguardaRepository.pas',
  Helper in 'Infra\Utils\Helper.pas',
  FormController in 'Infra\Controller\FormController.pas',
  UsuarioController in 'Infra\Controller\UsuarioController.pas',
  UsuarioRepository in 'Infra\Repository\RK.Retaguarda\UsuarioRepository.pas',
  FormService in 'Infra\Services\FormService.pas',
  ProdutoPDVRepository in 'Infra\Repository\RK.PDV\ProdutoPDVRepository.pas',
  PDV_Connection in 'Infra\Repository\RK.PDV\PDV_Connection.pas',
  ProdutoRepository in 'Infra\Repository\RK.Retaguarda\ProdutoRepository.pas',
  NotificacaoController in 'Infra\Controller\NotificacaoController.pas',
  NotificacaoService in 'Infra\Services\NotificacaoService.pas',
  NotificacaoRepository in 'Infra\Repository\RK.Retaguarda\NotificacaoRepository.pas',
  uFrmNotificacao in 'Forms\uFrmNotificacao.pas' {frmNotificacao},
  Classe.ConfiguracoesPDV in 'Classes\Classe.ConfiguracoesPDV.pas',
  uFrmNFCePendente in 'Forms\uFrmNFCePendente.pas' {frmNFCePendente},
  NFCeController in 'Infra\Controller\NFCeController.pas',
  NFcePendenteRepository in 'Infra\Repository\RK.Retaguarda\NFcePendenteRepository.pas',
  uFrmEnviaNFCe in 'Forms\uFrmEnviaNFCe.pas' {frmEnviaNFce},
  uIniManager in 'Infra2\Utils\uIniManager.pas',
  uTxtManager in 'Infra2\Utils\uTxtManager.pas',
  uStringUtils in 'Infra2\Utils\uStringUtils.pas',
  ProdutoPDVImplRepository in 'Infra2\Repository\PDV\ProdutoPDVImplRepository.pas',
  Global in 'Infra2\Application\Global.pas',
  ContaReceberPrinter in 'Infra2\Printer\ContaReceberPrinter.pas',
  CodigoAuxiliar in 'Infra\Entity\CodigoAuxiliar.pas',
  Configuracao in 'Infra\Entity\Configuracao.pas',
  ContasReceber in 'Infra\Entity\ContasReceber.pas',
  ContasReceberList in 'Infra\Entity\ContasReceberList.pas',
  Importar in 'Infra\Entity\Importar.pas',
  MapeamentoProduto in 'Infra\Entity\MapeamentoProduto.pas',
  NFCePendente in 'Infra\Entity\NFCePendente.pas',
  NivelAcessoRetaguarda in 'Infra\Entity\NivelAcessoRetaguarda.pas',
  Notificacao in 'Infra\Entity\Notificacao.pas',
  PDVConnectionList in 'Infra\Entity\PDVConnectionList.pas',
  Pessoa in 'Infra\Entity\Pessoa.pas',
  Produto in 'Infra\Entity\Produto.pas',
  ProdutoList in 'Infra\Entity\ProdutoList.pas',
  Usuario in 'Infra\Entity\Usuario.pas',
  HostService in 'Infra2\Services\HostService.pas',
  ImpressoraService in 'Infra2\Services\ImpressoraService.pas',
  LogService in 'Infra2\Services\LogService.pas',
  TerminalService in 'Infra2\Services\TerminalService.pas',
  UIAtualizarBanco in 'Infra2\Forms\UIAtualizarBanco.pas' {frmUIAtualizarBanco},
  UIAtualizarBancoInterface in 'Infra2\UI\UIAtualizarBancoInterface.pas',
  Helpers in 'Infra2\Utils\Helpers.pas',
  FornecedorSeeder in 'Infra2\Seeders\FornecedorSeeder.pas',
  GrupoSeeder in 'Infra2\Seeders\GrupoSeeder.pas',
  RetaguardaNivelSeeder in 'Infra2\Seeders\RetaguardaNivelSeeder.pas',
  SeederExecute in 'Infra2\Seeders\SeederExecute.pas',
  SubgrupoSeeder in 'Infra2\Seeders\SubgrupoSeeder.pas',
  CaixaModel in 'Infra2\Entity\CaixaModel.pas',
  CodigoAuxiliarModel in 'Infra2\Entity\CodigoAuxiliarModel.pas',
  ConfiguracaoModel in 'Infra2\Entity\ConfiguracaoModel.pas',
  ContaReceberItemModel in 'Infra2\Entity\ContaReceberItemModel.pas',
  ContaReceberModel in 'Infra2\Entity\ContaReceberModel.pas',
  EnderecoModel in 'Infra2\Entity\EnderecoModel.pas',
  FornecedorModel in 'Infra2\Entity\FornecedorModel.pas',
  GrupoModel in 'Infra2\Entity\GrupoModel.pas',
  MigrationModel in 'Infra2\Entity\MigrationModel.pas',
  PessoaModel in 'Infra2\Entity\PessoaModel.pas',
  ProdutoModel in 'Infra2\Entity\ProdutoModel.pas',
  ProprioModel in 'Infra2\Entity\ProprioModel.pas',
  RetaguardaNivelModel in 'Infra2\Entity\RetaguardaNivelModel.pas',
  SubgrupoModel in 'Infra2\Entity\SubgrupoModel.pas',
  CargaUseCase in 'Infra2\UseCase\CargaUseCase.pas',
  ContaReceberUseCase in 'Infra2\UseCase\ContaReceberUseCase.pas',
  DatabaseUseCase in 'Infra2\UseCase\DatabaseUseCase.pas',
  EtiquetaUseCase in 'Infra2\UseCase\EtiquetaUseCase.pas',
  CaixaRepositoryImpl in 'Infra2\Repository\CaixaRepositoryImpl.pas',
  ConfiguracaoRepositoryImpl in 'Infra2\Repository\ConfiguracaoRepositoryImpl.pas',
  ContaReceberRepositoryImpl in 'Infra2\Repository\ContaReceberRepositoryImpl.pas',
  DatabaseRepositoryImpl in 'Infra2\Repository\DatabaseRepositoryImpl.pas',
  EtiquetaRepositoryImpl in 'Infra2\Repository\EtiquetaRepositoryImpl.pas',
  FornecedorRepositoryImpl in 'Infra2\Repository\FornecedorRepositoryImpl.pas',
  GrupoRepositoryImpl in 'Infra2\Repository\GrupoRepositoryImpl.pas',
  ProdutoRepositoryImpl in 'Infra2\Repository\ProdutoRepositoryImpl.pas',
  ProprioRepositoryImpl in 'Infra2\Repository\ProprioRepositoryImpl.pas',
  RetaguardaNivelRepositoryImpl in 'Infra2\Repository\RetaguardaNivelRepositoryImpl.pas',
  SubgrupoRepositoryImpl in 'Infra2\Repository\SubgrupoRepositoryImpl.pas',
  uConexao in 'Infra2\Repository\uConexao.pas',
  uConexaoSyspdv in 'Infra2\Repository\uConexaoSyspdv.pas',
  uConexaoPDV in 'Infra2\Repository\uConexaoPDV.pas',
  uConexaoLocal in 'Infra2\Repository\uConexaoLocal.pas',
  UIEtiqueta in 'Infra2\UI\UIEtiqueta.pas',
  CodigoAuxiliarRepositoryImpl in 'Infra2\Repository\CodigoAuxiliarRepositoryImpl.pas',
  uConexaoSyspdvSQL in 'Infra2\Repository\uConexaoSyspdvSQL.pas',
  EtiquetaLayoutModel in 'Infra2\Entity\EtiquetaLayoutModel.pas',
  EtiquetaPrinter in 'Infra2\Printer\EtiquetaPrinter.pas',
  ConfiguracaoRepository in 'Infra\Repository\RK.Retaguarda\ConfiguracaoRepository.pas',
  EtiquetaPrinterFast in 'Infra2\Printer\EtiquetaPrinterFast.pas',
  UIRegerarNFCe in 'Infra2\Forms\UIRegerarNFCe.pas' {frmUIRegerarNFCe},
  NFCeUseCase in 'Infra2\UseCase\NFCeUseCase.pas',
  NFCeModel in 'Infra2\Entity\NFCeModel.pas',
  NFcePendenteRepositoryImpl in 'Infra2\Repository\NFcePendenteRepositoryImpl.pas',
  NFCeService in 'Infra2\Services\NFCeService.pas',
  ImportarIBPTUseCase in 'Infra2\UseCase\NCM\ImportarIBPTUseCase.pas',
  CSVService in 'Infra2\Services\CSVService.pas',
  NCMRepositoryImpl in 'Infra2\Repository\NCMRepositoryImpl.pas',
  NCMModel in 'Infra2\Entity\NCMModel.pas',
  ListarProdutosUseCase in 'Infra2\UseCase\Produto\ListarProdutosUseCase.pas',
  uFrmLocProduto3 in 'Forms\uFrmLocProduto3.pas' {FrmLocProduto3},
  ListarGruposUseCase in 'Infra2\UseCase\Grupo\ListarGruposUseCase.pas',
  uFrmLocCEST in 'Forms\Loc\uFrmLocCEST.pas' {frmLocCEST},
  uFrmLocCliente in 'Forms\Loc\uFrmLocCliente.pas' {frmLocCliente},
  uFrmLocFinalizadora in 'Forms\Loc\uFrmLocFinalizadora.pas' {frmLocFinalizadora},
  uFrmLocFormaPagamento in 'Forms\Loc\uFrmLocFormaPagamento.pas' {frmLocFormaPagamento},
  uFrmLocFornecedor in 'Forms\Loc\uFrmLocFornecedor.pas' {frmLocFornecedor},
  uFrmLocFun in 'Forms\Loc\uFrmLocFun.pas' {frmLocFun},
  uFrmLocGrupo in 'Forms\Loc\uFrmLocGrupo.pas' {frmLocGrupo},
  uFrmLocIBGE in 'Forms\Loc\uFrmLocIBGE.pas' {frmLocIbge},
  uFrmLocNCM in 'Forms\Loc\uFrmLocNCM.pas' {frmLocNCM},
  uFrmLocPreVenda in 'Forms\Loc\uFrmLocPreVenda.pas' {frmLocPreVenda},
  uFrmLocProduto in 'Forms\Loc\uFrmLocProduto.pas' {frmLocProduto},
  uFrmLocSubGrupo in 'Forms\Loc\uFrmLocSubGrupo.pas' {frmlocSubGrupo},
  uFrmLocVendedor in 'Forms\Loc\uFrmLocVendedor.pas' {frmLocVendedor};

{$R *.res}

begin
//  ReportMemoryLeaksOnShutdown := true;
  CreateMutex(nil, True, 'Borges');
  if GetLastError = ERROR_ALREADY_EXISTS then  begin  // se aplicativo já estiver aberto não abre novamente
    Application.MessageBox('O sistema já está aberto.', 'Sistema Informa', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmConexao, dmConexao);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmProduto, frmProduto);
  Application.CreateForm(TdmUtils, dmUtils);
  Application.CreateForm(TfrmGrupo, frmGrupo);
  Application.CreateForm(TdmGrupo, dmGrupo);
  Application.CreateForm(TdmSubgrupo, dmSubgrupo);
  Application.CreateForm(TfrmSubGrupo, frmSubGrupo);
  Application.CreateForm(TfrmLocGrupo, frmLocGrupo);
  Application.CreateForm(TfrmlocSubGrupo, frmlocSubGrupo);
  Application.CreateForm(TfrmTributacao, frmTributacao);
  Application.CreateForm(TdmTributacao, dmTributacao);
  Application.CreateForm(TdmNCM, dmNCM);
  Application.CreateForm(TfrmLocNCM, frmLocNCM);
  Application.CreateForm(TfrmLocCEST, frmLocCEST);
  Application.CreateForm(TdmCEST, dmCEST);
  Application.CreateForm(TfrmFuncionario, frmFuncionario);
  Application.CreateForm(TdmFinalizadora, dmFinalizadora);
  Application.CreateForm(TfrmFinalizadora, frmFinalizadora);
  Application.CreateForm(TdmFornecedor, dmFornecedor);
  Application.CreateForm(TdmProduto, dmProduto);
  Application.CreateForm(TfrmFornecedor, frmFornecedor);
  Application.CreateForm(TdmCliente, dmCliente);
  Application.CreateForm(TfrmCliente, frmCliente);
  Application.CreateForm(TdmFuncionario, dmFuncionario);
  Application.CreateForm(TfrmPDVCarga, frmPDVCarga);
  Application.CreateForm(TdmCaixa, dmCaixa);
  Application.CreateForm(TdmConexaoCaixa, dmConexaoCaixa);
  Application.CreateForm(TdmCargaPDV, dmCargaPDV);
  Application.CreateForm(TdmCargaCaixa, dmCargaCaixa);
  Application.CreateForm(TfrmProprio, frmProprio);
  Application.CreateForm(TdmProprio, dmProprio);
  Application.CreateForm(TfrmBalanca, frmBalanca);
  Application.CreateForm(TfrmRelPainel, frmRelPainel);
  Application.CreateForm(TdmRelCupom, dmRelCupom);
  Application.CreateForm(TfrmRelCupom, frmRelCupom);
  Application.CreateForm(TfrmRelProduto, frmRelProduto);
  Application.CreateForm(TdmRelProduto, dmRelProduto);
  Application.CreateForm(TFrmRelPagamento, FrmRelPagamento);
  Application.CreateForm(TdmRelFinalizadora, dmRelFinalizadora);
  Application.CreateForm(TfrmConfiguracoes, frmConfiguracoes);
  Application.CreateForm(TfrmEtiqueta, frmEtiqueta);
  Application.CreateForm(TfrmLocProduto, frmLocProduto);
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TfrmCaixaAcesso, frmCaixaAcesso);
  Application.CreateForm(TdmCaixaAcesso, dmCaixaAcesso);
  Application.CreateForm(TFrmRelSaldoEstoque, FrmRelSaldoEstoque);
  Application.CreateForm(TdmRelEstoque, dmRelEstoque);
  Application.CreateForm(TfrmContasReceber, frmContasReceber);
  Application.CreateForm(TdmContasReceber, dmContasReceber);
  Application.CreateForm(TfrmContasReceberPgto, frmContasReceberPgto);
  Application.CreateForm(TfrmLocFinalizadora, frmLocFinalizadora);
  Application.CreateForm(TfrmLocCliente, frmLocCliente);
  Application.CreateForm(TdmAuditoria, dmAuditoria);
  Application.CreateForm(TfrmAuditoria, frmAuditoria);
  Application.CreateForm(TFrmPreVenda, FrmPreVenda);
  Application.CreateForm(TfrmLocFun, frmLocFun);
  Application.CreateForm(TdmPreVenda, dmPreVenda);
  Application.CreateForm(TfrmPreVendaPgto, frmPreVendaPgto);
  Application.CreateForm(TfrmLocPreVenda, frmLocPreVenda);
  Application.CreateForm(TfrmLocFornecedor, frmLocFornecedor);
  Application.CreateForm(TfrmLocIbge, frmLocIbge);
  Application.CreateForm(TfrmRelFuncComissao, frmRelFuncComissao);
  Application.CreateForm(TdmRelFuncionario, dmRelFuncionario);
  Application.CreateForm(TfrmAcessoRetaguarda, frmAcessoRetaguarda);
  Application.CreateForm(TfrmEtiquetaConfig, frmEtiquetaConfig);
  Application.CreateForm(TdmValidade, dmValidade);
  Application.CreateForm(TfrmValidadeIncluir, frmValidadeIncluir);
  Application.CreateForm(TfrmEstoqueEditar, frmEstoqueEditar);
  Application.CreateForm(TdmEstoque, dmEstoque);
  Application.CreateForm(TfrmValidade, frmValidade);
  Application.CreateForm(TfrmExtratoEstoque, frmExtratoEstoque);
  Application.CreateForm(TfrmRelPerformanceProduto, frmRelPerformanceProduto);
  Application.CreateForm(TfrmAtualizarBanco, frmAtualizarBanco);
  Application.CreateForm(TDataMd, DataMd);
  Application.CreateForm(TFrmRelFechamento, FrmRelFechamento);
  Application.CreateForm(TfrmImportar, frmImportar);
  Application.CreateForm(TdmConexaoIntegracao, dmConexaoIntegracao);
  Application.CreateForm(TfrmImportarPersonalizado, frmImportarPersonalizado);
  Application.CreateForm(TfrmImpressao, frmImpressao);
  Application.CreateForm(TdmCodigoAuxiliar, dmCodigoAuxiliar);
  Application.CreateForm(TdmContasReceberPagamento, dmContasReceberPagamento);
  Application.CreateForm(TfrmNotificacao, frmNotificacao);
  Application.CreateForm(TfrmNFCePendente, frmNFCePendente);
  Application.CreateForm(TfrmEnviaNFce, frmEnviaNFce);
  Application.CreateForm(TfrmUIAtualizarBanco, frmUIAtualizarBanco);
  Application.CreateForm(TfrmUIRegerarNFCe, frmUIRegerarNFCe);
  Application.CreateForm(TFrmLocProduto3, FrmLocProduto3);
  Application.CreateForm(TfrmLocCEST, frmLocCEST);
  Application.CreateForm(TfrmLocCliente, frmLocCliente);
  Application.CreateForm(TfrmLocFinalizadora, frmLocFinalizadora);
  Application.CreateForm(TfrmLocFormaPagamento, frmLocFormaPagamento);
  Application.CreateForm(TfrmLocFornecedor, frmLocFornecedor);
  Application.CreateForm(TfrmLocFun, frmLocFun);
  Application.CreateForm(TfrmLocGrupo, frmLocGrupo);
  Application.CreateForm(TfrmLocIbge, frmLocIbge);
  Application.CreateForm(TfrmLocNCM, frmLocNCM);
  Application.CreateForm(TfrmLocPreVenda, frmLocPreVenda);
  Application.CreateForm(TfrmLocProduto, frmLocProduto);
  Application.CreateForm(TfrmlocSubGrupo, frmlocSubGrupo);
  Application.CreateForm(TfrmLocVendedor, frmLocVendedor);
  Application.Run;
end.
