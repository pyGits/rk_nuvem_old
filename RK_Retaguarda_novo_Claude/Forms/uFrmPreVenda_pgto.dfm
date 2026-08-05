object frmPreVendaPgto: TfrmPreVendaPgto
  Left = 0
  Top = 0
  Caption = 'Pr'#233' Venda > Pagamento'
  ClientHeight = 408
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 488
    Height = 97
    Align = alTop
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 0
    ExplicitLeft = -5
    ExplicitWidth = 486
    object Label4: TLabel
      Left = 26
      Top = 24
      Width = 301
      Height = 35
      Caption = 'Pr'#233' Venda - Pagamento'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 97
    Width = 488
    Height = 311
    Align = alClient
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    ExplicitLeft = -5
    ExplicitTop = 87
    ExplicitWidth = 486
    ExplicitHeight = 321
    object lblTipoDesconto: TLabel
      Left = 35
      Top = 73
      Width = 112
      Height = 32
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Desconto (R$) :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblTipoAcrescimo: TLabel
      Left = 16
      Top = 111
      Width = 131
      Height = 32
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Acr'#233'scimo (R$) :'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 1
      Top = 26
      Width = 146
      Height = 32
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Forma Pgto:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 16
      Top = 151
      Width = 131
      Height = 32
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Valor Pgto:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtDesconto: TJvCalcEdit
      Left = 153
      Top = 64
      Width = 145
      Height = 27
      DisplayFormat = '###,###,##0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      DecimalPlacesAlwaysShown = False
      OnKeyPress = edtCodFinKeyPress
    end
    object edtAcrescimo: TJvCalcEdit
      Left = 153
      Top = 110
      Width = 145
      Height = 27
      DisplayFormat = '###,###,##0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      DecimalPlacesAlwaysShown = False
      OnKeyPress = edtCodFinKeyPress
    end
    object Panel2: TPanel
      Left = 1
      Top = 227
      Width = 486
      Height = 83
      Align = alBottom
      Color = clActiveCaption
      ParentBackground = False
      TabOrder = 3
      ExplicitTop = 237
      ExplicitWidth = 484
      object lblVlrTotal: TLabel
        Left = 25
        Top = 24
        Width = 151
        Height = 35
        Caption = 'Valor total: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -29
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
    end
    object edtVlrPagamento: TJvCalcEdit
      Left = 153
      Top = 143
      Width = 145
      Height = 27
      DisplayFormat = '###,###,##0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      DecimalPlacesAlwaysShown = False
      OnKeyPress = edtCodFinKeyPress
    end
    object edtCodFin: TEdit
      Left = 153
      Top = 24
      Width = 80
      Height = 27
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnExit = edtCodFinExit
      OnKeyPress = edtCodFinKeyPress
    end
    object edtDescFin: TEdit
      Left = 239
      Top = 24
      Width = 218
      Height = 27
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 392
    Top = 288
    object S1: TMenuItem
      Caption = 'Sair'
      ShortCut = 27
    end
    object A1: TMenuItem
      Caption = 'Alterar'
      ShortCut = 114
    end
  end
end
