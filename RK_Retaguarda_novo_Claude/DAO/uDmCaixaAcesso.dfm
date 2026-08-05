object dmCaixaAcesso: TdmCaixaAcesso
  OldCreateOrder = False
  Height = 372
  Width = 499
  object qrCaixaAcessoPesquisar: TUniQuery
    Connection = dmConexao.conexao
    Left = 88
    Top = 64
  end
  object qrCaixaAcessoAtualizar: TUniQuery
    Connection = dmConexao.conexao
    Left = 216
    Top = 64
  end
end
