unit uClienteController;

interface
uses
System.SysUtils,uDmCliente,NxGrid,Classe.Cliente,Conversao,Data.DB;

type TClienteController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function CarregarCliente(oCliente : TCliente): Boolean;
  function AlterarCliente(oCliente:TCliente):Boolean;
  function InserirCliente(oCliente:TCliente):Boolean;
  function ExcluirCliente(oCliente:TCliente):Boolean;
  function PreencherGrid(sCliente:string;ds:TDataSource;tipo:TPesquisar):Boolean;

    function VerificaCliente(oCliente:TCliente):Boolean;



end;

implementation
uses Classe.Variaveis;

function TClienteController.AlterarCliente(oCliente: TCliente): Boolean;
begin
result :=dmCliente.AlterarCliente(oCliente);
VariaveisSrv.oUtilsController.InserirCarga('CLIENTE',oCliente.codigo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('CLIENTE','ALTEROU CLIENTE:'+oCliente.Codigo,tpAlteracao);
end;

function TClienteController.CarregarCliente(oCliente: TCliente): Boolean;
begin
result := dmCliente.CarregarCliente(oCliente);
end;

constructor TClienteController.create;
begin
  dmCliente := TDmCliente.create(nil);
end;

destructor TClienteController.destroy;
begin
  FreeAndNil(dmCliente);
  inherited;
end;


function TClienteController.ExcluirCliente(oCliente: TCliente): Boolean;
begin
result := dmCliente.ExcluirCliente(oCliente);
VariaveisSrv.oAuditoriaController.InserirAuditoria('CLIENTE','EXCLUIU CLIENTE:'+oCliente.Codigo,tpExclusao);
end;

function TClienteController.InserirCliente(oCliente: TCliente): Boolean;
begin
result := dmCliente.InserirCliente(oCliente);
VariaveisSrv.oUtilsController.InserirCarga('CLIENTE',oCliente.codigo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('CLIENTE','INSERIU CLIENTE:'+oCliente.Codigo,tpInclusao);
end;


function TClienteController.PreencherGrid(sCliente: string;
  ds: TDataSource; tipo: TPesquisar): Boolean;
begin
result := dmCliente.PreencherGrid(sCliente,ds,tipo);
end;

function TClienteController.VerificaCliente(oCliente: TCliente): Boolean;
begin
result :=dmCliente.VerificaCliente(oCliente);
end;

end.
