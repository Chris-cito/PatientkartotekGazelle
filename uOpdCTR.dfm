object frmOpdCTR: TfrmOpdCTR
  Left = 476
  Top = 165
  Caption = 'OpdaterCTR Status'
  ClientHeight = 400
  ClientWidth = 764
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
  object dbgOpdCTR: TDBGrid
    Left = 0
    Top = 0
    Width = 764
    Height = 340
    Align = alClient
    DataSource = MainDm.dsCtrOpd
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgEditing, dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = dbgOpdCTRDrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'Nr'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Dato'
        Width = 156
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Message'
        Title.Caption = 'Meddelelse'
        Width = 490
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 340
    Width = 764
    Height = 60
    Align = alBottom
    TabOrder = 1
    object btnSlet: TButton
      Left = 43
      Top = 14
      Width = 150
      Height = 32
      Caption = '&Slet lbnr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnSletClick
    end
    object BitBtn1: TBitBtn
      Left = 595
      Top = 14
      Width = 150
      Height = 32
      Caption = '&Fortryd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Kind = bkCancel
      NumGlyphs = 2
      ParentFont = False
      TabOrder = 1
    end
  end
  object timOpdCTR: TTimer
    Interval = 3000
    OnTimer = timOpdCTRTimer
    Left = 56
    Top = 168
  end
end
