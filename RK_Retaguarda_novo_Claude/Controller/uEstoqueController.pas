unit uEstoqueController;
interface
uses uDmEstoque,system.SysUtils;
type
  TEstoqueController = class
  private
  public
  constructor create;
  destructor destroy;override;
   function atualizarSaldo(qtdAnterior,qtdAtual:Real;codProduto:string):Boolean;

end;

implementation

{ TEstoqueController }

function TEstoqueController.atualizarSaldo(qtdAnterior, qtdAtual: Real;
  codProduto: string): Boolean;
begin
result := dmEstoque.atualizarSaldo(qtdAnterior,qtdAtual,codProduto);
end;

constructor TEstoqueController.create;
begin
  dmEstoque := TdmEstoque.create(nil);

  inherited;
end;

destructor TEstoqueController.destroy;
begin
  FreeAndNil(dmEstoque);
  inherited;
end;

end.
