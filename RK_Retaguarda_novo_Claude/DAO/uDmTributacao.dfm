object dmTributacao: TdmTributacao
  OldCreateOrder = False
  Height = 381
  Width = 518
  object qrTrbPesquisar: TUniQuery
    Connection = dmConexao.conexao
    Left = 88
    Top = 56
  end
  object qrTrbAlterar: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'update TRIBUTACAO'
      'set CODIGO = :CODIGO,'
      '    DESCRICAO = :DESCRICAO,'
      '    CST = :CST,'
      '    CFOP = :CFOP,'
      '    CSOSN = :CSOSN,'
      '    ST = :ST,'
      '    ICMS = :ICMS  '
      'where (CODIGO = :CODIGO)')
    Left = 176
    Top = 56
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DESCRICAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CST'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CFOP'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CSOSN'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ST'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ICMS'
        Value = nil
      end>
  end
  object qrTrbInserir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'insert into TRIBUTACAO (CODIGO, DESCRICAO, CST, CFOP, CSOSN, ST,' +
        ' ICMS)'
      'values (:CODIGO, :DESCRICAO, :CST, :CFOP, :CSOSN, :ST, :ICMS)  ')
    Left = 296
    Top = 56
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DESCRICAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CST'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CFOP'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CSOSN'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ST'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ICMS'
        Value = nil
      end>
  end
  object qrTrbExcluir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'DELETE FROM TRIBUTACAO WHERE CODIGO = :CODIGO')
    Left = 344
    Top = 120
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
  end
end
