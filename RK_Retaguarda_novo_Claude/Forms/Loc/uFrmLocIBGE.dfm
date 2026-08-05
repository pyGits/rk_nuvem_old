object frmLocIbge: TfrmLocIbge
  Left = 0
  Top = 0
  Caption = 'Localizar IBGE'
  ClientHeight = 354
  ClientWidth = 667
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Grid: TDBGrid
    Left = 0
    Top = 113
    Width = 667
    Height = 241
    Align = alClient
    DataSource = ds
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = GridDblClick
    OnKeyPress = GridKeyPress
  end
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 667
    Height = 113
    Align = alTop
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 1
    ExplicitLeft = -70
    ExplicitWidth = 737
    object lblNCM: TLabel
      Left = 34
      Top = 9
      Width = 63
      Height = 35
      Caption = 'IBGE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label124: TLabel
      Left = 34
      Top = 70
      Width = 79
      Height = 23
      Caption = 'Pesquisa:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtLoc: TEdit
      Left = 119
      Top = 70
      Width = 285
      Height = 26
      CharCase = ecUpperCase
      Color = 15916445
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = edtLocChange
      OnKeyPress = edtLocKeyPress
    end
    object cbPesq: TComboBox
      Left = 427
      Top = 70
      Width = 134
      Height = 26
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Items.Strings = (
        'Nome')
    end
  end
  object func: TPopupMenu
    Left = 568
    Top = 8
    object S1: TMenuItem
      Caption = 'Sair'
      ShortCut = 27
      OnClick = S1Click
    end
  end
  object ds: TDataSource
    Left = 280
    Top = 200
  end
end
