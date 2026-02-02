object FakturaForm: TFakturaForm
  Left = 399
  Top = 326
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Udskrift af faktura'
  ClientHeight = 133
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object gbFakturaNr: TGroupBox
    Left = 4
    Top = 1
    Width = 140
    Height = 78
    Caption = 'Fakturanr'
    TabOrder = 0
    object Label1: TLabel
      Left = 17
      Top = 23
      Width = 20
      Height = 16
      Alignment = taRightJustify
      Caption = 'Fra'
    end
    object Label2: TLabel
      Left = 22
      Top = 49
      Width = 15
      Height = 16
      Alignment = taRightJustify
      Caption = 'Til'
    end
    object eFra: TEdit
      Left = 42
      Top = 20
      Width = 90
      Height = 24
      TabOrder = 0
    end
    object eTil: TEdit
      Left = 42
      Top = 46
      Width = 90
      Height = 24
      TabOrder = 1
    end
  end
  object gbPrinter: TGroupBox
    Left = 148
    Top = 1
    Width = 116
    Height = 78
    Caption = 'Printervalg'
    TabOrder = 1
    object cbPrnNr: TComboBox
      Left = 8
      Top = 46
      Width = 100
      Height = 24
      Style = csDropDownList
      DropDownCount = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 0
      Items.Strings = (
        '1. Printer'
        '2. Printer'
        '3. Printer')
    end
  end
  object gbFakturaValg: TGroupBox
    Left = 268
    Top = 1
    Width = 116
    Height = 78
    Caption = 'Fakturavalg'
    TabOrder = 2
    object cbFakNr: TComboBox
      Left = 8
      Top = 46
      Width = 100
      Height = 24
      Style = csDropDownList
      DropDownCount = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 16
      ParentFont = False
      TabOrder = 0
      Items.Strings = (
        '1. Faktura'
        '2. Faktura'
        '3. Faktura')
    end
  end
  object Panel1: TPanel
    Left = 4
    Top = 84
    Width = 380
    Height = 46
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    object laMsg: TLabel
      Left = 12
      Top = 12
      Width = 50
      Height = 24
      Caption = 'laMsg'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ButOK: TBitBtn
      Left = 272
      Top = 9
      Width = 100
      Height = 28
      Caption = '&Udskriv'
      TabOrder = 0
      OnClick = ButOKClick
      NumGlyphs = 2
    end
  end
end
