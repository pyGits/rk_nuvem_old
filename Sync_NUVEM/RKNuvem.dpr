program RKNuvem;

uses
  Vcl.Forms,
  winapi.Windows,
  Login in 'Login.pas' {frmLogin},
  uAPIRequest in 'API\uAPIRequest.pas',
  uJsonUtils in 'API\uJsonUtils.pas',
  Principal in 'Principal.pas' {frmPrincipal},
  SelecionarLoja in 'SelecionarLoja.pas' {frmLoja},
  Loja in 'Classes_Varejo\Loja.pas',
  Utils in 'API\Utils.pas',
  Produto in 'Classes_RK\Produto.pas',
  Funcoes in 'Classes_RK\Funcoes.pas',
  Conexao in 'DAO_RK\Conexao.pas' {dmConexao: TDataModule},
  uDmProduto in 'DAO_RK\uDmProduto.pas' {dmProduto: TDataModule},
  Preco in 'Classes_RK\Preco.pas',
  uDmPreco in 'DAO_RK\uDmPreco.pas' {dmPreco: TDataModule},
  uDmTributacaoPDV in 'DAO_RK_PDV\uDmTributacaoPDV.pas' {dmTributacaoPDV: TDataModule},
  Tributacao in 'Classes_RK\Tributacao.pas',
  ConexaoPDV in 'DAO_RK_PDV\ConexaoPDV.pas' {uDmConexaoPDV: TDataModule},
  uDmPrecoPDV in 'DAO_RK_PDV\uDmPrecoPDV.pas' {DmPrecoPDV: TDataModule},
  uDmProdutoPDV in 'DAO_RK_PDV\uDmProdutoPDV.pas' {dmProdutoPDV: TDataModule},
  uDmCaixa in 'DAO_RK\uDmCaixa.pas' {dmCaixa: TDataModule},
  uDmTributacao in 'DAO_RK\uDmTributacao.pas' {dmTributacao: TDataModule},
  uDmVenda in 'DAO_RK\uDmVenda.pas' {dmVenda: TDataModule},
  Cupom in 'Classes_RK\Cupom.pas',
  Estoque in 'Classes_RK\Estoque.pas',
  Finalizadora in 'Classes_RK\Finalizadora.pas',
  uDmFinalizadora in 'DAO_RK\uDmFinalizadora.pas' {dmFinalizadora: TDataModule},
  uDmFinalizadoraPDV in 'DAO_RK_PDV\uDmFinalizadoraPDV.pas' {DmFinalizadoraPDV: TDataModule},
  Funcionario in 'Classes_RK\Funcionario.pas',
  uDmFuncionario in 'DAO_RK\uDmFuncionario.pas' {dmFuncionario: TDataModule},
  uDmFuncionarioPDV in 'DAO_RK_PDV\uDmFuncionarioPDV.pas' {dmFuncionarioPDV: TDataModule},
  NaoFiscal in 'Classes_RK\NaoFiscal.pas',
  Fechamento in 'Classes_RK\Fechamento.pas',
  Cliente in 'Classes_RK\Cliente.pas',
  uDmCliente in 'DAO_RK\uDmCliente.pas' {dmCliente: TDataModule},
  uConexao in 'DAO_RK\uConexao.pas',
  uDmClientePDV in 'DAO_RK_PDV\uDmClientePDV.pas' {dmClientePDV: TDataModule},
  CargaPDVUseCase in 'Infra\UseCase\CargaPDVUseCase.pas',
  CaixaRepository in 'Infra\Repository\Retaguarda\CaixaRepository.pas',
  CaixaModel in 'Infra\Entity\CaixaModel.pas',
  uConexaoRetaguarda in 'Infra\Repository\Retaguarda\uConexaoRetaguarda.pas',
  Global in 'Infra\Application\Global.pas',
  uLogErro in 'Infra\Application\uLogErro.pas',
  ClienteAPIRepository in 'Infra\Repository\API\ClienteAPIRepository.pas',
  ClienteModel in 'Infra\Entity\ClienteModel.pas',
  ClientePDVRepository in 'Infra\Repository\PDV\ClientePDVRepository.pas',
  uConexaoPDV in 'Infra\Repository\PDV\uConexaoPDV.pas',
  ContaReceber in 'Classes_RK\ContaReceber.pas',
  ErroPDV in 'Classes_RK\ErroPDV.pas',
  ContaReceberPDVRepository in 'Infra\Repository\PDV\ContaReceberPDVRepository.pas',
  ErroPDVRepository in 'Infra\Repository\PDV\ErroPDVRepository.pas',
  SubidaContaReceberUseCase in 'Infra\UseCase\SubidaContaReceberUseCase.pas',
  SubidaErroPDVUseCase in 'Infra\UseCase\SubidaErroPDVUseCase.pas',
  IndicesNuvemRepository in 'Infra\Repository\Retaguarda\IndicesNuvemRepository.pas';

{$R *.res}
 var
  Hand : THandle;
begin
  CreateMutex(nil, True, 'aaXyZzWw');
  if GetLastError = ERROR_ALREADY_EXISTS then  begin  // se aplicativo já estiver aberto não abre novamente
//    Application.MessageBox('O sistema já está aberto.', 'Sistema Informa', MB_OK + MB_ICONINFORMATION);
    Exit;
  end;
  Application.Initialize;
  Application.Title := 'RK Nuvem';
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmLoja, frmLoja);
  Application.CreateForm(TdmConexao, dmConexao);
  Application.CreateForm(TdmProduto, dmProduto);
  Application.CreateForm(TdmPreco, dmPreco);
  Application.CreateForm(TdmTributacaoPDV, dmTributacaoPDV);
  Application.CreateForm(TuDmConexaoPDV, uDmConexaoPDV);
  Application.CreateForm(TDmPrecoPDV, DmPrecoPDV);
  Application.CreateForm(TdmProdutoPDV, dmProdutoPDV);
  Application.CreateForm(TdmCaixa, dmCaixa);
  Application.CreateForm(TdmTributacao, dmTributacao);
  Application.CreateForm(TdmVenda, dmVenda);
  Application.CreateForm(TdmFinalizadora, dmFinalizadora);
  Application.CreateForm(TDmFinalizadoraPDV, DmFinalizadoraPDV);
  Application.CreateForm(TdmFuncionario, dmFuncionario);
  Application.CreateForm(TdmFuncionarioPDV, dmFuncionarioPDV);
  Application.CreateForm(TdmCliente, dmCliente);
  Application.CreateForm(TdmClientePDV, dmClientePDV);
  Application.Run;

end.
