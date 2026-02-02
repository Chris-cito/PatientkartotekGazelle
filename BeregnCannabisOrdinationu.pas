unit BeregnCannabisOrdinationu;
{ Developed by: Cito IT A/S

  Description: BeregnCannabisOrdination calculates the various support fees for the line

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  13-12-2021/cjs  Changes for using the new CtrTilskudSatser table

}


interface

uses CtrTilskudsSatser;
  procedure BeregnCannabisOrdination;

implementation

uses Sysutils,DM, C2MainLog,c2Procs,ChkBoxes,
      Main;


function Akkumuler (var Saldo : Currency;
                     var Koeb : Currency;
                       Niveau : Currency) : Currency;
var
  BGP : Currency;
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
      BGP  := Niveau - Saldo;
      Koeb := Koeb   - BGP;
    end
    else
    begin
      BGP  := Koeb;
      Koeb := 0;
    end;
    Saldo := Saldo + BGP;
  finally
    Result := BGP;
  end;
end;

//procedure BeregnBGP (Saldo, Koeb : currency;
//      var BGP0, BGP1, BGP2, BGP3 : Currency);
//begin
//  with MainDm do
//  begin
//    BGP0 := Akkumuler (Saldo, Koeb, TilskudsGr1);
//    BGP1 := Akkumuler (Saldo, Koeb, TilskudsGr2);
//    BGP2 := Akkumuler (Saldo, Koeb, TilskudsGr3);
//    BGP3 := Akkumuler (Saldo, Koeb, TilskudsGrMax);
//  end;
//end;
//

function BeregnTilsk (Bel : Currency; Prm : Word) : Currency;
begin
  Result := (Bel * Prm) / 1000;
end;

procedure BeregnSygesikring (TilKode : Word;
                            TilRegel : Word;
                             CtrType : Word;
                        var CtrSaldo : Currency;
                             var PRS : Currency;
                           var Tilsk : Currency);
var
  Saldo,
  Koeb,
  BGP0 : Currency;
begin
  with MainDm do
  begin
    try
      if TilKode <> 1 then
        exit;

      case CtrType of
        99:
          begin
            Tilsk := PRS;
          end;
      else
        begin // Kroniker voksen
          if CtrSaldo > CannabisGrp1 then
          begin
            Tilsk := 0;
          end
          else
          begin
            Saldo := CtrSaldo;
            Koeb := PRS;
            BGP0 := Akkumuler(Saldo, Koeb, CannabisGrp1);
            Tilsk := BeregnTilsk(BGP0, CannabisTilskudsPctNorm1);
          end;
        end;
      end;
    finally
      Tilsk := Oprund5Ore (Tilsk);
    end;
  end;
end;


procedure BeregnMedkort (TilKode : Word;
                         CtrType : Word;
                        CtrSaldo : Currency;
                             ESP : Currency;
                             BGP : Currency;
                             Prm : Word;
                       var Tilsk : Currency);
//var
//  PrmC : Word;
//  Rest0,
//  Rest1,
//  Rest2,
//  Rest3,
//  BGP0,
//  BGP1,
//  BGP2,
//  BGP3 : Currency;
begin
  with MainDm do
  begin
    try
      if TilKode <> 1 then
      begin
        Tilsk := BeregnTilsk (ESP, Prm);
        exit;
      end;
//      // Medicinkort efter BGP
//      case CtrType of
//        01 : PrmC := TilPctBarn1;  // Almen barn
//        11 : PrmC := TilPctBarn1;  // Kroniker barn
//      else
//        PrmC := TilPctNorm1;  // Almen voksen, Kroniker voksen, andre
//      end;
      BeregnSygesikring (mtLinTilskType.Value,
                         mtLinRegelSyg.Value,
                         mtEksCtrType.Value,
                         CtrSaldo, BGP, Tilsk);
      if BGP > Tilsk then
      begin


//      BeregnBGP (CtrSaldo, BGP, BGP0, BGP1, BGP2, BGP3);
//      Rest0 := BGP0  - BeregnTilsk (BGP0,  PrmC);
//      Rest1 := BGP1  - BeregnTilsk (BGP1,  TilPctNorm2);
//      Rest2 := BGP2  - BeregnTilsk (BGP2,  TilPctNorm3);
//      Rest3 := BGP3  - BeregnTilsk (BGP3,  TilPctNorm4);

//      Tilsk := Tilsk + BeregnTilsk (Rest0 + Rest1 + Rest2 + Rest3, Prm);
        Tilsk := BeregnTilsk (BGP-Tilsk, Prm);
      end
      else
        Tilsk := 0;

    finally
      Tilsk := Oprund5Ore (Tilsk);
    end;
  end;
end;

