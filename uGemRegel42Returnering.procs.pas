unit uGemRegel42Returnering.procs;

{ Developed by: Vitec Cito A/S

  Description: Efterregistering routines

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  26-08-2025/cjs  Corrected the fault of printing wrong ekspdirtion labels after efterregestering

  30-07-2025/cjs  Stopped the printing of etikets when processing CTR Efterregistering.

  22-07-2025/cjs  The printer routine call changing the lbnr back.  This is now fixed so tat the correct lbnr is
                  written to the Opdater Ctr queue.

  22-07-2025/cjs  CTR EFterReg :The old version would set the brugerkontrol to the brugertakser in the
                  new sales ekspedition. This is now removed.

  22-07-2025/cjs  Correction to efterregístering after Nana testing.

  21-07-2025/cjs  Corrected the creation of new salgsline and tilskud lines during efterregistering
}

interface

uses
  nxdb, System.SysUtils, DB, Winapi.Windows, System.Classes, Vcl.Dialogs, Forms, uC2Bruger.Types, uC2Fmk.common.types,
  uC2Common.Procs, uc2common.types;

procedure GemRegel42Returnering(var ALbNr: integer; var ALinienr: integer; ALinantal: integer);

var
  AfslLbNr: integer;
  AfslPakkeNr: LongWord;
  PartialCredit: Boolean;
  LRes: Word;
  LServerDateTime: TDateTime;
  LAllLiner: Boolean;

implementation

uses
  DM, uC2Fmk, ChkBoxes, C2MainLog, C2Procs, uGemRegel42Returnering.types;

procedure CopyMatchingFields(ASourceDS, ADestDS: TDataSet);
var
  DestField: TField;
begin
  for var SrcField in ASourceDS.Fields do
  begin
    if SrcField.FieldKind <> fkData then
      Continue;

    DestField := ADestDS.FindField(SrcField.FieldName);
    if Assigned(DestField) then
      DestField.Value := SrcField.Value
    else
      c2logadd('Field not found in destination: ' + SrcField.FieldName);
  end;
end;

procedure CancelWithLog(ADataSet: TDataSet; const AContext: string);
begin
  try
    ADataSet.Cancel;
  except
    on E: Exception do
      c2logadd('Error canceling in ' + AContext + ': ' + E.Message);
  end;
end;

procedure EditRecepturOplysninger;
var
  Lsave_index: string;
begin
  try
    LRes := STEP_EDIT_RCP_OPLYS;
    MainDm.ffRcpOpl.First;
    AfslLbNr := MainDm.ffRcpOplLbNr.Value;
    Lsave_index := SaveAndAdjustIndexName(MainDm.ffEksKar, 'NrOrden');
    try
      MainDm.ffEksKar.Last;
      if MainDm.ffEksKarLbNr.AsInteger >= AfslLbNr then
        AfslLbNr := MainDm.ffEksKarLbNr.AsInteger + 1;
    finally
      AdjustIndexName(MainDm.ffEksKar, Lsave_index);
    end;
    MainDm.ffRcpOpl.Edit;
    MainDm.ffRcpOplLbNr.Value := AfslLbNr + 1;
    C2LogAddF('Edit EditRecepturOplysninger : Afslbnr : %d',[AfslLbnr]);
    AfslPakkeNr := 0;
    // Tildel pakkenr hvis der var pakkenr i forvejen
    if Trim(MainDm.ffRetEks.FieldByName('KontoNr').AsString) <> '' then
    begin
      if MainDm.ffRetEks.FieldByName('PakkeNr').Value > 0 then
      begin
        AfslPakkeNr := MainDm.ffRcpOplPakkeNr.Value;
        MainDm.ffRcpOplPakkeNr.Value := MainDm.ffRcpOplPakkeNr.Value + 1;
      end;
    end;
    LRes := STEP_RCP_OPLYS_POST;
    MainDm.ffRcpOpl.Post;
  except
    on E: Exception do
    begin
      c2logadd('Error in EditRecepturOplysninger ' + E.Message);
      CancelWithLog(MainDm.ffRcpOpl, 'Error cancel edit in EditRecepturOplysninger ');
      raise;
    end;
  end;
