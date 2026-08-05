unit ImportarController;

interface
uses Produto,system.Generics.collections,Syspdv.Produto.Repository,RK.Produto.Repository,CodigoAuxiliar,Syspdv.CodigoAuxiliar.Repository,RK.CodigoAuxiliar.Repository,MapeamentoProduto,RK.ProdutoMapeamento.Repository,System.sysutils, VCL.stdctrls
,vcl.forms,ProdutoList,ProdutoPDVRepository,ProdutoRepository;
type TImportarController = class
public
  procedure ImportarSyspdv(memLog:TMemo);
  procedure ImportarSyspdvSQL(memLog:TMemo);
  procedure ImportarRKPdv;
end;


var
  Importar_Controller:TImportarController;
implementation

{ TImportarController }

procedure TImportarController.ImportarRKPdv;
var
  produtos:TProdutoList;
begin
if not FileExists('C:\SYSTEM_RK\SAT_DATPDV.FDB') then raise Exception.Create('Arquivo não encontrado !: ' + 'C:\SYSTEM_RK\SAT_DATPDV.FDB');
produtos := ProdutoPDV_Repository.CarregarTodosProdutos;
Produto_Repository.InserirListaProdutos(produtos);
end;

procedure TImportarController.ImportarSyspdv(memLog:TMemo);
var
  produtos:TObjectList<TProduto>;
  produtos_sem_mapeamento :TObjectList<TProduto>;
  codigos:TObjectList<TCodigoAuxiliar>;
  mapeamentos :TObjectList<TMapeamentoProduto>;
  mapeamentos_restante :TObjectList<TMapeamentoProduto>;
  ultimo_codigo:integer;
begin
try
  memLog.Lines.Clear;
  codigos := SYSPDV_CODIGO_AUXILIAR_REPO.getAll;
  mapeamentos := RK_PRODUTO_MAPEAMENTO_REPO.getAll;
  ultimo_codigo := RK_PRODUTO_MAPEAMENTO_REPO.getLastSequencial;
  produtos := SYSPDV_PRODUTO_REPO.getAll;


  TMapeamentoProdutoList.PreencherCodigoProduto(produtos,mapeamentos,ultimo_codigo);
  RK_PRODUTO_MAPEAMENTO_REPO.bulkInsert(mapeamentos);
  RK_PRODUTO_REPO.deleteAll;
  RK_PRODUTO_REPO.bulkInsert(produtos);
  Application.ProcessMessages;
  memLog.Lines.Add('PRODUTOS IMPORTADOS: '+ IntToStr(produtos.count));

  TMapeamentoProdutoList.PreencherCodigoProdutoAuxiliar(codigos,mapeamentos);
  RK_CODIGO_AUXILIAR_REPO.deleteAll;
  RK_CODIGO_AUXILIAR_REPO.bulkInsert(codigos);

  Application.ProcessMessages;
  memLog.Lines.Add('CODIGOS IMPORTADOS: '+ IntToStr(codigos.count));
  memLog.Lines.Add('');
  memLog.Lines.Add('IMPORTAÇÃO FINALIZADA');




finally
    produtos.Free;
  codigos.Free;
  mapeamentos.Free;

end;


end;
procedure TImportarController.ImportarSyspdvSQL(memLog: TMemo);
var
  produtos:TObjectList<TProduto>;
  produtos_sem_mapeamento :TObjectList<TProduto>;
  codigos:TObjectList<TCodigoAuxiliar>;
  mapeamentos :TObjectList<TMapeamentoProduto>;
  mapeamentos_restante :TObjectList<TMapeamentoProduto>;
  ultimo_codigo:integer;
begin
try
  memLog.Lines.Clear;
  codigos := SYSPDV_SQL_CODIGO_AUXILIAR_REPO.getAll;
  mapeamentos := RK_PRODUTO_MAPEAMENTO_REPO.getAll;
  ultimo_codigo := RK_PRODUTO_MAPEAMENTO_REPO.getLastSequencial;
  produtos := SYSPDV_SQL_PRODUTO_REPO.getAll;


  TMapeamentoProdutoList.PreencherCodigoProduto(produtos,mapeamentos,ultimo_codigo);
  RK_PRODUTO_MAPEAMENTO_REPO.bulkInsert(mapeamentos);
  RK_PRODUTO_REPO.deleteAll;
  RK_PRODUTO_REPO.bulkInsert(produtos);
  Application.ProcessMessages;
  memLog.Lines.Add('PRODUTOS IMPORTADOS: '+ IntToStr(produtos.count));

  TMapeamentoProdutoList.PreencherCodigoProdutoAuxiliar(codigos,mapeamentos);
  RK_CODIGO_AUXILIAR_REPO.deleteAll;
  RK_CODIGO_AUXILIAR_REPO.bulkInsert(codigos);

  Application.ProcessMessages;
  memLog.Lines.Add('CODIGOS IMPORTADOS: '+ IntToStr(codigos.count));
  memLog.Lines.Add('');
  memLog.Lines.Add('IMPORTAÇÃO FINALIZADA');




finally
    produtos.Free;
  codigos.Free;
  mapeamentos.Free;

end;

end;

initialization
  Importar_Controller:=TImportarController.Create;


end.
