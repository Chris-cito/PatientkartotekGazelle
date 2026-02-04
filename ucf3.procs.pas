unit ucf3.procs;

{ Developed by: Vitec Cito A/S

  Description: Routines for Control-F3 page

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  27-08-2025/cjs  Correction to CtrEfterReg transaction failure that caused lbnr not be added to OpdaterCTR queue

  25-08-2025/cjs  Correction to large antal when using efterreg function.

  22-07-2025/cjs  Write the newly created ekspedition in Ctr Efterreg to the Opdater Ctr queue.  This will set the CP
                  marker on the tilskud line

  21-07-2025/cjs  Corrections for CtrEfterReg

  09-12-2024/cjs  Tidy up some code

  17-02-2023/cjs  Added new functions that control when a Tilbageført of an ekspedition is in progress
                  Sagsnr 11528

  03-08-2022/cjs  Initial version.
}

interface

uses
  nxdb, System.SysUtils, uc2common.types, Winapi.Windows, System.Classes, generics.collections, System.DateUtils,
  System.Math, DM, FriDosEtiket,
  uDosisTakseringer.Tables, uC2Ui.MainLog.Procs, TakserAfslut, uC2Common.procs,uEkspeditioner.Tables,uEksplinierSalg.Tables,
  uEkspLinierTilskud.Tables,uEkspeditionerCredit.Tables;

procedure CF3DetailedKundeList2(AnXdb : TnxDatabase; const AKundeNr : string;AFraDato: TdateTime; ATilDato :TdateTime);


procedure CF3KundeList2(AnXdb : TnxDatabase; const AKundeNr : string;AFraDato: TdateTime; ATilDato :TdateTime);

procedure CF3VisEtiket(ALbNr :Integer);

function CF3IsDosisEkspedition(ALbnr : integer) : boolean;

function CF3StartTilbageFunction(ALbnr : integer; const AUser : string ; ABrugerNr : integer) : boolean;
function CF3FinishTilbageFunction(ALbnr : integer) : boolean;
function StregkodeKontrolInProgress(Albnr : Integer) : Boolean;

procedure CF3EfterReg;


implementation

uses C2Procs,C2Mainlog, PatMatrixPrinter,ChkBoxes, uGemRegel42Returnering.procs;


procedure CF3VisEtiket(ALbNr : Integer);
var
  Send: string;
  Edi: string;
  ChrNr: string;
  LKundeType: TKundeType;
  DosEtiket : TStringList;
begin
  AdjustIndexName(MainDM.ffEksOvr,'NrOrden');
  if not MainDm.ffEksOvr.FindKey([ALbNr]) then
    Exit;
  DosEtiket := TStringList.Create;
  try
    DosEtiket.Assign(MainDM.ffEksEtkEtiket);
    Send := '   ';
    if MainDM.ffEksOvrLeveringsForm.AsInteger > 0 then
      Send := LevForm2Str(MainDM.ffEksOvrLeveringsForm.AsInteger);
    Edi := '   ';
    if MainDM.ffEksOvrEkspForm.AsInteger = 3 then
      Edi := 'Edi';
    ChrNr := '';
    LKundeType := TKundeType.Parse(MainDM.ffEksOvrKundeType.AsInteger);
    if LKundeType = pt_Landmand then
    begin
      MainDM.ffPatKar.IndexName := 'NrOrden';
      if MainDM.ffPatKar.FindKey([MainDM.ffEksOvrKundenr.AsString]) then
        ChrNr := copy(MainDM.ffPatKarLmsModtager.AsString, 5, 6);
    end;
    DosEtiket.Insert(0, ChrNr);
    DosEtiket.Insert(0, MainDM.ffEksOvrLevNavn.AsString);
    DosEtiket.Insert(0, MainDM.ffEksOvrKontoNr.AsString);
    DosEtiket.Insert(0, MainDM.ffLinOvrLokation2.AsString);
    DosEtiket.Insert(0, MainDM.ffLinOvrLokation1.AsString);
    DosEtiket.Insert(0, MainDM.ffLinOvrATCKode.AsString);
    DosEtiket.Insert(0, MainDM.ffLinOvrSubVareNr.AsString);
    DosEtiket.Insert(0, Send);
    DosEtiket.Insert(0, Edi);
    DosEtiket.Insert(0, MainDM.ffEksOvrLbNr.AsString);
    DosEtiket.Insert(0, FormatDateTime('dd-mm-yy', MainDM.ffEksOvrTakserDato.AsDateTime));
    DosEtiket.Insert(0, MainDM.ffFirmaSupNavn.AsString);
    if TfmEtk.FriEtiket(DosEtiket, True) then
    begin
    end;
    // Gem rettelser
    // ffEksEtk.Edit;
    // ffEksEtkEtiket.Assign(DosEtiket);
    // ffEksEtk.Post;
  finally
    DosEtiket.Free;
  end;
end;

function CF3IsDosisEkspedition(ALbnr : integer) : boolean;
var
  LQry : TnxQuery;
