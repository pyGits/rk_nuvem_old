object dmPreVenda: TdmPreVenda
  OldCreateOrder = False
  Height = 324
  Width = 426
  object qrPreVendaItemTempInserir: TUniQuery
    Connection = dmConexao.conexao
    Left = 56
    Top = 80
  end
  object qrPreVendaItemTempGrid: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from prevenda_item_temp')
    Left = 56
    Top = 24
    object qrPreVendaItemTempGridCODIGO_PREVENDA: TStringField
      FieldName = 'CODIGO_PREVENDA'
      Required = True
      Size = 9
    end
    object qrPreVendaItemTempGridITEM: TIntegerField
      FieldName = 'ITEM'
    end
    object qrPreVendaItemTempGridCODIGO_BARRAS: TStringField
      FieldName = 'CODIGO_BARRAS'
      Size = 14
    end
    object qrPreVendaItemTempGridVALOR_UNITARIO: TFloatField
      FieldName = 'VALOR_UNITARIO'
      DisplayFormat = '###,###,##0.00'
    end
    object qrPreVendaItemTempGridVALOR_DESCONTO: TFloatField
      FieldName = 'VALOR_DESCONTO'
      DisplayFormat = '###,###,##0.00'
    end
    object qrPreVendaItemTempGridVALOR_ACRESCIMO: TFloatField
      FieldName = 'VALOR_ACRESCIMO'
      DisplayFormat = '###,###,##0.00'
    end
    object qrPreVendaItemTempGridVALOR_TOTAL: TFloatField
      FieldName = 'VALOR_TOTAL'
      DisplayFormat = '###,###,##0.00'
    end
    object qrPreVendaItemTempGridQTDE: TFloatField
      FieldName = 'QTDE'
      DisplayFormat = '###,###,##0.00'
    end
    object qrPreVendaItemTempGridUNIDADE: TStringField
      FieldName = 'UNIDADE'
      Size = 3
    end
    object qrPreVendaItemTempGridPRODUTO: TStringField
      FieldKind = fkLookup
      FieldName = 'PRODUTO'
      LookupDataSet = qrProduto
      LookupKeyFields = 'CODIGO_BARRAS'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'CODIGO_BARRAS'
      Size = 50
      Lookup = True
    end
  end
  object qrProduto: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from produto')
    Left = 160
    Top = 8
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
  end
  object qrPreVendaItemTempDeletar: TUniQuery
    Connection = dmConexao.conexao
    Left = 56
    Top = 144
  end
  object qrPreVendaInserir: TUniQuery
    Connection = dmConexao.conexao
    Left = 272
    Top = 24
  end
  object qrPreVendaItemTempPesq: TUniQuery
    Connection = dmConexao.conexao
    Left = 48
    Top = 216
  end
  object qrPreVendaItemInserir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'update or insert into PREVENDA_ITEM (CODIGO_PREVENDA, ITEM, CODI' +
        'GO_BARRAS, VALOR_UNITARIO, VALOR_DESCONTO,'
      
        '                           VALOR_ACRESCIMO, VALOR_TOTAL, QTDE, U' +
        'NIDADE,TERMINAL)'
      
        'values (:CODIGO_PREVENDA, :ITEM, :CODIGO_BARRAS, :VALOR_UNITARIO' +
        ', :VALOR_DESCONTO, :VALOR_ACRESCIMO,'
      '        :VALOR_TOTAL, :QTDE, :UNIDADE,:TERMINAL)  ')
    Left = 272
    Top = 88
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO_PREVENDA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ITEM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO_BARRAS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALOR_UNITARIO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALOR_DESCONTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALOR_ACRESCIMO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALOR_TOTAL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'QTDE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UNIDADE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TERMINAL'
        Value = nil
      end>
  end
  object qrPreVendaPesquisar: TUniQuery
    Connection = dmConexao.conexao
    Left = 272
    Top = 192
  end
  object qrPreVendaItemPesq: TUniQuery
    Connection = dmConexao.conexao
    Left = 264
    Top = 256
  end
  object qrPreVendaDeletar: TUniQuery
    Connection = dmConexao.conexao
    Left = 112
    Top = 272
  end
  object qrPreVendaGrid: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'SELECT * FROM PREVENDA WHERE DATA >= :DTINICIO AND DATA <= :DTFI' +
        'M AND STATUS = :STATUS')
    Left = 216
    Top = 160
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DTINICIO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DTFIM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'STATUS'
        Value = nil
      end>
    object qrPreVendaGridCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 12
    end
    object qrPreVendaGridCOD_CUPOM: TStringField
      FieldName = 'COD_CUPOM'
      Size = 50
    end
    object qrPreVendaGridFUNCIONARIO: TStringField
      FieldName = 'FUNCIONARIO'
      Size = 6
    end
    object qrPreVendaGridDATA: TDateTimeField
      FieldName = 'DATA'
    end
    object qrPreVendaGridCOD_CLIENTE: TStringField
      FieldName = 'COD_CLIENTE'
      Size = 6
    end
    object qrPreVendaGridVALOR_DESCONTO: TFloatField
      FieldName = 'VALOR_DESCONTO'
    end
    object qrPreVendaGridVALOR_ACRESCIMO: TFloatField
      FieldName = 'VALOR_ACRESCIMO'
    end
    object qrPreVendaGridVALOR_TOTAL: TFloatField
      FieldName = 'VALOR_TOTAL'
      DisplayFormat = '###,###,##0.00'
    end
    object qrPreVendaGridTERMINAL: TStringField
      FieldName = 'TERMINAL'
      Required = True
      Size = 3
    end
    object qrPreVendaGridCANCELADO: TIntegerField
      FieldName = 'CANCELADO'
    end
    object qrPreVendaGridSTATUS: TStringField
      FieldName = 'STATUS'
      Size = 1
    end
    object qrPreVendaGridCLIENTE: TStringField
      FieldKind = fkLookup
      FieldName = 'CLIENTE'
      LookupDataSet = qrCliente
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'NOME'
      KeyFields = 'COD_CLIENTE'
      Lookup = True
    end
  end
  object qrCliente: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from cliente')
    Left = 360
    Top = 64
    object qrClienteCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 6
    end
    object qrClienteNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object qrClienteNOME_FANTASIA: TStringField
      FieldName = 'NOME_FANTASIA'
      Size = 80
    end
    object qrClienteENDERECO: TStringField
      FieldName = 'ENDERECO'
      Size = 45
    end
    object qrClienteNUMERO: TStringField
      FieldName = 'NUMERO'
      Size = 15
    end
    object qrClienteBAIRRO: TStringField
      FieldName = 'BAIRRO'
      Size = 50
    end
    object qrClienteCIDADE: TStringField
      FieldName = 'CIDADE'
      Size = 40
    end
    object qrClienteUF: TStringField
      FieldName = 'UF'
      FixedChar = True
      Size = 2
    end
    object qrClienteCEP: TStringField
      FieldName = 'CEP'
      Size = 10
    end
    object qrClienteCOMPLEMENTO: TStringField
      FieldName = 'COMPLEMENTO'
    end
    object qrClienteTELEFONE1: TStringField
      FieldName = 'TELEFONE1'
      Size = 15
    end
    object qrClienteTELEFONE2: TStringField
      FieldName = 'TELEFONE2'
      Size = 15
    end
    object qrClienteCELULAR: TStringField
      FieldName = 'CELULAR'
      FixedChar = True
      Size = 15
    end
    object qrClienteEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 100
    end
    object qrClienteCNPJCPF: TStringField
      FieldName = 'CNPJCPF'
      Required = True
      Size = 14
    end
    object qrClienteOBSERVACAO: TMemoField
      FieldName = 'OBSERVACAO'
      BlobType = ftMemo
    end
    object qrClienteDATA_CADASTRO: TDateField
      FieldName = 'DATA_CADASTRO'
    end
    object qrClienteTIPO_PESSOA: TIntegerField
      FieldName = 'TIPO_PESSOA'
    end
    object qrClienteCREDITO_LIMITE: TFloatField
      FieldName = 'CREDITO_LIMITE'
    end
    object qrClienteCREDITO_UTILIZADO: TFloatField
      FieldName = 'CREDITO_UTILIZADO'
    end
  end
end
