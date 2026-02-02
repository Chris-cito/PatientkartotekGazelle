object fmInteraktion: TfmInteraktion
  Left = 683
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Interaktioner'
  ClientHeight = 533
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object pcInt: TPageControl
    Left = 0
    Top = 0
    Width = 429
    Height = 533
    ActivePage = tsLst
    Align = alClient
    TabHeight = 26
    TabOrder = 0
    TabWidth = 120
    object tsChk: TTabSheet
      Caption = 'Interaktionscheck'
      OnEnter = tsChkEnter
      OnExit = tsChkExit
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object gbInt: TGroupBox
        Left = 0
        Top = 0
        Width = 421
        Height = 60
        Align = alTop
        Caption = 'Mellem'
        TabOrder = 0
        DesignSize = (
          421
          60)
        object meChkInt: TMemo
          Left = 10
          Top = 18
          Width = 408
          Height = 38
          TabStop = False
          Anchors = [akLeft, akTop, akRight, akBottom]
          BorderStyle = bsNone
          Color = clBtnFace
          Ctl3D = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 0
        end
      end
      object gbVej: TGroupBox
        Left = 0
        Top = 60
        Width = 421
        Height = 387
        Align = alClient
        Caption = 'Vejledning'
        TabOrder = 1
        DesignSize = (
          421
          387)
        object dbmeChkVej: TDBMemo
          Left = 8
          Top = 18
          Width = 410
          Height = 365
          Anchors = [akLeft, akTop, akRight, akBottom]
          BorderStyle = bsNone
          Color = clBtnFace
          DataField = 'Tekst'
          DataSource = MainDm.dsIntTxt
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object gbBut: TGroupBox
        Left = 0
        Top = 447
        Width = 421
        Height = 50
        Align = alBottom
        TabOrder = 2
        object buOk: TBitBtn
          Left = 286
          Top = 14
          Width = 100
          Height = 30
          Caption = '&Ok'
          Glyph.Data = {
            DE010000424DDE01000000000000760000002800000024000000120000000100
            0400000000006801000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3333333333333333333333330000333333333333333333333333F33333333333
            00003333344333333333333333388F3333333333000033334224333333333333
            338338F3333333330000333422224333333333333833338F3333333300003342
            222224333333333383333338F3333333000034222A22224333333338F338F333
            8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
            33333338F83338F338F33333000033A33333A222433333338333338F338F3333
            0000333333333A222433333333333338F338F33300003333333333A222433333
            333333338F338F33000033333333333A222433333333333338F338F300003333
            33333333A222433333333333338F338F00003333333333333A22433333333333
            3338F38F000033333333333333A223333333333333338F830000333333333333
            333A333333333333333338330000333333333333333333333333333333333333
            0000}
          ModalResult = 1
          NumGlyphs = 2
          TabOrder = 2
        end
        object buUdEtk: TBitBtn
          Left = 162
          Top = 14
          Width = 100
          Height = 30
          Caption = '&Etiket'
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
          ModalResult = 1
          TabOrder = 1
          TabStop = False
          OnClick = buUdEtkClick
        end
        object buA4: TBitBtn
          Left = 38
          Top = 14
          Width = 100
          Height = 30
          Caption = '&A4 laser'
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
          ModalResult = 1
          TabOrder = 0
          TabStop = False
          OnClick = buA4Click
        end
      end
    end
    object tsLst: TTabSheet
      Caption = 'Interaktioner'
      ImageIndex = 1
      OnEnter = tsLstEnter
      OnShow = tsLstShow
      DesignSize = (
        421
        497)
      object Label1: TLabel
        Left = 18
        Top = 24
        Width = 57
        Height = 16
        Alignment = taRightJustify
        Caption = 'Atckode1'
        FocusControl = dbeLstAtc1
      end
      object Label2: TLabel
        Left = 18
        Top = 50
        Width = 57
        Height = 16
        Alignment = taRightJustify
        Caption = 'Atckode2'
        FocusControl = dbeLstAtc2
      end
      object Label3: TLabel
        Left = 36
        Top = 76
        Width = 38
        Height = 16
        Alignment = taRightJustify
        Caption = 'Adv.nr'
        FocusControl = dbeLstAdvNr
      end
      object Label4: TLabel
        Left = 38
        Top = 102
        Width = 37
        Height = 16
        Alignment = taRightJustify
        Caption = 'Vejl.nr'
        FocusControl = dbeLstVejNr
      end
      object Label5: TLabel
        Left = 128
        Top = 76
        Width = 43
        Height = 16
        Alignment = taRightJustify
        Caption = 'Niveau'
        FocusControl = dbeLstNiveau
      end
      object sbOver: TSpeedButton
        Tag = 1
        Left = 198
        Top = 20
        Width = 24
        Height = 25
        Hint = 'Vis oversigt (Alt + Pil Ned)'
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Layout = blGlyphRight
        ParentFont = False
        Visible = False
        OnClick = sbOverClick
      end
      object dbeLstAtc1: TDBEdit
        Left = 80
        Top = 20
        Width = 116
        Height = 24
        DataField = 'AtcKode1'
        DataSource = MainDm.dsIntAkt
        TabOrder = 0
      end
      object dbeLstAtc2: TDBEdit
        Left = 80
        Top = 46
        Width = 116
        Height = 24
        DataField = 'AtcKode2'
        DataSource = MainDm.dsIntAkt
        TabOrder = 1
      end
      object dbeLstAdvNr: TDBEdit
        Left = 80
        Top = 72
        Width = 40
        Height = 24
        DataField = 'AdvNr'
        DataSource = MainDm.dsIntAkt
        TabOrder = 2
      end
      object dbeLstVejNr: TDBEdit
        Left = 80
        Top = 98
        Width = 40
        Height = 24
        DataField = 'VejlNr'
        DataSource = MainDm.dsIntAkt
        TabOrder = 3
      end
      object dbeLstNiveau: TDBEdit
        Left = 176
        Top = 72
        Width = 20
        Height = 24
        DataField = 'AdvNiveau'
        DataSource = MainDm.dsIntAkt
        TabOrder = 4
      end
      object dbcbLstStar: TDBCheckBox
        Left = 126
        Top = 102
        Width = 70
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Stjerne'
        DataField = 'Stjerne'
        DataSource = MainDm.dsIntAkt
        TabOrder = 5
      end
      object dbmeLstVej: TDBMemo
        Left = 4
        Top = 132
        Width = 410
        Height = 359
        Anchors = [akLeft, akRight, akBottom]
        DataField = 'Tekst'
        DataSource = MainDm.dsIntTxt
        ScrollBars = ssVertical
        TabOrder = 6
      end
    end
  end
end
