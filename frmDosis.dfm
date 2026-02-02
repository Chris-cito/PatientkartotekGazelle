object frmDosiskort: TfrmDosiskort
  Left = 341
  Top = 169
  Caption = 'Dosiskort'
  ClientHeight = 285
  ClientWidth = 493
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 118
    Width = 493
    Height = 167
    Align = alClient
    TabOrder = 0
    object lblQuestion: TLabel
      Left = 1
      Top = 1
      Width = 491
      Height = 20
      Align = alTop
      Alignment = taCenter
      Caption = 'Kunden har dosiskort. Vil du forts'#230'tte ekspeditionen?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
      ExplicitWidth = 379
    end
    object bitJa: TBitBtn
      Left = 104
      Top = 106
      Width = 75
      Height = 25
      Caption = '&Ja'
      Kind = bkYes
      NumGlyphs = 2
      TabOrder = 0
    end
    object bitNej: TBitBtn
      Left = 312
      Top = 106
      Width = 75
      Height = 25
      Caption = '&Nej'
      Kind = bkNo
      NumGlyphs = 2
      TabOrder = 1
    end
    object bitOK: TBitBtn
      Left = 207
      Top = 106
      Width = 75
      Height = 25
      Caption = '&OK'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 2
    end
    object btnVisKort: TButton
      Left = 207
      Top = 44
      Width = 75
      Height = 25
      Action = acVisDoskort
      TabOrder = 3
    end
  end
  object cxGridDDCards: TcxGrid
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 487
    Height = 112
    Align = alTop
    TabOrder = 1
    object cxGridDDCardsTableView1: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnMoving = False
      OptionsData.Deleting = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsView.CellEndEllipsis = True
      OptionsView.GridLines = glNone
      OptionsView.GroupByBox = False
      object cxGridDDCardsTableView1Column1: TcxGridColumn
        Caption = 'Kort'
        Width = 100
      end
      object cxGridDDCardsTableView1Column2: TcxGridColumn
        Caption = 'I bero'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Width = 48
      end
      object cxGridDDCardsTableView1Column3: TcxGridColumn
        Caption = 'Udleveringsapotek'
        Width = 130
      end
      object cxGridDDCardsTableView1Column4: TcxGridColumn
        Caption = 'Pakkegruppe'
        Width = 105
      end
    end
    object cxGridDDCardsLevel1: TcxGridLevel
      GridView = cxGridDDCardsTableView1
    end
  end
  object ActionManager1: TActionManager
    Left = 376
    Top = 166
    StyleName = 'Platform Default'
    object acVisDoskort: TAction
      Caption = 'Vis DD-kort'
      OnExecute = acVisDoskortExecute
      OnUpdate = acVisDoskortUpdate
    end
    object acLuk: TAction
      Caption = 'acLuk'
      ShortCut = 27
      OnExecute = acLukExecute
    end
  end
end
