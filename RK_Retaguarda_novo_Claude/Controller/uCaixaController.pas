unit uCaixaController;

interface
uses
System.SysUtils,uDmCaixa,NxGrid,Classe.Caixa,Conversao,Data.DB;

type TCaixaController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function PreencherGrid(ds:TDataSource):Boolean;


end;

implementation



constructor TCaixaController.create;
begin
  dmCaixa := TdmCaixa.Create(nil);
end;

destructor TCaixaController.destroy;
begin
  FreeAndNil(dmCaixa);
  inherited;
end;


function TCaixaController.PreencherGrid(ds:TDataSource): Boolean;
begin
result := dmCaixa.PreencherGrid(ds);
end;

end.
