unit BeregnOrdinationu;

{ Developed by: Cito IT A/S

  Description: Beregnordination calculates the varios support fees for the line

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  26-06-2025/cjs  Change to beregn ordination to handle regel 73,74 (kontanthjælp) as it does with regel 75.
  04-02-2025/cjs  Regel59 work.

  13-12-2021/cjs  Changes for using the new CtrTilskudSatser table

  02-09-2019/cjs  reset the dk flag always in case the antal fielsd is reentered for some reason

}

interface

uses
  CtrTilskudsSatser;

procedure BeregnOrdination(saveDosiskortNr: integer);

implementation

uses
  Sysutils, DM, C2MainLog, c2Procs, CtrBevilling, uyesno, ChkBoxes, BevillingsOversigt, Main, system.Math, system.DateUtils,
  system.StrUtils;

function Akkumuler(var Saldo: Currency; var Koeb: Currency; Niveau: Currency): Currency;
var
  BGP: Currency;
begin
  Result := 0;
  BGP := 0;
  try
    if Koeb <= 0 then
      exit;
    if Saldo >= Niveau then
      exit;
    if Saldo + Koeb > Niveau then
    begin
      BGP := Niveau - Saldo;
      Koeb := Koeb - BGP;
    end
    else
    begin
      BGP := Koeb;
      Koeb := 0;
    end;
    Saldo := Saldo + BGP;
  finally
    Result := BGP;
  end;
end;

procedure BeregnBGP(Saldo, Koeb: currency; var BGP0, BGP1, BGP2, BGP3: Currency);
begin
  with MainDm do
  begin
    BGP0 := Akkumuler(Saldo, Koeb, TilskudsGrp1);
    BGP1 := Akkumuler(Saldo, Koeb, TilskudsGrp2);
    BGP2 := Akkumuler(Saldo, Koeb, TilskudsGrp3);
    BGP3 := Akkumuler(Saldo, Koeb, TilskudsGrpMax);
  end;
end;

function BeregnTilsk(Bel: Currency; Prm: Word): Currency;
begin
  Result := (Bel * Prm) / 1000;
end;

procedure BeregnSygesikring(TilKode: Word; TilRegel: Word; CtrType: Word; var CtrSaldo: Currency; var PRS: Currency; var Tilsk:
  Currency);
var
  Saldo, Koeb, BGP0, BGP1, BGP2, BGP3, BGP4: Currency;
begin
  with MainDm do
  begin
    try
      if TilKode <> 1 then
        exit;

      case CtrType of
        0, 10:
          begin // Kroniker voksen
            if CtrSaldo > KronikerGrpVoksen then
            begin
              Tilsk := PRS;
            end
            else
            begin
              Saldo := CtrSaldo;
              Koeb := PRS;
              BGP0 := Akkumuler(Saldo, Koeb, TilskudsGrp1);
              BGP1 := Akkumuler(Saldo, Koeb, TilskudsGrp2);
              BGP2 := Akkumuler(Saldo, Koeb, TilskudsGrp3);
              BGP3 := Akkumuler(Saldo, Koeb, KronikerGrpVoksen);
              BGP4 := Akkumuler(Saldo, Koeb, TilskudsGrpMax);
              Tilsk := Tilsk + BeregnTilsk(BGP0, TilskudsPctNorm1);
              Tilsk := Tilsk + BeregnTilsk(BGP1, TilskudsPctNorm2);
              Tilsk := Tilsk + BeregnTilsk(BGP2, TilskudsPctNorm3);
              Tilsk := Tilsk + BeregnTilsk(BGP3, TilskudsPctNorm4);
              Tilsk := Tilsk + BGP4;
            end;
          end;
        1, 11:
          begin // Kroniker barn
            if CtrSaldo > KronikerGrpBarn then
            begin
              Tilsk := PRS;
            end
            else
            begin
              Saldo := CtrSaldo;
              Koeb := PRS;
              BGP0 := Akkumuler(Saldo, Koeb, TilskudsGrp1);
              BGP1 := Akkumuler(Saldo, Koeb, TilskudsGrp2);
              BGP2 := Akkumuler(Saldo, Koeb, TilskudsGrp3);
              BGP3 := Akkumuler(Saldo, Koeb, KronikerGrpBarn);
              BGP4 := Akkumuler(Saldo, Koeb, TilskudsGrpMax);
              Tilsk := Tilsk + BeregnTilsk(BGP0, TilskudsPctBarn1);
              Tilsk := Tilsk + BeregnTilsk(BGP1, TilskudsPctBarn2);
              Tilsk := Tilsk + BeregnTilsk(BGP2, TilskudsPctBarn3);
              Tilsk := Tilsk + BeregnTilsk(BGP3, TilskudsPctBarn4);
              Tilsk := Tilsk + BGP4;
            end;
          end;
      end;
    finally
      Tilsk := Oprund5Ore(Tilsk);
    end;
  end;
end;

procedure BeregnMedkort(TilKode: Word; CtrType: Word; CtrSaldo: Currency; ESP: Currency; BGP: Currency; Prm: Word; var Tilsk:
  Currency);
begin
  try
    if TilKode <> 1 then
    begin
      Tilsk := BeregnTilsk(ESP, Prm);
      exit;
    end;
