unit TakserHuman;

{ Developed by: Cito IT A/S

  Description: Normasl ekspedition form

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  10-02-2023/cjs  Correction to the use of tidlsalgspris and tidlbgp.  The salesprice is only overwritten
                  if the price used would be the salgspris from lagerkartotek and that the order date is
                  not today and the UseEhTidlPris parameter in winpacer is set to Ja

  19-01-2023/cjs  Corrections for use of prices if Eordre dato is not today.

  13-12-2021/cjs  Changes for using the new CtrTilskudSatser table

  05-10-2021/cjs  Removed the warning about changing AP4 products when taksering

  21-09-2021/cjs  Corrected fault where autoenter was permanently disabled at the end
                  of the order.

  20-09-2021/cjs  Roll back autoenter functionality to that in 7.7.0.4.  The other
                  differences in 7.7.0.5 are kept in this version. When taksering the
                  order is complete autoenter is disabled.

  03-09-2021/cjs  Further amendments to autoenter in takser function.  Auto enter is
                  disabled if the operator edits a line.  Green indicator when
                  order is completed.  User can still add more lines if they wish.

  16-08-2021/cjs  Correction to autoenter when taksering eordre.

  15-01-2021/cjs  Fix to asylansøger not setting medicinecard details correctly

  06-01-2020/cjs  Change CheckCanOrdinate to not blank Authorisation number the check
                  is not needed

  29-10-2020/cjs  Modified to use new property for Recepturplads
                  if Recepturplads = DYR then move to dosis combobox from antal field

  28-10-2020/cjs  Warn about antal changes if the user switches to a product outside
                  the substitution group
  28-10-2020/cjs  reopen Max and Udlev field if antal is less than ordered

  28-10-2020/cjs  Ensure max and udlev are still disabled if AP4 (etc) product is
                  selected from the same substitution group

  28-10-2020/cjs  Check antal bearing in mind substitution list selection

  28-10-2020/cjs  Only warn if the antal is different providing they have not selected
                  a completely different product.

  26-10-2020/cjs  Setfocus on Max field if enabled after antal has been keyed.
                  A bevilling was causing an issue with the next field logoc

  26-10-2020/cjs  Check that the varenr has been switched from the ordineret
                  varenr before warning about antal

  19-10-2020/cjs  Block switch to antal field.  Need to check the
                  rules if the line is not complete yet

  16-10-2020/cjs  First attempt to stop cheating on antal field

  15-10-2020/cjs  correction to etiket lines being deleted if max and udlev fields
                  are disabled.

  09-10-2020/cjs  make F5 button yellow if antal field yellow + change text of popups

  09-10-2020/cjs  Check if the varenr has been changed completely from original
                  vare number. if it has and original product was ap4 etc then warn
                  when exiting antal field

  08-10-2020/cjs  Update mtlinvarenr if the varener is edited during taksering

  08-10-2020/cjs  Further corrections to udlevnr, udlevmax.  also update ctrtype
                  based on current value from c2getctr. it might have changed!!!

  07-10-2020/cjs  Fix tab order on max and udlev fields.  F5 now shows the presciption
                  and then the ordinations oversigt.  Translated messageboxes

  07-10-2020/cjs  New button to show ordination oversigt, yellow antal + fixes
                  to ap4 etc ordination in takser human screen

  06-10-2020/cjs  Shift-f5 shows the ordination view screen

  29-09-2020/cjs  Block udlev and max fields if AP4, NBS, A or AP4NBS

  29-09-2020/cjs  Code to handle changes to antal and max if product is AP4,NBS or A

  27-08-2020/cjs  Dont call remove status if the ordination has a lbnr from another
                  session.

  21-07-2020/cjs  Only call check ctr update if kunetype =1

  17-07-2020/cjs  Added ffpatkar refresh to ensure latest data available.

  04-05-2020/cjs  Use TC2Vareident in vare field so that varenr and various forms of barcode are
                  processed correctly.

  08-04-2020/cjs  if BEGR – Atckode J01FA10 message displayed then dont show the usual message

  08-04-2020/cjs  Moved BEGR – Atckode J01FA10 message to point where the user has entered the varenr

  08-04-2020/cjs  Udlev BEGR – Atckode J01FA10 messagechanged to yes no box in taksering screen

  02-04-2020/cjs  Fejl i Lægens navn text replace with Udsteders navn skal angives ved afslutning af manuelle recepter.
  30-03-2020/cjs  KeepReceptLokalt property added. if set to Nej then locsl copy of prescription
                  is kept if removestatus is called

  21-02-2020/cjs  Blan out authorisation number if the prescripyion does not need it

  14-01-2020/cjs  Do not check ydernavn if udligning

  14-01-2020/cjs  Do not prompt for dosering / indikation if udligning.

  24-09-2019/cjs  remove check on 80xxxx numbers to allow reservation

  10-09-2019/cjs   use the kundenavn specified at the start of taksering

  29-08-2019/cjs  only check the udlevnr if the SpørgUdlA parameter in winpacer is set to Ja (default is Ja)

  01-08-2019/cjs  Only point at the correct patient if not blank from Receptserver

  25-07-2019/cjs  if processing a prescription then point at the correct patient if ffpatkar before
                  showing the screen
  19-07-2019/cjs  Sagsnr 10310.  Replaced chkbox with new chkbox (need to click ok) to fix issue
                  with substitution combo box
  19-07-2019/cjs  Sagsnr 10289.  Check for AP4 extended to also check for AP4NB
  19-07-2019/cjs  Sagsnr 10388.  If max > udlev then pop on certain udlevtypes
  12-07-2019/cjs  Fix to ap4 ceck for skibsfører

  11-07-2019/cjs  Corrected ap4 check for skibsfører and allowed 4000000103 as valid ydercprnr

  22-05-2019/cjs  reset the reservation grossist list to the first grossist again in case it has
                  been changed during the ekspedition

}

interface

uses
  Classes, Graphics, Controls,
  Forms, Menus, StdCtrls,
  DBCtrls, DBGrids, ComCtrls,
  Grids, ExtCtrls, Mask,
  Messages, Windows, SysUtils, Dialogs,
  Db, Buttons, DateUtils,
  dbclient, ActnList, generics.collections, System.Actions, CtrTilskudsSatser,
  uC2Vareidentifikator.Classes,strutils,
  Math, uFMKCalls, ufrmIndtastTekst, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  uC2FMK.Prescription.Classes, uFMKGetMedsById, uOrdView,uLagersubstliste.tables,
  uLagerkartotek.tables,
  uc2fmk.Common.types,PosListJSON,nxdb, uFrmPositivlist;
{$I EdiRcpInc}

type
  PIBVarType = record
    VareNr: string;
    Checked: boolean;
  end;

