object dmFuncionarioPDV: TdmFuncionarioPDV
  OldCreateOrder = False
  Height = 295
  Width = 411
  object qrInserirFuncionarioPDV: TUniQuery
    Connection = uDmConexaoPDV.ConexaoPDV
    Left = 192
    Top = 128
  end
  object qrDeleteFuncionarioPDV: TUniQuery
    Connection = uDmConexaoPDV.ConexaoPDV
    SQL.Strings = (
      'DELETE FROM ADM WHERE CODIGO = :CODIGO')
    Left = 192
    Top = 192
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
  end
end
