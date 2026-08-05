object dmCupom: TdmCupom
  OldCreateOrder = False
  Height = 396
  Width = 560
  object qrCupomAtualizarPDV: TUniQuery
    Connection = dmConexao.sqlConexaoFirebird
    Left = 144
    Top = 24
  end
  object qrCupomItemPesquisar: TUniQuery
    Connection = dmConexao.sqlConexaoFirebird
    Left = 264
    Top = 24
  end
  object qrCupomPesquisar: TUniQuery
    Connection = dmConexao.sqlConexaoFirebird
    SpecificOptions.Strings = (
      'InterBase.FetchAll=True')
    Left = 56
    Top = 32
  end
  object qrCupomFormaPesquisar: TUniQuery
    Connection = dmConexao.sqlConexaoFirebird
    Left = 56
    Top = 168
  end
  object qrNaoFiscalPesquisar: TUniQuery
    Connection = dmConexao.sqlConexaoFirebird
    Left = 288
    Top = 176
  end
  object qrNaoFiscalAtualizar: TUniQuery
    Connection = dmConexao.sqlConexaoFirebird
    Left = 288
    Top = 232
  end
  object qrContasReceberPesquisar: TUniQuery
    Connection = dmConexao.sqlConexaoFirebird
    Left = 224
    Top = 112
  end
  object qrEstoqueAtualizar: TUniQuery
    Connection = dmConexao.sqlConexaoFirebird
    Left = 56
    Top = 272
  end
  object qrFechamentoPesquisar: TUniQuery
    Connection = dmConexao.sqlConexaoFirebird
    Left = 160
    Top = 272
  end
  object qrFechamentoAtualizar: TUniQuery
    Connection = dmConexao.sqlConexaoFirebird
    Left = 296
    Top = 296
  end
  object qrFechamentoFinPesquisar: TUniQuery
    Connection = dmConexao.sqlConexaoFirebird
    Left = 144
    Top = 328
  end
  object qrBulkInsert: TUniQuery
    Connection = dmConexao.sqlConexaoFirebird
    Left = 480
    Top = 56
  end
end
