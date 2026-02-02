unit uGrossistLager;

{ Developed by: Cito IT A/S

  Description:

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  07-03-2024/OB   Minor corrections in the Grossist lagerstatus grid

  03-01-2024/OB   Replacing old socket communication with Nomeco and replacing it with Nomeco REST API call.
                  Updating the call to TMJ REST API to use REST classes and functions like Nomeco
                  References to dmMain removed, so the unit now is self contained and can be used in other projects.
                  Beautified form.

  09-01-2023/cjs  Koncern Apotek

  08-07-2022/cjs  Fixed isue where there was no substituition possibilities for a product
                  which lead to a blank screen in Grossistreservation stock list screen.

  05-07-2022/cjs  Fixed the button issue on the stock screen

  05-07-2022/cjs  Correction to check mark in Stock screen even if the stock at grossister is zero

  17-06-2022/cjs  Corrections for new reservation screen in line with Lagerkartotek

  03-06-2022/cjs  Correction to nomeco stock screen to open the lagerkartotek table

  31-05-2022/cjs  Corrected the checked product in Grossist reservation screen and added packsize

  31-05-2022/cjs  Changed the Grossist reservation screen to allow only one item to be selected

  31-03-2022/cjs  Corrected access violation error if no products returned in grossist reservation screen

  05-05-2020/cjs  removed unused variables

  14-08-2019/cjs  Replace in with = in subsdtitution sql which is now embedded in nomstk routine

  14-11-2016/RP   Fixed error, where program would stall if Lageropslag failed.
  07-09-2016/RP   Set warnings to off. Chris needs to review and fix.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, System.DateUtils,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPC, ComCtrls,
  DB, nxdb, generics.collections, json, REST.Client, REST.Types, REST.Authenticator.Simple,
  REST.Authenticator.OAuth,
  IPPeerClient, REST.Authenticator.Basic, msxml, OverbyteIcsWndControl,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, Datasnap.DBClient, MidasLib, cxCheckBox,
  cxCalendar, cxGridBandedTableView, cxGridDBBandedTableView, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  dxDateRanges, dxScrollbarAnnotations, cxDBData, cxLabel, System.Actions,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, cxTextEdit,
  Data.Bind.Components, Data.Bind.ObjectScope;

type
  TfrmGrossistLager = class(TForm)
    nxLag: TnxTable;
    nxLagNavn: TStringField;
    nxLagForm: TStringField;
    nxLagStyrke: TStringField;
    nxLagPakning: TStringField;
    nxLagLager: TWordField;
    nxLagVareNr: TStringField;
    nxQuery1: TnxQuery;
    nxLagAntal: TIntegerField;
    nxLagSubKode: TStringField;
    nxLagSalgsPris: TCurrencyField;
    nxLagBGP: TCurrencyField;
    nxLagSSKode: TStringField;
    nxLagEnhedsPris: TCurrencyField;
    nxLagEgenPris: TCurrencyField;
    nxLagPaknNum: TIntegerField;
    nxLagSubEnhPris: TCurrencyField;
    ActionManager1: TActionManager;
    acSearch: TAction;
    datasetStock: TClientDataSet;
    datasourceStock: TDataSource;
    gridLagerOversigtLevel1: TcxGridLevel;
    gridLagerOversigt: TcxGrid;
    gridLagerOversigtDBBandedTableView1: TcxGridDBBandedTableView;
    gridLagerOversigtDBBandedTableView1ItemNo: TcxGridDBBandedColumn;
    datasetStockProductNo: TStringField;
    datasetStockIsSelected: TBooleanField;
    datasetStockSupplierLocalQuantity: TIntegerField;
    datasetStockSupplierOtherQuantity: TIntegerField;
    datasetStockProductName: TStringField;
    datasetStockProductForm: TStringField;
    datasetStockProductStrength: TStringField;
    datasetStockProductPackaging: TStringField;
    datasetStockProductType: TStringField;
    datasetStockProductCFlag: TStringField;
    datasetStockBackorderInfo: TStringField;
    datasetStockUnitPrice: TCurrencyField;
    gridLagerOversigtDBBandedTableView1IsSelected: TcxGridDBBandedColumn;
    gridLagerOversigtDBBandedTableView1SupplierLocalQuantity: TcxGridDBBandedColumn;
    gridLagerOversigtDBBandedTableView1SupplierOtherQuantity: TcxGridDBBandedColumn;
    gridLagerOversigtDBBandedTableView1ProductName: TcxGridDBBandedColumn;
    gridLagerOversigtDBBandedTableView1ProductForm: TcxGridDBBandedColumn;
    gridLagerOversigtDBBandedTableView1ProductStrength: TcxGridDBBandedColumn;
    gridLagerOversigtDBBandedTableView1ProductPackaging: TcxGridDBBandedColumn;
    gridLagerOversigtDBBandedTableView1ProductType: TcxGridDBBandedColumn;
    gridLagerOversigtDBBandedTableView1ProductCFlag: TcxGridDBBandedColumn;
    gridLagerOversigtDBBandedTableView1UnitPrice: TcxGridDBBandedColumn;
    gridLagerOversigtDBBandedTableView1ExpirationDate: TcxGridDBBandedColumn;
    gridLagerOversigtDBBandedTableView1DiscontinueDate: TcxGridDBBandedColumn;
    gridLagerOversigtDBBandedTableView1BackorderInfo: TcxGridDBBandedColumn;
    gridLagerOversigtDBBandedTableView1PharmacyQuantity: TcxGridDBBandedColumn;
    datasetStockPharmacyQuantity: TIntegerField;
    datasetStockExpirationDate: TStringField;
    datasetStockDiscontinueDate: TStringField;
    cxStyleRepository1: TcxStyleRepository;
    styleBandBackground: TcxStyle;
    styleHeader: TcxStyle;
    styleContentEven: TcxStyle;
    styleContentOdd: TcxStyle;
    styleSelection: TcxStyle;
    styleContentZeroStock: TcxStyle;
    datasetStockSortLevel: TSmallintField;
    styleContentHasStock: TcxStyle;
    styleContentSuggestedSubstitute: TcxStyle;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnSearch: TButton;
    btnVaelg: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure btnVaelgClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure acSearchExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure datasetStockAfterPost(DataSet: TDataSet);
    procedure cxGrid1DBBandedTableView1IsSelectedPropertiesEditValueChanged(
      Sender: TObject);
    procedure gridLagerOversigtDBBandedTableView1StylesGetContentStyle(
      Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
  private
    { Private declarations }
    SelectedVare: string;
    FLager: integer;
    FVarenr: string;
    StartUpMode : boolean;
    FGrossistNr: integer;
    FVareList: TStringList;
    KontoNr: string;
    procedure SetLager(const Value: integer);
    procedure SetVarenr(const Value: string);
    procedure GetNomecoStockList(const ProductList: TStringList);
    procedure GetTMJStockList(const ProductList: TStringList);
    procedure BuildStocklist(ProductList: TStringList);
    property Lager : integer read FLager write SetLager;
    property Varenr : string read FVarenr write SetVarenr;
    property GrossistNr: integer read FGrossistNr write FGrossistNr;
    procedure BuildVareList;
    property VareList: TStringList read FVareList write FVareList;
  public
    { Public declarations }
    class function VisGrossistLager(NxDB: TnxDatabase; const AGrossistNr, ALager: Integer; const AKontoNr, AVarenr: string): string;
  end;


implementation

{$WARN IMPLICIT_STRING_CAST off}
{$WARN IMPLICIT_STRING_CAST_LOSS off}

uses C2MainLog, c2sqlscripts, ChkBoxes,uc2ui.procs, uNomeco.REST.Functions,
  uNomeco.REST.StockList.Classes, uTMJ.REST.StockList.Classes, uTMJ.REST.Functions;


{$R *.dfm}


procedure TfrmGrossistLager.cxGrid1DBBandedTableView1IsSelectedPropertiesEditValueChanged(
  Sender: TObject);
begin
  datasetStock.Post;
end;

procedure TfrmGrossistLager.datasetStockAfterPost(DataSet: TDataSet);
var
  ProductNo: string;
  TblBookmark: TBookmark;
begin
  if StartUpMode then
    Exit;

  // When one product is selected, all other products should be unselected
  with DataSet do
  begin
    if FieldByName('IsSelected').AsBoolean then
    begin

      DisableControls;

      ProductNo := FieldByName('ProductNo').AsString;
      TblBookmark := GetBookmark;


      First;
      while not Eof do
      begin
        if FieldByName('ProductNo').AsString <> ProductNo then
        begin
          Edit;
          FieldByName('IsSelected').AsBoolean := False;
          Post;
        end;

        Next;
      end;

      GotoBookmark(TblBookmark);

      EnableControls;

      FreeBookmark(TblBookmark);
    end;
  end;
end;

procedure TfrmGrossistLager.GetNomecoStockList(const ProductList: TStringList);
var
  i, Antal: Integer;
  NomecoRESTClient: TNomecoRESTClient;
  ErrorMsg: string;
  StockList: TNomecoStockList;
  VareListItem: TListItem;
  EgenPris: Currency;
begin
  NomecoRESTClient := TNomecoRESTClient.Create;
  StockList := TNomecoStockList.Create;

  StartUpMode := True;

  try
    if NomecoRESTClient.GetStockInfoList(StrToInt(KontoNr), ProductList, StockList, ErrorMsg) then
    begin
      nxLag.IndexName := 'NrOrden';

      datasetStock.Close;
      datasetStock.CreateDataset;
      for i := 0 to StockList.Items.Count - 1 do
      begin
        if nxLag.FindKey([Lager, StockList.Items[i].ProductNo.PadLeft(6, '0')]) then
        begin
          datasetStock.Append;

          if (StockList.Items[i].ProductNo.PadLeft(6, '0') = Varenr) and
             (StockList.Items[i].QtyInStock > 0) then
            datasetStock.FieldByName('IsSelected').AsBoolean := True
          else
            datasetStock.FieldByName('IsSelected').AsBoolean := False;

          datasetStock.FieldByName('ProductNo').AsString := StockList.Items[i].ProductNo.PadLeft(6, '0');
          datasetStock.FieldByName('SupplierLocalQuantity').AsInteger := StockList.Items[i].QtyInStock;
          datasetStock.FieldByName('SupplierOtherQuantity').AsInteger := StockList.Items[i].QtyInStockBranches;
          datasetStock.FieldByName('PharmacyQuantity').AsInteger := nxLagAntal.AsInteger;
          datasetStock.FieldByName('ProductName').AsString := nxLagNavn.AsString;
          datasetStock.FieldByName('ProductForm').AsString := nxLagForm.AsString;
          datasetStock.FieldByName('ProductStrength').AsString := nxLagStyrke.AsString;
          datasetStock.FieldByName('ProductPackaging').AsString := nxLagPakning.AsString;
          datasetStock.FieldByName('ProductType').AsString := nxLagSubKode.AsString;

          if (Pos(nxLagSubKode.AsString, 'BC') <> 0) and
             (Pos(nxLagSSKode.AsString, 'ASV') <> 0) and
             (nxLagSalgsPris.AsCurrency = nxLagBGP.AsCurrency) then
            datasetStock.FieldByName('ProductCFlag').AsString := '*'
          else
            datasetStock.FieldByName('ProductCFlag').AsString := '';

          if nxLagEgenPris.AsCurrency <> 0 then
          begin
            if nxLagPaknNum.AsInteger = 0 then
              datasetStock.FieldByName('UnitPrice').AsCurrency := nxLagSubEnhPris.AsCurrency
            else
            begin
              EgenPris := nxLagEgenPris.AsCurrency / (nxLagPaknNum.AsCurrency / 100);
              datasetStock.FieldByName('UnitPrice').AsCurrency := EgenPris;
            end;
          end
          else
            datasetStock.FieldByName('UnitPrice').AsCurrency := nxLagSubEnhPris.AsCurrency;

          if StockList.Items[i].DateExpiry = 0 then
            datasetStock.FieldByName('ExpirationDate').AsString := ''
          else
            datasetStock.FieldByName('ExpirationDate').AsString := FormatDateTime('DD-MM-YY', StockList.Items[i].DateExpiry);
          
          if StockList.Items[i].DateDiscontinued = 0 then
            datasetStock.FieldByName('DiscontinueDate').AsString := ''
          else
            datasetStock.FieldByName('DiscontinueDate').AsString := FormatDateTime('DD-MM-YY', StockList.Items[i].DateDiscontinued);

          datasetStock.FieldByName('BackorderInfo').AsString := StockList.Items[i].BackorderText;


          // Sort level
          // 1 = Actual product searching for
          // 2 = Local supplier stock quantity greater than 0
          // 3 = Other supplier stock quantity greater than 0
          // 4 = All stock quantities are 0
          if StockList.Items[i].ProductNo.PadLeft(6, '0') = Varenr then
             datasetStock.FieldByName('SortLevel').AsInteger := 1
          else
            if datasetStock.FieldByName('SupplierLocalQuantity').AsInteger > 0 then
              datasetStock.FieldByName('SortLevel').AsInteger := 2
            else
              if datasetStock.FieldByName('SupplierOtherQuantity').AsInteger > 0 then
                datasetStock.FieldByName('SortLevel').AsInteger := 3
              else
                datasetStock.FieldByName('SortLevel').AsInteger := 4;
         datasetStock.Post;
        end else
        begin
          datasetStock.Append;
          datasetStock.FieldByName('ProductName').AsString := 'Vare findes ikke i C2';
          datasetStock.FieldByName('SortLevel').AsInteger := 5;
          datasetStock.Post;
        end;

        datasetStock.First;
      end;
    end else
    begin
      ShowMessageBox(ErrorMsg, 'Fejl', MB_ICONERROR or MB_OK);
    end;
  finally
    NomecoRESTClient.Free;
    StockList.Free;
  end;

  StartUpMode := False;
end;

procedure TfrmGrossistLager.GetTMJStockList(const ProductList: TStringList);
var
  i: Integer;
  TMJRESTClient: TTMJRESTClient;
  ErrorMsg: string;
  StockList: TTMJStockList;
  EgenPris: Currency;
  ExpiryDate: TDate;
begin
  TMJRESTClient := TTMJRESTClient.Create;
  StockList := TTMJStockList.Create;

  StartUpMode := True;

  try
    if TMJRESTClient.GetStockInfoList(StrToInt(KontoNr), ProductList, StockList, ErrorMsg) then
    begin
      nxLag.IndexName := 'NrOrden';

      datasetStock.Close;
      datasetStock.CreateDataset;
      for i := 0 to StockList.Items.Count - 1 do
      begin
        if nxLag.FindKey([Lager, StockList.Items[i].ItemId]) then
        begin
          datasetStock.Append;

          if (StockList.Items[i].ItemId = Varenr) and
             (StockList.Items[i].OnStock > 0) then
            datasetStock.FieldByName('IsSelected').AsBoolean := True
          else
            datasetStock.FieldByName('IsSelected').AsBoolean := False;

          datasetStock.FieldByName('ProductNo').AsString := StockList.Items[i].ItemId;
          datasetStock.FieldByName('SupplierLocalQuantity').AsInteger := StockList.Items[i].OnStock;
          datasetStock.FieldByName('SupplierOtherQuantity').AsInteger := 0;
          datasetStock.FieldByName('PharmacyQuantity').AsInteger := nxLagAntal.AsInteger;
          datasetStock.FieldByName('ProductName').AsString := nxLagNavn.AsString;
          datasetStock.FieldByName('ProductForm').AsString := nxLagForm.AsString;
          datasetStock.FieldByName('ProductStrength').AsString := nxLagStyrke.AsString;
          datasetStock.FieldByName('ProductPackaging').AsString := nxLagPakning.AsString;
          datasetStock.FieldByName('ProductType').AsString := nxLagSubKode.AsString;

          if (Pos(nxLagSubKode.AsString, 'BC') <> 0) and
             (Pos(nxLagSSKode.AsString, 'ASV') <> 0) and
             (nxLagSalgsPris.AsCurrency = nxLagBGP.AsCurrency) then
            datasetStock.FieldByName('ProductCFlag').AsString := '*'
          else
            datasetStock.FieldByName('ProductCFlag').AsString := '';

          if nxLagEgenPris.AsCurrency <> 0 then
          begin
            if nxLagPaknNum.AsInteger = 0 then
              datasetStock.FieldByName('UnitPrice').AsCurrency := nxLagSubEnhPris.AsCurrency
            else
            begin
              EgenPris := nxLagEgenPris.AsCurrency / (nxLagPaknNum.AsCurrency / 100);
              datasetStock.FieldByName('UnitPrice').AsCurrency := EgenPris;
            end;
          end
          else
            datasetStock.FieldByName('UnitPrice').AsCurrency := nxLagSubEnhPris.AsCurrency;


          if StockList.Items[i].WorstExpiryDate = '' then
          begin
            datasetStock.FieldByName('ExpirationDate').AsString := '';
          end else
          begin
            try
              ExpiryDate := UnixToDateTime(StrToInt(Copy(StockList.Items[i].WorstExpiryDate, 7, 10)));
            except
              ExpiryDate := 0;
            end;

            if ExpiryDate = 0 then
              datasetStock.FieldByName('ExpirationDate').AsString := ''
            else
              datasetStock.FieldByName('ExpirationDate').AsString := FormatDateTime('DD-MM-YY', ExpiryDate);

          end;

          datasetStock.FieldByName('DiscontinueDate').AsString := '';
          datasetStock.FieldByName('BackorderInfo').AsString := StockList.Items[i].Remark;


          // Sort level
          // 1 = Actual product searching for
          // 2 = Local supplier stock quantity greater than 0
          // 3 = Other supplier stock quantity greater than 0
          // 4 = All stock quantities are 0
          if StockList.Items[i].ItemId = Varenr then
             datasetStock.FieldByName('SortLevel').AsInteger := 1
          else
            if datasetStock.FieldByName('SupplierLocalQuantity').AsInteger > 0 then
              datasetStock.FieldByName('SortLevel').AsInteger := 2
            else
              if datasetStock.FieldByName('SupplierOtherQuantity').AsInteger > 0 then
                datasetStock.FieldByName('SortLevel').AsInteger := 3
              else
                datasetStock.FieldByName('SortLevel').AsInteger := 4;
         datasetStock.Post;
        end else
        begin
          datasetStock.Append;
          datasetStock.FieldByName('ProductName').AsString := 'Vare findes ikke i C2';
          datasetStock.FieldByName('SortLevel').AsInteger := 5;
          datasetStock.Post;
        end;

        datasetStock.First;
      end;
    end else
    begin
      ShowMessageBox(ErrorMsg, 'Fejl', MB_ICONERROR or MB_OK);
    end;
  finally
    TMJRESTClient.Free;
    StockList.Free;
  end;

  StartUpMode := False;
end;

procedure TfrmGrossistLager.gridLagerOversigtDBBandedTableView1StylesGetContentStyle(
  Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  if ARecord.IsFirst then
  begin
    if ARecord.Values[gridLagerOversigtDBBandedTableView1SupplierLocalQuantity.Index] = 0 then
      AStyle := styleContentZeroStock
    else
      AStyle := styleContentHasStock;
  end else
  begin
    if ARecord.Values[gridLagerOversigtDBBandedTableView1ProductCFlag.Index] = '*' then
      AStyle := styleContentSuggestedSubstitute;
  end;
end;

procedure TfrmGrossistLager.BuildStocklist(ProductList: TStringList);
begin
  if GrossistNr = 2 then
    GetTMJStockList(ProductList)
  else
    GetNomecoStockList(ProductList);
end;

procedure TfrmGrossistLager.acSearchExecute(Sender: TObject);
var
  ProductList: TStringList;
  strVarernr: string;
begin
  ProductList := TStringList.Create;
  BusyMouseBegin;
  nxLag.Open;
  try
    ProductList.Add(Varenr);
    for strVarernr in VareList do
      if (ProductList.IndexOf(strVarernr) = -1) and (strVarernr <> Varenr) then
        ProductList.Add(strVarernr);

    if ProductList.Count <> 0 then
      BuildStocklist(ProductList);

    if (datasetStock.Active = True) and
       (datasetStock.RecordCount = 1) then
      ModalResult := mrCancel;

  finally
    ProductList.Free;
    nxLag.Close;
    nxQuery1.Close;
    btnSearch.Enabled := true;
    BusyMouseEnd;
  end;

end;

procedure TfrmGrossistLager.btnVaelgClick(Sender: TObject);
var
  TblBookmark: TBookmark;
begin
  SelectedVare := '';

  with datasetStock do
  begin
    DisableControls;

    TblBookmark := GetBookmark;

    First;
    while not Eof do
    begin
      if FieldByName('IsSelected').AsBoolean then
      begin
        SelectedVare := FieldByName('ProductNo').AsString;

        Break;
      end;

      Next;
    end;

    GotoBookmark(TblBookmark);

    EnableControls;

    FreeBookmark(TblBookmark);
  end;

  if SelectedVare = '' then
  begin
    ModalResult := mrNone;
    ChkBoxOK('Der er ikke valgt en vare.');
  end else
    ModalResult := mrOk;
end;

procedure TfrmGrossistLager.FormCreate(Sender: TObject);
begin
  FVareList := TStringList.Create;

  if Screen.Width < 1280 then
    Width := Screen.Width - 20;
end;

procedure TfrmGrossistLager.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FVareList);
end;

procedure TfrmGrossistLager.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    ModalResult := mrCancel;
  if Key = #13 then
    btnVaelg.Click;
end;

procedure TfrmGrossistLager.FormShow(Sender: TObject);
begin
  if GrossistNr = 1 then // Nomeco
  begin
    // nothing to do
  end;

  if GrossistNr = 2 then // TMJ
  begin
    gridLagerOversigtDBBandedTableView1SupplierOtherQuantity.Visible := False;
    gridLagerOversigtDBBandedTableView1SupplierLocalQuantity.Width := 44;
    gridLagerOversigtDBBandedTableView1SupplierLocalQuantity.Caption := 'TMJ';
  end;

  acSearch.Execute;
end;

procedure TfrmGrossistLager.SetLager(const Value: integer);
begin
  FLager := Value;
end;

procedure TfrmGrossistLager.SetVarenr(const Value: string);
begin
  FVarenr := Value;
end;

class function TfrmGrossistLager.VisGrossistLager(NxDB: TnxDatabase; const AGrossistNr, ALager: Integer; const AKontoNr, AVarenr: string): string;
var
  LfrmGrossistLager : TfrmGrossistLager;
begin
  LfrmGrossistLager := TfrmGrossistLager.Create(Nil);
  try
    Result := '';

    LfrmGrossistLager.nxQuery1.Database := NxDB;
    LfrmGrossistLager.nxLag.Database := NxDB;
    LfrmGrossistLager.nxLag.Open;

    LfrmGrossistLager.FGrossistNr :=  AGrossistNr;
    LfrmGrossistLager.KontoNr := AKontonr;
    LfrmGrossistLager.Varenr := AVarenr;
    LfrmGrossistLager.lager := ALager;
    LfrmGrossistLager.BuildVareList;

    if LfrmGrossistLager.VareList.Count = 0 then
      Exit(AVarenr);

    LfrmGrossistLager.StartUpMode := True;
    if LfrmGrossistLager.ShowModal = mrOk then
      Result := LfrmGrossistLager.SelectedVare;
  finally
    LfrmGrossistLager.Free;
  end;
end;

procedure TfrmGrossistLager.BuildVareList;
var
  LSubnr: string;
begin
  nxQuery1.SQL.Clear;
  nxQuery1.SQL.Add('declare RcpGebyr money;');
  nxQuery1.SQL.Add('Set RcpGebyr=(select RcpGebyr from recepturOplysninger);');
  nxQuery1.SQL.Add('SELECT');
  nxQuery1.SQL.Add('  S.Subnr,');
  nxQuery1.SQL.Add('  (case when s.antpkn = 0');
  nxQuery1.SQL.Add('    THEN');
  nxQuery1.SQL.Add('   V.SubKode');
  nxQuery1.SQL.Add('    ELSE');
  nxQuery1.SQL.Add('   ''(''+v.subkode+'')''');
  nxQuery1.SQL.Add('  END) AS Kode');
  nxQuery1.SQL.Add('FROM');
  nxQuery1.SQL.Add('(');
  nxQuery1.SQL.Add('  select * from LagerSubstListe');
  nxQuery1.SQL.Add('  where varenr = ''' + Varenr + '''');
  nxQuery1.SQL.Add(') AS S');
  nxQuery1.SQL.Add('inner join LagerKartotek AS V on');
  nxQuery1.SQL.Add('  V.VareNr=S.SubNr and');
  nxQuery1.SQL.Add('  V.Lager=:lager');
  nxQuery1.SQL.Add('WHERE');
  nxQuery1.SQL.Add('  (V.SLETDATO IS NULL or (V.SLETDATO IS NOT NULL and v.antal>0)) and');
  nxQuery1.SQL.Add('  V.AfmDato IS NULL');
  nxQuery1.SQL.Add('ORDER BY');
  nxQuery1.SQL.Add('  S.VareNr,');
  nxQuery1.SQL.Add('  EnhedsPris ASC,');
  nxQuery1.SQL.Add('  Salgspris ASC,');
  nxQuery1.SQL.Add('  Kode ASC,');
  nxQuery1.SQL.Add('  V.PaKode ASC');
  // C2Logadd(nxquery1.SQL.Text);
  // Parametre
  nxQuery1.ParamByName('lager').AsInteger := Lager;
  nxQuery1.Open;
  if nxQuery1.RecordCount = 0 then
    exit;
  nxQuery1.First;
  while not nxQuery1.Eof do
  begin
    LSubnr := nxQuery1.FieldByName('Subnr').AsString.Trim;
    if VareList.IndexOf(LSubnr) = -1 then
      VareList.Add(LSubnr);
    nxQuery1.Next;
  end;
end;

end.
