unit uDmContasReceber;

interface

uses
  System.SysUtils, System.Classes,uDmConexao, Data.DB, MemDS, DBAccess, Uni,Conversao,Vcl.Forms,VCL.Dialogs,ContasReceber,System.Generics.Collections,ContasReceberList;

type
  TdmContasReceber = class(TDataModule)
    qrContasReceberGrid: TUniQuery;
    qrCupomContasReceber: TUniQuery;
    qrContasReceberGridNUMERO: TStringField;
    qrClienteContasReceber: TUniQuery;
    qrContasReceberGridCODIGO: TStringField;
    qrContasReceberGridCOD_CUPOM: TStringField;
    qrContasReceberGridCOD_VENDEDOR: TIntegerField;
    qrContasReceberGridCOD_CAIXA: TIntegerField;
    qrContasReceberGridDATA_EMISSAO: TDateField;
    qrContasReceberGridDATA_VENCIMENTO: TDateField;
    qrContasReceberGridDATA_PAGAMENTO: TDateField;
    qrContasReceberGridVALOR: TFloatField;
    qrContasReceberGridVALOR_PAGO: TFloatField;
    qrContasReceberGridVALOR_DESCONTO: TFloatField;
    qrContasReceberGridVALOR_ACRESCIMO: TFloatField;
    qrContasReceberGridVALOR_RESTANTE: TFloatField;
    qrContasReceberGridCLIENTE: TStringField;
    qrClienteContasReceberCODIGO: TStringField;
    qrClienteContasReceberNOME: TStringField;
    qrClienteContasReceberNOME_FANTASIA: TStringField;
    qrClienteContasReceberENDERECO: TStringField;
    qrClienteContasReceberNUMERO: TStringField;
    qrClienteContasReceberBAIRRO: TStringField;
    qrClienteContasReceberCIDADE: TStringField;
    qrClienteContasReceberUF: TStringField;
    qrClienteContasReceberCEP: TStringField;
    qrClienteContasReceberCOMPLEMENTO: TStringField;
    qrClienteContasReceberTELEFONE1: TStringField;
    qrClienteContasReceberTELEFONE2: TStringField;
    qrClienteContasReceberCELULAR: TStringField;
    qrClienteContasReceberEMAIL: TStringField;
    qrClienteContasReceberCNPJCPF: TStringField;
    qrClienteContasReceberOBSERVACAO: TMemoField;
    qrClienteContasReceberDATA_CADASTRO: TDateField;
    qrClienteContasReceberTIPO_PESSOA: TIntegerField;
    qrClienteContasReceberCREDITO_LIMITE: TFloatField;
    qrClienteContasReceberCREDITO_UTILIZADO: TFloatField;
    qrContasReceberGridCOD_CLIENTE: TStringField;
    qrProdutosGrid: TUniQuery;
    qrProduto: TUniQuery;
    qrProdutoCODIGO: TStringField;
    qrProdutoCODIGO_BARRAS: TStringField;
    qrProdutoDESCRICAO: TStringField;
    qrProdutoGRUPO: TStringField;
    qrProdutoSUBGRUPO: TStringField;
    qrProdutoFORNECEDOR: TStringField;
    qrProdutoTRIBUTACAO: TStringField;
    qrProdutoNCM: TStringField;
    qrProdutoCEST: TStringField;
    qrProdutoVALIDADE: TStringField;
    qrProdutoBALANCA: TIntegerField;
    qrProdutoFRACIONADO: TIntegerField;
    qrProdutoCUSTO: TFloatField;
    qrProdutoPRECO: TFloatField;
    qrProdutoMARGEM: TFloatField;
    qrProdutoESTOQUE: TFloatField;
    qrProdutoUNIDADE: TStringField;
    qrProdutoINATIVO: TIntegerField;
    qrProdutoDIVERSOS: TIntegerField;
    qrProdutoDATA_CADASTRO: TDateField;
    qrProdutoDATA_ALTERADO: TDateField;
    qrProdutoPENDENTE: TIntegerField;
    qrProdutoOBSERVACAO: TStringField;
    qrProdutosGridCODIGO: TStringField;
    qrProdutosGridCOD_CUPOM: TStringField;
    qrProdutosGridITEM: TIntegerField;
    qrProdutosGridUNIDADE: TStringField;
    qrProdutosGridQTDE: TFloatField;
    qrProdutosGridVALOR_UNITARIO: TFloatField;
    qrProdutosGridVALOR_DESCONTO: TFloatField;
    qrProdutosGridVALOR_ACRESCIMO: TFloatField;
    qrProdutosGridVALOR_TOTAL: TFloatField;
    qrProdutosGridCANCELADO: TIntegerField;
    qrProdutosGridEX: TIntegerField;
    qrProdutosGridDATA: TDateField;
    qrProdutosGridCOD_CAIXA: TIntegerField;
    qrProdutosGridCOD_PRODUTO: TStringField;
    qrProdutosGridPRODUTO: TStringField;
    qrContasReceberGridSELECAO: TIntegerField;
    qrContasReceberPesquisar: TUniQuery;
    qrContasReceberAtualizar: TUniQuery;
    qrContasReceberGridCANCELADO: TIntegerField;
    qrContasReceberGridSTATUS: TIntegerField;
    qrContasReceberPgto: TUniQuery;
    qrContasReceberPgtoGrid: TUniQuery;
    qrFinalizadora: TUniQuery;
    qrFinalizadoraCODIGO: TStringField;
    qrFinalizadoraDESCRICAO: TStringField;
    qrFinalizadoraESPECIE: TIntegerField;
    qrFinalizadoraTIPO: TStringField;
    qrFinalizadoraCODIGO99: TIntegerField;
    qrContasReceberPgtoGridCODIGO: TStringField;
    qrContasReceberPgtoGridCOD_CUPOM: TStringField;
    qrContasReceberPgtoGridDATA_PAGAMENTO: TDateTimeField;
    qrContasReceberPgtoGridFINALIZADORA: TStringField;
    qrContasReceberPgtoGridVALOR: TFloatField;
    qrContasReceberPgtoGridVALOR_DESCONTO: TFloatField;
    qrContasReceberPgtoGridVALOR_ACRESCIMO: TFloatField;
    qrContasReceberPgtoGridPRESTACAO: TIntegerField;
    qrContasReceberPgtoGridCOD_CAIXA: TIntegerField;
    qrContasReceberPgtoGridFUNCIONARIO: TStringField;
    qrContasReceberPgtoGridFZDES: TStringField;
    qrContasReceberExcluir: TUniQuery;
    qrContasReceberTotais: TUniQuery;
    procedure qrContasReceberGridSELECAOGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure qrContasReceberGridSTATUSGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
      // atualizar valor pago
      procedure AtualizarStatus;
  public
