object frmImportarPersonalizado: TfrmImportarPersonalizado
  Left = 0
  Top = 0
  Caption = 'Importar Planilha'
  ClientHeight = 600
  ClientWidth = 954
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object gridPlanilha: TStringGrid
    Left = 193
    Top = 97
    Width = 761
    Height = 503
    Align = alClient
    TabOrder = 0
    OnDrawCell = gridPlanilhaDrawCell
    OnSelectCell = gridPlanilhaSelectCell
    ExplicitLeft = 272
    ExplicitTop = 160
    ExplicitWidth = 320
    ExplicitHeight = 120
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 954
    Height = 97
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 49
      Height = 18
      Caption = 'Tabela:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Button1: TButton
      Left = 193
      Top = 19
      Width = 144
      Height = 42
      Caption = 'Importar Planilha'
      TabOrder = 0
      OnClick = Button1Click
    end
    object cbTabela: TComboBox
      Left = 16
      Top = 35
      Width = 145
      Height = 26
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnChange = cbTabelaChange
      Items.Strings = (
        'CLIENTE')
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 97
    Width = 193
    Height = 503
    Align = alLeft
    TabOrder = 2
    object Label2: TLabel
      Left = 16
      Top = 16
      Width = 48
      Height = 18
      Caption = 'Coluna:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 17
      Top = 104
      Width = 54
      Height = 18
      Caption = 'Sele'#231#227'o:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object cbColuna: TComboBox
      Left = 16
      Top = 43
      Width = 145
      Height = 26
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object abrirPlanilha: TOpenDialog
    Left = 56
    Top = 304
  end
end
