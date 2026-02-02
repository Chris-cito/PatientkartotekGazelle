unit PIBvARtmjU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OverbyteIcsWndControl, OverbyteIcsWSocket, StdCtrls, ExtCtrls,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPC, ComCtrls,
  DB, nxdb, DBGrids,generics.collections, DBCtrls, DBClient,TakserHuman, Vcl.Grids, Vcl.Mask;

type
  TfrmPIBVarTMJ = class(TForm)
    Timer1: TTimer;
    nxLag: TnxTable;
    nxLagNavn: TStringField;
    nxLagForm: TStringField;
    nxLagStyrke: TStringField;
    nxLagPakning: TStringField;
    nxLagLager: TWordField;
    nxLagVareNr: TStringField;
    Panel1: TPanel;
    Panel2: TPanel;
    nxLagSalgsTekst: TStringField;
    nxLagVareInfo: TIntegerField;
    DataSource1: TDataSource;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    nxLagLokation1: TIntegerField;
    nxLagAntal: TIntegerField;
    nxLagSalgsPris: TCurrencyField;
    cdsSuggestions: TClientDataSet;
    cdsSuggestionsForm: TStringField;
    cdsSuggestionsItenId: TIntegerField;
    cdsSuggestionsName: TStringField;
    cdsSuggestionsStrength: TStringField;
    cdsSuggestionsChain: TIntegerField;
    cdsReactions: TClientDataSet;
    cdsReactionsCategory: TIntegerField;
    cdsReactionsName: TStringField;
    cdsReactionsSuggestedItems: TDataSetField;
    cdsHeader: TClientDataSet;
    cdsHeaderVarenr: TStringField;
    cdsHeaderLines: TDataSetField;
    cdsSuggestionsAnbefaling: TStringField;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    dsReactions: TDataSource;
    DBGrid2: TDBGrid;
    dsSuggestions: TDataSource;
    nxLagAtcKode: TStringField;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure cdsSuggestionsCalcFields(DataSet: TDataSet);
    procedure cdsSuggestionsChainGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure DBGrid2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const {*****************************************************************************}
{* EBCDIC to ASCII                                                           *}
{*****************************************************************************}

  EtoA: array[0..255] of Word =
       ($00,$01,$02,$03,$04,$05,$06,$07, {00}
          $08,$09,$0A,$0B,$0C,$0D,$0E,$0F, {08}
        $10,$11,$12,$13,$14,$15,$16,$17, {10}
        $18,$19,$1A,$1B,$1C,$1D,$1E,$1F, {18}
        $20,$21,$22,$23,$24,$25,$26,$27, {20}
        $28,$29,$2A,$2B,$2C,$2D,$2E,$2F, {28}
        $30,$31,$32,$33,$34,$35,$36,$37, {30}
        $38,$39,$3A,$3B,$3C,$3D,$3E,$3F, {38}
        $20,$FF,$83,$84,$85,$A0,$C6,$86, {40}
        $87,$A4,$5B,$2E,$3C,$28,$2B,$21, {48}
        $26,$82,$88,$89,$8A,$A1,$8C,$8B, {50}
        $8D,$E1,$5D,$24,$2A,$29,$3B,$5E, {58}
        $2D,$2F,$B6,$8E,$B7,$B5,$C7,$8F, {60}
        $80,$A5,$DD,$2C,$25,$5F,$3E,$3F, {68}
        $9B,$90,$D2,$D3,$D4,$D6,$D7,$D8, {70}
        $DE,$60,$3A,$23,$40,$27,$3D,$22, {78}
        $9D,$61,$62,$63,$64,$65,$66,$67, {80}
        $68,$69,$AE,$AF,$D0,$EC,$E8,$F1, {88}
        $F8,$6A,$6B,$6C,$6D,$6E,$6F,$70, {90}
        $71,$72,$A6,$A7,$91,$F7,$92,$CF, {98}
        $E6,$7E,$73,$74,$75,$76,$77,$78, {A0}
        $79,$7A,$AD,$A8,$D1,$ED,$E7,$A9, {A8}
        $BD,$9C,$BE,$FA,$9F,$F5,$F4,$AC, {B0}
        $AB,$F3,$AA,$7C,$EE,$F9,$EF,$F2, {B8}
        $7B,$41,$42,$43,$44,$45,$46,$47, {C0}
        $48,$49,$F0,$93,$94,$95,$A2,$E4, {C8}
        $7D,$4A,$4B,$4C,$4D,$4E,$4F,$50, {D0}
        $51,$52,$D5,$96,$81,$97,$A3,$98, {D8}
        $5C,$E1,$53,$54,$55,$56,$57,$58, {E0}
        $59,$5A,$FD,$E2,$99,$E3,$E0,$E5, {E8}
        $30,$31,$32,$33,$34,$35,$36,$37, {F0}
        $38,$39,$FC,$EA,$9A,$EB,$E9,$FF);{F8}