end;

procedure InsertEkspLinierSalg(ALineNo: integer; AAntal: integer);
begin
  try
    LRes := STEP_INSERT_EKSPLIN_SALG;
    MainDm.ffEksLin.Insert;
      // Overfør alle felter fra ffLinOvr til ffEksLin
    CopyMatchingFields(MainDm.ffRetLin, MainDm.ffEksLin);
      // Ret nøglefelter m.m.
    C2LogAddF(' InsertEksplinierSalg : Afslbnr : %d',[AfslLbnr]);
    MainDm.ffEksLinLbNr.Value := AfslLbNr;
    MainDm.ffEksLinLinieNr.Value := ALineNo;
    MainDm.ffEksLinAntal.AsInteger := AAntal;
    if MainDm.ffEksKarOrdreType.AsInteger = ORDRETYPE_NORMAL then
    begin
      MainDm.ffEksLinDKType.AsInteger := DKTYPE_SYGEHJAELP;
      MainDm.ffEksLinTilskType.AsInteger := 1;

    end;
    C2LogAddF('antal is %d original antal is %d', [AAntal, MainDm.ffRetLin.FieldByName('Antal').AsInteger]);
    if AAntal <> 0 then
    begin
      if MainDm.ffRetLin.FieldByName('Antal').AsInteger <> AAntal then
      begin
        PartialCredit := True;
        c2logadd('Partial Credit is true ');
        MainDm.ffEksLinVareForbrug.AsCurrency := MainDm.ffEksLinKostPris.AsCurrency * AAntal;
        MainDm.ffEksLinBrutto.AsCurrency := MainDm.ffEksLinPris.AsCurrency * AAntal;
        MainDm.ffEksLinExMoms.AsCurrency := (MainDm.ffEksLinBrutto.AsCurrency * 100) / (MainDm.ffEksLinMomsPct.AsCurrency + 100);
        MainDm.ffEksLinExMoms.AsCurrency := RoundDecCurr(MainDm.ffEksLinExMoms.AsCurrency);
        MainDm.ffEksLinMoms.AsCurrency := MainDm.ffEksLinBrutto.AsCurrency - MainDm.ffEksLinExMoms.AsCurrency;
        MainDm.ffEksLinNetto.AsCurrency := MainDm.ffEksLinBrutto.AsCurrency;
      end;
      MainDm.ffEksLinAntal.AsInteger := AAntal;
    end;
    LRes := STEP_INSERT_EKSPLIN_SALG_POST;
    MainDm.ffEksLin.Post;

  except
    on E: Exception do
    begin
      c2logadd('Error in tr_InsertEkspLinierSalg ' + E.Message);
      CancelWithLog(MainDm.ffEksLin, 'Error cancel tr_InsertEkspLinierSalg ');
      raise;
    end;
  end;
end;

procedure InsertEkspeditionerCredit(ALbnr, ALin: integer; AAntal: integer);
begin
  try
    MainDm.nxEksCred.Insert;
    MainDm.nxEksCred.FieldByName('OldLbnr').AsInteger := ALbnr;
    MainDm.nxEksCred.FieldByName('OldLin').AsInteger := ALin;
    MainDm.nxEksCred.FieldByName('CreditLbnr').AsInteger := MainDm.ffEksKarLbNr.AsInteger;
    MainDm.nxEksCred.FieldByName('DelvisDato').AsDateTime := LServerDateTime;
    MainDm.nxEksCred.FieldByName('DelvisAntal').AsInteger := AAntal;
    MainDm.nxEksCred.Post;
  except
    on E: Exception do
    begin
      c2logadd('Error in InsertEkspeditionerCredit ' + E.Message);
      CancelWithLog(MainDm.nxEksCred, 'Error calling cancel in InsertEkspeditionerCredit ');
      raise;
    end;
  end;
end;

