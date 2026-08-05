unit uCESTController;

interface
uses
System.SysUtils,uDmCEST,NxGrid,Classe.CEST,Conversao,Vcl.DBGrids,data.db;

type TCESTController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function PreencherGrid(sNCM:string;ds:TDatasource;tipo:TPesquisar):Boolean;
  function ValidaCEST(oCest:TCest):Boolean;


end;

implementation

constructor TCESTController.create;
begin
  dmCEST := TDmCEST.create(nil);
end;

destructor TCESTController.destroy;
begin
  FreeAndNil(dmCEST);
  inherited;
end;

function TCESTController.PreencherGrid(sNCM: string; ds:TDatasource ;
  tipo: TPesquisar): Boolean;
begin
result := dmCEST.PreencherGrid(sNCM,ds,tipo);
end;

function TCESTController.ValidaCEST(oCest: TCest): Boolean;
begin
result := dmCEST.ValidaCEST(oCest);
end;

end.
