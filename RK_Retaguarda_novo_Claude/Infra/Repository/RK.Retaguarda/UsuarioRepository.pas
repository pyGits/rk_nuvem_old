unit UsuarioRepository;

interface
uses Usuario,RKConnection,Firedac.comp.client;
type TUsuarioRepository = class

  public
    function CarregarUsuario(codigo:string):TUsuario;
end;
var
  Usuario_Repository:TUsuarioRepository;

implementation
{ TUsuarioRepository }

function TUsuarioRepository.CarregarUsuario(codigo: string): TUsuario;
var
  query:TFDQuery;
begin
  result := TUsuario.create;
  query := RKConn.GetQuery('SELECT * FROM Funcionario WHERE CODIGO = :CODIGO');
  query.ParamByName('CODIGO').AsString := codigo;
  query.Open;

  if (query.RecordCount = 0)  then exit;
  

  Result.Codigo := query.FieldByName('CODIGO').AsString;
  Result.Pessoa.Nome := query.FieldByName('NOME').AsString;
  Result.Pessoa.Apelido := query.FieldByName('APELIDO').AsString;
  Result.Pessoa.Email := query.FieldByName('EMAIL').AsString;
  Result.Pessoa.CPFCNPJ := query.FieldByName('CPF').AsString;
  Result.cargo := query.FieldByName('CARGO').AsInteger;
  Result.senha := query.FieldByName('SENHA').AsString;
  Result.comissao := query.FieldByName('COMISSAO').AsFloat;
end;

initialization
    Usuario_Repository:=TUsuarioRepository.Create;

end.