procedure InsertEkspLinierTilskud(ALin: integer; AAntal: integer; AOldAntal: integer);
begin
  try
    LRes := STEP_INSERT_EKSPLIN_TILSKUD;
    MainDm.ffEksTil.Insert;
      // Overfør alle felter fra ffTilOvr til ffEksTil
    CopyMatchingFields(MainDm.ffRetTil, MainDm.ffEksTil);
      // Ret nøglefelter m.m.
    C2LogAddF(' InsertEksplinierTilskud : Afslbnr : %d',[AfslLbnr]);
    MainDm.ffEksTilLbNr.Value := AfslLbNr;
    MainDm.ffEksTilLinieNr.Value := ALin;
    MainDm.ffEksTilCtrIndberettet.Value := 0;
      // Ret CTR saldo
    if MainDm.ffEksTilRegelSyg.Value in [41..43] then
    begin
      MainDm.ffEksKarCtrSaldo.AsCurrency := MainDm.ffEksTilSaldo.AsCurrency;
    end;
    if AAntal <> 0 then
    begin

      if AAntal <> AOldAntal then
      begin
        MainDm.ffEksTilIBPBel.AsCurrency := Oprund5Ore(MainDm.ffEksTilIBPBel.AsCurrency * AAntal / AOldAntal);
        MainDm.ffEksTilBGPBel.AsCurrency := Oprund5Ore(MainDm.ffEksTilBGPBel.AsCurrency * AAntal / AOldAntal);
        MainDm.ffEksTilIBTBel.AsCurrency := Oprund5Ore(MainDm.ffEksTilIBTBel.AsCurrency * AAntal / AOldAntal);
        MainDm.ffEksTilAndel.AsCurrency := Oprund5Ore(MainDm.ffEksTilAndel.AsCurrency * AAntal / AOldAntal);
        MainDm.ffEksTilTilskSyg.AsCurrency := Oprund5Ore(MainDm.ffEksTilTilskSyg.AsCurrency * AAntal / AOldAntal);
        MainDm.ffEksTilTilskKom1.AsCurrency := Oprund5Ore(MainDm.ffEksTilTilskKom1.AsCurrency * AAntal / AOldAntal);
        MainDm.ffEksTilTilskKom2.AsCurrency := Oprund5Ore(MainDm.ffEksTilTilskKom2.AsCurrency * AAntal / AOldAntal);
      end;
    end;
      // IF MainDm.ffEksTilBGP.AsCurrency <> 0 then
      // BGPZero := False;

    LRes := STEP_INSERT_EKSPLIN_TILSKUD_POST;
    MainDm.ffEksTil.Post;

  except
    on E: Exception do
    begin
      c2logadd('Error in InsertEkspLinierTilskud ' + E.Message);
      CancelWithLog(MainDm.ffEksTil, 'Error calling cancel in InsertEkspLinierTilskud ');
      raise;
    end;
  end;
end;

procedure InsertEksplinierEtiket(ALin: integer);
begin
  try
      // Ekspeditionsetiketter gemmes
    LRes := STEP_INSERT_ETIKET;
    MainDm.ffEksEtk.Insert;
      // Overfør alle felter fra ffTilOvr til ffEksTil
    CopyMatchingFields(MainDm.ffRetEtk, MainDm.ffEksEtk);
      // Ret nøglefelter m.m.
    C2LogAddF(' InsertEksplinierEtiket : Afslbnr : %d',[AfslLbnr]);
    MainDm.ffEksEtkLbNr.Value := AfslLbNr;
    MainDm.ffEksEtkLinieNr.Value := ALin;
    LRes := STEP_INSERT_ETIKET_POST;
    MainDm.ffEksEtk.Post;
  except
    on E: Exception do
    begin
      c2logadd('Error in InsertEksplinierEtiket ' + E.Message);
      CancelWithLog(MainDm.ffEksEtk, 'Error calling cancel in InsertEksplinierEtiket ');
      raise;
    end;
  end;
end;