{*****************************************************************************}
{* ASCII to EBCDIC                                                           *}
{*****************************************************************************}

  AtoE: array[0..255] of Word =
       ($00,$01,$02,$03,$04,$05,$06,$07, {00}
          $08,$09,$0A,$0B,$0C,$0D,$0E,$0F, {08}
        $10,$11,$12,$13,$B6,$B5,$16,$17, {10}
        $18,$19,$1A,$1B,$1C,$1D,$1E,$1F, {18}
        $40,$4F,$7F,$7B,$5B,$6C,$50,$7D, {20}
        $4D,$5D,$5C,$4E,$6B,$60,$4B,$61, {28}
        $F0,$F1,$F2,$F3,$F4,$F5,$F6,$F7, {30}
        $F8,$F9,$7A,$5E,$4C,$7E,$6E,$6F, {38}
        $7C,$C1,$C2,$C3,$C4,$C5,$C6,$C7, {40}
        $C8,$C9,$D1,$D2,$D3,$D4,$D5,$D6, {48}
        $D7,$D8,$D9,$E2,$E3,$E4,$E5,$E6, {50}
        $E7,$E8,$E9,$4A,$E0,$5A,$5F,$6D, {58}
        $79,$81,$82,$83,$84,$85,$86,$87, {60}
        $88,$89,$91,$92,$93,$94,$95,$96, {68}
        $97,$98,$99,$A2,$A3,$A4,$A5,$A6, {70}
        $A7,$A8,$A9,$C0,$BB,$D0,$A1,$41, {78}
        $68,$DC,$51,$42,$43,$44,$47,$48, {80}
        $52,$53,$54,$57,$56,$58,$63,$67, {88}
        $71,$9C,$9E,$CB,$CC,$CD,$DB,$DD, {90}
        $DF,$EC,$FC,$70,$B1,$80,$41,$B4, {98}
        $45,$55,$CE,$DE,$49,$69,$9A,$9B, {A0}
        $AB,$AF,$BA,$B8,$B7,$AA,$8A,$8B, {A8}
        $41,$41,$41,$41,$41,$65,$62,$64, {B0}
        $41,$41,$41,$41,$41,$B0,$B2,$41, {B8}
        $41,$41,$41,$41,$41,$41,$46,$66, {C0}
        $41,$41,$41,$41,$41,$41,$41,$9F, {C8}
        $08,$AC,$72,$73,$74,$DA,$75,$76, {D0}
        $77,$41,$41,$41,$41,$6A,$78,$41, {D8}
        $EE,$59,$EB,$ED,$CF,$EF,$A0,$AE, {E0}
        $8E,$FE,$FB,$FD,$8D,$AD,$BC,$BE, {E8}
        $CA,$8F,$BF,$B9,$B6,$B5,$41,$9D, {F0}
        $90,$BD,$B3,$41,$FA,$EA,$FE,$41);{F8}



var
  frmPIBVarTMJ: TfrmPIBVarTMJ;
  CopyVareList : TList<TakserHuman.PIBVarType>;
  g_varenr : string;
  function ShowVareinfo(VareList : TList<TakserHuman.PIBVarType>): string;


implementation


uses C2MainLog, ChkBoxes, Main,Clipbrd;


function ShowVareInfo(VareList : TList<TakserHuman.PIBVarType>): string;
var
  tmpVarenr : takserhuman.PIBVarType;
  first : boolean;
begin
  C2LogAdd('in tmj showvareinfo');
  Result := '';
  CopyVareList := TList<takserhuman.PIBVarType>.Create;
  try
    for tmpVarenr in VareList do
      if not tmpVarenr.Checked then
       CopyVareList.Add(tmpVarenr);
    first := True;
    for tmpVarenr in CopyVareList do
    begin
      if CopyVareList.Count > 1 then
      begin
        if not first then
        begin
          if not ChkBoxYesNo('Vis vareinfo for næste vare',True) then
            exit;
        end;
        first := False;
      end;
      frmPIBVarTMJ := TfrmPIBVarTMJ.Create(Nil);
      try
        g_varenr := tmpVarenr.VareNr;
        frmPIBVarTMJ.ShowModal;
      finally
        frmPIBVarTMJ.Free;
      end;
    end;
  finally
    CopyVareList.Free;
  end;