begin
  try

    LQry := MainDm.nxdb.OpenQuery('select ' + fnDosisTakseringerLbNr + ' from ' +
      tnDosisTakseringer + ' where ' + fnDosisTakseringerLbNr_P,
      [ALbnr]);
    begin
      try
        if not LQry.Eof then
          exit(True)
        else
          exit(False);
      finally
        LQry.Free;
      end;

    end;
  except
    on e: Exception do
    begin
      // if we cannot access the table then its ok to continue with return.
      c2logadd('Fejl when checking ' + tnDosisTakseringer + ' ' +
        e.Message);
      Result := False;

    end;

  end;

end;


function CF3StartTilbageFunction(ALbnr : integer; const AUser : string ; ABrugerNr : integer) : boolean;
var
  LFilename : string;
  LSl : TStringList;
begin

  LFilename := 'G:\Temp\Tilbage' + ALbnr.ToString +'.txt';

  // if the file exists then warn the user and exit False
  if FileExists(LFilename) then
  begin
    LSl := TStringList.Create;
    try
      LSl.LoadFromFile(LFilename);
      ShowMessageBoxWithLogging(LSl.Text);


    finally
      LSl.Free;
    end;
    exit(False);

  end;

  LSl := TStringList.Create;
  try
    LSl.Add(Format('Tilbageførsel af dette løbenummer er igangværende på user %s brugernr %d ', [AUser,ABrugerNr]) +
                            FormatDateTime('dd-mm-yyyy hh:mm:ss',Now));
    LSl.SaveToFile(LFilename);
    exit(True);
  finally
   LSl.Free
  end;



end;
function CF3FinishTilbageFunction(ALbnr : integer) : boolean;
var
  LFilename : string;
begin
  LFilename := 'G:\Temp\Tilbage' + ALbnr.ToString +'.txt';

  // if the file exists then delete the file
  try
    if FileExists(LFilename) then
      System.SysUtils.DeleteFile(LFilename);
    exit(True);
  except
    on E: Exception do
    begin
      C2LogAdd('Fejl i CF3FinishTilbageFunction ' + e.Message);
      exit(False);
    end;
  end;

end;

function CF3EfterRegGetAntalNotCredited: Integer;
var
  antalnotcredited: Integer;
begin
  antalnotcredited := MainDm.ffLinOvrAntal.AsInteger;
  AdjustIndexName(MainDm.nxEksCred, 'LbnrOrden');

  MainDm.nxEksCred.SetRange([MainDm.ffEksOvrLbNr.AsInteger, MainDm.ffLinOvrLinieNr.AsInteger],
    [MainDm.ffEksOvrLbNr.AsInteger, MainDm.ffLinOvrLinieNr.AsInteger]);
  try
    if MainDm.nxEksCred.IsEmpty then
      exit;
    var LDevisAntalField := MainDm.nxEksCred.fieldbyname('DelvisAntal');
    MainDm.nxEksCred.First;
    while not MainDm.nxEksCred.Eof do
    begin
      var LDevisAntal := LDevisAntalField.AsInteger;
      if LDevisAntal = 0 then
      begin
        antalnotcredited := 0;
        break;
      end;

      antalnotcredited := antalnotcredited - LDevisAntal;
      MainDm.nxEksCred.Next;
    end;

  finally
    MainDm.nxEksCred.CancelRange;
    Result := antalnotcredited;
  end;
end;


