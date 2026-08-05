object dmRelProduto: TdmRelProduto
  OldCreateOrder = False
  Height = 385
  Width = 518
  object qrCupomProduto: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'SELECT COD_PRODUTO,DESCRICAO,SUM(VALOR_TOTAL) AS VALOR_ITEM,'
      'SUM(QTDE)  AS QTD_ITEM,'
      'SUM(VALOR_CUSTO_TOTAL)  AS CUSTO_ITEM,'
      '(SELECT SUM(VALOR_TOTAL) FROM CUPOM_ITEM) AS VALOR_TOTAL,'
      
        '(SUM(VALOR_TOTAL)/(SELECT SUM(VALOR_TOTAL) FROM CUPOM_ITEM)) * 1' +
        '00 AS PERC'
      'FROM CUPOM_ITEM'
      'LEFT JOIN PRODUTO ON CUPOM_ITEM.COD_PRODUTO = PRODUTO.CODIGO'
      'WHERE CANCELADO = 0'
      ''
      'GROUP BY COD_PRODUTO,DESCRICAO'
      'ORDER BY 2 DESC'
      '')
    MasterFields = 'CODIGO'
    DetailFields = 'COD_CUPOM'
    AfterOpen = qrCupomProdutoAfterOpen
    OnCalcFields = qrCupomProdutoCalcFields
    Left = 152
    Top = 208
    object qrCupomProdutoCOD_PRODUTO: TStringField
      FieldName = 'COD_PRODUTO'
      Size = 6
    end
    object qrCupomProdutoVALOR_ITEM: TFloatField
      FieldName = 'VALOR_ITEM'
      ReadOnly = True
    end
    object qrCupomProdutoVALOR_TOTAL: TFloatField
      FieldName = 'VALOR_TOTAL'
      ReadOnly = True
    end
    object qrCupomProdutoPERC: TFloatField
      FieldName = 'PERC'
      ReadOnly = True
    end
    object qrCupomProdutoQTD_ITEM: TFloatField
      FieldName = 'QTD_ITEM'
      ReadOnly = True
    end
    object qrCupomProdutoCUSTO_ITEM: TFloatField
      FieldName = 'CUSTO_ITEM'
      ReadOnly = True
    end
    object qrCupomProdutoPACU: TFloatField
      FieldKind = fkCalculated
      FieldName = 'PACU'
      Calculated = True
    end
    object qrCupomProdutoPERC2: TFloatField
      FieldKind = fkCalculated
      FieldName = 'PERC2'
      Calculated = True
    end
    object qrCupomProdutoDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      ReadOnly = True
      Size = 80
    end
  end
  object DBCupomItem: TfrxDBDataset
    UserName = 'DBCupomItem'
    CloseDataSource = False
    FieldAliases.Strings = (
      'COD_PRODUTO=COD_PRODUTO'
      'VALOR_ITEM=VALOR_ITEM'
      'VALOR_TOTAL=VALOR_TOTAL'
      'PERC=PERC'
      'QTD_ITEM=QTD_ITEM'
      'CUSTO_ITEM=CUSTO_ITEM'
      'PACU=PACU'
      'PERC2=PERC2'
      'DESCRICAO=DESCRICAO')
    DataSet = qrCupomProduto
    BCDToCurrency = False
    Left = 143
    Top = 48
  end
  object fxrelatorio: TfrxReport
    Version = '5.2.3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45695.710444976900000000
    ReportOptions.LastChange = 45695.736561377310000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      'begin'
      ''
      'end.')
    OnGetValue = fxrelatorioGetValue
    Left = 326
    Top = 232
    Datasets = <
      item
        DataSet = dbProdutosCancelados
        DataSetName = 'dbProdutosCancelados'
      end
      item
        DataSet = dmProprio.fxemitente
        DataSetName = 'fxemitente'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 250.000000000000000000
      PaperHeight = 300.000000000000000000
      PaperSize = 256
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 30.236240000000000000
        Top = 238.110390000000000000
        Width = 869.291900000000000000
        DataSet = dbProdutosCancelados
        DataSetName = 'dbProdutosCancelados'
        RowCount = 0
        object dbProdutosCanceladosCOD_PRODUTO: TfrxMemoView
          Left = 3.779530000000000000
          Top = 7.559059999999988000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          DataField = 'COD_PRODUTO'
          DataSet = dbProdutosCancelados
          DataSetName = 'dbProdutosCancelados'
          Memo.UTF8W = (
            '[dbProdutosCancelados."COD_PRODUTO"]')
        end
        object dbProdutosCanceladosDESCRICAO: TfrxMemoView
          Left = 64.252010000000000000
          Top = 7.559059999999988000
          Width = 279.685220000000000000
          Height = 18.897650000000000000
          DataField = 'DESCRICAO'
          DataSet = dbProdutosCancelados
          DataSetName = 'dbProdutosCancelados'
          Memo.UTF8W = (
            '[dbProdutosCancelados."DESCRICAO"]')
        end
        object dbProdutosCanceladosQTDE: TfrxMemoView
          Left = 442.205010000000000000
          Top = 7.559059999999988000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'QTDE'
          DataSet = dbProdutosCancelados
          DataSetName = 'dbProdutosCancelados'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = '###,###,##0.00'
          Memo.UTF8W = (
            '[dbProdutosCancelados."QTDE"]')
        end
        object dbProdutosCanceladosVALOR_UNITARIO: TfrxMemoView
          Left = 351.496290000000000000
          Top = 7.559059999999988000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'VALOR_UNITARIO'
          DataSet = dbProdutosCancelados
          DataSetName = 'dbProdutosCancelados'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = '###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[dbProdutosCancelados."VALOR_UNITARIO"]')
        end
        object dbProdutosCanceladosVALOR_TOTAL: TfrxMemoView
          Left = 532.913730000000000000
          Top = 7.559059999999988000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'VALOR_TOTAL'
          DataSet = dbProdutosCancelados
          DataSetName = 'dbProdutosCancelados'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = '###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[dbProdutosCancelados."VALOR_TOTAL"]')
        end
        object dbProdutosCanceladosDATA: TfrxMemoView
          Left = 642.520100000000000000
          Top = 7.559059999999988000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'DATA'
          DataSet = dbProdutosCancelados
          DataSetName = 'dbProdutosCancelados'
          DisplayFormat.Kind = fkDateTime
          Memo.UTF8W = (
            '[dbProdutosCancelados."DATA"]')
        end
      end
      object PageFooter1: TfrxPageFooter
        FillType = ftBrush
        Height = 22.677180000000000000
        Top = 393.071120000000000000
        Width = 869.291900000000000000
        object Memo1: TfrxMemoView
          Left = 642.520100000000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          HAlign = haRight
          Memo.UTF8W = (
            '[Page#]')
        end
      end
      object Header1: TfrxHeader
        FillType = ftBrush
        Height = 26.456710000000000000
        Top = 188.976500000000000000
        Width = 869.291900000000000000
        object Memo2: TfrxMemoView
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          Memo.UTF8W = (
            'C'#243'd. Prod')
        end
        object Memo3: TfrxMemoView
          Left = 75.590600000000000000
          Width = 230.551330000000000000
          Height = 18.897650000000000000
          Memo.UTF8W = (
            'Nome Produto')
        end
        object Memo4: TfrxMemoView
          Left = 438.425480000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          Memo.UTF8W = (
            'Qtde')
        end
        object Memo5: TfrxMemoView
          Left = 351.496290000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          Memo.UTF8W = (
            'Vlr Un')
        end
        object Memo6: TfrxMemoView
          Left = 532.913730000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          Memo.UTF8W = (
            'Vlr Total')
        end
        object Memo7: TfrxMemoView
          Left = 642.520100000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          Memo.UTF8W = (
            'Data Cancelamento')
        end
      end
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        Height = 109.606370000000000000
        Top = 18.897650000000000000
        Width = 869.291900000000000000
        object Memo24: TfrxMemoView
          Width = 253.228510000000000000
          Height = 18.897650000000000000
          DataField = 'NOME'
          DataSet = dmProprio.fxemitente
          DataSetName = 'fxemitente'
          DisplayFormat.DecimalSeparator = ','
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            '[fxemitente."NOME"]')
          ParentFont = False
        end
        object Memo30: TfrxMemoView
          Left = 623.622450000000000000
          Top = 18.897650000000000000
          Width = 113.385900000000000000
          Height = 15.118120000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = 'dd/mm/yyyy'
          DisplayFormat.Kind = fkDateTime
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            'Emiss'#227'o: [Date]')
          ParentFont = False
        end
        object Memo8: TfrxMemoView
          Left = 623.622450000000000000
          Top = 37.795300000000000000
          Width = 113.385900000000000000
          Height = 15.118120000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '000#'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -9
          Font.Name = 'Arial'
          Font.Style = []
          HAlign = haRight
          Memo.UTF8W = (
            'P'#225'gina: [Page]')
          ParentFont = False
        end
        object Line1: TfrxLineView
          Top = 60.472480000000000000
          Width = 978.898270000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
        object Memo9: TfrxMemoView
          Left = 7.559060000000000000
          Top = 30.236240000000000000
          Width = 238.110390000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial Narrow'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'Relat'#243'rio Produtos Cancelados')
          ParentFont = False
        end
      end
      object Footer1: TfrxFooter
        FillType = ftBrush
        Height = 41.574830000000000000
        Top = 291.023810000000000000
        Width = 869.291900000000000000
        object SysMemo1: TfrxSysMemoView
          Left = 438.425480000000000000
          Top = 18.897650000000000000
          Width = 83.149660000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = '###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[SUM(<dbProdutosCancelados."QTDE">,MasterData1)]')
        end
        object SysMemo2: TfrxSysMemoView
          Left = 532.913730000000000000
          Top = 18.897650000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = '###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[SUM(<dbProdutosCancelados."VALOR_TOTAL">,MasterData1)]')
        end
        object Memo10: TfrxMemoView
          Left = 185.196970000000000000
          Top = 18.897650000000000000
          Width = 238.110390000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial Narrow'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'Totais:')
          ParentFont = False
        end
      end
    end
  end
  object qrPerformanceProduto: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select'
      '  cod_produto,'
      '  sum(case'
      '      when extract (month from data)='#39'11'#39
      '      and extract (year from data) = '#39'2022'#39
      '      then valor_total'
      '      else 0 end) as "Mes1",'
      '  sum(case'
      '      when extract (month from data)='#39'12'#39
      '      and extract (year from data) = '#39'2022'#39
      '      then valor_total'
      '      else 0 end) as "Mes2",'
      '  sum(case'
      '      when extract (month from data)='#39'11'#39
      '      and extract (year from data) = '#39'2022'#39
      '      then valor_total'
      '      else 0 end) as "Mes3",'
      ''
      '  sum(case'
      '      when extract (month from data)='#39'11'#39
      '      and extract (year from data) = '#39'2022'#39
      '      then valor_total'
      '      else 0 end) as "Fat1",'
      '  sum(case'
      '      when extract (month from data)='#39'11'#39
      '      and extract (year from data) = '#39'2022'#39
      '      then valor_total'
      '      else 0 end) as "Fat2",'
      '  sum(case'
      '      when extract (month from data)='#39'11'#39
      '      and extract (year from data) = '#39'2022'#39
      '      then valor_total'
      '      else 0 end) as "Fat3",'
      '   sum(valor_custo_total) as custo_total'
      ''
      'from'
      '  cupom_item'
      ''
      'group by'
      '  cod_produto')
    MasterFields = 'CODIGO'
    DetailFields = 'COD_CUPOM'
    Left = 48
    Top = 160
    object qrPerformanceProdutoCOD_PRODUTO: TStringField
      FieldName = 'COD_PRODUTO'
      Size = 6
    end
    object qrPerformanceProdutoMes1: TFloatField
      FieldName = 'Mes1'
      ReadOnly = True
    end
    object qrPerformanceProdutoMes2: TFloatField
      FieldName = 'Mes2'
      ReadOnly = True
    end
    object qrPerformanceProdutoMes3: TFloatField
      FieldName = 'Mes3'
      ReadOnly = True
    end
    object qrPerformanceProdutoFat1: TFloatField
      FieldName = 'Fat1'
      ReadOnly = True
    end
    object qrPerformanceProdutoFat2: TFloatField
      FieldName = 'Fat2'
      ReadOnly = True
    end
    object qrPerformanceProdutoFat3: TFloatField
      FieldName = 'Fat3'
      ReadOnly = True
    end
    object qrPerformanceProdutoCUSTO_TOTAL: TFloatField
      FieldName = 'CUSTO_TOTAL'
      ReadOnly = True
    end
    object qrPerformanceProdutoESTOQUE_ATUAL: TFloatField
      FieldKind = fkLookup
      FieldName = 'ESTOQUE_ATUAL'
      LookupDataSet = qrProduto
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'ESTOQUE'
      KeyFields = 'COD_PRODUTO'
      Lookup = True
    end
    object qrPerformanceProdutoPROD_DES: TStringField
      FieldKind = fkLookup
      FieldName = 'PROD_DES'
      LookupDataSet = qrProduto
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'COD_PRODUTO'
      Size = 50
      Lookup = True
    end
  end
  object DBPerformanceProduto: TfrxDBDataset
    UserName = 'DBPerformance'
    CloseDataSource = False
    FieldAliases.Strings = (
      'COD_PRODUTO=COD_PRODUTO'
      'Mes1=Mes1'
      'Mes2=Mes2'
      'Mes3=Mes3'
      'Fat1=Fat1'
      'Fat2=Fat2'
      'Fat3=Fat3'
      'CUSTO_TOTAL=CUSTO_TOTAL'
      'ESTOQUE_ATUAL=ESTOQUE_ATUAL'
      'PROD_DES=PROD_DES')
    DataSet = qrPerformanceProduto
    BCDToCurrency = False
    Left = 151
    Top = 144
  end
  object qrProduto: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from produto')
    Left = 256
    Top = 120
    object qrProdutoCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 6
    end
    object qrProdutoCODIGO_BARRAS: TStringField
      FieldName = 'CODIGO_BARRAS'
      Required = True
      Size = 14
    end
    object qrProdutoDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 80
    end
    object qrProdutoGRUPO: TStringField
      FieldName = 'GRUPO'
      Size = 6
    end
    object qrProdutoSUBGRUPO: TStringField
      FieldName = 'SUBGRUPO'
      Size = 6
    end
    object qrProdutoFORNECEDOR: TStringField
      FieldName = 'FORNECEDOR'
      Size = 6
    end
    object qrProdutoTRIBUTACAO: TStringField
      FieldName = 'TRIBUTACAO'
      Size = 3
    end
    object qrProdutoNCM: TStringField
      FieldName = 'NCM'
      Size = 8
    end
    object qrProdutoCEST: TStringField
      FieldName = 'CEST'
      Size = 7
    end
    object qrProdutoVALIDADE: TStringField
      FieldName = 'VALIDADE'
      Size = 3
    end
    object qrProdutoBALANCA: TIntegerField
      FieldName = 'BALANCA'
    end
    object qrProdutoFRACIONADO: TIntegerField
      FieldName = 'FRACIONADO'
    end
    object qrProdutoCUSTO: TFloatField
      FieldName = 'CUSTO'
    end
    object qrProdutoPRECO: TFloatField
      FieldName = 'PRECO'
    end
    object qrProdutoMARGEM: TFloatField
      FieldName = 'MARGEM'
    end
    object qrProdutoESTOQUE: TFloatField
      FieldName = 'ESTOQUE'
    end
    object qrProdutoUNIDADE: TStringField
      FieldName = 'UNIDADE'
      Size = 3
    end
    object qrProdutoINATIVO: TIntegerField
      FieldName = 'INATIVO'
    end
    object qrProdutoDIVERSOS: TIntegerField
      FieldName = 'DIVERSOS'
    end
    object qrProdutoDATA_CADASTRO: TDateField
      FieldName = 'DATA_CADASTRO'
    end
    object qrProdutoDATA_ALTERADO: TDateField
      FieldName = 'DATA_ALTERADO'
    end
    object qrProdutoPENDENTE: TIntegerField
      FieldName = 'PENDENTE'
    end
    object qrProdutoOBSERVACAO: TStringField
      FieldName = 'OBSERVACAO'
      Size = 255
    end
    object qrProdutoESTOQUE_MINIMO: TFloatField
      FieldName = 'ESTOQUE_MINIMO'
    end
    object qrProdutoESTOQUE_MAXIMO: TFloatField
      FieldName = 'ESTOQUE_MAXIMO'
    end
  end
  object qrExportarCSV: TUniQuery
    Connection = dmConexao.conexao
    Left = 152
    Top = 312
  end
  object qrProdutosCancelados: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from cupom_item')
    Left = 432
    Top = 120
    object qrProdutosCanceladosCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 50
    end
    object qrProdutosCanceladosCOD_CUPOM: TStringField
      FieldName = 'COD_CUPOM'
      Required = True
      Size = 50
    end
    object qrProdutosCanceladosITEM: TIntegerField
      FieldName = 'ITEM'
      Required = True
    end
    object qrProdutosCanceladosUNIDADE: TStringField
      FieldName = 'UNIDADE'
      Required = True
      Size = 5
    end
    object qrProdutosCanceladosQTDE: TFloatField
      FieldName = 'QTDE'
    end
    object qrProdutosCanceladosVALOR_UNITARIO: TFloatField
      FieldName = 'VALOR_UNITARIO'
    end
    object qrProdutosCanceladosVALOR_DESCONTO: TFloatField
      FieldName = 'VALOR_DESCONTO'
    end
    object qrProdutosCanceladosVALOR_ACRESCIMO: TFloatField
      FieldName = 'VALOR_ACRESCIMO'
    end
    object qrProdutosCanceladosVALOR_TOTAL: TFloatField
      FieldName = 'VALOR_TOTAL'
    end
    object qrProdutosCanceladosCANCELADO: TIntegerField
      FieldName = 'CANCELADO'
      Required = True
    end
    object qrProdutosCanceladosEX: TIntegerField
      FieldName = 'EX'
      Required = True
    end
    object qrProdutosCanceladosDATA: TDateField
      FieldName = 'DATA'
      Required = True
    end
    object qrProdutosCanceladosCOD_CAIXA: TIntegerField
      FieldName = 'COD_CAIXA'
      Required = True
    end
    object qrProdutosCanceladosCOD_PRODUTO: TStringField
      FieldName = 'COD_PRODUTO'
      Size = 6
    end
    object qrProdutosCanceladosVALOR_CUSTO: TFloatField
      FieldName = 'VALOR_CUSTO'
    end
    object qrProdutosCanceladosVALOR_CUSTO_TOTAL: TFloatField
      FieldName = 'VALOR_CUSTO_TOTAL'
    end
    object qrProdutosCanceladosNUVEM: TIntegerField
      FieldName = 'NUVEM'
    end
    object qrProdutosCanceladosMOTIVO_CANCELAMENTO: TStringField
      FieldName = 'MOTIVO_CANCELAMENTO'
      Size = 3
    end
    object qrProdutosCanceladosDESCRICAO: TStringField
      FieldKind = fkLookup
      FieldName = 'DESCRICAO'
      LookupDataSet = qrProduto
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'COD_PRODUTO'
      Lookup = True
    end
  end
  object dbProdutosCancelados: TfrxDBDataset
    UserName = 'dbProdutosCancelados'
    CloseDataSource = False
    FieldAliases.Strings = (
      'CODIGO=CODIGO'
      'COD_CUPOM=COD_CUPOM'
      'ITEM=ITEM'
      'UNIDADE=UNIDADE'
      'QTDE=QTDE'
      'VALOR_UNITARIO=VALOR_UNITARIO'
      'VALOR_DESCONTO=VALOR_DESCONTO'
      'VALOR_ACRESCIMO=VALOR_ACRESCIMO'
      'VALOR_TOTAL=VALOR_TOTAL'
      'CANCELADO=CANCELADO'
      'EX=EX'
      'DATA=DATA'
      'COD_CAIXA=COD_CAIXA'
      'COD_PRODUTO=COD_PRODUTO'
      'VALOR_CUSTO=VALOR_CUSTO'
      'VALOR_CUSTO_TOTAL=VALOR_CUSTO_TOTAL'
      'NUVEM=NUVEM'
      'MOTIVO_CANCELAMENTO=MOTIVO_CANCELAMENTO'
      'DESCRICAO=DESCRICAO')
    DataSet = qrProdutosCancelados
    BCDToCurrency = False
    Left = 328
    Top = 40
  end
  object qrCupom: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from cupom')
    Left = 424
    Top = 240
    object qrCupomCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 50
    end
    object qrCupomNUMERO: TStringField
      FieldName = 'NUMERO'
      Required = True
      Size = 12
    end
    object qrCupomDATA: TDateField
      FieldName = 'DATA'
      Required = True
    end
    object qrCupomHORA: TTimeField
      FieldName = 'HORA'
      Required = True
    end
    object qrCupomQTDE_ITEM: TIntegerField
      FieldName = 'QTDE_ITEM'
      Required = True
    end
    object qrCupomVALOR_DESCONTO: TFloatField
      FieldName = 'VALOR_DESCONTO'
    end
    object qrCupomVALOR_ACRESCIMO: TFloatField
      FieldName = 'VALOR_ACRESCIMO'
    end
    object qrCupomVALOR_TOTAL: TFloatField
      FieldName = 'VALOR_TOTAL'
    end
    object qrCupomCOD_CLIENTE: TIntegerField
      FieldName = 'COD_CLIENTE'
    end
    object qrCupomCANCELADO: TIntegerField
      FieldName = 'CANCELADO'
      Required = True
    end
    object qrCupomCPF_CONSUMIDOR: TStringField
      FieldName = 'CPF_CONSUMIDOR'
      Size = 18
    end
    object qrCupomNOME_CONSUMIDOR: TStringField
      FieldName = 'NOME_CONSUMIDOR'
      Size = 40
    end
    object qrCupomCOD_VENDEDOR: TIntegerField
      FieldName = 'COD_VENDEDOR'
    end
    object qrCupomEX: TIntegerField
      FieldName = 'EX'
      Required = True
    end
    object qrCupomCOD_CAIXA: TIntegerField
      FieldName = 'COD_CAIXA'
      Required = True
    end
    object qrCupomNUVEM: TIntegerField
      FieldName = 'NUVEM'
    end
    object qrCupomXML_CHAVE: TStringField
      FieldName = 'XML_CHAVE'
      Size = 45
    end
    object qrCupomXML_CHAVE_CANCELAMENTO: TStringField
      FieldName = 'XML_CHAVE_CANCELAMENTO'
      Size = 50
    end
    object qrCupomVALOR_CUSTO: TFloatField
      FieldName = 'VALOR_CUSTO'
    end
  end
end