procedure EditEkspLinierTilskud(var ACTRSaldo: Currency);
begin
  try
    LRes := STEP_EDIT_TILSKUD;
    MainDm.ffEksTil.Edit;
    MainDm.ffEksTilSaldo.AsCurrency := ACTRSaldo - MainDm.ffEksTilBGPBel.AsCurrency;
    ACTRSaldo := MainDm.ffEksTilSaldo.AsCurrency;
    LRes := STEP_EDIT_TILSKUD_POST;
    MainDm.ffEksTil.Post;

  except
    on E: Exception do
    begin
      c2logadd('Error in EditEkspLinierTilskud ' + E.Message);
      CancelWithLog(MainDm.ffEksTil, 'Error calling cancel in EditEkspLinierTilskud ');
      raise;
    end;
  end;
end;

procedure EditPatientkartotek(ACTRSaldo: Currency);
var
  LSavePatIndex: string;
begin
  LSavePatIndex := SaveAndAdjustIndexName(MainDm.ffPatUpd, 'NrOrden');
  try
    if MainDm.ffPatUpd.FindKey([MainDm.ffPatKarKundeNr.AsString]) then
    begin
      try
        MainDm.ffPatUpd.Edit;
        MainDm.ffPatUpdCtrSaldo.AsCurrency := ACTRSaldo;
        MainDm.ffPatUpd.Post;
      except
        on E: Exception do
        begin
          c2logadd('Error in EditPatientKartotek ' + E.Message);
          CancelWithLog(MainDm.ffPatUpd, 'Error calling cancel in EditPatientKartotek ');
          raise;
        end;
      end;
    end;
  finally
    AdjustIndexName(MainDm.ffPatUpd, LSavePatIndex);
  end;
end;

procedure ResetNewEkspeditionTotals;
begin
    // Nulstil totaler

  MainDm.ffEksKarCtrSaldo.AsCurrency := 0; // todo
    // ffEksKarCtrUdlign.AsCurrency       := mtEksCtrUdlign.AsCurrency;
  MainDm.ffEksKarDKTilsk.AsCurrency := 0;
  MainDm.ffEksKarDKEjTilsk.AsCurrency := 0;
  MainDm.ffEksKarRabatLin.AsCurrency := 0;
  MainDm.ffEksKarRabat.AsCurrency := 0;
  MainDm.ffEksKarExMoms.AsCurrency := 0;
  MainDm.ffEksKarMoms.AsCurrency := 0;
  MainDm.ffEksKarTilskKom.AsCurrency := 0;
  MainDm.ffEksKarTilskAmt.AsCurrency := 0;
  MainDm.ffEksKarAndel.AsCurrency := 0;
  MainDm.ffEksKarBrutto.AsCurrency := 0;
  MainDm.ffEksKarNetto.AsCurrency := 0;

end;

function CheckGebyrAndResetIfNeeded(ALbNr: Integer): Boolean;
begin
      // 1182 check to see if part of ekspedition has already been credited
      // if it has then set telefon,edb,udbr gebyr to 0
  Result := False;
  AdjustIndexName(MainDm.nxEksCred, 'LbnrOrden');
  MainDm.nxEksCred.SetRange([ALbNr], [ALbNr]);
  try
    if MainDm.nxEksCred.RecordCount = 0 then
      Exit(False);

    MainDm.nxEksCred.First;
    while not MainDm.nxEksCred.Eof do
    begin
      if MainDm.nxEksp.FindKey([MainDm.nxEksCred.FieldByName('CreditLbnr').AsInteger]) then
      begin
        if MainDm.nxEkspEdbGebyr.AsCurrency <> 0 then
          Exit(True);
        if MainDm.nxEkspTlfGebyr.AsCurrency <> 0 then
          Exit(True);
        if MainDm.nxEkspUdbrGebyr.AsCurrency <> 0 then
          Exit(True);
      end;
      MainDm.nxEksCred.Next;
    end;
  finally
    MainDm.nxEksCred.CancelRange;
  end;
end;

