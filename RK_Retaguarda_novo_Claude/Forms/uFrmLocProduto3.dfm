object FrmLocProduto3: TFrmLocProduto3
  Left = 0
  Top = 0
  Caption = 'Localizar Produto'
  ClientHeight = 480
  ClientWidth = 833
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 833
    Height = 113
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 750
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 175
      Height = 19
      Caption = 'Nome/C'#243'digo de barras:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 380
      Top = 24
      Width = 38
      Height = 19
      Caption = 'Tipo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 492
      Top = 24
      Width = 50
      Height = 19
      Caption = 'Grupo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtBusca: TEdit
      Left = 16
      Top = 58
      Width = 350
      Height = 27
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnEnter = edtBuscaEnter
      OnKeyPress = edtBuscaKeyPress
    end
    object cbTipoBusca: TComboBox
      Left = 380
      Top = 58
      Width = 93
      Height = 27
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object btnBuscar: TButton
      Left = 686
      Top = 57
      Width = 117
      Height = 29
      Caption = 'Buscar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnBuscarClick
    end
    object cbGrupo: TComboBox
      Left = 492
      Top = 58
      Width = 125
      Height = 27
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 113
    Width = 833
    Height = 271
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 750
    ExplicitHeight = 255
    object gridProdutos: TStringGrid
      Left = 1
      Top = 1
      Width = 831
      Height = 269
      Align = alClient
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      TabOrder = 0
      OnDblClick = gridProdutosDblClick
      OnDrawCell = gridProdutosDrawCell
      OnKeyDown = gridProdutosKeyDown
      OnKeyPress = gridProdutosKeyPress
      ExplicitHeight = 308
      ColWidths = (
        64
        64
        64
        64
        64)
      RowHeights = (
        24
        24
        24
        24
        24)
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 384
    Width = 833
    Height = 96
    Align = alBottom
    TabOrder = 2
    object Label3: TLabel
      Left = 16
      Top = 68
      Width = 276
      Height = 16
      Caption = 'Pressione Espa'#231'o para selecionar, ou duplo click'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnConfirmar: TButton
      Left = 638
      Top = 14
      Width = 180
      Height = 25
      Caption = 'Confirmar Sele'#231#227'o'
      TabOrder = 0
      OnClick = btnConfirmarClick
    end
    object btnLimparSelecao: TButton
      Left = 446
      Top = 14
      Width = 180
      Height = 25
      Caption = 'Limpar Sele'#231#227'o'
      TabOrder = 1
      OnClick = btnLimparSelecaoClick
    end
    object btnSelecionarTodos: TButton
      Left = 260
      Top = 14
      Width = 180
      Height = 25
      Caption = 'Selecionar Todos'
      TabOrder = 2
      OnClick = btnSelecionarTodosClick
    end
  end
end
