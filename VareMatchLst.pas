unit VareMatchLst;

{$I bsdefine.inc}
{$R-,T-,H+,X+,M+}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Buttons, ExtCtrls, Mask, TypInfo,
  Variants,
  DBGrids, Db;

type
  TSetRangeEvent = procedure (Sender       : TObject;
                              ADataSet     : TDataSet;
                        const StartValues,
                              EndValues    : array of const) of object;

  TSearchEvent = procedure (Sender     : TObject;
                            ADataSet   : TDataSet;
                      const AValue     : Variant;
                            AFieldType : string) of object;

  TfrmSearch = class (TForm)
    dbgSearchGrid : TDBGrid;
    lblSearchWord : TLabel;
    Bevel         : TBevel;
    btnOK         : TBitBtn;
    btnCancel     : TBitBtn;
    edtSearchText : TMaskEdit;
    cbxSearch: TComboBox;
    Label1: TLabel;

    procedure dbgSearchGridTitleClick ( Column   : TColumn);
    procedure FormShow                ( Sender   : TObject);
    procedure dbgSearchGridMouseUp    ( Sender   : TObject;
                                        Button   : TMouseButton;
                                        Shift    : TShiftState;
                                        X, Y     : Integer);
    procedure edtSearchTextKeyDown    ( Sender   : TObject;
                                        var Key  : Word;
                                        Shift    : TShiftState);
    procedure dbgSearchGridKeyDown    ( Sender   : TObject;
                                        var Key  : Word;
                                        Shift    : TShiftState);
    procedure edtSearchTextChange     ( Sender   : TObject);
    procedure dbgSearchGridDblClick   ( Sender   : TObject);
  private
    DoSearch : Boolean; // Bestemmer om der skal foretages en søgning (bruges når EditMask sættes).

    // SetRange variable og events:
    FRangeFields    : string;
    FRangeFieldsVal : string;
    FOnSetRange     : TSetRangeEvent;
    FOnSearch       : TSearchEvent;
    // Sorterings kolonne variable:
//    FSortColFound   : Boolean;
    FSortCol        : Integer;
    FStartCol       : Integer;
    FSortColChar    : Char;
    Arr : Variant;
  public
    function Execute : integer;

    // SetRange Properties:
    property OnSetRange : TSetRangeEvent read FOnSetRange write FOnSetRange;
    property OnSearch   : TSearchEvent   read FOnSearch   write FOnSearch;
  end;

var
  frmSearch : TfrmSearch;

{ Viser søgeformen }
function ShowList (ACaption          : string;
                   AStartCol         : Integer;
                   ADataSource       : TDataSource;
                   const Values      : array of const;
                   const RangeFields : array of const;
                   SetRangeEvent     : TSetRangeEvent;
                   SearchEvent       : TSearchEvent   ) : Integer;

implementation

uses DM;

{$R *.DFM}

const
  ExtraGridSize = 38; // Ekstra gridstørrelse, så bredden på griddet passen.
  MinFormWidth = 197; // Minimum bredde på søgeformen.

  // Navigation keys:
  // VK_UP   : En linie op.
  // VK_DOWN : En linie ned.
  // VK_PRIOR: En side op.
  // VK_NEXT : En side ned.
  // VK_HOME : Gå til start.
  // VK_END  : Gå til slut.
  Nav_Keys = [VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT, VK_HOME, VK_END];

function ShowList (ACaption          : string;
                   AStartCol         : Integer;
                   ADataSource       : TDataSource;
                   const Values      : array of const;
                   const RangeFields : array of const;
                   SetRangeEvent     : TSetRangeEvent;
                   SearchEvent       : TSearchEvent   ): Integer;
var
  I, J    : Integer;
  tmpWidth: Integer;
