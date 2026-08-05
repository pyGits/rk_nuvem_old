unit uDmCliente;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,Classe.Cliente,NxGrid,Conversao,Classe.Funcoes;

type
  TdmCliente = class(TDataModule)
    qrClientePesquisar: TUniQuery;
    qrClienteAlterar: TUniQuery;
    qrClienteExcluir: TUniQuery;
    qrClienteInserir: TUniQuery;
    qrGridCliente: TUniQuery;
  private
    { Private declarations }
  public
    function CarregarCliente(oCliente : TCliente): Boolean;
    function AlterarCliente(oCliente:TCliente):Boolean;
    function InserirCliente(oCliente:TCliente):Boolean;
    function ExcluirCliente(oCliente:TCliente):Boolean;
    function PreencherGrid(sCliente:string;ds:TDataSource;tipo:TPesquisar):Boolean;


    function VerificaCliente(oCliente:TCliente):Boolean;
  end;

var
  dmCliente: TdmCliente;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmCliente }

function TdmCliente.AlterarCliente(oCliente: TCliente): Boolean;
begin
with qrClienteAlterar,oCliente do
begin
  ParamByName('CODIGO').AsString:=Codigo;
  ParamByName('ENDERECO').AsString:=Endereco.Endereco;
  ParamByName('NUMERO').AsString:=Endereco.Numero;
  ParamByName('BAIRRO').AsString:=Endereco.Bairro;
  ParamByName('CIDADE').AsString:=Endereco.Cidade;
  ParamByName('UF').AsString:=Endereco.UF;
  ParamByName('CEP').AsString:=Endereco.CEP;
  ParamByName('COMPLEMENTO').AsString:=Endereco.Complemento;
  ParamByName('NOME').AsString:=Pessoa.Nome;
  ParamByName('NOME_FANTASIA').AsString:=Pessoa.Apelido;
  ParamByName('CNPJCPF').AsString:=Pessoa.CPFCNPJ;
  ParamByName('TELEFONE1').AsString:=Pessoa.Telefone1;
  ParamByName('TELEFONE2').AsString:=Pessoa.Telefone2;
  ParamByName('CELULAR').AsString:=Pessoa.Celular1;
  ParamByName('EMAIL').AsString:=Pessoa.Email;
  ParamByName('OBSERVACAO').AsString:=Observacao;
  ParamByName('TIPO_PESSOA').AsInteger := Pessoa.tipoPessoa;
  ParamByName('DATA_CADASTRO').AsDate := datacadastro;
  ParamByName('CREDITO_LIMITE').AsFloat:=LimiteCredito;
  ParamByName('CREDITO_UTILIZADO').AsFloat:=UtilizadoCredito;
  ParamByName('DATA_NASCIMENTO').AsDate := pessoa.dataNascimento;
  ParamByName('PERC_DESCONTO').AsFloat:=PercDesconto;

  ExecSQL;
end;
end;

function TdmCliente.CarregarCliente(oCliente: TCliente): Boolean;
begin
with qrClientePesquisar,oCliente do
begin
  close;
  sql.clear;
  sql.add('SELECT * FROM Cliente WHERE CODIGO = :CODIGO');
  ParamByName('CODIGO').asstring := oCliente.Codigo;
    try
      qrClientePesquisar.Open;
      if qrClientePesquisar.RecordCount > 0 then
      begin
      Codigo := qrClientePesquisar.FieldByName('CODIGO').AsString;
      Endereco.Endereco := qrClientePesquisar.FieldByName('ENDERECO').AsString;
      Endereco.Numero := qrClientePesquisar.FieldByName('NUMERO').AsString;
      Endereco.Bairro := qrClientePesquisar.FieldByName('BAIRRO').AsString;
      Endereco.Cidade := qrClientePesquisar.FieldByName('CIDADE').AsString;
      Endereco.UF := qrClientePesquisar.FieldByName('UF').AsString;
      Endereco.CEP := qrClientePesquisar.FieldByName('CEP').AsString;
      Endereco.Complemento := qrClientePesquisar.FieldByName('COMPLEMENTO').AsString;
      Pessoa.Nome := qrClientePesquisar.FieldByName('NOME').AsString;
      Pessoa.Apelido := qrClientePesquisar.FieldByName('NOME_FANTASIA').AsString;
      Pessoa.CPFCNPJ := qrClientePesquisar.FieldByName('CNPJCPF').AsString;
      Pessoa.Telefone1 := qrClientePesquisar.FieldByName('TELEFONE1').AsString;
      Pessoa.Telefone2 := qrClientePesquisar.FieldByName('TELEFONE2').AsString;
      Pessoa.Celular1 := qrClientePesquisar.FieldByName('CELULAR').AsString;
      Pessoa.Email := qrClientePesquisar.FieldByName('EMAIL').AsString;
      Pessoa.tipoPessoa :=qrClientePesquisar.FieldByName('TIPO_PESSOA').AsInteger;
      Pessoa.dataNascimento := qrClientePesquisar.FieldByName('DATA_NASCIMENTO').AsDateTime;
      DataCadastro := qrClientePesquisar.FieldByName('DATA_CADASTRO').AsDateTime;
      Observacao := qrClientePesquisar.FieldByName('OBSERVACAO').AsString;
      LimiteCredito := qrClientePesquisar.FieldByName('CREDITO_LIMITE').AsFloat;
      UtilizadoCredito := qrClientePesquisar.FieldByName('CREDITO_UTILIZADO').AsFloat;
      UtilizaPreco2 := (qrClientePesquisar.FieldByName('UTILIZA_PRECO2').AsInteger = 1);
      PercDesconto := qrClientePesquisar.FieldByName('PERC_DESCONTO').AsFloat;


      result := True;
      end
      else
      begin
        Codigo := '000000';
        result := false;
      end;



    except
      on E : Exception do
      begin
          raise Exception.Create('Erro ao carregar Cliente: '+ E.message);
          Result := False;
      end;

    end;
