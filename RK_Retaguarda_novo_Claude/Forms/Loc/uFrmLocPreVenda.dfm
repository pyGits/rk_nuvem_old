object frmLocPreVenda: TfrmLocPreVenda
  Left = 0
  Top = 0
  Caption = 'Localizar Pr'#233' Venda'
  ClientHeight = 540
  ClientWidth = 805
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 805
    Height = 113
    Align = alTop
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 657
    object Label4: TLabel
      Left = 34
      Top = 9
      Width = 248
      Height = 35
      Caption = 'Localizar Pr'#233' Venda'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 34
      Top = 62
      Width = 58
      Height = 25
      Caption = 'In'#237'cio:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 258
      Top = 62
      Width = 41
      Height = 25
      Caption = 'Fim:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object dtInicio: TJvDateEdit
      Left = 98
      Top = 64
      Width = 121
      Height = 27
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ShowNullDate = False
      TabOrder = 0
    end
    object dtFim: TJvDateEdit
      Left = 314
      Top = 64
      Width = 121
      Height = 27
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ShowNullDate = False
      TabOrder = 1
    end
    object btnPesquisar: TButton
      Left = 624
      Top = 57
      Width = 105
      Height = 42
      Caption = 'Pesquisar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnPesquisarClick
    end
  end
  object grid: TDBGrid
    Left = 0
    Top = 113
    Width = 805
    Height = 427
    Align = alClient
    DataSource = ds
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ParentFont = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = gridDblClick
    OnKeyPress = gridKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'CODIGO'
        Title.Caption = 'C'#243'digo'
        Width = 151
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATA'
        Title.Caption = 'Data'
        Width = 85
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CLIENTE'
        Title.Caption = 'Cliente'
        Width = 299
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TERMINAL'
        Title.Caption = 'Terminal'
        Width = 63
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'VALOR_TOTAL'
        Title.Caption = 'Vlr. Total'
        Width = 159
        Visible = True
      end>
  end
  object ds: TDataSource
    Left = 240
    Top = 192
  end
  object PopupMenu1: TPopupMenu
    Left = 312
    Top = 192
    object S1: TMenuItem
      Caption = 'Sair'
      ShortCut = 27
      OnClick = S1Click
    end
  end
end
