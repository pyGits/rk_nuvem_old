unit ProprioRepositoryImpl;

interface
uses ProprioModel,uConexao,FireDAC.Comp.Client;
type IProprioRepository = interface
  ['{FE3F664B-3DD9-4095-84D2-5C89DEE44AD1}']
  function get:TProprioModel;
end;
type TProprioRepositoryFirebird = class(TInterfacedObject,IProprioRepository)

  public
    function get: TProprioModel;
end;

implementation

{ TEmitenteRepositoryFirebird }

function TProprioRepositoryFirebird.get: TProprioModel;
var
  query:TFDQuery;
begin
result := nil;
query := TConexao.GetInstance.ExecQuery('SELECT * FROM PROPRIO');

if query.RecNo = 1 then
begin
  result := TProprioModel.create;
  with result,query do
  begin
  Codigo := FieldByName('CODIGO').AsString;
  Endereco.Endereco := FieldByName('ENDERECO').AsString;
  Endereco.Numero := FieldByName('NUMERO').AsString;
  Endereco.Bairro := FieldByName('BAIRRO').AsString;
  Endereco.Cidade := FieldByName('CIDADE').AsString;
  Endereco.UF := FieldByName('UF').AsString;
  Endereco.CEP := FieldByName('CEP').AsString;
  Endereco.Complemento := FieldByName('COMPLEMENTO').AsString;
  Pessoa.Nome := FieldByName('NOME').AsString;
  Pessoa.Apelido := FieldByName('FANTASIA').AsString;
  Pessoa.CPFCNPJ := FieldByName('CNPJCPF').AsString;
  Pessoa.Telefone1 := FieldByName('TELEFONE').AsString;
  Pessoa.Celular1 := FieldByName('CELULAR').AsString;
  Pessoa.Email := FieldByName('EMAIL').AsString;
  IE := FieldByName('IE').AsString;
  IBGE := FieldByName('IBGE').AsString;
  end;
end;
end;

end.
