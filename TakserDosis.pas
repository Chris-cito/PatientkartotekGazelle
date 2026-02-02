unit TakserDosis;

{ Developed by: Cito IT A/S

  Description: Takser dosis ekspedition

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  13-12-2021/cjs  Changes for using the new CtrTilskudSatser table

  29-10-2020/cjs  Modified to use new property for Recepturplads

  10-09-2019/cjs   use the kundenavn specified at the start of taksering
}
  
interface

uses
  Classes,  Graphics, Controls,
  Forms,    Menus,    StdCtrls,
  DBCtrls,  DBGrids,  ComCtrls,
     ExtCtrls, Mask,
  Messages, Windows,  SysUtils,
  Db,       Buttons,  DateUtils,
  dbclient, ActnList,generics.collections, System.Actions, CtrTilskudsSatser,Math, Vcl.Grids;
{$I EdiRcpInc}

type
  TTakserDosisForm = class(TForm)
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
    EMax: TDBEdit;
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
    btnVis: TSpeedButton;
    acLager0: TAction;
    acLager1: TAction;
    acLager2: TAction;
    acLager3: TAction;
    acLager4: TAction;
    acLager5: TAction;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure buLukClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EkspFormExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbIndikationEnter(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure buGemClick(Sender: TObject);
    procedure FakTypeExit(Sender: TObject);
    procedure DropDown(Sender: TObject);
    function  CheckOrdination : Boolean;
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
  private
    { Private declarations }
    YderList : boolean;
    UdlignOrdination : boolean;
    SaveDosisKortNr : integer;
    AskYderNrQuestion: boolean;
    AskYderCPrNrQuestion : boolean;
    LagerListeLagerChk : boolean;
    OldDebitor : string;
    save_caption : string;
    SkipReservation : boolean;
    ReservationOrigVarenr : string;
    procedure BuildDosisEtiketLabel;
    procedure Process_eYdenr;
    procedure Process_cbIndikation;
    procedure process_cbDosTekst;
    procedure process_Eantal;
    procedure process_EDos2;
    procedure FillYderCpr;
    procedure ReadyDebitor;
    procedure ReadyLevering;
    procedure CheckDebitor;
    procedure CheckLevering;
    procedure CheckCtrUpdate;
    function NyLinie : boolean;
  public
    { Public declarations }
    FirstTime,
    CloseCF6,
    CloseSF6,
    CloseCSF6,
    CloseF6     : Boolean;
  end;

var
  TakserDosisForm: TTakserDosisForm;
  ReiterLbNr : Longword;
  ReceptId : integer;
  FirstWarning : boolean;
  LabelFirstWarn : boolean;
procedure EkspDosis (LbNr : LongWord; EdiPtr : Pointer);
procedure FillCTRBevDataset;

implementation

uses

  UdlignCtr,


  C2MainLog,
  HentTekst,
  HentHeltal,
  BevillingsOversigt,


  MidClientApi,
//  VareOversigt,
//  TakstOversigt,
  SubstOversigt,
  RcpProcs,
  C2Procs,
//  DebitorLst,
  YderLst,
  TakserAfslut,
  ChkBoxes,
  DM,
  Main,
  frmLagerList, RCPPrinter, uYesNo,
  uC2Vareidentifikator.Types,BeregnUdlignOrdinationu,BeregnDosisOrdinationu;

{$R *.DFM}


var
  EdiRcp          : PEdiRcp;
  FrmTekst,
  FrmEntal,
  FrmFlertal      : String;
//  VareRec         : TVareRec;
//  DebitorRec      : TDebitorRec;
  CtrRec          : MidClientApi.TCtrStatus;
  StartCTRTime : TDateTime;
  OriginalAntal : integer;
  itemsubst : boolean;
  AllHKlines : boolean;
  ProdDyrPrices : boolean;
  ForceClose : boolean;
(*
function HentDebitor (var Rec : TDebitorRec) : boolean;
begin with MidClient do begin
  MidClient.HentDeb (Rec);
  Result := Rec.Status = 0;
end; end;
*)

function calcage(yearstr : string;foeddato : string) : string;
var
  datestr : string;
  iyy,imm,idd : integer;
  bdate : TDate;
  agenow : integer;
begin
  try
    datestr := foeddato;
    if datestr = '' then
      datestr := yearstr;
    idd := strtoint(copy(datestr,1,2));
    imm := StrToInt(copy(datestr,3,2));
    iyy := StrToInt(copy(datestr,5,2));
    if iyy < 90 then
      iyy := 2000 + iyy
    else
      iyy := 1900 + iyy;
    bdate := EncodeDate(iyy,imm,idd);
    Result := '';
    IF bdate >= Now then
      exit;
    agenow := YearsBetween(Now,bdate);
    if agenow > 18 then
      exit;

    if agenow <= 2 then
      result := IntToStr(MonthsBetween(Now,bdate)) + ' mdr'
    else
      result := IntToStr(YearsBetween(Now,bdate)) + ' år';

  except
    result := '';
  end;
end;

procedure TTakserDosisForm.FillYderCpr;
var
  savecpr : string;
begin
  with MainDm do
  begin

    try
      // cjs to do
      savecpr := eYderCPRNr.Text;
      ffYdLst.IndexName := 'YderNrOrden';
      eYderCPRNr.Items.Clear;
      ffYdLst.FilterOptions := [foCaseInsensitive];
      ffYdLst.Filter := 'YderNr=''' + mtEksYderNr.AsString + '''';
      ffYdLst.Filtered := True;
      c2logadd('yder recordcount is ' + IntToStr(ffYdLst.RecordCount));
      if ffYdLst.RecordCount <> 0 then
      begin
        ffYdLst.First;
        eYderCPRNr.Items.Add('');
        while not ffydlst.Eof do
        begin
          if CAPS(ffYdLstYderNr.AsString) <> CAPS(mtEksYderNr.AsString) then
            break;
          if Trim(ffYdLstCprNr.AsString) <> '' then
            eYderCPRNr.Items.Add(ffYdLstCprNr.AsString);
          ffYdLst.Next;
        end;
        if (eYderCPRNr.Items.Count = 2) and (ffPatKarYderCprNr.AsString = '') then
          mtEksYderCprNr.AsString := eYderCPRNr.Items[1];
  //      eYderCPRNr.DropDownCount := eYderCPRNr.Items.Count;
      end;
      if YderList then
        mtEksYderCprNr.AsString := savecpr;
      ffYdLst.Filtered := False;
    except
      ON E : Exception    do
      C2LogAdd('No entry in yderkartotek for fill cpr ' + e.Message);
    end;
    yderlist := False;
  end;
end;


procedure TTakserDosisForm.ReadyDebitor;
begin
  eDebitorNr.Color    := clYellow;
//  eDebitorNr.ReadOnly := False;
  eDebitorNr.TabStop  := True;
  lcLevForm .Color    := clYellow;
//  lcLevForm .ReadOnly := False;
  lcLevForm .TabStop  := True;
  ePakkeNr  .Color    := clYellow;
//  ePakkeNr  .ReadOnly := False;
  ePakkeNr  .TabStop  := True;
end;

procedure TTakserDosisForm.ReadyLevering;
begin
    eLevNr.Color    := clYellow;
  //  eLevNr.ReadOnly := False;
    eLevNr.TabStop  := True;
end;

procedure TTakserDosisForm.CheckDebitor;
var
  i : integer;
  save_index : string;
begin
  with MainDm do
  begin
    ReadyDebitor;
    if mtEksDebitorNr.AsString <> OldDebitor  then
      LagerListeLagerChk := False;
    OldDebitor := mtEksDebitorNr.AsString;
    if not ffDebKar.FindKey([mtEksDebitorNr.AsString]) then
    begin
      ChkBoxOk ('Debitorkonto findes ikke i kartotek !');
      eDebitorNr.SetFocus;
      exit;
    end;

    if ffDebKarKontoLukket.AsBoolean then
    begin
      if trim(ffDebKarLukketGrund.AsString) <> '' then
        ChkBoxOK('Debitorkonto er lukket : ' + ffDebKarLukketGrund.AsString)
      else
        ChkBoxOK('Debitorkonto er lukket.');
      mtEksDebitorNr.AsString := '';
      eDebitorNr.SetFocus;
      exit;
    end;
    if ffDebKarKreditMax.AsCurrency <> 0 then
      ChkBoxOK('Bemærk kreditmax: ' + format('%8.2f',[ffDebKarKreditMax.AsCurrency]) + #10#13#10#13 +
          'Aktuel saldo: ' + format('%8.2f',[ffDebKarSaldo.AsCurrency]));

    if (ffDebKarAfdeling.AsString ='' ) or ( ffDebKarLager.AsString = '') then
    begin
      ChkBoxOK('Afdeling eller lager mangler på debitoren. Ret dette i Debitorkartoteket.');
      mtEksDebitorNr.AsString := '';
      eDebitorNr.SetFocus;
      exit;
    end;
    save_index := ffAfdNvn.IndexName;
    ffAfdNvn.IndexName := 'NrOrden';
    try
      if not ffAfdNvn.FindKey([ffDebKarAfdeling.AsInteger]) then
      begin
        ChkBoxOK('Afdeling eller lager mangler på debitoren. Ret dette i Debitorkartoteket.');
        mtEksDebitorNr.AsString := '';
        eDebitorNr.SetFocus;
        exit;
      end;
    finally
      ffAfdNvn.IndexName := save_index;
    end;

    ProdDyrPrices := ffAfdNvnProduktionsDyr.AsBoolean;
    c2logadd('Prod Dyr Prices ' + Bool2Str(ProdDyrPrices));
    if not LagerListeLagerChk  then
    begin
      mtEksAfdeling.Value        := ffDebKarAfdeling     .AsInteger;
      mtEksLager.Value           := ffDebKarLager        .AsInteger;
      StamForm.StockLager := mtEksLager.Value;
      c2logadd('1: Stock lager changed to ' +  inttostr(StamForm.StockLager));
    end;
    mtEksDebitorNavn.AsString  := BytNavn(ffDebKarNavn.AsString);
    mtEksLeveringsForm.Value   := ffDebKarLevForm      .AsInteger;
    mtEksDebitorGrp.Value      := ffDebKarDebGruppe    .AsInteger;
    mtEksDebProcent.AsCurrency  := ffDebKarAvancePct.AsCurrency;
    if (ffDebKarLevForm.AsInteger in [5,6]) and (mtEksKundeType.AsInteger <> 15) then begin
//      if AllHKLines then
        mtEksUdbrGebyr.AsCurrency := ffRcpOplHKgebyr.AsCurrency;
    end;
    if ffDebKarUdbrGebyr.AsBoolean then
    begin
      if mtEksUdbrGebyr.AsCurrency = 0 then
        mtEksUdbrGebyr.AsCurrency := ffRcpOplPlejehjemsgebyr.AsCurrency;
      if ffDebKarLevForm.AsInteger = 2 then
        mtEksUdbrGebyr.AsCurrency:= ffRcpOplUdbrGebyr    .AsCurrency;
    end;
    if (LagerListeLagerChk) and (stamform.debitorpopup) then
      exit;
    if Stamform.debitorpopup then
      LagerListeLagerChk := True;
    if (mtEksLager.value <> StamForm.FLagerNr) or (StamForm.Spoerg_Lager_Debitor) then
    begin
      if not StamForm.debitorpopup then
        exit;
      if StamForm.DebitorPopupAutoret then
      begin
        for i := 1 to 10 do begin
          if StamForm.debitorpopuptype[i] = -1 then
            exit;

          if StamForm.debitorpopuptype[i] = ffDebKarLevForm.AsInteger then
          begin
            mtEksLager.value := StamForm.FLagerNr;
            mtEksAfdeling.value := Maindm.AfdNr;
            StamForm.StockLager := mtEksLager.Value;
      c2logadd('2: Stock lager changed to ' +  inttostr(StamForm.StockLager));
            exit;
          end;
        end;
      end;
      for i := 1 to 10 do
      begin
        if StamForm.debitorpopuptype[i] = -1 then
          exit;

        if StamForm.debitorpopuptype[i] = ffDebKarLevForm.AsInteger then
        begin
          if frmDebLagListe.showLagerliste = mrok then
          begin
            mtEksLager.value := nxDebLagRefNr.asinteger;
            mtEksAfdeling.value := nxDebAfdRefNr.AsInteger;
            StamForm.StockLager := mtEksLager.Value;
      c2logadd('3: Stock lager changed to ' +  inttostr(StamForm.StockLager));
          end;
          exit;
        end;

      end;

    end;
  end;
end;

procedure TTakserDosisForm.CheckLevering;
begin
  with MainDm do
  begin
    ReadyLevering;
    if not ffDebKar.FindKey([mtEksLevNr.AsString]) then
    begin
      ChkBoxOk ('Leveringskonto findes ikke i kartotek !');
      exit;
    end;
    mtEksLevNavn.AsString:= BytNavn(ffDebKarNavn.AsString);
    if ffDebKarLevForm.AsInteger in [5,6] then
    begin
//      if AllHKLines then
        mtEksUdbrGebyr.AsCurrency := ffRcpOplHKgebyr.AsCurrency;
    end;
    if ffDebKarUdbrGebyr.AsBoolean then
    begin
      if mtEksUdbrGebyr.AsCurrency = 0 then
        mtEksUdbrGebyr.AsCurrency := ffRcpOplPlejehjemsgebyr.AsCurrency;
      if ffDebKarLevForm.AsInteger = 2 then
        mtEksUdbrGebyr.AsCurrency:= ffRcpOplUdbrGebyr    .AsCurrency;
    end;
  end;
end;


procedure EkspDosis (LbNr : LongWord; EdiPtr : Pointer);
var
  TilbDato : TDateTime;


begin
  with TakserDosisForm, MainDm do begin
    ReceptId := 0;
    FirstWarning := True;
    LabelFirstWarn := True;
    ProdDyrPrices := False;
    // Stop opdater CTR
    StamForm.CtrTimer.Enabled:= FALSE;

    ForceClose := False;

    if (ffPatKarKundeType.AsInteger = 1) and (ffPatKarEjCtrReg.AsBoolean) then
    begin
      if not frmYesNo.NewYesNoBox('Personen er markeret med ''Ej reg. i CTR''.'+#13#10+
              'Er det korrekt?') then
        exit;

    end;



    // Refresh recepturoplysninger
    ffRcpOpl.Refresh;
    // Nulstil CTR
    cdCtrBev.EmptyDataSet;
    EdiRcp      := EdiPtr; // Ikke NIL ved edifact
    TakserDosisForm   := TTakserDosisForm .Create (NIL);
    AskYderNrQuestion := False;
    AskYderCPrNrQuestion := False;
    AllHKlines := False;
    UdlignOrdination := False;
    stamform.Save_StockLager := StamForm.StockLager;
    try

//      //tilskud move to separate procedure for easy reading
//      SetupTilskudLevels;

      // Nulstil memtables
      mtEks.Close;
      mtEks.Open;
      if mtEks.RecordCount <> 0 then
      begin
        mtEks.First;
        while not mtEks.Eof do
          mtEks.Delete;
      end;
      mtEks.Insert;

  //    mtLin.Close;
  //    mtLin.Open;
  //    if mtLin.recordcount <> 0 then begin
      mtLin.First;
      while not mtLin.Eof do begin
        mtLin.Delete;
      end;
      mtLin.LogChanges:= FALSE;
  //    end;
      // Kundetype m.m.
      mtEksKundeNr.AsString    := ffPatKarKundeNr.AsString;
      mtEksKundeType.Value     := ffPatKarKundeType.Value ;
      // keep the current kundenavn just in case somebody else changes it.

      mtEksKundeNavn.AsString := ffPatKarNavn.AsString;

      mtEksDebitorNr.AsString  := ffPatKarDebitorNr.AsString;
      mtEksLevNr    .AsString  := ffPatKarLevNr.AsString;
      mtEksLeveringsForm.Value := 0;
      mtEksTurNr        .Value := ffRcpOplTurNr.Value;
      if mtEksTurNr.AsInteger <> 0 then
        eTurNr.Color := clYellow
      else
        eTurNr.Color := clWindow;

      mtEksYderNr.AsString     := ffPatKarYderNr.AsString;
      mtEksYderCprNr.AsString  := ffPatKarYderCprNr.AsString;
      FillYderCPR;
      mtEksYderNavn.AsString   := ffPatKarLuYdNavn.AsString;
      mtEksNettoPriser.Value   := ffPatKarNettoPriser.Value;
      lcArt.Enabled            := False;
      lcAlder.Enabled          := False;
      lcOrd.Enabled            := False;
      FillCTRBevDataset;
      // Eksptyper og Ekspformer
      mtEksEkspType.Value  := et_Recepter;
      mtEksEkspForm.Value  := 1;
      EkspTypFilter        := EkspTypEnk;
      EkspFrmFilter        := EkspFrmEnk;
      // Debitorfelter spærres
      eDebitorNr.Color         := clSilver;
      eLevNr    .Color         := clSilver;
      lcLevForm .Color         := clSilver;
  //    lcLevForm .ReadOnly      := True;
      lcLevForm .TabStop       := False;
      ePakkeNr  .Color         := clSilver;
  //    ePakkeNr  .ReadOnly      := True;
      ePakkeNr  .TabStop       := False;

      // Narkofelter spærres
      eNarkoNr.Color           := clSilver;
      eNarkoNr.ReadOnly        := True;
      eNarkoNr.TabStop         := False;
      mtEksYdCprChk.AsBoolean  := False;

      // eglctrsaldo set to cllime
      eGlCtrSaldo.Color := clLime;
      // Debitor checkes
      mtEksAfdeling.Value      := Maindm.AfdNr;
      mtEksLager.Value         := StamForm.FLagerNr;
      mtEksAvancePct.Value     := 0;
      mtEksUdbrGebyr.AsCurrency := 0.0;

      TakserDosisForm.LagerListeLagerChk := False;
      if mtEksDebitorNr.AsString <> '' then
      begin
        // Debitor felter åbnes
        CheckDebitor;
      end;
      if mtEksLevNr.AsString <> '' then
      begin
        // Levering felter åbnes
        CheckLevering;
      end;

      // Forbered CTR variable

      C2LogAdd ('CTR oplysninger start');
      try
        try
          ffPatUpd.IndexName := 'NrOrden';
          ffPatUpd.FindKey([ffPatKarKundeNr.AsString]);
          StartCTRTime := ffPatUpdCtrStempel.AsDateTime;
          mtEksCtrType      .AsInteger  := ffPatUpdCtrType.Value;
          if mtEksCtrType.AsInteger = 0 then
          begin
            if not ffPatKarEjCtrReg.AsBoolean then
            begin
              if mtEksKundeType.Value = 1 then
              begin
                C2LogAdd ('  Barn check på cprnr/fød.dato');
                if not ffPatKarFiktivtCprNr.AsBoolean then
                begin
                  // Check over/under 18 år
                  if CheckBarn (mtEksKundeNr.AsString) then
                    mtEksCtrType.AsInteger := 1;
                end else
                begin
                  // Check over/under 18 år
                  if CheckBarnDato (ffPatKarFoedDato.AsString) then
                    mtEksCtrType.AsInteger := 1;
                end;
              end;
            end;
          end;
          mtEksCtrUdlignType.AsInteger  := 0;
          mtEksCtrUdlignDato.AsDateTime := 0;
          mtEksCtrUdlFor    .AsCurrency := 0;

          nxCTRinf.IndexName := 'KundeNrOrden';

          if nxCTRinf.FindKey([ffPatKarKundeNr.AsString])  then
          begin
            mtEksCtrUdlignDato.AsDateTime := nxCTRinffor_slutdato.AsDateTime;
            mtEksCtrUdlFor    .AsCurrency := nxCTRinffor_udlign_tilskud.AsCurrency;
          end;
          if ffPatUpdCTRUdlignB.AsCurrency <> 0 then
          begin
            ChkBoxOK('Der er en udligning i ctrB. Gå til ctrl+I, hvis den skal medtages.');
          end;

          mtEksGlCtrSaldo   .AsCurrency := ffPatUpdCtrSaldo.AsCurrency;
          eGlCtrSaldo.Color := clLime;
          if ffPatUpdCtrType.AsInteger = 0 then
            if ffPatUpdCtrSaldo.AsCurrency > KronikerGrpVoksen then
              eGlCtrSaldo.Color := clYellow;
          if ffPatUpdCtrType.AsInteger = 1 then
            if ffPatUpdCtrSaldo.AsCurrency > KronikerGrpBarn then
              eGlCtrSaldo.Color := clYellow;
          mtEksNyCtrSaldo   .AsCurrency := 0;
          mtEksCtrUdlign    .AsCurrency := ffPatUpdCtrUdlign.AsCurrency;
          eCtrType          .Color      := clYellow;
          eCtrType.Font     .Color      := clWindowText;
          // Foretag CTR opkald
          if not ffPatKarEjCtrReg.AsBoolean then
          begin
            if mtEksKundeType.Value = 1 then
            begin
              C2LogAdd ('  Barn check på cprnr/fød.dato');
              if not ffPatKarFiktivtCprNr.AsBoolean then
              begin
                // Check over/under 18 år
  //              if CheckBarn (mtEksKundeNr.AsString) then
  //                mtEksCtrType.AsInteger := 1;
              end else begin
                // Check over/under 18 år
  //              if CheckBarnDato (ffPatKarFoedDato.AsString) then
  //                mtEksCtrType.AsInteger := 1;
              end;
              C2LogAdd ('  CTR patienttype efter barn check ' + mtEksCtrType.AsString);
              C2LogAdd ('  Behandling slut');
            end else
              C2LogAdd ('  Patient ikke enkeltperson');
          end else
            C2LogAdd ('  Patient uden CTR registrering');
  (*
          C2LogAdd ('  Beregn til ny saldo');
          // Ny CTR saldo
          mtEksNyCtrSaldo.AsCurrency := mtEksGlCtrSaldo.AsCurrency;
  *)
        except
          C2LogAdd ('  Exception');
          ChkBoxOk ('Exception under CTR opkald, check log!');
        end;

      finally
        if CtrRec.CtrBevText <> '' then
        begin
          C2LogAdd('  CTR Bevillinger start');
          C2LogAdd(CtrRec.CtrBevText);
          C2LogAdd('  CTR Bevillinger slut');
        end;
        C2LogAdd('CTR oplysninger slut');
//        C2LogSave;
      end;

      // Andre ordredata
      mtEksNarkoNr.AsString      := '';
      mtEksOrdreType.Value       := 1; // Salg    2=Retur
      mtEksOrdreStatus.Value     := 1; // Åben    2=Afsluttet
//      mtEksReceptStatus.Value    := 0; // Manuel
      mtEksAntLin.Value          := 0;

      // Evt Reitereret recept
  //    if LbNr <> 0 then begin
      ReiterLbnr := 0;
      mtEksReceptStatus.Value  := 999; // Dosiskort
      mtEksEkspType    .Value  := et_Dosispakning;   // Dosikort
      mtEksEkspForm    .Value  := 1;   // Normal
      mtEksDosKortNr.asinteger := edircp.lbnr;

      mtEksYderNr      .AsString := FixLFill ('0', 7, EdiRcp.YdNr);
      eYderCPRNr.Items.Clear;
      eYderCPRNr.Items.Add(EdiRcp.YdCprNr);
      mtEksYderCprNr   .AsString := EdiRcp.YdCprNr;
      mtEksYderNavn    .AsString := EdiRcp.YdNavn;

      // Klargør filtre og visning af lookup
  //    TableFilter   (cdEksTyp);
  //    TableFilter   (cdEksFrm);
      FakTypeExit (TakserDosisForm);

      // Vis form
      ShowModal;
      C2LogAdd('F6: after showmodal');

      AllHKlines := True;
      mtLin.First;
      while not mtLin.Eof do
      begin
        if mtLinLinieType.AsInteger <> 2 then
        begin
          AllHKlines := False;
          break;
        end;
        mtLin.Next;

      end;

      if AllHKlines then
      begin
        if mtEksDebitorNr.AsString <> '' then
        begin
          // Debitor felter åbnes
          CheckDebitor;
        end;
        if mtEksLevNr.AsString <> '' then
        begin
          // Levering felter åbnes
          CheckLevering;
        end;
      end;

      // Post ekspedition i memtable
      C2LogAdd('F6:Before mteks post !!!!!!');
      mtEks.Post;
      C2LogAdd('F6:after mteks post !!!!!!');

      if ModalResult <> mrOK then begin
        exit;
      end;

      C2LogAdd('F6:modal result ok update stamform');
      StamForm.Update;
      C2LogAdd('check for ctr 0 and tilbagefoersel');
      // Check for CTR 0 saldo og tilbageførsel
      TilbDato:= 0;
      if (mtEksOrdreType.AsInteger = 2) and (mtEksNyCtrSaldo.AsCurrency < 0) then begin
        C2LogAdd('  CTR forrige periode start');
        FillChar(CtrRec, SizeOf (CtrRec), 0);
        nxRemoteServerInfoPlugin1.GetServerDateTime(TilbDato);
        CtrRec.CprNr  := MtEksKundeNr.AsString;
        CtrRec.TimeOut:= 10000;
        MidClient.RecvCtrForrige(CtrRec);
        C2LogAdd ('    Status og message kode ' + IntToStr(CtrRec.Status) + ' ' + CtrRec.CtrMsg);
        if (CtrRec.Status = 0) and (CtrRec.CtrMsg = '0100') then begin
          // Tag dato fra forrige periode
          C2LogAdd('    Patientoplysninger');
          C2LogAdd('      CprNr "'   + CtrRec.CprNr   + '"');
          C2LogAdd('      Barn "'    + CtrRec.Barn    + '"');
          C2LogAdd('      PatType "' + CtrRec.PatType + '"');
          C2LogAdd('      Saldo "'   + CtrRec.Saldo   + '"');
          C2LogAdd('      UdlAkt "'  + CtrRec.Udlign  + '"');
          C2LogAdd('      UdlFor "'  + CtrRec.UdlFor  + '"');
          C2LogAdd('      SlutAkt "' + CtrRec.PerSlut + '"');
          C2LogAdd('      SlutFor "' + CtrRec.ForSlut + '"');
          if Length(CtrRec.PerSlut) = 10 then
            TilbDato:= StrToDate(CtrRec.PerSlut);
        end;
        TilbDato:= ChkBoxDate('Dato i forrige periode' , TilbDato);
        C2LogAdd ('  CTR forrige periode start');
      end;


      C2LogAdd('F6:About to call afslutekspedition');
      AfslutEkspedition(TRUE, CloseF6, CloseSF6, CloseCF6,CloseCSF6, TilbDato);
      C2LogAdd('F6:After call afslutekspedtion' );
      EkspTypFilter := EkspTypAlle;
      EkspFrmFilter := EkspFrmAlle;
      LinTypFilter  := LinTypAlle;
    finally
      c2logadd('F6: start of finally');
      Stamform.TakserDosisKortAuto := False;
      StamForm.Undladafstemplingsetiketter := False;
      TakserDosisForm .Free;
      TakserDosisForm := NIL;
      // Start opdater CTR
      StamForm.CtrTimer.Enabled:= TRUE;
      StamForm.StockLager := Stamform.Save_StockLager;
      c2logadd('f6: Stock lager changed to ' +  inttostr(StamForm.StockLager));
      C2LogAdd('F6: end of finally');
    end;
  end;
end;

procedure TTakserDosisForm.CheckCtrUpdate;
var
  save_index : string;
  ExitCode : DWord;
  i : integer;
begin
  with MainDm do
  begin
    C2LogAdd('CheckCtrUpdate in');
    if C2GetCTRJobid <> 0 then
    begin
      for i := 1  to 50 do
      begin
        GetExitCodeProcess (C2GetCTRJobid, ExitCode);
        if ExitCode <> STILL_ACTIVE then
          break;
        Sleep (100);
      end;
      C2GetCTRJobid := 0;
      C2LogAdd('c2getctr ' + IntToStr(ExitCode));
    end;

    save_index := ffPatUpd.indexname;
    ffpatupd.IndexName := 'NrOrden';
    try
      if not ffPatUpd.FindKey([ffPatKarKundeNr.AsString]) then
        exit;
      C2LogAdd('  Patient "' + ffPatUpdKundeNr.AsString + '" findes');
      C2LogAdd('    CtrStempel "' + ffPatUpdCtrStempel.AsString + '"');
      C2LogAdd('    CtrSaldo "' + ffPatUpdCtrSaldo.AsString + '"');
      C2LogAdd('    CtrUdlign "' + ffPatUpdCtrUdlign.AsString + '"');
      if (mtEksAntLin.Value < 2) and (dsEks.State <> dsBrowse) then
      begin
          C2LogAdd('first line always update the ctr values');
          mtEksGlCtrSaldo.AsCurrency := ffPatUpdCtrSaldo.AsCurrency;
          mtEksCtrUdlign.AsCurrency := ffPatUpdCtrUdlign.AsCurrency;


      end;

      if dsEks.State = dsEdit then
        C2LogAdd('  mtEks in edit state');
      if dsEks.State = dsInsert then
        C2LogAdd('  mtEks in insert state');
      if dsEks.State = dsBrowse then
        C2LogAdd('  mtEks in browse state');
      if MinutesBetween(Now,ffPatUpdCtrStempel.AsDateTime) > 15 then begin
        C2LogAdd('  Tidsforskel > 15 minutter fra nu');
        if ffPatUpdKundeType.AsInteger = 1 then
          eGlCtrSaldo.Color := clRed;
  //        ChkBoxOK('CTR data er ældre end 15 mintter.' + #13#10+
  //         'Der er en risiko for at det ikke er nyeste saldo, der anvendes.');
      end;
      if MinutesBetween(ffPatUpdCtrStempel.AsDateTime,StartCTRTime) <= 15 then
        exit;
      C2LogAdd('  Tidsforskel > 15 minutter fra StartCtrTime');
    (* BO 3.2.3.9 fjernet
          if mtEksAntLin.Value = 0 then begin
     BO 3.2.3.9 fjernet *)
    (* BO 3.2.3.9 rettet *)
      if mtEksAntLin.Value < 2 then begin
(* BO 3.2.3.9 rettet *)
        C2LogAdd('  Første linie i ekspedition');
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
//          mtEks.Post;
//          mtEks.ApplyUpdates(-1);
//          mtEks.Refresh;
//          mtEks.Edit;
          mtEksGlCtrSaldo.AsCurrency := ffPatUpdCtrSaldo.AsCurrency;
          eGlCtrSaldo.Color := clLime;
          if ffPatUpdCtrType.AsInteger = 0 then
            if ffPatUpdCtrSaldo.AsCurrency > KronikerGrpVoksen then
              eGlCtrSaldo.Color := clYellow;
          if ffPatUpdCtrType.AsInteger = 1 then
            if ffPatUpdCtrSaldo.AsCurrency > KronikerGrpBarn then
              eGlCtrSaldo.Color := clYellow;
          mtEksCtrUdlign.AsCurrency := ffPatupdCtrUdlign.AsCurrency;
          if mtEksAntLin.Value <> 0 then
            mtLinGlSaldo.AsCurrency   := ffPatUpdCtrSaldo.AsCurrency;
          ffPatKar.Refresh;
          if nxCTRinf.FindKey([ffPatUpdKundeNr.AsString]) then
            mtEksCtrUdlFor.AsCurrency := nxCTRinffor_udlign_tilskud.AsCurrency;
        except
          on e: exception do
            c2logadd(e.Message);
        end;
        exit;
(* BO 3.2.3.9 fjernet *)
      end;
      C2LogAdd('  Check for saldo ændret');
      if mtEksGlCtrSaldo.AsCurrency <> ffPatUpdCtrSaldo.AsCurrency then begin
        C2LogAdd('    Saldo ændret - bruger advares');
        ChkBoxOK('CTR data er ændret i forhold til igangværende ekspedition. ' + #13#10 +
        'Det anbefales at lukke ekspeditionen og starte forfra.');
      end;
      FillCTRBevDataset;
      eGlCtrSaldo.Color := clLime;
      if ffPatUpdCtrType.AsInteger = 0 then
        if ffPatUpdCtrSaldo.AsCurrency > KronikerGrpVoksen then
          eGlCtrSaldo.Color := clYellow;
      if ffPatUpdCtrType.AsInteger = 1 then
        if ffPatUpdCtrSaldo.AsCurrency > KronikerGrpBarn then
          eGlCtrSaldo.Color := clYellow;
    finally
      ffPatUpd.IndexName := save_index;
    end;
    C2LogAdd('CheckCtrUpdate out');
  end;
end;

function TTakserDosisForm.NyLinie : boolean;
var
  I       : Integer;
  UdlDato : TDateTime;
  UdlFor,
  UdlAkt,
  Udlign,
  Saldo   : Currency;
begin
  with MainDm do
  begin

    Result := True;
    save_caption := '';
    OriginalAntal := 0;
    // Check nyeste CTR
    CheckCtrUpdate;
    // Check linie
    Saldo  := mtEksGlCtrSaldo.AsCurrency;
    UdlAkt := mtEksCtrUdlign.AsCurrency;
    UdlFor := mtEksCtrUdlFor.AsCurrency;
    if mtEksAntLin.Value > 0 then begin
      Saldo  := mtLinNySaldo.AsCurrency;
      Udlign := mtLinUdligning.AsCurrency;
    end else
      Udlign := UdlAkt;
    paLager.Caption := '';
    paInfo.Color := clBtnFace;
    paInfo .Caption := '';
    SkipReservation := False;
    // Ny linie i linietæller på eksp.
    mtEksAntLin.Value         := mtEksAntLin.Value + 1;

    // Ny linie i mtLin
    itemsubst := False;
    KlausFlag := False;
    mtLin.Append;
    mtLinInclMoms.AsBoolean := True;
    mtLinEtkLin.Value         := 0;
    mtLinValideret.AsBoolean  := False;
    mtLinReitereret.AsBoolean := False;
    mtLinLinieNr.Value        := mtEksAntLin.Value;
    mtLinLager.Value          := mtEksLager.AsInteger;
    mtLinGlSaldo.AsCurrency   := Saldo;
    mtLinSubstValg.Value      := 9;
    if (ffPatKarEjSubstitution.AsBoolean) or
       (Recepturplads = 'DYR') then
      mtLinSubstValg.Value    := 0;
    mtLinEjS.Value            := False;
    // Normal
    mtLinUdlevMax.Value       := 0;
    mtLinUdlevNr.Value        := 1;
    mtLinAntal.Value          := 1;
    mtLinLinieType.Value      := 1;
    if (mtEksKundeType.AsInteger in [0,15]) then
      mtLinLinieType.AsInteger := 2;
    meEtiketter.Clear;
    meEtiketter.Lines.Add ('<TOM ETIKET>');
    // Felter uden db
    EVare.Text                := '';
    EAntal.Text               := IntToStr (mtLinAntal.Value);
    // Dosering og indikation
    EDos2.Text                := '';
    cbIndikation.Clear;
    cbDosTekst.Clear;
    // Linietype
    LinTypFilter              := LinTypRcp;
    if mtEksEkspType.Value = et_Haandkoeb then
    begin
      LinTypFilter            := LinTypHdk;
      mtLinLinieType.Value    := 2;
    end;
  //  TableFilter (cdLinTyp);
    TableFilter (cdDyrArt);
    TableFilter (cdDyrAld);
    TableFilter (cdDyrOrd);
    lcbLinTyp.ItemIndex:= mtLinLinieType.Value - 1;
    // Opdater form
    TakserDosisForm.Update;
    // Første linie
    if mtLinLinieNr.Value = 1 then
    begin
      // Evt. udligning
      if (Abs(UdlFor) > 0.25) or (Abs(UdlAkt) > 0.25) then begin
        if StamForm.DosisBatchMode then
        begin
          DosisUdlignPatients.Add(mtEksKundeNr.AsString);
        end
        else
        begin
          if TCtrUdlignForm.CtrUdlignValg (UdlDato, mtEksCtrUdlignDato.AsDateTime, Now,
                            Udlign, UdlFor, UdlAkt,Saldo,False) then begin
            if UdlDato > 0 then begin
              // Fjern evt. forsendelse
              mtEksCtrUdlignDato.Value    := UdlDato;
              mtEksCtrUdlignType.Value    := 1;
    //          mtEksDebitorNr.AsString     := '';
    //          mtEksDebitorNavn.AsString   := '';
    //          mtEksLevNr      .AsString   := '';
    //          mtEksLevNavn    .AsString   := '';
    //          mtEksLeveringsForm.Value    := 8;
              // Sikre at eksptype og form er korrekt
              mtEksEkspType.Value         := et_Recepter;
              mtEksEkspForm.Value         := 1;
              mtEksReceptStatus.Value     := 0;
              // Debitorfelter spærres
              eDebitorNr.Color            := clSilver;
              lcLevForm .Color            := clSilver;
              lcLevForm .ReadOnly         := True;
              lcLevForm .TabStop          := False;
              ePakkeNr  .Color            := clSilver;
              ePakkeNr  .ReadOnly         := True;
              ePakkeNr  .TabStop          := False;
              // Udfyld eksp.linie og afslut
              mtLinValideret.AsBoolean    := True;
              mtLinLinieType.Value        := 1;
              mtLinVareNr.AsString        := '100015';
              mtLinSubVareNr.AsString     := '100015';
              mtLinForm.AsString          := '';
              mtLinStyrke.AsString        := '';
              mtLinPakning.AsString       := '';
              mtLinSSKode.AsString        := '';
              mtLinATCType.AsString       := '';
              mtLinATCKode.AsString       := '';
              mtLinPAKode.AsString        := '';
              mtLinUdlevType.AsString     := '';
              mtLinHaType   .AsString     := '';
              mtLinUdlevMax.Value         := 0;
              mtLinUdlevNr.Value          := 0;
              mtLinRegelKom1.Value        := 0;
              mtLinRegelKom2.Value        := 0;
              mtLinGlSaldo.AsCurrency     := 0;
              mtLinNySaldo.AsCurrency     := 0;
              mtLinDKTilsk.AsCurrency     := 0;
              mtLinDKEjTilsk.AsCurrency   := 0;
              mtLinTilskKom1.AsCurrency   := 0;
              mtLinTilskKom2.AsCurrency   := 0;
              // Sygesikring og udligningsregel
              mtLinTilskType.Value        := 1;
              mtLinRegelSyg.Value         := 44;
              mtLinAntal.Value            := 1;
              mtLinKostPris.AsCurrency    := Abs (Udlign);
              mtLinESP.AsCurrency         := Abs (Udlign);
              mtLinBGP.AsCurrency         := Abs (Udlign);
              mtLinPris.AsCurrency        := Abs (Udlign);
              mtLinBrutto.AsCurrency      := Abs (Udlign);
              mtLinIBTBel.AsCurrency      := Abs (Udlign);
              mtLinAndel.AsCurrency       := Abs (Udlign);
              mtLinUdligning.AsCurrency   := Abs(Udlign);
              mtLinTilskSyg.AsCurrency    := 0;
              mtLinBGPBel.AsCurrency      := 0;
              if Udlign < 0 then begin
                // Udligning til sygesikringen
                mtEksOrdreType.Value      := 1;
                mtLinTekst.AsString       := 'Udligning til sygesikringen';
              end else begin
                // Udligning til patient
                mtEksOrdreType.Value      := 2;
                mtLinTekst.AsString       := 'Udligning til patienten';
              end;
              mtLinJournalNr1.AsString    := '';
              mtLinJournalNr2.AsString    := '';
              mtLinChkJrnlNr1.AsBoolean   := FALSE;
              mtLinChkJrnlNr2.AsBoolean   := FALSE;
              // temp fix until we get a solution for terminal patients
    //          if  (mtEksCtrType.AsInteger <> 10) and
    //              (mtEksCtrType.AsInteger <> 11) and
    //              (mtEksCtrType.AsInteger <> 99) then
                BeregnUdligningOrdination;
              // reset these values just in case they were changed in beregnordination
              mtLinRegelSyg.Value         := 44;
              mtLinTilskType.Value        := 1;
              buGem.Enabled               := True;
              CloseSF6                    := True;
              if mtRei.recordcount > 0 then begin
                while not mtRei.Eof do
                  mtRei.Delete;
              end;
              UdlignOrdination := True;
              buGem.Click;
            end else
              ChkBoxOK ('Udligning kan ikke foretages på forkert tidsstempel !');
          end else
            mtLinUdligning.AsCurrency := Udlign;
        end;
      end;
    end;
    // Hvis der ikke var udlignet
    if mtEksCtrUdlignType.Value <> 0 then
      exit;
//    if (mtEksReceptStatus.Value = 2) then //or (mtEksReceptStatus.Value = 999) then begin
//    begin
      if mtRei.RecordCount = 0 then begin
//        StamForm.TakserDosisKortAuto := False;
        Result := False;
        exit;

      end;

      // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER
      // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER
      // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER
      // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER
      // ZZZZZZZZZZZZZZZZZZZZZZZZ BENYTTER EDIFACT KODER

      // Memtable felter
      mtLinUdlevMax  .Value     := mtReiUdlevMax .Value;
      mtLinUdlevNr   .Value     := mtReiUdlevNr  .Value;
      mtLinAntal     .Value     := mtReiAntal    .Value;
      OriginalAntal := mtReiAntal    .Value;
      mtLinDosering1 .AsString  := mtReiDosKode1 .AsString;
      mtLinDosering2 .AsString  := '';
      mtLinIndikation.AsString  := mtReiIndikKode.AsString;
      mtLinFolgeTxt  .AsString  := '';
      mtLinLinieType .Value     := 1;
//      if mtEksReceptStatus.Value = 999 then
//        mtLinLinieType .Value     := 1;
//      else
//        if mtReiOrdId.AsString = '' then
//          mtLinLinieType.Value := 2;

      mtLinReitereret.AsBoolean := True;
      mtLinSubstValg .Value     := mtReiSubst    .Value;
      mtLinOrdId.asstring       := mtReiOrdId.AsString;
      mtLinReceptId.AsInteger   := mtReiReceptId.AsInteger;
      // Edit felter
      EVare          .Text      := mtReiVareNr   .AsString;
      EAntal         .Text      := IntToStr (mtLinAntal.Value);
      paInfo.Caption := mtReiVareTxt.AsString;
      save_caption := paInfo.Caption;
      itemsubst := pos('-S',paInfo.Caption)<>0;
      KlausFlag := pos('KLAUS',paInfo.Caption)<>0;
      if (itemsubst) or (KlausFlag) then
        paInfo.Color := clYellow;
      meEtiketter.Clear;
      meEtiketter.Update;
      for I := 1 to mtReiEtkLin.Value do
        meEtiketter.Lines.Add (mtRei.FieldByName ('Etk' + IntToStr (I)).AsString);
      mtRei.Delete;
//      if mtLinLinieNr.Value = 1 then
//      begin
//        SelectNext (ActiveControl, TRUE, TRUE);
//        if (Stamform.TakserDosisKortAuto) then
//        begin
//          if EVare.Text <> '' then
//          begin
//            EVare.SetFocus;
//            TakserDosisForm.FormKeyPress(buVidere,cr);
//            EAntal.SetFocus;
//            TakserDosisForm.FormKeyPress(buVidere,cr);
//            EMax.SetFocus;
//            TakserDosisForm.FormKeyPress(buVidere,cr);
//            EUdlev.SetFocus;
//            TakserDosisForm.FormKeyPress(buVidere,cr);
//          end;
//          if mtRei.RecordCount <> 0 then
//          begin
//             buVidereClick(buVidere);
//          end
//          else
//          begin
//            if (Stamform.TakserDosisKortAuto) and (DosisKortAutoExp) then
//              buGemClick(buGem);
//          end;
//          exit;
//        end;
//      end;
//    end;
  end;
end;

procedure TTakserDosisForm.buLukClick(Sender: TObject);
begin
  Close;
end;

procedure TTakserDosisForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  //if there has been an error then just quit taksering screen

  if  ForceClose then
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
      CanClose := True;
      ModalResult := mrCancel;
    end
    else
      CanClose := False;
  end;

end;

procedure TTakserDosisForm.FormActivate(Sender: TObject);
var
  I, J: Word;

begin
  with MainDm do begin
    C2LogAdd('Human Form Formactivate fired');
    if FirstTime then
      exit;
    C2LogAdd('first time is false then set it true');
    if (Screen.Height <= 768) and (Screen.Width <= 1024) then
      if (StamForm.FullScreen) or (Screen.Height=600) then
        SendMessage(Self.Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
    FirstTime := True;
    itemsubst := False;
    KlausFlag := False;
    // Etiketareal afhængig af printer
    if Recepturplads = 'DYR' then begin
      // Dyr
      meEtiketter.Width:= meEtiketter.Tag;
      cbSubst.Visible  := FALSE;
      laMax  .Visible  := FALSE;
      EMax   .Visible  := FALSE;
      laUdlev.Visible  := FALSE;
      EUdlev .Visible  := FALSE;
    end else begin
      // Human
      cbSubst.Visible  := TRUE;
      laMax  .Visible  := TRUE;
      EMax   .Visible  := TRUE;
      laUdlev.Visible  := TRUE;
      EUdlev .Visible  := TRUE;
    end;
    C2LogAdd('Emptying the mtrei tables');
    mtRei.Active := False;
    mtRei.Active := True;
    if mtRei.recordcount > 0 then begin
      while not mtRei.Eof do
        mtRei.Delete;
    end;
//    if (mtEksReceptStatus.Value = 2) then or (mtEksReceptStatus.Value = 999) then begin
      // Edifact dan receptlinier
      mtRei.Active := False;
      mtRei.Active := True;
      if mtRei.recordcount > 0 then begin
        while not mtRei.Eof do
          mtRei.Delete;
      end;
      SaveDosisKortNr := Edircp.LbNr;
      for J := 1 to EdiRcp.OrdAnt do begin
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
        if ffPatKarCtrType.AsInteger in [1,11] then
          meEtiketter.Lines.Add (AnsiUpperCase (BytNavn (ffPatKarNavn.AsString)) + ' ' +
            calcage(ffPatKarKundeNr.AsString,ffPatKarFoedDato.AsString))
        else
          meEtiketter.Lines.Add (AnsiUpperCase (BytNavn (ffPatKarNavn.AsString)));
        meEtiketter.Lines.Add (AnsiUpperCase (Trim    (EdiRcp.Ord [J].DosTxt)));
        meEtiketter.Lines.Add (AnsiUpperCase (Trim    (EdiRcp.Ord [J].IndTxt)));
        mtRei.Append;
        mtReiVareNr    .AsString := EdiRcp.Ord [J].VareNr;
        mtReiVareTxt   .AsString := copy(EdiRcp.Ord [J].Navn,1, 20) + ',' +
                                    copy(edircp.ord[j].Disp,1,10) + ',' +
                                    copy(EdiRcp.Ord [J].Pakn,1, 10) + ',' +
                                    copy(EdiRcp.Ord [J].Strk,1,10);
        if EdiRcp.Ord[J].Subst <> '' then
          mtReiVareTxt.asstring := mtReiVareTxt.asstring + ',  -S';
        if EdiRcp.ord[j].Klausulbetingelse then
          mtReiVareTxt.asstring := mtReiVareTxt.asstring + ',KLAUS';

        mtReiUdlevNr   .Value    := 1;
        if EdiRcp.ord[j].PEMAdmDone<> 0 then
          mtReiUdlevNr   .Value    := edircp.Ord[j].PEMAdmDone + 1;

        mtReiUdlevMax  .Value    := 0;
        if EdiRcp.Ord [J].Udlev > 1 then
          mtReiUdlevMax.Value    := EdiRcp.Ord [J].Udlev;
        mtReiAntal     .Value    := EdiRcp.Ord [J].Antal;
        mtReiDosKode1  .AsString := EdiRcp.Ord [J].DosKode;
        mtReiDosKode2  .AsString := '';
        mtReiIndikKode .AsString := EdiRcp.Ord [J].IndKode;
        mtReiTxtKode   .AsString := '';
        mtReiSubst     .Value    := 9;
        if Trim (EdiRcp.Ord [J].Subst) = '' then
          mtReiSubst   .Value    := 5
        else begin
          if Pos ('-S', EdiRcp.Ord [J].Subst) > 0 then
            mtReiSubst .Value    := 1;
          if Pos ('-G', EdiRcp.Ord [J].Subst) > 0 then
            mtReiSubst .Value    := 2;
        end;
        mtReiEtkLin    .Value    := 0;
        mtReiOrdId.AsString :=  edircp.ord[j].OrdId;
        mtReiReceptId.AsInteger := EdiRcp.Ord[j].ReceptId;
        c2logadd('setting the etiket label ' + meEtiketter.Text);
        for I := 1 to 10 do begin
          mtRei.FieldByName ('Etk' + IntToStr (I)).AsString := '';
          if meEtiketter.Lines.Count >= I then begin
            mtRei.FieldByName ('Etk' + IntToStr (I)).AsString :=
                               Trim (meEtiketter.Lines [I - 1]);
            if mtRei.FieldByName ('Etk' + IntToStr (I)).AsString <> '' then
              mtReiEtkLin.Value := mtReiEtkLin.Value + 1;
          end;
        end;
        mtRei.Post;
      end;
      // Slet evt. etiketter
      meEtiketter.Clear;
      // Peg på første post
      mtRei.First;
      // Forlad EkspForm
      EkspFormExit (Self);
      // Normal recept
//      if mtEksReceptStatus.AsInteger <> 999 then begin
//        PostMessage (lcbEkspType.Handle, wm_KeyDown, VK_DOWN, 0);
//        PostMessage (lcbEkspType.Handle, wm_KeyDown, VK_UP,   0);
//        PostMessage (lcbEkspForm.Handle, wm_KeyDown, VK_DOWN, 0);
//        PostMessage (lcbEkspForm.Handle, wm_KeyDown, VK_UP,   0);
//      end;
      lcbEkspType.SetFocus;

      // if dosiscard then lets press the button for a new line as well.

      PostMessage (buVidere.Handle, WM_LBUTTONDOWN, 0, 0);
      PostMessage (buVidere.Handle, WM_LBUTTONUP, 0,   0);
//    end;
  end;
end;

procedure TTakserDosisForm.FormShow(Sender: TObject);
begin
  with MainDm do begin
    c2logadd('Set firsttime to false');
    FirstTime        := False;
    buVidere.Tag     := 0;
    buGem.Enabled    := False;
    CloseF6          := False;
    CloseSF6         := False;
    CloseCF6         := False;
    CloseCSF6         := False;
    save_caption := '';
    if ReceptId = 0 then
      btnVis.Visible := False
    else begin
      btnVis.Visible := True;
    end;
    SkipReservation := False;
    cbDosTekst.AutoComplete := False;
    cbIndikation.AutoComplete := False;
    if StamForm.HentDosisIndikationsForslag then begin
      cbDosTekst.AutoComplete := True;
      cbIndikation.AutoComplete := True;
    end;

  (*
    paLinier.Visible := False;
    paBund.Visible   := False;
    Update;
  *)
  end;
end;

procedure TTakserDosisForm.EkspFormExit(Sender: TObject);
begin
  with MainDm do begin
    if mtEksEkspForm.Value = 4 then begin
      if eNarkoNr.Text <> '' then
        eNarkoNr.Color    := clWindow
      else
        eNarkoNr.Color    := clYellow;
      eNarkoNr.ReadOnly   := False;
      eNarkoNr.TabStop    := True;
    end else begin
      eNarkoNr.Color      := clSilver;
      eNarkoNr.ReadOnly   := True;
      eNarkoNr.TabStop    := False;
    end;

  //  if mtEksEkspType.Value = 6 then begin
      eYderCprNr.Color    := clYellow;
      eYderCprNr.ReadOnly := False;
      eYderCprNr.TabStop  := True;
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
  //  PostMessage (buVidere.Handle, WM_SETFOCUS, 0, 0);
  end;
end;

procedure TTakserDosisForm.buVidereEnter(Sender: TObject);
begin
  with MainDm do begin
    buGem.Enabled := False;

    if mtEksAntLin.Value = 0 then begin
      buVidere.Tag := 1;
      NyLinie;
      exit;
    end;



    if mtLin.State = dsBrowse then
      mtLin.Edit;
    // Kun valider hvis vi kommer fra indikation
    if buVidere.Tag = 2 then begin
      // Interaktionscheck
      if CheckOrdination then
        buGem.Enabled := True;
    end else
      buGem.Enabled := True;
  end;
end;

procedure TTakserDosisForm.buVidereExit(Sender: TObject);
begin
  with MainDm do begin
    buGem.Enabled := False;
    buVidere.Tag  := 0;
  end;
end;

procedure TTakserDosisForm.buVidereClick(Sender: TObject);
var
  cr : char;
begin
  with MainDm do begin
    // Kun check ved kontrol med indikation
    if buVidere.Tag = 2 then begin
      if CheckOrdination then
        NyLinie;
    end;
  (*Erstatter buVidereExit*)
    buGem.Enabled := False;
    buVidere.Tag  := 0;
  (*Erstatter buVidereExit*)
    SelectNext (ActiveControl, TRUE, TRUE);
    if (Stamform.TakserDosisKortAuto) then begin
      if EVare.Text <> '' then begin
        EVare.SetFocus;
        cr := #13;
        TakserDosisForm.FormKeyPress(Sender,cr);
        EAntal.SetFocus;
        cr := #13;
        TakserDosisForm.FormKeyPress(Sender,cr);
        EMax.SetFocus;
        cr := #13;
        TakserDosisForm.FormKeyPress(Sender,cr);
        EUdlev.SetFocus;
        cr := #13;
        TakserDosisForm.FormKeyPress(Sender,cr);
      end;
      if mtRei.RecordCount <> 0 then begin
         buVidereClick(Sender);
      end else begin
        if (Stamform.TakserDosisKortAuto) and (DosisKortAutoExp) then
          buGemClick(Sender);
      end;
      exit;
    end;
    if MainDm.TakserAutoEnter then
    begin
      if (mtEksKundeType.AsInteger <> 13) and (mtEksKundeType.AsInteger <> 14) then
        evare.SetFocus;
    end;

  end;
end;

procedure TTakserDosisForm.buVidereKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with MainDm do begin
    if (Key <> VK_F6) then
      exit;
    if ((Shift = []) or (Shift = [ssShift]) or (Shift = [ssCtrl])
          or ((ssShift in shift) and (ssctrl in shift) )) then
    begin
      Key := 0;
      if not CheckOrdination then
        exit;
      CloseF6:= True;
      // Trykket på SF6 eller dosispakning
      if (Shift = [ssShift]) or (mtEksEkspType.Value = et_Dosispakning) then
      begin
        CloseSF6:= True;
      end;
      // To etiketter
      if Shift = [ssCtrl] then
      begin
        CloseCF6:= True;
      end;
      // Gem
      if (ssShift in shift) and (ssctrl in shift)  then
      begin
        CloseCSF6 := True;
      end;

      buGem.Click;
    end;
  end;
end;

procedure YdLst;
begin
  with TakserDosisForm, MainDm do
  begin
    try
    ffYdLst.FindKey([mtEksYderNr.AsString]);
    except
    end;
    if ShowYdLst ('YderNr', dsYdLst, ffYdLst) then begin
      mtEksYderNr.AsString    := ffYdLstYderNr.AsString;
      mtEksYderCprNr.AsString := ffYdLstCprNr.AsString;
      mtEksYderNavn.AsString  := ffYdLstNavn.AsString;
    end;
    FillYderCpr;
    eYderCPRNr.SetFocus;
  end;
end;

procedure YdCprLst;
begin
  with TakserDosisForm, MainDm do begin
    if ShowYdLst ('CprNr', dsYdLst, ffYdLst) then begin
  //    mtEksYderCprNr.AsString := ffYdLstCprNr.AsString;
      mtEksYderNavn.AsString  := ffYdLstNavn.AsString;
    end;
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
  W : Word;
  str1 : string;
  sl: tstringlist;
begin
  with TakserDosisForm, MainDm do begin
    sl  := tstringlist.Create;
    try
      mtLinEtkLin.Value := 0;
      for W := 1 to 10 do begin
        mtLinEtkLin.Value := mtLinEtkLin.Value + 1;
        mtLin.FieldByName ('Etk' + IntToStr (W)).AsString := '';
       if meEtiketter.Lines.Count >= W then
          mtLin.FieldByName ('Etk' + IntToStr (W)).AsString := meEtiketter.Lines [W - 1];
      end;
      for str1 in  meEtiketter.Lines do
        sl.Add(str1);

      try
        MainDm.mtlinEtkMemo.AsString := sl.Text;
    //    MainDm.mtlinEtkMemo.Assign(meEtiketter.Lines);
      except
        on e : exception do
          Application.MessageBox(pchar(e.Message),'erm');
      end;
    finally
      sl.free;
    end;
  end;
end;

procedure mtLin2meEtk;
begin
  with TakserDosisForm, MainDm do begin
    meEtiketter.Clear;
    meEtiketter.Lines.Assign(mtlinEtkMemo);
  //  for W := 1 to mtLinEtkLin.Value do
  //    meEtiketter.Lines.Add (mtLin.FieldByName ('Etk' + IntToStr (W)).AsString);
  end;
end;

function TTakserDosisForm.CheckOrdination : Boolean;
var
  Bel : Currency;
  VareForSale : boolean;
begin
  with MainDm do begin
    Result := TRUE;
    // Check modulus 11 på journalnr
    if mtLinChkJrnlNr1.AsBoolean then
    begin
      if Date < EncodeDate(2018,1,1) then
      begin
        if not CheckJrnlNr (mtLinJournalNr1.AsString) then
        begin
          C2LogAdd ('Journalnr1 har modulus 11 fejl !');
          Result := FALSE;
          Exit;
        end;
      end
      else
      begin
        if length(Trim(mtLinJournalNr1.AsString)) <> 10  then
        begin
          C2LogAdd('Journalnummer skal bestå af 10 karakterer');
          Result := FALSE;
          Exit;
        end;

      end;
    end;
    if mtLinChkJrnlNr2.AsBoolean then
    begin
        if length(Trim(mtLinJournalNr2.AsString)) <> 10  then
        begin
          C2LogAdd('Journalnummer skal bestå af 10 karakterer');
          Result := FALSE;
          EVare.SetFocus;
          Exit;
        end;

    end;
    // Check håndkøb
    if mtLinLinieType.Value = 2 then begin
      VareForSale := False;
      if (Pos ('HA', mtLinUdlevType.AsString) <> 0) then
        VareForSale := True;
      if (Pos ('HV', mtLinUdlevType.AsString) <> 0) then
        VareForSale := True;
      if (Pos ('HF', mtLinUdlevType.AsString) <> 0) then
        VareForSale := True;
      if (Pos ('HP', mtLinUdlevType.AsString) <> 0) then
        VareForSale := True;
      if (Pos ('HPK', mtLinUdlevType.AsString) <> 0) then
        VareForSale := True;

      if (mtLinVareType.AsInteger in [2,8,9,10,11,12]) then
        VareForSale := True;

      if not VareForSale then begin
        ChkBoxOk ('Vare er IKKE håndkøbsvare !');
        Result := FALSE;
        lcbLinTyp.SetFocus;
        Exit;
      end;
    end;
    // Check antal
    if (mtLinAntal.Value < 1) or (mtLinAntal.Value > 99) then begin
      ChkBoxOk ('Antal pakninger skal være mellem 1 - 99 !');
      Result := FALSE;
      EAntal.SetFocus;
      Exit;
    end;
    if mtLinTilskSyg.AsCurrency > 999999.99 then begin
      ChkBoxOK('sygesikringsbeløb må ikke være større end 999.999,99');
      Result := False;
      EAntal.SetFocus;
      Exit;
    end;
    // Check max udleveringer
    if (mtLinUdlevMax.Value < 0) or (mtLinUdlevMax.Value > 99) then begin
      ChkBoxOk ('Max. udleveringer skal være mellem 0 - 99 !');
      Result := FALSE;
      EMax.SetFocus;
      Exit;
    end;
    // Check udleveringsnr
    if mtLinUdlevMax.Value > 0 then begin
      if (mtLinUdlevNr.Value < 1) or (mtLinUdlevNr.Value > 99) then begin
        ChkBoxOk ('Udleveringsnr skal være mellem 1 - 99 !');
        Result := FALSE;
        EUdlev.SetFocus;
        Exit;
      end;
    end else
      mtLinUdlevNr.Value := 1;
    // Check varenr
    if mtLinVareNr.AsString = '' then begin
      ChkBoxOk ('Varenr skal indtastes !');
      Result := FALSE;
      EVare.SetFocus;
      Exit;
    end;

    if mtLinSubVareNr.AsString <> '' then begin
      if ffPatKarEjSubstitution.AsBoolean then begin
        if mtLinSubVareNr.AsString <> mtLinVareNr.AsString then begin
          ChkBoxOk ('Patient ønsker IKKE substitution !');
          Result := FALSE;
          EVare.SetFocus;
          Exit;
        end;
        mtLinEjS.AsBoolean := True;
        mtLinSubstValg.Value    := 2;
      end;
    end else
      mtLinSubVareNr.AsString := mtLinVareNr.AsString;
    // Check pris = alle tilskud + patientandel
    Bel := 0;
    Bel := Bel + mtLinTilskSyg.AsCurrency;
    Bel := Bel + mtLinTilskKom1.AsCurrency;
    Bel := Bel + mtLinTilskKom2.AsCurrency;
    Bel := Bel + mtLinAndel.AsCurrency;
//    if Bel <> mtLinBrutto.AsCurrency then begin
//      ChkBoxOk ('Pris <> tilskud og patientandel !');
//      Result := FALSE;
//      EVare.SetFocus;
//      Exit;
//    end;
    // Check substitution
    if mtLinSubstValg.Value = 9 then begin
      ChkBoxOk ('Mangler evt. subst. fravalg !');
      Result := FALSE;
      cbSubst.SetFocus;
      Exit;
    end;
    // Opdater Ctr saldo på linie og lokalt
    if mtEksOrdreType.Value = 2 then
      mtLinNySaldo.AsCurrency  := mtLinGlSaldo.AsCurrency - mtLinBGPBel.AsCurrency
    else
      mtLinNySaldo.AsCurrency  := mtLinGlSaldo.AsCurrency + mtLinBGPBel.AsCurrency;
    mtEksNyCtrSaldo.AsCurrency := mtLinNySaldo.AsCurrency;
    // Gem etiket
    if (mtLinLinieType.Value = 1) or (mtLinEtkLin.Value = 1) then begin
      // Kun receptlinier eller om ønsket
      meEtk2mtLin;
    end;

    //  try and create the new dosis label
//    if mtEksReceptStatus.AsInteger = 999 then begin
      BuildDosisEtiketLabel;
//    end;
    mtLinValideret.AsBoolean := True;
  end;
end;

procedure TTakserDosisForm.buGemClick(Sender: TObject);
var
  i :  integer;
  AP4line : boolean;
  ilen : integer;
begin
  with MainDm do begin
    C2LogAdd('F6:F6 pressed');
    if not buGem.Enabled then
      exit;
    c2logadd('F6:Check repeat prescription lines all complete');
    try
      IF mtRei.recordcount <> 0 then begin
        if not ChkBoxYesNo('Der er flere ordinationer på recepten. Ønske du at afslutter ?',False) then begin
          CloseCF6 := False;
          CloseSF6 := False;
          CloseF6 := False;
          exit;
        end;
      end;
    except
    end;
    if mtLin.State <> dsBrowse then
      mtLin.Post;
    // if the last line posted was not valid  then get out.....
    if not mtLinValideret.AsBoolean then
    begin
      ModalResult := mrCancel;
      ForceClose := True;
      exit;
    end;

    c2logadd('F6:check all lines have been validated');
    mtLin.First;
    while not mtLin.Eof do begin
      if mtLinVareNr.AsString = '' then begin
        ChkBoxOK('Varenr mangler. Luk ekspeditionen og ekspeder forfra.');
        EVare.SetFocus;
        exit;
      end;
      if  (mtLinBGPBel.AsCurrency = 0) and
          (mtLinIBPBel.AsCurrency = 0) and
          (ffPatKarEjCtrReg.AsBoolean = False) and
          (mtLinRegelSyg.AsInteger in [41..43]) then begin
        ChkBoxOK('CTR BGP mangler. Luk ekspeditionen og ekspeder forfra.');
        EVare.SetFocus;
        exit;
      end;
      if not mtLinValideret.AsBoolean then
        mtLin.Delete
      else
        mtLin.Next;
    end;
    AllHKlines := True;
    mtLin.First;
    while not mtLin.Eof do begin
      if mtLinLinieType.AsInteger <> 2 then begin
        AllHKlines := False;
        break;
      end;
      mtLin.Next;

    end;
    mtlin.Last;
    if (not StamForm.TakserDosisKortAuto) or (not DosisKortAutoExp) then
    begin
      if (stamform.Spoerg_YderNr) and ( not udlignOrdination) then
      begin
        if (mtEksEkspType.AsInteger = et_Recepter) and
            (mtEksEkspForm.AsInteger IN [1,2]) and (not AskYderNrQuestion) then
        begin
          AskYderNrQuestion := True;
          if not AllHKlines then
          begin
            if not ChkBoxYesNo('Er lægens ydernummer korrekt?',False) then
            begin
              eYderNr.Color    := clYellow;
              eYderNr.ReadOnly := False;
              eYderNr.TabStop  := True;
              eYderNr.SetFocus;
              exit;
            end;
          end;
        end;
      end;
    end;
    C2LogAdd('F6:Check laege cpr');
    if (not StamForm.TakserDosisKortAuto) or (not DosisKortAutoExp) then
    begin
      if (stamform.Spoerg_AutorisationsNr) and ( not udlignOrdination) then
      begin
        if StamForm.SpoergAutorisationsnrKorrekt then
        begin
          if (mtEksYderCprNr.AsString <> '') and (mtEksEkspForm.AsInteger <> 3) then
          begin
            if mtEksEkspType.AsInteger <> et_Dosispakning  then
            begin
              if not AllHKlines then begin
                if not AskYderCPrNrQuestion then
                begin
                  AskYderCPrNrQuestion :=True;
                  if not ChkBoxYesNo('Er lægens autorisationsnummer korrekt?',true) then
                  begin
                    eYderCprNr.Color    := clYellow;
                    eYderCprNr.ReadOnly := False;
                    eYderCprNr.TabStop  := True;
                    eYderCPRNr.SetFocus;
                    exit;
                  end;
                end;
              end;
            end;
          end;
        end;
        if (mtEksYderCprNr.AsString = '') and (mtEksKundeType.AsInteger = 1) then
        begin
          if not AllHKlines then
          begin
            if ChkBoxYesNo('Skal lægens autorisationsnummer indtastes?',true) then
            begin
              eYderCprNr.Color    := clYellow;
              eYderCprNr.ReadOnly := False;
              eYderCprNr.TabStop  := True;
              eYderCPRNr.SetFocus;
              exit;
            end;
          end;
        end;
      end;
    end;

    // if any lines are ap4 then there must be a cpr number in ydercprnr
    if (maindm.mtEksEkspForm.AsInteger <> 4) then
    begin
      AP4line := False;
      mtLin.First;
      while not mtLin.Eof do
      begin
        if mtLinUdLevType.AsString = 'AP4' then begin
          if mtLinOrdId.AsString = '' then
          begin
            AP4line := True;
            Break;
          end;
        end;
        mtLin.Next;
      end;
      if AP4line then begin
        if mtEksYderCprNr.AsString = '' then begin
          ChkBoxOK('Lægens cprnr skal registreres.');
          eYderCPRNr.SetFocus;
          exit;
        end;

        if length( mtEksYderCprNr.AsString ) <> 10 then begin
          eYderCPRNr.SetFocus;
          if not frmYesNo.NewYesNoBox('Lægens cprnr skal registreres.' +
           'Er du sikker på, at du vil registrere denne ekspedition med autorisationsnummeret?') then
            exit;
        end;
      end;
    end;
    // Check lægecpr
    if (mtEksEkspType.Value = et_Narkoleverance) or (mtEksYdCprChk.AsBoolean) then
    begin
      if Length(mtEksYderCprNr.AsString) = 10 then
      begin
        if TryStrToInt(copy(mtEksYderCprNr.AsString,1,1),i) then
        begin
          if i>=4 then
          begin
            ChkBoxOK('Fejl i Lægens cprnr');
            if eYderCPRNr.Enabled then
              EYderCprNr.SetFocus;
            exit;
          end;
        end;
      end;
      if mtEksYderCprNr.AsString <> '4000000999' then
      begin
        if not CheckCprNr (99, mtEksYderCprNr.AsString) then
        begin
          if (Length(mtEksYderCprNr.AsString) = 10) and (not maindm.DisableCPRModulusCheck) then
          begin
            eYderCprNr.SetFocus;
            ChkBoxOk ('Fejl i Lægens cprnr !');
            Exit; // Afbryd F6 og gå til cprnr felt
          end
          else
          begin
            if (Length(mtEksYderCprNr.AsString) <> 5 ) then begin
              ChkBoxOk ('Fejl i Lægens autorisationsnr !');
              eYderCprNr.SetFocus;
              Exit; // Afbryd F6 og gå til cprnr felt
            end;
          end;
        end;
      end;
    end;
    C2LogAdd('F6:check ydernr');
    // Check ydernr
    if not AllHKlines then begin

      if not CheckYderNr(mtEksKundeType.Value, mtEksYderNr.AsString) then begin
        eYderNr.SetFocus;
        ChkBoxOk ('Fejl i Lægens ydernr !');
        Exit; // Afbryd F6 og gå til ydernr felt
      end;
      c2logadd('F6 : check ydercprnr ' + mtEksYderCprNr.AsString);
      mtEksYderCprNr.AsString := caps(mtEksYderCprNr.AsString);
      ilen := length(trim(mtEksYderCprNr.AsString));
      if (mtEksYderCprNr.AsString <> '') and (mtEksKundeType.AsInteger in [1,2]) then begin
        c2logadd('length is ' + inttostr(ilen));
        if NOT (ilen in [5,10]) then begin
          ChkBoxOK('Fejl i Aut.Nr.');
          EYderCprNr.SetFocus;
          exit;
        end;
        if ilen = 5 then begin
          for I := 1 to 5 do begin
            if pos(copy(mtEksYderCprNr.AsString,i,1),'ABCDEFGHIJKLMNOPQRSTUVWXYZÅÆØ0123456789') =0 THEN BEGIN
              ChkBoxOK('Fejl i Aut.Nr.');
              EYderCprNr.SetFocus;
              exit;
            end;
          end;
        end;

        if ilen = 10 then begin
          if TryStrToInt(copy(mtEksYderCprNr.AsString,1,1),i) then begin
            if i>=4 then begin
              ChkBoxOK('Fejl i Lægens cprnr');
              if eYderCPRNr.Enabled then
                EYderCprNr.SetFocus;
              exit;
            end;
          end;
          if not DisableCPRModulusCheck then
          begin
            if not (CheckCprNr(99,trim(mtEksYderCprNr.AsString))) then begin
              ChkBoxOK('Fejl i Aut.Nr.');
              EYderCprNr.SetFocus;
              exit;
            end;
          end;
        end;

      end;


    end;


    if (EHOrdre) and (EHDibs) then begin
      if Trim(mtEksDebitorNr.AsString) = '' then begin
        eDebitorNr.SetFocus;
        ChkBoxOK('Ehandel er betalt med DIBS,' +#10#13 +
         'så derfor skal der være et kontonummer af typen Bud' + #10#13 +
         'for at få en pakkeseddel til at slå på kassen.');
        exit;

      end;
    end;

    if (EHOrdre) and not (EHDibs) then begin
      if Trim(mtEksDebitorNr.AsString) = '' then begin
        eDebitorNr.SetFocus;
        if ChkBoxYesNo('Ehandel. Skal der kontonummer på?' + #10#13 +
                      'Uden konto, vil kunden ikke få sendt besked.',True) then
          exit;
      end;
    end;
    if not AllHKlines then begin
      if stamform.SpoergOmGemYdernr then begin
        if (trim(mtEksYderNr.AsString) <> trim(ffPatKarYderNr.AsString)) or
         (trim(mtEksYderCprNr.AsString) <> trim(ffPatKarYderCprNr.AsString)) then begin
          if frmYesNo.NewYesNoBox('Skal Ydernr/Aut.nr gemmes på kundens stamoplysninger ?') then begin
            // Gemmes på kunde
            ffPatKar.Edit;
            ffPatKarYderNr.AsString:= Trim(mtEksYderNr.AsString);
            ffPatKarYderCprNr.AsString:= Trim(mtEksYderCprNr.AsString);
            ffPatKar.Post;
          end;
        end;
      end;
    end;

    C2LogAdd('F6:check debitor');
    // Check Debitor
    if Trim (mtEksDebitorNr.AsString) <> '' then begin
      // Findes debitor
      if not ffDebKar.FindKey([mtEksDebitorNr.AsString]) then begin
        eDebitorNr.SetFocus;
        ChkBoxOk ('Debitorkonto findes ikke i kartotek !');
        Exit; // Afbryd F6 og gå til debitor felt
      end;
      if stamform.SpoergOmGemKontonr then begin
        if trim(mtEksDebitorNr.AsString) <> trim(ffPatKarDebitorNr.AsString) then begin
          if frmYesNo.NewYesNoBox('Skal kontonr gemmes på kundens stamoplysninger ?') then begin
            // Gemmes på kunde
            ffPatKar.Edit;
            ffPatKarDebitorNr.AsString:= Trim(mtEksDebitorNr.AsString);
            ffPatKar.Post;
          end;
        end;
      end;

      if (EHOrdre) and (EHDibs) then begin
        if ffDebKarLevForm.AsInteger in [4,5,6] then begin
          eDebitorNr.SelectAll;
          eDebitorNr.SetFocus;
          ChkBoxOK('Konto er til et udsalg. Brug ehandelskonto af typen BUD for at få DIBS betaling.');
          exit;
        end;

      end;

    end;
    C2LogAdd('F6:Check Eksp levering');
    // Check Levering
    if Trim (mtEksLevNr.AsString) <> '' then begin
      // Findes levering
      if not ffDebKar.FindKey([mtEksLevNr.AsString]) then begin
        eLevNr.SetFocus;
        ChkBoxOk ('Leveringskonto findes ikke i kartotek !');
        Exit; // Afbryd F6 og gå til debitor felt
      end;
      C2LogAdd('F6:check patients levnr');
      // Check patient
      if ffPatkarLevNr.AsString = '' then begin
        if frmYesNo.NewYesNoBox('Leveringskonto findes ikke på kunde, oprettes ?') then begin
          // Gemmes på kunde
          ffPatKar.Edit;
          ffPatKarLevNr.AsString:= Trim(mtEksLevNr.AsString);
          ffPatKar.Post;
        end;
      end;
    end;

    if ( mtEksTurNr.AsInteger < 0 ) or ( mtEksTurNr.AsInteger > 9 ) then begin
      eTurNr.SetFocus;
      ChkBoxOK('Tur-nummer kan ikke være større end 9');
      exit;
    end;

    if mtEksEkspType.AsInteger = et_Dosispakning then
      CloseSF6 := True;
    if (not CloseSF6) or (not CloseCF6) then
      CloseF6   := True;

    if (StamForm.TakserDosisKortAuto)  and (DosisKortAutoExp) then
      if not StamForm.Dosis_Auto_Udbringningsgebyr then
        mtEksUdbrGebyr.AsCurrency := 0.0;

    C2LogAdd('F6: about to set modalresult');

    ModalResult := mrOK;
  end;

end;

procedure TTakserDosisForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  SearchString :string;
begin
  with MainDm do begin
    try
      if Key = VK_F6 then begin
        if ActiveControl.Name = 'buVidere' then
          exit;
        if not buGem.Enabled then
          exit;
        Key := 0;
        buVidere.SetFocus;
        PostMessage(buVidere.Handle,wm_KeyDown, VK_F6, 0);
        PostMessage(buVidere.Handle,WM_KEYUP, VK_F6, 0);
        exit;
      end;

      if Shift = [] then begin
        case Key of
          VK_F8 : begin
            Key := 0;
            if mtLinLinieNr.Value > 1 then begin
              if mtLinValideret.AsBoolean then begin
                if ChkBoxYesNo ('Skal linie slettes ?', TRUE) then begin
                  // Linie slettes
                  if mtLin.State = dsBrowse then
                    mtLin.Delete
                  else
                    mtLin.Cancel;
                  mtLin.Edit;
                  mtLin2meEtk;
                  mtEksAntLin.Value          := mtEksAntLin.Value - 1;
                  mtEksNyCtrSaldo.AsCurrency := mtLinNySaldo.AsCurrency;
                  buVidere.Tag               := 2;
                  buVidere.SetFocus;
                end;
              end else begin
                // Linie slettes ukritisk
                if mtLin.State = dsBrowse then
                  mtLin.Delete
                else
                  mtLin.Cancel;
                mtLin.Edit;
                mtLin2meEtk;
                mtEksAntLin.Value := mtEksAntLin.Value - 1;
                buVidere.Tag      := 2;
                buVidere.SetFocus;
              end;
            end else begin
              if mtLinReitereret.AsBoolean then begin
                if ActiveControl.Name <> 'buVidere' then begin
                  // Slettes ukritisk ved reitereret
                  try
                    mtLin.Cancel;
                    mtLin.Delete;
                  except
                  end;
                  mtEksAntLin.Value := 0;
                  buVidere.SetFocus;
                end else
                  ChkBoxOK ('Kan IKKE slette ordination i dette felt !');
              end else begin
                if ChkBoxYesNo ('Kan IKKE slette sidste linie, annuller ?', TRUE) then
                  buLuk.Click;
              end;
            end;
          end;
          VK_UP : begin
            if ActiveControl.Name = 'EVare' then begin
              if mtLinLinieNr.Value > 1 then begin
                Key := 0;
              end else begin
                Beep;
                Key := 0;
              end;
            end;
          end;
          VK_DOWN : begin
            if ActiveControl.Name = 'EVare' then begin
              if mtLinLinieNr.Value < mtLin.RecordCount then begin
                Key := 0;
              end else begin
                Beep;
                Key := 0;
              end;
            end;
          end;
        end;
        exit;
      end;
      if Shift = [ssAlt] then begin
        if Key = VK_DOWN then begin
          if ActiveControl.Name = 'eYderNr' then begin
            YderList := True;
            YdLst;
            Key := 0;
          end else
          if ActiveControl.Name = 'eYderCprNr' then begin
            YderList := True;
            YdCprLst;
            Key := 0;
          end else
          if ActiveControl.Name = 'eDebitorNr' then begin
          end else begin
          end;
        end;
        if UpCase (Chr (Key)) = 'R' then begin
          if ChkBoxYesNo('Ønsker du returekspedition?',False) then begin
            mtEksOrdreType.Value := 2;
            FakTypeExit (Self);
          end;
          Key := 0;
        end;
        if UpCase (Chr (Key)) = 'S' then begin
          mtEksOrdreType.Value := 1;
          FakTypeExit (Self);
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
        if not SubstOver(nxdb,mtEksLager.Value,SearchString) then
          exit;
        if (SubstForm.VareNrSub = SubstForm.VareNrOrg) then
        begin
          EVare.Text             := Trim(SubstForm.VareNrOrg);
          mtLinVareNr   .AsString:= EVare.Text;
          mtLinSubVareNr.AsString:= EVare.Text;
        end
        else
        begin
          mtLinVareNr   .AsString:= Trim(SubstForm.VareNrOrg);
          mtLinSubVareNr.AsString:= Trim(SubstForm.VareNrOrg);
          EVare.Text             := mtLinSubVareNr.AsString;
        end;
        IF SubstForm.VareNrAntPkn <> 0 then
        begin
          mtLinAntal.AsInteger := SubstForm.VareNrAntPkn;
          if OriginalAntal <> 0 then
            mtLinAntal.AsInteger := OriginalAntal *
              SubstForm.VareNrAntPkn;
        end;
      end;
    finally
//      Key := 0;
    end;
  end;
end;

procedure TTakserDosisForm.FakTypeExit(Sender: TObject);
begin
  with MainDm do begin
    if mtEksOrdreType.Value = 1 then begin
      laSalgRetur.Caption  := '&Retur/Salg';
      lcFakType.Color      := clWindow;
      lcFakType.Font.Color := clWindowText;
    end else begin
      laSalgRetur.Caption  := '&Salg/Retur';
      lcFakType.Color      := clRed;
      lcFakType.Font.Color := clYellow;
    end;
  end;
end;


procedure DanDispFormer(Form: String; var Ental, Flertal: String);
var
  P, Q: Word;
  E, F: String;
begin
  E:= Form;
  F:= E;
  P:= Pos('/', E);
  Q:= Pos('*', E);
  if P > 0 then begin
    // Flertal
    Delete(F, P, Q - P + 1);
    // Ental
    Delete(E, Q, Length(E) - Q + 1);
    Delete(E, P, 1)
  end else begin
    // Flertal
    Delete(F, Q, 1);
    Q:= Pos('*', F);
    if Q > 0 then
      Q:= Pos('*', F);
    // Ental
    P:= Pos(' ', E);
    if P > Q then
      Delete(E, Q, P - Q)
    else
      Delete(E, Q, Length(E) - Q + 1);
    Q:= Pos('*', E);
    if Q > 0 then
      Delete(E, Q, Length(E) - Q + 1);
  end;
  // Returner
  Ental  := E;
  Flertal:= F;
end;

procedure TTakserDosisForm.FormKeyPress(Sender: TObject; var Key: Char);
var
  Bel   : integer;
  ICnt  : Word;
  Ok    : Boolean;
  WNr   : Int64;
  GAPO,
  WrkS,
  SNr   : String;
  sltmpSort : TStringList;
  i : integer;
  LaDisp : integer;
  VareForSale : boolean;
  TestDate : tdateTime;
  klausCaption : boolean;
  substCaption : boolean;
  procedure TabEnter;
  begin
    SelectNext (ActiveControl, TRUE, TRUE);
    Key := #0;
  end;

  procedure Process_Substitution;
  var
    SearchString : string;
  begin
    with MainDm do
    begin
      SearchString := SNr;
      if not SubstOver(nxdb,mtEksLager.Value,SearchString) then
        exit;
//               if (TakstForm.VareNrSub = ''                 ) or
//                  (TakstForm.VareNrSub = TakstForm.VareNrOrg) then begin
//                 SNr := Trim (TakstForm.VareNrOrg);
      if (SubstForm.VareNrSub = SubstForm.VareNrOrg) then
      begin
        SNr := Trim (SubstForm.VareNrOrg);
        mtLinVareNr.AsString    := SNr;
        mtLinSubVareNr.AsString := SNr;
        exit;
      end;
//                 mtLinSubVareNr.AsString := Trim (TakstForm.VareNrSub);
//                 mtLinVareNr.AsString    := Trim (TakstForm.VareNrOrg);
      mtLinSubVareNr.AsString := Trim(SubstForm.VareNrSub);
      mtLinVareNr.AsString    := Trim(SubstForm.VareNrOrg);
      SNr := mtLinSubVareNr.AsString;
      IF SubstForm.VareNrAntPkn <> 0 then
      begin
        mtLinAntal.AsInteger := SubstForm.VareNrAntPkn;
        if OriginalAntal <> 0 then
          mtLinAntal.AsInteger := OriginalAntal *
            SubstForm.VareNrAntPkn;

        EAntal.Text := IntToStr(mtLinAntal.AsInteger);
      end;

    end;
  end;

begin
  with MainDm do begin
    if Key <> #13 then
      exit;


    IF ActiveControl.Name = 'lcbEkspForm' then begin
      buVidere.SetFocus;
      Key := #0;
      exit;
    end;

    if ActiveControl.Name ='eYderCPRNr' then begin

      ffYdLst.IndexName := 'YderNrOrden';


      if ffYdLst.FindKey([mtEksYderNr.AsString,eYderCPRNr.text]) then begin
        mtEksYderNavn.AsString := ffYdLstNavn.AsString;
//        mtEks.Post;
//        mtEks.ApplyUpdates(-1);
//        mtEks.Refresh;
//        mtEks.Edit;
      end;
      TabEnter;
      exit;
    end;


    if ActiveControl.Name = 'eYderNr' then begin
      Process_eYdenr;
      TabEnter;
      exit;
    end;

    if ActiveControl.Name = 'eNarkoNr' then begin
      TabEnter;
      exit;
    end;

    if ActiveControl.Name = 'EVare' then begin
      klausCaption := pos(',KLAUS',paInfo.Caption) <> 0;
      substCaption := pos(',  -S',paInfo.Caption) <> 0;
      // Hent Vareoversigt
//      FillChar (VareRec, SizeOf (VareRec), 0);
      // Ikke reitereret
      if not mtLinReitereret.AsBoolean then begin
        mtLinAntal.Value         := 0;
        mtLinDosering1.AsString  := '';
        mtLinDosering2.AsString  := '';
        mtLinIndikation.AsString := '';
        mtLinFolgeTxt.AsString   := '';
        meEtiketter.Clear;
        if ffPatKarCtrType.AsInteger in [1,11] then begin
  //          ChkBoxOK('kundenr is ' + ffPatKarKundeNr.AsString);

          meEtiketter.Lines.Add (AnsiUpperCase (BytNavn (ffPatKarNavn.AsString)) +
                    ' ' + calcage(ffPatKarKundeNr.AsString,ffPatKarFoedDato.asstring));
        end else
          meEtiketter.Lines.Add (AnsiUpperCase (BytNavn (ffPatKarNavn.AsString)));
      end;
      mtLinVareNr.AsString     := '';
      mtLinSubVareNr.AsString  := '';
      if (not StamForm.TakserDosisKortAuto) or (not DosisKortAutoExp) then
        mtLinSubstValg.Value     := 9; // = Ej valgt
      if (ffPatKarEjSubstitution.AsBoolean) or
         (Recepturplads = 'DYR') or
         (mtLinLinieType.Value <> 1)        then
        mtLinSubstValg.Value   := 0;
      mtLinBGPBel.AsCurrency := 0;
      mtLinIBTBel.AsCurrency := 0;
      mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency;
      SNr:= Trim (EVare.Text);
      if (copy(caps(snr),1,1) = 'X') or  (not TryStrToInt64(Snr,Wnr)) then begin
        // Ikke Nr, kald søgning
        if SNr <> '' then begin
          TakserDosisForm.Update;
// cjs         if mtEksEkspType.Value = 7 then begin
//            // Dosispakning
//            mtLinVareNr.AsString    := Trim (SNr);
//            mtLinSubVareNr.AsString := Trim (SNr);
// cjs         end else begin
            // Normale pakninger
//TAKST
//             if TakstOver (SNr) then begin
          if not SkipReservation then
            Process_Substitution;
          if SkipReservation then
            mtLinVareNr.AsString := ReservationOrigVarenr;
// cjs          end;
        end;
      end else begin

        Ok := False;
        if SNr <> '' then begin
          if length(SNr) = 12 then
            SNr := '0' + SNr;
          try
            ffLagKar.IndexName := 'EanKodeOrden';
            Ok:= ffLagKar.FindKey([mtEksLager.AsInteger, SNr]);
            if ok then begin
              mtLinVareNr.AsString    := trim(ffLagKarVareNr.AsString);
              mtLinSubVareNr.AsString := trim(ffLagKarVareNr.AsString);
              snr := mtLinVareNr.AsString;
            end;
          finally
            ffLagKar.IndexName := 'NrOrden';
          end;
        end;
        if Length(SNr) = 13 then begin
          // Stregkode not ok so see if varenr in there must be cNTIN13Prefix in first 6 characters
          if not Ok then
          begin
            if copy(SNr,1,6) = SNTIN13Prefix then
              SNr := copy(SNr, 7, 6);
          end;
        end;
        if not ok then begin
          // Varenr
          mtLinVareNr.AsString    := SNr;
          mtLinSubVareNr.AsString := SNr;
          Ok:= ffLagKar.FindKey([mtEksLager.AsInteger, SNr]);
        end;
        if Ok then begin
          GAPO:= '';
          if ffLagKarSubGrp.AsInteger > 0 then
            GAPO:= 'G';
          MainDm.NxLagerSubstListe.IndexName := 'NrOrden';
          if MainDm.NxLagerSubstListe.findkey([Trim(Snr)]) then
            GAPO := 'G';
          if GAPO <> '' then begin
            if not ffLagKarSubst.AsBoolean then
              GAPO:= '';
            TakserDosisForm.Update;
            if mtEksEkspType.Value = et_Dosispakning then
            begin
              // Dosispakning
              mtLinVareNr.AsString    := Trim (SNr);
              mtLinSubVareNr.AsString := Trim (SNr);
            end
            else
            begin
              // Normale pakninger
//TAKST
//              if TakstOver (SNr) then begin
              if not SkipReservation then
                Process_Substitution;
              if SkipReservation then
                mtLinVareNr.AsString := ReservationOrigVarenr;
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
      ffLagKar.IndexName := 'NrOrden';
      c2logadd('10: Stock lager is ' +  inttostr(StamForm.StockLager));

      if not ffLagKar.FindKey([StamForm.StockLager, mtLinSubVareNr.AsString]) then begin
        // Vare findes ikke og skal ikke oprettes
        Beep;
        ChkBoxOk('Vare findes IKKE i lagerkartoteket');
        paLager       .Caption := '';
        paInfo        .Caption := ' ' + mtLinSubVareNr.AsString + ' findes IKKE på lager';
        if save_caption <> '' then
          paInfo.Caption := paInfo.Caption + ' Lægens tekst:' + save_caption;
        mtLinVareNr   .AsString:= '';
        mtLinSubVareNr.AsString:= '';
        exit;
      end;
      TestDate := EncodeDate(2011,03,01);
      if Date >= TestDate then begin
        if copy(ffLagKarVareNr.AsString,1,2) = '69' then begin
          if ffLagKarVareType.AsInteger in [1,4,5,6,7] then begin
            if ffLagKarIndbNr.AsString = '' then begin
              ChkBoxOK('Før denne vare kan ekspederes, skal der tilknyttes et LMS henvisningsvarenummer i Lagerkartoteket.');
              exit;
            end;

          end;

        end;
      end;

      // check kundetype. if ingen or handkøbsudsalg then warn the user on certain
      // product types
      if maindm.ffPatKarKundeType.AsInteger in [0,15] then begin
        VareForSale := False;
        if  (maindm.ffLagKarUdlevType.AsString = 'HF') or
            (maindm.ffLagKarUdlevType.AsString = 'HX') or
            (maindm.ffLagKarUdlevType.AsString = 'HV') then
              VareForSale := True;

        if (maindm.ffLagKarVareType.AsInteger = 5) and (maindm.ffPatKarKundeType.AsInteger=0) then
          VareForSale := true;
       if (maindm.ffLagKarVareType.AsInteger = 5) and (maindm.ffPatKarKundeType.AsInteger=15) and (MainDm.ffLagKarHaType.AsString <>'') then
           VareForSale := true;

        if maindm.ffLagKarVareType.AsInteger in [2,8,9] then
          VareForSale := True;

        if not VareForSale then begin
            if not ChkBoxYesNo('Varen kan normalt ikke sælges til denne kundetype.' + #13#10 +
              'Vælg Ja, hvis den alligevel ønskes.',false) then begin
              paLager       .Caption := '';
              paInfo        .Caption := ' ' + mtLinSubVareNr.AsString + ' kan normalt ikke sælges til denne kundetype.';
              mtLinVareNr   .AsString:= '';
              mtLinSubVareNr.AsString:= '';
              exit;
            end;
        end;
      end;

      // Vis vare
      if (ffLagKarAntal.AsInteger < mtLinAntal.AsInteger) or ( ffLagKarAntal.AsInteger <= 0) then begin
        paLager     .Color:= clRed;
        paLager.Font.Color:= clWhite;
        if StamForm.StockLager <> StamForm.FLagerNr then begin
          paLager     .Color:= clAqua;
          paLager.Font.Color:= clBlack;
        end;
        paLager.Caption:= ' ' + mtLinSubVareNr.AsString + ' lager ' + ffLagKarAntal.AsString;
        ffLagHis.SetRange([StamForm.StockLager, mtLinSubVareNr.AsString, 2], [StamForm.StockLager, mtLinSubVareNr.AsString, 0]);
        try
          if ffLagHis.recordcount <>  0 then begin
            paLager     .Color:= clYellow;
            paLager.Font.Color:= clWindowText;
          if StamForm.StockLager <> StamForm.FLagerNr then begin
              paLager     .Color:= clAqua;
              paLager.Font.Color:= clBlack;
            end;
            ffLagHis.First;
            LaDisp := 0;
            while not ffLagHis.Eof do begin
              if ffLagHisOrdreStatus.AsInteger = 2 then
                LaDisp:= LaDisp + ffLagHisLeveret  .AsInteger +
                                  ffLagHisRestordre.AsInteger
              else
                LaDisp:= LaDisp + ffLagHisAntal    .AsInteger;
              ffLagHis.Next;
            end;
            paLager.Caption:= ' ' + mtLinSubVareNr.AsString + ' - I OR : ' +
              IntToStr(LaDisp);

          end;
        finally
          ffLagHis.CancelRange;
        end;

      end else begin
        paLager     .Color:= clBtnFace;
        paLager.Font.Color:= clWindowText;
        if StamForm.StockLager <> StamForm.FLagerNr then begin
          paLager     .Color:= clAqua;
          paLager.Font.Color:= clBlack;
        end;
        paLager.Caption:= ' ' + mtLinSubVareNr.AsString + ' lager ' + ffLagKarAntal.AsString;
      end;
      try
        if ffLagKarRestOrdre.AsInteger > 0 then
          paLager.Caption := paLager.Caption + ' RO';
      except
        on e: exception do ChkBoxOK(e.Message);
      end;
      // Slettemærket ikke ved dosis
      if (ffLagKarAfmDato.AsString <> '') and (mtEksEkspType.AsInteger <> et_Dosispakning) then
      begin
        Beep;
        if ffLagKarAntal.AsInteger > 0 then
          ChkBoxOk('Vare er afregistreret i taksten, ' + ffLagKarAntal.AsString + ' på lager')
        else
          ChkBoxOk('Vare er afregistreret i taksten, ingen på lager');
        paInfo        .Caption := ' Vare er afregistreret i taksten';
        mtLinVareNr   .AsString:= '';
        mtLinSubVareNr.AsString:= '';
        exit;
      end;
        // Ikke afregistreret
//          Ok := ffLmsTak.FindKey ([mtLinSubVareNr.AsString]);
//          if Ok then begin
      if (ffLagKarVareType.AsInteger in [1, 3..7]) and (ffLagKarUdlevType.AsString = '') then begin
        Beep;
        ChkBoxOk('Vare mangler udleveringsbestemmelse, kan ikke takseres');
        paInfo        .Caption := ' Vare mangler udleveringsbestemmelse';
        mtLinVareNr   .AsString:= '';
        mtLinSubVareNr.AsString:= '';
        exit;
      end;
      // Check midlertidigt udgået
      if mtEksEkspType.AsInteger <> et_Dosispakning then
      begin
        if ffLagKarVareType.AsInteger in [1, 3..7] then
        begin
          if ffLagKarSletDato.AsString <> '' then
          begin
            Beep;
            if ffLagKarAntal.AsInteger > 0 then
              ChkBoxOk('Vare er midlertidigt udgået, ' + ffLagKarAntal.AsString + ' på lager')
            else
              ChkBoxOk('Vare er midlertidigt udgået, ingen på lager');
          end;
        end;
      end;
      // Udlevering OK
      mtLinNarkoType.AsInteger:= 0;
      if ffLagKarVareType.AsInteger = 4 then
      begin
        // Narko, ikke narkocheck ved dyr og dyrlæger
        if not (mtEksKundeType.AsInteger in [3, 13, 14]) then
        begin
          if (mtEksEkspForm.AsInteger <> 4) and (mtEksEkspType.AsInteger <> et_Narkoleverance) then
          begin
            mtEksYdCprChk.AsBoolean:= mtEksEkspType.AsInteger <> et_Dyr;
          end;
          if mtEksYdCprChk.AsBoolean then
          begin
            eYderCprNr.Color   := clYellow;
            eYderCprNr.ReadOnly:= False;
            eYderCprNr.TabStop := True;
          end;
          mtLinNarkoType.AsInteger:= 1;
        end;
      end;
      if not ffLagKar.FindKey([mtekslager.AsInteger, mtLinSubVareNr.AsString]) then begin
        ChkBoxOK('Fejl to move to correct stock inlagerkartotek. Kontakt Cito !' );
        exit;
      end;
      GAPO:= '';
      if ffLagKarSubst.AsBoolean then
        GAPO:= ' [G]';
      mtLinLokation1.AsInteger:= ffLagKarLokation1.AsInteger;
      mtLinLokation2.AsInteger:= ffLagKarLokation2.AsInteger;
      mtLinTekst    .AsString := Trim(ffLagKarNavn.AsString);
      mtLinForm     .AsString := Trim(ffLagKarForm.AsString);
      mtLinStyrke   .AsString := Trim(ffLagKarStyrke.AsString);
      mtLinPakning  .AsString := Trim(ffLagKarPakning.AsString);
      mtLinSSKode   .AsString := ffLagKarSSKode.AsString;
      mtLinATCType  .AsString := ffLagKarATCType.AsString;
      mtLinATCKode  .AsString := ffLagKarATCKode.AsString;
      mtLinPAKode   .AsString := ffLagKarPAKode.AsString;
      mtLinVareType .AsInteger:= ffLagKarVareType.AsInteger;
      mtLinUdlevType.AsString := Trim(ffLagKarUdlevType.AsString);
      mtLinHaType   .AsString := Trim(ffLagKarHAType.AsString);
      if mtLinVareType.AsInteger = 2 then
        mtLinLinieType.AsInteger := 2;
      if (mtLinVareType.AsInteger = 5) and (mtLinHaType.AsString <> '')  then
        mtLinLinieType.AsInteger := 2;


      // if we got an ordid then switch line  type to recept

      if mtLinOrdId.AsString <> '' then
        mtLinLinieType.AsInteger := 1;
      lcbLinTyp.ItemIndex:= mtLinLinieType.Value - 1;
      // Evt. 69xxxx vare
      if (not StamForm.TakserDosisKortAuto) or (not DosisKortAutoExp) then begin
        if (copy (mtLinSubVareNr.AsString, 1, 2) = '69') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '222222') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '555555') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '666666') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '685800') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '777777') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '888888') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '999999') then begin
          WrkS:= mtLinTekst.AsString;
          if TastTekst('Tast evt. anden varetekst ?', WrkS) then
            mtLinTekst.AsString:= WrkS;
        end;
      end;
      // Check udlevering
      if mtLinUdlevType.AsString = '' then begin
        if ffLagKarVareType.AsInteger = 2 then
          mtLinUdlevType.AsString:= 'HF';
      end;
      // Dosisvare
      if ffLagKarDoSalgsPris.AsCurrency = 0 then begin
        // Ingen pris måske slettet
        Bel:= 0;
        if TastHeltal('Ingen dosispris, tast enhedspris i ører ?', Bel) then begin
          // Omdan til kr og ører
          mtLinPris  .AsCurrency:= Bel / 100;
        end;
        mtLinKostPris.AsCurrency:= 0;
        mtLinAndel   .AsCurrency:= mtLinPris          .AsCurrency;
        mtLinESP     .AsCurrency:= mtLinPris          .AsCurrency;
        mtLinBGP     .AsCurrency:= mtLinPris          .AsCurrency;
      end else begin
        // Normal dosisvare
        // fix currency to 2 decimal places.......
        mtLinKostPris.AsCurrency := SimpleRoundTo(ffLagKarDoKostPris.AsCurrency,-2);
        mtLinPris.AsCurrency := SimpleRoundTo(ffLagKarDoSalgsPris.AsCurrency,-2);
        mtLinAndel.AsCurrency := SimpleRoundTo(ffLagKarDoSalgsPris.AsCurrency,-2);
        mtLinESP.AsCurrency := SimpleRoundTo(ffLagKarDoSalgsPris.AsCurrency,-2);
        mtLinBGP.AsCurrency := SimpleRoundTo(ffLagKarDoBGP.AsCurrency,-2);
        if mtLinBGP.AsCurrency = 0 then
          mtLinBGP.AsCurrency := SimpleRoundTo(ffLagKarDoSalgsPris.AsCurrency,-2);
      end;
      mtLinSaveBGP.AsCurrency := mtLinBGP.AsCurrency;
      mtLinSaveESP.AsCurrency := mtLinESP.AsCurrency;
      // Dispenseringsform for dosering
      FrmEntal  := '';
      FrmFlertal:= '';
      FrmTekst  := '';
      if cdDspFrm.FindKey([mtLinSubVareNr.AsString]) then begin
        DanDispFormer(cdDspFrmDispForm.AsString, FrmEntal, FrmFlertal);
        // Edifact følgetekst
//        if mtEksReceptStatus.Value = 2 then begin
//          // Følgetekst fra dispenseringsform
//          if FrmTekst <> '' then begin
//            meEtiketter.Lines.Add(FrmTekst);
//            mtLinFolgeTxt.AsString:= FrmTekst;
//          end;
//        end;
      end;


      // new code to fill the indikation box

      sltmpsort := TStringList.Create;
      try
        sltmpSort.Clear;
        cbIndikation.clear;
        ICnt := 0;
        cdDrgInd.IndexName := 'IdOrden';
        c2logadd('cbindikation ' + ffLagKarVareNr.AsString + ' ' + ffLagKarDrugId.AsString);
        if ffLagKarVareNr.AsString <> mtLinSubVareNr.AsString then begin
          C2LogAdd('Current varenr in lagerkarkartotek does not match line subvarenr');
          c2logadd('line subvarenr is ' + mtLinSubVareNr.AsString +
              ' lagerkartotek points to ' + ffLagKarVareNr.AsString);
          ChkBoxOK('Det ser ud til, at der er en fejl i indikationsteksten.' +#10#13+
               'Luk ekspeditionen og start forfra.' +#10#13+
               'Kontakt CITO vedrørende problemet.');
          exit;
        end;
        cdDrgInd.SetRange([ffLagKarDrugId.AsString],[ffLagKarDrugId.AsString]);
        try
          if cdDrgInd.RecordCount > 0 then begin
            cdDrgInd.First;
            while not cdDrgInd.Eof do begin
              cdIndTxt.IndexName := 'NrOrden';

              if cdIndTxt.FindKey([cdDrgIndNr.AsString]) then begin
                sltmpSort.Add(cdIndTxtTekst.AsString);
              end;

              cdDrgInd.Next;
            end;
            sltmpSort.Sort;
            for i := 0 to sltmpSort.Count - 1 do begin
                cbIndikation.Items.Add(sltmpSort.Strings[i]);
                Inc(ICnt);
            end;
          end;

        finally
          cdDrgInd.CancelRange;
          cbIndikation.DropDownCount := ICnt;
        end;



        // code to fill the cbDoseringsbox
        cbDosTekst.clear;
        sltmpSort.Clear;
        ICnt := 0;
        cdDrgDos.IndexName := 'IdOrden';
        cdDrgDos.SetRange([ffLagKarDrugId.AsString],[ffLagKarDrugId.AsString]);
        try
          if cdDrgDos.RecordCount > 0 then begin
            cdDrgDos.First;
            while not cdDrgDos.Eof do begin
              cdDosTxt.IndexName := 'NrOrden';

              if cdDosTxt.FindKey([cdDrgDosNr.AsString]) then begin
                sltmpSort.Add(cdDosTxtTekst.AsString);
              end;

              cdDrgDos.Next;
            end;
            sltmpSort.Sort;
            for i := 0 to sltmpSort.Count - 1 do begin
                cbDosTekst.Items.Add(sltmpSort.Strings[i]);
                Inc(ICnt);
            end;
          end;

        finally
          cdDrgDos.CancelRange;
          cbDosTekst.DropDownCount := ICnt;
        end;

      finally
        sltmpSort.Free;
      end;
      eVare .Text   := ffLagKarVareNr.AsString;
      if (mtLinUdLevType.AsString = 'NBS') or (mtLinUdLevType.AsString = 'BEGR') then begin
        paInfo.Color := clYellow;
        paInfo.Refresh;
        if StamForm.SpoergYdernrNBS then
          ChkBoxOK('Udlevering NBS eller Begr' + #10#13 +
          'Er du sikker på, at denne vare skal sælges? ' + #10#13 +
                    'Husk at se efter om ydernr er korrekt!');

      end else
        paInfo.Color := clBtnFace;
      paInfo.Caption:= ' ' +
        mtLinTekst.AsString     + ' ' +
        mtLinForm.AsString      + ' ' +
        mtLinStyrke.AsString    + ' ' +
        mtLinPakning.AsString   + ' udl. ' +
        mtLinUdlevType.AsString + ' ' +
        mtLinHaType.AsString    + GAPO;

      if mtEksEkspType.Value = et_Dosispakning then
        paInfo.Caption:= paInfo.Caption + ' DOSISENHED';
      if klausCaption then
        paInfo.Caption:= paInfo.Caption + ',KLAUS';
      if substCaption then
        paInfo.Caption:= paInfo.Caption + ',  S';
      TabEnter;
{ cjs
      if mtEksReceptStatus.AsInteger = 999 then begin
        EAntal.SetFocus;
        PostMessage(EAntal.Handle,WM_KEYDOWN,VK_RETURN,0);
        PostMessage(EAntal.Handle,WM_KEYUP,VK_RETURN,0);
      end;

}

      exit;
    end;

    if ActiveControl.Name = 'EAntal' then begin
      process_Eantal;
      exit;
    end;

    if ActiveControl.Name = 'EMax' then begin
      if mtLinUdlevMax.Value > 0 then
        if mtLinUdlevNr.Value > mtLinUdlevMax.Value then
          ChkBoxOk ('Udleveringsnr er større end Max. udleveringer');
      TabEnter;
      exit;
    end;


    if ActiveControl.Name = 'EUdlev' then
    begin
      if (mtLinUdlevNr.Value mod 10) = (mtLinUdlevNr.Value div 10) then
        ChkBoxOk ('Muligvis dobbeltindtastning af udleveringsnr');
      // Ikke reitereret eller dosispakning
      if (not mtLinReitereret.AsBoolean) and
         (mtEksEkspType.Value <> et_Dosispakning)      then
        TabEnter
      else
      begin
        buVidere.Tag := 2;
        buVidere.SetFocus;
      end;
      exit;
    end;

    if ActiveControl.Name = 'cbDosTekst' then begin
      process_cbDosTekst;
      TabEnter;
      exit;
    end;

    if ActiveControl.Name = 'EDos2' then begin
      process_EDos2;
      TabEnter;
      exit;
    end;


    if ActiveControl.Name = 'cbIndikation' then begin
      Process_cbIndikation;
      exit;
    end;

    if (not (ActiveControl is TDBGrid))     and
       (not (ActiveControl is TDBMemo))     and
       (not (ActiveControl is TMemo))       and
       (not (ActiveControl is TRichEdit))   and
       (not (ActiveControl is TDBRichEdit)) then begin
      if (ActiveControl is TDBLookupComboBox) then begin
        if not (ActiveControl as TDBLookupComboBox).ListVisible then
          TabEnter;
          exit;
      end;
      if (ActiveControl is TDBComboBox) then begin
        if not (ActiveControl as TDBComboBox).DroppedDown then
          TabEnter;
        exit;
      end;
      TabEnter;
    end;

  end;
end;

procedure TTakserDosisForm.cbIndikationEnter(Sender: TObject);
begin
  with MainDm do begin
    if cbIndikation.Text <> '' then
      exit;
    if C2StrPrm(MainDm.C2UserName, 'Recepturindikation', '') = 'Text2' then
      exit;
    if cbIndikation.DropDownCount > 0 then begin
      cbIndikation.ItemIndex  := 0;
      cbIndikation.Font.Size := 8;
      cbIndikation.DroppedDown:= True;
    end;
  end;
end;

procedure TTakserDosisForm.DropDown(Sender: TObject);
begin
  with MainDm do begin
    if (Sender is TDbLookupComboBox) then begin
      (Sender as TDbLookupComboBox).DropDownRows :=
      (Sender as TDbLookupComboBox).ListSource.DataSet.RecordCount;
    end;
    if (Sender is TDbComboBox) then begin
      (Sender as TDbComboBox).DropDownCount :=
      (Sender as TDbComboBox).Items.Count;
    end;
  end;
end;

procedure TTakserDosisForm.eDebitorNrEnter(Sender: TObject);
begin
  with MainDm do begin
    // Debitor
    OldDebitor := mtEksDebitorNr.AsString;
    if (Sender as TDBEdit).Tag = 1 then
      ReadyDebitor;
    // Levering
    if (Sender as TDBEdit).Tag = 2 then
      ReadyLevering;
  end;
end;

procedure TTakserDosisForm.eDebitorNrExit(Sender: TObject);
begin
  with MainDm do begin
    if not (Sender as TDBEdit).Tag in [1,2] then
      exit;

    // Debitor
    if (Sender as TDBEdit).Tag = 1 then begin
      if (ProdDyrPrices) and (mtLin.RecordCount >= 1) then begin
        if OldDebitor <> eDebitorNr.Text then
          ChkBoxOK('Kontoen er til produktionsdyr med specielle priser.' + #10#13 +
                'Den kan derfor ikke ændres under ekspeditionen.');
        exit;
      end;
      if Trim (eDebitorNr.Text) <> '' then begin
        CheckDebitor;
        exit;
      end;
      mtEksDebitorNavn.AsString := '';
      mtEksLeveringsForm.Value  := 0;
      // reset everything else back the way it should be on start
      mtEksAfdeling.Value        := Maindm.AfdNr;
      mtEksLager.Value           := StamForm.FLagerNr;
      StamForm.StockLager := Stamform.Save_StockLager;
      c2logadd('11: Stock lager changed to ' +  inttostr(StamForm.StockLager));
      mtEksDebitorNavn.AsString  := '';
      mtEksLeveringsForm.Value   := 0;
      mtEksUdbrGebyr.AsCurrency  := 0.0;
      eDebitorNr.Color    := clSilver;
      eDebitorNr.TabStop  := True;
      lcLevForm .Color    := clSilver;
      lcLevForm .TabStop  := False;
      ePakkeNr  .Color    := clSilver;
      ePakkeNr  .ReadOnly := False;
      ePakkeNr  .TabStop  := False;
      ProdDyrPrices := False;
    end;
    // Levering
    if Trim (eLevNr.Text) <> '' then begin
      CheckLevering;
      exit;
    end;
    mtEksLevNavn.AsString := '';

    // 1239 set the udbr gebyr to 0 to stop popup check the debitor as well.
    if mtEksDebitorNr.AsString <> '' then begin
      if ffDebKar.FindKey([mtEksDebitorNr.AsString]) then begin
        if ffDebKarUdbrGebyr.AsBoolean then
          exit;
      end;
    end;
    mtEksUdbrGebyr.AsCurrency  := 0.0;
  end;
end;

procedure TTakserDosisForm.lcArtExit(Sender: TObject);
begin
  with MainDm do begin
    TableFilter (cdDyrAld);
    TableFilter (cdDyrOrd);
    cdDyrAld.First;
    cdDyrOrd.First;
    mtLinAldersGrp.Value := cdDyrAldNr.Value;
    mtLinOrdGrp.Value    := cdDyrOrdNr.Value;
    lcAlder.Update;
    lcOrd.Update;
  end;
end;

procedure TTakserDosisForm.process_cbDosTekst;
var
  WrkS : string;
begin
  with MainDm do begin

    WrkS:= AnsiUppercase(Trim(cbDosTekst.Text));
    if WrkS = '' then
      exit;

    mtLinDosering1.AsString:= WrkS;
    if ffDosTxt.FindKey([WrkS]) then
    begin
      if C2StrPrm(MainDm.C2UserName, 'Recepturdosering', '') = 'Text2' then
        // Benyt tekst2 (Dyr)
        WrkS:= AnsiUppercase(Trim(ffDosTxtTekst2.AsString))
      else
      begin
        // Benyt tekst1 (Human)
        WrkS:= AnsiUppercase(Trim(ffDosTxtTekst1.AsString));
        WrkS := StringReplace(WrkS,'@',FrmEntal,[rfReplaceAll]);
        WrkS := StringReplace(WrkS,'#',FrmFlertal,[rfReplaceAll]);
      end;
    end;
    meEtiketter.Lines.Add(WrkS);

  end;
end;

procedure TTakserDosisForm.Process_cbIndikation;
var
  WrkS : string;
begin

  with MainDm do begin
    try
      if mtLinLinieType.Value <> 1 then
        exit;
      if C2StrPrm(MainDm.C2UserName, 'Recepturindikation', '') = 'Text2' then begin
        // Dyr indikation
        WrkS:= AnsiUppercase(Trim(cbIndikation.Text));
        if WrkS <> '' then begin
          cbIndikation.Text:= WrkS;
          if ffDosTxt.FindKey([WrkS]) then
            WrkS:= AnsiUppercase(Trim(ffDosTxtTekst2.AsString));
          meEtiketter.Lines.Add(WrkS);
        end;
        exit;
      end;

      // Evt. human indikation
      if cbIndikation.Text <> '' then begin
        cbIndikation.Text:= AnsiUppercase (cbIndikation.Text);
        meEtiketter.Lines.Add     (cbIndikation.Text);
        mtLinIndikation.AsString:= cbIndikation.Text;
      end;
      // Følgetekst fra dispenseringsform
      if FrmTekst <> '' then begin
        meEtiketter.Lines.Add   (FrmTekst);
        mtLinFolgeTxt.AsString:= FrmTekst;
      end;


      // Dyr
      if mtEksEkspType.Value = et_Dyr then
      begin
        meEtiketter.Lines.Add('LÆGEMIDDEL TIL DYR');
        if mtLinFolgeTxt.AsString = '' then
          mtLinFolgeTxt.AsString:= 'LÆGEMIDDEL TIL DYR';
        exit;
      end;

      if mtEksKundeType.AsInteger  in [pt_Dyrlaege,pt_Landmand] then
      begin
        meEtiketter.Lines.Add('LÆGEMIDDEL TIL DYR');
        if mtLinFolgeTxt.AsString = '' then
          mtLinFolgeTxt.AsString:= 'LÆGEMIDDEL TIL DYR';
      end;

    finally
      buVidere.Tag := 2;
      buVidere.SetFocus;
    end;

  end;

end;

procedure TTakserDosisForm.process_Eantal;

begin
  with MainDm do begin
    try
      mtLinAntal.Value := StrToInt (EAntal.Text);
    except
      mtLinAntal.Value := 1;
      EAntal.Text      := '1';
    end;

    mtLinAntal.Value   :=  Abs (mtLinAntal.Value);
    if mtLinAntal.Value < 100 then begin
      mtLinBGPBel.AsCurrency := 0;
      mtLinIBTBel.AsCurrency := 0;
      mtLinTilskType.Value      := 0;
      mtLinRegelSyg.Value       := 0;
      mtLinRegelKom1.Value      := 0;
      mtLinRegelKom2.Value      := 0;
      mtLinTilskSyg.AsCurrency  := 0;
      mtLinTilskKom1.AsCurrency := 0;
      mtLinTilskKom2.AsCurrency := 0;
//        mtLinBGP.AsCurrency := mtLinSaveBGP.AsCurrency;
//        mtLinESP.AsCurrency := mtLinSaveESP.AsCurrency;
      mtLinTilskSyg.AsCurrency := 0;
      mtLinBrutto.AsCurrency    := mtLinPris.AsCurrency * mtLinAntal.Value;
      mtLinAndel.AsCurrency     := mtLinBrutto.AsCurrency;
      // Tilskudsberegning eller ej
      if (mtEksKundeType.Value = 1) and
// CJS         (mtLinLinieType.Value = 1) and
         (mtEksEkspType.Value <> et_Narkoleverance) then
      begin
        // Enkeltpersoner
        if not ffPatKarEjCtrReg.AsBoolean then
        begin
          if ffPatKarFiktivtCprNr.AsBoolean then
          begin
            // Spørg om beregning ønskes foretaget
            if ChkBoxYesNo ('Beregn tilskud til fiktivt cprnr ?', TRUE) then
              BeregnDosisOrdination(SaveDosisKortNr);
          end
          else
            BeregnDosisOrdination(SaveDosisKortNr);
        end;
      end
      else
      begin
        if mtEksEkspType.Value = et_Vagtbrugmm then
        begin
          // Vagtbrug
          if (mtLinTilskType.Value = 0) and
             (mtLinRegelSyg .Value = 0) then
          begin
            ffPatTil.First;
            while not ffPatTil.Eof do
            begin
              if ffPatTilRegel.Value in [11, 13, 14, 16] then
              begin
                if BevOversigt('', '', '') then
                begin
                  if mtLinRegelSyg.Value = 0 then
                    mtLinRegelSyg.Value := ffPatTilRegel.Value
                  else
                    ChkBoxOK ('Der er godkendt en regel på ordination !');
                end;
              end;
              ffPatTil.Next;
            end;
          end;
          if mtLinRegelSyg.Value > 0 then begin
            mtLinTilskSyg.AsCurrency := mtLinBrutto.AsCurrency;
            mtLinAndel.AsCurrency    := 0;
          end;
        end;
      end;
      if mtLinLinieType.Value = 2 then begin
        mtLinEtkLin.Value := 0;
//        if ChkBoxYesNo ('Ønskes doseringsetikette(r) ?', TRUE) then
//          mtLinEtkLin.Value := 1;
        buVidere.Tag := 2;
        buVidere.SetFocus;
      end else begin
        if mtLinUdlevMax.Value > 0 then
          EUdlev.SetFocus
        else
          SelectNext (ActiveControl, TRUE, TRUE);
      end;
//      Key := #0;
    end else begin
      ChkBoxOk ('Kun max 99 i antal pr. ordination !');
      mtLinAntal.Value := 99;
      EAntal.Text      := '99';
      exit;
    end;
    if SkipReservation then begin
      SkipReservation := False;
      exit;
    end;
//    if (ffLagKarAntal.AsInteger < mtLinAntal.AsInteger) or ( ffLagKarAntal.AsInteger <= 0) then begin
//      if StamForm.SpoergReservation then begin
//        if (copy(ffLagKarVareNr.AsString,1,2) <> '69') and (copy(ffLagKarVareNr.AsString,1,2) <> '80') then begin
//            frmResv.ShowResv(True);
//            if EVare.Text <> mtLinSubVareNr.AsString then begin
//              evare.Text := mtLinSubVareNr.AsString;
//              ReservationOrigVarenr := mtLinVareNr.AsString;
//              SkipReservation := True;
//              EVare.SetFocus;
//              exit;
//            end;
//
//        end;
//
//      end;
//      paLager     .Color:= clRed;
//      paLager.Font.Color:= clWhite;
//      if StamForm.StockLager <> StamForm.FLagerNr then begin
//        paLager     .Color:= clAqua;
//        paLager.Font.Color:= clBlack;
//      end;
//      paLager.Caption:= ' ' + mtLinSubVareNr.AsString + ' lager ' + ffLagKarAntal.AsString;
//      ffLagHis.SetRange([StamForm.StockLager, mtLinSubVareNr.AsString, 2], [StamForm.StockLager, mtLinSubVareNr.AsString, 0]);
//      try
//        if ffLagHis.recordcount <>  0 then begin
//          paLager     .Color:= clYellow;
//          paLager.Font.Color:= clWindowText;
//          if StamForm.StockLager <> StamForm.FLagerNr then begin
//            paLager     .Color:= clAqua;
//            paLager.Font.Color:= clBlack;
//          end;
//          ffLagHis.First;
//          LaDisp := 0;
//          while not ffLagHis.Eof do begin
//            if ffLagHisOrdreStatus.AsInteger = 2 then
//              LaDisp:= LaDisp + ffLagHisLeveret  .AsInteger +
//                                ffLagHisRestordre.AsInteger
//            else
//              LaDisp:= LaDisp + ffLagHisAntal    .AsInteger;
//            ffLagHis.Next;
//          end;
//          paLager.Caption:= ' ' + mtLinSubVareNr.AsString + ' - I OR : ' +
//            IntToStr(LaDisp);
//
//        end;
//      finally
//        ffLagHis.CancelRange;
//      end;
//
//    end;

  end;
end;

procedure TTakserDosisForm.process_EDos2;
var
  WrkS : string;
  PDos : integer;
begin
  with MainDm do begin
    WrkS:= AnsiUppercase(Trim(EDos2.Text));
    if WrkS = '' then
      exit;
    mtLinDosering2.AsString:= WrkS;
    EDos2.Text             := WrkS;
    if ffDosTxt.FindKey([WrkS]) then begin
      if C2StrPrm(MainDm.C2UserName, 'Recepturdosering', '') = 'Text2' then
        // Benyt tekst2 (Dyr)
        WrkS:= AnsiUppercase(Trim(ffDosTxtTekst2.AsString))
      else begin
        // Benyt tekst1 (Human)
        WrkS:= AnsiUppercase(Trim(ffDosTxtTekst1.AsString));
        PDos:= Pos('@', WrkS);
        while PDos > 0 do begin
          Delete(WrkS, PDos, 1);
          Insert(FrmEntal, WrkS, PDos);
          PDos:= Pos('@', WrkS);
        end;
        PDos:= Pos('#', WrkS);
        while PDos > 0 do begin
          Delete(WrkS, PDos, 1);
          Insert(FrmFlertal, WrkS, PDos);
          PDos:= Pos('#', WrkS);
        end;
      end;
    end;
    meEtiketter.Lines.Add(WrkS);

  end;
end;

procedure TTakserDosisForm.Process_eYdenr;
begin

  with MainDm do begin
    // Ydernr
    mtEksYderNavn.AsString := '';
    mtEksYderNr.AsString := trim(eYderNr.Text);

    // if we change the doctor from that on the front screen then
    // blank out cpr/ydernr field

    if mtEksYderNr.AsString <> ffPatKarYderNr.AsString then
      mtEksYderCprNr.AsString := ''
    else
      mtEksYderCprNr.AsString := ffPatKarYderCprNr.AsString;

    if YderList then begin
      if Trim (ffYdLstNavn.AsString)  <> '' then
          mtEksYderNavn.AsString  := ffYdLstNavn.AsString;
      mtEksYderCprNr.AsString := ffYdLstCprNr.AsString;

    end else begin
      if ffYdLst.FindKey ([eYderNr.Text]) then begin
        mtEksYderNr.AsString := ffYdLstYderNr.AsString;
//          mtEksYderCprNr.AsString := ffYdLstCprNr.AsString;
        if Trim (ffYdLstNavn.AsString)  <> '' then
          mtEksYderNavn.AsString  := ffYdLstNavn.AsString;
      end;
    end;
    FillYderCpr;
//      mteks.Post;
//      mtEks.ApplyUpdates(-1);
//      mtEks.Refresh;
//      mtEks.Edit;

  end;
end;

procedure TTakserDosisForm.cbSubstEnter(Sender: TObject);
begin
  with MainDm do begin
    cbSubst.ItemIndex := mtLinSubstValg.Value;
    if mtLinSubstValg.Value <> 9 then begin
      cbSubst.Tag          := 0;
      EAntal.SetFocus;
      exit;
    end;
    // Sæt cbSubst combobox som cbIndikation
    cbSubst.ItemIndex    := 0;
    if (not StamForm.TakserDosisKortAuto) or (not DosisKortAutoExp) then
      mtLinSubstValg.Value := 0;
    cbSubst.Tag          := cbSubst.Width;
    cbSubst.Left         := cbIndikation.Left;
    cbSubst.Width        := cbIndikation.Width;
    cbSubst.ItemIndex    := 0;
    cbSubst.DroppedDown  := True;
    if itemsubst  then
      cbSubst.ItemIndex := 1;
  end;
end;

procedure TTakserDosisForm.cbSubstExit(Sender: TObject);
begin
  with MainDm do begin
    mtLinEjS.AsBoolean   := mtLinSubstValg.Value <> 0;
    if StamForm.TakserDosisKortAuto then begin
      if mtLinSubstValg.Value = 5 then begin
        mtLinSubstValg.Value := 0;
        mtLinEjS.AsBoolean := False;

      end;
      // Fjern dropdown
      if cbSubst.DroppedDown then
        cbSubst.DroppedDown := False;
      // Ret control som før enter
      if cbSubst.Width = cbIndikation.Width then begin
        cbSubst.Width := cbSubst.Tag;
        cbSubst.Left  := cbSubst.Left + (cbIndikation.Width - cbSubst.Width);
      end;
      exit;
    end;

    // Fjern dropdown
    if cbSubst.DroppedDown then
      cbSubst.DroppedDown := False;
    // Ret control som før enter
    if cbSubst.Width = cbIndikation.Width then begin
      cbSubst.Width := cbSubst.Tag;
      cbSubst.Left  := cbSubst.Left + (cbIndikation.Width - cbSubst.Width);
    end;
    // Vælg evt. fravalg
    mtLinSubstValg.Value := cbSubst.ItemIndex;
    mtLinEjS.AsBoolean   := mtLinSubstValg.Value <> 0;
  end;
end;


procedure TTakserDosisForm.cbIndikationKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not Key in [VK_UP, VK_DOWN] then
    exit;
  if not (Sender as TComboBox).DroppedDown then
    exit;
    if Key = VK_UP then begin
      if (Sender as TComboBox).ItemIndex = 0 then begin
        (Sender as TComboBox).ItemIndex := (Sender as TComboBox).DropDownCount - 1;
        Key := 0;
      end;
    end;
    if Key = VK_DOWN then begin
      if (Sender as TComboBox).ItemIndex = (Sender as TComboBox).DropDownCount - 1 then begin
        (Sender as TComboBox).ItemIndex := 0;
        Key := 0;
      end;
    end;
end;


procedure FillCTRBevDataset;
begin
  with MainDm do begin
    cdCtrBev.First;
    while not cdCtrBev.Eof do
      cdCtrBev.Delete;

    nxCTRBev.IndexName := 'KundeNrOrden';
    nxCTRBev.SetRange([ffPatKarKundeNr.AsString],[ffPatKarKundeNr.AsString]);
    try
      if nxCTRBev.recordcount = 0 then
        exit;
      nxCTRBev.First;
      while not nxCTRBev.Eof do begin
        if nxCTRBevRegel.AsInteger <> 75 then begin
          cdCtrBev.Append;
          cdCtrBevRegel.AsInteger := nxCTRBevRegel.AsInteger;
          cdCtrBevFraDato.AsDateTime := nxCTRBevFraDato.AsDateTime;
          cdCtrBevTilDato.AsDateTime := nxCTRBevTilDato.AsDateTime;
          cdCtrBevIndDato.AsDateTime := nxCTRBevIndbDato.AsDateTime;
          cdCtrBevAtc.AsString := nxCTRBevAtc.AsString;
          cdCtrBevLmNavn.AsString := nxCTRBevLmNavn.AsString;
          cdCtrBevAdmVej.AsString := nxCTRBevAdmVej.AsString;
          cdCtrBevVareNr.AsString := nxCTRBevVareNr.AsString;

          cdCtrBev.Post;
        end;
        nxCTRBev.Next;

      end;

    finally

      nxCTRBev.CancelRange;
    end;

  end;


end;


procedure TTakserDosisForm.cbDosTekstEnter(Sender: TObject);
var
  i : integer;
begin
  with MainDm do begin
    cbDosTekst.Tag := cbDosTekst.Width;
    cbDosTekst.Width := cbIndikation.Width;
    cbDosTekst.Font.Size := 8;
    if meEtiketter.Lines.Count > 1 then
      for I := 1 to meEtiketter.Lines.Count - 1 do
        meEtiketter.Lines.Delete (1);

    if cbDosTekst.Text = '' then begin
        if cbDosTekst.DropDownCount > 0 then begin
          cbDosTekst.ItemIndex  := 0;
          cbDosTekst.DroppedDown:= True;
        end;
    end;
  end;
end;

procedure TTakserDosisForm.cbDosTekstKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not Key in [VK_UP, VK_DOWN] then
    exit;
  if not (Sender as TComboBox).DroppedDown then
    exit;
  if Key = VK_UP then begin
    if (Sender as TComboBox).ItemIndex = 0 then begin
      (Sender as TComboBox).ItemIndex := (Sender as TComboBox).DropDownCount - 1;
      Key := 0;
    end;
  end;
  if Key = VK_DOWN then begin
    if (Sender as TComboBox).ItemIndex = (Sender as TComboBox).DropDownCount - 1 then begin
      (Sender as TComboBox).ItemIndex := 0;
      Key := 0;
    end;
  end;
end;

procedure TTakserDosisForm.cbDosTekstExit(Sender: TObject);
begin
  cbDosTekst.Width := cbDosTekst.Tag;
  cbDosTekst.Tag := 0;
  cbDosTekst.Font.Size := 10;

end;

procedure TTakserDosisForm.cbIndikationExit(Sender: TObject);
begin
  cbIndikation.Font.Size := 10;

end;

procedure TTakserDosisForm.eTurNrExit(Sender: TObject);
begin
  with MainDm do begin
    if mtEksTurNr.AsInteger > 0 then
      eTurNr.Color := clYellow
    else
      eTurNr.Color := clWindow;
  end;

end;

procedure TTakserDosisForm.eYderCPRNrEnter(Sender: TObject);
begin
  eYderCPRNr.DroppedDown := true;

end;

procedure TTakserDosisForm.eYderNrEnter(Sender: TObject);
begin
  YderList := False;
end;

procedure TTakserDosisForm.btnYderClick(Sender: TObject);
begin
  YderList := True;
  YdLst;
  eYderNr.SetFocus;
end;

procedure TTakserDosisForm.BuildDosisEtiketLabel;
begin
  with MainDm do
  begin
    meEtiketter.Lines.Clear;
    if ffPatKarCtrType.AsInteger in [1,11] then
    begin
      meEtiketter.Lines.Add (AnsiUpperCase (BytNavn (ffPatKarNavn.AsString)) +
                ' ' + calcage(ffPatKarKundeNr.AsString,ffPatKarFoedDato.asstring));
    end
    else
      meEtiketter.Lines.Add (AnsiUpperCase (BytNavn (ffPatKarNavn.AsString)));

    nqDosETK.Close;
    try
      nqDosETK.SQL.Clear;
      nqDosETK.SQL.Add('select');
      nqDosETK.SQL.Add('      z.*');
      nqDosETK.SQL.Add('      ,p.*');
      nqDosETK.SQL.Add('from');
      nqDosETK.SQL.Add('(');
      nqDosETK.SQL.Add('select');
      nqDosETK.SQL.Add('      y.*');
      nqDosETK.SQL.Add('      ,h.dosiskod');
      nqDosETK.SQL.Add('      ,h.startday');

      nqDosETK.SQL.Add('from');
      nqDosETK.SQL.Add('(');
      nqDosETK.SQL.Add('SELECT');
      nqDosETK.SQL.Add('       cardnumber');
      nqDosETK.SQL.Add('       ,varenummer');
      nqDosETK.SQL.Add('       ,regulardose');
      nqDosETK.SQL.Add('       ,days');
      nqDosETK.SQL.Add('       ,vareindikation');
      nqDosETK.SQL.Add('       ,sum(quantity1) as q1');
      nqDosETK.SQL.Add('       ,sum(quantity2) as q2');
      nqDosETK.SQL.Add('       ,sum(quantity3) as q3');
      nqDosETK.SQL.Add('       ,sum(quantity4) as q4');
      nqDosETK.SQL.Add('       ,sum(quantity5) as q5');
      nqDosETK.SQL.Add('       ,sum(quantity6) as q6');
      nqDosETK.SQL.Add('       ,sum(quantity7) aS q7');
      nqDosETK.SQL.Add('       ,sum(quantity8) as q8');
      nqDosETK.SQL.Add('from');
      nqDosETK.SQL.Add('(');
      nqDosETK.SQL.Add('     select');
      nqDosETK.SQL.Add('       cardnumber');
      nqDosETK.SQL.Add('       ,varenummer');
      nqDosETK.SQL.Add('       ,regulardose');
      nqDosETK.SQL.Add('       ,days');
      nqDosETK.SQL.Add('       ,vareindikation');
      nqDosETK.SQL.Add('       ,quantity1');
      nqDosETK.SQL.Add('       ,quantity2');
      nqDosETK.SQL.Add('       ,quantity3');
      nqDosETK.SQL.Add('       ,quantity4');
      nqDosETK.SQL.Add('       ,quantity5');
      nqDosETK.SQL.Add('       ,quantity6');
      nqDosETK.SQL.Add('       ,quantity7');
      nqDosETK.SQL.Add('       ,quantity8');
      nqDosETK.SQL.Add('     from');
      nqDosETK.SQL.Add('         dosiscardlines');
      nqDosETK.SQL.Add('    where');
      nqDosETK.SQL.Add('           cardnumber = :cardno');
      nqDosETK.SQL.Add('           and varenummer = :varenr');
      nqDosETK.SQL.Add(') as x');

      nqDosETK.SQL.Add('group by');
      nqDosETK.SQL.Add('      cardnumber');
      nqDosETK.SQL.Add('      ,Varenummer');
      nqDosETK.SQL.Add('      ,Regulardose');
      nqDosETK.SQL.Add('      ,days');
      nqDosETK.SQL.Add('      ,vareindikation');
      nqDosETK.SQL.Add('order by');
      nqDosETK.SQL.Add('      Cardnumber');
      nqDosETK.SQL.Add('      ,Varenummer');
      nqDosETK.SQL.Add('      ,regulardose');
      nqDosETK.SQL.Add('      ,days');
      nqDosETK.SQL.Add(') as y');
      nqDosETK.SQL.Add('left join');
      nqDosETK.SQL.Add('     Dosiscardheader as h on h.cardnumber=y.cardnumber');
      nqDosETK.SQL.Add(') as z');
      nqDosETK.SQL.Add('left join dosisperiod as p on p.dosiskod=z.dosiskod');
      nqDosETK.ParamByName('cardno').AsInteger := mtEksDosKortNr.AsInteger;
      nqDosETK.ParamByName('varenr').AsString := mtLinSubVareNr.AsString;
      nqDosETK.Open;
      try

        if nqDosETK.RecordCount = 0 then
          exit;
        nqDosETK.First;
        while not nqDosETK.Eof do
        begin
          if nqDosETK.FieldByName('regulardose').AsBoolean then
          begin
            if nqDosETK.FieldByName('q1').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period1').AsString + ':' +
                  nqDosETK.FieldByName('q1').AsString);
            end;
            if nqDosETK.FieldByName('q2').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period2').AsString + ':' +
                  nqDosETK.FieldByName('q2').AsString);
            end;
            if nqDosETK.FieldByName('q3').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period3').AsString + ':' +
                  nqDosETK.FieldByName('q3').AsString);
            end;
            if nqDosETK.FieldByName('q4').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period4').AsString + ':' +
                  nqDosETK.FieldByName('q4').AsString);
            end;
            if nqDosETK.FieldByName('q5').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period5').AsString + ':' +
                  nqDosETK.FieldByName('q5').AsString);
            end;
            if nqDosETK.FieldByName('q6').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period6').AsString + ':' +
                  nqDosETK.FieldByName('q6').AsString);
            end;
            if nqDosETK.FieldByName('q7').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period7').AsString + ':' +
                  nqDosETK.FieldByName('q7').AsString);
            end;
            if nqDosETK.FieldByName('q8').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period8').AsString + ':' +
                  nqDosETK.FieldByName('q8').AsString);
            end;
          end
          else
          begin
            meEtiketter.lines.Add(
                'Start '+
            nqDosETK.fieldbyname('Startday').AsString);
            meEtiketter.Lines.Add('Dag:' +
              nqDosETK.fieldbyname('days').AsString);
            if nqDosETK.FieldByName('q1').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period1').AsString + ':' +
                  nqDosETK.FieldByName('q1').AsString);
            end;
            if nqDosETK.FieldByName('q2').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period2').AsString + ':' +
                  nqDosETK.FieldByName('q2').AsString);
            end;
            if nqDosETK.FieldByName('q3').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period3').AsString + ':' +
                  nqDosETK.FieldByName('q3').AsString);
            end;
            if nqDosETK.FieldByName('q4').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period4').AsString + ':' +
                  nqDosETK.FieldByName('q4').AsString);
            end;
            if nqDosETK.FieldByName('q5').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period5').AsString + ':' +
                  nqDosETK.FieldByName('q5').AsString);
            end;
            if nqDosETK.FieldByName('q6').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period6').AsString + ':' +
                  nqDosETK.FieldByName('q6').AsString);
            end;
            if nqDosETK.FieldByName('q7').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period7').AsString + ':' +
                  nqDosETK.FieldByName('q7').AsString);
            end;
            if nqDosETK.FieldByName('q8').AsInteger <> 0 then
            begin
              meEtiketter.Lines.Add(
                  nqDosETK.FieldByName('period8').AsString + ':' +
                  nqDosETK.FieldByName('q8').AsString);
            end;

          end;
          meEtiketter.Lines.Add(nqDosETK.fieldbyname('vareindikation').AsString);
          nqDosETK.Next;
        end;

      finally
        nqDosETK.Close;
      end;
    except
      on e : Exception do
        ChkBoxOK(e.Message);
    end;
  end;
end;

procedure TTakserDosisForm.acVisRCPExecute(Sender: TObject);
begin
  with MainDm do begin
  if ReceptId <> 0 then
    TRCPPrnForm.RCPView(mtLinReceptId.AsInteger);
  end;
end;

procedure TTakserDosisForm.acLager0Execute(Sender: TObject);
begin
  StamForm.StockLager := 0;
end;

procedure TTakserDosisForm.acLager1Execute(Sender: TObject);
begin
  StamForm.StockLager := 1;
end;

procedure TTakserDosisForm.acLager2Execute(Sender: TObject);
begin
  StamForm.StockLager := 2;
end;

procedure TTakserDosisForm.acLager3Execute(Sender: TObject);
begin
  StamForm.StockLager := 3;
end;

procedure TTakserDosisForm.acLager4Execute(Sender: TObject);
begin
  StamForm.StockLager := 4;
end;

procedure TTakserDosisForm.acLager5Execute(Sender: TObject);
begin
  StamForm.StockLager := 5;
end;

end.
