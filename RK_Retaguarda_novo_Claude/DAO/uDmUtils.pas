unit uDmUtils;

interface

uses
  System.SysUtils, System.Classes, Data.DB, MemDS, DBAccess, Uni,uDmConexao,vcl.stdctrls,Classe.Configuracoes,Classe.Funcoes,Vcl.ComCtrls,uDmCaixaAcesso;

type
  TdmUtils = class(TDataModule)
    qrUtilsPesq: TUniQuery;
    qrUtilsInserir: TUniQuery;
    qrUtilsGridIBGE: TUniQuery;
    qrZerarBD: TUniQuery;
  private
    { Private declarations }
  public
      // CONFIGURACOES BD
      function GravarConfiguracoesBD(oConfiguracoes:TConfiguracoes):Boolean;
      function CarregarConfiguracoesBD(oConfiguracoes:TConfiguracoes):Boolean;
      function ZerarBancoDeDados:boolean;

      // SEQUENCIAL
      function RetornaSequencial(Tabela:string;Coluna:string):string;
      function RetornaSequencialFin(Tabela:string;Coluna:string;cupom:string):string;
      function ExisteCadastro(Tabela:string;Coluna:string;Valor:string):boolean;
      // CIDADE
      function PreencheUF(cbUF:TComboBox):Boolean;
      function PreencheCidade(cidade:string;cbCidade:TComboBox):Boolean;

      // PENDENTE CARGA
      function InserirCarga(tabela:string;codigo:string):boolean;

      function PreencherGridIBGE(sIBGE:string;ds:TDatasource):boolean;


      // ETIQUETA

      function carregarEtiquetaLista(cmbEtiqueta:TComboBox):Boolean;
      function carregarEtiqueta(etiqueta:array of string):TArray<string>;
      function DAOEtiqueta(tipo:string;etiqueta:array  of string):boolean;



  end;

var
  dmUtils: TdmUtils;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmUtils }





function TdmUtils.CarregarConfiguracoesBD(
  oConfiguracoes: TConfiguracoes): Boolean;
begin
with qrUtilsPesq do
begin
  CLose;
  SQL.Clear;
  SQL.add('SELECT * FROM CONFIGURACOES WHERE ID ='+Chr(39)+'000001'+Chr(39));
  Open;
  with oConfiguracoes do
  begin
    Produto.UtilizarCargaAutomatica := IntToBool(FieldByName('PROD_CARGA_AUTO').AsInteger);
    Etiqueta.VisualizarImpressao := IntToBool(FieldByName('ETQ_VISUALIZAR').AsInteger);
    Etiqueta.Impressora := FieldByName('ETQ_IMPRESSORA').AsString;
    Balanca.DiretorioBalanca := FieldByName('BAL_DIRETORIO').AsString;
    Validade.alertaDias := FieldByName('VALIDADE_DIAS_ALERTA').AsInteger;
    terminalNumero := FieldByName('PREVENDA_TERMINAL').AsString;
    Balanca.QtdDigitos := FieldByName('BAL_DIGITOS').AsInteger;
    impressora_porta := FieldByName('IMPRESSORA_PORTA').AsString;


  oConfiguracoes.NFCE.idToken:=   FieldByName('NFCE_IDTOKEN').AsString;
  oConfiguracoes.nfce.token := FieldByName('NFCE_TOKEN').AsString;
  oConfiguracoes.nfce.diretorio := FieldByName('NFCE_DIRETORIO').AsString;
  oConfiguracoes.NFCe.senha:=  FieldByName('NFCE_SENHA').AsString;

  oConfiguracoes.ETIQUETA_MODO_IMPORTACAO := FieldByName('ETIQUETA_MODO_IMPORTACAO').asinteger;
  oConfiguracoes.SYSPDV_IP := FieldByName('SYSPDV_IP').AsString
  end;
end;
end;


function TdmUtils.carregarEtiqueta(etiqueta: array of string): TArray<string>;
begin
with qrUtilsPesq do
begin
  if etiqueta[0] <> '' then
  begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM ETIQUETA_LAYOUT WHERE CODIGO = :CODIGO');
  ParamByName('CODIGO').AsString := etiqueta[0];



  Open;

  if qrUtilsPesq.RecordCount > 0  then
  begin