begin
  Result:= 0;

  frmSearch:= TfrmSearch.Create (Application);

  with frmSearch do
  try
    dbgSearchGrid.DataSource := ADataSource;
    FStartCol                := AStartCol;

    // Definer griddets kollonner:
    if High (Values) > -1 then
    begin
      tmpWidth := ExtraGridSize;

      // Tilføj kollonner til griddet.
      // Felterne der skal tilføjes er defineret i Values.
      for i := 0 to High (Values) do begin
        with dbgSearchGrid do begin
          Columns.Add;
          Columns[i].FieldName     := Values[i].VPWideChar;
          tmpWidth := tmpWidth + Columns[i].Width; // Beregn midlertidig bredde på formen.
          // Tilføj linier i combo result
          J:= DataSource.DataSet.FieldByName(Columns[I].FieldName).Tag;
          if J > 0 then begin
            cbxSearch.AddItem(Columns[I].Title.Caption, TObject(J));
          end;
        end;
        cbxSearch.ItemIndex    := 0;
        cbxSearch.DropDownCount:= cbxSearch.Items.Count;
      end;

      // Afkod RangeFields der bruges til at sætte
      // ekstra søgenøgler og SetRange værdier:
      if High (RangeFields) > -1 then
      begin
        // Afkod første element:
        FRangeFields    := Copy (RangeFields[0].VPWideChar, 0,
                                 Pos ('=', RangeFields[0].VPWideChar) - 1) + ';';
        FRangeFieldsVal := Copy (RangeFields[0].VPWideChar,
                                 Pos ('=', RangeFields[0].VPWideChar) + 1,
                                 Length (RangeFields[0].VPWideChar) -
                                 Pos ('=', RangeFields[0].VPWideChar));
        // Afkod de resterende elementer:
        for i := 1 to High (RangeFields) do
        begin
          FRangeFields    := FRangeFields + Copy (RangeFields[0].VPWideChar, 0,
                               Pos ('=', RangeFields[0].VPWideChar) - 1) + ';';
          FRangeFieldsVal := FRangeFieldsVal + Copy (RangeFields[0].VPWideChar,
                               Pos ('=', RangeFields[0].VPWideChar) + 1,
                               Length (RangeFields[0].VPWideChar) -
                               Pos ('=', RangeFields[0].VPWideChar));
        end;
      end
      else begin
        // Er der ikke defineret nogen Range,
        // cleares formens Range felter:
        FRangeFields    := '';
        FRangeFieldsVal := '';
      end;

      // Set OnSetRange event til den tilsendte event handler.
      // Er der ikke defineret noget handler, er den NIL.
      FOnSetRange := SetRangeEvent;
      FOnSearch   := SearchEvent;   // <<< 8/5/2001 - STLA

      // Beregn forments bredde.
      Width := tmpWidth + dbgSearchGrid.Columns.Count;

      // Juster formens og sidste kollonnes bredde
      // hvis formens bredde er mindre en mindste
      // tilladte bredde.
      if Width < MinFormWidth then
      begin
        with dbgSearchGrid do
          Columns [Columns.Count-1].Width :=
            Columns [Columns.Count-1].Width + (MinFormWidth - Width);
        Width := MinFormWidth;
      end;
      Caption := ACaption; // Sæt formens titel.
//      Result:= Execute;
      if Execute = mrOk then begin
        // Result fra cbxSearch
        Result:= Integer(cbxSearch.Items.Objects[cbxSearch.ItemIndex]);
      end;
    end;
  except
//    Result := mrCancel;    // Ved en evt. exception, returneres der med mrCancel.
  end;
  FreeAndNil (frmSearch);  // Frigør formen.
end;

function TfrmSearch.Execute: integer;
var
  DBBookmark        : TBookmark;
  DBIndexFieldNames : string;
  DBIndexName       : string;
begin with dbgSearchGrid do begin
  // Gem nuværende position i tabellen:
  DBBookmark := DataSource.DataSet.GetBookmark;

  // Gem IndexFieldNames og IndexName på tabellen via RTTI:
  DBIndexFieldNames := GetStrProp (DataSource.DataSet, 'IndexFieldNames');
  DBIndexName       := GetStrProp (DataSource.DataSet, 'IndexName');

  // Gør første kolonne den valgte kollonne
  // der skal søges i. Derefter vises formen.
  dbgSearchGridTitleClick (Columns[FStartCol]);
  Result := ShowModal;
  // Genetabler indeks definitionerne ved hjælp af RTTI:
  SetStrProp (DataSource.DataSet, 'IndexFieldNames', DBIndexFieldNames);
  SetStrProp (DataSource.DataSet, 'IndexName',       DBIndexName);

  // Hvis søgning er afbrudt bliver gemt position genetableret:
  if Result = mrCancel then
    DataSource.DataSet.GotoBookmark (DBBookmark);

  // Frigør bookmark:
  DataSource.DataSet.FreeBookmark (DBBookmark);
end; end;

procedure TfrmSearch.dbgSearchGridTitleClick(Column: TColumn);
var
  i          : Integer;
  AClassName : ShortString;
