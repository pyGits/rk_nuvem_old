object dmNCM: TdmNCM
  OldCreateOrder = False
  Height = 285
  Width = 404
  object qrGridNCM: TUniQuery
    Connection = dmConexao.conexao
    Left = 184
    Top = 128
  end
  object ds: TDataSource
    DataSet = qrGridNCM
    Left = 56
    Top = 120
  end
  object qrNCMPesquisar: TUniQuery
    Connection = dmConexao.conexao
    Left = 264
    Top = 136
  end
end