procedure BeregnDanmark;
begin
  with MainDm do
  begin
    C2LogAdd('Beregn danmark start');
    try
      mtLinDKTilsk.AsCurrency   := 0;
      mtLinDKEjTilsk.AsCurrency := 0;

      if mtLinUdligning.AsCurrency <> 0 then
      begin
          mtLinDKTilsk.AsCurrency := mtLinAndel.AsCurrency;
          mtLinDKType.AsInteger   := 1;
          exit;
      end;

      if mtLinTilskType.Value = 1 then
      begin
        mtLinDKTilsk.AsCurrency := mtLinAndel.AsCurrency;
        mtLinDKType.AsInteger   := 1;
        exit;
      end;
      if mtLinUdlevType.AsString = '' then
        exit;
      if (Pos ('HA', mtLinUdLevType.AsString) = 0) and
               (Pos ('HV', mtLinUdLevType.AsString) = 0) and
               (Pos ('HF', mtLinUdLevType.AsString) = 0) then
      begin
        if not ((Pos ('G02B',    mtLinATCKode.AsString) > 0) or
                  (Pos ('G03A',    mtLinATCKode.AsString) > 0) or
                  (Pos ('G03HB01', mtLinATCKode.AsString) > 0) or
                  (mtLinSubVareNr.AsString = '017020'))        then
        begin
          mtLinDKEjTilsk.AsCurrency := mtLinAndel.AsCurrency;
          mtLinDKType.AsInteger     := 2;
        end;
      end;
    finally
      C2LogAdd('  Type ' + mtLinDKType.AsString);
      C2LogAdd('  Afs1 ' + mtLinDKTilsk.AsString);
      C2LogAdd('  Afs2 ' + mtLinDKEjTilsk.AsString);
      C2LogAdd('Beregn danmark slut');
    end;
  end;
end;


procedure BeregnCannabisOrdination;
var
  WBGP,
  ESP,
  DOSISESP,
  BGP,
  DOSISBGP,
  Saldo,
  Tilsk,
  Andel : Currency;
  BevOk : Boolean;
  klausbool : Boolean;
  SygPrm00,
  KomPrm10,
  KomPrm11,
  KomPrm12,
  KomPrm13,
  KomPrm14,
  KomPrm20,
  KomPrm21,
  KomPrm22,
  KomPrm23,
  KomPrm24    : Word;

//  procedure process_CTRBevillinger;
//  begin
//    with MainDm{,TakserDosisForm} do
//    begin
//      // CTR bevillinger
//      C2LogAdd('CTR bevillinger ordination start ' + IntToStr(cdCtrBev.RecordCount));
//      try
//        if cdCtrBev.RecordCount = 0 then
//          exit;
//        // Check for typer af bevillinger
//        Syg42:= FALSE;
//        Syg43:= FALSE;
//        cdCtrBev.First;
//        while not cdCtrBev.Eof do
//        begin
//          if (Trunc(Date) >= Trunc(cdCtrBevFraDato.AsDateTime)) and
//             (Trunc(Date) <= Trunc(cdCtrBevTilDato.AsDateTime)) then
//          begin
//            if cdCtrBevRegel.Value = 42 then
//              Syg42:= TRUE;
//            if cdCtrBevRegel.Value = 43 then
//              Syg43:= TRUE;
//          end;
//          cdCtrBev.Next;
//        end;
//        // Check bevillinger
//        if mtLinSSKode.AsString = '' then
//          syg43 := False;
//        if ((Syg42) and (mtLinTilskType.Value = 0)) or (Syg43) then
//        begin
//          C2LogAdd('  Syg42 eller Syg43');
//          VareNr:= Trim(mtLinVareNr.AsString);
//          if VareNr = '' then
//            VareNr:= Trim(mtLinSubVareNr.AsString);
//
//          if CtrBevValg(VareNr, mtLinATCKode.AsString, mtLinTekst.AsString,0) then
//          begin
//            mtLinTilskType.Value:= 1;
//            mtLinRegelSyg.Value := cdCtrBevRegel.Value;
//            klausbool := False;
//            C2LogAdd('    Regel valgt ' + mtLinRegelSyg.AsString);
//          end
//          else
//          begin
//
//          end;
//        end;
//      finally
//        C2LogAdd('CTR bevillinger ordination slut');
//      end;
//    end;
//  end;

  procedure process_sygesikring;

  begin
    with MainDm do begin
//      if Pos ('A', mtLinSSKode.AsString) > 0 then
//      begin
        mtLinRegelSyg.AsInteger := 41;
        mtLinTilskType.Value  := 1;
        exit;
//      end;

      if (Pos ('S', mtLinSSKode.AsString) = 0) and
         (Pos ('V', mtLinSSKode.AsString) = 0) then
        exit;

      //CE 508
      if mtLinRegelSyg.AsInteger in [42,43] then
        exit;

