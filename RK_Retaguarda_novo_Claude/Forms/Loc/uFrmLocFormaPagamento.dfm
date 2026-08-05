object frmLocFormaPagamento: TfrmLocFormaPagamento
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Localizar Forma de Pagamento'
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
    object Label4: TLabel
      Left = 34
      Top = 9
      Width = 272
      Height = 35
      Caption = 'Forma de Pagamento'
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
      Header.Font.Charset = ANSI_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -13
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = -1
      SortType = stAlphabetic
    end
    object NxTextColumn1: TNxTextColumn
      DefaultWidth = 464
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      Header.Caption = 'Descri'#231#227'o'
      Header.Font.Charset = ANSI_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -13
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      ParentFont = False
      Position = -1
      SortType = stAlphabetic
    end
  end
end
