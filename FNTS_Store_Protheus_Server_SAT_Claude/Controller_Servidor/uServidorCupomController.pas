unit uServidorCupomController;

interface

uses uDmCupomServidor,System.sysutils,Classe.Cupom,Classe.NaoFiscal,Classe.Movimentacao,Classe.fechamento,Classe.NFCePendente;

type TServidorCupomController = class
  private
  public
    function InserirCupomServidor(oCupom:TCupom):Boolean;
    function InserirCupomItemServidor(oCupomItem:TCupomItem):Boolean;
    function InserirCupomFormaServidor(oCupomForma:TCupomForma):Boolean;
    function InserirEstoqueMovimentacao(oMovimentacao:TMovimentacao):Boolean;
    function InserirFechamento(oFechamento:TFechamento):Boolean;
    function InserirFechamentoFin(oFechamentoFin:TFechamentoFin):Boolean;
    function InserirNFCePendente(oNFCePendente:TNFcePendente):Boolean;

    function InserirNaoFiscalServidor(oNaoFiscal:TNaoFiscal):boolean;
    function AtualizarPreVendaServidor(cupom,terminal,prevenda:string):boolean;
  constructor create;
  destructor destroy;

end;

implementation

{ TServidorPreVendaController }

function TServidorCupomController.AtualizarPreVendaServidor(cupom, terminal,
  prevenda: string): boolean;
begin
result := dmCupomServidor.AtualizarPreVendaServidor(cupom,terminal,prevenda);
end;

constructor TServidorCupomController.create;
begin
  dmCupomServidor := TdmCupomServidor.create(nil);
end;

destructor TServidorCupomController.destroy;
begin
  freeandnil(dmCupomServidor);
  inherited;
end;

function TServidorCupomController.InserirCupomFormaServidor(
  oCupomForma: TCupomForma): Boolean;
begin
result := dmCupomServidor.InserirCupomFormaServidor(oCupomForma);
end;

function TServidorCupomController.InserirCupomItemServidor(
  oCupomItem: TCupomItem): Boolean;
begin
result := dmCupomServidor.InserirCupomItemServidor(oCupomItem);
end;

function TServidorCupomController.InserirCupomServidor(
  oCupom: TCupom): Boolean;
begin
result := dmCupomServidor.InserirCupomServidor(oCupom);
end;

function TServidorCupomController.InserirEstoqueMovimentacao(
  oMovimentacao: TMovimentacao): Boolean;
begin
result := dmCupomServidor.InserirEstoqueMovimentacao(oMovimentacao)
end;

function TServidorCupomController.InserirFechamento(
  oFechamento: TFechamento): Boolean;
begin
result := dmCupomServidor.InserirFechamentoServidor(oFechamento);
end;

function TServidorCupomController.InserirFechamentoFin(
  oFechamentoFin: TFechamentoFin): Boolean;
begin
result := dmCupomServidor.InserirFechamentoFinServidor(oFechamentoFin);
end;

function TServidorCupomController.InserirNaoFiscalServidor(
  oNaoFiscal: TNaoFiscal): boolean;
begin
result := dmCupomServidor.InserirNaoFiscalServidor(oNaoFiscal);
end;

function TServidorCupomController.InserirNFCePendente(
  oNFCePendente: TNFcePendente): Boolean;
begin
Result := dmCupomServidor.InserirNFCePendente(oNFCePendente);
end;

end.