function PreencherGrid(
  ds: TDataSource;
  status: TContasReceberStatus;
  codigoCliente: string;
  out AVlr, AVlrPago, AVlrAPagar, AVlrDesconto: Extended
): Boolean;
      function preencherGridProduto(ds:TDataSource;venda:string):boolean;
      function preencherGridPagamento(ds:TDataSource;venda:string):boolean;
      // carrega total pendente para parte visual
      function CarregarValorTotalAReceber:Real;
      // lança pagamento fazendo rateio

      function AtualizarPagamento(contasReceberList:TContasReceberList):Boolean;


      function EstornarContas:boolean;
      function ExcluirContas:boolean;


      function ZerarSelecao(tipo:integer):boolean;


      // REFATORADO

      function CarregarContasSelecionadas:TContasReceberList;



  end;

var
  dmContasReceber: TdmContasReceber;

implementation
USES Classe.Variaveis,Classe.Funcoes;
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmContasReceber }

procedure TdmContasReceber.AtualizarStatus;
begin
  with qrContasReceberAtualizar do
  begin
       // DEBITADO
    Close;
    SQL.Clear;
    SQL.ADD('UPDATE CONTAS_RECEBER SET STATUS = 1 WHERE  VALOR_RESTANTE  <= 0');
    ExecSQL;

       // NÃO DEBITADO
    Close;
    SQL.Clear;
    SQL.ADD('UPDATE CONTAS_RECEBER SET STATUS = 0 WHERE  VALOR_RESTANTE  > 0');
    ExecSQL;
  end;

