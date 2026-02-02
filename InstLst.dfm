object InLstForm: TInLstForm
  Left = 305
  Top = 236
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Instansoversigt'
  ClientHeight = 383
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object InLstGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 327
    Height = 383
    Align = alClient
    Options = [dgTitles, dgColLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = InLstGridDblClick
    OnTitleClick = InLstGridTitleClick
  end
  object ActionManager1: TActionManager
    Left = 104
    Top = 64
    StyleName = 'Platform Default'
    object acLuk: TAction
      Caption = 'acLuk'
      ShortCut = 27
      OnExecute = acLukExecute
    end
    object AcAltK: TAction
      Caption = 'AcAltK'
      ShortCut = 32843
      OnExecute = AcAltKExecute
    end
    object acAltA: TAction
      Caption = 'acAltA'
      ShortCut = 32833
      OnExecute = acAltAExecute
    end
    object acAltN: TAction
      Caption = 'acAltN'
      ShortCut = 32846
      OnExecute = acAltNExecute
    end
    object AcEnter: TAction
      Caption = 'AcEnter'
      ShortCut = 13
      OnExecute = AcEnterExecute
    end
  end
end
