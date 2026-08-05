object frmAuditoria: TfrmAuditoria
  Left = 0
  Top = 0
  Caption = 'Visualizar auditoria'
  ClientHeight = 567
  ClientWidth = 741
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  WindowState = wsMaximized
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 741
    Height = 113
    Align = alTop
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 0
    object Label4: TLabel
      Left = 26
      Top = 17
      Width = 114
      Height = 35
      Caption = 'Auditoria'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 24
      Top = 61
      Width = 67
      Height = 16
      Caption = 'Data inicial:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 240
      Top = 61
      Width = 59
      Height = 16
      Caption = 'Data final:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnVisualizar: TButton
      Left = 646
      Top = 72
      Width = 91
      Height = 29
      Caption = 'Visualizar'
      TabOrder = 0
      OnClick = btnVisualizarClick
    end
    object dtInicial: TDateTimePicker
      Left = 24
      Top = 80
      Width = 186
      Height = 21
      Date = 44533.000000000000000000
      Time = 44533.000000000000000000
      DoubleBuffered = False
      ParentDoubleBuffered = False
      TabOrder = 1
    end
    object dtFinal: TDateTimePicker
      Left = 240
      Top = 80
      Width = 186
      Height = 21
      Date = 44533.999305555550000000
      Time = 44533.999305555550000000
      TabOrder = 2
    end
    object cbTipo: TComboBox
      Left = 464
      Top = 80
      Width = 145
      Height = 21
      ItemIndex = 3
      TabOrder = 3
      Text = 'Todos'
      Items.Strings = (
        'Inclus'#227'o'
        'Alterado'
        'Exclus'#227'o'
        'Todos')
    end
  end
  object pcAuditoria: TPageControl
    Left = 0
    Top = 113
    Width = 741
    Height = 454
    ActivePage = tsLista
    Align = alClient
    TabOrder = 1
    object tsLista: TTabSheet
      Caption = 'Lista de auditoria'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      object grid: TDBGrid
        Left = 0
        Top = 0
        Width = 733
        Height = 426
        Align = alClient
        DataSource = ds
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDrawColumnCell = gridDrawColumnCell
        Columns = <
          item
            Expanded = False
            FieldName = 'DATA_REGISTRO'
            Title.Caption = 'Data/Hora'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'USUARIO_NOME'
            Title.Caption = 'Usu'#225'rio'
            Width = 171
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TABELA'
            Title.Caption = 'Tabela'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'ALTERADO'
            Title.Caption = 'Alterado'
            Width = 478
            Visible = True
          end>
      end
    end
  end
  object func: TPopupMenu
    Left = 328
    Top = 296
    object S1: TMenuItem
      Caption = 'Sair'
      ShortCut = 27
    end
    object I1: TMenuItem
      Caption = 'Incluir'
      ShortCut = 116
    end
    object g1: TMenuItem
      Caption = 'Gravar'
      ShortCut = 120
    end
    object C1: TMenuItem
      Caption = 'Cancelar'
      ShortCut = 117
    end
    object E1: TMenuItem
      Caption = 'Excluir'
      ShortCut = 46
    end
    object a1: TMenuItem
      Caption = 'Alterar'
      ShortCut = 118
    end
  end
  object ds: TDataSource
    Left = 212
    Top = 233
  end
end
