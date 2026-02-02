{$I bsdefine.inc}

unit UdskrivFakturaLaser;

{ Developed by: Vitec Cito A/S

  Description: Ekspedition program

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  28-10-2020/cjs  Correct email checking when printing kopi faktura

  29-09-2020/cjs  Ongoing work to skip email of faktura if betalform is 50 (C2PAY)
  22-07-2020/cjs  Correction to fqlevliste sql.

  11-05-2020/cjs  Correction to ctr being printed when more than 1 patient is on the faktura
                  Added C2Pay message if betalform is 50
                  General tidy up of code


  13-06-2019/cjs  Correction to start saldo's

  01-05-2109/cjs  Correction to total in momsfri faktura. It did not include gebyr before

  10-04-2019/cjs  only print batch number details if ffEksOvrKundeType.AsInteger in [3,5,13,14]

  22-03-2019/BN   7.2.3.8 Change Moms calculations for TlfGebyr, EdbGebyr and UdbrGebyr

  20-03-2019/BN   7.2.3.7 Changed Name to Vitec Cito and added comments to edited units

                          WinPacer.ini [Receptur] parameters:
                            FaktPrivatKopierDebGruppe
                            FaktPrivatFormulaDebGruppe
                            FaktLeveranceKopierDebGruppe
                            FaktLeveranceFormulaDebGruppe
                          are not used yet except for FaktPrivatKopierDebGruppe.
                          The Formular names are spelled wrong and changed:
                            FaktPrivatFormulaDebGruppe to FaktPrivatFormularDebGruppe
                            FaktLeveranceFormulaDebGruppe to FaktLeveranceFormularDebGruppe
                            (missing R's in Formula(r)
                          The parameter is meant to make special Rave invoices for
                          special groups of customers (Debitorer).

                          Added use of PrisExMoms and BruttoExMoms from LaserFormularer
                          in building lines of mtDetail used in Rave reportgenerated
                          invoices. Fx. an invoice with lines excl. moms. New functionality
                          meant to support 3 main setups of invoices:
                            - Normal inkl. "moms"
                            - Special none "moms" pointing to "momsfri dagseddel"
                            - Special excl. "moms" most for company customers
                          When special invoice wnat to be created use Rave designer
                          and refresh data from mtDetail then new ExMoms fields can
                          be used. Save name for new invoice Form and refer in
                          WinPacer.ini for designed groups.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons,
  uC2Vareidentifikator.Classes,
  uEkspLinierSerienumre.Tables,uEkspeditioner.Tables,
  RPDefine, ComCtrls,DBClient,FileCtrl,printers,nxdb, generics.collections;
{$I EdiRcpInc}

type
  TfmFakturaLaser = class(TForm)
    paPrm: TPanel;
    buUdskriv: TBitBtn;
    buFortryd: TBitBtn;
    gbFaktura: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    eFraNr: TEdit;
    eTilNr: TEdit;
    GroupBox1: TGroupBox;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label3: TLabel;
    edtKundenr: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    chkFakt: TCheckBox;
    chkKont: TCheckBox;
    chkVaelgPDF: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure buUdskrivClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    function  DanFormular (FaktType : Word) : Boolean;
    function  DanFormularFaktPakke : Boolean;
    function  DanFormularFaktPakkeGamle : Boolean;
    procedure chkFaktClick(Sender: TObject);
    procedure chkKontClick(Sender: TObject);
    procedure UdskrivFaktKont;
  private
    { Private declarations }
    Kopier : integer;
    FaktRave : string;
    PrintPaper : boolean;
    SendByMail : boolean;
    AskQuestions : boolean;
    DMVSProducts : boolean;
    /// <summary>Set mtkasterkoel if product is a refrigerated product</summary>
    /// <param name="ALager">The current Lager.</param>
    /// <param name="AVarenr">The varenr for checking in LagerKartotek.</param>
    procedure CheckFridgeProduct(ALager : integer; AVarenr : string);
    procedure AddTxt (ATab : TClientDataset;
                      ATxt : String;
                      ABel : String);
    procedure AddLin(VareNr, KortTxt, LangTxt, Antal, Pris, AndetBel, SygTilsk,
      KomTilsk, PatAndel, Brutto, Lokation1, Lokation2: string;
      PrisExMoms: string = ''; BruttoExMoms: String = '');
  public
    { Public declarations }
    class procedure UdskrivFaktLaser (FraNr, TilNr : LongWord;prmAskQuestions :boolean = False); overload;
  end;


implementation

uses
  LaserFormularer,
  C2MainLog,

  C2Procs,
  ChkBoxes,
  DM,
  MidClientApi,
  UbiPrinter,Main, DB,C2PrinterSelection,
  uC2Vareidentifikator.Types,
  uYesNo, EmailFakturau,uC2Common.Procs;

{$R *.DFM}
class procedure TfmFakturaLaser.UdskrivFaktLaser (FraNr, TilNr : LongWord;
    prmAskQuestions :boolean = False);
begin
  with MainDm do begin
    C2LogAdd('about to print the fakturas in the range ' + IntToStr(FraNr) + ' ' + IntToStr(TilNr));
    c2logadd('prmaskQuestions is ' + Bool2Str(prmAskQuestions));
    with TfmFakturaLaser.Create (NIL) do
    begin
      try
        eFraNr.Text := '';
        if FraNr <> 0 then
          eFraNr.Text := IntToStr (FraNr);
        eTilNr.Text := '';
        if TilNr <> 0 then
          eTilNr.Text := IntToStr (TilNr);
        DateTimePicker1.Date := now - 30;
        DateTimePicker2.Date := now;
        AskQuestions := prmAskQuestions;
        ShowModal;
      finally
        Free;
      end;
    end;
  end;
end;


procedure TfmFakturaLaser.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key,[#13,#27]) then
    exit;
  if Key = #13 then begin
    SelectNext (ActiveControl, TRUE, TRUE);
    Key := #0;
  end;
  if Key = #27 then begin
    ModalResult := mrCancel;
    Key         := #0;
  end;
end;

procedure TfmFakturaLaser.FormActivate(Sender: TObject);
begin
  if eFraNr.Text <> '' then
  begin
    chkFakt.Checked := True;
    chkKont.Checked := False;
    PostMessage (buUdskriv.Handle, BM_Click, 0, 0);
  end
  else
  begin
    chkFakt.Checked := True;
    chkKont.Checked := False;
  end;
end;

procedure TfmFakturaLaser.AddLin(VareNr, KortTxt, LangTxt, Antal, Pris,
  AndetBel, SygTilsk, KomTilsk, PatAndel, Brutto, Lokation1, Lokation2: string;
  PrisExMoms: string; BruttoExMoms: String);
begin

  with dmFormularer do
  begin
    mtDetail.Append;
    mtDetailVareNr      .AsString := VareNr;
    mtDetailKortTxt     .AsString := KortTxt;
    mtDetailLangTxt     .AsString := LangTxt;
    mtDetailAntal       .AsString := Antal;
    mtDetailPris        .AsString := Pris;
    mtDetailAndetBel    .AsString := AndetBel;
    mtDetailSygTilsk    .AsString := SygTilsk;
    mtDetailKomTilsk    .AsString := KomTilsk;
    mtDetailPatAndel    .AsString := PatAndel;
    mtDetailBrutto      .AsString := Brutto;
    mtDetailLokation1   .AsString := Lokation1;
    mtDetailLokation2   .AsString := Lokation2;
    mtDetailPrisExMoms  .AsString := PrisExMoms;
    mtDetailBruttoExMoms.AsString := BruttoExMoms;
    mtDetail.Post;
  end;

end;

procedure TfmFakturaLaser.AddTxt(ATab: TClientDataset; ATxt, ABel: String);
begin
    with dmFormularer do
    begin
      ATab.Append;
      ATab.FieldByName ('Txt').AsString := ATxt;
      ATab.FieldByName ('Bel').AsString := ABel;
      ATab.Post;
    end;

end;

procedure TfmFakturaLaser.buUdskrivClick(Sender: TObject);
var
  FraNr,
  TilNr,
  FakturaNr : LongWord;
  FaktType  : Word;
  FaktForm,
  FaktPrn,
  FaktBakke,
  GemIdx    : String;
  PDFPrint : boolean;
  GemFakIdx : string;
  tst : boolean;
  tmpPDFFOlder :string;
  options : TSelectDirOpts;
  save_folder :string;
  EmailTekst : TStringList;

  function CheckDebitorsForAllC2Pay(AFra : integer; ATil : integer) : boolean;
  var
    LFakturanr : LongWord;
  begin
    with MainDm do
    begin
      // assume all debitors are C2Pay unless we find one that is not
      Result := True;
      ffEksFak.IndexName := 'FakturaNrOrden';
      for LFakturanr:= AFra to ATil do
      begin
        if not ffEksFak.FindKey ([LFakturaNr]) then
          continue;

        if ffDebKar.FindKey([ffEksFakKontoNr.AsString]) then
        begin
          if ffDebKarBetalForm.AsInteger <> 50 then
          begin
            Result := False;
            exit;
          end;
        end;


      end;


    end;
  end;

begin
  with MainDm, dmFormularer do
  begin
    Application.ProcessMessages;
    tmpPDFFOlder := PDFFolder;
    C2LogAdd ('buUdskriv in');

    // Disable knapper
    buUdskriv.Enabled  := False;
    buFortryd.Enabled  := False;
    GemIdx             := ffEksOvr.IndexName;
    gemFakIdx          := ffEksFak.IndexName;
    ffEksOvr.IndexName := 'FakturaNrOrden';
    ffEksFak.IndexName := 'FakturaNrOrden';
    PDFPrint := True;
    EmailTekst := TStringList.Create;
    if (StamForm.TakserDosisKortAuto) and (DosisKortAutoExp) then
      AskQuestions := False;
    PrintPaper := True;
    SendByMail := False;

    try
      if chkKont.Checked then
      begin
        UdskrivFaktKont;
        exit;
      end;

      TilNr := 0;
      FraNr := StrToInt (eFraNr.Text);
      if eTilNr.Text <> '' then
        TilNr := StrToInt (eTilNr.Text);
      if Tilnr < FraNr then
        TilNr := FraNr;

      // look at all debitors and see if we need to send an email copy
      // of the faktura. if all debitors are C2Pay then we do not send
      // by email
      if not         CheckDebitorsForAllC2Pay(FraNr,TilNr) then
      begin
        if AskQuestions then
          SendByMail := TfrmEmailFaktura.EmailFakturaQuery(EmailTekst);
      end;

      if AskQuestions then
        PrintPaper := frmYesNo.NewYesNoBox('Skal fakturaen udskrives?');
      // in auto dosis mode pretend the questions have been asked and yes was replied to both
      if (StamForm.TakserDosisKortAuto) and (DosisKortAutoExp) then
      begin
        AskQuestions := True;
        PrintPaper := True;
        SendByMail := True;
      end;

      if chkVaelgPDF.Checked then
      begin
        save_folder := GetCurrentDir;
        try
          if LastPDFFolder <> '' then
            tmpPDFFOlder := LastPDFFolder;
          if not SelectDirectory(tmpPDFFOlder,options,0) then
            exit;
          PrintPaper := frmYesNo.NewYesNoBox('Fakturaer gemmes som PDF-filer. Skal de også udskrives?');
          tmpPDFFOlder  := AddSlash(tmpPDFFOlder);
          LastPDFFolder := tmpPDFFOlder;
          c2logadd('tmppdffiolder is ' + tmpPDFFOlder);
        finally
          SetCurrentDir(save_folder);
        end;

      end;
      for FakturaNr := FraNr to TilNr do
      begin
        if not ffEksFak.FindKey ([FakturaNr]) then
          continue;
        DMVSProducts := False;
        ffEksOvr.SetRange ([FakturaNr], [FakturaNr]);
        try
          C2LogAdd ('buUdskriv FaktForm, FaktPrn, FaktBakke');
  //          if ((ffEksOvrKundeType.Value in [1]) and
  //              (ffEksOvrTurNr.Value   = 0))     or
  //              (ffEksOvrPakkeNr.Value > 0)      then begin
          if (ffEksOvrKundeType.Value in [pt_Enkeltperson]) or (ffEksOvrPakkeNr.Value > 0) then
          begin
            if (ffEksFakLeveringsTekst.AsString = 'Håndkøbsudsalg' ) or
               (ffEksFakLeveringsTekst.AsString = 'Udleveringssted') or
               (ffEksFakLeveringsTekst.AsString = 'Bud'            ) then
            begin
              FaktType  := FakturaPakkeListe;
              FaktRave  := FaktPakkeFil;
              FaktForm  := FaktPakkeFrm;
              FaktPrn   := FaktPakkePrn;
              FaktBakke := FaktPakkeBin;
              Kopier    := FaktPakkeAnt;
            end
            else
            begin
              if ffEksFakLeveringsTekst.AsString = 'Institution' then
              begin
                FaktType  := FakturaInstitution;
                FaktRave  := FaktInstFil;
                FaktForm  := FaktInstFrm;
                FaktPrn   := FaktInstPrn;
                FaktBakke := FaktInstBin;
                Kopier    := FaktInstAnt;
              end
              else
              begin
                FaktType  := FakturaPrivat;
                FaktRave  := FaktPrivFil;
                FaktForm  := FaktPrivFrm;
                FaktPrn   := FaktPrivPrn;
                FaktBakke := FaktPrivBin;
                Kopier    := FaktPrivAnt;
              end;
            end;
          end
          else
          begin
            FaktType  := FakturaLeverance;
            FaktRave  := FaktLevFil;
            FaktForm  := FaktLevFrm;
            FaktPrn   := FaktLevPrn;
            FaktBakke := FaktLevBin;
            Kopier    := FaktLevAnt;
          end;

          // if the momstype = 0 then always use leverance method

          if ffDebKar.FindKey([ffEksFakKontoNr.AsString]) then
          begin
            if ffDebKarMomsType.AsInteger = 0 then
            begin
              FaktType  := FakturaLeverance;
              FaktRave  := FaktLevFil;
              FaktForm  := FaktLevFrm;
              FaktPrn   := FaktLevPrn;
              FaktBakke := FaktLevBin;
              Kopier    := FaktLevAnt;
            end;
          end;


          C2LogAdd ('buUdskriv DanFormular');
          if DanFormular (FaktType) then
          begin
            try
              // Printermulighed
              C2LogAdd ('buUdskriv FaktPrn vælges');
              if FaktPrn <> '' then
              begin
                // Forvalg
                C2LogAdd ('buUdskriv SelectPrinter "' + FaktPrn + '"');
                tst := C2SelectPrinter (FaktPrn,rpSystem, 'Faktura ' + FakturaNr.ToString);
                c2logadd('c2selectprinter ' + Bool2Str(tst));
              end;
              // Bakkemulighed
              C2LogAdd ('buUdskriv FaktBakke vælges');
              if FaktBakke <> '' then
              begin
                // Forvalg
                C2LogAdd ('buUdskriv SelectBin "' + FaktBakke + '"');
                C2SelectBin(FaktBakke);
              end;
              // Eksekver rapport
              C2LogAdd ('buUdskriv Copies "' + IntToStr(Kopier) + '"');
              rpSystem.SystemPrinter.Copies      := Kopier;
              C2LogAdd ('buUdskriv ProjectFile "' + FaktRave + '"');
              rpProjekt.ProjectFile := FaktRave;
              if PDFPrint then
              begin
                C2LogAdd ('buUdskriv Open Project');
                rpProjekt.Open;
                rpProjekt.Engine := RpSystem;
                rpSystem.DoNativeOutput := False;
                rpSystem.RenderObject := rpPDF;
                rpSystem.DefaultDest := rdFile;
                if FileExists(tmpPDFFOlder + format('FAKT%8.8d',[FakturaNr]) + '.pdf') then
                  DeleteFile(tmpPDFFOlder + format('FAKT%8.8d',[FakturaNr]) + '.pdf');
                rpSystem.OutputFileName := tmpPDFFOlder + format('FAKT%8.8d',[FakturaNr]) + '.pdf';
                c2logadd('***  Pdf name is ' + rpSystem.OutputFileName);
                dmFormularer.rpSystem.SystemSetups := rpSystem.SystemSetups - [ssAllowSetup];
                c2logadd('PDF Before exceute report');
                rpProjekt.ExecuteReport(FaktForm);
                c2logadd('PDF after exceute report');
                rpProjekt.Close;
                if ffDebKarFaktura.AsBoolean then
                begin
                  // do not send email for C2Pay debitors
                  if ffDebKarBetalForm.AsInteger <> 50 then
                  begin

                    if SendByMail then
                    begin
                      // reprint as pdf
                      if not SendFaktureByEmail(ffDebKarMail.AsString,
                          tmpPDFFOlder + format('FAKT%8.8d',[FakturaNr]) + '.pdf',EmailTekst) then
                        ChkBoxOK('Fejl i send faktura via email');
                      C2LogAdd('1 after sending faktura by email');

                    end;
                    if not AskQuestions then
                    begin
                      if TfrmEmailFaktura.EmailFakturaQuery('Send faktura ' + inttostr(FakturaNr) +' via email til ' +
                            ffDebKarmail.AsString + '?',EmailTekst) then
                      begin
                        if not SendFaktureByEmail(ffDebKarMail.AsString,
                            tmpPDFFOlder + format('FAKT%8.8d',[FakturaNr]) + '.pdf',EmailTekst) then
                          ChkBoxOK('Fejl i send faktura via email');
                        C2LogAdd('1 after sending faktura by email');
                      end;
                      c2logadd('before asking about print');
                      PrintPaper := ChkBoxYesNo('Skal fakturaen udskrives?',False);
                      c2logadd('after asking about print ' + Bool2Str(PrintPaper));
                    end;
                  end;
                end;
                if PrintPaper then
                begin
                  c2logadd('printing a paper copy');
                  try
                    // Printermulighed
                    C2LogAdd ('buUdskriv FaktPrn vælges');
                    if FaktPrn <> '' then
                    begin
                      // Forvalg
                      C2LogAdd ('buUdskriv SelectPrinter "' + FaktPrn + '"');
                      tst := C2SelectPrinter (FaktPrn,rpSystem,'Faktura ' + FakturaNr.ToString);
                      c2logadd('C2select printer returned ' + Bool2Str(tst));
                    end;
                    // Bakkemulighed
                    C2LogAdd ('buUdskriv FaktBakke vælges');
                    if FaktBakke <> '' then
                    begin
                      // Forvalg
                      C2LogAdd ('buUdskriv SelectBin "' + FaktBakke + '"');
                      C2SelectBin(FaktBakke);
                    end;
                    // Eksekver rapport
                    C2LogAdd ('buUdskriv Copies "' + IntToStr(Kopier) + '"');
                    rpSystem.SystemPrinter.Copies      := Kopier;
                    C2LogAdd ('buUdskriv ProjectFile "' + FaktRave + '"');
                    rpProjekt.ProjectFile := FaktRave;
                    C2LogAdd ('buUdskriv Open Project');
                    rpProjekt.Open;
                    rpProjekt.Engine := rpSystem;
                    rpSystem.DoNativeOutput := True;
                    dmFormularer.RPSystem.SystemSetups := RPSystem.SystemSetups - [ssAllowSetup];
                    rpSystem.RenderObject := Nil;
                    rpSystem.DefaultDest := rdPrinter;
                    rpSystem.OutputFileName := '';
                    c2logadd('Before exceute report to printer');
                    rpProjekt.ExecuteReport (FaktForm);
                    c2logadd('After exceute report to printer');
                    rpProjekt.Close;
                  except
                    on e : Exception do
                    begin

                      ChkBoxOK(e.Message);
                    end;

                  end;
                end;



              end;

              if FaktType = FakturaLeverance then
              begin
                // Er følgeseddel sat op
                if FolgeSedPrn <> '' then
                begin
                  C2LogAdd ('buUdskriv SelectPrinter "' + FolgeSedPrn + '"');
                  tst := C2SelectPrinter (FolgeSedPrn,rpSystem,'Faktura ' + FakturaNr.ToString);
                  c2logadd('c2selectprinter ' + Bool2Str(tst));
                  if FolgeSedBin <> '' then begin
                    C2LogAdd ('buUdskriv SelectBin "' + FolgeSedBin + '"');
                    C2SelectBin(FolgeSedBin);
                  end;
                  C2LogAdd ('buUdskriv Copies "' + IntToStr(FolgeSedAnt) + '"');
                  rpSystem.SystemPrinter.Copies      := FolgeSedAnt;
                  C2LogAdd ('buUdskriv ProjectFile "' + FolgeSedFil + '"');
                  rpProjekt.ProjectFile := FolgeSedFil;
                  C2LogAdd ('buUdskriv Open Project');
                  rpProjekt.Open;
                  C2LogAdd ('buUdskriv ExecuteReport "' + FolgeSedFrm + '"');
                  rpProjekt.ExecuteReport (FolgeSedFrm);
                  C2LogAdd ('buUdskriv Close Project');
                  rpProjekt.Close;
                  // Restore default printer
                  if StdPrintPrn <> '' then
                  begin
                    tst := C2SelectPrinter(StdPrintPrn);
                    c2logadd('c2selectprinter ' + Bool2Str(tst));
                  end;
                  if StdPrintBin <> '' then
                  begin
                    tst := C2SelectBin(StdPrintBin);
                    c2logadd('c2selectbin ' + Bool2Str(tst));
                  end;
                end;
              end;
            except
              on E:Exception do
              begin
                C2LogAdd ('buUdskriv exception "' + E.Message + '"');
                rpProjekt.Close;
              end;
            end;
          end;
          C2LogAdd ('buUdskriv efter DanFormular');
        except
          on  e : exception do
            ChkBoxOk ('Exception i faktura laserprinter !' + e.Message);
        end;
      end;
    finally
      EmailTekst.Free;
      ffEksOvr      .CancelRange;
      ffEksOvr      .IndexName   := GemIdx;
      ffEksFak.IndexName := GemFakIdx;
      buUdskriv     .Enabled     := True;
      buFortryd     .Enabled     := True;
      ModalResult := mrOk;
    end;
    C2LogAdd ('buUdskriv out');
  end;
end;

function TfmFakturaLaser.DanFormular (FaktType : Word) : Boolean;
var
  LinAntal     : Integer;
  FakBrutto,
  FakSygTilsk,
  FakKomTilsk,
  FakExMoms,
  FakMoms,
  FakNetto,
  FakFaktRabat,
  FakKontoGebyr,
  CtrSaldo,
  CtrSaldoB,
  CtrIndBel,
  LinPris,
  LinPrisExMoms,
  LinSygTilsk,
  LinKomTilsk,
  LinPatAndel,
  LinBrutto,
  LinBruttoExMoms,
  TotLinAndel,
  TotTlfGebyr,
  TotEdbGebyr,
  TotUdbGebyr,
  GebyrExMoms,
  TotDkTilsk,
  TotDkEjTilsk : Currency;
  LinVet,
  WrkDeNvn,
  WrkPaNvn,
  WrkDeAdr1,
  WrkPaAdr1,
  WrkStr,
  CtrUdDato    : String;
  CtrUdDatoB   : String;
  LinNr        : Word;
  CtrFirst     : Boolean;
  LevNr : string;
  saveindex : string;
  LemvigVet : boolean;
  i : integer;
  tmpstr : string;
  Til : string;
  TopLbnr : integer;
  FoundCTRA,
  FoundCTRB : boolean;
  CTRALbnr : integer;
  CTRBLbnr : integer;

//  function ExcludeMoms(Bel: Currency): Currency;
//  begin
//    Result:= Bel;
//    if Bel <> 0 then
//      Result:= Round((Bel / 125.0) * 100 * 100) / 100;
//  end;


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

      ffEksOvr.First;
      // initialise the earliest date to that of the first ekspedition
      TilbageDato := ffEksOvrTakserDato.AsDateTime + ffEksOvrReturdage.AsInteger;
      while not ffEksOvr.Eof do
      begin
        // if current ekspedition ia less than current earlist date then update earlist date
        if TilbageDato > (ffEksOvrTakserDato.AsDateTime + ffEksOvrReturdage.AsInteger) then
          TilbageDato := ffEksOvrTakserDato.AsDateTime + ffEksOvrReturdage.AsInteger;

        ffEksOvr.Next;
      end;
      mtMasterTilbDato.AsString := FormatDateTime('dd-mm-yyyy',TilbageDato);
      C2LogAdd('*** Latest return date is ' + mtMasterTilbDato.AsString);

    end;

  end;

  procedure AddBatchnrInfo(aLbnr,aLinienr : integer);
  begin
    with MainDm.nxdb.OpenQuery('select distinct ' +
      fnEkspLinierSerienumreBatchNr + fnEkspLinierSerienumreUdDato_K + ' from '
      + tnEkspLinierSerienumre + ' where ' + fnEkspLinierSerienumreLbNr_P +
      ' and ' + fnEkspLinierSerienumreLinieNr_P + ' order by ' +
      fnEkspLinierSerienumreUdDato, [aLbnr, aLinienr]) do
    begin
      try
        if eof then
          exit;

        First;
        while not Eof do
        begin
                AddLin( '',
                        '',
                        'Batch : ' + fieldbyname(fnEkspLinierSerienumreBatchNr).AsString + ' Udløb : ' +
                        fieldbyname(fnEkspLinierSerienumreUdDato).AsString,
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '');

          Next;
        end;


      finally
        Free;
      end;

    end;


  end;

begin
  with MidClient, MainDm, dmFormularer do
  begin
    C2LogAdd ('DanFormular in');


    if FaktType = fakturaPakkeListe then
    begin
      if StamForm.Pakkeliste_sorteret_efter_pakkenr then
        Result := DanFormularFaktPakkeGamle
      else
        Result := DanFormularFaktPakke;

      exit;
    end;

    // Result ved fejl
    Result := False;
    // Find debitor
    if not ffDebKar.FindKey([ffEksFakKontoNr.AsString]) then
    begin
      // Debitor fundet
      ChkBoxOk ('Kan ikke finde debitorkonto under dan formular!');
      Exit;
    end;

    if ffDebKarDebGruppe.AsInteger <> 0 then
    begin

      // Special RAVE invoice for DebGruppe privat
      if FaktType = FakturaPrivat then
      begin
          tmpstr := 'FaktPrivatKopierDebGruppe' + IntToStr(ffDebKarDebGruppe.AsInteger);
          Kopier := C2IntPrm('Receptur',tmpstr,Kopier);
          tmpstr := 'FaktPrivatFormularDebGruppe' + IntToStr(ffDebKarDebGruppe.AsInteger);
          FaktRave := C2StrPrm('Receptur',tmpstr,FaktRave);
      end;
      // Special RAVE invoice for DebGruppe leverance
      if FaktType = FakturaLeverance then
      begin
          tmpstr := 'FaktLeveranceKopierDebGruppe' + IntToStr(ffDebKarDebGruppe.AsInteger);
          Kopier := C2IntPrm('Receptur',tmpstr,Kopier);
          tmpstr := 'FaktLeveranceFormularDebGruppe' + IntToStr(ffDebKarDebGruppe.AsInteger);
          FaktRave := C2StrPrm('Receptur',tmpstr,FaktRave);
      end;

    end;

    ffEksOvr.First;
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
    C2LogAdd ('DanFormular Master pakkenr felt');
    mtMasterPakkeNr  .Value    := 0;
    C2LogAdd ('DanFormular Master fakturanr felt ' + IntToStr (ffEksFakFakturaNr.Value));
    mtMasterFaktNr   .Value    := ffEksFakFakturaNr  .Value;
    C2LogAdd ('DanFormular Master EFaktOrdrenrfelt ' + ffEksFakEFaktOrdreNr.AsString);
    mtMasterEFaktOrdreNr   .AsString    := ffEksFakEFaktOrdreNr  .AsString;
    C2LogAdd ('DanFormular Master fakturatype felt');
    mtMasterFaktType .AsString := ffEksFakFakturaType.AsString;
    C2LogAdd ('DanFormular Master rabat/pakker felter');
    if ffEksFakFakturaRabat.AsCurrency <> 0 then
      mtMasterFaktRabat.AsString := FormatCurr('###,##0.00', ffEksFakFakturaRabat.AsCurrency);
    if ffEksFakAntalPakker.Value <> 0 then
      mtMasterPakkeAnt .AsString := IntToStr (ffEksFakAntalPakker.Value);
    C2LogAdd ('DanFormular Master DK/bruger felter');
    if ffEksOvrDKMedlem.Value = 1 then
      mtMasterDKmedlem .AsString := ffEksOvrDKMedlem.AsString;
    if ffEksOvrBrugerTakser.Value > 0 then
      mtMasterBrTakser .AsString := ffEksOvrBrugerTakser.AsString;
    C2LogAdd ('DanFormular Master dato felter');
    mtMasterEkspDato .AsString := FormatDateTime('dd-mm-yyyy',ffEksOvrTakserDato   .AsDateTime);
    mtMasterAfslDato .AsString := FormatDateTime('dd-mm-yyyy',ffEksOvrAfsluttetDato.AsDateTime);
//    mtMasterTilbDato .AsString := FormatDateTime('dd-mm-yyyy',
//      ffEksOvrTakserDato.AsDateTime + ffEksOvrReturdage.AsInteger);
    SetEarliestTilbageDato;
    mtMasterForfDato .AsString := FormatDateTime('dd-mm-yyyy',ffEksFakForfaldsDato .AsDateTime);
    mtMasterBetalBet .AsString := ffEksFakKreditTekst.AsString;
    // Navn og adresse på debitor
    C2LogAdd ('DanFormular Master debitor felter');
    mtMasterDeNr     .AsString := ffEksFakKontoNr.AsString;
    mtMasterDeNavn   .AsString := BytNavn (ffEksFakKontoNavn.AsString);
    mtMasterDeAdr1   .AsString := ffEksFakKontoAdr1.AsString;
    mtMasterDeAdr2   .AsString := ffEksFakKontoAdr2.AsString;
    mtMasterDeAdr3   .AsString := ffEksFakKontoAdr3.AsString;
    mtMasterLevTil   .AsString := '';
    mtMasterXPaNr    .AsString := Trim (ffEksOvrKundeNr.AsString);
    mtMasterXPaNavn  .AsString := Trim (BytNavn (ffEksOvrNavn.AsString));
    // Levnr og levnavn
    mtMasterLevNavn.AsString := '';
    if Trim(ffEksOvrLevNavn.AsString) <> '' then
    begin
      mtMasterLevNavn.AsString := Trim(ffEksOvrLevNavn.AsString);
      saveindex := ffDebKar.IndexName;
      ffDebKar.IndexName := 'NrOrden';
      try
        if ffDebKar.FindKey([trim(ffEksOvrLevNavn.AsString)]) then
          mtMasterLevNavn.AsString := mtMasterLevNavn.AsString +
                ' ' + ffDebKarNavn.AsString;
      finally
        ffDebKar.IndexName := saveindex;
        // Reset debitor back to main debitor
        if not ffDebKar.FindKey([ffEksFakKontoNr.AsString]) then
          ChkBoxOk ('Kan ikke finde debitorkonto under dan formular!');           // Debitor fundet
      end;
    end;

    mtMasterCHRNR.AsString := '';
    if ffEksOvrKundeType.AsInteger = pt_Landmand then
    begin
      ffPatKar.IndexName := 'NrOrden';

      if ffPatKar.FindKey([ffEksOvrKundeNr.AsString]) then
        mtMasterCHRNR.AsString := copy(ffPatKarLmsModtager.AsString,5,6);

    end;


    // Navn og adresse på patienten

    C2LogAdd ('DanFormular Master patient felter');
    if (ffEksFakLeveringsTekst.AsString = 'Privat')      or
       (ffEksFakLeveringsTekst.AsString = 'Institution') then
    begin
      WrkDeNvn  := Caps (Trim (         mtMasterDeNavn.AsString));
      WrkPaNvn  := Caps (Trim (BytNavn (ffEksOvrNavn  .AsString)));
      WrkDeAdr1 := Caps (Trim (         mtMasterDeAdr1.AsString));
      WrkPaAdr1 := Caps (Trim (         ffEksOvrAdr1  .AsString));
      if (WrkDeNvn <> WrkPaNvn) or (WrkDeAdr1 <> WrkPaAdr1) then
      begin
        mtMasterLevTil.AsString := 'Leveringsadresse :';
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
        mtMasterKoel.AsString := '';
      end;
      mtMasterPaTlfNr.AsString := '';
      if ffDebKarTlfNr.AsString <> '' then
        mtMasterPaTlfNr.AsString :=  ffDebKarTlfNr.AsString;
      mtMasterTurnr.AsInteger := ffEksOvrTurNr.AsInteger;
    end;
    // Beregn alle totaler
    C2LogAdd ('DanFormular nulstil totaler');
    FakNetto     := 0;
    CtrSaldo     := 0;
    CtrSaldoB    := 0;
    CtrUdDato    := '';
    CtrUdDatoB   := '';
    CtrFirst     := True;
    C2LogAdd ('DanFormular recept gennemløb');

    // get ctrsaldo values from first lbnr which is lowest lbnr

//    ffEksOvr.First;
//    TopLbnr := 0;
//    while not ffEksOvr.Eof  do
//    begin
//      if TopLbnr = 0 then
//      begin
//        TopLbnr := ffEksOvrLbNr.AsInteger;
//        CtrSaldo := ffEksOvrCtrSaldo.AsCurrency;//ffEksoTilSaldo.AsCurrency - CtrIndBel;
//        CtrSaldoB := ffEksOvrCtrSaldo.AsCurrency;//ffEksoTilSaldo.AsCurrency - CtrIndBel;
//      end;
//      if ffEksOvrLbNr.AsInteger < TopLbnr then
//      begin
//        TopLbnr := ffEksOvrLbNr.AsInteger;
//        CtrSaldo := ffEksOvrCtrSaldo.AsCurrency;//ffEksoTilSaldo.AsCurrency - CtrIndBel;
//        CtrSaldoB := ffEksOvrCtrSaldo.AsCurrency;//ffEksoTilSaldo.AsCurrency - CtrIndBel;
//      end;
//      ffEksOvr.Next;
//    end;

    // look for ctr a first
    FoundCTRA := False;
    CTRALbnr := 0;
    ffEksOvr.First;
    TopLbnr := 0;
    while (not ffEksOvr.Eof) do
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
            CtrSaldo := ffEksOvrCtrSaldo.AsCurrency;
            CTRALbnr := ffEksOvrLbNr.AsInteger;
            FoundCTRA := True;
            break;
          end
          else
          begin
            if ffEksOvrOrdreType.AsInteger = 2 then
              CtrSaldo := ffEksTilSaldo.AsCurrency + ffEksTilBGPBel.AsCurrency
            else
              CtrSaldo := ffEksTilSaldo.AsCurrency - ffEksTilBGPBel.AsCurrency;
            FoundCTRA := True;
            CTRALbnr := ffEksOvrLbNr.AsInteger;
            break;
          end;

//          // if we get here then we hve the start saldo
//          if ffEksTilBGPBel.AsCurrency <> 0 then
//            break;
//

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

          if IsCannabisProduct(MainDm.nxdb, ffEksLinLager.AsInteger,
            ffEksLinSubVareNr.AsString, ffEksLinTekst.AsString,ffEksLinDrugId.AsString) then
            continue;

          if ffEksLinSubVareNr.AsString ='100015' then
          begin
            if (CTRALbnr = 0) or (ffEksOvrLbNr.AsInteger < CTRALbnr) then
            begin
              CtrSaldo := ffEksOvrCtrSaldo.AsCurrency;
              CTRALbnr := ffEksOvrLbNr.AsInteger;
              break;
            end;
          end
          else
          begin
            if (CTRALbnr = 0) or (ffEksOvrLbNr.AsInteger < CTRALbnr) then
            begin
              if ffEksOvrOrdreType.AsInteger = 2 then
                CtrSaldo := ffEksTilSaldo.AsCurrency + ffEksTilBGPBel.AsCurrency
              else
                CtrSaldo := ffEksTilSaldo.AsCurrency - ffEksTilBGPBel.AsCurrency;
              CTRALbnr := ffEksOvrLbNr.AsInteger;
              break;
            end;
          end;

        end;
      end;
      ffEksOvr.Next;
    end;

    // now for ctr B

    ffEksOvr.First;
    TopLbnr := 0;
    CTRBLbnr :=0;
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

//          // if we get here then we hve the start saldo
//          if ffEksTilBGPBel.AsCurrency <> 0 then
//            break;


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
//            break;
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

//          // if we get here then we hve the start saldo
//          if ffEksTilBGPBel.AsCurrency <> 0 then
//            break;

        end;
      end;
      ffEksOvr.Next;
    end;
    ffEksOvr.First;

    // Udfyld felter fra gennemløb
    while not ffEksOvr.Eof do
    begin
      // Tillæg gebyrer afhængig om det er kreditnota
      TotLinAndel  := 0;
      TotTlfGebyr  := ffEksOvrTlfGebyr .AsCurrency;
      TotEdbGebyr  := ffEksOvrEdbGebyr .AsCurrency;
      TotUdbGebyr  := ffEksOvrUdbrGebyr.AsCurrency;
      TotDkTilsk   := ffEksOvrDKTilsk  .AsCurrency;
      TotDkEjTilsk := ffEksOvrDKEjTilsk.AsCurrency;
      if ffEksOvrOrdreType.Value = 2 then
      begin
        TotTlfGebyr  := -TotTlfGebyr;
        TotEdbGebyr  := -TotEdbGebyr;
        TotUdbGebyr  := -TotUdbGebyr;
        TotDkTilsk   := -TotDKTilsk;
        TotDkEjTilsk := -TotDKEjTilsk;
      end;
      // Kun for institution
      if FaktType = FakturaInstitution then
      begin
        // Indsæt linie
        AddLin ('',
                'Cprnr ' + ffEksOvrKundeNr.AsString,
                'Cprnr ' + ffEksOvrKundeNr.AsString +
                '/' + BytNavn (ffEksOvrNavn.AsString),
                '','','','','','','', '', '', '', '');
      end;

      if (FaktType = FakturaPrivat) or (FaktType = FakturaLeverance) then
      begin
        // Indsæt linie
        AddLin ('',
                'Lbnr ' + ffEksOvrLbNr.AsString,
                'Lbnr ' + ffEksOvrLbNr.AsString,
                '','','','','','','', '', '', '', '');
      end;
      // Summer totaler fra gebyrer
      for LinNr := 1 to ffEksOvrAntLin.Value do
      begin
        if ffEksLin.FindKey ([ffEksOvrLbNr.Value, LinNr]) then
        begin
          if ffEksTil.FindKey ([ffEksOvrLbNr.Value, LinNr]) then
          begin
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
            TotLinAndel := TotLinAndel + LinPatAndel;

            FakNetto    := FakNetto + LinBrutto;

            // Betinget af fakturatype
            if FaktType <> FakturaPakkeListe then
            begin
(* Not needed after changes in ver. 7.2.3.7
              // Check momsfri debitor
              if (ffDebKarMomsType.AsInteger = 0) or (StamForm.FakturaLinierUdenMoms) then
              begin
                // Fratræk moms på totaler
//                LinPris    := ExcludeMoms(LinPris);
                LinPatAndel:= LinAntal * LinPris;
                LinSygTilsk:= 0;
                LinKomTilsk:= 0;
                LinBrutto  := LinPatAndel;
                FakNetto   := FakNetto + LinBrutto;
              end;
   Not needed after changes in ver. 7.2.3.7 *)

              (* hobro vilovet fix *)
              (* hobro vilovet fix *)
              (* hobro vilovet fix *)
              (* hobro vilovet fix *)
              (* hobro vilovet fix *)
              LinVet:= '';
              if Caps(C2StrPrm('Hobro', 'Vilovet', 'Nej')) = 'JA' then
              begin
                if (ffDebKarDebGruppe.AsInteger = 10) or
                   (ffDebKarDebGruppe.AsInteger = 11) or
                   (ffDebKarDebGruppe.AsInteger = 12) then
                begin
                  // Hobro Vilovet varelinie
                  if ffLagKar.FindKey([ffEksLinLager    .AsInteger,
                                       ffEksLinSubVareNr.AsString]) then
                  begin
                    // Formater normal nettopris
                    if ffLagKarSalgsPris2.AsCurrency <> 0 then
                      LinVet:= FormatCurr('###,##0.00', ffLagKarSalgsPris2.AsCurrency);
                  end;
                end;
              end;
              (* hobro vilovet fix *)
              (* hobro vilovet fix *)
              (* hobro vilovet fix *)
              (* hobro vilovet fix *)
              (* hobro vilovet fix *)

            // new vet code

              with StamForm do
              begin
                if VetNettoPris then
                begin
                  LemvigVet := False;
                  if ffEksOvrKundeType.AsInteger in [pt_Dyrlaege,pt_Landmand] then
                  begin
                    for i := 1 to 10 do
                    begin
                      if VetDebGruppe[i] = ffDebKarDebGruppe.AsInteger then
                        LemvigVet := true;
                      if VetDebGruppe[i] = -1 then
                        break;
                    end;
                  end;
                  if LemvigVet then
                  begin
                    C2LogAdd('New Vet beregning start');
                    if ffLagKar.FindKey([ffEksLinLager    .AsInteger,
                                         ffEksLinSubVareNr.AsString]) then
                    begin
                      // Formater normal nettopris

                      LinVet:= FormatCurr('###,##0.00', ffLagKarSalgsPris.AsCurrency);
                      if ffLagKarEgenPris.AsCurrency <> 0 then
                        LinVet:= FormatCurr('###,##0.00', ffLagKarEgenPris.AsCurrency)
                      else
                        if ffLagKarSalgsPris2.AsCurrency <> 0 then
                          LinVet:= FormatCurr('###,##0.00', ffLagKarSalgsPris2.AsCurrency);
                    end;
                    C2LogAdd('Hobro Vilovet beregning slut');

                  end;
                end;

              end;

              // Indsæt linie
              CheckFridgeProduct(ffEksOvrLager.AsInteger, ffEksLinSubVareNr.AsString);

              if DMVSSvrConnection.DMVSIntegrationEnabled  and ( not DMVSProducts) then
                DMVSProducts := CheckDMVSProduct(ffEksLinLager.AsInteger,ffEksLinSubVareNr.AsString);
              C2LogAdd('*** DMVS products is now ' + DMVSProducts.tostring);
              Til := '';
              if FaktType = FakturaPrivat then
              begin
                if (ffEksLinUdlevNr.AsInteger <= 1) and (ffEksLinUdlevNr.AsInteger >= ffEksLinUdlevMax.AsInteger) then
                  Til := ''
                else
                  Til := 'Udl ' + IntToStr (ffEksLinUdlevNr.Value) + '/' + IntToStr (ffEksLinUdlevMax.Value);
              end;

              // Set LinPrisExMoms and LinBruttoExMoms to default values
              LinPrisExMoms  := LinPris;
              LinBruttoExMoms:= LinBrutto;
              if ffDebKarMomsType.AsInteger <> 0 then
              begin
                // Debitor have values inkl. moms
                // Calculate LinPrisExMoms and LinBruttoExMoms
                if LinPris <> 0 then
                  LinPrisExMoms  := LinPrisExMoms   - BruttoMoms(LinPris  , MomsPercent);
                if LinBrutto <> 0 then
                  LinBruttoExMoms:= LinBruttoExMoms - BruttoMoms(LinBrutto, MomsPercent);
              end;

              if til <> ''  then

                AddLin (ffEksLinSubVareNr.AsString,
                        Til + ' ' + ffEksLinTekst    .AsString,
                        Til + ' ' + ffEksLinTekst    .AsString + ' ' +
                        ffEksLinPakning  .AsString + ' ' +
                        ffEksLinForm     .AsString + ' ' +
                        ffEksLinStyrke   .AsString,
                        IntToStr    (LinAntal),
                        FormatCurr('###,##0.00', LinPris),
                        LinVet,
                        FormatCurr('###,##0.00', LinSygTilsk),
                        FormatCurr('###,##0.00', LinKomTilsk),
                        FormatCurr('###,##0.00', LinPatAndel),
                        FormatCurr('###,##0.00', LinBrutto),
                        ffEksLinLokation1.AsString,
                        ffEksLinLokation2.AsString,
                        FormatCurr('###,##0.00', LinPrisExMoms),
                        FormatCurr('###,##0.00', LinBruttoExMoms))
              else
                AddLin (ffEksLinSubVareNr.AsString,
                        ffEksLinTekst    .AsString,
                        ffEksLinTekst    .AsString + ' ' +
                        ffEksLinPakning  .AsString + ' ' +
                        ffEksLinForm     .AsString + ' ' +
                        ffEksLinStyrke   .AsString,
                        IntToStr    (LinAntal),
                        FormatCurr('###,##0.00', LinPris),
                        LinVet,
                        FormatCurr('###,##0.00', LinSygTilsk),
                        FormatCurr('###,##0.00', LinKomTilsk),
                        FormatCurr('###,##0.00', LinPatAndel),
                        FormatCurr('###,##0.00', LinBrutto),
                        ffEksLinLokation1.AsString,
                        ffEksLinLokation2.AsString,
                        FormatCurr('###,##0.00', LinPrisExMoms),
                        FormatCurr('###,##0.00', LinBruttoExMoms))
            end;

            if FaktType = FakturaLeverance then
            begin
              if ffEksOvrKundeType.AsInteger in [pt_Dyrlaege,pt_Forsvaret,pt_Hobbydyr,pt_Landmand] then
                AddBatchnrInfo(ffEksOvrLbNr.AsInteger,ffEksLinLinieNr.AsInteger);

  //            if ffEksOvrKundeType.AsInteger in [3,5,13,14] then begin
//                if ffEksLinBatchNr.AsString <> '' then
//                begin
//                  AddLin( '',
//                          '',
//                          'Batch : ' + ffEksLinBatchNr.AsString + ' Udløb : ' +
//                          FormatDateTime('dd-mm-yyyy',ffEksLinUdDato.AsDateTime),
//                          '',
//                          '',
//                          '',
//                          '',
//                          '',
//                          '',
//                          '',
//                          '',
//                          '',
//                          '',
//                          '');
//                end;

  //            end;

            end;

            // Betinget af fakturatype
            if FaktType = FakturaPrivat then
            begin
              // Ctr oplysninger
              CtrIndBel := ffEksTilBGPBel.AsCurrency;
              if ffEksOvrOrdreType.Value = 2 then
                CtrIndBel := -CtrIndBel;
              // Første Ctr primo saldo
              if CtrFirst then
              begin
                if ffPatUpd.FindKey ([ffEksOvrKundeNr.AsString]) then
                begin
                  if not ffPatUpdCtrUdDato.IsNull then
                    CtrUdDato := FormatDateTime ('dd-mm-yyyy', ffPatUpdCtrUdDato.AsDateTime);
                  if not ffPatUpdCtrUdDatoB.IsNull then
                    CtrUdDatoB := FormatDateTime ('dd-mm-yyyy', ffPatUpdCtrUdDatoB.AsDateTime);
                end;
  //              CtrSaldo := ffEksOvrCtrSaldo.AsCurrency;//ffEksoTilSaldo.AsCurrency - CtrIndBel;
                CtrFirst := False;
              end;
              // Tilføj evt. Ctr linie
              if (CtrIndBel <> 0) or (ffEksLinSubVareNr.AsString ='100015')  then
              begin
                if isCannabisProduct(MainDm.nxdb, ffEksLinLager.AsInteger,
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
                    AddTxt (mtCtrLin, '   Anvendt saldo', FormatCurr('###,##0.00', CtrSaldo));
                  end;
                  AddTxt (mtCtrLin, '   Indberettet for ' + ffEksLinSubVareNr.AsString,
                          FormatCurr('###,##0.00', CtrIndBel));
                  CtrSaldo := CtrSaldo + CtrIndBel;

                end;
              end;
            end;
          end;
        end;
      end;
      // Betinget af fakturatype
      if FaktType = FakturaPakkeListe then
      begin
        // Indsæt linie
        AddLin ('',
                'Pakkenr ' + IntToStr (ffEksOvrPakkeNr.Value),
                'Pakkenr ' + IntToStr (ffEksOvrPakkeNr.Value) +
                '/' + BytNavn (ffEksOvrNavn.AsString) +
                '/' + trim(ffEksOvrAdr1.AsString) +
                trim(' ' + ffEksOvrAdr2.AsString) +
                ' ' + ffEksOvrPostNr.AsString,
                '','','','','',FormatCurr('###,##0.00', TotLinAndel),'', '', '', '', '');
      end;
      // Kun for institution
      if FaktType = FakturaInstitution then
      begin
        // Indsæt linie
        AddLin ('',
                'Total for ekspedition ' + IntToStr (ffEksOvrLbNr.AsInteger),
                'Total for ekspedition ' + IntToStr (ffEksOvrLbNr.AsInteger),
                '','','','','',FormatCurr('###,##0.00', TotLinAndel),'', '', '', '', '');
      end;
      // Tlf/EDB/Udbr.gebyr
      C2LogAdd ('DanFormular Master add gebyrer recept');
(* Not needed after changes in ver. 7.2.3.7
      // Check momsfri debitor
      if ffDebKarMomsType.AsInteger = 0 then
      begin
        // Fratræk moms på totaler
        TotTlfGebyr:= BruttoMoms(TotTlfGebyr,MomsPercent);
        TotEdbGebyr:= BruttoMoms(TotEdbGebyr,MomsPercent);
        TotUdbGebyr:= BruttoMoms(TotUdbGebyr,MomsPercent);
      end;
   Not needed after changes in ver. 7.2.3.7 *)
      if TotTlfGebyr <> 0 then
      begin
        GebyrExMoms:= TotTlfGebyr;
        if ffDebKarMomsType.AsInteger <> 0 then
          GebyrExMoms:= GebyrExMoms - BruttoMoms(GebyrExMoms, MomsPercent);
        AddLin ('','Tlf.gebyr','Tlf.gebyr','','','','','',
                FormatCurr('###,##0.00', TotTlfGebyr),
                FormatCurr('###,##0.00', TotTlfGebyr),
                '', '',
                FormatCurr('###,##0.00', GebyrExmoms),
                FormatCurr('###,##0.00', GebyrExMoms));
      end;
      if TotEdbGebyr <> 0 then
      begin
        GebyrExMoms:= TotEdbGebyr;
        if ffDebKarMomsType.AsInteger <> 0 then
          GebyrExMoms:= GebyrExMoms - BruttoMoms(GebyrExMoms, MomsPercent);
        AddLin ('','Edb-gebyr','Edb-gebyr','','','','','',
                FormatCurr('###,##0.00', TotEdbGebyr),
                FormatCurr('###,##0.00', TotEdbGebyr),
                '', '',
                FormatCurr('###,##0.00', GebyrExmoms),
                FormatCurr('###,##0.00', GebyrExMoms));
      end;
      if TotUdbGebyr <> 0 then
      begin
        GebyrExMoms:= TotUdbGebyr;
        if ffDebKarMomsType.AsInteger <> 0 then
          GebyrExMoms:= GebyrExMoms - BruttoMoms(GebyrExMoms, MomsPercent);
        AddLin ('','Udbr.gebyr','Udbr.gebyr','','','','','',
                FormatCurr('###,##0.00', TotUdbGebyr),
                FormatCurr('###,##0.00', TotUdbGebyr),
                '', '',
                FormatCurr('###,##0.00', GebyrExmoms),
                FormatCurr('###,##0.00', GebyrExMoms));
      end;
      // Betinget af fakturatype
      if FaktType = FakturaPrivat then
      begin
//        // are there any dmvs products on the faktprivat? add ReturDage to all ekspeditioner now
//        if DMVSSvrConnection.DMVSIntegrationEnabled then
//        begin
//
//          if not DMVSProducts then
//            mtMasterTilbDato.AsString := FormatDateTime('dd-mm-yyyy',
//              ffEksOvrTakserDato.AsDateTime + ffEksOvrReturdage.AsInteger);
//
//        end;
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
      end;
      ffEksOvr.Next;
      if not ffEksOvr.Eof then
        AddLin ('','','','','','','','','','', '', '', '', '');
    end;
    // Check momsfri debitor
    FakKontoGebyr:= ffEksFakKontoGebyr.AsCurrency;
    if ffDebKarMomsType.AsInteger = 0 then
    begin
      // Fratræk moms på totaler
      FakNetto      := ffEksFakNetto.AsCurrency;
      FakBrutto     := FakNetto;
      FakSygTilsk   := 0;
      FakKomTilsk   := 0;
      FakExMoms     := FakNetto;
      FakMoms       := 0;
      FakFaktRabat  := 0;
      (* Not needed after changes in ver. 7.2.3.7
      FakKontoGebyr:= FakKontoGebyr - BruttoMoms(FakKontoGebyr,MomsPercent);
   Not needed after changes in ver. 7.2.3.7 *)
    end
    else
    begin
      FakBrutto    := ffEksFakBrutto      .AsCurrency;
      FakSygTilsk  := ffEksFakTilskAmt    .AsCurrency;
      FakKomTilsk  := ffEksFakTilskKom    .AsCurrency;
      FakExMoms    := ffEksFakExMoms      .AsCurrency;
      FakMoms      := ffEksFakMoms        .AsCurrency;
      FakNetto     := ffEksFakNetto       .AsCurrency;
      FakFaktRabat := ffEksFakFakturaRabat.AsCurrency;
    end;
    // Kontogebyr
    C2LogAdd ('DanFormular kontogebyr');
    if FakKontoGebyr <> 0 then
    begin
      GebyrExMoms:= FakKontoGebyr;
      if ffDebKarMomsType.AsInteger <> 0 then
        GebyrExMoms:= GebyrExMoms - BruttoMoms(GebyrExMoms, MomsPercent);
      AddLin ('','Kontogebyr','Kontogebyr','','','','','',
              FormatCurr('###,##0.00', FakKontoGebyr),
              FormatCurr('###,##0.00', FakKontoGebyr),
              '', '',
              FormatCurr('###,##0.00', GebyrExmoms),
              FormatCurr('###,##0.00', GebyrExMoms));
    end;
    // Betinget af fakturatype
    if FaktType = FakturaPrivat then
    begin
      // Forsendelses etiket til pakken
      if PrintPaper  then
      begin
        if Caps(C2StrPrm(MainDm.C2UserName, 'ForsendelsesEtiket', '')) = 'JA' then
        begin
          LevNr := Spaces(10);
          if Trim(ffEksOvrLevNavn.AsString) <> '' then
            LevNr:= AddSpaces(Trim(ffEksOvrLevNavn.AsString), 10);
          fmUbi.PrintHyldeEtik(
            ffFirmaSupNavn.AsString,
            FormatDateTime('dd-mm-yy', ffEksFakAfsluttetDato.AsDateTime),
            ffEksFakFakturaNr.AsString,
            ffEksFakKontoNavn.AsString,
            ffEksFakKontoAdr1.AsString,
            ffEksFakKontoAdr2.AsString,
            ffEksFakKontoAdr3.AsString,
            ffEksFakKontoNr  .AsString,
            LevNr,
            FormatCurr('###,###,##0.00', ffEksFakNetto.AsCurrency), ffEksOvrKundeNr.AsString, 1, TRUE);
          fmubi.PrintTotalEtiket;
        end;
      end;
      // Ctr ultimo
      C2LogAdd ('DanFormular Master add Ctr ultimo');
      if mtCtrLin.RecordCount > 0 then
      begin
        AddTxt (mtCtrLin, '   Ny CTR saldo', FormatCurr('###,##0.00', CtrSaldo));
        if CtrUdDato <> '' then
          AddTxt (mtCtrLin,'   CTR udløber ' + CtrUdDato, '');
      end;
      // Opsaml Ctr og Danmark linier
      C2LogAdd ('DanFormular Master add Ctr linier');
      mtCtrLin.First;
      while not mtCtrLin.Eof do
      begin
        AddLin ('',mtCtrLinTxt.AsString,mtCtrLinTxt.AsString,
                '','',mtCtrLinBel.AsString,'','','','', '', '', '', '');
        mtCtrLin.Next;
      end;
      // Ctr B ultimo
      C2LogAdd ('DanFormular Master add CtrB ultimo');
      if mtCtrBLin.RecordCount > 0 then
      begin
        AddTxt (mtCtrBLin, '   Ny CTRB saldo', FormatCurr('###,##0.00', CtrSaldoB));
        if CtrUdDatoB <> '' then
          AddTxt (mtCtrBLin,'   CTRB udløber ' + CtrUdDatoB, '');
      end;
      // Opsaml Ctr og Danmark linier
      C2LogAdd ('DanFormular Master add CtrB linier');
      mtCtrBLin.First;
      while not mtCtrBLin.Eof do
      begin
        AddLin ('',mtCtrBLinTxt.AsString,mtCtrBLinTxt.AsString,
                '','',mtCtrBLinBel.AsString,'','','','', '', '', '', '');
        mtCtrBLin.Next;
      end;
      C2LogAdd ('DanFormular Master add Danmark linier');
      mtDanLin.First;
      while not mtDanLin.Eof do
      begin
        AddLin ('',mtDanLinTxt.AsString,mtDanLinTxt.AsString,
                '','',mtDanLinBel.AsString,'','','','', '', '', '', '');
        mtDanLin.Next;
      end;
    end;
    // Totaler
    C2LogAdd ('DanFormular Master add totaler');
    mtMasterBrutto   .AsString := FormatCurr('###,##0.00', FakBrutto);
    C2LogAdd ('DanFormular Master Brutto ' + mtMasterBrutto.AsString);
    mtMasterSygTilsk .AsString := FormatCurr('###,##0.00', FakSygTilsk);
    C2LogAdd ('DanFormular Master SygTilsk ' + mtMasterSygTilsk.AsString);
    mtMasterKomTilsk .AsString := FormatCurr('###,##0.00', FakKomTilsk);
    C2LogAdd ('DanFormular Master KomTilsk ' + mtMasterKomTilsk.AsString);
    mtMasterPatAndel .AsString := FormatCurr('###,##0.00', FakNetto);
    C2LogAdd ('DanFormular Master PatAndel ' + mtMasterPatAndel.AsString);
    mtMasterExMoms   .AsString := FormatCurr('###,##0.00', FakExMoms);
    C2LogAdd ('DanFormular Master ExMoms ' + mtMasterExMoms.AsString);
    mtMasterMoms     .AsString := FormatCurr('###,##0.00', FakMoms);
    C2LogAdd ('DanFormular Master Moms ' + mtMasterMoms.AsString);
    mtMasterNetto    .AsString := FormatCurr('###,##0.00', FakNetto);
    C2LogAdd ('DanFormular Master Netto ' + mtMasterNetto.AsString);
    mtMasterFaktRabat.AsString := FormatCurr('###,##0.00', FakFaktRabat);
    C2LogAdd ('DanFormular Master FaktRabat ' + mtMasterFaktRabat.AsString);
    mtMasterPakkeAnt .AsString := IntToStr(ffEksFakAntalPakker.AsInteger);
    C2LogAdd ('DanFormular Master PakkeAnt ' + mtMasterPakkeAnt.AsString);
    mtMasterOcrbData .AsString := CalcOcrbLeft(mtMasterDeNr.AsString);
    C2LogAdd ('DanFormular Master OcrbData ' + mtMasterOcrbData.Asstring);
    mtMasterOCRBtekst .AsString := '';
    if ffDebKarBetalForm.AsInteger = 0 then
      mtMasterOCRBtekst.AsString := '>71< '+ mtMasterOcrbData.AsString + '+'
                                  + ffFrmTxt.fieldbyname('OCRBKredNr').AsString + '<';
    C2LogAdd ('DanFormular Master OcrbTekst ' + mtMasterOCRBtekst.Asstring);
    mtMasterGiroBel  .Asstring := CalcGiro(FakNetto);
    C2LogAdd ('DanFormular Master GiroBel '  + mtMasterGiroBel .Asstring);
    mtMasterPbsTekst .AsString := '';
    if ffDebKarBetalForm.AsInteger in [1..3] then
    begin
      C2LogAdd ('DanFormular Master BetalingsForm PBS ' + ffDebKarBetalForm.Asstring);
      mtMasterPbsTekst.AsString:= 'Opkræves via PBS';
      if ffDebKarBetalForm.AsInteger = 2 then
      begin
       if caps(C2StrPrm('Receptur','Undlad_PBS_tekst_for_totalkunder','Nej')) = 'JA'  then
         mtMasterPbsTekst .AsString := '';
      end;
      C2LogAdd ('DanFormular Master PbsTekst ' + mtMasterPbsTekst.Asstring);
      mtMasterNetto   .AsString:= mtMasterPbsTekst.AsString;
      C2LogAdd ('DanFormular Master Netto '    + mtMasterNetto   .Asstring);
      mtMasterGiroBel .Asstring:= mtMasterPbsTekst.AsString;
      C2LogAdd ('DanFormular Master Girobel '  + mtMasterGiroBel .Asstring);
    end;
    // c2pay code added as per request by Bo
    if ffDebKarBetalForm.AsInteger = 50 then
    begin
      C2LogAdd ('DanFormular Master BetalingsForm C2Pay korttræk');
      mtMasterPbsTekst.AsString:= 'Opkrævet via C2Pay';
      mtMasterNetto   .AsString:= mtMasterPbsTekst.AsString;
      mtMasterGiroBel .Asstring:= mtMasterPbsTekst.AsString;
    end;
    if ffDebKarLuBetalOpr.AsString = 'Egen' then
    begin
      C2LogAdd ('DanFormular Master BetalOperation ' + ffDebKarLuBetalOpr.Asstring);
      C2LogAdd ('DanFormular Master BetalNavn '      + ffDebKarLuBetalTxt.Asstring);
      mtMasterPbsTekst.AsString:= ffDebKarLuBetalTxt.Asstring;
      mtMasterNetto   .AsString:= mtMasterPbsTekst  .AsString;
      mtMasterGiroBel .Asstring:= mtMasterPbsTekst  .AsString;
    end;
    if Trim(ffDebKarEFaktEanKode.AsString) <> '' then
    begin
      C2LogAdd ('DanFormular Master BetalingsForm Efaktura ' + ffDebKarBetalForm.Asstring);
      mtMasterPbsTekst.AsString:= 'eFaktura';
      C2LogAdd ('DanFormular Master PbsTekst ' + mtMasterPbsTekst.Asstring);
      mtMasterNetto   .AsString:= mtMasterPbsTekst.AsString;
      C2LogAdd ('DanFormular Master Netto '    + mtMasterNetto   .Asstring);
      mtMasterGiroBel .Asstring:= mtMasterPbsTekst.AsString;
      C2LogAdd ('DanFormular Master Girobel '  + mtMasterGiroBel .Asstring);
    end;
    mtMasterOpkrTekst.AsString:= mtMasterPbsTekst.AsString;
    C2LogAdd ('DanFormular Master Post');
    mtMaster.Post;
    // Result ved OK
    Result := True;
    C2LogAdd ('DanFormular out');
  end;
end;

function TfmFakturaLaser.DanFormularFaktPakke : Boolean;
var
  FakBrutto,
  FakSygTilsk,
  FakKomTilsk,
  FakExMoms,
  FakMoms,
  FakNetto,
  FakFaktRabat,
  FakKontoGebyr : Currency;
  WrkDeNvn,
  WrkPaNvn,
  WrkDeAdr1,
  WrkPaAdr1,
  WrkStr,
  CtrUdDato    : String;
  saveindex : string;

  LKoel : boolean;



//  function ExcludeMoms(Bel: Currency): Currency;
//  begin
//    Result:= Bel;
//    if Bel <> 0 then
//      Result:= Round((Bel / 125.0) * 100 * 100) / 100;
//  end;
//

  procedure UdPakkeLstDetail;
  var
    EkspTyp : Word;
    Andel,
    Total   : Currency;
    SOpkrBel,
    SKont,
    SNavn,
    SAdr,
    SPakkeNr: String;
    UdLst   : TStringList;
    UdLst2   : TStringList;
    Copypakkenr : string;
    CopyAndel : Currency;
    Save_CPr : string;
    i : integer;
    PatSl : TStringList;
    tmpline : string;
    PatCount : integer;
    PatTotal : Currency;
    TestStr : string;
    TilbageDato : TDateTime;
  begin
    with MainDm,dmFormularer do
    begin
      C2LogAdd('udpakkelist start');
      EkspTyp := 0;
      PatSl := TStringList.Create;
      UdLst := TStringList.Create;
      UdLst2 := TStringList.Create;
      try

        fqLevList.Close;
        fqLevList.SQL.Clear;
        fqLevList.SQL.Add('	Select');
        fqLevList.SQL.Add('	  ' + fnEkspeditionerKundeNr);
        fqLevList.SQL.Add('		' + fnEkspeditionerNavn_K);
        fqLevList.SQL.Add('		,(Trim(' + fnEkspeditionerAdr1 +') + '' '' + ' + fnEkspeditionerPostNr+ ') as Address');
        fqLevList.SQL.Add('		' + fnEkspeditionerLbNr_K);
        fqLevList.SQL.Add('		' + fnEkspeditionerPakkeNr_K);
        fqLevList.SQL.Add('		' + fnEkspeditionerFakturaNr_K);
        fqLevList.SQL.Add('		,case');
        fqLevList.SQL.Add('			when ' + fnEkspeditionerOrdreType +' = 2');
        fqLevList.SQL.Add('				then');
        fqLevList.SQL.Add('					0 - (' + fnEkspeditionerAndel + '+' + fnEkspeditionerTlfGebyr+ '+' + fnEkspeditionerEdbGebyr+ '+' + fnEkspeditionerUdbrGebyr+')');
        fqLevList.SQL.Add('				else');
        fqLevList.SQL.Add('					(' +fnEkspeditionerAndel + '+' + fnEkspeditionerTlfGebyr+ '+' + fnEkspeditionerEdbGebyr+ '+' + fnEkspeditionerUdbrGebyr+')');
        fqLevList.SQL.Add('		end as Andel');
        fqLevList.SQL.Add('		' + fnEkspeditionerBrugerKontrol_K);
        fqLevList.SQL.Add('		' + fnEkspeditionerLevNavn_K);
        fqLevList.SQL.Add('		' + fnEkspeditionerKontonr_K);
        fqLevList.SQL.Add('		' + fnEkspeditionerOrdreStatus_K);
        fqLevList.SQL.Add('		,case');
        fqLevList.SQL.Add('			when ' + fnEkspeditionerOrdreStatus+' =2');
        fqLevList.SQL.Add('	 			then');
        fqLevList.SQL.Add('					' + fnEkspeditionerAfsluttetDato);
        fqLevList.SQL.Add('				else');
        fqLevList.SQL.Add('					' + fnEkspeditionerTakserDato);
        fqLevList.SQL.Add('		end as Dato');
        fqLevList.SQL.Add('		' + fnEkspeditionerTurNr_K);
        fqLevList.SQL.Add('		' + fnEkspeditionerOrdreType_K);
        fqlevlist.SQL.Add('   ' + fnEkspeditionerReturdage_K);
        fqlevlist.SQL.Add('   ' + fnEkspeditionerTakserDato_K);
        fqLevList.SQL.Add('	FROM');
        fqLevList.SQL.Add('		' + tnEkspeditioner);
        fqLevList.SQL.Add('	where');
        fqLevList.SQL.Add('		' + fnEkspeditionerFakturaNr_P);

        fqLevList.SQL.Add('order by');
        fqLevList.SQL.Add('	Navn,');
        fqLevList.SQL.Add('	Kundenr,');
        fqLevList.SQL.Add('	PakkeNr');
        fqLevList.ParamByName('fakturanr').AsString := ffEksFakFakturaNr.AsString;
        fqLevList.Timeout:=100000;
        C2LogAdd(fqLevList.SQL.Text);
        try
          fqLevList.Open;
        except
          on  e : Exception do
            ChkBoxOK(e.Message);
        end;

        // Leveringsliste

        // Gennemløb
        Copypakkenr := '';
        CopyAndel := 0;
        Save_CPR := '';
        patsl.Clear;
        PatCount := 0;
        PatTotal := 0;
        Total := 0;
        TilbageDato := 0;
        fqLevList.First;
        while not fqLevList.Eof do
        begin
          if (EkspTyp <> 0) and
              (fqLevList.FieldByName('ordrestatus').AsInteger <> EkspTyp) then
          begin
            fqLevList.Next;
            continue;
          end;
          // set up the earliest retur date
          if mtMasterTilbDato.AsString = '' then
          begin
            TilbageDato := fqLevList.FieldByName('TakserDato').AsDateTime +
              fqLevList.FieldByName('Returdage').AsInteger;
            mtMasterTilbDato.AsString := FormatDateTime('dd-mm-yyyy',TilbageDato);
          end
          else
          begin
            if TilbageDato > ( fqLevList.FieldByName('TakserDato').AsDateTime +
              fqLevList.FieldByName('Returdage').AsInteger) then
            begin
              TilbageDato := fqLevList.FieldByName('TakserDato').AsDateTime +
                fqLevList.FieldByName('Returdage').AsInteger;
              mtMasterTilbDato.AsString := FormatDateTime('dd-mm-yyyy',TilbageDato);
            end;

          end;

          TestStr := fqLevList.FieldByName('Kundenr').AsString + fqLevList.FieldByName('Navn').AsString;
          c2logadd('test is ' + TestStr);
          C2LogAdd('save_cpr is ' + Save_CPr);
          if Save_CPr <> TestStr then
          begin
            if Save_CPr <> '' then
            begin
              if PatSl.Count <> 0 then
              begin
                tmpline := '';
                for i:= 0  to PatSl.Count - 1 do
                begin
                  if tmpline = '' then
                    tmpline :=  Copypakkenr + '(' + PatSl.Strings[i]
                  else
                    tmpline := tmpline + ',' + PatSl.Strings[i];
                end;
                Copypakkenr := 'xxx';
                tmpline := tmpline + ')';
                UdLst.Add(format('%-60.60s',[copy(tmpline,1,60)]));
                if LKoel then
                  UdLst2.Add(FormCurr2Str('  ###,##0.00', CopyAndel) + ' Køl')
                else
                  UdLst2.Add(FormCurr2Str('  ###,##0.00', CopyAndel));
                PatTotal := PatTotal + CopyAndel;
                C2LogAdd('1a : pattotal is now ' + Curr2Str(PatTotal));
              end;
              if PatCount > 1 then
              begin
                UdLst.Add('');
                udlst2.Add('------------');
                UdLst.Add('');
                udlst2.Add(FormCurr2Str('  ###,##0.00', PatTotal));
                UdLst.Add('');
                udlst2.Add('------------');
             end;
              PatSl.Clear;
              UdLst.Add('');
              udlst2.Add('');
              LKoel := False;
            end;
            SNavn:= Trim(fqLevList.fieldbyname('Navn').AsString);
            SNavn:= SNavn + Spaces (34 - Length(SNavn));
            SAdr := Trim(fqLevList.fieldbyname('Address').AsString);
            UdLst.Add(SNavn + SAdr);
            udlst2.Add('');
            PatSl.Clear;
            LKoel := False;
            PatCount := 0;
            PatTotal := 0;
          end;
          SPakkeNr := fqLevList.fieldbyname('Pakkenr').AsString;
          Save_CPr := TestStr;
          Andel := fqLevList.fieldbyname('Andel').AsCurrency;
          if andel < 0 then
            Skont := '   ';
          Total:= Total + Andel;
          SOpkrBel:= FormCurr2Str(' ###,##0.00', Andel);
          if Copypakkenr <> '' then
          begin
            if Copypakkenr=Spakkenr then
            begin
              CopyAndel := CopyAndel + Andel;
            end
            else
            begin
              if PatSl.Count <> 0 then
              begin
                tmpline := '';
                for i:= 0  to PatSl.Count - 1 do
                begin
                  if tmpline = '' then
                    tmpline :=  Copypakkenr + '(' + PatSl.Strings[i]
                  else
                    tmpline := tmpline + ',' + PatSl.Strings[i];
                end;
                PatSl.Clear;
                tmpline := tmpline + ')';
                UdLst.Add(format('%-120.120s',[copy(tmpline,1,60)]));
                if LKoel then
                  UdLst2.Add(FormCurr2Str('  ###,##0.00', CopyAndel) + ' Køl')
                else
                  UdLst2.Add(FormCurr2Str('  ###,##0.00', CopyAndel));
                PatCount := PatCount + 1;
                PatTotal := PatTotal + CopyAndel;
                C2LogAdd('1 : pattotal is now ' + Curr2Str(PatTotal));
              end;
              CopyAndel:= Andel;
            end;
          end;
          if Copypakkenr = '' then
            CopyAndel := andel;
          Copypakkenr := SPakkeNr;
          patsl.Add(fqLevList.fieldbyname('Lbnr').AsString);
          if not LKoel  then
            LKoel := KoelProductOnEkspedition(fqLevList.fieldbyname('Lbnr').AsInteger);
          fqLevList.Next;
        end;
        if PatSl.Count <> 0 then
        begin
          tmpline := '';
          for i:= 0  to PatSl.Count - 1 do
          begin
            if tmpline = '' then
              tmpline :=  SPakkeNr + '(' + PatSl.Strings[i]
            else
              tmpline := tmpline + ',' + PatSl.Strings[i];
          end;
          PatSl.Clear;
          tmpline := tmpline + ')';
          UdLst.Add(format('%-120.120s',[copy(tmpline,1,60)]));
          if LKoel then
            UdLst2.Add(FormCurr2Str('  ###,##0.00', CopyAndel) + ' Køl')
          else
            UdLst2.Add(FormCurr2Str('  ###,##0.00', CopyAndel));
          PatCount := PatCount + 1;
          PatTotal := PatTotal + CopyAndel;
                C2LogAdd('2 : pattotal is now ' + Curr2Str(PatTotal));
          LKoel := False;

        end;
        if PatCount > 1 then
        begin
                UdLst.Add('');
                udlst2.Add('------------');
                UdLst.Add('');
                udlst2.Add(FormCurr2Str('  ###,##0.00', PatTotal));
                UdLst.Add('');
                udlst2.Add('------------');
        end;
        UdLst.Add('');
        UdLst2.Add('');
        for i := 0 to UdLst.Count - 1 do
        begin
          C2LogAdd(UdLst.Strings[i]);
          if UdLst2.Strings[i] = '' then
            AddLin('','',UdLst.Strings[i],'','','','','','','','','')
          else
          begin
            C2LogAdd(UdLst2.Strings[i]);
            AddLin('','',UdLst.Strings[i],'','','','','',udlst2.Strings[i],'','','');
          end;
        end;
      finally
        fqLevList.Close;
        UdLst.Free;
        UdLst2.Free;
        PatSl.Free;
      end;
      C2LogAdd('Leveringsliste2 slut');
    end;
  end;

begin
  with MidClient, MainDm, dmFormularer do
  begin
    C2LogAdd ('DanFormularFaktPakke in');
    // Result ved fejl
    Result := False;
    // Find debitor
    if not ffDebKar.FindKey([ffEksFakKontoNr.AsString]) then
    begin
      // Debitor fundet
      ChkBoxOk ('Kan ikke finde debitorkonto under dan formular!');
      Exit;
    end;
    ffEksOvr.First;
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
    C2LogAdd ('DanFormular Master pakkenr felt');
    mtMasterPakkeNr  .Value    := 0;
    C2LogAdd ('DanFormular Master fakturanr felt ' + IntToStr (ffEksFakFakturaNr.Value));
    mtMasterFaktNr   .Value    := ffEksFakFakturaNr  .Value;
    C2LogAdd ('DanFormular Master EFaktOrdrenrfelt ' + ffEksFakEFaktOrdreNr.AsString);
    mtMasterEFaktOrdreNr   .AsString    := ffEksFakEFaktOrdreNr  .AsString;
    C2LogAdd ('DanFormular Master fakturatype felt');
    mtMasterFaktType .AsString := ffEksFakFakturaType.AsString;
    C2LogAdd ('DanFormular Master rabat/pakker felter');
    if ffEksFakFakturaRabat.AsCurrency <> 0 then
      mtMasterFaktRabat.AsString := FormatCurr('###,##0.00', ffEksFakFakturaRabat.AsCurrency);
    if ffEksFakAntalPakker.Value <> 0 then
      mtMasterPakkeAnt .AsString := IntToStr (ffEksFakAntalPakker.Value);
    C2LogAdd ('DanFormular Master DK/bruger felter');
    if ffEksOvrDKMedlem.Value = 1 then
      mtMasterDKmedlem .AsString := ffEksOvrDKMedlem.AsString;
    if ffEksOvrBrugerTakser.Value > 0 then
      mtMasterBrTakser .AsString := ffEksOvrBrugerTakser.AsString;
    C2LogAdd ('DanFormular Master dato felter');
    mtMasterEkspDato .AsString := FormatDateTime('dd-mm-yyyy',ffEksOvrTakserDato   .AsDateTime);
    mtMasterAfslDato .AsString := FormatDateTime('dd-mm-yyyy',ffEksOvrAfsluttetDato.AsDateTime);
//    mtMasterTilbDato .AsString := FormatDateTime('dd-mm-yyyy',ffEksOvrTakserDato   .AsDateTime+ ffEksOvrReturdage.AsInteger);
    mtMasterTilbDato .AsString := '';  // initialise to blank
    mtMasterForfDato .AsString := FormatDateTime('dd-mm-yyyy',ffEksFakForfaldsDato .AsDateTime);
    mtMasterBetalBet .AsString := ffEksFakKreditTekst.AsString;
    // Navn og adresse på debitor
    C2LogAdd ('DanFormular Master debitor felter');
    mtMasterDeNr     .AsString := ffEksFakKontoNr.AsString;
    mtMasterDeNavn   .AsString := BytNavn (ffEksFakKontoNavn.AsString);
    mtMasterDeAdr1   .AsString := ffEksFakKontoAdr1.AsString;
    mtMasterDeAdr2   .AsString := ffEksFakKontoAdr2.AsString;
    mtMasterDeAdr3   .AsString := ffEksFakKontoAdr3.AsString;
    mtMasterLevTil   .AsString := '';
    mtMasterXPaNr    .AsString := Trim (ffEksOvrKundeNr.AsString);
    mtMasterXPaNavn  .AsString := Trim (BytNavn (ffEksOvrNavn.AsString));
    // Levnr og levnavn
    mtMasterLevNavn.AsString := '';
    if Trim(ffEksOvrLevNavn.AsString) <> '' then
    begin
      mtMasterLevNavn.AsString := Trim(ffEksOvrLevNavn.AsString);
      saveindex := ffDebKar.IndexName;
      ffDebKar.IndexName := 'NrOrden';
      try
        if ffDebKar.FindKey([trim(ffEksOvrLevNavn.AsString)]) then
          mtMasterLevNavn.AsString := mtMasterLevNavn.AsString +
                ' ' + ffDebKarNavn.AsString;
      finally
        ffDebKar.IndexName := saveindex;
        // Reset debitor back to main debitor
        if not ffDebKar.FindKey([ffEksFakKontoNr.AsString]) then
        begin
          // Debitor fundet
          ChkBoxOk ('Kan ikke finde debitorkonto under dan formular!');
        end;
      end;
    end;
    // Navn og adresse på patienten
    C2LogAdd ('DanFormular Master patient felter');
    if (ffEksFakLeveringsTekst.AsString = 'Privat')      or
       (ffEksFakLeveringsTekst.AsString = 'Institution') then
    begin
      WrkDeNvn  := Caps (Trim (         mtMasterDeNavn.AsString));
      WrkPaNvn  := Caps (Trim (BytNavn (ffEksOvrNavn  .AsString)));
      WrkDeAdr1 := Caps (Trim (         mtMasterDeAdr1.AsString));
      WrkPaAdr1 := Caps (Trim (         ffEksOvrAdr1  .AsString));
      if (WrkDeNvn <> WrkPaNvn) or (WrkDeAdr1 <> WrkPaAdr1) then
      begin
        mtMasterLevTil.AsString := 'Leveringsadresse :';
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
      end;
    end;
    // Beregn alle totaler
    C2LogAdd ('DanFormular nulstil totaler');
    FakNetto     := 0;
    CtrUdDato    := '';
    C2LogAdd ('DanFormular recept gennemløb');
    // Udfyld felter fra gennemløb

    UdPakkeLstDetail;

    // Check momsfri debitor
    FakKontoGebyr:= ffEksFakKontoGebyr.AsCurrency;
    if ffDebKarMomsType.AsInteger = 0 then
    begin
      // Fratræk moms på totaler
      FakBrutto    := FakNetto;
      FakSygTilsk  := 0;
      FakKomTilsk  := 0;
      FakExMoms    := FakNetto;
      FakMoms      := 0;
      FakFaktRabat := 0;
(* Not needed after changes in ver. 7.2.3.7
      FakKontoGebyr:= FakKontoGebyr - BruttoMoms(FakKontoGebyr,MomsPercent);
   Not needed after changes in ver. 7.2.3.7 *)
    end
    else
    begin
      FakBrutto    := ffEksFakBrutto      .AsCurrency;
      FakSygTilsk  := ffEksFakTilskAmt    .AsCurrency;
      FakKomTilsk  := ffEksFakTilskKom    .AsCurrency;
      FakExMoms    := ffEksFakExMoms      .AsCurrency;
      FakMoms      := ffEksFakMoms        .AsCurrency;
      FakNetto     := ffEksFakNetto       .AsCurrency;
      FakFaktRabat := ffEksFakFakturaRabat.AsCurrency;
    end;
    // Kontogebyr
    C2LogAdd ('DanFormular kontogebyr');
    if FakKontoGebyr <> 0 then
    begin
      AddLin ('','Kontogebyr','Kontogebyr','','','','','',
              FormatCurr('###,##0.00', FakKontoGebyr),
              FormatCurr('###,##0.00', FakKontoGebyr), '', '');
    end;
    // Totaler
    C2LogAdd ('DanFormular Master add totaler');
    mtMasterBrutto   .AsString := FormatCurr('###,##0.00', FakBrutto);
    C2LogAdd ('DanFormular Master Brutto ' + mtMasterBrutto.AsString);
    mtMasterSygTilsk .AsString := FormatCurr('###,##0.00', FakSygTilsk);
    C2LogAdd ('DanFormular Master SygTilsk ' + mtMasterSygTilsk.AsString);
    mtMasterKomTilsk .AsString := FormatCurr('###,##0.00', FakKomTilsk);
    C2LogAdd ('DanFormular Master KomTilsk ' + mtMasterKomTilsk.AsString);
    mtMasterPatAndel .AsString := FormatCurr('###,##0.00', FakNetto);
    C2LogAdd ('DanFormular Master PatAndel ' + mtMasterPatAndel.AsString);
    mtMasterExMoms   .AsString := FormatCurr('###,##0.00', FakExMoms);
    C2LogAdd ('DanFormular Master ExMoms ' + mtMasterExMoms.AsString);
    mtMasterMoms     .AsString := FormatCurr('###,##0.00', FakMoms);
    C2LogAdd ('DanFormular Master Moms ' + mtMasterMoms.AsString);
    mtMasterNetto    .AsString := FormatCurr('###,##0.00', FakNetto);
    C2LogAdd ('DanFormular Master Netto ' + mtMasterNetto.AsString);
    mtMasterFaktRabat.AsString := FormatCurr('###,##0.00', FakFaktRabat);
    C2LogAdd ('DanFormular Master FaktRabat ' + mtMasterFaktRabat.AsString);
    mtMasterPakkeAnt .AsString := IntToStr(ffEksFakAntalPakker.AsInteger);
    C2LogAdd ('DanFormular Master PakkeAnt ' + mtMasterPakkeAnt.AsString);
    mtMasterOcrbData .AsString := CalcOcrbLeft(mtMasterDeNr.AsString +
                                  FormatDateTime('ddmm',nxFaktQueryAfsluttetDato.AsDateTime));
    C2LogAdd ('DanFormular Master OcrbData ' + mtMasterOcrbData.Asstring);
    mtMasterOCRBtekst .AsString := '';
    if ffDebKarBetalForm.AsInteger = 0 then
      mtMasterOCRBtekst.AsString := '>71< '+ mtMasterOcrbData.AsString + '+'
                                  + ffFrmTxt.fieldbyname('OCRBKredNr').AsString + '<';
    C2LogAdd ('DanFormular Master OcrbTekst ' + mtMasterOCRBtekst.Asstring);
    mtMasterGiroBel  .Asstring := CalcGiro(FakNetto);
    C2LogAdd ('DanFormular Master GiroBel '  + mtMasterGiroBel .Asstring);
    mtMasterPbsTekst .AsString := '';
    if ffDebKarBetalForm.AsInteger in [1..3] then
    begin
      C2LogAdd ('DanFormular Master BetalingsForm PBS ' + ffDebKarBetalForm.Asstring);
      mtMasterPbsTekst.AsString:= 'Opkræves via PBS';
      C2LogAdd ('DanFormular Master PbsTekst ' + mtMasterPbsTekst.Asstring);
      mtMasterNetto   .AsString:= mtMasterPbsTekst.AsString;
      C2LogAdd ('DanFormular Master Netto '    + mtMasterNetto   .Asstring);
      mtMasterGiroBel .Asstring:= mtMasterPbsTekst.AsString;
      C2LogAdd ('DanFormular Master Girobel '  + mtMasterGiroBel .Asstring);
    end;
    // c2pay code added as per request by Bo
    if ffDebKarBetalForm.AsInteger = 50 then
    begin
      C2LogAdd ('DanFormular Master BetalingsForm C2Pay korttræk');
      mtMasterPbsTekst.AsString:= 'Opkrævet via C2Pay';
      mtMasterNetto   .AsString:= mtMasterPbsTekst.AsString;
      mtMasterGiroBel .Asstring:= mtMasterPbsTekst.AsString;
    end;
    if ffDebKarLuBetalOpr.AsString = 'Egen' then
    begin
      C2LogAdd ('DanFormular Master BetalOperation ' + ffDebKarLuBetalOpr.Asstring);
      C2LogAdd ('DanFormular Master BetalNavn '      + ffDebKarLuBetalTxt.Asstring);
      mtMasterPbsTekst.AsString:= ffDebKarLuBetalTxt.Asstring;
      mtMasterNetto   .AsString:= mtMasterPbsTekst  .AsString;
      mtMasterGiroBel .Asstring:= mtMasterPbsTekst  .AsString;
    end;
    if Trim(ffDebKarEFaktEanKode.AsString) <> '' then
    begin
      C2LogAdd ('DanFormular Master BetalingsForm Efaktura ' + ffDebKarBetalForm.Asstring);
      mtMasterPbsTekst.AsString:= 'eFaktura';
      C2LogAdd ('DanFormular Master PbsTekst ' + mtMasterPbsTekst.Asstring);
      mtMasterNetto   .AsString:= mtMasterPbsTekst.AsString;
      C2LogAdd ('DanFormular Master Netto '    + mtMasterNetto   .Asstring);
      mtMasterGiroBel .Asstring:= mtMasterPbsTekst.AsString;
      C2LogAdd ('DanFormular Master Girobel '  + mtMasterGiroBel .Asstring);
    end;
    mtMasterOpkrTekst.AsString:= mtMasterPbsTekst.AsString;
    C2LogAdd ('DanFormular Master Post');
    mtMaster.Post;
    // Result ved OK
    Result := True;
    C2LogAdd ('DanFormularFaktPakke out');
  end;
end;




procedure TfmFakturaLaser.CheckFridgeProduct(ALager: integer;AVarenr: string);
var
  save_index : string;
begin
  with MainDm,dmFormularer do
  begin
    c2logadd('check køl for ' + AVarenr);
    save_index := ffLagKar.IndexName;
    ffLagKar.IndexName := 'NrOrden';

    try
      if ffLagKar.FindKey([ALager,AVarenr]) then
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

procedure TfmFakturaLaser.chkFaktClick(Sender: TObject);
begin
  chkKont.Checked := not chkFakt.Checked;
  if chkFakt.Checked then
    eFraNr.SetFocus;
end;

procedure TfmFakturaLaser.chkKontClick(Sender: TObject);
begin
  chkFakt.Checked := not chkKont.Checked;
  if chkKont.Checked then
    edtKundenr.SetFocus;
end;

procedure TfmFakturaLaser.UdskrivFaktKont;
var
  KontoNr :   string;
  Kopier,
  FaktType  : Word;
  FaktRave,
  FaktForm,
  FaktPrn,
  FaktBakke,
  GemIdx    : String;
  Fakturanr : integer;
  tst : boolean;
  tmpPDFFolder : string;
  options : TSelectDirOpts;
  save_folder :string;
  EmailTekst : TStringList;
begin
  with MainDm, dmFormularer do
  begin

    Application.ProcessMessages;
    C2LogAdd ('UdskrivFakKont in');
//    if AskQuestions then
//    begin
//      PrintPaper := frmYesNo.NewYesNoBox('Skal fakturaen udskrives?');
//    end;
    if chkVaelgPDF.Checked then
    begin
      save_folder := GetCurrentDir;
      try
        if LastPDFFolder <> '' then
          tmpPDFFolder := LastPDFFolder;
        if not SelectDirectory(tmpPDFFOlder,options,0) then
          exit;
        tmpPDFFOlder  := AddSlash(tmpPDFFOlder);
        LastPDFFolder := tmpPDFFolder;
        c2logadd('tmppdffiolder is ' + tmpPDFFOlder);
      finally
        SetCurrentDir(save_folder);
      end;
    end;
    tmpPDFFolder := IncludeTrailingBackslash( PDFFolder );
    // Disable knapper
    buUdskriv.Enabled  := False;
    buFortryd.Enabled  := False;
    GemIdx             := ffEksFak.IndexName;
    ffEksFak.IndexName := 'KontonrOrden';
    EmailTekst := TStringList.Create;
    try
      KontoNr := edtKundenr.Text;
      if not ffDebKar.FindKey ([Kontonr]) then
      begin
        ChkBoxOK('Debitonr ike findes');
        exit;
      end;
      if ffDebKarBetalForm.AsInteger = 50 then
        SendByMail := False
      else
        SendByMail := TfrmEmailFaktura.EmailFakturaQuery(EmailTekst);

      PrintPaper := frmYesNo.NewYesNoBox('Skal fakturaen udskrives?');

      ffEksFak.SetRange ([Kontonr], [Kontonr]);
      if ffEksFak.RecordCount = 0 then
      begin
        ChkBoxOK('No fakturas found for kontonr');
        exit;
      end;
      ffEksFak.First;
      while not ffEksFak.Eof do
      begin
        Fakturanr := ffEksFakFakturaNr.AsInteger;
        if (trunc(ffEksFakAfsluttetDato.AsDateTime) < trunc(DateTimePicker1.Date)) or
            (trunc(ffEksFakAfsluttetDato.AsDateTime) > trunc(DateTimePicker2.Date)) then
        begin
          ffEksFak.Next;
          continue;
        end;

        try
          C2LogAdd ('udsrivfaktont fakturanr is ' + IntToStr(Fakturanr));
          ffEksOvr.SetRange ([FakturaNr], [FakturaNr]);
          try
            if (ffEksOvrKundeType.Value in [pt_Enkeltperson]) or (ffEksOvrPakkeNr.Value > 0) then
            begin
              if (ffEksFakLeveringsTekst.AsString = 'Håndkøbsudsalg' ) or
                   (ffEksFakLeveringsTekst.AsString = 'Udleveringssted') or
                   (ffEksFakLeveringsTekst.AsString = 'Bud'            ) then
              begin
                FaktType  := FakturaPakkeListe;
                FaktRave  := FaktPakkeFil;
                FaktForm  := FaktPakkeFrm;
                FaktPrn   := FaktPakkePrn;
                FaktBakke := FaktPakkeBin;
                Kopier    := FaktPakkeAnt;
              end
              else
              begin
                if ffEksFakLeveringsTekst.AsString = 'Institution' then
                begin
                  FaktType  := FakturaInstitution;
                  FaktRave  := FaktInstFil;
                  FaktForm  := FaktInstFrm;
                  FaktPrn   := FaktInstPrn;
                  FaktBakke := FaktInstBin;
                  Kopier    := FaktInstAnt;
                end
                else
                begin
                  FaktType  := FakturaPrivat;
                  FaktRave  := FaktPrivFil;
                  FaktForm  := FaktPrivFrm;
                  FaktPrn   := FaktPrivPrn;
                  FaktBakke := FaktPrivBin;
                  Kopier    := FaktPrivAnt;
                end;
              end;
            end
            else
            begin
              FaktType  := FakturaLeverance;
              FaktRave  := FaktLevFil;
              FaktForm  := FaktLevFrm;
              FaktPrn   := FaktLevPrn;
              FaktBakke := FaktLevBin;
              Kopier    := FaktLevAnt;
            end;
            C2LogAdd ('buUdskriv DanFormular');
            if DanFormular (FaktType) then
            begin
              try
                // Printermulighed
                C2LogAdd ('buUdskriv FaktPrn vælges');
                if FaktPrn <> '' then
                begin
                  // Forvalg
                  C2LogAdd ('buUdskriv SelectPrinter "' + FaktPrn + '"');
                  tst := c2SelectPrinter (FaktPrn,rpSystem,'Faktura ' + FakturaNr.ToString);
                  C2LogAdd('C2selectprinter ' + Bool2Str(tst));
                end;
                // Bakkemulighed
                C2LogAdd ('buUdskriv FaktBakke vælges');
                if FaktBakke <> '' then
                begin
                  // Forvalg
                  C2LogAdd ('buUdskriv SelectBin "' + FaktBakke + '"');
                  tst := C2SelectBin (FaktBakke);
                  C2LogAdd('C2selectBin ' + Bool2Str(tst));
                end;
                // Eksekver rapport
                C2LogAdd ('buUdskriv Copies "' + IntToStr(Kopier) + '"');
                rpSystem.SystemPrinter.Copies      := Kopier;
                C2LogAdd ('buUdskriv ProjectFile "' + FaktRave + '"');
                rpProjekt.ProjectFile := FaktRave;
                C2LogAdd ('buUdskriv Open Project');
                rpProjekt.Open;
                rpProjekt.Engine := RpSystem;
                rpSystem.DoNativeOutput := False;
                rpSystem.RenderObject := rpPDF;
                rpSystem.DefaultDest := rdFile;
                if FileExists(tmpPDFFolder + format('FAKT%8.8d',[FakturaNr]) + '.pdf') then
                  DeleteFile(tmpPDFFolder + format('FAKT%8.8d',[FakturaNr]) + '.pdf');
                rpSystem.OutputFileName := tmpPDFFolder + format('FAKT%8.8d',[FakturaNr]) + '.pdf';
                dmFormularer.rpSystem.SystemSetups := rpSystem.SystemSetups - [ssAllowSetup];
                c2logadd('Before PDF execute report');
                rpProjekt.ExecuteReport(FaktForm);
                c2logadd('After PDF execute report');
                rpProjekt.Close;
                if ffDebKarFaktura.AsBoolean and (ffDebKarBetalForm.AsInteger <> 50) then
                begin
                  if SendByMail then
                  begin
                    // reprint as pdf
                    c2logadd('Before send by Email');
                    if not SendFaktureByEmail(ffDebKarMail.AsString,
                        tmpPDFFolder + format('FAKT%8.8d',[FakturaNr]) + '.pdf',EmailTekst) then
                      ChkBoxOK('Fejl i send faktura via email');
                  end;
                  if not AskQuestions then
                  begin
                    if ChkBoxYesNo('Send faktura ' + inttostr(FakturaNr) +' via email til ' +
                          ffDebKarmail.AsString + '?',False) then
                    begin
                      c2logadd('Before send by Email');
                      if not SendFaktureByEmail(ffDebKarMail.AsString,
                          tmpPDFFolder + format('FAKT%8.8d',[FakturaNr]) + '.pdf',EmailTekst) then
                        ChkBoxOK('Fejl i send faktura via email');
                      PrintPaper := ChkBoxYesNo('Skal fakturaen udskrives?',False);
                    end;
                    AskQuestions := True;
                  end;
                end;

                if PrintPaper then
                begin
                  try
                    // Printermulighed
                    C2LogAdd ('buUdskriv FaktPrn vælges');
                    if FaktPrn <> '' then
                    begin
                      // Forvalg
                      C2LogAdd ('buUdskriv SelectPrinter "' + FaktPrn + '"');
                      tst := C2SelectPrinter (FaktPrn,rpSystem,'Faktura ' + FakturaNr.ToString);
                      C2LogAdd('C2selectprinter ' + Bool2Str(tst));
                    end;
                    // Bakkemulighed
                    C2LogAdd ('buUdskriv FaktBakke vælges');
                    if FaktBakke <> '' then
                    begin
                      // Forvalg
                      C2LogAdd ('buUdskriv SelectBin "' + FaktBakke + '"');
                      C2SelectBin(FaktBakke);
                    end;
                    // Eksekver rapport
                    C2LogAdd ('buUdskriv Copies "' + IntToStr(Kopier) + '"');
                    rpSystem.SystemPrinter.Copies      := Kopier;
                    C2LogAdd ('buUdskriv ProjectFile "' + FaktRave + '"');
                    rpProjekt.ProjectFile := FaktRave;
                    C2LogAdd ('buUdskriv Open Project for Printer ');
                    rpProjekt.Open;
                    rpProjekt.Engine := rpSystem;
                    rpSystem.DoNativeOutput := True;
                    dmFormularer.RPSystem.SystemSetups := RPSystem.SystemSetups - [ssAllowSetup];
                    rpSystem.RenderObject := Nil;
                    rpSystem.DefaultDest := rdPrinter;
                    rpSystem.OutputFileName := '';
                    c2logadd('Before execute report for printer');
                    rpProjekt.ExecuteReport (FaktForm);
                    c2logadd('After execute report for printer');
                    rpProjekt.Close;
                  except
                    on e : Exception do
                      ChkBoxOK(e.Message);

                  end;
                end;


                if FaktType = FakturaLeverance then
                begin
                  // Er følgeseddel sat op
                  if FolgeSedPrn <> '' then
                  begin
                    C2LogAdd ('buUdskriv SelectPrinter "' + FolgeSedPrn + '"');
                    tst := C2SelectPrinter (FolgeSedPrn,rpSystem,'Faktura ' + FakturaNr.ToString);
                    C2LogAdd('C2selectprinter ' + Bool2Str(tst));
                    if FolgeSedBin <> '' then
                    begin
                      C2LogAdd ('buUdskriv SelectBin "' + FolgeSedBin + '"');
                     tst := C2SelectBin (FolgeSedBin);
                     C2LogAdd('C2selectBin ' + Bool2Str(tst));
                    end;
                    C2LogAdd ('buUdskriv Copies "' + IntToStr(FolgeSedAnt) + '"');
                    rpSystem.SystemPrinter.Copies      := FolgeSedAnt;
                    C2LogAdd ('buUdskriv ProjectFile "' + FolgeSedFil + '"');
                    rpProjekt.ProjectFile := FolgeSedFil;
                    C2LogAdd ('buUdskriv Open Project');
                    rpProjekt.Open;
                    C2LogAdd ('buUdskriv ExecuteReport "' + FolgeSedFrm + '"');
                    rpProjekt.ExecuteReport (FolgeSedFrm);
                    C2LogAdd ('buUdskriv Close Project');
                    rpProjekt.Close;
                    // Restore default printer
                    if StdPrintPrn <> '' then
                    begin
                      tst := C2SelectPrinter(StdPrintPrn);
                      C2LogAdd('C2selectprinter ' + Bool2Str(tst));
                    end;
                    if StdPrintBin <> '' then
                    begin
                      tst := C2SelectBin(StdPrintBin);
                      C2LogAdd('C2selectBin ' + Bool2Str(tst));
                    end;
                  end;
                end;
              except
                on E:Exception do
                begin
                  C2LogAdd ('buUdskriv exception "' + E.Message + '"');
                  rpProjekt.Close;
                end;
              end;
            end;
            C2LogAdd ('buUdskriv efter DanFormular');
          finally
            ffEksOvr.CancelRange;
          end;
        except
          on  e : exception do
            ChkBoxOk ('Exception i faktura laserprinter !' + e.Message);

        end;
        ffEksFak.Next;
      end;
    finally
      EmailTekst.Free;
    end;
    C2LogAdd ('buUdskriv out');
  end;
end;


function TfmFakturaLaser.DanFormularFaktPakkeGamle : Boolean;
var
  FakBrutto,
  FakSygTilsk,
  FakKomTilsk,
  FakExMoms,
  FakMoms,
  FakNetto,
  FakFaktRabat,
  FakKontoGebyr,
  LinPatAndel,
  TotLinAndel,
  TotTlfGebyr,
  TotEdbGebyr,
  TotUdbGebyr : Currency;
  WrkDeNvn,
  WrkPaNvn,
  WrkDeAdr1,
  WrkPaAdr1,
  WrkStr,
  CtrUdDato    : String;
  LinNr        : Word;
  saveindex : string;

//  function ExcludeMoms(Bel: Currency): Currency;
//  begin
//    Result:= Bel;
//    if Bel <> 0 then
//      Result:= Round((Bel / 125.0) * 100 * 100) / 100;
//  end;


  // routine to set mtmastertilbagedato to earliest return date
{ TODO : needs to use sql }
  procedure SetEarliestTilbageDato;
  var
    TilbageDato : TDateTime;
  begin
    with MainDm,dmFormularer do
    begin

      nxFaktQuery.First;
      // initialise the earliest date to that of the first ekspedition
      TilbageDato := nxFaktQuery.FieldByName('takserdato').AsDateTime +
        nxFaktQuery.FieldByName('Returdage').AsInteger;
      while not nxFaktQuery.Eof do
      begin
        // if current ekspedition ia less than current earlist date then update earlist date
        if TilbageDato > (nxFaktQuery.FieldByName('takserdato').AsDateTime +
          nxFaktQuery.FieldByName('Returdage').AsInteger) then
          TilbageDato := nxFaktQuery.FieldByName('takserdato').AsDateTime +
            nxFaktQuery.FieldByName('Returdage').AsInteger;

        nxFaktQuery.Next;
      end;
      mtMasterTilbDato.AsString := FormatDateTime('dd-mm-yyyy', TilbageDato);
      C2LogAdd('*** Latest return date is ' + mtMasterTilbDato.AsString);

    end;

  end;

begin
  with MidClient, MainDm, dmFormularer do
  begin
    C2LogAdd ('DanFormularFaktPakkeGamle in');
    // Result ved fejl
    Result := False;
    // Find debitor
    if not ffDebKar.FindKey([ffEksFakKontoNr.AsString]) then
    begin
      // Debitor fundet
      ChkBoxOk ('Kan ikke finde debitorkonto under dan formular!');
      Exit;
    end;
    ffEksOvr.First;
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
    C2LogAdd ('DanFormular Master pakkenr felt');
    mtMasterPakkeNr  .Value    := 0;
    C2LogAdd ('DanFormular Master fakturanr felt ' + IntToStr (ffEksFakFakturaNr.Value));
    mtMasterFaktNr   .Value    := ffEksFakFakturaNr  .Value;
    C2LogAdd ('DanFormular Master EFaktOrdrenrfelt ' + ffEksFakEFaktOrdreNr.AsString);
    mtMasterEFaktOrdreNr   .AsString    := ffEksFakEFaktOrdreNr  .AsString;
    C2LogAdd ('DanFormular Master fakturatype felt');
    mtMasterFaktType .AsString := ffEksFakFakturaType.AsString;
    C2LogAdd ('DanFormular Master rabat/pakker felter');
    if ffEksFakFakturaRabat.AsCurrency <> 0 then
      mtMasterFaktRabat.AsString := FormatCurr('###,##0.00', ffEksFakFakturaRabat.AsCurrency);
    if ffEksFakAntalPakker.Value <> 0 then
      mtMasterPakkeAnt .AsString := IntToStr (ffEksFakAntalPakker.Value);
    C2LogAdd ('DanFormular Master DK/bruger felter');
    if ffEksOvrDKMedlem.Value = 1 then
      mtMasterDKmedlem .AsString := ffEksOvrDKMedlem.AsString;
    if ffEksOvrBrugerTakser.Value > 0 then
      mtMasterBrTakser .AsString := ffEksOvrBrugerTakser.AsString;
    C2LogAdd ('DanFormular Master dato felter');
    mtMasterEkspDato .AsString := FormatDateTime('dd-mm-yyyy',ffEksOvrTakserDato   .AsDateTime);
    mtMasterAfslDato .AsString := FormatDateTime('dd-mm-yyyy',ffEksOvrAfsluttetDato.AsDateTime);
//    mtMasterTilbDato .AsString := FormatDateTime('dd-mm-yyyy',
//      ffEksOvrTakserDato   .AsDateTime + ffEksOvrReturdage.AsInteger);
    mtMasterForfDato.AsString := FormatDateTime('dd-mm-yyyy', ffEksFakForfaldsDato .AsDateTime);
    mtMasterBetalBet .AsString := ffEksFakKreditTekst.AsString;
    // Navn og adresse på debitor
    C2LogAdd ('DanFormular Master debitor felter');
    mtMasterDeNr     .AsString := ffEksFakKontoNr.AsString;
    mtMasterDeNavn   .AsString := BytNavn (ffEksFakKontoNavn.AsString);
    mtMasterDeAdr1   .AsString := ffEksFakKontoAdr1.AsString;
    mtMasterDeAdr2   .AsString := ffEksFakKontoAdr2.AsString;
    mtMasterDeAdr3   .AsString := ffEksFakKontoAdr3.AsString;
    mtMasterLevTil   .AsString := '';
    mtMasterXPaNr    .AsString := Trim (ffEksOvrKundeNr.AsString);
    mtMasterXPaNavn  .AsString := Trim (BytNavn (ffEksOvrNavn.AsString));
    // Levnr og levnavn
    mtMasterLevNavn.AsString := '';
    if Trim(ffEksOvrLevNavn.AsString) <> '' then
    begin
      mtMasterLevNavn.AsString := Trim(ffEksOvrLevNavn.AsString);
      saveindex := ffDebKar.IndexName;
      ffDebKar.IndexName := 'NrOrden';
      try
        if ffDebKar.FindKey([trim(ffEksOvrLevNavn.AsString)]) then
          mtMasterLevNavn.AsString := mtMasterLevNavn.AsString +
                ' ' + ffDebKarNavn.AsString;
      finally
        ffDebKar.IndexName := saveindex;
        // Reset debitor back to main debitor
        if not ffDebKar.FindKey([ffEksFakKontoNr.AsString]) then
          // Debitor fundet
          ChkBoxOk ('Kan ikke finde debitorkonto under dan formular!');
      end;
    end;
    // Navn og adresse på patienten
    C2LogAdd ('DanFormular Master patient felter');
    if (ffEksFakLeveringsTekst.AsString = 'Privat')      or
       (ffEksFakLeveringsTekst.AsString = 'Institution') then
    begin
      WrkDeNvn  := Caps (Trim (         mtMasterDeNavn.AsString));
      WrkPaNvn  := Caps (Trim (BytNavn (ffEksOvrNavn  .AsString)));
      WrkDeAdr1 := Caps (Trim (         mtMasterDeAdr1.AsString));
      WrkPaAdr1 := Caps (Trim (         ffEksOvrAdr1  .AsString));
      if (WrkDeNvn <> WrkPaNvn) or (WrkDeAdr1 <> WrkPaAdr1) then
      begin
        mtMasterLevTil.AsString := 'Leveringsadresse :';
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
      end;
    end;
    mtMasterKoel.AsString := '';
    // Beregn alle totaler
    C2LogAdd ('DanFormular nulstil totaler');
    FakNetto     := 0;
    CtrUdDato    := '';
    C2LogAdd ('DanFormular recept gennemløb');
    // Udfyld felter fra gennemløb

    nxFaktQuery.Close;
    nxFaktQuery.SQL.Text := 'select * from 	ekspeditioner where FAKTURANR=:FAKTNR order by pakkenr,lbnr';
    nxFaktQuery.ParamByName('FAKTNR').AsInteger := ffEksFakFakturaNr.AsInteger;
    nxFaktQuery.Open;
    if nxFaktQuery.RecordCount <> 0 then
    begin
      SetEarliestTilbageDato;
      nxFaktQuery.First;
      while not nxFaktQuery.Eof do
      begin
        // Tillæg gebyrer afhængig om det er kreditnota
        TotLinAndel  := 0;
        TotTlfGebyr  := nxFaktQueryTlfGebyr .AsCurrency;
        TotEdbGebyr  := nxFaktQueryEdbGebyr .AsCurrency;
        TotUdbGebyr  := nxFaktQueryUdbrGebyr.AsCurrency;
  //      TotDkTilsk   := nxFaktQueryDKTilsk  .AsCurrency;
  //      TotDkEjTilsk := nxFaktQueryDKEjTilsk.AsCurrency;
        if nxFaktQueryOrdreType.Value = 2 then
        begin
          TotTlfGebyr  := -TotTlfGebyr;
          TotEdbGebyr  := -TotEdbGebyr;
          TotUdbGebyr  := -TotUdbGebyr;
  //        TotDkTilsk   := -TotDKTilsk;
  //        TotDkEjTilsk := -TotDKEjTilsk;
        end;
        // Summer totaler fra gebyrer
        for LinNr := 1 to nxFaktQueryAntLin.Value do
        begin
          if ffEksLin.FindKey ([nxFaktQueryLbNr.Value, LinNr]) then
          begin
            if ffEksTil.FindKey ([nxFaktQueryLbNr.Value, LinNr]) then
            begin
              CheckFridgeProduct(ffEksOvrLager.AsInteger, ffEksLinSubVareNr.AsString);
             // Tillæg linieandele afhængig om det er kreditnota
              LinPatAndel := ffEksTilAndel    .AsCurrency;
              if nxFaktQueryOrdreType.Value = 2 then
                LinPatAndel := -LinPatAndel;
              // Summer totaler fra linier
              TotLinAndel := TotLinAndel + LinPatAndel;
            end;
          end;
        end;

        // Indsæt linie
        AddLin ('',
                  'Pakkenr ' + IntToStr (nxFaktQueryPakkeNr.Value),
                  'Pakkenr ' + IntToStr (nxFaktQueryPakkeNr.Value) +
                  '/' + BytNavn (nxFaktQueryNavn.AsString) +
                  '/' + trim(nxFaktQueryAdr1.AsString) +
                  trim(' ' + nxFaktQueryAdr2.AsString) +
                  ' ' + nxFaktQueryPostNr.AsString,
                  '','','','','',FormatCurr('###,##0.00', TotLinAndel),'', '', '');
        // Tlf/EDB/Udbr.gebyr
        C2LogAdd ('DanFormular Master add gebyrer recept');
(* Not needed after changes in ver. 7.2.3.7
        // Check momsfri debitor
        if ffDebKarMomsType.AsInteger = 0 then
        begin
          // Fratræk moms på totaler
          TotTlfGebyr:= BruttoMoms(TotTlfGebyr,MomsPercent);
          TotEdbGebyr:= BruttoMoms(TotEdbGebyr,MomsPercent);
          TotUdbGebyr:= BruttoMoms(TotUdbGebyr,MomsPercent);
        end;
   Not needed after changes in ver. 7.2.3.7 *)
        if TotTlfGebyr <> 0 then
        begin
          AddLin ('','Tlf.gebyr','Tlf.gebyr','','','','','',
                  FormatCurr('###,##0.00', TotTlfGebyr),
                  FormatCurr('###,##0.00', TotTlfGebyr), '', '');
        end;
        if TotEdbGebyr <> 0 then
        begin
          AddLin ('','Edb-gebyr','Edb-gebyr','','','','','',
                  FormatCurr('###,##0.00', TotEdbGebyr),
                  FormatCurr('###,##0.00', TotEdbGebyr), '', '');
        end;
        if TotUdbGebyr <> 0 then
        begin
          AddLin ('','Udbr.gebyr','Udbr.gebyr','','','','','',
                  FormatCurr('###,##0.00', TotUdbGebyr),
                  FormatCurr('###,##0.00', TotUdbGebyr), '', '');
        end;
        nxFaktQuery.Next;
        if not nxFaktQuery.Eof then
          AddLin ('','','','','','','','','','', '', '');
      end;
    end;
    // Check momsfri debitor
    FakKontoGebyr:= ffEksFakKontoGebyr.AsCurrency;
    if ffDebKarMomsType.AsInteger = 0 then
    begin
      // Fratræk moms på totaler
      FakBrutto    := FakNetto;
      FakSygTilsk  := 0;
      FakKomTilsk  := 0;
      FakExMoms    := FakNetto;
      FakMoms      := 0;
      FakFaktRabat := 0;
(* Not needed after changes in ver. 7.2.3.7
      FakKontoGebyr:= FakKontoGebyr - BruttoMoms(FakKontoGebyr,MomsPercent);
   Not needed after changes in ver. 7.2.3.7 *)
    end
    else
    begin
      FakBrutto    := ffEksFakBrutto      .AsCurrency;
      FakSygTilsk  := ffEksFakTilskAmt    .AsCurrency;
      FakKomTilsk  := ffEksFakTilskKom    .AsCurrency;
      FakExMoms    := ffEksFakExMoms      .AsCurrency;
      FakMoms      := ffEksFakMoms        .AsCurrency;
      FakNetto     := ffEksFakNetto       .AsCurrency;
      FakFaktRabat := ffEksFakFakturaRabat.AsCurrency;
    end;
    // Kontogebyr
    C2LogAdd ('DanFormular kontogebyr');
    if FakKontoGebyr <> 0 then
    begin
      AddLin ('','Kontogebyr','Kontogebyr','','','','','',
              FormatCurr('###,##0.00', FakKontoGebyr),
              FormatCurr('###,##0.00', FakKontoGebyr), '', '');
    end;
    // Totaler
    C2LogAdd ('DanFormular Master add totaler');
    mtMasterBrutto   .AsString := FormatCurr('###,##0.00', FakBrutto);
    C2LogAdd ('DanFormular Master Brutto ' + mtMasterBrutto.AsString);
    mtMasterSygTilsk .AsString := FormatCurr('###,##0.00', FakSygTilsk);
    C2LogAdd ('DanFormular Master SygTilsk ' + mtMasterSygTilsk.AsString);
    mtMasterKomTilsk .AsString := FormatCurr('###,##0.00', FakKomTilsk);
    C2LogAdd ('DanFormular Master KomTilsk ' + mtMasterKomTilsk.AsString);
    mtMasterPatAndel .AsString := FormatCurr('###,##0.00', FakNetto);
    C2LogAdd ('DanFormular Master PatAndel ' + mtMasterPatAndel.AsString);
    mtMasterExMoms   .AsString := FormatCurr('###,##0.00', FakExMoms);
    C2LogAdd ('DanFormular Master ExMoms ' + mtMasterExMoms.AsString);
    mtMasterMoms     .AsString := FormatCurr('###,##0.00', FakMoms);
    C2LogAdd ('DanFormular Master Moms ' + mtMasterMoms.AsString);
    mtMasterNetto    .AsString := FormatCurr('###,##0.00', FakNetto);
    C2LogAdd ('DanFormular Master Netto ' + mtMasterNetto.AsString);
    mtMasterFaktRabat.AsString := FormatCurr('###,##0.00', FakFaktRabat);
    C2LogAdd ('DanFormular Master FaktRabat ' + mtMasterFaktRabat.AsString);
    mtMasterPakkeAnt .AsString := IntToStr(ffEksFakAntalPakker.AsInteger);
    C2LogAdd ('DanFormular Master PakkeAnt ' + mtMasterPakkeAnt.AsString);
    mtMasterOcrbData .AsString := CalcOcrbLeft(mtMasterDeNr.AsString +
                                  FormatDateTime('ddmm',nxFaktQueryAfsluttetDato.AsDateTime));
    C2LogAdd ('DanFormular Master OcrbData ' + mtMasterOcrbData.Asstring);
    mtMasterOCRBtekst .AsString := '';
    if ffDebKarBetalForm.AsInteger = 0 then
      mtMasterOCRBtekst.AsString := '>71< '+ mtMasterOcrbData.AsString + '+'
                                  + ffFrmTxt.fieldbyname('OCRBKredNr').AsString + '<';
    C2LogAdd ('DanFormular Master OcrbTekst ' + mtMasterOCRBtekst.Asstring);
    mtMasterGiroBel  .Asstring := CalcGiro(FakNetto);
    C2LogAdd ('DanFormular Master GiroBel '  + mtMasterGiroBel .Asstring);
    mtMasterPbsTekst .AsString := '';
    if ffDebKarBetalForm.AsInteger in [1..3] then
    begin
      C2LogAdd ('DanFormular Master BetalingsForm PBS ' + ffDebKarBetalForm.Asstring);
      mtMasterPbsTekst.AsString:= 'Opkræves via PBS';
      C2LogAdd ('DanFormular Master PbsTekst ' + mtMasterPbsTekst.Asstring);
      mtMasterNetto   .AsString:= mtMasterPbsTekst.AsString;
      C2LogAdd ('DanFormular Master Netto '    + mtMasterNetto   .Asstring);
      mtMasterGiroBel .Asstring:= mtMasterPbsTekst.AsString;
      C2LogAdd ('DanFormular Master Girobel '  + mtMasterGiroBel .Asstring);
    end;
    // c2pay code added as per request by Bo
    if ffDebKarBetalForm.AsInteger = 50 then
    begin
      C2LogAdd ('DanFormular Master BetalingsForm C2Pay korttræk');
      mtMasterPbsTekst.AsString:= 'Opkrævet via C2Pay';
      mtMasterNetto   .AsString:= mtMasterPbsTekst.AsString;
      mtMasterGiroBel .Asstring:= mtMasterPbsTekst.AsString;
    end;
    if ffDebKarLuBetalOpr.AsString = 'Egen' then
    begin
      C2LogAdd ('DanFormular Master BetalOperation ' + ffDebKarLuBetalOpr.Asstring);
      C2LogAdd ('DanFormular Master BetalNavn '      + ffDebKarLuBetalTxt.Asstring);
      mtMasterPbsTekst.AsString:= ffDebKarLuBetalTxt.Asstring;
      mtMasterNetto   .AsString:= mtMasterPbsTekst  .AsString;
      mtMasterGiroBel .Asstring:= mtMasterPbsTekst  .AsString;
    end;
    if Trim(ffDebKarEFaktEanKode.AsString) <> '' then
    begin
      C2LogAdd ('DanFormular Master BetalingsForm Efaktura ' + ffDebKarBetalForm.Asstring);
      mtMasterPbsTekst.AsString:= 'eFaktura';
      C2LogAdd ('DanFormular Master PbsTekst ' + mtMasterPbsTekst.Asstring);
      mtMasterNetto   .AsString:= mtMasterPbsTekst.AsString;
      C2LogAdd ('DanFormular Master Netto '    + mtMasterNetto   .Asstring);
      mtMasterGiroBel .Asstring:= mtMasterPbsTekst.AsString;
      C2LogAdd ('DanFormular Master Girobel '  + mtMasterGiroBel .Asstring);
    end;
    mtMasterOpkrTekst.AsString:= mtMasterPbsTekst.AsString;
    C2LogAdd ('DanFormular Master Post');
    mtMaster.Post;
    // Result ved OK
    Result := True;
    C2LogAdd ('DanFormularFaktPakkeGamle out');
  end;
end;




end.
