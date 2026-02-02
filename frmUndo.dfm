object fmUndo: TfmUndo
  Left = 0
  Top = 0
  Caption = 'Undo FMK Effectuation'
  ClientHeight = 201
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbeKundenr: TLabeledEdit
    Left = 48
    Top = 24
    Width = 121
    Height = 21
    EditLabel.Width = 40
    EditLabel.Height = 13
    EditLabel.Caption = 'Kundenr'
    TabOrder = 0
  end
  object lbePrescriptionIdentifier: TLabeledEdit
    Left = 48
    Top = 64
    Width = 121
    Height = 21
    EditLabel.Width = 100
    EditLabel.Height = 13
    EditLabel.Caption = 'PrescriptionIdentifier'
    TabOrder = 1
  end
  object lbeOrderIdentifier: TLabeledEdit
    Left = 48
    Top = 104
    Width = 121
    Height = 21
    EditLabel.Width = 94
    EditLabel.Height = 13
    EditLabel.Caption = 'OrdinationIdentifier'
    TabOrder = 2
  end
  object lbeEffectuationIdentifier: TLabeledEdit
    Left = 48
    Top = 144
    Width = 121
    Height = 21
    EditLabel.Width = 99
    EditLabel.Height = 13
    EditLabel.Caption = 'EffectiationIdentifier'
    TabOrder = 3
  end
  object btnUndo: TButton
    Left = 288
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Undo Effectuation'
    TabOrder = 4
    OnClick = btnUndoClick
  end
  object BitBtn1: TBitBtn
    Left = 288
    Top = 120
    Width = 75
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 5
  end
end
