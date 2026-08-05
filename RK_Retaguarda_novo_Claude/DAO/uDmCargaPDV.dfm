object dmCargaPDV: TdmCargaPDV
  OldCreateOrder = False
  Height = 477
  Width = 566
  object qrCargaPDVPesquisar: TUniQuery
    Connection = dmConexao.conexao
    Left = 88
    Top = 56
  end
  object qrCargaPDVAtualizar: TUniQuery
    Connection = dmConexao.conexao
    Left = 200
    Top = 48
  end
  object qrCargaPDVExcluir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'delete from carga;')
    Left = 144
    Top = 176
  end
  object qrCargaExcluirPDVInsert: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'insert into carga_excluir(CODIGO,TABELA) values (:CODIGO,:TABELA' +
        ');')
    Left = 72
    Top = 336
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TABELA'
        Value = nil
      end>
  end
  object qrExcluirPDV: TUniQuery
    Connection = dmConexao.conexao
    Left = 184
    Top = 336
  end
  object qrZerarExclusaoPDV: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'delete from carga_excluir;')
    Left = 304
    Top = 336
  end
  object qrCargaTerminal: TUniQuery
    Connection = dmConexao.conexao
    Left = 264
    Top = 224
  end
end
