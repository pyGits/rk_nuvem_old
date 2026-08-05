object dmValidade: TdmValidade
  OldCreateOrder = False
  Height = 314
  Width = 509
  object qrValidadeInserir: TUniQuery
    Connection = dmConexao.conexao
    Left = 184
    Top = 56
  end
  object qrProdutoValidade: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select codigo,CODIGO_BARRAS,descricao,estoque from produto')
    Left = 416
    Top = 56
    object qrProdutoValidadeESTOQUE: TFloatField
      FieldName = 'ESTOQUE'
    end
    object qrProdutoValidadeCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 6
    end
    object qrProdutoValidadeCODIGO_BARRAS: TStringField
      FieldName = 'CODIGO_BARRAS'
      Required = True
      Size = 14
    end
    object qrProdutoValidadeDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 80
    end
  end
  object qrValidadeAtualizar: TUniQuery
    Connection = dmConexao.conexao
    Left = 88
    Top = 128
  end
  object qrGridValidade: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'SELECT * FROM VALIDADE')
    Left = 168
    Top = 178
    object qrGridValidadeID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object qrGridValidadeCODIGO_PRODUTO: TStringField
      FieldName = 'CODIGO_PRODUTO'
      Required = True
      Size = 6
    end
    object qrGridValidadeLOCALIZACAO: TStringField
      FieldName = 'LOCALIZACAO'
      Size = 40
    end
    object qrGridValidadeQUANTIDADE: TFloatField
      FieldName = 'QUANTIDADE'
      DisplayFormat = '###,###,##0.00'
    end
    object qrGridValidadeVALIDADE: TDateField
      FieldName = 'VALIDADE'
    end
    object qrGridValidadeSITUACAO: TIntegerField
      DisplayWidth = 20
      FieldName = 'SITUACAO'
    end
    object qrGridValidadeDIAS_VENCER: TIntegerField
      FieldName = 'DIAS_VENCER'
      OnGetText = qrGridValidadeDIAS_VENCERGetText
    end
    object qrGridValidadeDATA_ENTRADA: TDateField
      FieldName = 'DATA_ENTRADA'
    end
    object qrGridValidadeSELECIONADO: TIntegerField
      FieldName = 'SELECIONADO'
    end
    object qrGridValidadePROXIMO_VENCIMENTO: TIntegerField
      FieldName = 'PROXIMO_VENCIMENTO'
      OnGetText = qrGridValidadePROXIMO_VENCIMENTOGetText
    end
    object qrGridValidadePRODUTO: TStringField
      FieldKind = fkLookup
      FieldName = 'PRODUTO'
      LookupDataSet = qrProdutoValidade
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'CODIGO_PRODUTO'
      Lookup = True
    end
    object qrGridValidadeCODIGO_BARRAS: TStringField
      FieldKind = fkLookup
      FieldName = 'CODIGO_BARRAS'
      LookupDataSet = qrProdutoValidade
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'CODIGO_BARRAS'
      KeyFields = 'CODIGO_PRODUTO'
      Lookup = True
    end
    object qrGridValidadeESTOQUE: TFloatField
      FieldKind = fkLookup
      FieldName = 'ESTOQUE'
      LookupDataSet = qrProdutoValidade
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'ESTOQUE'
      KeyFields = 'CODIGO_PRODUTO'
      Lookup = True
    end
    object qrGridValidadeLOTE: TStringField
      FieldName = 'LOTE'
      Size = 200
    end
  end
  object qrGeral: TUniQuery
    Connection = dmConexao.conexao
    Left = 240
    Top = 144
  end
end
