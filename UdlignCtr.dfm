object CtrUdlignForm: TCtrUdlignForm
  Left = 246
  Top = 227
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Foretag udligning i CTR A'
  ClientHeight = 353
  ClientWidth = 664
  Color = clMaroon
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object dbgUdlign: TDBGrid
    Left = 0
    Top = 0
    Width = 664
    Height = 245
    Align = alClient
    DataSource = dsUdl
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object gbUdlign: TGroupBox
    Left = 0
    Top = 245
    Width = 664
    Height = 108
    Align = alBottom
    Color = clBtnFace
    ParentBackground = False
    ParentColor = False
    TabOrder = 0
    DesignSize = (
      664
      108)
    object laUdlign: TLabel
      Left = 29
      Top = 24
      Width = 57
      Height = 16
      Alignment = taRightJustify
      Caption = '&Udligning'
      FocusControl = meUdlign
    end
    object laSaldo: TLabel
      Left = 50
      Top = 50
      Width = 36
      Height = 16
      Alignment = taRightJustify
      Caption = 'Saldo'
    end
    object laUdlign2: TLabel
      Left = 217
      Top = 23
      Width = 69
      Height = 16
      Caption = 'Bel'#248'b i '#248'rer'
    end
    object laStempel: TLabel
      Left = 11
      Top = 75
      Width = 75
      Height = 16
      Alignment = taRightJustify
      Caption = 'Tidsstempel'
    end
    object meUdlign: TMaskEdit
      Left = 90
      Top = 20
      Width = 120
      Height = 24
      Hint = 'Udligning i '#248'rer'
      TabOrder = 0
      Text = ''
    end
    object meSaldo: TMaskEdit
      Left = 90
      Top = 46
      Width = 120
      Height = 24
      Hint = 'Saldo i CTR'
      TabStop = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
      Text = ''
    end
    object buGodkend: TBitBtn
      Left = 446
      Top = 63
      Width = 100
      Height = 33
      Hint = 'Godkend udligning med angivet bel'#248'b'
      Anchors = [akTop, akRight]
      Caption = '&Godkend'
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 5
      OnClick = buGodkendClick
    end
    object buFortryd: TBitBtn
      Left = 550
      Top = 63
      Width = 100
      Height = 33
      Hint = 'Fortryd udligning'
      Anchors = [akTop, akRight]
      Caption = 'Fortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 6
    end
    object buListe: TBitBtn
      Left = 342
      Top = 63
      Width = 100
      Height = 33
      Hint = 'Vis poster fra CTR-liste '
      Anchors = [akTop, akRight]
      Caption = '&CTR-liste'
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333330000330000000000000000330000330FFFFFFFFFFFFFF0330000330F
        FFFFFFFFFFFFF0330000330F0F0000F0F000F0330000330FFFFFFFFFFFFFF033
        0000330F000F0F00F0F0F0330000330FFFFFFFFFFFFFF0330000330F0F0F00F0
        F000F0330000330FFFFFFFFFFFFFF0330000330F00F0F0F0000FF0330000330F
        FFFFFFFFFFFFF0330000330F00F00F0F0000F0330000330FFFFFFFFFFFFFF033
        0000330F0F000F00F0F0F0330000330FFFFFFFFFFFFFF0330000330F000FF00F
        0F00F0330000330FFFFFFFFFFFFFF03300003300000000000000003300003333
        33333333333333330000}
      TabOrder = 4
      TabStop = False
      OnClick = buListeClick
    end
    object dbeStempel: TDBEdit
      Left = 90
      Top = 72
      Width = 120
      Height = 24
      TabStop = False
      Color = clBtnFace
      DataField = 'Stempel'
      DataSource = dsUdl
      ReadOnly = True
      TabOrder = 2
    end
    object paPeriode: TPanel
      Left = 342
      Top = 20
      Width = 308
      Height = 36
      Anchors = [akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 3
      object rbForrige: TRadioButton
        Left = 10
        Top = 10
        Width = 111
        Height = 17
        Caption = 'Forrige'
        TabOrder = 0
        OnClick = rbForrigeClick
      end
      object rbAktuelle: TRadioButton
        Left = 140
        Top = 10
        Width = 157
        Height = 17
        Caption = 'Aktuelle'
        TabOrder = 1
        OnClick = rbAktuelleClick
      end
    end
  end
  object dsUdl: TDataSource
    DataSet = mtUdl
    Left = 16
    Top = 243
  end
  object mtUdl: TClientDataSet
    PersistDataPacket.Data = {
      DC0000009619E0BD010000001800000008000000000003000000DC000541706F
      4E720100490000000100055749445448020002000F0006456B73704E72040001
      0000000000054F72644E720200020000000000075374656D70656C0800080000
      00000003424750080004000000010007535542545950450200490006004D6F6E
      65790003494254080004000000010007535542545950450200490006004D6F6E
      6579000553616C646F080004000000010007535542545950450200490006004D
      6F6E6579000446656A6C0100490000000100055749445448020002001E000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ApoNr'
        DataType = ftString
        Size = 15
      end
      item
        Name = 'EkspNr'
        DataType = ftInteger
      end
      item
        Name = 'OrdNr'
        DataType = ftWord
      end
      item
        Name = 'Stempel'
        DataType = ftDateTime
      end
      item
        Name = 'BGP'
        DataType = ftCurrency
      end
      item
        Name = 'IBT'
        DataType = ftCurrency
      end
      item
        Name = 'Saldo'
        DataType = ftCurrency
      end
      item
        Name = 'Fejl'
        DataType = ftString
        Size = 30
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 80
    Top = 240
    object mtUdlApoNr: TStringField
      DisplayLabel = 'Apotek'
      DisplayWidth = 7
      FieldName = 'ApoNr'
      Size = 15
    end
    object mtUdlEkspNr: TIntegerField
      DisplayLabel = 'Eksp.nr'
      DisplayWidth = 7
      FieldName = 'EkspNr'
    end
    object mtUdlOrdNr: TWordField
      DisplayLabel = 'Ord.nr'
      DisplayWidth = 5
      FieldName = 'OrdNr'
    end
    object mtUdlStempel: TDateTimeField
      DisplayWidth = 14
      FieldName = 'Stempel'
      DisplayFormat = 'dd-mm-yyyy hh:mm'
    end
    object mtUdlBGP: TCurrencyField
      DisplayWidth = 11
      FieldName = 'BGP'
      DisplayFormat = '##,###,##0.00'
    end
    object mtUdlIBT: TCurrencyField
      DisplayWidth = 11
      FieldName = 'IBT'
      DisplayFormat = '##,###,##0.00'
    end
    object mtUdlSaldo: TCurrencyField
      DisplayWidth = 11
      FieldName = 'Saldo'
      DisplayFormat = '##,###,##0.00'
    end
    object mtUdlFejl: TStringField
      DisplayWidth = 20
      FieldName = 'Fejl'
      Size = 30
    end
  end
end
