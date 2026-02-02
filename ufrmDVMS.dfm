object frmDMVS: TfrmDMVS
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'DMVS'
  ClientHeight = 196
  ClientWidth = 358
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
  object lblLbnr: TLabel
    Left = 32
    Top = 48
    Width = 28
    Height = 19
    Caption = 'lbnr'
  end
  object lblVarenr: TLabel
    Left = 32
    Top = 73
    Width = 47
    Height = 19
    Caption = 'Varenr'
  end
  object Label1: TLabel
    Left = 32
    Top = 20
    Width = 275
    Height = 19
    Caption = 'Dette er en DMVS vare og skal scannes'
  end
  object Label2: TLabel
    Left = 32
    Top = 156
    Width = 192
    Height = 16
    Caption = 'Tryk escape for at forlade pop-up'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object edtScan: TEdit
    Left = 32
    Top = 108
    Width = 275
    Height = 27
    TabOrder = 0
    OnKeyPress = edtScanKeyPress
  end
  object ActionManager1: TActionManager
    Left = 272
    Top = 47
    StyleName = 'Platform Default'
    object acOpdater: TAction
      Caption = '&Opdater'
      OnExecute = acOpdaterExecute
    end
    object acFortryd: TAction
      Caption = '&Fortryd'
      ShortCut = 27
      OnExecute = acFortrydExecute
    end
  end
end
