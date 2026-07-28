object uDmConexaoPDV: TuDmConexaoPDV
  OldCreateOrder = False
  Height = 443
  Width = 538
  object ConexaoPDV: TUniConnection
    ProviderName = 'InterBase'
    Database = 'c:\system_rk\pdv\bd\sat_datpdv.fdb'
    Username = 'SYSDBA'
    LoginPrompt = False
    Left = 88
    Top = 56
    EncryptedPassword = '92FF9EFF8CFF8BFF9AFF8DFF94FF9AFF86FF'
  end
  object InterBaseUniProvider1: TInterBaseUniProvider
    Left = 256
    Top = 56
  end
  object UniSQLMonitor1: TUniSQLMonitor
    Left = 384
    Top = 56
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Database=C:\System_RK\PDV\BD\sat_datpdv.FDB'
      'DriverID=FB')
    Left = 192
    Top = 224
  end
end
