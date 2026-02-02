object frmRCPVare: TfrmRCPVare
  Left = 0
  Top = 0
  Caption = 'Find varenr fra lokale receptkvitteringer'
  ClientHeight = 461
  ClientWidth = 734
  Color = clBtnFace
  Constraints.MinHeight = 500
  Constraints.MinWidth = 750
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 19
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 734
    Height = 185
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 48
      Top = 21
      Width = 69
      Height = 19
      Caption = '&Start dato'
      FocusControl = dtpStart
    end
    object Label2: TLabel
      Left = 264
      Top = 21
      Width = 63
      Height = 19
      Caption = 'S&lut dato'
      FocusControl = dtpSlutdato
    end
    object Label3: TLabel
      Left = 51
      Top = 99
      Width = 47
      Height = 19
      Caption = '&Varenr'
      FocusControl = edtVarenr
    end
    object dtpStart: TDateTimePicker
      Left = 48
      Top = 40
      Width = 120
      Height = 27
      Date = 41319.393131759260000000
      Time = 41319.393131759260000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object dtpSlutdato: TDateTimePicker
      Left = 264
      Top = 40
      Width = 120
      Height = 27
      Date = 41319.393131759260000000
      Time = 41319.393131759260000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object edtVarenr: TEdit
      Left = 48
      Top = 120
      Width = 121
      Height = 27
      TabOrder = 2
      Text = 'edtVarenr'
    end
    object btnSoeg: TButton
      Left = 264
      Top = 121
      Width = 75
      Height = 25
      Caption = 'S&'#248'g'
      TabOrder = 3
      OnClick = btnSoegClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 185
    Width = 734
    Height = 235
    Align = alClient
    TabOrder = 1
    object ListView1: TListView
      Left = 1
      Top = 1
      Width = 732
      Height = 233
      Align = alClient
      Checkboxes = True
      Columns = <
        item
          Caption = 'ReceptId'
          MinWidth = 100
          Width = 100
        end
        item
          Caption = 'Lbnr'
          Width = 100
        end
        item
          Caption = 'Dato'
          MinWidth = 100
          Width = 100
        end
        item
          Caption = 'CprNr'
          MinWidth = 120
          Width = 120
        end
        item
          Caption = 'Navn'
          MinWidth = 300
          Width = 300
        end>
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 420
    Width = 734
    Height = 41
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      734
      41)
    object btnUdRCP: TButton
      Left = 11
      Top = 6
      Width = 120
      Height = 25
      Anchors = [akLeft, akTop, akBottom]
      Caption = '&Udskriv RCP'
      TabOrder = 0
      OnClick = btnUdRCPClick
    end
    object btnEtiket: TButton
      Left = 305
      Top = 6
      Width = 120
      Height = 25
      Anchors = [akTop, akBottom]
      Caption = 'Udskriv &Etiketter'
      TabOrder = 1
      OnClick = btnEtiketClick
    end
    object btnCancel: TButton
      Left = 599
      Top = 6
      Width = 120
      Height = 25
      Anchors = [akTop, akRight, akBottom]
      Caption = '&Fortryd'
      ModalResult = 2
      TabOrder = 2
    end
  end
  object nxQuery1: TnxQuery
    Session = MainDm.nxSess
    AliasName = 'PRODUKTION'
    SQL.Strings = (
      '#t 100000'
      ''
      'select'
      '      x.*,'
      '      rsl.receptid'
      '      '
      'from'
      '('
      'select '
      '       e.*,'
      '       l.subvarenr as Varennr,'
      '       l.linienr'
      '       '
      'from'
      '('
      'select '
      'lbnr as rslbnr,'
      'afsluttetdato as dato,'
      'kundenr as Patcpr,'
      'navn'
      'from'
      '    ekspeditioner '
      'where'
      '     takserdato>=:startdato and takserdato <=:slutdato'
      ') as e'
      'inner join ekspliniersalg as l on l.lbnr=e.rslbnr'
      'where l.subvarenr=:strvarenr'
      ') as x'
      
        'inner join rs_eksplinier as rsl on rsl.rslbnr=x.rslbnr and rsl.r' +
        'slinienr=x.linienr')
    Left = 488
    Top = 32
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'startdato'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'slutdato'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'strvarenr'
        ParamType = ptUnknown
      end>
    object nxQuery1receptid: TIntegerField
      FieldName = 'receptid'
    end
    object nxQuery1Dato: TDateTimeField
      FieldName = 'Dato'
    end
    object nxQuery1PatCPr: TStringField
      FieldName = 'PatCPr'
      Size = 10
    end
    object nxQuery1Navn: TStringField
      FieldName = 'Navn'
      Size = 141
    end
    object nxQuery1varennr: TStringField
      FieldName = 'varennr'
      Size = 6
    end
    object nxQuery1rslbnr: TIntegerField
      FieldName = 'rslbnr'
    end
  end
end
