object frmEnviaNFce: TfrmEnviaNFce
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Enviar NFCes Pendentes'
  ClientHeight = 102
  ClientWidth = 503
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblEnvia: TLabel
    Left = 24
    Top = 32
    Width = 146
    Height = 25
    Caption = 'Enviando NFCe...'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -19
    Font.Name = 'Segoe UI Semibold'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ACBrNFe1: TACBrNFe
    Configuracoes.Geral.SSLLib = libNone
    Configuracoes.Geral.SSLCryptLib = cryNone
    Configuracoes.Geral.SSLHttpLib = httpNone
    Configuracoes.Geral.SSLXmlSignLib = xsNone
    Configuracoes.Geral.FormatoAlerta = 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.'
    Configuracoes.Arquivos.OrdenacaoPath = <>
    Configuracoes.Arquivos.SalvarApenasNFeProcessadas = True
    Configuracoes.WebServices.UF = 'SP'
    Configuracoes.WebServices.Ambiente = taProducao
    Configuracoes.WebServices.AguardarConsultaRet = 0
    Configuracoes.WebServices.QuebradeLinha = '|'
    Configuracoes.RespTec.IdCSRT = 0
    Left = 112
    Top = 48
  end
  object tmEnviarXML: TTimer
    Enabled = False
    OnTimer = tmEnviarXMLTimer
    Left = 240
    Top = 48
  end
end