//      // Medicinkort efter BGP
//      case CtrType of
//        01 : PrmC := TilPctBarn1;  // Almen barn
//        11 : PrmC := TilPctBarn1;  // Kroniker barn
//      else
//        PrmC := TilPctNorm1;  // Almen voksen, Kroniker voksen, andre
//      end;
    BeregnSygesikring(MainDm.mtLinTilskType.Value, MainDm.mtLinRegelSyg.Value, MainDm.mtEksCtrType.Value, CtrSaldo, BGP, Tilsk);
    if BGP > Tilsk then
    begin

      Tilsk := BeregnTilsk(BGP - Tilsk, Prm);
    end
    else
      Tilsk := 0;

  finally
    Tilsk := Oprund5Ore(Tilsk);
  end;
end;

procedure BeregnDanmark;
begin
  C2LogAdd('Beregn danmark start');
  try
    MainDm.mtLinDKTilsk.AsCurrency := 0;
    MainDm.mtLinDKEjTilsk.AsCurrency := 0;
      // reset the dk flag always in case the antal fielsd is reentered for some reason
    MainDm.mtLinDKType.AsInteger := 0;

    if MainDm.mtLinUdligning.AsCurrency <> 0 then
    begin
      MainDm.mtLinDKTilsk.AsCurrency := MainDm.mtLinAndel.AsCurrency;
      MainDm.mtLinDKType.AsInteger := 1;
      exit;
    end;

    if MainDm.mtLinTilskType.Value = 1 then
    begin
      MainDm.mtLinDKTilsk.AsCurrency := MainDm.mtLinAndel.AsCurrency;
      MainDm.mtLinDKType.AsInteger := 1;
      exit;
    end;
    if MainDm.mtLinUdlevType.AsString = '' then
      exit;
    if (Pos('HA', MainDm.mtLinUdLevType.AsString) = 0) and (Pos('HV', MainDm.mtLinUdLevType.AsString) = 0) and
      (Pos('HF', MainDm.mtLinUdLevType.AsString) = 0) then
    begin
      if not (MainDm.mtLinATCKode.AsString.StartsWith('G02B') or
        MainDm.mtLinATCKode.AsString.StartsWith('G03A') or
        SameText('G03HB01', MainDm.mtLinATCKode.AsString) or
        SameText(MainDm.mtLinSubVareNr.AsString, '017020') or
        MainDm.mtLinATCKode.AsString.StartsWith('A10B') or
        MainDm.mtLinATCKode.AsString.StartsWith('A08A') or
        MainDm.mtLinATCKode.AsString.StartsWith('M03AX01')) then
      begin
        MainDm.mtLinDKEjTilsk.AsCurrency := MainDm.mtLinAndel.AsCurrency;
        MainDm.mtLinDKType.AsInteger := 2;
      end;
    end;
  finally
    C2LogAddF('  Type %d Afs1 %f Afs2 %f', [MainDm.mtLinDKType.AsInteger, MainDm.mtLinDKTilsk.AsCurrency,
      MainDm.mtLinDKEjTilsk.AsCurrency]);
    C2LogAdd('Beregn danmark slut');
  end;
end;

procedure BeregnOrdination(saveDosiskortNr: integer);
var
  VareNr: string;
  WBGP, ESP, DOSISESP, BGP, DOSISBGP, Saldo, Tilsk, Andel: Currency;
  Syg42, Syg43, Syg47, BevOk: Boolean;
  klausbool: Boolean;
  tilATCkode: string;
  atclen: integer;
  SkipQuestion: boolean;
  Question: string;
  SygPrm00, KomPrm10, KomPrm11, KomPrm12, KomPrm13, KomPrm14, KomPrm20, KomPrm21, KomPrm22, KomPrm23, KomPrm24: Word;

  procedure process_CTRBevillinger;
  begin
    with MainDm{,TakserDosisForm} do
    begin
      // CTR bevillinger
      C2LogAdd('CTR bevillinger ordination start ' + IntToStr(cdCtrBev.RecordCount));
      try
        if cdCtrBev.RecordCount = 0 then
          exit;
        // Check for typer af bevillinger
        Syg42 := FALSE;
        Syg43 := FALSE;
        cdCtrBev.First;
        while not cdCtrBev.Eof do
        begin
          if DateInRange(Date, DateOf(cdCtrBevFraDato.AsDateTime), DateOf(cdCtrBevTilDato.AsDateTime)) then
          begin
            if cdCtrBevRegel.Value = 42 then
              Syg42 := TRUE;
            if cdCtrBevRegel.Value = 43 then
              Syg43 := TRUE;
          end;
          cdCtrBev.Next;
        end;