end;




function TdmContasReceber.CarregarContasSelecionadas: TContasReceberList;
var
  contas_receber:TContasReceber;
begin
with qrContasReceberPesquisar do
begin
  close;
  sql.clear;
  sql.add('select * from contas_receber where selecao = 1');
  open;

  result := TContasReceberList.Create;

  while not qrContasReceberPesquisar.eof do
  begin
    contas_receber := TContasReceber.Create;
    contas_receber.codigo := qrContasReceberPesquisar.FieldByName('CODIGO').AsString;
    contas_receber.cod_cupom := qrContasReceberPesquisar.FieldByName('COD_CUPOM').AsString;
    contas_receber.cod_vendedor := qrContasReceberPesquisar.FieldByName('COD_VENDEDOR').AsInteger;
    contas_receber.cod_caixa := qrContasReceberPesquisar.FieldByName('COD_CAIXA').AsInteger;
    contas_receber.cod_cliente := qrContasReceberPesquisar.FieldByName('COD_CLIENTE').AsString;
    contas_receber.data_emissao := qrContasReceberPesquisar.FieldByName('DATA_EMISSAO').AsDateTime;
    contas_receber.data_vencimento := qrContasReceberPesquisar.FieldByName('DATA_VENCIMENTO').AsDateTime;
    contas_receber.data_pagamento := qrContasReceberPesquisar.FieldByName('DATA_PAGAMENTO').AsDateTime;
    contas_receber.valor := qrContasReceberPesquisar.FieldByName('VALOR').AsFloat;
    contas_receber.valor_pago := qrContasReceberPesquisar.FieldByName('VALOR_PAGO').AsFloat;
    contas_receber.valor_desconto := qrContasReceberPesquisar.FieldByName('VALOR_DESCONTO').AsFloat;
    contas_receber.valor_acrescimo := qrContasReceberPesquisar.FieldByName('VALOR_ACRESCIMO').AsFloat;
    contas_receber.valor_restante := qrContasReceberPesquisar.FieldByName('VALOR_RESTANTE').AsFloat;
    contas_receber.cancelado := qrContasReceberPesquisar.FieldByName('CANCELADO').AsInteger;
    contas_receber.status := qrContasReceberPesquisar.FieldByName('STATUS').AsInteger;
    result.add(contas_receber);

    qrContasReceberPesquisar.next;
  end;
end;
end;

function TdmContasReceber.CarregarValorTotalAReceber: Real;
begin
with qrContasReceberPesquisar do
begin
  Close;
  SQL.Clear;
  SQL.add('SELECT SUM(VALOR_RESTANTE) AS VALOR_TOTAL FROM CONTAS_RECEBER WHERE CANCELADO = 0 AND SELECAO = 1');
  Open;
  if FieldByName('VALOR_TOTAL').AsFloat = 0  then
  begin
    raise Exception.Create('Não existem contas a receber');
  end;
  Result :=FieldByName('VALOR_TOTAL').AsFloat;
end;
end;

function TdmContasReceber.EstornarContas: boolean;
begin
  qrContasReceberPesquisar.Close;
  qrContasReceberPesquisar.SQL.Clear;
  qrContasReceberPesquisar.SQL.Add('SELECT * FROM CONTAS_RECEBER WHERE SELECAO = 1');
  qrContasReceberPesquisar.Open;

  while not qrContasReceberPesquisar.eof do
  begin
    with qrContasReceberAtualizar do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE CONTAS_RECEBER SET VALOR_PAGO = 0 , VALOR_DESCONTO = 0 ,VALOR_ACRESCIMO =0,VALOR_RESTANTE = VALOR WHERE CODIGO = :CODIGO');
      ParamByName('CODIGO').AsString := qrContasReceberPesquisar.FieldByName('CODIGO').AsString;
      ExecSQL;
      VariaveisSrv.oAuditoriaController.InserirAuditoria('CONTAS_RECEBER','ESTORNOU CONTA Nº'+qrContasReceberPesquisar.FieldByName('CODIGO').AsString,tpAlteracao);
    end;
    qrContasReceberPesquisar.Next;
  end;
    AtualizarStatus;
