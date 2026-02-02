object EHFrame: TEHFrame
  Left = 0
  Top = 0
  Width = 1036
  Height = 599
  TabOrder = 0
  object Panel10: TPanel
    Left = 0
    Top = 0
    Width = 1036
    Height = 599
    Align = alClient
    TabOrder = 0
    ExplicitLeft = -476
    ExplicitTop = -185
    ExplicitWidth = 796
    ExplicitHeight = 425
    object Panel11: TPanel
      Left = 1
      Top = 1
      Width = 1034
      Height = 80
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 794
      object Label63: TLabel
        Left = 32
        Top = 14
        Width = 50
        Height = 13
        Caption = '&KundeCPR'
        FocusControl = edtCPR
      end
      object lblehlin: TLabel
        Left = 768
        Top = 19
        Width = 6
        Height = 13
        Caption = '&2'
        FocusControl = dbgEHLin
      end
      object lblehord: TLabel
        Left = 769
        Top = 2
        Width = 6
        Height = 13
        Caption = '&1'
        FocusControl = dbgEHOrd
      end
      object Label66: TLabel
        Left = 32
        Top = 48
        Width = 50
        Height = 13
        Caption = 'Start &Dato'
        FocusControl = dtpEhstart
      end
      object Label67: TLabel
        Left = 256
        Top = 48
        Width = 43
        Height = 13
        Caption = 'Slut d&ato'
        FocusControl = dtpEhSlut
      end
      object edtCPR: TEdit
        Left = 120
        Top = 10
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object btnFilter: TButton
        Left = 439
        Top = 44
        Width = 122
        Height = 25
        Caption = '&Filter'
        TabOrder = 4
      end
      object chkAabenEordre: TCheckBox
        Left = 276
        Top = 14
        Width = 97
        Height = 17
        Caption = #197'b&ne Ordrer'
        TabOrder = 1
      end
      object dtpEhstart: TDateTimePicker
        Left = 120
        Top = 44
        Width = 91
        Height = 24
        Date = 41555.548351099540000000
        Time = 41555.548351099540000000
        TabOrder = 2
      end
      object dtpEhSlut: TDateTimePicker
        Left = 318
        Top = 46
        Width = 91
        Height = 21
        Date = 41555.548538784720000000
        Time = 41555.548538784720000000
        TabOrder = 3
      end
    end
    object pnlEHButtons: TPanel
      Left = 1
      Top = 557
      Width = 1034
      Height = 41
      Align = alBottom
      TabOrder = 1
      ExplicitTop = 383
      ExplicitWidth = 794
      object btnSkiftStatus: TButton
        Left = 16
        Top = 6
        Width = 100
        Height = 25
        Caption = '&Skift Status'
        TabOrder = 0
      end
      object btnBeskeder: TButton
        Left = 174
        Top = 6
        Width = 100
        Height = 25
        Caption = '&Besked'
        TabOrder = 1
      end
      object btnSendKvit: TButton
        Left = 332
        Top = 6
        Width = 100
        Height = 25
        Caption = 'S&end Kvittering'
        TabOrder = 2
      end
      object btnPrint: TButton
        Left = 490
        Top = 6
        Width = 100
        Height = 25
        Caption = '&Udskriv Ordre'
        TabOrder = 3
      end
      object btnEHTakser: TButton
        Left = 648
        Top = 6
        Width = 100
        Height = 25
        Caption = '&Takser'
        TabOrder = 4
      end
    end
    object dbgEHOrd: TDBGrid
      Left = 1
      Top = 81
      Width = 1034
      Height = 167
      Align = alTop
      DataSource = MainDm.dsOrd
      ReadOnly = True
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object Panel13: TPanel
      Left = 1
      Top = 248
      Width = 1034
      Height = 41
      Align = alTop
      TabOrder = 3
      ExplicitWidth = 794
    end
    object dbgEHLin: TDBGrid
      Left = 1
      Top = 289
      Width = 1034
      Height = 268
      Align = alClient
      DataSource = MainDm.dsOrdLin
      ReadOnly = True
      TabOrder = 4
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'OrdinationType'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ReceptId'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'OrdinationsId'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Antal'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Varenummer'
          Title.Caption = 'Varenr'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Varenavn'
          Title.Caption = 'Navn'
          Width = 252
          Visible = True
        end>
    end
  end
end
