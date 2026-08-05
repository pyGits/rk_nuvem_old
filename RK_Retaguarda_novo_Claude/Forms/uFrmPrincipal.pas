unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmProduto, Vcl.Menus,Classe.Variaveis,uFrmGrupo,uFrmSubGrupo,uFrmTributacao,uFrmFinalizadora,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls, acPNG,Conversao,uFrmFornecedor,uFrmCliente,uFrmFuncionario,uFrmPDVCarga,uFrmProprio,uFrmBalanca,uFrmRelPainel,uFrmRelCupom,uFrmRelProduto,uFrmRelPagamento,uFrmConfiguracoes,uFrmEtiqueta,uFrmLogin,
  LockApplication,uFrmCaixaAcesso,uFrmRelSaldoEstoque,uFrmContasreceber,uFrmAuditoria,uFrmPreVenda,
  ACBrBase, ACBrLCB, frxClass, frxExportXLS, vcl.gtxXport, vcl.gtFRXport,uFrmRelFuncComissao,uFrmRetaguardaAcesso,Classe.AcessoRetaguarda,
  uFrmValidade,uFrmRelExtratoEstoque,uFrmRelPerformanceProduto,uFrmRelFechamento,uFrmImportar,
  System.Notification,System.Generics.collections,uFrmImportarPersonalizado,ConfiguracaoController,uFrmNFCePendente,Global

//  Notificacao,NotificacaoController,uFrmNotificacao
  ;