//    etiqueta[1] := qrUtilsPesq.FieldByName('NOME').AsString;
//    etiqueta[2] := qrUtilsPesq.FieldByName('ARQUIVO').AsString;
    SetLength(Result,3);
    result[0] := qrUtilsPesq.FieldByName('CODIGO').AsString;
    result[1] := qrUtilsPesq.FieldByName('NOME').AsString;
    result[2] := qrUtilsPesq.FieldByName('ARQUIVO').AsString;
  end;
  end
  else
  begin

  end;

end;
end;

function TdmUtils.carregarEtiquetaLista(cmbEtiqueta: TComboBox): Boolean;
begin
with qrUtilsPesq do
begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM ETIQUETA_LAYOUT ORDER BY 1');
  Open;

  cmbEtiqueta.Items.Clear;
  if qrUtilsPesq.RecordCount > 0 then
  begin
  while not qrUtilsPesq.Eof do
  begin
  cmbEtiqueta.Items.Add(qrUtilsPesq.FieldByName('CODIGO').AsString + ' - ' + qrUtilsPesq.FieldByName('NOME').AsString);
  qrUtilsPesq.Next;
  end;
  end;
end;


end;

function TdmUtils.DAOEtiqueta(tipo: string;etiqueta:array of string): boolean;
begin
    Result := false;


if tipo = 'EXCLUIR' then
begin
  if etiqueta[0] <> '' then
  begin
    with qrUtilsPesq do
    begin
      CLose;
      SQL.Clear;
      SQL.Add('DELETE FROM ETIQUETA_LAYOUT WHERE CODIGO = :CODIGO');
      ParamByName('CODIGO').AsString := etiqueta[0];
      ExecSQL;

      Result := true;
    end;
  end;
end;

if tipo = 'INSERIR' then
begin
  with qrUtilsPesq do
  begin
    CLose;
    SQL.Clear;
    SQL.Add('INSERT INTO ETIQUETA_LAYOUT (NOME,ARQUIVO) VALUES(:NOME,:ARQUIVO)');
    ParamByName('NOME').AsString := etiqueta[1];
    ParamByName('ARQUIVO').AsString := etiqueta[2];

    ExecSQL;
  end;
end;
end;

function TdmUtils.ExisteCadastro(Tabela, Coluna, Valor: string): boolean;
begin
 with qrUtilsPesq do
begin
  Close;
  SQL.Clear;
  SQL.Add('select * from '+tabela+' where '+coluna+ ' = :VALOR');
  ParamByName('VALOR').AsString := Valor;
  Open;
  if qrUtilsPesq.RecordCount > 0 then
  begin
    Result := true;
  end
  else
  begin
    Result := false;
  end;

end;
end;

function TdmUtils.GravarConfiguracoesBD(
  oConfiguracoes: TConfiguracoes): Boolean;
