object dmPreco: TdmPreco
  OldCreateOrder = False
  Height = 291
  Width = 483
  object qrPreco: TFDQuery
    Connection = dmConexao.FDConnection1
    SQL.Strings = (
      
        'UPDATE PRODUTO SET PRECO = :PRECO,CUSTO=:CUSTO,MARGEM=:MARGEM WH' +
        'ERE CODIGO = :CODIGO')
    Left = 320
    Top = 120
    ParamData = <
      item
        Name = 'PRECO'
        ArrayType = atArray
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'CUSTO'
        DataType = ftBCD
        Precision = 18
        NumericScale = 3
        ParamType = ptInput
      end
      item
        Name = 'MARGEM'
        DataType = ftBCD
        Precision = 18
        NumericScale = 3
        ParamType = ptInput
      end
      item
        Name = 'CODIGO'
        DataType = ftString
        ParamType = ptInput
        Size = 6
      end>
  end
end
