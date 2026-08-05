unit EtiquetaUseCase;

interface
uses ConfiguracaoRepositoryImpl,ConfiguracaoModel,ProdutoRepositoryImpl,ProdutoModel,sYSTEM.SysUtils,EtiquetaRepositoryImpl,uConexaoSyspdv,UIEtiqueta,System.Classes,System.Generics.collections,CodigoAuxiliarModel,CodigoAuxiliarRepositoryImpl,uConexaoSyspdvSQL,uIniManager,EtiquetaLayoutModel,EtiquetaPrinter,Vcl.ExtCtrls;
type TEtiquetaUseCase = class
  private
  FProdutoRepository:IProdutoRepository;
  FEtiquetaRepository:IEtiquetaRepository;
  FCodigoAuxiliarRepository:ICodigoAuxiliarRepository;
  FUIEtiqueta:IUIEtiqueta;
  FEtiquetaPrinter:IEtiquetaPrinter;
  procedure IniciarConfiguracao;
  public
  constructor create(EtiquetaRepository:IEtiquetaRepository;UIEtiqueta:IUIEtiqueta;EtiquetaPrinter:IEtiquetaPrinter);
  procedure AdicionarProduto(codigo:string;quantidade:integer);
  procedure CarregarProduto(codigo:string);
  procedure DeletarItem(id:string);
  procedure DeletarTodosItens;
  procedure AdicionarItensAlterados(dtInicio:TDate;dtFim:TDate;unidade:string);
  procedure SelecionarLayout(etiqueta:TEtiquetaLayoutModel);
  procedure Abrir;
  procedure ImprimirEtiqueta(codigoProduto:string;codigoLayout:string);
  procedure ImprimirFilaEtiqueta(codigoLayout:string);
  procedure EditarLayout(layout:TEtiquetaLayoutModel);
  procedure Preview(codigo:string; layout: TEtiquetaLayoutModel; ParentPanel: TPanel);
end;

implementation

{ TEtiquetaUseCase }

procedure TEtiquetaUseCase.Abrir;
var
  CodigoEtiquetaPadrao:string;
begin
CodigoEtiquetaPadrao := TIniManager.GetInstance('./preferencias.ini').ReadString('Etiqueta','Layout','');
FUIEtiqueta.AtualizarInterface(FEtiquetaRepository.ObterFilaImpressao);
FUIEtiqueta.Abrir(FEtiquetaRepository.carregarLayouts,CodigoEtiquetaPadrao);
end;

procedure TEtiquetaUseCase.AdicionarItensAlterados(dtInicio:TDate;dtFim:TDate;unidade:string);
var
  ProdutosAlterados:TObjectList<TProdutoModel>;
  Produto:TProdutoModel;
begin

  Self.IniciarConfiguracao;

  ProdutosAlterados := FProdutoRepository.getProdutosAlterados(dtInicio,dtFim,unidade);

  if ProdutosAlterados = nil then raise Exception.Create('Não Existem Produtos Alterados No período Selecionado');
  

  for Produto in ProdutosAlterados do
  begin
    FEtiquetaRepository.inserirItem(Produto);
  end;


  FUIEtiqueta.AtualizarInterface(FEtiquetaRepository.ObterFilaImpressao);
end;

procedure TEtiquetaUseCase.AdicionarProduto(codigo: string; quantidade:integer);
var
  Produto:TProdutoModel;
  CodigoAuxiliar:TCodigoAuxiliarModel;
  I: Integer;
begin
if quantidade > 999 then raise Exception.Create('Quantidade Máxima de 999 itens !');

Self.IniciarConfiguracao;

CodigoAuxiliar := FCodigoAuxiliarRepository.getByCodigoAuxiliar(codigo);

if CodigoAuxiliar <> nil then codigo := CodigoAuxiliar.Codigo_Barras;

Produto := FProdutoRepository.getByCodigoBarras(codigo);

if Produto = nil then raise Exception.Create('Produto Não Encontrado !');

if CodigoAuxiliar<> nil then Produto.SetCodigoBarras(codigoauxiliar.codigo_auxiliar);

for I := 1 to quantidade do
begin
FEtiquetaRepository.inserirItem(Produto);
end;

FUIEtiqueta.AtualizarInterface(FEtiquetaRepository.ObterFilaImpressao);

end;

procedure TEtiquetaUseCase.CarregarProduto(codigo: string);
var
  Produto:TProdutoModel;
  CodigoAuxiliar:TCodigoAuxiliarModel;
begin

Self.IniciarConfiguracao;

CodigoAuxiliar := FCodigoAuxiliarRepository.getByCodigoAuxiliar(codigo);

if CodigoAuxiliar <> nil then codigo := CodigoAuxiliar.codigo_barras;

Produto := FProdutoRepository.getByCodigoBarras(codigo);

if Produto = nil then raise Exception.Create('Produto Não Encontrado !');

FUIEtiqueta.CarregarProduto(Produto);
end;