type
  TfrmPrincipal = class(TForm)
    pnl_fundo: TPanel;
    pnl_topo: TPanel;
    Label1: TLabel;
    Image1: TImage;
    pnl_lateral: TPanel;
    btnCadastro: TSpeedButton;
    pnl_exportar: TPanel;
    btnExportar: TSpeedButton;
    pnl_Cadastro: TPanel;
    btnFrmTrb: TSpeedButton;
    btnFrmProduto: TSpeedButton;
    btnSubClass: TSpeedButton;
    pnl_sub_classifcacao: TPanel;
    btnFrmGrupo: TSpeedButton;
    btmFrmSubGrupo: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    btnFrmFornecedor: TSpeedButton;
    btnFrmCliente: TSpeedButton;
    btnCadastroFuncionario: TSpeedButton;
    btnConfigurações: TSpeedButton;
    btnFrmFinalizadora: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btnFrmProprio: TSpeedButton;
    btnImprimir: TSpeedButton;
    pnl_imprimir: TPanel;
    btnFrmEtiqueta: TSpeedButton;
    Panel5: TPanel;
    btnRelatorio: TSpeedButton;
    pnl_relatorio: TPanel;
    Panel6: TPanel;
    btnRelSubCaixa: TSpeedButton;
    pnl_sub_rel_caixa: TPanel;
    btnFrmRelGraficoVenda: TSpeedButton;
    Panel7: TPanel;
    btnFrmRelCupom: TSpeedButton;
    btnFrmRelProduto: TSpeedButton;
    btnFrmRelFinalizadora: TSpeedButton;
    Panel4: TPanel;
    lblProprio: TLabel;
    store_protect: TLockApplication;
    btnContasReceber: TSpeedButton;
    pnl_Configuracoes: TPanel;
    btnFrmAcessoRetaguarda: TSpeedButton;
    Panel9: TPanel;
    btnFrmAcessoPDV: TSpeedButton;
    btnFrmConfiguracoes: TSpeedButton;
    pnl_financeiro: TPanel;
    btnFrmContasAReceber: TSpeedButton;
    Panel10: TPanel;
    btnAuditoria: TSpeedButton;
    btnVenda: TSpeedButton;
    pnl_vendas: TPanel;
    btnFrmPreVendas: TSpeedButton;
    Panel11: TPanel;
    frxXLSExport1: TfrxXLSExport;
    gtFRExport1: TgtFRExport;
    btnRelSubFuncionario: TSpeedButton;
    pnl_sub_rel_funcionario: TPanel;
    btnFrmRelComissao: TSpeedButton;
    Panel12: TPanel;
    btnValidade: TSpeedButton;
    btnRelSubEstoque: TSpeedButton;
    pnl_sub_rel_estoque: TPanel;
    btnFrmExtrato: TSpeedButton;
    Panel13: TPanel;
    btnFrmRelSaldoEstoque: TSpeedButton;
    btnRelSubVendas: TSpeedButton;
    pnl_sub_rel_vendas: TPanel;
    Panel14: TPanel;
    btnFrmRelPerformance: TSpeedButton;
    btnFrmRelFechamento: TSpeedButton;
    btnFrmImportar: TSpeedButton;
    btnNotificacoes: TSpeedButton;
    btnAtualizarLic: TSpeedButton;
    btnFrmNFCePendente: TSpeedButton;
    procedure FormCreate(Sender: TObject);

    procedure S2Click(Sender: TObject);
    procedure S3Click(Sender: TObject);
    procedure T1Click(Sender: TObject);
    procedure btnCadastroClick(Sender: TObject);
    procedure btnFrmProdutoClick(Sender: TObject);
    procedure btnFrmTrbClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure btnFrmGrupoClick(Sender: TObject);
    procedure btmFrmSubGrupoClick(Sender: TObject);
    procedure btnSubClassClick(Sender: TObject);
    procedure btnFrmFinalizadoraClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnRelatorioClick(Sender: TObject);
    procedure pnl_fundoClick(Sender: TObject);
    procedure pnl_lateralClick(Sender: TObject);
    procedure btnFrmFornecedorClick(Sender: TObject);
    procedure btnFrmClienteClick(Sender: TObject);
    procedure btnCadastroFuncionarioClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnFrmProprioClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure btnRelSubCaixaClick(Sender: TObject);
    procedure btnFrmRelGraficoVendaClick(Sender: TObject);
    procedure btnFrmRelCupomClick(Sender: TObject);
    procedure btnFrmRelProdutoClick(Sender: TObject);
    procedure btnFrmRelFinalizadoraClick(Sender: TObject);
    procedure btnFrmEtiquetaClick(Sender: TObject);
    procedure btnFrmConfiguracoesClick(Sender: TObject);
    procedure btnConfiguraçõesClick(Sender: TObject);
    procedure btnFrmAcessoPDVClick(Sender: TObject);
    procedure btnFrmRelSaldoEstoqueClick(Sender: TObject);
    procedure btnFrmContasAReceberClick(Sender: TObject);
    procedure btnContasReceberClick(Sender: TObject);
    procedure btnAuditoriaClick(Sender: TObject);
    procedure btnVendaClick(Sender: TObject);
    procedure btnFrmPreVendasClick(Sender: TObject);
    procedure btnRelSubFuncionarioClick(Sender: TObject);
    procedure btnFrmRelComissaoClick(Sender: TObject);

    procedure btnFrmAcessoRetaguardaClick(Sender: TObject);
    procedure btnValidadeClick(Sender: TObject);
    procedure btnRelSubEstoqueClick(Sender: TObject);
    procedure btnFrmExtratoClick(Sender: TObject);
    procedure btnRelSubVendasClick(Sender: TObject);
    procedure btnFrmRelPerformanceClick(Sender: TObject);
    procedure btnFrmRelFechamentoClick(Sender: TObject);
    procedure btnFrmImportarClick(Sender: TObject);
    procedure btnNotificacoesClick(Sender: TObject);
    procedure btnAtualizarLicClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFrmNFCePendenteClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure Inicializar;
    procedure CarregarProprio;
    procedure ExibirMenu(menu:TMenu);
    procedure FecharMenus;

    function ChecaNivelAcesso(menu:string):Boolean;
  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation
uses Classe.Funcoes;

{$R *.dfm}

procedure TfrmPrincipal.btnExportarClick(Sender: TObject);
begin
ExibirMenu(mnExportar);
end;

procedure TfrmPrincipal.btnFrmAcessoPDVClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Nível Acesso > PDV')) then
begin
frmCaixaAcesso := TfrmCaixaAcesso.Create(Self);
frmCaixaAcesso.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmAcessoRetaguardaClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Nível Acesso > Retaguarda')) then
begin
frmAcessoRetaguarda := TfrmAcessoRetaguarda.Create(self);
frmAcessoRetaguarda.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmClienteClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Cliente')) then
begin
frmCliente := TFrmCliente.Create(self);
frmCliente.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmConfiguracoesClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Configurações')) then
begin
frmConfiguracoes := TfrmConfiguracoes.Create(self);
frmConfiguracoes.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmContasAReceberClick(Sender: TObject);
var
  frmContasReceber : TfrmContasReceber;
