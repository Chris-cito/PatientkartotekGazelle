object frmDebKont: TfrmDebKont
  Left = 435
  Top = 216
  BorderStyle = bsDialog
  Caption = 'Debitor Eksp. Kontrol'
  ClientHeight = 192
  ClientWidth = 271
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 16
    Width = 37
    Height = 13
    Caption = '&Kontonr'
    FocusControl = edtKonto
  end
  object Label2: TLabel
    Left = 32
    Top = 64
    Width = 49
    Height = 13
    Caption = '&Start  dato'
    FocusControl = dtpStart
  end
  object Label3: TLabel
    Left = 32
    Top = 112
    Width = 42
    Height = 13
    Caption = 'S&lut dato'
    FocusControl = dtpSlut
  end
  object edtKonto: TEdit
    Left = 112
    Top = 12
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object dtpStart: TDateTimePicker
    Left = 112
    Top = 60
    Width = 81
    Height = 21
    Date = 40392.391654004600000000
    Time = 40392.391654004600000000
    TabOrder = 1
  end
  object dtpSlut: TDateTimePicker
    Left = 112
    Top = 108
    Width = 81
    Height = 21
    Date = 40392.391694155100000000
    Time = 40392.391694155100000000
    TabOrder = 2
  end
  object BitBtn1: TBitBtn
    Left = 32
    Top = 152
    Width = 75
    Height = 25
    Caption = '&OK'
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    ModalResult = 1
    NumGlyphs = 2
    TabOrder = 3
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 160
    Top = 152
    Width = 75
    Height = 25
    Caption = '&Fortryd'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 4
  end
  object nqDebKont: TnxQuery
    AliasName = 'Produktion'
    SQL.Strings = (
      '#t 100000'
      'SELECT '
      #9'* '
      'FROM '
      #9'"Ekspeditioner" '
      'WHERE '
      '//'#9'lbnr>startlbnr and lbnr<=endlbnr and '
      '//'#9'kontonr=:kontonr and '
      #9'brugerkontrol=0;')
    Left = 219
    Top = 52
  end
end
