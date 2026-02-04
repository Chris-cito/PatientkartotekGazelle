{$I bsdefine.inc}

{ Developed by: Vitec Cito A/S

  Description: Main form

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  20-03-2025/cjs  Change the passing of the bruger number from the programline to handle 4 digits.
                  Previously it was 2 digits.  This means that if the bruger number passed from programline was 112 then
                  it was truncated to 2 digits and therefore set to 11.  Error found in Randers.  Also haffects Gazelle.

  05-02-2025/cjs  New menu point / action for Takser uden ctr

  24-07-2024/CJS  Change to UpdatEHord routine to check whether there is match on ordinaton id if the ehordre
                  linier is from a prescription.  This will fix the issue where an ordre has the varenr twice but from 2
                  different prescriptions

  15-05-2024/cjs  User pris override for prescription products disabled for now

  14-05-2024/cjs  Correction to CF6 corrupt screen

  22-01-2024/cjs  Corrections to faults found during testing at Gazelle.

  20-11-2023/cjs  Added code to warn if taksering not started from Eordre tab (CF8)

  31-05-2023/cjs  Corrected the SendChillkatHttp routine be a function that returned the success or failure

  26-05-2023/cjs  Update the Eordre using https call.

  02-02-2023/cjs  Replace calls to SendC2ErrorMail with CSS logging

  19-01-2023/cjs  Corrections for use of prices if Eordre dato is not today.

  30-06-2022/cjs  Set the value of TakserC2Nr when Takser pressed in Cf8 and set to Zero when finished.
                  Pass the current c2nr into SendEordre routine.

  13-12-2021/cjs  Changes for using the new CtrTilskudSatser table

  26-08-2021/cjs  Corrected check on Fysisk line when checking user discounted price

  25-08-2021/cjs  Check that ordnations are valid before allowing them to be taksered

  12-08-2021/cjs  If takser button pressed in cf8 then setfocus on the header grid

  26-07-2021/cjs  Changes for Gazelle

  01-02-2020/cjs  Disabled the undo administration code

  29-01-2021/cjs  New function to manually undo administrations

  15-01-2021/cjs  Fix to asylansøger not gettings prescriptions under behandling

  07-01-2021/cjs  in cf8 if user has pressed ok on message screen then send eordre
                  so that the order will be printed

  21-12-2020/cjs  do not send the updated eordre when viewing / updating message

  15-12-2020/cjs  Changed the check to be on kundenr change rather than navn change
                  which can be different due to middle names etc

  15-12-2020/cjs  Remove the kundenr has changed messagebox.

  09-12-2020/cjs  Save the kundenr in the ctrl-k buffer if the prescription is
                  scanned for taksering.
                  Log and checkbox if kundenr has appeared to have changed after
                  start of taksering process.

  08-12-2020/cjs  Change konvrseksp to show dosis warning before any prescriptions
                  are handled

  20-11-2020/cjs  Changed c2kø button captions because speedbutton does not do
                  word wrap and the buttons did not look corrrect.

  12-11-2020/cjs  Removed checkeordreordinations call in Taksereh

  12-11-2020/cjs  Gazelle : if an ordination fails to start effectuation then
                  report more details and move to next line in the order rather than
                  just stop at that point!

  11-11-2020/cjs  Edifactrcp changed to keep and restore the Eh settings

  22-10-2020/cjs  Correction to alias when trying to get C2Q F5Enabled value

  22-10-2020/cjs  Renamed C2Q F5Disabled parameter to F5Enabled

  21-10-2020/cjs  Block taksering of dosis eksæpeditions in CF6

  21-10-2020/cjs  Allow download and print dosis ekspedition (blue line)
                  in CF5.  The rs_ekspeditioner and rs_eksplinier are deleted after
                  the print.

  21-10-2020/cjs  Disabe C2q næste button based on winpacer parameter

  09-10-2020/cjs  Remove the fee from the bottom of ekspedition-liste report

  07-10-2020/cjs  Correction to CF6 taksering not passing ordineret varenr and antal

  06-10-2020/cjs  Put the code back in to show selected varenummer for Gazelle

  01-10-2020/cjs  New function to calculate age of person based on cpr number or
                  foedsdato

  29-09-2020/cjs  Add the extra info to cf6 taksering to allow the ap4 checks in
                  taksering screen.

  29-09-2020/cjs  Remember the kundenr after taksering for CF5

  24-09-2020/cjs  Ehandel now correctly deals with under behandling ordinations

  10-09-2020/cjs  Problem when there is no kiundsenr passed from C2KØ. It should do
                  nothing if not in CF1. If in CF1 then point blank kunde and blank
                  out dosis info if needed.  Test box is enabled.

  09-09-2020/cjs  Blank out MOMSFRI on startup.

  09-09-2020/cjs  Disable test input box for c2kø testing

  09-09-2020/cjs  New input box to test kundenr switching from c2kø system.  Fix to
                  error when blank passed from kø system.

  08-09-2020/CJS  Switch dskar back to ffpatkar when entering CF1 fixes read only error

  07-09-2020/cjs  Add logic to show dosiskort warning if user process a fmk prescription
                  If there is no doiscard info and there is a dosisline on the
                  prescription then the usual warning is displayed.

  03-09-2020/cjs  Further work on c2kø passing kundenr.  Add the praksis name to
                  the cf5 screen

  28-08-2020/cjs  Fix to code when a message is receied from C2Kø system

  24-08-2020/cjs  Code removed which replaced Varenr with Ordination varenr in Ehandel
                  Customer has already selected the varenr and this must be honoured.
                  Also the code which updates te eordre lines after the taksering is
                  done matches the varenr bsaed on varenr or subvarenr or ordination
                  varenr.  This fixes issue where extra lines were aded to the eorder
                  because a match was not correctly found and updated.

  17-08-2020/cjs  Change to cf5 screen to allow the remova status call on prescription
                  without cprnr.

  13-08-2020/cjs  Change to dosisgrid to be grey line for 'i bero'.
                  Removed the column for 'i bero'
                  Also when cf1 is reentered if the kundenr has changed then the dosis
                  grid info is refreshed

  11-08-2020/cjs  Added packing group name to dosis card information

  10-08-2020/cjs  Changed call to get dosis info so only 10 digit kundenr are accepted

  10-08-2020/cjs  Removed code for updating dosis yder/cprnr info on doiskorts

  05-08-2020/cjs  Removed code for taksering blank cpr in CF6.

  29-07-2020/cjs  Changed text for prómpt if there is no cpr nr in CF6 taksering

  28-07-2020/cjs  Removed check on blank cpr in remove status action in CF5 CTRL-Alt-R

  21-07-2020/cjs  Added routine to check where the dosiscard is being handled at a
                  lokation mentioned in RS_Settings
  20-07-2020/cjs  Fix dosis box on main screen.

  17-07-2020/cjs  Handle exception when getting dosis info for non fmk patients
                  Added call to C2getctr if new patient added during FMK taksering
  17-07-2020/cjs  Added ffpatkar refresh to ensure latest data available.

  12-07-2020/CJS  Changed dosis information on main screen to be that from FMK

  16-06-2020/MA   Resized first panel in status panel to allow the whole Brugernr. to be shown in certain screen setups.

  04-05-2020/cjs  Use the VisRecepterCF6 property to show the number of days in CF6

  04-05-2020/cjs  If the cprnr number changes or they go back to cf6 then reset the date interval

  01-05-2020/cjs  Block the crediting of dosis ekspedition created using FMK dosis program
                  Corrected CheckEordreOrdinations to use the kundenr from the EOrdre for calls to
                  FMK.

  27-04-2020/cjs  if the doctor name on the header is blank then overwrite it with issuertitel from
                  the fmk ordination in ehandel ordders

  23-04-2020/cjs  CtrBevillinger screen fires c2getctr for latest info
                  Konvdoskort changed prompt to allow taksering of a single card if the user accepts
                  the messagebox.  in addition pakkegruppe taksering is not allowed if the card
                  exists in FMK dosiskort system
                  Eordre taksering now gets the doctor name

  21-04-2020/cjs  remnoved check for CheckEordreOrdinations logic for gazelle.
                  Requires more testing.

  15-04-2020/cjs  Changed konvdoskort to use the correct consent according to the value of privat
                  field in rs_ekspinier

  14-04-2020/cjs  Improve searching in CF6 limit date to max 60 days

  30-03-2020/cjs  KeepReceptLokalt property added. if set to Nej then locsl copy of prescription
                  is kept if removestatus is called

  23-03-2020/cjs  Rebuild to use new routinne that fixes issues with socket usage.  Also moved the
                  code that check is a user is logged in to datamodule that runs every 15 seconds.
                  Also amended dosiskort check (currently commented out)

  22-03-2020/cjs  Change drawpanel to not check the certificate of a user but if bruger<> 99 then
                  orange else grey. stops the program hittinbg the adgangserver too much

  19-03-2020/cjs  Use ansipos to check måned is specified in udlebv interval in cf5

  18-03-2020/cjs  Popup a warning if scanned receptkvittering does not exist

  18-03-2020/cjs  Valid cpr number changed to allow cprnr  > 010100-0000 and < 400000-0000

  13-03-2020/cjs  Fix to strange error in Christianshavn.  report the fmk error message when starting
                  an ordination.

  27-02-2020/cjs  Do not allow selection of prescription in cf5 if its ekspedition påbegynd

  26-02-2020/cjs  remove status on any prescriptions that were succesfully  set under behandling
                  if the list of failed is not empty

  26-02-2020/cjs  Created a list of invalid id's and report this if not empty

  24-02-2020/cjs  Use the PatPersonIdentifier and source when terminating a prescription

  21-02-2020/cjs  Corrected olor in cf6 if prescription chosen by spacebar
  21-02-2020/cjs  CF6 buttons now being passed the PatCPr/PatPersonIdentifier field from rs_ekspeditioner

  18-02-2020/cjs  Refresh bottom part of cf6 after afslut pressed

  18-02-2020/cjs  Warning on cf6 buttons if no cprnr

  18-02-2020/cjs  Add the varenr column to CF5

  14-02-2020/cjs  Correct validation of cpr number in cf5

  12-02-2020/cjs  Only extract numeric personid

  12-02-2020/cjs  Fix to function that extract PersonId correctly

  12-02-2020/cjs  Added function to extract PersonID correctly

  11-02-2020/cjs  Fix to sql after user logs in.

  11-02-2020/cjs  When i user logs in it checks if there is anything in the fejl queue with the
                  current bruger is either the takser or the afslut bruger. if there is then they
                  are automatically resubmitted to C2FMKKø.

  11-02-2020/cjs  added repaint of status bar to 10 second timer.  also dpanel is set to double
                  buffer to avoid flicker

  10-02-2020/cjs  Check 1st 6 digits of cprnr are a valid date

  10-02-2020/cjs  Check current bruger has a certificate before all fmk calls.  if sucessfully login
                  then update screen to say that else logout of program
                  Better validation of CF5 kundenr number

  04-02-2020/cjs  only set in progress if patient exists.

  03-02-2020/cjs  Commented out code for Tilbage ekspedition that checked it was an fmk dosiskort

  03-02-2020/cjs  Add date to search results for prescriptions without cprnr

  03-02-2020/cjs  Disable dosis check for fmk dosiskort

  03-02-2020/cjs  Use the patient number in PatPersonIdentifier if there is data there

  30-01-2020/cjs  Check FMKCertifikatLogon=Nej parameter in user segment to allow entry into program
                  without a certificate

  29-01-2020/CJS  Do not allow the tasering of dosis cards that are part of FMK solution

  16-01-2020/cjs  Display / print building number and middle names in CF5 search and receptoversigt

  16-01-2020/CJS  Update error text in search prescripTions CF5

  15-01-2020/cjs  Search prescriptons fix to null date + translation of english popups

  14-01-2020/cjs  Use new Drug.DrugName property

  13-01-2020/CJS  Remove unwanted calls to GetCTR

  08-01-2020/cjs  Print ordination id on prescription (used by dosis users)
                  Add hh:mm:ss to ordination dato

  12-08-2019/cjs  Danish tekst for popup in CF5 takser

  12-08-2019/cjs  BusyMouseBegin and BusyMouseEnd implemented in CF5 Takser

  12-08-2019/cjs  make sure any of the ordination id are not waiting in CF6 when takser button
                  pressed in cf5

  01-08-2019/cjs  Introduced DifferentLager to check whether we should ask the question

  01-08-2019/cjs  removed refresh on ffeksovr in tilbagefør function in cf3

  24-07-2019/cjs  Check goAuto flag if issue with patient from rs_ekspeditioner if there is an issue
                  with the patient.  This is only affect if the Afslut_i_CF5_CF6 parameter is set to Ja

  19-07-2019/cjs  Sagsnr 10289. Warn if udlevtype AP4NB like it does if AP4
  19-07-2019/cjs  Sagsnr none.  if adding a debitor to a patient then do not display MOMSFRI
  19-07-2019/cjs  Sagsnr 10198. popup if lager on ekspedition is not current lager when doing a return

  03-07-2019/cjs  if sendre is a lokation number then replace with Fxxxxxx where
                   xxxxxx is the autnr prefix with zeroes if necessary

  25-06-2019/cjs  Added code to handle lokationsnummer instead of ydernr in receptserver ordnation in
                  CF6 screen.

  21-06-2019/cjs  Added code to handle lokationsnummer instead of ydernr in receptserver ordnation

  10-05-2019/cjs  Old code to be replaced by a new sql that will stop issue with the
                  current cursor in nxREksplin being trashed by other procedure
                  such as viewing a prescription whilst waiting for the answer from receptserver


  23-08-2018/MA   Replaced the direct comparison of C2HostName and C2SERVER with the HostIsC2Server function to
                  support the new naming scheme.

  01-11-2017/CJS  CF3 sql hardcoded into program.
}

unit Main;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs,
  StdCtrls, DB, {DBTables,} DBCtrls,
  ExtCtrls, Grids, DBGrids, ComCtrls,
  DbClient,
  Buttons, Mask, OleCtrls, DateUtils,
  nxdb,
  Menus, ClipBrd,

  ActnList,
  // FileCtr,
  VareMatchLst,
  math,
  C2SApplicationData,
  C2StdMain, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, msxml, AppEvnts, generics.collections,
  RpDefine,
  OverbyteIcsHttpProt, HTTPApp,
  RpBase, RpSystem, RPBars, OverbyteIcsWndControl, C2Qbtnframeu,
  dxAlertWindow, System.Actions, cxLookAndFeelPainters,
  cxGraphics, cxClasses,
  cxLookAndFeels, cxButtons, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  frmC2Logon, uc2afdeling.Classes,  uC2FMK.Prescription.Classes,uC2Bruger.Types,uC2FMK,
  uC2FMK.DoseDispensingCard.Classes, uC2FMK.API.DoseDispensing.Procs,uC2FMK.Common.Types,
  frmFMKMedicineCardAsPDFViewer,
  uLagerKartotek.Tables, uOrdView, uFMKGetMedsById, uFMKCalls, dxBarBuiltInMenu,
  cxControls, cxPC, cxContainer, cxEdit, dxCore, cxDateUtils, cxTextEdit,
  cxMaskEdit,
  cxDropDownEdit, cxCalendar, uC2FMK.MedicineCard.Classes, cxFormats,
  uRS_Ekspqueue.Tables, uRS_EkspQueueFejl.Tables,uRS_Settings.Tables,
  uDosisTakseringer.Tables,
  uDosisKortKartotek.Tables, uC2Bruger.Logon.Procs,urs_ekspeditioner.tables, cxStyles, cxCustomData,
  cxDataStorage, cxNavigator, cxCheckBox,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridCustomView, cxGrid, uBogfoerSettings,
  Http, HttpRequest, HttpResponse, uC2Security.Chilkat.Procs, Xml,
  strutils,frmUndo,uC2Environment,uC2LLog.Types, cxFilter, cxData, dxDateRanges, dxScrollbarAnnotations;

{$I EdiRcpInc}

type
  TStamForm = class(TFrmC2StdMain)
    // TStamForm = class(TBSMainForm)
    StamPages: TcxPageControl;
    KartotekPage: TcxTabSheet;
    KartEditPanel: TPanel;
    TilskudsPage: TcxTabSheet;
    C2ButPanel: TPanel;
    C2StatusPanel: TPanel;
    C2StatusBar: TStatusBar;
    C2ButF5: TSpeedButton;
    C2ButF6: TSpeedButton;
    C2ButF7: TSpeedButton;
    C2ButF8: TSpeedButton;
    C2ButEsc: TSpeedButton;
    TilskEditPanel: TPanel;
    ButMenu: TSpeedButton;
    FunkMenu: TPopupMenu;
    MenuReRcp: TMenuItem;
    MenuGenEtiket: TMenuItem;
    MenuGenAfst: TMenuItem;
    N1: TMenuItem;
    MenuEtiket: TMenuItem;
    N3: TMenuItem;
    MenuForsendelser: TMenuItem;
    N4: TMenuItem;
    MenuTaksering: TMenuItem;
    menuDosRcp: TMenuItem;
    ActionList: TActionList;
    AcTaksering: TAction;
    AcReRcp: TAction;
    AcBogfFraTil: TAction;
    AcDosEtiket: TAction;
    AcGenEtiket: TAction;
    AcGenAfst: TAction;
    TilEditPanel: TPanel;
    DBGrid1: TDBGrid;
    TilBem: TDBMemo;
    EkspPage: TcxTabSheet;
    dbgrEksp: TDBGrid;
    N5: TMenuItem;
    UafslutPage: TcxTabSheet;
    FakturaPage: TcxTabSheet;
    dbgrUafsl: TDBGrid;
    dbgrFors: TDBGrid;
    paFaktura: TPanel;
    paUafslut: TPanel;
    butUdUaf: TBitBtn;
    paEksp: TPanel;
    butUdEksp: TBitBtn;
    butFindEksp: TBitBtn;
    eEkspLb: TEdit;
    AcUdFaktFraTil: TAction;
    Udskrivfaktura1: TMenuItem;
    AcHentFiktiv: TAction;
    HentFiktivtcprnr1: TMenuItem;
    Label32: TLabel;
    eUafKoNr: TEdit;
    butRetKonto: TBitBtn;
    MenuAfregning: TMenuItem;
    ButUdCtr: TBitBtn;
    ButUdAfsl: TBitBtn;
    butFindUaf: TBitBtn;
    Label36: TLabel;
    eUafLb: TEdit;
    laEkspGrid1: TLabel;
    laEkspGrid2: TLabel;
    laEkspGrid3: TLabel;
    laUafGrid1: TLabel;
    laFaktGrid1: TLabel;
    MenUdskrifter: TMenuItem;
    ButEtiket: TBitBtn;
    meSpcKom: TMenuItem;
    meCtrListe: TMenuItem;
    meDosListe: TMenuItem;
    meAfslListe: TMenuItem;
    meNarkoListe: TMenuItem;
    AcUdEkspListe: TAction;
    Logafforbrugerskift1: TMenuItem;
    AcHentCtrStatus: TAction;
    MenuBevillinger: TMenuItem;
    N6: TMenuItem;
    Andet1: TMenuItem;
    AcUdskrivMedk: TAction;
    Udskrivmedicinkortogbevillinger1: TMenuItem;
    AcOpdCtrSaldo: TAction;
    AcOpdCtrSaldo1: TMenuItem;
    AcUdCtrEkspListe: TAction;
    AcUdCtrUdlignListe: TAction;
    UdskrivpatientermedCTRudligning1: TMenuItem;
    AcSletMedk: TAction;
    AcAktiverCtr: TAction;
    AcEdiRcp: TAction;
    MenuEdiRcp: TMenuItem;
    acLogOff: TAction;
    acReportDesigner: TAction;
    odRave: TOpenDialog;
    AcInterAkt: TAction;
    InteraktionerprATCkode1: TMenuItem;
    acSidKundeNr: TAction;
    butKontrol: TBitBtn;
    AcRcpKontrol: TAction;
    gbRegel: TGroupBox;
    Label3: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    sbTilskud: TSpeedButton;
    Label21: TLabel;
    Label23: TLabel;
    Label34: TLabel;
    Label37: TLabel;
    TilERegel: TDBEdit;
    TilFraDato: TDBEdit;
    TilTilDato: TDBEdit;
    TilENavn: TDBEdit;
    TilEOrden: TDBEdit;
    TilEJnrChk: TDBCheckBox;
    TilEJnr: TDBEdit;
    TilAfd: TDBEdit;
    TilAfdEj: TDBEdit;
    gbBetaling: TGroupBox;
    Label13: TLabel;
    TilEAkkum: TDBEdit;
    gbPromiller: TGroupBox;
    Label15: TLabel;
    Label20: TLabel;
    TilPrm1: TDBEdit;
    TilPrm5: TDBEdit;
    AcHentDelta: TAction;
    CtrTimer: TTimer;
    gbTilskud: TGroupBox;
    Label28: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    TilAtcKode: TDBEdit;
    TilVarenr: TDBEdit;
    TilProdukt: TDBEdit;
    TilMenu: TPopupMenu;
    acTilAddAtc: TAction;
    acTilAddVarenr: TAction;
    acTilAddProdukt: TAction;
    ilfjATCkode1: TMenuItem;
    ilfjvarenr1: TMenuItem;
    ilfjprodukt1: TMenuItem;
    AcDosKort: TAction;
    AcRetLager: TAction;
    sbMatch: TSpeedButton;
    MenuAfstemp: TMenuItem;
    AcUdsAfs: TAction;
    btnNyPakke: TBitBtn;
    Label44: TLabel;
    edtLevnr: TEdit;
    btnLevnr: TButton;
    Label45: TLabel;
    edtFakLevNr: TEdit;
    btnFakLevNr: TButton;
    acOpdaterKomEan: TAction;
    Opdatertilskudmedkommuneeannumre1: TMenuItem;
    MenuEanListe: TMenuItem;
    TilEanKode: TDBEdit;
    sbTilEanKode: TSpeedButton;
    edtPakAnt: TEdit;
    Label10: TLabel;
    butRetPakAnt: TButton;
    Panel1: TPanel;
    Label12: TLabel;
    butRetPakke: TBitBtn;
    BitBtn3: TBitBtn;
    edtNr: TEdit;
    cboFors: TComboBox;
    Label11: TLabel;
    PopupUdMenu: TPopupMenu;
    UdskrivPakke1: TMenuItem;
    UdskrivFaktura2: TMenuItem;
    UdskrivLeveringsliste1: TMenuItem;
    UdskrivBudliste1: TMenuItem;
    UdskrivPrislabels2: TMenuItem;
    RSRemotePage: TcxTabSheet;
    gbCpr: TGroupBox;
    GroupBox1: TGroupBox;
    Label27: TLabel;
    Label31: TLabel;
    Label33: TLabel;
    Label35: TLabel;
    btnSearchRecept: TButton;
    ListView2: TListView;
    edtForNavn: TEdit;
    edtEftNavn: TEdit;
    edtPostNr: TEdit;
    RSLocalPage: TcxTabSheet;
    GroupBox2: TGroupBox;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    edtEftNavn1: TEdit;
    butFilter: TButton;
    dtpDatoFra: TDateTimePicker;
    dtpDatoTil: TDateTimePicker;
    edtCPRNr1: TEdit;
    edtForNavn1: TEdit;
    edtPraksis: TEdit;
    edtYdNavn: TEdit;
    edtYderNr: TEdit;
    lbLager: TComboBox;
    dbgLocalRS: TDBGrid;
    DBGrid4: TDBGrid;
    Panel2: TPanel;
    Label55: TLabel;
    btnTilbage: TButton;
    btnUdskriv: TButton;
    btnAnnul: TButton;
    edtReason: TEdit;
    btnAfslut: TButton;
    bitbtnTakser: TBitBtn;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    btnSend: TButton;
    btnSendF3: TBitBtn;
    acRemoveStatus: TAction;
    VisCTRBevllinger1: TMenuItem;
    acVisCTRBev: TAction;
    lblTime: TLabel;
    timClock: TTimer;
    lblClockDate: TLabel;
    lblClockTime: TLabel;
    acHldEtiket: TAction;
    Navneetiket1: TMenuItem;
    acUdRCP: TAction;
    Button1: TButton;
    TidyMenu: TPopupMenu;
    acTidy1: TAction;
    acTidy2: TAction;
    DeleteOldOpenPrescriptions1: TMenuItem;
    DeleteOldClosedEkspedtioner1: TMenuItem;
    Sletmedicinkortogbevillinger1: TMenuItem;
    acStregkodeKontrol: TAction;
    acBegyndBatch: TAction;
    BegyndBatchShiftCtrlB1: TMenuItem;
    Logafforbrugerskift2: TMenuItem;
    cboFind: TComboBox;
    acIndbCtr: TAction;
    IndeberetCtr1: TMenuItem;
    Label16: TLabel;
    Nyleveringslite1: TMenuItem;
    UdskrivKortLeveringsliste1: TMenuItem;
    acFejlForm: TAction;
    VisRCPKontrolSide1: TMenuItem;
    Panel3: TPanel;
    lblCF5Cprnr: TLabel;
    edtCprNr: TEdit;
    btnGetMedList: TButton;
    btnTakser: TButton;
    btnUdRapport: TButton;
    Panel4: TPanel;
    lvFMKPrescriptions: TListView;
    Panel5: TPanel;
    dbgrLinier: TDBGrid;
    dbgrTilskud: TDBGrid;
    Panel6: TPanel;
    Panel7: TPanel;
    EBem: TDBMemo;
    Panel8: TPanel;
    DBGrid2: TDBGrid;
    Panel9: TPanel;
    gbInstans: TGroupBox;
    Label22: TLabel;
    sbKommune: TSpeedButton;
    Label24: TLabel;
    KartLDKMedlem: TLabel;
    KartLOpretDato: TLabel;
    KartLRetDato: TLabel;
    Label29: TLabel;
    EAmt: TDBEdit;
    EKommune: TDBEdit;
    ENetto: TDBCheckBox;
    EjSubst: TDBCheckBox;
    EKomNavn: TDBEdit;
    EOpretDato: TDBEdit;
    ERetDato: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    EDanmark: TDBComboBox;
    gbCtr: TGroupBox;
    Label6: TLabel;
    Label26: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    ECtrSaldo: TDBEdit;
    ECtrUdlign: TDBEdit;
    ECtrStempel: TDBEdit;
    ECtrStatus: TDBEdit;
    ECtrUdDato: TDBEdit;
    ECtrType: TDBEdit;
    acVisRS: TAction;
    Label17: TLabel;
    Label18: TLabel;
    Label30: TLabel;
    acOpdCTR: TAction;
    VisOpdaterCTRStatus1: TMenuItem;
    Label60: TLabel;
    edtLevListNr: TEdit;
    btnRetLevListNr: TButton;
    MnuReprintleveringslist1: TMenuItem;
    MnuGenudskrivKortLeveringsliste: TMenuItem;
    dtpTidFra: TDateTimePicker;
    dtpTidTil: TDateTimePicker;
    acDebEkspKontrol: TAction;
    AktiverDeaktiverCTR1: TMenuItem;
    acRetYdernr: TAction;
    Label61: TLabel;
    edtRetYderNr: TEdit;
    bitRetYdernr: TBitBtn;
    Label62: TLabel;
    edtRetAutNr: TEdit;
    acGenBothEtiket: TAction;
    acGenBothEtiket1: TMenuItem;
    acInfert: TAction;
    InfertTaksering1: TMenuItem;
    acArkiverKunde: TAction;
    Arkiverenkeltkundenummer1: TMenuItem;
    pnlTopleft: TPanel;
    gbUdst: TGroupBox;
    KartLYderNr: TLabel;
    sbYderNr: TSpeedButton;
    Label1: TLabel;
    Label25: TLabel;
    EYderNr: TDBEdit;
    EYderCprNr: TDBEdit;
    EYdNavn: TDBEdit;
    gbNavn: TGroupBox;
    KartLAdr1: TLabel;
    KartLPostNr: TLabel;
    sbPostNr: TSpeedButton;
    KartLTlfNr: TLabel;
    KartLNavn: TLabel;
    Label7: TLabel;
    KartLDebNr: TLabel;
    sbDebNr: TSpeedButton;
    KartLDebSaldo: TLabel;
    Label41: TLabel;
    sbLevNr: TSpeedButton;
    dbtPBS: TDBText;
    EAdr1: TDBEdit;
    EAdr2: TDBEdit;
    EPostNr: TDBEdit;
    EBy: TDBEdit;
    ETlfNr: TDBEdit;
    ENavn: TDBEdit;
    EDebNavn: TDBEdit;
    EDebNr: TDBEdit;
    EDebSaldo: TDBEdit;
    ELevNr: TDBEdit;
    ELevNavn: TDBEdit;
    gbIdent: TGroupBox;
    KartLKontoNr: TLabel;
    sbCprNr: TSpeedButton;
    Label19: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    ECprChk: TDBCheckBox;
    EFiktiv: TDBCheckBox;
    EDato: TDBEdit;
    EBarn: TDBCheckBox;
    EModtager: TDBEdit;
    EKundeNr: TEdit;
    ECtrLand: TDBLookupComboBox;
    EKundeType: TDBComboBox;
    pnlBtnLeft: TPanel;
    gbDosis: TGroupBox;
    acEfterReg: TAction;
    EfterregistrerCTRmedregel421: TMenuItem;
    acEHandle: TAction;
    akserEHandleOrdrer1: TMenuItem;
    tsEHandel: TcxTabSheet;
    Panel10: TPanel;
    Panel11: TPanel;
    Label63: TLabel;
    edtCPR: TEdit;
    btnFilter: TButton;
    pnlEHButtons: TPanel;
    btnSkiftStatus: TButton;
    btnBeskeder: TButton;
    btnSendKvit: TButton;
    btnPrint: TButton;
    btnEHTakser: TButton;
    dbgEHOrd: TDBGrid;
    Panel13: TPanel;
    dbgEHLin: TDBGrid;
    RPEHPrint: TRvSystem;
    lblehlin: TLabel;
    lblehord: TLabel;
    acRCPSearch: TAction;
    SearchRCPOrdinationsforVarenr1: TMenuItem;
    Label65: TLabel;
    eMobil: TDBEdit;
    IdHTTP1: TIdHTTP;
    chkAabenEordre: TCheckBox;
    dtpEhstart: TDateTimePicker;
    dtpEhSlut: TDateTimePicker;
    Label66: TLabel;
    Label67: TLabel;
    btnSMS: TButton;
    acSendSMS: TAction;
    btnTurNr: TButton;
    edtTurnr: TEdit;
    Label68: TLabel;
    acKontrolSMS: TAction;
    SendKontrolSMS1: TMenuItem;
    lblCPrNvn: TLabel;
    TC2QFrame1: TC2QFrame;
    lblC2Q: TLabel;
    lblCF5name: TLabel;
    acRSEkspFejl: TAction;
    VisReceptserverFejl1: TMenuItem;
    dxAlertWindowManager1: TdxAlertWindowManager;
    cboVisDosis: TComboBox;
    Label14: TLabel;
    acHenstandsOrdning: TAction;
    Henstandsordning1: TMenuItem;
    btnUdsDosiskort: TButton;
    cxBtnUdskriv: TcxButton;
    ActionManager1: TActionManager;
    acTabKartotek: TAction;
    acTabTilskud: TAction;
    acTabEksp: TAction;
    acTabUaf: TAction;
    acTabReceptserver: TAction;
    acTabLokale: TAction;
    acTabFaktura: TAction;
    acTabEhandel: TAction;
    acAltDown: TAction;
    acFkeysFortryd: TAction;
    acFkeysGem: TAction;
    acFkeysRet: TAction;
    acFkeysOpret: TAction;
    acFkeysSlet: TAction;
    acStdSlet: TAction;
    acSletButton: TAction;
    ECtrBSaldo: TDBEdit;
    ECtrBUdlign: TDBEdit;
    ECtrBUdDato: TDBEdit;
    acLevlisteBon: TAction;
    acUdlevDMVSLevliste: TAction;
    cxBtnDMVS: TcxButton;
    DMVSMenu: TPopupMenu;
    UdlevDMVSlevliste2: TMenuItem;
    UdlevDMVSlevliste3: TMenuItem;
    acTilskudRegel: TAction;
    acTilskudEankode: TAction;
    acTilskudVare: TAction;
    acCF3Find: TAction;
    acCF3VisEtiket: TAction;
    acCF3SendRS: TAction;
    acCF3Tilbage: TAction;
    AcCF3UdEkspListe: TAction;
    AcCF3UdCtrEkspListe: TAction;
    acCF4FindUaf: TAction;
    acCF4RetKonto: TAction;
    acCF4Levnr: TAction;
    acCF4NyPakke: TAction;
    acCF4UdUaf: TAction;
    acCF4RetYdernr: TAction;
    lblMomsType: TLabel;
    btnSoegCPR: TButton;
    acSoegCPR: TAction;
    cxDateFoedselsdato: TcxDateEdit;
    chkUdenCPR: TCheckBox;
    btnHentOrdination: TButton;
    acHentOrdination: TAction;
    cxGridDDCards: TcxGrid;
    cxGridDDCardsTableView1: TcxGridTableView;
    cxGridDDCardsTableView1Column1: TcxGridColumn;
    cxGridDDCardsTableView1Column2: TcxGridColumn;
    cxGridDDCardsTableView1Column3: TcxGridColumn;
    cxGridDDCardsLevel1: TcxGridLevel;
    acVisDDKort: TAction;
    cxGridDDCardsTableView1Column4: TcxGridColumn;
    acTestMess: TAction;
    acUndoEffectuation: TAction;
    acTakserUdenCtr: TAction;
    MenuTakserUdenCtr: TMenuItem;
    procedure KeyHandler(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure KartotekPageExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StamF5Handler;
    procedure StamF6Handler;
    procedure StamF7Handler;
    procedure StamF8Handler;
    procedure StamEscHandler;
    procedure TilF5Handler;
    procedure sbClick(Sender: TObject);
    procedure DropDown(Sender: TObject);
    procedure EKundeTypeExit(Sender: TObject);
    procedure StamPagesEnter(Sender: TObject);
    procedure EFiktivExit(Sender: TObject);
    procedure ButMenuClick(Sender: TObject);
    procedure ReitererRcp(LbNr: LongWord);
    procedure MenuReRcpClick(Sender: TObject);
    procedure MenuGenEtiketClick(Sender: TObject);
    procedure MenuGenAfstClick(Sender: TObject);
    procedure MenuDosEtiketClick(Sender: TObject);
    procedure MenuBogfFraTilClick(Sender: TObject);
    procedure MenuTakseringClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    // procedure AcKonvPatExecute(Sender: TObject);
    // procedure AcDeletePatExecute(Sender: TObject);
    // procedure AcDeleteEkspExecute(Sender: TObject);
    procedure EkspPageExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure UafslutPageExit(Sender: TObject);
    procedure PakkePageEnter(Sender: TObject);
    procedure PakkePageExit(Sender: TObject);
    procedure FakturaPageExit(Sender: TObject);
    procedure KontoPageEnter(Sender: TObject);
    procedure KontoPageExit(Sender: TObject);
    procedure butFindKontoClick(Sender: TObject);
    procedure butFindFaktClick(Sender: TObject);
    procedure butFindPakkeClick(Sender: TObject);
    procedure AcUdFaktFraTilExecute(Sender: TObject);
    procedure butUdFaktClick(Sender: TObject);
    procedure butRetPakkeClick(Sender: TObject);
    procedure butUdPakkeClick(Sender: TObject);
    procedure AcHentFiktivExecute(Sender: TObject);
    procedure meSpcKomClick(Sender: TObject);
    procedure ButUdCtrClick(Sender: TObject);
    procedure meAfslListeClick(Sender: TObject);
    procedure ButUdPakLstClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure meDosListeClick(Sender: TObject);
    procedure meNarkoListeClick(Sender: TObject);
    procedure butGenCtrClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    function UserLogon: Boolean;
    procedure AcOpdCtrSaldoExecute(Sender: TObject);
    procedure AcHentCtrStatusExecute(Sender: TObject);
    procedure AcUdskrivMedkExecute(Sender: TObject);
    procedure ButKonPrisClick(Sender: TObject);
    procedure AcSletMedkExecute(Sender: TObject);
    procedure AcAktiverCtrExecute(Sender: TObject);
    procedure AcEdiRcpExecute(Sender: TObject);
    procedure KonvRSEksp(aReceptId: LongWord; TabSheet: TcxTabSheet;
      ABarcodeScanned: Boolean = False; AKundenr: string = ''; APromptUserWhenDDCardExists: Boolean = True);
    function EdifactRcp(EdiPtr: Pointer; TabSheet: TcxTabSheet; ABlankKundenr : boolean= False ): Boolean;
    procedure acLogOffExecute(Sender: TObject);
    procedure acReportDesignerExecute(Sender: TObject);
    procedure AcInterAktExecute(Sender: TObject);
    procedure acSidKundeNrExecute(Sender: TObject);
    procedure AcRcpKontrolExecute(Sender: TObject);
    procedure ButUdTurLstClick(Sender: TObject);
    procedure ButUdTurLst2Click(Sender: TObject);
    procedure AcHentDeltaExecute(Sender: TObject);
    procedure CtrTimerTimer(Sender: TObject);
    procedure AcDosKortExecute(Sender: TObject);
    function KonvDosKort(LbNr: LongWord; TabSheet: TcxTabSheet; APakkeGruppe : boolean=False): Boolean;
    procedure AcRetLagerExecute(Sender: TObject);
    procedure TilskudsPageExit(Sender: TObject);

    procedure OnCdsRange(Sender: TObject; ADataSet: TDataSet;
      const StartValues, EndValues: array of const);
    procedure OnCdsSearch(Sender: TObject; ADataSet: TDataSet;
      const AValue: Variant; AFieldType: string);
    procedure OnSetRange(Sender: TObject; ADataSet: TDataSet;
      const StartValues, EndValues: array of const);
    procedure OnDoSearch(Sender: TObject; ADataSet: TDataSet;
      const AValue: Variant; AFieldType: string);
    procedure MenuAfstempClick(Sender: TObject);
    procedure btnFakLevNrClick(Sender: TObject);
    procedure acOpdaterKomEanExecute(Sender: TObject);
    procedure butRetPakAntClick(Sender: TObject);
    procedure btnGetMedListClick(Sender: TObject);
    procedure lvFMKPrescriptionsDblClick(Sender: TObject);
    procedure VisOrdCprNr;
    procedure cboForsClick(Sender: TObject);
    procedure btnTakserClick(Sender: TObject);
    procedure btnSearchReceptClick(Sender: TObject);
    procedure butFilterClick(Sender: TObject);
    procedure dbgLocalRSTitleClick(Column: TColumn);
    procedure btnUdskrivClick(Sender: TObject);
    procedure btnAnnulClick(Sender: TObject);
    procedure btnTilbageClick(Sender: TObject);
    procedure btnAfslutClick(Sender: TObject);
    procedure bitbtnTakserClick(Sender: TObject);
    procedure SearchBarcode(barcodestr: string);
    procedure btnUdRapportClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure acRemoveStatusExecute(Sender: TObject);
    procedure acVisCTRBevExecute(Sender: TObject);
    procedure timClockTimer(Sender: TObject);
    procedure acHldEtiketExecute(Sender: TObject);
    procedure acUdRCPExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure acTidy1Execute(Sender: TObject);
    procedure acTidy2Execute(Sender: TObject);
    procedure C2StatusBarDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure acBegyndBatchExecute(Sender: TObject);
    procedure dbgrEkspDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgrUafslDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure acIndbCtrExecute(Sender: TObject);
    procedure dbgrLinierDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure acFejlFormExecute(Sender: TObject);
    procedure lvFMKPrescriptionsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure Panel5Resize(Sender: TObject);
    procedure dbgLocalRSDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid4DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure acVisRSExecute(Sender: TObject);
    procedure acOpdCTRExecute(Sender: TObject);
    procedure btnRetLevListNrClick(Sender: TObject);
    procedure MnuReprintleveringslist1Click(Sender: TObject);
    procedure MnuGenudskrivKortLeveringslisteClick(Sender: TObject);
    procedure acDebEkspKontrolExecute(Sender: TObject);
    procedure acRetYdernrExecute(Sender: TObject);
    procedure bitRetAutNrClick(Sender: TObject);
    procedure acGenBothEtiketExecute(Sender: TObject);
    procedure lvFMKPrescriptionsCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure acArkiverKundeExecute(Sender: TObject);
    procedure lvFMKPrescriptionsCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lvFMKPrescriptionsItemChecked(Sender: TObject; Item: TListItem);
    procedure EKundeTypeEnter(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure acEfterRegExecute(Sender: TObject);
    procedure dbgLocalRSKeyPress(Sender: TObject; var Key: Char);
    procedure acEHandleExecute(Sender: TObject);
    procedure btnSkiftStatusClick(Sender: TObject);
    procedure btnBeskederClick(Sender: TObject);
    procedure btnSendKvitClick(Sender: TObject);
    procedure dbgEHOrdDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnPrintClick(Sender: TObject);
    procedure RPEHPrintPrint(Sender: TObject);
    procedure btnEHTakserClick(Sender: TObject);
    procedure acRCPSearchExecute(Sender: TObject);
    procedure btnFilterClick(Sender: TObject);
    procedure acSendSMSExecute(Sender: TObject);
    procedure btnTurNrClick(Sender: TObject);
    procedure acKontrolSMSExecute(Sender: TObject);
    procedure acC2QExecute(Sender: TObject);
    procedure TC2QFrame1bitHkbClick(Sender: TObject);
    procedure acRSEkspFejlExecute(Sender: TObject);
    procedure acHenstandsOrdningExecute(Sender: TObject);
    procedure TC2QFrame1bitNaesteClick(Sender: TObject);
    procedure KartotekPageEnter(Sender: TObject);
    procedure TilskudsPageEnter(Sender: TObject);
    procedure EkspPageEnter(Sender: TObject);
    procedure UafslutPageEnter(Sender: TObject);
    procedure FakturaPageEnter(Sender: TObject);
    procedure tsEHandelEnter(Sender: TObject);
    procedure RSLocalPageShow(Sender: TObject);
    procedure RSRemotePageShow(Sender: TObject);
    procedure acStregkodeKontrolExecute(Sender: TObject);
    procedure acTabKartotekExecute(Sender: TObject);
    procedure acTabTilskudExecute(Sender: TObject);
    procedure acTabEkspExecute(Sender: TObject);
    procedure acTabUafExecute(Sender: TObject);
    procedure acTabReceptserverExecute(Sender: TObject);
    procedure acTabLokaleExecute(Sender: TObject);
    procedure acTabFakturaExecute(Sender: TObject);
    procedure acTabEhandelExecute(Sender: TObject);
    procedure acAltDownExecute(Sender: TObject);
    procedure acFkeysGemExecute(Sender: TObject);
    procedure acFkeysRetExecute(Sender: TObject);
    procedure acFkeysOpretExecute(Sender: TObject);
    procedure acFkeysSletExecute(Sender: TObject);
    procedure acFkeysFortrydExecute(Sender: TObject);
    procedure acFkeysGemUpdate(Sender: TObject);
    procedure acFkeysRetUpdate(Sender: TObject);
    procedure acFkeysOpretUpdate(Sender: TObject);
    procedure acFkeysSletUpdate(Sender: TObject);
    procedure acFkeysFortrydUpdate(Sender: TObject);
    procedure acStdSletExecute(Sender: TObject);
    procedure edtCprNrKeyPress(Sender: TObject; var Key: Char);
    procedure EYderCprNrKeyPress(Sender: TObject; var Key: Char);
    procedure eUafLbKeyPress(Sender: TObject; var Key: Char);
    procedure eEkspLbKeyPress(Sender: TObject; var Key: Char);
    procedure EKundeNrKeyPress(Sender: TObject; var Key: Char);
    procedure acStdSletUpdate(Sender: TObject);
    procedure acSletButtonExecute(Sender: TObject);
    procedure acSletButtonUpdate(Sender: TObject);
    procedure acLevlisteBonExecute(Sender: TObject);
    procedure dbgrForsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);
    procedure acUdlevDMVSLevlisteExecute(Sender: TObject);
    procedure acTilskudRegelExecute(Sender: TObject);
    procedure acTilskudEankodeExecute(Sender: TObject);
    procedure acTilskudVareExecute(Sender: TObject);
    procedure acCF3FindExecute(Sender: TObject);
    procedure acCF3VisEtiketExecute(Sender: TObject);
    procedure acCF3SendRSExecute(Sender: TObject);
    procedure acCF3TilbageExecute(Sender: TObject);
    procedure AcCF3UdEkspListeExecute(Sender: TObject);
    procedure AcCF3UdCtrEkspListeExecute(Sender: TObject);
    procedure acCF4FindUafExecute(Sender: TObject);
    procedure acCF4RetKontoExecute(Sender: TObject);
    procedure acCF4LevnrExecute(Sender: TObject);
    procedure acCF4NyPakkeExecute(Sender: TObject);
    procedure acCF4UdUafExecute(Sender: TObject);
    procedure acCF4RetYdernrExecute(Sender: TObject);
    procedure acSoegCPRExecute(Sender: TObject);
    procedure acSoegCPRUpdate(Sender: TObject);
    procedure StamPagesChanging(Sender: TObject; var AllowChange: Boolean);
    procedure StamPagesPageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure acHentOrdinationUpdate(Sender: TObject);
    procedure acHentOrdinationExecute(Sender: TObject);
    procedure edtCPRNr1KeyPress(Sender: TObject; var Key: Char);
    procedure acVisDDKortExecute(Sender: TObject);
    procedure acVisDDKortUpdate(Sender: TObject);
    procedure cxGridDDCardsTableView1CustomDrawCell(Sender: TcxCustomGridTableView;
      ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure dbgrEkspDblClick(Sender: TObject);
    procedure acTestMessExecute(Sender: TObject);
    procedure TC2QFrame1bitRecClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure acUndoEffectuationExecute(Sender: TObject);
    procedure acTakserUdenCtrExecute(Sender: TObject);

    // procedure Button1Click(Sender: TObject);
    // procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    TilladKrediteringAfReturEksp: Boolean;
    GoAuto: Boolean;
    NavneEtiketCount: Integer;
    UseInfertTakser: Boolean;
    CF6Selected: Tlist<TBookmark>;
    RCPTakserCompleted: Boolean;
    AlertRSFejlwin: TdxAlertWindow;
    BlankPreviousCustomer: Boolean;
    KonvRSEkspBusy: Boolean;
    FSaveTabsheet: Integer;
    FAfdelNavn: string;
    CF6_SaveCPRNr : string;
    FCF1KundeNr: string;
    procedure WMCopyData(var Msg: TWMCopyData); message WM_COPYDATA;
    procedure WMSetButtons(var Msg: TMessage); message WM_SetButtons;
    procedure WMGetEdifact(var Msg: TMessage); message WM_GetEdifact;
    procedure WMGetDosisPak(var Msg: TMessage); message WM_GetDosisPak;
    procedure WMSkiftBruger(var Msg: TMessage); message WM_SkiftBruger;
    procedure WndProc(var Message: TMessage); override;
    function GetCTR(const AKundeNr: string) : Boolean;
    procedure StartBatch;
    procedure CheckBatch;
    procedure CheckBatchLogon;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure AppDeactivate(Sender: TObject);
    procedure konvCDSBatch(ATabSheet: TcxTabSheet);
    procedure RefreshDoseDispensingCardsList(APersonId: string; APersonIdSource: TFMKPersonIdentifierSource);
    procedure TakserEh(AC2Nr: Integer);
    procedure CMDialogKey(var AMessage: TCMDialogKey); message CM_DIALOGKEY;
    procedure RefreshCF1WithBlankKundenr;
    function HttpPostStuff(const AEndpoint: string; const ARequestXml: WideString; const AApotekId: string;
      out AResponseXml, AErrorMessage: string): boolean;
    procedure PaLst;
    procedure InLst;
    procedure YdLst;
    procedure YdCprLst;
    procedure DeLst;
    procedure LeLst;
    procedure ReLst;
    procedure VmLst;
    procedure KmLst;
    property SaveTabsheet: Integer read FSaveTabsheet write FSaveTabsheet;
    procedure HandleLevListe;
    function CheckMedIdInCF6(MedId: string): Boolean;
    procedure UpdateListview;
    procedure ResubmitFMKCertificateErrors(ABrugerNr : integer);
    procedure DeleteLocalPrescription(AReceptId : integer;APrescriptionId: Int64);
    property CF1KundeNr: string read FCF1KundeNr write FCF1KundeNr;
    function CalculateAgeInYears(aCPRNr : string;aBirthDate : string = '') : integer;
    procedure PrintDosisEkspedition(APrescriptionId : string);
  public
    { Public declarations }
    DosEtiket: TStringList;
    SidKundeNr, FraKontoNr, TilKontoNr: String;
    SidPakkeNr, FraFakturaNr, TilFakturaNr: LongWord;
    TakserActive, FirstTime, CloseAtOnce, CallEnabled: Boolean;
    FLagerNr,  FPladsNr: Word;
    PrintAllAFSLabel: Boolean;
    ReceptServerPrescription: Boolean;
    ProgramFolder: string;

    // Robot Parameters
    RobotSection: string;
    RowaEnabled: Boolean;
    RowaLokation: Integer;
    RowaOrdre: Boolean;
    RowaGemOrdre: Boolean;
    ReceptServer: Boolean;
    DebitorPopup: Boolean;
    Spoerg_Lager_Debitor: Boolean;
    DebitorPopupType: array [1 .. 10] of Integer;
    DebitorPopupAutoret: Boolean;
    FPemUserName, FPemPassWord: String;
    save_ediNr: Integer;
    Save_Datofra: TDate;
    Save_lbLagerIndex: Integer;
    ProgramVersion: string;
    ProgramVersTestCount: Integer;
    LogoffTimer: Integer;
    AllowLogoff: Boolean;
    LastInput: TDateTime;
    AppDeactivated: Boolean;
    Pris_CTR_ekspliste: string;
    Pris_ekspliste: string;
    Afslut_i_CF5_CF6: Boolean;
    SkaffevareBar: string;
    VetNettoPris: Boolean;
    VetDebgruppeStr: string;
    VetDebGruppe: array [1 .. 10] of Integer;
    VetGebyrNr: string;
    VetProcent: Currency;
    FakturaLinierUdenMoms: Boolean;
    ReceptAddrPopup: Boolean;
    ReceptAddrPopupAlle: Boolean;
    BatchStarted: Boolean;
    Regel_76_Tilskudspris: Boolean;
    CitoEkspeditionAktiv: Boolean;
    Spoerg_AutorisationsNr: Boolean;
    Spoerg_YderNr: Boolean;
    Pakkeliste_sorteret_efter_pakkenr: Boolean;
    FullScreen: Boolean;
    TakserDosisKortAuto: Boolean;
    Undladafstemplingsetiketter: Boolean;
    TakserDosisKortManual: Boolean;
    GemNyeRsFornavnEfternavn: Boolean;
    Udskriv_recept_pop_up: Boolean;
    LogAfTid: Integer;
    CF3Lbnr: Integer;
    SpoergReservation: Boolean;
    StockLager: Integer;
    Save_StockLager: Integer;
    EdiIntervalAdvarsel: Boolean;
    QuestionAskedAboutOpenRCP: Boolean;
    HentDosisIndikationsForslag: Boolean;
    JumpToZeroLbnr: Boolean;
    VisUdlevStoerreEndMax: Boolean;
    CF5Ordlist: TStringList;
    DosisPakkeGruppeFileName: string;
    HaltProgram: Boolean;
    EHSendKvitt: Boolean;
    SpoergSendFakturaElektronisk: Boolean;
    C2ServerAdresse: string;
    Terminal_HK_Spoerg_SS_tilskud: Boolean;
    AfstemplingForHverReceptkvittering: Boolean;
    SpoergOmGemKontonr: Boolean;
    SpoergOmGemYdernr: Boolean;
    TakserPaaEordrenr: Boolean;
    Save_EordreNr: string;
    SpoergAutorisationsnrKorrekt: Boolean;
    SpoergEhandelKvittering: Boolean;
    SpoergYdernrNBS: Boolean;
    DosisAutoEnterF6: Boolean;
    DosisAskQuestions: Boolean;
    NulPakkeTilBud: Boolean;
    DosisAutoEkspSpoergUdbringningsGebyr: Boolean;
    SMSServer: string;
    SMSAktiv: Boolean;
    DosisAutoStopIkkeVedBemaerkning: Boolean;
    Dosis_Auto_Udbringningsgebyr: Boolean;
    PrinterServerIP: string;
    C2QEnabled: Boolean;
    C2QButtonPressed: Boolean;
    VareInfo: Boolean;
    PatientkartotekVareInfo: Boolean;
    UdlBegrKunTilSygehus: Boolean;
    Kronikerekstrabetaling: Boolean;
    DosisBatchMode: Boolean;
    AfdelingLMSNr: string;
    procedure AddLbnrToBatch(LbNr: LongWord);
    procedure CheckMoreOpenRCP(ABefore: Boolean);
    function AskAboutOpenRCP(Pakkenr: Integer): Boolean;
    procedure CheckFor0Ekspedition(strLevnr: string);
    procedure SendEOrdre(AC2Nr : integer);
    function HTTPSendEordre(xmlstr: WideString): Boolean;
    property AfdelNavn: string read FAfdelNavn write FAfdelNavn;
    function SendChilkatHttp(const AHTTPSUrl, AXMLString: WideString; const AApotekId: string): Boolean;
    procedure UpdateStatusBrugerInfo;
    function CalculateUdstederType(const AUdstederTypeString: string): integer;

  end;
const
  // column numbers for CF5 top listview
  lvFMKDato=0;
  lvFMKAdminDato=1;
  lvFMKBeskrivelse=2;
  lvFMKAntal=3;
  lvFMKMax=4;
  lvFMKUdlev=5;
  lvFMKIneterval = 6;
  lvFMKStatus=7;
  lvFMKYder=8;
  lvFMKPraksis=9;
  lvFMKApotek=10;
  lvFMKDosis=11;
  lvFMKPrivat=12;
  lvFMKReceptId=13;
  lvFMKVarenr=14;
  lvFMKLokation=15;
  lvFMKValidFra=16;
  lvFMKValidTil=17;
  lvFMKRSLbnr=18;
  lvPersonId = 19;
  lvPersonIdSource = 20;
  lvFMKNLastSubitem = lvPersonIdSource;
  SEHordreTakserWarning = 'Taksation påbegyndes normalt fra Ehandel[CF8]. Ønsker du at fortsætte?';
var
  StamForm: TStamForm;

implementation

uses
  // TMSClientApi,
  // stBCD,
  ChkBoxes,
  C2MainLog,
  C2WinApi,
  C2Procs,
  C2Date,
  uc2ui.procs,
  uC2Ui.MainLog.Procs,
  RcpProcs,
  DM,
  // AutoTilbRcp,
//  BrugerLogon,
  TakserHuman,
  TakserLeverancer,
  TakserAfslut,
  ReRecept,
  SoegRecept,
  // TilskLst,
  InstLst,
  // VareMatchLst,
  DebitorLst,
  PatientLst,
  RegelLst,
  YderLst,
  PostnrLst,
  // KonvPatienter,
  FriDosEtiket,
  OpdaterKonti,
  UdskrivFakturaLaser,
  UdskrivPakkeLaser,
  LaserFormularer,
  HentFraTilDato,
  HentFraTilDatoTid,
  SletMedkort,
  CtrBevOversigt,
  UdskBevillinger,
  MidClientApi,

  VisInteraktion,
  // EdifactRecepter,
  KommuneAfregning,
  ValgForsendelse,
  UbiPrinter,

  C2Splash, frmKomLst, uRCPMidCli, uCPRlist,
  uRCPTidy, RCPPrinter, uYesNo, uGebyr, uFejl, uOpdCTR,
  uVaelgLevliste, uDebKontrol,
  uArkivKunde, uDosCard, ufrmStatus, ufrmBeskeder, ufrmKvittering, uRCPSearch,
  SendSMS, TakserDosis, frmDosis, PatMatrixPrinter,
  SMSDMu, C2Qtnsu, RSEkspFejlu, frmHenstandsOrdning, uCTRUdskriv, uEkspUdsriv,
  uRS_EkspLinier.Tables,uEHOrdreLinier.tables, uehordreHeader.tables,
  uc2Common.procs, uUdlevDMVSLevliste,frmC2CtrCountryList, ucf3.procs; // TakserDosis;

{$R *.DFM}

procedure TStamForm.WMSetButtons(var Msg: TMessage);
begin
  MainDm.C2Buttons;
end;

procedure TStamForm.WndProc(var Message: TMessage);
begin
  if Message.Msg = C2_GetEdifact then
  begin
    PostMessage(Handle, WM_GetEdifact, Message.WParam, Message.LParam);
    Message.Result := 1;
  end;
  if Message.Msg = C2_GetDosisPak then
  begin
    PostMessage(Handle, WM_GetDosisPak, Message.WParam, Message.LParam);
    Message.Result := 1;
  end;
  if Message.Msg = WM_ACTIVATE then
  begin
    // C2LogAdd('wm_activate caught ' + inttostr(Message.WParam));
    if Message.WParam = WA_INACTIVE then
      AppDeactivated := True
    else
      AppDeactivated := False;
  end;
  inherited WndProc(Message);
end;

procedure TStamForm.WMGetEdifact(var Msg: TMessage);
var
  EdiLbNr: Integer;
  SaveIdx: String;
begin

  c2logadd('WMGetEdifact message received');
  if KonvRSEkspBusy then
    exit;
  EdiLbNr := Msg.WParam;
  SaveIdx := MainDm.nxRSEksp.IndexName;
  MainDm.nxRSEksp.IndexName := 'ReceptIdOrder';
  try
    if MainDm.nxRSEksp.FindKey([EdiLbNr]) then
      KonvRSEksp(EdiLbNr, StamPages.ActivePage);
  finally
    MainDm.nxRSEksp.IndexName := SaveIdx;
  end;
end;

procedure TStamForm.WMGetDosisPak(var Msg: TMessage);
var
  DosLbNr: Integer;
begin
  DosLbNr := Msg.WParam;
  // Kald dosiskort behandling
  DosisBatchMode := False;
  KonvDosKort(DosLbNr, StamPages.ActivePage);
end;

procedure TStamForm.StamPagesChanging(Sender: TObject; var AllowChange: Boolean);
begin
  AllowChange := True;
  if MainDm.Bruger.HasUserCertificate then
    exit;

  if (StamPages.ActivePage = RSRemotePage) or (StamPages.ActivePage = RSLocalPage) then
    AllowChange := False

end;

procedure TStamForm.StamPagesEnter(Sender: TObject);

begin
  MainDm.dsStateChange(MainDm.dsPatKar);
    // ffPatKar.FindKey([KundeKeyBlk]);
end;

procedure TStamForm.StamPagesPageChanging(Sender: TObject; NewPage: TcxTabSheet;
  var AllowChange: Boolean);
begin
  C2LogAdd('New page is ' + NewPage.Name);
  if (MainDm.Bruger.HasUserCertificate) and (MainDm.Bruger.SOSIIdIsValid) then
  begin
    btnAnnul.Enabled := true;
    btnTilbage.Enabled := True;
    btnAfslut.Enabled := True;
    bitbtnTakser.Enabled := True;
    btnSend.Enabled := True;
    AllowChange := True;
    exit;
  end;


  if (NewPage = RSRemotePage)  then
  begin
    acLogOff.Execute;
    if Application.Terminated then
    begin
      AllowChange := False;
      exit;
    end;
    if (MainDm.Bruger.HasUserCertificate) and (MainDm.Bruger.SOSIIdIsValid) then
    begin
      AllowChange := True;
      exit;
    end
    else
    begin
      ChkBoxOK('Bruger er ikke oprettet med NEMID signatur og kan ikke tilgå FMK');
      AllowChange := False;
    end;
    exit;

  end;


  if NewPage = RSLocalPage then
  begin
    btnAnnul.Enabled := False;
    btnTilbage.Enabled := False;
    btnAfslut.Enabled := False;
    bitbtnTakser.Enabled := False;
    btnSend.Enabled := False;
    AllowChange := True;
  end;


end;

procedure TStamForm.KartotekPageEnter(Sender: TObject);
var
  LChar: Char;
begin
  with MainDm do
  begin
    c2logadd(Format('KartotekPageEnter: Ekundenr.text : %s : CF1Kundenr : %s',
      [EKundeNr.Text, CF1KundeNr]));
    ffPatKar.IndexName := 'NrOrden';
    dsStateChange(dsPatKar);
    if BlankPreviousCustomer then
    begin
      RefreshCF1WithBlankKundenr;
//      ffPatKar.FindKey([KundeKeyBlk]);
//      EKundeNr.SelectAll;
//      EKundeNr.SetFocus;
      BlankPreviousCustomer := False;
//      gbDosis.Visible := False
    end
    else
    begin
      if trim(EKundeNr.Text) <> '' then
      begin

        if trim(EKundeNr.Text) <> CF1KundeNr then
        begin
          LChar := #13;
          EKundeNrKeyPress(Sender, LChar);
        end;

      end;

    end;
    PostMessage(Handle, WM_SetButtons, 0, 0);
  end;

end;

procedure TStamForm.KartotekPageExit(Sender: TObject);
begin
  with MainDm do
  begin
    if ffPatKar.State <> dsBrowse then
    begin
      // Opdater evt. patient
      C2ButF5.Click;
    end;
    CF3Lbnr := 0;
  end;
end;

procedure TStamForm.TilskudsPageEnter(Sender: TObject);
begin
  with MainDm do
  begin
    ffPatKar.IndexName := 'NrOrden';
    lblCPrNvn.Caption := ffPatKarKundeNr.AsString + ' ' + ffPatKarNavn.AsString;
    dsStateChange(dsPatTil);
    ffPatTil.First;
    PostMessage(Handle, WM_SetButtons, 0, 0);
  end;

end;

procedure TStamForm.TilskudsPageExit(Sender: TObject);
begin
  with MainDm do
  begin
    if ffPatTil.State <> dsBrowse then
    begin
      // Opdater evt. tilskud
      C2ButF5.Click;
    end;
    CF3Lbnr := 0;
  end;
end;

procedure TStamForm.EkspPageEnter(Sender: TObject);
begin
  with MainDm do
  begin
    c2logadd('eksppageshow');
    cboFind.ItemIndex := 0;

    ffEksOvr.EnableControls;
    BusyMouseBegin;
    try
      ffEksOvrYderNavn.Index := 21;
      // ffEksOvr.IndexName := 'KundeNrOrden';
      // ffEksOvr.SetRange ([ffPatKarKundeNr.AsString], [ffPatKarKundeNr.AsString]);
      fqEksOvr.Close;
      fqEksOvr.SQL.Clear;
      fqEksOvr.SQL.add('SELECT');
      fqEksOvr.SQL.add('	x.Lbnr,');
      fqEksOvr.SQL.add('	Kundenr,');
      fqEksOvr.SQL.add('	Navn,');
      fqEksOvr.SQL.add('	YderNavn,');
      fqEksOvr.SQL.add
        ('	case when Barn=True then ''Ja'' else ''Nej'' end as Barn,');
      fqEksOvr.SQL.add('	TakserDato as Takseret,');
      fqEksOvr.SQL.add('	Afsluttetdato as Afsluttet,');
      fqEksOvr.SQL.add
        ('	case when ordretype=1 then ''Salg'' else ''Retur'' end as Type,');
      fqEksOvr.SQL.add
        ('	case when ordrestatus=1 then ''Åben'' else ''Afsluttet'' end as Status,');
      fqEksOvr.SQL.add('	Kontonr as Konto,');
      fqEksOvr.SQL.add('	FakturaNr as Faktura,');
      fqEksOvr.SQL.add('	PakkeNr as Pakke,');
      fqEksOvr.SQL.add('	LevNAVN AS "Lev nr",');
//      fqEksOvr.SQL.add('	case when char_length(kundenr)=10 then');
      fqEksOvr.SQL.add
        ('	(select ListeNr from ekspLeveringsListe as lev where lev.lbnr=x.lbnr) as Listenr,');
//      fqEksOvr.SQL.add('	else');
//      fqEksOvr.SQL.add('	cast(Null as integer) end as Listenr,');
      fqEksOvr.SQL.add('	TurNr as Tur,');
      fqEksOvr.SQL.add('	BrugerTakser as Ta,');
      fqEksOvr.SQL.add('	BrugerKontrol as Ko,');
      fqEksOvr.SQL.add('	BrugerAfslut as Af,');
      fqEksOvr.SQL.add('	case dkmedlem');
      fqEksOvr.SQL.add('    		when 0 then ''Ikke medlem''');
      fqEksOvr.SQL.add('    		when 1 then ''Medlem''');
      fqEksOvr.SQL.add('    		when 9 then ''Ved ikke''');
      fqEksOvr.SQL.add('	end as "DK-Medlem",');
      fqEksOvr.SQL.add
        ('	case when dkindberettet = 0 then ''-'' else ''D'' end as DK,');
      fqEksOvr.SQL.add('	case  CtrType');
      fqEksOvr.SQL.add('		when 0 then ''Almen voksen''');
      fqEksOvr.SQL.add('		when 1 then ''Almen barn''');
      fqEksOvr.SQL.add('		when 10 then ''Kroniker voksen''');
      fqEksOvr.SQL.add('		when 11 then ''Kroniker barn''');
      fqEksOvr.SQL.add('		else ''Terminal''');
      fqEksOvr.SQL.add('	end as "Ctr Type",');
      fqEksOvr.SQL.add('	case Ctrindberettet');
      fqEksOvr.SQL.add('		when 0 then ''-''');
      fqEksOvr.SQL.add('		when 1 then ''C''');
      fqEksOvr.SQL.add('		when 2 then ''P''');
      fqEksOvr.SQL.add('		when 3 then ''CP''');
      fqEksOvr.SQL.add('	end as CP,');
      fqEksOvr.SQL.add('	Ctrsaldo as "CTR saldo",');
      fqEksOvr.SQL.add('	Ydernr,');
      fqEksOvr.SQL.add('	case Kundetype');
      fqEksOvr.SQL.add('	when 0  then ''Ingen''');
      fqEksOvr.SQL.add('	when 1  then ''Enkeltperson''');
      fqEksOvr.SQL.add('        when 2  then ''Læge''');
      fqEksOvr.SQL.add('        when 3  then ''Dyrlæge''');
      fqEksOvr.SQL.add('        when 4  then ''Tandlæge''');
      fqEksOvr.SQL.add('        when 5  then ''Forsvaret''');
      fqEksOvr.SQL.add('        when 6  then ''Fængsel/Arresthus''');
      fqEksOvr.SQL.add('        when 7  then ''Asylcenter''');
      fqEksOvr.SQL.add('        when 8  then ''Jordemor''');
      fqEksOvr.SQL.add('        when 9  then ''Hjemmesygeplejerske''');
      fqEksOvr.SQL.add('        when 10 then ''Skibsfører/Reder''');
      fqEksOvr.SQL.add('        when 11 then ''Sygehus''');
      fqEksOvr.SQL.add('        when 12 then ''Plejehjem''');
      fqEksOvr.SQL.add('        when 13 then ''Hobbydyr''');
      fqEksOvr.SQL.add('        when 14 then ''Landmand (erhvervsdyr)''');
      fqEksOvr.SQL.add('        when 15 then ''Håndkøbsudsalg''');
      fqEksOvr.SQL.add('        when 16 then ''Andet apotek''');
      fqEksOvr.SQL.add('        when 17 then ''Institutioner''');
      fqEksOvr.SQL.add('	end as Kundetype,');
      fqEksOvr.SQL.add('	case Eksptype');
      fqEksOvr.SQL.add('            when 1 then ''Recepter''');
      fqEksOvr.SQL.add('            when 2 then ''Vagtbrug m.m.''');
      fqEksOvr.SQL.add('            when 3 then ''Leverancer''');
      fqEksOvr.SQL.add('            when 4 then ''Håndkøb''');
      fqEksOvr.SQL.add('            when 5 then ''Dyr''');
      fqEksOvr.SQL.add('            when 6 then ''Narkoleverance''');
      fqEksOvr.SQL.add('            when 7 then ''Dosispakning''');
      fqEksOvr.SQL.add('	    when 8 then ''Infertilitet''');
      fqEksOvr.SQL.add('	end as "Eksp type",');
      fqEksOvr.SQL.add('	case Ekspform');
      fqEksOvr.SQL.add('          when 0 then ''Andet''');
      fqEksOvr.SQL.add('          when 1 then ''Recept''');
      fqEksOvr.SQL.add('          when 2 then ''Telefonrecept''');
      fqEksOvr.SQL.add('          when 3 then ''EDB-recept''');
      fqEksOvr.SQL.add('          when 4 then ''Narkocheck''');
      fqEksOvr.SQL.add('	end as "Eksp form",');
      fqEksOvr.SQL.add('	case when char_length(kundenr)=10 then');
      fqEksOvr.SQL.add
        ('	( select top 1 Receptid from Produktion.RS_Ekspeditioner as R where x.lbnr=r.lbnr )');
      fqEksOvr.SQL.add('	else');
      fqEksOvr.SQL.add('	cast(Null as integer) end as ReceptId,');
      fqEksOvr.SQL.add('	Amt,');
      fqEksOvr.SQL.add('	Kommune as Kom,');
      fqEksOvr.SQL.add('	x.Afdeling,');
      fqEksOvr.SQL.add('	Lager,');
      fqEksOvr.SQL.add('	Udlignnr as "Udlign Nr",');
      fqEksOvr.SQL.add
        ('	case when Fiktivtcprnr = True then ''Ja'' else ''Nej'' end as Fiktiv,');
      fqEksOvr.SQL.add('	case Leveringsform');
      fqEksOvr.SQL.add('		when 1 then ''Prv''');
      fqEksOvr.SQL.add('		when 2 then ''Bud''');
      fqEksOvr.SQL.add('		when 4 then ''Uds''');
      fqEksOvr.SQL.add('		when 5 then ''Hkb''');
      fqEksOvr.SQL.add('		when 6 then ''Lev''');
      fqEksOvr.SQL.add('		when 7 then ''Ins''');
      fqEksOvr.SQL.add('		when 8 then ''Afh''');
      fqEksOvr.SQL.add('	end as Lev,');
      fqEksOvr.SQL.add('Brutto,');
      fqEksOvr.SQL.add('	Rabat,');
      fqEksOvr.SQL.add('	Exmoms as "Excl moms",');
      fqEksOvr.SQL.add('	Moms,');
      fqEksOvr.SQL.add('	Netto,');
      fqEksOvr.SQL.add('	TilskAmt as Amtet,');
      fqEksOvr.SQL.add('	TilskKom as Kommunen,');
      fqEksOvr.SQL.add('	Andel as "Pat Andel",');
      fqEksOvr.SQL.add('	dktilsk as "DK Tilskud",');
      fqEksOvr.SQL.add('	DKEjTilsk as "DK Ej Tilskud",');
      fqEksOvr.SQL.add('	Edbgebyr as "Edb-gebyr",');
      fqEksOvr.SQL.add('	Tlfgebyr as "Tlf-gebyr",');
      fqEksOvr.SQL.add('	Udbrgebyr as "Udbr-gebyr",');
      fqEksOvr.SQL.add('	LMSModtager as "LMSModtager",');
      fqEksOvr.SQL.add('	YderCPRNr,');
      fqEksOvr.SQL.add('	KontrolFejl,');
      fqEksOvr.SQL.add('        KontrolDato,');
      fqEksOvr.SQL.add('	OrdreDato,');
      fqEksOvr.SQL.add('	ReturDage');

      fqEksOvr.SQL.add('FROM');
      fqEksOvr.SQL.add('(');
      fqEksOvr.SQL.add('	SELECT');
      fqEksOvr.SQL.add('	*        ');
      fqEksOvr.SQL.add('	FROM');
      fqEksOvr.SQL.add('		ekspeditioner as e');
      fqEksOvr.SQL.add('	WHERE');
      fqEksOvr.SQL.add('		kundenr=:kundenr');
      fqEksOvr.SQL.add(' ) AS X');

      fqEksOvr.SQL.add('order by');
      fqEksOvr.SQL.add('	afsluttet desc,');
      fqEksOvr.SQL.add('        takseret');
//      C2LogAdd(fqEksOvr.SQL.Text);
      try
        fqEksOvr.ParamByName('kundenr').AsString := ffPatKarKundeNr.AsString;
        fqEksOvr.Open;
        dsEksOvr.dataset := fqEksOvr;
      except
        on e: Exception do
          c2logadd('Exception in CTRL-F3 screen ' + e.Message);

      end;
      {
        try
        fqEksOvr.SQL.Text := 'call sp_sql_PatientEksp(''' + trim(ffPatKarKundeNr.AsString) + ''')';
        fqEksOvr.Open;
        dsEksOvr.dataset := fqEksOvr;
        except
        on e : Exception do
        c2logadd('Exception in CTRL-F3 screen ' + e.Message);
        end;
      }
      dsStateChange(dsEksOvr);
      dsEksOvr.dataset.First;
      eEkspLb.SetFocus;
      PostMessage(Handle, WM_SetButtons, 0, 0);

    finally
      // dsEksOvr.DataSet.EnableControls;
      BusyMouseEnd;
    end;
  end;

end;

procedure TStamForm.EkspPageExit(Sender: TObject);
begin
  with MainDm do
  begin
    c2logadd('ekspPageExit');
    CF3Lbnr := 0;
    if dsEksOvr.dataset = ffEksOvr then
    begin
      CF3Lbnr := ffEksOvrLbNr.AsInteger;
    end;
    ffEksOvr.DisableControls;
    ffEksOvr.CancelRange;
    ffEksOvr.IndexName := 'KundeNrOrden';
  end;
end;

procedure TStamForm.UafslutPageEnter(Sender: TObject);
begin
  with MainDm do
  begin

    ffEksOvrYderNavn.Index := 3;
    ffEksOvr.EnableControls;
    ffEksOvr.IndexName := 'StatusOrden';
    ffEksOvr.SetRange([1, 1], [1, High(LongInt)]);
    dsEksOvr.dataset := ffEksOvr;
    dsStateChange(dsEksOvr);
    if CF3Lbnr <> 0 then
    begin
      ffEksOvr.FindKey([1, CF3Lbnr]);
      eUafLb.Text := inttostr(CF3Lbnr);
    end;
    acRetYdernr.Enabled := True;
    edtRetYderNr.Text := '';
    edtRetAutNr.Text := '';
    // C2ButFirst.Click;
    eUafLb.SetFocus;
    PostMessage(Handle, WM_SetButtons, 0, 0);
  end;

end;

procedure TStamForm.UafslutPageExit(Sender: TObject);
begin
  with MainDm do
  begin
    ffEksOvr.DisableControls;
    ffEksOvr.CancelRange;
    ffEksOvr.IndexName := 'KundeNrOrden';
    CF3Lbnr := 0;
    eUafKoNr.Text := '';
    edtLevnr.Text := '';
    acRetYdernr.Enabled := False;
  end;
end;

procedure TStamForm.PakkePageEnter(Sender: TObject);
begin
  with MainDm do
  begin
    try
      ffEksOvrYderNavn.Index := 99;
      dsEksOvr.dataset := ffEksOvr;
      ffEksOvr.EnableControls;
      ffEksOvr.IndexName := 'PakkeNrOrden';
      ffEksOvr.SetRange([1], [High(LongInt)]);
      dsStateChange(dsEksOvr);
      dsEksOvr.dataset.Last;
      edtNr.SetFocus;
      PostMessage(Handle, WM_SetButtons, 0, 0);
    except
      on e: Exception do
        ChkBoxOK(e.Message);
    end;
  end;
end;

procedure TStamForm.PakkePageExit(Sender: TObject);
begin
  with MainDm do
  begin
    ffEksOvr.DisableControls;
    ffEksOvr.CancelRange;
    ffEksOvr.IndexName := 'KundeNrOrden';
    CF3Lbnr := 0;
  end;
end;

procedure TStamForm.FakturaPageEnter(Sender: TObject);
begin
  with MainDm do
  begin
    try
      ffEksOvrYderNavn.Index := 99;
      dsEksOvr.dataset := ffEksOvr;
      ffEksOvr.EnableControls;
      ffEksOvr.IndexName := 'FakturaNrOrden';
      ffEksOvr.SetRange([High(LongInt), Now],
        [1, EncodeDateTime(2000, 1, 1, 0, 0, 0, 0)]);
      dsStateChange(dsEksOvr);
      dsEksOvr.dataset.First;
      cboFors.ItemIndex := 1;
      edtNr.SetFocus;
      butRetPakke.Enabled := False;
      PostMessage(Handle, WM_SetButtons, 0, 0);
    except
      on e: Exception do
        ChkBoxOK(e.Message);
    end;
  end;

end;

procedure TStamForm.FakturaPageExit(Sender: TObject);
begin
  with MainDm do
  begin
    ffEksOvr.DisableControls;
    ffEksOvr.CancelRange;
    ffEksOvr.IndexName := 'KundeNrOrden';
    CF3Lbnr := 0;
  end;
end;

procedure TStamForm.KontoPageEnter(Sender: TObject);
begin
  with MainDm do
  begin
    try
      ffEksOvrYderNavn.Index := 99;
      dsEksOvr.dataset := ffEksOvr;
      ffEksOvr.EnableControls;
      ffEksOvr.IndexName := 'KontoNrOrden';
      ffEksOvr.SetRange(['                   1'], ['99999999999999999999']);
      dsStateChange(dsEksOvr);
      dsEksOvr.dataset.Last;
      edtNr.SetFocus;
      PostMessage(Handle, WM_SetButtons, 0, 0);
    except
      on e: Exception do
        ChkBoxOK(e.Message);
    end;
  end;
end;

procedure TStamForm.KontoPageExit(Sender: TObject);
begin
  with MainDm do
  begin
    ffEksOvr.DisableControls;
    ffEksOvr.CancelRange;
    ffEksOvr.IndexName := 'KundeNrOrden';
    CF3Lbnr := 0;
  end;
end;

procedure TStamForm.konvCDSBatch(ATabSheet: TcxTabSheet);
var
  EdiRcp: TEdiRcp;
  AP4: Boolean;
  TakserSuccess: Boolean;
  LSenderTypeIsLokationsNummer: Boolean;
  LSenderTypeIsSOR: Boolean;

  procedure UpdateRSEkspeditionerReceptStatus(Receptid: Integer);
  var
    save_index: string;
    save_pat_index: string;
  begin

    with MainDm do
    begin

      save_pat_index := ffPatUpd.IndexName;
      ffPatUpd.IndexName := 'NrOrden';
      try
        if not ffPatUpd.FindKey([cdsOrdHeaderPaCprNr.AsString]) then
          exit;

      finally
        ffPatUpd.IndexName := 'NrOrden';
      end;
      save_index := nxRSEksp.IndexName;
      nxRSEksp.IndexName := 'ReceptIdOrder';
      try
        if nxRSEksp.FindKey([Receptid]) then
        begin
          if nxRSEkspReceptStatus.AsInteger < 90 then
          begin

            nxRSEksp.Edit;

            nxRSEkspReceptStatus.AsInteger :=
              nxRSEkspReceptStatus.AsInteger + 90;
            nxRSEksp.Post;

          end;
        end;

      finally
        nxRSEksp.IndexName := save_index;
      end;
    end;

  end;

begin
  with MainDm do
  begin
    c2logadd('top of konvcdsbatch ' + inttostr(cdsOrdHeader.RecordCount));
    try
      try
        RCPTakserCompleted := False;
        TakserSuccess := True;
        LSenderTypeIsLokationsNummer := False;
        // first we rip down only processing ap4
        cdsOrdHeader.First;
        while not cdsOrdHeader.Eof do
        begin
          LSenderTypeIsLokationsNummer :=
            cdsOrdHeaderSenderType.AsString = 'lokationsnummer';
          LSenderTypeIsSOR := SameText(cdsOrdHeaderSenderType.AsString, 'SOR');
          if cdsOrdLinier.RecordCount = 0 then
          begin
            cdsOrdHeader.Next;
            Continue;
          end;
          ReceptServerPrescription := True;
          // this is the routine that will do it !!!!!!
          FillChar(EdiRcp, sizeof(TEdiRcp), 0);
          EdiRcp.LbNr := cdsOrdHeaderLbnr.AsInteger;
          EdiRcp.Annuller := False;
          EdiRcp.PaCprNr := cdsOrdHeaderPaCprNr.AsString;
          SidKundeNr := cdsOrdHeaderPaCprNr.AsString;
          c2logadd('117: sidkundenr ' + SidKundeNr);
          EdiRcp.PaNavn := cdsOrdHeaderPaNvn.AsString;
          EdiRcp.ForNavn := cdsOrdHeaderForNavn.AsString;
          EdiRcp.Adr := cdsOrdHeaderAdr.AsString;
          EdiRcp.Adr2 := cdsOrdHeaderAdr2.AsString;
          EdiRcp.PostNr := cdsOrdHeaderPostNr.AsString;
          EdiRcp.By := cdsOrdHeaderBy.AsString;

          EdiRcp.Amt := cdsOrdHeaderAmt.AsString;
          EdiRcp.Tlf := cdsOrdHeaderTlf.AsString;
          EdiRcp.Alder := cdsOrdHeaderAlder.AsString;
          EdiRcp.Barn := cdsOrdHeaderBarn.AsString;
          EdiRcp.Tilskud := cdsOrdHeaderTilskud.AsString;
          EdiRcp.TilBrug := cdsOrdHeaderTilBrug.AsString;
          EdiRcp.Levering := cdsOrdHeaderLevering.AsString;
          EdiRcp.FriTxt := cdsOrdHeaderFriTxt.AsString;
          EdiRcp.YdNr := cdsOrdHeaderYdNr.AsString;

          EdiRcp.YdCprNr := cdsOrdHeaderYderCprNr.AsString;
          // if sendre is a lokation number then replace with Fxxxxxx where
          // xxxxxx is the autnr prefix with zeroes if necessary
          if LSenderTypeIsLokationsNummer then
            EdiRcp.YdNr := 'F' + EdiRcp.YdCprNr.PadLeft(6, '0');
//          // If SenderType is SOR, then empty the Ydernr which will force the user to pick an Erstatningsydernr. 0990027
//          else if LSenderTypeIsSOR then
//            EdiRcp.YdNr := '';
          EdiRcp.YdNavn := cdsOrdHeaderYdNavn.AsString;
          EdiRcp.YdSpec := cdsOrdHeaderYdSpec.AsString;
          EdiRcp.OrdAnt := 0;
          EdiRcp.LevInfo := cdsOrdHeaderLevinfo.AsString;
          if EHOrdre then
          begin
            EdiRcp.Danmark := cdsOrdHeaderDanmark.AsBoolean;
            EdiRcp.Kontonr := cdsOrdHeaderKontonr.AsString;
            EdiRcp.OrdreDato := cdsOrdHeaderOrdreDato.AsDateTime;
          end;

          with EdiRcp do
          begin
            cdsOrdLinier.First;
            while not cdsOrdLinier.Eof do
            begin
              AP4 := False;
              if ffLagKar.FindKey([FLagerNr, cdsOrdLinierVarenr.AsString]) then
                AP4 := ffLagKarUdlevType.AsString = 'AP4';
              if not AP4 then
              begin
                cdsOrdLinier.Next;
                Continue;
              end;
              OrdAnt := 1;
              Ord[OrdAnt].VareNr := cdsOrdLinierVarenr.AsString;
              c2logadd('varenr in konvr cds batch is ' + Ord[OrdAnt].VareNr);
              Ord[OrdAnt].Navn := cdsOrdLinierNavn.AsString;
              Ord[OrdAnt].Disp := cdsOrdLinierDisp.AsString;
              Ord[OrdAnt].Strk := cdsOrdLinierStrk.AsString;
              Ord[OrdAnt].Pakn := cdsOrdLinierPakn.AsString;
              Ord[OrdAnt].Subst := cdsOrdLinierSubst.AsString;
              EdiRcp.Ord[EdiRcp.OrdAnt].DrugId := maindm.cdsOrdLinierDrugid.AsString;
              EdiRcp.Ord[EdiRcp.OrdAnt].OpbevKode := maindm.cdsOrdLinierOpbevKode.AsString;

              Ord[OrdAnt].Antal := cdsOrdLinierAntal.AsInteger;
              Ord[OrdAnt].Tilsk := cdsOrdLinierTilsk.AsString;
              Ord[OrdAnt].IndKode := cdsOrdLinierIndKode.AsString; // todo
              Ord[OrdAnt].IndTxt := cdsOrdLinierIndTxt.AsString;
              Ord[OrdAnt].Udlev := cdsOrdLinierUdlev.AsInteger;
              Ord[OrdAnt].Forhdl := cdsOrdLinierForhdl.AsString; // todo
              Ord[OrdAnt].DosKode := cdsOrdLinierDosKode.AsString; // todo
              Ord[OrdAnt].DosTxt := cdsOrdLinierDosTxt.AsString; // todo
              Ord[OrdAnt].PEMAdmDone := cdsOrdLinierPEMAdmDone.AsInteger;
              Ord[OrdAnt].OrdId := cdsOrdLinierOrdid.AsString;
              Ord[OrdAnt].Receptid := cdsOrdLinierReceptid.AsInteger;
              UpdateRSEkspeditionerReceptStatus(Ord[OrdAnt].Receptid);
              Ord[OrdAnt].Klausulbetingelse := cdsOrdLinierKlausulBetingelse.AsBoolean;
              if EHOrdre then
              begin
                if cdsOrdLinierUserPris.AsCurrency <> 0 then
                  Ord[OrdAnt].UserPris := cdsOrdLinierUserPris.AsCurrency;
                Ord[OrdAnt].SubVarenr := cdsOrdLinierSubVarenr.AsString;
              end;

              // add the 3 fields to keep original varenr,antal and udlevtype
              // so we can block antal from changed to greater than that from FMK
              Ord[OrdAnt].OrdineretVarenr := cdsOrdLinierOrdineretVarenr.AsString;
              Ord[OrdAnt].OrdineretAntal := cdsOrdLinierOrdineretAntal.AsInteger;
              Ord[OrdAnt].OrdineretUdlevType := ffLagKarUdlevType.AsString;
              EdiRcp.ord[EdiRcp.ordant].UdstederAutId := MainDm.cdsOrdLinierUdstederAutid.AsString;
              EdiRcp.Ord[EdiRcp.OrdAnt].UdstederId := MainDm.cdsOrdLinierUdstederId.AsString;
              EdiRcp.ord[EdiRcp.ordant].UdstederType := maindm.cdsOrdLinierUdstederType.Asinteger;

              if LSenderTypeIsLokationsNummer then
              begin
                ChkBoxOK('Genordination fra Behandlerfarmaceut:' + sLineBreak +
                  cdsOrdHeaderIssuerTitel.AsString + ', ' +
                  cdsOrdHeaderSenderNavn.AsString + sLineBreak +
                  'Et genordineret lægemiddel må kun udleveres én gang og i mindste pakning'
                  + sLineBreak + 'Husk at opkræve udleveringsgebyr');
              end;
              TakserSuccess := EdifactRcp(addr(EdiRcp), ATabSheet);
              if not TakserSuccess then
                exit;
              RCPTakserCompleted := True;
              cdsOrdLinier.Delete;
            end;
          end;
          if cdsOrdLinier.RecordCount = 0 then
            cdsOrdHeader.Delete
          else
            cdsOrdHeader.Next;
        end;
        if not TakserSuccess then
          exit;
        // now we process the non AP4 lines thats all thats left now !!!!
        cdsOrdHeader.First;
        while not cdsOrdHeader.Eof do
        begin
          if cdsOrdLinier.RecordCount = 0 then
          begin
            cdsOrdHeader.Next;
            Continue;
          end;
          ReceptServerPrescription := True;
          // this is the routine that will do it !!!!!!
          FillChar(EdiRcp, sizeof(TEdiRcp), 0);
          EdiRcp.LbNr := cdsOrdHeaderLbnr.AsInteger;
          EdiRcp.Annuller := False;
          EdiRcp.PaCprNr := cdsOrdHeaderPaCprNr.AsString;
          SidKundeNr := cdsOrdHeaderPaCprNr.AsString;
          c2logadd('1171: sidkundenr ' + SidKundeNr);
          EdiRcp.PaNavn := cdsOrdHeaderPaNvn.AsString;
          EdiRcp.ForNavn := cdsOrdHeaderForNavn.AsString;
          EdiRcp.Adr := cdsOrdHeaderAdr.AsString;
          EdiRcp.Adr2 := cdsOrdHeaderAdr2.AsString;
          EdiRcp.PostNr := cdsOrdHeaderPostNr.AsString;
          EdiRcp.By := cdsOrdHeaderBy.AsString;

          EdiRcp.Amt := cdsOrdHeaderAmt.AsString;
          EdiRcp.Tlf := cdsOrdHeaderTlf.AsString;
          EdiRcp.Alder := cdsOrdHeaderAlder.AsString;
          EdiRcp.Barn := cdsOrdHeaderBarn.AsString;
          EdiRcp.Tilskud := cdsOrdHeaderTilskud.AsString;
          EdiRcp.TilBrug := cdsOrdHeaderTilBrug.AsString;
          EdiRcp.Levering := cdsOrdHeaderLevering.AsString;
          EdiRcp.FriTxt := cdsOrdHeaderFriTxt.AsString;
          EdiRcp.YdNr := cdsOrdHeaderYdNr.AsString;
          EdiRcp.YdCprNr := cdsOrdHeaderYderCprNr.AsString;
          // if sendre is a lokation number then replace with replacenment yder code
          if LSenderTypeIsLokationsNummer then
            EdiRcp.YdNr := 'F' + EdiRcp.YdCprNr.PadLeft(6, '0')
          // If SenderType is SOR, then empty the Ydernr which will force the user to pick an Erstatningsydernr. 0990027
          else if LSenderTypeIsSOR then
            EdiRcp.YdNr := '';
          EdiRcp.YdNavn := cdsOrdHeaderYdNavn.AsString;
          EdiRcp.YdSpec := cdsOrdHeaderYdSpec.AsString;
          EdiRcp.OrdAnt := 0;
          EdiRcp.LevInfo := cdsOrdHeaderLevinfo.AsString;
          if EHOrdre then
          begin
            EdiRcp.Danmark := cdsOrdHeaderDanmark.AsBoolean;
            EdiRcp.Kontonr := cdsOrdHeaderKontonr.AsString;
            EdiRcp.OrdreDato := cdsOrdHeaderOrdreDato.AsDateTime;
          end;
          with EdiRcp do
          begin
            cdsOrdLinier.First;
            while not cdsOrdLinier.Eof do
            begin

              OrdAnt := OrdAnt + 1;
              Ord[OrdAnt].VareNr := cdsOrdLinierVarenr.AsString;
              c2logadd('varenr in konvr cds batch is ' + Ord[OrdAnt].VareNr);
              Ord[OrdAnt].Navn := cdsOrdLinierNavn.AsString;
              Ord[OrdAnt].Disp := cdsOrdLinierDisp.AsString;
              Ord[OrdAnt].Strk := cdsOrdLinierStrk.AsString;
              Ord[OrdAnt].Pakn := cdsOrdLinierPakn.AsString;
              Ord[OrdAnt].Subst := cdsOrdLinierSubst.AsString;
              EdiRcp.Ord[EdiRcp.OrdAnt].DrugId := maindm.cdsOrdLinierDrugid.AsString;
              EdiRcp.Ord[EdiRcp.OrdAnt].OpbevKode := maindm.cdsOrdLinierOpbevKode.AsString;

              Ord[OrdAnt].Antal := cdsOrdLinierAntal.AsInteger;
              Ord[OrdAnt].Tilsk := cdsOrdLinierTilsk.AsString;
              Ord[OrdAnt].IndKode := cdsOrdLinierIndKode.AsString; // todo
              Ord[OrdAnt].IndTxt := cdsOrdLinierIndTxt.AsString;
              Ord[OrdAnt].Udlev := cdsOrdLinierUdlev.AsInteger;
              Ord[OrdAnt].Forhdl := cdsOrdLinierForhdl.AsString; // todo
              Ord[OrdAnt].DosKode := cdsOrdLinierDosKode.AsString; // todo
              Ord[OrdAnt].DosTxt := cdsOrdLinierDosTxt.AsString; // todo
              Ord[OrdAnt].PEMAdmDone := cdsOrdLinierPEMAdmDone.AsInteger;
              Ord[OrdAnt].OrdId := cdsOrdLinierOrdid.AsString;
              Ord[OrdAnt].Receptid := cdsOrdLinierReceptid.AsInteger;
              UpdateRSEkspeditionerReceptStatus(Ord[OrdAnt].Receptid);
              Ord[OrdAnt].Klausulbetingelse := cdsOrdLinierKlausulBetingelse.AsBoolean;
              if EHOrdre then
              begin
                if cdsOrdLinierUserPris.AsCurrency <> 0 then
                  Ord[OrdAnt].UserPris := cdsOrdLinierUserPris.AsCurrency;
                Ord[OrdAnt].SubVarenr := cdsOrdLinierSubVarenr.AsString;
              end;
              // add the 3 fields to keep original varenr,antal and udlevtype
              // so we can block antal from changed to greater than that from FMK
              Ord[OrdAnt].OrdineretVarenr := cdsOrdLinierOrdineretVarenr.AsString;
              Ord[OrdAnt].OrdineretAntal := cdsOrdLinierOrdineretAntal.AsInteger;
              EdiRcp.ord[EdiRcp.ordant].UdstederAutId := MainDm.cdsOrdLinierUdstederAutid.AsString;
              EdiRcp.Ord[EdiRcp.OrdAnt].UdstederId := MainDm.cdsOrdLinierUdstederId.AsString;
              EdiRcp.ord[EdiRcp.ordant].UdstederType := maindm.cdsOrdLinierUdstederType.Asinteger;
              if ffLagKar.FindKey([FLagerNr, cdsOrdLinierVarenr.AsString]) then
                Ord[OrdAnt].OrdineretUdlevType := ffLagKarUdlevType.AsString;
              cdsOrdLinier.Delete;
            end;
          end;
          if LSenderTypeIsLokationsNummer then
          begin
            ChkBoxOK('Genordination fra Behandlerfarmaceut:' + sLineBreak +
              cdsOrdHeaderIssuerTitel.AsString + ', ' +
              cdsOrdHeaderSenderNavn.AsString + sLineBreak +
              'Et genordineret lægemiddel må kun udleveres én gang og i mindste pakning'
              + sLineBreak + 'Husk at opkræve udleveringsgebyr');
          end;
          TakserSuccess := EdifactRcp(addr(EdiRcp), ATabSheet);
          if TakserSuccess then
            RCPTakserCompleted := True;
          if not TakserSuccess then
            exit;
          if cdsOrdLinier.RecordCount = 0 then
            cdsOrdHeader.Delete
          else
            cdsOrdHeader.Next;
        end;

      except
        on e: Exception do
          ChkBoxOK(e.Message);
      end;

    finally
      // delete the conents of the client dataset if there has been any issues
      cdsOrdHeader.First;
      while not cdsOrdHeader.Eof do
      begin
        cdsOrdLinier.First;
        while not cdsOrdLinier.Eof do
          cdsOrdLinier.Delete;
        cdsOrdHeader.Delete;
      end;
      if Afslut_i_CF5_CF6 or EHOrdre then
      begin
        StamPages.ActivePage := ATabSheet;
        if FejlCF5Ekspedition then
          StamPages.ActivePage := RSRemotePage;

        StamPages.Refresh;
        if StamPages.ActivePage = KartotekPage then
        begin
          // Kun ved retur til kartotek
          if GoAuto then
          begin
            RefreshCF1WithBlankKundenr;
//            ffPatKar.FindKey([KundeKeyBlk]);
//            EKundeNr.SelectAll;
//            EKundeNr.SetFocus;
          end;
        end;
      end
      else
      begin
        if FejlCF5Ekspedition then
        begin
          StamPages.ActivePage := RSRemotePage;
          StamPages.Refresh;
        end
        else
        begin
          StamPages.ActivePage := KartotekPage;
          StamPages.Refresh;
          if GoAuto then
          begin
            // Kun ved retur til kartotek
            RefreshCF1WithBlankKundenr;
//            ffPatKar.FindKey([KundeKeyBlk]);
//            EKundeNr.SelectAll;
//            EKundeNr.SetFocus;
          end;
        end;
      end;
      // edtCprNr.Text := '';
      c2logadd('bottom of konvcdsBatch');
    end;

  end;
end;

procedure TStamForm.butGenCtrClick(Sender: TObject);
begin
  with MainDm do
  begin
    if not ChkBoxYesNo('Indberet løbenr ' + inttostr(ffEksOvrLbNr.Value) +
      ' til CTR ?', True) then
      exit;

    BusyMouseBegin;
    try
      AfslLbNr := ffEksOvrLbNr.Value;
      // OpdaterCTR;
      ffCtrOpd.Insert;
      ffCtrOpdNr.AsInteger := ffEksOvrLbNr.AsInteger;
      ffCtrOpdDato.AsDateTime := ffEksOvrOrdreDato.AsDateTime;
      ffCtrOpd.Post;
    finally
      BusyMouseEnd;
    end;
  end;
end;

procedure TStamForm.butFindPakkeClick(Sender: TObject);
var
  Idx: String;
begin
  with MainDm do
  begin
    case cboFors.ItemIndex of
      // 0 is pakke
      0:
        begin
          try
            if ffEksOvr.FindKey([StrToInt(edtNr.Text)]) then
              dbgrFors.SetFocus;
          except
          end;
        end;
      // 1 is faktura
      1:
        begin

          try
            edtPakAnt.Text := '0';
            if ffEksOvr.FindKey([StrToInt(edtNr.Text)]) then
            begin
              // dbgrFaktura.SetFocus;
              c2logadd('Find fakturanr "' + edtNr.Text + '"');
              Idx := SaveAndAdjustIndexName(MainDm.ffEksFak, 'FakturaNrOrden');
              try
                if ffEksFak.FindKey([ffEksOvrFakturaNr.AsInteger]) then
                begin
                  // Vis antal pakker
                  c2logadd('Fundet fakturanr "' + ffEksOvrFakturaNr.AsString +
                    '"' + ' antal pakker "' +
                    ffEksFakAntalPakker.AsString + '"');
                  edtPakAnt.Text := ffEksFakAntalPakker.AsString;
                end;
              finally
                ffEksFak.IndexName := Idx;
              end;
            end;
          except
            on e: Exception do
              c2logadd(' Find fakturanr, exception "' + e.Message + '"');
          end;

        end;
      // 2 is konto
      2:
        begin
          try
            if ffEksOvr.FindKey([edtNr.Text]) then
              dbgrFors.SetFocus;
          except
          end;

        end;
    end;
  end;
end;

procedure TStamForm.butFindFaktClick(Sender: TObject);
var
  Idx: String;
begin
  with MainDm do
  begin
    try
      edtPakAnt.Text := '0';
      if not ffEksOvr.FindKey([StrToInt(edtNr.Text)]) then
        exit;
      // dbgrFaktura.SetFocus;
      c2logadd('Find fakturanr "' + edtNr.Text + '"');
      Idx := SaveAndAdjustIndexName(MainDm.ffEksFak, 'FakturaNrOrden');
      try
        if not ffEksFak.FindKey([ffEksOvrFakturaNr.AsInteger]) then
          exit;
        // Vis antal pakker
        c2logadd('Fundet fakturanr "' + ffEksOvrFakturaNr.AsString + '"' +
          ' antal pakker "' + ffEksFakAntalPakker.AsString + '"');
        edtPakAnt.Text := ffEksFakAntalPakker.AsString;
      finally
        ffEksFak.IndexName := Idx;
      end;
    except
      on e: Exception do
        c2logadd(' Find fakturanr, exception "' + e.Message + '"');
    end;
  end;
end;

procedure TStamForm.butFindKontoClick(Sender: TObject);
begin
  with MainDm do
  begin
    try
      if ffEksOvr.FindKey([edtNr.Text]) then
        dbgrFors.SetFocus;
    except
    end;
  end;
end;

procedure PnLst;
var
  S: String;
begin
  with MainDm do
  begin
    if dsKar.State = dsBrowse then
    begin
      S := '';
      S := ShowPnLst(S);
      exit;
    end;
    ffPatKarPostNr.AsString := ShowPnLst(ffPatKarPostNr.AsString);
  end;
end;

procedure TStamForm.PaLst;
var
  Kundenr: string;
begin
  if MainDm.dsKar.State <> dsBrowse then
    exit;

  c2logadd('palst pressed');
  Kundenr := TPaLstForm.ShowPalst(MainDm.nxdb);
  if Kundenr <> '' then
  begin
    EKundeNr.Text := Kundenr;
    EKundeNr.SetFocus;
    PostMessage(EKundeNr.Handle, WM_CHAR, VK_RETURN, 0);
  end;
end;

procedure TStamForm.InLst;
begin
  with MainDm do
  begin
    if dsKar.State = dsBrowse then
    begin
      TInLstForm.ShowInLst('Navn', dsInLst, ffInLst);
      exit;
    end;
    if TInLstForm.ShowInLst('Navn', dsInLst, ffInLst) then
    begin
      ffPatKarKommune.Value := ffInLstNr.Value;
      ffPatKarAmt.Value := ffInLstAmtNr.Value;
    end;
  end;
end;

procedure TStamForm.YdLst;
begin
  with MainDm do
  begin
    if dsKar.State = dsBrowse then
    begin
      ShowYdLst('Navn', dsYdLst, ffYdLst);
      exit;
    end;

    try
      ffYdLst.IndexName := 'YderNrOrden';
      if not ffYdLst.FindKey([ffPatKarYderNr.AsString,
        ffPatKarYderCprNr.AsString]) then
        ffYdLst.FindKey([ffPatKarYderNr.AsString]);
    except
    end;

    if ShowYdLst('Navn', dsYdLst, ffYdLst) then
    begin
      ffPatKarYderNr.AsString := ffYdLstYderNr.AsString;
      // if EYderCprNr.Text = '' then
      ffPatKarYderCprNr.AsString := ffYdLstCprNr.AsString;
    end;
  end;
end;

procedure TStamForm.YdCprLst;
begin
  with MainDm do
  begin
    if dsKar.State = dsBrowse then
    begin
      ShowYdLst('CprNr', dsYdLst, ffYdLst);
      exit;
    end;
    if ShowYdLst('CprNr', dsYdLst, ffYdLst) then
      ffPatKarYderCprNr.AsString := ffYdLstCprNr.AsString;
  end;
end;

procedure TStamForm.DeLst;
var
  S: String;
begin
  with MainDm do
  begin
    if dsKar.State = dsBrowse then
    begin
      S := '';
      S := ShowDeLst('KontoNr', S);
      exit;
    end;
    ffPatKarDebitorNr.AsString := ShowDeLst('KontoNr',
      ffPatKarDebitorNr.AsString);
  end;
end;

procedure TStamForm.LeLst;
var
  S: String;
begin
  with MainDm do
  begin
    if dsKar.State = dsBrowse then
    begin
      S := '';
      S := ShowDeLst('KontoNr', S);
      exit;
    end;
    ffPatKarLevNr.AsString := ShowDeLst('KontoNr', ffPatKarDebitorNr.AsString);
  end;
end;

procedure TStamForm.ReLst;
begin
  with MainDm do
  begin
    if dsKar.State = dsBrowse then
    begin
      TReLstForm.ShowReLst(dsReLst, ffReLst);
      exit;
    end;
    if TReLstForm.ShowReLst(dsReLst, ffReLst) then
    begin
      ffPatTilRegel.Value := ffReLstNr.Value;
      ffPatTilOrden.Value := ffReLstOrden.Value;
      if ffReLstNr.Value = 45 then
        ffPatTilPromille5.Value := 600;
    end;
  end;
end;

procedure TStamForm.VmLst;
var
  Res: Integer;
begin
  with  MainDm do
  begin
    Res := ShowList('Vareoversigt', 0, dsVmLst, ['VareNr', 'AtcKode', 'SubGrp',
      'Navn', 'Pakning', 'Styrke', 'PaKode', 'KostPris', 'SalgsPris',
      'EgenPris', 'BGP', 'SubKode', 'SubForValg'], ['Lager=0'], OnSetRange,
      OnDoSearch);
    if dsKar.State = dsBrowse then
      exit;

    case Res of
      1:
        ffPatTilVareNr.AsString := ffVmLstVareNr.AsString;
      2:
        ffPatTilAtcKode.AsString := ffVmLstAtcKode.AsString;
      4:
        ffPatTilProdukt.AsString := ffVmLstNavn.AsString;
    end;
  end;
end;

procedure TStamForm.KmLst;
begin
  with MainDm do
  begin
    if ffPatKarKommune.AsString = '' then
      exit;
    if ffPatTilRegel.AsString = '' then
      exit;

    cdKomEan.Filtered := False;
    cdKomEan.Filter := '';
    cdKomEan.Filter := '(Kommunenr=' + ffPatKarKommune.AsString +
      ') and (RegelNr=' + ffPatTilRegel.AsString + ')';
    c2logadd(cdKomEan.Filter);
    try
      try
        cdKomEan.Filtered := True;
        if TfrmKomEanLst.KomLst <> mrok then
          exit;

        if dsKar.State <> dsBrowse then
        begin
          if (cdKomEanRegelNr.AsInteger = 0) or
            (cdKomEanRegelNr.AsInteger = ffPatTilRegel.AsInteger) then
          begin
            ffPatTilRefNr.AsString := Trim(cdKomEanEanNr.AsString);
            if Trim(cdKomEanFriTekst.AsString) <> '' then
              ffPatTilAfdeling.AsString := Trim(cdKomEanFriTekst.AsString);
          end
          else
            ChkBoxOK('Ikke overensstemmelse mellem valgt regel og eannr!');
        end;

      except
        on e: Exception do
          ChkBoxOK(e.Message);
      end;
    finally
      cdKomEan.Filter := '';
      cdKomEan.Filtered := False;
    end;
  end;
end;

procedure TStamForm.OnCdsRange(Sender: TObject; ADataSet: TDataSet;
  const StartValues, EndValues: array of const);
begin
  TClientDataSet(ADataSet).SetRange([StartValues[0].VPChar],
    [EndValues[0].VPChar]);
end;

procedure TStamForm.OnCdsSearch(Sender: TObject; ADataSet: TDataSet;
  const AValue: Variant; AFieldType: string);
begin
  TClientDataSet(ADataSet).FindNearest([string(AValue)]);
end;

procedure TStamForm.OnSetRange(Sender: TObject; ADataSet: TDataSet;
  const StartValues, EndValues: array of const);
begin
  (ADataSet as TnxTable).SetRange([StartValues[0].VPChar],
    [EndValues[0].VPChar]);
end;

procedure TStamForm.OnDoSearch(Sender: TObject; ADataSet: TDataSet;
  const AValue: Variant; AFieldType: string);
begin
  (ADataSet as TnxTable).FindNearest([Integer(AValue[0]), String(AValue[1])]);
end;

procedure TStamForm.StamF5Handler;
var
  ServerDateTime: TDateTime;
//  procedure UpdateDosisYderInfo;
//  begin
//    with MainDm do
//    begin
//      // update any dosiscard if doctor or autnr changed
//
//      if nxDCH.RecordCount = 0 then
//        exit;
//      if (ffPatKarYderNr.AsString = PatKarYdernr) and
//        (ffPatKarYderCprNr.AsString = PatKarYderCPrNr) then
//        exit;
//
//      if not frmYesNo.NewYesNoBox
//        ('Opdater Autnr / Ydernr på kundens dosiskort ?') then
//        exit;
//
//      nxDCH.First;
//      while not nxDCH.Eof do
//      begin
//        nxDCH.Edit;
//        nxDCH.fieldbyname('DoctorNumber').AsString := ffPatKarYderNr.AsString;
//        nxDCH.fieldbyname('YderCPRNr').AsString := ffPatKarYderCprNr.AsString;
//        nxDCH.Post;
//        nxDCH.Next;
//      end;
//      nxDCH.First;
//
//      PatKarYdernr := '';
//      PatKarYderCPrNr := '';
//    end;
//
//  end;

begin
  with MainDm do
  begin
    c2logadd('Top of F5 pressed');
    try
      if Assigned(ActiveControl) then
        SendMessage(ActiveControl.Handle, CM_EXIT, 0, 0);

      nxRemoteServerInfoPlugin1.GetServerDateTime(ServerDateTime);

      if not ValidatePatKar then
        exit;
      if EKundeType.ItemIndex = 18 then
        ffPatKarKundeType.AsInteger := 1;
      if MainDm.ffPatKarLandekode.AsInteger >= 999 then
        MainDm.ffPatKarEjCtrReg.AsBoolean := True;

      case ffPatKar.State of
        dsEdit:
          begin
            ffPatKarRetDato.AsDateTime := ServerDateTime;
            try
              ffPatKar.Post;
            except
              on e: Exception do
                ChkBoxOK('Gem post IKKE gennemført, exception' + e.Message);
            end;
          end;
        dsInsert:
          begin
            if ffPatKarKundeType.AsInteger = 18 then
            begin
              ffPatKarCprCheck.AsBoolean := False;
              ffPatKarLmsModtager.AsString := '4000005555';
              ffPatKarEjCtrReg.AsBoolean := True;
            end;

            ffPatKarOpretDato.AsDateTime := ServerDateTime;
            if ffPatKarKundeType.Value <> 1 then // Kun DK ved enkeltpersoner
              ffPatKarDKMedlem.Value := 0;
            try
              ffPatKar.Post;
//              GetCTR(ffPatKarKundeNr.AsString);
            except
              on e: Exception do
                ChkBoxOK('Gem post IKKE gennemført, exception' + e.Message);
            end;
          end;
      else
        ChkBoxOK('Kun Gem i Ret/Opret tilstand!');
        exit;
      end;

//      UpdateDosisYderInfo;

    finally
      c2logadd('Bottom of F5 pressed');
    end;

  end;
end;

procedure TStamForm.StamF6Handler;
begin
  with MainDm do
  begin
    c2logadd('Top of F6 pressed');
    try
      C2LogAdd('dskar set nanme is ' + dsKar.DataSet.Name);
      if dsKar.State = dsBrowse then
      begin
        try
          dsKar.dataset.Edit;
          if dsKar.dataset = ffPatKar then
          begin
            ENavn.SetFocus;
            ENavn.SelectAll;
          end;
          TilFraDato.ReadOnly := False;
          if dsKar.dataset = ffPatTil then
          begin
            if ffPatTilRegel.AsInteger > 59 then
              TilFraDato.ReadOnly := True;
          end;
        except
          on e: Exception do
            ChkBoxOK('Ret post IKKE gennemført, exception' + e.Message);
        end;
        exit;
      end;
      if dsKar.State = dsEdit then
        ChkBoxOK('Er i tilstand for Ret!')
      else
        ChkBoxOK('Forkert tilstand for Ret!');
    finally
      c2logadd('Bottom of F6 pressed');
    end;
  end;
end;

procedure TStamForm.StamF7Handler;
begin
  with MainDm do
  begin
    c2logadd('Top of F7 Pressed');
    try
      case dsKar.State of
        dsBrowse:
          begin
            TilFraDato.ReadOnly := False;
            try
              dsKar.dataset.Insert;
            except
              ChkBoxOK('Oprette tilstand spærret !');
            end;
            if dsKar.dataset = ffPatKar then
              ffPatKarAmt.Value := StrToInt(ffRcpOplAfrAmt.AsString);
          end;

        dsInsert:
          ChkBoxOK('Er i tilstand for Opret!');
      else
        ChkBoxOK('Forkert tilstand for Opret!');

      end;
    finally
      c2logadd('Bottom of F7 Pressed');
    end;

  end;
end;

procedure TStamForm.StamF8Handler;
begin
  with MainDm do
  begin
    c2logadd('Top of F8 pressed');
    try
      case dsKar.State of
        dsBrowse:
          begin
            if not ChkBoxYesNo('Skal post slettes ?', False) then
              exit;
            try
              if dsKar.dataset = ffPatTil then
              begin
                if ffPatTilRegel.AsInteger > 59 then
                begin
                  if ffPatTilTilDato.AsDateTime > IncYear(Now, -1) then
                  begin
                    ChkBoxOK('Bevilling kan ikke slettes, da den er udløbet for mindre end et år siden.');
                    exit;
                  end;
                end;
              end;
              dsKar.dataset.Delete;

            except
              ChkBoxOK('Slet post IKKE gennemført!');
            end;
          end
      else
        ChkBoxOK('Forkert tilstand for Slet!');

      end;
    finally
      c2logadd('Bottom of F8 pressed');
    end;

  end;

end;

procedure TStamForm.StamEscHandler;
begin
  with MainDm do
  begin
    if StamPages.ActivePage = KartotekPage then
    begin
      EKundeNr.Color := clWindow;
      EKundeNr.Font.Color := clWindowText;
      EModtager.Color := clWindow;
      EModtager.Font.Color := clWindowText;
      EYderNr.Color := clWindow;
      EYderNr.Font.Color := clWindowText;
      EKommune.Color := clWindow;
      EKommune.Font.Color := clWindowText;
      EAmt.Color := clWindow;
      EAmt.Font.Color := clWindowText;
      EBem.Color := clWindow;
      EKundeNr.SetFocus;
      EKundeNr.SelectAll;
    end;
    dsKar.dataset.Cancel;
    dsKar.dataset.Refresh;
  end;
end;

procedure TStamForm.TakserEh(AC2Nr: Integer);
var
  save_index: string;
  RSErrorMessage: string;
  PatientDebitor: string;

  function CreateEhOrdreDato(const ADateStr : string ): TDateTime;
  var
    dd,mm,yyyy : integer;
  begin

    yyyy := StrToIntDef(ADateStr.Substring(0,4),-1);
    mm := StrToIntDef(ADateStr.Substring(5,2),-1);
    dd := StrToIntDef(ADateStr.Substring(8,2),-1);

    if (yyyy= -1) or (mm=-1) or (dd =-1) then
      exit(Now);

    exit(StartOfTheDay(EncodeDate(yyyy, mm, dd)));

  end;

  procedure AddLocalRSLineToCdsOrd;
  var
    PatCPr: string;
    YderNr: string;
    YderCPRNr: string;
    save_RSEkspindex: string;
    LUdstederType: Integer;

    procedure AddCDSLines;
    begin
      c2logadd('Top of addcdslines in Localrs');
      // first check to see if ordid exsts in the current cds file if so skip it
      MainDm.cdsOrdLinier.First;
      while not MainDm.cdsOrdLinier.Eof do
      begin
        if MainDm.cdsOrdLinierOrdid.AsString = MainDm.nxRSEkspLinOrdId.AsString then
          exit;
        MainDm.cdsOrdLinier.Next;
      end;

      if MainDm.cdsOrdHeaderYdNavn.AsString.IsEmpty then
      begin
        C2LogAdd('updated the doctor name ' + MainDm.nxRSEkspIssuerTitel.AsString);
        MainDm.cdsOrdHeaderYdNavn.AsString := MainDm.nxRSEkspIssuerTitel.AsString;
      end;

      if not uFMKGetMedsById.RefreshReceivedMedications(PatCPr,
              MainDm.nxRSEkspLinPrivat.AsInteger,
              MainDm.nxRSEkspLinOrdId.AsString,
              MainDm.AfdNr,
              MainDm.nxRSEkspLinReceptId.AsInteger,False,True) then
      begin
        C2LogAdd('RefreshReceivedMedications returned false');
        exit;
      end;


      MainDm.cdsOrdLinier.Append;
      MainDm.cdsOrdLinierVarenr.AsString := MainDm.nxRSEkspLinVarenNr.AsString.PadLeft(6,'0');
      if MainDm.EHOrdre then
        MainDm.cdsOrdLinierSubVarenr.AsString := MainDm.cdsOrdLinierVarenr.AsString;

      if MainDm.EHOrdre then
      begin
        if MainDm.nxOrdLinOrdineretVarenummer.AsString <> '' then
        begin
          if MainDm.nxOrdLinOrdineretVarenummer.AsString <> MainDm.nxOrdLinVarenummer.AsString then
          begin
            MainDm.cdsOrdLinierVarenr.AsString := MainDm.nxOrdLinOrdineretVarenummer.AsString;
            MainDm.cdsOrdLinierSubVarenr.AsString := MainDm.nxOrdLinVarenummer.AsString;
          end;
        end;

      end;

      MainDm.cdsOrdHeaderOrdAnt.AsInteger := MainDm.cdsOrdHeaderOrdAnt.AsInteger + 1;
      AdjustIndexName(MainDm.ffLagKar, 'NrOrden');
      if MainDm.ffLagKar.FindKey([0, MainDm.cdsOrdLinierVarenr.AsString]) then
      begin
        c2logadd('found the product udlevtype is ' + MainDm.ffLagKarUdlevType.AsString);
        MainDm.cdsOrdLinierNavn.AsString := MainDm.ffLagKarNavn.AsString;
        MainDm.cdsOrdLinierDisp.AsString := MainDm.ffLagKarForm.AsString;
        MainDm.cdsOrdLinierStrk.AsString := MainDm.ffLagKarStyrke.AsString;
        MainDm.cdsOrdLinierPakn.AsString := MainDm.ffLagKarPakning.AsString;
        maindm.cdsOrdLinierDrugid.AsString := maindm.ffLagKarDrugId.AsString;
        maindm.cdsOrdLinierOpbevKode.AsString :=  maindm.ffLagKarOpbevKode.AsString;
      end
      else
      begin
        MainDm.cdsOrdLinierNavn.AsString := MainDm.nxRSEkspLinNavn.AsString;
        MainDm.cdsOrdLinierDisp.AsString := MainDm.nxRSEkspLinForm.AsString;
        MainDm.cdsOrdLinierStrk.AsString := MainDm.nxRSEkspLinStyrke.AsString;
        MainDm.cdsOrdLinierPakn.AsString := MainDm.nxRSEkspLinPakning.AsString;
        maindm.cdsOrdLinierDrugid.AsString := '';
        maindm.cdsOrdLinierOpbevKode.AsString :=  '';
      end;
      MainDm.cdsOrdLinierSubst.AsString := '';
      if MainDm.nxRSEkspLinSubstKode.AsString <> '' then
        MainDm.cdsOrdLinierSubst.AsString := '-S';
      if MainDm.EHOrdre then
      begin
        if MainDm.nxRSEkspLinSubstKode.AsString <> '' then
          MainDm.cdsOrdLinierSubst.AsString := 'Ejs'
        else
          MainDm.cdsOrdLinierSubst.AsString := MainDm.nxOrdLinSubstitution.AsString;
      end;

      MainDm.cdsOrdLinierAntal.AsInteger := MainDm.nxRSEkspLinAntal.AsInteger;
      MainDm.cdsOrdLinierTilsk.AsString := ''; // todo
      MainDm.cdsOrdLinierIndKode.AsString := MainDm.nxRSEkspLinIndCode.AsString; // todo
      MainDm.cdsOrdLinierIndTxt.AsString := MainDm.nxRSEkspLinIndText.AsString;
      if MainDm.nxRSEkspLinIterationNr.AsInteger <> 0 then
        MainDm.cdsOrdLinierUdlev.AsInteger := MainDm.nxRSEkspLinIterationNr.AsInteger + 1
      else
        MainDm.cdsOrdLinierUdlev.AsInteger := 0;
      MainDm.cdsOrdLinierForhdl.AsString := ''; // todo
      MainDm.cdsOrdLinierDosKode.AsString := MainDm.nxRSEkspLinDosKode.AsString; // todo
      MainDm.cdsOrdLinierDosTxt.AsString := MainDm.nxRSEkspLinDosTekst.AsString; // todo
      if MainDm.nxRSEkspLinDosPeriod.AsString <> '' then
        MainDm.cdsOrdLinierDosTxt.AsString := MainDm.cdsOrdLinierDosTxt.AsString + ' i ' +
          MainDm.nxRSEkspLinDosPeriod.AsString + ' ' + MainDm.nxRSEkspLinDosEnhed.AsString;
      MainDm.cdsOrdLinierPEMAdmDone.AsInteger := 0;
      if MainDm.nxRSEkspLinAdminCount.AsString <> '' then
        MainDm.cdsOrdLinierPEMAdmDone.AsInteger := MainDm.nxRSEkspLinAdminCount.AsInteger;
      MainDm.cdsOrdLinierOrdid.AsString := MainDm.nxRSEkspLinOrdId.AsString;
      MainDm.cdsOrdLinierReceptid.AsInteger := MainDm.nxRSEkspLinReceptId.AsInteger;
      MainDm.cdsOrdLinierKlausulBetingelse.AsBoolean := MainDm.nxRSEkspLinKlausulbetingelse.AsString <> '';
      if (Trim(MainDm.nxRSEkspLinSupplerende.AsString) <> '') or
        (Trim(MainDm.nxRSEkspLinOrdreInstruks.AsString) <> '') or
        (Trim(MainDm.nxRSEkspLinApotekBem.AsString) <> '') then
        if MainDm.cdsOrdHeaderLevinfo.AsString = '' then
          MainDm.cdsOrdHeaderLevinfo.AsString := 'Vis Ekspedition';
      MainDm.cdsOrdLinierUserPris.AsCurrency := 0;
      MainDm.cdsOrdLinierUdstederAutid.AsString := MainDm.nxRSEkspIssuerAutNr.AsString;
      MainDm.cdsOrdLinierUdstederId.AsString := MainDm.nxRSEkspSenderId.asstring;
      MainDm.cdsOrdLinierUdstederType.AsInteger := StamForm.CalculateUdstederType(MainDm.nxRSEkspSenderType.AsString);
//      if (MainDm.ffLagKarVareType.AsInteger  = 2) or
//        ((MainDm.ffLagKarVareType.AsInteger = 5) and (MainDm.ffLagKarHaType.AsString <> '')) then
//        MainDm.cdsOrdLinierUserPris.AsCurrency := MainDm.nxOrdLinListeprisPerStk.AsCurrency;
      MainDm.cdsOrdLinier.Post;
      c2logadd('Bottom of addcdslines in local rs');
    end;

  begin
    c2logadd('top of addlocal rs to cds');
    if not MainDm.cdsOrdHeader.Active then
      MainDm.cdsOrdHeader.Open;
    MainDm.cdsOrdHeader.LogChanges := False;
    // first find the rs header and if the header details are not cds then add them
    save_RSEkspindex := SaveAndAdjustIndexName( MainDm.nxRSEksp, 'ReceptIDOrder');
    try
      if not MainDm.nxRSEksp.FindKey([MainDm.nxRSEkspLinReceptId.AsInteger]) then
      begin
        c2logadd('Rs kspeditioner not found for lines');
        exit;
      end;

      MainDm.cdsOrdHeader.IndexFieldNames := 'PaCprNr;Ydnr;YderCprnr';
      PatCPr := MainDm.nxRSEkspPatCPR.AsString;
      YderNr := MainDm.nxRSEkspSenderId.AsString.PadLeft(7,'0');
      YderCPRNr := Trim(MainDm.nxRSEkspIssuerCPRNr.AsString);
      if YderCPRNr = '' then
        YderCPRNr := Trim(MainDm.nxRSEkspIssuerAutNr.AsString);
      if MainDm.cdsOrdHeader.FindKey([PatCPr, YderNr, YderCPRNr]) then
      begin
        c2logadd('found header');
        // if we can find the patient / ydernr / ydercprnr in cds then just add the lines
        MainDm.cdsOrdHeader.Edit; // updates the ordant
        AddCDSLines;
        MainDm.cdsOrdHeader.Post;
        exit;
      end;

      c2logadd(' header not found add new one');
      MainDm.cdsOrdHeader.Append;
      MainDm.cdsOrdHeaderPaCprNr.AsString := PatCPr;
      MainDm.cdsOrdHeaderYdNr.AsString := YderNr;
      LUdstederType := StamForm.CalculateUdstederType(MainDm.nxRSEkspSenderType.AsString);
      if LUdstederType = 3 then
      begin
        Maindm.cdsOrdHeaderYdNr.AsString  := '0990027';

        if ContainsText(MainDm.nxRSEkspSenderNavn.AsString, 'sygehus') or
          ContainsText(MainDm.nxRSEkspSenderNavn.AsString, 'hospital') then
          Maindm.cdsOrdHeaderYdNr.AsString  := '0994057';

      end;
      MainDm.cdsOrdHeaderYderCprNr.AsString := YderCPRNr;
      MainDm.cdsOrdHeaderLbnr.AsInteger := MainDm.nxOrdC2Nr.AsInteger;
      MainDm.cdsOrdHeaderAnnuller.AsBoolean := False;
      MainDm.cdsOrdHeaderPaNvn.AsString := Trim(MainDm.nxRSEkspPatEftNavn.AsString);
      MainDm.cdsOrdHeaderForNavn.AsString := Trim(MainDm.nxRSEkspPatForNavn.AsString);
      if MainDm.cdsOrdHeaderForNavn.AsString <> '' then
        MainDm.cdsOrdHeaderPaNvn.AsString :=
          Trim(MainDm.cdsOrdHeaderPaNvn.AsString) + ',' + Trim(MainDm.cdsOrdHeaderForNavn.AsString);
      MainDm.cdsOrdHeaderAdr.AsString := MainDm.nxRSEkspPatVej.AsString;
      MainDm.cdsOrdHeaderAdr2.AsString := '';
      MainDm.cdsOrdHeaderPostNr.AsString := MainDm.nxRSEkspPatPostNr.AsString;
      MainDm.cdsOrdHeaderBy.AsString := MainDm.nxRSEkspPatBy.AsString;

      MainDm.cdsOrdHeaderAmt.AsString := MainDm.nxRSEkspPatAmt.AsString;
      MainDm.cdsOrdHeaderTlf.AsString := ''; // todo
      MainDm.cdsOrdHeaderAlder.AsString := ''; // todo
      MainDm.cdsOrdHeaderBarn.AsString := ''; // todo
      MainDm.cdsOrdHeaderTilskud.AsString := ''; // todo
      MainDm.cdsOrdHeaderTilBrug.AsString := ''; // todo
      MainDm.cdsOrdHeaderLevering.AsString := MainDm.nxRSEkspLeveringAdresse.AsString;
      MainDm.cdsOrdHeaderFriTxt.AsString := '';
      MainDm.cdsOrdHeaderYdNavn.AsString := MainDm.nxRSEkspIssuerTitel.AsString;
      MainDm.cdsOrdHeaderYdSpec.AsString := ''; // todo
      MainDm.cdsOrdHeaderOrdAnt.AsInteger := 0;
      if (Trim(MainDm.nxRSEkspLeveringsInfo.AsString) <> '') or
        (Trim(MainDm.nxRSEkspOrdreInstruks.AsString) <> '') or
        (Trim(MainDm.nxRSEkspLeveringPri.AsString) <> '') or
        (Trim(MainDm.nxRSEkspLeveringAdresse.AsString) <> '') or
        (Trim(MainDm.nxRSEkspLeveringPseudo.AsString) <> '') or
        (Trim(MainDm.nxRSEkspLeveringPostNr.AsString) <> '') or
        (Trim(MainDm.nxRSEkspLeveringKontakt.AsString) <> '') then
        MainDm.cdsOrdHeaderLevinfo.AsString := 'Vis Ekspedition';
      if (Trim(MainDm.nxRSEkspLeveringsInfo.AsString) <> '') then
        MainDm.cdsOrdHeaderLevinfo.AsString := Trim(MainDm.nxRSEkspLeveringsInfo.AsString);
      if MainDm.EHOrdre then
      begin
        MainDm.cdsOrdHeaderDanmark.AsBoolean := MainDm.nxOrdMedlemAfDanmark.AsBoolean;
        if MainDm.nxOrdApoteketsRef.AsString <> '' then
        begin
          if MainDm.nxOrdApoteketsRef.AsString <> PatientDebitor then
            MainDm.cdsOrdHeaderKontonr.AsString := MainDm.nxOrdApoteketsRef.AsString;
        end;

        MainDm.cdsOrdHeaderOrdreDato.AsDateTime := CreateEhOrdreDato(MainDm.nxOrdOrdredato.AsString);

      end;
      AddCDSLines;
      MainDm.cdsOrdHeader.Post;

    finally
      AdjustIndexName(MainDm.nxRSEksp, save_RSEkspindex);
      c2logadd('Bottom of addlocal rs to cds');
    end;

  end;

  procedure AddCDSLines;
  var
    foundRSEksplin: Boolean;
    ReceivedReceptid: Integer;
    save_RSEKsplinIndex: string;
    printrsordinations: Boolean;
    askprint: Boolean;
    reqsl: TStringList;
    Rseksplindone: Boolean;
    LSavenxekspindex: string;
  begin
    reqsl := TStringList.Create;
    try

      // first rip down all fysyisk lines and add them to newly created ordheader
      // which uses doctor info from patientkartotek if 1 exists
      c2logadd('Top of general addcdslines');
      MainDm.nxOrdLin.First;
      while not MainDm.nxOrdLin.Eof do
      begin
        if (MainDm.nxOrdLinOrdinationType.AsString = 'Fysisk') or
          (MainDm.nxOrdLinOrdinationType.AsString = '') then
        begin
          c2logadd('found a fysisk ' + MainDm.nxOrdLinOrdinationType.AsString);
          MainDm.cdsOrdLinier.Append;
          MainDm.cdsOrdLinierVarenr.AsString := MainDm.nxOrdLinVarenummer.AsString.padleft(6,'0');
          if MainDm.EHOrdre then
            MainDm.cdsOrdLinierSubVarenr.AsString := MainDm.cdsOrdLinierVarenr.AsString;
          AdjustIndexName(MainDm.ffLagKar, 'NrOrden');
          if MainDm.ffLagKar.FindKey([0, MainDm.cdsOrdLinierVarenr.AsString]) then
          begin
            c2logadd('found the product udlevtype is ' + MainDm.ffLagKarUdlevType.AsString);
            MainDm.cdsOrdLinierNavn.AsString := MainDm.ffLagKarNavn.AsString;
            MainDm.cdsOrdLinierDisp.AsString := MainDm.ffLagKarForm.AsString;
            MainDm.cdsOrdLinierStrk.AsString := MainDm.ffLagKarStyrke.AsString;
            MainDm.cdsOrdLinierPakn.AsString := MainDm.ffLagKarPakning.AsString;
            MainDm.cdsOrdLinierDrugid.AsString := maindm.ffLagKarDrugId.AsString;
            MainDm.cdsOrdLinierOpbevKode.AsString := MainDm.ffLagKarOpbevKode.AsString;
          end
          else
          begin
            MainDm.cdsOrdLinierNavn.AsString := MainDm.nxOrdLinVarenavn.AsString;
            MainDm.cdsOrdLinierDisp.AsString := MainDm.nxOrdLinForm.AsString;
            MainDm.cdsOrdLinierStrk.AsString := MainDm.nxOrdLinStyrke.AsString;
            MainDm.cdsOrdLinierPakn.AsString := MainDm.nxOrdLinPakningsstoerrelse.AsString;
            MainDm.cdsOrdLinierDrugid.AsString := '';
            MainDm.cdsOrdLinierOpbevKode.AsString := '';
          end;
          MainDm.cdsOrdLinierSubst.AsString := '-S';
          if MainDm.EHOrdre then
            MainDm.cdsOrdLinierSubst.AsString := MainDm.nxOrdLinSubstitution.AsString;

          MainDm.cdsOrdLinierAntal.AsInteger := MainDm.nxOrdLinAntal.AsInteger;
          MainDm.cdsOrdLinierTilsk.AsString := '';
          MainDm.cdsOrdLinierIndKode.AsString := '';
          MainDm.cdsOrdLinierIndTxt.AsString := '';
          MainDm.cdsOrdLinierUdlev.AsInteger := 0;
          MainDm.cdsOrdLinierForhdl.AsString := '';
          MainDm.cdsOrdLinierDosKode.AsString := '';
          MainDm.cdsOrdLinierDosTxt.AsString := '';
          MainDm.cdsOrdLinierPEMAdmDone.AsInteger := 0;
          MainDm.cdsOrdLinierOrdid.AsString := '';
          MainDm.cdsOrdLinierReceptid.AsInteger := 0;
          MainDm.cdsOrdLinierKlausulBetingelse.AsBoolean := False;
          if MainDm.EHOrdre then
          begin
            MainDm.cdsOrdLinierUserPris.AsCurrency := MainDm.nxOrdLinListeprisPerStk.AsCurrency;

            if MainDm.nxOrdLinOrdineretVarenummer.AsString <> '' then
            begin

              if MainDm.nxOrdLinOrdineretVarenummer.AsString <> MainDm.nxOrdLinVarenummer.AsString
              then
              begin
                MainDm.cdsOrdLinierVarenr.AsString := MainDm.nxOrdLinOrdineretVarenummer.AsString;
                MainDm.cdsOrdLinierSubVarenr.AsString := MainDm.nxOrdLinVarenummer.AsString;
              end;
            end;
          end;

          MainDm.cdsOrdLinier.Post;

          MainDm.cdsOrdHeader.Edit;
          MainDm.cdsOrdHeaderOrdAnt.AsInteger := MainDm.cdsOrdHeaderOrdAnt.AsInteger + 1;
          MainDm.cdsOrdHeader.Post;

        end;
        MainDm.nxOrdLin.Next;
      end;

      c2logadd('look for receptkvittering');
      printrsordinations := False;
      askprint := True;
      MainDm.nxOrdLin.First;
      while not MainDm.nxOrdLin.Eof do
      begin
        c2logadd('ordination type is ' + MainDm.nxOrdLinOrdinationType.AsString);
        if MainDm.nxOrdLinOrdinationType.AsString <> 'Receptkvittering' then
        begin
          MainDm.nxOrdLin.Next;
          Continue;
        end;
        foundRSEksplin := False;
        Rseksplindone := False;
        c2logadd('found 1 so look if its stored locally ' +
          MainDm.nxOrdLinOrdinationsId.AsString);
        // we look locally so we need to check for an open one
        save_RSEKsplinIndex := SaveAndAdjustIndexName(MainDm.nxRSEkspLin,'OrdIdOrden');
        MainDm.nxRSEkspLin.SetRange([MainDm.nxOrdLinOrdinationsId.AsString],
          [MainDm.nxOrdLinOrdinationsId.AsString]);
        try
          MainDm.nxRSEkspLin.Last;
          while not MainDm.nxRSEkspLin.Bof do
          begin
            if MainDm.nxRSEkspLinRSLbnr.AsInteger = 0 then
            begin
              if MainDm.nxRSEkspLinFrigivStatus.AsInteger = 1 then
              begin
                MainDm.nxRSEkspLin.Prior;
                Continue;
              end;
              foundRSEksplin := True;
              break;
            end;
            MainDm.nxRSEkspLin.Prior;
          end;

          if not foundRSEksplin then
          begin
            MainDm.nxRSEkspLin.Last;
            while not MainDm.nxRSEkspLin.Bof do
            begin
              if MainDm.nxRSEkspLinRSLbnr.AsInteger = 0 then
              begin
                MainDm.nxRSEkspLin.Prior;
                Continue;
              end;

              try
                LSavenxekspindex := SaveAndAdjustIndexName(MainDm.nxEksp, 'NrOrden');
                try
                  if MainDm.nxEksp.FindKey([MainDm.nxRSEkspLinRSLbnr.AsInteger]) then
                  begin
                    if not frmYesNo.NewYesNoBox('Receptordinationen på ' +
                      MainDm.nxOrdLinVarenavn.AsString +
                      ' findes i Lokale Recepter med løbenr ' +
                      MainDm.nxRSEkspLinRSLbnr.AsString + slinebreak + 'og dato ' +
                      MainDm.nxEksp.fieldbyname('takserDato').AsString + slinebreak +
                      'Vil du prøve at hente ordinationen fra FMK?')
                    then
                    begin

                      Rseksplindone := True;
                    end;
                    break;
                  end;
                finally
                  MainDm.nxEksp.IndexName := LSavenxekspindex;
                end;
              except
                on e: Exception do
                  ChkBoxOK(e.Message);
              end;

              MainDm.nxRSEkspLin.Prior;
            end;
          end;

        finally
          MainDm.nxRSEkspLin.CancelRange;
          MainDm.nxRSEkspLin.IndexName := save_RSEKsplinIndex;
        end;

        if Rseksplindone then
        begin
          MainDm.nxOrdLin.Next;
          Continue;
        end;

        if foundRSEksplin then
        begin
          c2logadd('found it so add from local');
          if askprint then
          begin
            printrsordinations := ChkBoxYesNo('Udskriv receptkvittering?', True);
            askprint := False;
          end;
          if printrsordinations then
          begin
            RCPMidCli.SendRequest('GetAddressed',
              ['4', MainDm.nxRSEkspLinReceptId.AsString,
              inttostr(MainDm.AfdNr), MainDm.C2UserName], 10);
          end;
          AddLocalRSLineToCdsOrd;
          MainDm.nxOrdLin.Next;
          Continue;
        end;

        c2logadd('not found so try download from FMK');
        AdjustIndexName(MainDm.nxEHSettings, 'ApotekIdOrden');
        if MainDm.nxEHSettings.FindKey([MainDm.nxOrdApotekId.AsString]) then
        begin
          if askprint then
          begin
            printrsordinations := ChkBoxYesNo('Udskriv receptkvittering?', True);
            askprint := False;
          end;
          // we need to get ordination from the receptserver
          c2logadd('about to send the request to rsmidsrv');
          reqsl.Clear;
          reqsl.add(format('%-20.20s %-20.20s', [MainDm.nxOrdLinReceptId.AsString,
            MainDm.nxOrdLinOrdinationsId.AsString]));

          if not  uFMKGetMedsById.FMKGetMedById(MainDm.nxOrdKundeCPR.AsString,
            MainDm.nxOrdLinOrdinationsId.AsString, MainDm.nxEHSettingsAfdeling.AsInteger,
            ReceivedReceptid, printrsordinations,True, RSErrorMessage) then
          begin
            ChkBoxOK(RSErrorMessage+ slinebreak +
                      MainDm.nxOrdLinOrdinationsId.AsString +' : ' + MainDm.nxOrdLinVarenavn.AsString);
            MainDm.nxOrdLin.Next;
            continue;
          end;
          C2LogAddF('received recept id is %d',[ReceivedReceptid]);
          // we look locally so we need to check for an open one
          save_RSEKsplinIndex := SaveAndAdjustIndexName(MainDm.nxRSEkspLin, 'OrdIdOrden');
          MainDm.nxRSEkspLin.SetRange([MainDm.nxOrdLinOrdinationsId.AsString],
            [MainDm.nxOrdLinOrdinationsId.AsString]);
          try
            MainDm.nxRSEkspLin.Last;
            while not MainDm.nxRSEkspLin.Bof do
            begin
              if MainDm.nxRSEkspLinRSLbnr.AsInteger = 0 then
              begin
                if MainDm.nxRSEkspLinFrigivStatus.AsInteger = 1 then
                begin
                  MainDm.nxRSEkspLin.Prior;
                  Continue;
                end;
                foundRSEksplin := True;
                break;
              end;
              MainDm.nxRSEkspLin.Prior;
            end;

          finally
            MainDm.nxRSEkspLin.CancelRange;
            AdjustIndexName(MainDm.nxRSEkspLin, save_RSEKsplinIndex);
          end;
          c2logadd('found rseksplin is now ' + Bool2Str(foundRSEksplin));
          if foundRSEksplin then
            AddLocalRSLineToCdsOrd;

        end;

        MainDm.nxOrdLin.Next;
      end;

    finally
      reqsl.Free;
    end;
  end;

  function CreateCDSFile: Boolean;
  var
    PatCPr: string;
    YderNr: string;
    YderCPRNr: string;
    PaNavn: string;
    PatVej: string;
    PatAdr2: string;
    PatBy: string;
    PatPostNr: string;
    LUdstederType: Integer;
  begin
    Result := True;
    MainDm.cdsOrdHeader.Open;
    // first delete any contents
    MainDm.cdsOrdHeader.First;
    while not MainDm.cdsOrdHeader.Eof do
    begin
      MainDm.cdsOrdLinier.First;
      while not MainDm.cdsOrdLinier.Eof do
        MainDm.cdsOrdLinier.Delete;
      MainDm.cdsOrdHeader.Delete;
    end;

    try

      MainDm.cdsOrdHeader.LogChanges := False;
      MainDm.cdsOrdHeader.IndexFieldNames := 'PaCprNr;Ydnr;YderCprnr';
      PatCPr := MainDm.nxOrdKundeCPR.AsString;

      if PatCPr = '' then
      begin
        PatCPr := '99' + format('%7.7d', [MainDm.nxOrdC2Nr.AsInteger]);
        MainDm.EHCPR := True;
        if MainDm.C2WebOpdaterKundenr then
        begin
          MainDm.nxOrd.Edit;
          MainDm.nxOrdKundeCPR.AsString := PatCPr;
          MainDm.nxOrd.Post;
        end;
      end;

      if PatCPr.StartsWith('99') and (Length(PatCPr) = 9) then
        MainDm.EHCPR := True;

      if MainDm.ffPatKar.FindKey([PatCPr]) then
      begin
        YderNr := MainDm.ffPatKarYderNr.AsString;
        YderCPRNr := MainDm.ffPatKarYderCprNr.AsString;
        PaNavn := MainDm.ffPatKarNavn.AsString;
        PatVej := MainDm.ffPatKarAdr1.AsString;
        PatAdr2 := MainDm.ffPatKarAdr2.AsString;
        PatBy := MainDm.ffPatKarBy.AsString;
        PatPostNr := MainDm.ffPatKarPostNr.AsString;
        PatientDebitor := MainDm.ffPatKarDebitorNr.AsString;
      end
      else
      begin
        YderNr := '0990027';
        YderCPRNr := '09YM9';
        PaNavn := MainDm.nxOrdHjemNavn.AsString;
        PatVej := MainDm.nxOrdHjemAdresse1.AsString;
        PatAdr2 := MainDm.nxOrdHjemAdresse2.AsString;
        PatBy := MainDm.nxOrdHjemBy.AsString;
        PatPostNr := MainDm.nxOrdHjemPostnummer.AsString;
        PatientDebitor := '';

      end;

      MainDm.cdsOrdHeader.Append;
      MainDm.cdsOrdHeaderPaCprNr.AsString := PatCPr;
      MainDm.cdsOrdHeaderYdNr.AsString := YderNr;
      MainDm.cdsOrdHeaderYderCprNr.AsString := YderCPRNr;
      MainDm.cdsOrdHeaderLbnr.AsInteger := MainDm.nxOrdC2Nr.AsInteger;
      MainDm.cdsOrdHeaderAnnuller.AsBoolean := False;
      MainDm.cdsOrdHeaderPaNvn.AsString := PaNavn;
      MainDm.cdsOrdHeaderForNavn.AsString := '';
      MainDm.cdsOrdHeaderAdr.AsString := PatVej;
      MainDm.cdsOrdHeaderAdr2.AsString := PatAdr2;
      MainDm.cdsOrdHeaderPostNr.AsString := PatPostNr;
      MainDm.cdsOrdHeaderBy.AsString := PatBy;

      MainDm.cdsOrdHeaderAmt.AsString := MainDm.nxRSEkspPatAmt.AsString;
      MainDm.cdsOrdHeaderTlf.AsString := ''; // todo
      MainDm.cdsOrdHeaderAlder.AsString := ''; // todo
      MainDm.cdsOrdHeaderBarn.AsString := ''; // todo
      MainDm.cdsOrdHeaderTilskud.AsString := ''; // todo
      MainDm.cdsOrdHeaderTilBrug.AsString := ''; // todo
      MainDm.cdsOrdHeaderLevering.AsString := MainDm.nxOrdLeveringsAdresse1.AsString;
      MainDm.cdsOrdHeaderFriTxt.AsString := '';
      // need to get the doctor name from yderkartotek
      MainDm.cdsOrdHeaderYdNavn.AsString := '';
      MainDm.ffYdLst.IndexName := 'YderNrOrden';
      if MainDm.ffYdLst.FindKey([YderNr,YderCprnr]) then
        MainDm.cdsOrdHeaderYdNavn.AsString := MainDm.ffYdLstNavn.AsString;
      MainDm.cdsOrdHeaderYdSpec.AsString := ''; // todo
      MainDm.cdsOrdHeaderOrdAnt.AsInteger := 0;
      MainDm.cdsOrdHeaderLevinfo.AsString := MainDm.nxOrdLeveringsmetode.AsString;
      if MainDm.EHOrdre then
      begin
        MainDm.cdsOrdHeaderDanmark.AsBoolean := MainDm.nxOrdMedlemAfDanmark.AsBoolean;
        if MainDm.nxOrdApoteketsRef.AsString <> '' then
        begin
          if MainDm.nxOrdApoteketsRef.AsString <> PatientDebitor then
            MainDm.cdsOrdHeaderKontonr.AsString := MainDm.nxOrdApoteketsRef.AsString;
        end;
        MainDm.cdsOrdHeaderOrdreDato.AsDateTime := CreateEhOrdreDato(MainDm.nxOrdOrdredato.AsString);

      end;

      MainDm.cdsOrdHeader.Post;
      AddCDSLines;

      // lets delete any headers that have no lines. this is uisusally due to failed download
      // from receptserver.  if the file is empty when they try to scan in patientkartotek they will get an error
      // they must then do it manually
      MainDm.cdsOrdHeader.First;
      while not MainDm.cdsOrdHeader.Eof do
      begin
        if MainDm.cdsOrdLinier.RecordCount <> 0 then
          MainDm.cdsOrdHeader.Next
        else
          MainDm.cdsOrdHeader.Delete;
      end;

    finally
      if MainDm.cdsOrdHeader.RecordCount <> 0 then
      begin
        ForceDirectories('G:\Service\Ehandle\');
        // cdsOrdHeader.SaveToFile('G:\Service\Ehandle\EH' + nxOrdC2Nr.AsString + '.xml',dfXMLUTF8);
      end;
    end;

  end;

  function CheckEordreOrdinations(AEordreNr : integer; AKundeNr : string) : boolean;
  var
    LErrorlist : TStringList;
    LOrdidList : TStringList;
    LOrdid : string;
    LerrorString: string;
    LPrivat : integer;
    LReceptId : integer;
    LQry : TnxQuery;

    function IsOrdidLocal(const AMedId : string; var APrivat : integer; var AReceptid :integer ) : boolean;
    var
      RefreshSql: string;
      LQry : TnxQuery;
    begin
      Result := False;
      APrivat := 0;
      AReceptid := 0;
      try
        RefreshSql := 'select ' +  fnRS_EkspLinierReceptId + fnRS_EkspLinierOrdId_K +
              fnRS_EkspLinierPrivat_K + ' from ' + tnRS_EkspLinier + ' where ' + fnRS_EkspLinierOrdId_P +
          ' and coalesce(' + fnRS_EkspLinierLbNr + ',0)=0';
        c2logadd('Refresh sql is ' + RefreshSql);
        LQry := MainDm.nxdb.OpenQuery(RefreshSql, [AMedId]);
        try
          Result := not LQry.Eof;
          if Result  then
          begin
            APrivat := LQry.FieldByName(fnRS_EkspLinierPrivat).AsInteger;
            AReceptid := LQry.FieldByName(fnRS_EkspLinierReceptId).AsInteger;
          end;
        finally
          LQry.Free;
        end;
      except
        on e : Exception do
          C2LogAdd('Fejl in get refreshed ordination sql ' + e.Message);
      end;
    end;

    function ReadableMessage(const AMessage : string) :string;
    var
      doc: DOMDocument;
      nodelist: IXMLDOMNodeList;
      i: integer;
      LErrorMessage : string;
    begin
      Result := AMessage;
      if pos('<?xml', AMessage) = 0 then
        exit;
      doc := CoDOMDocument.Create;
      try
        doc.loadXML(AMessage);
      except
        on e: exception do
        begin
          c2logadd('error in loadxml ' + e.message);
          exit;
        end;
      end;
      nodelist := doc.documentElement.selectNodes('/ErrorResponse/Description');
      if nodelist.length > 0 then
      begin
        for i := 0 to nodelist.length - 1 do
          c2logadd('ERRORDESC=' + nodelist.item[i].text);
      end;
      nodelist := doc.documentElement.selectNodes('/ErrorResponse/Details');
      if nodelist.length > 0 then
      begin
        for i := 0 to pred(nodelist.length) do
        begin
          LErrorMessage := nodelist.item[i].text;
          Result := StringReplace(LErrorMessage,'. ','.'+ slinebreak,[rfReplaceAll]);
        end;
      end;
    end;

  begin
    Result := False;
    LErrorlist := TStringList.Create;
    LOrdidList := TStringList.Create;
    try
      LQry := MainDm.nxdb.OpenQuery('select ' + fnEHOrdreLinierOrdinationsId + ' from '
        + tnEHOrdreLinier + ' where ' + fnEHOrdreLinierC2Nr +
        '=:Eordrenr and ' + fnEHOrdreLinierOrdinationsId + '<> ''''',
        [AEordreNr]);
      try
        if Eof then // if there are none then get out all is well
          exit(True);

        LQry.First;
        while not LQry.Eof do
        begin
          LOrdidList.Add(LQry.FieldByName(fnEHOrdreLinierOrdinationsId).AsString);
          LQry.Next;
        end;
      finally
        LQry.Free;
      end;
      for LOrdid in LOrdidList do
      begin
        if IsOrdidLocal(LOrdid,LPrivat,LReceptId) then
        begin
          if not uFMKGetMedsById.RefreshReceivedMedications(AKundeNr,
                  LPrivat,
                  LOrdid,
                  MainDm.AfdNr,
                  LReceptId,False,True) then
            LErrorlist.Add(LOrdid);
        end
        else
        begin
          uFMKGetMedsById.FMKGetMedById(AKundeNr,LOrdid,MainDm.AfdNr,LReceptId,False,True,LerrorString);
          if not LerrorString.IsEmpty then
            LErrorlist.Add(ReadableMessage( LerrorString));
        end;
      end;
      Result := LErrorlist.Count = 0;
      if not Result then
      begin
        ChkBoxOK('Fejl list' + sLineBreak + sLineBreak + LErrorlist.Text);
      end;
    finally
      FreeAndNil(LOrdidList);
      FreeAndNil(LErrorlist);
    end;
  end;
begin
//  with MainDm do
  C2LogAdd('TakserEh started with c2nr ' + AC2Nr.ToString);
  save_index := SaveAndAdjustIndexName(MainDm.nxOrd, 'C2NrOrden');
  if MainDm.C2Web then
    MainDm.EHOrdre := True;
  MainDm.EHCPR := False;

  try
    MainDm.TakserC2Nr := AC2Nr;
    if not MainDm.nxOrd.FindKey([AC2Nr]) then
    begin
      ShowMessageBoxWithLogging('Eordre findes ikke','Meddelelse',MB_OK);
      exit;
    end;
//      if not CheckEordreOrdinations(AC2Nr,nxOrdKundeCPR.AsString) then
//        exit;
    MainDm.EHDibs := MainDm.nxOrdDibsTransaktionsId.AsString <> '';
    if CreateCDSFile then
      konvCDSBatch(StamPages.ActivePage);
  finally
    MainDm.TakserC2Nr :=0;
    MainDm.nxOrd.IndexName := save_index;
    MainDm.nxord.Refresh;
    MainDm.EHDibs := False;
    MainDm.EHOrdre := False;
    MainDm.EHCPR := False;
  end;
end;

procedure TStamForm.TC2QFrame1bitHkbClick(Sender: TObject);
begin
  TC2QFrame1.acC2QHkbExecute(Sender);

end;

procedure TStamForm.TC2QFrame1bitNaesteClick(Sender: TObject);
begin
  TC2QFrame1.acC2QNaesteExecute(Sender);

end;

procedure TStamForm.TC2QFrame1bitRecClick(Sender: TObject);
begin
  TC2QFrame1.acC2qRecExecute(Sender);

end;

procedure TStamForm.TilF5Handler;
  procedure CheckDosis(const AKundenr : string);
  begin
    TfrmDosiskort.WarnDoskort(AKundenr, TFMKPersonIdentifierSource.DetectSource(AKundenr));
  end;

begin
  with MainDm do
  begin
    if Assigned(ActiveControl) then
      SendMessage(ActiveControl.Handle, CM_EXIT, 0, 0);
    if ffPatTil.State = dsBrowse then
    begin
      ChkBoxOK('Kun Gem i Ret/Opret tilstand!');
      exit;
    end;
    if (ffPatTil.State = dsEdit) and (ffPatKarKommune.AsInteger = 101) then
    begin
      if not ChkBoxYesNo('Er Journalnummeret korrekt?', False) then
      begin
        TilEJnr.SetFocus;
        exit;
      end;
    end;
    if ffPatTilChkJournalNr.AsBoolean then
    begin
      if Length(Trim(ffPatTilJournalNr.AsString)) <> 10 then
      begin
        ChkBoxOK('Journalnummer skal bestå af 10 karakterer');
        exit;
      end;
    end;
    if (ffPatTilRegel.Value = 0) or (ffPatTilOrden.Value = 0) then
    begin
      ChkBoxOK('Et eller flere felter mangler!');
      exit;
    end;
    if Length(ffPatTilAtcKode.AsString) > 7 then
    begin
      ChkBoxOK('ATC Kode er for lang');
      exit;
    end;

    if ffPatTilFraDato.AsString = '' then
    begin
      ChkBoxOK('Fejl i fradato');
      exit;
    end;

    if DateOf(MainDm.ffPatTilTilDato.AsDateTime) < DateOf(MainDm.ffPatTilFraDato.AsDateTime)then
    begin
      ChkBoxOK('Fejl i tildato');
      TilTilDato.SetFocus;
      exit;

    end;

    CheckDosis(ffPatKarKundeNr.AsString);
    try
      ffPatTilAtcKode.AsString := caps(ffPatTilAtcKode.AsString);
      ffPatTilPromille2.Value := ffPatTilPromille1.Value;
      ffPatTilPromille3.Value := ffPatTilPromille1.Value;
      ffPatTilPromille4.Value := ffPatTilPromille1.Value;
      // dsKar.DataSet.Post;
      ffPatTil.Post;
    except
      ChkBoxOK('Ret/opret post IKKE gennemført!');
    end;
  end;
end;

procedure TStamForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  try
    AllowLogoff := False;
    if Key <> #13 then
      exit;
  finally
    if (ActiveControl <> EKundeNr) and (ActiveControl <> dbgLocalRS) and
      (ActiveControl <> edtCprNr) and (ActiveControl <> eUafLb) and
      (ActiveControl <> EYderCprNr) and (ActiveControl <> eEkspLb) then
      inherited;
  end;
end;

procedure TStamForm.FormResize(Sender: TObject);
begin
  if Height >= 700 then
    pnlBtnLeft.Visible := True
  else
    pnlBtnLeft.Visible := False;

end;

procedure TStamForm.KeyHandler(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Inherited;
  AllowLogoff := False;
  if Shift = [] then
  begin
    if ActiveControl is TDBComboBox then
    begin
      if Key in [VK_HOME, VK_NEXT, VK_PRIOR, VK_END] then
        exit;
    end;
    exit;
  end;

  if Shift = [ssAlt] then
  begin
    if StamPages.ActivePage = RSLocalPage then
    begin
      Case Chr(Key) of
        // 'r', 'R' : dbgLocalRSTitleClick (DBGrid1.Columns [0]);
        'l', 'L':
          dbgLocalRSTitleClick(DBGrid1.Columns[1]);
      end;
      c2logadd('Key is ' + inttostr(Key));
      if Key = 221 then
        edtReason.SetFocus;
    end;
  end;
end;

procedure TStamForm.DeleteLocalPrescription(AReceptId: integer; APrescriptionId: Int64);
var
  LQry : TnxQuery;
begin

  // first delete the line from rs_eksplinier
  LQry :=TnxQuery.Create(Nil);

  try
    LQry.Database  := Maindm.nxdb;
    LQry.sql.Text := 'delete from ' + tnRS_EkspLinier + ' where ' + fnRS_EkspLinierReceptId + '=' + AReceptId.ToString +
                ' and ' + fnRS_EkspLinierPrescriptionIdentifier + '=' + APrescriptionId.ToString;
    LQry.ExecSQL;
    if LQry.RowsAffected = 0 then
      exit;

  finally
    LQry.Free;
  end;



  // now look to see if there are any lines left on the recptid

  LQry := MainDm.nxdb.OpenQuery('select ' + fnRS_EkspLinierReceptId + ' from ' +
    tnRS_EkspLinier + ' where ' + fnRS_EkspLinierReceptId_P, [aReceptId]);
  try
    if not LQry.eof then
      exit;


  finally
    LQry.Free;
  end;

  // if we get here then delete the local RS_ekspeditioner
  LQry := TnxQuery.Create(Nil);
  try
    LQry.Database  := MainDm.nxdb;
    LQry.sql.Text := 'delete from ' + tnRS_Ekspeditioner + ' where ' + fnRS_EkspeditionerReceptId + '=' + AReceptId.ToString;
    LQry.ExecSQL;
    if LQry.RowsAffected = 0 then
      exit;

  finally
    LQry.Free;
  end;


end;

procedure TStamForm.DropDown(Sender: TObject);
var
  dbl: TDBLookupComboBox;
  dbc: TDBComboBox;
begin

  if (Sender is TDBLookupComboBox) then
  begin
    dbl := TDBLookupComboBox(Sender);
    dbl.DropDownRows := dbl.ListSource.dataset.RecordCount;
    if dbl = ECtrLand then
      dbl.DropDownRows := 7;
    exit;
  end;
  if (Sender is TDBComboBox) then
  begin
    dbc := TDBComboBox(Sender);
    dbc.DropDownCount := dbc.Items.Count;
  end;

end;

procedure TStamForm.FormCreate(Sender: TObject);
var
  ExeName: String;
  DebitorTypes: string;
  i: Integer;
  j: Integer;
  LC2QAlias : string;
begin
  with MainDm do
  begin
    TSplashScreen.UpdateActionText('Create mainform');
    Application.OnMessage := AppMessage;
    ExeName := ExtractFileName(Application.ExeName);
    if not MatchText(ExeName, ['PATIENTKARTOTEK.EXE', 'ARKIVPATIENTKARTOTEK.EXE'])  then
    begin
      C2ButPanel.Color := clYellow;
      Application.Title := 'Ekspedition Ekstra';
      Caption := 'Ekspedition Ekstra';
      if FileExists('G:\kartotekextra.ico') then
        Application.Icon.LoadFromFile('G:\kartotekextra.ico');
    end;
    Inherited;
    Application.OnDeactivate := AppDeactivate;
    if Assigned(SplashForm) then
      SplashScreenUpdate('MainForm')
    else
      TSplashScreen.UpdateActionText('MainForm');

    TC2QFrame1.bitRec.Caption := 'Recept' + sLineBreak + 'Alt-F1';
    TC2QFrame1.bitHkb.Caption := 'Håndkøb' + sLineBreak + 'Alt-F2';
    TC2QFrame1.bitFort.Caption := 'Fortryd' + slinebreak + 'Alt-F3';
    TC2QFrame1.bitLukke.Caption := 'Lukke' + slinebreak + 'Alt-F4';
    TC2QFrame1.bitNaeste.Caption := 'Næste' + slinebreak + 'Alt-F5';
    CallEnabled := False;
    CloseAtOnce := False;
    TakserActive := False;
    FirstTime := True;
    SidKundeNr := '';
    c2logadd('create: sidkundenr ' + SidKundeNr);
//    FBrNr := 0;
    {
      if ParamCount > 0 then begin
      if Pos('/Bruger=', ParamStr (1)) > 0 then
      FBrNr:= StrToInt (Copy (ParamStr (1), 9, Length (ParamStr (1)) - 8));
      end;
    }
    if not DirectoryExists('C:\C2\Dagsedler\') then
      ForceDirectories('C:\C2\Dagsedler\');
    if not DirectoryExists('C:\C2\Afregning\Sygesikring\') then
      ForceDirectories('C:\C2\Afregning\Sygesikring\');
    if not DirectoryExists('C:\C2\Afregning\Kommuner\') then
      ForceDirectories('C:\C2\Afregning\Kommuner\');
    if not DirectoryExists('C:\C2\Afregning\Lms\') then
      ForceDirectories('C:\C2\Afregning\Lms\');
    if not DirectoryExists('C:\C2\Temp\') then
      ForceDirectories('C:\C2\Temp\');
    DosEtiket := TStringList.Create;
    // SidPakkeNr:= 0;
    c2logadd('StamForm Create SysUserName"' + MainDm.C2UserName + '"');
    FPladsNr := C2IntPrm('Receptur', 'Arbejdsplads', 0);
    FPladsNr := C2IntPrm(MainDm.C2UserName, 'Arbejdsplads', FPladsNr);
    c2logadd('StamForm Create PladsNr"' + inttostr(FPladsNr) + '"');
    // C2LogSave;
    // Test parametre
    if (FPladsNr = 0) then
    begin
      ChkBoxOK('Arbejdspladsen har ikke nr i "WinPacer.Ini"');
      Application.Terminate;
      exit;
    end;
    if not ffArbOpl.FindKey([FPladsNr]) then
    begin
      ChkBoxOK('Arbejdspladsen findes ikke i databasen');
      Application.Terminate;
      exit;
    end;

    if not ffLagNvn.FindKey([ffArbOplSpecLager.AsString]) then
    begin
      ChkBoxOK('Lager findes ikke i databasen');
      Application.Terminate;
      exit;
    end;
    // Husk LagerNr til taksering
    FLagerNr := ffLagNvnRefNr.AsInteger;
    if not ffAfdNvn.FindKey([ffArbOplAfdeling.AsString]) then
    begin
      ChkBoxOK('Afdeling findes ikke i databasen');
      Application.Terminate;
      exit;
    end;

    // Husk AfdNr til taksering
    MainDm.AfdNr := ffAfdNvnRefNr.AsInteger;
    FAfdelNavn := ffAfdNvnNavn.AsString;
    AfdelingLMSNr := ffAfdNvnLmsNr.AsString;
    StockLager := FLagerNr;

    // setup rowa stuff
    RobotSection := C2StrPrm(MainDm.C2UserName, 'RobotSection', 'Rowa');
    RowaEnabled := SameText(C2StrPrm(RobotSection, 'Aktiveret', 'Nej'), 'Ja');
    if RowaEnabled then
      RowaEnabled := C2StrPrm(MainDm.C2UserName, 'RowaAktiveret', 'Ja') = 'Ja';
    RowaLokation := C2IntPrm(RobotSection, 'Lokation', 0);
    ReceptServer := C2StrPrm('Receptserver', 'Aktiveret', 'Nej') = 'Ja';
    VisUdlevStoerreEndMax := SameText(C2StrPrm('Receptserver', 'VisUdlevStørreEndMax', 'JA'),'JA');
    RowaOrdre := SameText(C2StrPrm(MainDm.C2UserName, 'RobotOrdre', 'Nej'), 'Ja');
    RowaGemOrdre := SameText(C2StrPrm(MainDm.C2UserName, 'RobotGemOrdre', 'Ja'), 'Ja');


    // setup the the list of accounnt types to popup message about
    // different stocks and afdeling

    DebitorPopup := False;
    DebitorPopupAutoret := False;

    DebitorTypes := C2StrPrm('Debitor', 'SammeLagerOgAfdelingLevering', '');
    DebitorTypes := C2StrPrm(MainDm.C2UserName, 'SammeLagerOgAfdelingLevering', DebitorTypes);
    Spoerg_Lager_Debitor := SameText(C2StrPrm(MainDm.C2UserName, 'Spørg_Lager_Debitor', 'NEJ'), 'JA');
    DebitorPopupAutoret := SameText(C2StrPrm('Debitor', 'AutoretLager', ''),'JA');
    DebitorPopupAutoret := SameText(C2StrPrm(MainDm.C2UserName, 'AutoretLager',
      C2StrPrm('Debitor', 'AutoretLager', '')), 'JA');
    DebitorPopup := DebitorTypes <> '';
    for i := 1 to 10 do
      DebitorPopupType[i] := -1;

    i := 0;

    try
      while DebitorTypes <> '' do
      begin
        j := pos(',', DebitorTypes);
        if j <> 0 then
        begin
          i := i + 1;
          DebitorPopupType[i] := StrToInt(copy(DebitorTypes, 1, j - 1));
          Delete(DebitorTypes, 1, j);
        end
        else
        begin
          if DebitorTypes <> '' then
          begin
            i := i + 1;
            DebitorPopupType[i] := StrToInt(DebitorTypes);
          end;
          DebitorTypes := '';
        end;

      end;
    except
      c2logadd('Problem processing Debitor segment in winpacer.ini');

    end;
    // C2LogSave;

    FPemUserName := C2StrPrm('Receptserver', 'User', 'blank');
    FPemPassWord := C2StrPrm('Receptserver', 'Password', 'blank');
    Pris_CTR_ekspliste := C2StrPrm('Receptur', 'Pris_CTR_ekspliste', '10,00');
    Pris_ekspliste := C2StrPrm('Receptur', 'Pris_ekspliste', '10,00');
    Afslut_i_CF5_CF6 := SameText(C2StrPrm('Receptur', 'Afslut_i_CF5_CF6', 'Nej'), 'JA');
    SkaffevareBar := C2StrPrm('Receptur', 'SkaffevareBar', 'CLFUCHSIA');

    // vet info

    VetNettoPris := SameText(C2StrPrm('Vet', 'Nettopris', 'NEJ'), 'JA');
    FakturaLinierUdenMoms := SameText(C2StrPrm(MainDm.C2UserName, 'FakturaLinierUdenMoms', 'NEJ'),'JA');
    VetDebgruppeStr := C2StrPrm('Vet', 'DebGruppe', '');
    VetGebyrNr := C2StrPrm('Vet', 'VetGebyrNr', '');
    VetProcent := C2IntPrm('Vet', 'VetProcent', 0) / 1000;;
    for i := 1 to 10 do
      VetDebGruppe[i] := -1;

    i := 0;

    try
      while VetDebgruppeStr <> '' do
      begin
        j := pos(',', VetDebgruppeStr);
        if j <> 0 then
        begin
          i := i + 1;
          VetDebGruppe[i] := StrToInt(copy(VetDebgruppeStr, 1, j - 1));
          Delete(VetDebgruppeStr, 1, j);
        end
        else
        begin
          if VetDebgruppeStr <> '' then
          begin
            i := i + 1;
            VetDebGruppe[i] := StrToInt(VetDebgruppeStr);
          end;
          VetDebgruppeStr := '';
        end;

      end;
    except
      c2logadd('Problem procesing VET Debitor GRUPPES segment in winpacer.ini');

    end;

    // recept server address check kontrol

    ReceptAddrPopup := SameText(C2StrPrm('Receptur', 'ReceptAddrPopup', 'Nej'), 'JA');
    ReceptAddrPopupAlle := SameText(C2StrPrm('Receptur', 'ReceptAddrPopupAlle', 'Nej'), 'JA');
    GemNyeRsFornavnEfternavn := SameText(C2StrPrm('Receptur', 'GemNyeRsFornavnEfternavn', 'Nej'), 'JA');
    // rule 76 logic

    Regel_76_Tilskudspris := SameText(C2StrPrm('Receptur', 'Regel_76_Tilskudspris', 'Nej'), 'JA');
    CitoEkspeditionAktiv := SameText(C2StrPrm(MainDm.C2UserName, 'CitoEkspeditionAktiv', 'Nej'), 'JA');
    Spoerg_AutorisationsNr := SameText(C2StrPrm('Receptur', 'Spørg_AutorisationsNr', 'Ja'), 'JA');
    Spoerg_YderNr := SameText(C2StrPrm('Receptur', 'SpørgYdernrKorrekt', 'Nej'), 'JA');
    Pakkeliste_sorteret_efter_pakkenr := SameText(C2StrPrm('Receptur', 'Pakkeliste_sorteret_efter_pakkenr', 'Nej'), 'JA');

    // choose whether to go full screen or not
    FullScreen := SameText(C2StrPrm(MainDm.C2UserName, 'FuldSkærm', 'JA'), 'JA');
    Udskriv_recept_pop_up := SameText(C2StrPrm('Receptur', 'Udskriv_recept_pop_up', 'JA'), 'JA');
    TilladKrediteringAfReturEksp := SameText(C2StrPrm('Receptur', 'TilladKrediteringAfReturEksp', 'JA'), 'JA');
    SpoergReservation := SameText(C2StrPrm(MainDm.C2UserName, 'SpørgReservation',
      C2StrPrm('Receptur', 'SpørgReservation', 'JA')), 'JA');
    SpoergSendFakturaElektronisk := SameText(C2StrPrm('Receptur', 'SpørgSendFakturaElektronisk', 'JA'), 'JA');
    // C2LogSave;
    StamPages.ActivePage := KartotekPage;
    save_ediNr := 0;
    Save_EordreNr := '';
    Save_Datofra := 0;
    Save_lbLagerIndex := 0;
    ProgramVersion := C2FileVersion(Application.ExeName);
    ProgramVersTestCount := 0;
    LogoffTimer := 0;
    AllowLogoff := False;
    LogAfTid := C2IntPrm('Receptur', 'LogAfTid', 0);
    EdiIntervalAdvarsel := SameText(C2StrPrm('Receptur', 'CheckUdleveringsInterval', 'JA'), 'JA');
    HentDosisIndikationsForslag := SameText(C2StrPrm('Receptur', 'HentDosisIndikationsForslag', 'NEJ'), 'JA');
    CF3Lbnr := 0;
    NavneEtiketCount := 0;
    UseInfertTakser := False;
    ProgramFolder := IncludeTrailingPathDelimiter(C2StrPrm('Generelt', 'Programsti', 'C:\C2\Programmer\'));
// 23-08-2018/MA: Replaced with HostIsC2Server
//    if (C2HostName = 'C2SERVER') or (C2HostName = 'TSSERVER') then
    if HostIsC2Server then
      ProgramFolder := IncludeTrailingPathDelimiter(ProgramFolder + C2UserName);
    ForceDirectories(ProgramFolder);
    ForceDirectories('G:\temp\Orders\');
    JumpToZeroLbnr := False;
    CF5Ordlist := TStringList.Create;
    CF6Selected := Tlist<TBookmark>.Create;
    C2ServerAdresse := C2StrPrm('Applikationsserver', 'Adresse', '');
    Terminal_HK_Spoerg_SS_tilskud := SameText(C2StrPrm('Receptur', 'Terminal_HK_Spoerg_SS_tilskud', 'NEJ'), 'JA');
    AfstemplingForHverReceptkvittering := SameText(C2StrPrm('Receptur', 'AfstemplingForHverReceptkvittering', 'NEJ'), 'JA');
    if AfstemplingForHverReceptkvittering then
      AfstemplingForHverReceptkvittering :=
        SameText(C2StrPrm(MainDm.C2UserName, 'AfstemplingForHverReceptkvittering', 'JA'), 'JA')
    else
      AfstemplingForHverReceptkvittering :=
        SameText(C2StrPrm(MainDm.C2UserName, 'AfstemplingForHverReceptkvittering', 'NEJ'), 'JA');

    SpoergOmGemKontonr := SameText(C2StrPrm('Receptur', 'SpørgOmGemKontonr', 'NEJ'), 'JA');
    if SpoergOmGemKontonr then
      SpoergOmGemKontonr := SameText(C2StrPrm(MainDm.C2UserName, 'SpørgOmGemKontonr', 'JA'), 'JA')
    else
      SpoergOmGemKontonr := SameText(C2StrPrm(MainDm.C2UserName, 'SpørgOmGemKontonr', 'NEJ'), 'JA');
    SpoergOmGemYdernr := SameText(C2StrPrm('Receptur', 'SpørgOmGemYdernr', 'NEJ'), 'JA');
    if SpoergOmGemYdernr then
      SpoergOmGemYdernr := SameText(C2StrPrm(MainDm.C2UserName, 'SpørgOmGemYdernr', 'JA'), 'JA')
    else
      SpoergOmGemYdernr := SameText(C2StrPrm(MainDm.C2UserName, 'SpørgOmGemYdernr', 'NEJ'), 'JA');
    TakserPaaEordrenr := SameText(C2StrPrm('Receptur', 'TakserPåEordrenr', 'NEJ'), 'JA');
    if TakserPaaEordrenr then
      TakserPaaEordrenr := SameText(C2StrPrm(MainDm.C2UserName, 'TakserPåEordrenr', 'JA'), 'JA')
    else
      TakserPaaEordrenr := SameText(C2StrPrm(MainDm.C2UserName, 'TakserPåEordrenr', 'NEJ'), 'JA');
    SpoergAutorisationsnrKorrekt := SameText(C2StrPrm('Receptur', 'SpørgAutorisationsnrKorrekt', 'JA'), 'JA');
    if SpoergAutorisationsnrKorrekt then
      SpoergAutorisationsnrKorrekt := SameText(C2StrPrm(MainDm.C2UserName, 'SpørgAutorisationsnrKorrekt', 'JA'), 'JA')
    else
      SpoergAutorisationsnrKorrekt := SameText(C2StrPrm(MainDm.C2UserName, 'SpørgAutorisationsnrKorrekt', 'NEJ'), 'JA');
    SpoergEhandelKvittering := SameText(C2StrPrm('Receptur', 'SpørgEhandelKvittering', 'JA'), 'JA');
    SpoergYdernrNBS := SameText(C2StrPrm('Receptur', 'SpørgYdernrNBS', 'NEJ'), 'JA');
    DosisAutoEnterF6 := SameText(C2StrPrm('Receptur', 'DosisAutoEnterF6', 'NEJ'), 'JA');
    NulPakkeTilBud := SameText(C2StrPrm('Receptur', 'NulPakkeTilBud', 'NEJ'), 'JA');
    DosisAutoEkspSpoergUdbringningsGebyr := SameText(C2StrPrm('Receptur', 'DosisAutoEkspSpørgUdbringningsGebyr', 'NEJ'), 'JA');
    SMSAktiv := SameText(C2StrPrm('SMS', 'Aktiv', 'NEJ'), 'JA');
    SMSServer := C2StrPrm('SMS', 'Server', '');
    acKontrolSMS.Enabled := SMSAktiv;

    DosisAutoStopIkkeVedBemaerkning := SameText(C2StrPrm('Receptur', 'DosisAutoStopIkkeVedBemærkning', 'NEJ'), 'JA');
    Dosis_Auto_Udbringningsgebyr := SameText(C2StrPrm('Receptur', 'Dosis_Auto_Udbringningsgebyr', 'JA'), 'JA');
    PrinterServerIP := C2StrPrm('Receptur', 'PrinterServerIP', '');
    PrinterServerIP := C2StrPrm(MainDm.C2UserName, 'PrinterServerIP', PrinterServerIP);
    C2QEnabled := SameText(C2StrPrm('C2Q', 'Enabled', 'NEJ'), 'JA');
    if C2QEnabled then
      C2QEnabled := SameText(C2StrPrm(MainDm.C2UserName, 'C2QEnabled', 'JA'), 'JA');
    C2QButtonPressed := False;
    if C2IntPrm(MainDm.C2UserName, 'Kasse', 0) = 0 then
      C2QEnabled := False;
    if SameText(C2StrPrm('Receptur', 'VisC2Q', 'JA'), 'NEJ') then
      C2QEnabled := False;

    if not C2QEnabled then
    begin
      TC2QFrame1.Visible := False;
      TC2QFrame1.bitRec.Enabled := False;
      TC2QFrame1.bitHkb.Enabled := False;
      TC2QFrame1.bitFort.Enabled := False;
      TC2QFrame1.bitLukke.Enabled := False;
      TC2QFrame1.bitNaeste.Enabled := False;
    end
    else
    begin
      LC2QAlias := C2StrPrm(MainDm.C2UserName,'C2QAlias','C2Q');
      TC2QFrame1.bitNaeste.Enabled := SameText(C2StrPrm(LC2QAlias,'F5Enabled', 'JA'), 'JA');
      if TC2QFrame1.bitNaeste.Enabled then
        TC2QFrame1.bitNaeste.Enabled := SameText(C2StrPrm(MainDm.C2UserName, 'C2QF5Enabled', 'JA'), 'JA')
      else
        TC2QFrame1.bitNaeste.Enabled := SameText(C2StrPrm(MainDm.C2UserName, 'C2QF5Enabled', 'NEJ'), 'JA');

    end;
    VareInfo := SameText(C2StrPrm('Receptur', 'VareInfo', 'NEJ'), 'JA');
    if VareInfo then
      PatientkartotekVareInfo := SameText(C2StrPrm(MainDm.C2UserName, 'PatientkartotekVareInfo', 'JA'), 'JA')
    else
      PatientkartotekVareInfo := SameText(C2StrPrm(MainDm.C2UserName, 'PatientkartotekVareInfo', 'NEJ'), 'JA');
    UdlBegrKunTilSygehus := SameText(C2StrPrm('Receptur', 'UdlBegrKunTilSygehus', 'NEJ'), 'JA');
    Kronikerekstrabetaling := SameText(C2StrPrm('Receptur', 'Kronikerekstrabetaling', 'NEJ'), 'JA');
    BlankPreviousCustomer := False;
    DosisBatchMode := False;
    KonvRSEkspBusy := False;
    SaveTabsheet := 0;
    cxFormatController.UseDelphiDateTimeFormats := True;
    FCF1KundeNr := '';
    gbDosis.Visible := False;
    lblMomsType.Visible := False;
    C2LogSave;
  end;
end;

procedure TStamForm.FormDestroy(Sender: TObject);
begin
  Inherited;
  try
    DosEtiket.Free;
    DosEtiket := NIL;
    CF5Ordlist.Free;
    CF5Ordlist := Nil;
    CF6Selected.Free;
    CF6Selected := nIL;
  except

  end;
end;

procedure TStamForm.FormShow(Sender: TObject);
begin
  Inherited;
  StamPages.ActivePage := KartotekPage;
  acRetYdernr.Enabled := False;
end;

procedure TStamForm.sbClick(Sender: TObject);
begin
  case (Sender as TSpeedButton).Tag of
    1:
      PaLst;
    2:
      InLst;
    3:
      PnLst;
    4:
      DeLst;
    5:
      LeLst;
    6:
      YdLst;
    7:
      ReLst;
    8:
      VmLst;
    9:
      KmLst;
  end;
end;

procedure TStamForm.EKundeNrKeyPress(Sender: TObject; var Key: Char);
var
  Kunr: string;
  LbNr: Integer;
  LAge: Integer;
begin
  if Key <> #13 then
    exit;

  MainDm.EHOrdre := False;
  MainDm.EHDibs := False;
  if MainDm.ffPatKar.State <> dsBrowse then
  begin
    if MainDm.ffPatKar.State = dsInsert then
    begin
      MainDm.ffPatKarKundeNr.AsString := trim(EKundeNr.Text);
      SelectNext(ActiveControl, True, True);
    end;
    exit;
  end;
  Key := #0;
  Kunr := trim(EKundeNr.Text);
  if (Length(Kunr) > 10) and (Length(Kunr) <> 13) then
  begin
    ChkBoxOK('cprnummer er for langt. tast igen.');
    exit;
  end;
  if Length(Kunr) = 13 then
  begin
    // if scanned prescription is not eordre then warn the user
    if not Kunr.StartsWith('88866') then
    begin
      if ShowMessageBoxWithLogging(SEHordreTakserWarning,'Warning', MB_YESNO + MB_DEFBUTTON2) <> IDYES then
        exit;
    end;
    // Udfør reiterering
    try
      LbNr := StrToInt(copy(Kunr, 6, 7));
      if copy(Kunr, 1, 4) = '9600' then
      begin
        // Dosiskort recept
        TakserDosisKortAuto := True;
        DosisBatchMode := False;
        KonvDosKort(LbNr, StamPages.ActivePage);
      end
      else if copy(Kunr, 1, 5) = '99966' then
      begin
        // recept server ekspedition
        c2logadd('Scanned a Receptkvittering ' + Kunr);
        if not KonvRSEkspBusy then
        begin
          KonvRSEksp(LbNr, StamPages.ActivePage, True);
          if RCPTakserCompleted then
            CheckMoreOpenRCP(False)
          else
          begin
            RefreshCF1WithBlankKundenr;
//              ffPatKar.FindKey([KundeKeyBlk]);
//              EKundeNr.SelectAll;
//              EKundeNr.SetFocus;
          end;
        end;
      end
      else if copy(Kunr, 1, 5) = '88866' then
      begin
        TakserEh(LbNr);

      end
      else
      begin
        // Reitereret recept
        ReitererRcp(LbNr);
      end;
    except
      on e: Exception do
      begin
        ChkBoxOK('Fejl i kundenr !');
        c2logadd('Fejl i kundenr ' + e.Message);
      end;
    end;
    exit;
  end;
  // get here then look for patient
  MainDm.PatientDosisCards.Clear;
  gbDosis.Visible := False;
  MainDm.ffPatKar.IndexName := 'NrOrden';
  try
    if MainDm.ffPatKar.FindKey([Kunr]) then
    begin
      if Kunr.trim.Length = 10 then
      begin
        CF1KundeNr := Kunr;
        RefreshDoseDispensingCardsList(Kunr, TFMKPersonIdentifierSource.DetectSource(Kunr));
        // GetCTR(Kunr);
        EKundeNr.SetFocus;
      end
      else
        gbDosis.Visible := False;
      // TfrmGebyr.VaelgGebyr(1,LGebyr); //for easy testing
      // AfterScroll(ffPatKar);

      LAge := CalculateAgeInYears(MainDm.ffPatKarKundeNr.AsString,
        MainDm.ffPatKarFoedDato.AsString);
      if LAge >= 65 then
      begin
        ChkBoxOK('Kunden er over 65 år og kan tilbydes gratis Influenzavaccination');
      end;

      if Spoerg_AutorisationsNr then
        EYderCprNr.SetFocus
      else
        EYderNr.SetFocus;
      SidKundeNr := Kunr;
      c2logadd('4: sidkundenr ' + SidKundeNr);
      // if FileExists('G:\temp\orders\' + ffPatKarKundeNr.asstring + '.cds') then begin
      // if ChkBoxYesNo('Ordre fil på kundenr ' + ffPatKarKundeNr.asstring + ' findes' +
      // sLineBreak +'Slet denne ordre fil?' ,False) then begin
      // DeleteFile('G:\temp\orders\' + ffPatKarKundeNr.asstring + '.cds');
      // end else begin
      // try
      // cdsOrdHeader.LoadFromFile('G:\temp\orders\' + ffPatKarKundeNr.asstring + '.cds');
      // c2logadd('cdsordheader record count is ' + inttostr(cdsOrdHeader.RecordCount));
      // except
      // on E: Exception do begin
      // ChkBoxOK('Fejl i læsning ordre fil ' + e.Message);
      // DeleteFile('G:\temp\orders\' + ffPatKarKundeNr.asstring + '.cds');
      // end;
      // end;
      // end;
      //
      // end;
    end
    else
    begin
      if Length(Kunr) = 10 then
      begin
        if not MainDm.DisableCPRModulusCheck then
        begin

          if not CheckCprNr(1, Kunr) then
          begin
            ChkBoxOK('Kundenr ' + Kunr + ' er ikke korrekt');
            EKundeNr.SetFocus;
            exit;
          end;

        end;
      end;

      SidKundeNr := Kunr;
      c2logadd('41: sidkundenr ' + SidKundeNr);
      if ChkBoxYesNo('Kundenr ' + Kunr + ' findes ikke !' + sLineBreak +
        'Vil du søge efter receptkvittering?', True) then
      begin
        // 08-06-2021/MA: This might not be 100% correct, but it is put here to prevent this method to be called again from CF5 when the customer does not exist
        CF1KundeNr := Kunr;

        // BlankPreviousCustomer := True;
        MainDm.fqOpenEDI.Close;
        MainDm.fqOpenEDI.SQL.Text := MainDm.sl_SQL_OpenEdi.Text;
        MainDm.fqOpenEDI.ParamByName('CPRNr').AsString := trim(copy(Kunr, 1, 10));
        MainDm.fqOpenEDI.Open;

        if MainDm.fqOpenEDI.RecordCount > 0 then
        begin
          edtCPRNr1.Text := Kunr;
          { TODO : fmklocal }
//            FrmFMKLocal.edtLokaleCprNr.Text := Kunr;
          StamPages.ActivePage := RSLocalPage;
          exit;
        end
        else
        begin
          edtCprNr.Text := Kunr;
          StamPages.ActivePage := RSRemotePage;
          exit;
        end;

      end;
      MainDm.ffPatKar.FindKey([KundeKeyBlk]);
      EKundeNr.Text := KundeKeyBlk;
      EKundeNr.SelectAll;
      gbDosis.Visible := False;
      // check for open edi for the patient
      if trim(Kunr) <> '' then
      begin
        MainDm.fqOpenEDI.Close;
        MainDm.fqOpenEDI.SQL.Text := MainDm.sl_SQL_OpenEdi.Text;
        MainDm.fqOpenEDI.ParamByName('CPRNr').AsString := trim(copy(Kunr, 1, 10));
        MainDm.fqOpenEDI.Open;

        if MainDm.fqOpenEDI.RecordCount > 0 then
        begin
          MainDm.fqOpenEDI.First;
          C2StatusBar.Panels[2].Text :=
            'Bemærk, der er ikke takseret EDI recept ' +
            MainDm.fqOpenEDI.fieldbyname('dato').AsString;
        end
        else
          C2StatusBar.Panels[2].Text := '';

        MainDm.fqOpenEDI.Close;
      end;
    end;
    EKundeNr.SetFocus;
  except
    on e: Exception do
      ChkBoxOK(e.Message);
  end;
end;

procedure TStamForm.EKundeTypeEnter(Sender: TObject);
begin
  if MainDm.ffPatKar.State in [dsEdit, dsInsert] then
    EKundeType.DroppedDown := True;
end;

procedure TStamForm.EKundeTypeExit(Sender: TObject);
begin
  if not( MainDm.ffPatKar.State in [dsEdit, dsInsert] ) then
    exit;

  case MainDm.ffPatKarKundeType.Value of
    1:
      begin // Enkeltperson
        MainDm.ffPatKarLmsModtager.AsString := MainDm.ffPatKarKundeNr.AsString;
        MainDm.ffPatKarCprCheck.AsBoolean := True;
        MainDm.ffPatKarLmsModtager.AsString := MainDm.ffPatKarKundeNr.AsString;
        if not MainDm.ffPatKarFiktivtCprNr.AsBoolean then
          ENavn.SetFocus;
      end;
    2:
      MainDm.ffPatKarLmsModtager.AsString := '3200000000';
    3:
      MainDm.ffPatKarLmsModtager.AsString := '330000xxxx';
    4:
      MainDm.ffPatKarLmsModtager.AsString := '3400000000';
    11:
      MainDm.ffPatKarLmsModtager.AsString := '450xxxxxxx';
    13:
      MainDm.ffPatKarLmsModtager.AsString := '4800000000';
    14:
      MainDm.ffPatKarLmsModtager.AsString := '0000xxxxxx';
    16:
      MainDm.ffPatKarLmsModtager.AsString := '40000xxxxx';
    18:
      MainDm.ffPatKarLmsModtager.AsString := '4000005555';

  else
    MainDm.ffPatKarLmsModtager.AsString := '4600000000';
  end;
end;

procedure TStamForm.eUafLbKeyPress(Sender: TObject; var Key: Char);
var
  lbstr: string;
  LbNr: Integer;
begin
  if Key <> #13 then
    exit;

  if Length(eUafLb.Text) = 13 then
  begin
    if copy(eUafLb.Text, 1, 4) = '9900' then
    begin
      lbstr := copy(eUafLb.Text, 5, 8);
      LbNr := StrToInt(lbstr);
      eUafLb.Text := inttostr(LbNr);
      PostMessage(butFindUaf.Handle, WM_LBUTTONDOWN, 0, 0);
      PostMessage(butFindUaf.Handle, WM_LBUTTONUP, 0, 0);
    end;
  end;
  butFindUaf.SetFocus;

end;

procedure TStamForm.EYderCprNrKeyPress(Sender: TObject; var Key: Char);
begin
  if Key <> #13 then
    exit;

  if EYderCprNr.Text <> '' then
  begin
    if MainDm.ffPatKar.State <> dsBrowse then
    begin
      MainDm.ffYdLst.IndexName := 'CprNrOrden';

      if MainDm.ffYdLst.FindKey([EYderCprNr.Text]) then
        MainDm.ffPatKarYderNr.AsString := MainDm.ffYdLstYderNr.AsString;

    end;
  end;
  EYderNr.SetFocus;
end;

procedure TStamForm.EFiktivExit(Sender: TObject);
begin
  with MainDm do
  begin
    if not(ffPatKar.State in [dsEdit, dsInsert]) then
      exit;
    if ffPatKarFiktivtCprNr.AsBoolean then
    begin
      ffPatKarCprCheck.AsBoolean := True;
      ffPatKarLmsModtager.AsString := ffPatKarKundeNr.AsString;
      ECtrLand.Color := clWindow;
      ECtrLand.ReadOnly := False;
      ECtrLand.TabStop := True;
      EDato.Color := clWindow;
      EDato.ReadOnly := False;
      EDato.TabStop := True;
    end
    else
    begin
      ffPatKarCprCheck.AsBoolean := False;
      ECtrLand.Color := clSilver;
      ECtrLand.ReadOnly := True;
      ECtrLand.TabStop := False;
      EDato.Color := clSilver;
      EDato.ReadOnly := True;
      EDato.TabStop := False;
    end;
  end;
end;

procedure TStamForm.ButMenuClick(Sender: TObject);
var
  P: TPoint;
begin
  P.X := ButMenu.Left;
  P.y := ButMenu.Top;
  P := ClientToScreen(P);
  ButMenu.PopupMenu.Popup(P.X, P.y + ButMenu.Height);
end;

procedure TStamForm.RPEHPrintPrint(Sender: TObject);
var
  i, j: Integer;
  Bar: TRPBarsBase;

  procedure Str2Pos(IndS: TStr100; var UdS: TStr100; P: Word);
  begin
    if UdS = '' then
      UdS := StringOfChar(' ',62);
    Delete(UdS, P, Length(IndS));
    Insert(IndS, UdS, P);
  end;

begin
  with (Sender as TBaseReport) do
  begin
    ResetSection;
    Home;
    LinesPerInch := 8;
    MarginLeft := 0.4;
    MarginRight := 0.0;
    MarginTop := 0.4;
    MarginBottom := 0.0;
    for j := 1 to numpages do
    begin
      // Start side
      Bar := TRPBarsEAN.Create(Sender as TBaseReport);
      try
        with Bar do
        begin
          BarHeight := 0.4;
          BarWidth := 0.014;
          Text := format('88866%7.7d', [RPEHPrint.Tag]);
          TextJustify := pjCenter;
          UseChecksum := True;
          PrintReadable := False;
          PrintChecksum := True;
          PrintTop := True;
          BarCodeRotation := Rot0;
          BarCodeJustify := pjCenter;
          PrintXY(4.6, 7.4);
        end;
      finally
        Bar.Free;
      end;
      SetFont('Courier New', 9.0);
      Home;
      NewLine;
      Str2Pos('Side ' + inttostr(j) + ' af ' + inttostr(numpages),
        rcp[1][59], 1);
      for i := 1 to 59 do
      begin
        if i = 6 then
        begin
          SetPen(clBlack, psSolid, -2, pmCopy);
          SetTab(0.4, pjLeft, 5, 1, BOXLINEBOTTOM, 0);
          PrintTab('');
          ClearTabs;
        end;
        if i = 15 then
        begin
          SetPen(clBlack, psSolid, -2, pmCopy);
          SetTab(0.4, pjLeft, 5, 1, BOXLINEBOTTOM, 0);
          PrintTab('');
          ClearTabs;
        end;
        if i = 21 then
        begin
          SetPen(clBlack, psSolid, -2, pmCopy);
          SetTab(0.4, pjLeft, 5, 1, BOXLINEBOTTOM, 0);
          PrintTab('');
          ClearTabs;
        end;
        if (i < 23) or (i > 49) then
          Print(rcp[1][i])
        else
          Print(rcp[j][i]);
        NewLine;
      end;
      if j <> numpages then
        NewPage;
    end;
  end;

end;

procedure TStamForm.RefreshCF1WithBlankKundenr;
begin
  MainDm.ffPatKar.FindKey([KundeKeyBlk]);
  EKundeNr.SelectAll;
  // Only try to set focus if the active page is CF1
  if StamPages.ActivePage = KartotekPage then
    EKundeNr.SetFocus;
  gbDosis.Visible := False;
  MainDm.PatientDosisCards.Clear;

end;

procedure TStamForm.RefreshDoseDispensingCardsList(APersonId: string; APersonIdSource: TFMKPersonIdentifierSource);
var
  I: Integer;
begin
  with MainDm do
  begin
    try
      if APersonId.Trim.IsEmpty then
        PatientDosisCards.Clear
      else
        GetExplicitDoseDispensingCardFromFMK(Bruger, Afdeling, APersonId, APersonIdSource, PatientDosisCards);

      with cxGridDDCardsTableView1.DataController do
      begin
        BeginUpdate;
        try
          while RecordCount > 0 do
            DeleteRecord(0);
        finally
          EndUpdate;
        end;
        RecordCount := PatientDosisCards.Count;
        for I := 0 to PatientDosisCards.Count - 1 do
        begin
          if I = 0 then
            DosiscardLokation := PatientDosisCards[I].OrderedAtPharmacy.Identifier;
          Values[I, 0] := PatientDosisCards[I].Description;
          Values[I, 3] := PatientDosisCards[I].DoseDispensingOnHold;
          Values[I, 1] := PatientDosisCards[I].OrderedAtPharmacy.Name;
          Values[I, 2] := PatientDosisCards[I].PackingGroupName;
        end;
      end;
    except
      on E: Exception do
        C2LogAdd('Exception in TStamForm.RefreshDoseDispensingCardsList: ' + E.Message);
    end;

    gbDosis.Visible := PatientDosisCards.Count > 0;
  end;
end;


procedure TStamForm.ReitererRcp(LbNr: LongWord);
var
  newsheet: TcxTabSheet;
  mbAnswer: Integer;
  AskInfertQuestion: Boolean;

begin
  with MainDm do
  begin
    if ffPatKar.State <> dsBrowse then
    begin
      ChkBoxOK('Husk at gemme ret/opret !');
      StamPages.ActivePage := KartotekPage;
      exit;
    end;
    if ffPatTil.State <> dsBrowse then
    begin
      ChkBoxOK('Husk at gemme ret/opret !');
      StamPages.ActivePage := TilskudsPage;
      exit;
    end;
    if TakserActive then
      exit;
    TakserActive := True;
    newsheet := KartotekPage;
    try

      ffEksOvr.CancelRange;
      ffEksOvr.EnableControls;
      ffEksOvr.IndexName := 'NrOrden';

      dsEksOvr.dataset := Nil;
      dsEksOvr.dataset := ffEksOvr;

      ffEksOvr.Refresh;
      if not ffEksOvr.FindKey([LbNr]) then
        exit;
      EKundeNr.Text := '';
      if not ffPatKar.FindKey([ffEksOvrKundenr.AsString]) then
      begin
        ChkBoxOK('Patient til ekspedition findes ikke !');
        exit;
      end;
      EKundeNr.Text := ffPatKarKundeNr.AsString;
      if not ValidatePatKar then
        exit;
      if ffPatKarDebitorNr.AsString <> '' then
      begin
        if ffDebKar.FindKey([ffPatKarDebitorNr.AsString]) then
        begin
          if ffDebKarKontoLukket.AsBoolean then
          begin
            if trim(ffDebKarLukketGrund.AsString) <> '' then
              ChkBoxOK('Debitorkonto er lukket : ' +
                ffDebKarLukketGrund.AsString)
            else
              ChkBoxOK('Debitorkonto er lukket.');
            exit;
          end;

        end;
      end;

      // new logic if old ekspeditioner was edb then check cF5 screen
      if ffEksOvrEkspForm.AsInteger = 3 then
      begin
        mbAnswer := Application.MessageBox
          (Pchar('Denne recept skal hentes fra FMK.' + sLineBreak +
          'Ønsker du at søge på FMK?'), 'Vælg Ja/Nej', MB_YESNO);
        if mbAnswer = IDYES then
        begin
          newsheet := RSRemotePage;
          exit;
        end;
        IF mbAnswer = IDNO then
          exit;
      end;
      UseInfertTakser := False;
      AskInfertQuestion := True;
      ffLinOvr.First;
      while not ffLinOvr.Eof do
      begin
        if (ffLinOvrUdlevMax.AsInteger <> 0) and
          (ffLinOvrUdlevNr.AsInteger < ffLinOvrUdlevMax.AsInteger) then
        begin
          if MatchText(ffLinOvrUdLevType.AsString ,['AP4','AP4NB','A','NBS']) then
          begin
            if not ChkBoxYesNo
              ('Genudlevering af udlevering A, AP4 eller NBS. Vil du fortsætte?', False) then
              exit;
            break;
          end;
        end;
        if ffLinOvrSSKode.AsString = 'I' then
          UseInfertTakser := True;
        if ffLinOvrSSKode.AsString = 'J' then
        begin
          if AskInfertQuestion then
          begin
            UseInfertTakser :=
              ChkBoxYesNo
              ('Receptkvitteringen indeholder vare, der normalt er til infertilitetsbehandling.'
              + sLineBreak + 'Skal der foretages infetilitetsekspedition?', True);
          end;
          AskInfertQuestion := False;

        end;
        ffLinOvr.Next;
      end;
      ffLinOvr.First;
      // Stop hvis bemærkning
      if EBem.Lines.Count > 0 then
        ChkBoxOK('Der er bemærkninger på patienten!' + sLineBreak +
          EBem.Lines.Text);
      if not GetCTR(EKundeNr.Text) then
        Exit;
      SidKundeNr := ffPatKarKundeNr.AsString;
      c2logadd('6: sidkundenr ' + SidKundeNr);
      EkspHuman(ffEksOvrLbNr.Value, NIL);
    finally
      ffEksOvr.DisableControls;
      ffEksOvr.IndexName := 'KundeNrOrden';
      TakserActive := False;
      LogoffTimer := 0;
      StamPages.ActivePage := newsheet;
      if newsheet = KartotekPage then
      begin
        RefreshCF1WithBlankKundenr;
//        ffPatKar.FindKey([KundeKeyBlk]);
//        EKundeNr.SelectAll;
//        EKundeNr.SetFocus;
      end
      else
      begin
        edtCprNr.SetFocus;
        PostMessage(StamForm.Handle, WM_CHAR, VK_RETURN, 0);
      end;
    end;
  end;
end;

procedure TStamForm.ResubmitFMKCertificateErrors(ABrugerNr: integer);

  procedure AddToRS_Queue(ALbnr : integer);
  begin
    with MainDm do
    begin
      try
        try
          with nxdb.OpenQuery('insert into ' + tnRS_EkspQueue + '(' +
            fnRS_EkspQueueLbnr + fnRS_EkspQueueDato_K + fnRS_EkspQueueReportedBy_K +
            ') values(' + ALbnr.ToString + ',' +
            'current_timestamp,' + ABrugernr.ToString + ')', []) do
          begin
            try
              C2LogAdd(sql.Text);
              if RowsAffected = 0 then
                ChkBoxOK('Not added');

            except
              on E: Exception do
                ChkBoxOK('fejl i resubmit ' + E.Message);
            end;
            Free;
          end;

          with nxdb.OpenQuery('delete from ' + tnRS_EkspQueueFejl + ' where ' +
            fnRS_EkspQueueFejlLbNr_P, [ALbnr]) do
          begin
            try
              c2logadd(SQL.Text);
              if RowsAffected = 0 then
                ChkBoxOK('Not deleted from rs_ekspqueuefejl');

            except
              on E: Exception do
                ChkBoxOK('fejl i resubmit ' + E.Message);
            end;
            Free;
          end;

        except
          on e : Exception do
          begin
            ChkBoxOK(e.Message);
            C2LogAdd(e.Message);
          end;
        end;
      finally
        if nxRSQueue.State <> dsbrowse then
          nxRSQueue.Cancel;
      end;


    end;

  end;

begin
  with MainDm do
  begin
    try
   with nxdb.OpenQuery
      ('SELECT distinct fejl.lbnr,e.BrugerTakser,e.BrugerAfslut FROM RS_EkspQueueFejl as fejl'
        + ' inner join ekspeditioner as e on e.lbnr=fejl.lbnr' +
        ' where fejl.ErrorDetails = ''Certifikat udløbet'' and ' +
        '(e.BrugerTakser=:Bruger or e.BrugerAfslut=:Bruger)',
        [ABrugerNr]) do
      begin
        try
          c2logadd(SQL.Text);
          if Eof then
            exit;

          C2LogAdd('There are fmk prescriptions to report for the current user');

          First;
          while not Eof do
          begin
            AddToRS_Queue(fieldbyname('lbnr').AsInteger);

            Next;
          end;

        except

          on e: Exception do
            c2logadd(e.Message);
        end;
        Free;
      end;
    except
      on e: Exception do
        c2logadd(e.Message);
    end;

  end;
end;

procedure TStamForm.MenuReRcpClick(Sender: TObject);
var
  LbNr: LongWord;
begin
  if ShowMessageBoxWithLogging(SEHordreTakserWarning,'Warning', MB_YESNO + MB_DEFBUTTON2) <> IDYES then
    exit;
  if RcptLbnr('Søg reitereret recept på løbenr', LbNr) then
  begin
    // Udfør reiterering
    ReitererRcp(LbNr);
  end;
end;

procedure TStamForm.MenuGenEtiketClick(Sender: TObject);
var
  Item: Word;
  LbNr: LongWord;
begin
  // Søg et recept løbenummer, pakkenummer eller fakturanr
  if TSoegRcpForm.SoegRcpt(Item, LbNr) then
  begin
    if (Item = 0) and (LbNr > 0) then
    begin
      AfslLbNr := LbNr;
      UbiEtiketter;
      if Kronikerekstrabetaling then
        UbiKronikerLabel;
      fmubi.PrintTotalEtiket;
    end;
  end;
end;

procedure TStamForm.MenuGenAfstClick(Sender: TObject);
var
  Item: Word;
  LbNr: LongWord;
begin
  PrintAllAFSLabel := True;
  // Søg et recept løbenummer, pakkenummer eller fakturanr
  if TSoegRcpForm.SoegRcpt(Item, LbNr) then
  begin
    if (Item = 0) and (LbNr > 0) then
    begin
      AfslLbNr := LbNr;
      UbiAfstempling(False, False);
      if Kronikerekstrabetaling then
        UbiKronikerLabel;
      fmubi.PrintTotalEtiket;
    end;
  end;
end;

procedure TStamForm.MenuDosEtiketClick(Sender: TObject);
begin
  DosEtiket.Clear;
  DosEtiket.Insert(0, '');
  DosEtiket.Insert(0, '');
  DosEtiket.Insert(0, '');
  DosEtiket.Insert(0, '');
  DosEtiket.Insert(0, '');
  DosEtiket.Insert(0, '');
  DosEtiket.Insert(0, '');
  DosEtiket.Insert(0, '');
  DosEtiket.Insert(0, '');
  DosEtiket.Insert(0, '');
  DosEtiket.Insert(0, FormatDateTime('dd-mm-yy', Date));
  DosEtiket.Insert(0, MainDm.ffFirmaSupNavn.AsString);
  TfmEtk.FriEtiket(DosEtiket, False);
end;

procedure TStamForm.MenuBogfFraTilClick(Sender: TObject);
var
  FraNr, TilNr: String;
begin
  FraNr := '';
  TilNr := '';
  // KontoNrMinMax      (FraNr, TilNr, NIL);
  TKontoFraTilForm.OpdaterFraTilKonto(FraNr, TilNr);
  MainDm.ffEksOvr.Refresh;
end;

procedure TStamForm.acTestMessExecute(Sender: TObject);
var
  cr : char;
  LCprnr : string;
  lBirthDate : string;
  Lage : integer;
begin
//for testing
  LCprnr := InputBox('cpr','Enter CPRnr.','');
  lBirthDate := InputBox('birthdate','Enter birthdate.','');
  Lage := CalculateAgeInYears(LCprnr,lBirthDate);
  if Lage >= 65 then
  begin
    ChkBoxOK('Kunden er over 65 år og kan tilbydes gratis Influenzavaccination');
  end;
  exit;

  TfrmBogfoerSettings.ShowFakturaSettings(True,False);
  exit;
  Sidkundenr := InputBox('kø cpr','Enter kø kundenr.','Blank');
  with MainDm do
  begin
    if SidKundeNr <> 'Blank' then
    begin
        EKundeNr.Text := SidKundeNr;
        EKundeNr.SelectAll;
      // now switch back to cf1
      if StamPages.ActivePage <> KartotekPage then
        StamPages.ActivePage := KartotekPage
      else
      begin

          cr := #13;
          StamForm.EKundeNrKeyPress(StamForm.EKundeNr, cr);

      end;
    end
    else
    begin
      if StamPages.ActivePage = KartotekPage then
      begin
        EKundeNr.Text := KundeKeyBlk;
        EKundeNr.SelectAll;
        ffPatKar.FindKey([KundeKeyBlk]);
        gbDosis.Visible := False;
      end;
    end;

  end;
end;

procedure TStamForm.AcUdFaktFraTilExecute(Sender: TObject);
begin
  with dmFormularer do
  begin
    if (FaktPrivPrn <> '') or (FaktInstPrn <> '') or (FaktLevPrn <> '') or
      (FaktPakkePrn <> '') then
      TfmFakturaLaser.UdskrivFaktLaser(0, 0, True);
  end;
end;

procedure TStamForm.butUdFaktClick(Sender: TObject);
begin
  with MainDm, dmFormularer do
  begin
    c2logadd('prnt faktura button pressed !!');
    if (FaktPrivPrn <> '') or (FaktInstPrn <> '') or (FaktLevPrn <> '') or
      (FaktPakkePrn <> '') then
      TfmFakturaLaser.UdskrivFaktLaser(ffEksOvrFakturaNr.Value,
        ffEksOvrFakturaNr.Value, True);
    FakturaPageEnter(Self);
  end;
end;

procedure TStamForm.butRetPakkeClick(Sender: TObject);
var
  TilNr: LongWord;
  oldindex: string;
begin
  with MainDm do
  begin
    try
      TilNr := StrToInt(edtNr.Text);
      if not ChkBoxYesNo('Pakkenr rettes fra ' + inttostr(ffEksOvrPakkeNr.Value)
        + ' til ' + inttostr(TilNr), True) then
        exit;

      // fejl 46
      oldindex := ffEksKar.IndexName;
      ffEksKar.IndexName := 'PakkeNrOrden';
      if not ffEksKar.FindKey([edtNr.Text]) then
      begin
        ChkBoxOK('Pakkenummer findes ikke. Vælg et eksisterende pakkenummer. ');
        ffEksKar.IndexName := oldindex;
        exit;
      end;
      if ffEksKarKontoNr.AsString <> ffEksOvrKontoNr.AsString then
      begin
        ChkBoxOK('Pakkenummeret er anvendt I forbindelse med en anden debitor. Kan derfor ikke tildeles.');
        ffEksKar.IndexName := oldindex;
        exit;
      end;
      ffEksKar.IndexName := oldindex;
      ffEksOvr.Edit;
      ffEksOvrPakkeNr.Value := TilNr;
      ffEksOvr.Post;
      ffEksOvr.Refresh;
    except
      ChkBoxOK('Pakkenr kunne ikke rettes!');
    end;
  end;
end;

procedure TStamForm.butUdPakkeClick(Sender: TObject);
begin
  with MainDm, dmFormularer do
  begin
    if ffEksOvrPakkeNr.Value = 0 then
    begin
      ChkBoxOK('Ekspeditionen har intet pakkenummer');
      exit;
    end;
    if PakkeSedPrn <> '' then
      TfmPakkeLaser.UdskrivPakkeSeddelLaser(ffEksOvrPakkeNr.Value);
    PakkePageEnter(Self);
  end;
end;

procedure TStamForm.MenuTakseringClick(Sender: TObject);
var
  Kunr: string;
begin
  with MainDm do
  begin
    AcTaksering.Enabled := False;
    c2logadd('Menu Taksering Click start');
    try
      if StamPages.ActivePage <> tsEHandel then
      begin
        if ShowMessageBoxWithLogging(SEHordreTakserWarning,'Warning', MB_YESNO + MB_DEFBUTTON2) <> IDYES then
        exit;

      end;

      if StamPages.ActivePage = RSRemotePage then
      begin
        btnTakserClick(Sender);
        exit;
      end;

      if StamPages.ActivePage = RSLocalPage then
      begin
        if bitbtnTakser.Enabled then
          bitbtnTakserClick(Sender);
        exit;
      end;

        { TODO : fmklocal }
  //      if StamPages.ActivePage = cxTabNyFMKLocal then
  //      begin
  //
  //        FrmFMKLocal.acTakser.Execute;
  //        exit;
  //      end;

      if not maindm.TakserUdenCTR then
      begin

        if StamPages.ActivePage = tsEHandel then
        begin
          btnEHTakserClick(Sender);
          exit;
        end;

        if not TfrmDosiskort.ShowDoskort(ffPatKarKundeNr.AsString,
            TFMKPersonIdentifierSource.DetectSource(ffPatKarKundeNr.AsString)) then
          exit;

      end;

      if ffPatKar.State <> dsBrowse then
      begin
        ChkBoxOK('Husk at gemme ret/opret !');
        StamPages.ActivePage := KartotekPage;
        exit;
      end;
      if ffPatTil.State <> dsBrowse then
      begin
        ChkBoxOK('Husk at gemme ret/opret !');
        StamPages.ActivePage := TilskudsPage;
        exit;
      end;
      if TakserActive then
      begin
        ChkBoxOK('Taksering er igangsat allerede !');
        exit;
      end;
      // new code to change to new patient number in case it has changed
      // without enter key being pressed Fejl - 066
      Kunr := trim(EKundeNr.Text);
      if Kunr <> ffPatKarKundeNr.AsString then
      begin
        ffPatKar.IndexName := 'NrOrden';
        if ffPatKar.FindKey([Kunr]) then
          AfterScroll(ffPatKar)
        else
        begin
          ChkBoxOK('Kundenr ' + Kunr + ' findes ikke !');
          EKundeNr.SetFocus;
          exit;
        end;
      end;
      TakserActive := True;
      try
        // Dette er et testnr for Terminal givet af LMS/CTR 4079000340
        if not ValidatePatKar then
        begin
          ChkBoxOK('Der er fejl i kundens stamdata.' + sLineBreak +
            'Kontroller og ret.');
          exit;
        end;

        // new code that forces kundenr with debitor with momstype 0 into leverancer

        if ffPatKarDebitorNr.AsString <> '' then
        begin
          if ffDebKar.FindKey([ffPatKarDebitorNr.AsString]) then
          begin
            if ffDebKarKontoLukket.AsBoolean then
            begin
              if trim(ffDebKarLukketGrund.AsString) <> '' then
                ChkBoxOK('Debitorkonto er lukket : ' +
                  ffDebKarLukketGrund.AsString)
              else
                ChkBoxOK('Debitorkonto er lukket.');
              exit;
            end;

            if ffDebKarMomsType.AsInteger = 0 then
            begin
              if not GetCTR(ffPatKarKundeNr.AsString) then
                Exit;

              SidKundeNr := ffPatKarKundeNr.AsString;
              c2logadd('7: sidkundenr ' + SidKundeNr);
              c2logadd('leverance uden moms');
              EkspLeverancer(0);
              exit;
            end;
          end
        end;

        // EKundeNr.Text := ffPatKarKundeNr.AsString;
        if ffPatKarKundeType.Value in [1, 2, 13, 14] then
        begin
          if ffPatKarDebitorNr.AsString <> '' then
          begin
            if ffDebKar.FindKey([ffPatKarDebitorNr.AsString]) then
            begin
              if ffDebKarKontoLukket.AsBoolean then
              begin
                if trim(ffDebKarLukketGrund.AsString) <> '' then
                  ChkBoxOK('Debitorkonto er lukket : ' +
                    ffDebKarLukketGrund.AsString)
                else
                  ChkBoxOK('Debitorkonto er lukket.');

              end
              else
              begin

                if not GetCTR(ffPatKarKundeNr.AsString) then
                  Exit;

                SidKundeNr := ffPatKarKundeNr.AsString;
                c2logadd('7: sidkundenr ' + SidKundeNr);
                EkspHuman(0, NIL);
              end;
            end
            else
              ChkBoxOK('Debitor konto findes ikke !');
          end
          else
          begin
            if not GetCTR(ffPatKarKundeNr.AsString) then
              Exit;
            SidKundeNr := ffPatKarKundeNr.AsString;
            c2logadd('8: sidkundenr ' + SidKundeNr);
            EkspHuman(0, NIL);
          end;
          exit;
        end;

        if not ffLagNvn.FindKey([ffArbOplLager.AsString]) then
        begin
          ChkBoxOK('Lager findes ikke i databasen');
          exit;
        end;

        if ffPatKarDebitorNr.AsString <> '' then
        begin
          if not ffDebKar.FindKey([ffPatKarDebitorNr.AsString]) then
          begin
            ChkBoxOK('Debitor konto findes ikke !');
            exit;
          end;
          if ffDebKarKontoLukket.AsBoolean then
          begin
            if trim(ffDebKarLukketGrund.AsString) <> '' then
              ChkBoxOK('Debitorkonto er lukket ' + ffDebKarLukketGrund.AsString)
            else
              ChkBoxOK('Debitorkonto er lukket.');
            exit;
          end;

          if frmYesNo.NewYesNoBox('Leverance uden etiketter ?') then
          begin
            SidKundeNr := ffPatKarKundeNr.AsString;
            c2logadd('9: sidkundenr ' + SidKundeNr);
            EkspLeverancer(0);
          end
          else
          begin
            if not GetCTR(ffPatKarKundeNr.AsString) then
              Exit;
            SidKundeNr := ffPatKarKundeNr.AsString;
            c2logadd('10: sidkundenr ' + SidKundeNr);
            EkspHuman(0, NIL);
          end;
          exit;
        end;

        SidKundeNr := ffPatKarKundeNr.AsString;
        if frmYesNo.NewYesNoBox('Leverance uden etiketter ?') then
        begin
          c2logadd('11: sidkundenr ' + SidKundeNr);
          EkspLeverancer(0);
        end
        else
        begin
          if not GetCTR(ffPatKarKundeNr.AsString) then
            Exit;
          c2logadd('12: sidkundenr ' + SidKundeNr);
          EkspHuman(0, NIL);
        end;
        {
          StamPages.ActivePage := KartotekPage;
          PostMessage (EKundeNr.Handle, WM_SETFOCUS, 0, 0);
          PostMessage (EKundeNr.Handle, EM_SETSEL,   0, -1);
        }
      finally
        TakserActive := False;
        LogoffTimer := 0;
        StamPages.ActivePage := KartotekPage;
        RefreshCF1WithBlankKundenr;
//        // ZZZZZZZZZZZZZ
//        ffPatKar.FindKey([KundeKeyBlk]);
//        // ZZZZZZZZZZZZZ
//        EKundeNr.SelectAll;
//        EKundeNr.SetFocus;
      end;
    finally
      AcTaksering.Enabled := True;
      c2logadd('Menu Taksering Click end');
    end;
  end;
end;

procedure TStamForm.AcSletMedkExecute(Sender: TObject);
var
  Slettet: Boolean;
  PatNr: LongWord;
  KomNr: Word;
  TilDato: TDateTime;
begin
  with MainDm do
  begin
    PatNr := 0;
    KomNr := 0;
    if not TSletMedkForm.SletMedicinkort(KomNr, TilDato) then
      exit;

    Screen.Cursor := crHourGlass;
    try
      ffTilUpd.First;
      while not ffTilUpd.Eof do
      begin
        Slettet := False;
        if Trunc(ffTilUpdTilDato.AsDateTime) <= TilDato then
        begin
          if ffTilUpdRegel.AsInteger < 100 then
          begin
            ffTilUpd.Delete;
            Slettet := True;
            Inc(PatNr);
            if PatNr mod 50 = 0 then
            begin
              C2StatusBar.Panels[2].Text := ' Behandlet ' + inttostr(PatNr) +
                ' medicinkort';
              C2StatusBar.Update;
            end;
          end;
        end;
        if not Slettet then
          ffTilUpd.Next;
        Application.ProcessMessages;
        if CloseAtOnce then
          break;
      end;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TStamForm.AcUdskrivMedkExecute(Sender: TObject);
var
  PatNr: LongWord;
  PNr: Word;
  Udskriv, MedOK, BevOK: Boolean;
  BevLst: TStringList;
begin
  with MainDm do
  begin
    PatNr := 0;
    MedOK := False;
    BevOK := False;
    if not UdskMedkBev(MedOK, BevOK) then
      exit;
    if (not MedOK) and (not BevOK) then
      exit;
    Screen.Cursor := crHourGlass;
    BevLst := TStringList.Create;
    PNr := 0;
    try
      ffTilUpd.First;
      while not ffTilUpd.Eof do
      begin
        if ffTilUpdRegel.Value in [75] then
        begin
          // Test for medicinkort
          Udskriv := MedOK;
        end
        else
        begin
          // Test for bevillinger
          Udskriv := BevOK;
        end;
        if Udskriv then
        begin
          if ffPatUpd.FindKey([ffTilUpdKundeNr.AsString]) then
          begin
            BevLst.add(OutStr(ffPatUpdKundeNr.AsString, 11) +
              OutStr(ffPatUpdNavn.AsString, 33) +
              FormWord2Str(ffPatUpdAmt.Value, 3) +
              FormWord2Str(ffPatUpdKommune.Value, 8) +
              FormWord2Str(ffTilUpdRegel.Value, 7) + ' ' +
              OutDate(ffTilUpdTilDato.AsDateTime));
            Inc(PatNr);
            if PatNr mod 50 = 0 then
            begin
              C2StatusBar.Panels[2].Text := ' Behandlet ' + inttostr(PatNr) +
                ' medicinkort/bevillinger';
              C2StatusBar.Update;
            end;
          end;
        end;
        ffTilUpd.Next;
        Application.ProcessMessages;
        if CloseAtOnce then
          break;
      end;
      BevLst.Insert(0,
        'nr         Navn                            Amt Kommune  Regel Udløbsdato');
      BevLst.Insert(0,
        'Kunde                                                                   ');
      BevLst.Insert(0, '');
      BevLst.Insert(0, ffFirmaNavn.AsString);
      BevLst.Insert(0, 'P A T I E N T   T I L S K U D S O P L Y S N I N G E R');
      BevLst.SaveToFile('C:\C2\Temp\BevListe.Txt');
      PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\BevListe.Txt');
    finally
      BevLst.Free;
      Screen.Cursor := crDefault;
    end;
  end;
end;

function StrOemAnsi(const S: String): String;
var
  Wi, Wo: String;
begin
  Wi := Trim(S);
  Wo := Wi;
  try
    if Wi = '' then
      exit;
    SetLength(Wo, Length(Wi));
    OemToCharBuff(@Wi[1], @Wo[1], Length(Wi));
    Wo := Cap1Letter(Wo);
  finally
    Result := Wo;
  end;
end;

function TStamForm.EdifactRcp(EdiPtr: Pointer; TabSheet: TcxTabSheet;
  ABlankKundenr: Boolean = False): Boolean;
var
  EdiTxt: String;
  EdiRcp: PEdiRcp;
  ipos: Integer;
  AsylnSoeger: Boolean;
  AsylnCPR: string;
  itst: Integer;
  LEordre: Boolean;
  LEHCPr: Boolean;
  LEHDibs: Boolean;
  LLmsModtagerId: string;
  LPersonIdSource: TFMKPersonIdentifierSource;
  LCtrCountryCode: Integer;

  // bo untested logic !!!!!!!
  function Amt2Region(Amt: Word): Word;
  begin
    case Amt of
      13, 14, 15, 20, 40:
        Result := 84;
      25, 30, 35:
        Result := 85;
      42, 50, 55, 60:
        Result := 83;
      65, 70, 76:
        Result := 82;
      80:
        Result := 81;
    else
      Result := Amt;
    end;
  end;

  function checkcustdetails: Boolean;
  begin
    with MainDm do
    begin
      Result := False;
      try
        c2logadd('checkcustdetails ' + Bool2Str(ReceptAddrPopup));
        if not((ReceptAddrPopup) or (ReceptAddrPopupAlle)) then
          exit;
        c2logadd('debitornr ' + ffPatKarDebitorNr.AsString);
        if not ReceptAddrPopupAlle then
          if ffPatKarDebitorNr.AsString = '' then
            exit;
        c2logadd('ffpatkarkundenr ' + ffPatKarKundeNr.AsString);
        c2logadd('Edircp.pacprnr ' + EdiRcp.PaCprNr);
        c2logadd('debitorn is true');
        c2logadd(caps(ffPatKarNavn.AsString));
        c2logadd(caps(EdiRcp.PaNavn));
        if AnsiCompareText(ffPatKarKundeNr.AsString.trim,
          EdiRcp.PaCprNr.trim) <> 0 then
        begin
          c2logadd('*** KUNDENR HAS CHANGED ***');
          // ChkBoxOK('*** Kundenr has changed after start of taksering ***');
        end;

        if caps(ffPatKarNavn.AsString) = caps(EdiRcp.PaNavn) then
          c2logadd('Name ok');
        c2logadd(caps(ffPatKarAdr1.AsString));
        c2logadd(caps(EdiRcp.Adr));
        if caps(ffPatKarAdr1.AsString) = caps(EdiRcp.Adr) then
          c2logadd('Adr ok');
        c2logadd(caps(ffPatKarAdr2.AsString));
        c2logadd(caps(EdiRcp.Adr2));
        c2logadd('adr2 not checked');
        c2logadd(caps(ffPatKarPostNr.AsString));
        c2logadd(caps(EdiRcp.PostNr));
        if caps(ffPatKarPostNr.AsString) = caps(EdiRcp.PostNr) then
          c2logadd('postnr ok');
        c2logadd(caps(ffPatKarTlfNr.AsString));
        c2logadd(caps(EdiRcp.Tlf));
        c2logadd('tlf not checked');
        c2logadd(inttostr(ffPatKarAmt.AsInteger));
        c2logadd(inttostr(Amt2Region(StrToInt(EdiRcp.Amt))));
        if ffPatKarAmt.AsInteger = Amt2Region(StrToInt(EdiRcp.Amt)) then
          c2logadd('Amt ok');
        if caps(ffPatKarNavn.AsString) = caps(EdiRcp.PaNavn) then
          if caps(ffPatKarAdr1.AsString) = caps(EdiRcp.Adr) then
            if caps(ffPatKarPostNr.AsString) = caps(EdiRcp.PostNr) then
              if ffPatKarAmt.AsInteger = Amt2Region(StrToInt(EdiRcp.Amt)) then
                exit;


        // if we get here then something has changed

        if ChkBoxYesNo
          ('Kunden er allerede oprettet med andre navne og/eller adresseoplysninger.'
          + sLineBreak + 'Skal de opdateres med lægens oplysninger?', False) then
        begin
          ffPatKar.Edit;
          ffPatKarNavn.AsString := EdiRcp.PaNavn;
          ffPatKarAdr1.AsString := EdiRcp.Adr;
          // ffPatKarAdr2          .AsString  := EdiRcp.Adr2;
          ffPatKarPostNr.AsString := EdiRcp.PostNr;
          // ffPatKarTlfNr         .AsString  := EdiRcp.Tlf;
          ffPatKarAmt.AsInteger := Amt2Region(StrToInt(EdiRcp.Amt));
          ffPatKar.Post;
          Result := True;
        end;
      except
        on e: Exception do
          ChkBoxOK(e.Message);
      end;
    end;
  end;

  function GetAsylnCpr(const ALevInfo: string): string;
  var
    sl: TStringList;
    LTmpstr: string;
    LSetAsynCPR: Boolean;
    i: Integer;
    LVal: Int64;
  begin
    Result := '';
    LSetAsynCPR := False;
    sl := TStringList.Create;
    try
      sl.Delimiter := ':';
      sl.StrictDelimiter := False; // delimiters are space and :
      sl.DelimitedText := ALevInfo;
      for LTmpstr in sl do
      begin
        // if the set flag is true then return the current bit up to 1st non digit
        if LSetAsynCPR then
        begin
          if TryStrToInt64(LTmpstr, LVal) then
          begin
            Result := LTmpstr;
            exit;
          end;

          // build up result until we get a non digit
          for i := 1 to Length(LTmpstr) do
          begin
            if (copy(LTmpstr, i, 1) >= '0') and (copy(LTmpstr, i, 1) <= '9')
            then
            begin
              Result := Result + copy(LTmpstr, i, 1);
            end
            else
              break;
          end;
          exit;
        end;

        // if personid : then we are interested so get the text after the :
        if CompareText(LTmpstr, 'PersonId') = 0 then
          LSetAsynCPR := True;
      end;

    finally
      sl.Free;
    end;

  end;
// procedure CheckRSOrdinations;
// var
// i: integer;
// ordstr : string;
// begin
// ordstr := '';
// for i  := 1 to edircp.OrdAnt  do
// begin
// if edircp.Ord[i].OrdId <> '' then
// begin
// if ordstr = '' then
// ordstr := edircp.Ord[i].OrdId
// else
// ordstr := ordstr + ';' + edircp.Ord[i].OrdId;
// end;
// end;
//
// if ordstr <> '' then
// C2WinApi.C2ExecuteCS(programfolder + 'rschkord.exe ' + edircp.PaCprNr + ' ' + ordstr,SW_HIDE,-1);
//
//
// end;

begin
  with MainDm do
  begin
    c2logadd('Top of edifactRcp');
    try
      Result := False;
      if (ffPatKar.State <> dsBrowse) or (ffPatTil.State <> dsBrowse) then
      begin
        ChkBoxOK('Husk at gemme ret/opret !');
        exit;
      end;
      if TakserActive then
        exit;
      GoAuto := True;
      TakserActive := True;

      // save the eordre values because they will be reset in cf1
      LEordre := EHOrdre;
      LEHCPr := EHCPR;
      LEHDibs := EHDibs;
      StamPages.ActivePage := KartotekPage;

      // reset the eordre values again
      EHOrdre := LEordre;
      EHCPR := LEHCPr;
      EHDibs := LEHDibs;

      try
        EdiRcp := EdiPtr;
        EKundeNr.Text := EdiRcp.PaCprNr;
        AsylnSoeger := False;
        ipos := pos('PersonID', EdiRcp.LevInfo);
        if ipos <> 0 then
        begin
          AsylnCPR := GetAsylnCpr(EdiRcp.LevInfo);
          if AsylnCPR <> '' then
          begin

            EKundeNr.Text := AsylnCPR;
            AsylnSoeger := True;
          end
          else
          begin
            ChkBoxOK('Ugyldig asylansøger-info ' + EdiRcp.LevInfo);
            exit;
          end;

        end;

        if ffPatKar.FindKey([EKundeNr.Text]) then
        begin

          // if EdiRcp.Amt = '' then begin
          EdiRcp.Amt := ffRcpOplAfrAmt.AsString;
          if ffPatKarAmt.AsString <> '' then
            EdiRcp.Amt := ffPatKarAmt.AsString;
          // end;
          if not ABlankKundenr then
          begin

            if checkcustdetails then
            begin
              save_ediNr := EdiRcp.LbNr;
              // GoAuto := False;
            end;
          end
          else
            save_ediNr := EdiRcp.LbNr;

          // check the current ydernr is valid on patient
          // if not then set it to the one received in order
          if (ffPatKarKundeType.AsInteger = 1) then
          begin
            if not CheckYderNr(ffPatKarKundeType.AsInteger,
              ffPatKarYderNr.AsString) then
            begin
              ffPatKar.Edit;
              ffPatKarYderNr.AsString := EdiRcp.YdNr;
              ffPatKar.Post;
            end;

          end;
          // if member of danmark then upddate the patient
          if EHOrdre then
          begin
            if EdiRcp.Danmark then
            begin
              if ffPatKarDKMedlem.AsInteger <> 1 then
              begin
                ffPatKar.Edit;
                ffPatKarDKMedlem.AsInteger := 1;
                ffPatKar.Post;
              end;
            end;

            if EdiRcp.Kontonr <> '' then
            begin
              { TODO : update the kontonr on the patient }

            end;
          end;
          if not ValidatePatKar then
          begin
            StamPages.ActivePage := KartotekPage;
            GoAuto := False;
            exit;
          end;

          // if not(ffPatKarKundeType.Value in [0, 1]) then
          // begin
          // ChkBoxOK('Kun reiterering af enkeltpersoner');
          // exit;
          // end;

          if ffPatKarDebitorNr.AsString <> '' then
          begin
            if not ffDebKar.FindKey([ffPatKarDebitorNr.AsString]) then
            begin
              ChkBoxOK('Debitor konto findes ikke !');
              GoAuto := False;
              exit;
            end;
            if ffDebKarKontoLukket.AsBoolean then
            begin
              if trim(ffDebKarLukketGrund.AsString) <> '' then
                ChkBoxOK('Debitorkonto er lukket : ' + ffDebKarLukketGrund.AsString)
              else
                ChkBoxOK('Debitorkonto er lukket.');
              GoAuto := False;
              exit;
            end;

            // Stop hvis bemærkning
            if EBem.Lines.Count > 0 then
              ChkBoxOK('Der er bemærkninger på patienten!' + sLineBreak + EBem.Lines.Text);
            // Kald taksering
            if not GetCTR(ffPatKarKundeNr.AsString) then
              Exit;
            SidKundeNr := ffPatKarKundeNr.AsString;
            c2logadd('13: sidkundenr ' + SidKundeNr);
            // CheckRSOrdinations;
            EkspHuman(0, EdiPtr);
            Result := True;
            exit;
          end;

          // Stop hvis bemærkning
          if EBem.Lines.Count > 0 then
            ChkBoxOK('Der er bemærkninger på patienten!' + sLineBreak + EBem.Lines.Text);
          if not GetCTR(ffPatKarKundeNr.AsString) then
            Exit;
          // Kald taksering
          SidKundeNr := ffPatKarKundeNr.AsString;
          c2logadd('14: sidkundenr ' + SidKundeNr);
          // CheckRSOrdinations;
          EkspHuman(0, EdiPtr);
          Result := True;
          Save_EordreNr := '';
          exit;
        end;

        LPersonIdSource := TFMKPersonIdentifierSource.DetectSource(EdiRcp.PaCprNr, pisUndefined);
        LLmsModtagerId := EdiRcp.PaCprNr;
        LCtrCountryCode := 0;

        // Check if the person is an asylumn seeker
        if (LPersonIdSource = pisXeCPR) and (not AsylnSoeger) then
        begin
          AsylnSoeger := ChkBoxYesNo('Er denne person asylansøger?' + sLineBreak + sLineBreak +
            'Hvis Nej, så oprettes automatisk et fiktivt CPR-nr. til brug for statistik og CTR for ' +
            EdiRcp.PaCprNr, False);

          // Don't request a CtrFiktivId if it's an asylumn seeker. Thats set to a fixed value later in this method
          if not AsylnSoeger then
          begin
            // Prompt for the Country code
            TFormC2CtrCountryList.ShowDialog(cdCtrLan, LCtrCountryCode);
            if not GetCtrFiktivId(LCtrCountryCode, LLmsModtagerId) then
              ChkBoxOK('Der kunne ikke tildeles et Lms-ID til denne kunde');
          end;
        end;

        ffPatKar.Insert;
        ffPatKarLmsModtager.AsString := LLmsModtagerId;
        if LCtrCountryCode > 0 then
          ffPatKarLandekode.Value := LCtrCountryCode;
        ffPatKarKundeType.AsInteger := 1;
        if EHCPR then
          ffPatKarKundeType.AsInteger := 0;
        ffPatKarKundeNr.AsString := EdiRcp.PaCprNr;
        EKundeNr.Text := EdiRcp.PaCprNr;
        if (LPersonIdSource = pisXeCPR) then
        begin
          ffPatKarFiktivtCprNr.AsBoolean := False;
          ffPatKarCprCheck.AsBoolean := False;
        end
        else
        begin
          if EHCPR then
            ffPatKarLmsModtager.AsString := '4600000000';
          ffPatKarCprCheck.AsBoolean := True;
          if EHCPR then
            ffPatKarCprCheck.AsBoolean := False;
          ffPatKarFiktivtCprNr.AsBoolean := False;
        end;
        ffPatKarBarn.AsBoolean := False;
        ffPatKarNettoPriser.AsBoolean := False;
        ffPatKarEjSubstitution.AsBoolean := False;
        ffPatKarEjCtrReg.AsBoolean := False;
        ffPatKarNavn.AsString := EdiRcp.PaNavn;
        ffPatKarAdr1.AsString := EdiRcp.Adr;
        ffPatKarAdr2.AsString := EdiRcp.Adr2;
        ffPatKarPostNr.AsString := EdiRcp.PostNr;
        ffPatKarTlfNr.AsString := EdiRcp.Tlf;
        // if member of danmark then upddate the patient
        if EdiRcp.Danmark then
          ffPatKarDKMedlem.AsInteger := 1;
        if TryStrToInt(EdiRcp.Amt, itst) then
        begin
          if itst = 0 then
            EdiRcp.Amt := ffRcpOplAfrAmt.AsString;
        end
        else
          EdiRcp.Amt := ffRcpOplAfrAmt.AsString;

        try
          ffPatKarAmt.AsInteger := Amt2Region(StrToInt(EdiRcp.Amt));
        except
          ffPatKarAmt.AsInteger := 0;
        end;
        ffPatKarYderNr.AsString := EdiRcp.YdNr;
        ffPatKarYderCprNr.AsString := EdiRcp.YdCprNr;
        ffPatKarLuYdNavn.AsString := EdiRcp.YdNavn;
        if pos('DK', EdiRcp.Tilskud) > 0 then
          ffPatKarDKMedlem.AsInteger := 1; // Medlem danmark
        if AsylnSoeger then
        begin
          // Don't try to replace the KundeNr if it's a X-eCPR, as this is already set previously in this method
          if LPersonIdSource <> pisXeCPR then
            ffPatKarKundeNr.AsString := AsylnCPR;
          ffPatKarLmsModtager.AsString := '4000005555';
          ffPatKarCprCheck.AsBoolean := False;
        end;
        ffPatKarEjCtrReg.AsBoolean := AsylnSoeger;
        ffPatKar.Post;
        if not GetCTR(ffPatKarKundeNr.AsString) then
          Exit;
        EdiTxt := '';
        if EdiRcp.Tilskud <> '' then
          EdiTxt := EdiTxt + sLineBreak + '  ' + EdiRcp.Tilskud;
        if EdiRcp.TilBrug <> '' then
          EdiTxt := EdiTxt + sLineBreak + '  ' + EdiRcp.TilBrug;
        if EdiRcp.Levering <> '' then
          EdiTxt := EdiTxt + sLineBreak + '  ' + EdiRcp.Levering;
        if EdiRcp.FriTxt <> '' then
          EdiTxt := EdiTxt + sLineBreak + '  ' + EdiRcp.FriTxt;
        if (EdiTxt <> '') then
          EdiTxt := sLineBreak + '  Bemærk følgende : ' + EdiTxt;
        if EHCPR then
          EdiTxt := '';
        ChkBoxOK('Ny kunde gemt!' + EdiTxt);
        save_ediNr := EdiRcp.LbNr;
        GoAuto := False;
        // 08-06-2021/MA: Prepare CF5 and CF6 with the customer no.
        edtCprNr1.Text := ffPatKarKundeNr.AsString;
        edtCprNr.Text := ffPatKarKundeNr.AsString;
        RefreshDoseDispensingCardsList(ffPatKarKundeNr.AsString,
          TFMKPersonIdentifierSource.DetectSource(ffPatKarKundeNr.AsString));
      finally
        TakserActive := False;
        LogoffTimer := 0;
        if GoAuto then
        begin
          StamPages.ActivePage := TabSheet;
          if StamPages.ActivePage = KartotekPage then
          begin
            // Kun ved retur til kartotek
            RefreshCF1WithBlankKundenr;
//            ffPatKar.FindKey([KundeKeyBlk]);
//            EKundeNr.SelectAll;
//            EKundeNr.SetFocus;
          end;
        end;
      end;
    finally
      c2logadd('Bottom of edifactRcp');
    end;
  end;

end;

procedure TStamForm.edtCPRNr1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if (CF6_SaveCPRNr = '') or (edtCPRNr1.Text <> CF6_SaveCPRNr) then
    begin
      dtpDatoFra.Date := Date - MainDm.VisRecepterCF6;
      dtpTidFra.Time := StrToTime('00:00:00');
      dtpDatoTil.Date := IncDay(dtpDatoFra.Date,MainDm.VisRecepterCF6);
      dtpTidTil.Time := StrToTime('23:59:59');
      Key := #0;
    end;
    CF6_SaveCPRNr := edtCPRNr1.Text;

  end;


end;

procedure TStamForm.edtCprNrKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    VisOrdCprNr;
    if Trim(edtCprNr.Text) <> '' then
      SidKundeNr := edtCprNr.Text;
    c2logadd('3: sidkundenr ' + SidKundeNr);
  end;

end;

procedure TStamForm.eEkspLbKeyPress(Sender: TObject; var Key: Char);
var
  lbstr: string;
  LbNr: Integer;
begin
  if Key <> #13 then
    exit;
  with MainDm do
  begin
    if Length(eEkspLb.Text) = 13 then
    begin
      if copy(eEkspLb.Text, 1, 4) = '9900' then
      begin
        lbstr := copy(eEkspLb.Text, 5, 8);
        LbNr := StrToInt(lbstr);
        eEkspLb.Text := inttostr(LbNr);
        PostMessage(butFindEksp.Handle, WM_LBUTTONDOWN, 0, 0);
        PostMessage(butFindEksp.Handle, WM_LBUTTONUP, 0, 0);
      end;
    end;
    butFindEksp.SetFocus;
  end;

end;

procedure TStamForm.AcEdiRcpExecute(Sender: TObject);
var
  SaveIdx: String;
  EdiLbNr: LongWord;
begin
  // this routine has now been changed to check if the lbnr is in
  // RSEkspeditioner. ie it has been delivered by ReceptServer
  with MainDm do
  begin
    c2logadd('edifact Recepter called');
    if KonvRSEkspBusy then
      exit;
    if not RcptLbnr('Søg edifact recept på løbenr', EdiLbNr) then
      exit;

    SaveIdx := nxRSEksp.IndexName;
    nxRSEksp.IndexName := 'ReceptIdOrder';
    try
      try
        if nxRSEksp.FindKey([EdiLbNr]) then
        begin
          c2logadd('konvrseksp called from acedircpexecute');
          KonvRSEksp(EdiLbNr, StamPages.ActivePage);
          if RCPTakserCompleted then
            CheckMoreOpenRCP(False);
          exit;
        end;
      except
        on e: Exception do
        begin
          Application.MessageBox(Pchar(e.Message), 'Fejl');
          exit;
        end;
      end;
    finally
      nxRSEksp.IndexName := SaveIdx;
    end;
  end;
end;

procedure TStamForm.AcDosKortExecute(Sender: TObject);
var
  DosResult: Integer;
  sl: TStringList;
  save_TakserDosisKort: Boolean;
  save_Undladafstemplingsetiketter: Boolean;
  autosl: TStringList;
  mansl: TStringList;

  procedure build_cardlists;
  var
    cardno: Integer;
    tmpstr: string;
    save_index: string;
  begin
    with MainDm do
    begin
      save_index := ffdch.IndexName;
      ffdch.IndexName := 'CardNumber';
      try
        for tmpstr in sl do
        begin
          if TryStrToInt(tmpstr, cardno) then
          begin
            if ffdch.FindKey([cardno]) then
            begin
              // skip parked cards sagsnr 10484
              if ffdchParked.AsBoolean then
                continue;

              if ffdchAutoEksp.AsBoolean then
                autosl.add(tmpstr)
              else
                mansl.add(tmpstr);
            end;
          end;
        end;
      finally
        ffdch.IndexName := save_index;
      end;

    end;
  end;

begin
  with MainDm do
  begin
    TakserDosisKortAuto := False;
    Undladafstemplingsetiketter := False;
    try
      DosResult := TfrmDosKort.SelectDoskort;
    except
      on e: Exception do
      begin
        ChkBoxOK(e.Message);
        exit; // DosResult := 0;
      end;
    end;

    case DosResult of
      0:
        exit;
      1:
        begin

          DosisBatchMode := False;
          KonvDosKort(ffdchCardNumber.AsInteger, StamPages.ActivePage);
        end;
      2:
        begin
          save_TakserDosisKort := TakserDosisKortAuto;
          save_Undladafstemplingsetiketter := Undladafstemplingsetiketter;
          sl := TStringList.Create;
          autosl := TStringList.Create;
          mansl := TStringList.Create;
          DosisBatchMode := True;

          try
            if not FileExists(StamForm.DosisPakkeGruppeFileName) then
              exit;
            sl.LoadFromFile(StamForm.DosisPakkeGruppeFileName);
            DeleteFile(StamForm.DosisPakkeGruppeFileName);

            build_cardlists;
            if (autosl.Count <> 0) and (mansl.Count <> 0) then
            begin
              if not frmYesNo.NewYesNoBox
                ('Pakkegruppen indeholder både kort, der er markeret med autoekspedition og kort, der ikke er.'
                + #13#10 + 'Ønsker du at fortsætte?' + #13#10 +

                'Hvis Ja, vil kun kort, der på dosiskortet er markeret med ' +
                #13#10 + 'autoekspedition, vil blive takseret automatisk.' +
                #13#10 + 'De øvrige vil komme til sidst og vil blive takseret en ad gangen.')
              then
              begin
                exit;
              end;
            end;
            DosisUdlignPatients.Clear;
            while autosl.Count <> 0 do
            begin
              TakserDosisKortAuto := save_TakserDosisKort;
              Undladafstemplingsetiketter := save_Undladafstemplingsetiketter;
              if KonvDosKort(StrToInt(autosl.Strings[0]), StamPages.ActivePage,True)
              then
              begin
                if save_TakserDosisKort then
                begin
                  autosl.Delete(0);
                  if autosl.Count = 0 then
                    break;
                  Continue;
                end;
                if not ChkBoxYesNo
                  ('Ønsker du at fortsætte med ekspedition af næste dosiskort?',
                  True) then
                begin
                  if mansl.Count <> 0 then
                    autosl.AddStrings(mansl);
                  autosl.SaveToFile(StamForm.DosisPakkeGruppeFileName);
                  exit;
                end;
                autosl.Delete(0);
                if autosl.Count = 0 then
                  break;
              end
              else
              begin
                c2logadd('failed to takserdosiskort ' + autosl.Strings[0]);

                if not ChkBoxYesNo
                  ('Ønsker du at fortsætte med ekspedition af næste dosiskort?',
                  True) then
                begin
                  if mansl.Count <> 0 then
                    autosl.AddStrings(mansl);
                  autosl.SaveToFile(StamForm.DosisPakkeGruppeFileName);
                  exit;
                end;
                c2logadd('autosl.count is ' + autosl.Count.toString);
                autosl.Delete(0);
                c2logadd('autosl.count after the delete is ' +
                  autosl.Count.toString);
                if autosl.Count = 0 then
                  break;

              end;
            end;

            while mansl.Count <> 0 do
            begin
              TakserDosisKortAuto := save_TakserDosisKort;
              Undladafstemplingsetiketter := save_Undladafstemplingsetiketter;
              if KonvDosKort(StrToInt(mansl.Strings[0]), StamPages.ActivePage,True)
              then
              begin
                mansl.Delete(0);
                if mansl.Count = 0 then
                  break;
                // if save_TakserDosisKort then
                // continue;
                if not ChkBoxYesNo
                  ('Ønsker du at fortsætte med ekspedition af næste dosiskort?',
                  True) then
                begin
                  mansl.SaveToFile(StamForm.DosisPakkeGruppeFileName);
                  exit;
                end;
              end
              else
              begin
                if not ChkBoxYesNo
                  ('Ønsker du at fortsætte med ekspedition af næste dosiskort?',
                  True) then
                begin
                  mansl.SaveToFile(StamForm.DosisPakkeGruppeFileName);
                  exit;
                end;
                mansl.Delete(0);
                if mansl.Count = 0 then
                  break;
              end;
            end;
          finally
            if DosisUdlignPatients.Count <> 0 then
            begin
              ChkBoxOK('Der er en udligning til følgende cprnr.' + #13#10#13#10
                + DosisUdlignPatients.Text + #13#10#13#10 +
                'Denne er ikke medtaget i den automatiske' + #13#10 +
                'ekspedition af dosiskort.' + #13#10#13#10 +
                'Skal håndteres manuelt.');
            end;
            DosisBatchMode := False;
            mansl.Free;
            autosl.Free;
            sl.Free;
          end;
        end;

    end;
  end;
end;

function TStamForm.KonvDosKort(LbNr: LongWord; TabSheet: TcxTabSheet; APakkeGruppe : boolean): Boolean;
var
  EdiRcp: TEdiRcp;
  LinAnt, P: Integer;
  NewOrdAnt: Integer;
  i: Integer;
  foundlargeantal: Boolean;
  TotalQuantity: Integer;
  ErrorList: TStringList;
  RSReceptId: Integer;
  PNr: Word;

  function find_edi_rcp(varenummer: string): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    if EdiRcp.OrdAnt >= 1 then
    begin
      for i := 1 to EdiRcp.OrdAnt do
      begin
        if EdiRcp.Ord[i].VareNr = varenummer then
        begin
          EdiRcp.Ord[i].Antal := EdiRcp.Ord[i].Antal + TotalQuantity;
          Result := True;
          exit;
        end;
      end;
    end;
  end;

  procedure calculate_total;
  var
    tmpstr: string;
    qu1: Integer;
    qu2: Integer;
    dotpos: Integer;
    savesep: Char;
  begin
    with MainDm do
    begin
      savesep := FormatSettings.DecimalSeparator;
      FormatSettings.DecimalSeparator := ',';
      try
        tmpstr := format('%6.2f', [ffDCLQuantity1.AsFloat]);
        dotpos := pos(',', tmpstr);
        qu1 := StrToInt(copy(tmpstr, 1, dotpos - 1));
        qu2 := StrToInt(copy(tmpstr, dotpos + 1, 2));
        TotalQuantity := qu1;
        if qu2 <> 0 then
          TotalQuantity := TotalQuantity + 1;
        tmpstr := format('%6.2f', [ffDCLQuantity2.AsFloat]);
        dotpos := pos(',', tmpstr);
        qu1 := StrToInt(copy(tmpstr, 1, dotpos - 1));
        qu2 := StrToInt(copy(tmpstr, dotpos + 1, 2));
        TotalQuantity := TotalQuantity + qu1;
        if qu2 <> 0 then
          TotalQuantity := TotalQuantity + 1;
        tmpstr := format('%6.2f', [ffDCLQuantity3.AsFloat]);
        dotpos := pos(',', tmpstr);
        qu1 := StrToInt(copy(tmpstr, 1, dotpos - 1));
        qu2 := StrToInt(copy(tmpstr, dotpos + 1, 2));
        TotalQuantity := TotalQuantity + qu1;
        if qu2 <> 0 then
          TotalQuantity := TotalQuantity + 1;
        tmpstr := format('%6.2f', [ffDCLQuantity4.AsFloat]);
        dotpos := pos(',', tmpstr);
        qu1 := StrToInt(copy(tmpstr, 1, dotpos - 1));
        qu2 := StrToInt(copy(tmpstr, dotpos + 1, 2));
        TotalQuantity := TotalQuantity + qu1;
        if qu2 <> 0 then
          TotalQuantity := TotalQuantity + 1;
        tmpstr := format('%6.2f', [ffDCLQuantity5.AsFloat]);
        dotpos := pos(',', tmpstr);
        qu1 := StrToInt(copy(tmpstr, 1, dotpos - 1));
        qu2 := StrToInt(copy(tmpstr, dotpos + 1, 2));
        TotalQuantity := TotalQuantity + qu1;
        if qu2 <> 0 then
          TotalQuantity := TotalQuantity + 1;
        tmpstr := format('%6.2f', [ffDCLQuantity6.AsFloat]);
        dotpos := pos(',', tmpstr);
        qu1 := StrToInt(copy(tmpstr, 1, dotpos - 1));
        qu2 := StrToInt(copy(tmpstr, dotpos + 1, 2));
        TotalQuantity := TotalQuantity + qu1;
        if qu2 <> 0 then
          TotalQuantity := TotalQuantity + 1;
        tmpstr := format('%6.2f', [ffDCLQuantity7.AsFloat]);
        dotpos := pos(',', tmpstr);
        qu1 := StrToInt(copy(tmpstr, 1, dotpos - 1));
        qu2 := StrToInt(copy(tmpstr, dotpos + 1, 2));
        TotalQuantity := TotalQuantity + qu1;
        if qu2 <> 0 then
          TotalQuantity := TotalQuantity + 1;
        tmpstr := format('%6.2f', [ffDCLQuantity8.AsFloat]);
        dotpos := pos(',', tmpstr);
        qu1 := StrToInt(copy(tmpstr, 1, dotpos - 1));
        qu2 := StrToInt(copy(tmpstr, dotpos + 1, 2));
        TotalQuantity := TotalQuantity + qu1;
        if qu2 <> 0 then
          TotalQuantity := TotalQuantity + 1;
        if ffDCLRegularDose.AsBoolean then
        begin
          TotalQuantity := TotalQuantity * ffdchInterval.AsInteger;
        end
        else
        begin
          tmpstr := ffDCLDays.AsString;
          qu1 := 1;
          for qu2 := 1 to Length(tmpstr) do
          begin
            if tmpstr[qu2] = ',' then
              qu1 := qu1 + 1;
          end;
          TotalQuantity := TotalQuantity * qu1;
        end;
      finally
        FormatSettings.DecimalSeparator := savesep;
      end;

    end;
  end;

  function CheckLocalRSOrdination(OrdId: string; var Receptid: Integer)
    : Boolean;
  var
    save_index: string;
    found: Boolean;
  begin
    with MainDm do
    begin
      found := False;
      Result := False;
      save_index := nxRSEkspLin.IndexName;
      nxRSEkspLin.IndexName := 'OrdIdOrden';
      nxRSEkspLin.SetRange([OrdId], [OrdId]);
      try
        if nxRSEkspLin.RecordCount = 0 then
          exit;

        nxRSEkspLin.First;
        while not nxRSEkspLin.Eof do
        begin
          if nxRSEkspLinRSLbnr.AsInteger = 0 then
          begin
            found := True;
            Receptid := nxRSEkspLinReceptId.AsInteger;
            // need to redresh the details from FMK
            if not uFMKGetMedsById.RefreshReceivedMedications(ffPatKarKundeNr.AsString,
                    nxRSEkspLinPrivat.AsInteger, nxRSEkspLinOrdId.AsString, MainDm.AfdNr,
                    nxRSEkspReceptId.AsInteger,True ) then
            begin
              found:= False;
              break;
            end
            else
              break;
          end;
          nxRSEkspLin.Next;
        end;

      finally
        Result := found;
        nxRSEkspLin.CancelRange;
        nxRSEkspLin.IndexName := save_index;
      end;

    end;
  end;

begin
  with MainDm do
  begin
    ErrorList := TStringList.Create;
    try
      Result := False;
      ffdch.IndexName := 'CardNumber';
      if not ffdch.FindKey([inttostr(LbNr)]) then
      begin
        ChkBoxOK('Dosiskort findes ikke');
        exit;
      end;

      // check to see if the card number is in the converted table then if it is do not
      // allow taksering
      { TODO : Dosis fmk check }
      try
        with MainDM.nxdb.OpenQuery('select ' +
            fnDosisKortKartotekKonverteretFraC2CardNumber + ' from ' +
            tnDosisKortKartotek + ' where ' +
            fnDosisKortKartotekKonverteretFraC2CardNumber_P + ' and ' +
            fnDosisKortKartotekSlettet + ' is null', [LbNr]) do
        begin
          try
            if not Eof then
            begin
              if APakkeGruppe then
              begin
                ChkBoxOK('Dosiskortet skal takseres via C2 Dosiskort for FMK');
                exit;
              end
              else
              begin
                if not frmYesNo.NewYesNoBox('Dosiskortet skal normalt takseres via C2 Dosiskort (FMK).' + #13#10+
                    'Skal kortet alligevel takseres manuelt nu?') then
                  exit;

                frmYesNo.NewOKBox('Kontroller følgende i C2 Dosiskort (FMK) når kort takseres manuel:' + #13#10 +
                                  '- Fjern markeringen "Automatisk taksering".' +#13#10 +
                                  '- Sørg for at status på perioden opdateres.')
              end;
            end;
          finally
            Free;
          end;
        end;
      except
      end;

      ffdcl.IndexName := 'CardProd';
      DosisKortAutoExp := ffdchAutoEksp.AsBoolean;
      if ffdchTerminalStatus.IsNull then
        DosiskortHeaderTerminal := 1
      else
      begin
        if ffdchTerminalStatus.AsBoolean then
          DosiskortHeaderTerminal := 2
        else
          DosiskortHeaderTerminal := 3;
      end;
      if Trunc(ffdchStartDate.AsDateTime) > Date then
      begin
        if not ChkBoxYesNo('Dosiskort nr ' + inttostr(LbNr) +
          ' er ikke startet endnu.  ' + #10#13 + 'Ønsker du at taksere det? ',
          False) then
        begin
          // Result := True;
          exit;
        end;
      end;
      FillChar(EdiRcp, sizeof(TEdiRcp), 0);
      EdiRcp.LbNr := ffdchCardNumber.AsInteger;
      EdiRcp.Annuller := False;
      EdiRcp.PaCprNr := ffDCHPatientNumber.AsString;
      EdiRcp.PaNavn := ffDCHPatientName.AsString;
      EdiRcp.ForNavn := EdiRcp.PaNavn;
      P := pos(',', EdiRcp.PaNavn);
      if P <> 0 then
        EdiRcp.ForNavn := copy(EdiRcp.PaNavn, P + 1, Length(EdiRcp.PaNavn) - P);
      EdiRcp.Adr := ffDCHPatientAddress1.AsString;
      EdiRcp.Adr2 := ffDCHPatientAddress2.AsString;
      EdiRcp.PostNr := ffDCHPostnummer.AsString;
      EdiRcp.By := ''; // todo
      ffPatKar.IndexName := 'NrOrden';
      if ffPatKar.FindKey([EdiRcp.PaCprNr]) then
      begin
        // Stop hvis bemærkning
        if not GetCTR(ffPatKarKundeNr.AsString) then
          Exit;
        if not DosisAutoStopIkkeVedBemaerkning then
          if EBem.Lines.Count > 0 then
            ChkBoxOK('Der er bemærkninger på patienten!' + #10#13 +
              EBem.Lines.Text);
        EdiRcp.Amt := ffPatKarAmt.AsString;
        SidKundeNr := ffPatKarKundeNr.AsString;
        c2logadd('15: sidkundenr ' + SidKundeNr);
      end;
      if not ValidatePatKar then
        exit;
      if ffPatKarDebitorNr.AsString <> '' then
      begin
        if ffDebKar.FindKey([ffPatKarDebitorNr.AsString]) then
        begin
          if ffDebKarKontoLukket.AsBoolean then
          begin
            if Trim(ffDebKarLukketGrund.AsString) <> '' then
              ChkBoxOK('Debitorkonto er lukket : ' +
                ffDebKarLukketGrund.AsString)
            else
              ChkBoxOK('Debitorkonto er lukket.');
            exit;
          end;

        end;
      end;
      EdiRcp.Tlf := ''; // todo
      EdiRcp.Alder := ''; // todo
      EdiRcp.Barn := ''; // todo
      EdiRcp.Tilskud := ''; // todo
      EdiRcp.TilBrug := ''; // todo
      EdiRcp.Levering := ffDCHDeliveryAddress.AsString;
      EdiRcp.FriTxt := ffDCHDoctorComment.AsString;
      EdiRcp.YdNr := ffDCHDoctorNumber.AsString;
      EdiRcp.YdCprNr := '';
      IF ffdchYderCprNr.AsString <> '' then
      begin
        EdiRcp.YdCprNr := Trim(ffdchYderCprNr.AsString);
      end
      else
      begin
        ffYdLst.IndexName := 'YderNrOrden';
        if ffYdLst.FindKey([EdiRcp.YdNr]) then
        begin
          EdiRcp.YdCprNr := ffYdLstCprNr.AsString;
        end;
      end;
      EdiRcp.YdNavn := ffDCHDoctorName.AsString;
      EdiRcp.YdSpec := ''; // todo
      EdiRcp.OrdAnt := 0;
      with EdiRcp do
      begin

        // pass through the doslines ans skip any fees
        ffdcl.First;
        while not ffdcl.Eof do
        begin
          calculate_total;
          if not find_edi_rcp(ffDCLVareNummer.AsString) then
          begin
            LinAnt := TotalQuantity;
            ffLagKar.IndexName := 'NrOrden';
            if ffLagKar.FindKey([0, ffDCLVareNummer.AsString]) then
            begin
              if ffLagKarVareType.AsInteger in [8, 9, 10, 11, 12] then
              begin
                ffdcl.Next;
                Continue;
              end;
            end;
            OrdAnt := OrdAnt + 1;
            Ord[OrdAnt].VareNr := ffDCLVareNummer.AsString;
            Ord[OrdAnt].Navn := ffLagKarNavn.AsString;
            Ord[OrdAnt].Disp := ffLagKarForm.AsString;
            Ord[OrdAnt].Strk := ffLagKarStyrke.AsString;
            Ord[OrdAnt].Pakn := ffLagKarPakning.AsString;
            Ord[OrdAnt].Subst := ''; // todo
            if ffdclEjSubst.AsBoolean then
              Ord[OrdAnt].Subst := '-S';

            Ord[OrdAnt].Antal := LinAnt;
            if ffLagKarVareType.AsInteger in [8, 9, 10, 11, 12] then
              Ord[OrdAnt].Antal := 1;
            if Ord[OrdAnt].Antal = 0 then
              Ord[OrdAnt].Antal := 1;
            Ord[OrdAnt].Tilsk := ''; // todo
            Ord[OrdAnt].IndKode := ''; // todo
            Ord[OrdAnt].IndTxt := ffDCLVareIndikation.AsString;
            Ord[OrdAnt].Udlev := 0; // todo
            Ord[OrdAnt].Forhdl := ''; // todo
            Ord[OrdAnt].DosKode := ''; // todo
            Ord[OrdAnt].DosTxt := ''; // todo
            Ord[OrdAnt].OrdId := ffdclOrdid.AsString;
          end;
          ffdcl.Next;
        end;
        // now we have ordant product lines in the list
        // we need to make sure that there are no lines > 99 quantity.
        NewOrdAnt := OrdAnt;
        foundlargeantal := True;
        while foundlargeantal do
        begin
          foundlargeantal := False;
          for i := 1 to OrdAnt do
          begin
            if Ord[i].Antal > 99 then
            begin
              Inc(NewOrdAnt, 1);
              Ord[NewOrdAnt].VareNr := Ord[i].VareNr;
              Ord[NewOrdAnt].Navn := Ord[i].Navn;
              Ord[NewOrdAnt].Disp := Ord[i].Disp;
              Ord[NewOrdAnt].Strk := Ord[i].Strk;
              Ord[NewOrdAnt].Pakn := Ord[i].Pakn;
              Ord[NewOrdAnt].Subst := Ord[i].Subst;
              Ord[NewOrdAnt].Antal := Ord[i].Antal - 99;

              Ord[i].Antal := 99;
              Ord[NewOrdAnt].Tilsk := Ord[i].Tilsk;
              Ord[NewOrdAnt].IndKode := Ord[i].IndKode;
              Ord[NewOrdAnt].IndTxt := Ord[i].IndTxt;
              Ord[NewOrdAnt].Udlev := Ord[i].Udlev;
              Ord[NewOrdAnt].Forhdl := Ord[i].Forhdl;
              Ord[NewOrdAnt].DosKode := Ord[i].DosKode;
              Ord[NewOrdAnt].DosTxt := Ord[i].DosTxt;
              Ord[NewOrdAnt].OrdId := Ord[i].OrdId;
              foundlargeantal := True;
            end;

          end;
          OrdAnt := NewOrdAnt;
        end;
        // NOW ADD THE TWO Dosis fees !!!!!
        OrdAnt := OrdAnt + 1;
        Ord[OrdAnt].VareNr := DosispakkegebyrVarenr;  // default is 688002
        ffLagKar.IndexName := 'NrOrden';
        if ffLagKar.FindKey([0, DosispakkegebyrVarenr]) then
          Ord[OrdAnt].Navn := ffLagKarNavn.AsString;
        Ord[OrdAnt].Subst := ''; // todo
        Ord[OrdAnt].Antal := (ffdchInterval.AsInteger div 7) + 1;
        if ffdchInterval.AsInteger mod 7 = 0 then
          Ord[OrdAnt].Antal := floor(ffdchInterval.AsInteger / 7);
        Ord[OrdAnt].Tilsk := ''; // todo
        Ord[OrdAnt].IndKode := ''; // todo
        Ord[OrdAnt].IndTxt := ''; // ffDCLVareIndikation.AsString;
        Ord[OrdAnt].Udlev := 0; // todo
        Ord[OrdAnt].Forhdl := ''; // todo
        Ord[OrdAnt].DosKode := ''; // todo
        Ord[OrdAnt].DosTxt := ''; // todo
        OrdAnt := OrdAnt + 1;
        Ord[OrdAnt].VareNr := '688003';
        ffLagKar.IndexName := 'NrOrden';
        if ffLagKar.FindKey([0, '688003']) then
          Ord[OrdAnt].Navn := ffLagKarNavn.AsString;
        Ord[OrdAnt].Subst := ''; // todo
        Ord[OrdAnt].Antal := (ffdchInterval.AsInteger div 7) + 1;
        if ffdchInterval.AsInteger mod 7 = 0 then
          Ord[OrdAnt].Antal := floor(ffdchInterval.AsInteger / 7);

        Ord[OrdAnt].Tilsk := ''; // todo
        Ord[OrdAnt].IndKode := ''; // todo
        Ord[OrdAnt].IndTxt := ''; // ffDCLVareIndikation.AsString;
        Ord[OrdAnt].Udlev := 0; // todo
        Ord[OrdAnt].Forhdl := ''; // todo
        Ord[OrdAnt].DosKode := ''; // todo
        Ord[OrdAnt].DosTxt := ''; // todo

        // now add the fees from dosislines if there are any
        ffdcl.First;
        while not ffdcl.Eof do
        begin
          ffLagKar.IndexName := 'NrOrden';
          if ffLagKar.FindKey([0, ffDCLVareNummer.AsString]) then
          begin
            if not(ffLagKarVareType.AsInteger in [8, 9, 10, 11, 12]) then
            begin
              ffdcl.Next;
              Continue;
            end;
          end;
          OrdAnt := OrdAnt + 1;
          Ord[OrdAnt].VareNr := ffDCLVareNummer.AsString;
          Ord[OrdAnt].Navn := ffLagKarNavn.AsString;
          Ord[OrdAnt].Disp := ffLagKarForm.AsString;
          Ord[OrdAnt].Strk := ffLagKarStyrke.AsString;
          Ord[OrdAnt].Pakn := ffLagKarPakning.AsString;
          Ord[OrdAnt].Subst := ''; // todo
          if ffdclEjSubst.AsBoolean then
            Ord[OrdAnt].Subst := '-S';
          Ord[OrdAnt].Antal := 1;
          Ord[OrdAnt].Tilsk := ''; // todo
          Ord[OrdAnt].IndKode := ''; // todo
          Ord[OrdAnt].IndTxt := ffDCLVareIndikation.AsString;
          Ord[OrdAnt].Udlev := 0; // todo
          Ord[OrdAnt].Forhdl := ''; // todo
          Ord[OrdAnt].DosKode := ''; // todo
          Ord[OrdAnt].DosTxt := ''; // todo
          Ord[OrdAnt].OrdId := ffdclOrdid.AsString;
          ffdcl.Next;
        end;

      end;

      // run down the ordination id and make sure that each ordid is available
      // locally
      for i := 1 to EdiRcp.OrdAnt do
      begin
        if EdiRcp.Ord[i].OrdId <> '' then
          if not CheckLocalRSOrdination(EdiRcp.Ord[i].OrdId, RSReceptId) then
            ErrorList.add('Recepten ' + EdiRcp.Ord[i].OrdId + ' ' +
              EdiRcp.Ord[i].Navn + ' er ikke  taget under behandling (låst).')
          else
            EdiRcp.Ord[i].Receptid := RSReceptId;

      end;

      if ErrorList.Count <> 0 then
      begin
        ErrorList.Insert(0, '');
        ErrorList.Insert(0, '');
        ErrorList.Insert(0, '');
        ErrorList.Insert(0, '');
        ErrorList.Insert(0, 'FMK Fejl Dosiskortnr. ' +
          inttostr(EdiRcp.LbNr));
        if ChkBoxYesNo(ErrorList.Text + #13#10#13#10 +
          'Vil du udskrive listen?', False) then
        begin
          PNr := 0;
          ErrorList.SaveToFile('c:\c2\DosisFejl.txt');
          PatMatrixPrnForm.PrintMatrix(PNr, 'c:\c2\DosisFejl.txt');
        end;
        exit;
      end;

      EkspDosis(99999999, addr(EdiRcp));
      Result := True;
    finally
      c2logadd('finally');
      ErrorList.Free;
      FillChar(EdiRcp, sizeof(TEdiRcp), 0);
      TakserActive := False;
      LogoffTimer := 0;
      StamPages.ActivePage := TabSheet;
      if StamPages.ActivePage = KartotekPage then
      begin
        // Kun ved retur til kartotek
        ffPatKar.FindKey([KundeKeyBlk]);
        EKundeNr.SelectAll;
        EKundeNr.SetFocus;
      end;
      c2logadd('after finally');
    end;
  end;
end;

function TStamForm.UserLogon: Boolean;
var
  Status: Integer;
  Retries: Word;
  LPassword : string;
  LLogonType : TLogonType;
begin
  C2LogAdd('in user logon');
  for Retries := 1 to 3 do
  begin
    Status := UsrResCancel;
    C2LogAdd('Before showC2logon');
    LLogonType := ltAll;
    TFormC2Logon.ConsiderSosiIdInvalidWhenExpiresWithin := maindm.FMKCertificateExpiredSeconds;
    if (TFormC2Logon.ShowC2Logon(MainDm.Bruger,maindm.Afdeling,LPassword,LLogonType)) and
      (maindm.Bruger.IsLoggedOn) then
    begin

      C2LogAdd('we are logged on');
      Status := MidClient.UserCheck(MainDm.BrugerNr, LPassword);
      case Status of
        UsrResOK:
          begin
            UpdateStatusBrugerInfo;
            break;
          end;
        UsrResNotUser:
          ChkBoxOK('Bruger findes IKKE i kartoteket!');
        UsrResNotPW:
          ChkBoxOK('Bruger kodeord er forkert!');
      else
        MidClient.ClientError(Status);
      end;
    end;
  end;
  Result := Status = UsrResOK;
  if Result then
  begin
    with MainDm do
    begin

      if (Bruger.HasValidSOSIIdOnServer) and (not Bruger.SOSIId.IsValid) then
        Bruger.SyncSOSIIdFromServer(Afdeling);

      { TODO : sosiid eanlokationsnr }
      // Transfer the current EAN lokationsnr. to the SOSIId as the SOSIId is only associated with a CVR-nr. but not a
      // specific EAN lokationsnr. so we have to apply where we are working at the moment
      Bruger.SOSIId.EANLokationsnr := Afdeling.EANLokationsnr;

       C2LogAdd('SOSIIdIsValid=' + BoolToStr(Bruger.SOSIIdIsValid, True) +
        '. ValidFrom=' + DateTimeToStr(Bruger.SOSIId.ValidFrom) +
        '. ValidTo=' + DateTimeToStr(Bruger.SOSIId.ValidTo) + '. Bruger.LastErrorMessage=' + Bruger.LastErrorMessage);


    end;

  end;

end;

procedure TStamForm.acKontrolSMSExecute(Sender: TObject);
begin
  with SMSDM do
  begin
    SendKontrolSMS;
  end;
end;

procedure TStamForm.acLevlisteBonExecute(Sender: TObject);
begin
  with MainDm do
  begin
    // if there is no lev listenr then just create zero for current lbnr
    if ffEksOvrListeNr.AsInteger = 0 then
    begin
      if ChkBoxYesNo('Vil du registrere løbenr som udleveret i DMVS' + #13#10 +
                          'og generere en bon?',False) then
        HandleLevListe;

    end
    else
    begin
      // its a whole list
      if ChkBoxYesNo('Vil du registrere listenr ' + ffEksOvrListeNr.AsString + ' som udleveret i DMVS'
                      + #13#10 + 'og generere en bon?',False) then
        HandleLevListe;
    end;

    ffEksOvr.Refresh;

  end;

end;

procedure TStamForm.acLogOffExecute(Sender: TObject);
var
  LLoggedOn : boolean;
begin
  C2LogAdd('actionlogoff  fired');
  if StamPages.ActivePage = KartotekPage then
  begin
    EKundeNr.Text := MainDm.ffPatKarKundeNr.AsString;
    EKundeNr.SetFocus;
    EKundeNr.SelectAll;
  end;

  if (MainDm.Bruger.HasUserCertificate) and (MainDm.Bruger.SOSIIdIsValid) then
  begin
    frmC2Logon.TFormC2Logon.ShowC2Logoff(MainDm.Bruger,MainDm.Afdeling,lsaPromptUser);
  end;

  C2LogAdd('before user logon');
  LLoggedOn := False;
  while not LLoggedOn do
  begin
    if not UserLogon then
    begin
      PostMessage(Application.Handle, wm_Close, 0, 0);
      exit;
    end;

    if (MainDm.Bruger.HasUserCertificate) and (MainDm.Bruger.SOSIIdIsValid) then
    begin
      C2LogAdd('FMK logged in');
      ResubmitFMKCertificateErrors(maindm.Bruger.Brugernr);
      LLoggedOn := True;
      break;
    end;

    // if we must be certificate user then stop the program
    if SameText(C2StrPrm(MainDm.C2UserName,'FMKCertifikatLogon','Ja'),'Ja') then
    begin
      ChkBoxOK('C2 bruger er ikke oprettet med certifikat');
      continue;
    end
    else
    begin
      StamPages.ActivePage := KartotekPage;
      LLoggedOn := True;
      break;
    end;

  end;

  CheckBatchLogon;
  if StamPages.ActivePage = KartotekPage then
  begin
    PostMessage(Handle, WM_SetButtons, 0, 0);
    PostMessage(EKundeNr.Handle, WM_SETFOCUS, 0, 0);
  end;



end;

procedure TStamForm.FormActivate(Sender: TObject);
begin
  c2logadd('StamForm activate in');
  try
    if not FirstTime then
      exit;

    if not MainDm.IsObjectValid then
    begin
      ChkBoxOK('Fejl i start ekspedition program');
      c2logadd('Fejl i start ekspedition program');
      Application.Terminate;
    end;

    c2logadd('*******************   SCREEN SIZE IS   ' + inttostr(Screen.Width)
      + '*' + inttostr(Screen.Height) + ' *******************');
    try
      c2logadd('StamForm activate check bruger');
      if MainDm.BrugerNr = 0 then
        PostMessage(StamForm.Handle, WM_SkiftBruger, 0, 0);
      EKundeNr.SetFocus;
      c2logadd('StamForm activate diverse');
      CallEnabled := True;
      FirstTime := False;
      dtpEhstart.Date := Now - 1;
      dtpEhSlut.Date := Now;
      ForceDirectories('C:\c2\temp\' + MainDm.C2UserName);
      if FileExists('C:\c2\temp\' + MainDm.C2UserName + '\dbgehord.dbg') then
        dbgEHOrd.Columns.LoadFromFile('C:\c2\temp\' + MainDm.C2UserName + '\dbgehord.dbg');

      UpdateStatusBrugerInfo;
      dxAlertWindowManager1.Tag := 0;
      c2logadd('StamForm activate alt er klar');
    except
      c2logadd('StamForm activate exception');
    end;
  finally
    c2logadd('StamForm activate out');
  end;
  TSplashScreen.UpdateActionText('MainForm klar');
end;

procedure TStamForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  try
    dbgEHOrd.Columns.SaveToFile('C:\c2\temp\' + MainDm.C2UserName + '\dbgehord.dbg');
//    replaced with formc2logon
//    if not Assigned(LogonForm) then
//      exit;
//    if LogonForm.Visible then
//    begin
//      // Sørg for at lukke logon formen
//      PostMessage(LogonForm.Handle, wm_Close, 0, 0);
//    end;
  finally
    CloseAtOnce := True;
    CanClose := True
  end;
end;

procedure TStamForm.AcHentFiktivExecute(Sender: TObject);
var
  LCtrFiktivId: string;
//  CtrRec: TCtrFiktiv;
begin
  with MainDm do
  begin
    if not ChkBoxYesNo('Skal der hentes fiktivt cprnr ?', True) then
      exit;
    if ffPatKar.State <> dsInsert then
    begin
      ChkBoxOK('Vælg opret og udfyld relevante felter !');
      exit;
    end;
    if not(EFiktiv.Checked) then
    begin
      ChkBoxOK('Fiktivt cprnr skal være markeret !');
      exit;
    end;
    if ffPatKarLandekode.Value = 0 then
    begin
      ChkBoxOK('Landekode skal være valgt !');
      exit;
    end;
    if ffPatKarFoedDato.AsString = '' then
    begin
      ChkBoxOK('Fødselsdato skal være indtastet !');
      exit;
    end;
    if not CheckFodDato(ffPatKarFoedDato.AsString) then
    begin
      ChkBoxOK('Fødselsdato er ikke korrekt !');
      exit;
    end;
    // Kald CTR
//    FillChar(CtrRec, sizeof(CtrRec), 0);
//    CtrRec.TimeOut := 20000;
//    CtrRec.Land := inttostr(ffPatKarLandekode.Value);
//    BusyMouseBegin;
//    try
//      if MidClient.CtrAdresse <> '' then
//      begin
//        MidClient.RecvCtrFiktiv(CtrRec);
//      end
//      else
//      begin
//        TastTekst('Enter fiktiv cpr nr.', CtrRec.CPRnr);
//        CtrRec.Status := 0;
//
//      end;
//
//    finally
//      BusyMouseEnd;
//    end;
//    if CtrRec.Status <> 0 then
//    begin
//      ChkBoxOK('Fiktivt cprnr ikke tildelt (mulig CTR fejl) !');
//      exit;
//    end;
    if not GetCtrFiktivId(ffPatKarLandekode.Value, LCtrFiktivId) then
      Exit;
    if ffPatKar.State <> dsInsert then
      exit;
    EBem.Lines.add('Fiktivt cprnr ' + LCtrFiktivId);
    EKundeNr.Text := LCtrFiktivId;
    ffPatKarKundeNr.AsString := LCtrFiktivId;
    ffPatKarLmsModtager.AsString := LCtrFiktivId;
    ffPatKar.Post;
    ffPatKar.Edit;
    ChkBoxOK('Fiktivt cprnr ' + LCtrFiktivId + ' er oprettet !');
    fmubi.UbiPrintFikt(ffPatKarKundeNr.AsString, ffPatKarFoedDato.AsString,
      ffPatKarNavn.AsString);
    fmubi.PrintTotalEtiket;
  end;
end;

procedure TStamForm.meSpcKomClick(Sender: TObject);
begin
  with MainDm do
  begin
    // Udfør kommuneafregning
    KommuneUdskrift;
  end;
end;

procedure TStamForm.ButUdCtrClick(Sender: TObject);
begin
  TfrmCTRUdskriv.CTRUdskriv;
end;

// not used by anything anymore since at the latest 2011
procedure TStamForm.AcRcpKontrolExecute(Sender: TObject);
//var
//  FraDato, TilDato: TDateTime;
//  PNr: Word;
//  RcpNr, DatoTa, DatoKo, DatoAf, BrTa, BrKo, BrAf, Tekst, Status: String;
//  RcpLst: TStringList;
//  SQL: TStringlist;
begin
//  with MainDm do
//  begin
//    if not ChkBoxYesNo('Skal receptkontrol liste udskrives ?', True) then
//      exit;
//    FraDato := FirstDayDate(Date);
//    TilDato := LastDayDate(Date);
//    if not TastDatoer('Tast ønsket datointerval !', FraDato, TilDato) then
//      exit;
//    BusyMouseBegin;
//    PNr := 0;
//    FraDato := Trunc(FraDato);
//    TilDato := Trunc(TilDato) + C2MaxTime;
//    RcpLst := TStringList.Create;
//    SQL := TStringList.Create;
//    try
//
//      SQL.clear;
//      SQL.Add('SELECT');
//      SQL.Add('  lbnr,');
//      SQL.Add(' kundenr ,');
//      SQL.Add('takserdato,');
//      SQL.Add(' kontroldato ,');
//      SQL.Add('afsluttetdato,');
//      SQL.Add('brugertakser ,');
//      SQL.Add(' brugerkontrol,');
//      SQL.Add('brugerafslut ,');
//      SQL.Add('kontrolfejl');
//      SQL.Add('FROM');
//      SQL.Add('  ekspeditioner');
//      SQL.Add('WHERE');
//      SQL.Add('  takserdato>=:startdate');
//      SQL.Add(' and  takserdato <=:slutdate');
//      SQL.Add(' and kontrolFejl >= 0');
//      SQL.Add('ORDER BY');
//      SQL.Add('  lbnr');
//      with nxdb.OpenQuery(SQL.Text,[FraDato,TilDato]) do
//      begin
//        if not Eof then
//        begin
//          First;
//          while not Eof do
//          begin
//            RcpNr := OutStr(inttostr(fieldbyname('RcpNr').AsInteger), 7);
//            DatoTa := Spaces(10);
//            DatoKo := Spaces(10);
//            DatoAf := Spaces(10);
//            if fieldbyname('DatoTa').AsDateTime <> 0 then
//              DatoTa := FormatDateTime('dd-mm-yyyy', fieldbyname('DatoTa')
//                .AsDateTime);
//            if fieldbyname('DatoKo').AsDateTime <> 0 then
//              DatoKo := FormatDateTime('dd-mm-yyyy', fieldbyname('DatoKo')
//                .AsDateTime);
//            if fieldbyname('DatoAf').AsDateTime <> 0 then
//              DatoAf := FormatDateTime('dd-mm-yyyy', fieldbyname('DatoAf')
//                .AsDateTime);
//            BrTa := '  ';
//            BrKo := '  ';
//            BrAf := '  ';
//            if Trim(DatoTa) <> '' then
//              BrTa := OutStr(inttostr(fieldbyname('BrugerTa').AsInteger), 2);
//            if Trim(DatoKo) <> '' then
//              BrKo := OutStr(inttostr(fieldbyname('BrugerKo').AsInteger), 2);
//            if Trim(DatoAf) <> '' then
//              BrAf := OutStr(inttostr(fieldbyname('BrugerAf')
//                .AsInteger), 2);
//            case fieldbyname('FejlNr').AsInteger of
//              0:
//                Tekst := '';
//              1:
//                Tekst := 'Anden fejl';
//              2:
//                Tekst := 'Fremtagningsfejl';
//              3:
//                Tekst := 'Taksationsfejl';
//              4:
//                Tekst := 'Stregkodefejl';
//            else
//              Tekst := 'Ukendt fejl';
//            end;
//            Status := '';
//            if fieldbyname('BrugerKo').AsInteger <> 0 then
//              Status := 'Kontrolleret';
//            if fieldbyname('BrugerAf').AsInteger <> 0 then
//              Status := 'Afsluttet';
//
//            if Status <> '' then
//              Tekst := Status + ' ' + Tekst;
//            RcpLst.add(RcpNr + ' ' + DatoTa + ' ' + BrTa + ' ' + DatoKo + ' ' + BrKo
//              + ' ' + DatoAf + ' ' + BrAf + ' ' + Tekst);
//            Next;
//          end;
//
//        end;
//
//        Free;
//      end;
//      RcpLst.Insert(0,
//        'Løbenr  Dato   Bruger Dato   Bruger Dato   Bruger Status                ');
//      RcpLst.Insert(0,
//        'Recept  Taksering---- Kontrol------ Afslutning---                             ');
//      RcpLst.Insert(0, 'Udskrevet for ' + FormatDateTime('dd-mm-yyyy', FraDato)
//        + ' - ' + FormatDateTime('dd-mm-yyyy', TilDato));
//      RcpLst.Insert(0, ffFirmaNavn.AsString);
//      RcpLst.Insert(0, 'R E C E P T K O N T R O L - L I S T E');
//      RcpLst.SaveToFile('C:\C2\Temp\RcpListe.Txt');
//      PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\RcpListe.Txt');
//    finally
//      SQL.Free;
//      RcpLst.Free;
//      BusyMouseEnd;
//    end;
//  end;
end;

procedure TStamForm.meAfslListeClick(Sender: TObject);
var
  PNr: Word;
  FraTid, TilTid, FraDato, TilDato: TDateTime;
  Pat, Til: Currency;
  Patient, Tilskud, Navn, Konto, CPRnr, LbNr, Dato: String;
  AfLst: TStringList;
begin
  with MainDm do
  begin
    if not ChkBoxYesNo('Skal afsluttet liste udskrives ?', True) then
      exit;
    PNr := 0;
    AfLst := TStringList.Create;
    try
      FraDato := Trunc(Date);
      TilDato := Trunc(Date);
      FraTid := 0;
      TilTid := C2MaxTime;
      if not TastDatoerTid('Tast ønsket dato/tid-interval !', FraDato, TilDato,
                    FraTid, TilTid) then
        exit;

      BusyMouseBegin;
      FraDato := Trunc(FraDato) + Frac(FraTid);
      TilDato := Trunc(TilDato) + Frac(TilTid);
      ffEksOvr.IndexName := 'DatoOrden';
      ffEksOvr.SetRange([FraDato], [TilDato]);
      ffEksOvr.Refresh;
      ffEksOvr.First;
      while not ffEksOvr.Eof do
      begin
        try
          if ffEksOvrOrdreStatus.Value <> 2 then
            Continue;
          if (ffEksOvrAfsluttetDato.AsDateTime < FraDato) or
            (ffEksOvrAfsluttetDato.AsDateTime > TilDato) then
            Continue;
          LbNr := format('%8d', [ffEksOvrLbNr.Value]);
          LbNr := LbNr + ' ';
          Dato := FormatDateTime('ddmmyy', ffEksOvrAfsluttetDato.AsDateTime);
          Navn := copy(Trim(ffEksOvrNavn.AsString), 1, 15);
          Navn := Navn + Spaces(15 - Length(Navn)) + ' ';
          CPRnr := ffEksOvrKundenr.AsString;
          CPRnr := CPRnr + Spaces(10 - Length(CPRnr)) + ' ';
          Konto := ffEksOvrKontoNr.AsString;
          Konto := Konto + Spaces(10 - Length(Konto));
          Til := Abs(ffEksOvrTilskAmt.AsCurrency) +
            Abs(ffEksOvrTilskKom.AsCurrency);
          Pat := Abs(ffEksOvrBrutto.AsCurrency) - Til;
          if ffEksOvrOrdreType.Value = 2 then
          begin
            Til := -Til;
            Pat := -Pat;
          end;
          Tilskud := FormCurr2Str('###,##0.00', Til);
          Patient := FormCurr2Str('###,##0.00', Pat);
          AfLst.add(Dato + LbNr + CPRnr + Navn + Konto + Tilskud + Patient);
        finally
          ffEksOvr.Next;
        end;
      end;
      AfLst.Insert(0,
        'Dato    Løbenr nr         Navn            nr         Instanser     Andel');
      AfLst.Insert(0,
        'Ekspeditionens Kunde                      Konto        Tilskud   Patient');
      AfLst.Insert(0, '');
      AfLst.Insert(0, ffFirmaNavn.AsString);
      AfLst.Insert(0, 'A F S L U T T E D E   E K S P E D I T I O N E R');
      AfLst.SaveToFile('C:\C2\Temp\AfListe.Txt');
      PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\AfListe.Txt');
    finally
      AfLst.Free;
      BusyMouseEnd;
    end;
  end;
end;

procedure TStamForm.ButUdTurLstClick(Sender: TObject);
var
  EkspTyp, FraTur, TilTur, PakAnt, Idx, Max, PNr: Word;
  Andel, Tilsk, Total: Currency;
  FraDato, TilDato: TDateTime;
  RcpKon, RecOk: Boolean;
  FraKonto, TilKonto, Konto, GemIdx, STotLin, SOpkrBel, SKont, SNavn, SLbNr,
    SFaktNr, SAdr, SPakkeNr: String;
  UdLst: TStringList;
  SQL: string;
  Copypakkenr: string;
  CopyAndel: Currency;
  CopyCount: Integer;
  UdskrivCount: Integer;
  KontoSl: TStringList;
  i: Integer;
  j: Integer;
  LevListeNr: Integer;
  FirstLine: Boolean;
  AfslutList: Boolean;
  Koel: Boolean;
  hkcnt : integer;
  procedure GetLeveringsListeNumber;
  begin
    with MainDm do
    begin
      ffRcpOpl.First;
      ffRcpOpl.Edit;
      ffRcpOplListeNr.AsInteger := ffRcpOplListeNr.AsInteger + 1;
      LevListeNr := ffRcpOplListeNr.AsInteger;
      ffRcpOpl.Post;

    end;

  end;

  procedure UpdateLeveringslisteNumber(ilbnr: Integer; Konto: string);
  begin
    with MainDm do
    begin
      nxEkspLevListe.Append;
      nxEkspLevListeListeNr.AsInteger := LevListeNr;
      nxEkspLevListeLbNr.AsInteger := ilbnr;
      nxEkspLevListeDato.AsDateTime := Now;
      nxEkspLevListeKonto.AsString := Konto;
      nxEkspLevListe.Post;

    end;
  end;




begin
  with MainDm do
  begin
    c2logadd('Leveringsliste start');
    FraKonto := edtNr.Text;
    TilKonto := edtNr.Text;
    FraDato := Date;
    TilDato := Now;
    FraTur := ffRcpOplTurNr.AsInteger;
    TilTur := FraTur;
    EkspTyp := 0;
    RcpKon := False;
    Koel := False;
    KontoSl := TStringList.Create;
    try
      if not UdskrivForsendelse(FraKonto, TilKonto, FraDato, TilDato, FraTur,
        TilTur, EkspTyp, RcpKon, UdskrivCount, AfslutList) then
        exit;

      KontoNrMinMax2(FraKonto, TilKonto, KontoSl);
      if KontoSl.Count = 0 then
      begin
        ChkBoxOK('Kontonumre ikke fundet');
        exit;
      end;
      for j := 0 to KontoSl.Count - 1 do
      begin
        Konto := KontoSl.Strings[j];
        // FraDato:= DateMinTime(FraDato);
        // TilDato:= DateMaxTime(TilDato);
        if not ffDebKar.FindKey([Konto]) then
        begin
          ChkBoxOK('Forsendelseskonto ' + Konto + ' findes ikke !');
          Continue;
        end;
        c2logadd('Leveringsliste parametre');
        c2logadd('  Konto: ' + Konto);
        c2logadd('  Fradato: ' + FormatDateTime('dd-mm-yyyy HH:mm', FraDato));
        c2logadd('  Fradato: ' + FormatDateTime('dd-mm-yyyy HH:mm', TilDato));
        c2logadd('  Fratur: ' + inttostr(FraTur));
        c2logadd('  Tiltur: ' + inttostr(TilTur));
        c2logadd('  Eksptype: ' + inttostr(EkspTyp));
        BusyMouseBegin;
        PNr := 0;
        UdLst := TStringList.Create;
        Total := 0;

        try
          SQL := sl_Sql_leveringliste.Text;
          fqLevList.Close;
          fqLevList.SQL.Text := SQL;
          fqLevList.ParamByName('konto').AsString := Konto;
          fqLevList.ParamByName('FraDato').AsString :=
            FormatDateTime('yyyy-mm-dd hh:mm:ss', FraDato);
          fqLevList.ParamByName('TilDato').AsString :=
            FormatDateTime('yyyy-mm-dd hh:mm:ss', TilDato);
          fqLevList.ParamByName('StartTur').AsInteger := FraTur;
          fqLevList.ParamByName('EndTur').AsInteger := TilTur;
          fqLevList.TimeOut := 100000;
          try
            fqLevList.Open;
          except
            on e: Exception do
              ChkBoxOK(e.Message);
          end;
          if fqLevList.RecordCount = 0 then
            Continue;

          // Gennemløb
          Copypakkenr := '';
          CopyAndel := 0;
          CopyCount := 0;
          PakAnt := 0;
          LevListeNr := 0;
          FirstLine := True;
          while not fqLevList.Eof do
          begin
            if (EkspTyp <> 0) and
              (fqLevList.fieldbyname('ordrestatus').AsInteger <> EkspTyp) then
            begin
              fqLevList.Next;
              Continue;
            end;

            if FindLevnr(fqLevList.fieldbyname('Lbnr').AsInteger) then
            begin
              fqLevList.Next;
              Continue;
            end;

            if AfslutList then
            begin
              if FirstLine then
                GetLeveringsListeNumber;
              FirstLine := False;

              UpdateLeveringslisteNumber(fqLevList.fieldbyname('Lbnr')
                .AsInteger, Konto);

            end;

            Koel := KoelProductOnEkspedition(fqLevList.fieldbyname('Lbnr').AsInteger);
            hkcnt := CountHandkoebLines(fqLevList.fieldbyname('Lbnr').AsInteger);
            SLbNr := format('%8d', [fqLevList.fieldbyname('Lbnr').AsInteger]);
            SFaktNr := format('%8d',
              [fqLevList.fieldbyname('Fakturanr').AsInteger]);
            SPakkeNr := format('%8d',
              [fqLevList.fieldbyname('Pakkenr').AsInteger]);
            SKont := ' **';
            if fqLevList.FieldByName('Eksptype').AsInteger = et_Dosispakning then
              SKont := '   ';
            if fqLevList.FieldByName('OrdreType').AsInteger = 2 then
              SKont := '   ';
            if (not AlleVnr) and (hkcnt <> 0) then
              SKont := '   ';
            if UdligningEkspedition(fqLevList.fieldbyname('Lbnr').AsInteger) then
              SKont := '   ';
            if NulPakkelistEkspedition(fqLevList.fieldbyname('Lbnr').AsInteger) then
              SKont := '   ';


            if fqLevList.fieldbyname('BrugerKontrol').Value > 0 then
              SKont := format('%3d',
                [fqLevList.fieldbyname('BrugerKontrol').AsInteger]);



            SNavn := Trim(fqLevList.fieldbyname('Navn').AsString);
            SNavn := SNavn + Spaces(34 - Length(SNavn));
            SAdr := Trim(fqLevList.fieldbyname('Address').AsString);
            Andel := fqLevList.fieldbyname('Andel').AsCurrency;
            if fqLevList.fieldbyname('Kontonr').AsString <> Konto then
              Andel := 0;
            if Andel < 0 then
              SKont := '   ';
            if fqLevList.fieldbyname('Eksptype').AsInteger = et_Dosispakning then
              SKont := ' D ';
            if fqLevList.fieldbyname('Eksptype').AsInteger = et_Haandkoeb then
              SKont := ' H ';

            Total := Total + Andel;
            SOpkrBel := FormCurr2Str(' ###,##0.00', Andel);
            if Copypakkenr <> '' then
            begin
              if Copypakkenr = SPakkeNr then
              begin
                CopyAndel := CopyAndel + Andel;
                CopyCount := CopyCount + 1;
              end
              else
              begin
                if CopyCount > 1 then
                begin
                  UdLst.add(Spaces(59) + '==========');
                  UdLst.add('Samlet beløb for pakkenr' + Spaces(18) +
                    Copypakkenr + Spaces(8) + FormCurr2Str(' ###,##0.00',
                    CopyAndel));
                  UdLst.add(Spaces(59) + '==========');

                end;
                CopyAndel := Andel;
                CopyCount := 1;
                PakAnt := PakAnt + 1;
              end;
            end;
            if Koel then
              UdLst.add(SNavn + SLbNr + SPakkeNr + SFaktNr + SOpkrBel + SKont +
                ' Køl ' + SAdr)
            else
              UdLst.add(SNavn + SLbNr + SPakkeNr + SFaktNr + SOpkrBel + SKont +
                '     ' + SAdr);
            if Copypakkenr = '' then
            begin
              CopyAndel := Andel;
              CopyCount := 1;
              PakAnt := 1;
            end;
            Copypakkenr := SPakkeNr;
            fqLevList.Next;
          end;
          if Copypakkenr <> '' then
          begin
            if CopyCount > 1 then
            begin
              UdLst.add(Spaces(59) + '==========');
              UdLst.add('Samlet beløb for pakkenr' + Spaces(18) + Copypakkenr +
                Spaces(8) + FormCurr2Str(' ###,##0.00', CopyAndel));
              UdLst.add(Spaces(59) + '==========');
            end;
          end;
          // Split navn og adresse linier
          repeat
            RecOk := False;
            Max := UdLst.Count - 1;
            for Idx := 0 to Max do
            begin
              SNavn := UdLst.Strings[Idx];
              if Length(SNavn) > 77 then
              begin
                SAdr := '  ' + copy(SNavn, 78, Length(SNavn) - 77);
                SNavn := copy(SNavn, 1, 77);
                UdLst.Strings[Idx] := SNavn;
                if Idx < Max then
                  UdLst.Insert(Idx + 1, SAdr)
                else
                  UdLst.add(SAdr);
                RecOk := True;
                break;
              end;
            end;
          until not RecOk;
          // Leveringsliste
          STotLin := 'Opkræves i alt for ' + inttostr(PakAnt) + ' pakker';
          STotLin := STotLin + Spaces(60 - Length(STotLin)) +
            FormCurr2Str('#,###,##0.00', Total);
          UdLst.add(FixStr('-', 72));
          UdLst.add(STotLin);
          UdLst.add(FixStr('=', 72));
          UdLst.Insert(0, '');
          UdLst.Insert(0,
            'Kundenavn & adresse                 Løbenr Pakkenr Fakt.nr      Beløb KB Køl');
          // UdLst.Insert(0, '         1         2         3         4         5         6         7;
          // UdLst.Insert(0, '123456789012345678901234567890123 xnnnnnnnxnnnnnnnxnnnnnnn nnn,nnn.nn nn;
          UdLst.Insert(0, '');
          UdLst.Insert(0, '             ' + ffDebKarPostNr.AsString + ' ' +
            ffDebKarBy.AsString);
          if Trim(ffDebKarAdr2.AsString) <> '' then
            UdLst.Insert(0, '             ' + ffDebKarAdr2.AsString);
          if Trim(ffDebKarAdr1.AsString) <> '' then
            UdLst.Insert(0, '             ' + ffDebKarAdr1.AsString);
          UdLst.Insert(0, '');
          UdLst.Insert(0, 'Leveres til: ' + Konto + ' ' +
            ffDebKarNavn.AsString);
          UdLst.Insert(0, '');
          UdLst.Insert(0, 'Listenr. ' + inttostr(LevListeNr));
          UdLst.Insert(0, '');
          UdLst.Insert(0, ffFirmaNavn.AsString);
          UdLst.Insert(0, 'L E V E R I N G S L I S T E');
          UdLst.SaveToFile('C:\C2\Temp\LevListe.Txt');
          if UdskrivCount = 0 then
            UdskrivCount := 1;
          for i := 1 to UdskrivCount do
          begin
            PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\LevListe.Txt');
          end;
        finally
          fqLevList.Close;
          UdLst.Free;
          BusyMouseEnd;
        end;
      end;
    finally
      KontoSl.Free;
      c2logadd('Leveringsliste slut');
    end;
  end;
end;

procedure TStamForm.ButUdPakLstClick(Sender: TObject);
var
  PakAnt, PNr: Word;
  Andel, Total: Currency;
  SavIdx, Konto, STotLin, SOpkrBel, SKont, SNavn, SLbNr, SPakkeNr: String;
  UdLst: TStringList;
begin
  with MainDm do
  begin
    Konto := ffEksOvrKontoNr.AsString;
    if not ChkBoxYesNo('Udskriv budliste for konto ' + Konto + ' ?', True) then
      exit;
    if not ffDebKar.FindKey([Konto]) then
    begin
      ChkBoxOK('Budkonto ' + Konto + ' findes ikke !');
      exit;
    end;
    BusyMouseBegin;
    PNr := 0;
    UdLst := TStringList.Create;
    Total := 0;
    PakAnt := 0;
    try
      // Budliste
      SavIdx := ffEksOvr.IndexName;
      ffEksOvr.IndexName := 'KontoNrOrden';
      ffEksOvr.SetRange([Konto, 1], [Konto, 1]);
      ffEksOvr.Refresh;
      ffEksOvr.First;
      while not ffEksOvr.Eof do
      begin
        if ffEksOvrOrdreStatus.Value <> 1 then
        begin
          ffEksOvr.Next;
          Continue;
        end;
        if ffEksOvrKontoNr.AsString <> Konto then
        begin
          ffEksOvr.Next;
          Continue;
        end;
        SLbNr := format('%8d', [ffEksOvrLbNr.Value]);
        SPakkeNr := format('%8d', [ffEksOvrPakkeNr.Value]);
        SKont := ' **';
        if ffEksOvrBrugerKontrol.Value > 0 then
          SKont := format('%3d', [ffEksOvrBrugerKontrol.Value]);
        SNavn := Trim(ffEksOvrNavn.AsString);
        SNavn := SNavn + Spaces(42 - Length(SNavn));
//        Tilsk := Abs(ffEksOvrTilskAmt.AsCurrency) +
//          Abs(ffEksOvrTilskKom.AsCurrency);
        Andel := Abs(ffEksOvrAndel.AsCurrency);
        Andel := Andel + Abs(ffEksOvrTlfGebyr.AsCurrency);
        Andel := Andel + Abs(ffEksOvrEdbGebyr.AsCurrency);
        Andel := Andel + Abs(ffEksOvrUdbrGebyr.AsCurrency);
        if ffEksOvrOrdreType.Value = 2 then
        begin
          Andel := -Andel;
          SKont := '   ';
        end;
        if ffEksOvrPakkeNr.AsInteger > 0 then
          Inc(PakAnt);
        Total := Total + Andel;
        SOpkrBel := FormCurr2Str(' ###,##0.00', Andel);
        UdLst.add(SNavn + SLbNr + SPakkeNr + SOpkrBel + SKont);
        ffEksOvr.Next;
      end;
      UdLst.Sort;
      // Budliste
      STotLin := 'Opkræves i alt for ' + inttostr(PakAnt) + ' pakker';
      STotLin := STotLin + Spaces(60 - Length(STotLin)) +
        FormCurr2Str('#,###,##0.00', Total);
      UdLst.add(FixStr('-', 72));
      UdLst.add(STotLin);
      UdLst.add(FixStr('=', 72));
      UdLst.Insert(0, '');
      UdLst.Insert(0,
        'Kundenavn                                   Løbenr Pakkenr      Beløb KB');
      // UdLst.Insert(0, '         1         2         3         4         5         6         7;
      // UdLst.Insert(0, '123456789012345678901234567890123 xnnnnnnnxnnnnnnnxnnnnnnn nnn,nnn.nn nn;
      UdLst.Insert(0, '');
      UdLst.Insert(0, '             ' + ffDebKarPostNr.AsString + ' ' +
        ffDebKarBy.AsString);
      if Trim(ffDebKarAdr2.AsString) <> '' then
        UdLst.Insert(0, '             ' + ffDebKarAdr2.AsString);
      if Trim(ffDebKarAdr1.AsString) <> '' then
        UdLst.Insert(0, '             ' + ffDebKarAdr1.AsString);
      UdLst.Insert(0, '');
      UdLst.Insert(0, 'Leveres til: ' + Konto + ' ' + ffDebKarNavn.AsString);
      UdLst.Insert(0, '');
      UdLst.Insert(0, '');
      UdLst.Insert(0, '');
      UdLst.Insert(0, ffFirmaNavn.AsString);
      UdLst.Insert(0, 'L E V E R I N G S L I S T E');
      UdLst.SaveToFile('C:\C2\Temp\LevListe.Txt');
      PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\LevListe.Txt');
    finally
      UdLst.Free;
      ffEksOvr.IndexName := SavIdx;
      BusyMouseEnd;
    end;
  end;
end;

procedure TStamForm.ButKonPrisClick(Sender: TObject);
var
  Vent: Boolean;
  VSub, VTxt, VPkn, Pris: String;
begin
  with MainDm, MainLOg, fmubi do
  begin
    if not Assigned(HkbMrkLst) then
      exit;
    // Prismærke til UBI
    if ChkBoxYesNo('Ønskes prøvetryk?', True) then
    begin
      PrintHkbEtik(ffFirmaNavn.AsString, 'Dato ' + FormatDateTime('dd-mm-yyyy',
        Date), 'Pris 111,22', 'Varenr 111111', 'Tekst på vare', '5', False);
      PrintTotalEtiket;
    end;

    Vent := ChkBoxYesNo('Udskriv alle prisetiketter?', True);
    PrintHkbEtik('', '', 'LØBENR ' + ffEksOvrLbNr.AsString, 'START', '',
      '1', True);
    ffLinOvr.First;
    while not ffLinOvr.Eof do
    begin
      VSub := ffLinOvrSubVareNr.AsString;
      VPkn := Trim(copy(ffLinOvrPakning.AsString, 1, 3));
      VTxt := Trim(copy(ffLinOvrTekst.AsString, 1, 20 - Length(VPkn)));
      VTxt := VTxt + ' ' + VPkn;
      Pris := FormatCurr('###,##0.00', ffLinOvrPris.AsCurrency);
      // 484 confirm print of each label.
      if not Vent then
      begin
        if not ChkBoxYesNo('Skal der udskrives prisetiket til: ' + VSub + ' ' +
          VTxt + '?', False) then
        begin
          ffLinOvr.Next;
          Continue;
        end;
      end;

      PrintHkbEtik(ffFirmaNavn.AsString, 'Dato ' + FormatDateTime('dd-mm-yyyy',
        ffEksOvrOrdreDato.AsDateTime), 'Pris ' + Pris, 'Varenr ' + VSub, VTxt,
        ffLinOvrAntal.AsString, False);
      ffLinOvr.Next;
    end;
    PrintHkbEtik('', '', 'LØBENR ' + ffEksOvrLbNr.AsString, 'SLUT', '',
      '1', True);
    PrintTotalEtiket;
  end;
end;

procedure TStamForm.meDosListeClick(Sender: TObject);
var
  Kode, Tekst: String;
  PNr: Word;
  UdLst: TStringList;
begin
  with MainDm do
  begin
    if not ChkBoxYesNo('Udskriv doseringsliste ?', True) then
      exit;
    Screen.Cursor := crHourGlass;
    PNr := 0;
    UdLst := TStringList.Create;
    try
      ffDosTxt.First;
      while not ffDosTxt.Eof do
      begin
        Kode := copy(ffDosTxtKode.AsString, 1, 12);
        if Length(Kode) < 12 then
          Kode := Kode + Spaces(12 - Length(Kode));
        Tekst := ffDosTxtTekst1.AsString;
        UdLst.add(Kode + Tekst);
        ffDosTxt.Next;
      end;
      UdLst.Insert(0, '');
      UdLst.Insert(0, '');
      UdLst.Insert(0, 'Kode        Tekst');
      UdLst.Insert(0, ffFirmaNavn.AsString);
      UdLst.Insert(0, 'D O S E R I N G S L I S T E');
      UdLst.SaveToFile('C:\C2\Temp\DosListe.Txt');
      PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\DosListe.Txt');
    finally
      UdLst.Free;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TStamForm.meNarkoListeClick(Sender: TObject);
var
  PNr: Word;
  FraDato, TilDato: TDateTime;
  IdxName, WrkLin, WrkStr: String;
  UafLst: TStringList;
begin
  with MainDm do
  begin
    if not ChkBoxYesNo('Skal uafsluttet narkoliste udskrives ?', True) then
      exit;
    IdxName := ffAfrEks.IndexName;
    UafLst := TStringList.Create;
    try
      FraDato := FirstDayDate(Date);
      TilDato := LastDayDate(Date);
      if not TastDatoer('Tast ønsket datointerval !', FraDato, TilDato) then
        exit;

      Screen.Cursor := crHourGlass;
      PNr := 0;
      FraDato := Trunc(FraDato);
      TilDato := Trunc(TilDato) + C2MaxTime;
      ffAfrEks.IndexName := 'StatusOrden';
      ffAfrEks.SetRange([1, 1], [1, High(LongInt)]);
      ffAfrEks.Refresh;
      ffAfrEks.First;
      while not ffAfrEks.Eof do
      begin
        if ffAfrEksOrdreStatus.Value <> 1 then
        begin
          ffAfrEks.Next;
          Continue;
        end;
        if (ffAfrEksTakserDato.AsDateTime < FraDato) or
          (ffAfrEksTakserDato.AsDateTime > TilDato) then
        begin
          ffAfrEks.Next;
          Continue;
        end;
        ffAfrLin.Last;
        while not ffAfrLin.Bof do
        begin
          if pos('P4', ffEksLinUdlevType.AsString) = 0 then
          begin
            ffAfrLin.Prior;
            Continue;
          end;
          WrkLin := '';
          WrkStr := Trim(ffAfrLinTekst.AsString) + ' ' +
            Trim(ffAfrLinForm.AsString) + ' ' + Trim(ffAfrLinStyrke.AsString) +
            ' ' + Trim(ffAfrLinPakning.AsString) + ' ' +
            Trim(ffAfrLinSubVareNr.AsString);
          if Length(WrkStr) > 70 then
            WrkStr := copy(WrkStr, 1, 70);
          if Length(WrkStr) < 70 then
            WrkStr := WrkStr + Spaces(70 - Length(WrkStr));
          WrkLin := WrkLin + ' ' + WrkStr;
          WrkStr := FormatDateTime('dd-mm-yyyy', ffAfrEksTakserDato.AsDateTime);
          WrkLin := WrkLin + ' ' + WrkStr;
          WrkStr := format('%8d', [ffAfrEksLbNr.Value]);
          WrkLin := WrkLin + ' ' + WrkStr;
          WrkStr := format('%3d', [ffafrlinlinienr.Value]);
          WrkLin := WrkLin + ' ' + WrkStr;
          WrkStr := format('%1d', [ffAfrLinAntal.Value]);
          if ffEksOvrOrdreType.Value = 2 then
            WrkStr := '-' + WrkStr;
          if Length(WrkStr) < 4 then
            WrkStr := Spaces(4 - Length(WrkStr)) + WrkStr;
          WrkLin := WrkLin + ' ' + WrkStr;
          // Str (ffAfrLinAntal.Value:3, Antal);
          ffAfrLin.Prior;
        end;
        ffEksOvr.Next;
      end;
      UafLst.Insert(0, '');
      UafLst.Insert(0, '');
      UafLst.Insert(0, 'Udskrevet for perioden' + ' fra ' +
        FormatDateTime('dd-mm-yyyy', FraDato) + ' til ' +
        FormatDateTime('dd-mm-yyyy', TilDato));
      UafLst.Insert(0, ffFirmaNavn.AsString);
      UafLst.Insert(0, 'U A F S L U T T E T   N A R K O L I S T E');
      UafLst.SaveToFile('C:\C2\Temp\NarkoListe.Txt');
      PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\NarkoListe.Txt');
    finally
      UafLst.Free;
      ffAfrEks.IndexName := IdxName;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TStamForm.acTilskudEankodeExecute(Sender: TObject);
begin
  KmLst;
end;

procedure TStamForm.acTilskudRegelExecute(Sender: TObject);
begin
  ReLst;
end;

procedure TStamForm.acTilskudVareExecute(Sender: TObject);
begin
  VmLst;
end;

procedure TStamForm.acFkeysGemExecute(Sender: TObject);
begin
  if KartotekPage.Visible then
    StamF5Handler;
  if TilskudsPage.Visible then
  TilF5Handler;

end;

procedure TStamForm.acFkeysGemUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := C2ButF5.Enabled;
end;

procedure TStamForm.acAltDownExecute(Sender: TObject);
begin
  c2logadd('alt down pressed');
  if ActiveControl = EPostNr then
  begin
    PnLst;
    exit;
  end;
  if ActiveControl = EKundeNr then
  begin
    PaLst;
    exit;
  end;
  if ActiveControl = ENavn then
  begin
    PaLst;
    exit;
  end;
  if ActiveControl = EDebNr then
  begin
    DeLst;
    exit;
  end;
  if ActiveControl = ELevNr then
  begin
    LeLst;
    exit;
  end;
  if ActiveControl = EKommune then
  begin
    InLst;
    exit;
  end;
  if ActiveControl = EYderNr then
  begin
    YdLst;
    exit;
  end;
  if ActiveControl = EYderCprNr then
  begin
    YdCprLst;
    exit;
  end;
  if ActiveControl = TilERegel then
  begin
    ReLst;
    exit;
  end;
  if ActiveControl = TilAtcKode then
  begin
    VmLst;
    exit;
  end;
  if ActiveControl = TilVarenr then
  begin
    VmLst;
    exit;
  end;
  if ActiveControl = TilEanKode then
  begin
    KmLst;
    exit;
  end;
  if ActiveControl = TilProdukt then
  begin
    VmLst;
    exit;
  end;
end;

procedure TStamForm.AcOpdCtrSaldoExecute(Sender: TObject);
var
  Bag: Boolean;
  PatNr: LongWord;
  save_index: string;
begin
  with MainDm do
  begin
    if not ChkBoxYesNo('Skal lokale CTR saldi opdateres ?', True) then
      exit;

    BusyMouseBegin;
    try
      save_index := SaveAndAdjustIndexName(nxCTRinf, 'KundeNrOrden');
      PatNr := 0;
      Bag := not ChkBoxYesNo('Skal der startes forfra ?', True);
      if Bag then
      begin
        ffPatUpd.Last;
        while not ffPatUpd.Bof do
        begin
          if not ffPatUpdEjCtrReg.AsBoolean then
          begin

            if ffPatUpdKundeType.Value = 1 then
            begin
              if not nxCTRinf.FindKey([ffPatUpdKundeNr.AsString]) then
              begin
                c2logadd('Starting c2getctr ' + ffPatUpdKundeNr.AsString);
                // frmDSFile.AddCPrToCTRQ(ffPatUpdKundeNr.AsString,C2ServerAdresse);
                C2ExecuteCS(ProgramFolder + 'C2GetCtr.exe ' +
                  ffPatUpdKundeNr.AsString, SW_HIDE, -1);
              end;
            end;
          end;
          ffPatUpd.Prior;
          Inc(PatNr);
          if PatNr mod 10 = 0 then
          begin
            C2StatusBar.Panels[2].Text := ' Behandlet ' + inttostr(PatNr) +
              ' patienter';
            C2StatusBar.Update;
          end;
          Application.ProcessMessages;
          if CloseAtOnce then
            break;
        end;
        exit;
      end;

      ffPatUpd.First;
      while not ffPatUpd.Eof do
      begin
        if not ffPatUpdEjCtrReg.AsBoolean then
        begin
          if ffPatUpdKundeType.Value = 1 then
          begin
            if not nxCTRinf.FindKey([ffPatUpdKundeNr.AsString]) then
            begin
              c2logadd('Starting c2getctr ' + ffPatUpdKundeNr.AsString);
              // frmDSFile.AddCPrToCTRQ(ffPatUpdKundeNr.AsString,C2ServerAdresse);
              // sleep(10);
              C2ExecuteCS(ProgramFolder + 'C2GetCtr.exe ' +
                ffPatUpdKundeNr.AsString, SW_HIDE, -1);
            end;
          end;
        end;
        ffPatUpd.Next;
        Inc(PatNr);
        if PatNr mod 10 = 0 then
        begin
          C2StatusBar.Panels[2].Text := ' Behandlet ' + inttostr(PatNr) +
            ' patienter';
          C2StatusBar.Update;
        end;
        Application.ProcessMessages;
        if CloseAtOnce then
          break;
      end;
    finally
      nxCTRinf.IndexName := save_index;
      BusyMouseEnd;
    end;
  end;
end;

procedure TStamForm.acFkeysOpretExecute(Sender: TObject);
begin
  StamF7Handler;

end;

procedure TStamForm.acFkeysOpretUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := C2ButF7.Enabled;
end;

procedure TStamForm.AcHentCtrStatusExecute(Sender: TObject);
begin
  GetCTR(MainDm.ffPatKarKundeNr.AsString);
end;

procedure TStamForm.AcAktiverCtrExecute(Sender: TObject);
begin
  with MidClient do
  begin
    if CtrAktiv then
      CtrAktiv := not ChkBoxYesNo('CTR er aktiveret, deaktiver ?', True)
    else
      CtrAktiv := ChkBoxYesNo('CTR er deaktiveret, aktiver ?', True);
  end;
end;

procedure TStamForm.acReportDesignerExecute(Sender: TObject);
begin
  with dmFormularer do
  begin
    if not odRave.Execute then
      exit;
    try
      try
        rpProjekt.ProjectFile := odRave.FileName;
        rpProjekt.Open;
        rpProjekt.Design;
        rpProjekt.Save;
      except
        on e: Exception do
          ChkBoxOK(e.Message);
      end;
    finally
      rpProjekt.Close;
    end;
  end;
end;

procedure TStamForm.acFkeysRetExecute(Sender: TObject);
begin
  StamF6Handler;
end;

procedure TStamForm.acFkeysRetUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := C2ButF6.Enabled;
end;

procedure TStamForm.AcInterAktExecute(Sender: TObject);
begin
  MainDm.ffIntAkt.First;
  TfmInteraktion.VisIntTekst(1, '');
end;

procedure TStamForm.acSendSMSExecute(Sender: TObject);
begin
  with MainDm do
  begin
    try
      if not SMSAktiv then
        exit;
      if ffPatKarMobil.AsString = '' then
        exit;
      TfrmSendSMS.SendSMS(SMSServer, ffPatKarKundeNr.AsString,
        ffPatKarNavn.AsString, ffPatKarMobil.AsString);
    finally
      EKundeNr.SetFocus;
    end;
  end;

end;

procedure TStamForm.acSidKundeNrExecute(Sender: TObject);
begin
  C2LogAdd('Ctrl-k last kundenr pressed ' + SidKundeNr);
  if StamPages.ActivePage = KartotekPage then
  begin
    EKundeNr.Text := SidKundeNr;
    c2logadd('16: sidkundenr ' + SidKundeNr);
    EKundeNr.SelectAll;
    EKundeNr.SetFocus;
  end;
  if StamPages.ActivePage = RSRemotePage then
  begin
    edtCprNr.Text := SidKundeNr;
    c2logadd('17: sidkundenr ' + SidKundeNr);
    edtCprNr.SelectAll;
    edtCprNr.SetFocus;
  end;

  if StamPages.ActivePage = RSLocalPage then
  begin
    edtCPRNr1.Text := SidKundeNr;
    c2logadd('18: sidkundenr ' + SidKundeNr);
    edtCPRNr1.SelectAll;
    edtCPRNr1.SetFocus;
  end;
end;

procedure TStamForm.acSletButtonExecute(Sender: TObject);
begin
  StamF8Handler;

end;

procedure TStamForm.acSletButtonUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := C2ButF8.Enabled;
end;

procedure TStamForm.acFkeysSletExecute(Sender: TObject);
begin
  if SameText(C2StrPrm('Generelt', 'STDsetup', 'Nej'), 'JA') then
    exit;

  StamF8Handler;
end;

procedure TStamForm.acFkeysSletUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := C2ButF8.Enabled;
end;

procedure TStamForm.AcHentDeltaExecute(Sender: TObject);
var
  CtrData: String;
begin
  if not ChkBoxYesNo('Hent deltafil på cprnr ?', True) then
    exit;
  CtrData := MainDm.ffPatKarKundeNr.AsString;
  MidClient.RecvCtrDelta(CtrData);
  if CtrData <> MainDm.ffPatKarKundeNr.AsString then
    ChkBoxOK('Data "' + CtrData + '"')
  else
    ChkBoxOK('patient findes ikke i deltafil!');
end;

procedure TStamForm.CtrTimerTimer(Sender: TObject);
var
  (*
    ClkNow,
    ClkRcp: TTimeStamp;
    CtrSec,
  *)
  CtrCnt: Integer;
  ErrStr: String;
  LQry : TnxQuery;
begin
  with MainDm do
  begin
    CtrTimer.Enabled := False;
    try

      if not MidClient.CtrAktiv then
        exit;

      if C2IntPrm(MainDm.C2UserName, 'Kasse', 0) = 0 then
      begin
        if dxAlertWindowManager1.Tag = 0 then
        begin
          dxAlertWindowManager1.Tag := 1; // show message 1 time only
          if AlertRSFejlwin <> Nil then
          begin
            if AlertRSFejlwin.Visible then
              dxAlertWindowManager1.Close(AlertRSFejlwin);
          end;

          // count how many recods are in RS_EkspQueueFejl

          try
            LQry := nxdb.OpenQuery('SELECT count (*) as icnt FROM RS_EkspQueueFejl',[]);
            try
              if not LQry.Eof  then
              begin

                if LQry.FieldByName('icnt').AsInteger > 5 then
                begin
                  ChkBoxOK('Der er ' + LQry.FieldByName('icnt').AsString + ' FMK fejl. Tjek liste i Ekspeditionsprogram / Menu');
                end;

              end;
            finally
              LQry.Free;
            end;
          except
            on e : Exception do
              C2LogAdd('Fejl i RS_EkspQueueFejl check ' + e.Message);

          end;

        end;
      end;
      CtrCnt := ffCtrOpd.RecordCount;
      if CtrCnt > 0 then
      begin
        ErrStr := inttostr(ffCtrOpd.RecordCount) + ' CTR rcp';
        ffCtrOpd.Last;
        if ffCtrOpdStatus.AsInteger > 0 then
          ErrStr := ErrStr + ' FEJL';
        (*
          CtrSec:= 0;
          ClkRcp:= DateTimeToTimeStamp(ffCtrOpdDato.AsDateTime);
          ClkNow:= DateTimeToTimeStamp(Now);
          CtrSec:= ClkNow.Time - ClkRcp.Time;
        *)
        // Vis CTR i statusbar
        C2StatusBar.Panels[3].Text := ErrStr;
        Beep;
        exit;
      end;

      if nxRSQueue.RecordCount > 200 then
      begin
//        C2StatusBar.Panels[3].Text := 'Kø i RSQueue. Ring Cito';

      end
      else
      begin
        // Blank tekst
        if pos('Åben ekspedition', C2StatusBar.Panels[2].Text) = 0 then
          C2StatusBar.Panels[3].Text := '';

      end;

    finally
      CtrTimer.Interval := 180000;
      CtrTimer.Enabled := True;
    end;
  end;
end;

procedure TStamForm.cxGridDDCardsTableView1CustomDrawCell(Sender: TcxCustomGridTableView;
  ACanvas: TcxCanvas; AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
begin
  if AViewInfo.GridRecord.Values[3] = 'True' then
    ACanvas.Brush.Color := clLtGray;

end;

procedure TStamForm.AcRetLagerExecute(Sender: TObject);
var
  ResVal: Integer;
  LbNr: LongWord;
begin
  LbNr := MainDm.ffEksOvrLbNr.AsInteger;
  c2logadd('Ret Lager called');
  if not ChkBoxYesNo('Opdater lager på løbenr ' + inttostr(LbNr) + '?', False) then
    exit;
  // Der opdateres IKKE lager ved dosispakning (EkspType = 7)
  if MainDm.ffEksOvrEkspType.Value = et_Dosispakning then
    exit;
  // Windows lager
  c2logadd('OpdatLagerEksp being called from RetLagerExecute');
  ResVal := MidClient.OpdatLagerEksp(LbNr);
  if ResVal > 0 then
    ChkBoxOK('Fejl i AppServer lager, kode ' + inttostr(ResVal));
end;

procedure TStamForm.MenuAfstempClick(Sender: TObject);
var
  Item: Word;
  LbNr: LongWord;
begin
  PrintAllAFSLabel := False;
  // Søg et recept løbenummer, pakkenummer eller fakturanr
  if not TSoegRcpForm.SoegRcpt(Item, LbNr) then
    exit;

  if (Item = 0) and (LbNr > 0) then
  begin
    AfslLbNr := LbNr;
    UbiAfstempling(False, False);
    fmubi.PrintTotalEtiket;
  end;

end;

procedure TStamForm.btnPrintClick(Sender: TObject);
begin
  RCPMidCli.SendRequest('GetAddressed', ['40', MainDm.nxOrdC2Nr.AsString, MainDm.C2UserName], 10);

end;

procedure TStamForm.btnFakLevNrClick(Sender: TObject);
// DebitorRec : TDebitorRec;
begin
  with MainDm do
  begin
    if Trim(edtFakLevNr.Text) = '' then
    begin
      // Fjern levnr
      if Trim(ffEksOvrLevNavn.AsString) = '' then
        exit;

      if not ChkBoxYesNo('Ekspedition fjernes fra levnr ' +
        ffEksOvrLevNavn.AsString, True) then
        exit;
      ffEksOvr.Edit;
      ffEksOvrLevNavn.AsString := '';
      ffEksOvr.Post;
      ffEksOvr.Refresh;
      nxEkspLevListe.IndexName := 'LbnrOrden';
      if nxEkspLevListe.FindKey([ffEksOvrLbNr.AsInteger]) then
        nxEkspLevListe.Delete;
      exit;
    end;
    // Ret lev nr
    if not ChkBoxYesNo('Lev.nr rettes fra ' + ffEksOvrLevNavn.AsString + ' til '
      + Trim(edtFakLevNr.Text), True) then
      exit;
    try
      ffEksOvr.Edit;
      ffEksOvrLevNavn.AsString := edtFakLevNr.Text;
      ffEksOvr.Post;
      ffEksOvr.Refresh;
      nxEkspLevListe.IndexName := 'LbnrOrden';
      if nxEkspLevListe.FindKey([ffEksOvrLbNr.AsInteger]) then
        nxEkspLevListe.Delete;
      CheckFor0Ekspedition(edtFakLevNr.Text);
    except
      if ffEksOvr.State <> dsBrowse then
        ffEksOvr.Cancel;
      if ffRcpOpl.State <> dsBrowse then
        ffRcpOpl.Cancel;
      ChkBoxOK('lev.nr kunne ikke rettes !');
    end;
  end;

end;

procedure TStamForm.btnFilterClick(Sender: TObject);
begin
  MainDm.nxOrd.Filtered := not MainDm.nxOrd.Filtered;
  if MainDm.nxOrd.Filtered then
    btnFilter.Caption := 'Fjern filter'
  else
    btnFilter.Caption := 'Filter';

end;

procedure TStamForm.KonvRSEksp(aReceptId: LongWord; TabSheet: TcxTabSheet;
  ABarcodeScanned: Boolean = False; AKundenr: string = ''; APromptUserWhenDDCardExists: Boolean = True);
var
  EdiRcp: TEdiRcp;
  SaveIndex: string;
  EkspCompleted: Boolean;
  AskNBSQuestion: Boolean;
  Frigiv: Boolean;
  AllFrigiv: Boolean;
  DosisLine: Boolean;
  ValidOrdIdList: TStringList;
  RefreshSql: string;
  LKundenr: string;
  LSetInProgress: Boolean;
  LInvalidOrdlist: TStringList;
  LSenderTypeIsSOR: Boolean;
  LQry : TnxQuery;

  procedure UpdateRSEkspeditionerReceptStatus(Receptid: Integer);
  var
    save_index: string;
    save_pat_index: string;
  begin
    with MainDm do
    begin

      save_pat_index := SaveAndAdjustIndexName(ffPatUpd, 'NrOrden');
      try
        if not ffPatUpd.FindKey([nxRSEkspPatCPR.AsString]) then
          exit;

      finally
        ffPatUpd.IndexName := 'NrOrden';
      end;
      save_index := SaveAndAdjustIndexName(nxRSEksp, 'ReceptIdOrder');
      try
        if nxRSEksp.FindKey([Receptid]) then
        begin
          if nxRSEkspReceptStatus.AsInteger < 90 then
          begin
            nxRSEksp.Edit;
            nxRSEkspReceptStatus.AsInteger := nxRSEkspReceptStatus.AsInteger + 90;
            nxRSEksp.Post;
          end;
        end;

      finally
        nxRSEksp.IndexName := save_index;
      end;
    end;

  end;

  procedure RemoveStatusFromValidOrd(AValidOrdIdList: TStringList);
  var
    LOrdid: string;
    LPrescriptionIdentifier: Int64;
    LSaveIndex: string;
    LDBParam : TnxDatabase;
  begin
    for LOrdid in AValidOrdIdList do
    begin
      LPrescriptionIdentifier := StrToInt64Def(LOrdid, -1);
      if LPrescriptionIdentifier = -1 then
        continue;

      LSaveIndex := SaveAndAdjustIndexName(MainDm.nxRSEkspLin, 'OrdidOrden');
      try
        if not MainDm.nxRSEkspLin.FindKey([LOrdid, aReceptId]) then
          continue;

        if MainDm.KeepReceptLokalt then
          LDBParam := nil
        else
          LDBParam := maindm.nxdb;

        if uFMKCalls.FMKRemoveStatus(MainDm.AfdNr, MainDm.ffPatKarKundeNr.AsString,
            { TODO : 03-06-2021/MA: Replace with real PersonIdSource }
          TFMKPersonIdentifierSource.DetectSource(MainDm.ffPatKarKundeNr.AsString), MainDm.nxRSEkspLinReceptId.AsInteger,
            MainDm.nxRSEkspLinPrescriptionIdentifier.AsLargeInt, MainDm.nxRSEkspLinAdministrationId.AsLargeInt, LDBParam) then
        begin
          c2logadd('remove status on Administration successful');

        end;
      finally
        MainDm.nxRSEkspLin.IndexName := LSaveIndex;
      end;

    end;

  end;

begin

  with MainDm do
  begin
    c2logadd('Top of konvrseksp');
    C2LogAdd('Prompt user when DD-card exists=' + BoolToStr(APromptUserWhenDDCardExists, True));
    // does the user still have a certificate before we call fmk routines
    if not maindm.CheckFMKCertificate then
      exit;
    UpdateStatusBrugerInfo;
    ValidOrdIdList := TStringList.Create;
    LInvalidOrdlist := TStringList.Create;
    KonvRSEkspBusy := True;

    try
      LSetInProgress := True;
      RCPTakserCompleted := False;
      // first check the prescription exists in RS tables
      nxRSEksp.IndexName := 'ReceptIdOrder';
      if not nxRSEksp.FindKey([aReceptId]) then
      begin
        if ABarcodeScanned then
          ChkBoxOK('Receptbestillingen eksisterer ikke længere i Lokale Recepter [CF6]'
            + sLineBreak + 'Tjek [CF6] for evt. nyere bestilling');

        exit;
      end;
      if nxRSEkspPatCPR.AsString.IsEmpty and AKundenr.IsEmpty then
      begin
        if pos('PersonID:', nxRSEkspLeveringsInfo.AsString) = 0 then
        begin
          ChkBoxOK('Ordinationen har ikke cprnr, så takser den manuelt og afslut den på FMK.');
          exit;
        end;
      end;

      // If a kundenr is passed in the call hen use that instead of the kundenr
      // in the RS_Ekspeditioner record
      if not AKundenr.IsEmpty then
      begin
        if not ffPatKar.FindKey([AKundenr]) then
          LSetInProgress := False;

        if not GetCTR(AKundenr) then
          Exit;
        LKundenr := AKundenr;
      end
      else
      begin

        if not ffPatKar.FindKey([nxRSEkspPatCPR.AsString]) then
          LSetInProgress := False;

        if not GetCTR(nxRSEkspPatCPR.AsString) then
          Exit;
        LKundenr := nxRSEkspPatCPR.AsString;
      end;
      // store thr kundenr for the ctrl-k buffer
      SidKundeNr := LKundenr;

      // if asylansoger then set the medication in progress

      if pos('PersonID', nxRSEkspLeveringsInfo.AsString) <> 0 then
        LSetInProgress := True;

      // warn if there is a dosis transaction before start to get everything
      // under behandling
      if LKundenr.IsEmpty then
      begin
        { TODO : 05-05-2021/MA: This part does not make sense to me. 1: DosisLine isn't set at this point. 2: Dosis are not allowed to be takseret in Pat.kar }
//        if DosisLine then
//        begin
//
//          if not ChkBoxYesNo('En eller flere ordinationer skal dosispakkes.' +
//            sLineBreak + 'Vil du fortsætte taksering?', False) then
//            exit;
//        end;

      end
      else
      begin
        if APromptUserWhenDDCardExists and
           (not TfrmDosiskort.ShowDoskort(LKundenr, TFMKPersonIdentifierSource.DetectSource(LKundenr))) then
          exit
        else
        begin
          if PatientDosisCards.Count = 0 then
          begin
            { TODO : 05-05-2021/MA: This part does not make sense to me. 1: DosisLine isn't set at this point. 2: Dosis are not allowed to be takseret in Pat.kar }
//            if DosisLine then
//            begin
//
//              if not ChkBoxYesNo('En eller flere ordinationer skal dosispakkes.'
//                + sLineBreak + 'Vil du fortsætte taksering?', False) then
//                exit;
//            end;
          end;
        end;
      end;

      // next check each line. if all are completed then messagebox
      c2logadd('check if all ordinations are complete');
      EkspCompleted := False;
      if nxRSEkspLbNr.AsInteger <> 0 then
      begin
        EkspCompleted := True;
        SaveIndex := nxRSEkspLin.IndexName;
        nxRSEkspLin.IndexName := 'ReceptIDOrder';
        nxRSEkspLin.SetRange([aReceptId], [aReceptId]);
        try
          nxRSEkspLin.First;
          while not nxRSEkspLin.Eof do
          begin
            if nxRSEkspLinRSLbnr.AsInteger = 0 then
              EkspCompleted := False;

            nxRSEkspLin.Next;
          end;

        finally
          nxRSEkspLin.CancelRange;
          nxRSEkspLin.IndexName := SaveIndex;

        end;

      end;

      if EkspCompleted then
      begin
        ChkBoxOK('Recepten er allerede ekspederet.' + sLineBreak +
          'Hent ordinationen i CF5.');
        exit;
      end;

      Frigiv := False;
      AllFrigiv := True;
      DosisLine := False;
      c2logadd('Refresh the ordinations from the receptserver');

      // Old code to be replaced by a new sql that will stop issue with the
      // current cursor in nxREksplin being trashed by othe other procedure
      // such as viewing a prescription whilst waiting for the answer from receptserver

      // SaveIndex := nxRSEkspLin.IndexName;
      // nxRSEkspLin.IndexName := 'ReceptIDOrder';
      // nxRSEkspLin.SetRange([aReceptId], [aReceptId]);
      // try
      // nxRSEkspLin.First;
      // while not nxRSEkspLin.Eof do
      // begin
      // // skip any ordinations that appear to have been done. fixes the issue
      // // where ordinations are left under behandling on the receptserver
      // if nxRSEkspLinRSLbnr.AsInteger <> 0 then
      // begin
      // nxRSEkspLin.Next;
      // continue;
      // end;
      //
      // if DMRSGetMeds.RefreshReceivedMedications(nxRSEkspLinOrdId.AsString,
      // AfdNr) then
      // ValidOrdIdList.add(nxRSEkspLinOrdId.AsString);
      //
      // if nxRSEkspLinFrigivStatus.AsInteger = 1 then
      // Frigiv := True
      // else
      // AllFrigiv := False;
      //
      // if Trim(nxRSEkspLinDosStartDato.AsString) <> '' then
      // DosisLine := True;
      // nxRSEkspLin.Next;
      // end;
      //
      // finally
      // nxRSEkspLin.CancelRange;
      // nxRSEkspLin.IndexName := SaveIndex;
      //
      // end;

      // LKundenr := nxRSEkspPatCPR.AsString;
      if not nxRSEkspPatPersonIdentifier.AsString.IsEmpty then
        LKundenr := nxRSEkspPatPersonIdentifier.AsString;

      try
        RefreshSql := 'select ' + fnRS_EkspLinierOrdId + ',' +
          fnRS_EkspLinierFrigivStatus + ',' + fnRS_EkspLinierDosStartDato + ','
          + fnRS_EkspLinierPrivat + ' from ' + tnRS_EkspLinier + ' where ' +
          fnRS_EkspLinierReceptId_P + ' and coalesce(' + fnRS_EkspLinierLbNr
          + ',0)=0';
        c2logadd('Refresh sql is ' + RefreshSql);
        LQry := MainDm.nxdb.OpenQuery(RefreshSql, [aReceptId]);
        begin
          try
            if not LQry.Eof then
            begin
              LQry.First;
              while not LQry.Eof do
              begin
                if uFMKGetMedsById.RefreshReceivedMedications(LKundenr,
                  LQry.fieldbyname(fnRS_EkspLinierPrivat).AsInteger,
                  LQry.fieldbyname(fnRS_EkspLinierOrdId).AsString, AfdNr,
                  nxRSEkspReceptId.AsInteger, False, LSetInProgress) then
                  ValidOrdIdList.add(LQry.fieldbyname(fnRS_EkspLinierOrdId).AsString)
                else
                  LInvalidOrdlist.add(LQry.fieldbyname(fnRS_EkspLinierOrdId).AsString);

                Frigiv := LQry.fieldbyname(fnRS_EkspLinierFrigivStatus).AsInteger = 1;

                if LQry.fieldbyname(fnRS_EkspLinierDosStartDato).AsString <> '' then
                  DosisLine := True;

                LQry.Next;
              end;
            end;

          finally
            LQry.Free;
          end;

        end;
      except
        on e: Exception do
          c2logadd('Fejl in   get refreshed ordination sql ' + e.Message);
      end;

      if LInvalidOrdlist.Count <> 0 then
      begin
        ChkBoxOK('Ordinationen findes ikke på FMK og  kan ikke sættes under behandling'
          + sLineBreak + sLineBreak + LInvalidOrdlist.Text);

        // If there are any that were successful then removestatus on them

        if ValidOrdIdList.Count <> 0 then
          RemoveStatusFromValidOrd(ValidOrdIdList);

        exit;

      end;

      if Frigiv then
      begin
        IF AllFrigiv then
        begin
          ChkBoxOK('Alle ordinationer på denne recept er frigivet til andet apotek');
          exit;
        end
        else
          ChkBoxOK('Mindst én ordination på denne receptkvittering er blevet frigivet til andet apotek');
      end;

      if DosisLine then
      begin
        ChkBoxOK('Ordinationen er markeret til dosisdispensering, og skal behandles og takseres i dosisprogrammet.');
        exit;
      end;

      c2logadd('start to create the record for pass into eksphuman');
      ReceptServerPrescription := True;
      // this is the routine that will do it !!!!!!
      FillChar(EdiRcp, sizeof(TEdiRcp), 0);
      try
        EdiRcp.LbNr := aReceptId;
        EdiRcp.Annuller := False;
        if AKundenr.IsEmpty then
        begin
          EdiRcp.PaCprNr := nxRSEkspPatCPR.AsString;
          SidKundeNr := nxRSEkspPatCPR.AsString;
        end
        else
        begin
          EdiRcp.PaCprNr := AKundenr;
          SidKundeNr := AKundenr;
        end;
        c2logadd('171: sidkundenr ' + SidKundeNr);
        EdiRcp.PaNavn := nxRSEkspPatEftNavn.AsString;
        EdiRcp.ForNavn := nxRSEkspPatForNavn.AsString;
        if GemNyeRsFornavnEfternavn then
        begin
          if EdiRcp.ForNavn <> '' then
            EdiRcp.PaNavn := EdiRcp.ForNavn + ' ' + EdiRcp.PaNavn
        end
        else
        begin
          if EdiRcp.ForNavn <> '' then
            EdiRcp.PaNavn := EdiRcp.PaNavn + ',' + EdiRcp.ForNavn;
        end;
        EdiRcp.Adr := nxRSEkspPatVej.AsString;
        EdiRcp.Adr2 := '';
        EdiRcp.PostNr := nxRSEkspPatPostNr.AsString;
        EdiRcp.By := nxRSEkspPatBy.AsString;

        EdiRcp.Amt := nxRSEkspPatAmt.AsString;
        EdiRcp.Tlf := ''; // todo
        EdiRcp.Alder := ''; // todo
        EdiRcp.Barn := ''; // todo
        EdiRcp.Tilskud := ''; // todo
        EdiRcp.TilBrug := ''; // todo
        EdiRcp.Levering := nxRSEkspLeveringAdresse.AsString;
        EdiRcp.FriTxt := '';
        EdiRcp.YdNr := FixLFill('0', 7, nxRSEkspSenderId.AsString);
        EdiRcp.YdCprNr := trim(nxRSEkspIssuerCPRNr.AsString);
        if EdiRcp.YdCprNr = '' then
          EdiRcp.YdCprNr := trim(nxRSEkspIssuerAutNr.AsString);
        LSenderTypeIsSOR := SameText(nxRSEkspSenderType.AsString, 'SOR');
        if nxRSEkspSenderType.AsString = 'lokationsnummer' then
          EdiRcp.YdNr := 'F' + EdiRcp.YdCprNr.PadLeft(6, '0');
//        end
//        // If SenderType is SOR, then empty the Ydernr which will force the user to pick an Erstatningsydernr. 0990027
//        else if LSenderTypeIsSOR then
//          EdiRcp.YdNr := '';
        EdiRcp.YdNavn := nxRSEkspIssuerTitel.AsString;
        EdiRcp.YdSpec := ''; // todo
        EdiRcp.OrdAnt := 0;
        if (trim(nxRSEkspLeveringsInfo.AsString) <> '') or
          (trim(nxRSEkspOrdreInstruks.AsString) <> '') or
          (trim(nxRSEkspLeveringPri.AsString) <> '') or
          (trim(nxRSEkspLeveringAdresse.AsString) <> '') or
          (trim(nxRSEkspLeveringPseudo.AsString) <> '') or
          (trim(nxRSEkspLeveringPostNr.AsString) <> '') or
          (trim(nxRSEkspLeveringKontakt.AsString) <> '') then
          EdiRcp.LevInfo := 'Vis Ekspedition';
        if (trim(nxRSEkspLeveringsInfo.AsString) <> '') then
          EdiRcp.LevInfo := trim(nxRSEkspLeveringsInfo.AsString);
        SaveIndex := SaveAndAdjustIndexName(nxRSEkspLin, 'ReceptIDOrder');
        nxRSEkspLin.SetRange([aReceptId], [aReceptId]);
        AskNBSQuestion := True;
        with EdiRcp do
        begin
          nxRSEkspLin.First;
          UseInfertTakser := False;
          while not nxRSEkspLin.Eof do
          begin

            // check to see if we set the ordid underbehandlng
            if ValidOrdIdList.IndexOf(nxRSEkspLinOrdId.AsString) = -1 then
            begin
              nxRSEkspLin.Next;
              Continue;
            end;

            if nxRSEkspLinFrigivStatus.AsInteger = 1 then
            begin
              nxRSEkspLin.Next;
              Continue;
            end;
            if (not EkspCompleted) and (nxRSEkspLinRSLbnr.AsInteger <> 0) then
            begin
              nxRSEkspLin.Next;
              Continue;
            end;

            OrdAnt := OrdAnt + 1;
            Ord[OrdAnt].VareNr := nxRSEkspLinVarenNr.AsString.PadLeft(6,'0');
            c2logadd('varenr in konrseksp is ' + Ord[OrdAnt].VareNr);
            AdjustIndexName(ffLagKar, 'NrOrden');
            if ffLagKar.FindKey([0, Ord[OrdAnt].VareNr]) then
            begin
              c2logadd('found the product udlevtype is ' + ffLagKarUdlevType.AsString);
              Ord[OrdAnt].Navn := ffLagKarNavn.AsString;
              Ord[OrdAnt].Disp := ffLagKarForm.AsString;
              Ord[OrdAnt].Strk := ffLagKarStyrke.AsString;
              Ord[OrdAnt].Pakn := ffLagKarPakning.AsString;
              EdiRcp.Ord[EdiRcp.OrdAnt].DrugId := ffLagKarDrugId.AsString;
              EdiRcp.Ord[EdiRcp.OrdAnt].OpbevKode := ffLagKarOpbevKode.AsString;
              // if ffLagKarSSKode.AsString = 'I' then
              // UseInfertTakser := True;
              // if ffLagKarSSKode.AsString = 'J' then begin
              // if AskInfertQuestion then begin
              // UseInfertTakser := ChkBoxYesNo('Receptkvitteringen indeholder vare, der normalt er til infertilitetsbehandling.'
              // +sLineBreak+'Skal der foretages infetilitetsekspedition?',True);
              // end;
              // AskInfertQuestion := False;
              //
              //
              // end;
            end
            else
            begin
              Ord[OrdAnt].Navn := nxRSEkspLinNavn.AsString;
              Ord[OrdAnt].Disp := nxRSEkspLinForm.AsString;
              Ord[OrdAnt].Strk := nxRSEkspLinStyrke.AsString;
              Ord[OrdAnt].Pakn := nxRSEkspLinPakning.AsString;
              EdiRcp.Ord[EdiRcp.OrdAnt].DrugId := '';
              EdiRcp.Ord[EdiRcp.OrdAnt].OpbevKode := '';
            end;
            Ord[OrdAnt].Subst := '';
            if nxRSEkspLinSubstKode.AsString <> '' then
              Ord[OrdAnt].Subst := '-S';

            Ord[OrdAnt].Antal := nxRSEkspLinAntal.AsInteger;
            Ord[OrdAnt].Tilsk := ''; // todo
            Ord[OrdAnt].IndKode := nxRSEkspLinIndCode.AsString; // todo
            Ord[OrdAnt].IndTxt := nxRSEkspLinIndText.AsString;
            if nxRSEkspLinIterationNr.AsInteger <> 0 then
              Ord[OrdAnt].Udlev := nxRSEkspLinIterationNr.AsInteger + 1
            else
              Ord[OrdAnt].Udlev := 0;
            Ord[OrdAnt].Forhdl := ''; // todo
            Ord[OrdAnt].DosKode := nxRSEkspLinDosKode.AsString; // todo
            Ord[OrdAnt].DosTxt := nxRSEkspLinDosTekst.AsString; // todo
            if nxRSEkspLinDosPeriod.AsString <> '' then
              Ord[OrdAnt].DosTxt := Ord[OrdAnt].DosTxt + ' i ' + nxRSEkspLinDosPeriod.AsString + ' ' + nxRSEkspLinDosEnhed.AsString;

            Ord[OrdAnt].PEMAdmDone := 0;
            if nxRSEkspLinAdminCount.AsString <> '' then
              Ord[OrdAnt].PEMAdmDone := nxRSEkspLinAdminCount.AsInteger;
            if (Ord[OrdAnt].PEMAdmDone > 0) and (AskNBSQuestion) then
            begin
              if MatchText(ffLagKarUdlevType.AsString,['AP4','AP4NB','A','NBS']) then
              begin
                if not ChkBoxYesNo('Genudlevering af udlevering A, AP4 eller NBS. Vil du fortsætte?', False) then
                  exit;
              end;

              AskNBSQuestion := False;
            end;
            Ord[OrdAnt].OrdId := nxRSEkspLinOrdId.AsString;
            Ord[OrdAnt].Receptid := EdiRcp.LbNr;
            Ord[OrdAnt].Klausulbetingelse := nxRSEkspLinKlausulbetingelse.AsString <> '';

            // add the 3 fields to keep original varenr,antal and udlevtype
            // so we can block antal from changed to greater than that from FMK
            Ord[OrdAnt].OrdineretVarenr := nxRSEkspLinVarenNr.AsString;
            Ord[OrdAnt].OrdineretAntal := nxRSEkspLinAntal.AsInteger;
            Ord[OrdAnt].OrdineretUdlevType := ffLagKarUdlevType.AsString;
            EdiRcp.ord[EdiRcp.ordant].UdstederAutId := MainDm.nxRSEkspIssuerAutNr.AsString;
            EdiRcp.Ord[EdiRcp.OrdAnt].UdstederId := MainDm.nxRSEkspSenderId.asstring;
            EdiRcp.ord[EdiRcp.ordant].UdstederType := CalculateUdstederType(maindm.nxRSEkspSenderType.AsString);

            UpdateRSEkspeditionerReceptStatus(Ord[OrdAnt].Receptid);
            if (trim(nxRSEkspLinSupplerende.AsString) <> '') or
              (trim(nxRSEkspLinOrdreInstruks.AsString) <> '') or
              (trim(nxRSEkspLinApotekBem.AsString) <> '') then
              if EdiRcp.LevInfo = '' then
                EdiRcp.LevInfo := 'Vis Ekspedition';
            nxRSEkspLin.Next;
          end;
        end;
        if nxRSEkspSenderType.AsString = 'lokationsnummer' then
        begin
          ChkBoxOK('Genordination fra Behandlerfarmaceut:' + sLineBreak +
            nxRSEkspIssuerTitel.AsString + ', ' + nxRSEkspSenderNavn.AsString +
            sLineBreak + 'Et genordineret lægemiddel må kun udleveres én gang og i mindste pakning'
            + sLineBreak + 'Husk at opkræve udleveringsgebyr');
        end;
        if EdifactRcp(Addr(EdiRcp), TabSheet) then
          RCPTakserCompleted := True;
      finally
        ReceptServerPrescription := False;
        c2logadd('finally');
        FillChar(EdiRcp, sizeof(TEdiRcp), 0);
        nxRSEkspLin.CancelRange;
        nxRSEkspLin.IndexName := SaveIndex;
        TakserActive := False;
        LogoffTimer := 0;
        if Afslut_i_CF5_CF6 then
        begin
          StamPages.ActivePage := TabSheet;

          if StamPages.ActivePage = KartotekPage then
          begin
            // Kun ved retur til kartotek
            RefreshCF1WithBlankKundenr;
//            ffPatKar.FindKey([KundeKeyBlk]);
//            EKundeNr.SelectAll;
//            EKundeNr.SetFocus;
          end;
        end
        else
        begin
          StamPages.ActivePage := KartotekPage;
          if GoAuto then
          begin
            // Kun ved retur til kartotek
            RefreshCF1WithBlankKundenr;
//            ffPatKar.FindKey([KundeKeyBlk]);
//            EKundeNr.SelectAll;
//            EKundeNr.SetFocus;
          end;
        end;
        c2logadd('after finally');
      end;
    finally
      ValidOrdIdList.Free;
      LInvalidOrdlist.Free;
      KonvRSEkspBusy := False;
      c2logadd('Bottom of konvrseksp');
    end;
  end;
end;

procedure TStamForm.acOpdaterKomEanExecute(Sender: TObject);
var
  Lst: TStringList;
  Fnd: Boolean;
  Chk, Mgl, Cnt: Integer;
  Rgl, Kom, PNr: Word;
  KNr: string;
  SQL: TStringlist;
begin
  with MainDm do
  begin
    // Opdater tilskud med kommunernes eanliste
    BusyMouseBegin;
    Lst := TStringList.Create;
    SQL := TStringList.Create;
    try
      Mgl := 0;
      Cnt := 0;
      Chk := 0;

      SQL.Clear;
      sql.add('SELECT distinct');
      sql.add('  P.Kundenr');
      sql.add('  ,P.Kommune');
      sql.add('FROM');
      sql.add('     PatientTilskud as T');
      sql.add('  INNER JOIN PatientKartotek AS P');
      sql.add('    ON P.KundeNr=T.KundeNr');
      sql.add('   WHERE');
      sql.add('     T.Regel BETWEEN 61 AND 79');
      sql.add('   ORDER BY');
      sql.add('     P.KundeNr');

      nqTilEan.Close;
      nqTilEan.SQL.Text := SQL.Text;
      try
        nqTilEan.Open;
        if nqTilEan.RecordCount = 0 then
        begin
          ChkBoxOK('Ingen bevillinger at opdatere!');
          exit;
        end;
        c2logadd('Start opdatering af ' + inttostr(nqTilEan.RecordCount) +
          ' bevillinger');
        nqTilEan.First;
        while not nqTilEan.Eof do
        begin
          KNr := nqTilEan.FieldByName('KundeNr').AsString;
          Kom := nqTilEan.FieldByName('Kommune').AsInteger;
          ffTilUpd.SetRange([KNr], [KNr]);
          try
            c2logadd('  Kundenr ' + KNr + ' kommune ' + inttostr(Kom));
            ffTilUpd.First;
            while not ffTilUpd.Eof do
            begin

              if (ffTilUpdRegel.AsInteger < 61) or (ffTilUpdRegel.AsInteger > 79)
              then
              begin
                ffTilUpd.Next;
                Continue;
              end;

              cdKomEan.Filter := '';
              cdKomEan.Filtered := False;
              try
                Rgl := ffTilUpdRegel.AsInteger;
                c2logadd('    Regel ' + inttostr(Rgl));
                cdKomEan.Filter := '(KommuneNr=' + inttostr(Kom) +
                  ') AND (RegelNr=' + inttostr(Rgl) + ')';
                c2logadd('    Filter ' + cdKomEan.Filter);
                cdKomEan.Filtered := True;
                c2logadd('    Antal eanliste ' +
                  inttostr(cdKomEan.RecordCount));
                if cdKomEan.RecordCount = 1 then
                begin
                  // Et eannr på regel
                  ffTilUpd.Edit;
                  ffTilUpdAfdeling.AsString := Trim(cdKomEanFriTekst.AsString);
                  ffTilUpdRefNr.AsString := Trim(cdKomEanEanNr.AsString);
                  ffTilUpd.Post;
                  Inc(Cnt);
                  c2logadd('      Regel ' + cdKomEanRegelNr.AsString);
                  c2logadd('      Eankode ' + cdKomEanEanNr.AsString);
                  c2logadd('      Afdeling ' + cdKomEanFriTekst.AsString);
                end
                else
                begin
                  // Ikke ved mere end et eannr pr. regel
                  if cdKomEan.RecordCount > 0 then
                  begin
                    // Her kan ikke opdateres automatisk
                    if (Trim(ffTilUpdRefNr.AsString) = '') or
                      (Trim(ffTilUpdRefNr.AsString) = '?????????????') then
                    begin
                      ffTilUpd.Edit;
                      ffTilUpdAfdeling.AsString := '***Afdelingsvalg***';
                      ffTilUpdRefNr.AsString := '?????????????';
                      ffTilUpd.Post;
                      Inc(Mgl);
                      Lst.add(KNr + Spaces(2) + Word2Str(Rgl, 3) + Spaces(2) +
                        FormInt2Str(cdKomEan.RecordCount, 2) + ' mulige,' +
                        ' bevilling ' + ffTilUpdFraDato.AsString + ' - ' +
                        ffTilUpdTilDato.AsString);
                    end
                    else
                    begin
                      // Check mellem mulige
                      Fnd := False;
                      cdKomEan.First;
                      while not cdKomEan.Eof do
                      begin
                        if ffTilUpdRefNr.AsString = cdKomEanEanNr.AsString then
                        begin
                          Fnd := True;
                          break;
                        end;
                        cdKomEan.Next;
                      end;
                      // Hvis den ikke var der fejlmeldes
                      if not Fnd then
                      begin
                        Inc(Chk);
                        Lst.add(KNr + Spaces(2) + Word2Str(Rgl, 3) + Spaces(2) +
                          '"diff. eannr", bevilling ' + ffTilUpdFraDato.AsString
                          + ' - ' + ffTilUpdTilDato.AsString);
                      end;
                    end;
                  end
                  else
                  begin
                    // Ingen regel - benyt regel 0
                    cdKomEan.Filter := '';
                    cdKomEan.Filtered := False;
                    if cdKomEan.FindKey([Kom, 0]) then
                    begin
                      // Et eannr på regel 0
                      ffTilUpd.Edit;
                      ffTilUpdRefNr.AsString := Trim(cdKomEanEanNr.AsString);
                      ffTilUpd.Post;
                      Inc(Cnt);
                      c2logadd('      Regel 0');
                      c2logadd('      Eankode ' + cdKomEanEanNr.AsString);
                    end
                    else
                    begin
                      Inc(Mgl);
                      Lst.add(KNr + Spaces(2) + Word2Str(Rgl, 3) + Spaces(2) +
                        '"ingen regel", bevilling ' + ffTilUpdFraDato.AsString +
                        ' - ' + ffTilUpdTilDato.AsString);
                    end;
                  end;
                end;
              except
                on e: Exception do
                begin
                  c2logadd('  Exception "' + e.Message + '" bevilling skippet');
                  if ffTilUpd.State <> dsBrowse then
                    ffTilUpd.Cancel;
                end;
              end;
              ffTilUpd.Next;
            end;
          finally
            ffTilUpd.CancelRange;
            cdKomEan.Filter := '';
            cdKomEan.Filtered := False;
          end;
          nqTilEan.Next;
        end;
        c2logadd('  Eankoder mangler på ' + inttostr(Mgl) + ' bevillinger');
        c2logadd('  Eankoder checkes på ' + inttostr(Chk) + ' bevillinger');
        c2logadd('  Eankoder opdateret på ' + inttostr(Cnt) + ' bevillinger');
        c2logadd('Stop opdatering af bevillinger');
        ChkBoxOK('Eankoder på bevillinger:'#13#10 + '  opdateret på ' +
          inttostr(Cnt) + ''#13#10 + '  checkes på ' + inttostr(Chk) + ''#13#10
          + '  mangler på ' + inttostr(Mgl));
        if Mgl > 0 then
        begin
          Lst.Insert(0, '');
          Lst.Insert(0, 'Cprnr     Regel');
          Lst.Insert(0, '');
          Lst.Insert(0, ffFirmaNavn.AsString);
          Lst.Insert(0,
            'E A N - B E V I L L I N G S L I S T E   M A N G L E R');
          Lst.SaveToFile('C:\C2\Temp\EanListe.Txt');
          PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\EanListe.Txt');
        end;
        // Refresh evt. patienter og tilskud
        if Cnt > 0 then
        begin
          ffPatKar.Refresh;
          ffPatTil.Refresh;
        end;
      except
        on e: Exception do
          ChkBoxOK('Søgning afbrudt af server!'#13#10 + SQL.Text +
            #13#10 + 'Exception "' + e.Message + '"');
      end;
    finally
      // C2LogSave;
      Lst.Free;
      SQL.Free;
      BusyMouseEnd;
    end;
  end;
end;

procedure TStamForm.butRetPakAntClick(Sender: TObject);
begin
  with MainDm do
  begin
    ffEksOvr.Refresh;
    ffEksFak.Refresh;
    try
      if not ffEksFak.FindKey([ffEksOvrFakturaNr.AsInteger]) then
        exit;
      // Vis antal pakker
      if not ChkBoxYesNo('Ret antal pakker på faktura ' +
        ffEksOvrFakturaNr.AsString + ' fra ' + ffEksFakAntalPakker.AsString +
        ' til ' + edtPakAnt.Text, True) then
        exit;

      ffEksFak.Edit;
      ffEksFakAntalPakker.AsInteger := StrToInt(edtPakAnt.Text);
      ffEksFakPakkeRabat.AsCurrency := ffEksFakAntalPakker.AsInteger *
        ffRcpOplPakkeGebyr.AsCurrency;
      ffEksFak.Post;
    except
    end;
  end;
end;

procedure TStamForm.btnGetMedListClick(Sender: TObject);
var
  SetInProgress: Boolean;
  sl: TStringList;
  printRecept: Boolean;
  ll : TListItem;
  LPrescriptionId : int64;
  LPrescription : TC2FMKPrescription;
  ReceivedLbnr: Integer;
  LFMKErrorString : string;
begin

  // does the user still have a certificate before we call fmk routines
  if not CurrentLogonIsValid(maindm.Bruger,maindm.Afdeling,ltAll) then
  begin
    Close;
    exit;
  end;
  UpdateStatusBrugerInfo;


  btnGetMedList.Enabled := False;
  btnTakser.Enabled := False;
  // SetInProgress:= ChkBoxYesNo('Ordination(er) sættes under behandling?',True);
  SetInProgress := False;
  printRecept := ChkBoxYesNo('Udskriv receptkvittering?', True);
  BusyMouseBegin;
  sl := TStringList.Create;
  try
    // if (not SetInProgress) and (not printRecept) then begin
    // c2logadd('not set in progress and not print recept.....why?');
    /// /      ChkBoxOK('Ordination are not set in progress and not printed.');
    // exit;
    // end;
    for ll in lvFMKPrescriptions.Items do
    begin
      if ll.Checked then
          CF5Ordlist.add(format('%-20.20s', [ll.Caption]));
    end;
    if CF5Ordlist.Count = 0 then
      exit;
    try
      SplashScreenShow(Nil, 'Ekspedition', 'Afventer FMK');
      SplashScreenUpdate('');

      // MidcliOption := '2';
      // IF printRecept then
      // MidcliOption := '20';
      CF5Ordlist.Sort;
      while CF5Ordlist.Count <> 0 do
      begin
        sl.add(CF5Ordlist.Strings[0].Trim);
        CF5Ordlist.Delete(0);
        if TryStrToInt64(sl.Strings[0],LPrescriptionId) then
        begin
          LPrescription := MainDm.PrescriptionsForPO.Prescriptions.GetPrescriptionByID(LPrescriptionId);
          if not uFMKGetMedsById.FMKGetPrescriptionById(MainDm.AfdNr,LPrescription, SetInProgress,ReceivedLbnr,LFMKErrorString) then
          begin
            C2LogAdd(LFMKErrorString);
            // ChkBoxOK(RSErrorMessage)
          end;
          if printRecept then
          begin
            with MainDm do
            begin
              // tell rsmidsrv to print it

              RCPMidCli.SendRequest('GetAddressed',
                ['4', ReceivedLbnr,
                IntToStr(MainDm.AfdNr), MainDm.C2UserName, Bool2Str(True)], 10);

              with nxdb.OpenQuery('update rs_ekspeditioner set ReceptStatus=4 where ReceptId=:Receptid',[ReceivedLbnr]) do
              begin
                try
                  C2LogAdd('Rowsaffected is ' + IntToStr(RowsAffected));

                finally
                  Free;
                end;
              end;

            end;


          end;

        end;
        sl.Clear;
      end;

    finally
      SplashScreenHide;
    end;
  finally
    sl.Free;
    BusyMouseEnd;
    edtCprNr.SetFocus;
    btnGetMedList.Enabled := True;
    btnTakser.Enabled := True;
    VisOrdCprNr;
    edtCprNr.SelectAll;
    edtCprNr.SetFocus;
    // PostMessage(StamForm.Handle, WM_CHAR, VK_RETURN, 0);
  end;
end;

procedure TStamForm.lvFMKPrescriptionsDblClick(Sender: TObject);
var
  i: Integer;
  LMedId: Int64;
  LPrescription : TC2FMKPrescription;
begin
  BusyMouseBegin;
  i := lvFMKPrescriptions.ItemIndex;
  try
    if i <> -1 then
    begin
        if TryStrToInt64(lvFMKPrescriptions.Items[i].Caption,LMedId) then
        begin
          LPrescription := MainDm.PrescriptionsForPO.Prescriptions.GetPrescriptionByID(LMedId);
          TfrmOrdView.ShowOrdView(LPrescription,FLagerNr,edtCprNr.Text);
        end;
    end;
  finally
    BusyMouseEnd;
  end;
end;

procedure TStamForm.lvFMKPrescriptionsItemChecked(Sender: TObject; Item: TListItem);
var
  sub4, sub5: Integer;
  last_date: TDate;
  dd, mm, yyyy: Integer;
  intantal: Integer;
  ipos: Integer;
  diffdays: Integer;
  btn1, btn2: Boolean;
  LValidSelection : Boolean;
  LStatus : string;
  LStrDate : string;
  LDosisSelection : Boolean;
begin
  try
    if not Item.Checked then
      exit;

    btn1 := btnGetMedList.Enabled;
    btn2 := btnTakser.Enabled;
    btnGetMedList.Enabled := False;
    btnTakser.Enabled := False;

    try

      LDosisSelection := item.SubItems[lvFMKDosis] <> '';
      if LDosisSelection then
      begin
        if ChkBoxYesNo('Ordinationen er markeret til dosisdispensering, og skal behandles ' +
            'og takseres i dosisprogrammet.' +
            #13#10+'Ønskes recepten udskrevet?',False) then
          PrintDosisEkspedition(Item.Caption);

        Item.Checked := False;
        exit;
      end;

      if (AnsiCompareText(Item.SubItems[lvFMKStatus], 'Behandles') = 0) or
        (AnsiCompareText(Item.SubItems[lvFMKStatus], osEkspeditionPaabegyndt.ToString) = 0) then
      begin
        if Item.SubItems[lvFMKLokation] <> MainDm.RSLokation then
        begin
          ChkBoxOK('Recepten er under ekspedition på andet apotek.');
          Item.Checked := False;
          exit;
        end;
      end;
    finally
      btnGetMedList.Enabled := btn1;
      btnTakser.Enabled := btn2;
    end;


    // check valid dates


    if (not Item.SubItems[lvFMKValidFra].IsEmpty) and (not Item.SubItems[lvFMKValidTil].IsEmpty) then
    begin
      LStrDate := Item.SubItems[lvFMKValidFra];
      if LStrDate > FormatDateTime('yyyy-mm-dd',Now) then
      begin
        ChkBoxOK('Recepten er endnu ikke gyldig');
        Item.Checked := False;
      end;

      LStrDate := Item.SubItems[lvFMKValidTil];
      if LStrDate < FormatDateTime('yyyy-mm-dd',Now) then
      begin
        ChkBoxOK('Recepten er ikke længere gyldig');
        Item.Checked := False;
      end;

    end;


    LStatus := Item.SubItems[lvFMKStatus];
    LValidSelection := (AnsiCompareText(LStatus, 'Åben') = 0 ) or
                        (AnsiCompareText(LStatus,'Delvis') = 0 ) or
                        (AnsiCompareText(LStatus,osUdfoert.toString) = 0);


//                         or
//                        (AnsiCompareText(Item.SubItems[lvFMKStatus], osEkspeditionPaabegyndt.ToString) = 0);
    if not LValidSelection then
    begin
      ChkBoxOK('Ordination kan ikke sættes under behandling!');
      Item.Checked := False;
      exit;
    end;
    //
    if CheckMedIdInCF6(Item.Caption) then
    begin
      ChkBoxOK('Denne ordination er allerede hentet. Gå til Lokale Recepter [CF6].');
      Item.Checked := False;
      exit;
    end;

    if EdiIntervalAdvarsel then
    begin
      if Item.SubItems[lvFMKAdminDato] <> '' then
      begin
        intantal := 0;
        dd := StrToInt(copy(Item.SubItems[lvFMKAdminDato], 9, 2));
        mm := StrToInt(copy(Item.SubItems[lvFMKAdminDato], 6, 2));
        yyyy := StrToInt(copy(Item.SubItems[lvFMKAdminDato], 1, 4));
        last_date := EncodeDate(yyyy, mm, dd);
        c2logadd('last date is ' + DateToStr(last_date));
        c2logadd('interval is ' + Item.SubItems[lvFMKIneterval]);
        ipos := pos('dag', Item.SubItems[lvFMKIneterval]);
        if ipos <> 0 then
          intantal := StrToInt(Trim(copy(Item.SubItems[lvFMKIneterval], 1, ipos - 1)));
        ipos := pos('uge', Item.SubItems[lvFMKIneterval]);
        if ipos <> 0 then
          intantal := StrToInt(Trim(copy(Item.SubItems[lvFMKIneterval], 1, ipos - 1))) * 7;
        ipos := AnsiPos('måned', Item.SubItems[lvFMKIneterval]);
        if ipos <> 0 then
        begin
          intantal := StrToInt(Trim(copy(Item.SubItems[lvFMKIneterval], 1, ipos - 1))) * 30;
          c2logadd('intantal is ' + inttostr(intantal));
        end;
        diffdays := DaysBetween(Now, last_date);
        if diffdays < intantal then
        begin
          if not ChkBoxYesNo('Sidst ekspederet: ' + Item.SubItems[lvFMKAdminDato] + #10#13 +
            'Antal dage siden sidste ekspedition: ' + inttostr(diffdays) +
            #10#13 + #10#13 + 'Interval: ' + Item.SubItems[lvFMKIneterval] + #10#13 +
            'Fortsæt JA/NEJ', False) then
          begin
            Item.Checked := False;
            exit;
          end;
        end;
      end;
    end;
    if VisUdlevStoerreEndMax then
    begin
      c2logadd('about to check udlev and max ' + Item.SubItems[lvFMKMax] + ' ' +
        Item.SubItems[lvFMKUdlev]);
      try
        sub4 := StrToInt(Item.SubItems[lvFMKMax]);
        sub5 := StrToInt(Item.SubItems[lvFMKUdlev]);
        if (sub4 <> 0) or (sub5 <> 0) then
        begin
          if sub5 >= sub4 then
            ChkBoxOK('Antal udleveringer er større end max.' + #10#13 +
              'Check udleveringsdetaljer ved at markere ordinationsnummer og Alt+O');
        end;
      except

      end;
    end;
    // CheckReturn := DMRSGetMeds.CheckMedbyId(Item.Caption,FAfdNr);
    //
    // if CheckReturn = 1 then begin
    // ChkBoxOK('Ordination id ' + item.Caption + ' findes ikke på receptserver');
    // item.Checked := False;
    // exit;
    // end;
    // if CheckReturn = 2 then begin
    // if not ChkBoxYesNo('Receptserveren svarer ikke. Vil du ekspedere ordinationen?',True) then begin
    // item.Checked := False;
    // exit;
    // end;
    // end;

  except
  end;
end;

procedure TStamForm.UpdateListview;
var
  LPrescription: TC2FMKPrescription;
  i: Integer;
  LOrder: TC2FMKOrder;
  ll: TListItem;
  NameOfDrug: string;
  LVarenr: string;
  LName: string;
  LForm: string;
  LStyrke: string;
  LPacksize: string;
  LastAdminDate: string;
  LAdminCount: Integer;
  LStatus: TFMKOrderStatus;
  LBehandleApotek: string;
  LPersonId: string;
  LPersonIdSource: TFMKPersonIdentifierSource;
begin
  lvFMKPrescriptions.Clear;
  MainDm.PrescriptionsForPO.Prescriptions.Sort(sfobCreatedDateTime, False);
//  LMedícineCardKey := '';
//  if MainDm.PrescriptionsForPO.Patient.Person.PersonIdentifierSource <> pisCPR
//  then
//    LMedícineCardKey := MainDm.PrescriptionsForPO.Patient.Person.
//      PersonIdentifier;
  LPersonId := MainDm.PrescriptionsForPO.Patient.Person.PersonIdentifier;
  LPersonIdSource := MainDm.PrescriptionsForPO.Patient.Person.PersonIdentifierSource;

  for LPrescription in MainDm.PrescriptionsForPO.Prescriptions do
  begin
    with LPrescription do
    begin

      LAdminCount := 0;
      LStatus := osUndefined;
      ll := lvFMKPrescriptions.Items.add;
      ll.Caption := Identifier.ToString;
      // add blank columns for each column in the listview
      // makess it easier to refer to each culmn by a "name"
      for i := 0 to lvFMKNLastSubitem do
        ll.SubItems.add('');

      ll.SubItems[lvFMKDato] := FormatDateTime('yyyy-mm-dd hh:mm:ss',  { TODO : Three y's ? }
        Created.DateTime);

      LastAdminDate := '';
      if LatestEffectuationDateTime <> 0 then
        LastAdminDate := FormatDateTime('yyyy-mm-dd',
          LatestEffectuationDateTime);
      LBehandleApotek := '';
      if Assigned(Orders) and (Orders.Count <> 0) then
      begin
        LOrder := Orders.ObjectList.Last;
        if (LOrder.Status = osEkspeditionPaabegyndt) or
          (LOrder.Status = osDosisdispenseret) then
        begin
          LStatus := LOrder.Status;
          LBehandleApotek := LOrder.OrderedAtPharmacy.Name;
        end;

      end;

      LAdminCount := OrderEffectuationsDoneCount;

      ll.SubItems[lvFMKAdminDato] := LastAdminDate;

      LVarenr := '';
      if PackageRestriction <> Nil then
        LVarenr := PackageRestriction.PackageNumber.ToVnr;

      with Drug do
      begin
        LName := DrugName.trim;
        if Assigned(Form) then
          LForm := Form.Text.trim
        else
          LForm := '';
        if Assigned(Strength) then
          LStyrke := Strength.Text.trim
        else
          LStyrke := '';

        if (PackageRestriction <> Nil) and
          (PackageRestriction.PackageSize <> Nil) then
          LPacksize := PackageRestriction.PackageSize.PackageSizeText.trim;
      end;

      // if no varenr then get the largest pack using drugid and set the varenr and packsize
      if LVarenr = '' then
      begin
        if (Assigned(Drug)) and (Assigned(Drug.Identifier)) then
        begin
          try
            with MainDm.nxdb.OpenQuery('#T 30000' + ' select top 1 ' +
              fnLagerKartotekVareNr + ',' + fnLagerKartotekPakning + ' from ' +
              tnLagerKartotek + ' where ' + fnLagerKartotekLager_P + ' and ' +
              fnLagerKartotekDrugId_P + ' and ' + fnLagerKartotekAfmDato +
              ' is null' + ' order by ' + fnLagerKartotekPaknNum + ' desc',
              [FLagerNr, Drug.Identifier.Identifier.ToString]) do
            begin
              if not Eof then
              begin
                LVarenr := fieldbyname(fnLagerKartotekVareNr).AsString;
                LPacksize := fieldbyname(fnLagerKartotekPakning).AsString;
              end;

              Free;
            end;
          except
            on e: Exception do
              c2logadd(e.Message);

          end;
        end;

      end;

      NameOfDrug := Format('%s %s %s %s', [LName, LForm, LStyrke, LPacksize]);
      NameOfDrug := StringReplace(NameOfDrug, '  ', ' ', [rfReplaceAll]);

      ll.SubItems[lvFMKBeskrivelse] := NameOfDrug;
      if PackageRestriction <> Nil then
      begin

        with PackageRestriction do
        begin
          ll.SubItems[lvFMKAntal] := PackageQuantity.ToString;
          // number of packings
          ll.SubItems[lvFMKMax] := IterationNumber.ToString;
          // number of iterations
          ll.SubItems[lvFMKUdlev] := LAdminCount.ToString;
          { TODO : administrationsdone }
          if IterationNumber <> 0 then
            ll.SubItems[lvFMKIneterval] := IterationInterval.ToString + ' ' +
              IterationIntervalUnit.ToString;

          LVarenr := PackageNumber.ToVnr;
        end;
      end
      else
      begin
        ll.SubItems[lvFMKAntal] := '1'; // number of packings
        ll.SubItems[lvFMKMax] := '0'; // number of iterations
        ll.SubItems[lvFMKUdlev] := LAdminCount.ToString;
        { TODO : administrationsdone }
      end;
      if LStatus <> osUndefined then
        ll.SubItems[lvFMKStatus] := LStatus.ToString
      else
      begin
        if Status = psAaben then
          ll.SubItems[lvFMKStatus] := 'Åben'
        else
          ll.SubItems[lvFMKStatus] := LStatus.ToString;
      end;
      ll.SubItems[lvFMKApotek] := LBehandleApotek;
      ll.SubItems[lvFMKReceptId] := Identifier.ToString; // prescription id
      ll.SubItems[lvFMKVarenr] := LVarenr;
      if (Orders <> Nil) and (Orders.Count <> 0) then
      begin
        LOrder := Orders.ObjectList.Last;
        if LOrder.Status = osEkspeditionPaabegyndt then
          ll.SubItems[lvFMKLokation] := LOrder.OrderedAtPharmacy.Identifier;
      end;
      if IsDoseDispensed then
        ll.SubItems[lvFMKDosis] := 'Ja';

      if IsPrivatePrescription then
        ll.SubItems[lvFMKPrivat] := 'Ja';

      if Assigned(Created.By.AuthorisedHealthcareProfessional) then
        ll.SubItems[lvFMKYder] :=
          Created.By.AuthorisedHealthcareProfessional.Name;

      if Assigned(Created.By.Organisation) then
        ll.SubItems[lvFMKPraksis] := Created.By.Organisation.Name;

      ll.SubItems[lvFMKValidFra] := FormatDateTime('yyyy-mm-dd', ValidFromDate);
      ll.SubItems[lvFMKValidTil] := FormatDateTime('yyyy-mm-dd', ValidToDate);
      // save_index := nxRSEkspLin.IndexName;
      // nxRSEkspLin.IndexName := 'OrdIdOrden';
      // try
      // nxRSEkspLin.SetRange([Item.Caption], [Item.Caption]);
      // try
      // if nxRSEkspLin.RecordCount <> 0 then
      // begin
      // nxRSEkspLin.First;
      // while not nxRSEkspLin.Eof do
      // begin
      // if nxRSEkspLinRSLbnr.AsInteger = 0 then
      // begin
      // lvFMKPrescriptions.Canvas.Brush.Color := tcolor($82DDEE);
      // break;
      // end;
      // nxRSEkspLin.Next;
      // end;
      // end;
      // finally
      // nxRSEkspLin.CancelRange;
      // end;
      //
      // finally
      // nxRSEkspLin.IndexName := save_index;
      //
      // end;
      ll.SubItems[lvFMKRSLbnr] := '0';
      with MainDm.nxdb.OpenQuery('select ' + fnRS_EkspLinierRSLbnr + ' from ' +
        tnRS_EkspLinier + ' where ' + fnRS_EkspLinierOrdId_P + ' and coalesce('
        + fnRS_EkspLinierRSLbnr + ',0)=0', [ll.Caption]) do
      begin
        try
          if not Eof then
            ll.SubItems[lvFMKRSLbnr] := '1';
        finally
          Free;
        end;

      end;
//      ll.SubItems[lvPersonId] := LMedícineCardKey;
      ll.SubItems[lvPersonId] := LPersonId;
      ll.SubItems[lvPersonIdSource] := LPersonIdSource.ToString;
    end;
  end;

end;

procedure TStamForm.UpdateStatusBrugerInfo;
var
  LExpireTime : TDateTime;
begin
  if MainDm.BrugerNr = 0 then
    exit;
  C2StatusBar.Panels[0].Text := ' Bruger ' + inttostr(MainDm.BrugerNr);
  if MainDm.Bruger.HasUserCertificate then
  begin
    MainDm.Bruger.SyncSosiIdFromServer(MainDm.Afdeling);
    LExpireTime := MainDm.Bruger.SosiId.ValidTo;
    if LExpireTime> Now then
      C2StatusBar.Panels[0].Text := C2StatusBar.Panels[0].Text +
      ' kl' + formatdatetime('hh:mm',
        IncSecond(LExpireTime,0-MainDm.FMKCertificateExpiredSeconds));

  end;
end;

procedure TStamForm.VisOrdCprNr;
var
  save_index: string;
  LCprnr: Int64;
  mm, dd, yy: Word;
  LDate: TDateTime;
  LPersonId: string;
  LPersonIdSource: TFMKPersonIdentifierSource;

  function CheckForPrivatePrescriptions: Boolean;
  var
    LApotekName: string;
  begin
    with MainDm do
    begin

      Result := False;

      LApotekName := ffAfdNvnNavn.AsString;
      if ffAfdNvnRefNr.AsInteger = 0 then
        LApotekName := ffFirmaNavn.AsString;

      if PrescriptionsForPO.PrivatePrescriptions.Count <> 0 then
      begin

        if uYesNo.frmYesNo.NewYesNoBox
          ('Der er privatmarkerede ordinationer der IKKE er adresseret til ' +
          sLineBreak + LApotekName + sLineBreak +
          'Er der samtykke fra kunde til at vise disse?') then
        begin
          if uYesNo.frmYesNo.NewYesNoBox
            ('Er du sikker på, at du ønsker at se privatmarkerede ordinationer?')
          then
          begin
            Result := True;
            exit;
          end;
        end;
      end;
    end;

  end;

  procedure FMKGetByCPR(APersonId: string; APersonIdSource: TFMKPersonIdentifierSource);
  var
    LResult: Boolean;
    LViewPrivatPrescriptions: Boolean;
    LConsent: TFMKConsentType;
  begin
    with MainDm do
    begin
      LConsent := ctUndefined;
      LResult := C2FMK.GetPrescriptionRequest(Bruger.SOSIId,
        Bruger.FMKRolle.ToSOSIId, APersonId, APersonIdSource, LConsent,
        ipOpenPrescriptions, True, PrescriptionsForPO);
      // c2logadd(C2FMK.XMLLog.Text);
      if not LResult then
      begin
        ChkBoxOK(C2FMK.LastErrorDisplayText);
        exit;
      end;
      if PrescriptionsForPO.MedicineCardIsInvalid then
        frmYesNo.NewOKBox('Ugyldigt medicinkort indikerer tvivl om dataindhold'
          + sLineBreak + 'og data kan være misvisende.' + sLineBreak +
          ' Kun Sundhedsdatastyrelsen kan ugyldiggøre medicinkort.' + sLineBreak +
          'Ugyldighedsmarkeringen fjernes automatisk ved lægens første' + sLineBreak
          + 'ajourføring af medicinkortet foretaget efter ugyldiggørelsen.' +
          sLineBreak + 'Ved tvivl bør apoteket søge recepternes indhold verificeret'
          + sLineBreak + 'hos receptudsteder eller borgerens egen læge.');

      UpdateListview;

      // IF consent given go get the prescriptions again wih consent
      LViewPrivatPrescriptions := CheckForPrivatePrescriptions;
      if LViewPrivatPrescriptions then
      begin
        LConsent := ctPrivateDataConsentGiven;
        LResult := C2FMK.GetPrescriptionRequest(Bruger.SOSIId,
          Bruger.FMKRolle.ToSOSIId, APersonId, APersonIdSource, LConsent,
          ipOpenPrescriptions, True, PrescriptionsForPO);
        // c2logadd(C2FMK.XMLLog.Text);
        if not LResult then
        begin
          ChkBoxOK(C2FMK.LastErrorDisplayText);
          exit;
        end;
        UpdateListview;

      end;

      C2FMK.XMLLog.Clear;
    end;
  end;

begin
  with MainDm do
  begin
    BusyMouseBegin;
    btnGetMedList.Enabled := False;
    btnTakser.Enabled := False;
    lvFMKPrescriptions.Clear;
    ListView2.Clear;
    edtForNavn.Text := '';
    edtEftNavn.Text := '';
    cxDateFoedselsdato.Clear;
    edtPostNr.Text := '';
    chkUdenCPR.Checked := False;
    lblCF5Cprnr.Caption := '&Cprnr';
    LPersonId := Trim(edtCprNr.Text);
    LPersonIdSource := TFMKPersonIdentifierSource.DetectSource(LPersonId, pisUndefined);

    try
      // does the user still have a certificate before we call fmk routines
      if not maindm.CheckFMKCertificate then
        exit;

      UpdateStatusBrugerInfo;

      if LPersonId.IsEmpty then
        exit;

      if CompareText(LPersonId, 'Blank') = 0 then
      begin
        edtCprNr.Text := '';
        exit;
      end;

      if LPersonId.Length = 13 then
      begin
        SearchBarcode(LPersonId);
        exit;
      end;

      if not (LPersonIdSource in [pisCPR, pisXeCpr, pisSORPerson]) then
//      if trim(edtCprNr.Text).Length <> 10 then
      begin
        ChkBoxOK('Dette er ikke et gyldigt CPR-nummer : ' + LPersonId);
        edtCprNr.Text := '';
        exit;
      end;

//      if not TryStrToInt64(edtCprNr.Text, LCprnr) then
//      begin
//        ChkBoxOK('Dette er ikke et gyldigt CPR-nummer : ' + edtCprNr.Text);
//        edtCprNr.Text := '';
//        exit;
//      end;
      LCprNr := StrToInt64Def(LPersonId, 0);
      if (LPersonIdSource = pisCPR) and ((LCprnr < 0101000000) or (LCprnr >= 4000000000)) then
      begin
        ChkBoxOK('Dette er ikke et gyldigt CPR-nummer : ' + LPersonId);
        exit;
      end;

      // check first 6 digits are ddmmyy
      if LPersonIdSource in [pisCPR, pisXeCPR] then
      begin
        dd := StrToInt(copy(LPersonId, 1, 2));
        mm := StrToInt(copy(LPersonId, 3, 2));
        yy := StrToInt(copy(LPersonId, 5, 2));
        yy := 1900 + yy;
        if not TryEncodeDate(yy, mm, dd, LDate) then
        begin
          yy := yy + 100;
          if not TryEncodeDate(yy, mm, dd, LDate) then
          begin
            ChkBoxOK('Dette er ikke et gyldigt CPR-nummer : ' + LPersonId);
            exit;
          end;
        end;
      end;

      try

        try
          lblCF5name.Caption := '';
          save_index := ffPatKar.IndexName;
          ffPatKar.IndexName := 'NrOrden';
          if ffPatKar.FindKey([LPersonId]) then
          begin
            lblCF5Cprnr.Caption := '&Cprnr';
            lblCF5name.Caption := ffPatKarNavn.AsString;
            lblCF5name.Update;
            // Application.ProcessMessages;
          end;

        finally
          ffPatKar.IndexName := save_index;
        end;
      except
        on e: Exception do
          ChkBoxOK('Fejl ' + e.Message);
      end;

      FMKGetByCPR(LPersonId, LPersonIdSource);

      if lvFMKPrescriptions.Items.Count = 0 then
      begin
        ChkBoxOK('Der er ikke recept til CPR ' + LPersonId);
      end;
      if lvFMKPrescriptions.Items.Count = 1 then
        lvFMKPrescriptions.Items[0].Checked := True;
    finally
      if lvFMKPrescriptions.Items.Count <> 0 then
      begin
        btnGetMedList.Enabled := True;
        btnTakser.Enabled := True;
        if lvFMKPrescriptions.Items.Count > 1 then
          lvFMKPrescriptions.SetFocus;
      end
      else
      begin
        btnGetMedList.Enabled := False;
        btnTakser.Enabled := False;
      end;
      BusyMouseEnd;
    end;
  end;
end;

procedure TStamForm.SendEOrdre(AC2Nr: integer);
var
  doc: IXMLDOMDocument;
  xmlelement: IXMLDOMProcessingInstruction;
  rootelement: IXMLDOMElement;
  EordreElement: IXMLDOMElement;
  Beskedid: string;
  HeaderElement: IXMLDOMElement;
  newelement: IXMLDOMElement;
  Text: IXMLDOMText;
  saveSeparator: Char;
  i: Integer;
  procedure addKunde;
  var
    KundeElement: IXMLDOMElement;

    procedure addHjemmeadresse;
    var
      Hjemadresse: IXMLDOMElement;
    begin
      Hjemadresse := doc.createElement('Hjemmeadresse');
      KundeElement.appendChild(Hjemadresse);

      newelement := doc.createElement('Navn');
      Hjemadresse.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdHjemNavn.AsString);
      newelement.appendChild(Text);

      newelement := doc.createElement('Adresse1');
      Hjemadresse.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdHjemAdresse1.AsString);
      newelement.appendChild(Text);

      if MainDm.nxOrdHjemAdresse2.AsString <> '' then
      begin
        newelement := doc.createElement('Adresse2');
        Hjemadresse.appendChild(newelement);
        Text := doc.createTextNode(MainDm.nxOrdHjemAdresse2.AsString);
        newelement.appendChild(Text);
      end;

      newelement := doc.createElement('Postnummer');
      Hjemadresse.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdHjemPostnummer.AsString);
      newelement.appendChild(Text);

      newelement := doc.createElement('By');
      Hjemadresse.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdHjemBy.AsString);
      newelement.appendChild(Text);

      if MainDm.nxOrdHjemLand.AsString <> '' then
      begin
        newelement := doc.createElement('Land');
        Hjemadresse.appendChild(newelement);
        Text := doc.createTextNode(MainDm.nxOrdHjemLand.AsString);
        newelement.appendChild(Text);
      end;

    end;

    procedure addLeveringsadresse;
    var
      Leveringsadresse: IXMLDOMElement;
    begin
      Leveringsadresse := doc.createElement('Leveringsadresse');
      KundeElement.appendChild(Leveringsadresse);

      newelement := doc.createElement('Navn');
      Leveringsadresse.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdLeveringsNavn.AsString);
      newelement.appendChild(Text);

      newelement := doc.createElement('Adresse1');
      Leveringsadresse.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdLeveringsAdresse1.AsString);
      newelement.appendChild(Text);

      if MainDm.nxOrdLeveringsAdresse2.AsString <> '' then
      begin
        newelement := doc.createElement('Adresse2');
        Leveringsadresse.appendChild(newelement);
        Text := doc.createTextNode(MainDm.nxOrdLeveringsAdresse2.AsString);
        newelement.appendChild(Text);
      end;

      newelement := doc.createElement('Postnummer');
      Leveringsadresse.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdLeveringsPostnummer.AsString);
      newelement.appendChild(Text);

      newelement := doc.createElement('By');
      Leveringsadresse.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdLeveringsBy.AsString);
      newelement.appendChild(Text);

      if MainDm.nxOrdLeveringsLand.AsString <> '' then
      begin
        newelement := doc.createElement('Land');
        Leveringsadresse.appendChild(newelement);
        Text := doc.createTextNode(MainDm.nxOrdLeveringsLand.AsString);
        newelement.appendChild(Text);
      end;

    end;

  begin
    KundeElement := doc.createElement('Kunde');
    EordreElement.appendChild(KundeElement);

    if MainDm.nxOrdKundeCPR.AsString <> '' then
    begin
      newelement := doc.createElement('CPR');
      KundeElement.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdKundeCPR.AsString);
      newelement.appendChild(Text)

    end;

    if MainDm.nxOrdMedlemAfDanmark.AsString <> '' then
    begin
      newelement := doc.createElement('MedlemAfDanmark');
      KundeElement.appendChild(newelement);
      if MainDm.nxOrdMedlemAfDanmark.AsBoolean then
        Text := doc.createTextNode('true')
      else
        Text := doc.createTextNode('false');
      newelement.appendChild(Text);

    end;

    newelement := doc.createElement('Email');
    KundeElement.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdEmail.AsString);
    newelement.appendChild(Text);

    newelement := doc.createElement('Telefon');
    KundeElement.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdTelefon.AsString);
    newelement.appendChild(Text);

    if MainDm.nxOrdMobiletelefon.AsString <> '' then
    begin
      newelement := doc.createElement('Mobiltelefon');
      KundeElement.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdMobiletelefon.AsString);
      newelement.appendChild(Text);
    end;

    addHjemmeadresse;

    addLeveringsadresse;

  end;

  procedure addLevering;
  var
    LeveringElement: IXMLDOMElement;
  begin
    LeveringElement := doc.createElement('Levering');
    EordreElement.appendChild(LeveringElement);

    newelement := doc.createElement('Leveringsmetode');
    LeveringElement.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdLeveringsmetode.AsString);
    newelement.appendChild(Text);

    if MainDm.nxOrdAfhentningssted.AsString <> '' then
    begin
      newelement := doc.createElement('Afhentningssted');
      LeveringElement.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdAfhentningssted.AsString);
      newelement.appendChild(Text);
    end;

    if MainDm.nxOrdAfhentningsstedErApotek.AsString <> '' then
    begin
      newelement := doc.createElement('AfhentningsstedErApotek');
      LeveringElement.appendChild(newelement);
      if MainDm.nxOrdAfhentningsstedErApotek.AsBoolean then
        Text := doc.createTextNode('true')
      else
        Text := doc.createTextNode('false');
      newelement.appendChild(Text);
    end;

  end;

  procedure addBetaling;
  var
    BetalingElement: IXMLDOMElement;
  begin
    BetalingElement := doc.createElement('Betaling');
    EordreElement.appendChild(BetalingElement);

    newelement := doc.createElement('Betalingsmetode');
    BetalingElement.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdBetalingsmetode.AsString);
    newelement.appendChild(Text);

    if MainDm.nxOrdDibsTransaktionsId.AsString <> '' then
    begin
      newelement := doc.createElement('DibsTransaktionsId');
      BetalingElement.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdDibsTransaktionsId.AsString);
      newelement.appendChild(Text);
    end;

    if MainDm.nxOrdDibsOrdrenummer.AsString <> '' then
    begin
      newelement := doc.createElement('DibsOrdrenummer');
      BetalingElement.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdDibsOrdrenummer.AsString);
      newelement.appendChild(Text);
    end;

    if MainDm.nxOrdDibsMerchantId.AsString <> '' then
    begin
      newelement := doc.createElement('DibsMerchantId');
      BetalingElement.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdDibsMerchantId.AsString);
      newelement.appendChild(Text);
    end;

    if MainDm.nxOrdAutoriseretBeloeb.AsString <> '' then
    begin
      newelement := doc.createElement('AutoriseretBeloeb');
      BetalingElement.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdAutoriseretBeloeb.AsString);
      newelement.appendChild(Text);
    end;

    if MainDm.nxOrdHaevetBeloeb.AsString <> '' then
    begin
      newelement := doc.createElement('HaevetBeloeb');
      BetalingElement.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdHaevetBeloeb.AsString);
      newelement.appendChild(Text);
    end;

  end;

  procedure addBeskeder;
  var
    BeskederElement: IXMLDOMElement;
  begin
    if (MainDm.nxOrdBeskedFraKunde.AsString = '') and
      (MainDm.nxOrdBeskedFraApotek.AsString = '') then
      exit;

    BeskederElement := doc.createElement('Beskeder');
    EordreElement.appendChild(BeskederElement);

    if MainDm.nxOrdBeskedFraKunde.AsString <> '' then
    begin
      newelement := doc.createElement('BeskedFraKunde');
      BeskederElement.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdBeskedFraKunde.AsString);
      newelement.appendChild(Text);
    end;
    // hello
    if MainDm.nxOrdBeskedFraApotek.AsString <> '' then
    begin
      newelement := doc.createElement('BeskedFraApotek');
      BeskederElement.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdBeskedFraApotek.AsString);
      newelement.appendChild(Text);
    end;


  end;

  procedure addVarelinjer;
  var
    VareLinjer: IXMLDOMElement;

    procedure addVarelinje;
    var
      VareLinje: IXMLDOMElement;

      procedure addOrdination;
      var
        Ordination: IXMLDOMElement;
      begin
        if MainDm.nxOrdLinOrdinationType.AsString = '' then
          exit;

        Ordination := doc.createElement('Ordination');
        VareLinje.appendChild(Ordination);

        newelement := doc.createElement('Type');
        Ordination.appendChild(newelement);
        Text := doc.createTextNode(MainDm.nxOrdLinOrdinationType.AsString);
        newelement.appendChild(Text);

        newelement := doc.createElement('OrdinationsId');
        Ordination.appendChild(newelement);
        Text := doc.createTextNode(MainDm.nxOrdLinOrdinationsId.AsString);
        newelement.appendChild(Text);

        newelement := doc.createElement('ReceptId');
        Ordination.appendChild(newelement);
        Text := doc.createTextNode(MainDm.nxOrdLinReceptId.AsString);
        newelement.appendChild(Text);

        if MainDm.nxOrdLinApoteketsOrdinationRef.AsString <> '' then
        begin
          newelement := doc.createElement('ApoteketsOrdinationRef');
          Ordination.appendChild(newelement);
          Text := doc.createTextNode(MainDm.nxOrdLinApoteketsOrdinationRef.AsString);
          newelement.appendChild(Text);
        end;

        newelement := doc.createElement('OrdineretAntal');
        Ordination.appendChild(newelement);
        Text := doc.createTextNode(MainDm.nxOrdLinOrdineretAntal.AsString);
        newelement.appendChild(Text);

        newelement := doc.createElement('OrdineretVarenummer');
        Ordination.appendChild(newelement);
        Text := doc.createTextNode(MainDm.nxOrdLinOrdineretVarenummer.AsString);
        newelement.appendChild(Text);

      end;

      procedure addKvitteringsbeloeb;
      var
        Kvitteringsbeloeb: IXMLDOMElement;
      begin
        if MainDm.nxOrdLinSygesikringensAndel.AsString = '' then
          exit;

        Kvitteringsbeloeb := doc.createElement('Kvitteringsbeloeb');
        VareLinje.appendChild(Kvitteringsbeloeb);

        if MainDm.nxOrdLinSygesikringensAndel.AsString <> '' then
        begin
          newelement := doc.createElement('SygesikringensAndel');
          Kvitteringsbeloeb.appendChild(newelement);
          Text := doc.createTextNode(MainDm.nxOrdLinSygesikringensAndel.AsString);
          newelement.appendChild(Text);
        end;

        if MainDm.nxOrdLinKommunensAndel.AsString <> '' then
        begin
          newelement := doc.createElement('KommunensAndel');
          Kvitteringsbeloeb.appendChild(newelement);
          Text := doc.createTextNode(MainDm.nxOrdLinKommunensAndel.AsString);
          newelement.appendChild(Text);
        end;

        if MainDm.nxOrdLinKundeandel.AsString <> '' then
        begin
          newelement := doc.createElement('Kundeandel');
          Kvitteringsbeloeb.appendChild(newelement);
          Text := doc.createTextNode(MainDm.nxOrdLinKundeandel.AsString);
          newelement.appendChild(Text);
        end;

        if MainDm.nxOrdLinCTRbeloeb.AsString <> '' then
        begin
          newelement := doc.createElement('CTRbeloeb');
          Kvitteringsbeloeb.appendChild(newelement);
          Text := doc.createTextNode(MainDm.nxOrdLinCTRbeloeb.AsString);
          newelement.appendChild(Text);
        end;

      end;

    begin
      VareLinje := doc.createElement('Varelinje');
      VareLinjer.appendChild(VareLinje);

      newelement := doc.createElement('Linjenummer');
      VareLinje.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdLinLinjenummer.AsString);
      newelement.appendChild(Text);

      newelement := doc.createElement('Antal');
      VareLinje.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdLinAntal.AsString);
      newelement.appendChild(Text);

      newelement := doc.createElement('Varenummer');
      VareLinje.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdLinVarenummer.AsString);
      newelement.appendChild(Text);

      newelement := doc.createElement('ErSpeciel');
      VareLinje.appendChild(newelement);
      if MainDm.nxOrdLinErSpeciel.AsBoolean then
        Text := doc.createTextNode('true')
      else
        Text := doc.createTextNode('false');
      newelement.appendChild(Text);

      newelement := doc.createElement('Varenavn');
      VareLinje.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdLinVarenavn.AsString);
      newelement.appendChild(Text);

      if MainDm.nxOrdLinForm.AsString <> '' then
      begin
        newelement := doc.createElement('Form');
        VareLinje.appendChild(newelement);
        Text := doc.createTextNode(MainDm.nxOrdLinForm.AsString);
        newelement.appendChild(Text);
      end;

      if MainDm.nxOrdLinStyrke.AsString <> '' then
      begin
        newelement := doc.createElement('Styrke');
        VareLinje.appendChild(newelement);
        Text := doc.createTextNode(MainDm.nxOrdLinStyrke.AsString);
        newelement.appendChild(Text);
      end;

      if MainDm.nxOrdLinPakningsstoerrelse.AsString <> '' then
      begin
        newelement := doc.createElement('Pakningsstoerrelse');
        VareLinje.appendChild(newelement);
        Text := doc.createTextNode(MainDm.nxOrdLinPakningsstoerrelse.AsString);
        newelement.appendChild(Text);
      end;

      newelement := doc.createElement('Substitution');
      VareLinje.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdLinSubstitution.AsString);
      newelement.appendChild(Text);

      newelement := doc.createElement('ListeprisPerStk');
      VareLinje.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdLinListeprisPerStk.AsString);
      newelement.appendChild(Text);

      newelement := doc.createElement('Totallistepris');
      VareLinje.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdLinTotallistepris.AsString);
      newelement.appendChild(Text);

      if MainDm.nxOrdLinApoteketsLinjeRef.AsString <> '' then
      begin
        newelement := doc.createElement('ApoteketsLinjeRef');
        VareLinje.appendChild(newelement);
        Text := doc.createTextNode(MainDm.nxOrdLinApoteketsLinjeRef.AsString);
        newelement.appendChild(Text);
      end;

      addOrdination;

      addKvitteringsbeloeb;


    end;

  begin
    VareLinjer := doc.createElement('Varelinjer');
    EordreElement.appendChild(VareLinjer);

    MainDm.nxOrdLin.First;
    while not MainDm.nxOrdLin.Eof do
    begin
      addVarelinje;
      MainDm.nxOrdLin.Next;
    end;

  end;

  procedure addKvitteringsdata;
  var
    Kvitteringsdata: IXMLDOMElement;

    procedure addCTRInformation;
    var
      CTRInfo: IXMLDOMElement;
    begin
      if not MainDm.EHOrdre then
      begin
        if MainDm.nxOrdCTRperiodeudloeb.AsString = '' then
          exit;
      end;

      CTRInfo := doc.createElement('CTRinformation');
      Kvitteringsdata.appendChild(CTRInfo);

      newelement := doc.createElement('AnvendtCTR');
      CTRInfo.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdAnvendtCTR.AsString);
      newelement.appendChild(Text);

      newelement := doc.createElement('NyBeregnetCTRsaldo');
      CTRInfo.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdNyBeregnetCTRsaldo.AsString);
      newelement.appendChild(Text);

      newelement := doc.createElement('CTRperiodeudloeb');
      CTRInfo.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdCTRperiodeudloeb.AsString);
      newelement.appendChild(Text);

    end;

    procedure addDanmarkInformation;
    var
      DanmarkInfo: IXMLDOMElement;
    begin
      if MainDm.nxOrdTilskudsberettiget.AsString = '' then
        exit;

      DanmarkInfo := doc.createElement('DanmarkInfo');
      Kvitteringsdata.appendChild(DanmarkInfo);

      newelement := doc.createElement('Tilskudsberettiget');
      DanmarkInfo.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdTilskudsberettiget.AsString);
      newelement.appendChild(Text);

      newelement := doc.createElement('IkkeTilskudsberettiget');
      DanmarkInfo.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdIkkeTilskudsberettiget.AsString);
      newelement.appendChild(Text);

    end;

  begin
    if MainDm.nxOrdUdleveringstidspunkt.AsString = '' then
      exit;

    Kvitteringsdata := doc.createElement('Kvitteringsdata');
    EordreElement.appendChild(Kvitteringsdata);

    newelement := doc.createElement('Udleveringstidspunkt');
    Kvitteringsdata.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdUdleveringstidspunkt.AsString);
    newelement.appendChild(Text);

    newelement := doc.createElement('Ekspedient');
    Kvitteringsdata.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdEkspedient.AsString);
    newelement.appendChild(Text);

    newelement := doc.createElement('Udleveringsnummer');
    Kvitteringsdata.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdUdleveringsnummer.AsString);
    newelement.appendChild(Text);

    if MainDm.nxOrdTrackAndTrace.AsString <> '' then
    begin
      newelement := doc.createElement('TrackAndTrace');
      Kvitteringsdata.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdTrackAndTrace.AsString);
      newelement.appendChild(Text);
    end;

    newelement := doc.createElement('SamletKundeandel');
    Kvitteringsdata.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdSamletKundeandel.AsString);
    newelement.appendChild(Text);

    addCTRInformation;

    addDanmarkInformation;

  end;

  procedure addEordreElement;
  begin
    EordreElement := doc.createElement('Eordre');
    rootelement.appendChild(EordreElement);

    newelement := doc.createElement('ApotekNr');
    EordreElement.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdApotekId.AsString);
    newelement.appendChild(Text);

    newelement := doc.createElement('Ordredato');
    EordreElement.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdOrdredato.AsString);
    newelement.appendChild(Text);

    newelement := doc.createElement('Eordrenummer');
    EordreElement.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdEordrenummer.AsString);
    newelement.appendChild(Text);

    newelement := doc.createElement('Kundeeordrenummer');
    EordreElement.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdKundeeordrenummer.AsString);
    newelement.appendChild(Text);

    if Trim(MainDm.nxOrdApoteketsRef.AsString) <> '' then
    begin
      newelement := doc.createElement('Apoteketsref');
      EordreElement.appendChild(newelement);
      Text := doc.createTextNode(MainDm.nxOrdApoteketsRef.AsString);
      newelement.appendChild(Text);
    end;

    newelement := doc.createElement('Genereringsbaggrund');
    EordreElement.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdGenereringsbaggrund.AsString);
    newelement.appendChild(Text);

    newelement := doc.createElement('Ordrestatus');
    EordreElement.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdOrdrestatus.AsString);
    newelement.appendChild(Text);

    newelement := doc.createElement('AfventerKundensGodkendelse');
    EordreElement.appendChild(newelement);
    if MainDm.nxOrdAfventerKundensGodkendelse.AsBoolean then
      Text := doc.createTextNode('true')
    else
      Text := doc.createTextNode('false');
    newelement.appendChild(Text);

    newelement := doc.createElement('AendringerKanAfvises');
    EordreElement.appendChild(newelement);
    if MainDm.nxOrdAendringerKanAfvises.AsBoolean then
      Text := doc.createTextNode('true')
    else
      Text := doc.createTextNode('false');
    newelement.appendChild(Text);

    newelement := doc.createElement('Totallistepris');
    EordreElement.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdTotallistepris.AsString);
    newelement.appendChild(Text);

    newelement := doc.createElement('Fragtpris');
    EordreElement.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdFragtpris.AsString);
    newelement.appendChild(Text);

    newelement := doc.createElement('Totalpris');
    EordreElement.appendChild(newelement);
    Text := doc.createTextNode(MainDm.nxOrdTotalpris.AsString);
    newelement.appendChild(Text);

    newelement := doc.createElement('FraAbonnement');
    EordreElement.appendChild(newelement);
    if MainDm.nxOrdFraAbonnement.AsBoolean then
      Text := doc.createTextNode('true')
    else
      Text := doc.createTextNode('false');
    newelement.appendChild(Text);
    addKunde;
    addLevering;
    addBetaling;
    addBeskeder;
    addVarelinjer;
    addKvitteringsdata;
  end;

begin
  saveSeparator := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := '.';
  BusyMouseBegin;
  try
    if not MainDm.nxord.FindKey([aC2NR]) then
    begin
      ShowMessageBoxWithLogging('SendEordre : Eordre ' + AC2Nr.ToString + ' findes ikke');
      exit;
    end;

    doc := CoDOMDocument.Create;
    xmlelement := doc.createProcessingInstruction('xml', 'version="1.0" encoding="UTF-8"');
    doc.appendChild(xmlelement);
    rootelement := doc.createElement('OpdaterEordreFraApotekRequest');
    rootelement.setAttribute('xsi:schemaLocation',
      'http://schemas.apoteket.dk/integration/apotekssystemer OpdaterEordreFraApotekRequest.xsd');
    rootelement.setAttribute('xmlns', 'http://schemas.apoteket.dk/integration/apotekssystemer');
    rootelement.setAttribute('xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
    doc.appendChild(rootelement);
    MainDm.nxEHSettings.IndexName := 'ApotekIdOrden';
    if not MainDm.nxEHSettings.FindKey(['ADMIN']) then
    begin
      ChkBoxOK('ADMIN record not setup');
      exit;
    end;
    try
      MainDm.nxEHSettings.Edit;
      MainDm.nxEHSettingsBeskedId.AsInteger := MainDm.nxEHSettingsBeskedId.AsInteger + 1;
      MainDm.nxEHSettings.Post;
    except
      on e: Exception do
      begin
        ChkBoxOK(e.Message);
        exit;
      end;
    end;
    Beskedid := MainDm.nxEHSettingsBeskedId.AsString;
    // now get the lager record from the ehsettings
    // nxEHSettings.IndexName := 'LagerOrden';
    // if not nxEHSettings.FindKey([FLagerNr]) then
    // begin
    // ChkBoxOK('Lager record not found in EHSettings');
    // exit;
    // end;
    // add the header
    HeaderElement := doc.createElement('Header');
    rootelement.appendChild(HeaderElement);
    newelement := doc.createElement('Beskedtype');
    Text := doc.createTextNode('OpdaterEordreFraApotekRequest');
    newelement.appendChild(Text);
    HeaderElement.appendChild(newelement);
    newelement := doc.createElement('ApotekNr');
    Text := doc.createTextNode(MainDm.nxOrdApotekId.AsString);
    newelement.appendChild(Text);
    HeaderElement.appendChild(newelement);
    newelement := doc.createElement('BeskedId');
    Text := doc.createTextNode(Beskedid);
    newelement.appendChild(Text);
    HeaderElement.appendChild(newelement);
    newelement := doc.createElement('System');
    Text := doc.createTextNode('1.0.0.1');
    newelement.appendChild(Text);
    HeaderElement.appendChild(newelement);
    addEordreElement;
    c2logadd(doc.xml);

    for i := 1 to 5 do
    begin
      if HTTPSendEordre(doc.xml) then
        break;
      if i < 5 then
        Sleep(1000)
      else
      begin
        c2logadd('Failed 5 times to update eordre');
        ChkBoxOK('E-handel send fejl ');
        try
          C2Env.Log.AddLog('E-handel send fejl:' + sLineBreak + 'E-handel fejlede da den skulle sende en fil.',
            130002,cC2LogPrioritetError);
        except
          on e: Exception do
            c2logadd('Fejlede ved C2Env.Log.AddLog. Fejl: ' + e.Message);
        end;
      end;

    end;

  finally
    FormatSettings.DecimalSeparator := saveSeparator;
    BusyMouseEnd;
  end;

end;

procedure TStamForm.cboForsClick(Sender: TObject);
begin
  case cboFors.ItemIndex of
    0:
      begin
        PakkePageEnter(Sender);
        butRetPakke.Enabled := True;
      end;
    1:
      begin
        FakturaPageEnter(Sender);
        butRetPakke.Enabled := False;
      end;
    2:
      begin
        KontoPageEnter(Sender);
        butRetPakke.Enabled := False;
      end;
  end;

end;

procedure TStamForm.btnTakserClick(Sender: TObject);
var
  ll: TListItem;
  ReceivedLbnr: Integer;
  SetInProgress: Boolean;
  save_prescriptId: string;
  printRecept: Boolean;
  reqsl: TStringList;
  AskNBSQuestion: Boolean;
  LPrescription: TC2FMKPrescription;
  LPrescriptionId: Int64;
  LFMKErrorString: string;
  LPersonId: string;
  LPersonIdSource: TFMKPersonIdentifierSource;
  LQry : TnxQuery;
  LUdstederType : integer;

  procedure AddToCdsOrder(Receptid: Integer);
  var
    PatCPr: string;
    YderNr: string;
    YderCPRNr: string;
    save_index: string;

    procedure AddCDSLines;
    begin
      with MainDm do
      begin
        nxRSEkspLin.First;
        while not nxRSEkspLin.Eof do
        begin
          if nxRSEkspLinAdminCount.AsString = '' then
          begin
            nxRSEkspLin.Next;
            Continue;
          end;
          if nxRSEkspLinDosStartDato.AsString <> '' then
          begin
            if not frmYesNo.NewYesNoBox
              ('En eller flere ordinationer skal dosispakkes.' + sLineBreak +
              'Vil du fortsætte taksering?') then
            begin
              nxRSEkspLin.Next;
              Continue;
            end;
          end;
          cdsOrdLinier.Append;
          cdsOrdLinierVarenr.AsString := nxRSEkspLinVarenNr.AsString.PadLeft(6,'0');
          cdsOrdHeaderOrdAnt.AsInteger := cdsOrdHeaderOrdAnt.AsInteger + 1;
          AdjustIndexName(ffLagKar, 'NrOrden');
          if ffLagKar.FindKey([0, cdsOrdLinierVarenr.AsString]) then
          begin
            c2logadd('found the product  udlevtype is ' + ffLagKarUdlevType.AsString);
            cdsOrdLinierNavn.AsString := ffLagKarNavn.AsString;
            cdsOrdLinierDisp.AsString := ffLagKarForm.AsString;
            cdsOrdLinierStrk.AsString := ffLagKarStyrke.AsString;
            cdsOrdLinierPakn.AsString := ffLagKarPakning.AsString;
            cdsOrdLinierDrugid.AsString := ffLagKarDrugId.AsString;
            cdsOrdLinierOpbevKode.AsString := ffLagKarOpbevKode.AsString;
          end
          else
          begin
            cdsOrdLinierNavn.AsString := nxRSEkspLinNavn.AsString;
            cdsOrdLinierDisp.AsString := nxRSEkspLinForm.AsString;
            cdsOrdLinierStrk.AsString := nxRSEkspLinStyrke.AsString;
            cdsOrdLinierPakn.AsString := nxRSEkspLinPakning.AsString;
            cdsOrdLinierDrugid.AsString := '';
            cdsOrdLinierOpbevKode.AsString := '';
          end;
          if (nxRSEkspLinAdminCount.AsInteger > 0) and (AskNBSQuestion) then
          begin
            AskNBSQuestion := False;
            if MatchText(ffLagKarUdlevType.AsString, ['AP4', 'AP4NB', 'A', 'NBS']) then
            begin
              if not ChkBoxYesNo('Genudlevering af udlevering A, AP4 eller NBS. Vil du fortsætte?', False) then
              begin
                nxRSEkspLin.Next;
                cdsOrdLinier.Cancel;
                Continue;
              end;
            end;
          end;
          cdsOrdLinierSubst.AsString := '';
          if nxRSEkspLinSubstKode.AsString <> '' then
            cdsOrdLinierSubst.AsString := '-S';

          cdsOrdLinierAntal.AsInteger := nxRSEkspLinAntal.AsInteger;
          cdsOrdLinierTilsk.AsString := ''; // todo
          cdsOrdLinierIndKode.AsString := nxRSEkspLinIndCode.AsString; // todo
          cdsOrdLinierIndTxt.AsString := nxRSEkspLinIndText.AsString;
          if nxRSEkspLinIterationNr.AsInteger <> 0 then
            cdsOrdLinierUdlev.AsInteger := nxRSEkspLinIterationNr.AsInteger + 1
          else
            cdsOrdLinierUdlev.AsInteger := 0;
          cdsOrdLinierForhdl.AsString := ''; // todo
          cdsOrdLinierDosKode.AsString := nxRSEkspLinDosKode.AsString; // todo
          cdsOrdLinierDosTxt.AsString := nxRSEkspLinDosTekst.AsString; // todo
          if nxRSEkspLinDosPeriod.AsString <> '' then
            cdsOrdLinierDosTxt.AsString := cdsOrdLinierDosTxt.AsString + ' i ' +
              nxRSEkspLinDosPeriod.AsString + ' ' +
              nxRSEkspLinDosEnhed.AsString;
          cdsOrdLinierPEMAdmDone.AsInteger := 0;
          if nxRSEkspLinAdminCount.AsString <> '' then
            cdsOrdLinierPEMAdmDone.AsInteger := nxRSEkspLinAdminCount.AsInteger;
          cdsOrdLinierOrdid.AsString := nxRSEkspLinOrdId.AsString;
          cdsOrdLinierReceptid.AsInteger := nxRSEkspLinReceptId.AsInteger;
          cdsOrdLinierKlausulBetingelse.AsBoolean :=
            nxRSEkspLinKlausulbetingelse.AsString <> '';
          if (trim(nxRSEkspLinSupplerende.AsString) <> '') or
            (trim(nxRSEkspLinOrdreInstruks.AsString) <> '') or
            (trim(nxRSEkspLinApotekBem.AsString) <> '') then
            if cdsOrdHeaderLevinfo.AsString = '' then
              cdsOrdHeaderLevinfo.AsString := 'Vis Ekspedition';

          cdsOrdLinierOrdineretVarenr.AsString := nxRSEkspLinVarenNr.AsString;
          cdsOrdLinierOrdineretAntal.AsInteger := nxRSEkspLinAntal.AsInteger;
          MainDm.cdsOrdLinierUdstederAutid.AsString := MainDm.nxRSEkspIssuerAutNr.AsString;
          MainDm.cdsOrdLinierUdstederId.AsString := MainDm.nxRSEkspSenderId.asstring;
          MainDm.cdsOrdLinierUdstederType.AsInteger := StamForm.CalculateUdstederType(MainDm.nxRSEkspSenderType.AsString);
          cdsOrdLinier.Post;

          nxRSEkspLin.Next;
        end;
      end;
    end;

  begin
    with MainDm do
    begin
      if not cdsOrdHeader.Active then
        cdsOrdHeader.Open;
      cdsOrdHeader.LogChanges := False;
      cdsOrdHeader.IndexFieldNames := 'PaCprNr;Ydnr;YderCprnr';
      nxRSEksp.IndexName := 'ReceptIdOrder';
      if not nxRSEksp.FindKey([Receptid]) then
        exit;


      // next check each line. if all are completed then messagebox

      save_index := SaveAndAdjustIndexName(nxRSEkspLin, 'ReceptIDOrder');
      nxRSEkspLin.SetRange([Receptid], [Receptid]);
      try
        PatCPr := nxRSEkspPatCPR.AsString;
        YderNr := nxRSEkspSenderId.AsString.PadLeft(7,'0');
        YderCPRNr := trim(nxRSEkspIssuerCPRNr.AsString);
        if YderCPRNr = '' then
          YderCPRNr := trim(nxRSEkspIssuerAutNr.AsString);
        if (cdsOrdHeader.FindKey([PatCPr, YderNr, YderCPRNr])) and
          (not AfstemplingForHverReceptkvittering) then
        begin
          // if we can find the patient / ydernr / ydercprnr in cds then just add the lines
          cdsOrdHeader.Edit; // updates the ordant
          AddCDSLines;
          cdsOrdHeader.Post;
        end
        else
        begin
          cdsOrdHeader.Append;
          cdsOrdHeaderPaCprNr.AsString := PatCPr;
          cdsOrdHeaderYdNr.AsString := YderNr;
          LUdstederType := StamForm.CalculateUdstederType(MainDm.nxRSEkspSenderType.AsString);
          if LUdstederType = 3 then
          begin
            Maindm.cdsOrdHeaderYdNr.AsString  := '0990027';

            if ContainsText(MainDm.nxRSEkspSenderNavn.AsString, 'sygehus') or
              ContainsText(MainDm.nxRSEkspSenderNavn.AsString, 'hospital') then
              Maindm.cdsOrdHeaderYdNr.AsString  := '0994057';

          end;

          cdsOrdHeaderYderCprNr.AsString := YderCPRNr;
          cdsOrdHeaderLbnr.AsInteger := nxRSEkspReceptId.AsInteger;
          cdsOrdHeaderAnnuller.AsBoolean := False;
          SidKundeNr := PatCPr;
          MainDm.cdsOrdHeaderPaNvn.AsString := trim(nxRSEkspPatEftNavn.AsString);
          MainDm.cdsOrdHeaderForNavn.AsString := trim(nxRSEkspPatForNavn.AsString);
          if GemNyeRsFornavnEfternavn then
          begin
            if cdsOrdHeaderForNavn.AsString <> '' then
              cdsOrdHeaderPaNvn.AsString := trim(cdsOrdHeaderForNavn.AsString) +
                ' ' + trim(cdsOrdHeaderPaNvn.AsString);
          end
          else
          begin
            if cdsOrdHeaderForNavn.AsString <> '' then
              MainDm.cdsOrdHeaderPaNvn.AsString :=
                trim(cdsOrdHeaderPaNvn.AsString) + ',' + trim(cdsOrdHeaderForNavn.AsString);
          end;
          cdsOrdHeaderAdr.AsString := nxRSEkspPatVej.AsString;
          cdsOrdHeaderAdr2.AsString := '';
          cdsOrdHeaderPostNr.AsString := nxRSEkspPatPostNr.AsString;
          cdsOrdHeaderBy.AsString := nxRSEkspPatBy.AsString;

          cdsOrdHeaderAmt.AsString := nxRSEkspPatAmt.AsString;
          cdsOrdHeaderTlf.AsString := ''; // todo
          cdsOrdHeaderAlder.AsString := ''; // todo
          cdsOrdHeaderBarn.AsString := ''; // todo
          cdsOrdHeaderTilskud.AsString := ''; // todo
          cdsOrdHeaderTilBrug.AsString := ''; // todo
          cdsOrdHeaderLevering.AsString := nxRSEkspLeveringAdresse.AsString;
          cdsOrdHeaderFriTxt.AsString := '';
          cdsOrdHeaderYdNavn.AsString := nxRSEkspIssuerTitel.AsString;
          cdsOrdHeaderYdSpec.AsString := ''; // todo
          cdsOrdHeaderOrdAnt.AsInteger := 0;
          cdsOrdHeaderSenderType.AsString := nxRSEkspSenderType.AsString;
          cdsOrdHeaderSenderNavn.AsString := nxRSEkspSenderNavn.AsString;
          cdsOrdHeaderIssuerTitel.AsString := nxRSEkspIssuerTitel.AsString;
          if (trim(nxRSEkspLeveringsInfo.AsString) <> '') or
            (trim(nxRSEkspOrdreInstruks.AsString) <> '') or
            (trim(nxRSEkspLeveringPri.AsString) <> '') or
            (trim(nxRSEkspLeveringAdresse.AsString) <> '') or
            (trim(nxRSEkspLeveringPseudo.AsString) <> '') or
            (trim(nxRSEkspLeveringPostNr.AsString) <> '') or
            (trim(nxRSEkspLeveringKontakt.AsString) <> '') then
            cdsOrdHeaderLevinfo.AsString := 'Vis Ekspedition';
          if (trim(nxRSEkspLeveringsInfo.AsString) <> '') then
            cdsOrdHeaderLevinfo.AsString := trim(nxRSEkspLeveringsInfo.AsString);
          AddCDSLines;
          cdsOrdHeader.Post;
        end;
      finally
        nxRSEkspLin.CancelRange;
        nxRSEkspLin.IndexName := save_index;
      end;

    end;
  end;

begin
  if ShowMessageBoxWithLogging(SEHordreTakserWarning,'Warning', MB_YESNO + MB_DEFBUTTON2) <> IDYES then
    exit;

  with MainDm do
  begin
    // does the user still have a certificate before we call fmk routines
    if not maindm.CheckFMKCertificate then
      exit;
    UpdateStatusBrugerInfo;

    // Use the customer no. from edtCprNr.Text and use that for the following lookups
    LPersonId := Trim(edtCprNr.Text);
    LPersonIdSource := TFMKPersonIdentifierSource.DetectSource(LPersonId);

// 08-06-2021/MA: It might not be the person at ffPatkarKundeNr we're about to Takser, so therefore it's changed
//    if not TfrmDosiskort.ShowDoskort(MainDm.ffPatKarKundeNr.AsString,
//      TFMKPersonIdentifierSource.DetectSource(MainDm.ffPatKarKundeNr.AsString)) then
    if not TfrmDosiskort.ShowDoskort(LPersonId, LPersonIdSource) then
      Exit;
    btnTakser.Enabled := False;
    btnGetMedList.Enabled := False;
    SetInProgress := True; // Takser altid 1. markerede ordination
    // if the patient does not exist do not set in progress
    with MainDm do
    begin
      ffPatKar.IndexName := 'NrOrden';
      if not ffPatKar.FindKey([LPersonId]) then
        SetInProgress := False;
    end;
    BusyMouseBegin; { TODO : 08-06-2021/MA: Starting BusyMouseBegin here might interfere with possible dialogs after here }
    reqsl := TStringList.Create;
    MainDm.FejlCF5Ekspedition := False;
    save_prescriptId := '';
    if Udskriv_recept_pop_up then
      printRecept := ChkBoxYesNo('Udskriv receptkvittering?', True)
    else
      printRecept := False;
    // make sure any of the ordination id are not waiting in CF6

    if MainDm.PrescriptionsForPO.MedicineCardIsInvalid then
      { TODO : 08-06-2021/MA: When inside a BusyMouseBegin/End use uC2Ui.Procs.ShowMessageBox to ensure the mouse cursor is show normally and restored afterwards }
      frmYesNo.NewOKBox('Ugyldigt medicinkort indikerer tvivl om dataindhold' +
        sLineBreak + 'og data kan være misvisende.' + sLineBreak +
        ' Kun Sundhedsdatastyrelsen kan ugyldiggøre medicinkort.' + sLineBreak +
        'Ugyldighedsmarkeringen fjernes automatisk ved lægens første' + sLineBreak +
        'ajourføring af medicinkortet foretaget efter ugyldiggørelsen.' + sLineBreak
        + 'Ved tvivl bør apoteket søge recepternes indhold verificeret' + sLineBreak
        + 'hos receptudsteder eller borgerens egen læge.');

    for ll in lvFMKPrescriptions.Items do
    begin
      if not ll.Checked then
        Continue;

      if CheckMedIdInCF6(ll.Caption) then
      begin
        { TODO : 08-06-2021/MA: When inside a BusyMouseBegin/End use uC2Ui.Procs.ShowMessageBox to ensure the mouse cursor is show normally and restored afterwards }
        ChkBoxOK('Ordination ' + ll.Caption + ' er allerede hentet' + sLineBreak + 'Gå til Lokale Recepter [CF6]');
        ll.Checked := False;
        BusyMouseEnd; { TODO : 08-06-2021/MA: BusyMouseEnd should always be called when BusyMouseBegin was called. It's reference counted. I'm not sure this will happen here }
        exit;
      end;
    end;

    try
      SplashScreenShow(Nil, 'Ekspedition', 'Afventer FMK');
      SplashScreenUpdate('');
      try
        CF5Ordlist.Clear;
        for ll in lvFMKPrescriptions.Items do
        begin
          if ll.Checked then
            CF5Ordlist.add(Format('%-20.20s', [ll.Caption]));
        end;

        AskNBSQuestion := True;
        CF5Ordlist.Sort;
        while CF5Ordlist.Count <> 0 do
        begin
          reqsl.add(CF5Ordlist.Strings[0].trim);
          CF5Ordlist.Delete(0);
          if TryStrToInt64(reqsl.Strings[0], LPrescriptionId) then
          begin
            LPrescription := MainDm.PrescriptionsForPO.Prescriptions.
              GetPrescriptionByID(LPrescriptionId);

            if not uFMKGetMedsById.FMKGetPrescriptionById(MainDm.AfdNr,
              LPrescription, SetInProgress, ReceivedLbnr, LFMKErrorString) then
            begin
              ChkBoxOK(LFMKErrorString);
              if SetInProgress then
              begin
                DeleteLocalPrescription(ReceivedLbnr, LPrescriptionId);
              end;

              exit;
            end;
            if printRecept then
            begin
              with MainDm do
              begin
                // tell rsmidsrv to print it

                c2logadd('Call C2FMKMidSrv with receptid ' +
                  ReceivedLbnr.ToString);
                RCPMidCli.SendRequest('GetAddressed',
                  ['4', ReceivedLbnr, inttostr(AfdNr), MainDm.C2UserName, Bool2Str(True)], 10);

                LQry := nxdb.OpenQuery('update rs_ekspeditioner set ReceptStatus=4 where ReceptId=:Receptid', [ReceivedLbnr]);
                try
                  c2logadd('Rowsaffected is ' + inttostr(LQry.RowsAffected));

                finally
                  LQry.Free;
                end;

              end;

            end;

            AddToCdsOrder(ReceivedLbnr);
          end;
          reqsl.Clear;
        end;

      finally
        SplashScreenHide;
      end;
      if MainDm.cdsOrdHeader.RecordCount <> 0 then
        konvCDSBatch(RSLocalPage);

    finally
      if not MainDm.FejlCF5Ekspedition then
        CheckMoreOpenRCP(False);
      CF5Ordlist.Clear;
      reqsl.Free;
      btnTakser.Enabled := True;
      btnGetMedList.Enabled := True;
      BusyMouseEnd;
    end;
  end;

end;

procedure TStamForm.btnEHTakserClick(Sender: TObject);
begin
  if MainDm.nxOrdPrintStatus.AsInteger in [2, 4] then
    if not ChkBoxYesNo('Ehandel-ordren er takseret. Skal den takseres igen?', False) then
      exit;

  if MainDm.nxOrdPrintStatus.AsInteger = 99 then
    if not ChkBoxYesNo('Denne ordre er annulleret. Ønsker du at ekspedere alligevel?', False) then
      exit;

  TakserEh(MainDm.nxOrdC2Nr.AsInteger);
  dbgEHOrd.SetFocus;
end;

procedure TStamForm.btnSearchReceptClick(Sender: TObject);
var
    lBirthDate: TDateTime;
begin

  // does the user still have a certificate before we call fmk routines
  if not CurrentLogonIsValid(MainDm.Bruger, MainDm.Afdeling, ltAll) then
  begin
    Close;
    exit;
  end;
  UpdateStatusBrugerInfo;

  BusyMouseBegin;
  btnGetMedList.Enabled := False;
  lvFMKPrescriptions.Clear;
  ListView2.Clear;
  try
    if (length(trim(edtForNavn.Text)) < 2) then
    begin
      ChkBoxOK( 'For- og efternavn skal udfyldes med mindst 2 karakterer samt fødselsdag eller postnummer.' + #13#10 +
                'For personer uden CPR nummer marker ''Uden CPR''' );
      exit;
    end;

    if (length(trim(edtEftNavn.Text)) < 2) then
    begin
      ChkBoxOK( 'For- og efternavn skal udfyldes med mindst 2 karakterer samt fødselsdag eller postnummer.' + #13#10 +
                'For personer uden CPR nummer marker ''Uden CPR''' );
      exit;
    end;

    if cxDateFoedselsdato.Date = NullDate then
      LBirthDate := 0
    else
      LBirthDate := cxDateFoedselsdato.Date;


    if (LBirthDate = 0) and (trim(edtPostNr.Text) = '') and (not chkUdenCPR.Checked) then
    begin
      ChkBoxOK( 'For- og efternavn skal udfyldes med mindst 2 karakterer samt fødselsdag eller postnummer.' + #13#10 +
                'For personer uden CPR nummer marker ''Uden CPR''' );
      exit;
    end;


    uFMKCalls.FMKSearchPrescriptions(ListView2,Trim(edtForNavn.Text),
      Trim(edtEftNavn.Text),LBirthDate,chkUdenCPR.Checked,Trim(edtPostNr.Text));
    if ListView2.Items.Count = 0 then
      exit;

    // code commented out to stop auto selection of possibly the wrong patient

//    if ListView2.Items.Count = 1 then
//    begin
//      LListItem := ListView2.Items[0];
//      if LListItem.Caption <> '' then
//      begin
//        edtCprNr.Text := LListItem.Caption;
//        VisOrdCprNr;
//        exit;
//      end;
//    end;
//    save_CPR := '';
//    for LListItem in ListView2.Items do
//    begin
//      if (save_CPR <> '') and (save_CPR <> LListItem.Caption) then
//      begin
//        if ListView2.Items.Count > 1 then
//          ListView2.SetFocus;
//        exit;
//      end;
//      save_CPR := LListItem.Caption;
//    end;
//    if save_CPR <> '' then
//    begin
//      edtCprNr.Text := save_CPR;
//      VisOrdCprNr;
//    end;
    ListView2.ItemIndex := 0;
    ListView2.SetFocus;
  finally
    BusyMouseEnd;
  end;

end;

procedure TStamForm.RSLocalPageShow(Sender: TObject);
var
  found: Boolean;
begin
  with MainDm do
  begin
    c2logadd('RslocalPageShow fired');
    nxRSEkspList.Filtered := False;
    dtpDatoFra.Date := Date - VisRecepterCF6;
    dtpTidFra.Time := StrToTime('00:00:00');
    dtpDatoTil.Date := IncDay(dtpDatoFra.Date,VisRecepterCF6);
    dtpTidTil.Time := StrToTime('23:59:59');
    // edtCPRNr1.Text := SidKundeNr;
    // edtCprNr1    .Text    := ffPatKarKundeNr.AsString;

    edtForNavn1.Text := '';
    edtEftNavn1.Text := '';
    // edtPraksis  .Text    := '';
    edtYdNavn.Text := '';
    edtReason.Text := '';
    lbLager.Clear;
    lbLager.Items.add('Alle lagre');
    lbLager.ItemIndex := 0;
    AdjustIndexName(nxSettings, 'AfdelingOrder');
    nxSettings.First;
    while Not nxSettings.Eof do
    begin
      lbLager.Items.AddObject(nxSettingsAfdelingNavn.AsString, TObject(nxSettingsAfdeling.AsInteger));
      C2LogAddF('afdnr is %d', [MainDm.AfdNr]);
      C2LogAddF('nxSettingsAfdeling  is %d',[nxSettingsAfdeling.AsInteger]);
      if nxSettingsAfdeling.AsInteger = MainDm.AfdNr then
        lbLager.ItemIndex := lbLager.Items.Count - 1;
      C2LogAddF('lblager itemindex is %d', [lbLager.ItemIndex]);
      nxSettings.Next;
    end;
    if lbLager.Items.Count = 2 then
    begin
      lbLager.Items.Delete(1);
      lbLager.ItemIndex := 0;
    end;
    lbLager.ItemIndex := 0;
    if Save_lbLagerIndex <> 0 then
      lbLager.ItemIndex := Save_lbLagerIndex;
    C2LogAddF('lbl lager item index is %d',[lbLager.ItemIndex]);
    AdjustIndexName(nxSettings, 'AfdelingOrder');
    if not nxSettings.FindKey([MainDm.AfdNr]) then
      nxSettings.First;
    butFilter.Click;
    if JumpToZeroLbnr then
    begin
      JumpToZeroLbnr := False;
      found := False;
      if nxRSEkspList.RecordCount <> 0 then
      begin
        nxRSEkspList.First;
        while not nxRSEkspList.Eof do
        begin
          if nxRSEkspListLbNr.AsInteger = 0 then
          begin
            found := True;
            break;
          end;
          nxRSEkspLinList.First;
          while not nxRSEkspLinList.Eof do
          begin
            if nxRSEkspLinListRSLbnr.AsInteger = 0 then
            begin
              found := True;
              break;
            end;
            nxRSEkspLinList.Next;
          end;
          if found then
            break;
          nxRSEkspList.Next;
        end;
      end;
      if not found then
        nxRSEkspList.First;
      dbgLocalRS.SetFocus;
    end
    else

      edtCPRNr1.SetFocus;
  end;

end;

procedure TStamForm.butFilterClick(Sender: TObject);
var
  Filter, DatoFra, DatoTil: String;
  date1: TDateTime;
  date2: TDateTime;
  procedure AddFilterVal(V, M: String; var F: String);
  begin
    if Trim(V) <> '' then
    begin
      if not F.IsEmpty then
        F := F + ' AND ';
      F := F + '(' + M + ' LIKE '#39#37 + Trim(caps(V)) + #37#39 + ')';
    end;
  end;

begin
  with MainDm do
  begin
    BusyMouseBegin;
    nxRSEkspList.DisableControls;
    nxRSEkspLinList.DisableControls;
    try
      try
        CF6Selected.Clear;
        dbgLocalRS.Columns[0].Title.Font.Style := [];
        dbgLocalRS.Columns[1].Title.Font.Style := [];
        if edtCPRNr1.Text <> CF6_SaveCPRNr then
        begin
          dtpDatoFra.Date := Date - VisRecepterCF6;
          dtpTidFra.Time := StrToTime('00:00:00');
          dtpDatoTil.Date := IncDay(dtpDatoFra.Date,VisRecepterCF6);
          dtpTidTil.Time := StrToTime('23:59:59');
          CF6_SaveCPRNr := edtCPRNr1.Text;
        end;

        Filter := '';
        if DaysBetween(dtpDatoFra.Date,dtpDatoTil.Date) > VisRecepterCF6 then
        begin
          if CF6DateWarning then
          begin
            ShowMessageWithTimeOut('Søgning er ændret til ' + VisRecepterCF6.ToString + ' dage!',ID_OK,10,'Bemærk slutdato');
            CF6DateWarning := False;
          end;

          dtpDatoTil.Date := IncDay(dtpDatoFra.Date,VisRecepterCF6);
        end;
        if trunc(dtpDatoFra.Date) > trunc(dtpDatoTil.Date) then
          dtpDatoTil.Date := IncDay(dtpDatoFra.Date,VisRecepterCF6);
        if trunc(dtpDatoTil.Date) > trunc(Date) then
          dtpDatoTil.Date:= trunc(Date);
        Save_Datofra := dtpDatoFra.Date;

        date1 := EncodeDateTime(YearOf(dtpDatoFra.Date),
          MonthOf(dtpDatoFra.Date), DayOf(dtpDatoFra.Date),
          HourOf(dtpTidFra.DateTime), MinuteOf(dtpTidFra.DateTime), 0, 0);
        date2 := EncodeDateTime(YearOf(dtpDatoTil.Date),
          MonthOf(dtpDatoTil.Date), DayOf(dtpDatoTil.Date),
          HourOf(dtpTidTil.DateTime), MinuteOf(dtpTidTil.DateTime), 59, 0);

        if Trim(edtCPRNr1.Text) <> '' then
        begin
          AdjustIndexName(nxRSEkspList, 'CPROrden');
          nxRSEkspList.SetRange([Trim(edtCPRNr1.Text)], [Trim(edtCPRNr1.Text)]);
          nxRSEkspList.FlipOrder := False;
          Save_Datofra := dtpDatoFra.Date;
          DatoFra := FormatDateTime('YYYY-MM-DD hh:mm:ss', DateOf(dtpDatoFra.Date) + TimeOf (dtpTidFra.Time));
          DatoTil := FormatDateTime('YYYY-MM-DD hh:mm:ss', DateOf(dtpDatoTil.Date) + TimeOf(dtpTidTil.Time));
          Filter := '(Dato>=' + 'CAST('#39 + DatoFra + #39 + ' AS DATETIME)) AND'
            + '(Dato<=' + 'CAST('#39 + DatoTil + #39 + ' AS DATETIME))';

        end
        else
        begin
          nxRSEkspList.Filtered := False;
          nxRSEkspList.CancelRange;
          AdjustIndexName(nxRSEkspList, 'DatoOrden');



          if nxRSEkspList.FlipOrder then
            nxRSEkspList.SetRange([date2], [date1])
          else
            nxRSEkspList.SetRange([date1], [date2]);

        end;
        AddFilterVal(edtForNavn1.Text, 'UPPER(PatForNavn)', Filter);
        AddFilterVal(edtEftNavn1.Text, 'UPPER(PatEftNavn)', Filter);
        AddFilterVal(edtYderNr.Text, 'SenderId', Filter);
        AddFilterVal(edtYdNavn.Text, 'UPPER(IssuerTitel)', Filter);
        if edtPraksis.Text <> '' then
        begin
          if not Filter.IsEmpty then
            Filter := Filter + ' AND ';

          Filter := Filter + '(' +
            '(UPPER(cast(SenderNavn as shortstring(255) locale 1030)) LIKE ' +
            #39#37 + Trim(caps(edtPraksis.Text)) + #37#39 + ')' + ' OR ' +
            '(UPPER(cast(Leveringsinfo as shortstring(255) locale 1030)) LIKE '
            + #39#37 + Trim(caps(edtPraksis.Text)) + #37#39 + ')' + ' OR ' +
            '(UPPER(cast(SenderSystem as shortstring(255) locale 1030)) LIKE ' +
            #39#37 + Trim(caps(edtPraksis.Text)) + #37#39 + ')' + ' OR ' +
            '(UPPER(cast(LeveringPseudo as shortstring(255) locale 1030)) LIKE '
            + #39#37 + Trim(caps(edtPraksis.Text)) + #37#39 + ')' + ' OR ' +
            '(UPPER(cast(LeveringAdresse as shortstring(255) locale 1030)) LIKE '
            + #39#37 + Trim(caps(edtPraksis.Text)) + #37#39 + ')' + ' OR ' +
            '(UPPER(cast(LeveringPri as shortstring(255) locale 1030)) LIKE ' +
            #39#37 + Trim(caps(edtPraksis.Text)) + #37#39 + ')' + ')';
          // DatoFra:= FormatDateTime('YYYY-MM-DD hh:mm:ss', trunc(dtpDatoFra.Date) + frac(dtpTidFra.Time));
          // DatoTil:= FormatDateTime('YYYY-MM-DD hh:mm:ss', trunc(dtpDatoTil.Date) + frac(dtpTidTil.Time) );
          // Filter := '(CAST(Dato AS DATETIME)>=' +
          // 'CAST('#39 + DatoFra + #39 + ' AS DATETIME)) AND' +
          // '(CAST(Dato AS DATETIME)<=' +
          // 'CAST('#39 + DatoTil + #39 + ' AS DATETIME))';

        end;
        Save_lbLagerIndex := lbLager.ItemIndex;
        if lbLager.ItemIndex > 0 then
        begin
          if not Filter.IsEmpty then
            Filter := Filter + ' AND ';
          Filter := Filter + 'Afdeling=' + inttostr(Integer(lbLager.Items.Objects[lbLager.ItemIndex]))
        end;

        if cboVisDosis.ItemIndex in [2,3,4] then
          nxRSEkspList.OnFilterRecord := nxRSEkspListFilterRecord
        else
          nxRSEkspList.OnFilterRecord := Nil;

        if cboVisDosis.ItemIndex = 2 then
        begin
          if not Filter.IsEmpty then
            Filter := Filter + ' AND ';
          Filter := Filter + '(lbnr =0)';
        end;

        if cboVisDosis.ItemIndex = 1 then
        begin
          if not Filter.IsEmpty then
            Filter := Filter + ' AND ';
          Filter := Filter + '(PatCPR is null or PatCPR ='''')';
        end;
        c2logadd('Filter "' + Filter + '"');

        nxRSEkspList.Filtered := False;
        nxRSEkspList.Filter := Filter;
        nxRSEkspList.Filtered := True;
        nxRSEkspList.Refresh;
        nxRSEkspLinList.Refresh;
        nxRSEkspList.First;
      except
        on e: Exception do
          ChkBoxOK('Exception, "' + e.Message + '"');
      end;
    finally
      nxRSEkspList.EnableControls;
      nxRSEkspLinList.EnableControls;
      BusyMouseEnd;
    end;
  end;

end;

procedure TStamForm.dbgLocalRSTitleClick(Column: TColumn);
begin
  case Column.Index of
    0:
      begin
        AdjustIndexName(MainDm.nxRSEkspList, 'ReceptIdOrder');
        MainDm.nxRSEkspList.FlipOrder := True;
        MainDm.nxRSEkspList.First;
        dbgLocalRS.Columns[0].Title.Font.Style := [fsBold];
        dbgLocalRS.Columns[1].Title.Font.Style := [];
      end;
    1:
      begin
        AdjustIndexName(MainDm.nxRSEkspList, 'LbnrOrder');
        MainDm.nxRSEkspList.FlipOrder := False;
        MainDm.nxRSEkspList.First;
        dbgLocalRS.Columns[0].Title.Font.Style := [];
        dbgLocalRS.Columns[1].Title.Font.Style := [fsBold];
      end;
  end;

end;

procedure TStamForm.btnUdskrivClick(Sender: TObject);
begin

  RCPMidCli.SendRequest('GetAddressed',
    ['4', MainDm.nxRSEkspListReceptId.AsString, inttostr(MainDm.AfdNr), MainDm.C2UserName], 10);
end;

procedure TStamForm.btnAnnulClick(Sender: TObject);
var
  LPrescriptionId : int64;
  LCPRNr: string;
begin
  // does the user still have a certificate before we call fmk routines
  if not CurrentLogonIsValid(maindm.Bruger,maindm.Afdeling,ltAll) then
  begin
    Close;
    exit;
  end;
  UpdateStatusBrugerInfo;

  with MainDm do
  begin

    if nxRSEkspListPatCPR.AsString = '' then
    begin
      if pos('PersonID:', nxRSEkspListLeveringsInfo.AsString) = 0 then
      begin
        ChkBoxOK('Brug knappen AFSLUT når recepter uden CPRnumre skal fjernes!');
        exit;
      end;
    end;
    if Trim(edtReason.Text) = '' then
    begin
      ChkBoxOK('Husk at angive en årsag til annullering!');
      exit;
    end;

    if not ChkBoxYesNo('Skal recepten ugyldiggøres?', True) then
      exit;

    BusyMouseBegin;
    try
      if TryStrToInt64(nxRSEkspLinListOrdId.AsString,LPrescriptionId) then
      begin
        LCPRNr := nxRSEkspListPatCPR.AsString;
        if not nxRSEkspListPatPersonIdentifier.AsString.IsEmpty then
          LCPRNr := nxRSEkspListPatPersonIdentifier.AsString;
        if uFMKCalls.FMKInvalidate(LCPRNr,LPrescriptionId, nxRSEkspLinListReceptId.AsInteger, edtReason.Text,nxdb) then
        begin
          C2LogAdd('invalidate was successful');
        end;
      end;
    finally
      nxRSEkspList.Refresh;
      nxRSEkspLinList.Refresh;
      BusyMouseEnd;
    end;
  end;
end;

procedure TStamForm.btnBeskederClick(Sender: TObject);
begin
  if TfrmBeskeder.updateBeskeder then
    SendEOrdre(MainDm.nxOrdC2Nr.AsInteger);

end;

procedure TStamForm.btnTilbageClick(Sender: TObject);
var
  sl: TStringList;
  LReceptID : integer;
  LPersonId: string;
  LPersonIdSource: TFMKPersonIdentifierSource;
begin
  // does the user still have a certificate before we call fmk routines
  if not CurrentLogonIsValid(maindm.Bruger,maindm.Afdeling,ltAll) then
  begin
    Close;
    exit;
  end;
  UpdateStatusBrugerInfo;

  with MainDm do
  begin
    c2logadd('Tilbage pressed');
    if nxRSEkspListPatCPR.AsString = '' then
    begin
      if pos('PersonID:', nxRSEkspListLeveringsInfo.AsString) = 0 then
      begin
        ChkBoxOK('Brug knappen AFSLUT når recepter uden CPRnumre skal fjernes!');
        exit;
      end;
    end;

    if nxRSEkspLinListRSLbnr.AsInteger > 0 then
    begin
      ChkBoxOK('Der tilbagesendes automatisk, når ordinationen tilbageføres og afsluttes.');
      exit;
    end;
    if nxRSEkspListReceptStatus.AsInteger > 90 then
    begin
      c2logadd('**** Tilbage requested for ReceptStatus > 90');
      if not frmYesNo.NewYesNoBox
        ('Det ser ud til, at der er (eller har været) en igangværende ekspedition på denne receptkvittering.'
        + #13#10 +
        'Er du sikker på, at den skal sendes tilbage til FMK?') then
        exit;
      c2logadd('**** Tilbage ACCEPTED with receptstatus >90');
    end;
    sl := TStringList.Create;
    BusyMouseBegin;
    try
      // if we have an administration then we removbe status on fmk server
      if nxRSEkspLinListAdministrationId.AsLargeInt <> 0 then
      begin

        c2logadd('Call RemoveStatus CPR=' + nxRSEkspListPatCPR.AsString +
          ' OrdId= ' + nxRSEkspLinListOrdId.AsString);
        if not nxRSEkspListPatPersonIdentifier.AsString.IsEmpty then
        begin
          LPersonId := nxRSEkspListPatPersonIdentifier.AsString;
          LPersonIdSource := TFMKPersonIdentifierSource.Parse(nxRSEkspListPatPersonIdentifierSource.AsInteger);
        end
        else
        begin
          LPersonId := nxRSEkspListPatCPR.AsString;
          LPersonIdSource := TFMKPersonIdentifierSource.DetectSource(LPersonId);
        end;

        if ufmkcalls.FMKRemoveStatus(AfdNr,
           LPersonId, LPersonIdSource, nxRSEkspListReceptId.AsInteger,
           nxRSEkspLinListPrescriptionIdentifier.AsLargeInt,
           nxRSEkspLinListOrderIdentifier.AsLargeInt,MainDm.nxdb) then
        begin
          c2logadd('remove status on Administration successful');

        end
        else
        begin
          if ChkBoxYesNo('Skal den bare slettes lokalt?', True) then
          begin
            LReceptID := nxRSEkspLinListReceptId.AsInteger;
            nxRSEkspLinList.Delete;

            // check to see if there are no lines with this recept id.
            nxRSEkspLin.IndexName := 'ReceptIDOrder';
            if not nxRSEkspLin.FindKey([LReceptId]) then
            begin
              nxRSEksp.IndexName := 'ReceptIdOrder';
              if nxRSEksp.FindKey([LReceptId]) then
                nxRSEksp.Delete;
            end;


          end;


        end;
      end
      else
      begin
        // no administration id so just delete locally
        if ChkBoxYesNo( 'Ordinationen har ikke status Ekspedition påbegyndt på FMK.' + sLineBreak +
                        'Skal den bare slettes lokalt?',True) then
        begin
          LReceptID := nxRSEkspLinListReceptId.AsInteger;
          nxRSEkspLinList.Delete;

          // check to see if there are no lines with this recept id.
          nxRSEkspLin.IndexName := 'ReceptIDOrder';
          if not nxRSEkspLin.FindKey([LReceptId]) then
          begin
            nxRSEksp.IndexName := 'ReceptIdOrder';
            if nxRSEksp.FindKey([LReceptId]) then
              nxRSEksp.Delete;
          end;


        end;


      end;
    finally
      nxRSEkspList.Refresh;
      sl.Free;
      BusyMouseEnd;
    end;
  end;

end;

procedure TStamForm.btnTurNrClick(Sender: TObject);
var
  itmp: Integer;
begin
  with MainDm do
  begin
    itmp := StrToIntDef(edtTurnr.Text, -1);
    if itmp = -1 then
    begin
      ChkBoxOK('Tur-nummer kan ikke være større end 9');
      exit;
    end;
    if (itmp < 0) or (itmp > 9) then
    begin
      ChkBoxOK('Tur-nummer kan ikke være større end 9');
      exit;
    end;
    try

      if not ChkBoxYesNo('Ret turnr fra ' + ffEksOvrTurNr.AsString + ' til ' +
        edtTurnr.Text, True) then
        exit;

      ffEksOvr.Edit;
      ffEksOvrTurNr.AsInteger := itmp;
      ffEksOvr.Post;
    except
      on e: Exception do
      begin
        ChkBoxOK(e.Message);
        c2logadd('Ret Turnr exception ' + e.Message);
      end;
    end;

  end;
end;

procedure TStamForm.btnAfslutClick(Sender: TObject);
var
  sl: TStringList;
begin
  // does the user still have a certificate before we call fmk routines
  if not CurrentLogonIsValid(maindm.Bruger,maindm.Afdeling,ltAll) then
  begin
    Close;
    exit;
  end;
  UpdateStatusBrugerInfo;

  with MainDm do
  begin

    if not ChkBoxYesNo
      ('Recepten vil få status Afsluttet på FMK. Er du sikker?',
      False) then
      exit;
    sl := TStringList.Create;
    BusyMouseBegin;
    try
      if uFMKCalls.FMKTerminatePrescription(nxRSEkspListPatCPR.AsString,
            nxRSEkspListPatPersonIdentifier.AsString, nxRSEkspListPatPersonIdentifierSource.AsInteger,
      StrToInt64(nxRSEkspLinListOrdId.AsString),
        nxRSEkspListSenderId.AsString,nxRSEkspListSenderType.AsString, nxdb)
      then
      begin
        c2logadd('Ordination terminated successfully');
      end;

    finally
      MainDm.nxRSEkspList.Refresh;
      MainDm.nxRSEkspLinList.Refresh;
      sl.Free;
      BusyMouseEnd;
    end;
  end;
end;

procedure TStamForm.bitbtnTakserClick(Sender: TObject);
var
  ReceivedLbnr: Integer;
  save_prescriptId: string;
  UdskrivQuestion: Boolean;
  UdskrivAnswer: Boolean;
  BMark: TBookmark;
  AskNBSQuestion: Boolean;
  AskRetakserQuestion: Boolean;
  AddHeader: Boolean;
  LKundenr : string;
  LSetInProgress : boolean;
  LIsAppOrder : boolean;

  procedure AddToCdsOrd;
  var
    PatCPr: string;
    YderNr: string;
    YderCPRNr: string;
    strVarenr: string;
    ValidOrdIdList: TStringList;
    LUdstederType: integer;
    procedure AddCDSLines;
    begin
      with MainDm do
      begin
        c2logadd('AddCDSLines called');
        nxRSEkspLinList.First;
        while not nxRSEkspLinList.Eof do
        begin
          // only add those ordid that were set in progress
          if ValidOrdIdList.IndexOf(nxRSEkspLinListOrdId.AsString) = -1 then
          begin
            nxRSEkspLinList.Next;
            Continue;
          end;
          if (nxRSEkspLinListRSLbnr.AsInteger <> 0) and (AskRetakserQuestion)
          then
          begin
            AskRetakserQuestion := False;
            if not ChkBoxYesNo('Recepten er allerede ekspederet. Vil du ekspedere igen?', False) then
            begin
              nxRSEkspLinList.Next;
              Continue;
            end;
          end;
          if nxRSEkspLinListDosStartDato.AsString <> '' then
          begin
            if not frmYesNo.NewYesNoBox('En eller flere ordinationer skal dosispakkes.' + sLineBreak +
              'Vil du fortsætte taksering?') then
            begin
              nxRSEkspLinList.Next;
              Continue;
            end;
          end;
          if nxRSEkspLinListFrigivStatus.AsInteger = 1 then
          begin
            nxRSEkspLinList.Next;
            Continue;
          end;
          cdsOrdLinier.Append;
          ffLagKar.IndexName := 'NrOrden';
          strVarenr := FixLFill('0', 6, nxRSEkspLinListVarenNr.AsString);
          if ffLagKar.FindKey([0, strVarenr]) then
          begin
            c2logaddF('found the product udlevtype is %s', [ffLagKarUdlevType.AsString]);
            cdsOrdLinierNavn.AsString := ffLagKarNavn.AsString;
            cdsOrdLinierDisp.AsString := ffLagKarForm.AsString;
            cdsOrdLinierStrk.AsString := ffLagKarStyrke.AsString;
            cdsOrdLinierPakn.AsString := ffLagKarPakning.AsString;
            cdsOrdLinierDrugid.AsString :=  ffLagKarDrugId.AsString;
            cdsOrdLinierOpbevKode.AsString := ffLagKarOpbevKode.AsString;
          end
          else
          begin
            cdsOrdLinierNavn.AsString := nxRSEkspLinListNavn.AsString;
            cdsOrdLinierDisp.AsString := nxRSEkspLinListForm.AsString;
            cdsOrdLinierStrk.AsString := nxRSEkspLinListStyrke.AsString;
            cdsOrdLinierPakn.AsString := nxRSEkspLinListPakning.AsString;
            cdsOrdLinierDrugid.AsString :=  '';
            cdsOrdLinierOpbevKode.AsString := '';
          end;

          if nxRSEkspLinListAdminCount.AsString <> '' then
          begin

            if (nxRSEkspLinListAdminCount.AsInteger > 0) and (AskNBSQuestion)
            then
            begin
              AskNBSQuestion := False;
              if MatchText(ffLagKarUdlevType.AsString, ['AP4', 'AP4NB', 'A', 'NBS']) then
              begin
                if not ChkBoxYesNo('Genudlevering af udlevering A, AP4 eller NBS. Vil du fortsætte?', False) then
                begin
                  nxRSEkspLinList.Next;
                  cdsOrdLinier.Cancel;
                  Continue;
                end;
              end;
            end;
          end;

          cdsOrdLinierVarenr.AsString := FixLFill('0', 6, nxRSEkspLinListVarenNr.AsString);
          cdsOrdHeaderOrdAnt.AsInteger := cdsOrdHeaderOrdAnt.AsInteger + 1;
          cdsOrdLinierSubst.AsString := '';
          if nxRSEkspLinListSubstKode.AsString <> '' then
            cdsOrdLinierSubst.AsString := '-S';

          cdsOrdLinierAntal.AsInteger := nxRSEkspLinListAntal.AsInteger;
          cdsOrdLinierTilsk.AsString := ''; // todo
          cdsOrdLinierIndKode.AsString := nxRSEkspLinListIndCode.AsString;
          // todo
          cdsOrdLinierIndTxt.AsString := nxRSEkspLinListIndText.AsString;
          if nxRSEkspLinListIterationNr.AsInteger <> 0 then
            cdsOrdLinierUdlev.AsInteger :=
              nxRSEkspLinListIterationNr.AsInteger + 1
          else
            cdsOrdLinierUdlev.AsInteger := 0;
          cdsOrdLinierForhdl.AsString := ''; // todo
          cdsOrdLinierDosKode.AsString := nxRSEkspLinListDosKode.AsString;
          // todo
          cdsOrdLinierDosTxt.AsString := nxRSEkspLinListDosTekst.AsString;
          // todo
          if nxRSEkspLinListDosPeriod.AsString <> '' then
            cdsOrdLinierDosTxt.AsString := cdsOrdLinierDosTxt.AsString + ' i ' +
              nxRSEkspLinListDosPeriod.AsString + ' ' +
              nxRSEkspLinListDosEnhed.AsString;
          cdsOrdLinierPEMAdmDone.AsInteger := 0;
          if nxRSEkspLinListAdminCount.AsString <> '' then
            cdsOrdLinierPEMAdmDone.AsInteger :=
              nxRSEkspLinListAdminCount.AsInteger;
          cdsOrdLinierOrdid.AsString := nxRSEkspLinListOrdId.AsString;
          cdsOrdLinierReceptid.AsInteger := nxRSEkspLinListReceptId.AsInteger;
          cdsOrdLinierKlausulBetingelse.AsBoolean :=
            nxRSEkspLinListKlausulbetingelse.AsString <> '';
          if (Trim(nxRSEkspLinListSupplerende.AsString) <> '') or
            (Trim(nxRSEkspLinListOrdreInstruks.AsString) <> '') or
            (Trim(nxRSEkspLinListApotekBem.AsString) <> '') then
            if cdsOrdHeaderLevinfo.AsString = '' then
              cdsOrdHeaderLevinfo.AsString := 'Vis Ekspedition';
          cdsOrdLinierOrdineretVarenr.AsString := nxRSEkspLinListVarenNr.AsString;
          cdsOrdLinierOrdineretAntal.AsInteger := nxRSEkspLinListAntal.AsInteger;
          MainDm.cdsOrdLinierUdstederAutid.AsString := MainDm.nxRSEkspListIssuerAutNr.AsString;
          MainDm.cdsOrdLinierUdstederId.AsString := MainDm.nxRSEkspListSenderId.asstring;
          MainDm.cdsOrdLinierUdstederType.AsInteger := StamForm.CalculateUdstederType(MainDm.nxRSEkspListSenderType.AsString);
          cdsOrdLinier.Post;
          nxRSEkspLinList.Next;
        end;
        c2logadd('End of AddCdsLines');
      end;
    end;

  begin
    with MainDm do
    begin
      ValidOrdIdList := TStringList.Create;
      try
        if not cdsOrdHeader.Active then
          cdsOrdHeader.Open;
        cdsOrdHeader.LogChanges := False;
        cdsOrdHeader.IndexFieldNames := 'PaCprNr;Ydnr;YderCprnr';
        PatCPr := nxRSEkspListPatCPR.AsString;
        YderNr := FixLFill('0', 7, nxRSEkspListSenderId.AsString);
        YderCPRNr := Trim(nxRSEkspListIssuerCPRNr.AsString);
        if YderCPRNr = '' then
          YderCPRNr := Trim(nxRSEkspListIssuerAutNr.AsString);
        AskNBSQuestion := True;
        AskRetakserQuestion := True;
        nxRSEkspLinList.First;
        LKundenr := PatCPr;
        if not nxRSEkspListPatPersonIdentifier.AsString.IsEmpty then
          LKundenr := nxRSEkspListPatPersonIdentifier.AsString;
        LSetInProgress := True;
        if not PatCPr.IsEmpty then
        begin
          if not ffPatKar.FindKey([Patcpr]) then
            LSetInProgress := False;
        end;

        while not nxRSEkspLinList.Eof do
        begin
          if uFMKGetMedsById.RefreshReceivedMedications(LKundenr,
                    nxRSEkspLinListPrivat.AsInteger,
                    nxRSEkspLinListOrdId.AsString,
                    AfdNr,nxRSEkspLinListReceptId.AsInteger,False,LSetInProgress) then
            ValidOrdIdList.add(nxRSEkspLinListOrdId.AsString);
          nxRSEkspLinList.Next;
        end;
        if ValidOrdIdList.Count = 0 then
          exit;
        AddHeader := True;
        if cdsOrdHeader.FindKey([PatCPr, YderNr, YderCPRNr]) then
          AddHeader := False;
        if AfstemplingForHverReceptkvittering then
          AddHeader := True;
        if not AddHeader then
        begin
          // if we can find the patient / ydernr / ydercprnr in cds then just add the lines
          cdsOrdHeader.Edit; // updates the ordant
          try
            AddCDSLines;
          except
            on e: Exception do
              c2logadd('Header edit Exception in AddCDSLines ' + e.Message);
          end;
          cdsOrdHeader.Post;
          exit;
        end;

        cdsOrdHeader.Append;
        cdsOrdHeaderPaCprNr.AsString := PatCPr;
        cdsOrdHeaderYdNr.AsString := YderNr;
        LUdstederType := StamForm.CalculateUdstederType(MainDm.nxRSEkspListSenderType.AsString);
        if LUdstederType = 3 then
        begin
          Maindm.cdsOrdHeaderYdNr.AsString  := '0990027';

          if ContainsText(MainDm.nxRSEkspListSenderNavn.AsString, 'sygehus') or
            ContainsText(MainDm.nxRSEkspListSenderNavn.AsString, 'hospital') then
            Maindm.cdsOrdHeaderYdNr.AsString  := '0994057';

        end;
        cdsOrdHeaderYderCprNr.AsString := YderCPRNr;
        cdsOrdHeaderLbnr.AsInteger := nxRSEkspListReceptId.AsInteger;
        cdsOrdHeaderAnnuller.AsBoolean := False;
        SidKundeNr := PatCPr;
        MainDm.cdsOrdHeaderPaNvn.AsString :=
          Trim(nxRSEkspListPatEftNavn.AsString);
        MainDm.cdsOrdHeaderForNavn.AsString :=
          Trim(nxRSEkspListPatForNavn.AsString);
        if GemNyeRsFornavnEfternavn then
        begin
          if cdsOrdHeaderForNavn.AsString <> '' then
            cdsOrdHeaderPaNvn.AsString := Trim(cdsOrdHeaderForNavn.AsString) +
              ' ' + Trim(cdsOrdHeaderPaNvn.AsString);
        end
        else
        begin
          if cdsOrdHeaderForNavn.AsString <> '' then
            MainDm.cdsOrdHeaderPaNvn.AsString :=
              Trim(cdsOrdHeaderPaNvn.AsString) + ',' +
              Trim(cdsOrdHeaderForNavn.AsString);
        end;
        cdsOrdHeaderAdr.AsString := nxRSEkspListPatVej.AsString;
        cdsOrdHeaderAdr2.AsString := '';
        cdsOrdHeaderPostNr.AsString := nxRSEkspListPatPostNr.AsString;
        cdsOrdHeaderBy.AsString := nxRSEkspListPatBy.AsString;

        cdsOrdHeaderAmt.AsString := nxRSEkspListPatAmt.AsString;
        cdsOrdHeaderTlf.AsString := ''; // todo
        cdsOrdHeaderAlder.AsString := ''; // todo
        cdsOrdHeaderBarn.AsString := ''; // todo
        cdsOrdHeaderTilskud.AsString := ''; // todo
        cdsOrdHeaderTilBrug.AsString := ''; // todo
        cdsOrdHeaderLevering.AsString := nxRSEkspListLeveringAdresse.AsString;
        cdsOrdHeaderFriTxt.AsString := '';
        cdsOrdHeaderYdNavn.AsString := nxRSEkspListIssuerTitel.AsString;
        cdsOrdHeaderYdSpec.AsString := ''; // todo
        cdsOrdHeaderOrdAnt.AsInteger := 0;
        cdsOrdHeaderLevinfo.AsString := nxRSEkspListLeveringsInfo.AsString;
        cdsOrdHeaderSenderType.AsString := nxRSEkspListSenderType.AsString;
        cdsOrdHeaderSenderNavn.AsString := nxRSEkspListSenderNavn.AsString;
        cdsOrdHeaderIssuerTitel.AsString := nxRSEkspListIssuerTitel.AsString;
        if (Trim(nxRSEkspListLeveringsInfo.AsString) <> '') or
          (Trim(nxRSEkspListOrdreInstruks.AsString) <> '') or
          (Trim(nxRSEkspListLeveringPri.AsString) <> '') or
          (Trim(nxRSEkspListLeveringAdresse.AsString) <> '') or
          (Trim(nxRSEkspListLeveringPseudo.AsString) <> '') or
          (Trim(nxRSEkspListLeveringPostNr.AsString) <> '') or
          (Trim(nxRSEkspListLeveringKontakt.AsString) <> '') then
          cdsOrdHeaderLevinfo.AsString := 'Vis Ekspedition';
        if (Trim(nxRSEkspListLeveringsInfo.AsString) <> '') then
          cdsOrdHeaderLevinfo.AsString :=
            Trim(nxRSEkspListLeveringsInfo.AsString);
        cdsOrdHeaderAP4.AsBoolean := True;
        try
          AddCDSLines;
        except
          on e: Exception do
            c2logadd('Header edit Exception in AddCDSLines ' + e.Message);
        end;
        cdsOrdHeader.Post;

      finally
        ValidOrdIdList.Free;
      end;
    end;
  end;

  function IsAppOrder : boolean;
  var
    LKundenr : string;
    LC2Nr : integer;
  const
    EHH = 'EHH.';
    EHL = 'EHL.';
  begin
    Result := False;
    with MainDm do
    begin
      nxRSEkspLin.IndexName := 'Receptidorder';
      nxRSEkspLin.SetRange([nxRSEkspListReceptId.AsInteger],[nxRSEkspListReceptId.AsInteger]);
      try
        nxRSEkspLin.First;
        while not nxRSEkspLin.Eof do
        begin

          // look for a line with the prescription identifier in ehordrelinier

          with nxdb.OpenQuery('select ' + EHL + fnEHOrdreLinierOrdinationsId + ','
             +EHL + fnEHOrdreLinierC2Nr + ',' + EHH + fnEHOrdreHeaderKundeCPR +
             ' from ' + tnEHOrdreLinier + ' as EHL inner join ' + tnEHOrdreHeader +
            ' as EHH on ' + EHL + fnEHOrdreLinierC2Nr + '=' + EHH+
            fnEHOrdreHeaderC2Nr + ' where ' +
            fnEHOrdreLinierFmkPrescriptionId_P,
            [nxRSEkspLinPrescriptionIdentifier.AsLargeInt]) do
          begin
            try
              if not Eof then
              begin
                if ChkBoxYesNo('Denne recept er en App. ordre' + #13#10 +
                  'Påbegynd taksering fra [CF8]?', False) then
                begin
                  LKundenr := fieldbyname(fnEHOrdreHeaderKundeCPR).AsString;
                  LC2Nr := fieldbyname(fnEHOrdreLinierC2Nr).AsInteger;
                  nxOrd.IndexName := 'C2NrOrden';
                  nxOrd.FindKey([LC2Nr]);
                  ffpatkar.IndexName := 'NrOrden';
                  if not ffPatKar.FindKey([LKundenr]) then
                  begin
                    C2LogAdd('patient not found');
                    edtCPR.Text := LKundenr;
                  end;
                  StamPages.ActivePage := tsEHandel;
                end;
                Result := True;
                break;
              end;

            finally
              Free;
            end;

          end;
          nxRSEkspLin.Next;
        end;
      finally
        nxRSEkspLin.CancelRange;
      end;

    end;
  end;

begin
  if ShowMessageBoxWithLogging(SEHordreTakserWarning,'Warning', MB_YESNO + MB_DEFBUTTON2) <> IDYES then
    exit;
  LKundenr := '';
  // does the user still have a certificate before we call fmk routines
  if not CurrentLogonIsValid(MainDm.Bruger, MainDm.Afdeling, ltAll) then
  begin
    Close;
    exit;
  end;
  UpdateStatusBrugerInfo;

  with MainDm do
  begin

    // SetInProgress:= True;  // Takser altid 1. markerede ordination
    bitbtnTakser.Enabled := False;
    BusyMouseBegin;
    UdskrivQuestion := True;
    UdskrivAnswer := False;
    c2logadd('CF6 Takser button pressed');
    save_prescriptId := '';
    try
      LIsAppOrder := IsAppOrder;
      if LIsAppOrder then
        exit;

      if nxRSEkspListPatCPR.AsString = '' then
      begin
        if pos('PersonID:', nxRSEkspListLeveringsInfo.AsString) = 0 then
        begin
          ChkBoxOK('Ordinationen har ikke cprnr, så takser den manuelt og afslut den på FMk.');
          exit;
//          if ChkBoxYesNo('Ordinationen har ikke CPR nummer.' + #13#10 +
//          'Vælg fra listen eller opret nyt korrekt Erstatnings CPR nummer. ',True) then
//          begin
//            // Show the patient search screen
//            LKundenr := TPaLstForm.ShowPalst(MainDm.nxdb);
//            if LKundenr = '' then
//            begin
//              StamPages.ActivePage := KartotekPage;
//
//              exit;
//            end;
//          end;
//          if not ffPatKar.FindKey([LKundenr]) then
//          begin
//            ChkBoxOK('Bizarrely the patient does not exist ' + LKundenr);
//            C2LogAdd('Bizarrely the patient does not exist ' + LKundenr);
//            exit;
//          end;
//          if not ChkBoxYesNo('Ønsker du at benytt ' + LKundenr + ' - ' +
//                ffPatKarNavn.AsString+'?',true) then
//            exit;
////          nxRSEkspList.Edit;
////          nxRSEkspListPatCPR.AsString := LKundenr;
////          nxRSEkspListPatForNavn.AsString := ffPatKarNavn.AsString;
//          // nxRSEkspListPatVej.AsString := ffPatKarAdr1.AsString;
//          // nxRSEkspListPatBy.AsString := ffPatKarAdr2.AsString;
////          nxRSEkspListPatPostNr.AsString := ffPatKarPostNr.AsString;
////          nxRSEkspList.Post;
        end;
      end
      else
      begin
        if not TfrmDosiskort.ShowDoskort(nxRSEkspListPatCPR.AsString,
          TFMKPersonIdentifierSource.DetectSource(nxRSEkspListPatCPR.AsString)) then
          exit;
      end;
      if (CF6Selected.Count = 0) then
      begin
        if not nxRSEkspListDosis.AsString.IsEmpty then
        begin
          ChkBoxOK('Ordinationen er markeret til dosisdispensering, og skal behandles og takseres i dosisprogrammet.');
          exit;
        end;
        c2logadd('no lines selected so just takser the current prescription.');
        if (Udskriv_recept_pop_up) then
        begin
          if (UdskrivQuestion) then
            UdskrivAnswer := ChkBoxYesNo('Udskriv receptkvittering?', True);
          if UdskrivAnswer then
          begin
            C2LogAdd('Call C2FMKMidSrv with receptid ' + MainDm.nxRSEkspListReceptId.AsString);
            RCPMidCli.SendRequest('GetAddressed',
              ['4', MainDm.nxRSEkspListReceptId.AsString, inttostr(AfdNr), MainDm.C2UserName], 10);
          end;
        end;
        // check to see if takser in progress
        if nxRSEkspListReceptStatus.AsInteger > 90 then
        begin
          c2logadd('**** Takser requested for ReceptStatus > 90');
          if not frmYesNo.NewYesNoBox
            ('Det ser ud til, at der er (eller har været) en igangværende ekspedition på denne receptkvittering.'
            + #13#10 + 'Er du sikker på, at du vil fortsætte ekspedition?') then
            exit;
          c2logadd('**** Takser ACCEPTED with receptstatus >90');
        end;

        ReceivedLbnr := nxRSEkspListReceptId.AsInteger;

        // nxRSEkspLinList.First;
        // while not nxRSEkspLinList.Eof do
        // begin
        // if not DMRSGetMeds.RefreshReceivedMedications(nxRSEkspLinListOrdId.AsString,
        // afdnr) then
        // c2logadd('Ordid ' + nxRSEkspLinListOrdId.AsString +
        // ' not set in progress');
        // nxRSEkspLinList.Next;
        // end;

        c2logadd('konvrseksp called from takser in Cf6');
        if not KonvRSEkspBusy then
          KonvRSEksp(ReceivedLbnr, StamPages.ActivePage,False,LKundenr, False); // False means that we should not prompt the user again with DD-card info. We have done that
        exit;
      end;

      c2logadd('no of entries selected ' + inttostr(CF6Selected.Count));
      for BMark in CF6Selected do
      begin
        nxRSEkspList.Bookmark := BMark;
        if (Udskriv_recept_pop_up) then
        begin
          if (UdskrivQuestion) then
            UdskrivAnswer := ChkBoxYesNo('Udskriv receptkvittering?', True);
          if UdskrivAnswer then
          begin
            C2LogAdd('Call C2FMKMidSrv with receptid ' + MainDm.nxRSEkspListReceptId.AsString);
            RCPMidCli.SendRequest('GetAddressed',
              ['4', MainDm.nxRSEkspListReceptId.AsString, inttostr(AfdNr), MainDm.C2UserName], 10);
          end;
        end;
        UdskrivQuestion := False;

        AddToCdsOrd;

      end;

      konvCDSBatch(StamPages.ActivePage);
      CF6Selected.Clear;
      dbgLocalRS.Repaint;

    finally
      c2logadd('CF6 Takser finally');
      if not LIsAppOrder then
      begin
        if RCPTakserCompleted then
          CheckMoreOpenRCP(False);
      end;
      BusyMouseEnd;
      bitbtnTakser.Enabled := True;
    end;
  end; // with maindm

end;

procedure TStamForm.SearchBarcode(barcodestr: string);
var
  ReceptNr: Integer;
begin
  with MainDm do
  begin

    if copy(barcodestr, 1, 5) = '99966' then
    begin
      ReceptNr := StrToInt(copy(barcodestr, 6, 7));
      nxRSEksp.IndexName := 'ReceptIDOrder';
      if not nxRSEksp.FindKey([ReceptNr]) then
      begin
        ChkBoxOK('Recept (receptnr) findes ikke!');
        edtCprNr.Text := '';
        exit;
      end;
      edtCprNr.Text := nxRSEksp.fieldbyname('PatCPR').AsString;
      VisOrdCprNr;
      exit;
    end;

    if copy(barcodestr, 1, 4) = '9900' then
    begin
      ReceptNr := StrToInt(copy(barcodestr, 5, 8));
      ffEksKar.IndexName := 'NrOrden';
      if not ffEksKar.FindKey([ReceptNr]) then
      begin
        ChkBoxOK('Recept (løbenr) findes ikke!');
        edtCprNr.Text := '';
        exit;
      end;
      edtCprNr.Text := ffEksKarKundeNr.AsString;
      VisOrdCprNr;
      exit;
    end;

    ChkBoxOK('Denne stregkode findes ikke!');
  end;
end;

procedure TStamForm.btnUdRapportClick(Sender: TObject);
begin
  // does the user still have a certificate before we call fmk routines
  if not CurrentLogonIsValid(maindm.Bruger,maindm.Afdeling,ltAll) then
  begin
    Close;
    exit;
  end;
  UpdateStatusBrugerInfo;

  uCPRlist.GetMedsByCPR(edtCprNr.Text, True);
end;

procedure TStamForm.btnSendClick(Sender: TObject);
var
  LbNr: Integer;

  function AlreadyReported: Boolean;
  begin
    Result := False;
    with MainDm do
    begin
      if ffEksKar.FindKey([LbNr]) then
      begin

        if ffEksKarRSQueueStatus.AsInteger <> 0 then
        begin
          ChkBoxOK('Denne ekspedition er tidligere sendt til FMK og kan ikke sendes igen.');
          Result := True;
          exit;
        end;
      end;

    end;
  end;

begin
  with MainDm do
  begin

    btnSend.Enabled := False;
    BusyMouseBegin;
    try
      LbNr := nxRSEkspLinListLbNr.AsInteger;
      c2logadd('Send function called with lbnr ' + inttostr(LbNr));
      try
        with nxdb.OpenQuery('select top 1 oldlbnr from EkspeditionerCredit where CreditLbnr=:ilbnr',
                      [Lbnr]) do
        begin
          try
            if not Eof then
            begin
              ChkBoxOK('Denne ekspedition er en resultatet af en kreditering ' +
                #13#10 + 'af en anden ekspedition og kan ikke sendes til FMK.'
                + #13#10 + 'Prøv i stedet at sende den oprindelige ekspedition.');
              exit;
            end;
          finally
            Free;
          end;
        end;
      except
        on e: Exception do
          c2logadd('Error checking if theres a credit for lbnr ' +
            inttostr(LbNr));
      end;

      if AlreadyReported then
        exit;

      if not ChkBoxYesNo('Send løbenr ' + inttostr(LbNr), True) then
        exit;
      try
        try
          nxRSQueue.Insert;
          nxRSQueueLbnr.AsInteger := LbNr;
          nxRSQueueDato.AsDateTime := Now;
          nxRSQueue.Post;
        except
          on e: Exception do
          begin
            ChkBoxOK(e.Message);
            c2logadd(e.Message);
          end;
        end;
      finally
        if nxRSQueue.State <> dsBrowse then
          nxRSQueue.Cancel;
      end;
    finally
      BusyMouseEnd;
      btnSend.Enabled := True;

    end;
  end;
end;

procedure TStamForm.btnSendKvitClick(Sender: TObject);
begin
  if TfrmKvittering.ShowKvittering then
  begin
    SendEOrdre(maindm.nxOrdC2Nr.AsInteger);
  end;

end;

procedure TStamForm.btnSkiftStatusClick(Sender: TObject);
begin

  if TfrmStatus.skiftstatus then
    SendEOrdre(MainDm.nxOrdC2Nr.AsInteger);

end;

procedure TStamForm.RSRemotePageShow(Sender: TObject);
begin
  c2logadd('RSremote page show fired ' + edtCprNr.Text);
  with MainDm do
  begin


    nxSettings.IndexName := 'AfdelingOrder';
    if not nxSettings.FindKey([MainDm.AfdNr]) then
      nxSettings.First;
    RSLokation := nxSettingsLokationNr.AsString;
    {
      try
      ffPatKar.IndexName := 'NrOrden';
      if ffPatKar.findkey([trim(edtCprNr.text)]) then begin
      c2logadd('Found the patient' + ffPatKarKundeNr.AsString);
      end;
      except
      on e : Exception do
      ChkBoxOK(e.Message);
      end;
      edtCprNr.Text := ffPatKarKundeNr.AsString;
    }
    // if trim(edtCprNr.Text) = '' then
    // edtCprNr.Text := SidKundeNr;

    c2logadd('edtcprnr is now ' + edtCprNr.Text);
    edtCprNr.SelectAll;
    edtCprNr.SetFocus;
    if Trim(edtCprNr.Text) <> '' then
    begin
      VisOrdCprNr;
      SidKundeNr := edtCprNr.Text;
      c2logadd('181: sidkundenr ' + SidKundeNr);
    end
    else
      lvFMKPrescriptions.Clear;
  end;

end;

procedure TStamForm.acRCPSearchExecute(Sender: TObject);
begin
  TfrmRCPVare.ShowRCPVarenrSearch(FLagerNr);

end;

procedure TStamForm.acRemoveStatusExecute(Sender: TObject);
var
  LPrescriptionId: Int64;
  LPrescription: TC2FMKPrescription;
  LOrder: TC2FMKOrder;
  ll: TListItem;
  LPersonId: string;
  LPersonIdSource: TFMKPersonIdentifierSource;
begin
  with MainDm do
  begin
    // only makes sense to allow this function if we are on CF%
    if StamPages.ActivePage <> RSRemotePage then
      exit;

    // are there any lines displayed and a line focused
    if (lvFMKPrescriptions.Items.Count = 0) or (lvFMKPrescriptions.ItemIndex < 0) then
      exit;

    // // is there a kundenr?
    // if edtCprNr.Text = '' then
    // exit;

    if not ChkBoxYesNo('Are you sure?', False) then
      exit;

    LPersonId := edtCprNr.Text;
    LPersonIdSource := TFMKPersonIdentifierSource.DetectSource(LPersonId);

    ll := lvFMKPrescriptions.Items[lvFMKPrescriptions.ItemIndex];
    if ll.SubItems[lvPersonId] <> '' then
    begin
//      LCprnr := ll.SubItems[lvMedicineCardKey];
//      LPatientType := pisMedicineCardKey;
      LPersonId := ll.SubItems[lvPersonId];
      LPersonIdSource := TFMKPersonIdentifierSource.Parse(ll.SubItems[lvPersonIdSource]);
    end;

    if TryStrToInt64(ll.Caption, LPrescriptionId) then
    begin
      LPrescription := PrescriptionsForPO.Prescriptions.GetPrescriptionByID
        (LPrescriptionId);

      LOrder := LPrescription.Orders.GetOrderByStatus(osEkspeditionPaabegyndt);

      if LOrder <> Nil then
      begin
        if uFMKCalls.FMKRemoveStatus(AfdNr, LPersonId, LPersonIdSource, 0, LPrescriptionId,
          LOrder.Identifier, Nil) then
        begin
          c2logadd('remove status on Administration successful');

        end;
      end;

    end;
    VisOrdCprNr;

  end;

end;

function TStamForm.GetCTR(const AKundeNr: string) : Boolean;
const
  SCTR1Name = 'C2GetCtr.exe';
  SCTR2Name = 'C2GetCtr2.exe';
var
  LCTRprogstring: string;
  LCTRProgramName : string;
begin
  Result := True;
  LCTRprogstring := '';
  MainDm.C2GetCTRJobid := 0;
  if not MainDm.ffPatUpd.FindKey([AKundeNr]) then
    exit;
  if MainDm.ffPatUpdKundeType.AsInteger <> 1 then
    exit;
  if TFMKPersonIdentifierSource.DetectSource(AKundeNr,pisUndefined) <> pisCPR then
    exit;

  if MainDm.IsCTR2Enabled then
  begin
    LCTRProgramName := SCTR2Name;
    if (maindm.BrugerNr <> 99) and (not maindm.Bruger.HasValidSosiIdOnServer) then
    begin
      // message about user not being logged in
      TaskMessageDlg('Bemærk',PWideChar('CTR2 : Bruger skal være logget ind med MitID'),TMsgDlgType.mtInformation,
        [TMsgDlgBtn.mbOK],0);
      Exit(True);
    end;


  end
  else
    LCTRProgramName := SCTR1Name;



  c2logadd('Starting C2GetCtr');
  if FileExists(ProgramFolder + LCTRProgramName) then
    LCTRprogstring := ProgramFolder + LCTRProgramName
  else
  begin
    if FileExists('G:\' + LCTRProgramName) then
      LCTRprogstring := 'G:\' + LCTRProgramName;
  end;

  // if LCTRProgrstring is blank then C2GetCtr.exe does not exist in the 2 places we have looked
  if LCTRprogstring = '' then
  begin
    c2logadd(LCTRProgramName + ' not found');
    exit;
  end;
  var LBrugerNr := maindm.BrugerNr;
  if LBrugerNr = 99 then
    LBrugerNr := 0;
  if LCTRProgramName = SCTR2Name then
    LCTRprogstring := LCTRprogstring + Format(' /AfdelingsNr:%d /Bruger:%d /Kundenr:%s',
      [MainDm.AfdNr, LBrugerNr, Trim(AKundeNr)])
  else
    LCTRprogstring := LCTRprogstring + ' ' + Trim(AKundeNr);

  if ExecuteJob(LCTRprogstring, SW_HIDE, MainDm.C2GetCTRJobid) <> 0 then
    c2logadd('Fejl i start C2GetCtr');

  c2logadd('After execute job ' + LCTRprogstring);
end;

function TStamForm.HTTPSendEordre(xmlstr: WideString): Boolean;
var
  datain: TMemoryStream;
  dataout: TMemoryStream;
  http: THttpCli;
  buf: AnsiString;
  sl: TStringList;
  ansixmlstr: AnsiString;
  Error: Integer;
  HTTPUrl: string;
  FApotekid: string;
  FPassword: string;
  HTTPSUrl : string;

begin
  Result := False; // mweans that retry pattern is enabled
  if C2StrPrm('Ehandel', 'Url', '') <> '' then
    HTTPUrl := C2StrPrm('Ehandel', 'Url', '')
  else
    HTTPUrl := C2StrPrm('Ehandle', 'Url', '');

  // get the HTTPS url from user section winpacer. initially this will be on a test user then when
  // it is tested ok will be moved into Ehandel segment

  HTTPSUrl := C2StrPrm('Ehandel', 'HttpsUrl', '');
  HTTPSUrl := C2StrPrm(MainDm.C2UserName,'EhandelHttpsUrl', HTTPSUrl);


  // possibility to override under the user segment.

  HTTPUrl := C2StrPrm(MainDm.C2UserName, 'EhandelTestUrl', HTTPUrl);

  if HTTPUrl.IsEmpty and HTTPSUrl.IsEmpty then
  begin
    c2logadd('No url or https url in Ehandel segment of winpacer.ini');
    Result := True; // no point retrying
    exit;
  end;
  c2logadd('HttpUrl is ' + HTTPUrl);
  c2logadd('HttpsUrl is ' + HTTPSUrl);
  AdjustIndexName(MainDm.nxEHSettings, 'ApotekIdOrden');

  if MainDm.nxEHSettings.FindKey([MainDm.nxOrdApotekId.AsString]) then
  begin
    FApotekid := MainDm.nxEHSettingsApotekId.AsString;
    FPassword := MainDm.nxEHSettingsPassword.AsString;
  end
  else
  begin
    ChkBoxOK('Lager ikke findes i EHSettings');
    Result := True; // no point retrying
    exit;
  end;
  FormatSettings.DecimalSeparator := '.';
  if not HTTPSUrl.IsEmpty then
  begin
    Result := SendChilkatHttp(HTTPSUrl,xmlstr,FApotekid);
    exit;
  end;

  datain := TMemoryStream.Create;
  dataout := TMemoryStream.Create;
  http := THttpCli.Create(NIL);
  sl := TStringList.Create;
  try
    ansixmlstr := UTF8Encode(xmlstr);
    // C2LogAdd(STRING(ansixmlstr));
    // exit;
{$WARNINGS OFF}
    buf := 'beskedtype=OpdaterEordreFraApotekRequest' + '&apotekNr=' + FApotekid
      + '&password=' + FPassword + '&requestdata=' + HTTPEncode(ansixmlstr);
{$WARNINGS ON}
    dataout.Write(buf[1], Length(buf));
    dataout.Seek(0, soFromBeginning);
    http.Accept := 'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*';
    http.Agent := 'Mozilla/3.0 (compatible)';
    http.ContentTypePost := 'application/x-www-form-urlencoded';
    http.Cookie := '';
    http.MultiThreaded := False;
    http.NoCache := False;
    http.Proxy := '';
    http.ProxyPort := '';
    http.RcvdStream := datain;
    http.SendStream := dataout;
    http.URL := HTTPUrl;
    // C2LogAdd(string(buf));
    Error := 0;
    try
      try
        http.Post;
        Error := http.StatusCode;

      except
        on e: EHttpException do
        begin
          // ChkBoxOK('E-handel send fejl ' + E.Message);
          c2logadd(e.Message);
        end;
      end;
    finally
      c2logadd('did we get an answer?');
      // Error 200 = OK
      if Error = 200 then
      begin
        datain.Seek(0, 0);
        sl.LoadFromStream(datain);
        c2logadd(sl.Text);
        Result := True;
      end
      else
      begin
      end;
    end;
  finally
    http.Free;
    dataout.Free;
    datain.Free;
    sl.Free
  end;

end;

procedure TStamForm.acUndoEffectuationExecute(Sender: TObject);
begin
  if StamPages.ActivePage <> RSLocalPage then
    TfmUndo.Showform('',0,0,0)
  else
  begin
    with MainDm do
    begin
      TfmUndo.Showform( nxRSEkspListPatCPR.AsString,
                        nxRSEkspLinListPrescriptionIdentifier.AsLargeInt,
                        nxRSEkspLinListOrderIdentifier.AsLargeInt,
                        nxRSEkspLinListEffectuationIdentifier.AsLargeInt);

    end;
  end;
end;

procedure TStamForm.acVisCTRBevExecute(Sender: TObject);
var
  ExitCode: DWord;
begin
  inherited;
  GetCTR(MainDm.ffPatKarKundeNr.AsString);
  if MainDm.C2GetCTRJobid <> 0 then
  begin
    for var i := 1 to 50 do
    begin
      GetExitCodeProcess(MainDm.C2GetCTRJobid, ExitCode);
      if ExitCode <> STILL_ACTIVE then
        break;
      Sleep(100);
    end;
    MainDm.C2GetCTRJobid := 0;
    C2LogAddF('C2GetCtr %d', [ExitCode]);
  end;
  TfmCtrBevOversigt.CtrBevOver(MainDm.ffPatKarKundeNr.AsString);
end;

procedure TStamForm.acVisDDKortExecute(Sender: TObject);
  function CurrentLokation(ALokation: string): Boolean;
  begin
    Result := False;
    with MainDm.nxdb.OpenQuery('select ' + fnRS_SettingsLokationNr + ' from ' +
      tnRS_Settings + ' where ' + fnRS_SettingsLokationNr_P, [ALokation]) do
    begin
      try
        Result := not Eof;
      finally
        Free;
      end;

    end;

  end;

begin
  with MainDm do
  begin
    if not CurrentLokation(DosiscardLokation) then
    begin
      if not frmYesNo.NewYesNoBox
        ('Har du samtykke fra kunden til at se doseringskortet?') then
        exit;

    end;

    { TODO : 03-06-2021/MA: Replace constant with real PersonIdSource }
    TFormDosiskortPDFViewer.ShowDialog(Bruger, Afdeling,
      ffPatKarKundeNr.AsString, TFMKPersonIdentifierSource.DetectSource(ffPatKarKundeNr.AsString));
  end;
end;

procedure TStamForm.acVisDDKortUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := maindm.PatientDosisCards.Count <> 0;

end;

procedure TStamForm.timClockTimer(Sender: TObject);
begin
  timClock.Enabled := False;
  try
    lblC2Q.Visible := False;
    lblClockDate.Caption := FormatDateTime('ddd dd/mm/yyyy', Now);
    lblClockTime.Caption := FormatDateTime('hh:mm', Now);
    C2StatusBar.Repaint;
    if LogAfTid <> 0 then
    begin
      if AllowLogoff then
      begin
        if not TakserActive then
        begin
          if SecondsBetween(Now, LastInput) > LogAfTid then
          begin
            if not AppDeactivated then
              acLogOffExecute(Sender);
            LastInput := Now;
          end;
        end;
      end;
      AllowLogoff := True;
    end;

    if ProgramVersTestCount = 0 then
    begin
      if pos('USER', caps(MainDm.C2UserName)) <> 0 then
      begin
        if ProgramVersion <> C2FileVersion('G:\PatientKartotek.exe') then
        begin

          ChkBoxOK('Der er en ny version af Patientkartoteket.' + sLineBreak +
            'Genstart C2 for at få den opdateret.');
          ProgramVersTestCount := 999;
        end;
      end;
    end
    else
      ProgramVersTestCount := 999;

    if ProgramVersTestCount <> 999 then
    begin
      ProgramVersTestCount := ProgramVersTestCount + 1;
      if ProgramVersTestCount = 30 then
        ProgramVersTestCount := 0;
    end;
  finally
    timClock.Enabled := True;
  end;

end;

procedure TStamForm.tsEHandelEnter(Sender: TObject);
begin
  lblehlin.Visible := False;
  lblehord.Visible := False;
  // for i := 0 to  pnlEHButtons.ControlCount -1 do begin
  // cmp := pnlEHButtons.Controls[i];
  // if cmp is TButton then begin
  // btn :=  cmp as tbutton;
  // btn.Enabled := False;
  // end;
  // end;
  // btnSkiftStatus.Enabled := False;
  // btnBeskeder.Enabled := False;
  // btnSendKvit.Enabled := False;
  dbgEHOrd.SetFocus;
  C2LogAdd('nxord.indexname is ' + maindm.nxord.IndexName);
end;

procedure TStamForm.acHentOrdinationExecute(Sender: TObject);
var
  LPersonId: string;
  LPersonIdSource: TFMKPersonIdentifierSource;
  LResult: Boolean;
begin
  // does the user still have a certificate before we call fmk routines
  if not MainDm.CheckFMKCertificate then
    exit;
  UpdateStatusBrugerInfo;

  with MainDm do
  begin
    BusyMouseBegin;
    try
      LPersonId := ListView2.Items[ListView2.ItemIndex].SubItems[4].trim;
      LPersonIdSource := TFMKPersonIdentifierSource.DetectSource(LPersonId);

      LResult := C2FMK.GetPrescriptionRequest(Bruger.SOSIId,
        Bruger.FMKRolle.ToSOSIId, LPersonId, LPersonIdSource, ctUndefined,
        ipOpenPrescriptions, True, PrescriptionsForPO);
      // c2logadd(C2FMK.XMLLog.Text);
      if not LResult then
      begin
        ChkBoxOK(C2FMK.LastFMKFaultText);
        exit;
      end;
      UpdateListview;

    finally
      if lvFMKPrescriptions.Items.Count <> 0 then
      begin
        btnGetMedList.Enabled := True;
        btnTakser.Enabled := False;
        lvFMKPrescriptions.SetFocus;
      end
      else
      begin
        btnGetMedList.Enabled := False;
        btnTakser.Enabled := False;
      end;
      BusyMouseEnd;

    end;
  end;
end;

procedure TStamForm.acHentOrdinationUpdate(Sender: TObject);
begin

  if ListView2.ItemIndex = -1 then
    (Sender as TAction).Enabled := False
  else
  (Sender as TAction).Enabled := (ListView2.Items.Count <> 0) and
                                  (ListView2.Items[ListView2.ItemIndex].SubItems[4] <> '');

end;

procedure TStamForm.acHldEtiketExecute(Sender: TObject);
var
  Item: Word;
  LbNr: Cardinal;
  save_index: string;
  levnr: string;
  i: Integer;
begin
  with MainDm do
  begin
    if fmubi.HldEtkDev = '' then
    begin
      ChkBoxOK('Der mangler setup til at udskrive denne etiket.' + #13#10 +
        'Kontakt Bo Soft, hvis udskrift ønskes.');
      exit;
    end;

    // Søg et recept løbenummer, pakkenummer eller fakturanr
    if not TSoegRcpForm.SoegRcpt(Item, LbNr) then
      exit;
    if Item <> 0 then
      exit;
    if LbNr = 0 then
      exit;

    save_index := SaveAndAdjustIndexName(MainDm.ffEksKar, 'NrOrden');
    try
      if not ffEksKar.FindKey([LbNr]) then
      begin
        ChkBoxOK('Løbenummer findes ikke');
        exit;
      end;
      levnr := StringOfChar(' ',10);
      if Trim(ffEksKarLevNavn.AsString) <> '' then
        levnr := Trim(ffEksKarLevNavn.AsString).PadRight(10);
      if NavneEtiketCount = 0 then
        NavneEtiketCount := 1;
      NavneEtiketCount := ChkBoxInt('Antal etiketter', NavneEtiketCount);
      for i := 1 to NavneEtiketCount do
      begin
        fmubi.PrintHyldeEtik(ffFirmaSupNavn.AsString,
          FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
          ffEksKarLbNr.AsString, ffEksKarNavn.AsString, ffEksKarAdr1.AsString,
          ffEksKarAdr2.AsString, ffEksKarPostNr.AsString + ' ' +
          ffEksKarBy.AsString, ffEksKarKontoNr.AsString, levnr, '',
          ffEksKarKundeNr.AsString, 1, True);
      end;
      fmubi.PrintTotalEtiket;
    finally
      AdjustIndexName(MainDm.ffEksKar, save_index);
    end;

  end;

end;

procedure TStamForm.acUdlevDMVSLevlisteExecute(Sender: TObject);
begin
//  show a list of leverlingst that have no bonnr.
  TfrmUdlevDMVS.ShowForm(MainDm.AfdNr);

end;

procedure TStamForm.acUdRCPExecute(Sender: TObject);
begin
  try
    TRCPPrnForm.RCPView(MainDm.nxRSEkspListReceptId.AsInteger);
  except
    on e: Exception do
    begin
      ChkBoxOK(e.Message);
    end;
  end;
end;

procedure TStamForm.Button1Click(Sender: TObject);
begin
  acUdRCP.Execute;
end;

procedure TStamForm.Button2Click(Sender: TObject);
begin
  with MainDm do
  begin
    // if not CurrentLokation(DosiscardLokation) then
    // begin
    // if not frmYesNo.NewYesNoBox('Har du samtykke fra kunden til at se doseringskortet?') then
    // exit;
    //
    // end;
    //
    { TODO : 03-06-2021/MA: Replace constant with real PersonIdSource. Is this procedure in use at all? }
    TFormDosiskortPDFViewer.ShowDialog(Bruger, Afdeling, edtCprNr.Text,
      TFMKPersonIdentifierSource.DetectSource(edtCprNr.Text), 0, ptLaege);
  end;

end;

procedure TStamForm.acSoegCPRExecute(Sender: TObject);
var
  i : integer;

begin
  // does the user still have a certificate before we call fmk routines
  if not CurrentLogonIsValid(maindm.Bruger,maindm.Afdeling,ltAll) then
  begin
    Close;
    exit;
  end;
  UpdateStatusBrugerInfo;

  if ListView2.Items.Count = 0 then
    exit;
  i := ListView2.ItemIndex;
  if i < 0 then
    exit;

  if ListView2.Items[i].Caption = '' then
    exit;

  edtCprNr.Text := ListView2.Items[i].Caption;
  VisOrdCprNr;

end;

procedure TStamForm.acSoegCPRUpdate(Sender: TObject);
begin
  if ListView2.ItemIndex = -1 then
    (Sender as TAction).Enabled := False
  else
  (Sender as TAction).Enabled := (ListView2.Items.Count <> 0) and
                                  (ListView2.Items[ListView2.ItemIndex].Caption <> '');

end;

procedure TStamForm.acStdSletExecute(Sender: TObject);
begin
  if not SameText(C2StrPrm('Generelt', 'STDsetup', 'Nej'), 'JA') then
    exit;

  StamF8Handler;

end;

procedure TStamForm.acStdSletUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := C2ButF8.Enabled;
end;

procedure TStamForm.acStregkodeKontrolExecute(Sender: TObject);
begin
  BatchStarted := False;
end;

procedure TStamForm.acTabEhandelExecute(Sender: TObject);
begin
  StamPages.ActivePage := tsEHandel;

end;

procedure TStamForm.acTabEkspExecute(Sender: TObject);
begin
  StamPages.ActivePage := EkspPage;
end;

procedure TStamForm.acTabFakturaExecute(Sender: TObject);
begin
  StamPages.ActivePage := FakturaPage;

end;

procedure TStamForm.acTabKartotekExecute(Sender: TObject);
begin
  StamPages.ActivePage := KartotekPage;
end;

procedure TStamForm.acTabLokaleExecute(Sender: TObject);
begin
  StamPages.ActivePage := RSLocalPage;

end;

procedure TStamForm.acTabReceptserverExecute(Sender: TObject);
begin
  StamPages.ActivePage := RSRemotePage;

end;

procedure TStamForm.acTabTilskudExecute(Sender: TObject);
begin
  StamPages.ActivePage := TilskudsPage;
end;

procedure TStamForm.acTabUafExecute(Sender: TObject);
begin
  StamPages.ActivePage := UafslutPage;

end;

procedure TStamForm.acTakserUdenCtrExecute(Sender: TObject);
begin
  if (StamPages.ActivePage <> KartotekPage) and (StamPages.ActivePage <> RSRemotePage) and (StamPages.ActivePage <> RSLocalPage)
    then
      exit;

  if not ChkBoxYesNo('Er du sikker på at taksere udenom CTR?', false) then
    exit;
  c2logadd('takser uden ctr is selected');
  MainDm.TakserUdenCTR := true;
  try
    MenuTaksering.Click;
  finally
    Maindm.TakserUdenCTR := False;
  end;
end;

procedure TStamForm.acTidy1Execute(Sender: TObject);
begin
  // this code will perform tidy of old open Rs_ekspeditioner

  frmRCPTidy.RCPTidy(1);
end;

procedure TStamForm.acTidy2Execute(Sender: TObject);
begin
  // tidy2 funktion
  frmRCPTidy.RCPTidy(2);
end;

procedure TStamForm.C2StatusBarDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
  case Panel.Index of
    0:
      begin
        if MainDm.BrugerCertificateValid then
//          begin
//          if maindm.BrugerNr <> 99 then
          StatusBar.Canvas.Brush.Color := TColor($107CFF)
        else
          StatusBar.Canvas.Brush.Color := clBtnFace;


      end;
    2:
      begin
        if pos('Ikke takseret receptkvitt', StatusBar.Panels[2].Text) <> 0
        then
          StatusBar.Canvas.Brush.Color := clYellow;
        if pos('Åben', StatusBar.Panels[2].Text) <> 0 then
          StatusBar.Canvas.Brush.Color := TColor($70FFFF);
        Panel.Width := Trunc(Trunc(StamForm.Width) / 2.29);

      end;
    3: // fist panel
      begin
        if pos('Åben', StatusBar.Panels[3].Text) <> 0 then
          StatusBar.Canvas.Brush.Color := tcolor($70FFFF);
        if MainDm.ffCtrOpd.RecordCount > 50 then
          StatusBar.Canvas.Brush.Color := clRed;
//          if MainDm.nxRSQueue.RecordCount > 50 then
//            Brush.Color := clRed;
      end;
  end;
  // Panel background color
  StatusBar.Canvas.FillRect(Rect);
  StatusBar.Canvas.TextRect(Rect, Rect.Left + 10, Rect.Top + 5, Panel.Text);

end;

function TStamForm.CalculateAgeInYears(aCPRNr: string; aBirthDate: string=''): integer;
var
  idd,imm,iyy : integer;
  dd,mm,yy : word;
  LOldDate : TDateTime;
  LToday  : TDateTime;
  LCiffer7 : integer;
  LCurrentYear : integer;
begin

  Result := -1; // set to default -1 implies error

  if not MainDm.VaccinationPopUp then
  begin
    exit;
  end;

  // use the birthdate if supplied
  if not aBirthDate.IsEmpty then
  begin
    if not TryStrToInt(Copy(aBirthDate,1,2),idd) then
      exit;
    if not TryStrToInt(Copy(aBirthDate,3,2),imm) then
      exit;

    case  aBirthDate.Trim.Length of
      8:  if not TryStrToInt(Copy(aBirthDate,5,4),iyy) then
            exit;
      6:
      begin
        if not TryStrToInt(Copy(aBirthDate,5,2),iyy) then
            exit;
        LCurrentYear := YearInDate(Now) - 2000;
        if iyy <= LCurrentYear then
          iyy:= iyy+2000
        else
          iyy:= iyy + 1900;


      end;
      else
        exit;
    end;


    dd := idd;
    mm := imm;
    yy := iyy;

    if not sysutils.TryEncodeDate(yy,mm,dd,LOldDate) then
      exit;
    LToday := Date;

    Result := YearsBetween(trunc(LToday),trunc(LOldDate));

    exit;
  end;

  if aCPRNr.Trim.Length <> 10 then
    exit;

  if not TryStrToInt(Copy(aCPRNr,1,2),idd) then
    exit;
  if not TryStrToInt(Copy(aCPRNr,3,2),imm) then
    exit;
  if not TryStrToInt(Copy(aCPRNr,5,2),iyy) then
    exit;
  if not TryStrToInt(Copy(aCPRNr,7,1),LCiffer7) then
    exit;

  dd := idd;
  mm := imm;
  yy := iyy;

  case LCiffer7 of
    0..3: yy := yy + 1900;
    4,9:
    begin
      if yy <= 36 then
        yy := yy + 2000
      else
        yy := yy + 1900;


    end;
    5..8:
    begin
      if yy <= 57 then
        yy := yy + 2000
      else
        yy := yy + 1900;


    end;
  end;
  if yy > YearInDate(Now) then
    yy := yy - 100;

  if not sysutils.TryEncodeDate(yy,mm,dd,LOldDate) then
    exit;

  LToday := Date;

  Result := YearsBetween(trunc(LToday),trunc(LOldDate));




end;

function TStamForm.CalculateUdstederType(const AUdstederTypeString: string): integer;
var
  LUdstedType : TFMKOrganisationIdentifiersource;
begin
  Result := 0;
  for LUdstedType := Low(TFMKOrganisationIdentifiersource)to High(TFMKOrganisationIdentifiersource) do
  begin
    if ContainsText(LUdstedType.ToRSString, AUdstederTypeString) then
    begin
      case LUdstedType of
        oisSKS: Result := 1;
        oisYder: Result := 2;
        oisSOR: Result := 3;
      end;
      break;

    end;
  end;

end;

procedure TStamForm.StartBatch;
begin
  ChkBoxOK('Dette vil starte CITO ekspedition');
  CheckBatch;
  BatchStarted := True;
end;

procedure TStamForm.CheckBatch;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  BatchStarted := False;
  try
    if not FileExists('G:\temp\Batch' + IntToStr(maindm.BrugerNr) + '.txt') then
      exit;
    sl.LoadFromFile('G:\temp\Batch' + inttostr(maindm.BrugerNr) + '.txt');
    if sl.Count = 0 then
      exit;
    BatchStarted := True;
    if NOT ChkBoxYesNo('Citoekspedition er i gang.' + sLineBreak +
      'Vil du fortsætte med at opsamle ekspeditioner til stregkodekontrol og kasseindslag?',
      False) then
    begin
      DeleteFile('G:\temp\Batch' + inttostr(maindm.BrugerNr) + '.txt');
      BatchStarted := False;
    end;

  finally
    sl.Free;

  end;

end;

procedure TStamForm.AddLbnrToBatch(LbNr: LongWord);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  try

    if FileExists('G:\temp\Batch' + inttostr(maindm.BrugerNr) + '.txt') then
      sl.LoadFromFile('G:\temp\Batch' + inttostr(maindm.BrugerNr) + '.txt');
    sl.add(inttostr(LbNr));
    sl.SaveToFile('G:\temp\Batch' + inttostr(maindm.BrugerNr) + '.txt');
  finally
    sl.Free;

  end;

end;

procedure TStamForm.acBegyndBatchExecute(Sender: TObject);
begin
  StartBatch;
end;

procedure TStamForm.acC2QExecute(Sender: TObject);
begin

  // display the new form that will send a message to Kasse program to press 1 of
  // c2q buttons
  frmC2Q.ShowModal;
end;

procedure TStamForm.acCF3FindExecute(Sender: TObject);
begin
  with MainDm do
  begin
    try
      dsEksOvr.dataset := ffEksOvr;
      ffEksOvr.CancelRange;
      case cboFind.ItemIndex of
        0:
          ffEksOvr.IndexName := 'NrOrden';
        1:
          ffEksOvr.IndexName := 'FakturaNrOrden';
        2:
          ffEksOvr.IndexName := 'PakkeNrOrden';
      end;
      if not ffEksOvr.FindKey([StrToInt(eEkspLb.Text)]) then
        exit;
      if not ffPatKar.FindKey([ffEksOvrKundenr.AsString]) then
      begin
        ChkBoxOK('Patient til ekspedition findes ikke !');
        exit;
      end;
      dbgrEksp.SetFocus;
      SidKundeNr := ffPatKarKundeNr.AsString;
      c2logadd('1: sidkundenr ' + SidKundeNr);
    finally
      ffEksOvr.IndexName := 'KundeNrOrden';
    end;
  end;
end;

procedure TStamForm.acCF3SendRSExecute(Sender: TObject);
var
  LbNr: Integer;

  function AlreadyReported: Boolean;
  begin
    Result := False;

    if MainDm.ffEksOvrRSQueueStatus.AsInteger <> 0 then
    begin
      ChkBoxOK('Denne ekspedition er tidligere sendt til FMK og kan ikke sendes igen.');
      exit(True);
    end;

  end;

begin
  with MainDm do
  begin

    acCF3SendRS.Enabled := False;
    BusyMouseBegin;
    try
      LbNr := ffEksOvrLbNr.AsInteger;
      c2logadd('Send function called with lbnr ' + inttostr(LbNr));
      try
        if ffEksOvrKundeType.AsInteger <> 1 then
        begin
          C2LogAdd('Send to FMK pressed with kundetype ' + ffEksOvrKundeType.AsString);
          exit;
        end;

        with nxdb.OpenQuery('select top 1 oldlbnr from EkspeditionerCredit where CreditLbnr=:ilbnr',
                      [Lbnr]) do
        begin
          try
            if not Eof then
            begin
              ChkBoxOK('Denne ekspedition er en resultatet af en kreditering ' +
                sLineBreak + 'af en anden ekspedition og kan ikke sendes til FMK.'
                + sLineBreak + 'Prøv i stedet at sende den oprindelige ekspedition.');
              exit;
            end;
          finally
            Free;
          end;
        end;

      except
        on e: Exception do
          C2LogAddF('Error checking if theres a credit for lbnr %d', [LbNr]);
      end;

      if AlreadyReported then
        exit;

      if not ChkBoxYesNo('Send løbenr til FMK ' + inttostr(LbNr), True) then
        exit;
      try
        try
          nxRSQueue.Insert;
          nxRSQueueLbnr.AsInteger := LbNr;
          nxRSQueueDato.AsDateTime := Now;
          nxRSQueue.Post;
        except
          on e: Exception do
          begin
            ChkBoxOK(e.Message);
            c2logadd(e.Message);
          end;
        end;
      finally
        if nxRSQueue.State <> dsBrowse then
          nxRSQueue.Cancel;
      end;

    finally
      BusyMouseEnd;
      acCF3SendRS.Enabled := True;

    end;
  end;

end;

procedure TStamForm.acCF3TilbageExecute(Sender: TObject);
var
  LbNr: LongWord;
  tmpstr: string;
  DifferentLager : boolean;
  LQry : TnxQuery;
begin
  with MainDm do
  begin
    ButUdAfsl.Enabled := False;
    try


      if (ffEksOvrOrdreType.AsInteger = 2) and (not TilladKrediteringAfReturEksp) then
      begin
        ChkBoxOK('Ikke tilbageførsel af "returnering"!');
        exit;
      end;

      // if dosis then check its not a lbnr mentioned in DosisTaksering table
      if ffEksOvrEkspType.AsInteger = et_Dosispakning then
      begin
        try

          LQry := nxdb.OpenQuery('select ' + fnDosisTakseringerLbNr + ' from ' + tnDosisTakseringer + ' where ' +
              fnDosisTakseringerLbNr_P,[ffEksOvrLbNr.AsInteger]);
          try
            if not LQry.Eof then
            begin
              // found the lbnr so block the return
              ChkBoxOK('Skal tilbageføres i C2 Dosiskort FMK');
              exit;
            end;

          finally
            LQry.Free;
          end;

        except
          on e: Exception do
          begin
            // if we cannot access the table then its ok to continue with return.
            c2logadd('Fejl when checking ' + tnDosisTakseringer + ' ' + e.Message);

          end;

        end;

      end;

      if (ffPatKar.State <> dsBrowse) or (ffPatTil.State <> dsBrowse) then
      begin
        ChkBoxOK('Husk at gemme ret/opret patient!');
        StamPages.ActivePage := KartotekPage;
        exit;
      end;
      ffEksOvr.Refresh;
      if (ffEksOvrUdlignNr.AsInteger = 0) or
        ((ffEksOvrOrdreType.AsInteger = 2) and
        (ffEksOvrReceptStatus.AsInteger <> 4)) then
      begin
        DifferentLager := FLagerNr <> ffEksOvrLager.AsInteger;

        LbNr := ffEksOvrLbNr.Value;
        if ffEksOvrKundenr.AsString <> ffPatKarKundeNr.AsString then
          exit;

        tmpstr := 'Skal løbenr ' + inttostr(LbNr) + ' tilbageføres ?';
        if ffEksOvrOrdreType.AsInteger = 2 then
          tmpstr := tmpstr + sLineBreak + sLineBreak +
            'BEMÆRK! DET ER EN RETUREKSPEDITION.';
        if ffEksOvrTakserDato.AsDateTime < Now - 30 then
          tmpstr := tmpstr + sLineBreak + sLineBreak +sLineBreak +
            'BEMÆRK!  DENNE EKSPEDITION ER MERE END 1 MÅNED GAMMEL.';
        if not frmYesNo.NewYesNoBox(tmpstr) then
          exit;


        // sagsnr 10198

        if DifferentLager then
        begin
          if not ChkBoxYesNo('Ekspedition er foretaget på andet lager og varerne tilskrives dette' +
                    sLineBreak + 'Ønsker du at fortsætte?',False) then
            exit;

        end;


        AfslutReturnering(LbNr);
        if dsEksOvr.dataset = fqEksOvr then
        begin
          fqEksOvr.Close;
          fqEksOvr.Open;
        end;

        dsEksOvr.dataset.Refresh;
      end
      else
        ChkBoxOK('Ekspedition er allerede tilbageført!');
    finally
      ButUdAfsl.Enabled := True;
    end;
  end;

end;

procedure TStamForm.AcCF3UdCtrEkspListeExecute(Sender: TObject);
begin
  TfrmCTRUdskriv.CTRUdskriv;
end;

procedure TStamForm.AcCF3UdEkspListeExecute(Sender: TObject);
var
  FraDato, TilDato: TDateTime;
  DetailedList: Boolean;


begin
  FraDato := FirstDayDate(Date);
  TilDato := LastDayDate(Date);
  if not TfrmEkspUdskriv.ShowForm(FraDato, TilDato, DetailedList) then
    exit;

  BusyMouseBegin;
  try

    try
      if DetailedList then
        CF3DetailedKundeList2(MainDm.nxdb, MainDm.ffPatKarKundeNr.AsString, FraDato, TilDato)
      else
        CF3KundeList2(MainDm.nxdb, MainDm.ffPatKarKundeNr.AsString, FraDato, TilDato);
    except
      on e: Exception do
        ChkBoxOK(e.Message);
    end;

  finally
    BusyMouseEnd;
  end;

end;

procedure TStamForm.acCF3VisEtiketExecute(Sender: TObject);
var
  Edi, Send: String;
  ChrNr: string;
begin
  with MainDm do
  begin
    if not ffEksEtk.FindKey([ffLinOvrLbNr.Value, ffLinOvrLinieNr.Value]) then
    begin
      ChkBoxOK('Etiket(ter) findes ikke !');
      exit;
    end;
    DosEtiket.Clear;
    DosEtiket.Assign(ffEksEtkEtiket);
    Send := '   ';
    if ffEksOvrLeveringsForm.AsInteger > 0 then
      Send := LevForm2Str(ffEksOvrLeveringsForm.AsInteger);
    Edi := '   ';
    if ffEksOvrEkspForm.AsInteger = 3 then
      Edi := 'Edi';
    ChrNr := '';
    if ffEksOvrKundeType.AsInteger = 14 then
    begin
      ffPatKar.IndexName := 'NrOrden';

      if ffPatKar.FindKey([ffEksOvrKundenr.AsString]) then
        ChrNr := copy(ffPatKarLmsModtager.AsString, 5, 6);

    end;

    DosEtiket.Insert(0, ChrNr);
    DosEtiket.Insert(0, ffEksOvrLevNavn.AsString);
    DosEtiket.Insert(0, ffEksOvrKontoNr.AsString);
    DosEtiket.Insert(0, ffLinOvrLokation2.AsString);
    DosEtiket.Insert(0, ffLinOvrLokation1.AsString);
    DosEtiket.Insert(0, ffLinOvrATCKode.AsString);
    DosEtiket.Insert(0, ffLinOvrSubVareNr.AsString);
    DosEtiket.Insert(0, Send);
    DosEtiket.Insert(0, Edi);
    DosEtiket.Insert(0, ffEksOvrLbNr.AsString);
    DosEtiket.Insert(0, FormatDateTime('dd-mm-yy',
      ffEksOvrTakserDato.AsDateTime));
    DosEtiket.Insert(0, ffFirmaSupNavn.AsString);
    if TfmEtk.FriEtiket(DosEtiket, True) then
    begin
      // Gem rettelser
      // ffEksEtk.Edit;
      // ffEksEtkEtiket.Assign(DosEtiket);
      // ffEksEtk.Post;
    end;
  end;

end;

procedure TStamForm.acCF4FindUafExecute(Sender: TObject);
begin
  with MainDm do
  begin
    try
      if ffEksOvr.FindKey([1, StrToInt(eUafLb.Text)]) then
      begin
        dbgrUafsl.SetFocus;
        SidKundeNr := ffEksOvrKundenr.AsString;
        c2logadd('2: sidkundenr ' + SidKundeNr);
      end;
    except
    end;
  end;

end;

procedure TStamForm.acCF4LevnrExecute(Sender: TObject);
var
  save_index: string;
  save_index2: string;
  gebyr: Boolean;
  updateeksp: Boolean;
  udbGebyr: Currency;
  // DebitorRec : TDebitorRec;
begin

  with MainDm do
  begin
    gebyr := False;
    updateeksp := False;
    save_index := ffDebKar.IndexName;
    ffDebKar.IndexName := 'NrOrden';
    save_index2 := ffEksKar.IndexName;
    ffEksKar.IndexName := 'NrOrden';
    try

      if not ffEksKar.FindKey([ffEksOvrLbNr.AsInteger]) then
        exit;
      if Trim(edtLevnr.Text) = '' then
      begin
        // Fjern levnr
        udbGebyr := ffEksOvrUdbrGebyr.AsCurrency;
        if udbGebyr <> 0 then
          gebyr := True;
        if Trim(ffEksOvrLevNavn.AsString) <> '' then
        begin
          if not ChkBoxYesNo('Ekspedition fjernes fra levnr ' +
            ffEksOvrLevNavn.AsString, True) then
            exit;
          updateeksp := True;
          if ffEksOvrKontoNr.AsString <> '' then
          begin
            if ffDebKar.FindKey([ffEksOvrKontoNr.AsString]) then
            begin
              if not ffDebKarUdbrGebyr.AsBoolean then
              begin
                if udbGebyr <> 0 then
                  gebyr := not ChkBoxYesNo
                    ('Tilbagefør udbringningsgebyr ?', True)
                else
                  gebyr := False;

              end;
            end;
            exit;
          end;

          if udbGebyr <> 0 then
            gebyr := not ChkBoxYesNo('Tilbagefør udbringningsgebyr ?', True)
          else
            gebyr := False;

        end;
        exit;
      end;
      // Ret lev nr
      if not ChkBoxYesNo('Lev.nr rettes fra ' + ffEksOvrLevNavn.AsString +
        ' til ' + Trim(edtLevnr.Text), True) then
        exit;
      updateeksp := True;
      if ffDebKar.FindKey([Trim(edtLevnr.Text)]) then
      begin
        gebyr := True;
        udbGebyr := ffEksOvrUdbrGebyr.AsCurrency;
        if ffDebKarLevForm.AsInteger in [5, 6] then
        begin
          gebyr := TfrmGebyr.VaelgGebyr(ffDebKarLevForm.AsInteger, udbGebyr)

        end
        else
        begin
          if ffDebKarUdbrGebyr.AsBoolean then
          begin
            IF udbGebyr = 0 then
              gebyr := TfrmGebyr.VaelgGebyr(ffDebKarLevForm.AsInteger,
                udbGebyr);
          end
          else
            gebyr := False;
        end;
      end
      else
      begin
        ChkBoxOK('Lev.nr ikke findes i debitorkartotek');
        updateeksp := False;
        exit;
      end;
    finally
      if updateeksp then
      begin
        try
          ffEksOvr.Edit;
          ffEksOvrLevNavn.AsString := edtLevnr.Text;
          if gebyr then
            ffEksOvrUdbrGebyr.AsCurrency := udbGebyr
          else
            ffEksOvrUdbrGebyr.AsCurrency := 0;
          ffEksOvr.Post;
          ffEksOvr.Refresh;
          nxEkspLevListe.IndexName := 'LbnrOrden';
          if nxEkspLevListe.FindKey([ffEksOvrLbNr.AsInteger]) then
            nxEkspLevListe.Delete;

          CheckFor0Ekspedition(edtLevnr.Text);

        except
          if ffEksOvr.State <> dsBrowse then
            ffEksOvr.Cancel;
          if ffRcpOpl.State <> dsBrowse then
            ffRcpOpl.Cancel;
          ChkBoxOK('lev.nr kunne ikke rettes !');
        end;
      end;
      ffDebKar.IndexName := save_index;
      ffEksKar.IndexName := save_index2;
    end;
  end;

end;

procedure TStamForm.acCF4NyPakkeExecute(Sender: TObject);
begin
  with MainDm, dmFormularer do
  begin
    if ffEksOvrPakkeNr.Value = 0 then
      exit;
    if PakkeSedPrn <> '' then
      TfmPakkeLaser.UdskrivPakkeSeddelLaser(ffEksOvrPakkeNr.Value);
  end;
end;

procedure TStamForm.acCF4RetKontoExecute(Sender: TObject);
var
  GebyrJa, GebyrNej: Boolean;
  LevForm: Word;
  Pakkenr: LongWord;
  udbGebyr: Currency;


  function UseOldPakkeNr: Boolean;
  begin
    with MainDm do
    begin
      nxOpenPakke.SQL.Text := sl_Sql_GetOldOpenPakkenr.Text;
      nxOpenPakke.Params.ParamByName('Kundenr').AsString := ffEksOvrKundenr.AsString;
      nxOpenPakke.Params.ParamByName('kontonr').AsString := Trim(eUafKoNr.Text);
      c2logadd('kundenr is ' + nxOpenPakke.Params.ParamByName('Kundenr').AsString);
      c2logadd('kontonr is ' + nxOpenPakke.Params.ParamByName('kontonr').AsString);

      try
        nxOpenPakke.Open;

      except
        on e: Exception do
        begin
          c2logadd('Error in nxopenpakke ' + e.Message);
          Result := False;
          exit;
        end;

      end;

      try

        if nxOpenPakke.RecordCount = 0 then
        begin
          Result := False;
          exit;
        end;

        nxOpenPakke.First;
        if not ChkBoxYesNo(' Vil du tilføje denne ekspedition til pakkenr ' +
          nxOpenPakke.fieldbyname('Pakkenr').AsString, True) then
        begin
          Result := False;
          exit;
        end;

        Pakkenr := StrToInt(nxOpenPakke.fieldbyname('Pakkenr').AsString);
        Result := True;
      finally
        nxOpenPakke.Close;
      end;
    end;

  end;

// DebitorRec : TDebitorRec;
begin
  with MainDm do
  begin
    c2logadd('Ret Kontonr pressed on lbnr ' + ffEksOvrLbNr.AsString +
      ' entered kontonr is ' + eUafKoNr.Text + ' eksp kontonr is ' +
      ffEksOvrKontoNr.AsString);
    try
      if ffEksOvrOrdreStatus.Value <> 1 then
      begin
        ChkBoxOK('Ekspedition er afsluttet !');
        exit;
      end;
      // just check that they will change the right lbnr
      if Trim(eUafLb.Text) <> Trim(ffEksOvrLbNr.AsString) then
        if not ChkBoxYesNo('Du har søgt løbenummer ' + eUafLb.Text +
          ', men løbenummer ' + ffEksOvrLbNr.AsString +
          ' er markeret. Vil du fortsætte?', False) then
          exit;

      if Trim(eUafKoNr.Text) = '' then
      begin
        // Fjern forsendelse
        if Trim(ffEksOvrKontoNr.AsString) = '' then
        begin
          ChkBoxOK('Ekspedition mangler kontonr !');
          exit;
        end;

        if not ChkBoxYesNo('Ekspedition fjernes fra konto ' +
          ffEksOvrKontoNr.AsString, True) then
          exit;

        if ffEksOvrLager.AsInteger <> StamForm.FLagerNr then
          ChkBoxOK('Kontoen tilhører et andet lager, så husk at rette lageret manuelt.');
        if ffEksOvrUdbrGebyr.AsCurrency <> 0 then
          GebyrNej := ChkBoxYesNo('Tilbagefør udbringningsgebyr ?', True)
        else
          GebyrNej := False;
        if ffEksKar.FindKey([ffEksOvrLbNr.AsInteger]) then
        begin
          ffEksKar.Edit;
          ffEksKarKontoNr.AsString := '';
          ffEksKarLeveringsForm.Value := 0;
          ffEksKarTurNr.Value := 0;
          ffEksKarPakkeNr.Value := 0;
          ffEksKarAfdeling.Value := MainDm.AfdNr;
          if GebyrNej then
            ffEksKarUdbrGebyr.AsCurrency := 0;
          // F1282 blank the liste nr if accountr is changed
          // ffEksKarListeNr.AsInteger := 0;
          ffEksKarLevNavn.AsString := '';
          ffEksKar.Post;
          // delete from leveringliste
          nxEkspLevListe.IndexName := 'LbnrOrden';
          if nxEkspLevListe.FindKey([ffEksKarLbNr.AsInteger]) then
            nxEkspLevListe.Delete;
          ffEksOvr.Refresh;
        end;
        exit;
      end;
      // Ret kontonr
      (*
        FillChar (DebitorRec, SizeOf (DebitorRec), 0);
        DebitorRec.Nr := Trim (eUafKoNr.Text);
        MidClient.HentDeb (DebitorRec);
        if DebitorRec.Status = 0 then begin
      *)
      if not ffDebKar.FindKey([Trim(eUafKoNr.Text)]) then
      begin
        ChkBoxOK('Debitorkonto findes ikke i kartotek !');
        exit;
      end;

      if ffDebKarKontoLukket.AsBoolean then
      begin
        if Trim(ffDebKarLukketGrund.AsString) <> '' then
          ChkBoxOK('Debitorkonto er lukket : ' + ffDebKarLukketGrund.AsString)
        else
          ChkBoxOK('Debitorkonto er lukket.');
        exit;
      end;
      if not ChkBoxYesNo('Kontonr rettes fra ' + ffEksOvrKontoNr.AsString +
        ' til ' + Trim(eUafKoNr.Text) + ' ' + ffDebKarNavn.AsString, True) then
        exit;

      // check to see if lager will change if so then warn the user

      if ffEksOvrLager.AsInteger <> ffDebKarLager.AsInteger then
        ChkBoxOK('Kontoen tilhører et andet lager, så husk at rette lageret manuelt.');

      // if DebitorRec.UdbrGebyr then
      if ffEksKar.FindKey([ffEksOvrLbNr.AsInteger]) then
      begin
        LevForm := ffDebKarLevForm.AsInteger;
        GebyrJa := True;
        udbGebyr := ffEksKarUdbrGebyr.AsCurrency;
        c2logadd('ffDebKarUdbrGebyr ' + Bool2Str(ffDebKarUdbrGebyr.AsBoolean));
        c2logadd('Levform is ' + inttostr(LevForm));
        c2logadd('ffEksKarEkspType ' + inttostr(ffEksKarEkspType.AsInteger));
        //  set up the correct gebyr value
        if (LevForm in [5, 6])  then
        begin
          ffEksKar.Edit;
          ffEksKarUdbrGebyr.AsCurrency := ffRcpOplHKgebyr.AsCurrency;
          ffEksKar.Post;
        end
        else
        begin
          if ffDebKarUdbrGebyr.AsBoolean then
          begin
            if LevForm in [1, 2] then
            begin
              ffEksKar.Edit;
              case LevForm of
                1:
                  ffEksKarUdbrGebyr.AsCurrency :=
                    ffRcpOplPlejehjemsgebyr.AsCurrency;
                2:
                  ffEksKarUdbrGebyr.AsCurrency := ffRcpOplUdbrGebyr.AsCurrency;
              end;
              ffEksKar.Post;
            end;

          end;

        end;

        if (ffDebKarUdbrGebyr.AsBoolean) or
          ((LevForm in [5, 6])  ) then
        begin
          IF (udbGebyr = 0) or ((LevForm in [5, 6])  )
          then
            GebyrJa := TfrmGebyr.VaelgGebyr(LevForm, udbGebyr)
        end
        else
          GebyrJa := False;

        try
          // LevForm := DebitorRec.SendeType;
          // Tildel pakkenr ved Bud=2 HK=5 Udlev=6 eller
          // Udsalg=4 og pakkeseddel
          Pakkenr := 0;
          if (LevForm in [2, 5, 6]) or
            ((LevForm = 4) and (ffRcpOplPakSedUdsalg.AsBoolean)) then
          begin
            if not UseOldPakkeNr then
            begin
              ffRcpOpl.First;
              ffRcpOpl.Edit;
              Pakkenr := ffRcpOplPakkeNr.Value;
              ffRcpOplPakkeNr.Value := Pakkenr + 1;
              ffRcpOpl.Post;
            end;
          end;
          ffEksOvr.Edit;
          ffEksOvrKontoNr.AsString := ffDebKarKontoNr.AsString;
          // ffEksOvrKontoNr.AsString     := Trim (DebitorRec.Nr);
          ffEksOvrLeveringsForm.Value := LevForm;
          ffEksOvrPakkeNr.Value := Pakkenr;
          ffEksOvrAfdeling.AsInteger := ffDebKarAfdeling.AsInteger;
          ffEksOvrUdbrGebyr.AsCurrency := 0;
          if GebyrJa then
            ffEksOvrUdbrGebyr.AsCurrency := udbGebyr;
          // F1282 blank the liste nr if accountr is changed
          ffEksOvrListeNr.AsInteger := 0;
          ffEksOvr.Post;
          // delete from leveringliste
          nxEkspLevListe.IndexName := 'LbnrOrden';
          if nxEkspLevListe.FindKey([ffEksOvrLbNr.AsInteger]) then
            nxEkspLevListe.Delete;

          ffEksOvr.Refresh;

          // check to see if konto is Privat

          if LevForm = 1 then
            TKontoFraTilForm.OpdaterFraTilKonto(ffEksOvrKontoNr.AsString,
              ffEksOvrKontoNr.AsString);

          // CJS here print pakkelist
        except
          on e: Exception do
          begin
            ChkBoxOK('Debitorkonto kunne ikke rettes ! ' + e.Message);
            if ffEksOvr.State <> dsBrowse then
              ffEksOvr.Cancel;
            if ffRcpOpl.State <> dsBrowse then
              ffRcpOpl.Cancel;
          end;
        end;
      end;
    finally
      c2logadd('Bottom of ret kontonr');
    end;
  end;

end;

procedure TStamForm.acCF4RetYdernrExecute(Sender: TObject);
var
  ilen: Integer;
  lnavn: string;
begin
  with MainDm do
  begin
    try
      if edtRetYderNr.Text = '' then
        exit;
      if not CheckYderNr(ffEksOvrKundeType.AsInteger, edtRetYderNr.Text) then
      begin
        ChkBoxOK('Fejl i Lægens ydernr !');
        exit;
      end;
      if not ChkBoxYesNo('Ret Ydernr fra ' + ffEksOvrYderNr.AsString + ' til ' +
        edtRetYderNr.Text + '?', False) then
        exit;
      lnavn := '';
      if edtRetAutNr.Text <> '' then
      begin
        ilen := Length(edtRetAutNr.Text);
        if (ilen <> 5) and (ilen <> 10) then
        begin
          ChkBoxOK('Aut.Nr er ikke korrekt');
          exit;
        end;

        if ilen = 10 then
        begin
          if not DisableCPRModulusCheck then
          begin

            if not CheckCprNr(1, edtRetAutNr.Text) then
            begin
              ChkBoxOK('Fejl i Aut.Nr');
              exit;
            end;

          end;
        end;
        ffYdLst.IndexName := 'YderNrOrden';
        if ffYdLst.FindKey([edtRetYderNr.Text, edtRetAutNr.Text]) then
          lnavn := ffYdLstNavn.AsString;
      end;
      ffEksOvr.Edit;
      ffEksOvrYderNr.AsString := edtRetYderNr.Text;
      ffEksOvrYderNavn.AsString := lnavn;
      ffEksOvrYderCprNr.AsString := edtRetAutNr.Text;
      ffEksOvr.Post;

    finally

    end;
  end;

end;

procedure TStamForm.acCF4UdUafExecute(Sender: TObject);
var
  PNr: Word;
  FraDato, TilDato: TDateTime;
  Pat: Currency;
  Patient, Navn, Konto, CPRnr, LbNr, Dato: String;
  UafLst: TStringList;
  Afdelingnr: Integer;
  SortType: Integer;
  sqltxt: string;
begin
  with MainDm do
  begin
    if not ChkBoxYesNo('Skal uafsluttet liste udskrives ?', True) then
      exit;

    FraDato := FirstDayDate(Date);
    TilDato := LastDayDate(Date);
    if not TastDatoer('Tast ønsket datointerval !', FraDato, TilDato, Afdelingnr, SortType) then
      exit;

    BusyMouseBegin;
    UafLst := TStringList.Create;
    sqltxt := 'select * from table(uafreport(' + inttostr(SortType) + ',' +
        'cast(''' + FormatDateTime('yyyy-mm-dd', FraDato) + ''' as date),' +
        'cast(''' + FormatDateTime('yyyy-mm-dd', TilDato) + ''' as date),' +
        inttostr(Afdelingnr) + ')) as uaf';
    try
      with nxdb.OpenQuery(sqltxt,[]) do
      begin
        try
          if not eof  then
          begin
            PNr := 0;
            First;
            try

              while not Eof do
              begin
                LbNr := format('%8d', [fieldbyname('Lbnr').AsInteger]);
                LbNr := LbNr + ' ';
                Dato := FormatDateTime('ddmmyy', fieldbyname('Takserdato').AsDateTime);
                Navn := copy(Trim(fieldbyname('Navn').AsString), 1, 25);
                Navn := Navn.padright(25);
                CPRnr := fieldbyname('Kundenr').AsString;
                CPRnr := CPRnr.PadRight(13) + ' ';
                Konto := fieldbyname('Kontonr').AsString;
                Konto := Konto.PadRight(10);
                Pat := fieldbyname('Pat').AsCurrency;
                if fieldbyname('Ordretype').Value = 2 then
                  Pat := -Pat;
                Patient := FormCurr2Str('###,##0.00', Pat);
                UafLst.add(Dato + LbNr + CPRnr + Navn + Konto + Patient);
                Next;
              end;
            except
              on e : Exception do
              begin
                ChkBoxOK('dfejl i cf4 dsrkriv ' + e.Message);
              end;

            end;

          end;

        finally
          Free;
        end;


      end;

      UafLst.Insert(0, 'Dato    Løbenr nr            Navn                      nr             Andel');
      UafLst.Insert(0, 'Ekspeditionens Kunde                                   Konto        Patient');
      UafLst.Insert(0, '');
      UafLst.Insert(0, ffFirmaNavn.AsString);
      UafLst.Insert(0, 'U A F S L U T T E D E   E K S P E D I T I O N E R');
      UafLst.SaveToFile('C:\C2\Temp\UafListe.Txt');
      PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\UafListe.Txt');
    finally
      UafLst.Free;
      BusyMouseEnd;
    end;
  end;


end;

procedure TStamForm.CheckBatchLogon;
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  BatchStarted := False;
  try
    // if not CitoEkspeditionAktiv then
    // exit;
    IF CitoEkspeditionAktiv then
    begin
      BatchStarted := True;
      exit;
    end;
    if not FileExists('G:\temp\Batch' + inttostr(maindm.BrugerNr) + '.txt') then
      exit;
    sl.LoadFromFile('G:\temp\Batch' + inttostr(maindm.BrugerNr) + '.txt');
    if sl.Count = 0 then
      exit;
    BatchStarted := True;
    if not ChkBoxYesNo('Citoekspedition er i gang.' + sLineBreak +
      'Vil du fortsætte med at opsamle ekspeditioner til stregkodekontrol og kasseindslag?',
      False) then
    begin
      DeleteFile('G:\temp\Batch' + inttostr(maindm.BrugerNr) + '.txt');
      BatchStarted := False;
    end;

  finally
    sl.Free;

  end;

end;

procedure TStamForm.dbgrEkspDblClick(Sender: TObject);
//var
//  LLbnr : integer;
begin
//  with MainDm do
//  begin
//    LLbnr := dsEksOvr.dataset.fieldbyname('Lbnr').AsInteger;
//    C2LogAdd('Before sql version ' + FormatDateTime('hh:mm:s.zzz',Now));
//    KoelProductOnEkspedition(LLbnr);
//    C2LogAdd('after sql version ' + FormatDateTime('hh:mm:s.zzz',Now));
//    C2LogAdd('Before table version ' + FormatDateTime('hh:mm:s.zzz',Now));
//    KoelProductOnEkspeditionOld(LLbnr);
//    C2LogAdd('after table version ' + FormatDateTime('hh:mm:s.zzz',Now));
//
//
//  end;
end;

procedure TStamForm.dbgrEkspDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  with MainDm do
  begin
    try
      if dsEksOvr.dataset = ffEksOvr then
      begin
        if dsEksOvr.dataset.fieldbyname('Ordrestatus').AsInteger = 1 then
        begin
          dbgrEksp.Canvas.Brush.Color := tcolor($82DDEE);
          if dsEksOvr.dataset.fieldbyname('Kontonr').AsString <> '' then
            dbgrEksp.Canvas.Brush.Color := tcolor($70FFFF);
          dbgrEksp.Canvas.Font.Color := clBlack;
        end;
        if dsEksOvr.dataset.fieldbyname('Ordrestatus').AsInteger = 2 then
        begin
          if dsEksOvr.dataset.fieldbyname('Kontonr').AsString <> '' then
          begin
            dbgrEksp.Canvas.Brush.Color := clYellow;
            if dsEksOvr.dataset.fieldbyname('Bonnr').AsString <> '' then
              dbgrEksp.Canvas.Brush.Color := tcolor($00A5FF);
          end;
          dbgrEksp.Canvas.Font.Color := clBlack;
        end;
        if dsEksOvr.dataset.fieldbyname('Kontrolfejl').AsInteger = 9 then
        begin
          nxEksCred.IndexName := 'LbNrOrden';
          if dsEksOvr.dataset.fieldbyname('UdlignNr').AsInteger = 0 then
            if not nxEksCred.FindKey
              ([dsEksOvr.dataset.fieldbyname('Lbnr').AsInteger]) then
              dbgrEksp.Canvas.Brush.Color := clFuchsia;
        end;
      end
      else
      begin
        if dsEksOvr.dataset.fieldbyname('Status').AsString = 'Åben' then
        begin
          dbgrEksp.Canvas.Brush.Color := tcolor($82DDEE);
          if dsEksOvr.dataset.fieldbyname('Konto').AsString <> '' then
            dbgrEksp.Canvas.Brush.Color := tcolor($70FFFF);
          dbgrEksp.Canvas.Font.Color := clBlack;
        end
        else
        begin
          if dsEksOvr.dataset.fieldbyname('Konto').AsString <> '' then
          begin
            dbgrEksp.Canvas.Brush.Color := clYellow;
            if dsEksOvr.dataset.fieldbyname('Bonnr').AsString <> '' then
              dbgrEksp.Canvas.Brush.Color := tcolor($00A5FF);
          end;
          dbgrEksp.Canvas.Font.Color := clBlack;
        end;
        if dsEksOvr.dataset.fieldbyname('Kontrolfejl').AsInteger = 9 then
        begin
          nxEksCred.IndexName := 'LbNrOrden';
          if dsEksOvr.dataset.fieldbyname('Udlign Nr').AsInteger = 0 then
            if not nxEksCred.FindKey
              ([dsEksOvr.dataset.fieldbyname('Lbnr').AsInteger]) then
              dbgrEksp.Canvas.Brush.Color := clFuchsia;

        end;
      end;

    finally
      if gdSelected in State then
      begin
        dbgrEksp.Canvas.Brush.Color := clBlue;
        dbgrEksp.Canvas.Font.Color := clWhite;
      end;

      dbgrEksp.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
  end;

end;

procedure TStamForm.dbgrForsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
begin
  with MainDm do
  begin
    try
      if dsEksOvr.dataset.fieldbyname('Bonnr').AsString <> '' then
        dbgrFors.Canvas.Brush.Color := tcolor($00A5FF);

      dbgrFors.Canvas.Font.Color := clBlack;

    finally
      if gdSelected in State then
      begin
        dbgrFors.Canvas.Brush.Color := clBlue;
        dbgrFors.Canvas.Font.Color := clWhite;
      end;

      dbgrFors.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
  end;
end;

procedure TStamForm.dbgrUafslDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  with MainDm do
  begin
    if dsEksOvr.dataset.fieldbyname('Kontrolfejl').AsInteger = 9 then
    begin
      nxEksCred.IndexName := 'LbNrOrden';
      if not nxEksCred.FindKey([dsEksOvr.dataset.fieldbyname('Lbnr').AsInteger])
      then
        dbgrUafsl.Canvas.Brush.Color := clFuchsia;
    end;

    dbgrUafsl.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;

end;

procedure TStamForm.acIndbCtrExecute(Sender: TObject);
begin
  with MainDm do
  begin
    if not ChkBoxYesNo('Indberet løbenr ' + inttostr(ffEksOvrLbNr.Value) + ' til CTR ?', True) then
      exit;
    BusyMouseBegin;

    try
      AfslLbNr := ffEksOvrLbNr.Value;
      // OpdaterCTR;
      ffCtrOpd.Insert;
      ffCtrOpdNr.AsInteger := ffEksOvrLbNr.AsInteger;
      ffCtrOpdDato.AsDateTime := ffEksOvrOrdreDato.AsDateTime;
      ffCtrOpd.Post;
    finally
      BusyMouseEnd;
    end;
  end;
end;

procedure TStamForm.dbgrLinierDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  with MainDm do
  begin
    try
      nxLager.IndexName := 'NrOrden';
      if nxLager.FindKey([fflinovrLager.AsInteger, ffLinOvrSubVareNr.AsString])
      then
      begin
        if copy(nxLagerDrugId.AsString, 1, 4) = CannabisPrefix then
        begin
          dbgrLinier.Canvas.Brush.Color := clWebOrange;
          exit;
        end;
      end;
      // mark udligning to ctrb as orange
      if (ffLinOvrSubVareNr.AsString = '100015')  and (copy(ffLinOvrTekst.AsString,1,5) = 'CTR-B') then
      begin
        dbgrLinier.Canvas.Brush.Color := clWebOrange;
        exit;
      end;

      if dsEksOvr.dataset.fieldbyname('Kontrolfejl').AsInteger <> 9 then
        exit;
      nxEkspLinKon.IndexName := 'NrOrden';
      if not nxEkspLinKon.FindKey([ffLinOvrLbNr.AsInteger,
        ffLinOvrLinieNr.AsInteger]) then
        exit;
      if (nxEkspLinKonOpKode.AsInteger <> 0) then
        exit;
      if (nxEkspLinKonFejlkode.AsInteger <> 9) then
        exit;
      nxEksCred.IndexName := 'LbNrOrden';
      if not nxEksCred.FindKey([ffLinOvrLbNr.AsInteger,
        ffLinOvrLinieNr.AsInteger]) then
        dbgrLinier.Canvas.Brush.Color := clFuchsia;
    finally
      dbgrLinier.DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
  end;

end;

procedure TStamForm.ButUdTurLst2Click(Sender: TObject);
var
  EkspTyp, FraTur, TilTur, PakAnt, Idx, Max, PNr: Word;
  Andel, Tilsk, Total: Currency;
  FraDato, TilDato: TDateTime;
  RcpKon, RecOk: Boolean;
  FraKonto, TilKonto, Konto, GemIdx, STotLin, SOpkrBel, SKont, SNavn, SLbNr,
    SFaktNr, SAdr, SPakkeNr: String;
  UdLst: TStringList;
  SQL: string;
  Copypakkenr: string;
  CopyAndel: Currency;
  CopyCount: Integer;
  UdskrivCount: Integer;
  KontoSl: TStringList;
  save_CPR: string;
  i: Integer;
  j: Integer;
  PatSl: TStringList;
  tmpline: string;
  PatCount: Integer;
  PatTotal: Currency;
  tmpstr: string;
  firstdetail: Boolean;
  LevListeNr: Integer;
  FirstLine: Boolean;
  AfslutList: Boolean;
  Koel: Boolean;
  hkcnt : integer;

  procedure GetLeveringsListeNumber;
  begin
    with MainDm do
    begin
      ffRcpOpl.First;
      ffRcpOpl.Edit;
      ffRcpOplListeNr.AsInteger := ffRcpOplListeNr.AsInteger + 1;
      LevListeNr := ffRcpOplListeNr.AsInteger;
      ffRcpOpl.Post;

    end;

  end;

  procedure UpdateLeveringslisteNumber(ilbnr: Integer; Konto: string);
  begin
    with MainDm do
    begin
      nxEkspLevListe.Append;
      nxEkspLevListeListeNr.AsInteger := LevListeNr;
      nxEkspLevListeLbNr.AsInteger := ilbnr;
      nxEkspLevListeDato.AsDateTime := Now;
      nxEkspLevListeKonto.AsString := Konto;
      nxEkspLevListe.Post;

    end;
  end;


begin
  with MainDm do
  begin
    c2logadd('Leveringsliste2 start');
    FraKonto := edtNr.Text;
    TilKonto := edtNr.Text;
    FraDato := Date;
    TilDato := Now;
    FraTur := ffRcpOplTurNr.AsInteger;
    TilTur := FraTur;
    EkspTyp := 0;
    RcpKon := False;
    KontoSl := TStringList.Create;
    PatSl := TStringList.Create;
    Koel := False;
    try
      if not UdskrivForsendelse(FraKonto, TilKonto, FraDato, TilDato, FraTur,
        TilTur, EkspTyp, RcpKon, UdskrivCount, AfslutList) then
        exit;

      KontoNrMinMax2(FraKonto, TilKonto, KontoSl);
      if KontoSl.Count = 0 then
      begin
        ChkBoxOK('Kontonumre ikke fundet');
        exit;
      end;
      for Konto in KontoSl do
      begin
        // FraDato:= DateMinTime(FraDato);
        // TilDato:= DateMaxTime(TilDato);
        if not ffDebKar.FindKey([Konto]) then
        begin
          ChkBoxOK('Forsendelseskonto ' + Konto + ' findes ikke !');
          Continue;
        end;
        c2logadd('Leveringsliste parametre');
        c2logadd('  Konto: ' + Konto);
        c2logadd('  Fradato: ' + FormatDateTime('dd-mm-yyyy HH:mm', FraDato));
        c2logadd('  Tildato: ' + FormatDateTime('dd-mm-yyyy HH:mm', TilDato));
        c2logadd('  Fratur: ' + inttostr(FraTur));
        c2logadd('  Tiltur: ' + inttostr(TilTur));
        c2logadd('  Eksptype: ' + inttostr(EkspTyp));
        Screen.Cursor := crHourGlass;
        PNr := 0;
        UdLst := TStringList.Create;
        Total := 0;

        try
          SQL := sl_Sql_leveringliste.Text;
          fqLevList.Close;
          fqLevList.SQL.Text := SQL;
          fqLevList.ParamByName('konto').AsString := Konto;
          fqLevList.ParamByName('FraDato').AsString := FormatDateTime('yyyy-mm-dd hh:mm:ss', FraDato);
          fqLevList.ParamByName('TilDato').AsString := FormatDateTime('yyyy-mm-dd hh:mm:ss', TilDato);
          fqLevList.ParamByName('StartTur').AsInteger := FraTur;
          fqLevList.ParamByName('EndTur').AsInteger := TilTur;
          fqLevList.TimeOut := 100000;
          try
            C2LogAdd('Before fqlevlist open');
            fqLevList.Open;
            C2LogAdd('After fqlevlist open');
          except
            on e: Exception do
              ChkBoxOK(e.Message);
          end;
          if fqLevList.RecordCount = 0 then
            Continue;

          // Leveringsliste

          // Gennemløb
          Copypakkenr := '';
          CopyAndel := 0;
          PakAnt := 0;
          save_CPR := '';
          PatSl.Clear;
          PatCount := 0;
          PatTotal := 0;
          FirstLine := True;
          LevListeNr := 0;
          while not fqLevList.Eof do
          begin
            if (EkspTyp <> 0) and
              (fqLevList.fieldbyname('ordrestatus').AsInteger <> EkspTyp) then
            begin
              fqLevList.Next;
              Continue;
            end;
            if FindLevnr(fqLevList.fieldbyname('Lbnr').AsInteger) then
            begin
              fqLevList.Next;
              Continue;
            end;
            if AfslutList then
            begin
              if FirstLine then
                GetLeveringsListeNumber;
              FirstLine := False;

              UpdateLeveringslisteNumber(fqLevList.fieldbyname('Lbnr').AsInteger, Konto);

            end;
            if save_CPR <> fqLevList.fieldbyname('Kundenr').AsString then
            begin
              if save_CPR <> '' then
              begin
                if PatSl.Count <> 0 then
                begin
                  tmpline := '';
                  firstdetail := True;
                  for i := 0 to PatSl.Count - 1 do
                  begin
                    if tmpline = '' then
                      tmpline := Copypakkenr + '(' + PatSl.Strings[i]
                    else
                    begin
                      tmpstr := tmpline + ',' + PatSl.Strings[i];
                      if Length(tmpstr) > 60 then
                      begin
                        tmpline := tmpline + ',';
                        if firstdetail then
                          if Koel then
                            UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)])
                              + FormCurr2Str('  ###,##0.00', CopyAndel) + ' Køl')
                          else
                            UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)])
                              + FormCurr2Str('  ###,##0.00', CopyAndel))
                        else
                          UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]));
                        tmpline := '   ' + PatSl.Strings[i];
                        firstdetail := False;
                      end
                      else
                        tmpline := tmpstr;
                    end;
                  end;
                  Copypakkenr := 'xxx';
                  tmpline := tmpline + ')';
                  if firstdetail then
                    if Koel then
                      UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                        FormCurr2Str('  ###,##0.00', CopyAndel) + ' Køl')
                    else
                      UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                        FormCurr2Str('  ###,##0.00', CopyAndel))
                  else
                    UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]));
                  tmpline := '';
                end;
                if PatCount > 1 then
                begin
                  UdLst.add(format('%-60.60s', ['']) + '------------');
                  UdLst.add(format('%-60.60s', ['']) + FormCurr2Str('  ###,##0.00', PatTotal));
                  UdLst.add(format('%-60.60s', ['']) + '------------');
                end;
                PatSl.Clear;
                UdLst.add('');
                Koel := False;
              end;
              SNavn := Trim(fqLevList.fieldbyname('Navn').AsString);
              SNavn := SNavn.PadRight(34);
              SAdr := Trim(fqLevList.fieldbyname('Address').AsString);
              UdLst.add('[BOLD-ON]' + SNavn + SAdr + '[BOLD-OFF]');
              PatSl.Clear;
              Koel := False;
              PatCount := 0;
              PatTotal := 0;
            end;
            SPakkeNr := fqLevList.fieldbyname('Pakkenr').AsString;
            save_CPR := fqLevList.fieldbyname('Kundenr').AsString;
            Andel := fqLevList.fieldbyname('Andel').AsCurrency;
            if fqLevList.fieldbyname('Kontonr').AsString <> Konto then
              Andel := 0;
            if Andel < 0 then
              SKont := '   ';
            Total := Total + Andel;
            SOpkrBel := FormCurr2Str(' ###,##0.00', Andel);
            if Copypakkenr <> '' then
            begin
              if Copypakkenr = SPakkeNr then
              begin
                CopyAndel := CopyAndel + Andel;
              end
              else
              begin
                if PatSl.Count <> 0 then
                begin
                  tmpline := '';
                  firstdetail := True;
                  for i := 0 to PatSl.Count - 1 do
                  begin
                    if tmpline = '' then
                      tmpline := Copypakkenr + '(' + PatSl.Strings[i]
                    else
                    begin
                      tmpstr := tmpline + ',' + PatSl.Strings[i];
                      if Length(tmpstr) > 60 then
                      begin
                        tmpline := tmpline + ',';
                        if firstdetail then
                          if Koel then
                            UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)])
                              + FormCurr2Str('  ###,##0.00', CopyAndel) + ' Køl')
                          else
                            UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)])
                              + FormCurr2Str('  ###,##0.00', CopyAndel))
                        else
                          UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]));
                        tmpline := '   ' + PatSl.Strings[i];
                        firstdetail := False;
                      end
                      else
                        tmpline := tmpstr;
                    end;
                  end;
                  Copypakkenr := 'xxx';
                  tmpline := tmpline + ')';
                  if firstdetail then
                    if Koel then
                      UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                        FormCurr2Str('  ###,##0.00', CopyAndel) + ' Køl')
                    else
                      UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                        FormCurr2Str('  ###,##0.00', CopyAndel))
                  else
                    UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]));
                  tmpline := '';
                end;
                CopyAndel := Andel;
                PakAnt := PakAnt + 1;
                PatSl.Clear;
                Koel := False;
              end;
            end;
            if Copypakkenr = '' then
            begin
              CopyAndel := Andel;
              PakAnt := 1;
            end;
            Copypakkenr := SPakkeNr;
            tmpstr := fqLevList.fieldbyname('Lbnr').AsString;
            hkcnt := CountHandkoebLines(fqLevList.fieldbyname('Lbnr').AsInteger);
            if not Koel then
              Koel := KoelProductOnEkspedition(fqLevList.fieldbyname('Lbnr').AsInteger);
            if fqLevList.fieldbyname('EkspType').AsInteger = et_Dosispakning then
              tmpstr := tmpstr + ' D'
            else if fqLevList.fieldbyname('EkspType').AsInteger = et_Haandkoeb then
              tmpstr := tmpstr + ' H'
            else if fqLevList.fieldbyname('BrugerKontrol').AsInteger = 0 then
            begin
              if (fqLevList.FieldByName('OrdreType').AsInteger <> 2)
                and ((AlleVnr) and (hkcnt = 0))
                and (not UdligningEkspedition(fqLevList.fieldbyname('Lbnr').AsInteger))
                and (not NulPakkelistEkspedition(fqLevList.fieldbyname('Lbnr').AsInteger))  then
                  tmpstr := tmpstr + '*';
            end;
            if fqLevList.fieldbyname('Fakturanr').AsInteger <> 0 then
              tmpstr := tmpstr + '/' + fqLevList.fieldbyname
                ('Fakturanr').AsString;
            PatSl.add(tmpstr);
            fqLevList.Next;
          end;
          if PatSl.Count <> 0 then
          begin
            tmpline := '';
            firstdetail := True;
            for i := 0 to PatSl.Count - 1 do
            begin
              if tmpline = '' then
                tmpline := Copypakkenr + '(' + PatSl.Strings[i]
              else
              begin
                tmpstr := tmpline + ',' + PatSl.Strings[i];
                if Length(tmpstr) > 60 then
                begin
                  tmpline := tmpline + ',';
                  if firstdetail then
                    if Koel then
                      UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                        FormCurr2Str('  ###,##0.00', CopyAndel) + ' Køl')
                    else
                      UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                        FormCurr2Str('  ###,##0.00', CopyAndel))
                  else
                    UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]));
                  tmpline := '   ' + PatSl.Strings[i];
                  firstdetail := False;
                end
                else
                  tmpline := tmpstr;
              end;
            end;
            PatSl.Clear;
            Copypakkenr := 'xxx';
            tmpline := tmpline + ')';
            if firstdetail then
              if Koel then
                UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                  FormCurr2Str('  ###,##0.00', CopyAndel) + ' Køl')
              else
                UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                  FormCurr2Str('  ###,##0.00', CopyAndel))
            else
              UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]));
            tmpline := '';
            Koel := False;
          end;
          if PatCount > 1 then
          begin
            UdLst.add(format('%-60.60s', ['']) + '------------');
            UdLst.add(format('%-60.60s', ['']) + FormCurr2Str('  ###,##0.00', PatTotal));
            UdLst.add(format('%-60.60s', ['']) + '------------');
          end;
          UdLst.add('');

          // Leveringsliste
          STotLin := 'Opkræves i alt for ' + inttostr(PakAnt) + ' pakker';
          STotLin := STotLin.PadRight(60) + FormCurr2Str('#,###,##0.00', Total);
          UdLst.add(StringOfChar('-', 72));
          UdLst.add(STotLin);
          UdLst.add(StringOfChar('=', 72));
          UdLst.Insert(0, '');
          UdLst.Insert(0, 'Kundenavn & adresse                                                Beløb Køl');
          // UdLst.Insert(0, '         1         2         3         4         5         6         7;
          // UdLst.Insert(0, '123456789012345678901234567890123 xnnnnnnnxnnnnnnnxnnnnnnn nnn,nnn.nn nn;
          UdLst.Insert(0, '');
          UdLst.Insert(0, '             ' + ffDebKarPostNr.AsString + ' ' + ffDebKarBy.AsString);
          if Trim(ffDebKarAdr2.AsString) <> '' then
            UdLst.Insert(0, '             ' + ffDebKarAdr2.AsString);
          if Trim(ffDebKarAdr1.AsString) <> '' then
            UdLst.Insert(0, '             ' + ffDebKarAdr1.AsString);
          UdLst.Insert(0, '');
          UdLst.Insert(0, '[BOLD-ON]Leveres til: ' + Konto + ' ' + ffDebKarNavn.AsString + '[BOLD-OFF]');
          UdLst.Insert(0, '');
          if LevListeNr <> 0 then
            UdLst.Insert(0, 'Listenr. ' + inttostr(LevListeNr))
          else
            UdLst.Insert(0, '');
          UdLst.Insert(0, '');
          UdLst.Insert(0, ffFirmaNavn.AsString);
          UdLst.Insert(0, 'L E V E R I N G S L I S T E');
          UdLst.SaveToFile('C:\C2\Temp\LevListe2.Txt');
          if UdskrivCount = 0 then
            UdskrivCount := 1;
          for i := 1 to UdskrivCount do
            PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\LevListe2.Txt');
        finally
          fqLevList.Close;
          UdLst.Free;
          Screen.Cursor := crDefault;
        end;
      end;
    finally
      KontoSl.Free;
      PatSl.Free;
    end;
    c2logadd('Leveringsliste2 slut');
  end;
end;

procedure TStamForm.acEfterRegExecute(Sender: TObject);
begin
  if StamPages.ActivePage <> EkspPage then
    exit;

  var LSaveIndex := saveandadjustIndexName(maindm.ffeksovr,'NrOrden');
  try
//    if not MainDm.ffEksOvr.FindKey([MainDm.fqEksOvrLbnr.AsInteger]) then
//    begin
//      ChkBoxOK('Ekspedition ' + MainDm.fqEksOvrLbnr.AsString + ' findes ikke');
//      Exit;
//    end;
    CF3EfterReg;
  finally
    AdjustIndexName(MainDm.ffEksOvr,LSaveIndex);
  end;
end;

procedure TStamForm.acEHandleExecute(Sender: TObject);
var
  Ehnr: Cardinal;
  save_index: string;
  EOrdreNummer: string;
begin
  with MainDm do
  begin
    try
      EOrdreNummer := Save_EordreNr;
      if not InputQuery('Søg Ehandelordre på ordrenummer', 'EordreNummer', EOrdreNummer) then
        exit;
      EOrdreNummer := caps(EOrdreNummer);
      Save_EordreNr := EOrdreNummer;
      if TakserPaaEordrenr then
      begin
        save_index := SaveAndAdjustIndexName(nxOrd,'NrOrden');
        try
          if not nxOrd.FindKey([EOrdreNummer]) then
          begin
            ChkBoxOK('Eordre findes ikke');
            exit;
          end;
          Ehnr := nxOrdC2Nr.AsInteger
        finally
          AdjustIndexName(nxOrd, save_index);
        end;

      end
      else
      begin
        Ehnr := StrToInt(EOrdreNummer);
        save_index := SaveAndAdjustIndexName(nxOrd, 'C2NrOrden');
        try
          if not nxOrd.FindKey([Ehnr]) then
          begin
            ChkBoxOK('Eordre findes ikke');
            exit;
          end;
        finally
          AdjustIndexName(nxOrd, save_index);
        end;
      end;

      if nxOrdPrintStatus.AsInteger in [2, 4] then
      begin
        if not ChkBoxYesNo
          ('Ehandel-ordren er takseret. Skal den takseres igen?', False) then
          exit;
      end;

      if nxOrdPrintStatus.AsInteger = 99 then
      begin
        if not ChkBoxYesNo
          ('Denne ordre er annulleret. Ønsker du at ekspedere alligevel?', False)
        then
          exit;
      end;

      TakserEh(Ehnr);
    finally
      nxOrd.Refresh;

    end;

  end;
end;

procedure TStamForm.acFejlFormExecute(Sender: TObject);
begin
  TfrmRcpKont.showRcpKont(Sender);
end;

procedure TStamForm.acFkeysFortrydExecute(Sender: TObject);
begin
  StamEscHandler;

end;

procedure TStamForm.acFkeysFortrydUpdate(Sender: TObject);
begin
//  (Sender as TAction).Enabled := C2ButEsc.Enabled;
end;

procedure TStamForm.lvFMKPrescriptionsCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  strdate1, strdate2: string;
  strstatus1: string;
  strstatus2: string;
begin

  strdate1 := Item1.SubItems[lvFMKDato];
  strdate2 := Item2.SubItems[lvFMKDato];

  strstatus1 := Item1.SubItems[lvFMKStatus];
  strstatus2 := Item2.SubItems[lvFMKStatus];
  if strstatus1 = 'Ugyldig' then
  begin
    Compare := 1;
    exit;
  end;
  if strstatus2 = 'Ugyldig' then
  begin
    Compare := -1;
    exit;
  end;

  if strdate1 < strdate2 then
    Compare := 1;

  if strdate1 = strdate2 then
    Compare := 0;

  if strdate1 > strdate2 then
    Compare := -1;

end;

procedure TStamForm.Panel5Resize(Sender: TObject);
begin
  dbgrLinier.Width := (Panel5.Width - 10) div 2;
  dbgrTilskud.Width := dbgrLinier.Width;
end;

procedure TStamForm.PrintDosisEkspedition(APrescriptionId : string);
var
  SetInProgress: Boolean;
  RSErrorMessage: string;
  LPrescriptionId : int64;
  LPrescription : TC2FMKPrescription;
  ReceivedLbnr: Integer;
  LFMKErrorString : string;
  LQry : TnxQuery;
begin

  // does the user still have a certificate before we call fmk routines
  if not CurrentLogonIsValid(maindm.Bruger,maindm.Afdeling,ltAll) then
  begin
    Close;
    exit;
  end;
  UpdateStatusBrugerInfo;


  btnGetMedList.Enabled := False;
  btnTakser.Enabled := False;
  // SetInProgress:= ChkBoxYesNo('Ordination(er) sættes under behandling?',True);
  SetInProgress := False;
  BusyMouseBegin;
  try
    // if (not SetInProgress) and (not printRecept) then begin
    // c2logadd('not set in progress and not print recept.....why?');
    /// /      ChkBoxOK('Ordination are not set in progress and not printed.');
    // exit;
    // end;
    LPrescriptionId := StrToInt64Def(APrescriptionId,-1);
    if LPrescriptionId = -1 then
      exit;

    SplashScreenShow(Nil, 'Ekspedition', 'Afventer FMK');
    SplashScreenUpdate('');
    try

      LPrescription := MainDm.PrescriptionsForPO.Prescriptions.GetPrescriptionByID(LPrescriptionId);
      if not uFMKGetMedsById.FMKGetPrescriptionById(MainDm.AfdNr,LPrescription, SetInProgress,ReceivedLbnr,LFMKErrorString) then
      begin
        C2LogAdd(LFMKErrorString);
        ChkBoxOK(RSErrorMessage);
        exit;
      end;

      with MainDm do
      begin
        // tell rsmidsrv to print it

        RCPMidCli.SendRequest('GetAddressed',
          ['4', ReceivedLbnr, IntToStr(MainDm.AfdNr), MainDm.C2UserName, Bool2Str(True)], 10);

        LQry := nxdb.OpenQuery('delete from rs_ekspeditioner where ReceptId=:Receptid',[ReceivedLbnr]);
        try
          C2LogAdd('Rowsaffected is ' + IntToStr(LQry.RowsAffected));

        finally
          LQry.Free;
        end;

        LQry := nxdb.OpenQuery('delete from rs_eksplinier where ReceptId=:Receptid',[ReceivedLbnr]);
        try
          C2LogAdd('Rowsaffected is ' + IntToStr(LQry.RowsAffected));

        finally
          LQry.Free;
        end;

      end;

    finally
      SplashScreenHide;
    end;
  finally
    BusyMouseEnd;
    edtCprNr.SetFocus;
    btnGetMedList.Enabled := True;
    btnTakser.Enabled := True;
    edtCprNr.SelectAll;
    edtCprNr.SetFocus;
  end;

end;

procedure TStamForm.WMCopyData(var Msg: TWMCopyData);
var
  S: String;
  cr: Char;
  tickno: string;
  ipos: Integer;
  LBrnr : integer;
begin
  with MainDm do
  begin
    try
      S := string(PANSIChar(Msg.CopyDataStruct.lpData));
      if pos('BRUGER=', S) <> 0 then
      begin
        LBrNr := StrToIntDef(copy(S, 8, 4),-1);
        if LBrnr = -1 then
          exit;

        Bruger.AutoLogOn(LBrNr,Afdeling);
        if not bruger.HasUserCertificate then
        begin
          if (StamPages.ActivePage = RSRemotePage) or (StamPages.ActivePage = RSLocalPage) then
            StamPages.ActivePage := KartotekPage;


        end;


        if StamPages.ActivePage = KartotekPage then
        begin
          PostMessage(Handle, WM_SetButtons, 0, 0);
          PostMessage(EKundeNr.Handle, WM_SETFOCUS, 0, 0);
        end;
        UpdateStatusBrugerInfo;
        exit;
      end;

      c2logadd('Message from kasse is ' + S);
      ipos := pos(';', S);
      if ipos = 0 then
      begin
        if S <> 'Blank' then
          SidKundeNr := S;
        tickno := '';
      end
      else
      begin
        SidKundeNr := copy(S, 1, ipos - 1);
        Delete(S, 1, ipos);
        tickno := S;
      end;

      if C2QButtonPressed then
      begin
          if SidKundeNr <> 'Blank' then
          begin
              EKundeNr.Text := SidKundeNr;
              EKundeNr.SelectAll;
            // now switch back to cf1
            if StamPages.ActivePage <> KartotekPage then
              StamPages.ActivePage := KartotekPage
            else
            begin

                cr := #13;
                StamForm.EKundeNrKeyPress(StamForm.EKundeNr, cr);

            end;
          end
          else
          begin
            if StamPages.ActivePage = KartotekPage then
            begin
              EKundeNr.Text := KundeKeyBlk;
              EKundeNr.SelectAll;
              ffPatKar.FindKey([KundeKeyBlk]);
              gbDosis.Visible := False;
            end;
          end;

          if tickno <> '' then
          begin
            timClock.Enabled := False;
            lblC2Q.Caption := tickno;
            lblC2Q.Visible := True;
            timClock.Enabled := True;
          end;

      end;
      C2QButtonPressed := False;
      c2logadd('message: sidkundenr ' + SidKundeNr);

    finally
      // Send something back
      Msg.Result := 2006;
    end;

  end;
end;

procedure TStamForm.dbgEHOrdDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  i: Integer;
  DBGrid1: TDBGrid;
begin
  with MainDm do
  begin
    DBGrid1 := Sender as TDBGrid;
    i := nxOrdPrintStatus.AsInteger;
    case i of
      0:
        DBGrid1.Canvas.Brush.Color := clBlue;
      2:
        DBGrid1.Canvas.Brush.Color := clYellow;
      4:
        DBGrid1.Canvas.Brush.Color := clLime;
      99:
        DBGrid1.Canvas.Brush.Color := clRed;
    end;
    if (nxOrdBeskedFraKunde.AsString <> '') and (DataCol = 0) then
      DBGrid1.Canvas.Brush.Color := clWebOrange;
    if (nxOrdBeskedFraApotek.AsString <> '') and (DataCol = 0) then
      DBGrid1.Canvas.Brush.Color := clWebOrange;
    DBGrid1.Canvas.Font.Color := clBlack;
    DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;

end;

procedure TStamForm.dbgLocalRSDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  YellowLine: Boolean;
  AquaLine: Boolean;
  LGreenLine : boolean;

begin
  with MainDm do
  begin
    try
      YellowLine := False;
      AquaLine := False;
      LGreenLine := False;
      if Trim(nxRSEkspListOrdreInstruks.AsString) <> '' then
        YellowLine := True;
      if Trim(nxRSEkspListLeveringsInfo.AsString) <> '' then
        YellowLine := True;
      if Trim(nxRSEkspListLeveringPri.AsString) <> '' then
        YellowLine := True;
      if Trim(nxRSEkspListLeveringAdresse.AsString) <> '' then
        YellowLine := True;
      if Trim(nxRSEkspListLeveringPseudo.AsString) <> '' then
        YellowLine := True;
      if Trim(nxRSEkspListLeveringPostNr.AsString) <> '' then
        YellowLine := True;
      if Trim(nxRSEkspListLeveringKontakt.AsString) <> '' then
        YellowLine := True;
      if Trim(MainDm.nxRSEkspListDosis.AsString) <> '' then
      begin
        YellowLine := False;
        AquaLine := True;
      end;


      AdjustIndexName(nxRSEkspLin, 'Receptidorder');
      nxRSEkspLin.SetRange([nxRSEkspListReceptId.AsInteger],[nxRSEkspListReceptId.AsInteger]);
      try
        nxRSEkspLin.First;
        while not nxRSEkspLin.Eof do
        begin
          if not nxRSEkspLinBestiltAfNavn.AsString.IsEmpty then
          begin
            LGreenLine := True;
            break;
          end;
          if not nxRSEkspLinBestiltAfOrgNavn.AsString.IsEmpty then
          begin
            LGreenLine := True;
            break;
          end;


          nxRSEkspLin.Next;
        end;
      finally
        nxRSEkspLin.CancelRange;
      end;

      dbgLocalRS.Canvas.Brush.Color := clWhite;
      dbgLocalRS.Canvas.Font.Color := clWindowText;
      if LGreenLine then
      begin
        dbgLocalRS.Canvas.Brush.Color := clLime;
        dbgLocalRS.Canvas.Font.Color := clBlack;
      end;

      if AquaLine then
      begin
        dbgLocalRS.Canvas.Brush.Color := clAqua;
        dbgLocalRS.Canvas.Font.Color := clBlack;
      end;
      if YellowLine then
      begin
        dbgLocalRS.Canvas.Brush.Color := clYellow;
        dbgLocalRS.Canvas.Font.Color := clBlack;
      end;
      if LGreenLine then
      begin
        dbgLocalRS.Canvas.Brush.Color := clLime;
        dbgLocalRS.Canvas.Font.Color := clBlack;
      end;
      if CF6Selected.IndexOf(dbgLocalRS.DataSource.dataset.GetBookmark) <> -1
      then
      begin
        dbgLocalRS.Canvas.Brush.Color := tcolor($99FFFF);
        dbgLocalRS.Canvas.Font.Color := clBlack;
      end;
    finally
      if gdSelected in State then
      begin
        dbgLocalRS.Canvas.Brush.Color := clBlue;
        dbgLocalRS.Canvas.Font.Color := clWhite;
      end;

      dbgLocalRS.DefaultDrawColumnCell(Rect, DataCol, Column, State);

    end;
  end;
end;

procedure TStamForm.dbgLocalRSKeyPress(Sender: TObject; var Key: Char);
var
  i: Integer;
  EkspCompleted: Boolean;
  Frigiv: Boolean;
  AllFrigiv: Boolean;
  DosisLine: Boolean;
  SaveIndex: string;
  LbNr: Integer;
begin
  if Key <> ' ' then
    exit;


  // need to ask here id they want to add the lines to the order
  with MainDm do
  begin
    if not nxRSEkspListDosis.AsString.IsEmpty then
    begin
      ChkBoxOK('Ordinationen er markeret til dosisdispensering, og skal behandles og takseres i dosisprogrammet.');
      exit;
    end;

    // next check each line. if all are completed then messagebox
    BusyMouseBegin;
    try
      EkspCompleted := False;
      Frigiv := False;
      AllFrigiv := True;
      DosisLine := False;
      SaveIndex := nxRSEkspLin.IndexName;
      LbNr := nxRSEkspListReceptId.AsInteger;

      // check to see if takser in progress
      if nxRSEkspListReceptStatus.AsInteger > 90 then
      begin
        c2logadd('**** Takser requested for ReceptStatus > 90');
        if not frmYesNo.NewYesNoBox
          ('Det ser ud til, at der er (eller har været) en igangværende ekspedition på denne receptkvittering.'
          + sLineBreak + 'Er du sikker på, at du vil fortsætte ekspedition?') then
          exit;
        c2logadd('**** Takser ACCEPTED with receptstatus >90');
      end;

      AdjustIndexName(nxRSEkspLin, 'ReceptIDOrder');
      nxRSEkspLin.SetRange([LbNr], [LbNr]);
      try
        nxRSEkspLin.First;
        while not nxRSEkspLin.Eof do
        begin
          // CheckReturn := DMRSGetMeds.CheckMedbyId(nxRSEkspLinOrdId.AsString,FAfdNr);
          //
          // if CheckReturn = 1 then begin
          // ChkBoxOK('Ordination id ' + nxRSEkspLinOrdId.AsString + ' findes ikke på receptserver');
          // exit;
          // end;
          // if CheckReturn = 2 then begin
          //
          // if not ChkBoxYesNo('Receptserveren svarer ikke. Vil du ekspedere ordinationen?',True) then
          // exit;
          // end;
          //
          if nxRSEkspLinFrigivStatus.AsInteger = 1 then
          begin
            Frigiv := True;
          end
          else
            AllFrigiv := False;
          if Trim(nxRSEkspLinDosStartDato.AsString) <> '' then
            DosisLine := True;
          nxRSEkspLin.Next;
        end;

      finally
        nxRSEkspLin.CancelRange;
        nxRSEkspLin.IndexName := SaveIndex;

      end;

      if Frigiv then
      begin
        IF AllFrigiv then
        begin
          ChkBoxOK('Alle ordinationer på denne recept er frigivet til andet apotek');
          exit;
        end
        else
          ChkBoxOK('Mindst én ordination på denne receptkvittering er blevet frigivet til andet apotek');
      end;

      if DosisLine then
      begin
        if not ChkBoxYesNo('En eller flere ordinationer skal dosispakkes.' +
          slinebreak + 'Vil du fortsætte taksering?', False) then
          exit;
      end;

      if nxRSEkspLbNr.AsInteger <> 0 then
      begin
        EkspCompleted := True;
        SaveIndex := SaveAndAdjustIndexName(nxRSEkspLin, 'ReceptIDOrder');
        nxRSEkspLin.SetRange([LbNr], [LbNr]);
        try
          nxRSEkspLin.First;
          while not nxRSEkspLin.Eof do
          begin
            if nxRSEkspLinRSLbnr.AsInteger = 0 then
            begin
              EkspCompleted := False;
              break;
            end;

            nxRSEkspLin.Next;
          end;

        finally
          nxRSEkspLin.CancelRange;
          AdjustIndexName(nxRSEkspLin, SaveIndex);

        end;

      end;

      if EkspCompleted then
      begin
        if not ChkBoxYesNo
          ('Recepten er allerede ekspederet. Vil du ekspedere igen?', False)
        then
          exit;
      end;

      i := CF6Selected.IndexOf(dbgLocalRS.DataSource.dataset.GetBookmark);
      if i = -1 then
        CF6Selected.add(dbgLocalRS.DataSource.dataset.GetBookmark)
      else
        CF6Selected.Delete(i);
    finally
      dbgLocalRS.Repaint;
      BusyMouseEnd;
    end;
  end;

end;

procedure TStamForm.DBGrid4DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  YellowLine: Boolean;
  Redline: Boolean;
  AquaLine: Boolean;
  LGreyLine : boolean;
  LLtGreenLine : boolean;
begin
  with MainDm do
  begin
    YellowLine := False;
    Redline := False;
    AquaLine := False;
    LGreyLine := False;
    LLtGreenLine := False;
    if Trim(nxRSEkspLinListSupplerende.AsString) <> '' then
      YellowLine := True;
    if Trim(nxRSEkspLinListOrdreInstruks.AsString) <> '' then
      YellowLine := True;
    if Trim(nxRSEkspLinListApotekBem.AsString) <> '' then
      YellowLine := True;
    if Trim(nxRSEkspLinListDosStartDato.AsString) <> '' then
      AquaLine := True;
    if nxRSEkspLinListFrigivStatus.AsInteger = 1 then
      Redline := True;
    if nxRSEkspLinier.FindField('Privat') <> Nil then
    begin
      if nxRSEkspLinList.FieldByName('Privat').AsInteger <> 0 then
        LGreyLine := True;
    end;
    if nxRSEkspLinListBestiltAfNavn.AsString <> '' then
      LLtGreenLine := True;


    if YellowLine then
    begin
      DBGrid4.Canvas.Brush.Color := clYellow;
      DBGrid4.Canvas.Font.Color := clBlack;
    end;
    if AquaLine then
    begin
      DBGrid4.Canvas.Brush.Color := clAqua;
      DBGrid4.Canvas.Font.Color := clBlack;
    end;
    if Redline then
    begin
      DBGrid4.Canvas.Brush.Color := clRed;
      DBGrid4.Canvas.Font.Color := clBlack;
    end;
    if LGreyLine then
    begin
      DBGrid4.Canvas.Brush.Color := clLtGray;
      DBGrid4.Canvas.Font.Color := clBlack;
    end;
    if LLtGreenLine then
    begin
      DBGrid4.Canvas.Brush.Color := clLime;
      DBGrid4.Canvas.Font.Color := clBlack;
    end;


    DBGrid4.DefaultDrawColumnCell(Rect, DataCol, Column, State);

  end;

end;

procedure TStamForm.acVisRSExecute(Sender: TObject);
var
  i: Integer;
  LMedId: Int64;
  LPrescription : TC2FMKPrescription;
begin
  if StamPages.ActivePage = KartotekPage then
  begin
    eMobil.SetFocus;
    exit;
  end;
  if StamPages.ActivePage = RSLocalPage then
  begin
    cboVisDosis.SetFocus;
    exit;
  end;

  if StamPages.ActivePage <> RSRemotePage then
    exit;

  BusyMouseBegin;
  try
    i := lvFMKPrescriptions.ItemIndex;
    if i <> -1 then
    begin
      if TryStrToInt64(lvFMKPrescriptions.Items[i].Caption,LMedId) then
      begin
        LPrescription := MainDm.PrescriptionsForPO.Prescriptions.GetPrescriptionByID(LMedId);
        TfrmOrdView.ShowOrdView(LPrescription,FLagerNr,edtCprNr.Text);
      end;
    end;
  finally
    BusyMouseEnd;
  end;

end;

procedure TStamForm.acOpdCTRExecute(Sender: TObject);
begin
  CtrTimer.Enabled := False;
  try
    TfrmOpdCTR.ShowOpdCTR;
  finally
    CtrTimer.Enabled := True;
  end;

end;

function TStamForm.CheckMedIdInCF6(MedId: string): Boolean;
var
  RsLineIndex: string;
begin
  with MainDm do
  begin
    Result := False;
    RsLineIndex := SaveAndAdjustIndexName(nxRSEkspLin, 'OrdIDOrden');
    try
      nxRSEkspLin.SetRange([MedId], [MedId]);
      try
        if nxRSEkspLin.RecordCount = 0 then
          exit;
        nxRSEkspLin.First;
        while not nxRSEkspLin.Eof do
        begin
          if nxRSEkspLinLbNr.AsInteger = 0 then
          begin
            Result := True;
            exit;
          end;
          nxRSEkspLin.Next;
        end;
      finally
        nxRSEkspLin.CancelRange;
      end;

    finally
      AdjustIndexName(nxRSEkspLin, RsLineIndex);
    end;

  end;
end;

procedure TStamForm.CheckMoreOpenRCP(ABefore: Boolean);
var
  LQry : TnxQuery;
  LSql : string;
  LKundenr : string;
begin

  if not GoAuto then
    exit;

  LSql := maindm.sl_SQL_OpenEdi.Text;
  if ABefore then
  begin
    LKundenr := Trim(copy(MainDm.ffPatKarKundeNr.AsString, 1, 10));
    LQry := MainDm.nxdb.OpenQuery(LSql,[LKundenr]);
    try
      if LQry.RecordCount > 0 then
      begin
        LQry.Last;
        ChkBoxOK('Bemærk, der er ikke takseret ordination fra: ' + LQry.FieldByName('dato').AsString);

      end;
    finally
      LQry.Free;
    end;
    exit;
  end;

  LKundenr := Trim(copy(SidKundeNr, 1, 10));
  LQry := MainDm.nxdb.OpenQuery(LSql,[LKundenr]);
  try
    if LQry.RecordCount > 0 then
    begin
      LQry.Last;
      if ChkBoxYesNo('Bemærk, der er ikke takseret ordination fra: ' + LQry.FieldByName('dato').AsString + sLineBreak +
        'Vil du gå til Lokale recepter[CF6]?', True) then
      begin
        MainDm.ffPatKar.FindKey([SidKundeNr]);
        JumpToZeroLbnr := True;
        StamPages.ActivePage := RSLocalPage;
      end;

    end;
  finally
    LQry.Free;
  end;

end;


procedure TStamForm.btnRetLevListNrClick(Sender: TObject);
var
  Konto: string;
  save_index: string;
  // DebitorRec : TDebitorRec;
  find_mode: Integer;
begin
  with MainDm do
  begin
    save_index := nxEkspLevListe.IndexName;
    find_mode := cboFors.ItemIndex;
    try
      if Trim(edtLevListNr.Text) = '' then
      begin
        // Fjern levnr

        if Trim(ffEksOvrListeNr.AsString) <> '' then
        begin

          case find_mode of

            0:
              begin
                if ChkBoxYesNo('Pakkenr ' + ffEksOvrPakkeNr.AsString +
                  ' fjernes fra leveringsliste ' + ffEksOvrListeNr.AsString +
                  '?', True) then
                begin
                  nqEkspLevListe.Close;
                  nqEkspLevListe.SQL.Clear;
                  nqEkspLevListe.SQL.add('delete from EkspLeveringsListe');
                  nqEkspLevListe.SQL.add('where lbnr in (select lbnr from Ekspeditioner where Pakkenr = :pakkenr);');
                  nqEkspLevListe.ParamByName('Pakkenr').AsInteger :=
                    ffEksOvrPakkeNr.AsInteger;
                  nqEkspLevListe.Open;
                  nqEkspLevListe.Close;
                  ffEksOvr.Refresh;
                end;
              end;

            1:
              begin
                if ChkBoxYesNo('Fakturanr ' + ffEksOvrFakturaNr.AsString +
                  ' fjernes fra leveringsliste ' + ffEksOvrListeNr.AsString +
                  '?', True) then
                begin
                  nqEkspLevListe.Close;
                  nqEkspLevListe.SQL.Clear;
                  nqEkspLevListe.SQL.Add('delete from EkspLeveringsListe');
                  nqEkspLevListe.SQL.Add('where lbnr in (select lbnr from Ekspeditioner where Fakturanr = :fakturanr);');
                  nqEkspLevListe.ParamByName('Fakturanr').AsInteger :=
                    ffEksOvrFakturaNr.AsInteger;
                  nqEkspLevListe.Open;
                  nqEkspLevListe.Close;
                  ffEksOvr.Refresh;
                end;
              end;

          end;

        end;
        exit;

      end;

      // Ret lev nr
      nxEkspLevListe.IndexName := 'ListeNrOrden';
      if not nxEkspLevListe.FindKey([StrToInt(edtLevListNr.Text)]) then
      begin
        ChkBoxOK('Leveringsliste findes ikke');
        exit;
      end;
      Konto := nxEkspLevListeKonto.AsString;
      if (Konto <> ffEksOvrKontoNr.AsString) and
        (Konto <> ffEksOvrLevNavn.AsString) then
      begin
        ChkBoxOK('Denne ekspedition har ikke konto ' + Konto +
          ' som konto eller leveringsnr. Den kan derfor ikke tilføjes til listen.');
        exit;
      end;

      case find_mode of

        0:
          begin
            if not ChkBoxYesNo('Pakkenr ' + ffEksOvrPakkeNr.AsString +
              ' tilføj til leveringsliste ' + edtLevnr.Text + '?', True) then
              exit;
            nqEkspLevListe.Close;
            nqEkspLevListe.SQL.Clear;
            nqEkspLevListe.SQL.Add('delete from EkspLeveringsListe');
            nqEkspLevListe.SQL.Add('where lbnr in (select lbnr from Ekspeditioner where Pakkenr = :pakkenr);');
            nqEkspLevListe.SQL.Add('insert into EkspLeveringsListe');
            nqEkspLevListe.SQL.Add('  select ');
            nqEkspLevListe.SQL.Add('    :Listenr,');
            nqEkspLevListe.SQL.Add('    lbnr,');
            nqEkspLevListe.SQL.Add('    current_timestamp,');
            nqEkspLevListe.SQL.Add('    :Konto');
            nqEkspLevListe.SQL.Add('  from ');
            nqEkspLevListe.SQL.Add('    ekspeditioner');
            nqEkspLevListe.SQL.Add('  where ');
            nqEkspLevListe.SQL.Add('    Pakkenr= :Pakkenr;');
            nqEkspLevListe.ParamByName('Pakkenr').AsInteger :=
              ffEksOvrPakkeNr.AsInteger;
            nqEkspLevListe.ParamByName('Listenr').AsInteger :=
              nxEkspLevListeListeNr.AsInteger;
            nqEkspLevListe.ParamByName('Konto').AsString := Konto;

            nqEkspLevListe.Open;
            nqEkspLevListe.Close;
            ffEksOvr.Refresh;
          end;

        1:
          begin
            if not ChkBoxYesNo('Fakturanr ' + ffEksOvrFakturaNr.AsString +
              ' tilføj til leveringsliste ' + edtLevnr.Text + '?', True) then
              exit;
            nqEkspLevListe.Close;
            nqEkspLevListe.SQL.Clear;
            nqEkspLevListe.SQL.Add('delete from EkspLeveringsListe');
            nqEkspLevListe.SQL.Add('where lbnr in (select lbnr from Ekspeditioner where Fakturanr = :Fakturanr);');
            nqEkspLevListe.SQL.Add('insert into EkspLeveringsListe');
            nqEkspLevListe.SQL.Add('  select ');
            nqEkspLevListe.SQL.Add('    :Listenr,');
            nqEkspLevListe.SQL.Add('    lbnr,');
            nqEkspLevListe.SQL.Add('    current_timestamp,');
            nqEkspLevListe.SQL.Add('    :Konto');
            nqEkspLevListe.SQL.Add('  from ');
            nqEkspLevListe.SQL.Add('    ekspeditioner');
            nqEkspLevListe.SQL.Add('  where ');
            nqEkspLevListe.SQL.Add('    Fakturanr = :Fakturanr;');
            nqEkspLevListe.ParamByName('Fakturanr').AsInteger :=
              ffEksOvrFakturaNr.AsInteger;
            nqEkspLevListe.ParamByName('Listenr').AsInteger :=
              nxEkspLevListeListeNr.AsInteger;
            nqEkspLevListe.ParamByName('Konto').AsString := Konto;
            nqEkspLevListe.Open;
            nqEkspLevListe.Close;
            ffEksOvr.Refresh;
          end;

      end;

    finally
      nxEkspLevListe.IndexName := save_index;
    end;
  end;

end;

procedure TStamForm.MnuReprintleveringslist1Click(Sender: TObject);
var
  PakAnt, Idx, Max, PNr: Word;
  Andel, Total: Currency;
  RecOk: Boolean;
  FraKonto, TilKonto, Konto, STotLin, SOpkrBel, SKont, SNavn, SLbNr, SFaktNr,
    SAdr, SPakkeNr: String;
  UdLst: TStringList;
  SQL: string;
  Copypakkenr: string;
  CopyAndel: Currency;
  CopyCount: Integer;
  LevListeNr: Integer;
  Koel: Boolean;
  hkcnt : integer;


begin
  with MainDm do
  begin
    c2logadd('Genudskriv Leveringsliste start');
    FraKonto := edtNr.Text;
    TilKonto := edtNr.Text;
    Total := 0;
    try
      UdLst := TStringList.Create;
      try
        LevListeNr := TfrmVaelgLevliste.VaelgLeveringste;
        if LevListeNr = 0 then
          exit;

        SQL := 'SELECT TOP 1 konto FROM "EkspLeveringsListe" WHERE listenr=:listenr';
        fqLevList.Close;
        fqLevList.SQL.Text := SQL;
        fqLevList.ParamByName('listenr').AsInteger := LevListeNr;
        fqLevList.TimeOut := 100000;
        try
          fqLevList.Open;
        except
          on e: Exception do
            ChkBoxOK(e.Message);
        end;

        if fqLevList.RecordCount = 0 then
        begin
          ChkBoxOK('Leveringsliste findes ikke');
          exit;
        end;

        Konto := fqLevList.fieldbyname('konto').AsString;

        ffDebKar.IndexName := 'NrOrden';
        ffDebKar.FindKey([Konto]);

        SQL := sl_Sql_leveringlisteByListenr.Text;
        fqLevList.Close;
        fqLevList.SQL.Text := SQL;
        fqLevList.ParamByName('listenr').AsInteger := LevListeNr;
        fqLevList.TimeOut := 100000;
        try
          fqLevList.Open;
        except
          on e: Exception do
            ChkBoxOK(e.Message);
        end;

        if fqLevList.RecordCount = 0 then
        begin
          ChkBoxOK('Leveringsliste findes ikke');
          exit;
        end;

        // Gennemløb
        Copypakkenr := '';
        CopyAndel := 0;
        CopyCount := 0;
        PakAnt := 0;
        while not fqLevList.Eof do
        begin
          Koel := KoelProductOnEkspedition(fqLevList.fieldbyname('Lbnr').AsInteger);
          hkcnt := CountHandkoebLines(fqLevList.fieldbyname('Lbnr').AsInteger);
          SLbNr := format('%8d', [fqLevList.fieldbyname('Lbnr').AsInteger]);
          SFaktNr := format('%8d',
            [fqLevList.fieldbyname('Fakturanr').AsInteger]);
          SPakkeNr := format('%8d',
            [fqLevList.fieldbyname('Pakkenr').AsInteger]);
          SKont := ' **';
          if fqLevList.FieldByName('Eksptype').AsInteger = et_Dosispakning then
            SKont := '   ';
          if fqLevList.FieldByName('OrdreType').AsInteger = 2 then
            SKont := '   ';
          if (not AlleVnr) and (hkcnt <> 0) then
            SKont := '   ';
          if UdligningEkspedition(fqLevList.fieldbyname('Lbnr').AsInteger) then
            SKont := '   ';
          if NulPakkelistEkspedition(fqLevList.fieldbyname('Lbnr').AsInteger) then
            SKont := '   ';
          if fqLevList.fieldbyname('BrugerKontrol').Value > 0 then
            SKont := format('%3d', [fqLevList.fieldbyname('BrugerKontrol')
              .AsInteger]);
          SNavn := Trim(fqLevList.fieldbyname('Navn').AsString);
          SNavn := SNavn + Spaces(34 - Length(SNavn));
          SAdr := Trim(fqLevList.fieldbyname('Address').AsString);
          Andel := fqLevList.fieldbyname('Andel').AsCurrency;
          if fqLevList.fieldbyname('Kontonr').AsString <> Konto then
            Andel := 0;
          if Andel < 0 then
            SKont := '   ';
          if fqLevList.fieldbyname('EkspType').AsInteger = et_Dosispakning then
            SKont := ' D ';
          if fqLevList.fieldbyname('EkspType').AsInteger = et_Haandkoeb then
            SKont := ' H ';
          Total := Total + Andel;
          SOpkrBel := FormCurr2Str(' ###,##0.00', Andel);
          if Copypakkenr <> '' then
          begin
            if Copypakkenr = SPakkeNr then
            begin
              CopyAndel := CopyAndel + Andel;
              CopyCount := CopyCount + 1;
            end
            else
            begin
              if CopyCount > 1 then
              begin
                UdLst.add(Spaces(59) + '==========');
                UdLst.add('Samlet beløb for pakkenr' + Spaces(18) + Copypakkenr
                  + Spaces(8) + FormCurr2Str(' ###,##0.00', CopyAndel));
                UdLst.add(Spaces(59) + '==========');

              end;
              CopyAndel := Andel;
              CopyCount := 1;
              PakAnt := PakAnt + 1;
            end;
          end;
          if Koel then
            UdLst.add(SNavn + SLbNr + SPakkeNr + SFaktNr + SOpkrBel + SKont +
              ' Køl ' + SAdr)
          else
            UdLst.add(SNavn + SLbNr + SPakkeNr + SFaktNr + SOpkrBel + SKont +
              '     ' + SAdr);
          if Copypakkenr = '' then
          begin
            CopyAndel := Andel;
            CopyCount := 1;
            PakAnt := 1;
          end;
          Copypakkenr := SPakkeNr;
          fqLevList.Next;
        end;
        if Copypakkenr <> '' then
        begin
          if CopyCount > 1 then
          begin
            UdLst.add(Spaces(59) + '==========');
            UdLst.add('Samlet beløb for pakkenr' + Spaces(18) + Copypakkenr +
              Spaces(8) + FormCurr2Str(' ###,##0.00', CopyAndel));
            UdLst.add(Spaces(59) + '==========');
          end;
        end;

        // Split navn og adresse linier
        repeat
          RecOk := False;
          Max := UdLst.Count - 1;
          for Idx := 0 to Max do
          begin
            SNavn := UdLst.Strings[Idx];
            if Length(SNavn) > 77 then
            begin
              SAdr := '  ' + copy(SNavn, 78, Length(SNavn) - 77);
              SNavn := copy(SNavn, 1, 77);
              UdLst.Strings[Idx] := SNavn;
              if Idx < Max then
                UdLst.Insert(Idx + 1, SAdr)
              else
                UdLst.add(SAdr);
              RecOk := True;
              break;
            end;
          end;
        until not RecOk;
        // Leveringsliste
        STotLin := 'Opkræves i alt for ' + inttostr(PakAnt) + ' pakker';
        STotLin := STotLin + Spaces(60 - Length(STotLin)) +
          FormCurr2Str('#,###,##0.00', Total);
        UdLst.add(FixStr('-', 72));
        UdLst.add(STotLin);
        UdLst.add(FixStr('=', 72));
        UdLst.Insert(0, '');
        UdLst.Insert(0,
          'Kundenavn & adresse                 Løbenr Pakkenr Fakt.nr      Beløb KB Køl');
        // UdLst.Insert(0, '         1         2         3         4         5         6         7;
        // UdLst.Insert(0, '123456789012345678901234567890123 xnnnnnnnxnnnnnnnxnnnnnnn nnn,nnn.nn nn;
        UdLst.Insert(0, '');
        UdLst.Insert(0, '             ' + ffDebKarPostNr.AsString + ' ' +
          ffDebKarBy.AsString);
        if Trim(ffDebKarAdr2.AsString) <> '' then
          UdLst.Insert(0, '             ' + ffDebKarAdr2.AsString);
        if Trim(ffDebKarAdr1.AsString) <> '' then
          UdLst.Insert(0, '             ' + ffDebKarAdr1.AsString);
        UdLst.Insert(0, '');
        UdLst.Insert(0, 'Leveres til: ' + Konto + ' ' + ffDebKarNavn.AsString);
        UdLst.Insert(0, '');
        UdLst.Insert(0, 'Listenr. ' + inttostr(LevListeNr));
        UdLst.Insert(0, '');
        UdLst.Insert(0, ffFirmaNavn.AsString);
        UdLst.Insert(0, 'L E V E R I N G S L I S T E');
        UdLst.SaveToFile('C:\C2\Temp\LevListe.Txt');
        PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\LevListe.Txt');
      finally
        fqLevList.Close;
        UdLst.Free;
        Screen.Cursor := crDefault;
      end;
    finally
    end;
    c2logadd('Leveringsliste by listenr slut');
  end;
end;

procedure TStamForm.MnuGenudskrivKortLeveringslisteClick(Sender: TObject);
var
  PakAnt, PNr: Word;
  Andel, Total: Currency;
  FraKonto, TilKonto, Konto, STotLin, SOpkrBel, SKont, SNavn, SAdr,
    SPakkeNr: String;
  UdLst: TStringList;
  SQL: string;
  Copypakkenr: string;
  CopyAndel: Currency;
  KontoSl: TStringList;
  save_CPR: string;
  i: Integer;
  PatSl: TStringList;
  tmpline: string;
  PatCount: Integer;
  PatTotal: Currency;
  tmpstr: string;
  firstdetail: Boolean;
  LevListeNr: Integer;
  Koel: Boolean;
  hkcnt: Integer;

begin
  with MainDm do
  begin
    c2logadd('Leveringsliste2 start');
    FraKonto := edtNr.Text;
    TilKonto := edtNr.Text;
    KontoSl := TStringList.Create;
    PatSl := TStringList.Create;
    UdLst := TStringList.Create;
    try
      try
        LevListeNr := TfrmVaelgLevliste.VaelgLeveringste;
        c2logadd('levlistenr ' + inttostr(LevListeNr));
        if LevListeNr = 0 then
          exit;
        SQL := 'SELECT TOP 1 konto FROM "EkspLeveringsListe" WHERE listenr=:listenr';
        c2logadd(SQL);
        fqLevList.Close;
        fqLevList.SQL.Text := SQL;
        fqLevList.ParamByName('listenr').AsInteger := LevListeNr;
        fqLevList.TimeOut := 100000;
        try
          fqLevList.Open;
        except
          on e: Exception do
            ChkBoxOK(e.Message);
        end;

        if fqLevList.RecordCount = 0 then
        begin
          ChkBoxOK('Leveringsliste findes ikke');
          exit;
        end;

        Konto := fqLevList.fieldbyname('konto').AsString;
        ffDebKar.IndexName := 'NrOrden';
        ffDebKar.FindKey([Konto]);
        c2logadd('after konto');
        SQL := sl_Sql_leveringlisteByListenr.Text;
        fqLevList.Close;
        fqLevList.SQL.Text := SQL;
        fqLevList.ParamByName('listenr').AsInteger := LevListeNr;
        fqLevList.TimeOut := 100000;
        try
          fqLevList.Open;
        except
          on e: Exception do
            ChkBoxOK(e.Message);
        end;

        if fqLevList.RecordCount = 0 then
        begin
          ChkBoxOK('Leveringsliste findes ikke');
          exit;
        end;

        // Leveringsliste

        // Gennemløb
        Copypakkenr := '';
        CopyAndel := 0;
        PakAnt := 0;
        save_CPR := '';
        PatSl.Clear;
        PatCount := 0;
        PatTotal := 0;
        Total := 0;
        c2logadd('before levlist loop');
        try

          fqLevList.First;
          while not fqLevList.Eof do
          begin
            c2logadd('in loop kundenr is ' + fqLevList.fieldbyname('Kundenr')
              .AsString);
            if save_CPR <> fqLevList.fieldbyname('Kundenr').AsString then
            begin
              if save_CPR <> '' then
              begin
                if PatSl.Count <> 0 then
                begin
                  tmpline := '';
                  firstdetail := True;
                  for i := 0 to PatSl.Count - 1 do
                  begin
                    if tmpline = '' then
                      tmpline := Copypakkenr + '(' + PatSl.Strings[i]
                    else
                    begin
                      tmpstr := tmpline + ',' + PatSl.Strings[i];
                      if Length(tmpstr) > 60 then
                      begin
                        tmpline := tmpline + ',';
                        if firstdetail then
                          if Koel then
                            UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)])
                              + FormCurr2Str('  ###,##0.00',
                              CopyAndel) + ' Køl')
                          else
                            UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)])
                              + FormCurr2Str('  ###,##0.00', CopyAndel))
                        else
                          UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]));
                        tmpline := '   ' + PatSl.Strings[i];
                        firstdetail := False;
                      end
                      else
                        tmpline := tmpstr;
                    end;
                  end;
                  Copypakkenr := 'xxx';
                  tmpline := tmpline + ')';
                  if firstdetail then
                    if Koel then
                      UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                        FormCurr2Str('  ###,##0.00', CopyAndel) + ' Køl')
                    else
                      UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                        FormCurr2Str('  ###,##0.00', CopyAndel))
                  else
                    UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]));
                  tmpline := '';
                end;
                if PatCount > 1 then
                begin
                  UdLst.add(format('%-60.60s', ['']) + '------------');
                  UdLst.add(format('%-60.60s', ['']) +
                    FormCurr2Str('  ###,##0.00', PatTotal));
                  UdLst.add(format('%-60.60s', ['']) + '------------');
                end;
                PatSl.Clear;
                Koel := False;
                UdLst.add('');
              end;
              SNavn := Trim(fqLevList.fieldbyname('Navn').AsString);
              SNavn := SNavn + Spaces(34 - Length(SNavn));
              SAdr := Trim(fqLevList.fieldbyname('Address').AsString);
              UdLst.add('[BOLD-ON]' + SNavn + SAdr + '[BOLD-OFF]');
              PatSl.Clear;
              Koel := False;
              PatCount := 0;
              PatTotal := 0;
            end;
            SPakkeNr := fqLevList.fieldbyname('Pakkenr').AsString;
            save_CPR := fqLevList.fieldbyname('Kundenr').AsString;
            Andel := fqLevList.fieldbyname('Andel').AsCurrency;
            if fqLevList.fieldbyname('Kontonr').AsString <> Konto then
              Andel := 0;
            if Andel < 0 then
              SKont := '   ';
            Total := Total + Andel;
            SOpkrBel := FormCurr2Str(' ###,##0.00', Andel);
            if Copypakkenr <> '' then
            begin
              if Copypakkenr = SPakkeNr then
              begin
                CopyAndel := CopyAndel + Andel;
              end
              else
              begin
                if PatSl.Count <> 0 then
                begin
                  tmpline := '';
                  firstdetail := True;
                  for i := 0 to PatSl.Count - 1 do
                  begin
                    if tmpline = '' then
                      tmpline := Copypakkenr + '(' + PatSl.Strings[i]
                    else
                    begin
                      tmpstr := tmpline + ',' + PatSl.Strings[i];
                      if Length(tmpstr) > 60 then
                      begin
                        tmpline := tmpline + ',';
                        if firstdetail then
                          if Koel then
                            UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)])
                              + FormCurr2Str('  ###,##0.00',
                              CopyAndel) + ' Køl')
                          else
                            UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)])
                              + FormCurr2Str('  ###,##0.00', CopyAndel))
                        else
                          UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]));
                        tmpline := '   ' + PatSl.Strings[i];
                        firstdetail := False;
                      end
                      else
                        tmpline := tmpstr;
                    end;
                  end;
                  Copypakkenr := 'xxx';
                  tmpline := tmpline + ')';
                  if firstdetail then
                    if Koel then
                      UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                        FormCurr2Str('  ###,##0.00', CopyAndel) + ' Køl')
                    else
                      UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                        FormCurr2Str('  ###,##0.00', CopyAndel))
                  else
                    UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]));
                  tmpline := '';
                end;
                CopyAndel := Andel;
                PakAnt := PakAnt + 1;
                PatSl.Clear;
                Koel := False;
              end;
            end;
            if Copypakkenr = '' then
            begin
              CopyAndel := Andel;
              PakAnt := 1;
            end;
            Copypakkenr := SPakkeNr;
            tmpstr := fqLevList.fieldbyname('Lbnr').AsString;
            if not Koel then
              Koel := KoelProductOnEkspedition(fqLevList.fieldbyname('Lbnr').AsInteger);
            hkcnt := CountHandkoebLines(fqLevList.fieldbyname('Lbnr').AsInteger);
            if fqLevList.fieldbyname('EkspType').AsInteger = et_Dosispakning then
              tmpstr := tmpstr + ' D'
            else if fqLevList.fieldbyname('EkspType').AsInteger = et_Haandkoeb then
              tmpstr := tmpstr + ' H'
            else if fqLevList.fieldbyname('BrugerKontrol').AsInteger = 0 then
            begin
              if (fqLevList.FieldByName('OrdreType').AsInteger <> 2)
                and ((AlleVnr) and (hkcnt = 0))
                and (not UdligningEkspedition(fqLevList.fieldbyname('Lbnr').AsInteger))
                and (not NulPakkelistEkspedition(fqLevList.fieldbyname('Lbnr').AsInteger))  then
                  tmpstr := tmpstr + '*';
            end;
            if fqLevList.fieldbyname('Fakturanr').AsInteger <> 0 then
              tmpstr := tmpstr + '/' + fqLevList.fieldbyname
                ('Fakturanr').AsString;
            PatSl.add(tmpstr);
            fqLevList.Next;
          end;
        except
          on e: Exception do
            c2logadd(e.Message);
        end;
        if PatSl.Count <> 0 then
        begin
          tmpline := '';
          firstdetail := True;
          for i := 0 to PatSl.Count - 1 do
          begin
            if tmpline = '' then
              tmpline := Copypakkenr + '(' + PatSl.Strings[i]
            else
            begin
              tmpstr := tmpline + ',' + PatSl.Strings[i];
              if Length(tmpstr) > 60 then
              begin
                tmpline := tmpline + ',';
                if firstdetail then
                  if Koel then
                    UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                      FormCurr2Str('  ###,##0.00', CopyAndel) + ' Køl')
                  else
                    UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                      FormCurr2Str('  ###,##0.00', CopyAndel))
                else
                  UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]));
                tmpline := '   ' + PatSl.Strings[i];
                firstdetail := False;
              end
              else
                tmpline := tmpstr;
            end;
          end;
          PatSl.Clear;
          Copypakkenr := 'xxx';
          tmpline := tmpline + ')';
          if firstdetail then
            if Koel then
              UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                FormCurr2Str('  ###,##0.00', CopyAndel) + ' Køl')
            else
              UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]) +
                FormCurr2Str('  ###,##0.00', CopyAndel))
          else
            UdLst.add(format('%-60.60s', [copy(tmpline, 1, 60)]));
          tmpline := '';
          Koel := False;
        end;
        if PatCount > 1 then
        begin
          UdLst.add(format('%-60.60s', ['']) + '------------');
          UdLst.add(format('%-60.60s', ['']) + FormCurr2Str('  ###,##0.00',
            PatTotal));
          UdLst.add(format('%-60.60s', ['']) + '------------');
        end;
        UdLst.add('');

        // Leveringsliste
        STotLin := 'Opkræves i alt for ' + inttostr(PakAnt) + ' pakker';
        STotLin := STotLin + Spaces(60 - Length(STotLin)) +
          FormCurr2Str('#,###,##0.00', Total);
        UdLst.add(FixStr('-', 72));
        UdLst.add(STotLin);
        UdLst.add(FixStr('=', 72));
        UdLst.Insert(0, '');
        UdLst.Insert(0,
          'Kundenavn & adresse                                                Beløb Køl');
        // UdLst.Insert(0, '         1         2         3         4         5         6         7;
        // UdLst.Insert(0, '123456789012345678901234567890123 xnnnnnnnxnnnnnnnxnnnnnnn nnn,nnn.nn nn;
        UdLst.Insert(0, '');
        UdLst.Insert(0, '             ' + ffDebKarPostNr.AsString + ' ' +
          ffDebKarBy.AsString);
        if Trim(ffDebKarAdr2.AsString) <> '' then
          UdLst.Insert(0, '             ' + ffDebKarAdr2.AsString);
        if Trim(ffDebKarAdr1.AsString) <> '' then
          UdLst.Insert(0, '             ' + ffDebKarAdr1.AsString);
        UdLst.Insert(0, '');
        UdLst.Insert(0, '[BOLD-ON]Leveres til: ' + Konto + ' ' +
          ffDebKarNavn.AsString + '[BOLD-OFF]');
        UdLst.Insert(0, '');
        if LevListeNr <> 0 then
          UdLst.Insert(0, 'Listenr. ' + inttostr(LevListeNr))
        else
          UdLst.Insert(0, '');
        UdLst.Insert(0, '');
        UdLst.Insert(0, ffFirmaNavn.AsString);
        UdLst.Insert(0, 'L E V E R I N G S L I S T E');
        UdLst.SaveToFile('C:\C2\Temp\LevListe2.Txt');
        PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\LevListe2.Txt');
      finally
        fqLevList.Close;
        UdLst.Free;
        Screen.Cursor := crDefault;
      end;
    finally
      KontoSl.Free;
      PatSl.Free;
    end;
    c2logadd('Leveringsliste2 slut');
  end;
end;

procedure TStamForm.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if (Msg.Message = WM_KEYDOWN) or (Msg.Message = WM_LBUTTONDOWN) then
    LastInput := Now;

  Handled := False;
end;

procedure TStamForm.AppDeactivate(Sender: TObject);
begin
end;

function TStamForm.AskAboutOpenRCP(Pakkenr: Integer): Boolean;
begin
  Result := True;
  with MainDm do
  begin
    try
      fqOpenEDI.Close;
      fqOpenEDI.SQL.Text := sl_SQL_OpenEdi.Text;
      fqOpenEDI.ParamByName('CPRNr').AsString :=
        Trim(copy(ffPatKarKundeNr.AsString, 1, 10));
      fqOpenEDI.Open;

      if fqOpenEDI.RecordCount = 0 then
        exit;
      fqOpenEDI.Last;
      QuestionAskedAboutOpenRCP := True;
      Result := ChkBoxYesNo('Bemærk, der er ikke takseret ordination fra: ' +
        fqOpenEDI.fieldbyname('dato').AsString + #10#13 + 'Skal pakkeseddel ' +
        inttostr(Pakkenr) + ' udskrives nu?', False);

    finally
      fqOpenEDI.Close;
    end;
  end;
end;

procedure TStamForm.acDebEkspKontrolExecute(Sender: TObject);
begin
  TfrmDebKont.showdebkont;
end;

procedure TStamForm.acRetYdernrExecute(Sender: TObject);
begin
  // show yder screen
  with MainDm do
  begin
    if StamPages.ActivePage <> UafslutPage then
      exit;
    if not ShowYdLst('Navn', dsYdLst, ffYdLst) then
      exit;

    if ffYdLstYderNr.AsString <> ffEksOvrYderNr.AsString then
    begin
      if ChkBoxYesNo('Ret ydernr fra ' + ffEksOvrYderNr.AsString + ' til ' +
        ffYdLstYderNr.AsString + '?', False) then
      begin

        ffEksOvr.Edit;
        try
          ffEksOvrYderNr.AsString := ffYdLstYderNr.AsString;
          ffEksOvrYderCprNr.AsString := ffYdLstCprNr.AsString;
        finally
          ffEksOvr.Post;
        end;
      end;
      exit;

    end;

    if ffYdLstCprNr.AsString <> ffEksOvrYderCprNr.AsString then
    begin
      if ChkBoxYesNo('Ret ydercprnr fra ' + ffEksOvrYderCprNr.AsString + ' til '
        + ffYdLstCprNr.AsString + '?', False) then
      begin

        ffEksOvr.Edit;
        try
          ffEksOvrYderNr.AsString := ffYdLstYderNr.AsString;
          ffEksOvrYderCprNr.AsString := ffYdLstCprNr.AsString;
        finally
          ffEksOvr.Post;
        end;

      end;
      exit;
    end;

  end;
end;

procedure TStamForm.acRSEkspFejlExecute(Sender: TObject);
begin
  TfrmRSEkspFejl.ShowRSEkspFejl;
end;


procedure TStamForm.CheckFor0Ekspedition(strLevnr: string);
var
  Res: Word;
  ServerDateTime: TDateTime;

  procedure Create0ekspedition(var Res: Word);
  var
    Lbnr0: Integer;
    Pakkenr0: Integer;
    save_index: string;
    ZeroReturDage : integer;

  begin
    with MainDm do
    begin
      Res := 2000;
      nxRemoteServerInfoPlugin1.GetServerDateTime(ServerDateTime);
      ffRcpOpl.First;
      Lbnr0 := ffRcpOplLbNr.Value;
      save_index := ffEksKar.IndexName;
      ffEksKar.IndexName := 'NrOrden';
      try
        ffEksKar.Last;
        if ffEksKarLbNr.AsInteger >= Lbnr0 then
          Lbnr0 := ffEksKarLbNr.AsInteger + 1;
      finally
        ffEksKar.IndexName := save_index;
      end;
      ffRcpOpl.Edit;
      ffRcpOplLbNr.Value := Lbnr0 + 1;
      Pakkenr0 := ffRcpOplPakkeNr.AsInteger;
      ffRcpOplPakkeNr.Value := ffRcpOplPakkeNr.Value + 1;
      AfslPakkeNr := Pakkenr0;
      Res := 2102;
      ffRcpOpl.Post;

      // set the returdage from the newly created ekspedition
      ZeroReturDage := ffEksOvrReturdage.AsInteger;


      // Ekspedition gemmes
      Res := 2110;
      ffEksKar.Insert;
      ffEksKarLbNr.Value := Lbnr0;
      ffEksKarTurNr.Value := 0;
      ffEksKarPakkeNr.Value := Pakkenr0;
      ffEksKarFakturaNr.Value := 0;
      ffEksKarUdlignNr.Value := 0;
      ffEksKarKundeNr.Value := ffEksOvrKundenr.Value;

      /// need to carry this on !!!!!!!!
      // ffEksKarLMSUdsteder.AsString      := mtEksYderNr.AsString;
      ffEksKarLMSModtager.AsString := ffEksOvrLMSModtager.AsString;
      ffEksKarFiktivtCprNr.AsBoolean := ffEksOvrFiktivtCprNr.Value;
      ffEksKarCprCheck.AsBoolean := ffEksOvrCprCheck.AsBoolean;
      ffEksKarEjSubstitution.AsBoolean := ffEksOvrEjSubstitution.AsBoolean;
      ffEksKarBarn.AsBoolean := ffEksOvrBarn.AsBoolean;
      ffEksKarKundeKlub.AsBoolean := False;
      ffEksKarKlubNr.AsInteger := 0;
      ffEksKarAmt.Value := ffEksOvrAmt.Value;
      ffEksKarKommune.Value := ffEksOvrKommune.Value;
      ffEksKarKundeType.Value := ffEksOvrKundeType.Value;
      ffEksKarLandeKode.Value := ffEksOvrLandeKode.Value;
      ffEksKarCtrType.Value := ffEksOvrCtrType.Value;
      ffEksKarFoedDato.AsString := ffEksOvrFoedDato.AsString;
      ffEksKarNarkoNr.AsString := ffEksOvrNarkoNr.AsString;
      ffEksKarOrdreType.Value := ffEksOvrOrdreType.Value;
      ffEksKarOrdreStatus.Value := 1;
      ffEksKarReceptStatus.Value := ffEksOvrReceptStatus.Value;
      if ffEksKarReceptStatus.Value = 999 then
        ffEksKarReceptStatus.Value := 3;
      ffEksKarEkspType.Value := ffEksOvrEkspType.Value;
      ffEksKarEkspForm.Value := ffEksOvrEkspForm.Value;
      ffEksKarDosStyring.AsBoolean := False;
      ffEksKarIndikStyring.AsBoolean := False;
      ffEksKarAntLin.Value := 0;
      ffEksKarAntVarer.Value := 0;
      ffEksKarDKMedlem.Value := 0;
      if ffEksKarKundeType.Value = 1 then
        ffEksKarDKMedlem.Value := ffEksOvrDKMedlem.Value;
      ffEksKarDKAnt.Value := 0;
      // ffEksKarReceptDato.AsDateTime     := Now;
      ffEksKarTakserDato.AsDateTime := ServerDateTime;
      ffEksKarOrdreDato.AsDateTime := ServerDateTime; // CTR dato og tid
      // ffEksKarKontrolDato.AsDateTime    := ;
      ffEksKarForfaldsdato.AsDateTime := ffEksOvrTakserDato.AsDateTime;
      // Hvis udligntype = 1 så er det forrige periode
      // da benyttes mtEksCtrUdlignDato til ordredato
      ffEksKarBrugerTakser.Value := BrugerNr;
      ffEksKarBrugerKontrol.Value := 0;
      ffEksKarBrugerAfslut.Value := 0;
      ffEksKarTitel.AsString := '';
      ffEksKarNavn.AsString := ffEksOvrNavn.AsString;
      ffEksKarAdr1.AsString := ffEksOvrAdr1.AsString;
      ffEksKarAdr2.AsString := ffEksOvrAdr2.AsString;
      ffEksKarPostNr.AsString := ffEksOvrPostNr.AsString;
      ffEksKarLand.AsString := '';
      ffEksKarKontakt.AsString := '';
      ffEksKarTlfNr.AsString := '';
      ffEksKarTlfNr2.AsString := '';
      ffEksKarYderNr.AsString := ffEksOvrYderNr.AsString;
      ffEksKarYderCprNr.AsString := ffEksOvrYderCprNr.AsString;
      ffEksKarYderNavn.AsString := ffEksOvrYderNavn.AsString;
      ffEksKarKontoNr.AsString := Trim(strLevnr);
      if ffDebKar.FindKey([strLevnr]) then
      begin
        ffEksKarKontoNavn.AsString := ffDebKarNavn.AsString;
        ffEksKarLeveringsForm.Value := ffDebKarLevForm.Value;
        ffEksKarUdbrGebyr.AsCurrency := 0;
      end
      else
      begin
        ffEksKarKontoNavn.AsString := '';
        ffEksKarLeveringsForm.Value := 0;
        ffEksKarUdbrGebyr.AsCurrency := 0;
      end;
      ffEksKarLevNavn.AsString := '';
      ffEksKarSprog.Value := 0;
      ffEksKarAfdeling.Value := ffEksOvrAfdeling.Value;
      ffEksKarLager.Value := ffEksOvrLager.Value;
      ffEksKarNettoPriser.AsBoolean := ffEksOvrNettoPriser.AsBoolean;
      ffEksKarInclMoms.AsBoolean := True;
      ffEksKarMomsPct.AsCurrency := ffRcpOplMomsPct.AsCurrency;
      ffEksKarRabatPct.AsCurrency := 0;
      ffEksKarCtrIndberettet.Value := 0;
      ffEksKarDKIndberettet.Value := 0;
      // Gebyrer
      ffEksKarTlfGebyr.AsCurrency := 0;
      ffEksKarEdbGebyr.AsCurrency := 0;

      // Nulstil totaler

      ffEksKarCtrSaldo.AsCurrency := ffEksOvrCtrSaldo.AsCurrency;
      // ffEksKarCtrUdlign.AsCurrency       := mtEksCtrUdlign.AsCurrency;
      ffEksKarDKTilsk.AsCurrency := 0;
      ffEksKarDKEjTilsk.AsCurrency := 0;
      ffEksKarRabatLin.AsCurrency := 0;
      ffEksKarRabat.AsCurrency := 0;
      ffEksKarExMoms.AsCurrency := 0;
      ffEksKarMoms.AsCurrency := 0;
      ffEksKarTilskKom.AsCurrency := 0;
      ffEksKarTilskAmt.AsCurrency := 0;
      ffEksKarAndel.AsCurrency := 0;
      ffEksKarBrutto.AsCurrency := 0;
      ffEksKarNetto.AsCurrency := 0;


      ffEksKarReturdage.AsInteger := ZeroReturDage;


      ffEksKar.Post;
    end;
  end;

  function UseOldPakkeNr0Ekspedition: Boolean;
  begin
    with MainDm do
    begin
      Result := False;
      nxOpenPakke.SQL.Text := sl_Sql_GetOldOpenPakkenr.Text;
      nxOpenPakke.Params.ParamByName('Kundenr').AsString :=
        ffEksOvrKundenr.AsString;
      nxOpenPakke.Params.ParamByName('Kontonr').AsString :=
        ffEksOvrKontoNr.AsString;
      try
        nxOpenPakke.Open;

      except
        on e: Exception do
        begin
          c2logadd('Error in nxopenpakke ' + e.Message);
          Result := False;
          exit;
        end;

      end;

      try

        if nxOpenPakke.RecordCount <> 0 then
          Result := True;

      finally
        nxOpenPakke.Close;
      end;
    end;

  end;

begin
  with MainDm do
  begin
    if not ffDebKar.FindKey([strLevnr]) then
      exit;
    if not(ffDebKarLevForm.AsInteger in [5, 6]) then
      exit;
    If UseOldPakkeNr0Ekspedition then
      exit;
    if ChkBoxYesNo('Ønskes 0-pakke til denne ekspedition på leveringsnummer ' +
      strLevnr, True) then
      Create0ekspedition(Res);

  end;
end;

procedure TStamForm.bitRetAutNrClick(Sender: TObject);
var
  ilen: Integer;
begin
  with MainDm do
  begin

    if edtRetAutNr.Text = '' then
    begin
      if not ChkBoxYesNo
        ('Skal autorisationsnummeret fjernes for denne ekspedition?', False)
      then
        exit;
      ffEksOvr.Edit;
      ffEksOvrYderCprNr.AsString := '';
      ffEksOvr.Post;
    end;
    if not ChkBoxYesNo('Ret Aut.Nr fra ' + ffEksOvrYderCprNr.AsString + ' til '
      + edtRetAutNr.Text + '?', False) then
      exit;
    ilen := Length(edtRetAutNr.Text);
    if (ilen <> 5) and (ilen <> 10) then
    begin
      ChkBoxOK('Aut.Nr er ikke korrekt');
      exit;
    end;

    if ilen = 10 then
    begin
      if not DisableCPRModulusCheck then
      begin
        if not CheckCprNr(1, edtRetAutNr.Text) then
        begin
          ChkBoxOK('Fejl i Aut.Nr');
          exit;
        end;
      end;
    end;

    ffEksOvr.Edit;
    ffEksOvrYderCprNr.AsString := caps(edtRetAutNr.Text);
    ffEksOvr.Post;

  end;
end;

procedure TStamForm.acGenBothEtiketExecute(Sender: TObject);
var
  Item: Word;
  LbNr: LongWord;
begin
  // Søg et recept løbenummer, pakkenummer eller fakturanr
  if not TSoegRcpForm.SoegRcpt(Item, LbNr) then
    exit;
  if (Item <> 0) then
    exit;
  if (LbNr = 0) then
    exit;
  AfslLbNr := LbNr;
  UbiEtiketter;
  UbiAfstempling(False, False);
  if Kronikerekstrabetaling then
    UbiKronikerLabel;
  fmubi.PrintTotalEtiket;

end;

procedure TStamForm.acHenstandsOrdningExecute(Sender: TObject);
begin
  with MainDm do
  begin
    if ffPatKarKundeType.AsInteger <> 1 then
    begin
      ChkBoxOK('Kundetype skal være Enkeltperson.');
      exit;
    end;

    if trim(ffPatKarKundeNr.AsString) = '' then
    begin
      ChkBoxOK('Der skal vælges en kunde først.');
      exit;
    end;
    if Length(trim(ffPatKarKundeNr.AsString)) <> 10 then
    begin
      ChkBoxOK('Kundenummeret skal være på 10 tegn');
      exit;
    end;
    TFmHenstandsOrdning.ShowForm(ffPatKarKundeNr.AsString, ffPatKarLmsModtager.AsString, Self.AfdelingLMSNr);
  end;
end;

procedure TStamForm.lvFMKPrescriptionsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  LStrDate : string;

begin
  with MainDm do
  begin
      lvFMKPrescriptions.Canvas.Brush.Color := clWindow;
      if Item.Checked then
        lvFMKPrescriptions.Canvas.Brush.Color := tcolor($99FFFF);

      if Item.SubItems[lvFMKPrivat] <> '' then
      begin
        lvFMKPrescriptions.Canvas.Brush.Color := clLtGray;
        exit;
      end;

      if Item.SubItems[lvFMKStatus] = 'Ugyldig' then
      begin
        lvFMKPrescriptions.Canvas.Brush.Color := clDkGray;
        exit;
      end;


      LStrDate := FormatDateTime('yyyy-mm-dd',Now);
      if LStrDate < Item.SubItems[lvFMKValidFra] then
      begin
        lvFMKPrescriptions.Canvas.Brush.Color := clWebRed;
        exit;
      end;

      LStrDate := FormatDateTime('yyyy-mm-dd',Now);
      if LStrDate > Item.SubItems[lvFMKValidTil] then
      begin
        lvFMKPrescriptions.Canvas.Brush.Color := clWebRed;
        exit;
      end;

      if (Item.SubItems[lvFMKDosis] <> '') then
      begin
        lvFMKPrescriptions.Canvas.Brush.Color := clAqua;
        exit;
      end;

      if Item.SubItems[lvFMKRSLbnr] = '1' then
      begin
        lvFMKPrescriptions.Canvas.Brush.Color := tcolor($82DDEE);
      end;


  end;
end;

procedure TStamForm.lvFMKPrescriptionsCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  sub4, sub5: Integer;
begin

  if SubItem <> lvFMKUdlev then
    exit;
  DefaultDraw := True;
  sub4 := StrToInt(Item.SubItems[lvFMKMax]);
  sub5 := StrToInt(Item.SubItems[lvFMKUdlev]);
  if (sub4 = 0) and (sub5 = 0) then
    exit;
  if sub5 >= sub4 then
    lvFMKPrescriptions.Canvas.Brush.Color := clYellow;

end;

procedure TStamForm.acArkiverKundeExecute(Sender: TObject);
begin
  // this is where we show the form
  frmArkivKunde.ShowArkivKunde;
end;

procedure TStamForm.WMSkiftBruger(var Msg: TMessage);
begin
  C2LogAdd('Received a user switch message');
  acLogOffExecute(Self);
end;

procedure TStamForm.CMDialogKey(var AMessage: TCMDialogKey);
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


procedure TStamForm.HandleLevListe;
var
  ListeNr : integer;
  nxq : TnxQuery;
  LevLbnrList : TList<integer>;

  function CheckKontrol : boolean;
  var
    lbnr : integer;
    sl : TStringList;

  begin
    with MainDm do
    begin
      sl := TStringList.Create;
      try
        for lbnr in LevLbnrList do
        begin
          nxq.Close;
          nxq.SQL.Clear;
          nxq.SQL.Add('SELECT s.lbnr,count(lag.dmvs),e.brugerkontrol as dmvs FROM EkspLinierSalg as s');
          nxq.SQL.Add('inner join lagerkartotek as lag on lag.lager=s.lager and lag.varenr=s.subvarenr');
          nxq.SQL.Add('left join ekspeditioner as e on e.lbnr=s.lbnr');
          nxq.SQL.Add('where lag.dmvs<> 0');
          nxq.SQL.Add('and s.lbnr=:ilbnr');
          nxq.SQL.Add('and e.brugerkontrol=0');
          nxq.SQL.Add('and e.ordretype=1');
          nxq.SQL.add('and e.eksptype<>' + IntToStr(et_Dosispakning));
          nxq.SQL.Add('group by s.lbnr,e.brugerkontrol');
          nxq.ParamByName('ilbnr').AsInteger := lbnr;
          nxq.Open;
          if not nxq.Eof then
            sl.Add(lbnr.ToString);
        end;

        if sl.Count <> 0 then
          ChkBoxOK('Følgende løbenumre mangler stregkodekontrol: ' + #13#10 + sl.Text)

      finally

        Result := sl.Count = 0;
        sl.Free
      end;


    end;
  end;

  function CheckBogfoer : boolean;
  var
    lbnr : integer;
    counter : integer;
    sl : TStrings;
  begin
    with MainDm do
    begin
      sl:= TStringList.Create;
      try
        Result := True;
        counter := 0;
        for lbnr in LevLbnrList do
        begin
          nxq.Close;
          nxq.SQL.Clear;
          nxq.SQL.Add('SELECT e.Afsluttetdato,b.bonnr FROM Ekspeditioner as E');
          nxq.SQL.Add('left join Ekspeditionerbon as b on b.lbnr=e.lbnr');
          nxq.SQL.Add('where e.lbnr=:ilbnr');
          nxq.ParamByName('ilbnr').AsInteger := lbnr;
          nxq.Open;
          if nxq.Eof then
            continue;

          if nxq.FieldByName('Afsluttetdato').IsNull then
          begin
            sl.Add(lbnr.ToString);
          end;

          if not nxq.FieldByName('Bonnr').IsNull then
          begin
            // count how many lines have a bonnr
            inc(counter);
  //          ChkBoxOK('Udlevering af denne lev.liste er allerede registreret.');
  //          Result := False;
  //          exit;
          end;

        end;

        if sl.Count <> 0 then
        begin
          ChkBoxOK('Leveringsliste er ikke bogført ' + #13#10  + sl.Text);
          Result := False;
          exit;
        end;

  //      if the counter is all of the lbnr in the list then message box
        if counter = LevLbnrList.Count then
            ChkBoxOK('Udlevering af denne lev.liste er allerede registreret.');

        // return true if something on the list is valid
        Result := counter <> LevLbnrList.Count;

      finally
        sl.Free;
      end;
    end;
  end;

begin
  with MainDm do
  begin
    // Løbenr muligvis stregkode
    ListeNr := ffEksOvrListeNr.AsInteger;


    // Søg løbenr

    LevLbnrList := TList<integer>.Create;
    nxq:= TnxQuery.Create(Nil);
    try
    // here we use the levliste sql to return the lbnr's in the leversingslist
      nxq.Database := nxdb;

      try
        if ListeNr <> 0 then
        begin

          nxq.Close;
          nxq.SQL.Text := 'select LbNr from ekspleveringsliste where listenr=:listenr';
          nxq.ParamByName('listenr').AsInteger := ListeNr;
          nxq.Open;
          if nxq.RecordCount = 0 then
          begin
            ChkBoxOK('Leveringslistenr findes IKKE i kartoteket!');
            Exit;
          end;
          nxq.first;
          while not nxq.Eof do
          begin
            LevLbnrList.Add(nxq.FieldByName('Lbnr').AsInteger);
            nxq.Next;
          end;
        end
        else
        begin
          LevLbnrList.Add(ffEksOvrLbNr.AsInteger);
        end;

        // check each lbnr for existence of DMVS product. if there is at least 1 then
        // must check kontrol has been done

        if not CheckKontrol then
          exit;

        // check that all have been afsluttet
        if not CheckBogfoer then
          exit;


        if OpdaterZeroBonLevlist(LevLbnrList) = 0 then
        begin
          ChkBoxOK('Løbenr/Listenr er nu registreret udleveret i DMVS');
        end;
      except
        on e : exception do
        begin
          ChkBoxOK('Exception under søgning recept "' + E.Message);
          Exit;
        end;

      end;
    finally
      nxq.Free;
      LevLbnrList.Free;
    end;

  end;
end;


function TStamForm.SendChilkatHttp(const AHTTPSUrl, AXMLString: WideString; const AApotekId: string) : Boolean;
var
  LResponse: string;
  LErrorMessage: string;
  LResult: boolean;
begin
  Result := False;
  LResponse := '';
  C2LogAdd(AXMLString);
  C2LogAddF('length of AXMLString is %d',[Length(AXMLString)]);
  LResult := HttpPostStuff(AHTTPSUrl, AXMLString, AApotekId, LResponse, LErrorMessage);

  if LResult then
    C2LogAdd(LResponse)
  else
    C2LogAdd(LErrorMessage);

  Result := LResult;
end;

function TStamForm.HttpPostStuff(const AEndpoint: string; const ARequestXml: WideString; const AApotekId: string;
  out AResponseXml, AErrorMessage: string): boolean;
var
  LHttpClient: HCkHttp;
  LHttpRequest: HCkHttpRequest;

  LEndpointHost: string;
  LEndpointPath: string;
  LEndpointPort: integer;
  LHttpResponse: HCkHttpResponse;
  LReasonCode: integer;
  LSsl: boolean;
  LXml: HCkXml;
begin
  C2LogAdd('Top of httppoststuff');
  // Create
  LHttpClient := CkHttp_Create();
  LHttpRequest := CkHttpRequest_Create();
  LHttpResponse := nil;
  AErrorMessage := '';
  AResponseXml := '';
  LXml := CkXml_Create;
  CkXml_LoadXml(LXml, pwidechar(ARequestXml));
  try
    // Init
    // If you reuse a global HttpRequest object, you might need to remove params from a previous request
    // CkHttpRequest_RemoveAllParams(LHttpRequest);
    CkHttpRequest_putHttpVerb(LHttpRequest, 'POST'); // !!! Important to set
    // CkHttpRequest_putContentType(LHttpRequest, 'application/xml; charset=utf-8');
    CkHttpRequest_putContentType(LHttpRequest, 'application/x-www-form-urlencoded; charset=utf-8');

    // CkHttpRequest_AddHeader(LHttpRequest, 'Pragma', 'no-cache');
    CkHttp_putUserAgent(LHttpClient, 'C2 (Chilkat)');
    CkHttpRequest_AddHeader(LHttpRequest, 'User-Agent', CkHttp__userAgent(LHttpClient));
    // CkHttpRequest_AddHeader(LHttpRequest, 'Accept-Encoding', 'gzip');
    CkHttp_putAccept(LHttpClient, 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
    CkHttpRequest_AddHeader(LHttpRequest, 'Accept', CkHttp__accept(LHttpClient));
    CkHttpRequest_putCharset(LHttpRequest, 'UTF-8');
    CkHttp_putUncommonOptions(LHttpClient, 'EnableTls13');
    // This is only necessary with Chilkat.dll from 2020 and earlier
    CkHttp_putBasicAuth(LHttpClient, True);
    // Optional if using Fiddler
    // CkHttp_putProxyDomain(LHttpClient, '127.0.0.1');
    // CkHttp_putProxyPort(LHttpClient, 8888);

    CkHttpRequest_AddParam(LHttpRequest, 'beskedtype', 'OpdaterEordreFraApotekRequest');
    CkHttpRequest_AddParam(LHttpRequest, 'apotekNr', pwidechar(AApotekId));
    CkHttpRequest_AddParam(LHttpRequest, 'password', 'phUs12DkioN5Bm');
    CkHttpRequest_AddParam(LHttpRequest, 'requestdata', pwidechar(ARequestXml));

    // // Set the body
    // CkHttpRequest_LoadBodyFromString(LHttpRequest,ckxml__getxml(LXml), 'utf-8');

    // Split the endpoint into components. Chilkat is very "nerdy" and needs everything as separate parameters
    SplitEndpointAddressIntoComponents(AEndpoint, LEndpointHost, LEndpointPath, LEndpointPort, LSsl);
    CkHttpRequest_putPath(LHttpRequest, pwidechar(LEndpointPath));
    // if LSsl then
    // begin
    //
    // CkHttp_putBasicAuth(LHttpClient,True);
    // CkHttp_putLogin(LHttpClient,'CitoWSUser');
    // CkHttp_putPassword(LHttpClient,'DoTqCffuskkaU6Qhi');
    // end;
    //
    // Send the request
    // Only necessary if you have a global HttpClient object that could be idle for a longer period
    // CkHttp_CloseAllConnections(LHttpClient);

    LHttpResponse := CkHttp_SynchronousRequest(LHttpClient, pwidechar(LEndpointHost), LEndpointPort, LSsl,
      LHttpRequest);

    // Check the result
    if CkHttp_getLastMethodSuccess(LHttpClient) and Assigned(LHttpResponse) then
    begin
      AResponseXml := CkHttpResponse__bodyStr(LHttpResponse);
      // If the response isn't 200 OK, then raise the Indy protocol exception, so the exception handler will work
      if CkHttpResponse_getStatusCode(LHttpResponse) <> 200 then
        raise Exception.Create(CkHttpResponse__statusLine(LHttpResponse) + ' ' + AResponseXml);
    end
    else
    begin
      LReasonCode := CkHttp_getConnectFailReason(LHttpClient);
      if LReasonCode = 0 then // 0=Success
        raise Exception.Create(CkHttp__lastErrorText(LHttpClient))
      else
        raise Exception.Create(CkHttpConnectFailReasonDisplayText(LReasonCode));
    end;

    Result := True;
  except
    on e: Exception do
    begin
      Result := False;
      AErrorMessage := 'Exception: "' + e.Message + '"';
    end;
  end;

  // Free
  if Assigned(LHttpResponse) then
    CkHttpResponse_Dispose(LHttpResponse);
  CkHttpRequest_Dispose(LHttpRequest);
  CkHttp_Dispose(LHttpClient);
  CkXml_Dispose(LXml);
end;



end.
