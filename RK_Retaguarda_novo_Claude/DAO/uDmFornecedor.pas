unit uDmFornecedor;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,Classe.Fornecedor,NxGrid,Conversao,Classe.Funcoes;

type
  TdmFornecedor = class(TDataModule)
    qrFornecedorPesquisar: TUniQuery;
    qrFornecedorInserir: TUniQuery;
    qrFornecedorAlterar: TUniQuery;
    qrFornecedorExcluir: TUniQuery;
    qrGridFornecedor: TUniQuery;
  private
    { Private declarations }
  public
    function CarregarFornecedor(oFornecedor : TFornecedor): Boolean;
    function AlterarFornecedor(oFornecedor:TFornecedor):Boolean;
    function InserirFornecedor(oFornecedor:TFornecedor):Boolean;
    function ExcluirFornecedor(oFornecedor:TFornecedor):Boolean;
    function PreencherGrid(sFornecedor:string;ds:TDataSource;tipo:TPesquisar):Boolean;

    function VerificaFornecedor(oFornecedor:TFornecedor):Boolean;
  end;

var
  dmFornecedor: TdmFornecedor;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmFornecedor }

function TdmFornecedor.AlterarFornecedor(oFornecedor: TFornecedor): Boolean;
begin
with qrFornecedorAlterar,oFornecedor do
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
  ParamByName('IE').AsString:=IE;
  ParamByName('IM').AsString:=IM;
  ParamByName('OBSERVACAO').AsString:=Observacao;

  ExecSQL;
end;
end;

function TdmFornecedor.CarregarFornecedor(oFornecedor: TFornecedor): Boolean;
begin
with qrFornecedorPesquisar,oFornecedor do
begin
  close;
  sql.clear;
  sql.add('SELECT * FROM Fornecedor WHERE CODIGO = :CODIGO');
  ParamByName('CODIGO').asstring := oFornecedor.Codigo;
    try
      qrFornecedorPesquisar.Open;
      if qrFornecedorPesquisar.RecordCount > 0 then
      begin
      Codigo := qrFornecedorPesquisar.FieldByName('CODIGO').AsString;
      Endereco.Endereco := qrFornecedorPesquisar.FieldByName('ENDERECO').AsString;
      Endereco.Numero := qrFornecedorPesquisar.FieldByName('NUMERO').AsString;
      Endereco.Bairro := qrFornecedorPesquisar.FieldByName('BAIRRO').AsString;
      Endereco.Cidade := qrFornecedorPesquisar.FieldByName('CIDADE').AsString;
      Endereco.UF := qrFornecedorPesquisar.FieldByName('UF').AsString;
      Endereco.CEP := qrFornecedorPesquisar.FieldByName('CEP').AsString;
      Endereco.Complemento := qrFornecedorPesquisar.FieldByName('COMPLEMENTO').AsString;
      Pessoa.Nome := qrFornecedorPesquisar.FieldByName('NOME').AsString;
      Pessoa.Apelido := qrFornecedorPesquisar.FieldByName('NOME_FANTASIA').AsString;
      Pessoa.CPFCNPJ := qrFornecedorPesquisar.FieldByName('CNPJCPF').AsString;
      Pessoa.Telefone1 := qrFornecedorPesquisar.FieldByName('TELEFONE1').AsString;
      Pessoa.Telefone2 := qrFornecedorPesquisar.FieldByName('TELEFONE2').AsString;
      Pessoa.Celular1 := qrFornecedorPesquisar.FieldByName('CELULAR').AsString;
      Pessoa.Email := qrFornecedorPesquisar.FieldByName('EMAIL').AsString;
      IE := qrFornecedorPesquisar.FieldByName('IE').AsString;
      IM := qrFornecedorPesquisar.FieldByName('IM').AsString;
      Observacao := qrFornecedorPesquisar.FieldByName('OBSERVACAO').AsString;

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
          raise Exception.Create('Erro ao carregar Fornecedor ' + E.Message);
          Result := False;
      end;

    end;
end;
end;

function TdmFornecedor.ExcluirFornecedor(oFornecedor: TFornecedor): Boolean;
begin
 with qrFornecedorExcluir do
begin
  ParamByName('CODIGO').AsString := oFornecedor.Codigo;
  ExecSQL;
end;
end;

function TdmFornecedor.InserirFornecedor(oFornecedor: TFornecedor): Boolean;
begin
 with qrFornecedorInserir,oFornecedor do
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
  ParamByName('IE').AsString:=IE;
  ParamByName('IM').AsString:=IM;
  ParamByName('OBSERVACAO').AsString:=Observacao;
  ExecSQL;
end;
end;
function TdmFornecedor.PreencherGrid(sFornecedor:string;ds:TDataSource;tipo:TPesquisar):Boolean;
begin
with qrGridFornecedor do
begin
ds.DataSet := qrGridFornecedor;
sFornecedor := StringReplace(sFornecedor,Chr(39),'',[rfReplaceAll,rfIgnoreCase]);
Close;
SQL.Clear;
SQL.Add('SELECT * FROM Fornecedor');

   if sFornecedor = EmptyStr then
   begin
      SQL.Add('WHERE NOME LIKE '+Chr(39)+'%%%'+Chr(39));
      SQL.Add('ORDER BY 1');
   end
   else
   begin

    if tipo = nome then
    begin

      SQL.Add('WHERE NOME LIKE '+Chr(39)+'%'+sFornecedor+'%'+Chr(39));
      SQL.Add('ORDER BY NOME');

    end
    else
    if tipo = codigo then
    begin
      SQL.Add('WHERE CNPJCPF LIKE '+Chr(39)+sFornecedor+'%'+Chr(39));
      SQL.Add('ORDER BY CNPJCPF');
    end;


   end;

Open;


end;
end;

function TdmFornecedor.VerificaFornecedor(oFornecedor: TFornecedor): Boolean;
begin
with qrFornecedorPesquisar do
begin
  Close;
  SQL.Clear;
  SQL.add('SELECT * FROM FORNECEDOR WHERE CNPJCPF = :CNPJCPF');
  ParamByName('CNPJCPF').AsString := oFornecedor.Pessoa.CPFCNPJ;
  Open;
  if qrFornecedorPesquisar.RecordCount > 0 then
  begin
    oFornecedor.codigo := FieldByName('CODIGO').AsString;
    CarregarFornecedor(oFornecedor);
    Result := True;
  end
  else
  begin
    result := false;
  end;
end;
end;

end.
