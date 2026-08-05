object dmFuncionario: TdmFuncionario
  OldCreateOrder = False
  Height = 360
  Width = 514
  object qrFuncionarioPesquisar: TUniQuery
    Connection = dmConexao.conexao
    Left = 96
    Top = 56
  end
  object qrFuncionarioAlterar: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'update FUNCIONARIO'
      'set NOME = :NOME,'
      '    APELIDO = :APELIDO,'
      '    EMAIL = :EMAIL,'
      '    CPF = :CPF,'
      '    CARGO = :CARGO,'
      '    SENHA = :SENHA,'
      '    COMISSAO = :COMISSAO'
      'where (CODIGO = :CODIGO)   ')
    Left = 176
    Top = 56
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'NOME'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'APELIDO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EMAIL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CPF'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CARGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'SENHA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'COMISSAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
  end
  object qrFuncionarioInserir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'insert into FUNCIONARIO (CODIGO, NOME, APELIDO, EMAIL, CPF, CARG' +
        'O, SENHA, COMISSAO)'
      
        'values (:CODIGO, :NOME, :APELIDO, :EMAIL, :CPF, :CARGO, :SENHA, ' +
        ':COMISSAO)  ')
    Left = 272
    Top = 64
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
        Name = 'APELIDO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EMAIL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CPF'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CARGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'SENHA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'COMISSAO'
        Value = nil
      end>
  end
  object qrFuncionarioExcluir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'delete from FUNCIONARIO'
      'where (CODIGO = :CODIGO)   ')
    Left = 360
    Top = 56
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
  end
  object qrGridFuncionario: TUniQuery
    Connection = dmConexao.conexao
    Left = 272
    Top = 160
  end
  object qrListaFuncionarios: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from funcionario')
    Left = 120
    Top = 192
    object qrListaFuncionariosCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 6
    end
    object qrListaFuncionariosNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object qrListaFuncionariosAPELIDO: TStringField
      FieldName = 'APELIDO'
      Size = 100
    end
    object qrListaFuncionariosEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 100
    end
    object qrListaFuncionariosCPF: TStringField
      FieldName = 'CPF'
      Required = True
      Size = 14
    end
    object qrListaFuncionariosCARGO: TIntegerField
      FieldName = 'CARGO'
    end
    object qrListaFuncionariosSENHA: TStringField
      FieldName = 'SENHA'
      Size = 255
    end
  end
end
