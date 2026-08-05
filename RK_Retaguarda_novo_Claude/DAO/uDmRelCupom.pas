unit uDmRelCupom;

interface

uses
  System.SysUtils, System.Classes,VCLTee.Chart,Classe.Relatorio,uDmConexao,
  Data.DB, MemDS, DBAccess, Uni,Vcl.Graphics,VCLTee.Series,nxgrid,Conversao,
  frxClass, frxDBSet,uDmProduto, vcl.gtxXport, vcl.gtFRXport;

type
  TdmRelCupom = class(TDataModule)
    qrRelatorioPesquisar: TUniQuery;
    fxrelatorio: TfrxReport;
    qrCupomRelDetalhado: TUniQuery;
    qrCupomRelDetalhadoCODIGO: TStringField;
    qrCupomRelDetalhadoNUMERO: TStringField;
    qrCupomRelDetalhadoDATA: TDateField;
    qrCupomRelDetalhadoHORA: TTimeField;
    qrCupomRelDetalhadoQTDE_ITEM: TIntegerField;
    qrCupomRelDetalhadoVALOR_DESCONTO: TFloatField;
    qrCupomRelDetalhadoVALOR_ACRESCIMO: TFloatField;
    qrCupomRelDetalhadoVALOR_TOTAL: TFloatField;
    qrCupomRelDetalhadoCOD_CLIENTE: TIntegerField;
    qrCupomRelDetalhadoCANCELADO: TIntegerField;
    qrCupomRelDetalhadoCPF_CONSUMIDOR: TStringField;
    qrCupomRelDetalhadoNOME_CONSUMIDOR: TStringField;
    qrCupomRelDetalhadoCOD_VENDEDOR: TIntegerField;
    qrCupomRelDetalhadoEX: TIntegerField;
    qrCupomRelDetalhadoCOD_CAIXA: TIntegerField;
    qrCupomRelDetalhadoNUVEM: TIntegerField;
    qrCupomRelDetalhadoXML_CHAVE: TStringField;
    qrCupomRelDetalhadoXML_CHAVE_CANCELAMENTO: TStringField;
    DBCupomDetalhe: TfrxDBDataset;
    qrCupomFinalizadora: TUniQuery;
    qrCupomFinalizadoraCODIGO: TStringField;
    qrCupomFinalizadoraCOD_CUPOM: TStringField;
    qrCupomFinalizadoraFORMA: TStringField;
    qrCupomFinalizadoraVALOR: TFloatField;
    qrCupomFinalizadoraPRESTACAO: TIntegerField;
    qrCupomFinalizadoraTIPO: TStringField;
    qrCupomFinalizadoraEX: TIntegerField;
    qrCupomFinalizadoraCOD: TIntegerField;
    qrCupomFinalizadoraVALOR_TROCO: TFloatField;
    qrCupomFinalizadoraDATA: TDateField;
    qrCupomFinalizadoraCANCELADO: TIntegerField;
    qrCupomFinalizadoraCOD_CAIXA: TIntegerField;
    qrCupomFinalizadoraFINALIZADORA: TStringField;
    DBCupomFinalizadora: TfrxDBDataset;
    qrCupomItem: TUniQuery;
    qrCupomItemCODIGO: TStringField;
    qrCupomItemCOD_CUPOM: TStringField;
    qrCupomItemITEM: TIntegerField;
    qrCupomItemUNIDADE: TStringField;
    qrCupomItemQTDE: TFloatField;
    qrCupomItemVALOR_UNITARIO: TFloatField;
    qrCupomItemVALOR_DESCONTO: TFloatField;
    qrCupomItemVALOR_ACRESCIMO: TFloatField;
    qrCupomItemVALOR_TOTAL: TFloatField;
    qrCupomItemCANCELADO: TIntegerField;
    qrCupomItemEX: TIntegerField;
    qrCupomItemDATA: TDateField;
    qrCupomItemCOD_CAIXA: TIntegerField;
    qrCupomItemCOD_PRODUTO: TStringField;
    qrCupomItemPRODUTO: TStringField;
    DBCupomItem: TfrxDBDataset;
    qrFinalizadora: TUniQuery;
    qrFinalizadoraCODIGO: TStringField;
    qrFinalizadoraDESCRICAO: TStringField;
    qrFinalizadoraESPECIE: TIntegerField;
    qrFinalizadoraTIPO: TStringField;
    qrFinalizadoraCODIGO99: TIntegerField;
    dsCupomDetalhe: TUniDataSource;
    qrCupomRelRes: TUniQuery;
    qrCupomRelResCODIGO: TStringField;
    qrCupomRelResNUMERO: TStringField;
    qrCupomRelResDATA: TDateField;
    qrCupomRelResHORA: TTimeField;
    qrCupomRelResQTDE_ITEM: TIntegerField;
    qrCupomRelResVALOR_DESCONTO: TFloatField;
    qrCupomRelResVALOR_ACRESCIMO: TFloatField;
    qrCupomRelResVALOR_TOTAL: TFloatField;
    qrCupomRelResCOD_CLIENTE: TIntegerField;
    qrCupomRelResCANCELADO: TIntegerField;
    qrCupomRelResCPF_CONSUMIDOR: TStringField;
    qrCupomRelResNOME_CONSUMIDOR: TStringField;
    qrCupomRelResCOD_VENDEDOR: TIntegerField;
    qrCupomRelResEX: TIntegerField;
    qrCupomRelResCOD_CAIXA: TIntegerField;
    qrCupomRelResNUVEM: TIntegerField;
    qrCupomRelResXML_CHAVE: TStringField;
    qrCupomRelResXML_CHAVE_CANCELAMENTO: TStringField;
    qrCupomResumido: TfrxDBDataset;
    qrRelFechamento: TUniQuery;
    qrRelFechamentoCODIGO: TStringField;
    qrRelFechamentoDATA_ABERTURA: TDateField;
    qrRelFechamentoHORA_ABERTURA: TTimeField;
    qrRelFechamentoDATA_FECHAMENTO: TDateField;
    qrRelFechamentoHORA_FECHAMENTO: TTimeField;
    qrRelFechamentoVENDA_BRUTA: TFloatField;
    qrRelFechamentoCANCELAMENTO_CUPOM: TFloatField;
    qrRelFechamentoCANCELAMENTO_ITEM: TFloatField;
    qrRelFechamentoDESCONTO_ITEM: TFloatField;
    qrRelFechamentoDESCONTO_CUPOM: TFloatField;
    qrRelFechamentoACRESCIMO_CUPOM: TFloatField;
    qrRelFechamentoVENDA_LIQUIDA: TFloatField;
    qrRelFechamentoFUNDO_CAIXA: TFloatField;
    qrRelFechamentoSANGRIA: TFloatField;
    qrRelFechamentoTOTAIS: TFloatField;
    qrRelFechamentoQTD_CUPONS_EFETIVADOS: TIntegerField;
    qrRelFechamentoQTD_CUPONS_CANCELADOS: TIntegerField;
    qrRelFechamentoEX: TIntegerField;
    qrRelFechamentoCOD_OPERADOR: TIntegerField;
    qrRelFechamentoCOD_CAIXA: TIntegerField;
    DBFechamento: TfrxDBDataset;
    qrRelFechamentoDetalhe: TUniQuery;
    qrRelFechamentoDetalheID_FECHAMENTO: TStringField;
    qrRelFechamentoDetalheFZCOD: TStringField;
    qrRelFechamentoDetalheVALOR_LIQUIDO: TFloatField;
    qrRelFechamentoDetalheVALOR_ENTRADA: TFloatField;
    qrRelFechamentoDetalheVALOR_TROCO: TFloatField;
    qrRelFechamentoDetalheVALOR_REFORCO: TFloatField;
    qrRelFechamentoDetalheVALOR_SANGRIA: TFloatField;
    qrRelFechamentoDetalheEX: TIntegerField;
    qrRelFechamentoDetalheCOD_CAIXA: TIntegerField;
    DBFechamentoDetalhe: TfrxDBDataset;
    dsFechamento: TDataSource;
    qrRelFechamentoOPERADOR: TStringField;
    qrCupomItemVALOR_CUSTO: TFloatField;
    qrCupomItemVALOR_CUSTO_TOTAL: TFloatField;
    qrCupomItemNUVEM: TIntegerField;
    qrCupomItemMOTIVO_CANCELAMENTO: TStringField;
    qrRelFechamentoDetalheNUVEM: TIntegerField;
    qrRelFechamentoDetalheVALOR_CONFERENCIA: TFloatField;
    qrRelFechamentoDetalheFINALIZADORA_DESCRICAO: TStringField;
  private
    { Private declarations }
  public
    function RelatorioGraficoCupom(oRelatorio:TRelatorio;Grafico:TChart;GridValores:TNextGrid):Boolean;
    function RelatorioCupom(oRelatorio:TRelatorio):Boolean;
    function RelatorioFechamentoCaixa(oRelatorio:TRelatorio):boolean;
  end;

