unit uSubGrupoController;

interface
uses
System.SysUtils,uDmSubgrupo,NxGrid,Classe.Subgrupo,Conversao;

type TSubGrupoController = class
  private
  public
  constructor create;
  destructor destroy;override;

    function CarregarSubGrupo(oSubGrupo : TSubgrupo): Boolean;
    function AlterarSubGrupo(oSubGrupo:TSubgrupo):Boolean;
    function InserirSubGrupo(oSubGrupo:TSubgrupo):Boolean;
    function ExcluirSubGrupo(oSubGrupo:TSubgrupo):Boolean;
    function PreencherGrid(sSubGrupo:string;Grid:TNextGrid;tipo:TPesquisar):Boolean;
    function RetornaSequencial(oSubGrupo:TSubGrupo):string;
end;

implementation
uses Classe.Variaveis;

function TSubGrupoController.AlterarSubGrupo(oSubGrupo: TSubGrupo): Boolean;
begin
result :=dmSubgrupo.AlterarSubGrupo(oSubGrupo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('SUBGRUPO','ALTEROU SUBGRUPO:'+oSubgrupo.codigo,tpalteracao);
end;

function TSubGrupoController.CarregarSubGrupo(oSubGrupo: TSubGrupo): Boolean;
begin
result := dmSubgrupo.CarregarSubGrupo(oSubGrupo);
end;

constructor TSubGrupoController.create;
begin
  dmSubgrupo := TdmSubgrupo.create(nil);
end;

destructor TSubGrupoController.destroy;
begin
  FreeAndNil(dmSubgrupo);
  inherited;
end;


function TSubGrupoController.ExcluirSubGrupo(oSubGrupo: TSubGrupo): Boolean;
begin
result := dmSubgrupo.ExcluirSubGrupo(oSubGrupo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('SUBGRUPO','EXCLUIU SUBGRUPO:'+oSubgrupo.codigo,tpExclusao);
end;

function TSubGrupoController.InserirSubGrupo(oSubGrupo: TSubGrupo): Boolean;
begin
result := dmSubgrupo.InserirSubGrupo(oSubGrupo);
VariaveisSrv.oAuditoriaController.InserirAuditoria('SUBGRUPO','INSERIU SUBGRUPO:'+oSubgrupo.codigo,tpInclusao);
end;

function TSubGrupoController.PreencherGrid(sSubGrupo: string; Grid: TNextGrid;
  tipo: TPesquisar): Boolean;
begin
result := dmSubgrupo.PreencherGrid(sSubGrupo,grid,tipo);
end;

function TSubGrupoController.RetornaSequencial(oSubGrupo: TSubGrupo): string;
begin
Result := dmSubgrupo.RetornaSequencial(oSubGrupo);
end;

end.
