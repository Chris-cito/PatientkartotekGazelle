object SubstForm: TSubstForm
  Left = 85
  Top = 40
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Vare- s'#248'gning og substitution'
  ClientHeight = 511
  ClientWidth = 834
  Color = clBtnFace
  Constraints.MinHeight = 540
  Constraints.MinWidth = 840
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object paSub: TPanel
    Left = 0
    Top = 271
    Width = 834
    Height = 240
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object paSubBut: TPanel
      Left = 0
      Top = 192
      Width = 834
      Height = 48
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      DesignSize = (
        834
        48)
      object buFortryd: TBitBtn
        Left = 728
        Top = 8
        Width = 100
        Height = 34
        Hint = 'Fortryd s'#248'gning og returner til taksering'
        Anchors = [akRight, akBottom]
        Caption = '&Fortryd'
        Kind = bkCancel
        NumGlyphs = 2
        TabOrder = 0
        TabStop = False
        OnClick = buFortrydClick
      end
      object paReserver: TPanel
        Left = 1
        Top = 1
        Width = 393
        Height = 46
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 3
        DesignSize = (
          393
          46)
        object laVareNr: TLabel
          Left = 8
          Top = 17
          Width = 49
          Height = 16
          Alignment = taRightJustify
          Anchors = [akRight, akBottom]
          Caption = '&Grossist'
          FocusControl = dblKonti
        end
        object buReserv: TBitBtn
          Left = 287
          Top = 7
          Width = 100
          Height = 34
          Hint = 'Reserver vare hos Max Jenne'
          Anchors = [akRight, akBottom]
          Caption = '&Reserver'
          Glyph.Data = {
            66010000424D6601000000000000760000002800000014000000140000000100
            040000000000F000000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
            5555555500005550000000055555555500005509999999005555555500005099
            9999990105555555000000111111110110555555000000000000000011055555
            0000501111111110011055550000550FFFFFFFF0F011055500005550FFFFFFF0
            F0011055000055550F800000F0F011050000555550FFFFFFF0F0010500005555
            550F800000F0F005000055555550FFFFFFF0F0050000555555550F800000F055
            00005555555550FFFFFFF055000055555555550F800000550000555555555550
            0055555500005555555555555555555500005555555555555555555500005555
            55555555555555550000}
          TabOrder = 0
          TabStop = False
          OnClick = buReservClick
        end
        object dblKonti: TDBLookupComboBox
          Left = 64
          Top = 12
          Width = 217
          Height = 24
          Anchors = [akTop, akRight]
          DataField = 'GrNr'
          DataSource = MainDm.dsGro
          KeyField = 'GrNr'
          ListField = 'FullNavn'
          ListSource = MainDm.dsKto
          TabOrder = 1
        end
      end
      object bitMini: TBitBtn
        Left = 502
        Top = 8
        Width = 100
        Height = 34
        Caption = '&Mini Info'
        TabOrder = 1
        Visible = False
        OnClick = bitMiniClick
      end
      object BitBtn1VisEksp: TBitBtn
        Left = 610
        Top = 8
        Width = 100
        Height = 34
        Caption = '&Vis Eksp'
        TabOrder = 2
        OnClick = BitBtn1VisEkspClick
      end
      object bitNaermeste: TBitBtn
        Left = 394
        Top = 8
        Width = 100
        Height = 34
        Action = acNaemeste
        Caption = 'N&'#230'rmeste Apo'
        TabOrder = 4
        Visible = False
      end
    end
    object grSub: TDBGrid
      Left = 0
      Top = 0
      Width = 834
      Height = 192
      Align = alClient
      DataSource = dsSubst
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDrawColumnCell = grSubDrawColumnCell
      OnEnter = grSubEnter
      OnExit = grSubExit
      OnKeyDown = grSubKeyDown
      OnKeyPress = grSubKeyPress
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'MU'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Subnr'
          Title.Caption = 'Varenr'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Navn'
          Width = 171
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Pakning'
          Width = 119
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'AntPkn'
          Title.Caption = 'Ant.Pkn'
          Width = 42
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Kode'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CTilsk'
          Title.Caption = 'C'
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'PI'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Antal'
          Title.Alignment = taRightJustify
          Width = 50
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Forvalg'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Enhedspris'
          Title.Alignment = taRightJustify
          Width = 57
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Salgspris'
          Title.Alignment = taRightJustify
          Width = 57
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'lokation1'
          Title.Caption = 'Lok'
          Width = 28
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'skaffe'
          Title.Caption = 'L'
          Width = 10
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RO'
          Width = 27
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NySubKode'
          Title.Caption = 'Ny ABC'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GrLevSvigtDato'
          Title.Caption = 'GrLSDato'
          Width = 50
          Visible = True
        end>
    end
  end
  object paTak: TPanel
    Left = 0
    Top = 0
    Width = 834
    Height = 271
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object paTakBut: TPanel
      Left = 0
      Top = 0
      Width = 834
      Height = 30
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 12
        Top = 7
        Width = 50
        Height = 16
        Caption = '&S'#248'gning'
        FocusControl = eSoeg
      end
      object lbl1: TLabel
        Left = 320
        Top = 8
        Width = 60
        Height = 16
        AutoSize = False
        Caption = 'lbl&1'
        FocusControl = grTak
        Visible = False
      end
      object lbl2: TLabel
        Left = 408
        Top = 8
        Width = 21
        Height = 16
        Caption = 'lbl&2'
        FocusControl = grSub
        Visible = False
      end
      object eSoeg: TEdit
        Left = 72
        Top = 3
        Width = 200
        Height = 24
        TabOrder = 0
        OnEnter = eSoegEnter
        OnKeyPress = eSoegKeyPress
      end
      object chkVareLevsvigt: TCheckBox
        Left = 432
        Top = 7
        Width = 297
        Height = 17
        Caption = 'Vis kun &udg'#229'ede varer, hvis de er p'#229' lager.'
        TabOrder = 1
        OnClick = chkVareLevsvigtClick
      end
    end
    object grTak: TDBGrid
      Left = 0
      Top = 30
      Width = 834
      Height = 241
      Align = alClient
      DataSource = dsTakst
      Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDrawColumnCell = grTakDrawColumnCell
      OnEnter = grTakEnter
      OnExit = grTakExit
      OnKeyDown = grTakKeyDown
      OnKeyPress = grTakKeyPress
      Columns = <
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'MU'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Varenr'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Navn'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Pakning'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Form'
          Width = 86
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Styrke'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EnhedsPris'
          Width = 57
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'SubKode'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'PI'
          Title.Alignment = taCenter
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'lokation1'
          Title.Caption = 'Lok.'
          Width = 30
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Antal'
          Title.Alignment = taRightJustify
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'skaffe'
          Title.Caption = 'L'
          Width = 10
          Visible = True
        end>
    end
  end
  object fqTakst: TnxQuery
    Timeout = 30000
    SQL.Strings = (
      'SELECT'
      '  CASE'
      '    WHEN V.Sletdato is NULL THEN '#39#39
      '    ELSE '#39'*'#39' END AS MU,'
      '  V.Varenr,'
      '  V.Navn,'
      '  V.Form,'
      '  V.Styrke,'
      '  V.Pakning,'
      '  V.PaKode AS PI,'
      '  COALESCE(V.Antal, 0) AS Antal,'
      '  V.FormKode,'
      '  V.SubKode,'
      '  V.StyrkeNum,'
      '  V.PaknNum,'
      '  (case when v.egenpris<>0 '
      #9'THEN '
      #9#9'(case WHEN V.Paknnum = 0 '
      #9#9#9'then'
      #9#9#9#9'v.SUBENHpris'
      #9#9#9'ELSE'
      #9#9#9#9'((V.EGENPRIS+o.rcpgebyr)/(V.PaknNum/100.0))'
      #9#9'END)'
      #9#9#9
      #9'ELSE V.SubEnhPris '
      '  END) as EnhedsPris,'
      #9'(case when v.minimum=-1'
      #9#9'then'
      #9#9#9'(case when v.genbestil=1'
      #9#9#9#9'then '#39'-1/1'#39
      #9#9#9#9'else '#39#39
      #9#9#9'end)'
      #9#9'else'
      #9#9#9#39#39
      '   '#9'end) as skaffe'
      '  '
      'FROM'
      '  LagerKartotek AS V,'
      '  RecepturOplysninger AS O'
      'WHERE'
      '  V.Lager=0 AND '
      '  V.AfmDato IS NULL'
      'ORDER BY'
      '  Navn,'
      '  Formkode,'
      '  StyrkeNum,'
      '  PaknNum')
    Left = 688
    Top = 56
    object fqTakstMU: TStringField
      FieldName = 'MU'
      Size = 1
    end
    object fqTakstVarenr: TStringField
      FieldName = 'Varenr'
    end
    object fqTakstNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object fqTakstForm: TStringField
      FieldName = 'Form'
    end
    object fqTakstStyrke: TStringField
      FieldName = 'Styrke'
    end
    object fqTakstPakning: TStringField
      FieldName = 'Pakning'
      Size = 30
    end
    object fqTakstPI: TStringField
      FieldName = 'PI'
      Size = 2
    end
    object fqTakstAntal: TIntegerField
      FieldName = 'Antal'
    end
    object fqTakstFormKode: TStringField
      FieldName = 'FormKode'
      Size = 7
    end
    object fqTakstSubKode: TStringField
      FieldName = 'SubKode'
      Size = 1
    end
    object fqTakstStyrkeNum: TIntegerField
      FieldName = 'StyrkeNum'
    end
    object fqTakstPaknNum: TIntegerField
      FieldName = 'PaknNum'
    end
    object fqTakstEnhedsPris: TCurrencyField
      FieldName = 'EnhedsPris'
    end
    object fqTakstskaffe: TStringField
      FieldName = 'skaffe'
      Size = 4
    end
  end
  object dpSubst: TDataSetProvider
    DataSet = fqSubst
    Left = 744
    Top = 336
  end
  object fqSubst: TnxQuery
    Timeout = 30000
    SQL.Strings = (
      'SELECT'
      #9'S.VareNr,'
      '  '#9'S.Subnr,'
      #9'(case when s.antpkn = 0 '
      #9#9'THEN'
      #9'  '#9#9'V.SubKode'
      #9#9'ELSE'
      #9#9#9#39' '#39
      #9'END) AS Kode,'
      '  '#9'(CASE WHEN V.SletDato IS NULL THEN '#39#39' ELSE '#39'*'#39' END) AS MU,'
      #9'V.Navn,'
      '  '#9'V.Form,'
      '  '#9'V.Styrke,'
      '  '#9'V.Pakning,'
      '                V.GrLevSvigtDato, '
      '                V.NySubKode'
      #9'(case when s.antpkn = 0 '
      #9#9'THEN'
      #9'  '#9#9'V.PaKode'
      #9#9'ELSE'
      #9#9#9#39' '#39
      #9'END) AS PI,'
      '  '#9'COALESCE(V.Antal, 0) AS Antal,'
      '  '#9'V.SubForvalg AS Forvalg,'
      '  '#9'(case when v.egenpris<>0 '
      #9#9'THEN '
      #9#9#9'(case WHEN V.Paknnum = 0 '
      #9#9#9'then'
      #9#9#9#9'v.SUBENHpris'
      #9#9#9'ELSE'
      #9#9#9#9'((V.EGENPRIS+O.Rcpgebyr)/(V.PaknNum/100.0))'
      #9#9#9'END)'
      #9#9#9
      #9#9'ELSE V.SubEnhPris '
      #9'END) as EnhedsPris,'
      #9'(CASE WHEN S.antpkn = 0 THEN'
      #9'  '#9'(CASE WHEN V.HaType<>'#39#39' '
      #9'   '#9#9'THEN '
      #9'   '#9#9#9'(CASE WHEN V.EgenPris<>0'
      '    '#9#9#9#9#9'THEN V.Egenpris + O.Rcpgebyr'
      '    '#9#9#9#9#9'ELSE V.Salgspris + O.Rcpgebyr'
      '    '#9#9#9#9'END)'
      '   '#9#9#9'ELSE '
      '   '#9#9#9#9'(CASE WHEN V.EgenPris<>0'
      '    '#9#9#9#9#9'THEN V.Egenpris'
      '    '#9#9#9#9#9'ELSE V.Salgspris'
      '    '#9#9#9#9'END)'
      #9#9'END)'
      #9'ELSE'
      #9#9'cast((s.LMS32Salgspris / 100.0) as money)'
      '   '#9'END) AS SalgsPris,'
      '   '#9'(case when s.antpkn = 0 then 1 else s.antpkn end) as antpkn,'
      #9'(case '#9'when v.minimum=-1 and v.genbestil=1 then '#39'-'#39
      #9#9'when v.minimum>=0 and v.genbestil>0 then '#39'+'#39
      #9#9'else '#39#39
      '   '#9'end) as skaffe,'
      #9'(CASE WHEN V.RESTORDRE <> 0 THEN '#39'RO'#39' ELSE '#39#39' END) AS RO,'
      #9'v.lokation1,'
      
        #9'(case when s.antpkn = 0 and V.subkode='#39'C'#39' and v.sskode in ('#39'A'#39',' +
        #39'S'#39','#39'V'#39') AND V.salgspris=V.BGP then'
      #9#9#39'*'#39
      #9'else'
      #9#9#39' '#39
      #9'END) AS CTilsk'
      #9
      ''
      '   '#9
      'FROM'
      '('
      #9'SELECT '
      #9#9'Varenr,'
      #9#9'SubNr,'
      #9#9'0 as antpkn,'
      #9#9'0 as LMS32Salgspris'
      #9#9
      #9'FROM'
      #9#9'LmsSubst '
      '//'#9'WHERE '
      '//'#9#9'Varenr IN (#PARAM#)'
      #9'UNION'
      #9'SELECT '
      #9#9'VarenrOrdin,'
      #9#9'VarenrAlt,'
      #9#9'Antal as antpkn,'
      #9#9'Salgspris   as LMS32Salgspris'
      #9#9
      #9'FROM'
      #9#9'LmsKombi '
      '//'#9'WHERE '
      '//'#9#9'VarenrOrdin IN (#PARAM#)'
      #9
      ') AS S,'
      #9' LagerKartotek AS V,'
      #9' RecepturOplysninger AS O'
      'WHERE'
      '//'#9'V.Lager=#LAGER# AND'
      #9'V.VareNr=S.SubNr AND'
      '  '#9'V.AfmDato IS NULL'
      'ORDER BY'
      '  '#9'S.VareNr,'
      '  '#9'EnhedsPris ASC,'
      #9'Salgspris ASC,'
      #9'Kode ASC,'
      '  '#9'V.PaKode ASC'
      '    ')
    Left = 744
    Top = 288
    object fqSubstVareNr: TStringField
      FieldName = 'VareNr'
      Size = 6
    end
    object fqSubstSubnr: TStringField
      FieldName = 'Subnr'
      Size = 6
    end
    object fqSubstKode: TStringField
      FieldName = 'Kode'
      Size = 1
    end
    object fqSubstMU: TStringField
      FieldName = 'MU'
      Size = 1
    end
    object fqSubstNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object fqSubstForm: TStringField
      FieldName = 'Form'
    end
    object fqSubstStyrke: TStringField
      FieldName = 'Styrke'
    end
    object fqSubstPakning: TStringField
      FieldName = 'Pakning'
      Size = 30
    end
    object fqSubstPI: TStringField
      FieldName = 'PI'
      Size = 2
    end
    object fqSubstAntal: TIntegerField
      FieldName = 'Antal'
    end
    object fqSubstForvalg: TStringField
      FieldName = 'Forvalg'
      Size = 1
    end
    object fqSubstEnhedspris: TCurrencyField
      FieldName = 'Enhedspris'
    end
    object fqSubstSalgspris: TCurrencyField
      FieldName = 'Salgspris'
    end
    object fqSubstAntpkn: TIntegerField
      FieldName = 'Antpkn'
    end
    object fqSubstskaffe: TStringField
      FieldName = 'skaffe'
      Size = 1
    end
    object fqSubstRO: TStringField
      FieldName = 'RO'
      Size = 2
    end
    object fqSubstlokation1: TIntegerField
      FieldName = 'lokation1'
    end
    object fqSubstCTilsk: TStringField
      FieldName = 'CTilsk'
      Size = 1
    end
    object fqSubstGrLevSvigtDato: TDateTimeField
      FieldName = 'GrLevSvigtDato'
    end
    object fqSubstNySubKode: TStringField
      FieldName = 'NySubKode'
      Size = 1
    end
  end
  object dsTakst: TDataSource
    AutoEdit = False
    DataSet = cdTakst
    Left = 688
    Top = 200
  end
  object cdTakst: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'MU'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'Varenr'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Navn'
        DataType = ftString
        Size = 30
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
        Name = 'PI'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'Antal'
        DataType = ftInteger
      end
      item
        Name = 'FormKode'
        DataType = ftString
        Size = 7
      end
      item
        Name = 'SubKode'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'StyrkeNum'
        DataType = ftInteger
      end
      item
        Name = 'PaknNum'
        DataType = ftInteger
      end
      item
        Name = 'EnhedsPris'
        DataType = ftCurrency
      end
      item
        Name = 'skaffe'
        DataType = ftString
        Size = 4
      end>
    IndexDefs = <
      item
        Name = 'TakstOrden'
        Fields = 'FormKode;StyrkeNum;PaknNum'
        Options = [ixPrimary, ixCaseInsensitive]
      end>
    Params = <>
    ProviderName = 'dpTakst'
    StoreDefs = True
    AfterScroll = cdTakstAfterScroll
    Left = 688
    Top = 152
    object cdTakstMU: TStringField
      DisplayLabel = 'U'
      FieldName = 'MU'
      Size = 1
    end
    object cdTakstVarenr: TStringField
      DisplayWidth = 6
      FieldName = 'Varenr'
    end
    object cdTakstNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object cdTakstForm: TStringField
      FieldName = 'Form'
    end
    object cdTakstStyrke: TStringField
      FieldName = 'Styrke'
    end
    object cdTakstPakning: TStringField
      FieldName = 'Pakning'
      Size = 30
    end
    object cdTakstPI: TStringField
      FieldName = 'PI'
      Size = 2
    end
    object cdTakstAntal: TIntegerField
      FieldName = 'Antal'
    end
    object cdTakstFormKode: TStringField
      FieldName = 'FormKode'
      Size = 7
    end
    object cdTakstSubKode: TStringField
      DisplayLabel = 'ABC'
      DisplayWidth = 3
      FieldName = 'SubKode'
      Size = 1
    end
    object cdTakstStyrkeNum: TIntegerField
      FieldName = 'StyrkeNum'
    end
    object cdTakstPaknNum: TIntegerField
      FieldName = 'PaknNum'
    end
    object cdTakstEnhedsPris: TCurrencyField
      FieldName = 'EnhedsPris'
    end
    object cdTakstskaffe: TStringField
      FieldName = 'skaffe'
      Size = 4
    end
  end
  object dpTakst: TDataSetProvider
    DataSet = fqTakst
    Left = 688
    Top = 104
  end
  object cdSubst: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'VareNr'
        DataType = ftString
        Size = 6
      end
      item
        Name = 'Subnr'
        DataType = ftString
        Size = 6
      end
      item
        Name = 'Kode'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'MU'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'Navn'
        DataType = ftString
        Size = 30
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
        Name = 'PI'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'Antal'
        DataType = ftInteger
      end
      item
        Name = 'Forvalg'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'Enhedspris'
        DataType = ftCurrency
      end
      item
        Name = 'Salgspris'
        DataType = ftCurrency
      end
      item
        Name = 'Antpkn'
        DataType = ftInteger
      end
      item
        Name = 'skaffe'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'RO'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'lokation1'
        DataType = ftInteger
      end
      item
        Name = 'CTilsk'
        DataType = ftString
        Size = 1
      end>
    IndexDefs = <>
    Params = <>
    ProviderName = 'dpSubst'
    StoreDefs = True
    Left = 744
    Top = 384
    object cdSubstMU: TStringField
      DisplayLabel = 'U'
      FieldName = 'MU'
      Size = 1
    end
    object cdSubstVareNr: TStringField
      DisplayLabel = 'Varenr'
      FieldName = 'VareNr'
      Size = 6
    end
    object cdSubstSubnr: TStringField
      FieldName = 'Subnr'
      Size = 6
    end
    object cdSubstKode: TStringField
      DisplayLabel = 'ABC'
      FieldName = 'Kode'
      Size = 1
    end
    object cdSubstNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object cdSubstForm: TStringField
      FieldName = 'Form'
    end
    object cdSubstStyrke: TStringField
      FieldName = 'Styrke'
    end
    object cdSubstPakning: TStringField
      FieldName = 'Pakning'
      Size = 30
    end
    object cdSubstPI: TStringField
      FieldName = 'PI'
      Size = 2
    end
    object cdSubstAntal: TIntegerField
      FieldName = 'Antal'
    end
    object cdSubstForvalg: TStringField
      FieldName = 'Forvalg'
      Size = 1
    end
    object cdSubstEnhedspris: TCurrencyField
      FieldName = 'Enhedspris'
      DisplayFormat = '###,###,###,##0.00'
    end
    object cdSubstSalgspris: TCurrencyField
      FieldName = 'Salgspris'
      DisplayFormat = '###,###,###,##0.00'
    end
    object cdSubstAntPkn: TIntegerField
      FieldName = 'AntPkn'
    end
    object cdSubstskaffe: TStringField
      FieldName = 'skaffe'
      Size = 4
    end
    object cdSubstRO: TStringField
      FieldName = 'RO'
      Size = 2
    end
    object cdSubstlokation1: TIntegerField
      FieldName = 'lokation1'
    end
    object cdSubstCTilsk: TStringField
      FieldName = 'CTilsk'
      Size = 1
    end
    object cdSubstGrLevSvigtDato: TDateTimeField
      FieldName = 'GrLevSvigtDato'
    end
    object cdSubstNySubKode: TStringField
      FieldName = 'NySubKode'
      Size = 1
    end
  end
  object dsSubst: TDataSource
    AutoEdit = False
    DataSet = cdSubst
    Left = 744
    Top = 432
  end
  object ActionManager1: TActionManager
    Left = 592
    Top = 327
    StyleName = 'Platform Default'
    object acNaemeste: TAction
      Caption = 'N&'#230'rmeste Apo'
      Enabled = False
      OnExecute = acNaemesteExecute
    end
    object acVisPositivList: TAction
      Caption = 'Show positive list'
      ShortCut = 118
      OnExecute = acVisPositivListExecute
    end
  end
end
