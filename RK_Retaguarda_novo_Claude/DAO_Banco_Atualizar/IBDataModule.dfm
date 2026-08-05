object DataMd: TDataMd
  OldCreateOrder = False
  Height = 317
  Width = 545
  object DBCConnection1: TDBCConnectionUniDAC
    Database = UniConnection1
    OnBeforeConnect = DBCConnection1BeforeConnect
    Left = 144
    Top = 24
  end
  object DBCConnection2: TDBCConnectionUniDAC
    Database = UniConnection2
    OnBeforeConnect = DBCConnection2BeforeConnect
    Left = 144
    Top = 80
  end
  object UniConnection1: TUniConnection
    ProviderName = 'InterBase'
    LoginPrompt = False
    Left = 48
    Top = 24
  end
  object UniConnection2: TUniConnection
    ProviderName = 'InterBase'
    Port = 3050
    Database = 'c:\system_rk\server\bd\banco.fdb'
    Username = 'SYSDBA'
    Server = '127.0.0.1'
    LoginPrompt = False
    Left = 48
    Top = 80
    EncryptedPassword = '92FF9EFF8CFF8BFF9AFF8DFF94FF9AFF86FF'
  end
  object InterBaseUniProvider1: TInterBaseUniProvider
    Left = 288
    Top = 80
  end
  object UniSQLMonitor1: TUniSQLMonitor
    Left = 208
    Top = 24
  end
  object inserirAjuste: TUniQuery
    Connection = UniConnection2
    Left = 256
    Top = 144
  end
end
