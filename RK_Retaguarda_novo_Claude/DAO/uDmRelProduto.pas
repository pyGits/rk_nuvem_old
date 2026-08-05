unit uDmRelProduto;

interface

uses
  System.SysUtils, System.Classes,Classe.Relatorio,uDmProduto, frxClass,
  frxDBSet, Data.DB, MemDS, DBAccess, Uni,uDmConexao, vcl.gtxXport,
  vcl.gtFRXport, frxDMPExport, frxOLE,utils;



type
  TdmRelProduto = class(TDataModule)
    qrCupomProduto: TUniQuery;
    qrCupomProdutoCOD_PRODUTO: TStringField;
    qrCupomProdutoVALOR_ITEM: TFloatField;
    qrCupomProdutoVALOR_TOTAL: TFloatField;
    qrCupomProdutoPERC: TFloatField;
    qrCupomProdutoQTD_ITEM: TFloatField;
    DBCupomItem: TfrxDBDataset;
    fxrelatorio: TfrxReport;
    qrCupomProdutoCUSTO_ITEM: TFloatField;
    qrPerformanceProduto: TUniQuery;
    qrPerformanceProdutoCOD_PRODUTO: TStringField;
    qrPerformanceProdutoMes1: TFloatField;
    qrPerformanceProdutoMes2: TFloatField;
    qrPerformanceProdutoMes3: TFloatField;
    DBPerformanceProduto: TfrxDBDataset;
    qrPerformanceProdutoFat1: TFloatField;
    qrPerformanceProdutoFat2: TFloatField;
    qrPerformanceProdutoFat3: TFloatField;
    qrPerformanceProdutoCUSTO_TOTAL: TFloatField;
    qrPerformanceProdutoESTOQUE_ATUAL: TFloatField;
    qrPerformanceProdutoPROD_DES: TStringField;
    qrCupomProdutoPACU: TFloatField;
    qrCupomProdutoPERC2: TFloatField;
    qrCupomProdutoDESCRICAO: TStringField;
    qrProduto: TUniQuery;
    qrExportarCSV: TUniQuery;
    qrProdutosCancelados: TUniQuery;
    dbProdutosCancelados: TfrxDBDataset;
    qrProdutosCanceladosCODIGO: TStringField;
    qrProdutosCanceladosCOD_CUPOM: TStringField;
    qrProdutosCanceladosITEM: TIntegerField;
    qrProdutosCanceladosUNIDADE: TStringField;
    qrProdutosCanceladosQTDE: TFloatField;
    qrProdutosCanceladosVALOR_UNITARIO: TFloatField;
    qrProdutosCanceladosVALOR_DESCONTO: TFloatField;
    qrProdutosCanceladosVALOR_ACRESCIMO: TFloatField;
    qrProdutosCanceladosVALOR_TOTAL: TFloatField;
    qrProdutosCanceladosCANCELADO: TIntegerField;
    qrProdutosCanceladosEX: TIntegerField;
    qrProdutosCanceladosDATA: TDateField;
    qrProdutosCanceladosCOD_CAIXA: TIntegerField;
    qrProdutosCanceladosCOD_PRODUTO: TStringField;
    qrProdutosCanceladosVALOR_CUSTO: TFloatField;
    qrProdutosCanceladosVALOR_CUSTO_TOTAL: TFloatField;
    qrProdutosCanceladosNUVEM: TIntegerField;
    qrProdutosCanceladosMOTIVO_CANCELAMENTO: TStringField;
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
    qrProdutoESTOQUE_MINIMO: TFloatField;
    qrProdutoESTOQUE_MAXIMO: TFloatField;
    qrProdutosCanceladosDESCRICAO: TStringField;
    qrCupom: TUniQuery;
    qrCupomCODIGO: TStringField;
    qrCupomNUMERO: TStringField;
    qrCupomDATA: TDateField;
    qrCupomHORA: TTimeField;
    qrCupomQTDE_ITEM: TIntegerField;
    qrCupomVALOR_DESCONTO: TFloatField;
    qrCupomVALOR_ACRESCIMO: TFloatField;
    qrCupomVALOR_TOTAL: TFloatField;
    qrCupomCOD_CLIENTE: TIntegerField;
    qrCupomCANCELADO: TIntegerField;
    qrCupomCPF_CONSUMIDOR: TStringField;
    qrCupomNOME_CONSUMIDOR: TStringField;
    qrCupomCOD_VENDEDOR: TIntegerField;
    qrCupomEX: TIntegerField;
    qrCupomCOD_CAIXA: TIntegerField;
    qrCupomNUVEM: TIntegerField;
    qrCupomXML_CHAVE: TStringField;
    qrCupomXML_CHAVE_CANCELAMENTO: TStringField;
    qrCupomVALOR_CUSTO: TFloatField;
    procedure fxrelatorioGetValue(const VarName: string; var Value: Variant);
    procedure qrCupomProdutoCalcFields(DataSet: TDataSet);
    procedure qrCupomProdutoAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    function relatorioCurvaABC(oRelatorio:TRelatorio):Boolean;
    function relatorioPerformanceProduto(oRelatorio:TRelatorio):Boolean;
    function relatorioListarProduto(oRelatorio:TRelatorio;diretorio:string):boolean;
    function relatorioProdutosCancelados(oRelatorio:TRelatorio):boolean;
  end;

