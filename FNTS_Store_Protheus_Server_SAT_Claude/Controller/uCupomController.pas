unit uCupomController;

interface

uses uDmCupom,Classe.Produto,System.sysutils,NxGrid,Vcl.StdCtrls,uDmStorage,vcl.forms,System.classes;

type TCupomController = class
  private
  public
    function VerificaPendenciaSubir:Boolean;
    function SincronizarVendaServidor(memoLog:TMemo):Boolean;
    function SincronizarVendasAntigas(dtInicio:TDate;dtFim:TDate):Boolean;
    function SincronizarVendasBackup:boolean;
  constructor create;
  destructor destroy;
end;

implementation

{ TProdutoController }

constructor TCupomController.create;
begin
  dmCupom := TdmCupom.create(nil);
  dmStorage := TdmStorage.Create(nil);
end;

destructor TCupomController.destroy;
begin
  freeandnil(dmCupom);
  inherited;
end;

function TCupomController.SincronizarVendasAntigas(dtInicio,
  dtFim: TDate): Boolean;
begin
Result := dmCupom.SincronizarVendasAntigas(dtInicio,dtFim);
end;

function TCupomController.SincronizarVendasBackup: boolean;
var
  backups:TStringList;
begin
backups := dmStorage.getRestoreScript;
dmCupom.bulkInsert(backups);
end;

function TCupomController.SincronizarVendaServidor(memoLog:TMemo): Boolean;
begin
//dmCupom := TdmCupom.create(nil);
result := dmCupom.SincronizarVendaServidor(memoLog);
//freeandnil(dmCupom);
end;

function TCupomController.VerificaPendenciaSubir: Boolean;
begin
result := dmCupom.VerificaPendenciaSubir;
end;

end.
