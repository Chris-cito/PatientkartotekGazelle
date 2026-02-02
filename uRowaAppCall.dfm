object frmRowaApp: TfrmRowaApp
  Left = 203
  Top = 116
  Caption = 'RowaAppCall'
  ClientHeight = 442
  ClientWidth = 680
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 68
    Width = 33
    Height = 13
    Caption = 'VareNr'
  end
  object Label2: TLabel
    Left = 240
    Top = 68
    Width = 24
    Height = 13
    Caption = 'Antal'
  end
  object Button1: TButton
    Left = 16
    Top = 16
    Width = 75
    Height = 25
    Caption = 'A request'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 164
    Width = 680
    Height = 278
    Align = alBottom
    TabOrder = 1
  end
  object Button2: TButton
    Left = 136
    Top = 16
    Width = 75
    Height = 25
    Caption = 'K request'
    TabOrder = 2
    OnClick = Button2Click
  end
  object edtVarenr: TEdit
    Left = 88
    Top = 64
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object edtAntal: TEdit
    Left = 312
    Top = 64
    Width = 129
    Height = 21
    TabOrder = 4
  end
  object CliApp: TAppSrvClient
    Server = 'localhost'
    Port = '2106'
    SocksAuthentication = socksNoAuthentication
    Answer = BuffApp
    MaxRetries = 0
    RcvSize = 2048
    RcvSizeInc = 0
    OnAfterProcessReply = CliAppAfterProcessReply
    Left = 536
    Top = 32
  end
  object BuffApp: TMWBuffer
    DataBufferSize = 256
    HeaderSize = 0
    AutoExpand = 256
    Left = 592
    Top = 24
  end
  object TimApp: TTimer
    OnTimer = TimAppTimer
    Left = 488
    Top = 112
  end
end
