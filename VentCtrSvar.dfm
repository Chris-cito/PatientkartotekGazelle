object frmVentCtrSvar: TfrmVentCtrSvar
  Left = 392
  Top = 301
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 284
  ClientWidth = 202
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object paCtr1: TPanel
    Left = 0
    Top = 0
    Width = 202
    Height = 284
    Align = alClient
    BevelWidth = 2
    TabOrder = 0
    object paCtgr2: TPanel
      Left = 2
      Top = 2
      Width = 198
      Height = 280
      Align = alClient
      BevelOuter = bvLowered
      BevelWidth = 2
      TabOrder = 0
      object laCtr2: TLabel
        Left = 2
        Top = 258
        Width = 194
        Height = 20
        Align = alBottom
        Alignment = taCenter
        Caption = 'G'#248'r du ogs'#229' ?'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
        ExplicitWidth = 115
      end
      object laCtr1: TLabel
        Left = 2
        Top = 238
        Width = 194
        Height = 20
        Align = alBottom
        Alignment = taCenter
        Caption = 'Jeg venter p'#229' CTR ! '
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
        ExplicitWidth = 165
      end
      object amCtr: TAnimate
        Left = 2
        Top = 2
        Width = 194
        Height = 236
        Align = alClient
        Color = clWhite
        FileName = 'CtrDino.avi'
        ParentColor = False
        StopFrame = 18
        Timers = True
      end
    end
  end
end
