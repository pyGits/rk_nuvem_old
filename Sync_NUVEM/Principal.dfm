object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Sincronizar RK Nuvem'
  ClientHeight = 509
  ClientWidth = 629
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlReenvio: TPanel
    Left = 0
    Top = 0
    Width = 629
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblReenvioDe: TLabel
      Left = 8
      Top = 9
      Width = 79
      Height = 13
      Caption = 'Reenviar de:'
    end
    object lblReenvioAte: TLabel
      Left = 194
      Top = 9
      Width = 20
      Height = 13
      Caption = 'at'#233':'
    end
    object dtpReenvioInicio: TDateTimePicker
      Left = 93
      Top = 5
      Width = 95
      Height = 21
      Date = 0.000000000000000000
      Format = 'dd/MM/yyyy'
      Time = 0.000000000000000000
      TabOrder = 0
    end
    object dtpReenvioFim: TDateTimePicker
      Left = 220
      Top = 5
      Width = 95
      Height = 21
      Date = 0.000000000000000000
      Format = 'dd/MM/yyyy'
      Time = 0.000000000000000000
      TabOrder = 1
    end
    object btnReenviar: TButton
      Left = 327
      Top = 4
      Width = 145
      Height = 23
      Caption = 'Reenviar per'#237'odo'
      TabOrder = 2
      OnClick = btnReenviarClick
    end
  end
  object memLog: TMemo
    Left = 0
    Top = 33
    Width = 629
    Height = 455
    Align = alClient
    TabOrder = 1
  end
  object edtToken: TEdit
    Left = 0
    Top = 488
    Width = 629
    Height = 21
    Align = alBottom
    TabOrder = 2
  end
  object tmInicializa: TTimer
    Enabled = False
    OnTimer = tmInicializaTimer
    Left = 240
    Top = 224
  end
  object tmCarga: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = tmCargaTimer
    Left = 336
    Top = 200
  end
  object tmSubidaVenda: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = tmSubidaVendaTimer
    Left = 312
    Top = 264
  end
  object TrayIcon1: TTrayIcon
    PopupMenu = PopupMenu1
    OnDblClick = TrayIcon1DblClick
    Left = 400
    Top = 256
  end
  object PopupMenu1: TPopupMenu
    Left = 192
    Top = 280
    object S1: TMenuItem
      Caption = 'Sair'
      OnClick = S1Click
    end
  end
end
