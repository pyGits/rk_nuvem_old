object frmPopUpNotificacao: TfrmPopUpNotificacao
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmPopUpNotificacao'
  ClientHeight = 169
  ClientWidth = 469
  Color = clActiveCaption
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  object lblMensagem: TLabel
    Left = 168
    Top = 72
    Width = 94
    Height = 21
    Caption = 'lblMensagem'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object TimerFechar: TTimer
    OnTimer = TimerFecharTimer
    Left = 40
    Top = 32
  end
end