var
  dmRelCupom: TdmRelCupom;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmRelatorio }

function TdmRelCupom.RelatorioCupom(oRelatorio: TRelatorio): Boolean;
var
  i:integer;
begin

    if oRelatorio.detalhado then
    begin//
    // ==============================================================
    // Relat�rio cupom detalhado
    with qrCupomRelDetalhado do
      begin

          Close;
          SQL.clear;
          SQL.add('select * from CUPOM ');
          SQL.add('where data >= :DTINICIO and data <=:DTFIM');
          ParamByName('DTINICIO').AsDate := oRelatorio.periodoInicial;
          ParamByName('DTFIM').AsDate := oRelatorio.periodoFinal;

          sql.Add('and valor_total ' + oRelatorio.filtro1 + ' :VALOR_TOTAL');
          ParamByName('VALOR_TOTAL').AsFloat := oRelatorio.valor1;

          // cancelado
          if oRelatorio.itemIndex = 0 then
          begin
          // EFETIVADO
            sql.Add('and cancelado = 0');
          end
          else
          if oRelatorio.itemIndex = 1 then
          begin
            sql.Add('and cancelado = 1');
          end;


          if oRelatorio.caixa <> '000' then
          begin
            SQL.Add('AND COD_CAIXA = :COD_CAIXA');
            ParamByName('COD_CAIXA').AsInteger := StrToInt(oRelatorio.caixa);
          end;

          // Filtro de vendedor
          if oRelatorio.listaString1[0] <> '000000' then
          begin
            SQL.Add('AND COD_VENDEDOR = :COD_VENDEDOR');
            ParamByName('COD_VENDEDOR').AsInteger := StrToInt(oRelatorio.listaString1[0]);
          end;

          // Filtro de forma de pagamento
          if oRelatorio.listaString1[1] <> '000' then
          begin
            SQL.Add('AND CODIGO IN (SELECT COD_CUPOM FROM CUPOM_FORMA WHERE FORMA = :FORMA_PAGAMENTO)');
            ParamByName('FORMA_PAGAMENTO').AsString := oRelatorio.listaString1[1];
          end;

          // Filtro de CPF/CNPJ
          if oRelatorio.listaString1[2] <> '' then
          begin
            SQL.Add('AND CPF_CONSUMIDOR LIKE :CPF_CONSUMIDOR');
            ParamByName('CPF_CONSUMIDOR').AsString := '%' + oRelatorio.listaString1[2] + '%';
          end;

          if oRelatorio.Fiscal = 1 then
          begin
          // fiscal
            SQL.Add('AND XML_CHAVE  <> '+Chr(39)+Chr(39));
          end
          ELSE
          if oRelatorio.Fiscal = 2 then
          begin
          //03
            SQL.Add('AND XML_CHAVE  = '+Chr(39)+Chr(39));
          end;


          SQL.add('order by 1 desc');
          Open;

        fxrelatorio.LoadFromFile('\System_RK\server\relatorios\relCupomDetalhe.fr3');
        fxrelatorio.ShowReport;
      end;



    end
    else
    begin
      // RESUMIDO
      with qrCupomRelRes do
      begin
      qrCupomRelRes.Close;
      qrCupomRelRes.SQL.clear;
      qrCupomRelRes.SQL.Add('select * from cupom ');
      qrCupomRelRes.SQL.add('where data >= :DTINICIO and data <=:DTFIM');
      qrCupomRelRes.ParamByName('DTINICIO').AsDate := oRelatorio.periodoInicial;
      qrCupomRelRes.ParamByName('DTFIM').AsDate := oRelatorio.periodoFinal;

      sql.Add('and valor_total ' + oRelatorio.filtro1 + ' :VALOR_TOTAL');
      ParamByName('VALOR_TOTAL').AsFloat := oRelatorio.valor1;

      // cancelado
      if oRelatorio.itemIndex = 0 then
      begin
      // EFETIVADO
        sql.Add('and cancelado = 0');
      end
      else
      if oRelatorio.itemIndex = 1 then
      begin
        sql.Add('and cancelado = 1');
      end;





      // caixa
      if oRelatorio.caixa <> '000' then
      begin
      qrCupomRelRes.SQL.Add('AND CUPOM.COD_CAIXA = :COD_CAIXA');
      qrCupomRelRes.ParamByName('COD_CAIXA').AsInteger := StrToInt(oRelatorio.caixa);
      end;

      // Filtro de vendedor
      if oRelatorio.listaString1[0] <> '000000' then
      begin
        qrCupomRelRes.SQL.Add('AND CUPOM.COD_VENDEDOR = :COD_VENDEDOR');
        qrCupomRelRes.ParamByName('COD_VENDEDOR').AsInteger := StrToInt(oRelatorio.listaString1[0]);
      end;

      // Filtro de forma de pagamento
      if oRelatorio.listaString1[1] <> '000' then
      begin
        qrCupomRelRes.SQL.Add('AND CUPOM.CODIGO IN (SELECT COD_CUPOM FROM CUPOM_FORMA WHERE FORMA = :FORMA_PAGAMENTO)');
        qrCupomRelRes.ParamByName('FORMA_PAGAMENTO').AsString := oRelatorio.listaString1[1];
      end;

      // Filtro de CPF/CNPJ
      if oRelatorio.listaString1[2] <> '' then
      begin
        qrCupomRelRes.SQL.Add('AND CUPOM.CPF_CONSUMIDOR LIKE :CPF_CONSUMIDOR');
        qrCupomRelRes.ParamByName('CPF_CONSUMIDOR').AsString := '%' + oRelatorio.listaString1[2] + '%';
      end;

          if oRelatorio.Fiscal = 1 then
          begin
          // fiscal
            qrCupomRelRes.SQL.Add('AND XML_CHAVE <> '+Chr(39)+Chr(39));
          end
          ELSE
          if oRelatorio.Fiscal = 2 then
          begin
          //03
            qrCupomRelRes.SQL.Add('AND XML_CHAVE = '+Chr(39)+Chr(39));
          end;


      qrCupomRelRes.SQL.Add('ORDER BY DATA,HORA');
      qrCupomRelRes.Open;

      fxrelatorio.LoadFromFile('\System_RK\server\relatorios\relCupomRes.fr3');
      fxrelatorio.ShowReport;

      end;
    end;

