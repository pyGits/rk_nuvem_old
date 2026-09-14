object frmCadastroCaixas: TfrmCadastroCaixas
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Caixas'
  ClientHeight = 361
  ClientWidth = 514
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
  object lblAjuda: TLabel
    Left = 8
    Top = 8
    Width = 498
    Height = 26
    AutoSize = False
    Caption =
      'Caixas que recebem a carga. O caixa 1 '#233' o PDV desta m'#225'quina: ele' +
      ' sempre existe e o IP dele n'#227'o muda.'
    WordWrap = True
  end
  object gridCaixas: TStringGrid
    Left = 8
    Top = 40
    Width = 498
    Height = 273
    ColCount = 3
    DefaultRowHeight = 22
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs]
    TabOrder = 0
    OnSelectCell = gridCaixasSelectCell
  end
  object btnAdicionar: TButton
    Left = 8
    Top = 324
    Width = 97
    Height = 25
    Caption = 'Adicionar'
    TabOrder = 1
    OnClick = btnAdicionarClick
  end
  object btnRemover: TButton
    Left = 111
    Top = 324
    Width = 97
    Height = 25
    Caption = 'Remover'
    TabOrder = 2
    OnClick = btnRemoverClick
  end
  object btnSalvar: TButton
    Left = 306
    Top = 324
    Width = 97
    Height = 25
    Caption = 'Salvar'
    TabOrder = 3
    OnClick = btnSalvarClick
  end
  object btnFechar: TButton
    Left = 409
    Top = 324
    Width = 97
    Height = 25
    Caption = 'Fechar'
    TabOrder = 4
    OnClick = btnFecharClick
  end
end
