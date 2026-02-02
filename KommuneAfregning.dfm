object KommuneForm: TKommuneForm
  Left = 335
  Top = 166
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Udskriv kommuneafregning'
  ClientHeight = 406
  ClientWidth = 374
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object gbDatoer: TGroupBox
    Left = 0
    Top = 2
    Width = 374
    Height = 68
    Align = alBottom
    Caption = 'Datointerval'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 20
      Height = 16
      Caption = 'Fra'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 108
      Top = 20
      Width = 15
      Height = 16
      Caption = 'Til'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object eFra: TDateTimePicker
      Left = 8
      Top = 36
      Width = 90
      Height = 24
      Date = 36606.329333564800000000
      Time = 36606.329333564800000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object eTil: TDateTimePicker
      Left = 108
      Top = 36
      Width = 90
      Height = 24
      Date = 36606.329333564800000000
      Time = 36606.329333564800000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object gbKommuner: TGroupBox
    Left = 0
    Top = 70
    Width = 374
    Height = 102
    Align = alBottom
    Caption = 'Kommuneinterval'
    TabOrder = 1
    object Label6: TLabel
      Left = 8
      Top = 20
      Width = 20
      Height = 16
      Caption = 'Fra'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 101
      Top = 20
      Width = 15
      Height = 16
      Caption = 'Til'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 110
      Height = 16
      Caption = 'Regel (blank=alle)'
    end
    object eFraIn: TEdit
      Left = 8
      Top = 36
      Width = 65
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '100'
    end
    object eTilIn: TEdit
      Left = 101
      Top = 36
      Width = 65
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '999'
    end
    object edtRegel: TEdit
      Left = 133
      Top = 68
      Width = 33
      Height = 24
      TabOrder = 2
    end
  end
  object gbPrinter: TGroupBox
    Left = 0
    Top = 282
    Width = 374
    Height = 54
    Align = alBottom
    Caption = 'Printer'
    TabOrder = 3
    object cbPNr: TComboBox
      Left = 8
      Top = 20
      Width = 200
      Height = 24
      Style = csDropDownList
      DropDownCount = 6
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Items.Strings = (
        '1 - Printer et'
        '2 - Printer to'
        '3 - Printer tre'
        '4 - Forvalg til sk'#230'rm'
        '5 - Forvalg til diskfil'
        '6 - Windows printer')
    end
  end
  object gbDebitor: TGroupBox
    Left = 0
    Top = 172
    Width = 374
    Height = 44
    Align = alBottom
    Caption = 'Debitering'
    TabOrder = 2
    object cbDeb: TCheckBox
      Left = 8
      Top = 20
      Width = 193
      Height = 17
      Caption = 'Opdater debitorkonto'
      TabOrder = 0
    end
  end
  object paGentag: TPanel
    Left = 0
    Top = 336
    Width = 374
    Height = 70
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 4
    DesignSize = (
      374
      70)
    object gaMeter: TGauge
      Left = 4
      Top = 4
      Width = 366
      Height = 26
      Anchors = [akLeft, akTop, akRight]
      Color = clWhite
      ParentColor = False
      Progress = 0
    end
    object butAfregn: TBitBtn
      Left = 4
      Top = 35
      Width = 90
      Height = 32
      Hint = 'Dan ny sygesikringsafregning og udskriv'
      Anchors = [akLeft, akBottom]
      Caption = '&Afregning'
      NumGlyphs = 2
      TabOrder = 0
      OnClick = butAfregnClick
    end
    object butDisketter: TBitBtn
      Left = 96
      Top = 35
      Width = 90
      Height = 32
      Hint = 'Gendan diskette(r)'
      Anchors = [akLeft, akBottom]
      Caption = '&Diskette(r)'
      NumGlyphs = 2
      TabOrder = 1
    end
    object butEtik: TBitBtn
      Left = 188
      Top = 35
      Width = 90
      Height = 32
      Hint = 'Dan etiketter til diskette(r)'
      Anchors = [akRight, akBottom]
      Caption = '&Etikette(r)'
      NumGlyphs = 2
      TabOrder = 2
    end
    object butUdskriv: TBitBtn
      Left = 280
      Top = 35
      Width = 90
      Height = 32
      Hint = 'Udskriv menu'
      Anchors = [akRight, akBottom]
      Caption = '&Udskriv'
      NumGlyphs = 2
      TabOrder = 3
      OnClick = butUdskrivClick
    end
  end
  object gbFormat: TGroupBox
    Left = 0
    Top = 216
    Width = 374
    Height = 66
    Align = alBottom
    Caption = 'Formatering'
    TabOrder = 5
    object cbSidCpr: TCheckBox
      Left = 8
      Top = 20
      Width = 193
      Height = 17
      Caption = 'Sideskift pr. cpr.nr'
      TabOrder = 0
    end
    object cbSidRegel: TCheckBox
      Left = 8
      Top = 41
      Width = 193
      Height = 18
      Caption = 'Sideskift pr. regel'
      TabOrder = 1
    end
  end
  object meUd: TPopupMenu
    Left = 228
    Top = 23
    object meUdRegn: TMenuItem
      Caption = 'Udskriv &afregningsliste'
      OnClick = meUdAfrClick
    end
    object meUdOpg: TMenuItem
      Caption = 'Udskriv &samleopg'#248'relse'
      OnClick = meUdOpgClick
    end
    object meUdFejl: TMenuItem
      Caption = 'Udskriv &fejlliste'
      OnClick = meUdFejlClick
    end
  end
end
