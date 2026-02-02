Unit BeregnUdlignOrdinationu;

{ Developed by: Cito IT A/S

  Description: BeregnUdligningOrdination calculates the various support fees for the line

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  13-12-2021/cjs  Changes for using the new CtrTilskudSatser table

}


interface

uses CtrTilskudsSatser;
  procedure BeregnUdligningOrdination;

implementation

uses Sysutils,DM, C2MainLog,c2Procs,ChkBoxes,
      BevillingsOversigt,Main,uC2Common.Procs;



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

procedure BeregnBGP (Saldo, Koeb : currency;
      var BGP0, BGP1, BGP2, BGP3 : Currency);
begin
  with MainDm do
  begin
    BGP0 := Akkumuler (Saldo, Koeb, TilskudsGrp1);
    BGP1 := Akkumuler (Saldo, Koeb, TilskudsGrp2);
    BGP2 := Akkumuler (Saldo, Koeb, TilskudsGrp3);
    BGP3 := Akkumuler (Saldo, Koeb, TilskudsGrpMax);
  end;
end;

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
  BGP0,
  BGP1,
  BGP2,
  BGP3,
  BGP4 : Currency;
begin
  with MainDm do
  begin
    try
      if TilKode <> 1 then
        exit;

      case CtrType of
//        00 : begin // Almen voksen
//          BeregnBGP (CtrSaldo, PRS, BGP0, BGP1, BGP2, BGP3);
//          Tilsk := Tilsk + BeregnTilsk (BGP0, TilPctNorm1);
//          Tilsk := Tilsk + BeregnTilsk (BGP1, TilPctNorm2);
//          Tilsk := Tilsk + BeregnTilsk (BGP2, TilPctNorm3);
//          Tilsk := Tilsk + BeregnTilsk (BGP3, TilPctNorm4);
//        end;
//        01 : begin // Almen barn
//          BeregnBGP (CtrSaldo, PRS, BGP0, BGP1, BGP2, BGP3);
//          Tilsk := Tilsk + BeregnTilsk (BGP0, TilPctBarn1);
//          Tilsk := Tilsk + BeregnTilsk (BGP1, TilPctBarn2);
//          Tilsk := Tilsk + BeregnTilsk (BGP2, TilPctBarn3);
//          Tilsk := Tilsk + BeregnTilsk (BGP3, TilPctBarn4);
//        end;
        0,10 :
        begin // Kroniker voksen
          if CtrSaldo > KronikerGrpVoksen then
          begin
            Tilsk := PRS;
          end
          else
          begin
            Saldo := CtrSaldo;
            Koeb  := PRS;
            BGP0  := Akkumuler (Saldo, Koeb, TilskudsGrp1);
            BGP1  := Akkumuler (Saldo, Koeb, TilskudsGrp2);
            BGP2  := Akkumuler (Saldo, Koeb, TilskudsGrp3);
            BGP3  := Akkumuler (Saldo, Koeb, KronikerGrpVoksen);
            BGP4  := Akkumuler (Saldo, Koeb, TilskudsGrpMax);
            Tilsk := Tilsk + BeregnTilsk (BGP0, TilskudsPctNorm1);
            Tilsk := Tilsk + BeregnTilsk (BGP1, TilskudsPctNorm2);
            Tilsk := Tilsk + BeregnTilsk (BGP2, TilskudsPctNorm3);
            Tilsk := Tilsk + BeregnTilsk (BGP3, TilskudsPctNorm4);
            Tilsk := Tilsk + BGP4;
          end;
        end;
        1,11 :
        begin // Kroniker barn
          if CtrSaldo > KronikerGrpBarn then
          begin
            Tilsk := PRS;
          end
          else
          begin
            Saldo := CtrSaldo;
            Koeb  := PRS;
            BGP0  := Akkumuler (Saldo, Koeb, TilskudsGrp1);
            BGP1  := Akkumuler (Saldo, Koeb, TilskudsGrp2);
            BGP2  := Akkumuler (Saldo, Koeb, TilskudsGrp3);
            BGP3  := Akkumuler (Saldo, Koeb, KronikerGrpBarn);
            BGP4  := Akkumuler (Saldo, Koeb, TilskudsGrpMax);
            Tilsk := Tilsk + BeregnTilsk (BGP0, TilskudsPctBarn1);
            Tilsk := Tilsk + BeregnTilsk (BGP1, TilskudsPctBarn2);
            Tilsk := Tilsk + BeregnTilsk (BGP2, TilskudsPctBarn3);
            Tilsk := Tilsk + BeregnTilsk (BGP3, TilskudsPctBarn4);
            Tilsk := Tilsk + BGP4;
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