constructor TEtiquetaUseCase.create(EtiquetaRepository:IEtiquetaRepository;UIEtiqueta:IUIEtiqueta;EtiquetaPrinter:IEtiquetaPrinter);
begin
FEtiquetaRepository := EtiquetaRepository;
FUIEtiqueta := UIEtiqueta;
FEtiquetaPrinter := EtiquetaPrinter;

Self.IniciarConfiguracao;
end;


procedure TEtiquetaUseCase.DeletarItem(id: string);
begin
if id = '' then exit;
FEtiquetaRepository.deletarItem(id);
FUIEtiqueta.AtualizarInterface(FEtiquetaRepository.ObterFilaImpressao);
end;

procedure TEtiquetaUseCase.DeletarTodosItens;
begin
FEtiquetaRepository.deletarTodosItens;
FUIEtiqueta.AtualizarInterface(FEtiquetaRepository.ObterFilaImpressao);
end;

procedure TEtiquetaUseCase.EditarLayout(
  layout: TEtiquetaLayoutModel);
begin
FEtiquetaPrinter.EditarLayout(layout);
end;

procedure TEtiquetaUseCase.ImprimirEtiqueta(codigoProduto,
  codigoLayout: string);
  var
    CodigoAuxiliar:TCodigoAuxiliarModel;
    Produto:TProdutoModel;
    Layout:TEtiquetaLayoutModel;
begin
Self.IniciarConfiguracao;

Layout :=FEtiquetaRepository.ObterLayout(codigoLayout);

if Layout = nil then raise Exception.Create('Layout Não Encontrado ! '+ codigoLayout);

CodigoAuxiliar := FCodigoAuxiliarRepository.getByCodigoAuxiliar(codigoProduto);

if CodigoAuxiliar <> nil then codigoProduto := CodigoAuxiliar.codigo_barras;

Produto := FProdutoRepository.getByCodigoBarras(codigoProduto);

if Produto = nil then raise Exception.Create('Produto Não Encontrado !');

FEtiquetaPrinter.Imprimir(Produto,layout);

end;

procedure TEtiquetaUseCase.ImprimirFilaEtiqueta(codigoLayout: string);
var
      Layout:TEtiquetaLayoutModel;
      produto:TProdutoModel;
begin
Layout :=FEtiquetaRepository.ObterLayout(codigoLayout);
if Layout = nil then raise Exception.Create('Layout Não Encontrado ! '+ codigoLayout);

FEtiquetaPrinter.ImprimirFila(FEtiquetaRepository.ObterFilaImpressao,layout);
end;

procedure TEtiquetaUseCase.IniciarConfiguracao;
begin
// rk
if FConfiguracaoRepositoryFirebird.Obter.etiqueta_modo_importacao = 0 then
begin
FProdutoRepository := TProdutoRepositoryFirebird.Create;
FCodigoAuxiliarRepository:= TCodigoAuxiliarRepositoryFirebird.Create;
end;
// syspdv - firebird

if FConfiguracaoRepositoryFirebird.Obter.etiqueta_modo_importacao = 1 then
begin
FProdutoRepository := TProdutoRepositorySyspdv.Create(TConexaoSyspdv.GetInstance(FConfiguracaoRepositoryFirebird.Obter.syspdv_ip));
FCodigoAuxiliarRepository:= TCodigoAuxiliarRepositorySyspdv.Create(TConexaoSyspdv.GetInstance(FConfiguracaoRepositoryFirebird.Obter.syspdv_ip));
end;

if FConfiguracaoRepositoryFirebird.Obter.etiqueta_modo_importacao = 2 then
begin
FProdutoRepository := TProdutoRepositorySyspdvSQL.Create(TConexaoSyspdvSQL.GetInstance(FConfiguracaoRepositoryFirebird.Obter.syspdv_ip));
FCodigoAuxiliarRepository:= TCodigoAuxiliarRepositorySyspdvSQL.Create(TConexaoSyspdvSQL.GetInstance(FConfiguracaoRepositoryFirebird.Obter.syspdv_ip));
end;
end;

procedure TEtiquetaUseCase.Preview(codigo:string;
  layout: TEtiquetaLayoutModel; ParentPanel: TPanel);
    var
    CodigoAuxiliar:TCodigoAuxiliarModel;
    Produto:TProdutoModel;
begin
IniciarConfiguracao;
CodigoAuxiliar := FCodigoAuxiliarRepository.getByCodigoAuxiliar(codigo);

if CodigoAuxiliar <> nil then codigo := CodigoAuxiliar.Codigo_Barras;

Produto := FProdutoRepository.getByCodigoBarras(codigo);

if Produto = nil then raise Exception.Create('Produto Não Encontrado !');

if CodigoAuxiliar<> nil then Produto.SetCodigoBarras(codigoauxiliar.codigo_auxiliar);

FEtiquetaPrinter.Preview(produto,layout,ParentPanel);
end;

procedure TEtiquetaUseCase.SelecionarLayout(etiqueta:TEtiquetaLayoutModel);
begin
TIniManager.GetInstance('./preferencias.ini').WriteString('Etiqueta','Layout',etiqueta.codigo);
end;

end.
