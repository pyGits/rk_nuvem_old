object dmGrupo: TdmGrupo
  OldCreateOrder = False
  Height = 299
  Width = 473
  object qrGrupoPesquisar: TUniQuery
    Connection = dmConexao.conexao
    Left = 88
    Top = 56
  end
  object qrGrupoAlterar: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      '              update GRUPO'
      '              set GRUPO = :GRUPO'
      '              where (CODIGO = :CODIGO)')
    Left = 216
    Top = 64
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'GRUPO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
  end
  object qrGrupoInserir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      '          insert into GRUPO (CODIGO, GRUPO)'
      '          values (:CODIGO, :GRUPO)')
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
        Name = 'GRUPO'
        Value = nil
      end>
  end
  object qrGrupoExcluir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'DELETE FROM GRUPO WHERE CODIGO = :CODIGO')
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
