object dmConexaoIntegracao: TdmConexaoIntegracao
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 475
  Width = 643
  object ConexaoIntegracao: TUniConnection
    ProviderName = 'InterBase'
    Database = 'c:\syspdv\syspdv_srv.fdb'
    Username = 'SYSDBA'
    Server = '127.0.0.1'
    LoginPrompt = False
    Left = 48
    Top = 24
    EncryptedPassword = '92FF9EFF8CFF8BFF9AFF8DFF94FF9AFF86FF'
  end
  object InterBaseUniProvider1: TInterBaseUniProvider
    Left = 152
    Top = 8
  end
  object qrZerar: TUniQuery
    Connection = dmConexao.conexao
    Left = 136
    Top = 88
  end
  object qrIntegracaoPesq: TUniQuery
    Connection = ConexaoIntegracao
    Left = 32
    Top = 160
  end
  object qrAtualizaCodigo: TUniQuery
    Connection = ConexaoIntegracao
    Left = 88
    Top = 240
  end
  object qrInserirMapeamento: TUniQuery
    Connection = dmConexao.conexao
    Left = 440
    Top = 248
  end
  object qrInserirAuxiliar: TUniQuery
    Connection = dmConexao.conexao
    Left = 280
    Top = 40
  end
  object qrGetCodigoAuxiliar: TUniQuery
    Connection = ConexaoIntegracao
    Left = 288
    Top = 88
  end
  object qrGetCodigoMax: TUniQuery
    Connection = dmConexao.conexao
    Left = 176
    Top = 144
  end
  object qrGetMapeamento: TUniQuery
    Connection = dmConexao.conexao
    Left = 544
    Top = 392
  end
  object qrDeleteAuxiliar: TUniQuery
    Connection = dmConexao.conexao
    Left = 280
    Top = 152
  end
end