end;
end;

function TdmCliente.ExcluirCliente(oCliente: TCliente): Boolean;
begin
 with qrClienteExcluir do
begin
  ParamByName('CODIGO').AsString := oCliente.Codigo;
  ExecSQL;
end;
end;

function TdmCliente.InserirCliente(oCliente: TCliente): Boolean;
begin
 with qrClienteInserir,oCliente do
begin
  ParamByName('CODIGO').AsString:=Codigo;
  ParamByName('ENDERECO').AsString:=Endereco.Endereco;
  ParamByName('NUMERO').AsString:=Endereco.Numero;
  ParamByName('BAIRRO').AsString:=Endereco.Bairro;
  ParamByName('CIDADE').AsString:=Endereco.Cidade;
  ParamByName('UF').AsString:=Endereco.UF;
  ParamByName('CEP').AsString:=Endereco.CEP;
  ParamByName('COMPLEMENTO').AsString:=Endereco.Complemento;
  ParamByName('NOME').AsString:=Pessoa.Nome;
  ParamByName('NOME_FANTASIA').AsString:=Pessoa.Apelido;
  ParamByName('CNPJCPF').AsString:=Pessoa.CPFCNPJ;
  ParamByName('TELEFONE1').AsString:=Pessoa.Telefone1;
  ParamByName('TELEFONE2').AsString:=Pessoa.Telefone2;
  ParamByName('CELULAR').AsString:=Pessoa.Celular1;
  ParamByName('EMAIL').AsString:=Pessoa.Email;
  ParamByName('TIPO_PESSOA').AsInteger := Pessoa.tipoPessoa;
  ParamByName('DATA_CADASTRO').AsDate := datacadastro;
  ParamByName('OBSERVACAO').AsString:=Observacao;
  ParamByName('CREDITO_LIMITE').AsFloat:=LimiteCredito;
  ParamByName('CREDITO_UTILIZADO').AsFloat:=UtilizadoCredito;
  ParamByName('DATA_NASCIMENTO').AsDate := pessoa.dataNascimento;
  ParamByName('PERC_DESCONTO').AsFloat:=PercDesconto;
  ExecSQL;
end;
end;
function TdmCliente.PreencherGrid(sCliente:string;ds:TDataSource;tipo:TPesquisar):Boolean;
begin
with qrGridCliente do
begin
ds.DataSet := qrGridCliente;
sCliente := StringReplace(sCliente,Chr(39),'',[rfReplaceAll,rfIgnoreCase]);
Close;
SQL.Clear;
SQL.Add('SELECT * FROM Cliente');

   if sCliente = EmptyStr then
   begin
      SQL.Add('WHERE NOME LIKE '+Chr(39)+'%%%'+Chr(39));
      SQL.Add('ORDER BY 1');
   end
   else
   begin

    if tipo = nome then
    begin

      SQL.Add('WHERE NOME LIKE '+Chr(39)+'%'+sCliente+'%'+Chr(39));
      SQL.Add('ORDER BY NOME');

    end
    else
    if tipo = codigo then
    begin
      SQL.Add('WHERE CNPJCPF LIKE '+Chr(39)+sCliente+'%'+Chr(39));
      SQL.Add('ORDER BY CNPJCPF');
    end;
    if tipo = telefone then
    begin
      SQL.Add('WHERE telefone1 LIKE '+QuotedStr('%'+sCliente+'%')+' OR ');
      SQL.Add('telefone2 LIKE '+QuotedStr('%'+sCliente+'%')+' OR ');
      SQL.Add('celular LIKE '+QuotedStr('%'+sCliente+'%'));
      SQL.Add('ORDER BY nome asc');
    end;


   end;

Open;


end;
end;

function TdmCliente.VerificaCliente(oCliente: TCliente): Boolean;
begin
with qrClientePesquisar do
begin
  Close;
  SQL.Clear;
  SQL.add('select * from cliente where cnpjcpf = :CNPJCPF');
  ParamByName('CNPJCPF').AsString := oCliente.Pessoa.CPFCNPJ;
  Open;
  if qrClientePesquisar.RecordCount > 0 then
  begin
    // encontrou cliente
    oCliente.codigo := FieldByName('CODIGO').AsString;
    CarregarCliente(oCliente);
    result := true;
  end
  else
  begin
    Result := false;
  end;
end;
end;

end.
