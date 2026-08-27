object dmVenda: TdmVenda
  OldCreateOrder = False
  Height = 342
  Width = 447
  object qrCupomSincroniza: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 40
    Top = 16
  end
  object qrCupomUpdate: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 136
    Top = 16
  end
  object qrCupomItemSincroniza: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 40
    Top = 64
  end
  object qrCupomItemUpdate: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 136
    Top = 64
  end
  object qrCupomFormaSincroniza: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 40
    Top = 112
  end
  object qrCupomFormaUpdate: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 136
    Top = 112
  end
  object qrEstoqueSincroniza: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 40
    Top = 160
  end
  object qrEstoqueUpdate: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 136
    Top = 160
  end
  object qrNaoFiscalSincroniza: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 40
    Top = 208
  end
  object qrNaoFiscalUpdate: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 136
    Top = 208
  end
  object qrFechamentoSincroniza: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 40
    Top = 256
  end
  object qrFechamentoUpdate: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 136
    Top = 256
  end
  object qrFechamentoFormaSincroniza: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 264
    Top = 256
  end
  object qrFechamentoFormaUpdate: TUniQuery
    Connection = dmConexao.ConexaoServer
    Left = 360
    Top = 256
  end
end