//      // Klasuleret
//      if (Pos ('S', mtLinSSKode.AsString) > 0) then
//      begin
//        VareNr:= Trim(mtLinVareNr.AsString);
//        SkipQuestion := False;
//        if not SkipQuestion then
//        begin
//
//          Question := '"Sygdomsklausuleret tilskud ?"';
//          if KlausFlag then
//            Question := Question + #13#10 + 'Ordinationen er KLAUSULERET';
//          if frmYesNo.NewYesNoBox (Question) then
//          begin
//            mtLinTilskType.Value := 1;
//            mtLinRegelSyg.Value := 41;
//          end;
//        end;
//        exit;
//      end;
//      // Klasuleret
//      Syg47 := False;
//      cdCtrBev.First;
//      while not cdCtrBev.Eof do
//      begin
//        if (Trunc(Date) >= Trunc(cdCtrBevFraDato.AsDateTime)) and
//           (Trunc(Date) <= Trunc(cdCtrBevTilDato.AsDateTime)) then
//        begin
//          if cdCtrBevRegel.Value = 47 then
//            Syg47:= TRUE;
//        end;
//        cdCtrBev.Next;
//      end;
//      VareNr:= Trim(mtLinVareNr.AsString);
//      SkipQuestion := False;
//      if not SkipQuestion then
//      begin
//        if Syg47 then
//        begin
//          Question := '"Tilskud kun pensionist eller ved bestemte sygdomme ?"'
//              +#13#10+'KUNDEN HAR PENSIONISTSTATUS I CTR';
//          if KlausFlag then
//            Question := Question + #13#10+'Ordinationen er KLAUSULERET';
//          if frmYesNo.NewYesNoBox (Question) then
//          begin
//            mtLinTilskType.Value := 1;
//            mtLinRegelSyg.Value := 41;
//          end;
//
//        end
//        else
//        begin
//          Question := '"Tilskud til bestemte sygdomme?"';
//          if KlausFlag then
//            question := Question + #13#10+ 'Ordinationen er KLAUSULERET';
//          if frmYesNo.NewYesNoBox (Question) then
//          begin
//            mtLinTilskType.Value := 1;
//            mtLinRegelSyg.Value := 41;
//          end;
//
//        end;
//      end;
    end;
  end;

//  procedure process_EgneBevilling;
//  var
//    save_DCLIndex : string;
//    dclregel : integer;
//    dclregelfound : boolean;
//    blankdclregel : boolean;
//  begin
//    with MainDm do begin
//      C2LogAdd('Egne bevillinger ordination start');
//        c2logadd('takersdoskortauto is ' + Bool2Str(StamForm.TakserDosisKortAuto));
//        c2logadd('varenr is ' + mtLinVareNr.AsString);
//        c2logadd('autoexp on the card is ' + bool2str(DosisKortAutoExp));
//      try
//        // Egne bevillinger
//        if mtLinRegelSyg.Value <> 0 then
//          exit;
//        dclregel := 0;
//        blankdclregel := False;
//
//        // Kaldes kun hvis regel ikke er brugt fra CTR
//        ffPatTil.First;
//        while not ffPatTil.Eof do
//        begin
//          c2logadd('regel on tilskud record is ' + ffPatTilRegel.AsString);
//          c2logadd('regel for dosiscard lines is' + inttostr(dclregel));
//          if ((ffPatTilRegel.Value = 42) and (mtLinTilskType.Value = 0)) or
//              (ffPatTilRegel.Value = 43) then
//          begin
//          end;
//          if (ffPatTilRegel.Value in [45, 46, 59]) and
//             (mtLinTilskType.Value = 0)            then
//          begin
//                // fejl 1055
//            if (Trunc(Date) >= Trunc(ffPatTilFraDato.AsDateTime)) and
//              (Trunc(Date) <= Trunc(ffPatTilTilDato.AsDateTime)) then
//            begin
//              tilATCkode := trim(ffPatTilAtcKode.AsString);
//              BevOk := False;
//              atclen := length(tilATCkode);
//              begin
//                if (ffPatTilVareNr.AsString = '') and (tilATCkode = '') then
//                  BevOK:= BevOversigt('', '', '')
//                else
//                begin
//                  if mtLinSubVareNr.AsString = ffPatTilVareNr.AsString then
//                    BevOK:= BevOversigt('', '', '')
//                  else
//                    if (tilatckode<>'') and (tilATCkode = copy(mtLinATCKode.AsString,1,atclen)) then
//                      BevOK:= BevOversigt('', '', '')
//                    else
//                      BevOk := False;
//                end;
//              end;
//              if BevOk then
//              begin
//    //            if BevOversigt(mtLinSubVareNr.AsString,
//    //                              mtLinATCKode  .AsString,
//    //                              mtLinTekst    .AsString) then begin
//                  mtLinTilskType.Value:= 0;
//                  mtLinRegelSyg.Value := ffPatTilRegel.Value;
//                  SygPrm00            := ffPatTilPromille5.Value;
//              end;
//            end;
//          end;
//          ffPatTil.Next;
//        end;
//      finally
//        C2LogAdd('Egne bevillinger ordination slut');
//      end;
//
//    end;
//  end;

  procedure process_sygesikringmm;
  var
    AskQuestion : boolean;
    MMBevOK : boolean;
    save_DCHIndex : string;
    save_DCLIndex : string;

  begin
    with MainDm do
     begin
      c2logadd('top of process_sygesikringmm');
      save_DCHIndex := ffdch.IndexName;
      save_DCLindex := ffdcl.IndexName;
      try
        if (MAINDM.mtLinRegelSyg.Value = 0) and (mtEksCtrType.Value <> 99) then
          exit;
        c2logadd('varenr is ' + mtLinVareNr.AsString);
        c2logadd('udlevtype is ' + mtLinUdLevType.AsString);
        if mtEksCtrType.Value = 99 then
        begin
          // Terminal
          if (Pos ('HV', mtLinUdlevType.AsString) = 0) and
             (Pos ('HF', mtLinUdlevType.AsString) = 0) then
          begin
            mtLinRegelSyg.AsInteger := 41;
            if (mtLinVareType.AsInteger = 12) or (mtLinVareNr.AsString = '100000') then
              mtLinRegelSyg.AsInteger := 59;
            if mtEksEkspType.AsInteger = et_Dosispakning then
            begin
              mtLinTilskSyg.AsCurrency := DOSISESP;
              mtLinAndel.AsCurrency    := 0;
              if mtEksOrdreType.Value = 2 then
                mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency - DOSISESP
              else
                mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency + DOSISESP;
              mtLinBGPBel.AsCurrency   := DOSISESP;
              mtLinIBTBel.AsCurrency   := DOSISESP;


            end
            else
            begin
              mtLinTilskSyg.AsCurrency := ESP;
              mtLinAndel.AsCurrency    := 0;
              if mtEksOrdreType.Value = 2 then
                mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency - ESP
              else
                mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency + ESP;
              mtLinBGPBel.AsCurrency   := ESP;
              mtLinIBTBel.AsCurrency   := ESP;

            end;

            exit;
          end;

        //fe 413
          MMBevOK := False;
          AskQuestion := True;
