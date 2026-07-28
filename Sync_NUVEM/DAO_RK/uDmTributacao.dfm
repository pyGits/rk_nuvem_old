object dmTributacao: TdmTributacao
  OldCreateOrder = False
  Height = 370
  Width = 515
  object qrTributacaoInsertUpdate: TUniQuery
    Connection = dmConexao.ConexaoServer
    SQL.Strings = (
      
        'update or insert into tributacao(codigo,descricao,cst,cfop,csosn' +
        ',st,icms)'
      'values (:codigo,:descricao,:cst,:cfop,:csosn,:st,:icms)')
    Left = 72
    Top = 48
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
        Name = 'cst'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'cfop'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'csosn'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'st'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'icms'
        Value = nil
      end>
  end
end