procedure BeregnUdligningOrdination;
var
  WBGP,
  ESP,
  BGP,
  Saldo,
  Tilsk,
  Andel : Currency;
  BevOk : Boolean;
  tilATCkode : string;
  atclen : integer;
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
  CannabisProduct : boolean;
begin
  with MainDm do
  begin
    SygPrm00                  := 0;
    KomPrm10                  := 0;
    KomPrm14                  := 0;
    KomPrm20                  := 0;
    KomPrm24                  := 0;
    mtLinTilskType.Value      := 0;
    mtLinRegelSyg.Value       := 0;
    mtLinRegelKom1.Value      := 0;
    mtLinRegelKom2.Value      := 0;
    mtLinTilskSyg.AsCurrency  := 0;
    mtLinTilskKom1.AsCurrency := 0;
    mtLinTilskKom2.AsCurrency := 0;
    ESP                       := mtLinESP.AsCurrency * mtLinAntal.Value;
    BGP                       := mtLinBGP.AsCurrency * mtLinAntal.Value;
    // Ved dosis afrundes ESP til 5 øre
    if mtEksEkspType.Value = et_Dosispakning then
      ESP                     := Oprund5Ore(ESP);
    mtLinBrutto    .AsCurrency:= ESP;
    mtLinAndel     .AsCurrency:= mtLinBrutto.AsCurrency;
    mtLinJournalNr1.AsString  := '';
    mtLinJournalNr2.AsString  := '';
    mtLinChkJrnlNr1.AsBoolean := FALSE;
    mtLinChkJrnlNr2.AsBoolean := FALSE;

   CannabisProduct := IsCannabisProduct(MainDm.nxdb, mtLinLager.AsInteger,
      mtLinSubVareNr.AsString, mtLinTekst.AsString);

  C2LogAdd('Egne bevillinger ordination start');
    // Egne bevillinger
  C2LogAdd('Egne bevillinger ordination slut');
    // Sygesikring m.m.
    if (mtLinRegelSyg.Value > 0) or (mtEksCtrType.Value = 99) then
    begin
            C2LogAdd('Udligning trace 3');
      if mtEksCtrType.Value = 99 then
      begin
            C2LogAdd('Udligning trace 4');
      end
      else
      begin
            C2LogAdd('Udligning trace 6');
        if mtLinRegelSyg.Value in [41..43] then
        begin
            C2LogAdd('Udligning trace 7');
          if mtLinTilskType.Value = 1 then
          begin
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
            BeregnSygesikring (mtLinTilskType.Value,
                               mtLinRegelSyg.Value,
                               mtEksCtrType.Value,
                               Saldo, WBGP, Tilsk);
            mtLinTilskSyg.AsCurrency := Tilsk;
            mtLinAndel.AsCurrency    := ESP - Tilsk;
            if mtEksOrdreType.Value = 2 then
              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency - WBGP
            else
              mtLinNySaldo.AsCurrency := mtLinGlSaldo.AsCurrency + WBGP;
            mtLinBGPBel.AsCurrency   := WBGP;
            mtLinIBTBel.AsCurrency   := Tilsk;
          end;
        end;
      end;
      // Anden amtslig refusion
      if mtLinRegelSyg.Value in [45, 46, 59] then
      begin
            C2LogAdd('Udligning trace 8');
        Tilsk:= BeregnTilsk (ESP, SygPrm00);
        Tilsk:= Oprund5Ore (Tilsk);
        mtLinTilskSyg.AsCurrency := Tilsk;
        mtLinAndel.AsCurrency    := ESP - Tilsk;
      end;
    end;
    // Kommuner
    if not CannabisProduct then begin
    C2LogAdd('Kommunale bevillinger ordination start');
      ffPatTil.First;
      while not ffPatTil.Eof do
      begin
        BevOk:= FALSE;
              C2LogAdd('Udligning trace 9');
        if (Trunc(Date) >= Trunc(ffPatTilFraDato.AsDateTime)) and
           (Trunc(Date) <= Trunc(ffPatTilTilDato.AsDateTime)) then
        begin
          // Marker Hermedico
          if (ffPatTilRegel.AsInteger >= 101) and (ffPatTilRegel.AsInteger <= 109) then
          begin
            if (not BevOk) and (VareTypeAV(mtLinVareType.AsInteger)) then
            begin
    //        if not BevOk then begin
              C2LogAdd('Udligning trace 10');
              BevOK:= BevOversigt(mtLinSubVareNr.AsString,
                                  mtLinATCKode  .AsString,
                                  mtLinTekst    .AsString);
    //          BevOK:= BevOversigt('', '', '');
              // Godkendt
              if BevOk then
              begin
      C2LogAdd('  Første tilskudsvalg');
                KomPrm14                 := ffPatTilPromille5   .AsInteger;
                mtLinRegelKom1 .AsInteger:= ffPatTilRegel       .AsInteger;
                mtLinChkJrnlNr1.AsBoolean:= ffPatTilChkJournalNr.AsBoolean;
                mtLinJournalNr1.AsString := ffPatTilJournalNr   .AsString;
                mtLinAfdeling1 .AsString := ffPatTilAfdelingEj  .AsString;
              end;
            end;
          end;
          // Marker kommunetilskud
          if ffPatTilInstans.AsString = 'Kommune' then
          begin
              C2LogAdd('Udligning trace 11');
            if (ffPatTilRegel.Value = 75) or (StamForm.Regel_76_Tilskudspris and (ffPatTilRegel.Value = 76)) then
              BevOk:= True
            else
            begin
              tilATCkode := trim(ffPatTilAtcKode.AsString);
              atclen := length(tilATCkode);
              if (ffPatTilVareNr.AsString = '') and (tilATCkode = '') then
                BevOK:= BevOversigt('', '', '')
              else
              begin
                if mtLinSubVareNr.AsString = ffPatTilVareNr.AsString then
                  BevOK:= BevOversigt('', '', '')
                else
                  if (tilatckode<>'') and (tilATCkode = copy(mtLinATCKode.AsString,1,atclen)) then
                    BevOK:= BevOversigt('', '', '')
                  else
                    BevOk := False;
              end;
            end;
    //          BevOK:= BevOversigt('', '', '');
    (*
              BevOK:= BevOversigt(mtLinSubVareNr.AsString,
                                  mtLinATCKode  .AsString,
                                  mtLinTekst    .AsString);
    *)
            // Godkendt
            if BevOk then
            begin
              // Check kommunenr
              if (ffPatKarKommune.AsInteger < 100) or
                 (ffPatKarKommune.AsInteger > 999) then
                 begin
                // Ingen kommunenr fejlmeld
                ChkBoxOK('Mangler kommunenr på patient!');
                BevOk:= FALSE;
              end;
            end;
            if BevOK then
            begin
              if mtLinRegelKom1.AsInteger = 0 then
              begin
      C2LogAdd('  Første tilskudsvalg');
                KomPrm10 := ffPatTilPromille1.Value;
                KomPrm11 := ffPatTilPromille2.Value;
                KomPrm12 := ffPatTilPromille3.Value;
                KomPrm13 := ffPatTilPromille4.Value;
                KomPrm14 := ffPatTilPromille5.Value;
                mtLinRegelKom1.AsInteger  := ffPatTilRegel.AsInteger;
                mtLinChkJrnlNr1.AsBoolean := ffPatTilChkJournalNr.AsBoolean;
                mtLinJournalNr1.AsString  := ffPatTilJournalNr.AsString;
                mtLinAfdeling1.AsString   := ffPatTilAfdeling.AsString;
                if mtLinTilskType.Value = 0 then
                begin
                  if Trim (ffPatTilAfdelingEj.AsString) <> '' then
                    mtLinAfdeling1.AsString := ffPatTilAfdelingEj.AsString;
                end;
      C2LogAdd('    Regel ' + mtLinRegelKom1.AsString);
      C2LogAdd('    Prm0 '  + IntToStr(KomPrm10));
      C2LogAdd('    Prm1 '  + IntToStr(KomPrm11));
      C2LogAdd('    Prm2 '  + IntToStr(KomPrm12));
      C2LogAdd('    Prm3 '  + IntToStr(KomPrm13));
      C2LogAdd('    Prm4 '  + IntToStr(KomPrm14));
      C2LogAdd('    Jnlnr ' + mtLinJournalNr1.AsString);
      C2LogAdd('    Afd '   + mtLinAfdeling1.AsString);
              end
              else
              begin
                if mtLinRegelKom2.AsInteger = 0 then
                begin
      C2LogAdd('  Andet tilskudsvalg');
                  KomPrm20 := ffPatTilPromille1.Value;
                  KomPrm21 := ffPatTilPromille2.Value;
                  KomPrm22 := ffPatTilPromille3.Value;
                  KomPrm23 := ffPatTilPromille4.Value;
                  KomPrm24 := ffPatTilPromille5.Value;
                  mtLinRegelKom2.AsInteger  := ffPatTilRegel.AsInteger;
                  mtLinChkJrnlNr2.AsBoolean := ffPatTilChkJournalNr.AsBoolean;
                  mtLinJournalNr2.AsString  := ffPatTilJournalNr.AsString;
                  mtLinAfdeling2.AsString   := ffPatTilAfdeling.AsString;
                  if mtLinTilskType.Value = 0 then
                  begin
                    if Trim (ffPatTilAfdelingEj.AsString) <> '' then
                      mtLinAfdeling2.AsString := ffPatTilAfdelingEj.AsString;
                  end;
      C2LogAdd('    Regel ' + mtLinRegelKom2.AsString);
      C2LogAdd('    Prm0 '  + IntToStr(KomPrm20));
      C2LogAdd('    Prm1 '  + IntToStr(KomPrm21));
      C2LogAdd('    Prm2 '  + IntToStr(KomPrm22));
      C2LogAdd('    Prm3 '  + IntToStr(KomPrm23));
      C2LogAdd('    Prm4 '  + IntToStr(KomPrm24));
      C2LogAdd('    Jnlnr ' + mtLinJournalNr2.AsString);
      C2LogAdd('    Afd '   + mtLinAfdeling2.AsString);
                end
                else
                  ChkBoxOK ('Kun to kommunale tilskud!');
              end;
            end;
          end;
        end;
        ffPatTil.Next;
      end;

    end;
    // Hermedico
    if (mtLinRegelKom1.AsInteger >= 101) and (mtLinRegelKom1.AsInteger <= 109) then
    begin
            C2LogAdd('Udligning trace 12');
      Saldo:= mtLinGlSaldo.AsCurrency;
      Tilsk:= 0;
      Andel:= mtLinAndel.AsCurrency;
      if KomPrm14 <> 0 then
        Tilsk:= BeregnTilsk(Andel, KomPrm14)
      else
        Tilsk:= BeregnTilsk(Andel, KomPrm10);
      Tilsk:= Oprund5Ore(Tilsk);
      if Tilsk > Andel then
        Tilsk:= Andel;
      mtLinTilskKom1.AsCurrency:= Tilsk;
      mtLinAndel    .AsCurrency:= Andel - Tilsk;
  (*
      Tilsk:= BeregnTilsk(mtLinAndel.AsCurrency, KomPrm14);
      Tilsk:= Oprund5Ore(Tilsk);
      if Tilsk > mtLinAndel.AsCurrency then
        Tilsk:= mtLinAndel.AsCurrency;
      mtLinTilskKom1.AsCurrency:= Tilsk;
      mtLinAndel    .AsCurrency:= mtLinAndel.AsCurrency - Tilsk;
  *)
    end
    else
    begin
            C2LogAdd('Udligning trace 13');
      // Første kommune
      if mtLinRegelKom1.AsInteger > 0 then
      begin
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
            if Trunc(Date) < EncodeDate(2005, 4, 1) then
            begin
              Tilsk:= BeregnTilsk(Andel, KomPrm10);
              Tilsk:= Oprund5Ore(Tilsk);
            end
            else
            begin
              // fejl medkort retur if ctr band switch.
              if mtEksOrdreType.Value = 2 then
              begin
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
                  BeregnMedkort(0, mtEksCtrType.Value, Saldo, ESP, ESP, KomPrm10, Tilsk)
                else
                  BeregnMedkort(0, mtEksCtrType.Value, Saldo, ESP, BGP, KomPrm10, Tilsk);
              end;
            end;
          end;
    C2LogAdd('    Tilsk ' + CurrToStr(Tilsk));
        end
        else
        begin
    C2LogAdd('  Første kommunale tilskud');
          // Andre kommunale tilskud
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
    if not CannabisProduct then
    begin

      // Anden kommune
      if mtLinRegelKom2.AsInteger > 0 then
      begin
        Saldo:= mtLinGlSaldo.AsCurrency;
        Tilsk:= 0;
        Andel:= mtLinAndel.AsCurrency;
        // Medicinkort
        if (mtLinRegelKom2.AsInteger = 75) or (StamForm.Regel_76_Tilskudspris and (mtLinRegelKom2.AsInteger = 76)) then
        begin
    C2LogAdd('  Andet medicinkort tilskud');
          if mtLinRegelKom2.AsInteger = 76 then
          BGP := BGP - mtLinTilskSyg.AsCurrency - mtLinTilskKom1.AsCurrency;
    C2LogAdd('  Andet medicinkort tilskud');
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
      end;
    C2LogAdd('Kommunale bevillinger ordination slut');
    end;
    BeregnDanmark;
  end;
end;


end.