end;

function TdmRelCupom.RelatorioFechamentoCaixa(oRelatorio: TRelatorio): boolean;
begin
  with qrFinalizadora do
  begin
    close;
    sql.Clear;
    sql.Add('select * from finalizadora');
    Open;
  end;

  with qrRelFechamento do
  begin
    Close;
    SQl.Clear;
    SQl.Add('SELECT * FROM FECHAMENTO WHERE DATA_FECHAMENTO >= :DTINICIO AND DATA_FECHAMENTO <= :DTFIM');
    ParamByName('DTINICIO').AsDate := oRelatorio.periodoInicial;
    ParamByName('DTFIM').AsDate := oRelatorio.periodoFinal;

    if oRelatorio.caixa <> '0' then
    begin
      sql.Add('AND COD_CAIXA = :COD_CAIXA');
      ParamByName('COD_CAIXA').AsInteger := StrToInt(oRelatorio.caixa);
    end;

    if oRelatorio.filtro1 <> '000000' then
    begin
      sql.Add('AND COD_OPERADOR = :COD_OPERADOR');
      ParamByName('COD_OPERADOR').AsString := oRelatorio.filtro1;
    end;

    Open;
  end;


      fxrelatorio.LoadFromFile('\System_RK\server\relatorios\relFechamento.fr3');
      fxrelatorio.ShowReport;
