object dmFornecedor: TdmFornecedor
  OldCreateOrder = False
  Height = 381
  Width = 420
  object qrFornecedorPesquisar: TUniQuery
    Connection = dmConexao.conexao
    Left = 96
    Top = 48
  end
  object qrFornecedorInserir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'insert into FORNECEDOR (CODIGO, NOME, NOME_FANTASIA, ENDERECO, N' +
        'UMERO, BAIRRO, CIDADE, UF, CEP, COMPLEMENTO, TELEFONE1,'
      
        '                        TELEFONE2, CELULAR, EMAIL, CNPJCPF, IE, ' +
        'IM, OBSERVACAO, CONTATO1, CONTATO2)'
      
        'values (:CODIGO, :NOME, :NOME_FANTASIA, :ENDERECO, :NUMERO, :BAI' +
        'RRO, :CIDADE, :UF, :CEP, :COMPLEMENTO, :TELEFONE1,'
      
        '        :TELEFONE2, :CELULAR, :EMAIL, :CNPJCPF, :IE, :IM, :OBSER' +
        'VACAO, :CONTATO1, :CONTATO2)  ')
    Left = 168
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
        Name = 'NOME_FANTASIA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ENDERECO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NUMERO'
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
        Name = 'COMPLEMENTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TELEFONE1'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TELEFONE2'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CELULAR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EMAIL'
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
        Name = 'IM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'OBSERVACAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CONTATO1'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CONTATO2'
        Value = nil
      end>
  end
  object qrFornecedorAlterar: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'update FORNECEDOR'
      'set NOME = :NOME,'
      '    NOME_FANTASIA = :NOME_FANTASIA,'
      '    ENDERECO = :ENDERECO,'
      '    NUMERO = :NUMERO,'
      '    BAIRRO = :BAIRRO,'
      '    CIDADE = :CIDADE,'
      '    UF = :UF,'
      '    CEP = :CEP,'
      '    COMPLEMENTO = :COMPLEMENTO,'
      '    TELEFONE1 = :TELEFONE1,'
      '    TELEFONE2 = :TELEFONE2,'
      '    CELULAR = :CELULAR,'
      '    EMAIL = :EMAIL,'
      '    CNPJCPF = :CNPJCPF,'
      '    IE = :IE,'
      '    IM = :IM,'
      '    OBSERVACAO = :OBSERVACAO,'
      '    CONTATO1 = :CONTATO1,'
      '    CONTATO2 = :CONTATO2'
      'where (CODIGO = :CODIGO)   ')
    Left = 272
    Top = 24
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'NOME'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NOME_FANTASIA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ENDERECO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NUMERO'
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
        Name = 'COMPLEMENTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TELEFONE1'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TELEFONE2'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CELULAR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EMAIL'
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
        Name = 'IM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'OBSERVACAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CONTATO1'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CONTATO2'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
  end
  object qrFornecedorExcluir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'delete from fornecedor where codigo = :CODIGO')
    Left = 288
    Top = 128
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
  end
  object qrGridFornecedor: TUniQuery
    Connection = dmConexao.conexao
    Left = 104
    Top = 56
  end
end
