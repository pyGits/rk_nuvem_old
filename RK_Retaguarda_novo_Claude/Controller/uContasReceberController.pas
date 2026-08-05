unit uContasReceberController;

interface
uses
System.SysUtils,uDmContasReceber,NxGrid,Conversao,Data.DB,System.Generics.Collections,ContasReceber,ContasReceberList,uDmContasReceberPagamento;

type TContasReceberController = class
  private
  public
  constructor create;
  destructor destroy;override;
function PreencherGrid(
  ds: TDataSource;
  status: TContasReceberStatus;
  codigoCliente: string;
  out AVlr, AVlrPago, AVlrAPagar, AVlrDesconto: Extended
): Boolean;
  function preencherGridProduto(ds:TDataSource;venda:string):boolean;
  function preencherGridPagamento(ds:TDataSource;venda:string):boolean;
  function CarregarValorTotalAReceber:Real;
  function LancarPagamento(vlrPagamento:Real;vlrDesconto:real;vlrAcrescimo:Real;Forma:string):Boolean;
  function EstornarContas:boolean;
  function ExcluirContas:Boolean;


end;

implementation
uses Classe.Variaveis;


function TContasReceberController.CarregarValorTotalAReceber: Real;
begin
result := dmContasReceber.CarregarValorTotalAReceber;
end;

constructor TContasReceberController.create;
begin
  dmContasReceber := TDmContasReceber.create(nil);
  dmContasReceberPagamento := TDmContasReceberPagamento.create(nil);
end;

destructor TContasReceberController.destroy;
begin
  FreeAndNil(dmContasReceber);
  inherited;
end;

function TContasReceberController.EstornarContas: boolean;
begin

result := dmContasReceber.EstornarContas;
end;

function TContasReceberController.ExcluirContas: Boolean;
begin
result := dmContasReceber.ExcluirContas;
end;

function TContasReceberController.LancarPagamento(vlrPagamento: Real;vlrDesconto:Real;vlrAcrescimo:Real;
  Forma: string): Boolean;
  var
  contas_receber_list:TContasReceberList;
begin
  contas_receber_list := dmContasReceber.CarregarContasSelecionadas;
  contas_receber_list.lancarPagamento(vlrPagamento,vlrDesconto,vlrAcrescimo,forma);

  dmContasReceber.AtualizarPagamento(contas_receber_list);
  dmContasReceberPagamento.insertContasReceberPagamento(contas_receber_list,Forma);
end;

//function TContasReceberController.PreencherGrid(ds:TDataSource;status:TContasReceberStatus;codigoCliente:string): Boolean;
function TContasReceberController.PreencherGrid(
  ds: TDataSource;
  status: TContasReceberStatus;
  codigoCliente: string;
  out AVlr, AVlrPago, AVlrAPagar, AVlrDesconto: Extended
): Boolean;
begin
result := dmContasReceber.PreencherGrid(ds,status,codigoCliente,  AVlr, AVlrPago, AVlrAPagar, AVlrDesconto);
end;

function TContasReceberController.preencherGridPagamento(ds: TDataSource;
  venda: string): boolean;
begin
result := dmContasReceber.preencherGridPagamento(ds,venda);
end;

function TContasReceberController.preencherGridProduto(ds: TDataSource;
  venda: string): boolean;
begin
result := dmContasReceber.preencherGridProduto(ds,venda);
end;



end.
