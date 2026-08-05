object dmRelFinalizadora: TdmRelFinalizadora
  OldCreateOrder = False
  Height = 278
  Width = 361
  object qrCupomFormaRel: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from cupom_forma'
      'left join finalizadora'
      'on cupom_forma.forma = finalizadora.codigo'
      'order by cod_caixa,cupom_forma.forma')
    Left = 40
    Top = 16
    object qrCupomFormaRelCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 50
    end
    object qrCupomFormaRelCOD_CUPOM: TStringField
      FieldName = 'COD_CUPOM'
      Required = True
      Size = 50
    end
    object qrCupomFormaRelFORMA: TStringField
      FieldName = 'FORMA'
      Required = True
      Size = 30
    end
    object qrCupomFormaRelVALOR: TFloatField
      FieldName = 'VALOR'
    end
    object qrCupomFormaRelPRESTACAO: TIntegerField
      FieldName = 'PRESTACAO'
      Required = True
    end
    object qrCupomFormaRelTIPO: TStringField
      FieldName = 'TIPO'
      Required = True
      Size = 30
    end
    object qrCupomFormaRelEX: TIntegerField
      FieldName = 'EX'
      Required = True
    end
    object qrCupomFormaRelCOD: TIntegerField
      FieldName = 'COD'
    end
    object qrCupomFormaRelVALOR_TROCO: TFloatField
      FieldName = 'VALOR_TROCO'
    end
    object qrCupomFormaRelDATA: TDateField
      FieldName = 'DATA'
    end
    object qrCupomFormaRelCANCELADO: TIntegerField
      FieldName = 'CANCELADO'
    end
    object qrCupomFormaRelCOD_CAIXA: TIntegerField
      FieldName = 'COD_CAIXA'
    end
    object qrCupomFormaRelCODIGO_1: TStringField
      FieldName = 'CODIGO_1'
      ReadOnly = True
      Size = 3
    end
    object qrCupomFormaRelDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      ReadOnly = True
    end
    object qrCupomFormaRelESPECIE: TIntegerField
      FieldName = 'ESPECIE'
      ReadOnly = True
    end
    object qrCupomFormaRelTIPO_1: TStringField
      FieldName = 'TIPO_1'
      ReadOnly = True
      FixedChar = True
      Size = 1
    end
    object qrCupomFormaRelCODIGO99: TIntegerField
      FieldName = 'CODIGO99'
      ReadOnly = True
    end
  end
  object qrCupomFormaTotRel: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select finalizadora.codigo,finalizadora.descricao,'
      'sum(valor) as "VALOR",'
      'sum(valor_troco) as "VALOR_TROCO"'
      ''
      'from cupom_forma'
      'left join finalizadora'
      'on cupom_forma.forma = finalizadora.codigo'
      'group by finalizadora.codigo,finalizadora.descricao')
    Left = 48
    Top = 88
    object qrCupomFormaTotRelCODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 3
    end
    object qrCupomFormaTotRelDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
    end
    object qrCupomFormaTotRelVALOR: TFloatField
      FieldName = 'VALOR'
      ReadOnly = True
    end
    object qrCupomFormaTotRelVALOR_TROCO: TFloatField
      FieldName = 'VALOR_TROCO'
      ReadOnly = True
    end
  end
  object DBCupomForma: TfrxDBDataset
    UserName = 'DBCupomForma'
    CloseDataSource = False
    FieldAliases.Strings = (
      'CODIGO=CODIGO'
      'COD_CUPOM=COD_CUPOM'
      'FORMA=FORMA'
      'VALOR=VALOR'
      'PRESTACAO=PRESTACAO'
      'TIPO=TIPO'
      'EX=EX'
      'COD=COD'
      'VALOR_TROCO=VALOR_TROCO'
      'DATA=DATA'
      'CANCELADO=CANCELADO'
      'COD_CAIXA=COD_CAIXA'
      'CODIGO_1=CODIGO_1'
      'DESCRICAO=DESCRICAO'
      'ESPECIE=ESPECIE'
      'TIPO_1=TIPO_1'
      'CODIGO99=CODIGO99')
    DataSet = qrCupomFormaRel
    BCDToCurrency = False
    Left = 143
    Top = 16
  end
  object DBCupomFormaRes: TfrxDBDataset
    UserName = 'DBCupomFormaRes'
    CloseDataSource = False
    FieldAliases.Strings = (
      'CODIGO=CODIGO'
      'DESCRICAO=DESCRICAO'
      'VALOR=VALOR'
      'VALOR_TROCO=VALOR_TROCO')
    DataSet = qrCupomFormaTotRel
    BCDToCurrency = False
    Left = 151
    Top = 80
  end
  object fxrelatorio: TfrxReport
    Version = '5.2.3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 39181.615094942100000000
    ReportOptions.LastChange = 44509.469345057900000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      'end.          ')
    Left = 263
    Top = 48
    Datasets = <
      item
        DataSet = DBCupomFormaRes
        DataSetName = 'DBCupomFormaRes'
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
      PaperWidth = 215.900000000000000000
      PaperHeight = 279.400000000000000000
      PaperSize = 1
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 38.354360000000000000
        Top = 188.976500000000000000
        Width = 740.409927000000000000
        DataSet = DBCupomFormaRes
        DataSetName = 'DBCupomFormaRes'
        RowCount = 0
        object DBCupomFormaResFZCOD: TfrxMemoView
          Top = 11.338582680000000000
          Width = 75.590600000000000000
          Height = 18.897650000000000000
          DataSet = DBCupomFormaRes
          DataSetName = 'DBCupomFormaRes'
          Memo.UTF8W = (
            '[DBCupomFormaRes."CODIGO"]')
        end
        object DBCupomFormaResFZDES: TfrxMemoView
          Left = 86.929190000000000000
          Top = 11.338582680000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataSet = DBCupomFormaRes
          DataSetName = 'DBCupomFormaRes'
          Memo.UTF8W = (
            '[DBCupomFormaRes."DESCRICAO"]')
        end
        object DBCupomFormaResVALOR: TfrxMemoView
          Left = 264.567100000000000000
          Top = 11.338582677165400000
          Width = 105.826840000000000000
          Height = 18.897650000000000000
          DataField = 'VALOR'
          DataSet = DBCupomFormaRes
          DataSetName = 'DBCupomFormaRes'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[DBCupomFormaRes."VALOR"]')
        end
        object DBCupomFormaResVALOR_TROCO: TfrxMemoView
          Left = 400.630180000000000000
          Top = 11.338582677165400000
          Width = 90.708720000000000000
          Height = 18.897650000000000000
          DataField = 'VALOR_TROCO'
          DataSet = DBCupomFormaRes
          DataSetName = 'DBCupomFormaRes'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[DBCupomFormaRes."VALOR_TROCO"]')
        end
        object Memo3: TfrxMemoView
          Left = 566.929500000000000000
          Top = 11.338582677165400000
          Width = 90.708720000000000000
          Height = 18.897650000000000000
          DataSet = DBCupomFormaRes
          DataSetName = 'DBCupomFormaRes'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[<DBCupomFormaRes."VALOR"> - <DBCupomFormaRes."VALOR_TROCO">]')
        end
      end
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        Height = 109.606370000000000000
        Top = 18.897650000000000000
        Width = 740.409927000000000000
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
        object Memo2: TfrxMemoView
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
        object Line2: TfrxLineView
          Top = 75.590600000000000000
          Width = 740.787880000000000000
          Color = clBlack
          Diagonal = True
        end
        object Line1: TfrxLineView
          Top = 60.472480000000000000
          Width = 740.787880000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
        object Memo8: TfrxMemoView
          Left = 3.779530000000000000
          Top = 83.149660000000000000
          Width = 56.692950000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'C'#243'd. Fin')
          ParentFont = False
        end
        object Memo9: TfrxMemoView
          Left = 86.929190000000000000
          Top = 83.149660000000000000
          Width = 105.826840000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Finalizadora')
          ParentFont = False
        end
        object Memo10: TfrxMemoView
          Left = 400.630180000000000000
          Top = 83.929190000000000000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Valor Troco')
          ParentFont = False
        end
        object Memo12: TfrxMemoView
          Left = 264.567100000000000000
          Top = 83.149660000000000000
          Width = 105.826840000000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Valor Entrada')
          ParentFont = False
        end
        object Memo1: TfrxMemoView
          Left = 566.929500000000000000
          Top = 83.149660000000000000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Valor Total')
          ParentFont = False
        end
      end
      object Footer1: TfrxFooter
        FillType = ftBrush
        Height = 26.456710000000000000
        Top = 249.448980000000000000
        Width = 740.409927000000000000
        object SysMemo1: TfrxSysMemoView
          Left = 264.567100000000000000
          Top = 7.559055118110220000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[SUM(<DBCupomFormaRes."VALOR">,MasterData1)]')
        end
        object Line3: TfrxLineView
          Width = 1096.063700000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
        object SysMemo2: TfrxSysMemoView
          Left = 400.630180000000000000
          Top = 7.559055118110220000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[SUM(<DBCupomFormaRes."VALOR_TROCO">,MasterData1)]')
        end
        object SysMemo3: TfrxSysMemoView
          Left = 566.929500000000000000
          Top = 7.559055118110220000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            
              '[SUM(<DBCupomFormaRes."VALOR"> - <DBCupomFormaRes."VALOR_TROCO">' +
              ',MasterData1)]')
        end
        object Memo4: TfrxMemoView
          Left = 158.740260000000000000
          Top = 7.559055118110220000
          Width = 56.692950000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'Totais:')
          ParentFont = False
        end
      end
    end
  end
end