begin
if (ChecaNivelAcesso('Contas a Receber')) then
begin
frmContasReceber := TfrmContasReceber.Create(nil);
frmContasReceber.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmEtiquetaClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Etiqueta')) then
begin
EtiquetaUseCase.abrir;
end;
end;

procedure TfrmPrincipal.btnFrmExtratoClick(Sender: TObject);
var
frmExtratoEstoque:TfrmExtratoEstoque;
begin
frmExtratoEstoque := TfrmExtratoEstoque.Create(self);
frmExtratoEstoque.ShowModal;
end;

procedure TfrmPrincipal.btnFrmFinalizadoraClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Finalizadora')) then
begin
frmFinalizadora := TFrmFinalizadora.Create(self);
frmFinalizadora.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmFornecedorClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Fornecedor')) then
begin
frmFornecedor := TfrmFornecedor.Create(self);
frmfornecedor.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmGrupoClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Grupo')) then
begin
frmGrupo := TFrmGrupo.Create(self);
frmGrupo.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmImportarClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Importar')) then
begin
frmImportar := TfrmImportar.Create(self);
frmImportar.ShowModal;
end;

end;

procedure TfrmPrincipal.btnFrmNFCePendenteClick(Sender: TObject);
begin
TfrmNFCePendente.abrir;
end;

procedure TfrmPrincipal.btnFrmPreVendasClick(Sender: TObject);
begin

begin
if (ChecaNivelAcesso('Pré Venda')) then
begin
FrmPreVenda := TFrmPreVenda.Create(Self);
FrmPreVenda.ShowModal;
end;
end;

end;
procedure TfrmPrincipal.btnFrmProdutoClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Produto')) then
begin
frmProduto := TFrmProduto.Create(self);
frmProduto.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmProprioClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Próprio')) then
begin
frmProprio := TfrmProprio.Create(self);
frmProprio.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmTrbClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Tributação')) then
begin
frmTributacao := TFrmTributacao.Create(self);
frmTributacao.ShowModal;
end;
end;

procedure TfrmPrincipal.btnImprimirClick(Sender: TObject);
begin
ExibirMenu(mnImprimir);
end;

procedure TfrmPrincipal.btnNotificacoesClick(Sender: TObject);
begin
//TfrmNotificacao.Create(self).ShowModal;
end;

procedure TfrmPrincipal.btnRelatorioClick(Sender: TObject);
begin
ExibirMenu(mnRelatorio);
end;

procedure TfrmPrincipal.btnRelSubCaixaClick(Sender: TObject);
begin
ExibirMenu(sbRelCaixa);
end;

procedure TfrmPrincipal.btnRelSubEstoqueClick(Sender: TObject);
begin
ExibirMenu(sbRelEstoque);
end;

procedure TfrmPrincipal.btnRelSubFuncionarioClick(Sender: TObject);
begin
ExibirMenu(sbRelFuncionario);
end;

procedure TfrmPrincipal.btnRelSubVendasClick(Sender: TObject);
begin
ExibirMenu(sbRelVendas);
end;

procedure TfrmPrincipal.btnSubClassClick(Sender: TObject);
begin
ExibirMenu(sbClassificacao);
end;

procedure TfrmPrincipal.btnValidadeClick(Sender: TObject);
var
  frmValidade:TFrmValidade;
begin
  frmValidade := TfrmValidade.Create(self);
  frmValidade.Position := poMainFormCenter;
  frmValidade.BorderStyle := bsSingle;
  frmValidade.ShowModal;
end;

procedure TfrmPrincipal.btnVendaClick(Sender: TObject);
begin
ExibirMenu(mnVendas);
end;

