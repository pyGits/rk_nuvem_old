unit uDmCliente;

interface

uses
  System.SysUtils, System.Classes, Data.DB, MemDS, DBAccess, Uni,Cliente,Conexao;

type
  TdmCliente = class(TDataModule)
    qrClienteInsert: TUniQuery;
  private
    { Private declarations }
  public
    function InsertCliente(oCliente:TCliente):boolean;
  end;

var
  dmCliente: TdmCliente;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmCliente }

function TdmCliente.InsertCliente(oCliente: TCliente): boolean;
begin
with qrClienteInsert,oCliente do
begin
  close;
  sql.Clear;
  sql.Add('UPDATE OR INSERT INTO CLIENTE (CODIGO,NOME,NOME_FANTASIA,ENDERECO,NUMERO,BAIRRO,CIDADE,UF,CEP,COMPLEMENTO,TELEFONE1,TELEFONE2,CELULAR,EMAIL,CNPJCPF,PERC_DESCONTO,UTILIZA_PRECO2)');
  sql.Add('VALUES(:CODIGO,:NOME,:NOME_FANTASIA,:ENDERECO,:NUMERO,:BAIRRO,:CIDADE,:UF,:CEP,:COMPLEMENTO,:TELEFONE1,:TELEFONE2,:CELULAR,:EMAIL,:CNPJCPF,:PERC_DESCONTO,:UTILIZA_PRECO2)');
    ParamByName('CODIGO').AsString := codigo;
    ParamByName('NOME').AsString := nome;
    ParamByName('NOME_FANTASIA').AsString := fantasia;
    ParamByName('ENDERECO').AsString := endereco;
    ParamByName('NUMERO').AsString := numero;
    ParamByName('BAIRRO').AsString := bairro;
    ParamByName('CIDADE').AsString := cidade;
    ParamByName('UF').AsString := uf;
    ParamByName('CEP').AsString := cep;
    ParamByName('COMPLEMENTO').AsString := complemento;
    ParamByName('TELEFONE1').AsString := telefone1;
    ParamByName('TELEFONE2').AsString := telefone2;
    ParamByName('CELULAR').AsString := celular;
    ParamByName('EMAIL').AsString := email;
    ParamByName('CNPJCPF').AsString := cnpjcpf;
    ParamByName('PERC_DESCONTO').AsFloat := Perc_Desconto;
    ParamByName('UTILIZA_PRECO2').AsInteger := Ord(utiliza_preco2);
    ExecSQL;

end;

end;

end.
