unit uFornecedorController;

interface
uses
System.SysUtils,uDmFornecedor,NxGrid,Classe.Fornecedor,Conversao,Data.DB;

type TFornecedorController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function CarregarFornecedor(oFornecedor : TFornecedor): Boolean;
  function AlterarFornecedor(oFornecedor:TFornecedor):Boolean;
  function InserirFornecedor(oFornecedor:TFornecedor):Boolean;
  function ExcluirFornecedor(oFornecedor:TFornecedor):Boolean;
  function PreencherGrid(sFornecedor:string;ds:TDataSource;tipo:TPesquisar):Boolean;
  function VerificaFornecedor(oFornecedor:TFornecedor):Boolean;



end;

implementation
uses Classe.Variaveis;

function TFornecedorController.AlterarFornecedor(oFornecedor: TFornecedor): Boolean;
begin
result :=dmFornecedor.AlterarFornecedor(oFornecedor);
VariaveisSrv.oAuditoriaController.InserirAuditoria('FORNECEDOR','ALTEROU FORNECEDOR:'+oFORNECEDOR.Codigo,tpAlteracao);
end;

function TFornecedorController.CarregarFornecedor(oFornecedor: TFornecedor): Boolean;
begin
result := dmFornecedor.CarregarFornecedor(oFornecedor);
end;

constructor TFornecedorController.create;
begin
  dmFornecedor := TDmFornecedor.create(nil);
end;

destructor TFornecedorController.destroy;
begin
  FreeAndNil(dmFornecedor);
  inherited;
end;


function TFornecedorController.ExcluirFornecedor(oFornecedor: TFornecedor): Boolean;
begin
result := dmFornecedor.ExcluirFornecedor(oFornecedor);
variaveisSrv.oAuditoriaController.InserirAuditoria('FORNECEDOR','EXCLUIU FORNECEDOR:'+oFORNECEDOR.Codigo,tpExclusao);
end;

function TFornecedorController.InserirFornecedor(oFornecedor: TFornecedor): Boolean;
begin
result := dmFornecedor.InserirFornecedor(oFornecedor);
VariaveisSrv.oAuditoriaController.InserirAuditoria('FORNECEDOR','INSERIU FORNECEDOR:'+oFORNECEDOR.Codigo,tpInclusao);
end;


function TFornecedorController.PreencherGrid(sFornecedor: string;
  ds: TDataSource; tipo: TPesquisar): Boolean;
begin
result := dmFornecedor.PreencherGrid(sFornecedor,ds,tipo);
end;

function TFornecedorController.VerificaFornecedor(
  oFornecedor: TFornecedor): Boolean;
begin
result := dmFornecedor.VerificaFornecedor(oFornecedor);
end;

end.
