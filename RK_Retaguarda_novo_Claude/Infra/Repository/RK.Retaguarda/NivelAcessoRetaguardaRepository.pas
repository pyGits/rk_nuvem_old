unit NivelAcessoRetaguardaRepository;

interface
uses NivelAcessoRetaguarda,RKConnection,FireDAC.Comp.Client;
type TNivelAcessoRetaguardaRepository = class
  private
  public
  function CarregarNivelAcesso(formulario:string):TNivelAcessoRetaguarda;
end;
var
  NivelAcessoRetaguarda_Repository:TNivelAcessoRetaguardaRepository;

implementation
{ TNivelAcessoRetaguardaRepository }

function TNivelAcessoRetaguardaRepository.CarregarNivelAcesso(
  formulario: string): TNivelAcessoRetaguarda;
  var
    query:TFDQuery;
begin
result := TNivelAcessoRetaguarda.Create;
query := RKConn.GetQuery('SELECT * FROM RETAGUARDA_NIVEL WHERE FUNCDESC = '+Chr(39)+formulario+Chr(39)+'');
query.open;

result.Codigo := query.FieldByName('CODIGO').AsString;
result.CodigoFuncao := query.FieldByName('ACFUNC').AsString;
result.Descricao := query.FieldByName('FUNCDESC').AsString;
result.Categoria := query.FieldByName('FUNCCAT').AsString;
result.FuncaoNivel := query.FieldByName('FUNCNIV').AsString;
result.funcaoSolicitaSenha := query.FieldByName('FUNCSOLIC').AsString;

end;

initialization
  NivelAcessoRetaguarda_Repository := TNivelAcessoRetaguardaRepository.Create;

end.
