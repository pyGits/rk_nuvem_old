unit uFuncionarioController;

interface
uses
System.SysUtils,uDmFuncionario,NxGrid,Classe.Funcionario,Conversao,Data.DB;

type TFuncionarioController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function CarregarFuncionario(oFuncionario : TFuncionario): Boolean;
  function AlterarFuncionario(oFuncionario:TFuncionario):Boolean;
  function InserirFuncionario(oFuncionario:TFuncionario):Boolean;
  function ExcluirFuncionario(oFuncionario:TFuncionario):Boolean;
  function PreencherGrid(sFuncionario:string;ds:TDataSource;tipo:TPesquisar):Boolean;



end;

implementation
uses Classe.Variaveis;

function TFuncionarioController.AlterarFuncionario(oFuncionario: TFuncionario): Boolean;
begin
result :=dmFuncionario.AlterarFuncionario(oFuncionario);
VariaveisSrv.oUtilsController.InserirCarga('FUNCIONARIO',oFuncionario.codigo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('FUNCIONARIO','ALTEROU FUNCIONARIO:'+oFuncionario.Codigo,tpAlteracao);
end;

function TFuncionarioController.CarregarFuncionario(oFuncionario: TFuncionario): Boolean;
begin
result := dmFuncionario.CarregarFuncionario(oFuncionario);
end;

constructor TFuncionarioController.create;
begin
  dmFuncionario := TDmFuncionario.create(nil);
end;

destructor TFuncionarioController.destroy;
begin
  FreeAndNil(dmFuncionario);
  inherited;
end;


function TFuncionarioController.ExcluirFuncionario(oFuncionario: TFuncionario): Boolean;
begin
result := dmFuncionario.ExcluirFuncionario(oFuncionario);
VariaveisSrv.oAuditoriaController.InserirAuditoria('FUNCIONARIO','EXCLUIU FUNCIONARIO:'+oFuncionario.Codigo,tpExclusao);
end;

function TFuncionarioController.InserirFuncionario(oFuncionario: TFuncionario): Boolean;
begin
result := dmFuncionario.InserirFuncionario(oFuncionario);
VariaveisSrv.oUtilsController.InserirCarga('FUNCIONARIO',oFuncionario.codigo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('FUNCIONARIO','INSERIU FUNCIONARIO:'+oFuncionario.Codigo,tpInclusao);
end;


function TFuncionarioController.PreencherGrid(sFuncionario: string;
  ds: TDataSource; tipo: TPesquisar): Boolean;
begin
result := dmFuncionario.PreencherGrid(sFuncionario,ds,tipo);
end;

end.