procedure CF3EfterReg;
var
  LSaveIndex: string;
  LbNr, LLinienr, LAntal: Integer;
  LMessageBoxText: string;
  BGPBel: Currency;
  LPris : Currency;

  procedure UpdateEksplinierTilskud;
  begin
    try
      var IsTerminalCtrType := TKundeCTRType(MainDm.ffPatUpdCtrType.AsInteger) = kctTerminal;


      MainDm.ffEksTil.Edit;


        // Set RegelSyg
      MainDm.ffEksTilRegelSyg.AsInteger := IfThen(IsTerminalCtrType, 41, 42);

        // Determine price based on contract type
      if IsTerminalCtrType then
        LPris := MainDm.ffLinOvrPris.AsCurrency
      else
        LPris := MainDm.ffEksTilBGP.AsCurrency;

        // Calculate and assign BGPBel
      var Antal := MainDm.ffEksLinAntal.AsInteger;

      MainDm.ffEksTilBGPBel.AsCurrency := Antal * LPris;
      MainDm.ffEksTil.Post;
    except
      on e: Exception do
      begin
        ChkBoxOK('Fejl i ret Tilskud ' + e.Message);
        MainDm.ffEksTil.Cancel;
        raise;
      end;
    end;

  end;

  procedure AddToOpdaterQueue;

  begin
      // write to opdater ctr queue
    try
      MainDm.ffCtrOpd.Insert;
      MainDm.ffCtrOpdNr.AsInteger := LbNr;
      MainDm.ffCtrOpdDato.AsDateTime := MainDm.ffEksKarOrdreDato.AsDateTime;
      MainDm.ffCtrOpd.Post;
    except
      on E: Exception do
      begin
        C2LogAddF('Failed to write to OpdaterCTR queue %s ', [e.Message]);
        MainDm.ffCtrOpd.Cancel;
        raise;
      end;
    end;
  end;

  procedure ValidateExpeditionOrRaise;
  begin
    // do not allow if the ekspedition is not closed!!

    if TEkspOrdreStatus.Parse(MainDm.ffEksOvrOrdreStatus.AsInteger) <> eosAfsluttet then
      raise Exception.Create('Det er ikke muligt at efterregistrere en åben ekspedition.');

    if TEkspOrdreType.Parse(MainDm.ffEksOvrOrdreType.AsInteger) = eotRetur then
      raise Exception.Create('Returekspedition kan ikke efterregistreres');

    if TEkspLinieType(MainDm.ffLinOvrLinieType.AsInteger) = eltHaandkoeb then
      raise Exception.Create('Håndkøbslinie kan ikke sendes til CTR');

    if MainDm.ffEksOvrOrdreDato.AsDateTime <= IncYear(Now, -1) then
      raise Exception.Create('Denne ekspedition kan ikke efterregistreres hos CTR,' + sLineBreak +
                             'da den er mere end 1 år.');

    if MainDm.ffEksOvrUdlignNr.AsInteger <> 0 then
      raise Exception.Create('Ordinationen er allerede tilbageført!');

    LAntal := CF3EfterRegGetAntalNotCredited;
    if LAntal = 0 then
      raise Exception.Create('Ordinationen er allerede tilbageført!');

    AdjustIndexName(MainDm.nxLager, 'NrOrden');
    if MainDm.nxLager.FindKey([MainDm.ffLinOvrLager.AsInteger, MainDm.ffLinOvrSubVareNr.AsString]) then
      if MainDm.nxLagerDrugId.AsString.StartsWith(SCannabisDrugIdPrefix) then
        raise Exception.Create('Medicinsk Cannabis kan ikke efterregistreres til CTR A' + sLineBreak +
                               'Tjek Saldo i CTR B');

    if not MainDm.ffEksTil.FindKey([MainDm.ffLinOvrLbNr.AsInteger, MainDm.ffLinOvrLinieNr.AsInteger]) then
      raise Exception.Create('Fejl: Kunne ikke finde ekspedition i ffEksTil.');

    if MainDm.ffEksTilRegelSyg.AsInteger <> 0 then
      raise Exception.Create('Ordinationen har allerede en ss regel');

    if not MainDm.ffPatUpd.FindKey([MainDm.ffEksOvrKundenr.AsString]) then
      raise Exception.Create('Kunde findes ikke: ' + MainDm.ffEksOvrKundenr.AsString);

    if TKundeType.Parse(MainDm.ffPatUpdKundeType.AsInteger) <> pt_Enkeltperson then
      raise Exception.Create('Kun ekspedition til enkeltperson kan sendes til CTR');
  end;

  function ConfirmUserWantsToReport: Boolean;
  var
    MsgText: string;
  begin
    if TKundeCTRType(MainDm.ffPatUpdCtrType.AsInteger) = kctTerminal then
      MsgText := 'Er du sikker på, at du vil indberette terminalbevilling for ' +
                 sLineBreak + 'Lbnr. ' + MainDm.ffEksOvrLbNr.AsString + ' ' +
                 MainDm.ffLinOvrTekst.AsString
    else
      MsgText := 'Er du sikker på, at du vil indberette regel 42 til ctr for ' +
                 sLineBreak + 'Lbnr. ' + MainDm.ffEksOvrLbNr.AsString + ' ' +
                 MainDm.ffLinOvrTekst.AsString;

    Result := ChkBoxYesNo(MsgText, False);
  end;

begin
  LSaveIndex := SaveAndAdjustIndexName(MainDm.ffEksTil, 'NrOrden');
  try

    try
      ValidateExpeditionOrRaise;
    except
      on E: Exception do
      begin
        ChkBoxOK(E.Message);
        Exit;
      end;
    end;

