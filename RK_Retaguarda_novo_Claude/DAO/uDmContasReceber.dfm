object dmContasReceber: TdmContasReceber
  OldCreateOrder = False
  Height = 296
  Width = 767
  object qrContasReceberGrid: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from contas_receber')
    Left = 56
    Top = 16
    object qrContasReceberGridCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 50
    end
    object qrContasReceberGridCOD_CUPOM: TStringField
      FieldName = 'COD_CUPOM'
      Required = True
      Size = 50
    end
    object qrContasReceberGridCOD_VENDEDOR: TIntegerField
      FieldName = 'COD_VENDEDOR'
    end
    object qrContasReceberGridCOD_CLIENTE: TStringField
      FieldName = 'COD_CLIENTE'
      Size = 6
    end
    object qrContasReceberGridCOD_CAIXA: TIntegerField
      FieldName = 'COD_CAIXA'
    end
    object qrContasReceberGridDATA_EMISSAO: TDateField
      FieldName = 'DATA_EMISSAO'
    end
    object qrContasReceberGridDATA_VENCIMENTO: TDateField
      FieldName = 'DATA_VENCIMENTO'
    end
    object qrContasReceberGridDATA_PAGAMENTO: TDateField
      FieldName = 'DATA_PAGAMENTO'
    end
    object qrContasReceberGridVALOR: TFloatField
      FieldName = 'VALOR'
      DisplayFormat = '###,###,##0.00'
    end
    object qrContasReceberGridVALOR_PAGO: TFloatField
      FieldName = 'VALOR_PAGO'
      DisplayFormat = '###,###,##0.00'
    end
    object qrContasReceberGridVALOR_DESCONTO: TFloatField
      FieldName = 'VALOR_DESCONTO'
      DisplayFormat = '###,###,##0.00'
    end
    object qrContasReceberGridVALOR_ACRESCIMO: TFloatField
      FieldName = 'VALOR_ACRESCIMO'
      DisplayFormat = '###,###,##0.00'
    end
    object qrContasReceberGridVALOR_RESTANTE: TFloatField
      FieldName = 'VALOR_RESTANTE'
      DisplayFormat = '###,###,##0.00'
    end
    object qrContasReceberGridNUMERO: TStringField
      FieldKind = fkLookup
      FieldName = 'NUMERO'
      LookupDataSet = qrCupomContasReceber
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'NUMERO'
      KeyFields = 'COD_CUPOM'
      Lookup = True
    end
    object qrContasReceberGridCLIENTE: TStringField
      FieldKind = fkLookup
      FieldName = 'CLIENTE'
      LookupDataSet = qrClienteContasReceber
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'NOME'
      KeyFields = 'COD_CLIENTE'
      Lookup = True
    end
    object qrContasReceberGridSELECAO: TIntegerField
      FieldName = 'SELECAO'
      OnGetText = qrContasReceberGridSELECAOGetText
    end
    object qrContasReceberGridCANCELADO: TIntegerField
      FieldName = 'CANCELADO'
    end
    object qrContasReceberGridSTATUS: TIntegerField
      FieldName = 'STATUS'
      OnGetText = qrContasReceberGridSTATUSGetText
    end
  end
  object qrCupomContasReceber: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from cupom')
    Left = 184
    Top = 16
  end
  object qrClienteContasReceber: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from cliente')
    Left = 296
    Top = 16
    object qrClienteContasReceberCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 6
    end
    object qrClienteContasReceberNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object qrClienteContasReceberNOME_FANTASIA: TStringField
      FieldName = 'NOME_FANTASIA'
      Size = 80
    end
    object qrClienteContasReceberENDERECO: TStringField
      FieldName = 'ENDERECO'
      Size = 45
    end
    object qrClienteContasReceberNUMERO: TStringField
      FieldName = 'NUMERO'
      Size = 15
    end
    object qrClienteContasReceberBAIRRO: TStringField
      FieldName = 'BAIRRO'
      Size = 50
    end
    object qrClienteContasReceberCIDADE: TStringField
      FieldName = 'CIDADE'
      Size = 40
    end
    object qrClienteContasReceberUF: TStringField
      FieldName = 'UF'
      FixedChar = True
      Size = 2
    end
    object qrClienteContasReceberCEP: TStringField
      FieldName = 'CEP'
      Size = 10
    end
    object qrClienteContasReceberCOMPLEMENTO: TStringField
      FieldName = 'COMPLEMENTO'
    end
    object qrClienteContasReceberTELEFONE1: TStringField
      FieldName = 'TELEFONE1'
      Size = 15
    end
    object qrClienteContasReceberTELEFONE2: TStringField
      FieldName = 'TELEFONE2'
      Size = 15
    end
    object qrClienteContasReceberCELULAR: TStringField
      FieldName = 'CELULAR'
      FixedChar = True
      Size = 15
    end
    object qrClienteContasReceberEMAIL: TStringField
      FieldName = 'EMAIL'
      Size = 100
    end
    object qrClienteContasReceberCNPJCPF: TStringField
      FieldName = 'CNPJCPF'
      Required = True
      Size = 14
    end
    object qrClienteContasReceberOBSERVACAO: TMemoField
      FieldName = 'OBSERVACAO'
      BlobType = ftMemo
    end
    object qrClienteContasReceberDATA_CADASTRO: TDateField
      FieldName = 'DATA_CADASTRO'
    end
    object qrClienteContasReceberTIPO_PESSOA: TIntegerField
      FieldName = 'TIPO_PESSOA'
    end
    object qrClienteContasReceberCREDITO_LIMITE: TFloatField
      FieldName = 'CREDITO_LIMITE'
    end
    object qrClienteContasReceberCREDITO_UTILIZADO: TFloatField
      FieldName = 'CREDITO_UTILIZADO'
    end
  end
  object qrProdutosGrid: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from cupom_item')
    Left = 56
    Top = 104
    object qrProdutosGridCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 50
    end
    object qrProdutosGridCOD_CUPOM: TStringField
      FieldName = 'COD_CUPOM'
      Required = True
      Size = 50
    end
    object qrProdutosGridITEM: TIntegerField
      FieldName = 'ITEM'
      Required = True
    end
    object qrProdutosGridUNIDADE: TStringField
      FieldName = 'UNIDADE'
      Required = True
      Size = 5
    end
    object qrProdutosGridQTDE: TFloatField
      FieldName = 'QTDE'
      DisplayFormat = '###,###,##0.00'
    end
    object qrProdutosGridVALOR_UNITARIO: TFloatField
      FieldName = 'VALOR_UNITARIO'
      DisplayFormat = '###,###,##0.00'
    end
    object qrProdutosGridVALOR_DESCONTO: TFloatField
      FieldName = 'VALOR_DESCONTO'
      DisplayFormat = '###,###,##0.00'
    end
    object qrProdutosGridVALOR_ACRESCIMO: TFloatField
      FieldName = 'VALOR_ACRESCIMO'
      DisplayFormat = '###,###,##0.00'
    end
    object qrProdutosGridVALOR_TOTAL: TFloatField
      FieldName = 'VALOR_TOTAL'
      DisplayFormat = '###,###,##0.00'
    end
    object qrProdutosGridCANCELADO: TIntegerField
      FieldName = 'CANCELADO'
      Required = True
    end
    object qrProdutosGridEX: TIntegerField
      FieldName = 'EX'
      Required = True
    end
    object qrProdutosGridDATA: TDateField
      FieldName = 'DATA'
      Required = True
    end
    object qrProdutosGridCOD_CAIXA: TIntegerField
      FieldName = 'COD_CAIXA'
      Required = True
    end
    object qrProdutosGridCOD_PRODUTO: TStringField
      FieldName = 'COD_PRODUTO'
      Size = 6
    end
    object qrProdutosGridPRODUTO: TStringField
      FieldKind = fkLookup
      FieldName = 'PRODUTO'
      LookupDataSet = qrProduto
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'COD_PRODUTO'
      Lookup = True
    end
  end
  object qrProduto: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from produto')
    Left = 152
    Top = 104
    object qrProdutoCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 6
    end
    object qrProdutoCODIGO_BARRAS: TStringField
      FieldName = 'CODIGO_BARRAS'
      Required = True
      Size = 14
    end
    object qrProdutoDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 80
    end
    object qrProdutoGRUPO: TStringField
      FieldName = 'GRUPO'
      Size = 6
    end
    object qrProdutoSUBGRUPO: TStringField
      FieldName = 'SUBGRUPO'
      Size = 6
    end
    object qrProdutoFORNECEDOR: TStringField
      FieldName = 'FORNECEDOR'
      Size = 6
    end
    object qrProdutoTRIBUTACAO: TStringField
      FieldName = 'TRIBUTACAO'
      Size = 3
    end
    object qrProdutoNCM: TStringField
      FieldName = 'NCM'
      Size = 8
    end
    object qrProdutoCEST: TStringField
      FieldName = 'CEST'
      Size = 7
    end
    object qrProdutoVALIDADE: TStringField
      FieldName = 'VALIDADE'
      Size = 3
    end
    object qrProdutoBALANCA: TIntegerField
      FieldName = 'BALANCA'
    end
    object qrProdutoFRACIONADO: TIntegerField
      FieldName = 'FRACIONADO'
    end
    object qrProdutoCUSTO: TFloatField
      FieldName = 'CUSTO'
    end
    object qrProdutoPRECO: TFloatField
      FieldName = 'PRECO'
    end
    object qrProdutoMARGEM: TFloatField
      FieldName = 'MARGEM'
    end
    object qrProdutoESTOQUE: TFloatField
      FieldName = 'ESTOQUE'
    end
    object qrProdutoUNIDADE: TStringField
      FieldName = 'UNIDADE'
      Size = 3
    end
    object qrProdutoINATIVO: TIntegerField
      FieldName = 'INATIVO'
    end
    object qrProdutoDIVERSOS: TIntegerField
      FieldName = 'DIVERSOS'
    end
    object qrProdutoDATA_CADASTRO: TDateField
      FieldName = 'DATA_CADASTRO'
    end
    object qrProdutoDATA_ALTERADO: TDateField
      FieldName = 'DATA_ALTERADO'
    end
    object qrProdutoPENDENTE: TIntegerField
      FieldName = 'PENDENTE'
    end
    object qrProdutoOBSERVACAO: TStringField
      FieldName = 'OBSERVACAO'
      Size = 255
    end
  end
  object qrContasReceberPesquisar: TUniQuery
    Connection = dmConexao.conexao
    Left = 272
    Top = 96
  end
  object qrContasReceberAtualizar: TUniQuery
    Connection = dmConexao.conexao
    Left = 392
    Top = 16
  end
  object qrContasReceberPgto: TUniQuery
    Connection = dmConexao.conexao
    Left = 48
    Top = 176
  end
  object qrContasReceberPgtoGrid: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from contas_receber_pagamento')
    Left = 184
    Top = 176
    object qrContasReceberPgtoGridCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 50
    end
    object qrContasReceberPgtoGridCOD_CUPOM: TStringField
      FieldName = 'COD_CUPOM'
      Size = 50
    end
    object qrContasReceberPgtoGridDATA_PAGAMENTO: TDateTimeField
      FieldName = 'DATA_PAGAMENTO'
    end
    object qrContasReceberPgtoGridFINALIZADORA: TStringField
      FieldName = 'FINALIZADORA'
      Size = 3
    end
    object qrContasReceberPgtoGridVALOR: TFloatField
      FieldName = 'VALOR'
      DisplayFormat = '###,###,##0.00'
    end
    object qrContasReceberPgtoGridVALOR_DESCONTO: TFloatField
      FieldName = 'VALOR_DESCONTO'
      DisplayFormat = '###,###,##0.00'
    end
    object qrContasReceberPgtoGridVALOR_ACRESCIMO: TFloatField
      FieldName = 'VALOR_ACRESCIMO'
      DisplayFormat = '###,###,##0.00'
    end
    object qrContasReceberPgtoGridPRESTACAO: TIntegerField
      FieldName = 'PRESTACAO'
    end
    object qrContasReceberPgtoGridCOD_CAIXA: TIntegerField
      FieldName = 'COD_CAIXA'
    end
    object qrContasReceberPgtoGridFUNCIONARIO: TStringField
      FieldName = 'FUNCIONARIO'
      Size = 6
    end
    object qrContasReceberPgtoGridFZDES: TStringField
      FieldKind = fkLookup
      FieldName = 'FZDES'
      LookupDataSet = qrFinalizadora
      LookupKeyFields = 'CODIGO'
      LookupResultField = 'DESCRICAO'
      KeyFields = 'FINALIZADORA'
      Lookup = True
    end
  end
  object qrFinalizadora: TUniQuery
    Connection = dmConexao.conexao
    SQL.Strings = (
      'select * from FINALIZADORA')
    Left = 312
    Top = 176
    object qrFinalizadoraCODIGO: TStringField
      FieldName = 'CODIGO'
      Required = True
      Size = 3
    end
    object qrFinalizadoraDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
    end
    object qrFinalizadoraESPECIE: TIntegerField
      FieldName = 'ESPECIE'
    end
    object qrFinalizadoraTIPO: TStringField
      FieldName = 'TIPO'
      FixedChar = True
      Size = 1
    end
    object qrFinalizadoraCODIGO99: TIntegerField
      FieldName = 'CODIGO99'
    end
  end
  object qrContasReceberExcluir: TUniQuery
    Connection = dmConexao.conexao
    Left = 384
    Top = 96
  end
  object qrContasReceberTotais: TUniQuery
    Connection = dmConexao.conexao
    Left = 424
    Top = 264
  end
end
