object dmConexao: TdmConexao
  OldCreateOrder = False
  Height = 317
  Width = 474
  object ConexaoServer: TUniConnection
    ProviderName = 'InterBase'
    Database = 'c:\system_rk\server\bd\banco.fdb'
    Username = 'SYSDBA'
    Server = '127.0.0.1'
    LoginPrompt = False
    Left = 224
    Top = 144
    EncryptedPassword = '92FF9EFF8CFF8BFF9AFF8DFF94FF9AFF86FF'
  end
  object InterBaseUniProvider1: TInterBaseUniProvider
    Left = 288
    Top = 104
  end
  object UniSQLMonitor1: TUniSQLMonitor
    Left = 112
    Top = 80
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Database=c:\system_rk\server\bd\banco.fdb'
      'DriverID=FB')
    Left = 88
    Top = 200
  end
end
