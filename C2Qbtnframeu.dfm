object C2QFrame: TC2QFrame
  Left = 0
  Top = 0
  Width = 276
  Height = 56
  TabOrder = 0
  object pnlC2Qbuts: TPanel
    Left = 0
    Top = 0
    Width = 276
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      276
      56)
    object bitRec: TSpeedButton
      Left = 0
      Top = 0
      Width = 55
      Height = 56
      Action = acC2qRec
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Recept Alt-F1'
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
      Width = 55
      Height = 56
      Action = acC2QHkb
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'H'#229'ndk'#248'b Alt-F2'
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
      Width = 59
      Height = 56
      Action = acC2QFort
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Fortryd  Alt- F3'
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
      Width = 55
      Height = 56
      Action = acC2QLuk
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Lukket Alt-F4'
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
      Width = 55
      Height = 56
      Action = acC2QNaeste
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'N'#230'ste Alt-F5'
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
      Caption = 'Recept F1'
      ShortCut = 32880
      OnExecute = acC2qRecExecute
    end
    object acC2QHkb: TAction
      Caption = 'H'#229'ndk'#248'b F2'
      ShortCut = 32881
      OnExecute = acC2QHkbExecute
    end
    object acC2QFort: TAction
      Caption = 'Fortryd   F3'
      ShortCut = 32882
      OnExecute = acC2QFortExecute
    end
    object acC2QLuk: TAction
      Caption = 'Lukket F4'
      OnExecute = acC2QLukExecute
    end
    object acC2QNaeste: TAction
      Caption = 'N'#230'ste F5'
      ShortCut = 32884
      OnExecute = acC2QNaesteExecute
    end
  end
end
