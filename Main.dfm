object StamForm: TStamForm
  Left = 266
  Top = 88
  Caption = 'Patientkartotek'
  ClientHeight = 531
  ClientWidth = 804
  Color = clBtnFace
  Constraints.MinHeight = 570
  Constraints.MinWidth = 820
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  HelpFile = 'C2Help.Hlp'
  Icon.Data = {
    0000010001002020040000000000E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000111111111111110000000000000000
    0199999999999991100000000000000011999999999999991000000000000001
    9999999999999999101100000000000119999999999999911011100000000001
    1111111111111111001111000000000011111111111111110001111000000000
    0000000000000000000011110000000000008888888888880008111110000000
    8008777777777778808780111100000080087FFFFFFFFFF78087800111000000
    00087FFFFFFFFFF7808780001100000000087FFFF77777780087800111000000
    00087FF778888880008780878000000000087778888000000877808F80000000
    000088800887777777F7808F8000000000000000087FFF777777808F80000000
    0000000087FF78888888008F8000000000000008777788000000008F80000000
    00000000888808888888877F80000000000000000000087FFFF7777780000000
    00000000000087FF78888888000000000000000000007FF78800000000000000
    0000000000008888800000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFC0003FFFC0003FFF00000FFF00000FFC000003FC000003F0000
    000F0000000F0000000300000003C0000000C0000000F0000000F0000000FC00
    0000FC000000FF000000FF000000FFC00003FFC00003FFF00003FFF00003FFFC
    0003FFFC0003FFFF03FFFFFF03FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = KeyHandler
  OnKeyPress = FormKeyPress
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StamPages: TcxPageControl
    Left = 0
    Top = 42
    Width = 804
    Height = 459
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TabStop = False
    Properties.ActivePage = tsEHandel
    Properties.CustomButtons.Buttons = <>
    Properties.TabHeight = 25
    OnEnter = StamPagesEnter
    OnPageChanging = StamPagesPageChanging
    ClientRectBottom = 455
    ClientRectLeft = 4
    ClientRectRight = 800
    ClientRectTop = 31
    object KartotekPage: TcxTabSheet
      Caption = 'Kartotek [CF1]'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnEnter = KartotekPageEnter
      OnExit = KartotekPageExit
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object KartEditPanel: TPanel
        Left = 0
        Top = 0
        Width = 796
        Height = 424
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Panel6: TPanel
          Left = 0
          Top = 0
          Width = 321
          Height = 424
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object pnlTopleft: TPanel
            Left = 0
            Top = 0
            Width = 321
            Height = 433
            Align = alTop
            BevelEdges = []
            BevelOuter = bvNone
            TabOrder = 0
            object gbUdst: TGroupBox
              Left = 8
              Top = 352
              Width = 310
              Height = 75
              Caption = 'Udsteder (l'#230'ge)'
              TabOrder = 2
              object KartLYderNr: TLabel
                Left = 186
                Top = 23
                Width = 31
                Height = 13
                Alignment = taRightJustify
                Caption = '&Ydernr'
                FocusControl = EYderNr
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object sbYderNr: TSpeedButton
                Tag = 6
                Left = 274
                Top = 20
                Width = 24
                Height = 21
                Hint = 'S'#248'g efter l'#230'ge (Alt + Pil Ned)'
                Caption = '...'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                OnClick = sbClick
              end
              object Label1: TLabel
                Left = 37
                Top = 23
                Width = 28
                Height = 13
                Alignment = taRightJustify
                Caption = 'A&ut.nr'
                FocusControl = EYderCprNr
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label25: TLabel
                Left = 19
                Top = 47
                Width = 46
                Height = 13
                Alignment = taRightJustify
                Caption = 'Ydernavn'
                FocusControl = EYderNr
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object EYderNr: TDBEdit
                Left = 222
                Top = 20
                Width = 50
                Height = 21
                Hint = 'L'#230'gens ydernummer'
                DataField = 'YderNr'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 1
              end
              object EYderCprNr: TDBEdit
                Left = 70
                Top = 20
                Width = 110
                Height = 21
                Hint = 'L'#230'gens Aut.nr'
                DataField = 'YderCprNr'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 0
                OnKeyPress = EYderCprNrKeyPress
              end
              object EYdNavn: TDBEdit
                Left = 70
                Top = 44
                Width = 230
                Height = 21
                TabStop = False
                Color = clSilver
                DataField = 'LuYdNavn'
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
            end
            object gbNavn: TGroupBox
              Left = 8
              Top = 127
              Width = 310
              Height = 224
              Caption = 'Navn, adresse og forsendelse'
              TabOrder = 1
              object KartLAdr1: TLabel
                Left = 23
                Top = 48
                Width = 42
                Height = 13
                Alignment = taRightJustify
                Caption = 'Vej og nr'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object KartLPostNr: TLabel
                Left = 35
                Top = 96
                Width = 30
                Height = 13
                Alignment = taRightJustify
                Caption = '&Postnr'
                FocusControl = EPostNr
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object sbPostNr: TSpeedButton
                Tag = 3
                Left = 122
                Top = 92
                Width = 24
                Height = 21
                Hint = 'S'#248'g efter postnr (Alt + Pil Ned)'
                Caption = '...'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                OnClick = sbClick
              end
              object KartLTlfNr: TLabel
                Left = 29
                Top = 120
                Width = 36
                Height = 13
                Alignment = taRightJustify
                Caption = 'Telefon'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object KartLNavn: TLabel
                Left = 39
                Top = 24
                Width = 26
                Height = 13
                Alignment = taRightJustify
                Caption = 'Na&vn'
                FocusControl = ENavn
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label7: TLabel
                Left = 43
                Top = 72
                Width = 22
                Height = 13
                Alignment = taRightJustify
                Caption = 'Sted'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object KartLDebNr: TLabel
                Left = 22
                Top = 144
                Width = 43
                Height = 13
                Alignment = taRightJustify
                Caption = '&Debitornr'
                FocusControl = EDebNr
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object sbDebNr: TSpeedButton
                Tag = 4
                Left = 150
                Top = 140
                Width = 24
                Height = 21
                Hint = 'S'#248'g efter debitor (Alt + Pil Ned)'
                Caption = '...'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                OnClick = sbClick
              end
              object KartLDebSaldo: TLabel
                Left = 38
                Top = 168
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
              object Label41: TLabel
                Left = 35
                Top = 191
                Width = 30
                Height = 13
                Alignment = taRightJustify
                Caption = '&Lev.nr'
                FocusControl = ELevNr
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object sbLevNr: TSpeedButton
                Tag = 5
                Left = 150
                Top = 188
                Width = 24
                Height = 21
                Hint = 'S'#248'g efter pakkeenhed (Alt + Pil Ned)'
                Caption = '...'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                OnClick = sbClick
              end
              object dbtPBS: TDBText
                Left = 176
                Top = 164
                Width = 59
                Height = 19
                AutoSize = True
                DataField = 'LuPbs'
                DataSource = MainDm.dsPatKar
                Font.Charset = ANSI_CHARSET
                Font.Color = clGreen
                Font.Height = -16
                Font.Name = 'Default'
                Font.Pitch = fpVariable
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label65: TLabel
                Left = 150
                Top = 119
                Width = 25
                Height = 13
                Caption = 'M&obil'
                FocusControl = eMobil
              end
              object lblMomsType: TLabel
                Left = 176
                Top = 164
                Width = 84
                Height = 20
                Caption = 'MOMSFRI'
                Font.Charset = ANSI_CHARSET
                Font.Color = clRed
                Font.Height = -16
                Font.Name = 'MS Sans Serif'
                Font.Pitch = fpVariable
                Font.Style = [fsBold]
                ParentFont = False
              end
              object btnSMS: TButton
                Left = 259
                Top = 115
                Width = 39
                Height = 22
                Action = acSendSMS
                Caption = '&SMS'
                TabOrder = 12
                TabStop = False
              end
              object EAdr1: TDBEdit
                Left = 70
                Top = 44
                Width = 230
                Height = 21
                Hint = 'Vej og nr i adresse'
                DataField = 'Adr1'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 1
              end
              object EAdr2: TDBEdit
                Left = 70
                Top = 68
                Width = 230
                Height = 21
                Hint = 'Sted i adresse'
                DataField = 'Adr2'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 2
              end
              object EPostNr: TDBEdit
                Left = 70
                Top = 92
                Width = 50
                Height = 21
                Hint = 'Postnr fra tabel [Alt+Pil-Ned]'
                DataField = 'PostNr'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                MaxLength = 30
                ParentFont = False
                TabOrder = 3
              end
              object EBy: TDBEdit
                Left = 148
                Top = 92
                Width = 152
                Height = 21
                TabStop = False
                Color = clSilver
                DataField = 'By'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                ReadOnly = True
                TabOrder = 4
              end
              object ETlfNr: TDBEdit
                Left = 70
                Top = 115
                Width = 72
                Height = 21
                Hint = 'Telefonnr hos kunde'
                DataField = 'TlfNr'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 5
              end
              object ENavn: TDBEdit
                Left = 70
                Top = 20
                Width = 230
                Height = 21
                Hint = 'Navn p'#229' kunde'
                DataField = 'Navn'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 0
              end
              object EDebNavn: TDBEdit
                Left = 176
                Top = 140
                Width = 124
                Height = 21
                TabStop = False
                Color = clSilver
                DataField = 'LuDebNavn'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                ReadOnly = True
                TabOrder = 8
              end
              object EDebNr: TDBEdit
                Left = 70
                Top = 140
                Width = 78
                Height = 21
                Hint = 'Debitorkonto for debitering og forsendelse (fra DOS)'
                DataField = 'DebitorNr'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 7
              end
              object EDebSaldo: TDBEdit
                Left = 70
                Top = 164
                Width = 105
                Height = 21
                TabStop = False
                Color = clSilver
                DataField = 'LukDebSaldo'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                ReadOnly = True
                TabOrder = 9
              end
              object ELevNr: TDBEdit
                Left = 70
                Top = 188
                Width = 78
                Height = 21
                Hint = 'Debitorkonto for debitering og forsendelse (fra DOS)'
                DataField = 'LevNr'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 10
              end
              object ELevNavn: TDBEdit
                Left = 176
                Top = 188
                Width = 124
                Height = 21
                TabStop = False
                Color = clSilver
                DataField = 'LuLevNavn'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                ReadOnly = True
                TabOrder = 11
              end
              object eMobil: TDBEdit
                Left = 181
                Top = 116
                Width = 72
                Height = 21
                DataField = 'Mobil'
                DataSource = MainDm.dsPatKar
                TabOrder = 6
              end
            end
            object gbIdent: TGroupBox
              Left = 8
              Top = -1
              Width = 310
              Height = 122
              Align = alCustom
              Caption = 'Kundeoplysninger'
              TabOrder = 0
              object KartLKontoNr: TLabel
                Left = 26
                Top = 23
                Width = 39
                Height = 13
                Alignment = taRightJustify
                Caption = '&Nummer'
                FocusControl = EKundeNr
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object sbCprNr: TSpeedButton
                Tag = 1
                Left = 185
                Top = 20
                Width = 24
                Height = 21
                Hint = 'S'#248'g efter patient (Alt + Pil Ned)'
                Caption = '...'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                Layout = blGlyphRight
                ParentFont = False
                OnClick = sbClick
              end
              object Label19: TLabel
                Left = 14
                Top = 47
                Width = 51
                Height = 13
                Alignment = taRightJustify
                Caption = 'Kundetype'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label4: TLabel
                Left = 186
                Top = 71
                Width = 42
                Height = 13
                Alignment = taRightJustify
                Caption = 'F'#248'd.dato'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label2: TLabel
                Left = 33
                Top = 71
                Width = 33
                Height = 13
                Alignment = taRightJustify
                Caption = 'Lms-ID'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label5: TLabel
                Left = 11
                Top = 95
                Width = 54
                Height = 13
                Alignment = taRightJustify
                Caption = 'Landekode'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object ECprChk: TDBCheckBox
                Left = 220
                Top = 47
                Width = 79
                Height = 17
                Hint = 'Cprnr check (modulus 11) foretages'
                Alignment = taLeftJustify
                Caption = 'Cprnr.check'
                DataField = 'CprCheck'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 3
              end
              object EFiktiv: TDBCheckBox
                Left = 223
                Top = 23
                Width = 76
                Height = 17
                Hint = 'Markering ved fiktivt cprnr'
                Alignment = taLeftJustify
                Caption = 'Fiktivt cprnr'
                DataField = 'FiktivtCprNr'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 1
                OnExit = EFiktivExit
              end
              object EDato: TDBEdit
                Left = 233
                Top = 68
                Width = 66
                Height = 21
                Hint = 'F'#248'dseldsdato ved fiktivt cprnr'
                DataField = 'FoedDato'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 5
              end
              object EBarn: TDBCheckBox
                Left = 255
                Top = 95
                Width = 44
                Height = 17
                Hint = 'Markering for barn'
                TabStop = False
                Alignment = taLeftJustify
                Caption = '&Barn'
                DataField = 'Barn'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 7
                Visible = False
              end
              object EModtager: TDBEdit
                Left = 70
                Top = 68
                Width = 100
                Height = 21
                Hint = 'Lmskode for modtager'
                DataField = 'LmsModtager'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 4
              end
              object EKundeNr: TEdit
                Left = 71
                Top = 20
                Width = 112
                Height = 21
                Hint = 'Kundenr (cprnr p'#229' enkeltpersoner)'
                TabOrder = 0
                OnKeyPress = EKundeNrKeyPress
              end
              object ECtrLand: TDBLookupComboBox
                Left = 70
                Top = 92
                Width = 140
                Height = 21
                Hint = 'Landekode ved fiktivt cprnr'
                DataField = 'Landekode'
                DataSource = MainDm.dsPatKar
                KeyField = 'Nr'
                ListField = 'Navn'
                ListFieldIndex = 1
                ListSource = MainDm.dsCtrLan
                TabOrder = 6
                OnDropDown = DropDown
              end
              object EKundeType: TDBComboBox
                Left = 70
                Top = 44
                Width = 140
                Height = 21
                Style = csDropDownList
                DataField = 'KundeType'
                DataSource = MainDm.dsPatKar
                Items.Strings = (
                  'Ingen'
                  'Enkeltperson'
                  'L'#230'ge'
                  'Dyrl'#230'ge'
                  'Tandl'#230'ge'
                  'Forsvaret'
                  'F'#230'ngsel/Arresthus'
                  'Asylcenter'
                  'Jordemor'
                  'Hjemmesygeplejerske'
                  'Skibsf'#248'rer/Reder'
                  'Sygehus'
                  'Plejehjem'
                  'Hobbydyr'
                  'Landmand (erhvervsdyr)'
                  'H'#229'ndk'#248'bsudsalg'
                  'Andet apotek'
                  'Institutioner'
                  'Asylans'#248'ger')
                TabOrder = 2
                OnDropDown = DropDown
                OnEnter = EKundeTypeEnter
                OnExit = EKundeTypeExit
              end
            end
          end
          object pnlBtnLeft: TPanel
            Left = 0
            Top = 433
            Width = 321
            Height = 209
            Align = alClient
            TabOrder = 1
            Visible = False
            object gbDosis: TGroupBox
              Left = 8
              Top = 2
              Width = 307
              Height = 159
              Align = alCustom
              Caption = 'Dosiskort'
              TabOrder = 0
              object btnUdsDosiskort: TButton
                Left = 14
                Top = 121
                Width = 128
                Height = 25
                Action = acVisDDKort
                TabOrder = 0
              end
              object cxGridDDCards: TcxGrid
                AlignWithMargins = True
                Left = 5
                Top = 18
                Width = 297
                Height = 97
                Align = alTop
                TabOrder = 1
                object cxGridDDCardsTableView1: TcxGridTableView
                  Navigator.Buttons.CustomButtons = <>
                  ScrollbarAnnotations.CustomAnnotations = <>
                  OnCustomDrawCell = cxGridDDCardsTableView1CustomDrawCell
                  DataController.Summary.DefaultGroupSummaryItems = <>
                  DataController.Summary.FooterSummaryItems = <>
                  DataController.Summary.SummaryGroups = <>
                  OptionsCustomize.ColumnGrouping = False
                  OptionsCustomize.ColumnMoving = False
                  OptionsData.Deleting = False
                  OptionsData.Editing = False
                  OptionsData.Inserting = False
                  OptionsSelection.CellSelect = False
                  OptionsView.CellEndEllipsis = True
                  OptionsView.GridLines = glNone
                  OptionsView.GroupByBox = False
                  object cxGridDDCardsTableView1Column1: TcxGridColumn
                    Caption = 'Kort'
                    Width = 100
                  end
                  object cxGridDDCardsTableView1Column3: TcxGridColumn
                    Caption = 'Udleveringsapotek'
                    Width = 113
                  end
                  object cxGridDDCardsTableView1Column4: TcxGridColumn
                    Caption = 'Pakkegruppe'
                    Width = 79
                  end
                  object cxGridDDCardsTableView1Column2: TcxGridColumn
                    Caption = 'I bero'
                    PropertiesClassName = 'TcxCheckBoxProperties'
                    Visible = False
                    VisibleForEditForm = bTrue
                    Width = 48
                  end
                end
                object cxGridDDCardsLevel1: TcxGridLevel
                  GridView = cxGridDDCardsTableView1
                end
              end
            end
          end
        end
        object Panel7: TPanel
          Left = 321
          Top = 0
          Width = 475
          Height = 424
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object EBem: TDBMemo
            Left = 0
            Top = 313
            Width = 475
            Height = 111
            Hint = 'Vigtige bem'#230'rkninger'
            Align = alClient
            DataField = 'VigtigBem'
            DataSource = MainDm.dsPatKar
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 1
          end
          object Panel8: TPanel
            Left = 0
            Top = 0
            Width = 475
            Height = 145
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 2
            object DBGrid2: TDBGrid
              Left = 0
              Top = 0
              Width = 475
              Height = 145
              TabStop = False
              Align = alClient
              DataSource = MainDm.dsPatTil
              Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'MS Sans Serif'
              TitleFont.Style = []
            end
          end
          object Panel9: TPanel
            Left = 0
            Top = 145
            Width = 475
            Height = 168
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            DesignSize = (
              475
              168)
            object Label30: TLabel
              Left = 8
              Top = 8
              Width = 7
              Height = 13
              Caption = '&B'
              FocusControl = EBem
              Visible = False
            end
            object gbInstans: TGroupBox
              Left = 13
              Top = 22
              Width = 258
              Height = 146
              Caption = 'Instanser, danmark m.m.'
              TabOrder = 1
              object Label22: TLabel
                Left = 18
                Top = 23
                Width = 47
                Height = 13
                Alignment = taRightJustify
                Caption = '&Kommune'
                FocusControl = EKommune
              end
              object sbKommune: TSpeedButton
                Tag = 2
                Left = 112
                Top = 20
                Width = 24
                Height = 21
                Hint = 'S'#248'g efter instans (Alt + Pil Ned)'
                Caption = '...'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = [fsBold]
                ParentFont = False
                OnClick = sbClick
              end
              object Label24: TLabel
                Left = 170
                Top = 23
                Width = 34
                Height = 13
                Alignment = taRightJustify
                Caption = 'Region'
                FocusControl = EAmt
              end
              object KartLDKMedlem: TLabel
                Left = 93
                Top = 72
                Width = 43
                Height = 13
                Alignment = taRightJustify
                Caption = 'D&anmark'
                FocusControl = EDanmark
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object KartLOpretDato: TLabel
                Left = 98
                Top = 119
                Width = 38
                Height = 13
                Alignment = taRightJustify
                Caption = 'Oprettet'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object KartLRetDato: TLabel
                Left = 107
                Top = 95
                Width = 29
                Height = 13
                Alignment = taRightJustify
                Caption = 'Rettet'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label29: TLabel
                Left = 7
                Top = 48
                Width = 58
                Height = 13
                Alignment = taRightJustify
                Caption = 'Instansnavn'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object EAmt: TDBEdit
                Left = 209
                Top = 20
                Width = 40
                Height = 21
                Hint = 'Personens bop'#230'lsamt'
                DataField = 'Amt'
                DataSource = MainDm.dsPatKar
                TabOrder = 1
              end
              object EKommune: TDBEdit
                Left = 70
                Top = 20
                Width = 40
                Height = 21
                Hint = 'Personens bop'#230'lskommune'
                DataField = 'Kommune'
                DataSource = MainDm.dsPatKar
                TabOrder = 0
              end
              object ENetto: TDBCheckBox
                Left = 12
                Top = 71
                Width = 71
                Height = 17
                Hint = 'Nettopriser fra Lms taksten'
                Alignment = taLeftJustify
                Caption = 'Nettopriser'
                DataField = 'NettoPriser'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 3
              end
              object EjSubst: TDBCheckBox
                Left = 24
                Top = 119
                Width = 59
                Height = 17
                Hint = 'Markering ved original pr'#230'parater'
                Alignment = taLeftJustify
                Caption = 'Ej subst.'
                DataField = 'EjSubstitution'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 6
              end
              object EKomNavn: TDBEdit
                Left = 70
                Top = 44
                Width = 180
                Height = 21
                TabStop = False
                Color = clSilver
                DataField = 'Instans'
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
              object EOpretDato: TDBEdit
                Left = 140
                Top = 116
                Width = 70
                Height = 21
                Hint = 'Oprettelsesdato'
                TabStop = False
                Color = clSilver
                DataField = 'OpretDato'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                MaxLength = 30
                ParentFont = False
                ReadOnly = True
                TabOrder = 8
              end
              object ERetDato: TDBEdit
                Left = 140
                Top = 92
                Width = 70
                Height = 21
                Hint = 'Rettedato'
                TabStop = False
                Color = clSilver
                DataField = 'RetDato'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                MaxLength = 30
                ParentFont = False
                ReadOnly = True
                TabOrder = 7
              end
              object DBCheckBox1: TDBCheckBox
                Left = 4
                Top = 95
                Width = 79
                Height = 17
                Hint = #216'nsker ikke reg. i CTR kartotek (ingen tilskud)'
                Alignment = taLeftJustify
                Caption = 'Ej reg. i CTR'
                DataField = 'EjCtrReg'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 5
              end
              object EDanmark: TDBComboBox
                Left = 140
                Top = 68
                Width = 110
                Height = 21
                Style = csDropDownList
                DataField = 'DKMedlem'
                DataSource = MainDm.dsPatKar
                DropDownCount = 3
                Items.Strings = (
                  'Ikke medlem'
                  'Medlem'
                  'Ved ikke')
                TabOrder = 4
                OnDropDown = DropDown
              end
            end
            object gbCtr: TGroupBox
              Left = 275
              Top = 22
              Width = 191
              Height = 146
              Anchors = [akTop, akRight]
              Caption = 'CTR oplysninger'
              TabOrder = 0
              object Label6: TLabel
                Left = 3
                Top = 48
                Width = 56
                Height = 13
                Alignment = taRightJustify
                Caption = 'Tidsstempel'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label26: TLabel
                Left = 3
                Top = 73
                Width = 27
                Height = 13
                Caption = 'Saldo'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label38: TLabel
                Left = 3
                Top = 95
                Width = 44
                Height = 13
                Caption = 'Udligning'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label39: TLabel
                Left = 3
                Top = 23
                Width = 59
                Height = 13
                Alignment = taRightJustify
                Caption = 'Status/Type'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label40: TLabel
                Left = 3
                Top = 120
                Width = 28
                Height = 13
                Caption = 'Udl'#248'b'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object ECtrSaldo: TDBEdit
                Left = 49
                Top = 68
                Width = 65
                Height = 21
                Hint = 'Saldo i CTR kartoteket'
                TabStop = False
                Color = clLime
                DataField = 'CtrSaldo'
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
              object ECtrUdlign: TDBEdit
                Left = 49
                Top = 92
                Width = 65
                Height = 21
                Hint = 'Saldo i CTR kartoteket'
                TabStop = False
                Color = clLime
                DataField = 'CtrUdlign'
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
              object ECtrStempel: TDBEdit
                Left = 70
                Top = 44
                Width = 110
                Height = 21
                Hint = 'Rettedato'
                TabStop = False
                Color = clLime
                DataField = 'CtrStempel'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                MaxLength = 30
                ParentFont = False
                ReadOnly = True
                TabOrder = 3
              end
              object ECtrStatus: TDBEdit
                Left = 70
                Top = 20
                Width = 15
                Height = 21
                Hint = 'CTR status 0=Ingen 1=CTR status 2=Lokal saldo 3=CTR opdatering'
                TabStop = False
                Color = clLime
                DataField = 'CtrStatus'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                MaxLength = 30
                ParentFont = False
                ReadOnly = True
                TabOrder = 4
              end
              object ECtrUdDato: TDBEdit
                Left = 49
                Top = 116
                Width = 65
                Height = 21
                Hint = 'Rettedato'
                TabStop = False
                Color = clLime
                DataField = 'CtrUdDato'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -9
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                MaxLength = 30
                ParentFont = False
                ReadOnly = True
                TabOrder = 5
              end
              object ECtrType: TDBEdit
                Left = 83
                Top = 20
                Width = 97
                Height = 21
                Hint = 'CTR patienttype'
                TabStop = False
                Color = clLime
                DataField = 'CtrType'
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
              object ECtrBSaldo: TDBEdit
                Left = 115
                Top = 68
                Width = 65
                Height = 21
                Hint = 'Saldo i CTR kartoteket'
                TabStop = False
                Color = clLime
                DataField = 'CtrSaldoB'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                ReadOnly = True
                TabOrder = 6
              end
              object ECtrBUdlign: TDBEdit
                Left = 115
                Top = 92
                Width = 65
                Height = 21
                Hint = 'Saldo i CTR kartoteket'
                TabStop = False
                Color = clLime
                DataField = 'CTRUdlignB'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                ReadOnly = True
                TabOrder = 7
              end
              object ECtrBUdDato: TDBEdit
                Left = 115
                Top = 116
                Width = 65
                Height = 21
                Hint = 'Rettedato'
                TabStop = False
                Color = clLime
                DataField = 'CtrUdDatoB'
                DataSource = MainDm.dsPatKar
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -9
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                MaxLength = 30
                ParentFont = False
                ReadOnly = True
                TabOrder = 8
              end
            end
          end
        end
      end
    end
    object TilskudsPage: TcxTabSheet
      Caption = 'Tilskud [CF2]'
      OnEnter = TilskudsPageEnter
      OnExit = TilskudsPageExit
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object TilskEditPanel: TPanel
        Left = 0
        Top = 0
        Width = 796
        Height = 424
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object TilEditPanel: TPanel
          Left = 0
          Top = 0
          Width = 796
          Height = 424
          Align = alClient
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          DesignSize = (
            796
            424)
          object DBGrid1: TDBGrid
            Left = 324
            Top = 10
            Width = 457
            Height = 189
            TabStop = False
            Anchors = [akLeft, akTop, akRight]
            DataSource = MainDm.dsPatTil
            Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
            TabOrder = 4
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
          end
          object TilBem: TDBMemo
            Left = 323
            Top = 205
            Width = 457
            Height = 227
            Anchors = [akLeft, akTop, akRight, akBottom]
            DataField = 'Bevilling'
            DataSource = MainDm.dsPatTil
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            PopupMenu = TilMenu
            TabOrder = 5
            ExplicitWidth = 473
            ExplicitHeight = 243
          end
          object gbRegel: TGroupBox
            Left = 7
            Top = 4
            Width = 310
            Height = 195
            Caption = 'Regeloplysninger'
            TabOrder = 0
            object Label3: TLabel
              Left = 38
              Top = 43
              Width = 28
              Height = 13
              Alignment = taRightJustify
              Caption = '&Regel'
              FocusControl = TilERegel
            end
            object Label8: TLabel
              Left = 51
              Top = 91
              Width = 15
              Height = 13
              Alignment = taRightJustify
              Caption = 'Fra'
              FocusControl = TilFraDato
            end
            object Label9: TLabel
              Left = 146
              Top = 91
              Width = 11
              Height = 13
              Caption = 'Til'
              FocusControl = TilTilDato
            end
            object sbTilskud: TSpeedButton
              Tag = 7
              Left = 208
              Top = 39
              Width = 24
              Height = 21
              Action = acTilskudRegel
              Caption = '...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              Layout = blGlyphRight
              ParentFont = False
            end
            object Label21: TLabel
              Left = 125
              Top = 43
              Width = 29
              Height = 13
              Hint = 'Orden for regneregler'
              Caption = 'Orden'
              FocusControl = TilEOrden
            end
            object Label23: TLabel
              Left = 39
              Top = 67
              Width = 27
              Height = 13
              Alignment = taRightJustify
              Caption = 'Tekst'
              FocusControl = TilERegel
            end
            object Label34: TLabel
              Left = 28
              Top = 144
              Width = 38
              Height = 13
              Alignment = taRightJustify
              Caption = 'Afdeling'
            end
            object Label37: TLabel
              Left = 16
              Top = 168
              Width = 50
              Height = 13
              Alignment = taRightJustify
              Caption = 'Afdeling Ej'
            end
            object Label46: TLabel
              Left = 158
              Top = 168
              Width = 43
              Height = 13
              Alignment = taRightJustify
              Caption = '&Debitornr'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
            end
            object lblCPrNvn: TLabel
              Left = 39
              Top = 21
              Width = 241
              Height = 13
              AutoSize = False
              Caption = 'KundeNavn'
            end
            object TilERegel: TDBEdit
              Left = 70
              Top = 39
              Width = 48
              Height = 21
              Hint = 'Regel if'#248'lge instans for tilskud'
              DataField = 'Regel'
              DataSource = MainDm.dsPatTil
              TabOrder = 0
            end
            object TilFraDato: TDBEdit
              Left = 70
              Top = 87
              Width = 68
              Height = 21
              Hint = 'Bevillings startdato'
              DataField = 'FraDato'
              DataSource = MainDm.dsPatTil
              TabOrder = 3
            end
            object TilTilDato: TDBEdit
              Left = 164
              Top = 87
              Width = 68
              Height = 21
              Hint = 'Bevillings slutdato'
              DataField = 'TilDato'
              DataSource = MainDm.dsPatTil
              TabOrder = 4
            end
            object TilENavn: TDBEdit
              Left = 70
              Top = 63
              Width = 162
              Height = 21
              TabStop = False
              Color = clSilver
              DataField = 'Navn'
              DataSource = MainDm.dsPatTil
              ReadOnly = True
              TabOrder = 2
            end
            object TilEOrden: TDBEdit
              Left = 159
              Top = 39
              Width = 48
              Height = 21
              Hint = 'Regel if'#248'lge instans for tilskud'
              DataField = 'Orden'
              DataSource = MainDm.dsPatTil
              TabOrder = 1
            end
            object TilEJnrChk: TDBCheckBox
              Left = 12
              Top = 118
              Width = 49
              Height = 17
              Hint = 'Modulus check journalnr (K'#248'benhavn)'
              Alignment = taLeftJustify
              Caption = '&Jour.nr'
              DataField = 'ChkJournalNr'
              DataSource = MainDm.dsPatTil
              TabOrder = 5
            end
            object TilEJnr: TDBEdit
              Left = 70
              Top = 116
              Width = 162
              Height = 21
              Hint = 'Journalnr'
              DataField = 'JournalNr'
              DataSource = MainDm.dsPatTil
              TabOrder = 6
            end
            object TilAfd: TDBEdit
              Left = 70
              Top = 140
              Width = 162
              Height = 21
              Hint = 'Afdeling/Sagsomr'#229'de for tilskudsberettiget andel'
              DataField = 'Afdeling'
              DataSource = MainDm.dsPatTil
              TabOrder = 7
            end
            object TilAfdEj: TDBEdit
              Left = 70
              Top = 164
              Width = 162
              Height = 21
              Hint = 'Afdeling/Sagsomr'#229'de for ikke tilskudsberettiget andel'
              DataField = 'AfdelingEj'
              DataSource = MainDm.dsPatTil
              TabOrder = 8
            end
          end
          object gbBetaling: TGroupBox
            Left = 8
            Top = 200
            Width = 310
            Height = 75
            Caption = 'Betalingsoplysninger'
            TabOrder = 1
            object Label13: TLabel
              Left = 23
              Top = 24
              Width = 43
              Height = 13
              Alignment = taRightJustify
              Caption = '&Eankode'
              FocusControl = TilEanKode
            end
            object sbTilEanKode: TSpeedButton
              Tag = 9
              Left = 176
              Top = 20
              Width = 24
              Height = 21
              Action = acTilskudEankode
              Caption = '...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object TilEAkkum: TDBEdit
              Left = 70
              Top = 32130
              Width = 100
              Height = 21
              Hint = 'Akkumuleret egenbetaling'
              Color = clSilver
              DataField = 'AkkBetaling'
              TabOrder = 1
            end
            object TilEanKode: TDBEdit
              Left = 70
              Top = 20
              Width = 100
              Height = 21
              Hint = 'Eankode for debitering af beregnet kommuneandel'
              DataField = 'RefNr'
              DataSource = MainDm.dsPatTil
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
            end
          end
          object gbPromiller: TGroupBox
            Left = 8
            Top = 276
            Width = 310
            Height = 75
            Caption = 'Tilskudspromiller'
            TabOrder = 2
            object Label15: TLabel
              Left = 36
              Top = 24
              Width = 30
              Height = 13
              Alignment = taRightJustify
              Caption = '&M.tilsk'
              FocusControl = TilPrm1
            end
            object Label20: TLabel
              Left = 224
              Top = 24
              Width = 33
              Height = 13
              Alignment = taRightJustify
              Caption = 'Ej &tilsk.'
              FocusControl = TilPrm5
            end
            object TilPrm1: TDBEdit
              Left = 70
              Top = 20
              Width = 40
              Height = 21
              Hint = 'Tilskudspromille 1. niveau'
              DataField = 'Promille1'
              DataSource = MainDm.dsPatTil
              TabOrder = 0
            end
            object TilPrm5: TDBEdit
              Left = 261
              Top = 20
              Width = 40
              Height = 21
              Hint = 'Tilskudspromille ikke tilskudsberettiget'
              DataField = 'Promille5'
              DataSource = MainDm.dsPatTil
              TabOrder = 1
            end
          end
          object gbTilskud: TGroupBox
            Left = 8
            Top = 352
            Width = 310
            Height = 75
            Caption = 'Produkt(er)'
            TabOrder = 3
            object Label28: TLabel
              Left = 21
              Top = 24
              Width = 45
              Height = 13
              Alignment = taRightJustify
              Caption = '&ATCkode'
              FocusControl = TilAtcKode
            end
            object Label42: TLabel
              Left = 22
              Top = 48
              Width = 44
              Height = 13
              Alignment = taRightJustify
              Caption = 'Pr'#230'parat'
              FocusControl = TilVarenr
            end
            object Label43: TLabel
              Left = 168
              Top = 24
              Width = 31
              Height = 13
              Alignment = taRightJustify
              Caption = '&Varenr'
              FocusControl = TilVarenr
            end
            object sbMatch: TSpeedButton
              Tag = 8
              Left = 255
              Top = 20
              Width = 24
              Height = 21
              Action = acTilskudVare
              Caption = '...'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              Layout = blGlyphRight
              ParentFont = False
            end
            object TilAtcKode: TDBEdit
              Left = 70
              Top = 20
              Width = 75
              Height = 21
              Hint = 'ATCKode hel eller delvis for d'#230'kning af pr'#230'parat(er)'
              DataField = 'AtcKode'
              DataSource = MainDm.dsPatTil
              TabOrder = 0
            end
            object TilVarenr: TDBEdit
              Left = 204
              Top = 20
              Width = 50
              Height = 21
              Hint = 'Varenr for d'#230'kning af pr'#230'parat'
              DataField = 'VareNr'
              DataSource = MainDm.dsPatTil
              TabOrder = 1
            end
            object TilProdukt: TDBEdit
              Left = 72
              Top = 43
              Width = 230
              Height = 21
              Hint = 'Produktnavn for d'#230'kning af pr'#230'parat(er)'
              DataField = 'Produkt'
              DataSource = MainDm.dsPatTil
              TabOrder = 2
            end
          end
        end
      end
    end
    object EkspPage: TcxTabSheet
      Caption = 'Eksp. [CF3]'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImageIndex = 2
      ParentFont = False
      OnEnter = EkspPageEnter
      OnExit = EkspPageExit
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgrEksp: TDBGrid
        Left = 0
        Top = 0
        Width = 796
        Height = 211
        Align = alClient
        DataSource = MainDm.dsEksOvr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDrawColumnCell = dbgrEkspDrawColumnCell
      end
      object paEksp: TPanel
        Left = 0
        Top = 384
        Width = 796
        Height = 40
        Align = alBottom
        BevelOuter = bvLowered
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object laEkspGrid1: TLabel
          Left = 4
          Top = 2
          Width = 25
          Height = 8
          AutoSize = False
          Caption = '&1'
          FocusControl = dbgrEksp
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnFace
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object laEkspGrid2: TLabel
          Left = 16
          Top = 2
          Width = 21
          Height = 8
          AutoSize = False
          Caption = '&2'
          FocusControl = dbgrLinier
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnFace
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object laEkspGrid3: TLabel
          Left = 32
          Top = 2
          Width = 21
          Height = 8
          AutoSize = False
          Caption = '&3'
          FocusControl = dbgrTilskud
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnFace
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Visible = False
        end
        object Label16: TLabel
          Left = 8
          Top = 13
          Width = 25
          Height = 16
          Caption = 'S&'#248'g'
          FocusControl = cboFind
        end
        object butUdEksp: TBitBtn
          Left = 616
          Top = 7
          Width = 80
          Height = 28
          Action = AcCF3UdEkspListe
          Caption = '&Eksp.liste'
          NumGlyphs = 2
          TabOrder = 7
        end
        object butFindEksp: TBitBtn
          Left = 225
          Top = 7
          Width = 57
          Height = 28
          Action = acCF3Find
          Caption = '&Find'
          NumGlyphs = 2
          TabOrder = 2
        end
        object eEkspLb: TEdit
          Left = 145
          Top = 9
          Width = 70
          Height = 24
          TabOrder = 1
          OnKeyPress = eEkspLbKeyPress
        end
        object ButUdCtr: TBitBtn
          Left = 535
          Top = 7
          Width = 80
          Height = 28
          Action = AcCF3UdCtrEkspListe
          Caption = '&Ctr eksp.liste'
          NumGlyphs = 2
          TabOrder = 6
        end
        object ButUdAfsl: TBitBtn
          Left = 373
          Top = 7
          Width = 80
          Height = 28
          Action = acCF3Tilbage
          Caption = '&Tilbagef'#248'r'
          NumGlyphs = 2
          TabOrder = 4
        end
        object ButEtiket: TBitBtn
          Left = 292
          Top = 7
          Width = 80
          Height = 28
          Action = acCF3VisEtiket
          Caption = '&Vis etiket'
          NumGlyphs = 2
          TabOrder = 3
        end
        object butKontrol: TBitBtn
          Left = 698
          Top = 7
          Width = 95
          Height = 28
          Action = acFejlForm
          Caption = '&RCP Kontrol'
          NumGlyphs = 2
          TabOrder = 8
        end
        object btnSendF3: TBitBtn
          Left = 454
          Top = 7
          Width = 80
          Height = 28
          Action = acCF3SendRS
          Caption = '&Send FMK'
          TabOrder = 5
        end
        object cboFind: TComboBox
          Left = 50
          Top = 9
          Width = 87
          Height = 24
          Style = csDropDownList
          TabOrder = 0
          Items.Strings = (
            'Lbnr'
            'Faktnr'
            'Pakkenr')
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 211
        Width = 796
        Height = 173
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        OnResize = Panel5Resize
        ExplicitTop = 219
        ExplicitWidth = 804
        object dbgrLinier: TDBGrid
          Left = 0
          Top = 0
          Width = 401
          Height = 173
          Align = alLeft
          DataSource = MainDm.dsLinOvr
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ParentFont = False
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDrawColumnCell = dbgrLinierDrawColumnCell
        end
        object dbgrTilskud: TDBGrid
          Left = 342
          Top = 0
          Width = 462
          Height = 173
          Align = alRight
          Anchors = [akLeft, akTop, akRight, akBottom]
          DataSource = MainDm.dsTilOvr
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ParentFont = False
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
        end
      end
    end
    object UafslutPage: TcxTabSheet
      Caption = 'Uafsluttede [CF4]'
      ImageIndex = 3
      OnEnter = UafslutPageEnter
      OnExit = UafslutPageExit
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgrUafsl: TDBGrid
        Left = 0
        Top = 0
        Width = 796
        Height = 347
        Align = alClient
        DataSource = MainDm.dsEksOvr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDrawColumnCell = dbgrUafslDrawColumnCell
      end
      object paUafslut: TPanel
        Left = 0
        Top = 347
        Width = 796
        Height = 77
        Align = alBottom
        BevelOuter = bvLowered
        TabOrder = 1
        DesignSize = (
          796
          77)
        object Label32: TLabel
          Left = 219
          Top = 13
          Width = 45
          Height = 16
          Alignment = taRightJustify
          Caption = '&Kontonr'
          FocusControl = eUafKoNr
        end
        object Label36: TLabel
          Left = 11
          Top = 13
          Width = 42
          Height = 16
          Alignment = taRightJustify
          Caption = 'L'#248'be&nr'
          FocusControl = eUafLb
        end
        object laUafGrid1: TLabel
          Left = 4
          Top = 4
          Width = 5
          Height = 5
          AutoSize = False
          Caption = '&1'
          FocusControl = dbgrUafsl
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnFace
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label44: TLabel
          Left = 434
          Top = 13
          Width = 36
          Height = 16
          Caption = '&Lev.nr'
          FocusControl = edtLevnr
        end
        object Label61: TLabel
          Left = 10
          Top = 45
          Width = 43
          Height = 16
          Alignment = taRightJustify
          Caption = '&Yder.nr'
          FocusControl = edtRetYderNr
        end
        object Label62: TLabel
          Left = 142
          Top = 45
          Width = 36
          Height = 16
          Alignment = taRightJustify
          Caption = '&Aut.Nr'
          FocusControl = edtRetAutNr
        end
        object butUdUaf: TBitBtn
          Left = 708
          Top = 7
          Width = 74
          Height = 28
          Action = acCF4UdUaf
          Anchors = [akTop, akRight]
          Caption = '&Udskriv'
          NumGlyphs = 2
          TabOrder = 7
          ExplicitLeft = 724
        end
        object eUafKoNr: TEdit
          Left = 269
          Top = 9
          Width = 82
          Height = 24
          TabOrder = 2
        end
        object butRetKonto: TBitBtn
          Left = 357
          Top = 7
          Width = 72
          Height = 28
          Action = acCF4RetKonto
          Caption = '&Ret kontonr'
          NumGlyphs = 2
          TabOrder = 3
        end
        object butFindUaf: TBitBtn
          Left = 136
          Top = 7
          Width = 73
          Height = 28
          Action = acCF4FindUaf
          Caption = '&Find l'#248'benr'
          NumGlyphs = 2
          TabOrder = 1
        end
        object eUafLb: TEdit
          Left = 57
          Top = 9
          Width = 70
          Height = 24
          TabOrder = 0
          OnKeyPress = eUafLbKeyPress
        end
        object btnNyPakke: TBitBtn
          Left = 617
          Top = 7
          Width = 84
          Height = 28
          Action = acCF4NyPakke
          Anchors = [akTop, akRight]
          Caption = 'Udsk. &pakke'
          NumGlyphs = 2
          TabOrder = 6
          ExplicitLeft = 633
        end
        object edtLevnr: TEdit
          Left = 474
          Top = 9
          Width = 57
          Height = 24
          TabOrder = 4
        end
        object btnLevnr: TButton
          Left = 537
          Top = 6
          Width = 65
          Height = 27
          Action = acCF4Levnr
          TabOrder = 5
        end
        object edtRetYderNr: TEdit
          Left = 57
          Top = 41
          Width = 70
          Height = 24
          TabOrder = 8
        end
        object bitRetYdernr: TBitBtn
          Left = 269
          Top = 39
          Width = 128
          Height = 28
          Action = acCF4RetYdernr
          Caption = 'Re&t YderNr / AutNr'
          NumGlyphs = 2
          TabOrder = 10
        end
        object edtRetAutNr: TEdit
          Left = 188
          Top = 41
          Width = 70
          Height = 24
          TabOrder = 9
        end
      end
    end
    object RSRemotePage: TcxTabSheet
      Caption = 'FMK Recepter [CF5]'
      ImageIndex = 5
      OnShow = RSRemotePageShow
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object gbCpr: TGroupBox
        Left = 0
        Top = 0
        Width = 796
        Height = 235
        Align = alClient
        Caption = 'S'#248'gning p'#229' cprnr / stregkode'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Label58: TLabel
          Left = 416
          Top = 48
          Width = 6
          Height = 13
          Caption = '&1'
          Visible = False
        end
        object Label59: TLabel
          Left = 488
          Top = 48
          Width = 6
          Height = 13
          Caption = '&2'
          FocusControl = ListView2
          Visible = False
        end
        object Panel3: TPanel
          Left = 2
          Top = 15
          Width = 792
          Height = 50
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object lblCF5Cprnr: TLabel
            Left = 8
            Top = 1
            Width = 32
            Height = 16
            Caption = '&Cprnr'
            FocusControl = edtCprNr
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label17: TLabel
            Left = 512
            Top = 2
            Width = 6
            Height = 13
            Caption = '&2'
            FocusControl = ListView2
            Visible = False
          end
          object Label18: TLabel
            Left = 488
            Top = 1
            Width = 6
            Height = 13
            Caption = '&1'
            FocusControl = lvFMKPrescriptions
            Visible = False
          end
          object lblCF5name: TLabel
            Left = 112
            Top = 1
            Width = 3
            Height = 16
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object edtCprNr: TEdit
            Left = 6
            Top = 20
            Width = 100
            Height = 24
            Hint = 'Indtast cprnr eller scan stregkode og tryk ENTER'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnKeyPress = edtCprNrKeyPress
          end
          object btnGetMedList: TButton
            Left = 112
            Top = 19
            Width = 120
            Height = 25
            Caption = '&Hent Recept(er)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = btnGetMedListClick
          end
          object btnTakser: TButton
            Left = 238
            Top = 19
            Width = 120
            Height = 25
            Caption = '&Takser recept'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            TabStop = False
            OnClick = btnTakserClick
          end
          object btnUdRapport: TButton
            Left = 384
            Top = 19
            Width = 120
            Height = 25
            Caption = 'Uds&kriv Rapport'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = btnUdRapportClick
          end
        end
        object Panel4: TPanel
          Left = 2
          Top = 65
          Width = 792
          Height = 168
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object lvFMKPrescriptions: TListView
            Left = 0
            Top = 0
            Width = 792
            Height = 168
            Align = alClient
            Checkboxes = True
            Columns = <
              item
                Caption = 'Ord-ID'
                Width = 60
              end
              item
                Caption = 'Dato'
                Width = 120
              end
              item
                Caption = 'Sidste ekspeditionsdato'
                Width = 70
              end
              item
                Caption = 'Produkt beskrivelse'
                Width = 300
              end
              item
                Alignment = taRightJustify
                Caption = 'Ant'
                Width = 30
              end
              item
                Alignment = taRightJustify
                Caption = 'Max'
                Width = 35
              end
              item
                Alignment = taRightJustify
                Caption = 'Udl'
                Width = 30
              end
              item
                Caption = 'Udl.int'
                Width = 60
              end
              item
                Alignment = taCenter
                Caption = 'Status'
                Width = 120
              end
              item
                Caption = 'L'#230'ge'
                Width = 100
              end
              item
                Caption = 'Praksis'
                Width = 100
              end
              item
                Caption = 'Apotek'
                Width = 115
              end
              item
                Caption = 'Dosis'
              end
              item
                Caption = 'Privat'
              end
              item
                Caption = 'ReceptId'
                Width = 80
              end
              item
                Caption = 'Varenr'
              end
              item
                Caption = 'Lokation'
              end
              item
                Caption = 'Gyldig fra'
                Width = 70
              end
              item
                Caption = 'Gyldig til'
                Width = 70
              end
              item
                Caption = 'RSLbnr'
                Width = 0
              end
              item
                Caption = 'Kunde-id'
                Width = 150
              end
              item
                Caption = 'Kunde-id type'
              end>
            GridLines = True
            MultiSelect = True
            SortType = stData
            TabOrder = 0
            ViewStyle = vsReport
            OnCompare = lvFMKPrescriptionsCompare
            OnCustomDrawItem = lvFMKPrescriptionsCustomDrawItem
            OnCustomDrawSubItem = lvFMKPrescriptionsCustomDrawSubItem
            OnDblClick = lvFMKPrescriptionsDblClick
            OnItemChecked = lvFMKPrescriptionsItemChecked
          end
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 235
        Width = 796
        Height = 189
        Align = alBottom
        Caption = 'S'#248'gning p'#229' flere parametre'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object Label27: TLabel
          Left = 8
          Top = 16
          Width = 49
          Height = 16
          Caption = '&Fornavn'
          FocusControl = edtForNavn
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label31: TLabel
          Left = 134
          Top = 16
          Width = 56
          Height = 16
          Caption = '&Efternavn'
          FocusControl = edtEftNavn
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label33: TLabel
          Left = 8
          Top = 56
          Width = 76
          Height = 16
          Caption = '&F'#248'dselsdato'
          FocusControl = cxDateFoedselsdato
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label35: TLabel
          Left = 134
          Top = 56
          Width = 38
          Height = 16
          Caption = '&Postnr'
          FocusControl = edtPostNr
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object btnSearchRecept: TButton
          Left = 301
          Top = 73
          Width = 105
          Height = 25
          Caption = '&Navne s'#248'gning'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = btnSearchReceptClick
        end
        object ListView2: TListView
          Left = 2
          Top = 104
          Width = 792
          Height = 83
          Align = alBottom
          Columns = <
            item
              Caption = 'Cprnr'
              Width = 80
            end
            item
              Caption = 'Efternavn'
              Width = 140
            end
            item
              Caption = 'Fornavn'
              Width = 140
            end
            item
              Caption = 'Vej'
              Width = 140
            end
            item
              Caption = 'Postnr'
              Width = 55
            end
            item
              Caption = 'Medicinkort'
              Width = 150
            end
            item
              Caption = 'Dato'
              Width = 70
            end>
          GridLines = True
          RowSelect = True
          TabOrder = 8
          ViewStyle = vsReport
        end
        object edtForNavn: TEdit
          Left = 8
          Top = 32
          Width = 120
          Height = 24
          Hint = 'Indtast helt eller devist fornavn'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object edtEftNavn: TEdit
          Left = 134
          Top = 32
          Width = 160
          Height = 24
          Hint = 'Indtast helt eller devist efternavn'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object edtPostNr: TEdit
          Left = 134
          Top = 72
          Width = 50
          Height = 24
          Hint = 'Indtast postnr'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object btnSoegCPR: TButton
          Left = 450
          Top = 73
          Width = 105
          Height = 25
          Action = acSoegCPR
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object cxDateFoedselsdato: TcxDateEdit
          Left = 7
          Top = 74
          TabOrder = 2
          Width = 121
        end
        object chkUdenCPR: TCheckBox
          Left = 198
          Top = 76
          Width = 97
          Height = 17
          Caption = '&Uden CPR'
          TabOrder = 4
        end
        object btnHentOrdination: TButton
          Left = 602
          Top = 73
          Width = 127
          Height = 25
          Action = acHentOrdination
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
      end
    end
    object RSLocalPage: TcxTabSheet
      Caption = 'Lokale Recepter [CF6]'
      ImageIndex = 6
      OnShow = RSLocalPageShow
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 796
        Height = 113
        Align = alTop
        Caption = 'Recept s'#248'gning'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        DesignSize = (
          796
          113)
        object Label47: TLabel
          Left = 208
          Top = 16
          Width = 56
          Height = 16
          Caption = '&Efternavn'
          FocusControl = edtEftNavn1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label48: TLabel
          Left = 8
          Top = 64
          Width = 57
          Height = 16
          Caption = '&Dato start'
          FocusControl = dtpDatoFra
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label49: TLabel
          Left = 187
          Top = 64
          Width = 52
          Height = 16
          Caption = 'D&ato slut'
          FocusControl = dtpDatoTil
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label50: TLabel
          Left = 8
          Top = 16
          Width = 35
          Height = 16
          Caption = '&Cpr.nr'
          FocusControl = edtCPRNr1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label51: TLabel
          Left = 108
          Top = 16
          Width = 49
          Height = 16
          Caption = '&Fornavn'
          FocusControl = edtForNavn1
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label52: TLabel
          Left = 363
          Top = 64
          Width = 21
          Height = 16
          Caption = '&Info'
          FocusControl = edtPraksis
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label53: TLabel
          Left = 459
          Top = 15
          Width = 36
          Height = 16
          Caption = '&L'#230'ge'
          FocusControl = edtYdNavn
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label54: TLabel
          Left = 368
          Top = 16
          Width = 40
          Height = 16
          Caption = '&Ydernr'
          FocusControl = edtYderNr
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label56: TLabel
          Left = 488
          Top = 40
          Width = 7
          Height = 16
          Caption = '&1'
          FocusControl = dbgLocalRS
          Visible = False
        end
        object Label57: TLabel
          Left = 512
          Top = 40
          Width = 7
          Height = 16
          Caption = '&2'
          FocusControl = DBGrid4
          Visible = False
        end
        object Label14: TLabel
          Left = 617
          Top = 15
          Width = 29
          Height = 16
          Caption = 'Filte&r'
          FocusControl = cboVisDosis
        end
        object edtEftNavn1: TEdit
          Left = 208
          Top = 32
          Width = 150
          Height = 24
          Hint = 'Indtast patientens efternavn helt eller delvist'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
        object butFilter: TButton
          Left = 690
          Top = 80
          Width = 81
          Height = 27
          Hint = 'Udf'#248'r s'#248'gning'
          Anchors = [akTop, akRight]
          Caption = '&S'#248'g'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = butFilterClick
          ExplicitLeft = 698
        end
        object dtpDatoFra: TDateTimePicker
          Left = 8
          Top = 80
          Width = 90
          Height = 24
          Hint = 'Startdato p'#229' receptoversigt'
          Date = 39006.676472615700000000
          Time = 39006.676472615700000000
          TabOrder = 7
        end
        object dtpDatoTil: TDateTimePicker
          Left = 185
          Top = 80
          Width = 90
          Height = 24
          Hint = 'Slutdato p'#229' receptoversigt'
          Date = 39006.676472615700000000
          Time = 39006.676472615700000000
          TabOrder = 9
        end
        object edtCPRNr1: TEdit
          Left = 6
          Top = 32
          Width = 90
          Height = 24
          Hint = 'Indtast cprnr p'#229' patient'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnKeyPress = edtCPRNr1KeyPress
        end
        object edtForNavn1: TEdit
          Left = 108
          Top = 32
          Width = 90
          Height = 24
          Hint = 'Indtast patientens fornavn helt eller delvist'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object edtPraksis: TEdit
          Left = 364
          Top = 80
          Width = 150
          Height = 24
          Hint = 'Indtast praksis navn helt eller delvist'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
        end
        object edtYdNavn: TEdit
          Left = 455
          Top = 32
          Width = 150
          Height = 24
          Hint = 'Indtast l'#230'gens navn helt eller delvist'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object edtYderNr: TEdit
          Left = 368
          Top = 32
          Width = 73
          Height = 24
          Hint = 'Indtast l'#230'gens ydernr helt eller delvist'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object lbLager: TComboBox
          Left = 528
          Top = 80
          Width = 121
          Height = 24
          Style = csDropDownList
          TabOrder = 12
        end
        object dtpTidFra: TDateTimePicker
          Left = 106
          Top = 80
          Width = 63
          Height = 24
          Date = 40147.327171759300000000
          Format = 'HH:mm'
          Time = 40147.327171759300000000
          Kind = dtkTime
          TabOrder = 8
        end
        object dtpTidTil: TDateTimePicker
          Left = 280
          Top = 80
          Width = 63
          Height = 24
          Date = 40147.327171759300000000
          Format = 'HH:mm'
          Time = 40147.327171759300000000
          Kind = dtkTime
          TabOrder = 10
        end
        object cboVisDosis: TComboBox
          Left = 617
          Top = 32
          Width = 168
          Height = 24
          Style = csDropDownList
          DropDownCount = 4
          TabOrder = 6
          Items.Strings = (
            'Vis alle'
            'Vis ikke CPRnr.'
            'Vis ej eksp (ikke dosis)'
            'Vis kun dosis'
            'Vis ikke dosis')
        end
      end
      object dbgLocalRS: TDBGrid
        Left = 0
        Top = 113
        Width = 796
        Height = 134
        Align = alClient
        DataSource = MainDm.dsEkspList
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect, dgTitleClick]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDrawColumnCell = dbgLocalRSDrawColumnCell
        OnKeyPress = dbgLocalRSKeyPress
        OnTitleClick = dbgLocalRSTitleClick
      end
      object DBGrid4: TDBGrid
        Left = 0
        Top = 247
        Width = 796
        Height = 136
        Align = alBottom
        DataSource = MainDm.dsEkspLinList
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 2
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDrawColumnCell = DBGrid4DrawColumnCell
      end
      object Panel2: TPanel
        Left = 0
        Top = 383
        Width = 796
        Height = 41
        Align = alBottom
        TabOrder = 3
        ExplicitTop = 391
        ExplicitWidth = 804
        object Label55: TLabel
          Left = 166
          Top = 13
          Width = 36
          Height = 16
          Hint = #197'rsag til annullering'
          Alignment = taRightJustify
          Caption = '&'#197'rsag'
          FocusControl = edtReason
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object btnTilbage: TButton
          Left = 425
          Top = 8
          Width = 90
          Height = 25
          Hint = 'TIlbagef'#248'r ordination til FMK ('#229'ben)'
          Caption = 'Til&bage'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          TabStop = False
          OnClick = btnTilbageClick
        end
        object btnUdskriv: TButton
          Left = 6
          Top = 8
          Width = 75
          Height = 25
          Hint = 'Udskriv kopi af allerede modtaget recept'
          Caption = '&Udskriv'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TabStop = False
          OnClick = btnUdskrivClick
        end
        object btnAnnul: TButton
          Left = 330
          Top = 8
          Width = 90
          Height = 25
          Hint = 'Ugyldigg'#248'r ordination i FMK (HUSK '#197'RSAG)'
          Caption = 'Ugyldigg'#248'r'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          TabStop = False
          OnClick = btnAnnulClick
        end
        object edtReason: TEdit
          Left = 206
          Top = 9
          Width = 121
          Height = 24
          Hint = #197'rsag til annullering'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object btnAfslut: TButton
          Left = 521
          Top = 8
          Width = 90
          Height = 25
          Hint = 'Afslut ordination i FMK (ordination fjernes)'
          Caption = 'Afslut'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          TabStop = False
          OnClick = btnAfslutClick
        end
        object bitbtnTakser: TBitBtn
          Left = 615
          Top = 8
          Width = 75
          Height = 25
          Caption = '&Takser'
          TabOrder = 5
          OnClick = bitbtnTakserClick
        end
        object btnSend: TButton
          Left = 696
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Se&nd FMK'
          TabOrder = 6
          OnClick = btnSendClick
        end
        object Button1: TButton
          Left = 87
          Top = 8
          Width = 75
          Height = 25
          Caption = '&Vis'
          TabOrder = 7
          OnClick = Button1Click
        end
      end
    end
    object FakturaPage: TcxTabSheet
      Caption = 'Forsendelse [CF7]'
      ImageIndex = 6
      OnEnter = FakturaPageEnter
      OnExit = FakturaPageExit
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object dbgrFors: TDBGrid
        Left = 0
        Top = 0
        Width = 796
        Height = 324
        Align = alClient
        DataSource = MainDm.dsEksOvr
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDrawColumnCell = dbgrForsDrawColumnCell
      end
      object paFaktura: TPanel
        Left = 0
        Top = 364
        Width = 796
        Height = 60
        Align = alBottom
        BevelOuter = bvLowered
        TabOrder = 1
        DesignSize = (
          796
          60)
        object laFaktGrid1: TLabel
          Left = 148
          Top = 31
          Width = 21
          Height = 16
          Anchors = [akLeft, akBottom]
          AutoSize = False
          Caption = '&1'
          FocusControl = dbgrFors
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnFace
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label45: TLabel
          Left = 404
          Top = 8
          Width = 36
          Height = 16
          Anchors = [akLeft, akBottom]
          Caption = '&Lev.nr'
          FocusControl = edtFakLevNr
        end
        object Label10: TLabel
          Left = 20
          Top = 8
          Width = 43
          Height = 16
          Anchors = [akLeft, akBottom]
          Caption = '&Pakker'
          FocusControl = edtPakAnt
        end
        object Label60: TLabel
          Left = 586
          Top = 8
          Width = 60
          Height = 16
          Caption = 'Lev.liste&nr'
          FocusControl = edtLevListNr
        end
        object Label68: TLabel
          Left = 208
          Top = 6
          Width = 31
          Height = 16
          Caption = '&Turnr'
          FocusControl = edtTurnr
        end
        object edtFakLevNr: TEdit
          Left = 404
          Top = 28
          Width = 57
          Height = 24
          Anchors = [akLeft, akBottom]
          TabOrder = 4
        end
        object btnFakLevNr: TButton
          Left = 467
          Top = 24
          Width = 100
          Height = 28
          Anchors = [akLeft, akBottom]
          Caption = 'Ret lev.nr'
          TabOrder = 5
          OnClick = btnFakLevNrClick
        end
        object edtPakAnt: TEdit
          Left = 20
          Top = 27
          Width = 40
          Height = 24
          Anchors = [akLeft, akBottom]
          TabOrder = 0
          Text = '0'
        end
        object butRetPakAnt: TButton
          Left = 65
          Top = 27
          Width = 100
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = 'Ret pakkeantal'
          TabOrder = 1
          OnClick = butRetPakAntClick
        end
        object edtLevListNr: TEdit
          Left = 586
          Top = 29
          Width = 57
          Height = 24
          TabOrder = 6
        end
        object btnRetLevListNr: TButton
          Left = 666
          Top = 27
          Width = 100
          Height = 28
          Caption = 'Ret lev.listenr'
          TabOrder = 7
          OnClick = btnRetLevListNrClick
        end
        object btnTurNr: TButton
          Left = 265
          Top = 27
          Width = 100
          Height = 25
          Caption = 'Ret Turnr'
          TabOrder = 3
          OnClick = btnTurNrClick
        end
        object edtTurnr: TEdit
          Left = 208
          Top = 27
          Width = 41
          Height = 24
          TabOrder = 2
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 324
        Width = 796
        Height = 40
        Align = alBottom
        BevelOuter = bvLowered
        TabOrder = 2
        DesignSize = (
          796
          40)
        object Label12: TLabel
          Left = 148
          Top = 12
          Width = 21
          Height = 16
          AutoSize = False
          Caption = '&1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBtnFace
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label11: TLabel
          Left = 16
          Top = 8
          Width = 54
          Height = 16
          Caption = '&Sortering'
          FocusControl = cboFors
        end
        object butRetPakke: TBitBtn
          Left = 464
          Top = 7
          Width = 100
          Height = 28
          Anchors = [akTop, akRight]
          Caption = '&Ret pakkenr'
          NumGlyphs = 2
          TabOrder = 3
          OnClick = butRetPakkeClick
          ExplicitLeft = 472
        end
        object BitBtn3: TBitBtn
          Left = 315
          Top = 7
          Width = 100
          Height = 28
          Caption = '&Find'
          NumGlyphs = 2
          TabOrder = 2
          OnClick = butFindPakkeClick
        end
        object edtNr: TEdit
          Left = 236
          Top = 9
          Width = 70
          Height = 24
          TabOrder = 1
        end
        object cboFors: TComboBox
          Left = 88
          Top = 8
          Width = 145
          Height = 24
          Style = csDropDownList
          DropDownCount = 3
          ItemIndex = 0
          TabOrder = 0
          Text = 'Pakkenr'
          OnClick = cboForsClick
          Items.Strings = (
            'Pakkenr'
            'Fakturanr'
            'Kontonr')
        end
        object cxBtnUdskriv: TcxButton
          Left = 570
          Top = 7
          Width = 100
          Height = 28
          Anchors = [akTop, akRight]
          Caption = '&Udskriv'
          DropDownMenu = PopupUdMenu
          Kind = cxbkOfficeDropDown
          TabOrder = 4
          ExplicitLeft = 578
        end
        object cxBtnDMVS: TcxButton
          Left = 669
          Top = 7
          Width = 125
          Height = 28
          Anchors = [akTop, akRight]
          Caption = 'U&dlev. DMVS'
          DropDownMenu = DMVSMenu
          Kind = cxbkOfficeDropDown
          TabOrder = 5
          ExplicitLeft = 677
        end
      end
    end
    object tsEHandel: TcxTabSheet
      Caption = 'EHandel [CF8]'
      ImageIndex = 7
      OnEnter = tsEHandelEnter
      object Panel10: TPanel
        Left = 0
        Top = 0
        Width = 796
        Height = 424
        Align = alClient
        TabOrder = 0
        object Panel11: TPanel
          Left = 1
          Top = 1
          Width = 794
          Height = 80
          Align = alTop
          TabOrder = 0
          object Label63: TLabel
            Left = 32
            Top = 14
            Width = 66
            Height = 16
            Caption = '&KundeCPR'
            FocusControl = edtCPR
          end
          object lblehlin: TLabel
            Left = 768
            Top = 19
            Width = 7
            Height = 16
            Caption = '&2'
            FocusControl = dbgEHLin
          end
          object lblehord: TLabel
            Left = 769
            Top = 2
            Width = 7
            Height = 16
            Caption = '&1'
            FocusControl = dbgEHOrd
          end
          object Label66: TLabel
            Left = 32
            Top = 48
            Width = 59
            Height = 16
            Caption = 'Start &Dato'
            FocusControl = dtpEhstart
          end
          object Label67: TLabel
            Left = 256
            Top = 48
            Width = 52
            Height = 16
            Caption = 'Slut d&ato'
            FocusControl = dtpEhSlut
          end
          object edtCPR: TEdit
            Left = 120
            Top = 10
            Width = 121
            Height = 24
            TabOrder = 0
          end
          object btnFilter: TButton
            Left = 439
            Top = 44
            Width = 122
            Height = 25
            Caption = '&Filter'
            TabOrder = 4
            OnClick = btnFilterClick
          end
          object chkAabenEordre: TCheckBox
            Left = 276
            Top = 14
            Width = 97
            Height = 17
            Caption = #197'b&ne Ordrer'
            TabOrder = 1
          end
          object dtpEhstart: TDateTimePicker
            Left = 120
            Top = 44
            Width = 91
            Height = 24
            Date = 41555.548351099540000000
            Time = 41555.548351099540000000
            TabOrder = 2
          end
          object dtpEhSlut: TDateTimePicker
            Left = 318
            Top = 46
            Width = 91
            Height = 21
            Date = 41555.548538784720000000
            Time = 41555.548538784720000000
            TabOrder = 3
          end
        end
        object pnlEHButtons: TPanel
          Left = 1
          Top = 382
          Width = 794
          Height = 41
          Align = alBottom
          TabOrder = 1
          object btnSkiftStatus: TButton
            Left = 13
            Top = 6
            Width = 100
            Height = 25
            Caption = '&Skift Status'
            TabOrder = 0
            OnClick = btnSkiftStatusClick
          end
          object btnBeskeder: TButton
            Left = 174
            Top = 6
            Width = 100
            Height = 25
            Caption = '&Besked'
            TabOrder = 1
            OnClick = btnBeskederClick
          end
          object btnSendKvit: TButton
            Left = 332
            Top = 6
            Width = 100
            Height = 25
            Caption = 'S&end Kvittering'
            TabOrder = 2
            OnClick = btnSendKvitClick
          end
          object btnPrint: TButton
            Left = 490
            Top = 6
            Width = 100
            Height = 25
            Caption = '&Udskriv Ordre'
            TabOrder = 3
            OnClick = btnPrintClick
          end
          object btnEHTakser: TButton
            Left = 644
            Top = 6
            Width = 100
            Height = 25
            Caption = '&Takser'
            TabOrder = 4
            OnClick = btnEHTakserClick
          end
        end
        object dbgEHOrd: TDBGrid
          Left = 1
          Top = 81
          Width = 794
          Height = 167
          Align = alTop
          DataSource = MainDm.dsOrd
          ReadOnly = True
          TabOrder = 2
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -13
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDrawColumnCell = dbgEHOrdDrawColumnCell
        end
        object Panel13: TPanel
          Left = 1
          Top = 248
          Width = 794
          Height = 41
          Align = alTop
          TabOrder = 3
        end
        object dbgEHLin: TDBGrid
          Left = 1
          Top = 289
          Width = 794
          Height = 93
          Align = alClient
          DataSource = MainDm.dsOrdLin
          ReadOnly = True
          TabOrder = 4
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -13
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'OrdinationType'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ReceptId'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'OrdinationsId'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Antal'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Varenummer'
              Title.Caption = 'Varenr'
              Width = 50
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Varenavn'
              Title.Caption = 'Navn'
              Width = 252
              Visible = True
            end>
        end
      end
    end
  end
  object C2ButPanel: TPanel
    Left = 0
    Top = 0
    Width = 804
    Height = 42
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      804
      42)
    object C2ButF5: TSpeedButton
      Tag = 1
      Left = 4
      Top = 1
      Width = 55
      Height = 40
      Action = acFkeysGem
      Flat = True
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333300003330000000000000000300003304440000000880440300003044
        4400000008804403000030444400000008804403000030444400000008804403
        0000304444000000088044030000304444000000000044030000304444444444
        4444440300003044444444444444440300003040000000000000040300003040
        7777777777770403000030407777777777770403000030407777777777770403
        0000304077777777777704030000304077777777777704030000304077777777
        7777040300003040777777777777070300003000000000000000000300003333
        33333333333333330000}
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
    end
    object C2ButF6: TSpeedButton
      Tag = 2
      Left = 59
      Top = 1
      Width = 55
      Height = 40
      Action = acFkeysRet
      Flat = True
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33333333000033333330000000000003000033333330FFFFFFFFFF0300003333
        3330FFFFFFFFFF030000000300000FFFFFFFFF0300004400BFBFB0FFFFFFFF03
        0000440BFBF00000F08F0F030000440FBFBFBFBF0B0FFF030000440BFBF00000
        B0FFFF030000440FBFBFBFBF0F0F0F030000440BF0000000FFFFFF0300000000
        BFB00B0FFF00FF03000033330000B0FFFFFFFF0300003333330B0FF00F000003
        0000333330B0FFFFFF0FF033000033330900F00F0F0F0333000033333030FFFF
        FF00333300003333333000000003333300003333333333333333333300003333
        33333333333333330000}
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
    end
    object C2ButF7: TSpeedButton
      Tag = 3
      Left = 114
      Top = 1
      Width = 55
      Height = 40
      Action = acFkeysOpret
      Flat = True
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333330000330000000000000000330000330FFFFFFFFFFFFFF0330000330F
        FFFFFFFFFFFFF0330000330FFFFFFFFFFFFFF0330000330FFFFFFFFFFFFFF033
        0000330FFFFFFFFFFFFFF0330000330FFFFFFFFFFFFFF0330000330FFFFFFFFF
        FFFFF0330000330FFFFFFFFFFFFFF0330000330FFFFFFFFFFFFFF0330000330F
        FFFFFFFFFFFFF0330000330FFFFFFFFFFFFFF0330000330FFFFFFFFF00000033
        0000330FFFFFFFFF0FFF03330000330FFFFFFFFF0FF033330000330FFFFFFFFF
        0F0333330000330FFFFFFFFF0033333300003300000000000333333300003333
        33333333333333330000}
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
    end
    object C2ButF8: TSpeedButton
      Tag = 4
      Left = 169
      Top = 1
      Width = 55
      Height = 40
      Action = acSletButton
      Flat = True
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333300003333333333300000333300003333333333333000330000003000
        0300033333300003000000000000333033333033000000330033303333333333
        0000033333003333303333330000333330110333330033330000300309991033
        3333003300003303099991033333333300003333309990B03333333300003303
        33090B0B03333333000033333330B0B0B03333330000333333330B0BBB033333
        00003333333330BBBBB03333000033333333330BBBBB03330000333333333330
        BBBBB03300003333333333330BBBBB03000033333333333330BB333300003333
        33333333333333330000}
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
    end
    object C2ButEsc: TSpeedButton
      Tag = 5
      Left = 225
      Top = 1
      Width = 55
      Height = 40
      Action = acFkeysFortryd
      Flat = True
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333300003333333303030333333300003333330333333303333300003333
        3333333333330333000033333333333333333333000033033333333333333033
        0000300033333333333333330000000003333333333333030000333333333333
        3333333300003303333333333333330300003333333333333333333300003303
        3333333333333303000033333333333333333333000033033333333333333303
        0000333333333333333333330000333033333333333330330000333333333333
        3333333300003333033333333333033300003333330333333303333300003333
        33330303033333330000}
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      Spacing = 0
    end
    object ButMenu: TSpeedButton
      Tag = 5
      Left = 323
      Top = 1
      Width = 55
      Height = 40
      Hint = 'V'#230'lg funktion fra menuer'
      Caption = '&Menu'
      Flat = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000120B0000120B00001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
        DADAADADADADADADADAD444444444444DADA477777777774ADAD488888888084
        DADA480080080004ADAD488888888000DADA4800800800B70DAD4888888880B8
        0ADA44444444440B70AD4F44F44F440B80DA444444444440B70DDADADADADAD0
        B70AADADADADADAD0050DADADADADADA0550ADADADADADADA00D}
      Layout = blGlyphTop
      ParentShowHint = False
      PopupMenu = FunkMenu
      ShowHint = True
      Spacing = 0
      OnClick = ButMenuClick
    end
    object lblTime: TLabel
      Left = 384
      Top = 0
      Width = 3
      Height = 13
    end
    object lblClockDate: TLabel
      Left = 384
      Top = 5
      Width = 160
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Layout = tlCenter
    end
    object lblClockTime: TLabel
      Left = 384
      Top = 24
      Width = 160
      Height = 13
      Alignment = taCenter
      AutoSize = False
    end
    object lblC2Q: TLabel
      Left = 378
      Top = -4
      Width = 145
      Height = 40
      Alignment = taCenter
      AutoSize = False
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    inline TC2QFrame1: TC2QFrame
      Left = 527
      Top = -4
      Width = 276
      Height = 56
      Anchors = [akRight, akBottom]
      TabOrder = 0
      ExplicitLeft = 527
      ExplicitTop = -4
      inherited pnlC2Qbuts: TPanel
        inherited bitRec: TSpeedButton
          OnClick = TC2QFrame1bitRecClick
        end
        inherited bitLukke: TSpeedButton
          Enabled = False
        end
      end
    end
  end
  object C2StatusPanel: TPanel
    Left = 0
    Top = 501
    Width = 804
    Height = 30
    Align = alBottom
    Caption = 'C2StatusPanel'
    TabOrder = 2
    object C2StatusBar: TStatusBar
      Left = 1
      Top = 1
      Width = 802
      Height = 28
      DoubleBuffered = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Panels = <
        item
          Style = psOwnerDraw
          Width = 120
        end
        item
          Alignment = taCenter
          Width = 70
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 350
        end
        item
          Alignment = taCenter
          Style = psOwnerDraw
          Width = 300
        end>
      ParentDoubleBuffered = False
      UseSystemFont = False
      OnDrawPanel = C2StatusBarDrawPanel
    end
  end
  object FunkMenu: TPopupMenu
    AutoPopup = False
    Left = 348
    Top = 203
    object MenuReRcp: TMenuItem
      Action = AcReRcp
    end
    object MenuEdiRcp: TMenuItem
      Action = AcEdiRcp
    end
    object MenuDosRcp: TMenuItem
      Action = AcDosKort
    end
    object akserEHandleOrdrer1: TMenuItem
      Action = acEHandle
      Caption = 'EHandel Ordre'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MenuGenEtiket: TMenuItem
      Action = AcGenEtiket
    end
    object MenuGenAfst: TMenuItem
      Action = AcGenAfst
    end
    object acGenBothEtiket1: TMenuItem
      Action = acGenBothEtiket
    end
    object MenuAfstemp: TMenuItem
      Action = AcUdsAfs
    end
    object MenuEtiket: TMenuItem
      Action = AcDosEtiket
    end
    object Navneetiket1: TMenuItem
      Action = acHldEtiket
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object MenuForsendelser: TMenuItem
      Action = AcBogfFraTil
    end
    object Udskrivfaktura1: TMenuItem
      Action = AcUdFaktFraTil
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Logafforbrugerskift2: TMenuItem
      Action = acSidKundeNr
    end
    object MenuTaksering: TMenuItem
      Action = AcTaksering
    end
    object InfertTaksering1: TMenuItem
      Action = acInfert
    end
    object BegyndBatchShiftCtrlB1: TMenuItem
      Action = acBegyndBatch
    end
    object Logafforbrugerskift1: TMenuItem
      Action = acLogOff
    end
    object MenuTakserUdenCtr: TMenuItem
      Action = acTakserUdenCtr
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object VisCTRBevllinger1: TMenuItem
      Action = acVisCTRBev
    end
    object HentFiktivtcprnr1: TMenuItem
      Action = AcHentFiktiv
    end
    object IndeberetCtr1: TMenuItem
      Action = acIndbCtr
    end
    object EfterregistrerCTRmedregel421: TMenuItem
      Action = acEfterReg
    end
    object MenuAfregning: TMenuItem
      Caption = '&M'#229'nedsafregning'
      ShortCut = 16461
      object meSpcKom: TMenuItem
        Caption = '&Regningsspecifikationer til kommunerne'
        OnClick = meSpcKomClick
      end
    end
    object MenUdskrifter: TMenuItem
      Caption = 'A&ndre udskrifter'
      ShortCut = 16462
      object meCtrListe: TMenuItem
        Action = AcUdCtrEkspListe
      end
      object UdskrivpatientermedCTRudligning1: TMenuItem
        Action = AcUdCtrUdlignListe
      end
      object meDosListe: TMenuItem
        Caption = 'Udskriv &doseringsliste'
        OnClick = meDosListeClick
      end
      object meAfslListe: TMenuItem
        Caption = 'Udskriv &afsluttede liste'
        OnClick = meAfslListeClick
      end
      object meNarkoListe: TMenuItem
        Caption = 'Udskriv uafsluttet &narkoliste'
        Enabled = False
        OnClick = meNarkoListeClick
      end
    end
    object MenuBevillinger: TMenuItem
      Caption = 'Medicin&kort og bevillinger'
      object Sletmedicinkortogbevillinger1: TMenuItem
        Action = AcSletMedk
      end
      object Udskrivmedicinkortogbevillinger1: TMenuItem
        Action = AcUdskrivMedk
      end
    end
    object MenuEanListe: TMenuItem
      Caption = 'Kommunernes EAN liste'
      object Opdatertilskudmedkommuneeannumre1: TMenuItem
        Action = acOpdaterKomEan
      end
      object Hentkommuneeannumre1: TMenuItem
        Action = acHentKomEan
      end
    end
    object Henstandsordning1: TMenuItem
      Action = acHenstandsOrdning
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Andet1: TMenuItem
      Caption = 'Andre funktioner'
      object AcOpdCtrSaldo1: TMenuItem
        Action = AcOpdCtrSaldo
      end
      object InteraktionerprATCkode1: TMenuItem
        Action = AcInterAkt
      end
    end
    object VisOpdaterCTRStatus1: TMenuItem
      Action = acOpdCTR
    end
    object VisReceptserverFejl1: TMenuItem
      Action = acRSEkspFejl
    end
    object VisRCPKontrolSide1: TMenuItem
      Action = acFejlForm
    end
    object AktiverDeaktiverCTR1: TMenuItem
      Action = acDebEkspKontrol
    end
    object Arkiverenkeltkundenummer1: TMenuItem
      Action = acArkiverKunde
    end
    object SearchRCPOrdinationsforVarenr1: TMenuItem
      Action = acRCPSearch
    end
    object SendKontrolSMS1: TMenuItem
      Action = acKontrolSMS
    end
  end
  object ActionList: TActionList
    Left = 372
    Top = 203
    object AcTaksering: TAction
      Category = 'Taksering'
      Caption = '&Taksering'
      ShortCut = 16468
      OnExecute = MenuTakseringClick
    end
    object AcReRcp: TAction
      Category = 'Taksering'
      Caption = '&Reitereret recept'
      ShortCut = 16466
      OnExecute = MenuReRcpClick
    end
    object AcBogfFraTil: TAction
      Category = 'Fakturering'
      Caption = '&Bogf'#248'r og udskriv faktura(er)'
      ShortCut = 16450
      OnExecute = MenuBogfFraTilClick
    end
    object AcDosEtiket: TAction
      Category = 'Taksering'
      Caption = '&Doseringsetiket'
      ShortCut = 16452
      OnExecute = MenuDosEtiketClick
    end
    object AcGenEtiket: TAction
      Category = 'Taksering'
      Caption = '&Genskriv etiket(ter)'
      ShortCut = 16455
      OnExecute = MenuGenEtiketClick
    end
    object AcGenAfst: TAction
      Category = 'Taksering'
      Caption = 'Genskriv &afstempling'
      ShortCut = 16449
      OnExecute = MenuGenAfstClick
    end
    object AcUdFaktFraTil: TAction
      Category = 'Fakturering'
      Caption = '&Udskriv fakturakopi(er)'
      ShortCut = 16469
      OnExecute = AcUdFaktFraTilExecute
    end
    object AcHentFiktiv: TAction
      Category = 'Taksering'
      Caption = 'Hent &Fiktivt cprnr'
      ShortCut = 16454
      OnExecute = AcHentFiktivExecute
    end
    object AcUdEkspListe: TAction
      Category = 'Taksering'
      Caption = '&Eksp.liste'
    end
    object AcHentCtrStatus: TAction
      Category = 'Taksering'
      Caption = 'Hent CTR &status'
      OnExecute = AcHentCtrStatusExecute
    end
    object AcUdskrivMedk: TAction
      Category = 'Medicinkort'
      Caption = 'Udskriv medicinkort og bevillinger'
      OnExecute = AcUdskrivMedkExecute
    end
    object AcOpdCtrSaldo: TAction
      Category = 'Taksering'
      Caption = 'Opdater lokal saldo fra CTR'
      OnExecute = AcOpdCtrSaldoExecute
    end
    object AcUdCtrEkspListe: TAction
      Category = 'Taksering'
      Caption = 'Udskriv &CTR ekspeditioner'
    end
    object AcUdCtrUdlignListe: TAction
      Category = 'Taksering'
      Caption = 'Udskriv CTR &udligninger'
      Enabled = False
    end
    object AcSletMedk: TAction
      Category = 'Medicinkort'
      Caption = 'Slet medicinkort og bevillinger'
      OnExecute = AcSletMedkExecute
    end
    object AcAktiverCtr: TAction
      Category = 'Taksering'
      Caption = 'Aktiver/Deaktiver CTR'
      OnExecute = AcAktiverCtrExecute
    end
    object AcEdiRcp: TAction
      Category = 'Taksering'
      Caption = '&Edifact recepter'
      ShortCut = 16453
      OnExecute = AcEdiRcpExecute
    end
    object acLogOff: TAction
      Category = 'Taksering'
      Caption = '&Log af for brugerskift'
      ShortCut = 16460
      OnExecute = AcLogOffExecute
    end
    object acReportDesigner: TAction
      Category = 'Fakturering'
      Caption = 'acReportDesigner'
      ShortCut = 49220
      OnExecute = acReportDesignerExecute
    end
    object AcInterAkt: TAction
      Category = 'Taksering'
      Caption = 'Interaktioner pr. ATC-kode'
      OnExecute = AcInterAktExecute
    end
    object acSidKundeNr: TAction
      Category = 'Taksering'
      Caption = 'Forrige kundenummer'
      ShortCut = 16459
      OnExecute = acSidKundeNrExecute
    end
    object AcRcpKontrol: TAction
      Category = 'Taksering'
      Caption = '&Rcp. kontrol'
      OnExecute = AcRcpKontrolExecute
    end
    object AcHentDelta: TAction
      Category = 'Taksering'
      Caption = 'AcHentDelta'
      OnExecute = AcHentDeltaExecute
    end
    object acTilAddAtc: TAction
      Category = 'Tilskud'
      Caption = 'Tilf'#248'j &ATC kode'
    end
    object acTilAddVarenr: TAction
      Category = 'Tilskud'
      Caption = 'Tilf'#248'j &varenr'
    end
    object acTilAddProdukt: TAction
      Category = 'Tilskud'
      Caption = 'Tilf'#248'j &produkt'
    end
    object AcDosKort: TAction
      Category = 'Taksering'
      Caption = 'DosisKort recept'
      ShortCut = 16456
      OnExecute = AcDosKortExecute
    end
    object AcRetLager: TAction
      Category = 'Taksering'
      Caption = 'AcRetLager'
      ShortCut = 8315
      OnExecute = AcRetLagerExecute
    end
    object AcUdsAfs: TAction
      Category = 'Taksering'
      Caption = 'Afstemp. u. tilbagef'#248'rte linier'
      ShortCut = 16471
      OnExecute = MenuAfstempClick
    end
    object acHentKomEan: TAction
      Category = 'Tilskud'
      Caption = 'Hent nyeste kommune EAN liste'
      Enabled = False
    end
    object acOpdaterKomEan: TAction
      Category = 'Tilskud'
      Caption = 'Opdater tilskud med kommune EAN liste'
      OnExecute = acOpdaterKomEanExecute
    end
    object acRemoveStatus: TAction
      Caption = 'RemoveStatus'
      ShortCut = 49234
      OnExecute = acRemoveStatusExecute
    end
    object acVisCTRBev: TAction
      Category = 'Taksering'
      Caption = 'Vis CTR Bevillinger'
      ShortCut = 16467
      OnExecute = acVisCTRBevExecute
    end
    object acHldEtiket: TAction
      Category = 'Taksering'
      Caption = 'Navneetiket'
      ShortCut = 16464
      OnExecute = acHldEtiketExecute
    end
    object acUdRCP: TAction
      Caption = 'Print Receptkvittering'
      ShortCut = 49238
      OnExecute = acUdRCPExecute
    end
    object acTidy1: TAction
      Caption = 'Slet ikke ekspederede receptkvitteringer'
      OnExecute = acTidy1Execute
    end
    object acTidy2: TAction
      Caption = 'Slet ekspederede receptkvitteringer'
      OnExecute = acTidy2Execute
    end
    object acStregkodeKontrol: TAction
      Caption = 'Slut CITO ekspedition'
      ShortCut = 24659
      OnExecute = acStregkodeKontrolExecute
    end
    object acBegyndBatch: TAction
      Caption = 'Begynd CITO ekspedition'
      ShortCut = 24642
      OnExecute = acBegyndBatchExecute
    end
    object acIndbCtr: TAction
      Caption = 'Indberet Ctr'
      OnExecute = acIndbCtrExecute
    end
    object acFejlForm: TAction
      Category = 'Taksering'
      Caption = 'Vis RCP Kontrol Side'
      OnExecute = acFejlFormExecute
    end
    object acVisRS: TAction
      Caption = 'acVisRS'
      ShortCut = 32847
      OnExecute = acVisRSExecute
    end
    object acOpdCTR: TAction
      Caption = 'Vis OpdaterCTR Status'
      OnExecute = acOpdCTRExecute
    end
    object acDebEkspKontrol: TAction
      Caption = 'Vis manglende kontrol p'#229' eksp. med konto.'
      ShortCut = 16462
      OnExecute = acDebEkspKontrolExecute
    end
    object acRetYdernr: TAction
      Caption = 'Ret YderNr / AutNr'
      ShortCut = 16473
      OnExecute = acRetYdernrExecute
    end
    object acGenBothEtiket: TAction
      Category = 'Taksering'
      Caption = 'Genskriv etiket(ter) &og afstempling'
      ShortCut = 16463
      OnExecute = acGenBothEtiketExecute
    end
    object acInfert: TAction
      Category = 'Taksering'
      Caption = 'Taksering infertilitet'
      Enabled = False
      ShortCut = 16457
      Visible = False
    end
    object acArkiverKunde: TAction
      Caption = 'Arkiver enkelt kundenummer'
      OnExecute = acArkiverKundeExecute
    end
    object acEfterReg: TAction
      Caption = 'Efterregistrer CTR med regel 42 / terminal'
      ShortCut = 24643
      OnExecute = acEfterRegExecute
    end
    object acEHandle: TAction
      Category = 'Taksering'
      Caption = 'Takser EHandle Ordrer'
      ShortCut = 24645
      OnExecute = acEHandleExecute
    end
    object acRCPSearch: TAction
      Caption = 'Find varenr fra lokale receptkvitteringer'
      OnExecute = acRCPSearchExecute
    end
    object acSendSMS: TAction
      Caption = 'Send SMS'
      OnExecute = acSendSMSExecute
    end
    object acKontrolSMS: TAction
      Caption = 'Send SMS - Uafhentet medicin'
      OnExecute = acKontrolSMSExecute
    end
    object acRSEkspFejl: TAction
      Caption = 'Vis FMK Fejl'
      OnExecute = acRSEkspFejlExecute
    end
    object acHenstandsOrdning: TAction
      Caption = 'Henstandsordning'
      OnExecute = acHenstandsOrdningExecute
    end
    object acTestMess: TAction
      Caption = 'acTestMess'
      ShortCut = 49217
      OnExecute = acTestMessExecute
    end
    object acTakserUdenCtr: TAction
      Category = 'Taksering'
      Caption = 'Takser uden Ctr'
      OnExecute = acTakserUdenCtrExecute
    end
  end
  object odRave: TOpenDialog
    DefaultExt = 'rav'
    Filter = 'Rave rapporter|*.rav'
    Title = 'Rapporter'
    Left = 308
    Top = 203
  end
  object CtrTimer: TTimer
    Interval = 30000
    OnTimer = CtrTimerTimer
    Left = 404
    Top = 202
  end
  object TilMenu: TPopupMenu
    Left = 436
    Top = 202
    object ilfjATCkode1: TMenuItem
      Action = acTilAddAtc
    end
    object ilfjvarenr1: TMenuItem
      Action = acTilAddVarenr
    end
    object ilfjprodukt1: TMenuItem
      Action = acTilAddProdukt
    end
  end
  object PopupUdMenu: TPopupMenu
    Left = 468
    Top = 202
    object UdskrivPakke1: TMenuItem
      Caption = 'Udskriv Pakke'
      OnClick = butUdPakkeClick
    end
    object UdskrivFaktura2: TMenuItem
      Caption = 'Udskriv Faktura'
      OnClick = butUdFaktClick
    end
    object UdskrivLeveringsliste1: TMenuItem
      Caption = 'Udskriv Leveringsliste'
      OnClick = ButUdTurLstClick
    end
    object UdskrivKortLeveringsliste1: TMenuItem
      Caption = 'Udskriv Kort Leveringsliste'
      OnClick = ButUdTurLst2Click
    end
    object UdskrivBudliste1: TMenuItem
      Caption = 'Udskriv Budliste'
      OnClick = ButUdPakLstClick
    end
    object UdskrivPrislabels2: TMenuItem
      Caption = 'Udskriv Prislabels'
      OnClick = ButKonPrisClick
    end
    object Nyleveringslite1: TMenuItem
      Caption = 'Ny leveringslite'
      Visible = False
      OnClick = ButUdTurLst2Click
    end
    object MnuReprintleveringslist1: TMenuItem
      Caption = 'Genudskriv Leveringsliste'
      OnClick = MnuReprintleveringslist1Click
    end
    object MnuGenudskrivKortLeveringsliste: TMenuItem
      Caption = 'Genudskriv Kort Leveringsliste'
      OnClick = MnuGenudskrivKortLeveringslisteClick
    end
  end
  object timClock: TTimer
    Interval = 10000
    OnTimer = timClockTimer
    Left = 268
    Top = 202
  end
  object TidyMenu: TPopupMenu
    Left = 532
    Top = 202
    object DeleteOldOpenPrescriptions1: TMenuItem
      Action = acTidy1
    end
    object DeleteOldClosedEkspedtioner1: TMenuItem
      Action = acTidy2
    end
  end
  object RPEHPrint: TRvSystem
    TitleSetup = 'Output Options'
    TitleStatus = 'Report Status'
    TitlePreview = 'Report Preview'
    SystemFiler.FileName = 'test.ndr'
    SystemFiler.StatusFormat = 'Generating page %p'
    SystemFiler.StreamMode = smFile
    SystemPreview.ZoomFactor = 100.000000000000000000
    SystemPrinter.LineHeightMethod = lhmLinesPerInch
    SystemPrinter.ScaleX = 100.000000000000000000
    SystemPrinter.ScaleY = 100.000000000000000000
    SystemPrinter.StatusFormat = 'Printing page %p'
    SystemPrinter.Title = 'Rave Report'
    SystemPrinter.UnitsFactor = 1.000000000000000000
    OnPrint = RPEHPrintPrint
    Left = 616
    Top = 192
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 504
    Top = 200
  end
  object dxAlertWindowManager1: TdxAlertWindowManager
    OptionsBehavior.DisplayTime = 170000
    OptionsButtons.Buttons = <>
    OptionsCaptionButtons.CaptionButtons = [awcbClose]
    OptionsMessage.Caption.Font.Charset = DEFAULT_CHARSET
    OptionsMessage.Caption.Font.Color = clWindowText
    OptionsMessage.Caption.Font.Height = -13
    OptionsMessage.Caption.Font.Name = 'Tahoma'
    OptionsMessage.Caption.Font.Style = [fsBold]
    OptionsMessage.Text.Font.Charset = DEFAULT_CHARSET
    OptionsMessage.Text.Font.Color = clWindowText
    OptionsMessage.Text.Font.Height = -11
    OptionsMessage.Text.Font.Name = 'Tahoma'
    OptionsMessage.Text.Font.Style = []
    OptionsNavigationPanel.Font.Charset = DEFAULT_CHARSET
    OptionsNavigationPanel.Font.Color = clWindowText
    OptionsNavigationPanel.Font.Height = -11
    OptionsNavigationPanel.Font.Name = 'Tahoma'
    OptionsNavigationPanel.Font.Style = []
    Left = 664
    Top = 192
    PixelsPerInch = 96
  end
  object ActionManager1: TActionManager
    Left = 604
    Top = 73
    StyleName = 'Platform Default'
    object acFkeysGem: TAction
      Category = 'Edit Keys'
      Caption = 'Gem [F5]'
      ShortCut = 116
      OnExecute = acFkeysGemExecute
      OnUpdate = acFkeysGemUpdate
    end
    object acFkeysRet: TAction
      Category = 'Edit Keys'
      Caption = 'Ret [F6]'
      ShortCut = 117
      OnExecute = acFkeysRetExecute
      OnUpdate = acFkeysRetUpdate
    end
    object acFkeysOpret: TAction
      Category = 'Edit Keys'
      Caption = 'Opret [F7]'
      ShortCut = 118
      OnExecute = acFkeysOpretExecute
      OnUpdate = acFkeysOpretUpdate
    end
    object acFkeysSlet: TAction
      Category = 'Edit Keys'
      Caption = 'Slet [F8]'
      ShortCut = 119
      OnExecute = acFkeysSletExecute
      OnUpdate = acFkeysSletUpdate
    end
    object acTabKartotek: TAction
      Category = 'Tab Switches'
      Caption = 'Kartotek'
      ShortCut = 16496
      OnExecute = acTabKartotekExecute
    end
    object acTabTilskud: TAction
      Category = 'Tab Switches'
      Caption = 'acTabTilskud'
      ShortCut = 16497
      OnExecute = acTabTilskudExecute
    end
    object acTabEksp: TAction
      Category = 'Tab Switches'
      Caption = 'Eksp'
      ShortCut = 16498
      OnExecute = acTabEkspExecute
    end
    object acTabUaf: TAction
      Category = 'Tab Switches'
      Caption = 'Uaf'
      ShortCut = 16499
      OnExecute = acTabUafExecute
    end
    object acTabReceptserver: TAction
      Category = 'Tab Switches'
      Caption = 'Receptserver'
      ShortCut = 16500
      OnExecute = acTabReceptserverExecute
    end
    object acTabLokale: TAction
      Category = 'Tab Switches'
      Caption = 'Lokale receptserver'
      ShortCut = 16501
      OnExecute = acTabLokaleExecute
    end
    object acTabFaktura: TAction
      Category = 'Tab Switches'
      Caption = 'Faktura'
      ShortCut = 16502
      OnExecute = acTabFakturaExecute
    end
    object acTabEhandel: TAction
      Category = 'Tab Switches'
      Caption = 'Ehandel'
      ShortCut = 16503
      OnExecute = acTabEhandelExecute
    end
    object acAltDown: TAction
      Caption = 'acAltDown'
      ShortCut = 32808
      OnExecute = acAltDownExecute
    end
    object acFkeysFortryd: TAction
      Category = 'Edit Keys'
      Caption = 'Fortryd'
      ShortCut = 27
      OnExecute = acFkeysFortrydExecute
      OnUpdate = acFkeysFortrydUpdate
    end
    object acStdSlet: TAction
      Category = 'Edit Keys'
      Caption = 'STD Slet'
      ShortCut = 8311
      OnExecute = acStdSletExecute
      OnUpdate = acStdSletUpdate
    end
    object acSletButton: TAction
      Category = 'Edit Keys'
      Caption = 'Slet [F8]'
      OnExecute = acSletButtonExecute
      OnUpdate = acSletButtonUpdate
    end
    object acLevlisteBon: TAction
      Category = 'CF7'
      Caption = 'Udle&v. DMVS'
      OnExecute = acLevlisteBonExecute
    end
    object acUdlevDMVSLevliste: TAction
      Caption = 'Udlev DMVS levliste.'
      OnExecute = acUdlevDMVSLevlisteExecute
    end
    object acTilskudRegel: TAction
      Category = 'CF2'
      Caption = 'Tilskud Regel Speedbutton'
      OnExecute = acTilskudRegelExecute
    end
    object acTilskudEankode: TAction
      Category = 'CF2'
      Caption = 'Tilskud Eankode Speedbutton'
      OnExecute = acTilskudEankodeExecute
    end
    object acTilskudVare: TAction
      Category = 'CF2'
      Caption = 'Tilskud Vare Speedbutton'
      OnExecute = acTilskudVareExecute
    end
    object acCF3Find: TAction
      Category = 'CF3'
      Caption = '&Find'
      OnExecute = acCF3FindExecute
    end
    object acCF3VisEtiket: TAction
      Category = 'CF3'
      Caption = '&Vis etiket'
      OnExecute = acCF3VisEtiketExecute
    end
    object acCF3SendRS: TAction
      Category = 'CF3'
      Caption = '&Send FMK'
      OnExecute = acCF3SendRSExecute
    end
    object acCF3Tilbage: TAction
      Category = 'CF3'
      Caption = '&Tilbagef'#248'r'
      OnExecute = acCF3TilbageExecute
    end
    object AcCF3UdEkspListe: TAction
      Category = 'CF3'
      Caption = '&Eksp.liste'
      OnExecute = AcCF3UdEkspListeExecute
    end
    object AcCF3UdCtrEkspListe: TAction
      Category = 'CF3'
      Caption = '&Ctr eksp.liste'
      OnExecute = AcCF3UdCtrEkspListeExecute
    end
    object acCF4FindUaf: TAction
      Category = 'CF4'
      Caption = '&Find l'#248'benr'
      OnExecute = acCF4FindUafExecute
    end
    object acCF4RetKonto: TAction
      Category = 'CF4'
      Caption = '&Ret kontonr'
      OnExecute = acCF4RetKontoExecute
    end
    object acCF4Levnr: TAction
      Category = 'CF4'
      Caption = 'Ret L&ev.nr'
      OnExecute = acCF4LevnrExecute
    end
    object acCF4NyPakke: TAction
      Category = 'CF4'
      Caption = 'Udsk. &pakke'
      OnExecute = acCF4NyPakkeExecute
    end
    object acCF4UdUaf: TAction
      Category = 'CF4'
      Caption = '&Udskriv'
      OnExecute = acCF4UdUafExecute
    end
    object acCF4RetYdernr: TAction
      Category = 'CF4'
      Caption = 'Re&t YderNr / AutNr'
      OnExecute = acCF4RetYdernrExecute
    end
    object acSoegCPR: TAction
      Category = 'CF5'
      Caption = '&S'#248'g CPR'
      OnExecute = acSoegCPRExecute
      OnUpdate = acSoegCPRUpdate
    end
    object acHentOrdination: TAction
      Category = 'CF5'
      Caption = '&Hent recepter'
      OnExecute = acHentOrdinationExecute
      OnUpdate = acHentOrdinationUpdate
    end
    object acVisDDKort: TAction
      Caption = 'Vis DD-kort'
      OnExecute = acVisDDKortExecute
      OnUpdate = acVisDDKortUpdate
    end
    object acUndoEffectuation: TAction
      Caption = 'UndoEffectuation'
      Enabled = False
      ShortCut = 49237
      OnExecute = acUndoEffectuationExecute
    end
  end
  object DMVSMenu: TPopupMenu
    Left = 276
    Top = 257
    object UdlevDMVSlevliste2: TMenuItem
      Action = acLevlisteBon
    end
    object UdlevDMVSlevliste3: TMenuItem
      Action = acUdlevDMVSLevliste
    end
  end
end
