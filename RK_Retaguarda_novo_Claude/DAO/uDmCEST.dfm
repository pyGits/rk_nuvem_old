object dmCEST: TdmCEST
  OldCreateOrder = False
  Height = 335
  Width = 415
  object qrGridCEST: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'SELECT * FROM CEST')
    Left = 192
    Top = 152
    object qrGridCESTCEST: TStringField
      FieldName = 'CEST'
      Required = True
      Size = 7
    end
    object qrGridCESTNCM: TStringField
      FieldName = 'NCM'
      Required = True
      FixedChar = True
      Size = 8
    end
    object qrGridCESTDESCRICAO: TMemoField
      FieldName = 'DESCRICAO'
      OnGetText = qrGridCESTDESCRICAOGetText
      BlobType = ftMemo
    end
  end
  object qrCESTPesquisar: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'SELECT * FROM CEST')
    Left = 272
    Top = 192
    object StringField1: TStringField
      FieldName = 'CEST'
      Required = True
      Size = 7
    end
    object StringField2: TStringField
      FieldName = 'NCM'
      Required = True
      FixedChar = True
      Size = 8
    end
    object MemoField1: TMemoField
      FieldName = 'DESCRICAO'
      OnGetText = qrGridCESTDESCRICAOGetText
      BlobType = ftMemo
    end
  end
end
