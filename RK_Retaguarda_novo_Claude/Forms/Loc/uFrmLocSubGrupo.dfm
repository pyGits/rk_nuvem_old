object frmlocSubGrupo: TfrmlocSubGrupo
  Left = 0
  Top = 0
  Caption = 'Localizar Subgrupo'
  ClientHeight = 508
  ClientWidth = 737
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = func
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object grid: TNextGrid
    Left = 0
    Top = 81
    Width = 737
    Height = 427
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
    ExplicitTop = 80
    ExplicitHeight = 428
    object NxNumberColumn1: TNxTextColumn
      Alignment = taRightJustify
      DefaultValue = '0'
      DefaultWidth = 115
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
      Width = 115
    end
    object NxTextColumn1: TNxTextColumn
      DefaultWidth = 293
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Courier New'
      Font.Style = []
      Header.Caption = 'Grupo'
      Header.Alignment = taCenter
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = 1
      SortType = stAlphabetic
      Width = 293
    end
    object NxTextColumn2: TNxTextColumn
      DefaultWidth = 291
      Header.Caption = 'Subgrupo'
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Position = 2
      SortType = stAlphabetic
      Width = 291
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 737
    Height = 81
    Align = alTop
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 1
    object Label4: TLabel
      Left = 34
      Top = 14
      Width = 122
      Height = 35
      Caption = 'Subgrupo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
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
