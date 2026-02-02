object frmRetLin: TfrmRetLin
  Left = 289
  Top = 184
  Caption = 'Ekspeditionslinier'
  ClientHeight = 371
  ClientWidth = 558
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblF6: TLabel
    Left = 11
    Top = 296
    Width = 381
    Height = 26
    Caption = 
      'For tilbagef'#248'rsel af mindre antal pakninger: Mark'#233'r linienummer ' +
      'tallet og v'#230'lg F6. Tast det '#248'nskede antal pakninger, der skal kr' +
      'editeres. '
    WordWrap = True
  end
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 558
    Height = 282
    Align = alTop
    Checkboxes = True
    Columns = <
      item
        Caption = 'Linie'
        Width = 40
      end
      item
        Caption = 'Varenr'
        Width = 80
      end
      item
        Caption = 'Tekst'
        Width = 360
      end
      item
        Caption = 'Antal'
        Width = 80
      end
      item
        Caption = 'Max'
        Width = 0
      end>
    TabOrder = 0
    ViewStyle = vsReport
    OnMouseDown = ListView1MouseDown
  end
  object btnHele: TButton
    Left = 159
    Top = 330
    Width = 121
    Height = 25
    Caption = 'He&le ekspeditionen'
    TabOrder = 1
    OnClick = btnHeleClick
  end
  object btnAfslut: TButton
    Left = 435
    Top = 330
    Width = 121
    Height = 25
    Cancel = True
    Caption = '&Afslut'
    TabOrder = 2
    OnClick = btnAfslutClick
  end
  object btnMarkerede: TButton
    Left = 11
    Top = 330
    Width = 121
    Height = 25
    Caption = '&Kun markerede linier'
    TabOrder = 3
    OnClick = btnMarkeredeClick
  end
  object dsRetLin: TDataSource
    DataSet = mtRetlin
    Left = 72
    Top = 248
  end
  object mtRetlin: TClientDataSet
    PersistDataPacket.Data = {
      7A0000009619E0BD0100000018000000050000000000030000007A00034C696E
      040001000000000006566172654E720100490000000100055749445448020002
      0014000554656B7374010049000000010005574944544802000200280005416E
      74616C04000100000000000853656C656374656402000300000000000000}
    Active = True
    Aggregates = <>
    Params = <>
    Left = 128
    Top = 256
    object mtRetlinLin: TIntegerField
      FieldName = 'Lin'
    end
    object mtRetlinVareNr: TStringField
      FieldName = 'VareNr'
    end
    object mtRetlinTekst: TStringField
      FieldName = 'Tekst'
      Size = 40
    end
    object mtRetlinAntal: TIntegerField
      FieldName = 'Antal'
    end
    object mtRetlinSelected: TBooleanField
      FieldName = 'Selected'
    end
  end
  object ActionList1: TActionList
    Left = 312
    Top = 264
    object acF6: TAction
      Caption = 'acF6'
      ShortCut = 117
      OnExecute = acF6Execute
    end
  end
end