end;

function TdmContasReceber.ExcluirContas: boolean;
begin
  qrContasReceberPesquisar.Close;
  qrContasReceberPesquisar.SQL.Clear;
  qrContasReceberPesquisar.SQL.Add('SELECT * FROM CONTAS_RECEBER WHERE SELECAO = 1');
  qrContasReceberPesquisar.Open;

  while not qrContasReceberPesquisar.eof do
  begin
    with qrContasReceberExcluir do
    begin
      Close;
      SQL.Clear;
      SQL.Add('update CONTAS_RECEBER set cancelado = 1 WHERE CODIGO = :CODIGO');
      ParamByName('CODIGO').AsString := qrContasReceberPesquisar.FieldByName('CODIGO').AsString;
      ExecSQL;
      VariaveisSrv.oAuditoriaController.InserirAuditoria('CONTAS_RECEBER','CANCELADO CONTA Nº'+qrContasReceberPesquisar.FieldByName('CODIGO').AsString,tpExclusao);
    end;
    qrContasReceberPesquisar.Next;
  end;
    AtualizarStatus;
end;

function TdmContasReceber.AtualizarPagamento(contasReceberList:TContasReceberList): Boolean;
var
  ContasReceber:TContasReceber;
begin
  ZerarSelecao(1);
  for ContasReceber in contasReceberList.Items do
  begin
    qrContasReceberAtualizar.Close;
    qrContasReceberAtualizar.SQL.Clear;
    qrContasReceberAtualizar.SQL.Add('UPDATE CONTAS_RECEBER SET VALOR_PAGO =:VALOR_PAGO, VALOR_DESCONTO=:VALOR_DESCONTO, VALOR_ACRESCIMO=:VALOR_ACRESCIMO, VALOR_RESTANTE=:VALOR_RESTANTE WHERE CODIGO = :CODIGO');
    qrContasReceberAtualizar.ParamByName('VALOR_PAGO').AsFloat := ContasReceber.valor_pago;
    qrContasReceberAtualizar.ParamByName('VALOR_DESCONTO').AsFloat := ContasReceber.valor_desconto;
    qrContasReceberAtualizar.ParamByName('VALOR_ACRESCIMO').AsFloat := ContasReceber.valor_acrescimo;
    qrContasReceberAtualizar.ParamByName('VALOR_RESTANTE').AsFloat := ContasReceber.valor_restante;
    qrContasReceberAtualizar.ParamByName('CODIGO').AsString := ContasReceber.codigo;
    qrContasReceberAtualizar.ExecSQL;

  end;

end;