//    // look for patienttilskud regel > 59
//
//    MainDm.ffTilUpd.SetRange([MainDm.ffEksOvrKundenr.AsString], [MainDm.ffEksOvrKundenr.AsString]);
//    try
//      if MainDm.ffTilUpd.RecordCount <> 0 then
//      begin
//        MainDm.ffTilUpd.First;
//        while not MainDm.ffTilUpd.Eof do
//        begin
//          if MainDm.ffTilUpdRegel.AsInteger > 59 then
//          begin
//            ChkBoxOK('Kunden har kommunal bevilling, så denne funktion kan ikke benyttes.');
//            exit;
//          end;
//
//          MainDm.ffTilUpd.Next;
//        end;
//      end;
//
//    finally
//      MainDm.ffTilUpd.CancelRange;
//    end;
//
    if not ConfirmUserWantsToReport then
      Exit;


    LbNr := MainDm.ffLinOvrLbNr.AsInteger;
    LLinienr := MainDm.ffLinOvrLinieNr.AsInteger;
    GemRegel42Returnering(LbNr, LLinienr, LAntal);

    if not MainDm.ffEksTil.FindKey([LbNr, LLinienr]) then
    begin
      ChkBoxOK('Fejl i ret Tilskud ny Tilskud findes ikke');
      exit;
    end;

    if not MainDm.ffEksLin.FindKey([LbNr, LLinienr]) then
    begin
      ChkBoxOK('Fejl i ret Tilskud ny LinierSalg findes ikke');
      exit;
    end;

    if not MainDm.ffEksKar.FindKey([LbNr]) then
    begin
      ChkBoxOK('Fejl i ret Tilskud ny Ekspeditioner findes ikke');
      exit;
    end;

    try


      for var i := 1 to 5 do
      begin
        try

          MainDm.ffRcpOpl.Database.StartTransactionWith([MainDm.ffCtrOpd, MainDm.ffEksTil]);

          break;
        except
          on E: Exception do
          begin
            if i = 5 then
              raise;
            Sleep(3000);

          end;

        end;
      end;

      try
        UpdateEksplinierTilskud;

        AddToOpdaterQueue;
        MainDm.ffRcpOpl.Database.Commit;
      except
        on E: Exception do
        begin
          c2logadd('    Message "' + E.Message + '"');
          try
            MainDm.nxdb.Rollback;
          except
            on E: Exception do
            begin
              c2logadd('Error calling rollback ' + E.Message);
            end;

          end;
        end;

      end;
    except
      on E: Exception do
      begin
        C2LogAddF('Failed to start a tranaaction %s', [e.Message]);
      end;
    end;
  finally
    AdjustIndexName(MainDm.ffEksTil, LSaveIndex);
  end;
end;

function StregkodeKontrolInProgress(Albnr : Integer) : Boolean;
var
  LFilename : string;
  LSl : TStringList;
begin
  LFilename := 'G:\Temp\StregkodeKontrol_' + Albnr.ToString + '.txt';

  // if the file does not exist then no stregkode is in progress on the ekspedition.
  if not FileExists(LFilename) then
    Exit(False);
  // if the file exists then warn the user and exit True

  LSl := TStringList.Create;
  try
    LSl.LoadFromFile(LFilename);
    ShowMessageBoxWithLogging(LSl.Text);

  finally
    LSl.Free;
  end;
  exit(True);
end;

function GetFirmaNavn (ANxDb : TnxDatabase) : string;
begin
  var LQry := TnxQuery.Create(nil);
  try
    LQry.Database := AnXdb;
    LQry.sql.Text := 'SELECT navn FROM firmaoplysninger';
    LQry.Open;
    if LQry.Eof then
      Exit('Firma-Fejl')
    else
      Exit(LQry.FieldByName('navn').asstring);
  finally
    LQry.Free;
  end;
end;

procedure CF3KundeList2(AnXdb : TnxDatabase; const AKundeNr : string;AFraDato: TdateTime; ATilDato :TdateTime);
var
  PatLst: TStringList;
  PNr: Word;
  Syg, Kom, Pat: Currency;
  Antal, Patient, TilAmt, TilKom, VareNr, VareNavn, YderNavn, LbNr, Dato: string;
  TotalSyg, TotalKom, TotalPat: Currency;
  gebyr: Currency;
  LKundenr,LKundenavn : string;
  LOrdreType : integer;

  function BuildHeaderSql: string;
  begin
    var LSQl := TStringBuilder.Create;
    try
      LSQl.AppendLine('SELECT');
      LSQl.AppendLine('  ' + fnEkspeditionerLbNr);
      LSQl.AppendLine('  ' + fnEkspeditionerOrdreType_K);
      LSQl.AppendLine('  ' + fnEkspeditionerOrdreStatus_K);
      LSQl.AppendLine('  ' + fnEkspeditionerAfsluttetDato_K);
      LSQl.AppendLine('  ' + fnEkspeditionerYderNavn_K);
      LSQl.AppendLine('  ' + fnEkspeditionerUdbrGebyr_K);
      LSQl.AppendLine('  ' + fnEkspeditionerEdbGebyr_K);
      LSQl.AppendLine('  ' + fnEkspeditionerTlfGebyr_K);
      LSQl.AppendLine('  ' + fnEkspeditionerKundeNr_K);
      LSQl.AppendLine('  ' + fnEkspeditionerNavn_K);
      LSQl.AppendLine('  ' + fnEkspeditionerTakserDato_K);
      LSQl.AppendLine('  ' + fnEkspeditionerUdlignNr_K);
      LSQl.AppendLine('fROM ' + tnEkspeditioner);
      LSQl.AppendLine('WHERE');
      LSQl.AppendLine('  ' + fnEkspeditionerKundeNr_P);
      LSQl.AppendLine('  AND ' + fnEkspeditionerOrdreStatus + '=2');
      LSQl.AppendLine('  AND ' + fnEkspeditionerafsluttetdato + ' BETWEEN :StartDate AND :EndDate');
      LSQl.AppendLine('ORDER BY ' + fnEkspeditionerLbNr);
    finally
      Result := LSQl.ToString;
      LSQl.Free;
    end;


  end;

  function BuildLinesSql: string;
  begin
    var SQL := TStringBuilder.Create;
    try
      SQL.AppendLine('SELECT');
      SQL.AppendLine('  l.linienr,');
      SQL.AppendLine('  l.Antal,');
      SQL.AppendLine('  l.SubVarenr,');
      SQL.AppendLine('  l.Tekst,');
      SQL.AppendLine('  t.tilsksyg,');
      SQL.AppendLine('  t.tilskkom1,');
      SQL.AppendLine('  t.tilskkom2,');
      SQL.AppendLine('  t.andel,');
      SQL.AppendLine('  t.udligning');
      SQL.AppendLine('FROM ekspliniersalg l');
      SQL.AppendLine('INNER JOIN ekspliniertilskud t');
      SQL.AppendLine('  ON t.lbnr = l.lbnr AND t.linienr = l.linienr');
      SQL.AppendLine('WHERE l.lbnr = :lbnr');
      SQL.AppendLine('ORDER BY l.linienr DESC');
      Result := SQL.ToString;
    finally
      SQL.Free;
    end;
  end;

  function FormatCurrency(Value: Currency): string;
  begin
    Result := FormCurr2Str('#####0.00', Value);
  end;


  procedure AddGebyrLine(PatLst: TStringList; const Dato, LbNr, Antal: string; const GebyrType: string; GebyrValue: Currency;
    var TotalPat: Currency);
  var
    TilAmt, TilKom, Patient, VareNr, VareNavn: string;
  begin
    TilAmt := FormatCurrency(0.0);
    TilKom := FormatCurrency(0.0);
    Patient := FormatCurrency(GebyrValue);
    TotalPat := TotalPat + GebyrValue;
    VareNr := '      '.PadRight(7, ' ');
    VareNavn := GebyrType.PadRight(20, ' ');
    PatLst.Add(Dato + LbNr + VareNr + VareNavn + Antal + TilAmt + TilKom + Patient);
  end;

