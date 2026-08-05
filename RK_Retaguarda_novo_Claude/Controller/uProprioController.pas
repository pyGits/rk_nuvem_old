unit uProprioController;

interface
uses
System.SysUtils,uDmProprio,NxGrid,Classe.Proprio,Conversao;

type TProprioController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function CarregarProprio(oProprio : TProprio): Boolean;
  function AlterarProprio(oProprio:TProprio):Boolean;

end;

implementation
uses Classe.Variaveis;

function TProprioController.AlterarProprio(oProprio: TProprio): Boolean;
begin
result :=dmProprio.AlterarProprio(oProprio);
VariaveisSrv.oAuditoriaController.InserirAuditoria('PROPRIO','ALTEROU PROPRIO:'+oProprio.Pessoa.CPFCNPJ,tpalteracao);
end;

function TProprioController.CarregarProprio(oProprio: TProprio): Boolean;
begin
result := dmProprio.CarregarProprio(oProprio);
end;

constructor TProprioController.create;
begin
  dmProprio := TDmProprio.create(nil);
end;

destructor TProprioController.destroy;
begin
  FreeAndNil(dmProprio);
  inherited;
end;


end.
