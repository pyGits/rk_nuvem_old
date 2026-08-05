object dmFinalizadora: TdmFinalizadora
  OldCreateOrder = False
  Height = 419
  Width = 493
  object qrFinalizadoraPesquisar: TUniQuery
    Connection = dmConexao.conexao
    Left = 88
    Top = 56
  end
  object qrFinalizadoraAlterar: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'update FINALIZADORA'
      'set DESCRICAO = :DESCRICAO,'
      '    ESPECIE = :ESPECIE,'
      '    TIPO = :TIPO,'
      '    CODIGO99 = :CODIGO99'
      'where (CODIGO = :CODIGO)   ')
    Left = 216
    Top = 64
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'DESCRICAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ESPECIE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TIPO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO99'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
  end
  object qrFinalizadoraInserir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'insert into FINALIZADORA (CODIGO, DESCRICAO, ESPECIE, TIPO, CODI' +
        'GO99)'
      'values (:CODIGO, :DESCRICAO, :ESPECIE, :TIPO, :CODIGO99)  ')
    Left = 280
    Top = 112
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
        Name = 'ESPECIE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TIPO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO99'
        Value = nil
      end>
  end
  object qrFinalizadoraExcluir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'delete from FINALIZADORA'
      'where (CODIGO = :CODIGO)   ')
    Left = 376
    Top = 112
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
  end
end