//          if (mtLinVareNr.AsString = '100000') then
//          begin
//            mtLinRegelSyg.AsInteger := 59;
//            mtLinTilskSyg.AsCurrency := ESP;
//            mtLinAndel.AsCurrency    := 0;
//            if mtEksOrdreType.Value = 2 then
//              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency - ESP
//            else
//              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency + ESP;
//            mtLinBGPBel.AsCurrency   := ESP;
//            mtLinIBTBel.AsCurrency   := ESP;
//            exit;
//          end;

          if AskQuestion then
          begin
            MMBevOK := ChkBoxYesNo ('Skal der ydes tilskud fra sygesikringen (CTR)?', False);


          end;

          if not MMBevOK then
            exit;

          mtLinRegelSyg.AsInteger := 41;
          if mtLinVareType.AsInteger = 12 then
            mtLinRegelSyg.AsInteger := 59;
//          if mtEksEkspType.AsInteger = 7 then
//          begin
//            mtLinTilskSyg.AsCurrency := DOSISESP;
//            mtLinAndel.AsCurrency    := 0;
//            if mtEksOrdreType.Value = 2 then
//              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency - DOSISESP
//            else
//              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency + DOSISESP;
//            mtLinBGPBel.AsCurrency   := DOSISESP;
//            mtLinIBTBel.AsCurrency   := DOSISESP;
//          end
//          else
          begin
            mtLinTilskSyg.AsCurrency := ESP;
            mtLinAndel.AsCurrency    := 0;
            if mtEksOrdreType.Value = 2 then
              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency - ESP
            else
              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency + ESP;
            mtLinBGPBel.AsCurrency   := ESP;
            mtLinIBTBel.AsCurrency   := ESP;
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
        begin
          WBGP := ESP;
//          if (mtEksEkspType.AsInteger = 7) then
//              WBGP := DOSISESP;
        end
        else
        begin
          WBGP := BGP;
//          if (mtEksEkspType.AsInteger = 7) then
//              WBGP := DOSISBGP;
        end;
        Tilsk := 0;
        BeregnSygesikring (mtLinTilskType.Value,
                           mtLinRegelSyg.Value,
                           mtEksCtrType.Value,
                           Saldo, WBGP, Tilsk);
        C2LogAdd('wbgp is ' + CurrToStr(wbgp));
        C2LogAdd('Tilsk is ' + CurrToStr(Tilsk) );
        begin
          mtLinTilskSyg.AsCurrency := Tilsk;
          mtLinAndel.AsCurrency    := ESP - Tilsk;
        end;
        C2LogAdd('TilskSyg is ' + CurrToStr(mtLinTilskSyg.AsCurrency));
        C2LogAdd('Andel is ' + CurrToStr(mtLinAndel.AsCurrency));

        if mtEksOrdreType.Value = 2 then
          mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency - WBGP
        else
          mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency + WBGP;
        mtLinBGPBel.AsCurrency   := WBGP;
        mtLinIBTBel.AsCurrency   := Tilsk;
      finally
        // Anden amtslig refusion
