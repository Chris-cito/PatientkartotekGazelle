object fmEtk: TfmEtk
  Left = 324
  Top = 321
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Fri etiket'
  ClientHeight = 123
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  DesignSize = (
    392
    123)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 339
    Top = 70
    Width = 24
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = '&Antal'
    FocusControl = eAntal
  end
  object buEtk: TBitBtn
    Left = 314
    Top = 3
    Width = 75
    Height = 28
    Anchors = [akTop, akRight]
    Caption = '&Udskriv [F6]'
    NumGlyphs = 2
    TabOrder = 0
    TabStop = False
    OnClick = buEtkClick
  end
  object meEtk: TMemo
    Tag = 276
    Left = 3
    Top = 1
    Width = 250
    Height = 114
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object eAntal: TEdit
    Left = 367
    Top = 66
    Width = 21
    Height = 21
    Anchors = [akTop, akRight]
    TabOrder = 2
    Text = '1'
    OnKeyPress = eAntalKeyPress
  end
  object buGem: TBitBtn
    Left = 314
    Top = 33
    Width = 75
    Height = 28
    Anchors = [akTop, akRight]
    Caption = '&Gem [F5]'
    NumGlyphs = 2
    TabOrder = 3
    TabStop = False
    OnClick = buGemClick
  end
  object bitLuk: TBitBtn
    Left = 314
    Top = 89
    Width = 75
    Height = 28
    Anchors = [akTop, akRight]
    Caption = '&Luk [Esc]'
    ModalResult = 1
    NumGlyphs = 2
    TabOrder = 4
    TabStop = False
    OnClick = bitLukClick
  end
end
