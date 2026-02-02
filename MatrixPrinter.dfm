object MatrixPrnForm: TMatrixPrnForm
  Left = 121
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  ClientHeight = 558
  ClientWidth = 753
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 486
    Width = 753
    Height = 72
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      753
      72)
    object Label1: TLabel
      Left = 168
      Top = 27
      Width = 57
      Height = 20
      Caption = 'F&ra side'
      FocusControl = edtFirst
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 336
      Top = 27
      Width = 48
      Height = 20
      Caption = '&Til side'
      FocusControl = edtLast
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object buUdskriv: TBitBtn
      Left = 38
      Top = 20
      Width = 100
      Height = 35
      Hint = 'Udskriv direkte til forvalgt printer'
      Caption = '&Udskriv'
      Glyph.Data = {
        66010000424D6601000000000000760000002800000014000000140000000100
        040000000000F000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333300003000000000000000033300003088888888888880803300000000
        000000000000080300000888888888889BA80003000008888888888888880803
        0000000000000000000008030000088888888888888808030000300000000000
        000080030000330FFFFFFFFFFFF088030000330F0F000F0000F0080300003330
        FFFFFFFFFFFF003300003330F0F00F000F0F0333000033330FFFFFFFFFFFF033
        000033330FF000000F00F0330000333330FFFFFFFFFFFF030000333330000000
        0000000300003333333333333333333300003333333333333333333300003333
        33333333333333330000}
      TabOrder = 0
      OnClick = buUdskrivClick
    end
    object buFortryd: TBitBtn
      Left = 617
      Top = 20
      Width = 100
      Height = 35
      Hint = 'Fortryd udskrift af pakkeseddel'
      Anchors = [akTop, akRight]
      Caption = '&Fortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
    object edtFirst: TEdit
      Tag = 100
      Left = 248
      Top = 23
      Width = 49
      Height = 28
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object edtLast: TEdit
      Left = 400
      Top = 23
      Width = 49
      Height = 28
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object BitBtn1: TBitBtn
      Left = 483
      Top = 20
      Width = 100
      Height = 35
      Anchors = [akTop, akRight]
      Caption = '&PDF'
      Glyph.Data = {
        8A020000424D8A02000000000000360100002800000011000000110000000100
        08000000000054010000C40E0000C40E00004000000040000000817CE400D2D0
        DD00AFACE0004640E9009894E200BBB8DF005B55F2007C7C7B0084839D00F0F0
        F000C6C4DE007570E5001B15B1004B44E100443EDB003737370047465300140F
        85002F28EB0009073B001F18CF005E58E7008F8DA700120E76000D0A5800403E
        720063626F008C88E3006964E600524CE800A6A5A5006F6E6E00241CED00C0C0
        C000DEDDDC00FFFFFF0000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000000000000000000023232110191F
        1F1F1F1F1F1F1F1F1F0F2100000023232116031D2222222222222222221F2100
        00002323211E041D0B22222222222222221F210000002323211E22011C000222
        22220A1B1D1A210000002323211E2222011505001C0320031C1F210000002323
        211E2222220004051D0A2222221F210000002323211E222222011D1D01222222
        221F210000002323211E222222221C0422222222221F210000002323211E2222
        22221C0222222222221F210000002323211E222222221C0222222222221F2100
        00002323211E22222222000222222222221F2100000006060D0E1D1D1D1D1203
        1D0B2222221F2100000020202020202020202020201D2222221F210000002020
        2020202020202020201D1E1817132100000020202020202020202020201D1E0C
        140809000000232321071E1E1E1E1E1E1E1E0711082323000000232309212121
        2121212121212121232323000000}
      TabOrder = 4
      OnClick = BitBtn1Click
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 753
    Height = 486
    Align = alClient
    Color = clWindow
    ParentColor = False
    TabOrder = 1
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'pdf'
    Filter = 'PDF Files|*.pdf'
    InitialDir = 'i:\'
    Left = 248
    Top = 8
  end
  object RvRenderPrinter1: TRvRenderPrinter
    Left = 648
    Top = 296
  end
  object RvRenderPreview1: TRvRenderPreview
    ScrollBox = ScrollBox1
    ZoomFactor = 100.000000000000000000
    ShadowDepth = 0
    Left = 544
    Top = 296
  end
  object RvNDRWriter1: TRvNDRWriter
    StatusFormat = 'Printing page %p'
    Units = unMM
    UnitsFactor = 25.400000000000000000
    MarginLeft = 25.000000000000000000
    MarginRight = 10.000000000000000000
    MarginTop = 10.000000000000000000
    MarginBottom = 10.000000000000000000
    Title = 'Rave Report'
    Orientation = poPortrait
    ScaleX = 100.000000000000000000
    ScaleY = 100.000000000000000000
    OnPrint = rpsC2Print
    Left = 432
    Top = 312
  end
  object RvRenderPDF1: TRvRenderPDF
    DisplayName = 'Adobe Acrobat (PDF)'
    FileExtension = '*.pdf'
    DocInfo.Creator = 'Rave Reports (http://www.nevrona.com/rave)'
    DocInfo.Producer = 'Nevrona Designs'
    Left = 248
    Top = 256
  end
end