begin
with qrUtilsInserir do
begin
  Close;
  SQL.Clear;
  SQL.Add('UPDATE OR INSERT INTO CONFIGURACOES');
  SQL.Add('(' +
          'ID, PROD_CARGA_AUTO, ETQ_VISUALIZAR, ETQ_IMPRESSORA, ' +
          'BAL_DIRETORIO, PREVENDA_TERMINAL, VALIDADE_DIAS_ALERTA, BAL_DIGITOS, ' +
          'IMPRESSORA_PORTA, PDV_LIMITE_DESCONTO_PERC, NFCE_IDTOKEN, NFCE_TOKEN, ' +
          'NFCE_DIRETORIO, NFCE_SENHA, ETIQUETA_MODO_IMPORTACAO, SYSPDV_IP' +
          ')');
  SQL.Add('VALUES (' +
          ':ID, :PROD_CARGA_AUTO, :ETQ_VISUALIZAR, :ETQ_IMPRESSORA, ' +
          ':BAL_DIRETORIO, :PREVENDA_TERMINAL, :VALIDADE_DIAS_ALERTA, :BAL_DIGITOS, ' +
          ':IMPRESSORA_PORTA, :PDV_LIMITE_DESCONTO_PERC, :NFCE_IDTOKEN, :NFCE_TOKEN, ' +
          ':NFCE_DIRETORIO, :NFCE_SENHA, :ETIQUETA_MODO_IMPORTACAO, :SYSPDV_IP' +
          ')');

  ParamByName('PROD_CARGA_AUTO').AsInteger := BoolToInt(oConfiguracoes.Produto.UtilizarCargaAutomatica);
  ParamByName('ETQ_VISUALIZAR').AsInteger := BoolToInt(oConfiguracoes.Etiqueta.VisualizarImpressao);
  ParamByName('ETQ_IMPRESSORA').asString := oConfiguracoes.Etiqueta.Impressora;
  ParamByName('BAL_DIRETORIO').asString := oConfiguracoes.Balanca.DiretorioBalanca;
  ParamByName('PREVENDA_TERMINAL').AsString := oConfiguracoes.terminalNumero;
  ParamByName('VALIDADE_DIAS_ALERTA').AsInteger := oConfiguracoes.Validade.alertaDias;
  ParamByName('BAL_DIGITOS').AsInteger := oConfiguracoes.Balanca.QtdDigitos;
  ParamByName('IMPRESSORA_PORTA').AsString := oConfiguracoes.impressora_porta;
  ParamByName('PDV_LIMITE_DESCONTO_PERC').AsFloat := oConfiguracoes.PDV_Limite_Desconto_Perc;

  ParamByName('NFCE_IDTOKEN').AsString := oConfiguracoes.NFCE.idToken;
  ParamByName('NFCE_TOKEN').AsString := oConfiguracoes.nfce.token;
  ParamByName('NFCE_DIRETORIO').AsString := oConfiguracoes.nfce.diretorio;
  ParamByName('NFCE_SENHA').AsString := oConfiguracoes.NFCe.senha;

  ParamByName('ETIQUETA_MODO_IMPORTACAO').AsInteger := oConfiguracoes.ETIQUETA_MODO_IMPORTACAO;
  ParamByName('SYSPDV_IP').AsString := oConfiguracoes.SYSPDV_IP;

  ParamByName('ID').asString := '000001';

  ExecSQL;
end;
end;

function TdmUtils.InserirCarga(tabela, codigo: string): boolean;
begin
with qrUtilsInserir do
begin
  Close;
  SQL.Clear;
  SQL.Add('UPDATE OR INSERT INTO CARGA(tabela,codigo) values (:TABELA,:CODIGO)');
  ParamByName('TABELA').AsString := tabela;
  ParamByName('CODIGO').asString := codigo;
  ExecSQL;
end;
end;

function TdmUtils.PreencheCidade(cidade:string;cbCidade: TComboBox): Boolean;
begin
with qrUtilsPesq do
begin
  cbCidade.Items.Clear;
  close;
  sql.clear;
  SQL.add('select * from ibge where CODIBGEUF = :CIDADE');
  ParamByName('CIDADE').AsString := cidade;
  Open;
  while not qrUtilsPesq.Eof do
  begin
    cbCidade.Items.Add(FieldByName('CODIBGECID').AsString);
    qrUtilsPesq.Next;
  end;
end;
end;

function TdmUtils.PreencherGridIBGE(sIBGE: string; ds: TDatasource): boolean;
begin
with qrUtilsGridIBGE do
begin
  ds.DataSet := qrUtilsGridIBGE;
  sIBGE := StringReplace(sIBGE,Chr(39),'',[rfReplaceAll,rfIgnoreCase]);
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM IBGE');

   if sIBGE = EmptyStr then
   begin
      SQL.Add('WHERE CODIBGECID LIKE '+Chr(39)+'%%%'+Chr(39));
      SQL.Add('ORDER BY 1');
   end
   else
   begin

      SQL.Add('WHERE CODIBGECID LIKE '+Chr(39)+'%'+sIbge+'%'+Chr(39));
      SQL.Add('ORDER BY 2');


   end;
Open;

end;
end;

function TdmUtils.PreencheUF(cbUF: TComboBox): Boolean;
begin
with qrUtilsPesq do
begin
  cbUF.Items.Clear;
  close;
  sql.clear;
  SQL.add('select distinct codibgeuf from ibge');
  Open;
  while not qrUtilsPesq.Eof do
  begin
    cbUF.Items.Add(FieldByName('CODIBGEUF').AsString);
    qrUtilsPesq.Next;
  end;
