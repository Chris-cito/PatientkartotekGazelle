object frmNomecoStk: TfrmNomecoStk
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Grossistreservation'
  ClientHeight = 385
  ClientWidth = 876
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 876
    Height = 305
    Align = alTop
    Checkboxes = True
    Columns = <
      item
        Caption = 'Varenr'
        Width = 75
      end
      item
        Alignment = taRightJustify
        Caption = 'Gros'
        Width = 35
      end
      item
        Alignment = taRightJustify
        Caption = 'Apo'
        Width = 35
      end
      item
        Caption = 'Navn'
        Width = 150
      end
      item
        Caption = 'Form'
        Width = 80
      end
      item
        Caption = 'Styrke'
        Width = 80
      end
      item
        Caption = 'Pakn'
        Width = 75
      end
      item
        Alignment = taCenter
        Caption = 'ABC'
      end
      item
        Alignment = taCenter
        Caption = 'C'
      end
      item
        Caption = 'Enh. Pris'
        Width = 60
      end
      item
        Caption = 'Udl'#248'b dato'
        Width = 64
      end
      item
        Caption = 'udl Flag'
      end
      item
        Caption = 'Tekst'
        Width = 125
      end>
    TabOrder = 0
    ViewStyle = vsReport
    OnCompare = ListView1Compare
    OnCustomDrawItem = ListView1CustomDrawItem
    OnCustomDrawSubItem = ListView1CustomDrawSubItem
    OnItemChecked = ListView1ItemChecked
  end
  object btnSearch: TButton
    Left = 265
    Top = 331
    Width = 75
    Height = 25
    Caption = 'S'#248'g'
    TabOrder = 1
    Visible = False
    OnClick = btnSearchClick
  end
  object btnVaelg: TButton
    Left = 8
    Top = 331
    Width = 75
    Height = 25
    Caption = '&V'#230'lg vare'
    TabOrder = 2
    OnClick = btnVaelgClick
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
    Top = 40
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 20000
    OnTimer = Timer1Timer
    Left = 120
    Top = 40
  end
  object nxLag: TnxTable
    TableName = 'LagerKartotek'
    Left = 392
    Top = 64
    object nxLagNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object nxLagForm: TStringField
      FieldName = 'Form'
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
    object nxLagAntal: TIntegerField
      FieldName = 'Antal'
    end
    object nxLagSubKode: TStringField
      FieldName = 'SubKode'
      Size = 1
    end
    object nxLagSalgsPris: TCurrencyField
      FieldName = 'SalgsPris'
    end
    object nxLagBGP: TCurrencyField
      FieldName = 'BGP'
    end
    object nxLagSSKode: TStringField
      FieldName = 'SSKode'
      Size = 2
    end
    object nxLagEnhedsPris: TCurrencyField
      FieldName = 'EnhedsPris'
    end
    object nxLagEgenPris: TCurrencyField
      FieldName = 'EgenPris'
    end
    object nxLagPaknNum: TIntegerField
      FieldName = 'PaknNum'
    end
    object nxLagSubEnhPris: TCurrencyField
      FieldName = 'SubEnhPris'
    end
  end
  object nxQuery1: TnxQuery
    Left = 352
    Top = 80
  end
end
