unit uProdutoController;

interface
uses
System.SysUtils,uDmProduto,NxGrid,Classe.Produto,Conversao,Data.DB,Vcl.StdCtrls,Classe.Relatorio,uDmCodigoAuxiliar,Classe.CodigoAuxiliar,Produto;

type TProdutoController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function PreencherGrid(sProduto:string;ds:TDatasource;tipo:TPesquisar):Boolean;
  function InserirProduto(oProduto:Classe.Produto.TProduto):Boolean;
  function AlterarProduto(oProduto:Classe.Produto.TProduto):boolean;
  function CarregarProduto(oProduto:Classe.Produto.TProduto):boolean;overload;
  function CarregarProduto(oProduto:Classe.Produto.TProduto;iCodigoAuxiliar:string):boolean;overload;
  function ExcluirProduto(oProduto:Classe.Produto.TProduto):boolean;
  function VerificaCodigoBarras(oProduto:Classe.Produto.TProduto):Boolean;
  // balanca
  function ExportarProdutosBalanca(bal:TBalanca;lblProgresso:TLabel;memProgresso:TMemo;diretorio:string):Boolean;
  // etiqueta
    function InserirEtiqueta(oProduto:Produto.TProduto):boolean;
    function InserirEtiquetaAuxiliar(oProduto:Classe.Produto.TProduto):boolean;
    function PreencherGridEtiqueta(ds:TDataSource;imprimirLote:boolean):boolean;
    function PreencherGridAlterados(oRelatorio:TRelatorio):Boolean;
    function ImprimirEtiqueta(ds:TDatasource;layout:string):Boolean;

    function LimparGrid(ds:TDataSource):boolean;


end;

implementation
uses Classe.Variaveis;

function TProdutoController.AlterarProduto(oProduto: Classe.Produto.TProduto): boolean;
begin
result := dmProduto.AlterarProduto(oProduto);
VariaveisSrv.oUtilsController.InserirCarga('PRODUTO',oProduto.codigo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('PRODUTO','ALTEROU PRODUTO:'+oProduto.Codigo,tpAlteracao);
end;

function TProdutoController.CarregarProduto(oProduto: Classe.Produto.TProduto): boolean;
var
codigo:string;
begin
result := dmProduto.CarregarProduto(oProduto);
end;



function TProdutoController.CarregarProduto(oProduto: Classe.Produto.TProduto;
  iCodigoAuxiliar: string): boolean;
begin
result := false;
oProduto.CodigoAuxiliar := dmCodigoAuxiliar.ObterCodigoAuxiliar(iCodigoAuxiliar);
if oProduto.CodigoAuxiliar.codigo <> '' then
begin
Result := dmProduto.CarregarProduto(oProduto);
end;

end;

constructor TProdutoController.create;
begin

  dmProduto := TdmProduto.create(nil);
  dmCodigoAuxiliar := TdmCodigoAuxiliar.Create(nil);
end;




destructor TProdutoController.destroy;
begin
  FreeAndNil(dmProduto);
  FreeAndNil(dmCodigoAuxiliar);
  inherited;
end;


function TProdutoController.ExcluirProduto(oProduto: Classe.Produto.TProduto): boolean;
begin
result := dmProduto.ExcluirProduto(oProduto);
VariaveisSrv.oCargaPDVController.InsertFilaExcluir('PRODUTO',oProduto.Codigo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('PRODUTO','EXCLUIU PRODUTO:'+oProduto.Codigo,tpExclusao);
end;

function TProdutoController.ExportarProdutosBalanca(bal: TBalanca;
  lblProgresso: TLabel; memProgresso: TMemo;diretorio:string): Boolean;
begin
result :=dmProduto.ExportarProdutosBalanca(bal,lblprogresso,memProgresso,diretorio);
end;

function TProdutoController.ImprimirEtiqueta(ds: TDatasource;layout:string): Boolean;
begin
result := dmProduto.ImprimirEtiqueta(ds,layout);
end;

function TProdutoController.InserirEtiqueta(oProduto: Produto.TProduto): boolean;
begin
result := dmProduto.InserirEtiqueta(oProduto);
end;


function TProdutoController.InserirEtiquetaAuxiliar(oProduto: Classe.Produto.TProduto): boolean;
begin
result := dmProduto.InserirEtiquetaCodigoAuxiliar(oProduto);
end;

function TProdutoController.InserirProduto(oProduto: Classe.Produto.TProduto): Boolean;
begin
result := dmProduto.InserirProduto(oProduto);
VariaveisSrv.oUtilsController.InserirCarga('PRODUTO',oProduto.codigo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('PRODUTO','INSERIU PRODUTO:'+oProduto.Codigo,tpInclusao);
end;

function TProdutoController.LimparGrid(ds: TDataSource): boolean;
begin
dmProduto.limparGridEtiqueta(ds);
end;

function TProdutoController.PreencherGrid(sProduto:string;ds:TDatasource;tipo:TPesquisar): Boolean;
var
  codigo_auxiliar:TCodigoAuxiliar;
begin
codigo_auxiliar := dmCodigoAuxiliar.ObterCodigoAuxiliar(sProduto);
  if(codigo_auxiliar.codigo ='') then
  begin
    Result := dmProduto.PreencherGrid(sProduto,ds,tipo);
  end;

  if not(codigo_auxiliar.codigo ='') then
  begin
    Result := dmProduto.PreencherGrid(codigo_auxiliar.codigo_barras,ds,tipo);
  end;
end;

function TProdutoController.PreencherGridAlterados(oRelatorio: TRelatorio): Boolean;
begin
result := dmProduto.PreencherGridAlterados(oRelatorio);
end;

function TProdutoController.PreencherGridEtiqueta(ds: TDataSource;imprimirLote:boolean): boolean;
begin
Result := dmProduto.PreencherGridEtiqueta(ds,imprimirLote);
end;

function TProdutoController.VerificaCodigoBarras(oProduto: Classe.Produto.TProduto): Boolean;
begin
result := dmProduto.VerificaCodigoBarras(oProduto);
end;

end.
