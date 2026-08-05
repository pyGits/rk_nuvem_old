object dmCliente: TdmCliente
  OldCreateOrder = False
  Height = 323
  Width = 462
  object qrClientePesquisar: TUniQuery
    Connection = dmConexao.conexao
    Left = 32
    Top = 80
  end
  object qrClienteAlterar: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'update CLIENTE'
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
      '    OBSERVACAO = :OBSERVACAO,'
      '    DATA_CADASTRO = :DATA_CADASTRO,'
      '    TIPO_PESSOA = :TIPO_PESSOA,'
      '    CREDITO_LIMITE = :CREDITO_LIMITE,'
      '    CREDITO_UTILIZADO = :CREDITO_UTILIZADO,'
      '    DATA_NASCIMENTO = :DATA_NASCIMENTO,'
      '    PERC_DESCONTO = :PERC_DESCONTO'
      'where (CODIGO = :CODIGO)   ')
    Left = 288
    Top = 40
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
        Name = 'OBSERVACAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATA_CADASTRO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TIPO_PESSOA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CREDITO_LIMITE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CREDITO_UTILIZADO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATA_NASCIMENTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERC_DESCONTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
  end
  object qrClienteExcluir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'delete from cliente where codigo = :codigo')
    Left = 88
    Top = 24
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'codigo'
        Value = nil
      end>
  end
  object qrClienteInserir: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      
        'insert into CLIENTE (CODIGO, NOME, NOME_FANTASIA, ENDERECO, NUME' +
        'RO, BAIRRO, CIDADE, UF, CEP, COMPLEMENTO, TELEFONE1,'
      
        '                     TELEFONE2, CELULAR, EMAIL, CNPJCPF, OBSERVA' +
        'CAO, DATA_CADASTRO, TIPO_PESSOA,CREDITO_LIMITE,CREDITO_UTILIZADO' +
        ',DATA_NASCIMENTO,PERC_DESCONTO)'

        'values (:CODIGO, :NOME, :NOME_FANTASIA, :ENDERECO, :NUMERO, :BAI' +
        'RRO, :CIDADE, :UF, :CEP, :COMPLEMENTO, :TELEFONE1,'

        '        :TELEFONE2, :CELULAR, :EMAIL, :CNPJCPF, :OBSERVACAO, :DA' +
        'TA_CADASTRO, :TIPO_PESSOA,:CREDITO_LIMITE,:CREDITO_UTILIZADO,:DA' +
        'TA_NASCIMENTO,:PERC_DESCONTO)  ')
    Left = 352
    Top = 80
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
        Name = 'OBSERVACAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATA_CADASTRO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TIPO_PESSOA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CREDITO_LIMITE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CREDITO_UTILIZADO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATA_NASCIMENTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERC_DESCONTO'
        Value = nil
      end>
  end
  object qrGridCliente: TUniQuery
    Connection = dmConexao.conexao
    Left = 256
    Top = 152
  end
end
