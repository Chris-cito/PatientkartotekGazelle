object frmPIBNom: TfrmPIBNom
  Left = 0
  Top = 0
  Caption = 'Vareinfo'
  ClientHeight = 355
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
      TabOrder = 0
    end
    object DBEdit2: TDBEdit
      Left = 328
      Top = 32
      Width = 394
      Height = 27
      DataField = 'Navn'
      DataSource = DataSource1
      TabOrder = 1
    end
    object DBEdit3: TDBEdit
      Left = 16
      Top = 97
      Width = 654
      Height = 27
      DataField = 'SalgsTekst'
      DataSource = DataSource1
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 129
    Width = 744
    Height = 208
    Align = alTop
    Caption = 'Panel2'
    TabOrder = 1
    object ListView2: TListView
      Left = 1
      Top = 1
      Width = 742
      Height = 206
      Align = alClient
      Columns = <
        item
          Caption = 'Tekst'
          Width = 190
        end
        item
          Caption = 'Varenr'
          Width = 100
        end
        item
          Caption = 'Navn'
          Width = 220
        end
        item
          Caption = 'Stk'
          Width = 35
        end
        item
          Caption = 'Lok'
        end
        item
          Caption = 'Pris'
          Width = 70
        end
        item
          Caption = 'K'#230'de'
          Width = 70
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object WSocket1: TWSocket
    LineEnd = #13#10
    Proto = 'tcp'
    LocalAddr = '0.0.0.0'
    LocalAddr6 = '::'
    LocalPort = '0'
    SocksLevel = '5'
    ComponentOptions = []
    OnDataAvailable = WSocket1DataAvailable
    OnDataSent = WSocket1DataSent
    OnSessionConnected = WSocket1SessionConnected
    OnError = WSocket1Error
    OnBgException = WSocket1BgException
    Left = 24
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = Timer1Timer
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
  end
  object DataSource1: TDataSource
    DataSet = nxLag
    Left = 368
    Top = 184
  end
end
