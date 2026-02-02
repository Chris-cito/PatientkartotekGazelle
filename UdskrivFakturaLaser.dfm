object fmFakturaLaser: TfmFakturaLaser
  Left = 761
  Top = 287
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Udskrift af faktura p'#229' laserprinter'
  ClientHeight = 303
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
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object paPrm: TPanel
    Left = 0
    Top = 0
    Width = 387
    Height = 303
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      387
      303)
    object buUdskriv: TBitBtn
      Left = 168
      Top = 248
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
      TabOrder = 2
      OnClick = buUdskrivClick
    end
    object buFortryd: TBitBtn
      Left = 274
      Top = 248
      Width = 100
      Height = 35
      Hint = 'Fortryd udskrift af pakkeseddel'
      Anchors = [akTop, akRight]
      Caption = 'F&ortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 3
    end
    object gbFaktura: TGroupBox
      Left = 8
      Top = 4
      Width = 361
      Height = 85
      TabOrder = 0
      object Label1: TLabel
        Left = 17
        Top = 48
        Width = 20
        Height = 16
        Alignment = taRightJustify
        Caption = 'F&ra'
        FocusControl = eFraNr
      end
      object Label2: TLabel
        Left = 176
        Top = 47
        Width = 15
        Height = 16
        Alignment = taRightJustify
        Caption = 'T&il'
        FocusControl = eTilNr
      end
      object eFraNr: TEdit
        Left = 42
        Top = 45
        Width = 90
        Height = 24
        TabOrder = 1
        Text = 'eFraNr'
      end
      object eTilNr: TEdit
        Left = 196
        Top = 44
        Width = 90
        Height = 24
        TabOrder = 2
        Text = 'eTilNr'
      end
      object chkFakt: TCheckBox
        Left = 16
        Top = 16
        Width = 97
        Height = 17
        Caption = '&Fakturanr'
        TabOrder = 0
        OnClick = chkFaktClick
      end
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 95
      Width = 361
      Height = 137
      TabOrder = 1
      object Label3: TLabel
        Left = 16
        Top = 52
        Width = 48
        Height = 16
        Caption = 'Konto&nr.'
        FocusControl = edtKundenr
      end
      object Label4: TLabel
        Left = 16
        Top = 104
        Width = 52
        Height = 16
        Caption = 'Fra &Dato'
        FocusControl = DateTimePicker1
      end
      object Label5: TLabel
        Left = 192
        Top = 104
        Width = 47
        Height = 16
        Caption = 'Til D&ato'
        FocusControl = DateTimePicker2
      end
      object DateTimePicker1: TDateTimePicker
        Left = 80
        Top = 100
        Width = 89
        Height = 24
        Date = 39594.000000000000000000
        Time = 0.372139386599883400
        TabOrder = 2
      end
      object DateTimePicker2: TDateTimePicker
        Left = 248
        Top = 100
        Width = 89
        Height = 24
        Date = 39594.000000000000000000
        Time = 0.372139386599883400
        TabOrder = 3
      end
      object edtKundenr: TEdit
        Left = 80
        Top = 48
        Width = 121
        Height = 24
        TabOrder = 1
      end
      object chkKont: TCheckBox
        Left = 16
        Top = 16
        Width = 97
        Height = 17
        Caption = '&Kontonr'
        TabOrder = 0
        OnClick = chkKontClick
      end
    end
    object chkVaelgPDF: TCheckBox
      Left = 25
      Top = 257
      Width = 137
      Height = 17
      Caption = '&V'#230'lg PDF Mappe'
      TabOrder = 4
    end
  end
end