//        if mtLinRegelSyg.Value in [45, 46, 59] then
//        begin
//          if (mtEksCtrType.AsInteger = 99) then
//            if ((mtLinRegelSyg.Value = 59) or (mtLinVareNr.AsString = '100000')) then
//              sygprm00 :=1000;
//
//          Tilsk:= BeregnTilsk (ESP, SygPrm00);
//          Tilsk:= Oprund5Ore (Tilsk);
//          mtLinTilskSyg.AsCurrency := Tilsk;
//          mtLinAndel.AsCurrency    := ESP - Tilsk;
//        end;

        ffdch.IndexName := save_DCHIndex;
        ffdcl.IndexName := save_DCLindex;
        c2logadd('bottom of process_sygesikringmm');
      end;
    end;
  end;

//  procedure process_Kommuner;
//  var
//    save_DCLIndex : string;
//    dclregel : integer;
//    dclregelfound : boolean;
//    blankdclregel : boolean;
//    askquestion : boolean;
//  begin
//    with MainDm do
//    begin
//      C2LogAdd('Kommunale bevillinger ordination start');
//      try
//        dclregel := 0;
//        blankdclregel := False;
//
//
//        ffPatTil.First;
//        while not ffPatTil.Eof do
//        begin
//          BevOk:= FALSE;
//          if (Trunc(Date) >= Trunc(ffPatTilFraDato.AsDateTime)) and
//             (Trunc(Date) <= Trunc(ffPatTilTilDato.AsDateTime)) then
//          begin
//            // Marker Hermedico
//            if (ffPatTilRegel.AsInteger >= 101) and (ffPatTilRegel.AsInteger <= 109) then
//            begin
//              if (not BevOk) and (VareTypeAV(mtLinVareType.AsInteger)) then
//              begin
//      //        if not BevOk then begin
//                askquestion := true;
//                if askquestion then
//                  BevOK:= BevOversigt(mtLinSubVareNr.AsString,
//                                  mtLinATCKode  .AsString,
//                                  mtLinTekst    .AsString);
//      //          BevOK:= BevOversigt('', '', '');
//                // Godkendt
//                if BevOk then
//                begin
//        C2LogAdd('  Første tilskudsvalg');
//                  KomPrm14                 := ffPatTilPromille5   .AsInteger;
//                  mtLinRegelKom1 .AsInteger:= ffPatTilRegel       .AsInteger;
//                  mtLinChkJrnlNr1.AsBoolean:= ffPatTilChkJournalNr.AsBoolean;
//                  mtLinJournalNr1.AsString := ffPatTilJournalNr   .AsString;
//                  mtLinAfdeling1 .AsString := ffPatTilAfdelingEj  .AsString;
//                end;
//              end;
//            end;
//            // Marker kommunetilskud
//            if ffPatTilInstans.AsString = 'Kommune' then
//            begin
//              if (ffPatTilRegel.Value = 75)  or (StamForm.Regel_76_Tilskudspris and (ffPatTilRegel.Value = 76)) then
//                BevOk:= True
//              else
//              begin
//                askquestion := True;
//                if askquestion then
//                begin
//                  tilATCkode := trim(ffPatTilAtcKode.AsString);
//                  atclen := length(tilATCkode);
//                  if (ffPatTilVareNr.AsString = '') and (tilATCkode = '') then
//                    BevOK:= BevOversigt('', '', '')
//                  else
//                  begin
//                    if mtLinSubVareNr.AsString = ffPatTilVareNr.AsString then
//                      BevOK:= BevOversigt('', '', '')
//                    else
//                      if (tilatckode<>'') and (tilATCkode = copy(mtLinATCKode.AsString,1,atclen)) then
//                        BevOK:= BevOversigt('', '', '')
//                      else
//                        BevOk := False;
//
//                  end;
//                end;
//
//              end;
//
//      (*
//                BevOK:= BevOversigt(mtLinSubVareNr.AsString,
//                                    mtLinATCKode  .AsString,
//                                    mtLinTekst    .AsString);
//      *)
//              // Godkendt
//              if BevOk then
//              begin
//                // Check kommunenr
//                if (ffPatKarKommune.AsInteger < 100) or
//                   (ffPatKarKommune.AsInteger > 999) then
//                begin
//                  // Ingen kommunenr fejlmeld
//                  ChkBoxOK('Mangler kommunenr på patient!');
//                  BevOk:= FALSE;
//                end;
//              end;
//              if BevOK then
//              begin
//                if mtLinRegelKom1.AsInteger = 0 then
//                begin
//        C2LogAdd('  Første tilskudsvalg');
//                  KomPrm10 := ffPatTilPromille1.Value;
//                  KomPrm11 := ffPatTilPromille2.Value;
//                  KomPrm12 := ffPatTilPromille3.Value;
//                  KomPrm13 := ffPatTilPromille4.Value;
//                  KomPrm14 := ffPatTilPromille5.Value;
//                  mtLinRegelKom1.AsInteger  := ffPatTilRegel.AsInteger;
//                  mtLinChkJrnlNr1.AsBoolean := ffPatTilChkJournalNr.AsBoolean;
//                  mtLinJournalNr1.AsString  := ffPatTilJournalNr.AsString;
//                  mtLinAfdeling1.AsString   := ffPatTilAfdeling.AsString;
//                  if mtLinTilskType.Value = 0 then
//                  begin
//                    if Trim (ffPatTilAfdelingEj.AsString) <> '' then
//                      mtLinAfdeling1.AsString := ffPatTilAfdelingEj.AsString;
//                  end;
//        C2LogAdd('    Regel ' + mtLinRegelKom1.AsString);
//        C2LogAdd('    Prm0 '  + IntToStr(KomPrm10));
//        C2LogAdd('    Prm1 '  + IntToStr(KomPrm11));
//        C2LogAdd('    Prm2 '  + IntToStr(KomPrm12));
//        C2LogAdd('    Prm3 '  + IntToStr(KomPrm13));
//        C2LogAdd('    Prm4 '  + IntToStr(KomPrm14));
//        C2LogAdd('    Jnlnr ' + mtLinJournalNr1.AsString);
//        C2LogAdd('    Afd '   + mtLinAfdeling1.AsString);
//                end
//                else
//                begin
//                  if mtLinRegelKom2.AsInteger = 0 then
//                  begin
//                    if (mtLinRegelKom1.AsInteger = 75) and (ffPatTilRegel.AsInteger = 75) then
//                    begin
//        c2logadd('  2 rule 75 problem occurred');
//                      if KomPrm10 <> ffPatTilPromille1.Value then
//                      begin
//                        if ChkBoxYesNo('Der er mere end et gældende helbredstillægskort.' + #13#10 +
//                                 'Der beregnes med ' + FloatToStr(KomPrm10/10) +
//                                 '%, ønsker du at bruge næste kort med ' +
//                                 FloatToStr(ffPatTilPromille1.AsInteger /10)+  '%?'
//                                 ,false) then
//                        begin
//                          KomPrm10 := ffPatTilPromille1.Value;
//                          KomPrm11 := ffPatTilPromille2.Value;
//                          KomPrm12 := ffPatTilPromille3.Value;
//                          KomPrm13 := ffPatTilPromille4.Value;
//                          KomPrm14 := ffPatTilPromille5.Value;
//                          mtLinRegelKom1.AsInteger  := ffPatTilRegel.AsInteger;
//                          mtLinChkJrnlNr1.AsBoolean := ffPatTilChkJournalNr.AsBoolean;
//                          mtLinJournalNr1.AsString  := ffPatTilJournalNr.AsString;
//                          mtLinAfdeling1.AsString   := ffPatTilAfdeling.AsString;
//                          if mtLinTilskType.Value = 0 then
//                          begin
//                            if Trim (ffPatTilAfdelingEj.AsString) <> '' then
//                              mtLinAfdeling1.AsString := ffPatTilAfdelingEj.AsString;
//                          end;
//                C2LogAdd('    Regel ' + mtLinRegelKom1.AsString);
//                C2LogAdd('    Prm0 '  + IntToStr(KomPrm10));
//                C2LogAdd('    Prm1 '  + IntToStr(KomPrm11));
//                C2LogAdd('    Prm2 '  + IntToStr(KomPrm12));
//                C2LogAdd('    Prm3 '  + IntToStr(KomPrm13));
//                C2LogAdd('    Prm4 '  + IntToStr(KomPrm14));
//                C2LogAdd('    Jnlnr ' + mtLinJournalNr1.AsString);
//                C2LogAdd('    Afd '   + mtLinAfdeling1.AsString);
//
//                        end;
//                      end;
//                    end
//                    else
//                    begin
//        C2LogAdd('  Andet tilskudsvalg');
//                      KomPrm20 := ffPatTilPromille1.Value;
//                      KomPrm21 := ffPatTilPromille2.Value;
//                      KomPrm22 := ffPatTilPromille3.Value;
//                      KomPrm23 := ffPatTilPromille4.Value;
//                      KomPrm24 := ffPatTilPromille5.Value;
//                      mtLinRegelKom2.AsInteger  := ffPatTilRegel.AsInteger;
//                      mtLinChkJrnlNr2.AsBoolean := ffPatTilChkJournalNr.AsBoolean;
//                      mtLinJournalNr2.AsString  := ffPatTilJournalNr.AsString;
//                      mtLinAfdeling2.AsString   := ffPatTilAfdeling.AsString;
//                      if mtLinTilskType.Value = 0 then begin
//                        if Trim (ffPatTilAfdelingEj.AsString) <> '' then
//                          mtLinAfdeling2.AsString := ffPatTilAfdelingEj.AsString;
//                      end;
//        C2LogAdd('    Regel ' + mtLinRegelKom2.AsString);
//        C2LogAdd('    Prm0 '  + IntToStr(KomPrm20));
//        C2LogAdd('    Prm1 '  + IntToStr(KomPrm21));
//        C2LogAdd('    Prm2 '  + IntToStr(KomPrm22));
//        C2LogAdd('    Prm3 '  + IntToStr(KomPrm23));
//        C2LogAdd('    Prm4 '  + IntToStr(KomPrm24));
//        C2LogAdd('    Jnlnr ' + mtLinJournalNr2.AsString);
//        C2LogAdd('    Afd '   + mtLinAfdeling2.AsString);
//                    end;
//                  end
//                  else
//                    ChkBoxOK ('Kun to kommunale tilskud!');
//                end;
//              end;
//            end;
//          end;
//          ffPatTil.Next;
//        end;
//      finally
//        C2LogAdd('Kommunale bevillinger ordination slut');
//      end;
//
//    end;
//  end;

  procedure process_Hermedico;
  begin
    with MainDm do
    begin
