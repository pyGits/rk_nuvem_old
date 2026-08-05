object dmRelFuncionario: TdmRelFuncionario
  OldCreateOrder = False
  Height = 283
  Width = 370
  object qrRelComissaoFunc: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'select sum(valor_total) as venda_total, lpad(cod_vendedor,6,'#39'0'#39')' +
        ' as codfuncionario , cancelado '
      'from cupom'
      'where cancelado = 0'
      'group by cod_vendedor,cancelado')
    Left = 152
    Top = 32
    object qrRelComissaoFuncVENDA_TOTAL: TFloatField
      FieldName = 'VENDA_TOTAL'
      ReadOnly = True
    end
    object qrRelComissaoFuncCANCELADO: TIntegerField
      FieldName = 'CANCELADO'
      Required = True
    end
    object qrRelComissaoFuncCODFUNCIONARIO: TStringField
      FieldName = 'CODFUNCIONARIO'
      ReadOnly = True
      Size = 6
    end
    object qrRelComissaoFuncCOMISSAO: TFloatField
      FieldKind = fkLookup
      FieldName = 'COMISSAO'
      LookupDataSet = qrRelFunFuncionarios
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'COMISSAO'
      KeyFields = 'CODFUNCIONARIO'
      Lookup = True
    end
    object qrRelComissaoFuncNOME: TStringField
      FieldKind = fkLookup
      FieldName = 'NOME'
      LookupDataSet = qrRelFunFuncionarios
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'NOME'
      KeyFields = 'CODFUNCIONARIO'
      Lookup = True
    end
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
    ReportOptions.LastChange = 44799.692038078700000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'procedure ComissaoOnAfterData(Sender: TfrxComponent);'
      'begin'
      '//formatfloat('#39'###,###,##0.00'#39',ss);    '
      
        '  Comissao.text := formatfloat('#39'R$###,###,##0.00'#39',(DBComissaoFun' +
        'cCOMISSAO.value/100)* DBComissaoFuncVENDA_TOTAL.value);         ' +
        '                                                                ' +
        '                             '
      'end;'
      ''
      'begin'
      '  '
      'end.          ')
    Left = 68
    Top = 34
    Datasets = <
      item
        DataSet = DBComissaoFunc
        DataSetName = 'DBComissaoFunc'
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
      Orientation = poLandscape
      PaperWidth = 240.000000000000000000
      PaperHeight = 210.000000000000000000
      PaperSize = 256
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      OnAfterPrint = 'Page1OnAfterPrint'
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        Height = 109.606370000000000000
        Top = 18.897650000000000000
        Width = 831.496600000000000000
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
          Left = 593.386210000000000000
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
        object Line2: TfrxLineView
          Top = 71.811070000000000000
          Width = 1247.244900000000000000
          Color = clBlack
          Diagonal = True
        end
        object Line1: TfrxLineView
          Top = 60.472480000000000000
          Width = 1254.803960000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
        object Memo8: TfrxMemoView
          Left = 234.330860000000000000
          Top = 83.149611180000000000
          Width = 136.063080000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            'Valor Total')
          ParentFont = False
        end
        object Memo2: TfrxMemoView
          Left = 593.386210000000000000
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
        object Memo1: TfrxMemoView
          Left = 34.015770000000000000
          Top = 83.149611180000000000
          Width = 136.063080000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            'Funcion'#225'rio')
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          Left = 608.504330000000000000
          Top = 83.149611180000000000
          Width = 136.063080000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            '% Comiss'#227'o')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          Left = 396.850650000000000000
          Top = 83.149611180000000000
          Width = 136.063080000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            'Valor Comiss'#227'o')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 26.456710000000000000
        Top = 188.976500000000000000
        Width = 831.496600000000000000
        DataSet = DBComissaoFunc
        DataSetName = 'DBComissaoFunc'
        RowCount = 0
        object DBComissaoFuncVENDA_TOTAL: TfrxMemoView
          Left = 268.346630000000000000
          Top = 3.779527560000000000
          Width = 143.622140000000000000
          Height = 18.897650000000000000
          DataField = 'VENDA_TOTAL'
          DataSet = DBComissaoFunc
          DataSetName = 'DBComissaoFunc'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[DBComissaoFunc."VENDA_TOTAL"]')
        end
        object DBComissaoFuncCOMISSAO: TfrxMemoView
          Left = 634.961040000000000000
          Top = 3.779527560000000000
          Width = 136.063080000000000000
          Height = 18.897650000000000000
          DataSet = DBComissaoFunc
          DataSetName = 'DBComissaoFunc'
          Memo.UTF8W = (
            '[DBComissaoFunc."COMISSAO"] %')
        end
        object DBComissaoFuncNOME: TfrxMemoView
          Left = 64.252010000000000000
          Top = 3.779527560000000000
          Width = 196.535560000000000000
          Height = 18.897650000000000000
          DataField = 'NOME'
          DataSet = DBComissaoFunc
          DataSetName = 'DBComissaoFunc'
          Memo.UTF8W = (
            '[DBComissaoFunc."NOME"]')
        end
        object Comissao: TfrxMemoView
          Left = 423.307360000000000000
          Top = 3.779527560000000000
          Width = 136.063080000000000000
          Height = 18.897650000000000000
          OnAfterData = 'ComissaoOnAfterData'
          DataSet = DBComissaoFunc
          DataSetName = 'DBComissaoFunc'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = 'R$ ###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
        end
        object DBComissaoFuncCODFUNCIONARIO: TfrxMemoView
          Top = 3.779530000000000000
          Width = 49.133890000000000000
          Height = 18.897650000000000000
          DataField = 'CODFUNCIONARIO'
          DataSet = DBComissaoFunc
          DataSetName = 'DBComissaoFunc'
          Memo.UTF8W = (
            '[DBComissaoFunc."CODFUNCIONARIO"]')
        end
      end
      object Footer1: TfrxFooter
        FillType = ftBrush
        Height = 22.677180000000000000
        Top = 238.110390000000000000
        Width = 831.496600000000000000
      end
    end
  end
  object DBComissaoFunc: TfrxDBDataset
    UserName = 'DBComissaoFunc'
    CloseDataSource = False
    FieldAliases.Strings = (
      'VENDA_TOTAL=VENDA_TOTAL'
      'CANCELADO=CANCELADO'
      'CODFUNCIONARIO=CODFUNCIONARIO'
      'COMISSAO=COMISSAO'
      'NOME=NOME')
    DataSet = qrRelComissaoFunc
    BCDToCurrency = False
    Left = 72
    Top = 160
  end
  object qrRelFunFuncionarios: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from funcionario')
    Left = 168
    Top = 120
    object qrRelFunFuncionariosCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 6
    end
    object qrRelFunFuncionariosNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object qrRelFunFuncionariosAPELIDO: TStringField
      FieldName = 'APELIDO'
      Size = 100
    end
    object qrRelFunFuncionariosEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 100
    end
    object qrRelFunFuncionariosCPF: TStringField
      FieldName = 'CPF'
      Required = True
      Size = 14
    end
    object qrRelFunFuncionariosCARGO: TIntegerField
      FieldName = 'CARGO'
    end
    object qrRelFunFuncionariosSENHA: TStringField
      FieldName = 'SENHA'
      Size = 255
    end
    object qrRelFunFuncionariosCOMISSAO: TFloatField
      FieldName = 'COMISSAO'
    end
  end
end
