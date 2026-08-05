object dmCupomServidor: TdmCupomServidor
  OldCreateOrder = False
  Height = 478
  Width = 592
  object qrCupomServidorPesquisar: TUniQuery
    Connection = dmConexaoServer.sqlConexaoServerFirebird
    Left = 56
    Top = 24
  end
  object spCupom: TUniStoredProc
    StoredProcName = 'ST_CUPOM_INSERT'
    SQL.Strings = (
      
        'EXECUTE PROCEDURE ST_CUPOM_INSERT(:CODIGO, :NUMERO, :DATA, :HORA' +
        ', :QTDE_ITEM, :VALOR_DESCONTO, :VALOR_ACRESCIMO, :VALOR_TOTAL, :' +
        'COD_CLIENTE, :CANCELADO, :CPF_CONSUMIDOR, :NOME_CONSUMIDOR, :COD' +
        '_VENDEDOR, :EX, :COD_CAIXA, :NUVEM, :XML_CHAVE, :XML_CHAVE_CANCE' +
        'LAMENTO, :VALOR_CUSTO)')
    Connection = dmConexaoServer.sqlConexaoServerFirebird
    Left = 216
    Top = 24
    ParamData = <
      item
        DataType = ftString
        Name = 'CODIGO'
        ParamType = ptInput
        Size = 50
        Value = nil
      end
      item
        DataType = ftString
        Name = 'NUMERO'
        ParamType = ptInput
        Size = 12
        Value = nil
      end
      item
        DataType = ftDate
        Name = 'DATA'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftTime
        Name = 'HORA'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'QTDE_ITEM'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_DESCONTO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_ACRESCIMO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_TOTAL'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'COD_CLIENTE'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'CANCELADO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftString
        Name = 'CPF_CONSUMIDOR'
        ParamType = ptInput
        Size = 20
        Value = nil
      end
      item
        DataType = ftString
        Name = 'NOME_CONSUMIDOR'
        ParamType = ptInput
        Size = 40
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'COD_VENDEDOR'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'EX'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'COD_CAIXA'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'NUVEM'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftString
        Name = 'XML_CHAVE'
        ParamType = ptInput
        Size = 45
        Value = nil
      end
      item
        DataType = ftString
        Name = 'XML_CHAVE_CANCELAMENTO'
        ParamType = ptInput
        Size = 50
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_CUSTO'
        ParamType = ptInput
        Value = nil
      end>
    CommandStoredProcName = 'ST_CUPOM_INSERT'
  end
  object spCupom_Item: TUniStoredProc
    StoredProcName = 'ST_CUPOM_ITEM_INSERT'
    SQL.Strings = (
      
        'EXECUTE PROCEDURE ST_CUPOM_ITEM_INSERT(:CODIGO, :COD_CUPOM, :ITE' +
        'M, :COD_PRODUTO, :UNIDADE, :QTDE, :VALOR_UNITARIO, :VALOR_DESCON' +
        'TO, :VALOR_ACRESCIMO, :VALOR_TOTAL, :CANCELADO, :DATA, :EX, :COD' +
        '_CAIXA, :VALOR_CUSTO, :VALOR_CUSTO_TOTAL, :MOTIVO_CANCELAMENTO)')
    Connection = dmConexaoServer.sqlConexaoServerFirebird
    Left = 293
    Top = 16
    ParamData = <
      item
        DataType = ftString
        Name = 'CODIGO'
        ParamType = ptInput
        Size = 50
        Value = nil
      end
      item
        DataType = ftString
        Name = 'COD_CUPOM'
        ParamType = ptInput
        Size = 50
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'ITEM'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftString
        Name = 'COD_PRODUTO'
        ParamType = ptInput
        Size = 6
        Value = nil
      end
      item
        DataType = ftString
        Name = 'UNIDADE'
        ParamType = ptInput
        Size = 10
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'QTDE'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_UNITARIO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_DESCONTO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_ACRESCIMO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_TOTAL'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'CANCELADO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftDate
        Name = 'DATA'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'EX'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'COD_CAIXA'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_CUSTO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_CUSTO_TOTAL'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftString
        Name = 'MOTIVO_CANCELAMENTO'
        ParamType = ptInput
        Size = 3
        Value = nil
      end>
    CommandStoredProcName = 'ST_CUPOM_ITEM_INSERT'
  end
  object spCupom_Forma: TUniStoredProc
    StoredProcName = 'ST_CUPOM_FORMA_INSERT'
    SQL.Strings = (
      
        'EXECUTE PROCEDURE ST_CUPOM_FORMA_INSERT(:CODIGO, :COD_CUPOM, :FO' +
        'RMA, :VALOR, :PRESTACAO, :TIPO, :VALOR_TROCO, :DATA, :CANCELADO,' +
        ' :EX, :COD_CAIXA, :NUVEM)')
    Connection = dmConexaoServer.sqlConexaoServerFirebird
    Left = 373
    Top = 16
    ParamData = <
      item
        DataType = ftString
        Name = 'CODIGO'
        ParamType = ptInput
        Size = 50
        Value = nil
      end
      item
        DataType = ftString
        Name = 'COD_CUPOM'
        ParamType = ptInput
        Size = 50
        Value = nil
      end
      item
        DataType = ftString
        Name = 'FORMA'
        ParamType = ptInput
        Size = 30
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'PRESTACAO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftString
        Name = 'TIPO'
        ParamType = ptInput
        Size = 30
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_TROCO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftDate
        Name = 'DATA'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'CANCELADO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'EX'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'COD_CAIXA'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'NUVEM'
        ParamType = ptInput
        Value = nil
      end>
    CommandStoredProcName = 'ST_CUPOM_FORMA_INSERT'
  end
  object spNao_Fiscal: TUniStoredProc
    StoredProcName = 'ST_NAO_FISCAL'
    SQL.Strings = (
      
        'EXECUTE PROCEDURE ST_NAO_FISCAL(:CODIGO, :DATA, :INDICE, :DESCRI' +
        'CAO, :VALOR, :HORA, :CODVENDEDOR, :FZCOD, :COD_CAIXA)')
    Connection = dmConexaoServer.sqlConexaoServerFirebird
    Left = 161
    Top = 168
    ParamData = <
      item
        DataType = ftString
        Name = 'CODIGO'
        ParamType = ptInput
        Size = 50
        Value = nil
      end
      item
        DataType = ftDate
        Name = 'DATA'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftString
        Name = 'INDICE'
        ParamType = ptInput
        Size = 2
        Value = nil
      end
      item
        DataType = ftString
        Name = 'DESCRICAO'
        ParamType = ptInput
        Size = 30
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftTime
        Name = 'HORA'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'CODVENDEDOR'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftString
        Name = 'FZCOD'
        ParamType = ptInput
        Size = 3
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'COD_CAIXA'
        ParamType = ptInput
        Value = nil
      end>
    CommandStoredProcName = 'ST_NAO_FISCAL'
  end
  object spEstoque_Movimentacao: TUniStoredProc
    StoredProcName = 'ST_ESTOQUE_MOVIMENTACAO'
    SQL.Strings = (
      
        'EXECUTE PROCEDURE ST_ESTOQUE_MOVIMENTACAO(:QTDE, :DATA, :HORA, :' +
        'CODPRODUTO, :COD_CUPOM, :ITEM, :COD_FUNCIONARIO, :ORIGEM, :COD_C' +
        'AIXA)')
    Connection = dmConexaoServer.sqlConexaoServerFirebird
    Left = 241
    Top = 96
    ParamData = <
      item
        DataType = ftFloat
        Name = 'QTDE'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftDate
        Name = 'DATA'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftTime
        Name = 'HORA'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftString
        Name = 'CODPRODUTO'
        ParamType = ptInput
        Size = 6
        Value = nil
      end
      item
        DataType = ftString
        Name = 'COD_CUPOM'
        ParamType = ptInput
        Size = 50
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'ITEM'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftString
        Name = 'COD_FUNCIONARIO'
        ParamType = ptInput
        Size = 6
        Value = nil
      end
      item
        DataType = ftString
        Name = 'ORIGEM'
        ParamType = ptInput
        Size = 50
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'COD_CAIXA'
        ParamType = ptInput
        Value = nil
      end>
    CommandStoredProcName = 'ST_ESTOQUE_MOVIMENTACAO'
  end
  object spContas_Receber: TUniStoredProc
    StoredProcName = 'ST_CONTAS_RECEBER'
    SQL.Strings = (
      
        'EXECUTE PROCEDURE ST_CONTAS_RECEBER(:CODIGO, :COD_CUPOM, :COD_VE' +
        'NDEDOR, :COD_CAIXA, :COD_CLIENTE, :DATA_EMISSAO, :DATA_VENCIMENT' +
        'O, :DATA_PAGAMENTO, :VALOR, :VALOR_PAGO, :VALOR_DESCONTO, :VALOR' +
        '_ACRESCIMO, :VALOR_RESTANTE, :CANCELADO, :STATUS)')
    Connection = dmConexaoServer.sqlConexaoServerFirebird
    Left = 281
    Top = 168
    ParamData = <
      item
        DataType = ftString
        Name = 'CODIGO'
        ParamType = ptInput
        Size = 50
        Value = nil
      end
      item
        DataType = ftString
        Name = 'COD_CUPOM'
        ParamType = ptInput
        Size = 50
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'COD_VENDEDOR'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'COD_CAIXA'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftString
        Name = 'COD_CLIENTE'
        ParamType = ptInput
        Size = 6
        Value = nil
      end
      item
        DataType = ftDate
        Name = 'DATA_EMISSAO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftDate
        Name = 'DATA_VENCIMENTO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftDate
        Name = 'DATA_PAGAMENTO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_PAGO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_DESCONTO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_ACRESCIMO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftFloat
        Name = 'VALOR_RESTANTE'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'CANCELADO'
        ParamType = ptInput
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'STATUS'
        ParamType = ptInput
        Value = nil
      end>
    CommandStoredProcName = 'ST_CONTAS_RECEBER'
  end
  object qrPrevendaServidorAtualizar: TUniQuery
    Connection = dmConexaoServer.sqlConexaoServerFirebird
    Left = 64
    Top = 88
  end
  object qrEnviado: TUniQuery
    Connection = dmConexaoServer.sqlConexaoServerFirebird
    Left = 56
    Top = 168
  end
  object qrFechamentoInserir: TUniQuery
    Connection = dmConexaoServer.sqlConexaoServerFirebird
    SQL.Strings = (
      
        'update or insert into FECHAMENTO (CODIGO, OPERADOR, DATA_ABERTUR' +
        'A, HORA_ABERTURA, DATA_FECHAMENTO, HORA_FECHAMENTO, VENDA_BRUTA,'
      
        '                        CANCELAMENTO_CUPOM, CANCELAMENTO_ITEM, D' +
        'ESCONTO_ITEM, DESCONTO_CUPOM, ACRESCIMO_CUPOM,'
      
        '                        VENDA_LIQUIDA, FUNDO_CAIXA, SANGRIA, TOT' +
        'AIS, QTD_CUPONS_EFETIVADOS, QTD_CUPONS_CANCELADOS,EX,COD_OPERADO' +
        'R,COD_CAIXA,NUVEM)'
      
        'values (:CODIGO, :OPERADOR, :DATA_ABERTURA, :HORA_ABERTURA, :DAT' +
        'A_FECHAMENTO, :HORA_FECHAMENTO, :VENDA_BRUTA,'
      
        '        :CANCELAMENTO_CUPOM, :CANCELAMENTO_ITEM, :DESCONTO_ITEM,' +
        ' :DESCONTO_CUPOM, :ACRESCIMO_CUPOM, :VENDA_LIQUIDA,'
      
        '        :FUNDO_CAIXA, :SANGRIA, :TOTAIS, :QTD_CUPONS_EFETIVADOS,' +
        ' :QTD_CUPONS_CANCELADOS,:EX,:COD_OPERADOR,:COD_CAIXA,0)  '
      'matching(DATA_ABERTURA,HORA_ABERTURA,COD_OPERADOR,COD_CAIXA);')
    Left = 160
    Top = 288
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'OPERADOR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATA_ABERTURA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'HORA_ABERTURA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATA_FECHAMENTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'HORA_FECHAMENTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VENDA_BRUTA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CANCELAMENTO_CUPOM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CANCELAMENTO_ITEM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DESCONTO_ITEM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DESCONTO_CUPOM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ACRESCIMO_CUPOM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VENDA_LIQUIDA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FUNDO_CAIXA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'SANGRIA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TOTAIS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'QTD_CUPONS_EFETIVADOS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'QTD_CUPONS_CANCELADOS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EX'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'COD_OPERADOR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'COD_CAIXA'
        Value = nil
      end>
    object StringField1: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 50
    end
    object StringField2: TStringField
      FieldName = 'OPERADOR'
      Size = 6
    end
    object DateField1: TDateField
      FieldName = 'DATA_ABERTURA'
    end
    object TimeField1: TTimeField
      FieldName = 'HORA_ABERTURA'
    end
    object DateField2: TDateField
      FieldName = 'DATA_FECHAMENTO'
    end
    object TimeField2: TTimeField
      FieldName = 'HORA_FECHAMENTO'
    end
    object FloatField1: TFloatField
      FieldName = 'VENDA_BRUTA'
    end
    object FloatField2: TFloatField
      FieldName = 'CANCELAMENTO_CUPOM'
    end
    object FloatField3: TFloatField
      FieldName = 'CANCELAMENTO_ITEM'
    end
    object FloatField4: TFloatField
      FieldName = 'DESCONTO_ITEM'
    end
    object FloatField5: TFloatField
      FieldName = 'DESCONTO_CUPOM'
    end
    object FloatField6: TFloatField
      FieldName = 'ACRESCIMO_CUPOM'
    end
    object FloatField7: TFloatField
      FieldName = 'VENDA_LIQUIDA'
    end
    object FloatField8: TFloatField
      FieldName = 'FUNDO_CAIXA'
    end
    object FloatField9: TFloatField
      FieldName = 'SANGRIA'
    end
    object FloatField10: TFloatField
      FieldName = 'TOTAIS'
    end
    object IntegerField1: TIntegerField
      FieldName = 'QTD_CUPONS_EFETIVADOS'
    end
    object IntegerField2: TIntegerField
      FieldName = 'QTD_CUPONS_CANCELADOS'
    end
  end
  object qrFechamentoFinalizadoraInserir: TUniQuery
    Connection = dmConexaoServer.sqlConexaoServerFirebird
    SQL.Strings = (
      
        'UPDATE OR insert into FECHAMENTO_FINALIZADORA (ID_FECHAMENTO, FZ' +
        'COD, VALOR_LIQUIDO, VALOR_ENTRADA, VALOR_TROCO,VALOR_REFORCO,VAL' +
        'OR_SANGRIA,EX,COD_CAIXA,NUVEM,VALOR_CONFERENCIA)'
      
        'values (:ID_FECHAMENTO, :FZCOD, :VALOR_LIQUIDO, :VALOR_ENTRADA, ' +
        ':VALOR_TROCO,:VALOR_REFORCO,:VALOR_SANGRIA,:EX,:COD_CAIXA,0,:VAL' +
        'OR_CONFERENCIA)')
    Left = 304
    Top = 264
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ID_FECHAMENTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FZCOD'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALOR_LIQUIDO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALOR_ENTRADA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALOR_TROCO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALOR_REFORCO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALOR_SANGRIA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EX'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'COD_CAIXA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALOR_CONFERENCIA'
        Value = nil
      end>
    object StringField3: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 50
    end
    object StringField4: TStringField
      FieldName = 'OPERADOR'
      Size = 6
    end
    object DateField3: TDateField
      FieldName = 'DATA_ABERTURA'
    end
    object TimeField3: TTimeField
      FieldName = 'HORA_ABERTURA'
    end
    object DateField4: TDateField
      FieldName = 'DATA_FECHAMENTO'
    end
    object TimeField4: TTimeField
      FieldName = 'HORA_FECHAMENTO'
    end
    object FloatField11: TFloatField
      FieldName = 'VENDA_BRUTA'
    end
    object FloatField12: TFloatField
      FieldName = 'CANCELAMENTO_CUPOM'
    end
    object FloatField13: TFloatField
      FieldName = 'CANCELAMENTO_ITEM'
    end
    object FloatField14: TFloatField
      FieldName = 'DESCONTO_ITEM'
    end
    object FloatField15: TFloatField
      FieldName = 'DESCONTO_CUPOM'
    end
    object FloatField16: TFloatField
      FieldName = 'ACRESCIMO_CUPOM'
    end
    object FloatField17: TFloatField
      FieldName = 'VENDA_LIQUIDA'
    end
    object FloatField18: TFloatField
      FieldName = 'FUNDO_CAIXA'
    end
    object FloatField19: TFloatField
      FieldName = 'SANGRIA'
    end
    object FloatField20: TFloatField
      FieldName = 'TOTAIS'
    end
    object IntegerField3: TIntegerField
      FieldName = 'QTD_CUPONS_EFETIVADOS'
    end
    object IntegerField4: TIntegerField
      FieldName = 'QTD_CUPONS_CANCELADOS'
    end
  end
  object qrNFCePendenteInserir: TUniQuery
    Connection = dmConexaoServer.sqlConexaoServerFirebird
    Left = 224
    Top = 408
  end
end
