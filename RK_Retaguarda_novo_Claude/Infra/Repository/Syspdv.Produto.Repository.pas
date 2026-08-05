unit Syspdv.Produto.Repository;


interface
uses Produto,System.Generics.Collections,SyspdvConnection,FireDAC.Comp.Client,ProdutoSyspdvAdapter,System.sysutils;

type TProdutoSyspdvRepository = class
  public
    function getAll:TObjectList<TProduto>;
end;

type TProdutoSyspdvSQLRepository = class
  public
    function getAll:TObjectList<TProduto>;
end;



var
  SYSPDV_PRODUTO_REPO : TProdutoSyspdvRepository;
  SYSPDV_SQL_PRODUTO_REPO : TProdutoSyspdvSQLRepository;

implementation

{ TProdutoSyspdvRepository }

function TProdutoSyspdvRepository.getAll: TObjectList<TProduto>;
var
  query:TFDQuery;
  produto:TProduto;
begin
try
  result := TObjectList<TProduto>.create(true);
  query := SyspdvConn.ExecuteQuery('select * from produto');
  while not query.eof do  begin
    produto := TProdutoSyspdvAdapter.ProdutoSyspdv(query);
    result.Add(produto);
    query.Next;
  end;
finally
  query.Free;
end;

end;
{ TProdutoSyspdvSQLRepository }

function TProdutoSyspdvSQLRepository.getAll: TObjectList<TProduto>;
var
  query:TFDQuery;
  produto:TProduto;
begin
try
  result := TObjectList<TProduto>.create(true);
  query := SyspdvConnSQL.ExecuteQuery('select * from produto');
  while not query.eof do  begin
    produto := TProdutoSyspdvAdapter.ProdutoSyspdv(query);
    result.Add(produto);
    query.Next;
  end;
finally
  query.Free;
end;
end;

initialization
  SYSPDV_PRODUTO_REPO := TProdutoSyspdvRepository.create;
  SYSPDV_SQL_PRODUTO_REPO := TProdutoSyspdvSQLRepository.Create;



end.