procedure UpdateHeaderTotalsBasedOnReturnedLline(ALbnr, ALinienr, ALinantal: integer);
begin
  var LCreditAntal := ALinantal;
  if MainDm.ffEksKarOrdreType.AsInteger = ORDRETYPE_RETUR then
    InsertEkspeditionerCredit(ALbnr, ALinienr, LCreditAntal);
        // Ekspeditionslinier gemmes
  InsertEkspLinierSalg(1, LCreditAntal);
  MainDm.ffEksKarExMoms.AsCurrency := MainDm.ffEksKarExMoms.AsCurrency + MainDm.ffEksLinExMoms.AsCurrency;
  MainDm.ffEksKarMoms.AsCurrency := MainDm.ffEksKarMoms.AsCurrency + MainDm.ffEksLinMoms.AsCurrency;
  MainDm.ffEksKarBrutto.AsCurrency := MainDm.ffEksKarBrutto.AsCurrency + MainDm.ffEksLinBrutto.AsCurrency;
  MainDm.ffEksKarNetto.AsCurrency := MainDm.ffEksKarNetto.AsCurrency + MainDm.ffEksLinNetto.AsCurrency;

  if MainDm.ffRetTil.FindKey([ALbnr, ALinienr]) then
  begin
          // Ekspeditionstilskud gemmes
    InsertEkspLinierTilskud(1, LCreditAntal, MainDm.ffRetLin.FieldByName('Antal').AsInteger);

    MainDm.ffEksKarTilskKom.AsCurrency := MainDm.ffEksKarTilskKom.AsCurrency + MainDm.ffEksTilTilskKom1.AsCurrency +
      MainDm.ffEksTilTilskKom2.AsCurrency;
    MainDm.ffEksKarTilskAmt.AsCurrency := MainDm.ffEksKarTilskAmt.AsCurrency + MainDm.ffEksTilTilskSyg.AsCurrency;
    MainDm.ffEksKarAndel.AsCurrency := MainDm.ffEksKarAndel.AsCurrency + MainDm.ffEksTilAndel.AsCurrency;
          // todo
    if MainDm.ffEksLinDKType.AsInteger = DKTYPE_SYGEHJAELP then
      MainDm.ffEksKarDKTilsk.AsCurrency := MainDm.ffEksKarDKTilsk.AsCurrency + MainDm.ffEksTilAndel.AsCurrency;
    if MainDm.ffEksLinDKType.AsInteger = DKTYPE_EGENBETALING then
      MainDm.ffEksKarDKEjTilsk.AsCurrency := MainDm.ffEksKarDKEjTilsk.AsCurrency + MainDm.ffEksTilAndel.AsCurrency;

  end;

end;

procedure InsertEkspeditioner(ALbnr, ALinieNr, ALinAntal: Integer);
var
  LCTRSaldo : Currency;
