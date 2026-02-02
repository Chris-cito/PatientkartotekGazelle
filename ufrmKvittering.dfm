object frmKvittering: TfrmKvittering
  Left = 328
  Top = 149
  Caption = 'EOrdre Kvittering'
  ClientHeight = 217
  ClientWidth = 401
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
  object Label1: TLabel
    Left = 48
    Top = 36
    Width = 40
    Height = 13
    Caption = 'Pakkenr'
    FocusControl = edtLbnr
  end
  object edtLbnr: TEdit
    Left = 144
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 156
    Width = 401
    Height = 61
    Align = alBottom
    TabOrder = 1
    object BitOK: TBitBtn
      Left = 56
      Top = 18
      Width = 110
      Height = 32
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BitOKClick
    end
    object BitCancel: TBitBtn
      Left = 248
      Top = 18
      Width = 110
      Height = 32
      Caption = 'Fortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
end