// dosis
//        if ( not Syg42) and ( not Syg43) and (mtEksReceptStatus.AsInteger = 999) then
//        begin
//          save_DCLindex := ffdcl.IndexName;
//          ffdcl.IndexName := 'cardvaren';
//          try
//            if ffdcl.FindKey([SaveDosisKortNr,mtLinVareNr.AsString]) then
//            begin
//              ffdcl.Edit;
//              ffdclRegel4243.Clear;
//              ffdcl.Post;
//            end;
//          finally
//            ffdcl.IndexName := save_DCLindex;
//          end;
//
//        end;
        // Check bevillinger
        if mtLinSSKode.AsString = '' then
          Syg43 := False;
        if ((Syg42) and (mtLinTilskType.Value = 0)) or (Syg43) then
        begin
          C2LogAdd('  Syg42 eller Syg43');
          VareNr := Trim(mtLinVareNr.AsString);
          if VareNr = '' then
            VareNr := Trim(mtLinSubVareNr.AsString);

          if CtrBevValg(VareNr, mtLinATCKode.AsString, mtLinTekst.AsString, saveDosiskortNr) then
          begin
            mtLinTilskType.Value := 1;
            mtLinRegelSyg.Value := cdCtrBevRegel.Value;
            klausbool := False;
            C2LogAdd('    Regel valgt ' + mtLinRegelSyg.AsString);
          end
          else
          begin

          end;
        end;
      finally
        C2LogAdd('CTR bevillinger ordination slut');
      end;
    end;
  end;

  procedure process_sygesikring;

  begin
    with MainDm do
    begin
      if (Pos('A', mtLinSSKode.AsString) > 0) or (Pos('R', mtLinSSKode.AsString) > 0) then
      begin
        mtLinTilskType.Value := 1;
        exit;
      end;
      if (Pos('S', mtLinSSKode.AsString) = 0) and (Pos('V', mtLinSSKode.AsString) = 0) then
        exit;

      //CE 508
      if mtLinRegelSyg.AsInteger in [42, 43] then
        exit;

      // Klasuleret
      if (Pos('S', mtLinSSKode.AsString) > 0) then
      begin
        VareNr := Trim(mtLinVareNr.AsString);
        SkipQuestion := False;
        if not SkipQuestion then
        begin

          Question := '"Sygdomsklausuleret tilskud ?"';
          if KlausFlag then
            Question := Question + #13#10 + 'Ordinationen er KLAUSULERET';
          if frmYesNo.NewYesNoBox(Question) then
          begin
            mtLinTilskType.Value := 1;
            mtLinRegelSyg.Value := 41;
          end
          else
          begin

          end;
        end;
        exit;
      end;
      // Klasuleret
      Syg47 := False;
      cdCtrBev.First;
      while not cdCtrBev.Eof do
      begin
        if DateInRange(Date,DateOf(cdCtrBevFraDato.AsDateTime), DateOf(cdCtrBevTilDato.AsDateTime)) then
        begin
          if cdCtrBevRegel.Value = 47 then
            Syg47 := TRUE;
        end;
        cdCtrBev.Next;
      end;
      VareNr := Trim(mtLinVareNr.AsString);
      SkipQuestion := False;
      if not SkipQuestion then
      begin
        if Syg47 then
        begin
          Question := '"Tilskud kun pensionist eller ved bestemte sygdomme ?"' + #13#10 + 'KUNDEN HAR PENSIONISTSTATUS I CTR';
          if KlausFlag then
            Question := Question + #13#10 + 'Ordinationen er KLAUSULERET';
          if frmYesNo.NewYesNoBox(Question) then
          begin
            mtLinTilskType.Value := 1;
            mtLinRegelSyg.Value := 41;
          end;

        end
        else
        begin
          Question := '"Tilskud til bestemte sygdomme?"';
          if KlausFlag then
            Question := Question + #13#10 + 'Ordinationen er KLAUSULERET';
          if frmYesNo.NewYesNoBox(Question) then
          begin
            mtLinTilskType.Value := 1;
            mtLinRegelSyg.Value := 41;
          end;

        end;
      end;
    end;
  end;

  procedure process_EgneBevilling;
  type
    TValidRegels = set of byte;
  var
    dclregel: integer;
    ValidRegels : TValidRegels;
  begin
    with MainDm do
    begin
      C2LogAdd('Egne bevillinger ordination start');
      c2logadd('dosiskort nr is ' + inttostr(saveDosiskortNr));
      c2logadd('takersdoskortauto is ' + Bool2Str(StamForm.TakserDosisKortAuto));
      c2logadd('varenr is ' + mtLinVareNr.AsString);
      C2LogAddF('varenr is %s autoexp on the card is %s', [ mtLinVareNr.AsString, bool2str(DosisKortAutoExp)]);
      try
        // Egne bevillinger
        if mtLinRegelSyg.Value <> 0 then
          exit;
        dclregel := 0;

        if Maindm.TakserUdenCTR then
          ValidRegels := [59]
        else
          ValidRegels := [45,46,59];
        // Kaldes kun hvis regel ikke er brugt fra CTR
        ffPatTil.First;
        while not ffPatTil.Eof do
        begin
          C2LogAddF('regel on tilskud record is %d', [ffPatTilRegel.AsInteger]);
          if (ffPatTilRegel.Value in ValidRegels) and (mtLinTilskType.Value = 0) then
          begin
                // fejl 1055
            if DateInRange(Date,DateOf(ffPatTilFraDato.AsDateTime),DateOf(ffPatTilTilDato.AsDateTime)) then
            begin
              tilATCkode := trim(ffPatTilAtcKode.AsString);
              if (saveDosiskortNr <> 0) then
              begin
                if ffPatTilRegel.Value = 45 then
                begin
                  ffPatTil.Next;
                  continue;
                end;
              end;
              BevOk := False;
              atclen := length(tilATCkode);
              begin
                if (ffPatTilVareNr.AsString = '') and (tilATCkode = '') then
                  BevOk := BevOversigt('', '', '')
                else
                begin
                  if mtLinSubVareNr.AsString = ffPatTilVareNr.AsString then
                    BevOk := BevOversigt('', '', '')
                  else if (tilATCkode <> '') and (tilATCkode = copy(mtLinATCKode.AsString, 1, atclen)) then
                    BevOk := BevOversigt('', '', '')
                  else
                    BevOk := False;
                end;
              end;
              if BevOk then
              begin
                mtLinTilskType.Value := 0;
                mtLinRegelSyg.Value := ffPatTilRegel.Value;
                SygPrm00 := ffPatTilPromille5.Value;
              end;
            end;
          end;
          ffPatTil.Next;
        end;
      finally
        C2LogAdd('Egne bevillinger ordination slut');
      end;

    end;
  end;

  procedure process_sygesikringmm;
  var
    AskQuestion: boolean;
    MMBevOK: boolean;
    save_DCHIndex: string;
    save_DCLIndex: string;
  begin
    with MainDm do
    begin
      c2logadd('top of process_sygesikringmm');
      save_DCHIndex := ffdch.IndexName;
      save_DCLIndex := ffdcl.IndexName;
      try
        if (MAINDM.mtLinRegelSyg.Value = 0) and (mtEksCtrType.Value <> 99) then
          exit;
        c2logadd('dosiskort nr is ' + inttostr(saveDosiskortNr));
        c2logadd('takersdoskortauto is ' + Bool2Str(StamForm.TakserDosisKortAuto));
        C2LogAddF('varenr is %s udlevtype is %s autoexp on the card is %s',
          [ mtLinVareNr.AsString, mtLinUdLevType.AsString, bool2str(DosisKortAutoExp)]);
        if mtEksCtrType.Value = 99 then
        begin
          // Terminal
          if (not containstext( mtLinUdlevType.AsString,'HV')) and (not containstext( mtLinUdlevType.AsString,'HF')) then
          begin
            mtLinRegelSyg.AsInteger := 41;
            if (mtLinVareType.AsInteger = 12) or (mtLinVareNr.AsString = '100000') then
              mtLinRegelSyg.AsInteger := 59;
            if mtEksEkspType.AsInteger = et_Dosispakning then
            begin
              mtLinTilskSyg.AsCurrency := DOSISESP;
              mtLinAndel.AsCurrency := 0;
              if mtEksOrdreType.Value = 2 then
                mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency - DOSISESP
              else
                mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency + DOSISESP;
              mtLinBGPBel.AsCurrency := DOSISESP;
              mtLinIBTBel.AsCurrency := DOSISESP;

            end
            else
            begin
              mtLinTilskSyg.AsCurrency := ESP;
              mtLinAndel.AsCurrency := 0;
              if mtEksOrdreType.Value = 2 then
                mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency - ESP
              else
                mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency + ESP;
              mtLinBGPBel.AsCurrency := ESP;
              mtLinIBTBel.AsCurrency := ESP;

            end;

            exit;
          end;

        //fe 413
          MMBevOK := False;
          AskQuestion := True;
          if (mtLinVareNr.AsString = '100000') then
          begin
            mtLinRegelSyg.AsInteger := 59;
            mtLinTilskSyg.AsCurrency := ESP;
            mtLinAndel.AsCurrency := 0;
            if mtEksOrdreType.Value = 2 then
              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency - ESP
            else
              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency + ESP;
            mtLinBGPBel.AsCurrency := ESP;
            mtLinIBTBel.AsCurrency := ESP;
            exit;
          end;

          if AskQuestion then
          begin
            MMBevOK := ChkBoxYesNo('Skal der ydes tilskud fra sygesikringen (CTR)?', False);

          end;

          if not MMBevOK then
            exit;

          mtLinRegelSyg.AsInteger := 41;
          if mtLinVareType.AsInteger = 12 then
            mtLinRegelSyg.AsInteger := 59;
          if mtEksEkspType.AsInteger = et_Dosispakning then
          begin
            mtLinTilskSyg.AsCurrency := DOSISESP;
            mtLinAndel.AsCurrency := 0;
            if mtEksOrdreType.Value = 2 then
              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency - DOSISESP
            else
              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency + DOSISESP;
            mtLinBGPBel.AsCurrency := DOSISESP;
            mtLinIBTBel.AsCurrency := DOSISESP;
          end
          else
          begin
            mtLinTilskSyg.AsCurrency := ESP;
            mtLinAndel.AsCurrency := 0;
            if mtEksOrdreType.Value = 2 then
              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency - ESP
            else
              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency + ESP;
            mtLinBGPBel.AsCurrency := ESP;
            mtLinIBTBel.AsCurrency := ESP;
          end;
          exit;
        end;

        if not mtLinRegelSyg.Value in [41..43] then
          exit;
        if mtLinTilskType.Value <> 1 then
          exit;
        // Almindelig sygesikring + klausulereret
        if mtEksOrdreType.Value = 2 then
        begin
          if mtLinRegelSyg.Value = 43 then
            Saldo := mtLinGlSaldo.AsCurrency - ESP
          else
            Saldo := mtLinGlSaldo.AsCurrency - BGP;
        end
        else
          Saldo := mtLinGlSaldo.AsCurrency;
        // Beregn på BGP eller ESP samt med CTR
        if mtLinRegelSyg.Value = 43 then
          WBGP := ESP
        else
          WBGP := BGP;
        Tilsk := 0;
        BeregnSygesikring(mtLinTilskType.Value, mtLinRegelSyg.Value, mtEksCtrType.Value, Saldo, WBGP, Tilsk);
        C2LogAddF('wbgp is %f Tilsk is %f', [wbgp,Tilsk] );
        if mtEksEkspType.AsInteger = et_Dosispakning then
        begin
          mtLinTilskSyg.AsCurrency := Oprund5Ore(Tilsk);
          mtLinAndel.AsCurrency := mtLinBrutto.AsCurrency - mtLinTilskSyg.AsCurrency;
          if mtLinAndel.AsCurrency < 0 then
            mtLinAndel.AsCurrency := 0;

        end
        else
        begin
          mtLinTilskSyg.AsCurrency := Tilsk;
          mtLinAndel.AsCurrency := ESP - Tilsk;
        end;
        C2LogAddF('TilskSyg is %f Andel is %f', [mtLinTilskSyg.AsCurrency, mtLinAndel.AsCurrency]);

        if mtEksOrdreType.Value = 2 then
          mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency - WBGP
        else
          mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency + WBGP;
        if mtEksEkspType.AsInteger = et_Dosispakning then
        begin
          if mtLinRegelSyg.AsInteger = 43 then
            mtLinBGPBel.AsCurrency := ESP
          else
            mtLinBGPBel.AsCurrency := BGP;
        end
        else
          mtLinBGPBel.AsCurrency := WBGP;
        mtLinIBTBel.AsCurrency := Tilsk;
      finally
        // Anden amtslig refusion
        if mtLinRegelSyg.Value in [45, 46, 59] then
        begin
          if (mtEksCtrType.AsInteger = 99) then
            if ((mtLinRegelSyg.Value = 59) or (mtLinVareNr.AsString = '100000')) then
              SygPrm00 := 1000;

          Tilsk := BeregnTilsk(ESP, SygPrm00);
          Tilsk := Oprund5Ore(Tilsk);
          mtLinTilskSyg.AsCurrency := Tilsk;
          mtLinAndel.AsCurrency := ESP - Tilsk;
        end;

        ffdch.IndexName := save_DCHIndex;
        ffdcl.IndexName := save_DCLIndex;
        c2logadd('bottom of process_sygesikringmm');
      end;
    end;
  end;

  procedure process_Kommuner;
  var
    dclregel: integer;
    blankdclregel: boolean;
    askquestion: boolean;
  begin
    with MainDm do
    begin
      C2LogAdd('Kommunale bevillinger ordination start');
      try
        dclregel := 0;
        blankdclregel := False;

        ffPatTil.First;
        while not ffPatTil.Eof do
        begin
          BevOk := FALSE;
          if not DateInRange(Date, DateOf(ffPatTilFraDato.AsDateTime),DateOf(ffPatTilTilDato.AsDateTime)) then
          begin
            ffPatTil.Next;
            Continue;
          end;
            // Marker Hermedico
          if InRange(ffPatTilRegel.AsInteger, 101, 109) then
          begin
            if (not BevOk) and (VareTypeAV(mtLinVareType.AsInteger)) then
            begin
              BevOk := BevOversigt(mtLinSubVareNr.AsString, mtLinATCKode.AsString, mtLinTekst.AsString);
              // Godkendt
              if BevOk then
              begin
                C2LogAdd('  Første tilskudsvalg');
                KomPrm14 := ffPatTilPromille5.AsInteger;
                mtLinRegelKom1.AsInteger := ffPatTilRegel.AsInteger;
                mtLinChkJrnlNr1.AsBoolean := ffPatTilChkJournalNr.AsBoolean;
                mtLinJournalNr1.AsString := ffPatTilJournalNr.AsString;
                mtLinAfdeling1.AsString := ffPatTilAfdelingEj.AsString;
              end;
            end;
          end;
          // Marker kommunetilskud
          if ffPatTilInstans.AsString = 'Kommune' then
          begin
            if (MainDm.ffPatTilRegel.AsInteger in [73,74,75])  or
              (StamForm.Regel_76_Tilskudspris and (ffPatTilRegel.Value = 76)) then
              BevOk:= True
            else
            begin
              askquestion := True;
              if askquestion then
              begin
                tilATCkode := trim(ffPatTilAtcKode.AsString);
                atclen := length(tilATCkode);
                if (ffPatTilVareNr.AsString = '') and (tilATCkode = '') then
                  BevOk := BevOversigt('', '', '')
                else
                begin
                  if mtLinSubVareNr.AsString = ffPatTilVareNr.AsString then
                    BevOk := BevOversigt('', '', '')
                else
                  if (tilatckode<>'') and (tilATCkode = copy(mtLinATCKode.AsString,1,atclen)) then
                    BevOk := BevOversigt('', '', '')
                  else
                    BevOk := False;

                end;
              end;

            end;

            if BevOk then
            begin
              // Check kommunenr
              if (ffPatKarKommune.AsInteger < 100) or (ffPatKarKommune.AsInteger > 999) then
              begin
                // Ingen kommunenr fejlmeld
                ChkBoxOK('Mangler kommunenr på patient!');
                BevOk := FALSE;
              end;
            end;
            if BevOk then
            begin
              if mtLinRegelKom1.AsInteger = 0 then
              begin
                C2LogAdd('  Første tilskudsvalg');
                KomPrm10 := ffPatTilPromille1.Value;
                KomPrm11 := ffPatTilPromille2.Value;
                KomPrm12 := ffPatTilPromille3.Value;
                KomPrm13 := ffPatTilPromille4.Value;
                KomPrm14 := ffPatTilPromille5.Value;
                mtLinRegelKom1.AsInteger := ffPatTilRegel.AsInteger;
                mtLinChkJrnlNr1.AsBoolean := ffPatTilChkJournalNr.AsBoolean;
                mtLinJournalNr1.AsString := ffPatTilJournalNr.AsString;
                mtLinAfdeling1.AsString := ffPatTilAfdeling.AsString;
                if mtLinTilskType.Value = 0 then
                begin
                  if Trim(ffPatTilAfdelingEj.AsString) <> '' then
                    mtLinAfdeling1.AsString := ffPatTilAfdelingEj.AsString;
                end;
              C2LogAddF('    Regel %d Prm0 %d Prm1 %d Prm2 %d Prm3 %d Prm4 %d Jnlnr %s Afd %s', [mtLinRegelKom1.AsInteger,
                KomPrm10, KomPrm11, KomPrm12, KomPrm13, KomPrm14, mtLinJournalNr1.AsString, mtLinAfdeling1.AsString]);
              end
              else
              begin
                if mtLinRegelKom2.AsInteger = 0 then
                begin
                  if (mtLinRegelKom1.AsInteger in [73,74,75]) and (ffPatTilRegel.AsInteger = mtLinRegelKom1.AsInteger) then
                  begin

      c2logaddF('  2 rule 73,74,75 problem occurred with regel %d',[MainDm.mtLinRegelKom1.AsInteger]);
                    if KomPrm10 <> ffPatTilPromille1.Value then
                    begin
                      if ChkBoxYesNo('Der er mere end et gældende helbredstillægskort.' + #13#10 + 'Der beregnes med ' +
                        FloatToStr(KomPrm10 / 10) + '%, ønsker du at bruge næste kort med ' + FloatToStr(ffPatTilPromille1.AsInteger
                        / 10) + '%?', false) then
                      begin
                        KomPrm10 := ffPatTilPromille1.Value;
                        KomPrm11 := ffPatTilPromille2.Value;
                        KomPrm12 := ffPatTilPromille3.Value;
                        KomPrm13 := ffPatTilPromille4.Value;
                        KomPrm14 := ffPatTilPromille5.Value;
                        mtLinRegelKom1.AsInteger := ffPatTilRegel.AsInteger;
                        mtLinChkJrnlNr1.AsBoolean := ffPatTilChkJournalNr.AsBoolean;
                        mtLinJournalNr1.AsString := ffPatTilJournalNr.AsString;
                        mtLinAfdeling1.AsString := ffPatTilAfdeling.AsString;
                        if mtLinTilskType.Value = 0 then
                        begin
                          if Trim(ffPatTilAfdelingEj.AsString) <> '' then
                            mtLinAfdeling1.AsString := ffPatTilAfdelingEj.AsString;
                        end;
                      C2LogAddF('    Regel %d Prm0 %d Prm1 %d Prm2 %d Prm3 %d Prm4 %d Jnlnr %s Afd %s',
                      [mtLinRegelKom1.AsInteger, KomPrm10, KomPrm11, KomPrm12, KomPrm13, KomPrm14, mtLinJournalNr1.AsString,
                      mtLinAfdeling1.AsString]);

                      end;
                    end;
                  end
                  else
                  begin
                    C2LogAdd('  Andet tilskudsvalg');
                    KomPrm20 := ffPatTilPromille1.Value;
                    KomPrm21 := ffPatTilPromille2.Value;
                    KomPrm22 := ffPatTilPromille3.Value;
                    KomPrm23 := ffPatTilPromille4.Value;
                    KomPrm24 := ffPatTilPromille5.Value;
                    mtLinRegelKom2.AsInteger := ffPatTilRegel.AsInteger;
                    mtLinChkJrnlNr2.AsBoolean := ffPatTilChkJournalNr.AsBoolean;
                    mtLinJournalNr2.AsString := ffPatTilJournalNr.AsString;
                    mtLinAfdeling2.AsString := ffPatTilAfdeling.AsString;
                    if mtLinTilskType.Value = 0 then
                    begin
                      if Trim(ffPatTilAfdelingEj.AsString) <> '' then
                        mtLinAfdeling2.AsString := ffPatTilAfdelingEj.AsString;
                    end;
                  C2LogAddF('    Regel %d Prm0 %d Prm1 %d Prm2 %d Prm3 %d Prm4 %d Jnlnr %s Afd %s',
                  [mtLinRegelKom2.AsInteger, KomPrm10, KomPrm11, KomPrm12, KomPrm13, KomPrm14, mtLinJournalNr2.AsString,
                  mtLinAfdeling2.AsString]);
                  end;
                end
                else
                  ChkBoxOK('Kun to kommunale tilskud!');
              end;
            end;
          end;
          ffPatTil.Next;
        end;
      finally
        C2LogAdd('Kommunale bevillinger ordination slut');
      end;

    end;
  end;

  procedure process_Hermedico;
  begin
    with MainDm do
    begin
      if InRange(mtLinRegelKom1.AsInteger, 101, 109) then
      begin
        Saldo := mtLinGlSaldo.AsCurrency;
        Tilsk := 0;
        Andel := mtLinAndel.AsCurrency;
        if KomPrm14 <> 0 then
          Tilsk := BeregnTilsk(Andel, KomPrm14)
        else
          Tilsk := BeregnTilsk(Andel, KomPrm10);
        Tilsk := Oprund5Ore(Tilsk);
        if Tilsk > Andel then
          Tilsk := Andel;
        mtLinTilskKom1.AsCurrency := Tilsk;
        mtLinAndel.AsCurrency := Andel - Tilsk;
        exit;
    (*
        Tilsk:= BeregnTilsk(mtLinAndel.AsCurrency, KomPrm14);
        Tilsk:= Oprund5Ore(Tilsk);
        if Tilsk > mtLinAndel.AsCurrency then
          Tilsk:= mtLinAndel.AsCurrency;
        mtLinTilskKom1.AsCurrency:= Tilsk;
        mtLinAndel    .AsCurrency:= mtLinAndel.AsCurrency - Tilsk;
    *)
      end;

      // Første kommune
      if mtLinRegelKom1.AsInteger <= 0 then
        exit;
      Saldo := mtLinGlSaldo.AsCurrency;
      Tilsk := 0;
      Andel := mtLinAndel.AsCurrency;
      // Medicinkort
      if (MainDm.mtLinRegelKom1.AsInteger in [73,74,75]) or
        (StamForm.Regel_76_Tilskudspris and (mtLinRegelKom1.AsInteger = 76)) then
      begin
        C2LogAddF('  Første medicinkort tilskud %d',[MainDm.mtLinRegelKom1.AsInteger]);
        // Medicinkort efter ESP
        if (mtLinTilskType.Value = 1) or (mtLinVareNr.AsString = '100015') then
        begin
          C2LogAddF('    Type 1 or udligning Saldo %f ESP %f TSP %f Prm %d', [Saldo, ESP, BGP, KomPrm10]);
          // fejl medkort retur if ctr band switch.
          if mtEksOrdreType.Value = 2 then
          begin
            if mtLinRegelSyg.Value = 43 then
              Saldo := mtLinGlSaldo.AsCurrency - ESP
            else
              Saldo := mtLinGlSaldo.AsCurrency - BGP;
          end;
          if mtLinVareNr.AsString = '100015' then
            BevOk := ChkBoxYesNo('Skal der foretages helbredstillægsberegning?', True)
          else
            BevOk := True;
          if BevOk then
          begin
            if mtLinRegelSyg.Value = 43 then
            begin
              if (mtLinTilskSyg.AsCurrency < ESP) or (mtLinRegelKom1.AsInteger = 76) then
                BeregnMedkort(1, mtEksCtrType.Value, Saldo, ESP, ESP, KomPrm10, Tilsk)
            end
            else
            begin
              if (mtLinTilskSyg.AsCurrency < BGP) or (mtLinRegelKom1.AsInteger = 76) then
                BeregnMedkort(1, mtEksCtrType.Value, Saldo, ESP, BGP, KomPrm10, Tilsk);
            end;
          end;
        end;
        C2LogAddF('    Tilsk %f',[Tilsk]);
      end
      else
      begin
        C2LogAdd('  Første kommunale tilskud');
        // Andre kommunale tilskud
  (*
        if mtLinRegelKom1.Value = 71 then
          BeregnMedkort (mtLinTilskType.Value, mtEksCtrType.Value,
                         Saldo, ESP, BGP, KomPrm10, KomPrm11,
                         KomPrm12, KomPrm13, KomPrm14, Tilsk)
        else begin
          if KomPrm14 <> 0 then
            Tilsk := BeregnTilsk (Andel, KomPrm14)
          else
            Tilsk := BeregnTilsk (Andel, KomPrm10);
          Tilsk := Oprund5Ore (Tilsk);
        end;
  *)
        if KomPrm14 <> 0 then
          Tilsk := BeregnTilsk(Andel, KomPrm14)
        else
          Tilsk := BeregnTilsk(Andel, KomPrm10);
        Tilsk := Oprund5Ore(Tilsk);
        C2LogAddF('    Prm0 %d Prm4 %d Tilsk %f', [KomPrm10, KomPrm14,Tilsk]);
      end;
      if Tilsk > Andel then
        Tilsk := Andel;
      mtLinTilskKom1.AsCurrency := Tilsk;
      mtLinAndel.AsCurrency := Andel - Tilsk;
      C2LogAddF('    Tilskud %f Patient %f', [mtLinTilskKom1.AsCurrency, mtLinAndel.AsCurrency]);
    end;

  end;

  procedure process_Anden_Kommune;
  begin
    with MainDm do
    begin
      C2LogAdd('Anden kommune start');
      try
        if mtLinRegelKom2.AsInteger = 0 then
          exit;
        Saldo := mtLinGlSaldo.AsCurrency;
        Tilsk := 0;
        Andel := mtLinAndel.AsCurrency;
        // Medicinkort
        if (MainDm.mtLinRegelKom2.AsInteger in [73,74,75]) or
          (StamForm.Regel_76_Tilskudspris and (mtLinRegelKom2.AsInteger = 76)) then
        begin
          C2LogAddF('  Andet medicinkort tilskud Regel %d',[MainDm.mtLinRegelKom2.AsInteger]);
          if mtLinRegelKom2.AsInteger = 76 then
          begin
            if mtLinRegelSyg.AsInteger = 43 then
              ESP := ESP - mtLinTilskSyg.AsCurrency - mtLinTilskKom1.AsCurrency
            else
              BGP := BGP - mtLinTilskSyg.AsCurrency - mtLinTilskKom1.AsCurrency;
          end;
          // Medicinkort efter ESP
          if (mtLinTilskType.Value = 1) or (mtLinVareNr.AsString = '100015') then
          begin
            C2LogAdd('    Type 1');
            C2LogAdd('    Saldo ' + CurrToStr(Saldo));
            C2LogAdd('    ESP ' + CurrToStr(ESP));
            C2LogAdd('    TSP ' + CurrToStr(BGP));
            C2LogAdd('    Prm ' + CurrToStr(KomPrm20));
            if Trunc(Date) < EncodeDate(2005, 4, 1) then
            begin
              Tilsk := BeregnTilsk(Andel, KomPrm20);
              Tilsk := Oprund5Ore(Tilsk);
            end
            else
            begin
              if mtLinVareNr.AsString = '100015' then
                BevOk := ChkBoxYesNo('Skal der foretages helbredstillægsberegning?', True)
              else
                BevOk := True;
              if BevOk then
              begin
                if mtLinRegelKom2.AsInteger = 76 then
                begin
                  if mtLinRegelSyg.AsInteger = 43 then
                    Tilsk := BeregnTilsk(ESP, KomPrm20)
                  else
                    Tilsk := BeregnTilsk(BGP, KomPrm20);
                  Tilsk := Oprund5Ore(Tilsk);

                end
                else
                begin
                  if mtLinRegelSyg.Value = 43 then
                    BeregnMedkort(1, mtEksCtrType.Value, Saldo, ESP, ESP, KomPrm20, Tilsk)
                  else
                    BeregnMedkort(1, mtEksCtrType.Value, Saldo, ESP, BGP, KomPrm20, Tilsk);
                end;
              end;
            end;
          end;
          C2LogAddF('    Tilsk %f',[Tilsk]);
        end
        else
        begin
          C2LogAdd('  Andet kommunale tilskud');
          // Andre kommunale tilskud
    (*
          if mtLinRegelKom2.Value = 71 then
            BeregnMedkort (mtLinTilskType.Value, mtEksCtrType.Value,
                           Saldo, ESP, BGP, KomPrm20, KomPrm21,
                           KomPrm22, KomPrm23, KomPrm24, Tilsk)
          else begin
            if KomPrm24 <> 0 then
              Tilsk := BeregnTilsk (Andel, KomPrm24)
            else
              Tilsk := BeregnTilsk (Andel, KomPrm20);
            Tilsk := Oprund5Ore (Tilsk);
          end;
    *)
          if KomPrm24 <> 0 then
            Tilsk := BeregnTilsk(Andel, KomPrm24)
          else
            Tilsk := BeregnTilsk(Andel, KomPrm20);
          Tilsk := Oprund5Ore(Tilsk);
          C2LogAddF('    Prm0 %d Prm4 %d Tilsk %f',[KomPrm20, KomPrm24,Tilsk]);
        end;
        if Tilsk > Andel then
          Tilsk := Andel;
        mtLinTilskKom2.AsCurrency := Tilsk;
        mtLinAndel.AsCurrency := Andel - Tilsk;
        C2LogAddF('    Tilskud %f Patient %f',[mtLinTilskKom2.AsCurrency,mtLinAndel.AsCurrency]);

      finally
        C2LogAdd('Anden Kommune slut');

      end;

    end;
  end;