begin
  C2LogAddF('Insert Ekspeditioner Lbnr : %d Linienr : %d Antal : %d',[ALbnr,ALinieNr,ALinAntal]);
  try
      // Ekspedition gemmes
    LRes := STEP_INSERT_EKSP;
    MainDm.ffEksKar.Insert;
      // Overfør alle felter fra ffRetEks til ffEksKar
    CopyMatchingFields(MainDm.ffRetEks, MainDm.ffEksKar);

    ResetNewEkspeditionTotals;

      // Ret nøglefelter m.m.
    C2LogAddF(' InsertEkspeditioner : Afslbnr : %d',[AfslLbnr]);
    MainDm.ffEksKarLbNr.Value := AfslLbNr;
    MainDm.ffEksKarTurNr.Value := 0;
    MainDm.ffEksKarPakkeNr.Value := AfslPakkeNr;
    MainDm.ffEksKarOrdreNr.Value := 0;
    MainDm.ffEksKarFakturaNr.Value := 0;
    MainDm.ffEksKarUdlignNr.Value := ALbnr;
    C2LogAddF('Ekspedition ordretype is %d',[MainDm.ffRetEks.FieldByName('Ordretype').AsInteger]);
    MainDm.ffEksKarOrdreType.Value := ORDRETYPE_RETUR; // Retur
    if MainDm.ffRetEks.FieldByName('Ordretype').AsInteger = ORDRETYPE_RETUR then
    begin
      MainDm.ffEksKarOrdreType.Value := ORDRETYPE_NORMAL;
      MainDm.ffEksKarUdlignNr.AsInteger := 0;
      MainDm.ffEksKarOrdreDato.AsDateTime := MainDm.ffRetEks.FieldByName('OrdreDato').AsDateTime;
    end;
    MainDm.ffEksKarTakserDato.AsDateTime := LServerDateTime;
    MainDm.ffEksKarAfsluttetDato.AsString := '';
    MainDm.ffEksKarOrdreStatus.Value := ORDRESTATUS_TAKSERET; // Takseret
    MainDm.ffEksKarReceptStatus.Value := RECEPTSTATUS_MANUAL; // Manuel
    MainDm.ffEksKarBrugerTakser.Value := MainDm.BrugerNr;
      // MainDm.ffEksKarBrugerKontrol.Value := 0;
    MainDm.ffEksKarBrugerAfslut.Value := 0;
    MainDm.ffEksKarCtrIndberettet.Value := 0;
    MainDm.ffEksKarDKIndberettet.Value := 0;

      // Gennemløb alle ordinationer


    if CheckGebyrAndResetIfNeeded(ALbnr) then
    begin
      MainDm.ffEksKarUdbrGebyr.AsCurrency := 0;
      MainDm.ffEksKarTlfGebyr.AsCurrency := 0;
      MainDm.ffEksKarEdbGebyr.AsCurrency := 0;
    end;

    if MainDm.ffRetLin.FindKey([ALbnr, ALinieNr]) then
    begin
      UpdateHeaderTotalsBasedOnReturnedLline(ALbnr, ALinieNr, ALinAntal);
      if MainDm.ffRetEtk.FindKey([ALbnr, ALinieNr]) then
      begin
        InsertEksplinierEtiket(1);
      end;
    end;

      // Reguler CTR

    var LSavePatIndex := SaveAndAdjustIndexName(MainDm.ffPatUpd, 'NrOrden');
    try
      if MainDm.ffPatUpd.FindKey([MainDm.ffEksKarKundeNr.AsString]) then
      begin
        LCTRSaldo := MainDm.ffPatUpdCtrSaldo.AsCurrency;
        C2LogAddF('patient start saldo is %f', [LCTRSaldo]);
        C2LogAddF(' InsertEkspeditioner 2 : Afslbnr : %d',[AfslLbnr]);
        if MainDm.ffEksTil.FindKey([AfslLbNr, 1]) then
        begin
            // Ret CTR saldo
          if MainDm.ffEksTilRegelSyg.Value in [41..43] then
            EditEkspLinierTilskud(LCTRSaldo);
        end;
        EditPatientkartotek(LCTRSaldo);
      end;
    finally
      AdjustIndexName(MainDm.ffPatUpd, LSavePatIndex);
    end;

      // Afslut hvis ikke afsluttet
    if LAllLiner then
    begin

      if MainDm.ffRetEks.FieldByName('OrdreStatus').AsInteger = ORDRESTATUS_TAKSERET then
      begin
        MainDm.ffEksKarKontoNr.AsString := '';
        MainDm.ffEksKarLeveringsForm.AsInteger := 0;
        MainDm.ffEksKarTurNr.AsInteger := 0;
        MainDm.ffEksKarPakkeNr.AsInteger := 0;
        MainDm.ffEksKarLevNavn.AsString := '';
        AfslPakkeNr := 0;
          // fejl 1072   ffEksKarUdbrGebyr    .AsCurrency:= 0;
        MainDm.ffEksKarOrdreStatus.AsInteger := ORDRESTATUS_AFSLUTTET; // Afsluttet
