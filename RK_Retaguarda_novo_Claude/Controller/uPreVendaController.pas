unit uPreVendaController;

interface
uses
System.SysUtils,uDmPreVenda,NxGrid,Classe.PreVenda,Conversao,Data.DB,Classe.Impressao.Prevenda,uDmCliente,Classe.Cliente,System.Classes;

type TPreVendaController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function InserirPrevenda(oPrevenda:TPrevenda):Boolean;
  function InserirPreVendaItemTemp(oPreVendaItem:TPrevendaItem):boolean;


  function CarregarItensPreVenda(ds:TDataSource):Boolean;
  function DeletarPreVendaItemTemp:boolean;
  function CarregarPreVendaTela(oPreVenda:TPrevenda):Boolean;
  function DeletarPreVenda(oPrevenda:TPrevenda):boolean;
  function CarregarGridPreVenda(dtInicio,dtFim:TDate;ds:TDatasource):boolean;

  function Imprimir_Cupom_Completo(nPrevenda:string;nTerminal:string):TStringList;

  function Carregar(codigo:string;nTerminal:string):TPrevenda;



end;

implementation
uses Classe.Variaveis;

function TPreVendaController.Carregar(codigo: string;nTerminal:string): TPrevenda;
begin
result := TPrevenda.create;
Result.codigo := codigo;
result.terminal := nTerminal;
dmPreVenda.CarregarPreVenda(result);
end;

function TPreVendaController.CarregarGridPreVenda(dtInicio, dtFim: TDate;
  ds: TDatasource): boolean;
begin
result := dmPreVenda.CarregarGridPreVenda(dtInicio,dtFim,ds);
end;

function TPreVendaController.CarregarItensPreVenda(ds: TDataSource): Boolean;
begin
result := dmPreVenda.CarregarItensPreVenda(ds);
end;

function TPreVendaController.CarregarPreVendaTela(
  oPreVenda: TPrevenda): Boolean;
begin
result := dmPreVenda.CarregarPreVendaTela(oPreVenda);
end;

constructor TPreVendaController.create;
begin
  dmPreVenda := TDmPreVenda.create(nil);
  dmCliente := TdmCliente.Create(nil);
end;

function TPreVendaController.DeletarPreVenda(oPrevenda: TPrevenda): boolean;
begin
result := dmPreVenda.DeletarPreVenda(oPrevenda);
end;

function TPreVendaController.DeletarPreVendaItemTemp: boolean;
begin
result := dmPreVenda.DeletarPreVendaItemTemp;
end;

destructor TPreVendaController.destroy;
begin
  FreeAndNil(dmPreVenda);
  inherited;
end;

function TPreVendaController.Imprimir_Cupom_Completo(
  nPrevenda: string;nTerminal:string): TStringList;
var
  Cupom:TImpressaoPreVenda;
  Prevenda:TPrevenda;
  Cliente:TCliente;
begin
Cupom:=TImpressaoPreVenda.Create;
Prevenda := TPrevenda.create;
Cliente := TCliente.create;

prevenda.codigo := nPrevenda;
prevenda.terminal := nTerminal;
dmPreVenda.CarregarPreVenda(prevenda);

Cliente.codigo := prevenda.cliente;
dmCliente.CarregarCliente(Cliente);


result := cupom.imprimir_cupom_completo(VariaveisSrv.oProprio,Cliente,Prevenda);
end;

function TPreVendaController.InserirPrevenda(oPrevenda: TPrevenda): Boolean;
begin
result := dmPreVenda.InserirPrevenda(oPrevenda);
end;

function TPreVendaController.InserirPreVendaItemTemp(
  oPreVendaItem: TPrevendaItem): boolean;
begin
result := dmPreVenda.InserirPreVendaItemTemp(oPreVendaItem);
end;

end.