//      if (mtLinRegelKom1.AsInteger >= 101) and (mtLinRegelKom1.AsInteger <= 109) then
//      begin
//        Saldo:= mtLinGlSaldo.AsCurrency;
//        Tilsk:= 0;
//        Andel:= mtLinAndel.AsCurrency;
//        if KomPrm14 <> 0 then
//          Tilsk:= BeregnTilsk(Andel, KomPrm14)
//        else
//          Tilsk:= BeregnTilsk(Andel, KomPrm10);
//        Tilsk:= Oprund5Ore(Tilsk);
//        if Tilsk > Andel then
//          Tilsk:= Andel;
//        mtLinTilskKom1.AsCurrency:= Tilsk;
//        mtLinAndel    .AsCurrency:= Andel - Tilsk;
//        exit;
//    (*
//        Tilsk:= BeregnTilsk(mtLinAndel.AsCurrency, KomPrm14);
//        Tilsk:= Oprund5Ore(Tilsk);
//        if Tilsk > mtLinAndel.AsCurrency then
//          Tilsk:= mtLinAndel.AsCurrency;
//        mtLinTilskKom1.AsCurrency:= Tilsk;
//        mtLinAndel    .AsCurrency:= mtLinAndel.AsCurrency - Tilsk;
//    *)
//      end;

      // Første kommune
      if mtLinRegelKom1.AsInteger <= 0 then
        exit;
      Saldo:= mtLinGlSaldo.AsCurrency;
      Tilsk:= 0;
      Andel:= mtLinAndel.AsCurrency;
      // Medicinkort
      if (mtLinRegelKom1.AsInteger = 75) or (StamForm.Regel_76_Tilskudspris and (mtLinRegelKom1.AsInteger = 76)) then
      begin
        C2LogAdd('  Første medicinkort tilskud');
        // Medicinkort efter ESP
        if (mtLinTilskType.Value = 1) or (mtLinVareNr.AsString = '100015') then
        begin
          C2LogAdd('    Type 1 or udligning');
          C2LogAdd('    Saldo ' + CurrToStr(Saldo));
          C2LogAdd('    ESP ' + CurrToStr(ESP));
          C2LogAdd('    TSP ' + CurrToStr(BGP));
          C2LogAdd('    Prm ' + CurrToStr(KomPrm10));
          // fejl medkort retur if ctr band switch.
          if mtEksOrdreType.Value = 2 then begin
            if mtLinRegelSyg.Value = 43 then
              Saldo := mtLinGlSaldo.AsCurrency - ESP
            else
              Saldo := mtLinGlSaldo.AsCurrency - BGP;
          end;
          if mtLinVareNr.AsString = '100015' then
            BevOK:= ChkBoxYesNo('Skal der foretages helbredstillægsberegning?',True)
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
        C2LogAdd('    Tilsk ' + CurrToStr(Tilsk));
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
          Tilsk:= BeregnTilsk(Andel, KomPrm14)
        else
          Tilsk:= BeregnTilsk(Andel, KomPrm10);
        Tilsk:= Oprund5Ore(Tilsk);
        C2LogAdd('    Prm0 ' + CurrToStr(KomPrm10));
        C2LogAdd('    Prm4 ' + CurrToStr(KomPrm14));
        C2LogAdd('    Tilsk ' + CurrToStr(Tilsk));
      end;
      if Tilsk > Andel then
        Tilsk:= Andel;
      mtLinTilskKom1.AsCurrency:= Tilsk;
      mtLinAndel.AsCurrency    := Andel - Tilsk;
      C2LogAdd('    Tilskud ' + mtLinTilskKom1.AsString);
      C2LogAdd('    Patient ' + mtLinAndel.AsString);
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
        Saldo:= mtLinGlSaldo.AsCurrency;
        Tilsk:= 0;
        Andel:= mtLinAndel.AsCurrency;
        // Medicinkort
        if (mtLinRegelKom2.AsInteger = 75) or (StamForm.Regel_76_Tilskudspris and (mtLinRegelKom2.AsInteger = 76)) then
        begin
          C2LogAdd('  Andet medicinkort tilskud');
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
              Tilsk:= BeregnTilsk(Andel, KomPrm20);
              Tilsk:= Oprund5Ore(Tilsk);
            end
            else
            begin
              if mtLinVareNr.AsString = '100015' then
                  BevOK:= ChkBoxYesNo('Skal der foretages helbredstillægsberegning?',True)
              else
                  BevOk := True;
              if BevOk then
              begin
                if mtLinRegelKom2.AsInteger = 76 then
                begin
                  if mtLinRegelSyg.AsInteger = 43 then
                    Tilsk:= BeregnTilsk(ESP, KomPrm20)
                  else
                    Tilsk:= BeregnTilsk(BGP, KomPrm20);
                  Tilsk:= Oprund5Ore(Tilsk);

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
          C2LogAdd('    Tilsk ' + CurrToStr(Tilsk));
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
            Tilsk:= BeregnTilsk(Andel, KomPrm24)
          else
            Tilsk:= BeregnTilsk(Andel, KomPrm20);
          Tilsk:= Oprund5Ore(Tilsk);
          C2LogAdd('    Prm0 ' + CurrToStr(KomPrm20));
          C2LogAdd('    Prm4 ' + CurrToStr(KomPrm24));
          C2LogAdd('    Tilsk ' + CurrToStr(Tilsk));
        end;
        if Tilsk > Andel then
          Tilsk:= Andel;
        mtLinTilskKom2.AsCurrency:= Tilsk;
        mtLinAndel.AsCurrency    := Andel - Tilsk;
        C2LogAdd('    Tilskud ' + mtLinTilskKom2.AsString);
        C2LogAdd('    Patient ' + mtLinAndel.AsString);

      finally
        C2LogAdd('Anden Kommune slut');

      end;

    end;
  end;
