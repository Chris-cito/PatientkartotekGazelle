object frmPIBVarTMJ: TfrmPIBVarTMJ
  Left = 0
  Top = 0
  Caption = 'TMJ Vareinfo'
  ClientHeight = 512
  ClientWidth = 744
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 744
    Height = 129
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 49
      Height = 19
      Caption = 'VareNr'
      FocusControl = DBEdit1
    end
    object Label2: TLabel
      Left = 328
      Top = 16
      Width = 36
      Height = 19
      Caption = 'Navn'
      FocusControl = DBEdit2
    end
    object Label3: TLabel
      Left = 16
      Top = 80
      Width = 75
      Height = 19
      Caption = 'SalgsTekst'
      FocusControl = DBEdit3
    end
    object DBEdit1: TDBEdit
      Left = 16
      Top = 32
      Width = 264
      Height = 27
      DataField = 'VareNr'
      DataSource = DataSource1
      ReadOnly = True
      TabOrder = 0
    end
    object DBEdit2: TDBEdit
      Left = 328
      Top = 32
      Width = 394
      Height = 27
      DataField = 'Navn'
      DataSource = DataSource1
      ReadOnly = True
      TabOrder = 1
    end
    object DBEdit3: TDBEdit
      Left = 16
      Top = 97
      Width = 654
      Height = 27
      DataField = 'SalgsTekst'
      DataSource = DataSource1
      ReadOnly = True
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 129
    Width = 744
    Height = 104
    Align = alTop
    Caption = 'Panel2'
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 742
      Height = 102
      Align = alClient
      DataSource = dsReactions
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 233
    Width = 744
    Height = 279
    Align = alClient
    TabOrder = 2
    object DBGrid2: TDBGrid
      Left = 1
      Top = 1
      Width = 742
      Height = 277
      Align = alClient
      DataSource = dsSuggestions
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnKeyDown = DBGrid2KeyDown
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 300000
    Left = 120
    Top = 16
  end
  object nxLag: TnxTable
    ActiveRuntime = True
    Session = MainDm.nxSess
    AliasName = 'Produktion'
    TableName = 'LagerKartotek'
    Left = 392
    Top = 64
    object nxLagForm: TStringField
      FieldName = 'Form'
    end
    object nxLagNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object nxLagStyrke: TStringField
      FieldName = 'Styrke'
    end
    object nxLagPakning: TStringField
      FieldName = 'Pakning'
      Size = 30
    end
    object nxLagLager: TWordField
      FieldName = 'Lager'
    end
    object nxLagVareNr: TStringField
      FieldName = 'VareNr'
    end
    object nxLagSalgsTekst: TStringField
      FieldName = 'SalgsTekst'
      Size = 50
    end
    object nxLagVareInfo: TIntegerField
      FieldName = 'VareInfo'
    end
    object nxLagLokation1: TIntegerField
      FieldName = 'Lokation1'
    end
    object nxLagAntal: TIntegerField
      FieldName = 'Antal'
    end
    object nxLagSalgsPris: TCurrencyField
      FieldName = 'SalgsPris'
    end
    object nxLagAtcKode: TStringField
      FieldName = 'AtcKode'
      Size = 15
    end
  end
  object DataSource1: TDataSource
    DataSet = nxLag
    Left = 352
    Top = 64
  end
  object cdsSuggestions: TClientDataSet
    Active = True
    Aggregates = <>
    DataSetField = cdsReactionsSuggestedItems
    FieldDefs = <
      item
        Name = 'Form'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'ItenId'
        DataType = ftInteger
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'Strength'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Chain'
        DataType = ftInteger
      end
      item
        Name = 'Anbefaling'
        DataType = ftString
        Size = 100
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    OnCalcFields = cdsSuggestionsCalcFields
    Left = 520
    Top = 392
    object cdsSuggestionsAnbefaling: TStringField
      DisplayWidth = 60
      FieldKind = fkInternalCalc
      FieldName = 'Anbefaling'
      Size = 100
    end
    object cdsSuggestionsForm: TStringField
      FieldName = 'Form'
      Visible = False
      Size = 30
    end
    object cdsSuggestionsItenId: TIntegerField
      FieldName = 'ItenId'
      Visible = False
      DisplayFormat = '000000'
    end
    object cdsSuggestionsName: TStringField
      FieldName = 'Name'
      Visible = False
      Size = 50
    end
    object cdsSuggestionsStrength: TStringField
      FieldName = 'Strength'
      Visible = False
      Size = 30
    end
    object cdsSuggestionsChain: TIntegerField
      Alignment = taLeftJustify
      DisplayLabel = 'K'#230'de'
      FieldName = 'Chain'
      OnGetText = cdsSuggestionsChainGetText
    end
  end
  object cdsReactions: TClientDataSet
    Active = True
    Aggregates = <>
    DataSetField = cdsHeaderLines
    FieldDefs = <
      item
        Name = 'Category'
        DataType = ftInteger
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'SuggestedItems'
        DataType = ftDataSet
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 448
    Top = 176
    object cdsReactionsCategory: TIntegerField
      FieldName = 'Category'
      Visible = False
    end
    object cdsReactionsName: TStringField
      DisplayLabel = 'Bivirkning'
      FieldName = 'Name'
      Size = 50
    end
    object cdsReactionsSuggestedItems: TDataSetField
      FieldName = 'SuggestedItems'
      Visible = False
    end
  end
  object cdsHeader: TClientDataSet
    PersistDataPacket.Data = {
      F40000009619E0BD02000000180000000A000000000003000000F40006566172
      656E720100490000000100055749445448020002000A00054C696E657308000E
      05000000000843617465676F72790400010000000000044E616D650100490000
      0001000557494454480200020032000E5375676765737465644974656D730500
      0E050000000004466F726D0100490000000100055749445448020002001E0006
      4974656E49640400010000000000044E616D6501004900000001000557494454
      4802000200320008537472656E67746801004900000001000557494454480200
      02001E0005436861696E0400010000000000000000000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 312
    Top = 24
    object cdsHeaderVarenr: TStringField
      FieldName = 'Varenr'
      Size = 10
    end
    object cdsHeaderLines: TDataSetField
      FieldName = 'Lines'
      Visible = False
    end
  end
  object dsReactions: TDataSource
    DataSet = cdsReactions
    Left = 352
    Top = 168
  end
  object dsSuggestions: TDataSource
    DataSet = cdsSuggestions
    Left = 384
    Top = 344
  end
end
