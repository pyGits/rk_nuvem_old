object dmFuncionario: TdmFuncionario
  OldCreateOrder = False
  Height = 272
  Width = 331
  object qrFuncionarioInsert: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 88
    Top = 56
  end
  object qrFuncionarioDelete: TUniQuery
    Connection = dmConexao.ConexaoServer
    SQL.Strings = (
      'delete from funcionario where codigo = :codigo;')
    Left = 152
    Top = 120
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'codigo'
        Value = nil
      end>
  end
end
