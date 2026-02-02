object frmResv: TfrmResv
  Left = 820
  Top = 435
  Caption = 'Reservation'
  ClientHeight = 147
  ClientWidth = 347
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
  DesignSize = (
    347
    147)
  PixelsPerInch = 96
  TextHeight = 13
  object laVareNr: TLabel
    Left = 37
    Top = 45
    Width = 37
    Height = 13
    Alignment = taRightJustify
    Anchors = []
    Caption = '&Grossist'
    FocusControl = dblKonti
  end
  object buReserv: TBitBtn
    Left = 21
    Top = 87
    Width = 100
    Height = 34
    Hint = 'Reserver vare hos Max Jenne'
    Anchors = []
    Caption = '&Reserver'
    Default = True
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555500005550000000055555555500005509999999005555555500005099
      9999990105555555000000111111110110555555000000000000000011055555
      0000501111111110011055550000550FFFFFFFF0F011055500005550FFFFFFF0
      F0011055000055550F800000F0F011050000555550FFFFFFF0F0010500005555
      550F800000F0F005000055555550FFFFFFF0F0050000555555550F800000F055
      00005555555550FFFFFFF055000055555555550F800000550000555555555550
      0055555500005555555555555555555500005555555555555555555500005555
      55555555555555550000}
    TabOrder = 0
    TabStop = False
    OnClick = buReservClick
  end
  object dblKonti: TDBLookupComboBox
    Left = 97
    Top = 39
    Width = 217
    Height = 28
    Anchors = []
    DataField = 'GrNr'
    DataSource = MainDm.dsGro
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    KeyField = 'GrNr'
    ListField = 'FullNavn'
    ListSource = MainDm.dsKto
    ParentFont = False
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 256
    Top = 88
    Width = 75
    Height = 34
    Caption = '&Fortryd'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
end
