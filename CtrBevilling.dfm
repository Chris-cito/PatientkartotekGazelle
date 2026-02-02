object fmCtrBevilling: TfmCtrBevilling
  Left = 254
  Top = 275
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'CTR bevilling'
  ClientHeight = 521
  ClientWidth = 794
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
  PixelsPerInch = 96
  TextHeight = 16
  object paCtrBev: TPanel
    Left = 0
    Top = 422
    Width = 794
    Height = 99
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      794
      99)
    object Label10: TLabel
      Left = 626
      Top = 11
      Width = 40
      Height = 16
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = 'Varenr'
      ExplicitLeft = 494
    end
    object Label11: TLabel
      Left = 605
      Top = 39
      Width = 61
      Height = 16
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = 'ATC kode'
      ExplicitLeft = 473
    end
    object buFortryd: TBitBtn
      Left = 130
      Top = 66
      Width = 120
      Height = 30
      Hint = 'Tryk Esc s'#229' tilskud IKKE anvendes'
      Anchors = [akLeft, akBottom]
      Caption = 'Fortryd (Esc)'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 3
      TabStop = False
    end
    object buOk: TBitBtn
      Left = 4
      Top = 66
      Width = 120
      Height = 30
      Hint = 'Tryk F6 s'#229' tilskud godkendes'
      Anchors = [akLeft, akBottom]
      Caption = 'Godkend (F6)'
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 2
      TabStop = False
      OnClick = buOkClick
    end
    object stCtrAtcMatch: TStaticText
      Left = 592
      Top = 66
      Width = 200
      Height = 30
      Alignment = taCenter
      Anchors = [akRight, akBottom]
      AutoSize = False
      BevelKind = bkSoft
      BorderStyle = sbsSunken
      Caption = 'ATC kode lighed'
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 4
    end
    object edLinVareNr: TEdit
      Left = 671
      Top = 7
      Width = 120
      Height = 24
      TabStop = False
      Anchors = [akRight, akBottom]
      Color = clSilver
      ReadOnly = True
      TabOrder = 0
    end
    object edLinAtcKode: TEdit
      Left = 671
      Top = 35
      Width = 120
      Height = 24
      TabStop = False
      Anchors = [akRight, akBottom]
      Color = clSilver
      ReadOnly = True
      TabOrder = 1
    end
  end
  object dbgCtrOver: TDBGrid
    Left = 0
    Top = 0
    Width = 794
    Height = 422
    Align = alClient
    DataSource = MainDm.dsCtrBev
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = dbgCtrOverDrawColumnCell
  end
end
