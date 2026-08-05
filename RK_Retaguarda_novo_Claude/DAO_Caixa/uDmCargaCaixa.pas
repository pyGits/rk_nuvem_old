unit uDmCargaCaixa;

interface

uses
  System.SysUtils, System.Classes, Data.DB, MemDS, DBAccess, Uni,Classe.Caixa,uDmConexaoCaixa,Classe.Produto,  Classe.Tributacao,Classe.Cliente,Classe.Funcionario,Classe.Finalizadora,Classe.Proprio,Classe.AcessoPDV,Classe.ConfiguracoesPDV,IdIcmpClient;

type
  TdmCargaCaixa = class(TDataModule)
    qrProdutoInserir: TUniQuery;
    qrTributacaoInserir: TUniQuery;
    qrClienteInserir: TUniQuery;
    qrFuncionarioInserir: TUniQuery;
    qrFinalizadoraInserir: TUniQuery;
    qrProprioInserir: TUniQuery;
    qrNivelAcessoInserir: TUniQuery;
    qrProdutoDeletar: TUniQuery;
    qrDeletar: TUniQuery;
    qrConfiguracoesPDV: TUniQuery;
  private
    { Private declarations }
  public
    function HostDisponivel(const AIP: string; TimeoutMs: Integer = 1000): Boolean;
    function ConfigurarConexaoPDV(oCaixa:TCaixa):Boolean;
    function EnviaProduto(oProduto:TProduto):boolean;
    function EnviaCliente(oCliente:TCliente):Boolean;
    function EnviaFuncionario(oFuncionario:TFuncionario):boolean;
    function EnviaTributacao(oTributacao:TTributacao):boolean;
    function EnviaFinalizadora(oFinalizadora:TFinalizadora):boolean;
    function EnviaProprio(oProprio:TProprio):Boolean;
    function EnviaAcessoPDV(oAcessoPDV:TAcessoPDV):boolean;
    function EnviaConfigPDV(oConfigPDV:TConfiguracoesPDV):boolean;


    function EnviaExclusao(tabela,codigo:string):boolean;
  end;

var
  dmCargaCaixa: TdmCargaCaixa;

implementation
  uses Classe.Funcoes;


{$R *.dfm}

{ TdmCargaCaixa }

function TdmCargaCaixa.ConfigurarConexaoPDV(oCaixa: TCaixa): Boolean;
begin
try
  dmConexaoCaixa.conexaoCaixa.Disconnect;
  dmConexaoCaixa.conexaoCaixa.Server := oCaixa.IP;
  dmConexaoCaixa.conexaoCaixa.Database := 'C:\System_rk\PDV\BD\SAT_DATPDV.FDB';
  dmConexaoCaixa.conexaoCaixa.Port := 3050;
  dmConexaoCaixa.conexaoCaixa.Username := 'SYSDBA';
  dmConexaoCaixa.conexaoCaixa.Password := 'masterkey';
  dmConexaoCaixa.conexaoCaixa.Connect;
except
  result := false;
end;
end;



function TdmCargaCaixa.EnviaAcessoPDV(oAcessoPDV: TAcessoPDV): boolean;
begin
  with qrNivelAcessoInserir, oAcessoPDV do
  begin
    ParamByName('CODIGO').AsString := Codigo;
    ParamByName('ACFUNC').AsString := CodigoFuncao;
//    ParamByName('FUNCDESC').AsString := Descricao;
//    ParamByName('FUNCCAT').AsString := Categoria;
    ParamByName('FUNCNIV').AsString := FuncaoNivel;
    ParamByName('FUNCSOLIC').AsString := funcaoSolicitaSenha;
     try
       ExecSQL();
       Result := True;
     except
       on E : Exception do
       begin
        raise Exception.Create(E.Message);
        Result := false;
       end;

     end;

  end;
end;

function TdmCargaCaixa.EnviaCliente(oCliente: TCliente): Boolean;
begin
    with qrClienteInserir, oCliente do begin
     Params.ParamByName('CODIGO').AsString := Codigo;
     Params.ParamByName('NOME').AsString := Pessoa.Nome;
     Params.ParamByName('CPF').AsString := Pessoa.CPFCNPJ;
     Params.ParamByName('ENDERECO').AsString := Endereco.Endereco;
     Params.ParamByName('COMPLEMENTO').AsString := Endereco.Complemento;
     Params.ParamByName('BAIRRO').AsString := Endereco.Bairro;
     Params.ParamByName('CIDADE').AsString := Endereco.Cidade;
     Params.ParamByName('UF').AsString := Endereco.UF;
     Params.ParamByName('CEP').AsString := Endereco.CEP;
     Params.ParamByName('OBS').AsString := observacao;
     Params.ParamByName('LIMITE').AsFloat := LimiteCredito;
     Params.ParamByName('UTILIZA_PRECO2').AsInteger := Ord(UtilizaPreco2);
     Params.ParamByName('PERC_DESCONTO').AsFloat := PercDesconto;

     try
       ExecSQL();
       Result := True;
     except
       on E : Exception do
       begin
        raise Exception.Create(E.Message);
        Result := false;
       end;

     end;


    end;
end;

