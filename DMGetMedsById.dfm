object DMRSGetMeds: TDMRSGetMeds
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 344
  Width = 522
  object nxRSEkspeditioner: TnxTable
    TableName = 'RS_Ekspeditioner'
    Left = 192
    Top = 88
  end
  object nxRSEkspLinier: TnxTable
    TableName = 'RS_Eksplinier'
    Left = 280
    Top = 88
  end
  object nxSettings: TnxTable
    Tag = 1
    TableName = 'RS_Settings'
    Left = 88
    Top = 88
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
      LookupDataSet = nxAfdefling
      LookupKeyFields = 'RefNr'
      LookupResultField = 'LmsPNr'
      KeyFields = 'Afdeling'
      Size = 10
      Lookup = True
    end
    object nxSettingsPapirType1: TIntegerField
      FieldName = 'PapirType1'
    end
    object nxSettingsPapirType2: TIntegerField
      FieldName = 'PapirType2'
    end
    object nxSettingsLager: TIntegerField
      FieldName = 'Lager'
    end
  end
  object nxAfdefling: TnxTable
    TableName = 'AfdelingsNavne'
    Left = 272
    Top = 32
    object nxAfdeflingType: TStringField
      FieldName = 'Type'
      Size = 21
    end
    object nxAfdeflingOperation: TStringField
      FieldName = 'Operation'
      Size = 21
    end
    object nxAfdeflingNavn: TStringField
      FieldName = 'Navn'
      Size = 21
    end
    object nxAfdeflingRefNr: TIntegerField
      FieldName = 'RefNr'
    end
    object nxAfdeflingLmsPNr: TStringField
      FieldName = 'LmsPNr'
      Size = 11
    end
    object nxAfdeflingLmsNr: TStringField
      FieldName = 'LmsNr'
      Size = 6
    end
  end
  object nxdb: TnxDatabase
    AliasName = 'produktion'
    Left = 216
    Top = 24
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
    Left = 72
    Top = 168
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
end
