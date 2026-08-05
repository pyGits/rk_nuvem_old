unit uCargaController;

interface
uses
System.SysUtils,uDmCargaPDV,NxGrid,Conversao,Classe.Caixa,Vcl.Dialogs,Vcl.StdCtrls,Vcl.ComCtrls,ProdutoRepositoryImpl,System.Generics.Collections,ProdutoModel,
TerminalService;

type TCargaController = class
  private
  public
  FProdutoRepository:IProdutoRepository;
  FTerminalService:ITerminalService;

  constructor create;
  destructor destroy;override;
  function EnviarCargaPDV(tipo:TCarga;oCaixa:TCaixa;lblProgresso:TLabel;pb:TProgressBar):boolean;
  procedure AtualizarRecebimento(concluido:string;oCaixa:TCaixa);
  function InsertFilaExcluir(tabela:string; codigo:string):Boolean;
  procedure ZerarCargaAlterados;

end;

implementation
uses Classe.Variaveis;

procedure TCargaController.AtualizarRecebimento(concluido: string;
  oCaixa: TCaixa);
begin
dmCargaPDV.AtualizarRecebimento(concluido,oCaixa);
end;

constructor TCargaController.create;
begin
  dmCargaPDV := TDmCargaPDV.create(nil);
  FProdutoRepository := TProdutoRepositoryFirebird.create;
  FTerminalService := TterminalService.create('c:\system_rk\terminal.txt');
end;

destructor TCargaController.destroy;
begin
  FreeAndNil(dmCargaPDV);
  inherited;
end;


function TCargaController.EnviarCargaPDV(tipo: TCarga; oCaixa: TCaixa;lblProgresso:TLabel;pb:TProgressBar): boolean;
var
  produtos:TObjectList<TProdutoModel>;
begin
result := dmCargaPDV.EnviarCargaPDV(tipo,oCaixa,lblProgresso,pb);

if dmCargaPDV.EnviarExclusaoPDV then
begin
  dmCargaPDV.ZerarExclusaoPDV;
end;





end;

function TCargaController.InsertFilaExcluir(tabela, codigo: string): Boolean;
begin
result := dmCargaPDV.InsertFilaExcluir(tabela,codigo);
end;

procedure TCargaController.ZerarCargaAlterados;
begin
dmCargaPDV.ZerarCargaAlterados;
end;

end.
