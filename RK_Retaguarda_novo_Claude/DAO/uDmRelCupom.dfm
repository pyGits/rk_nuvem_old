object dmRelCupom: TdmRelCupom
  OldCreateOrder = False
  Height = 362
  Width = 615
  object qrRelatorioPesquisar: TUniQuery
    Connection = dmConexao.conexao
    Left = 336
    Top = 248
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
    ReportOptions.LastChange = 46141.428808472200000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'var'
      '  TotalGeral: Real;'
      ''
      ''
      'procedure DetailData1OnBeforePrint(Sender: TfrxComponent);'
      'begin'
      '  // TESTE: soma 1 por item v'#225'lido'
      '  if <DBCupomItem."MOTIVO_CANCELAMENTO"> <> '#39'F5'#39' then'
      '  begin'
      '//    showmessage(TotalGeral);      '
      '    TotalGeral := TotalGeral+1;'
      '  end;              '
      ''
      '  // Itens cancelados'
      '  if <DBCupomItem."CANCELADO"> = 1 then'
      '  begin'
      '    DetailData1.Font.Color := clRed;'
      '    Footer1.Font.Color := clRed;'
      '  end'
      '  else'
      '  begin'
      '    DetailData1.Font.Color := clBlack;'
      '    Footer1.Font.Color := clBlack;'
      '  end;'
      ''
      '  // Finalizadora cancelada'
      '  if <DBCupomFinalizadora."CANCELADO"> = 1 then'
      '    DetailData2.Font.Color := clRed'
      '  else'
      '    DetailData2.Font.Color := clBlack;'
      'end;'
      ''
      'procedure ReportSummary1OnBeforePrint(Sender: TfrxComponent);'
      'begin'
      
        '//showmessage(floattostr(TotalGeral));                          ' +
        '                                              '
      'end;'
      ''
      'begin'
      'end.          ')
    Left = 300
    Top = 18
    Datasets = <
      item
        DataSet = DBCupomDetalhe
        DataSetName = 'DBCupomDetalhe'
      end
      item
        DataSet = DBCupomFinalizadora
        DataSetName = 'DBCupomFinalizadora'
      end
      item
        DataSet = DBCupomItem
        DataSetName = 'DBCupomItem'
      end
      item
        DataSet = dmProprio.fxemitente
        DataSetName = 'fxemitente'
      end>
    Variables = <
      item
        Name = ' TotalGeral'
        Value = ''
      end>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 270.000000000000000000
      PaperHeight = 279.400000000000000000
      PaperSize = 256
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        Height = 109.606370000000000000
        Top = 18.897650000000000000
        Width = 944.882500000000000000
        object Memo24: TfrxMemoView
          Left = 7.559060000000000000
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
        object Line1: TfrxLineView
          Top = 60.472480000000000000
          Width = 740.787880000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 52.913420000000000000
        Top = 188.976500000000000000
        Width = 944.882500000000000000
        DataSet = DBCupomDetalhe
        DataSetName = 'DBCupomDetalhe'
        RowCount = 0
        object Line2: TfrxLineView
          Top = 15.118120000000010000
          Width = 944.882500000000000000
          Color = clBlack
          Diagonal = True
        end
        object DBCupomDetalheCOD_CUPOM: TfrxMemoView
          Left = 2.779530000000000000
          Top = 32.236240000000010000
          Width = 268.346630000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial Narrow'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'Cupom N'#250'mero: [copy(<DBCupomDetalhe."CODIGO">,30,6)]')
          ParentFont = False
        end
        object DBCupomDetalheDATA: TfrxMemoView
          Left = 525.354670000000000000
          Top = 34.015770000000010000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'DATA'
          Memo.UTF8W = (
            '[DBCupomDetalhe."DATA"]')
        end
        object DBCupomDetalheHORA: TfrxMemoView
          Left = 616.063390000000000000
          Top = 34.015770000000010000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'HORA'
          Memo.UTF8W = (
            '[DBCupomDetalhe."HORA"]')
        end
        object DBCupomDetalheCPF_CONSUMIDOR: TfrxMemoView
          Left = 370.393940000000000000
          Top = 34.015770000000010000
          Width = 143.622140000000000000
          Height = 18.897650000000000000
          DataField = 'CPF_CONSUMIDOR'
          Memo.UTF8W = (
            '[DBCupomDetalhe."CPF_CONSUMIDOR"]')
        end
      end
      object DetailData1: TfrxDetailData
        FillType = ftBrush
        Height = 30.236240000000000000
        Top = 309.921460000000000000
        Width = 944.882500000000000000
        OnBeforePrint = 'DetailData1OnBeforePrint'
        DataSet = DBCupomItem
        DataSetName = 'DBCupomItem'
        RowCount = 0
        object DBCupomItemCOD_PRODUTO: TfrxMemoView
          Left = 7.559060000000000000
          Top = 3.779527559055112000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          DataField = 'COD_PRODUTO'
          Memo.UTF8W = (
            '[DBCupomItem."COD_PRODUTO"]')
        end
        object DBCupomItemPRODUTO: TfrxMemoView
          Left = 71.811070000000000000
          Top = 3.779527560000020000
          Width = 234.330860000000000000
          Height = 18.897650000000000000
          DataField = 'PRODUTO'
          Memo.UTF8W = (
            '[DBCupomItem."PRODUTO"]')
        end
        object DBCupomItemQTDE: TfrxMemoView
          Left = 309.921460000000000000
          Top = 3.779527560000020000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'QTDE'
          Memo.UTF8W = (
            '[DBCupomItem."QTDE"]')
        end
        object DBCupomItemVALOR_UNITARIO: TfrxMemoView
          Left = 396.850650000000000000
          Top = 3.779527559055112000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'VALOR_UNITARIO'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[DBCupomItem."VALOR_UNITARIO"]')
        end
        object DBCupomItemVALOR_DESCONTO: TfrxMemoView
          Left = 521.575140000000000000
          Top = 3.779527560000020000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'VALOR_DESCONTO'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[DBCupomItem."VALOR_DESCONTO"]')
        end
        object DBCupomItemVALOR_TOTAL: TfrxMemoView
          Left = 767.244590000000000000
          Top = 3.779527560000020000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'VALOR_TOTAL'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[DBCupomItem."VALOR_TOTAL"]')
        end
        object Memo7: TfrxMemoView
          Left = 642.520100000000000000
          Top = 3.779527560000020000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[DBCupomItem."VALOR_ACRESCIMO"]')
        end
        object DBCupomItemMOTIVO_CANCELAMENTO: TfrxMemoView
          Left = 895.748610000000000000
          Top = 3.779530000000022000
          Width = 30.236240000000000000
          Height = 18.897650000000000000
          DataField = 'MOTIVO_CANCELAMENTO'
          DataSet = DBCupomItem
          DataSetName = 'DBCupomItem'
          Memo.UTF8W = (
            '[DBCupomItem."MOTIVO_CANCELAMENTO"]')
        end
      end
      object DetailData2: TfrxDetailData
        FillType = ftBrush
        Height = 34.015770000000000000
        Top = 476.220780000000000000
        Width = 944.882500000000000000
        DataSet = DBCupomFinalizadora
        DataSetName = 'DBCupomFinalizadora'
        RowCount = 0
        object DBCupomFinalizadoraFORMA: TfrxMemoView
          Left = 7.559060000000000000
          Top = 7.559059999999988000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          DataField = 'FORMA'
          Memo.UTF8W = (
            '[DBCupomFinalizadora."FORMA"]')
        end
        object DBCupomFinalizadoraFINALIZADORA: TfrxMemoView
          Left = 166.299320000000000000
          Top = 7.559059999999988000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataField = 'FINALIZADORA'
          Memo.UTF8W = (
            '[DBCupomFinalizadora."FINALIZADORA"]')
        end
        object DBCupomFinalizadoraVALOR: TfrxMemoView
          Left = 396.850650000000000000
          Top = 7.559059999999988000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'VALOR'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[DBCupomFinalizadora."VALOR"]')
        end
        object DBCupomFinalizadoraVALOR_TROCO: TfrxMemoView
          Left = 502.677490000000000000
          Top = 7.559059999999988000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'VALOR_TROCO'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[DBCupomFinalizadora."VALOR_TROCO"]')
        end
        object Memo4: TfrxMemoView
          Left = 623.622450000000000000
          Top = 7.559059999999988000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            
              '[<DBCupomFinalizadora."VALOR"> - <DBCupomFinalizadora."VALOR_TRO' +
              'CO">]')
        end
        object Line3: TfrxLineView
          Top = 30.236240000000010000
          Width = 941.102970000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
      end
      object Header1: TfrxHeader
        FillType = ftBrush
        Height = 22.677180000000000000
        Top = 264.567100000000000000
        Width = 944.882500000000000000
        object Memo8: TfrxMemoView
          Left = 7.559060000000000000
          Width = 56.692950000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'C'#243'd. ')
          ParentFont = False
        end
        object Memo9: TfrxMemoView
          Left = 71.811070000000000000
          Width = 105.826840000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Produto')
          ParentFont = False
        end
        object Memo10: TfrxMemoView
          Left = 396.850650000000000000
          Top = 0.779530000000022500
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Vlr. Unit'#225'rio')
          ParentFont = False
        end
        object Memo12: TfrxMemoView
          Left = 313.700990000000000000
          Width = 71.811070000000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Qtd')
          ParentFont = False
        end
        object Memo1: TfrxMemoView
          Left = 521.575140000000000000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Vlr. Desconto')
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          Left = 771.024120000000000000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Vlr. Total')
          ParentFont = False
        end
        object Memo15: TfrxMemoView
          Left = 642.520100000000000000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Vlr. Acr'#233'scimo')
          ParentFont = False
        end
      end
      object Header2: TfrxHeader
        FillType = ftBrush
        Height = 45.354360000000000000
        Top = 408.189240000000000000
        Width = 944.882500000000000000
        object Memo5: TfrxMemoView
          Left = 7.559060000000000000
          Top = 22.677180000000020000
          Width = 71.811070000000000000
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
        object Memo6: TfrxMemoView
          Left = 166.299320000000000000
          Top = 22.677180000000020000
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
        object Memo11: TfrxMemoView
          Left = 400.630180000000000000
          Top = 22.677180000000020000
          Width = 94.488250000000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Vlr. Entrada')
          ParentFont = False
        end
        object Memo13: TfrxMemoView
          Left = 506.457020000000000000
          Top = 22.677180000000020000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Vlr. Troco')
          ParentFont = False
        end
        object Memo14: TfrxMemoView
          Left = 623.622450000000000000
          Top = 22.677180000000020000
          Width = 109.606370000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8W = (
            'Vlr. Liq')
          ParentFont = False
        end
      end
      object Footer1: TfrxFooter
        FillType = ftBrush
        Height = 22.677180000000000000
        Top = 362.834880000000000000
        Width = 944.882500000000000000
        object SysMemo1: TfrxSysMemoView
          Left = 309.921460000000000000
          Width = 222.992270000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial Narrow'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'Qtde Total: [SUM(<DBCupomItem."QTDE">,DetailData1)]')
          ParentFont = False
        end
        object Memo16: TfrxMemoView
          Left = 767.244590000000000000
          Width = 173.858380000000000000
          Height = 18.897650000000000000
          DisplayFormat.FormatStr = '%2.2m'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial Narrow'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            
              '[SUM(IIF(<DBCupomItem."MOTIVO_CANCELAMENTO"> <> '#39'F5'#39', <DBCupomIt' +
              'em."VALOR_TOTAL">, 0), DetailData1)]')
          ParentFont = False
        end
        object Memo17: TfrxMemoView
          Left = 11.338590000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial Narrow'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'Total:')
          ParentFont = False
        end
      end
      object ReportSummary1: TfrxReportSummary
        FillType = ftBrush
        Height = 79.370130000000000000
        Top = 570.709030000000000000
        Width = 944.882500000000000000
        OnBeforePrint = 'ReportSummary1OnBeforePrint'
        object Memo18: TfrxMemoView
          Left = 536.693260000000000000
          Top = 45.354360000000040000
          Width = 389.291590000000000000
          Height = 18.897650000000000000
          Memo.UTF8W = (
            
              'Total Geral, Venda L'#237'quida: [FormatFloat('#39'#,##0.00'#39', TotalGeral)' +
              ']')
        end
      end
    end
  end
  object qrCupomRelDetalhado: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from cupom'
      '')
    Active = True
    Left = 48
    Top = 24
    object qrCupomRelDetalhadoCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 50
    end
    object qrCupomRelDetalhadoNUMERO: TStringField
      FieldName = 'NUMERO'
      Required = True
      Size = 12
    end
    object qrCupomRelDetalhadoDATA: TDateField
      FieldName = 'DATA'
      Required = True
    end
    object qrCupomRelDetalhadoHORA: TTimeField
      FieldName = 'HORA'
      Required = True
    end
    object qrCupomRelDetalhadoQTDE_ITEM: TIntegerField
      FieldName = 'QTDE_ITEM'
      Required = True
    end
    object qrCupomRelDetalhadoVALOR_DESCONTO: TFloatField
      FieldName = 'VALOR_DESCONTO'
    end
    object qrCupomRelDetalhadoVALOR_ACRESCIMO: TFloatField
      FieldName = 'VALOR_ACRESCIMO'
    end
    object qrCupomRelDetalhadoVALOR_TOTAL: TFloatField
      FieldName = 'VALOR_TOTAL'
    end
    object qrCupomRelDetalhadoCOD_CLIENTE: TIntegerField
      FieldName = 'COD_CLIENTE'
    end
    object qrCupomRelDetalhadoCANCELADO: TIntegerField
      FieldName = 'CANCELADO'
      Required = True
    end
    object qrCupomRelDetalhadoCPF_CONSUMIDOR: TStringField
      FieldName = 'CPF_CONSUMIDOR'
      Size = 18
    end
    object qrCupomRelDetalhadoNOME_CONSUMIDOR: TStringField
      FieldName = 'NOME_CONSUMIDOR'
      Size = 40
    end
    object qrCupomRelDetalhadoCOD_VENDEDOR: TIntegerField
      FieldName = 'COD_VENDEDOR'
    end
    object qrCupomRelDetalhadoEX: TIntegerField
      FieldName = 'EX'
      Required = True
    end
    object qrCupomRelDetalhadoCOD_CAIXA: TIntegerField
      FieldName = 'COD_CAIXA'
      Required = True
    end
    object qrCupomRelDetalhadoNUVEM: TIntegerField
      FieldName = 'NUVEM'
    end
    object qrCupomRelDetalhadoXML_CHAVE: TStringField
      FieldName = 'XML_CHAVE'
      Size = 45
    end
    object qrCupomRelDetalhadoXML_CHAVE_CANCELAMENTO: TStringField
      FieldName = 'XML_CHAVE_CANCELAMENTO'
      Size = 50
    end
  end
  object DBCupomDetalhe: TfrxDBDataset
    UserName = 'DBCupomDetalhe'
    CloseDataSource = False
    FieldAliases.Strings = (
      'CODIGO=CODIGO'
      'NUMERO=NUMERO'
      'DATA=DATA'
      'HORA=HORA'
      'QTDE_ITEM=QTDE_ITEM'
      'VALOR_DESCONTO=VALOR_DESCONTO'
      'VALOR_ACRESCIMO=VALOR_ACRESCIMO'
      'VALOR_TOTAL=VALOR_TOTAL'
      'COD_CLIENTE=COD_CLIENTE'
      'CANCELADO=CANCELADO'
      'CPF_CONSUMIDOR=CPF_CONSUMIDOR'
      'NOME_CONSUMIDOR=NOME_CONSUMIDOR'
      'COD_VENDEDOR=COD_VENDEDOR'
      'EX=EX'
      'COD_CAIXA=COD_CAIXA'
      'NUVEM=NUVEM'
      'XML_CHAVE=XML_CHAVE'
      'XML_CHAVE_CANCELAMENTO=XML_CHAVE_CANCELAMENTO')
    DataSet = qrCupomRelDetalhado
    BCDToCurrency = False
    Left = 159
    Top = 24
  end
  object qrCupomFinalizadora: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from cupom_forma')
    MasterSource = dsCupomDetalhe
    MasterFields = 'CODIGO'
    DetailFields = 'COD_CUPOM'
    Active = True
    Left = 40
    Top = 112
    ParamData = <
      item
        DataType = ftString
        Name = 'CODIGO'
        ParamType = ptInput
        Value = '00000000000000000000000000000025291'
      end>
    object qrCupomFinalizadoraCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 50
    end
    object qrCupomFinalizadoraCOD_CUPOM: TStringField
      FieldName = 'COD_CUPOM'
      Required = True
      Size = 50
    end
    object qrCupomFinalizadoraFORMA: TStringField
      FieldName = 'FORMA'
      Required = True
      Size = 30
    end
    object qrCupomFinalizadoraVALOR: TFloatField
      FieldName = 'VALOR'
    end
    object qrCupomFinalizadoraPRESTACAO: TIntegerField
      FieldName = 'PRESTACAO'
      Required = True
    end
    object qrCupomFinalizadoraTIPO: TStringField
      FieldName = 'TIPO'
      Required = True
      Size = 30
    end
    object qrCupomFinalizadoraEX: TIntegerField
      FieldName = 'EX'
      Required = True
    end
    object qrCupomFinalizadoraCOD: TIntegerField
      FieldName = 'COD'
    end
    object qrCupomFinalizadoraVALOR_TROCO: TFloatField
      FieldName = 'VALOR_TROCO'
    end
    object qrCupomFinalizadoraDATA: TDateField
      FieldName = 'DATA'
    end
    object qrCupomFinalizadoraCANCELADO: TIntegerField
      FieldName = 'CANCELADO'
    end
    object qrCupomFinalizadoraCOD_CAIXA: TIntegerField
      FieldName = 'COD_CAIXA'
    end
    object qrCupomFinalizadoraFINALIZADORA: TStringField
      FieldKind = fkLookup
      FieldName = 'FINALIZADORA'
      LookupDataSet = qrFinalizadora
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'FORMA'
      Lookup = True
    end
  end
  object DBCupomFinalizadora: TfrxDBDataset
    UserName = 'DBCupomFinalizadora'
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
      'FINALIZADORA=FINALIZADORA')
    DataSet = qrCupomFinalizadora
    BCDToCurrency = False
    Left = 151
    Top = 112
  end
  object qrCupomItem: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from cupom_item')
    MasterSource = dsCupomDetalhe
    MasterFields = 'CODIGO;DATA;COD_CAIXA'
    DetailFields = 'COD_CUPOM;DATA;COD_CAIXA'
    Active = True
    Left = 40
    Top = 184
    ParamData = <
      item
        DataType = ftString
        Name = 'CODIGO'
        ParamType = ptInput
        Value = '00000000000000000000000000000025291'
      end
      item
        DataType = ftDate
        Name = 'DATA'
        ParamType = ptInput
        Value = 46127d
      end
      item
        DataType = ftInteger
        Name = 'COD_CAIXA'
        ParamType = ptInput
        Value = 1
      end>
    object qrCupomItemCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 50
    end
    object qrCupomItemCOD_CUPOM: TStringField
      FieldName = 'COD_CUPOM'
      Required = True
      Size = 50
    end
    object qrCupomItemITEM: TIntegerField
      FieldName = 'ITEM'
      Required = True
    end
    object qrCupomItemUNIDADE: TStringField
      FieldName = 'UNIDADE'
      Required = True
      Size = 5
    end
    object qrCupomItemQTDE: TFloatField
      FieldName = 'QTDE'
    end
    object qrCupomItemVALOR_UNITARIO: TFloatField
      FieldName = 'VALOR_UNITARIO'
    end
    object qrCupomItemVALOR_DESCONTO: TFloatField
      FieldName = 'VALOR_DESCONTO'
    end
    object qrCupomItemVALOR_ACRESCIMO: TFloatField
      FieldName = 'VALOR_ACRESCIMO'
    end
    object qrCupomItemVALOR_TOTAL: TFloatField
      FieldName = 'VALOR_TOTAL'
    end
    object qrCupomItemCANCELADO: TIntegerField
      FieldName = 'CANCELADO'
      Required = True
    end
    object qrCupomItemEX: TIntegerField
      FieldName = 'EX'
      Required = True
    end
    object qrCupomItemDATA: TDateField
      FieldName = 'DATA'
      Required = True
    end
    object qrCupomItemCOD_CAIXA: TIntegerField
      FieldName = 'COD_CAIXA'
      Required = True
    end
    object qrCupomItemCOD_PRODUTO: TStringField
      FieldName = 'COD_PRODUTO'
      Size = 6
    end
    object qrCupomItemPRODUTO: TStringField
      FieldKind = fkLookup
      FieldName = 'PRODUTO'
      LookupDataSet = dmProduto.qrProduto
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'COD_PRODUTO'
      Lookup = True
    end
    object qrCupomItemVALOR_CUSTO: TFloatField
      FieldName = 'VALOR_CUSTO'
    end
    object qrCupomItemVALOR_CUSTO_TOTAL: TFloatField
      FieldName = 'VALOR_CUSTO_TOTAL'
    end
    object qrCupomItemNUVEM: TIntegerField
      FieldName = 'NUVEM'
    end
    object qrCupomItemMOTIVO_CANCELAMENTO: TStringField
      FieldName = 'MOTIVO_CANCELAMENTO'
      Size = 3
    end
  end
  object DBCupomItem: TfrxDBDataset
    UserName = 'DBCupomItem'
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
      'PRODUTO=PRODUTO'
      'VALOR_CUSTO=VALOR_CUSTO'
      'VALOR_CUSTO_TOTAL=VALOR_CUSTO_TOTAL'
      'NUVEM=NUVEM'
      'MOTIVO_CANCELAMENTO=MOTIVO_CANCELAMENTO')
    DataSet = qrCupomItem
    BCDToCurrency = False
    Left = 151
    Top = 184
  end
  object qrFinalizadora: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from finalizadora')
    Active = True
    Left = 436
    Top = 248
    object qrFinalizadoraCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 3
    end
    object qrFinalizadoraDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
    end
    object qrFinalizadoraESPECIE: TIntegerField
      FieldName = 'ESPECIE'
    end
    object qrFinalizadoraTIPO: TStringField
      FieldName = 'TIPO'
      FixedChar = True
      Size = 1
    end
    object qrFinalizadoraCODIGO99: TIntegerField
      FieldName = 'CODIGO99'
    end
  end
  object dsCupomDetalhe: TUniDataSource
    DataSet = qrCupomRelDetalhado
    Left = 44
    Top = 250
  end
  object qrCupomRelRes: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from cupom')
    Left = 112
    Top = 280
    object qrCupomRelResCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 50
    end
    object qrCupomRelResNUMERO: TStringField
      FieldName = 'NUMERO'
      Required = True
      Size = 12
    end
    object qrCupomRelResDATA: TDateField
      FieldName = 'DATA'
      Required = True
    end
    object qrCupomRelResHORA: TTimeField
      FieldName = 'HORA'
      Required = True
    end
    object qrCupomRelResQTDE_ITEM: TIntegerField
      FieldName = 'QTDE_ITEM'
      Required = True
    end
    object qrCupomRelResVALOR_DESCONTO: TFloatField
      FieldName = 'VALOR_DESCONTO'
    end
    object qrCupomRelResVALOR_ACRESCIMO: TFloatField
      FieldName = 'VALOR_ACRESCIMO'
    end
    object qrCupomRelResVALOR_TOTAL: TFloatField
      FieldName = 'VALOR_TOTAL'
    end
    object qrCupomRelResCOD_CLIENTE: TIntegerField
      FieldName = 'COD_CLIENTE'
    end
    object qrCupomRelResCANCELADO: TIntegerField
      FieldName = 'CANCELADO'
      Required = True
    end
    object qrCupomRelResCPF_CONSUMIDOR: TStringField
      FieldName = 'CPF_CONSUMIDOR'
      Size = 18
    end
    object qrCupomRelResNOME_CONSUMIDOR: TStringField
      FieldName = 'NOME_CONSUMIDOR'
      Size = 40
    end
    object qrCupomRelResCOD_VENDEDOR: TIntegerField
      FieldName = 'COD_VENDEDOR'
    end
    object qrCupomRelResEX: TIntegerField
      FieldName = 'EX'
      Required = True
    end
    object qrCupomRelResCOD_CAIXA: TIntegerField
      FieldName = 'COD_CAIXA'
      Required = True
    end
    object qrCupomRelResNUVEM: TIntegerField
      FieldName = 'NUVEM'
    end
    object qrCupomRelResXML_CHAVE: TStringField
      FieldName = 'XML_CHAVE'
      Size = 45
    end
    object qrCupomRelResXML_CHAVE_CANCELAMENTO: TStringField
      FieldName = 'XML_CHAVE_CANCELAMENTO'
      Size = 50
    end
  end
  object qrCupomResumido: TfrxDBDataset
    UserName = 'DBCupomResumido'
    CloseDataSource = False
    FieldAliases.Strings = (
      'CODIGO=CODIGO'
      'NUMERO=NUMERO'
      'DATA=DATA'
      'HORA=HORA'
      'QTDE_ITEM=QTDE_ITEM'
      'VALOR_DESCONTO=VALOR_DESCONTO'
      'VALOR_ACRESCIMO=VALOR_ACRESCIMO'
      'VALOR_TOTAL=VALOR_TOTAL'
      'COD_CLIENTE=COD_CLIENTE'
      'CANCELADO=CANCELADO'
      'CPF_CONSUMIDOR=CPF_CONSUMIDOR'
      'NOME_CONSUMIDOR=NOME_CONSUMIDOR'
      'COD_VENDEDOR=COD_VENDEDOR'
      'EX=EX'
      'COD_CAIXA=COD_CAIXA'
      'NUVEM=NUVEM'
      'XML_CHAVE=XML_CHAVE'
      'XML_CHAVE_CANCELAMENTO=XML_CHAVE_CANCELAMENTO')
    DataSet = qrCupomRelRes
    BCDToCurrency = False
    Left = 207
    Top = 288
  end
  object qrRelFechamento: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from fechamento')
    Left = 408
    Top = 16
    object qrRelFechamentoCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 50
    end
    object qrRelFechamentoDATA_ABERTURA: TDateField
      FieldName = 'DATA_ABERTURA'
    end
    object qrRelFechamentoHORA_ABERTURA: TTimeField
      FieldName = 'HORA_ABERTURA'
    end
    object qrRelFechamentoDATA_FECHAMENTO: TDateField
      FieldName = 'DATA_FECHAMENTO'
    end
    object qrRelFechamentoHORA_FECHAMENTO: TTimeField
      FieldName = 'HORA_FECHAMENTO'
    end
    object qrRelFechamentoVENDA_BRUTA: TFloatField
      FieldName = 'VENDA_BRUTA'
    end
    object qrRelFechamentoCANCELAMENTO_CUPOM: TFloatField
      FieldName = 'CANCELAMENTO_CUPOM'
    end
    object qrRelFechamentoCANCELAMENTO_ITEM: TFloatField
      FieldName = 'CANCELAMENTO_ITEM'
    end
    object qrRelFechamentoDESCONTO_ITEM: TFloatField
      FieldName = 'DESCONTO_ITEM'
    end
    object qrRelFechamentoDESCONTO_CUPOM: TFloatField
      FieldName = 'DESCONTO_CUPOM'
    end
    object qrRelFechamentoACRESCIMO_CUPOM: TFloatField
      FieldName = 'ACRESCIMO_CUPOM'
    end
    object qrRelFechamentoVENDA_LIQUIDA: TFloatField
      FieldName = 'VENDA_LIQUIDA'
    end
    object qrRelFechamentoFUNDO_CAIXA: TFloatField
      FieldName = 'FUNDO_CAIXA'
    end
    object qrRelFechamentoSANGRIA: TFloatField
      FieldName = 'SANGRIA'
    end
    object qrRelFechamentoTOTAIS: TFloatField
      FieldName = 'TOTAIS'
    end
    object qrRelFechamentoQTD_CUPONS_EFETIVADOS: TIntegerField
      FieldName = 'QTD_CUPONS_EFETIVADOS'
    end
    object qrRelFechamentoQTD_CUPONS_CANCELADOS: TIntegerField
      FieldName = 'QTD_CUPONS_CANCELADOS'
    end
    object qrRelFechamentoEX: TIntegerField
      FieldName = 'EX'
    end
    object qrRelFechamentoCOD_OPERADOR: TIntegerField
      FieldName = 'COD_OPERADOR'
    end
    object qrRelFechamentoCOD_CAIXA: TIntegerField
      FieldName = 'COD_CAIXA'
    end
    object qrRelFechamentoOPERADOR: TStringField
      FieldName = 'OPERADOR'
      Size = 70
    end
  end
  object DBFechamento: TfrxDBDataset
    UserName = 'DBFechamento'
    CloseDataSource = False
    FieldAliases.Strings = (
      'CODIGO=CODIGO'
      'DATA_ABERTURA=DATA_ABERTURA'
      'HORA_ABERTURA=HORA_ABERTURA'
      'DATA_FECHAMENTO=DATA_FECHAMENTO'
      'HORA_FECHAMENTO=HORA_FECHAMENTO'
      'VENDA_BRUTA=VENDA_BRUTA'
      'CANCELAMENTO_CUPOM=CANCELAMENTO_CUPOM'
      'CANCELAMENTO_ITEM=CANCELAMENTO_ITEM'
      'DESCONTO_ITEM=DESCONTO_ITEM'
      'DESCONTO_CUPOM=DESCONTO_CUPOM'
      'ACRESCIMO_CUPOM=ACRESCIMO_CUPOM'
      'VENDA_LIQUIDA=VENDA_LIQUIDA'
      'FUNDO_CAIXA=FUNDO_CAIXA'
      'SANGRIA=SANGRIA'
      'TOTAIS=TOTAIS'
      'QTD_CUPONS_EFETIVADOS=QTD_CUPONS_EFETIVADOS'
      'QTD_CUPONS_CANCELADOS=QTD_CUPONS_CANCELADOS'
      'EX=EX'
      'COD_OPERADOR=COD_OPERADOR'
      'COD_CAIXA=COD_CAIXA'
      'OPERADOR=OPERADOR')
    DataSet = qrRelFechamento
    BCDToCurrency = False
    Left = 303
    Top = 88
  end
  object qrRelFechamentoDetalhe: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from fechamento_finalizadora')
    MasterSource = dsFechamento
    MasterFields = 'CODIGO'
    DetailFields = 'ID_FECHAMENTO'
    Left = 416
    Top = 96
    ParamData = <
      item
        DataType = ftString
        Name = 'CODIGO'
        ParamType = ptInput
        Value = '15'
      end>
    object qrRelFechamentoDetalheID_FECHAMENTO: TStringField
      FieldName = 'ID_FECHAMENTO'
      Required = True
      Size = 50
    end
    object qrRelFechamentoDetalheFZCOD: TStringField
      FieldName = 'FZCOD'
      Required = True
      Size = 3
    end
    object qrRelFechamentoDetalheVALOR_LIQUIDO: TFloatField
      FieldName = 'VALOR_LIQUIDO'
    end
    object qrRelFechamentoDetalheVALOR_ENTRADA: TFloatField
      FieldName = 'VALOR_ENTRADA'
    end
    object qrRelFechamentoDetalheVALOR_TROCO: TFloatField
      FieldName = 'VALOR_TROCO'
    end
    object qrRelFechamentoDetalheVALOR_REFORCO: TFloatField
      FieldName = 'VALOR_REFORCO'
    end
    object qrRelFechamentoDetalheVALOR_SANGRIA: TFloatField
      FieldName = 'VALOR_SANGRIA'
    end
    object qrRelFechamentoDetalheEX: TIntegerField
      FieldName = 'EX'
    end
    object qrRelFechamentoDetalheCOD_CAIXA: TIntegerField
      FieldName = 'COD_CAIXA'
    end
    object qrRelFechamentoDetalheNUVEM: TIntegerField
      FieldName = 'NUVEM'
    end
    object qrRelFechamentoDetalheVALOR_CONFERENCIA: TFloatField
      FieldName = 'VALOR_CONFERENCIA'
    end
    object qrRelFechamentoDetalheFINALIZADORA_DESCRICAO: TStringField
      FieldKind = fkLookup
      FieldName = 'FINALIZADORA_DESCRICAO'
      LookupDataSet = qrFinalizadora
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'FZCOD'
      Lookup = True
    end
  end
  object DBFechamentoDetalhe: TfrxDBDataset
    UserName = 'DBFechamentoDetalhe'
    CloseDataSource = False
    FieldAliases.Strings = (
      'ID_FECHAMENTO=ID_FECHAMENTO'
      'FZCOD=FZCOD'
      'VALOR_LIQUIDO=VALOR_LIQUIDO'
      'VALOR_ENTRADA=VALOR_ENTRADA'
      'VALOR_TROCO=VALOR_TROCO'
      'VALOR_REFORCO=VALOR_REFORCO'
      'VALOR_SANGRIA=VALOR_SANGRIA'
      'EX=EX'
      'COD_CAIXA=COD_CAIXA'
      'NUVEM=NUVEM'
      'VALOR_CONFERENCIA=VALOR_CONFERENCIA'
      'FINALIZADORA_DESCRICAO=FINALIZADORA_DESCRICAO')
    DataSet = qrRelFechamentoDetalhe
    BCDToCurrency = False
    Left = 295
    Top = 152
  end
  object dsFechamento: TDataSource
    DataSet = qrRelFechamento
    Left = 440
    Top = 160
  end
end
