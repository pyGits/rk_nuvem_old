unit ClientePDVRepository;

interface
uses ClienteModel,System.Generics.Collections,uConexaoPDV,CaixaModel,FireDAC.Comp.Client,system.SysUtils;
type IClientePDVRepository = interface
  ['{45003203-1E2C-46B3-996D-A3005F765F95}']
  procedure InsertBulk(oClienteList:TObjectList<TClienteModel>;caixa:TCaixaModel);
end;

type TClientePDVRepository = class(TInterfacedObject,IClientePDVRepository)

  public
    procedure InsertBulk(oClienteList: System.Generics.Collections.TObjectList<ClienteModel.TClienteModel>;
      caixa: TCaixaModel);
end;

implementation

{ TClientePDVRepository }

procedure TClientePDVRepository.InsertBulk(
  oClienteList: System.Generics.Collections.TObjectList<ClienteModel.TClienteModel>;
  caixa: TCaixaModel);
var
  Query:TFDquery;
  I:integer;
  Cliente:TClienteModel;
begin
  Query := TConexaoPDV.GetInstance(caixa.ip).CreateQuery;
  Query.SQL.Clear;
  Query.SQL.Add('UPDATE OR INSERT INTO CLIENTE(CODIGO,NOME,CPF,PERC_DESCONTO,ENDERECO,COMPLEMENTO,BAIRRO,CIDADE,UF,CEP,OBS)');
  Query.SQL.Add('VALUES(:CODIGO,:NOME,:CPF,:PERC_DESCONTO,:ENDERECO,:COMPLEMENTO,:BAIRRO,:CIDADE,:UF,:CEP,:OBS)');

  for cliente in oClienteList do
  begin
    Query.ParamByName('CODIGO').AsInteger := strtoInt(Cliente.codigo);
    Query.ParamByName('NOME').asstring := Cliente.nome;
    Query.ParamByName('CPF').asstring := Cliente.cnpjcpf;
    Query.ParamByName('PERC_DESCONTO').AsFloat := Cliente.perc_desconto;

    query.ParamByName('ENDERECO').asstring := cliente.endereco;
    query.ParamByName('COMPLEMENTO').asstring := cliente.complemento;
    query.ParamByName('BAIRRO').asstring := cliente.bairro;
    query.ParamByName('CIDADE').asstring := cliente.cidade;
    query.ParamByName('UF').asstring := cliente.uf;
    query.ParamByName('CEP').asstring := cliente.cep;
    query.ParamByName('OBS').asstring := cliente.Observacao;

    Query.ExecSQL;
  end;

end;

end.