end;

function TdmRelCupom.RelatorioGraficoCupom(oRelatorio: TRelatorio;
  Grafico: TChart;GridValores:TNextGrid): Boolean;
begin
    // limpargrafico
    Grafico.ClearChart;
    GridValores.ClearRows;

case oRelatorio.tipo of
  relCupom:begin
    GridValores.ColumnByName['coluna1'].Header.Caption := 'Caixa';
    GridValores.ColumnByName['coluna2'].Header.Caption := 'Valor Venda';
    GridValores.ColumnByName['coluna3'].Header.Caption := 'Qtd. Clientes';


    with qrRelatorioPesquisar do
    begin
      Close;
      SQL.Clear;
      SQL.add('select cod_caixa,sum(valor_total) AS TOTAL, count(*) as QTD_CLIENTES from cupom ');
      SQL.add('where data >= :dtInicio and data <= :dtFim');
      sql.add('AND CANCELADO = 0');
      SQL.add('group by cod_caixa ');

      ParamByName('dtInicio').AsDate := oRelatorio.periodoInicial;
      ParamByName('dtFim').AsDate := oRelatorio.periodoFinal;
      Open;
      while not qrRelatorioPesquisar.eof do
      begin
      Grafico.AddSeries(TBarSeries.Create(self));
      GridValores.AddRow(1);
      Grafico.Series[qrRelatorioPesquisar.RecNo-1].Add(FieldByName('TOTAL').asfloat,'Caixa: '+FieldByName('COD_CAIXA').asString);
      Grafico.Series[qrRelatorioPesquisar.RecNo-1].LegendTitle :='Caixa: '+FieldByName('COD_CAIXA').asString + ' ' + FormatFloat('R$ ###,###,##0.00',FieldByName('TOTAL').AsFloat);

      GridValores.Cell[0,qrRelatorioPesquisar.RecNo-1].AsString := FieldByName('COD_CAIXA').asString;
      GridValores.Cell[1,qrRelatorioPesquisar.RecNo-1].AsFloat := FieldByName('TOTAL').AsFloat;
      GridValores.Cell[2,qrRelatorioPesquisar.RecNo-1].AsInteger := FieldByName('QTD_CLIENTES').AsInteger;
      GridValores.Cell[3,qrRelatorioPesquisar.RecNo-1].AsFloat := (FieldByName('TOTAL').AsFloat / FieldByName('QTD_CLIENTES').AsInteger);


      qrRelatorioPesquisar.Next;
      end;
    end;


  end;
  relProduto:begin
    with qrRelatorioPesquisar do
    begin

    GridValores.ColumnByName['coluna1'].Header.Caption := 'Produto';
    GridValores.ColumnByName['coluna2'].Header.Caption := 'Valor Total';
    GridValores.ColumnByName['coluna3'].Header.Caption := 'Qtd. Vendida';

      Close;
      SQL.Clear;
      SQL.add('select cod_produto,sum(valor_total) as TOTAL, sum(QTDE) AS QTD_ITEM ,produto.descricao from cupom_item ');
      SQL.add('left join produto on ');
      SQL.add('produto.codigo = cupom_item.cod_produto ');
      SQL.add('where data >= :dtInicio and data <= :dtFim');
      sql.add('AND CANCELADO = 0');
      SQL.add('group by cupom_item.COD_PRODUTO,produto.descricao ');
      SQL.ADD('Order by TOTAL DESC');

      ParamByName('dtInicio').AsDate := oRelatorio.periodoInicial;
      ParamByName('dtFim').AsDate := oRelatorio.periodoFinal;
      Open;
      Grafico.AddSeries(TPieSeries.Create(self));
      while not qrRelatorioPesquisar.eof do
      begin



