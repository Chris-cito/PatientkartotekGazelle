unit SubstOversigt;

{ Developed by: Cito IT A/S

  Description:

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  14-03-2023/cjs  Re-enable the grossist lager screen ready for deploy.

  08-03-2024/cjs  Disable new Grossist lager screen until testing is complete in lagerkartotek.

  01-03-2024/cjs  Allow the use of F7 (positivlist) in substitution screen

  27-02-2024/cjs  Delete the mininfo button after 1/3/24

  29-08-2022/cjs  Correction to substitution screen to allow view of background taksering screen

  24-06-2022/cjs  Updated the label for Nærmeste Apo and use the new SetPopupParent Routine

  23-06-2022/cjs  Added substform to parameter list for TFormC2AspNearbyStockStatus.ShowDialog
  to ensure the create z-order of forms

  21-06-2022/cjs  Added nearest pharmacy stock information as used in lagerkartotek

  23-02-2021/cjs  In eordre set the selected product in biottom window to be the
  same as the top.

  01-05-2020/cjs  removed th ' character from earch text in substitution screen

  21-04-2020/cjs  Improved searching using navn index better

  07-09-2016/RP   Suppressed warning.
  03-0-2018/CJS   Added 2d barcode processing + localised the clientdatasets etc
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DB, DBGrids, DBCtrls, StdCtrls, ExtCtrls, Buttons,
  uC2Vareidentifikator.Classes,
  generics.collections, Datasnap.DBClient, Datasnap.Provider, nxdb, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, uc2afdeling.Classes, frmC2AspNearbyStockStatus,
  uC2Asp.Connection.Classes, uC2Asp.Common.Types, uC2Asp, uFrmPositivlist, uGrossistLager;

type
  TSubstForm = class(TForm)
    paSub: TPanel;
    paSubBut: TPanel;
    grSub: TDBGrid;
    paTak: TPanel;
    paTakBut: TPanel;
    Label1: TLabel;
    eSoeg: TEdit;
    grTak: TDBGrid;
    buFortryd: TBitBtn;
    paReserver: TPanel;
    laVareNr: TLabel;
    buReserv: TBitBtn;
    dblKonti: TDBLookupComboBox;
    lbl1: TLabel;
    lbl2: TLabel;
    bitMini: TBitBtn;
    BitBtn1VisEksp: TBitBtn;
    chkVareLevsvigt: TCheckBox;
    fqTakst: TnxQuery;
    fqTakstMU: TStringField;
    fqTakstVarenr: TStringField;
    fqTakstNavn: TStringField;
    fqTakstForm: TStringField;
    fqTakstStyrke: TStringField;
    fqTakstPakning: TStringField;
    fqTakstPI: TStringField;
    fqTakstAntal: TIntegerField;
    fqTakstFormKode: TStringField;
    fqTakstSubKode: TStringField;
    fqTakstStyrkeNum: TIntegerField;
    fqTakstPaknNum: TIntegerField;
    fqTakstEnhedsPris: TCurrencyField;
    fqTakstskaffe: TStringField;
    dpSubst: TDataSetProvider;
    fqSubst: TnxQuery;
    fqSubstVareNr: TStringField;
    fqSubstSubnr: TStringField;
    fqSubstKode: TStringField;
    fqSubstMU: TStringField;
    fqSubstNavn: TStringField;
    fqSubstForm: TStringField;
    fqSubstStyrke: TStringField;
    fqSubstPakning: TStringField;
    fqSubstPI: TStringField;
    fqSubstAntal: TIntegerField;
    fqSubstForvalg: TStringField;
    fqSubstEnhedspris: TCurrencyField;
    fqSubstSalgspris: TCurrencyField;
    fqSubstAntpkn: TIntegerField;
    fqSubstskaffe: TStringField;
    fqSubstRO: TStringField;
    fqSubstlokation1: TIntegerField;
    fqSubstCTilsk: TStringField;
    fqSubstGrLevSvigtDato: TDateTimeField;
    fqSubstNySubKode: TStringField;
    dsTakst: TDataSource;
    cdTakst: TClientDataSet;
    cdTakstMU: TStringField;
    cdTakstVarenr: TStringField;
    cdTakstNavn: TStringField;
    cdTakstForm: TStringField;
    cdTakstStyrke: TStringField;
    cdTakstPakning: TStringField;
    cdTakstPI: TStringField;
    cdTakstAntal: TIntegerField;
    cdTakstFormKode: TStringField;
    cdTakstSubKode: TStringField;
    cdTakstStyrkeNum: TIntegerField;
    cdTakstPaknNum: TIntegerField;
    cdTakstEnhedsPris: TCurrencyField;
    cdTakstskaffe: TStringField;
    dpTakst: TDataSetProvider;
    cdSubst: TClientDataSet;
    cdSubstMU: TStringField;
    cdSubstVareNr: TStringField;
    cdSubstSubnr: TStringField;
    cdSubstKode: TStringField;
    cdSubstNavn: TStringField;
    cdSubstForm: TStringField;
    cdSubstStyrke: TStringField;
    cdSubstPakning: TStringField;
    cdSubstPI: TStringField;
    cdSubstAntal: TIntegerField;
    cdSubstForvalg: TStringField;
    cdSubstEnhedspris: TCurrencyField;
    cdSubstSalgspris: TCurrencyField;
    cdSubstAntPkn: TIntegerField;
    cdSubstskaffe: TStringField;
    cdSubstRO: TStringField;
    cdSubstlokation1: TIntegerField;
    cdSubstCTilsk: TStringField;
    cdSubstGrLevSvigtDato: TDateTimeField;
    cdSubstNySubKode: TStringField;
    dsSubst: TDataSource;
    bitNaermeste: TBitBtn;
    ActionManager1: TActionManager;
    acNaemeste: TAction;
    acVisPositivList: TAction;
    procedure FormShow(Sender: TObject);
    procedure buF6Click(Sender: TObject);
    procedure grTakEnter(Sender: TObject);
    procedure grTakExit(Sender: TObject);
    procedure grSubEnter(Sender: TObject);
    procedure grSubExit(Sender: TObject);
    procedure buReservClick(Sender: TObject);
    procedure grTakDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure grSubDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure bitMiniClick(Sender: TObject);
    procedure BitBtn1VisEkspClick(Sender: TObject);
    procedure chkVareLevsvigtClick(Sender: TObject);
    procedure eSoegEnter(Sender: TObject);
    procedure buFortrydClick(Sender: TObject);
    procedure CheckFirstSubNr;
    procedure grTakKeyPress(Sender: TObject; var Key: Char);
    procedure grSubKeyPress(Sender: TObject; var Key: Char);
    procedure grSubKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grTakKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure eSoegKeyPress(Sender: TObject; var Key: Char);
    procedure cdTakstAfterScroll(DataSet: TDataSet);
    procedure acNaemesteExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure acVisPositivListExecute(Sender: TObject);
  private
    { Private declarations }
    FVareNrOrg: string;
    FVareNrSub: string;
    WhichGrid: Integer;
    FirstSubNr: String;
    FVareIdent: TC2Vareident;
    FnxDB: TnxDatabase;
    FVareNrAntPkn: Integer;
    BottomScreen: boolean;
    FSubstResvPressed: boolean;
    FHideMininInfo: boolean;
    property VareIdent: TC2Vareident read FVareIdent write FVareIdent;
    property nxdb: TnxDatabase read FnxDB write FnxDB;
    procedure ShowNearbyStockForVarenr(AVarenr: string);
    property HideMininInfo: boolean read FHideMininInfo write FHideMininInfo;
  public
    { Public declarations }
    FSubValg, FLager: Word;
    property SubstResvPressed: boolean read FSubstResvPressed;
    property VareNrOrg: string read FVareNrOrg;
    property VareNrSub: String read FVareNrSub;
    property VareNrAntPkn: Integer read FVareNrAntPkn;
  end;

var
  SubstForm: TSubstForm;

function SubstOver(ANxdb: TnxDatabase; ALager: Word; var AVarenr: String): boolean;

implementation

uses
  C2MainLog,
  ChkBoxes,
  VareReservation,
  DM,
  uC2Vareidentifikator.Procs, uC2Vareidentifikator.Types,
  MidClientApi, Main, C2Procs, TakserHuman, uKundeOrd, frmC2VareMiniInfo,
  uc2ui.mainlog.Procs, uc2ui.Procs;

{$R *.DFM}

procedure TSubstForm.CheckFirstSubNr;
// var
// saveindex: string;
begin
  // if cdSubstSubnr.AsString <> FirstSubNr then
  // begin
  // // setting back Lagerkartotek to original VareNr
  // try
  // SaveIndex := dmMain.tblLagerKartotek1.IndexName;
  // dmMain.tblLagerKartotek1.IndexName := 'NrOrden';
  // dmMain.tblLagerKartotek1.FindKey([dmMain.tblLagerKartotek1Lager.Value, FirstSubNr]);
  // dmMain.tblLagerKartotek1.IndexName := SaveIndex;
  // except
  // on E: Exception do
  // begin
  // C2LogAdd('Failed to findkey on tlbLagerkartotek1 with VareNr: ' + FirstSubNr +
  // '. Error: ' + E.Message);
  // end;
  // end;
  // end;
end;

function SubstOver(ANxdb: TnxDatabase; ALager: Word; var AVarenr: String): boolean;
begin
  with SubstForm do
  begin
    FSubValg := C2IntPrm('Receptur', 'Substforvalg', 0);
    FVareNrOrg := '';
    FVareNrSub := '';
    eSoeg.Text := Trim(AVarenr);
    FLager := ALager;
    WhichGrid := 0;
    FnxDB := ANxdb;
    SetPopupParent(SubstForm, HumanForm);
    ShowModal;
    AVarenr := FVareNrOrg;
    if VareNrSub <> '' then
      AVarenr := FVareNrSub
    else
      FVareNrSub := VareNrOrg;
    Result := ModalResult = mrOK;
  end;
end;

procedure TSubstForm.FormCreate(Sender: TObject);
begin
  FHideMininInfo := SameText(C2StrPrm('kasse', 'disableminiinfo', ''), 'Ja');
end;

procedure TSubstForm.FormShow(Sender: TObject);
var
  Key: Char;
  int4: int64;
  sl: TStringList;
  tmpstr: string;
begin
  sl := TStringList.Create;
  try
    fqTakst.Database := nxdb;
    fqSubst.Database := nxdb;
    FSubstResvPressed := False;
    paReserver.Visible := (C2StrPrm('[Nomeco]   ', 'ReservUrl', '') <> '') or (C2StrPrm('[Tjellesen]', 'ReservUrl', '') <> '') or
      (C2StrPrm('[MaxJenne] ', 'ReservUrl', '') <> '');
    bitMini.Visible := True;
    if (HideMininInfo) or (Date >= EncodeDate(2024, 03, 1)) then
      bitMini.Visible := False;
    chkVareLevsvigt.Checked := True;
    if TryStrToInt64(eSoeg.Text, int4) then
      chkVareLevsvigt.Checked := False;
    cdTakst.Close;
    cdSubst.Close;
    eSoeg.SetFocus;
    if Trim(eSoeg.Text) <> '' then
    begin
      sl.Delimiter := ',';
      sl.DelimitedText := Trim(eSoeg.Text);
      for tmpstr in sl do
      begin
        if Trim(tmpstr) <> '' then
        begin
          Key := #13;
          eSoegKeyPress(Self, Key);
          break;
        end;
      end;
    end;
  finally
    sl.Free;
  end;
end;

procedure TSubstForm.buF6Click(Sender: TObject);
begin
  CheckFirstSubNr;

  FVareNrAntPkn := 0;
  if ActiveControl = grTak then
  begin
    FVareNrOrg := cdTakstVarenr.AsString;
    FVareNrSub := '';
    ModalResult := mrOK;
  end;
  if ActiveControl = grSub then
  begin
    FVareNrOrg := cdTakstVarenr.AsString;
    FVareNrSub := cdSubstSubnr.AsString;
    if cdSubstAntPkn.AsInteger <> 0 then
      FVareNrAntPkn := cdSubstAntPkn.AsInteger;
    ModalResult := mrOK;
  end;
end;

procedure TSubstForm.buFortrydClick(Sender: TObject);
begin
  CheckFirstSubNr;
end;

procedure TSubstForm.grTakEnter(Sender: TObject);
begin
  WhichGrid := 1;
  grTak.Color := clYellow;
  grSub.Color := clWindow;
  BottomScreen := False;
end;

procedure TSubstForm.grTakExit(Sender: TObject);
begin
  // grTak.Color:= clWindow;
end;

procedure TSubstForm.grTakKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift = [] then
  begin
    if Key = VK_F6 then
    begin
      buF6Click(Sender);
      Key := 0;
    end;
  end;

end;

procedure TSubstForm.grTakKeyPress(Sender: TObject; var Key: Char);
var
  FVlg: boolean;
begin

  if Key <> #13 then
    exit;

  // Hvis in subst så forlades med F6
  if cdSubst.RecordCount = 0 then
  begin
    buF6Click(Sender);
    Key := #0;
    exit;
  end;
  FVlg := False;


  // Egne forvalg;

  case FSubValg of
    1:
      begin // Første på lager
        cdSubst.First;
        while not cdSubst.Eof do
        begin
          if (cdSubstAntal.AsInteger > 0) then
          begin
            // forvalg fundet stop
            FVlg := True;
            break;
          end;
          cdSubst.Next;
        end;
      end;
    2:
      begin // Samme hvis A/B
        cdSubst.First;
        while not cdSubst.Eof do
        begin
          if ((cdTakstSubKode.AsString < 'C') or (cdTakstSubKode.AsString = 'X')) and
            (cdSubstSubnr.AsString = cdTakstVarenr.AsString) then
          begin
            // forvalg fundet stop
            FVlg := True;
            break;
          end;
          cdSubst.Next;
        end;
      end;
    3:
      begin // Samme hvis C
        cdSubst.First;
        while not cdSubst.Eof do
        begin
          if ((cdTakstSubKode.AsString = 'C') or (cdTakstSubKode.AsString = 'X')) and
            (cdSubstSubnr.AsString = cdTakstVarenr.AsString) then
          begin
            // forvalg fundet stop
            FVlg := True;
            break;
          end;
          cdSubst.Next;
        end;
      end;
    4:
      begin // Altid samme
        cdSubst.First;
        while not cdSubst.Eof do
        begin
          if cdSubstSubnr.AsString = cdTakstVarenr.AsString then
          begin
            // forvalg fundet stop
            FVlg := True;
            break;
          end;
          cdSubst.Next;
        end;
      end;
    5:
      begin // same as 2 but for Egtved
        cdSubst.First;
        while not cdSubst.Eof do
        begin
          if ((cdTakstSubKode.AsString < 'B') or (cdTakstSubKode.AsString = 'X')) and
            (cdSubstSubnr.AsString = cdTakstVarenr.AsString) then
          begin
            // forvalg fundet stop
            FVlg := True;
            break;
          end;
          cdSubst.Next;
        end;
      end;
  else
    cdSubst.First;
  end;
  // Check andet forvalg end egne markeringer
  if not FVlg then
  begin
    cdSubst.First;
    while not cdSubst.Eof do
    begin
      if cdSubstForvalg.AsString <> '' then
      begin
        // forvalg fundet stop
        FVlg := True;
        break;
      end;
      cdSubst.Next;
    end;
  end;
  // Hvis stadig ingen forvalg
  if not FVlg then
    cdSubst.First;

  // if ej s then choose the product that is that number in the top
  // part of the screen
  try
    if (pos('-S', HumanForm.paInfo.Caption) <> 0) or (maindm.ffPatKarEjSubstitution.AsBoolean) then
    begin
      cdSubst.First;
      while not cdSubst.Eof do
      begin
        if cdSubstSubnr.AsString = cdTakstVarenr.AsString then
          break;
        cdSubst.Next;
      end;
    end;
  except
  end;

  // Setfocus i grSub
  grSub.SetFocus;
  Key := #0;

end;

procedure TSubstForm.grSubEnter(Sender: TObject);
begin
  WhichGrid := 2;
  grSub.Color := clYellow;
  grTak.Color := clWindow;
  BottomScreen := True;
end;

procedure TSubstForm.grSubExit(Sender: TObject);
begin
  // grSub.Color:= clWindow;
end;

procedure TSubstForm.grSubKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Shift = [] then
  begin
    if Key = VK_F6 then
    begin
      buF6Click(Sender);
      Key := 0;
    end;
  end;

end;

procedure TSubstForm.grSubKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then
    exit;

  buF6Click(Sender);
  Key := #0;
  exit;

end;

procedure TSubstForm.buReservClick(Sender: TObject);
var
  Resv, Bekr: Word;
  LVareNr: String;
  Vare: TVareRec;
  LSave_VareNr: string;
begin
  with MidClient do
  begin
    try
      FSubstResvPressed := True;
      Resv := 1;
      Bekr := 0;
      if WhichGrid <> 2 then
        LVareNr := cdTakstVarenr.AsString
      else
        LVareNr := cdSubstSubnr.AsString;
      // Grossist
      if maindm.mtGroGrNr.AsInteger = 0 then
      begin
        ChkBoxOk('Der mangler konto for reservation!');
        exit;
      end;
      c2logadd('2:Shall we show nomeco screen?');
      try
        if maindm.fqKto.FieldByName('VisVareHost').AsString <> '' then
        begin
          LSave_VareNr := LVareNr;
          c2logadd('about to shownomecostk with ' + FLager.ToString + ' ' + LVareNr);
          LVareNr := TfrmGrossistLager.VisGrossistLager(nxdb,
                                                        MainDm.fqKto.FieldByName('GrOplNr').AsInteger,
                                                        FLager,
                                                        MainDm.fqKto.FieldByName('Kontonr').AsString,
                                                        LVareNr);
//          LVareNr := TfrmNomecoStk.ShowNomecoStk(FLager, LVareNr);

          if LVareNr = '' then
            LVareNr := LSave_VareNr;
          if LVareNr <> LSave_VareNr then
            WhichGrid := 2;
        end;
      except
        on E: Exception do
          c2logadd('2: Vis Vare function not setup !!!! ' + E.Message);
      end;
      // Reservation
      Bekr := 0;
      if TfrmRes.ReserverVare(maindm.fqKto, LVareNr, Resv, Bekr, False) then
      begin
        FillChar(Vare, SizeOf(Vare), 0);
{$WARN IMPLICIT_STRING_CAST_LOSS off}
        Vare.Nr := LVareNr;
{$WARN IMPLICIT_STRING_CAST_LOSS on}
        Vare.Antal := Bekr;
        Vare.Lager := maindm.fqKto.FieldByName('Lager').AsInteger;
        Vare.EgenGrp := maindm.fqKto.FieldByName('GrNr').AsInteger;
        MidClient.BestilVare(Vare);
        if Vare.Status <> AppResOK then
          MidClient.ClientError(Vare.Status);
      end;
    finally
      if WhichGrid <> 2 then
      begin
        grTak.SetFocus;
      end
      else
      begin
        if cdSubst.RecordCount = 0 then
        begin
          WhichGrid := 1;
          grTak.SetFocus;
        end
        else
        begin
          cdSubst.First;
          while not cdSubst.Eof do
          begin
            if cdSubstSubnr.AsString = LVareNr then
              break;
            cdSubst.Next;
          end;

          grSub.SetFocus;
        end;
      end;

    end;
  end;
end;

procedure TSubstForm.cdTakstAfterScroll(DataSet: TDataSet);
begin
  if not cdSubst.Filtered then
    exit;

  cdSubst.Filtered := False;
  cdSubst.Filter := 'VareNr = ' + AnsiQuotedStr(cdTakstVarenr.AsString, '''');
  if chkVareLevsvigt.Checked then
    cdSubst.Filter := cdSubst.Filter + ' and (MU='''' or (MU<>'''' AND antal<>0))';
  cdSubst.Filtered := True;
  grSub.Width := grSub.Width + 1;
  // if cdSubst.RecordCount <= 1 then begin
  // // Uden elevator
  // SubstForm.grSub.Columns[2].Width:= 227;
  // end else begin
  // // Med elevator
  // SubstForm.grSub.Columns[2].Width:= 211;
  // end;
end;

procedure TSubstForm.grTakDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if not SameText(StamForm.SkaffevareBar, 'NEJ') then
  begin
    if DataCol in [10] then
      if (cdTakstskaffe.AsString = '-') and (cdTakstAntal.AsInteger > 0) then
        grTak.Canvas.Brush.Color := C2StrToColor(StamForm.SkaffevareBar);
  end;
  if cdTakstMU.AsString <> '' then
    grTak.Canvas.Brush.Color := ClRed;
  grTak.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TSubstForm.grSubDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  try
    if not SameText(StamForm.SkaffevareBar, 'NEJ') then
    begin
      if DataCol in [13] then
        if (cdSubstskaffe.AsString = '-') and (cdSubstAntal.AsInteger > 0) then
          grSub.Canvas.Brush.Color := C2StrToColor(StamForm.SkaffevareBar);
    end;
    if cdSubstForvalg.AsString <> '' then
    begin

      if (cdSubstForvalg.AsString = 'S') then
        exit;
      if cdSubstForvalg.AsString = 'F' then
        grSub.Canvas.Brush.Color := tcolor($00B800)
      else
        grSub.Canvas.Brush.Color := clLime;
      // grSub.Canvas.Font.Color := clBlack;

    end;
    if cdSubstMU.AsString <> '' then
      grSub.Canvas.Brush.Color := ClRed;
    if (cdSubstAntPkn.AsInteger <> 0) and (cdSubstAntPkn.AsInteger <> 1) then
      grSub.Canvas.Brush.Color := clgray;
  finally
    grSub.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;

end;

procedure TSubstForm.bitMiniClick(Sender: TObject);
begin
  //
  case WhichGrid of
    0, 1:
      TFormC2VareMiniInfo.ShowMiniInfo(nxdb, cdTakstVarenr.AsString);
    2:
      TFormC2VareMiniInfo.ShowMiniInfo(nxdb, cdSubstSubnr.AsString);
  end;
end;

procedure TSubstForm.chkVareLevsvigtClick(Sender: TObject);
begin
  try
    if cdTakst.Active then
    begin

      if chkVareLevsvigt.Checked then
      begin
        cdTakst.Filtered := True;
        if cdTakst.RecordCount <> 0 then
          cdTakst.First;
      end
      else
      begin
        cdTakst.Filtered := False;
        if cdTakst.RecordCount <> 0 then
          cdTakst.First;
      end;
    end;
  except

  end;
  case WhichGrid of
    0:
      eSoeg.SetFocus;
    1:
      grTak.SetFocus;
    2:
      grSub.SetFocus;
  end;

end;

procedure TSubstForm.eSoegEnter(Sender: TObject);
begin
  WhichGrid := 0;
end;

procedure TSubstForm.eSoegKeyPress(Sender: TObject; var Key: Char);
var
  VNr: Integer;
  Sql, Prm, PArg, Arg1, Arg2, Arg3: String;
  int4: int64;
  CheckStyrke: string;
  ipos: Integer;
  StyrkeStr: string;

  procedure BuildTakstSqlByVarenr;
  begin

    // Søgning på varenr
    fqTakst.Sql.Clear;
    fqTakst.Sql.Add('declare RcpGebyr money;');
    fqTakst.Sql.Add('set RcpGebyr=(select RcpGebyr from recepturOplysninger);');

    fqTakst.Sql.Add('SELECT');
    fqTakst.Sql.Add('  CASE');
    fqTakst.Sql.Add('    WHEN (V.Sletdato is not NULL) or (V.Afmdato is not null) THEN ''*''');
    fqTakst.Sql.Add('    ELSE '''' END AS MU');
    fqTakst.Sql.Add('  ,V.Varenr');
    fqTakst.Sql.Add('  ,V.Navn');
    fqTakst.Sql.Add('  ,V.Form');
    fqTakst.Sql.Add('  ,V.Styrke');
    fqTakst.Sql.Add('  ,V.Pakning');
    fqTakst.Sql.Add('  ,V.PaKode AS PI');
    fqTakst.Sql.Add('  ,COALESCE(V.Antal, 0) AS Antal');
    fqTakst.Sql.Add('  ,V.FormKode');
    fqTakst.Sql.Add('  ,V.SubKode');
    fqTakst.Sql.Add('  ,V.StyrkeNum');
    fqTakst.Sql.Add('  ,V.PaknNum');
    fqTakst.Sql.Add('  ,(case when v.egenpris<>0');
    fqTakst.Sql.Add('	THEN');
    fqTakst.Sql.Add('		(case WHEN V.Paknnum = 0');
    fqTakst.Sql.Add('			then');
    fqTakst.Sql.Add('				v.SUBENHpris');
    fqTakst.Sql.Add('			ELSE');
    fqTakst.Sql.Add('				((V.EGENPRIS+RcpGebyr)/(V.PaknNum/100.0))');
    fqTakst.Sql.Add('		END)');

    fqTakst.Sql.Add('	ELSE V.SubEnhPris');
    fqTakst.Sql.Add('  END) as EnhedsPris');
    fqTakst.Sql.Add('	,(case 	when v.minimum=-1 and v.genbestil=1 then ''-''');
    fqTakst.Sql.Add('		when v.minimum>=0 and v.genbestil>0 then ''+''');
    fqTakst.Sql.Add('		else ''''');
    fqTakst.Sql.Add('   	end) as skaffe');
    fqTakst.Sql.Add('	,v.doegnet');
    fqTakst.Sql.Add('	,v.lokation1');

    fqTakst.Sql.Add('FROM');
    fqTakst.Sql.Add('  LagerKartotek AS V');
    fqTakst.Sql.Add('WHERE');
    fqTakst.Sql.Add('  V.Lager=:lager AND');
    fqTakst.Sql.Add('V.Varenr=:Varenr');

    fqTakst.Sql.Add('ORDER BY');
    fqTakst.Sql.Add('  Navn');
    fqTakst.Sql.Add('  ,Formkode');
    fqTakst.Sql.Add('  ,StyrkeNum');
    fqTakst.Sql.Add('  ,PaknNum ');
    // Parametre
    fqTakst.ParamByName('lager').AsInteger := FLager;
    fqTakst.ParamByName('Varenr').AsString := PArg;

  end;

  procedure BuildTakstSqlByTekst;
  var
    arglist: TStringList;
    PDel: Integer;
  begin
    arglist := TStringList.Create;
    try
      // Søgning på varetekst
      arglist.Delimiter := ',';
      arglist.StrictDelimiter := True;
      arglist.DelimitedText := PArg;
      for PDel := 0 to arglist.Count - 1 do
      begin
        case PDel of
          0:
            Arg1 := arglist.Strings[PDel];
          1:
            Arg2 := arglist.Strings[PDel];
          2:
            Arg3 := arglist.Strings[PDel];
        end;

      end;
      Arg1 := Trim(AnsiUpperCase(Arg1));
      if Arg1 = '' then
      begin
        Key := #0;
        exit;
      end;

      if length(Arg1) > 30 then
      begin
        Key := #0;
        exit;
      end;

      Arg2 := UpperCase(Arg2.Trim);
      Arg3 := UpperCase(Arg3.Trim);

      // Søgning
      fqTakst.Sql.Clear;
      fqTakst.Sql.Add('declare RcpGebyr money;');
      fqTakst.Sql.Add('set RcpGebyr=(select RcpGebyr from recepturOplysninger);');

      fqTakst.Sql.Add('SELECT');
      fqTakst.Sql.Add('  CASE');
      fqTakst.Sql.Add('    WHEN (V.Sletdato is not NULL) or (V.Afmdato is not null) THEN ''*''');
      fqTakst.Sql.Add('    ELSE '''' END AS MU,');
      fqTakst.Sql.Add('  V.Varenr,');
      fqTakst.Sql.Add('  V.Navn,');
      fqTakst.Sql.Add('  V.Form,');
      fqTakst.Sql.Add('  V.Styrke,');
      fqTakst.Sql.Add('  V.Pakning,');
      fqTakst.Sql.Add('  V.PaKode AS PI,');
      fqTakst.Sql.Add('  COALESCE(V.Antal, 0) AS Antal,');
      fqTakst.Sql.Add('  V.FormKode,');
      fqTakst.Sql.Add('  V.SubKode,');
      fqTakst.Sql.Add('  V.StyrkeNum,');
      fqTakst.Sql.Add('  V.PaknNum,');
      fqTakst.Sql.Add('  (case when v.egenpris<>0');
      fqTakst.Sql.Add('	THEN');
      fqTakst.Sql.Add('		(case WHEN V.Paknnum = 0');
      fqTakst.Sql.Add('			then');
      fqTakst.Sql.Add('				v.SUBENHpris');
      fqTakst.Sql.Add('			ELSE');
      fqTakst.Sql.Add('				((V.EGENPRIS+RcpGebyr)/(V.PaknNum/100.0))');
      fqTakst.Sql.Add('		END)');

      fqTakst.Sql.Add('	ELSE V.SubEnhPris');
      fqTakst.Sql.Add('  END) as EnhedsPris,');
      fqTakst.Sql.Add('	(case 	when v.minimum=-1 and v.genbestil=1 then ''-''');
      fqTakst.Sql.Add('		when v.minimum>=0 and v.genbestil>0 then ''+''');
      fqTakst.Sql.Add('		else ''''');
      fqTakst.Sql.Add('   	end) as skaffe,');
      fqTakst.Sql.Add('	v.doegnet,');
      fqTakst.Sql.Add('	v.lokation1');

      fqTakst.Sql.Add('FROM');
      fqTakst.Sql.Add('  LagerKartotek AS V');
      fqTakst.Sql.Add('WHERE');
      fqTakst.Sql.Add('  V.Lager=:lager AND');
      // fqTakst.SQL.Add('POSITION(UPPER(:PRM1) IN upper(navn))=1');
      fqTakst.Sql.Add('NAVN LIKE ''' + Arg1 + '%'' IGNORE CASE');
      if Arg2 <> '' then
        fqTakst.Sql.Add('and Pakning like ''%' + Arg2 + '%'' ignore case');
      if Arg3 <> '' then
        fqTakst.Sql.Add('and Styrke like  ''%' + Arg3 + '%'' ignore case');

      fqTakst.Sql.Add('ORDER BY');
      fqTakst.Sql.Add('  Navn,');
      fqTakst.Sql.Add('  Formkode,');
      fqTakst.Sql.Add('  StyrkeNum,');
      fqTakst.Sql.Add('  PaknNum ');

      // Parametre
      fqTakst.ParamByName('lager').AsInteger := FLager;
      // fqTakst.ParamByName('prm1').AsString := arg1;
      // if Arg2 <> '' then
      // fqTakst.ParamByName('prm2').AsString := '%' + Arg2 + '%';
      // if Arg3 <> '' then
      // fqTakst.ParamByName('prm3').AsString := '%' + Arg3 + '%';

      c2logadd('SQL=' + fqTakst.Sql.Text);
    finally
      arglist.Free;
    end;

  end;

  procedure BuildSubstSql;
  begin
    // Søg subst

    fqSubst.Sql.Clear;
    fqSubst.Sql.Add('declare RcpGebyr money;');
    fqSubst.Sql.Add('Set RcpGebyr=(select RcpGebyr from recepturOplysninger);');

    fqSubst.Sql.Add('SELECT');
    fqSubst.Sql.Add('	S.VareNr,');
    fqSubst.Sql.Add('  	S.Subnr,');
    fqSubst.Sql.Add('	(case when s.antpkn = 0');
    fqSubst.Sql.Add('		THEN');
    fqSubst.Sql.Add('	  		V.SubKode');
    fqSubst.Sql.Add('		ELSE');
    fqSubst.Sql.Add('			''(''+v.subkode+'')''');
    fqSubst.Sql.Add('	END) AS Kode,');
    fqSubst.Sql.Add('  	(CASE WHEN V.SletDato IS NULL THEN '''' ELSE ''*'' END) AS MU,');
    fqSubst.Sql.Add('	V.Navn,');
    fqSubst.Sql.Add('  	V.Form,');
    fqSubst.Sql.Add('  	V.Styrke,');
    fqSubst.Sql.Add('  	V.Pakning,');
    fqSubst.Sql.Add('	V.GrLevSvigtDato,');
    fqSubst.Sql.Add('	V.NySubKode,');
    fqSubst.Sql.Add('	(case when s.antpkn = 0');
    fqSubst.Sql.Add('		THEN');
    fqSubst.Sql.Add('	  		V.PaKode');
    fqSubst.Sql.Add('		ELSE');
    fqSubst.Sql.Add('			'' ''');
    fqSubst.Sql.Add('	END) AS PI,');
    fqSubst.Sql.Add('  	COALESCE(V.Antal, 0) AS Antal,');
    fqSubst.Sql.Add('  	V.SubForvalg AS Forvalg,');
    fqSubst.Sql.Add('  	(case when v.egenpris<>0');
    fqSubst.Sql.Add('		THEN');
    fqSubst.Sql.Add('			(case WHEN V.Paknnum = 0');
    fqSubst.Sql.Add('			then');
    fqSubst.Sql.Add('				v.SUBENHpris');
    fqSubst.Sql.Add('			ELSE');
    fqSubst.Sql.Add('				((V.EGENPRIS+RcpGebyr)/(V.PaknNum/100.0))');
    fqSubst.Sql.Add('			END)');

    fqSubst.Sql.Add('		ELSE V.SubEnhPris');
    fqSubst.Sql.Add('	END) as EnhedsPris,');
    fqSubst.Sql.Add('	(CASE WHEN S.antpkn = 0 THEN');
    fqSubst.Sql.Add('	  	(CASE WHEN V.HaType<>''''');
    fqSubst.Sql.Add('	   		THEN');
    fqSubst.Sql.Add('	   			(CASE WHEN V.EgenPris<>0');
    fqSubst.Sql.Add('    					THEN V.Egenpris + RcpGebyr');
    fqSubst.Sql.Add('    					ELSE V.Salgspris + RcpGebyr');
    fqSubst.Sql.Add('    				END)');
    fqSubst.Sql.Add('   			ELSE');
    fqSubst.Sql.Add('   				(CASE WHEN V.EgenPris<>0');
    fqSubst.Sql.Add('    					THEN V.Egenpris');
    fqSubst.Sql.Add('    					ELSE V.Salgspris');
    fqSubst.Sql.Add('    				END)');
    fqSubst.Sql.Add('		END)');
    fqSubst.Sql.Add('	ELSE');
    fqSubst.Sql.Add('		cast((s.LMS32Salgspris / 100.0) as money)');
    fqSubst.Sql.Add('   	END) AS SalgsPris,');
    fqSubst.Sql.Add('   	(case when s.antpkn = 0 then 1 else s.antpkn end) as antpkn,');
    fqSubst.Sql.Add('	(case 	when v.minimum=-1 and v.genbestil=1 then ''-''');
    fqSubst.Sql.Add('		when v.minimum>=0 and v.genbestil>0 then ''+''');
    fqSubst.Sql.Add('		else ''''');
    fqSubst.Sql.Add('   	end) as skaffe,');
    fqSubst.Sql.Add('	(CASE WHEN V.RESTORDRE <> 0 THEN ''RO'' ELSE '''' END) AS RO,');
    fqSubst.Sql.Add('	v.lokation1,');
    fqSubst.Sql.Add
      ('	(case when ((V.subkode=''C'') or (V.subkode=''B'')) and v.sskode in (''A'',''R'',''S'',''V'') AND V.salgspris=V.BGP then');
    fqSubst.Sql.Add('		''*''');
    fqSubst.Sql.Add('	else');
    fqSubst.Sql.Add('		'' ''');
    fqSubst.Sql.Add('	END) AS CTilsk,');
    fqSubst.Sql.Add('	v.doegnet');

    fqSubst.Sql.Add('FROM');
    fqSubst.Sql.Add('(');
    fqSubst.Sql.Add('	select * from LagerSubstListe');
    fqSubst.Sql.Add('where ' + Prm);

    fqSubst.Sql.Add(') AS S');
    fqSubst.Sql.Add('inner join LagerKartotek AS V on');
    fqSubst.Sql.Add('	V.VareNr=S.SubNr and');
    fqSubst.Sql.Add('	V.Lager=:lager');
    fqSubst.Sql.Add('WHERE');
    fqSubst.Sql.Add('	(V.SLETDATO IS NULL or (V.SLETDATO IS NOT NULL and v.antal>0)) and');
    fqSubst.Sql.Add('  	V.AfmDato IS NULL');
    fqSubst.Sql.Add('ORDER BY');
    fqSubst.Sql.Add('  	S.VareNr,');
    fqSubst.Sql.Add('  	EnhedsPris ASC,');
    fqSubst.Sql.Add('	Salgspris ASC,');
    fqSubst.Sql.Add('	Kode ASC,');
    fqSubst.Sql.Add('  	V.PaKode ASC');
    Sql := fqSubst.Sql.Text;
    c2logadd(Sql);
    // Parametre
    fqSubst.ParamByName('lager').AsInteger := FLager;

  end;

begin

  if Key <> #13 then
  begin
    EditVareidentKeyPress(Sender, Key);
    exit;
  end;

  eSoeg.Text := StringReplace(eSoeg.Text, '''', '', [rfReplaceAll]);

  VareIdent := TC2Vareident.Create(maindm.nxdb, maindm.mtLinLager.AsInteger, eSoeg.Text, False);
  try
    if VareIdent.VNr <> '' then
      eSoeg.Text := VareIdent.VNr;

  finally
    VareIdent.Free;
  end;

  if TryStrToInt64(eSoeg.Text, int4) then
    chkVareLevsvigt.Checked := False
  else
    chkVareLevsvigt.Checked := True;
  if Trim(eSoeg.Text) = '' then
  begin
    Key := #0;
    exit;
  end;
  if cdTakst.Active then
    cdTakst.EmptyDataSet;
  cdTakst.Close;

  cdSubst.Filtered := False;
  cdTakst.DisableControls;
  cdSubst.DisableControls;
  try
    Arg1 := '';
    Arg2 := '';
    Arg3 := '';
    PArg := Trim(eSoeg.Text);
    VNr := 0;
    if (copy(caps(PArg), 1, 1) <> 'X') and (TryStrToInt(PArg, VNr)) then
      BuildTakstSqlByVarenr
    else
      BuildTakstSqlByTekst;

    if cdTakst.Active then
      cdTakst.EmptyDataSet;
    cdTakst.Close;
    try
      cdTakst.Filtered := False;
      Sql := fqTakst.Sql.Text;
      cdTakst.Open;
      c2logadd('after takst window sql');
      cdTakst.LogChanges := False;
    except
      on E: Exception do
      begin
        c2logadd('error in takstoversigt ' + E.Message);
        c2logadd('sql is  ' + sLineBreak + Sql);
        c2logadd('Takst søgning afbrudt af server!' + sLineBreak + 'prm1= ' + Arg1 + sLineBreak + 'prm2= ' + Arg2 + sLineBreak +
          'prm3= ' + Arg3);
        ChkBoxOk('Takst søgning afbrudt af server!' + sLineBreak + 'prm1= ' + Arg1 + sLineBreak + 'prm2= ' + Arg2 + sLineBreak +
          'prm3= ' + Arg3 + sLineBreak +

          sLineBreak + sLineBreak + 'Exception "' + E.Message + '"');
      end;
    end;
    if cdTakst.RecordCount = 0 then
    begin
      Key := #0;
      exit;
    end;

    if cdTakst.RecordCount > 300 then
    begin
      ChkBoxOk('Resultatet af søgningen er for stort (mere end 300). søg mere detaljeret.');
      exit;
    end;

    Prm := '';
    cdTakst.First;
    while not cdTakst.Eof do
    begin
      // 556 if stryke is included in search then delete any products that dont have space
      // either side of styrke
      if Arg3 <> '' then
      begin
        CheckStyrke := cdTakstStyrke.AsString;
        ipos := pos(Arg3, CheckStyrke);
        if ipos = 1 then
        begin
          StyrkeStr := copy(CheckStyrke, length(Arg3) + 1, 1);
          if (StyrkeStr <> ' ') and (StyrkeStr <> ',') and (StyrkeStr <> '+') then
          begin
            cdTakst.Delete;
            continue;
          end;
        end
        else
        begin
          StyrkeStr := copy(CheckStyrke, ipos - 1, 1);
          if (StyrkeStr <> ' ') and (StyrkeStr <> '+') then
          begin
            cdTakst.Delete;
            continue;
          end;

          StyrkeStr := copy(CheckStyrke, ipos + length(Arg3), 1);
          if (StyrkeStr <> ' ') and (StyrkeStr <> ',') and (StyrkeStr <> '+') then
          begin
            cdTakst.Delete;
            continue;
          end;
        end;
      end;
      if Prm = '' then
        Prm := 'Varenr=' + AnsiQuotedStr(cdTakstVarenr.AsString, '''')
      else
        Prm := Prm + ' or Varenr=' + AnsiQuotedStr(cdTakstVarenr.AsString, '''');
      cdTakst.Next;
    end;
    if chkVareLevsvigt.Checked then
    begin
      cdTakst.Filter := 'MU='''' or (MU<>'''' AND antal<>0)';
      cdTakst.Filtered := True;
    end
    else
    begin
      cdTakst.Filter := '';
      cdTakst.Filtered := False;
    end;
    if Prm = '' then
    begin
      Key := #0;
      exit;
    end;
    BuildSubstSql;
    if cdSubst.Active then
      cdSubst.EmptyDataSet;
    cdSubst.Close;
    try
      cdSubst.Open;
      c2logadd('after subst window sql ');
      cdSubst.LogChanges := False;
      FirstSubNr := cdTakstVarenr.AsString;
    except
      on E: Exception do
      begin
        c2logadd('error in substoversigt ' + E.Message);
        c2logadd('sql is  ' + sLineBreak + Sql);

        ChkBoxOk('Substitution søgning afbrudt af server!' + sLineBreak + sLineBreak + sLineBreak + 'Exception "' +
          E.Message + '"');
      end;

    end;
  finally
    cdSubst.EnableControls;
    cdTakst.EnableControls;
    cdSubst.Filtered := True;
    cdTakst.First;
    cdSubst.First;
    grTak.SetFocus;
  end;
  Key := #0;

end;

procedure TSubstForm.acNaemesteExecute(Sender: TObject);
var
  LVarenr: string;
begin

  c2logadd('Top of acNaemesteExecute');
  try
    case WhichGrid of
      1:
        LVarenr := cdTakstVarenr.AsString;
      2:
        LVarenr := cdSubstSubnr.AsString;
    end;
    if LVarenr.IsEmpty then
      LVarenr := cdTakstVarenr.AsString;
    if LVarenr.IsEmpty then
      exit;

    ShowNearbyStockForVarenr(LVarenr);

  finally
    case WhichGrid of
      1:
        grTak.SetFocus;
      2:
        grSub.SetFocus;
    end;
    c2logadd('End of acNaemesteExecute');
  end;

end;

procedure TSubstForm.ShowNearbyStockForVarenr(AVarenr: string);
var
  LAssignedSOSIId: boolean;
  LUseTestEndPoints: boolean;
  LResult: boolean;
begin
  LAssignedSOSIId := Assigned(maindm.Afdeling.SOSIId);
  LUseTestEndPoints := Assigned(maindm.Afdeling.SOSIId) and maindm.Afdeling.SOSIId.IsIssuedByTestSTS;
  c2logadd('LAssignedSOSIID ' + BoolToStr(LAssignedSOSIId, True));
  c2logadd('LUseTestEndPoints ' + BoolToStr(LUseTestEndPoints, True));
  // FreeAndNil(C2Asp);
  // if LUseTestEndPoints then
  // C2ASP := TC2AspConnection.Create(maindm.Afdeling, True, True, True, nil,
  // SAspTestAuthHost, SAspTestApiHost)
  // else
  // C2ASP := TC2AspConnection.Create(maindm.Afdeling);
  //
  LResult := uC2Asp.SetupC2AspConnection(maindm.Afdeling, LUseTestEndPoints);
  c2logadd('c2asp.objectisvalid ' + BoolToStr(C2ASP.ObjectIsValid, True));
  try
    if C2ASP.ObjectIsValid then
      TFormC2AspNearbyStockStatus.ShowDialog(maindm.nxdb, AVarenr, FLager)
    else
      ShowMessageBoxWithLogging('Kan ikke vise lagerstatus for nærmeste apoteker.' + ''#13''#13'' +
        C2ASP.LastErrorDisplayText, 'Fejl');
  finally
    FreeAndNil(C2ASP);
  end;
end;

procedure TSubstForm.acVisPositivListExecute(Sender: TObject);
var
  LRegionPosListFile : string;
begin
  LRegionPosListFile := 'G:\Temp\RegionPoslist' + MainDm.BrugerNr.ToString + '.cds';
  if FileExists(LRegionPosListFile) then
    TfrmPositivList.VisPositivlist(LRegionPosListFile);

end;

procedure TSubstForm.BitBtn1VisEkspClick(Sender: TObject);
var
  atckode: string;
  copyindex: string;
  maerkevare: Integer;
  varenr: string;
begin
  copyindex := MainDm.ffLagKar.IndexName;
  MainDm.ffLagKar.IndexName := 'NrOrden';
  try
    if BottomScreen then
      varenr := cdSubstVareNr.AsString
    else
      varenr := cdTakstVarenr.AsString;

    if MainDm.ffLagKar.FindKey([0, varenr]) then
      atckode := MainDm.ffLagKarAtcKode.AsString;

    maerkevare := 0;
    if MainDm.ffLagKarVareType.AsInteger = 2 then
      maerkevare := 2;

    TfrmKundeOrd.ShowKundeOrd(MainDm.mtEksKundeNr.AsString, atckode, maerkevare);
    if BottomScreen then
      grSub.SetFocus
    else
      grTak.SetFocus;

  finally
    MainDm.ffLagKar.IndexName := copyindex;
  end;
end;

end.
