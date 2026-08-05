object frmRelPainel: TfrmRelPainel
  Left = 0
  Top = 0
  Caption = 'Relat'#243'rio > Painel de vendas'
  ClientHeight = 730
  ClientWidth = 1008
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = func
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object chtCupom: TChart
    Left = 193
    Top = 113
    Width = 815
    Height = 427
    PrintProportional = False
    Title.Text.Strings = (
      'TChart')
    LeftAxis.LabelsFormat.Margins.Right = 71
    LeftAxis.PositionPercent = 50.000000000000000000
    Align = alClient
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      13
      16
      13
      19)
    ColorPaletteIndex = 13
    object Series1: TBarSeries
      MultiBar = mbNone
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 1008
    Height = 113
    Align = alTop
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 1
    object Label4: TLabel
      Left = 34
      Top = 32
      Width = 214
      Height = 35
      Caption = 'Painel de vendas'
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
    Top = 113
    Width = 193
    Height = 427
    Align = alLeft
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 2
    object Label1: TLabel
      Left = 18
      Top = 163
      Width = 52
      Height = 23
      Caption = 'In'#237'cio:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 18
      Top = 227
      Width = 37
      Height = 23
      Caption = 'Fim:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 18
      Top = 27
      Width = 43
      Height = 23
      Caption = 'Tipo:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnVisualizar: TButton
      Left = 18
      Top = 304
      Width = 127
      Height = 41
      Caption = 'Visualizar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnVisualizarClick
      OnKeyPress = dtInicioKeyPress
    end
    object dtInicio: TDateTimePicker
      Left = 18
      Top = 192
      Width = 127
      Height = 24
      Date = 44508.504697916670000000
      Time = 44508.504697916670000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnKeyPress = dtInicioKeyPress
    end
    object dtFim: TDateTimePicker
      Left = 18
      Top = 256
      Width = 127
      Height = 24
      Date = 44508.504697916670000000
      Time = 44508.504697916670000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnKeyPress = dtInicioKeyPress
    end
    object cbTipo: TComboBox
      Left = 18
      Top = 56
      Width = 145
      Height = 26
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
      Text = 'Vendas'
      OnKeyPress = dtInicioKeyPress
      Items.Strings = (
        'Vendas'
        'Produtos'
        'Finalizadoras')
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 540
    Width = 1008
    Height = 190
    Align = alBottom
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 3
    object gridValores: TNextGrid
      Left = 1
      Top = 1
      Width = 1006
      Height = 188
      Touch.InteractiveGestures = [igPan, igPressAndTap]
      Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
      Align = alClient
      Caption = ''
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goHeader, goSelectFullRow]
      RowSize = 20
      ParentFont = False
      TabOrder = 0
      TabStop = True
      ExplicitLeft = 34
      ExplicitTop = 6
      object coluna1: TNxTextColumn
        DefaultWidth = 453
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.Caption = 'Caixa'
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        ParentFont = False
        Position = 0
        SortType = stAlphabetic
        Width = 453
      end
      object coluna2: TNxNumberColumn
        DefaultValue = '0'
        DefaultWidth = 165
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.Caption = 'Valor Total'
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        ParentFont = False
        Position = 1
        SortType = stNumeric
        Width = 165
        FormatMask = 'R$ ###,###,##0.00'
        Increment = 1.000000000000000000
        Precision = 0
      end
      object coluna3: TNxNumberColumn
        DefaultValue = '0'
        DefaultWidth = 139
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.Caption = 'Qtd. Clientes'
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        ParentFont = False
        Position = 2
        SortType = stNumeric
        Width = 139
        Increment = 1.000000000000000000
        Precision = 0
      end
      object NxNumberColumn1: TNxNumberColumn
        DefaultValue = '0'
        DefaultWidth = 128
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Tahoma'
        Font.Style = []
        Header.Caption = 'Ticket M'#233'dio'
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        ParentFont = False
        Position = 3
        SortType = stNumeric
        Width = 128
        FormatMask = '###,###,##0.00'
        Increment = 1.000000000000000000
        Precision = 0
      end
    end
  end
  object func: TPopupMenu
    Left = 496
    Top = 368
    object S1: TMenuItem
      Caption = 'Sair'
      ShortCut = 27
      OnClick = S1Click
    end
  end
end
