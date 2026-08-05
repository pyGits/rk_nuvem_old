object dmNotificacao: TdmNotificacao
  OldCreateOrder = False
  Height = 345
  Width = 439
  object qrNotEstoque: TUniQuery
    Connection = dmConexao.conexao
    Left = 40
    Top = 24
  end
  object qrNotValidade: TUniQuery
    Connection = dmConexao.conexao
    Left = 112
    Top = 24
  end
end