function TdmCargaCaixa.EnviaConfigPDV(oConfigPDV: TConfiguracoesPDV): boolean;
begin
with qrConfiguracoesPDV do
begin
  ParamByName('LIMITE_DESCONTO_PERC').AsFloat := oConfigPDV.limite_desconto_perc;
  ExecSQL;
end;
end;

function TdmCargaCaixa.EnviaExclusao(tabela, codigo: string): boolean;
begin
with qrDeletar do
begin
  if tabela = 'PRODUTO' then
  begin
  Close;
  SQL.Clear;
  SQL.Add('DELETE FROM ESTOQUE WHERE CODIGO = :CODIGO');
  ParamByName('CODIGO').AsString := removeZeroEsquerda(codigo);
  ExecSQL;
  end;
end;
end;

function TdmCargaCaixa.EnviaFinalizadora(oFinalizadora: TFinalizadora): boolean;
begin
with qrFinalizadoraInserir,oFinalizadora do
begin
     Params.ParamByName('FZCOD').AsString := codigo;
     Params.ParamByName('FZDES').AsString := descricao;
     Params.ParamByName('FZESPECIE').AsInteger := especie;
     Params.ParamByName('FZTIPO').AsString := Tipo;
     Params.ParamByName('FZCOD99').AsInteger := cod99;
     ExecSQL;
end;
end;

function TdmCargaCaixa.EnviaFuncionario(oFuncionario: TFuncionario): boolean;
begin
with qrFuncionarioInserir,oFuncionario do
begin
     Params.ParamByName('CODIGO').AsString := Codigo;
     Params.ParamByName('INFO1').AsString := Pessoa.Nome;
     Params.ParamByName('INFO2').AsString := senha;
     Params.ParamByName('FUNCNIV').AsInteger := CARGO;
     ExecSQL;
end;
end;

function TdmCargaCaixa.EnviaProduto(oProduto: TProduto): boolean;
begin
    // ANTES DELETAR
    with qrProdutoDeletar,oProduto do
    begin
      Params.ParamByName('CODIGO').AsString := codigo;
      ExecSQL;
    end;

    with qrProdutoInserir, oProduto do begin
     Params.ParamByName('CODIGO').AsString := Codigo;
     Params.ParamByName('COD_BARRA').AsString := CodigoBarras;
     Params.ParamByName('NOME').AsString := Descricao;
     Params.ParamByName('Tributacao').AsString := Tributacao;
     Params.ParamByName('NCM').AsString := NCM;
     Params.ParamByName('CEST').AsString := CEST;
     Params.ParamByName('USA_BALANCA').AsInteger := getFracionado;
     Params.ParamByName('SITUACAO').AsInteger := getInativo;
     Params.ParamByName('PRECO_VARIAVEL').AsInteger := getDiversos;
     Params.ParamByName('CUSTO').AsFloat := Custo;
     Params.ParamByName('PRECO_VENDA').AsFloat := Preco;
     Params.ParamByName('ESTOQUE').AsFloat := Estoque;
     Params.ParamByName('Unidade').AsString := Unidade;
     Params.ParamByName('IAT').AsString := 'T';
     Params.ParamByName('IPPT').AsString := 'T';
     Params.ParamByName('OBSERVACAO').AsString := Observacao;
     try
       ExecSQL();
       Result := True;
     except
       on E : Exception do
       begin
        raise Exception.Create(E.Message);
        Result := false;
       end;

     end;


    end;
end;

function TdmCargaCaixa.EnviaProprio(oProprio: TProprio): Boolean;
begin
 with qrProprioInserir,oProprio do
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
  ParamByName('FANTASIA').AsString:=Pessoa.Apelido;
  ParamByName('CNPJ').AsString:=Pessoa.CPFCNPJ;
  ParamByName('TELEFONE').AsString:=Pessoa.Telefone1;
  ParamByName('IBGE').AsString:=IBGE;

  ParamByName('CELULAR').AsString:=Pessoa.Celular1;
  ParamByName('EMAIL').AsString:=Pessoa.Email;
  ParamByName('IE').AsString:=IE;
  ExecSQL;
end;
end;

function TdmCargaCaixa.EnviaTributacao(oTributacao: TTributacao): boolean;
begin
  with qrTributacaoInserir,oTributacao do
  begin
     Params.ParamByName('CODIGO').AsString := Codigo;
     Params.ParamByName('DESCRICAO').AsString := Tributacao;
     Params.ParamByName('CST').AsString := CST;
     Params.ParamByName('CFOP').AsString := CFOP;
     Params.ParamByName('CSOSN').AsString := CSOSN;
     Params.ParamByName('ST').AsString := ST;
     Params.ParamByName('ICMS').AsFloat := ICMS;
     ExecSQL;
  end;
end;

function TdmCargaCaixa.HostDisponivel(const AIP: string;
  TimeoutMs: Integer): Boolean;
var
  Ping: TIdIcmpClient;
begin
//  result := true;
  Result := False;
  Ping := TIdIcmpClient.Create(nil);
  try
    Ping.Host := AIP;
    Ping.ReceiveTimeout := TimeoutMs; // tempo m�ximo para aguardar resposta
    Ping.Ping;
    Result := Ping.ReplyStatus.ReplyStatusType = rsEcho;
  except
    // ignora erros
  end;
  Ping.Free;
end;

end.
