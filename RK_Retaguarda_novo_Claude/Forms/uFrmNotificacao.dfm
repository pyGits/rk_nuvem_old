object frmNotificacao: TfrmNotificacao
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Central de Notifica'#231#245'es'
  ClientHeight = 517
  ClientWidth = 879
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 879
    Height = 113
    Align = alTop
    Color = clActiveCaption
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 866
    object Label4: TLabel
      Left = 26
      Top = 17
      Width = 153
      Height = 35
      Caption = 'Notifica'#231#245'es'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 256
      Top = 29
      Width = 149
      Height = 21
      Caption = 'Filtrar Por Categoria:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnVisualizar: TButton
      Left = 26
      Top = 62
      Width = 91
      Height = 29
      Caption = 'Atualizar'
      TabOrder = 0
      OnClick = btnVisualizarClick
    end
    object cbFiltroCategoria: TComboBox
      Left = 256
      Top = 56
      Width = 281
      Height = 29
      Style = csDropDownList
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ItemIndex = 0
      ParentFont = False
      TabOrder = 1
      Text = 'Todos'
      OnChange = cbFiltroCategoriaChange
      Items.Strings = (
        'Todos'
        'Produto'
        'Validade'
        'Cliente')
    end
  end
  object pcAuditoria: TPageControl
    Left = 0
    Top = 113
    Width = 879
    Height = 404
    ActivePage = tsLista
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 866
    object tsLista: TTabSheet
      Caption = 'Lista de Notifica'#231#245'es'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 858
      object grid: TNextGrid
        Left = 0
        Top = 0
        Width = 871
        Height = 376
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
        Align = alClient
        Caption = ''
        Options = [goHeader, goSelectFullRow]
        TabOrder = 0
        TabStop = True
        OnCellDblClick = gridCellDblClick
        ExplicitWidth = 858
        object NxTextColumn2: TNxTextColumn
          DefaultWidth = 548
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Mensagem'
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 0
          SortType = stAlphabetic
          Width = 548
        end
        object NxTextColumn3: TNxTextColumn
          DefaultWidth = 178
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'C'#243'digo'
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 1
          SortType = stAlphabetic
          Width = 178
        end
        object NxTextColumn1: TNxTextColumn
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          Header.Caption = 'Tipo'
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'Tahoma'
          Header.Font.Style = []
          ParentFont = False
          Position = 2
          SortType = stAlphabetic
        end
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
end
