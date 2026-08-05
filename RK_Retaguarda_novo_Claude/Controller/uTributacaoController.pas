unit uTributacaoController;

interface

uses
System.SysUtils,uDmTributacao,NxGrid,Classe.Tributacao,Conversao,Vcl.StdCtrls;

type TTributacaoController = class
  private
  public
  constructor create;
  destructor destroy;override;
  function CarregarTributacao(oTributacao : TTributacao): Boolean;
  function AlterarTributacao(oTributacao:TTributacao):Boolean;
  function InserirTributacao(oTributacao:TTributacao):Boolean;
  function ExcluirTributacao(oTributacao:TTributacao):Boolean;
  function PreencherGrid(sTributacao:string;Grid:TNextGrid;tipo:TPesquisar):Boolean;
  function PreencherComboBox(cb:TComboBox):Boolean;


end;


implementation
uses Classe.Variaveis;


function TTributacaoController.AlterarTributacao(oTributacao: TTributacao): Boolean;
begin
result :=dmTributacao.AlterarTributacao(oTributacao);
VariaveisSrv.oAuditoriaController.InserirAuditoria('TRIBUTACAO','ALTEROU TRIBUTACAO:'+oTributacao.codigo,tpalteracao);
end;

function TTributacaoController.CarregarTributacao(oTributacao: TTributacao): Boolean;
begin
result := dmTributacao.CarregarTributacao(oTributacao);
end;

constructor TTributacaoController.create;
begin
  dmTributacao := TDmTributacao.create(nil);
end;

destructor TTributacaoController.destroy;
begin
  FreeAndNil(dmTributacao);
  inherited;
end;


function TTributacaoController.ExcluirTributacao(oTributacao: TTributacao): Boolean;
begin
result := dmTributacao.ExcluirTributacao(oTributacao);
VariaveisSrv.oAuditoriaController.InserirAuditoria('TRIBUTACAO','EXCLUIU TRIBUTACAO:'+oTributacao.codigo,tpExclusao);
end;

function TTributacaoController.InserirTributacao(oTributacao: TTributacao): Boolean;
begin
result := dmTributacao.InserirTributacao(oTributacao);
VariaveisSrv.oAuditoriaController.InserirAuditoria('TRIBUTACAO','INSERIU TRIBUTACAO:'+oTributacao.codigo,tpInclusao);
end;

function TTributacaoController.PreencherComboBox(cb: TComboBox): Boolean;
begin
result := dmTributacao.PreencherComboBox(cb);
end;

function TTributacaoController.PreencherGrid(sTributacao: string; Grid: TNextGrid;
  tipo: TPesquisar): Boolean;
begin
result := dmTributacao.PreencherGrid(sTributacao,Grid,tipo);
end;

end.
