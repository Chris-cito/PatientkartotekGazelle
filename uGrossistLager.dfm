object frmGrossistLager: TfrmGrossistLager
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Grossist lageroversigt'
  ClientHeight = 457
  ClientWidth = 1164
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gridLagerOversigt: TcxGrid
    Left = 0
    Top = 0
    Width = 1164
    Height = 396
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 60
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = False
    object gridLagerOversigtDBBandedTableView1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      DataController.DataSource = datasourceStock
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsSelection.ShowCheckBoxesDynamically = True
      OptionsView.FocusRect = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GridLines = glNone
      OptionsView.GroupByBox = False
      Styles.ContentEven = styleContentEven
      Styles.ContentOdd = styleContentOdd
      Styles.UseOddEvenStyles = bTrue
      Styles.OnGetContentStyle = gridLagerOversigtDBBandedTableView1StylesGetContentStyle
      Styles.Header = styleHeader
      Styles.Selection = styleSelection
      Styles.BandHeader = styleBandBackground
      Bands = <
        item
          Caption = 'Varevalg'
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Options.Sizing = False
        end
        item
          Caption = 'Lagerstatus'
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Options.Sizing = False
        end
        item
          Caption = 'Koder'
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Options.Sizing = False
        end
        item
          Caption = 'Pris'
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Options.Sizing = False
        end
        item
          Caption = 'Dato'
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Options.Sizing = False
        end
        item
          Caption = 'Vareinfo'
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Width = 449
        end
        item
          Caption = 'Bem'#230'rkninger'
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Width = 150
        end>
      object gridLagerOversigtDBBandedTableView1IsSelected: TcxGridDBBandedColumn
        Caption = ' '
        DataBinding.FieldName = 'IsSelected'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.Alignment = taCenter
        Properties.ImmediatePost = True
        Properties.OnEditValueChanged = cxGrid1DBBandedTableView1IsSelectedPropertiesEditValueChanged
        VisibleForExpressionEditor = bFalse
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.AutoWidthSizable = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Options.ShowCaption = False
        Options.Sorting = False
        Options.VertSizing = False
        VisibleForEditForm = bFalse
        VisibleForRowLayout = bFalse
        Width = 20
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1ItemNo: TcxGridDBBandedColumn
        Caption = 'Varenr.'
        DataBinding.FieldName = 'ProductNo'
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        MinWidth = 44
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.AutoWidthSizable = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 44
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1SupplierLocalQuantity: TcxGridDBBandedColumn
        Caption = 'Nomeco lokal'
        DataBinding.FieldName = 'SupplierLocalQuantity'
        PropertiesClassName = 'TcxLabelProperties'
        HeaderAlignmentHorz = taRightJustify
        MinWidth = 72
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.AutoWidthSizable = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 72
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1SupplierOtherQuantity: TcxGridDBBandedColumn
        Caption = 'Nomeco andre'
        DataBinding.FieldName = 'SupplierOtherQuantity'
        PropertiesClassName = 'TcxLabelProperties'
        HeaderAlignmentHorz = taRightJustify
        MinWidth = 80
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.AutoWidthSizable = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 80
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1PharmacyQuantity: TcxGridDBBandedColumn
        Caption = 'Apotek'
        DataBinding.FieldName = 'PharmacyQuantity'
        PropertiesClassName = 'TcxLabelProperties'
        HeaderAlignmentHorz = taRightJustify
        MinWidth = 44
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.AutoWidthSizable = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 44
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1ProductName: TcxGridDBBandedColumn
        Caption = 'Navn'
        DataBinding.FieldName = 'ProductName'
        PropertiesClassName = 'TcxLabelProperties'
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 120
        Position.BandIndex = 5
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1ProductForm: TcxGridDBBandedColumn
        Caption = 'Form'
        DataBinding.FieldName = 'ProductForm'
        PropertiesClassName = 'TcxLabelProperties'
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 120
        Position.BandIndex = 5
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1ProductStrength: TcxGridDBBandedColumn
        Caption = 'Styrke'
        DataBinding.FieldName = 'ProductStrength'
        PropertiesClassName = 'TcxLabelProperties'
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 70
        Position.BandIndex = 5
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1ProductPackaging: TcxGridDBBandedColumn
        Caption = 'Pakning'
        DataBinding.FieldName = 'ProductPackaging'
        PropertiesClassName = 'TcxLabelProperties'
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 120
        Position.BandIndex = 5
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1ProductType: TcxGridDBBandedColumn
        Caption = 'ABC'
        DataBinding.FieldName = 'ProductType'
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        MinWidth = 30
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.AutoWidthSizable = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 30
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1ProductCFlag: TcxGridDBBandedColumn
        Caption = 'C'
        DataBinding.FieldName = 'ProductCFlag'
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        MinWidth = 18
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.AutoWidthSizable = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 18
        Position.BandIndex = 2
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1UnitPrice: TcxGridDBBandedColumn
        Caption = 'Enh. pris'
        DataBinding.FieldName = 'UnitPrice'
        PropertiesClassName = 'TcxLabelProperties'
        HeaderAlignmentHorz = taRightJustify
        MinWidth = 52
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.AutoWidthSizable = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 52
        Position.BandIndex = 3
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1ExpirationDate: TcxGridDBBandedColumn
        Caption = 'Udl'#248'b'
        DataBinding.FieldName = 'ExpirationDate'
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        HeaderAlignmentHorz = taCenter
        MinWidth = 60
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.AutoWidthSizable = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 60
        Position.BandIndex = 4
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1DiscontinueDate: TcxGridDBBandedColumn
        Caption = 'Udg'#229'r'
        DataBinding.FieldName = 'DiscontinueDate'
        PropertiesClassName = 'TcxLabelProperties'
        Properties.Alignment.Horz = taCenter
        Visible = False
        HeaderAlignmentHorz = taCenter
        MinWidth = 52
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.AutoWidthSizable = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 4
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object gridLagerOversigtDBBandedTableView1BackorderInfo: TcxGridDBBandedColumn
        Caption = 'Restordre information'
        DataBinding.FieldName = 'BackorderInfo'
        PropertiesClassName = 'TcxLabelProperties'
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringWithFindPanel = False
        Options.Focusing = False
        Options.IgnoreTimeForFiltering = False
        Options.IncSearch = False
        Options.FilteringAddValueItems = False
        Options.FilteringFilteredItemsList = False
        Options.FilteringFilteredItemsListShowFilteredItemsOnly = False
        Options.FilteringMRUItemsList = False
        Options.FilteringPopup = False
        Options.FilteringPopupMultiSelect = False
        Options.ExpressionEditing = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 145
        Position.BandIndex = 6
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
    end
    object gridLagerOversigtLevel1: TcxGridLevel
      GridView = gridLagerOversigtDBBandedTableView1
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 396
    Width = 1164
    Height = 61
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 282
      Top = 13
      Width = 226
      Height = 13
      Caption = 'Den oprindelige vare er p'#229' lager hos grossisten'
    end
    object Label2: TLabel
      Left = 282
      Top = 34
      Width = 247
      Height = 13
      Caption = 'Den oprindelige vare er ikke p'#229' lager hos grossisten'
    end
    object Label3: TLabel
      Left = 618
      Top = 13
      Width = 153
      Height = 13
      Caption = 'Alternativ vare med fuldt tilskud'
    end
    object btnSearch: TButton
      Left = 148
      Top = 14
      Width = 58
      Height = 25
      Action = acSearch
      TabOrder = 0
      Visible = False
    end
    object btnVaelg: TButton
      Left = 13
      Top = 13
      Width = 129
      Height = 36
      Caption = '&Start reservation'
      TabOrder = 1
      OnClick = btnVaelgClick
    end
    object Panel1: TPanel
      Left = 261
      Top = 13
      Width = 15
      Height = 15
      BevelOuter = bvNone
      Color = 9961367
      ParentBackground = False
      TabOrder = 2
    end
    object Panel2: TPanel
      Left = 261
      Top = 34
      Width = 15
      Height = 15
      BevelOuter = bvNone
      Color = 10790143
      ParentBackground = False
      TabOrder = 3
    end
    object Panel3: TPanel
      Left = 597
      Top = 12
      Width = 15
      Height = 15
      BevelOuter = bvNone
      Caption = '*'
      Color = 9961471
      ParentBackground = False
      TabOrder = 4
    end
  end
  object nxLag: TnxTable
    TableName = 'LagerKartotek'
    Left = 392
    Top = 64
    object nxLagNavn: TStringField
      FieldName = 'Navn'
      Size = 30
    end
    object nxLagForm: TStringField
      FieldName = 'Form'
    end
    object nxLagStyrke: TStringField
      FieldName = 'Styrke'
    end
    object nxLagPakning: TStringField
      FieldName = 'Pakning'
      Size = 30
    end
    object nxLagLager: TWordField
      FieldName = 'Lager'
    end
    object nxLagVareNr: TStringField
      FieldName = 'VareNr'
    end
    object nxLagAntal: TIntegerField
      FieldName = 'Antal'
    end
    object nxLagSubKode: TStringField
      FieldName = 'SubKode'
      Size = 1
    end
    object nxLagSalgsPris: TCurrencyField
      FieldName = 'SalgsPris'
    end
    object nxLagBGP: TCurrencyField
      FieldName = 'BGP'
    end
    object nxLagSSKode: TStringField
      FieldName = 'SSKode'
      Size = 2
    end
    object nxLagEnhedsPris: TCurrencyField
      FieldName = 'EnhedsPris'
    end
    object nxLagEgenPris: TCurrencyField
      FieldName = 'EgenPris'
    end
    object nxLagPaknNum: TIntegerField
      FieldName = 'PaknNum'
    end
    object nxLagSubEnhPris: TCurrencyField
      FieldName = 'SubEnhPris'
    end
  end
  object nxQuery1: TnxQuery
    Left = 336
    Top = 64
  end
  object ActionManager1: TActionManager
    Left = 688
    Top = 72
    StyleName = 'Platform Default'
    object acSearch: TAction
      Caption = 'acSearch'
      OnExecute = acSearchExecute
    end
  end
  object datasetStock: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'IsSelected'
        DataType = ftBoolean
      end
      item
        Name = 'SortLevel'
        DataType = ftSmallint
      end
      item
        Name = 'ProductNo'
        DataType = ftString
        Size = 6
      end
      item
        Name = 'SupplierLocalQuantity'
        DataType = ftInteger
      end
      item
        Name = 'SupplierOtherQuantity'
        DataType = ftInteger
      end
      item
        Name = 'PharmacyQuantity'
        DataType = ftInteger
      end
      item
        Name = 'ProductName'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'ProductForm'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'ProductStrength'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'ProductPackaging'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'ProductType'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'ProductCFlag'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'UnitPrice'
        DataType = ftCurrency
      end
      item
        Name = 'ExpirationDate'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'DiscontinueDate'
        DataType = ftString
        Size = 8
      end
      item
        Name = 'BackorderInfo'
        DataType = ftString
        Size = 100
      end>
    IndexDefs = <
      item
        Name = 'idxStockPrimary'
        DescFields = 'ProductCFlag;SupplierLocalQuantity;SupplierOtherQuantity'
        Fields = 
          'SortLevel;ProductType;UnitPrice;ProductCFlag;SupplierLocalQuanti' +
          'ty;SupplierOtherQuantity'
        Options = [ixPrimary, ixDescending]
      end>
    IndexName = 'idxStockPrimary'
    FetchOnDemand = False
    Params = <>
    StoreDefs = True
    AfterPost = datasetStockAfterPost
    Left = 200
    Top = 184
    object datasetStockIsSelected: TBooleanField
      FieldName = 'IsSelected'
    end
    object datasetStockSortLevel: TSmallintField
      FieldName = 'SortLevel'
    end
    object datasetStockProductNo: TStringField
      FieldName = 'ProductNo'
      Size = 6
    end
    object datasetStockSupplierLocalQuantity: TIntegerField
      FieldName = 'SupplierLocalQuantity'
    end
    object datasetStockSupplierOtherQuantity: TIntegerField
      FieldName = 'SupplierOtherQuantity'
    end
    object datasetStockPharmacyQuantity: TIntegerField
      FieldName = 'PharmacyQuantity'
    end
    object datasetStockProductName: TStringField
      FieldName = 'ProductName'
      Size = 100
    end
    object datasetStockProductForm: TStringField
      FieldName = 'ProductForm'
      Size = 100
    end
    object datasetStockProductStrength: TStringField
      FieldName = 'ProductStrength'
      Size = 100
    end
    object datasetStockProductPackaging: TStringField
      FieldName = 'ProductPackaging'
      Size = 100
    end
    object datasetStockProductType: TStringField
      FieldName = 'ProductType'
      Size = 1
    end
    object datasetStockProductCFlag: TStringField
      FieldName = 'ProductCFlag'
      Size = 1
    end
    object datasetStockUnitPrice: TCurrencyField
      FieldName = 'UnitPrice'
    end
    object datasetStockExpirationDate: TStringField
      FieldName = 'ExpirationDate'
      Size = 8
    end
    object datasetStockDiscontinueDate: TStringField
      FieldName = 'DiscontinueDate'
      Size = 8
    end
    object datasetStockBackorderInfo: TStringField
      FieldName = 'BackorderInfo'
      Size = 100
    end
  end
  object datasourceStock: TDataSource
    DataSet = datasetStock
    Left = 296
    Top = 184
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 872
    Top = 88
    PixelsPerInch = 96
    object styleBandBackground: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = clGradientInactiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object styleHeader: TcxStyle
      AssignedValues = [svColor]
      Color = clBtnFace
    end
    object styleContentEven: TcxStyle
    end
    object styleContentOdd: TcxStyle
      AssignedValues = [svColor]
      Color = clInactiveBorder
    end
    object styleSelection: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 13821650
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TextColor = clWindowText
    end
    object styleContentZeroStock: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 10790143
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TextColor = clWindowText
    end
    object styleContentHasStock: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 9961367
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TextColor = clWindowText
    end
    object styleContentSuggestedSubstitute: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = 9961471
      TextColor = clWindowText
    end
  end
end
