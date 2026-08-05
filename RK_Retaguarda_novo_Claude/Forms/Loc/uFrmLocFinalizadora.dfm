object frmLocFinalizadora: TfrmLocFinalizadora
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Localizar Finalizadora'
  ClientHeight = 371
  ClientWidth = 680
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
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 680
    Height = 73
    Align = alTop
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 614
    object lblNCM: TLabel
      Left = 34
      Top = 9
      Width = 152
      Height = 35
      Caption = 'Finalizadora'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object grid: TNextGrid
    Left = 0
    Top = 73
    Width = 680
    Height = 298
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
    TabOrder = 1
    TabStop = True
    OnDblClick = gridDblClick
    OnKeyPress = gridKeyPress
    ExplicitWidth = 689
    ExplicitHeight = 410
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
end
