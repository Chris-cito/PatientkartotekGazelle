object frmRCPTidy: TfrmRCPTidy
  Left = 448
  Top = 123
  Caption = 'Oprydning i lokale receptkvitteringer'
  ClientHeight = 426
  ClientWidth = 435
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 435
    Height = 426
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 80
      Top = 100
      Width = 67
      Height = 20
      Caption = '&Startdato'
      FocusControl = dtpStartDate
    end
    object Label2: TLabel
      Left = 80
      Top = 132
      Width = 60
      Height = 20
      Caption = 'S&lutdato'
      FocusControl = dtpEndDate
    end
    object Label3: TLabel
      Left = 88
      Top = 314
      Width = 42
      Height = 20
      Caption = #197'&rsag'
      FocusControl = edtArsag
    end
    object Label4: TLabel
      Left = 1
      Top = 405
      Width = 433
      Height = 20
      Align = alBottom
      ExplicitWidth = 4
    end
    object Label5: TLabel
      Left = 1
      Top = 1
      Width = 433
      Height = 20
      Align = alTop
      WordWrap = True
      ExplicitWidth = 4
    end
    object BitBtn1: TBitBtn
      Left = 104
      Top = 369
      Width = 89
      Height = 25
      Caption = '&OK'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 270
      Top = 369
      Width = 89
      Height = 25
      Caption = '&Fortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
    object dtpStartDate: TDateTimePicker
      Left = 174
      Top = 92
      Width = 107
      Height = 28
      Date = 39272.380345358800000000
      Time = 39272.380345358800000000
      TabOrder = 2
    end
    object dtpEndDate: TDateTimePicker
      Left = 174
      Top = 132
      Width = 107
      Height = 28
      Date = 39272.380575555600000000
      Time = 39272.380575555600000000
      TabOrder = 3
    end
    object RadioGroup1: TRadioGroup
      Left = 80
      Top = 170
      Width = 185
      Height = 121
      Items.Strings = (
        '&Tilbage'
        '&Ugyldigg'#248'r')
      TabOrder = 4
      OnClick = RadioGroup1Click
    end
    object edtArsag: TEdit
      Left = 160
      Top = 314
      Width = 201
      Height = 28
      TabOrder = 5
    end
  end
end
