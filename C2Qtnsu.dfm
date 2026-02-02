object frmC2Q: TfrmC2Q
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'C2K'#248
  ClientHeight = 56
  ClientWidth = 275
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object pnlC2Qbuts: TPanel
    Left = 0
    Top = 0
    Width = 275
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      275
      56)
    object bitRec: TSpeedButton
      Left = 0
      Top = 0
      Width = 56
      Height = 56
      Action = acC2qRec
      Anchors = [akLeft, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Pitch = fpVariable
      Font.Style = [fsBold]
      ParentFont = False
    end
    object bitHkb: TSpeedButton
      Left = 54
      Top = 0
      Width = 56
      Height = 56
      Action = acC2QHkb
      Anchors = [akLeft, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Pitch = fpVariable
      Font.Style = [fsBold]
      ParentFont = False
    end
    object bitFort: TSpeedButton
      Left = 108
      Top = 0
      Width = 60
      Height = 56
      Action = acC2QLuk
      Anchors = [akLeft, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Pitch = fpVariable
      Font.Style = [fsBold]
      ParentFont = False
    end
    object bitLukke: TSpeedButton
      Left = 166
      Top = 0
      Width = 56
      Height = 56
      Action = acC2QLuk
      Anchors = [akLeft, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Pitch = fpVariable
      Font.Style = [fsBold]
      ParentFont = False
    end
    object bitNaeste: TSpeedButton
      Left = 220
      Top = 0
      Width = 56
      Height = 56
      Action = acC2QNaeste
      Anchors = [akLeft, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Pitch = fpVariable
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object ActionList1: TActionList
    Left = 136
    Top = 65528
    object acC2qRec: TAction
      Caption = 'Recept'
      ShortCut = 112
      OnExecute = acC2qRecExecute
    end
    object acC2QHkb: TAction
      Caption = 'H'#229'ndk'#248'b'
      ShortCut = 113
      OnExecute = acC2QHkbExecute
    end
    object acC2QFort: TAction
      Caption = 'Fortryd'
      ShortCut = 114
      OnExecute = acC2QFortExecute
    end
    object acC2QLuk: TAction
      Caption = 'Lukket'
      ShortCut = 115
      OnExecute = acC2QLukExecute
    end
    object acC2QNaeste: TAction
      Caption = 'N'#230'ste'
      ShortCut = 116
      OnExecute = acC2QNaesteExecute
    end
  end
end