begin
  with MainDm do
  begin
    klausbool := true;

    SygPrm00                  := 0;
    KomPrm10                  := 0;
    KomPrm11                  := 0;
    KomPrm12                  := 0;
    KomPrm13                  := 0;
    KomPrm14                  := 0;
    KomPrm20                  := 0;
    KomPrm21                  := 0;
    KomPrm22                  := 0;
    KomPrm23                  := 0;
    KomPrm24                  := 0;
    mtLinTilskType.Value      := 0;
    mtLinRegelSyg.Value       := 0;
    mtLinRegelKom1.Value      := 0;
    mtLinRegelKom2.Value      := 0;
    mtLinTilskSyg.AsCurrency  := 0;
    mtLinTilskKom1.AsCurrency := 0;
    mtLinTilskKom2.AsCurrency := 0;

    ESP                       := mtLinESP.AsCurrency * mtLinAntal.Value;
    DOSISESP                  := ESP;
    BGP                       := mtLinBGP.AsCurrency * mtLinAntal.Value;
    DOSISBGP                  := BGP;
    // Ved dosis afrundes ESP til 5 øre
    if mtEksEkspType.Value = et_Dosispakning then
    begin
        DOSISESP                     := Oprund5Ore(DOSISESP);
        DOSISBGP                     := Oprund5Ore(DOSISBGP);
    end;
    mtLinBrutto    .AsCurrency:= ESP;
    mtLinAndel     .AsCurrency:= mtLinBrutto.AsCurrency;
    mtLinJournalNr1.AsString  := '';
    mtLinJournalNr2.AsString  := '';
    mtLinChkJrnlNr1.AsBoolean := FALSE;
    mtLinChkJrnlNr2.AsBoolean := FALSE;

//    if mtLinLinieType.AsInteger <> 1 then begin
//      if frmYesNo.NewYesNoBox('Skal bevillingen gælde for håndkøbslinie?') then
//      process_Kommuner;
//      process_Hermedico;
//      exit;
//    end;
    // Check sygesikring
    if Pos ( mtLinSSKode.AsString,'AJ') > 0 then
    begin
      mtLinTilskType.Value  := 1;
      mtLinRegelSyg.Value := 41;
    end;


{ TODO : COMMENTED OUT }
//    process_CTRBevillinger;
    // Check sygesikring

    process_sygesikring;
//
//    process_EgneBevilling;
//
    // Sygesikring m.m.
    process_sygesikringmm;
//
//    // Kommuner
//    process_Kommuner;
//
//
    // Hermedico
    process_Hermedico;

//    // Anden kommune


//    process_Anden_Kommune;
    BeregnDanmark;
  end;
end;



end.
