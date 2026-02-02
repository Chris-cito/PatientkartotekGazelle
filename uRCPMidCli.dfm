object RCPMidCli: TRCPMidCli
  OldCreateOrder = False
  OnCreate = MidClientCreate
  Height = 163
  Width = 267
  object CliApp: TAppSrvClient
    Server = '172.26.20.28'
    Port = '2106'
    SocksAuthentication = socksNoAuthentication
    Answer = BufApp
    MaxRetries = 0
    RcvSize = 2048
    RcvSizeInc = 0
    OnAfterProcessReply = CliAppAfterProcessReply
    Left = 12
    Top = 8
  end
  object BufApp: TMWBuffer
    DataBufferSize = 512
    HeaderSize = 0
    AutoExpand = 512
    Left = 44
    Top = 8
  end
  object TimApp: TTimer
    Enabled = False
    OnTimer = TimAppTimer
    Left = 76
    Top = 8
  end
end
