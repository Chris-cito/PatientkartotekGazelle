object MainDm: TMainDm
  OldCreateOrder = True
  OnCreate = MainDmCreate
  OnDestroy = MainDmDestroy
  Height = 778
  Width = 975
  object nxSess: TnxSession
    ActiveDesigntime = True
    ServerEngine = ffEngine
    Left = 741
    Top = 12
  end
  object cdCtrLan: TClientDataSet
    PersistDataPacket.Data = {
      5C0000009619E0BD0100000018000000030000000000030000005C00024E7202
      00010000000000094F7065726174696F6E010049000000010005574944544802
      0002001400044E61766E0100490000000100055749445448020002001E000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Nr'
        DataType = ftSmallint
      end
      item
        Name = 'Operation'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Navn'
        DataType = ftString
        Size = 30
      end>
    IndexDefs = <
      item
        Name = 'NrOrden'
        Fields = 'Nr'
      end
      item
        Name = 'NavnOrden'
        Fields = 'Navn'
      end>
    IndexName = 'NrOrden'
    Params = <>
    StoreDefs = True
    Left = 167
    Top = 520
    object cdCtrLanNr: TSmallintField
      FieldName = 'Nr'
    end
    object cdCtrLanNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
  end
  object dsCtrLan: TDataSource
    AutoEdit = False
    DataSet = cdCtrLan
    Left = 168
    Top = 569
  end
  object dsLevFrm: TDataSource
    AutoEdit = False
    DataSet = ffLevFrm
    Left = 795
    Top = 453
  end
  object ffPatKar: TnxTable
    Session = nxSess
    AliasName = 'PRODUKTION'
    BeforeInsert = ffPatKarBeforeInsert
    BeforeEdit = ffPatKarBeforeEdit
    BeforePost = ffPatKarBeforePost
    AfterScroll = AfterScroll
    AutoCalcFields = False
    TableName = 'PatientKartotek'
    IndexName = 'NrOrden'
    Left = 18
    Top = 11
    object ffPatKarKundeNr: TStringField
      DisplayLabel = 'Kundenr'
      DisplayWidth = 16
      FieldName = 'KundeNr'
    end
    object ffPatKarKundeType: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Type'
      DisplayWidth = 14
      FieldName = 'KundeType'
      Visible = False
      OnGetText = KundeTypeGetText
      OnSetText = KundeTypeSetText
    end
    object ffPatKarCprCheck: TBooleanField
      FieldName = 'CprCheck'
      Visible = False
    end
    object ffPatKarLandekode: TWordField
      FieldName = 'Landekode'
      Visible = False
    end
    object ffPatKarFiktivtCprNr: TBooleanField
      FieldName = 'FiktivtCprNr'
      Visible = False
    end
    object ffPatKarFoedDato: TStringField
      FieldName = 'FoedDato'
      Visible = False
      Size = 8
    end
    object ffPatKarBarn: TBooleanField
      FieldName = 'Barn'
      Visible = False
    end
    object ffPatKarNettoPriser: TBooleanField
      FieldName = 'NettoPriser'
      Visible = False
    end
    object ffPatKarDKMedlem: TWordField
      Alignment = taLeftJustify
      FieldName = 'DKMedlem'
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      Visible = False
      OnGetText = DKMedlemGetText
      OnSetText = DKMedlemSetText
    end
    object ffPatKarEjSubstitution: TBooleanField
      FieldName = 'EjSubstitution'
      Visible = False
    end
    object ffPatKarKommune: TWordField
      FieldName = 'Kommune'
      Visible = False
    end
    object ffPatKarAmt: TWordField
      FieldName = 'Amt'
      Visible = False
    end
    object ffPatKarInstans: TStringField
      FieldKind = fkLookup
      FieldName = 'Instans'
      LookupDataSet = ffInLst
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      KeyFields = 'Kommune'
      Visible = False
      Size = 30
      Lookup = True
    end
    object ffPatKarNavn: TStringField
      DisplayWidth = 32
      FieldName = 'Navn'
      Size = 30
    end
    object ffPatKarAdr1: TStringField
      FieldName = 'Adr1'
      Visible = False
      Size = 30
    end
    object ffPatKarAdr2: TStringField
      FieldName = 'Adr2'
      Visible = False
      Size = 30
    end
    object ffPatKarPostNr: TStringField
      FieldName = 'PostNr'
      Visible = False
    end
    object ffPatKarBy: TStringField
      FieldKind = fkLookup
      FieldName = 'By'
      LookupDataSet = ffPnLst
      LookupKeyFields = 'PostNr'
      LookupResultField = 'ByNavn'
      KeyFields = 'PostNr'
      Visible = False
      Size = 30
      Lookup = True
    end
    object ffPatKarTlfNr: TStringField
      FieldName = 'TlfNr'
      Visible = False
      Size = 30
    end
    object ffPatKarDebitorNr: TStringField
      FieldName = 'DebitorNr'
      Visible = False
    end
    object ffPatKarLuDebNavn: TStringField
      FieldKind = fkLookup
      FieldName = 'LuDebNavn'
      LookupDataSet = ffDebKar
      LookupKeyFields = 'KontoNr'
      LookupResultField = 'Navn'
      KeyFields = 'DebitorNr'
      Visible = False
      Size = 30
      Lookup = True
    end
    object ffPatKarLuDebSaldo: TCurrencyField
      DisplayLabel = 'Deb.saldo'
      FieldKind = fkLookup
      FieldName = 'LukDebSaldo'
      LookupDataSet = ffDebKar
      LookupKeyFields = 'KontoNr'
      LookupResultField = 'Saldo'
      KeyFields = 'DebitorNr'
      Visible = False
      DisplayFormat = '###,###,##0.00'
      Lookup = True
    end
    object ffPatKarLevNr: TStringField
      FieldName = 'LevNr'
      Visible = False
    end
    object ffPatKarLuLevNavn: TStringField
      FieldKind = fkLookup
      FieldName = 'LuLevNavn'
      LookupDataSet = ffDebKar
      LookupKeyFields = 'KontoNr'
      LookupResultField = 'Navn'
      KeyFields = 'LevNr'
      Visible = False
      Size = 30
      Lookup = True
    end
    object ffPatKarYderNr: TStringField
      FieldName = 'YderNr'
      Visible = False
      Size = 10
    end
    object ffPatKarYderCprNr: TStringField
      FieldName = 'YderCprNr'
      Visible = False
      Size = 10
    end
    object ffPatKarLuYdNavn: TStringField
      FieldKind = fkLookup
      FieldName = 'LuYdNavn'
      LookupDataSet = ffYdLst
      LookupKeyFields = 'YderNr;CprNr'
      LookupResultField = 'Navn'
      KeyFields = 'YderNr;YderCprNr'
      Visible = False
      Size = 30
      Lookup = True
    end
    object ffPatKarLmsModtager: TStringField
      FieldName = 'LmsModtager'
      Visible = False
      Size = 10
    end
    object ffPatKarRetDato: TDateTimeField
      DisplayLabel = 'Rettet'
      DisplayWidth = 10
      FieldName = 'RetDato'
      Visible = False
      DisplayFormat = 'DD-MM-YYYY'
    end
    object ffPatKarOpretDato: TDateTimeField
      DisplayLabel = 'Oprettet'
      DisplayWidth = 10
      FieldName = 'OpretDato'
      Visible = False
      DisplayFormat = 'DD-MM-YYYY'
    end
    object ffPatKarVigtigBem: TMemoField
      FieldName = 'VigtigBem'
      Visible = False
      BlobType = ftMemo
    end
    object ffPatKarEjCtrReg: TBooleanField
      FieldName = 'EjCtrReg'
      Visible = False
    end
    object ffPatKarCtrUdDato: TDateTimeField
      FieldName = 'CtrUdDato'
      Visible = False
      DisplayFormat = 'dd-mm-yyyy'
    end
    object ffPatKarCtrType: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Ctr type'
      FieldName = 'CtrType'
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      Visible = False
      OnGetText = CtrTypeGetText
      OnSetText = CtrTypeSetText
    end
    object ffPatKarCtrSaldo: TCurrencyField
      FieldName = 'CtrSaldo'
      Visible = False
      DisplayFormat = '###,###,##0.00'
    end
    object ffPatKarCtrStempel: TDateTimeField
      FieldName = 'CtrStempel'
      Visible = False
      DisplayFormat = 'dd-mm-yyyy hh:mm:ss'
    end
    object ffPatKarCtrUdlign: TCurrencyField
      FieldName = 'CtrUdlign'
      Visible = False
      DisplayFormat = '###,###,##0.00'
    end
    object ffPatKarCtrStatus: TSmallintField
      FieldName = 'CtrStatus'
      Visible = False
    end
    object ffPatKarKontakt: TStringField
      FieldName = 'Kontakt'
      Visible = False
      Size = 30
    end
    object ffPatKarLuPbs: TWordField
      FieldKind = fkLookup
      FieldName = 'LuPbs'
      LookupDataSet = ffDebKar
      LookupKeyFields = 'KontoNr'
      LookupResultField = 'BetalForm'
      KeyFields = 'DebitorNr'
      OnGetText = ffPatKarLuPbsGetText
      Lookup = True
    end
    object ffPatKarCtrUdDatoB: TDateTimeField
      FieldName = 'CtrUdDatoB'
      DisplayFormat = 'dd-mm-yyyy'
    end
    object ffPatKarCtrSaldoB: TCurrencyField
      FieldName = 'CtrSaldoB'
      DisplayFormat = '###,###,##0.00'
    end
    object ffPatKarCTRUdlignB: TCurrencyField
      FieldName = 'CTRUdlignB'
      DisplayFormat = '###,###,##0.00'
    end
    object ffPatKarMobil: TStringField
      FieldName = 'Mobil'
      Size = 30
    end
  end
  object ffYdLst: TnxTable
    AutoCalcFields = False
    TableName = 'YderKartotek'
    IndexName = 'YderNrOrden'
    Left = 164
    Top = 11
    object ffYdLstYderNr: TStringField
      DisplayLabel = 'Yder.nr'
      DisplayWidth = 7
      FieldName = 'YderNr'
      Size = 10
    end
    object ffYdLstCprNr: TStringField
      DisplayLabel = 'Cpr.nr'
      FieldName = 'CprNr'
      Size = 10
    end
    object ffYdLstNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object ffYdLstTlfNr: TStringField
      FieldName = 'TlfNr'
      Visible = False
      Size = 30
    end
  end
  object dsPatKar: TDataSource
    AutoEdit = False
    DataSet = ffPatKar
    OnStateChange = dsStateChange
    Left = 18
    Top = 57
  end
  object dsYdLst: TDataSource
    AutoEdit = False
    DataSet = ffYdLst
    Left = 164
    Top = 61
  end
  object dsPnLst: TDataSource
    AutoEdit = False
    DataSet = ffPnLst
    Left = 116
    Top = 568
  end
  object dsKar: TDataSource
    AutoEdit = False
    Left = 789
    Top = 11
  end
  object ffInLst: TnxTable
    AutoCalcFields = False
    TableName = 'InstansKartotek'
    IndexName = 'NrOrden'
    Left = 262
    Top = 11
    object ffInLstNr: TWordField
      DisplayLabel = 'Kommune'
      DisplayWidth = 10
      FieldName = 'Nr'
    end
    object ffInLstAmtNr: TWordField
      DisplayLabel = 'Amt'
      DisplayWidth = 4
      FieldName = 'AmtNr'
    end
    object ffInLstNavn: TStringField
      DisplayWidth = 36
      FieldName = 'Navn'
      Size = 30
    end
  end
  object dsInLst: TDataSource
    AutoEdit = False
    DataSet = ffInLst
    Left = 261
    Top = 61
  end
  object ffPatTil: TnxTable
    AfterScroll = AfterScroll
    AutoCalcFields = False
    TableName = 'PatientTilskud'
    IndexName = 'NrOrden'
    MasterFields = 'KundeNr'
    MasterSource = dsPatKar
    Left = 68
    Top = 11
    object ffPatTilKundeNr: TStringField
      FieldName = 'KundeNr'
      Visible = False
    end
    object ffPatTilOrden: TWordField
      DisplayWidth = 6
      FieldName = 'Orden'
      Visible = False
    end
    object ffPatTilRegel: TWordField
      DisplayWidth = 5
      FieldName = 'Regel'
    end
    object ffPatTilRef: TWordField
      DisplayWidth = 3
      FieldKind = fkLookup
      FieldName = 'Ref'
      LookupDataSet = ffReLst
      LookupKeyFields = 'Nr'
      LookupResultField = 'RefNr'
      KeyFields = 'Regel'
      Lookup = True
    end
    object ffPatTilNavn: TStringField
      DisplayWidth = 22
      FieldKind = fkLookup
      FieldName = 'Navn'
      LookupDataSet = ffReLst
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      KeyFields = 'Regel'
      Size = 30
      Lookup = True
    end
    object ffPatTilFraDato: TDateTimeField
      DisplayLabel = 'Fra'
      DisplayWidth = 10
      FieldName = 'FraDato'
      Visible = False
      DisplayFormat = 'dd-mm-yyyy'
      EditMask = '90/90/00;1;_'
    end
    object ffPatTilTilDato: TDateTimeField
      DisplayLabel = 'Udl'#248'b'
      DisplayWidth = 10
      FieldName = 'TilDato'
      DisplayFormat = 'dd-mm-yyyy'
      EditMask = '90/90/00;1;_'
    end
    object ffPatTilPromille1: TWordField
      DisplayLabel = 'M.tilsk'
      DisplayWidth = 4
      FieldName = 'Promille1'
    end
    object ffPatTilPromille2: TWordField
      DisplayLabel = 'Niv 1'
      DisplayWidth = 4
      FieldName = 'Promille2'
      Visible = False
    end
    object ffPatTilPromille3: TWordField
      DisplayLabel = 'Niv 2'
      DisplayWidth = 4
      FieldName = 'Promille3'
      Visible = False
    end
    object ffPatTilPromille4: TWordField
      DisplayLabel = 'Niv 3'
      DisplayWidth = 4
      FieldName = 'Promille4'
      Visible = False
    end
    object ffPatTilPromille5: TWordField
      DisplayLabel = '-Tilsk'
      DisplayWidth = 4
      FieldName = 'Promille5'
    end
    object ffPatTilEgenbetaling: TCurrencyField
      DisplayWidth = 11
      FieldName = 'Egenbetaling'
      Visible = False
      DisplayFormat = '###,###,###,##0.00'
    end
    object ffPatTilAkkBetaling: TCurrencyField
      DisplayLabel = 'Akkumuleret'
      FieldName = 'AkkBetaling'
      Visible = False
      DisplayFormat = '###,###,###,##0.00'
    end
    object ffPatTilBetalType: TWordField
      DisplayLabel = 'Type'
      DisplayWidth = 12
      FieldName = 'BetalType'
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      Visible = False
      OnGetText = EgenBetTypeGetText
      OnSetText = EgenBetTypeSetText
    end
    object ffPatTilTilskMetode: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Metode'
      DisplayWidth = 12
      FieldName = 'TilskMetode'
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      Visible = False
      OnGetText = TilskMetodeGetText
      OnSetText = TilskMetodeSetText
    end
    object ffPatTilBetalDato: TDateTimeField
      DisplayLabel = 'Betal.dato'
      DisplayWidth = 10
      FieldName = 'BetalDato'
      Visible = False
      DisplayFormat = 'dd-mm-yyyy'
      EditMask = '90/90/00;1;_'
    end
    object ffPatTilJournalNr: TStringField
      DisplayLabel = 'Journalnr'
      DisplayWidth = 15
      FieldName = 'JournalNr'
      Visible = False
    end
    object ffPatTilRefNr: TStringField
      FieldName = 'RefNr'
      Visible = False
    end
    object ffPatTilChkJournalNr: TBooleanField
      FieldName = 'ChkJournalNr'
      Visible = False
      DisplayValues = 'Ja;Nej'
    end
    object ffPatTilBevilling: TMemoField
      FieldName = 'Bevilling'
      Visible = False
      BlobType = ftMemo
    end
    object ffPatTilInstans: TStringField
      FieldKind = fkLookup
      FieldName = 'Instans'
      LookupDataSet = ffReLst
      LookupKeyFields = 'Nr'
      LookupResultField = 'Operation'
      KeyFields = 'Regel'
      Visible = False
      Lookup = True
    end
    object ffPatTilAfdeling: TStringField
      FieldName = 'Afdeling'
      Visible = False
      Size = 30
    end
    object ffPatTilAfdelingEj: TStringField
      FieldName = 'AfdelingEj'
      Visible = False
      Size = 30
    end
    object ffPatTilAtcKode: TStringField
      DisplayWidth = 8
      FieldName = 'AtcKode'
      Size = 10
    end
    object ffPatTilVareNr: TStringField
      FieldName = 'VareNr'
      Size = 10
    end
    object ffPatTilProdukt: TStringField
      FieldName = 'Produkt'
      Size = 30
    end
    object ffPatTilDebitorNr: TStringField
      FieldName = 'DebitorNr'
      Size = 10
    end
  end
  object dsPatTil: TDataSource
    AutoEdit = False
    DataSet = ffPatTil
    OnStateChange = dsStateChange
    Left = 68
    Top = 57
  end
  object dsReLst: TDataSource
    AutoEdit = False
    DataSet = ffReLst
    Left = 309
    Top = 61
  end
  object ffReLst: TnxTable
    AutoCalcFields = False
    TableName = 'TilskudsRegler'
    IndexName = 'NrOrden'
    Left = 309
    Top = 11
    object ffReLstNr: TWordField
      DisplayLabel = 'Regel'
      DisplayWidth = 6
      FieldName = 'Nr'
    end
    object ffReLstRefNr: TWordField
      DisplayLabel = 'Ref'
      DisplayWidth = 3
      FieldName = 'RefNr'
    end
    object ffReLstNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object ffReLstOperation: TStringField
      DisplayLabel = 'Instans'
      DisplayWidth = 9
      FieldName = 'Operation'
    end
    object ffReLstOrden: TWordField
      FieldName = 'Orden'
      Visible = False
    end
  end
  object dsEks: TDataSource
    AutoEdit = False
    DataSet = mtEks
    Left = 163
    Top = 157
  end
  object dsLin: TDataSource
    AutoEdit = False
    DataSet = mtLin
    Left = 210
    Top = 158
  end
  object ffEksKar: TnxTable
    Session = nxSess
    AliasName = 'PRODUKTION'
    AutoCalcFields = False
    TableName = 'Ekspeditioner'
    IndexName = 'NrOrden'
    Left = 640
    Top = 208
    object ffEksKarLbNr: TIntegerField
      FieldName = 'LbNr'
      Visible = False
    end
    object ffEksKarKundeNr: TStringField
      FieldName = 'KundeNr'
      Visible = False
    end
    object ffEksKarNavn: TStringField
      FieldName = 'Navn'
      Visible = False
      Size = 30
    end
    object ffEksKarYderNavn: TStringField
      FieldName = 'YderNavn'
      Visible = False
      Size = 30
    end
    object ffEksKarBarn: TBooleanField
      FieldName = 'Barn'
      Visible = False
    end
    object ffEksKarTakserDato: TDateTimeField
      FieldName = 'TakserDato'
      Visible = False
    end
    object ffEksKarAfsluttetDato: TDateTimeField
      FieldName = 'AfsluttetDato'
      Visible = False
    end
    object ffEksKarOrdreDato: TDateTimeField
      FieldName = 'OrdreDato'
      Visible = False
    end
    object ffEksKarOrdreType: TWordField
      FieldName = 'OrdreType'
      Visible = False
    end
    object ffEksKarOrdreStatus: TWordField
      FieldName = 'OrdreStatus'
      Visible = False
    end
    object ffEksKarKontoNr: TStringField
      FieldName = 'KontoNr'
      Visible = False
    end
    object ffEksKarFakturaNr: TIntegerField
      FieldName = 'FakturaNr'
      Visible = False
    end
    object ffEksKarPakkeNr: TIntegerField
      FieldName = 'PakkeNr'
      Visible = False
    end
    object ffEksKarTurNr: TIntegerField
      FieldName = 'TurNr'
      Visible = False
    end
    object ffEksKarBrugerTakser: TWordField
      FieldName = 'BrugerTakser'
      Visible = False
    end
    object ffEksKarBrugerKontrol: TWordField
      FieldName = 'BrugerKontrol'
      Visible = False
    end
    object ffEksKarBrugerAfslut: TWordField
      FieldName = 'BrugerAfslut'
      Visible = False
    end
    object ffEksKarDKMedlem: TWordField
      FieldName = 'DKMedlem'
      Visible = False
    end
    object ffEksKarDKIndberettet: TWordField
      FieldName = 'DKIndberettet'
      Visible = False
    end
    object ffEksKarCtrType: TWordField
      FieldName = 'CtrType'
      Visible = False
    end
    object ffEksKarCtrIndberettet: TWordField
      FieldName = 'CtrIndberettet'
      Visible = False
    end
    object ffEksKarCtrSaldo: TCurrencyField
      FieldName = 'CtrSaldo'
      Visible = False
    end
    object ffEksKarYderNr: TStringField
      FieldName = 'YderNr'
      Visible = False
      Size = 10
    end
    object ffEksKarYderCprNr: TStringField
      FieldName = 'YderCprNr'
      Visible = False
      Size = 10
    end
    object ffEksKarKundeType: TWordField
      FieldName = 'KundeType'
      Visible = False
    end
    object ffEksKarEkspType: TWordField
      FieldName = 'EkspType'
      Visible = False
    end
    object ffEksKarEkspForm: TWordField
      FieldName = 'EkspForm'
      Visible = False
    end
    object ffEksKarAmt: TWordField
      FieldName = 'Amt'
      Visible = False
    end
    object ffEksKarKommune: TWordField
      FieldName = 'Kommune'
      Visible = False
    end
    object ffEksKarAfdeling: TWordField
      FieldName = 'Afdeling'
      Visible = False
    end
    object ffEksKarLager: TWordField
      FieldName = 'Lager'
      Visible = False
    end
    object ffEksKarUdlignNr: TIntegerField
      FieldName = 'UdlignNr'
      Visible = False
    end
    object ffEksKarFiktivtCprNr: TBooleanField
      FieldName = 'FiktivtCprNr'
      Visible = False
    end
    object ffEksKarCprCheck: TBooleanField
      FieldName = 'CprCheck'
      Visible = False
    end
    object ffEksKarEjSubstitution: TBooleanField
      FieldName = 'EjSubstitution'
      Visible = False
    end
    object ffEksKarNettoPriser: TBooleanField
      FieldName = 'NettoPriser'
      Visible = False
    end
    object ffEksKarLandeKode: TWordField
      FieldName = 'LandeKode'
      Visible = False
    end
    object ffEksKarFoedDato: TStringField
      FieldName = 'FoedDato'
      Visible = False
      Size = 8
    end
    object ffEksKarNarkoNr: TStringField
      FieldName = 'NarkoNr'
      Visible = False
      Size = 10
    end
    object ffEksKarReceptStatus: TWordField
      FieldName = 'ReceptStatus'
      Visible = False
    end
    object ffEksKarDosStyring: TBooleanField
      FieldName = 'DosStyring'
      Visible = False
    end
    object ffEksKarIndikStyring: TBooleanField
      FieldName = 'IndikStyring'
      Visible = False
    end
    object ffEksKarAntLin: TWordField
      FieldName = 'AntLin'
      Visible = False
    end
    object ffEksKarAntVarer: TWordField
      FieldName = 'AntVarer'
      Visible = False
    end
    object ffEksKarDKAnt: TWordField
      FieldName = 'DKAnt'
      Visible = False
    end
    object ffEksKarReceptDato: TDateTimeField
      FieldName = 'ReceptDato'
      Visible = False
    end
    object ffEksKarKontrolDato: TDateTimeField
      FieldName = 'KontrolDato'
      Visible = False
    end
    object ffEksKarForfaldsdato: TDateTimeField
      FieldName = 'Forfaldsdato'
      Visible = False
    end
    object ffEksKarKundeKlub: TBooleanField
      FieldName = 'KundeKlub'
      Visible = False
    end
    object ffEksKarTitel: TStringField
      FieldName = 'Titel'
      Visible = False
      Size = 30
    end
    object ffEksKarAdr1: TStringField
      FieldName = 'Adr1'
      Visible = False
      Size = 30
    end
    object ffEksKarAdr2: TStringField
      FieldName = 'Adr2'
      Visible = False
      Size = 30
    end
    object ffEksKarPostNr: TStringField
      FieldName = 'PostNr'
      Visible = False
    end
    object ffEksKarLand: TStringField
      FieldName = 'Land'
      Visible = False
      Size = 30
    end
    object ffEksKarKontakt: TStringField
      FieldName = 'Kontakt'
      Visible = False
      Size = 30
    end
    object ffEksKarTlfNr: TStringField
      FieldName = 'TlfNr'
      Visible = False
      Size = 30
    end
    object ffEksKarTlfNr2: TStringField
      FieldName = 'TlfNr2'
      Visible = False
      Size = 30
    end
    object ffEksKarKontoNavn: TStringField
      FieldName = 'KontoNavn'
      Visible = False
      Size = 30
    end
    object ffEksKarLevNavn: TStringField
      FieldName = 'LevNavn'
      Visible = False
      Size = 30
    end
    object ffEksKarBy: TStringField
      FieldKind = fkLookup
      FieldName = 'By'
      LookupDataSet = ffPnLst
      LookupKeyFields = 'PostNr'
      LookupResultField = 'ByNavn'
      KeyFields = 'PostNr'
      Visible = False
      Size = 30
      Lookup = True
    end
    object ffEksKarOrdreNr: TIntegerField
      FieldName = 'OrdreNr'
      Visible = False
    end
    object ffEksKarSprog: TWordField
      FieldName = 'Sprog'
      Visible = False
    end
    object ffEksKarKlubNr: TIntegerField
      FieldName = 'KlubNr'
      Visible = False
    end
    object ffEksKarLeveringsForm: TWordField
      FieldName = 'LeveringsForm'
      Visible = False
    end
    object ffEksKarBrutto: TCurrencyField
      FieldName = 'Brutto'
      Visible = False
    end
    object ffEksKarRabatLin: TCurrencyField
      FieldName = 'RabatLin'
      Visible = False
    end
    object ffEksKarRabatPct: TCurrencyField
      FieldName = 'RabatPct'
      Visible = False
    end
    object ffEksKarRabat: TCurrencyField
      FieldName = 'Rabat'
      Visible = False
    end
    object ffEksKarInclMoms: TBooleanField
      FieldName = 'InclMoms'
      Visible = False
    end
    object ffEksKarExMoms: TCurrencyField
      FieldName = 'ExMoms'
      Visible = False
    end
    object ffEksKarMomsPct: TCurrencyField
      FieldName = 'MomsPct'
      Visible = False
    end
    object ffEksKarMoms: TCurrencyField
      FieldName = 'Moms'
      Visible = False
    end
    object ffEksKarNetto: TCurrencyField
      FieldName = 'Netto'
      Visible = False
    end
    object ffEksKarTilskAmt: TCurrencyField
      FieldName = 'TilskAmt'
      Visible = False
    end
    object ffEksKarDKTilsk: TCurrencyField
      FieldName = 'DKTilsk'
      Visible = False
    end
    object ffEksKarDKEjTilsk: TCurrencyField
      FieldName = 'DKEjTilsk'
      Visible = False
    end
    object ffEksKarTilskKom: TCurrencyField
      FieldName = 'TilskKom'
      Visible = False
    end
    object ffEksKarUdbrGebyr: TCurrencyField
      FieldName = 'UdbrGebyr'
      Visible = False
    end
    object ffEksKarEdbGebyr: TCurrencyField
      FieldName = 'EdbGebyr'
      Visible = False
    end
    object ffEksKarTlfGebyr: TCurrencyField
      FieldName = 'TlfGebyr'
      Visible = False
    end
    object ffEksKarAndel: TCurrencyField
      FieldName = 'Andel'
      Visible = False
    end
    object ffEksKarLMSModtager: TStringField
      FieldName = 'LMSModtager'
      Size = 10
    end
    object ffEksKarAlder: TSmallintField
      FieldName = 'Alder'
    end
    object ffEksKarKontrolFejl: TWordField
      FieldName = 'KontrolFejl'
    end
    object ffEksKarLevAdr1: TStringField
      FieldName = 'LevAdr1'
      Size = 30
    end
    object ffEksKarLevAdr2: TStringField
      FieldName = 'LevAdr2'
      Size = 30
    end
    object ffEksKarLevPostNr: TStringField
      FieldName = 'LevPostNr'
    end
    object ffEksKarLevLand: TStringField
      FieldName = 'LevLand'
      Size = 30
    end
    object ffEksKarLevKontakt: TStringField
      FieldName = 'LevKontakt'
      Size = 30
    end
    object ffEksKarLevTlfNr: TStringField
      FieldName = 'LevTlfNr'
      Size = 30
    end
    object ffEksKarYderTlfNr: TStringField
      FieldName = 'YderTlfNr'
      Size = 30
    end
    object ffEksKarKontoAdr1: TStringField
      FieldName = 'KontoAdr1'
      Size = 30
    end
    object ffEksKarKontoAdr2: TStringField
      FieldName = 'KontoAdr2'
      Size = 30
    end
    object ffEksKarKontoPostNr: TStringField
      FieldName = 'KontoPostNr'
    end
    object ffEksKarKontoLand: TStringField
      FieldName = 'KontoLand'
      Size = 30
    end
    object ffEksKarKontoKontakt: TStringField
      FieldName = 'KontoKontakt'
      Size = 30
    end
    object ffEksKarKontoTlf: TStringField
      FieldName = 'KontoTlf'
      Size = 30
    end
    object ffEksKarKontoGruppe: TWordField
      FieldName = 'KontoGruppe'
    end
    object ffEksKarRabatGruppe: TWordField
      FieldName = 'RabatGruppe'
    end
    object ffEksKarPrisGruppe: TWordField
      FieldName = 'PrisGruppe'
    end
    object ffEksKarStatGruppe: TWordField
      FieldName = 'StatGruppe'
    end
    object ffEksKarKreditForm: TWordField
      FieldName = 'KreditForm'
    end
    object ffEksKarBetalingsForm: TWordField
      FieldName = 'BetalingsForm'
    end
    object ffEksKarPakkeseddel: TWordField
      FieldName = 'Pakkeseddel'
    end
    object ffEksKarFaktura: TWordField
      FieldName = 'Faktura'
    end
    object ffEksKarBetalingskort: TWordField
      FieldName = 'Betalingskort'
    end
    object ffEksKarLeveringsseddel: TWordField
      FieldName = 'Leveringsseddel'
    end
    object ffEksKarAdrEtiket: TWordField
      FieldName = 'AdrEtiket'
    end
    object ffEksKarVigtigBem: TnxMemoField
      FieldName = 'VigtigBem'
      BlobType = ftMemo
    end
    object ffEksKarAfstempling: TnxMemoField
      FieldName = 'Afstempling'
      BlobType = ftMemo
    end
    object ffEksKarLMSUdsteder: TStringField
      FieldName = 'LMSUdsteder'
      Size = 7
    end
    object ffEksKarCtrBel: TCurrencyField
      FieldName = 'CtrBel'
    end
    object ffEksKarRSQueueStatus: TIntegerField
      FieldName = 'RSQueueStatus'
    end
    object ffEksKarReturdage: TWordField
      FieldName = 'Returdage'
    end
  end
  object dsEksKar: TDataSource
    AutoEdit = False
    DataSet = ffEksKar
    Left = 640
    Top = 253
  end
  object ffEksLin: TnxTable
    Session = nxSess
    AliasName = 'PRODUKTION'
    AutoCalcFields = False
    TableName = 'EkspLinierSalg'
    IndexName = 'NrOrden'
    Left = 691
    Top = 208
    object ffEksLinLbNr: TIntegerField
      FieldName = 'LbNr'
      Visible = False
    end
    object ffEksLinLinieNr: TWordField
      FieldName = 'LinieNr'
      Visible = False
    end
    object ffEksLinLinieType: TWordField
      FieldName = 'LinieType'
      Visible = False
    end
    object ffEksLinLager: TWordField
      FieldName = 'Lager'
      Visible = False
    end
    object ffEksLinVareNr: TStringField
      FieldName = 'VareNr'
      Visible = False
    end
    object ffEksLinSubVareNr: TStringField
      FieldName = 'SubVareNr'
      Visible = False
    end
    object ffEksLinStatNr: TStringField
      FieldName = 'StatNr'
      Visible = False
    end
    object ffEksLinLokation1: TWordField
      FieldName = 'Lokation1'
      Visible = False
    end
    object ffEksLinLokation2: TWordField
      FieldName = 'Lokation2'
      Visible = False
    end
    object ffEksLinLokation3: TWordField
      FieldName = 'Lokation3'
      Visible = False
    end
    object ffEksLinVareType: TWordField
      FieldName = 'VareType'
      Visible = False
    end
    object ffEksLinVareGruppe: TWordField
      FieldName = 'VareGruppe'
      Visible = False
    end
    object ffEksLinStatGruppe: TWordField
      FieldName = 'StatGruppe'
      Visible = False
    end
    object ffEksLinOmsType: TWordField
      FieldName = 'OmsType'
      Visible = False
    end
    object ffEksLinNarkoType: TWordField
      FieldName = 'NarkoType'
      Visible = False
    end
    object ffEksLinTilskType: TWordField
      FieldName = 'TilskType'
      Visible = False
    end
    object ffEksLinDKType: TWordField
      FieldName = 'DKType'
      Visible = False
    end
    object ffEksLinTekst: TStringField
      FieldName = 'Tekst'
      Visible = False
      Size = 100
    end
    object ffEksLinEnhed: TStringField
      FieldName = 'Enhed'
      Visible = False
      Size = 5
    end
    object ffEksLinDyreArt: TWordField
      FieldName = 'DyreArt'
      Visible = False
    end
    object ffEksLinAldersGrp: TWordField
      FieldName = 'AldersGrp'
      Visible = False
    end
    object ffEksLinOrdGrp: TWordField
      FieldName = 'OrdGrp'
      Visible = False
    end
    object ffEksLinUdlevMax: TWordField
      FieldName = 'UdlevMax'
      Visible = False
    end
    object ffEksLinUdlevNr: TWordField
      FieldName = 'UdlevNr'
      Visible = False
    end
    object ffEksLinAntal: TIntegerField
      FieldName = 'Antal'
      Visible = False
    end
    object ffEksLinPris: TCurrencyField
      FieldName = 'Pris'
      Visible = False
    end
    object ffEksLinKostPris: TCurrencyField
      FieldName = 'KostPris'
      Visible = False
    end
    object ffEksLinVareForbrug: TCurrencyField
      FieldName = 'VareForbrug'
      Visible = False
    end
    object ffEksLinBrutto: TCurrencyField
      FieldName = 'Brutto'
      Visible = False
    end
    object ffEksLinRabatPct: TCurrencyField
      FieldName = 'RabatPct'
      Visible = False
    end
    object ffEksLinRabat: TCurrencyField
      FieldName = 'Rabat'
      Visible = False
    end
    object ffEksLinExMoms: TCurrencyField
      FieldName = 'ExMoms'
      Visible = False
    end
    object ffEksLinInclMoms: TBooleanField
      FieldName = 'InclMoms'
      Visible = False
    end
    object ffEksLinMomsPct: TCurrencyField
      FieldName = 'MomsPct'
      Visible = False
    end
    object ffEksLinMoms: TCurrencyField
      FieldName = 'Moms'
      Visible = False
    end
    object ffEksLinNetto: TCurrencyField
      FieldName = 'Netto'
      Visible = False
    end
    object ffEksLinForm: TStringField
      FieldName = 'Form'
    end
    object ffEksLinStyrke: TStringField
      FieldName = 'Styrke'
    end
    object ffEksLinPakning: TStringField
      FieldName = 'Pakning'
      Size = 30
    end
    object ffEksLinATCType: TStringField
      FieldName = 'ATCType'
      Size = 3
    end
    object ffEksLinATCKode: TStringField
      FieldName = 'ATCKode'
      Size = 7
    end
    object ffEksLinSSKode: TStringField
      FieldName = 'SSKode'
      Size = 2
    end
    object ffEksLinKlausul: TStringField
      FieldName = 'Klausul'
      Size = 5
    end
    object ffEksLinPAKode: TStringField
      FieldName = 'PAKode'
      Size = 2
    end
    object ffEksLinDDD: TIntegerField
      FieldName = 'DDD'
    end
    object ffEksLinEjG: TWordField
      FieldName = 'EjG'
      Visible = False
    end
    object ffEksLinEjO: TWordField
      FieldName = 'EjO'
      Visible = False
    end
    object ffEksLinEjS: TWordField
      FieldName = 'EjS'
      Visible = False
    end
    object ffEksLinUdLevType: TStringField
      FieldName = 'UdLevType'
      Visible = False
      Size = 5
    end
    object ffEksLinGMark: TBooleanField
      FieldName = 'GMark'
    end
    object ffEksLinOMark: TBooleanField
      FieldName = 'OMark'
    end
    object ffEksLinAMark: TBooleanField
      FieldName = 'AMark'
    end
    object ffEksLinPMark: TBooleanField
      FieldName = 'PMark'
    end
    object ffEksLinUdDato: TDateTimeField
      FieldName = 'UdDato'
    end
    object ffEksLinBatchNr: TStringField
      FieldName = 'BatchNr'
      Size = 25
    end
    object ffEksLinOrdinationId: TStringField
      FieldName = 'OrdinationId'
      Size = 15
    end
    object ffEksLinUdstederAutId: TnxStringField
      FieldName = 'UdstederAutId'
      Size = 5
    end
    object ffEksLinUdstederId: TnxStringField
      FieldName = 'UdstederId'
      Size = 200
    end
    object ffEksLinUdstederType: TIntegerField
      FieldName = 'UdstederType'
    end
    object ffEksLinDrugId: TnxStringField
      FieldName = 'DrugId'
      Size = 11
    end
    object ffEksLinOpbevKode: TnxStringField
      FieldName = 'OpbevKode'
      Size = 1
    end
  end
  object dsEksLin: TDataSource
    AutoEdit = False
    DataSet = ffEksLin
    Left = 691
    Top = 253
  end
  object ffEksTil: TnxTable
    Session = nxSess
    AliasName = 'PRODUKTION'
    AutoCalcFields = False
    TableName = 'EkspLinierTilskud'
    IndexName = 'NrOrden'
    Left = 740
    Top = 208
    object ffEksTilLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object ffEksTilLinieNr: TWordField
      FieldName = 'LinieNr'
    end
    object ffEksTilESP: TCurrencyField
      FieldName = 'ESP'
    end
    object ffEksTilRFP: TCurrencyField
      FieldName = 'RFP'
    end
    object ffEksTilBGP: TCurrencyField
      FieldName = 'BGP'
    end
    object ffEksTilSaldo: TCurrencyField
      FieldName = 'Saldo'
    end
    object ffEksTilIBPBel: TCurrencyField
      FieldName = 'IBPBel'
    end
    object ffEksTilBGPBel: TCurrencyField
      FieldName = 'BGPBel'
    end
    object ffEksTilIBTBel: TCurrencyField
      FieldName = 'IBTBel'
    end
    object ffEksTilUdligning: TCurrencyField
      FieldName = 'Udligning'
    end
    object ffEksTilAndel: TCurrencyField
      FieldName = 'Andel'
    end
    object ffEksTilTilskSyg: TCurrencyField
      FieldName = 'TilskSyg'
    end
    object ffEksTilTilskKom1: TCurrencyField
      FieldName = 'TilskKom1'
    end
    object ffEksTilTilskKom2: TCurrencyField
      FieldName = 'TilskKom2'
    end
    object ffEksTilRegelSyg: TWordField
      FieldName = 'RegelSyg'
    end
    object ffEksTilRegelKom1: TWordField
      FieldName = 'RegelKom1'
    end
    object ffEksTilRegelKom2: TWordField
      FieldName = 'RegelKom2'
    end
    object ffEksTilPromilleSyg: TWordField
      FieldName = 'PromilleSyg'
    end
    object ffEksTilPromilleKom1: TWordField
      FieldName = 'PromilleKom1'
    end
    object ffEksTilPromilleKom2: TWordField
      FieldName = 'PromilleKom2'
    end
    object ffEksTilJournalNr1: TStringField
      FieldName = 'JournalNr1'
    end
    object ffEksTilJournalNr2: TStringField
      FieldName = 'JournalNr2'
    end
    object ffEksTilAfdeling1: TStringField
      FieldName = 'Afdeling1'
      Size = 30
    end
    object ffEksTilAfdeling2: TStringField
      FieldName = 'Afdeling2'
      Size = 30
    end
    object ffEksTilCtrIndberettet: TWordField
      FieldName = 'CtrIndberettet'
    end
    object ffEksTilFraDato1: TDateTimeField
      FieldName = 'FraDato1'
    end
    object ffEksTilTilDato1: TDateTimeField
      FieldName = 'TilDato1'
    end
    object ffEksTilFraDato2: TDateTimeField
      FieldName = 'FraDato2'
    end
    object ffEksTilTilDato2: TDateTimeField
      FieldName = 'TilDato2'
    end
    object ffEksTilAfdeling1Ej: TStringField
      FieldName = 'Afdeling1Ej'
      Size = 30
    end
    object ffEksTilAfdeling2Ej: TStringField
      FieldName = 'Afdeling2Ej'
      Size = 30
    end
  end
  object dsEksTil: TDataSource
    AutoEdit = False
    DataSet = ffEksTil
    Left = 740
    Top = 253
  end
  object ffEksEtk: TnxTable
    Session = nxSess
    AliasName = 'PRODUKTION'
    AutoCalcFields = False
    TableName = 'EkspLinierEtiket'
    IndexName = 'NrOrden'
    Left = 793
    Top = 208
    object ffEksEtkLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object ffEksEtkLinieNr: TWordField
      FieldName = 'LinieNr'
    end
    object ffEksEtkDosKode: TStringField
      FieldName = 'DosKode'
    end
    object ffEksEtkDosKode1: TStringField
      FieldName = 'DosKode1'
    end
    object ffEksEtkDosKode2: TStringField
      FieldName = 'DosKode2'
    end
    object ffEksEtkIndikKode: TStringField
      FieldName = 'IndikKode'
    end
    object ffEksEtkTxtKode: TStringField
      FieldName = 'TxtKode'
    end
    object ffEksEtkEtiket: TMemoField
      FieldName = 'Etiket'
      BlobType = ftMemo
    end
  end
  object dsEksEtk: TDataSource
    AutoEdit = False
    DataSet = ffEksEtk
    Left = 793
    Top = 253
  end
  object ffLagNvn: TnxTable
    AutoCalcFields = False
    TableName = 'LagerNavne'
    IndexName = 'NavneOrden'
    Left = 640
    Top = 452
    object ffLagNvnOperation: TStringField
      FieldName = 'Operation'
    end
    object ffLagNvnNavn: TStringField
      FieldName = 'Navn'
    end
    object ffLagNvnRefNr: TIntegerField
      FieldName = 'RefNr'
    end
  end
  object ffPatUpd: TnxTable
    AutoCalcFields = False
    TableName = 'PatientKartotek'
    IndexName = 'NrOrden'
    Left = 19
    Top = 104
    object ffPatUpdKundeNr: TStringField
      FieldName = 'KundeNr'
    end
    object ffPatUpdKundeType: TWordField
      FieldName = 'KundeType'
    end
    object ffPatUpdCtrType: TWordField
      FieldName = 'CtrType'
    end
    object ffPatUpdLandekode: TWordField
      FieldName = 'Landekode'
    end
    object ffPatUpdFoedDato: TStringField
      FieldName = 'FoedDato'
      Size = 8
    end
    object ffPatUpdLmsModtager: TStringField
      FieldName = 'LmsModtager'
      Size = 10
    end
    object ffPatUpdLmsUdsteder: TStringField
      FieldName = 'LmsUdsteder'
      Size = 7
    end
    object ffPatUpdTitel: TStringField
      FieldName = 'Titel'
      Size = 30
    end
    object ffPatUpdCprCheck: TBooleanField
      FieldName = 'CprCheck'
    end
    object ffPatUpdFiktivtCprNr: TBooleanField
      FieldName = 'FiktivtCprNr'
    end
    object ffPatUpdNettoPriser: TBooleanField
      FieldName = 'NettoPriser'
    end
    object ffPatUpdEjSubstitution: TBooleanField
      FieldName = 'EjSubstitution'
    end
    object ffPatUpdBarn: TBooleanField
      FieldName = 'Barn'
    end
    object ffPatUpdKundeKlub: TBooleanField
      FieldName = 'KundeKlub'
    end
    object ffPatUpdKlubNr: TIntegerField
      FieldName = 'KlubNr'
    end
    object ffPatUpdNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object ffPatUpdAdr1: TStringField
      FieldName = 'Adr1'
      Size = 30
    end
    object ffPatUpdAdr2: TStringField
      FieldName = 'Adr2'
      Size = 30
    end
    object ffPatUpdPostNr: TStringField
      FieldName = 'PostNr'
    end
    object ffPatUpdLand: TStringField
      FieldName = 'Land'
      Size = 30
    end
    object ffPatUpdKontakt: TStringField
      FieldName = 'Kontakt'
      Size = 30
    end
    object ffPatUpdTlfNr: TStringField
      FieldName = 'TlfNr'
      Size = 30
    end
    object ffPatUpdTlfNr2: TStringField
      FieldName = 'TlfNr2'
      Size = 30
    end
    object ffPatUpdMobil: TStringField
      FieldName = 'Mobil'
      Size = 30
    end
    object ffPatUpdFaxNr: TStringField
      FieldName = 'FaxNr'
      Size = 30
    end
    object ffPatUpdMail: TStringField
      FieldName = 'Mail'
      Size = 30
    end
    object ffPatUpdLink: TStringField
      FieldName = 'Link'
      Size = 30
    end
    object ffPatUpdDebitorNr: TStringField
      FieldName = 'DebitorNr'
    end
    object ffPatUpdLevNr: TStringField
      FieldName = 'LevNr'
    end
    object ffPatUpdYderNr: TStringField
      FieldName = 'YderNr'
      Size = 10
    end
    object ffPatUpdYderCprNr: TStringField
      FieldName = 'YderCprNr'
      Size = 10
    end
    object ffPatUpdDKMedlem: TWordField
      FieldName = 'DKMedlem'
    end
    object ffPatUpdAmt: TWordField
      FieldName = 'Amt'
    end
    object ffPatUpdKommune: TWordField
      FieldName = 'Kommune'
    end
    object ffPatUpdOpretDato: TDateTimeField
      FieldName = 'OpretDato'
    end
    object ffPatUpdRetDato: TDateTimeField
      FieldName = 'RetDato'
    end
    object ffPatUpdVigtigBem: TMemoField
      FieldName = 'VigtigBem'
      BlobType = ftMemo
    end
    object ffPatUpdEjCtrReg: TBooleanField
      FieldName = 'EjCtrReg'
    end
    object ffPatUpdCtrUdDato: TDateTimeField
      FieldName = 'CtrUdDato'
    end
    object ffPatUpdCtrSaldo: TCurrencyField
      FieldName = 'CtrSaldo'
    end
    object ffPatUpdCtrStempel: TDateTimeField
      FieldName = 'CtrStempel'
    end
    object ffPatUpdCtrUdlign: TCurrencyField
      FieldName = 'CtrUdlign'
    end
    object ffPatUpdCtrStatus: TSmallintField
      FieldName = 'CtrStatus'
    end
    object ffPatUpdCtrOrd: TSmallintField
      FieldName = 'CtrOrd'
    end
    object ffPatUpdCtrUdDatoB: TDateTimeField
      FieldName = 'CtrUdDatoB'
    end
    object ffPatUpdCtrSaldoB: TCurrencyField
      FieldName = 'CtrSaldoB'
    end
    object ffPatUpdCTRUdlignB: TCurrencyField
      FieldName = 'CTRUdlignB'
    end
  end
  object ffTilUpd: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    AutoCalcFields = False
    TableName = 'PatientTilskud'
    IndexName = 'NrOrden'
    Left = 68
    Top = 104
    object ffTilUpdKundeNr: TStringField
      FieldName = 'KundeNr'
    end
    object ffTilUpdOrden: TWordField
      FieldName = 'Orden'
    end
    object ffTilUpdRegel: TWordField
      FieldName = 'Regel'
    end
    object ffTilUpdFraDato: TDateTimeField
      FieldName = 'FraDato'
    end
    object ffTilUpdTilDato: TDateTimeField
      FieldName = 'TilDato'
    end
    object ffTilUpdPromille1: TWordField
      FieldName = 'Promille1'
    end
    object ffTilUpdPromille2: TWordField
      FieldName = 'Promille2'
    end
    object ffTilUpdPromille3: TWordField
      FieldName = 'Promille3'
    end
    object ffTilUpdPromille4: TWordField
      FieldName = 'Promille4'
    end
    object ffTilUpdPromille5: TWordField
      FieldName = 'Promille5'
    end
    object ffTilUpdEgenbetaling: TCurrencyField
      FieldName = 'Egenbetaling'
    end
    object ffTilUpdAkkBetaling: TCurrencyField
      FieldName = 'AkkBetaling'
    end
    object ffTilUpdBetalType: TWordField
      FieldName = 'BetalType'
    end
    object ffTilUpdBetalDato: TDateTimeField
      FieldName = 'BetalDato'
    end
    object ffTilUpdJournalNr: TStringField
      FieldName = 'JournalNr'
    end
    object ffTilUpdRefNr: TStringField
      FieldName = 'RefNr'
    end
    object ffTilUpdChkJournalNr: TBooleanField
      FieldName = 'ChkJournalNr'
    end
    object ffTilUpdTilskMetode: TWordField
      FieldName = 'TilskMetode'
    end
    object ffTilUpdBevilling: TMemoField
      FieldName = 'Bevilling'
      BlobType = ftMemo
    end
    object ffTilUpdAfdeling: TStringField
      FieldName = 'Afdeling'
      Size = 30
    end
  end
  object ffAfdNvn: TnxTable
    AutoCalcFields = False
    TableName = 'AfdelingsNavne'
    IndexName = 'NavneOrden'
    Left = 686
    Top = 452
    object ffAfdNvnOperation: TStringField
      FieldName = 'Operation'
    end
    object ffAfdNvnNavn: TStringField
      FieldName = 'Navn'
    end
    object ffAfdNvnRefNr: TIntegerField
      FieldName = 'RefNr'
    end
    object ffAfdNvnLmsPNr: TStringField
      FieldName = 'LmsPNr'
      Size = 10
    end
    object ffAfdNvnType: TStringField
      FieldName = 'Type'
      Size = 21
    end
    object ffAfdNvnLmsNr: TStringField
      FieldName = 'LmsNr'
      Size = 6
    end
    object ffAfdNvnProduktionsDyr: TBooleanField
      FieldName = 'ProduktionsDyr'
    end
  end
  object ffArbOpl: TnxTable
    AutoCalcFields = False
    TableName = 'ArbejdspladsOplysninger'
    IndexName = 'NrOrden'
    Left = 456
    Top = 112
    object ffArbOplPladsNr: TIntegerField
      FieldName = 'PladsNr'
    end
    object ffArbOplAfdeling: TStringField
      FieldName = 'Afdeling'
    end
    object ffArbOplLager: TStringField
      FieldName = 'Lager'
    end
    object ffArbOplSpecLager: TStringField
      FieldName = 'SpecLager'
    end
    object ffArbOplNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
  end
  object ffFirma: TnxTable
    TableName = 'FirmaOplysninger'
    IndexName = 'NavneOrden'
    Left = 456
    Top = 11
    object ffFirmaNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object ffFirmaSupNavn: TStringField
      FieldName = 'SupNavn'
      Size = 30
    end
    object ffFirmaAfdeling: TStringField
      FieldName = 'Afdeling'
    end
    object ffFirmaLager: TStringField
      FieldName = 'Lager'
    end
    object ffFirmaSpec1: TStringField
      FieldName = 'Spec1'
      Size = 30
    end
    object ffFirmaAdresse1: TStringField
      FieldName = 'Adresse1'
      Size = 30
    end
    object ffFirmaAdresse2: TStringField
      FieldName = 'Adresse2'
      Size = 30
    end
    object ffFirmaPostNr: TStringField
      FieldName = 'PostNr'
    end
    object ffFirmaByNavn: TStringField
      FieldName = 'ByNavn'
      Size = 30
    end
    object ffFirmaSeNr: TStringField
      FieldName = 'SeNr'
    end
    object ffFirmaGiroNr: TStringField
      FieldName = 'GiroNr'
    end
    object ffFirmaSpec2: TStringField
      FieldName = 'Spec2'
      Size = 30
    end
    object ffFirmaBankRegNr1: TStringField
      FieldName = 'BankRegNr1'
    end
    object ffFirmaBankKontoNr1: TStringField
      FieldName = 'BankKontoNr1'
    end
    object ffFirmaTlfNr: TStringField
      FieldName = 'TlfNr'
      Size = 30
    end
    object ffFirmaTlfNr2: TStringField
      FieldName = 'TlfNr2'
      Size = 30
    end
    object ffFirmaMobil: TStringField
      FieldName = 'Mobil'
      Size = 30
    end
    object ffFirmaTelefax: TStringField
      FieldName = 'Telefax'
      Size = 30
    end
    object ffFirmaMail: TStringField
      FieldName = 'Mail'
      Size = 30
    end
  end
  object ffRcpOpl: TnxTable
    TableName = 'RecepturOplysninger'
    Left = 507
    Top = 113
    object ffRcpOplLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object ffRcpOplTurNr: TIntegerField
      FieldName = 'TurNr'
    end
    object ffRcpOplPakkeNr: TIntegerField
      FieldName = 'PakkeNr'
    end
    object ffRcpOplUdskrivPct: TCurrencyField
      FieldName = 'UdskrivPct'
    end
    object ffRcpOplAfrPerDKSt: TDateTimeField
      FieldName = 'AfrPerDKSt'
    end
    object ffRcpOplAfrPerDKSl: TDateTimeField
      FieldName = 'AfrPerDKSl'
    end
    object ffRcpOplAfrDiskDK: TWordField
      FieldName = 'AfrDiskDK'
    end
    object ffRcpOplAfrPostDK: TIntegerField
      FieldName = 'AfrPostDK'
    end
    object ffRcpOplAfrLbNrDK: TIntegerField
      FieldName = 'AfrLbNrDK'
    end
    object ffRcpOplAfrFormDK: TStringField
      FieldName = 'AfrFormDK'
    end
    object ffRcpOplAfrPerSSSt: TDateTimeField
      FieldName = 'AfrPerSSSt'
    end
    object ffRcpOplAfrPerSSSl: TDateTimeField
      FieldName = 'AfrPerSSSl'
    end
    object ffRcpOplAfrDiskSS: TWordField
      FieldName = 'AfrDiskSS'
    end
    object ffRcpOplAfrPostSS: TIntegerField
      FieldName = 'AfrPostSS'
    end
    object ffRcpOplAfrLbNrSS: TIntegerField
      FieldName = 'AfrLbNrSS'
    end
    object ffRcpOplAfrFormSS: TStringField
      FieldName = 'AfrFormSS'
    end
    object ffRcpOplAfrPerLMSSt: TDateTimeField
      FieldName = 'AfrPerLMSSt'
    end
    object ffRcpOplAfrPerLMSSl: TDateTimeField
      FieldName = 'AfrPerLMSSl'
    end
    object ffRcpOplAfrDiskLMS: TWordField
      FieldName = 'AfrDiskLMS'
    end
    object ffRcpOplAfrPostLMS: TIntegerField
      FieldName = 'AfrPostLMS'
    end
    object ffRcpOplAfrLbNrLMS: TIntegerField
      FieldName = 'AfrLbNrLMS'
    end
    object ffRcpOplAfrFormLMS: TStringField
      FieldName = 'AfrFormLMS'
    end
    object ffRcpOplAfrPerKOMSt: TDateTimeField
      FieldName = 'AfrPerKOMSt'
    end
    object ffRcpOplAfrPerKOMSl: TDateTimeField
      FieldName = 'AfrPerKOMSl'
    end
    object ffRcpOplAfrDiskKOM: TWordField
      FieldName = 'AfrDiskKOM'
    end
    object ffRcpOplAfrPostKOM: TIntegerField
      FieldName = 'AfrPostKOM'
    end
    object ffRcpOplAfrLbNrKOM: TIntegerField
      FieldName = 'AfrLbNrKOM'
    end
    object ffRcpOplAfrFormKOM: TStringField
      FieldName = 'AfrFormKOM'
    end
    object ffRcpOplTakstDatoGl: TDateTimeField
      FieldName = 'TakstDatoGl'
    end
    object ffRcpOplTakstDatoAkt: TDateTimeField
      FieldName = 'TakstDatoAkt'
    end
    object ffRcpOplTakstDatoNy: TDateTimeField
      FieldName = 'TakstDatoNy'
    end
    object ffRcpOplInteraktType: TStringField
      FieldName = 'InteraktType'
    end
    object ffRcpOplInteraktMdr: TWordField
      FieldName = 'InteraktMdr'
    end
    object ffRcpOplInteraktNiveau: TStringField
      FieldName = 'InteraktNiveau'
    end
    object ffRcpOplLmsNr: TStringField
      FieldName = 'LmsNr'
      Size = 5
    end
    object ffRcpOplLmsPNr: TStringField
      FieldName = 'LmsPNr'
      Size = 10
    end
    object ffRcpOplSSRabat: TCurrencyField
      FieldName = 'SSRabat'
    end
    object ffRcpOplApoteksNr: TStringField
      FieldName = 'ApoteksNr'
      Size = 5
    end
    object ffRcpOplMomsPct: TCurrencyField
      FieldName = 'MomsPct'
    end
    object ffRcpOplEdbGebyr: TCurrencyField
      FieldName = 'EdbGebyr'
    end
    object ffRcpOplTlfGebyr: TCurrencyField
      FieldName = 'TlfGebyr'
    end
    object ffRcpOplUdbrGebyr: TCurrencyField
      FieldName = 'UdbrGebyr'
    end
    object ffRcpOplKontoGebyr: TCurrencyField
      FieldName = 'KontoGebyr'
    end
    object ffRcpOplPakkeGebyr: TCurrencyField
      FieldName = 'PakkeGebyr'
    end
    object ffRcpOplRcpGebyr: TCurrencyField
      FieldName = 'RcpGebyr'
    end
    object ffRcpOplRcpKontrol: TBooleanField
      FieldName = 'RcpKontrol'
    end
    object ffRcpOplPakSedUdsalg: TBooleanField
      FieldName = 'PakSedUdsalg'
    end
    object ffRcpOplHKgebyr: TCurrencyField
      FieldName = 'HKgebyr'
    end
    object ffRcpOplPlejehjemsgebyr: TCurrencyField
      FieldName = 'Plejehjemsgebyr'
    end
    object ffRcpOplListeNr: TIntegerField
      FieldName = 'ListeNr'
    end
    object ffRcpOplAfrAmt: TStringField
      FieldName = 'AfrAmt'
      Size = 3
    end
  end
  object ffEksOvr: TnxTable
    AliasName = 'produktion'
    AfterScroll = ffEksOvrAfterScroll
    OnCalcFields = ffEksOvrCalcFields
    TableName = 'Ekspeditioner'
    IndexName = 'KundeNrOrden'
    Left = 640
    Top = 112
    object ffEksOvrLbNr: TIntegerField
      DisplayLabel = 'L'#248'benr'
      DisplayWidth = 7
      FieldName = 'LbNr'
      DisplayFormat = '0000000'
    end
    object ffEksOvrKundeNr: TStringField
      DisplayLabel = 'Kundenr'
      DisplayWidth = 10
      FieldName = 'KundeNr'
    end
    object ffEksOvrNavn: TStringField
      DisplayWidth = 25
      FieldName = 'Navn'
      Size = 30
    end
    object ffEksOvrTakserDato: TDateTimeField
      DisplayLabel = 'Takseret'
      DisplayWidth = 14
      FieldName = 'TakserDato'
      DisplayFormat = 'dd-mm-yyyy hh:mm'
    end
    object ffEksOvrAfsluttetDato: TDateTimeField
      DisplayLabel = 'Afsluttet'
      DisplayWidth = 14
      FieldName = 'AfsluttetDato'
      DisplayFormat = 'dd-mm-yyyy hh:mm'
    end
    object ffEksOvrOrdreType: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Type'
      DisplayWidth = 5
      FieldName = 'OrdreType'
      OnGetText = OrdreTypeGetText
      OnSetText = OrdreTypeSetText
    end
    object ffEksOvrOrdreStatus: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Status'
      DisplayWidth = 8
      FieldName = 'OrdreStatus'
      OnGetText = OrdreStatusGetText
      OnSetText = OrdreStatusSetText
    end
    object ffEksOvrBrugerTakser: TWordField
      DisplayLabel = 'Ta'
      DisplayWidth = 2
      FieldName = 'BrugerTakser'
    end
    object ffEksOvrBrugerKontrol: TWordField
      DisplayLabel = 'Ko'
      DisplayWidth = 2
      FieldName = 'BrugerKontrol'
    end
    object ffEksOvrBrugerAfslut: TWordField
      DisplayLabel = 'Af'
      DisplayWidth = 2
      FieldName = 'BrugerAfslut'
    end
    object ffEksOvrKontoNr: TStringField
      DisplayLabel = 'Konto'
      DisplayWidth = 6
      FieldName = 'KontoNr'
    end
    object ffEksOvrFakturaNr: TIntegerField
      DisplayLabel = 'Faktura'
      DisplayWidth = 8
      FieldName = 'FakturaNr'
    end
    object ffEksOvrUdlignNr: TIntegerField
      DisplayLabel = 'Udlign.nr'
      DisplayWidth = 6
      FieldName = 'UdlignNr'
    end
    object ffEksOvrPakkeNr: TIntegerField
      DisplayLabel = 'Pakke'
      DisplayWidth = 6
      FieldName = 'PakkeNr'
    end
    object ffEksOvrListeNr: TIntegerField
      DisplayLabel = 'Listenr'
      DisplayWidth = 6
      FieldKind = fkLookup
      FieldName = 'ListeNr'
      LookupDataSet = nxEkspLevListe
      LookupKeyFields = 'LbNr'
      LookupResultField = 'ListeNr'
      KeyFields = 'LbNr'
      Lookup = True
    end
    object ffEksOvrLevNavn: TStringField
      DisplayLabel = 'Lev.nr'
      DisplayWidth = 6
      FieldName = 'LevNavn'
      Size = 30
    end
    object ffEksOvrBarn: TBooleanField
      FieldName = 'Barn'
      DisplayValues = 'Ja;Nej'
    end
    object ffEksOvrTurNr: TIntegerField
      DisplayLabel = 'Tur'
      DisplayWidth = 3
      FieldName = 'TurNr'
    end
    object ffEksOvrDKMedlem: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'DK-medlem'
      DisplayWidth = 10
      FieldName = 'DKMedlem'
      OnGetText = DKMedlemGetText
      OnSetText = DKMedlemSetText
    end
    object ffEksOvrDKIndberettet: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'DK'
      DisplayWidth = 2
      FieldName = 'DKIndberettet'
      OnGetText = DKOpdGetText
      OnSetText = DKOpdSetText
    end
    object ffEksOvrYderNavn: TStringField
      DisplayLabel = 'L'#230'ge'
      DisplayWidth = 15
      FieldName = 'YderNavn'
      Size = 30
    end
    object ffEksOvrCtrType: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Ctr type'
      DisplayWidth = 10
      FieldName = 'CtrType'
      OnGetText = CtrTypeGetText
      OnSetText = CtrTypeSetText
    end
    object ffEksOvrCtrIndberettet: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'CP'
      DisplayWidth = 2
      FieldName = 'CtrIndberettet'
      OnGetText = CtrPemGetText
      OnSetText = CtrPemSetText
    end
    object ffEksOvrCtrSaldo: TCurrencyField
      DisplayLabel = 'CTR saldo'
      FieldName = 'CtrSaldo'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrYderNr: TStringField
      DisplayLabel = 'Ydernr'
      DisplayWidth = 7
      FieldName = 'YderNr'
      Size = 10
    end
    object ffEksOvrKundeType: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Kundetype'
      DisplayWidth = 12
      FieldName = 'KundeType'
      OnGetText = KundeTypeGetText
      OnSetText = KundeTypeSetText
    end
    object ffEksOvrEkspType: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Eksp.type'
      DisplayWidth = 10
      FieldName = 'EkspType'
      OnGetText = EkspTypeGetText
      OnSetText = EkspTypeSetText
    end
    object ffEksOvrEkspForm: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Eksp.form'
      DisplayWidth = 10
      FieldName = 'EkspForm'
      OnGetText = EkspFormGetText
      OnSetText = EkspFormSetText
    end
    object ffEksOvrReceptId: TIntegerField
      FieldKind = fkLookup
      FieldName = 'ReceptId'
      LookupDataSet = nxRSEkspLin
      LookupKeyFields = 'LbNr'
      LookupResultField = 'ReceptId'
      KeyFields = 'LbNr'
      Lookup = True
    end
    object ffEksOvrAmt: TWordField
      DisplayWidth = 3
      FieldName = 'Amt'
    end
    object ffEksOvrKommune: TWordField
      DisplayLabel = 'Kom'
      DisplayWidth = 3
      FieldName = 'Kommune'
    end
    object ffEksOvrAfdeling: TWordField
      DisplayWidth = 3
      FieldName = 'Afdeling'
    end
    object ffEksOvrLager: TWordField
      DisplayWidth = 3
      FieldName = 'Lager'
    end
    object ffEksOvrFiktivtCprNr: TBooleanField
      DisplayLabel = 'Fiktiv'
      FieldName = 'FiktivtCprNr'
      DisplayValues = 'Ja;Nej'
    end
    object ffEksOvrCprCheck: TBooleanField
      DisplayLabel = 'Cpr.check'
      FieldName = 'CprCheck'
      Visible = False
      DisplayValues = 'Ja;Nej'
    end
    object ffEksOvrEjSubstitution: TBooleanField
      DisplayLabel = 'Ej.subst'
      FieldName = 'EjSubstitution'
      Visible = False
      DisplayValues = 'Ja;Nej'
    end
    object ffEksOvrNettoPriser: TBooleanField
      DisplayLabel = 'Netto'
      FieldName = 'NettoPriser'
      Visible = False
      DisplayValues = 'Ja;Nej'
    end
    object ffEksOvrLandeKode: TWordField
      FieldName = 'LandeKode'
      Visible = False
    end
    object ffEksOvrFoedDato: TStringField
      FieldName = 'FoedDato'
      Visible = False
      Size = 8
    end
    object ffEksOvrNarkoNr: TStringField
      FieldName = 'NarkoNr'
      Visible = False
      Size = 10
    end
    object ffEksOvrReceptStatus: TWordField
      Alignment = taLeftJustify
      FieldName = 'ReceptStatus'
      Visible = False
    end
    object ffEksOvrDosStyring: TBooleanField
      FieldName = 'DosStyring'
      Visible = False
      DisplayValues = 'Ja;Nej'
    end
    object ffEksOvrIndikStyring: TBooleanField
      FieldName = 'IndikStyring'
      Visible = False
      DisplayValues = 'Ja;Nej'
    end
    object ffEksOvrAntLin: TWordField
      FieldName = 'AntLin'
      Visible = False
    end
    object ffEksOvrAntVarer: TWordField
      FieldName = 'AntVarer'
      Visible = False
    end
    object ffEksOvrDKAnt: TWordField
      FieldName = 'DKAnt'
      Visible = False
    end
    object ffEksOvrReceptDato: TDateTimeField
      DisplayWidth = 10
      FieldName = 'ReceptDato'
      Visible = False
      DisplayFormat = 'dd-mm-yyyy'
    end
    object ffEksOvrForfaldsdato: TDateTimeField
      DisplayWidth = 10
      FieldName = 'Forfaldsdato'
      Visible = False
      DisplayFormat = 'dd-mm-yyyy'
    end
    object ffEksOvrKontrolFejl: TWordField
      FieldName = 'KontrolFejl'
      Visible = False
    end
    object ffEksOvrTitel: TStringField
      FieldName = 'Titel'
      Visible = False
      Size = 30
    end
    object ffEksOvrAdr1: TStringField
      FieldName = 'Adr1'
      Visible = False
      Size = 30
    end
    object ffEksOvrAdr2: TStringField
      FieldName = 'Adr2'
      Visible = False
      Size = 30
    end
    object ffEksOvrPostNr: TStringField
      FieldName = 'PostNr'
      Visible = False
    end
    object ffEksOvrLand: TStringField
      FieldName = 'Land'
      Visible = False
      Size = 30
    end
    object ffEksOvrKontakt: TStringField
      FieldName = 'Kontakt'
      Visible = False
      Size = 30
    end
    object ffEksOvrTlfNr: TStringField
      FieldName = 'TlfNr'
      Visible = False
      Size = 30
    end
    object ffEksOvrTlfNr2: TStringField
      FieldName = 'TlfNr2'
      Visible = False
      Size = 30
    end
    object ffEksOvrKontoNavn: TStringField
      FieldName = 'KontoNavn'
      Visible = False
      Size = 30
    end
    object ffEksOvrLeveringsForm: TWordField
      DisplayLabel = 'Lev'
      DisplayWidth = 3
      FieldName = 'LeveringsForm'
      OnGetText = LevFormGetText
      OnSetText = LevFormSetText
    end
    object ffEksOvrPrisGruppe: TWordField
      FieldName = 'PrisGruppe'
      Visible = False
    end
    object ffEksOvrSprog: TWordField
      FieldName = 'Sprog'
      Visible = False
    end
    object ffEksOvrVigtigBem: TMemoField
      FieldName = 'VigtigBem'
      Visible = False
      BlobType = ftMemo
    end
    object ffEksOvrBrutto: TCurrencyField
      FieldName = 'Brutto'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrRabatLin: TCurrencyField
      FieldName = 'RabatLin'
      Visible = False
    end
    object ffEksOvrRabatPct: TCurrencyField
      FieldName = 'RabatPct'
      Visible = False
    end
    object ffEksOvrRabat: TCurrencyField
      FieldName = 'Rabat'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrInclMoms: TBooleanField
      FieldName = 'InclMoms'
      Visible = False
    end
    object ffEksOvrExMoms: TCurrencyField
      DisplayLabel = 'Excl.moms'
      FieldName = 'ExMoms'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrMomsPct: TCurrencyField
      FieldName = 'MomsPct'
      Visible = False
    end
    object ffEksOvrMoms: TCurrencyField
      FieldName = 'Moms'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrNetto: TCurrencyField
      FieldName = 'Netto'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrTilskAmt: TCurrencyField
      DisplayLabel = 'Amtet'
      FieldName = 'TilskAmt'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrTilskKom: TCurrencyField
      DisplayLabel = 'Kommunen'
      FieldName = 'TilskKom'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrAndel: TCurrencyField
      DisplayLabel = 'Pat.andel'
      FieldName = 'Andel'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrDKTilsk: TCurrencyField
      DisplayLabel = 'DK.Tilskud'
      FieldName = 'DKTilsk'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrDKEjTilsk: TCurrencyField
      DisplayLabel = 'DK.Ej.tilskud'
      FieldName = 'DKEjTilsk'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrEdbGebyr: TCurrencyField
      DisplayLabel = 'Edb-gebyr'
      FieldName = 'EdbGebyr'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrTlfGebyr: TCurrencyField
      DisplayLabel = 'Tlf-gebyr'
      FieldName = 'TlfGebyr'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrUdbrGebyr: TCurrencyField
      DisplayLabel = 'Udbr.gebyr'
      FieldName = 'UdbrGebyr'
      DisplayFormat = '###,###,##0.00'
    end
    object ffEksOvrLMSModtager: TStringField
      FieldName = 'LMSModtager'
      Size = 10
    end
    object ffEksOvrYderCprNr: TStringField
      FieldName = 'YderCprNr'
      Size = 10
    end
    object ffEksOvrKontrolDato: TDateTimeField
      DisplayWidth = 18
      FieldName = 'KontrolDato'
    end
    object ffEksOvrOrdreDato: TDateTimeField
      DisplayLabel = 'CTRDato'
      DisplayWidth = 18
      FieldName = 'OrdreDato'
      DisplayFormat = 'dd-mm-yyyy hh:mm:ss'
    end
    object ffEksOvrBonnr: TLargeintField
      DisplayWidth = 10
      FieldKind = fkCalculated
      FieldName = 'Bonnr'
      Calculated = True
    end
    object ffEksOvrRSQueueStatus: TIntegerField
      FieldName = 'RSQueueStatus'
    end
    object ffEksOvrReturdage: TWordField
      FieldName = 'Returdage'
    end
  end
  object ffLinOvr: TnxTable
    Session = nxSess
    AliasName = 'PRODUKTION'
    AfterScroll = ffLinOvrAfterScroll
    TableName = 'EkspLinierSalg'
    IndexName = 'NrOrden'
    MasterFields = 'LbNr'
    MasterSource = dsEksOvr
    Left = 691
    Top = 112
    object ffLinOvrLbNr: TIntegerField
      FieldName = 'LbNr'
      Visible = False
    end
    object ffLinOvrLinieNr: TWordField
      DisplayLabel = '#'
      DisplayWidth = 2
      FieldName = 'LinieNr'
    end
    object ffLinOvrLinieType: TWordField
      DisplayLabel = 'Type'
      DisplayWidth = 8
      FieldName = 'LinieType'
      OnGetText = LinieTypeGetText
      OnSetText = LinieTypeSetText
    end
    object ffLinOvrVareNr: TStringField
      DisplayLabel = 'Varenr'
      DisplayWidth = 6
      FieldName = 'VareNr'
    end
    object ffLinOvrSubVareNr: TStringField
      DisplayLabel = 'Sub.nr'
      DisplayWidth = 6
      FieldName = 'SubVareNr'
    end
    object ffLinOvrTekst: TStringField
      DisplayWidth = 25
      FieldName = 'Tekst'
      Size = 100
    end
    object ffLinOvrAntal: TIntegerField
      DisplayLabel = 'Ant'
      DisplayWidth = 2
      FieldName = 'Antal'
    end
    object ffLinOvrPris: TCurrencyField
      DisplayWidth = 9
      FieldName = 'Pris'
      DisplayFormat = '###,###,##0.00'
    end
    object ffLinOvrBrutto: TCurrencyField
      DisplayWidth = 9
      FieldName = 'Brutto'
      DisplayFormat = '###,###,##0.00'
    end
    object ffLinOvrSSKode: TStringField
      DisplayLabel = 'SS'
      FieldName = 'SSKode'
      Size = 2
    end
    object ffLinOvrForm: TStringField
      DisplayWidth = 15
      FieldName = 'Form'
    end
    object ffLinOvrEjG: TWordField
      DisplayLabel = '-G'
      DisplayWidth = 2
      FieldName = 'EjG'
      Visible = False
      DisplayFormat = '#'
    end
    object ffLinOvrEjO: TWordField
      DisplayLabel = '-O'
      DisplayWidth = 2
      FieldName = 'EjO'
      Visible = False
      DisplayFormat = '#'
    end
    object ffLinOvrEjS: TWordField
      DisplayLabel = '-S'
      DisplayWidth = 2
      FieldName = 'EjS'
      DisplayFormat = '#'
    end
    object ffLinOvrLager: TWordField
      DisplayWidth = 3
      FieldName = 'Lager'
    end
    object ffLinOvrStyrke: TStringField
      DisplayWidth = 15
      FieldName = 'Styrke'
    end
    object ffLinOvrPakning: TStringField
      DisplayWidth = 20
      FieldName = 'Pakning'
      Size = 30
    end
    object ffLinOvrATCType: TStringField
      DisplayLabel = 'ATC'
      FieldName = 'ATCType'
      Size = 3
    end
    object ffLinOvrATCKode: TStringField
      FieldName = 'ATCKode'
      Size = 7
    end
    object ffLinOvrUdLevType: TStringField
      DisplayLabel = 'Bestem'
      FieldName = 'UdLevType'
      Size = 5
    end
    object ffLinOvrStatNr: TStringField
      FieldName = 'StatNr'
      Visible = False
    end
    object ffLinOvrLokation1: TWordField
      FieldName = 'Lokation1'
      Visible = False
    end
    object ffLinOvrLokation2: TWordField
      FieldName = 'Lokation2'
      Visible = False
    end
    object ffLinOvrLokation3: TWordField
      FieldName = 'Lokation3'
      Visible = False
    end
    object ffLinOvrVareType: TWordField
      FieldName = 'VareType'
      Visible = False
    end
    object ffLinOvrVareGruppe: TWordField
      FieldName = 'VareGruppe'
      Visible = False
    end
    object ffLinOvrStatGruppe: TWordField
      FieldName = 'StatGruppe'
      Visible = False
    end
    object ffLinOvrOmsType: TWordField
      FieldName = 'OmsType'
      Visible = False
    end
    object ffLinOvrNarkoType: TWordField
      FieldName = 'NarkoType'
      Visible = False
    end
    object ffLinOvrTilskType: TWordField
      FieldName = 'TilskType'
      Visible = False
    end
    object ffLinOvrDKType: TWordField
      FieldName = 'DKType'
      Visible = False
    end
    object ffLinOvrEnhed: TStringField
      FieldName = 'Enhed'
      Visible = False
      Size = 5
    end
    object ffLinOvrKlausul: TStringField
      FieldName = 'Klausul'
      Visible = False
      Size = 5
    end
    object ffLinOvrPAKode: TStringField
      DisplayLabel = 'PI'
      FieldName = 'PAKode'
      Size = 2
    end
    object ffLinOvrDDD: TIntegerField
      FieldName = 'DDD'
      Visible = False
    end
    object ffLinOvrUdlevNr: TWordField
      DisplayLabel = 'Gang'
      DisplayWidth = 2
      FieldName = 'UdlevNr'
    end
    object ffLinOvrUdlevMax: TWordField
      DisplayLabel = 'Max'
      DisplayWidth = 2
      FieldName = 'UdlevMax'
    end
    object ffLinOvrKostPris: TCurrencyField
      DisplayWidth = 9
      FieldName = 'KostPris'
      DisplayFormat = '###,###,##0.00'
    end
    object ffLinOvrVareForbrug: TCurrencyField
      DisplayWidth = 9
      FieldName = 'VareForbrug'
      DisplayFormat = '###,###,##0.00'
    end
    object ffLinOvrRabatPct: TCurrencyField
      FieldName = 'RabatPct'
      Visible = False
    end
    object ffLinOvrDyreArt: TWordField
      FieldName = 'DyreArt'
    end
    object ffLinOvrAldersGrp: TWordField
      FieldName = 'AldersGrp'
    end
    object ffLinOvrOrdGrp: TWordField
      FieldName = 'OrdGrp'
    end
    object ffLinOvrRabat: TCurrencyField
      DisplayWidth = 9
      FieldName = 'Rabat'
      Visible = False
      DisplayFormat = '###,###,##0.00'
    end
    object ffLinOvrExMoms: TCurrencyField
      DisplayWidth = 9
      FieldName = 'ExMoms'
      Visible = False
      DisplayFormat = '###,###,##0.00'
    end
    object ffLinOvrInclMoms: TBooleanField
      FieldName = 'InclMoms'
      Visible = False
      DisplayValues = 'Ja;Nej'
    end
    object ffLinOvrMomsPct: TCurrencyField
      FieldName = 'MomsPct'
      Visible = False
    end
    object ffLinOvrMoms: TCurrencyField
      DisplayWidth = 9
      FieldName = 'Moms'
      Visible = False
      DisplayFormat = '###,###,##0.00'
    end
    object ffLinOvrNetto: TCurrencyField
      DisplayWidth = 9
      FieldName = 'Netto'
      Visible = False
      DisplayFormat = '###,###,##0.00'
    end
    object ffLinOvrBatchNr: TStringField
      FieldName = 'BatchNr'
      Size = 25
    end
    object ffLinOvrUdDato: TDateTimeField
      FieldName = 'UdDato'
      DisplayFormat = 'dd-mm-yyyy'
    end
  end
  object ffTilOvr: TnxTable
    Session = nxSess
    AliasName = 'produktion'
    TableName = 'EkspLinierTilskud'
    IndexName = 'NrOrden'
    MasterFields = 'LbNr'
    MasterSource = dsEksOvr
    Left = 741
    Top = 112
    object ffTilOvrLbNr: TIntegerField
      FieldName = 'LbNr'
      Visible = False
    end
    object ffTilOvrLinieNr: TWordField
      FieldName = 'LinieNr'
      Visible = False
    end
    object ffTilOvrESP: TCurrencyField
      DisplayWidth = 9
      FieldName = 'ESP'
      Visible = False
      DisplayFormat = '###,###,##0.00'
    end
    object ffTilOvrCtrIndberettet: TWordField
      DisplayLabel = 'CP'
      DisplayWidth = 2
      FieldName = 'CtrIndberettet'
      OnGetText = CtrPemGetText
      OnSetText = CtrPemSetText
    end
    object ffTilOvrTilskSyg: TCurrencyField
      DisplayLabel = 'Sygesikring'
      DisplayWidth = 9
      FieldName = 'TilskSyg'
      DisplayFormat = '###,###,##0.00'
    end
    object ffTilOvrTilskKom1: TCurrencyField
      DisplayLabel = 'Kommune1'
      DisplayWidth = 9
      FieldName = 'TilskKom1'
      DisplayFormat = '###,###,##0.00'
    end
    object ffTilOvrTilskKom2: TCurrencyField
      DisplayLabel = 'Kommune2'
      DisplayWidth = 9
      FieldName = 'TilskKom2'
      DisplayFormat = '###,###,##0.00'
    end
    object ffTilOvrAndel: TCurrencyField
      DisplayLabel = 'Patient'
      DisplayWidth = 9
      FieldName = 'Andel'
      DisplayFormat = '###,###,##0.00'
    end
    object ffTilOvrSaldo: TCurrencyField
      DisplayLabel = 'Ny CTR saldo'
      DisplayWidth = 9
      FieldName = 'Saldo'
      DisplayFormat = '###,###,##0.00'
    end
    object ffTilOvrUdligning: TCurrencyField
      DisplayWidth = 9
      FieldName = 'Udligning'
      DisplayFormat = '###,###,##0.00'
    end
    object ffTilOvrRFP: TCurrencyField
      DisplayWidth = 9
      FieldName = 'RFP'
      DisplayFormat = '###,###,##0.00'
    end
    object ffTilOvrBGP: TCurrencyField
      DisplayWidth = 9
      FieldName = 'BGP'
      DisplayFormat = '###,###,##0.00'
    end
    object ffTilOvrIBPBel: TCurrencyField
      DisplayWidth = 9
      FieldName = 'IBPBel'
      Visible = False
      DisplayFormat = '###,###,##0.00'
    end
    object ffTilOvrBGPBel: TCurrencyField
      DisplayLabel = 'BGP'
      DisplayWidth = 9
      FieldName = 'BGPBel'
      DisplayFormat = '###,###,##0.00'
    end
    object ffTilOvrIBTBel: TCurrencyField
      DisplayWidth = 9
      FieldName = 'IBTBel'
      DisplayFormat = '###,###,##0.00'
    end
    object ffTilOvrRegelSyg: TWordField
      DisplayLabel = 'R.SS'
      DisplayWidth = 3
      FieldName = 'RegelSyg'
    end
    object ffTilOvrPromilleSyg: TWordField
      DisplayLabel = 'P.SS'
      DisplayWidth = 4
      FieldName = 'PromilleSyg'
    end
    object ffTilOvrRegelKom1: TWordField
      DisplayLabel = 'R.K1'
      DisplayWidth = 3
      FieldName = 'RegelKom1'
    end
    object ffTilOvrPromilleKom1: TWordField
      DisplayLabel = 'P.K1'
      DisplayWidth = 4
      FieldName = 'PromilleKom1'
    end
    object ffTilOvrRegelKom2: TWordField
      DisplayLabel = 'R.K2'
      DisplayWidth = 3
      FieldName = 'RegelKom2'
    end
    object ffTilOvrPromilleKom2: TWordField
      DisplayLabel = 'P.K2'
      DisplayWidth = 4
      FieldName = 'PromilleKom2'
    end
    object ffTilOvrJournalNr1: TStringField
      DisplayLabel = 'Journalnr 1'
      DisplayWidth = 12
      FieldName = 'JournalNr1'
      Visible = False
    end
    object ffTilOvrJournalNr2: TStringField
      DisplayLabel = 'Journalnr 2'
      DisplayWidth = 12
      FieldName = 'JournalNr2'
      Visible = False
    end
  end
  object dsEksOvr: TDataSource
    AutoEdit = False
    DataSet = ffEksOvr
    Left = 640
    Top = 159
  end
  object dsLinOvr: TDataSource
    AutoEdit = False
    DataSet = ffLinOvr
    Left = 690
    Top = 159
  end
  object dsTilOvr: TDataSource
    AutoEdit = False
    DataSet = ffTilOvr
    Left = 740
    Top = 160
  end
  object ffEksFak: TnxTable
    TableName = 'EkspForsendelse'
    IndexName = 'FakturaNrOrden'
    Left = 594
    Top = 208
    object ffEksFakFakturaNr: TIntegerField
      FieldName = 'FakturaNr'
    end
    object ffEksFakFakturaType: TStringField
      FieldName = 'FakturaType'
    end
    object ffEksFakUdlignNr: TIntegerField
      FieldName = 'UdlignNr'
    end
    object ffEksFakKontoNr: TStringField
      FieldName = 'KontoNr'
    end
    object ffEksFakAfsluttetDato: TDateTimeField
      FieldName = 'AfsluttetDato'
    end
    object ffEksFakForfaldsdato: TDateTimeField
      FieldName = 'Forfaldsdato'
    end
    object ffEksFakKontoNavn: TStringField
      FieldName = 'KontoNavn'
      Size = 30
    end
    object ffEksFakKontoAdr1: TStringField
      FieldName = 'KontoAdr1'
      Size = 30
    end
    object ffEksFakKontoAdr2: TStringField
      FieldName = 'KontoAdr2'
      Size = 30
    end
    object ffEksFakKontoAdr3: TStringField
      FieldName = 'KontoAdr3'
      Size = 30
    end
    object ffEksFakLevNavn: TStringField
      FieldName = 'LevNavn'
      Size = 30
    end
    object ffEksFakLevAdr1: TStringField
      FieldName = 'LevAdr1'
      Size = 30
    end
    object ffEksFakLevAdr2: TStringField
      FieldName = 'LevAdr2'
      Size = 30
    end
    object ffEksFakLevAdr3: TStringField
      FieldName = 'LevAdr3'
      Size = 30
    end
    object ffEksFakKontoGruppe: TWordField
      FieldName = 'KontoGruppe'
    end
    object ffEksFakAfdeling: TWordField
      FieldName = 'Afdeling'
    end
    object ffEksFakLager: TWordField
      FieldName = 'Lager'
    end
    object ffEksFakKreditTekst: TStringField
      FieldName = 'KreditTekst'
      Size = 30
    end
    object ffEksFakLeveringsTekst: TStringField
      FieldName = 'LeveringsTekst'
    end
    object ffEksFakPakkeseddel: TWordField
      FieldName = 'Pakkeseddel'
    end
    object ffEksFakFaktura: TWordField
      FieldName = 'Faktura'
    end
    object ffEksFakBetalingskort: TWordField
      FieldName = 'Betalingskort'
    end
    object ffEksFakLeveringsseddel: TWordField
      FieldName = 'Leveringsseddel'
    end
    object ffEksFakAdrEtiket: TWordField
      FieldName = 'AdrEtiket'
    end
    object ffEksFakBrutto: TCurrencyField
      FieldName = 'Brutto'
    end
    object ffEksFakTilskAmt: TCurrencyField
      FieldName = 'TilskAmt'
    end
    object ffEksFakTilskKom: TCurrencyField
      FieldName = 'TilskKom'
    end
    object ffEksFakPakkeRabat: TCurrencyField
      FieldName = 'PakkeRabat'
    end
    object ffEksFakFakturaRabat: TCurrencyField
      FieldName = 'FakturaRabat'
    end
    object ffEksFakUdbrGebyr: TCurrencyField
      FieldName = 'UdbrGebyr'
    end
    object ffEksFakKontoGebyr: TCurrencyField
      FieldName = 'KontoGebyr'
    end
    object ffEksFakEDBGebyr: TCurrencyField
      FieldName = 'EDBGebyr'
    end
    object ffEksFakTlfRcpGebyr: TCurrencyField
      FieldName = 'TlfRcpGebyr'
    end
    object ffEksFakNetto: TCurrencyField
      FieldName = 'Netto'
    end
    object ffEksFakExMoms: TCurrencyField
      FieldName = 'ExMoms'
    end
    object ffEksFakMoms: TCurrencyField
      FieldName = 'Moms'
    end
    object ffEksFakAntalPakker: TSmallintField
      FieldName = 'AntalPakker'
    end
    object ffEksFakEFaktOrdreNr: TStringField
      FieldName = 'EFaktOrdreNr'
    end
  end
  object ffAfrEks: TnxTable
    TableName = 'Ekspeditioner'
    IndexName = 'DatoOrden'
    Left = 640
    Top = 304
    object ffAfrEksLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object ffAfrEksKundeNr: TStringField
      FieldName = 'KundeNr'
    end
    object ffAfrEksCprCheck: TBooleanField
      FieldName = 'CprCheck'
    end
    object ffAfrEksBarn: TBooleanField
      FieldName = 'Barn'
    end
    object ffAfrEksAmt: TWordField
      FieldName = 'Amt'
    end
    object ffAfrEksKommune: TWordField
      FieldName = 'Kommune'
    end
    object ffAfrEksKundeType: TWordField
      FieldName = 'KundeType'
    end
    object ffAfrEksCtrType: TWordField
      FieldName = 'CtrType'
    end
    object ffAfrEksFoedDato: TStringField
      FieldName = 'FoedDato'
      Size = 8
    end
    object ffAfrEksOrdreType: TWordField
      FieldName = 'OrdreType'
    end
    object ffAfrEksOrdreStatus: TWordField
      FieldName = 'OrdreStatus'
    end
    object ffAfrEksEkspType: TWordField
      FieldName = 'EkspType'
    end
    object ffAfrEksEkspForm: TWordField
      FieldName = 'EkspForm'
    end
    object ffAfrEksAntLin: TWordField
      FieldName = 'AntLin'
    end
    object ffAfrEksAfsluttetDato: TDateTimeField
      DisplayWidth = 10
      FieldName = 'AfsluttetDato'
      DisplayFormat = 'dd-mm-yyyy'
    end
    object ffAfrEksBrugerTakser: TWordField
      DisplayLabel = 'Bruger'
      DisplayWidth = 2
      FieldName = 'BrugerTakser'
    end
    object ffAfrEksYderNr: TStringField
      FieldName = 'YderNr'
      Size = 10
    end
    object ffAfrEksNarkoNr: TStringField
      FieldName = 'NarkoNr'
      Size = 10
    end
    object ffAfrEksYderCprNr: TStringField
      FieldName = 'YderCprNr'
      Size = 10
    end
    object ffAfrEksYderNavn: TStringField
      FieldName = 'YderNavn'
      Size = 30
    end
    object ffAfrEksNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object ffAfrEksTakserDato: TDateTimeField
      DisplayWidth = 10
      FieldName = 'TakserDato'
      DisplayFormat = 'dd-mm-yyyy'
    end
    object ffAfrEksPakkeNr: TIntegerField
      FieldName = 'PakkeNr'
    end
    object ffAfrEksFakturaNr: TIntegerField
      FieldName = 'FakturaNr'
    end
    object ffAfrEksLeveringsForm: TWordField
      FieldName = 'LeveringsForm'
    end
    object ffAfrEksFiktivtCprNr: TBooleanField
      FieldName = 'FiktivtCprNr'
    end
    object ffAfrEksNettoPriser: TBooleanField
      FieldName = 'NettoPriser'
    end
    object ffAfrEksEdbGebyr: TCurrencyField
      FieldName = 'EdbGebyr'
      DisplayFormat = '###,###,##0.00'
    end
    object ffAfrEksTlfGebyr: TCurrencyField
      FieldName = 'TlfGebyr'
      DisplayFormat = '###,###,##0.00'
    end
    object ffAfrEksUdbrGebyr: TCurrencyField
      FieldName = 'UdbrGebyr'
      DisplayFormat = '###,###,##0.00'
    end
    object ffAfrEksAfdeling: TWordField
      FieldName = 'Afdeling'
    end
    object ffAfrEksKontoNr: TStringField
      FieldName = 'KontoNr'
    end
    object ffAfrEksLager: TWordField
      FieldName = 'Lager'
    end
    object ffAfrEksLMSModtager: TStringField
      FieldName = 'LMSModtager'
      Size = 10
    end
    object ffAfrEksUdlignNr: TIntegerField
      FieldName = 'UdlignNr'
    end
  end
  object dsAfrEks: TDataSource
    AutoEdit = False
    DataSet = ffAfrEks
    Left = 640
    Top = 348
  end
  object ffAfrLin: TnxTable
    TableName = 'EkspLinierSalg'
    IndexName = 'NrOrden'
    MasterFields = 'LbNr'
    MasterSource = dsAfrEks
    Left = 692
    Top = 304
    object ffAfrLinLbNr: TIntegerField
      FieldName = 'LbNr'
      Visible = False
    end
    object ffAfrLinLinieNr: TWordField
      FieldName = 'LinieNr'
      Visible = False
    end
    object ffAfrLinLinieType: TWordField
      FieldName = 'LinieType'
      Visible = False
    end
    object ffAfrLinVareNr: TStringField
      DisplayLabel = 'Nr'
      DisplayWidth = 6
      FieldName = 'VareNr'
    end
    object ffAfrLinSubVareNr: TStringField
      FieldName = 'SubVareNr'
      Visible = False
    end
    object ffAfrLinTilskType: TWordField
      FieldName = 'TilskType'
      Visible = False
    end
    object ffAfrLinUdlevMax: TWordField
      FieldName = 'UdlevMax'
      Visible = False
    end
    object ffAfrLinUdlevNr: TWordField
      FieldName = 'UdlevNr'
      Visible = False
    end
    object ffAfrLinAntal: TIntegerField
      DisplayLabel = 'Ant'
      DisplayWidth = 3
      FieldName = 'Antal'
    end
    object ffAfrLinPris: TCurrencyField
      FieldName = 'Pris'
      DisplayFormat = '###,###,##0.00'
    end
    object ffAfrLinSSKode: TStringField
      FieldName = 'SSKode'
      Visible = False
      Size = 2
    end
    object ffAfrLinTekst: TStringField
      DisplayWidth = 19
      FieldName = 'Tekst'
      Size = 100
    end
    object ffAfrLinForm: TStringField
      DisplayWidth = 14
      FieldName = 'Form'
    end
    object ffAfrLinStyrke: TStringField
      DisplayWidth = 14
      FieldName = 'Styrke'
    end
    object ffAfrLinPakning: TStringField
      DisplayWidth = 14
      FieldName = 'Pakning'
      Size = 30
    end
    object ffAfrLinBrutto: TCurrencyField
      FieldName = 'Brutto'
      Visible = False
    end
    object ffAfrLinDyreArt: TWordField
      FieldName = 'DyreArt'
      Visible = False
    end
    object ffAfrLinAldersGrp: TWordField
      FieldName = 'AldersGrp'
      Visible = False
    end
    object ffAfrLinOrdGrp: TWordField
      FieldName = 'OrdGrp'
      Visible = False
    end
    object ffAfrLinEjS: TWordField
      FieldName = 'EjS'
      Visible = False
    end
    object ffAfrLinEjO: TWordField
      FieldName = 'EjO'
      Visible = False
    end
    object ffAfrLinEjG: TWordField
      FieldName = 'EjG'
      Visible = False
    end
    object ffAfrLinUdLevType: TStringField
      FieldName = 'UdLevType'
      Visible = False
      Size = 5
    end
    object ffAfrLinKostPris: TCurrencyField
      FieldName = 'KostPris'
    end
    object ffAfrLinVareForbrug: TCurrencyField
      FieldName = 'VareForbrug'
    end
  end
  object dsAfrLin: TDataSource
    AutoEdit = False
    DataSet = ffAfrLin
    Left = 692
    Top = 348
  end
  object ffAfrTil: TnxTable
    TableName = 'EkspLinierTilskud'
    IndexName = 'NrOrden'
    MasterFields = 'LbNr;LinieNr'
    MasterSource = dsAfrLin
    Left = 740
    Top = 304
    object ffAfrTilLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object ffAfrTilLinieNr: TWordField
      FieldName = 'LinieNr'
    end
    object ffAfrTilESP: TCurrencyField
      FieldName = 'ESP'
    end
    object ffAfrTilRFP: TCurrencyField
      FieldName = 'RFP'
    end
    object ffAfrTilBGP: TCurrencyField
      FieldName = 'BGP'
    end
    object ffAfrTilSaldo: TCurrencyField
      FieldName = 'Saldo'
    end
    object ffAfrTilIBPBel: TCurrencyField
      FieldName = 'IBPBel'
    end
    object ffAfrTilBGPBel: TCurrencyField
      FieldName = 'BGPBel'
    end
    object ffAfrTilIBTBel: TCurrencyField
      FieldName = 'IBTBel'
    end
    object ffAfrTilUdligning: TCurrencyField
      FieldName = 'Udligning'
    end
    object ffAfrTilAndel: TCurrencyField
      FieldName = 'Andel'
    end
    object ffAfrTilTilskSyg: TCurrencyField
      FieldName = 'TilskSyg'
    end
    object ffAfrTilTilskKom1: TCurrencyField
      FieldName = 'TilskKom1'
    end
    object ffAfrTilTilskKom2: TCurrencyField
      FieldName = 'TilskKom2'
    end
    object ffAfrTilRegelSyg: TWordField
      FieldName = 'RegelSyg'
    end
    object ffAfrTilRegelKom1: TWordField
      FieldName = 'RegelKom1'
    end
    object ffAfrTilRegelKom2: TWordField
      FieldName = 'RegelKom2'
    end
    object ffAfrTilPromilleSyg: TWordField
      FieldName = 'PromilleSyg'
    end
    object ffAfrTilPromilleKom1: TWordField
      FieldName = 'PromilleKom1'
    end
    object ffAfrTilPromilleKom2: TWordField
      FieldName = 'PromilleKom2'
    end
    object ffAfrTilJournalNr1: TStringField
      FieldName = 'JournalNr1'
    end
    object ffAfrTilJournalNr2: TStringField
      FieldName = 'JournalNr2'
    end
    object ffAfrTilAfdeling1: TStringField
      FieldName = 'Afdeling1'
      Visible = False
      Size = 30
    end
    object ffAfrTilAfdeling2: TStringField
      FieldName = 'Afdeling2'
      Visible = False
      Size = 30
    end
  end
  object cdDyrArt: TClientDataSet
    PersistDataPacket.Data = {
      6E0000009619E0BD0100000018000000050000000000030000006E00024E7202
      000100000000000A416E76656E64656C7365020001000000000005416C646572
      0200010000000000064F72644772700200010000000000044E61766E01004900
      00000100055749445448020002001E000000}
    Active = True
    Aggregates = <>
    Filtered = True
    FieldDefs = <
      item
        Name = 'Nr'
        DataType = ftSmallint
      end
      item
        Name = 'Anvendelse'
        DataType = ftSmallint
      end
      item
        Name = 'Alder'
        DataType = ftSmallint
      end
      item
        Name = 'OrdGrp'
        DataType = ftSmallint
      end
      item
        Name = 'Navn'
        DataType = ftString
        Size = 30
      end>
    IndexDefs = <
      item
        Name = 'NrOrden'
        Fields = 'Nr'
      end>
    IndexName = 'NrOrden'
    Params = <>
    StoreDefs = True
    OnFilterRecord = cdDyrArtFilterRecord
    Left = 217
    Top = 520
    object cdDyrArtNr: TSmallintField
      DisplayWidth = 3
      FieldName = 'Nr'
    end
    object cdDyrArtAnvendelse: TSmallintField
      FieldName = 'Anvendelse'
    end
    object cdDyrArtAlder: TSmallintField
      FieldName = 'Alder'
    end
    object cdDyrArtOrdGrp: TSmallintField
      FieldName = 'OrdGrp'
    end
    object cdDyrArtNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
  end
  object cdDyrAld: TClientDataSet
    PersistDataPacket.Data = {
      4D0000009619E0BD0100000018000000030000000000030000004D00024E7202
      00010000000000064772757070650200010000000000044E61766E0100490000
      000100055749445448020002001E000000}
    Active = True
    Aggregates = <>
    Filtered = True
    FieldDefs = <
      item
        Name = 'Nr'
        DataType = ftSmallint
      end
      item
        Name = 'Gruppe'
        DataType = ftSmallint
      end
      item
        Name = 'Navn'
        DataType = ftString
        Size = 30
      end>
    IndexDefs = <
      item
        Name = 'NrOrden'
        Fields = 'Nr'
      end>
    IndexName = 'NrOrden'
    Params = <>
    StoreDefs = True
    OnFilterRecord = cdDyrAldFilterRecord
    Left = 268
    Top = 520
    object cdDyrAldNr: TSmallintField
      DisplayWidth = 3
      FieldName = 'Nr'
    end
    object cdDyrAldGruppe: TSmallintField
      FieldName = 'Gruppe'
    end
    object cdDyrAldNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
  end
  object cdDyrOrd: TClientDataSet
    PersistDataPacket.Data = {
      4D0000009619E0BD0100000018000000030000000000030000004D00024E7202
      00010000000000064772757070650200010000000000044E61766E0100490000
      000100055749445448020002001E000000}
    Active = True
    Aggregates = <>
    Filtered = True
    FieldDefs = <
      item
        Name = 'Nr'
        DataType = ftSmallint
      end
      item
        Name = 'Gruppe'
        DataType = ftSmallint
      end
      item
        Name = 'Navn'
        DataType = ftString
        Size = 30
      end>
    IndexDefs = <
      item
        Name = 'NrOrden'
        Fields = 'Nr'
      end>
    IndexName = 'NrOrden'
    Params = <>
    StoreDefs = True
    OnFilterRecord = cdDyrOrdFilterRecord
    Left = 319
    Top = 520
    object cdDyrOrdNr: TSmallintField
      DisplayWidth = 3
      FieldName = 'Nr'
    end
    object cdDyrOrdGruppe: TSmallintField
      FieldName = 'Gruppe'
    end
    object cdDyrOrdNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
  end
  object dsDyrArt: TDataSource
    DataSet = cdDyrArt
    Left = 219
    Top = 569
  end
  object dsDyrAld: TDataSource
    DataSet = cdDyrAld
    Left = 269
    Top = 569
  end
  object dsDyrOrd: TDataSource
    DataSet = cdDyrOrd
    Left = 321
    Top = 569
  end
  object ffEtkOvr: TnxTable
    Session = nxSess
    AutoCalcFields = False
    TableName = 'EkspLinierEtiket'
    IndexName = 'NrOrden'
    MasterFields = 'LbNr'
    MasterSource = dsEksOvr
    Left = 792
    Top = 112
    object ffEtkOvrLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object ffEtkOvrLinieNr: TWordField
      FieldName = 'LinieNr'
    end
    object ffEtkOvrDosKode1: TStringField
      FieldName = 'DosKode1'
    end
    object ffEtkOvrDosKode2: TStringField
      FieldName = 'DosKode2'
    end
    object ffEtkOvrIndikKode: TStringField
      FieldName = 'IndikKode'
    end
    object ffEtkOvrTxtKode: TStringField
      FieldName = 'TxtKode'
    end
    object ffEtkOvrEtiket: TMemoField
      FieldName = 'Etiket'
      BlobType = ftMemo
    end
  end
  object dsEtkOvr: TDataSource
    AutoEdit = False
    DataSet = ffEtkOvr
    Left = 792
    Top = 160
  end
  object ffCtrOpd: TnxTable
    OnCalcFields = ffCtrOpdCalcFields
    TableName = 'CtrEfterReg'
    IndexName = 'NrOrden'
    Left = 20
    Top = 188
    object ffCtrOpdNr: TIntegerField
      FieldName = 'Nr'
    end
    object ffCtrOpdDato: TDateTimeField
      FieldName = 'Dato'
    end
    object ffCtrOpdStatus: TIntegerField
      FieldName = 'Status'
    end
    object ffCtrOpdTiNr: TIntegerField
      FieldName = 'TiNr'
    end
    object ffCtrOpdCtr: TBooleanField
      FieldName = 'Ctr'
    end
    object ffCtrOpdPem: TBooleanField
      FieldName = 'Pem'
    end
    object ffCtrOpdDosKode: TWordField
      FieldName = 'DosKode'
    end
    object ffCtrOpdIndKode: TWordField
      FieldName = 'IndKode'
    end
    object ffCtrOpdMessage: TStringField
      FieldKind = fkCalculated
      FieldName = 'Message'
      Size = 55
      Calculated = True
    end
  end
  object dsCtrOpd: TDataSource
    AutoEdit = False
    DataSet = ffCtrOpd
    Left = 20
    Top = 232
  end
  object ffRetEks: TnxTable
    TableName = 'Ekspeditioner'
    IndexName = 'NrOrden'
    Left = 548
    Top = 404
  end
  object ffRetLin: TnxTable
    TableName = 'EkspLinierSalg'
    IndexName = 'NrOrden'
    Left = 592
    Top = 404
  end
  object ffRetTil: TnxTable
    TableName = 'EkspLinierTilskud'
    IndexName = 'NrOrden'
    Left = 640
    Top = 404
  end
  object ffRetEtk: TnxTable
    TableName = 'EkspLinierEtiket'
    IndexName = 'NrOrden'
    Left = 684
    Top = 404
  end
  object ffAtcTxt: TnxTable
    TableName = 'IndikationsTekster'
    IndexName = 'NrOrden'
    Left = 628
    Top = 520
    object ffAtcTxtKode: TStringField
      FieldName = 'Kode'
      Size = 10
    end
    object ffAtcTxtIndikation1: TStringField
      FieldName = 'Indikation1'
      Size = 30
    end
    object ffAtcTxtIndikation2: TStringField
      FieldName = 'Indikation2'
      Size = 30
    end
    object ffAtcTxtIndikation3: TStringField
      FieldName = 'Indikation3'
      Size = 30
    end
    object ffAtcTxtIndikation4: TStringField
      FieldName = 'Indikation4'
      Size = 30
    end
    object ffAtcTxtIndikation5: TStringField
      FieldName = 'Indikation5'
      Size = 30
    end
  end
  object ffDosTxt: TnxTable
    TableName = 'RecepturTekster'
    IndexName = 'NrOrden'
    Left = 576
    Top = 520
    object ffDosTxtKode: TStringField
      FieldName = 'Kode'
      Size = 10
    end
    object ffDosTxtTekst1: TStringField
      FieldName = 'Tekst1'
      Size = 60
    end
    object ffDosTxtTekst2: TStringField
      FieldName = 'Tekst2'
      Size = 250
    end
  end
  object dsEdiRcp: TDataSource
    AutoEdit = False
    Left = 740
    Top = 452
  end
  object ffFrmTxt: TnxTable
    TableName = 'FormularTekster'
    Left = 528
    Top = 520
  end
  object ffIntAkt: TnxTable
    TableName = 'Interaktioner'
    IndexName = 'NrOrden'
    Left = 472
    Top = 176
    object ffIntAktAtcKode1: TStringField
      FieldName = 'AtcKode1'
      Size = 7
    end
    object ffIntAktAtcKode2: TStringField
      FieldName = 'AtcKode2'
      Size = 7
    end
    object ffIntAktAdvNr: TWordField
      FieldName = 'AdvNr'
    end
    object ffIntAktAdvNiveau: TWordField
      FieldName = 'AdvNiveau'
    end
    object ffIntAktVejlNr: TWordField
      FieldName = 'VejlNr'
    end
    object ffIntAktStjerne: TBooleanField
      FieldName = 'Stjerne'
    end
  end
  object ffIntTxt: TnxTable
    AutoCalcFields = False
    TableName = 'InteraktionsTekster'
    IndexName = 'NrOrden'
    Left = 512
    Top = 176
    object ffIntTxtType: TWordField
      FieldName = 'Type'
    end
    object ffIntTxtNr: TWordField
      FieldName = 'Nr'
    end
    object ffIntTxtTekst: TMemoField
      FieldName = 'Tekst'
      BlobType = ftMemo
    end
  end
  object dsIntAkt: TDataSource
    AutoEdit = False
    DataSet = ffIntAkt
    Left = 472
    Top = 224
  end
  object dsIntTxt: TDataSource
    AutoEdit = False
    DataSet = ffIntTxt
    Left = 512
    Top = 224
  end
  object ffEngine: TnxRemoteServerEngine
    ActiveDesigntime = True
    Transport = nxTCPIPTrans
    Left = 684
    Top = 16
  end
  object ffDebKar: TnxTable
    ActiveDesigntime = True
    Session = nxSess
    AliasName = 'Produktion'
    BeforePost = ffDebKarBeforePost
    TableName = 'DebitorKartotek'
    IndexName = 'NrOrden'
    Left = 264
    Top = 184
    object ffDebKarKontoNr: TStringField
      DisplayLabel = 'Debitor'
      DisplayWidth = 12
      FieldName = 'KontoNr'
    end
    object ffDebKarNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object ffDebKarTlfNr: TStringField
      DisplayLabel = 'Tlf.nr'
      DisplayWidth = 12
      FieldName = 'TlfNr'
      Size = 30
    end
    object ffDebKarAdr1: TStringField
      DisplayLabel = 'Adresse'
      FieldName = 'Adr1'
      Size = 30
    end
    object ffDebKarAdr2: TStringField
      FieldName = 'Adr2'
      Visible = False
      Size = 30
    end
    object ffDebKarPostNr: TStringField
      DisplayLabel = 'Postnr'
      DisplayWidth = 6
      FieldName = 'PostNr'
    end
    object ffDebKarBy: TStringField
      DisplayWidth = 20
      FieldKind = fkLookup
      FieldName = 'By'
      LookupDataSet = ffPnLst
      LookupKeyFields = 'PostNr'
      LookupResultField = 'ByNavn'
      KeyFields = 'PostNr'
      Size = 30
      Lookup = True
    end
    object ffDebKarLand: TStringField
      FieldName = 'Land'
      Visible = False
      Size = 30
    end
    object ffDebKarKontakt: TStringField
      FieldName = 'Kontakt'
      Visible = False
      Size = 30
    end
    object ffDebKarTlfNr2: TStringField
      FieldName = 'TlfNr2'
      Visible = False
      Size = 30
    end
    object ffDebKarMobil: TStringField
      FieldName = 'Mobil'
      Visible = False
      Size = 30
    end
    object ffDebKarFaxNr: TStringField
      FieldName = 'FaxNr'
      Visible = False
      Size = 30
    end
    object ffDebKarMail: TStringField
      FieldName = 'Mail'
      Visible = False
      Size = 80
    end
    object ffDebKarLevNavn: TStringField
      FieldName = 'LevNavn'
      Visible = False
      Size = 30
    end
    object ffDebKarLevAdr1: TStringField
      FieldName = 'LevAdr1'
      Visible = False
      Size = 30
    end
    object ffDebKarLevAdr2: TStringField
      FieldName = 'LevAdr2'
      Visible = False
      Size = 30
    end
    object ffDebKarLevPostNr: TStringField
      FieldName = 'LevPostNr'
      Visible = False
    end
    object ffDebKarLevLand: TStringField
      FieldName = 'LevLand'
      Visible = False
      Size = 30
    end
    object ffDebKarLevKontakt: TStringField
      FieldName = 'LevKontakt'
      Visible = False
      Size = 30
    end
    object ffDebKarLevTlfNr: TStringField
      FieldName = 'LevTlfNr'
      Visible = False
      Size = 30
    end
    object ffDebKarCvrNr: TStringField
      FieldName = 'CvrNr'
      Visible = False
    end
    object ffDebKarGiroNr: TStringField
      FieldName = 'GiroNr'
      Visible = False
    end
    object ffDebKarAfdeling: TWordField
      FieldName = 'Afdeling'
      Visible = False
    end
    object ffDebKarLager: TWordField
      FieldName = 'Lager'
      Visible = False
    end
    object ffDebKarDebType: TWordField
      FieldName = 'DebType'
      Visible = False
    end
    object ffDebKarDebGruppe: TWordField
      FieldName = 'DebGruppe'
      Visible = False
    end
    object ffDebKarKreditForm: TWordField
      FieldName = 'KreditForm'
      Visible = False
    end
    object ffDebKarBetalForm: TWordField
      FieldName = 'BetalForm'
      Visible = False
    end
    object ffDebKarLuBetalOpr: TStringField
      FieldKind = fkLookup
      FieldName = 'LuBetalOpr'
      LookupDataSet = ffBetFrm
      LookupKeyFields = 'Nr'
      LookupResultField = 'Operation'
      KeyFields = 'BetalForm'
      Visible = False
      Lookup = True
    end
    object ffDebKarLuBetalTxt: TStringField
      FieldKind = fkLookup
      FieldName = 'LuBetalTxt'
      LookupDataSet = ffBetFrm
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      KeyFields = 'BetalForm'
      Size = 30
      Lookup = True
    end
    object ffDebKarLevForm: TWordField
      FieldName = 'LevForm'
      Visible = False
    end
    object ffDebKarRabatType: TWordField
      FieldName = 'RabatType'
      Visible = False
    end
    object ffDebKarRenteType: TWordField
      FieldName = 'RenteType'
      Visible = False
    end
    object ffDebKarSaldoType: TWordField
      FieldName = 'SaldoType'
      Visible = False
    end
    object ffDebKarValutaType: TWordField
      FieldName = 'ValutaType'
      Visible = False
    end
    object ffDebKarMomsType: TWordField
      FieldName = 'MomsType'
      Visible = False
    end
    object ffDebKarKreditMax: TCurrencyField
      FieldName = 'KreditMax'
      Visible = False
    end
    object ffDebKarAvancePct: TCurrencyField
      FieldName = 'AvancePct'
      Visible = False
    end
    object ffDebKarLuLevTxt: TStringField
      FieldKind = fkLookup
      FieldName = 'LuLevTxt'
      LookupDataSet = ffLevFrm
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      KeyFields = 'LevForm'
      Visible = False
      Size = 30
      Lookup = True
    end
    object ffDebKarPrimo: TCurrencyField
      FieldName = 'Primo'
      Visible = False
    end
    object ffDebKarSaldo: TCurrencyField
      FieldName = 'Saldo'
      Visible = False
    end
    object ffDebKarKontoGebyr: TBooleanField
      FieldName = 'KontoGebyr'
      Visible = False
    end
    object ffDebKarKontoLukket: TBooleanField
      FieldName = 'KontoLukket'
      Visible = False
    end
    object ffDebKarLukketGrund: TStringField
      FieldName = 'LukketGrund'
      Visible = False
      Size = 30
    end
    object ffDebKarRenteDato: TDateTimeField
      FieldName = 'RenteDato'
      Visible = False
    end
    object ffDebKarBevDato: TDateTimeField
      FieldName = 'BevDato'
      Visible = False
    end
    object ffDebKarOpretDato: TDateTimeField
      FieldName = 'OpretDato'
      Visible = False
    end
    object ffDebKarRetDato: TDateTimeField
      FieldName = 'RetDato'
      Visible = False
    end
    object ffDebKarGebyrDato: TDateTimeField
      FieldName = 'GebyrDato'
      Visible = False
    end
    object ffDebKarBem: TMemoField
      FieldName = 'Bem'
      Visible = False
      BlobType = ftMemo
    end
    object ffDebKarLuLevUdbr: TBooleanField
      FieldKind = fkLookup
      FieldName = 'LuLevUdbr'
      LookupDataSet = ffLevFrm
      LookupKeyFields = 'Nr'
      LookupResultField = 'UdbringningsGebyr'
      KeyFields = 'LevForm'
      Visible = False
      Lookup = True
    end
    object ffDebKarLuLevPakke: TBooleanField
      FieldKind = fkLookup
      FieldName = 'LuLevPakke'
      LookupDataSet = ffLevFrm
      LookupKeyFields = 'Nr'
      LookupResultField = 'PakkeGebyr'
      KeyFields = 'LevForm'
      Visible = False
      Lookup = True
    end
    object ffDebKarLuKreditTxt: TStringField
      FieldKind = fkLookup
      FieldName = 'LuKreditTxt'
      LookupDataSet = ffKreFrm
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      KeyFields = 'KreditForm'
      Visible = False
      Size = 30
      Lookup = True
    end
    object ffDebKarFaktForm: TWordField
      FieldName = 'FaktForm'
    end
    object ffDebKarUdbrGebyr: TBooleanField
      FieldName = 'UdbrGebyr'
    end
    object ffDebKarMaster: TBooleanField
      FieldName = 'Master'
      Visible = False
    end
    object ffDebKarMasterFra: TStringField
      FieldName = 'MasterFra'
      Visible = False
    end
    object ffDebKarMasterTil: TStringField
      FieldName = 'MasterTil'
      Visible = False
    end
    object ffDebKarEFaktEanKode: TStringField
      FieldName = 'EFaktEanKode'
      Visible = False
      Size = 13
    end
    object ffDebKarKroniker: TBooleanField
      FieldName = 'Kroniker'
    end
    object ffDebKarKronSaldo: TCurrencyField
      FieldName = 'KronSaldo'
    end
    object ffDebKarEFaktOrdreNr: TStringField
      FieldName = 'EFaktOrdreNr'
    end
    object ffDebKarEFaktPersRef: TStringField
      FieldName = 'EFaktPersRef'
    end
    object ffDebKarEFaktKontoNr: TStringField
      FieldName = 'EFaktKontoNr'
    end
    object ffDebKarEValgOrdreNr: TWordField
      FieldName = 'EValgOrdreNr'
    end
    object ffDebKarEValgPersRef: TWordField
      FieldName = 'EValgPersRef'
    end
    object ffDebKarEValgKontoNr: TWordField
      FieldName = 'EValgKontoNr'
    end
    object ffDebKarEFaktMdFakt: TBooleanField
      FieldName = 'EFaktMdFakt'
    end
    object ffDebKarEValgEanType: TWordField
      FieldName = 'EValgEanType'
    end
    object ffDebKarRemoteStatus: TIntegerField
      FieldName = 'RemoteStatus'
    end
    object ffDebKarFaktura: TBooleanField
      FieldName = 'Faktura'
    end
  end
  object ffLevFrm: TnxTable
    ActiveDesigntime = True
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'LeveringsFormer'
    IndexName = 'NrOrden'
    Left = 796
    Top = 404
    object ffLevFrmNr: TWordField
      FieldName = 'Nr'
    end
    object ffLevFrmOperation: TStringField
      FieldName = 'Operation'
    end
    object ffLevFrmNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object ffLevFrmUdbringningsGebyr: TBooleanField
      FieldName = 'UdbringningsGebyr'
    end
    object ffLevFrmPakkeGebyr: TBooleanField
      FieldName = 'PakkeGebyr'
    end
  end
  object dsDebKar: TDataSource
    AutoEdit = False
    DataSet = ffDebKar
    Left = 264
    Top = 232
  end
  object cdCtrBev: TClientDataSet
    PersistDataPacket.Data = {
      C10000009619E0BD010000001800000008000000000003000000C10005526567
      656C0200020000000000074672614461746F08000800000000000754696C4461
      746F080008000000000007496E644461746F080008000000000006566172654E
      720100490000000100055749445448020002000A000341746301004900000001
      00055749445448020002000A00064C6D4E61766E010049000000010005574944
      54480200020032000641646D56656A0100490000000100055749445448020002
      0014000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Regel'
        DataType = ftWord
      end
      item
        Name = 'FraDato'
        DataType = ftDateTime
      end
      item
        Name = 'TilDato'
        DataType = ftDateTime
      end
      item
        Name = 'IndDato'
        DataType = ftDateTime
      end
      item
        Name = 'VareNr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'Atc'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'LmNavn'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'AdmVej'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <
      item
        Name = 'NrOrden'
        Fields = 'Regel'
        Options = [ixPrimary, ixCaseInsensitive]
      end>
    IndexName = 'NrOrden'
    Params = <>
    StoreDefs = True
    Left = 20
    Top = 304
    object cdCtrBevRegel: TWordField
      DisplayWidth = 5
      FieldName = 'Regel'
    end
    object cdCtrBevFraDato: TDateTimeField
      DisplayLabel = 'Fradato'
      DisplayWidth = 10
      FieldName = 'FraDato'
      DisplayFormat = 'dd-mm-yyyy'
    end
    object cdCtrBevTilDato: TDateTimeField
      DisplayLabel = 'Tildato'
      DisplayWidth = 10
      FieldName = 'TilDato'
      DisplayFormat = 'dd-mm-yyyy'
    end
    object cdCtrBevIndDato: TDateTimeField
      DisplayLabel = 'Indb.dato'
      DisplayWidth = 18
      FieldName = 'IndDato'
      Visible = False
      DisplayFormat = 'dd-mm-yyyy'
    end
    object cdCtrBevVareNr: TStringField
      DisplayLabel = 'Varenr'
      DisplayWidth = 6
      FieldName = 'VareNr'
      Size = 10
    end
    object cdCtrBevAtc: TStringField
      DisplayLabel = 'ATC'
      FieldName = 'Atc'
      Size = 10
    end
    object cdCtrBevLmNavn: TStringField
      DisplayLabel = 'L'#230'gemiddel'
      DisplayWidth = 30
      FieldName = 'LmNavn'
      Size = 50
    end
    object cdCtrBevAdmVej: TStringField
      DisplayLabel = 'Adm.vej'
      DisplayWidth = 15
      FieldName = 'AdmVej'
    end
  end
  object dsCtrBev: TDataSource
    AutoEdit = False
    DataSet = cdCtrBev
    Left = 20
    Top = 348
  end
  object ffLagKar: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    AfterScroll = ffLagKarAfterScroll
    TableName = 'LagerKartotek'
    IndexName = 'NrOrden'
    Left = 332
    Top = 256
    object ffLagKarLager: TWordField
      FieldName = 'Lager'
    end
    object ffLagKarVareNr: TStringField
      FieldName = 'VareNr'
    end
    object ffLagKarDrugId: TStringField
      FieldName = 'DrugId'
      Size = 11
    end
    object ffLagKarEanKode: TStringField
      FieldName = 'EanKode'
    end
    object ffLagKarSamPakNr: TStringField
      FieldName = 'SamPakNr'
      Size = 10
    end
    object ffLagKarSamPakAnt: TWordField
      FieldName = 'SamPakAnt'
    end
    object ffLagKarSampakAfr: TBooleanField
      FieldName = 'SampakAfr'
    end
    object ffLagKarGrNr1: TWordField
      FieldName = 'GrNr1'
    end
    object ffLagKarLokation1: TIntegerField
      FieldName = 'Lokation1'
    end
    object ffLagKarLokation2: TIntegerField
      FieldName = 'Lokation2'
    end
    object ffLagKarEgenGrp1: TIntegerField
      FieldName = 'EgenGrp1'
    end
    object ffLagKarEgenGrp2: TIntegerField
      FieldName = 'EgenGrp2'
    end
    object ffLagKarEgenGrp3: TIntegerField
      FieldName = 'EgenGrp3'
    end
    object ffLagKarMinimum: TIntegerField
      FieldName = 'Minimum'
    end
    object ffLagKarAntal: TIntegerField
      FieldName = 'Antal'
    end
    object ffLagKarVareType: TWordField
      FieldName = 'VareType'
    end
    object ffLagKarKostPris: TCurrencyField
      FieldName = 'KostPris'
    end
    object ffLagKarSalgsPris: TCurrencyField
      FieldName = 'SalgsPris'
    end
    object ffLagKarSalgsPris2: TCurrencyField
      FieldName = 'SalgsPris2'
    end
    object ffLagKarEgenPris: TCurrencyField
      FieldName = 'EgenPris'
    end
    object ffLagKarSubEnhPris: TCurrencyField
      FieldName = 'SubEnhPris'
    end
    object ffLagKarBGP: TCurrencyField
      FieldName = 'BGP'
    end
    object ffLagKarDoKostPris: TCurrencyField
      FieldName = 'DoKostPris'
    end
    object ffLagKarDoSalgsPris: TCurrencyField
      FieldName = 'DoSalgsPris'
    end
    object ffLagKarDoBGP: TCurrencyField
      FieldName = 'DoBGP'
    end
    object ffLagKarSletDato: TDateTimeField
      FieldName = 'SletDato'
    end
    object ffLagKarAfmDato: TDateTimeField
      FieldName = 'AfmDato'
    end
    object ffLagKarSubst: TBooleanField
      FieldName = 'Subst'
    end
    object ffLagKarAtcType: TStringField
      FieldName = 'AtcType'
      Size = 1
    end
    object ffLagKarAtcKode: TStringField
      FieldName = 'AtcKode'
      Size = 15
    end
    object ffLagKarUdlevType: TStringField
      FieldName = 'UdlevType'
      Size = 5
    end
    object ffLagKarHaType: TStringField
      FieldName = 'HaType'
      Size = 2
    end
    object ffLagKarSSKode: TStringField
      FieldName = 'SSKode'
      Size = 2
    end
    object ffLagKarNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object ffLagKarForm: TStringField
      FieldName = 'Form'
    end
    object ffLagKarStyrke: TStringField
      FieldName = 'Styrke'
    end
    object ffLagKarPakning: TStringField
      FieldName = 'Pakning'
      Size = 30
    end
    object ffLagKarPaKode: TStringField
      FieldName = 'PaKode'
      Size = 2
    end
    object ffLagKarSalgsled: TStringField
      FieldName = 'Salgsled'
    end
    object ffLagKarDelPakUdskAnt: TWordField
      FieldName = 'DelPakUdskAnt'
    end
    object ffLagKarRestOrdre: TIntegerField
      FieldName = 'RestOrdre'
    end
    object ffLagKarSubKode: TStringField
      FieldName = 'SubKode'
      Size = 1
    end
    object ffLagKarPaknNum: TIntegerField
      FieldName = 'PaknNum'
    end
    object ffLagKarSubGrp: TWordField
      FieldName = 'SubGrp'
    end
    object ffLagKarOpbevKode: TStringField
      FieldName = 'OpbevKode'
      Size = 1
    end
    object ffLagKarIndbNr: TStringField
      FieldName = 'IndbNr'
      Size = 10
    end
    object ffLagKarVetProdPris: TCurrencyField
      FieldName = 'VetProdPris'
    end
    object ffLagKarVareInfo: TIntegerField
      FieldName = 'VareInfo'
    end
    object ffLagKarSalgsTekst: TStringField
      FieldName = 'SalgsTekst'
      Size = 50
    end
    object ffLagKarDMVS: TWordField
      FieldName = 'DMVS'
    end
    object ffLagKarTiSalgsPris: TCurrencyField
      FieldName = 'TiSalgsPris'
    end
    object ffLagKarTiBGP: TCurrencyField
      FieldName = 'TiBGP'
    end
  end
  object cdDspFrm: TClientDataSet
    PersistDataPacket.Data = {
      520000009619E0BD010000001800000002000000000003000000520006566172
      654E7201004900000001000557494454480200020006000844697370466F726D
      01004900000001000557494454480200020014000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'VareNr'
        DataType = ftString
        Size = 6
      end
      item
        Name = 'DispForm'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <
      item
        Name = 'NrOrden'
        Fields = 'VareNr'
        Options = [ixPrimary, ixUnique, ixCaseInsensitive]
      end>
    IndexName = 'NrOrden'
    Params = <>
    StoreDefs = True
    Left = 372
    Top = 520
    object cdDspFrmVareNr: TStringField
      FieldName = 'VareNr'
      Size = 6
    end
    object cdDspFrmDispForm: TStringField
      FieldName = 'DispForm'
    end
  end
  object cdDosTxt: TClientDataSet
    PersistDataPacket.Data = {
      660000009619E0BD0100000018000000030000000000030000006600024E7201
      004900000001000557494454480200020007000554656B737401004900000001
      0005574944544802000200500006456E6844676E010049000000010005574944
      54480200020009000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Nr'
        DataType = ftString
        Size = 7
      end
      item
        Name = 'Tekst'
        DataType = ftString
        Size = 80
      end
      item
        Name = 'EnhDgn'
        DataType = ftString
        Size = 9
      end>
    IndexDefs = <
      item
        Name = 'NrOrden'
        Fields = 'Nr'
        Options = [ixPrimary, ixUnique, ixCaseInsensitive]
      end>
    IndexName = 'NrOrden'
    Params = <>
    StoreDefs = True
    Left = 424
    Top = 520
    object cdDosTxtNr: TStringField
      FieldName = 'Nr'
      Size = 7
    end
    object cdDosTxtTekst: TStringField
      FieldName = 'Tekst'
      Size = 80
    end
    object cdDosTxtEnhDgn: TStringField
      FieldName = 'EnhDgn'
      Size = 9
    end
  end
  object cdIndTxt: TClientDataSet
    PersistDataPacket.Data = {
      4B0000009619E0BD0100000018000000020000000000030000004B00024E7201
      004900000001000557494454480200020007000554656B737401004900000001
      000557494454480200020050000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Nr'
        DataType = ftString
        Size = 7
      end
      item
        Name = 'Tekst'
        DataType = ftString
        Size = 80
      end>
    IndexDefs = <
      item
        Name = 'NrOrden'
        Fields = 'Nr'
        Options = [ixPrimary, ixUnique, ixCaseInsensitive]
      end>
    IndexName = 'NrOrden'
    Params = <>
    StoreDefs = True
    Left = 476
    Top = 520
    object cdIndTxtNr: TStringField
      FieldName = 'Nr'
      Size = 7
    end
    object cdIndTxtTekst: TStringField
      FieldName = 'Tekst'
      Size = 80
    end
  end
  object ffAfrEtk: TnxTable
    TableName = 'EkspLinierEtiket'
    IndexName = 'NrOrden'
    Left = 796
    Top = 304
    object ffAfrEtkLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object ffAfrEtkLinieNr: TWordField
      FieldName = 'LinieNr'
    end
    object ffAfrEtkIndikKode: TStringField
      FieldName = 'IndikKode'
    end
    object ffAfrEtkDosKode1: TStringField
      FieldName = 'DosKode1'
    end
    object ffAfrEtkDosKode: TStringField
      FieldName = 'DosKode'
    end
  end
  object ffPnLst: TnxTable
    ActiveDesigntime = True
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'PostNumre'
    IndexName = 'NrOrden'
    Left = 116
    Top = 520
    object ffPnLstPostNr: TStringField
      DisplayLabel = 'Postnr'
      DisplayWidth = 10
      FieldName = 'PostNr'
    end
    object ffPnLstByNavn: TStringField
      DisplayLabel = 'Navn'
      FieldName = 'ByNavn'
      Size = 30
    end
  end
  object fqKto: TnxQuery
    Left = 20
    Top = 520
  end
  object dsKto: TDataSource
    DataSet = fqKto
    Left = 20
    Top = 568
  end
  object dsGro: TDataSource
    DataSet = mtGro
    Left = 68
    Top = 568
  end
  object ffdch: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'DosisCardHeader'
    Left = 744
    Top = 520
    object ffdchCardNumber: TWordField
      DisplayLabel = 'KortNummer'
      FieldName = 'CardNumber'
      Required = True
    end
    object ffdchPatientNumber: TStringField
      DisplayLabel = 'CPR Nr'
      FieldName = 'PatientNumber'
      Required = True
      Size = 10
    end
    object ffdchPatientName: TStringField
      DisplayLabel = 'Patientnavn'
      FieldName = 'PatientName'
      Required = True
      Size = 30
    end
    object ffdchPatientAddress1: TStringField
      FieldName = 'PatientAddress1'
      Visible = False
      Size = 30
    end
    object ffdchPatientAddress2: TStringField
      FieldName = 'PatientAddress2'
      Visible = False
      Size = 30
    end
    object ffdchPostnummer: TStringField
      FieldName = 'Postnummer'
      Visible = False
      Size = 30
    end
    object ffdchDeliveryAddress: TStringField
      FieldName = 'DeliveryAddress'
      Visible = False
      Size = 30
    end
    object ffdchKontaktPerson: TStringField
      FieldName = 'KontaktPerson'
      Visible = False
      Size = 30
    end
    object ffdchDoctorNumber: TStringField
      FieldName = 'DoctorNumber'
      Required = True
      Visible = False
      Size = 7
    end
    object ffdchDoctorName: TStringField
      FieldName = 'DoctorName'
      Visible = False
      Size = 30
    end
    object ffdchTelegram: TWordField
      FieldName = 'Telegram'
      Visible = False
    end
    object ffdchStartDate: TDateTimeField
      DisplayLabel = 'StartDato'
      DisplayWidth = 10
      FieldName = 'StartDate'
      Required = True
    end
    object ffdchEndDate: TDateTimeField
      DisplayLabel = 'Slutdato'
      DisplayWidth = 10
      FieldName = 'EndDate'
      Required = True
    end
    object ffdchInterval: TWordField
      FieldName = 'Interval'
      Required = True
      Visible = False
    end
    object ffdchAddDate: TDateTimeField
      FieldName = 'AddDate'
      Visible = False
    end
    object ffdchAdduser: TIntegerField
      FieldName = 'Adduser'
      Visible = False
    end
    object ffdchChangeDate: TDateTimeField
      FieldName = 'ChangeDate'
      Visible = False
    end
    object ffdchChangeUser: TIntegerField
      FieldName = 'ChangeUser'
      Visible = False
    end
    object ffdchDeleteDate: TDateTimeField
      FieldName = 'DeleteDate'
      Visible = False
    end
    object ffdchDeleteUser: TIntegerField
      FieldName = 'DeleteUser'
      Visible = False
    end
    object ffdchPackGroupNumber: TIntegerField
      FieldName = 'PackGroupNumber'
      Visible = False
    end
    object ffdchDoctorComment: TStringField
      FieldName = 'DoctorComment'
      Visible = False
      Size = 250
    end
    object ffdchPharmacistComment: TStringField
      FieldName = 'PharmacistComment'
      Visible = False
      Size = 250
    end
    object ffdchDosiskod: TStringField
      FieldName = 'Dosiskod'
      Required = True
      Visible = False
      Size = 10
    end
    object ffdchSendDate: TDateTimeField
      FieldName = 'SendDate'
      Visible = False
    end
    object ffdchKontroller: TIntegerField
      FieldName = 'Kontroller'
      Visible = False
    end
    object ffdchKontrolDate: TDateTimeField
      FieldName = 'KontrolDate'
      Visible = False
    end
    object ffdchStartDay: TStringField
      FieldName = 'StartDay'
      Visible = False
      Size = 10
    end
    object ffdchFileReceiveDate: TDateTimeField
      FieldName = 'FileReceiveDate'
      Visible = False
    end
    object ffdchOrderReceiveDate: TDateTimeField
      FieldName = 'OrderReceiveDate'
      Visible = False
    end
    object ffdchOrderMemo: TnxMemoField
      FieldName = 'OrderMemo'
      Visible = False
      BlobType = ftMemo
    end
    object ffdchPackAccept: TBooleanField
      FieldName = 'PackAccept'
      Visible = False
    end
    object ffdchBemaerkMemo: TnxMemoField
      FieldName = 'BemaerkMemo'
      Visible = False
      BlobType = ftMemo
    end
    object ffdchParked: TBooleanField
      FieldName = 'Parked'
      Visible = False
    end
    object ffdchYderCprNr: TStringField
      FieldName = 'YderCprNr'
      Visible = False
      Size = 10
    end
    object ffdchAndreTilskud: TBooleanField
      FieldName = 'AndreTilskud'
      Visible = False
    end
    object ffdchKlausuleret: TBooleanField
      FieldName = 'Klausuleret'
      Visible = False
    end
    object ffdchLbnr: TIntegerField
      FieldName = 'Lbnr'
    end
    object ffdchKortStatus: TStringField
      FieldKind = fkCalculated
      FieldName = 'KortStatus'
      OnGetText = ffdchKortStatusGetText
      Calculated = True
    end
    object ffdchAutoEksp: TBooleanField
      FieldName = 'AutoEksp'
    end
    object ffdchTerminalStatus: TBooleanField
      FieldName = 'TerminalStatus'
    end
  end
  object ffdcl: TnxTable
    Session = nxSess
    AliasName = 'PRODUKTION'
    TableName = 'DosisCardLines'
    IndexName = 'cardprod'
    MasterFields = 'CardNumber'
    MasterSource = dsdch
    Left = 800
    Top = 520
    object ffdclCardNumber: TWordField
      FieldName = 'CardNumber'
    end
    object ffdclVareNummer: TStringField
      FieldName = 'VareNummer'
    end
    object ffdclDrugid: TStringField
      FieldName = 'Drugid'
      Size = 11
    end
    object ffdclRegularDose: TBooleanField
      FieldName = 'RegularDose'
    end
    object ffdclDays: TStringField
      FieldName = 'Days'
      Size = 40
    end
    object ffdclQuantity1: TFloatField
      FieldName = 'Quantity1'
    end
    object ffdclQuantity2: TFloatField
      FieldName = 'Quantity2'
    end
    object ffdclQuantity3: TFloatField
      FieldName = 'Quantity3'
    end
    object ffdclQuantity4: TFloatField
      FieldName = 'Quantity4'
    end
    object ffdclQuantity5: TFloatField
      FieldName = 'Quantity5'
    end
    object ffdclQuantity6: TFloatField
      FieldName = 'Quantity6'
    end
    object ffdclQuantity7: TFloatField
      FieldName = 'Quantity7'
    end
    object ffdclQuantity8: TFloatField
      FieldName = 'Quantity8'
    end
    object ffdclVareDescription: TStringField
      FieldName = 'VareDescription'
      Size = 30
    end
    object ffdclVareIndikation: TStringField
      FieldName = 'VareIndikation'
      Size = 30
    end
    object ffdclVareName: TStringField
      FieldName = 'VareName'
      Size = 50
    end
    object ffdclVareIntake: TStringField
      FieldName = 'VareIntake'
      Size = 30
    end
    object ffdclTotalQuantity: TIntegerField
      FieldName = 'TotalQuantity'
    end
    object ffdclKontrolled: TBooleanField
      FieldName = 'Kontrolled'
    end
    object ffdclEjSubst: TBooleanField
      FieldName = 'EjSubst'
    end
    object ffdclRegel4243: TBooleanField
      FieldName = 'Regel4243'
    end
    object ffdclAndreTilskud: TBooleanField
      FieldName = 'AndreTilskud'
    end
    object ffdclKlausuleret: TBooleanField
      FieldName = 'Klausuleret'
    end
    object ffdclOrdid: TStringField
      FieldName = 'Ordid'
      Size = 50
    end
    object ffdclIndikKode: TIntegerField
      FieldName = 'IndikKode'
    end
    object ffdclGammeltVarenr: TStringField
      FieldName = 'GammeltVarenr'
    end
    object ffdclRetVareNrDato: TDateTimeField
      FieldName = 'RetVareNrDato'
    end
    object ffdclBevilRegelNr: TIntegerField
      FieldName = 'BevilRegelNr'
    end
    object ffdclTerminalStatus: TBooleanField
      FieldName = 'TerminalStatus'
    end
  end
  object dsdch: TDataSource
    DataSet = ffdch
    Left = 744
    Top = 564
  end
  object fqSqlSel: TnxQuery
    Left = 16
    Top = 412
  end
  object ffVmLst: TnxTable
    TableName = 'LagerKartotek'
    IndexName = 'NrOrden'
    Left = 356
    Top = 12
    object ffVmLstLager: TWordField
      FieldName = 'Lager'
      Visible = False
    end
    object ffVmLstVareNr: TStringField
      Tag = 1
      DisplayLabel = 'Varenr'
      DisplayWidth = 6
      FieldName = 'VareNr'
    end
    object ffVmLstAtcKode: TStringField
      Tag = 2
      DisplayLabel = 'Atckode'
      DisplayWidth = 8
      FieldName = 'AtcKode'
      Size = 15
    end
    object ffVmLstSubGrp: TWordField
      Tag = 3
      DisplayLabel = 'Grp'
      DisplayWidth = 4
      FieldName = 'SubGrp'
    end
    object ffVmLstNavn: TStringField
      Tag = 4
      DisplayWidth = 25
      FieldName = 'Navn'
      Size = 30
    end
    object ffVmLstPakning: TStringField
      DisplayWidth = 15
      FieldName = 'Pakning'
      Size = 30
    end
    object ffVmLstStyrke: TStringField
      DisplayWidth = 12
      FieldName = 'Styrke'
    end
    object ffVmLstPaKode: TStringField
      DisplayLabel = 'PI'
      FieldName = 'PaKode'
      Size = 2
    end
    object ffVmLstKostPris: TCurrencyField
      DisplayLabel = 'Kostpris'
      DisplayWidth = 9
      FieldName = 'KostPris'
      DisplayFormat = '###,###,###,##0.00'
    end
    object ffVmLstSalgsPris: TCurrencyField
      DisplayLabel = 'Salgspris'
      DisplayWidth = 9
      FieldName = 'SalgsPris'
      DisplayFormat = '###,###,###,##0.00'
    end
    object ffVmLstEgenPris: TCurrencyField
      DisplayLabel = 'Egenpris'
      DisplayWidth = 9
      FieldName = 'EgenPris'
      DisplayFormat = '###,###,###,##0.00'
    end
    object ffVmLstBGP: TCurrencyField
      DisplayLabel = 'TSP'
      DisplayWidth = 9
      FieldName = 'BGP'
      DisplayFormat = '###,###,###,##0.00'
    end
    object ffVmLstSubKode: TStringField
      DisplayLabel = 'S'
      FieldName = 'SubKode'
      Size = 1
    end
    object ffVmLstSubForValg: TStringField
      DisplayLabel = 'FV'
      DisplayWidth = 2
      FieldName = 'SubForValg'
      Size = 1
    end
  end
  object dsVmLst: TDataSource
    DataSet = ffVmLst
    Left = 356
    Top = 60
  end
  object nxTCPIPTrans: TnxWinsockTransport
    DisplayCategory = 'Transports'
    ActiveDesigntime = True
    ServerNameDesigntime = '127.0.0.1'
    Left = 632
    Top = 16
  end
  object dsRetLin: TDataSource
    DataSet = ffRetLin
    Left = 592
    Top = 456
  end
  object nxEksCred: TnxTable
    TableName = 'EkspeditionerCredit'
    Left = 408
    Top = 256
  end
  object nxKombi: TnxQuery
    Left = 64
    Top = 416
  end
  object fqLevList: TnxQuery
    Left = 336
    Top = 304
  end
  object fqOpenEDI: TnxQuery
    Left = 392
    Top = 304
  end
  object fqEksOvr: TnxQuery
    Session = nxSess
    AliasName = 'Produktion'
    Timeout = 30000
    AfterScroll = fqEksOvrAfterScroll
    OnCalcFields = fqEksOvrCalcFields
    SQL.Strings = (
      'SELECT'
      #9'x.Lbnr,'
      #9'Kundenr,'
      #9'Navn,'
      #9'YderNavn,'
      #9'case when Barn=True then '#39'Ja'#39' else '#39'Nej'#39' end as Barn,'
      #9'TakserDato as Takseret,'
      #9'Afsluttetdato as Afsluttet,'
      #9'case when ordretype=1 then '#39'Salg'#39' else '#39'Retur'#39' end as Type,'
      
        #9'case when ordrestatus=1 then '#39#197'ben'#39' else '#39'Afsluttet'#39' end as Sta' +
        'tus,'
      #9'Kontonr as Konto,'
      #9'FakturaNr as Faktura,'
      #9'PakkeNr as Pakke,'
      #9'LevNAVN AS "Lev nr",'
      
        #9'(select ListeNr from ekspLeveringsListe as lev where lev.lbnr=x' +
        '.lbnr) as Listenr,'
      #9'TurNr as Tur,'
      #9'BrugerTakser as Ta,'
      #9'BrugerKontrol as Ko,'
      #9'BrugerAfslut as Af,'
      #9'case dkmedlem '
      '    '#9#9'when 0 then '#39'Ikke medlem'#39
      '    '#9#9'when 1 then '#39'Medlem'#39
      '    '#9#9'when 9 then '#39'Ved ikke'#39
      #9'end as "DK-Medlem",'
      #9'case when dkindberettet = 0 then '#39'-'#39' else '#39'D'#39' end as DK,'
      #9'case  CtrType'
      #9#9'when 0 then '#39'Almen voksen'#39
      #9#9'when 1 then '#39'Almen barn'#39
      #9#9'when 10 then '#39'Kroniker voksen'#39
      #9#9'when 11 then '#39'Kroniker barn'#39
      #9#9'else '#39'Terminal'#39
      #9'end as "Ctr Type",'
      #9'case Ctrindberettet'
      #9#9'when 0 then '#39'-'#39
      #9#9'when 1 then '#39'C'#39
      #9#9'when 2 then '#39'P'#39
      #9#9'when 3 then '#39'CP'#39
      #9'end as CP,'
      #9'Ctrsaldo as "CTR saldo",'
      #9'Ydernr,'
      #9'case Kundetype'
      #9'when 0  then '#39'Ingen'#39
      #9'when 1  then '#39'Enkeltperson'#39
      '        when 2  then '#39'L'#230'ge'#39
      '        when 3  then '#39'Dyrl'#230'ge'#39
      '        when 4  then '#39'Tandl'#230'ge'#39
      '        when 5  then '#39'Forsvaret'#39
      '        when 6  then '#39'F'#230'ngsel/Arresthus'#39
      '        when 7  then '#39'Asylcenter'#39
      '        when 8  then '#39'Jordemor'#39
      '        when 9  then '#39'Hjemmesygeplejerske'#39
      '        when 10 then '#39'Skibsf'#248'rer/Reder'#39
      '        when 11 then '#39'Sygehus'#39
      '        when 12 then '#39'Plejehjem'#39
      '        when 13 then '#39'Hobbydyr'#39
      '        when 14 then '#39'Landmand (erhvervsdyr)'#39
      '        when 15 then '#39'H'#229'ndk'#248'bsudsalg'#39
      '        when 16 then '#39'Andet apotek'#39
      '        when 17 then '#39'Institutioner'#39
      #9'end as Kundetype,'
      #9'case Eksptype'
      '            when 1 then '#39'Recepter'#39
      '            when 2 then '#39'Vagtbrug m.m.'#39
      '            when 3 then '#39'Leverancer'#39
      '            when 4 then '#39'H'#229'ndk'#248'b'#39
      '            when 5 then '#39'Dyr'#39
      '            when 6 then '#39'Narkoleverance'#39
      '            when 7 then '#39'Dosispakning'#39
      #9'end as "Eksp type",'
      #9'case Ekspform '
      '          when 0 then '#39'Andet'#39
      '          when 1 then '#39'Recept'#39
      '          when 2 then '#39'Telefonrecept'#39
      '          when 3 then '#39'EDB-recept'#39
      '          when 4 then '#39'Narkocheck'#39
      #9'end as "Eksp form",'
      #9'r.Receptid as ReceptId,'
      #9'Amt,'
      #9'Kommune as Kom,'
      #9'x.Afdeling,'
      #9'Lager,'
      #9'Udlignnr as "Udlign Nr",'
      
        #9'case when Fiktivtcprnr = True then '#39'Ja'#39' else '#39'Nej'#39' end as Fikti' +
        'v,'
      #9'case Leveringsform'
      #9#9'when 1 then '#39'Prv'#39
      #9#9'when 2 then '#39'Bud'#39
      #9#9'when 4 then '#39'Uds'#39
      #9#9'when 5 then '#39'Hkb'#39
      #9#9'when 6 then '#39'Lev'#39
      #9#9'when 7 then '#39'Ins'#39
      #9#9'when 8 then '#39'Afh'#39
      #9'end as Lev,'
      #9'Brutto,'
      #9'Rabat,'
      #9'Exmoms as "Excl moms",'
      #9'Moms,'
      #9'Netto,'
      #9'TilskAmt as Amtet,'
      #9'TilskKom as Kommunen,'
      #9'Andel as "Pat Andel",'
      #9'dktilsk as "DK Tilskud",'
      #9'DKEjTilsk as "DK Ej Tilskud",'
      #9'Edbgebyr as "Edb-gebyr",'
      #9'Tlfgebyr as "Tlf-gebyr",'
      #9'Udbrgebyr as "Udbr-gebyr",'
      #9'LMSModtager as "LMSModtager",'
      #9'YderCPRNr,'
      #9'KontrolFejl,'
      '        KontrolDato,'
      '                OrdreDato,'
      'Returdage'
      ''
      #9
      'FROM '
      '('
      #9'SELECT '
      #9#9'* '
      #9'FROM'#9
      #9#9'ekspeditioner as e'
      #9'WHERE'
      #9#9'kundenr='#39'xxx'#39
      ' '#9'order by '
      ' '#9#9'afsluttetdato desc,'
      ' '#9#9'takserdato'
      ' ) AS X'
      ''
      #9'left join RS_Ekspeditioner as R on x.lbnr=r.lbnr'
      'order by'
      #9'x.afsluttetdato desc,'
      #9'x.takserdato')
    Left = 544
    Top = 16
    object fqEksOvrLbnr: TIntegerField
      DisplayWidth = 7
      FieldName = 'Lbnr'
    end
    object fqEksOvrKundenr: TStringField
      DisplayWidth = 10
      FieldName = 'Kundenr'
    end
    object fqEksOvrNavn: TStringField
      DisplayWidth = 25
      FieldName = 'Navn'
      Size = 30
    end
    object fqEksOvrTakseret: TDateTimeField
      DisplayWidth = 14
      FieldName = 'Takseret'
    end
    object fqEksOvrAfsluttet: TDateTimeField
      DisplayWidth = 14
      FieldName = 'Afsluttet'
    end
    object fqEksOvrType: TStringField
      DisplayWidth = 5
      FieldName = 'Type'
      Size = 5
    end
    object fqEksOvrStatus: TStringField
      DisplayWidth = 8
      FieldName = 'Status'
      Size = 9
    end
    object fqEksOvrTa: TWordField
      DisplayWidth = 2
      FieldName = 'Ta'
    end
    object fqEksOvrKo: TWordField
      DisplayWidth = 2
      FieldName = 'Ko'
    end
    object fqEksOvrAf: TWordField
      DisplayWidth = 2
      FieldName = 'Af'
    end
    object fqEksOvrKonto: TStringField
      DisplayWidth = 6
      FieldName = 'Konto'
    end
    object fqEksOvrFaktura: TIntegerField
      DisplayWidth = 8
      FieldName = 'Faktura'
    end
    object fqEksOvrPakke: TIntegerField
      DisplayWidth = 5
      FieldName = 'Pakke'
    end
    object fqEksOvrUdlignNr: TIntegerField
      DisplayWidth = 6
      FieldName = 'Udlign Nr'
    end
    object fqEksOvrListenr: TIntegerField
      DisplayWidth = 6
      FieldName = 'Listenr'
    end
    object fqEksOvrLevnr: TStringField
      DisplayWidth = 6
      FieldName = 'Lev nr'
      Size = 30
    end
    object fqEksOvrBarn: TStringField
      FieldName = 'Barn'
      Size = 3
    end
    object fqEksOvrDKMedlem: TStringField
      DisplayWidth = 10
      FieldName = 'DK-Medlem'
      Size = 11
    end
    object fqEksOvrTur: TIntegerField
      DisplayWidth = 3
      FieldName = 'Tur'
    end
    object fqEksOvrYderNavn: TStringField
      DisplayLabel = 'L'#230'ge'
      DisplayWidth = 15
      FieldName = 'YderNavn'
      Size = 30
    end
    object fqEksOvrDK: TStringField
      DisplayWidth = 2
      FieldName = 'DK'
      Size = 1
    end
    object fqEksOvrCtrType: TStringField
      DisplayWidth = 10
      FieldName = 'Ctr Type'
      Size = 15
    end
    object fqEksOvrCP: TStringField
      FieldName = 'CP'
      Size = 2
    end
    object fqEksOvrCTRsaldo: TCurrencyField
      FieldName = 'CTR saldo'
    end
    object fqEksOvrYdernr: TStringField
      DisplayWidth = 7
      FieldName = 'Ydernr'
      Size = 10
    end
    object fqEksOvrKundetype: TStringField
      DisplayWidth = 12
      FieldName = 'Kundetype'
      Size = 22
    end
    object fqEksOvrEksptype: TStringField
      DisplayWidth = 10
      FieldName = 'Eksp type'
      Size = 14
    end
    object fqEksOvrEkspform: TStringField
      DisplayWidth = 10
      FieldName = 'Eksp form'
      Size = 13
    end
    object fqEksOvrReceptId: TIntegerField
      FieldName = 'ReceptId'
    end
    object fqEksOvrAmt: TWordField
      DisplayWidth = 3
      FieldName = 'Amt'
    end
    object fqEksOvrKom: TWordField
      DisplayWidth = 3
      FieldName = 'Kom'
    end
    object fqEksOvrAfdeling: TWordField
      DisplayWidth = 3
      FieldName = 'Afdeling'
    end
    object fqEksOvrLager: TWordField
      DisplayWidth = 3
      FieldName = 'Lager'
    end
    object fqEksOvrFiktiv: TStringField
      FieldName = 'Fiktiv'
      Size = 3
    end
    object fqEksOvrLev: TStringField
      FieldName = 'Lev'
      Size = 3
    end
    object fqEksOvrBrutto: TCurrencyField
      FieldName = 'Brutto'
    end
    object fqEksOvrRabat: TCurrencyField
      FieldName = 'Rabat'
    end
    object fqEksOvrExclmoms: TCurrencyField
      FieldName = 'Excl moms'
    end
    object fqEksOvrMoms: TCurrencyField
      FieldName = 'Moms'
    end
    object fqEksOvrNetto: TCurrencyField
      FieldName = 'Netto'
    end
    object fqEksOvrAmtet: TCurrencyField
      FieldName = 'Amtet'
    end
    object fqEksOvrKommunen: TCurrencyField
      FieldName = 'Kommunen'
    end
    object fqEksOvrPatAndel: TCurrencyField
      FieldName = 'Pat Andel'
    end
    object fqEksOvrDKTilskud: TCurrencyField
      FieldName = 'DK Tilskud'
    end
    object fqEksOvrDKEjTilskud: TCurrencyField
      FieldName = 'DK Ej Tilskud'
    end
    object fqEksOvrEdbgebyr: TCurrencyField
      FieldName = 'Edb-gebyr'
    end
    object fqEksOvrTlfgebyr: TCurrencyField
      FieldName = 'Tlf-gebyr'
    end
    object fqEksOvrUdbrgebyr: TCurrencyField
      FieldName = 'Udbr-gebyr'
    end
    object fqEksOvrLMSModtager: TStringField
      FieldName = 'LMSModtager'
      Size = 10
    end
    object fqEksOvrYderCPRNr: TStringField
      FieldName = 'YderCPRNr'
      Size = 10
    end
    object fqEksOvrKontrolFejl: TWordField
      FieldName = 'KontrolFejl'
    end
    object fqEksOvrKontrolDato: TDateTimeField
      FieldName = 'KontrolDato'
    end
    object fqEksOvrOrdreDato: TDateTimeField
      DisplayLabel = 'CTRDato'
      FieldName = 'OrdreDato'
    end
    object fqEksOvrBonnr: TLargeintField
      DisplayWidth = 10
      FieldKind = fkCalculated
      FieldName = 'Bonnr'
      Calculated = True
    end
    object fqEksOvrReturdage: TWordField
      FieldName = 'Returdage'
    end
  end
  object nxRSEksp: TnxTable
    Session = nxSess
    AliasName = 'produktion'
    TableName = 'RS_Ekspeditioner'
    IndexName = 'LbnrOrder'
    Left = 336
    Top = 368
    object nxRSEkspPrescriptionId: TStringField
      FieldName = 'PrescriptionId'
      Size = 15
    end
    object nxRSEkspReceptId: TIntegerField
      FieldName = 'ReceptId'
    end
    object nxRSEkspLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object nxRSEkspDato: TDateTimeField
      FieldName = 'Dato'
    end
    object nxRSEkspOrdAnt: TIntegerField
      FieldName = 'OrdAnt'
    end
    object nxRSEkspSenderId: TStringField
      FieldName = 'SenderId'
    end
    object nxRSEkspSenderType: TStringField
      FieldName = 'SenderType'
    end
    object nxRSEkspSenderNavn: TStringField
      FieldName = 'SenderNavn'
      Size = 50
    end
    object nxRSEkspSenderVej: TStringField
      FieldName = 'SenderVej'
    end
    object nxRSEkspSenderPostNr: TStringField
      FieldName = 'SenderPostNr'
      Size = 4
    end
    object nxRSEkspSenderTel: TStringField
      FieldName = 'SenderTel'
      Size = 25
    end
    object nxRSEkspSenderSpecKode: TStringField
      FieldName = 'SenderSpecKode'
      Size = 100
    end
    object nxRSEkspIssuerAutNr: TStringField
      FieldName = 'IssuerAutNr'
      Size = 8
    end
    object nxRSEkspIssuerCPRNr: TStringField
      FieldName = 'IssuerCPRNr'
      Size = 10
    end
    object nxRSEkspIssuerTitel: TStringField
      FieldName = 'IssuerTitel'
      Size = 70
    end
    object nxRSEkspIssuerSpecKode: TStringField
      FieldName = 'IssuerSpecKode'
      Size = 3
    end
    object nxRSEkspIssuerType: TStringField
      FieldName = 'IssuerType'
      Size = 10
    end
    object nxRSEkspSenderSystem: TStringField
      FieldName = 'SenderSystem'
      Size = 30
    end
    object nxRSEkspPatCPR: TStringField
      FieldName = 'PatCPR'
      Size = 10
    end
    object nxRSEkspPatEftNavn: TStringField
      FieldName = 'PatEftNavn'
      Size = 70
    end
    object nxRSEkspPatForNavn: TStringField
      FieldName = 'PatForNavn'
      Size = 70
    end
    object nxRSEkspPatVej: TStringField
      FieldName = 'PatVej'
      Size = 35
    end
    object nxRSEkspPatBy: TStringField
      FieldName = 'PatBy'
      Size = 35
    end
    object nxRSEkspPatPostNr: TStringField
      FieldName = 'PatPostNr'
      Size = 4
    end
    object nxRSEkspPatLand: TStringField
      FieldName = 'PatLand'
      Size = 3
    end
    object nxRSEkspPatAmt: TStringField
      FieldName = 'PatAmt'
      Size = 3
    end
    object nxRSEkspPatFoed: TStringField
      FieldName = 'PatFoed'
      Size = 10
    end
    object nxRSEkspPatKoen: TStringField
      FieldName = 'PatKoen'
      Size = 10
    end
    object nxRSEkspOrdreInstruks: TStringField
      FieldName = 'OrdreInstruks'
      Size = 25
    end
    object nxRSEkspLeveringsInfo: TStringField
      FieldName = 'LeveringsInfo'
      Size = 255
    end
    object nxRSEkspLeveringPri: TStringField
      FieldName = 'LeveringPri'
      Size = 50
    end
    object nxRSEkspLeveringAdresse: TStringField
      FieldName = 'LeveringAdresse'
      Size = 255
    end
    object nxRSEkspLeveringPseudo: TStringField
      FieldName = 'LeveringPseudo'
      Size = 100
    end
    object nxRSEkspLeveringPostNr: TStringField
      FieldName = 'LeveringPostNr'
      Size = 4
    end
    object nxRSEkspLeveringKontakt: TStringField
      FieldName = 'LeveringKontakt'
      Size = 150
    end
    object nxRSEkspReceptStatus: TIntegerField
      FieldName = 'ReceptStatus'
    end
    object nxRSEkspAfdeling: TIntegerField
      FieldName = 'Afdeling'
    end
    object nxRSEkspPatPersonIdentifier: TStringField
      FieldName = 'PatPersonIdentifier'
      Size = 50
    end
    object nxRSEkspPatPersonIdentifierSource: TWordField
      FieldName = 'PatPersonIdentifierSource'
    end
    object nxRSEkspPatOrganisationIdentifier: TStringField
      FieldName = 'PatOrganisationIdentifier'
      Size = 200
    end
    object nxRSEkspPatOrganisationIdentifierSource: TWordField
      FieldName = 'PatOrganisationIdentifierSource'
    end
  end
  object nxRSEkspLin: TnxTable
    TableName = 'RS_Eksplinier'
    Left = 404
    Top = 368
    object nxRSEkspLinReceptId: TIntegerField
      FieldName = 'ReceptId'
    end
    object nxRSEkspLinOrdId: TStringField
      FieldName = 'OrdId'
      Size = 15
    end
    object nxRSEkspLinOrdNr: TIntegerField
      FieldName = 'OrdNr'
    end
    object nxRSEkspLinVersion: TStringField
      FieldName = 'Version'
      Size = 15
    end
    object nxRSEkspLinOpretDato: TStringField
      FieldName = 'OpretDato'
      Size = 30
    end
    object nxRSEkspLinVarenNr: TStringField
      FieldName = 'VarenNr'
      Size = 6
    end
    object nxRSEkspLinNavn: TStringField
      FieldName = 'Navn'
      Size = 35
    end
    object nxRSEkspLinForm: TStringField
      FieldName = 'Form'
      Size = 35
    end
    object nxRSEkspLinStyrke: TStringField
      FieldName = 'Styrke'
      Size = 70
    end
    object nxRSEkspLinMagistrel: TStringField
      FieldName = 'Magistrel'
      Size = 255
    end
    object nxRSEkspLinPakning: TStringField
      FieldName = 'Pakning'
      Size = 70
    end
    object nxRSEkspLinAntal: TIntegerField
      FieldName = 'Antal'
    end
    object nxRSEkspLinImportKort: TStringField
      FieldName = 'ImportKort'
      Size = 70
    end
    object nxRSEkspLinImportLangt: TStringField
      FieldName = 'ImportLangt'
      Size = 70
    end
    object nxRSEkspLinKlausulbetingelse: TStringField
      FieldName = 'Klausulbetingelse'
      Size = 30
    end
    object nxRSEkspLinSubstKode: TStringField
      FieldName = 'SubstKode'
    end
    object nxRSEkspLinDosKode: TStringField
      FieldName = 'DosKode'
      Size = 8
    end
    object nxRSEkspLinDosTekst: TStringField
      FieldName = 'DosTekst'
      Size = 70
    end
    object nxRSEkspLinDosPeriod: TStringField
      FieldName = 'DosPeriod'
      Size = 35
    end
    object nxRSEkspLinDosEnhed: TStringField
      FieldName = 'DosEnhed'
      Size = 10
    end
    object nxRSEkspLinIndCode: TStringField
      FieldName = 'IndCode'
      Size = 17
    end
    object nxRSEkspLinIndText: TStringField
      FieldName = 'IndText'
      Size = 70
    end
    object nxRSEkspLinTakstVersion: TStringField
      FieldName = 'TakstVersion'
      Size = 30
    end
    object nxRSEkspLinIterationNr: TIntegerField
      FieldName = 'IterationNr'
    end
    object nxRSEkspLinIterationInterval: TIntegerField
      FieldName = 'IterationInterval'
    end
    object nxRSEkspLinIterationType: TStringField
      FieldName = 'IterationType'
      Size = 10
    end
    object nxRSEkspLinSupplerende: TStringField
      FieldName = 'Supplerende'
      Size = 70
    end
    object nxRSEkspLinDosStartDato: TStringField
      FieldName = 'DosStartDato'
      Size = 10
    end
    object nxRSEkspLinDosSlutDato: TStringField
      FieldName = 'DosSlutDato'
      Size = 10
    end
    object nxRSEkspLinAdminCount: TIntegerField
      FieldName = 'AdminCount'
    end
    object nxRSEkspLinLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object nxRSEkspLinLinieNr: TWordField
      FieldName = 'LinieNr'
    end
    object nxRSEkspLinAdminID: TIntegerField
      FieldName = 'AdminID'
    end
    object nxRSEkspLinAdminDate: TStringField
      FieldName = 'AdminDate'
      Size = 30
    end
    object nxRSEkspLinApotekBem: TStringField
      FieldName = 'ApotekBem'
      Size = 100
    end
    object nxRSEkspLinOrdreInstruks: TStringField
      FieldName = 'OrdreInstruks'
      Size = 100
    end
    object nxRSEkspLinRSLbnr: TIntegerField
      FieldName = 'RSLbnr'
    end
    object nxRSEkspLinRSLinienr: TIntegerField
      FieldName = 'RSLinienr'
    end
    object nxRSEkspLinAdministrationId: TLargeintField
      FieldName = 'AdministrationId'
    end
    object nxRSEkspLinFrigivStatus: TIntegerField
      FieldName = 'FrigivStatus'
    end
    object nxRSEkspLinPrescriptionIdentifier: TLargeintField
      FieldName = 'PrescriptionIdentifier'
    end
    object nxRSEkspLinOrderIdentifier: TLargeintField
      FieldName = 'OrderIdentifier'
    end
    object nxRSEkspLinEffectuationIdentifier: TLargeintField
      FieldName = 'EffectuationIdentifier'
    end
    object nxRSEkspLinPrivat: TIntegerField
      FieldName = 'Privat'
    end
    object nxRSEkspLinBestiltAfNavn: TStringField
      FieldName = 'BestiltAfNavn'
      Size = 100
    end
    object nxRSEkspLinBestiltAfAutNr: TStringField
      FieldName = 'BestiltAfAutNr'
      Size = 8
    end
    object nxRSEkspLinBestiltAfOrgNavn: TStringField
      FieldName = 'BestiltAfOrgNavn'
      Size = 100
    end
    object nxRSEkspLinBestiltAfAdresse: TStringField
      FieldName = 'BestiltAfAdresse'
      Size = 255
    end
    object nxRSEkspLinBestiltAfTelefon: TStringField
      FieldName = 'BestiltAfTelefon'
      Size = 25
    end
    object nxRSEkspLinBestiltAfPostNr: TStringField
      FieldName = 'BestiltAfPostNr'
      Size = 10
    end
    object nxRSEkspLinBestiltAfId: TStringField
      FieldName = 'BestiltAfId'
    end
    object nxRSEkspLinBestiltAfIdType: TStringField
      FieldName = 'BestiltAfIdType'
      Size = 25
    end
  end
  object dsRSEksp: TDataSource
    DataSet = nxRSEksp
    Left = 336
    Top = 424
  end
  object mtLin: TClientDataSet
    PersistDataPacket.Data = {
      290A00009619E0BD010000001800000063000000000003000000290A074C696E
      69654E720200010000000000094C696E6965547970650200010000000000054C
      61676572020001000000000006566172654E7201004900000001000557494454
      4802000200140009537562566172654E72010049000000010005574944544802
      000200140003456A530200030000000000085661726554797065020001000000
      0000074F6D73547970650200010000000000094E61726B6F5479706502000100
      000000000954696C736B5479706502000100000000000554656B737401004900
      0000010005574944544802000200640005456E68656401004900000001000557
      494454480200020005000744797265417274020001000000000009416C646572
      734772700200010000000000064F726447727002000100000000000755646C65
      764E7202000100000000000855646C65764D6178020001000000000005416E74
      616C040001000000000004507269730800040000000100075355425459504502
      00490006004D6F6E657900084B6F737450726973080004000000010007535542
      545950450200490006004D6F6E6579000642727574746F080004000000010007
      535542545950450200490006004D6F6E65790008526162617450637408000400
      0000010007535542545950450200490006004D6F6E6579000552616261740800
      04000000010007535542545950450200490006004D6F6E65790008496E636C4D
      6F6D7302000300000000000653534B6F64650100490000000100055749445448
      0200020002000345535008000400000001000753554254595045020049000600
      4D6F6E6579000342475008000400000001000753554254595045020049000600
      4D6F6E6579000955646C69676E696E6708000400000001000753554254595045
      0200490006004D6F6E65790008526567656C5379670200010000000000085469
      6C736B537967080004000000010007535542545950450200490006004D6F6E65
      790009526567656C4B6F6D3102000100000000000954696C736B4B6F6D310800
      04000000010007535542545950450200490006004D6F6E65790009526567656C
      4B6F6D3202000100000000000954696C736B4B6F6D3208000400000001000753
      5542545950450200490006004D6F6E65790005416E64656C0800040000000100
      07535542545950450200490006004D6F6E65790006444B547970650200010000
      00000007446B54696C736B080004000000010007535542545950450200490006
      004D6F6E65790009446B456A54696C736B080004000000010007535542545950
      450200490006004D6F6E65790007476C53616C646F0800040000000100075355
      42545950450200490006004D6F6E6579000649425042656C0800040000000100
      07535542545950450200490006004D6F6E6579000649425442656C0800040000
      00010007535542545950450200490006004D6F6E6579000642475042656C0800
      04000000010007535542545950450200490006004D6F6E657900074E7953616C
      646F080004000000010007535542545950450200490006004D6F6E6579000B50
      726F6D696C6C6553796702000100000000000C50726F6D696C6C654B6F6D3102
      000100000000000C50726F6D696C6C654B6F6D32020001000000000009446F73
      6572696E6731010049000000010005574944544802000200320009446F736572
      696E673201004900000001000557494454480200020014000A496E64696B6174
      696F6E010049000000010005574944544802000200320008466F6C6765547874
      010049000000010005574944544802000200140009416664656C696E67310100
      490000000100055749445448020002001E0009416664656C696E673201004900
      00000100055749445448020002001E000B416664656C696E6731456A01004900
      00000100055749445448020002001E000B416664656C696E6732456A01004900
      00000100055749445448020002001E000A4A6F75726E616C4E72310100490000
      0001000557494454480200020014000A4A6F75726E616C4E7232010049000000
      01000557494454480200020014000A43686B4A726E6C4E723102000300000000
      000A43686B4A726E6C4E7232020003000000000004466F726D01004900000001
      0005574944544802000200140006537479726B65010049000000010005574944
      54480200020014000750616B6E696E6701004900000001000557494454480200
      02001E0007415443547970650100490000000100055749445448020002000300
      074154434B6F646501004900000001000557494454480200020007000650414B
      6F646501004900000001000557494454480200020002000955644C6576547970
      6501004900000001000557494454480200020005000648615479706501004900
      0000010005574944544802000200020009537562737456616C67020001000000
      00000445746B3101004900000001000557494454480200020032000445746B32
      01004900000001000557494454480200020032000445746B3301004900000001
      000557494454480200020032000445746B340100490000000100055749445448
      0200020032000445746B35010049000000010005574944544802000200320004
      45746B3601004900000001000557494454480200020032000445746B37010049
      00000001000557494454480200020032000445746B3801004900000001000557
      494454480200020032000445746B390100490000000100055749445448020002
      0032000545746B31300100490000000100055749445448020002003200064574
      6B4C696E02000100000000000956616C69646572657402000300000000000A52
      6569746572657265740200030000000000094C6F6B6174696F6E310400010000
      000000094C6F6B6174696F6E3204000100000000000745746B4D656D6F04004B
      000000010007535542545950450200490005005465787400054F726449640100
      490000000100055749445448020002000F000852656365707449640400010000
      0000000753617665424750080004000000010007535542545950450200490006
      004D6F6E65790007536176654553500800040000000100075355425459504502
      00490006004D6F6E6579000856617265496E666F020003000000000004444D56
      5302000300000000000644727567696401004900000001000557494454480200
      02001400104865616465724354525570646174656402000300000000000F4F72
      64696E65726574566172656E720100490000000100055749445448020002000A
      000E4F7264696E65726574416E74616C0400010000000000124F7264696E6572
      657455646C6576547970650100490000000100055749445448020002000A000F
      506F736C6973744F7665727269646502000300000000000D5564737465646572
      417574696401004900000001000557494454480200020005000A556473746564
      65724964010049000000010005574944544802000200C8000C55647374656465
      72547970650400010000000000094F706265764B6F6465010049000000010005
      57494454480200020001000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'LinieNr'
        DataType = ftSmallint
      end
      item
        Name = 'LinieType'
        DataType = ftSmallint
      end
      item
        Name = 'Lager'
        DataType = ftSmallint
      end
      item
        Name = 'VareNr'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'SubVareNr'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'EjS'
        DataType = ftBoolean
      end
      item
        Name = 'VareType'
        DataType = ftSmallint
      end
      item
        Name = 'OmsType'
        DataType = ftSmallint
      end
      item
        Name = 'NarkoType'
        DataType = ftSmallint
      end
      item
        Name = 'TilskType'
        DataType = ftSmallint
      end
      item
        Name = 'Tekst'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'Enhed'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'DyreArt'
        DataType = ftSmallint
      end
      item
        Name = 'AldersGrp'
        DataType = ftSmallint
      end
      item
        Name = 'OrdGrp'
        DataType = ftSmallint
      end
      item
        Name = 'UdlevNr'
        DataType = ftSmallint
      end
      item
        Name = 'UdlevMax'
        DataType = ftSmallint
      end
      item
        Name = 'Antal'
        DataType = ftInteger
      end
      item
        Name = 'Pris'
        DataType = ftCurrency
      end
      item
        Name = 'KostPris'
        DataType = ftCurrency
      end
      item
        Name = 'Brutto'
        DataType = ftCurrency
      end
      item
        Name = 'RabatPct'
        DataType = ftCurrency
      end
      item
        Name = 'Rabat'
        DataType = ftCurrency
      end
      item
        Name = 'InclMoms'
        DataType = ftBoolean
      end
      item
        Name = 'SSKode'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'ESP'
        DataType = ftCurrency
      end
      item
        Name = 'BGP'
        DataType = ftCurrency
      end
      item
        Name = 'Udligning'
        DataType = ftCurrency
      end
      item
        Name = 'RegelSyg'
        DataType = ftSmallint
      end
      item
        Name = 'TilskSyg'
        DataType = ftCurrency
      end
      item
        Name = 'RegelKom1'
        DataType = ftSmallint
      end
      item
        Name = 'TilskKom1'
        DataType = ftCurrency
      end
      item
        Name = 'RegelKom2'
        DataType = ftSmallint
      end
      item
        Name = 'TilskKom2'
        DataType = ftCurrency
      end
      item
        Name = 'Andel'
        DataType = ftCurrency
      end
      item
        Name = 'DKType'
        DataType = ftSmallint
      end
      item
        Name = 'DkTilsk'
        DataType = ftCurrency
      end
      item
        Name = 'DkEjTilsk'
        DataType = ftCurrency
      end
      item
        Name = 'GlSaldo'
        DataType = ftCurrency
      end
      item
        Name = 'IBPBel'
        DataType = ftCurrency
      end
      item
        Name = 'IBTBel'
        DataType = ftCurrency
      end
      item
        Name = 'BGPBel'
        DataType = ftCurrency
      end
      item
        Name = 'NySaldo'
        DataType = ftCurrency
      end
      item
        Name = 'PromilleSyg'
        DataType = ftSmallint
      end
      item
        Name = 'PromilleKom1'
        DataType = ftSmallint
      end
      item
        Name = 'PromilleKom2'
        DataType = ftSmallint
      end
      item
        Name = 'Dosering1'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Dosering2'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Indikation'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'FolgeTxt'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Afdeling1'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Afdeling2'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Afdeling1Ej'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Afdeling2Ej'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'JournalNr1'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'JournalNr2'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ChkJrnlNr1'
        DataType = ftBoolean
      end
      item
        Name = 'ChkJrnlNr2'
        DataType = ftBoolean
      end
      item
        Name = 'Form'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Styrke'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Pakning'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'ATCType'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'ATCKode'
        DataType = ftString
        Size = 7
      end
      item
        Name = 'PAKode'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'UdLevType'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'HaType'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'SubstValg'
        DataType = ftSmallint
      end
      item
        Name = 'Etk1'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk2'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk3'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk4'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk5'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk6'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk7'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk8'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk9'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk10'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'EtkLin'
        DataType = ftSmallint
      end
      item
        Name = 'Valideret'
        DataType = ftBoolean
      end
      item
        Name = 'Reitereret'
        DataType = ftBoolean
      end
      item
        Name = 'Lokation1'
        DataType = ftInteger
      end
      item
        Name = 'Lokation2'
        DataType = ftInteger
      end
      item
        Name = 'EtkMemo'
        DataType = ftMemo
      end
      item
        Name = 'OrdId'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'ReceptId'
        DataType = ftInteger
      end
      item
        Name = 'SaveBGP'
        DataType = ftCurrency
      end
      item
        Name = 'SaveESP'
        DataType = ftCurrency
      end
      item
        Name = 'VareInfo'
        DataType = ftBoolean
      end
      item
        Name = 'DMVS'
        DataType = ftBoolean
      end
      item
        Name = 'Drugid'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'HeaderCTRUpdated'
        DataType = ftBoolean
      end
      item
        Name = 'OrdineretVarenr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'OrdineretAntal'
        DataType = ftInteger
      end
      item
        Name = 'OrdineretUdlevType'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'PoslistOverride'
        DataType = ftBoolean
      end
      item
        Name = 'UdstederAutid'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'UdstederId'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'UdstederType'
        DataType = ftInteger
      end
      item
        Name = 'OpbevKode'
        DataType = ftString
        Size = 1
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    BeforePost = mtLinBeforePost
    Left = 208
    Top = 112
    object mtLinLinieNr: TSmallintField
      DisplayLabel = '#'
      DisplayWidth = 2
      FieldName = 'LinieNr'
    end
    object mtLinLinieType: TSmallintField
      Alignment = taLeftJustify
      DisplayLabel = 'Type'
      DisplayWidth = 7
      FieldName = 'LinieType'
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      OnGetText = LinieTypeGetText
      OnSetText = LinieTypeSetText
    end
    object mtLinLager: TSmallintField
      DisplayWidth = 5
      FieldName = 'Lager'
      LookupDataSet = ffLagNvn
      LookupKeyFields = 'RefNr'
      LookupResultField = 'Navn'
      Visible = False
    end
    object mtLinVareNr: TStringField
      DisplayLabel = 'Varenr'
      DisplayWidth = 6
      FieldName = 'VareNr'
    end
    object mtLinSubVareNr: TStringField
      DisplayLabel = 'Sub.nr'
      DisplayWidth = 6
      FieldName = 'SubVareNr'
    end
    object mtLinEjS: TBooleanField
      DisplayLabel = '-S'
      FieldName = 'EjS'
      DisplayValues = 'J;N'
    end
    object mtLinVareType: TSmallintField
      FieldName = 'VareType'
      Visible = False
    end
    object mtLinOmsType: TSmallintField
      DisplayLabel = 'Oms'
      DisplayWidth = 3
      FieldName = 'OmsType'
      Visible = False
    end
    object mtLinNarkoType: TSmallintField
      DisplayLabel = 'Narko'
      FieldName = 'NarkoType'
      Visible = False
    end
    object mtLinTilskType: TSmallintField
      FieldName = 'TilskType'
      Visible = False
    end
    object mtLinTekst: TStringField
      DisplayWidth = 27
      FieldName = 'Tekst'
      Size = 100
    end
    object mtLinEnhed: TStringField
      FieldName = 'Enhed'
      Visible = False
      Size = 5
    end
    object mtLinDyreArt: TSmallintField
      FieldName = 'DyreArt'
      Visible = False
    end
    object mtLinAldersGrp: TSmallintField
      FieldName = 'AldersGrp'
      Visible = False
    end
    object mtLinOrdGrp: TSmallintField
      FieldName = 'OrdGrp'
      Visible = False
    end
    object mtLinUdlevNr: TSmallintField
      DisplayLabel = 'Ud'
      DisplayWidth = 2
      FieldName = 'UdlevNr'
    end
    object mtLinUdlevMax: TSmallintField
      DisplayLabel = 'Max'
      DisplayWidth = 2
      FieldName = 'UdlevMax'
    end
    object mtLinAntal: TIntegerField
      DisplayLabel = 'Ant'
      DisplayWidth = 3
      FieldName = 'Antal'
    end
    object mtLinPris: TCurrencyField
      DisplayWidth = 8
      FieldName = 'Pris'
      DisplayFormat = '###,###,###,##0.00'
      EditFormat = '###########0.00'
    end
    object mtLinKostPris: TCurrencyField
      DisplayWidth = 9
      FieldName = 'KostPris'
      Visible = False
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinBrutto: TCurrencyField
      DisplayWidth = 9
      FieldName = 'Brutto'
      Visible = False
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinRabatPct: TCurrencyField
      FieldName = 'RabatPct'
      Visible = False
    end
    object mtLinRabat: TCurrencyField
      DisplayWidth = 9
      FieldName = 'Rabat'
      Visible = False
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinInclMoms: TBooleanField
      FieldName = 'InclMoms'
      Visible = False
    end
    object mtLinSSKode: TStringField
      DisplayLabel = 'SS'
      FieldName = 'SSKode'
      Size = 2
    end
    object mtLinESP: TCurrencyField
      DisplayWidth = 9
      FieldName = 'ESP'
      Visible = False
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinBGP: TCurrencyField
      DisplayWidth = 9
      FieldName = 'BGP'
      Visible = False
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinUdligning: TCurrencyField
      DisplayWidth = 9
      FieldName = 'Udligning'
      Visible = False
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinRegelSyg: TSmallintField
      DisplayLabel = 'SS'
      DisplayWidth = 2
      FieldName = 'RegelSyg'
    end
    object mtLinTilskSyg: TCurrencyField
      DisplayLabel = 'Sygesikr'
      DisplayWidth = 9
      FieldName = 'TilskSyg'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinRegelKom1: TSmallintField
      DisplayLabel = 'K1'
      DisplayWidth = 3
      FieldName = 'RegelKom1'
    end
    object mtLinTilskKom1: TCurrencyField
      DisplayLabel = 'Komm. 1'
      DisplayWidth = 9
      FieldName = 'TilskKom1'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinRegelKom2: TSmallintField
      DisplayLabel = 'K2'
      DisplayWidth = 3
      FieldName = 'RegelKom2'
    end
    object mtLinTilskKom2: TCurrencyField
      DisplayLabel = 'Komm. 2'
      DisplayWidth = 9
      FieldName = 'TilskKom2'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinAndel: TCurrencyField
      DisplayLabel = 'Patient'
      DisplayWidth = 9
      FieldName = 'Andel'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinDKType: TSmallintField
      DisplayLabel = 'DK'
      DisplayWidth = 2
      FieldName = 'DKType'
    end
    object mtLinDkTilsk: TCurrencyField
      DisplayLabel = 'DK tilsk'
      DisplayWidth = 9
      FieldName = 'DkTilsk'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinDkEjTilsk: TCurrencyField
      DisplayLabel = 'DK ej tilsk'
      DisplayWidth = 9
      FieldName = 'DkEjTilsk'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinGlSaldo: TCurrencyField
      DisplayLabel = 'Gl. Ctr-saldo'
      DisplayWidth = 9
      FieldName = 'GlSaldo'
    end
    object mtLinIBPBel: TCurrencyField
      DisplayLabel = 'IBP Bel'#248'b'
      DisplayWidth = 9
      FieldName = 'IBPBel'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinIBTBel: TCurrencyField
      DisplayLabel = 'IBT Bel'#248'b'
      DisplayWidth = 9
      FieldName = 'IBTBel'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinBGPBel: TCurrencyField
      DisplayLabel = 'BGP Bel'#248'b'
      DisplayWidth = 9
      FieldName = 'BGPBel'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinNySaldo: TCurrencyField
      DisplayLabel = 'Ny Ctr-saldo'
      DisplayWidth = 9
      FieldName = 'NySaldo'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtLinPromilleSyg: TSmallintField
      FieldName = 'PromilleSyg'
      Visible = False
    end
    object mtLinPromilleKom1: TSmallintField
      FieldName = 'PromilleKom1'
      Visible = False
    end
    object mtLinPromilleKom2: TSmallintField
      FieldName = 'PromilleKom2'
      Visible = False
    end
    object mtLinDosering1: TStringField
      FieldName = 'Dosering1'
      Visible = False
      Size = 50
    end
    object mtLinDosering2: TStringField
      FieldName = 'Dosering2'
      Visible = False
    end
    object mtLinIndikation: TStringField
      FieldName = 'Indikation'
      Visible = False
      Size = 50
    end
    object mtLinFolgeTxt: TStringField
      FieldName = 'FolgeTxt'
      Visible = False
    end
    object mtLinAfdeling1: TStringField
      FieldName = 'Afdeling1'
      Visible = False
      Size = 30
    end
    object mtLinAfdeling2: TStringField
      FieldName = 'Afdeling2'
      Visible = False
      Size = 30
    end
    object mtLinAfdeling1Ej: TStringField
      FieldName = 'Afdeling1Ej'
      Visible = False
      Size = 30
    end
    object mtLinAfdeling2Ej: TStringField
      FieldName = 'Afdeling2Ej'
      Visible = False
      Size = 30
    end
    object mtLinJournalNr1: TStringField
      FieldName = 'JournalNr1'
      Visible = False
    end
    object mtLinJournalNr2: TStringField
      FieldName = 'JournalNr2'
      Visible = False
    end
    object mtLinChkJrnlNr1: TBooleanField
      FieldName = 'ChkJrnlNr1'
      Visible = False
    end
    object mtLinChkJrnlNr2: TBooleanField
      FieldName = 'ChkJrnlNr2'
      Visible = False
    end
    object mtLinForm: TStringField
      FieldName = 'Form'
      Visible = False
    end
    object mtLinStyrke: TStringField
      FieldName = 'Styrke'
      Visible = False
    end
    object mtLinPakning: TStringField
      FieldName = 'Pakning'
      Visible = False
      Size = 30
    end
    object mtLinATCType: TStringField
      FieldName = 'ATCType'
      Visible = False
      Size = 3
    end
    object mtLinATCKode: TStringField
      FieldName = 'ATCKode'
      Visible = False
      Size = 7
    end
    object mtLinPAKode: TStringField
      FieldName = 'PAKode'
      Visible = False
      Size = 2
    end
    object mtLinUdLevType: TStringField
      FieldName = 'UdLevType'
      Visible = False
      Size = 5
    end
    object mtLinHaType: TStringField
      FieldName = 'HaType'
      Size = 2
    end
    object mtLinSubstValg: TSmallintField
      FieldName = 'SubstValg'
      Visible = False
    end
    object mtLinEtk1: TStringField
      FieldName = 'Etk1'
      Visible = False
      Size = 50
    end
    object mtLinEtk2: TStringField
      FieldName = 'Etk2'
      Visible = False
      Size = 50
    end
    object mtLinEtk3: TStringField
      FieldName = 'Etk3'
      Visible = False
      Size = 50
    end
    object mtLinEtk4: TStringField
      FieldName = 'Etk4'
      Visible = False
      Size = 50
    end
    object mtLinEtk5: TStringField
      FieldName = 'Etk5'
      Visible = False
      Size = 50
    end
    object mtLinEtk6: TStringField
      FieldName = 'Etk6'
      Visible = False
      Size = 50
    end
    object mtLinEtk7: TStringField
      FieldName = 'Etk7'
      Visible = False
      Size = 50
    end
    object mtLinEtk8: TStringField
      FieldName = 'Etk8'
      Visible = False
      Size = 50
    end
    object mtLinEtk9: TStringField
      FieldName = 'Etk9'
      Visible = False
      Size = 50
    end
    object mtLinEtk10: TStringField
      FieldName = 'Etk10'
      Visible = False
      Size = 50
    end
    object mtLinEtkLin: TSmallintField
      FieldName = 'EtkLin'
      Visible = False
    end
    object mtLinValideret: TBooleanField
      FieldName = 'Valideret'
      Visible = False
    end
    object mtLinReitereret: TBooleanField
      FieldName = 'Reitereret'
    end
    object mtLinLokation1: TIntegerField
      FieldName = 'Lokation1'
    end
    object mtLinLokation2: TIntegerField
      FieldName = 'Lokation2'
    end
    object mtLinEtkMemo: TMemoField
      FieldName = 'EtkMemo'
      Visible = False
      BlobType = ftMemo
    end
    object mtLinOrdId: TStringField
      FieldName = 'OrdId'
      Size = 15
    end
    object mtLinReceptId: TIntegerField
      FieldName = 'ReceptId'
    end
    object mtLinSaveBGP: TCurrencyField
      FieldName = 'SaveBGP'
    end
    object mtLinSaveESP: TCurrencyField
      FieldName = 'SaveESP'
    end
    object mtLinVareInfo: TBooleanField
      FieldName = 'VareInfo'
    end
    object mtLinDMVS: TBooleanField
      FieldName = 'DMVS'
    end
    object mtLinDrugid: TStringField
      FieldName = 'Drugid'
    end
    object mtLinHeaderCTRUpdated: TBooleanField
      FieldName = 'HeaderCTRUpdated'
    end
    object mtLinOrdineretVarenr: TStringField
      FieldName = 'OrdineretVarenr'
      Size = 10
    end
    object mtLinOrdineretAntal: TIntegerField
      FieldName = 'OrdineretAntal'
    end
    object mtLinOrdineretUdlevType: TStringField
      FieldName = 'OrdineretUdlevType'
      Size = 10
    end
    object mtLinPoslistOverride: TBooleanField
      FieldName = 'PoslistOverride'
    end
    object mtLinUdstederAutid: TStringField
      FieldName = 'UdstederAutid'
      Size = 5
    end
    object mtLinUdstederId: TStringField
      FieldName = 'UdstederId'
      Size = 200
    end
    object mtLinUdstederType: TIntegerField
      FieldName = 'UdstederType'
    end
    object mtLinOpbevKode: TStringField
      FieldName = 'OpbevKode'
      Size = 1
    end
  end
  object nxOpenPakke: TnxQuery
    Left = 456
    Top = 272
  end
  object dsKomEan: TDataSource
    DataSet = cdKomEan
    Left = 472
    Top = 464
  end
  object cdKomEan: TClientDataSet
    PersistDataPacket.Data = {
      8C0000009619E0BD0100000018000000050000000000030000008C00094B6F6D
      6D756E654E720200020000000000044E61766E01004900000001000557494454
      48020002001E0007526567656C4E7202000200000000000545616E4E72010049
      00000001000557494454480200020014000846726954656B7374010049000000
      01000557494454480200020032000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'KommuneNr'
        DataType = ftWord
      end
      item
        Name = 'Navn'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'RegelNr'
        DataType = ftWord
      end
      item
        Name = 'EanNr'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'FriTekst'
        DataType = ftString
        Size = 50
      end>
    IndexDefs = <
      item
        Name = 'NrOrden'
        Fields = 'KommuneNr;RegelNr;EanNr'
        Options = [ixPrimary, ixUnique]
      end>
    IndexName = 'NrOrden'
    Params = <>
    StoreDefs = True
    Left = 472
    Top = 416
    object cdKomEanKommuneNr: TWordField
      FieldName = 'KommuneNr'
    end
    object cdKomEanNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object cdKomEanRegelNr: TWordField
      FieldName = 'RegelNr'
    end
    object cdKomEanEanNr: TStringField
      FieldName = 'EanNr'
    end
    object cdKomEanFriTekst: TStringField
      FieldName = 'FriTekst'
      Size = 50
    end
  end
  object nqTilEan: TnxQuery
    Session = nxSess
    AliasName = 'Produktion'
    Timeout = 120000
    SQL.Strings = (
      'SELECT'
      '  T.*,'
      '  P.Kommune  '
      'FROM'
      '  (SELECT DISTINCT'
      '     KundeNr'
      '   FROM '
      '     "PatientTilskud"'
      '   WHERE '
      '     Regel BETWEEN 61 AND 79'
      '   ORDER BY'
      '     KundeNr'
      '  ) AS T'
      '  INNER JOIN "PatientKartotek" AS P'
      '    ON P.KundeNr=T.KundeNr '
      'ORDER BY'
      '  KundeNr')
    Left = 416
    Top = 417
    object nqTilEanKundeNr: TStringField
      FieldName = 'KundeNr'
    end
    object nqTilEanKommune: TWordField
      FieldName = 'Kommune'
    end
  end
  object nxDebAfd: TnxTable
    TableName = 'AfdelingsNavne'
    Left = 512
    Top = 272
    object nxDebAfdNavn: TStringField
      FieldName = 'Navn'
      Size = 21
    end
    object nxDebAfdRefNr: TIntegerField
      FieldName = 'RefNr'
    end
  end
  object nxDebLag: TnxTable
    TableName = 'LagerNavne'
    Left = 568
    Top = 272
    object nxDebLagNavn: TStringField
      FieldName = 'Navn'
    end
    object nxDebLagRefNr: TIntegerField
      FieldName = 'RefNr'
    end
  end
  object dsDebAfd: TDataSource
    DataSet = nxDebAfd
    Left = 512
    Top = 320
  end
  object dsDebLag: TDataSource
    DataSet = nxDebLag
    Left = 560
    Top = 320
  end
  object nxAfdeling: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'AfdelingsNavne'
    Left = 504
    Top = 372
    object nxAfdelingType: TStringField
      FieldName = 'Type'
      Size = 21
    end
    object nxAfdelingOperation: TStringField
      FieldName = 'Operation'
      Size = 21
    end
    object nxAfdelingNavn: TStringField
      FieldName = 'Navn'
      Size = 21
    end
    object nxAfdelingRefNr: TIntegerField
      FieldName = 'RefNr'
    end
    object nxAfdelingLmsPNr: TStringField
      FieldName = 'LmsPNr'
      Size = 11
    end
    object nxAfdelingLmsNr: TStringField
      FieldName = 'LmsNr'
      Size = 6
    end
  end
  object nxSettings: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'RS_Settings'
    Left = 456
    Top = 352
    object nxSettingsId: TIntegerField
      FieldName = 'Id'
    end
    object nxSettingsLokationNr: TStringField
      FieldName = 'LokationNr'
      Size = 15
    end
    object nxSettingsSubstLokationNr: TStringField
      FieldName = 'SubstLokationNr'
      Size = 15
    end
    object nxSettingsAfdeling: TIntegerField
      FieldName = 'Afdeling'
    end
    object nxSettingsPrinterNavn1: TStringField
      FieldName = 'PrinterNavn1'
      Size = 30
    end
    object nxSettingsPrinterSkuffe1: TStringField
      FieldName = 'PrinterSkuffe1'
      Size = 30
    end
    object nxSettingsPrinterNavn2: TStringField
      FieldName = 'PrinterNavn2'
      Size = 30
    end
    object nxSettingsPrinterSkuffe2: TStringField
      FieldName = 'PrinterSkuffe2'
      Size = 30
    end
    object nxSettingsReceptNo: TIntegerField
      FieldName = 'ReceptNo'
    end
    object nxSettingsPNummer: TStringField
      FieldKind = fkLookup
      FieldName = 'PNummer'
      LookupDataSet = nxAfdeling
      LookupKeyFields = 'RefNr'
      LookupResultField = 'LmsPNr'
      KeyFields = 'Afdeling'
      Size = 10
      Lookup = True
    end
    object nxSettingsAfdelingNavn: TStringField
      FieldKind = fkLookup
      FieldName = 'AfdelingNavn'
      LookupDataSet = nxAfdeling
      LookupKeyFields = 'RefNr'
      LookupResultField = 'Navn'
      KeyFields = 'Afdeling'
      Size = 30
      Lookup = True
    end
    object nxSettingsPapirType1: TIntegerField
      FieldName = 'PapirType1'
    end
    object nxSettingsPapirType2: TIntegerField
      FieldName = 'PapirType2'
    end
  end
  object nxRSEkspList: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    FilterType = ftSqlWhere
    FlipOrder = True
    OnFilterRecord = nxRSEkspListFilterRecord
    TableName = 'RS_Ekspeditioner'
    IndexName = 'ReceptIDOrder'
    Left = 488
    Top = 584
    object nxRSEkspListReceptId: TIntegerField
      DisplayLabel = 'Receptnr'
      DisplayWidth = 8
      FieldName = 'ReceptId'
    end
    object nxRSEkspListLbNr: TIntegerField
      DisplayLabel = 'L'#248'benr'
      DisplayWidth = 7
      FieldName = 'LbNr'
    end
    object nxRSEkspListDato: TDateTimeField
      DisplayWidth = 14
      FieldName = 'Dato'
      DisplayFormat = 'dd-mm-yyyy hh:mm'
    end
    object nxRSEkspListOrdreStatus: TIntegerField
      DisplayLabel = 'Status'
      FieldKind = fkLookup
      FieldName = 'OrdreStatus'
      LookupDataSet = ffEksOvr
      LookupKeyFields = 'LbNr'
      LookupResultField = 'OrdreStatus'
      KeyFields = 'LbNr'
      OnGetText = OrdreStatusGetText
      Lookup = True
    end
    object nxRSEkspListOrdAnt: TIntegerField
      DisplayLabel = 'Ord'
      DisplayWidth = 3
      FieldName = 'OrdAnt'
    end
    object nxRSEkspListPatCPR: TStringField
      DisplayLabel = 'Cprnr'
      FieldName = 'PatCPR'
      Size = 10
    end
    object nxRSEkspListPatForNavn: TStringField
      DisplayLabel = 'Fornavn'
      DisplayWidth = 15
      FieldName = 'PatForNavn'
      Size = 70
    end
    object nxRSEkspListPatEftNavn: TStringField
      DisplayLabel = 'Efternavn'
      DisplayWidth = 20
      FieldName = 'PatEftNavn'
      Size = 70
    end
    object nxRSEkspListSenderId: TStringField
      DisplayLabel = 'Ydernr'
      DisplayWidth = 7
      FieldName = 'SenderId'
    end
    object nxRSEkspListSenderNavn: TStringField
      DisplayLabel = 'Praksis'
      DisplayWidth = 20
      FieldName = 'SenderNavn'
      Size = 50
    end
    object nxRSEkspListIssuerTitel: TStringField
      DisplayLabel = 'L'#230'genavn'
      DisplayWidth = 15
      FieldName = 'IssuerTitel'
      Size = 70
    end
    object nxRSEkspListLeveringsInfo: TStringField
      DisplayLabel = 'Leveringsinfo'
      DisplayWidth = 50
      FieldName = 'LeveringsInfo'
      Size = 255
    end
    object nxRSEkspListLeveringPri: TStringField
      FieldName = 'LeveringPri'
      Size = 50
    end
    object nxRSEkspListLeveringAdresse: TStringField
      DisplayWidth = 50
      FieldName = 'LeveringAdresse'
      Size = 255
    end
    object nxRSEkspListLeveringPseudo: TStringField
      FieldName = 'LeveringPseudo'
      Size = 25
    end
    object nxRSEkspListLeveringPostNr: TStringField
      FieldName = 'LeveringPostNr'
      Size = 4
    end
    object nxRSEkspListOrdreInstruks: TStringField
      FieldName = 'OrdreInstruks'
      Size = 25
    end
    object nxRSEkspListLeveringKontakt: TStringField
      DisplayWidth = 50
      FieldName = 'LeveringKontakt'
      Size = 150
    end
    object nxRSEkspListIssuerAutNr: TStringField
      DisplayLabel = 'Aut.nr'
      DisplayWidth = 6
      FieldName = 'IssuerAutNr'
      Size = 8
    end
    object nxRSEkspListIssuerCPRNr: TStringField
      DisplayLabel = 'L'#230'ge cprnr'
      FieldName = 'IssuerCPRNr'
      Size = 10
    end
    object nxRSEkspListIssuerSpecKode: TStringField
      DisplayLabel = 'Speciale'
      DisplayWidth = 10
      FieldName = 'IssuerSpecKode'
      Size = 3
    end
    object nxRSEkspListIssuerType: TStringField
      DisplayLabel = 'L'#230'getype'
      FieldName = 'IssuerType'
      Size = 10
    end
    object nxRSEkspListSenderSystem: TStringField
      DisplayLabel = 'L'#230'gesystem'
      DisplayWidth = 20
      FieldName = 'SenderSystem'
      Size = 30
    end
    object nxRSEkspListSenderVej: TStringField
      DisplayLabel = 'L'#230'ge adresse'
      DisplayWidth = 30
      FieldName = 'SenderVej'
      Visible = False
    end
    object nxRSEkspListSenderPostNr: TStringField
      DisplayLabel = 'L'#230'geponr'
      FieldName = 'SenderPostNr'
      Visible = False
      Size = 4
    end
    object nxRSEkspListSenderTel: TStringField
      DisplayLabel = 'Afs. tlf'
      DisplayWidth = 10
      FieldName = 'SenderTel'
      Visible = False
      Size = 25
    end
    object nxRSEkspListSenderSpecKode: TStringField
      FieldName = 'SenderSpecKode'
      Visible = False
      Size = 100
    end
    object nxRSEkspListPatLand: TStringField
      DisplayLabel = 'Land'
      DisplayWidth = 4
      FieldName = 'PatLand'
      Size = 3
    end
    object nxRSEkspListPatAmt: TStringField
      DisplayLabel = 'Amt'
      FieldName = 'PatAmt'
      Size = 3
    end
    object nxRSEkspListPatVej: TStringField
      DisplayLabel = 'Pat. adresse'
      FieldName = 'PatVej'
      Visible = False
      Size = 35
    end
    object nxRSEkspListPatBy: TStringField
      FieldName = 'PatBy'
      Visible = False
      Size = 35
    end
    object nxRSEkspListPatPostNr: TStringField
      FieldName = 'PatPostNr'
      Visible = False
      Size = 4
    end
    object nxRSEkspListPatFoed: TStringField
      FieldName = 'PatFoed'
      Size = 10
    end
    object nxRSEkspListPatKoen: TStringField
      FieldName = 'PatKoen'
      Size = 10
    end
    object nxRSEkspListPrescriptionId: TStringField
      DisplayLabel = 'Recept-ID'
      FieldName = 'PrescriptionId'
      Size = 15
    end
    object nxRSEkspListSenderType: TStringField
      FieldName = 'SenderType'
      Visible = False
    end
    object nxRSEkspListAfdeling: TIntegerField
      FieldName = 'Afdeling'
    end
    object nxRSEkspListReceptStatus: TIntegerField
      FieldName = 'ReceptStatus'
    end
    object nxRSEkspListDosis: TStringField
      FieldKind = fkLookup
      FieldName = 'Dosis'
      LookupDataSet = nxRSEkspLin
      LookupKeyFields = 'ReceptId'
      LookupResultField = 'DosStartDato'
      KeyFields = 'ReceptId'
      Lookup = True
    end
    object nxRSEkspListPatPersonIdentifier: TStringField
      FieldName = 'PatPersonIdentifier'
      Size = 50
    end
    object nxRSEkspListPatPersonIdentifierSource: TWordField
      FieldName = 'PatPersonIdentifierSource'
    end
    object nxRSEkspListPatOrganisationIdentifier: TStringField
      FieldName = 'PatOrganisationIdentifier'
      Size = 200
    end
    object nxRSEkspListPatOrganisationIdentifierSource: TWordField
      FieldName = 'PatOrganisationIdentifierSource'
    end
  end
  object nxRSEkspLinList: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'RS_Eksplinier'
    IndexFieldNames = 'ReceptId;OrdNr'
    MasterFields = 'ReceptId'
    MasterSource = dsEkspList
    Left = 576
    Top = 584
    object nxRSEkspLinListRSLbnr: TIntegerField
      DisplayLabel = 'L'#248'benr'
      FieldName = 'RSLbnr'
    end
    object nxRSEkspLinListLbNr: TIntegerField
      DisplayLabel = 'L'#248'benr'
      FieldName = 'LbNr'
      Visible = False
    end
    object nxRSEkspLinListOrdId: TStringField
      DisplayLabel = 'Ord-ID'
      DisplayWidth = 8
      FieldName = 'OrdId'
      Size = 15
    end
    object nxRSEkspLinListOrdNr: TIntegerField
      DisplayLabel = 'Ord'
      DisplayWidth = 3
      FieldName = 'OrdNr'
      Visible = False
    end
    object nxRSEkspLinListVarenNr: TStringField
      DisplayLabel = 'Varenr'
      FieldName = 'VarenNr'
      Size = 6
    end
    object nxRSEkspLinListNavn: TStringField
      DisplayWidth = 25
      FieldName = 'Navn'
      Size = 35
    end
    object nxRSEkspLinListForm: TStringField
      DisplayWidth = 15
      FieldName = 'Form'
      Size = 35
    end
    object nxRSEkspLinListStyrke: TStringField
      DisplayWidth = 15
      FieldName = 'Styrke'
      Size = 70
    end
    object nxRSEkspLinListPakning: TStringField
      DisplayWidth = 20
      FieldName = 'Pakning'
      Size = 70
    end
    object nxRSEkspLinListAntal: TIntegerField
      DisplayLabel = 'Ant'
      DisplayWidth = 3
      FieldName = 'Antal'
    end
    object nxRSEkspLinListIterationNr: TIntegerField
      DisplayLabel = 'Max'
      DisplayWidth = 3
      FieldName = 'IterationNr'
    end
    object nxRSEkspLinListSubstKode: TStringField
      DisplayLabel = 'Sub'
      DisplayWidth = 3
      FieldName = 'SubstKode'
    end
    object nxRSEkspLinListDosStartDato: TStringField
      DisplayLabel = 'Dos.start'
      FieldName = 'DosStartDato'
      Size = 10
    end
    object nxRSEkspLinListDosSlutDato: TStringField
      DisplayLabel = 'Dos.slut'
      FieldName = 'DosSlutDato'
      Size = 10
    end
    object nxRSEkspLinListDosKode: TStringField
      DisplayLabel = 'Doskd'
      DisplayWidth = 5
      FieldName = 'DosKode'
      Size = 8
    end
    object nxRSEkspLinListIndCode: TStringField
      DisplayLabel = 'Indkd'
      DisplayWidth = 5
      FieldName = 'IndCode'
      Size = 17
    end
    object nxRSEkspLinListIterationInterval: TIntegerField
      DisplayLabel = 'Interval'
      FieldName = 'IterationInterval'
    end
    object nxRSEkspLinListIterationType: TStringField
      DisplayLabel = 'Type'
      DisplayWidth = 6
      FieldName = 'IterationType'
      Size = 10
    end
    object nxRSEkspLinListBestiltAfNavn: TStringField
      FieldName = 'BestiltAfNavn'
      Size = 100
    end
    object nxRSEkspLinListBestiltAfOrgNavn: TStringField
      FieldName = 'BestiltAfOrgNavn'
      Size = 100
    end
    object nxRSEkspLinListSupplerende: TStringField
      DisplayWidth = 30
      FieldName = 'Supplerende'
      Size = 70
    end
    object nxRSEkspLinListImportKort: TStringField
      DisplayLabel = 'Imp'
      DisplayWidth = 7
      FieldName = 'ImportKort'
      Size = 70
    end
    object nxRSEkspLinListImportLangt: TStringField
      DisplayLabel = 'Import'#248'r'
      DisplayWidth = 20
      FieldName = 'ImportLangt'
      Size = 70
    end
    object nxRSEkspLinListKlausulbetingelse: TStringField
      DisplayLabel = 'Klausulering'
      DisplayWidth = 20
      FieldName = 'Klausulbetingelse'
      Size = 30
    end
    object nxRSEkspLinListDosTekst: TStringField
      DisplayLabel = 'Dosering'
      DisplayWidth = 50
      FieldName = 'DosTekst'
      Size = 70
    end
    object nxRSEkspLinListDosPeriod: TStringField
      DisplayLabel = 'Periode'
      DisplayWidth = 20
      FieldName = 'DosPeriod'
      Size = 35
    end
    object nxRSEkspLinListDosEnhed: TStringField
      DisplayLabel = 'Enhed'
      FieldName = 'DosEnhed'
      Size = 10
    end
    object nxRSEkspLinListIndText: TStringField
      DisplayLabel = 'Indikation'
      DisplayWidth = 50
      FieldName = 'IndText'
      Size = 70
    end
    object nxRSEkspLinListReceptId: TIntegerField
      DisplayLabel = 'Receptnr'
      FieldName = 'ReceptId'
    end
    object nxRSEkspLinListMagistrel: TStringField
      DisplayWidth = 30
      FieldName = 'Magistrel'
      Size = 255
    end
    object nxRSEkspLinListOpretDato: TStringField
      DisplayLabel = 'Opretdato'
      DisplayWidth = 20
      FieldName = 'OpretDato'
      Size = 30
    end
    object nxRSEkspLinListAdminCount: TIntegerField
      DisplayLabel = 'Admin'
      FieldName = 'AdminCount'
    end
    object nxRSEkspLinListTakstVersion: TStringField
      DisplayLabel = 'Takst'
      DisplayWidth = 10
      FieldName = 'TakstVersion'
      Size = 30
    end
    object nxRSEkspLinListVersion: TStringField
      FieldName = 'Version'
      Size = 15
    end
    object nxRSEkspLinListLinieNr: TWordField
      FieldName = 'LinieNr'
    end
    object nxRSEkspLinListAdminID: TIntegerField
      FieldName = 'AdminID'
    end
    object nxRSEkspLinListAdminDate: TStringField
      FieldName = 'AdminDate'
      Size = 30
    end
    object nxRSEkspLinListOrdreInstruks: TStringField
      FieldName = 'OrdreInstruks'
      Size = 100
    end
    object nxRSEkspLinListApotekBem: TStringField
      FieldName = 'ApotekBem'
      Size = 100
    end
    object nxRSEkspLinListRSLinienr: TIntegerField
      FieldName = 'RSLinienr'
    end
    object nxRSEkspLinListAdministrationId: TLargeintField
      FieldName = 'AdministrationId'
    end
    object nxRSEkspLinListFrigivStatus: TIntegerField
      FieldName = 'FrigivStatus'
    end
    object nxRSEkspLinListPrescriptionIdentifier: TLargeintField
      FieldName = 'PrescriptionIdentifier'
    end
    object nxRSEkspLinListOrderIdentifier: TLargeintField
      FieldName = 'OrderIdentifier'
    end
    object nxRSEkspLinListEffectuationIdentifier: TLargeintField
      FieldName = 'EffectuationIdentifier'
    end
    object nxRSEkspLinListPrivat: TIntegerField
      FieldName = 'Privat'
    end
  end
  object dsEkspList: TDataSource
    DataSet = nxRSEkspList
    Left = 488
    Top = 632
  end
  object dsEkspLinList: TDataSource
    DataSet = nxRSEkspLinList
    Left = 576
    Top = 640
  end
  object nxStoredProc1: TnxStoredProc
    Session = nxSess
    AliasName = 'produktion'
    ReadOnly = True
    StoredProcName = 'sp_sql_PatientEksp'
    Left = 24
    Top = 464
    ParamData = <
      item
        DataType = ftString
        Name = 'p_kundenr'
        ParamType = ptInput
      end>
  end
  object dsStoredProc: TDataSource
    AutoEdit = False
    DataSet = nxStoredProc1
    Left = 104
    Top = 472
  end
  object nxRSQueue: TnxTable
    Session = nxSess
    AliasName = 'produktion'
    TableName = 'RS_EkspQueue'
    Left = 424
    Top = 584
    object nxRSQueueLbnr: TIntegerField
      FieldName = 'Lbnr'
    end
    object nxRSQueueDato: TDateTimeField
      FieldName = 'Dato'
    end
  end
  object nxCTRinf: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'CTRInformation'
    IndexFieldNames = 'KundeNr'
    Left = 616
    Top = 576
    object nxCTRinfKundeNr: TStringField
      FieldName = 'KundeNr'
    end
    object nxCTRinfUpdateTime: TDateTimeField
      FieldName = 'UpdateTime'
    end
    object nxCTRinfpt_barn: TBooleanField
      FieldName = 'pt_barn'
    end
    object nxCTRinfpt_type: TIntegerField
      FieldName = 'pt_type'
    end
    object nxCTRinff_pension: TBooleanField
      FieldName = 'f_pension'
    end
    object nxCTRinfsaldo: TCurrencyField
      FieldName = 'saldo'
    end
    object nxCTRinfudlign_tilskud: TCurrencyField
      FieldName = 'udlign_tilskud'
    end
    object nxCTRinfslutdato: TDateTimeField
      FieldName = 'slutdato'
    end
    object nxCTRinfstartdato: TDateTimeField
      FieldName = 'startdato'
    end
    object nxCTRinfvarighed: TIntegerField
      FieldName = 'varighed'
    end
    object nxCTRinfbev_indb: TDateTimeField
      FieldName = 'bev_indb'
    end
    object nxCTRinffor_udlign_tilskud: TCurrencyField
      FieldName = 'for_udlign_tilskud'
    end
    object nxCTRinffor_slutdato: TDateTimeField
      FieldName = 'for_slutdato'
    end
    object nxCTRinfh_komnr: TIntegerField
      FieldName = 'h_komnr'
    end
    object nxCTRinfh_ean_lok: TStringField
      FieldName = 'h_ean_lok'
    end
    object nxCTRinfh_sats: TIntegerField
      FieldName = 'h_sats'
    end
    object nxCTRinfSaldoB: TCurrencyField
      FieldName = 'SaldoB'
    end
    object nxCTRinfslutdatoB: TDateTimeField
      FieldName = 'slutdatoB'
    end
    object nxCTRinffor_udlign_tilskudB: TCurrencyField
      FieldName = 'for_udlign_tilskudB'
    end
    object nxCTRinffor_slutdatoB: TDateTimeField
      FieldName = 'for_slutdatoB'
    end
    object nxCTRinfudlign_tilskudB: TCurrencyField
      FieldName = 'udlign_tilskudB'
    end
  end
  object nxCTRBev: TnxTable
    TableName = 'CTRBevillinger'
    Left = 680
    Top = 624
    object nxCTRBevKundeNr: TStringField
      FieldName = 'KundeNr'
      Visible = False
    end
    object nxCTRBevRegel: TIntegerField
      DisplayWidth = 6
      FieldName = 'Regel'
    end
    object nxCTRBevFraDato: TDateTimeField
      DisplayWidth = 10
      FieldName = 'FraDato'
    end
    object nxCTRBevTilDato: TDateTimeField
      DisplayWidth = 10
      FieldName = 'TilDato'
    end
    object nxCTRBevIndbDato: TDateTimeField
      FieldName = 'IndbDato'
      Visible = False
    end
    object nxCTRBevVareNr: TStringField
      DisplayWidth = 6
      FieldName = 'VareNr'
      Size = 10
    end
    object nxCTRBevAtc: TStringField
      DisplayWidth = 8
      FieldName = 'Atc'
      Size = 10
    end
    object nxCTRBevLmNavn: TStringField
      DisplayWidth = 36
      FieldName = 'LmNavn'
      Size = 50
    end
    object nxCTRBevAdmVej: TStringField
      FieldName = 'AdmVej'
    end
    object nxCTRBevVarighed: TIntegerField
      FieldName = 'Varighed'
      Visible = False
    end
    object nxCTRBevh_komnr: TIntegerField
      DisplayLabel = 'Kom.'
      DisplayWidth = 4
      FieldName = 'h_komnr'
    end
    object nxCTRBevh_ean_lok: TStringField
      FieldName = 'h_ean_lok'
      Visible = False
    end
    object nxCTRBevh_sats: TIntegerField
      DisplayLabel = 'Sats'
      DisplayWidth = 5
      FieldName = 'h_sats'
    end
  end
  object dsnxCTRBev: TDataSource
    AutoEdit = False
    DataSet = nxCTRBev
    Left = 736
    Top = 632
  end
  object cdDrgDos: TClientDataSet
    PersistDataPacket.Data = {
      480000009619E0BD010000001800000002000000000003000000480002496401
      00490000000100055749445448020002000B00024E7201004900000001000557
      494454480200020007000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftString
        Size = 11
      end
      item
        Name = 'Nr'
        DataType = ftString
        Size = 7
      end>
    IndexDefs = <
      item
        Name = 'IdOrden'
        Fields = 'Id'
      end>
    IndexName = 'IdOrden'
    Params = <>
    StoreDefs = True
    Left = 288
    Top = 624
    object cdDrgDosId: TStringField
      FieldName = 'Id'
      Size = 11
    end
    object cdDrgDosNr: TStringField
      FieldName = 'Nr'
      Size = 7
    end
  end
  object cdDrgInd: TClientDataSet
    PersistDataPacket.Data = {
      480000009619E0BD010000001800000002000000000003000000480002496401
      00490000000100055749445448020002000B00024E7201004900000001000557
      494454480200020007000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftString
        Size = 11
      end
      item
        Name = 'Nr'
        DataType = ftString
        Size = 7
      end>
    IndexDefs = <
      item
        Name = 'IdOrden'
        Fields = 'Id'
      end>
    IndexName = 'IdOrden'
    Params = <>
    StoreDefs = True
    Left = 348
    Top = 624
    object cdDrgIndId: TStringField
      FieldName = 'Id'
      Size = 11
    end
    object cdDrgIndNr: TStringField
      FieldName = 'Nr'
      Size = 7
    end
  end
  object nxFaktQuery: TnxQuery
    Session = nxSess
    AliasName = 'produktion'
    SQL.Strings = (
      'select '
      #9'*'
      'from'
      #9'ekspeditioner'
      'where'
      #9'FAKTURANR=23'
      ''
      'order by'
      #9'pakkenr,lbnr')
    Left = 24
    Top = 632
    object nxFaktQueryLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object nxFaktQueryTurNr: TIntegerField
      FieldName = 'TurNr'
    end
    object nxFaktQueryPakkeNr: TIntegerField
      FieldName = 'PakkeNr'
    end
    object nxFaktQueryFakturaNr: TIntegerField
      FieldName = 'FakturaNr'
    end
    object nxFaktQueryUdlignNr: TIntegerField
      FieldName = 'UdlignNr'
    end
    object nxFaktQueryKundeNr: TStringField
      FieldName = 'KundeNr'
    end
    object nxFaktQueryFiktivtCprNr: TBooleanField
      FieldName = 'FiktivtCprNr'
    end
    object nxFaktQueryCprCheck: TBooleanField
      FieldName = 'CprCheck'
    end
    object nxFaktQueryNettoPriser: TBooleanField
      FieldName = 'NettoPriser'
    end
    object nxFaktQueryEjSubstitution: TBooleanField
      FieldName = 'EjSubstitution'
    end
    object nxFaktQueryBarn: TBooleanField
      FieldName = 'Barn'
    end
    object nxFaktQueryKundeKlub: TBooleanField
      FieldName = 'KundeKlub'
    end
    object nxFaktQueryKlubNr: TIntegerField
      FieldName = 'KlubNr'
    end
    object nxFaktQueryAmt: TWordField
      FieldName = 'Amt'
    end
    object nxFaktQueryKommune: TWordField
      FieldName = 'Kommune'
    end
    object nxFaktQueryKundeType: TWordField
      FieldName = 'KundeType'
    end
    object nxFaktQueryLandeKode: TWordField
      FieldName = 'LandeKode'
    end
    object nxFaktQueryCtrType: TWordField
      FieldName = 'CtrType'
    end
    object nxFaktQueryCtrIndberettet: TWordField
      FieldName = 'CtrIndberettet'
    end
    object nxFaktQueryAlder: TSmallintField
      FieldName = 'Alder'
    end
    object nxFaktQueryFoedDato: TStringField
      FieldName = 'FoedDato'
      Size = 8
    end
    object nxFaktQueryNarkoNr: TStringField
      FieldName = 'NarkoNr'
      Size = 10
    end
    object nxFaktQueryOrdreType: TWordField
      FieldName = 'OrdreType'
    end
    object nxFaktQueryOrdreStatus: TWordField
      FieldName = 'OrdreStatus'
    end
    object nxFaktQueryReceptStatus: TWordField
      FieldName = 'ReceptStatus'
    end
    object nxFaktQueryEkspType: TWordField
      FieldName = 'EkspType'
    end
    object nxFaktQueryEkspForm: TWordField
      FieldName = 'EkspForm'
    end
    object nxFaktQueryDosStyring: TBooleanField
      FieldName = 'DosStyring'
    end
    object nxFaktQueryIndikStyring: TBooleanField
      FieldName = 'IndikStyring'
    end
    object nxFaktQueryAntLin: TWordField
      FieldName = 'AntLin'
    end
    object nxFaktQueryAntVarer: TWordField
      FieldName = 'AntVarer'
    end
    object nxFaktQueryDKMedlem: TWordField
      FieldName = 'DKMedlem'
    end
    object nxFaktQueryDKAnt: TWordField
      FieldName = 'DKAnt'
    end
    object nxFaktQueryDKIndberettet: TWordField
      FieldName = 'DKIndberettet'
    end
    object nxFaktQueryReceptDato: TDateTimeField
      FieldName = 'ReceptDato'
    end
    object nxFaktQueryOrdreDato: TDateTimeField
      FieldName = 'OrdreDato'
    end
    object nxFaktQueryTakserDato: TDateTimeField
      FieldName = 'TakserDato'
    end
    object nxFaktQueryKontrolDato: TDateTimeField
      FieldName = 'KontrolDato'
    end
    object nxFaktQueryAfsluttetDato: TDateTimeField
      FieldName = 'AfsluttetDato'
    end
    object nxFaktQueryForfaldsdato: TDateTimeField
      FieldName = 'Forfaldsdato'
    end
    object nxFaktQueryBrugerTakser: TWordField
      FieldName = 'BrugerTakser'
    end
    object nxFaktQueryBrugerKontrol: TWordField
      FieldName = 'BrugerKontrol'
    end
    object nxFaktQueryBrugerAfslut: TWordField
      FieldName = 'BrugerAfslut'
    end
    object nxFaktQueryKontrolFejl: TWordField
      FieldName = 'KontrolFejl'
    end
    object nxFaktQueryTitel: TStringField
      FieldName = 'Titel'
      Size = 30
    end
    object nxFaktQueryNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object nxFaktQueryAdr1: TStringField
      FieldName = 'Adr1'
      Size = 30
    end
    object nxFaktQueryAdr2: TStringField
      FieldName = 'Adr2'
      Size = 30
    end
    object nxFaktQueryPostNr: TStringField
      FieldName = 'PostNr'
    end
    object nxFaktQueryLand: TStringField
      FieldName = 'Land'
      Size = 30
    end
    object nxFaktQueryKontakt: TStringField
      FieldName = 'Kontakt'
      Size = 30
    end
    object nxFaktQueryTlfNr: TStringField
      FieldName = 'TlfNr'
      Size = 30
    end
    object nxFaktQueryTlfNr2: TStringField
      FieldName = 'TlfNr2'
      Size = 30
    end
    object nxFaktQueryLevNavn: TStringField
      FieldName = 'LevNavn'
      Size = 30
    end
    object nxFaktQueryLevAdr1: TStringField
      FieldName = 'LevAdr1'
      Size = 30
    end
    object nxFaktQueryLevAdr2: TStringField
      FieldName = 'LevAdr2'
      Size = 30
    end
    object nxFaktQueryLevPostNr: TStringField
      FieldName = 'LevPostNr'
    end
    object nxFaktQueryLevLand: TStringField
      FieldName = 'LevLand'
      Size = 30
    end
    object nxFaktQueryLevKontakt: TStringField
      FieldName = 'LevKontakt'
      Size = 30
    end
    object nxFaktQueryLevTlfNr: TStringField
      FieldName = 'LevTlfNr'
      Size = 30
    end
    object nxFaktQueryYderNr: TStringField
      FieldName = 'YderNr'
      Size = 10
    end
    object nxFaktQueryYderCprNr: TStringField
      FieldName = 'YderCprNr'
      Size = 10
    end
    object nxFaktQueryYderNavn: TStringField
      FieldName = 'YderNavn'
      Size = 30
    end
    object nxFaktQueryYderTlfNr: TStringField
      FieldName = 'YderTlfNr'
      Size = 30
    end
    object nxFaktQueryKontoNr: TStringField
      FieldName = 'KontoNr'
    end
    object nxFaktQueryKontoNavn: TStringField
      FieldName = 'KontoNavn'
      Size = 30
    end
    object nxFaktQueryKontoAdr1: TStringField
      FieldName = 'KontoAdr1'
      Size = 30
    end
    object nxFaktQueryKontoAdr2: TStringField
      FieldName = 'KontoAdr2'
      Size = 30
    end
    object nxFaktQueryKontoPostNr: TStringField
      FieldName = 'KontoPostNr'
    end
    object nxFaktQueryKontoLand: TStringField
      FieldName = 'KontoLand'
      Size = 30
    end
    object nxFaktQueryKontoKontakt: TStringField
      FieldName = 'KontoKontakt'
      Size = 30
    end
    object nxFaktQueryKontoTlf: TStringField
      FieldName = 'KontoTlf'
      Size = 30
    end
    object nxFaktQueryKontoGruppe: TWordField
      FieldName = 'KontoGruppe'
    end
    object nxFaktQueryRabatGruppe: TWordField
      FieldName = 'RabatGruppe'
    end
    object nxFaktQueryPrisGruppe: TWordField
      FieldName = 'PrisGruppe'
    end
    object nxFaktQueryStatGruppe: TWordField
      FieldName = 'StatGruppe'
    end
    object nxFaktQuerySprog: TWordField
      FieldName = 'Sprog'
    end
    object nxFaktQueryAfdeling: TWordField
      FieldName = 'Afdeling'
    end
    object nxFaktQueryLager: TWordField
      FieldName = 'Lager'
    end
    object nxFaktQueryKreditForm: TWordField
      FieldName = 'KreditForm'
    end
    object nxFaktQueryBetalingsForm: TWordField
      FieldName = 'BetalingsForm'
    end
    object nxFaktQueryLeveringsForm: TWordField
      FieldName = 'LeveringsForm'
    end
    object nxFaktQueryPakkeseddel: TWordField
      FieldName = 'Pakkeseddel'
    end
    object nxFaktQueryFaktura: TWordField
      FieldName = 'Faktura'
    end
    object nxFaktQueryBetalingskort: TWordField
      FieldName = 'Betalingskort'
    end
    object nxFaktQueryLeveringsseddel: TWordField
      FieldName = 'Leveringsseddel'
    end
    object nxFaktQueryAdrEtiket: TWordField
      FieldName = 'AdrEtiket'
    end
    object nxFaktQueryVigtigBem: TnxMemoField
      FieldName = 'VigtigBem'
      BlobType = ftMemo
    end
    object nxFaktQueryAfstempling: TnxMemoField
      FieldName = 'Afstempling'
      BlobType = ftMemo
    end
    object nxFaktQueryBrutto: TCurrencyField
      FieldName = 'Brutto'
    end
    object nxFaktQueryRabatLin: TCurrencyField
      FieldName = 'RabatLin'
    end
    object nxFaktQueryRabatPct: TCurrencyField
      FieldName = 'RabatPct'
    end
    object nxFaktQueryRabat: TCurrencyField
      FieldName = 'Rabat'
    end
    object nxFaktQueryInclMoms: TBooleanField
      FieldName = 'InclMoms'
    end
    object nxFaktQueryExMoms: TCurrencyField
      FieldName = 'ExMoms'
    end
    object nxFaktQueryMomsPct: TCurrencyField
      FieldName = 'MomsPct'
    end
    object nxFaktQueryMoms: TCurrencyField
      FieldName = 'Moms'
    end
    object nxFaktQueryNetto: TCurrencyField
      FieldName = 'Netto'
    end
    object nxFaktQueryTilskAmt: TCurrencyField
      FieldName = 'TilskAmt'
    end
    object nxFaktQueryTilskKom: TCurrencyField
      FieldName = 'TilskKom'
    end
    object nxFaktQueryDKTilsk: TCurrencyField
      FieldName = 'DKTilsk'
    end
    object nxFaktQueryDKEjTilsk: TCurrencyField
      FieldName = 'DKEjTilsk'
    end
    object nxFaktQueryOrdreNr: TIntegerField
      FieldName = 'OrdreNr'
    end
    object nxFaktQueryLMSModtager: TStringField
      FieldName = 'LMSModtager'
      Size = 10
    end
    object nxFaktQueryEdbGebyr: TCurrencyField
      FieldName = 'EdbGebyr'
    end
    object nxFaktQueryTlfGebyr: TCurrencyField
      FieldName = 'TlfGebyr'
    end
    object nxFaktQueryUdbrGebyr: TCurrencyField
      FieldName = 'UdbrGebyr'
    end
    object nxFaktQueryAndel: TCurrencyField
      FieldName = 'Andel'
    end
    object nxFaktQueryCtrSaldo: TCurrencyField
      FieldName = 'CtrSaldo'
    end
  end
  object ffLagHis: TnxTable
    TableName = 'LagerBestillinger'
    IndexName = 'NrOrden'
    Left = 176
    Top = 228
    object ffLagHisLager: TWordField
      FieldName = 'Lager'
      Visible = False
    end
    object ffLagHisOrdreStatus: TWordField
      FieldName = 'OrdreStatus'
      Visible = False
    end
    object ffLagHisBestDato: TDateTimeField
      FieldName = 'BestDato'
    end
    object ffLagHisVareNr: TStringField
      FieldName = 'VareNr'
      Visible = False
    end
    object ffLagHisAntal: TIntegerField
      DisplayWidth = 5
      FieldName = 'Antal'
    end
    object ffLagHisLeveret: TIntegerField
      DisplayLabel = 'Lev'
      DisplayWidth = 5
      FieldName = 'Leveret'
    end
    object ffLagHisRestordre: TIntegerField
      DisplayLabel = 'Rest'
      DisplayWidth = 5
      FieldName = 'Restordre'
    end
    object ffLagHisSort: TStringField
      FieldName = 'Sort'
      Size = 50
    end
    object ffLagHisVareType: TWordField
      FieldName = 'VareType'
    end
    object ffLagHisGrNr: TWordField
      FieldName = 'GrNr'
    end
    object ffLagHisKostPris: TCurrencyField
      FieldName = 'KostPris'
    end
    object ffLagHisLokation1: TIntegerField
      FieldName = 'Lokation1'
    end
    object ffLagHisLokation2: TIntegerField
      FieldName = 'Lokation2'
    end
    object ffLagHisOptagRO: TWordField
      FieldName = 'OptagRO'
    end
    object ffLagHisAntalSP: TWordField
      FieldName = 'AntalSP'
    end
  end
  object nxAfd: TnxTable
    TableName = 'AfdelingsNavne'
    IndexName = 'NrOrden'
    Left = 800
    Top = 568
    object nxAfdType: TStringField
      FieldName = 'Type'
      Size = 21
    end
    object nxAfdOperation: TStringField
      FieldName = 'Operation'
      Size = 21
    end
    object nxAfdNavn: TStringField
      FieldName = 'Navn'
      Size = 21
    end
    object nxAfdRefNr: TIntegerField
      FieldName = 'RefNr'
    end
    object nxAfdLmsPNr: TStringField
      FieldName = 'LmsPNr'
      Size = 11
    end
    object nxAfdLmsNr: TStringField
      FieldName = 'LmsNr'
      Size = 6
    end
  end
  object nxEkspLinKon: TnxTable
    TableName = 'EkspLinierkontrol'
    Left = 176
    Top = 632
    object nxEkspLinKonLbnr: TIntegerField
      FieldName = 'Lbnr'
    end
    object nxEkspLinKonLinienr: TIntegerField
      FieldName = 'Linienr'
    end
    object nxEkspLinKonVarenr: TStringField
      FieldName = 'Varenr'
    end
    object nxEkspLinKonAntal: TIntegerField
      FieldName = 'Antal'
    end
    object nxEkspLinKonOpKode: TIntegerField
      FieldName = 'OpKode'
    end
    object nxEkspLinKonDato: TDateTimeField
      FieldName = 'Dato'
    end
    object nxEkspLinKonFejlkode: TIntegerField
      FieldName = 'Fejlkode'
    end
    object nxEkspLinKonBemaerk: TnxMemoField
      FieldName = 'Bemaerk'
      BlobType = ftMemo
    end
  end
  object nxEkspLevListe: TnxTable
    TableName = 'EkspLeveringsListe'
    Left = 416
    Top = 640
    object nxEkspLevListeListeNr: TIntegerField
      FieldName = 'ListeNr'
    end
    object nxEkspLevListeLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object nxEkspLevListeDato: TDateTimeField
      FieldName = 'Dato'
    end
    object nxEkspLevListeKonto: TStringField
      FieldName = 'Konto'
    end
  end
  object nqEkspLevListe: TnxQuery
    Left = 416
    Top = 696
  end
  object nqVaelgLevliste: TnxQuery
    Session = nxSess
    AliasName = 'Produktion'
    ReadOnly = True
    SQL.Strings = (
      '#t 100000'
      ''
      'select '
      '     distinct listenr,'
      '     cast(dato as date) as dato ,'
      '     konto'
      'from ekspleveringsliste as l'
      'order by listenr desc')
    Left = 16
    Top = 696
    object nqVaelgLevlistelistenr: TIntegerField
      FieldName = 'listenr'
    end
    object nqVaelgLevlistedato: TDateField
      FieldName = 'dato'
    end
    object nqVaelgLevlistekonto: TStringField
      FieldName = 'konto'
    end
  end
  object dsVaelgLevliste: TDataSource
    AutoEdit = False
    DataSet = nqVaelgLevliste
    Left = 80
    Top = 696
  end
  object nqKundeOrd: TnxQuery
    Session = nxSess
    AliasName = 'Produktion'
    SQL.Strings = (
      'select '
      '  Takserdato as Dato,'
      '  l.subvarenr as Varenr,'
      '  l.tekst as Navn,'
      '  case when l.linietype=1 then '#39'Salg'#39' else '#39'Retur'#39' end as Type'
      'from'
      '('
      '   select '
      '     lbnr,'
      '     takserdato'
      '   from ekspeditioner'
      '//     where kundenr=:kundenr'
      '     where takserdato > current_timestamp - interval '#39'6'#39' month'
      ') as e'
      'left join ekspliniersalg as l on l.lbnr=e.lbnr'
      '//where atckode=:atckode'
      'order by takserdato desc')
    Left = 160
    Top = 696
    object nqKundeOrdDato: TDateTimeField
      FieldName = 'Dato'
    end
    object nqKundeOrdVarenr: TStringField
      DisplayWidth = 10
      FieldName = 'Varenr'
    end
    object nqKundeOrdNavn: TStringField
      DisplayWidth = 30
      FieldName = 'Navn'
      Size = 100
    end
    object nqKundeOrdType: TStringField
      FieldName = 'Type'
      Size = 5
    end
  end
  object dsKundeOrd: TDataSource
    AutoEdit = False
    DataSet = nqKundeOrd
    Left = 232
    Top = 696
  end
  object nxEkspBon: TnxTable
    TableName = 'EkspeditionerBon'
    IndexName = 'LbNrOrden'
    Left = 560
    Top = 696
    object nxEkspBonLbNr: TLargeintField
      FieldName = 'LbNr'
    end
    object nxEkspBonKasseNr: TLargeintField
      FieldName = 'KasseNr'
    end
    object nxEkspBonBonNr: TLargeintField
      FieldName = 'BonNr'
    end
  end
  object nxEksp: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'Ekspeditioner'
    IndexName = 'NrOrden'
    Left = 616
    Top = 696
    object nxEkspEdbGebyr: TCurrencyField
      FieldName = 'EdbGebyr'
    end
    object nxEkspTlfGebyr: TCurrencyField
      FieldName = 'TlfGebyr'
    end
    object nxEkspUdbrGebyr: TCurrencyField
      FieldName = 'UdbrGebyr'
    end
    object nxEkspLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object nxEkspTakserDato: TDateTimeField
      FieldName = 'TakserDato'
    end
  end
  object nxRemoteServerInfoPlugin1: TnxRemoteServerInfoPlugin
    DisplayCategory = 'Plugins'
    Session = nxSess
    Left = 672
    Top = 704
  end
  object nqDosETK: TnxQuery
    Left = 808
    Top = 688
  end
  object mtRei: TClientDataSet
    PersistDataPacket.Data = {
      900300009619E0BD010000001800000022000000000003000000900306566172
      654E720100490000000100055749445448020002001400075661726554787401
      004900000001000557494454480200020050000755646C65764E720200020000
      0000000855646C65764D6178020002000000000005416E74616C040001000000
      00000645746B4C696E02000200000000000445746B3101004900000001000557
      494454480200020032000445746B320100490000000100055749445448020002
      0032000445746B3301004900000001000557494454480200020032000445746B
      3401004900000001000557494454480200020032000445746B35010049000000
      01000557494454480200020032000445746B3601004900000001000557494454
      480200020032000445746B370100490000000100055749445448020002003200
      0445746B3801004900000001000557494454480200020032000445746B390100
      4900000001000557494454480200020032000545746B31300100490000000100
      05574944544802000200320008446F734B6F6465310100490000000100055749
      44544802000200140008446F734B6F6465320100490000000100055749445448
      02000200140009496E64696B4B6F646501004900000001000557494454480200
      02001400075478744B6F64650100490000000100055749445448020002001400
      0754696C736B75640100490000000100055749445448020002001E0005537562
      73740200020000000000054F7264496401004900000001000557494454480200
      02000F0008526563657074496404000100000000000855736572507269730800
      04000000010007535542545950450200490006004D6F6E657900095375625661
      72656E720100490000000100055749445448020002000A0006446F7354787401
      0049000000010005574944544802000200320006496E64547874010049000000
      01000557494454480200020032000F4F7264696E65726574566172656E720100
      490000000100055749445448020002000A000E4F7264696E65726574416E7461
      6C0400010000000000124F7264696E6572657455646C65765479706501004900
      00000100055749445448020002000A000D556473746564657241757469640100
      4900000001000557494454480200020005000A55647374656465724964010049
      000000010005574944544802000200C8000C5564737465646572547970650100
      4900000001000557494454480200020001000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'VareNr'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'VareTxt'
        DataType = ftString
        Size = 80
      end
      item
        Name = 'UdlevNr'
        DataType = ftWord
      end
      item
        Name = 'UdlevMax'
        DataType = ftWord
      end
      item
        Name = 'Antal'
        DataType = ftInteger
      end
      item
        Name = 'EtkLin'
        DataType = ftWord
      end
      item
        Name = 'Etk1'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk2'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk3'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk4'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk5'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk6'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk7'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk8'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk9'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Etk10'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'DosKode1'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DosKode2'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'IndikKode'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'TxtKode'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Tilskud'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Subst'
        DataType = ftWord
      end
      item
        Name = 'OrdId'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'ReceptId'
        DataType = ftInteger
      end
      item
        Name = 'UserPris'
        DataType = ftCurrency
      end
      item
        Name = 'SubVarenr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'DosTxt'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'IndTxt'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'OrdineretVarenr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'OrdineretAntal'
        DataType = ftInteger
      end
      item
        Name = 'OrdineretUdlevType'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'UdstederAutid'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'UdstederId'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'UdstederType'
        DataType = ftString
        Size = 1
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 312
    Top = 112
    object mtReiVareNr: TStringField
      FieldName = 'VareNr'
    end
    object mtReiVareTxt: TStringField
      DisplayWidth = 80
      FieldName = 'VareTxt'
      Size = 80
    end
    object mtReiUdlevNr: TWordField
      FieldName = 'UdlevNr'
    end
    object mtReiUdlevMax: TWordField
      FieldName = 'UdlevMax'
    end
    object mtReiAntal: TIntegerField
      FieldName = 'Antal'
    end
    object mtReiEtkLin: TWordField
      FieldName = 'EtkLin'
    end
    object mtReiEtk1: TStringField
      FieldName = 'Etk1'
      Size = 50
    end
    object mtReiEtk2: TStringField
      FieldName = 'Etk2'
      Size = 50
    end
    object mtReiEtk3: TStringField
      FieldName = 'Etk3'
      Size = 50
    end
    object mtReiEtk4: TStringField
      FieldName = 'Etk4'
      Size = 50
    end
    object mtReiEtk5: TStringField
      FieldName = 'Etk5'
      Size = 50
    end
    object mtReiEtk6: TStringField
      FieldName = 'Etk6'
      Size = 50
    end
    object mtReiEtk7: TStringField
      FieldName = 'Etk7'
      Size = 50
    end
    object mtReiEtk8: TStringField
      FieldName = 'Etk8'
      Size = 50
    end
    object mtReiEtk9: TStringField
      FieldName = 'Etk9'
      Size = 50
    end
    object mtReiEtk10: TStringField
      FieldName = 'Etk10'
      Size = 50
    end
    object mtReiDosKode1: TStringField
      FieldName = 'DosKode1'
    end
    object mtReiDosKode2: TStringField
      FieldName = 'DosKode2'
    end
    object mtReiIndikKode: TStringField
      FieldName = 'IndikKode'
    end
    object mtReiTxtKode: TStringField
      FieldName = 'TxtKode'
    end
    object mtReiTilskud: TStringField
      FieldName = 'Tilskud'
      Size = 30
    end
    object mtReiSubst: TWordField
      FieldName = 'Subst'
    end
    object mtReiOrdId: TStringField
      FieldName = 'OrdId'
      Size = 15
    end
    object mtReiReceptId: TIntegerField
      FieldName = 'ReceptId'
    end
    object mtReiUserPris: TCurrencyField
      FieldName = 'UserPris'
    end
    object mtReiSubVarenr: TStringField
      FieldName = 'SubVarenr'
      Size = 10
    end
    object mtReiDosTxt: TStringField
      FieldName = 'DosTxt'
      Size = 50
    end
    object mtReiIndTxt: TStringField
      FieldName = 'IndTxt'
      Size = 50
    end
    object mtReiOrdineretVarenr: TStringField
      FieldName = 'OrdineretVarenr'
      Size = 10
    end
    object mtReiOrdineretAntal: TIntegerField
      FieldName = 'OrdineretAntal'
    end
    object mtReiOrdineretUdlevType: TStringField
      FieldName = 'OrdineretUdlevType'
      Size = 10
    end
    object mtReiUdstederAutid: TStringField
      FieldName = 'UdstederAutid'
      Size = 5
    end
    object mtReiUdstederId: TStringField
      FieldName = 'UdstederId'
      Size = 200
    end
    object mtReiUdstederType: TStringField
      FieldName = 'UdstederType'
      Size = 1
    end
  end
  object mtGro: TClientDataSet
    PersistDataPacket.Data = {
      370000009619E0BD01000000180000000200000000000300000037000447724E
      7202000200000000000747724F706C4E7204000100000000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'GrNr'
        DataType = ftWord
      end
      item
        Name = 'GrOplNr'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 64
    Top = 520
    object mtGroGrNr: TWordField
      FieldName = 'GrNr'
    end
    object mtGroGrOplNr: TIntegerField
      FieldName = 'GrOplNr'
    end
  end
  object nxDCH: TnxTable
    TableName = 'DosisCardHeader'
    Left = 688
    Top = 528
    object WordField1: TWordField
      DisplayLabel = 'KortNummer'
      FieldName = 'CardNumber'
      Required = True
    end
    object StringField1: TStringField
      DisplayLabel = 'CPR Nr'
      FieldName = 'PatientNumber'
      Required = True
      Size = 10
    end
    object StringField2: TStringField
      DisplayLabel = 'Patientnavn'
      FieldName = 'PatientName'
      Required = True
      Size = 30
    end
    object StringField3: TStringField
      FieldName = 'PatientAddress1'
      Visible = False
      Size = 30
    end
    object StringField4: TStringField
      FieldName = 'PatientAddress2'
      Visible = False
      Size = 30
    end
    object StringField5: TStringField
      FieldName = 'Postnummer'
      Visible = False
      Size = 30
    end
    object StringField6: TStringField
      FieldName = 'DeliveryAddress'
      Visible = False
      Size = 30
    end
    object StringField7: TStringField
      FieldName = 'KontaktPerson'
      Visible = False
      Size = 30
    end
    object StringField8: TStringField
      FieldName = 'DoctorNumber'
      Required = True
      Visible = False
      Size = 7
    end
    object StringField9: TStringField
      FieldName = 'DoctorName'
      Visible = False
      Size = 30
    end
    object WordField2: TWordField
      FieldName = 'Telegram'
      Visible = False
    end
    object DateTimeField1: TDateTimeField
      DisplayLabel = 'StartDato'
      DisplayWidth = 10
      FieldName = 'StartDate'
      Required = True
    end
    object DateTimeField2: TDateTimeField
      DisplayLabel = 'Slutdato'
      DisplayWidth = 10
      FieldName = 'EndDate'
      Required = True
    end
    object WordField3: TWordField
      FieldName = 'Interval'
      Required = True
      Visible = False
    end
    object DateTimeField3: TDateTimeField
      FieldName = 'AddDate'
      Visible = False
    end
    object IntegerField1: TIntegerField
      FieldName = 'Adduser'
      Visible = False
    end
    object DateTimeField4: TDateTimeField
      FieldName = 'ChangeDate'
      Visible = False
    end
    object IntegerField2: TIntegerField
      FieldName = 'ChangeUser'
      Visible = False
    end
    object DateTimeField5: TDateTimeField
      FieldName = 'DeleteDate'
      Visible = False
    end
    object IntegerField3: TIntegerField
      FieldName = 'DeleteUser'
      Visible = False
    end
    object IntegerField4: TIntegerField
      FieldName = 'PackGroupNumber'
      Visible = False
    end
    object StringField10: TStringField
      FieldName = 'DoctorComment'
      Visible = False
      Size = 250
    end
    object StringField11: TStringField
      FieldName = 'PharmacistComment'
      Visible = False
      Size = 250
    end
    object StringField12: TStringField
      FieldName = 'Dosiskod'
      Required = True
      Visible = False
      Size = 10
    end
    object DateTimeField6: TDateTimeField
      FieldName = 'SendDate'
      Visible = False
    end
    object IntegerField5: TIntegerField
      FieldName = 'Kontroller'
      Visible = False
    end
    object DateTimeField7: TDateTimeField
      FieldName = 'KontrolDate'
      Visible = False
    end
    object StringField13: TStringField
      FieldName = 'StartDay'
      Visible = False
      Size = 10
    end
    object DateTimeField8: TDateTimeField
      FieldName = 'FileReceiveDate'
      Visible = False
    end
    object DateTimeField9: TDateTimeField
      FieldName = 'OrderReceiveDate'
      Visible = False
    end
    object nxMemoField1: TnxMemoField
      FieldName = 'OrderMemo'
      Visible = False
      BlobType = ftMemo
    end
    object BooleanField1: TBooleanField
      FieldName = 'PackAccept'
      Visible = False
    end
    object nxMemoField2: TnxMemoField
      FieldName = 'BemaerkMemo'
      Visible = False
      BlobType = ftMemo
    end
    object BooleanField2: TBooleanField
      FieldName = 'Parked'
      Visible = False
    end
    object StringField14: TStringField
      FieldName = 'YderCprNr'
      Visible = False
      Size = 10
    end
    object BooleanField3: TBooleanField
      FieldName = 'AndreTilskud'
      Visible = False
    end
    object BooleanField4: TBooleanField
      FieldName = 'Klausuleret'
      Visible = False
    end
    object IntegerField6: TIntegerField
      FieldName = 'Lbnr'
    end
    object StringField15: TStringField
      FieldKind = fkCalculated
      FieldName = 'KortStatus'
      OnGetText = ffdchKortStatusGetText
      Calculated = True
    end
    object nxDCHAutoEksp: TBooleanField
      FieldName = 'AutoEksp'
    end
    object nxDCHTerminalStatus: TBooleanField
      FieldName = 'TerminalStatus'
    end
  end
  object dsnxDCH: TDataSource
    DataSet = nxDCH
    Left = 688
    Top = 572
  end
  object ffBetFrm: TnxTable
    ActiveDesigntime = True
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'BetalingsFormer'
    IndexName = 'NrOrden'
    Left = 364
    Top = 184
    object ffBetFrmNr: TWordField
      FieldName = 'Nr'
    end
    object ffBetFrmOperation: TStringField
      FieldName = 'Operation'
    end
    object ffBetFrmNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
  end
  object ffKreFrm: TnxTable
    ActiveDesigntime = True
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'KreditFormer'
    IndexName = 'NrOrden'
    Left = 312
    Top = 184
    object ffKreFrmNr: TWordField
      FieldName = 'Nr'
    end
    object ffKreFrmOperation: TStringField
      FieldName = 'Operation'
    end
    object ffKreFrmNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object ffKreFrmDage: TWordField
      FieldName = 'Dage'
    end
    object ffKreFrmRespit: TWordField
      FieldName = 'Respit'
    end
  end
  object nxOrd: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    FlipOrder = True
    OnFilterRecord = nxOrdFilterRecord
    TableName = 'EHOrdreHeader'
    IndexName = 'C2NrOrden'
    Left = 832
    Top = 248
    object nxOrdC2Nr: TIntegerField
      FieldName = 'C2Nr'
    end
    object nxOrdEordrenummer: TStringField
      DisplayWidth = 10
      FieldName = 'Eordrenummer'
      Size = 64
    end
    object nxOrdKundeCPR: TStringField
      FieldName = 'KundeCPR'
      Size = 10
    end
    object nxOrdHjemNavn: TStringField
      DisplayWidth = 25
      FieldName = 'HjemNavn'
      Size = 80
    end
    object nxOrdBetalingsmetode: TStringField
      DisplayWidth = 13
      FieldName = 'Betalingsmetode'
      Size = 32
    end
    object nxOrdEkspLbnr: TIntegerField
      DisplayLabel = 'Pakkenr.'
      FieldName = 'EkspLbnr'
    end
    object nxOrdLeveringsmetode: TStringField
      DisplayWidth = 13
      FieldName = 'Leveringsmetode'
      Size = 32
    end
    object nxOrdAfhentningssted: TStringField
      DisplayWidth = 20
      FieldName = 'Afhentningssted'
      Size = 64
    end
    object nxOrdOrdredato: TStringField
      FieldName = 'Ordredato'
      Size = 30
    end
    object nxOrdKundeeordrenummer: TIntegerField
      FieldName = 'Kundeeordrenummer'
    end
    object nxOrdApoteketsRef: TStringField
      DisplayWidth = 50
      FieldName = 'ApoteketsRef'
      Size = 255
    end
    object nxOrdGenereringsbaggrund: TStringField
      DisplayWidth = 16
      FieldName = 'Genereringsbaggrund'
      Size = 32
    end
    object nxOrdOrdrestatus: TStringField
      DisplayWidth = 16
      FieldName = 'Ordrestatus'
      Size = 32
    end
    object nxOrdAfventerKundensGodkendelse: TBooleanField
      FieldName = 'AfventerKundensGodkendelse'
    end
    object nxOrdAendringerKanAfvises: TBooleanField
      FieldName = 'AendringerKanAfvises'
    end
    object nxOrdTotallistepris: TCurrencyField
      FieldName = 'Totallistepris'
    end
    object nxOrdFragtpris: TCurrencyField
      FieldName = 'Fragtpris'
    end
    object nxOrdTotalpris: TCurrencyField
      FieldName = 'Totalpris'
    end
    object nxOrdFraAbonnement: TBooleanField
      FieldName = 'FraAbonnement'
    end
    object nxOrdMedlemAfDanmark: TBooleanField
      FieldName = 'MedlemAfDanmark'
    end
    object nxOrdEmail: TStringField
      DisplayWidth = 20
      FieldName = 'Email'
      Size = 64
    end
    object nxOrdTelefon: TStringField
      DisplayWidth = 15
      FieldName = 'Telefon'
      Size = 50
    end
    object nxOrdMobiletelefon: TStringField
      DisplayWidth = 15
      FieldName = 'Mobiletelefon'
      Size = 50
    end
    object nxOrdHjemAdresse1: TStringField
      DisplayWidth = 40
      FieldName = 'HjemAdresse1'
      Size = 80
    end
    object nxOrdHjemAdresse2: TStringField
      DisplayWidth = 40
      FieldName = 'HjemAdresse2'
      Size = 80
    end
    object nxOrdHjemPostnummer: TStringField
      DisplayLabel = 'PostNr'
      DisplayWidth = 10
      FieldName = 'HjemPostnummer'
    end
    object nxOrdHjemBy: TStringField
      DisplayWidth = 32
      FieldName = 'HjemBy'
      Size = 64
    end
    object nxOrdHjemLand: TStringField
      DisplayWidth = 15
      FieldName = 'HjemLand'
      Size = 50
    end
    object nxOrdLeveringsNavn: TStringField
      DisplayWidth = 25
      FieldName = 'LeveringsNavn'
      Size = 80
    end
    object nxOrdLeveringsAdresse1: TStringField
      DisplayWidth = 40
      FieldName = 'LeveringsAdresse1'
      Size = 80
    end
    object nxOrdLeveringsAdresse2: TStringField
      DisplayWidth = 40
      FieldName = 'LeveringsAdresse2'
      Size = 80
    end
    object nxOrdLeveringsPostnummer: TStringField
      DisplayLabel = 'PostNr'
      DisplayWidth = 10
      FieldName = 'LeveringsPostnummer'
    end
    object nxOrdLeveringsBy: TStringField
      DisplayWidth = 32
      FieldName = 'LeveringsBy'
      Size = 64
    end
    object nxOrdLeveringsLand: TStringField
      DisplayWidth = 15
      FieldName = 'LeveringsLand'
      Size = 50
    end
    object nxOrdAfhentningsstedErApotek: TBooleanField
      FieldName = 'AfhentningsstedErApotek'
    end
    object nxOrdDibsTransaktionsId: TStringField
      DisplayWidth = 25
      FieldName = 'DibsTransaktionsId'
      Size = 50
    end
    object nxOrdDibsOrdrenummer: TStringField
      DisplayWidth = 25
      FieldName = 'DibsOrdrenummer'
      Size = 50
    end
    object nxOrdDibsMerchantId: TStringField
      DisplayWidth = 25
      FieldName = 'DibsMerchantId'
      Size = 50
    end
    object nxOrdAutoriseretBeloeb: TCurrencyField
      FieldName = 'AutoriseretBeloeb'
    end
    object nxOrdHaevetBeloeb: TCurrencyField
      FieldName = 'HaevetBeloeb'
    end
    object nxOrdBeskedFraKunde: TnxMemoField
      FieldName = 'BeskedFraKunde'
      BlobType = ftMemo
    end
    object nxOrdBeskedFraApotek: TnxMemoField
      FieldName = 'BeskedFraApotek'
      BlobType = ftMemo
    end
    object nxOrdUdleveringstidspunkt: TStringField
      FieldName = 'Udleveringstidspunkt'
      Size = 30
    end
    object nxOrdEkspedient: TStringField
      DisplayWidth = 15
      FieldName = 'Ekspedient'
      Size = 128
    end
    object nxOrdUdleveringsnummer: TStringField
      DisplayLabel = 'PakkeNr'
      DisplayWidth = 10
      FieldName = 'Udleveringsnummer'
      Size = 64
    end
    object nxOrdTrackAndTrace: TStringField
      FieldName = 'TrackAndTrace'
      Size = 32
    end
    object nxOrdSamletKundeandel: TCurrencyField
      FieldName = 'SamletKundeandel'
    end
    object nxOrdAnvendtCTR: TCurrencyField
      FieldName = 'AnvendtCTR'
    end
    object nxOrdNyBeregnetCTRsaldo: TCurrencyField
      FieldName = 'NyBeregnetCTRsaldo'
    end
    object nxOrdCTRperiodeudloeb: TStringField
      FieldName = 'CTRperiodeudloeb'
      Size = 30
    end
    object nxOrdTilskudsberettiget: TCurrencyField
      FieldName = 'Tilskudsberettiget'
    end
    object nxOrdIkkeTilskudsberettiget: TCurrencyField
      FieldName = 'IkkeTilskudsberettiget'
    end
    object nxOrdPrintStatus: TIntegerField
      FieldName = 'PrintStatus'
    end
    object nxOrdOrdreStatTekst: TStringField
      FieldName = 'OrdreStatTekst'
      Size = 30
    end
    object nxOrdApotekId: TStringField
      FieldName = 'ApotekId'
      Size = 10
    end
  end
  object nxOrdLin: TnxTable
    TableName = 'EHOrdreLinier'
    IndexFieldNames = 'Eordrenummer'
    MasterFields = 'Eordrenummer'
    MasterSource = dsOrd
    Left = 888
    Top = 248
    object nxOrdLinEordrenummer: TStringField
      FieldName = 'Eordrenummer'
      Size = 64
    end
    object nxOrdLinLinjenummer: TIntegerField
      FieldName = 'Linjenummer'
    end
    object nxOrdLinAntal: TIntegerField
      FieldName = 'Antal'
    end
    object nxOrdLinVarenummer: TStringField
      FieldName = 'Varenummer'
      Size = 10
    end
    object nxOrdLinErSpeciel: TBooleanField
      FieldName = 'ErSpeciel'
    end
    object nxOrdLinVarenavn: TStringField
      FieldName = 'Varenavn'
      Size = 128
    end
    object nxOrdLinForm: TStringField
      FieldName = 'Form'
      Size = 64
    end
    object nxOrdLinStyrke: TStringField
      FieldName = 'Styrke'
      Size = 64
    end
    object nxOrdLinPakningsstoerrelse: TStringField
      FieldName = 'Pakningsstoerrelse'
      Size = 64
    end
    object nxOrdLinSubstitution: TStringField
      FieldName = 'Substitution'
      Size = 32
    end
    object nxOrdLinListeprisPerStk: TCurrencyField
      FieldName = 'ListeprisPerStk'
    end
    object nxOrdLinTotallistepris: TCurrencyField
      FieldName = 'Totallistepris'
    end
    object nxOrdLinApoteketsLinjeRef: TnxMemoField
      FieldName = 'ApoteketsLinjeRef'
      BlobType = ftMemo
    end
    object nxOrdLinOrdinationType: TStringField
      FieldName = 'OrdinationType'
      Size = 32
    end
    object nxOrdLinOrdinationsId: TStringField
      FieldName = 'OrdinationsId'
      Size = 64
    end
    object nxOrdLinReceptId: TStringField
      FieldName = 'ReceptId'
      Size = 64
    end
    object nxOrdLinApoteketsOrdinationRef: TnxMemoField
      FieldName = 'ApoteketsOrdinationRef'
      BlobType = ftMemo
    end
    object nxOrdLinOrdineretAntal: TIntegerField
      FieldName = 'OrdineretAntal'
    end
    object nxOrdLinOrdineretVarenummer: TStringField
      FieldName = 'OrdineretVarenummer'
      Size = 10
    end
    object nxOrdLinSygesikringensAndel: TCurrencyField
      FieldName = 'SygesikringensAndel'
    end
    object nxOrdLinKommunensAndel: TCurrencyField
      FieldName = 'KommunensAndel'
    end
    object nxOrdLinKundeandel: TCurrencyField
      FieldName = 'Kundeandel'
    end
    object nxOrdLinCTRbeloeb: TCurrencyField
      FieldName = 'CTRbeloeb'
    end
    object nxOrdLinEkspLinienr: TIntegerField
      FieldName = 'EkspLinienr'
    end
    object nxOrdLinC2Nr: TIntegerField
      FieldName = 'C2Nr'
    end
  end
  object dsOrd: TDataSource
    AutoEdit = False
    DataSet = nxOrd
    Left = 832
    Top = 304
  end
  object dsOrdLin: TDataSource
    AutoEdit = False
    DataSet = nxOrdLin
    Left = 888
    Top = 304
  end
  object nxQryPak: TnxQuery
    Left = 888
    Top = 360
  end
  object nxEkspLin: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'EkspLinierSalg'
    IndexName = 'NrOrden'
    Left = 888
    Top = 472
    object nxEkspLinLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object nxEkspLinLinieNr: TWordField
      FieldName = 'LinieNr'
    end
    object nxEkspLinLinieType: TWordField
      FieldName = 'LinieType'
    end
    object nxEkspLinLager: TWordField
      FieldName = 'Lager'
    end
    object nxEkspLinGMark: TBooleanField
      FieldName = 'GMark'
    end
    object nxEkspLinOMark: TBooleanField
      FieldName = 'OMark'
    end
    object nxEkspLinAMark: TBooleanField
      FieldName = 'AMark'
    end
    object nxEkspLinPMark: TBooleanField
      FieldName = 'PMark'
    end
    object nxEkspLinVareNr: TStringField
      FieldName = 'VareNr'
    end
    object nxEkspLinSubVareNr: TStringField
      FieldName = 'SubVareNr'
    end
    object nxEkspLinStatNr: TStringField
      FieldName = 'StatNr'
    end
    object nxEkspLinLokation1: TWordField
      FieldName = 'Lokation1'
    end
    object nxEkspLinLokation2: TWordField
      FieldName = 'Lokation2'
    end
    object nxEkspLinLokation3: TWordField
      FieldName = 'Lokation3'
    end
    object nxEkspLinVareType: TWordField
      FieldName = 'VareType'
    end
    object nxEkspLinVareGruppe: TWordField
      FieldName = 'VareGruppe'
    end
    object nxEkspLinStatGruppe: TWordField
      FieldName = 'StatGruppe'
    end
    object nxEkspLinOmsType: TWordField
      FieldName = 'OmsType'
    end
    object nxEkspLinNarkoType: TWordField
      FieldName = 'NarkoType'
    end
    object nxEkspLinTilskType: TWordField
      FieldName = 'TilskType'
    end
    object nxEkspLinDKType: TWordField
      FieldName = 'DKType'
    end
    object nxEkspLinTekst: TStringField
      FieldName = 'Tekst'
      Size = 100
    end
    object nxEkspLinEnhed: TStringField
      FieldName = 'Enhed'
      Size = 5
    end
    object nxEkspLinForm: TStringField
      FieldName = 'Form'
    end
    object nxEkspLinStyrke: TStringField
      FieldName = 'Styrke'
    end
    object nxEkspLinPakning: TStringField
      FieldName = 'Pakning'
      Size = 30
    end
    object nxEkspLinATCType: TStringField
      FieldName = 'ATCType'
      Size = 3
    end
    object nxEkspLinATCKode: TStringField
      FieldName = 'ATCKode'
      Size = 7
    end
    object nxEkspLinSSKode: TStringField
      FieldName = 'SSKode'
      Size = 2
    end
    object nxEkspLinKlausul: TStringField
      FieldName = 'Klausul'
      Size = 5
    end
    object nxEkspLinPAKode: TStringField
      FieldName = 'PAKode'
      Size = 2
    end
    object nxEkspLinDDD: TIntegerField
      FieldName = 'DDD'
    end
    object nxEkspLinDyreArt: TWordField
      FieldName = 'DyreArt'
    end
    object nxEkspLinAldersGrp: TWordField
      FieldName = 'AldersGrp'
    end
    object nxEkspLinOrdGrp: TWordField
      FieldName = 'OrdGrp'
    end
    object nxEkspLinUdlevMax: TWordField
      FieldName = 'UdlevMax'
    end
    object nxEkspLinUdlevNr: TWordField
      FieldName = 'UdlevNr'
    end
    object nxEkspLinAntal: TIntegerField
      FieldName = 'Antal'
    end
    object nxEkspLinPris: TCurrencyField
      FieldName = 'Pris'
    end
    object nxEkspLinKostPris: TCurrencyField
      FieldName = 'KostPris'
    end
    object nxEkspLinVareForbrug: TCurrencyField
      FieldName = 'VareForbrug'
    end
    object nxEkspLinBrutto: TCurrencyField
      FieldName = 'Brutto'
    end
    object nxEkspLinRabatPct: TCurrencyField
      FieldName = 'RabatPct'
    end
    object nxEkspLinRabat: TCurrencyField
      FieldName = 'Rabat'
    end
    object nxEkspLinExMoms: TCurrencyField
      FieldName = 'ExMoms'
    end
    object nxEkspLinInclMoms: TBooleanField
      FieldName = 'InclMoms'
    end
    object nxEkspLinMomsPct: TCurrencyField
      FieldName = 'MomsPct'
    end
    object nxEkspLinMoms: TCurrencyField
      FieldName = 'Moms'
    end
    object nxEkspLinNetto: TCurrencyField
      FieldName = 'Netto'
    end
    object nxEkspLinEjS: TWordField
      FieldName = 'EjS'
    end
    object nxEkspLinEjO: TWordField
      FieldName = 'EjO'
    end
    object nxEkspLinEjG: TWordField
      FieldName = 'EjG'
    end
    object nxEkspLinUdLevType: TStringField
      FieldName = 'UdLevType'
      Size = 5
    end
  end
  object nxEkspTil: TnxTable
    TableName = 'EkspLinierTilskud'
    IndexName = 'NrOrden'
    Left = 888
    Top = 528
    object nxEkspTilLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object nxEkspTilLinieNr: TWordField
      FieldName = 'LinieNr'
    end
    object nxEkspTilFraDato1: TDateTimeField
      FieldName = 'FraDato1'
    end
    object nxEkspTilTilDato1: TDateTimeField
      FieldName = 'TilDato1'
    end
    object nxEkspTilFraDato2: TDateTimeField
      FieldName = 'FraDato2'
    end
    object nxEkspTilTilDato2: TDateTimeField
      FieldName = 'TilDato2'
    end
    object nxEkspTilJournalNr1: TStringField
      FieldName = 'JournalNr1'
    end
    object nxEkspTilJournalNr2: TStringField
      FieldName = 'JournalNr2'
    end
    object nxEkspTilESP: TCurrencyField
      FieldName = 'ESP'
    end
    object nxEkspTilRFP: TCurrencyField
      FieldName = 'RFP'
    end
    object nxEkspTilBGP: TCurrencyField
      FieldName = 'BGP'
    end
    object nxEkspTilSaldo: TCurrencyField
      FieldName = 'Saldo'
    end
    object nxEkspTilIBPBel: TCurrencyField
      FieldName = 'IBPBel'
    end
    object nxEkspTilBGPBel: TCurrencyField
      FieldName = 'BGPBel'
    end
    object nxEkspTilIBTBel: TCurrencyField
      FieldName = 'IBTBel'
    end
    object nxEkspTilUdligning: TCurrencyField
      FieldName = 'Udligning'
    end
    object nxEkspTilAndel: TCurrencyField
      FieldName = 'Andel'
    end
    object nxEkspTilTilskSyg: TCurrencyField
      FieldName = 'TilskSyg'
    end
    object nxEkspTilTilskKom1: TCurrencyField
      FieldName = 'TilskKom1'
    end
    object nxEkspTilTilskKom2: TCurrencyField
      FieldName = 'TilskKom2'
    end
    object nxEkspTilRegelSyg: TWordField
      FieldName = 'RegelSyg'
    end
    object nxEkspTilRegelKom1: TWordField
      FieldName = 'RegelKom1'
    end
    object nxEkspTilRegelKom2: TWordField
      FieldName = 'RegelKom2'
    end
    object nxEkspTilPromilleSyg: TWordField
      FieldName = 'PromilleSyg'
    end
    object nxEkspTilPromilleKom1: TWordField
      FieldName = 'PromilleKom1'
    end
    object nxEkspTilPromilleKom2: TWordField
      FieldName = 'PromilleKom2'
    end
    object nxEkspTilAfdeling1: TStringField
      FieldName = 'Afdeling1'
      Size = 30
    end
    object nxEkspTilAfdeling2: TStringField
      FieldName = 'Afdeling2'
      Size = 30
    end
    object nxEkspTilCtrIndberettet: TWordField
      FieldName = 'CtrIndberettet'
    end
    object nxEkspTilAfdeling1Ej: TStringField
      FieldName = 'Afdeling1Ej'
      Size = 30
    end
    object nxEkspTilAfdeling2Ej: TStringField
      FieldName = 'Afdeling2Ej'
      Size = 30
    end
  end
  object nxLager: TnxTable
    TableName = 'LagerKartotek'
    Left = 880
    Top = 584
    object nxLagerLager: TWordField
      FieldName = 'Lager'
    end
    object nxLagerVareNr: TStringField
      FieldName = 'VareNr'
    end
    object nxLagerEanKode: TStringField
      FieldName = 'EanKode'
    end
    object nxLagerAtcKode: TStringField
      FieldName = 'AtcKode'
      Size = 15
    end
    object nxLagerSamPakNr: TStringField
      FieldName = 'SamPakNr'
      Size = 10
    end
    object nxLagerTekst: TStringField
      FieldName = 'Tekst'
      Size = 30
    end
    object nxLagerTekst2: TStringField
      FieldName = 'Tekst2'
      Size = 30
    end
    object nxLagerPaknNum: TIntegerField
      FieldName = 'PaknNum'
    end
    object nxLagerPaknEnh: TStringField
      FieldName = 'PaknEnh'
      Size = 5
    end
    object nxLagerKommentar: TStringField
      FieldName = 'Kommentar'
      Size = 50
    end
    object nxLagerABCgruppe: TStringField
      FieldName = 'ABCgruppe'
      Size = 10
    end
    object nxLagerGruppe: TWordField
      FieldName = 'Gruppe'
    end
    object nxLagerSamPakAnt: TWordField
      FieldName = 'SamPakAnt'
    end
    object nxLagerGrNr1: TWordField
      FieldName = 'GrNr1'
    end
    object nxLagerGrNr2: TWordField
      FieldName = 'GrNr2'
    end
    object nxLagerLokation1: TIntegerField
      FieldName = 'Lokation1'
    end
    object nxLagerLokation2: TIntegerField
      FieldName = 'Lokation2'
    end
    object nxLagerEgenGrp1: TIntegerField
      FieldName = 'EgenGrp1'
    end
    object nxLagerEgenGrp2: TIntegerField
      FieldName = 'EgenGrp2'
    end
    object nxLagerEgenGrp3: TIntegerField
      FieldName = 'EgenGrp3'
    end
    object nxLagerMinimum: TIntegerField
      FieldName = 'Minimum'
    end
    object nxLagerMaximum: TIntegerField
      FieldName = 'Maximum'
    end
    object nxLagerGenBestil: TIntegerField
      FieldName = 'GenBestil'
    end
    object nxLagerPrimo: TIntegerField
      FieldName = 'Primo'
    end
    object nxLagerAntal: TIntegerField
      FieldName = 'Antal'
    end
    object nxLagerRestOrdre: TIntegerField
      FieldName = 'RestOrdre'
    end
    object nxLagerGrRestOrdre: TIntegerField
      FieldName = 'GrRestOrdre'
    end
    object nxLagerSampakAfr: TBooleanField
      FieldName = 'SampakAfr'
    end
    object nxLagerKostPris: TCurrencyField
      FieldName = 'KostPris'
    end
    object nxLagerKostModel: TWordField
      FieldName = 'KostModel'
    end
    object nxLagerAvanceModel: TWordField
      FieldName = 'AvanceModel'
    end
    object nxLagerLagerMetode: TWordField
      FieldName = 'LagerMetode'
    end
    object nxLagerVareType: TWordField
      FieldName = 'VareType'
    end
    object nxLagerEgenType: TWordField
      FieldName = 'EgenType'
    end
    object nxLagerPrisLabel: TWordField
      FieldName = 'PrisLabel'
    end
    object nxLagerSalgsPris: TCurrencyField
      FieldName = 'SalgsPris'
    end
    object nxLagerSalgsPris2: TCurrencyField
      FieldName = 'SalgsPris2'
    end
    object nxLagerEgenPris: TCurrencyField
      FieldName = 'EgenPris'
    end
    object nxLagerEnhedsPris: TCurrencyField
      FieldName = 'EnhedsPris'
    end
    object nxLagerBevDato: TDateTimeField
      FieldName = 'BevDato'
    end
    object nxLagerOpretDato: TDateTimeField
      FieldName = 'OpretDato'
    end
    object nxLagerRetDato: TDateTimeField
      FieldName = 'RetDato'
    end
    object nxLagerSletDato: TDateTimeField
      FieldName = 'SletDato'
    end
    object nxLagerPrisDato: TDateTimeField
      FieldName = 'PrisDato'
    end
    object nxLagerHovedGrp: TStringField
      FieldName = 'HovedGrp'
      Size = 2
    end
    object nxLagerUnderGrp: TStringField
      FieldName = 'UnderGrp'
      Size = 2
    end
    object nxLagerDrugId: TStringField
      FieldName = 'DrugId'
      Size = 11
    end
    object nxLagerNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object nxLagerForm: TStringField
      FieldName = 'Form'
    end
    object nxLagerStyrke: TStringField
      FieldName = 'Styrke'
    end
    object nxLagerPakning: TStringField
      FieldName = 'Pakning'
      Size = 30
    end
    object nxLagerPaKode: TStringField
      FieldName = 'PaKode'
      Size = 2
    end
    object nxLagerFirmaReg: TIntegerField
      FieldName = 'FirmaReg'
    end
    object nxLagerFirmaImp: TIntegerField
      FieldName = 'FirmaImp'
    end
    object nxLagerUdlevType: TStringField
      FieldName = 'UdlevType'
      Size = 5
    end
    object nxLagerHaType: TStringField
      FieldName = 'HaType'
      Size = 2
    end
    object nxLagerSSKode: TStringField
      FieldName = 'SSKode'
      Size = 2
    end
    object nxLagerOpbevKode: TStringField
      FieldName = 'OpbevKode'
      Size = 1
    end
    object nxLagerSubGrp: TWordField
      FieldName = 'SubGrp'
    end
    object nxLagerSubst: TBooleanField
      FieldName = 'Subst'
    end
    object nxLagerSubKode: TStringField
      FieldName = 'SubKode'
      Size = 1
    end
    object nxLagerTiSubKode: TStringField
      FieldName = 'TiSubKode'
      Size = 1
    end
    object nxLagerTrafikAdv: TBooleanField
      FieldName = 'TrafikAdv'
    end
    object nxLagerDDD: TCurrencyField
      FieldName = 'DDD'
    end
    object nxLagerBGP: TCurrencyField
      FieldName = 'BGP'
    end
    object nxLagerKampStart: TDateTimeField
      FieldName = 'KampStart'
    end
    object nxLagerKampStop: TDateTimeField
      FieldName = 'KampStop'
    end
    object nxLagerTiKostPris: TCurrencyField
      FieldName = 'TiKostPris'
    end
    object nxLagerDoKostPris: TCurrencyField
      FieldName = 'DoKostPris'
    end
    object nxLagerDoSalgsPris: TCurrencyField
      FieldName = 'DoSalgsPris'
    end
    object nxLagerDoBGP: TCurrencyField
      FieldName = 'DoBGP'
    end
    object nxLagerDoSubGrp: TWordField
      FieldName = 'DoSubGrp'
    end
    object nxLagerDoSort: TStringField
      FieldName = 'DoSort'
      Size = 1
    end
    object nxLagerDoEgnet: TBooleanField
      FieldName = 'DoEgnet'
    end
    object nxLagerDelPakNr: TStringField
      FieldName = 'DelPakNr'
      Size = 10
    end
    object nxLagerIndbNr: TStringField
      FieldName = 'IndbNr'
      Size = 10
    end
    object nxLagerIndbKode: TStringField
      FieldName = 'IndbKode'
      Size = 10
    end
    object nxLagerSalgsled: TStringField
      FieldName = 'Salgsled'
    end
    object nxLagerAtcType: TStringField
      FieldName = 'AtcType'
      Size = 1
    end
    object nxLagerTiSalgsPris: TCurrencyField
      FieldName = 'TiSalgsPris'
    end
    object nxLagerEnhPrisBet: TStringField
      FieldName = 'EnhPrisBet'
      Size = 5
    end
    object nxLagerEnhPrisBer: TStringField
      FieldName = 'EnhPrisBer'
      Size = 10
    end
    object nxLagerBerMinimum: TIntegerField
      FieldName = 'BerMinimum'
    end
    object nxLagerBerGenBestil: TIntegerField
      FieldName = 'BerGenBestil'
    end
    object nxLagerFormKode: TStringField
      FieldName = 'FormKode'
      Size = 7
    end
    object nxLagerStyrkeNum: TIntegerField
      FieldName = 'StyrkeNum'
    end
    object nxLagerSubEnhPris: TCurrencyField
      FieldName = 'SubEnhPris'
    end
    object nxLagerTiBGP: TCurrencyField
      FieldName = 'TiBGP'
    end
    object nxLagerTiSalgsPris2: TCurrencyField
      FieldName = 'TiSalgsPris2'
    end
    object nxLagerAfmDato: TDateTimeField
      FieldName = 'AfmDato'
    end
    object nxLagerSubForValg: TStringField
      FieldName = 'SubForValg'
      Size = 1
    end
    object nxLagerDelPakUdskAnt: TWordField
      FieldName = 'DelPakUdskAnt'
    end
  end
  object nxEHSettings: TnxTable
    TableName = 'EHSettings'
    Left = 872
    Top = 640
    object nxEHSettingsApotekId: TStringField
      FieldName = 'ApotekId'
    end
    object nxEHSettingsC2Nr: TIntegerField
      FieldName = 'C2Nr'
    end
    object nxEHSettingsBeskedId: TIntegerField
      FieldName = 'BeskedId'
    end
    object nxEHSettingsPrinterName: TStringField
      FieldName = 'PrinterName'
      Size = 30
    end
    object nxEHSettingsPrinterSkuffe: TStringField
      FieldName = 'PrinterSkuffe'
    end
    object nxEHSettingsPrinterSize: TIntegerField
      FieldName = 'PrinterSize'
    end
    object nxEHSettingsLager: TIntegerField
      FieldName = 'Lager'
    end
    object nxEHSettingsPassword: TStringField
      FieldName = 'Password'
      Size = 10
    end
    object nxEHSettingsDeltaTime: TDateTimeField
      FieldName = 'DeltaTime'
    end
    object nxEHSettingsMajor: TIntegerField
      FieldName = 'Major'
    end
    object nxEHSettingsMinor: TIntegerField
      FieldName = 'Minor'
    end
    object nxEHSettingsAfdeling: TIntegerField
      FieldName = 'Afdeling'
    end
  end
  object NxLagerSubstListe: TnxTable
    TableName = 'LagerSubstListe'
    IndexName = 'NrOrden'
    Left = 120
    Top = 368
  end
  object cdsGeneriske: TClientDataSet
    PersistDataPacket.Data = {
      690000009619E0BD010000001800000003000000000003000000690006447275
      6749440100490000000100055749445448020002000B0006566172654E720100
      490000000100055749445448020002000600044E61766E010049000000010005
      5749445448020002001E000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 872
    Top = 176
    object cdsGeneriskeDrugID: TStringField
      FieldName = 'DrugID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Size = 11
    end
    object cdsGeneriskeVareNr: TStringField
      FieldName = 'VareNr'
      Size = 6
    end
    object cdsGeneriskeNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
  end
  object cdsHenstandsOrdning: TClientDataSet
    PersistDataPacket.Data = {
      B80000009619E0BD010000001800000005000000000003000000B80005616B74
      69760100490000000100055749445448020002000A000F696E64676161656C73
      65736461746F01004900000001000557494454480200020008000B6F70686F65
      72736461746F01004900000001000557494454480200020008000941706F7465
      6B736E7201004900000001000557494454480200020005000D6F70686F657273
      6161727361670100490000000100055749445448020002001E000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'aktiv'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'indgaaelsesdato'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'ophoersdato'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'Apoteksnr'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'ophoersaarsag'
        DataType = ftString
        Size = 30
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 120
    Top = 424
    object cdsHenstandsOrdningaktiv: TStringField
      FieldName = 'aktiv'
      Size = 1
    end
    object cdsHenstandsOrdningindgaaelsesdato: TStringField
      FieldName = 'indgaaelsesdato'
      Size = 8
    end
    object cdsHenstandsOrdningophoersdato: TStringField
      FieldName = 'ophoersdato'
      Size = 8
    end
    object cdsHenstandsOrdningApoteksnr: TStringField
      FieldName = 'Apoteksnr'
      Size = 5
    end
    object cdsHenstandsOrdningophoersaarsag: TStringField
      FieldName = 'ophoersaarsag'
      Size = 30
    end
  end
  object nxDB: TnxDatabase
    ActiveDesigntime = True
    Session = nxSess
    AliasName = 'Produktion'
    Left = 840
    Top = 16
  end
  object tbl_MomsTyper: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'MomsTyper'
    Left = 208
    Top = 344
    object tbl_MomsTyperNr: TWordField
      FieldName = 'Nr'
    end
    object tbl_MomsTyperOperation: TStringField
      FieldName = 'Operation'
    end
    object tbl_MomsTyperNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object tbl_MomsTyperMomsKonto: TStringField
      FieldName = 'MomsKonto'
    end
    object tbl_MomsTyperSats: TCurrencyField
      FieldName = 'Sats'
    end
  end
  object ffKasOpl: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'KasseOplysninger'
    IndexName = 'NrOrden'
    Left = 452
    Top = 68
    object ffKasOplKasseNr: TIntegerField
      FieldName = 'KasseNr'
      DisplayFormat = '###0'
    end
    object ffKasOplBonNr: TIntegerField
      FieldName = 'BonNr'
    end
    object ffKasOplSalgMax: TCurrencyField
      FieldName = 'SalgMax'
    end
    object ffKasOplKasseMax: TCurrencyField
      FieldName = 'KasseMax'
    end
    object ffKasOplPrinter: TStringField
      FieldName = 'Printer'
      Size = 30
    end
    object ffKasOplDisplay: TStringField
      FieldName = 'Display'
      Size = 30
    end
    object ffKasOplSkuffe: TStringField
      FieldName = 'Skuffe'
      Size = 30
    end
    object ffKasOplPrinterPort: TStringField
      FieldName = 'PrinterPort'
      Size = 30
    end
    object ffKasOplDisplayPort: TStringField
      FieldName = 'DisplayPort'
      Size = 30
    end
    object ffKasOplSkuffePort: TStringField
      FieldName = 'SkuffePort'
      Size = 30
    end
    object ffKasOplBonSti: TStringField
      FieldName = 'BonSti'
      Size = 50
    end
    object ffKasOplBonGemAar: TWordField
      FieldName = 'BonGemAar'
    end
    object ffKasOplHovedTxt1: TStringField
      FieldName = 'HovedTxt1'
      Size = 50
    end
    object ffKasOplHovedTxt2: TStringField
      FieldName = 'HovedTxt2'
      Size = 50
    end
    object ffKasOplHovedTxt3: TStringField
      FieldName = 'HovedTxt3'
      Size = 50
    end
    object ffKasOplHovedTxt4: TStringField
      FieldName = 'HovedTxt4'
      Size = 50
    end
    object ffKasOplHovedCenter1: TBooleanField
      FieldName = 'HovedCenter1'
    end
    object ffKasOplHovedCenter2: TBooleanField
      FieldName = 'HovedCenter2'
    end
    object ffKasOplHovedCenter3: TBooleanField
      FieldName = 'HovedCenter3'
    end
    object ffKasOplHovedCenter4: TBooleanField
      FieldName = 'HovedCenter4'
    end
    object ffKasOplHovedBred1: TBooleanField
      FieldName = 'HovedBred1'
    end
    object ffKasOplHovedBred2: TBooleanField
      FieldName = 'HovedBred2'
    end
    object ffKasOplHovedBred3: TBooleanField
      FieldName = 'HovedBred3'
    end
    object ffKasOplHovedBred4: TBooleanField
      FieldName = 'HovedBred4'
    end
    object ffKasOplBundTxt1: TStringField
      FieldName = 'BundTxt1'
      Size = 50
    end
    object ffKasOplBundTxt2: TStringField
      FieldName = 'BundTxt2'
      Size = 50
    end
    object ffKasOplBundTxt3: TStringField
      FieldName = 'BundTxt3'
      Size = 50
    end
    object ffKasOplBundTxt4: TStringField
      FieldName = 'BundTxt4'
      Size = 50
    end
    object ffKasOplBundCenter1: TBooleanField
      FieldName = 'BundCenter1'
    end
    object ffKasOplBundCenter2: TBooleanField
      FieldName = 'BundCenter2'
    end
    object ffKasOplBundCenter3: TBooleanField
      FieldName = 'BundCenter3'
    end
    object ffKasOplBundCenter4: TBooleanField
      FieldName = 'BundCenter4'
    end
    object ffKasOplBundBred1: TBooleanField
      FieldName = 'BundBred1'
    end
    object ffKasOplBundBred2: TBooleanField
      FieldName = 'BundBred2'
    end
    object ffKasOplBundBred3: TBooleanField
      FieldName = 'BundBred3'
    end
    object ffKasOplBundBred4: TBooleanField
      FieldName = 'BundBred4'
    end
    object ffKasOplBonCut: TBooleanField
      FieldName = 'BonCut'
    end
    object ffKasOplKopierSalg: TWordField
      FieldName = 'KopierSalg'
    end
    object ffKasOplKopierIndbet: TWordField
      FieldName = 'KopierIndbet'
    end
    object ffKasOplKopierUdbet: TWordField
      FieldName = 'KopierUdbet'
    end
    object ffKasOplHovedTxt5: TStringField
      FieldName = 'HovedTxt5'
      Size = 50
    end
    object ffKasOplHovedTxt6: TStringField
      FieldName = 'HovedTxt6'
      Size = 50
    end
    object ffKasOplHovedTxt7: TStringField
      FieldName = 'HovedTxt7'
      Size = 50
    end
    object ffKasOplHovedTxt8: TStringField
      FieldName = 'HovedTxt8'
      Size = 50
    end
    object ffKasOplHovedTxt9: TStringField
      FieldName = 'HovedTxt9'
      Size = 50
    end
    object ffKasOplHovedTxt10: TStringField
      FieldName = 'HovedTxt10'
      Size = 50
    end
    object ffKasOplHovedCenter5: TBooleanField
      FieldName = 'HovedCenter5'
    end
    object ffKasOplHovedCenter6: TBooleanField
      FieldName = 'HovedCenter6'
    end
    object ffKasOplHovedCenter7: TBooleanField
      FieldName = 'HovedCenter7'
    end
    object ffKasOplHovedCenter8: TBooleanField
      FieldName = 'HovedCenter8'
    end
    object ffKasOplHovedCenter9: TBooleanField
      FieldName = 'HovedCenter9'
    end
    object ffKasOplHovedCenter10: TBooleanField
      FieldName = 'HovedCenter10'
    end
    object ffKasOplHovedBred5: TBooleanField
      FieldName = 'HovedBred5'
    end
    object ffKasOplHovedBred6: TBooleanField
      FieldName = 'HovedBred6'
    end
    object ffKasOplHovedBred7: TBooleanField
      FieldName = 'HovedBred7'
    end
    object ffKasOplHovedBred8: TBooleanField
      FieldName = 'HovedBred8'
    end
    object ffKasOplHovedBred9: TBooleanField
      FieldName = 'HovedBred9'
    end
    object ffKasOplHovedBred10: TBooleanField
      FieldName = 'HovedBred10'
    end
    object ffKasOplBundTxt5: TStringField
      FieldName = 'BundTxt5'
      Size = 50
    end
    object ffKasOplBundTxt6: TStringField
      FieldName = 'BundTxt6'
      Size = 50
    end
    object ffKasOplBundTxt7: TStringField
      FieldName = 'BundTxt7'
      Size = 50
    end
    object ffKasOplBundTxt8: TStringField
      FieldName = 'BundTxt8'
      Size = 50
    end
    object ffKasOplBundTxt9: TStringField
      FieldName = 'BundTxt9'
      Size = 50
    end
    object ffKasOplBundTxt10: TStringField
      FieldName = 'BundTxt10'
      Size = 50
    end
    object ffKasOplBundCenter5: TBooleanField
      FieldName = 'BundCenter5'
    end
    object ffKasOplBundCenter6: TBooleanField
      FieldName = 'BundCenter6'
    end
    object ffKasOplBundCenter7: TBooleanField
      FieldName = 'BundCenter7'
    end
    object ffKasOplBundCenter8: TBooleanField
      FieldName = 'BundCenter8'
    end
    object ffKasOplBundCenter9: TBooleanField
      FieldName = 'BundCenter9'
    end
    object ffKasOplBundCenter10: TBooleanField
      FieldName = 'BundCenter10'
    end
    object ffKasOplBundBred5: TBooleanField
      FieldName = 'BundBred5'
    end
    object ffKasOplBundBred6: TBooleanField
      FieldName = 'BundBred6'
    end
    object ffKasOplBundBred7: TBooleanField
      FieldName = 'BundBred7'
    end
    object ffKasOplBundBred8: TBooleanField
      FieldName = 'BundBred8'
    end
    object ffKasOplBundBred9: TBooleanField
      FieldName = 'BundBred9'
    end
    object ffKasOplBundBred10: TBooleanField
      FieldName = 'BundBred10'
    end
    object ffKasOplDispTekst1Lin1: TStringField
      FieldName = 'DispTekst1Lin1'
    end
    object ffKasOplDispTekst1Lin2: TStringField
      FieldName = 'DispTekst1Lin2'
    end
    object ffKasOplDispTekst2Lin1: TStringField
      FieldName = 'DispTekst2Lin1'
    end
    object ffKasOplDispTekst2Lin2: TStringField
      FieldName = 'DispTekst2Lin2'
    end
    object ffKasOplDispTekst3Lin1: TStringField
      FieldName = 'DispTekst3Lin1'
    end
    object ffKasOplDispTekst3Lin2: TStringField
      FieldName = 'DispTekst3Lin2'
    end
    object ffKasOplC2QKasseType: TStringField
      FieldName = 'C2QKasseType'
      Size = 10
    end
    object ffKasOplMobilePayPosId: TStringField
      FieldName = 'MobilePayPosId'
      Size = 40
    end
    object ffKasOplMobilePayPosUnitId: TStringField
      FieldName = 'MobilePayPosUnitId'
      Size = 40
    end
    object ffKasOplMobilePayComPort: TStringField
      FieldName = 'MobilePayComPort'
    end
    object ffKasOplMobilePayPosUnitC2Id: TStringField
      FieldName = 'MobilePayPosUnitC2Id'
    end
    object ffKasOplMobilePayOK: TBooleanField
      FieldName = 'MobilePayOK'
    end
  end
  object ffKasEks: TnxTable
    Session = nxSess
    AliasName = 'PRODUKTION'
    TableName = 'KasseEkspeditioner'
    IndexName = 'NrOrden'
    Left = 512
    Top = 68
    object ffKasEksKasseNr: TIntegerField
      FieldName = 'KasseNr'
    end
    object ffKasEksBonNr: TIntegerField
      FieldName = 'BonNr'
    end
    object ffKasEksDato: TDateTimeField
      FieldName = 'Dato'
    end
    object ffKasEksBrugerNr: TWordField
      FieldName = 'BrugerNr'
    end
    object ffKasEksUdlignNr: TIntegerField
      FieldName = 'UdlignNr'
    end
    object ffKasEksType: TStringField
      FieldName = 'Type'
    end
    object ffKasEksAfdeling: TStringField
      FieldName = 'Afdeling'
    end
    object ffKasEksBrutto: TCurrencyField
      FieldName = 'Brutto'
    end
    object ffKasEksRabatBon: TCurrencyField
      FieldName = 'RabatBon'
    end
    object ffKasEksMoms: TCurrencyField
      FieldName = 'Moms'
    end
    object ffKasEksKontant: TCurrencyField
      FieldName = 'Kontant'
    end
    object ffKasEksCheck: TCurrencyField
      FieldName = 'Check'
    end
    object ffKasEksDankort: TCurrencyField
      FieldName = 'Dankort'
    end
    object ffKasEksValuta: TCurrencyField
      FieldName = 'Valuta'
    end
    object ffKasEksAntLin: TWordField
      FieldName = 'AntLin'
    end
    object ffKasEksAntBet: TWordField
      FieldName = 'AntBet'
    end
    object ffKasEksAntBon: TWordField
      FieldName = 'AntBon'
    end
    object ffKasEksRabatLin: TCurrencyField
      FieldName = 'RabatLin'
    end
    object ffKasEksKrKort: TCurrencyField
      FieldName = 'KrKort'
    end
    object ffKasEksKonto: TCurrencyField
      FieldName = 'Konto'
    end
    object ffKasEksKontoNr: TStringField
      FieldName = 'KontoNr'
    end
    object ffKasEksTekst2: TStringField
      FieldName = 'Tekst2'
      Size = 30
    end
    object ffKasEksTekst3: TStringField
      FieldName = 'Tekst3'
      Size = 30
    end
    object ffKasEksTekst4: TStringField
      FieldName = 'Tekst4'
      Size = 30
    end
    object ffKasEksTekst5: TStringField
      FieldName = 'Tekst5'
      Size = 30
    end
    object ffKasEksStatus: TIntegerField
      FieldName = 'Status'
    end
  end
  object nxEksbon: TnxTable
    Session = nxSess
    AliasName = 'Produktion'
    TableName = 'EkspeditionerBon'
    IndexName = 'LbNrOrden'
    Left = 560
    Top = 64
    object nxEksbonLbNr: TLargeintField
      FieldName = 'LbNr'
    end
    object nxEksbonKasseNr: TLargeintField
      FieldName = 'KasseNr'
    end
    object nxEksbonBonNr: TLargeintField
      FieldName = 'BonNr'
    end
  end
  object nxRSEkspeditioner: TnxTable
    TableName = 'RS_Ekspeditioner'
    Left = 144
    Top = 296
  end
  object nxRSEkspLinier: TnxTable
    TableName = 'RS_Eksplinier'
    Left = 256
    Top = 296
  end
  object mtAfdeling: TClientDataSet
    PersistDataPacket.Data = {
      4B0100009619E0BD01000000180000000B0000000000030000004B010E4C6F6B
      6174696F6E4E756D6265720100490000000100055749445448020002000F0013
      53756273744C6F6B6174696F6E4E756D62657201004900000001000557494454
      48020002000F000B5072696E7465724E61766E01004900000001000557494454
      48020002001E000D5072696E746572536B756666650100490000000100055749
      445448020002001E0007504E756D6D6572010049000000010005574944544802
      0002000A000A416664656C696E674E7204000100000000000950617069725479
      70650400010000000000054C61676572040001000000000008557365726E616D
      6501004900000001000557494454480200020032000850617373776F72640100
      4900000001000557494454480200020032000655736572496401004900000001
      000557494454480200020014000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 304
    object mtAfdelingLokationNumber: TStringField
      FieldName = 'LokationNumber'
      Size = 15
    end
    object mtAfdelingSubstLokationNumber: TStringField
      FieldName = 'SubstLokationNumber'
      Size = 15
    end
    object mtAfdelingPrinterNavn: TStringField
      FieldName = 'PrinterNavn'
      Size = 30
    end
    object mtAfdelingPrinterSkuffe: TStringField
      FieldName = 'PrinterSkuffe'
      Size = 30
    end
    object mtAfdelingPNummer: TStringField
      FieldName = 'PNummer'
      Size = 10
    end
    object mtAfdelingAfdelingNr: TIntegerField
      FieldName = 'AfdelingNr'
    end
    object mtAfdelingPapirType: TIntegerField
      FieldName = 'PapirType'
    end
    object mtAfdelingLager: TIntegerField
      FieldName = 'Lager'
    end
    object mtAfdelingUsername: TStringField
      FieldName = 'Username'
      Size = 50
    end
    object mtAfdelingPassword: TStringField
      FieldName = 'Password'
      Size = 50
    end
    object mtAfdelingUserId: TStringField
      FieldName = 'UserId'
    end
  end
  object nxRSEksplinOrd: TnxTable
    Session = nxSess
    TableName = 'RS_Eksplinier'
    IndexName = 'OrdIdOrden'
    Left = 216
    Top = 232
  end
  object cdsRSEksp: TClientDataSet
    PersistDataPacket.Data = {
      E50800009619E0BD020000001800000053000000000003000000E5080E507265
      736372697074696F6E49640100490000000100055749445448020002000F0008
      52656365707449640400010000000000044C624E720400010000000000044461
      746F0800080000000000064F7264416E7404000100000000000853656E646572
      496401004900000001000557494454480200020014000A53656E646572547970
      6501004900000001000557494454480200020014000A53656E6465724E61766E
      01004900000001000557494454480200020032000953656E64657256656A0100
      4900000001000557494454480200020014000C53656E646572506F73744E7201
      004900000001000557494454480200020004000953656E64657254656C010049
      00000001000557494454480200020019000E53656E646572537065634B6F6465
      01004900000001000557494454480200020064000B4973737565724175744E72
      01004900000001000557494454480200020008000B4973737565724350524E72
      0100490000000100055749445448020002000A000B497373756572546974656C
      01004900000001000557494454480200020046000E497373756572537065634B
      6F646501004900000001000557494454480200020003000A4973737565725479
      70650100490000000100055749445448020002000A000C53656E646572537973
      74656D0100490000000100055749445448020002001E00065061744350520100
      490000000100055749445448020002000A000A5061744566744E61766E010049
      00000001000557494454480200020046000A506174466F724E61766E01004900
      000001000557494454480200020046000650617456656A010049000000010005
      5749445448020002002300055061744279010049000000010005574944544802
      000200230009506174506F73744E720100490000000100055749445448020002
      000400075061744C616E64010049000000010005574944544802000200030006
      506174416D74010049000000010005574944544802000200030007506174466F
      65640100490000000100055749445448020002000A00075061744B6F656E0100
      490000000100055749445448020002000A000D4F72647265496E737472756B73
      01004900000001000557494454480200020019000D4C65766572696E6773496E
      666F020049000000010005574944544802000200FF000B4C65766572696E6750
      726901004900000001000557494454480200020032000F4C65766572696E6741
      647265737365020049000000010005574944544802000200FF000E4C65766572
      696E6750736575646F01004900000001000557494454480200020064000E4C65
      766572696E67506F73744E720100490000000100055749445448020002000400
      0F4C65766572696E674B6F6E74616B7401004900000001000557494454480200
      0200960008416664656C696E6704000100000000000C52656365707453746174
      75730400010000000000054C696E65732D000E05000000000852656365707449
      640400010000000000054F726449640100490000000100055749445448020002
      000F00054F72644E720400010000000000044C624E720400010000000000074C
      696E69654E7202000200000000000756657273696F6E01004900000001000557
      49445448020002000F00094F707265744461746F010049000000010005574944
      5448020002001E0007566172656E4E7201004900000001000557494454480200
      02000600044E61766E010049000000010005574944544802000200230004466F
      726D010049000000010005574944544802000200230006537479726B65010049
      0000000100055749445448020002004600094D616769737472656C0200490000
      00010005574944544802000200FF000750616B6E696E67010049000000010005
      574944544802000200460005416E74616C04000100000000000A496D706F7274
      4B6F727401004900000001000557494454480200020046000B496D706F72744C
      616E67740100490000000100055749445448020002004600114B6C617573756C
      626574696E67656C73650100490000000100055749445448020002001E000953
      756273744B6F6465010049000000010005574944544802000200140007446F73
      4B6F6465010049000000010005574944544802000200080008446F7354656B73
      74010049000000010005574944544802000200460009446F73506572696F6401
      0049000000010005574944544802000200230008446F73456E68656401004900
      00000100055749445448020002000A0007496E64436F64650100490000000100
      05574944544802000200110007496E6454657874010049000000010005574944
      54480200020046000C54616B737456657273696F6E0100490000000100055749
      445448020002001E000B497465726174696F6E4E720400010000000000114974
      65726174696F6E496E74657276616C04000100000000000D497465726174696F
      6E547970650100490000000100055749445448020002000A000B537570706C65
      72656E646501004900000001000557494454480200020046000C446F73537461
      72744461746F0100490000000100055749445448020002000A000B446F73536C
      75744461746F0100490000000100055749445448020002000A000A41646D696E
      436F756E7404000100000000000741646D696E49440400010000000000094164
      6D696E446174650100490000000100055749445448020002001E000941706F74
      656B42656D01004900000001000557494454480200020064000D4F7264726549
      6E737472756B73020049000000010005574944544802000200FF000652534C62
      6E7204000100000000000952534C696E69656E7204000100000000001041646D
      696E697374726174696F6E496408000100000000000C46726967697653746174
      757304000100000000000D525351756575655374617475730400010000000000
      16507265736372697074696F6E4964656E74696669657208000100000000000F
      4F726465724964656E7469666965720800010000000000164566666563747561
      74696F6E4964656E746966696572080001000000000006507269766174040001
      000000000000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'PrescriptionId'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'ReceptId'
        DataType = ftInteger
      end
      item
        Name = 'LbNr'
        DataType = ftInteger
      end
      item
        Name = 'Dato'
        DataType = ftDateTime
      end
      item
        Name = 'OrdAnt'
        DataType = ftInteger
      end
      item
        Name = 'SenderId'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'SenderType'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'SenderNavn'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'SenderVej'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'SenderPostNr'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'SenderTel'
        DataType = ftString
        Size = 25
      end
      item
        Name = 'SenderSpecKode'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'IssuerAutNr'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'IssuerCPRNr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'IssuerTitel'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'IssuerSpecKode'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'IssuerType'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SenderSystem'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'PatCPR'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'PatEftNavn'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'PatForNavn'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'PatVej'
        DataType = ftString
        Size = 35
      end
      item
        Name = 'PatBy'
        DataType = ftString
        Size = 35
      end
      item
        Name = 'PatPostNr'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'PatLand'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'PatAmt'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'PatFoed'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'PatKoen'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'OrdreInstruks'
        DataType = ftString
        Size = 25
      end
      item
        Name = 'LeveringsInfo'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'LeveringPri'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'LeveringAdresse'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'LeveringPseudo'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'LeveringPostNr'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'LeveringKontakt'
        DataType = ftString
        Size = 150
      end
      item
        Name = 'Afdeling'
        DataType = ftInteger
      end
      item
        Name = 'ReceptStatus'
        DataType = ftInteger
      end
      item
        Name = 'Lines'
        DataType = ftDataSet
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 112
    Top = 160
    object cdsRSEkspPrescriptionId: TStringField
      FieldName = 'PrescriptionId'
      Size = 15
    end
    object cdsRSEkspReceptId: TIntegerField
      FieldName = 'ReceptId'
    end
    object cdsRSEkspLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object cdsRSEkspDato: TDateTimeField
      FieldName = 'Dato'
    end
    object cdsRSEkspOrdAnt: TIntegerField
      FieldName = 'OrdAnt'
    end
    object cdsRSEkspSenderId: TStringField
      FieldName = 'SenderId'
    end
    object cdsRSEkspSenderType: TStringField
      FieldName = 'SenderType'
    end
    object cdsRSEkspSenderNavn: TStringField
      FieldName = 'SenderNavn'
      Size = 50
    end
    object cdsRSEkspSenderVej: TStringField
      FieldName = 'SenderVej'
    end
    object cdsRSEkspSenderPostNr: TStringField
      FieldName = 'SenderPostNr'
      Size = 4
    end
    object cdsRSEkspSenderTel: TStringField
      FieldName = 'SenderTel'
      Size = 25
    end
    object cdsRSEkspSenderSpecKode: TStringField
      FieldName = 'SenderSpecKode'
      Size = 100
    end
    object cdsRSEkspIssuerAutNr: TStringField
      FieldName = 'IssuerAutNr'
      Size = 8
    end
    object cdsRSEkspIssuerCPRNr: TStringField
      FieldName = 'IssuerCPRNr'
      Size = 10
    end
    object cdsRSEkspIssuerTitel: TStringField
      FieldName = 'IssuerTitel'
      Size = 70
    end
    object cdsRSEkspIssuerSpecKode: TStringField
      FieldName = 'IssuerSpecKode'
      Size = 3
    end
    object cdsRSEkspIssuerType: TStringField
      FieldName = 'IssuerType'
      Size = 10
    end
    object cdsRSEkspSenderSystem: TStringField
      FieldName = 'SenderSystem'
      Size = 30
    end
    object cdsRSEkspPatCPR: TStringField
      FieldName = 'PatCPR'
      Size = 10
    end
    object cdsRSEkspPatEftNavn: TStringField
      FieldName = 'PatEftNavn'
      Size = 70
    end
    object cdsRSEkspPatForNavn: TStringField
      FieldName = 'PatForNavn'
      Size = 70
    end
    object cdsRSEkspPatVej: TStringField
      FieldName = 'PatVej'
      Size = 35
    end
    object cdsRSEkspPatBy: TStringField
      FieldName = 'PatBy'
      Size = 35
    end
    object cdsRSEkspPatPostNr: TStringField
      FieldName = 'PatPostNr'
      Size = 4
    end
    object cdsRSEkspPatLand: TStringField
      FieldName = 'PatLand'
      Size = 3
    end
    object cdsRSEkspPatAmt: TStringField
      FieldName = 'PatAmt'
      Size = 3
    end
    object cdsRSEkspPatFoed: TStringField
      FieldName = 'PatFoed'
      Size = 10
    end
    object cdsRSEkspPatKoen: TStringField
      FieldName = 'PatKoen'
      Size = 10
    end
    object cdsRSEkspOrdreInstruks: TStringField
      FieldName = 'OrdreInstruks'
      Size = 25
    end
    object cdsRSEkspLeveringsInfo: TStringField
      FieldName = 'LeveringsInfo'
      Size = 255
    end
    object cdsRSEkspLeveringPri: TStringField
      FieldName = 'LeveringPri'
      Size = 50
    end
    object cdsRSEkspLeveringAdresse: TStringField
      FieldName = 'LeveringAdresse'
      Size = 255
    end
    object cdsRSEkspLeveringPseudo: TStringField
      FieldName = 'LeveringPseudo'
      Size = 100
    end
    object cdsRSEkspLeveringPostNr: TStringField
      FieldName = 'LeveringPostNr'
      Size = 4
    end
    object cdsRSEkspLeveringKontakt: TStringField
      FieldName = 'LeveringKontakt'
      Size = 150
    end
    object cdsRSEkspAfdeling: TIntegerField
      FieldName = 'Afdeling'
    end
    object cdsRSEkspReceptStatus: TIntegerField
      FieldName = 'ReceptStatus'
    end
    object cdsRSEkspLines: TDataSetField
      FieldName = 'Lines'
    end
  end
  object cdsRSEkspin: TClientDataSet
    Active = True
    Aggregates = <>
    DataSetField = cdsRSEkspLines
    FieldDefs = <
      item
        Name = 'ReceptId'
        DataType = ftInteger
      end
      item
        Name = 'OrdId'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'OrdNr'
        DataType = ftInteger
      end
      item
        Name = 'LbNr'
        DataType = ftInteger
      end
      item
        Name = 'LinieNr'
        DataType = ftWord
      end
      item
        Name = 'Version'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'OpretDato'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'VarenNr'
        DataType = ftString
        Size = 6
      end
      item
        Name = 'Navn'
        DataType = ftString
        Size = 35
      end
      item
        Name = 'Form'
        DataType = ftString
        Size = 35
      end
      item
        Name = 'Styrke'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'Magistrel'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Pakning'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'Antal'
        DataType = ftInteger
      end
      item
        Name = 'ImportKort'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'ImportLangt'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'Klausulbetingelse'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'SubstKode'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DosKode'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'DosTekst'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'DosPeriod'
        DataType = ftString
        Size = 35
      end
      item
        Name = 'DosEnhed'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'IndCode'
        DataType = ftString
        Size = 17
      end
      item
        Name = 'IndText'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'TakstVersion'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'IterationNr'
        DataType = ftInteger
      end
      item
        Name = 'IterationInterval'
        DataType = ftInteger
      end
      item
        Name = 'IterationType'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'Supplerende'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'DosStartDato'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'DosSlutDato'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'AdminCount'
        DataType = ftInteger
      end
      item
        Name = 'AdminID'
        DataType = ftInteger
      end
      item
        Name = 'AdminDate'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'ApotekBem'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'OrdreInstruks'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'RSLbnr'
        DataType = ftInteger
      end
      item
        Name = 'RSLinienr'
        DataType = ftInteger
      end
      item
        Name = 'AdministrationId'
        DataType = ftLargeint
      end
      item
        Name = 'FrigivStatus'
        DataType = ftInteger
      end
      item
        Name = 'RSQueueStatus'
        DataType = ftInteger
      end
      item
        Name = 'PrescriptionIdentifier'
        DataType = ftLargeint
      end
      item
        Name = 'OrderIdentifier'
        DataType = ftLargeint
      end
      item
        Name = 'EffectuationIdentifier'
        DataType = ftLargeint
      end
      item
        Name = 'Privat'
        DataType = ftInteger
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 112
    Top = 208
    object cdsRSEkspinReceptId: TIntegerField
      FieldName = 'ReceptId'
    end
    object cdsRSEkspinOrdId: TStringField
      FieldName = 'OrdId'
      Size = 15
    end
    object cdsRSEkspinOrdNr: TIntegerField
      FieldName = 'OrdNr'
    end
    object cdsRSEkspinLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object cdsRSEkspinLinieNr: TWordField
      FieldName = 'LinieNr'
    end
    object cdsRSEkspinVersion: TStringField
      FieldName = 'Version'
      Size = 15
    end
    object cdsRSEkspinOpretDato: TStringField
      FieldName = 'OpretDato'
      Size = 30
    end
    object cdsRSEkspinVarenNr: TStringField
      FieldName = 'VarenNr'
      Size = 6
    end
    object cdsRSEkspinNavn: TStringField
      FieldName = 'Navn'
      Size = 35
    end
    object cdsRSEkspinForm: TStringField
      FieldName = 'Form'
      Size = 35
    end
    object cdsRSEkspinStyrke: TStringField
      FieldName = 'Styrke'
      Size = 70
    end
    object cdsRSEkspinMagistrel: TStringField
      FieldName = 'Magistrel'
      Size = 255
    end
    object cdsRSEkspinPakning: TStringField
      FieldName = 'Pakning'
      Size = 70
    end
    object cdsRSEkspinAntal: TIntegerField
      FieldName = 'Antal'
    end
    object cdsRSEkspinImportKort: TStringField
      FieldName = 'ImportKort'
      Size = 70
    end
    object cdsRSEkspinImportLangt: TStringField
      FieldName = 'ImportLangt'
      Size = 70
    end
    object cdsRSEkspinKlausulbetingelse: TStringField
      FieldName = 'Klausulbetingelse'
      Size = 30
    end
    object cdsRSEkspinSubstKode: TStringField
      FieldName = 'SubstKode'
    end
    object cdsRSEkspinDosKode: TStringField
      FieldName = 'DosKode'
      Size = 8
    end
    object cdsRSEkspinDosTekst: TStringField
      FieldName = 'DosTekst'
      Size = 70
    end
    object cdsRSEkspinDosPeriod: TStringField
      FieldName = 'DosPeriod'
      Size = 35
    end
    object cdsRSEkspinDosEnhed: TStringField
      FieldName = 'DosEnhed'
      Size = 10
    end
    object cdsRSEkspinIndCode: TStringField
      FieldName = 'IndCode'
      Size = 17
    end
    object cdsRSEkspinIndText: TStringField
      FieldName = 'IndText'
      Size = 70
    end
    object cdsRSEkspinTakstVersion: TStringField
      FieldName = 'TakstVersion'
      Size = 30
    end
    object cdsRSEkspinIterationNr: TIntegerField
      FieldName = 'IterationNr'
    end
    object cdsRSEkspinIterationInterval: TIntegerField
      FieldName = 'IterationInterval'
    end
    object cdsRSEkspinIterationType: TStringField
      FieldName = 'IterationType'
      Size = 10
    end
    object cdsRSEkspinSupplerende: TStringField
      FieldName = 'Supplerende'
      Size = 70
    end
    object cdsRSEkspinDosStartDato: TStringField
      FieldName = 'DosStartDato'
      Size = 10
    end
    object cdsRSEkspinDosSlutDato: TStringField
      FieldName = 'DosSlutDato'
      Size = 10
    end
    object cdsRSEkspinAdminCount: TIntegerField
      FieldName = 'AdminCount'
    end
    object cdsRSEkspinAdminID: TIntegerField
      FieldName = 'AdminID'
    end
    object cdsRSEkspinAdminDate: TStringField
      FieldName = 'AdminDate'
      Size = 30
    end
    object cdsRSEkspinApotekBem: TStringField
      FieldName = 'ApotekBem'
      Size = 100
    end
    object cdsRSEkspinOrdreInstruks: TStringField
      FieldName = 'OrdreInstruks'
      Size = 255
    end
    object cdsRSEkspinRSLbnr: TIntegerField
      FieldName = 'RSLbnr'
    end
    object cdsRSEkspinRSLinienr: TIntegerField
      FieldName = 'RSLinienr'
    end
    object cdsRSEkspinAdministrationId: TLargeintField
      FieldName = 'AdministrationId'
    end
    object cdsRSEkspinFrigivStatus: TIntegerField
      FieldName = 'FrigivStatus'
    end
    object cdsRSEkspinRSQueueStatus: TIntegerField
      FieldName = 'RSQueueStatus'
    end
    object cdsRSEkspinPrescriptionIdentifier: TLargeintField
      FieldName = 'PrescriptionIdentifier'
    end
    object cdsRSEkspinOrderIdentifier: TLargeintField
      FieldName = 'OrderIdentifier'
    end
    object cdsRSEkspinEffectuationIdentifier: TLargeintField
      FieldName = 'EffectuationIdentifier'
    end
    object cdsRSEkspinPrivat: TIntegerField
      FieldName = 'Privat'
    end
  end
  object cdsRSEkspeditioner: TClientDataSet
    PersistDataPacket.Data = {
      A10A00009619E0BD02000000180000005F000000000003000000A10A0E507265
      736372697074696F6E49640100490000000100055749445448020002000F0008
      52656365707449640400010000000000044C624E720400010000000000044461
      746F0800080000000000064F7264416E7404000100000000000853656E646572
      496401004900000001000557494454480200020014000A53656E646572547970
      6501004900000001000557494454480200020014000A53656E6465724E61766E
      01004900000001000557494454480200020032000953656E64657256656A0100
      4900000001000557494454480200020014000C53656E646572506F73744E7201
      004900000001000557494454480200020004000953656E64657254656C010049
      00000001000557494454480200020019000E53656E646572537065634B6F6465
      01004900000001000557494454480200020064000B4973737565724175744E72
      01004900000001000557494454480200020008000B4973737565724350524E72
      0100490000000100055749445448020002000A000B497373756572546974656C
      01004900000001000557494454480200020046000E497373756572537065634B
      6F646501004900000001000557494454480200020003000A4973737565725479
      70650100490000000100055749445448020002000A000C53656E646572537973
      74656D0100490000000100055749445448020002001E00065061744350520100
      490000000100055749445448020002000A000A5061744566744E61766E010049
      00000001000557494454480200020046000A506174466F724E61766E01004900
      000001000557494454480200020046000650617456656A010049000000010005
      5749445448020002002300055061744279010049000000010005574944544802
      000200230009506174506F73744E720100490000000100055749445448020002
      000400075061744C616E64010049000000010005574944544802000200030006
      506174416D74010049000000010005574944544802000200030007506174466F
      65640100490000000100055749445448020002000A00075061744B6F656E0100
      490000000100055749445448020002000A000D4F72647265496E737472756B73
      01004900000001000557494454480200020019000D4C65766572696E6773496E
      666F020049000000010005574944544802000200FF000B4C65766572696E6750
      726901004900000001000557494454480200020032000F4C65766572696E6741
      647265737365020049000000010005574944544802000200FF000E4C65766572
      696E6750736575646F01004900000001000557494454480200020064000E4C65
      766572696E67506F73744E720100490000000100055749445448020002000400
      0F4C65766572696E674B6F6E74616B7401004900000001000557494454480200
      0200960008416664656C696E6704000100000000000C52656365707453746174
      7573040001000000000013506174506572736F6E4964656E7469666965720100
      49000000010005574944544802000200320019506174506572736F6E4964656E
      746966696572536F757263650200020000000000195061744F7267616E697361
      74696F6E4964656E746966696572010049000000010005574944544802000200
      C8001F5061744F7267616E69736174696F6E4964656E746966696572536F7572
      63650200020000000000054C696E657335000E05000000000852656365707449
      640400010000000000054F726449640100490000000100055749445448020002
      000F00054F72644E720400010000000000044C624E720400010000000000074C
      696E69654E7202000200000000000756657273696F6E01004900000001000557
      49445448020002000F00094F707265744461746F010049000000010005574944
      5448020002001E0007566172656E4E7201004900000001000557494454480200
      02000600044E61766E010049000000010005574944544802000200230004466F
      726D010049000000010005574944544802000200230006537479726B65010049
      0000000100055749445448020002004600094D616769737472656C0200490000
      00010005574944544802000200FF000750616B6E696E67010049000000010005
      574944544802000200460005416E74616C04000100000000000A496D706F7274
      4B6F727401004900000001000557494454480200020046000B496D706F72744C
      616E67740100490000000100055749445448020002004600114B6C617573756C
      626574696E67656C73650100490000000100055749445448020002001E000953
      756273744B6F6465010049000000010005574944544802000200140007446F73
      4B6F6465010049000000010005574944544802000200080008446F7354656B73
      74010049000000010005574944544802000200460009446F73506572696F6401
      0049000000010005574944544802000200230008446F73456E68656401004900
      00000100055749445448020002000A0007496E64436F64650100490000000100
      05574944544802000200110007496E6454657874010049000000010005574944
      54480200020046000C54616B737456657273696F6E0100490000000100055749
      445448020002001E000B497465726174696F6E4E720400010000000000114974
      65726174696F6E496E74657276616C04000100000000000D497465726174696F
      6E547970650100490000000100055749445448020002000A000B537570706C65
      72656E646501004900000001000557494454480200020046000C446F73537461
      72744461746F0100490000000100055749445448020002000A000B446F73536C
      75744461746F0100490000000100055749445448020002000A000A41646D696E
      436F756E7404000100000000000741646D696E49440400010000000000094164
      6D696E446174650100490000000100055749445448020002001E000941706F74
      656B42656D01004900000001000557494454480200020064000D4F7264726549
      6E737472756B73020049000000010005574944544802000200FF000652534C62
      6E7204000100000000000952534C696E69656E7204000100000000001041646D
      696E697374726174696F6E496408000100000000000C46726967697653746174
      757304000100000000000D525351756575655374617475730400010000000000
      16507265736372697074696F6E4964656E74696669657208000100000000000F
      4F726465724964656E7469666965720800010000000000164566666563747561
      74696F6E4964656E746966696572080001000000000006507269766174040001
      00000000000D42657374696C7441664E61766E01004900000001000557494454
      480200020064000E42657374696C7441664175744E7201004900000001000557
      494454480200020008001042657374696C7441664F72674E61766E0100490000
      0001000557494454480200020064001042657374696C74416641647265737365
      020049000000010005574944544802000200FF001042657374696C7441665465
      6C65666F6E01004900000001000557494454480200020019000F42657374696C
      744166506F73744E720100490000000100055749445448020002000A000B4265
      7374696C744166496401004900000001000557494454480200020014000F4265
      7374696C74416649645479706501004900000001000557494454480200020019
      0000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'PrescriptionId'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'ReceptId'
        DataType = ftInteger
      end
      item
        Name = 'LbNr'
        DataType = ftInteger
      end
      item
        Name = 'Dato'
        DataType = ftDateTime
      end
      item
        Name = 'OrdAnt'
        DataType = ftInteger
      end
      item
        Name = 'SenderId'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'SenderType'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'SenderNavn'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'SenderVej'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'SenderPostNr'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'SenderTel'
        DataType = ftString
        Size = 25
      end
      item
        Name = 'SenderSpecKode'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'IssuerAutNr'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'IssuerCPRNr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'IssuerTitel'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'IssuerSpecKode'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'IssuerType'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SenderSystem'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'PatCPR'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'PatEftNavn'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'PatForNavn'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'PatVej'
        DataType = ftString
        Size = 35
      end
      item
        Name = 'PatBy'
        DataType = ftString
        Size = 35
      end
      item
        Name = 'PatPostNr'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'PatLand'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'PatAmt'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'PatFoed'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'PatKoen'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'OrdreInstruks'
        DataType = ftString
        Size = 25
      end
      item
        Name = 'LeveringsInfo'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'LeveringPri'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'LeveringAdresse'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'LeveringPseudo'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'LeveringPostNr'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'LeveringKontakt'
        DataType = ftString
        Size = 150
      end
      item
        Name = 'Afdeling'
        DataType = ftInteger
      end
      item
        Name = 'ReceptStatus'
        DataType = ftInteger
      end
      item
        Name = 'PatPersonIdentifier'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'PatPersonIdentifierSource'
        DataType = ftWord
      end
      item
        Name = 'PatOrganisationIdentifier'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'PatOrganisationIdentifierSource'
        DataType = ftWord
      end
      item
        Name = 'Lines'
        DataType = ftDataSet
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 112
    Top = 40
    object cdsRSEkspeditionerPrescriptionId: TStringField
      FieldName = 'PrescriptionId'
      Size = 15
    end
    object cdsRSEkspeditionerReceptId: TIntegerField
      FieldName = 'ReceptId'
    end
    object cdsRSEkspeditionerLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object cdsRSEkspeditionerDato: TDateTimeField
      FieldName = 'Dato'
    end
    object cdsRSEkspeditionerOrdAnt: TIntegerField
      FieldName = 'OrdAnt'
    end
    object cdsRSEkspeditionerSenderId: TStringField
      FieldName = 'SenderId'
    end
    object cdsRSEkspeditionerSenderType: TStringField
      FieldName = 'SenderType'
    end
    object cdsRSEkspeditionerSenderNavn: TStringField
      FieldName = 'SenderNavn'
      Size = 50
    end
    object cdsRSEkspeditionerSenderVej: TStringField
      FieldName = 'SenderVej'
    end
    object cdsRSEkspeditionerSenderPostNr: TStringField
      FieldName = 'SenderPostNr'
      Size = 4
    end
    object cdsRSEkspeditionerSenderTel: TStringField
      FieldName = 'SenderTel'
      Size = 25
    end
    object cdsRSEkspeditionerSenderSpecKode: TStringField
      FieldName = 'SenderSpecKode'
      Size = 100
    end
    object cdsRSEkspeditionerIssuerAutNr: TStringField
      FieldName = 'IssuerAutNr'
      Size = 8
    end
    object cdsRSEkspeditionerIssuerCPRNr: TStringField
      FieldName = 'IssuerCPRNr'
      Size = 10
    end
    object cdsRSEkspeditionerIssuerTitel: TStringField
      FieldName = 'IssuerTitel'
      Size = 70
    end
    object cdsRSEkspeditionerIssuerSpecKode: TStringField
      FieldName = 'IssuerSpecKode'
      Size = 3
    end
    object cdsRSEkspeditionerIssuerType: TStringField
      FieldName = 'IssuerType'
      Size = 10
    end
    object cdsRSEkspeditionerSenderSystem: TStringField
      FieldName = 'SenderSystem'
      Size = 30
    end
    object cdsRSEkspeditionerPatCPR: TStringField
      FieldName = 'PatCPR'
      Size = 10
    end
    object cdsRSEkspeditionerPatEftNavn: TStringField
      FieldName = 'PatEftNavn'
      Size = 70
    end
    object cdsRSEkspeditionerPatForNavn: TStringField
      FieldName = 'PatForNavn'
      Size = 70
    end
    object cdsRSEkspeditionerPatVej: TStringField
      FieldName = 'PatVej'
      Size = 35
    end
    object cdsRSEkspeditionerPatBy: TStringField
      FieldName = 'PatBy'
      Size = 35
    end
    object cdsRSEkspeditionerPatPostNr: TStringField
      FieldName = 'PatPostNr'
      Size = 4
    end
    object cdsRSEkspeditionerPatLand: TStringField
      FieldName = 'PatLand'
      Size = 3
    end
    object cdsRSEkspeditionerPatAmt: TStringField
      FieldName = 'PatAmt'
      Size = 3
    end
    object cdsRSEkspeditionerPatFoed: TStringField
      FieldName = 'PatFoed'
      Size = 10
    end
    object cdsRSEkspeditionerPatKoen: TStringField
      FieldName = 'PatKoen'
      Size = 10
    end
    object cdsRSEkspeditionerOrdreInstruks: TStringField
      FieldName = 'OrdreInstruks'
      Size = 25
    end
    object cdsRSEkspeditionerLeveringsInfo: TStringField
      FieldName = 'LeveringsInfo'
      Size = 255
    end
    object cdsRSEkspeditionerLeveringPri: TStringField
      FieldName = 'LeveringPri'
      Size = 50
    end
    object cdsRSEkspeditionerLeveringAdresse: TStringField
      FieldName = 'LeveringAdresse'
      Size = 255
    end
    object cdsRSEkspeditionerLeveringPseudo: TStringField
      FieldName = 'LeveringPseudo'
      Size = 100
    end
    object cdsRSEkspeditionerLeveringPostNr: TStringField
      FieldName = 'LeveringPostNr'
      Size = 4
    end
    object cdsRSEkspeditionerLeveringKontakt: TStringField
      FieldName = 'LeveringKontakt'
      Size = 150
    end
    object cdsRSEkspeditionerAfdeling: TIntegerField
      FieldName = 'Afdeling'
    end
    object cdsRSEkspeditionerReceptStatus: TIntegerField
      FieldName = 'ReceptStatus'
    end
    object cdsRSEkspeditionerPatPersonIdentifier: TStringField
      FieldName = 'PatPersonIdentifier'
      Size = 50
    end
    object cdsRSEkspeditionerPatPersonIdentifierSource: TWordField
      FieldName = 'PatPersonIdentifierSource'
    end
    object cdsRSEkspeditionerPatOrganisationIdentifier: TStringField
      FieldName = 'PatOrganisationIdentifier'
      Size = 200
    end
    object cdsRSEkspeditionerPatOrganisationIdentifierSource: TWordField
      FieldName = 'PatOrganisationIdentifierSource'
    end
    object cdsRSEkspeditionerLines: TDataSetField
      FieldName = 'Lines'
    end
  end
  object cdsRSEksplinier: TClientDataSet
    Active = True
    Aggregates = <>
    DataSetField = cdsRSEkspeditionerLines
    FieldDefs = <
      item
        Name = 'ReceptId'
        DataType = ftInteger
      end
      item
        Name = 'OrdId'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'OrdNr'
        DataType = ftInteger
      end
      item
        Name = 'LbNr'
        DataType = ftInteger
      end
      item
        Name = 'LinieNr'
        DataType = ftWord
      end
      item
        Name = 'Version'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'OpretDato'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'VarenNr'
        DataType = ftString
        Size = 6
      end
      item
        Name = 'Navn'
        DataType = ftString
        Size = 35
      end
      item
        Name = 'Form'
        DataType = ftString
        Size = 35
      end
      item
        Name = 'Styrke'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'Magistrel'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'Pakning'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'Antal'
        DataType = ftInteger
      end
      item
        Name = 'ImportKort'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'ImportLangt'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'Klausulbetingelse'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'SubstKode'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DosKode'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'DosTekst'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'DosPeriod'
        DataType = ftString
        Size = 35
      end
      item
        Name = 'DosEnhed'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'IndCode'
        DataType = ftString
        Size = 17
      end
      item
        Name = 'IndText'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'TakstVersion'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'IterationNr'
        DataType = ftInteger
      end
      item
        Name = 'IterationInterval'
        DataType = ftInteger
      end
      item
        Name = 'IterationType'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'Supplerende'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'DosStartDato'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'DosSlutDato'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'AdminCount'
        DataType = ftInteger
      end
      item
        Name = 'AdminID'
        DataType = ftInteger
      end
      item
        Name = 'AdminDate'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'ApotekBem'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'OrdreInstruks'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'RSLbnr'
        DataType = ftInteger
      end
      item
        Name = 'RSLinienr'
        DataType = ftInteger
      end
      item
        Name = 'AdministrationId'
        DataType = ftLargeint
      end
      item
        Name = 'FrigivStatus'
        DataType = ftInteger
      end
      item
        Name = 'RSQueueStatus'
        DataType = ftInteger
      end
      item
        Name = 'PrescriptionIdentifier'
        DataType = ftLargeint
      end
      item
        Name = 'OrderIdentifier'
        DataType = ftLargeint
      end
      item
        Name = 'EffectuationIdentifier'
        DataType = ftLargeint
      end
      item
        Name = 'Privat'
        DataType = ftInteger
      end
      item
        Name = 'BestiltAfNavn'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'BestiltAfAutNr'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'BestiltAfOrgNavn'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'BestiltAfAdresse'
        DataType = ftString
        Size = 255
      end
      item
        Name = 'BestiltAfTelefon'
        DataType = ftString
        Size = 25
      end
      item
        Name = 'BestiltAfPostNr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'BestiltAfId'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'BestiltAfIdType'
        DataType = ftString
        Size = 25
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 112
    Top = 88
    object cdsRSEksplinierReceptId: TIntegerField
      FieldName = 'ReceptId'
    end
    object cdsRSEksplinierOrdId: TStringField
      FieldName = 'OrdId'
      Size = 15
    end
    object cdsRSEksplinierOrdNr: TIntegerField
      FieldName = 'OrdNr'
    end
    object cdsRSEksplinierLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object cdsRSEksplinierLinieNr: TWordField
      FieldName = 'LinieNr'
    end
    object cdsRSEksplinierVersion: TStringField
      FieldName = 'Version'
      Size = 15
    end
    object cdsRSEksplinierOpretDato: TStringField
      FieldName = 'OpretDato'
      Size = 30
    end
    object cdsRSEksplinierVarenNr: TStringField
      FieldName = 'VarenNr'
      Size = 6
    end
    object cdsRSEksplinierNavn: TStringField
      FieldName = 'Navn'
      Size = 35
    end
    object cdsRSEksplinierForm: TStringField
      FieldName = 'Form'
      Size = 35
    end
    object cdsRSEksplinierStyrke: TStringField
      FieldName = 'Styrke'
      Size = 70
    end
    object cdsRSEksplinierMagistrel: TStringField
      FieldName = 'Magistrel'
      Size = 255
    end
    object cdsRSEksplinierPakning: TStringField
      FieldName = 'Pakning'
      Size = 70
    end
    object cdsRSEksplinierAntal: TIntegerField
      FieldName = 'Antal'
    end
    object cdsRSEksplinierImportKort: TStringField
      FieldName = 'ImportKort'
      Size = 70
    end
    object cdsRSEksplinierImportLangt: TStringField
      FieldName = 'ImportLangt'
      Size = 70
    end
    object cdsRSEksplinierKlausulbetingelse: TStringField
      FieldName = 'Klausulbetingelse'
      Size = 30
    end
    object cdsRSEksplinierSubstKode: TStringField
      FieldName = 'SubstKode'
    end
    object cdsRSEksplinierDosKode: TStringField
      FieldName = 'DosKode'
      Size = 8
    end
    object cdsRSEksplinierDosTekst: TStringField
      FieldName = 'DosTekst'
      Size = 70
    end
    object cdsRSEksplinierDosPeriod: TStringField
      FieldName = 'DosPeriod'
      Size = 35
    end
    object cdsRSEksplinierDosEnhed: TStringField
      FieldName = 'DosEnhed'
      Size = 10
    end
    object cdsRSEksplinierIndCode: TStringField
      FieldName = 'IndCode'
      Size = 17
    end
    object cdsRSEksplinierIndText: TStringField
      FieldName = 'IndText'
      Size = 70
    end
    object cdsRSEksplinierTakstVersion: TStringField
      FieldName = 'TakstVersion'
      Size = 30
    end
    object cdsRSEksplinierIterationNr: TIntegerField
      FieldName = 'IterationNr'
    end
    object cdsRSEksplinierIterationInterval: TIntegerField
      FieldName = 'IterationInterval'
    end
    object cdsRSEksplinierIterationType: TStringField
      FieldName = 'IterationType'
      Size = 10
    end
    object cdsRSEksplinierSupplerende: TStringField
      FieldName = 'Supplerende'
      Size = 70
    end
    object cdsRSEksplinierDosStartDato: TStringField
      FieldName = 'DosStartDato'
      Size = 10
    end
    object cdsRSEksplinierDosSlutDato: TStringField
      FieldName = 'DosSlutDato'
      Size = 10
    end
    object cdsRSEksplinierAdminCount: TIntegerField
      FieldName = 'AdminCount'
    end
    object cdsRSEksplinierAdminID: TIntegerField
      FieldName = 'AdminID'
    end
    object cdsRSEksplinierAdminDate: TStringField
      FieldName = 'AdminDate'
      Size = 30
    end
    object cdsRSEksplinierApotekBem: TStringField
      FieldName = 'ApotekBem'
      Size = 100
    end
    object cdsRSEksplinierOrdreInstruks: TStringField
      FieldName = 'OrdreInstruks'
      Size = 255
    end
    object cdsRSEksplinierRSLbnr: TIntegerField
      FieldName = 'RSLbnr'
    end
    object cdsRSEksplinierRSLinienr: TIntegerField
      FieldName = 'RSLinienr'
    end
    object cdsRSEksplinierAdministrationId: TLargeintField
      FieldName = 'AdministrationId'
    end
    object cdsRSEksplinierFrigivStatus: TIntegerField
      FieldName = 'FrigivStatus'
    end
    object cdsRSEksplinierRSQueueStatus: TIntegerField
      FieldName = 'RSQueueStatus'
    end
    object cdsRSEksplinierPrescriptionIdentifier: TLargeintField
      FieldName = 'PrescriptionIdentifier'
    end
    object cdsRSEksplinierOrderIdentifier: TLargeintField
      FieldName = 'OrderIdentifier'
    end
    object cdsRSEksplinierEffectuationIdentifier: TLargeintField
      FieldName = 'EffectuationIdentifier'
    end
    object cdsRSEksplinierPrivat: TIntegerField
      FieldName = 'Privat'
    end
    object cdsRSEksplinierBestiltAfNavn: TStringField
      FieldName = 'BestiltAfNavn'
      Size = 100
    end
    object cdsRSEksplinierBestiltAfAutNr: TStringField
      FieldName = 'BestiltAfAutNr'
      Size = 8
    end
    object cdsRSEksplinierBestiltAfOrgNavn: TStringField
      FieldName = 'BestiltAfOrgNavn'
      Size = 100
    end
    object cdsRSEksplinierBestiltAfAdresse: TStringField
      FieldName = 'BestiltAfAdresse'
      Size = 255
    end
    object cdsRSEksplinierBestiltAfTelefon: TStringField
      FieldName = 'BestiltAfTelefon'
      Size = 25
    end
    object cdsRSEksplinierBestiltAfPostNr: TStringField
      FieldName = 'BestiltAfPostNr'
      Size = 10
    end
    object cdsRSEksplinierBestiltAfId: TStringField
      FieldName = 'BestiltAfId'
    end
    object cdsRSEksplinierBestiltAfIdType: TStringField
      FieldName = 'BestiltAfIdType'
      Size = 25
    end
  end
  object timChkCert: TTimer
    Interval = 15000
    OnTimer = timChkCertTimer
    Left = 416
    Top = 24
  end
  object nqKoel: TnxQuery
    Left = 224
    Top = 424
  end
  object cdsOrdHeader: TClientDataSet
    PersistDataPacket.Data = {
      DA0500009619E0BD02000000180000003B000000000003000000DA05044C626E
      720400010000000000054C696E65731C000E050000000006566172656E720100
      490000000100055749445448020002001400044E61766E010049000000010005
      5749445448020002003200044469737001004900000001000557494454480200
      02001400045374726B0100490000000100055749445448020002001400045061
      6B6E010049000000010005574944544802000200140005537562737401004900
      00000100055749445448020002001E0005416E74616C04000100000000000554
      696C736B010049000000010005574944544802000200140007496E644B6F6465
      010049000000010005574944544802000200140006496E645478740100490000
      0001000557494454480200020046000555646C6576040001000000000006466F
      7268646C010049000000010005574944544802000200140007446F734B6F6465
      010049000000010005574944544802000200140006446F735478740100490000
      0001000557494454480200020064000A50454D41646D446F6E65040001000000
      0000054F72646964010049000000010005574944544802000200140008526563
      65707469640400010000000000114B6C617573756C426574696E67656C736502
      00030000000000044C626E720400010000000000085573657250726973080004
      000000010007535542545950450200490006004D6F6E65790009537562566172
      656E720100490000000100055749445448020002000A000F4F7264696E657265
      74566172656E720100490000000100055749445448020002000A000E4F726469
      6E65726574416E74616C04000100000000000D55647374656465724175746964
      01004900000001000557494454480200020005000A5564737465646572496401
      0049000000010005574944544802000200C8000C556473746564657254797065
      0400010000000000064472756769640100490000000100055749445448020002
      000B00094F706265764B6F646501004900000001000557494454480200020001
      00000008416E6E756C6C657202000300000000000750614370724E7201004900
      000001000557494454480200020014000550614E766E01004900000001000557
      49445448020002001E0007466F724E61766E0100490000000100055749445448
      020002001E000341647201004900000001000557494454480200020032000441
      647232010049000000010005574944544802000200320006506F73744E720100
      490000000100055749445448020002000A000242790100490000000100055749
      44544802000200140003416D740100490000000100055749445448020002000A
      0003546C66010049000000010005574944544802000200140005416C64657201
      00490000000100055749445448020002001400044261726E0100490000000100
      0557494454480200020014000754696C736B7564010049000000010005574944
      54480200020014000754696C4272756701004900000001000557494454480200
      02001400084C65766572696E6701004900000001000557494454480200020032
      000646726954787401004900000001000557494454480200020032000459644E
      720100490000000100055749445448020002000A0009596465724370724E7201
      004900000001000557494454480200020014000659644E61766E010049000000
      0100055749445448020002001E00065964537065630100490000000100055749
      445448020002003200064F7264416E740400010000000000074C6576696E666F
      0100490000000100055749445448020002003200034150340200030000000000
      0744616E6D61726B0200030000000000074B6F6E746F6E720100490000000100
      0557494454480200020014000A53656E64657254797065010049000000010005
      57494454480200020014000A53656E6465724E61766E01004900000001000557
      494454480200020032000B497373756572546974656C01004900000001000557
      49445448020002004600094F726472654461746F08000800000000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Lbnr'
        DataType = ftInteger
      end
      item
        Name = 'Lines'
        DataType = ftDataSet
      end
      item
        Name = 'Annuller'
        DataType = ftBoolean
      end
      item
        Name = 'PaCprNr'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'PaNvn'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'ForNavn'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Adr'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Adr2'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'PostNr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'By'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Amt'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'Tlf'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Alder'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Barn'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Tilskud'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'TilBrug'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Levering'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'FriTxt'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'YdNr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'YderCprNr'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'YdNavn'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'YdSpec'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'OrdAnt'
        DataType = ftInteger
      end
      item
        Name = 'Levinfo'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'AP4'
        DataType = ftBoolean
      end
      item
        Name = 'Danmark'
        DataType = ftBoolean
      end
      item
        Name = 'Kontonr'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'SenderType'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'SenderNavn'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'IssuerTitel'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'OrdreDato'
        DataType = ftDateTime
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 784
    Top = 72
    object cdsOrdHeaderLbnr: TIntegerField
      FieldName = 'Lbnr'
    end
    object cdsOrdHeaderLines: TDataSetField
      FieldName = 'Lines'
    end
    object cdsOrdHeaderAnnuller: TBooleanField
      FieldName = 'Annuller'
    end
    object cdsOrdHeaderPaCprNr: TStringField
      FieldName = 'PaCprNr'
    end
    object cdsOrdHeaderPaNvn: TStringField
      FieldName = 'PaNvn'
      Size = 30
    end
    object cdsOrdHeaderForNavn: TStringField
      FieldName = 'ForNavn'
      Size = 30
    end
    object cdsOrdHeaderAdr: TStringField
      FieldName = 'Adr'
      Size = 50
    end
    object cdsOrdHeaderAdr2: TStringField
      FieldName = 'Adr2'
      Size = 50
    end
    object cdsOrdHeaderPostNr: TStringField
      FieldName = 'PostNr'
      Size = 10
    end
    object cdsOrdHeaderBy: TStringField
      FieldName = 'By'
    end
    object cdsOrdHeaderAmt: TStringField
      FieldName = 'Amt'
      Size = 10
    end
    object cdsOrdHeaderTlf: TStringField
      FieldName = 'Tlf'
    end
    object cdsOrdHeaderAlder: TStringField
      FieldName = 'Alder'
    end
    object cdsOrdHeaderBarn: TStringField
      FieldName = 'Barn'
    end
    object cdsOrdHeaderTilskud: TStringField
      FieldName = 'Tilskud'
    end
    object cdsOrdHeaderTilBrug: TStringField
      FieldName = 'TilBrug'
    end
    object cdsOrdHeaderLevering: TStringField
      FieldName = 'Levering'
      Size = 50
    end
    object cdsOrdHeaderFriTxt: TStringField
      FieldName = 'FriTxt'
      Size = 50
    end
    object cdsOrdHeaderYdNr: TStringField
      FieldName = 'YdNr'
      Size = 10
    end
    object cdsOrdHeaderYderCprNr: TStringField
      FieldName = 'YderCprNr'
    end
    object cdsOrdHeaderYdNavn: TStringField
      FieldName = 'YdNavn'
      Size = 30
    end
    object cdsOrdHeaderYdSpec: TStringField
      FieldName = 'YdSpec'
      Size = 50
    end
    object cdsOrdHeaderOrdAnt: TIntegerField
      FieldName = 'OrdAnt'
    end
    object cdsOrdHeaderLevinfo: TStringField
      FieldName = 'Levinfo'
      Size = 50
    end
    object cdsOrdHeaderAP4: TBooleanField
      FieldName = 'AP4'
    end
    object cdsOrdHeaderDanmark: TBooleanField
      FieldName = 'Danmark'
    end
    object cdsOrdHeaderKontonr: TStringField
      FieldName = 'Kontonr'
    end
    object cdsOrdHeaderSenderType: TStringField
      FieldName = 'SenderType'
    end
    object cdsOrdHeaderSenderNavn: TStringField
      FieldName = 'SenderNavn'
      Size = 50
    end
    object cdsOrdHeaderIssuerTitel: TStringField
      FieldName = 'IssuerTitel'
      Size = 70
    end
    object cdsOrdHeaderOrdreDato: TDateTimeField
      FieldName = 'OrdreDato'
    end
  end
  object cdsOrdLinier: TClientDataSet
    Active = True
    Aggregates = <>
    DataSetField = cdsOrdHeaderLines
    FieldDefs = <
      item
        Name = 'Varenr'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Navn'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Disp'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Strk'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Pakn'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Subst'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Antal'
        DataType = ftInteger
      end
      item
        Name = 'Tilsk'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'IndKode'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'IndTxt'
        DataType = ftString
        Size = 70
      end
      item
        Name = 'Udlev'
        DataType = ftInteger
      end
      item
        Name = 'Forhdl'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DosKode'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DosTxt'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'PEMAdmDone'
        DataType = ftInteger
      end
      item
        Name = 'Ordid'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Receptid'
        DataType = ftInteger
      end
      item
        Name = 'KlausulBetingelse'
        DataType = ftBoolean
      end
      item
        Name = 'Lbnr'
        DataType = ftInteger
      end
      item
        Name = 'UserPris'
        DataType = ftCurrency
      end
      item
        Name = 'SubVarenr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'OrdineretVarenr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'OrdineretAntal'
        DataType = ftInteger
      end
      item
        Name = 'UdstederAutid'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'UdstederId'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'UdstederType'
        DataType = ftInteger
      end
      item
        Name = 'Drugid'
        DataType = ftString
        Size = 11
      end
      item
        Name = 'OpbevKode'
        DataType = ftString
        Size = 1
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 848
    Top = 72
    object cdsOrdLinierVarenr: TStringField
      FieldName = 'Varenr'
    end
    object cdsOrdLinierNavn: TStringField
      FieldName = 'Navn'
      Size = 50
    end
    object cdsOrdLinierDisp: TStringField
      FieldName = 'Disp'
    end
    object cdsOrdLinierStrk: TStringField
      FieldName = 'Strk'
    end
    object cdsOrdLinierPakn: TStringField
      FieldName = 'Pakn'
    end
    object cdsOrdLinierSubst: TStringField
      FieldName = 'Subst'
      Size = 30
    end
    object cdsOrdLinierAntal: TIntegerField
      FieldName = 'Antal'
    end
    object cdsOrdLinierTilsk: TStringField
      FieldName = 'Tilsk'
    end
    object cdsOrdLinierIndKode: TStringField
      FieldName = 'IndKode'
    end
    object cdsOrdLinierIndTxt: TStringField
      FieldName = 'IndTxt'
      Size = 70
    end
    object cdsOrdLinierUdlev: TIntegerField
      FieldName = 'Udlev'
    end
    object cdsOrdLinierForhdl: TStringField
      FieldName = 'Forhdl'
    end
    object cdsOrdLinierDosKode: TStringField
      FieldName = 'DosKode'
    end
    object cdsOrdLinierDosTxt: TStringField
      FieldName = 'DosTxt'
      Size = 100
    end
    object cdsOrdLinierPEMAdmDone: TIntegerField
      FieldName = 'PEMAdmDone'
    end
    object cdsOrdLinierOrdid: TStringField
      FieldName = 'Ordid'
    end
    object cdsOrdLinierReceptid: TIntegerField
      FieldName = 'Receptid'
    end
    object cdsOrdLinierKlausulBetingelse: TBooleanField
      FieldName = 'KlausulBetingelse'
    end
    object cdsOrdLinierLbnr: TIntegerField
      FieldName = 'Lbnr'
    end
    object cdsOrdLinierUserPris: TCurrencyField
      FieldName = 'UserPris'
    end
    object cdsOrdLinierSubVarenr: TStringField
      FieldName = 'SubVarenr'
      Size = 10
    end
    object cdsOrdLinierOrdineretVarenr: TStringField
      FieldName = 'OrdineretVarenr'
      Size = 10
    end
    object cdsOrdLinierOrdineretAntal: TIntegerField
      FieldName = 'OrdineretAntal'
    end
    object cdsOrdLinierUdstederAutid: TStringField
      FieldName = 'UdstederAutid'
      Size = 5
    end
    object cdsOrdLinierUdstederId: TStringField
      FieldName = 'UdstederId'
      Size = 200
    end
    object cdsOrdLinierUdstederType: TIntegerField
      FieldName = 'UdstederType'
    end
    object cdsOrdLinierDrugid: TStringField
      FieldName = 'Drugid'
      Size = 11
    end
    object cdsOrdLinierOpbevKode: TStringField
      FieldName = 'OpbevKode'
      Size = 1
    end
  end
  object mtEks: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'KundeNr'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'KundeType'
        DataType = ftWord
      end
      item
        Name = 'CtrType'
        DataType = ftWord
      end
      item
        Name = 'NarkoNr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'OrdreStatus'
        DataType = ftWord
      end
      item
        Name = 'OrdreType'
        DataType = ftWord
      end
      item
        Name = 'ReceptStatus'
        DataType = ftWord
      end
      item
        Name = 'EkspType'
        DataType = ftWord
      end
      item
        Name = 'EkspForm'
        DataType = ftWord
      end
      item
        Name = 'AntLin'
        DataType = ftWord
      end
      item
        Name = 'LevNr'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'LevNavn'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'YderNr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'YderCprNr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'YderNavn'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'DebitorNr'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'DebitorNavn'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'DebitorGrp'
        DataType = ftWord
      end
      item
        Name = 'Afdeling'
        DataType = ftWord
      end
      item
        Name = 'Lager'
        DataType = ftWord
      end
      item
        Name = 'LeveringsForm'
        DataType = ftWord
      end
      item
        Name = 'GlCtrSaldo'
        DataType = ftCurrency
      end
      item
        Name = 'NyCtrSaldo'
        DataType = ftCurrency
      end
      item
        Name = 'CtrUdlign'
        DataType = ftCurrency
      end
      item
        Name = 'YdCprChk'
        DataType = ftBoolean
      end
      item
        Name = 'NettoPriser'
        DataType = ftBoolean
      end
      item
        Name = 'UdbrGebyr'
        DataType = ftCurrency
      end
      item
        Name = 'AvancePct'
        DataType = ftCurrency
      end
      item
        Name = 'CtrUdlFor'
        DataType = ftCurrency
      end
      item
        Name = 'CtrUdlignType'
        DataType = ftWord
      end
      item
        Name = 'CtrUdlignDato'
        DataType = ftDateTime
      end
      item
        Name = 'PakkeNr'
        DataType = ftInteger
      end
      item
        Name = 'TurNr'
        DataType = ftInteger
      end
      item
        Name = 'DebProcent'
        DataType = ftCurrency
      end
      item
        Name = 'DosKortNr'
        DataType = ftInteger
      end
      item
        Name = 'Kontakt'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'GlCtrSaldoB'
        DataType = ftCurrency
      end
      item
        Name = 'NyCtrSaldoB'
        DataType = ftCurrency
      end
      item
        Name = 'CtrUdlForB'
        DataType = ftCurrency
      end
      item
        Name = 'CtrUdlignTypeB'
        DataType = ftWord
      end
      item
        Name = 'CtrUdlignDatoB'
        DataType = ftDateTime
      end
      item
        Name = 'CtrUdlignB'
        DataType = ftCurrency
      end
      item
        Name = 'KundeNavn'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'LmsModtager'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'OrdreDato'
        DataType = ftDateTime
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 160
    Top = 120
    object mtEksKundeNr: TStringField
      FieldName = 'KundeNr'
    end
    object mtEksKundeType: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Kundetype'
      DisplayWidth = 15
      FieldName = 'KundeType'
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      OnGetText = KundeTypeGetText
      OnSetText = KundeTypeSetText
    end
    object mtEksCtrType: TWordField
      Alignment = taLeftJustify
      FieldName = 'CtrType'
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      OnGetText = CtrTypeGetText
      OnSetText = CtrTypeSetText
    end
    object mtEksNarkoNr: TStringField
      FieldName = 'NarkoNr'
      Size = 10
    end
    object mtEksOrdreStatus: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Status'
      FieldName = 'OrdreStatus'
      OnGetText = OrdreStatusGetText
      OnSetText = OrdreStatusSetText
    end
    object mtEksOrdreType: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Type'
      DisplayWidth = 5
      FieldName = 'OrdreType'
      OnGetText = OrdreTypeGetText
      OnSetText = OrdreTypeSetText
    end
    object mtEksReceptStatus: TWordField
      Alignment = taLeftJustify
      FieldName = 'ReceptStatus'
    end
    object mtEksEkspType: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Eksp.type'
      FieldName = 'EkspType'
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      OnGetText = EkspTypeGetText
      OnSetText = EkspTypeSetText
    end
    object mtEksEkspForm: TWordField
      Alignment = taLeftJustify
      DisplayLabel = 'Eksp.form'
      FieldName = 'EkspForm'
      LookupKeyFields = 'Nr'
      LookupResultField = 'Navn'
      OnGetText = EkspFormGetText
      OnSetText = EkspFormSetText
    end
    object mtEksAntLin: TWordField
      FieldName = 'AntLin'
    end
    object mtEksLevNr: TStringField
      FieldName = 'LevNr'
    end
    object mtEksLevNavn: TStringField
      FieldName = 'LevNavn'
      Size = 30
    end
    object mtEksYderNr: TStringField
      FieldName = 'YderNr'
      Size = 10
    end
    object mtEksYderCprNr: TStringField
      FieldName = 'YderCprNr'
      Size = 10
    end
    object mtEksYderNavn: TStringField
      FieldName = 'YderNavn'
      Size = 30
    end
    object mtEksDebitorNr: TStringField
      FieldName = 'DebitorNr'
    end
    object mtEksDebitorNavn: TStringField
      FieldName = 'DebitorNavn'
      Size = 30
    end
    object mtEksDebitorGrp: TWordField
      FieldName = 'DebitorGrp'
      Visible = False
    end
    object mtEksAfdeling: TWordField
      FieldName = 'Afdeling'
    end
    object mtEksLager: TWordField
      FieldName = 'Lager'
    end
    object mtEksLeveringsForm: TWordField
      FieldName = 'LeveringsForm'
    end
    object mtEksGlCtrSaldo: TCurrencyField
      DisplayLabel = 'Gl. Ctr-saldo'
      DisplayWidth = 12
      FieldName = 'GlCtrSaldo'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtEksNyCtrSaldo: TCurrencyField
      DisplayLabel = 'Ny Ctr-saldo'
      DisplayWidth = 12
      FieldName = 'NyCtrSaldo'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtEksCtrUdlign: TCurrencyField
      DisplayLabel = 'CTR udligning'
      FieldName = 'CtrUdlign'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtEksYdCprChk: TBooleanField
      FieldName = 'YdCprChk'
      Visible = False
    end
    object mtEksNettoPriser: TBooleanField
      FieldName = 'NettoPriser'
      Visible = False
    end
    object mtEksUdbrGebyr: TCurrencyField
      FieldName = 'UdbrGebyr'
      Visible = False
    end
    object mtEksAvancePct: TCurrencyField
      FieldName = 'AvancePct'
      Visible = False
    end
    object mtEksCtrUdlFor: TCurrencyField
      DisplayLabel = 'Forrige udligning'
      FieldName = 'CtrUdlFor'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtEksCtrUdlignType: TWordField
      FieldName = 'CtrUdlignType'
      Visible = False
    end
    object mtEksCtrUdlignDato: TDateTimeField
      FieldName = 'CtrUdlignDato'
      Visible = False
    end
    object mtEksPakkeNr: TIntegerField
      DisplayLabel = 'Pakkenr'
      DisplayWidth = 7
      FieldName = 'PakkeNr'
    end
    object mtEksTurNr: TIntegerField
      DisplayLabel = 'Turnr'
      DisplayWidth = 5
      FieldName = 'TurNr'
    end
    object mtEksLuPbs: TWordField
      FieldKind = fkLookup
      FieldName = 'LuPbs'
      LookupDataSet = ffDebKar
      LookupKeyFields = 'KontoNr'
      LookupResultField = 'BetalForm'
      KeyFields = 'DebitorNr'
      OnGetText = mtEksOldLuPbsGetText
      Lookup = True
    end
    object mtEksDebProcent: TCurrencyField
      FieldName = 'DebProcent'
    end
    object mtEksDosKortNr: TIntegerField
      FieldName = 'DosKortNr'
    end
    object mtEksKontakt: TStringField
      FieldName = 'Kontakt'
      Size = 30
    end
    object mtEksGlCtrSaldoB: TCurrencyField
      FieldName = 'GlCtrSaldoB'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtEksNyCtrSaldoB: TCurrencyField
      FieldName = 'NyCtrSaldoB'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtEksCtrUdlForB: TCurrencyField
      FieldName = 'CtrUdlForB'
    end
    object mtEksCtrUdlignTypeB: TWordField
      FieldName = 'CtrUdlignTypeB'
    end
    object mtEksCtrUdlignDatoB: TDateTimeField
      FieldName = 'CtrUdlignDatoB'
    end
    object mtEksCtrUdlignB: TCurrencyField
      FieldName = 'CtrUdlignB'
      DisplayFormat = '###,###,###,##0.00'
    end
    object mtEksKundeNavn: TStringField
      FieldName = 'KundeNavn'
      Size = 30
    end
    object mtEksLmsModtager: TStringField
      FieldName = 'LmsModtager'
      Size = 10
    end
    object mtEksOrdreDato: TDateTimeField
      FieldName = 'OrdreDato'
    end
  end
  object cdCtrLanISo: TClientDataSet
    PersistDataPacket.Data = {
      4A1C00009619E0BD01000000180000000400EC000000030000007800024E7204
      00010000000000094F7065726174696F6E010049000000010005574944544802
      0002003200044E61766E01004900000001000557494454480200020032000749
      534F4B6F64650100490000000100055749445448020002000300000000000600
      00000A4C616E64656B6F646572054E6F726765034E4F5200000E0000000A4C61
      6E64656B6F6465720753766572696765035357450000160000000A4C616E6465
      6B6F6465720649736C616E640349534C00001E0000000A4C616E64656B6F6465
      720746696E6C616E640346494E0000310000000A4C616E64656B6F6465720847
      72F86E6C616E640347524C0000390000000A4C616E64656B6F6465720846E672
      F865726E650346524F0000410000000A4C616E64656B6F6465720744616E6D61
      726B03444E4B0000510000000A4C616E64656B6F646572075479726B69657403
      5455520000540100000A4C616E64656B6F646572074974616C69656E03495441
      0000670100000A4C616E64656B6F64657207486F6C6C616E64034E4C4400006F
      0100000A4C616E64656B6F6465720742656C6769656E0342454C000077010000
      0A4C616E64656B6F646572094C7578656D62757267034C555800007F0100000A
      4C616E64656B6F646572084672616E6B726967034652410000870100000A4C61
      6E64656B6F646572085479736B6C616E64034445550000950100000A4C616E64
      656B6F6465720649726C616E640349524C00009D0100000A4C616E64656B6F64
      65720A4772E66B656E6C616E64034752430000A50100000A4C616E64656B6F64
      6572075370616E69656E034553500000C00100000A4C616E64656B6F64657208
      506F72747567616C035052540000C80100000A4C616E64656B6F64657206D873
      74726967034155540000D00100000A4C616E64656B6F6465720C4C6963687465
      6E737465696E034C49450000E00100000A4C616E64656B6F646572074573746C
      616E64034553540000F30100000A4C616E64656B6F646572074C65746C616E64
      034C56410000F60100000A4C616E64656B6F646572074C69746175656E034C54
      550000FE0100000A4C616E64656B6F64657205506F6C656E03504F4C00001102
      00000A4C616E64656B6F64657208546A656B6B69657403435A45000019020000
      0A4C616E64656B6F64657209536C6F76616B6965740353564B0000210200000A
      4C616E64656B6F64657206556E6761726E0348554E0000290200000A4C616E64
      656B6F64657209536C6F76656E69656E0353564E0000310200000A4C616E6465
      6B6F646572054D616C7461034D4C5400004C0200000A4C616E64656B6F646572
      0643797065726E034359500000540200000A4C616E64656B6F6465720942756C
      67617269656E0342475200006A0200000A4C616E64656B6F6465720852756DE6
      6E69656E03524F550000E7030000094C616E64656B6F64650B41666768616E69
      7374616E034146470000E8030000094C616E64656B6F646508416C62616E6965
      6E03414C420000E9030000094C616E64656B6F646508416C6765726965740344
      5A410000EA030000094C616E64656B6F646510416D6572696B616E736B205361
      6D6F610341534D0000EB030000094C616E64656B6F646507416E646F72726103
      414E440000EC030000094C616E64656B6F646506416E676F6C610341474F0000
      ED030000094C616E64656B6F646508416E6775696C6C61034149410000EE0300
      00094C616E64656B6F646509416E7461726B746973034154410000EF03000009
      4C616E64656B6F646512416E7469677561206F67204261726275646103415447
      0000F0030000094C616E64656B6F646509417267656E74696E61034152470000
      F1030000094C616E64656B6F64650841726D656E69656E0341524D0000F20300
      00094C616E64656B6F6465054172756261034142570000F3030000094C616E64
      656B6F64650A4175737472616C69656E034155530000F4030000094C616E6465
      6B6F64650C4173657262616A64736A616E03415A450000F5030000094C616E64
      656B6F646507426168616D6173034248530000F6030000094C616E64656B6F64
      65074261687261696E034248520000F7030000094C616E64656B6F64650A4261
      6E676C6164657368034247440000F8030000094C616E64656B6F646508426172
      6261646F73034252420000F9030000094C616E64656B6F64651442656C617275
      732F48766964657275736C616E6403424C520000FA030000094C616E64656B6F
      64650642656C697A6503424C5A0000FB030000094C616E64656B6F6465054265
      6E696E0342454E0000FC030000094C616E64656B6F6465074265726D75646103
      424D550000FD030000094C616E64656B6F64650642687574616E0342544E0000
      FE030000094C616E64656B6F646507426F6C6976696103424F4C0000FF030000
      094C616E64656B6F646513426F736E69656E2D4865726365676F76696E610342
      4948000000040000094C616E64656B6F646508426F747377616E610342574100
      0001040000094C616E64656B6F646509426F75766574F8656E03425654000002
      040000094C616E64656B6F64650942726173696C69656E034252410000030400
      00094C616E64656B6F6465274272697469736B207465727269746F7269756D20
      692044657420496E6469736B65204F6365616E03494F54000004040000094C61
      6E64656B6F6465064272756E65690342524E000005040000094C616E64656B6F
      64650C4275726B696E61204661736F03424641000006040000094C616E64656B
      6F646507427572756E646903424449000007040000094C616E64656B6F646508
      43616D626F646A61034B484D000008040000094C616E64656B6F64650843616D
      65726F756E03434D52000009040000094C616E64656B6F64650643616E616461
      0343414E00000A040000094C616E64656B6F64650B4361796D616EF865726E65
      0343594D00000B040000094C616E64656B6F64651A43656E7472616C61667269
      6B616E736B652052657075626C696B0343414600000C040000094C616E64656B
      6F6465054368696C650343484C00000D040000094C616E64656B6F6465044B69
      6E610343484E00000E040000094C616E64656B6F6465074A756C65F8656E0343
      585200000F040000094C616E64656B6F64650A436F636F73F865726E65034343
      4B000010040000094C616E64656B6F646508436F6C6F6D62696103434F4C0000
      11040000094C616E64656B6F646509436F6D6F7265726E6503434F4D00001204
      0000094C616E64656B6F646505436F6E676F03434F47000013040000094C616E
      64656B6F64651B44656D6F6B72617469736B652052657075626C696B20436F6E
      676F03434F44000014040000094C616E64656B6F646509436F6F6BF865726E65
      03434F4B000015040000094C616E64656B6F64650A436F737461205269636103
      435249000016040000094C616E64656B6F646504437562610343554200001704
      0000094C616E64656B6F64650743757261E7616F03435557000018040000094C
      616E64656B6F646508446A69626F75746903444A49000019040000094C616E64
      656B6F646508446F6D696E69636103444D4100001A040000094C616E64656B6F
      646515446F6D696E696B616E736B652052657075626C696B03444F4D00001B04
      0000094C616E64656B6F64650745637561646F720345435500001C040000094C
      616E64656B6F6465074567797074656E0345475900001D040000094C616E6465
      6B6F64650F456C66656E62656E736B797374656E0343495600001E040000094C
      616E64656B6F64650B456C2053616C7661646F7203534C5600001F040000094C
      616E64656B6F6465074572697472656103455249000020040000094C616E6465
      6B6F6465084574696F7069656E03455448000021040000094C616E64656B6F64
      650E46616C6B6C616E6473F865726E6503464C4B000022040000094C616E6465
      6B6F64650446696A6903464A49000023040000094C616E64656B6F64650C4669
      6C697070696E65726E650350484C000024040000094C616E64656B6F64650547
      61626F6E03474142000025040000094C616E64656B6F64650647616D62696103
      474D42000026040000094C616E64656B6F64650847656F726769656E0347454F
      000027040000094C616E64656B6F6465054768616E6103474841000028040000
      094C616E64656B6F64650947696272616C74617203474942000029040000094C
      616E64656B6F6465084772F86E6C616E640347524C00002A040000094C616E64
      656B6F6465074772656E6164610347524400002B040000094C616E64656B6F64
      650A47756164656C6F75706503474C5000002C040000094C616E64656B6F6465
      044775616D0347554D00002D040000094C616E64656B6F64650947756174656D
      616C610347544D00002E040000094C616E64656B6F6465064775696E65610347
      494E00002F040000094C616E64656B6F64650D4775696E65612D426973736175
      03474E42000030040000094C616E64656B6F646506477579616E610347555900
      0031040000094C616E64656B6F64650548616974690348544900003204000009
      4C616E64656B6F646508486F6E647572617303484E44000033040000094C616E
      64656B6F646508486F6E676B6F6E6703484B47000034040000094C616E64656B
      6F646506496E6469656E03494E44000035040000094C616E64656B6F64650A49
      6E646F6E657369656E0349444E000036040000094C616E64656B6F6465044972
      616B03495251000037040000094C616E64656B6F6465044972616E0349524E00
      0038040000094C616E64656B6F64650649737261656C03495352000039040000
      094C616E64656B6F64650649736C616E640349534C00003A040000094C616E64
      656B6F6465074A616D61696361034A414D00003B040000094C616E64656B6F64
      65054A6170616E034A504E00003C040000094C616E64656B6F6465064A6F7264
      616E034A4F5200003D040000094C616E64656B6F6465094B6170205665726465
      0343505600003E040000094C616E64656B6F64650A4B6173616B687374616E03
      4B415A00003F040000094C616E64656B6F6465054B656E7961034B454E000040
      040000094C616E64656B6F6465094B697267697374616E034B475A0000410400
      00094C616E64656B6F6465084B69726962617469034B4952000042040000094C
      616E64656B6F6465094E6F72646B6F7265610350524B000043040000094C616E
      64656B6F6465085379646B6F726561034B4F52000044040000094C616E64656B
      6F6465064B7577616974034B5754000045040000094C616E64656B6F6465044C
      616F73034C414F000046040000094C616E64656B6F6465074C6962616E6F6E03
      4C424E000047040000094C616E64656B6F6465074C65736F74686F034C534F00
      0048040000094C616E64656B6F6465074C696265726961034C42520000490400
      00094C616E64656B6F6465064C696279656E034C425900004A040000094C616E
      64656B6F64650D4C6965636874656E737465696E034C494500004B040000094C
      616E64656B6F6465054D6163616F034D414300004C040000094C616E64656B6F
      64650A4D6164616761736B6172034D444700004D040000094C616E64656B6F64
      65064D616C617769034D574900004E040000094C616E64656B6F6465084D616C
      6179736961034D595300004F040000094C616E64656B6F64650A4D616C646976
      65726E65034D4456000050040000094C616E64656B6F6465044D616C69034D4C
      49000051040000094C616E64656B6F64650D4D61727368616C6CF865726E6503
      4D484C000052040000094C616E64656B6F64650A4D617274696E69717565034D
      5451000053040000094C616E64656B6F64650B4D6175726574616E69656E034D
      5254000054040000094C616E64656B6F6465094D6175726974697573034D5553
      000055040000094C616E64656B6F6465074D61796F747465034D595400005604
      0000094C616E64656B6F6465064D657869636F034D4558000057040000094C61
      6E64656B6F64650B4D696B726F6E657369656E0346534D000058040000094C61
      6E64656B6F6465074D6F6C646F7661034D4441000059040000094C616E64656B
      6F6465064D6F6E61636F034D434F00005A040000094C616E64656B6F6465094D
      6F6E676F6C696574034D4E4700005B040000094C616E64656B6F64650A4D6F6E
      74656E6567726F034D4E4500005C040000094C616E64656B6F64650A4D6F6E74
      736572726174034D535200005D040000094C616E64656B6F6465074D61726F6B
      6B6F034D415200005E040000094C616E64656B6F64650A4D6F7A616D62697175
      65034D4F5A00005F040000094C616E64656B6F6465074E616D69626961034E41
      4D000060040000094C616E64656B6F6465054E61757275034E52550000610400
      00094C616E64656B6F6465054E6570616C034E504C000062040000094C616E64
      656B6F64650B4E6577205A65616C616E64034E5A4C000063040000094C616E64
      656B6F6465094E6963617261677561034E4943000064040000094C616E64656B
      6F6465054E69676572034E4552000065040000094C616E64656B6F6465074E69
      6765726961034E4741000066040000094C616E64656B6F6465044E697565034E
      4955000067040000094C616E64656B6F64650A4E6F72666F6C6BF8656E034E46
      4B000068040000094C616E64656B6F64650E4E6F72646D616B65646F6E69656E
      034D4B44000069040000094C616E64656B6F64650E4E6F72646D617269616E65
      726E65034D4E5000006A040000094C616E64656B6F6465054E6F726765034E4F
      5200006B040000094C616E64656B6F6465044F6D616E034F4D4E00006C040000
      094C616E64656B6F64650850616B697374616E0350414B00006D040000094C61
      6E64656B6F64650550616C617503504C5700006E040000094C616E64656B6F64
      650950616CE67374696E610350534500006F040000094C616E64656B6F646506
      50616E616D610350414E000070040000094C616E64656B6F64650F5061707561
      204E79204775696E656103504E47000071040000094C616E64656B6F64650850
      6172616775617903505259000072040000094C616E64656B6F64650450657275
      03504552000073040000094C616E64656B6F646508506974636169726E035043
      4E000074040000094C616E64656B6F6465055161746172035141540000750400
      00094C616E64656B6F64650752E9756E696F6E03524555000076040000094C61
      6E64656B6F6465075275736C616E6403525553000077040000094C616E64656B
      6F6465065277616E646103525741000078040000094C616E64656B6F64651053
      61696E74204261727468E96C656D7903424C4D000079040000094C616E64656B
      6F64650C5361696E742048656C656E610353484E00007A040000094C616E6465
      6B6F6465145361696E74204B69747473206F67204E65766973034B4E4100007B
      040000094C616E64656B6F64650B5361696E74204C75636961034C434100007C
      040000094C616E64656B6F64650C5361696E74204D617274696E034D41460000
      7D040000094C616E64656B6F6465185361696E7420506965727265206F67204D
      697175656C6F6E0353504D00007E040000094C616E64656B6F64651D5361696E
      742056696E63656E74206F67204772656E6164696E65726E650356435400007F
      040000094C616E64656B6F64650553616D6F610357534D000080040000094C61
      6E64656B6F64650A53616E204D6172696E6F03534D52000081040000094C616E
      64656B6F64651453E36F20546F6DE9206F67205072ED6E636970650353545000
      0082040000094C616E64656B6F64650D53617564692D4172616269656E035341
      55000083040000094C616E64656B6F64650753656E6567616C0353454E000084
      040000094C616E64656B6F6465075365726269656E0353524200008504000009
      4C616E64656B6F64650C5365796368656C6C65726E6503535943000086040000
      094C616E64656B6F64650C536965727261204C656F6E6503534C450000870400
      00094C616E64656B6F64650953696E6761706F72650353475000008804000009
      4C616E64656B6F64650C53696E74204D61617274656E0353584D000089040000
      094C616E64656B6F64650C53616C6F6D6F6EF865726E6503534C4200008A0400
      00094C616E64656B6F646507536F6D616C696103534F4D00008B040000094C61
      6E64656B6F646509537964616672696B61035A414600008C040000094C616E64
      656B6F646508537964737564616E0353534400008D040000094C616E64656B6F
      646509537269204C616E6B61034C4B4100008E040000094C616E64656B6F6465
      05537564616E0353444E00008F040000094C616E64656B6F646507537572696E
      616D03535552000090040000094C616E64656B6F6465155376616C6261726420
      6F67204A616E204D6179656E03534A4D000091040000094C616E64656B6F6465
      075363687765697A03434845000092040000094C616E64656B6F646506537972
      69656E03535952000093040000094C616E64656B6F64650654616977616E0354
      574E000094040000094C616E64656B6F64650C546164736A696B697374616E03
      544A4B000095040000094C616E64656B6F64650854616E7A616E696103545A41
      000096040000094C616E64656B6F646508546861696C616E6403544841000097
      040000094C616E64656B6F64650B54696D6F722D4C6573746503544C53000098
      040000094C616E64656B6F646504546F676F0354474F000099040000094C616E
      64656B6F646507546F6B656C617503544B4C00009A040000094C616E64656B6F
      646505546F6E676103544F4E00009B040000094C616E64656B6F646512547269
      6E69646164206F6720546F6261676F0354544F00009C040000094C616E64656B
      6F64650854756E657369656E0354554E00009D040000094C616E64656B6F6465
      075479726B6965740354555200009E040000094C616E64656B6F64650C547572
      6B6D656E697374616E03544B4D00009F040000094C616E64656B6F6465155475
      726B732D206F6720436169636F73F865726E65035443410000A0040000094C61
      6E64656B6F646506547576616C75035455560000A1040000094C616E64656B6F
      6465065567616E6461035547410000A2040000094C616E64656B6F646507556B
      7261696E6503554B520000A3040000094C616E64656B6F64651A466F72656E65
      6465204172616269736B6520456D697261746572034152450000A4040000094C
      616E64656B6F64650E53746F7262726974616E6E69656E034742520000A50400
      00094C616E64656B6F646503555341035553410000A6040000094C616E64656B
      6F64650E5553419273207964726520F8657203554D490000A7040000094C616E
      64656B6F64650755727567756179035552590000A8040000094C616E64656B6F
      64650A557362656B697374616E03555A420000A9040000094C616E64656B6F64
      650756616E75617475035655540000AA040000094C616E64656B6F6465095665
      6E657A75656C610356454E0000AB040000094C616E64656B6F64650756696574
      6E616D03564E4D0000AC040000094C616E64656B6F6465124272697469736B65
      204A6F6D667275F86572035647420000AD040000094C616E64656B6F64651541
      6D6572696B616E736B65204A6F6D667275F86572035649520000AE040000094C
      616E64656B6F64651057616C6C6973206F6720467574756E6103574C460000AF
      040000094C616E64656B6F64650A56657374736168617261034553480000B004
      0000094C616E64656B6F64650559656D656E0359454D0000B1040000094C616E
      64656B6F6465065A616D626961035A4D420000B2040000094C616E64656B6F64
      65085A696D6261627765035A5745}
    Active = True
    Aggregates = <>
    FileName = 'G:\CdsLandekodeISo.cds'
    FieldDefs = <
      item
        Name = 'Nr'
        DataType = ftInteger
      end
      item
        Name = 'Operation'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Navn'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'ISOKode'
        DataType = ftString
        Size = 3
      end>
    IndexDefs = <
      item
        Name = 'NavnOrden'
        Fields = 'Navn'
      end
      item
        Name = 'NrOrden'
        Fields = 'Nr;Navn'
      end>
    Params = <>
    StoreDefs = True
    Left = 168
    Top = 472
    object cdCtrLanISoNr: TIntegerField
      FieldName = 'Nr'
    end
    object cdCtrLanISoOperation: TStringField
      FieldName = 'Operation'
      Size = 50
    end
    object cdCtrLanISoNavn: TStringField
      FieldName = 'Navn'
      Size = 50
    end
    object cdCtrLanISoISOKode: TStringField
      FieldName = 'ISOKode'
      Size = 3
    end
  end
  object SQLConnection1: TSQLConnection
    DriverName = 'DataSnap'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DbxDatasnap'
      'HostName=localhost'
      'Port=21167'
      'CommunicationProtocol=tcp/ip'
      'DatasnapContext=datasnap/')
    Left = 904
    Top = 24
  end
end
