object dmProprio: TdmProprio
  OldCreateOrder = False
  Height = 320
  Width = 441
  object qrProprioPesquisar: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from proprio')
    Left = 56
    Top = 24
  end
  object qrProprioAlterar: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'update or insert into PROPRIO (CODIGO, NOME, FANTASIA, ENDERECO,' +
        ' BAIRRO, CIDADE, UF, CEP, TELEFONE, CNPJCPF, IE, EMAIL,'
      
        '                     RESPONSAVEL, CELULAR, LOGO, NUMERO, COMPLEM' +
        'ENTO, RG, INSC_MUNICIPAL, COD_MUNICIPIO_IBGE, IBGE)'
      
        'values (:CODIGO, :NOME, :FANTASIA, :ENDERECO, :BAIRRO, :CIDADE, ' +
        ':UF, :CEP, :TELEFONE, :CNPJCPF, :IE, :EMAIL,'
      
        '        :RESPONSAVEL, :CELULAR, :LOGO, :NUMERO, :COMPLEMENTO, :R' +
        'G, :INSC_MUNICIPAL, :COD_MUNICIPIO_IBGE, :IBGE)  ')
    Left = 152
    Top = 24
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NOME'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FANTASIA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ENDERECO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BAIRRO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CIDADE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UF'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CEP'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TELEFONE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CNPJCPF'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'IE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EMAIL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'RESPONSAVEL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CELULAR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'LOGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NUMERO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'COMPLEMENTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'RG'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'INSC_MUNICIPAL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'COD_MUNICIPIO_IBGE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'IBGE'
        Value = nil
      end>
  end
  object fxemitente: TfrxDBDataset
    UserName = 'fxemitente'
    CloseDataSource = False
    FieldAliases.Strings = (
      'CODIGO=CODIGO'
      'NOME=NOME'
      'FANTASIA=FANTASIA'
      'ENDERECO=ENDERECO'
      'BAIRRO=BAIRRO'
      'CIDADE=CIDADE'
      'UF=UF'
      'CEP=CEP'
      'TELEFONE=TELEFONE'
      'CNPJCPF=CNPJCPF'
      'IE=IE'
      'EMAIL=EMAIL'
      'RESPONSAVEL=RESPONSAVEL'
      'CELULAR=CELULAR'
      'LOGO=LOGO'
      'NUMERO=NUMERO'
      'COMPLEMENTO=COMPLEMENTO'
      'RG=RG'
      'INSC_MUNICIPAL=INSC_MUNICIPAL'
      'COD_MUNICIPIO_IBGE=COD_MUNICIPIO_IBGE'
      'IBGE=IBGE')
    DataSet = qrEmitente
    BCDToCurrency = False
    Left = 152
    Top = 168
  end
  object qrEmitente: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from proprio')
    Left = 56
    Top = 176
    object qrEmitenteCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 6
    end
    object qrEmitenteNOME: TStringField
      FieldName = 'NOME'
      Size = 80
    end
    object qrEmitenteFANTASIA: TStringField
      FieldName = 'FANTASIA'
      Size = 80
    end
    object qrEmitenteENDERECO: TStringField
      FieldName = 'ENDERECO'
      Size = 80
    end
    object qrEmitenteBAIRRO: TStringField
      FieldName = 'BAIRRO'
      Size = 50
    end
    object qrEmitenteCIDADE: TStringField
      FieldName = 'CIDADE'
      Size = 40
    end
    object qrEmitenteUF: TStringField
      FieldName = 'UF'
      Size = 2
    end
    object qrEmitenteCEP: TStringField
      FieldName = 'CEP'
      Size = 10
    end
    object qrEmitenteTELEFONE: TStringField
      FieldName = 'TELEFONE'
      Size = 30
    end
    object qrEmitenteCNPJCPF: TStringField
      FieldName = 'CNPJCPF'
      Size = 25
    end
    object qrEmitenteIE: TStringField
      FieldName = 'IE'
    end
    object qrEmitenteEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 80
    end
    object qrEmitenteRESPONSAVEL: TStringField
      FieldName = 'RESPONSAVEL'
      Size = 50
    end
    object qrEmitenteCELULAR: TStringField
      FieldName = 'CELULAR'
    end
    object qrEmitenteLOGO: TBlobField
      FieldName = 'LOGO'
    end
    object qrEmitenteNUMERO: TStringField
      FieldName = 'NUMERO'
      Size = 10
    end
    object qrEmitenteCOMPLEMENTO: TStringField
      FieldName = 'COMPLEMENTO'
      Size = 30
    end
    object qrEmitenteRG: TStringField
      FieldName = 'RG'
    end
    object qrEmitenteINSC_MUNICIPAL: TStringField
      FieldName = 'INSC_MUNICIPAL'
    end
    object qrEmitenteCOD_MUNICIPIO_IBGE: TStringField
      FieldName = 'COD_MUNICIPIO_IBGE'
      Size = 10
    end
    object qrEmitenteIBGE: TStringField
      FieldName = 'IBGE'
      Size = 10
    end
  end
end
