object dmProduto: TdmProduto
  OldCreateOrder = False
  Height = 300
  Width = 472
  object qrProdutoPesq: TUniQuery
    Connection = dmConexao.conexao
    SpecificOptions.Strings = (
      'InterBase.FetchAll=True')
    Left = 72
    Top = 24
  end
  object qrProdutoInserir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'UPDATE OR insert into PRODUTO (CODIGO, CODIGO_BARRAS, DESCRICAO,' +
        ' GRUPO, SUBGRUPO, FORNECEDOR, TRIBUTACAO, NCM, CEST, VALIDADE,'
      
        '                     BALANCA, FRACIONADO, CUSTO, PRECO, MARGEM, ' +
        'ESTOQUE, UNIDADE, INATIVO, DIVERSOS, DATA_CADASTRO,'
      
        '                     DATA_ALTERADO, PENDENTE,ESTOQUE_MINIMO,ESTO' +
        'QUE_MAXIMO,OBSERVACAO)'
      
        'values (:CODIGO, :CODIGO_BARRAS, :DESCRICAO, :GRUPO, :SUBGRUPO, ' +
        ':FORNECEDOR, :TRIBUTACAO, :NCM, :CEST, :VALIDADE,'
      
        '        :BALANCA, :FRACIONADO, :CUSTO, :PRECO, :MARGEM, :ESTOQUE' +
        ', :UNIDADE, :INATIVO, :DIVERSOS, :DATA_CADASTRO,'
      
        '        :DATA_ALTERADO, :PENDENTE,:ESTOQUE_MINIMO,:ESTOQUE_MAXIM' +
        'O,:OBSERVACAO)  ')
    Left = 264
    Top = 24
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO_BARRAS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DESCRICAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'GRUPO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'SUBGRUPO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FORNECEDOR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TRIBUTACAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NCM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CEST'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALIDADE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BALANCA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FRACIONADO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CUSTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PRECO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'MARGEM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ESTOQUE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UNIDADE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'INATIVO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DIVERSOS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATA_CADASTRO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATA_ALTERADO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PENDENTE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ESTOQUE_MINIMO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ESTOQUE_MAXIMO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'OBSERVACAO'
        Value = nil
      end>
  end
  object qrProdutoAlterar: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'update PRODUTO'
      'set CODIGO_BARRAS = :CODIGO_BARRAS,'
      '    DESCRICAO = :DESCRICAO,'
      '    GRUPO = :GRUPO,'
      '    SUBGRUPO = :SUBGRUPO,'
      '    FORNECEDOR = :FORNECEDOR,'
      '    TRIBUTACAO = :TRIBUTACAO,'
      '    NCM = :NCM,'
      '    CEST = :CEST,'
      '    VALIDADE = :VALIDADE,'
      '    BALANCA = :BALANCA,'
      '    FRACIONADO = :FRACIONADO,'
      '    CUSTO = :CUSTO,'
      '    PRECO = :PRECO,'
      '    MARGEM = :MARGEM,'
      '    ESTOQUE = :ESTOQUE,'
      '    UNIDADE = :UNIDADE,'
      '    INATIVO = :INATIVO,'
      '    DIVERSOS = :DIVERSOS,'
      '    DATA_CADASTRO = :DATA_CADASTRO,'
      '    DATA_ALTERADO = :DATA_ALTERADO,'
      '    PENDENTE = :PENDENTE,'
      '    ESTOQUE_MINIMO = :ESTOQUE_MINIMO,'
      '    ESTOQUE_MAXIMO = :ESTOQUE_MAXIMO,'
      'OBSERVACAO = :OBSERVACAO'
      'where (CODIGO = :CODIGO)   ')
    Left = 176
    Top = 24
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO_BARRAS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DESCRICAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'GRUPO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'SUBGRUPO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FORNECEDOR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TRIBUTACAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NCM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CEST'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALIDADE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BALANCA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FRACIONADO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CUSTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PRECO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'MARGEM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ESTOQUE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UNIDADE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'INATIVO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DIVERSOS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATA_CADASTRO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATA_ALTERADO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PENDENTE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ESTOQUE_MINIMO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ESTOQUE_MAXIMO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'OBSERVACAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
  end
  object qrProdutoExcluir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'delete from produto where codigo = :codigo')
    Left = 352
    Top = 24
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
  end
  object qrGridProduto: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from produto')
    Left = 152
    Top = 112
    object qrGridProdutoCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 6
    end
    object qrGridProdutoCODIGO_BARRAS: TStringField
      FieldName = 'CODIGO_BARRAS'
      Required = True
      Size = 14
    end
    object qrGridProdutoDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 80
    end
    object qrGridProdutoGRUPO: TStringField
      FieldName = 'GRUPO'
      Size = 6
    end
    object qrGridProdutoSUBGRUPO: TStringField
      FieldName = 'SUBGRUPO'
      Size = 6
    end
    object qrGridProdutoFORNECEDOR: TStringField
      FieldName = 'FORNECEDOR'
      Size = 6
    end
    object qrGridProdutoTRIBUTACAO: TStringField
      FieldName = 'TRIBUTACAO'
      Size = 3
    end
    object qrGridProdutoNCM: TStringField
      FieldName = 'NCM'
      Size = 8
    end
    object qrGridProdutoCEST: TStringField
      FieldName = 'CEST'
      Size = 7
    end
    object qrGridProdutoVALIDADE: TStringField
      FieldName = 'VALIDADE'
      Size = 3
    end
    object qrGridProdutoBALANCA: TIntegerField
      FieldName = 'BALANCA'
    end
    object qrGridProdutoFRACIONADO: TIntegerField
      FieldName = 'FRACIONADO'
    end
    object qrGridProdutoCUSTO: TFloatField
      FieldName = 'CUSTO'
      DisplayFormat = '###,###,##0.00'
    end
    object qrGridProdutoPRECO: TFloatField
      FieldName = 'PRECO'
      DisplayFormat = '###,###,##0.00'
    end
    object qrGridProdutoMARGEM: TFloatField
      FieldName = 'MARGEM'
    end
    object qrGridProdutoESTOQUE: TFloatField
      FieldName = 'ESTOQUE'
      DisplayFormat = '###,###,##0.00'
    end
    object qrGridProdutoUNIDADE: TStringField
      FieldName = 'UNIDADE'
      Size = 3
    end
    object qrGridProdutoINATIVO: TIntegerField
      FieldName = 'INATIVO'
    end
    object qrGridProdutoDIVERSOS: TIntegerField
      FieldName = 'DIVERSOS'
    end
    object qrGridProdutoDATA_CADASTRO: TDateField
      FieldName = 'DATA_CADASTRO'
    end
    object qrGridProdutoDATA_ALTERADO: TDateField
      FieldName = 'DATA_ALTERADO'
    end
    object qrGridProdutoPENDENTE: TIntegerField
      FieldName = 'PENDENTE'
    end
  end
  object qrProduto: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from PRODUTO')
    Left = 63
    Top = 112
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
  end
  object qrEtiquetaInserir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'insert into ETIQUETA ( CODIGO, CODIGO_BARRAS, PRODUTO, UNIDADE, ' +
        'PRECO,VALIDADE)'
      
        'values (:CODIGO, :CODIGO_BARRAS, :PRODUTO, :UNIDADE, :PRECO,:VAL' +
        'IDADE)  ')
    Left = 72
    Top = 232
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO_BARRAS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PRODUTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UNIDADE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PRECO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALIDADE'
        Value = nil
      end>
  end
  object qrGridEtiqueta_old: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'SELECT id,'
      ''
      '       produto.codigo AS codigo,'
      '       produto,'
      '       produto.codigo_barras,'
      '       produto.unidade,'
      '       produto.preco,'
      '       produto.validade,'
      '       produto.observacao,'
      'PRODUTO.PRECO2,'
      'PRODUTO.PRECO2_QTD,'
      'PRODUTO.PRECO3,'
      'PRODUTO.PRECO3_QTD,'
      '       0              AS ID_1,'
      '       '#39#39'             AS CODIGO_PRODUTO,'
      '       '#39#39'             AS LOCALIZACAO,'
      '       0.01           AS QUANTIDADE,'
      '       CURRENT_DATE   AS VALIDADE_1,'
      '       0              AS SITUACAO,'
      '       0              AS DIAS_VENCER,'
      '       CURRENT_DATE   AS DATA_ENTRADA,'
      '       0              AS SELECIONADO,'
      '       0              AS PROXIMO_VENCIMENTO,'
      '       '#39#39'             AS LOTE'
      ''
      ''
      'FROM   etiqueta'
      '       LEFT JOIN produto'
      '              ON etiqueta.codigo = produto.codigo')
    Left = 368
    Top = 240
    object qrGridEtiqueta_oldID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object qrGridEtiqueta_oldCODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 6
    end
    object qrGridEtiqueta_oldCODIGO_BARRAS: TStringField
      FieldName = 'CODIGO_BARRAS'
      Size = 14
    end
    object qrGridEtiqueta_oldPRODUTO: TStringField
      FieldName = 'PRODUTO'
      Size = 80
    end
    object qrGridEtiqueta_oldUNIDADE: TStringField
      FieldName = 'UNIDADE'
      Size = 3
    end
    object qrGridEtiqueta_oldPRECO: TFloatField
      FieldName = 'PRECO'
    end
    object qrGridEtiqueta_oldID_1: TIntegerField
      FieldName = 'ID_1'
      ReadOnly = True
    end
    object qrGridEtiqueta_oldCODIGO_PRODUTO: TStringField
      FieldName = 'CODIGO_PRODUTO'
      ReadOnly = True
      Size = 6
    end
    object qrGridEtiqueta_oldLOCALIZACAO: TStringField
      FieldName = 'LOCALIZACAO'
      ReadOnly = True
      Size = 40
    end
    object qrGridEtiqueta_oldQUANTIDADE: TFloatField
      FieldName = 'QUANTIDADE'
      ReadOnly = True
    end
    object qrGridEtiqueta_oldVALIDADE_1: TDateField
      FieldName = 'VALIDADE_1'
      ReadOnly = True
    end
    object qrGridEtiqueta_oldSITUACAO: TIntegerField
      FieldName = 'SITUACAO'
      ReadOnly = True
    end
    object qrGridEtiqueta_oldDIAS_VENCER: TIntegerField
      FieldName = 'DIAS_VENCER'
      ReadOnly = True
    end
    object qrGridEtiqueta_oldDATA_ENTRADA: TDateField
      FieldName = 'DATA_ENTRADA'
      ReadOnly = True
    end
    object qrGridEtiqueta_oldSELECIONADO: TIntegerField
      FieldName = 'SELECIONADO'
      ReadOnly = True
    end
    object qrGridEtiqueta_oldPROXIMO_VENCIMENTO: TIntegerField
      FieldName = 'PROXIMO_VENCIMENTO'
      ReadOnly = True
    end
    object qrGridEtiqueta_oldLOTE: TStringField
      FieldName = 'LOTE'
      ReadOnly = True
      Size = 200
    end
    object qrGridEtiqueta_oldOBSERVACAO: TStringField
      FieldName = 'OBSERVACAO'
      ReadOnly = True
      Size = 255
    end
    object qrGridEtiqueta_oldVALIDADE: TStringField
      FieldName = 'VALIDADE'
      ReadOnly = True
      Size = 3
    end
    object qrGridEtiqueta_oldPRECO2: TFloatField
      FieldName = 'PRECO2'
      ReadOnly = True
    end
    object qrGridEtiqueta_oldPRECO2_QTD: TFloatField
      FieldName = 'PRECO2_QTD'
      ReadOnly = True
    end
    object qrGridEtiqueta_oldPRECO3: TFloatField
      FieldName = 'PRECO3'
      ReadOnly = True
    end
    object qrGridEtiqueta_oldPRECO3_QTD: TFloatField
      FieldName = 'PRECO3_QTD'
      ReadOnly = True
    end
  end
  object dbGridEtiqueta: TfrxDBDataset
    UserName = 'gridEtiqueta'
    CloseDataSource = False
    FieldAliases.Strings = (
      'ID=ID'
      'CODIGO=CODIGO'
      'CODIGO_BARRAS=CODIGO_BARRAS'
      'PRODUTO=PRODUTO'
      'UNIDADE=UNIDADE'
      'PRECO=PRECO'
      'VALIDADE=VALIDADE')
    DataSet = qrGridEtiqueta
    BCDToCurrency = False
    Left = 240
    Top = 184
  end
  object frxEtiqueta: TfrxReport
    Version = '5.2.3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Padr'#227'o'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 44147.721607500010000000
    ReportOptions.LastChange = 44511.501581261570000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 392
    Top = 104
    Datasets = <
      item
        DataSet = dbGridEtiqueta
        DataSetName = 'gridEtiqueta'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 100.000000000000000000
      PaperHeight = 30.000000000000000000
      PaperSize = 256
      ResetPageNumbers = True
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 94.488250000000000000
        Top = 18.897650000000000000
        Width = 377.953000000000000000
        DataSet = dbGridEtiqueta
        DataSetName = 'gridEtiqueta'
        RowCount = 0
        object CODIGO_BARRAS: TfrxBarCodeView
          Left = 30.236240000000000000
          Top = 37.795300000000000000
          Width = 79.000000000000000000
          Height = 56.692950000000000000
          BarType = bcCode128
          Expression = '<gridEtiqueta."CODIGO_BARRAS">'
          Rotation = 0
          Text = '12345678'
          WideBarRatio = 2.000000000000000000
          Zoom = 1.000000000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
        end
        object UN: TfrxMemoView
          Left = 166.299320000000000000
          Top = 30.236240000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            '[gridEtiqueta."UNIDADE"]')
          ParentFont = False
        end
        object DESCRICAO_PRODUTO: TfrxMemoView
          Left = 26.456710000000000000
          Top = 3.779530000000000000
          Width = 400.630180000000000000
          Height = 22.677180000000000000
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            '[gridEtiqueta."PRODUTO"]')
          ParentFont = False
        end
        object VALOR_PRODUTO: TfrxMemoView
          Left = 162.519790000000000000
          Top = 52.913420000000000000
          Width = 173.858380000000000000
          Height = 22.677180000000000000
          DataSetName = 'frxDBDataset1'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8W = (
            'R$ [gridEtiqueta."PRECO"]')
          ParentFont = False
        end
        object OBSERVACAO: TfrxMemoView
          Left = 207.874150000000000000
          Top = 75.590600000000000000
          Width = 94.488250000000000000
          Height = 15.118120000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
      end
    end
  end
  object frxBarCodeObject1: TfrxBarCodeObject
    Left = 304
    Top = 104
  end
  object qrGridEtiqueta: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from etiqueta')
    Left = 160
    Top = 200
    object qrGridEtiquetaID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object qrGridEtiquetaCODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 6
    end
    object qrGridEtiquetaCODIGO_BARRAS: TStringField
      FieldName = 'CODIGO_BARRAS'
      Size = 14
    end
    object qrGridEtiquetaPRODUTO: TStringField
      FieldName = 'PRODUTO'
      Size = 80
    end
    object qrGridEtiquetaUNIDADE: TStringField
      FieldName = 'UNIDADE'
      Size = 3
    end
    object qrGridEtiquetaPRECO: TFloatField
      FieldName = 'PRECO'
    end
    object qrGridEtiquetaVALIDADE: TIntegerField
      FieldName = 'VALIDADE'
    end
  end
  object dbGridEtiqueta_old: TfrxDBDataset
    UserName = 'gridEtiqueta'
    CloseDataSource = False
    FieldAliases.Strings = (
      'ID=ID'
      'CODIGO=CODIGO'
      'CODIGO_BARRAS=CODIGO_BARRAS'
      'PRODUTO=PRODUTO'
      'UNIDADE=UNIDADE'
      'PRECO=PRECO'
      'ID_1=ID_1'
      'CODIGO_PRODUTO=CODIGO_PRODUTO'
      'LOCALIZACAO=LOCALIZACAO'
      'QUANTIDADE=QUANTIDADE'
      'VALIDADE_1=VALIDADE_1'
      'SITUACAO=SITUACAO'
      'DIAS_VENCER=DIAS_VENCER'
      'DATA_ENTRADA=DATA_ENTRADA'
      'SELECIONADO=SELECIONADO'
      'PROXIMO_VENCIMENTO=PROXIMO_VENCIMENTO'
      'LOTE=LOTE'
      'OBSERVACAO=OBSERVACAO'
      'VALIDADE=VALIDADE'
      'PRECO2=PRECO2'
      'PRECO2_QTD=PRECO2_QTD'
      'PRECO3=PRECO3'
      'PRECO3_QTD=PRECO3_QTD')
    DataSet = qrGridEtiqueta_old
    BCDToCurrency = False
    Left = 408
    Top = 192
  end
end