begin
  klausbool := true;

  SygPrm00 := 0;
  KomPrm10 := 0;
  KomPrm11 := 0;
  KomPrm12 := 0;
  KomPrm13 := 0;
  KomPrm14 := 0;
  KomPrm20 := 0;
  KomPrm21 := 0;
  KomPrm22 := 0;
  KomPrm23 := 0;
  KomPrm24 := 0;
  Maindm.mtLinTilskType.Value := 0;
  Maindm.mtLinRegelSyg.Value := 0;
  Maindm.mtLinRegelKom1.Value := 0;
  Maindm.mtLinRegelKom2.Value := 0;
  Maindm.mtLinTilskSyg.AsCurrency := 0;
  Maindm.mtLinTilskKom1.AsCurrency := 0;
  Maindm.mtLinTilskKom2.AsCurrency := 0;
  Tilsk := 0.0;

  ESP := Maindm.mtLinESP.AsCurrency * Maindm.mtLinAntal.Value;
  DOSISESP := ESP;
  BGP := Maindm.mtLinBGP.AsCurrency * Maindm.mtLinAntal.Value;
  // Ved dosis afrundes ESP til 5 øre
  if Maindm.mtEksEkspType.Value = et_Dosispakning then
  begin
    DOSISESP := Oprund5Ore(DOSISESP);
    DOSISBGP := Oprund5Ore(DOSISBGP);
  end;
  Maindm.mtLinBrutto.AsCurrency := ESP;
  Maindm.mtLinAndel.AsCurrency := Maindm.mtLinBrutto.AsCurrency;
  Maindm.mtLinJournalNr1.AsString := '';
  Maindm.mtLinJournalNr2.AsString := '';
  Maindm.mtLinChkJrnlNr1.AsBoolean := FALSE;
  Maindm.mtLinChkJrnlNr2.AsBoolean := FALSE;

  // Check sygesikring
  if MainDm.TakserUdenCTR then
  begin
    Tilsk := 0.0;
    andel :=  MainDm.mtLinAndel.AsCurrency;
    process_EgneBevilling;
    if MainDm.mtLinRegelSyg.AsInteger = 59 then
      Tilsk := BeregnTilsk(BGP, SygPrm00);
    Tilsk := Oprund5Ore(Tilsk);
    C2LogAddF('    Prm0 %d Prm4 %d Tilsk %f', [KomPrm10, KomPrm14, Tilsk]);
    if Tilsk > Andel then
      Tilsk := Andel;
    MainDm.mtLinTilskSyg.AsCurrency := Tilsk;
    MainDm.mtLinAndel.AsCurrency := Andel - Tilsk;
    C2LogAddF('    Tilskud %f Patient %f', [MainDm.mtLinTilskSyg.AsCurrency, MainDm.mtLinAndel.AsCurrency]);
    exit;
  end;

  if Pos(Maindm.mtLinSSKode.AsString, 'ARJ') > 0 then
  begin
    Maindm.mtLinTilskType.Value := 1;
    Maindm.mtLinRegelSyg.Value := 41;
  end;

  process_CTRBevillinger;
  // Check sygesikring

  process_sygesikring;

  process_EgneBevilling;

  // Sygesikring m.m.
  process_sygesikringmm;

  // Kommuner
  process_Kommuner;


  // Hermedico
  process_Hermedico;
  // Anden kommune


  process_Anden_Kommune;
  BeregnDanmark;
end;

end.