//        MainDm.ffEksKarBrugerKontrol.AsInteger := MainDm.ffEksKarBrugerTakser.AsInteger;
        MainDm.ffEksKarBrugerAfslut.AsInteger := MainDm.ffEksKarBrugerTakser.AsInteger;
        MainDm.ffEksKarAfsluttetDato.AsDateTime := MainDm.ffEksKarTakserDato.AsDateTime;
      end;
    end;

    LRes := STEP_INSERT_EKSP_POST;
    MainDm.ffEksKar.Post;

  except
    on E: Exception do
    begin
      c2logadd('Error in InsertEkspeditioner ' + E.Message);
      CancelWithLog(MainDm.ffEksKar, 'Error calling cancel in InsertEkspeditioner ');
      raise;
    end;

  end;
end;

procedure EditOldEkspeditioner;
begin
  try
    if LAllLiner then
    begin
      LRes := STEP_EDIT_OLD_EKSP;
      MainDm.ffRetEks.Edit;
      C2LogAddF(' EditOldEkspeditioner : Afslbnr : %d', [AfslLbnr]);
      MainDm.ffRetEks.FieldByName('UdlignNr').AsInteger := AfslLbNr;
        // Afslut hvis ikke afsluttet
      if MainDm.ffRetEks.FieldByName('OrdreStatus').AsInteger = ORDRESTATUS_TAKSERET then
      begin
        MainDm.ffRetEks.FieldByName('KontoNr').AsString := '';
        MainDm.ffRetEks.FieldByName('LeveringsForm').AsInteger := 0;
        MainDm.ffRetEks.FieldByName('TurNr').AsInteger := 0;
        MainDm.ffRetEks.FieldByName('PakkeNr').AsInteger := 0;
          // fejl 1072 MainDm.ffRetEks.FieldByName('UdbrGebyr'    ).AsCurrency:= 0;
        MainDm.ffRetEks.FieldByName('OrdreStatus').AsInteger := ORDRESTATUS_AFSLUTTET; // Afsluttet
        MainDm.ffRetEks.FieldByName('BrugerAfslut').AsInteger := MainDm.ffEksKarBrugerTakser.AsInteger;
        MainDm.ffRetEks.FieldByName('AfsluttetDato').AsDateTime := MainDm.ffEksKarTakserDato.AsDateTime;
        MainDm.ffRetEks.FieldByName('LevNavn').AsString := '';
        MainDm.DeleteLbnrFromEkspLeveringsListe(MainDm.ffRetEks.FieldByName('LbNr').AsInteger);
      end;
      if MainDm.ffEksKarOrdreType.AsInteger = ORDRETYPE_NORMAL then
        MainDm.ffRetEks.FieldByName('ReceptStatus').AsInteger := RECEPTSTATUS_CREDIT_UNDONE;
        // credit undone
      LRes := STEP_EDIT_OLD_EKSP_POST;
      MainDm.ffRetEks.Post;

    end;

  except
    on E: Exception do
    begin
      c2logadd('Error in EditOldEkspeditioner ' + E.Message);
      CancelWithLog(MainDm.ffRetEks, 'Error calling cancel in EditOldEkspeditioner ');
      raise;
    end;
  end;
end;

procedure GemRegel42Returnering(var ALbNr, ALinienr: integer; ALinantal: integer);
// ok this routine will create a return ekspedition of a line and then create a return of that
// new ekspedition.   the idea is that the bgp and regel of the newly created tilskud line
// will be updated in the main
var
  SaveNewLbnr : Integer;
