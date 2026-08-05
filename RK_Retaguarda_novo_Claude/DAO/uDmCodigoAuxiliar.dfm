object dmCodigoAuxiliar: TdmCodigoAuxiliar
  OldCreateOrder = False
  Height = 349
  Width = 475
  object qrCodigoAuxiliarPesq: TUniQuery
    Connection = dmConexao.conexao
    Left = 224
    Top = 160
  end
  object getCodigoAuxiliar: TUniQuery
    Connection = dmConexao.conexao
    Left = 80
    Top = 48
  end
end
