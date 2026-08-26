object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Configura'#231#227'o'
  ClientHeight = 602
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    635
    602)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 1
    Top = 4
    Width = 638
    Height = 537
    ActivePage = TabSheet4
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Impressora - Fiscal'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label44: TLabel
        Left = 8
        Top = 73
        Width = 99
        Height = 13
        Caption = 'Marca da impressora'
      end
      object lbl1: TLabel
        Left = 8
        Top = 32
        Width = 214
        Height = 13
        Caption = 'Porta de Comunica'#231#227'o ou compartilhamento:'
      end
      object lbl2: TLabel
        Left = 235
        Top = 32
        Width = 77
        Height = 13
        Caption = 'Pular linhas final'
      end
      object Label19: TLabel
        Left = 235
        Top = 73
        Width = 67
        Height = 13
        Caption = 'N'#250'mero Caixa'
      end
      object Panel5: TPanel
        Left = 0
        Top = 181
        Width = 620
        Height = 23
        BevelOuter = bvNone
        Caption = 'Fiscal'
        Color = clTeal
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object pgConfigFiscal: TPageControl
        Left = 0
        Top = 210
        Width = 621
        Height = 299
        ActivePage = tsNFCe
        TabOrder = 1
        object tsSAT: TTabSheet
          Caption = 'SAT'
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object sPageControl1: TsPageControl
            Left = 0
            Top = 3
            Width = 617
            Height = 280
            ActivePage = sTabSheet4
            TabOrder = 0
            SkinData.SkinSection = 'PAGECONTROL'
            object sTabSheet4: TsTabSheet
              Caption = 'Dados do S@T CFe'
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object Label4: TLabel
                Left = 222
                Top = 7
                Width = 54
                Height = 13
                Alignment = taRightJustify
                Caption = 'Nome DLL:'
                Color = 14803425
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentColor = False
                ParentFont = False
              end
              object SpeedButton1: TSpeedButton
                Left = 517
                Top = 25
                Width = 24
                Height = 22
                Caption = '...'
                OnClick = SpeedButton1Click
              end
              object Label5: TLabel
                Left = 16
                Top = 56
                Width = 93
                Height = 13
                Caption = 'C'#243'digo de Ativa'#231#227'o'
                Color = 14803425
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentColor = False
                ParentFont = False
              end
              object Label7: TLabel
                Left = 220
                Top = 56
                Width = 36
                Height = 13
                Caption = 'C'#243'd.UF'
                Color = 14803425
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentColor = False
                ParentFont = False
              end
              object Label8: TLabel
                Left = 17
                Top = 106
                Width = 33
                Height = 13
                Caption = 'Vers'#227'o'
                Color = 14803425
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentColor = False
                ParentFont = False
              end
              object Label9: TLabel
                Left = 220
                Top = 106
                Width = 71
                Height = 13
                Caption = 'Chamada DLL:'
                Color = 14803425
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentColor = False
                ParentFont = False
              end
              object Label11: TLabel
                Left = 19
                Top = 7
                Width = 69
                Height = 13
                Alignment = taRightJustify
                Caption = 'Modelo do Sat'
                Color = 14803425
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentColor = False
                ParentFont = False
              end
              object cbSATModelo: TComboBox
                Left = 17
                Top = 26
                Width = 134
                Height = 21
                Style = csDropDownList
                TabOrder = 0
                OnChange = cbSATModeloChange
                Items.Strings = (
                  'Elgin Linker I'
                  'Elgin Linker II'
                  'Dimep'
                  'Control ID'
                  'Gertec'
                  'Nitere'
                  'Tanca'
                  'Daruma'
                  'Bematech'
                  'Sweda')
              end
              object edtSATCaminhoDLL: TRzEdit
                Left = 222
                Top = 27
                Width = 283
                Height = 19
                Text = ''
                Color = 15916445
                Ctl3D = False
                ParentCtl3D = False
                TabOrder = 1
              end
              object edtSATUF: TRzEdit
                Left = 220
                Top = 77
                Width = 84
                Height = 19
                Text = '35'
                Color = 15916445
                Ctl3D = False
                ParentCtl3D = False
                TabOrder = 2
              end
              object edtSATCodigo: TRzEdit
                Left = 16
                Top = 77
                Width = 176
                Height = 19
                Text = ''
                Color = 15916445
                Ctl3D = False
                ParentCtl3D = False
                TabOrder = 3
              end
              object edtSATVersao: TRzEdit
                Left = 16
                Top = 125
                Width = 72
                Height = 19
                Text = ''
                Color = 15916445
                Ctl3D = False
                ParentCtl3D = False
                TabOrder = 4
              end
              object cbChamadaDLL: TComboBox
                Left = 220
                Top = 125
                Width = 134
                Height = 21
                Style = csDropDownList
                TabOrder = 5
                OnChange = cbSSLLibChange
              end
              object chkSATValida: TCheckBox
                Left = 16
                Top = 178
                Width = 161
                Height = 19
                Caption = 'Validar sat na inicaliza'#231#227'o'
                TabOrder = 6
              end
            end
            object sTabSheet6: TsTabSheet
              Caption = 'Dados do Emitente'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              object Label15: TLabel
                Left = 12
                Top = 23
                Width = 27
                Height = 13
                Caption = 'CNPJ'
                Color = clBtnFace
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentColor = False
                ParentFont = False
                Transparent = True
              end
              object Label16: TLabel
                Left = 186
                Top = 23
                Width = 64
                Height = 13
                Caption = 'Insc.Estadual'
                Color = clBtnFace
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentColor = False
                ParentFont = False
                Transparent = True
              end
              object Label17: TLabel
                Left = 327
                Top = 23
                Width = 68
                Height = 13
                Caption = 'Insc.Municipal'
                Color = clBtnFace
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentColor = False
                ParentFont = False
                Transparent = True
              end
              object edtEmitenteCNPJ: TEdit
                Left = 12
                Top = 38
                Width = 166
                Height = 21
                Cursor = crIBeam
                Color = 9167337
                TabOrder = 0
              end
              object edtEmitenteIE: TEdit
                Left = 186
                Top = 38
                Width = 134
                Height = 21
                Cursor = crIBeam
                Color = 9167337
                TabOrder = 1
              end
              object edtEmitenteIM: TEdit
                Left = 327
                Top = 38
                Width = 134
                Height = 21
                Cursor = crIBeam
                Color = 9167337
                TabOrder = 2
              end
            end
            object sTabSheet7: TsTabSheet
              Caption = 'Dados Sw. House'
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              DesignSize = (
                609
                252)
              object Label22: TLabel
                Left = 14
                Top = 15
                Width = 137
                Height = 13
                Caption = 'CNPJ: (13.998.916/0001-24)'
                Color = clBtnFace
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentColor = False
                ParentFont = False
                Transparent = True
              end
              object Label23: TLabel
                Left = 10
                Top = 71
                Width = 181
                Height = 13
                Caption = 'Assinatura Sw.House (344 caracteres)'
                Color = clBtnFace
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentColor = False
                ParentFont = False
                Transparent = True
              end
              object edtSWHouseCNPJ: TEdit
                Left = 10
                Top = 31
                Width = 195
                Height = 21
                Anchors = [akLeft, akTop, akRight]
                Color = 9167337
                TabOrder = 0
              end
              object edtSWHouseAC: TEdit
                Left = 10
                Top = 89
                Width = 594
                Height = 21
                Color = 9167337
                TabOrder = 1
              end
            end
          end
        end
        object tsNFCe: TTabSheet
          Caption = 'NFCe'
          ImageIndex = 1
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object lSSLLib: TLabel
            Left = 39
            Top = 16
            Width = 30
            Height = 13
            Alignment = taRightJustify
            Caption = 'SSLLib'
            Color = clBtnFace
            ParentColor = False
          end
          object lCryptLib: TLabel
            Left = 29
            Top = 43
            Width = 40
            Height = 13
            Alignment = taRightJustify
            Caption = 'CryptLib'
            Color = clBtnFace
            ParentColor = False
          end
          object lHttpLib: TLabel
            Left = 35
            Top = 70
            Width = 34
            Height = 13
            Alignment = taRightJustify
            Caption = 'HttpLib'
            Color = clBtnFace
            ParentColor = False
          end
          object lXmlSign: TLabel
            Left = 17
            Top = 97
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = 'XMLSignLib'
            Color = clBtnFace
            ParentColor = False
          end
          object Label59: TLabel
            Left = 306
            Top = 3
            Width = 73
            Height = 13
            Caption = 'IdToken/IdCSC'
          end
          object Label60: TLabel
            Left = 306
            Top = 41
            Width = 53
            Height = 13
            Caption = 'Token/CSC'
          end
          object lSSLLib1: TLabel
            Left = 310
            Top = 112
            Width = 41
            Height = 13
            Alignment = taRightJustify
            Caption = 'SSLType'
            Color = clBtnFace
            ParentColor = False
          end
          object Label14: TLabel
            Left = 310
            Top = 177
            Width = 66
            Height = 13
            Alignment = taRightJustify
            Caption = 'N'#250'mero NFCe'
            Color = clBtnFace
            ParentColor = False
          end
          object Label20: TLabel
            Left = 475
            Top = 176
            Width = 24
            Height = 13
            Alignment = taRightJustify
            Caption = 'S'#233'rie'
            Color = clBtnFace
            ParentColor = False
          end
          object cbSSLLib: TComboBox
            Left = 80
            Top = 8
            Width = 160
            Height = 21
            Style = csDropDownList
            TabOrder = 0
            OnChange = cbSSLLibChange
          end
          object cbCryptLib: TComboBox
            Left = 80
            Top = 35
            Width = 160
            Height = 21
            Style = csDropDownList
            TabOrder = 1
            OnChange = cbCryptLibChange
          end
          object cbHttpLib: TComboBox
            Left = 80
            Top = 62
            Width = 160
            Height = 21
            Style = csDropDownList
            TabOrder = 2
            OnChange = cbHttpLibChange
          end
          object cbXmlSignLib: TComboBox
            Left = 80
            Top = 89
            Width = 160
            Height = 21
            Style = csDropDownList
            TabOrder = 3
            OnChange = cbXmlSignLibChange
          end
          object gbCertificado: TGroupBox
            Left = 14
            Top = 116
            Width = 263
            Height = 144
            Caption = 'Certificado'
            TabOrder = 4
            object Label18: TLabel
              Left = 8
              Top = 16
              Width = 41
              Height = 13
              Caption = 'Caminho'
            end
            object Label57: TLabel
              Left = 8
              Top = 56
              Width = 30
              Height = 13
              Caption = 'Senha'
            end
            object sbtnCaminhoCert: TSpeedButton
              Left = 235
              Top = 32
              Width = 23
              Height = 24
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000130B0000130B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
                333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
                0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
                07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
                07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
                0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
                33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
                B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
                3BB33773333773333773B333333B3333333B7333333733333337}
              NumGlyphs = 2
              OnClick = sbtnCaminhoCertClick
            end
            object Label58: TLabel
              Left = 8
              Top = 96
              Width = 79
              Height = 13
              Caption = 'N'#250'mero de S'#233'rie'
            end
            object sbtnGetCert: TSpeedButton
              Left = 235
              Top = 99
              Width = 23
              Height = 24
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000130B0000130B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
                333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
                0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
                07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
                07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
                0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
                33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
                B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
                3BB33773333773333773B333333B3333333B7333333733333337}
              NumGlyphs = 2
              Visible = False
            end
            object btnSerie: TSpeedButton
              Left = 206
              Top = 110
              Width = 23
              Height = 24
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000130B0000130B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
                333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
                0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
                07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
                07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
                0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
                33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
                B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
                3BB33773333773333773B333333B3333333B7333333733333337}
              NumGlyphs = 2
              OnClick = btnSerieClick
            end
            object edtCaminho: TEdit
              Left = 8
              Top = 32
              Width = 225
              Height = 21
              TabOrder = 0
            end
            object edtSenha: TEdit
              Left = 8
              Top = 72
              Width = 249
              Height = 21
              PasswordChar = '*'
              TabOrder = 1
            end
            object edtNumSerie: TEdit
              Left = 8
              Top = 112
              Width = 193
              Height = 21
              TabOrder = 2
            end
          end
          object edtIdToken: TEdit
            Left = 306
            Top = 19
            Width = 248
            Height = 21
            TabOrder = 5
          end
          object edtToken: TEdit
            Left = 306
            Top = 60
            Width = 248
            Height = 21
            TabOrder = 6
          end
          object cbSSLType: TComboBox
            Left = 363
            Top = 104
            Width = 160
            Height = 21
            Hint = 'Depende de configura'#231#227'o de  SSL.HttpLib'
            Style = csDropDownList
            TabOrder = 7
          end
          object edtSerie: TSpinEdit
            Left = 475
            Top = 195
            Width = 64
            Height = 22
            MaxValue = 9999
            MinValue = 0
            TabOrder = 8
            Value = 1
          end
          object edtNNFce: TEdit
            Left = 310
            Top = 196
            Width = 142
            Height = 21
            TabOrder = 9
          end
        end
        object TabSheet3: TTabSheet
          Caption = 'Impress'#227'o'
          ImageIndex = 2
          ExplicitLeft = 0
          ExplicitTop = 0
          ExplicitWidth = 0
          ExplicitHeight = 0
          object GroupBox1: TGroupBox
            Left = -4
            Top = 24
            Width = 284
            Height = 225
            Caption = 'Fortes'
            TabOrder = 0
            object Label24: TLabel
              Left = 8
              Top = 16
              Width = 37
              Height = 13
              Caption = 'Largura'
              Color = clBtnFace
              ParentColor = False
              Transparent = True
            end
            object Label25: TLabel
              Left = 96
              Top = 16
              Width = 24
              Height = 13
              Caption = 'Topo'
              Color = clBtnFace
              ParentColor = False
              Transparent = True
            end
            object Label27: TLabel
              Left = 8
              Top = 64
              Width = 30
              Height = 13
              Caption = 'Fundo'
              Color = clBtnFace
              ParentColor = False
              Transparent = True
            end
            object Label28: TLabel
              Left = 96
              Top = 64
              Width = 45
              Height = 13
              Caption = 'Esquerda'
              Color = clBtnFace
              ParentColor = False
              Transparent = True
            end
            object Label29: TLabel
              Left = 184
              Top = 64
              Width = 31
              Height = 13
              Caption = 'Direita'
              Color = clBtnFace
              ParentColor = False
              Transparent = True
            end
            object lblFortesNome: TLabel
              Left = 138
              Top = 120
              Width = 97
              Height = 13
              Caption = 'Impresssora Default'
              Color = clBtnFace
              ParentColor = False
              Transparent = True
            end
            object edtFortesLarg: TSpinEdit
              Left = 8
              Top = 30
              Width = 64
              Height = 22
              MaxValue = 9999
              MinValue = 0
              TabOrder = 0
              Value = 0
            end
            object edtFortesTopo: TSpinEdit
              Left = 96
              Top = 30
              Width = 64
              Height = 22
              MaxValue = 9999
              MinValue = 0
              TabOrder = 1
              Value = 0
            end
            object edtFortesFundo: TSpinEdit
              Left = 8
              Top = 78
              Width = 64
              Height = 22
              MaxValue = 9999
              MinValue = 0
              TabOrder = 2
              Value = 0
            end
            object edtFortesEsq: TSpinEdit
              Left = 96
              Top = 78
              Width = 64
              Height = 22
              MaxValue = 9999
              MinValue = 0
              TabOrder = 3
              Value = 0
            end
            object edtFortesDir: TSpinEdit
              Left = 184
              Top = 78
              Width = 64
              Height = 22
              MaxValue = 9999
              MinValue = 0
              TabOrder = 4
              Value = 0
            end
            object Button2: TButton
              Left = 303
              Top = 139
              Width = 122
              Height = 25
              Caption = 'Definir Impressora'
              TabOrder = 5
            end
            object cbUsarFortes: TRadioButton
              Left = 184
              Top = 16
              Width = 78
              Height = 19
              Caption = 'Usar Fortes'
              TabOrder = 6
              OnClick = cbUsarFortesClick
            end
            object chkPreview: TCheckBox
              Left = 184
              Top = 41
              Width = 61
              Height = 19
              Caption = 'Preview'
              TabOrder = 7
            end
            object AdvGlowButton1: TAdvGlowButton
              Left = 301
              Top = 130
              Width = 121
              Height = 33
              Caption = 'Definir Impressora'
              NotesFont.Charset = DEFAULT_CHARSET
              NotesFont.Color = clWindowText
              NotesFont.Height = -11
              NotesFont.Name = 'Tahoma'
              NotesFont.Style = []
              TabOrder = 8
              Visible = False
              Appearance.ColorChecked = 16111818
              Appearance.ColorCheckedTo = 16367008
              Appearance.ColorDisabled = 15921906
              Appearance.ColorDisabledTo = 15921906
              Appearance.ColorDown = 16111818
              Appearance.ColorDownTo = 16367008
              Appearance.ColorHot = 16117985
              Appearance.ColorHotTo = 16372402
              Appearance.ColorMirrorHot = 16107693
              Appearance.ColorMirrorHotTo = 16775412
              Appearance.ColorMirrorDown = 16102556
              Appearance.ColorMirrorDownTo = 16768988
              Appearance.ColorMirrorChecked = 16102556
              Appearance.ColorMirrorCheckedTo = 16768988
              Appearance.ColorMirrorDisabled = 11974326
              Appearance.ColorMirrorDisabledTo = 15921906
            end
            object btnDefinirImpr: TsBitBtn
              Left = 4
              Top = 112
              Width = 129
              Height = 30
              Caption = 'Definir Impressora'
              TabOrder = 9
              OnClick = btnDefinirImprClick
            end
          end
          object GroupBox2: TGroupBox
            Left = 283
            Top = 24
            Width = 327
            Height = 225
            Caption = 'EscPOS'
            TabOrder = 1
            DesignSize = (
              327
              225)
            object Label31: TLabel
              Left = 8
              Top = 39
              Width = 34
              Height = 13
              Caption = 'Modelo'
              Color = clBtnFace
              ParentColor = False
              Transparent = True
            end
            object Label32: TLabel
              Left = 160
              Top = 39
              Width = 26
              Height = 13
              Caption = 'Porta'
              Color = clBtnFace
              ParentColor = False
              Transparent = True
            end
            object Label33: TLabel
              Left = 211
              Top = 102
              Width = 55
              Height = 13
              Caption = 'Pag.Codigo'
              Color = clBtnFace
              ParentColor = False
              Transparent = True
            end
            object Label34: TLabel
              Left = 8
              Top = 108
              Width = 38
              Height = 13
              Caption = 'Colunas'
              Color = clBtnFace
              ParentColor = False
              Transparent = True
            end
            object Label35: TLabel
              Left = 80
              Top = 95
              Width = 39
              Height = 26
              Caption = 'Espa'#231'os'#13#10'Linhas'
              Color = clBtnFace
              ParentColor = False
              Transparent = True
            end
            object Label36: TLabel
              Left = 144
              Top = 95
              Width = 30
              Height = 26
              Caption = 'Linhas'#13#10'Pular'
              Color = clBtnFace
              ParentColor = False
              Transparent = True
            end
            object BitBtn1: TBitBtn
              Left = 297
              Top = 53
              Width = 22
              Height = 22
              Anchors = [akTop, akRight]
              Glyph.Data = {
                36030000424D3603000000000000360000002800000010000000100000000100
                1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF323232
                3232323E3E3E565656FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3E3E3EFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFF565656FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3E3E3EFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFF503200FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                565656565656FFFFFFFFFFFF3232322626262626262626262626265032005032
                000000504873FFFFFFFFFFFFFFFFFFFF6E6E6EFFFFFFFFFFFFFFFFFFFFFFFF6E
                6E6E32323232323232323232323250320000005025AAFFFFFFFFFFFFFF565656
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5656563232323232326E6E6E5032005032
                008FFF6B8ED4FFFFFFFFFFFFFFFFFFFF3E3E3EFFFFFFFFFFFF50320050320056
                56564A4A4A5050003232325032005032008FFF6B8ED4FFFFFFFFFFFFFFFFFFFF
                FFFFFF5656563E3E3E2626265032006262625656565050003232325032005032
                008FFF6B8ED4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5050005050006E
                6E6E5656565050003250005032005032008FFF6B8ED4FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8686865656565656563250005032005032
                008FFF6B48B8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3232323E
                3E3EA4A0A08686866E6E6E565656503200C0C0C02557FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFF5050004A4A4A3232323232323232323232325032
                00FFFFFF6B8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
              Layout = blGlyphTop
              ModalResult = 1
              TabOrder = 0
            end
            object rdUsarEscPos: TRadioButton
              Left = 3
              Top = 14
              Width = 85
              Height = 19
              Caption = 'Usar EscPOS'
              TabOrder = 1
              OnClick = rdUsarEscPosClick
            end
            object cbEscPosModelo: TComboBox
              Left = 7
              Top = 55
              Width = 146
              Height = 21
              Style = csDropDownList
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 2
            end
            object cbEscPosPorta: TComboBox
              Left = 159
              Top = 55
              Width = 138
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 3
            end
            object cbEscPosPagCod: TComboBox
              Left = 214
              Top = 121
              Width = 100
              Height = 21
              Style = csDropDownList
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 4
            end
            object edtEscPosCol: TSpinEdit
              Left = 8
              Top = 124
              Width = 49
              Height = 22
              MaxValue = 9999
              MinValue = 0
              TabOrder = 5
              Value = 0
            end
            object edtEscPosEspacLin: TSpinEdit
              Left = 80
              Top = 124
              Width = 49
              Height = 22
              MaxValue = 9999
              MinValue = 0
              TabOrder = 6
              Value = 0
            end
            object edtEscPosLinPular: TSpinEdit
              Left = 144
              Top = 124
              Width = 49
              Height = 22
              MaxValue = 9999
              MinValue = 0
              TabOrder = 7
              Value = 0
            end
            object chkEscPos1Linha: TCheckBox
              Left = 160
              Top = 16
              Width = 145
              Height = 19
              Caption = 'Imprimir Item em 1 Linha'
              TabOrder = 8
            end
          end
        end
      end
      object ComboGuilhotina: TComboBox
        Left = 8
        Top = 92
        Width = 213
        Height = 21
        Style = csDropDownList
        Color = 15916445
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 2
        Items.Strings = (
          'PADR'#195'O'
          'BEMATECH MP 4200 TH'
          'BEMATECH MP 2500 TH'
          'DARUMA'
          'SWEDA')
      end
      object ComboImpressora: TComboBox
        Left = 8
        Top = 51
        Width = 213
        Height = 21
        Color = 15916445
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 3
        Items.Strings = (
          'COM1')
      end
      object EditQtdLinhas: TSpinEdit
        Left = 235
        Top = 49
        Width = 97
        Height = 19
        Color = 15916445
        Ctl3D = False
        MaxValue = 0
        MinValue = 0
        ParentCtl3D = False
        TabOrder = 4
        Value = 5
      end
      object CheckHabGuilhotina: TCheckBox
        Left = 349
        Top = 36
        Width = 109
        Height = 17
        Caption = 'Habilita Guilhotina '
        TabOrder = 5
      end
      object CheckReimpressao: TCheckBox
        Left = 349
        Top = 59
        Width = 124
        Height = 17
        Caption = 'Pergunta qtd vias'
        TabOrder = 6
      end
      object btn1: TAdvGlowButton
        Left = 479
        Top = 49
        Width = 114
        Height = 49
        Caption = 'Testar Impressora'
        NotesFont.Charset = DEFAULT_CHARSET
        NotesFont.Color = clWindowText
        NotesFont.Height = -11
        NotesFont.Name = 'Tahoma'
        NotesFont.Style = []
        Picture.Data = {
          89504E470D0A1A0A0000000D49484452000000280000002808060000008CFEB8
          6D000000097048597300000EC300000EC301C76FA864000000206348524D0000
          7A25000080830000F9FF000080E8000052080001155800003A970000176FD75A
          1F900000080A4944415478DABC995D6C5BE519805F0931894948136C12D2346D
          6C5743D38634600212D74E4B932671827DCEF14F12276E9A94262194B6406929
          B0C2184CEC629A9040303169EA10378801EB4F92529AB4244DE2738E93B64949
          491B5A5ADAD0A6A98F9DC471EC67174ED3E617A709B3F45CD8B23F3D7E7FBEEF
          F36B8117653A2F09133B2465A8C2F112A1372018AA70A24230BDC2515FFAB9A1
          FE3A6568B518DABB98DAA7E8EA19743582AE4608A9E7097B5B30B55D18DA5398
          DABD18AAA44C55D0BDC2F18070CC2F74F984633E49E96E6164ABC09F64A68F64
          2468AA42DF5AC1F4DD4158DB86A1F5A2AB4C115298F65C57A1D33DFD7543EDC7
          505F41F7FE829EF2F4DA4B16EC29154E940BBA7A2B47FDAFA16BC373CA2C8690
          9A20EC7B8B6EDF9D74FB9720684E45D049BBEB4B3ADD4B139B19DD4E65882E5F
          90637E49190B0AEE9CC12B022F4AAADB2B74BA774E7EEBE5939B1E4DD0D53752
          862A8C3F27F0EA2C1F21F9FC0CFE28C4B70BA66717475C2C39A5DF45871B42EE
          26A2CF08C99766F908FD8149CA84810AA1BF5CD0B57F7F6F519B3F9ACD9C0C08
          5F05D32E935E426CCB244F0B234F095DDA4E5A8BFEBF72BA0AADC5A02BEF11D9
          24C4B64E790903EBD39CAD13BE7ACC4E485920AD1E08B9A023777EDA73A1230F
          7405746D111154D2CD73AA2AC8D9BA292FA1BF5238552DF4046EE1B0F35B420A
          18F32DA480EE216506E6271C00B304F44740772F4E5257E0B0138E97DDC9E96A
          A1BF52848BF5C2E026A1AFFC358E142FBC409B8D64CF56A2A323C4623162D1E1
          598C8DC5181CB2B8ACBF009DF72D5EF248319C08BCCFC54DC2C57A11C23EC1F4
          DE46A792983F72D7041F26D9BB83C80458E360C567134FC2450B9ACD2B5C0A3D
          07FAEF17976E4385763718DA3D74F964F2C8F16CCB683B69CB26D9B30D2B0ED1
          D114D191F82CE2E349AE0C47F8DC3C47B339C490F102E88B8C644881B0F626C7
          4B4430BC82AE9DCDE883190A0E0D47E9348F71C838C7A1AE61868CE7417F0074
          D722D2AD5DC5F4DD2A84D55F665C1F19088E27525CBE62D172A48B96D61007DA
          07686A1FE47CEBB310B283E9C9BC1E4DB548528667E3720A8E8E25B86A8D72FA
          EC054E9FF986AFCE9EE7E4D731FACEC7891F7D1A3A1D990B1ADA3B82E9DD95F1
          719681A0151B23363ACE44122652309184640AE28065BECAC4FEDF40B73FB33A
          343C0785B0B779C19B4A4885B0024715D0B3A0EF59220B08CEC96882680AC6CC
          1D243EFE19E84E38EEFB6E4153EB1374F5EBF90F7215BE70C34937982A84D282
          D64D0AC6BB5E24F1F1CF1969C886EE02E857A173C1A6B924E8EAC8BC6F38E1E6
          CC012F1B37AF23B8A11AC5E7E4F5BFFD859B7DFCE39F6F51E45A4D455590CAEA
          72FAF678D292F30B46E71734551870B1637B25B7DF57CFFDCE1A7EFA8087B28D
          AF12B5225C1E1AE6C2C54B1931F8ED1031CB62F3CB6F72D7FD1EFE50FC387765
          3F4949702D09D3093DDE050443CA37739E20663ABD5B9F59C76FF36AC92F798C
          FCD21A0A7CD5389500858BC4E92EA3C057457E690DF9258F91ADD452545AC5E5
          8F1C102E9CBB7142EA90D0EDFB9C0EF7DC827D6E9EDF5E392558585643AEB78A
          ACC212B29D25643B4B33A484ACC212567BD6515896167CD85D8BB7B28AA1DD76
          3890C544FBA3D325430A989E7E21EC7D7FCE2E9E43708AD20D37C70D6B5C13BC
          B237070E6411D96B4B4B76F96E143C2CE8DAD6796B7096E07AF24B375010A89B
          A47611D4A525FDEB670B36DBB0F6ADC09A29A96BFF124CED9E4C050B4A6B58E3
          AB26D75546AEBB8C5C77206356BB4A59E3ADA260468AAF09461B1D5392C96B92
          A6E69794A109BA7A2923C1401D6BB44A725639C979C449CE234519E3C8C92757
          A9A0A0BC6E5EC129C97D3626DA1F1DA7DBFFC3F40822ACBD3EEBB89BECE26D5B
          2BF9DD5417A75394A706C9D382E4696B33470DB2C6573D558BD94A2DAE8A6A2E
          ED5E092DD705A34D395CDD6B23BACFFEDEF8C1DCC9EB5648FB311DEEE9577D53
          85532EB66C59C74F1E7C82156A2DD9EE1AB2953A6C5AFD4DF004D94A1DD9EE1A
          6C4A2DBF5AB591E2C07A463EB5933CB8629A60748F8D7863D603E34D59227CFD
          B870EE49A137F00EED33AEFC5FBA39F2819F02FF3A0AFDD52815CB4351D97A56
          FB36B0E7AD6268CBBA2ED7E820F2DF2C465AF31B3915144E9589706E8370AE4E
          38B9F6765A8BE3D3521D52E1A40A9D459CFBD0C1E0270EBEDDBD72C95CF86415
          B146077C9E9DAEBB6BF5D760C7FACF434C74F9EE4E0ED448B27F9D083D01A1A7
          2C3DBDEA2DF7A5A752D34613D0EB49EFF69F3D0C07B3A0C506CD4BA0C506076D
          C41A1D580DD7A37775B78DF8E1FC6D7428425BA1D0EA1421B2298DB545B0360B
          61CFDB73FEBAEBF23171A4186B6F7ACFBA312DCB41E4938718D9BFF233869E10
          86370B57EA852BF5229C2ABFCE99A0D0572AB4BBF6CFB9374E4A46BE07C9C847
          0FF6264CD72D5C582F9CAE100682C2405084F8B6EB8C6F17C67708D16704533B
          40BB6BB664B79FC4324A5A7B6C587B571C9F18ACFF516AEC0521B17D9A93C0CB
          37F092C09F0576A6C76F1DAE5D730E91BAFDCB12496B9F9D58837DAFD594F383
          546287C05F271DAE3B2D30C0D4D29B784F5915EDEEF159178A25A4DB6A481F69
          2307563F3B7A385FAC268724ADA72683B3D811F017154248BD9B6EDFBBB3E6D1
          37D3380D76629FAEFA70F450DEBDF1963C193D9C2F56A3FD2605A786E89AD017
          144CEFFD98DADF31B40BD324DB8A3289E4D568A3FD9DB1861C47FC50A18CB53B
          65EC60AE8C1E5AB30C82B3FE86D06EC3509D18DA1B18EA7EBAFDBD89B6A241AB
          C11E8936D823D146C7A558A3A32FDAE8688E3639DE8E36397CD126C71DD12687
          8C35AC94784B818CB6156424F8BF01009FA2A1EEC0ABEA0E0000000049454E44
          AE426082}
        Transparent = True
        TabOrder = 7
        OnClick = btn1Click
        Appearance.BorderColor = 12631218
        Appearance.BorderColorHot = 10079963
        Appearance.BorderColorDown = 4548219
        Appearance.Color = 14671574
        Appearance.ColorTo = 15000283
        Appearance.ColorChecked = 7915518
        Appearance.ColorCheckedTo = 11918331
        Appearance.ColorDisabled = 15921906
        Appearance.ColorDisabledTo = 15921906
        Appearance.ColorDown = 7778289
        Appearance.ColorDownTo = 4296947
        Appearance.ColorHot = 15465983
        Appearance.ColorHotTo = 11332863
        Appearance.ColorMirror = 14144974
        Appearance.ColorMirrorTo = 15197664
        Appearance.ColorMirrorHot = 5888767
        Appearance.ColorMirrorHotTo = 10807807
        Appearance.ColorMirrorDown = 946929
        Appearance.ColorMirrorDownTo = 5021693
        Appearance.ColorMirrorChecked = 10480637
        Appearance.ColorMirrorCheckedTo = 5682430
        Appearance.ColorMirrorDisabled = 11974326
        Appearance.ColorMirrorDisabledTo = 15921906
        Appearance.GradientHot = ggVertical
        Appearance.GradientMirrorHot = ggVertical
        Appearance.GradientDown = ggVertical
        Appearance.GradientMirrorDown = ggVertical
        Appearance.GradientChecked = ggVertical
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 620
        Height = 23
        BevelOuter = bvNone
        Caption = 'Impressora Gerencial'
        Color = clTeal
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 8
      end
      object rdLocalGaveta: TRadioGroup
        Left = 295
        Top = 139
        Width = 223
        Height = 36
        Caption = 'Gaveta'
        Columns = 2
        Items.Strings = (
          'Sem Gaveta'
          'Impressora')
        TabOrder = 9
      end
      object edtNumCaixa: TRzEdit
        Left = 235
        Top = 94
        Width = 97
        Height = 19
        Text = '001'
        Color = 15916445
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 10
      end
      object rdTipoPDV: TRadioGroup
        Left = 3
        Top = 139
        Width = 286
        Height = 36
        Caption = 'Tipo de PDV'
        Columns = 3
        Items.Strings = (
          'SAT'
          'NFCe'
          'Nenhum')
        TabOrder = 11
        OnClick = rdTipoPDVClick
      end
      object checkImpressao: TCheckBox
        Left = 349
        Top = 83
        Width = 124
        Height = 17
        Caption = 'Imprimir cupom'
        TabOrder = 12
      end
      object chkPerguntaImprimir: TCheckBox
        Left = 349
        Top = 106
        Width = 148
        Height = 17
        Caption = 'Pergunta imprimir cupom'
        TabOrder = 13
      end
      object chkGavInvertida: TCheckBox
        Left = 524
        Top = 152
        Width = 97
        Height = 17
        Caption = 'Gav. Invertida'
        TabOrder = 14
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Balan'#231'a - Banco de dados'
      ImageIndex = 1
      object Label1: TLabel
        Left = 19
        Top = 48
        Width = 34
        Height = 13
        Caption = 'Modelo'
      end
      object Label2: TLabel
        Left = 6
        Top = 76
        Width = 47
        Height = 13
        Caption = 'BaudRate'
      end
      object Label38: TLabel
        Left = 14
        Top = 104
        Width = 39
        Height = 13
        Caption = 'StopBits'
      end
      object Label3: TLabel
        Left = 157
        Top = 48
        Width = 26
        Height = 13
        Caption = 'Porta'
      end
      object Label37: TLabel
        Left = 122
        Top = 76
        Width = 61
        Height = 13
        Caption = 'Handshaking'
      end
      object Label40: TLabel
        Left = 155
        Top = 104
        Width = 28
        Height = 13
        Caption = 'Parity'
      end
      object Label39: TLabel
        Left = 278
        Top = 104
        Width = 44
        Height = 13
        Caption = 'Time-Out'
      end
      object Label6: TLabel
        Left = 280
        Top = 47
        Width = 40
        Height = 13
        Caption = 'DataBits'
      end
      object Label10: TLabel
        Left = 7
        Top = 360
        Width = 120
        Height = 13
        Caption = 'Banco de Dados Servidor'
      end
      object Label12: TLabel
        Left = 7
        Top = 304
        Width = 104
        Height = 13
        Caption = 'Banco de Dados Local'
      end
      object cb_bal_modelo: TComboBox
        Left = 57
        Top = 44
        Width = 60
        Height = 21
        Style = csDropDownList
        Color = 15916445
        Ctl3D = False
        ItemIndex = 0
        ParentCtl3D = False
        TabOrder = 0
        Text = 'Nenhuma'
        Items.Strings = (
          'Nenhuma'
          'Filizola'
          'Toledo')
      end
      object cb_bal_baudrate: TComboBox
        Left = 56
        Top = 73
        Width = 60
        Height = 21
        Style = csDropDownList
        Color = 15916445
        Ctl3D = False
        ItemIndex = 6
        ParentCtl3D = False
        TabOrder = 1
        Text = '9600'
        Items.Strings = (
          '110'
          '300'
          '600'
          '1200'
          '2400'
          '4800'
          '9600'
          '14400'
          '19200'
          '38400'
          '56000'
          '57600')
      end
      object cb_bal_stop: TComboBox
        Left = 57
        Top = 100
        Width = 60
        Height = 21
        Style = csDropDownList
        Color = 15916445
        Ctl3D = False
        ItemIndex = 0
        ParentCtl3D = False
        TabOrder = 2
        Text = 's1'
        Items.Strings = (
          's1'
          's1,5'
          's2')
      end
      object cb_bal_porta: TComboBox
        Left = 188
        Top = 44
        Width = 75
        Height = 21
        Style = csDropDownList
        Color = 15916445
        Ctl3D = False
        ItemIndex = 0
        ParentCtl3D = False
        TabOrder = 3
        Text = 'COM1'
        Items.Strings = (
          'COM1'
          'COM2'
          'COM3'
          'COM4'
          'COM5'
          'COM6'
          'COM7'
          'COM8'
          'COM9'
          'USB')
      end
      object cb_bal_hand: TComboBox
        Left = 188
        Top = 72
        Width = 75
        Height = 21
        Color = 15916445
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 4
        Text = 'Nenhum'
        Items.Strings = (
          'Nenhum'
          'XON/XOFF'
          'RTS/CTS'
          'DTR/DSR')
      end
      object cb_parity: TComboBox
        Left = 188
        Top = 100
        Width = 75
        Height = 21
        Style = csDropDownList
        Color = 15916445
        Ctl3D = False
        ItemIndex = 2
        ParentCtl3D = False
        TabOrder = 5
        Text = 'pNone'
        Items.Strings = (
          'pEven'
          'pMark'
          'pNone'
          'pOdd'
          'pSpace')
      end
      object cb_bal_time_out: TEdit
        Left = 326
        Top = 100
        Width = 60
        Height = 19
        Color = 15916445
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 6
        Text = '5000'
      end
      object cb_bal_databits: TComboBox
        Left = 326
        Top = 44
        Width = 60
        Height = 21
        Style = csDropDownList
        Color = 15916445
        Ctl3D = False
        ItemIndex = 3
        ParentCtl3D = False
        TabOrder = 7
        Text = '8'
        Items.Strings = (
          '5'
          '6'
          '7'
          '8')
      end
      object Panel20: TPanel
        Left = 399
        Top = 42
        Width = 203
        Height = 134
        BevelOuter = bvNone
        Color = 7456876
        ParentBackground = False
        TabOrder = 8
        object Label43: TLabel
          Left = 12
          Top = 34
          Width = 88
          Height = 13
          Caption = 'N'#186' Digitos Produto'
        end
        object Panel21: TPanel
          Left = 0
          Top = 0
          Width = 203
          Height = 18
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Balan'#231'a Retaguarda'
          Color = clGreen
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object EditQtdDigitos: TSpinEdit
          Left = 104
          Top = 30
          Width = 86
          Height = 22
          Color = 15916445
          Ctl3D = False
          MaxValue = 6
          MinValue = 2
          ParentCtl3D = False
          TabOrder = 1
          Value = 5
        end
        object chkLeituraAutomatica: TCheckBox
          Left = 12
          Top = 69
          Width = 157
          Height = 17
          Caption = 'Habilita leitura autom'#225'tica'
          TabOrder = 2
        end
        object chk2Etiqueta: TCheckBox
          Left = 12
          Top = 92
          Width = 157
          Height = 17
          Caption = 'Habilita digito 2 (etiqueta)'
          TabOrder = 3
        end
      end
      object Panel2: TPanel
        Left = -7
        Top = 0
        Width = 620
        Height = 23
        BevelOuter = bvNone
        Caption = 'Balan'#231'a'
        Color = clTeal
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 9
      end
      object Panel3: TPanel
        Left = -4
        Top = 264
        Width = 620
        Height = 23
        BevelOuter = bvNone
        Caption = 'Banco de dados'
        Color = clTeal
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 10
      end
      object ed_server: TRzEdit
        Left = 7
        Top = 381
        Width = 113
        Height = 19
        Text = 'LOCALHOST'
        Color = 15916445
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 11
      end
      object ed_base: TRzButtonEdit
        Left = 137
        Top = 381
        Width = 329
        Height = 19
        Text = 'C:\System_RK\Server\BD\BASE.FDB'
        Color = 15916445
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 12
        AltBtnWidth = 15
        ButtonWidth = 15
        OnButtonClick = ed_baseButtonClick
      end
      object ed_base_local: TRzButtonEdit
        Left = 5
        Top = 320
        Width = 461
        Height = 19
        Text = 'C:\System_RK\PDV\BD\SAT_DATPDV.FDB'
        Color = 15916445
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 13
        OnClick = ed_base_localClick
        AltBtnWidth = 15
        ButtonWidth = 15
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Par'#226'metros adicionais'
      ImageIndex = 2
      object Panel7: TPanel
        Left = 0
        Top = 135
        Width = 610
        Height = 378
        BevelOuter = bvNone
        Color = 14086904
        ParentBackground = False
        TabOrder = 0
        object Label13: TLabel
          Left = 21
          Top = 31
          Width = 77
          Height = 13
          Caption = 'Limite diversos :'
        end
        object Label21: TLabel
          Left = 21
          Top = 221
          Width = 129
          Height = 13
          Caption = 'Vias sangria e fundo caixa:'
        end
        object SpeedButton2: TSpeedButton
          Left = 316
          Top = 266
          Width = 24
          Height = 22
          Caption = '...'
          OnClick = SpeedButton2Click
        end
        object Label26: TLabel
          Left = 21
          Top = 249
          Width = 68
          Height = 13
          Caption = 'Caminho logo:'
        end
        object Label30: TLabel
          Left = 21
          Top = 58
          Width = 123
          Height = 13
          Caption = 'C'#243'digo Diversos (Tecla D)'
        end
        object Label61: TLabel
          Left = 267
          Top = 150
          Width = 145
          Height = 13
          Caption = 'Hora virada do dia (HH:MM):'
        end
        object Panel8: TPanel
          Left = 0
          Top = 0
          Width = 610
          Height = 18
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Par'#226'metros'
          Color = clTeal
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object edtLimiteDiversos: TRzNumericEdit
          Left = 104
          Top = 28
          Width = 113
          Height = 21
          TabOrder = 1
          IntegersOnly = False
          DisplayFormat = '###,###,##0.000'
        end
        object chkDescSub: TCheckBox
          Left = 19
          Top = 102
          Width = 252
          Height = 17
          Caption = 'Habilita desconto no subtotal'
          TabOrder = 2
        end
        object chkJanelas: TCheckBox
          Left = 19
          Top = 125
          Width = 252
          Height = 17
          Caption = 'Permitir sistema abrir mais de uma janela'
          TabOrder = 3
        end
        object chkCod99: TCheckBox
          Left = 19
          Top = 148
          Width = 252
          Height = 17
          Caption = 'PDV C'#243'd 99'
          TabOrder = 4
        end
        object edtViasSanFun: TSpinEdit
          Left = 156
          Top = 219
          Width = 81
          Height = 22
          Color = 15916445
          Ctl3D = False
          MaxValue = 0
          MinValue = 0
          ParentCtl3D = False
          TabOrder = 5
          Value = 1
        end
        object edtLogoMarca: TRzEdit
          Left = 21
          Top = 268
          Width = 283
          Height = 19
          Text = ''
          Color = 15916445
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 6
        end
        object edtCodigoDiversos: TRzEdit
          Left = 150
          Top = 55
          Width = 87
          Height = 19
          Text = ''
          Color = clWhite
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 7
        end
        object chkClienteAvulso: TCheckBox
          Left = 19
          Top = 171
          Width = 252
          Height = 17
          Caption = 'Informar Cliente Avulso'
          TabOrder = 8
        end
        object chkExibeFechamento: TCheckBox
          Left = 267
          Top = 102
          Width = 252
          Height = 17
          Caption = 'Exibe Tela Fechamento'
          TabOrder = 9
        end
        object chkClienteIdentificaCompleto: TCheckBox
          Left = 267
          Top = 125
          Width = 252
          Height = 17
          Caption = 'Identifica Cliente Completo'
          TabOrder = 10
        end
        object edtHoraVirada: TRzEdit
          Left = 267
          Top = 168
          Width = 63
          Height = 19
          Hint = 'Hora em que o PDV exige o fechamento do caixa. Em branco = meia-noite.'
          ParentShowHint = False
          ShowHint = True
          Text = ''
          Color = clWhite
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 11
        end
      end
      object Panel25: TPanel
        Left = 0
        Top = 37
        Width = 297
        Height = 92
        BevelOuter = bvNone
        Color = 14086904
        ParentBackground = False
        TabOrder = 1
        object Panel29: TPanel
          Left = 0
          Top = 0
          Width = 297
          Height = 18
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Vendedor/Clientes'
          Color = clTeal
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
        end
        object chkInformarVendedor: TCheckBox
          Left = 21
          Top = 30
          Width = 252
          Height = 17
          Caption = 'Informar o vendedor no fechamento da venda'
          TabOrder = 1
        end
        object chkVendaInicio: TCheckBox
          Left = 21
          Top = 53
          Width = 252
          Height = 17
          Caption = 'Informar o cliente no in'#237'cio da venda'
          TabOrder = 2
        end
      end
      object Panel4: TPanel
        Left = -7
        Top = 8
        Width = 620
        Height = 23
        BevelOuter = bvNone
        Caption = 'Par'#226'metros'
        Color = clTeal
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
      end
    end
  end
  object btnAvancar: TAdvGlowButton
    Left = 509
    Top = 547
    Width = 100
    Height = 52
    Anchors = [akTop, akRight]
    Caption = 'Gravar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    NotesFont.Charset = DEFAULT_CHARSET
    NotesFont.Color = clWindowText
    NotesFont.Height = -11
    NotesFont.Name = 'Tahoma'
    NotesFont.Style = []
    ParentFont = False
    Picture.Data = {
      89504E470D0A1A0A0000000D49484452000000280000002808060000008CFEB8
      6D0000001974455874536F6674776172650041646F626520496D616765526561
      647971C9653C0000036669545874584D4C3A636F6D2E61646F62652E786D7000
      000000003C3F787061636B657420626567696E3D22EFBBBF222069643D225735
      4D304D7043656869487A7265537A4E54637A6B633964223F3E203C783A786D70
      6D65746120786D6C6E733A783D2261646F62653A6E733A6D6574612F2220783A
      786D70746B3D2241646F626520584D5020436F726520352E332D633031312036
      362E3134353636312C20323031322F30322F30362D31343A35363A3237202020
      2020202020223E203C7264663A52444620786D6C6E733A7264663D2268747470
      3A2F2F7777772E77332E6F72672F313939392F30322F32322D7264662D73796E
      7461782D6E7323223E203C7264663A4465736372697074696F6E207264663A61
      626F75743D222220786D6C6E733A786D704D4D3D22687474703A2F2F6E732E61
      646F62652E636F6D2F7861702F312E302F6D6D2F2220786D6C6E733A73745265
      663D22687474703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F73
      547970652F5265736F75726365526566232220786D6C6E733A786D703D226874
      74703A2F2F6E732E61646F62652E636F6D2F7861702F312E302F2220786D704D
      4D3A4F726967696E616C446F63756D656E7449443D22786D702E6469643A3444
      3538324345333046463345343131383932454130343642353242383133372220
      786D704D4D3A446F63756D656E7449443D22786D702E6469643A363237383534
      38374633313031314534413133314444363345433831363235412220786D704D
      4D3A496E7374616E636549443D22786D702E6969643A36323738353438364633
      313031314534413133314444363345433831363235412220786D703A43726561
      746F72546F6F6C3D2241646F62652050686F746F73686F702043533620285769
      6E646F777329223E203C786D704D4D3A4465726976656446726F6D2073745265
      663A696E7374616E636549443D22786D702E6969643A34443538324345333046
      46334534313138393245413034364235324238313337222073745265663A646F
      63756D656E7449443D22786D702E6469643A3444353832434533304646334534
      313138393245413034364235324238313337222F3E203C2F7264663A44657363
      72697074696F6E3E203C2F7264663A5244463E203C2F783A786D706D6574613E
      203C3F787061636B657420656E643D2272223F3E77FAF4360000049549444154
      78DACC987B6C53551CC7BF6D6FDB6D1D5BBBECA5190FC1C188222841A2238D12
      93C5408868F085890A2AF1458CF10F497C4062A231D11031BE12FF300650D098
      98208A4074021115C42DA251746E202B34E04AB7D1767DF8FDDD9DCA5CDADE7B
      DB6BE72FF9A4D9EEB9E77C7FBF7BCEEF77CE7104DFFD09455833B98CCC2773C9
      34524F6AD5F30809931ED2450E931F49C8EA409AC5F6579265E40E32AB40BB26
      3293B48FF9DF2F6433F9981C313BA0D364BB4BC91BE42BB2DE405C3E13C11B54
      1FAFA93E6D11783FD943D6101F4AB76AF220D9ADFA2E5AA09BBCA59802FB6DAA
      EAFB4D3596258193C8FB663CB4C11E5063559B1528DE6C21CB513E5BAE169066
      46E0EB6429CA6FCBD4D805054AB85763E2EC3E454E81B3C90B98787B9EB4E612
      B89604EC1841733A4A795D2AD263E3054AB95A695708E2E98C2EB204A1779139
      6305DEAE524BC99173BB1C383A3482BDE7E270509FFC5D84D590DBB202A56EDE
      6387B868328DD3B114365EDD8CA75A03D8131AC6B99174B122578936C93BF3D4
      EEC4508044249381FE9BCB62A90CBAE3492C6CA9C6CAB9F5FA3BEB8F8471498D
      07D3AB34FDDD243FBF49BB885C2E021719B594084824BACE275155A0DD5F6C83
      58127D9138663554E2D9EB5B3099E2561F38899E911496042A10A3732329D322
      1789C02B8C5A89E7129D853EB71E957C511081DD9A035EED42725835BF1153FC
      1E2CDD7D1C3B4E0D6349D3A88B2645CE1381D38D5AC984DFD05687871634156C
      97A227E28CBFF2DF15EB86197E74D57A71F7277F60C79F8358DCECD3BF8A0991
      D3A4A706433F9219B4D655A0DEE72E7A11CDACAFC4CE15AD78F8B35E6C393188
      A0DF5BF06B6437BE4E537B427634184F959C1F25B29B6F9A81756D0174461366
      168C3E593228B3F9DC4ED3A3CA27364E52F4B4D2E32A59D808FB7972572F5EFE
      2D8260ADA94F9C1681A70DE7212774889F64389182334FF94A73207926BFB28A
      5DE3DAC9FB8FEEEAC3073D11B49B5F246111D8A78E90796D31BDDD7A6C00FBFA
      8790AFBCBA98BDA34C3361E6C14DCC7FD74EADF9E7D9775CB96B3EEFC3E1B331
      74B48C56D4F3AC3A26EC7711F803B9B150AB6CE5F89403C433B9BDF6B2515C16
      120546131716D44747CFE2E6CE139283D07171351342C64AA2EE1281FB0DE70E
      3BF4730EB61BCCC3B027856E8F13931971B14D5F87B0F6603F02151AAEAAF3EA
      73D042A9133BA0A9537F64CCAD40EE5468D0B1BE9361A4677B351C3B13C3CE5F
      07F0C4C110E6B0BC3556B8AC442D6B67E480AFA9EB88B7C9E3A5AC507140A21C
      A0C847F69DC471CEB1606395D9C590CBDE116D920765B6BE471276E43811D3C0
      3C179CE429455C421D4533D92AF2AD128952A3A8570C35578B1407A5E59BF167
      925764B76E47142D2E84F1364C36E63A341D22CFFC0F4E75A2E1FB7CE7E217C9
      8713286E3B79C9E866E15E33B9F13FB04E35B6E1D54794AC205F9451DC5E722B
      19327BBBD5AF2E74B69741DC36720B3965F57E704079F5B4CAEA769BF4B94E9D
      7F078AB9C0CCDA73A443254EBB6CABEAD3F02EC8EC1DF52175FB701D46EF97C3
      4588927DE7AB2448EE547D9ADA515BB12F15928E16906BD4BD4E9BDAF47AC694
      2A71E267B59DDBAF04F55AF5EA6F01060058D57322DA95B3520000000049454E
      44AE426082}
    Transparent = True
    TabOrder = 1
    OnClick = btnAvancarClick
    Appearance.BorderColor = 12631218
    Appearance.BorderColorHot = 10079963
    Appearance.BorderColorDown = 4548219
    Appearance.Color = 14671574
    Appearance.ColorTo = 15000283
    Appearance.ColorChecked = 7915518
    Appearance.ColorCheckedTo = 11918331
    Appearance.ColorDisabled = 15921906
    Appearance.ColorDisabledTo = 15921906
    Appearance.ColorDown = 7778289
    Appearance.ColorDownTo = 4296947
    Appearance.ColorHot = 15465983
    Appearance.ColorHotTo = 11332863
    Appearance.ColorMirror = 14144974
    Appearance.ColorMirrorTo = 15197664
    Appearance.ColorMirrorHot = 5888767
    Appearance.ColorMirrorHotTo = 10807807
    Appearance.ColorMirrorDown = 946929
    Appearance.ColorMirrorDownTo = 5021693
    Appearance.ColorMirrorChecked = 10480637
    Appearance.ColorMirrorCheckedTo = 5682430
    Appearance.ColorMirrorDisabled = 11974326
    Appearance.ColorMirrorDisabledTo = 15921906
    Appearance.GradientHot = ggVertical
    Appearance.GradientMirrorHot = ggVertical
    Appearance.GradientDown = ggVertical
    Appearance.GradientMirrorDown = ggVertical
    Appearance.GradientChecked = ggVertical
    Layout = blGlyphLeftAdjusted
  end
  object btnCancelar: TAdvGlowButton
    Left = 383
    Top = 547
    Width = 100
    Height = 52
    Anchors = [akTop, akRight]
    Caption = 'Cancelar'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    NotesFont.Charset = DEFAULT_CHARSET
    NotesFont.Color = clWindowText
    NotesFont.Height = -11
    NotesFont.Name = 'Tahoma'
    NotesFont.Style = []
    ParentFont = False
    Picture.Data = {
      89504E470D0A1A0A0000000D49484452000000280000002808060000008CFEB8
      6D000000097048597300000EC300000EC301C76FA864000000206348524D0000
      7A25000080830000F9FF000080E8000052080001155800003A970000176FD75A
      1F90000009564944415478DAB4996B6C5BE51DC6FF12621293264DB02FDB00D1
      7DD844B742B9AF6D1A9A9B9DA4F812DBE7E2A471EC243E766E6D9396B409C99C
      A494316DD2C6C404B41B1250AA6E6C65373469C03676D13498B6412EBEC44D5B
      484BE3738EEF766227E9B30FC776E2DA4E5C281F9E0FB6FCFAFDF9F9BFEFFBFC
      CF6B82CB45799A18A7D5D15192190745CDBD146EEB21997550BCAD9F427C3745
      F93E921927494CE7DD122B74CBACF0A2CC0A6F4B8CFD4389B14733BA2CF38EBF
      CAAC704A6485C33263DF2E330E0A324E92F92E8A58FA28DADC4741733745F81E
      928D022D1F1D223C3941D7F250B98009DB210AF13DB70659E790CC086E89B123
      2BD1D489F5AF25C60ED1D80969DDFB32239C9319FB7199EBBA2BDAB69F622DFB
      6F10A0B59764D67973D8DCFDB4C40A6105A610A81C89CAB8E520EF783E62EEBD
      2DD8D2F329019B7B296CE9D1048C9D7ED1D8F189C10ADDED8068EA0CCACD4E6B
      D4DC47B2D1B101E0B82B5FC72708632E0A724E928DC2B8C4D8F34A75E3A45442
      36399E951907AD3E3142F8EEB1021EC2A82B5F63E3B43A3C4232279C0A18DA21
      99EC9F015C819B6F2E0F0E1326260A7808AD2E45FB5C84B62769D9324422DBFE
      EA6709554C01C6F64EAA7590603DAEB064B80887C6143D3E4E387C8CA25CEFF8
      82CE5AFACB3E4DB93718BBA0B7226CEC3A8DFE09C29109C22117E1D018515418
      A0A83040B19EC729E238B027602A5156B31392C68240851662630B247357F960
      E58C35D91130DA10B6F75AA33D83392E4AB51FA1947D8892AD876F5AD0B68BA2
      A9A37030EF8458C340D2DB10F9F96F205B0F42ACD02A136F06773D634D9DB8A2
      B521B16FE0B6947D9852ED478856FA4668A57F8CA26D7D4F2FE8AD25263041AC
      D022FAAFFF620940CC7F01A28A8758A9DF18F2138C5DD0DB10B1F49C5939E8A2
      95BE11A228DF4F51EEE02D92C9BE5C70CEB102C4C61688554644DF7D1F4900F1
      A5652401C4CE7D08692348B31362B50962850ED1F73EC81FEBBF08A9B119929A
      87C4390A378CB1031176FFD6283F40146BE9A710DB351428565A9D15928A43CC
      7D4E9960318D786209F1645A799D85ACD0E6AF2BB31362B511E26E1DA2EFFE2F
      07174F2C219E48611140321C47D0D00E5963C926CCBAE8EC4090753E176BEE27
      92CDDD24B3C2474553A2A91D929A47E4B5DF2B935C456E922C64CC7F0162BD19
      E22E8D0299756EB77E9DEB991F96584262E52AD2003E7EE32DCC566A21EBAD08
      F18515905921229BBB6F2699737CADE41A6205484D3604EEAB45F88553480248
      603D644A819C3D0FA9DE0CF1D126886A5E296B9E73A93CB82BA7CF62EA8E7B30
      F9880AFE061E41CE5104B21332E7D092CC3A0E6C98B19C0392CE8AC0BDD508BF
      F08A0279B508E4DC4588155A04EEAD46F4DF1F143A975EC532802BAF9EC5E4ED
      F7C0B3B3113E358BE93D3AF8D5AC02C939AF75F124C9BCE3D4A687EF7AC8E75F
      C92F7772ADDCD177DF47E4CDBF153AB79C813BF54B4CDEB91DEE1D0DF0AA1978
      6B8DF0D61A31BD4787D96B214D76C89CF0179279C73BA2B18C74C8426EAF29EE
      6422854476092453796B4E71EE5798BAEB3EB81F51C3AB66737039C82A1DFC2A
      26576ED1D40999137C2431F6F9B213817340D2B521705F4D092753882FA67280
      6B70673175E7F69270EB9DBC06522289B127AF2B4F3390E2032A849EF929E2B1
      04E2E99535C08C12A96524928BB8FCFC4B98DA723F3C3B1A3684CB8354E720E3
      D70FC8D821357743DCAD43607B0D62B317D6CABA4E8B0062F31F637A5B25A6B6
      DC0FDF5EF3A670F94EB208728E384926FBC7D705973DE72AF588FEF33F0ADC62
      BA0030BEA8408627DD703FACC2F4D60AF8EAB9F221ABF4F0ABD92005CDCE7F94
      B549CA4888447A1589F46A6ED3C417D3480388F8E630F3601DA6EFDE015F4379
      909E1A03BC75C67314E41D67CA02DC2C21D2AB5804B00820B17215B1B8F27E0E
      D27B4E71F21BE5417A6A0CF0A999BF93C43A8E6CFA30946999364B884BCF9CC4
      87A34F2305289F59178B6900118F1FEE87324E6E526E4F8D017E15FB320579E7
      D6CDE1322DD37BEF974E88D36731F9E56FE283DBBE8E4B3F3A81740652715259
      97D972BB1FACC5F4D65D1B42BA6B0DB8A0E6CD24714E9218BB54328B1B5B2056
      E7B75BA512C2B3AB11DE2A3D26BFF22D5CFAE10B39C8DC39B96E4DBA1F5163E6
      815A78554C29C8F45C3DF7798A9A0F5288757EBF68BBA5B742AC630BDBAD8D12
      42C5C053A9C1E457B7613E0B79158865CA1D4BA4B00C20168CC053A9817B6743
      6179AB9AE0A9674ECF36351385D8FD14627ABF5474A318DA21AA7944CEFC3617
      6DB1F81212AB9B24848A8167B70693B76FCB73323B360D407CE36D782AF6C2B3
      5B930F586782FB513DCED7310F5F7CCC4CB4D43B44A9832314B6F49C5CD0DB4A
      B65BA19FBC84446622A5657A5DE94A4A254416729D934BD9B12FBFA68CDDB5B7
      A0C453953A5CD4B5FC31D9758092F65EA255E730ADF68C52CA36F88580BE3D55
      7011C43920E96D4A2773E2552C01B8F28BDF61EA8E7BE0D999DF951485ACD428
      6BF2D99F6105C09533BFC6E4EDDB8AC2796B8C98DCA5C105B675CBA5AE2E9AEF
      B013055B0F5070DF010ADB0628D8D6CD078CB622F92B40D2DB1054F1081C1EC7
      D48E06CC7C5B0D5F19D99A859CB9BF1AE7BB1E8767D75E78763616DD1C338FEA
      30DF641B0AB4F6D16556A0CBAC40B4DC3FA2E8D028AD0EB828C2F59C58682A01
      69EC845C6DC27C3D8F995A8372DA97135D2A06DE2A3DA6B755C253A929EAFA4C
      A50E9E3AC39FA307FB29797498920383943C344804CB78466304EB714AB71CA5
      0583F5AD52E7A2CC08089BBB704967C17495AE7CC84DE4AED4BBE74CCD37CDD9
      ADE46FDD477E8B22C2906B4DC3637475648C96078748E6843F050C1DC5215901
      1173F70D8174EF6982A7DA301DDF3FF0C5B4EB3B941E1EA6D4D0504E8463AE35
      4DB8084F4D1026C628C8394836D84F89251E07644640E4533AE9A936C0536BF8
      834F65FADCCA13A3841F7C4FB9E13A762CA792179841C64131732F852CDD9D01
      63675AB9C0BC314E7AAA9BE0A932E05C037B744ECB914F65A4A5C347094F3D79
      1D37AC2681A22D7D14B6F591CC3AB684F8AE17B30FD585905927F51B43D618E1
      AD31C05FCFBE3EFB18BFFDBCD64CE7B51C79EB0C9F10B0B997426DBD24734E4A
      580728C4773F14641D3F9619E1CAB5576AD98D339385CC6A0D30E2A9359E9C53
      3355F3060BF99B5A68EE319EE634370270DDDF1031AE8F828CF31689B16B2446
      78566285B7645670CBAC108898BBA297B496A8BBA649F2A94C3E5F9DE91D6F9D
      F184AFCEC4FBD4A65B3D6A135D6860E9A3A6569AD5359705F8FF0100B9934224
      A87C8EDD0000000049454E44AE426082}
    Transparent = True
    TabOrder = 2
    OnClick = btnCancelarClick
    Appearance.BorderColor = 12631218
    Appearance.BorderColorHot = 10079963
    Appearance.BorderColorDown = 4548219
    Appearance.Color = 14671574
    Appearance.ColorTo = 15000283
    Appearance.ColorChecked = 7915518
    Appearance.ColorCheckedTo = 11918331
    Appearance.ColorDisabled = 15921906
    Appearance.ColorDisabledTo = 15921906
    Appearance.ColorDown = 7778289
    Appearance.ColorDownTo = 4296947
    Appearance.ColorHot = 15465983
    Appearance.ColorHotTo = 11332863
    Appearance.ColorMirror = 14144974
    Appearance.ColorMirrorTo = 15197664
    Appearance.ColorMirrorHot = 5888767
    Appearance.ColorMirrorHotTo = 10807807
    Appearance.ColorMirrorDown = 946929
    Appearance.ColorMirrorDownTo = 5021693
    Appearance.ColorMirrorChecked = 10480637
    Appearance.ColorMirrorCheckedTo = 5682430
    Appearance.ColorMirrorDisabled = 11974326
    Appearance.ColorMirrorDisabledTo = 15921906
    Appearance.GradientHot = ggVertical
    Appearance.GradientMirrorHot = ggVertical
    Appearance.GradientDown = ggVertical
    Appearance.GradientMirrorDown = ggVertical
    Appearance.GradientChecked = ggVertical
    Layout = blGlyphLeftAdjusted
  end
  object edtConfigAnt: TAdvGlowButton
    Left = 13
    Top = 551
    Width = 192
    Height = 49
    Caption = 'Ler configura'#231#245'es antigas'
    NotesFont.Charset = DEFAULT_CHARSET
    NotesFont.Color = clWindowText
    NotesFont.Height = -11
    NotesFont.Name = 'Tahoma'
    NotesFont.Style = []
    Picture.Data = {
      89504E470D0A1A0A0000000D49484452000000280000002808060000008CFEB8
      6D000000097048597300000EC300000EC301C76FA864000000206348524D0000
      7A25000080830000F9FF000080E8000052080001155800003A970000176FD75A
      1F900000080A4944415478DABC995D6C5BE519805F0931894948136C12D2346D
      6C5743D38634600212D74E4B932671827DCEF14F12276E9A94262194B6406929
      B0C2184CEC629A9040303169EA10378801EB4F92529AB4244DE2738E93B64949
      491B5A5ADAD0A6A98F9DC471EC67174ED3E617A709B3F45CD8B23F3D7E7FBEEF
      F36B8117653A2F09133B2465A8C2F112A1372018AA70A24230BDC2515FFAB9A1
      FE3A6568B518DABB98DAA7E8EA19743582AE4608A9E7097B5B30B55D18DA5398
      DABD18AAA44C55D0BDC2F18070CC2F74F984633E49E96E6164ABC09F64A68F64
      2468AA42DF5AC1F4DD4158DB86A1F5A2AB4C115298F65C57A1D33DFD7543EDC7
      505F41F7FE829EF2F4DA4B16EC29154E940BBA7A2B47FDAFA16BC373CA2C8690
      9A20EC7B8B6EDF9D74FB9720684E45D049BBEB4B3ADD4B139B19DD4E65882E5F
      90637E49190B0AEE9CC12B022F4AAADB2B74BA774E7EEBE5939B1E4DD0D53752
      862A8C3F27F0EA2C1F21F9FC0CFE28C4B70BA66717475C2C39A5DF45871B42EE
      26A2CF08C99766F908FD8149CA84810AA1BF5CD0B57F7F6F519B3F9ACD9C0C08
      5F05D32E935E426CCB244F0B234F095DDA4E5A8BFEBF72BA0AADC5A02BEF11D9
      24C4B64E790903EBD39CAD13BE7ACC4E485920AD1E08B9A023777EDA73A1230F
      7405746D111154D2CD73AA2AC8D9BA292FA1BF5238552DF4046EE1B0F35B420A
      18F32DA480EE216506E6271C00B304F44740772F4E5257E0B0138E97DDC9E96A
      A1BF52848BF5C2E026A1AFFC358E142FBC409B8D64CF56A2A323C4623162D1E1
      598C8DC5181CB2B8ACBF009DF72D5EF248319C08BCCFC54DC2C57A11C23EC1F4
      DE46A792983F72D7041F26D9BB83C80458E360C567134FC2450B9ACD2B5C0A3D
      07FAEF17976E4385763718DA3D74F964F2C8F16CCB683B69CB26D9B30D2B0ED1
      D114D191F82CE2E349AE0C47F8DC3C47B339C490F102E88B8C644881B0F626C7
      4B4430BC82AE9DCDE883190A0E0D47E9348F71C838C7A1AE61868CE7417F0074
      D722D2AD5DC5F4DD2A84D55F665C1F19088E27525CBE62D172A48B96D61007DA
      07686A1FE47CEBB310B283E9C9BC1E4DB548528667E3720A8E8E25B86A8D72FA
      EC054E9FF986AFCE9EE7E4D731FACEC7891F7D1A3A1D990B1ADA3B82E9DD95F1
      719681A0151B23363ACE44122652309184640AE28065BECAC4FEDF40B73FB33A
      343C0785B0B779C19B4A4885B0024715D0B3A0EF59220B08CEC96882680AC6CC
      1D243EFE19E84E38EEFB6E4153EB1374F5EBF90F7215BE70C34937982A84D282
      D64D0AC6BB5E24F1F1CF1969C886EE02E857A173C1A6B924E8EAC8BC6F38E1E6
      CC012F1B37AF23B8A11AC5E7E4F5BFFD859B7DFCE39F6F51E45A4D455590CAEA
      72FAF678D292F30B46E71734551870B1637B25B7DF57CFFDCE1A7EFA8087B28D
      AF12B5225C1E1AE6C2C54B1931F8ED1031CB62F3CB6F72D7FD1EFE50FC387765
      3F4949702D09D3093DDE050443CA37739E20663ABD5B9F59C76FF36AC92F798C
      FCD21A0A7CD5389500858BC4E92EA3C057457E690DF9258F91ADD452545AC5E5
      8F1C102E9CBB7142EA90D0EDFB9C0EF7DC827D6E9EDF5E392558585643AEB78A
      ACC212B29D25643B4B33A484ACC212567BD6515896167CD85D8BB7B28AA1DD76
      3890C544FBA3D325430A989E7E21EC7D7FCE2E9E43708AD20D37C70D6B5C13BC
      B237070E6411D96B4B4B76F96E143C2CE8DAD6796B7096E07AF24B375010A89B
      A47611D4A525FDEB670B36DBB0F6ADC09A29A96BFF124CED9E4C050B4A6B58E3
      AB26D75546AEBB8C5C77206356BB4A59E3ADA260468AAF09461B1D5392C96B92
      A6E69794A109BA7A2923C1401D6BB44A725639C979C449CE234519E3C8C92757
      A9A0A0BC6E5EC129C97D3626DA1F1DA7DBFFC3F40822ACBD3EEBB89BECE26D5B
      2BF9DD5417A75394A706C9D382E4696B33470DB2C6573D558BD94A2DAE8A6A2E
      ED5E092DD705A34D395CDD6B23BACFFEDEF8C1DCC9EB5648FB311DEEE9577D53
      85532EB66C59C74F1E7C82156A2DD9EE1AB2953A6C5AFD4DF004D94A1DD9EE1A
      6C4A2DBF5AB591E2C07A463EB5933CB8629A60748F8D7863D603E34D59227CFD
      B870EE49A137F00EED33AEFC5FBA39F2819F02FF3A0AFDD52815CB4351D97A56
      FB36B0E7AD6268CBBA2ED7E820F2DF2C465AF31B3915144E9589706E8370AE4E
      38B9F6765A8BE3D3521D52E1A40A9D459CFBD0C1E0270EBEDDBD72C95CF86415
      B146077C9E9DAEBB6BF5D760C7FACF434C74F9EE4E0ED448B27F9D083D01A1A7
      2C3DBDEA2DF7A5A752D34613D0EB49EFF69F3D0C07B3A0C506CD4BA0C506076D
      C41A1D580DD7A37775B78DF8E1FC6D7428425BA1D0EA1421B2298DB545B0360B
      61CFDB73FEBAEBF23171A4186B6F7ACFBA312DCB41E4938718D9BFF233869E10
      86370B57EA852BF5229C2ABFCE99A0D0572AB4BBF6CFB9374E4A46BE07C9C847
      0FF6264CD72D5C582F9CAE100682C2405084F8B6EB8C6F17C67708D16704533B
      40BB6BB664B79FC4324A5A7B6C587B571C9F18ACFF516AEC0521B17D9A93C0CB
      37F092C09F0576A6C76F1DAE5D730E91BAFDCB12496B9F9D58837DAFD594F383
      546287C05F271DAE3B2D30C0D4D29B784F5915EDEEF159178A25A4DB6A481F69
      2307563F3B7A385FAC268724ADA72683B3D811F017154248BD9B6EDFBBB3E6D1
      37D3380D76629FAEFA70F450DEBDF1963C193D9C2F56A3FD2605A786E89AD017
      144CEFFD98DADF31B40BD324DB8A3289E4D568A3FD9DB1861C47FC50A18CB53B
      65EC60AE8C1E5AB30C82B3FE86D06EC3509D18DA1B18EA7EBAFDBD89B6A241AB
      C11E8936D823D146C7A558A3A32FDAE8688E3639DE8E36397CD126C71DD12687
      8C35AC94784B818CB6156424F8BF01009FA2A1EEC0ABEA0E0000000049454E44
      AE426082}
    Transparent = True
    TabOrder = 3
    OnClick = edtConfigAntClick
    Appearance.BorderColor = 12631218
    Appearance.BorderColorHot = 10079963
    Appearance.BorderColorDown = 4548219
    Appearance.Color = 14671574
    Appearance.ColorTo = 15000283
    Appearance.ColorChecked = 7915518
    Appearance.ColorCheckedTo = 11918331
    Appearance.ColorDisabled = 15921906
    Appearance.ColorDisabledTo = 15921906
    Appearance.ColorDown = 7778289
    Appearance.ColorDownTo = 4296947
    Appearance.ColorHot = 15465983
    Appearance.ColorHotTo = 11332863
    Appearance.ColorMirror = 14144974
    Appearance.ColorMirrorTo = 15197664
    Appearance.ColorMirrorHot = 5888767
    Appearance.ColorMirrorHotTo = 10807807
    Appearance.ColorMirrorDown = 946929
    Appearance.ColorMirrorDownTo = 5021693
    Appearance.ColorMirrorChecked = 10480637
    Appearance.ColorMirrorCheckedTo = 5682430
    Appearance.ColorMirrorDisabled = 11974326
    Appearance.ColorMirrorDisabledTo = 15921906
    Appearance.GradientHot = ggVertical
    Appearance.GradientMirrorHot = ggVertical
    Appearance.GradientDown = ggVertical
    Appearance.GradientMirrorDown = ggVertical
    Appearance.GradientChecked = ggVertical
  end
  object DataSource1: TDataSource
    DataSet = dmConfiguracoes.qrConfiguracaoPDV
    Left = 480
  end
  object ACBrNFe1: TACBrNFe
    Configuracoes.Geral.SSLLib = libNone
    Configuracoes.Geral.SSLCryptLib = cryNone
    Configuracoes.Geral.SSLHttpLib = httpNone
    Configuracoes.Geral.SSLXmlSignLib = xsNone
    Configuracoes.Geral.FormatoAlerta = 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.'
    Configuracoes.Geral.VersaoQRCode = veqr000
    Configuracoes.Arquivos.OrdenacaoPath = <>
    Configuracoes.WebServices.UF = 'SP'
    Configuracoes.WebServices.AguardarConsultaRet = 0
    Configuracoes.WebServices.QuebradeLinha = '|'
    Configuracoes.RespTec.IdCSRT = 0
    Left = 528
  end
  object OpenDialog1: TOpenDialog
    Left = 568
  end
  object ACBrPosPrinter1: TACBrPosPrinter
    ConfigBarras.MostrarCodigo = False
    ConfigBarras.LarguraLinha = 0
    ConfigBarras.Altura = 0
    ConfigBarras.Margem = 0
    ConfigQRCode.Tipo = 2
    ConfigQRCode.LarguraModulo = 4
    ConfigQRCode.ErrorLevel = 0
    LinhasEntreCupons = 0
    Left = 592
    Top = 112
  end
  object PrintDialog1: TPrintDialog
    Left = 528
    Top = 280
  end
end
