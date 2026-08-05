unit Classe.Variaveis;

interface
  uses uProdutoController,uUtilsController,uGrupoController,uSubGrupoController,uTributacaoController,uNCMController,uCESTController
  ,uFinalizadoraController,uFornecedorController,uClienteController,uFuncionarioController,uCaixaController,uCargaController,uProprioController,uRelatorioController,Classe.Configuracoes,Classe.Proprio,Classe.Funcionario,System.SysUtils,VCL.Dialogs,VCL.Forms,uContasReceberController
  ,uAuditoriaController,uPreVendaController , uValidadeController,uEstoqueController;
type
  TVariaveis = class
    private
    public
    // CONTROLLER
    oProdutoController :TProdutoController;
    oGrupoController :TGrupoController;
    oSubGrupoController :TSubgrupoController;
    oUtilsController : TUtilsController;
    oTributacaoController : TTributacaoController;
    oNCMController : TNCMController;
    oCESTController : TCESTController;
    oFinalizadoraController : TFinalizadoraController;
    oFornecedorController : TFornecedorController;
    oClienteController : TClienteController;
    oFuncionarioController : TFuncionarioController;
    oCaixaController:TCaixaController;
    oCargaPDVController:TCargaController;
    oProprioController:TProprioController;
    oRelatorioController:TRelatorioController;
    oContasReceberController:TContasReceberController;
    oAuditoriaController:TAuditoriaController;
    oPreVendaController:TPreVendaController;
    oValidadeController:TValidadeController;
    oEstoqueController:TEstoqueController;


    // VARIAVEIS
    oConfiguracoes:TConfiguracoes;
    oProprio:TProprio;
    oFuncionario:TFuncionario;



    constructor create;
    destructor destroy;override;
  end;
  var
    VariaveisSrv :TVariaveis;
implementation

{ TVariaveis }

constructor TVariaveis.create;
begin
try
  // INICIALIZAR CONEXAO COM BANCO


  oProdutoController := TProdutoController.create;
  oUtilsController :=TUtilsController.Create;
  oGrupoController := TGrupoController.Create;
  oSubgrupoController := TSubGrupoController.Create;
  oTributacaoController := TTributacaoController.Create;
  oNCMController := TNCMController.Create;
  oCESTController := TCESTController.Create;
  oFinalizadoraController := TFinalizadoraController.create;
  oFornecedorController := TFornecedorController.Create;
  oClienteController := TClienteController.Create;
  oFuncionarioController := TFuncionarioController.Create;
  oCaixaController := TCaixaController.Create;
  oCargaPDVController := TCargaController.Create;
  oProprioController := TProprioController.Create;
  oRelatorioController := TRelatorioController.Create;
  oContasReceberController := TContasReceberController.Create;
  oAuditoriaController := TAuditoriaController.Create;
  oPreVendaController := TPreVendaController.Create;
  oValidadeController := TValidadeController.create;
  oEstoqueController := TEstoqueController.create;


  oConfiguracoes := TConfiguracoes.Create;
  oProprio := TProprio.create;
  oFuncionario := TFuncionario.Create;

  oProprioController.CarregarProprio(oProprio);
  oUtilsController.CarregarConfiguracoesBD(oConfiguracoes);
except
 on E:Exception do
 begin
   ShowMessage('Erro ao inicializar configurações do sistema ! Contate o suporte: '+E.message);
   Application.Terminate;
 end;

end;

end;

destructor TVariaveis.destroy;
begin
  oProdutoController.Destroy;
  oSubGrupoController.destroy;
  oGrupoController.Destroy;
  oUtilsController.Destroy;
  oNCMController.Destroy;
  oCESTController.Destroy;
  oFinalizadoraController.Destroy;
  oFornecedorController.Destroy;
  oClienteController.Destroy;
  oFuncionarioController.destroy;
  oCaixaController.Destroy;
  oCargaPDVController.Destroy;
  oProprioController.Destroy;
  oRelatorioController.Destroy;
  oFuncionario.destroy;
  oConfiguracoes.Destroy;
  oContasReceberController.Destroy;
  oAuditoriaController.Destroy;
  oPreVendaController.Destroy;
  oValidadeController.Destroy;
  oEstoqueController.Destroy;
  inherited;
end;

end.
