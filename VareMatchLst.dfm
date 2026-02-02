object frmSearch: TfrmSearch
  Left = 367
  Top = 169
  BorderStyle = bsDialog
  Caption = 'frmSearch'
  ClientHeight = 404
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF11FFFFFFF
    FFFFFFFFFFFFFFFFFFFFFF1B11FFFFF7777777F7777777F7777771B1B1FFFFF7
    FFFFF7F7FFFFF7F7FFFF1B1B1FFFFFF7FFFFF7F7FFFFF7F7FFF1B1B1FFFFFFF7
    FFFFF7F7FFFFF7F7FF1B1B1FFFFFFFF7777FF7F7777FF7F771B1B17FFFFFFFFF
    777FF7F7777FF7F71B1B1F7FFFFFFFFFF77FF7FF700000F1B1B17F7FFFFFFFFF
    FF7777F00FFFFF001B17777FFFFFFFFFFFFFFF0FFFFFFFFF01FFFFFFFFFFFFF7
    7777770FFFFFFFFF0777777FFFFFFFF7FFFFF0FFFFFFFFFFF0FFFF7FFFFFFFF7
    FFFFF0FFFFFFFFFFF0FFFF7FFFFFFFF7FFFFF0FFFFFFFFFFF0FFFF7FFFFFFFF7
    777FF0FFFFFFFFFFF0FFFF7FFFFFFFFF777FF0FFFFFFFFFFF077FF7FFFFFFFFF
    F77FF70FFFFFFFFF0F77FF7FFFFFFFFFFF77770FFFFFFFFF0FF7777FFFFFFFFF
    FFFFFFF00FFFFF00FFFFFFFFFFFFFFF7777777FF7000007F7777777FFFFFFFF7
    FFFFF7FF7FFFFF7F7FFFFF7FFFFFFFF7FFFFF7FF7FFFFF7F7FFFFF7FFFFFFFF7
    FFFFF7FF7FFFFF7F7FFFFF7FFFFFFFF7777FF7FF7777FF7F7777FF7FFFFFFFFF
    777FF7FFF777FF7FF777FF7FFFFFFFFFF77FF7FFFF77FF7FFF77FF7FFFFFFFFF
    FF7777FFFFF7777FFFF7777FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    377
    404)
  PixelsPerInch = 96
  TextHeight = 13
  object lblSearchWord: TLabel
    Left = 4
    Top = 8
    Width = 209
    Height = 13
    Caption = '&Indtast s'#248'gekriterie eller v'#230'lg emne fra listen'
    FocusControl = edtSearchText
  end
  object Bevel: TBevel
    Left = 0
    Top = 353
    Width = 377
    Height = 9
    Anchors = [akLeft, akRight, akBottom]
    Shape = bsBottomLine
  end
  object Label1: TLabel
    Left = 279
    Top = 8
    Width = 89
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'V'#230'lg svar &kolonne'
    FocusControl = cbxSearch
  end
  object dbgSearchGrid: TDBGrid
    Left = 8
    Top = 52
    Width = 361
    Height = 298
    TabStop = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsNone
    Options = [dgTitles, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgSearchGridDblClick
    OnKeyDown = dbgSearchGridKeyDown
    OnMouseUp = dbgSearchGridMouseUp
    OnTitleClick = dbgSearchGridTitleClick
  end
  object btnOK: TBitBtn
    Left = 8
    Top = 372
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    DoubleBuffered = True
    Kind = bkOK
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 3
    TabStop = False
  end
  object btnCancel: TBitBtn
    Left = 295
    Top = 372
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Fortryd'
    DoubleBuffered = True
    Kind = bkCancel
    NumGlyphs = 2
    ParentDoubleBuffered = False
    TabOrder = 4
    TabStop = False
  end
  object edtSearchText: TMaskEdit
    Left = 4
    Top = 24
    Width = 209
    Height = 21
    AutoSelect = False
    TabOrder = 0
    OnChange = edtSearchTextChange
    OnKeyDown = edtSearchTextKeyDown
  end
  object cbxSearch: TComboBox
    Left = 278
    Top = 24
    Width = 91
    Height = 21
    Style = csDropDownList
    Anchors = [akTop, akRight]
    DropDownCount = 1
    TabOrder = 1
  end
end