begin
  PatLst := TStringList.Create;
  try
    PatLst.Capacity := 1000;  // this is to optimise the memory creation of the tstringlist.
    TotalSyg := 0;
    TotalKom := 0;
    TotalPat := 0;
    PNr := 0;

    var LQry := TnxQuery.Create(nil);
    try
      LQry.Database := AnXdb;
      LQry.SQL.Text := BuildHeaderSql;
      LQry.ParamByName('kundenr').AsString := AKundeNr;
      LQry.ParamByName('StartDate').AsDateTime := AFraDato;
      LQry.ParamByName('EndDate').AsDateTime := ATilDato;
      LQry.Open;

      while not LQry.Eof do
      begin
        try
          LKundenr := AKundeNr;
          LKundenavn := LQry.FieldByName(fnEkspeditionerNavn).AsString;
          var LLBnr := LQry.FieldByName('lbnr').AsInteger;
          LbNr := Format('%8d', [LLBnr]);
          LbNr := LbNr + ' ';
          Dato := FormatDateTime('ddmmyy', LQry.FieldByName('AfsluttetDato').AsDateTime);
          YderNavn := trim(LQry.FieldByName('YderNavn').AsString);
          LOrdreType := LQry.FieldByName(fnEkspeditionerOrdreType).AsInteger;

          var LLinesQry := TnxQuery.Create(nil);
          try
            LLinesQry.Database := AnXdb;
            LLinesQry.SQL.Text := BuildLinesSql;
            LLinesQry.ParamByName(fnEkspeditionerLbNr).AsInteger := LLbnr;
            LLinesQry.Open;
            while not LLinesQry.Eof do
            begin
              Syg := Abs(LLinesQry.FieldByName(fnEkspLinierTilskudTilskSyg).AsCurrency);
              Kom := Abs(LLinesQry.FieldByName(fnEkspLinierTilskudTilskKom1).AsCurrency) +
                Abs(LLinesQry.FieldByName(fnEkspLinierTilskudTilskKom2).AsCurrency);
              Pat := Abs(LLinesQry.FieldByName(fnEkspLinierTilskudAndel).AsCurrency);
              var LAntal := LLinesQry.FieldByName(fnEkspLinierSalgAntal).AsInteger;
              if LLinesQry.FieldByName(fnEkspLinierTilskudUdligning).AsCurrency <> 0 then
                Syg := -Pat;
              if LOrdreType = 2 then
              begin
                Syg := -Syg;
                Kom := -Kom;
                Pat := -Pat;
                Antal := Format('%3d', [-LAntal]);
              end
              else
                Antal := Format('%3d', [LAntal]);
              TotalSyg := TotalSyg + Syg;
              TotalKom := TotalKom + Kom;
              TotalPat := TotalPat + Pat;

              TilAmt := FormatCurrency(Syg);
              TilKom := FormatCurrency(Kom);
              Patient := FormatCurrency(Pat);
              VareNr := trim(LLinesQry.FieldByName(fnEkspLinierSalgSubVareNr).AsString);
              VareNr := VareNr.PadRight(7, ' ');
              VareNavn := copy(LLinesQry.FieldByName(fnEkspLinierSalgTekst).AsString, 1, 20);
              VareNavn := VareNavn.PadRight(20, ' ');
              PatLst.add(Dato + LbNr + VareNr + VareNavn + Antal + TilAmt + TilKom + Patient);
              LLinesQry.next;
            end;

          finally
            LLinesQry.Free;
          end;


          // add the gebyr lines
          for var GebyrField in [fnEkspeditionerUdbrGebyr, fnEkspeditionerEdbGebyr, fnEkspeditionerTlfGebyr] do
          begin
            gebyr := LQry.FieldByName(GebyrField).AsCurrency;
            if gebyr <> 0.0 then
            begin
              if LOrdreType = 2 then
                gebyr := -gebyr;
              Antal := '   ';
              if GebyrField = fnEkspeditionerUdbrGebyr then
                AddGebyrLine(PatLst, Dato, LbNr, Antal, 'Udbr.Gebyr', gebyr, TotalPat);
              if GebyrField = fnEkspeditionerEdbGebyr then
                AddGebyrLine(PatLst, Dato, LbNr, Antal, 'Edb.Gebyr', gebyr, TotalPat);
              if GebyrField = fnEkspeditionertlfGebyr then
                AddGebyrLine(PatLst, Dato, LbNr, Antal, 'Tlf.Gebyr', gebyr, TotalPat);

            end;
          end;

        finally
          LQry.Next;
        end;
      end;

    finally
      LQry.Free;
    end;

    PatLst.add(' ');
    PatLst.add('I alt' + StringOfChar(' ', 40) + FormCurr2Str('#####0.00', TotalSyg) + FormCurr2Str('#####0.00', TotalKom) +
      FormCurr2Str('#####0.00', TotalPat));
    PatLst.add(StringOfChar('=', 72));
    PatLst.add('');
    PatLst.add('');
    // PatLst.add('Vejledende pris for udskrift kr. ' + Trim(Pris_ekspliste) +
    // ' incl. moms pr. påbegyndt side dog max.');
    // PatLst.add('kr. 200 incl. moms for hele listen.');
    PatLst.add('');
    PatLst.Insert(0, 'Dato    Løbenr Nr     Beskrivelse       Antal   Region  Kommune    Andel');
    PatLst.Insert(0, 'Ekspeditionens Vare   og                       Tilskud  Tilskud  Patient');
    PatLst.Insert(0, 'Udskrevet for ' +LKundenr + ' ' + BytNavn(LKundenavn) + ' ' +
      FormatDateTime('dd/mm/yyyy', AFraDato) + ' - ' + FormatDateTime('dd/mm/yyyy', ATilDato));
    PatLst.Insert(0, GetFirmaNavn(AnXdb));
    PatLst.Insert(0, 'E K S P E D I T I O N S - L I S T E');
    PatLst.SaveToFile('C:\C2\Temp\EkspListe.Txt');
    PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\EkspListe.Txt');
  finally
    PatLst.Free;
  end;
