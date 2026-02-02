object frmOrdView: TfrmOrdView
  Left = 153
  Top = 94
  Caption = 'Ordinations oversigt'
  ClientHeight = 448
  ClientWidth = 804
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 31
    Height = 13
    Caption = 'Varenr'
  end
  object Label2: TLabel
    Left = 128
    Top = 16
    Width = 26
    Height = 13
    Caption = 'Navn'
  end
  object Label3: TLabel
    Left = 304
    Top = 16
    Width = 23
    Height = 13
    Caption = 'Form'
  end
  object Label4: TLabel
    Left = 488
    Top = 16
    Width = 30
    Height = 13
    Caption = 'Styrke'
  end
  object Label5: TLabel
    Left = 8
    Top = 48
    Width = 39
    Height = 13
    Caption = 'Pakning'
  end
  object Label6: TLabel
    Left = 192
    Top = 48
    Width = 24
    Height = 13
    Caption = 'Antal'
  end
  object LabIter: TLabel
    Left = 56
    Top = 80
    Width = 593
    Height = 13
    AutoSize = False
  end
  object dbgOrdOversigt: TDBGrid
    Left = 0
    Top = 96
    Width = 804
    Height = 352
    Align = alBottom
    DataSource = dsMem
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object edtVarenr: TEdit
    Left = 56
    Top = 12
    Width = 57
    Height = 21
    TabOrder = 1
  end
  object edtNavn: TEdit
    Left = 168
    Top = 12
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object edtForm: TEdit
    Left = 344
    Top = 12
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object edtStyrke: TEdit
    Left = 528
    Top = 12
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object edtPakning: TEdit
    Left = 56
    Top = 44
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object edtAntal: TEdit
    Left = 232
    Top = 44
    Width = 121
    Height = 21
    TabOrder = 6
  end
  object dsMem: TDataSource
    AutoEdit = False
    DataSet = mtOrd
    Left = 283
    Top = 188
  end
  object mtOrd: TClientDataSet
    PersistDataPacket.Data = {
      750100009619E0BD01000000180000000D000000000003000000750108446174
      6554696D65010049000000010005574944544802000200140005416E74616C01
      00490000000100055749445448020002000A00044E61766E0100490000000100
      055749445448020002001E0004466F726D010049000000010005574944544802
      0002001E000450616B6E01004900000001000557494454480200020014000656
      6172656E720100490000000100055749445448020002000A000741706F4E616D
      650100490000000100055749445448020002001E00044C626E72010049000000
      0100055749445448020002000A00074C696E69656E7201004900000001000557
      49445448020002000A0002494401004900000001000557494454480200020014
      0016507265736372697074696F6E4964656E7469666965720800010000000000
      0F4F726465724964656E74696669657208000100000000001645666665637475
      6174696F6E4964656E74696669657208000100000000000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'DateTime'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Antal'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'Navn'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Form'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Pakn'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Varenr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'ApoName'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'Lbnr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'Linienr'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'ID'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'PrescriptionIdentifier'
        DataType = ftLargeint
      end
      item
        Name = 'OrderIdentifier'
        DataType = ftLargeint
      end
      item
        Name = 'EffectuationIdentifier'
        DataType = ftLargeint
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 352
    Top = 188
    object mtOrdDateTime: TStringField
      DisplayLabel = 'Dato'
      FieldName = 'DateTime'
    end
    object mtOrdAntal: TStringField
      DisplayWidth = 5
      FieldName = 'Antal'
      Size = 10
    end
    object mtOrdNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object mtOrdForm: TStringField
      DisplayWidth = 20
      FieldName = 'Form'
      Size = 30
    end
    object mtOrdPakn: TStringField
      DisplayLabel = 'Pakning'
      DisplayWidth = 15
      FieldName = 'Pakn'
    end
    object mtOrdVarenr: TStringField
      DisplayWidth = 6
      FieldName = 'Varenr'
      Size = 10
    end
    object mtOrdApoName: TStringField
      DisplayLabel = 'Apotek'
      FieldName = 'ApoName'
      Size = 30
    end
    object mtOrdLbnr: TStringField
      DisplayWidth = 8
      FieldName = 'Lbnr'
      Size = 10
    end
    object mtOrdLinienr: TStringField
      DisplayLabel = 'Ord'
      DisplayWidth = 3
      FieldName = 'Linienr'
      Size = 10
    end
    object mtOrdID: TStringField
      DisplayLabel = 'AdminId'
      DisplayWidth = 20
      FieldName = 'ID'
    end
    object mtOrdPrescriptionIdentifier: TLargeintField
      FieldName = 'PrescriptionIdentifier'
      Visible = False
    end
    object mtOrdOrderIdentifier: TLargeintField
      FieldName = 'OrderIdentifier'
      Visible = False
    end
    object mtOrdEffectuationIdentifier: TLargeintField
      FieldName = 'EffectuationIdentifier'
      Visible = False
    end
  end
  object ActionManager1: TActionManager
    Left = 504
    Top = 144
    StyleName = 'Platform Default'
    object acUndo: TAction
      Caption = 'acUndo'
      ShortCut = 49237
      OnExecute = acUndoExecute
    end
  end
end