procedure TfrmPrincipal.CarregarProprio;
begin
with VariaveisSrv.oProprio do
begin
VariaveisSrv.oFuncionarioController.CarregarFuncionario(VariaveisSrv.oFuncionario);
lblProprio.Caption := Pessoa.Nome + #13 + 'Usuário: '+VariaveisSrv.oFuncionario.Pessoa.Nome;
lblProprio.Caption := lblProprio.caption + #13 + 'Sistema vence em '+inttostr(store_protect.Dias_RestantesU)+ ' Dias !';
end;

end;

function TfrmPrincipal.ChecaNivelAcesso(menu: string): Boolean;
var
  oAcesso:TAcessoRetaguarda;
  i:integer;
  arrayNiv:TArray<string>;
  flagResult :Boolean;
begin
  try
    oAcesso := TAcessoRetaguarda.Create;
    oAcesso.Descricao := menu;

    if VariaveisSrv.oUtilsController.preencherNivelAcessoRetaguarda(oAcesso) then
    begin
      // checar nivel usuario com acesso
      flagResult := false;
      // senha validada, validar nivel de acesso
      arrayNiv := Split(oAcesso.FuncaoNivel,';');
      for I := 0 to Length(arrayNiv)-1 do
      begin
        if arrayNiv[I] = IntToStr(VariaveisSrv.oFuncionario.cargo) then
        begin
          flagResult := true;
        end;

      end;
      if flagResult then
      begin
        result := True;
      end
      else
      begin
        result := false;
        ShowMessage('Usuário sem acesso');
      end;
    end
    else
    begin
      ShowMessage('Nível de acesso não encontrado no banco de dados !');
      Result := false;
    end;

  finally
    oAcesso.Destroy;
  end;
end;

procedure TfrmPrincipal.ExibirMenu(menu: TMenu);
begin
// oculta todos paineis
FecharMenus;

case menu of
  mnProduto:begin
  pnl_Cadastro.visible := True;
  end;
  mnExportar:
  begin
  pnl_exportar.Visible := true
  end;
  mnImprimir:
  begin
  pnl_imprimir.Visible := true;
  end;
  mnRelatorio:
  begin
    pnl_relatorio.visible := true;
  end;
  mnConfiguracoes:begin
    pnl_Configuracoes.Visible := true;
  end;

  mnFinanceiro:begin
    pnl_Financeiro.visible := True;
  end;

  mnVendas:begin
    pnl_vendas.Visible := true;
  end;


  sbClassificacao:begin
    pnl_sub_classifcacao.visible := true;
  end;
  sbRelCaixa:
  begin
    pnl_sub_rel_caixa.Visible := true;
  end;
  sbRelFuncionario:
  begin
    pnl_sub_rel_funcionario.Visible := true;
  end;
  sbRelEstoque:
  begin
    pnl_sub_rel_estoque.Visible := true;
  end;
  sbRelVendas:
  begin
    pnl_sub_rel_vendas.visible := true;
  end;

end;
end;



procedure TfrmPrincipal.FecharMenus;
begin
// oculta todos paineis
pnl_vendas.visible := false;
pnl_financeiro.visible := false;
pnl_Cadastro.Visible := false;
pnl_exportar.visible := false;
pnl_imprimir.Visible := false;
pnl_relatorio.visible := false;
pnl_sub_classifcacao.Visible := false;
pnl_sub_rel_caixa.Visible:=false;
pnl_Configuracoes.Visible := false;
pnl_sub_rel_funcionario.Visible := False;
pnl_sub_rel_estoque.Visible := false;
pnl_sub_rel_vendas.Visible := false;
end;


procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
Inicializar;
end;

procedure TfrmPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // 🔥 bloqueia Alt + F4
  if (Key = VK_F4) and (ssAlt in Shift) then
    Key := 0;

end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
//Notificacao_Controller.ExibirNotificacoes;
end;

procedure TfrmPrincipal.Inicializar;
begin

VariaveisSrv := TVariaveis.create;

FrmLogin := TFrmLogin.Create(Self);
FrmLogin.ShowModal;
   store_protect.IDSistema := 3000;
   store_protect.executar('');
CarregarProprio;




end;




procedure TfrmPrincipal.pnl_fundoClick(Sender: TObject);
begin
FecharMenus;
end;

