object dmRelEstoque: TdmRelEstoque
  OldCreateOrder = False
  Height = 398
  Width = 526
  object qrRelEstoque: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'select codigo_barras,unidade,descricao,estoque,estoque_minimo,es' +
        'toque_maximo,custo,preco,fornecedor,grupo from produto order by ' +
        '3')
    MasterSource = FornecedorDetalhe
    MasterFields = 'CODIGO'
    DetailFields = 'FORNECEDOR'
    Left = 112
    Top = 16
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
    object qrRelEstoqueCODIGO_BARRAS: TStringField
      FieldName = 'CODIGO_BARRAS'
      Required = True
      Size = 14
    end
    object qrRelEstoqueUNIDADE: TStringField
      FieldName = 'UNIDADE'
      Size = 3
    end
    object qrRelEstoqueDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 80
    end
    object qrRelEstoqueESTOQUE: TFloatField
      FieldName = 'ESTOQUE'
    end
    object qrRelEstoqueCUSTO: TFloatField
      FieldName = 'CUSTO'
    end
    object qrRelEstoquePRECO: TFloatField
      FieldName = 'PRECO'
    end
    object qrRelEstoqueESTOQUE_MINIMO: TFloatField
      FieldName = 'ESTOQUE_MINIMO'
    end
    object qrRelEstoqueESTOQUE_MAXIMO: TFloatField
      FieldName = 'ESTOQUE_MAXIMO'
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
    ReportOptions.LastChange = 44883.700250995370000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      'end.          ')
    Left = 12
    Top = 10
    Datasets = <
      item
        DataSet = DBExtratoEstoque
        DataSetName = 'DBExtratoEstoque'
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
      PaperWidth = 350.000000000000000000
      PaperHeight = 210.000000000000000000
      PaperSize = 256
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        Height = 109.606370000000000000
        Top = 18.897650000000000000
        Width = 1247.244900000000000000
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
          Width = 1727.245210000000000000
          Color = clBlack
          Diagonal = True
        end
        object Line1: TfrxLineView
          Top = 60.472480000000000000
          Width = 1678.111320000000000000
          Color = clBlack
          Frame.Typ = [ftTop]
        end
        object Memo8: TfrxMemoView
          Top = 83.149606300000000000
          Width = 86.929190000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            'Data')
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
          Left = 117.165430000000000000
          Top = 83.149660000000000000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            'Hora')
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          Left = 548.031849999999900000
          Top = 83.149660000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            'Produto'
            '')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          Left = 1028.032160000000000000
          Top = 83.149660000000000000
          Width = 238.110390000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            'Origem')
          ParentFont = False
        end
        object Memo14: TfrxMemoView
          Left = 374.173470000000000000
          Top = 83.149660000000000000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            'C'#243'd. Barras')
          ParentFont = False
        end
        object Memo15: TfrxMemoView
          Left = 729.449290000000000000
          Top = 83.149660000000000000
          Width = 90.708720000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            'C'#243'd. Fun.')
          ParentFont = False
        end
        object Memo17: TfrxMemoView
          Left = 827.717070000000000000
          Top = 83.149660000000000000
          Width = 158.740260000000000000
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
        object Memo5: TfrxMemoView
          Left = 207.874150000000000000
          Top = 83.149660000000000000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haCenter
          Memo.UTF8W = (
            'Quantidade')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 26.456710000000000000
        Top = 188.976500000000000000
        Width = 1247.244900000000000000
        DataSet = DBExtratoEstoque
        DataSetName = 'DBExtratoEstoque'
        RowCount = 0
        object DBExtratoEstoqueDATA: TfrxMemoView
          Left = 18.897650000000000000
          Top = 3.779529999999994000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'DATA'
          DataSet = DBExtratoEstoque
          DataSetName = 'DBExtratoEstoque'
          Highlight.Font.Charset = DEFAULT_CHARSET
          Highlight.Font.Color = clBlack
          Highlight.Font.Height = -13
          Highlight.Font.Name = 'Arial'
          Highlight.Font.Style = []
          Highlight.Condition = '(<Line#>mod 2) = 0'
          Highlight.FillType = ftBrush
          Highlight.Fill.BackColor = 15329769
          Memo.UTF8W = (
            '[DBExtratoEstoque."DATA"]')
        end
        object DBExtratoEstoqueHORA: TfrxMemoView
          Left = 117.165430000000000000
          Top = 3.779529999999994000
          Width = 79.370130000000000000
          Height = 18.897650000000000000
          DataField = 'HORA'
          DataSet = DBExtratoEstoque
          DataSetName = 'DBExtratoEstoque'
          Highlight.Font.Charset = DEFAULT_CHARSET
          Highlight.Font.Color = clBlack
          Highlight.Font.Height = -13
          Highlight.Font.Name = 'Arial'
          Highlight.Font.Style = []
          Highlight.Condition = '(<Line#>mod 2) = 0'
          Highlight.FillType = ftBrush
          Highlight.Fill.BackColor = 15329769
          Memo.UTF8W = (
            '[DBExtratoEstoque."HORA"]')
        end
        object DBExtratoEstoqueQTDE: TfrxMemoView
          Left = 207.874150000000000000
          Top = 3.779529999999994000
          Width = 120.944960000000000000
          Height = 18.897650000000000000
          DataField = 'QTDE'
          DataSet = DBExtratoEstoque
          DataSetName = 'DBExtratoEstoque'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.ThousandSeparator = '.'
          DisplayFormat.FormatStr = '###,###,##0.00'
          DisplayFormat.Kind = fkNumeric
          Highlight.Font.Charset = DEFAULT_CHARSET
          Highlight.Font.Color = clBlack
          Highlight.Font.Height = -13
          Highlight.Font.Name = 'Arial'
          Highlight.Font.Style = []
          Highlight.Condition = '(<Line#>mod 2) = 0'
          Highlight.FillType = ftBrush
          Highlight.Fill.BackColor = 15329769
          Memo.UTF8W = (
            '[DBExtratoEstoque."QTDE"]')
        end
        object DBExtratoEstoqueORIGEM: TfrxMemoView
          Left = 1028.032160000000000000
          Top = 3.779529999999994000
          Width = 238.110390000000000000
          Height = 18.897650000000000000
          DataField = 'ORIGEM'
          DataSet = DBExtratoEstoque
          DataSetName = 'DBExtratoEstoque'
          Highlight.Font.Charset = DEFAULT_CHARSET
          Highlight.Font.Color = clBlack
          Highlight.Font.Height = -13
          Highlight.Font.Name = 'Arial'
          Highlight.Font.Style = []
          Highlight.Condition = '(<Line#>mod 2) = 0'
          Highlight.FillType = ftBrush
          Highlight.Fill.BackColor = 15329769
          Memo.UTF8W = (
            '[DBExtratoEstoque."ORIGEM"]')
        end
        object DBExtratoEstoquePRODUTODESC: TfrxMemoView
          Left = 548.031849999999900000
          Top = 3.779529999999994000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataField = 'PRODUTODESC'
          DataSet = DBExtratoEstoque
          DataSetName = 'DBExtratoEstoque'
          Highlight.Font.Charset = DEFAULT_CHARSET
          Highlight.Font.Color = clBlack
          Highlight.Font.Height = -13
          Highlight.Font.Name = 'Arial'
          Highlight.Font.Style = []
          Highlight.Condition = '(<Line#>mod 2) = 0'
          Highlight.FillType = ftBrush
          Highlight.Fill.BackColor = 15329769
          Memo.UTF8W = (
            '[DBExtratoEstoque."PRODUTODESC"]')
        end
        object DBExtratoEstoqueCOD_FUNCIONARIO: TfrxMemoView
          Left = 729.449290000000000000
          Top = 3.779529999999994000
          Width = 90.708720000000000000
          Height = 18.897650000000000000
          DataField = 'COD_FUNCIONARIO'
          DataSet = DBExtratoEstoque
          DataSetName = 'DBExtratoEstoque'
          Highlight.Font.Charset = DEFAULT_CHARSET
          Highlight.Font.Color = clBlack
          Highlight.Font.Height = -13
          Highlight.Font.Name = 'Arial'
          Highlight.Font.Style = []
          Highlight.Condition = '(<Line#>mod 2) = 0'
          Highlight.FillType = ftBrush
          Highlight.Fill.BackColor = 15329769
          Memo.UTF8W = (
            '[DBExtratoEstoque."COD_FUNCIONARIO"]')
        end
        object DBExtratoEstoqueFUNCIONARIO: TfrxMemoView
          Left = 827.717070000000000000
          Top = 3.779529999999994000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataField = 'FUNCIONARIO'
          DataSet = DBExtratoEstoque
          DataSetName = 'DBExtratoEstoque'
          Highlight.Font.Charset = DEFAULT_CHARSET
          Highlight.Font.Color = clBlack
          Highlight.Font.Height = -13
          Highlight.Font.Name = 'Arial'
          Highlight.Font.Style = []
          Highlight.Condition = '(<Line#>mod 2) = 0'
          Highlight.FillType = ftBrush
          Highlight.Fill.BackColor = 15329769
          Memo.UTF8W = (
            '[DBExtratoEstoque."FUNCIONARIO"]')
        end
        object DBExtratoEstoquePRODUTOCOD: TfrxMemoView
          Left = 374.173470000000000000
          Top = 3.779529999999994000
          Width = 158.740260000000000000
          Height = 18.897650000000000000
          DataField = 'PRODUTOCOD'
          DataSet = DBExtratoEstoque
          DataSetName = 'DBExtratoEstoque'
          Highlight.Font.Charset = DEFAULT_CHARSET
          Highlight.Font.Color = clBlack
          Highlight.Font.Height = -13
          Highlight.Font.Name = 'Arial'
          Highlight.Font.Style = []
          Highlight.Condition = '(<Line#>mod 2) = 0'
          Highlight.FillType = ftBrush
          Highlight.Fill.BackColor = 15329769
          Memo.UTF8W = (
            '[DBExtratoEstoque."PRODUTOCOD"]')
        end
      end
      object Footer1: TfrxFooter
        FillType = ftBrush
        Height = 22.677180000000000000
        Top = 238.110390000000000000
        Width = 1247.244900000000000000
      end
    end
  end
  object DBSaldoEstoque: TfrxDBDataset
    UserName = 'DBSaldoEstoque'
    CloseDataSource = False
    FieldAliases.Strings = (
      'CODIGO_BARRAS=CODIGO_BARRAS'
      'UNIDADE=UNIDADE'
      'DESCRICAO=DESCRICAO'
      'ESTOQUE=ESTOQUE'
      'CUSTO=CUSTO'
      'PRECO=PRECO'
      'ESTOQUE_MINIMO=ESTOQUE_MINIMO'
      'ESTOQUE_MAXIMO=ESTOQUE_MAXIMO')
    DataSet = qrRelEstoque
    BCDToCurrency = False
    Left = 24
    Top = 96
  end
  object qrFornecedor: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from fornecedor')
    Left = 192
    Top = 16
    object qrFornecedorCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 6
    end
    object qrFornecedorNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object qrFornecedorNOME_FANTASIA: TStringField
      FieldName = 'NOME_FANTASIA'
      Size = 80
    end
    object qrFornecedorENDERECO: TStringField
      FieldName = 'ENDERECO'
      Size = 45
    end
    object qrFornecedorNUMERO: TStringField
      FieldName = 'NUMERO'
      Size = 15
    end
    object qrFornecedorBAIRRO: TStringField
      FieldName = 'BAIRRO'
      Size = 50
    end
    object qrFornecedorCIDADE: TStringField
      FieldName = 'CIDADE'
      Size = 40
    end
    object qrFornecedorUF: TStringField
      FieldName = 'UF'
      FixedChar = True
      Size = 2
    end
    object qrFornecedorCEP: TStringField
      FieldName = 'CEP'
      Size = 10
    end
    object qrFornecedorCOMPLEMENTO: TStringField
      FieldName = 'COMPLEMENTO'
    end
    object qrFornecedorTELEFONE1: TStringField
      FieldName = 'TELEFONE1'
      Size = 15
    end
    object qrFornecedorTELEFONE2: TStringField
      FieldName = 'TELEFONE2'
      Size = 15
    end
    object qrFornecedorCELULAR: TStringField
      FieldName = 'CELULAR'
      FixedChar = True
      Size = 15
    end
    object qrFornecedorEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 100
    end
    object qrFornecedorCNPJCPF: TStringField
      FieldName = 'CNPJCPF'
      Required = True
      Size = 14
    end
    object qrFornecedorIE: TStringField
      FieldName = 'IE'
    end
    object qrFornecedorIM: TStringField
      FieldName = 'IM'
      Size = 25
    end
    object qrFornecedorOBSERVACAO: TMemoField
      FieldName = 'OBSERVACAO'
      BlobType = ftMemo
    end
    object qrFornecedorCONTATO1: TStringField
      FieldName = 'CONTATO1'
      Size = 50
    end
    object qrFornecedorCONTATO2: TStringField
      FieldName = 'CONTATO2'
      Size = 50
    end
  end
  object DBFornecedor: TfrxDBDataset
    UserName = 'Fornecedor'
    CloseDataSource = False
    FieldAliases.Strings = (
      'CODIGO=CODIGO'
      'NOME=NOME'
      'NOME_FANTASIA=NOME_FANTASIA'
      'ENDERECO=ENDERECO'
      'NUMERO=NUMERO'
      'BAIRRO=BAIRRO'
      'CIDADE=CIDADE'
      'UF=UF'
      'CEP=CEP'
      'COMPLEMENTO=COMPLEMENTO'
      'TELEFONE1=TELEFONE1'
      'TELEFONE2=TELEFONE2'
      'CELULAR=CELULAR'
      'EMAIL=EMAIL'
      'CNPJCPF=CNPJCPF'
      'IE=IE'
      'IM=IM'
      'OBSERVACAO=OBSERVACAO'
      'CONTATO1=CONTATO1'
      'CONTATO2=CONTATO2')
    DataSet = qrFornecedor
    BCDToCurrency = False
    Left = 280
    Top = 16
  end
  object FornecedorDetalhe: TUniDataSource
    DataSet = qrFornecedor
    Left = 376
    Top = 16
  end
  object qrGrupo: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from grupo')
    Left = 200
    Top = 88
    object qrGrupoCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 6
    end
    object qrGrupoGRUPO: TStringField
      FieldName = 'GRUPO'
      Size = 40
    end
  end
  object DBGrupo: TfrxDBDataset
    UserName = 'DBGrupo'
    CloseDataSource = False
    FieldAliases.Strings = (
      'CODIGO=CODIGO'
      'GRUPO=GRUPO')
    DataSet = qrGrupo
    BCDToCurrency = False
    Left = 280
    Top = 88
  end
  object GrupoDetalhe: TUniDataSource
    DataSet = qrGrupo
    Left = 376
    Top = 88
  end
  object qrSubGrupo: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from subgrupo')
    Left = 200
    Top = 160
    object qrSubGrupoCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 6
    end
    object qrSubGrupoCODIGO_GRUPO: TStringField
      FieldName = 'CODIGO_GRUPO'
      Required = True
      Size = 6
    end
    object qrSubGrupoSUBGRUPO: TStringField
      FieldName = 'SUBGRUPO'
      Size = 40
    end
    object qrSubGrupoGRUPO_DESCRICAO: TStringField
      FieldKind = fkLookup
      FieldName = 'GRUPO_DESCRICAO'
      LookupDataSet = qrGrupo
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'GRUPO'
      KeyFields = 'CODIGO_GRUPO'
      Lookup = True
    end
  end
  object DBSubGrupo: TfrxDBDataset
    UserName = 'DBSubGrupo'
    CloseDataSource = False
    FieldAliases.Strings = (
      'CODIGO=CODIGO'
      'CODIGO_GRUPO=CODIGO_GRUPO'
      'SUBGRUPO=SUBGRUPO'
      'GRUPO_DESCRICAO=GRUPO_DESCRICAO')
    DataSet = qrSubGrupo
    BCDToCurrency = False
    Left = 280
    Top = 160
  end
  object SubGrupoDetalhe: TUniDataSource
    DataSet = qrSubGrupo
    Left = 376
    Top = 160
  end
  object DBExtratoEstoque: TfrxDBDataset
    UserName = 'DBExtratoEstoque'
    CloseDataSource = False
    FieldAliases.Strings = (
      'ID=ID'
      'TIPO=TIPO'
      'QTDE=QTDE'
      'DATA=DATA'
      'HORA=HORA'
      'CODPRODUTO=CODPRODUTO'
      'COD_CUPOM=COD_CUPOM'
      'ITEM=ITEM'
      'COD_FUNCIONARIO=COD_FUNCIONARIO'
      'ORIGEM=ORIGEM'
      'PRODUTODESC=PRODUTODESC'
      'FUNCIONARIO=FUNCIONARIO'
      'PRODUTOCOD=PRODUTOCOD')
    DataSet = qrRelExtratoEstoque
    BCDToCurrency = False
    Left = 32
    Top = 256
  end
  object qrRelExtratoEstoque: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from ESTOQUE_MOVIMENTACAO')
    Left = 136
    Top = 257
    object qrRelExtratoEstoqueID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object qrRelExtratoEstoqueTIPO: TIntegerField
      FieldName = 'TIPO'
    end
    object qrRelExtratoEstoqueQTDE: TFloatField
      FieldName = 'QTDE'
    end
    object qrRelExtratoEstoqueDATA: TDateField
      FieldName = 'DATA'
    end
    object qrRelExtratoEstoqueHORA: TTimeField
      FieldName = 'HORA'
    end
    object qrRelExtratoEstoqueCODPRODUTO: TStringField
      FieldName = 'CODPRODUTO'
      Size = 6
    end
    object qrRelExtratoEstoqueCOD_CUPOM: TStringField
      FieldName = 'COD_CUPOM'
      Size = 50
    end
    object qrRelExtratoEstoqueITEM: TIntegerField
      FieldName = 'ITEM'
    end
    object qrRelExtratoEstoqueCOD_FUNCIONARIO: TStringField
      FieldName = 'COD_FUNCIONARIO'
      Size = 6
    end
    object qrRelExtratoEstoqueORIGEM: TStringField
      FieldName = 'ORIGEM'
      Size = 30
    end
    object qrRelExtratoEstoquePRODUTODESC: TStringField
      FieldKind = fkLookup
      FieldName = 'PRODUTODESC'
      LookupDataSet = qrProduto
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'CODPRODUTO'
      Lookup = True
    end
    object qrRelExtratoEstoqueFUNCIONARIO: TStringField
      FieldKind = fkLookup
      FieldName = 'FUNCIONARIO'
      LookupDataSet = qrFuncionario
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'NOME'
      KeyFields = 'COD_FUNCIONARIO'
      Lookup = True
    end
    object qrRelExtratoEstoquePRODUTOCOD: TStringField
      FieldKind = fkLookup
      FieldName = 'PRODUTOCOD'
      LookupDataSet = qrProduto
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'CODIGO_BARRAS'
      KeyFields = 'CODPRODUTO'
      Lookup = True
    end
  end
  object qrProduto: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from produto')
    Left = 224
    Top = 256
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
  object qrFuncionario: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from funcionario'
      '')
    Left = 312
    Top = 256
    object qrFuncionarioCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 6
    end
    object qrFuncionarioNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object qrFuncionarioAPELIDO: TStringField
      FieldName = 'APELIDO'
      Size = 100
    end
    object qrFuncionarioEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 100
    end
    object qrFuncionarioCPF: TStringField
      FieldName = 'CPF'
      Required = True
      Size = 14
    end
    object qrFuncionarioCARGO: TIntegerField
      FieldName = 'CARGO'
    end
    object qrFuncionarioSENHA: TStringField
      FieldName = 'SENHA'
      Size = 255
    end
    object qrFuncionarioCOMISSAO: TFloatField
      FieldName = 'COMISSAO'
    end
  end
end
