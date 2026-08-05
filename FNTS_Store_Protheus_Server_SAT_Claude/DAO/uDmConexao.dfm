object dmConexao: TdmConexao
  OldCreateOrder = False
  Height = 168
  Width = 240
  object sqlConexaoFirebird: TUniConnection
    ProviderName = 'InterBase'
    Port = 3050
    Database = 'c:\system_rk\pdv\bd\sat_datpdv.fdb'
    Username = 'SYSDBA'
    Server = '127.0.0.1'
    Connected = True
    LoginPrompt = False
    Left = 96
    Top = 72
    EncryptedPassword = '92FF9EFF8CFF8BFF9AFF8DFF94FF9AFF86FF'
  end
  object InterBaseUniProvider1: TInterBaseUniProvider
    Left = 48
    Top = 16
  end
  object monitor: TUniSQLMonitor
    Left = 176
    Top = 120
  end
end
