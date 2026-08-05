unit RK.Etiqueta.Repository;

interface
uses Produto,RKConnection,FireDAC.Comp.Client,Classe.funcoes,System.SysUtils;
type TEtiquetaRepository = class
  public
  procedure insert(produto:TProduto;codigo:string);
end;
var
  RK_ETIQUETA_REPO:TEtiquetaRepository;
implementation


{ TEtiquetaRepository }

procedure TEtiquetaRepository.insert(produto: TProduto; codigo: string);
var
  query:TFDQuery;
begin
query := RKConn.GetQuery('insert into ETIQUETA ( CODIGO, CODIGO_BARRAS, PRODUTO, UNIDADE, PRECO,VALIDADE) values (:CODIGO, :CODIGO_BARRAS, :PRODUTO, :UNIDADE, :PRECO,:VALIDADE)');
  with query do
  begin
   ParamByName('CODIGO').AsString := produto.Codigo;
    Params.ParamByName('CODIGO_BARRAS').AsString := removeZeroEsquerda(codigo);
    Params.ParamByName('PRODUTO').AsString := produto.Descricao;
    Params.ParamByName('UNIDADE').AsString := produto.Unidade;
    Params.ParamByName('PRECO').AsFloat := produto.Preco;
  if not Trim(produto.Validade).IsEmpty then
  begin
    Params.ParamByName('VALIDADE').AsInteger := StrToInt(produto.Validade)
  end
  else
  begin
    Params.ParamByName('VALIDADE').Clear;
  end;
  end;
  query.ExecSQL;
end;

initialization
  RK_ETIQUETA_REPO:=TEtiquetaRepository.Create;
end.
