object fmValgFors: TfmValgFors
  Left = 650
  Top = 259
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Forsendelsesliste'
  ClientHeight = 364
  ClientWidth = 245
  Color = clBtnFace
  Constraints.MinHeight = 262
  Constraints.MinWidth = 192
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object gbKonto: TGroupBox
    Left = 0
    Top = 0
    Width = 245
    Height = 89
    Align = alTop
    Caption = 'Konto for forsendelse'
    TabOrder = 0
    object edtFraKonto: TEdit
      Left = 7
      Top = 20
      Width = 100
      Height = 24
      TabOrder = 0
    end
    object edtTilKonto: TEdit
      Left = 119
      Top = 20
      Width = 100
      Height = 24
      TabOrder = 1
    end
    object chkAfslutListe: TCheckBox
      Left = 8
      Top = 56
      Width = 97
      Height = 17
      Caption = '&Tildel listenr'
      TabOrder = 2
      OnClick = chkAfslutListeClick
    end
  end
  object gbDatoer: TGroupBox
    Left = 0
    Top = 92
    Width = 245
    Height = 83
    Align = alBottom
    Caption = 'Dato interval'
    TabOrder = 1
    object Label3: TLabel
      Left = 111
      Top = 24
      Width = 16
      Height = 16
      Caption = '  -  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object dtpFraDato: TDateTimePicker
      Left = 7
      Top = 20
      Width = 100
      Height = 24
      Date = 36606.000000000000000000
      Time = 36606.000000000000000000
      TabOrder = 0
    end
    object dtpTilDato: TDateTimePicker
      Left = 132
      Top = 20
      Width = 100
      Height = 24
      Date = 36606.000000000000000000
      Time = 36606.000000000000000000
      TabOrder = 1
    end
    object dtpFraTid: TDateTimePicker
      Left = 7
      Top = 48
      Width = 58
      Height = 24
      Date = 38961.574297338000000000
      Format = 'HH:mm'
      Time = 38961.574297338000000000
      Kind = dtkTime
      TabOrder = 2
    end
    object dtpTilTid: TDateTimePicker
      Left = 132
      Top = 48
      Width = 58
      Height = 24
      Date = 38961.575000000000000000
      Format = 'HH:mm'
      Time = 38961.575000000000000000
      Kind = dtkTime
      TabOrder = 3
    end
  end
  object gbTurNr: TGroupBox
    Left = 0
    Top = 175
    Width = 245
    Height = 54
    Align = alBottom
    Caption = 'Turnr for forsendelse'
    TabOrder = 2
    object Label1: TLabel
      Left = 45
      Top = 23
      Width = 16
      Height = 16
      Caption = '  -  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object edtFraTur: TEdit
      Left = 7
      Top = 20
      Width = 21
      Height = 24
      TabOrder = 0
      Text = '0'
    end
    object udFraTur: TUpDown
      Left = 28
      Top = 20
      Width = 12
      Height = 24
      Associate = edtFraTur
      Max = 9
      TabOrder = 1
    end
    object edtTilTur: TEdit
      Left = 66
      Top = 20
      Width = 21
      Height = 24
      TabOrder = 2
      Text = '9'
    end
    object udTilTur: TUpDown
      Left = 87
      Top = 20
      Width = 13
      Height = 24
      Associate = edtTilTur
      Max = 9
      Position = 9
      TabOrder = 3
    end
  end
  object paKnapper: TPanel
    Left = 0
    Top = 324
    Width = 245
    Height = 40
    Align = alBottom
    TabOrder = 4
    DesignSize = (
      245
      40)
    object butOK: TBitBtn
      Left = 7
      Top = 6
      Width = 100
      Height = 30
      Anchors = [akLeft, akBottom]
      Caption = '&Godkend'
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
    end
    object butFortryd: TBitBtn
      Left = 139
      Top = 6
      Width = 100
      Height = 30
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = '&Fortryd'
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      ModalResult = 2
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object gbEkspType: TGroupBox
    Left = 0
    Top = 229
    Width = 245
    Height = 54
    Align = alBottom
    Caption = 'Ekspeditioner'
    TabOrder = 3
    object cbxEkspTyp: TComboBox
      Left = 7
      Top = 20
      Width = 100
      Height = 24
      Style = csDropDownList
      DropDownCount = 3
      ItemIndex = 0
      TabOrder = 0
      Text = 'Alle'
      Items.Strings = (
        'Alle'
        #197'bne'
        'Afsluttede')
    end
    object cbxKontrol: TCheckBox
      Left = 116
      Top = 23
      Width = 121
      Height = 17
      Caption = 'Kontrol aktiveret'
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 283
    Width = 245
    Height = 41
    Align = alBottom
    BorderStyle = bsSingle
    TabOrder = 5
    object Label2: TLabel
      Left = 8
      Top = 11
      Width = 39
      Height = 16
      Caption = '&Kopier'
      FocusControl = EdtKopi
    end
    object EdtKopi: TEdit
      Left = 58
      Top = 7
      Width = 33
      Height = 24
      TabOrder = 0
      Text = '1'
    end
  end
end
