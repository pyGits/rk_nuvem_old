unit uRelatorioController;

interface
uses
System.SysUtils,uDmRelCupom,NxGrid,Classe.Relatorio,Conversao,VCLTee.Chart,uDmRelProduto,uDmRelFinalizadora,uDmRelEstoque,uDmRelFuncionario;

type TRelatorioController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function RelatorioGraficoCupom(oRelatorio:TRelatorio;Grafico:TChart;GridValores:TNextGrid):Boolean;
  function RelatorioCupom(oRelatorio:TRelatorio):Boolean;
  function relatorioCurvaABC(oRelatorio:TRelatorio):Boolean;
  function RelatorioFinalizadora(oRelatorio:TRelatorio):Boolean;

  function RelatorioSaldoEstoque(oRelatorio:TRelatorio):boolean;
  function RelatorioExtratoEstoque(oRelatorio:TRelatorio):Boolean;

  function RelatorioComissaoFuncionario(oRelatorio:TRelatorio):boolean;

  function relatorioPerformanceProduto(oRelatorio:TRelatorio):Boolean;
  function RelatorioFechamentoCaixa(oRelatorio:TRelatorio):boolean;

  function relatorioProdutosCancelados(oRelatorio:TRelatorio):boolean;


  function relatorioListarProduto(oRelatorio:TRelatorio;diretorio:string):boolean;


end;

implementation

constructor TRelatorioController.create;
begin
  dmRelCupom := TdmRelCupom.create(nil);
  dmRelProduto := TdmRelProduto.Create(nil);
  dmRelFinalizadora := TdmRelFinalizadora.Create(nil);
end;

destructor TRelatorioController.destroy;
begin
  FreeAndNil(dmRelCupom);
  FreeAndNil(dmRelProduto);
  FreeAndNil(dmRelFinalizadora);
  inherited;
end;



function TRelatorioController.RelatorioComissaoFuncionario(
  oRelatorio: TRelatorio): boolean;
begin
result := dmRelFuncionario.RelatorioComissaoFuncionario(oRelatorio);
end;

function TRelatorioController.RelatorioCupom(oRelatorio: TRelatorio): Boolean;
begin
result := dmRelCupom.RelatorioCupom(oRelatorio);
end;

function TRelatorioController.relatorioCurvaABC(
  oRelatorio: TRelatorio): Boolean;
begin
Result :=dmRelProduto.relatorioCurvaABC(oRelatorio);
end;

function TRelatorioController.RelatorioExtratoEstoque(
  oRelatorio: TRelatorio): Boolean;
begin
result := dmRelEstoque.RelatorioExtratoEstoque(oRelatorio);
end;

function TRelatorioController.RelatorioFechamentoCaixa(
  oRelatorio: TRelatorio): boolean;
begin
result := dmRelCupom.RelatorioFechamentoCaixa(oRelatorio);
end;

function TRelatorioController.RelatorioFinalizadora(
  oRelatorio: TRelatorio): Boolean;
begin
Result := dmRelFinalizadora.RelatorioFinalizadora(oRelatorio);
end;

function TRelatorioController.RelatorioGraficoCupom(oRelatorio: TRelatorio;
  Grafico: TChart;GridValores:TNextGrid): Boolean;
begin
result := dmRelCupom.RelatorioGraficoCupom(oRelatorio,Grafico,GridValores);
end;

function TRelatorioController.relatorioListarProduto(
  oRelatorio: TRelatorio;diretorio:string): boolean;
begin
result := dmRelProduto.relatorioListarProduto(oRelatorio,diretorio);
end;

function TRelatorioController.relatorioPerformanceProduto(
  oRelatorio: TRelatorio): Boolean;
begin
result := dmRelProduto.relatorioPerformanceProduto(oRelatorio);
end;

function TRelatorioController.relatorioProdutosCancelados(
  oRelatorio: TRelatorio): boolean;
begin
result := dmRelProduto.relatorioProdutosCancelados(oRelatorio);
end;

function TRelatorioController.RelatorioSaldoEstoque(
  oRelatorio: TRelatorio): boolean;
begin
result := dmRelEstoque.RelatorioSaldoEstoque(oRelatorio);
end;

end.
