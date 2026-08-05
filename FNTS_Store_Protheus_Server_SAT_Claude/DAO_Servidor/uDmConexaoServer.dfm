object dmConexaoServer: TdmConexaoServer
  OldCreateOrder = False
  Height = 272
  Width = 389
  object InterBaseUniProvider1: TInterBaseUniProvider
    Left = 48
    Top = 16
  end
  object monitor: TUniSQLMonitor
    Left = 168
    Top = 120
  end
  object sqlConexaoServerFirebird: TUniConnection
    ProviderName = 'InterBase'
    Port = 3050
    Database = 'c:\system_rk\server\bd\banco.fdb'
    Username = 'SYSDBA'
    Server = '127.0.0.1'
    LoginPrompt = False
    Left = 96
    Top = 72
    EncryptedPassword = '92FF9EFF8CFF8BFF9AFF8DFF94FF9AFF86FF'
  end
end
