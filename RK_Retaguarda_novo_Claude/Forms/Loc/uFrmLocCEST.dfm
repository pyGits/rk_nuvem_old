object frmLocCEST: TfrmLocCEST
  Left = 0
  Top = 0
  Caption = 'Localizar CEST'
  ClientHeight = 535
  ClientWidth = 738
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
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 738
    Height = 81
    Align = alTop
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 0
    object lblNCM: TLabel
      Left = 34
      Top = 9
      Width = 66
      Height = 35
      Caption = 'CEST'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object Grid: TDBGrid
    Left = 0
    Top = 81
    Width = 738
    Height = 454
    Align = alClient
    DataSource = ds
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = GridDblClick
    OnKeyPress = GridKeyPress
    Columns = <
      item
        Expanded = False
        FieldName = 'CEST'
        Width = 92
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NCM'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DESCRICAO'
        Width = 504
        Visible = True
      end>
  end
  object func: TPopupMenu
    Left = 390
    Top = 40
    object S1: TMenuItem
      Caption = 'Sair'
      ShortCut = 27
      OnClick = S1Click
    end
  end
  object ds: TDataSource
    Left = 320
    Top = 200
  end
end
