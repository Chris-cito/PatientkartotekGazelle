object frmStatus: TfrmStatus
  Left = 328
  Top = 149
  Caption = 'Skift EOrdre Status'
  ClientHeight = 387
  ClientWidth = 365
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RadioGroup1: TRadioGroup
    Left = 0
    Top = 0
    Width = 365
    Height = 321
    Align = alTop
    Items.Strings = (
      '&Ny'
      '&UnderBehandling'
      '&Ekspederet'
      '&KlarTilAfhentning'
      '&Afsluttet'
      'A&nnulleretAfKunde'
      'Annu&lleretAfApotek'
      '&Bed om accept at h'#248'jere DIBS bel'#248'b')
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 321
    Width = 365
    Height = 66
    Align = alClient
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 56
      Top = 24
      Width = 75
      Height = 25
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 224
      Top = 24
      Width = 75
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
end
