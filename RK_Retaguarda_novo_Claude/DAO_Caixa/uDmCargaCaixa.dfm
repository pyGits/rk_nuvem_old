object dmCargaCaixa: TdmCargaCaixa
  OldCreateOrder = False
  Height = 382
  Width = 506
  object qrProdutoInserir: TUniQuery
    Connection = dmConexaoCaixa.conexaoCaixa
    SQL.Strings = (
      
        'UPDATE OR insert into ESTOQUE (CODIGO, COD_BARRA, NOME, UNIDADE,' +
        ' PRECO_VENDA, PRECO_PROMOCAO, INICIO_PROMOCAO, FINAL_PROMOCAO,'
      
        '                     CST, ALIQUOTA, DESCONTO_MAXIMO, ST, ESTOQUE' +
        ', IAT, IPPT, SITUACAO, REFERENCIA, TAMANHO, COR,'
      
        '                     DESCRICAO_COR, DESCRICAO_MARCA, NCM, ALIQIM' +
        'PORTADO, ALIQNACIONAL, CFOP, CSOSN, USA_BALANCA,'
      
        '                     PRECO_PROMOCAO_XY, QTDE_PROMOCAO_XY, HABILI' +
        'TA_XY, PRECO_VENDA1, PRECO_VARIAVEL, CUSTO, CEST,'
      
        '                     QTD_ATACADO1, PRECO_VENDA2, QTD_ATACADO2,TR' +
        'IBUTACAO,OBSERVACAO)'
      
        'values (:CODIGO, :COD_BARRA, :NOME, :UNIDADE, :PRECO_VENDA, :PRE' +
        'CO_PROMOCAO, :INICIO_PROMOCAO, :FINAL_PROMOCAO, :CST,'
      
        '        :ALIQUOTA, :DESCONTO_MAXIMO, :ST, :ESTOQUE, :IAT, :IPPT,' +
        ' :SITUACAO, :REFERENCIA, :TAMANHO, :COR, :DESCRICAO_COR,'
      
        '        :DESCRICAO_MARCA, :NCM, :ALIQIMPORTADO, :ALIQNACIONAL, :' +
        'CFOP, :CSOSN, :USA_BALANCA, :PRECO_PROMOCAO_XY,'
      
        '        :QTDE_PROMOCAO_XY, :HABILITA_XY, :PRECO_VENDA1, :PRECO_V' +
        'ARIAVEL, :CUSTO, :CEST, :QTD_ATACADO1, :PRECO_VENDA2,'
      '        :QTD_ATACADO2,:TRIBUTACAO,:OBSERVACAO)  ')
    Left = 80
    Top = 40
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'COD_BARRA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NOME'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UNIDADE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PRECO_VENDA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PRECO_PROMOCAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'INICIO_PROMOCAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FINAL_PROMOCAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CST'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ALIQUOTA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DESCONTO_MAXIMO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ST'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ESTOQUE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'IAT'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'IPPT'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'SITUACAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'REFERENCIA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TAMANHO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'COR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DESCRICAO_COR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DESCRICAO_MARCA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NCM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ALIQIMPORTADO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ALIQNACIONAL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CFOP'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CSOSN'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'USA_BALANCA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PRECO_PROMOCAO_XY'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'QTDE_PROMOCAO_XY'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'HABILITA_XY'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PRECO_VENDA1'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PRECO_VARIAVEL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CUSTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CEST'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'QTD_ATACADO1'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PRECO_VENDA2'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'QTD_ATACADO2'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TRIBUTACAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'OBSERVACAO'
        Value = nil
      end>
  end
  object qrTributacaoInserir: TUniQuery
    Connection = dmConexaoCaixa.conexaoCaixa
    SQL.Strings = (
      
        'update or insert into TRIBUTACAO (CODIGO, DESCRICAO, CST, CFOP, ' +
        'CSOSN, ST, ICMS)'
      'values (:CODIGO, :DESCRICAO, :CST, :CFOP, :CSOSN, :ST, :ICMS)  ')
    Left = 288
    Top = 32
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DESCRICAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CST'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CFOP'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CSOSN'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ST'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ICMS'
        Value = nil
      end>
  end
  object qrClienteInserir: TUniQuery
    Connection = dmConexaoCaixa.conexaoCaixa
    SQL.Strings = (
      
        'update or insert into CLIENTE (CODIGO, NOME, CPF, ENDERECO, COMP' +
        'LEMENTO, BAIRRO, CIDADE, UF, CEP, SITUACAO, OBS, LIMITE,'
      
        '                     UTILIZADO, DISPONIVEL, ATUALIZADO,UTILIZA_P' +
        'RECO2,PERC_DESCONTO)'

        'values (:CODIGO, :NOME, :CPF, :ENDERECO, :COMPLEMENTO, :BAIRRO, ' +
        ':CIDADE, :UF, :CEP, :SITUACAO, :OBS, :LIMITE,'

        '        :UTILIZADO, :DISPONIVEL, :ATUALIZADO,:UTILIZA_PRECO2,:PE' +
        'RC_DESCONTO)  ')
    Left = 176
    Top = 32
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
        Name = 'CPF'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ENDERECO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'COMPLEMENTO'
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
        Name = 'SITUACAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'OBS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'LIMITE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UTILIZADO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DISPONIVEL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ATUALIZADO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'UTILIZA_PRECO2'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERC_DESCONTO'
        Value = nil
      end>
  end
  object qrFuncionarioInserir: TUniQuery
    Connection = dmConexaoCaixa.conexaoCaixa
    SQL.Strings = (
      
        'update or insert into ADM (CODIGO, INFO1, INFO2, INFO3, INFO4, I' +
        'NFO5, INFO6, FUNCNIV, DESCONTO_MAXIMO_PORCENTAGEM)'
      
        'values (:CODIGO, :INFO1, :INFO2, :INFO3, :INFO4, :INFO5, :INFO6,' +
        ' :FUNCNIV, :DESCONTO_MAXIMO_PORCENTAGEM)  ')
    Left = 208
    Top = 112
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'INFO1'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'INFO2'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'INFO3'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'INFO4'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'INFO5'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'INFO6'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FUNCNIV'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DESCONTO_MAXIMO_PORCENTAGEM'
        Value = nil
      end>
  end
  object qrFinalizadoraInserir: TUniQuery
    Connection = dmConexaoCaixa.conexaoCaixa
    SQL.Strings = (
      
        'update or insert into FINALIZADORA (FZCOD, FZDES, FZESPECIE, FZT' +
        'IPO, FZCOD99, FZTECLA)'
      
        'values (:FZCOD, :FZDES, :FZESPECIE, :FZTIPO, :FZCOD99, :FZTECLA)' +
        '  ')
    Left = 176
    Top = 192
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'FZCOD'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FZDES'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FZESPECIE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FZTIPO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FZCOD99'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FZTECLA'
        Value = nil
      end>
  end
  object qrProprioInserir: TUniQuery
    Connection = dmConexaoCaixa.conexaoCaixa
    SQL.Strings = (
      
        'update or insert into PROPRIO (CODIGO, NOME, FANTASIA, ENDERECO,' +
        ' BAIRRO, CIDADE, UF, CEP, TELEFONE, CNPJ, IE, EMAIL, HOMEPAGE,'
      
        '                     RESPONSAVEL, CELULAR, LOGO, FAX, NUMERO, CO' +
        'MPLEMENTO, CONTRIBUINTE_IPI, SUBSTITUTO_TRIBUTARIO,'
      
        '                     COMENTARIOS, DATAHORA_INICIAL, DATAHORA_FIN' +
        'AL, DATA_INVENTARIO, ESTOQUE, VALOR, CONHECIMENTO, CPF,'
      
        '                     RG, DIA_VENCIMENTO_CHAVE, INSC_MUNICIPAL, D' +
        'ATA_ABERTURA, COD_MUNICIPIO_IBGE, IBGE,'
      '                     EMAIL_FINANCEIRO)'
      
        'values (:CODIGO, :NOME, :FANTASIA, :ENDERECO, :BAIRRO, :CIDADE, ' +
        ':UF, :CEP, :TELEFONE, :CNPJ, :IE, :EMAIL, :HOMEPAGE,'
      
        '        :RESPONSAVEL, :CELULAR, :LOGO, :FAX, :NUMERO, :COMPLEMEN' +
        'TO, :CONTRIBUINTE_IPI, :SUBSTITUTO_TRIBUTARIO,'
      
        '        :COMENTARIOS, :DATAHORA_INICIAL, :DATAHORA_FINAL, :DATA_' +
        'INVENTARIO, :ESTOQUE, :VALOR, :CONHECIMENTO, :CPF, :RG,'
      
        '        :DIA_VENCIMENTO_CHAVE, :INSC_MUNICIPAL, :DATA_ABERTURA, ' +
        ':COD_MUNICIPIO_IBGE, :IBGE, :EMAIL_FINANCEIRO)  ')
    Left = 328
    Top = 176
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
        Name = 'CNPJ'
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
        Name = 'HOMEPAGE'
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
        Name = 'FAX'
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
        Name = 'CONTRIBUINTE_IPI'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'SUBSTITUTO_TRIBUTARIO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'COMENTARIOS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATAHORA_INICIAL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATAHORA_FINAL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATA_INVENTARIO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ESTOQUE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VALOR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CONHECIMENTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CPF'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'RG'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DIA_VENCIMENTO_CHAVE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'INSC_MUNICIPAL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'DATA_ABERTURA'
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
      end
      item
        DataType = ftUnknown
        Name = 'EMAIL_FINANCEIRO'
        Value = nil
      end>
  end
  object qrNivelAcessoInserir: TUniQuery
    Connection = dmConexaoCaixa.conexaoCaixa
    SQL.Strings = (
      
        'update or insert into FUNCOES (CODIGO, ACFUNC, FUNCNIV, FUNCSOLI' +
        'C)'
      'values (:CODIGO, :ACFUNC, :FUNCNIV, :FUNCSOLIC)'
      'matching (CODIGO)  ')
    Left = 288
    Top = 272
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'ACFUNC'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FUNCNIV'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'FUNCSOLIC'
        Value = nil
      end>
  end
  object qrProdutoDeletar: TUniQuery
    Connection = dmConexaoCaixa.conexaoCaixa
    SQL.Strings = (
      'delete from estoque where codigo = :codigo;')
    Left = 64
    Top = 120
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'CODIGO'
        Value = nil
      end>
  end
  object qrDeletar: TUniQuery
    Connection = dmConexaoCaixa.conexaoCaixa
    Left = 48
    Top = 280
  end
  object qrConfiguracoesPDV: TUniQuery
    Connection = dmConexaoCaixa.conexaoCaixa
    SQL.Strings = (
      
        'UPDATE CONFIGURACOES_PDV SET LIMITE_DESCONTO_PERC = :LIMITE_DESC' +
        'ONTO_PERC')
    Left = 128
    Top = 312
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'LIMITE_DESCONTO_PERC'
        Value = nil
      end>
  end
end