//      Grafico.Series[qrRelatorioPesquisar.RecNo-1].Add(FieldByName('TOTAL').asfloat, FieldByName('DESCRICAO').asString);
      Grafico.Series[0].Add(FieldByName('TOTAL').asfloat, FieldByName('DESCRICAO').asString);
//      Grafico.Series[qrRelatorioPesquisar.RecNo-1].LegendTitle :=FieldByName('DESCRICAO').asString + ' ' + FormatFloat('R$ ###,###,##0.00',FieldByName('TOTAL').AsFloat);
      GridValores.AddRow(1);
      GridValores.Cell[0,qrRelatorioPesquisar.RecNo-1].AsString := FieldByName('DESCRICAO').asString;
      GridValores.Cell[1,qrRelatorioPesquisar.RecNo-1].AsFloat := FieldByName('TOTAL').AsFloat;
      GridValores.Cell[2,qrRelatorioPesquisar.RecNo-1].AsInteger := FieldByName('QTD_ITEM').AsInteger;


      qrRelatorioPesquisar.Next;
      end;
    end;

  end;
  relFinalizadora:begin
      with qrRelatorioPesquisar do
    begin
    GridValores.ColumnByName['coluna1'].Header.Caption := 'Finalizadora';
    GridValores.ColumnByName['coluna2'].Header.Caption := 'Vlr. Venda';
    GridValores.ColumnByName['coluna3'].Header.Caption := 'Qtde. Finaliza��es';

      Close;
      SQL.Clear;
      SQL.add('select cupom_forma.forma,finalizadora.descricao,sum(valor-valor_troco) as TOTAL ,count(*) as qtde from cupom_forma left join finalizadora on ');
      SQL.add('cupom_forma.forma = finalizadora.codigo ');
      SQL.add('where data >= :dtInicio and data <= :dtFim');
      sql.add('AND CANCELADO = 0');
      SQL.add('group by cupom_forma.forma , finalizadora.descricao ');
      SQL.ADD('Order by TOTAL DESC');

      ParamByName('dtInicio').AsDate := oRelatorio.periodoInicial;
      ParamByName('dtFim').AsDate := oRelatorio.periodoFinal;
      Open;
      while not qrRelatorioPesquisar.eof do
      begin
      Grafico.AddSeries(TBarSeries.Create(self));
      GridValores.AddRow(1);
      Grafico.Series[qrRelatorioPesquisar.RecNo-1].Add(FieldByName('TOTAL').asfloat, FieldByName('DESCRICAO').asString);
      Grafico.Series[qrRelatorioPesquisar.RecNo-1].LegendTitle :=FieldByName('DESCRICAO').asString + ' ' + FormatFloat('R$ ###,###,##0.00',FieldByName('TOTAL').AsFloat);

      GridValores.Cell[0,qrRelatorioPesquisar.RecNo-1].AsString := FieldByName('DESCRICAO').asString;
      GridValores.Cell[1,qrRelatorioPesquisar.RecNo-1].AsFloat := FieldByName('TOTAL').AsFloat;
      GridValores.Cell[2,qrRelatorioPesquisar.RecNo-1].AsFloat := FieldByName('qtde').AsFloat;


      qrRelatorioPesquisar.Next;
      end;
    end;



  end;
end;


end;

end.
