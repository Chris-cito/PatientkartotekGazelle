object SMSDM: TSMSDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 273
  Width = 451
  object SQLConnection1: TSQLConnection
    ConnectionName = 'SMSServer'
    DriverName = 'DATASNAP'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=DBXDataSnap'
      'DatasnapContext=datasnap/'
      
        'DriverAssemblyLoader=Borland.Data.TDBXClientDriverLoader,Borland' +
        '.Data.DbxClientDriver,Version=15.0.0.0,Culture=neutral,PublicKey' +
        'Token=91d62ebb5b0d1b1b'
      'drivername=DATASNAP'
      'Port=21101'
      'CommunicationProtocol=tcp/ip'
      'HostName=127.0.0.1'
      'Filters={}'
      
        'ConnectionString=DriverUnit=DBXDataSnap,DatasnapContext=datasnap' +
        '/,DriverAssemblyLoader=Borland.Data.TDBXClientDriverLoader,Borla' +
        'nd.Data.DbxClientDriver,Version=15.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b,drivername=DATASNAP,Port=21101,Communic' +
        'ationProtocol=tcp/ip,HostName=127.0.0.1,Filters={}')
    Left = 32
    Top = 8
    UniqueId = '{E0325DD1-73E3-468C-9E42-777D57F2403A}'
  end
  object DSProviderConnection1: TDSProviderConnection
    ServerClassName = 'TServerMethods1'
    SQLConnection = SQLConnection1
    Left = 184
    Top = 56
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    CommandText = 'select  Kundenr,Message,SendTime from smsbesked'
    Params = <>
    ProviderName = 'dspGeneral'
    RemoteServer = DSProviderConnection1
    Left = 216
    Top = 128
  end
  object nxQuery1: TnxQuery
    Left = 64
    Top = 184
  end
end
