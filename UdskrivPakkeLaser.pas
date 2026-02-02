{$I bsdefine.inc}

unit UdskrivPakkeLaser;

{ Developed by: Cito IT A/S
  
  Description: Print a pakkelist
  
  Highest assigned Tilstand: 100000.
  
  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  13-06-2019/cjs  Corrected calculation of start saldos
}
  
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons,
  uC2Vareidentifikator.Classes,
  RPDefine,DBClient;

type
  TfmPakkeLaser = class(TForm)
    paPrm: TPanel;
    gbPakke: TGroupBox;
    eNr: TEdit;
    buUdskriv: TBitBtn;
    buFortryd: TBitBtn;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure buUdskrivClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    function  DanFormular : Boolean;
  private
    { Private declarations }
    DMVSProducts : boolean;
  public
    { Public declarations }
    class procedure UdskrivPakkeseddelLaser (Nr : LongWord);
  end;


implementation

uses
  LaserFormularer,
  C2MainLog,

  C2Procs,
  ChkBoxes,
  DM,
  UbiPrinter,
  uC2Vareidentifikator.Types,uC2Common.Procs,
  C2PrinterSelection;

{$R *.DFM}



procedure TfmPakkeLaser.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, [#13, #27]) then
    exit;
  if Key = #13 then
  begin
    SelectNext(ActiveControl, TRUE, TRUE);
    Key := #0;
    exit;
  end;
  if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key := #0;
    exit;
  end;

end;

class procedure TfmPakkeLaser.UdskrivPakkeseddelLaser(Nr: LongWord);
begin
  with MainDm do
  begin
    with TfmPakkeLaser.Create (NIL) do
    begin
    try
      eNr.Text := IntToStr (Nr);
      ShowModal;
    finally
      Free;
    end;
    end;
  end;

end;

procedure TfmPakkeLaser.FormActivate(Sender: TObject);
begin
  if eNr.Text <> '0' then
    PostMessage(buUdskriv.Handle, BM_Click, 0, 0)
  else
    eNr.SetFocus;
end;

procedure TfmPakkeLaser.buUdskrivClick(Sender: TObject);
var
  GemIdx : String;
begin
  with MainDm, dmFormularer do
  begin
    C2LogAdd('Start print pakkeseddel ' + eNr.Text);
    Application.ProcessMessages;
    DMVSProducts := False;
    // Disable knapper

    buUdskriv.Enabled := False;
    buFortryd.Enabled := False;
    GemIdx := ffEksOvr.IndexName;
    ffEksOvr.IndexName := 'PakkeNrOrden';
    try
      ffEksOvr.SetRange([StrToInt(eNr.Text)], [StrToInt(eNr.Text)]);
      try
        if not DanFormular then
          exit;
        try
          // Printermulighed
          if PakkeSedPrn <> '' then
          begin
            // Forvalg
            if C2SelectPrinter(PakkeSedPrn, rpSystem, 'Faktura ' + eNr.Text)
            then
              C2LogAdd('printer selected ok ')
            else
              C2LogAdd('printer NOT selected ok ')

          end;
          // Bakkemulighed
          if PakkeSedBin <> '' then
          begin
            // Forvalg
            IF C2SelectBin(PakkeSedBin) then
              C2LogAdd('bin selcted ok')
            else
              C2LogAdd('bin NOT selected ok');
          end;
          // Eksekver rapport
          rpSystem.SystemPrinter.Copies := PakkeSedAnt;
          rpSystem.SystemSetups := rpSystem.SystemSetups - [ssAllowSetup];
          rpProjekt.ProjectFile := PakkeSedFil;
          rpSystem.DoNativeOutput := TRUE;
          rpSystem.RenderObject := Nil;
          rpSystem.DefaultDest := rdPrinter;
          rpSystem.OutputFileName := '';
          rpProjekt.Open;
          rpProjekt.ExecuteReport(PakkeSedFrm);
        finally
          rpProjekt.Close;
        end;
        try
          rpProjekt.Open;
          rpProjekt.Engine := rpSystem;
          rpSystem.DoNativeOutput := False;
          rpSystem.RenderObject := rpPDF;
          rpSystem.DefaultDest := rdFile;
          if FileExists(PDFFolderPakke + format('PAKKE%8.8d',
            [StrToInt(eNr.Text)]) + '.pdf') then
            DeleteFile(PDFFolderPakke + format('PAKKE%8.8d',
              [StrToInt(eNr.Text)]) + '.pdf');
          rpSystem.OutputFileName := PDFFolderPakke +
            format('FAKT%8.8d', [StrToInt(eNr.Text)]) + '.pdf';
          dmFormularer.rpSystem.SystemSetups := rpSystem.SystemSetups -
            [ssAllowSetup];
          rpProjekt.ProjectFile := PakkeSedFil;
          rpProjekt.ExecuteReport(PakkeSedFrm);

        finally
          rpProjekt.Close;
        end;

      except
        on e: exception do
        begin
          ChkBoxOk('Exception i pakkeseddel laserprinter !' + e.Message);
        end;
      end;
    finally
      ffEksOvr.CancelRange;
      ffEksOvr.IndexName := GemIdx;
      buUdskriv.Enabled := TRUE;
      buFortryd.Enabled := TRUE;
      ModalResult := mrOk;
      C2LogAdd('End print pakkeseddel');
    end;
  end;
end;

function TfmPakkeLaser.DanFormular : Boolean;
var
//  DebitorRec : TDebitorRec;
  LinAntal   : Integer;
  CtrSaldoA,
  CtrSaldoB,
  CtrIndBel,
  LinPris,
  LinSygTilsk,
  LinKomTilsk,
  LinPatAndel,
  LinBrutto,
  TotTlfGebyr,
  TotEdbGebyr,
  TotUdbrGebyr,
  TotSygTilsk,
  TotKomTilsk,
  TotPatAndel,
  TotDkTilsk,
  TotDkEjTilsk,
  TotNetto,
  TotMoms,
  TotBrutto  : Currency;
  WrkStr,
  CtrUdDato  : String;
  CtrUdDatoB  : String;
  LinNr      : Word;
  CtrFirst   : Boolean;
  LevNr : string;
  saveindex : string;
  udbrtxt : string;
  Fak,
  Bet : currency;
  SaveLbnr : integer;
  Til : string;
  TopLbnr: integer;
  i: integer;
  CTRALbnr : integer;
  CTRBLbnr : integer;

  procedure AddTxt (Tab : TClientDataset;
                    Txt : String;
                    Bel : String);
  begin
    with dmFormularer do
    begin
      Tab.Append;
      Tab.FieldByName ('Txt').AsString := Txt;
      Tab.FieldByName ('Bel').AsString := Bel;
      Tab.Post;
      C2LogAdd(tab.Name + ' ' + Txt + ' ' + Bel);
    end;
  end;

  procedure AddLin (VareNr : String;
                   KortTxt : String;
                   LangTxt : String;
                     Antal : String;
                      Pris : String;
                  AndetBel : String;
                  SygTilsk : String;
                  KomTilsk : String;
                  PatAndel : String;
                    Brutto : String);
  begin
    with dmFormularer do
    begin
      mtDetail.Append;
      mtDetailVareNr  .AsString := VareNr;
      mtDetailKortTxt .AsString := KortTxt;
      mtDetailLangTxt .AsString := LangTxt;
      mtDetailAntal   .AsString := Antal;
      mtDetailPris    .AsString := Pris;
      mtDetailAndetBel.AsString := AndetBel;
      mtDetailSygTilsk.AsString := SygTilsk;
      mtDetailKomTilsk.AsString := KomTilsk;
      mtDetailPatAndel.AsString := PatAndel;
      mtDetailBrutto  .AsString := Brutto;
      mtDetail.Post;
    end;
  end;

  procedure CheckFridgeProduct(varenr : string);
  var
    save_index : string;
  begin
    with MainDm,dmFormularer do
    begin
      c2logadd('check køl for ' + varenr);
      save_index := ffLagKar.IndexName;
      ffLagKar.IndexName := 'NrOrden';

      try
        if ffLagKar.FindKey([ffEksOvrLager.AsInteger,varenr]) then
        begin
          if ffLagKarOpbevKode.AsString = 'H' then
            mtMasterKoel.AsString := 'KØL';
          if ffLagKarOpbevKode.AsString = 'K' then
            mtMasterKoel.AsString := 'KØL';
        end;
      finally
        fflagkar.indexname := save_index;
      end;
      C2LogAdd('køl is ' + mtMasterKoel.AsString);
    end;

  end;

  ///  <summary> This routine true if the product is a DMVS product
  /// </summary>
  /// <param name = "ALager"> Lager of the product being check
  /// </param>
  /// <param name = "AVarenr"> The varenr of the product being check
  /// </param>
  /// <returns> true if the product is marked DMVS false otherwise
  /// </returns>

  function CheckDMVSProduct(ALager: Integer; AVarenr: string): Boolean;
  var
    Vareident: TC2Vareident;
  begin
    try
      Vareident := TC2Vareident.Create(MainDm.nxDB, ALager, AVarenr, True);
      Result := Vareident.DMVSKlassificering = dmklDMVSVare;
    except
      Result := False;
    end;

    Vareident.Free;
  end;

  // routine to set mtmastertilbagedato to earliest return date

  procedure SetEarliestTilbageDato;
  var
    TilbageDato : TDateTime;
  begin
    with MainDm,dmFormularer do
    begin
      C2LogAdd('start of setearliestilbagedato');
      ffEksOvr.First;
      // initialise the earliest date to that of the first ekspedition
      C2LogAdd(format('initialise tilbage dato %s %d',
        [FormatDateTime('dd-mm-yyyy', ffEksOvrTakserDato.AsDateTime),
        ffEksOvrReturdage.AsInteger]));
      TilbageDato := ffEksOvrTakserDato.AsDateTime + ffEksOvrReturdage.AsInteger;
      C2LogAdd('initialise tilbagedato is now ' + FormatDateTime('dd-mm-yyyy',TilbageDato));
      while not ffEksOvr.Eof do
      begin
        C2LogAdd(Format('lbnr is %d %s %d', [ffeksovrlbnr.AsInteger,
          FormatDateTime('dd-mm-yyyy', ffEksOvrTakserDato.AsDateTime),
          ffEksOvrReturdage.AsInteger]));
        // if current ekspedition ia less than current earlist date then update earlist date
        if TilbageDato > (ffEksOvrTakserDato.AsDateTime + ffEksOvrReturdage.AsInteger) then
          TilbageDato := ffEksOvrTakserDato.AsDateTime + ffEksOvrReturdage.AsInteger;
        C2LogAdd('Tilbage date is now '  + FormatDateTime('dd-mm-yyyy',TilbageDato));
        ffEksOvr.Next;
      end;
      mtMasterTilbDato.AsString := FormatDateTime('dd-mm-yyyy',TilbageDato);
      C2LogAdd('*** Latest return date is ' + mtMasterTilbDato.AsString);

    end;

  end;

begin
  with MainDm, dmFormularer do
  begin
    C2LogAdd ('DanFormular in');
    // Result ved fejl
    Result := False;
    ffEksOvr.First;
    // Udfyld felter fra første recept
    if not ffDebKar.FindKey([ffEksOvrKontoNr.AsString]) then
    begin
      ChkBoxOk ('Debitorkonto findes ikke i kartotek !');
      Exit;
    end;
  (*
    FillChar (DebitorRec, SizeOf (DebitorRec), 0);
    DebitorRec.Nr := ffEksOvrKontoNr.AsString;
    MidClient.HentDeb (DebitorRec);
    if not DebitorRec.Status = 0 then begin
      ChkBoxOk ('Debitor findes ikke !');
      Exit;
    end;
  *)
    // Tøm memorytables
    C2LogAdd ('DanFormular tøm memorytables');
    mtMaster.Close;
    mtMaster.Open;
    if mtMaster.RecordCount <> 0 then
    begin
      mtMaster.First;
      while not mtMaster.Eof do
        mtMaster.Delete;
    end;
    mtDetail.Close;
    mtDetail.Open;
    if mtDetail.RecordCount <> 0 then
    begin
      mtDetail.First;
      while not mtDetail.Eof do
        mtDetail.Delete;
    end;
    mtCtrLin.Close;
    mtCtrLin.Open;
    if mtCtrLin.RecordCount <> 0 then
    begin
      mtCtrLin.First;
      while not mtCtrLin.Eof do
        mtCtrLin.Delete;
    end;
    mtCtrBLin.Close;
    mtCtrBLin.Open;
    if mtCtrBLin.RecordCount <> 0 then
    begin
      mtCtrBLin.First;
      while not mtCtrBLin.Eof do
        mtCtrBLin.Delete;
    end;
    mtDanLin.Close;
    mtDanLin.Open;
    if mtDanLin.RecordCount <> 0 then
    begin
      mtDanLin.First;
      while not mtDanLin.Eof do
        mtDanLin.Delete;
    end;
    // Diverse felter
    C2LogAdd ('DanFormular append Master');
    mtMaster.Append;
    mtMasterPakkeNr .Value    := ffEksOvrPakkeNr.Value;
    mtMasterEkspDato.AsString := FormatDateTime('dd-mm-yyyy',ffEksOvrTakserDato.AsDateTime);
    SetEarliestTilbageDato;
    if ffEksOvrDKMedlem.Value = 1 then
      mtMasterDKmedlem.AsString := ffEksOvrDKMedlem.AsString;
    if ffEksOvrBrugerTakser.Value > 0 then
      mtMasterBrTakser.AsString := ffEksOvrBrugerTakser.AsString;
    // Navn og adresse på debitor
    mtMasterDeNr  .AsString := ffDebKarKontoNr.AsString;
    mtMasterDeNavn.AsString := Trim (ffDebKarNavn.AsString);
    mtMasterDeAdr1.AsString := Trim (ffDebKarAdr1.AsString);
    mtMasterDeAdr2.AsString := Trim (ffDebKarAdr2.AsString);
    if mtMasterDeAdr2.AsString = '' then
      mtMasterDeAdr2.AsString := Trim (ffDebKarPostNr.AsString + ' ' + ffDebKarBy.AsString)
    else
      mtMasterDeAdr3.AsString := Trim (ffDebKarPostNr.AsString + ' ' + ffDebKarBy.AsString);
    // Navn og adresse på patienten
    mtMasterPaNr  .AsString := Trim (ffEksOvrKundeNr.AsString);
    mtMasterPaNavn.AsString := Trim (BytNavn (ffEksOvrNavn.AsString));
    mtMasterPaAdr1.AsString := Trim (ffEksOvrAdr1.AsString);
    mtMasterPaAdr2.AsString := Trim (ffEksOvrAdr2.AsString);
    WrkStr                  := Trim (ffEksOvrPostNr.AsString);
    if WrkStr <> '' then
    begin
      ffPnLst.IndexName := 'NrOrden';
      if ffPnLst.FindKey ([WrkStr]) then
        WrkStr := WrkStr + ' ' + ffPnLstByNavn.AsString;
    end;
    if mtMasterPaAdr2.AsString = '' then
      mtMasterPaAdr2.AsString := WrkStr
    else
      mtMasterPaAdr3.AsString := WrkStr;

    mtMasterLevNavn.AsString := '';
    c2logadd('køl is blanked');
    mtMasterKoel.AsString := '';
    LevNr := Spaces(10);
    if Trim(ffEksOvrLevNavn.AsString) <> '' then
      LevNr:= AddSpaces(Trim(ffEksOvrLevNavn.AsString), 10);



    mtMasterPaTlfNr.AsString := '';

    // add the turnr

    mtMasterTurnr.AsInteger := ffEksOvrTurNr.AsInteger;

    // Beregn alle totaler
    C2LogAdd ('DanFormular nulstil totaler');
    TotSygTilsk  := 0;
    TotKomTilsk  := 0;
    TotPatAndel  := 0;
    TotBrutto    := 0;
    CtrSaldoA    := 0;
    CtrSaldoB    := 0;
    CtrUdDato    := '';
    CtrFirst     := True;
    SaveLbnr := 0;


    ffEksOvr.First;


    CTRALbnr := 0;
    TopLbnr := 0;
    while not ffEksOvr.Eof  do
    begin
      if TopLbnr = 0 then
      begin
        TopLbnr := ffEksOvrLbNr.AsInteger;
        for i := 1 to ffEksOvrAntLin.AsInteger  do
        begin
          if not ffEksLin.FindKey([TopLbnr,i]) then
            continue;
          if not ffEksTil.FindKey([TopLbnr,i]) then
            continue;

          if IsCannabisProduct(MainDm.nxdb, ffEksLinLager.AsInteger,
            ffEksLinSubVareNr.AsString, ffEksLinTekst.AsString,ffEksLinDrugId.AsString) then
            continue;

          if ffEksLinSubVareNr.AsString ='100015' then
          begin
            CtrSaldoA := ffEksOvrCtrSaldo.AsCurrency;
            CTRALbnr := ffEksOvrLbNr.AsInteger;
            break;
          end
          else
          begin
            if ffEksOvrOrdreType.AsInteger = 2 then
              CtrSaldoA := ffEksTilSaldo.AsCurrency + ffEksTilBGPBel.AsCurrency
            else
              CtrSaldoA := ffEksTilSaldo.AsCurrency - ffEksTilBGPBel.AsCurrency;
              CTRALbnr := ffEksOvrLbNr.AsInteger;
              break;
          end;

//          // if we get here then we hve the start saldo
//          if ffEksTilBGPBel.AsCurrency <> 0 then
//            break;


        end;

      end
      ELSE
      begin
        TopLbnr := ffEksOvrLbNr.AsInteger;
        for i := 1 to ffEksOvrAntLin.AsInteger  do
        begin
          if not ffEksLin.FindKey([TopLbnr,i]) then
            continue;
          if not ffEksTil.FindKey([TopLbnr,i]) then
            continue;

          if IsCannabisProduct(MainDm.nxdb, ffEksLinLager.AsInteger,
            ffEksLinSubVareNr.AsString, ffEksLinTekst.AsString,ffEksLinDrugId.AsString) then
            continue;

          if ffEksLinSubVareNr.AsString ='100015' then
          begin
            if (CTRALbnr = 0) or (ffEksOvrLbNr.AsInteger < CTRALbnr) then
            begin
              CtrSaldoA := ffEksOvrCtrSaldo.AsCurrency;
              CTRALbnr := ffEksOvrLbNr.AsInteger;
              break;
            end;
          end
          else
          begin
            if (CTRALbnr = 0) or (ffEksOvrLbNr.AsInteger < CTRALbnr) then
            begin
              if ffEksOvrOrdreType.AsInteger = 2 then
                CtrSaldoA := ffEksTilSaldo.AsCurrency + ffEksTilBGPBel.AsCurrency
              else
                CtrSaldoA := ffEksTilSaldo.AsCurrency - ffEksTilBGPBel.AsCurrency;
              CTRALbnr := ffEksOvrLbNr.AsInteger;
              break;
            end;
          end;

//          // if we get here then we hve the start saldo
//          if ffEksTilBGPBel.AsCurrency <> 0 then
//            break;

        end;
      end;
      ffEksOvr.Next;
    end;

    // now for ctr B

    ffEksOvr.First;
    TopLbnr := 0;
    CTRBLbnr := 0;
    while not ffEksOvr.Eof  do
    begin
      if TopLbnr = 0 then
      begin
        TopLbnr := ffEksOvrLbNr.AsInteger;
        for i := 1 to ffEksOvrAntLin.AsInteger  do
        begin
          if not ffEksLin.FindKey([TopLbnr,i]) then
            continue;
          if not ffEksTil.FindKey([TopLbnr,i]) then
            continue;

          if not IsCannabisProduct(MainDm.nxdb, ffEksLinLager.AsInteger,
            ffEksLinSubVareNr.AsString, ffEksLinTekst.AsString,ffEksLinDrugId.AsString) then
            continue;

          if ffEksLinSubVareNr.AsString ='100015' then
          begin
            CtrSaldoB := ffEksOvrCtrSaldo.AsCurrency;
            CTRBLbnr := ffEksOvrLbNr.AsInteger;
            break;
          end
          else
          begin
            if ffEksOvrOrdreType.AsInteger = 2 then
              CtrSaldoB := ffEksTilSaldo.AsCurrency + ffEksTilBGPBel.AsCurrency
            else
              CtrSaldoB := ffEksTilSaldo.AsCurrency - ffEksTilBGPBel.AsCurrency;
            CTRBLbnr := ffEksOvrLbNr.AsInteger;
            break;
          end;

          // if we get here then we hve the start saldo
          if ffEksTilBGPBel.AsCurrency <> 0 then
            break;


        end;

      end
      else
      begin
        TopLbnr := ffEksOvrLbNr.AsInteger;
        for i := 1 to ffEksOvrAntLin.AsInteger  do
        begin
          if not ffEksLin.FindKey([TopLbnr,i]) then
            continue;
          if not ffEksTil.FindKey([TopLbnr,i]) then
            continue;

          if not IsCannabisProduct(MainDm.nxdb, ffEksLinLager.AsInteger,
            ffEksLinSubVareNr.AsString, ffEksLinTekst.AsString,ffEksLinDrugId.AsString) then
            continue;

          if ffEksLinSubVareNr.AsString ='100015' then
          begin
            if (CTRBLbnr = 0) or (ffEksOvrLbNr.AsInteger < CTRBLbnr) then
            begin
              CtrSaldoB := ffEksOvrCtrSaldo.AsCurrency;
              CTRBLbnr := ffEksOvrLbNr.AsInteger;
              break;
            end;
          end
          else
          begin
            if (CTRBLbnr = 0) or (ffEksOvrLbNr.AsInteger < CTRBLbnr) then
            begin
              if ffEksOvrOrdreType.AsInteger = 2 then
                CtrSaldoB := ffEksTilSaldo.AsCurrency + ffEksTilBGPBel.AsCurrency
              else
                CtrSaldoB := ffEksTilSaldo.AsCurrency - ffEksTilBGPBel.AsCurrency;
              CTRBLbnr := ffEksOvrLbNr.AsInteger;
              break;
            end;
          end;

          // if we get here then we hve the start saldo
          if ffEksTilBGPBel.AsCurrency <> 0 then
            break;

        end;
      end;
      ffEksOvr.Next;
    end;
    ffEksOvr.First;


    // Udfyld felter fra gennemløb
    C2LogAdd ('DanFormular recept gennemløb');
    while not ffEksOvr.Eof do
    begin
      if ffEksOvrLbNr.AsInteger <> SaveLbnr then
      begin
        // Indsæt linie
        AddLin ('',
                'Lbnr ' + ffEksOvrLbNr.AsString,
                'Lbnr ' + ffEksOvrLbNr.AsString,
                '','','','','','','');
      end;
      try
        if mtMasterPaTlfNr.AsString = '' then
        begin
          if ffPatUpd.FindKey ([ffEksOvrKundeNr.AsString]) then
            mtMasterPaTlfNr.AsString := ffPatUpdTlfNr.AsString;
        end;
      except
      end;
      SaveLbnr := ffEksOvrLbNr.AsInteger;
      // Tillæg gebyrer afhængig om det er kreditnota
      TotTlfGebyr  := ffEksOvrTlfGebyr .AsCurrency;
      TotEdbGebyr  := ffEksOvrEdbGebyr .AsCurrency;
      TotUdbrGebyr := ffEksOvrUdbrGebyr.AsCurrency;
      TotDkTilsk   := ffEksOvrDKTilsk  .AsCurrency;
      TotDkEjTilsk := ffEksOvrDKEjTilsk.AsCurrency;
      if ffEksOvrOrdreType.Value = 2 then
      begin
        TotTlfGebyr  := -TotTlfGebyr;
        TotEdbGebyr  := -TotEdbGebyr;
        TotUdbrGebyr := -TotUdbrGebyr;
        TotDkTilsk   := -TotDKTilsk;
        TotDkEjTilsk := -TotDKEjTilsk;
      end;
      // Summer totaler fra gebyrer
      TotPatAndel := TotPatAndel + TotTlfGebyr;
      TotPatAndel := TotPatAndel + TotEdbGebyr;
      TotPatAndel := TotPatAndel + TotUdbrGebyr;
      for LinNr := 1 to ffEksOvrAntLin.Value do
      begin
        if not ffEksLin.FindKey ([ffEksOvrLbNr.Value, LinNr]) then
          continue;
        if not ffEksTil.FindKey ([ffEksOvrLbNr.Value, LinNr]) then
          continue;
       // Tillæg linieandele afhængig om det er kreditnota
        LinPatAndel := ffEksTilAndel    .AsCurrency;
        LinSygTilsk := ffEksTilTilskSyg .AsCurrency;
        LinKomTilsk := ffEksTilTilskKom1.AsCurrency +
                       ffEksTilTilskKom2.AsCurrency;
        LinAntal    := ffEksLinAntal    .AsInteger;
        LinPris     := ffEksLinPris     .AsCurrency;
        if ffEksOvrOrdreType.Value = 2 then
        begin
          LinPatAndel := -LinPatAndel;
          LinSygTilsk := -LinSygTilsk;
          LinKomTilsk := -LinKomTilsk;
          LinAntal    := -LinAntal;
        end;
        LinBrutto   := LinPatAndel + LinSygTilsk + LinKomTilsk;
        // Summer totaler fra linier
        TotPatAndel := TotPatAndel + LinPatAndel;
        TotSygTilsk := TotSygTilsk + LinSygTilsk;
        TotKomTilsk := TotKomTilsk + LinKomTilsk;
        TotBrutto   := TotBrutto   + LinBrutto;
        // Indsæt linie
        CheckFridgeProduct(ffEksLinSubVareNr.AsString);

        // only check for dmvs if there are none so far
        if DMVSSvrConnection.DMVSIntegrationEnabled and (not DMVSProducts) then
          DMVSProducts := CheckDMVSProduct(ffEksLinLager.AsInteger, ffEksLinSubVareNr.AsString);
        C2LogAdd('*** dmvsproducts is ' + Bool2Str(DMVSProducts));

        Til := '';
        if (ffEksLinUdlevNr.AsInteger <= 1) and (ffEksLinUdlevNr.AsInteger >= ffEksLinUdlevMax.AsInteger) then
          Til := ''
        else
          Til := 'Udl ' + IntToStr (ffEksLinUdlevNr.Value) + '/' + IntToStr (ffEksLinUdlevMax.Value);
        if Til <> '' then
          AddLin (ffEksLinSubVareNr.AsString,
                  Til + ' ' + ffEksLinTekst    .AsString,
                  Til + ' ' + ffEksLinTekst    .AsString + ' ' +
                  ffEksLinPakning  .AsString + ' ' +
                  ffEksLinForm     .AsString + ' ' +
                  ffEksLinStyrke   .AsString,
                  IntToStr    (LinAntal),
                  FormatCurr('###,##0.00', LinPris),
                  '',
                  FormatCurr('###,##0.00', LinSygTilsk),
                  FormatCurr('###,##0.00', LinKomTilsk),
                  FormatCurr('###,##0.00', LinPatAndel),
                  FormatCurr('###,##0.00', LinBrutto))
        else
          AddLin (ffEksLinSubVareNr.AsString,
                  ffEksLinTekst    .AsString,
                  ffEksLinTekst    .AsString + ' ' +
                  ffEksLinPakning  .AsString + ' ' +
                  ffEksLinForm     .AsString + ' ' +
                  ffEksLinStyrke   .AsString,
                  IntToStr    (LinAntal),
                  FormatCurr('###,##0.00', LinPris),
                  '',
                  FormatCurr('###,##0.00', LinSygTilsk),
                  FormatCurr('###,##0.00', LinKomTilsk),
                  FormatCurr('###,##0.00', LinPatAndel),
                  FormatCurr('###,##0.00', LinBrutto));
        // Ctr oplysninger
        CtrIndBel := ffEksTilBGPBel.AsCurrency;
        if ffEksOvrOrdreType.Value = 2 then
          CtrIndBel := -CtrIndBel;
        // Første Ctr primo saldo
        if CtrFirst then
        begin
          if (CtrIndBel <> 0) or (ffEksLinSubVareNr.AsString ='100015') then
          begin
            if ffPatUpd.FindKey ([ffEksOvrKundeNr.AsString]) then
            begin
              if not ffPatUpdCtrUdDato.IsNull then
                CtrUdDato := FormatDateTime ('dd-mm-yyyy', ffPatUpdCtrUdDato.AsDateTime);
              if not ffPatUpdCtrUdDatoB.IsNull then
                CtrUdDatoB := FormatDateTime ('dd-mm-yyyy', ffPatUpdCtrUdDatoB.AsDateTime);
            end;

            CtrFirst := False;
          end;
        end;
        // Tilføj evt. Ctr linie
        if (CtrIndBel <> 0) or (ffEksLinSubVareNr.AsString ='100015') then
        begin
          if isCannabisProduct(MainDm.nxDB, ffEksLinLager.AsInteger,
            ffEksLinSubVareNr.AsString, ffEksLinTekst.AsString,ffEksLinDrugId.AsString) then
          begin

            // Første gang overskrift
            if mtCtrBLin.RecordCount = 0 then
            begin
              AddTxt (mtCtrBLin, '', '');
              AddTxt (mtCtrBLin, 'Oplysninger til CTRB', '');
              AddTxt (mtCtrBLin, '   Anvendt saldo', FormatCurr('###,##0.00', CtrSaldoB));
            end;
            AddTxt (mtCtrBLin, '   Indberettet for ' + ffEksLinSubVareNr.AsString,
                    FormatCurr('###,##0.00', CtrIndBel));
            CtrSaldoB := CtrSaldoB + CtrIndBel;
          end
          else
          begin
            // Første gang overskrift
            if mtCtrLin.RecordCount = 0 then
            begin
              AddTxt (mtCtrLin, '', '');
              AddTxt (mtCtrLin, 'Oplysninger til CTR', '');
              AddTxt (mtCtrLin, '   Anvendt saldo', FormatCurr('###,##0.00', CtrSaldoA));
            end;
            AddTxt (mtCtrLin, '   Indberettet for ' + ffEksLinSubVareNr.AsString,
                    FormatCurr('###,##0.00', CtrIndBel));
            CtrSaldoA := CtrSaldoA + CtrIndBel;

          end;
        end;
      end;

//      // are there any dmvs products on the pakkeseddel? if not then tilbagdato is 14 days from now
//      // onlty check if there are lines on the ekspedition
//
//      if ffEksOvrAntLin.AsInteger <> 0 then
//      begin
//
//        if DMVSSvrConnection.DMVSIntegrationEnabled then
//        begin
//
//          // if there a
//          if (not DMVSProducts) then
//            mtMasterTilbDato.AsString := FormatDateTime('dd-mm-yyyy',
//              ffEksOvrTakserDato.AsDateTime + ffEksOvrReturdage.AsInteger);
//          C2LogAdd('*** New Latest return date is ' + mtMasterTilbDato.AsString);
//
//        end;
//
//      end;

      // Tlf/EDB/Udbr.gebyr
      C2LogAdd ('DanFormular Master add gebyrer recept');
      if TotTlfGebyr <> 0 then
      begin
        AddLin ('','Tlf.gebyr','Tlf.gebyr','','','','','',
                FormatCurr('###,##0.00', TotTlfGebyr),
                FormatCurr('###,##0.00', TotTlfGebyr));
      end;
      if TotEdbGebyr <> 0 then
      begin
        AddLin ('','Edb-gebyr','Edb-gebyr','','','','','',
                FormatCurr('###,##0.00', TotEdbGebyr),
                FormatCurr('###,##0.00', TotEdbGebyr));
      end;
      if TotUdbrGebyr <> 0 then
      begin
        udbrtxt := 'Udbr.gebyr';
        if (ffDebKarLevForm.AsInteger in [5,6]) and
          ( TotUdbrGebyr = ffRcpOplHKgebyr.AsCurrency) then
          udbrtxt := 'Udleveringssgebyr'
        else
          if TotUdbrGebyr = ffRcpOplPlejehjemsgebyr.AsCurrency then
            udbrtxt := 'Udbr. til plejehjem';

        AddLin ('',udbrtxt,'Udbr.gebyr','','','','','',
                FormatCurr('###,##0.00', TotUdbrGebyr),
                FormatCurr('###,##0.00', TotUdbrGebyr));
      end;
      // Danmark
      C2LogAdd ('DanFormular Master add Danmark recept');
      if (TotDKTilsk <> 0) or (TotDKEjTilsk <> 0) then
      begin
        if ffEksOvrDKmedlem.Value = 1 then
        begin
          if mtDanLin.RecordCount = 0 then
          begin
            AddTxt (mtDanLin, '', '');
            AddTxt (mtDanLin, 'Indberettet til Danmark', '');
          end;
          AddTxt (mtDanLin,'   Løbenr ' + IntToStr(ffEksOvrLbNr.Value), '');
          if TotDKTilsk <> 0 then
            AddTxt (mtDanLin,'   Tilskudsberettiget', FormatCurr('###,##0.00', TotDKTilsk));
          if TotDKEjTilsk <> 0 then
            AddTxt (mtDanLin,'   Ej tilskudsberettiget', FormatCurr('###,##0.00', TotDKEjTilsk));
        end;
      end;
      ffEksOvr.Next;
      if not ffEksOvr.Eof then
        AddLin ('','','','','','','','','','');
    end;
    // Ctr A ultimo
    if mtCtrLin.RecordCount > 0 then
    begin
      AddTxt (mtCtrLin, '   Ny CTR saldo', FormatCurr('###,##0.00', CtrSaldoA));
      if CtrUdDato <> '' then
        AddTxt (mtCtrLin,'   CTR udløber ' + CtrUdDato, '');
    end;
    // Opsaml Ctr og Danmark linier
    mtCtrLin.First;
    while not mtCtrLin.Eof do
    begin
      AddLin ('',mtCtrLinTxt.AsString,mtCtrLinTxt.AsString,'','',mtCtrLinBel.AsString,'','','','');
      mtCtrLin.Next;
    end;
    // Ctr B ultimo
    if mtCtrBLin.RecordCount > 0 then
    begin
      AddTxt (mtCtrBLin, '   Ny CTR B saldo', FormatCurr('###,##0.00', CtrSaldoB));
      if CtrUdDatoB <> '' then
        AddTxt (mtCtrBLin,'   CTR B udløber ' + CtrUdDatoB, '');
    end;
    // Opsaml Ctr og Danmark linier
    mtCtrBLin.First;
    while not mtCtrBLin.Eof do
    begin
      AddLin ('',mtCtrBLinTxt.AsString,mtCtrBLinTxt.AsString,'','',mtCtrBLinBel.AsString,'','','','');
      mtCtrBLin.Next;
    end;
    mtDanLin.First;
    while not mtDanLin.Eof do
    begin
      AddLin ('',mtDanLinTxt.AsString,mtDanLinTxt.AsString,'','',mtDanLinBel.AsString,'','','','');
      mtDanLin.Next;
    end;
    // Totaler
    C2LogAdd ('DanFormular Master add totaler');
    TotMoms  := TotBrutto * ffRcpOplMomsPct.AsCurrency /
                (100      + ffRcpOplMomsPct.AsCurrency);
    TotNetto := TotBrutto - TotMoms;

    Bet := Abs(TotPatAndel) * 100;
    Fak := 50;

    Bet := (Int ((Bet + Fak / 2.0) / Fak)) * Fak /100.0;



    C2LogAdd ('DanFormular Master add TotBrutto');
    mtMasterBrutto  .AsString := FormatCurr('###,##0.00', TotBrutto);
    C2LogAdd ('DanFormular Master add TotSygTilsk');
    mtMasterSygTilsk.AsString := FormatCurr('###,##0.00', TotSygTilsk);
    C2LogAdd ('DanFormular Master add TotKomTilsk');
    mtMasterKomTilsk.AsString := FormatCurr('###,##0.00', TotKomTilsk);
    C2LogAdd ('DanFormular Master add TotPatAndel ' + Curr2Str(TotPatAndel));
    mtMasterPatAndel.AsString := FormatCurr('###,##0.00', TotPatAndel);
    C2LogAdd ('DanFormular Master add TotMoms');
    mtMasterMoms    .AsString := FormatCurr('###,##0.00', TotMoms);
    C2LogAdd ('DanFormular Master add TotNetto');
    mtMasterNetto   .AsString := FormatCurr('###,##0.00', TotNetto);
    C2LogAdd ('Danformular master add PatAndelRnd ' + Curr2Str(Bet));
    mtMasterPatAndelRnd.AsString := FormatCurr('###,##0.00', Bet);
    C2LogAdd ('DanFormular Master Post');
    mtMaster.Post;
    // Forsendelses etiket til pakken
    if Caps(C2StrPrm(MainDm.C2UserName, 'ForsendelsesEtiket', '')) = 'JA' then
    begin

      fmUbi.PrintHyldeEtik(
        ffFirmaSupNavn .AsString,
        FormatDateTime('dd-mm-yy', mtMasterEkspDato.AsDateTime),
        mtMasterPakkeNr.AsString,
        mtMasterPaNavn .AsString,
        mtMasterPaAdr1 .AsString,
        mtMasterPaAdr2 .AsString,
        mtMasterPaAdr3 .AsString,
        mtMasterDeNr   .AsString,
        LevNr,
        FormatCurr('###,###,##0.00', TotPatAndel),'', 1, TRUE);
      fmubi.PrintTotalEtiket;
    end;
    // Result ved OK
    Result := True;
    C2LogAdd ('DanFormular out');
  end;
end;

end.
