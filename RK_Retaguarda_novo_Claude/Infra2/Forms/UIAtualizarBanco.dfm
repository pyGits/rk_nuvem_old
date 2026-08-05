object frmUIAtualizarBanco: TfrmUIAtualizarBanco
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmUIAtualizarBanco'
  ClientHeight = 498
  ClientWidth = 664
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 664
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    Color = 16744576
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 327
      Height = 25
      Caption = 'Atualiza'#231#227'o do Banco de Dados'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 47
      Width = 332
      Height = 13
      Caption = 
        'Atualizando estrutura do banco de dados para a vers'#227'o mais recen' +
        'te'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 73
    Width = 664
    Height = 64
    Align = alTop
    TabOrder = 1
    ExplicitTop = 67
  end
  object Panel2: TPanel
    Left = 0
    Top = 137
    Width = 664
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label3: TLabel
      Left = 8
      Top = 12
      Width = 107
      Height = 13
      Caption = 'Status da atualiza'#231#227'o:'
    end
    object lblScriptAtual: TLabel
      Left = 167
      Top = 12
      Width = 124
      Height = 13
      Caption = 'Executando script 0/0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 377
    Width = 664
    Height = 121
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object Label6: TLabel
      Left = 16
      Top = 16
      Width = 75
      Height = 13
      Caption = 'Vers'#227'o Atual:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 109
      Top = 16
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label10: TLabel
      Left = 16
      Top = 64
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Shape1: TShape
      Left = 16
      Top = 56
      Width = 569
      Height = 1
      Brush.Color = clSilver
      Pen.Color = clSilver
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 177
    Width = 664
    Height = 200
    Align = alTop
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 4
  end
end
