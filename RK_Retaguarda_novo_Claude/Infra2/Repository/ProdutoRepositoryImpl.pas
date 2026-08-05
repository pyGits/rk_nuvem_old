unit ProdutoRepositoryImpl;

interface
uses ProdutoModel, System.Generics.collections,uConexao,FireDAC.Comp.Client,System.SysUtils,Helpers,uConexaoSyspdv,uConexaoSyspdvSQL;

type IProdutoRepository = interface
  ['{E2B5E469-9321-4A75-B62E-4603256922C3}']
   function getAll:TObjectList<TProdutoModel>;
   function getAllByGrupo(codigoGrupo:string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
   function getAllByDescricao(descricao:string):TObjectList<TProdutoModel>;
   function getByCodigo(codigo:string):TProdutoModel;
   function getByCodigoBarras(codigoBarras:string):TProdutoModel;
   function getProdutosAlterados(dtInicio:TDate;dtFim:TDate;unidade:string):TObjectList<TProdutoModel>;
end;

type TProdutoRepositoryFirebird = class(TInterfacedObject,IProdutoRepository)
  private
  Query:TFDQuery;
  function ProdutoAdapter(query:TFDQuery):TProdutoModel;

  public
    function getAll: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
    function getAllByGrupo(codigoGrupo:string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
    function getByCodigo(codigo:string):TProdutoModel;
    function getByCodigoBarras(codigoBarras: string): TProdutoModel;
    function getProdutosAlterados(dtInicio:TDate;dtFim:TDate;unidade:string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
    function getAllByDescricao(descricao: string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;

end;

type TProdutoRepositorySyspdv = class(TInterfacedObject,IProdutoRepository)
  private
  FConexao:TConexaoSyspdv;
  query:TFDQuery;
  function ProdutoAdapter(query:TFDQuery):TProdutoModel;
  public
    constructor create(Conexao:TConexaoSyspdv);

    function getAll: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
    function getAllByGrupo(codigoGrupo:string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
    function getByCodigo(codigo:string):TProdutoModel;
    function getByCodigoBarras(codigoBarras: string): TProdutoModel;
    function getProdutosAlterados(dtInicio: TDate; dtFim: TDate;
      unidade: string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
    function getAllByDescricao(descricao: string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
end;

type TProdutoRepositorySyspdvSQL = class(TInterfacedObject,IProdutoRepository)
  private
  FConexao:TConexaoSyspdvSQL;
  query:TFDQuery;
  function ProdutoAdapter(query:TFDQuery):TProdutoModel;
  public
    constructor create(Conexao:TConexaoSyspdvSQL);
    function getAll: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
    function getAllByGrupo(codigoGrupo:string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
    function getByCodigo(codigo:string):TProdutoModel;
    function getByCodigoBarras(codigoBarras: string): TProdutoModel;
    function getProdutosAlterados(dtInicio: TDate; dtFim: TDate;
      unidade: string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
    function getAllByDescricao(descricao: string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;

end;

type TProdutoRepositoryFake = class(TInterfacedObject,IProdutoRepository)
  public
    function getAll: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
    function getAllByGrupo(codigoGrupo:string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
    function getByCodigo(codigo:string):TProdutoModel;
    function getByCodigoBarras(codigoBarras: string): TProdutoModel;
    function getProdutosAlterados(dtInicio: TDate; dtFim: TDate;
      unidade: string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
    function getAllByDescricao(descricao: string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;

end;




implementation

{ TProdutoRepositoryFirebird }


function TProdutoRepositoryFirebird.getAll: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin
  try
    Query := TConexao.GetInstance.ExecQuery('SELECT * FROM PRODUTO order by codigo_barras asc');
    result := TObjectList<TProdutoModel>.Create(true);

    while not Query.Eof do
    begin
      Result.Add(ProdutoAdapter(query));
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

function TProdutoRepositoryFirebird.getAllByDescricao(
  descricao: string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin
  try
    Query := TConexao.GetInstance.CreateQuery(
      'SELECT * FROM PRODUTO ' +
      'WHERE UPPER(DESCRICAO) LIKE :DESCRICAO ' +
      'ORDER BY CODIGO_BARRAS ASC'
    );

    Query.ParamByName('DESCRICAO').AsString := '%' + UpperCase(descricao) + '%';

    Query.Open;

    Result := TObjectList<TProdutoModel>.Create(True);

    while not Query.Eof do
    begin
      Result.Add(ProdutoAdapter(Query));
      Query.Next;
    end;

  finally
    Query.Free;
  end;
end;

function TProdutoRepositoryFirebird.getAllByGrupo(codigoGrupo:string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin
result := nil;

query := TConexao.GetInstance.CreateQuery('SELECT * FROM PRODUTO WHERE GRUPO = :CODIGO');
query.ParamByName('CODIGO').AsString := codigoGrupo.ZeroEsquerda(6);

query.Open;
 Result := TObjectList<TProdutoModel>.Create(True);

    while not Query.Eof do
    begin
      Result.Add(ProdutoAdapter(Query));
      Query.Next;
    end;


   Query.Free;
end;

function TProdutoRepositoryFirebird.getByCodigo(codigo: string): TProdutoModel;
begin
result := nil;

query := TConexao.GetInstance.CreateQuery('SELECT * FROM PRODUTO WHERE CODIGO = :CODIGO');
query.ParamByName('CODIGO').AsString := codigo.ZeroEsquerda(6);

query.Open;
if query.RecordCount = 0 then Exit;

result := ProdutoAdapter(query);
end;

function TProdutoRepositoryFirebird.getByCodigoBarras(
  codigoBarras: string): TProdutoModel;
begin
result := nil;

query := TConexao.GetInstance.CreateQuery('SELECT * FROM PRODUTO WHERE CODIGO_BARRAS = :CODIGO_BARRAS');
query.ParamByName('CODIGO_BARRAS').AsString := codigoBarras.ZeroEsquerda(14);

query.Open;
if query.RecordCount = 0 then Exit;

result := ProdutoAdapter(query);
end;

function TProdutoRepositoryFirebird.getProdutosAlterados(dtInicio:TDate;dtFim:TDate;unidade:string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
var
  sQuery: string;
begin
  Result := nil;

  sQuery := 'SELECT * FROM PRODUTO ' +
            'WHERE DATA_ALTERADO >= :DATAINICIO ' +
            'AND DATA_ALTERADO <= :DATAFIM ';

  if unidade <> 'TODOS' then
    sQuery := sQuery + 'AND UNIDADE = :UNIDADE ';

  query := TConexao.GetInstance.CreateQuery(sQuery);
  query.ParamByName('DATAINICIO').AsDate := dtInicio;
  query.ParamByName('DATAFIM').AsDate := dtFim;

  if unidade <> 'TODOS' then
    query.ParamByName('UNIDADE').AsString := unidade;

  query.Open;


  if query.RecordCount = 0 then exit;

  result := TObjectList<TProdutoModel>.create;

  Query.First;
  while not Query.Eof do
  begin
  result.Add(ProdutoAdapter(query));
  query.Next;
  end;


end;

function TProdutoRepositoryFirebird.ProdutoAdapter(
  query: TFDQuery): TProdutoModel;
begin
result := TProdutoModel.create;
result.codigo       := Query.FieldByName('CODIGO').AsString;
result.CodigoBarras:= Query.FieldByName('CODIGO_BARRAS').AsString;
result.Descricao         := Query.FieldByName('DESCRICAO').AsString;
result.grupo        := Query.FieldByName('GRUPO').AsString;
result.subgrupo     := Query.FieldByName('SUBGRUPO').AsString;
result.fornecedor   := Query.FieldByName('FORNECEDOR').AsString;
result.tributacao   := Query.FieldByName('TRIBUTACAO').AsString;
result.ncm          := Query.FieldByName('NCM').AsString;
result.cest         := Query.FieldByName('CEST').AsString;
result.validade     := Query.FieldByName('VALIDADE').AsString;
result.unidade      := Query.FieldByName('UNIDADE').AsString;
result.custo        := Query.FieldByName('CUSTO').AsFloat;
result.Preco  := Query.FieldByName('PRECO').AsFloat;
result.margem       := Query.FieldByName('MARGEM').AsFloat;
result.estoque      := Query.FieldByName('ESTOQUE').AsFloat;
result.DataCadastro:= Query.FieldByName('DATA_CADASTRO').AsDateTime;
result.DataAlterado:= Query.FieldByName('DATA_ALTERADO').AsDateTime;
result.balanca      := result.getBoolBalanca(Query.FieldByName('BALANCA').AsInteger);
result.fracionado   := result.getBoolFracionado(Query.FieldByName('FRACIONADO').AsInteger);
result.inativo      := result.getBoolInativo(Query.FieldByName('INATIVO').AsInteger);
result.diversos     := result.getBoolDiversos(Query.FieldByName('DIVERSOS').AsInteger);
result.estoqueMaximo:= Query.FieldByName('ESTOQUE_MAXIMO').AsFloat;
result.estoqueMinimo:= Query.FieldByName('ESTOQUE_MINIMO').AsFloat;
result.observacao   := Query.FieldByName('OBSERVACAO').AsString;
result.preco2 := query.FieldByName('PRECO2').AsFloat;
result.preco2_qtd := query.FieldByName('PRECO2_QTD').AsFloat;
end;

{ TProdutoRepositoryFake }

function TProdutoRepositoryFake.getAll: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin
//
end;

function TProdutoRepositoryFake.getAllByDescricao(
  descricao: string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin
raise Exception.Create('Nao implementado');
end;

function TProdutoRepositoryFake.getAllByGrupo(codigoGrupo:string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin

end;

function TProdutoRepositoryFake.getByCodigo(codigo: string): TProdutoModel;
begin
result := nil;

if codigo = '1' then
begin
  result := TProdutoModel.create;
  result.setDescricao('TESTE');
  result.SetPreco(1.99);
  result.SetCodigo('1');
  Result.SetCodigoBarras('00000000000001');
end;
end;

function TProdutoRepositoryFake.getByCodigoBarras(
  codigoBarras: string): TProdutoModel;
begin
result := nil;
if codigoBarras = '1' then
begin
  result := TProdutoModel.create;
  result.setDescricao('TESTE');
  result.SetPreco(1.99);
  result.SetCodigo('1');
  Result.SetCodigoBarras('00000000000001');
  result.SetValidade('');
end;

end;

function TProdutoRepositoryFake.getProdutosAlterados(dtInicio:TDate;dtFim:TDate;unidade:string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin

end;

{ TProdutoRepositorySyspdv }

constructor TProdutoRepositorySyspdv.create(Conexao:TConexaoSyspdv);
begin
FConexao := Conexao;
end;

function TProdutoRepositorySyspdv.getAll: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin
raise Exception.Create('Falta implementar');
end;

function TProdutoRepositorySyspdv.getAllByDescricao(
  descricao: string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin
raise Exception.Create('Nao implementado');
end;

function TProdutoRepositorySyspdv.getAllByGrupo(codigoGrupo:string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin

end;

function TProdutoRepositorySyspdv.getByCodigo(codigo: string): TProdutoModel;
begin
raise Exception.Create('Falta implementar');
end;

function TProdutoRepositorySyspdv.getByCodigoBarras(
  codigoBarras: string): TProdutoModel;
begin
  result := nil;
  query := FConexao.CreateQuery('');
  query.SQL.Clear;
  query.SQL.Add('SELECT * FROM PRODUTO WHERE PROCOD = :PROCOD');
  query.Params.ParamByName('PROCOD').AsString := codigoBarras.ZeroEsquerda(14);
  query.Open();

  if query.RecordCount =0 then exit;

  result := ProdutoAdapter(query);
end;

function TProdutoRepositorySyspdv.getProdutosAlterados(dtInicio:TDate;dtFim:TDate;unidade:string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
var
  sQuery:string;
begin
Result := nil;

  sQuery := 'SELECT * FROM PRODUTO ' +
            'WHERE PRODATCADALT >= :DATAINICIO ' +
            'AND PRODATCADALT <= :DATAFIM ';

  if unidade <> 'TODOS' then
    sQuery := sQuery + 'AND PROUNID = :UNIDADE ';

  query := FConexao.CreateQuery(sQuery);
  query.ParamByName('DATAINICIO').AsDate := dtInicio;
  query.ParamByName('DATAFIM').AsDate := dtFim;

  if unidade <> 'TODOS' then
    query.ParamByName('UNIDADE').AsString := unidade;

  query.Open;


  if query.RecordCount = 0 then exit;

  result := TObjectList<TProdutoModel>.create;

  Query.First;
  while not Query.Eof do
  begin
  result.Add(ProdutoAdapter(query));
  query.Next;
  end;
end;

function TProdutoRepositorySyspdv.ProdutoAdapter(
  query: TFDQuery): TProdutoModel;
begin
  result := TProdutoModel.create;
  result.SetCodigoBarras(query.FieldByName('PROCOD').AsString);
  result.setDescricao(query.FieldByName('PRODES').AsString);
  result.SetPreco(query.FieldByName('PROPRCVDAVAR').AsFloat);
  result.SetValidade(query.FieldByName('PROVLD').AsString);
  RESULT.SetUnidade(query.FieldByName('PROUNID').AsString);
end;

{ TProdutoRepositorySyspdvSQL }

constructor TProdutoRepositorySyspdvSQL.create(Conexao: TConexaoSyspdvSQL);
begin
FConexao := Conexao;
end;

function TProdutoRepositorySyspdvSQL.getAll: System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin

end;

function TProdutoRepositorySyspdvSQL.getAllByDescricao(
  descricao: string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin
raise Exception.Create('Nao implementado');
end;

function TProdutoRepositorySyspdvSQL.getAllByGrupo(codigoGrupo:string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
begin

end;

function TProdutoRepositorySyspdvSQL.getByCodigo(codigo: string): TProdutoModel;
begin

end;

function TProdutoRepositorySyspdvSQL.getByCodigoBarras(
  codigoBarras: string): TProdutoModel;
begin
  result := nil;
  query := FConexao.CreateQuery('');
  query.SQL.Clear;
  query.SQL.Add('SELECT * FROM PRODUTO WHERE PROCOD = :PROCOD');
  query.Params.ParamByName('PROCOD').AsString := codigoBarras.ZeroEsquerda(14);
  query.Open();

  if query.RecordCount =0 then exit;

  result := ProdutoAdapter(query);
end;

function TProdutoRepositorySyspdvSQL.getProdutosAlterados(dtInicio,
  dtFim: TDate;
  unidade: string): System.Generics.Collections.TObjectList<ProdutoModel.TProdutoModel>;
  var
    sQuery:string;
begin
Result := nil;

  sQuery := 'SELECT * FROM PRODUTO ' +
            'WHERE PRODATCADALT >= :DATAINICIO ' +
            'AND PRODATCADALT <= :DATAFIM ';

  if unidade <> 'TODOS' then
    sQuery := sQuery + 'AND PROUNID = :UNIDADE ';

  query := FConexao.CreateQuery(sQuery);
  query.ParamByName('DATAINICIO').AsDate := dtInicio;
  query.ParamByName('DATAFIM').AsDate := dtFim;

  if unidade <> 'TODOS' then
    query.ParamByName('UNIDADE').AsString := unidade;

  query.Open;


  if query.RecordCount = 0 then exit;

  result := TObjectList<TProdutoModel>.create;

  Query.First;
  while not Query.Eof do
  begin
  result.Add(ProdutoAdapter(query));
  query.Next;
  end;
end;

function TProdutoRepositorySyspdvSQL.ProdutoAdapter(
  query: TFDQuery): TProdutoModel;
begin
result := TProdutoModel.create;
  result.SetCodigoBarras(query.FieldByName('PROCOD').AsString);
  result.setDescricao(query.FieldByName('PRODES').AsString);
  result.SetPreco(query.FieldByName('PROPRCVDAVAR').AsFloat);
  result.SetValidade(query.FieldByName('PROVLD').AsString);
  RESULT.SetUnidade(query.FieldByName('PROUNID').AsString);
end;

end.
