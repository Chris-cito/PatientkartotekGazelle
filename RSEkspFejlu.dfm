object frmRSEkspFejl: TfrmRSEkspFejl
  Left = 0
  Top = 0
  Caption = 'FMK Fejl'
  ClientHeight = 683
  ClientWidth = 924
  Color = clBtnFace
  Constraints.MinHeight = 500
  Constraints.MinWidth = 700
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 924
    Height = 683
    Align = alClient
    TabOrder = 0
    AutoSize = True
    ShowDesignSelectors = False
    HighlightRoot = False
    object cxGrid1: TcxGrid
      Left = 10
      Top = 10
      Width = 904
      Height = 632
      TabOrder = 0
      LookAndFeel.NativeStyle = True
      object cxGrid1DBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        DataController.DataSource = dsEkspFejl
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.CellAutoHeight = True
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        object cxGrid1DBTableView1reqtype: TcxGridDBColumn
          Caption = 'Type'
          DataBinding.FieldName = 'reqtype'
        end
        object cxGrid1DBTableView1Lbnr: TcxGridDBColumn
          DataBinding.FieldName = 'Lbnr'
        end
        object cxGrid1DBTableView1Linienr: TcxGridDBColumn
          DataBinding.FieldName = 'Linienr'
        end
        object cxGrid1DBTableView1TakserBruger: TcxGridDBColumn
          Caption = 'Takser'
          DataBinding.FieldName = 'BrugerTakser'
        end
        object cxGrid1DBTableView1Afslut: TcxGridDBColumn
          DataBinding.FieldName = 'Afslut'
        end
        object cxGrid1DBTableView1OrdinationId: TcxGridDBColumn
          Caption = 'OrdinationsID'
          DataBinding.FieldName = 'OrdinationId'
          Width = 127
        end
        object cxGrid1DBTableView1ErrorKode: TcxGridDBColumn
          Caption = 'Fejlkode'
          DataBinding.FieldName = 'ErrorKode'
        end
        object cxGrid1DBTableView1ErrorDetails: TcxGridDBColumn
          Caption = 'Fejltekst'
          DataBinding.FieldName = 'ErrorDetails'
          PropertiesClassName = 'TcxMemoProperties'
          Properties.VisibleLineCount = 5
          Width = 239
        end
        object cxGrid1DBTableView1Dato: TcxGridDBColumn
          DataBinding.FieldName = 'Dato'
        end
      end
      object cxGrid1Level1: TcxGridLevel
        GridView = cxGrid1DBTableView1
      end
    end
    object btnSlet: TButton
      Left = 10
      Top = 648
      Width = 75
      Height = 25
      Caption = '&Slet'
      TabOrder = 1
      OnClick = btnSletClick
    end
    object btnRet: TButton
      Left = 191
      Top = 648
      Width = 75
      Height = 25
      Caption = '&Ret'
      TabOrder = 2
      OnClick = btnRetClick
    end
    object Button3: TButton
      Left = 839
      Top = 648
      Width = 75
      Height = 25
      Caption = '&Afslut'
      TabOrder = 4
      OnClick = Button3Click
    end
    object Udskriv: TButton
      Left = 658
      Top = 648
      Width = 75
      Height = 25
      Caption = '&Udskriv'
      TabOrder = 3
      OnClick = UdskrivClick
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object dxLayoutControl1Group1: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item1: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      AlignHorz = ahClient
      AlignVert = avClient
      Control = cxGrid1
      ControlOptions.OriginalHeight = 626
      ControlOptions.OriginalWidth = 853
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Group2: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      AlignHorz = ahClient
      AlignVert = avBottom
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Item2: TdxLayoutItem
      Parent = dxLayoutControl1Group2
      AlignHorz = ahLeft
      Padding.Right = 50
      Padding.AssignedValues = [lpavLeft, lpavRight]
      CaptionOptions.Text = 'Button1'
      CaptionOptions.Visible = False
      Control = btnSlet
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item3: TdxLayoutItem
      Parent = dxLayoutControl1Group2
      AlignHorz = ahLeft
      Padding.Left = 50
      Padding.Right = 25
      Padding.AssignedValues = [lpavLeft, lpavRight]
      CaptionOptions.Text = 'Button2'
      CaptionOptions.Visible = False
      Control = btnRet
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Item4: TdxLayoutItem
      Parent = dxLayoutControl1Group2
      AlignHorz = ahRight
      Padding.Left = 50
      Padding.AssignedValues = [lpavLeft]
      CaptionOptions.Text = 'Button3'
      CaptionOptions.Visible = False
      Control = Button3
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutControl1Item5: TdxLayoutItem
      Parent = dxLayoutControl1Group2
      AlignHorz = ahRight
      Padding.Left = 25
      Padding.Right = 50
      Padding.AssignedValues = [lpavLeft, lpavRight]
      CaptionOptions.Text = 'Button2'
      CaptionOptions.Visible = False
      Control = Udskriv
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 2
    end
  end
  object dsEkspFejl: TDataSource
    AutoEdit = False
    DataSet = tblRS_EkspQueueFejl1
    Left = 384
    Top = 144
  end
  object tblRS_EkspQueueFejl1: TnxTable
    ActiveRuntime = True
    Session = MainDm.nxSess
    AliasName = 'PRODUKTION'
    AfterScroll = tblRS_EkspQueueFejl1AfterScroll
    TableName = 'RS_EkspQueueFejl'
    Left = 448
    Top = 160
    object tblRS_EkspQueueFejl1reqtype: TStringField
      FieldName = 'reqtype'
      OnGetText = tblRS_EkspQueueFejl1reqtypeGetText
    end
    object tblRS_EkspQueueFejl1Lbnr: TIntegerField
      FieldName = 'Lbnr'
    end
    object tblRS_EkspQueueFejl1Linienr: TIntegerField
      FieldName = 'Linienr'
    end
    object tblRS_EkspQueueFejl1BrugerTakser: TIntegerField
      FieldKind = fkLookup
      FieldName = 'BrugerTakser'
      LookupDataSet = tblEkspeditioner
      LookupKeyFields = 'LbNr'
      LookupResultField = 'BrugerTakser'
      KeyFields = 'Lbnr'
      Lookup = True
    end
    object tblRS_EkspQueueFejl1OrdinationId: TLargeintField
      FieldName = 'OrdinationId'
    end
    object tblRS_EkspQueueFejl1ErrorKode: TIntegerField
      FieldName = 'ErrorKode'
    end
    object tblRS_EkspQueueFejl1ErrorDesc: TStringField
      FieldName = 'ErrorDesc'
      Size = 100
    end
    object tblRS_EkspQueueFejl1ErrorDetails: TnxMemoField
      FieldName = 'ErrorDetails'
      BlobType = ftMemo
    end
    object tblRS_EkspQueueFejl1Dato: TDateTimeField
      FieldName = 'Dato'
    end
    object tblRS_EkspQueueFejl1Afslut: TIntegerField
      FieldKind = fkLookup
      FieldName = 'Afslut'
      LookupDataSet = tblEkspeditioner
      LookupKeyFields = 'LbNr'
      LookupResultField = 'BrugerAfslut'
      KeyFields = 'Lbnr'
      Lookup = True
    end
  end
  object dxComponentPrinter1: TdxComponentPrinter
    CurrentLink = dxComponentPrinter1Link1
    Version = 0
    Left = 632
    Top = 176
    PixelsPerInch = 96
    object dxComponentPrinter1Link1: TdxGridReportLink
      Active = True
      Component = cxGrid1
      PrinterPage.DMPaper = 9
      PrinterPage.Footer = 6350
      PrinterPage.GrayShading = True
      PrinterPage.Header = 6350
      PrinterPage.Margins.Bottom = 12700
      PrinterPage.Margins.Left = 12700
      PrinterPage.Margins.Right = 12700
      PrinterPage.Margins.Top = 12700
      PrinterPage.Orientation = poLandscape
      PrinterPage.PageSize.X = 210000
      PrinterPage.PageSize.Y = 297000
      PrinterPage._dxMeasurementUnits_ = 0
      PrinterPage._dxLastMU_ = 2
      ReportDocument.CreationDate = 45497.475847592590000000
      OptionsOnEveryPage.Footers = False
      OptionsOnEveryPage.FilterBar = False
      OptionsView.FilterBar = False
      PixelsPerInch = 96
      BuiltInReportLink = True
    end
  end
  object tblEkspeditioner: TnxTable
    Session = MainDm.nxSess
    AliasName = 'Produktion'
    TableName = 'Ekspeditioner'
    Left = 544
    Top = 160
    object tblEkspeditionerLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object tblEkspeditionerBrugerTakser: TWordField
      FieldName = 'BrugerTakser'
    end
    object tblEkspeditionerTurNr: TIntegerField
      FieldName = 'TurNr'
    end
    object tblEkspeditionerPakkeNr: TIntegerField
      FieldName = 'PakkeNr'
    end
    object tblEkspeditionerFakturaNr: TIntegerField
      FieldName = 'FakturaNr'
    end
    object tblEkspeditionerUdlignNr: TIntegerField
      FieldName = 'UdlignNr'
    end
    object tblEkspeditionerKundeNr: TStringField
      FieldName = 'KundeNr'
    end
    object tblEkspeditionerFiktivtCprNr: TBooleanField
      FieldName = 'FiktivtCprNr'
    end
    object tblEkspeditionerCprCheck: TBooleanField
      FieldName = 'CprCheck'
    end
    object tblEkspeditionerNettoPriser: TBooleanField
      FieldName = 'NettoPriser'
    end
    object tblEkspeditionerEjSubstitution: TBooleanField
      FieldName = 'EjSubstitution'
    end
    object tblEkspeditionerBarn: TBooleanField
      FieldName = 'Barn'
    end
    object tblEkspeditionerKundeKlub: TBooleanField
      FieldName = 'KundeKlub'
    end
    object tblEkspeditionerKlubNr: TIntegerField
      FieldName = 'KlubNr'
    end
    object tblEkspeditionerAmt: TWordField
      FieldName = 'Amt'
    end
    object tblEkspeditionerKommune: TWordField
      FieldName = 'Kommune'
    end
    object tblEkspeditionerKundeType: TWordField
      FieldName = 'KundeType'
    end
    object tblEkspeditionerLandeKode: TWordField
      FieldName = 'LandeKode'
    end
    object tblEkspeditionerCtrType: TWordField
      FieldName = 'CtrType'
    end
    object tblEkspeditionerCtrIndberettet: TWordField
      FieldName = 'CtrIndberettet'
    end
    object tblEkspeditionerAlder: TSmallintField
      FieldName = 'Alder'
    end
    object tblEkspeditionerFoedDato: TStringField
      FieldName = 'FoedDato'
      Size = 8
    end
    object tblEkspeditionerNarkoNr: TStringField
      FieldName = 'NarkoNr'
      Size = 10
    end
    object tblEkspeditionerOrdreType: TWordField
      FieldName = 'OrdreType'
    end
    object tblEkspeditionerOrdreStatus: TWordField
      FieldName = 'OrdreStatus'
    end
    object tblEkspeditionerReceptStatus: TWordField
      FieldName = 'ReceptStatus'
    end
    object tblEkspeditionerEkspType: TWordField
      FieldName = 'EkspType'
    end
    object tblEkspeditionerEkspForm: TWordField
      FieldName = 'EkspForm'
    end
    object tblEkspeditionerDosStyring: TBooleanField
      FieldName = 'DosStyring'
    end
    object tblEkspeditionerIndikStyring: TBooleanField
      FieldName = 'IndikStyring'
    end
    object tblEkspeditionerAntLin: TWordField
      FieldName = 'AntLin'
    end
    object tblEkspeditionerAntVarer: TWordField
      FieldName = 'AntVarer'
    end
    object tblEkspeditionerDKMedlem: TWordField
      FieldName = 'DKMedlem'
    end
    object tblEkspeditionerDKAnt: TWordField
      FieldName = 'DKAnt'
    end
    object tblEkspeditionerDKIndberettet: TWordField
      FieldName = 'DKIndberettet'
    end
    object tblEkspeditionerReceptDato: TDateTimeField
      FieldName = 'ReceptDato'
    end
    object tblEkspeditionerOrdreDato: TDateTimeField
      FieldName = 'OrdreDato'
    end
    object tblEkspeditionerTakserDato: TDateTimeField
      FieldName = 'TakserDato'
    end
    object tblEkspeditionerKontrolDato: TDateTimeField
      FieldName = 'KontrolDato'
    end
    object tblEkspeditionerAfsluttetDato: TDateTimeField
      FieldName = 'AfsluttetDato'
    end
    object tblEkspeditionerForfaldsdato: TDateTimeField
      FieldName = 'Forfaldsdato'
    end
    object tblEkspeditionerBrugerKontrol: TWordField
      FieldName = 'BrugerKontrol'
    end
    object tblEkspeditionerBrugerAfslut: TWordField
      FieldName = 'BrugerAfslut'
    end
    object tblEkspeditionerKontrolFejl: TWordField
      FieldName = 'KontrolFejl'
    end
    object tblEkspeditionerTitel: TStringField
      FieldName = 'Titel'
      Size = 30
    end
    object tblEkspeditionerNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object tblEkspeditionerAdr1: TStringField
      FieldName = 'Adr1'
      Size = 30
    end
    object tblEkspeditionerAdr2: TStringField
      FieldName = 'Adr2'
      Size = 30
    end
    object tblEkspeditionerPostNr: TStringField
      FieldName = 'PostNr'
    end
    object tblEkspeditionerLand: TStringField
      FieldName = 'Land'
      Size = 30
    end
    object tblEkspeditionerKontakt: TStringField
      FieldName = 'Kontakt'
      Size = 30
    end
    object tblEkspeditionerTlfNr: TStringField
      FieldName = 'TlfNr'
      Size = 30
    end
    object tblEkspeditionerTlfNr2: TStringField
      FieldName = 'TlfNr2'
      Size = 30
    end
    object tblEkspeditionerLevNavn: TStringField
      FieldName = 'LevNavn'
      Size = 30
    end
    object tblEkspeditionerLevAdr1: TStringField
      FieldName = 'LevAdr1'
      Size = 30
    end
    object tblEkspeditionerLevAdr2: TStringField
      FieldName = 'LevAdr2'
      Size = 30
    end
    object tblEkspeditionerLevPostNr: TStringField
      FieldName = 'LevPostNr'
    end
    object tblEkspeditionerLevLand: TStringField
      FieldName = 'LevLand'
      Size = 30
    end
    object tblEkspeditionerLevKontakt: TStringField
      FieldName = 'LevKontakt'
      Size = 30
    end
    object tblEkspeditionerLevTlfNr: TStringField
      FieldName = 'LevTlfNr'
      Size = 30
    end
    object tblEkspeditionerYderNr: TStringField
      FieldName = 'YderNr'
      Size = 10
    end
    object tblEkspeditionerYderCprNr: TStringField
      FieldName = 'YderCprNr'
      Size = 10
    end
    object tblEkspeditionerYderNavn: TStringField
      FieldName = 'YderNavn'
      Size = 30
    end
    object tblEkspeditionerYderTlfNr: TStringField
      FieldName = 'YderTlfNr'
      Size = 30
    end
    object tblEkspeditionerKontoNr: TStringField
      FieldName = 'KontoNr'
    end
    object tblEkspeditionerKontoNavn: TStringField
      FieldName = 'KontoNavn'
      Size = 30
    end
    object tblEkspeditionerKontoAdr1: TStringField
      FieldName = 'KontoAdr1'
      Size = 30
    end
    object tblEkspeditionerKontoAdr2: TStringField
      FieldName = 'KontoAdr2'
      Size = 30
    end
    object tblEkspeditionerKontoPostNr: TStringField
      FieldName = 'KontoPostNr'
    end
    object tblEkspeditionerKontoLand: TStringField
      FieldName = 'KontoLand'
      Size = 30
    end
    object tblEkspeditionerKontoKontakt: TStringField
      FieldName = 'KontoKontakt'
      Size = 30
    end
    object tblEkspeditionerKontoTlf: TStringField
      FieldName = 'KontoTlf'
      Size = 30
    end
    object tblEkspeditionerKontoGruppe: TWordField
      FieldName = 'KontoGruppe'
    end
    object tblEkspeditionerRabatGruppe: TWordField
      FieldName = 'RabatGruppe'
    end
    object tblEkspeditionerPrisGruppe: TWordField
      FieldName = 'PrisGruppe'
    end
    object tblEkspeditionerStatGruppe: TWordField
      FieldName = 'StatGruppe'
    end
    object tblEkspeditionerSprog: TWordField
      FieldName = 'Sprog'
    end
    object tblEkspeditionerAfdeling: TWordField
      FieldName = 'Afdeling'
    end
    object tblEkspeditionerLager: TWordField
      FieldName = 'Lager'
    end
    object tblEkspeditionerKreditForm: TWordField
      FieldName = 'KreditForm'
    end
    object tblEkspeditionerBetalingsForm: TWordField
      FieldName = 'BetalingsForm'
    end
    object tblEkspeditionerLeveringsForm: TWordField
      FieldName = 'LeveringsForm'
    end
    object tblEkspeditionerPakkeseddel: TWordField
      FieldName = 'Pakkeseddel'
    end
    object tblEkspeditionerFaktura: TWordField
      FieldName = 'Faktura'
    end
    object tblEkspeditionerBetalingskort: TWordField
      FieldName = 'Betalingskort'
    end
    object tblEkspeditionerLeveringsseddel: TWordField
      FieldName = 'Leveringsseddel'
    end
    object tblEkspeditionerAdrEtiket: TWordField
      FieldName = 'AdrEtiket'
    end
    object tblEkspeditionerVigtigBem: TnxMemoField
      FieldName = 'VigtigBem'
      BlobType = ftMemo
    end
    object tblEkspeditionerAfstempling: TnxMemoField
      FieldName = 'Afstempling'
      BlobType = ftMemo
    end
    object tblEkspeditionerBrutto: TCurrencyField
      FieldName = 'Brutto'
    end
    object tblEkspeditionerRabatLin: TCurrencyField
      FieldName = 'RabatLin'
    end
    object tblEkspeditionerRabatPct: TCurrencyField
      FieldName = 'RabatPct'
    end
    object tblEkspeditionerRabat: TCurrencyField
      FieldName = 'Rabat'
    end
    object tblEkspeditionerInclMoms: TBooleanField
      FieldName = 'InclMoms'
    end
    object tblEkspeditionerExMoms: TCurrencyField
      FieldName = 'ExMoms'
    end
    object tblEkspeditionerMomsPct: TCurrencyField
      FieldName = 'MomsPct'
    end
    object tblEkspeditionerMoms: TCurrencyField
      FieldName = 'Moms'
    end
    object tblEkspeditionerNetto: TCurrencyField
      FieldName = 'Netto'
    end
    object tblEkspeditionerTilskAmt: TCurrencyField
      FieldName = 'TilskAmt'
    end
    object tblEkspeditionerTilskKom: TCurrencyField
      FieldName = 'TilskKom'
    end
    object tblEkspeditionerDKTilsk: TCurrencyField
      FieldName = 'DKTilsk'
    end
    object tblEkspeditionerDKEjTilsk: TCurrencyField
      FieldName = 'DKEjTilsk'
    end
    object tblEkspeditionerOrdreNr: TIntegerField
      FieldName = 'OrdreNr'
    end
    object tblEkspeditionerLMSUdsteder: TStringField
      FieldName = 'LMSUdsteder'
      Size = 7
    end
    object tblEkspeditionerLMSModtager: TStringField
      FieldName = 'LMSModtager'
      Size = 10
    end
    object tblEkspeditionerEdbGebyr: TCurrencyField
      FieldName = 'EdbGebyr'
    end
    object tblEkspeditionerTlfGebyr: TCurrencyField
      FieldName = 'TlfGebyr'
    end
    object tblEkspeditionerUdbrGebyr: TCurrencyField
      FieldName = 'UdbrGebyr'
    end
    object tblEkspeditionerAndel: TCurrencyField
      FieldName = 'Andel'
    end
    object tblEkspeditionerCtrBel: TCurrencyField
      FieldName = 'CtrBel'
    end
    object tblEkspeditionerCtrSaldo: TCurrencyField
      FieldName = 'CtrSaldo'
    end
    object tblEkspeditionerRSQueueStatus: TIntegerField
      FieldName = 'RSQueueStatus'
    end
    object tblEkspeditionerReturdage: TWordField
      FieldName = 'Returdage'
    end
  end
end
