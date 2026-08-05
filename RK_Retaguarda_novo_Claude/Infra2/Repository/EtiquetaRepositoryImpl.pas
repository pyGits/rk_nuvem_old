unit EtiquetaRepositoryImpl;

interface
uses ProdutoModel,FireDAC.Comp.Client,Helpers,uConexaoLocal,System.Generics.Collections,EtiquetaLayoutModel;
type IEtiquetaRepository = interface
  ['{4A59AAC0-E0EA-47DD-A933-AFD04E83E5F7}']
  procedure inserirItem(produto:TProdutoModel);
  procedure deletarItem(id:string);
  procedure deletarTodosItens;
  function ObterFilaImpressao:TObjectList<TProdutoModel>;
  function CarregarLayouts:TObjectList<TEtiquetaLayoutModel>;
  function ObterLayout(codigo:string):TEtiquetaLayoutModel;
end;

type TEtiquetaRepositoryFirebird = class(TInterfacedObject,IEtiquetaRepository)
  private
    query:TFDQuery;
  public
    procedure inserirItem(produto: TProdutoModel);
    procedure deletarItem(id:string);
    procedure deletarTodosItens;

    function CarregarLayouts: System.Generics.Collections.TObjectList<EtiquetaLayoutModel.TEtiquetaLayoutModel>;
    function ObterFilaImpressao: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
    function ObterLayout(codigo: string): TEtiquetaLayoutModel;



end;



implementation

{ TEtiquetaRepositoryFirebird }

function TEtiquetaRepositoryFirebird.CarregarLayouts: System.Generics.Collections.TObjectList<EtiquetaLayoutModel.TEtiquetaLayoutModel>;
begin
result := nil;

query := TConexaoLocal.GetInstance('127.0.0.1','c:\system_rk\server\bd\banco.fdb',tbFirebird).CreateQuery('SELECT * FROM ETIQUETA_LAYOUT');
query.open;
if query.RecordCount =0  then exit;


result := TObjectList<TEtiquetaLayoutModel>.Create(true);

while not query.Eof do
begin
result.Add(TEtiquetaLayoutModel.create);
result.Last.codigo := query.FieldByName('CODIGO').AsString;
result.Last.nome :=  query.FieldByName('NOME').AsString;
result.Last.arquivo :=  query.FieldByName('ARQUIVO').AsString;
query.next;
end;

end;

procedure TEtiquetaRepositoryFirebird.deletarItem(id: string);
begin
query := TConexaoLocal.GetInstance('127.0.0.1','c:\system_rk\server\bd\banco.fdb',tbFirebird).CreateQuery('');
query.SQL.Clear;
query.SQL.Add('DELETE FROM ETIQUETA WHERE ID = :ID');
query.Params.ParamByName('ID').AsString := id;
query.ExecSQL;
end;

procedure TEtiquetaRepositoryFirebird.deletarTodosItens;
begin
query := TConexaoLocal.GetInstance('127.0.0.1','c:\system_rk\server\bd\banco.fdb',tbFirebird).CreateQuery('');
query.SQL.Clear;
query.SQL.Add('DELETE FROM ETIQUETA');
query.ExecSQL;
end;

procedure TEtiquetaRepositoryFirebird.inserirItem(produto: TProdutoModel);
begin
query := TConexaoLocal.GetInstance('127.0.0.1','c:\system_rk\server\bd\banco.fdb',tbFirebird).CreateQuery('');
query.SQL.Clear;
query.SQL.Add('INSERT INTO ETIQUETA(CODIGO,CODIGO_BARRAS,PRODUTO,UNIDADE,PRECO,VALIDADE) VALUES (:CODIGO,:CODIGO_BARRAS,:PRODUTO,:UNIDADE,:PRECO,:VALIDADE)');
query.Params.ParamByName('CODIGO').AsString := PRODUTO.Codigo;
query.Params.ParamByName('CODIGO_BARRAS').AsString := produto.CodigoBarras;
query.Params.ParamByName('PRODUTO').AsString := produto.Descricao;
query.Params.ParamByName('UNIDADE').AsString := produto.Unidade;
query.Params.ParamByName('PRECO').AsFloat := produto.Preco;
query.Params.ParamByName('VALIDADE').AsInteger := produto.Validade.parainteiro;
query.ExecSQL;
end;

function TEtiquetaRepositoryFirebird.ObterFilaImpressao: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin
result := nil;
query := TConexaoLocal.GetInstance('127.0.0.1','c:\system_rk\server\bd\banco.fdb',tbFirebird).CreateQuery('select * from etiqueta order by id asc');
query.open;

if query.RecordCount =0 then exit;

result := TObjectList<TProdutoModel>.create(True);
while not query.Eof do
begin
result.Add(TProdutoModel.create);
result.Last.Codigo := query.FieldByName('ID').AsString;
result.Last.CodigoBarras := query.FieldByName('CODIGO_BARRAS').AsString;
result.Last.Descricao := query.FieldByName('PRODUTO').AsString;
result.Last.unidade := query.FieldByName('unidade').AsString;
result.Last.preco := query.FieldByName('PRECO').AsFloat;
result.Last.Validade := query.FieldByName('VALIDADE').AsString;
query.Next;
end;


end;

function TEtiquetaRepositoryFirebird.ObterLayout(
  codigo: string): TEtiquetaLayoutModel;
begin
result := nil;

if codigo = '' then exit;


query := TConexaoLocal.GetInstance('127.0.0.1','c:\system_rk\server\bd\banco.fdb',tbFirebird).CreateQuery('select * from etiqueta_layout where codigo = :CODIGO');
query.ParamByName('CODIGO').AsString := codigo;
query.open;

if query.RecordCount =0 then exit;

result := TEtiquetaLayoutModel.Create;
result.codigo := query.FieldByName('CODIGO').AsString;
result.nome := query.FieldByName('NOME').AsString;
result.arquivo := query.FieldByName('ARQUIVO').AsString;
end;

end.