end;

procedure CF3DetailedKundeList2(AnXdb : TnxDatabase; const AKundeNr : string;AFraDato: TdateTime; ATilDato :TdateTime);
var
  LPrintList: Tlist<Integer>;
  ilbnr: Integer;
  credlbnr: Integer;
  credlinlbnr: Integer;
  LPatLst: TStringList;
  LPrnString: string;
  PNr: Word;
  LKundeNavn : string;

  function BuildHeaderSql: string;
  begin
    var LSQl := TStringBuilder.Create;
    try
      LSQl.AppendLine('SELECT');
      LSQl.AppendLine('  ' + fnEkspeditionerLbNr);
      LSQl.AppendLine('  ' + fnEkspeditionerOrdreType_K);
      LSQl.AppendLine('  ' + fnEkspeditionerOrdreStatus_K);
      LSQl.AppendLine('  ' + fnEkspeditionerAfsluttetDato_K);
      LSQl.AppendLine('  ' + fnEkspeditionerYderNavn_K);
      LSQl.AppendLine('  ' + fnEkspeditionerUdbrGebyr_K);
      LSQl.AppendLine('  ' + fnEkspeditionerEdbGebyr_K);
      LSQl.AppendLine('  ' + fnEkspeditionerTlfGebyr_K);
      LSQl.AppendLine('  ' + fnEkspeditionerKundeNr_K);
      LSQl.AppendLine('  ' + fnEkspeditionerNavn_K);
      LSQl.AppendLine('  ' + fnEkspeditionerTakserDato_K);
      LSQl.AppendLine('  ' + fnEkspeditionerUdlignNr_K);
      LSQl.AppendLine('FROM ' + tnEkspeditioner);
      LSQl.AppendLine('WHERE ');
      LSQl.AppendLine('  ' + fnEkspeditionerKundeNr_P);
      LSQl.AppendLine('  AND ' + fnEkspeditionerOrdreType + '<>2');
      LSQl.AppendLine('  AND ' + fnEkspeditionerTakserDato + ' BETWEEN :StartDate AND :EndDate');
      LSQl.AppendLine('ORDER BY');
      LSQl.AppendLine(fnEkspeditionerLbNr);
    finally
      Result := LSQl.ToString;
      LSQl.Free;
    end;
  end;

  function BuildLinesSql : string;
  begin
    var LSQl := TStringBuilder.Create;
    try

      LSQl.AppendLine('SELECT ');
      LSQl.AppendLine('  lbnr,');
      LSQl.AppendLine('  linienr,');
      LSQl.AppendLine('  Antal,');
      LSQl.AppendLine('  SubVarenr,');
      LSQl.AppendLine('  Tekst');
      LSQl.AppendLine('FROM ekspliniersalg');
      LSQl.AppendLine('WHERE');
      LSQl.AppendLine('  lbnr=:lbnr');
      LSQl.AppendLine('ORDER BY');
      LSQl.AppendLine('  linienr desc');

    finally
      Result := LSQl.ToString;
      LSQl.Free;
    end;
  end;

  function BuildEkspeditionerCreditSql : string;
  begin
    var LSQl := TStringBuilder.Create;
    try
      LSQl.AppendLine('SELECT');
      LSQl.AppendLine('  ' + fnEkspeditionerCreditCreditLbnr);
      LSQl.AppendLine('  ' + fnEkspeditionerCreditDelvisAntal_K);
      LSQl.AppendLine('  ' + fnEkspeditionerCreditDelvisDato_K);
      LSQl.AppendLine('FROM ' + tnEkspeditionerCredit);
      LSQl.AppendLine('WHERE');
      LSQl.AppendLine('  ' + fnEkspeditionerCreditOldLbnr_P);
      LSQl.AppendLine('AND');
      LSQl.AppendLine('  ' + fnEkspeditionerCreditOldLin_P);
    finally
      Result := LSQl.ToString;
      LSQl.Free;
    end;
  end;

  function GetTakseringsDatoForEkspedition(ANxDb: TnxDatabase; ALbNr: Integer): TDateTime;
  var
    LQry: TnxQuery;
  begin
    Result := 0; // Default value if no result is found
    LQry := TnxQuery.Create(nil);
    try
      LQry.Database := ANxDb;
      LQry.SQL.Text := 'SELECT ' + fnEkspeditionerTakserDato +
                       ' FROM ' + tnEkspeditioner +
                       ' WHERE ' + fnEkspeditionerLbNr + ' = :LbNr';
      LQry.ParamByName('LbNr').AsInteger := ALbNr;
      LQry.Open;
      if not LQry.Eof then
        Result := LQry.FieldByName(fnEkspeditionerTakserDato).AsDateTime;
    finally
      LQry.Free;
    end;
  end;


