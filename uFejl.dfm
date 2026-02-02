object frmRcpKont: TfrmRcpKont
  Left = 733
  Top = 101
  BiDiMode = bdLeftToRight
  BorderStyle = bsSingle
  Caption = 'Rcp Kontrol'
  ClientHeight = 382
  ClientWidth = 404
  Color = clWindow
  Constraints.MinHeight = 411
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlParams: TPanel
    Left = 0
    Top = 105
    Width = 404
    Height = 136
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 60
      Width = 48
      Height = 13
      Caption = '&Start Dato'
      FocusControl = dtpStart
    end
    object Label2: TLabel
      Left = 24
      Top = 100
      Width = 44
      Height = 13
      Caption = 'S&lut Dato'
      FocusControl = dtpEnd
    end
    object Label3: TLabel
      Left = 24
      Top = 27
      Width = 38
      Height = 13
      Caption = '&Afdeling'
    end
    object dtpStart: TDateTimePicker
      Left = 112
      Top = 56
      Width = 81
      Height = 21
      Date = 39793.572243506900000000
      Time = 39793.572243506900000000
      TabOrder = 1
    end
    object dtpEnd: TDateTimePicker
      Left = 112
      Top = 96
      Width = 81
      Height = 21
      Date = 39793.572243506900000000
      Time = 39793.572243506900000000
      TabOrder = 2
    end
    object cboAfdeling: TComboBox
      Left = 112
      Top = 24
      Width = 145
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
  end
  object rgSortering: TRadioGroup
    Left = 0
    Top = 241
    Width = 404
    Height = 95
    Align = alClient
    Caption = 'Sortering'
    Color = clBtnFace
    Ctl3D = True
    ItemIndex = 0
    Items.Strings = (
      '&Brugernr'
      '&Dato')
    ParentColor = False
    ParentCtl3D = False
    TabOrder = 2
  end
  object TPanel
    Left = 0
    Top = 336
    Width = 404
    Height = 46
    Align = alBottom
    TabOrder = 3
    object BtnOK: TBitBtn
      Left = 56
      Top = 8
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
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object btnFortryd: TBitBtn
      Left = 288
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Fortr&yd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 0
    Top = 0
    Width = 404
    Height = 105
    Align = alTop
    Color = clBtnFace
    ItemIndex = 0
    Items.Strings = (
      '&Vis Ekspedition'
      'Vis &restscanningsliste')
    ParentColor = False
    TabOrder = 0
    OnClick = RadioGroup1Click
  end
end
