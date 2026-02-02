object FmHenstandsOrdning: TFmHenstandsOrdning
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'HenstandsOrdning'
  ClientHeight = 372
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 19
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 554
    Height = 372
    Align = alClient
    TabOrder = 0
    object EditCPRNr: TEdit
      Left = 103
      Top = 41
      Width = 114
      Height = 17
      BorderStyle = bsNone
      ReadOnly = True
      TabOrder = 0
    end
    object DateTimePicker1: TDateTimePicker
      Left = 101
      Top = 68
      Width = 116
      Height = 27
      Date = 42356.462081284720000000
      Time = 42356.462081284720000000
      TabOrder = 1
    end
    object DateTimePicker2: TDateTimePicker
      Left = 101
      Top = 103
      Width = 116
      Height = 27
      Date = 42356.462213310190000000
      Time = 42356.462213310190000000
      TabOrder = 2
    end
    object RadioGroup1: TRadioGroup
      Left = 30
      Top = 163
      Width = 494
      Height = 105
      Caption = 'Inaktiv tekst'
      Items.Strings = (
        'Misligholdt'
        'Andet')
      TabOrder = 4
    end
    object BitBtn1: TBitBtn
      Left = 30
      Top = 317
      Width = 115
      Height = 25
      Caption = '&Gem'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 5
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 409
      Top = 317
      Width = 115
      Height = 25
      Caption = '&Fortryd'
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 6
    end
    object CheckBoxAktiv: TCheckBox
      Left = 30
      Top = 138
      Width = 97
      Height = 17
      Caption = '&Aktiv'
      TabOrder = 3
      OnClick = CheckBoxAktivClick
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object dxLayoutControl1Group1: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      AlignHorz = ahClient
      AlignVert = avClient
      ButtonOptions.Buttons = <>
      Padding.AssignedValues = [lpavTop]
      Index = 0
    end
    object dxLayoutControl1Item2: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      AlignHorz = ahLeft
      CaptionOptions.Text = 'CPRnr.'
      Control = EditCPRNr
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 114
      Index = 0
    end
    object dxLayoutControl1Item1: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      AlignHorz = ahLeft
      CaptionOptions.Text = '&Startdato'
      Control = DateTimePicker1
      ControlOptions.OriginalHeight = 27
      ControlOptions.OriginalWidth = 116
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Item3: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      AlignHorz = ahLeft
      CaptionOptions.Text = 'S&lutdato'
      Control = DateTimePicker2
      ControlOptions.OriginalHeight = 27
      ControlOptions.OriginalWidth = 116
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutControl1Item4: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      CaptionOptions.Text = 'RadioGroup1'
      CaptionOptions.Visible = False
      Control = RadioGroup1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 105
      ControlOptions.OriginalWidth = 510
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutControl1Group2: TdxLayoutGroup
      Parent = dxLayoutControl1Group_Root
      CaptionOptions.AlignVert = tavBottom
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutControl1Item5: TdxLayoutItem
      Parent = dxLayoutControl1Group2
      AlignHorz = ahLeft
      CaptionOptions.Text = 'BitBtn1'
      CaptionOptions.Visible = False
      Control = BitBtn1
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 115
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutControl1Item6: TdxLayoutItem
      Parent = dxLayoutControl1Group2
      AlignHorz = ahRight
      CaptionOptions.Text = 'BitBtn2'
      CaptionOptions.Visible = False
      Control = BitBtn2
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 115
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutControl1Item8: TdxLayoutItem
      Parent = dxLayoutControl1Group1
      AlignHorz = ahLeft
      CaptionOptions.Text = 'CheckBox1'
      CaptionOptions.Visible = False
      Control = CheckBoxAktiv
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 3
    end
  end
  object ActionManager1: TActionManager
    Left = 344
    Top = 200
    StyleName = 'Platform Default'
  end
end
