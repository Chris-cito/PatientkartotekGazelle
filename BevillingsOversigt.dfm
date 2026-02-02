object BevillingsForm: TBevillingsForm
  Left = 660
  Top = 384
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Bevillingsoplysninger'
  ClientHeight = 223
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object paBevBut: TPanel
    Left = 0
    Top = 83
    Width = 440
    Height = 140
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label3: TLabel
      Left = 10
      Top = 12
      Width = 37
      Height = 16
      Alignment = taRightJustify
      Caption = 'Regel'
      FocusControl = TilERegel
    end
    object Label8: TLabel
      Left = 27
      Top = 37
      Width = 20
      Height = 16
      Alignment = taRightJustify
      Caption = 'Fra'
      FocusControl = TilFraDato
    end
    object Label9: TLabel
      Left = 32
      Top = 63
      Width = 15
      Height = 16
      Caption = 'Til'
      FocusControl = TilTilDato
    end
    object Label15: TLabel
      Left = 313
      Top = 12
      Width = 53
      Height = 16
      Alignment = taRightJustify
      Caption = 'Niveau 0'
      FocusControl = TilPrm1
    end
    object Label16: TLabel
      Left = 313
      Top = 38
      Width = 53
      Height = 16
      Alignment = taRightJustify
      Caption = 'Niveau 1'
      FocusControl = TilPrm2
    end
    object Label17: TLabel
      Left = 313
      Top = 63
      Width = 53
      Height = 16
      Alignment = taRightJustify
      Caption = 'Niveau 2'
      FocusControl = TilPrm3
    end
    object Label18: TLabel
      Left = 313
      Top = 90
      Width = 53
      Height = 16
      Alignment = taRightJustify
      Caption = 'Niveau 3'
      FocusControl = TilPrm4
    end
    object Label20: TLabel
      Left = 313
      Top = 115
      Width = 53
      Height = 16
      Alignment = taRightJustify
      Caption = 'Ej tilskud'
      FocusControl = TilPrm5
    end
    object buFortryd: TBitBtn
      Left = 154
      Top = 106
      Width = 120
      Height = 30
      Hint = 'Tryk Esc s'#229' tilskud IKKE anvendes'
      Caption = 'Fortryd (Esc)'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      TabStop = False
    end
    object buOk: TBitBtn
      Left = 28
      Top = 106
      Width = 120
      Height = 30
      Hint = 'Tryk F6 s'#229' tilskud godkendes'
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
      TabOrder = 0
      TabStop = False
    end
    object TilERegel: TDBEdit
      Left = 52
      Top = 8
      Width = 40
      Height = 24
      Hint = 'Regel if'#248'lge instans for tilskud'
      TabStop = False
      Color = clSilver
      DataField = 'Regel'
      DataSource = MainDm.dsPatTil
      ReadOnly = True
      TabOrder = 2
    end
    object TilENavn: TDBEdit
      Left = 94
      Top = 8
      Width = 180
      Height = 24
      TabStop = False
      Color = clSilver
      DataField = 'Navn'
      DataSource = MainDm.dsPatTil
      ReadOnly = True
      TabOrder = 3
    end
    object TilFraDato: TDBEdit
      Left = 52
      Top = 34
      Width = 70
      Height = 24
      Hint = 'Bevillings startdato'
      TabStop = False
      Color = clSilver
      DataField = 'FraDato'
      DataSource = MainDm.dsPatTil
      ReadOnly = True
      TabOrder = 4
    end
    object TilTilDato: TDBEdit
      Left = 52
      Top = 60
      Width = 70
      Height = 24
      Hint = 'Bevillings slutdato'
      TabStop = False
      Color = clSilver
      DataField = 'TilDato'
      DataSource = MainDm.dsPatTil
      ReadOnly = True
      TabOrder = 5
    end
    object TilPrm1: TDBEdit
      Left = 369
      Top = 8
      Width = 56
      Height = 24
      Hint = 'Tilskudspromille 1. niveau'
      TabStop = False
      Color = clSilver
      DataField = 'Promille1'
      DataSource = MainDm.dsPatTil
      ReadOnly = True
      TabOrder = 6
    end
    object TilPrm2: TDBEdit
      Left = 369
      Top = 34
      Width = 56
      Height = 24
      Hint = 'Tilskudspromille 2. niveau'
      TabStop = False
      Color = clSilver
      DataField = 'Promille2'
      DataSource = MainDm.dsPatTil
      ReadOnly = True
      TabOrder = 7
    end
    object TilPrm3: TDBEdit
      Left = 369
      Top = 60
      Width = 56
      Height = 24
      Hint = 'Tilskudspromille 3. niveau'
      TabStop = False
      Color = clSilver
      DataField = 'Promille3'
      DataSource = MainDm.dsPatTil
      ReadOnly = True
      TabOrder = 8
    end
    object TilPrm4: TDBEdit
      Left = 369
      Top = 86
      Width = 56
      Height = 24
      Hint = 'Tilskudspromille 5. niveau'
      TabStop = False
      Color = clSilver
      DataField = 'Promille4'
      DataSource = MainDm.dsPatTil
      ReadOnly = True
      TabOrder = 9
    end
    object TilPrm5: TDBEdit
      Left = 369
      Top = 112
      Width = 56
      Height = 24
      Hint = 'Tilskudspromille ikke tilskudsberettiget'
      TabStop = False
      Color = clSilver
      DataField = 'Promille5'
      DataSource = MainDm.dsPatTil
      ReadOnly = True
      TabOrder = 10
    end
  end
  object meBev: TDBMemo
    Left = 0
    Top = 0
    Width = 440
    Height = 83
    TabStop = False
    Align = alClient
    DataField = 'Bevilling'
    DataSource = MainDm.dsPatTil
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
  end
end
