object dmUtils: TdmUtils
  OldCreateOrder = False
  Height = 307
  Width = 477
  object qrUtilsPesq: TUniQuery
    Connection = dmConexao.conexao
    Left = 32
    Top = 48
  end
  object qrUtilsInserir: TUniQuery
    Connection = dmConexao.conexao
    Left = 128
    Top = 56
  end
  object qrUtilsGridIBGE: TUniQuery
    Connection = dmConexao.conexao
    Left = 56
    Top = 144
  end
  object qrZerarBD: TUniQuery
    Connection = dmConexao.conexao
    Left = 224
    Top = 136
  end
end
