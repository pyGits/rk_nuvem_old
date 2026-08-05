object frmImpressao: TfrmImpressao
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmImpressao'
  ClientHeight = 282
  ClientWidth = 311
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ACBrGIF1: TACBrGIF
    Left = 0
    Top = 0
    Width = 311
    Height = 282
    Align = alClient
    Filename = 'C:\System_RK\PDV\Img\Impressora.gif'
    ExplicitTop = -37
    ExplicitWidth = 344
    ExplicitHeight = 336
  end
  object impressora: TACBrPosPrinter
    Modelo = ppEscPosEpson
    ConfigBarras.MostrarCodigo = False
    ConfigBarras.LarguraLinha = 0
    ConfigBarras.Altura = 0
    ConfigBarras.Margem = 0
    ConfigQRCode.Tipo = 2
    ConfigQRCode.LarguraModulo = 4
    ConfigQRCode.ErrorLevel = 0
    LinhasEntreCupons = 0
    Left = 104
    Top = 40
  end
  object timer_fechar: TTimer
    OnTimer = timer_fecharTimer
    Left = 216
    Top = 88
  end
  object frxReport1: TfrxReport
    Version = '5.2.3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 45537.643214062500000000
    ReportOptions.LastChange = 45537.708249270840000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 128
    Top = 184
    Datasets = <
      item
        DataSet = dmProprio.fxemitente
        DataSetName = 'fxemitente'
      end
      item
        DataSet = frxDBDataset1
        DataSetName = 'prevenda'
      end
      item
        DataSet = frxDBDataset2
        DataSetName = 'prevendaitem'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 287.244280000000000000
        Top = 139.842610000000000000
        Width = 718.110700000000000000
        DataSet = frxDBDataset1
        DataSetName = 'prevenda'
        RowCount = 0
        object frxDBDataset1CODIGO: TfrxMemoView
          Left = 158.740260000000000000
          Top = 11.338590000000010000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataField = 'CODIGO'
          DataSet = frxDBDataset1
          DataSetName = 'prevenda'
          Memo.UTF8W = (
            '[prevenda."CODIGO"]')
        end
        object Memo1: TfrxMemoView
          Left = 11.338590000000000000
          Top = 11.338590000000010000
          Width = 139.842610000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'N'#250'mero Pedido:')
          ParentFont = False
        end
        object Memo2: TfrxMemoView
          Left = 11.338590000000000000
          Top = 45.354360000000010000
          Width = 124.724490000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'Cliente:')
          ParentFont = False
        end
        object prevendaCLIENTE_CODIGO: TfrxMemoView
          Left = 158.740260000000000000
          Top = 45.354359999999990000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataField = 'CLIENTE_CODIGO'
          DataSet = frxDBDataset1
          DataSetName = 'prevenda'
          Memo.UTF8W = (
            '[prevenda."CLIENTE_CODIGO"]')
        end
        object prevendaCLIENTE_NOME: TfrxMemoView
          Left = 158.740260000000000000
          Top = 79.370129999999930000
          Width = 548.031850000000000000
          Height = 18.897650000000000000
          DataField = 'CLIENTE_NOME'
          DataSet = frxDBDataset1
          DataSetName = 'prevenda'
          Memo.UTF8W = (
            '[prevenda."CLIENTE_NOME"]')
        end
        object prevendaCLIENTE_CNPJCPF: TfrxMemoView
          Left = 158.740260000000000000
          Top = 113.385899999999800000
          Width = 207.874150000000000000
          Height = 18.897650000000000000
          DataField = 'CLIENTE_CNPJCPF'
          DataSet = frxDBDataset1
          DataSetName = 'prevenda'
          Memo.UTF8W = (
            '[prevenda."CLIENTE_CNPJCPF"]')
        end
        object prevendaCLIENTE_CEP: TfrxMemoView
          Left = 158.740260000000000000
          Top = 139.842609999999800000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataField = 'CLIENTE_CEP'
          DataSet = frxDBDataset1
          DataSetName = 'prevenda'
          Memo.UTF8W = (
            '[prevenda."CLIENTE_CEP"]')
        end
        object prevendaCLIENTE_ENDERECO: TfrxMemoView
          Left = 158.740260000000000000
          Top = 173.858379999999800000
          Width = 548.031850000000000000
          Height = 18.897650000000000000
          DataField = 'CLIENTE_ENDERECO'
          DataSet = frxDBDataset1
          DataSetName = 'prevenda'
          Memo.UTF8W = (
            '[prevenda."CLIENTE_ENDERECO"]')
        end
        object Line1: TfrxLineView
          Left = 7.559060000000000000
          Top = 37.795300000000000000
          Width = 880.630490000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
        object Memo3: TfrxMemoView
          Left = 11.338590000000000000
          Top = 79.370129999999990000
          Width = 124.724490000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'Nome:')
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          Left = 11.338590000000000000
          Top = 113.385899999999800000
          Width = 124.724490000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'CNPJ/CPF:')
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          Left = 11.338590000000000000
          Top = 143.622139999999900000
          Width = 124.724490000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'CEP:')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          Left = 11.338590000000000000
          Top = 173.858379999999800000
          Width = 124.724490000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'ENDERE'#199'O:')
          ParentFont = False
        end
        object Line2: TfrxLineView
          Left = -34.015770000000000000
          Top = 211.653679999999800000
          Width = 880.630490000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
        object Memo13: TfrxMemoView
          Left = 11.338590000000000000
          Top = 219.212740000000000000
          Width = 124.724490000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'Funcion'#225'rio:')
          ParentFont = False
        end
        object Memo14: TfrxMemoView
          Left = 11.338590000000000000
          Top = 253.228510000000000000
          Width = 124.724490000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'Nome:')
          ParentFont = False
        end
        object prevendaFUNCIONARIO_CODIGO: TfrxMemoView
          Left = 158.740260000000000000
          Top = 219.212740000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataField = 'FUNCIONARIO_CODIGO'
          DataSet = frxDBDataset1
          DataSetName = 'prevenda'
          Memo.UTF8W = (
            '[prevenda."FUNCIONARIO_CODIGO"]')
        end
        object prevendaFUNCIONARIO_NOME: TfrxMemoView
          Left = 158.740260000000000000
          Top = 253.228510000000000000
          Width = 548.031850000000000000
          Height = 18.897650000000000000
          DataField = 'FUNCIONARIO_NOME'
          DataSet = frxDBDataset1
          DataSetName = 'prevenda'
          Memo.UTF8W = (
            '[prevenda."FUNCIONARIO_NOME"]')
        end
      end
      object MasterData2: TfrxMasterData
        FillType = ftBrush
        Height = 22.677180000000000000
        Top = 502.677490000000000000
        Width = 718.110700000000000000
        DataSet = frxDBDataset2
        DataSetName = 'prevendaitem'
        RowCount = 0
        object prevendaitemSEQ: TfrxMemoView
          Left = 9.559060000000000000
          Top = 3.779530000000022000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'SEQ'
          DataSet = frxDBDataset2
          DataSetName = 'prevendaitem'
          Memo.UTF8W = (
            '[prevendaitem."SEQ"]')
        end
        object prevendaitemNOME: TfrxMemoView
          Left = 130.504020000000000000
          Top = 3.779530000000022000
          Width = 362.834880000000000000
          Height = 18.897650000000000000
          DataField = 'NOME'
          DataSet = frxDBDataset2
          DataSetName = 'prevendaitem'
          Memo.UTF8W = (
            '[prevendaitem."NOME"]')
        end
        object prevendaitemQTDE: TfrxMemoView
          Left = 506.457020000000000000
          Top = 3.779530000000022000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'QTDE'
          DataSet = frxDBDataset2
          DataSetName = 'prevendaitem'
          DisplayFormat.FormatStr = '###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[prevendaitem."QTDE"]')
        end
        object prevendaitemTOTAL: TfrxMemoView
          Left = 627.401980000000000000
          Top = 3.779530000000022000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'TOTAL'
          DataSet = frxDBDataset2
          DataSetName = 'prevendaitem'
          DisplayFormat.FormatStr = '###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[prevendaitem."TOTAL"]')
        end
      end
      object Header1: TfrxHeader
        FillType = ftBrush
        Height = 30.236240000000000000
        Top = 449.764070000000000000
        Width = 718.110700000000000000
        object Memo7: TfrxMemoView
          Left = 11.338590000000000000
          Top = 3.779530000000022000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'ITEM')
          ParentFont = False
        end
        object Memo8: TfrxMemoView
          Left = 132.283550000000000000
          Top = 3.779530000000022000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'NOME')
          ParentFont = False
        end
        object Memo9: TfrxMemoView
          Left = 506.457020000000000000
          Top = 3.779530000000022000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'QTD.')
          ParentFont = False
        end
        object Memo10: TfrxMemoView
          Left = 623.622450000000000000
          Top = 3.779530000000022000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'TOTAL')
          ParentFont = False
        end
      end
      object Footer1: TfrxFooter
        FillType = ftBrush
        Height = 45.354360000000000000
        Top = 548.031850000000000000
        Width = 718.110700000000000000
        object prevendaPREVENDA_TOTAL: TfrxMemoView
          Left = 627.401980000000000000
          Top = 18.897650000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'PREVENDA_TOTAL'
          DataSet = frxDBDataset1
          DataSetName = 'prevenda'
          DisplayFormat.FormatStr = '###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Memo.UTF8W = (
            '[prevenda."PREVENDA_TOTAL"]')
        end
        object Memo11: TfrxMemoView
          Left = 540.472790000000000000
          Top = 18.897650000000000000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'TOTAL')
          ParentFont = False
        end
        object Line3: TfrxLineView
          Left = -64.252010000000000000
          Top = 7.559059999999931000
          Width = 880.630490000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
      end
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        Height = 60.472480000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
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
          Left = 600.945270000000100000
          Top = 22.677180000000000000
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
        object Memo12: TfrxMemoView
          Left = 600.945270000000100000
          Top = 41.574830000000000000
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
        object Line4: TfrxLineView
          Top = 60.472479999999990000
          Width = 978.898270000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
      end
    end
  end
  object dbPrevenda: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 184
    Top = 24
    object dbPrevendaCODIGO: TStringField
      FieldName = 'CODIGO'
    end
    object dbPrevendaCLIENTE_CODIGO: TStringField
      FieldName = 'CLIENTE_CODIGO'
    end
    object dbPrevendaCLIENTE_NOME: TStringField
      FieldName = 'CLIENTE_NOME'
    end
    object dbPrevendaCLIENTE_CNPJCPF: TStringField
      FieldName = 'CLIENTE_CNPJCPF'
    end
    object dbPrevendaCLIENTE_CEP: TStringField
      FieldName = 'CLIENTE_CEP'
    end
    object dbPrevendaCLIENTE_ENDERECO: TStringField
      FieldName = 'CLIENTE_ENDERECO'
    end
    object dbPrevendaCLIENTE_NUMERO: TStringField
      FieldName = 'CLIENTE_NUMERO'
    end
    object dbPrevendaCLIENTE_COMPLEMENTO: TStringField
      FieldName = 'CLIENTE_COMPLEMENTO'
    end
    object dbPrevendaPREVENDA_TOTAL: TFloatField
      FieldName = 'PREVENDA_TOTAL'
    end
    object dbPrevendaFUNCIONARIO_CODIGO: TStringField
      FieldName = 'FUNCIONARIO_CODIGO'
    end
    object dbPrevendaFUNCIONARIO_NOME: TStringField
      FieldName = 'FUNCIONARIO_NOME'
    end
  end
  object frxDBDataset1: TfrxDBDataset
    UserName = 'prevenda'
    CloseDataSource = False
    FieldAliases.Strings = (
      'CODIGO=CODIGO'
      'CLIENTE_CODIGO=CLIENTE_CODIGO'
      'CLIENTE_NOME=CLIENTE_NOME'
      'CLIENTE_CNPJCPF=CLIENTE_CNPJCPF'
      'CLIENTE_CEP=CLIENTE_CEP'
      'CLIENTE_ENDERECO=CLIENTE_ENDERECO'
      'CLIENTE_NUMERO=CLIENTE_NUMERO'
      'CLIENTE_COMPLEMENTO=CLIENTE_COMPLEMENTO'
      'PREVENDA_TOTAL=PREVENDA_TOTAL'
      'FUNCIONARIO_CODIGO=FUNCIONARIO_CODIGO'
      'FUNCIONARIO_NOME=FUNCIONARIO_NOME')
    DataSet = dbPrevenda
    BCDToCurrency = False
    Left = 24
    Top = 24
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 128
    Top = 104
    object ClientDataSet1SEQ: TIntegerField
      FieldName = 'SEQ'
    end
    object ClientDataSet1NOME: TStringField
      FieldName = 'NOME'
    end
    object ClientDataSet1QTDE: TFloatField
      FieldName = 'QTDE'
    end
    object ClientDataSet1TOTAL: TFloatField
      FieldName = 'TOTAL'
    end
  end
  object frxDBDataset2: TfrxDBDataset
    UserName = 'prevendaitem'
    CloseDataSource = False
    FieldAliases.Strings = (
      'SEQ=SEQ'
      'NOME=NOME'
      'QTDE=QTDE'
      'TOTAL=TOTAL')
    DataSet = ClientDataSet1
    BCDToCurrency = False
    Left = 24
    Top = 96
  end
end
