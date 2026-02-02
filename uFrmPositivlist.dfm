object frmPositivList: TfrmPositivList
  Left = 0
  Top = 0
  Caption = 'Region positivlist'
  ClientHeight = 387
  ClientWidth = 770
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 770
    Height = 256
    Align = alClient
    DataSource = DataSource1
    Options = [dgEditing, dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'VareId'
        Title.Caption = 'Varenr/ATC'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FormTxt'
        Title.Caption = 'Form'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'StyrkeTxt'
        Title.Caption = 'Styrke'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Tekst'
        Width = 483
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FraDato'
        Title.Caption = 'Fra-dato'
        Visible = False
      end
      item
        Expanded = False
        FieldName = 'TilDato'
        Title.Caption = 'Til-dato'
        Visible = False
      end>
  end
  object DBMemo1: TDBMemo
    Left = 0
    Top = 298
    Width = 770
    Height = 89
    Align = alBottom
    DataField = 'Memo'
    DataSource = DataSource1
    TabOrder = 1
  end
  object DBEdit1: TDBEdit
    Left = 0
    Top = 256
    Width = 770
    Height = 21
    Align = alBottom
    DataField = 'FormTxt'
    DataSource = DataSource1
    TabOrder = 2
    ExplicitTop = 277
  end
  object DBEdit2: TDBEdit
    Left = 0
    Top = 277
    Width = 770
    Height = 21
    Align = alBottom
    DataField = 'StyrkeTxt'
    DataSource = DataSource1
    TabOrder = 3
    ExplicitTop = 256
  end
  object ActionManager1: TActionManager
    Left = 192
    Top = 96
    StyleName = 'Platform Default'
    object acClose: TAction
      Caption = 'Close'
      ShortCut = 27
      OnExecute = acCloseExecute
    end
  end
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = ClientDataSet1
    Left = 440
    Top = 144
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    ReadOnly = True
    Left = 368
    Top = 144
  end
end
