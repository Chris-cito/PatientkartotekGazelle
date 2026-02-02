object PrintDosCardDM: TPrintDosCardDM
  OldCreateOrder = False
  Height = 346
  Width = 565
  object RaveProject1: TRvProject
    Engine = ReportSystem1
    ProjectFile = 'DOSIS.rav'
    Left = 24
    Top = 160
  end
  object ReportSystem1: TRvSystem
    TitleSetup = 'Output Options'
    TitleStatus = 'Report Status'
    TitlePreview = 'Report Preview'
    DefaultDest = rdPrinter
    SystemFiler.StatusFormat = 'Generating page %p'
    SystemPreview.ZoomFactor = 100.000000000000000000
    SystemPrinter.ScaleX = 100.000000000000000000
    SystemPrinter.ScaleY = 100.000000000000000000
    SystemPrinter.StatusFormat = 'Printing page %p'
    SystemPrinter.Title = 'Rave Report'
    SystemPrinter.Units = unMM
    SystemPrinter.UnitsFactor = 25.400000000000000000
    Left = 21
    Top = 96
  end
  object rpBRU: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = ffBRU
    Left = 200
    Top = 24
  end
  object RPDCH: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = cdsUdHeader
    Left = 96
    Top = 24
  end
  object RPDCL: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = cdsUdLines
    Left = 152
    Top = 24
  end
  object RPDCP: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = ffDCP
    Left = 253
    Top = 32
  end
  object rpMEM: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = MemTable1
    Left = 317
    Top = 32
  end
  object RpRenderPDF1: TRvRenderPDF
    DisplayName = 'Adobe Acrobat (PDF)'
    FileExtension = '*.pdf'
    DocInfo.Creator = 'Rave Reports (http://www.nevrona.com/rave)'
    DocInfo.Producer = 'Nevrona Designs'
    Left = 24
    Top = 24
  end
  object MemTable1: TClientDataSet
    PersistDataPacket.Data = {
      3B0200009619E0BD0100000018000000130000000000030000003B0207426172
      636F64650100490000000100055749445448020002000C000A5765656B4E756D
      62657201004900000001000557494454480200020004000950616765436F756E
      7401004900000001000557494454480200020002000A41706F74656B4E616D65
      01004900000001000557494454480200020032000944656269746F724E720100
      490000000100055749445448020002001E000A43617264456469746F72010049
      00000001000557494454480200020014000A4B6F6E74726F6C6C657201004900
      00000100055749445448020002001E0005546C664E7201004900000001000557
      49445448020002001E0003466178010049000000010005574944544802000200
      1E0007496E74616B65310100490000000100055749445448020002000A000769
      6E74616B65320100490000000100055749445448020002000A0007496E74616B
      6533010049000000010005574944544802000200140007496E74616B65340100
      490000000100055749445448020002000A0007496E74616B6535010049000000
      0100055749445448020002000A0007496E74616B653601004900000001000557
      49445448020002000A0007496E74616B65370100490000000100055749445448
      020002000A0007496E74616B6538010049000000010005574944544802000200
      0A000B50616B6B6541706F74656B010049000000010005574944544802000200
      3200065061726B65640100490000000100055749445448020002000A000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 320
    Top = 88
    object MemTable1Barcode: TStringField
      FieldName = 'Barcode'
      Size = 12
    end
    object MemTable1WeekNumber: TStringField
      FieldName = 'WeekNumber'
      Size = 4
    end
    object MemTable1PageCount: TStringField
      FieldName = 'PageCount'
      Size = 2
    end
    object MemTable1ApotekName: TStringField
      FieldName = 'ApotekName'
      Size = 50
    end
    object MemTable1DebitorNr: TStringField
      FieldName = 'DebitorNr'
      Size = 30
    end
    object MemTable1CardEditor: TStringField
      FieldName = 'CardEditor'
    end
    object MemTable1Kontroller: TStringField
      FieldName = 'Kontroller'
      Size = 30
    end
    object MemTable1TlfNr: TStringField
      FieldName = 'TlfNr'
      Size = 30
    end
    object MemTable1Fax: TStringField
      FieldName = 'Fax'
      Size = 30
    end
    object MemTable1Intake1: TStringField
      FieldName = 'Intake1'
      Size = 10
    end
    object MemTable1intake2: TStringField
      DisplayWidth = 10
      FieldName = 'intake2'
      Size = 10
    end
    object MemTable1Intake3: TStringField
      FieldName = 'Intake3'
    end
    object MemTable1Intake4: TStringField
      FieldName = 'Intake4'
      Size = 10
    end
    object MemTable1Intake5: TStringField
      FieldName = 'Intake5'
      Size = 10
    end
    object MemTable1Intake6: TStringField
      FieldName = 'Intake6'
      Size = 10
    end
    object MemTable1Intake7: TStringField
      FieldName = 'Intake7'
      Size = 10
    end
    object MemTable1Intake8: TStringField
      FieldName = 'Intake8'
      Size = 10
    end
    object MemTable1PakkeApotek: TStringField
      FieldName = 'PakkeApotek'
      Size = 50
    end
    object MemTable1Parked: TStringField
      FieldName = 'Parked'
      Size = 10
    end
  end
  object ffDCP: TnxTable
    TableName = 'DosisPeriod'
    IndexName = 'Dosiskod'
    Left = 256
    Top = 88
    object ffDCPDosiskod: TStringField
      FieldName = 'Dosiskod'
      Required = True
      Size = 10
    end
    object ffDCPDosisPeriods: TWordField
      FieldName = 'DosisPeriods'
      Required = True
    end
    object ffDCPPeriod1: TStringField
      FieldName = 'Period1'
      Size = 10
    end
    object ffDCPPeriod2: TStringField
      FieldName = 'Period2'
      Size = 10
    end
    object ffDCPPeriod3: TStringField
      FieldName = 'Period3'
      Size = 10
    end
    object ffDCPPeriod4: TStringField
      FieldName = 'Period4'
      Size = 10
    end
    object ffDCPPeriod5: TStringField
      FieldName = 'Period5'
      Size = 10
    end
    object ffDCPPeriod6: TStringField
      FieldName = 'Period6'
      Size = 10
    end
    object ffDCPPeriod7: TStringField
      FieldName = 'Period7'
      Size = 10
    end
    object ffDCPPeriod8: TStringField
      FieldName = 'Period8'
      Size = 10
    end
  end
  object ffBRU: TnxTable
    AliasName = 'PRODUKTION'
    TableName = 'BrugerAdgang'
    Left = 200
    Top = 88
    object ffBRUBrugerNr: TWordField
      FieldName = 'BrugerNr'
    end
    object ffBRUNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
  end
  object ffDCL: TnxTable
    AliasName = 'produktion'
    TableName = 'DosisCardLines'
    IndexName = 'DosisNum'
    Left = 152
    Top = 94
    object ffDCLDrugid: TStringField
      FieldName = 'Drugid'
      Size = 11
    end
    object ffDCLRegularDose: TBooleanField
      FieldName = 'RegularDose'
    end
    object ffDCLDays: TStringField
      FieldName = 'Days'
      Size = 40
    end
    object ffDCLQuantity1: TFloatField
      FieldName = 'Quantity1'
    end
    object ffDCLQuantity2: TFloatField
      FieldName = 'Quantity2'
    end
    object ffDCLQuantity3: TFloatField
      FieldName = 'Quantity3'
    end
    object ffDCLQuantity4: TFloatField
      FieldName = 'Quantity4'
    end
    object ffDCLQuantity5: TFloatField
      FieldName = 'Quantity5'
    end
    object ffDCLQuantity6: TFloatField
      FieldName = 'Quantity6'
    end
    object ffDCLQuantity7: TFloatField
      FieldName = 'Quantity7'
    end
    object ffDCLQuantity8: TFloatField
      FieldName = 'Quantity8'
    end
    object ffDCLVareDescription: TStringField
      FieldName = 'VareDescription'
      Size = 30
    end
    object ffDCLVareIndikation: TStringField
      FieldName = 'VareIndikation'
      Size = 30
    end
    object ffDCLVareIntake: TStringField
      FieldName = 'VareIntake'
      Size = 30
    end
    object ffDCLCardNumber: TWordField
      FieldName = 'CardNumber'
    end
    object ffDCLVareNummer: TStringField
      FieldName = 'VareNummer'
    end
    object ffDCLTotalQuantity: TIntegerField
      FieldName = 'TotalQuantity'
    end
    object ffDCLKontrolled: TBooleanField
      FieldName = 'Kontrolled'
    end
    object ffDCLtest: TStringField
      FieldKind = fkCalculated
      FieldName = 'test'
      Size = 30
      Calculated = True
    end
    object ffDCLVareName: TStringField
      FieldName = 'VareName'
      Size = 50
    end
    object ffDCLEjSubst: TBooleanField
      FieldName = 'EjSubst'
    end
    object ffDCLKlausuleret: TBooleanField
      FieldName = 'Klausuleret'
    end
    object ffDCLRegel4243: TBooleanField
      FieldName = 'Regel4243'
    end
    object ffDCLAndreTilskud: TBooleanField
      FieldName = 'AndreTilskud'
    end
    object ffDCLIndikKode: TIntegerField
      FieldName = 'IndikKode'
    end
    object ffDCLGammeltVarenr: TStringField
      FieldName = 'GammeltVarenr'
    end
    object ffDCLRetVarenrInfo: TStringField
      FieldKind = fkCalculated
      FieldName = 'RetVarenrInfo'
      Size = 50
      Calculated = True
    end
    object ffDCLRetVareNrDato: TDateTimeField
      FieldName = 'RetVareNrDato'
    end
    object ffDCLLinenumber: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Linenumber'
      Calculated = True
    end
    object ffDCLOrdid: TStringField
      FieldName = 'Ordid'
      Size = 50
    end
    object ffDCLBevilRegelNr: TIntegerField
      FieldName = 'BevilRegelNr'
    end
    object ffDCLTerminalStatus: TBooleanField
      FieldName = 'TerminalStatus'
    end
    object ffDCLManOrdination: TBooleanField
      FieldName = 'ManOrdination'
    end
  end
  object ffDCH: TnxTable
    FilterType = ftSqlWhere
    TableName = 'DosisCardHeader'
    IndexName = 'CardNumber'
    Left = 96
    Top = 96
    object ffDCHCardNumber: TWordField
      FieldName = 'CardNumber'
    end
    object ffDCHPatientNumber: TStringField
      FieldName = 'PatientNumber'
      Size = 10
    end
    object ffDCHPatientName: TStringField
      FieldName = 'PatientName'
      Size = 30
    end
    object ffDCHPatientAddress1: TStringField
      FieldName = 'PatientAddress1'
      Size = 30
    end
    object ffDCHPatientAddress2: TStringField
      FieldName = 'PatientAddress2'
      Size = 30
    end
    object ffDCHPostnummer: TStringField
      FieldName = 'Postnummer'
      Size = 30
    end
    object ffDCHDeliveryAddress: TStringField
      FieldName = 'DeliveryAddress'
      Size = 30
    end
    object ffDCHKontaktPerson: TStringField
      FieldName = 'KontaktPerson'
      Size = 30
    end
    object ffDCHDoctorNumber: TStringField
      FieldName = 'DoctorNumber'
      Size = 7
    end
    object ffDCHDoctorName: TStringField
      FieldName = 'DoctorName'
      Size = 30
    end
    object ffDCHTelegram: TWordField
      FieldName = 'Telegram'
    end
    object ffDCHStartDate: TDateTimeField
      FieldName = 'StartDate'
    end
    object ffDCHEndDate: TDateTimeField
      FieldName = 'EndDate'
    end
    object ffDCHInterval: TWordField
      FieldName = 'Interval'
    end
    object ffDCHAddDate: TDateTimeField
      FieldName = 'AddDate'
    end
    object ffDCHChangeDate: TDateTimeField
      FieldName = 'ChangeDate'
    end
    object ffDCHDeleteDate: TDateTimeField
      FieldName = 'DeleteDate'
    end
    object ffDCHPackGroupNumber: TIntegerField
      FieldName = 'PackGroupNumber'
    end
    object ffDCHDoctorComment: TStringField
      FieldName = 'DoctorComment'
      Size = 250
    end
    object ffDCHPharmacistComment: TStringField
      FieldName = 'PharmacistComment'
      Size = 250
    end
    object ffDCHDosiskod: TStringField
      FieldName = 'Dosiskod'
      Size = 10
    end
    object ffDCHSendDate: TDateTimeField
      FieldName = 'SendDate'
    end
    object ffDCHAdduser: TIntegerField
      FieldName = 'Adduser'
    end
    object ffDCHChangeUser: TIntegerField
      FieldName = 'ChangeUser'
    end
    object ffDCHDeleteUser: TIntegerField
      FieldName = 'DeleteUser'
    end
    object ffDCHKontroller: TIntegerField
      FieldName = 'Kontroller'
    end
    object ffDCHKontrolDate: TDateTimeField
      FieldName = 'KontrolDate'
    end
    object ffDCHStartDay: TStringField
      FieldName = 'StartDay'
      Size = 10
    end
    object ffDCHFileReceiveDate: TDateTimeField
      FieldName = 'FileReceiveDate'
    end
    object ffDCHOrderReceiveDate: TDateTimeField
      FieldName = 'OrderReceiveDate'
    end
    object ffDCHOrderMemo: TMemoField
      FieldName = 'OrderMemo'
      BlobType = ftMemo
    end
    object ffDCHPackAccept: TBooleanField
      FieldName = 'PackAccept'
    end
    object ffDCHBemaerkMemo: TMemoField
      FieldName = 'BemaerkMemo'
      BlobType = ftMemo
    end
    object ffDCHParked: TBooleanField
      FieldName = 'Parked'
    end
    object ffDCHYderCprNr: TStringField
      FieldName = 'YderCprNr'
      Size = 10
    end
    object ffDCHKlausuleret: TBooleanField
      FieldName = 'Klausuleret'
    end
    object ffDCHAndreTilskud: TBooleanField
      FieldName = 'AndreTilskud'
    end
    object ffDCHLbNr: TIntegerField
      FieldName = 'LbNr'
    end
    object ffDCHAutoEksp: TBooleanField
      FieldName = 'AutoEksp'
    end
    object ffDCHTerminalStatus: TBooleanField
      FieldName = 'TerminalStatus'
    end
  end
  object cdsUdHeader: TClientDataSet
    PersistDataPacket.Data = {
      D30300009619E0BD010000001800000026000000000003000000D3030A436172
      644E756D62657202000200000000000D50617469656E744E756D626572010049
      0000000100055749445448020002000A000B50617469656E744E616D65010049
      0000000100055749445448020002001E000F50617469656E7441646472657373
      310100490000000100055749445448020002001E000F50617469656E74416464
      72657373320100490000000100055749445448020002001E000A506F73746E75
      6D6D65720100490000000100055749445448020002001E000F44656C69766572
      79416464726573730100490000000100055749445448020002001E000D4B6F6E
      74616B74506572736F6E0100490000000100055749445448020002001E000C44
      6F63746F724E756D62657201004900000001000557494454480200020007000A
      446F63746F724E616D650100490000000100055749445448020002001E000854
      656C656772616D02000200000000000953746172744461746508000800000000
      0007456E6444617465080008000000000008496E74657276616C020002000000
      0000074164644461746508000800000000000A4368616E676544617465080008
      00000000000A44656C6574654461746508000800000000000F5061636B47726F
      75704E756D62657204000100000000000D446F63746F72436F6D6D656E740100
      49000000010005574944544802000200FA0011506861726D6163697374436F6D
      6D656E74010049000000010005574944544802000200FA0008446F7369736B6F
      640100490000000100055749445448020002000A0006427265764E7202000200
      000000000853656E644461746508000800000000000741646475736572040001
      00000000000A4368616E67655573657204000100000000000A44656C65746555
      73657204000100000000000A4B6F6E74726F6C6C657204000100000000000B4B
      6F6E74726F6C4461746508000800000000000853746172744461790100490000
      000100055749445448020002000A000F46696C65526563656976654461746508
      00080000000000104F7264657252656365697665446174650800080000000000
      094F726465724D656D6F04004B00000001000753554254595045020049000500
      54657874000A5061636B41636365707402000300000000000B42656D6165726B
      4D656D6F04004B00000001000753554254595045020049000500546578740006
      5061726B6564020003000000000009596465724370724E720100490000000100
      055749445448020002000A000B4B6C617573756C657265740200030000000000
      0C416E64726554696C736B756402000300000000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'CardNumber'
        DataType = ftWord
      end
      item
        Name = 'PatientNumber'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'PatientName'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'PatientAddress1'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'PatientAddress2'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Postnummer'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'DeliveryAddress'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'KontaktPerson'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'DoctorNumber'
        DataType = ftString
        Size = 7
      end
      item
        Name = 'DoctorName'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Telegram'
        DataType = ftWord
      end
      item
        Name = 'StartDate'
        DataType = ftDateTime
      end
      item
        Name = 'EndDate'
        DataType = ftDateTime
      end
      item
        Name = 'Interval'
        DataType = ftWord
      end
      item
        Name = 'AddDate'
        DataType = ftDateTime
      end
      item
        Name = 'ChangeDate'
        DataType = ftDateTime
      end
      item
        Name = 'DeleteDate'
        DataType = ftDateTime
      end
      item
        Name = 'PackGroupNumber'
        DataType = ftInteger
      end
      item
        Name = 'DoctorComment'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'PharmacistComment'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'Dosiskod'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'BrevNr'
        DataType = ftWord
      end
      item
        Name = 'SendDate'
        DataType = ftDateTime
      end
      item
        Name = 'Adduser'
        DataType = ftInteger
      end
      item
        Name = 'ChangeUser'
        DataType = ftInteger
      end
      item
        Name = 'DeleteUser'
        DataType = ftInteger
      end
      item
        Name = 'Kontroller'
        DataType = ftInteger
      end
      item
        Name = 'KontrolDate'
        DataType = ftDateTime
      end
      item
        Name = 'StartDay'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'FileReceiveDate'
        DataType = ftDateTime
      end
      item
        Name = 'OrderReceiveDate'
        DataType = ftDateTime
      end
      item
        Name = 'OrderMemo'
        DataType = ftMemo
      end
      item
        Name = 'PackAccept'
        DataType = ftBoolean
      end
      item
        Name = 'BemaerkMemo'
        DataType = ftMemo
      end
      item
        Name = 'Parked'
        DataType = ftBoolean
      end
      item
        Name = 'YderCprNr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'Klausuleret'
        DataType = ftBoolean
      end
      item
        Name = 'AndreTilskud'
        DataType = ftBoolean
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 392
    Top = 32
    object cdsUdHeaderCardNumber: TWordField
      FieldName = 'CardNumber'
    end
    object cdsUdHeaderPatientNumber: TStringField
      FieldName = 'PatientNumber'
      Size = 10
    end
    object cdsUdHeaderPatientName: TStringField
      FieldName = 'PatientName'
      Size = 30
    end
    object cdsUdHeaderPatientAddress1: TStringField
      FieldName = 'PatientAddress1'
      Size = 30
    end
    object cdsUdHeaderPatientAddress2: TStringField
      FieldName = 'PatientAddress2'
      Size = 30
    end
    object cdsUdHeaderPostnummer: TStringField
      FieldName = 'Postnummer'
      Size = 30
    end
    object cdsUdHeaderDeliveryAddress: TStringField
      FieldName = 'DeliveryAddress'
      Size = 30
    end
    object cdsUdHeaderKontaktPerson: TStringField
      FieldName = 'KontaktPerson'
      Size = 30
    end
    object cdsUdHeaderDoctorNumber: TStringField
      FieldName = 'DoctorNumber'
      Size = 7
    end
    object cdsUdHeaderDoctorName: TStringField
      FieldName = 'DoctorName'
      Size = 30
    end
    object cdsUdHeaderTelegram: TWordField
      FieldName = 'Telegram'
    end
    object cdsUdHeaderStartDate: TDateTimeField
      FieldName = 'StartDate'
    end
    object cdsUdHeaderEndDate: TDateTimeField
      FieldName = 'EndDate'
    end
    object cdsUdHeaderInterval: TWordField
      FieldName = 'Interval'
    end
    object cdsUdHeaderAddDate: TDateTimeField
      FieldName = 'AddDate'
    end
    object cdsUdHeaderChangeDate: TDateTimeField
      FieldName = 'ChangeDate'
    end
    object cdsUdHeaderDeleteDate: TDateTimeField
      FieldName = 'DeleteDate'
    end
    object cdsUdHeaderPackGroupNumber: TIntegerField
      FieldName = 'PackGroupNumber'
    end
    object cdsUdHeaderDoctorComment: TStringField
      FieldName = 'DoctorComment'
      Size = 250
    end
    object cdsUdHeaderPharmacistComment: TStringField
      FieldName = 'PharmacistComment'
      Size = 250
    end
    object cdsUdHeaderDosiskod: TStringField
      FieldName = 'Dosiskod'
      Size = 10
    end
    object cdsUdHeaderSendDate: TDateTimeField
      FieldName = 'SendDate'
    end
    object cdsUdHeaderAdduser: TIntegerField
      FieldName = 'Adduser'
    end
    object cdsUdHeaderChangeUser: TIntegerField
      FieldName = 'ChangeUser'
    end
    object cdsUdHeaderDeleteUser: TIntegerField
      FieldName = 'DeleteUser'
    end
    object cdsUdHeaderKontroller: TIntegerField
      FieldName = 'Kontroller'
    end
    object cdsUdHeaderKontrolDate: TDateTimeField
      FieldName = 'KontrolDate'
    end
    object cdsUdHeaderStartDay: TStringField
      FieldName = 'StartDay'
      Size = 10
    end
    object cdsUdHeaderFileReceiveDate: TDateTimeField
      FieldName = 'FileReceiveDate'
    end
    object cdsUdHeaderOrderReceiveDate: TDateTimeField
      FieldName = 'OrderReceiveDate'
    end
    object cdsUdHeaderOrderMemo: TMemoField
      FieldName = 'OrderMemo'
      BlobType = ftMemo
    end
    object cdsUdHeaderPackAccept: TBooleanField
      FieldName = 'PackAccept'
    end
    object cdsUdHeaderBemaerkMemo: TMemoField
      FieldName = 'BemaerkMemo'
      BlobType = ftMemo
    end
    object cdsUdHeaderParked: TBooleanField
      FieldName = 'Parked'
    end
    object cdsUdHeaderYderCprNr: TStringField
      FieldName = 'YderCprNr'
      Size = 10
    end
    object cdsUdHeaderKlausuleret: TBooleanField
      FieldName = 'Klausuleret'
    end
    object cdsUdHeaderAndreTilskud: TBooleanField
      FieldName = 'AndreTilskud'
    end
  end
  object cdsUdLines: TClientDataSet
    PersistDataPacket.Data = {
      7F0200009619E0BD01000000180000001B0000000000030000007F0206447275
      6769640100490000000100055749445448020002000B000B526567756C617244
      6F73650200030000000000044461797301004900000001000557494454480200
      02002800095175616E74697479310800040000000000095175616E7469747932
      0800040000000000095175616E74697479330800040000000000095175616E74
      697479340800040000000000095175616E746974793508000400000000000951
      75616E74697479360800040000000000095175616E7469747937080004000000
      0000095175616E746974793808000400000000000F5661726544657363726970
      74696F6E0100490000000100055749445448020002001E000E56617265496E64
      696B6174696F6E0100490000000100055749445448020002001E000A56617265
      496E74616B650100490000000100055749445448020002001E000A436172644E
      756D62657202000200000000000A566172654E756D6D65720100490000000100
      0557494454480200020014000D546F74616C5175616E74697479040001000000
      00000A4B6F6E74726F6C6C6564020003000000000008566172654E616D650100
      49000000010005574944544802000200320007456A5375627374020003000000
      00000B4B6C617573756C65726574020003000000000009526567656C34323433
      02000300000000000C416E64726554696C736B7564020003000000000009496E
      64696B4B6F646504000100000000000D47616D6D656C74566172656E72010049
      00000001000557494454480200020014000D526574566172654E724461746F08
      00080000000000054F7264696401004900000001000557494454480200020032
      000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 392
    Top = 96
    object cdsUdLinesDrugid: TStringField
      FieldName = 'Drugid'
      Size = 11
    end
    object cdsUdLinesRegularDose: TBooleanField
      FieldName = 'RegularDose'
    end
    object cdsUdLinesDays: TStringField
      FieldName = 'Days'
      Size = 40
    end
    object cdsUdLinesQuantity1: TFloatField
      FieldName = 'Quantity1'
    end
    object cdsUdLinesQuantity2: TFloatField
      FieldName = 'Quantity2'
    end
    object cdsUdLinesQuantity3: TFloatField
      FieldName = 'Quantity3'
    end
    object cdsUdLinesQuantity4: TFloatField
      FieldName = 'Quantity4'
    end
    object cdsUdLinesQuantity5: TFloatField
      FieldName = 'Quantity5'
    end
    object cdsUdLinesQuantity6: TFloatField
      FieldName = 'Quantity6'
    end
    object cdsUdLinesQuantity7: TFloatField
      FieldName = 'Quantity7'
    end
    object cdsUdLinesQuantity8: TFloatField
      FieldName = 'Quantity8'
    end
    object cdsUdLinesVareDescription: TStringField
      FieldName = 'VareDescription'
      Size = 30
    end
    object cdsUdLinesVareIndikation: TStringField
      FieldName = 'VareIndikation'
      Size = 30
    end
    object cdsUdLinesVareIntake: TStringField
      FieldName = 'VareIntake'
      Size = 30
    end
    object cdsUdLinesCardNumber: TWordField
      FieldName = 'CardNumber'
    end
    object cdsUdLinesVareNummer: TStringField
      FieldName = 'VareNummer'
    end
    object cdsUdLinesTotalQuantity: TIntegerField
      FieldName = 'TotalQuantity'
    end
    object cdsUdLinesKontrolled: TBooleanField
      FieldName = 'Kontrolled'
    end
    object cdsUdLinestest: TStringField
      FieldKind = fkCalculated
      FieldName = 'test'
      Size = 30
      Calculated = True
    end
    object cdsUdLinesVareName: TStringField
      FieldName = 'VareName'
      Size = 50
    end
    object cdsUdLinesEjSubst: TBooleanField
      FieldName = 'EjSubst'
    end
    object cdsUdLinesKlausuleret: TBooleanField
      FieldName = 'Klausuleret'
    end
    object cdsUdLinesRegel4243: TBooleanField
      FieldName = 'Regel4243'
    end
    object cdsUdLinesAndreTilskud: TBooleanField
      FieldName = 'AndreTilskud'
    end
    object cdsUdLinesIndikKode: TIntegerField
      FieldName = 'IndikKode'
    end
    object cdsUdLinesGammeltVarenr: TStringField
      FieldName = 'GammeltVarenr'
    end
    object cdsUdLinesRetVarenrInfo: TStringField
      FieldKind = fkCalculated
      FieldName = 'RetVarenrInfo'
      Size = 50
      Calculated = True
    end
    object cdsUdLinesRetVareNrDato: TDateTimeField
      FieldName = 'RetVareNrDato'
    end
    object cdsUdLinesLinenumber: TIntegerField
      FieldKind = fkCalculated
      FieldName = 'Linenumber'
      Calculated = True
    end
    object cdsUdLinesOrdid: TStringField
      FieldName = 'Ordid'
      Size = 50
    end
  end
  object ffPat: TnxTable
    TableName = 'PatientKartotek'
    ReadOnly = True
    Left = 96
    Top = 168
    object ffPatKundeNr: TStringField
      FieldName = 'KundeNr'
    end
    object ffPatNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object ffPatAdr1: TStringField
      FieldName = 'Adr1'
      Size = 30
    end
    object ffPatAdr2: TStringField
      FieldName = 'Adr2'
      Size = 30
    end
    object ffPatPostNr: TStringField
      FieldName = 'PostNr'
    end
    object ffPatYderNr: TStringField
      FieldName = 'YderNr'
      Size = 10
    end
    object ffPatAmt: TWordField
      FieldName = 'Amt'
    end
    object ffPatBarn: TBooleanField
      FieldName = 'Barn'
    end
    object ffPatDebitorNr: TStringField
      FieldName = 'DebitorNr'
    end
    object ffPatYderCprNr: TStringField
      FieldName = 'YderCprNr'
      Size = 10
    end
  end
  object ffFirm: TnxTable
    TableName = 'FirmaOplysninger'
    Left = 144
    Top = 168
    object ffFirmNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object ffFirmTlfNr: TStringField
      FieldName = 'TlfNr'
      Size = 30
    end
    object ffFirmTelefax: TStringField
      FieldName = 'Telefax'
      Size = 30
    end
  end
  object ffDCPARAMS: TnxTable
    TableName = 'DosisParams'
    Left = 192
    Top = 168
    object ffDCPARAMSKuvertnr: TIntegerField
      FieldName = 'Kuvertnr'
    end
    object ffDCPARAMSBrevNr: TIntegerField
      FieldName = 'BrevNr'
    end
    object ffDCPARAMSAfsLok: TStringField
      FieldName = 'AfsLok'
      Size = 40
    end
    object ffDCPARAMSAfsIdentifikation: TStringField
      FieldName = 'AfsIdentifikation'
    end
    object ffDCPARAMSAfSenderNavn: TStringField
      FieldName = 'AfSenderNavn'
      Size = 70
    end
    object ffDCPARAMSModtLok: TStringField
      FieldName = 'ModtLok'
      Size = 40
    end
    object ffDCPARAMSModtIdentifikation: TStringField
      FieldName = 'ModtIdentifikation'
    end
    object ffDCPARAMSModtagerNavn: TStringField
      FieldName = 'ModtagerNavn'
      Size = 70
    end
    object ffDCPARAMSUdlevApoNr: TStringField
      FieldName = 'UdlevApoNr'
      Size = 10
    end
    object ffDCPARAMSDAServerUser: TStringField
      FieldName = 'DAServerUser'
    end
    object ffDCPARAMSDAServerPass: TStringField
      FieldName = 'DAServerPass'
    end
    object ffDCPARAMSPrintPages: TIntegerField
      FieldName = 'PrintPages'
    end
  end
  object ffLag: TnxTable
    FilterOptions = [foCaseInsensitive]
    TableName = 'LagerKartotek'
    ReadOnly = True
    Left = 248
    Top = 168
    object ffLagLager: TWordField
      FieldName = 'Lager'
    end
    object ffLagVareNr: TStringField
      FieldName = 'VareNr'
    end
    object ffLagDrugId: TStringField
      FieldName = 'DrugId'
      Size = 11
    end
    object ffLagNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object ffLagForm: TStringField
      FieldName = 'Form'
    end
    object ffLagStyrke: TStringField
      FieldName = 'Styrke'
    end
  end
end
