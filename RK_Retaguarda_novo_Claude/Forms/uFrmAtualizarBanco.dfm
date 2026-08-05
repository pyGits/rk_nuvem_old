object frmAtualizarBanco: TfrmAtualizarBanco
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Atualizar Banco De Dados'
  ClientHeight = 312
  ClientWidth = 842
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 154
    Top = 272
    Width = 326
    Height = 19
    Caption = 'Aguarde, atualizando banco de dados ...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object MemoExtr: TRichEdit
    Left = 16
    Top = 16
    Width = 281
    Height = 243
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
    Zoom = 100
  end
  object MemoResult: TMemo
    Left = 318
    Top = 16
    Width = 499
    Height = 243
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    WordWrap = False
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 168
    Top = 24
  end
  object DBComparer1: TDBComparer
    DBStructureMaster = DBStructure1
    DBStructureTarget = DBStructure2
    SQLExec = IBSQLExec
    Left = 448
    Top = 168
  end
  object DBStructure1: TDBStructure
    IBServerOptions.SQLServerVersion = st_Firebird_30
    MSSQLServerOptions.SQLServerVersion = st_MSSQL2000
    PGSQLServerOptions.SQLServerVersion = st_PostgreSQL_8x
    Left = 280
    Top = 112
  end
  object DBStructure2: TDBStructure
    IBServerOptions.SQLServerVersion = st_Firebird_30
    MSSQLServerOptions.SQLServerVersion = st_MSSQL2000
    PGSQLServerOptions.SQLServerVersion = st_PostgreSQL_8x
    Left = 280
    Top = 176
  end
  object IBDBExtract1: TIBDBExtract
    DBCConnection = DataMd.DBCConnection1
    DBStructure = DBStructure1
    Left = 24
    Top = 184
  end
  object IBDBExtract2: TIBDBExtract
    DBCConnection = DataMd.DBCConnection2
    DBStructure = DBStructure2
    Left = 24
    Top = 248
  end
  object IBScriptExtract1: TIBScriptExtract
    DBStructure = DBStructure1
    Left = 104
    Top = 176
  end
  object IBScriptExtract2: TIBScriptExtract
    DBStructure = DBStructure2
    Left = 104
    Top = 232
  end
  object IBSQLExec: TIBSQLExec
    IBServerOptions.SQLServerVersion = st_Firebird_30
    DBCConnection = DataMd.DBCConnection2
    Left = 432
    Top = 212
  end
  object qrAjusteDel: TUniQuery
    Connection = DataMd.UniConnection2
    Left = 184
    Top = 104
  end
  object qrAjustePesq: TUniQuery
    Connection = DataMd.UniConnection2
    Left = 144
    Top = 64
  end
  object ExecAjusta: TIBSQLExec
    IBServerOptions.SQLServerVersion = st_Firebird_30
    DBCConnection = DataMd.DBCConnection2
    Left = 400
    Top = 52
  end
  object IBSQLExec1: TIBSQLExec
    IBServerOptions.SQLServerVersion = st_Firebird_30
    DBCConnection = DataMd.DBCConnection2
    Left = 280
    Top = 244
  end
end