type
  THumanForm = class(TForm)
    paTop: TPanel;
    paBund: TPanel;
    paLinier: TPanel;
    grLinier: TDBGrid;
    Label5: TLabel;
    laMax: TLabel;
    Label7: TLabel;
    gbKunde: TGroupBox;
    eCprNr: TDBEdit;
    eNavn: TDBEdit;
    eGlCtrSaldo: TDBEdit;
    eCtrType: TDBEdit;
    Label3: TLabel;
    Label4: TLabel;
    eDebitorNr: TDBEdit;
    eDebitorNavn: TDBEdit;
    eYderNr: TDBEdit;
    eYderNavn: TDBEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    gbEksp: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    cbIndikation: TComboBox;
    laUdlev: TLabel;
    EVare: TEdit;
    EUdlev: TDBEdit;
    EAntal: TEdit;
    laSalgRetur: TLabel;
    Label28: TLabel;
    eCtrUdlign: TDBEdit;
    grCTR: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    Label25: TLabel;
    EIBTBel: TDBEdit;
    EBGPBel: TDBEdit;
    ELinSaldo: TDBEdit;
    Label8: TLabel;
    Label9: TLabel;
    lcLevForm: TDBLookupComboBox;
    Label23: TLabel;
    cbSubst: TComboBox;
    EDos2: TEdit;
    gbAfslut: TGroupBox;
    buGem: TButton;
    buLuk: TButton;
    Label14: TLabel;
    Label16: TLabel;
    eNyCtrSaldo: TDBEdit;
    buVidere: TButton;
    Label15: TLabel;
    lcArt: TDBLookupComboBox;
    lcAlder: TDBLookupComboBox;
    lcOrd: TDBLookupComboBox;
    Label17: TLabel;
    ePakkeNr: TDBEdit;
    lcFakType: TDBComboBox;
    lcbEkspType: TDBComboBox;
    lcbEkspForm: TDBComboBox;
    lcbLinTyp: TDBComboBox;
    Label22: TLabel;
    eNarkoNr: TDBEdit;
    Label6: TLabel;
    eLevNr: TDBEdit;
    eLevNavn: TDBEdit;
    Label13: TLabel;
    eTurNr: TDBEdit;
    eDebitorTidl: TDBEdit;
    eYderCPRNr: TDBComboBox;
    meEtiketter: TMemo;
    dbtPBS: TDBText;
    cbDosTekst: TComboBox;
    btnYder: TSpeedButton;
    ActionList1: TActionList;
    acVisRCP: TAction;
    Panel1: TPanel;
    paLager: TPanel;
    paInfo: TPanel;
    acLager0: TAction;
    acLager1: TAction;
    acLager2: TAction;
    acLager3: TAction;
    acLager4: TAction;
    acLager5: TAction;
    acPIBVar: TAction;
    dsLinDisp: TDataSource;
    cdsLinDisp: TClientDataSet;
    eGlCtrSaldoB: TDBEdit;
    eNyCtrSaldoB: TDBEdit;
    eCtrUdlignB: TDBEdit;
    EMax: TDBEdit;
    ActionManager1: TActionManager;
    acShowPrescriptionDetails: TAction;
    pnlVisOrd: TPanel;
    btnVis: TSpeedButton;
    acVisPositivList: TAction;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure buLukClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EkspFormExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbIndikationEnter(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure buGemClick(Sender: TObject);
    procedure FakTypeExit(Sender: TObject);
    procedure DropDown(Sender: TObject);
    function CheckOrdination: boolean;
    procedure eDebitorNrExit(Sender: TObject);
    procedure lcArtExit(Sender: TObject);
    procedure cbSubstEnter(Sender: TObject);
    procedure cbSubstExit(Sender: TObject);
    procedure buVidereEnter(Sender: TObject);
    procedure buVidereExit(Sender: TObject);
    procedure buVidereKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure buVidereClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cbIndikationKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eDebitorNrEnter(Sender: TObject);
    procedure cbDosTekstEnter(Sender: TObject);
    procedure cbDosTekstKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbDosTekstExit(Sender: TObject);
    procedure cbIndikationExit(Sender: TObject);
    procedure eYderCPRNrEnter(Sender: TObject);
    procedure eYderNrEnter(Sender: TObject);
    procedure btnYderClick(Sender: TObject);
    procedure acVisRCPExecute(Sender: TObject);
    procedure acLager0Execute(Sender: TObject);
    procedure acLager1Execute(Sender: TObject);
    procedure acLager2Execute(Sender: TObject);
    procedure acLager3Execute(Sender: TObject);
    procedure acLager4Execute(Sender: TObject);
    procedure acLager5Execute(Sender: TObject);
    procedure eTurNrExit(Sender: TObject);
    procedure EUdlevExit(Sender: TObject);
    procedure grLinierDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure acPIBVarExecute(Sender: TObject);
    procedure meEtiketterChange(Sender: TObject);
    procedure meEtiketterEnter(Sender: TObject);
    procedure grLinierCellClick(Column: TColumn);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grLinierMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EVareEnter(Sender: TObject);
    procedure EVareKeyPress(Sender: TObject; var Key: Char);
    procedure acShowPrescriptionDetailsExecute(Sender: TObject);
    procedure acShowPrescriptionDetailsUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EAntalEnter(Sender: TObject);
    procedure acVisPositivListExecute(Sender: TObject);
  private
    { Private declarations }
    YderList: boolean;
    UdlignOrdination: boolean;
    SaveDosisKortNr: Integer;
    AskYderNrQuestion: boolean;
    AskYderCPrNrQuestion: boolean;
    LagerListeLagerChk: boolean;
    OldDebitor: string;
    save_caption: string;
    SkipReservation: boolean;
    ReservationOrigVarenr: string;
    Varelist: TList<PIBVarType>;
    SaveEtiket: TStringList;
    AntalFieldKeyPress: boolean;
    OriginalVarenr: string;
    EordreOveridePrice: boolean;
    CTRBStartDate: TDate;
    CTRBOrdination: boolean;
    FirstCTRCall : boolean;
    FVareIdent: TC2Vareident;
    FPreviousControl: TWinControl;
    FActiveControl: TWinControl;
    FTakserEHAutoEnter: boolean;
    FNyLineClicked: boolean;
    FOrderComplete: boolean;
    PositiveRule : integer;
    procedure HandlePositivList(const APositiveRule : integer; const AVarenr,AATCKode : string);
    procedure SetUpPositiveRuleForEkspedition;
    property VareIdent: TC2Vareident read FVareIdent write FVareIdent;
    property ActiveControl : TWinControl read FActiveControl write FActiveControl;
    property TakserEHAutotEnter: boolean read FTakserEHAutoEnter write FTakserEHAutoEnter;
    property NyLineClicked: boolean read FNyLineClicked write FNyLineClicked;
    property OrderComplete: boolean read FOrderComplete write FOrderComplete;
    procedure Process_eYdenr;
    procedure Process_cbIndikation;
    procedure process_cbDosTekst;
    procedure process_Eantal;
    procedure process_EDos2;
    procedure CheckEtiket;
    procedure CMDialogKey(var AMessage: TCMDialogKey); message CM_DIALOGKEY;
    procedure FillYderCpr;
    procedure ReadyDebitor;
    procedure ReadyLevering;
    procedure CheckDebitor;
    procedure CheckLevering;
    procedure CheckCtrUpdate;
    function NyLinie: boolean;
    procedure ActiveControlChanged(Sender: TObject) ;
    function CheckInSameSubstGtoup(AOrdineretVarenr,ASubVareNr : string) : boolean;
    procedure SendEnterKey(AHandle :HWND);
    procedure GetTidlPrices(ALagerNr : integer; AVarenr : string; out ASalgspris : currency; out ABGP : currency);
    function GetRegionName(ARegionNumber : integer): string;
  public
    { Public declarations }
    FirstTime, CloseCF6, CloseSF6, CloseCSF6, CloseF6: boolean;
  end;

var
  HumanForm: THumanForm;
  ReiterLbNr: Longword;
  ReceptId: Integer;
  FirstWarning: boolean;
  LabelFirstWarn: boolean;
  Save_AtcKode: string;
  EtiketWarn: boolean;
  EtiketFieldEntered: boolean;
procedure EkspHuman(LbNr: Longword; EdiPtr: Pointer);
procedure FillCTRBevDataset;

implementation

uses
//  VentCtrSvar,
  UdlignCtr,
  C2Date,

  C2MainLog,
  HentTekst,
  HentHeltal,


  VisInteraktion,
  MidClientApi,
  // VareOversigt,
  // TakstOversigt,
  SubstOversigt,
  RcpProcs,
  C2Procs,
  // DebitorLst,
  YderLst,
  TakserAfslut,
  ChkBoxes,
  DM,
  Main,
  uC2Vareidentifikator.Procs,
  uC2Vareidentifikator.Types, uRowaAppCall, frmLagerList, RCPPrinter,
  uResv, uYesNo,
  uC2BegrOrdinationsretInfo.Classes,
  BeregnOrdinationu, PIBVarNomu, PIBvARtmjU,
  BeregnUdlignOrdinationu,
  BeregnCannabisOrdinationu,
  uC2Ui.MainLog.Procs,
  uc2common.types,
  uC2Ui.Procs,
  uc2Common.procs;

{$R *.DFM}

type
  TIntRef = packed record
    LbNr: Longword;
    LinieNr: Word;
    VareNr: String[06];
    AtcKode: String[10];
    AdvNr: Word;
    VejlNr: Word;
    Varetxt: string[30];
  end;

  PTIntRef = ^TIntRef;

var
  IntRef: PTIntRef;
  IntLst: TStringList;
  EdiRcp: PEdiRcp;
  FrmTekst, FrmEntal, FrmFlertal: String;
  // VareRec         : TVareRec;
  // DebitorRec      : TDebitorRec;
  CtrRec: MidClientApi.TCtrStatus;
  StartCTRTime: TDateTime;
  OriginalAntal: Integer;
  itemsubst: boolean;
  AllHKlines: boolean;
  ProdDyrPrices: boolean;
  ForceClose: boolean;
  (*
    function HentDebitor (var Rec : TDebitorRec) : boolean;
    begin with MidClient do begin
    MidClient.HentDeb (Rec);
    Result := Rec.Status = 0;
    end; end;
  *)


function calcage(const AKundenr: string; const ABirthdate: string): string;
var
  Ldd, Lmm, Lyyyy: Integer;
  dd, mm, yy: Word;
  LOldDate: TDateTime;
  LCiffer7: Integer;
  LCurrentYear: Integer;
begin

  Result := '';
  try
    // use the birthdate if supplied
    if not ABirthdate.IsEmpty then
    begin
      Ldd := StrToIntDef(copy(ABirthdate, 1, 2), -1);
      if Ldd= -1 then
        exit;
      Lmm := StrToIntDef(copy(ABirthdate, 3, 2), -1);
      if Lmm = -1 then
        exit;

      case ABirthdate.trim.Length of
        8:begin
            Lyyyy := StrToIntDef(copy(ABirthdate, 5, 4), -1);
            if Lyyyy = -1 then
              exit;
          end;
        6:
          begin
            Lyyyy := StrToIntDef(copy(ABirthdate, 5, 2), -1);
            if Lyyyy = -1 then
              exit;
            LCurrentYear := YearInDate(Now) - 2000;
            if Lyyyy <= LCurrentYear then
              Lyyyy := Lyyyy + 2000
            else
              Lyyyy := Lyyyy + 1900;

          end;
      else
        exit;
      end;

      dd := Ldd;
      mm := Lmm;
      yy := Lyyyy;

    end
    else
    begin

      if AKundenr.trim.Length <> 10 then
        exit;

      Ldd := StrToIntDef(copy(ABirthdate, 1, 2), -1);
      if Ldd= -1 then
        exit;
      Lmm := StrToIntDef(copy(ABirthdate, 3, 2), -1);
      if Lmm = -1 then
        exit;
      Lyyyy := StrToIntDef(copy(ABirthdate, 5, 2), -1);
      if Lyyyy = -1 then
        exit;
      LCiffer7 := StrToIntDef(copy(AKundenr, 7, 1), -1);
      if LCiffer7 = -1 then
        exit;

      dd := Ldd;
      mm := Lmm;
      yy := Lyyyy;

      case LCiffer7 of
        0 .. 3:
          yy := yy + 1900;
        4, 9:
          begin
            if yy <= 36 then
              yy := yy + 2000
            else
              yy := yy + 1900;

          end;
        5 .. 8:
          begin
            if yy <= 57 then
              yy := yy + 2000
            else
              yy := yy + 1900;

          end;
      end;
      if yy > YearInDate(Now) then
        yy := yy - 100;

    end;

    if not SysUtils.TryEncodeDate(yy, mm, dd, LOldDate) then
      exit;
    if YearsBetween(Now, LOldDate) > 18 then
      exit;

    if YearsBetween(Now, LOldDate) <= 2 then
      Result := format('%d mdr', [MonthsBetween(Now, LOldDate)])
    else
      Result := format('%d år', [YearsBetween(Now, LOldDate)]);

  except
    on e: Exception do
      C2LogAdd('Fejl i calcage ' + e.Message);
  end;
end;



procedure THumanForm.FillYderCpr;
var
  savecpr: string;
begin

  try
    // cjs to do
    savecpr := eYderCPRNr.Text;
    AdjustIndexName(MainDm.ffYdLst, 'YderNrOrden');
    eYderCPRNr.Items.Clear;
    MainDm.ffYdLst.FilterOptions := [foCaseInsensitive];
    MainDm.ffYdLst.Filter := 'YderNr=''' + MainDm.mtEksYderNr.AsString + '''';
    MainDm.ffYdLst.Filtered := True;
    c2logadd('yder recordcount is ' + IntToStr(MainDm.ffYdLst.RecordCount));
    if MainDm.ffYdLst.RecordCount <> 0 then
    begin
      MainDm.ffYdLst.First;
      eYderCPRNr.Items.Add('');
      while not MainDm.ffYdLst.Eof do
      begin
        if not SameText(MainDm.ffYdLstYderNr.AsString,MainDm.mtEksYderNr.AsString) then
          break;
        if Trim(MainDm.ffYdLstCprNr.AsString) <> '' then
          eYderCPRNr.Items.Add(MainDm.ffYdLstCprNr.AsString);
        MainDm.ffYdLst.Next;
      end;
      if (eYderCPRNr.Items.Count = 2) and (MainDm.ffPatKarYderCprNr.AsString = '') then
        MainDm.mtEksYderCprNr.AsString := eYderCPRNr.Items[1];
      // eYderCPRNr.DropDownCount := eYderCPRNr.Items.Count;
    end;
    if YderList then
      MainDm.mtEksYderCprNr.AsString := savecpr;
    MainDm.ffYdLst.Filtered := False;
  except
    ON E: Exception do
      c2logadd('No entry in yderkartotek for fill cpr ' + E.Message);
  end;
  YderList := False;
end;

procedure THumanForm.ReadyDebitor;
begin
  eDebitorNr.Color := clYellow;
  // eDebitorNr.ReadOnly := False;
  eDebitorNr.TabStop := True;
  lcLevForm.Color := clYellow;
  // lcLevForm .ReadOnly := False;
  lcLevForm.TabStop := True;
  ePakkeNr.Color := clYellow;
  // ePakkeNr  .ReadOnly := False;
  ePakkeNr.TabStop := True;
end;

procedure THumanForm.ReadyLevering;
begin
  eLevNr.Color := clYellow;
  // eLevNr.ReadOnly := False;
  eLevNr.TabStop := True;
end;

procedure THumanForm.SendEnterKey(AHandle :   HWND);
var
  cr : char;
begin
  if TakserEHAutotEnter then
  begin
    cr := #13;
    PostMessage(AHandle, WM_CHAR, Ord(cr), 0);

  end;

end;

procedure THumanForm.CheckDebitor;
var
  i: Integer;
  save_index: string;
begin
  ReadyDebitor;
  if MainDm.mtEksDebitorNr.AsString <> OldDebitor then
    LagerListeLagerChk := False;
  OldDebitor := MainDm.mtEksDebitorNr.AsString;
  if not MainDm.ffDebKar.FindKey([MainDm.mtEksDebitorNr.AsString]) then
  begin
    ChkBoxOk('Debitorkonto findes ikke i kartotek !');
    eDebitorNr.SetFocus;
    exit;
  end;

  if MainDm.ffDebKarKontoLukket.AsBoolean then
  begin
    if Trim(MainDm.ffDebKarLukketGrund.AsString) <> '' then
      ChkBoxOk('Debitorkonto er lukket : ' + MainDm.ffDebKarLukketGrund.AsString)
    else
      ChkBoxOk('Debitorkonto er lukket.');
    MainDm.mtEksDebitorNr.AsString := '';
    eDebitorNr.SetFocus;
    exit;
  end;
  if MainDm.ffDebKarKreditMax.AsCurrency <> 0 then
    ChkBoxOk('Bemærk kreditmax: ' + format('%8.2f', [MainDm.ffDebKarKreditMax.AsCurrency]) +
      sLineBreak + sLineBreak + 'Aktuel saldo: ' + format('%8.2f', [MainDm.ffDebKarSaldo.AsCurrency]));

  if (MainDm.ffDebKarAfdeling.AsString = '') or (MainDm.ffDebKarLager.AsString = '') then
  begin
    ChkBoxOk('Afdeling eller lager mangler på debitoren. Ret dette i Debitorkartoteket.');
    MainDm.mtEksDebitorNr.AsString := '';
    eDebitorNr.SetFocus;
    exit;
  end;
  save_index := SaveAndAdjustIndexName(MainDm.ffAfdNvn, 'NrOrden');
  try
    if not MainDm.ffAfdNvn.FindKey([MainDm.ffDebKarAfdeling.AsInteger]) then
    begin
      ChkBoxOk('Afdeling eller lager mangler på debitoren. Ret dette i Debitorkartoteket.');
      MainDm.mtEksDebitorNr.AsString := '';
      eDebitorNr.SetFocus;
      exit;
    end;
  finally
    AdjustIndexName(MainDm.ffAfdNvn, save_index);
  end;

  ProdDyrPrices := MainDm.ffAfdNvnProduktionsDyr.AsBoolean;
  c2logadd('Prod Dyr Prices ' + Bool2Str(ProdDyrPrices));
  if not LagerListeLagerChk then
  begin
    MainDm.mtEksAfdeling.Value := MainDm.ffDebKarAfdeling.AsInteger;
    MainDm.mtEksLager.Value := MainDm.ffDebKarLager.AsInteger;
    StamForm.StockLager := MainDm.mtEksLager.Value;
    c2logadd('1: Stock lager changed to ' + IntToStr(StamForm.StockLager));
  end;
  MainDm.mtEksDebitorNavn.AsString := BytNavn(MainDm.ffDebKarNavn.AsString);
  MainDm.mtEksLeveringsForm.Value := MainDm.ffDebKarLevForm.AsInteger;
  MainDm.mtEksDebitorGrp.Value := MainDm.ffDebKarDebGruppe.AsInteger;
  MainDm.mtEksDebProcent.AsCurrency := MainDm.ffDebKarAvancePct.AsCurrency;

  // if Date < dateutils.EncodeDateTime(2018,4,23,0,0,0,0) then
  // begin
  // // FE 1340 5,6 -> 5
  //
  // if (ffDebKarLevForm.AsInteger in [5]) and (mtEksKundeType.AsInteger <> 15)
  // then
  // begin
  // if AllHKlines then
  // mtEksUdbrGebyr.AsCurrency := ffRcpOplHKgebyr.AsCurrency;
  // end;
  //
  // end
  // else
  // begin
  // dont check allhklines after 22nd may
  if (MainDm.ffDebKarLevForm.AsInteger in [5, 6]) and (MainDm.mtEksKundeType.AsInteger <> pt_Haandkoebsudsalg) then
    MainDm.mtEksUdbrGebyr.AsCurrency := MainDm.ffRcpOplHKgebyr.AsCurrency;

  // end;

  if MainDm.ffDebKarUdbrGebyr.AsBoolean then
  begin
    if MainDm.mtEksUdbrGebyr.AsCurrency = 0 then
      MainDm.mtEksUdbrGebyr.AsCurrency := MainDm.ffRcpOplPlejehjemsgebyr.AsCurrency;
    if MainDm.ffDebKarLevForm.AsInteger = 2 then
      MainDm.mtEksUdbrGebyr.AsCurrency := MainDm.ffRcpOplUdbrGebyr.AsCurrency;
  end;
  if (LagerListeLagerChk) and (StamForm.debitorpopup) then
    exit;
  if StamForm.debitorpopup then
    LagerListeLagerChk := True;
  if (MainDm.mtEksLager.Value <> StamForm.FLagerNr) or (StamForm.Spoerg_Lager_Debitor)
  then
  begin
    if not StamForm.debitorpopup then
      exit;
    if StamForm.DebitorPopupAutoret then
    begin
      for i := 1 to 10 do
      begin
        if StamForm.debitorpopuptype[i] = -1 then
          exit;

        if StamForm.debitorpopuptype[i] = MainDm.ffDebKarLevForm.AsInteger then
        begin
          MainDm.mtEksLager.Value := StamForm.FLagerNr;
          MainDm.mtEksAfdeling.Value := MainDm.AfdNr;
          StamForm.StockLager := MainDm.mtEksLager.Value;
          c2logadd('2: Stock lager changed to ' + IntToStr(StamForm.StockLager));
          exit;
        end;
      end;
    end;
    for i := 1 to 10 do
    begin
      if StamForm.debitorpopuptype[i] = -1 then
        exit;

      if StamForm.debitorpopuptype[i] = MainDm.ffDebKarLevForm.AsInteger then
      begin
        if frmDebLagListe.showLagerliste = mrok then
        begin
          MainDm.mtEksLager.Value := MainDm.nxDebLagRefNr.AsInteger;
          MainDm.mtEksAfdeling.Value := MainDm.nxDebAfdRefNr.AsInteger;
          StamForm.StockLager := MainDm.mtEksLager.Value;
          c2logadd('3: Stock lager changed to ' + IntToStr(StamForm.StockLager));
        end;
        exit;
      end;

    end;

  end;
end;

procedure THumanForm.CheckLevering;
begin
  ReadyLevering;
  if not MainDm.ffDebKar.FindKey([MainDm.mtEksLevNr.AsString]) then
  begin
    ChkBoxOk('Leveringskonto findes ikke i kartotek !');
    exit;
  end;
  MainDm.mtEksLevNavn.AsString := BytNavn(MainDm.ffDebKarNavn.AsString);
  // FE 1340 4,5 -> 5
  if MainDm.ffDebKarLevForm.AsInteger in [5, 6] then
    // if AllHKlines then
    MainDm.mtEksUdbrGebyr.AsCurrency := MainDm.ffRcpOplHKgebyr.AsCurrency;
  if MainDm.ffDebKarUdbrGebyr.AsBoolean then
  begin
    if MainDm.mtEksUdbrGebyr.AsCurrency = 0 then
      MainDm.mtEksUdbrGebyr.AsCurrency := MainDm.ffRcpOplPlejehjemsgebyr.AsCurrency;
    if MainDm.ffDebKarLevForm.AsInteger = 2 then
      MainDm.mtEksUdbrGebyr.AsCurrency := MainDm.ffRcpOplUdbrGebyr.AsCurrency;
  end;
end;

procedure InteraktionsCheck(const AVareNr, AVaretxt, AAtcKode: String);
var
  IntCnt: Integer;
  Check, Found: boolean;
  WTxt, FKey, LKey: String;
begin
//  with HumanForm do
  c2logadd('top of check interktioner ' + IntToStr(IntLst.Count));
  // Er  der historik
  if IntLst.Count = 0 then
    exit;
  c2logadd('Check af Interaktioner start');
  LKey := IntLst.Strings[IntLst.Count - 1];
  FKey := AAtcKode;
  Found := MainDm.ffIntAkt.FindKey([FKey]);
  if not Found then
  begin
    FKey := copy(AAtcKode, 1, Length(AAtcKode) - 1);
    Found := MainDm.ffIntAkt.FindKey([FKey]);
  end;
  if not Found then
  begin
    FKey := copy(AAtcKode, 1, Length(AAtcKode) - 2);
    Found := MainDm.ffIntAkt.FindKey([FKey]);
  end;
  if not Found then
    exit;
  // C2LogAdd ('  Interaktion atckode fundet ' + FKey + ' ' + LKey);
  MainDm.ffIntAkt.SetRange([FKey, ''], [FKey, LKey]);
  try
    try
      // Atckode fundet checkes mod historik
      // C2LogAdd ('Atckode checkes ' + ffIntAktAtcKode1.AsString);
      MainDm.ffIntAkt.First;
      while not MainDm.ffIntAkt.Eof do
      begin
        Check := False;
        for IntCnt := 0 to IntLst.Count - 1 do
        begin
          // Mulig atckode
          // if ffIntAktAtcKode2.AsString <= IntLst.Strings [IntCnt] then begin
          if Pos(MainDm.ffIntAktAtcKode2.AsString, IntLst.Strings[IntCnt]) = 0 then
            continue;
          // Check niveau
          if MainDm.ffRcpOplInteraktNiveau.AsString = '*' then
            // Kun stjerne niveau
            Check := MainDm.ffIntAktStjerne.AsBoolean
          else
          begin
            // Niveau 1-3 og stjerne
            Check := MainDm.ffRcpOplInteraktNiveau.AsString >= MainDm.ffIntAktAdvNiveau.AsString;
            if not Check then
              Check := MainDm.ffIntAktStjerne.AsBoolean;
          end;
          if not Check then
            continue;
          IntRef := PTIntRef(IntLst.Objects[IntCnt]);
          if IntRef <> NIL then
          begin
            // Vis kun interaktioner første gang
            if (IntRef^.AdvNr + IntRef^.VejlNr) = 0 then
            begin
              IntRef^.AdvNr := MainDm.ffIntAktAdvNr.AsInteger;
              IntRef^.VejlNr := MainDm.ffIntAktVejlNr.AsInteger;
              // Vis tekst
{$WARNINGS OFF}
              WTxt := copy(AVaretxt, 1, 15) + ' og ' + copy(IntRef^.Varetxt, 1, 15) + sLineBreak +
                ' løbenr ' + IntToStr(IntRef^.LbNr) +
                ' niveau ' + MainDm.ffIntAktAdvNiveau.AsString;
{$WARNINGS ON}
              if MainDm.ffIntAktStjerne.AsBoolean then
                WTxt := WTxt + ' *';
              TfmInteraktion.VisIntTekst(0, WTxt);
              break;
            end;
          end;
        end;
        if Check then
          break;
        // Application.ProcessMessages;
        MainDm.ffIntAkt.Next;
      end;
    except
      c2logadd('Check af Interaktioner exception');
    end;
  finally
    MainDm.ffIntAkt.CancelRange;
    c2logadd('Check af Interaktioner slut');
    // C2LogSave;
  end;
end;

procedure EkspHuman(LbNr: Longword; EdiPtr: Pointer);
var
  TilbDato, GrValue: TDateTime;
  IntCnt: Integer;
  SaveIndex: String;
  i: Integer;
  sl: TStringList;
  saveRSEkspLinIndex: string;
  LOrdid : string;
  LKundenr : string;
  LPersonIdSource: TFMKPersonIdentifierSource;
  LPositiveLog : TStringList;
  LRegionPosListFile: string;
begin
  StamForm.TakserDosisKortAuto := False;
  Stamform.Undladafstemplingsetiketter := False;
  StamForm.DosisAskQuestions := True;
  ReceptId := 0;
  FirstWarning := True;
  LabelFirstWarn := True;
  ProdDyrPrices := False;
  // Stop opdater CTR
  StamForm.CtrTimer.Enabled := False;

  ForceClose := False;

  if (MainDm.ffPatKarKundeType.AsInteger = pt_Enkeltperson) and (MainDm.ffPatKarEjCtrReg.AsBoolean) then
  begin
    if not frmYesNo.NewYesNoBox('Personen er markeret med ''Ej reg. i CTR''.'
      + sLineBreak + 'Er det korrekt?') then
      exit;

  end;


//    if not TfrmDosiskort.ShowDoskort then
//      exit;


  // Refresh recepturoplysninger
  MainDm.ffRcpOpl.Refresh;
  // Nulstil CTR
  MainDm.cdCtrBev.EmptyDataSet;
  EdiRcp := EdiPtr; // Ikke NIL ved edifact
  IntLst := TStringList.Create;
  HumanForm := THumanForm.Create(NIL);
  HumanForm.AskYderNrQuestion := False;
  HumanForm.AskYderCPrNrQuestion := False;
  AllHKlines := False;
  HumanForm.UdlignOrdination := False;
  StamForm.Save_StockLager := StamForm.StockLager;
  HumanForm.Varelist := TList<PIBVarType>.Create;
  HumanForm.SaveEtiket := TStringList.Create;
  try
    // Indlæs interaktionshistorik ved enkeltpersoner
    if MainDm.ffPatKarKundeType.AsInteger = pt_Enkeltperson then
    begin
      if (MainDm.ffRcpOplInteraktMdr.AsInteger > 0) and  MainDm.CheckInteraktion then
      begin
        BusyMouseBegin;
        GrValue := Trunc(Now - (MainDm.ffRcpOplInteraktMdr.AsInteger * 30));
        try
          c2logadd('Indlæsning af Interaktionshistorik start');
          try
            MainDm.ffEksLin.MasterSource := MainDm.dsEksKar;
            MainDm.ffEksLin.MasterFields := 'LbNr';
            SaveIndex := SaveAndAdjustIndexName(MainDm.ffEksKar, 'KundeNrOrden');
            MainDm.ffEksKar.SetRange([MainDm.ffPatKarKundeNr.AsString], [MainDm.ffPatKarKundeNr.AsString]);
            MainDm.ffEksKar.Last;
            while not MainDm.ffEksKar.Bof do
            begin
              if Trunc(MainDm.ffEksKarTakserDato.AsDateTime) > GrValue then
              begin
                MainDm.ffEksLin.First;
                while not MainDm.ffEksLin.Eof do
                begin
                  if Pos('H', MainDm.ffEksLinATCType.AsString) > 0 then
                  begin
                    if Trim(MainDm.ffEksLinATCKode.AsString) <> '' then
                    begin
                      c2logadd('  Mulig Interaktionshistorik ' + MainDm.ffEksLinSubVareNr.AsString + ' ' +
                        MainDm.ffEksLinATCKode.AsString);
                      IntCnt := IntLst.IndexOf(Trim(MainDm.ffEksLinATCKode.AsString));
                      if IntCnt = -1 then
                      begin
                        GetMem(IntRef, SizeOf(TIntRef));
                        IntCnt := IntLst.AddObject(Trim(MainDm.ffEksLinATCKode.AsString), TObject(IntRef));
                        IntRef := PTIntRef(IntLst.Objects[IntCnt]);
                        if IntRef <> NIL then
                        begin
                          // Add interaktionsfelter
                          IntRef^.LbNr := MainDm.ffEksLinLbNr.AsInteger;
                          IntRef^.LinieNr := MainDm.ffEksLinLinieNr.AsInteger;
                          IntRef^.AdvNr := 0;
                          IntRef^.VejlNr := 0;
{$WARNINGS OFF}
                          IntRef^.VareNr := Trim(MainDm.ffEksLinSubVareNr.AsString);
                          IntRef^.AtcKode := Trim(MainDm.ffEksLinATCKode.AsString);
                          IntRef^.Varetxt := Trim(MainDm.ffEksLinTekst.AsString);
                          c2logadd('  Opret Interaktionshistorik ' + IntRef^.VareNr + ' ' + IntRef^.AtcKode);
{$WARNINGS ON}
                        end;
                      end;
                    end;
                  end;
                  MainDm.ffEksLin.Next;
                end;
              end;
              // else
              // Break;
              MainDm.ffEksKar.Prior;
            end;
          except
            on E: Exception do
            begin
              c2logadd('Exception i Interaktionshistorik');
              ChkBoxOk('Exception under indlæs historik, check log!' +
                E.Message);
            end;
          end;
          c2logadd('Indlæsning af Interaktionshistorik slut');
          // C2LogSave;
        finally
          MainDm.ffEksLin.MasterFields := '';
          MainDm.ffEksLin.MasterSource := NIL;
          MainDm.ffEksKar.CancelRange;
          AdjustIndexName(MainDm.ffEksKar, SaveIndex);
          IntLst.Sorted := True;
          BusyMouseEnd;
        end;
      end;
    end;

    // get the correct patient record for the receptserver prescription
    if EdiRcp <> Nil then
    begin
      if EdiRcp.PaCprNr <> '' then
      begin

        if not MainDm.ffPatKar.FindKey([EdiRcp.PaCprNr]) then
        begin
          ChkBoxOK('Patient ' + edircp.PaCprNr + ' findes ikke');
          exit;
        end;
      end;
    end;


    // //tilskud move to separate procedure for easy reading
    // SetupTilskudLevels;

    // Nulstil memtables
    MainDm.mtEks.Close;
    MainDm.mtEks.Open;
    if MainDm.mtEks.RecordCount <> 0 then
    begin
      MainDm.mtEks.First;
      while not MainDm.mtEks.Eof do
        MainDm.mtEks.Delete;
    end;
    MainDm.mtEks.Insert;

    // mtLin.Close;
    // mtLin.Open;
    // if mtLin.recordcount <> 0 then begin
    MainDm.mtLin.First;
    while not MainDm.mtLin.Eof do
      MainDm.mtLin.Delete;
    MainDm.mtLin.LogChanges := False;
    // end;
    // Kundetype m.m.
    MainDm.mtEksKundeNr.AsString := MainDm.ffPatKarKundeNr.AsString;
    MainDm.mtEksKundeType.Value := MainDm.ffPatKarKundeType.Value;

    // keep the current kundenavn just in case somebody else changes it.

    MainDm.mtEksKundeNavn.AsString := MainDm.ffPatKarNavn.AsString;
    MainDm.mtEksLmsModtager.AsString := MainDm.ffPatKarLmsModtager.AsString;
    MainDm.mtEksDebitorNr.AsString := MainDm.ffPatKarDebitorNr.AsString;
    if MainDm.EHOrdre then
    begin
      if EdiRcp <> Nil then
      begin
        if EdiRcp.Kontonr <> '' then
          MainDm.mtEksDebitorNr.AsString := EdiRcp.Kontonr;
      end;

    end;

    MainDm.mtEksLevNr.AsString := MainDm.ffPatKarLevNr.AsString;
    MainDm.mtEksLeveringsForm.Value := 0;
    MainDm.mtEksTurNr.Value := MainDm.ffRcpOplTurNr.Value;
    if MainDm.mtEksTurNr.AsInteger <> 0 then
      HumanForm.eTurNr.Color := clYellow
    else
      HumanForm.eTurNr.Color := clWindow;
    MainDm.mtEksKontakt.AsString := MainDm.ffPatKarKontakt.AsString;
    MainDm.mtEksYderNr.AsString := MainDm.ffPatKarYderNr.AsString;
    MainDm.mtEksYderCprNr.AsString := MainDm.ffPatKarYderCprNr.AsString;
    HumanForm.FillYderCpr;
    MainDm.mtEksYderNavn.AsString := MainDm.ffPatKarLuYdNavn.AsString;
    MainDm.mtEksNettoPriser.Value := MainDm.ffPatKarNettoPriser.Value;
    HumanForm.lcArt.Enabled := False;
    HumanForm.lcAlder.Enabled := False;
    HumanForm.lcOrd.Enabled := False;
    FillCTRBevDataset;
    HumanForm.PositiveRule := 0;
    HumanForm.acVisPositivList.Enabled := False;
    // Eksptyper og Ekspformer
    case MainDm.mtEksKundeType.Value of
      pt_Enkeltperson:
        begin // Enkeltperson
          MainDm.mtEksEkspType.Value := et_Recepter;
          MainDm.mtEksEkspForm.Value := 1;
          MainDm.EkspTypFilter := EkspTypEnk;
          MainDm.EkspFrmFilter := EkspFrmEnk;
        end;
      pt_Laege:
        begin // Læger
          MainDm.mtEksEkspType.Value := et_Vagtbrugmm;
          MainDm.mtEksEkspForm.Value := 0;
          MainDm.EkspTypFilter := EkspTypVagt;
          MainDm.EkspFrmFilter := EkspFrmEnk;
          LPositiveLog := TStringList.Create;
          try
            LRegionPosListFile := 'G:\Temp\RegionPoslist' + MainDm.BrugerNr.ToString + '.cds';
            if FileExists(LRegionPosListFile) then
              DeleteFile(LRegionPosListFile);
            HumanForm.PositiveRule :=  RegionPosList.InitRegion(MainDm.nxdb, LPositiveLog, MainDm.mtEksKundeNr.AsString);
            if HumanForm.PositiveRule = CRegionRule1113NotValid then
            begin
              ShowMessageBoxWithLogging('Der kan ikke anvendes både regel 11 og regel 13 på samme kundenummer' + slinebreak +
                  'Der skal oprettes et kundenummer for hver af disse regler');
              exit;
            end;

            if HumanForm.PositiveRule = CRegionRule1416NotValid then
            begin
              ShowMessageBoxWithLogging('Der kan ikke anvendes både regel 14 og regel 16 på samme kundenummer' + slinebreak +
                  'Der skal oprettes et kundenummer for hver af disse regler');
              exit;
            end;

            if HumanForm.PositiveRule <> 0 then
              HumanForm.SetUpPositiveRuleForEkspedition;

          finally
            C2LogAdd(LPositiveLog.Text);
            LPositiveLog.Free;
          end;
        end;
      pt_Hobbydyr, pt_Landmand:
        begin // Hobbydyr eller Landmænd
          HumanForm.lcArt.Enabled := True;
          MainDm.mtEksEkspType.Value := et_Dyr;
          MainDm.mtEksEkspForm.Value := 1;
          MainDm.EkspTypFilter := EkspTypDyr;
          MainDm.EkspFrmFilter := EkspFrmDyr;
          MainDm.DyreAnvFilter := DyreAnvPriv;
          if (MainDm.mtEksKundeType.Value = 14) or (MainDm.mtEksNettoPriser.AsBoolean) then
          begin
            MainDm.DyreAnvFilter := DyreAnvErhv;
            IF (MainDm.mtEksKundeType.AsInteger = 14) then
              MainDm.DyreAnvFilter := 0;
          end;
          if (MainDm.mtEksKundeType.Value = 14) or (MainDm.mtEksNettoPriser.AsBoolean) then
          begin
            HumanForm.lcAlder.Enabled := True;
            HumanForm.lcOrd.Enabled := True;
          end;
        end;
      pt_Haandkoebsudsalg:
        begin // Håndkøbsudsalg
          MainDm.mtEksEkspType.Value := et_Haandkoeb;
          MainDm.mtEksEkspForm.Value := 1;
          MainDm.EkspTypFilter := EkspTypHdk;
          MainDm.EkspFrmFilter := EkspFrmAndet;
        end;
    else
      MainDm.mtEksEkspType.Value := et_Leverancer;
      MainDm.mtEksEkspForm.Value := 0;
      MainDm.EkspTypFilter := EkspTypLev;
      MainDm.EkspFrmFilter := EkspFrmAndet;
    end;

    // Deb
    // Debitorfelter spærres
    HumanForm.eDebitorNr.Color := clSilver;
    HumanForm.eLevNr.Color := clSilver;
    HumanForm.lcLevForm.Color := clSilver;
    // lcLevForm .ReadOnly      := True;
    HumanForm.lcLevForm.TabStop := False;
    HumanForm.ePakkeNr.Color := clSilver;
    // ePakkeNr  .ReadOnly      := True;
    HumanForm.ePakkeNr.TabStop := False;

    // Narkofelter spærres
    HumanForm.eNarkoNr.Color := clSilver;
    HumanForm.eNarkoNr.ReadOnly := True;
    HumanForm.eNarkoNr.TabStop := False;
    MainDm.mtEksYdCprChk.AsBoolean := False;

    // eglctrsaldo set to cllime
    HumanForm.eGlCtrSaldo.Color := clLime;
    HumanForm.eGlCtrSaldoB.Color := clLime;
    HumanForm.eNyCtrSaldoB.Color := clLime;
    HumanForm.eCtrUdlignB.Color := clLime;
    // Debitor checkes
    MainDm.mtEksAfdeling.Value := MainDm.AfdNr;
    MainDm.mtEksLager.Value := StamForm.FLagerNr;
    MainDm.mtEksAvancePct.Value := 0;
    MainDm.mtEksUdbrGebyr.AsCurrency := 0.0;

    HumanForm.FirstCTRCall := True;
    HumanForm.LagerListeLagerChk := False;
    if MainDm.mtEksDebitorNr.AsString <> '' then
      // Debitor felter åbnes
      HumanForm.CheckDebitor;
    if MainDm.mtEksLevNr.AsString <> '' then
      // Levering felter åbnes
      HumanForm.CheckLevering;

    // Forbered CTR variable

    c2logadd('CTR oplysninger start');
    try
      try
        MainDm.ffPatUpd.IndexName := 'NrOrden';
        MainDm.ffPatUpd.FindKey([MainDm.ffPatKarKundeNr.AsString]);
        StartCTRTime := MainDm.ffPatUpdCtrStempel.AsDateTime;
        MainDm.mtEksCtrType.AsInteger := MainDm.ffPatUpdCtrType.Value;
        if MainDm.mtEksCtrType.AsInteger = 0 then
        begin
          if not MainDm.ffPatKarEjCtrReg.AsBoolean then
          begin
            if MainDm.mtEksKundeType.Value = pt_Enkeltperson then
            begin
              c2logadd('  Barn check på cprnr/fød.dato');
              if not MainDm.ffPatKarFiktivtCprNr.AsBoolean then
              begin
                // Check over/under 18 år
                if CheckBarn(MainDm.mtEksKundeNr.AsString) then
                begin
                  c2logadd('child detected');
                  MainDm.mtEksCtrType.AsInteger := 1;
                end;
              end
              else
              begin
                // Check over/under 18 år
                if CheckBarnDato(MainDm.ffPatKarFoedDato.AsString) then
                  MainDm.mtEksCtrType.AsInteger := 1;
              end;
            end;
          end;
        end;
        MainDm.mtEksCtrUdlignType.AsInteger := 0;
        MainDm.mtEksCtrUdlignDato.AsDateTime := 0;
        MainDm.mtEksCtrUdlFor.AsCurrency := 0;
        MainDm.mtEksCtrUdlignTypeB.AsInteger := 0;
        MainDm.mtEksCtrUdlignDatoB.AsDateTime := 0;
        MainDm.mtEksCtrUdlForB.AsCurrency := 0;

        MainDm.nxCTRinf.IndexName := 'KundeNrOrden';

        if MainDm.nxCTRinf.FindKey([MainDm.ffPatKarKundeNr.AsString]) then
        begin
          MainDm.mtEksCtrUdlignDato.AsDateTime := MainDm.nxCTRinffor_slutdato.AsDateTime;
          MainDm.mtEksCtrUdlFor.AsCurrency := MainDm.nxCTRinffor_udlign_tilskud.AsCurrency;
          MainDm.mtEksCtrUdlignDatoB.AsDateTime := MainDm.nxCTRinffor_slutdatoB.AsDateTime;
          MainDm.mtEksCtrUdlForB.AsCurrency := MainDm.nxCTRinffor_udlign_tilskudB.AsCurrency;
        end;
        // if ffPatUpdCTRUdlignB.AsCurrency <> 0 then
        // begin
        // ChkBoxOk('Der er en udligning i ctrB. Gå til ctrl+I, hvis den skal medtages.');
        // end;

        MainDm.mtEksGlCtrSaldo.AsCurrency := MainDm.ffPatUpdCtrSaldo.AsCurrency;
        MainDm.mtEksGlCtrSaldoB.AsCurrency := MainDm.ffPatUpdCtrSaldoB.AsCurrency;
        HumanForm.eGlCtrSaldo.Color := clLime;
        if (MainDm.ffPatUpdCtrType.AsInteger = 0) and (MainDm.ffPatUpdCtrSaldo.AsCurrency > KronikerGrpVoksen) then
          HumanForm.eGlCtrSaldo.Color := clYellow;
        if (MainDm.ffPatUpdCtrType.AsInteger = 1) and (MainDm.ffPatUpdCtrSaldo.AsCurrency > KronikerGrpBarn) then
          HumanForm.eGlCtrSaldo.Color := clYellow;
        // ctr b
        HumanForm.eGlCtrSaldoB.Color := clLime;
        HumanForm.eNyCtrSaldoB.Color := clLime;
        HumanForm.eCtrUdlignB.Color := clLime;
        if MainDm.ffPatUpdCtrSaldoB.AsCurrency <> 0 then
          HumanForm.eGlCtrSaldoB.Color := clWebOrange;
        if MainDm.ffPatUpdCtrSaldoB.AsCurrency <> 0 then
          HumanForm.eNyCtrSaldoB.Color := clWebOrange;
        if MainDm.ffPatUpdCTRUdlignB.AsCurrency <> 0 then
          HumanForm.eCtrUdlignB.Color := clWebOrange;

        { TODO : is this correct? used to be 0 }
        MainDm.mtEksNyCtrSaldo.AsCurrency := MainDm.ffPatUpdCtrSaldo.AsCurrency;
        MainDm.mtEksNyCtrSaldoB.AsCurrency := MainDm.ffPatUpdCtrSaldoB.AsCurrency;
        MainDm.mtEksCtrUdlign.AsCurrency := MainDm.ffPatUpdCtrUdlign.AsCurrency;
        MainDm.mtEksCtrUdlignB.AsCurrency := MainDm.ffPatUpdCTRUdlignB.AsCurrency;
        HumanForm.eCtrType.Color := clYellow;
        HumanForm.eCtrType.Font.Color := clWindowText;
        if MainDm.ffPatUpdCtrType.AsInteger = 99 then
          HumanForm.eCtrType.Color := clAqua;

        // Foretag CTR opkald
        if not MainDm.ffPatKarEjCtrReg.AsBoolean then
        begin
          if MainDm.mtEksKundeType.Value = pt_Enkeltperson then
          begin
            c2logadd('  Barn check på cprnr/fød.dato');
            if not MainDm.ffPatKarFiktivtCprNr.AsBoolean then
            begin
              // Check over/under 18 år
              // if CheckBarn (mtEksKundeNr.AsString) then
              // mtEksCtrType.AsInteger := 1;
            end
            else
            begin
              // Check over/under 18 år
              // if CheckBarnDato (ffPatKarFoedDato.AsString) then
              // mtEksCtrType.AsInteger := 1;
            end;
            c2logadd('  CTR patienttype efter barn check ' + MainDm.mtEksCtrType.AsString);
            c2logadd('  Behandling slut');
          end
          else
            c2logadd('  Patient ikke enkeltperson');
        end
        else
          c2logadd('  Patient uden CTR registrering');
        (*
          C2LogAdd ('  Beregn til ny saldo');
          // Ny CTR saldo
          mtEksNyCtrSaldo.AsCurrency := mtEksGlCtrSaldo.AsCurrency;
        *)
      except
        c2logadd('  Exception');
        ChkBoxOk('Exception under CTR opkald, check log!');
      end;

    finally
      if CtrRec.CtrBevText <> '' then
      begin
        c2logadd('  CTR Bevillinger start');
        c2logadd(CtrRec.CtrBevText);
        c2logadd('  CTR Bevillinger slut');
      end;
      c2logadd('CTR oplysninger slut');
      // C2LogSave;
    end;

    // Andre ordredata
    MainDm.mtEksNarkoNr.AsString := '';
    MainDm.mtEksOrdreType.Value := 1; // Salg    2=Retur
    C2LogAdd('Eksphuman ordretype is ' + MainDm.mtEksOrdreType.AsString);
    MainDm.mtEksOrdreStatus.Value := 1; // Åben    2=Afsluttet
    MainDm.mtEksReceptStatus.Value := 0; // Manuel
    MainDm.mtEksAntLin.Value := 0;

    // Evt Reitereret recept
    // if LbNr <> 0 then begin
    ReiterLbNr := 0;
    if (LbNr > 0) then
    begin
      ReiterLbNr := LbNr;
      MainDm.mtEksReceptStatus.Value := 1; // Reitereret
      MainDm.mtEksEkspType.Value := MainDm.ffEksOvrEkspType.Value;
      MainDm.mtEksEkspForm.Value := MainDm.ffEksOvrEkspForm.Value;
      MainDm.mtEksYderNr.AsString := MainDm.ffEksOvrYderNr.AsString;
      MainDm.mtEksYderCprNr.AsString := MainDm.ffEksOvrYderCprNr.AsString;
      MainDm.mtEksYderNavn.AsString := MainDm.ffEksOvrYderNavn.AsString;
    end
    else
    begin
      // Evt. Edifact
      if EdiRcp <> NIL then
      begin
        MainDm.mtEksReceptStatus.Value := 2; // Edifact
        MainDm.mtEksEkspType.Value := et_Recepter; // Recept
        MainDm.mtEksEkspForm.Value := 3; // Edifact
        ReceptId := EdiRcp.LbNr;
        if EdiRcp.LevInfo <> '' then
        begin
          HumanForm.btnVis.Font.Color := clRed;
          HumanForm.btnVis.Font.Style := [fsBold];
        end
        else
        begin
          HumanForm.btnVis.Font.Color := clWindowText;
          HumanForm.btnVis.Font.Style := [];
        end;

        MainDm.mtEksYderNr.AsString := FixLFill('0', 7, EdiRcp.YdNr);
        HumanForm.eYderCPRNr.Items.Clear;
        HumanForm.eYderCPRNr.Items.Add(EdiRcp.YdCprNr);
        MainDm.mtEksYderCprNr.AsString := EdiRcp.YdCprNr;
        MainDm.mtEksYderNavn.AsString := EdiRcp.YdNavn;
        MainDm.mtEksOrdreDato.AsDateTime := EdiRcp.OrdreDato;
      end;
    end;

    // Klargør filtre og visning af lookup
    // TableFilter   (cdEksTyp);
    // TableFilter   (cdEksFrm);
    HumanForm.FakTypeExit(HumanForm);

    // Vis form
    HumanForm.ShowModal;
    c2logadd('F6: after showmodal');

    AllHKlines := True;
    MainDm.mtLin.First;
    while not MainDm.mtLin.Eof do
    begin
      if MainDm.mtLinLinieType.AsInteger <> lt_Handkoeb then
      begin
        AllHKlines := False;
        break;
      end;
      MainDm.mtLin.Next;

    end;

    if AllHKlines then
    begin
      if MainDm.mtEksDebitorNr.AsString <> '' then
        // Debitor felter åbnes
        HumanForm.CheckDebitor;
      if MainDm.mtEksLevNr.AsString <> '' then
        // Levering felter åbnes
        HumanForm.CheckLevering;
    end;

    // Post ekspedition i memtable
    c2logadd('F6:Before mteks post !!!!!!');
    MainDm.mtEks.Post;
    c2logadd('F6:after mteks post !!!!!!');

    if HumanForm.ModalResult = mrok then
    begin
      if EtiketWarn then
      begin
        c2logadd('           **** Kontrol etikett warning issued ****');
        ChkBoxOk('Kontroller at doseringsetiketterne er korrekte.');
      end;
      c2logadd('F6:modal result ok update stamform');
      StamForm.Update;
      c2logadd('check for ctr 0 and tilbagefoersel');
      // Check for CTR 0 saldo og tilbageførsel
      TilbDato := 0;
      if (MainDm.mtEksOrdreType.AsInteger = 2) and (MainDm.mtEksNyCtrSaldo.AsCurrency < 0) then
      begin
        { TODO : CtrB ????? }
        c2logadd('  CTR forrige periode start');
        FillChar(CtrRec, SizeOf(CtrRec), 0);
        MainDm.nxRemoteServerInfoPlugin1.GetServerDateTime(TilbDato);
        CtrRec.CprNr := MainDm.mtEksLmsModtager.AsString;
        CtrRec.TimeOut := 10000;
        MidClient.RecvCtrForrige(CtrRec);
        c2logadd('    Status og message kode ' + IntToStr(CtrRec.Status) + ' '
          + CtrRec.CtrMsg);
        if (CtrRec.Status = 0) and (CtrRec.CtrMsg = '0100') then
        begin
          // Tag dato fra forrige periode
          c2logadd('    Patientoplysninger');
          c2logadd('      CprNr "' + CtrRec.CprNr + '"');
          c2logadd('      Barn "' + CtrRec.Barn + '"');
          c2logadd('      PatType "' + CtrRec.PatType + '"');
          c2logadd('      Saldo "' + CtrRec.Saldo + '"');
          c2logadd('      UdlAkt "' + CtrRec.Udlign + '"');
          c2logadd('      UdlFor "' + CtrRec.UdlFor + '"');
          c2logadd('      SlutAkt "' + CtrRec.PerSlut + '"');
          c2logadd('      SlutFor "' + CtrRec.ForSlut + '"');
          if Length(CtrRec.PerSlut) = 10 then
            TilbDato := StrToDate(CtrRec.PerSlut);
        end;
        TilbDato := ChkBoxDate('Dato i forrige periode', TilbDato);
        c2logadd('  CTR forrige periode start');
      end;

      c2logadd('F6:About to call afslutekspedition');
      AfslutEkspedition(True, HumanForm.CloseF6, HumanForm.CloseSF6, HumanForm.CloseCF6, HumanForm.CloseCSF6,
        TilbDato);
      c2logadd('F6:After call afslutekspedtion');
      MainDm.EkspTypFilter := EkspTypAlle;
      MainDm.EkspFrmFilter := EkspFrmAlle;
      MainDm.LinTypFilter := LinTypAlle;
      // TableFilter (cdEksTyp);
      // TableFilter (cdEksFrm);
      // TableFilter (cdLinTyp);
    end
    else
    begin

      // cancel pressed so remove status any receptserver ordinations
      if EdiRcp <> Nil then
      begin

        sl := TStringList.Create;
        saveRSEkspLinIndex := MainDm.nxRSEkspLin.IndexName;
        MainDm.nxRSEkspLin.IndexName := 'OrdIdOrden';
        try
          for i := 1 to EdiRcp.OrdAnt do
          begin
            LOrdid := EdiRcp.Ord[i].OrdId;
            if LOrdid = '' then
              continue;

            MainDm.nxRSEkspLin.IndexName := 'OrdIdOrden';
            if MainDm.nxRSEkspLin.FindKey([LOrdid,EdiRcp.Ord[i].ReceptId]) then
            begin
              // somewhere else has taksered this ordination on this receptid
              // so skip
              if MainDm.nxRSEkspLinRSLbnr.AsInteger <> 0 then
                continue;

              { TODO : 03-06-2021/MA: Replace constant with real PersonIdSource }
              LKundenr := MainDm.ffPatUpdKundeNr.AsString;
              LPersonIdSource := TFMKPersonIdentifierSource.DetectSource(LKundenr);

              // if the original rs_ekspeditioner record has a blank cpr number
              // then set lkundenr to the patpersonidentifier
              MainDm.nxRSEksp.IndexName := 'ReceptIdOrder';
              if MainDm.nxRSEksp.FindKey([EdiRcp.Ord[i].ReceptId]) then
              begin
                if MainDm.nxRSEkspPatCPR.AsString.IsEmpty then
                begin
                  LKundenr := MainDm.nxRSEkspPatPersonIdentifier.AsString;
                  LPersonIdSource := TFMKPersonIdentifierSource.Parse(
                    MainDm.nxRSEkspPatPersonIdentifierSource.AsInteger);
                end;
              end;

              if MainDm.KeepReceptLokalt then
              begin
                if ufmkcalls.FMKRemoveStatus(MainDm.AfdNr,
                   LKundenr, LPersonIdSource,
                   MainDm.nxRSEkspLinReceptId.AsInteger,
                   StrToInt64( MainDm.nxRSEkspLinOrdId.AsString),
                   MainDm.nxRSEkspLinAdministrationId.AsLargeInt,Nil) then
                begin
                  C2LogAdd('remove status on Administration successful');

                end;

              end
              else
              begin
                if ufmkcalls.FMKRemoveStatus(MainDm.AfdNr,
                  LKundenr, LPersonIdSource,
                  MainDm.nxRSEkspLinReceptId.AsInteger,
                  StrToInt64(MainDm.nxRSEkspLinOrdId.AsString),
                  MainDm.nxRSEkspLinAdministrationId.AsLargeInt, MainDm.nxdb) then
                begin
                  c2logadd('remove status on Administration successful');

                end;
              end;

            end;

          end;
        finally
          sl.Free;
          MainDm.nxRSEkspLin.IndexName := saveRSEkspLinIndex;
        end;

      end;

    end;

    // Luk memtables
    // mtEks.Close;
    // mtLin.Close;
    // mtlin.EmptyDataSet;
  finally
    c2logadd('F6: start of finally');
    if IntLst.Count > 0 then
    begin
      for IntCnt := 0 to IntLst.Count - 1 do
      begin
        IntRef := PTIntRef(IntLst.Objects[IntCnt]);
        if IntRef <> NIL then
        begin
          IntLst.Objects[IntCnt] := NIL;
          FreeMem(IntRef);
        end;
      end;
    end;
    IntLst.Free;
    IntLst := NIL;
    HumanForm.Varelist.Free;
    HumanForm.SaveEtiket.Free;
    HumanForm.Free;
    HumanForm := NIL;
    // Start opdater CTR
    StamForm.CtrTimer.Enabled := True;
    StamForm.StockLager := StamForm.Save_StockLager;

    // reset the reservation grossist list to the first grossist again in case it has been changed
    // during the ekspedition
    MainDm.fqKto.First;
    MainDm.mtGroGrNr.AsInteger := MainDm.fqKto.FieldByName('GrNr').AsInteger;
    MainDm.mtGroGrOplNr.AsInteger := MainDm.fqKto.FieldByName('GrOplNr').AsInteger;

    c2logadd('f6: Stock lager changed to ' + IntToStr(StamForm.StockLager));
    c2logadd('F6: end of finally');
  end;
end;

procedure THumanForm.CheckCtrUpdate;
var
  save_index: string;
  ExitCode: DWord;
  i: Integer;
begin
  c2logadd(' ');
  if MainDm.C2GetCTRJobid <> 0 then
  begin
    for i := 1 to 50 do
    begin
      GetExitCodeProcess(MainDm.C2GetCTRJobid, ExitCode);
      if ExitCode <> STILL_ACTIVE then
        break;
      Sleep(100);
    end;
    MainDm.C2GetCTRJobid := 0;
    c2logadd('c2getctr ' + IntToStr(ExitCode));
  end;

  save_index := MainDm.ffPatUpd.IndexName;
  MainDm.ffPatUpd.IndexName := 'NrOrden';
  try
    if not MainDm.ffPatUpd.FindKey([MainDm.ffPatKarKundeNr.AsString]) then
      exit;
    MainDm.ffPatKar.Refresh;
    c2logadd('  Patient "' + MainDm.ffPatUpdKundeNr.AsString + '" findes');
    c2logadd('    CtrStempel "' + MainDm.ffPatUpdCtrStempel.AsString + '"');
    c2logadd('    CtrSaldo "' + MainDm.ffPatUpdCtrSaldo.AsString + '"');
    c2logadd('    CtrUdlign "' + MainDm.ffPatUpdCtrUdlign.AsString + '"');
    c2logadd('    CtrSaldoB "' + MainDm.ffPatUpdCtrSaldoB.AsString + '"');
    c2logadd('    CtrUdlignB "' + MainDm.ffPatUpdCTRUdlignB.AsString + '"');
    if (FirstCTRCall) and (MainDm.dsEks.State <> dsBrowse) then
    begin
        C2LogAdd('first line always update the ctr values');
        MainDm.mtEksGlCtrSaldo.AsCurrency := MainDm.ffPatUpdCtrSaldo.AsCurrency;
        MainDm.mtEksGlCtrSaldoB.AsCurrency := MainDm.ffPatUpdCtrSaldoB.AsCurrency;
        MainDm.mtEksNyCtrSaldo.AsCurrency := MainDm.ffPatUpdCtrSaldo.AsCurrency;
        MainDm.mtEksNyCtrSaldoB.AsCurrency := MainDm.ffPatUpdCtrSaldoB.AsCurrency;
        MainDm.mtEksCtrUdlign.AsCurrency := MainDm.ffPatUpdCtrUdlign.AsCurrency;
        MainDm.mtEksCtrUdlignB.AsCurrency := MainDm.ffPatUpdCTRUdlignB.AsCurrency;


    end;
    FirstCTRCall := False;

    if MainDm.dsEks.State = dsEdit then
      c2logadd('  mtEks in edit state');
    if MainDm.dsEks.State = dsInsert then
      c2logadd('  mtEks in insert state');
    if MainDm.dsEks.State = dsBrowse then
      c2logadd('  mtEks in browse state');
    if MinutesBetween(Now, MainDm.ffPatUpdCtrStempel.AsDateTime) > 15 then
    begin
      c2logadd('  Tidsforskel > 15 minutter fra nu');
      if MainDm.ffPatUpdKundeType.AsInteger = pt_Enkeltperson then
      begin
        eGlCtrSaldo.Color := clRed;
        eGlCtrSaldoB.Color := clRed;
      end;
      // ChkBoxOK('CTR data er ældre end 15 mintter.' + #13#10+
      // 'Der er en risiko for at det ikke er nyeste saldo, der anvendes.');
    end;
    if MinutesBetween(MainDm.ffPatUpdCtrStempel.AsDateTime, StartCTRTime) <= 15 then
      exit;
    c2logadd('  Tidsforskel > 15 minutter fra StartCtrTime');
    (* BO 3.2.3.9 fjernet
      if mtEksAntLin.Value = 0 then begin
      BO 3.2.3.9 fjernet *)
    (* BO 3.2.3.9 rettet *)
    if MainDm.mtEksAntLin.Value < 2 then
    begin
      (* BO 3.2.3.9 rettet *)
      c2logadd('  Første linie i ekspedition');
      (* BO 3.2.3.9 fjernet
        mtEksGlCtrSaldo.AsCurrency := ffPatUpdCtrSaldo.AsCurrency;
        mtEksCtrUdlign.AsCurrency := ffPatupdCtrUdlign.AsCurrency;
        if nxCTRinf.FindKey([ffPatUpdKundeNr.AsString]) then
        mtEksCtrUdlFor.AsCurrency := nxCTRinffor_udlign_tilskud.AsCurrency;
        FillCTRBevDataset;
        eGlCtrSaldo.Color := clLime;
        mtEks.Refresh;
        mtEks.Edit;
        BO 3.2.3.9 fjernet *)
      (* BO 3.2.3.9 rettet *)
      try
        FillCTRBevDataset;
        eGlCtrSaldo.Color := clLime;
        eGlCtrSaldoB.Color := clLime;
        // mtEks.Post;
        // mtEks.ApplyUpdates(-1);
        // mtEks.Refresh;
        // mtEks.Edit;

        // maybe the ctr type has changed
        MainDm.mtEksCtrType.AsInteger := MainDm.ffPatUpdCtrType.AsInteger;
        eGlCtrSaldo.Color := clLime;
        if (MainDm.ffPatUpdCtrType.AsInteger = 0) and (MainDm.ffPatUpdCtrSaldo.AsCurrency > KronikerGrpVoksen) then
            eGlCtrSaldo.Color := clYellow;
        if (MainDm.ffPatUpdCtrType.AsInteger = 1) and (MainDm.ffPatUpdCtrSaldo.AsCurrency > KronikerGrpBarn) then
            eGlCtrSaldo.Color := clYellow;
        // ctr b
        eGlCtrSaldoB.Color := clLime;
        eNyCtrSaldoB.Color := clLime;
        eCtrUdlignB.Color := clLime;
        if MainDm.ffPatUpdCtrSaldoB.AsCurrency <> 0 then
          eGlCtrSaldoB.Color := clWebOrange;
        if MainDm.ffPatUpdCtrSaldoB.AsCurrency <> 0 then
          eNyCtrSaldoB.Color := clWebOrange;
        if MainDm.ffPatUpdCTRUdlignB.AsCurrency <> 0 then
          eCtrUdlignB.Color := clWebOrange;

        MainDm.mtEksGlCtrSaldo.AsCurrency := MainDm.ffPatUpdCtrSaldo.AsCurrency;
        MainDm.mtEksGlCtrSaldoB.AsCurrency := MainDm.ffPatUpdCtrSaldoB.AsCurrency;
        eGlCtrSaldo.Color := clLime;
        eGlCtrSaldoB.Color := clLime;
        eNyCtrSaldoB.Color := clLime;
        eCtrUdlignB.Color := clLime;
        if MainDm.ffPatUpdCtrSaldoB.AsCurrency <> 0 then
          eGlCtrSaldoB.Color := clWebOrange;
        if MainDm.ffPatUpdCtrSaldoB.AsCurrency <> 0 then
          eNyCtrSaldoB.Color := clWebOrange;
        if MainDm.ffPatUpdCTRUdlignB.AsCurrency <> 0 then
          eCtrUdlignB.Color := clWebOrange;
        MainDm.mtEksCtrUdlign.AsCurrency := MainDm.ffPatUpdCtrUdlign.AsCurrency;
        MainDm.mtEksCtrUdlignB.AsCurrency := MainDm.ffPatUpdCTRUdlignB.AsCurrency;
        { TODO : saldo b? }
        if MainDm.mtEksAntLin.Value <> 0 then
          MainDm.mtLinGlSaldo.AsCurrency := MainDm.ffPatUpdCtrSaldo.AsCurrency;
        MainDm.ffPatKar.Refresh;
        if MainDm.nxCTRinf.FindKey([MainDm.ffPatUpdKundeNr.AsString]) then
        begin
          MainDm.mtEksCtrUdlFor.AsCurrency := MainDm.nxCTRinffor_udlign_tilskud.AsCurrency;
          MainDm.mtEksCtrUdlForB.AsCurrency := MainDm.nxCTRinffor_udlign_tilskudB.AsCurrency;

        end;
      except
        on E: Exception do
          c2logadd(E.Message);
      end;
      exit;
      (* BO 3.2.3.9 fjernet *)
    end;
    c2logadd('  Check for saldo ændret');
    if MainDm.mtEksGlCtrSaldo.AsCurrency <> MainDm.ffPatUpdCtrSaldo.AsCurrency then
    begin
      c2logadd('    Saldo ændret - bruger advares');
      ChkBoxOk('CTR data er ændret i forhold til igangværende ekspedition. ' +
        sLineBreak + 'Det anbefales at lukke ekspeditionen og starte forfra.');
    end;

    c2logadd('  Check for saldoB ændret');
    if MainDm.mtEksGlCtrSaldoB.AsCurrency <> MainDm.ffPatUpdCtrSaldoB.AsCurrency then
    begin
      c2logadd('    Saldo B ændret - bruger advares');
      ChkBoxOk('CTR-B data er ændret i forhold til igangværende ekspedition. '
        + sLineBreak + 'Det anbefales at lukke ekspeditionen og starte forfra.');
    end;
    FillCTRBevDataset;
    eGlCtrSaldo.Color := clLime;
    eGlCtrSaldo.Color := clLime;
    eGlCtrSaldoB.Color := clLime;
    eNyCtrSaldoB.Color := clLime;
    eCtrUdlignB.Color := clLime;
    if MainDm.ffPatUpdCtrSaldoB.AsCurrency <> 0 then
      eGlCtrSaldoB.Color := clWebOrange;
    if MainDm.ffPatUpdCtrSaldoB.AsCurrency <> 0 then
      eNyCtrSaldoB.Color := clWebOrange;
    if MainDm.ffPatUpdCTRUdlignB.AsCurrency <> 0 then
      eCtrUdlignB.Color := clWebOrange;
  finally
    MainDm.ffPatUpd.IndexName := save_index;
  end;
  c2logadd('CheckCtrUpdate out');
end;

function THumanForm.NyLinie: boolean;
var
  i: Integer;
  UdlDato: TDateTime;
  UdlFor, UdlAkt, Udlign, Saldo: Currency;
  IntCnt: Integer;
  save_index: string;
begin

  Result := True;
  Save_AtcKode := '';
  save_caption := '';
  OriginalAntal := 0;
  EUdlev.Enabled := True;
  EMax.Enabled := True;
  // Check nyeste CTR
  if (MainDm.mtlin.RecordCount = 0) and (MainDm.ffPatKarKundeType.AsInteger = pt_Enkeltperson) then
    CheckCtrUpdate;
  // Check linie

  // need to update the ny ctrsaldo values in mteks header record

  // check if product is cannabis, if so then update the header CTR Saldo for B
  if MainDm.mtEksAntLin.AsInteger > 0 then
  begin
    c2logadd('about to update the ny ctr saldo with ' + MainDm.mtLinNySaldo.AsString);
    if CTRBOrdination then
      MainDm.mtEksNyCtrSaldoB.AsCurrency := MainDm.mtLinNySaldo.AsCurrency
    else
      MainDm.mtEksNyCtrSaldo.AsCurrency := MainDm.mtLinNySaldo.AsCurrency;
  end;

  Saldo := MainDm.mtEksGlCtrSaldo.AsCurrency;
  UdlAkt := MainDm.mtEksCtrUdlign.AsCurrency;
  UdlFor := MainDm.mtEksCtrUdlFor.AsCurrency;
  if MainDm.mtEksAntLin.Value > 0 then
  begin
    Saldo := MainDm.mtLinNySaldo.AsCurrency;
    Udlign := MainDm.mtLinUdligning.AsCurrency;
    MainDm.mtLinHeaderCTRUpdated.AsBoolean := True;
  end
  else
    Udlign := UdlAkt;
  paLager.Caption := '';
  paInfo.Color := clBtnFace;
  paInfo.Caption := '';
  SkipReservation := False;
  // Ny linie i linietæller på eksp.
  MainDm.mtEksAntLin.Value := MainDm.mtEksAntLin.Value + 1;

  // cjs code to add entry into intlst
  if MainDm.mtEksAntLin.AsInteger > 1 then
  begin
    if MainDm.ffPatKarKundeType.AsInteger = pt_Enkeltperson then
    begin
      if (MainDm.ffRcpOplInteraktMdr.AsInteger > 0) and maindm.CheckInteraktion then
      begin
        try
          c2logadd('about to add current line to intlst');
          IntCnt := IntLst.IndexOf(Trim(MainDm.mtLinATCKode.AsString));
          c2logadd('intcnt is ' + IntToStr(IntCnt));
          if IntCnt = -1 then
          begin
            GetMem(IntRef, SizeOf(TIntRef));
            IntCnt := IntLst.AddObject(Trim(MainDm.mtLinATCKode.AsString), TObject(IntRef));
            IntRef := PTIntRef(IntLst.Objects[IntCnt]);
            if IntRef <> NIL then
            begin
              // Add interaktionsfelter
              IntRef^.LbNr := 0;
              IntRef^.LinieNr := MainDm.mtLinLinieNr.AsInteger;
              IntRef^.AdvNr := 0;
              IntRef^.VejlNr := 0;
{$WARNINGS OFF}
              IntRef^.VareNr := Trim(MainDm.mtLinSubVareNr.AsString);
              IntRef^.AtcKode := Trim(MainDm.mtLinATCKode.AsString);
              IntRef^.Varetxt := Trim(MainDm.mtLinTekst.AsString);
              c2logadd('  Opret Interaktion current ' + IntRef^.VareNr + ' ' + IntRef^.AtcKode);
{$WARNINGS ON}
            end;
            IntLst.Sorted := True;
          end;
        except
          on E: Exception do
          begin

          end;
        end;
      end;
    end;
  end;

  // Ny linie i mtLin
  itemsubst := False;
  MainDm.KlausFlag := False;
  SaveEtiket.Clear;
  EtiketFieldEntered := False;
  MainDm.mtLin.Append;
  MainDm.mtLinPoslistOverride.AsBoolean := False;
  MainDm.mtLinHeaderCTRUpdated.AsBoolean := False;
  MainDm.mtLinInclMoms.AsBoolean := True;
  MainDm.mtLinEtkLin.Value := 0;
  MainDm.mtLinValideret.AsBoolean := False;
  MainDm.mtLinReitereret.AsBoolean := False;
  MainDm.mtLinLinieNr.Value := MainDm.mtEksAntLin.Value;
  MainDm.mtLinLager.Value := MainDm.mtEksLager.AsInteger;
  MainDm.mtLinGlSaldo.AsCurrency := Saldo;
  MainDm.mtLinSubstValg.Value := 9;
  if (MainDm.ffPatKarEjSubstitution.AsBoolean) or (MainDm.Recepturplads = 'DYR') then
    MainDm.mtLinSubstValg.Value := 0;
  MainDm.mtLinEjS.Value := False;
  // Normal
  MainDm.mtLinUdlevMax.Value := 0;
  MainDm.mtLinUdlevNr.Value := 1;
  MainDm.mtLinAntal.Value := 1;
  EAntal.Color := clWindow;
  pnlVisOrd.Color := clWindow;
  MainDm.mtLinLinieType.Value := lt_Recept;
  if (MainDm.mtEksKundeType.AsInteger in [pt_Ingen, pt_Haandkoebsudsalg]) then
    MainDm.mtLinLinieType.AsInteger := lt_Handkoeb;
  meEtiketter.Clear;
  meEtiketter.Lines.Add('<TOM ETIKET>');
  // Felter uden db
  EVare.Text := '';
  EAntal.Text := IntToStr(MainDm.mtLinAntal.Value);
  // Dosering og indikation
  EDos2.Text := '';
  cbIndikation.Clear;
  cbDosTekst.Clear;
  // Linietype
  MainDm.LinTypFilter := LinTypRcp;
  if MainDm.mtEksEkspType.Value = et_Haandkoeb then
  begin
    MainDm.LinTypFilter := LinTypHdk;
    MainDm.mtLinLinieType.Value := lt_Handkoeb;
  end;
  // TableFilter (cdLinTyp);
  MainDm.TableFilter(MainDm.cdDyrArt);
  MainDm.TableFilter(MainDm.cdDyrAld);
  MainDm.TableFilter(MainDm.cdDyrOrd);
  lcbLinTyp.ItemIndex := MainDm.mtLinLinieType.Value - 1;
  // PostMessage (lcbLinTyp.Handle, wm_KeyDown, VK_DOWN, 0);
  // PostMessage (lcbLinTyp.Handle, wm_KeyDown, VK_UP,   0);
  // Dyr
  if MainDm.mtEksKundeType.Value in [pt_Hobbydyr,pt_Landmand] then
  begin
    MainDm.cdDyrArt.First;
    MainDm.cdDyrAld.First;
    MainDm.cdDyrOrd.First;
    // set animal type to not heste
    if MainDm.mtEksKundeType.Value = pt_Hobbydyr then
      MainDm.cdDyrArt.FindKey([90]);
    MainDm.mtLinDyreArt.Value := MainDm.cdDyrArtNr.Value;
    if (MainDm.DyreAnvFilter = DyreAnvErhv) or (MainDm.DyreAnvFilter = 0) then
    begin
      // Erhverv
      if C2StrPrm(MainDm.C2UserName, 'Receptursvin', '') = 'Ja' then
        MainDm.mtLinDyreArt.Value := 15; // Svin
      MainDm.mtLinAldersGrp.Value := MainDm.cdDyrAldNr.Value;
      MainDm.mtLinOrdGrp.Value := MainDm.cdDyrOrdNr.Value;
    end
    else
    begin
      // Privat
      MainDm.mtLinAldersGrp.Value := 0;
      MainDm.mtLinOrdGrp.Value := 0;
    end;
  end;
  // Opdater form
  HumanForm.Update;
  // Første linie
  if MainDm.mtLinLinieNr.Value = 1 then
  begin
    // Evt. udligning for CTR A
    if (Abs(UdlFor) > 0.25) or (Abs(UdlAkt) > 0.25) then
    begin
      if TCtrUdlignForm.CtrUdlignValg(UdlDato, MainDm.mtEksCtrUdlignDato.AsDateTime,
        Now, Udlign, UdlFor, UdlAkt, Saldo, False) then
      begin
        if UdlDato > 0 then
        begin
          // Fjern evt. forsendelse
          CTRBOrdination := False;
          MainDm.mtEksCtrUdlignDato.Value := UdlDato;
          MainDm.mtEksCtrUdlignType.Value := 1;
          // mtEksDebitorNr.AsString     := '';
          // mtEksDebitorNavn.AsString   := '';
          // mtEksLevNr      .AsString   := '';
          // mtEksLevNavn    .AsString   := '';
          // mtEksLeveringsForm.Value    := 8;
          // Sikre at eksptype og form er korrekt
          MainDm.mtEksEkspType.Value := et_Recepter;
          MainDm.mtEksEkspForm.Value := 1;
          MainDm.mtEksReceptStatus.Value := 0;
          // Debitorfelter spærres
          eDebitorNr.Color := clSilver;
          lcLevForm.Color := clSilver;
          lcLevForm.ReadOnly := True;
          lcLevForm.TabStop := False;
          ePakkeNr.Color := clSilver;
          ePakkeNr.ReadOnly := True;
          ePakkeNr.TabStop := False;
          // Udfyld eksp.linie og afslut
          MainDm.mtEksGlCtrSaldo.AsCurrency := MainDm.ffPatUpdCtrSaldo.AsCurrency;
          MainDm.mtLinValideret.AsBoolean := True;
          MainDm.mtLinLinieType.Value := lt_Recept;
          MainDm.mtLinVareNr.AsString := '100015';
          MainDm.mtLinSubVareNr.AsString := '100015';
          MainDm.mtLinForm.AsString := '';
          MainDm.mtLinStyrke.AsString := '';
          MainDm.mtLinPakning.AsString := '';
          MainDm.mtLinSSKode.AsString := '';
          MainDm.mtLinATCType.AsString := '';
          MainDm.mtLinATCKode.AsString := '';
          MainDm.mtLinPAKode.AsString := '';
          MainDm.mtLinUdlevType.AsString := '';
          MainDm.mtLinHaType.AsString := '';
          MainDm.mtLinUdlevMax.Value := 0;
          MainDm.mtLinUdlevNr.Value := 0;
          MainDm.mtLinRegelKom1.Value := 0;
          MainDm.mtLinRegelKom2.Value := 0;
          MainDm.mtLinGlSaldo.AsCurrency := 0;
          MainDm.mtLinNySaldo.AsCurrency := 0;
          MainDm.mtLinDKTilsk.AsCurrency := 0;
          MainDm.mtLinDKEjTilsk.AsCurrency := 0;
          MainDm.mtLinTilskKom1.AsCurrency := 0;
          MainDm.mtLinTilskKom2.AsCurrency := 0;
          // Sygesikring og udligningsregel
          MainDm.mtLinTilskType.Value := 1;
          MainDm.mtLinRegelSyg.Value := 44;
          MainDm.mtLinAntal.Value := 1;
          MainDm.mtLinKostPris.AsCurrency := Abs(Udlign);
          MainDm.mtLinESP.AsCurrency := Abs(Udlign);
          MainDm.mtLinBGP.AsCurrency := Abs(Udlign);
          MainDm.mtLinPris.AsCurrency := Abs(Udlign);
          MainDm.mtLinBrutto.AsCurrency := Abs(Udlign);
          MainDm.mtLinIBTBel.AsCurrency := Abs(Udlign);
          MainDm.mtLinAndel.AsCurrency := Abs(Udlign);
          MainDm.mtLinUdligning.AsCurrency := Abs(Udlign);
          MainDm.mtLinTilskSyg.AsCurrency := 0;
          MainDm.mtLinBGPBel.AsCurrency := 0;
          if Udlign < 0 then
          begin
            // Udligning til sygesikringen
            MainDm.mtEksOrdreType.Value := 1;
            MainDm.mtLinTekst.AsString := 'Udligning til sygesikringen';
          end
          else
          begin
            // Udligning til patient
            MainDm.mtEksOrdreType.Value := 2;
            MainDm.mtLinTekst.AsString := 'Udligning til patienten';
          end;
          MainDm.mtLinJournalNr1.AsString := '';
          MainDm.mtLinJournalNr2.AsString := '';
          MainDm.mtLinChkJrnlNr1.AsBoolean := False;
          MainDm.mtLinChkJrnlNr2.AsBoolean := False;
          // temp fix until we get a solution for terminal patients
          // if  (mtEksCtrType.AsInteger <> 10) and
          // (mtEksCtrType.AsInteger <> 11) and
          // (mtEksCtrType.AsInteger <> 99) then
          BeregnUdligningOrdination;
          // reset these values just in case they were changed in beregnordination
          MainDm.mtLinRegelSyg.Value := 44;
          MainDm.mtLinTilskType.Value := 1;
          buGem.Enabled := True;
          CloseSF6 := True;
          if MainDm.mtRei.RecordCount > 0 then
          begin
            while not MainDm.mtRei.Eof do
              MainDm.mtRei.Delete;
          end;
          UdlignOrdination := True;
          buGem.Click;
          exit;
        end
        else
          ChkBoxOk('Udligning kan ikke foretages på forkert tidsstempel !');
      end
      else
        MainDm.mtLinUdligning.AsCurrency := Udlign;
    end;

    // Evt. udligning for CTR B
    UdlAkt := MainDm.mtEksCtrUdlignB.AsCurrency;
    UdlFor := MainDm.mtEksCtrUdlForB.AsCurrency;
    if (Abs(UdlFor) > 0.25) or (Abs(UdlAkt) > 0.25) then
    begin
      if TCtrUdlignForm.CtrUdlignValg(UdlDato, MainDm.mtEksCtrUdlignDatoB.AsDateTime,
        Now, Udlign, UdlFor, UdlAkt, MainDm.mtEksGlCtrSaldoB.AsCurrency, True) then
      begin
        if UdlDato > 0 then
        begin
          // Fjern evt. forsendelse
          CTRBOrdination := True;
          MainDm.mtEksCtrUdlignDato.Value := UdlDato;
          MainDm.mtEksCtrUdlignType.Value := 1;
          // mtEksDebitorNr.AsString     := '';
          // mtEksDebitorNavn.AsString   := '';
          // mtEksLevNr      .AsString   := '';
          // mtEksLevNavn    .AsString   := '';
          // mtEksLeveringsForm.Value    := 8;
          // Sikre at eksptype og form er korrekt
          MainDm.mtEksEkspType.Value := et_Recepter;
          MainDm.mtEksEkspForm.Value := 1;
          MainDm.mtEksReceptStatus.Value := 0;
          // Debitorfelter spærres
          eDebitorNr.Color := clSilver;
          lcLevForm.Color := clSilver;
          lcLevForm.ReadOnly := True;
          lcLevForm.TabStop := False;
          ePakkeNr.Color := clSilver;
          ePakkeNr.ReadOnly := True;
          ePakkeNr.TabStop := False;
          // Udfyld eksp.linie og afslut
          MainDm.mtEksGlCtrSaldo.AsCurrency := MainDm.ffPatUpdCtrSaldoB.AsCurrency;
          MainDm.mtLinValideret.AsBoolean := True;
          MainDm.mtLinLinieType.Value := lt_Recept;
          MainDm.mtLinVareNr.AsString := '100015';
          MainDm.mtLinSubVareNr.AsString := '100015';
          MainDm.mtLinForm.AsString := '';
          MainDm.mtLinStyrke.AsString := '';
          MainDm.mtLinPakning.AsString := '';
          MainDm.mtLinSSKode.AsString := '';
          MainDm.mtLinATCType.AsString := '';
          MainDm.mtLinATCKode.AsString := '';
          MainDm.mtLinPAKode.AsString := '';
          MainDm.mtLinUdlevType.AsString := '';
          MainDm.mtLinHaType.AsString := '';
          MainDm.mtLinUdlevMax.Value := 0;
          MainDm.mtLinUdlevNr.Value := 0;
          MainDm.mtLinRegelKom1.Value := 0;
          MainDm.mtLinRegelKom2.Value := 0;
          MainDm.mtLinGlSaldo.AsCurrency := 0;
          MainDm.mtLinNySaldo.AsCurrency := 0;
          MainDm.mtLinDKTilsk.AsCurrency := 0;
          MainDm.mtLinDKEjTilsk.AsCurrency := 0;
          MainDm.mtLinTilskKom1.AsCurrency := 0;
          MainDm.mtLinTilskKom2.AsCurrency := 0;
          // Sygesikring og udligningsregel
          MainDm.mtLinTilskType.Value := 1;
          MainDm.mtLinRegelSyg.Value := 44;
          MainDm.mtLinAntal.Value := 1;
          MainDm.mtLinKostPris.AsCurrency := Abs(Udlign);
          MainDm.mtLinESP.AsCurrency := Abs(Udlign);
          MainDm.mtLinBGP.AsCurrency := Abs(Udlign);
          MainDm.mtLinPris.AsCurrency := Abs(Udlign);
          MainDm.mtLinBrutto.AsCurrency := Abs(Udlign);
          MainDm.mtLinIBTBel.AsCurrency := Abs(Udlign);
          MainDm.mtLinAndel.AsCurrency := Abs(Udlign);
          MainDm.mtLinUdligning.AsCurrency := Abs(Udlign);
          MainDm.mtLinTilskSyg.AsCurrency := 0;
          MainDm.mtLinBGPBel.AsCurrency := 0;
          if Udlign < 0 then
          begin
            // Udligning til sygesikringen
            MainDm.mtEksOrdreType.Value := 1;
            MainDm.mtLinTekst.AsString := 'CTR-B Udligning til sygesikringen';
          end
          else
          begin
            // Udligning til patient
            MainDm.mtEksOrdreType.Value := 2;
            MainDm.mtLinTekst.AsString := 'CTR-B Udligning til patienten';
          end;
          MainDm.mtLinJournalNr1.AsString := '';
          MainDm.mtLinJournalNr2.AsString := '';
          MainDm.mtLinChkJrnlNr1.AsBoolean := False;
          MainDm.mtLinChkJrnlNr2.AsBoolean := False;
          // temp fix until we get a solution for terminal patients
          // if  (mtEksCtrType.AsInteger <> 10) and
          // (mtEksCtrType.AsInteger <> 11) and
          // (mtEksCtrType.AsInteger <> 99) then
          BeregnUdligningOrdination;
          // reset these values just in case they were changed in beregnordination
          MainDm.mtLinRegelSyg.Value := 44;
          MainDm.mtLinTilskType.Value := 1;
          buGem.Enabled := True;
          CloseSF6 := True;
          if MainDm.mtRei.RecordCount > 0 then
          begin
            while not MainDm.mtRei.Eof do
              MainDm.mtRei.Delete;
          end;
          UdlignOrdination := True;
          buGem.Click;
        end
        else
          ChkBoxOk('Udligning kan ikke foretages på forkert tidsstempel !');
      end
      else
        MainDm.mtLinUdligning.AsCurrency := Udlign;
    end;

  end;
  // Hvis der ikke var udlignet
  if MainDm.mtEksCtrUdlignType.Value <> 0 then
    exit;

  // Check reiterering
  if MainDm.mtEksReceptStatus.Value = 1 then
  begin
    if MainDm.mtRei.RecordCount = 0 then
    begin
      Result := False;
      exit;
    end;
    // Memtable felter
    MainDm.mtLinUdlevMax.Value := MainDm.mtReiUdlevMax.Value;
    MainDm.mtLinUdlevNr.Value := MainDm.mtReiUdlevNr.Value;

    MainDm.mtLinAntal.Value := MainDm.mtReiAntal.Value;
    OriginalAntal := MainDm.mtReiAntal.Value;
    MainDm.mtLinDosering1.AsString := MainDm.mtReiDosTxt.AsString;
    MainDm.mtLinDosering2.AsString := MainDm.mtReiDosKode2.AsString;
    MainDm.mtLinIndikation.AsString := MainDm.mtReiIndTxt.AsString;
    MainDm.mtLinFolgeTxt.AsString := MainDm.mtReiTxtKode.AsString;
    MainDm.mtLinSubstValg.AsInteger := MainDm.mtReiSubst.Value;
    MainDm.mtLinLinieType.Value := lt_Recept;

    MainDm.mtLinReitereret.AsBoolean := True;
    // Edit felter
    EVare.Text := MainDm.mtReiVareNr.AsString;
    EAntal.Text := IntToStr(MainDm.mtLinAntal.Value);
    paInfo.Caption := MainDm.mtReiVareTxt.AsString;
    save_caption := paInfo.Caption;
    itemsubst := Pos('-S', paInfo.Caption) <> 0;
    MainDm.KlausFlag := Pos('KLAUS', paInfo.Caption) <> 0;
    if (itemsubst) or (MainDm.KlausFlag) then
      paInfo.Color := clYellow;
    meEtiketter.Clear;
    meEtiketter.Update;
    // F1227 change etiketter label to have updated navn and age (if necessaery)
    if MainDm.mtEksCtrType.AsInteger in [1, 11] then
      meEtiketter.Lines.Add(AnsiUpperCase(BytNavn(MainDm.ffPatKarNavn.AsString)) +
        ' ' + calcage(MainDm.ffPatKarKundeNr.AsString, MainDm.ffPatKarFoedDato.AsString))
    else
      meEtiketter.Lines.Add(AnsiUpperCase(BytNavn(MainDm.ffPatKarNavn.AsString)));
    for i := 2 to MainDm.mtReiEtkLin.Value do
      meEtiketter.Lines.Add(MainDm.mtRei.FieldByName('Etk' + IntToStr(i)).AsString);
    SaveEtiket.Text := meEtiketter.Lines.Text;
    MainDm.mtRei.Delete;
    exit;
  end;
  // Evt Edifact
  // if mtEksReceptStatus.Value = 2 then begin
  if (MainDm.mtEksReceptStatus.Value = 2) then
  begin
    if MainDm.mtRei.RecordCount = 0 then
    begin
      StamForm.TakserDosisKortAuto := False;
      StamForm.Undladafstemplingsetiketter := False;
      OrderComplete := True;
      Result := False;
      exit;

    end;

    // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER
    // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER
    // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER
    // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER
    // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER

    // Memtable felter
    MainDm.mtLinUdlevMax.Value := MainDm.mtReiUdlevMax.Value;
    MainDm.mtLinUdlevNr.Value := MainDm.mtReiUdlevNr.Value;
    if (MainDm.mtLinUdlevMax.AsInteger <> 0) or (MainDm.mtLinUdlevNr.AsInteger <> 0) then
      if MainDm.mtLinUdlevNr.AsInteger > MainDm.mtLinUdlevMax.AsInteger + 1 then
    begin
      ChkBoxOK('Antal udleveringer er større end max'+ sLineBreak +
          'Tjek udleveringsdetaljer med F5');
        EAntal.Color := clYellow;
        pnlVisOrd.Color := clYellow;
    end;
    MainDm.mtLinAntal.Value := MainDm.mtReiAntal.Value;
    OriginalAntal := MainDm.mtReiAntal.Value;
    MainDm.mtLinDosering1.AsString := MainDm.mtReiDosTxt.AsString;
    MainDm.mtLinDosering2.AsString := '';
    MainDm.mtLinIndikation.AsString := MainDm.mtReiIndTxt.AsString;
    MainDm.mtLinFolgeTxt.AsString := '';
    MainDm.mtLinLinieType.Value := lt_Recept;
    if MainDm.mtReiOrdId.AsString = '' then
      MainDm.mtLinLinieType.Value := lt_Handkoeb;

    MainDm.mtLinReitereret.AsBoolean := True;
    MainDm.mtLinSubstValg.Value := MainDm.mtReiSubst.Value;
    MainDm.mtLinOrdId.AsString := MainDm.mtReiOrdId.AsString;
    MainDm.mtLinReceptId.AsInteger := MainDm.mtReiReceptId.AsInteger;
    MainDm.mtLinOrdineretVarenr.AsString := MainDm.mtReiOrdineretVarenr.AsString;
    MainDm.mtLinOrdineretAntal.AsInteger := MainDm.mtReiOrdineretAntal.AsInteger;
    MainDm.mtLinOrdineretUdlevType.AsString := MainDm.mtReiOrdineretUdlevType.AsString;
    EUdlev.Enabled := True;
    EMax.Enabled := True;
    if MatchText(MainDm.mtLinOrdineretUdlevType.AsString,['AP4','NBS','A','AP4NBS']) then
    begin
      EUdlev.Enabled := False;
      EMax.Enabled := False;
    end;

    EordreOveridePrice := False;
    c2logadd('Ehordre is ' + Bool2Str(MainDm.EHOrdre));
    if MainDm.EHOrdre then
    begin
      MainDm.mtLinPris.AsCurrency := MainDm.mtReiUserPris.AsCurrency;
      EordreOveridePrice := MainDm.mtReiUserPris.AsCurrency <> 0;
      c2logadd('eordre override price is ' + Bool2Str(EordreOveridePrice));
    end;
    // Edit felter
    EVare.Text := MainDm.mtReiVareNr.AsString;
    OriginalVarenr := '';
    if MainDm.EHOrdre then
    begin
      if MainDm.mtReiSubst.Value in [1, 2] then
      begin
        OriginalVarenr := MainDm.mtReiVareNr.AsString;
        EVare.Text := MainDm.mtReiSubVarenr.AsString;
      end;
    end;
    EAntal.Text := IntToStr(MainDm.mtLinAntal.Value);
    save_index := MainDm.ffLagKar.IndexName;
    MainDm.ffLagKar.IndexName := 'NrOrden';
    try
      if MainDm.ffLagKar.FindKey([MainDm.mtLinLager.Value, EVare.Text]) then
        Save_AtcKode := MainDm.ffLagKarAtcKode.AsString;
    finally
      MainDm.ffLagKar.IndexName := save_index;
    end;
    paInfo.Caption := MainDm.mtReiVareTxt.AsString;
    save_caption := paInfo.Caption;
    itemsubst := Pos('-S', paInfo.Caption) <> 0;
    MainDm.KlausFlag := Pos('KLAUS', paInfo.Caption) <> 0;
    if (itemsubst) or (MainDm.KlausFlag) then
      paInfo.Color := clYellow;
    meEtiketter.Clear;
    meEtiketter.Update;
    for i := 1 to MainDm.mtReiEtkLin.Value do
      meEtiketter.Lines.Add(MainDm.mtRei.FieldByName('Etk' + IntToStr(i)).AsString);
    SaveEtiket.Text := meEtiketter.Lines.Text;
    EtiketFieldEntered := False;
    MainDm.mtLinUdstederAutid.AsString := MainDm.mtReiUdstederAutid.AsString;
    MainDm.mtLinUdstederId.AsString := MainDm.mtReiUdstederId.AsString;
    MainDm.mtLinUdstederType.AsInteger := MainDm.mtReiUdstederType.AsInteger;
    MainDm.mtRei.Delete;
  end;
end;

procedure THumanForm.buLukClick(Sender: TObject);
begin
  Close;
end;

procedure THumanForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin

  // if there has been an error then just quit taksering screen

  if ForceClose then
  begin
    CanClose := True;
    ModalResult := mrCancel;
    exit;
  end;

  if (not CloseF6) and (not CloseSF6) and (not CloseCF6) and (not CloseCSF6)
  then
  begin
    if ChkBoxYesNo('Skal ekspedition annulleres ?', True) then
    begin
      if MainDm.mtLin.State <> dsBrowse then
        MainDm.mtLin.Cancel;
      CanClose := True;
      ModalResult := mrCancel;
    end
    else
      CanClose := False;
  end;
end;

procedure THumanForm.FormCreate(Sender: TObject);
begin
  Screen.OnActiveControlChange := ActiveControlChanged;
end;

procedure THumanForm.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveControlChange := Nil;
end;

procedure THumanForm.FormActivate(Sender: TObject);
var
  i, J: Word;
  save_index: string;
  saveETKindex: string;

  procedure delete_old_indhold;
  var
    i: Integer;
    tmpstr: string;
  begin
    c2logadd('before deleting indhold ' + meEtiketter.Text);
    for i := 0 to meEtiketter.Lines.Count - 1 do
    begin
      tmpstr := meEtiketter.Lines[i];
      if tmpstr = '------------------------------' then
      begin
        meEtiketter.Lines.Delete(i);
        break;
      end;
    end;
    for i := 0 to meEtiketter.Lines.Count - 1 do
    begin
      tmpstr := meEtiketter.Lines[i];
      if Pos('INDHOLD:', tmpstr) <> 0 then
      begin
        meEtiketter.Lines.Delete(i);
        break;
      end;
    end;
    c2logadd('after deleting indhold ' + meEtiketter.Text);

  end;

  function StripChars(inputstr: string): string;
  var
    i: Integer;
    tmpstr: string;
  begin
    tmpstr := inputstr;
    for i in [0 .. 31] do
    begin
      tmpstr := StringReplace(tmpstr, Chr(i), ' ', [rfReplaceAll]);
      // c2logadd('tmpstr is ' + tmpstr);
    end;
    Result := tmpstr;

  end;

begin
  { TODO : set the date to correct date before distribution }
  CTRBStartDate := EncodeDate(2018, 1, 1);
  // if CTRBStartDate<EncodeDate (2019, 1, 1) then
  // ChkBoxOK('CTR-B TEST DATE !!!!!!!!!');
  CTRBOrdination := False;
  c2logadd('Human Form Formactivate fired');
  // reset the ehandelautoenter to the value from winpacer
  TakserEHAutotEnter := maindm.EHAutoEnter;
  OrderComplete := False;
  if FirstTime then
    exit;
  c2logadd('first time is false then set it true');
  if (Screen.Height <= 768) and (Screen.Width <= 1024) then
    if (StamForm.FullScreen) or (Screen.Height = 600) then
      SendMessage(Self.Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
  FirstTime := True;
  itemsubst := False;
  MainDm.KlausFlag := False;
  Caption := 'Taksering';
  // Etiketareal afhængig af printer
  if MainDm.Recepturplads = 'DYR' then
  begin
    // Dyr
    meEtiketter.Width := meEtiketter.Tag;
    cbSubst.Visible := False;
    laMax.Visible := False;
    EMax.Visible := False;
    laUdlev.Visible := False;
    EUdlev.Visible := False;
  end
  else
  begin
    // Human
    cbSubst.Visible := True;
    laMax.Visible := True;
    EMax.Visible := True;
    laUdlev.Visible := True;
    EUdlev.Visible := True;
  end;
  eYderNr.Enabled := True;
  eYderCPRNr.Enabled := True;
  c2logadd('Emptying the mtrei tables');
  MainDm.mtRei.Active := False;
  MainDm.mtRei.Active := True;
  if MainDm.mtRei.RecordCount > 0 then
  begin
    while not MainDm.mtRei.Eof do
      MainDm.mtRei.Delete;
  end;
  // Ved reiterering lades som om der vælges på Type og Form
  if MainDm.mtEksReceptStatus.Value = 1 then
  begin
    // Dan receptlinier
    c2logadd('recept status is 1');
    MainDm.mtRei.Active := False;
    MainDm.mtRei.Active := True;
    if MainDm.mtRei.RecordCount > 0 then
    begin
      while not MainDm.mtRei.Eof do
        MainDm.mtRei.Delete;
    end;
    save_index := MainDm.ffEksLin.IndexName;
    saveETKindex := MainDm.ffEksEtk.IndexName;
    MainDm.ffEksLin.IndexName := 'NrOrden';
    MainDm.ffEksEtk.IndexName := 'NrOrden';
    MainDm.ffEksLin.SetRange([ReiterLbNr], [ReiterLbNr]);
    try
      MainDm.ffEksLin.Last;
      while not MainDm.ffEksLin.Bof do
      begin
        c2logadd('lbnr on the lines is ' + IntToStr(MainDm.ffEksLinLbNr.AsInteger));
        if MainDm.ffEksLinUdlevMax.Value > 0 then
        begin
          c2logadd('found a line which is to be checked for repeat');
          if MainDm.ffEksLinUdlevNr.Value < MainDm.ffEksLinUdlevMax.Value then
          begin
            c2logadd('the udlev number is less than the max');
            if MainDm.ffEksEtk.FindKey([MainDm.ffEksLinLbNr.Value, MainDm.ffEksLinLinieNr.Value])
            then
            begin
              c2logadd('Found the etiketter');
              meEtiketter.Clear;
              meEtiketter.Lines.Assign(MainDm.ffEksEtkEtiket);
              MainDm.mtRei.Append;
              MainDm.mtReiVareNr.AsString := MainDm.ffEksLinVareNr.AsString;
              MainDm.mtReiUdlevNr.Value := MainDm.ffEksLinUdlevNr.Value + 1;
              MainDm.mtReiUdlevMax.Value := MainDm.ffEksLinUdlevMax.Value;
              MainDm.mtReiAntal.Value := MainDm.ffEksLinAntal.Value;
              MainDm.mtReiDosKode1.AsString := MainDm.ffEksEtkDosKode1.AsString;
              MainDm.mtReiDosKode2.AsString := MainDm.ffEksEtkDosKode2.AsString;
              MainDm.mtReiIndikKode.AsString := MainDm.ffEksEtkIndikKode.AsString;
              MainDm.mtReiTxtKode.AsString := MainDm.ffEksEtkTxtKode.AsString;
              MainDm.mtReiVareTxt.AsString := copy(MainDm.ffEksLinTekst.AsString, 1, 20) +
                ',' + copy(MainDm.ffEksLinForm.AsString, 1, 10) + ',' +
                copy(MainDm.ffEksLinPakning.AsString, 1, 10) + ',' +
                copy(MainDm.ffEksLinStyrke.AsString, 1, 10);
              MainDm.mtReiEtkLin.Value := 0;
              if Pos('INDHOLD:', meEtiketter.Text) <> 0 then
                delete_old_indhold;
              c2logadd('setting the etiket label ' + meEtiketter.Text);
              for i := 1 to 10 do
              begin
                MainDm.mtRei.FieldByName('Etk' + IntToStr(i)).AsString := '';
                if meEtiketter.Lines.Count >= i then
                begin
                  MainDm.mtRei.FieldByName('Etk' + IntToStr(i)).AsString := Trim(meEtiketter.Lines[i - 1]);
                  if MainDm.mtRei.FieldByName('Etk' + IntToStr(i)).AsString <> '' then
                    MainDm.mtReiEtkLin.Value := i;
                end;
              end;
              MainDm.mtRei.Post;
            end;
          end;
        end;
        MainDm.ffEksLin.Prior;
      end;
    finally
      MainDm.ffEksLin.CancelRange;
      MainDm.ffEksLin.IndexName := save_index;
    end;
    // Slet evt. etiketter
    meEtiketter.Clear;
    // Peg på første post
    MainDm.mtRei.First;
    // Forlad EkspForm
    EkspFormExit(Self);
    if MainDm.TakserAutoEnter then
    begin
      PostMessage(buVidere.Handle, WM_LBUTTONDOWN, 0, 0);
      PostMessage(buVidere.Handle, WM_LBUTTONUP, 0, 0);
      EVare.SetFocus;
    end;
    exit;
  end;
  // if mtEksReceptStatus.Value = 2 then begin
  if (MainDm.mtEksReceptStatus.Value = 2) then
  begin
    // Edifact dan receptlinier
    MainDm.mtRei.Active := False;
    MainDm.mtRei.Active := True;
    if MainDm.mtRei.RecordCount > 0 then
    begin
      while not MainDm.mtRei.Eof do
        MainDm.mtRei.Delete;
    end;
    // eYderNr.Enabled := False;
    // eYderCPRNr.Enabled := False;
    SaveDosisKortNr := 0;
    for J := 1 to EdiRcp.OrdAnt do
    begin
      (*
        C2LogAdd ('  ' + EdiOrd.Navn);
        C2LogAdd ('  ' + EdiOrd.Disp);
        C2LogAdd ('  ' + EdiOrd.Strk);
        C2LogAdd ('  ' + EdiOrd.Pakn);
        C2LogAdd ('  ' + EdiOrd.Subst);
        C2LogAdd ('  ' + IntToStr (EdiOrd.Antal));
        C2LogAdd ('  ' + EdiOrd.Tilsk);
        C2LogAdd ('  ' + EdiOrd.Indik);
        C2LogAdd ('  ' + IntToStr (EdiOrd.Udlev));
        C2LogAdd ('  ' + EdiOrd.Forhdl);
        C2LogAdd ('  ' + EdiOrd.DosTxt);
      *)

      // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER
      // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER
      // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER
      // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER
      // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER

      meEtiketter.Clear;
      // F1227 change etiketter label to have updated navn and age (if necessaery)
      if MainDm.ffPatKarCtrType.AsInteger in [1, 11] then
        meEtiketter.Lines.Add(AnsiUpperCase(BytNavn(MainDm.ffPatKarNavn.AsString)) +
          ' ' + calcage(MainDm.ffPatKarKundeNr.AsString, MainDm.ffPatKarFoedDato.AsString))
      else
        meEtiketter.Lines.Add(AnsiUpperCase(BytNavn(MainDm.ffPatKarNavn.AsString)));
      c2logadd('before the lines were stripchars would be called');
      meEtiketter.Lines.Add(StripChars(AnsiUpperCase(Trim(EdiRcp.Ord[J].DosTxt))));
      meEtiketter.Lines.Add(StripChars(AnsiUpperCase(Trim(EdiRcp.Ord[J].IndTxt))));
      MainDm.mtRei.Append;
      MainDm.mtReiVareNr.AsString := EdiRcp.Ord[J].VareNr;
      if MainDm.EHOrdre then
        MainDm.mtReiSubVarenr.AsString := EdiRcp.Ord[J].SubVarenr;

      MainDm.mtReiVareTxt.AsString := copy(EdiRcp.Ord[J].Navn, 1, 20) + ',' +
        copy(EdiRcp.Ord[J].Disp, 1, 10) + ',' + copy(EdiRcp.Ord[J].Pakn, 1, 10) + ',' +
        copy(EdiRcp.Ord[J].Strk, 1, 10);
      if EdiRcp.Ord[J].Subst <> '' then
        MainDm.mtReiVareTxt.AsString := MainDm.mtReiVareTxt.AsString + ',  -S';
      if EdiRcp.Ord[J].Klausulbetingelse then
        MainDm.mtReiVareTxt.AsString := MainDm.mtReiVareTxt.AsString + ',KLAUS';

      MainDm.mtReiUdlevNr.Value := 1;
      if EdiRcp.Ord[J].PEMAdmDone <> 0 then
        MainDm.mtReiUdlevNr.Value := EdiRcp.Ord[J].PEMAdmDone + 1;

      MainDm.mtReiUdlevMax.Value := 0;
      if EdiRcp.Ord[J].Udlev > 1 then
        MainDm.mtReiUdlevMax.Value := EdiRcp.Ord[J].Udlev;
      MainDm.mtReiAntal.Value := EdiRcp.Ord[J].Antal;
      MainDm.mtReiDosKode1.AsString := EdiRcp.Ord[J].DosKode;
      MainDm.mtReiDosTxt.AsString := edircp.Ord[J].DosTxt;
      MainDm.mtReiDosKode2.AsString := '';
      MainDm.mtReiIndikKode.AsString := EdiRcp.Ord[J].IndKode;
      MainDm.mtReiIndTxt.AsString := edircp.Ord[J].IndTxt;
      MainDm.mtReiTxtKode.AsString := '';
      MainDm.mtReiSubst.Value := 9;
      if Trim(EdiRcp.Ord[J].Subst) = '' then
        MainDm.mtReiSubst.Value := 5
      else
      begin
        if Pos('-S', EdiRcp.Ord[J].Subst) > 0 then
          MainDm.mtReiSubst.Value := 1;
        if Pos('-G', EdiRcp.Ord[J].Subst) > 0 then
          MainDm.mtReiSubst.Value := 2;
      end;

      if MainDm.EHOrdre then
      begin
        c2logadd('Subst is ' + EdiRcp.Ord[J].Subst);
        if EdiRcp.Ord[J].Subst = 'Ejs' then
          MainDm.mtReiSubst.Value := 1
        else if EdiRcp.Ord[J].Subst = 'KundenHarValgtOrdineret' then
          MainDm.mtReiSubst.Value := 2
        else if EdiRcp.Ord[J].Subst = 'KundenHarValgtAnden' then
          MainDm.mtReiSubst.Value := 2
        else
          MainDm.mtReiSubst.Value := 5;
        if EdiRcp.Ord[J].OrdId = '' then
          MainDm.mtReiSubst.Value := 2;

        MainDm.mtReiVareTxt.AsString := copy(EdiRcp.Ord[J].Navn, 1, 20) + ',' +
          copy(EdiRcp.Ord[J].Disp, 1, 10) + ',' + copy(EdiRcp.Ord[J].Pakn, 1, 10) + ',' +
          copy(EdiRcp.Ord[J].Strk, 1, 10);
        if EdiRcp.Ord[J].Subst = 'Ejs' then
          MainDm.mtReiVareTxt.AsString := MainDm.mtReiVareTxt.AsString + ',  -S';
        if EdiRcp.Ord[J].Klausulbetingelse then
          MainDm.mtReiVareTxt.AsString := MainDm.mtReiVareTxt.AsString + ',KLAUS';
      end;
      c2logadd('mtreisubst ' + MainDm.mtReiSubst.AsString);

      MainDm.mtReiEtkLin.Value := 0;
      MainDm.mtReiOrdId.AsString := EdiRcp.Ord[J].OrdId;
      MainDm.mtReiReceptId.AsInteger := EdiRcp.Ord[J].ReceptId;
      MainDm.mtReiOrdineretVarenr.AsString := EdiRcp.Ord[J].OrdineretVarenr;
      MainDm.mtReiOrdineretAntal.AsInteger := EdiRcp.Ord[J].OrdineretAntal;
      MainDm.mtReiOrdineretUdlevType.AsString := EdiRcp.Ord[J].OrdineretUdlevType;
      MainDm.mtReiUdstederId.AsString := EdiRcp.Ord[J].UdstederId;
      MainDm.mtReiUdstederAutid.AsString := EdiRcp.Ord[J].UdstederAutId;
      MainDm.mtReiUdstederType.AsInteger := EdiRcp.Ord[J].UdstederType;
      if MainDm.mtReiUdstederType.AsInteger = 3 then
      begin
        MainDm.mtEksYderNr.AsString := '0990027';
  //      MainDm.mtReiVareNr.AsString := '0990027';

  //      if ContainsText(Organisation.Name, 'sygehus') or ContainsText(Organisation.Name, 'hospital') then
  //        FieldByName(fnRS_EkspeditionerSenderId).AsString := '0994057';

      end;
      if MainDm.EHOrdre then
        MainDm.mtReiUserPris.AsCurrency := EdiRcp.Ord[J].UserPris;
      c2logadd('setting the etiket label ' + meEtiketter.Text);
      for i := 1 to 10 do
      begin
        MainDm.mtRei.FieldByName('Etk' + IntToStr(i)).AsString := '';
        if meEtiketter.Lines.Count >= i then
        begin
          MainDm.mtRei.FieldByName('Etk' + IntToStr(i)).AsString := Trim(meEtiketter.Lines[i - 1]);
          if MainDm.mtRei.FieldByName('Etk' + IntToStr(i)).AsString <> '' then
            MainDm.mtReiEtkLin.Value := MainDm.mtReiEtkLin.Value + 1;
        end;
      end;
      MainDm.mtRei.Post;
    end;
    // Slet evt. etiketter
    meEtiketter.Clear;
    // Peg på første post
    MainDm.mtRei.First;
    // Forlad EkspForm
    EkspFormExit(Self);
    // Normal recept
    PostMessage(lcbEkspType.Handle, wm_KeyDown, VK_DOWN, 0);
    PostMessage(lcbEkspType.Handle, wm_KeyDown, VK_UP, 0);
    PostMessage(lcbEkspForm.Handle, wm_KeyDown, VK_DOWN, 0);
    PostMessage(lcbEkspForm.Handle, wm_KeyDown, VK_UP, 0);
    lcbEkspType.SetFocus;

    if MainDm.TakserAutoEnter then
    begin
      PostMessage(buVidere.Handle, WM_LBUTTONDOWN, 0, 0);
      PostMessage(buVidere.Handle, WM_LBUTTONUP, 0, 0);
      EVare.SetFocus;
    end;
  end
  else
  begin
    // Normal recept

    PostMessage(lcbEkspType.Handle, wm_KeyDown, VK_DOWN, 0);
    PostMessage(lcbEkspType.Handle, wm_KeyDown, VK_UP, 0);
    PostMessage(lcbEkspForm.Handle, wm_KeyDown, VK_DOWN, 0);
    PostMessage(lcbEkspForm.Handle, wm_KeyDown, VK_UP, 0);
    lcbEkspType.SetFocus;
    if MainDm.TakserAutoEnter then
    begin
      PostMessage(buVidere.Handle, WM_LBUTTONDOWN, 0, 0);
      PostMessage(buVidere.Handle, WM_LBUTTONUP, 0, 0);
      EVare.SetFocus;
    end;
    if MainDm.mtEksKundeType.AsInteger = pt_Hobbydyr then
    begin
      PostMessage(buVidere.Handle, WM_LBUTTONDOWN, 0, 0);
      PostMessage(buVidere.Handle, WM_LBUTTONUP, 0, 0);
      EVare.SetFocus;
    end;
  end;
end;

procedure THumanForm.FormShow(Sender: TObject);
begin
  c2logadd('Set firsttime to false');
  FirstTime := False;
  buVidere.Tag := 0;
  buGem.Enabled := False;
  CloseF6 := False;
  CloseSF6 := False;
  CloseCF6 := False;
  CloseCSF6 := False;
  save_caption := '';
  if ReceptId = 0 then
    btnVis.Visible := False
  else
    btnVis.Visible := True;
  SkipReservation := False;
  cbDosTekst.AutoComplete := False;
  cbIndikation.AutoComplete := False;
  if StamForm.HentDosisIndikationsForslag then
  begin
    cbDosTekst.AutoComplete := True;
    cbIndikation.AutoComplete := True;
  end;

  AntalFieldKeyPress := False;
  EtiketWarn := False;
  try
    cdsLinDisp.CloneCursor(MainDm.mtLin, False, True);
  except
    on E: Exception do
      ChkBoxOk(E.Message);
  end;
    (*
      paLinier.Visible := False;
      paBund.Visible   := False;
      Update;
    *)
end;

procedure THumanForm.GetTidlPrices(ALagerNr: integer; AVarenr: string; out ASalgspris : currency; out ABGP : currency);
var
  Lquery : TnxQuery;
begin
  ASalgspris := 0.0;
  ABGP := 0.0;
  try
    Lquery := MainDm.nxdb.OpenQuery('select TidlSalgsPris, TidlBgp from ' + tnlagerkartotek + ' where ' +
        fnLagerKartotekLager_P + ' and ' + fnLagerKartotekVareNr_P,[ALagerNr,AVareNr]);
    try
      if not Lquery.Eof then
      begin
        ASalgspris := Lquery.FieldByName('TidlSalgsPris').AsCurrency;
        ABGp := Lquery.FieldByName('TidlBgp').AsCurrency;
      end;


    finally
      Lquery.Free;
    end;


  except
    on E: Exception do
      C2LogAdd('Fejl i GetTidlPrices ' + e.Message);
  end;

end;

procedure THumanForm.grLinierCellClick(Column: TColumn);
begin
  // ChkBoxOK('No no no no no no');
end;

procedure THumanForm.grLinierDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  try
    MainDm.nxLager.IndexName := 'NrOrden';

    // colour canabis orange
    if MainDm.nxLager.FindKey([MainDm.mtLinLager.AsInteger, MainDm.mtLinSubVareNr.AsString]) then
    begin
      if copy(MainDm.nxLagerDrugId.AsString, 1, 4) = CannabisPrefix then
      begin
        grLinier.Canvas.Brush.Color := clWebOrange;
        grLinier.Canvas.Font.Color := clBlack;
        exit;
      end;
    end;

    if not StamForm.PatientkartotekVareInfo then
      exit;
    if not MainDm.mtLinVareInfo.AsBoolean then
      exit;

    grLinier.Canvas.Brush.Color := clLime;
    grLinier.Canvas.Font.Color := clBlack;
  finally
    grLinier.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;

end;

procedure THumanForm.grLinierMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  c2logadd('Mouse pressed on ' + ActiveControl.Name);
end;

procedure THumanForm.EkspFormExit(Sender: TObject);
begin
  if MainDm.mtEksEkspForm.Value = 4 then
  begin
    if eNarkoNr.Text <> '' then
      eNarkoNr.Color := clWindow
    else
      eNarkoNr.Color := clYellow;
    eNarkoNr.ReadOnly := False;
    eNarkoNr.TabStop := True;
  end
  else
  begin
    eNarkoNr.Color := clSilver;
    eNarkoNr.ReadOnly := True;
    eNarkoNr.TabStop := False;
  end;

  // if mtEksEkspType.Value = 6 then begin
  eYderCPRNr.Color := clYellow;
  eYderCPRNr.ReadOnly := False;
  eYderCPRNr.TabStop := True;
  {
    end else begin

    eYderCprNr.Color    := clSilver;
    eYderCprNr.ReadOnly := True;
    eYderCprNr.TabStop  := False;
    end;
  }
  (*
    if not paLinier.Visible then begin
    paLinier.Visible    := True;
    paBund.Visible      := True;
    Update;
    end;
  *)
  // PostMessage (buVidere.Handle, WM_SETFOCUS, 0, 0);
end;

procedure THumanForm.buVidereEnter(Sender: TObject);
begin
  c2logadd('Ny linie entered');
  buGem.Enabled := False;
  NyLineClicked := False;
  if MainDm.mtEksAntLin.Value = 0 then
  begin
    buVidere.Tag := 1;
    NyLinie;
    exit;
  end;

  if MainDm.mtLin.State = dsBrowse then
    MainDm.mtLin.Edit;
  // Kun valider hvis vi kommer fra indikation
  if buVidere.Tag = 2 then
  begin
    // Interaktionscheck
    if MainDm.mtEksKundeType.AsInteger = pt_Enkeltperson then
      InteraktionsCheck(MainDm.mtLinSubVareNr.AsString, MainDm.mtLinTekst.AsString, MainDm.mtLinATCKode.AsString);
    if CheckOrdination then
      buGem.Enabled := True;
  end
  else
    buGem.Enabled := True;

  if (MainDm.mtEksReceptStatus.Value = 2) and (MainDm.mtRei.RecordCount = 0) then
  begin
    paLager.Color := clLime;
    paLager.Caption := 'Klar til afslutning [F6]';
    TakserEHAutotEnter := False;
  end;

end;

procedure THumanForm.buVidereExit(Sender: TObject);
begin
//    // if we exit the nyline button without clicking then cancel autoenter
//
//    if not NyLineClicked then
//    begin
//      TakserEHAutotEnter := False;
//    end;

  buGem.Enabled := False;
  buVidere.Tag := 0;
end;

procedure THumanForm.buVidereClick(Sender: TObject);
begin
  c2logadd('Ny linie clicked');
  NyLineClicked := True;
  if MainDm.mtEksEkspType.AsInteger = et_Haandkoeb then
    MainDm.mtLinLinieType.AsInteger := lt_Handkoeb;

  // Kun check ved kontrol med indikation
  if buVidere.Tag = 2 then
  begin
    if CheckOrdination then
      NyLinie;
  end;

 // reset taksering copy of autoenter back to that from maindm

  TakserEHAutotEnter := MainDm.EHAutoEnter;
  // if there are no more lines in the order then disable autoenter for the rest
  // of taksering
  if OrderComplete then
    TakserEHAutotEnter := False;


  (* Erstatter buVidereExit *)
  buGem.Enabled := False;
  buVidere.Tag := 0;
  (* Erstatter buVidereExit *)
  SelectNext(ActiveControl, True, True);
  if MainDm.mtEksKundeType.AsInteger = pt_Hobbydyr then
  begin
    EVare.SetFocus;
    exit;
  end;

  // if the line type is not håndkøb then then disable autoenter for this line
  if MainDm.mtLinLinieType.AsInteger <> lt_Handkoeb then
    TakserEHAutotEnter := False;

  if (MainDm.EHordre) and TakserEHAutotEnter then
  begin
    if (EVare.Text <> '') or (MainDm.mtrei.RecordCount=0) then
    begin
      EVare.SetFocus;

      // cr := #13;
      // HumanForm.FormKeyPress(Sender,cr);
      // EAntal.SetFocus;
      // cr := #13;
      // HumanForm.FormKeyPress(Sender,cr);
      // EMax.SetFocus;
      // cr := #13;
      // HumanForm.FormKeyPress(Sender,cr);
      // EUdlev.SetFocus;
      // cr := #13;
      // HumanForm.FormKeyPress(Sender,cr);
    end;
    if MainDm.mtRei.RecordCount <> 0 then
    begin
      // buVidereClick(Sender);
    end
    else
    begin
//        buGemClick(Sender);
    end;
    exit;
  end;

  if MainDm.TakserAutoEnter then
  begin
    if (MainDm.mtEksKundeType.AsInteger <> pt_Hobbydyr) and (MainDm.mtEksKundeType.AsInteger <> pt_Landmand) then
      EVare.SetFocus;
  end;
end;

procedure THumanForm.buVidereKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key <> VK_F6) then
    exit;
  if ((Shift = []) or (Shift = [ssShift]) or (Shift = [ssCtrl]) or ((ssShift in Shift) and (ssCtrl in Shift))) then
  begin
    Key := 0;
    if not CheckOrdination then
      exit;
    CloseF6 := True;
    // Trykket på SF6 eller dosispakning
    if (Shift = [ssShift]) or (MainDm.mtEksEkspType.Value = et_Dosispakning) then
      CloseSF6 := True;
    // To etiketter
    if Shift = [ssCtrl] then
      CloseCF6 := True;
    // Gem
    if (ssShift in Shift) and (ssCtrl in Shift) then
      CloseCSF6 := True;

    buGem.Click;
  end;
end;

procedure YdLst;
begin
  try
    MainDm.ffYdLst.FindKey([MainDm.mtEksYderNr.AsString]);
  except
  end;
  if ShowYdLst('YderNr', MainDm.dsYdLst, MainDm.ffYdLst) then
  begin
    MainDm.mtEksYderNr.AsString := MainDm.ffYdLstYderNr.AsString;
    MainDm.mtEksYderCprNr.AsString := MainDm.ffYdLstCprNr.AsString;
    MainDm.mtEksYderNavn.AsString := MainDm.ffYdLstNavn.AsString;
  end;
  HumanForm.FillYderCpr;
  HumanForm.eYderCPRNr.SetFocus;
end;

procedure YdCprLst;
begin
  if ShowYdLst('CprNr', MainDm.dsYdLst, MainDm.ffYdLst) then
  begin
    // mtEksYderCprNr.AsString := ffYdLstCprNr.AsString;
    MainDm.mtEksYderNavn.AsString := MainDm.ffYdLstNavn.AsString;
  end;
end;

(*
  procedure DeLst;
  begin with HumanForm, MainDm do begin
  mtEksDebitorNr.AsString := ShowDeLst ('KontoNr', mtEksDebitorNr.AsString);
  end; end;
*)
procedure meEtk2mtLin;
var
  W: Word;
  str1: string;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    MainDm.mtLinEtkLin.Value := 0;
    for W := 1 to 10 do
    begin
      MainDm.mtLinEtkLin.Value := MainDm.mtLinEtkLin.Value + 1;
      MainDm.mtLin.FieldByName('Etk' + IntToStr(W)).AsString := '';
      if HumanForm.meEtiketter.Lines.Count >= W then
        MainDm.mtLin.FieldByName('Etk' + IntToStr(W)).AsString := HumanForm.meEtiketter.Lines[W - 1];
    end;
    for str1 in HumanForm.meEtiketter.Lines do
      sl.Add(str1);

    try
      MainDm.mtlinEtkMemo.AsString := sl.Text;
      // MainDm.mtlinEtkMemo.Assign(meEtiketter.Lines);
    except
      on E: Exception do
        Application.MessageBox(pchar(E.Message), 'erm');
    end;
  finally
    sl.Free;
  end;
end;

procedure mtLin2meEtk;
begin
  HumanForm.meEtiketter.Clear;
  HumanForm.meEtiketter.Lines.Assign(MainDm.mtlinEtkMemo);
  HumanForm.SaveEtiket.Text := HumanForm.meEtiketter.Lines.Text;
  // for W := 1 to mtLinEtkLin.Value do
  // meEtiketter.Lines.Add (mtLin.FieldByName ('Etk' + IntToStr (W)).AsString);
end;

procedure THumanForm.CheckEtiket;
var
  i, J: Integer;
  foundline: boolean;
begin
  if SaveEtiket.Count <= 1 then
    exit;
  foundline := False;
  for i := 1 to SaveEtiket.Count - 1 do
  begin
    foundline := False;
    for J := 1 to meEtiketter.Lines.Count - 1 do
    begin
      if CAPS(SaveEtiket.Strings[i]) = CAPS(meEtiketter.Lines[J]) then
      begin
        foundline := True;
        break;
      end;

    end;
    if not foundline then
      break;
  end;
  if not foundline then
  begin
    c2logadd('     ***   Etiket has changed ***');
    c2logadd(SaveEtiket.Text);
    c2logadd('============================================');
    c2logadd(meEtiketter.Lines.Text);
    ChkBoxOk('Der er et problem med doseringsetiketterne.' + sLineBreak +
      'Luk ekspeditionen og start forfra.');
    ModalResult := mrCancel;
    EtiketWarn := True;
  end;

end;

function THumanForm.CheckInSameSubstGtoup(AOrdineretVarenr, ASubVareNr: string): boolean;
var
  LQuery : TnxQuery;
begin
  Result := False;
  LQuery := MainDm.nxdb.OpenQuery('select ' + fnLagerSubstListeVarenr + ' from ' + tnLagerSubstListe+
        ' where ' + fnLagerSubstListeVarenr_P + ' and '+ fnLagerSubstListeSubNr_P,
          [AOrdineretVarenr,ASubVareNr]);
  try
    Result := not LQuery.IsEmpty;
  finally
    LQuery.Free;
  end;

end;



function THumanForm.CheckOrdination: boolean;
var
  Bel: Currency;
  VareForSale: boolean;
begin
  Result := True;
  // Check modulus 11 på journalnr
  if  MainDm.mtLinChkJrnlNr1.AsBoolean then
  begin
    if Date < EncodeDate(2018, 1, 1) then
    begin
      if not CheckJrnlNr( MainDm.mtLinJournalNr1.AsString) then
      begin
        ChkBoxOk('Journalnr1 har modulus 11 fejl !');
        Result := False;
        EVare.SetFocus;
        exit;
      end;
    end
    else
    begin
      if Length(Trim( MainDm.mtLinJournalNr1.AsString)) <> 10 then
      begin
        ChkBoxOk('Journalnummer skal bestå af 10 karakterer');
        Result := False;
        EVare.SetFocus;
        exit;
      end;

    end;
  end;
  if  MainDm.mtLinChkJrnlNr2.AsBoolean then
  begin
    if Date < EncodeDate(2018, 1, 1) then
    begin
      if not CheckJrnlNr( MainDm.mtLinJournalNr2.AsString) then
      begin
        ChkBoxOk('Journalnr2 har modulus 11 fejl !');
        Result := False;
        EVare.SetFocus;
        exit;
      end;
    end
    else
    begin
      if Length(Trim( MainDm.mtLinJournalNr2.AsString)) <> 10 then
      begin
        ChkBoxOk('Journalnummer skal bestå af 10 karakterer');
        Result := False;
        EVare.SetFocus;
        exit;
      end;

    end;
  end;
  if  MainDm.mtLinLinieType.AsInteger <> lt_Handkoeb then
    if not EtiketFieldEntered then
      CheckEtiket;
  // Check håndkøb
  if  MainDm.mtLinLinieType.Value = lt_Handkoeb then
  begin
    VareForSale := False;
    if (Pos('HA',  MainDm.mtLinUdlevType.AsString) <> 0) then
      VareForSale := True;
    if (Pos('HV',  MainDm.mtLinUdlevType.AsString) <> 0) then
      VareForSale := True;
    if (Pos('HF',  MainDm.mtLinUdlevType.AsString) <> 0) then
      VareForSale := True;
    if (Pos('HP',  MainDm.mtLinUdlevType.AsString) <> 0) then
      VareForSale := True;
    if (Pos('HPK',  MainDm.mtLinUdlevType.AsString) <> 0) then
      VareForSale := True;

    if MainDm.mtLinVareType.AsInteger in [2, 8, 9, 10, 11, 12] then
      VareForSale := True;

    if not VareForSale then
    begin
      ChkBoxOk('Vare er IKKE håndkøbsvare !');
      Result := False;
      lcbLinTyp.SetFocus;
      exit;
    end;
  end;


  if StamForm.UdlBegrKunTilSygehus then
  begin
    if ( MainDm.mtLinUdlevType.AsString = 'BEGR') and ( MainDm.mtLinATCKode.AsString  <> 'J01FA10') then
    begin
      if  MainDm.mtEksKundeType.AsInteger <> pt_Sygehus then
      begin
        ChkBoxOk('NB ! Udlevering BEGR må kun sælges til sygehuse.');
        Result := False;
        EVare.SetFocus;
        exit;
      end;
    end;
  end;

  // Check antal
  if ( MainDm.mtLinAntal.Value < 1) or ( MainDm.mtLinAntal.Value > 99) then
  begin
    ChkBoxOk('Antal pakninger skal være mellem 1 - 99 !');
    Result := False;
    EAntal.SetFocus;
    exit;
  end;
  if  MainDm.mtLinTilskSyg.AsCurrency > 999999.99 then
  begin
    ChkBoxOk('sygesikringsbeløb må ikke være større end 999.999,99');
    Result := False;
    EAntal.SetFocus;
    exit;
  end;
  // Check max udleveringer
  if ( MainDm.mtLinUdlevMax.Value < 0) or ( MainDm.mtLinUdlevMax.Value > 99) then
  begin
    ChkBoxOk('Max. udleveringer skal være mellem 0 - 99 !');
    Result := False;
    EMax.SetFocus;
    exit;
  end;
  // Check udleveringsnr
  if  MainDm.mtLinUdlevMax.Value > 0 then
  begin
    if ( MainDm.mtLinUdlevNr.Value < 1) or ( MainDm.mtLinUdlevNr.Value > 99) then
    begin
      ChkBoxOk('Udleveringsnr skal være mellem 1 - 99 !');
      Result := False;
      EUdlev.SetFocus;
      exit;
    end;
  end
  else
    MainDm.mtLinUdlevNr.Value := 1;
  // Check varenr
  if MainDm.mtLinVareNr.AsString = '' then
  begin
    ChkBoxOk('Varenr skal indtastes !');
    Result := False;
    EVare.SetFocus;
    exit;
  end;

  if MainDm.mtLinSubVareNr.AsString <> '' then
  begin
    if MainDm.ffPatKarEjSubstitution.AsBoolean then
    begin
      if MainDm.mtLinSubVareNr.AsString <>  MainDm.mtLinVareNr.AsString then
      begin
        ChkBoxOk('Patient ønsker IKKE substitution !');
        Result := False;
        EVare.SetFocus;
        exit;
      end;
       MainDm.mtLinEjS.AsBoolean := True;
       MainDm.mtLinSubstValg.Value := 2;
    end;
  end
  else
    MainDm.mtLinSubVareNr.AsString := MainDm.mtLinVareNr.AsString;

  // if StamForm.EHOrdre then
  // begin
  // if OriginalVarenr<> '' then
  // begin
  // mtLinSubstValg.AsInteger := 2;
  // mtLinEjS.AsBoolean := True;
  // end;
  // end;
  //
  // Check pris = alle tilskud + patientandel
  Bel := 0;
  Bel := Bel + MainDm.mtLinTilskSyg.AsCurrency;
  Bel := Bel + MainDm.mtLinTilskKom1.AsCurrency;
  Bel := Bel + MainDm.mtLinTilskKom2.AsCurrency;
  Bel := Bel + MainDm.mtLinAndel.AsCurrency;
  if MainDm.mtEksEkspType.AsInteger <> et_Dosispakning then
  begin
    if Bel <> MainDm.mtLinBrutto.AsCurrency then
    begin
      ChkBoxOk('Pris <> tilskud og patientandel !');
      Result := False;
      EVare.SetFocus;
      exit;
    end;
  end;
  // Check substitution
  if MainDm.mtLinSubstValg.Value = 9 then
  begin
    ChkBoxOk('Mangler evt. subst. fravalg !');
    Result := False;
    cbSubst.SetFocus;
    exit;
  end;
  // Opdater Ctr saldo på linie og lokalt
  if MainDm.mtEksOrdreType.Value = 2 then
    MainDm.mtLinNySaldo.AsCurrency := MainDm.mtLinGlSaldo.AsCurrency - MainDm.mtLinBGPBel.AsCurrency
  else
    MainDm.mtLinNySaldo.AsCurrency := MainDm.mtLinGlSaldo.AsCurrency + MainDm.mtLinBGPBel.AsCurrency;
  // onlæy update the header ny ctrsaldo
{ TODO : ctr calculation problem }
//    if not mtLinValideret.AsBoolean then
//    begin
//      // check if product is cannabis, if so then update the header CTR Saldo for B
//      c2logadd('about to update the ny ctr saldo with ' +
//        mtLinNySaldo.AsString);
//
//      if CTRBOrdination then
//        mtEksNyCtrSaldoB.AsCurrency := mtLinNySaldo.AsCurrency
//      else
//        mtEksNyCtrSaldo.AsCurrency := mtLinNySaldo.AsCurrency;
//    end;

  // Gem etiket
  if not MainDm.mtLinValideret.AsBoolean then
  begin
    if (MainDm.mtLinLinieType.Value = lt_Recept) or (MainDm.mtLinEtkLin.Value = 1) then
    begin
      // Kun receptlinier eller om ønsket
      meEtk2mtLin;
    end;
  end;

  MainDm.mtLinValideret.AsBoolean := True;
end;

procedure THumanForm.CMDialogKey(var AMessage: TCMDialogKey);
begin
  if AMessage.CharCode = VK_TAB then
  begin
    c2logadd('TAB key has been pressed in ' + ActiveControl.Name);
    if GetKeyState(VK_SHIFT) < 0 then
    begin
      inherited;
      exit;
    end;
    AMessage.Result := 1;
  end
  else
    inherited;
end;

function THumanForm.GetRegionName(ARegionNumber: integer): string;
begin
  if MainDm.ffInLst.FindKey([ARegionNumber]) then
    Result := MainDm.ffInLstNavn.AsString
  else
    Result := '';


end;


procedure THumanForm.buGemClick(Sender: TObject);
var
  i: Integer;
  AP4line: boolean;
  ilen: Integer;
  LBlankTekstQuestion : boolean;
  LReplaceBlankTekst : boolean;
  LDostekst : string;
  lIndTekst : string;
  function CheckCanOrdinate: boolean;
  var
    sl: TStringList;
    AutNr: string;
    CprNr: string;
    CheckNeeded: boolean;
    BlankATCList: TStringList;
  begin
    Result := True;
    sl := TStringList.Create;
    BlankATCList := TStringList.Create;
    try
      if AllHKlines then
        exit;

      CheckNeeded := False;
      MainDm.mtLin.First;
      while not MainDm.mtLin.Eof do
      begin
        // recept lines only and only those not from receptserver and not mæerkevare
        if (MainDm.mtLinLinieType.AsInteger = lt_Recept) and (MainDm.mtLinOrdId.AsString = '') and
          (not(MainDm.mtLinVareType.AsInteger in [2, 3, 8, 9, 10, 11, 12])) and
          (MainDm.mtLinSubVareNr.AsString <> '100015') then // udligning varenr
        begin
          CheckNeeded := True;
          break;
        end;
        MainDm.mtLin.Next;
      end;

      // no need to check so just get out and do not blank the authorisation number

      if not CheckNeeded then
      begin
//          mtEksYderCprNr.AsString := '';
        exit;
      end;


      // get the authoriastion number, must not be blank now

      if Trim(MainDm.mtEksYderCprNr.AsString) = '' then
      begin
        ChkBoxOk('Ekspeditionen kan ikke afsluttes uden autorisationsnummer');
        Result := False;
        exit;
      end;

      if Length(MainDm.mtEksYderCprNr.AsString) = 10 then
        CprNr := Trim(MainDm.mtEksYderCprNr.AsString)
      else
        AutNr := Trim(MainDm.mtEksYderCprNr.AsString);

      with TC2BegrOrdinationsretInfo.Create(MainDm.Nxdb, CprNr, AutNr) do
      begin
        try

          // error getting details so get out
          if not IsObjectValid then
          begin
            ChkBoxOk('Autorisationsnummeret kan ikke valideres' + sLineBreak + sLineBreak  + 'Kontakt Cito IT');
            Result := False;
            exit;
          end;

          // docotor is not authorise at all, so get out
          if not HasAutorisation then
          begin
            ChkBoxOk('Lægen har ikke autorisation til at ordinere lægemidler'
              + sLineBreak + sLineBreak +
              'Ændr autorisationskode eller luk ekspeditionen');

            Result := False;
            exit;
          end;

          // run down the lines on the prescription, if we are here
          // there must be at least 1 that needs validating.
          MainDm.mtLin.First;
          while not MainDm.mtLin.Eof do
          begin
            // recept lines only and only those not from receptserver
            if (MainDm.mtLinLinieType.AsInteger = lt_Recept) and (MainDm.mtLinOrdId.AsString = '')
              and (not(MainDm.mtLinVareType.AsInteger in [2, 3, 8, 9, 10, 11, 12]))
              and (MainDm.mtLinSubVareNr.AsString <> '100015') then
            // udligning varenr
            begin
              if MainDm.mtLinATCKode.AsString = '' then
                BlankATCList.Add(MainDm.mtLinSubVareNr.AsString + ' ' + MainDm.mtLinTekst.AsString);

              if not CanOrdinate(MainDm.mtLinATCKode.AsString) then
                sl.Add(MainDm.mtLinSubVareNr.AsString + ' ' + MainDm.mtLinTekst.AsString + ' ' +
                MainDm.mtLinATCKode.AsString);

            end;
            MainDm.mtLin.Next;
          end;

        finally
          Free;
        end;

      end;
      // if we have anything in the stringlist then popup at screen
      if sl.Count <> 0 then
      begin
        if sl.Count = 1 then
          ChkBoxOk('Lægen er frataget ordinationsret på følgende produkt' +
            sLineBreak  + sLineBreak + sl.Text + sLineBreak + sLineBreak +
            'Ændr autorisationskode eller luk ekspeditionen')
        else
          ChkBoxOk('Lægen er frataget ordinationsret på følgende produkter' +
            sLineBreak + sLineBreak + sl.Text + sLineBreak + sLineBreak +
            'Ændr autorisationskode eller luk ekspeditionen');

        Result := False;
        exit;
      end;

      if BlankATCList.Count <> 0 then
      begin
        if BlankATCList.Count = 1 then
        begin
          if not frmYesNo.NewYesNoBox
            ('Da ATC kode på følgende produkt er blankt,' + sLineBreak +
            'kan tjek på begrænset autorisationsret ikke foretages' +
            sLineBreak + sLineBreak + BlankATCList.Text + sLineBreak + sLineBreak +
            'Ønsker du at afslutte ekspeditionen alligevel?') then
            Result := False;

        end
        else
        begin
          if not frmYesNo.NewYesNoBox
            ('Da ATC kode på følgende produkter er blanke,' + sLineBreak +
            'kan tjek på begrænset autorisationsret ikke foretages' +
            sLineBreak + sLineBreak + BlankATCList.Text + sLineBreak + sLineBreak +
            'Ønsker du at afslutte ekspeditionen alligevel?') then
            Result := False;

        end;
      end;

    finally
      sl.Free;
      BlankATCList.Free;
    end;
  end;

  procedure ReturnUnusedOrdinations;
  var
    sl: TStringList;
    Found: boolean;
    i: Integer;
    saveRSEkspLinIndex: string;
  begin

    sl := TStringList.Create;
    try

      // loop down edircp (if set looking for ordinationid) if not found then remove status from it.
      // must have been deleted (skipped) during ekspedition

      if EdiRcp <> Nil then
      begin

        for i := 1 to EdiRcp.OrdAnt do
        begin

          if EdiRcp.Ord[i].OrdId <> '' then
          begin
            Found := False;
            MainDm.mtLin.First;
            while not MainDm.mtLin.Eof do
            begin
              if MainDm.mtLinOrdId.AsString = EdiRcp.Ord[i].OrdId then
              begin
                Found := True;
                break;
              end;
              MainDm.mtLin.Next;
            end;

          end;

          // ordid not found so remove status on it
          if not Found then
          begin
            saveRSEkspLinIndex := MainDm.nxRSEkspLin.IndexName;
            MainDm.nxRSEkspLin.IndexName := 'OrdIdOrden';
            try
              if MainDm.nxRSEkspLin.FindKey([EdiRcp.Ord[i].OrdId,EdiRcp.Ord[i].ReceptId]) then
              begin
                // somewhere else has taksered this ordination on this receptid
                // so skip
                if MainDm.nxRSEkspLinRSLbnr.AsInteger <> 0 then
                  continue;

                if MainDm.KeepReceptLokalt then
                begin
                  if ufmkcalls.FMKRemoveStatus(MainDm.AfdNr,
                     MainDm.ffPatUpdKundeNr.AsString,
                     { TODO : 03-06-2021/MA: Replace with real PersonIdSource }
                     TFMKPersonIdentifierSource.DetectSource(MainDm.ffPatUpdKundeNr.AsString),
                     MainDm.nxRSEkspLinReceptId.AsInteger,
                     StrToInt64( MainDm.nxRSEkspLinOrdId.AsString),
                     MainDm.nxRSEkspLinAdministrationId.AsLargeInt) then
                  begin
                    C2LogAdd('remove status on Administration successful');
                  end;
                end
                else
                begin
                  if ufmkcalls.FMKRemoveStatus(MainDm.AfdNr,
                     MainDm.ffPatUpdKundeNr.AsString,
                     { TODO : 03-06-2021/MA: Replace with real PersonIdSource }
                     TFMKPersonIdentifierSource.DetectSource(MainDm.ffPatUpdKundeNr.AsString),
                     MainDm.nxRSEkspLinReceptId.AsInteger,
                     StrToInt64( MainDm.nxRSEkspLinOrdId.AsString),
                     MainDm.nxRSEkspLinAdministrationId.AsLargeInt,MainDm.nxdb) then
                  begin
                    C2LogAdd('remove status on Administration successful');
                  end;
                end;
              end;
            finally
              MainDm.nxRSEkspLin.IndexName := saveRSEkspLinIndex;
            end;

          end;
        end;

      end;

    except
      on E: Exception do
      begin
        c2logadd('Exception in ReturnUnusedOrdinations ' + E.Message);
      end;

    end;

    sl.Free;
  end;

  function CheckLokalRSLines: boolean;
  var
    saveRSEkspLinIndex: string;
  begin
    c2logadd('top of checklokalrslines');
    Result := True;
    saveRSEkspLinIndex := MainDm.nxRSEkspLin.IndexName;
    MainDm.nxRSEkspLin.IndexName := 'OrdIdOrden';
    try
      MainDm.mtLin.First;
      while not MainDm.mtLin.Eof do
      begin
        c2logadd('mtliniordid is ' + MainDm.mtLinOrdId.AsString + ' receptid is ' + MainDm.mtLinReceptId.AsString);
        if not MainDm.mtLinOrdId.AsString.IsEmpty then
        begin
          if not MainDm.nxRSEkspLin.FindKey([MainDm.mtLinOrdId.AsString, MainDm.mtLinReceptId.AsInteger]) then
          begin
            Result := False;
            exit;
          end;
          c2logadd('if we get here then we found the ordination');

        end;

        MainDm.mtLin.Next;
      end;
    finally
      MainDm.nxRSEkspLin.IndexName := saveRSEkspLinIndex;
      c2logadd('result from checklokalslines is ' + Result.ToString);
    end;

  end;

  procedure RebuildEtiket;
  var
    i : integer;
  begin
    // first delete all but the first line
    for i:= meEtiketter.lines.Count -1 downto 1 do
    begin
      meEtiketter.Lines.Delete(i);
    end;

    if MainDm.mtLinDosering1.AsString <> 'IKKE ANGIVET' then
      meEtiketter.Lines.Add(AnsiUpperCase(MainDm.mtLinDosering1.AsString));
    if MainDm.mtLinDosering2.AsString <> '' then
      meEtiketter.Lines.Add(AnsiUpperCase(MainDm.mtLinDosering2.AsString));
    if MainDm.mtLinIndikation.AsString <> 'IKKE ANGIVET' then
      meEtiketter.Lines.Add(AnsiUpperCase(MainDm.mtLinIndikation.AsString));

    MainDm.mtLinEtkMemo.AsString := meEtiketter.Lines.Text;
  end;

begin
  c2logadd('F6:F6 pressed');
  if not buGem.Enabled then
    exit;
  C2LogAddF('Autid %s Id %s Type %d Drugid %s Opbevkode %s', [MainDm.mtLinUdstederAutid.AsString,MainDm.mtLinUdstederId.asstring,
    MainDm.mtLinUdstederType.asinteger,MainDm.mtLinDrugid.asstring,MainDm.mtLinOpbevKode.asstring]);

  c2logadd('F6:Check repeat prescription lines all complete');
  try
    IF not MainDm.mtRei.IsEmpty then
    begin
      if not ChkBoxYesNo('Der er flere ordinationer på recepten. Ønsker du at afslutte ?', False) then
      begin
        CloseCF6 := False;
        CloseSF6 := False;
        CloseF6 := False;
        exit;
      end;
    end;
  except
  end;
  if MainDm.mtLin.State <> dsBrowse then
  begin
    MainDm.mtLinHeaderCTRUpdated.AsBoolean := True;
    MainDm.mtLin.Post;


    // update the ekspeditioner header ny ctr values
    // check if product is cannabis, if so then update the header CTR Saldo for B


    // if the product was udlgning then use glsaldo

    if MainDm.mtLinSubVareNr.AsString = '100015' then
    begin
//        c2logadd('about to update the gl ctr saldo with ' +
//          mtLinGlSaldo.AsString);
//        mtEksGlCtrSaldo.AsCurrency := mtLinGlSaldo.AsCurrency;
//
//
    end
    else
    begin
        // not udligning so use ny saldo
      c2logadd('about to update the ny ctr saldo with ' + MainDm.mtLinNySaldo.AsString);
      if CTRBOrdination then
        MainDm.mtEksNyCtrSaldoB.AsCurrency := MainDm.mtLinNySaldo.AsCurrency
      else
        MainDm.mtEksNyCtrSaldo.AsCurrency := MainDm.mtLinNySaldo.AsCurrency;
    end;
  end;
  // if the last line posted was not valid  then get out.....
  if not MainDm.mtLinValideret.AsBoolean then
  begin
    ModalResult := mrCancel;
    ForceClose := True;
    exit;
  end;

  MainDm.mtLin.DisableControls;
  try
    c2logadd('F6:check all lines have been validated');
    MainDm.mtLin.First;
    while not MainDm.mtLin.Eof do
    begin
      if MainDm.mtLinVareNr.AsString = '' then
      begin
        ChkBoxOk('Varenr mangler. Luk ekspeditionen og ekspeder forfra.');
        EVare.SetFocus;
        exit;
      end;
      if MainDm.mtLinPris.AsCurrency <> 0 then
      begin
        if (MainDm.mtLinBGPBel.AsCurrency = 0) and (MainDm.mtLinIBPBel.AsCurrency = 0) and
          (MainDm.ffPatKarEjCtrReg.AsBoolean = False) and
          (MainDm.mtLinRegelSyg.AsInteger in [41 .. 43]) then
        begin
          ChkBoxOk('CTR BGP mangler. Luk ekspeditionen og ekspeder forfra.');
          EVare.SetFocus;
          exit;
        end;
      end;
      if not MainDm.mtLinValideret.AsBoolean then
        MainDm.mtLin.Delete
      else
        MainDm.mtLin.Next;
    end;

    if (MainDm.mtEksKundeType.AsInteger in [pt_Enkeltperson]) and (not UdlignOrdination) then
    begin

      // now checkif there are any blank indikations or doserings tekst
      LBlankTekstQuestion := False;
      LReplaceBlankTekst := True;
      MainDm.mtlin.First;
      while not MainDm.mtlin.eof do
      begin
        if (MainDm.mtLinLinieType.AsInteger = lt_Recept) and (MainDm.mtEksEkspType.AsInteger = et_Recepter) then
        begin

          // skip udligning varenr
          if MainDm.mtLinSubVareNr.AsString = '100015' then
          begin
            MainDm.mtLin.Next;
            continue;
          end;
//    1 : Result:= 'Specialitet';
//    2 : Result:= 'Mærkevare';
//    3 : Result:= 'Råvare';
//    4 : Result:= 'Narkospecialitet';
//    5 : Result:= 'Håndkøbsspecialitet';
//    6 : Result:= 'Magistrelt lægemiddel';
//    7 : Result:= 'Veterinær specialitet';
//    8 : Result:= 'Gebyr';
//    9 : Result:= 'Anden vare';
//    10: Result:= 'Omsætningsfri';
//    11: Result:= 'Serviceydelse';
//    12: Result:= 'Udbringningsgebyr';
//    99: Result:= 'DisplayVare';
//
          if MainDm.mtLinVareType.AsInteger in [3,8,9,10,11,12,99] then
          begin
            MainDm.mtlin.Next;
            Continue;
          end;




          if (MainDm.mtLinIndikation.AsString = '') or (MainDm.mtLinDosering1.AsString = '') then
          begin
            if not LBlankTekstQuestion then
            begin
              LBlankTekstQuestion := True;
              LReplaceBlankTekst:= ChkBoxYesNo('Dosering og/eller indikation vil blive sendt til FMK som IKKE ANGIVET?',False);


            end;

            if LReplaceBlankTekst then
            begin
              MainDm.mtLin.Edit;
              if MainDm.mtLinIndikation.AsString = '' then
                MainDm.mtLinIndikation.AsString := 'IKKE ANGIVET';
              if MainDm.mtLinDosering1.AsString = '' then
                MainDm.mtLinDosering1.AsString := 'IKKE ANGIVET';

              MainDm.mtlin.Post;
            end
            else
            begin
              lIndTekst := MainDm.mtLinIndikation.AsString;
              LDostekst := MainDm.mtLinDosering1.AsString;
              TfrmIndtastTekst.IndtastTekst(MainDm.mtLinTekst.AsString,LDostekst,lIndTekst);
              MainDm.mtLin.Edit;
              MainDm.mtLinIndikation.AsString := lIndTekst;
              MainDm.mtLinDosering1.AsString := LDostekst;
              RebuildEtiket;
              MainDm.mtlin.Post;

            end;

          end;

        end;
        MainDm.mtlin.Next;
      end;

    end;

    MainDm.FejlCF5Ekspedition := False;
    // check to see if all ordinations from receptserver still exist locally
    if not CheckLokalRSLines then
    begin
      frmYesNo.NewOKBox('Ekspeditionen kan ikke afsluttes da' + sLineBreak +
        'ordinationen er slettet i Lokale recepter CF6' + sLineBreak + sLineBreak +
        'Påbegynd ny taksation fra FMK CF5');
      ModalResult := mrCancel;
      ForceClose := True;
      MainDm.FejlCF5Ekspedition := True;
      exit;
    end;

    // Check narkocheck
    c2logadd('F6:Narko check');
    if MainDm.mtEksEkspForm.Value = 4 then
    begin
      MainDm.mtEksNarkoNr.AsString := AnsiUpperCase(MainDm.mtEksNarkoNr.AsString);
      if not CheckNarko(MainDm.mtEksNarkoNr.AsString) then
      begin
        eNarkoNr.SetFocus;
        ChkBoxOk('Fejl i Narkocheck nr !');
        exit; // Afbryd F6 og gå til narkonr felt
      end;
      if (StamForm.Spoerg_YderNr) and (not UdlignOrdination) then
      begin
        if (MainDm.mtEksEkspType.AsInteger = et_Recepter) and (MainDm.mtEksKundeType.AsInteger = pt_Enkeltperson)
          and (MainDm.mtEksEkspForm.AsInteger IN [1, 2]) and (not AskYderNrQuestion)
        then
        begin
          AskYderNrQuestion := True;
          if not ChkBoxYesNo('Er lægens ydernummer korrekt?', False) then
          begin
            eYderNr.Color := clYellow;
            eYderNr.ReadOnly := False;
            eYderNr.TabStop := True;
            eYderNr.SetFocus;
            exit;
          end;
        end;
      end;
    end
    else
    begin
      AllHKlines := True;
      MainDm.mtLin.First;
      while not MainDm.mtLin.Eof do
      begin
        if MainDm.mtLinLinieType.AsInteger <> lt_Handkoeb then
        begin
          AllHKlines := False;
          break;
        end;
        MainDm.mtLin.Next;

      end;
      MainDm.mtLin.Last;

      if (StamForm.Spoerg_YderNr) and (not UdlignOrdination) then
      begin
        if (MainDm.mtEksEkspType.AsInteger = et_Recepter) and (MainDm.mtEksKundeType.AsInteger = pt_Enkeltperson)
          and (MainDm.mtEksEkspForm.AsInteger IN [1, 2]) and (not AskYderNrQuestion) then
        begin
          AskYderNrQuestion := True;
          if not AllHKlines then
          begin
            if not ChkBoxYesNo('Er lægens ydernummer korrekt?', False) then
            begin
              eYderNr.Color := clYellow;
              eYderNr.ReadOnly := False;
              eYderNr.TabStop := True;
              eYderNr.SetFocus;
              exit;
            end;
          end;
        end;
      end;
      c2logadd('F6:Check laege cpr');
      if (StamForm.Spoerg_AutorisationsNr) and (not UdlignOrdination) then
      begin
        C2LogAdd('buGemClick 1');
        if StamForm.SpoergAutorisationsnrKorrekt then
        begin
        C2LogAdd('buGemClick 2');
          if (MainDm.mtEksYderCprNr.AsString <> '') and (MainDm.mtEksEkspForm.AsInteger <> 3) then
          begin
        C2LogAdd('buGemClick 3');
            if MainDm.mtEksEkspType.AsInteger <> et_Dosispakning then
            begin
        C2LogAdd('buGemClick 4');

              if not AllHKlines then
              begin
        C2LogAdd('buGemClick 5');
                if not AskYderCPrNrQuestion then
                begin
        C2LogAdd('buGemClick 6');
                  AskYderCPrNrQuestion := True;
                  if not ChkBoxYesNo('Er lægens autorisationsnummer korrekt?',
                    True) then
                  begin
        C2LogAdd('buGemClick 7');
                    eYderCPRNr.Color := clYellow;
                    eYderCPRNr.ReadOnly := False;
                    eYderCPRNr.TabStop := True;
                    eYderCPRNr.SetFocus;
                    exit;
                  end;
                end;
              end;
            end;
          end;
        end;

        // if (StamForm.TakserDosisKortAuto)  and (stamform.DosisAskQuestions) then xxxx
        C2LogAdd('buGemClick 8');

        if (MainDm.mtEksYderCprNr.AsString = '') and (MainDm.mtEksKundeType.AsInteger = pt_Enkeltperson)
        then
        begin
        C2LogAdd('buGemClick 9');
          if (not AllHKlines) then
          begin
        C2LogAdd('buGemClick 10');
            if ChkBoxYesNo('Skal lægens autorisationsnummer indtastes?', True) then
            begin
        C2LogAdd('buGemClick 11');
              eYderCPRNr.Color := clYellow;
              eYderCPRNr.ReadOnly := False;
              eYderCPRNr.TabStop := True;
              eYderCPRNr.SetFocus;
              exit;
            end;
          end;
        end;
      end;

        C2LogAdd('buGemClick 12');
      // if any lines are ap4 then there must be a cpr number in ydercprnr
      if not (MainDm.mtEksKundeType.AsInteger in [pt_Dyrlaege, // pt_Skibsfoerer_Reder,
        pt_Hobbydyr, pt_Landmand, pt_Andetapotek]) then
      begin
        c2logadd('buGemClick 13');

        if (MainDm.mtEksReceptStatus.AsInteger = 0) and (MainDm.mtEksEkspForm.AsInteger <> 4)
        then
        begin
        C2LogAdd('buGemClick 14');

          AP4line := False;
          MainDm.mtLin.First;
          while not MainDm.mtLin.Eof do
          begin
            if MatchText(MainDm.mtLinUdlevType.AsString, ['AP4', 'AP4NB']) then
            begin
              AP4line := True;
              break;
            end;
            MainDm.mtLin.Next;
          end;
          if AP4line then
          begin
        C2LogAdd('buGemClick 15');

            if MainDm.mtEksYderCprNr.AsString = '' then
            begin
        C2LogAdd('buGemClick 16');

              ChkBoxOk('Lægens cprnr skal registreres.');
              eYderCPRNr.SetFocus;
              exit;
            end;

            if Length(MainDm.mtEksYderCprNr.AsString) <> 10 then
            begin
        C2LogAdd('buGemClick 17');
              eYderCPRNr.SetFocus;
              if not frmYesNo.NewYesNoBox('Lægens cprnr skal registreres.' +
                'Er du sikker på, at du vil registrere denne ekspedition med autorisationsnummeret?')
              then
                exit;
            end;
          end;
        end;
      end;
      // Check lægecpr
      if (MainDm.mtEksEkspType.Value = et_Narkoleverance) or (MainDm.mtEksYdCprChk.AsBoolean) then
      begin
        C2LogAdd('buGemClick 18');

        if Length(MainDm.mtEksYderCprNr.AsString) = 10 then
        begin
        C2LogAdd('buGemClick 19');
          if (MainDm.mtEksYderCprNr.AsString <> '4000000999') and (MainDm.mtEksYderCprNr.AsString <> '4000000103') then
          begin
            if TryStrToInt(copy(MainDm.mtEksYderCprNr.AsString, 1, 1), i) then
            begin
          C2LogAdd('buGemClick 20');
              if i >= 4 then
              begin
          C2LogAdd('buGemClick 21');
                ChkBoxOk('Fejl i Lægens cprnr');
                if eYderCPRNr.Enabled then
                  eYderCPRNr.SetFocus;
                exit;
              end;
            end;
          end;
        end;
        if (MainDm.mtEksYderCprNr.AsString <> '4000000999') and (MainDm.mtEksYderCprNr.AsString <> '4000000103') then
        begin
        C2LogAdd('buGemClick 22');

          if not CheckCprNr(99, MainDm.mtEksYderCprNr.AsString) then
          begin
        C2LogAdd('buGemClick 23');

            if (Length(MainDm.mtEksYderCprNr.AsString) = 10)  and (not MainDm.DisableCPRModulusCheck) then
            begin

        C2LogAdd('buGemClick 24');
              eYderCPRNr.SetFocus;
              ChkBoxOk('Fejl i Lægens cprnr !');
              exit; // Afbryd F6 og gå til cprnr felt
            end
            else
            begin
        C2LogAdd('buGemClick 25');
              if (Length(MainDm.mtEksYderCprNr.AsString) <> 5) then
              begin
        C2LogAdd('buGemClick 26');
                ChkBoxOk('Fejl i Lægens autorisationsnr !');
                eYderCPRNr.SetFocus;
                exit; // Afbryd F6 og gå til cprnr felt
              end;
            end;
          end;
        end;
      end;
    end;
    c2logadd('F6:check ydernr');
    // Check ydernr
    if not AllHKlines then
    begin

      if not CheckYderNr(MainDm.mtEksKundeType.Value, MainDm.mtEksYderNr.AsString) then
      begin
        if eYderNr.Enabled then
          eYderNr.SetFocus;
        ChkBoxOk('Fejl i Lægens ydernr !');
        exit; // Afbryd F6 og gå til ydernr felt
      end;
      c2logadd('F6 : check ydercprnr ' + MainDm.mtEksYderCprNr.AsString);
      MainDm.mtEksYderCprNr.AsString := AnsiUpperCase(MainDm.mtEksYderCprNr.AsString);
      ilen := Length(Trim(MainDm.mtEksYderCprNr.AsString));
      if (MainDm.mtEksYderCprNr.AsString <> '') and (MainDm.mtEksKundeType.AsInteger in [pt_Enkeltperson, pt_Laege]) then
      begin
        c2logadd('length is ' + IntToStr(ilen));
        if NOT(ilen in [5, 10]) then
        begin
          ChkBoxOk('Fejl i Aut.Nr.');
          if eYderCPRNr.Enabled then
            eYderCPRNr.SetFocus;
          exit;
        end;
        if ilen = 5 then
        begin
          for i := 1 to 5 do
          begin
            if Pos(copy(MainDm.mtEksYderCprNr.AsString, i, 1),
              'BCDFGHJKLMNPQRSTVWXYZ0123456789') = 0 THEN
            BEGIN
              ChkBoxOk('Fejl i Aut.Nr. Kun vokalen Y er tilladt.');
              if eYderCPRNr.Enabled then
                eYderCPRNr.SetFocus;
              exit;
            end;
          end;
        end;

        if ilen = 10 then
        begin
          if TryStrToInt(copy(MainDm.mtEksYderCprNr.AsString, 1, 1), i) then
          begin
            if i >= 4 then
            begin
              ChkBoxOk('Fejl i Lægens cprnr.');
              if eYderCPRNr.Enabled then
                eYderCPRNr.SetFocus;
              exit;
            end;
          end;
          if not MainDm.DisableCPRModulusCheck then
          begin
            if not(CheckCprNr(99, Trim(MainDm.mtEksYderCprNr.AsString))) then
            begin
              ChkBoxOk('Fejl i Lægens cprnr.');
              if eYderCPRNr.Enabled then
                eYderCPRNr.SetFocus;
              exit;
            end;
          end;

        end;

      end;

    end;


    if (not AllHKlines) and (MainDm.mtEksYderNavn.AsString = '') and (not UdlignOrdination) then
    begin
      ChkBoxOK('Udsteders navn skal angives ved afslutning af manuelle recepter.');
      eYderNavn.SetFocus;
      exit;
    end;

    if (MainDm.EHOrdre) and (MainDm.EHDibs) then
    begin
      if Trim(MainDm.mtEksDebitorNr.AsString) = '' then
      begin
        eDebitorNr.SetFocus;
        ChkBoxOk('Ehandel er betalt med DIBS,' + sLineBreak +
          'så derfor skal der være et kontonummer af typen Bud' + sLineBreak +
          'for at få en pakkeseddel til at slå på kassen.');
        exit;

      end;
    end;

    if (MainDm.EHOrdre) and not(MainDm.EHDibs) then
    begin
      if Trim(MainDm.mtEksDebitorNr.AsString) = '' then
      begin
        eDebitorNr.SetFocus;
        if ChkBoxYesNo('Ehandel. Skal der kontonummer på?' + sLineBreak +
          'Uden konto, vil kunden ikke få sendt besked.', True) then
          exit;
      end;
    end;
    if not AllHKlines then
    begin
      if StamForm.SpoergOmGemYdernr then
      begin
        if (Trim(MainDm.mtEksYderNr.AsString) <> Trim(MainDm.ffPatKarYderNr.AsString)) or
          (Trim(MainDm.mtEksYderCprNr.AsString) <> Trim(MainDm.ffPatKarYderCprNr.AsString)) then
        begin
          if frmYesNo.NewYesNoBox
            ('Skal Ydernr/Aut.nr gemmes på kundens stamoplysninger ?') then
          begin
            // Gemmes på kunde
            MainDm.ffPatKar.Edit;
            MainDm.ffPatKarYderNr.AsString := Trim(MainDm.mtEksYderNr.AsString);
            MainDm.ffPatKarYderCprNr.AsString := Trim(MainDm.mtEksYderCprNr.AsString);
            MainDm.ffPatKar.Post;
          end;
        end;
      end;
    end;

    // check that the doctor is allowed to prescribe the products
    // patient type must be enkeltperson, læge or tændlæge
    if (MainDm.mtEksEkspType.AsInteger in [et_Recepter, et_Vagtbrugmm, et_Dosispakning]) and
      (MainDm.mtEksKundeType.AsInteger in [pt_Enkeltperson, pt_Laege, pt_Tandlaege]) then
    begin
      if not CheckCanOrdinate then
      begin
        eYderCPRNr.SetFocus;
        exit;
      end;
    end;

    c2logadd('F6:check debitor');
    // Check Debitor
    if Trim(MainDm.mtEksDebitorNr.AsString) <> '' then
    begin
      // Findes debitor
      if not MainDm.ffDebKar.FindKey([MainDm.mtEksDebitorNr.AsString]) then
      begin
        eDebitorNr.SetFocus;
        ChkBoxOk('Debitorkonto findes ikke i kartotek !');
        exit; // Afbryd F6 og gå til debitor felt
      end;

      if StamForm.SpoergOmGemKontonr then
      begin
        if Trim(MainDm.mtEksDebitorNr.AsString) <> Trim(MainDm.ffPatKarDebitorNr.AsString)
        then
        begin
          if MainDm.EHOrdre then
          begin
            if EdiRcp <> Nil then
            begin
              if EdiRcp.Kontonr = '' then
              begin
                if frmYesNo.NewYesNoBox
                  ('Skal kontonr gemmes på kundens stamoplysninger ?') then
                begin
                  // Gemmes på kunde
                  MainDm.ffPatKar.Edit;
                  MainDm.ffPatKarDebitorNr.AsString := Trim(MainDm.mtEksDebitorNr.AsString);
                  MainDm.ffPatKar.Post;
                end;
              end;
            end;

          end
          else
          begin
            if frmYesNo.NewYesNoBox
              ('Skal kontonr gemmes på kundens stamoplysninger ?') then
            begin
              // Gemmes på kunde
              MainDm.ffPatKar.Edit;
              MainDm.ffPatKarDebitorNr.AsString := Trim(MainDm.mtEksDebitorNr.AsString);
              MainDm.ffPatKar.Post;
            end;
          end;
        end;
      end;

      if (MainDm.EHOrdre) and (MainDm.EHDibs) then
      begin
        if MainDm.ffDebKarLevForm.AsInteger in [4, 5, 6] then
        begin
          eDebitorNr.SelectAll;
          eDebitorNr.SetFocus;
          ChkBoxOk('Konto er til et udsalg. Brug ehandelskonto af typen BUD for at få DIBS betaling.');
          exit;
        end;

      end;

    end;
    c2logadd('F6:Check Eksp levering');
    // Check Levering
    if Trim(MainDm.mtEksLevNr.AsString) <> '' then
    begin
      // Findes levering
      if not MainDm.ffDebKar.FindKey([MainDm.mtEksLevNr.AsString]) then
      begin
        eLevNr.SetFocus;
        ChkBoxOk('Leveringskonto findes ikke i kartotek !');
        exit; // Afbryd F6 og gå til debitor felt
      end;
      c2logadd('F6:check patients levnr');
      // Check patient
      if MainDm.ffPatKarLevNr.AsString = '' then
      begin
        if frmYesNo.NewYesNoBox('Leveringskonto findes ikke på kunde, oprettes ?') then
        begin
          // Gemmes på kunde
          MainDm.ffPatKar.Edit;
          MainDm.ffPatKarLevNr.AsString := Trim(MainDm.mtEksLevNr.AsString);
          MainDm.ffPatKar.Post;
        end;
      end;
    end;

    c2logadd('F6:Check Eksp Kontakt');
    // Check Kontakt
    if Trim(MainDm.mtEksKontakt.AsString) <> '' then
    begin
      // Findes levering
      if not MainDm.ffDebKar.FindKey([MainDm.mtEksKontakt.AsString]) then
      begin
        eDebitorTidl.SetFocus;
        ChkBoxOk('Dette kontonummer findes ikke I Debitorkartoteket og kan derfor ikke gemmes.');
        // Afbryd F6 og gå til debitor felt
      end
      else
      begin
        c2logadd('F6:check patients Kontakt');
        // Check patient
        if MainDm.ffPatKarKontakt.AsString <> MainDm.mtEksKontakt.AsString then
        begin
          if frmYesNo.NewYesNoBox('Kontoen tilhører: ' + MainDm.ffDebKarNavn.AsString
            + sLineBreak +
            'Skal nummeret kundens gemmes på kundens stamoplysninger?' +
            sLineBreak + 'Ja/Nej') then
          begin
            // Gemmes på kunde
            MainDm.ffPatKar.Edit;
            MainDm.ffPatKarKontakt.AsString := Trim(MainDm.mtEksKontakt.AsString);
            MainDm.ffPatKar.Post;
          end;
        end;
      end;

    end
    else
    begin
      c2logadd('F6:check patients Kontakt');
      // Check patient
      if MainDm.ffPatKarKontakt.AsString <> MainDm.mtEksKontakt.AsString then
      begin
        // Gemmes på kunde
        MainDm.ffPatKar.Edit;
        MainDm.ffPatKarKontakt.AsString := Trim(MainDm.mtEksKontakt.AsString);
        MainDm.ffPatKar.Post;
      end;
    end;
    if (MainDm.mtEksTurNr.AsInteger < 0) or (MainDm.mtEksTurNr.AsInteger > 9) then
    begin
      eTurNr.SetFocus;
      ChkBoxOk('Tur-nummer kan ikke være større end 9');
      exit;
    end;

    // loop down edircp (if set looking for ordinationid) if not found then remove status from it.
    // must have been deleted (skipped) during ekspedition

    ReturnUnusedOrdinations;

    if MainDm.mtEksEkspType.AsInteger = et_Dosispakning then
      CloseSF6 := True;
    if (not CloseSF6) or (not CloseCF6) then
      CloseF6 := True;
    c2logadd('F6: about to set modalresult');
    ModalResult := mrok;
  finally
    MainDm.mtLin.EnableControls;
  end;

end;

procedure THumanForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  SearchString: string;
begin
  try
    if Key = VK_F6 then
    begin
      if ActiveControl.Name = 'buVidere' then
        exit;
      if not buGem.Enabled then
        exit;
      Key := 0;
      buVidere.SetFocus;
      PostMessage(buVidere.Handle, wm_KeyDown, VK_F6, 0);
      PostMessage(buVidere.Handle, WM_KEYUP, VK_F6, 0);
      exit;
    end;

    if Shift = [] then
    begin
      case Key of
        VK_F8:
          begin
            c2logadd('    **** F8 pressed ****    ');
            Key := 0;
            if MainDm.mtLinLinieNr.Value > 1 then
            begin
              if MainDm.mtLinValideret.AsBoolean then
              begin
                c2logadd('line was complete');
                if ChkBoxYesNo('Skal linie slettes ?', True) then
                begin
                  // Linie slettes
                  if MainDm.mtLin.State <> dsBrowse then
                    MainDm.mtLin.Post;
                  MainDm.mtLin.Delete;
                  MainDm.mtLin.Edit;
                  mtLin2meEtk;
                  MainDm.mtEksAntLin.Value := MainDm.mtEksAntLin.Value - 1;
                  { TODO : which ctr saldo to update? }
                  MainDm.mtEksNyCtrSaldo.AsCurrency := MainDm.mtLinNySaldo.AsCurrency;
                  buVidere.Tag := 2;
                  buVidere.SetFocus;
                end;
              end
              else
              begin
                c2logadd('line was not complete');
                // Linie slettes ukritisk
                if MainDm.mtLin.State <> dsBrowse then
                  MainDm.mtLin.Cancel
                else
                  MainDm.mtLin.Delete;
                MainDm.mtLin.Edit;
                mtLin2meEtk;
                MainDm.mtEksAntLin.Value := MainDm.mtEksAntLin.Value - 1;
                buVidere.Tag := 2;
                buVidere.SetFocus;
              end;
            end
            else
            begin
              if MainDm.mtLinReitereret.AsBoolean then
              begin
                if ActiveControl.Name <> 'buVidere' then
                begin
                  // Slettes ukritisk ved reitereret
                  try
                    MainDm.mtLin.Cancel;
                    MainDm.mtLin.Delete;
                  except
                  end;
                  MainDm.mtEksAntLin.Value := 0;
                  buVidere.SetFocus;
                end
                else
                  ChkBoxOk('Kan IKKE slette ordination i dette felt !');
              end
              else
              begin
                if ChkBoxYesNo('Kan IKKE slette sidste linie, annuller ?',
                  True) then
                  buLuk.Click
                else
                  ActiveControl.SetFocus;
              end;
            end;
          end;
        VK_UP:
          begin
            if ActiveControl = EVare then
            begin
              if MainDm.mtLinLinieNr.Value > 1 then
                Key := 0
              else
              begin
                Beep;
                Key := 0;
              end;
            end;
          end;
        VK_DOWN:
          begin
            if ActiveControl = EVare then
            begin
              if MainDm.mtLinLinieNr.Value < MainDm.mtLin.RecordCount then
                Key := 0
              else
              begin
                Beep;
                Key := 0;
              end;
            end;
          end;
      end;
      exit;
    end;
    if Shift = [ssAlt] then
    begin
      if Key = VK_DOWN then
      begin
        if ActiveControl = eYderNr then
        begin
          YderList := True;
          YdLst;
          Key := 0;
        end
        else if ActiveControl = eYderCprNr then
        begin
          YderList := True;
          YdCprLst;
          Key := 0;
        end
        else if ActiveControl = eDebitorNr then
        begin
        end
        else
        begin
        end;
      end;
      if UpCase(Chr(Key)) = 'R' then
      begin
        if ChkBoxYesNo('Ønsker du returekspedition?', False) then
        begin
          MainDm.mtEksOrdreType.Value := 2;
          FakTypeExit(Self);
        end;
        Key := 0;
      end;
      if UpCase(Chr(Key)) = 'S' then
      begin
        MainDm.mtEksOrdreType.Value := 1;
        FakTypeExit(Self);
        Key := 0;
      end;
      exit;
    end;
    if Shift = [ssCtrl] then
    begin
      // Ctrl + tast
      if UpCase(Chr(Key)) <> 'S' then
        exit;
      if ActiveControl <> EVare then
        exit;
      SearchString := EVare.Text;
      if not SubstOver(MainDm.Nxdb, MainDm.mtEksLager.Value, SearchString) then
        exit;
      if (SubstForm.VareNrOrg = SubstForm.VareNrSub) then
      begin

        EVare.Text := Trim(SubstForm.VareNrOrg);
        MainDm.mtLinVareNr.AsString := EVare.Text;
        MainDm.mtLinSubVareNr.AsString := EVare.Text;
      end
      else
      begin
        MainDm.mtLinVareNr.AsString := Trim(SubstForm.VareNrOrg);
        MainDm.mtLinSubVareNr.AsString := Trim(SubstForm.VareNrSub);
        EVare.Text := MainDm.mtLinSubVareNr.AsString;
      end;
      IF SubstForm.VareNrAntPkn <> 0 then
      begin
        MainDm.mtLinAntal.AsInteger := SubstForm.VareNrAntPkn;
        if OriginalAntal <> 0 then
          MainDm.mtLinAntal.AsInteger := OriginalAntal * SubstForm.VareNrAntPkn;
      end;
    end;
  finally
    // Key := 0;
  end;
end;

procedure THumanForm.FakTypeExit(Sender: TObject);
begin
  if MainDm.mtEksOrdreType.Value = 1 then
  begin
    laSalgRetur.Caption := '&Retur/Salg';
    lcFakType.Color := clWindow;
    lcFakType.Font.Color := clWindowText;
  end
  else
  begin
    laSalgRetur.Caption := '&Salg/Retur';
    lcFakType.Color := clRed;
    lcFakType.Font.Color := clYellow;
  end;
end;

procedure DanDispFormer(Form: String; var Ental, Flertal: String);
var
  P, Q: Word;
  E, F: String;
begin
  E := Form;
  F := E;
  P := Pos('/', E);
  Q := Pos('*', E);
  if P > 0 then
  begin
    // Flertal
    Delete(F, P, Q - P + 1);
    // Ental
    Delete(E, Q, Length(E) - Q + 1);
    Delete(E, P, 1)
  end
  else
  begin
    // Flertal
    Delete(F, Q, 1);
    Q := Pos('*', F);
    if Q > 0 then
      Q := Pos('*', F);
    // Ental
    P := Pos(' ', E);
    if P > Q then
      Delete(E, Q, P - Q)
    else
      Delete(E, Q, Length(E) - Q + 1);
    Q := Pos('*', E);
    if Q > 0 then
      Delete(E, Q, Length(E) - Q + 1);
  end;
  // Returner
  Ental := E;
  Flertal := F;
end;

procedure THumanForm.FormKeyPress(Sender: TObject; var Key: Char);
var
  Bel: Integer;
  ICnt: Word;
  Ok: boolean;
  WNr: Int64;
  GAPO, WrkS, SNr: String;
  sltmpSort: TStringList;
  LaDisp: Integer;
  VareForSale: boolean;
  LemvigVet: boolean;
  klausCaption: boolean;
  substCaption: boolean;
  tstval: Integer;
  Found: boolean;
  tmppib: PIBVarType;
  OldProductIsCannabis: boolean;
  EditingVarenr: boolean;
  LEvareText : string;

  procedure TabEnter;
  begin
    SelectNext(ActiveControl, True, True);
    Key := #0;
  end;

  procedure Process_Substitution;
  var
    SearchString: string;
  begin
    c2logadd('mtlinsubstvalg is ' + MainDm.mtLinSubstValg.AsString);
    if MainDm.EHOrdre then
    begin
      if MainDm.mtLinSubstValg.AsInteger in [1, 2] then
        exit;
    end;
    SearchString := SNr;
    { TODO : check out linetype }
    if not SubstOver(MainDm.Nxdb, MainDm.mtEksLager.Value, SearchString) then
      exit;
    if (SubstForm.VareNrOrg = SubstForm.VareNrSub) then
    begin
      SNr := Trim(SubstForm.VareNrOrg);
      MainDm.mtLinVareNr.AsString := SNr;
      MainDm.mtLinSubVareNr.AsString := SNr;
      exit;
    end;
    // mtLinSubVareNr.AsString := Trim (TakstForm.VareNrSub);
    // mtLinVareNr.AsString    := Trim (TakstForm.VareNrOrg);
    MainDm.mtLinSubVareNr.AsString := Trim(SubstForm.VareNrSub);
    MainDm.mtLinVareNr.AsString := Trim(SubstForm.VareNrOrg);
    SNr := MainDm.mtLinSubVareNr.AsString;
    IF SubstForm.VareNrAntPkn <> 0 then
    begin
      MainDm.mtLinAntal.AsInteger := SubstForm.VareNrAntPkn;
      if OriginalAntal <> 0 then
        MainDm.mtLinAntal.AsInteger := OriginalAntal * SubstForm.VareNrAntPkn;

      EAntal.Text := IntToStr(MainDm.mtLinAntal.AsInteger);
    end;

  end;

  procedure process_EVare;
  var
    i : integer;
  begin
    LEvareText := EVare.Text;

    klausCaption := Pos(',KLAUS', paInfo.Caption) <> 0;
    substCaption := Pos(',  -S', paInfo.Caption) <> 0;
    // Hent Vareoversigt
    // FillChar (VareRec, SizeOf (VareRec), 0);
    // Ikke reitereret
    if not MainDm.mtLinReitereret.AsBoolean then
    begin
      MainDm.mtLinAntal.Value := 0;
      MainDm.mtLinDosering1.AsString := '';
      MainDm.mtLinDosering2.AsString := '';
      MainDm.mtLinIndikation.AsString := '';
      MainDm.mtLinFolgeTxt.AsString := '';
      meEtiketter.Clear;
      if MainDm.ffPatKarCtrType.AsInteger in [1, 11] then
      begin
        // ChkBoxOK('kundenr is ' + ffPatKarKundeNr.AsString);

        meEtiketter.Lines.Add(AnsiUpperCase(BytNavn(MainDm.ffPatKarNavn.AsString)) +
          ' ' + calcage(MainDm.ffPatKarKundeNr.AsString, MainDm.ffPatKarFoedDato.AsString));
      end
      else
        meEtiketter.Lines.Add(AnsiUpperCase(BytNavn(MainDm.ffPatKarNavn.AsString)));
    end;

    // if editing the varenr field then check wheither its cannabis
    EditingVarenr := False;
    if MainDm.mtLinSubVareNr.AsString <> '' then
    begin
      EditingVarenr := True;
      OldProductIsCannabis := IsCannabisProduct(MainDm.Nxdb,
        MainDm.mtLinLager.AsInteger, MainDm.mtLinSubVareNr.AsString, MainDm.mtLinTekst.AsString,MainDm.mtLinDrugid.AsString);

    end
    else
    begin
      if (MainDm.mtLinVareNr.AsString <> '') and  (MainDm.mtLinVareNr.AsString <> EVare.Text) then
          EditingVarenr := True;

    end;

    MainDm.mtLinVareNr.AsString := '';
    MainDm.mtLinSubVareNr.AsString := '';
    c2logadd('Evare field mtlinsubstvalg is ' + MainDm.mtLinSubstValg.AsString);
    if not MainDm.EHOrdre then
    begin
      MainDm.mtLinSubstValg.Value := 9; // = Ej valgt
      if (MainDm.ffPatKarEjSubstitution.AsBoolean) or (MainDm.Recepturplads = 'DYR') or
          (MainDm.mtLinLinieType.Value <> lt_Recept) then
        MainDm.mtLinSubstValg.Value := 0;
    end;
    // mtLinBGPBel.AsCurrency := 0;
    MainDm.mtLinIBTBel.AsCurrency := 0;
    // this has been moved after we know which vare has been selected to ensure we get the correct
    // ctr value
    // mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency;

    SNr := EVare.Text;
    Vareident := TC2Vareident.Create(mainDM.nxdb,maindm.mtLinLager.AsInteger,SNr,False);
    try
      if VareIdent.Vnr <> '' then
        SNr := Vareident.Vnr;

    finally
      Vareident.Free;
    end;

    if (copy(CAPS(SNr), 1, 1) = 'X') or (not TryStrToInt64(SNr, WNr)) then
    begin
      // Ikke Nr, kald søgning
      if SNr <> '' then
      begin
        HumanForm.Update;

        // Normale pakninger
        // TAKST
        // if TakstOver (SNr) then begin
        TakserEHAutotEnter := False;
        if not SkipReservation then
          Process_Substitution;
        if SkipReservation then
          MainDm.mtLinVareNr.AsString := ReservationOrigVarenr;
      end;
    end
    else
    begin

      Ok := False;
      if SNr <> '' then
      begin
        // Varenr
        MainDm.mtLinVareNr.AsString := SNr;
        MainDm.mtLinSubVareNr.AsString := SNr;
        MainDm.ffLagKar.IndexName := 'NrOrden';
        Ok := MainDm.ffLagKar.FindKey([MainDm.mtEksLager.AsInteger, SNr]);
      end;

      if Ok then
      begin
        GAPO := '';
        if MainDm.ffLagKarSubGrp.AsInteger > 0 then
          GAPO := 'G';
        MainDm.NxLagerSubstListe.IndexName := 'NrOrden';
        if MainDm.NxLagerSubstListe.FindKey([Trim(SNr)]) then
          GAPO := 'G';
        if GAPO <> '' then
        begin
          if not MainDm.ffLagKarSubst.AsBoolean then
            GAPO := '';
          HumanForm.Update;
          if MainDm.mtEksEkspType.Value = et_Dosispakning then
          begin
            // Dosispakning
            MainDm.mtLinVareNr.AsString := Trim(SNr);
            MainDm.mtLinSubVareNr.AsString := Trim(SNr);
          end
          else
          begin
            // Normale pakninger
            // TAKST
            // if TakstOver (SNr) then begin
            if MainDm.EHordre then
              MainDm.mtLinSubVareNr.AsString := Trim (SNr)
            else
            begin

                if not SkipReservation then
                  Process_Substitution;
                if SkipReservation then
                  MainDm.mtLinVareNr.AsString := ReservationOrigVarenr;
            end;
          end;
        end;
      end;
    end;

    // Check lager
    (*
      FillChar (VareRec, SizeOf (VareRec), 0);
      VareRec.Lager := mtEksLager.Value;
      VareRec.Nr    := mtLinSubVareNr.AsString;
      MidClient.HentVare (VareRec);
      // Vare kan evt. oprettes
      if VareRec.Status = 0 then begin
    *)
    MainDm.ffLagKar.IndexName := 'NrOrden';
    c2logadd('10: Stock lager is ' + IntToStr(StamForm.StockLager));

    if not MainDm.ffLagKar.FindKey([StamForm.StockLager, MainDm.mtLinSubVareNr.AsString]) then
    begin
      // Vare findes ikke og skal ikke oprettes
      Beep;
      ChkBoxOk('Vare findes IKKE i lagerkartoteket');
      paLager.Caption := '';
      paInfo.Caption := ' ' + MainDm.mtLinSubVareNr.AsString + ' findes IKKE på lager';
      if save_caption <> '' then
        paInfo.Caption := paInfo.Caption + ' Lægens tekst:' + save_caption;
      MainDm.mtLinVareNr.AsString := '';
      MainDm.mtLinSubVareNr.AsString := '';
      EVare.SetFocus;
      exit;
    end;

    if EditingVarenr then
      MainDm.mtLinVareNr.AsString := MainDm.mtLinSubVareNr.AsString;

    // set the dmvs flag

    MainDm.mtLinDMVS.AsBoolean := MainDm.ffLagKarDMVS.AsInteger <> 0;

    // remove the check on date greater than 01/03/2011

    if MainDm.ffLagKarVareNr.AsString.StartsWith('69') and
      (MainDm.ffLagKarVareType.AsInteger in [1, 4, 5, 6, 7]) and
      (MainDm.ffLagKarIndbNr.AsString = '') then
    begin
      ChkBoxOk('Før denne vare kan ekspederes, skal der tilknyttes et LMS henvisningsvarenummer i Lagerkartoteket.');
      exit;
    end;

    // when we get here we need to make sure tha the correct ctr values are
    // being used subtract bgpbel just in case the user is trying to edit the line
    MainDm.mtLinDrugid.AsString := MainDm.ffLagKarDrugId.AsString;
    if MainDm.mtLinDrugid.AsString.StartsWith( CannabisPrefix ) then
    begin
      if EditingVarenr and (not OldProductIsCannabis) then
      begin
        ChkBoxOk('Ekspeditionslinjen er startet med indberetning til anden CTR Saldo.'
          + sLineBreak + 'Luk ekspeditionen og start forfra.');

        EVare.SetFocus;
        ForceClose := True;
        ModalResult := mrCancel;
        exit;

      end;

      CTRBOrdination := True;
      c2logadd('mteksglctrsaldob ' + CurrToStr(MainDm.mtEksGlCtrSaldoB.AsCurrency));
      c2logadd('mteksnyctrsaldob ' + CurrToStr(MainDm.mtEksNyCtrSaldoB.AsCurrency));
      c2logadd('mtlinglsaldo ' + CurrToStr(MainDm.mtLinGlSaldo.AsCurrency));
      c2logadd('mtlinnysaldo ' + CurrToStr(MainDm.mtLinNySaldo.AsCurrency));
      c2logadd('mtlinbbgpbel ' + CurrToStr(MainDm.mtLinBGPBel.AsCurrency));
      MainDm.mtLinGlSaldo.AsCurrency := MainDm.mtEksNyCtrSaldoB.AsCurrency;
      MainDm.mtLinNySaldo.AsCurrency := MainDm.mtLinGlSaldo.AsCurrency;
      c2logadd('mtlinglsaldo is now ' + CurrToStr(MainDm.mtLinGlSaldo.AsCurrency));
      c2logadd('mtlinnysaldo is now ' + CurrToStr(MainDm.mtLinNySaldo.AsCurrency));
    end
    else
    begin
      if EditingVarenr and OldProductIsCannabis then
      begin
        ChkBoxOk('Ekspeditionslinjen er startet med indberetning til anden CTR Saldo.'
          + sLineBreak + 'Luk ekspeditionen og start forfra.');
        EVare.SetFocus;
        ForceClose := True;
        ModalResult := mrCancel;
        exit;
      end;
      CTRBOrdination := False;
      c2logadd('mteksglctrsaldo ' + CurrToStr(MainDm.mtEksGlCtrSaldo.AsCurrency));
      c2logadd('mteksnyctrsaldo ' + CurrToStr(MainDm.mtEksNyCtrSaldo.AsCurrency));
      c2logadd('mtlinglsaldo ' + CurrToStr(MainDm.mtLinGlSaldo.AsCurrency));
      c2logadd('mtlinnysaldo ' + CurrToStr(MainDm.mtLinNySaldo.AsCurrency));
      c2logadd('mtlinbbgpbel ' + CurrToStr(MainDm.mtLinBGPBel.AsCurrency));
      // maindm.mtLinGlSaldo.AsCurrency := maindm.mtLinNySaldo.AsCurrency - maindm.mtLinBGPBel.AsCurrency;
      MainDm.mtLinGlSaldo.AsCurrency := MainDm.mtEksNyCtrSaldo.AsCurrency;
      MainDm.mtLinNySaldo.AsCurrency := MainDm.mtLinGlSaldo.AsCurrency;
      c2logadd('mtlinglsaldo is now ' + CurrToStr(MainDm.mtLinGlSaldo.AsCurrency));
      c2logadd('mtlinnysaldo is now ' + CurrToStr(MainDm.mtLinNySaldo.AsCurrency));

    end;

    if MainDm.mtEksReceptStatus.AsInteger = 2 then
    begin
      if (MainDm.ffLagKarAtcKode.AsString <> Save_AtcKode) and (Save_AtcKode <> '') then
      begin
        c2logadd('*** ATCKODE has changed popup message displayed ***');
        frmYesNo.NewOKBox('Atc-koden er blevet ændret i forhold til receptordinationen.' + sLineBreak +
          'Er du sikker på at dette er korrekt?' + sLineBreak +
          'Hvis ændringen er rigtig, så kontroller om etiketten skal rettes.');
      end;
    end;

    // check kundetype. if ingen or handkøbsudsalg then warn the user on certain
    // product types
    if MainDm.ffPatKarKundeType.AsInteger in [pt_Ingen, pt_Haandkoebsudsalg] then
    begin
      VareForSale := False;
      if MatchText(MainDm.ffLagKarUdlevType.AsString, ['HF', 'HX', 'HV']) then
        VareForSale := True;

      if (MainDm.ffLagKarVareType.AsInteger = 5) then
      begin
        if(MainDm.ffPatKarKundeType.AsInteger = pt_Ingen) then
          VareForSale := True
        else
        if (MainDm.ffPatKarKundeType.AsInteger = pt_Haandkoebsudsalg) and (MainDm.ffLagKarHaType.AsString <> '') then
          VareForSale := True;
      end;

      if MainDm.ffLagKarVareType.AsInteger in [2, 8, 9] then
        VareForSale := True;

      if not VareForSale then
      begin
        if not ChkBoxYesNo( 'Varen kan normalt ikke sælges til denne kundetype.' + sLineBreak +
                            'Vælg Ja, hvis den alligevel ønskes.', False) then
        begin
          paLager.Caption := '';
          paInfo.Caption := ' ' + MainDm.mtLinSubVareNr.AsString + ' kan normalt ikke sælges til denne kundetype.';
          MainDm.mtLinVareNr.AsString := '';
          MainDm.mtLinSubVareNr.AsString := '';
          exit;
        end;
      end;
    end;

    // Vis vare
    if (MainDm.ffLagKarAntal.AsInteger < MainDm.mtLinAntal.AsInteger) or (MainDm.ffLagKarAntal.AsInteger <= 0) then
    begin
      paLager.Color := clRed;
      paLager.Font.Color := clWhite;
      if StamForm.StockLager <> StamForm.FLagerNr then
      begin
        paLager.Color := clAqua;
        paLager.Font.Color := clBlack;
      end;
      paLager.Caption := ' ' + MainDm.mtLinSubVareNr.AsString + ' lager ' + MainDm.ffLagKarAntal.AsString;
      MainDm.ffLagHis.SetRange(  [StamForm.StockLager, MainDm.mtLinSubVareNr.AsString, 2],
                         [StamForm.StockLager, MainDm.mtLinSubVareNr.AsString, 0]);
      try
        if MainDm.ffLagHis.RecordCount <> 0 then
        begin
          paLager.Color := clYellow;
          paLager.Font.Color := clWindowText;
          if StamForm.StockLager <> StamForm.FLagerNr then
          begin
            paLager.Color := clAqua;
            paLager.Font.Color := clBlack;
          end;
          MainDm.ffLagHis.First;
          LaDisp := 0;
          while not MainDm.ffLagHis.Eof do
          begin
            if MainDm.ffLagHisOrdreStatus.AsInteger = 2 then
              LaDisp := LaDisp + MainDm.ffLagHisLeveret.AsInteger + MainDm.ffLagHisRestordre.AsInteger
            else
              LaDisp := LaDisp + MainDm.ffLagHisAntal.AsInteger;
            MainDm.ffLagHis.Next;
          end;
          paLager.Caption := ' ' + MainDm.mtLinSubVareNr.AsString + ' - I OR : ' + IntToStr(LaDisp);

        end;
      finally
        MainDm.ffLagHis.CancelRange;
      end;

    end
    else
    begin
      paLager.Color := clBtnFace;
      paLager.Font.Color := clWindowText;
      if StamForm.StockLager <> StamForm.FLagerNr then
      begin
        paLager.Color := clAqua;
        paLager.Font.Color := clBlack;
      end;
      paLager.Caption := ' ' + MainDm.mtLinSubVareNr.AsString + ' lager ' + MainDm.ffLagKarAntal.AsString;
    end;

    try
      if MainDm.ffLagKarRestOrdre.AsInteger > 0 then
        paLager.Caption := paLager.Caption + ' RO';
    except
      on E: Exception do
        ChkBoxOk(E.Message);
    end;

    // Slettemærket ikke ved dosis
    if (MainDm.ffLagKarAfmDato.AsString <> '') and (MainDm.mtEksEkspType.AsInteger <> et_Dosispakning) then
    begin
      Beep;
      if MainDm.ffLagKarAntal.AsInteger > 0 then
        ChkBoxOk('Vare er afregistreret i taksten, ' + MainDm.ffLagKarAntal.AsString + ' på lager')
      else
        ChkBoxOk('Vare er afregistreret i taksten, ingen på lager');
      paInfo.Caption := ' Vare er afregistreret i taksten';
      MainDm.mtLinVareNr.AsString := '';
      MainDm.mtLinSubVareNr.AsString := '';
      exit;
    end;
    // Ikke afregistreret
    // Ok := ffLmsTak.FindKey ([mtLinSubVareNr.AsString]);
    // if Ok then begin
    if (MainDm.ffLagKarVareType.AsInteger in [1, 3 .. 7]) and (MainDm.ffLagKarUdlevType.AsString = '') then
    begin
      Beep;
      ChkBoxOk('Vare mangler udleveringsbestemmelse, kan ikke takseres');
      paInfo.Caption := ' Vare mangler udleveringsbestemmelse';
      MainDm.mtLinVareNr.AsString := '';
      MainDm.mtLinSubVareNr.AsString := '';
      exit;
    end;
    // Check midlertidigt udgået
    if MainDm.mtEksEkspType.AsInteger <> et_Dosispakning then
    begin
      if (MainDm.ffLagKarVareType.AsInteger in [1, 3 .. 7]) and ( MainDm.ffLagKarSletDato.AsString <> '') then
      begin
        Beep;
        if MainDm.ffLagKarAntal.AsInteger > 0 then
          ChkBoxOk('Vare er midlertidigt udgået, ' + MainDm.ffLagKarAntal.AsString + ' på lager')
        else
          ChkBoxOk('Vare er midlertidigt udgået, ingen på lager');
      end;
    end;
    // Udlevering OK
    MainDm.mtLinNarkoType.AsInteger := 0;
    if MainDm.ffLagKarVareType.AsInteger = 4 then
    begin
      // Narko, ikke narkocheck ved dyr og dyrlæger
      if not(MainDm.mtEksKundeType.AsInteger in [pt_Dyrlaege,pt_Hobbydyr,pt_Landmand,pt_Andetapotek]) then
      begin
        if (MainDm.mtEksEkspForm.AsInteger <> 4) and (MainDm.mtEksEkspType.AsInteger <> et_Narkoleverance) then
          MainDm.mtEksYdCprChk.AsBoolean := MainDm.mtEksEkspType.AsInteger <> et_Dyr;
        if MainDm.mtEksYdCprChk.AsBoolean then
        begin
          eYderCPRNr.Color := clYellow;
          eYderCPRNr.ReadOnly := False;
          eYderCPRNr.TabStop := True;
        end;
        MainDm.mtLinNarkoType.AsInteger := 1;
      end;
    end;
    if not MainDm.ffLagKar.FindKey([MainDm.mtEksLager.AsInteger, MainDm.mtLinSubVareNr.AsString])
    then
    begin
      ChkBoxOk('Fejl to move to correct stock in lagerkartotek. Kontakt Cito !');
      exit;
    end;
    GAPO := '';
    if MainDm.ffLagKarSubst.AsBoolean then
      GAPO := ' [G]';
    MainDm.mtLinLokation1.AsInteger := MainDm.ffLagKarLokation1.AsInteger;
    MainDm.mtLinLokation2.AsInteger := MainDm.ffLagKarLokation2.AsInteger;
    MainDm.mtLinTekst.AsString := Trim(MainDm.ffLagKarNavn.AsString);
    MainDm.mtLinForm.AsString := Trim(MainDm.ffLagKarForm.AsString);
    MainDm.mtLinStyrke.AsString := Trim(MainDm.ffLagKarStyrke.AsString);
    MainDm.mtLinPakning.AsString := Trim(MainDm.ffLagKarPakning.AsString);
    MainDm.mtLinSSKode.AsString := MainDm.ffLagKarSSKode.AsString;
    MainDm.mtLinATCType.AsString := MainDm.ffLagKarATCType.AsString;
    MainDm.mtLinATCKode.AsString := MainDm.ffLagKarAtcKode.AsString;
    MainDm.mtLinPAKode.AsString := MainDm.ffLagKarPAKode.AsString;
    MainDm.mtLinVareType.AsInteger := MainDm.ffLagKarVareType.AsInteger;
    MainDm.mtLinUdlevType.AsString := Trim(MainDm.ffLagKarUdlevType.AsString);
    MainDm.mtLinHaType.AsString := Trim(MainDm.ffLagKarHaType.AsString);
    MainDm.mtLinOpbevKode.AsString := MainDm.ffLagKarOpbevKode.AsString;

    MainDm.mtLinVareInfo.AsBoolean := False;
    if MainDm.ffLagKarSalgsTekst.AsString <> '' then
      MainDm.mtLinVareInfo.AsBoolean := True;
    tstval := MainDm.ffLagKarVareInfo.AsInteger and MainDm.mtGroGrOplNr.AsInteger;
    c2logadd('vareinfo is ' + MainDm.ffLagKarVareInfo.AsString);
    c2logadd('tstval is ' + IntToStr(tstval));
    if tstval = MainDm.mtGroGrOplNr.AsInteger then
      MainDm.mtLinVareInfo.AsBoolean := True;
    if StamForm.PatientkartotekVareInfo and MainDm.mtLinVareInfo.AsBoolean then
    begin
      Caption := 'Taksering - Tast F4 for Vareinfo';
      Found := False;
      if Varelist.Count <> 0 then
      begin
        for i := 0 to Varelist.Count - 1 do
        begin
          if Varelist.Items[i].VareNr = MainDm.mtLinSubVareNr.AsString then
            Found := True;
        end;
      end;

      if not Found then
      begin
        tmppib.VareNr := MainDm.mtLinSubVareNr.AsString;
        tmppib.Checked := False;
        Varelist.Add(tmppib);
      end;

    end;


    // Evt. 69xxxx vare
    if (copy(MainDm.mtLinSubVareNr.AsString, 1, 2) = '69') or
      (MatchText(copy(MainDm.mtLinSubVareNr.AsString, 1, 6),
        ['222222', '555555', '666666', '685800', '777777', '888888', '999999'])) then
    begin
      WrkS := MainDm.mtLinTekst.AsString;
      if TastTekst('Tast evt. anden varetekst ?', WrkS) then
        MainDm.mtLinTekst.AsString := WrkS;
    end;
    // Check udlevering
    if (MainDm.mtLinUdlevType.AsString = '')  and (MainDm.ffLagKarVareType.AsInteger = 2) then
        MainDm.mtLinUdlevType.AsString := 'HF';
    // Dosispakning eller normal taksering
    if MainDm.mtEksEkspType.AsInteger = et_Dosispakning then
    begin
      // Dosisvare
      if MainDm.ffLagKarDoSalgsPris.AsCurrency = 0 then
      begin
        // Ingen pris måske slettet
        Bel := 0;
        if TastHeltal('Ingen dosispris, tast enhedspris i ører ?', Bel) then
        begin
          // Omdan til kr og ører
          MainDm.mtLinPris.AsCurrency := Bel / 100;
        end;
        MainDm.mtLinKostPris.AsCurrency := 0;
        MainDm.mtLinAndel.AsCurrency := MainDm.mtLinPris.AsCurrency;
        MainDm.mtLinESP.AsCurrency := MainDm.mtLinPris.AsCurrency;
        MainDm.mtLinBGP.AsCurrency := MainDm.mtLinPris.AsCurrency;
      end
      else
      begin
        // Normal dosisvare
        // fix currency to 2 decimal places.......
        MainDm.mtLinKostPris.AsCurrency := SimpleRoundTo(MainDm.ffLagKarDoKostPris.AsCurrency, -2);
        MainDm.mtLinPris.AsCurrency := SimpleRoundTo(MainDm.ffLagKarDoSalgsPris.AsCurrency, -2);
        MainDm.mtLinAndel.AsCurrency := SimpleRoundTo(MainDm.ffLagKarDoSalgsPris.AsCurrency, -2);
        MainDm.mtLinESP.AsCurrency := SimpleRoundTo(MainDm.ffLagKarDoSalgsPris.AsCurrency, -2);
        MainDm.mtLinBGP.AsCurrency := SimpleRoundTo(MainDm.ffLagKarDoBGP.AsCurrency, -2);
        if MainDm.mtLinBGP.AsCurrency = 0 then
          MainDm.mtLinBGP.AsCurrency := SimpleRoundTo(MainDm.ffLagKarDoSalgsPris.AsCurrency, -2);
      end;
    end
    else
    begin
      // Salgspris evt. nettopris eller egenpris
      if MainDm.mtEksNettoPriser.AsBoolean then
      begin
        (* hobro vilovet fix *)
        (* hobro vilovet fix *)
        (* hobro vilovet fix *)
        (* hobro vilovet fix *)
        (* hobro vilovet fix *)
        if SameText(C2StrPrm('Hobro', 'Vilovet', 'Nej'), 'JA') then
        begin
          if MainDm.mtEksDebitorGrp.AsInteger in [10, 11, 12] then
            // PRIS = KostPris + Moms;
            MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarKostPris.AsCurrency +
                                              NettoMoms(MainDm.ffLagKarKostPris.AsCurrency, 25)
          else
            MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarSalgsPris2.AsCurrency;
          (* hobro vilovet fix *)
          (* hobro vilovet fix *)
          (* hobro vilovet fix *)
          (* hobro vilovet fix *)
          (* hobro vilovet fix *)

        end
        else
        begin

          // new vet code

          if StamForm.VetNettoPris then
          begin
            LemvigVet := False;
            for i := 1 to 10 do
            begin
              if StamForm.VetDebGruppe[i] = MainDm.mtEksDebitorGrp.AsInteger then
              begin
                LemvigVet := True;
                break;
              end;
              if StamForm.VetDebGruppe[i] = -1 then
                break;
            end;
            if LemvigVet then
            begin

              MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarEgenPris.AsCurrency;
              if MainDm.mtLinPris.AsCurrency = 0 then
                MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarSalgsPris2.AsCurrency;
              if MainDm.mtLinPris.AsCurrency = 0 then
                MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarSalgsPris.AsCurrency;

              MainDm.mtLinPris.AsCurrency := MainDm.mtLinPris.AsCurrency -
                NettoMoms(MainDm.mtLinPris.AsCurrency, MainDm.mtEksDebProcent.AsCurrency);

            end
            else
              MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarSalgsPris2.AsCurrency;

            if MainDm.mtLinPris.AsCurrency = 0 then
            begin
              if MainDm.ffLagKarEgenPris.AsCurrency > 0 then
                MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarEgenPris.AsCurrency
              else
                MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarSalgsPris.AsCurrency;
            end;
          end
          else
          begin

            // new code for landmand and vet doktor. always use egenpris if there is one.
            if (MainDm.mtEksKundeType.AsInteger in [pt_Dyrlaege, pt_Landmand]) and
              (MainDm.ffLagKarEgenPris.AsCurrency > 0) then
              MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarEgenPris.AsCurrency
            else
              MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarSalgsPris2.AsCurrency;

            if MainDm.mtLinPris.AsCurrency = 0 then
            begin
              if MainDm.ffLagKarEgenPris.AsCurrency > 0 then
                MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarEgenPris.AsCurrency
              else
                MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarSalgsPris.AsCurrency;
            end;
          end;
        end;
      end
      else
      begin

        if (MainDm.EHOrdre) and (EordreOveridePrice) then
          c2logadd('use overrided price ' + MainDm.mtLinPris.AsString)
        else
        begin
          // allow override of prices only on håndkøb lies.
          // if (maindm.mtLinPris.AsCurrency = 0) OR (maindm.mtLinLinieType.AsInteger <> 2)
          // then
          // begin
          if MainDm.ffLagKarEgenPris.AsCurrency > 0 then
            MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarEgenPris.AsCurrency
          else
          begin
            MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarSalgsPris.AsCurrency;
            // new code to check whether eordredato is not today then use tidl salgspris
            if MainDm.EHOrdre and MainDm.EHUseTidlPris and ( DateOf(MainDm.mtEksOrdreDato.AsDateTime) <> Date) then
            begin
              if MainDm.ffLagKarTiSalgsPris.AsCurrency <> 0.0 then
                MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarTiSalgsPris.AsCurrency;
            end;
          end;
          // end;
          c2logadd('check whether to add rcpgebyr');
          // Evt. HX/HV/HF tillægges recepturgebyr
          if MainDm.mtLinPris.AsCurrency > 0 then
            if (MainDm.ffLagKarVareType.AsInteger = 5) and (MainDm.mtLinHaType.AsString <> '') then
              MainDm.mtLinPris.AsCurrency := MainDm.mtLinPris.AsCurrency + MainDm.ffRcpOplRcpGebyr.AsCurrency;
        end;
        if ProdDyrPrices then
        begin
          c2logadd('proddyr price used !!');
          MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarVetProdPris.AsCurrency;
          if MainDm.ffLagKarEgenPris.AsCurrency > 0 then
          begin
            MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarEgenPris.AsCurrency;
            c2logadd('egenpris price used !!');
            if (MainDm.ffLagKarVareType.AsInteger = 5) and (MainDm.mtLinHaType.AsString <> '') then
              MainDm.mtLinPris.AsCurrency := MainDm.mtLinPris.AsCurrency + MainDm.ffRcpOplRcpGebyr.AsCurrency;
          end;
          if MainDm.mtLinPris.AsCurrency = 0 then
          begin
            c2logadd('salgspris price used !!');
            MainDm.mtLinPris.AsCurrency := MainDm.ffLagKarSalgsPris.AsCurrency;
            // Evt. HX/HV/HF tillægges recepturgebyr
            if MainDm.mtLinPris.AsCurrency > 0 then
              if (MainDm.ffLagKarVareType.AsInteger = 5) and (MainDm.mtLinHaType.AsString <> '') then
                MainDm.mtLinPris.AsCurrency := MainDm.mtLinPris.AsCurrency + MainDm.ffRcpOplRcpGebyr.AsCurrency;
          end;
        end;
      end;
      // Ingen pris måske slettet
      if MainDm.mtLinPris.AsCurrency = 0 then
      begin
        while True do
        begin
          Bel := 0;
          if TastHeltal('Ingen salgspris, tast pris i ører ?', Bel) then
          begin
            // Omdan til kr og ører
            MainDm.mtLinPris.AsCurrency := Bel / 100;
            break;
          end;
        end;
      end
      else
      begin
        // Udligning på 100015
        if MainDm.mtLinSubVareNr.AsString = '100015' then
        begin
          while True do
          begin
            Bel := 0;
            if TastHeltal('Tast pris på "100015" i ører ?', Bel) then
            begin
              // Omdan til kr og ører
              MainDm.mtLinPris.AsCurrency := Bel / 100;
              break;
            end;
          end;
        end;
      end;
      // Kostpris m.m.
      MainDm.mtLinKostPris.AsCurrency := MainDm.ffLagKarKostPris.AsCurrency;
      MainDm.mtLinAndel.AsCurrency := MainDm.mtLinPris.AsCurrency;
      MainDm.mtLinESP.AsCurrency := MainDm.mtLinPris.AsCurrency;
      MainDm.mtLinBGP.AsCurrency := MainDm.ffLagKarBGP.AsCurrency;

      // new code to check whether eordredato is not today then use tidl bgp
      if MainDm.EHOrdre and MainDm.EHUseTidlPris and ( DateOf(MainDm.mtEksOrdreDato.AsDateTime) <> Date) then
      begin
        if MainDm.ffLagKarTiBGP.AsCurrency <> 0.0 then
          MainDm.mtLinBGP.AsCurrency := MainDm.ffLagKarTiBGP.AsCurrency;
      end;


      // Reguler evt. BGP
       if (MainDm.ffLagKarVareType.AsInteger = 2) or
        ((MainDm.ffLagKarVareType.AsInteger = 5) and (MainDm.mtLinHaType.AsString <> '')) then
      begin
        // Mærkevarer og HX/HX sæt BGP = ESP
        MainDm.mtLinBGP.AsCurrency := MainDm.mtLinPris.AsCurrency;
      end;
      // Check for høj evt 0 BGP
      if (MainDm.mtLinBGP.AsCurrency = 0) or (MainDm.mtLinBGP.AsCurrency > MainDm.mtLinPris.AsCurrency) then
      begin
        // Ret BGP
        MainDm.mtLinBGP.AsCurrency := MainDm.mtLinPris.AsCurrency;
      end;
      // Fjern recepturgebyr ved HA håndkøbslinier
      if (MainDm.ffLagKarVareType.AsInteger = 5) and
        (MainDm.mtLinPris.AsCurrency > MainDm.ffRcpOplRcpGebyr.AsCurrency) and
        (MainDm.mtLinLinieType.AsInteger = lt_Handkoeb) then
      begin
        // Håndkøbslinie
        if (MainDm.EHOrdre) and (EordreOveridePrice) then
          c2logadd('use overrided price ' + MainDm.mtLinPris.AsString)
        else
        begin
          c2logadd('not eordre so remove recepter gebyr');
          MainDm.mtLinPris.AsCurrency := MainDm.mtLinPris.AsCurrency - MainDm.ffRcpOplRcpGebyr.AsCurrency;
        end;
      end;
    end;
    MainDm.mtLinSaveBGP.AsCurrency := MainDm.mtLinBGP.AsCurrency;
    MainDm.mtLinSaveESP.AsCurrency := MainDm.mtLinESP.AsCurrency;
    // Dispenseringsform for dosering
    FrmEntal := '';
    FrmFlertal := '';
    FrmTekst := '';
    if MainDm.cdDspFrm.FindKey([MainDm.mtLinSubVareNr.AsString]) then
    begin
      DanDispFormer(MainDm.cdDspFrmDispForm.AsString, FrmEntal, FrmFlertal);
      // Edifact følgetekst
      if MainDm.mtEksReceptStatus.Value = 2 then
      begin
        // Følgetekst fra dispenseringsform
        if FrmTekst <> '' then
        begin
          meEtiketter.Lines.Add(FrmTekst);
          MainDm.mtLinFolgeTxt.AsString := FrmTekst;
        end;
      end;
    end;


    // new code to fill the indikation box

    sltmpSort := TStringList.Create;
    try
      sltmpSort.Clear;
      cbIndikation.Clear;
      ICnt := 0;
      MainDm.cdDrgInd.IndexName := 'IdOrden';
      c2logadd('cbindikation ' + MainDm.ffLagKarVareNr.AsString + ' ' + MainDm.ffLagKarDrugId.AsString);
      if MainDm.ffLagKarVareNr.AsString <> MainDm.mtLinSubVareNr.AsString then
      begin
        c2logadd('Current varenr in lagerkarkartotek does not match line subvarenr');
        c2logadd('line subvarenr is ' + MainDm.mtLinSubVareNr.AsString +
          ' lagerkartotek points to ' + MainDm.ffLagKarVareNr.AsString);
        ChkBoxOk( 'Det ser ud til, at der er en fejl i indikationsteksten.' + sLineBreak +
                  'Luk ekspeditionen og start forfra.' + sLineBreak +
                  'Kontakt CITO vedrørende problemet.');
        exit;
      end;
      MainDm.cdDrgInd.SetRange([MainDm.ffLagKarDrugId.AsString], [MainDm.ffLagKarDrugId.AsString]);
      try
        if MainDm.cdDrgInd.RecordCount > 0 then
        begin
          MainDm.cdDrgInd.First;
          while not MainDm.cdDrgInd.Eof do
          begin
            MainDm.cdIndTxt.IndexName := 'NrOrden';

            if MainDm.cdIndTxt.FindKey([MainDm.cdDrgIndNr.AsString]) then
              sltmpSort.Add(MainDm.cdIndTxtTekst.AsString);

            MainDm.cdDrgInd.Next;
          end;
          sltmpSort.Sort;
          for i := 0 to sltmpSort.Count - 1 do
          begin
            cbIndikation.Items.Add(sltmpSort.Strings[i]);
            Inc(ICnt);
          end;
        end;

      finally
        MainDm.cdDrgInd.CancelRange;
        cbIndikation.DropDownCount := ICnt;
      end;

      // code to fill the cbDoseringsbox
      cbDosTekst.Clear;
      sltmpSort.Clear;
      ICnt := 0;
      MainDm.cdDrgDos.IndexName := 'IdOrden';
      MainDm.cdDrgDos.SetRange([MainDm.ffLagKarDrugId.AsString], [MainDm.ffLagKarDrugId.AsString]);
      try
        if MainDm.cdDrgDos.RecordCount > 0 then
        begin
          MainDm.cdDrgDos.First;
          while not MainDm.cdDrgDos.Eof do
          begin
            MainDm.cdDosTxt.IndexName := 'NrOrden';

            if MainDm.cdDosTxt.FindKey([MainDm.cdDrgDosNr.AsString]) then
              sltmpSort.Add(MainDm.cdDosTxtTekst.AsString);

            MainDm.cdDrgDos.Next;
          end;
          sltmpSort.Sort;
          for i := 0 to sltmpSort.Count - 1 do
          begin
            cbDosTekst.Items.Add(sltmpSort.Strings[i]);
            Inc(ICnt);
          end;
        end;

      finally
        MainDm.cdDrgDos.CancelRange;
        cbDosTekst.DropDownCount := ICnt;
      end;

    finally
      sltmpSort.Free;
    end;
    EVare.Text := MainDm.ffLagKarVareNr.AsString;
    if MainDm.EHOrdre then
    begin
      if OriginalVarenr <> '' then
        MainDm.mtLinVareNr.AsString := OriginalVarenr;
      OriginalVarenr := '';
    end;

    if (MainDm.mtLinUdLevType.AsString = 'BEGR') and (MainDm.mtLinATCKode.AsString ='J01FA10') then
    begin
      if not frmYesNo.NewYesNoBox('Udlev BEGR – Atckode J01FA10' + sLineBreak + sLineBreak +
                                  'Jf. gældende undtagelser KAN ekspedition være tilladt.' + sLineBreak +
                                  'Ønsker du at fortsætte?') then
      begin
        ForceClose := True;
        Close;
        exit;
      end;

    end;

    if (MatchText(MainDm.mtLinUdlevType.AsString,['NBS', 'BEGR']) and
      (MainDm.mtLinATCKode.AsString  <> 'J01FA10')) or (MainDm.mtLinUdlevType.AsString = 'AP4NB') then
    begin
      paInfo.Color := clYellow;
      paInfo.Refresh;
      if StamForm.SpoergYdernrNBS then
        frmYesNo.NewOKBox('Udlevering NBS eller Begr' + sLineBreak +
          'Husk at se efter om ydernr er korrekt!');

    end
    else
      paInfo.Color := clBtnFace;

    paInfo.Caption := ' ' + MainDm.mtLinTekst.AsString + ' ' + MainDm.mtLinForm.AsString +
      ' ' + MainDm.mtLinStyrke.AsString + ' ' + MainDm.mtLinPakning.AsString + ' udl. ' +
      MainDm.mtLinUdlevType.AsString + ' ' + MainDm.mtLinHaType.AsString + GAPO;

    if MainDm.mtEksEkspType.Value = et_Dosispakning then
      paInfo.Caption := paInfo.Caption + ' DOSISENHED';
    if klausCaption then
      paInfo.Caption := paInfo.Caption + ',KLAUS';
    if substCaption then
      paInfo.Caption := paInfo.Caption + ',  S';

    if copy(MainDm.ffLagKarDrugId.AsString, 1, 4) = CannabisPrefix then
      paInfo.Caption := paInfo.Caption + ' CANNABIS';
    if MainDm.mtlinsubvarenr.AsString <> MainDm.mtLinOrdineretVarenr.AsString then
    begin
      if not CheckInSameSubstGtoup(MainDm.mtLinOrdineretVarenr.AsString,MainDm.mtLinSubVareNr.AsString) then
      begin
        EUdlev.Enabled := True;
        EMax.Enabled := True;
      end;

//      end
//      else
//      begin
//        EUdlev.Enabled := False;
//        EMax.Enabled := False;
    end;
    TabEnter;
  end;


begin
  if Key <> #13 then
    exit;

  c2logadd('Enter pressed in ' + ActiveControl.Name);
  IF ActiveControl = lcbEkspForm then
  begin
    buVidere.SetFocus;
    Key := #0;
    exit;
  end;

  if ActiveControl = eYderCPRNr then
  begin

    MainDm.ffYdLst.IndexName := 'YderNrOrden';

    if MainDm.ffYdLst.FindKey([MainDm.mtEksYderNr.AsString, eYderCPRNr.Text]) then
    begin
      MainDm.mtEksYderNavn.AsString := MainDm.ffYdLstNavn.AsString;
      // mtEks.Post;
      // mtEks.ApplyUpdates(-1);
      // mtEks.Refresh;
      // mtEks.Edit;
    end;
    TabEnter;
    exit;
  end;

  if ActiveControl = eYderNr then
  begin
    Process_eYdenr;
    TabEnter;
    exit;
  end;

  if ActiveControl = eNarkoNr then
  begin
    TabEnter;
    exit;
  end;

  if ActiveControl = EVare then
  begin
    process_EVare;
    exit;
  end;

  if ActiveControl = EAntal then
  begin
    if AntalFieldKeyPress then
      exit;
    AntalFieldKeyPress := True;
    try
      process_Eantal;
    finally
      AntalFieldKeyPress := False;
    end;
    exit;
  end;

  if ActiveControl = EMax then
  begin
    if MainDm.mtLinOrdineretVarenr.AsString = MainDm.mtLinSubVareNr.AsString  then
    begin
      if MatchText(MainDm.mtLinOrdineretUdlevType.AsString, ['AP4','NBS','A','AP4NBS']) then
      begin
        buVidere.Tag := 2;
        buVidere.SetFocus;
        exit;
      end;
    end;
    if MainDm.mtLinUdlevMax.Value > 0 then
      if MainDm.mtLinUdlevNr.Value > MainDm.mtLinUdlevMax.Value then
        ChkBoxOk('Udleveringsnr er større end Max. udleveringer');
    TabEnter;
    exit;
  end;

  if ActiveControl = EUdlev then
  begin
    // only check the udlevnr if the SpørgUdlA parameter in winpacer is set to Ja (default is Ja)
    if MainDm.SpoergUdlA then
    begin
      if MainDm.mtLinUdlevMax.AsInteger > MainDm.mtLinUdlevNr.AsInteger then
      begin
        if MatchText( MainDm.mtLinUdLevType.AsString, ['A','AP4','NBS','AP4NB','BEGR','APK','AP']) then
        begin

          if not ChkBoxYesNo('Vær opmærksom på udleveringstype:' + sLineBreak + sLineBreak +

            'AP4 må ikke genudleveres.' + sLineBreak +
            'A - NBS må ikke genudleveres, men den samlede mængde må gerne deles op.' + sLineBreak + sLineBreak +
            'Ønsker du at fortsætte?', True) then
          begin
            EMax.SetFocus;
            exit;
          end;
        end;
      end;
    end;

    if (MainDm.mtLinUdlevNr.Value mod 10) = (MainDm.mtLinUdlevNr.Value div 10) then
      ChkBoxOk('Muligvis dobbeltindtastning af udleveringsnr');
    // Ikke reitereret eller dosispakning
    if (not MainDm.mtLinReitereret.AsBoolean) and (MainDm.mtEksEkspType.Value <> et_Dosispakning) then
      TabEnter
    else
    begin
      buVidere.Tag := 2;
      buVidere.SetFocus;
    end;
    exit;
  end;

  if ActiveControl = cbDosTekst then
  begin
    process_cbDosTekst;
    TabEnter;
    exit;
  end;

  if ActiveControl = EDos2 then
  begin
    process_EDos2;
    TabEnter;
    exit;
  end;

  if ActiveControl = cbIndikation then
  begin
    Process_cbIndikation;
    exit;
  end;

  if (not(ActiveControl is TDBGrid)) and (not(ActiveControl is TDBMemo)) and
    (not(ActiveControl is TMemo)) and (not(ActiveControl is TRichEdit)) and
    (not(ActiveControl is TDBRichEdit)) then
  begin
    if (ActiveControl is TDBLookupComboBox) then
    begin
      if not(ActiveControl as TDBLookupComboBox).ListVisible then
        TabEnter;
      exit;
    end;
    if (ActiveControl is TDBComboBox) then
    begin
      if not(ActiveControl as TDBComboBox).DroppedDown then
        TabEnter;
      exit;
    end;
    TabEnter;
  end;

end;

procedure THumanForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  c2logadd('Mouse clicked in ' + ActiveControl.Name);
end;

procedure THumanForm.cbIndikationEnter(Sender: TObject);
begin
  c2logadd('   *** Indikation field entered ***');
  EtiketFieldEntered := True;
  if cbIndikation.Text <> '' then
    exit;
  if C2StrPrm(MainDm.C2UserName, 'Recepturindikation', '') = 'Text2' then
    exit;
  if cbIndikation.DropDownCount > 0 then
  begin
    cbIndikation.ItemIndex := 0;
    cbIndikation.Font.Size := 8;
    cbIndikation.DroppedDown := True;
  end;
end;

procedure THumanForm.DropDown(Sender: TObject);
begin
  if (Sender is TDBLookupComboBox) then
    (Sender as TDBLookupComboBox).DropDownRows := (Sender as TDBLookupComboBox).ListSource.DataSet.RecordCount;
  if (Sender is TDBComboBox) then
    (Sender as TDBComboBox).DropDownCount := (Sender as TDBComboBox).Items.Count;
end;

procedure THumanForm.EAntalEnter(Sender: TObject);
begin
  if TakserEHAutotEnter then
    SendEnterKey(EAntal.Handle);
end;

procedure THumanForm.eDebitorNrEnter(Sender: TObject);
begin
  // Debitor
  OldDebitor := MainDm.mtEksDebitorNr.AsString;
  if (Sender as TDBEdit).Tag = 1 then
    ReadyDebitor;
  // Levering
  if (Sender as TDBEdit).Tag = 2 then
    ReadyLevering;
end;

procedure THumanForm.eDebitorNrExit(Sender: TObject);
begin
  if not((Sender as TDBEdit).Tag in [1, 2]) then
    exit;

  // Debitor
  if (Sender as TDBEdit).Tag = 1 then
  begin
    if (ProdDyrPrices) and (MainDm.mtLin.RecordCount >= 1) then
    begin
      if OldDebitor <> eDebitorNr.Text then
        ChkBoxOk( 'Kontoen er til produktionsdyr med specielle priser.' + sLineBreak +
                  'Den kan derfor ikke ændres under ekspeditionen.');
      exit;
    end;
    if Trim(eDebitorNr.Text) <> '' then
    begin
      CheckDebitor;
      exit;
    end;
    MainDm.mtEksDebitorNavn.AsString := '';
    MainDm.mtEksLeveringsForm.Value := 0;
    // reset everything else back the way it should be on start
    MainDm.mtEksAfdeling.Value := MainDm.AfdNr;
    MainDm.mtEksLager.Value := StamForm.FLagerNr;
    StamForm.StockLager := StamForm.Save_StockLager;
    c2logadd('11: Stock lager changed to ' + IntToStr(StamForm.StockLager));
    MainDm.mtEksDebitorNavn.AsString := '';
    MainDm.mtEksLeveringsForm.Value := 0;
    MainDm.mtEksUdbrGebyr.AsCurrency := 0.0;
    eDebitorNr.Color := clSilver;
    eDebitorNr.TabStop := True;
    lcLevForm.Color := clSilver;
    lcLevForm.TabStop := False;
    ePakkeNr.Color := clSilver;
    ePakkeNr.ReadOnly := False;
    ePakkeNr.TabStop := False;
    ProdDyrPrices := False;
  end;
  // Levering
  if Trim(eLevNr.Text) <> '' then
  begin
    CheckLevering;
    exit;
  end;
  MainDm.mtEksLevNavn.AsString := '';

  // 1239 set the udbr gebyr to 0 to stop popup check the debitor as well.
  if MainDm.mtEksDebitorNr.AsString <> '' then
  begin
    if MainDm.ffDebKar.FindKey([MainDm.mtEksDebitorNr.AsString]) then
    begin
      if MainDm.ffDebKarUdbrGebyr.AsBoolean then
        exit;
    end;
  end;
  MainDm.mtEksUdbrGebyr.AsCurrency := 0.0;
end;

procedure THumanForm.lcArtExit(Sender: TObject);
begin
  MainDm.TableFilter(MainDm.cdDyrAld);
  MainDm.TableFilter(MainDm.cdDyrOrd);
  MainDm.cdDyrAld.First;
  MainDm.cdDyrOrd.First;
  MainDm.mtLinAldersGrp.Value := MainDm.cdDyrAldNr.Value;
  MainDm.mtLinOrdGrp.Value := MainDm.cdDyrOrdNr.Value;
  lcAlder.Update;
  lcOrd.Update;
end;

procedure THumanForm.meEtiketterChange(Sender: TObject);
begin
  c2logadd('Etiket is now ' + meEtiketter.Lines.Text);
end;

procedure THumanForm.meEtiketterEnter(Sender: TObject);
begin
  EtiketFieldEntered := True;
  if MainDm.mtLin.State = dsBrowse then
  begin
    c2logadd('etiket field entered in browse this might not end well');
    exit;
  end;
  MainDm.mtLinValideret.AsBoolean := False;
end;

procedure THumanForm.process_cbDosTekst;
var
  WrkS: string;
begin

  WrkS := AnsiUpperCase(Trim(cbDosTekst.Text));
  if WrkS = '' then
    exit;

  MainDm.mtLinDosering1.AsString := WrkS;
  if MainDm.ffDosTxt.FindKey([WrkS]) then
  begin
    if C2StrPrm(MainDm.C2UserName, 'Recepturdosering', '') = 'Text2' then
      // Benyt tekst2 (Dyr)
      WrkS := AnsiUpperCase(Trim(MainDm.ffDosTxtTekst2.AsString))
    else
    begin
      // Benyt tekst1 (Human)
      WrkS := AnsiUpperCase(Trim(MainDm.ffDosTxtTekst1.AsString));
      WrkS := StringReplace(WrkS, '@', FrmEntal, [rfReplaceAll]);
      WrkS := StringReplace(WrkS, '#', FrmFlertal, [rfReplaceAll]);
    end;
  end;
  meEtiketter.Lines.Add(WrkS);

end;

procedure THumanForm.Process_cbIndikation;
var
  WrkS: string;
begin

  try
    if MainDm.mtLinLinieType.Value <> lt_Recept then
      exit;
    if C2StrPrm(MainDm.C2UserName, 'Recepturindikation', '') = 'Text2' then
    begin
      // Dyr indikation
      WrkS := AnsiUpperCase(Trim(cbIndikation.Text));
      if WrkS <> '' then
      begin
        cbIndikation.Text := WrkS;
        if MainDm.ffDosTxt.FindKey([WrkS]) then
          WrkS := AnsiUpperCase(Trim(MainDm.ffDosTxtTekst2.AsString));
        meEtiketter.Lines.Add(WrkS);
      end;
      exit;
    end;

    // Evt. human indikation
    if cbIndikation.Text <> '' then
    begin
      cbIndikation.Text := AnsiUpperCase(cbIndikation.Text);
      meEtiketter.Lines.Add(cbIndikation.Text);
      MainDm.mtLinIndikation.AsString := cbIndikation.Text;
    end;
    // Følgetekst fra dispenseringsform
    if FrmTekst <> '' then
    begin
      meEtiketter.Lines.Add(FrmTekst);
      MainDm.mtLinFolgeTxt.AsString := FrmTekst;
    end;

    // Dyr
    if MainDm.mtEksEkspType.Value = et_Dyr then
    begin
      meEtiketter.Lines.Add('LÆGEMIDDEL TIL DYR');
      if MainDm.mtLinFolgeTxt.AsString = '' then
        MainDm.mtLinFolgeTxt.AsString := 'LÆGEMIDDEL TIL DYR';
      exit;
    end;

    if MainDm.mtEksKundeType.AsInteger in [pt_Dyrlaege, pt_Landmand] then
    begin
      meEtiketter.Lines.Add('LÆGEMIDDEL TIL DYR');
      if MainDm.mtLinFolgeTxt.AsString = '' then
        MainDm.mtLinFolgeTxt.AsString := 'LÆGEMIDDEL TIL DYR';
    end;

  finally
    buVidere.Tag := 2;
    buVidere.SetFocus;
  end;


end;

procedure THumanForm.process_Eantal;
var
  LaDisp: Integer;

  function CheckSubstAntal(AVarenr, ASubVarenr : string; AOrdineretAntal : integer ) : boolean;
  var
    LAntPkn : integer;
    LQry : TnxQuery;
  begin
    Result := True;
    LAntPkn := 0;

    LQry := MainDm.nxdb.OpenQuery('select ' + fnLagerSubstListeantpkn + ' from '+  tnLagerSubstListe+
                        ' where ' + fnLagerSubstListeVarenr_P + ' and ' + fnLagerSubstListeSubNr_P,
                        [AVarenr,ASubVarenr]);
    try
      if LQry.Eof then
      begin
        ChkBoxOK('Varenummeret på en udlevering A - AP4 - NBS taksation er blevet ændret.'
            + sLineBreak +'Vær opmærksom på antal');
        exit;
      end;
      LAntPkn := LQry.FieldByName(fnLagerSubstListeantpkn).AsInteger;
      if LAntPkn = 0 then
        LAntPkn := 1;


    finally
      LQry.Free;
    end;



    if MainDm.mtLinAntal.AsInteger > MainDm.mtLinOrdineretAntal.AsInteger * LAntPkn then
    begin
      ChkBoxOK('Antal kan højst være ' + inttostr(MainDm.mtLinOrdineretAntal.AsInteger * LAntPkn));
      MainDm.mtLinAntal.AsInteger := MainDm.mtLinOrdineretAntal.AsInteger * LAntPkn;
      EAntal.Text := MainDm.mtLinAntal.AsString;
      Result := False;
    end;

    // if antal is less than calculated ordineret antal then open
    // eudlev and emax fields
    if MainDm.mtLinAntal.AsInteger < MainDm.mtLinOrdineretAntal.AsInteger * LAntPkn then
    begin

        EUdlev.Enabled := True;
        EMax.Enabled := True;
    end;


  end;


begin
  MainDm.mtLinAntal.Value := strtointdef(EAntal.Text,1);
  EAntal.Text := MainDm.mtLinAntal.AsString;
  if (StamForm.RowaEnabled) then
  begin
    if (not StamForm.RowaOrdre) and (MainDm.mtEksEkspType.AsInteger <> et_Dosispakning) and
      (MainDm.mtEksOrdreType.AsInteger = 1) and  (MainDm.mtLinLokation1.AsInteger = StamForm.RowaLokation) then
      frmRowaApp.RowaSendARequest(MainDm.mtLinSubVareNr.AsString, MainDm.mtLinAntal.AsInteger);
  end;

  MainDm.mtLinAntal.Value := Abs(MainDm.mtLinAntal.Value);
  if MainDm.mtLinAntal.Value > 99 then
  begin
    ChkBoxOk('Kun max 99 i antal pr. ordination !');
    MainDm.mtLinAntal.Value := 99;
    EAntal.Text := '99';
    exit;
  end;

  // if its the same the product number as the ordered then check if it
  // is AP4 ,NBS or in udlevtype then antal must not be greater than
  // ordineret antal
  // this check has been chaned so that if they pick a completelyt different
  // then
  if (MainDm.mtLinOrdineretVarenr.AsString = MainDm.mtLinVareNr.AsString) and
      (MainDm.mtLinVareNr.AsString = MainDm.mtLinSubVareNr.AsString)  then
  begin
    if MatchText(MainDm.mtLinOrdineretUdlevType.AsString, ['AP4','NBS','A','AP4NBS']) then
    begin
      if MainDm.mtLinAntal.AsInteger > MainDm.mtLinOrdineretAntal.AsInteger then
      begin
        ChkBoxOK('Antal kan højst være ' + MainDm.mtLinOrdineretAntal.AsString);
        MainDm.mtLinAntal.AsInteger := MainDm.mtLinOrdineretAntal.AsInteger;
        EAntal.Text := MainDm.mtLinAntal.AsString;
        exit;
      end;

      if MainDm.mtLinAntal.AsInteger < MainDm.mtLinOrdineretAntal.AsInteger then
      begin
        EUdlev.Enabled := True;
        EMax.Enabled := True;
      end
      else
      begin
        EUdlev.Enabled := False;
        EMax.Enabled :=False;
      end;


    end;
  end
  else
  begin
    // if the original product was AP4 etc and the newly selected product is
    // AP4 etc then messagebox them
    if (MainDm.mtLinVareNr.AsString = MainDm.mtLinOrdineretVarenr.AsString) then
    begin

      if MatchText(MainDm.mtLinOrdineretUdlevType.AsString, ['AP4','NBS','A','AP4NBS']) then
      begin
  //        if not MatchText(mtLinUdlevType.AsString, ['AP4','NBS','A','AP4NBS']) then
//          if not CheckSubstAntal( mtLinVareNr.AsString, mtLinSubVareNr.asstring,
//                                  mtLinOrdineretAntal.AsInteger) then
//            exit;


      end;
    end
    else
    begin
      if MatchText(MainDm.mtLinOrdineretUdlevType.AsString, ['AP4','NBS','A','AP4NBS']) then
      begin
  //        if not MatchText(mtLinUdlevType.AsString, ['AP4','NBS','A','AP4NBS']) then
//          CheckSubstAntal( mtLinOrdineretVarenr.AsString, mtLinSubVareNr.asstring,
//                                  mtLinOrdineretAntal.AsInteger);
      end;
      EUdlev.Enabled := True;
      EMax.Enabled := True;
    end;
  end;




  MainDm.mtLinBGPBel.AsCurrency := 0;
  MainDm.mtLinIBTBel.AsCurrency := 0;
  MainDm.mtLinTilskType.Value := 0;
  MainDm.mtLinRegelSyg.Value := 0;
  MainDm.mtLinRegelKom1.Value := 0;
  MainDm.mtLinRegelKom2.Value := 0;
  MainDm.mtLinTilskSyg.AsCurrency := 0;
  MainDm.mtLinTilskKom1.AsCurrency := 0;
  MainDm.mtLinTilskKom2.AsCurrency := 0;
  // mtLinBGP.AsCurrency := mtLinSaveBGP.AsCurrency;
  // mtLinESP.AsCurrency := mtLinSaveESP.AsCurrency;
  MainDm.mtLinTilskSyg.AsCurrency := 0;
  MainDm.mtLinBrutto.AsCurrency := MainDm.mtLinPris.AsCurrency * MainDm.mtLinAntal.Value;
  MainDm.mtLinAndel.AsCurrency := MainDm.mtLinBrutto.AsCurrency;
  // Tilskudsberegning eller ej
  if (MainDm.mtEksKundeType.Value = pt_Enkeltperson) and (MainDm.mtLinLinieType.Value = lt_Recept) and
    (MainDm.mtEksEkspType.Value <> et_Narkoleverance) then
  begin
    // Enkeltpersoner
    if not MainDm.ffPatKarEjCtrReg.AsBoolean then
    begin
      if MainDm.ffPatKarFiktivtCprNr.AsBoolean then
      begin
        // Spørg om beregning ønskes foretaget
        if ChkBoxYesNo('Beregn tilskud til fiktivt cprnr ?', True) then
        begin
          if IsCannabisProduct(MainDm.Nxdb, MainDm.mtLinLager.AsInteger, MainDm.mtLinSubVareNr.AsString, MainDm.mtLinTekst.AsString,
            MainDm.mtLinDrugid.AsString) then
            BeregnCannabisOrdination
          else
            BeregnOrdination(SaveDosisKortNr);
        end;
      end
      else
      begin
        if IsCannabisProduct(MainDm.Nxdb, MainDm.mtLinLager.AsInteger,  MainDm.mtLinSubVareNr.AsString, MainDm.mtLinTekst.asstring,
          MainDm.mtLinDrugid.AsString) then
          BeregnCannabisOrdination
        else
          BeregnOrdination(SaveDosisKortNr);
      end;
    end;
  end
  else
  begin
    if MainDm.mtEksEkspType.Value = et_Vagtbrugmm then
    begin
      // Vagtbrug
      if (MainDm.mtLinTilskType.Value = 0) and (MainDm.mtLinRegelSyg.Value = 0) then
      begin
        if PositiveRule <>0 then
        begin
          HandlePositivList(PositiveRule,MainDm.mtLinSubVareNr.AsString,MainDm.mtLinATCKode.AsString);
        end;
      end;
      if MainDm.mtLinRegelSyg.Value > 0 then
      begin
        MainDm.mtLinTilskSyg.AsCurrency := MainDm.mtLinBrutto.AsCurrency;
        MainDm.mtLinAndel.AsCurrency := 0;
      end;
    end;
  end;
  if MainDm.mtLinLinieType.Value = lt_Handkoeb then
  begin
    MainDm.mtLinEtkLin.Value := 0;
    if (not MainDm.EHOrdre) then
    begin
      if ChkBoxYesNo('Ønskes doseringsetikette(r) ?', True) then
        MainDm.mtLinEtkLin.Value := 1;
    end;
    buVidere.Tag := 2;
    buVidere.SetFocus;

  end
  else
  begin
    if MainDm.Recepturplads ='DYR' then
      cbDosTekst.SetFocus
    else
    begin

      if MainDm.mtLinUdlevMax.Value > 0 then
        if EUdlev.Enabled then
          EUdlev.SetFocus
        else
        begin
          buVidere.Tag := 2;
          buVidere.SetFocus;
        end
      else
        if EMax.Enabled and EUdlev.Enabled then
          EMax.SetFocus
        else
        begin
          buVidere.Tag := 2;
          buVidere.SetFocus;
        end;
    end;
  end;
  // Key := #0;
  if SkipReservation then
  begin
    SkipReservation := False;
    if MainDm.ehordre and TakserEHAutotEnter then
      buVidere.Click;
    exit;
  end;

  if MainDm.mtEksOrdreType.AsInteger = 1 then
  begin

    if (MainDm.ffLagKarAntal.AsInteger < MainDm.mtLinAntal.AsInteger) or (MainDm.ffLagKarAntal.AsInteger <= 0) then
    begin
      if StamForm.SpoergReservation then
      begin
        // remove check on 80xxxx numbers
        if (copy(MainDm.ffLagKarVareNr.AsString, 1, 2) <> '69') then
        begin
          TfrmResv.ShowResv(True);
          if EVare.Text <> MainDm.mtLinSubVareNr.AsString then
          begin
            EVare.Text := MainDm.mtLinSubVareNr.AsString;
            ReservationOrigVarenr := MainDm.mtLinVareNr.AsString;
            SkipReservation := True;
            EVare.SetFocus;
            exit;
          end;

        end;

      end;

      paLager.Color := clRed;
      paLager.Font.Color := clWhite;
      if StamForm.StockLager <> StamForm.FLagerNr then
      begin
        paLager.Color := clAqua;
        paLager.Font.Color := clBlack;
      end;
      paLager.Caption := ' ' + MainDm.mtLinSubVareNr.AsString + ' lager ' + MainDm.ffLagKarAntal.AsString;
      MainDm.ffLagHis.SetRange([StamForm.StockLager, MainDm.mtLinSubVareNr.AsString, 2],
                        [StamForm.StockLager, MainDm.mtLinSubVareNr.AsString, 0]);
      try
        if not MainDm.ffLagHis.IsEmpty then
        begin
          paLager.Color := clYellow;
          paLager.Font.Color := clWindowText;
          if StamForm.StockLager <> StamForm.FLagerNr then
          begin
            paLager.Color := clAqua;
            paLager.Font.Color := clBlack;
          end;
          MainDm.ffLagHis.First;
          LaDisp := 0;
          while not MainDm.ffLagHis.Eof do
          begin
            if MainDm.ffLagHisOrdreStatus.AsInteger = 2 then
              LaDisp := LaDisp + MainDm.ffLagHisLeveret.AsInteger + MainDm.ffLagHisRestordre.AsInteger
            else
              LaDisp := LaDisp + MainDm.ffLagHisAntal.AsInteger;
            MainDm.ffLagHis.Next;
          end;
          paLager.Caption := ' ' + MainDm.mtLinSubVareNr.AsString + ' - I OR : ' + IntToStr(LaDisp);

        end;
      finally
        MainDm.ffLagHis.CancelRange;
      end;

    end;

  end;
  if MainDm.ehordre and TakserEHAutotEnter then
    buVidere.Click;

end;
procedure THumanForm.SetUpPositiveRuleForEkspedition;
var
  LRegionPosListFile : string;

const
  SRegel1116Message = 'Lægen er oprettet med både en regel 11 og regel 16.' + slinebreak +
                      'Skal regel 11 anvendes? ' + slinebreak +
                      'Vælges nej, anvendes regel 16' + slinebreak + slinebreak +
                      'Vælg F7 under taksationen for at få vist positivlisten';
  SRegel1314Message = 'Lægen er oprettet med både en regel 13 og regel 14.' + sLineBreak +
                      'Skal regel 13 anvendes? ' + slinebreak +
                      'Vælges nej, anvendes regel 14' + slinebreak + slinebreak +
                      'Vælg F7 under taksationen for at få vist positivlisten';
begin
  try
    if PositiveRule = CRegionRule1116Found then
    begin
      if ShowMessageBoxWithLogging(sregel1116Message,'Vælg Ja/Nej', MB_YESNO+MB_DEFBUTTON1)= ID_YES then
        PositiveRule := CRegionRule11Found
      else
        PositiveRule := CRegionRule16Found;

      exit;
    end;

    if PositiveRule = CRegionRule1314Found then
    begin
      if ShowMessageBoxWithLogging(sregel1314Message,'Vælg Ja/Nej', MB_YESNO+MB_DEFBUTTON1)= ID_YES then
        PositiveRule := CRegionRule13Found
      else
        PositiveRule := CRegionRule14Found;

      exit;
    end;

  finally
    acVisPositivList.Enabled := PositiveRule in [CRegionRule11Found,CRegionRule13Found];
    if acVisPositivList.Enabled then
    begin
      LRegionPosListFile := 'G:\Temp\RegionPoslist' + MainDm.BrugerNr.ToString + '.cds';
      RegionPosList.CDS.SaveToFile(LRegionPosListFile);
    end;

  end;


end;

procedure THumanForm.HandlePositivList(const APositiveRule : integer; const AVarenr,AATCKode : string);
var
  LPosListLog: TStringList;
  LPositivMessage: string;
begin
  LPosListLog := TStringList.Create;
  try
    case APositiveRule of
      CRegionRule11Found:
        begin
          if RegionPosList.ValidItem(LPosListLog, AVarenr, AATCKode, LPositivMessage) <> CNotFoundInList then
          begin
            LPositivMessage := LPositivMessage + sLineBreak + sLineBreak + 'Luk boksen og vælg F7 for at se positivlisten';
            if ShowMessageBoxWithLogging(LPositivMessage, 'Vælg Ja/Nej', MB_YESNO + MB_DEFBUTTON1) = ID_YES then

              MainDm.mtLinRegelSyg.AsInteger := 11;

          end
          else
          begin

            if ShowMessageBoxWithLogging('Dette varenummer/denne ATC-kode er IKKE på ' + GetRegionName(RegionPosList.RegionNumber) +
              's positivliste.' + sLineBreak + 'Skal der alligevel ydes tilskud i henhold til regel 11?', 'Vælg Ja/Nej',
              MB_YESNO + MB_DEFBUTTON2) = ID_YES then
            begin
              MainDm.mtLinRegelSyg.AsInteger := 11;
              MainDm.mtLinPoslistOverride.AsBoolean := True;
            end;

          end;
        end;

      CRegionRule13Found:
        begin
          if RegionPosList.ValidItem(LPosListLog, AVarenr, AATCKode, LPositivMessage) <> CNotFoundInList then
          begin
            LPositivMessage := LPositivMessage + sLineBreak + sLineBreak + 'Luk boksen og vælg F7 for at se positivlisten';
            if ShowMessageBoxWithLogging(LPositivMessage, 'Vælg Ja/Nej', MB_YESNO + MB_DEFBUTTON1) = ID_YES then
              MainDm.mtLinRegelSyg.AsInteger := 13;

          end
          else
          begin
            if ShowMessageBoxWithLogging(
              'Dette varenummer/denne ATC-kode er IKKE på Positivlisten for rekvisition af lægemidler til speciallæger.' +
              sLineBreak + 'Skal der alligevel ydes tilskud i henhold til regel 13?', 'Vælg Ja/Nej',
              MB_YESNO + MB_DEFBUTTON2) = ID_YES then
              MainDm.mtLinRegelSyg.AsInteger := 13;

          end;
        end;
      CRegionRule14Found:
        begin
          if ShowMessageBoxWithLogging('Regel 14 fundet' + sLineBreak + 'Skal reglen anvendes?', 'Vælg Ja/Nej',
            MB_YESNO + MB_DEFBUTTON1) = ID_YES then
            MainDm.mtLinRegelSyg.AsInteger := CRegionRule14;

        end;
      CRegionRule16Found:
        begin
          if ShowMessageBoxWithLogging('Regel 16 fundet' + sLineBreak + 'Skal reglen anvendes?', 'Vælg Ja/Nej',
            MB_YESNO + MB_DEFBUTTON1) = ID_YES then
            MainDm.mtLinRegelSyg.AsInteger := 16;

        end;
    end;
  finally
    C2LogAdd(LPosListLog.Text);
    LPosListLog.Free;
  end;

end;

procedure THumanForm.process_EDos2;
var
  WrkS: string;
begin
  WrkS := AnsiUpperCase(Trim(EDos2.Text));
  if WrkS = '' then
    exit;
  MainDm.mtLinDosering2.AsString := WrkS;
  EDos2.Text := WrkS;
  if MainDm.ffDosTxt.FindKey([WrkS]) then
  begin
    if C2StrPrm(MainDm.C2UserName, 'Recepturdosering', '') = 'Text2' then
      // Benyt tekst2 (Dyr)
      WrkS := AnsiUpperCase(Trim(MainDm.ffDosTxtTekst2.AsString))
    else
    begin
      // Benyt tekst1 (Human)
      WrkS := AnsiUpperCase(Trim(MainDm.ffDosTxtTekst1.AsString));
      WrkS := StringReplace(WrkS, '@', FrmEntal, [rfReplaceAll]);
      WrkS := StringReplace(WrkS, '#', FrmFlertal, [rfReplaceAll]);
    end;
  end;
  meEtiketter.Lines.Add(WrkS);

end;

procedure THumanForm.Process_eYdenr;
begin

  // Ydernr
  MainDm.mtEksYderNavn.AsString := '';
  MainDm.mtEksYderNr.AsString := Trim(eYderNr.Text);

  // if we change the doctor from that on the front screen then
  // blank out cpr/ydernr field

  if MainDm.mtEksYderNr.AsString <> MainDm.ffPatKarYderNr.AsString then
    MainDm.mtEksYderCprNr.AsString := ''
  else
    MainDm.mtEksYderCprNr.AsString := MainDm.ffPatKarYderCprNr.AsString;

  if YderList then
  begin
    if Trim(MainDm.ffYdLstNavn.AsString) <> '' then
      MainDm.mtEksYderNavn.AsString := MainDm.ffYdLstNavn.AsString;
    MainDm.mtEksYderCprNr.AsString := MainDm.ffYdLstCprNr.AsString;

  end
  else
  begin
    if MainDm.ffYdLst.FindKey([eYderNr.Text]) then
    begin
      MainDm.mtEksYderNr.AsString := MainDm.ffYdLstYderNr.AsString;
      // mtEksYderCprNr.AsString := ffYdLstCprNr.AsString;
      if Trim(MainDm.ffYdLstNavn.AsString) <> '' then
        MainDm.mtEksYderNavn.AsString := MainDm.ffYdLstNavn.AsString;
    end;
  end;
  FillYderCpr;
  // mteks.Post;
  // mtEks.ApplyUpdates(-1);
  // mtEks.Refresh;
  // mtEks.Edit;

end;

procedure THumanForm.cbSubstEnter(Sender: TObject);
begin
  cbSubst.ItemIndex := MainDm.mtLinSubstValg.Value;
  if MainDm.mtLinSubstValg.Value <> 9 then
  begin
    cbSubst.Tag := 0;
    EAntal.SetFocus;
    exit;
  end;
  // Sæt cbSubst combobox som cbIndikation
  cbSubst.ItemIndex := 0;
  if not StamForm.TakserDosisKortAuto then
    MainDm.mtLinSubstValg.Value := 0;
  cbSubst.Tag := cbSubst.Width;
  cbSubst.Left := cbIndikation.Left;
  cbSubst.Width := cbIndikation.Width;
  cbSubst.ItemIndex := 0;
  cbSubst.DroppedDown := True;
  if itemsubst then
    cbSubst.ItemIndex := 1;
end;

procedure THumanForm.cbSubstExit(Sender: TObject);
begin
  MainDm.mtLinEjS.AsBoolean := MainDm.mtLinSubstValg.Value <> 0;
  if StamForm.TakserDosisKortAuto then
  begin
    if MainDm.mtLinSubstValg.Value = 5 then
    begin
      MainDm.mtLinSubstValg.Value := 0;
      MainDm.mtLinEjS.AsBoolean := False;

    end;
    // // Fjern dropdown
    // if cbSubst.DroppedDown then
    // cbSubst.DroppedDown := False;
    // // Ret control som før enter
    // if cbSubst.Width = cbIndikation.Width then begin
    // cbSubst.Width := cbSubst.Tag;
    // cbSubst.Left  := cbSubst.Left + (cbIndikation.Width - cbSubst.Width);
    // end;
    exit;
  end;

  // Fjern dropdown
  if cbSubst.DroppedDown then
    cbSubst.DroppedDown := False;
  // Ret control som før enter
  if cbSubst.Width = cbIndikation.Width then
  begin
    cbSubst.Width := cbSubst.Tag;
    cbSubst.Left := cbSubst.Left + (cbIndikation.Width - cbSubst.Width);
  end;
  // Vælg evt. fravalg
  MainDm.mtLinSubstValg.Value := cbSubst.ItemIndex;
  MainDm.mtLinEjS.AsBoolean := MainDm.mtLinSubstValg.Value <> 0;
end;

procedure THumanForm.cbIndikationKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not Key in [VK_UP, VK_DOWN] then
    exit;
  if not(Sender as TComboBox).DroppedDown then
    exit;
  if Key = VK_UP then
  begin
    if (Sender as TComboBox).ItemIndex = 0 then
    begin
      (Sender as TComboBox).ItemIndex := (Sender as TComboBox).DropDownCount - 1;
      Key := 0;
    end;
  end;
  if Key = VK_DOWN then
  begin
    if (Sender as TComboBox).ItemIndex = (Sender as TComboBox).DropDownCount - 1 then
    begin
      (Sender as TComboBox).ItemIndex := 0;
      Key := 0;
    end;
  end;
end;

procedure FillCTRBevDataset;
var
  LRegl : Integer;
begin
  MainDm.cdCtrBev.First;
  while not MainDm.cdCtrBev.Eof do
    MainDm.cdCtrBev.Delete;

  MainDm.nxCTRBev.IndexName := 'KundeNrOrden';
  MainDm.nxCTRBev.SetRange([MainDm.ffPatKarKundeNr.AsString], [MainDm.ffPatKarKundeNr.AsString]);
  try
    if MainDm.nxCTRBev.IsEmpty then
      exit;
    MainDm.nxCTRBev.First;
    while not MainDm.nxCTRBev.Eof do
    begin
      LRegl := MainDm.nxCTRBevRegel.AsInteger;
      if not (LRegl in [73..75]) then
      begin
        MainDm.cdCtrBev.Append;
        MainDm.cdCtrBevRegel.AsInteger := MainDm.nxCTRBevRegel.AsInteger;
        MainDm.cdCtrBevFraDato.AsDateTime := MainDm.nxCTRBevFraDato.AsDateTime;
        MainDm.cdCtrBevTilDato.AsDateTime := MainDm.nxCTRBevTilDato.AsDateTime;
        MainDm.cdCtrBevIndDato.AsDateTime := MainDm.nxCTRBevIndbDato.AsDateTime;
        MainDm.cdCtrBevAtc.AsString := MainDm.nxCTRBevAtc.AsString;
        MainDm.cdCtrBevLmNavn.AsString := MainDm.nxCTRBevLmNavn.AsString;
        MainDm.cdCtrBevAdmVej.AsString := MainDm.nxCTRBevAdmVej.AsString;
        MainDm.cdCtrBevVareNr.AsString := MainDm.nxCTRBevVareNr.AsString;

        MainDm.cdCtrBev.Post;
      end;
      MainDm.nxCTRBev.Next;

    end;

  finally

    MainDm.nxCTRBev.CancelRange;
  end;

end;

procedure THumanForm.cbDosTekstEnter(Sender: TObject);
var
  i: Integer;
begin
  c2logadd('    *** Dosis tekst field entered *** ');
  EtiketFieldEntered := True;
  cbDosTekst.Tag := cbDosTekst.Width;
  cbDosTekst.Width := cbIndikation.Width;
  cbDosTekst.Font.Size := 8;
  if meEtiketter.Lines.Count > 1 then
    for i := 1 to meEtiketter.Lines.Count - 1 do
      meEtiketter.Lines.Delete(1);

  if cbDosTekst.Text = '' then
  begin
    if cbDosTekst.DropDownCount > 0 then
    begin
      cbDosTekst.ItemIndex := 0;
      cbDosTekst.DroppedDown := True;
    end;
  end;
end;

procedure THumanForm.cbDosTekstKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not(Key in [VK_UP, VK_DOWN]) then
    exit;
  if not(Sender as TComboBox).DroppedDown then
    exit;
  if Key = VK_UP then
  begin
    if (Sender as TComboBox).ItemIndex = 0 then
    begin
      (Sender as TComboBox).ItemIndex := (Sender as TComboBox).DropDownCount - 1;
      Key := 0;
    end;
  end;
  if Key = VK_DOWN then
  begin
    if (Sender as TComboBox).ItemIndex = (Sender as TComboBox).DropDownCount - 1 then
    begin
      (Sender as TComboBox).ItemIndex := 0;
      Key := 0;
    end;
  end;
end;

procedure THumanForm.cbDosTekstExit(Sender: TObject);
begin
  cbDosTekst.Width := cbDosTekst.Tag;
  cbDosTekst.Tag := 0;
  cbDosTekst.Font.Size := 10;

end;

procedure THumanForm.cbIndikationExit(Sender: TObject);
begin
  cbIndikation.Font.Size := 10;

end;

procedure THumanForm.eTurNrExit(Sender: TObject);
begin
  if MainDm.mtEksTurNr.AsInteger > 0 then
    eTurNr.Color := clYellow
  else
    eTurNr.Color := clWindow;
end;

procedure THumanForm.EUdlevExit(Sender: TObject);
begin
  with MainDm do
  begin
    // if not mtEksReceptStatus.AsInteger in [1,2] then
    // exit;
    // if mtRei.RecordCount <> 0 then
    // exit;
    // if labelFirstWarn then
    // if Not ChkBoxYesNo ('is the label ok ?',true) then
    // meEtiketter.SetFocus;
    // labelFirstWarn := False;
  end;

end;

procedure THumanForm.EVareEnter(Sender: TObject);
begin
  if MainDm.mtLinHeaderCTRUpdated.AsBoolean then
  begin

//    if mtLinValideret.AsBoolean and (mtLinNySaldo.AsCurrency <> 0) then
//    begin
//
//
//      if mtLinGlSaldo.AsCurrency =  mtEksNyCtrSaldo.AsCurrency then
//        exit;
//      if mtLinGlSaldo.AsCurrency =  mtEksNyCtrSaldoB.AsCurrency then
//        exit;
//
    ChkBoxOK('Det er ikke muligt at ændre en færdigekspederet linje,' + sLineBreak
              +'Tryk enter for ny linje eller slet tidligere linje med F8.');
    buVidere.SetFocus;
    exit;
  end;


  if TakserEHAutotEnter and (maindm.mtLinLinieNr.AsInteger>1) then
  begin
    SendEnterKey(EVare.Handle);
  end;

end;

procedure THumanForm.EVareKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then
  begin
    EditVareidentKeyPress(Sender, Key);
    exit;
  end;

end;

procedure THumanForm.eYderCPRNrEnter(Sender: TObject);
begin
  eYderCPRNr.DroppedDown := True;

end;

procedure THumanForm.eYderNrEnter(Sender: TObject);
begin
  YderList := False;
end;

procedure THumanForm.btnYderClick(Sender: TObject);
begin
  YderList := True;
  YdLst;
  eYderNr.SetFocus;
end;

procedure THumanForm.acVisPositivListExecute(Sender: TObject);
var
  LRegionPosListFile : string;
begin
  LRegionPosListFile := 'G:\Temp\RegionPoslist' + MainDm.BrugerNr.ToString + '.cds';
  if FileExists(LRegionPosListFile) then
    TfrmPositivList.VisPositivlist(LRegionPosListFile);
end;

procedure THumanForm.acVisRCPExecute(Sender: TObject);
begin
  if ReceptId <> 0 then
    TRCPPrnForm.RCPView(MainDm.mtLinReceptId.AsInteger);

  if acShowPrescriptionDetails.Enabled then
    acShowPrescriptionDetails.Execute;

end;

procedure THumanForm.acLager0Execute(Sender: TObject);
begin
  StamForm.StockLager := 0;
end;

procedure THumanForm.acLager1Execute(Sender: TObject);
begin
  StamForm.StockLager := 1;
end;

procedure THumanForm.acLager2Execute(Sender: TObject);
begin
  StamForm.StockLager := 2;
end;

procedure THumanForm.acLager3Execute(Sender: TObject);
begin
  StamForm.StockLager := 3;
end;

procedure THumanForm.acLager4Execute(Sender: TObject);
begin
  StamForm.StockLager := 4;
end;

procedure THumanForm.acLager5Execute(Sender: TObject);
begin
  StamForm.StockLager := 5;
end;

procedure THumanForm.acPIBVarExecute(Sender: TObject);

var
  tmppib: PIBVarType;
  counter: Integer;
  i: Integer;
begin

  if not StamForm.PatientkartotekVareInfo then
    exit;

  counter := 0;
  for tmppib in Varelist do
    iF not tmppib.Checked then
      Inc(counter);

  if counter = 0 then
    exit;

  case MainDm.mtGroGrOplNr.AsInteger of
    1:
      PIBVarNomu.ShowVareinfo(Varelist);
    2:
      PIBvARtmjU.ShowVareinfo(Varelist);
  end;
  for i := 0 to Varelist.Count - 1 do
  begin
    tmppib := Varelist.Items[i];
    tmppib.Checked := True;
    Varelist[i] := tmppib;

  end;

end;

procedure THumanForm.acShowPrescriptionDetailsExecute(Sender: TObject);
var
  LKundeNr: string;
  LOrdId : string;
  LAfdelingNr :integer;
  LLager : integer;

  LPrescription : TC2FMKPrescription;
  LErrorstring: string;
begin
  LKundeNr := MainDm.mtEksKundeNr.AsString;
  LOrdId := MainDm.mtLinOrdId.AsString;
  LAfdelingNr := MainDm.mtEksAfdeling.AsInteger;
  LLager := MainDm.mtEksLager.AsInteger;

  LPrescription:= uFMKGetMedsById.FMKGetPrescriptionByMedId(LKundeNr,LOrdId, LAfdelingNr,LErrorstring);
  if LPrescription = Nil then
    ChkBoxOK(LErrorstring)
  else
    TfrmOrdView.ShowOrdView(LPrescription, LLager, LKundeNr);

end;

procedure THumanForm.acShowPrescriptionDetailsUpdate(Sender: TObject);
begin

  (Sender as TAction).Enabled := MainDm.mtLinOrdId.AsString <> '';

end;

procedure THumanForm.ActiveControlChanged(Sender: TObject);
begin
  FPreviousControl := FActiveControl;
  FActiveControl := Screen.ActiveControl;

  if (FPreviousControl = buVidere) and (FActiveControl= EAntal) then
  begin

    if MainDm.mtLinValideret.AsBoolean then
    begin
      ChkBoxOK('Ønskes antal ændret, da LUK ekspeditionen og start forfra.');
      FPreviousControl.SetFocus;
    end;
  end;

end;

end.
