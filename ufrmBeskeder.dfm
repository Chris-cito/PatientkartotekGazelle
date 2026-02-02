object frmBeskeder: TfrmBeskeder
  Left = 328
  Top = 149
  Caption = 'EOrdre Beskeder'
  ClientHeight = 397
  ClientWidth = 472
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 472
    Height = 169
    Align = alTop
    TabOrder = 0
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 470
      Height = 167
      Align = alClient
      ReadOnly = True
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 329
    Width = 472
    Height = 68
    Align = alClient
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 80
      Top = 16
      Width = 113
      Height = 33
      Caption = '&OK'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 304
      Top = 16
      Width = 113
      Height = 33
      Caption = '&Fortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 169
    Width = 472
    Height = 160
    Align = alTop
    Caption = 'Panel3'
    TabOrder = 2
    object Memo2: TMemo
      Left = 1
      Top = 1
      Width = 470
      Height = 158
      Align = alClient
      TabOrder = 0
    end
  end
end
