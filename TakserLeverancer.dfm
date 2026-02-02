object LeveranceForm: TLeveranceForm
  Left = 33
  Top = 29
  BorderIcons = [biMaximize]
  BorderStyle = bsSingle
  Caption = 'Taksering af leverancer'
  ClientHeight = 517
  ClientWidth = 780
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
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
      object Label10: TLabel
        Left = 13
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
        Left = 22
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
        Left = 10
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
        Top = 96
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
      object Label23: TLabel
        Left = 12
        Top = 96
        Width = 41
        Height = 13
        Alignment = taRightJustify
        Caption = 'Lev.for&m'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblMomsType0: TLabel
        Left = 305
        Top = 69
        Width = 103
        Height = 16
        Caption = 'lblMomsType0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object eCprNr: TDBEdit
        Left = 56
        Top = 20
        Width = 100
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
        Left = 159
        Top = 20
        Width = 180
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
      object eDebitorNr: TDBEdit
        Left = 56
        Top = 68
        Width = 60
        Height = 21
        DataField = 'DebitorNr'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnEnter = eDebitorNrEnter
        OnExit = eDebitorNrExit
      end
      object eDebitorNavn: TDBEdit
        Left = 119
        Top = 68
        Width = 180
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
        TabOrder = 5
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
        TabOrder = 2
      end
      object eYderNavn: TDBEdit
        Left = 119
        Top = 44
        Width = 180
        Height = 21
        DataField = 'YderNavn'
        DataSource = MainDm.dsEks
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object lcFakType: TDBComboBox
        Left = 468
        Top = 92
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
        TabOrder = 7
        OnDropDown = DropDown
        OnExit = FakTypeExit
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
        ParentFont = False
        TabOrder = 6
        OnDropDown = DropDown
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
      end
      object Label2: TLabel
        Left = 10
        Top = 50
        Width = 31
        Height = 16
        Caption = '&Form'
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
        OnEnter = EkspTypeEnter
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
    Top = 364
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
      Left = 146
      Top = 13
      Width = 29
      Height = 16
      Alignment = taRightJustify
      Caption = '&Vare'
      FocusControl = EVare
    end
    object Label7: TLabel
      Left = 145
      Top = 97
      Width = 30
      Height = 16
      Alignment = taRightJustify
      Caption = 'Ant&al'
      FocusControl = EAntal
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
    object Label3: TLabel
      Left = 152
      Top = 41
      Width = 23
      Height = 16
      Alignment = taRightJustify
      Caption = 'Pris'
    end
    object Label4: TLabel
      Left = 141
      Top = 69
      Width = 34
      Height = 16
      Alignment = taRightJustify
      Caption = 'Tekst'
    end
    object EVare: TEdit
      Left = 178
      Top = 9
      Width = 165
      Height = 24
      Hint = 'Tast varenr, stregkode eller s'#248'gekriterie (navn,pakning,form)'
      TabOrder = 2
    end
    object EAntal: TEdit
      Left = 178
      Top = 93
      Width = 30
      Height = 24
      Hint = 'Antal pakninger'
      TabOrder = 5
    end
    object buVidere: TButton
      Left = 6
      Top = 9
      Width = 52
      Height = 24
      Hint = 'Tryk ENTER eller F6 for afslut'
      Caption = 'Ny &linie'
      TabOrder = 0
      OnClick = buVidereClick
      OnEnter = buVidereEnter
      OnExit = buVidereExit
      OnKeyDown = buVidereKeyDown
    end
    object DBEPris: TDBEdit
      Left = 178
      Top = 37
      Width = 165
      Height = 24
      DataField = 'Pris'
      DataSource = MainDm.dsLin
      TabOrder = 3
    end
    object DBETekst: TDBEdit
      Left = 178
      Top = 65
      Width = 300
      Height = 24
      DataField = 'Tekst'
      DataSource = MainDm.dsLin
      TabOrder = 4
    end
    object paLager: TPanel
      Left = 6
      Top = 124
      Width = 135
      Height = 25
      Alignment = taLeftJustify
      Anchors = [akLeft, akBottom]
      BevelOuter = bvLowered
      TabOrder = 6
    end
    object paInfo: TPanel
      Left = 178
      Top = 124
      Width = 597
      Height = 25
      Alignment = taLeftJustify
      Anchors = [akRight, akBottom]
      BevelOuter = bvLowered
      TabOrder = 7
    end
    object lcbLinTyp: TDBComboBox
      Left = 63
      Top = 8
      Width = 78
      Height = 24
      Hint = 'V'#230'lg linietype for vare'
      Style = csDropDownList
      DataField = 'LinieType'
      DataSource = MainDm.dsLin
      DropDownCount = 3
      Items.Strings = (
        'Recept'
        'H'#229'ndk'#248'b')
      TabOrder = 1
      OnDropDown = DropDown
    end
  end
  object paLinier: TPanel
    Left = 0
    Top = 153
    Width = 780
    Height = 211
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object grLinier: TDBGrid
      Left = 0
      Top = 0
      Width = 780
      Height = 211
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