begin
  // Returner ekspedition
  PartialCredit := False;
  AfslLbNr := 0;
  AfslPakkeNr := 0;
  if not MainDm.ffRetEks.FindKey([ALbNr]) then
    exit;
  LAllLiner := False;
  LRes := STEP_INIT;
  try
    C2LogAddF('Step 1 : Create return for Lbnr : %d Linienr : %d LinAntal : %d', [ALbNr, ALinienr, ALinantal]);
    MainDm.ffRcpOpl.DataBase.StartTransactionWith([MainDm.ffEksKar, MainDm.nxEksCred, MainDm.ffEksEtk, MainDm.ffEksLin,
      MainDm.ffEksTil, MainDm.ffPatUpd, MainDm.ffRcpOpl]);
    try
      MainDm.nxRemoteServerInfoPlugin1.GetServerDateTime(LServerDateTime);

      EditRecepturOplysninger;

      InsertEkspeditioner(ALbNr, ALinienr, ALinantal);
      C2LogAddF('1 MainDm.ffEksKarLbNr.Value is %d',[MainDm.ffEksKarLbNr.Value]);
      EditOldEkspeditioner;
      C2LogAddF('2 MainDm.ffEksKarLbNr.Value is %d',[MainDm.ffEksKarLbNr.Value]);
      SaveNewLbnr := MainDm.ffEksKarLbNr.AsInteger;

      MainDm.ffRcpOpl.DataBase.Commit;
      LRes := 0;
    except
      on E: Exception do
      begin
        c2logadd('  Exception, err ' + IntToStr(LRes));
        c2logadd('    Message "' + E.Message + '"');
        try
          MainDm.ffRcpOpl.DataBase.Rollback;
        except
          on E: Exception do
            c2logadd('Fejl i rollback ' + E.Message);
        end;
      end;
    end;
  finally
    if LRes <> 0 then
      ChkBoxOK('Fejl i returner ekspedition, fejl ' + IntToStr(LRes))
    else
    begin
      if MainDm.Recepturplads <> 'DYR' then
      try
      C2LogAddF('3 MainDm.ffEksKarLbNr.Value is %d',[MainDm.ffEksKarLbNr.Value]);
//        UbiAfstempling(False, False);
      C2LogAddF('4 MainDm.ffEksKarLbNr.Value is %d',[MainDm.ffEksKarLbNr.Value]);
      except
      end;
    end;
    // Returner true eller false
  end;
      C2LogAddF('5 MainDm.ffEksKarLbNr.Value is %d',[MainDm.ffEksKarLbNr.Value]);

  // now recredit the newly created ekspedition
  ALbNr := SaveNewLbnr;
  ALinienr := 1;
  C2LogAddF('Step 2 : Create salgsline for Lbnr : %d Linienr : %d LinAntal : %d', [ALbNr, ALinienr, ALinantal]);

  // Returner ekspedition
  PartialCredit := False;
  AfslLbNr := 0;
  AfslPakkeNr := 0;
  LAllLiner := True;
  if not MainDm.ffRetEks.FindKey([ALbNr]) then
    exit;

  LRes := STEP_INIT;
  try

    MainDm.ffRcpOpl.DataBase.StartTransactionWith([MainDm.ffEksKar, MainDm.nxEksCred, MainDm.ffEksEtk, MainDm.ffEksLin,
      MainDm.ffEksTil, MainDm.ffPatUpd, MainDm.ffRcpOpl]);
    try
      MainDm.nxRemoteServerInfoPlugin1.GetServerDateTime(LServerDateTime);

      EditRecepturOplysninger;

      InsertEkspeditioner(ALbNr, 1, ALinantal);

      EditOldEkspeditioner;
      SaveNewLbnr := MainDm.ffEksKarLbNr.AsInteger;
      MainDm.ffRcpOpl.DataBase.Commit;
      LRes := 0;
    except
      on E: Exception do
      begin
        c2logadd('  Exception, err ' + IntToStr(LRes));
        c2logadd('    Message "' + E.Message + '"');
        try
          MainDm.ffRcpOpl.DataBase.Rollback;
        except
          on E: Exception do
            c2logadd('Fejl i rollback ' + E.Message);
        end;
      end;
    end;
  finally
    if LRes <> 0 then
      ChkBoxOK('Fejl i returner ekspedition, fejl ' + IntToStr(LRes))
    else
    begin
      if MainDm.Recepturplads <> 'DYR' then
      try
//        UbiAfstempling(False, False);
      except
      end;
    end;
    // Returner true eller false
  end;

  ALbNr := SaveNewLbnr;
  ALinienr := 1;

end;

end.

