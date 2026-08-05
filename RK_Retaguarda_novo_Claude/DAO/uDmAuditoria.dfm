object dmAuditoria: TdmAuditoria
  OldCreateOrder = False
  Height = 383
  Width = 474
  object qrAuditoriaInserir: TUniQuery
    Connection = dmConexao.conexao
    Left = 224
    Top = 176
  end
  object qrAuditoriaGrid: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from auditoria')
    Left = 344
    Top = 168
    object qrAuditoriaGridDATA_REGISTRO: TDateTimeField
      FieldName = 'DATA_REGISTRO'
      Required = True
    end
    object qrAuditoriaGridUSUARIO: TStringField
      FieldName = 'USUARIO'
      Size = 6
    end
    object qrAuditoriaGridTABELA: TStringField
      FieldName = 'TABELA'
    end
    object qrAuditoriaGridALTERADO: TMemoField
      FieldName = 'ALTERADO'
      OnGetText = qrAuditoriaGridALTERADOGetText
      BlobType = ftMemo
    end
    object qrAuditoriaGridUSUARIO_NOME: TStringField
      FieldKind = fkLookup
      FieldName = 'USUARIO_NOME'
      LookupDataSet = dmFuncionario.qrListaFuncionarios
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'NOME'
      KeyFields = 'USUARIO'
      Lookup = True
    end
  end
end
