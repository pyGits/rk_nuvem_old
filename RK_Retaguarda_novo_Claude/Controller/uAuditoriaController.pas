unit uAuditoriaController;

interface
uses
System.SysUtils,uDmAuditoria,NxGrid,Conversao,Data.DB;

type TAuditoriaController = class
  private
  public
  function InserirAuditoria(tabela:string;alteracao:string;tpAuditoria:TAuditoria):boolean;
    function PreencherGrid(ds:TDataSource;dtInicial,dtFinal:TDateTime;tipo:TAuditoria):Boolean;
  constructor create;
  destructor destroy;override;

end;

implementation

constructor TAuditoriaController.create;
begin
  dmAuditoria := TDmAuditoria.create(nil);
end;

destructor TAuditoriaController.destroy;
begin
  FreeAndNil(dmAuditoria);
  inherited;
end;


function TAuditoriaController.InserirAuditoria(tabela,
  alteracao: string;tpAuditoria:TAuditoria): boolean;
begin
Result := dmAuditoria.InserirAuditoria(tabela,alteracao,tpAuditoria);
end;


function TAuditoriaController.PreencherGrid(ds: TDataSource; dtInicial,
  dtFinal: TDateTime;tipo:TAuditoria): Boolean;
begin
Result := dmAuditoria.PreencherGrid(ds,dtInicial,dtFinal,tipo);
end;

end.
