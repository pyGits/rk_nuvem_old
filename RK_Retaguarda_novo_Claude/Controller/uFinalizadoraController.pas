unit uFinalizadoraController;

interface
uses
System.SysUtils,uDmFinalizadora,NxGrid,Classe.Finalizadora,Conversao;

type TFinalizadoraController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function CarregarFinalizadora(oFinalizadora : TFinalizadora): Boolean;
  function AlterarFinalizadora(oFinalizadora:TFinalizadora):Boolean;
  function InserirFinalizadora(oFinalizadora:TFinalizadora):Boolean;
  function ExcluirFinalizadora(oFinalizadora:TFinalizadora):Boolean;
  function PreencherGrid(sFinalizadora:string;Grid:TNextGrid;tipo:TPesquisar):Boolean;


end;

implementation
uses classe.variaveis;

function TFinalizadoraController.AlterarFinalizadora(oFinalizadora: TFinalizadora): Boolean;
begin
result :=dmFinalizadora.AlterarFinalizadora(oFinalizadora);
VariaveisSrv.oUtilsController.InserirCarga('FINALIZADORA',oFinalizadora.Codigo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('FINALIZADORA','ALTEROU FINALIZADORA:'+oFinalizadora.Codigo,tpAlteracao);
end;

function TFinalizadoraController.CarregarFinalizadora(oFinalizadora: TFinalizadora): Boolean;
begin
result := dmFinalizadora.CarregarFinalizadora(oFinalizadora);
end;

constructor TFinalizadoraController.create;
begin
  dmFinalizadora := TDmFinalizadora.create(nil);
end;

destructor TFinalizadoraController.destroy;
begin
  FreeAndNil(dmFinalizadora);
  inherited;
end;


function TFinalizadoraController.ExcluirFinalizadora(oFinalizadora: TFinalizadora): Boolean;
begin
result := dmFinalizadora.ExcluirFinalizadora(oFinalizadora);
VariaveisSrv.oAuditoriaController.InserirAuditoria('FINALIZADORA','EXCLUIU FINALIZADORA:'+oFinalizadora.Codigo,tpExclusao);
end;

function TFinalizadoraController.InserirFinalizadora(oFinalizadora: TFinalizadora): Boolean;
begin
result := dmFinalizadora.InserirFinalizadora(oFinalizadora);
VariaveisSrv.oUtilsController.InserirCarga('FINALIZADORA',oFinalizadora.codigo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('FINALIZADORA','INSERIU FINALIZADORA:'+oFinalizadora.Codigo,tpInclusao);
end;

function TFinalizadoraController.PreencherGrid(sFinalizadora: string; Grid: TNextGrid;
  tipo: TPesquisar): Boolean;
begin
result := dmFinalizadora.PreencherGrid(sFinalizadora,Grid,tipo);
end;

end.