var
  dmRelProduto: TdmRelProduto;
  data1,data2,data3:string;
  acumulado:Real;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmRelProduto }

procedure TdmRelProduto.fxrelatorioGetValue(const VarName: string;
  var Value: Variant);
begin
if VarName = 'Data1' then
begin
  value := data1;
end;
if VarName = 'Data2' then
begin
  value := data2;
end;
if VarName = 'Data3' then
begin
  value := data3;
end;

end;
procedure TdmRelProduto.qrCupomProdutoAfterOpen(DataSet: TDataSet);
begin
acumulado := 0;
//qrCupomProduto.IndexFieldNames := 'COD_PRODUTO';
end;

procedure TdmRelProduto.qrCupomProdutoCalcFields(DataSet: TDataSet);
begin
acumulado := acumulado + dataset.FieldByName('PERC').AsFloat;
Dataset.FieldByName('PERC2').AsFloat := (dataset.FieldByName('VALOR_ITEM').AsFloat / dataset.FieldByName('VALOR_TOTAL').AsFloat)*100;
Dataset.FieldByName('PACU').AsFloat :=  acumulado;

end;

function TdmRelProduto.relatorioCurvaABC(oRelatorio: TRelatorio): Boolean;
begin
with qrCupomProduto do
begin
  Close;
  SQL.Clear;

  SQL.Add('SELECT ');
  SQL.Add('  CUPOM_ITEM.COD_PRODUTO, ');
  SQL.Add('  PRODUTO.DESCRICAO, ');
  SQL.Add('  SUM(CUPOM_ITEM.VALOR_TOTAL) AS VALOR_ITEM, ');
  SQL.Add('  SUM(CUPOM_ITEM.QTDE) AS QTD_ITEM, ');
  SQL.Add('  SUM(CUPOM_ITEM.VALOR_CUSTO_TOTAL) AS CUSTO_ITEM, ');

  // CAMPOS DO CUPOM (AGREGADOS)
  SQL.Add('  COUNT(DISTINCT CUPOM.CODIGO) AS QTD_CUPOM, ');
  SQL.Add('  MIN(CUPOM.DATA) AS PRIMEIRA_VENDA, ');
  SQL.Add('  MAX(CUPOM.DATA) AS ULTIMA_VENDA, ');

  SQL.Add('  (SELECT SUM(VALOR_TOTAL) ');
  SQL.Add('     FROM CUPOM_ITEM ');
  SQL.Add('    WHERE CANCELADO = 0 ');
  SQL.Add('      AND DATA >= :DTINICIO ');
  SQL.Add('      AND DATA <= :DTFIM) AS VALOR_TOTAL, ');

  SQL.Add('  (SUM(CUPOM_ITEM.VALOR_TOTAL) / ');
  SQL.Add('   (SELECT SUM(VALOR_TOTAL) ');
  SQL.Add('      FROM CUPOM_ITEM ');
  SQL.Add('     WHERE CANCELADO = 0 ');
  SQL.Add('       AND DATA >= :DTINICIO ');
  SQL.Add('       AND DATA <= :DTFIM)) * 100 AS PERC ');

  SQL.Add('FROM CUPOM_ITEM ');
  SQL.Add('LEFT JOIN PRODUTO ON CUPOM_ITEM.COD_PRODUTO = PRODUTO.CODIGO ');
  SQL.Add('LEFT JOIN CUPOM ON CUPOM_ITEM.COD_CUPOM = CUPOM.CODIGO ');

  SQL.Add('WHERE CUPOM_ITEM.CANCELADO = 0 ');
  SQL.Add('  AND CUPOM_ITEM.DATA >= :DTINICIO ');
  SQL.Add('  AND CUPOM_ITEM.DATA <= :DTFIM ');

  if oRelatorio.listaString1[0] <> '000000' then
  begin
    SQL.Add(' AND PRODUTO.GRUPO = :GRUPO ');
    ParamByName('GRUPO').AsString := oRelatorio.listaString1[0];
  end;

  if oRelatorio.listaString1[1] <> '000000' then
  begin
    SQL.Add(' AND PRODUTO.SUBGRUPO = :SUBGRUPO ');
    ParamByName('SUBGRUPO').AsString := oRelatorio.listaString1[1];
  end;

  if oRelatorio.listaString1[2] <> '000000' then
  begin
    SQL.Add(' AND PRODUTO.FORNECEDOR = :FORNECEDOR ');
    ParamByName('FORNECEDOR').AsString := oRelatorio.listaString1[2];
  end;

  if oRelatorio.listaString1[3] <> '000000' then
  begin
    SQL.Add(' AND PRODUTO.CODIGO = :CODPRODUTO ');
    ParamByName('CODPRODUTO').AsString := oRelatorio.listaString1[3];
  end;

  // VENDEDOR
  if oRelatorio.listaString1[4] <> '000000' then
  begin
    SQL.Add(' AND CUPOM.COD_VENDEDOR = :COD_VENDEDOR ');
    ParamByName('COD_VENDEDOR').AsString := oRelatorio.listaString1[4];
  end;

  // 🔥 FORMA DE PAGAMENTO (SEM DUPLICAR)
  if oRelatorio.listaString1[5] <> '000' then
  begin
    SQL.Add(' AND EXISTS ( ');
    SQL.Add('   SELECT 1 FROM CUPOM_FORMA ');
    SQL.Add('   WHERE CUPOM_FORMA.COD_CUPOM = CUPOM.CODIGO ');
    SQL.Add('     AND CUPOM_FORMA.FORMA = :FORMA ');
    SQL.Add(' ) ');
    ParamByName('FORMA').AsString := oRelatorio.listaString1[5];
  end;

  if oRelatorio.caixa <> '0' then
  begin
    SQL.Add(' AND CUPOM.COD_CAIXA = :COD_CAIXA ');
    ParamByName('COD_CAIXA').AsString := oRelatorio.caixa;
  end;

  SQL.Add('GROUP BY ');
  SQL.Add('  CUPOM_ITEM.COD_PRODUTO, ');
  SQL.Add('  PRODUTO.DESCRICAO ');

  // ORDENAÇÃO
  if oRelatorio.itemIndex = 0 then
  begin
    if oRelatorio.itemindex1 = 0 then
      SQL.Add('ORDER BY CUPOM_ITEM.COD_PRODUTO ASC ')
    else
      SQL.Add('ORDER BY CUPOM_ITEM.COD_PRODUTO DESC ');
  end;

  if oRelatorio.itemIndex = 1 then
  begin
    if oRelatorio.itemindex1 = 0 then
      SQL.Add('ORDER BY PRODUTO.DESCRICAO ASC ')
    else
      SQL.Add('ORDER BY PRODUTO.DESCRICAO DESC ');
  end;

  if oRelatorio.itemIndex = 2 then
  begin
    if oRelatorio.itemindex1 = 0 then
      SQL.Add('ORDER BY VALOR_ITEM ASC ')
    else
      SQL.Add('ORDER BY VALOR_ITEM DESC ');
  end;

  if oRelatorio.itemIndex = 3 then
  begin
    if oRelatorio.itemindex1 = 0 then
      SQL.Add('ORDER BY QTD_ITEM ASC ')
    else
      SQL.Add('ORDER BY QTD_ITEM DESC ');
  end;

  ParamByName('DTINICIO').AsDate := oRelatorio.periodoInicial;
  ParamByName('DTFIM').AsDate := oRelatorio.periodoFinal;

  Open;

  fxrelatorio.LoadFromFile('\System_RK\server\Relatorios\relCupomProdutoABC.fr3');
  fxrelatorio.ShowReport;