function TdmContasReceber.PreencherGrid(
  ds: TDataSource;
  status: TContasReceberStatus;
  codigoCliente: string;
  out AVlr, AVlrPago, AVlrAPagar, AVlrDesconto: Extended
): Boolean;
begin
  Result := False;

  // Zera totais
  AVlr         := 0;
  AVlrPago     := 0;
  AVlrAPagar   := 0;
  AVlrDesconto := 0;

  ds.DataSet := qrContasReceberGrid;

  // dependências
  qrCupomContasReceber.Close;
  qrCupomContasReceber.Open;

  qrClienteContasReceber.Close;
  qrClienteContasReceber.Open;

  ZerarSelecao(0);

  {======================
    QUERY DO GRID
  ======================}
  with qrContasReceberGrid do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM CONTAS_RECEBER');
    SQL.Add('WHERE CANCELADO = 0');

    case status of
      crAbertas:
        SQL.Add('AND VALOR_RESTANTE > 0');

      crRecebido:
        SQL.Add('AND VALOR_RESTANTE <= 0');

      crVencer:
        begin
          SQL.Add('AND VALOR_RESTANTE > 0');
          SQL.Add('AND DATA_VENCIMENTO < :DATAVENCIMENTO');
          ParamByName('DATAVENCIMENTO').AsDate := Date;
        end;

      crTodas:
        ; // sem filtro
    end;

    if codigoCliente <> '' then
    begin
      SQL.Add('AND COD_CLIENTE = :CODIGO_CLIENTE');
      ParamByName('CODIGO_CLIENTE').AsString := codigoCliente;
    end;

    Open;
  end;

  {======================
    QUERY DE TOTAIS (SUM)
  ======================}
  with qrContasReceberTotais do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT');
    SQL.Add('  COALESCE(SUM(VALOR), 0)           AS VLR_TOTAL,');
    SQL.Add('  COALESCE(SUM(VALOR_PAGO), 0)      AS VLR_PAGO,');
    SQL.Add('  COALESCE(SUM(VALOR_RESTANTE), 0)  AS VLR_APAGAR,');
    SQL.Add('  COALESCE(SUM(VALOR_DESCONTO), 0)  AS VLR_DESCONTO');
    SQL.Add('FROM CONTAS_RECEBER');
    SQL.Add('WHERE CANCELADO = 0');

    case status of
      crAbertas:
        SQL.Add('AND VALOR_RESTANTE > 0');

      crRecebido:
        SQL.Add('AND VALOR_RESTANTE <= 0');

      crVencer:
        begin
          SQL.Add('AND VALOR_RESTANTE > 0');
          SQL.Add('AND DATA_VENCIMENTO < :DATAVENCIMENTO');
          ParamByName('DATAVENCIMENTO').AsDate := Date;
        end;

      crTodas:
        ; // sem filtro
    end;

    if codigoCliente <> '' then
    begin
      SQL.Add('AND COD_CLIENTE = :CODIGO_CLIENTE');
      ParamByName('CODIGO_CLIENTE').AsString := codigoCliente;
    end;

    Open;

    AVlr         := FieldByName('VLR_TOTAL').AsFloat;
    AVlrPago     := FieldByName('VLR_PAGO').AsFloat;
    AVlrAPagar   := FieldByName('VLR_APAGAR').AsFloat;
    AVlrDesconto := FieldByName('VLR_DESCONTO').AsFloat;
  end;

  Result := True;
end;

function TdmContasReceber.preencherGridPagamento(ds: TDataSource;
  venda: string): boolean;
begin
ds.DataSet := qrContasReceberPgtoGrid;
qrContasReceberPgtoGrid.Close;
with qrContasReceberPgtoGrid do
begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM CONTAS_RECEBER_PAGAMENTO WHERE COD_CUPOM = :COD_CUPOM');
  ParamByName('COD_CUPOM').AsString := venda;
  Open;
end;
end;

function TdmContasReceber.preencherGridProduto(ds: TDataSource;
  venda: string): boolean;
begin
ds.DataSet := qrProdutosGrid;
qrProduto.Close;
qrProduto.Open;
with qrProdutosGrid do
begin
  Close;
  SQL.Clear;
  SQL.Add('SELECT * FROM CUPOM_ITEM WHERE COD_CUPOM = :COD_CUPOM');
  ParamByName('COD_CUPOM').AsString := venda;
  Open;
end;
end;

procedure TdmContasReceber.qrContasReceberGridSELECAOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
Text := EmptyStr;
end;

procedure TdmContasReceber.qrContasReceberGridSTATUSGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
Text := EmptyStr;
end;



function TdmContasReceber.ZerarSelecao(tipo:integer): boolean;
begin
if tipo = 0 then
begin
  // todos
  with qrContasReceberAtualizar do
  begin
    Close;
    SQL.Clear;
    SQL.add('UPDATE CONTAS_RECEBER SET SELECAO = 0 where selecao <> 0');
    ExecSQL;
  end;
end
else
if tipo = 1 then
begin
  // zera contas que não são a pagar
  with qrContasReceberAtualizar do
  begin
    Close;
    SQL.Clear;
    SQL.add('UPDATE CONTAS_RECEBER SET SELECAO = 0 where valor_restante = 0');
    ExecSQL;
  end;
end;


end;

end.