begin
  with dbgSearchGrid do
  begin
    // Sæt fonten of baggrundsfarven i kollonnerne:
    for i := 0 to Columns.Count-1 do
      if i = Column.Index then
      begin // Aktive søgekollonne:
        Columns [i].Title.Font.Style := [fsBold];
        Columns [i].Color := clInfoBk;
        FSortCol := i;
        FSortColChar := Columns[i].Title.Caption[1];
      end
      else begin // Andre kollonner:
        Columns [i].Title.Font.Style := [];
        Columns [i].Color := clWindow;
      end;

    try
      // Sæt IndexFieldNames ved hjælp af RTTI:
      if DataSource.DataSet <> MainDm.cdKomEan then
      SetStrProp (DataSource.DataSet, 'IndexFieldNames', FRangeFields + Columns [Column.Index].FieldName);

      // Hvis der er sat en Range OnSetRange bruges til
      // at håndtere søgeformens Range:
      if Assigned (FOnSetRange) then
        FOnSetRange (Self, DataSource.DataSet, [FRangeFieldsVal], [FRangeFieldsVal]);
    except
      // I tilfælde af at indekset ikke er defineret i databasen/tabellen,
      // kastes der en exception, som blot ignoreres.
    end;

    try
      // Find kollonnefeltets ClassName:
      AClassName := DataSource.DataSet.FieldByName (Columns [Column.Index].FieldName).ClassName;
      DoSearch := False; // Forhindre at der sker søgning mens editmask sættes.
      edtSearchText.EditMask := DataSource.DataSet.FieldByName(Columns [Column.Index].FieldName).EditMask;
    except
      // I tilfælde af at EditMask ikke kan sættes,
      // kastes der en exception.
      DoSearch := False;
      edtSearchText.EditMask := '';
    end;

    DoSearch := True;
    edtSearchText.Clear;
    edtSearchText.Width := Columns [Column.Index].Width;
  end;
end;

procedure TfrmSearch.FormShow(Sender: TObject);
begin
  edtSearchText.SetFocus;
end;

procedure TfrmSearch.dbgSearchGridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  edtSearchText.SetFocus;
end;

procedure TfrmSearch.edtSearchTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (ssAlt in Shift) then
  begin
    if Key in Nav_Keys then
    begin
      SendMessage (dbgSearchGrid.Handle, WM_KEYDOWN, Key, 0);
      Key := 0;
    end;
  end
  else
  if (ssAlt in Shift) then dbgSearchGridKeyDown(Sender, Key, Shift);
end;

procedure TfrmSearch.dbgSearchGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

  function FindSortingCol(CountFrom: Integer): Boolean;
  var
    I : Integer;
  begin
    Result := False;
    for I := CountFrom to dbgSearchGrid.Columns.Count - 1 do
      if Ord(dbgSearchGrid.Columns[I].Title.Caption[1]) = Key then
        if not (fsBold in dbgSearchGrid.Columns[I].Title.Font.Style) then
        begin
          dbgSearchGridTitleClick(dbgSearchGrid.Columns[I]);
          Result := True;
          Break;
        end;
  end;

begin
  if not (ssAlt in Shift) then
  begin
    if not (Key in Nav_Keys) then
    begin
      SendMessage (edtSearchText.Handle, WM_KEYDOWN, Key, 0);
      Key := 0;
    end;
  end
  else
  if (ssAlt in Shift) then
  begin
    if Ord(FSortColChar) = Key then
    begin
      if not FindSortingCol(FSortCol + 1) then
        FindSortingCol(0);
    end else
      FindSortingCol(0);
(*
    if not FSortColFound then
      for I := 0 to dbgSearchGrid.Columns.Count - 1 do
        if Ord(dbgSearchGrid.Columns[I].Title.Caption[1]) = Key then
          if not (fsBold in dbgSearchGrid.Columns[I].Title.Font.Style) then
          begin
            dbgSearchGridTitleClick(dbgSearchGrid.Columns[I]);
            Break;
          end;
*) {!!! v1.05 - slut}
    Key := 0;
  end;
end;

procedure TfrmSearch.edtSearchTextChange(Sender: TObject);
begin
  try
  if DoSearch then
    with dbgSearchGrid.DataSource do
    try
      if Assigned (FOnSearch) then begin
        if Length (FRangeFields) = 0 then
          FOnSearch (Self, DataSet, edtSearchText.Text, GetStrProp (DataSet, 'IndexFieldNames'))
          else begin
          FOnSearch (Self, DataSet, VarArrayOf ([FRangeFieldsVal, edtSearchText.Text]),
            GetStrProp (DataSet, 'IndexFieldNames'));
          end;
        end else begin
      if FRangeFields = '' then
        DataSet.Locate (GetStrProp (DataSet, 'IndexFieldNames'),
                        edtSearchText.Text,
                        [loCaseInsensitive, loPartialKey])
          else begin
            arr[0] := FRangeFieldsVal;
            arr[1] := edtSearchText.Text;
        DataSet.Locate (GetStrProp (DataSet, 'IndexFieldNames'),
                        VarArrayOf ([FRangeFieldsVal, edtSearchText.Text]),
                        [loCaseInsensitive, loPartialKey]);

          end;
        end;
    except
    end;
  finally
    VarClear(Arr);
  end;
end;

procedure TfrmSearch.dbgSearchGridDblClick(Sender: TObject);
begin
  btnOK.Click;
end;

end.
