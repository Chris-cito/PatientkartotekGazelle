object frmVaelgLevliste: TfrmVaelgLevliste
  Left = 457
  Top = 147
  BorderStyle = bsDialog
  Caption = 'V'#230'lg leveringsliste'
  ClientHeight = 359
  ClientWidth = 357
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dbgLevliste: TDBGrid
    Left = 0
    Top = 0
    Width = 357
    Height = 257
    Align = alTop
    DataSource = MainDm.dsVaelgLevliste
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 257
    Width = 357
    Height = 102
    Align = alClient
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 48
      Top = 48
      Width = 75
      Height = 25
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 232
      Top = 48
      Width = 75
      Height = 25
      Caption = '&Fortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
end
