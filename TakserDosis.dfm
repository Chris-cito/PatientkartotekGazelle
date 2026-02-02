object TakserDosisForm: TTakserDosisForm
  Left = 53
  Top = 0
  BorderIcons = [biMaximize]
  BorderStyle = bsSingle
  Caption = 'Taksering Dosis'
  ClientHeight = 533
  ClientWidth = 780
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = '\C2\C2Help.Hlp'
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object paTop: TPanel
    Left = 0
    Top = 0
    Width = 780
    Height = 153
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object gbKunde: TGroupBox
      Left = 201
      Top = 2
      Width = 573
      Height = 143
      Caption = 'Kundeoplysninger'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      TabStop = True
      object Label3: TLabel
        Left = 365
        Top = 24
        Width = 100
        Height = 13
        Alignment = taRightJustify
        Caption = 'Oprindelig CTR saldo'
        FocusControl = eGlCtrSaldo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 420
        Top = 96
        Width = 45
        Height = 13
        Alignment = taRightJustify
        Caption = 'CTR type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 11
        Top = 24
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kundenr'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 20
        Top = 48
        Width = 31
        Height = 13
        Alignment = taRightJustify
        Caption = '&Ydernr'
        FocusControl = eYderNr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 8
        Top = 72
        Width = 43
        Height = 13
        Alignment = taRightJustify
        Caption = '&Debitornr'
        FocusControl = eDebitorNr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object laSalgRetur: TLabel
        Left = 413
        Top = 120
        Width = 52
        Height = 13
        Alignment = taRightJustify
        Caption = '&Retur/Salg'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label28: TLabel
        Left = 398
        Top = 72
        Width = 67
        Height = 13
        Alignment = taRightJustify
        Caption = 'CTR udligning'
        FocusControl = eCtrUdlign
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label23: TLabel
        Left = 10
        Top = 96
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = 'Lev.for&m'
        FocusControl = lcLevForm
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label16: TLabel
        Left = 399
        Top = 48
        Width = 66
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ny CTR saldo'
        FocusControl = eNyCtrSaldo
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label17: TLabel
        Left = 159
        Top = 96
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'Pakkenr'
        FocusControl = ePakkeNr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label22: TLabel
        Left = 268
        Top = 96
        Width = 46
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nar&kolbnr'
        FocusControl = eNarkoNr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 21
        Top = 120
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Lev.&nr'
        FocusControl = eLevNr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label13: TLabel
        Left = 307
        Top = 120
        Width = 25
        Height = 13
        Alignment = taRightJustify
        Caption = 'Turnr'
        FocusControl = eTurNr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object dbtPBS: TDBText
        Left = 301
        Top = 67
        Width = 59
        Height = 19
        AutoSize = True
        DataField = 'LuPbs'
        DataSource = MainDm.dsEks
        Font.Charset = ANSI_CHARSET
        Font.Color = clGreen
        Font.Height = -16
        Font.Name = 'Default'
        Font.Pitch = fpVariable
        Font.Style = [fsBold]
        ParentFont = False
      end
      object btnYder: TSpeedButton
        Left = 120
        Top = 43
        Width = 23
        Height = 22
        Caption = '...'
        OnClick = btnYderClick
      end
      object eCprNr: TDBEdit
        Left = 56
        Top = 20
        Width = 80
        Height = 21
        TabStop = False
        Color = clSilver
        DataField = 'KundeNr'
        DataSource = MainDm.dsPatKar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object eNavn: TDBEdit
        Left = 139
        Top = 20
        Width = 160
        Height = 21
        TabStop = False
        Color = clSilver
        DataField = 'Navn'
        DataSource = MainDm.dsPatKar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
      object eGlCtrSaldo: TDBEdit
        Left = 468
        Top = 20
        Width = 98
        Height = 21
        TabStop = False
        Color = clLime
        DataField = 'GlCtrSaldo'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 14
      end
      object eCtrType: TDBEdit
        Left = 468
        Top = 92
        Width = 98
        Height = 21
        TabStop = False
        Color = clLime
        DataField = 'CtrType'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 17
      end
      object eDebitorNr: TDBEdit
        Tag = 1
        Left = 56
        Top = 68
        Width = 80
        Height = 21
        DataField = 'DebitorNr'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnEnter = eDebitorNrEnter
        OnExit = eDebitorNrExit
      end
      object eDebitorNavn: TDBEdit
        Left = 139
        Top = 68
        Width = 160
        Height = 21
        TabStop = False
        Color = clSilver
        DataField = 'DebitorNavn'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 7
      end
      object eYderNr: TDBEdit
        Left = 56
        Top = 44
        Width = 60
        Height = 21
        DataField = 'YderNr'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnEnter = eYderNrEnter
      end
      object eYderNavn: TDBEdit
        Left = 240
        Top = 44
        Width = 146
        Height = 21
        DataField = 'YderNavn'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
      object eCtrUdlign: TDBEdit
        Left = 468
        Top = 68
        Width = 98
        Height = 21
        TabStop = False
        Color = clLime
        DataField = 'CtrUdlign'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 16
      end
      object lcLevForm: TDBLookupComboBox
        Left = 56
        Top = 92
        Width = 100
        Height = 21
        DataField = 'LeveringsForm'
        DataSource = MainDm.dsEks
        DropDownRows = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        KeyField = 'Nr'
        ListField = 'Navn'
        ListSource = MainDm.dsLevFrm
        ParentFont = False
        ReadOnly = True
        TabOrder = 8
        OnDropDown = DropDown
      end
      object eNyCtrSaldo: TDBEdit
        Left = 468
        Top = 44
        Width = 98
        Height = 21
        TabStop = False
        Color = clLime
        DataField = 'NyCtrSaldo'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 15
      end
      object ePakkeNr: TDBEdit
        Left = 204
        Top = 92
        Width = 60
        Height = 21
        DataField = 'PakkeNr'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
      end
      object lcFakType: TDBComboBox
        Left = 468
        Top = 116
        Width = 98
        Height = 21
        Style = csDropDownList
        DataField = 'OrdreType'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Items.Strings = (
          'Salg'
          'Retur')
        ParentFont = False
        TabOrder = 18
        OnDropDown = DropDown
        OnExit = FakTypeExit
      end
      object eNarkoNr: TDBEdit
        Left = 317
        Top = 92
        Width = 70
        Height = 21
        DataField = 'NarkoNr'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 10
      end
      object eLevNr: TDBEdit
        Tag = 2
        Left = 56
        Top = 116
        Width = 80
        Height = 21
        DataField = 'LevNr'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 11
        OnEnter = eDebitorNrEnter
        OnExit = eDebitorNrExit
      end
      object eLevNavn: TDBEdit
        Left = 139
        Top = 116
        Width = 160
        Height = 21
        TabStop = False
        Color = clSilver
        DataField = 'LevNavn'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 12
      end
      object eTurNr: TDBEdit
        Left = 337
        Top = 116
        Width = 50
        Height = 21
        DataField = 'TurNr'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 13
        OnExit = eTurNrExit
      end
      object eDebitorTidl: TDBEdit
        Left = 302
        Top = 20
        Width = 60
        Height = 21
        TabStop = False
        Color = clSilver
        DataField = 'Kontakt'
        DataSource = MainDm.dsPatKar
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
      object eYderCPRNr: TDBComboBox
        Left = 152
        Top = 44
        Width = 89
        Height = 21
        DataField = 'YderCprNr'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnEnter = eYderCPRNrEnter
      end
    end
    object gbEksp: TGroupBox
      Left = 5
      Top = 2
      Width = 190
      Height = 83
      Caption = 'Ekspedition'
      TabOrder = 0
      TabStop = True
      object Label1: TLabel
        Left = 9
        Top = 23
        Width = 32
        Height = 16
        Caption = '&Type'
        FocusControl = lcbEkspType
      end
      object Label2: TLabel
        Left = 10
        Top = 50
        Width = 31
        Height = 16
        Caption = '&Form'
        FocusControl = lcbEkspForm
      end
      object lcbEkspType: TDBComboBox
        Left = 46
        Top = 20
        Width = 138
        Height = 24
        Hint = 'V'#230'lg ekspeditionstype '
        Style = csDropDownList
        DataField = 'EkspType'
        DataSource = MainDm.dsEks
        DropDownCount = 7
        Items.Strings = (
          'Recepter'
          'Vagtbrug m.m.'
          'Leverancer'
          'H'#229'ndk'#248'b'
          'Dyr'
          'Narkoleverance'
          'Dosispakning')
        TabOrder = 0
        OnDropDown = DropDown
      end
      object lcbEkspForm: TDBComboBox
        Left = 46
        Top = 48
        Width = 138
        Height = 24
        Hint = 'V'#230'lg ekspeditionsform'
        Style = csDropDownList
        DataField = 'EkspForm'
        DataSource = MainDm.dsEks
        DropDownCount = 7
        Items.Strings = (
          'Andet'
          'Recept'
          'Telefonrecept'
          'EDB-recept'
          'Narkocheck')
        TabOrder = 1
        OnDropDown = DropDown
        OnExit = EkspFormExit
      end
    end
    object gbAfslut: TGroupBox
      Left = 5
      Top = 85
      Width = 190
      Height = 60
      Caption = 'Afslutning'
      TabOrder = 1
      object buGem: TButton
        Left = 12
        Top = 23
        Width = 75
        Height = 25
        Caption = 'Afslut [F6]'
        TabOrder = 0
        TabStop = False
        OnClick = buGemClick
      end
      object buLuk: TButton
        Left = 104
        Top = 23
        Width = 75
        Height = 25
        Caption = 'L&uk'
        TabOrder = 1
        TabStop = False
        OnClick = buLukClick
      end
    end
  end
  object paBund: TPanel
    Left = 0
    Top = 380
    Width = 780
    Height = 153
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    DesignSize = (
      780
      153)
    object Label5: TLabel
      Left = 144
      Top = 13
      Width = 29
      Height = 16
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = '&Vare'
      FocusControl = EVare
    end
    object laMax: TLabel
      Left = 233
      Top = 41
      Width = 25
      Height = 16
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Max'
    end
    object Label7: TLabel
      Left = 143
      Top = 41
      Width = 30
      Height = 16
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Ant&al'
      FocusControl = EAntal
    end
    object laUdlev: TLabel
      Left = 307
      Top = 41
      Width = 36
      Height = 16
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Udlev'
    end
    object Label8: TLabel
      Left = 148
      Top = 69
      Width = 25
      Height = 16
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'D&os'
      FocusControl = cbDosTekst
    end
    object Label9: TLabel
      Left = 145
      Top = 97
      Width = 28
      Height = 16
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = '&Indik'
      FocusControl = cbIndikation
    end
    object Label14: TLabel
      Left = 376
      Top = 0
      Width = 37
      Height = 33
      AutoSize = False
      Caption = '&E'
      FocusControl = meEtiketter
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnFace
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label15: TLabel
      Left = 0
      Top = 0
      Width = 37
      Height = 33
      AutoSize = False
      Caption = '&L'
      FocusControl = buVidere
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnFace
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object cbIndikation: TComboBox
      Left = 176
      Top = 96
      Width = 201
      Height = 24
      Hint = 'V'#230'lg indikation for brugsanvisning'
      AutoComplete = False
      Anchors = [akLeft, akBottom]
      DropDownCount = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
      OnEnter = cbIndikationEnter
      OnExit = cbIndikationExit
      OnKeyDown = cbIndikationKeyDown
      Items.Strings = (
        '1. Indikation nr. 1'
        '2. Indikation nr. 2'
        '3. Indikation nr. 3')
    end
    object EVare: TEdit
      Left = 176
      Top = 9
      Width = 165
      Height = 24
      Hint = 'Tast varenr, stregkode eller s'#248'gekriterie (navn,pakning,form)'
      Anchors = [akLeft, akBottom]
      TabOrder = 5
    end
    object EMax: TDBEdit
      Left = 261
      Top = 37
      Width = 30
      Height = 24
      Hint = 'Tast max udleveringer ved reiterering'
      Anchors = [akLeft, akBottom]
      DataField = 'UdlevMax'
      DataSource = MainDm.dsLin
      TabOrder = 8
    end
    object EUdlev: TDBEdit
      Left = 346
      Top = 37
      Width = 30
      Height = 24
      Hint = 'Tast aktuelt udleveringsnr'
      Anchors = [akLeft, akBottom]
      DataField = 'UdlevNr'
      DataSource = MainDm.dsLin
      TabOrder = 9
    end
    object EAntal: TEdit
      Left = 176
      Top = 37
      Width = 30
      Height = 24
      Hint = 'Antal pakninger'
      Anchors = [akLeft, akBottom]
      TabOrder = 7
    end
    object grCTR: TGroupBox
      Left = 661
      Top = 2
      Width = 114
      Height = 115
      Anchors = [akRight, akBottom]
      Caption = 'CTR linietotaler'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
      object Label19: TLabel
        Left = 10
        Top = 24
        Width = 22
        Height = 13
        Alignment = taRightJustify
        Caption = 'BGP'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label20: TLabel
        Left = 15
        Top = 52
        Width = 17
        Height = 13
        Alignment = taRightJustify
        Caption = 'IBT'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label25: TLabel
        Left = 5
        Top = 80
        Width = 27
        Height = 13
        Alignment = taRightJustify
        Caption = 'Saldo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object EIBTBel: TDBEdit
        Left = 35
        Top = 48
        Width = 70
        Height = 21
        TabStop = False
        DataField = 'IBTBel'
        DataSource = MainDm.dsLin
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
      object EBGPBel: TDBEdit
        Left = 35
        Top = 20
        Width = 70
        Height = 21
        TabStop = False
        DataField = 'BGPBel'
        DataSource = MainDm.dsLin
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object ELinSaldo: TDBEdit
        Left = 35
        Top = 76
        Width = 70
        Height = 21
        TabStop = False
        DataField = 'NySaldo'
        DataSource = MainDm.dsLin
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
    end
    object cbSubst: TComboBox
      Tag = 200
      Left = 346
      Top = 9
      Width = 30
      Height = 24
      Hint = 'V'#230'lg receptens markerede substitutioner'
      Style = csDropDownList
      Anchors = [akLeft, akBottom]
      DropDownCount = 5
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnEnter = cbSubstEnter
      OnExit = cbSubstExit
      Items.Strings = (
        'Recept er IKKE markeret'
        'Recept markeret -S'
        'Kunde'#248'nske')
    end
    object EDos2: TEdit
      Left = 276
      Top = 65
      Width = 100
      Height = 24
      Hint = 'Tast doseringskode eller tekstkode'
      Anchors = [akLeft, akBottom]
      TabOrder = 11
    end
    object buVidere: TButton
      Left = 5
      Top = 7
      Width = 52
      Height = 24
      Hint = 'Tryk ENTER eller F6 for afslut'
      Anchors = [akLeft, akBottom]
      Caption = 'Ny &linie'
      TabOrder = 0
      OnClick = buVidereClick
      OnEnter = buVidereEnter
      OnKeyDown = buVidereKeyDown
    end
    object lcArt: TDBLookupComboBox
      Left = 6
      Top = 37
      Width = 135
      Height = 24
      Hint = 'V'#230'lg dyreart'
      Anchors = [akLeft, akBottom]
      DataField = 'DyreArt'
      DataSource = MainDm.dsLin
      DropDownWidth = 250
      KeyField = 'Nr'
      ListField = 'Nr;Navn'
      ListFieldIndex = 1
      ListSource = MainDm.dsDyrArt
      TabOrder = 2
      OnDropDown = DropDown
      OnExit = lcArtExit
    end
    object lcAlder: TDBLookupComboBox
      Left = 6
      Top = 65
      Width = 135
      Height = 24
      Hint = 'V'#230'lg aldersgruppe'
      Anchors = [akLeft, akBottom]
      DataField = 'AldersGrp'
      DataSource = MainDm.dsLin
      DropDownWidth = 250
      KeyField = 'Nr'
      ListField = 'Nr;Navn'
      ListFieldIndex = 1
      ListSource = MainDm.dsDyrAld
      TabOrder = 3
      OnDropDown = DropDown
    end
    object lcOrd: TDBLookupComboBox
      Left = 6
      Top = 93
      Width = 135
      Height = 24
      Hint = 'V'#230'lg ordinationsgruppe'
      Anchors = [akLeft, akBottom]
      DataField = 'OrdGrp'
      DataSource = MainDm.dsLin
      DropDownWidth = 250
      KeyField = 'Nr'
      ListField = 'Nr;Navn'
      ListFieldIndex = 1
      ListSource = MainDm.dsDyrOrd
      TabOrder = 4
      OnDropDown = DropDown
    end
    object lcbLinTyp: TDBComboBox
      Left = 63
      Top = 8
      Width = 78
      Height = 24
      Hint = 'V'#230'lg linietype for vare'
      Style = csDropDownList
      Anchors = [akLeft, akBottom]
      DataField = 'LinieType'
      DataSource = MainDm.dsLin
      DropDownCount = 2
      Items.Strings = (
        'Recept'
        'H'#229'ndk'#248'b')
      TabOrder = 1
      OnDropDown = DropDown
    end
    object meEtiketter: TMemo
      Tag = 276
      Left = 392
      Top = 8
      Width = 250
      Height = 113
      TabStop = False
      Anchors = [akLeft, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'dette er en testlinie som fylder '
        'det antal '
        'karakterer pr. linie man m'#229
        ''
        '12345678901234567890123456789012'
        '3456')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 14
    end
    object cbDosTekst: TComboBox
      Left = 176
      Top = 65
      Width = 100
      Height = 24
      AutoComplete = False
      TabOrder = 10
      OnEnter = cbDosTekstEnter
      OnExit = cbDosTekstExit
      OnKeyDown = cbDosTekstKeyDown
    end
    object Panel1: TPanel
      Left = 0
      Top = 123
      Width = 780
      Height = 30
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 15
      DesignSize = (
        780
        30)
      object btnVis: TSpeedButton
        Left = 711
        Top = 1
        Width = 68
        Height = 25
        Action = acVisRCP
        Anchors = [akTop, akRight]
        ExplicitLeft = 696
      end
      object paLager: TPanel
        Left = 6
        Top = 1
        Width = 135
        Height = 25
        Alignment = taLeftJustify
        Anchors = [akLeft, akBottom]
        BevelOuter = bvLowered
        TabOrder = 0
      end
      object paInfo: TPanel
        Left = 183
        Top = 1
        Width = 523
        Height = 25
        Alignment = taLeftJustify
        Anchors = [akRight, akBottom]
        BevelOuter = bvLowered
        TabOrder = 1
      end
    end
  end
  object paLinier: TPanel
    Left = 0
    Top = 153
    Width = 780
    Height = 227
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object grLinier: TDBGrid
      Left = 0
      Top = 0
      Width = 780
      Height = 227
      Align = alClient
      DataSource = MainDm.dsLin
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
  end
  object ActionList1: TActionList
    Left = 488
    Top = 168
    object acVisRCP: TAction
      Caption = 'Vis [F5]'
      ShortCut = 116
      OnExecute = acVisRCPExecute
    end
    object acLager0: TAction
      Caption = 'acLager0'
      ShortCut = 16432
      OnExecute = acLager0Execute
    end
    object acLager1: TAction
      Caption = 'acLager1'
      ShortCut = 16433
      OnExecute = acLager1Execute
    end
    object acLager2: TAction
      Caption = 'acLager2'
      ShortCut = 16434
      OnExecute = acLager2Execute
    end
    object acLager3: TAction
      Caption = 'acLager3'
      ShortCut = 16435
      OnExecute = acLager3Execute
    end
    object acLager4: TAction
      Caption = 'acLager4'
      ShortCut = 16436
      OnExecute = acLager4Execute
    end
    object acLager5: TAction
      Caption = 'acLager5'
      ShortCut = 16437
      OnExecute = acLager5Execute
    end
  end
end
