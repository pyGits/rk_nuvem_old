object dmConfiguracoes: TdmConfiguracoes
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 377
  Width = 460
  object conexao: TUniConnection
    ProviderName = 'InterBase'
    Database = 'c:\system_rk\pdv\bd\sat_datpdv.fdb'
    Username = 'SYSDBA'
    Server = '127.0.0.1'
    Connected = False
    LoginPrompt = False
    Left = 80
    Top = 16
    EncryptedPassword = '92FF9EFF8CFF8BFF9AFF8DFF94FF9AFF86FF'
  end
  object qrConfiguracaoPDV: TUniQuery
    Connection = conexao
    SQL.Strings = (
      'select * from CONFIGURACOES_PDV')
    Left = 224
    Top = 184
    object qrConfiguracaoPDVID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object qrConfiguracaoPDVCAIXA: TStringField
      FieldName = 'CAIXA'
      Required = True
      Size = 3
    end
    object qrConfiguracaoPDVTIPOPDV: TIntegerField
      FieldName = 'TIPOPDV'
    end
    object qrConfiguracaoPDVNFCE_SSLLIB: TIntegerField
      FieldName = 'NFCE_SSLLIB'
    end
    object qrConfiguracaoPDVNFCE_CRYPTLIB: TIntegerField
      FieldName = 'NFCE_CRYPTLIB'
    end
    object qrConfiguracaoPDVNFCE_HTTPLIB: TIntegerField
      FieldName = 'NFCE_HTTPLIB'
    end
    object qrConfiguracaoPDVNFCE_XMLSIGNLIB: TIntegerField
      FieldName = 'NFCE_XMLSIGNLIB'
    end
    object qrConfiguracaoPDVNFCE_SSLTYPE: TIntegerField
      FieldName = 'NFCE_SSLTYPE'
    end
    object qrConfiguracaoPDVNFCE_CERTCAMINHO: TStringField
      FieldName = 'NFCE_CERTCAMINHO'
      Size = 200
    end
    object qrConfiguracaoPDVNFCE_CERTSENHA: TStringField
      FieldName = 'NFCE_CERTSENHA'
      Size = 50
    end
    object qrConfiguracaoPDVNFCE_NUMSERIE: TStringField
      FieldName = 'NFCE_NUMSERIE'
      Size = 100
    end
    object qrConfiguracaoPDVNFCE_IDTOKEN: TStringField
      FieldName = 'NFCE_IDTOKEN'
    end
    object qrConfiguracaoPDVNFCE_TOKEN: TStringField
      FieldName = 'NFCE_TOKEN'
    end
    object qrConfiguracaoPDVPERIFERICO_USAGAVETA: TIntegerField
      FieldName = 'PERIFERICO_USAGAVETA'
    end
    object qrConfiguracaoPDVPERIFERICO_USAESCPOS: TIntegerField
      FieldName = 'PERIFERICO_USAESCPOS'
    end
    object qrConfiguracaoPDVPERIFERICO_PORTA: TStringField
      FieldName = 'PERIFERICO_PORTA'
      Size = 30
    end
    object qrConfiguracaoPDVPERIFERICO_ESCPOS_1LINHA: TIntegerField
      FieldName = 'PERIFERICO_ESCPOS_1LINHA'
    end
    object qrConfiguracaoPDVPERIFERICO_ESCPOS_MODELO: TIntegerField
      FieldName = 'PERIFERICO_ESCPOS_MODELO'
    end
    object qrConfiguracaoPDVPERIFERICO_ESCPOS_COLUNAS: TIntegerField
      FieldName = 'PERIFERICO_ESCPOS_COLUNAS'
    end
    object qrConfiguracaoPDVPERIFERICO_ESCPOS_ESPACOLIN: TIntegerField
      FieldName = 'PERIFERICO_ESCPOS_ESPACOLIN'
    end
    object qrConfiguracaoPDVPERIFERICO_ESCPOS_LINPULAR: TIntegerField
      FieldName = 'PERIFERICO_ESCPOS_LINPULAR'
    end
    object qrConfiguracaoPDVPERIFERICO_ESCPOS_PAGCOD: TIntegerField
      FieldName = 'PERIFERICO_ESCPOS_PAGCOD'
    end
    object qrConfiguracaoPDVPERIFERICO_FORTES_LARG: TIntegerField
      FieldName = 'PERIFERICO_FORTES_LARG'
    end
    object qrConfiguracaoPDVPERIFERICO_FORTES_TOPO: TIntegerField
      FieldName = 'PERIFERICO_FORTES_TOPO'
    end
    object qrConfiguracaoPDVPERIFERICO_FORTES_FUNDO: TIntegerField
      FieldName = 'PERIFERICO_FORTES_FUNDO'
    end
    object qrConfiguracaoPDVPERIFERICO_FORTES_ESQ: TIntegerField
      FieldName = 'PERIFERICO_FORTES_ESQ'
    end
    object qrConfiguracaoPDVPERIFERICO_FORTES_DIR: TIntegerField
      FieldName = 'PERIFERICO_FORTES_DIR'
    end
    object qrConfiguracaoPDVPERIFERICO_FORTES_PREV: TIntegerField
      FieldName = 'PERIFERICO_FORTES_PREV'
    end
    object qrConfiguracaoPDVPERIFERICO_FORTES_NOME: TStringField
      FieldName = 'PERIFERICO_FORTES_NOME'
      Size = 50
    end
    object qrConfiguracaoPDVEMITENTE_CNPJ: TStringField
      FieldName = 'EMITENTE_CNPJ'
    end
    object qrConfiguracaoPDVEMITENTE_IE: TStringField
      FieldName = 'EMITENTE_IE'
    end
    object qrConfiguracaoPDVSWHOUSE_CNPJ: TStringField
      FieldName = 'SWHOUSE_CNPJ'
    end
    object qrConfiguracaoPDVSWHOUSE_AC: TMemoField
      FieldName = 'SWHOUSE_AC'
      BlobType = ftMemo
    end
    object qrConfiguracaoPDVCFE_MODELOSAT: TIntegerField
      FieldName = 'CFE_MODELOSAT'
    end
    object qrConfiguracaoPDVCFE_CAMINHODLL: TStringField
      FieldName = 'CFE_CAMINHODLL'
      Size = 255
    end
    object qrConfiguracaoPDVCFE_CODIGOATIVACAO: TStringField
      FieldName = 'CFE_CODIGOATIVACAO'
    end
    object qrConfiguracaoPDVCFE_CODUF: TIntegerField
      FieldName = 'CFE_CODUF'
    end
    object qrConfiguracaoPDVCFE_VERSAO: TStringField
      FieldName = 'CFE_VERSAO'
      FixedChar = True
      Size = 5
    end
    object qrConfiguracaoPDVCFE_TIPODLL: TIntegerField
      FieldName = 'CFE_TIPODLL'
    end
    object qrConfiguracaoPDVCFE_VALIDASAT: TIntegerField
      FieldName = 'CFE_VALIDASAT'
    end
    object qrConfiguracaoPDVPERIFERICO_ESCPOS_PORTA: TStringField
      FieldName = 'PERIFERICO_ESCPOS_PORTA'
      Size = 30
    end
    object qrConfiguracaoPDVEMITENTE_IM: TStringField
      FieldName = 'EMITENTE_IM'
      Size = 15
    end
    object qrConfiguracaoPDVPERIFERICO_GER_LINFIN: TIntegerField
      FieldName = 'PERIFERICO_GER_LINFIN'
    end
    object qrConfiguracaoPDVPERIFERICO_GER_MARCA: TStringField
      FieldName = 'PERIFERICO_GER_MARCA'
      Size = 100
    end
    object qrConfiguracaoPDVPERIFERICO_GER_HGUILHO: TIntegerField
      FieldName = 'PERIFERICO_GER_HGUILHO'
    end
    object qrConfiguracaoPDVPERIFERICO_GER_HREIM: TIntegerField
      FieldName = 'PERIFERICO_GER_HREIM'
    end
    object qrConfiguracaoPDVPERIFERICO_GER_HIMP: TIntegerField
      FieldName = 'PERIFERICO_GER_HIMP'
    end
    object qrConfiguracaoPDVBALANCA_MODELO: TIntegerField
      FieldName = 'BALANCA_MODELO'
    end
    object qrConfiguracaoPDVBALANCA_BAUDRATE: TIntegerField
      FieldName = 'BALANCA_BAUDRATE'
    end
    object qrConfiguracaoPDVBALANCA_STOPBITS: TIntegerField
      FieldName = 'BALANCA_STOPBITS'
    end
    object qrConfiguracaoPDVBALANCA_HANDSHAKE: TIntegerField
      FieldName = 'BALANCA_HANDSHAKE'
    end
    object qrConfiguracaoPDVBALANCA_PARIDADE: TIntegerField
      FieldName = 'BALANCA_PARIDADE'
    end
    object qrConfiguracaoPDVBALANCA_DATABITS: TIntegerField
      FieldName = 'BALANCA_DATABITS'
    end
    object qrConfiguracaoPDVBALANCA_TIMEOUT: TIntegerField
      FieldName = 'BALANCA_TIMEOUT'
    end
    object qrConfiguracaoPDVBALANCA_DIGITO: TIntegerField
      FieldName = 'BALANCA_DIGITO'
    end
    object qrConfiguracaoPDVBALANCA_HLEITURA: TIntegerField
      FieldName = 'BALANCA_HLEITURA'
    end
    object qrConfiguracaoPDVBALANCA_HDIGITO2: TIntegerField
      FieldName = 'BALANCA_HDIGITO2'
    end
    object qrConfiguracaoPDVBD_PDV: TStringField
      FieldName = 'BD_PDV'
      Size = 255
    end
    object qrConfiguracaoPDVBD_IPSERVIDOR: TStringField
      FieldName = 'BD_IPSERVIDOR'
      Size = 100
    end
    object qrConfiguracaoPDVBD_SERVIDOR: TStringField
      FieldName = 'BD_SERVIDOR'
      Size = 255
    end
    object qrConfiguracaoPDVVENDEDOR_INFORMAR: TIntegerField
      FieldName = 'VENDEDOR_INFORMAR'
    end
    object qrConfiguracaoPDVVENDEDOR_INFORMARCLI: TIntegerField
      FieldName = 'VENDEDOR_INFORMARCLI'
    end
    object qrConfiguracaoPDVPARAMETROS_LIMDIVERSOS: TFloatField
      FieldName = 'PARAMETROS_LIMDIVERSOS'
    end
    object qrConfiguracaoPDVPARAMETROS_DESCSUBTOTAL: TIntegerField
      FieldName = 'PARAMETROS_DESCSUBTOTAL'
    end
    object qrConfiguracaoPDVPARAMETROS_JANELAS: TIntegerField
      FieldName = 'PARAMETROS_JANELAS'
    end
    object qrConfiguracaoPDVPARAMETROS_COD99: TIntegerField
      FieldName = 'PARAMETROS_COD99'
    end
    object qrConfiguracaoPDVLOGIN_USUARIO: TStringField
      FieldName = 'LOGIN_USUARIO'
      Size = 10
    end
    object qrConfiguracaoPDVLOGIN_SENHA: TStringField
      FieldName = 'LOGIN_SENHA'
      Size = 50
    end
    object qrConfiguracaoPDVPARAMETROS_HPERGUNTAIMPRIMIR: TIntegerField
      FieldName = 'PARAMETROS_HPERGUNTAIMPRIMIR'
    end
    object qrConfiguracaoPDVNFCE_SERIE: TIntegerField
      FieldName = 'NFCE_SERIE'
    end
    object qrConfiguracaoPDVNFCE_NUMERO: TStringField
      FieldName = 'NFCE_NUMERO'
      Size = 9
    end
    object qrConfiguracaoPDVBALANCA_PORTA: TStringField
      FieldName = 'BALANCA_PORTA'
      Size = 11
    end
    object qrConfiguracaoPDVPARAMETROS_VIASSF: TIntegerField
      FieldName = 'PARAMETROS_VIASSF'
    end
    object qrConfiguracaoPDVPARAMETROS_LOGO: TStringField
      FieldName = 'PARAMETROS_LOGO'
      Size = 255
    end
    object qrConfiguracaoPDVPERIFERICO_GAVETA_INVERTIDO: TIntegerField
      FieldName = 'PERIFERICO_GAVETA_INVERTIDO'
    end
    object qrConfiguracaoPDVPARAMETROS_CODIGODIVER: TStringField
      FieldName = 'PARAMETROS_CODIGODIVER'
      Size = 14
    end
    object qrConfiguracaoPDVUSA_CLIENTE_AVULSO: TIntegerField
      FieldName = 'USA_CLIENTE_AVULSO'
    end
    object qrConfiguracaoPDVPARAMETROS_EXIBE_FECHAMENTO: TIntegerField
      FieldName = 'PARAMETROS_EXIBE_FECHAMENTO'
    end
    object qrConfiguracaoPDVCLIENTE_IDENTIFICA_COMPLETO: TIntegerField
      FieldName = 'CLIENTE_IDENTIFICA_COMPLETO'
    end
    object qrConfiguracaoPDVPARAMETROS_HORA_VIRADA: TStringField
      FieldName = 'PARAMETROS_HORA_VIRADA'
      Size = 5
    end
  end
  object InterBaseUniProvider1: TInterBaseUniProvider
    Left = 320
    Top = 24
  end
  object qrConfiguracaoPDVUpdate: TUniQuery
    Connection = conexao
    SQL.Strings = (
      
        'update or insert into CONFIGURACOES_PDV (ID, CAIXA, TIPOPDV, NFC' +
        'E_SSLLIB, NFCE_CRYPTLIB, NFCE_HTTPLIB, NFCE_XMLSIGNLIB,'
      
        '                                         NFCE_SSLTYPE, NFCE_CERT' +
        'CAMINHO, NFCE_CERTSENHA, NFCE_NUMSERIE, NFCE_IDTOKEN,'
      
        '                                         NFCE_TOKEN, PERIFERICO_' +
        'USAGAVETA, PERIFERICO_USAESCPOS, PERIFERICO_PORTA,'
      
        '                                         PERIFERICO_ESCPOS_1LINH' +
        'A, PERIFERICO_ESCPOS_MODELO, PERIFERICO_ESCPOS_COLUNAS,'
      
        '                                         PERIFERICO_ESCPOS_ESPAC' +
        'OLIN, PERIFERICO_ESCPOS_LINPULAR,'
      
        '                                         PERIFERICO_ESCPOS_PAGCO' +
        'D, PERIFERICO_FORTES_LARG, PERIFERICO_FORTES_TOPO,'
      
        '                                         PERIFERICO_FORTES_FUNDO' +
        ', PERIFERICO_FORTES_ESQ, PERIFERICO_FORTES_DIR,'
      
        '                                         PERIFERICO_FORTES_PREV,' +
        ' PERIFERICO_FORTES_NOME, EMITENTE_CNPJ, EMITENTE_IE,'
      
        '                                         SWHOUSE_CNPJ, SWHOUSE_A' +
        'C, CFE_MODELOSAT, CFE_CAMINHODLL, CFE_CODIGOATIVACAO,'
      
        '                                         CFE_CODUF, CFE_VERSAO, ' +
        'CFE_TIPODLL, CFE_VALIDASAT, PERIFERICO_ESCPOS_PORTA,'
      
        '                                         EMITENTE_IM, PERIFERICO' +
        '_GER_LINFIN, PERIFERICO_GER_MARCA,'
      
        '                                         PERIFERICO_GER_HGUILHO,' +
        ' PERIFERICO_GER_HREIM, PERIFERICO_GER_HIMP,'
      
        '                                         BALANCA_MODELO, BALANCA' +
        '_BAUDRATE, BALANCA_STOPBITS, BALANCA_PORTA,'
      
        '                                         BALANCA_HANDSHAKE, BALA' +
        'NCA_PARIDADE, BALANCA_DATABITS, BALANCA_TIMEOUT,'
      
        '                                         BALANCA_DIGITO, BALANCA' +
        '_HLEITURA, BALANCA_HDIGITO2, BD_PDV, BD_IPSERVIDOR,'
      
        '                                         BD_SERVIDOR, VENDEDOR_I' +
        'NFORMAR, VENDEDOR_INFORMARCLI, PARAMETROS_LIMDIVERSOS,'
      
        '                                         PARAMETROS_DESCSUBTOTAL' +
        ', PARAMETROS_JANELAS, PARAMETROS_COD99,PARAMETROS_HPERGUNTAIMPRI' +
        'MIR,NFCE_SERIE,NFCE_NUMERO,PARAMETROS_VIASSF,PARAMETROS_LOGO,PER' +
        'IFERICO_GAVETA_INVERTIDO,PARAMETROS_CODIGODIVER,USA_CLIENTE_AVUL' +
        'SO,PARAMETROS_EXIBE_FECHAMENTO,CLIENTE_IDENTIFICA_COMPLETO,PARAMET' +
        'ROS_HORA_VIRADA)'
      
        'values (:ID, :CAIXA, :TIPOPDV, :NFCE_SSLLIB, :NFCE_CRYPTLIB, :NF' +
        'CE_HTTPLIB, :NFCE_XMLSIGNLIB, :NFCE_SSLTYPE,'
      
        '        :NFCE_CERTCAMINHO, :NFCE_CERTSENHA, :NFCE_NUMSERIE, :NFC' +
        'E_IDTOKEN, :NFCE_TOKEN, :PERIFERICO_USAGAVETA,'
      
        '        :PERIFERICO_USAESCPOS, :PERIFERICO_PORTA, :PERIFERICO_ES' +
        'CPOS_1LINHA, :PERIFERICO_ESCPOS_MODELO,'
      
        '        :PERIFERICO_ESCPOS_COLUNAS, :PERIFERICO_ESCPOS_ESPACOLIN' +
        ', :PERIFERICO_ESCPOS_LINPULAR,'
      
        '        :PERIFERICO_ESCPOS_PAGCOD, :PERIFERICO_FORTES_LARG, :PER' +
        'IFERICO_FORTES_TOPO, :PERIFERICO_FORTES_FUNDO,'
      
        '        :PERIFERICO_FORTES_ESQ, :PERIFERICO_FORTES_DIR, :PERIFER' +
        'ICO_FORTES_PREV, :PERIFERICO_FORTES_NOME,'
      
        '        :EMITENTE_CNPJ, :EMITENTE_IE, :SWHOUSE_CNPJ, :SWHOUSE_AC' +
        ', :CFE_MODELOSAT, :CFE_CAMINHODLL, :CFE_CODIGOATIVACAO,'
      
        '        :CFE_CODUF, :CFE_VERSAO, :CFE_TIPODLL, :CFE_VALIDASAT, :' +
        'PERIFERICO_ESCPOS_PORTA, :EMITENTE_IM,'
      
        '        :PERIFERICO_GER_LINFIN, :PERIFERICO_GER_MARCA, :PERIFERI' +
        'CO_GER_HGUILHO, :PERIFERICO_GER_HREIM,'
      
        '        :PERIFERICO_GER_HIMP, :BALANCA_MODELO, :BALANCA_BAUDRATE' +
        ', :BALANCA_STOPBITS, :BALANCA_PORTA, :BALANCA_HANDSHAKE,'
      
        '        :BALANCA_PARIDADE, :BALANCA_DATABITS, :BALANCA_TIMEOUT, ' +
        ':BALANCA_DIGITO, :BALANCA_HLEITURA, :BALANCA_HDIGITO2,'
      
        '        :BD_PDV, :BD_IPSERVIDOR, :BD_SERVIDOR, :VENDEDOR_INFORMA' +
        'R, :VENDEDOR_INFORMARCLI, :PARAMETROS_LIMDIVERSOS,'
      
        '        :PARAMETROS_DESCSUBTOTAL, :PARAMETROS_JANELAS,:PARAMETRO' +
        'S_COD99,:PARAMETROS_HPERGUNTAIMPRIMIR,:NFCE_SERIE,:NFCE_NUMERO,:' +
        'PARAMETROS_VIASSF,:PARAMETROS_LOGO,:PERIFERICO_GAVETA_INVERTIDO,' +
        ':PARAMETROS_CODIGODIVER,:USA_CLIENTE_AVULSO,:PARAMETROS_EXIBE_FE' +
        'CHAMENTO,:CLIENTE_IDENTIFICA_COMPLETO,:PARAMETROS_HORA_VIRADA)'
      'matching (ID)  ')
    Left = 88
    Top = 128
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ID'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CAIXA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'TIPOPDV'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NFCE_SSLLIB'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NFCE_CRYPTLIB'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NFCE_HTTPLIB'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NFCE_XMLSIGNLIB'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NFCE_SSLTYPE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NFCE_CERTCAMINHO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NFCE_CERTSENHA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NFCE_NUMSERIE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NFCE_IDTOKEN'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NFCE_TOKEN'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_USAGAVETA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_USAESCPOS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_PORTA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_ESCPOS_1LINHA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_ESCPOS_MODELO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_ESCPOS_COLUNAS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_ESCPOS_ESPACOLIN'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_ESCPOS_LINPULAR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_ESCPOS_PAGCOD'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_FORTES_LARG'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_FORTES_TOPO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_FORTES_FUNDO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_FORTES_ESQ'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_FORTES_DIR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_FORTES_PREV'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_FORTES_NOME'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EMITENTE_CNPJ'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EMITENTE_IE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'SWHOUSE_CNPJ'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'SWHOUSE_AC'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CFE_MODELOSAT'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CFE_CAMINHODLL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CFE_CODIGOATIVACAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CFE_CODUF'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CFE_VERSAO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CFE_TIPODLL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CFE_VALIDASAT'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_ESCPOS_PORTA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EMITENTE_IM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_GER_LINFIN'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_GER_MARCA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_GER_HGUILHO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_GER_HREIM'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_GER_HIMP'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BALANCA_MODELO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BALANCA_BAUDRATE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BALANCA_STOPBITS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BALANCA_PORTA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BALANCA_HANDSHAKE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BALANCA_PARIDADE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BALANCA_DATABITS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BALANCA_TIMEOUT'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BALANCA_DIGITO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BALANCA_HLEITURA'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BALANCA_HDIGITO2'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BD_PDV'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BD_IPSERVIDOR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'BD_SERVIDOR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VENDEDOR_INFORMAR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'VENDEDOR_INFORMARCLI'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PARAMETROS_LIMDIVERSOS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PARAMETROS_DESCSUBTOTAL'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PARAMETROS_JANELAS'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PARAMETROS_COD99'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PARAMETROS_HPERGUNTAIMPRIMIR'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NFCE_SERIE'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'NFCE_NUMERO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PARAMETROS_VIASSF'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PARAMETROS_LOGO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PERIFERICO_GAVETA_INVERTIDO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PARAMETROS_CODIGODIVER'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'USA_CLIENTE_AVULSO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PARAMETROS_EXIBE_FECHAMENTO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'CLIENTE_IDENTIFICA_COMPLETO'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'PARAMETROS_HORA_VIRADA'
        Value = nil
      end>
  end
  object UniSQLMonitor1: TUniSQLMonitor
    Left = 352
    Top = 168
  end
end