end;
end;

function TdmUtils.RetornaSequencial(Tabela, Coluna: string): string;
begin
with qrUtilsPesq do
begin
  Close;
  SQL.Clear;
  SQL.Add('select max(cast('+Coluna+' as float) + 1) from '+Tabela);
  Open;
  First;
  if FieldByName('max').asstring <> '' then
  begin
  Result := FieldByName('max').asstring;
  end
  else
  begin
    result := '1';
  end;

end;
end;



function TdmUtils.RetornaSequencialFin(Tabela, Coluna, cupom: string): string;
begin
with qrUtilsPesq do
begin
  Close;
  SQL.Clear;
  SQL.Add('select max(cast('+Coluna+' as float) + 1) from '+Tabela+' where cod_cupom = :cod_cupom');
  ParamByName('cod_cupom').AsString := cupom;
  Open;
  First;
  if FieldByName('max').asstring <> '' then
  begin
  Result := FieldByName('max').asstring;
  end
  else
  begin
    result := '1';
  end;

end;
end;

function TdmUtils.ZerarBancoDeDados: boolean;
begin
with qrZerarBD do
begin
try
  Close;
  SQL.Clear;
  SQl.Add('DELETE FROM CUPOM');
  ExecSQL;

  Close;
  SQL.Clear;
  SQl.Add('DELETE FROM CUPOM_ITEM');
  ExecSQL;

  Close;
  SQL.Clear;
  SQl.Add('DELETE FROM CUPOM_FORMA');
  ExecSQL;

    Close;
  SQL.Clear;
  SQl.Add('DELETE FROM FECHAMENTO');
  ExecSQL;
      Close;
  SQL.Clear;
  SQl.Add('DELETE FROM FECHAMENTO_FINALIZADORA');
  ExecSQL;

      Close;
  SQL.Clear;
  SQl.Add('DELETE FROM AUDITORIA');
  ExecSQL;

      Close;
  SQL.Clear;
  SQl.Add('DELETE FROM CONTAS_RECEBER');
  ExecSQL;

      Close;
  SQL.Clear;
  SQl.Add('DELETE FROM CONTAS_RECEBER_PAGAMENTO');
  ExecSQL;

      Close;
  SQL.Clear;
  SQl.Add('DELETE FROM ESTOQUE_MOVIMENTACAO');
  ExecSQL;

   Close;
  SQL.Clear;
  SQl.Add('DELETE FROM FINALIZADORA');
  ExecSQL;

  Close;
  SQL.Clear;
  SQl.Add('DELETE FROM FORNECEDOR WHERE CODIGO <> :CODIGO');
  ParamByName('CODIGO').AsString := '000000';
  ExecSQL;

      Close;
  SQL.Clear;
  SQl.Add('DELETE FROM FUNCIONARIO where CODIGO <> :CODIGO');
      ParamByName('CODIGO').AsString := '000001';
  ExecSQL;

      Close;
  SQL.Clear;
  SQl.Add('DELETE FROM GRUPO WHERE CODIGO <> :CODIGO');
    ParamByName('CODIGO').AsString := '000000';
  ExecSQL;


      Close;
  SQL.Clear;
  SQl.Add('DELETE FROM PREVENDA');
  ExecSQL;

      Close;
  SQL.Clear;
  SQl.Add('DELETE FROM PREVENDA_ITEM');
  ExecSQL;


      Close;
  SQL.Clear;
  SQl.Add('DELETE FROM PRODUTO');
  ExecSQL;

      Close;
  SQL.Clear;
  SQl.Add('DELETE FROM SUBGRUPO WHERE CODIGO <> :CODIGO');
    ParamByName('CODIGO').AsString := '000000';
  ExecSQL;

      Close;
  SQL.Clear;
  SQl.Add('DELETE FROM TRIBUTACAO');
  ExecSQL;

        Close;
  SQL.Clear;
  SQl.Add('DELETE FROM CLIENTE WHERE CODIGO <> :CODIGO');
  ParamByName('CODIGO').asstring := '000001';
  ExecSQL;
except
on E:Exception do
begin
  raise Exception.Create('Erro ao zerar banco de dados: '+ E.Message);
end;

end;
end;
end;

end.