procedure TfrmPrincipal.pnl_lateralClick(Sender: TObject);
begin
FecharMenus;
end;

procedure TfrmPrincipal.S2Click(Sender: TObject);
begin
frmGrupo := TFrmGrupo.Create(self);
frmGrupo.ShowModal;
end;

procedure TfrmPrincipal.S3Click(Sender: TObject);
begin
if (ChecaNivelAcesso('Subgrupo')) then
begin
frmSubGrupo := TfrmSubGrupo.Create(self);
frmSubGrupo.ShowModal;
end;
end;

procedure TfrmPrincipal.SpeedButton1Click(Sender: TObject);
begin
if (ChecaNivelAcesso('Carga PDV')) then
begin
frmPDVCarga := TfrmPDVCarga.Create(Self);
frmPDVCarga.ShowModal;
end;
end;

procedure TfrmPrincipal.SpeedButton2Click(Sender: TObject);
begin
if (ChecaNivelAcesso('Carga Balança')) then
begin
frmBalanca := TfrmBalanca.Create(self);
frmBalanca.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmRelComissaoClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Funcionários>Comissão')) then
begin
frmRelFuncComissao := TfrmRelFuncComissao.Create(self);
frmRelFuncComissao.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmRelCupomClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Caixa>Cupom')) then
begin
frmRelCupom := TfrmRelCupom.Create(Self);
frmRelCupom.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmRelFechamentoClick(Sender: TObject);
begin
FrmRelFechamento := TFrmRelFechamento.Create(self);
FrmRelFechamento.ShowModal;
end;

procedure TfrmPrincipal.btnFrmRelFinalizadoraClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Caixa>Finalização')) then
begin
FrmRelPagamento := TFrmRelPagamento.Create(self);
FrmRelPagamento.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmRelGraficoVendaClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Caixa>Gráfico de Vendas')) then
begin
frmRelPainel := TfrmRelPainel.Create(Self);
frmRelPainel.ShowModal;
end;
end;

procedure TfrmPrincipal.btnFrmRelPerformanceClick(Sender: TObject);
begin
frmRelPerformanceProduto := TfrmRelPerformanceProduto.Create(self);
frmRelPerformanceProduto.ShowModal;
end;

procedure TfrmPrincipal.btnFrmRelProdutoClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Caixa>Produto')) then
begin
frmRelProduto := TfrmRelProduto.Create(Self);
frmRelProduto.showmodal;
end;
end;

procedure TfrmPrincipal.btnFrmRelSaldoEstoqueClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Caixa>Saldo Estoque')) then
begin
FrmRelSaldoEstoque := TFrmRelSaldoEstoque.Create(self);
FrmRelSaldoEstoque.showmodal;
end;
end;


procedure TfrmPrincipal.btmFrmSubGrupoClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Subgrupo')) then
begin
frmSubGrupo := TfrmSubGrupo.Create(self);
frmSubGrupo.ShowModal;
end;
end;

procedure TfrmPrincipal.btnAtualizarLicClick(Sender: TObject);
begin
store_protect.renovar;
end;

procedure TfrmPrincipal.btnAuditoriaClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Auditoria')) then
begin
frmAuditoria := TfrmAuditoria.Create(Self);
frmAuditoria.ShowModal;
end;
end;

procedure TfrmPrincipal.btnCadastroClick(Sender: TObject);
var
  Notification: TNotification;
begin
ExibirMenu(mnProduto);
end;

procedure TfrmPrincipal.btnCadastroFuncionarioClick(Sender: TObject);
begin
if (ChecaNivelAcesso('Funcionário')) then
begin
frmFuncionario := TfrmFuncionario.Create(Self);
frmFuncionario.ShowModal;
end;
end;

procedure TfrmPrincipal.btnConfiguraçõesClick(Sender: TObject);
begin
ExibirMenu(mnConfiguracoes);
end;

procedure TfrmPrincipal.btnContasReceberClick(Sender: TObject);
begin
ExibirMenu(mnFinanceiro);
end;

procedure TfrmPrincipal.T1Click(Sender: TObject);
begin
frmTributacao := TFrmTributacao.Create(self);
frmTributacao.ShowModal;
end;

end.
