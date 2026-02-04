object frmCTRUdskriv: TfrmCTRUdskriv
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'CTR Ekspeditionslister'
  ClientHeight = 250
  ClientWidth = 367
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 20
  object rgCTRServer: TRadioGroup
    Left = 0
    Top = 0
    Width = 367
    Height = 105
    Align = alTop
    Caption = 'CTR Server'
    Items.Strings = (
      'CTR &A'
      'CTR &B')
    TabOrder = 0
  end
  object rgPeriode: TRadioGroup
    Left = 0
    Top = 105
    Width = 367
    Height = 105
    Align = alTop
    Caption = 'Periode'
    Items.Strings = (
      'A&ktuel Periode'
      '&Forrige Periode')
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 210
    Width = 367
    Height = 40
    Align = alClient
    TabOrder = 2
    object BitBtn2: TcxButton
      Left = 255
      Top = 6
      Width = 100
      Height = 30
      Cancel = True
      Caption = '&Fortryd'
      ModalResult = 2
      TabOrder = 0
    end
    object BitBtn1: TcxButton
      Left = 149
      Top = 6
      Width = 100
      Height = 30
      Caption = '&Gem'
      ModalResult = 1
      TabOrder = 1
      OnClick = BitBtn1_Click
    end
  end
  object SQLConnection1: TSQLConnection
    DriverName = 'DataSnap'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DbxDatasnap'
      'HostName=localhost'
      'Port=21167'
      'CommunicationProtocol=tcp/ip'
      'DatasnapContext=datasnap/')
    Left = 304
    Top = 24
    UniqueId = '{3E8FCCC7-3EBB-4A54-A05E-D3BCDB6ACB80}'
  end
end
