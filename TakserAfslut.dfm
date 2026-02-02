object AfslutForm: TAfslutForm
  Left = 879
  Top = 496
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Afslut ekspedition'
  ClientHeight = 129
  ClientWidth = 322
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
  PixelsPerInch = 96
  TextHeight = 13
  object paTxt: TPanel
    Left = 0
    Top = 89
    Width = 322
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Tekst'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object paAnimation: TPanel
    Left = 0
    Top = 0
    Width = 322
    Height = 89
    Align = alClient
    BevelOuter = bvNone
    Caption = 'paAnimation'
    TabOrder = 1
    object Animate: TAnimate
      Left = 0
      Top = 0
      Width = 322
      Height = 89
      Align = alClient
      CommonAVI = aviCopyFiles
      StopFrame = 34
    end
  end
end
