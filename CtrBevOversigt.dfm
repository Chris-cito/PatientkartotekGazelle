object fmCtrBevOversigt: TfmCtrBevOversigt
  Left = 168
  Top = 213
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'CTR bevillinger'
  ClientHeight = 288
  ClientWidth = 919
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI '
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object paCtrOver: TPanel
    Left = 0
    Top = 252
    Width = 919
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object buLuk: TcxButton
      AlignWithMargins = True
      Left = 809
      Top = 3
      Width = 90
      Height = 30
      Margins.Right = 20
      Align = alRight
      Cancel = True
      Caption = '&Luk'
      ModalResult = 1
      TabOrder = 0
    end
  end
  object dbgCtrOver: TDBGrid
    Left = 0
    Top = 89
    Width = 919
    Height = 163
    Align = alClient
    DataSource = MainDm.dsnxCTRBev
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -15
    TitleFont.Name = 'Segoe UI '
    TitleFont.Style = []
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 919
    Height = 89
    Align = alTop
    TabOrder = 2
    object lblCpRnr: TLabel
      Left = 24
      Top = 16
      Width = 113
      Height = 20
      AutoSize = False
      Caption = 'test'
      Transparent = True
    end
    object lblNavn: TLabel
      Left = 143
      Top = 15
      Width = 250
      Height = 20
      AutoSize = False
      Caption = 'test'
      Transparent = True
    end
    object lblType: TLabel
      Left = 399
      Top = 15
      Width = 200
      Height = 20
      AutoSize = False
      Caption = 'test'
      Transparent = True
    end
    object lblStart: TLabel
      Left = 560
      Top = 15
      Width = 100
      Height = 20
      AutoSize = False
      Caption = 'test'
      Transparent = True
    end
    object lblHenstans: TLabel
      Left = 24
      Top = 42
      Width = 24
      Height = 17
      Caption = 'test'
      Transparent = True
    end
  end
end
