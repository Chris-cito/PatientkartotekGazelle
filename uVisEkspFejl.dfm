object frmVisEkspKontrol: TfrmVisEkspKontrol
  Left = 44
  Top = 100
  Caption = 'Vis Ekspedition Kontrol'
  ClientHeight = 455
  ClientWidth = 767
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 767
    Height = 73
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 56
      Height = 24
      Caption = 'Label1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object ListView1: TListView
    Left = 0
    Top = 73
    Width = 767
    Height = 206
    Align = alClient
    Columns = <
      item
        Caption = 'Linienr'
      end
      item
        Caption = 'Varenr'
        Width = 80
      end
      item
        Caption = 'Tekst'
        Width = 200
      end
      item
        Caption = 'Antal'
      end
      item
        Caption = 'Kontroller'
        Width = 60
      end
      item
        Caption = 'Fejlkode'
        Width = 60
      end
      item
        Caption = 'Dato'
        Width = 150
      end
      item
        Caption = 'Bem'#230'rk'
        Width = 400
      end>
    ReadOnly = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object Panel2: TPanel
    Left = 0
    Top = 399
    Width = 767
    Height = 56
    Align = alBottom
    TabOrder = 2
    object BitBtn1: TBitBtn
      Left = 335
      Top = 16
      Width = 105
      Height = 25
      Caption = '&Fortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 279
    Width = 767
    Height = 120
    Align = alBottom
    DataSource = DataSource1
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = DBGrid1DrawColumnCell
  end
  object DataSource1: TDataSource
    DataSet = nxqDMVS
    Left = 208
    Top = 352
  end
  object nxqDMVS: TnxQuery
    Left = 272
    Top = 352
  end
end
