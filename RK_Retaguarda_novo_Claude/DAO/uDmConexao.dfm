object dmConexao: TdmConexao
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 325
  Width = 459
  object conexao: TUniConnection
    ProviderName = 'InterBase'
    Port = 3050
    Database = 'C:\SYSTEM_RK\SERVER\BD\BANCO.FDB'
    Username = 'SYSDBA'
    Server = '127.0.0.1'
    LoginPrompt = False
    Left = 216
    Top = 144
    EncryptedPassword = '92FF9EFF8CFF8BFF9AFF8DFF94FF9AFF86FF'
  end
  object InterBaseUniProvider1: TInterBaseUniProvider
    Left = 248
    Top = 72
  end
  object UniSQLMonitor1: TUniSQLMonitor
    Left = 328
    Top = 144
  end
  object FDConnection1: TFDConnection
    Left = 88
    Top = 112
  end
  object FDPhysIBDriverLink1: TFDPhysIBDriverLink
    Left = 136
    Top = 208
  end
end
