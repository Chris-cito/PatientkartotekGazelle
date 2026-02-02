object frmEkspUdskriv: TfrmEkspUdskriv
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Ekspeditionsliste'
  ClientHeight = 230
  ClientWidth = 210
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 210
    Height = 65
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 47
      Height = 16
      Caption = '&Fradato'
      FocusControl = eFra
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 108
      Top = 8
      Width = 42
      Height = 16
      Caption = '&Tildato'
      FocusControl = eTil
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object eFra: TDateTimePicker
      Left = 8
      Top = 24
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
      Top = 24
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
  object rgDetailedList: TRadioGroup
    Left = 0
    Top = 65
    Width = 210
    Height = 112
    Align = alTop
    Items.Strings = (
      '&Alm Ekspeditionsliste'
      '&Detailjeret liste til intern brug')
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 177
    Width = 210
    Height = 53
    Align = alClient
    TabOrder = 2
    object BitBtn1: TBitBtn
      Left = 8
      Top = 16
      Width = 75
      Height = 25
      Caption = '&OK'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 123
      Top = 16
      Width = 75
      Height = 25
      Caption = '&Fortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
end
