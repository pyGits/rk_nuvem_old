unit uGrupoController;

interface
uses
System.SysUtils,uDmGrupo,NxGrid,Classe.Grupo,Conversao;

type TGrupoController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function CarregarGrupo(oGrupo : TGrupo): Boolean;
  function AlterarGrupo(oGrupo:TGrupo):Boolean;
  function InserirGrupo(oGrupo:TGrupo):Boolean;
  function ExcluirGrupo(oGrupo:TGrupo):Boolean;
  function PreencherGrid(sGrupo:string;Grid:TNextGrid;tipo:TPesquisar):Boolean;


end;

implementation
uses Classe.Variaveis;

function TGrupoController.AlterarGrupo(oGrupo: TGrupo): Boolean;
begin
result :=dmGrupo.AlterarGrupo(oGrupo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('GRUPO','ALTEROU GRUPO:'+oGrupo.Codigo,tpAlteracao);
end;

function TGrupoController.CarregarGrupo(oGrupo: TGrupo): Boolean;
begin
result := dmGrupo.CarregarGrupo(oGrupo);
end;

constructor TGrupoController.create;
begin
  dmGrupo := TDmGrupo.create(nil);
end;

destructor TGrupoController.destroy;
begin
  FreeAndNil(dmGrupo);
  inherited;
end;


function TGrupoController.ExcluirGrupo(oGrupo: TGrupo): Boolean;
begin
result := dmGrupo.ExcluirGrupo(oGrupo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('GRUPO','EXCLUIU GRUPO:'+oGrupo.Codigo,tpExclusao);
end;

function TGrupoController.InserirGrupo(oGrupo: TGrupo): Boolean;
begin
result := dmGrupo.InserirGrupo(oGrupo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('GRUPO','INSERIU GRUPO:'+oGrupo.Codigo,tpInclusao);
end;

function TGrupoController.PreencherGrid(sGrupo: string; Grid: TNextGrid;
  tipo: TPesquisar): Boolean;
begin
result := dmGrupo.PreencherGrid(sGrupo,Grid,tipo);
end;

end.
