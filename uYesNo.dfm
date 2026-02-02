object frmYesNo: TfrmYesNo
  Left = 294
  Top = 171
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'V'#230'lg Ja / Nej'
  ClientHeight = 143
  ClientWidth = 341
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  PopupMode = pmAuto
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    341
    143)
  PixelsPerInch = 96
  TextHeight = 13
  object btnJa: TButton
    Left = 64
    Top = 111
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Ja'
    TabOrder = 0
    OnClick = btnJaClick
  end
  object btnNej: TButton
    Left = 192
    Top = 111
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Nej'
    TabOrder = 1
    OnClick = btnNejClick
  end
  object btnOk: TButton
    Left = 128
    Top = 111
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Ok'
    TabOrder = 2
    OnClick = btnOkClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 341
    Height = 105
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 3
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 339
      Height = 103
      TabStop = False
      Align = alClient
      Alignment = taCenter
      BorderStyle = bsNone
      Color = clBtnFace
      Lines.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9')
      ReadOnly = True
      TabOrder = 0
      ExplicitLeft = 2
      ExplicitTop = 0
      ExplicitHeight = 169
    end
  end
end
