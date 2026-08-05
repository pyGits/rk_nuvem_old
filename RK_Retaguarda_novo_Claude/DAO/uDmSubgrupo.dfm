object dmSubgrupo: TdmSubgrupo
  OldCreateOrder = False
  Height = 345
  Width = 521
  object qrSubGrupoPesquisar: TUniQuery
    Connection = dmConexao.conexao
    Left = 88
    Top = 56
  end
  object qrSubGrupoAlterar: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      '              update SUBGRUPO'
      '              set SUBGRUPO = :SUBGRUPO'
      
        '              where (CODIGO = :CODIGO) AND (CODIGO_GRUPO = :CODI' +
        'GO_GRUPO)')
    Left = 96
    Top = 120
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'SUBGRUPO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO_GRUPO'
        Value = nil
      end>
  end
  object qrSubGrupoInserir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      '          insert into SUBGRUPO (CODIGO,CODIGO_GRUPO ,SUBGRUPO)'
      '          values (:CODIGO, :CODIGO_GRUPO,:SUBGRUPO)')
    Left = 256
    Top = 56
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO_GRUPO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'SUBGRUPO'
        Value = nil
      end>
  end
  object qrSubGrupoExcluir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'DELETE FROM SUBGRUPO WHERE (CODIGO = :CODIGO) AND (CODIGO_GRUPO ' +
        '= :CODIGO_GRUPO)')
    Left = 336
    Top = 120
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO_GRUPO'
        Value = nil
      end>
  end
end
