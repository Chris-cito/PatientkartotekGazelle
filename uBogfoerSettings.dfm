object frmBogfoerSettings: TfrmBogfoerSettings
  Left = 0
  Top = 0
  Caption = 'Bogf'#248'r / Faktura settings'
  ClientHeight = 271
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 224
    Width = 447
    Height = 47
    Align = alBottom
    TabOrder = 0
    object Button1: TButton
      Left = 80
      Top = 8
      Width = 75
      Height = 25
      Action = acBogfoer
      TabOrder = 0
    end
    object Button2: TButton
      Left = 288
      Top = 8
      Width = 75
      Height = 25
      Action = acFortryd
      TabOrder = 1
    end
  end
  object gbEmail: TGroupBox
    Left = 0
    Top = 73
    Width = 447
    Height = 151
    Align = alClient
    Caption = 'Email Faktura'
    TabOrder = 1
    object gbEmailTekst: TGroupBox
      Left = 2
      Top = 21
      Width = 443
      Height = 128
      Align = alClient
      Caption = 'Evt. supplerende tekst:'
      TabOrder = 0
      object memEmailSubject: TMemo
        Left = 2
        Top = 28
        Width = 439
        Height = 98
        Align = alBottom
        TabOrder = 0
      end
    end
  end
  object gbCheckBoxes: TGroupBox
    Left = 0
    Top = 0
    Width = 447
    Height = 73
    Align = alTop
    TabOrder = 2
    object chkPrint: TCheckBox
      Left = 40
      Top = 16
      Width = 137
      Height = 17
      Action = acPrint
      TabOrder = 0
    end
    object chkEmailFaktura: TCheckBox
      Left = 40
      Top = 47
      Width = 153
      Height = 17
      Action = acEmail
      TabOrder = 1
    end
  end
  object ActionManager1: TActionManager
    Left = 312
    Top = 32
    StyleName = 'Platform Default'
    object acBogfoer: TAction
      Caption = '&Bogf'#248'r'
      ShortCut = 32834
      OnExecute = acBogfoerExecute
    end
    object acFortryd: TAction
      Caption = 'Fortryd'
      ShortCut = 27
      OnExecute = acFortrydExecute
    end
    object acPrint: TAction
      Caption = '&Print Faktura'
      OnExecute = acPrintExecute
    end
    object acEmail: TAction
      Caption = '&Email Faktura'
      OnExecute = acEmailExecute
    end
  end
end
