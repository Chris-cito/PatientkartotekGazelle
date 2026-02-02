object frmDosKort: TfrmDosKort
  Left = 434
  Top = 404
  Caption = 'Takser Dosiskort'
  ClientHeight = 483
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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 271
    Height = 65
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 26
      Width = 53
      Height = 13
      Caption = '&Dosiskortnr'
      FocusControl = edtCardNumber
    end
    object edtCardNumber: TEdit
      Left = 128
      Top = 22
      Width = 121
      Height = 21
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 65
    Width = 271
    Height = 64
    Align = alTop
    TabOrder = 1
    object Label2: TLabel
      Left = 32
      Top = 21
      Width = 73
      Height = 13
      Caption = '&Pakkegruppenr'
      FocusControl = edtPakke
    end
    object edtPakke: TEdit
      Left = 128
      Top = 17
      Width = 121
      Height = 21
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 352
    Width = 271
    Height = 131
    Align = alBottom
    TabOrder = 4
    object btnOK: TBitBtn
      Left = 32
      Top = 90
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
      TabOrder = 2
      OnClick = btnOKClick
    end
    object BitBtn2: TBitBtn
      Left = 174
      Top = 90
      Width = 75
      Height = 25
      Caption = '&Fortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 3
      OnClick = BitBtn2Click
    end
    object chkDosis: TCheckBox
      Left = 32
      Top = 26
      Width = 217
      Height = 17
      Caption = '&Takser dosiskort automatisk'
      TabOrder = 0
    end
    object chkAfstempling: TCheckBox
      Left = 32
      Top = 56
      Width = 185
      Height = 17
      Caption = '&Undlad afstemplingsetiketter'
      TabOrder = 1
    end
  end
  object GroupBox4: TGroupBox
    Left = 0
    Top = 129
    Width = 271
    Height = 56
    Align = alTop
    TabOrder = 2
    object Label3: TLabel
      Left = 32
      Top = 22
      Width = 36
      Height = 13
      Caption = '&Lev. nr.'
      FocusControl = edtLevnr
    end
    object edtLevnr: TEdit
      Left = 128
      Top = 19
      Width = 121
      Height = 21
      TabOrder = 0
    end
  end
  object GroupBox5: TGroupBox
    Left = 0
    Top = 185
    Width = 271
    Height = 167
    Align = alClient
    TabOrder = 3
    object rgSort: TRadioGroup
      Left = 32
      Top = 6
      Width = 217
      Height = 122
      Caption = 'Sortering'
      Items.Strings = (
        'Sorteret efter &kortnr'
        'Sorteret efter &cprnr'
        'Sorteret efter &navn')
      TabOrder = 0
    end
  end
  object nqSelectDos: TnxQuery
    Left = 211
    Top = 375
  end
end