end;

{$R *.dfm}
function ToAscii(StrObj: AnsiString; Len: Integer) : AnsiString;
var
  i: Integer;
  tmpstr : AnsiString;
  ascn : integer;
begin
  tmpstr := '';
  for i := 1 to Len do begin
    ascn := Ord(strobj[i]);
    case ascn  of
      $C0 :       tmpstr := tmpstr + 'æ';
      $7B :       tmpstr := tmpstr + 'Æ';
      $6A :       tmpstr := tmpstr + 'ø';
      $7C :       tmpstr := tmpstr + 'Ø';
      $D0 :       tmpstr := tmpstr + 'å';
      $5B :       tmpstr := tmpstr + 'Å';
    else
{$WARNINGS OFF}
      tmpstr := tmpstr + Chr(EtoA[ascn]);
{$WARNINGS ON}
    end;
  end;
  Result := tmpstr;
end;


function ToEbcdic(StrObj: AnsiString; Len: Integer) : AnsiString;
var
  i: Integer;
  tmpstr : AnsiString;
  ascn : integer;
begin
  tmpstr := '';
  for i := 1 to Len do
  begin
    ascn := Ord(strobj[i]);
{$WARNINGS OFF}
    tmpstr := tmpstr + Chr(AtoE[ascn]);
{$WARNINGS ON}
  end;
  Result := tmpstr;
end;

procedure TfrmPIBVarTMJ.cdsSuggestionsCalcFields(DataSet: TDataSet);
begin
  cdsSuggestionsAnbefaling.AsString := trim(cdsSuggestionsName.AsString) + ' ' +
    trim(cdsSuggestionsForm.AsString) + ' ' + trim(cdsSuggestionsStrength.AsString);
end;

procedure TfrmPIBVarTMJ.cdsSuggestionsChainGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := '';
  if cdsSuggestionsChain.AsInteger = 0 then
    Text := 'Ja'
end;

procedure TfrmPIBVarTMJ.DBGrid2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in shift then
  begin
    if (key = ord('C')) or (key = ord('c')) then
      Clipboard.AsText := cdsSuggestionsName.AsString;
  end;
end;

procedure TfrmPIBVarTMJ.FormKeyPress(Sender: TObject; var Key: Char);
begin
  C2LogAdd('key is ' + Key);
  if key = #27 then
  begin
    ModalResult := mrCancel;
    frmPIBVarTMJ.Close;
    exit;
  end;
  if (key ='B') or (key ='b') then
  begin
    DBGrid1.SetFocus;
    key := #0;
    exit;
  end;
  if (key = 'A') or (key = 'a') then
  begin
    DBGrid2.SetFocus;
    key := #0;
    exit;
  end;

end;

procedure TfrmPIBVarTMJ.FormShow(Sender: TObject);
var
  book : TBookmark;
begin
  nxLag.Open;
  if FileExists('G:\TMJVareInfo.cds') then
    cdsHeader.LoadFromFile('G:\TMJVareInfo.cds');
  panel2.Visible := True;
  panel3.Visible := True;
  nxlag.IndexName := 'NrOrden';
  if not nxLag.FindKey([stamform.FLagerNr,g_varenr]) then
    exit;

  book := nxlag.Bookmark;
  try
    if (nxLagVareInfo.AsInteger and 2) <> 2 then
    begin
      panel2.Visible := False;
      panel3.Visible := False;
      exit;
    end;


    cdsHeader.IndexFieldNames := 'Varenr';
    if cdsHeader.FindKey([nxLagAtcKode.AsString]) then
    begin
      cdsHeader.SetRange([nxLagAtcKode.AsString],[nxLagAtcKode.AsString]);
      cdsReactions.First;
      cdsSuggestions.First;
      cdsSuggestions.IndexFieldNames := 'Chain;Name';
      DBGrid1.SetFocus;
      exit
    end
    else
    begin
      if cdsHeader.FindKey([nxLagVareNr.AsString]) then
      begin
        cdsHeader.SetRange([nxLagVareNr.AsString],[nxLagVareNr.AsString]);
        cdsReactions.First;
        cdsSuggestions.First;
        cdsSuggestions.IndexFieldNames := 'Chain;Name';
        DBGrid1.SetFocus;
        exit;
      end;
    end;
  finally
    nxlag.Bookmark := book;
  end;
end;


end.
