object fmPakkeLaser: TfmPakkeLaser
  Left = 766
  Top = 301
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Udskrift af pakkeseddel p'#229' laserprinter'
  ClientHeight = 64
  ClientWidth = 383
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
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object paPrm: TPanel
    Left = 0
    Top = 0
    Width = 383
    Height = 64
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      383
      64)
    object buUdskriv: TBitBtn
      Left = 158
      Top = 17
      Width = 100
      Height = 35
      Hint = 'Udskriv direkte til forvalgt printer'
      Anchors = [akTop, akRight]
      Caption = '&Udskriv'
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333300003000000000000000033300003088888888888880803300000000
        000000000000080300000888888888889BA80003000008888888888888880803
        0000000000000000000008030000088888888888888808030000300000000000
        000080030000330FFFFFFFFFFFF088030000330F0F000F0000F0080300003330
        FFFFFFFFFFFF003300003330F0F00F000F0F0333000033330FFFFFFFFFFFF033
        000033330FF000000F00F0330000333330FFFFFFFFFFFF030000333330000000
        0000000300003333333333333333333300003333333333333333333300003333
        33333333333333330000}
      TabOrder = 1
      OnClick = buUdskrivClick
    end
    object gbPakke: TGroupBox
      Left = 8
      Top = 4
      Width = 96
      Height = 52
      Caption = 'Pakkenr'
      TabOrder = 0
      object eNr: TEdit
        Left = 8
        Top = 20
        Width = 80
        Height = 24
        TabOrder = 0
        Text = 'eNr'
      end
    end
    object buFortryd: TBitBtn
      Left = 270
      Top = 17
      Width = 100
      Height = 35
      Hint = 'Fortryd udskrift af pakkeseddel'
      Anchors = [akTop, akRight]
      Caption = '&Fortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 2
      OnClick = buUdskrivClick
    end
  end
end
