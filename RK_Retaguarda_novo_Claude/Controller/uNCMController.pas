unit uNCMController;

interface
uses
System.SysUtils,uDmNCM,NxGrid,Classe.NCM,Conversao,Vcl.DBGrids;

type TNCMController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function PreencherGrid(sNCM:string;Grid:TDbGrid;tipo:TPesquisar):Boolean;
  function ValidarNCM(oNCM:TNcm):boolean;


end;

implementation

constructor TNCMController.create;
begin
  dmNCM := TDmNCM.create(nil);
end;

destructor TNCMController.destroy;
begin
  FreeAndNil(dmNCM);
  inherited;
end;

function TNCMController.PreencherGrid(sNCM: string; Grid: TDbGrid;
  tipo: TPesquisar): Boolean;
begin
result := dmNCM.PreencherGrid(sNCM,Grid,tipo);
end;

function TNCMController.ValidarNCM(oNCM: TNcm): boolean;
begin
result := dmNCM.ValidarNCM(oNCM);
end;

end.
