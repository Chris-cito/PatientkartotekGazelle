object frmGebyr: TfrmGebyr
  Left = 373
  Top = 73
  Caption = 'Gebyr'
  ClientHeight = 269
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object rgGebyr: TRadioGroup
    Left = 0
    Top = 0
    Width = 321
    Height = 185
    Align = alTop
    Items.Strings = (
      '&Udbringningsgebyr'
      'U&dleveringsgebyr'
      '&Institutionsgebyr')
    TabOrder = 0
    OnClick = rgGebyrClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 185
    Width = 321
    Height = 84
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 5
      Height = 24
      Align = alTop
      Alignment = taCenter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object BitBtn1: TBitBtn
      Left = 56
      Top = 48
      Width = 75
      Height = 25
      Caption = '&Ja'
      Kind = bkYes
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 200
      Top = 48
      Width = 75
      Height = 25
      Caption = '&Nej'
      Kind = bkNo
      NumGlyphs = 2
      TabOrder = 1
    end
  end
end
