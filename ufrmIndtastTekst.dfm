object frmIndtastTekst: TfrmIndtastTekst
  Left = 0
  Top = 0
  Caption = 'Indtast tekst'
  ClientHeight = 235
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblVarenavn: TLabel
    Left = 32
    Top = 16
    Width = 79
    Height = 23
    Caption = 'Varenavn'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 32
    Top = 56
    Width = 42
    Height = 13
    Caption = 'Dosering'
  end
  object Label3: TLabel
    Left = 32
    Top = 128
    Width = 47
    Height = 13
    Caption = 'Indikation'
  end
  object edtDoserings: TEdit
    Left = 32
    Top = 80
    Width = 377
    Height = 21
    TabOrder = 0
    Text = 'edtDoserings'
  end
  object edtIndtag: TEdit
    Left = 32
    Top = 152
    Width = 377
    Height = 21
    TabOrder = 1
    Text = 'edtIndtag'
  end
  object bitOK: TBitBtn
    Left = 176
    Top = 192
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 2
    OnClick = bitOKClick
  end
end
