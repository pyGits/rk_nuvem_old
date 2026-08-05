object frmLocGrupo: TfrmLocGrupo
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Localizar Grupo'
  ClientHeight = 385
  ClientWidth = 685
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = func
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grid: TNextGrid
    Left = 0
    Top = 113
    Width = 685
    Height = 272
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Align = alClient
    AppearanceOptions = [aoHighlightSlideCells]
    BorderStyle = bsNone
    Caption = ''
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    GridLinesStyle = lsVerticalOnly
    HideScrollBar = False
    Options = [goGrid, goHeader, goSelectFullRow]
    ParentFont = False
    TabOrder = 0
    TabStop = True
    OnCellDblClick = gridCellDblClick
    OnKeyPress = gridKeyPress
    object NxNumberColumn1: TNxTextColumn
      Alignment = taRightJustify
      DefaultValue = '0'
      DefaultWidth = 216
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Courier New'
      Font.Style = []
      Header.Caption = 'C'#243'digo'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Options = [coCanClick, coCanInput, coCanSort, coPublicUsing]
      ParentFont = False
      Position = 0
      SortType = stAlphabetic
      Width = 216
    end
    object NxTextColumn1: TNxTextColumn
      DefaultWidth = 436
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Courier New'
      Font.Style = []
      Header.Caption = 'Descri'#231#227'o'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 1
      SortType = stAlphabetic
      Width = 436
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 685
    Height = 113
    Align = alTop
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 1
    object Label4: TLabel
      Left = 34
      Top = 9
      Width = 77
      Height = 35
      Caption = 'Grupo'
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
      Left = 122
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
      ItemIndex = 0
      ParentFont = False
      TabOrder = 1
      Text = 'Nome'
      Items.Strings = (
        'Nome'
        'C'#243'digo')
    end
  end
  object func: TPopupMenu
    Left = 328
    Top = 192
    object S1: TMenuItem
      Caption = 'Sair'
      ShortCut = 27
      OnClick = S1Click
    end
  end
end