begin
  PNr := 0;
  LPrintList := Tlist<Integer>.Create;
  LPatLst := TStringList.Create;
  try
    LPatLst.Capacity := 1000;
    var LHeaderQry := TnxQuery.Create(nil);
    try
      LHeaderQry.Database := AnXdb;
      LHeaderQry.SQL.Text := BuildHeaderSql;
      LHeaderQry.ParamByName(fnEkspeditionerKundeNr).AsString := AKundeNr;
      LHeaderQry.ParamByName('StartDate').AsDateTime := AFraDato;
      LHeaderQry.ParamByName('EndDate').AsDateTime := ATilDato;
      LHeaderQry.Open;
      if LHeaderQry.IsEmpty then
        Exit;
      while not LHeaderQry.Eof do
      begin
        ilbnr := LHeaderQry.FieldByName(fnEkspeditionerLbNr).AsInteger;
        LKundenavn := LHeaderQry.FieldByName(fnEkspeditionerNavn).AsString;
        var LordreStatus := LHeaderQry.FieldByName(fnEkspeditionerOrdreStatus).AsInteger;
        if LPrintList.Contains(ilbnr) then
        begin
          LHeaderQry.Next;
          Continue;
        end;
        credlbnr := LHeaderQry.FieldByName(fnEkspeditionerUdlignNr).AsInteger;
        var LLinesQry := TnxQuery.Create(Nil);
        try
          LLinesQry.Database := AnXdb;
          LLinesQry.sql.Text := BuildLinesSql;
          LLinesQry.ParamByName(fnEkspLinierSalgLbNr).AsInteger := ilbnr;
          LLinesQry.Open;
          while not LLinesQry.Eof do
          begin
            var LSubVarenr := LLinesQry.FieldByName(fnEkspLinierSalgSubVareNr).AsString;
            var LTekst := LLinesQry.FieldByName(fnEkspLinierSalgTekst).AsString;
            var LAntal := LLinesQry.FieldByName(fnEkspLinierSalgAntal).AsInteger;
            var LCreditQry := TnxQuery.Create(Nil);
            try
              LCreditQry.Database := AnXdb;
              LCreditQry.SQL.Text := BuildEkspeditionerCreditSql;
              LCreditQry.ParamByName(fnEkspeditionerCreditOldLbnr).AsInteger := ilbnr;
              LCreditQry.ParamByName(fnEkspeditionerCreditOldLin).AsInteger :=
                LLinesQry.FieldByName(fnEkspLinierSalgLinieNr).asinteger;
              LCreditQry.Open;
              if LCreditQry.IsEmpty then
              begin
                if LPrintList.Contains(ilbnr) then
                  LPrnString := '        '
                else
                begin
                  LPrnString := Format('%-8.d', [ilbnr]);
                  LPrintList.add(ilbnr);
                end;

                if credlbnr <> 0 then
                begin
                  LPrnString := LPrnString + ' ' + Format('%-8.d', [credlbnr]);
                  if not LPrintList.Contains(credlbnr) then
                    LPrintList.add(credlbnr);
                end
                else
                  LPrnString := LPrnString + '         ';
                LPrnString := LPrnString + ' ' + LSubVarenr;
                LPrnString := LPrnString + ' ' + Format('%-20s', [copy(LTekst, 1, 20)]);
                LPrnString := LPrnString + ' ' + Format('%-5.d', [LAntal]);
                if credlbnr <> 0 then
                begin
                  LPrnString := LPrnString + ' ' + Format('%-5.d', [LAntal]);
                  LPrnString := LPrnString + ' ' + FormatDateTime('dd-mm-yy',GetTakseringsDatoForEkspedition(AnXdb,credlbnr));

                end
                else
                begin
                  LPrnString := LPrnString + ' ' + StringOfChar(' ', 5);
                  LPrnString := LPrnString + ' ' + StringOfChar(' ', 8);

                end;
                if LordreStatus = 1 then
                  LPrnString := LPrnString + ' Åben'
                else
                  LPrnString := LPrnString + ' Afsluttet';
                LPatLst.add(LPrnString);
              end
              else
              begin
                LCreditQry.First;
                while not LCreditQry.Eof do
                begin
                  var LDelvisAntal := LCreditQry.FieldByName(fnEkspeditionerCreditDelvisAntal).AsInteger;
                  var LDelvisDatoStr := LCreditQry.FieldByName(fnEkspeditionerCreditDelvisDato).AsString;
                  var LDelvisDato := LCreditQry.FieldByName(fnEkspeditionerCreditDelvisDato).AsDateTime;
                  if LPrintList.Contains(ilbnr) then
                    LPrnString := '        '
                  else
                  begin
                    LPrnString := Format('%-8.d', [ilbnr]);
                    LPrintList.add(ilbnr);
                  end;
                  credlinlbnr := LCreditQry.FieldByName(fnEkspeditionerCreditCreditLbnr).AsInteger;
                  LPrnString := LPrnString + ' ' + Format('%-8.d', [credlinlbnr]);
                  if not LPrintList.Contains(credlinlbnr) then
                    LPrintList.add(credlinlbnr);
                  LPrnString := LPrnString + ' ' + LSubVarenr;
                  LPrnString := LPrnString + ' ' + Format('%-20s', [copy(LTekst, 1, 20)]);
                  LPrnString := LPrnString + ' ' + Format('%-5.d', [LAntal]);
                  if LDelvisAntal <> 0 then
                    LPrnString := LPrnString + ' ' + Format('%-5.d', [LDelvisAntal])
                  else
                    LPrnString := LPrnString + ' ' + Format('%-5.d', [LAntal]);
                  if LDelvisDatoStr = '' then
                    LPrnString := LPrnString + ' ' + Format('%-8s', [''])
                  else
                    LPrnString := LPrnString + ' ' + FormatDateTime('dd-mm-yy', LDelvisDato);

                  if LordreStatus = 1 then
                    LPrnString := LPrnString + ' Åben'
                  else
                    LPrnString := LPrnString + ' Afsluttet';
                  LPatLst.add(LPrnString);
                  LCreditQry.Next;
                end;

              end;

            finally
               LCreditQry.Free;
            end;

            LLinesQry.Next;

          end;

        finally
          LLinesQry.Free;
        end;

        LHeaderQry.Next;
        LPatLst.add('');
      end;

    finally
      LHeaderQry.Free;
    end;

    LPatLst.Insert(0, 'løbenr   løbenr                               pak   kred  retur            ');
    LPatLst.Insert(0, 'Eksp     Retur    Varenr Varenavn             Ant   Ant   Dato for Status  ');
    LPatLst.Insert(0, 'Udskrevet for ' + AKundeNr + ' ' + BytNavn(LKundeNavn));
    LPatLst.Insert(0, GetFirmaNavn(AnXdb));
    LPatLst.Insert(0, 'E K S P E D I T I O N S - L I S T E');
    LPatLst.SaveToFile('C:\C2\Temp\EkspListe.Txt');
    PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\EkspListe.Txt');
  finally
    LPatLst.Free;
    LPrintList.Free;
  end;


end;

end.
