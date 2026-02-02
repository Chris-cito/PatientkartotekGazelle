object frmCTRUdskriv: TfrmCTRUdskriv
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'CTR Ekspeditionslister'
  ClientHeight = 250
  ClientWidth = 367
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
  object rgCTRServer: TRadioGroup
    Left = 0
    Top = 0
    Width = 367
    Height = 105
    Align = alTop
    Caption = 'CTR Server'
    Items.Strings = (
      'CTR &A'
      'CTR &B')
    TabOrder = 0
  end
  object rgPeriode: TRadioGroup
    Left = 0
    Top = 105
    Width = 367
    Height = 105
    Align = alTop
    Caption = 'Periode'
    Items.Strings = (
      'A&ktuel Periode'
      '&Forrige Periode')
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 210
    Width = 367
    Height = 40
    Align = alClient
    TabOrder = 2
    object BitBtn1: TBitBtn
      Left = 16
      Top = 6
      Width = 75
      Height = 25
      Caption = '&OK'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 280
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Fortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
end