end;


end;

function TdmRelProduto.relatorioListarProduto(oRelatorio: TRelatorio;diretorio:string): boolean;
var
  utils:TUtils;
begin
try
    utils:=TUtils.Create;
  with qrExportarCSV do
  begin
  Close;
  SQL.clear;
  sql.Add('select * from produto');
  Open;

  utils.CreateCSVFromQuery(diretorio,qrExportarCSV);


  end;

finally
    utils.Free;
end;
end;

function TdmRelProduto.relatorioPerformanceProduto(
  oRelatorio: TRelatorio): Boolean;
begin
  with qrProduto do
  begin
    Close;
    SQl.Clear;
    SQl.Add('SELECT * FROM PRODUTO');

    Open;
  end;
  with qrPerformanceProduto do
  begin
    Close;
    SQl.Clear;
    sql.Add('SELECT COD_PRODUTO,');
    SQL.Add(' sum(case when extract (month from data)=:MES1 and extract (year from data) = :ANO1 then qtde else 0 end) as "Mes1",');
    SQL.Add(' sum(case when extract (month from data)=:MES2 and extract (year from data) = :ANO2 then qtde else 0 end) as "Mes2",');
    SQL.Add(' sum(case when extract (month from data)=:MES3 and extract (year from data) = :ANO3 then qtde else 0 end) as "Mes3",');

    SQL.Add(' sum(case when extract (month from data)=:MES1 and extract (year from data) = :ANO3 then VALOR_TOTAL else 0 end) as "Fat1",');
    SQL.Add(' sum(case when extract (month from data)=:MES2 and extract (year from data) = :ANO3 then VALOR_TOTAL else 0 end) as "Fat2",');
    SQL.Add(' sum(case when extract (month from data)=:MES3 and extract (year from data) = :ANO3 then VALOR_TOTAL else 0 end) as "Fat3",');
    SQL.Add(' SUM(VALOR_CUSTO_TOTAL) AS CUSTO_TOTAL');
    SQL.Add('from cupom_item');
    SQL.Add('WHERE CANCELADO = 0');
    if oRelatorio.listaString1[6] <> '000000' then
    begin
    SQL.Add('and cod_produto = :cod_produto');
    ParamByName('cod_produto').AsString := oRelatorio.listaString1[6];
    end;
    SQL.Add('group by cod_produto');
    ParamByName('MES1').AsString := oRelatorio.listaString1[0];
    ParamByName('MES2').AsString := oRelatorio.listaString1[1];
    ParamByName('MES3').AsString := oRelatorio.listaString1[2];

    ParamByName('ANO1').AsString := oRelatorio.listaString1[3];
    ParamByName('ANO2').AsString := oRelatorio.listaString1[4];
    ParamByName('ANO3').AsString := oRelatorio.listaString1[5];


    sql.Add('ORDER BY COD_PRODUTO');





    // passar texto mes / ano para o relatorio
    Open;

    data1 := oRelatorio.listaString1[0] + '/' + oRelatorio.listaString1[3];
    data2 := oRelatorio.listaString1[1] + '/' + oRelatorio.listaString1[4];
    data3 := oRelatorio.listaString1[2] + '/' + oRelatorio.listaString1[5];

    fxrelatorio.LoadFromFile('\System_RK\server\Relatorios\relPerformanceProduto.fr3');
    fxrelatorio.ShowReport;
  end;
end;

function TdmRelProduto.relatorioProdutosCancelados(
  oRelatorio: TRelatorio): boolean;
begin
with qrProdutosCancelados do
begin
  close;
  sql.Clear;
  SQL.Add('select * from cupom_item where cancelado = 1');

  SQL.Add('AND DATA >= :DTINICIO AND DATA <= :DTFIM ORDER BY DATA ASC');
  ParamByName('DTINICIO').asdate := oRelatorio.periodoInicial;
  ParamByName('DTFIM').asdate := oRelatorio.periodoFinal;

  Open;

  fxrelatorio.LoadFromFile('\System_RK\server\Relatorios\relProdutosCancelados.fr3');
  fxrelatorio.ShowReport;


end;

end;

end.
