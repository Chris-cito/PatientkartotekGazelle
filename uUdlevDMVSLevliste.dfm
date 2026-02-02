object frmUdlevDMVS: TfrmUdlevDMVS
  Left = 0
  Top = 0
  Caption = 'Udlev DMVS Levliste'
  ClientHeight = 192
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmExplicit
  PopupParent = StamForm.Owner
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 415
    Height = 151
    Align = alClient
    DataSource = dsLevListe
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'listenr'
        Title.Caption = #8237'Listenr.'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'dato'
        Title.Caption = 'Dato'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'konto'
        Title.Caption = 'Kontonr.'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'navn'
        Title.Caption = 'Afdeling'
        Width = 180
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 151
    Width = 415
    Height = 41
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      415
      41)
    object btnUdlev: TButton
      Left = 8
      Top = 6
      Width = 75
      Height = 25
      Action = acUdlev
      TabOrder = 0
    end
    object BitBtn1: TBitBtn
      Left = 331
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '&Fortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object ActionManager1: TActionManager
    Left = 256
    Top = 40
    StyleName = 'Platform Default'
    object acUdlev: TAction
      Caption = '&Udlev DMVS'
      OnExecute = acUdlevExecute
    end
  end
  object dsLevListe: TDataSource
    DataSet = nxQuery1
    Left = 352
    Top = 96
  end
  object nxQuery1: TnxQuery
    Session = MainDm.nxSess
    SQL.Strings = (
      '#t 100000'
      'select x.*'
      ',afd.navn'
      'from'
      '('
      'select distinct lev.listenr'
      ',cast(lev.dato as  date) as dato'
      ',lev.konto'
      'from ekspleveringsliste as lev'
      'inner join ekspeditioner as e on e.lbnr=lev.lbnr'
      'left join ekspeditionerbon as bon on bon.lbnr=e.lbnr'
      'left join debitorkartotek as deb on deb.kontonr=lev.konto'
      'and (bon.bonnr=0 or bon.bonnr is null)'
      'where   lev.dato >= cast('#39'2019-02-09 00:00:00.000'#39' as datetime)'
      ') as x'
      'left join debitorkartotek as deb on deb.kontonr=x.konto'
      'left join afdelingsnavne as afd on afd.refnr=deb.afdeling')
    Left = 136
    Top = 48
  end
end
