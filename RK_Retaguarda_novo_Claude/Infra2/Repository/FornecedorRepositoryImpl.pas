unit FornecedorRepositoryImpl;

interface

uses
  FornecedorModel, uConexao, FireDAC.Comp.Client, System.SysUtils;

type
  IFornecedorRepository = interface
    ['{E9C59A3B-1A25-4F38-9E7B-97D6C9468B72}']
    function Get(codigo: string): TFornecedorModel;
    procedure Insert(fornecedor: TFornecedorModel);
  end;

  TFornecedorRepositoryFirebird = class(TInterfacedObject, IFornecedorRepository)
  public
    function Get(codigo: string): TFornecedorModel;
    procedure Insert(fornecedor: TFornecedorModel);
  end;

implementation

{ TFornecedorRepositoryFirebird }

function TFornecedorRepositoryFirebird.Get(codigo: string): TFornecedorModel;
var
  query: TFDQuery;
begin
  Result := nil;
  query := TConexao.GetInstance.CreateQuery('SELECT * FROM FORNECEDOR WHERE CODIGO = :CODIGO');
  try
    query.ParamByName('CODIGO').AsString := codigo;
    query.Open;

    if query.RecordCount = 0 then
      Exit;

    Result := TFornecedorModel.Create;
    Result.codigo        := query.FieldByName('CODIGO').AsString;
    Result.nome          := query.FieldByName('NOME').AsString;
    Result.NomeFantasia := query.FieldByName('NOME_FANTASIA').AsString;
    Result.endereco      := query.FieldByName('ENDERECO').AsString;
    Result.numero        := query.FieldByName('NUMERO').AsString;
    Result.bairro        := query.FieldByName('BAIRRO').AsString;
    Result.cidade        := query.FieldByName('CIDADE').AsString;
    Result.uf            := query.FieldByName('UF').AsString;
    Result.cep           := query.FieldByName('CEP').AsString;
    Result.complemento   := query.FieldByName('COMPLEMENTO').AsString;
    Result.telefone1     := query.FieldByName('TELEFONE1').AsString;
    Result.telefone2     := query.FieldByName('TELEFONE2').AsString;
    Result.celular       := query.FieldByName('CELULAR').AsString;
    Result.email         := query.FieldByName('EMAIL').AsString;
    Result.cnpjcpf       := query.FieldByName('CNPJCPF').AsString;
    Result.ie            := query.FieldByName('IE').AsString;
    Result.im            := query.FieldByName('IM').AsString;
    Result.observacao    := query.FieldByName('OBSERVACAO').AsString;
    Result.contato1      := query.FieldByName('CONTATO1').AsString;
    Result.contato2      := query.FieldByName('CONTATO2').AsString;
  finally
    query.Free;
  end;
end;

procedure TFornecedorRepositoryFirebird.Insert(fornecedor: TFornecedorModel);
var
  query: TFDQuery;
begin
  query := TConexao.GetInstance.CreateQuery(
    'INSERT INTO FORNECEDOR (' +
    'CODIGO, NOME, NOME_FANTASIA, ENDERECO, NUMERO, BAIRRO, CIDADE, UF, CEP, ' +
    'COMPLEMENTO, TELEFONE1, TELEFONE2, CELULAR, EMAIL, CNPJCPF, IE, IM, ' +
    'OBSERVACAO, CONTATO1, CONTATO2) ' +
    'VALUES (' +
    ':CODIGO, :NOME, :NOME_FANTASIA, :ENDERECO, :NUMERO, :BAIRRO, :CIDADE, :UF, :CEP, ' +
    ':COMPLEMENTO, :TELEFONE1, :TELEFONE2, :CELULAR, :EMAIL, :CNPJCPF, :IE, :IM, ' +
    ':OBSERVACAO, :CONTATO1, :CONTATO2)'
  );
  try
    query.ParamByName('CODIGO').AsString        := fornecedor.codigo;
    query.ParamByName('NOME').AsString          := fornecedor.nome;
    query.ParamByName('NOME_FANTASIA').AsString := fornecedor.NomeFantasia;
    query.ParamByName('ENDERECO').AsString      := fornecedor.endereco;
    query.ParamByName('NUMERO').AsString        := fornecedor.numero;
    query.ParamByName('BAIRRO').AsString        := fornecedor.bairro;
    query.ParamByName('CIDADE').AsString        := fornecedor.cidade;
    query.ParamByName('UF').AsString            := fornecedor.uf;
    query.ParamByName('CEP').AsString           := fornecedor.cep;
    query.ParamByName('COMPLEMENTO').AsString   := fornecedor.complemento;
    query.ParamByName('TELEFONE1').AsString     := fornecedor.telefone1;
    query.ParamByName('TELEFONE2').AsString     := fornecedor.telefone2;
    query.ParamByName('CELULAR').AsString       := fornecedor.celular;
    query.ParamByName('EMAIL').AsString         := fornecedor.email;
    query.ParamByName('CNPJCPF').AsString       := fornecedor.cnpjcpf;
    query.ParamByName('IE').AsString            := fornecedor.ie;
    query.ParamByName('IM').AsString            := fornecedor.im;
    query.ParamByName('OBSERVACAO').AsString    := fornecedor.observacao;
    query.ParamByName('CONTATO1').AsString      := fornecedor.contato1;
    query.ParamByName('CONTATO2').AsString      := fornecedor.contato2;

    query.ExecSQL;
  finally
    query.Free;
  end;
end;

end.

