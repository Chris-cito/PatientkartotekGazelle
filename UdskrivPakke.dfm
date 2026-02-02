object PakkeForm: TPakkeForm
  Left = 314
  Top = 318
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Udskrift af pakkeseddel'
  ClientHeight = 111
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
  object gbPakkeNr: TGroupBox
    Left = 4
    Top = 1
    Width = 187
    Height = 52
    Caption = 'Pakkenr'
    TabOrder = 0
    object eNr: TEdit
      Left = 8
      Top = 20
      Width = 90
      Height = 24
      TabOrder = 0
    end
  end
  object gbPrinterValg: TGroupBox
    Left = 197
    Top = 1
    Width = 187
    Height = 52
    Caption = 'Printervalg'
    TabOrder = 1
    object cbPrnNr: TComboBox
      Left = 8
      Top = 18
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
  object Panel1: TPanel
    Left = 4
    Top = 59
    Width = 380
    Height = 46
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    TabStop = True
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
