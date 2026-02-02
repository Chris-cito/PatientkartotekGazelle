unit TakserAfslut;

{ Developed by: Cito IT A/S

  Description: Afslut ekspeditioner fra taksering

  Date/Initials   Description
  --------------  ------------------------------------------------------------------------------------------------------
  28-05-2024/cjs  Changed Takserafslut routine to only update the Eordre if there are no
                  more order lines left to process.  This should fix the 5 øre issue

  20-11-2023/cjs  Added code to not update total pris on eordre if the calculated total
  price is within a limit in øre specified by EorderPriceWithinLimits
  parameter in winpacer

  02-02-2023/cjs  Replace calls to SendC2ErrorMail with CSS logging

  30-06-2022/cjs  Rewrite UpdateEhord routine to use TakserC2Nr

  24-11-2020/cjs  Changed afslutreturnering to always call UpdateDMVS.  This fixes
  an issue where a partially stregkodekontrolled ekspedition left an
  item in a dispense/ on hold state in DMVS log

  29-10-2020/cjs  Modified to use new property for Recepturplads

  19-08-2020/cjs  change to update eorder lines to compare varenr, subvarenr
  and the ordineretvarenummer

  12-08-2020/cjs  report to c2fmkkø all retur ekspeditioner not just those that
  are afsluttet

  07-08-2020/cjs   Report error if lager does not exist in OpdaterLager function

  06-04-2020/cjs   Only write to rs_ekspqueue if kundetype is enkeltperson (1)

  01-04-2020/cjs   report the credit to C2fmkkø  not the original ekspedition number.  This allows
  the correct bruger to log in.  C2fmkkø wil work out with ekpedition is the
  original ekspedition and work through all credits correctly.

  30-03-2020/cjs   KeepReceptLokalt property added. if set to Nej then locsl copy of prescription
  is kept if removestatus is called

  15-10-2019/cjs   Update ctrsaldo in eordre from ekspliniertilskud even if the product has been
  substituted

  11-10-2019/cjs   Get the latest ctrsaldo from last ekspliniertilskud rather than from the
  ekspedtioner record. This is necessary due to Cannabis change

  09-10-2019/cjs   Update the ctr values after each line in the pakkelist for eordre

  10-09-2019/cjs   use the kundenavn specified at the start of taksering

  05-08-2019/cjs   EscapePressedInDMVS boolean property added

  25-07-2019/cjs   Always get the current patient record from the ekspedition when saving an
  ekspedition.

  29-05-2019/CJS   opdaterlagereksp call checks on AppResConError(6) and retries, also the timeout
  for the call is reduced to 10 seconds

  21-05-2019/cjs   dmvs not enabled on the afdeling so use the global connection

  06-05-2019/cjs   Change tekst on lms32 etiket to Flere mindre pakninger er billigere

  30-04-2019/cjs   Use minimum of antal returned and antal2dscanned when requesting scans of DMVS
  packages.  New field retuerTidspunkt is checked to exclude pacages that have
  already been scanned.

  29-04-2019/cjs   Use CurrentDMVS connection t be created if afdnr is different and free it if created
  also added exception handling to cope with error when processing UpdateDMVS

  26-04-2019/cjs   Create a local new TC2DMVSSrvConnection if the original ekspedition was done in a
  different afdeling from the curren afdeling.

  25-04-2019/cjs   Only request scans for those products that have been 2d scanned when returning
  part of an ekspedition

  24-04-2019/cjs   if the product has not been scanned by 2d barcode then do not ask user to scan
  again when returning part of an ekspedition

  10-04-2019/cjs           dont set bruger kontrol to brugertakser if all lines are credited
  04-04-2019/cjs   7.2.4.4 use ekpslinierserienumre.tables to avoid stupid spelling mistake
  29-03-2019/cjs           dont warn if dmvs product but not scanned 2d code
  25-03-2019/cjs   7.2.4.0 wrong calculation of udbrgebyr uden moms
  22-03-2019/cjs   7.2.3.9 use gebyr properties for comparsion based on inclmoms on each line
  22-03-2019/BN    7.2.3.8 Change Moms calculations for TlfGebyr, EdbGebyr and UdbrGebyr

  13-02-2019/BN    7.2.2.7 Change Moms calculations from InclMoms = FALSE
  Some cleanup - remove code fx. LagerOpdatering
  Spelling mistakes
  All code with these changes marked (* BN

  CJS REMEMBER:
  Remoce nxLagerOpdatering from DM
  Add mtMomsPct and mtMomsBel to mtLin (used for EkspLinierSalg
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,System.StrUtils,
  ExtCtrls, DB, ComCtrls, Math, uFMKCalls;

type
  TAfslutForm = class(TForm)
    paTxt: TPanel;
    paAnimation: TPanel;
    Animate: TAnimate;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure UpdateEHOrd(Pakkenr: integer);
  public
    { Public declarations }
    procedure VisTekst(const S: String);
    procedure GemRegel42Retrunering(var Lbnr: integer; var Linienr: integer; Linantal: integer);
  end;

procedure AfslutEkspedition(Human, CloseF6, CloseSF6, CloseCF6, CloseCSF6: Boolean; OrdreDato: TDateTime);
procedure AfslutReturnering(Lbnr: LongWord);
procedure UbiAfstempling(CloseCF6, CloseCSF6: Boolean);
procedure UbiKronikerLabel;
procedure UbiEtiketter;
function UseOldPakkeNr: Boolean;
function ReturUseOldPakkeNr: Boolean;
function UseOldPakkeNr0Ekspedition: Boolean;
procedure ReportCancelledRCP(Lbnr: LongWord);
procedure CheckDeletedLines;
procedure Create0ekspedition(var Res: Word);
procedure SendRowaOrdre;
function UpdateDMVS(AFullEkspedition: Boolean; ABrugerNr, AOldlbnr, ANewLbnr, AAfdnr: integer): Boolean;
// procedure OpdaterCTR;

var
  AfslKontoNr: String;
  AfslLevForm: Word;
  AfslLbNr: integer;
  AfslPakkeNr: LongWord;
  AfslutForm: TAfslutForm;
  PakkeNrSet: Boolean;
  ReportReceptServer: Boolean;
  saveRobotUdtag: string;
  SendToCTR: Boolean;
  PartialCredit: Boolean;

implementation

uses
  // TakserHuman,
  HentHeltal,
  ChkBoxes,
  C2WinApi,
  C2MainLog,
  C2Procs,
  // OpdaterKonti,
  UbiPrinter,
  MidClientApi,
  LaserFormularer,
  UdskrivPakkeLaser,
  UdskrivFakturaLaser,
  Main,
  DM, frmEkspLin, nxdb,
  uRowaUdtag, uGebyr, frmMidCli, uyesno, uRowaAppCall,
  ufrmDVMS,
  uc2common.procs,
  uEkspLinierSerienumre.Tables,
  uEHOrdreHeader.Tables, uEHOrdreLinier.Tables,
  uLagerNavne.Tables,
  uC2DMVSSvrConnection.Classes,
  uC2Environment,
  uC2LLog.Types, PatMatrixPrinter,
  uc2ui.mainlog.procs,
  uC2Fmk.Common.Types;

{$R *.DFM}

function GemEkspedition(OrdreDato: TDateTime): Boolean;
var
  PemUpd, CtrUpd: Boolean;
  VetTotal, VetGebyr, SaldoA, SaldoB: Currency;
  Retries, Lin, Res: Word;
  SaveRSline_index: string;
  Automatisk0Ekspedition: Boolean;
  SaveEksIndex: string;
  SavePatIndex: string;
  LemvigVet: Boolean;
  i: integer;
  udbGebyr: Currency;
  GebyrUdenMoms: Currency;
  savedebindex: string;
  ServerDateTime: TDateTime;
  SaveDCHIndex: string;
  RSEkspediton: Boolean;
  EHPakkenr: integer;
  gebyrKontonr: string;

  procedure AddGeneriskeData(etk: TStringList);
  var
    save_index: string;

    procedure delete_old_indhold;
    var
      i: integer;
      tmpstr: string;
    begin
      c2logadd('before deleting indhold ' + etk.Text);
      for i := 0 to etk.Count - 1 do
      begin
        tmpstr := etk.Strings[i];
        if tmpstr = '------------------------------' then
        begin
          etk.Delete(i);
          break;
        end;
      end;
      for i := 0 to etk.Count - 1 do
      begin
        tmpstr := etk.Strings[i];
        if pos('INDHOLD:', tmpstr) <> 0 then
        begin
          etk.Delete(i);
          break;
        end;
      end;
      c2logadd('after deleting indhold ' + etk.Text);

    end;

  begin
    with MainDm do
    begin
      c2logadd('in AddgeneriskeData');
      if pos('INDHOLD:', etk.Text) <> 0 then
      begin
        c2logadd('Indhold tekst already on the label');
        delete_old_indhold;
      end;
      try
        try
          save_index := nxLager.IndexName;
          nxLager.IndexName := 'NrOrden';
          try

            if not nxLager.FindKey([0, ffEksLinSubVareNr.AsString]) then
              exit;
            c2logadd('varenr ' + nxLagerVareNr.AsString + ' drugid ' + nxLagerDrugId.AsString);
            cdsGeneriske.IndexFieldNames := 'Varenr';
            if cdsGeneriske.FindKey([nxLagerVareNr.AsString]) then
            begin

              etk.Add('------------------------------');
              etk.Add(caps('Indhold:' + copy(cdsGeneriskeNavn.AsString, 1, 24)));
              exit;
            end;

            if nxLagerDrugId.AsString <> '' then
            begin
              cdsGeneriske.IndexFieldNames := 'Drugid';
              if cdsGeneriske.FindKey([nxLagerDrugId.AsString]) then
              begin
                etk.Add('------------------------------');
                etk.Add(caps('Indhold:' + copy(cdsGeneriskeNavn.AsString, 1, 24)));
                exit;
              end;
            end;
          finally
            nxLager.IndexName := save_index;
          end;
        except
          on E: Exception do
            c2logadd('Fejl in AddGeneriskedata ' + E.Message);
        end;
      finally
        c2logadd('Bottom of AddGeneriskeData');
      end;
    end;
  end;

  procedure AddVetVarenavnData(etk: TStringList);
  var
    save_index: string;

    procedure delete_old_VetVareNavn;
    var
      i: integer;
      tmpstr: string;
    begin
      c2logadd('before deleting VetVareNavn ' + etk.Text);
      for i := 0 to etk.Count - 1 do
      begin
        tmpstr := etk.Strings[i];
        if tmpstr = '------------------------------' then
        begin
          etk.Delete(i);
          break;
        end;
      end;
      for i := 0 to etk.Count - 1 do
      begin
        tmpstr := etk.Strings[i];
        if pos('VARENAVN:', tmpstr) <> 0 then
        begin
          etk.Delete(i);
          break;
        end;
      end;
      c2logadd('after deleting VetVareNavn ' + etk.Text);

    end;

  begin
    with MainDm do
    begin
      c2logadd('in AddVetVarenavnData');
      if pos('VARENAVN:', etk.Text) <> 0 then
      begin
        c2logadd('VetVarenavn tekst already on the label');
        delete_old_VetVareNavn;
      end;
      try
        try
          save_index := nxLager.IndexName;
          nxLager.IndexName := 'NrOrden';
          try

            if not nxLager.FindKey([0, ffEksLinSubVareNr.AsString]) then
              exit;
            c2logadd('varenr ' + nxLagerVareNr.AsString + ' ' + nxLagerNavn.AsString);
            etk.Add('------------------------------');
            etk.Add(caps('VARENAVN:' + copy(nxLagerNavn.AsString, 1, 21)));
            exit;
          finally
            nxLager.IndexName := save_index;
          end;
        except
          on E: Exception do
            c2logadd('Fejl in AddGeneriskedata ' + E.Message);
        end;
      finally
        c2logadd('Bottom of AddGeneriskeData');
      end;
    end;
  end;

  procedure tr_AddEkspLinierSalg;
  begin
    with MainDm do
    begin
      // Ekspeditionslinier gemmes
      try

        Res := 120;
        ffEksLin.Insert;
        ffEksLinLbNr.Value := ffEksKarLbNr.Value;
        ffEksLinLinieNr.Value := Lin;
        ffEksLinLinieType.Value := mtLinLinieType.Value;
        ffEksLinLager.Value := mtEksLager.Value;
        ffEksLinVareNr.AsString := mtLinVareNr.AsString;
        ffEksLinSubVareNr.AsString := mtLinSubVareNr.AsString;
        ffEksLinStatNr.AsString := '';
        ffEksLinLokation1.Value := mtLinLokation1.Value;
        ffEksLinLokation2.Value := mtLinLokation2.Value;
        ffEksLinLokation3.Value := 0;
        ffEksLinVareType.Value := mtLinVareType.AsInteger;
        ffEksLinVareGruppe.Value := 0;
        ffEksLinStatGruppe.Value := 0;
        ffEksLinOmsType.Value := 0;
        ffEksLinNarkoType.Value := mtLinNarkoType.Value;
        ffEksLinTilskType.Value := mtLinTilskType.Value;
        ffEksLinDKType.Value := mtLinDKType.Value;
        ffEksLinUdlevType.AsString := mtLinUdlevType.AsString;
        ffEksLinKlausul.AsString := mtLinHaType.AsString;
        ffEksLinTekst.AsString := mtLinTekst.AsString;
        ffEksLinEnhed.AsString := '';
        ffEksLinDyreArt.Value := mtLinDyreArt.Value;
        ffEksLinAldersGrp.Value := mtLinAldersGrp.Value;
        ffEksLinOrdGrp.Value := mtLinOrdGrp.Value;
        ffEksLinUdlevMax.Value := mtLinUdLevMax.Value;
        ffEksLinUdlevNr.Value := mtLinUdLevNr.Value;
        ffEksLinAntal.Value := mtLinAntal.Value;
        ffEksLinPris.AsCurrency := mtLinPris.AsCurrency;
        ffEksLinKostPris.AsCurrency := mtLinKostPris.AsCurrency;
        ffEksLinVareForbrug.AsCurrency := ffEksLinKostPris.AsCurrency * ffEksLinAntal.Value;
        ffEksLinVareForbrug.AsCurrency := RoundDecCurr(ffEksLinVareForbrug.AsCurrency);
        ffEksLinBrutto.AsCurrency := mtLinBrutto.AsCurrency;
        (* BN change VAT begin - remove code
          ffEksLinInclMoms.AsBoolean := True;
          ffEksLinMomsPct.AsCurrency := ffRcpOplMomsPct.AsCurrency;
          ffEksLinRabatPct.AsCurrency := 0;;
          ffEksLinRabat.AsCurrency := 0;
          ffEksLinNetto.AsCurrency := ffEksLinBrutto.AsCurrency;
          ffEksLinExMoms.AsCurrency := (ffEksLinBrutto.AsCurrency * 100) /
          (ffEksLinMomsPct.AsCurrency + 100);
          ffEksLinExMoms.AsCurrency := RoundDecCurr(ffEksLinExMoms.AsCurrency);
          ffEksLinMoms.AsCurrency := ffEksLinBrutto.AsCurrency -
          ffEksLinExMoms.AsCurrency;
          BN change VAT end *)
        (* BN change VAT begin - new code *)
        ffEksLinNetto.AsCurrency := ffEksLinBrutto.AsCurrency;
        ffEksLinRabatPct.AsCurrency := 0;;
        ffEksLinRabat.AsCurrency := 0;
        ffEksLinInclMoms.AsBoolean := mtLinInclMoms.AsBoolean;
        // Override InclMoms from lines
        ffEksKarInclMoms.AsBoolean := ffEksLinInclMoms.AsBoolean;
        // Different calculation depending on InclMoms
        if ffEksLinInclMoms.AsBoolean = FALSE then
        begin
          // Momsfri - nulstil momsfelter både ekspedition og linje
          ffEksKarMomsPct.AsCurrency := 0;
          ffEksLinMomsPct.AsCurrency := 0;
          ffEksLinExMoms.AsCurrency := ffEksLinBrutto.AsCurrency;
          ffEksLinExMoms.AsCurrency := RoundDecCurr(ffEksLinExMoms.AsCurrency);
        end
        else
        begin
          // Normal inkl. moms - beregn excl. moms felter
          ffEksKarMomsPct.AsCurrency := MomsPercent;
          ffEksLinMomsPct.AsCurrency := MomsPercent;
          ffEksLinExMoms.AsCurrency := (ffEksLinBrutto.AsCurrency * 100) / (ffEksLinMomsPct.AsCurrency + 100);
          ffEksLinExMoms.AsCurrency := RoundDecCurr(ffEksLinExMoms.AsCurrency);
        end;
        ffEksLinMoms.AsCurrency := ffEksLinBrutto.AsCurrency - ffEksLinExMoms.AsCurrency;
        ffEksLinMoms.AsCurrency := RoundDecCurr(ffEksLinMoms.AsCurrency);
        (* BN change VAT end *)
        ffEksLinEjS.Value := 0;
        ffEksLinEjG.Value := 0;
        ffEksLinEjO.Value := 0;
        ffEksLinEjS.Value := 1;
        ffEksLinEjS.Value := mtLinSubstValg.Value;
        ffEksLinForm.AsString := mtLinForm.AsString;
        ffEksLinStyrke.AsString := mtLinStyrke.AsString;
        ffEksLinPakning.AsString := mtLinPakning.AsString;
        ffEksLinATCType.AsString := mtLinATCType.AsString;
        ffEksLinATCKode.AsString := mtLinATCKode.AsString;
        ffEksLinSSKode.AsString := mtLinSSKode.AsString;
        ffEksLinPAKode.AsString := mtLinPAKode.AsString;
        try
          ffEksLinOrdinationId.AsString := mtLinOrdId.AsString;

        except
          on E: Exception do
            c2logadd('Error adding ordination id to EksplinierSalg ' + E.Message);
        end;
        MainDm.ffEksLinUdstederAutId.AsString := MainDm.mtLinUdstederAutid.AsString;
        MainDm.ffEksLinUdstederId.AsString := MainDm.mtLinUdstederId.AsString;
        MainDm.ffEksLinUdstederType.AsInteger := MainDm.mtLinUdstederType.AsInteger;
        MainDm.ffEksLinDrugId.AsString := MainDm.mtLinDrugid.AsString;
        MainDm.ffEksLinOpbevKode.AsString := MainDm.mtLinOpbevKode.AsString;
        Res := 121;
        ffEksLin.Post;
      except
        on E: Exception do
        begin
          c2logadd('Error insert into ekspliniersalg ' + E.Message);
          try
            ffEksLin.Cancel;
          except
            on E: Exception do
              c2logadd('Error cancelling edit on Ekspliniersalg ' + E.Message);
          end;
          raise;
        end;

      end;

    end;
  end;

  procedure tr_AddEkspLinierTilskud;
  begin
    with MainDm do
    begin
      // Ekspeditionstilskud gemmes
      try

        Res := 130;
        ffEksTil.Insert;
        ffEksTilLbNr.Value := ffEksKarLbNr.Value;
        ffEksTilLinieNr.Value := Lin;
        ffEksTilESP.AsCurrency := mtLinESP.AsCurrency;
        ffEksTilBGP.AsCurrency := mtLinBGP.AsCurrency;
        ffEksTilSaldo.AsCurrency := mtLinNySaldo.AsCurrency;
        ffEksTilIBPBel.AsCurrency := mtLinBGPBel.AsCurrency;
        ffEksTilBGPBel.AsCurrency := mtLinBGPBel.AsCurrency;
        ffEksTilIBTBel.AsCurrency := mtLinIBTBel.AsCurrency;
        ffEksTilUdligning.AsCurrency := mtLinUdligning.AsCurrency;
        ffEksTilAndel.AsCurrency := mtLinAndel.AsCurrency;
        ffEksTilTilskSyg.AsCurrency := mtLinTilskSyg.AsCurrency;
        ffEksTilTilskKom1.AsCurrency := mtLinTilskKom1.AsCurrency;
        ffEksTilTilskKom2.AsCurrency := mtLinTilskKom2.AsCurrency;
        ffEksTilRegelSyg.Value := mtLinRegelSyg.Value;
        ffEksTilRegelKom1.Value := mtLinRegelKom1.Value;
        ffEksTilRegelKom2.Value := mtLinRegelKom2.Value;
        ffEksTilPromilleSyg.Value := mtLinPromilleSyg.Value;
        ffEksTilPromilleKom1.Value := mtLinPromilleKom1.Value;
        ffEksTilPromilleKom2.Value := mtLinPromilleKom2.Value;
        ffEksTilAfdeling1.AsString := mtLinAfdeling1.AsString;
        ffEksTilAfdeling2.AsString := mtLinAfdeling2.AsString;
        ffEksTilJournalNr1.AsString := mtLinJournalNr1.AsString;
        ffEksTilJournalNr2.AsString := mtLinJournalNr2.AsString;

        Res := 131;
        ffEksTil.Post;
      except
        on E: Exception do
        begin
          c2logadd('Error insert into eksplinietilskud ' + E.Message);
          try
            ffEksTil.Cancel;
          except
            on E: Exception do
              c2logadd('Error cancelling edit on Ekspliniertilskud ' + E.Message);
          end;
          raise;
        end;

      end;

    end;
  end;

  procedure tr_AddEkspLinierEtiket;
  var
    etk: TStringList;
  begin
    with MainDm do
    begin
      // Ekspeditionsetiketter gemmes
      etk := TStringList.Create;
      try
        try
          etk.Clear;
          etk.Text := mtlinEtkMemo.AsString;
          if etk.Count > 0 then
          begin
            if (ffEksKarKundeType.AsInteger in [pt_Dyrlaege, pt_Hobbydyr, pt_Landmand, pt_Andetapotek]) and (PraeparatnavnPaaEtiket)
            then
              AddVetVarenavnData(etk)
            else
              AddGeneriskeData(etk);
            try
              Res := 140;
              ffEksEtk.Insert;
              ffEksEtkLbNr.Value := ffEksKarLbNr.Value;
              ffEksEtkLinieNr.Value := Lin;
              ffEksEtkDosKode.AsString := mtLinDosering1.AsString;
              ffEksEtkDosKode1.AsString := mtLinDosering1.AsString;
              ffEksEtkDosKode2.AsString := mtLinDosering2.AsString;
              ffEksEtkIndikKode.AsString := mtLinIndikation.AsString;
              ffEksEtkTxtKode.AsString := mtLinFolgeTxt.AsString;
              ffEksEtkEtiket.Assign(etk);
              Res := 142;
              ffEksEtk.Post;
            except
              on E: Exception do
              begin
                c2logadd('Error insert into eksplinieretiket ' + E.Message);
                try
                  ffEksEtk.Cancel;
                except
                  on E: Exception do
                    c2logadd('Error cancelling edit on Eksplinieretiket ' + E.Message);
                end;
                raise;
              end;

            end;

          end;
        except
          Res := 141;
          raise;
        end;
      finally
        etk.Free;
      end;
    end;
  end;

  procedure tr_EditRecepturOplysninger;
  var
    save_index: string;
  begin
    with MainDm do
    begin
      try
        Res := 101;
        ffRcpOpl.First;
        AfslLbNr := ffRcpOplLbNr.Value;
        save_index := ffEksKar.IndexName;
        ffEksKar.IndexName := 'NrOrden';
        try
          ffEksKar.Last;
          if ffEksKarLbNr.AsInteger >= AfslLbNr then
            AfslLbNr := ffEksKarLbNr.AsInteger + 1;
        finally
          ffEksKar.IndexName := save_index;
        end;
        ffRcpOpl.Edit;
        if not PakkeNrSet then
          AfslPakkeNr := 0;
        ffRcpOplLbNr.Value := AfslLbNr + 1;
        // Opdater turnr
        ffRcpOplTurNr.Value := mtEksTurNr.Value;
        // Tildel pakkenr ved Bud=2 HK=5 Udlev=6 eller Udsalg=4 og pakkeseddel
        if mtEksPakkeNr.AsInteger = 0 then
        begin
          if Trim(mtEksDebitorNr.AsString) <> '' then
          begin
            if (MainDm.mtEksLeveringsForm.Value in [2, 5, 6]) or
              ((MainDm.mtEksLeveringsForm.Value = 4) and (ffRcpOplPakSedUdsalg.AsBoolean)) then
            begin
              if ffPatKarKundeType.Value <> pt_Haandkoebsudsalg then
              begin
                if not PakkeNrSet then
                begin
                  AfslPakkeNr := ffRcpOplPakkeNr.Value;
                  ffRcpOplPakkeNr.Value := ffRcpOplPakkeNr.Value + 1;
                end;
              end;
            end;
          end;
        end
        else
          AfslPakkeNr := mtEksPakkeNr.AsInteger;
        Res := 102;
        ffRcpOpl.Post;
      except
        on E: Exception do
        begin
          c2logadd('Error edit RecepturOplysninger ' + E.Message);
          try
            ffRcpOpl.Cancel;
          except
            on E: Exception do
              c2logadd('Error cancelling edit on RecepturOplysninger ' + E.Message);
          end;
          raise;
        end;
      end;

    end;
  end;

  procedure tr_EditRSEksplinier;
  begin
    with MainDm do
    begin
      Res := 1450;
      if nxRSEkspLin.IndexName <> '' then
        SaveRSline_index := nxRSEkspLin.IndexName;
      try
        nxRSEkspLin.IndexName := 'OrdIdOrden';

        if mtLinReceptId.AsInteger = 0 then
        begin
          if nxRSEkspLin.FindKey([Trim(mtLinOrdId.AsString)]) then
          begin
            try
              Res := 1451;
              nxRSEkspLin.Edit;
              IF nxRSEkspLinLbNr.AsInteger = 0 then
              begin
                nxRSEkspLinLbNr.AsInteger := ffEksLinLbNr.AsInteger;
                nxRSEkspLinLinieNr.AsInteger := ffEksLinLinieNr.AsInteger;
              end;
              nxRSEkspLinRSLbnr.AsInteger := ffEksLinLbNr.AsInteger;
              nxRSEkspLinRSLinienr.AsInteger := ffEksLinLinieNr.AsInteger;
              Res := 1452;
              nxRSEkspLin.Post;
            except
              on E: Exception do
              begin
                c2logadd('Error edit EditRSEksplinier ' + E.Message);
                try
                  nxRSEkspLin.Cancel;
                except
                  on E: Exception do
                    c2logadd('Error cancelling edit on RSEksplinier ' + E.Message);
                end;
                raise;
              end;
            end;
          end;
          exit;
        end;
        if nxRSEkspLin.FindKey([Trim(mtLinOrdId.AsString), mtLinReceptId.AsInteger]) then
        begin
          try
            Res := 1451;
            nxRSEkspLin.Edit;
            IF nxRSEkspLinLbNr.AsInteger = 0 then
            begin
              nxRSEkspLinLbNr.AsInteger := ffEksLinLbNr.AsInteger;
              nxRSEkspLinLinieNr.AsInteger := ffEksLinLinieNr.AsInteger;
            end;
            nxRSEkspLinRSLbnr.AsInteger := ffEksLinLbNr.AsInteger;
            nxRSEkspLinRSLinienr.AsInteger := ffEksLinLinieNr.AsInteger;
            Res := 1452;
            nxRSEkspLin.Post;
          except
            on E: Exception do
            begin
              c2logadd('Error edit EditRSEksplinier ' + E.Message);
              try
                nxRSEkspLin.Cancel;
              except
                on E: Exception do
                  c2logadd('Error cancelling edit on RSEksplinier ' + E.Message);
              end;
              raise;
            end;
          end;
        end;

      finally
        if SaveRSline_index <> '' then
          nxRSEkspLin.IndexName := SaveRSline_index;

      end;

    end;

  end;

  procedure tr_EditRSEkspeditioner;
  var
    save_RSIndex: string;
  begin
    with MainDm do
    begin
      // update the lbnr number in the recept server ekspedition set
      try
        save_RSIndex := nxRSEksp.IndexName;
        nxRSEksp.IndexName := 'ReceptIdOrder';
        try
          Res := 1031;
          if nxRSEksp.FindKey([mtLinReceptId.AsInteger]) then
          begin
            nxRSEksp.Edit;
            nxRSEkspLbNr.AsInteger := AfslLbNr;
            Res := 1041;
            nxRSEksp.Post;
          end;
        finally
          nxRSEksp.IndexName := save_RSIndex;
        end;
      except
        on E: Exception do
        begin
          c2logadd('Error Edit RSEkspeditioner ' + E.Message);
          try
            nxRSEksp.Cancel;
          except
            on E: Exception do
              c2logadd('Error cancelling edit on RSEkspeditioner ' + E.Message);
          end;
          raise;
        end;

      end;
    end;
  end;

  procedure tr_AddEkspeditioner;
  begin
    with MainDm do
    begin
      // Ekspedition gemmes
      try
        Res := 110;
        ffEksKar.Insert;
        ffEksKarLbNr.Value := AfslLbNr;
        ffEksKarTurNr.Value := mtEksTurNr.AsInteger;
        ffEksKarPakkeNr.Value := AfslPakkeNr;
        ffEksKarFakturaNr.Value := 0;
        ffEksKarUdlignNr.Value := 0;
        ffEksKarKundeNr.Value := mtEksKundeNr.Value;
        // ffEksKarLMSUdsteder.AsString      := mtEksYderNr.AsString;
        ffEksKarLMSModtager.AsString := ffPatKarLmsModtager.AsString;
        ffEksKarFiktivtCprNr.AsBoolean := ffPatKarFiktivtCprNr.Value;
        ffEksKarCprCheck.AsBoolean := ffPatKarCprCheck.AsBoolean;
        ffEksKarEjSubstitution.AsBoolean := ffPatKarEjSubstitution.AsBoolean;
        ffEksKarBarn.AsBoolean := ffPatKarBarn.AsBoolean;
        ffEksKarKundeKlub.AsBoolean := FALSE;
        ffEksKarKlubNr.AsInteger := 0;
        ffEksKarAmt.Value := ffPatKarAmt.Value;
        ffEksKarKommune.Value := ffPatKarKommune.Value;
        ffEksKarKundeType.Value := mtEksKundeType.Value;
        ffEksKarLandeKode.Value := ffPatKarLandeKode.Value;
        ffEksKarCtrType.Value := mtEksCtrType.Value;
        ffEksKarFoedDato.AsString := ffPatKarFoedDato.AsString;
        ffEksKarNarkoNr.AsString := mtEksNarkoNr.AsString;
        ffEksKarOrdreType.Value := mtEksOrdreType.Value;
        ffEksKarOrdreStatus.Value := mtEksOrdreStatus.Value;
        ffEksKarReceptStatus.Value := mtEksReceptStatus.Value;
        if ffEksKarReceptStatus.Value = 999 then
          ffEksKarReceptStatus.Value := 3;
        ffEksKarEkspType.Value := mtEksEkspType.Value;
        ffEksKarEkspForm.Value := mtEksEkspForm.Value;
        ffEksKarDosStyring.AsBoolean := FALSE;
        ffEksKarIndikStyring.AsBoolean := FALSE;
        ffEksKarAntLin.Value := mtEksAntLin.Value;
        ffEksKarAntVarer.Value := 0;
        ffEksKarDKMedlem.Value := 0;
        if ffEksKarKundeType.Value = pt_Enkeltperson then
          ffEksKarDKMedlem.Value := ffPatKarDKMedlem.Value;
        ffEksKarDKAnt.Value := 0;
        // ffEksKarReceptDato.AsDateTime     := Now;
        ffEksKarTakserDato.AsDateTime := ServerDateTime;
        if OrdreDato = 0 then
          OrdreDato := ffEksKarTakserDato.AsDateTime;
        ffEksKarOrdreDato.AsDateTime := OrdreDato; // CTR dato og tid
        // ffEksKarKontrolDato.AsDateTime    := ;
        ffEksKarForfaldsdato.AsDateTime := ffEksKarTakserDato.AsDateTime;
        // Hvis udligntype = 1 så er det forrige periode
        // da benyttes mtEksCtrUdlignDato til ordredato
        if mtEksCtrUdlignType.Value > 0 then
          ffEksKarOrdreDato.AsDateTime := mtEksCtrUdlignDato.AsDateTime;
        ffEksKarBrugerTakser.Value := BrugerNr;
        ffEksKarBrugerKontrol.Value := 0;
        ffEksKarBrugerAfslut.Value := 0;
        ffEksKarTitel.AsString := '';

        // use the kundenavn specified at the start of taksering

        ffEksKarNavn.AsString := mtEksKundeNavn.AsString;

        ffEksKarAdr1.AsString := ffPatKarAdr1.AsString;
        ffEksKarAdr2.AsString := ffPatKarAdr2.AsString;
        ffEksKarPostNr.AsString := ffPatKarPostNr.AsString;
        ffEksKarLand.AsString := '';
        ffEksKarKontakt.AsString := '';
        ffEksKarTlfNr.AsString := '';
        ffEksKarTlfNr2.AsString := '';
        ffEksKarYderNr.AsString := mtEksYderNr.AsString;
        ffEksKarYderCprNr.AsString := mtEksYderCprNr.AsString;
        ffEksKarYderNavn.AsString := mtEksYderNavn.AsString;
        if Trim(mtEksDebitorNr.AsString) <> '' then
        begin
          ffEksKarKontoNr.AsString := Trim(mtEksDebitorNr.AsString);
          ffEksKarKontoNavn.AsString := mtEksDebitorNavn.AsString;
          ffEksKarLeveringsForm.Value := mtEksLeveringsForm.Value;
          ffEksKarUdbrGebyr.AsCurrency := mtEksUdbrGebyr.AsCurrency;
          if StamForm.CF5Ordlist.Count <> 0 then
            ffEksKarUdbrGebyr.AsCurrency := 0;

        end
        else
        begin
          ffEksKarKontoNr.AsString := '';
          ffEksKarKontoNavn.AsString := '';
          ffEksKarLeveringsForm.Value := 0;
          ffEksKarUdbrGebyr.AsCurrency := 0;
        end;
        if Trim(mtEksLevNr.AsString) <> '' then
        begin
          ffEksKarLevNavn.AsString := Trim(mtEksLevNr.AsString);
        end
        else
        begin
          ffEksKarLevNavn.AsString := '';
        end;
        AfslLevForm := ffEksKarLeveringsForm.Value;
        AfslKontoNr := ffEksKarKontoNr.AsString;
        ffEksKarSprog.Value := 0;
        ffEksKarAfdeling.Value := mtEksAfdeling.Value;
        ffEksKarLager.Value := mtEksLager.Value;
        ffEksKarNettoPriser.AsBoolean := ffPatKarNettoPriser.AsBoolean;
        ffEksKarInclMoms.AsBoolean := True;
        (* BN change VAT begin - remove code
          ffEksKarMomsPct.AsCurrency := ffRcpOplMomsPct.AsCurrency;
          BN change VAT end *)
        (* BN change VAT begin - new code *)
        ffEksKarMomsPct.AsCurrency := MomsPercent;
        (* BN change VAT end *)
        ffEksKarRabatPct.AsCurrency := 0;
        ffEksKarCtrIndberettet.Value := 0;
        ffEksKarDKIndberettet.Value := 0;
        // Gebyrer
        ffEksKarTlfGebyr.AsCurrency := 0;
        ffEksKarEdbGebyr.AsCurrency := 0;

        (* 7.2.3.8 change VAT begin - move code to after line handling
          // Reitereret ? ingen gebyrer
          if ffEksKarReceptStatus.Value <> 1 then
          begin
          case ffEksKarEkspForm.Value of
          2:
          ffEksKarTlfGebyr.AsCurrency := ffRcpOplTlfGebyr.AsCurrency;
          3:
          ffEksKarEdbGebyr.AsCurrency := ffRcpOplEdbGebyr.AsCurrency;
          else
          end;
          end;
          7.2.3.8 change VAT end *)

        // Nulstil totaler

        ffEksKarCtrSaldo.AsCurrency := mtEksGlCtrSaldo.AsCurrency;
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
        ffEksKarReturdage.AsInteger := ReturDays;

        // Gennemløb alle ordinationer
        // Selvom der tælles hentes næste mtLin i slutning af loop

        CtrUpd := FALSE;
        PemUpd := FALSE;
        SaldoA := 0;
        SaldoB := 0;
        Lin := 0;
        mtLin.First;
        while not mtLin.Eof do
        begin
          inc(Lin);
          tr_AddEkspLinierSalg;
          tr_AddEkspLinierTilskud;
          tr_AddEkspLinierEtiket;
          // CTR
          if copy(mtLinDrugid.AsString, 1, 4) = CannabisPrefix then
          begin
            CtrUpd := True;
            SaldoB := ffEksTilSaldo.AsCurrency;
          end
          else
          begin
            if ffEksTilRegelSyg.Value in [41 .. 44] then
            begin
              CtrUpd := True;
              if ffEksTilRegelSyg.Value <> 44 then
                SaldoA := ffEksTilSaldo.AsCurrency;
            end;
          end;
          // PEM
          if not PemUpd then
          begin
            if (ffEksKarKundeType.AsInteger in [pt_Enkeltperson]) and
              (ffEksKarEkspType.AsInteger in [et_Recepter, et_Narkoleverance, et_Dosispakning, et_Infertilitet]) and
              (ffEksLinLinieType.AsInteger in [lt_Recept]) then
              PemUpd := True;
            // Recepttype=1=Recepter,6=Narkoleverance,7=Dosispakning,8 = Infertilitet
          end;
          // Beregn recepttotaler
          ffEksKarExMoms.AsCurrency := ffEksKarExMoms.AsCurrency + ffEksLinExMoms.AsCurrency;
          ffEksKarMoms.AsCurrency := ffEksKarMoms.AsCurrency + ffEksLinMoms.AsCurrency;
          ffEksKarTilskKom.AsCurrency := ffEksKarTilskKom.AsCurrency + ffEksTilTilskKom1.AsCurrency + ffEksTilTilskKom2.AsCurrency;
          ffEksKarTilskAmt.AsCurrency := ffEksKarTilskAmt.AsCurrency + ffEksTilTilskSyg.AsCurrency;
          ffEksKarAndel.AsCurrency := ffEksKarAndel.AsCurrency + ffEksTilAndel.AsCurrency;
          ffEksKarBrutto.AsCurrency := ffEksKarBrutto.AsCurrency + ffEksLinBrutto.AsCurrency;
          ffEksKarNetto.AsCurrency := ffEksKarNetto.AsCurrency + ffEksLinNetto.AsCurrency;
          ffEksKarDKTilsk.AsCurrency := ffEksKarDKTilsk.AsCurrency + mtLinDKTilsk.AsCurrency;
          ffEksKarDKEjTilsk.AsCurrency := ffEksKarDKEjTilsk.AsCurrency + mtLinDKEjTilsk.AsCurrency;

          // here we update the RS_eksplinier with the current lbnr and lininer
          if mtLinOrdId.AsString <> '' then
          begin
            RSEkspediton := True;
            tr_EditRSEksplinier;
            tr_EditRSEkspeditioner;
          end;

          // if its dmvs product then we need set returDage to the value in Winpacer (default 9)

          if mtLinDMVS.AsBoolean then
            ffEksKarReturdage.AsInteger := DMVSReturDays;

          if mtLinPoslistOverride.AsBoolean then
          begin
            ffEksKarVigtigBem.AsString := ffEksKarVigtigBem.AsString +
              Format('Linie %d Ej på positivliste, tilskud givet alligevel', [mtLinLinieNr.AsInteger]) + sLineBreak;
          end;

          // Hent næste ordination
          mtLin.Next;
        end;
        (* 7.2.3.8 change VAT begin *)
        // Reitereret ? ingen gebyrer
        if ffEksKarReceptStatus.Value <> 1 then
        begin
          case ffEksKarEkspForm.Value of
            2:
              if not ffEksKarInclMoms.AsBoolean then
                ffEksKarTlfGebyr.AsCurrency := TlfGebyrUdenMoms
              else
                ffEksKarTlfGebyr.AsCurrency := TlfGebyr;
            3:
              if not ffEksKarInclMoms.AsBoolean then
                ffEksKarEdbGebyr.AsCurrency := EdbGebyrUdenMoms
              else
                ffEksKarEdbGebyr.AsCurrency := EdbGebyr;
          else
          end;
        end;
        (* 7.2.3.8 change VAT end *)

        // update the antlin in ekspeditioner
        ffEksKarAntLin.AsInteger := Lin;
        Res := 111;
        ffEksKar.Post;
      except
        on E: Exception do
        begin
          c2logadd('Error edit Ekspeditioner ' + E.Message);
          try
            ffEksKar.Cancel;
          except
            on E: Exception do
              c2logadd('Error cancelling edit on Ekspeditioner ' + E.Message);
          end;
          raise;
        end;
      end;

    end;
  end;

  procedure tr_EditDosisCardHeader;
  begin
    with MainDm do
    begin
      SaveDCHIndex := ffdch.IndexName;
      ffdch.IndexName := 'CardNumber';
      try
        if ffdch.FindKey([mtEksDosKortNr.AsInteger]) then
        begin
          try
            ffdch.Edit;
            ffdchLbnr.AsInteger := ffEksKarLbNr.AsInteger;
            ffdch.Post;
          except
            on E: Exception do
            begin
              c2logadd('Error edit DosisCardHeader ' + E.Message);
              try
                ffdch.Cancel;
              except
                on E: Exception do
                  c2logadd('Error cancelling edit on DosisCardHeader ' + E.Message);
              end;
              raise;
            end;
          end;
        end;
      finally
        ffdch.IndexName := SaveDCHIndex;
      end;

    end;
  end;

  procedure tr_EditPatientkartotek;
  begin
    with MainDm do
    begin
      Res := 150;
      SavePatIndex := ffPatUpd.IndexName;
      ffPatUpd.IndexName := 'NrOrden';
      try
        if ffPatUpd.FindKey([ffPatKarKundeNr.AsString]) then
        begin
          try
            ffPatUpd.Edit;
            ffPatUpdCtrType.Value := mtEksCtrType.Value;
            ffPatUpdCtrStempel.AsDateTime := ffEksKarTakserDato.AsDateTime;
            if SaldoB <> 0 then
              ffPatUpdCtrSaldoB.AsCurrency := SaldoB;
            if SaldoA <> 0 then
              ffPatUpdCtrSaldo.AsCurrency := SaldoA;
            ffPatUpdCtrUdlign.AsCurrency := 0;
            ffPatUpdCtrStatus.Value := 2;
            Res := 151;
            ffPatUpd.Post;
          except
            on E: Exception do
            begin
              c2logadd('Error edit Patientkartotek ' + E.Message);
              try
                ffPatUpd.Cancel;
              except
                on E: Exception do
                  c2logadd('Error cancelling edit on Patientkartotek ' + E.Message);
              end;
              raise;
            end;
          end;
        end;
      finally
        ffPatUpd.IndexName := SavePatIndex;
      end;

    end;
  end;

  procedure tr_AddCTREfterReg;
  begin
    with MainDm do
    begin
      try
        Res := 160;
        ffCtrOpd.Insert;
        ffCtrOpdNr.AsInteger := ffEksKarLbNr.AsInteger;
        ffCtrOpdDato.AsDateTime := ffEksKarOrdreDato.AsDateTime;
        Res := 161;
        ffCtrOpd.Post;
      except
        on E: Exception do
        begin
          c2logadd('Error Add CTREfterReg ' + E.Message);
          try
            ffCtrOpd.Cancel;
          except
            on E: Exception do
              c2logadd('Error cancelling edit on CTREfterReg ' + E.Message);
          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_EditDebitorKartotek;
  begin
    with MainDm do
    begin
      savedebindex := ffDebKar.IndexName;
      ffDebKar.IndexName := 'NrOrden';
      try
        if ffDebKar.FindKey([ffEksKarKontoNr.AsString]) then
        begin
          try
            ffDebKar.Edit;
            ffDebKarLager.AsInteger := ffEksKarLager.AsInteger;
            ffDebKarAfdeling.AsInteger := ffEksKarAfdeling.AsInteger;
            ffDebKar.Post;
          except
            on E: Exception do
            begin
              c2logadd('Error Edit DebitorKartotek ' + E.Message);
              try
                ffDebKar.Cancel;
              except
                on E: Exception do
                  c2logadd('Error cancelling edit on DebitorKartotek ' + E.Message);
              end;
              raise;
            end;
          end;
        end;
      finally
        ffDebKar.IndexName := savedebindex;
      end;
    end;
  end;

begin
  with AfslutForm, MainDm do
  begin
    // Gem Ekspedition på nyt lbnr
    AfslKontoNr := '';
    AfslLevForm := 0;
    AfslLbNr := 0;
    AfslPakkeNr := 0;
    EHPakkenr := 0;
    Res := 100;
    Retries := 0;
    RSEkspediton := FALSE;
    Automatisk0Ekspedition := FALSE;
    try
      if (mtEksDebitorNr.AsString <> '') and (mtEksLevNr.AsString <> '') then
      begin
        if ffDebKar.FindKey([mtEksLevNr.AsString]) then
        begin
          if StamForm.NulPakkeTilBud then
          begin
            if ffDebKarLevForm.AsInteger in [2, 5, 6] then
              If not UseOldPakkeNr0Ekspedition then
              begin
                if (StamForm.TakserDosisKortAuto) and (DosisKortAutoExp) then
                  Automatisk0Ekspedition := True
                else
                  Automatisk0Ekspedition := ChkBoxYesNo('Ønskes 0-pakke til denne ekspedition på leveringsnummer ' +
                    mtEksLevNr.AsString, True);
              end;
          end
          else
          begin
            if ffDebKarLevForm.AsInteger in [5, 6] then
              If not UseOldPakkeNr0Ekspedition then
              begin
                if (StamForm.TakserDosisKortAuto) and (DosisKortAutoExp) then
                  Automatisk0Ekspedition := True
                else
                  Automatisk0Ekspedition := ChkBoxYesNo('Ønskes 0-pakke til denne ekspedition på leveringsnummer ' +
                    mtEksLevNr.AsString, True);
              end;
          end;

        end;
      end;
    except
      on E: Exception do
        ChkBoxOK(E.Message);
    end;

    (* hobro vilovet fix *)
    (* hobro vilovet fix *)
    (* hobro vilovet fix *)
    (* hobro vilovet fix *)
    (* hobro vilovet fix *)
    VetTotal := 0;
    if SameText(C2StrPrm('Hobro', 'Vilovet', 'Nej'), 'JA') then
    begin
      if (mtEksDebitorGrp.AsInteger in [10, 11, 12]) then
      begin
        c2logadd('Hobro Vilovet beregning start');
        // Indsæt linie
        mtLin.First;
        for Lin := 1 to mtEksAntLin.Value do
        begin
          if mtLinVareNr.AsString = '690000' then
          begin
            // Indsæt gebyr
            VetGebyr := NettoMoms(VetTotal, 0.835);
            mtLin.Edit;
            mtLinPris.AsCurrency := VetGebyr;
            mtLinBrutto.AsCurrency := VetGebyr;
            mtLinAndel.AsCurrency := VetGebyr;
            mtLin.Post;
            c2logadd('  Total ' + CurrToStr(VetTotal));
            c2logadd('  Gebyr ' + CurrToStr(VetGebyr));
          end
          else
          begin
            // Sammentæl VetGebyr
            VetTotal := VetTotal + mtLinAndel.AsCurrency;
          end;
          // Hent næste ordination
          mtLin.Next;
        end;
        c2logadd('Hobro Vilovet beregning slut');
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
        LemvigVet := FALSE;
        for i := 1 to 10 do
        begin
          if VetDebGruppe[i] = mtEksDebitorGrp.AsInteger then
            LemvigVet := True;
          if VetDebGruppe[i] = -1 then
            break;
        end;
        if LemvigVet then
        begin
          c2logadd('New Vet beregning start');
          // Indsæt linie
          mtLin.First;
          for Lin := 1 to mtEksAntLin.Value do
          begin
            if mtLinVareNr.AsString = VetGebyrNr then
            begin
              // Indsæt gebyr
              VetGebyr := NettoMoms(VetTotal, (mtEksDebProcent.AsCurrency));
              mtLin.Edit;
              mtLinPris.AsCurrency := VetGebyr;
              mtLinBrutto.AsCurrency := VetGebyr;
              mtLinAndel.AsCurrency := VetGebyr;
              mtLin.Post;
              c2logadd('  Total ' + CurrToStr(VetTotal));
              c2logadd('  Gebyr ' + CurrToStr(VetGebyr));
            end
            else
            begin
              // Sammentæl VetGebyr
              VetTotal := VetTotal + mtLinAndel.AsCurrency;
            end;
            // Hent næste ordination
            mtLin.Next;
          end;
          c2logadd('Hobro Vilovet beregning slut');

        end;
      end;

    end;

    PakkeNrSet := FALSE;
    if mtEksPakkeNr.AsInteger = 0 then
    begin
      if Trim(mtEksDebitorNr.AsString) <> '' then
      begin
        if (mtEksLeveringsForm.Value in [2, 5, 6]) or ((mtEksLeveringsForm.Value = 4) and (ffRcpOplPakSedUdsalg.AsBoolean)) then
        begin
          if (ffPatKarKundeType.Value <> pt_Haandkoebsudsalg) and (ffPatKarKundeType.Value <> pt_Hobbydyr) then
          begin
            // if StamForm.SidPakkeNr <= 0 then begin
            if UseOldPakkeNr then
            begin
              PakkeNrSet := True;
            end;
            // end;
          end;
        end;
      end;
    end;

    // get the current patient

    if not ffPatKar.FindKey([mtEksKundeNr.AsString]) then
    begin
      ChkBoxOK('Something has gone wrong patient does not exist');
      c2logadd('Something has gone wrong patient does not exist !' + mtEksKundeNr.AsString + '!');
      exit;
    end;

    repeat
      try
        // try 5 times to start the transaction
        for i := 1 to 5 do
        begin
          try

            // if its a dosis ekspedition then lock the dosisheader table as well
            if mtEksDosKortNr.AsInteger <> 0 then

              ffRcpOpl.DataBase.StartTransactionWith([ffCtrOpd, ffDebKar, ffdch, ffEksKar, ffEksEtk, ffEksLin, ffEksTil, nxLager,
                ffPatUpd, ffRcpOpl, nxRSEksp, nxRSEkspLin])
            else
              ffRcpOpl.DataBase.StartTransactionWith([ffCtrOpd, ffDebKar, ffEksKar, ffEksEtk, ffEksLin, ffEksTil, nxLager, ffPatUpd,
                ffRcpOpl, nxRSEksp, nxRSEkspLin]);

            break;
          except
            on E: Exception do
            begin
              if i = 5 then
                raise;
              VisTekst('Ekspedition gemmes på server - ' + i.ToString);
              Sleep(3000);

            end;

          end;
        end;

        try
          nxRemoteServerInfoPlugin1.GetServerDateTime(ServerDateTime);

          tr_EditRecepturOplysninger;

          tr_AddEkspeditioner;

          // put the lbnr in dosiscardheader. lbnr in dosiscardheader is the
          // latest ekspedition number for the dosiscard.
          if mtEksDosKortNr.AsInteger <> 0 then
          begin
            tr_EditDosisCardHeader;
          end;

          // Opdater patient
          if (CtrUpd) or (PemUpd) then
          begin
            if (CtrUpd) and ((SaldoA <> 0) or (SaldoB <> 0)) then
            begin
              tr_EditPatientkartotek;
            end;

            if SameText(C2StrPrm('Ctrserver', 'Opdatering', 'Receptur'), 'RECEPTUR') then
            begin
              tr_AddCTREfterReg;
            end;
          end;

          IF SameText(C2StrPrm('Debitor', 'SammeLagerOgAfdelingGemValg', 'NEJ'), 'JA') then
          begin
            tr_EditDebitorKartotek;
          end;
          EHPakkenr := AfslPakkeNr;
          if Automatisk0Ekspedition then
            Create0ekspedition(Res);

          //
          // Commit database
          c2logadd('  Commit data');
          ffRcpOpl.DataBase.Commit;
          Res := 0;
          c2logadd('  Committed');

        except
          on E: Exception do
          begin
            c2logadd('  Exception, err ' + IntToStr(Res));
            c2logadd('    Message "' + E.Message + '"');
            try
              ffRcpOpl.DataBase.Rollback;
            except
              on E: Exception do
              begin
                c2logadd('Error calling rollback ' + E.Message);
              end;

            end;
          end;

        end;

      finally
        // Fejl
        if Res = 0 then
        begin

          if (EHOrdre) and (AfslPakkeNr <> 0) and (cdsOrdHeader.RecordCount = 1) then
          begin
            if StamForm.SpoergEhandelKvittering then
            begin
              if frmYesNo.NewYesNoBox('Send kvittering til kunden?' + sLineBreak +
                'Hvis der vælges Nej, kan kvittering senere sendes manuelt.') then

                UpdateEHOrd(EHPakkenr);
            end
            else
              UpdateEHOrd(EHPakkenr);
          end;
          if (not StamForm.TakserDosisKortAuto) or (not DosisKortAutoExp) or (StamForm.DosisAutoEkspSpoergUdbringningsGebyr) then
          begin

            if StamForm.CF5Ordlist.Count = 0 then
            begin

              // need to refind the original created ekspedition
              c2logadd('about to check lbnr for udbr ' + IntToStr(AfslLbNr));
              try
                SaveEksIndex := SaveAndAdjustIndexName(ffEksKar, 'NrOrden');
                try
                  if ffEksKar.FindKey([AfslLbNr]) then
                  begin
                    gebyrKontonr := ffEksKarKontoNr.AsString;
                    if not ffEksKarLevNavn.AsString.IsEmpty then
                      gebyrKontonr := ffEksKarLevNavn.AsString;

                    if not gebyrKontonr.IsEmpty then
                    begin
                      if not ffDebKar.FindKey([gebyrKontonr]) then
                        ChkBoxOK(gebyrKontonr + ' konto findes ikke');

                    end;

                    // Evt. udbringningsgebyr
                    if ffEksKarUdbrGebyr.AsCurrency <> 0 then
                    begin
                      C2LogAddF('kontonr %s levform %d ', [ffDebKarKontoNr.AsString, ffDebKarLevForm.AsInteger]);
                      if not TfrmGebyr.VaelgGebyr(ffDebKarLevForm.AsInteger, udbGebyr) then
                      begin
                        try
                          ffEksKar.Edit;
                          ffEksKarUdbrGebyr.AsCurrency := 0;
                          ffEksKar.Post;
                        except
                          ffEksKar.Cancel;
                          ChkBoxOK('Kunne ikke fjerne udbringningsgebyr!');
                        end;
                      end
                      else
                      begin
                        try
                          GebyrUdenMoms := udbGebyr;
                          if GebyrUdenMoms <> 0 then
                            GebyrUdenMoms := GebyrUdenMoms - BruttoMoms(GebyrUdenMoms, MomsPercent);
                          ffEksKar.Edit;
                          if not ffEksKarInclMoms.AsBoolean then
                            ffEksKarUdbrGebyr.AsCurrency := GebyrUdenMoms
                          else
                            ffEksKarUdbrGebyr.AsCurrency := udbGebyr;
                          ffEksKar.Post;
                        except
                          ffEksKar.Cancel;
                          (* BN change VAT begin - spelling mistake *)
                          ChkBoxOK('Kunne ikke tilføje udbringningsgebyr!');
                          (* BN change VAT end *)
                        end;

                      end;
                    end;
                  end;
                finally
                  AdjustIndexName(ffEksKar, SaveEksIndex);
                end;
              except
                on E: Exception do
                  ChkBoxOK(E.Message);
              end;
            end;
          end;
        end
        else
        begin
          // Increment retries
          inc(Retries);
          // Vent tre sekunder hvis retry
          if Retries < 5 then
            Sleep(3000);
        end;
      end;
    until (Res = 0) or (Retries = 5);
    // Hvis fejl vis fejlkode
    if Res > 0 then
      ChkBoxOK('Fejl i opdater ekspedition, fejl ' + IntToStr(Res));
    // Returner true eller false
    Result := Res = 0;
    if Res = 0 then
    begin
      if ffEksKarEkspType.AsInteger <> et_Dosispakning then
        SendRowaOrdre;
    end;

  end;
end;

function GemReturnering(Lbnr: LongWord): Boolean;
var
  CTRSaldoA: Currency;
  CTRSaldoB: Currency;
  Nam: String;
  PemUpd, CtrUpd: Boolean;
  Res: Word;
  lineselected: Boolean;
  save_index: string;
  CheckGebyr: Boolean;
  ServerDateTime: TDateTime;
  BGPZero: Boolean;
  FoundCTRA: Boolean;
  FoundCTRB: Boolean;

  procedure tr_EditRecepturOplysninger;
  var
    save_index: string;
  begin
    with MainDm do
    begin
      try
        Res := 101;
        ffRcpOpl.First;
        AfslLbNr := ffRcpOplLbNr.Value;
        save_index := SaveAndAdjustIndexName(ffEksKar, 'NrOrden');
        try
          ffEksKar.Last;
          if ffEksKarLbNr.AsInteger >= AfslLbNr then
            AfslLbNr := ffEksKarLbNr.AsInteger + 1;
        finally
          AdjustIndexName(ffEksKar, save_index);
        end;
        ffRcpOpl.Edit;
        if not PakkeNrSet then
          AfslPakkeNr := 0;
        ffRcpOplLbNr.Value := AfslLbNr + 1;
        // Tildel pakkenr hvis der var pakkenr i forvejen
        if not PakkeNrSet then
        begin
          if Trim(ffRetEks.FieldByName('KontoNr').AsString) <> '' then
          begin
            if ffRetEks.FieldByName('PakkeNr').Value > 0 then
            begin
              AfslPakkeNr := ffRcpOplPakkeNr.Value;
              ffRcpOplPakkeNr.Value := ffRcpOplPakkeNr.Value + 1;
            end;
          end;
        end;
        Res := 102;
        ffRcpOpl.Post;
      except
        on E: Exception do
        begin
          c2logadd('Error in EditRecepturOplysninger ' + E.Message);
          try
            ffRcpOpl.Cancel;
          except
            on E: Exception do
              c2logadd('Error cancel edit in EditRecepturOplysninger ' + E.Message)

          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_InsertEkspLinierSalg(Lin: integer; Antal: integer);
  var
    Fld: TField;
  begin
    with MainDm do
    begin
      try
        Res := 120;
        ffEksLin.Insert;
        // Overfør alle felter fra ffLinOvr til ffEksLin
        for Fld in ffEksLin.Fields do
        begin
          Nam := Fld.FieldName;
          Fld.Value := ffRetLin.FieldByName(Nam).Value;
        end;
        // Ret nøglefelter m.m.
        ffEksLinLbNr.Value := AfslLbNr;
        ffEksLinLinieNr.Value := Lin;
        C2LogAddF('antal is %d original antal is %d', [Antal, ffEksLinAntal.AsInteger]);
        if Antal <> 0 then
        begin
          if ffEksLinAntal.AsInteger <> Antal then
          begin
            PartialCredit := True;
            c2logadd('Partial Credit is true ');
            ffEksLinVareForbrug.AsCurrency := ffEksLinKostPris.AsCurrency * Antal;
            ffEksLinBrutto.AsCurrency := ffEksLinPris.AsCurrency * Antal;
            ffEksLinExMoms.AsCurrency := (ffEksLinBrutto.AsCurrency * 100) / (ffEksLinMomsPct.AsCurrency + 100);
            ffEksLinExMoms.AsCurrency := RoundDecCurr(ffEksLinExMoms.AsCurrency);
            ffEksLinMoms.AsCurrency := ffEksLinBrutto.AsCurrency - ffEksLinExMoms.AsCurrency;
            ffEksLinNetto.AsCurrency := ffEksLinBrutto.AsCurrency;
          end;
          ffEksLinAntal.AsInteger := Antal;
        end;

        // PEM
        if not PemUpd then
        begin
          if (ffEksKarKundeType.AsInteger in [pt_Enkeltperson]) and
            (ffEksKarEkspType.AsInteger in [et_Recepter, et_Narkoleverance, et_Dosispakning, et_Infertilitet]) and
            (ffEksLinLinieType.AsInteger in [lt_Recept]) then
            PemUpd := True;
          // Recepttype=1=Recepter,6=Narkoleverance,7=Dosispakning,8=Infertilitet
        end;
        Res := 121;
        ffEksLin.Post;

      except
        on E: Exception do
        begin
          c2logadd('Error in tr_InsertEkspLinierSalg ' + E.Message);
          try
            ffEksLin.Cancel;
          except
            on E: Exception do
              c2logadd('Error cancel tr_InsertEkspLinierSalg ' + E.Message);
          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_InsertEkspeditionerCredit(Lin: integer; Antal: integer);
  begin
    with MainDm do
    begin
      try
        nxEksCred.Insert;
        nxEksCred.FieldByName('OldLbnr').AsInteger := Lbnr;
        nxEksCred.FieldByName('OldLin').AsInteger := Lin;
        nxEksCred.FieldByName('CreditLbnr').AsInteger := ffEksKarLbNr.AsInteger;
        nxEksCred.FieldByName('DelvisDato').AsDateTime := ServerDateTime;
        nxEksCred.FieldByName('DelvisAntal').AsInteger := Antal;
        nxEksCred.Post;
      except
        on E: Exception do
        begin
          c2logadd('Error in InsertEkspeditionerCredit ' + E.Message);
          try
            nxEksCred.Cancel;
          except
            on E: Exception do
              c2logadd('Error calling cancel in InsertEkspeditionerCredit ' + E.Message);
          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_InsertEkspLinierTilskud(Lin: integer; Antal: integer; OldAntal: integer);
  var
    Fld: TField;
  begin
    with MainDm do
    begin
      try
        Res := 130;
        ffEksTil.Insert;
        // Overfør alle felter fra ffTilOvr til ffEksTil
        for Fld in ffRetTil.Fields do
        begin
          Nam := Fld.FieldName;
          ffEksTil.FieldByName(Nam).Value := Fld.Value;
        end;
        // Ret nøglefelter m.m.
        ffEksTilLbNr.Value := AfslLbNr;
        ffEksTilLinieNr.Value := Lin;
        ffEksTilCtrIndberettet.Value := 0;
        // Ret CTR saldo
        if ffEksTilRegelSyg.Value in [41 .. 43] then
        begin
          CtrUpd := True;
          ffEksKarCtrSaldo.AsCurrency := ffEksTilSaldo.AsCurrency;
        end;
        if Antal <> 0 then
        begin

          if Antal <> OldAntal then
          begin
            ffEksTilIBPBel.AsCurrency := Oprund5Ore(ffEksTilIBPBel.AsCurrency * Antal / OldAntal);
            ffEksTilBGPBel.AsCurrency := Oprund5Ore(ffEksTilBGPBel.AsCurrency * Antal / OldAntal);
            ffEksTilIBTBel.AsCurrency := Oprund5Ore(ffEksTilIBTBel.AsCurrency * Antal / OldAntal);
            ffEksTilAndel.AsCurrency := Oprund5Ore(ffEksTilAndel.AsCurrency * Antal / OldAntal);
            ffEksTilTilskSyg.AsCurrency := Oprund5Ore(ffEksTilTilskSyg.AsCurrency * Antal / OldAntal);
            ffEksTilTilskKom1.AsCurrency := Oprund5Ore(ffEksTilTilskKom1.AsCurrency * Antal / OldAntal);
            ffEksTilTilskKom2.AsCurrency := Oprund5Ore(ffEksTilTilskKom2.AsCurrency * Antal / OldAntal);
          end;
        end;
        IF ffEksTilBGP.AsCurrency <> 0 then
          BGPZero := FALSE;

        Res := 131;
        ffEksTil.Post;

      except
        on E: Exception do
        begin
          c2logadd('Error in InsertEkspLinierTilskud ' + E.Message);
          try
            ffEksTil.Cancel
          except
            on E: Exception do
              c2logadd('Error calling cancel in InsertEkspLinierTilskud ' + E.Message);
          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_InsertEksplinierEtiket(Lin: integer);
  var
    Fld: TField;
  begin
    with MainDm do
    begin
      try
        // Ekspeditionsetiketter gemmes
        Res := 140;
        ffEksEtk.Insert;
        // Overfør alle felter fra ffTilOvr til ffEksTil
        for Fld in ffRetEtk.Fields do
        begin
          Nam := Fld.FieldName;
          ffEksEtk.FieldByName(Nam).Value := Fld.Value;
        end;
        // Ret nøglefelter m.m.
        ffEksEtkLbNr.Value := AfslLbNr;
        ffEksEtkLinieNr.Value := Lin;
        Res := 141;
        ffEksEtk.Post;
      except
        on E: Exception do
        begin
          c2logadd('Error in InsertEksplinierEtiket ' + E.Message);
          try
            ffEksEtk.Cancel;
          except
            on E: Exception do
            begin
              c2logadd('Error calling cancel in InsertEksplinierEtiket ' + E.Message);
            end;
          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_EditEkspLinierTilskud;
  begin
    with MainDm do
    begin
      try
        Res := 150;
        ffEksTil.Edit;
        if IsCannabisProduct(MainDm.nxdb, ffEksLinLager.AsInteger, ffEksLinSubVareNr.AsString, ffEksLinTekst.AsString,
          ffEksLinDrugId.AsString) then
        begin
          ffEksTilSaldo.AsCurrency := CTRSaldoB - ffEksTilBGPBel.AsCurrency;
          CTRSaldoB := ffEksTilSaldo.AsCurrency
        end
        else
        begin
          ffEksTilSaldo.AsCurrency := CTRSaldoA - ffEksTilBGPBel.AsCurrency;
          CTRSaldoA := ffEksTilSaldo.AsCurrency
        end;
        Res := 151;
        ffEksTil.Post;

      except
        on E: Exception do
        begin
          c2logadd('Error in EditEkspLinierTilskud ' + E.Message);
          try
            ffEksTil.Cancel
          except
            on E: Exception do
              c2logadd('Error calling cancel in EditEkspLinierTilskud ' + E.Message);
          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_EditPatientkartotek;
  var
    SavePatIndex: string;
  begin
    with MainDm do
    begin
      SavePatIndex := SaveAndAdjustIndexName(ffPatUpd, 'NrOrden');
      try
        if ffPatUpd.FindKey([ffPatKarKundeNr.AsString]) then
        begin
          try
            ffPatUpd.Edit;
            if FoundCTRA then
              ffPatUpdCtrSaldo.AsCurrency := CTRSaldoA;
            if FoundCTRB then
              ffPatUpdCtrSaldoB.AsCurrency := CTRSaldoB;
            ffPatUpd.Post;
          except
            on E: Exception do
            begin
              c2logadd('Error in EditPatientKartotek ' + E.Message);
              try
                ffPatUpd.Cancel;
              except
                on E: Exception do
                  c2logadd('Error calling cancel in EditPatientKartotek ' + E.Message);
              end;
              raise;
            end;
          end;
        end;
      finally
        AdjustIndexName(ffPatUpd, SavePatIndex);
      end;
    end;
  end;

  procedure tr_InsertCTREfterReg;
  begin
    with MainDm do
    begin
      try
        Res := 160;
        if SendToCTR then
        begin
          ffCtrOpd.Insert;
          ffCtrOpdNr.AsInteger := ffEksKarLbNr.AsInteger;
          ffCtrOpdTiNr.AsInteger := Lbnr;
          ffCtrOpdDato.AsDateTime := ffEksKarOrdreDato.AsDateTime;
          Res := 161;
          ffCtrOpd.Post;
        end;
      except
        on E: Exception do
        begin
          c2logadd('Error in tr_InsertCTREfterReg ' + E.Message);
          try
            ffCtrOpd.Cancel;
          except
            on E: Exception do
              c2logadd('Error calling cancel in tr_InsertCTREfterReg ' + E.Message);
          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_InsertEkspeditioner;
  var
    Fld: TField;
    Lin: integer;
    CreditAntal: integer;
    SavePatIndex: string;
    ll: TListItem;
  begin
    with MainDm do
    begin

      try
        // Ekspedition gemmes
        Res := 110;
        ffEksKar.Insert;
        // Overfør alle felter fra ffEksOvr til ffEksKar
        for Fld in ffEksKar.Fields do
        begin
          if Fld.FieldKind = fkData then
          begin
            Nam := Fld.FieldName;
            Fld.Value := ffRetEks.FieldByName(Nam).Value;
          end;
        end;
        if not frmRetLin.AllEkspLinier then
        begin
          // Nulstil totaler

          ffEksKarCtrSaldo.AsCurrency := 0; // todo
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

        end;
        // fejl 51 allow automatic bookkeeping possibility if original ekspedition
        // is closed
        if ffEksKarOrdreStatus.AsInteger = 2 then
        begin
          AfslKontoNr := ffEksKarKontoNr.AsString;
          AfslLevForm := ffEksKarLeveringsForm.Value;
        end;
        // Ret nøglefelter m.m.
        ffEksKarLbNr.Value := AfslLbNr;
        ffEksKarTurNr.Value := 0;
        ffEksKarPakkeNr.Value := AfslPakkeNr;
        ffEksKarOrdreNr.Value := 0;
        ffEksKarFakturaNr.Value := 0;
        ffEksKarUdlignNr.Value := Lbnr;
        ffEksKarOrdreType.Value := 2; // Retur
        if ffRetEks.FieldByName('Ordretype').AsInteger = 2 then
        begin
          ffEksKarOrdreType.Value := 1;
          ffEksKarUdlignNr.AsInteger := 0;
          ffEksKarOrdreDato.AsDateTime := ffRetEks.FieldByName('OrdreDato').AsDateTime;
        end;
        ffEksKarTakserDato.AsDateTime := ServerDateTime;
        ffEksKarAfsluttetDato.AsString := '';
        ffEksKarOrdreStatus.Value := 1; // Takseret
        ffEksKarReceptStatus.Value := 0; // Manuel
        ffEksKarBrugerTakser.Value := BrugerNr;
        ffEksKarBrugerKontrol.Value := 0;
        ffEksKarBrugerAfslut.Value := 0;
        ffEksKarCtrIndberettet.Value := 0;
        ffEksKarDKIndberettet.Value := 0;

        // Gennemløb alle ordinationer

        CtrUpd := FALSE;
        PemUpd := FALSE;

        // 1182 check to see if part of ekspedition has already been credited
        // if it has then set telefon,edb,udbr gebyr to 0
        CheckGebyr := FALSE;
        nxEksCred.IndexName := 'LbnrOrden';
        nxEksCred.SetRange([Lbnr], [Lbnr]);
        try
          if nxEksCred.RecordCount <> 0 then
          begin
            nxEksCred.First;
            while not nxEksCred.Eof do
            begin
              if nxEksp.FindKey([nxEksCred.FieldByName('CreditLbnr').AsInteger]) then
              begin
                if nxEkspEdbGebyr.AsCurrency <> 0 then
                  CheckGebyr := True;
                if nxEkspTlfGebyr.AsCurrency <> 0 then
                  CheckGebyr := True;
                if nxEkspUdbrGebyr.AsCurrency <> 0 then
                  CheckGebyr := True;
                if CheckGebyr then
                  break;
              end;
              nxEksCred.Next;
            end;
            if CheckGebyr then
            begin
              ffEksKarUdbrGebyr.AsCurrency := 0;
              ffEksKarTlfGebyr.AsCurrency := 0;
              ffEksKarEdbGebyr.AsCurrency := 0;
            end;
          end;
        finally
          nxEksCred.CancelRange;
        end;

        for Lin := 1 to ffRetEks.FieldByName('AntLin').Value do
        begin
          CreditAntal := 0;
          if ffRetLin.FindKey([Lbnr, Lin]) then
          begin
            if not frmRetLin.AllEkspLinier then
            begin
              lineselected := FALSE;
              for ll in frmRetLin.ListView1.Items do
              begin
                if ll.Checked then
                begin
                  if Lin = StrToInt(ll.Caption) then
                  begin
                    lineselected := True;
                    CreditAntal := StrToInt(ll.SubItems[2]);
                    tr_InsertEkspeditionerCredit(Lin, CreditAntal);
                    break;
                  end;
                end;
              end;
              if not lineselected then
                continue;
            end
            else
            begin
              tr_InsertEkspeditionerCredit(Lin, ffRetLin.FieldByName('Antal').AsInteger);
            end;

            // Ekspeditionslinier gemmes
            tr_InsertEkspLinierSalg(Lin, CreditAntal);
            if not frmRetLin.AllEkspLinier then
            begin // update total line
              ffEksKarExMoms.AsCurrency := ffEksKarExMoms.AsCurrency + ffEksLinExMoms.AsCurrency;
              ffEksKarMoms.AsCurrency := ffEksKarMoms.AsCurrency + ffEksLinMoms.AsCurrency;
              ffEksKarBrutto.AsCurrency := ffEksKarBrutto.AsCurrency + ffEksLinBrutto.AsCurrency;
              ffEksKarNetto.AsCurrency := ffEksKarNetto.AsCurrency + ffEksLinNetto.AsCurrency;
            end;

          end;

          if ffRetTil.FindKey([Lbnr, Lin]) then
          begin
            // Ekspeditionstilskud gemmes
            tr_InsertEkspLinierTilskud(Lin, CreditAntal, ffRetLin.FieldByName('Antal').AsInteger);

            if not frmRetLin.AllEkspLinier then
            begin // update total line
              ffEksKarTilskKom.AsCurrency := ffEksKarTilskKom.AsCurrency + ffEksTilTilskKom1.AsCurrency +
                ffEksTilTilskKom2.AsCurrency;
              ffEksKarTilskAmt.AsCurrency := ffEksKarTilskAmt.AsCurrency + ffEksTilTilskSyg.AsCurrency;
              ffEksKarAndel.AsCurrency := ffEksKarAndel.AsCurrency + ffEksTilAndel.AsCurrency;
              // todo
              if ffEksLinDKType.AsInteger = 1 then
                ffEksKarDKTilsk.AsCurrency := ffEksKarDKTilsk.AsCurrency + ffEksTilAndel.AsCurrency;
              if ffEksLinDKType.AsInteger = 2 then
                ffEksKarDKEjTilsk.AsCurrency := ffEksKarDKEjTilsk.AsCurrency + ffEksTilAndel.AsCurrency;
            end;

          end;

          if ffRetEtk.FindKey([Lbnr, Lin]) then
            tr_InsertEksplinierEtiket(Lin);
        end;

        // Reguler CTR

        // look backwards to get the final ctrsaldo values for CTR-A and CTR-B

        FoundCTRA := FALSE;
        FoundCTRB := FALSE;
        for Lin := ffEksKarAntLin.Value downto 1 do
        begin
          if not ffEksTil.FindKey([AfslLbNr, Lin]) then
            continue;

          if not ffEksTilRegelSyg.Value in [41 .. 43] then
            continue;

          if not ffEksLin.FindKey([AfslLbNr, Lin]) then
            continue;
          if IsCannabisProduct(MainDm.nxdb, ffEksLinLager.AsInteger, ffEksLinSubVareNr.AsString, ffEksLinTekst.AsString,
            ffEksLinDrugId.AsString) then
          begin
            if FoundCTRB then
              continue;
            FoundCTRB := True;

          end
          else
          begin
            if FoundCTRA then
              continue;
            FoundCTRA := True;

          end;

          if FoundCTRA and FoundCTRB then
            break;

        end;

        SavePatIndex := SaveAndAdjustIndexName(ffPatUpd, 'NrOrden');
        try
          if ffPatUpd.FindKey([ffEksKarKundeNr.AsString]) then
          begin
            CTRSaldoA := ffPatUpdCtrSaldo.AsCurrency;
            CTRSaldoB := ffPatUpdCtrSaldoB.AsCurrency;
            c2logadd('CTR-A start saldo is ' + CurrToStr(CTRSaldoA));
            c2logadd('CTR-B start saldo is ' + CurrToStr(CTRSaldoB));
            for Lin := 1 to ffEksKarAntLin.Value do
            begin
              if ffEksTil.FindKey([AfslLbNr, Lin]) then
              begin
                if ffEksLin.FindKey([AfslLbNr, Lin]) then
                begin
                  // Ret CTR saldo
                  if ffEksTilRegelSyg.Value in [41 .. 43] then
                  begin
                    tr_EditEkspLinierTilskud;
                  end;
                end;
              end;
            end;
            tr_EditPatientkartotek;
          end;
        finally
          AdjustIndexName(ffPatUpd, SavePatIndex);
        end;

        // Evt. PEM og CTR
        if (CtrUpd) or (PemUpd) then
        begin
          if SameText(C2StrPrm('Ctrserver', 'Opdatering', 'Receptur'), 'RECEPTUR') then
            tr_InsertCTREfterReg;
        end;

        Res := 111;
        if ffEksKarKundeType.AsInteger = pt_Enkeltperson then
          ReportReceptServer := True;

        // Afslut hvis ikke afsluttet
        if frmRetLin.AllEkspLinier then
        begin

          if ffRetEks.FieldByName('OrdreStatus').AsInteger = 1 then
          begin
            ffEksKarKontoNr.AsString := '';
            ffEksKarLeveringsForm.AsInteger := 0;
            ffEksKarTurNr.AsInteger := 0;
            ffEksKarPakkeNr.AsInteger := 0;
            ffEksKarLevNavn.AsString := '';
            AfslPakkeNr := 0;
            // fejl 1072   ffEksKarUdbrGebyr    .AsCurrency:= 0;
            ffEksKarOrdreStatus.AsInteger := 2; // Afsluttet
            // commented out next line because it made no sense
            // ffEksKarBrugerKontrol.AsInteger := ffEksKarBrugerTakser.AsInteger;
            ffEksKarBrugerAfslut.AsInteger := ffEksKarBrugerTakser.AsInteger;
            ffEksKarAfsluttetDato.AsDateTime := ffEksKarTakserDato.AsDateTime;
          end;
        end;
        Res := 112;
        ffEksKar.Post;

      except
        on E: Exception do
        begin
          c2logadd('Error in InsertEkspeditioner ' + E.Message);
          try
            ffEksKar.Cancel;
          except
            on E: Exception do
              c2logadd('Error calling cancel in InsertEkspeditioner ' + E.Message);
          end;

          raise;
        end;

      end;
    end;
  end;

  procedure tr_EditOldEkspeditioner;
  begin
    with MainDm do
    begin
      try
        Res := 113;
        ffRetEks.Edit;
        if frmRetLin.AllEkspLinier then
        begin
          ffRetEks.FieldByName('UdlignNr').AsInteger := AfslLbNr;
          // Afslut hvis ikke afsluttet
          if ffRetEks.FieldByName('OrdreStatus').AsInteger = 1 then
          begin
            ffRetEks.FieldByName('KontoNr').AsString := '';
            ffRetEks.FieldByName('LeveringsForm').AsInteger := 0;
            ffRetEks.FieldByName('TurNr').AsInteger := 0;
            ffRetEks.FieldByName('PakkeNr').AsInteger := 0;
            // fejl 1072 ffRetEks.FieldByName('UdbrGebyr'    ).AsCurrency:= 0;
            ffRetEks.FieldByName('OrdreStatus').AsInteger := 2; // Afsluttet
            ffRetEks.FieldByName('BrugerAfslut').AsInteger := ffEksKarBrugerTakser.AsInteger;
            ffRetEks.FieldByName('AfsluttetDato').AsDateTime := ffEksKarTakserDato.AsDateTime;
            ffRetEks.FieldByName('LevNavn').AsString := '';
            save_index := SaveAndAdjustIndexName(nxEkspLevListe, 'LbnrOrden');
            try
              if nxEkspLevListe.FindKey([ffRetEks.FieldByName('LbNr').AsInteger]) then
                nxEkspLevListe.Delete;
            finally
              AdjustIndexName(nxEkspLevListe, save_index);
            end;
          end;
          if ffEksKarOrdreType.AsInteger = 1 then
            ffRetEks.FieldByName('ReceptStatus').AsInteger := 4;
          // credit undone

        end;
        Res := 114;
        ffRetEks.Post;

      except
        on E: Exception do
        begin
          c2logadd('Error in EditOldEkspeditioner ' + E.Message);
          try
            ffRetEks.Cancel;
          except
            on E: Exception do
              c2logadd('Error calling cancel in EditOldEkspeditioner ' + E.Message);

          end;
          raise;
        end;
      end;
    end;
  end;

begin
  with MainDm do
  begin
    // Returner ekspedition
    PartialCredit := FALSE;
    AfslKontoNr := '';
    AfslLevForm := 0;
    AfslLbNr := 0;
    AfslPakkeNr := 0;
    Result := FALSE;
    BGPZero := True;
    if not ffRetEks.FindKey([Lbnr]) then
      exit;

    Res := 100;
    try
      PakkeNrSet := FALSE;
      if ffRetEks.FieldByName('PakkeNr').Value > 0 then
      begin
        if ReturUseOldPakkeNr then
        begin
          PakkeNrSet := True;
        end;
      end;

      ffRcpOpl.DataBase.StartTransactionWith([ffCtrOpd, ffEksKar, nxEksCred, ffEksEtk, ffEksLin, ffEksTil, ffPatUpd, ffRcpOpl]);
      try
        nxRemoteServerInfoPlugin1.GetServerDateTime(ServerDateTime);

        tr_EditRecepturOplysninger;

        tr_InsertEkspeditioner;

        tr_EditOldEkspeditioner;

        ffRcpOpl.DataBase.Commit;
        Res := 0;
      except
        on E: Exception do
        begin
          c2logadd('  Exception, err ' + IntToStr(Res));
          c2logadd('    Message "' + E.Message + '"');
          try
            ffRcpOpl.DataBase.Rollback;
          except
            on E: Exception do
              c2logadd('Fejl i rollback ' + E.Message);
          end;
        end;
      end;
    finally
      if Res = 0 then
      begin
        // Evt. udbringningsgebyr
        if (ffEksKarUdbrGebyr.AsCurrency <> 0) or (ffEksKarTlfGebyr.AsCurrency <> 0) or (ffEksKarEdbGebyr.AsCurrency <> 0) then
        begin
          if not ChkBoxYesNo('Skal telefongebyr/udbringningsgebyr tilbageføres?', True) then
          begin
            try
              ffEksKar.Edit;
              ffEksKarUdbrGebyr.AsCurrency := 0;
              ffEksKarTlfGebyr.AsCurrency := 0;
              ffEksKarEdbGebyr.AsCurrency := 0;
              ffEksKar.Post;
            except
              ffEksKar.Cancel;
              ChkBoxOK('Kunne ikke fjerne udbringningsgebyr!');
            end;
          end;
        end;
        if (CtrUpd) then
          ChkBoxOK('Denne tilbageførsel kan resultere i en udligning. Check derfor for dette.');
      end
      else
      begin
        if Res > 0 then
          ChkBoxOK('Fejl i returner ekspedition, fejl ' + IntToStr(Res));
      end;
      // Returner true eller false
      Result := Res = 0;
    end;
  end;
end;

procedure OpdaterLager;
var
  Txt: String;
  Cnt, Err: integer;
  function CheckLagerExists(ALager: integer): Boolean;
  begin
    Result := True;
    with MainDm do
    begin
      with nxdb.OpenQuery('select ' + fnLagerNavneRefNr + ' from ' + tnLagerNavne + ' where ' + fnLagerNavneRefNr_P, [ALager]) do
      begin
        try
          Result := not Eof;
        finally
          Free;
        end;

      end;

    end;
  end;

begin
  with AfslutForm, MainDm do
  begin
    // Opdater lager via WinAppServer
    if not ffEksKar.FindKey([AfslLbNr]) then
      exit;

    if not CheckLagerExists(ffEksKarLager.AsInteger) then
    begin
      ChkBoxOK('Lageret på returekspeditionen eksisterer ikke længere.' + #13#10 + 'Opdater derfor korrekt lager manuelt.');
      c2logadd('OpdaterLager: Lager does not exist');
      exit;
    end;

    // Afslut lager på recept
    MidClient.MsgAktiv := FALSE;
    Err := DBMSResRollback; // Start loop
    Cnt := 1;
    while (Err in [DBMSResRollback, AppResConnError]) and (Cnt < 6) do
    begin
      if Cnt > 1 then
        AfslutForm.VisTekst('Opdater lager på server ' + IntToStr(Cnt) + '. forsøg!')
      else
        AfslutForm.VisTekst('Opdater lager på server!');
      c2logadd('  Opdater lager forsøg ' + IntToStr(Cnt));
      Err := MidCli.OpdatLagerEksp(AfslLbNr);
      // Vent tre sekunder før nyt forsøg
      inc(Cnt);
      if (Err in [DBMSResRollback, AppResConnError]) and (Cnt < 6) then
        Sleep(3000);
    end;
    if Err = DBMSResOK then
      exit;

    case Err of
      002:
        Txt := 'Server svarer ikke eller er stoppet';
      005:
        Txt := 'Fejl i data ved kald til server';
      006:
        Txt := 'Fejl i forbindelse til server';
      007:
        Txt := 'Klient er optaget ved kald til server';
      008:
        Txt := 'Kommunikationsfejl ved kald til server';
      009:
        Txt := 'Exception ved kald til server';
      100:
        Txt := 'Kan ikke finde recept lbnr';
      108:
        Txt := 'Lager kan ikke opdateres';
      110:
        Txt := 'Opdatering afbrudt af server';
      111:
        Txt := 'Recepttype må ikke være dosis';
    else
      Txt := 'Opdater lager anden fejl, kode "' + IntToStr(Err) + '"';
    end;
    ChkBoxOK(Txt);
    c2logadd('  Opdater lager fejl "' + Txt + '"');
    C2Env.Log.AddLog('Opdater lager fejl' + Txt + ' lbnr ' + IntToStr(AfslLbNr), 130001, cC2LogPrioritetError);
  end;
end;

procedure UbiAfstempling;
var
  Andel: Currency;
  Lgd1, Lgd2,
  // Ant,
  Cnt: Word;
  DebNr, LevNr, ChrNr, Send, Edi, Sub1, Sub2, Wrk, Til, Nvn, ONr, LNr, Over: String;
  Lins: TStringList;
  Danm: String;
  Ialt: String;
  udbrtxt: string;
  DetailledAFSLabel: Boolean;
  SendDebNr: string;
  CStar: string;
  CredAntal: integer;
  etkAndel: Currency;
  etkUdlign: Currency;
  etkKom1: Currency;
  etkKom2: Currency;
  etkSyg: Currency;
  levform: integer;

  procedure GetCredTilskValues;
  var
    Credlbnr: integer;
  begin
    with MainDm do
    begin
      Credlbnr := nxEksCred.FieldByName('CreditLbnr').AsInteger;
      ffRetLin.SetRange([Credlbnr], [Credlbnr]);
      try
        if ffRetLin.RecordCount = 0 then
          exit;

        ffRetLin.First;
        while not ffRetLin.Eof do
        begin
          if ffRetLin.FieldByName('Varenr').AsString = ffEksLin.FieldByName('Varenr').AsString then
          begin
            if ffRetTil.FindKey([Credlbnr, ffRetLin.FieldByName('LinieNr').AsInteger]) then
            begin
              etkAndel := etkAndel + ffRetTil.FieldByName('Andel').AsCurrency;
              etkUdlign := etkUdlign + ffRetTil.FieldByName('Udligning').AsCurrency;
              etkKom1 := etkKom1 + ffRetTil.FieldByName('TilskKom1').AsCurrency;
              etkKom2 := etkKom2 + ffRetTil.FieldByName('TilskKom2').AsCurrency;
              etkSyg := etkSyg + ffRetTil.FieldByName('TilskSyg').AsCurrency;
            end;
            break;
          end;
          ffRetLin.Next;
        end;

      finally
        ffRetLin.CancelRange;
      end;
    end;

  end;

begin
  with MainDm do
  begin
    DetailledAFSLabel := pos('Detail0', fmUbi.AfsEtkLst.Text) <> 0;
    Lins := TStringList.Create;
    try
      if not ffEksKar.FindKey([AfslLbNr]) then
        exit;

      Andel := 0;
      // Ant  := 0;
      Send := '   ';
      if ffEksKarLeveringsForm.AsInteger > 0 then
        Send := LevForm2Str(ffEksKarLeveringsForm.AsInteger);
      SendDebNr := '';
      if ffEksKarLeveringsForm.AsInteger in [4, 5, 6] then
        SendDebNr := ffEksKarKontoNr.AsString;
      Edi := '   ';
      if ffEksKarEkspForm.AsInteger = 3 then
        Edi := 'Edi';
      for Cnt := 1 to ffEksKarAntLin.Value do
      begin
        CredAntal := 0;
        etkAndel := 0;
        etkUdlign := 0;
        etkKom1 := 0;
        etkKom2 := 0;
        etkSyg := 0;
        if not ffEksLin.FindKey([AfslLbNr, Cnt]) then
          continue;
        if not ffEksTil.FindKey([AfslLbNr, Cnt]) then
          continue;
        if not StamForm.PrintAllAFSLabel then
        begin
          try
            nxEksCred.IndexName := 'LbnrOrden';
            nxEksCred.SetRange([AfslLbNr, Cnt], [AfslLbNr, Cnt]);
            try
              if nxEksCred.RecordCount <> 0 then
              begin
                nxEksCred.First;
                while not nxEksCred.Eof do
                begin
                  CredAntal := CredAntal + nxEksCred.FieldByName('DelvisAntal').AsInteger;
                  GetCredTilskValues;
                  nxEksCred.Next;
                end;
                if (CredAntal = 0) or (CredAntal = ffEksLinAntal.AsInteger) then
                  continue;

              end;

            finally
              nxEksCred.CancelRange;
            end;
          except
          end;

        end;
        // Inc (Ant);
        ONr := Trim(ffEksLinVareNr.AsString);
        LNr := Trim(ffEksLinSubVareNr.AsString);
        if ONr <> '' then
        begin
          if ffLagKar.FindKey([ffEksKarLager.AsInteger, ONr]) then
          begin
            c2logadd('point at the right product anyway');
            c2logadd('start cstar check');
            CStar := '';
            if (ffLagKarSalgsPris.AsCurrency = ffLagKarBGP.AsCurrency) and
              ((ffLagKarSubKode.AsString = 'C') or (ffLagKarSubKode.AsString = 'B')) and
              ((ffLagKarSSKode.AsString = 'A') or (ffLagKarSSKode.AsString = 'R') or (ffLagKarSSKode.AsString = 'S') or
              (ffLagKarSSKode.AsString = 'V')) then
              CStar := '*';
            c2logadd('end of cstar check ' + CStar);
          end;
        end;
        if ONr <> LNr then
        begin
          // Vis ordineret præparat
          if (ONr <> '') and (LNr <> '') then
          begin
            Sub1 := '';
            Sub2 := '';
            if ffLagKar.FindKey([ffEksKarLager.AsInteger, ONr]) then
              Sub1 := StringReplace(ffLagKarNavn.AsString, '"','',[rfReplaceAll] );
            if ffLagKar.FindKey([ffEksKarLager.AsInteger, LNr]) then
              Sub2 := StringReplace(ffLagKarNavn.AsString, '"','',[rfReplaceAll] );
            c2logadd('varenr and subvarenr diferent');
            c2logadd('start cstar check');
            CStar := '';
            if (ffLagKarSalgsPris.AsCurrency = ffLagKarBGP.AsCurrency) and
              ((ffLagKarSubKode.AsString = 'C') or (ffLagKarSubKode.AsString = 'B')) and
              ((ffLagKarSSKode.AsString = 'A') or (ffLagKarSSKode.AsString = 'A') or (ffLagKarSSKode.AsString = 'S') or
              (ffLagKarSSKode.AsString = 'V')) then
              CStar := '*';
            c2logadd('END Of cstar check ' + CStar);
            Lgd1 := Length(Sub1);
            Lgd2 := Length(Sub2);
            while Lgd1 + Lgd2 > 35 do
            begin
              if Lgd1 > Lgd2 then
              begin
                Delete(Sub1, Lgd1, 1);
                Lgd1 := Length(Sub1);
              end
              else
              begin
                Delete(Sub2, Lgd2, 1);
                Lgd2 := Length(Sub2);
              end;
            end;
            Lins.Add('ORD=' + Sub1 + ' SUB=' + Sub2);
            // Inc      (Ant);
          end;
        end;
        // Evt. subst. præparat
        if DetailledAFSLabel then
          Nvn := Format('%6.6s %3.3s/%5.5s', [copy(ffEksLinTekst.AsString, 1, 6), copy(ffEksLinPakning.AsString, 1, 3),
            copy(ffEksLinStyrke.AsString, 1, 5)])
        else
        begin
          Nvn := copy(ffEksLinPakning.AsString, 1, 3);
          Nvn := copy(ffEksLinTekst.AsString, 1, 6 - Length(Nvn)) + Nvn;
          if Length(Nvn) < 6 then
            Nvn := Nvn + Spaces(6 - Length(Nvn));

        end;
        Wrk := IntToStr(ffEksLinAntal.Value - CredAntal);
        if Length(Wrk) < 3 then
          Wrk := Spaces(3 - Length(Wrk)) + Wrk;
        etkAndel := ffEksTilAndel.AsCurrency - etkAndel;
        etkUdlign := ffEksTilUdligning.AsCurrency - etkUdlign;
        etkKom1 := ffEksTilTilskKom1.AsCurrency - etkKom1;
        etkKom2 := ffEksTilTilskKom2.AsCurrency - etkKom2;
        etkSyg := ffEksTilTilskSyg.AsCurrency - etkSyg;
        if ffEksTilRegelSyg.AsInteger = 44 then
        begin
          if ffEksKarOrdreType.Value = 1 then
          begin
            Til := FormCurr2Str('####0.00', -etkAndel) + FormCurr2Str('####0.00', 0) + FormCurr2Str('####0.00', etkAndel);
          end
          else
          begin
            Til := FormCurr2Str('####0.00', etkAndel) + FormCurr2Str('####0.00', 0) + FormCurr2Str('####0.00', -etkAndel);
          end;
          Til := FormCurr2Str('####0.00', etkUdlign) + FormCurr2Str('####0.00', etkKom1 + etkKom2) +
            FormCurr2Str('####0.00', etkAndel);
        end
        else
        begin
          if ffEksTilIBPBel.AsCurrency = 0 then
          begin
            if etkSyg = 0 then
              Til := '        '
            else
              Til := FormCurr2Str('####0.00', etkSyg);

            if (etkKom1 + etkKom2) = 0 then
              Til := Til + '        ' + FormCurr2Str('####0.00', etkAndel)
            else
              Til := Til + FormCurr2Str('####0.00', etkKom1 + etkKom2) + FormCurr2Str('####0.00', etkAndel);

          end
          else
          begin
            Til := FormCurr2Str('####0.00', etkSyg) + FormCurr2Str('####0.00', etkKom1 + etkKom2) +
              FormCurr2Str('####0.00', etkAndel);
          end;

        end;
        // if ffEksLinUdlevNr.Value < ffEksLinUdlevMax.Value then begin
        if (ffEksLinUdlevNr.AsInteger = 1) and (ffEksLinUdlevNr.AsInteger >= ffEksLinUdlevMax.AsInteger) then
          Til := Til + ' A '
        else
        begin
          IF DetailledAFSLabel then
          begin
            if ffEksLinUdlevNr.Value < 10 then
              Til := Til + '  ' + IntToStr(ffEksLinUdlevNr.Value)
            else
              Til := Til + ' ' + IntToStr(ffEksLinUdlevNr.Value);

            Til := Til + '/' + IntToStr(ffEksLinUdlevMax.Value);
          end
          else
          begin
            if ffEksLinUdlevNr.AsInteger >= ffEksLinUdlevMax.AsInteger then
              Til := Til + ' A '
            else if ffEksLinUdlevNr.Value < 10 then
              Til := Til + '  ' + IntToStr(ffEksLinUdlevNr.Value)
            else
              Til := Til + ' ' + IntToStr(ffEksLinUdlevNr.Value);
          end;
        end;
        Til := Til + ' ' + ffLagKarSubKode.AsString;

        if CStar <> '' then
          Til := Til + CStar;
        // end else
        c2logadd('add cstar to end of etiket line ' + CStar);
        Lins.Add(LNr + ' ' + Nvn + Wrk + Til);
        Andel := Andel + etkAndel;
      end;
      (* UDBR/EDB/TELEFONGEBYR *)
      if ffEksKarTlfGebyr.AsCurrency <> 0 then
      begin
        // Inc (Ant);
        Andel := Andel + ffEksKarTlfGebyr.AsCurrency;
        if DetailledAFSLabel then
          Til := Format('%-42s', ['Tlf-gebyr']) + FormCurr2Str('####0.00', ffEksKarTlfGebyr.AsCurrency)
        else
          Til := Format('%-32s', ['Tlf-gebyr']) + FormCurr2Str('####0.00', ffEksKarTlfGebyr.AsCurrency);
        Lins.Add(Til);
      end;
      if ffEksKarEdbGebyr.AsCurrency <> 0 then
      begin
        // Inc (Ant);
        Andel := Andel + ffEksKarEdbGebyr.AsCurrency;
        if DetailledAFSLabel then
          Til := Format('%-42s', ['EDB-gebyr']) + FormCurr2Str('####0.00', ffEksKarEdbGebyr.AsCurrency)
        else
          Til := Format('%-32s', ['EDB-gebyr']) + FormCurr2Str('####0.00', ffEksKarEdbGebyr.AsCurrency);
        Lins.Add(Til);
      end;

      // nwe code to get the correct levform
      levform := 0;
      if ffEksKarKontoNr.AsString <> '' then
      begin
        if ffDebKar.FindKey([ffEksKarKontoNr.AsString]) then
          levform := ffDebKarLevForm.AsInteger;
      end;
      if ffEksKarLevNavn.AsString <> '' then
      begin
        if ffDebKar.FindKey([ffEksKarLevNavn.AsString]) then
          levform := ffDebKarLevForm.AsInteger;
      end;

      if ffEksKarUdbrGebyr.AsCurrency <> 0 then
      begin
        // if line is including moms the the use moms included properties else use uden moms properties
        if ffEksLinInclMoms.AsBoolean then
        begin
          udbrtxt := 'UDBR.GEBYR';
          if (ffEksKarUdbrGebyr.AsCurrency = HKGebyr) and (levform in [5, 6]) then
            udbrtxt := 'UDLEVERINGSGEBYR'
          else
          begin

            if ffEksKarUdbrGebyr.AsCurrency = PlejehjemsGebyr then
              udbrtxt := 'UDBR. TIL INSTITUTION';
          end;
        end
        else
        begin
          udbrtxt := 'UDBR.GEBYR';
          if (ffEksKarUdbrGebyr.AsCurrency = HKGebyrUdenMoms) and (levform in [5, 6]) then
            udbrtxt := 'UDLEVERINGSGEBYR'
          else
          begin

            if ffEksKarUdbrGebyr.AsCurrency = PlejehjemsGebyrUdenMoms then
              udbrtxt := 'UDBR. TIL INSTITUTION';
          end;
        end;
        // Inc (Ant);
        Andel := Andel + ffEksKarUdbrGebyr.AsCurrency;
        if DetailledAFSLabel then
          Til := Format('%-42s', [udbrtxt]) + FormCurr2Str('####0.00', ffEksKarUdbrGebyr.AsCurrency)
        else
          Til := Format('%-32s', [udbrtxt]) + FormCurr2Str('####0.00', ffEksKarUdbrGebyr.AsCurrency);
        Lins.Add(Til);
      end;

      if ffEksKarOrdreType.Value = 2 then
      begin
        if Andel = 0 then
          Ialt := 'KR.    -0,00'
        else
          Ialt := 'KR.' + FormCurr2Str('#####0.00', -Andel);
      end
      else
        Ialt := 'KR.' + FormCurr2Str('#####0.00', Andel);
      if ffEksKarDKMedlem.Value = 1 then
        Danm := 'danmark'
      else
        Danm := '';
      if DetailledAFSLabel then
      begin
        Over := 'PRÆPARAT               ANT  AMT=' + IntToStr(ffEksKarAmt.Value) + ' KOM=' + IntToStr(ffEksKarKommune.Value) +
          ' PATIENT UDL';
      end
      else
      begin
        Over := 'PRÆPARAT     ANT  AMT=' + IntToStr(ffEksKarAmt.Value) + ' KOM=' + IntToStr(ffEksKarKommune.Value) + ' PATIENT UDL';
      end;
      Lins.Insert(0, Over);
      DebNr := Spaces(10);
      LevNr := Spaces(10);
      ChrNr := Spaces(6);
      if Trim(ffEksKarKontoNr.AsString) <> '' then
        DebNr := AddSpaces(Trim(ffEksKarKontoNr.AsString), 10);
      if Trim(ffEksKarLevNavn.AsString) <> '' then
        LevNr := AddSpaces(Trim(ffEksKarLevNavn.AsString), 10);
      if ffEksKarKundeType.AsInteger = pt_Landmand then
      begin
        ffPatKar.IndexName := 'NrOrden';

        if ffPatKar.FindKey([ffEksKarKundeNr.AsString]) then
          ChrNr := copy(ffPatKarLmsModtager.AsString, 5, 6);
      end;
      c2logadd('*** Chrnr is ' + ChrNr + ' karkundenr is ' + ffEksKarKundeNr.AsString);
      if not StamForm.Undladafstemplingsetiketter then
      begin

        if not CloseCSF6 then
        begin

          fmUbi.PrintDosAfst(ffFirmaSupNavn.AsString, FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
            ffEksKarLbNr.AsString, DebNr, LevNr, ChrNr, Lins, Edi, Send, Danm, Ialt, SendDebNr);
          if CloseCF6 then
            fmUbi.PrintDosAfst(ffFirmaSupNavn.AsString, FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
              ffEksKarLbNr.AsString, DebNr, LevNr, ChrNr, Lins, Edi, Send, Danm, Ialt, SendDebNr);
        end;
      end;
      {
        if Feed then
        UbiPrinterForm.UbiFeed;
      }
      // Bakkeetiket til hylden
      if caps(C2StrPrm(MainDm.C2UserName, 'RecepthyldeEtiket', '')) = 'JA' then
      begin
        if ffEksKarKontoNr.AsString = '' then
        begin
          fmUbi.PrintHyldeEtik(ffFirmaSupNavn.AsString, FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
            ffEksKarLbNr.AsString, ffEksKarNavn.AsString, ffEksKarAdr1.AsString, ffEksKarAdr2.AsString,
            ffEksKarPostNr.AsString + ' ' + ffEksKarBy.AsString, '', LevNr, '', ffEksKarKundeNr.AsString, 1, True);
        end;
      end;

      if caps(C2StrPrm(MainDm.C2UserName, 'RecepthyldeEtiketApoteksudsalg', '')) <> 'JA' then
        exit;

      if ffEksKarKontoNr.AsString <> '' then
      begin
        if ffDebKar.FindKey([ffEksKarKontoNr.AsString]) then
        begin
          if ffDebKarLevForm.AsInteger = 4 then
          begin // udsalg !!!!
            fmUbi.PrintHyldeEtik(ffFirmaSupNavn.AsString, FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
              ffEksKarLbNr.AsString, ffEksKarNavn.AsString, ffEksKarAdr1.AsString, ffEksKarAdr2.AsString,
              ffEksKarPostNr.AsString + ' ' + ffEksKarBy.AsString, '', LevNr, '', ffEksKarKundeNr.AsString, 1, True);
            exit;
          end;
        end;
      end;
      // 800 i guess this is what it means !
      if ffEksKarLevNavn.AsString <> '' then
      begin
        if ffDebKar.FindKey([ffEksKarLevNavn.AsString]) then
        begin
          if ffDebKarLevForm.AsInteger = 4 then
          begin // udsalg !!!!
            fmUbi.PrintHyldeEtik(ffFirmaSupNavn.AsString, FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
              ffEksKarLbNr.AsString, ffEksKarNavn.AsString, ffEksKarAdr1.AsString, ffEksKarAdr2.AsString,
              ffEksKarPostNr.AsString + ' ' + ffEksKarBy.AsString, '', LevNr, '', ffEksKarKundeNr.AsString, 1, True);
            exit;
          end;
        end;
      end;

    finally
      Lins.Free;
    end;
  end;
end;

procedure UbiEtiketter;
var
  Prs1, Prs2: Currency;
  etk: TStringList;
  Ok: Boolean;
  XPos, Ant, Cnt: integer;
  Max: integer;
  Lok1, Lok2, DebNr, LevNr, ChrNr, Edi, Send, Nvn, Pkn, Sql, Atc: String;
  NumEnh: integer;
  NumOrg: integer;
  CStar: string;
begin
  with MainDm do
  begin
    if not ffEksKar.FindKey([AfslLbNr]) then
      exit;

    if StamForm.Undladafstemplingsetiketter then
      exit;
    try
      Send := '   ';
      if ffEksKarLeveringsForm.AsInteger > 0 then
        Send := LevForm2Str(ffEksKarLeveringsForm.AsInteger);
      Edi := '   ';
      if ffEksKarEkspForm.AsInteger = 3 then
        Edi := 'Edi';
      for Cnt := 1 to ffEksKarAntLin.Value do
      begin
        if not ffEksLin.FindKey([AfslLbNr, Cnt]) then
          continue;
        if not ffEksEtk.FindKey([AfslLbNr, Cnt]) then
          continue;
        c2logadd('Etiket nr ' + IntToStr(ffEksEtkLinieNr.AsInteger));
        c2logadd(ffEksEtkEtiket.AsString);
        Ok := True;
        if Recepturplads = 'AUTO' then
        begin
          // spørg om dyr
          Max := ffEksLinAntal.Value;
        end
        else if Recepturplads = 'DYR' then
        begin
          // spørg om dyr
          Max := ffEksLinAntal.Value;
          Ok := TastHeltal('Etiketter for ' + ffEksLinTekst.AsString, Max);
          if Max < 1 then
            Ok := FALSE;
        end
        else
        begin
          // Der skal være antal pakninger
          if ffEksLinAntal.Value > 0 then
          begin
            Max := ffEksLinAntal.Value;
            if caps(C2StrPrm(MainDm.C2UserName, 'Klinikpakninger', '')) = 'JA' then
            begin
              Atc := copy(ffEksLinATCKode.AsString, 1, 4);
              if (Atc <> 'G03A') and (ffEksLinATCKode.AsString <> 'G03FB05') then
              begin
                Pkn := Trim(ffEksLinPakning.AsString);
                XPos := pos('x', Pkn);
                if XPos = 0 then
                  XPos := pos('X', Pkn);
                if XPos > 0 then
                begin
                  try
                    Ant := StrToInt(copy(Pkn, 1, XPos - 2));
                  except
                    Ant := 1;
                  end;
                  if Ant > 0 then
                    Max := Ant * ffEksLinAntal.Value + 1;
                  Ok := TastHeltal('Godkend antal etiketter', Max);
                end;
              end
              else
              begin
                if Max > 10 then
                  Ok := TastHeltal('Godkend antal etiketter', Max);
              end;
            end
            else
            begin
              if Max > 10 then
                Ok := TastHeltal('Godkend antal etiketter', Max);
            end;
          end;
        end;
        // Udskriv
        if not Ok then
          continue;
        etk := TStringList.Create;
        try
          etk.Assign(ffEksEtkEtiket);
          // Kun receptlinier Evt. hvis der blev ønsket etiketter
          if etk.Count = 0 then
            continue;
          // Lokationer
          Lok1 := Trim(ffEksLinLokation1.AsString);
          Lok2 := Trim(ffEksLinLokation2.AsString);
          // Atc
          Atc := ffEksLinATCKode.AsString;
          XPos := C2IntPrm(MainDm.C2UserName, 'AtcLokation', 0);
          if XPos > 0 then
            Atc := Trim(copy(Atc, 1, XPos));
          // Forsendelse
          DebNr := Spaces(10);
          LevNr := Spaces(10);
          ChrNr := Spaces(6);
          if Trim(ffEksKarKontoNr.AsString) <> '' then
            DebNr := AddSpaces(Trim(ffEksKarKontoNr.AsString), 10);
          if Trim(ffEksKarLevNavn.AsString) <> '' then
            LevNr := AddSpaces(Trim(ffEksKarLevNavn.AsString), 10);
          if ffEksKarKundeType.AsInteger = pt_Landmand then
          begin
            ffPatKar.IndexName := 'NrOrden';

            if ffPatKar.FindKey([ffEksKarKundeNr.AsString]) then
              ChrNr := copy(ffPatKarLmsModtager.AsString, 5, 6);
          end;
          c2logadd('*** Chrnr is ' + ChrNr + ' karkundenr is ' + ffEksKarKundeNr.AsString);
          // Print
          try
            ffLagKar.IndexName := 'NrOrden';

            if ffLagKar.FindKey([ffEksLinLager.AsInteger, ffEksLinSubVareNr.AsString]) then
            begin

              if ffLagKarDelPakUdskAnt.AsInteger <> 0 then
                Max := Max * ffLagKarDelPakUdskAnt.AsInteger;
            end;
          except
          end;
          fmUbi.PrintDosEtik(ffFirmaSupNavn.AsString, FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
            ffEksKarLbNr.AsString, etk, Edi, Send, ffEksLinSubVareNr.AsString, Atc, Lok1, Lok2, DebNr, LevNr, ChrNr, Max,
            Cnt = ffEksKarAntLin.Value, True);
          // Substitutions etiket til kunden
          if C2StrPrm(MainDm.C2UserName, 'SubstitutionsEtiket', '') = 'Ja' then
          begin
            if ffEksLinVareNr.AsString <> ffEksLinSubVareNr.AsString then
            begin
              Prs1 := 0;
              Prs2 := 0;
              etk.Clear;
              NumOrg := 0;
              NumEnh := 0;
              if ffLagKar.FindKey([ffEksKarLager.AsInteger, ffEksLinSubVareNr.AsString]) then
              begin
                Prs2 := ffEksLinAntal.AsInteger * ffLagKarSalgsPris.AsCurrency;
                NumEnh := ffEksLinAntal.AsInteger * ffLagKarPaknNum.AsInteger;
              end;
              etk.Add('LÆGEN HAR ORDINERET:');
              if ffLagKar.FindKey([ffEksKarLager.AsInteger, ffEksLinVareNr.AsString]) then
              begin
                if ffLagKarPaknNum.AsInteger <> 0 then
                  NumOrg := NumEnh div ffLagKarPaknNum.AsInteger;
                if NumOrg = 0 then
                  NumOrg := 1;
                Prs1 := NumOrg * ffLagKarSalgsPris.AsCurrency;
                Nvn := ffLagKarNavn.AsString;
                if ffLagKarPAKode.AsString <> '' then
                  Nvn := Nvn + '/' + ffLagKarPAKode.AsString;
                etk.Add(' ' + Strip4Char('"', Nvn));
              end;
              etk.Add('APOTEKET HAR UDLEVERET:');
              if ffLagKar.FindKey([ffEksKarLager.AsInteger, ffEksLinSubVareNr.AsString]) then
              begin
                Prs2 := ffEksLinAntal.AsInteger * ffLagKarSalgsPris.AsCurrency;
                Nvn := ffLagKarNavn.AsString;
                if ffLagKarPAKode.AsString <> '' then
                  Nvn := Nvn + '/' + ffLagKarPAKode.AsString;

                // add the qauantity of the substituted product if greater than 1

                if ffEksLinAntal.AsInteger > 1 then
                  Nvn := Nvn + ' ' + ffEksLinAntal.AsString + ' Pakn';
                etk.Add(' ' + Strip4Char('"', Nvn));

              end;
              Prs2 := Prs1 - Prs2;
              if Prs2 > 0 then
                etk.Add('DER SPARES KR. ' + FormatCurr('#####0.00', Prs2));
              fmUbi.PrintDosEtik(ffFirmaSupNavn.AsString, FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
                ffEksKarLbNr.AsString, etk, '', '', '', '', '', '', '', '', '', 1, Cnt = ffEksKarAntLin.Value, FALSE);
            end;
          end;
          if ffEksLinEjS.AsInteger = 0 then
          begin
            if C2StrPrm(MainDm.C2UserName, 'SubstitutionsEtiketOmvendt', '') = 'Ja' then
            begin
              try
                if ffLagKar.FindKey([ffEksKarLager.AsInteger, ffEksLinSubVareNr.AsString]) then
                begin
                  if (ffLagKarSubKode.AsString = 'B') or (ffLagKarSubKode.AsString = 'C') then
                  begin
                    // Change 782
                    c2logadd(' c product in omvendt etiket, check for cstar');
                    CStar := '';
                    if (ffLagKarSalgsPris.AsCurrency = ffLagKarBGP.AsCurrency) and
                      ((ffLagKarSSKode.AsString = 'A') or (ffLagKarSSKode.AsString = 'R') or (ffLagKarSSKode.AsString = 'S') or
                      (ffLagKarSSKode.AsString = 'V')) then
                      CStar := '*';
                    c2logadd('after cstar ' + CStar);
                    if CStar = '' then
                    begin
                      etk.Clear;
                      etk.Add('Lovpligtig information');
                      c2logadd('ABOUT TO PRINT THE NEW SUBST LABEL');
                      fqSqlSel.Close;
                      Sql := sl_Sql_subst_label.Text;
                      fqSqlSel.Sql.Clear;
                      fqSqlSel.Sql.Text := Sql;
                      fqSqlSel.ParamByName('lager').AsString := ffEksKarLager.AsString;
                      fqSqlSel.ParamByName('Varenr').AsString := ffEksLinSubVareNr.AsString;
                      fqSqlSel.Filtered := FALSE;
                      fqSqlSel.Filter := '';
                      fqSqlSel.Open;
                      c2logadd('record count is ' + IntToStr(fqSqlSel.RecordCount));
                      if fqSqlSel.RecordCount > 0 then
                      begin

                        // fqSqlSel.Filter := 'Antal>0';
                        // fqSqlSel.Filtered := True;
                        // if fqSqlSel.RecordCount = 0 then
                        // fqSqlSel.Filtered := False;
                        fqSqlSel.First;
                        etk.Add('Ekspederet vare');
                        Prs1 := ffEksLinAntal.AsInteger * ffEksLinPris.AsCurrency;
                        Nvn := ffEksLinTekst.AsString;
                        etk.Add(' ' + Strip4Char('"', Nvn) + ' ' + CStar);
                        c2logadd('added cstar ' + CStar);
                        etk.Add('Billigere Vare');
                        Prs2 := ffEksLinAntal.AsInteger * fqSqlSel.FieldByName('Salgspris').AsCurrency;
                        Nvn := fqSqlSel.FieldByName('Navn').AsString;
                        etk.Add(' ' + Strip4Char('"', Nvn));
                        Prs2 := Prs1 - Prs2;

                        if ffEksTil.FindKey([AfslLbNr, Cnt]) then
                          if ffEksTilRegelSyg.AsInteger in [42, 43] then
                            Prs2 := 0;

                        if Prs2 > 0 then
                          etk.Add('PRISFORSKEL KR. ' + FormatCurr('#####0.00', Prs2) + ' ANT ' +
                            fqSqlSel.FieldByName('Antal').AsString)
                        else
                          etk.Add('PRISFORSKEL KR. ' + FormatCurr('#####0.00', Prs2) + '(PAKNSTR) ANT ' +
                            fqSqlSel.FieldByName('Antal').AsString);

                        fmUbi.PrintDosEtik(ffFirmaSupNavn.AsString, FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
                          ffEksKarLbNr.AsString, etk, '', '', '', '', '', '', '', '', '', 1, Cnt = ffEksKarAntLin.Value, FALSE);
                      end;
                      fqSqlSel.Close;
                    end;
                  end;
                end;
              except
                on E: Exception do
                  Application.MessageBox(pchar(E.Message), 'erm');
              end;
            end;
          end
          else
          begin
            c2logadd('Ejsubst was not zero so dont print omvendt label');
          end;
          // now we shall print the substitution label for lms32
          if C2StrPrm(MainDm.C2UserName, 'SubstitutionsLMS32', '') = 'Ja' then
          begin
            try
              if ffEksLinVareNr.AsString <> ffEksLinSubVareNr.AsString then
                continue;
              if ffLagKar.FindKey([ffEksKarLager.AsInteger, ffEksLinSubVareNr.AsString]) then
              begin

                etk.Clear;
                c2logadd('about to print lms32 label');
                nxKombi.Close;
                nxKombi.Sql.Clear;
                Sql := sl_Sql_lms32_label.Text;
                nxKombi.Sql.Text := Sql;
                c2logadd(Sql);
                nxKombi.ParamByName('lager').AsInteger := ffEksKarLager.AsInteger;
                c2logadd(ffEksKarLager.AsString);
                nxKombi.ParamByName('Varenr').AsString := ffEksLinVareNr.AsString;
                c2logadd(ffEksLinVareNr.AsString);
                nxKombi.ParamByName('Drugid').AsString := ffLagKarDrugId.AsString;
                c2logadd(ffLagKarDrugId.AsString);
                nxKombi.Open;
                if nxKombi.RecordCount > 0 then
                begin
                  etk.Add('Ekspederet vare');
                  Nvn := ffEksLinTekst.AsString;
                  etk.Add(' ' + Strip4Char('"', Nvn));
                  etk.Add('Flere mindre pakninger');
                  etk.Add('er billigere');
                  fmUbi.PrintDosEtik(ffFirmaSupNavn.AsString, FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
                    ffEksKarLbNr.AsString, etk, '', '', '', '', '', '', '', '', '', 1, Cnt = ffEksKarAntLin.Value, True);

                end;
                nxKombi.Close;
              end;
            except
              on E: Exception do
                Application.MessageBox(pchar(E.Message), 'erm');
            end;
          end;

        finally
          etk.Free;
        end;
      end;
    finally
    end;
  end;
end;

procedure PrivatFaktura(KontoNr: String);
var
  FakturaNr: LongWord;
  Txt: String;
  Cnt, Err: integer;
  save_index: string;
begin
  with dmFormularer, MainDm do
  begin
    AfslutForm.VisTekst('Check privatfaktura!');
    if (StamForm.TakserDosisKortAuto) and (DosisKortAutoExp) then
    begin
    end
    else
    begin
      StamForm.CheckMoreOpenRCP(True);
      if not ChkBoxYesNo('Bogfør/udskriv privatfaktura til konto ' + KontoNr + '?', True) then
        exit;
    end;
    FakturaNr := 0;
    // Afslut faktura
    MidClient.MsgAktiv := FALSE;
    Err := DBMSResRollback; // Start loop
    Cnt := 1;
    while (Err = DBMSResRollback) and (Cnt < 6) do
    begin
      if Cnt > 1 then
        AfslutForm.VisTekst('Bogfør faktura på server ' + IntToStr(Cnt) + '. forsøg!')
      else
        AfslutForm.VisTekst('Bogfør faktura på server!');
      c2logadd('  Bogfør konto "' + KontoNr + '" forsøg ' + IntToStr(Cnt));
      Err := MidClient.AfslutFakt(KontoNr, BrugerNr, 0, FakturaNr);
      // Vent tre sekunder før nyt forsøg
      inc(Cnt);
      if (Err = DBMSResRollback) and (Cnt < 6) then
        Sleep(3000);
    end;
    if Err <> DBMSResOK then
    begin
      case Err of
        002:
          Txt := 'Server svarer ikke eller er stoppet';
        005:
          Txt := 'Fejl i data ved kald til server';
        006:
          Txt := 'Fejl i forbindelse til server';
        007:
          Txt := 'Klient er optaget ved kald til server';
        008:
          Txt := 'Kommunikationsfejl ved kald til server';
        009:
          Txt := 'Exception ved kald til server';
        100:
          Txt := 'Kan ikke finde debitor kontonr';
        104:
          Txt := 'Ingen recepter at bogføre';
        106:
          Txt := 'Forkert leveringsform på debitor kontonr';
        108:
          Txt := 'Faktura kan ikke bogføres';
        110:
          Txt := 'Bogføring afbrudt af server';
      else
        Txt := 'Bogfør konto anden fejl, kode "' + IntToStr(Err) + '"';
      end;
      ChkBoxOK(Txt + ', check evt. log');
      c2logadd('  Bogfør konto fejl "' + Txt + '"');
      exit;
    end;
    // Udskriv faktura
    if FakturaNr <= 0 then
      exit;

    // moved before the print to allow danxmlfaktura to set fields used in the print

    c2logadd('about to check whether we should send xml faktura for konto ' + KontoNr);
    save_index := ffDebKar.IndexName;
    ffDebKar.IndexName := 'NrOrden';
    try
      if not ffDebKar.FindKey([KontoNr]) then
        exit;
      c2logadd('ok we found the entry in debitorkartotek eankode is ' + ffDebKarEFaktEanKode.AsString);
      if CheckNumerisk(ffDebKarEFaktEanKode.AsString) = 13 then
      begin
        c2logadd('valid ean code so we will send the fatkura using DanXMLFaktura');
        if not StamForm.SpoergSendFakturaElektronisk then
          C2ExecuteCS('G:\DanXMLFaktura.exe ' + KontoNr + ' 0 ' + IntToStr(FakturaNr), SW_SHOWNORMAL, 3)
        else if (StamForm.TakserDosisKortAuto) and (DosisKortAutoExp) then
        begin
          C2ExecuteCS('G:\DanXMLFaktura.exe ' + KontoNr + ' 0 ' + IntToStr(FakturaNr), SW_SHOWNORMAL, 3);
        end
        else
        begin
          if ChkBoxYesNo('Send faktura elektronisk?', True) then
          begin
            C2ExecuteCS('G:\DanXMLFaktura.exe ' + KontoNr + ' 0 ' + IntToStr(FakturaNr), SW_SHOWNORMAL, 3);
          end;
        end;

      end;

    finally
      ffDebKar.IndexName := save_index;
    end;

    AfslutForm.VisTekst('Udskriv privatfaktura!');
    c2logadd('  Fakturanr ' + IntToStr(FakturaNr) + ' udskrives');
    if (FaktPrivPrn <> '') or (FaktInstPrn <> '') or (FaktLevPrn <> '') or (FaktPakkePrn <> '') then
      TfmFakturaLaser.UdskrivFaktLaser(FakturaNr, FakturaNr);

  end;
end;

procedure Forsendelse;
begin
  with dmFormularer, MainDm do
  begin
    c2logadd('Top of forsendelse');
    if AfslPakkeNr > 0 then
    begin
      AfslutForm.VisTekst('Check pakkeseddel!');
      // Udskriv pakkeseddel
      try
        if (StamForm.TakserDosisKortAuto) and (DosisKortAutoExp) then
        begin
          if PakkeSedPrn <> '' then
            TfmPakkeLaser.UdskrivPakkeseddelLaser(AfslPakkeNr);
        end
        else
        begin
          if StamForm.QuestionAskedAboutOpenRCP then
          begin
            AfslutForm.VisTekst('Udskriv pakkeseddel!');
            // Nulstil sidste pakkenr
            // StamForm.SidPakkeNr:= 0;
            // Udskriv
            if PakkeSedPrn <> '' then
              TfmPakkeLaser.UdskrivPakkeseddelLaser(AfslPakkeNr);
          end
          else
          begin
            if ChkBoxYesNo('Udskriv pakkenr ' + IntToStr(AfslPakkeNr) + ' ?', True) then
            begin
              AfslutForm.VisTekst('Udskriv pakkeseddel!');
              // Nulstil sidste pakkenr
              // StamForm.SidPakkeNr:= 0;
              // Udskriv
              if PakkeSedPrn <> '' then
                TfmPakkeLaser.UdskrivPakkeseddelLaser(AfslPakkeNr);
            end;
          end;
        end;
      except
      end;
    end;
    if AfslLevForm = 1 then
    begin
      // Udskriv faktura privat
      if StamForm.CF5Ordlist.Count = 0 then
        PrivatFaktura(AfslKontoNr);
      (*
        try
        OpdaterFraTilKonto (AfslKontoNr, AfslKontoNr);
        except
        end;
      *)
    end;
    c2logadd('Bottom of forsendelse');
  end;
end;

procedure AfslutEkspedition;
begin
  StamForm.PrintAllAFSLabel := True;
  AfslutForm := TAfslutForm.Create(NIL);
  try
    AfslutForm.Show;
    AfslutForm.VisTekst('Ekspedition gemmes på server!');
    AfslutForm.Animate.Active := True;
    try
      if GemEkspedition(OrdreDato) then
      begin
        // AfslutForm.VisTekst ('Opdater apotekets lager !');
        c2logadd('Before OpdaterLager');
        { TODO : Opdater lager commented out }
        OpdaterLager;
        c2logadd('Before check if batch started');
        if StamForm.BatchStarted then
          StamForm.addLbnrtobatch(AfslLbNr);
        if Human then
        begin
          // fmUbi.PrinterLockOpen;
          try
            if (not CloseSF6) then
            begin
              AfslutForm.VisTekst('Doseringsetiketter udskrives !');
              c2logadd('Before ubietiketter');
              UbiEtiketter;
              c2logadd('After ubietiketter');
            end;
            // lc          if C2StrPrm(C2SysUserName, 'Recepturplads', '') <> 'Dyr' then begin
            if not assigned(fmUbi.AfsEtkLst) then
              exit;

            AfslutForm.VisTekst('Afstemplingsetiket udskrives !');

            c2logadd('before ubiafstempling');
            UbiAfstempling(CloseCF6, CloseCSF6);
            c2logadd('after ubiafstempling');
            // lc         end;

            if StamForm.Kronikerekstrabetaling then
              UbiKronikerLabel;

          finally
            fmUbi.PrintTotalEtiket;
            // fmUbi.PrinterLockClose;
          end;
        end
        else
        begin
          { TODO : leverancer etiketter }
          if MainDm.UdskrivLeverenceEtiketter and (not CloseSF6) then
          begin
            UbiAfstempling(CloseCF6, CloseCSF6);
            UbiEtiketter;
            fmUbi.PrintTotalEtiket;
          end;

        end;

        // AfslutForm.VisTekst ('Opdater/udskriv forsendelse !');
        c2logadd('Before setting asked about open rcp');
        StamForm.QuestionAskedAboutOpenRCP := FALSE;
        if (MainDm.mtEksDebitorNr.AsString <> '') and (MainDm.mtEksLeveringsForm.AsInteger in [2, 5, 6]) then
        begin
          c2logadd('before ask about open rcp');
          if (StamForm.TakserDosisKortAuto) and (MainDm.DosisKortAutoExp) then
          begin
            Forsendelse
          end
          else
          begin
            if StamForm.AskAboutOpenRCP(AfslPakkeNr) then
              Forsendelse;
          end;
        end
        else
          Forsendelse;
      end;
    except
      on E: Exception do
      begin
        c2logadd('Exception during gemekspedition ' + E.Message);
      end;

    end;
    AfslutForm.Animate.Active := FALSE;
    AfslutForm.Hide;
  finally
    AfslutForm.Free;
    AfslutForm := NIL;
  end;
end;

procedure AfslutReturnering(Lbnr: LongWord);
var
  save_index: string;

  function ContinueWithDMVSOldBon: Boolean;
  var
    nxq: TnxQuery;
    Bonnr: integer;
    BonDato: TDateTime;
  begin

    Result := FALSE;
    nxq := TnxQuery.Create(Nil);
    try
      nxq.DataBase := MainDm.nxdb;

      // first get the bonnr (if any)
      Bonnr := 0;
      BonDato := Now;
      nxq.Sql.Add('select e.Bonnr,k.dato from ekspeditionerbon as e');
      nxq.Sql.Add('inner join kasseekspeditioner as k on k.bonnr=e.bonnr and k.kassenr=e.kassenr');
      nxq.Sql.Add('where e.lbnr=:ilbnr');
      nxq.ParamByName('ilbnr').AsInteger := Lbnr;
      nxq.Open;
      if not nxq.Eof then
      begin
        Bonnr := nxq.FieldByName('Bonnr').AsInteger;
        BonDato := nxq.FieldByName('Dato').AsDateTime;

      end;
      nxq.Close;

      nxq.Sql.Clear;
      nxq.Sql.Add('select lin.lbnr,lin.linienr,lin.subvarenr,lin.antal,lin.lager,lag.tekst from ekspliniersalg as lin');
      nxq.Sql.Add('inner join lagerkartotek as lag on lag.lager=0 and lag.varenr=lin.subvarenr');
      nxq.Sql.Add('where lin.lbnr= :ilbnr');
      nxq.Sql.Add('and lag.dmvs<>0');
      c2logadd(nxq.Sql.Text);
      nxq.ParamByName('ilbnr').AsInteger := Lbnr;
      nxq.Open;

      // if there are no dmvs products get out and result is true
      if nxq.Eof then
      begin
        Result := True;
        exit;
      end;

      // if we get here then there is a dmvs product. now we check if there is an entry in
      // eksplinierserienumre that would be created if they scanned the 2d barcode

      nxq.Close;
      nxq.Sql.Clear;
      nxq.Sql.Add('select ' + fnEkspLinierSerienumreProduktKode + ' from ' + tnEkspLinierSerienumre);
      nxq.Sql.Add(' where lbnr= :ilbnr');
      c2logadd(nxq.Sql.Text);
      nxq.ParamByName('ilbnr').AsInteger := Lbnr;
      nxq.Open;

      if nxq.Eof then
      begin
        Result := True;
        exit;
      end;




      // if we get here then check the bon dato to see if more than 10 days old

      if (BonDato < Now - 10) and (Bonnr <> 0) then
      begin
        Result := ChkBoxYesNo('Varen er udleveret for mere end 10 dage siden og kan ikke reaktiveres i DMVS.' + 'Fortsæt?', FALSE)
      end
      else
        Result := True; // not too old or not on a bon

    finally
      nxq.Free;
    end;
  end;

begin
  StamForm.PrintAllAFSLabel := True;
  SendToCTR := True;
  AfslutForm := TAfslutForm.Create(NIL);
  try

    // check if there is  a dmvs product on the ekspedition
    // if there is then check the date of the bon.
    // if it is not accepted to continue with the retur then get outlllll
    if not ContinueWithDMVSOldBon then
      exit;

    save_index := MainDm.ffEksOvr.IndexName;
    MainDm.ffEksOvr.IndexName := 'NrOrden';
    if not MainDm.ffEksOvr.FindKey([Lbnr]) then
      exit;

    if (MainDm.ffEksOvrOrdreType.AsInteger = 2) then
      frmRetLin.AllEkspLinier := True
    else IF frmRetLin.ShowModal = mrCancel then
      exit;

    if MainDm.ffEksOvrOrdreType.AsInteger = 2 then
      SendToCTR := True;
    AfslutForm.Show;
    AfslutForm.VisTekst('Ekspedition gemmes på server!');
    try
      AfslutForm.Animate.Active := True;
      ReportReceptServer := FALSE;
      { TODO : dmvs checks here friday am }
      if not GemReturnering(Lbnr) then
        exit;

      AfslutForm.VisTekst('Opdater apotekets lager !');
      OpdaterLager;
      if (StamForm.BatchStarted) and (MainDm.ffRetEks.FieldByName('OrdreStatus').AsInteger <> 1) then
        StamForm.addLbnrtobatch(AfslLbNr);

      c2logadd('Before call to reportcancelled rcp');
      if (ReportReceptServer)
      // and (maindm.ffEksKarOrdreStatus.AsInteger = 2)
      then
      begin
        // if MainDm.ffEksKarOrdreType.Value = 1 then
        ReportCancelledRCP(MainDm.ffEksKarLbNr.Value);
        // else
        // ReportCancelledRCP(Lbnr);
      end;

      // update DMVS if required
      // if MainDm.ffEksOvrBrugerKontrol.AsInteger <> 0 then
      // begin
      try
        UpdateDMVS(frmRetLin.AllEkspLinier, MainDm.ffEksKarBrugerTakser.AsInteger, Lbnr, MainDm.ffEksKarLbNr.AsInteger,
          MainDm.ffEksKarAfdeling.AsInteger);
      except
        on E: Exception do
          c2logadd('Exception thrown in UpdateDMVS ' + E.Message);
      end;
      // end;

      // rs fejl      if not PartialCredit then
      // CheckDeletedLines;
      if ChkBoxYesNo('Ønskes afstempling ?', True) then
      begin
        // fmUbi.PrinterLockOpen;
        try
          AfslutForm.VisTekst('Afstemplingsetiket udskrives !');
          if MainDm.Recepturplads <> 'DYR' then
            UbiAfstempling(FALSE, FALSE);
        finally
          fmUbi.PrintTotalEtiket;
          // fmUbi.PrinterLockClose;
        end;
      end;

      if MainDm.EscapePressedInDMVS then
      begin
        c2logadd('Returekspedition er foretaget.' + #13#10 + 'Bemærk at ikke alle varer er genaktiveret i DMVS');
        ChkBoxOK('Returekspedition er foretaget.' + #13#10 + 'Bemærk at ikke alle varer er genaktiveret i DMVS');
      end;
      StamForm.QuestionAskedAboutOpenRCP := FALSE;
      // AfslutForm.VisTekst ('Opdater/udskriv forsendelse !');
      Forsendelse;
    finally
      AfslutForm.Animate.Active := FALSE;
      AfslutForm.Hide;
    end;
  finally
    MainDm.ffEksOvr.IndexName := save_index;
    AfslutForm.Free;
  end;
end;

procedure TAfslutForm.GemRegel42Retrunering(var Lbnr, Linienr: integer; Linantal: integer);
// ok this routine will create a return ekspedition of a line and then create a return of that
// new ekspedition.   the idea is that the bgp and regel of the newly created tilskud line
// will be updated in the main
var
  Saldo: Currency;
  Nam: String;
  PemUpd, CtrUpd: Boolean;
  Res: Word;
  save_index: string;
  CheckGebyr: Boolean;
  ServerDateTime: TDateTime;
  BGPZero: Boolean;
  AllLiner: Boolean;

  procedure tr_EditRecepturOplysninger;
  var
    save_index: string;
  begin
    with MainDm do
    begin
      try
        Res := 101;
        ffRcpOpl.First;
        AfslLbNr := ffRcpOplLbNr.Value;
        save_index := ffEksKar.IndexName;
        ffEksKar.IndexName := 'NrOrden';
        try
          ffEksKar.Last;
          if ffEksKarLbNr.AsInteger >= AfslLbNr then
            AfslLbNr := ffEksKarLbNr.AsInteger + 1;
        finally
          ffEksKar.IndexName := save_index;
        end;
        ffRcpOpl.Edit;
        if not PakkeNrSet then
          AfslPakkeNr := 0;
        ffRcpOplLbNr.Value := AfslLbNr + 1;
        // Tildel pakkenr hvis der var pakkenr i forvejen
        if not PakkeNrSet then
        begin
          if Trim(ffRetEks.FieldByName('KontoNr').AsString) <> '' then
          begin
            if ffRetEks.FieldByName('PakkeNr').Value > 0 then
            begin
              AfslPakkeNr := ffRcpOplPakkeNr.Value;
              ffRcpOplPakkeNr.Value := ffRcpOplPakkeNr.Value + 1;
            end;
          end;
        end;
        Res := 102;
        ffRcpOpl.Post;
      except
        on E: Exception do
        begin
          c2logadd('Error in EditRecepturOplysninger ' + E.Message);
          try
            ffRcpOpl.Cancel;
          except
            on E: Exception do
              c2logadd('Error cancel edit in EditRecepturOplysninger ' + E.Message)

          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_InsertEkspLinierSalg(Lin: integer; Antal: integer);
  var
    Fld: TField;
  begin
    with MainDm do
    begin
      try
        Res := 120;
        ffEksLin.Insert;
        // Overfør alle felter fra ffLinOvr til ffEksLin
        for Fld in ffRetLin.Fields do
        begin
          Nam := Fld.FieldName;
          ffEksLin.FieldByName(Nam).Value := Fld.Value;
        end;
        // Ret nøglefelter m.m.
        ffEksLinLbNr.Value := AfslLbNr;
        ffEksLinLinieNr.Value := Lin;
        ffEksLinAntal.AsInteger := Antal;
        if ffEksKarOrdreType.AsInteger = 1 then
        begin
          ffEksLinDKType.AsInteger := 1;
          ffEksLinTilskType.AsInteger := 1;

        end;
        c2logadd('antal is ' + IntToStr(Antal));
        c2logadd('original antal is ' + ffRetLin.FieldByName('Antal').AsString);
        if Antal <> 0 then
        begin
          if ffRetLin.FieldByName('Antal').AsInteger <> Antal then
          begin
            PartialCredit := True;
            c2logadd('Partial Credit is true ');
            ffEksLinVareForbrug.AsCurrency := ffEksLinKostPris.AsCurrency * Antal;
            ffEksLinBrutto.AsCurrency := ffEksLinPris.AsCurrency * Antal;
            ffEksLinExMoms.AsCurrency := (ffEksLinBrutto.AsCurrency * 100) / (ffEksLinMomsPct.AsCurrency + 100);
            ffEksLinExMoms.AsCurrency := RoundDecCurr(ffEksLinExMoms.AsCurrency);
            ffEksLinMoms.AsCurrency := ffEksLinBrutto.AsCurrency - ffEksLinExMoms.AsCurrency;
            ffEksLinNetto.AsCurrency := ffEksLinBrutto.AsCurrency;
          end;
          ffEksLinAntal.AsInteger := Antal;
        end;
        Res := 121;
        ffEksLin.Post;

      except
        on E: Exception do
        begin
          c2logadd('Error in tr_InsertEkspLinierSalg ' + E.Message);
          try
            ffEksLin.Cancel;
          except
            on E: Exception do
              c2logadd('Error cancel tr_InsertEkspLinierSalg ' + E.Message);
          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_InsertEkspeditionerCredit(Lin: integer; Antal: integer);
  begin
    with MainDm do
    begin
      try
        nxEksCred.Insert;
        nxEksCred.FieldByName('OldLbnr').AsInteger := Lbnr;
        nxEksCred.FieldByName('OldLin').AsInteger := Lin;
        nxEksCred.FieldByName('CreditLbnr').AsInteger := ffEksKarLbNr.AsInteger;
        nxEksCred.FieldByName('DelvisDato').AsDateTime := ServerDateTime;
        nxEksCred.FieldByName('DelvisAntal').AsInteger := Antal;
        nxEksCred.Post;
      except
        on E: Exception do
        begin
          c2logadd('Error in InsertEkspeditionerCredit ' + E.Message);
          try
            nxEksCred.Cancel;
          except
            on E: Exception do
              c2logadd('Error calling cancel in InsertEkspeditionerCredit ' + E.Message);
          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_InsertEkspLinierTilskud(Lin: integer; Antal: integer; OldAntal: integer);
  var
    Fld: TField;
  begin
    with MainDm do
    begin
      try
        Res := 130;
        ffEksTil.Insert;
        // Overfør alle felter fra ffTilOvr til ffEksTil
        for Fld in ffRetTil.Fields do
        begin
          Nam := Fld.FieldName;
          ffEksTil.FieldByName(Nam).Value := Fld.Value;
        end;
        // Ret nøglefelter m.m.
        ffEksTilLbNr.Value := AfslLbNr;
        ffEksTilLinieNr.Value := Lin;
        ffEksTilCtrIndberettet.Value := 0;
        // Ret CTR saldo
        if ffEksTilRegelSyg.Value in [41 .. 43] then
        begin
          CtrUpd := True;
          ffEksKarCtrSaldo.AsCurrency := ffEksTilSaldo.AsCurrency;
        end;
        if Antal <> 0 then
        begin

          if Antal <> OldAntal then
          begin
            ffEksTilIBPBel.AsCurrency := Oprund5Ore(ffEksTilIBPBel.AsCurrency * Antal / OldAntal);
            ffEksTilBGPBel.AsCurrency := Oprund5Ore(ffEksTilBGPBel.AsCurrency * Antal / OldAntal);
            ffEksTilIBTBel.AsCurrency := Oprund5Ore(ffEksTilIBTBel.AsCurrency * Antal / OldAntal);
            ffEksTilAndel.AsCurrency := Oprund5Ore(ffEksTilAndel.AsCurrency * Antal / OldAntal);
            ffEksTilTilskSyg.AsCurrency := Oprund5Ore(ffEksTilTilskSyg.AsCurrency * Antal / OldAntal);
            ffEksTilTilskKom1.AsCurrency := Oprund5Ore(ffEksTilTilskKom1.AsCurrency * Antal / OldAntal);
            ffEksTilTilskKom2.AsCurrency := Oprund5Ore(ffEksTilTilskKom2.AsCurrency * Antal / OldAntal);
          end;
        end;
        IF ffEksTilBGP.AsCurrency <> 0 then
          BGPZero := FALSE;

        Res := 131;
        ffEksTil.Post;

      except
        on E: Exception do
        begin
          c2logadd('Error in InsertEkspLinierTilskud ' + E.Message);
          try
            ffEksTil.Cancel
          except
            on E: Exception do
              c2logadd('Error calling cancel in InsertEkspLinierTilskud ' + E.Message);
          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_InsertEksplinierEtiket(Lin: integer);
  var
    Fld: TField;
  begin
    with MainDm do
    begin
      try
        // Ekspeditionsetiketter gemmes
        Res := 140;
        ffEksEtk.Insert;
        // Overfør alle felter fra ffTilOvr til ffEksTil
        for Fld in ffRetEtk.Fields do
        begin
          Nam := Fld.FieldName;
          ffEksEtk.FieldByName(Nam).Value := Fld.Value;
        end;
        // Ret nøglefelter m.m.
        ffEksEtkLbNr.Value := AfslLbNr;
        ffEksEtkLinieNr.Value := Lin;
        Res := 141;
        ffEksEtk.Post;
      except
        on E: Exception do
        begin
          c2logadd('Error in InsertEksplinierEtiket ' + E.Message);
          try
            ffEksEtk.Cancel;
          except
            on E: Exception do
            begin
              c2logadd('Error calling cancel in InsertEksplinierEtiket ' + E.Message);
            end;
          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_EditEkspLinierTilskud;
  begin
    with MainDm do
    begin
      try
        Res := 150;
        ffEksTil.Edit;
        ffEksTilSaldo.AsCurrency := Saldo - ffEksTilBGPBel.AsCurrency;
        Saldo := ffEksTilSaldo.AsCurrency;
        Res := 151;
        ffEksTil.Post;

      except
        on E: Exception do
        begin
          c2logadd('Error in EditEkspLinierTilskud ' + E.Message);
          try
            ffEksTil.Cancel
          except
            on E: Exception do
              c2logadd('Error calling cancel in EditEkspLinierTilskud ' + E.Message);
          end;
          raise;
        end;
      end;
    end;
  end;

  procedure tr_EditPatientkartotek;
  var
    SavePatIndex: string;
  begin
    with MainDm do
    begin
      SavePatIndex := ffPatUpd.IndexName;
      ffPatUpd.IndexName := 'NrOrden';
      try
        if ffPatUpd.FindKey([ffPatKarKundeNr.AsString]) then
        begin
          try
            ffPatUpd.Edit;
            ffPatUpdCtrSaldo.AsCurrency := Saldo;
            ffPatUpd.Post;
          except
            on E: Exception do
            begin
              c2logadd('Error in EditPatientKartotek ' + E.Message);
              try
                ffPatUpd.Cancel;
              except
                on E: Exception do
                  c2logadd('Error calling cancel in EditPatientKartotek ' + E.Message);
              end;
              raise;
            end;
          end;
        end;
      finally
        ffPatUpd.IndexName := SavePatIndex;
      end;
    end;
  end;

  procedure tr_InsertEkspeditioner;
  var
    Fld: TField;
    CreditAntal: integer;
    SavePatIndex: string;
  begin
    with MainDm do
    begin

      try
        // Ekspedition gemmes
        Res := 110;
        ffEksKar.Insert;
        // Overfør alle felter fra ffEksOvr til ffEksKar
        for Fld in ffRetEks.Fields do
        begin
          if Fld.FieldKind = fkData then
          begin
            Nam := Fld.FieldName;
            ffEksKar.FieldByName(Nam).Value := Fld.Value;
          end;
        end;

        // Nulstil totaler

        ffEksKarCtrSaldo.AsCurrency := 0; // todo
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

        // fejl 51 allow automatic bookkeeping possibility if original ekspedition
        // is closed
        if ffEksKarOrdreStatus.AsInteger = 2 then
        begin
          AfslKontoNr := ffEksKarKontoNr.AsString;
          AfslLevForm := ffEksKarLeveringsForm.Value;
        end;
        // Ret nøglefelter m.m.
        ffEksKarLbNr.Value := AfslLbNr;
        ffEksKarTurNr.Value := 0;
        ffEksKarPakkeNr.Value := AfslPakkeNr;
        ffEksKarOrdreNr.Value := 0;
        ffEksKarFakturaNr.Value := 0;
        ffEksKarUdlignNr.Value := Lbnr;
        ffEksKarOrdreType.Value := 2; // Retur
        if ffRetEks.FieldByName('Ordretype').AsInteger = 2 then
        begin
          ffEksKarOrdreType.Value := 1;
          ffEksKarUdlignNr.AsInteger := 0;
          ffEksKarOrdreDato.AsDateTime := ffRetEks.FieldByName('OrdreDato').AsDateTime;
        end;
        ffEksKarTakserDato.AsDateTime := ServerDateTime;
        ffEksKarAfsluttetDato.AsString := '';
        ffEksKarOrdreStatus.Value := 1; // Takseret
        ffEksKarReceptStatus.Value := 0; // Manuel
        ffEksKarBrugerTakser.Value := BrugerNr;
        ffEksKarBrugerKontrol.Value := 0;
        ffEksKarBrugerAfslut.Value := 0;
        ffEksKarCtrIndberettet.Value := 0;
        ffEksKarDKIndberettet.Value := 0;

        // Gennemløb alle ordinationer

        CtrUpd := FALSE;
        PemUpd := FALSE;

        // 1182 check to see if part of ekspedition has already been credited
        // if it has then set telefon,edb,udbr gebyr to 0
        CheckGebyr := FALSE;
        nxEksCred.IndexName := 'LbnrOrden';
        nxEksCred.SetRange([Lbnr], [Lbnr]);
        try
          if nxEksCred.RecordCount <> 0 then
          begin
            nxEksCred.First;
            while not nxEksCred.Eof do
            begin
              if nxEksp.FindKey([nxEksCred.FieldByName('CreditLbnr').AsInteger]) then
              begin
                if nxEkspEdbGebyr.AsCurrency <> 0 then
                  CheckGebyr := True;
                if nxEkspTlfGebyr.AsCurrency <> 0 then
                  CheckGebyr := True;
                if nxEkspUdbrGebyr.AsCurrency <> 0 then
                  CheckGebyr := True;
                if CheckGebyr then
                  break;
              end;
              nxEksCred.Next;
            end;
            if CheckGebyr then
            begin
              ffEksKarUdbrGebyr.AsCurrency := 0;
              ffEksKarTlfGebyr.AsCurrency := 0;
              ffEksKarEdbGebyr.AsCurrency := 0;
            end;
          end;
        finally
          nxEksCred.CancelRange;
        end;

        if ffRetLin.FindKey([Lbnr, Linienr]) then
        begin
          CreditAntal := Linantal;
          if ffEksKarOrdreType.AsInteger = 2 then
            tr_InsertEkspeditionerCredit(Linienr, CreditAntal);
          // Ekspeditionslinier gemmes
          tr_InsertEkspLinierSalg(1, CreditAntal);
          ffEksKarExMoms.AsCurrency := ffEksKarExMoms.AsCurrency + ffEksLinExMoms.AsCurrency;
          ffEksKarMoms.AsCurrency := ffEksKarMoms.AsCurrency + ffEksLinMoms.AsCurrency;
          ffEksKarBrutto.AsCurrency := ffEksKarBrutto.AsCurrency + ffEksLinBrutto.AsCurrency;
          ffEksKarNetto.AsCurrency := ffEksKarNetto.AsCurrency + ffEksLinNetto.AsCurrency;

          if ffRetTil.FindKey([Lbnr, Linienr]) then
          begin
            // Ekspeditionstilskud gemmes
            tr_InsertEkspLinierTilskud(1, CreditAntal, ffRetLin.FieldByName('Antal').AsInteger);

            ffEksKarTilskKom.AsCurrency := ffEksKarTilskKom.AsCurrency + ffEksTilTilskKom1.AsCurrency +
              ffEksTilTilskKom2.AsCurrency;
            ffEksKarTilskAmt.AsCurrency := ffEksKarTilskAmt.AsCurrency + ffEksTilTilskSyg.AsCurrency;
            ffEksKarAndel.AsCurrency := ffEksKarAndel.AsCurrency + ffEksTilAndel.AsCurrency;
            // todo
            if ffEksLinDKType.AsInteger = 1 then
              ffEksKarDKTilsk.AsCurrency := ffEksKarDKTilsk.AsCurrency + ffEksTilAndel.AsCurrency;
            if ffEksLinDKType.AsInteger = 2 then
              ffEksKarDKEjTilsk.AsCurrency := ffEksKarDKEjTilsk.AsCurrency + ffEksTilAndel.AsCurrency;

          end;

          if ffRetEtk.FindKey([Lbnr, Linienr]) then
          begin
            tr_InsertEksplinierEtiket(1);
          end;
        end;

        // Reguler CTR

        SavePatIndex := ffPatUpd.IndexName;
        ffPatUpd.IndexName := 'NrOrden';
        try
          if ffPatUpd.FindKey([ffEksKarKundeNr.AsString]) then
          begin
            Saldo := ffPatUpdCtrSaldo.AsCurrency;
            c2logadd('patient start saldo is ' + CurrToStr(Saldo));
            if ffEksTil.FindKey([AfslLbNr, 1]) then
            begin
              // Ret CTR saldo
              if ffEksTilRegelSyg.Value in [41 .. 43] then
              begin
                tr_EditEkspLinierTilskud;
              end;
            end;
            tr_EditPatientkartotek;
          end;
        finally
          ffPatUpd.IndexName := SavePatIndex;
        end;

        Res := 111;
        // Afslut hvis ikke afsluttet
        if AllLiner then
        begin

          if ffRetEks.FieldByName('OrdreStatus').AsInteger = 1 then
          begin
            ffEksKarKontoNr.AsString := '';
            ffEksKarLeveringsForm.AsInteger := 0;
            ffEksKarTurNr.AsInteger := 0;
            ffEksKarPakkeNr.AsInteger := 0;
            ffEksKarLevNavn.AsString := '';
            AfslPakkeNr := 0;
            // fejl 1072   ffEksKarUdbrGebyr    .AsCurrency:= 0;
            ffEksKarOrdreStatus.AsInteger := 2; // Afsluttet
            ffEksKarBrugerKontrol.AsInteger := ffEksKarBrugerTakser.AsInteger;
            ffEksKarBrugerAfslut.AsInteger := ffEksKarBrugerTakser.AsInteger;
            ffEksKarAfsluttetDato.AsDateTime := ffEksKarTakserDato.AsDateTime;
          end;
        end;

        Res := 112;
        ffEksKar.Post;

      except
        on E: Exception do
        begin
          c2logadd('Error in InsertEkspeditioner ' + E.Message);
          try
            ffEksKar.Cancel;
          except
            on E: Exception do
              c2logadd('Error calling cancel in InsertEkspeditioner ' + E.Message);
          end;

          raise;
        end;

      end;
    end;
  end;

  procedure tr_EditOldEkspeditioner;
  begin
    with MainDm do
    begin
      try
        Res := 113;
        ffRetEks.Edit;
        if AllLiner then
        begin
          ffRetEks.FieldByName('UdlignNr').AsInteger := AfslLbNr;
          // Afslut hvis ikke afsluttet
          if ffRetEks.FieldByName('OrdreStatus').AsInteger = 1 then
          begin
            ffRetEks.FieldByName('KontoNr').AsString := '';
            ffRetEks.FieldByName('LeveringsForm').AsInteger := 0;
            ffRetEks.FieldByName('TurNr').AsInteger := 0;
            ffRetEks.FieldByName('PakkeNr').AsInteger := 0;
            // fejl 1072 ffRetEks.FieldByName('UdbrGebyr'    ).AsCurrency:= 0;
            ffRetEks.FieldByName('OrdreStatus').AsInteger := 2; // Afsluttet
            ffRetEks.FieldByName('BrugerAfslut').AsInteger := ffEksKarBrugerTakser.AsInteger;
            ffRetEks.FieldByName('AfsluttetDato').AsDateTime := ffEksKarTakserDato.AsDateTime;
            ffRetEks.FieldByName('LevNavn').AsString := '';
            save_index := nxEkspLevListe.IndexName;
            nxEkspLevListe.IndexName := 'LbnrOrden';
            try
              if nxEkspLevListe.FindKey([ffRetEks.FieldByName('LbNr').AsInteger]) then
                nxEkspLevListe.Delete;
            finally
              nxEkspLevListe.IndexName := save_index;
            end;
          end;
          if ffEksKarOrdreType.AsInteger = 1 then
            ffRetEks.FieldByName('ReceptStatus').AsInteger := 4;
          // credit undone

        end;
        Res := 114;
        ffRetEks.Post;

      except
        on E: Exception do
        begin
          c2logadd('Error in EditOldEkspeditioner ' + E.Message);
          try
            ffRetEks.Cancel;
          except
            on E: Exception do
              c2logadd('Error calling cancel in EditOldEkspeditioner ' + E.Message);

          end;
          raise;
        end;
      end;
    end;
  end;

begin
  with MainDm do
  begin
    // Returner ekspedition
    PartialCredit := FALSE;
    AfslKontoNr := '';
    AfslLevForm := 0;
    AfslLbNr := 0;
    AfslPakkeNr := 0;
    BGPZero := True;
    if not ffRetEks.FindKey([Lbnr]) then
      exit;
    AllLiner := FALSE;
    Res := 100;
    try
      PakkeNrSet := FALSE;

      ffRcpOpl.DataBase.StartTransactionWith([ffCtrOpd, ffEksKar, nxEksCred, ffEksEtk, ffEksLin, ffEksTil, ffPatUpd, ffRcpOpl]);
      try
        nxRemoteServerInfoPlugin1.GetServerDateTime(ServerDateTime);

        tr_EditRecepturOplysninger;

        tr_InsertEkspeditioner;

        tr_EditOldEkspeditioner;

        ffRcpOpl.DataBase.Commit;
        Res := 0;
      except
        on E: Exception do
        begin
          c2logadd('  Exception, err ' + IntToStr(Res));
          c2logadd('    Message "' + E.Message + '"');
          try
            ffRcpOpl.DataBase.Rollback;
          except
            on E: Exception do
              c2logadd('Fejl i rollback ' + E.Message);
          end;
        end;
      end;
    finally
      if Res <> 0 then
      begin
        ChkBoxOK('Fejl i returner ekspedition, fejl ' + IntToStr(Res));
      end
      else
      begin
        if Recepturplads <> 'DYR' then
          try
            UbiAfstempling(FALSE, FALSE);
          except
          end;
      end;
      // Returner true eller false
    end;

    // now recredit the newly created ekspedition
    Lbnr := ffEksKarLbNr.AsInteger;
    Linienr := 1;

    // Returner ekspedition
    PartialCredit := FALSE;
    AfslKontoNr := '';
    AfslLevForm := 0;
    AfslLbNr := 0;
    AfslPakkeNr := 0;
    BGPZero := True;
    AllLiner := True;
    if not ffRetEks.FindKey([Lbnr]) then
      exit;

    Res := 100;
    try
      PakkeNrSet := FALSE;

      ffRcpOpl.DataBase.StartTransactionWith([ffCtrOpd, ffEksKar, nxEksCred, ffEksEtk, ffEksLin, ffEksTil, ffPatUpd, ffRcpOpl]);
      try
        nxRemoteServerInfoPlugin1.GetServerDateTime(ServerDateTime);

        tr_EditRecepturOplysninger;

        tr_InsertEkspeditioner;

        tr_EditOldEkspeditioner;

        ffRcpOpl.DataBase.Commit;
        Res := 0;
      except
        on E: Exception do
        begin
          c2logadd('  Exception, err ' + IntToStr(Res));
          c2logadd('    Message "' + E.Message + '"');
          try
            ffRcpOpl.DataBase.Rollback;
          except
            on E: Exception do
              c2logadd('Fejl i rollback ' + E.Message);
          end;
        end;
      end;
    finally
      if Res <> 0 then
      begin
        ChkBoxOK('Fejl i returner ekspedition, fejl ' + IntToStr(Res));
      end
      else
      begin
        if Recepturplads <> 'DYR' then
          try
            UbiAfstempling(FALSE, FALSE);
          except
          end;
      end;
      // Returner true eller false
    end;

    Lbnr := ffEksKarLbNr.AsInteger;
    Linienr := 1;

  end;
end;

procedure TAfslutForm.UpdateEHOrd(Pakkenr: integer);
var
  LGebyr: Currency;
  LTakserDato: Currency;
  First: Boolean;
  found: Boolean;
  TotalPris: Currency;
  LVarenr: string;
  LSubVarenr: string;
  LEhordreHeader: TnxTable;
  LEhordreLines: TnxTable;
  LOereDifference: integer;
  LLinieNr: integer;
  LLbnr: integer;
  procedure CreateEhTables;
  begin
    LEhordreHeader := TnxTable.Create(Nil);
    LEhordreHeader.TableName := tnEHOrdreHeader;
    LEhordreHeader.DataBase := MainDm.nxdb;
    LEhordreHeader.Open;
    LEhordreHeader.IndexName := 'C2NrOrden';
    LEhordreLines := TnxTable.Create(Nil);
    LEhordreLines.TableName := tnEHOrdreLinier;
    LEhordreLines.DataBase := MainDm.nxdb;
    LEhordreLines.Open;
    LEhordreLines.IndexName := 'C2NrOrden';
  end;
  procedure FreeEhTables;
  begin
    LEhordreHeader.Close;
    LEhordreHeader.Free;
    LEhordreLines.Close;
    LEhordreLines.Free;
  end;

begin
  with MainDm do
  begin
    C2LogAddF('Top of UpdateEHOrd with C2Nr %d',[takserc2nr]);
    CreateEhTables;
    try
      try
        First := True;
        nxQryPak.Close;
        nxQryPak.Sql.Clear;
        nxQryPak.Sql.Add('#t 100000');
        nxQryPak.Sql.Add('select');
        nxQryPak.Sql.Add('       x. *');
        nxQryPak.Sql.Add('       ,rsl.ordid');
        nxQryPak.Sql.Add('       ,rse.prescriptionid');
        nxQryPak.Sql.Add('from');
        nxQryPak.Sql.Add('(');
        nxQryPak.Sql.Add('select');
        nxQryPak.Sql.Add('      e.*');
        nxQryPak.Sql.Add('      ,l.linienr');
        nxQryPak.Sql.Add('      ,l.varenr');
        nxQryPak.Sql.Add('      ,l.subvarenr');
        nxQryPak.Sql.Add('      ,l.antal');
        nxQryPak.Sql.Add('      ,l.tekst');
        nxQryPak.Sql.Add('      ,l.form');
        nxQryPak.Sql.Add('      ,l.styrke');
        nxQryPak.Sql.Add('      ,l.Pakning');
        nxQryPak.Sql.Add('      ,t.saldo');
        nxQryPak.Sql.Add('from');
        nxQryPak.Sql.Add('(');
        nxQryPak.Sql.Add('SELECT');
        nxQryPak.Sql.Add('       lbnr');
        nxQryPak.Sql.Add('       ,takserdato');
        nxQryPak.Sql.Add('       ,brugertakser');
        nxQryPak.Sql.Add('       ,andel');
        nxQryPak.Sql.Add('       ,tlfgebyr');
        nxQryPak.Sql.Add('       ,edbgebyr');
        nxQryPak.Sql.Add('       ,udbrgebyr');
        nxQryPak.Sql.Add('       ,dktilsk');
        nxQryPak.Sql.Add('       ,dkejtilsk');
        nxQryPak.Sql.Add('       ,ctrsaldo');
        nxQryPak.Sql.Add('       ,kundenr');
        nxQryPak.Sql.Add('FROM');
        nxQryPak.Sql.Add('     "Ekspeditioner"');
        nxQryPak.Sql.Add('where');
        nxQryPak.Sql.Add('     Pakkenr=:InPakkenr');
        nxQryPak.Sql.Add(') as e');
        nxQryPak.Sql.Add('left join ekspliniersalg as l on l.lbnr=e.lbnr');
        nxQryPak.Sql.Add('left join ekspliniertilskud as t on t.lbnr=l.lbnr and t.linienr=l.linienr');
        nxQryPak.Sql.Add(') as x');
        nxQryPak.Sql.Add('left join rs_eksplinier as rsl on rsl.lbnr=x.lbnr and rsl.linienr=x.linienr');
        nxQryPak.Sql.Add('left join rs_ekspeditioner as rse on rse.receptid=rsl.receptid');
        nxQryPak.Sql.Add('order by lbnr,linienr;');
        c2logadd(nxQryPak.Sql.Text);
        nxQryPak.ParamByName('InPakkenr').AsInteger := Pakkenr;
        nxQryPak.Open;
        if nxQryPak.RecordCount = 0 then
        begin
          ChkBoxOK('Pakkenr findes ikke');
          ModalResult := mrNone;
          exit;
        end;
        c2logadd('Record count is ' + IntToStr(nxQryPak.RecordCount));
        nxQryPak.First;
        TotalPris := 0.0;
        if not LEhordreHeader.FindKey([takserc2nr]) then
        begin
          ShowMessageBoxWithLogging('EHordre ' + takserc2nr.ToString + ' findes ikke');
          exit;
        end;
        LEhordreHeader.Edit;
        LTakserDato := nxQryPak.FieldByName('TakserDato').AsDateTime;
        LEhordreHeader.FieldByName(fnEHOrdreHeaderUdleveringstidspunkt).AsString := FormatDateTime('yyyy-mm-dd', LTakserDato) + 'T'
          + FormatDateTime('hh:mm:ss', LTakserDato);
        LEhordreHeader.FieldByName(fnEHOrdreHeaderEkspedient).AsString := nxQryPak.FieldByName('BrugerTakser').AsString;
        LEhordreHeader.FieldByName(fnEHOrdreHeaderEkspLbnr).AsInteger := Pakkenr;
        LEhordreHeader.FieldByName(fnEHOrdreHeaderUdleveringsnummer).AsString := IntToStr(Pakkenr);
        LEhordreHeader.FieldByName(fnEHOrdreHeaderSamletKundeandel).AsCurrency :=
          RoundDecCurr(nxQryPak.FieldByName('Andel').AsCurrency);

        LGebyr := nxQryPak.FieldByName('TlfGebyr').AsCurrency;
        if LGebyr <> 0 then
          LEhordreHeader.FieldByName(fnEHOrdreHeaderSamletKundeandel).AsCurrency :=
            LEhordreHeader.FieldByName(fnEHOrdreHeaderSamletKundeandel).AsCurrency + RoundDecCurr(LGebyr);
        LGebyr := nxQryPak.FieldByName('EdbGebyr').AsCurrency;
        if LGebyr <> 0 then
          LEhordreHeader.FieldByName(fnEHOrdreHeaderSamletKundeandel).AsCurrency :=
            LEhordreHeader.FieldByName(fnEHOrdreHeaderSamletKundeandel).AsCurrency + RoundDecCurr(EdbGebyr);
        LGebyr := nxQryPak.FieldByName('UdbrGebyr').AsCurrency;
        if LGebyr <> 0 then
          LEhordreHeader.FieldByName(fnEHOrdreHeaderSamletKundeandel).AsCurrency :=
            LEhordreHeader.FieldByName(fnEHOrdreHeaderSamletKundeandel).AsCurrency + RoundDecCurr(LGebyr);

        LEhordreHeader.FieldByName(fnEHOrdreHeaderTilskudsberettiget).AsCurrency := nxQryPak.FieldByName('DKTilsk').AsCurrency;
        LEhordreHeader.FieldByName(fnEHOrdreHeaderIkkeTilskudsberettiget).AsCurrency :=
          nxQryPak.FieldByName('DkEjTilsk').AsCurrency;
        LEhordreHeader.FieldByName(fnEHOrdreHeaderAnvendtCTR).AsCurrency := nxQryPak.FieldByName('CTRSaldo').AsCurrency;
        // put the ctr end of period date if available for C2Web orders only
        if (EHOrdre) and (ffPatUpdCtrUdDato.AsString <> '') then
          LEhordreHeader.FieldByName(fnEHOrdreHeaderCTRperiodeudloeb).AsString := ffPatUpdCtrUdDato.AsString;
        LEhordreHeader.FieldByName(fnEHOrdreHeaderAfventerKundensGodkendelse).AsBoolean := FALSE;
        LEhordreHeader.FieldByName(fnEHOrdreHeaderOrdrestatus).AsString := 'KlarTilAfhentning';
        LEhordreHeader.FieldByName(fnEHOrdreHeaderPrintStatus).AsInteger := 2; // completed
        // run down the eksplinier salg and try and find the product ordered
        while not nxQryPak.Eof do
        begin
          LVarenr := nxQryPak.FieldByName('Varenr').AsString;
          LSubVarenr := nxQryPak.FieldByName('SubVarenr').AsString;
          LLinieNr := nxQryPak.FieldByName('Linienr').AsInteger;
          LLbnr := nxQryPak.FieldByName('Lbnr').AsInteger;
          found := FALSE;
          try
            LEhordreLines.SetRange([takserc2nr], [takserc2nr]);
            try
              LEhordreLines.First;
              while not LEhordreLines.Eof do
              begin
                if MatchText(LEhordreLines.FieldByName(fnEHOrdreLinierVarenummer).AsString,[LVarenr, LSubVarenr]) or
                  MatchText(LEhordreLines.FieldByName(fnEHOrdreLinierOrdineretVarenummer).AsString,[LVarenr, LSubVarenr]) then
                begin
                  // if there is a prescription id then try and match the ordid as well as varenr or subvarenr

                  if not nxQryPak.FieldByName('PrescriptionId').IsNull then
                  begin
                    if not SameText(LEhordreLines.FieldByName(fnEHOrdreLinierOrdinationsId).AsString,
                      nxQryPak.FieldByName('Ordid').AsString) then
                    begin
                      LEhordreLines.Next;
                      Continue;
                    end;
                  end;

                  AdjustIndexName(nxEkspTil, 'NrOrden');
                  if nxEkspTil.FindKey([LLbnr, LLinieNr]) then
                  begin
                    LEhordreLines.Edit;
                    if not nxQryPak.FieldByName('PrescriptionId').IsNull then
                    begin
                      LEhordreLines.FieldByName(fnEHOrdreLinierOrdinationType).AsString := 'Receptkvittering';
                      LEhordreLines.FieldByName(fnEHOrdreLinierOrdinationsId).AsString := nxQryPak.FieldByName('Ordid').AsString;
                      LEhordreLines.FieldByName(fnEHOrdreLinierReceptId).AsString := nxQryPak.FieldByName('PrescriptionId').AsString;
                    end
                    else
                      LEhordreLines.FieldByName(fnEHOrdreLinierOrdinationType).AsString := 'Fysisk';
                    if C2Web then
                      LEhordreLines.FieldByName(fnEHOrdreLinierApoteketsOrdinationRef).AsString := IntToStr(Pakkenr) + ';' +
                        LLbnr.ToString;
                    LEhordreLines.FieldByName(fnEHOrdreLinierOrdineretAntal).AsInteger := nxQryPak.FieldByName('Antal').AsInteger;
                    // nxOrdLinOrdineretVarenummer.AsString := LSubVarenr;
                    LEhordreLines.FieldByName(fnEHOrdreLinierSygesikringensAndel).AsCurrency := nxEkspTilTilskSyg.AsCurrency;
                    LEhordreLines.FieldByName(fnEHOrdreLinierKommunensAndel).AsCurrency := nxEkspTilTilskKom1.AsCurrency;
                    LEhordreLines.FieldByName(fnEHOrdreLinierKundeandel).AsCurrency := nxEkspTilAndel.AsCurrency;
                    TotalPris := TotalPris + nxEkspTilAndel.AsCurrency;
                    LEhordreLines.FieldByName(fnEHOrdreLinierCTRbeloeb).AsCurrency := nxEkspTilBGPBel.AsCurrency;
                    LEhordreLines.Post;
                    LEhordreHeader.FieldByName(fnEHOrdreHeaderNyBeregnetCTRsaldo).AsCurrency := nxEkspTilSaldo.AsCurrency;
                  end;
                  found := True;
                  break;
                end;
                LEhordreLines.Next;
              end;
            finally
              LEhordreLines.CancelRange;
            end;
          finally
            // if we do not find the ordination the pharmacy have added a product to the eordre
            if not found then
            begin
              LEhordreLines.Append;
              LEhordreLines.FieldByName(fnEHOrdreLinierC2Nr).AsInteger := takserc2nr;
              LEhordreLines.FieldByName(fnEHOrdreLinierEordrenummer).AsString :=
                LEhordreHeader.FieldByName(fnEHOrdreHeaderEordrenummer).AsString;
              LEhordreLines.FieldByName(fnEHOrdreLinierLinjenummer).AsInteger := LEhordreLines.RecordCount + 1;
              LEhordreLines.FieldByName(fnEHOrdreLinierAntal).AsInteger := nxQryPak.FieldByName('Antal').AsInteger;
              LEhordreLines.FieldByName(fnEHOrdreLinierVarenummer).AsString := LSubVarenr;
              LEhordreLines.FieldByName(fnEHOrdreLinierErSpeciel).AsBoolean := FALSE;
              LEhordreLines.FieldByName(fnEHOrdreLinierVarenavn).AsString := nxQryPak.FieldByName('Tekst').AsString;
              LEhordreLines.FieldByName(fnEHOrdreLinierForm).AsString := nxQryPak.FieldByName('Form').AsString;
              LEhordreLines.FieldByName(fnEHOrdreLinierStyrke).AsString := nxQryPak.FieldByName('Styrke').AsString;
              LEhordreLines.FieldByName(fnEHOrdreLinierPakningsstoerrelse).AsString := nxQryPak.FieldByName('Pakning').AsString;
              LEhordreLines.FieldByName(fnEHOrdreLinierSubstitution).AsString := 'IngenSubstitution';
              nxLager.IndexName := 'NrOrden';
              if nxLager.FindKey([0, LSubVarenr]) then
              begin
                LEhordreLines.FieldByName(fnEHOrdreLinierListeprisPerStk).AsCurrency := nxLagerSalgsPris.AsCurrency;
                LEhordreLines.FieldByName(fnEHOrdreLinierTotallistepris).AsCurrency := nxLagerSalgsPris.AsCurrency *
                  nxQryPak.FieldByName('Antal').AsInteger;
              end;
              if not nxQryPak.FieldByName('PrescriptionId').IsNull then
              begin
                LEhordreLines.FieldByName(fnEHOrdreLinierOrdinationType).AsString := 'Receptkvittering';
                LEhordreLines.FieldByName(fnEHOrdreLinierOrdinationsId).AsString := nxQryPak.FieldByName('Ordid').AsString;
                LEhordreLines.FieldByName(fnEHOrdreLinierReceptId).AsString := nxQryPak.FieldByName('PrescriptionId').AsString;
              end
              else
                LEhordreLines.FieldByName(fnEHOrdreLinierOrdinationType).AsString := 'Fysisk';
              if C2Web then
                LEhordreLines.FieldByName(fnEHOrdreLinierApoteketsOrdinationRef).AsString := IntToStr(Pakkenr) + ';' +
                  LLbnr.ToString;
              LEhordreLines.FieldByName(fnEHOrdreLinierOrdineretAntal).AsInteger := nxQryPak.FieldByName('Antal').AsInteger;
              LEhordreLines.FieldByName(fnEHOrdreLinierOrdineretVarenummer).AsString := LSubVarenr;
              if nxEkspTil.FindKey([nxQryPak.FieldByName('Lbnr').AsInteger, nxQryPak.FieldByName('Linienr').AsInteger]) then
              begin
                LEhordreLines.FieldByName(fnEHOrdreLinierSygesikringensAndel).AsCurrency := nxEkspTilTilskSyg.AsCurrency;
                LEhordreLines.FieldByName(fnEHOrdreLinierKommunensAndel).AsCurrency := nxEkspTilTilskKom1.AsCurrency;
                LEhordreLines.FieldByName(fnEHOrdreLinierKundeandel).AsCurrency := nxEkspTilAndel.AsCurrency;
                TotalPris := TotalPris + nxEkspTilAndel.AsCurrency;
                LEhordreLines.FieldByName(fnEHOrdreLinierCTRbeloeb).AsCurrency := nxEkspTilBGPBel.AsCurrency;
                LEhordreHeader.FieldByName(fnEHOrdreHeaderNyBeregnetCTRsaldo).AsCurrency := nxEkspTilSaldo.AsCurrency;
              end;
              LEhordreLines.FieldByName(fnEHOrdreLinierEkspLinienr).AsInteger := nxQryPak.FieldByName('Linienr').AsInteger;
              LEhordreLines.Post;
            end;
            First := FALSE;
            nxQryPak.Next;
          end;
        end;
        if C2Web then
        begin
          LEhordreHeader.FieldByName(fnEHOrdreHeaderFragtpris).AsCurrency := 0;
          // if the difference between total pris on eordre and the calculated pris
          // is less than EorderPriceWithinLimits then do not update total pris
          C2LogAddF('EHOrdreHeaderTotalpris %f TotalPris %f', [LEhordreHeader.FieldByName(fnEHOrdreHeaderTotalpris).AsCurrency,
            TotalPris]);
          LOereDifference := Round((LEhordreHeader.FieldByName(fnEHOrdreHeaderTotalpris).AsCurrency - TotalPris) * 100);
          C2LogAddF('loeredifference is %d EorderPriceWithinLimits %d', [LOereDifference, MainDm.EorderPriceWithinLimits]);
          if (MainDm.EorderPriceWithinLimits <> 0) and (Abs(LOereDifference) > MainDm.EorderPriceWithinLimits) then
            LEhordreHeader.FieldByName(fnEHOrdreHeaderTotalpris).AsCurrency := TotalPris;
          LEhordreHeader.FieldByName(fnEHOrdreHeaderEkspedient).AsString := MainDm.C2UserName;
        end
        else
          LEhordreHeader.FieldByName(fnEHOrdreHeaderTotalpris).AsCurrency := TotalPris;
        LEhordreHeader.Post;
        StamForm.SendEOrdre(takserc2nr);
      except
        on E: Exception do
        begin
          ShowMessageBoxWithLogging(E.Message);
          ModalResult := mrNone;
        end;
      end;
    finally
      FreeEhTables;
    end;
  end;
end;

procedure TAfslutForm.VisTekst(const S: String);
begin
  c2logadd(S);
  paTxt.Caption := S;
  paTxt.Update;
end;

procedure TAfslutForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

function UseOldPakkeNr: Boolean;
begin
  with MainDm do
  begin
    nxOpenPakke.Sql.Text := sl_Sql_GetOldOpenPakkenr.Text;
    nxOpenPakke.Params.ParamByName('Kundenr').AsString := mtEksKundeNr.AsString;
    nxOpenPakke.Params.ParamByName('Kontonr').AsString := mtEksDebitorNr.AsString;
    try
      nxOpenPakke.Open;

    except
      on E: Exception do
      begin
        c2logadd('Error in nxopenpakke ' + E.Message);
        Result := FALSE;
        exit;
      end;

    end;

    try

      if nxOpenPakke.RecordCount = 0 then
      begin
        Result := FALSE;
        exit;
      end;

      nxOpenPakke.First;
      if (StamForm.TakserDosisKortAuto) and (DosisKortAutoExp) then
      begin
        AfslPakkeNr := StrToInt(nxOpenPakke.FieldByName('Pakkenr').AsString);
        Result := FALSE;
        exit;
      end;

      if not ChkBoxYesNo(' Vil du tilføje denne ekspedition til pakkenr ' + nxOpenPakke.FieldByName('Pakkenr').AsString, True) then
      begin
        Result := FALSE;
        exit;
      end;

      AfslPakkeNr := StrToInt(nxOpenPakke.FieldByName('Pakkenr').AsString);
      Result := True;
    finally
      nxOpenPakke.Close;
    end;
  end;

end;

function ReturUseOldPakkeNr: Boolean;
begin
  with MainDm do
  begin
    nxOpenPakke.Sql.Text := sl_Sql_GetOldOpenPakkenr.Text;
    nxOpenPakke.Params.ParamByName('Kundenr').AsString := ffRetEks.FieldByName('Kundenr').AsString;
    nxOpenPakke.Params.ParamByName('Kontonr').AsString := ffRetEks.FieldByName('KontoNr').AsString;
    try
      nxOpenPakke.Open;

    except
      on E: Exception do
      begin
        c2logadd('Error in nxopenpakke ' + E.Message);
        Result := FALSE;
        exit;
      end;

    end;

    try

      if nxOpenPakke.RecordCount = 0 then
      begin
        Result := FALSE;
        exit;
      end;

      nxOpenPakke.First;
      if not ChkBoxYesNo(' Vil du tilføje denne ekspedition til pakkenr ' + nxOpenPakke.FieldByName('Pakkenr').AsString, True) then
      begin
        Result := FALSE;
        exit;
      end;

      AfslPakkeNr := StrToInt(nxOpenPakke.FieldByName('Pakkenr').AsString);
      Result := True;
    finally
      nxOpenPakke.Close;
    end;
  end;

end;

function UseOldPakkeNr0Ekspedition: Boolean;
begin
  with MainDm do
  begin
    nxOpenPakke.Sql.Text := sl_Sql_GetOldOpenPakkenr.Text;
    nxOpenPakke.Params.ParamByName('Kundenr').AsString := mtEksKundeNr.AsString;
    nxOpenPakke.Params.ParamByName('Kontonr').AsString := mtEksLevNr.AsString;
    try
      nxOpenPakke.Open;

    except
      on E: Exception do
      begin
        c2logadd('Error in nxopenpakke ' + E.Message);
        Result := FALSE;
        exit;
      end;

    end;

    try

      if nxOpenPakke.RecordCount = 0 then
      begin
        Result := FALSE;
        exit;
      end;

      Result := True;
    finally
      nxOpenPakke.Close;
    end;
  end;

end;

procedure ReportCancelledRCP(Lbnr: LongWord);
begin
  try
    c2logadd('Top of reportcancelledrcp for lbnr ' + IntToStr(Lbnr));
    if not StamForm.ReceptServer then
      exit;
    try

      // MainDm.nxRSEkspLin.SetRange([lbnrtmp],[lbnrtmp]);
      // if MainDm.nxRSEkspLin.RecordCount = 0 then
      // exit;
      // c2logadd('Partial Credit is ' + Bool2Str(PartialCredit));
      // if PartialCredit then
      // exit;
      // C2LogAdd('Calling Midclient to remove status on the lines for lbnr ' + IntToStr(LbNr));
      // RSMidsrvError:= RCPMidCli.SendRequest('GetAddressed',
      // [
      // '6',
      // inttostr(LbNr)
      // ],
      // 10);
      //
      // // if we get an error removing status from RSMidsrv then put it in RSqueue
      // if RSMidsrvError = 888 then begin
      with MainDm do
      begin
        try
          nxRSQueue.Append;
          nxRSQueueLbnr.AsInteger := Lbnr;
          nxRSQueueDato.AsDateTime := Now;
          nxRSQueue.Post;

        except
          on E: Exception do
          begin
            c2logadd('Error adding to RSEkspqueue ' + E.Message);
            nxRSQueue.Cancel;
          end;
        end;
      end;

      // end;
    finally

    end;

  except
    on E: Exception do
      c2logadd('Exception in report cancelled rcp ' + E.Message);
  end;
end;

procedure CheckDeletedLines;
var
  save_index: string;
  oldlbnr: integer;
  newlbnr: integer;
  updateRSserver: Boolean;
  save_linindex: string;
begin

  with MainDm do
  begin
    if ffRetEks.FieldByName('OrdreStatus').AsInteger <> 1 then
      exit;
    save_index := SaveAndAdjustIndexName(nxEksCred, 'LbNrOrden');
    save_linindex := SaveAndAdjustIndexName(nxRSEkspLin, 'LbNrOrden');
    oldlbnr := ffRetEks.FieldByName('lbnr').AsInteger;
    newlbnr := ffEksKarLbNr.AsInteger;
    nxEksCred.SetRange([oldlbnr], [oldlbnr]);
    try
      if not nxRSEkspLin.FindKey([oldlbnr]) then
        exit;
      if nxEksCred.RecordCount = 0 then
        exit;

      updateRSserver := ChkBoxYesNo('Ja=Send tilbage til FMK. Der skal ikke ekspederes igen.' + sLineBreak +
        'Nej=Send IKKE tilbage til FMK. Der skal foretages ny ekspedition', FALSE);
      nxEksCred.First;
      while not nxEksCred.Eof do
      begin
        C2LogAddF('newbnr is %d', [newlbnr]);
        C2LogAddF('credt lbnr is %d', [nxEksCred.FieldByName('CreditLbnr').AsInteger]);
        if nxEksCred.FieldByName('CreditLbnr').AsInteger = newlbnr then
        begin
          c2logadd('found one ');
          if nxRSEkspLin.FindKey([oldlbnr, nxEksCred.FieldByName('Oldlin').AsInteger]) then
          begin
            c2logadd(' found line in rseksplinier');
            if updateRSserver then
            begin
              if KeepReceptLokalt then
              begin
                if uFMKCalls.FMKRemoveStatus(AfdNr, ffRetEks.FieldByName('Kundenr').AsString,
                  { TODO : 03-06-2021/MA: Replace with real PersonIdSource }
                  TFMKPersonIdentifierSource.DetectSource(ffRetEks.FieldByName('Kundenr').AsString), nxRSEkspLinReceptId.AsInteger,
                  StrToInt64(nxRSEkspLinOrdId.AsString), nxRSEkspLinAdministrationId.AsLargeInt) then
                begin
                  c2logadd('remove status on Administration successful');

                end;
              end
              else
              begin
                if uFMKCalls.FMKRemoveStatus(AfdNr, ffRetEks.FieldByName('Kundenr').AsString,
                  { TODO : 03-06-2021/MA: Replace with real PersonIdSource }
                  TFMKPersonIdentifierSource.DetectSource(ffRetEks.FieldByName('Kundenr').AsString), nxRSEkspLinReceptId.AsInteger,
                  StrToInt64(nxRSEkspLinOrdId.AsString), nxRSEkspLinAdministrationId.AsLargeInt, MainDm.nxdb) then
                begin
                  c2logadd('remove status on Administration successful');

                end;
              end;

            end
            else
            begin
              c2logadd('about to edit the lines set');
              try
                try
                  nxRSEkspLin.Edit;
                  nxRSEkspLinRSLbnr.AsInteger := 0;
                  nxRSEkspLinRSLinienr.AsInteger := 0;
                  nxRSEkspLin.Post;
                except
                  on E: Exception do
                    c2logadd('Exception during zero of lbnr linienr ' + E.Message);
                end;
              finally
                if nxRSEkspLin.State <> dsbrowse then
                  nxRSEkspLin.Cancel;
              end;

            end;

          end;

        end;
        nxEksCred.Next;
      end;

    finally
      nxEksCred.CancelRange;
      AdjustIndexName(nxEksCred, save_index);
      AdjustIndexName(nxRSEkspLin, save_linindex);
    end;
  end;

end;

procedure Create0ekspedition(var Res: Word);
var
  Lbnr0: integer;
  Pakkenr0: integer;
  ServerDateTime: TDateTime;
  ZeroReturDage: integer;
begin
  with MainDm do
  begin
    Res := 2000;
    nxRemoteServerInfoPlugin1.GetServerDateTime(ServerDateTime);
    ffRcpOpl.First;
    ffRcpOpl.Edit;
    Lbnr0 := ffRcpOplLbNr.Value;
    ffRcpOplLbNr.Value := ffRcpOplLbNr.Value + 1;
    Pakkenr0 := ffRcpOplPakkeNr.AsInteger;
    ffRcpOplPakkeNr.Value := ffRcpOplPakkeNr.Value + 1;
    AfslPakkeNr := Pakkenr0;
    Res := 2102;
    ffRcpOpl.Post;

    // set the returdage from the newly created ekspedition
    ZeroReturDage := ffEksKarReturdage.AsInteger;

    // Ekspedition gemmes
    Res := 2110;
    ffEksKar.Insert;
    ffEksKarLbNr.Value := Lbnr0;
    ffEksKarTurNr.Value := ffRcpOplTurNr.AsInteger;
    ffEksKarPakkeNr.Value := Pakkenr0;
    ffEksKarFakturaNr.Value := 0;
    ffEksKarUdlignNr.Value := 0;
    ffEksKarKundeNr.Value := mtEksKundeNr.Value;
    // ffEksKarLMSUdsteder.AsString      := mtEksYderNr.AsString;
    ffEksKarLMSModtager.AsString := ffPatKarLmsModtager.AsString;
    ffEksKarFiktivtCprNr.AsBoolean := ffPatKarFiktivtCprNr.Value;
    ffEksKarCprCheck.AsBoolean := ffPatKarCprCheck.AsBoolean;
    ffEksKarEjSubstitution.AsBoolean := ffPatKarEjSubstitution.AsBoolean;
    ffEksKarBarn.AsBoolean := ffPatKarBarn.AsBoolean;
    ffEksKarKundeKlub.AsBoolean := FALSE;
    ffEksKarKlubNr.AsInteger := 0;
    ffEksKarAmt.Value := ffPatKarAmt.Value;
    ffEksKarKommune.Value := ffPatKarKommune.Value;
    ffEksKarKundeType.Value := mtEksKundeType.Value;
    ffEksKarLandeKode.Value := ffPatKarLandeKode.Value;
    ffEksKarCtrType.Value := mtEksCtrType.Value;
    ffEksKarFoedDato.AsString := ffPatKarFoedDato.AsString;
    ffEksKarNarkoNr.AsString := mtEksNarkoNr.AsString;
    ffEksKarOrdreType.Value := mtEksOrdreType.Value;
    ffEksKarOrdreStatus.Value := mtEksOrdreStatus.Value;
    ffEksKarReceptStatus.Value := mtEksReceptStatus.Value;
    if ffEksKarReceptStatus.Value = 999 then
      ffEksKarReceptStatus.Value := 3;
    ffEksKarEkspType.Value := mtEksEkspType.Value;
    ffEksKarEkspForm.Value := mtEksEkspForm.Value;
    ffEksKarDosStyring.AsBoolean := FALSE;
    ffEksKarIndikStyring.AsBoolean := FALSE;
    ffEksKarAntLin.Value := 0;
    ffEksKarAntVarer.Value := 0;
    ffEksKarDKMedlem.Value := 0;
    if ffEksKarKundeType.Value = pt_Enkeltperson then
      ffEksKarDKMedlem.Value := ffPatKarDKMedlem.Value;
    ffEksKarDKAnt.Value := 0;
    // ffEksKarReceptDato.AsDateTime     := Now;
    ffEksKarTakserDato.AsDateTime := ServerDateTime;
    ffEksKarOrdreDato.AsDateTime := ServerDateTime; // CTR dato og tid
    // ffEksKarKontrolDato.AsDateTime    := ;
    ffEksKarForfaldsdato.AsDateTime := ffEksKarTakserDato.AsDateTime;
    // Hvis udligntype = 1 så er det forrige periode
    // da benyttes mtEksCtrUdlignDato til ordredato
    ffEksKarBrugerTakser.Value := BrugerNr;
    ffEksKarBrugerKontrol.Value := 0;
    ffEksKarBrugerAfslut.Value := 0;
    ffEksKarTitel.AsString := '';
    ffEksKarNavn.AsString := ffPatKarNavn.AsString;
    ffEksKarAdr1.AsString := ffPatKarAdr1.AsString;
    ffEksKarAdr2.AsString := ffPatKarAdr2.AsString;
    ffEksKarPostNr.AsString := ffPatKarPostNr.AsString;
    ffEksKarLand.AsString := '';
    ffEksKarKontakt.AsString := '';
    ffEksKarTlfNr.AsString := '';
    ffEksKarTlfNr2.AsString := '';
    ffEksKarYderNr.AsString := mtEksYderNr.AsString;
    ffEksKarYderCprNr.AsString := mtEksYderCprNr.AsString;
    ffEksKarYderNavn.AsString := mtEksYderNavn.AsString;
    ffEksKarKontoNr.AsString := Trim(mtEksLevNr.AsString);
    if ffDebKar.FindKey([mtEksLevNr.AsString]) then
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
    ffEksKarAfdeling.Value := mtEksAfdeling.Value;
    ffEksKarLager.Value := mtEksLager.Value;
    ffEksKarNettoPriser.AsBoolean := ffPatKarNettoPriser.AsBoolean;
    ffEksKarInclMoms.AsBoolean := True;
    (* BN change VAT begin - remove code
      ffEksKarMomsPct.AsCurrency := ffRcpOplMomsPct.AsCurrency;
      BN change VAT end *)
    (* BN change VAT begin - new code *)
    ffEksKarMomsPct.AsCurrency := MomsPercent;
    (* BN change VAT end *)
    ffEksKarRabatPct.AsCurrency := 0;
    ffEksKarCtrIndberettet.Value := 0;
    ffEksKarDKIndberettet.Value := 0;
    // Gebyrer
    ffEksKarTlfGebyr.AsCurrency := 0;
    ffEksKarEdbGebyr.AsCurrency := 0;

    // Nulstil totaler

    ffEksKarCtrSaldo.AsCurrency := mtEksGlCtrSaldo.AsCurrency;
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

procedure SendRowaOrdre;
var
  RobotUdtag: string;
  save_index: string;
  CopyUdtag: string;
begin

  if not StamForm.RowaOrdre then
    exit;
  with MainDm do
  begin
    if Rowasl.Count = 0 then
    begin
      RobotUdtag := C2StrPrm(StamForm.RobotSection, 'RobotUdtag', '001');
      RobotUdtag := C2StrPrm(MainDm.C2UserName, 'RobotUdtag', RobotUdtag);
      CopyUdtag := RobotUdtag;

      IF ffEksKarKontoNr.AsString <> '' then
      begin
        if ffEksKarKontoNr.AsString = C2StrPrm(StamForm.RobotSection, 'RobotKonto', '') then
          RobotUdtag := C2StrPrm(StamForm.RobotSection, 'RobotKontoUdtag', RobotUdtag)
        else
          RobotUdtag := C2StrPrm(StamForm.RobotSection, 'RobotDebUdtag', RobotUdtag);
      end
      else
      begin
        if pos('/', RobotUdtag) <> 0 then
        begin
          AfslutForm.Hide;
          frmRowaUdtag.ShowUdtag(CopyUdtag, RobotUdtag);
          AfslutForm.Show;
        end;
      end;
      saveRobotUdtag := RobotUdtag;
    end;
    save_index := SaveAndAdjustIndexName(ffEksLin, 'NrOrden');
    ffEksLin.SetRange([AfslLbNr], [AfslLbNr]);
    try
      while not ffEksLin.Eof do
      begin
        if ffEksLinLokation1.AsInteger = StamForm.RowaLokation then
          Rowasl.Add(ffEksLinSubVareNr.AsString + Format('%4.4d', [ffEksLinAntal.AsInteger]));
        ffEksLin.Next;
      end;
      if Rowasl.Count = 0 then
        exit;
      if ChkBoxYesNo('Send ordre til Robot nu ?', True) then
      begin
        frmRowaApp.RowaSendAXRequest(Rowasl, saveRobotUdtag);
        Rowasl.Clear;
      end
      else
      begin
        if not StamForm.RowaGemOrdre then
          Rowasl.Clear;

      end;
    finally
      ffEksLin.CancelRange;
      AdjustIndexName(ffEksLin, save_index);
    end;
  end;
end;

procedure UbiKronikerLabel;
var
  etk: TStringList;
  save_index: string;
  Cnt: integer;
  Ialt: Currency;
  line_amount: Currency;
begin
  with MainDm do
  begin
    c2logadd('Top of kroniker label');
    c2logadd('kundetype is ' + IntToStr(ffEksKarCtrType.AsInteger));

    // the  following check is no longer required just look at the debitor
    // if not (ffEksKarCtrType.AsInteger in [10,11]) then
    // exit;
    c2logadd('kontonr is ' + ffEksKarKontoNr.AsString);
    if ffEksKarKontoNr.AsString = '' then
      exit;
    save_index := SaveAndAdjustIndexName(ffDebKar, 'NrOrden');
    try
      c2logadd('lookup the debitor');
      if not ffDebKar.FindKey([ffEksKarKontoNr.AsString]) then
        exit;
      c2logadd('debitor is kroniker ? ' + Bool2Str(ffDebKarKroniker.AsBoolean));
      if not ffDebKarKroniker.AsBoolean then
        exit;

    finally
      AdjustIndexName(ffDebKar, save_index);
    end;

    // ok if we get here then we need to print the new label

    etk := TStringList.Create;
    try
      etk.Add(ffEksKarNavn.AsString);
      etk.Add('Beløb, der ikke medtages I');
      etk.Add('kronikerhenstandsberegningen:');
      Ialt := 0.0;
      for Cnt := 1 to ffEksKarAntLin.Value do
      begin
        if not ffEksLin.FindKey([AfslLbNr, Cnt]) then
          continue;
        if not ffEksTil.FindKey([AfslLbNr, Cnt]) then
          continue;
        if ffEksLinBrutto.AsCurrency = ffEksTilBGPBel.AsCurrency then
        begin
          // if cannabis product then always the patient part if not then skip
          if IsCannabisProduct(nxdb, ffEksLinLager.AsInteger, ffEksLinSubVareNr.AsString, ffEksLinTekst.asstring,
            ffEksLinDrugId.AsString) then
            line_amount := ffEksTilAndel.AsCurrency
          else
            continue;
        end
        else
          line_amount := ffEksLinBrutto.AsCurrency - ffEksTilBGPBel.AsCurrency;
        etk.Add(Format('%-20s %8.2f', [copy(ffEksLinTekst.AsString, 1, 20), line_amount]));
        Ialt := Ialt + line_amount;

      end;
      if ffEksKarTlfGebyr.AsCurrency <> 0 then
      begin
        etk.Add(Format('%-20s %8.2f', ['Tlf.gebyr', ffEksKarTlfGebyr.AsCurrency]));
        Ialt := Ialt + ffEksKarTlfGebyr.AsCurrency;
      end;
      if ffEksKarUdbrGebyr.AsCurrency <> 0 then
      begin
        etk.Add(Format('%-20s %8.2f', ['Udbr.gebyr', ffEksKarUdbrGebyr.AsCurrency]));
        Ialt := Ialt + ffEksKarUdbrGebyr.AsCurrency;
      end;
      if Ialt <> 0.0 then
      begin
        etk.Add('');
        etk.Add(Format('%-20s %8.2f', ['I alt', Ialt]));
      end;

      c2logadd('etk before print is ' + etk.Text);
      if etk.Count = 3 then
        exit;
      fmUbi.PrintDosEtik(ffFirmaSupNavn.AsString, FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime), ffEksKarLbNr.AsString,
        etk, '', '', '', '', '', '', '', '', '', 1, True, FALSE);
    finally
      etk.Free;
    end;
  end;
end;

function UpdateDMVS(AFullEkspedition: Boolean; ABrugerNr, AOldlbnr, ANewLbnr, AAfdnr: integer): Boolean;
var
  nxq: TnxQuery;
  i: integer;
  DMVSResultList: TStringList;
  Pnr: Word;
  NumberOf2DScannedProducts: integer;
  CurrentDMVSSvrConnection: TC2DMVSSvrConnection;
  NewConnectionCreated: Boolean;
  OriginalAntal: integer;
  LAntal: integer;
  LLinieNr: integer;

  function CheckEksplinierSerieNumre(aLbnr, Alinienr: integer): integer;
  var
    LQry: TnxQuery;
  begin
    Result := 0;
    c2logadd(Format('CheckEksplinierSerieNumre lbnr %d lininenr %d', [aLbnr, Alinienr]));

    with MainDm do
    begin
      try
        LQry := MainDm.nxdb.OpenQuery('select produktkode from eksplinierserienumre ' +
          'where lbnr=:lbnr and linienr=:linienr and produktkode<>''''' + ' and Returtidspunkt is Null', [aLbnr, Alinienr]);
        try
          C2LogAddF('record count is %d', [LQry.RecordCount]);
          Result := LQry.RecordCount;

        finally
          LQry.Free;
        end;
      except
        on E: Exception do
          c2logadd('Fejl i CheckEksplinierSerieNumre' + E.Message);

      end;

    end;

    C2LogAddF('Result from CheckEksplinierSerieNumre is %d', [Result]);
  end;

  function GetOriginalAntal(aLbnr, ALinier: integer): integer;
  var
    LQry: TnxQuery;
  begin
    Result := 0;
    LQry := MainDm.nxdb.OpenQuery('select antal from ekspliniersalg where lbnr=:ilbnr and linienr=:ilinienr', [aLbnr, ALinier]);
    try
      if not LQry.Eof then
        Result := LQry.FieldByName('antal').AsInteger;
    finally
      LQry.Free;

    end;

  end;

begin
  with MainDm do
  begin
    Result := FALSE;
    EscapePressedInDMVS := FALSE;
    NewConnectionCreated := FALSE;
    if AAfdnr <> MainDm.AfdNr then
    begin
      // create a new temporary connection for the afdeling
      c2logadd('create a new TC2DMVSSvrConnection');
      CurrentDMVSSvrConnection := TC2DMVSSvrConnection.Create(MainDm.nxdb, AAfdnr, C2Env.Arbejdsstation, C2Env.C2ServerAddress);
      if not CurrentDMVSSvrConnection.DMVSIntegrationEnabled then
      begin
        c2logadd('dmvs not enabled on the afdeling so free the connection');
        CurrentDMVSSvrConnection.Free;
        c2logadd('dmvs not enabled on the afdeling so use the local pc connection');
        CurrentDMVSSvrConnection := DMVSSvrConnection;
        NewConnectionCreated := FALSE;
      end
      else
        NewConnectionCreated := True;
    end
    else
    begin
      // use the global one created in Maindm
      c2logadd('use the global connection');
      CurrentDMVSSvrConnection := DMVSSvrConnection;
      NewConnectionCreated := FALSE;
    end;

    DMVSResultList := TStringList.Create;
    nxq := TnxQuery.Create(Nil);
    try
      try

        nxq.DataBase := nxdb;

        nxq.Sql.Clear;
        nxq.Sql.Add('select lin.lbnr,lin.linienr,lin.subvarenr,lin.antal,lin.lager,lag.tekst from ekspliniersalg as lin');
        nxq.Sql.Add('inner join lagerkartotek as lag on lag.lager=0 and lag.varenr=lin.subvarenr');
        nxq.Sql.Add('where lin.lbnr= :ilbnr');
        nxq.Sql.Add('and lag.dmvs<>0');
        c2logadd(nxq.Sql.Text);
        nxq.ParamByName('ilbnr').AsInteger := ANewLbnr;
        nxq.Open;

        // if there are no dmvs products get out
        if nxq.Eof then
          exit;

        FejliDMVS := FALSE;
        if AFullEkspedition then
        begin
          // 0 passed in Alinienr to indicate all ekspedition is being returned
          c2logadd('full ekspedition using the Current dmvs connection ' + BoolToStr(NewConnectionCreated, True));
          TfrmDMVS.UpdateAllDMVSinfo(nxdb, CurrentDMVSSvrConnection, ABrugerNr, AOldlbnr, 0, ANewLbnr,
            nxq.FieldByName('lager').AsInteger, DMVSResultList);

        end
        else
        begin
          nxq.First;
          while not nxq.Eof do
          begin
            // how many products have bee scanned usng 2D barcode
            LAntal := nxq.FieldByName('antal').AsInteger;
            LLinieNr := nxq.FieldByName('linienr').AsInteger;
            NumberOf2DScannedProducts := CheckEksplinierSerieNumre(AOldlbnr, LLinieNr);

            if NumberOf2DScannedProducts <> 0 then
            begin

              // need to scan the minumum of antal returned and antal scanned
              C2LogAddF('antal is %d numberof2dscannnedproducts is %d min is %d',
                [LAntal, NumberOf2DScannedProducts, Min(NumberOf2DScannedProducts, LAntal)]);


              // get the original antal from the ekspedition

              OriginalAntal := GetOriginalAntal(AOldlbnr, LLinieNr);

              c2logadd('orginal antal is ' + OriginalAntal.ToString);

              // if the line is a total line credit then dont ask for scan of inidividual products.
              if LAntal = OriginalAntal then
              begin
                // 0 passed in Alinienr to indicate all ekspedition is being returned
                c2logadd('full ekspedition using the Current dmvs connection ' + Bool2Str(NewConnectionCreated));
                TfrmDMVS.UpdateAllDMVSinfo(nxdb, CurrentDMVSSvrConnection, ABrugerNr, AOldlbnr, LLinieNr, ANewLbnr,
                  nxq.FieldByName('lager').AsInteger, DMVSResultList);

              end
              else
              begin

                for i := 1 to Min(NumberOf2DScannedProducts, LAntal) do
                begin
                  // if they press opdater on any line then result is true so create the
                  // return ekspedition

                  c2logadd('partial credit isung the current TC2DMVSSvrConnection ' + Bool2Str(NewConnectionCreated));
                  if TfrmDMVS.UpdateDMVSInfo(nxdb, CurrentDMVSSvrConnection, ABrugerNr, AOldlbnr, ANewLbnr,
                    nxq.FieldByName('lager').AsInteger, LLinieNr, nxq.FieldByName('subvarenr').AsString,
                    nxq.FieldByName('tekst').AsString, DMVSResultList) then
                    Result := True;
                end;
              end;
            end;

            nxq.Next;
          end;
        end;

        if FejliDMVS then
        begin
          Pnr := 0;
          DMVSResultList.Insert(0, '');
          DMVSResultList.Insert(0, '');
          DMVSResultList.Insert(0, Format('%-8s %-20s %-14s %-20s %-20s %-8s %s', ['Varenr', 'Navn', 'Produktkode', 'Serienr.',
            'Batchnr.', 'Udl.', 'Status']));
          DMVSResultList.Insert(0, ffFirmaNavn.AsString);
          DMVSResultList.Insert(0, 'DMVS genaktiverings status');
          DMVSResultList.SaveToFile('C:\C2\Temp\DMVSListe.Txt');
          PatMatrixPrnForm.PrintMatrix(Pnr, 'C:\C2\Temp\DMVSListe.Txt', FALSE);

        end;

      except
        on E: Exception do
          c2logadd('fejl i updatedmvs sql ' + E.Message);
      end;

    finally
      if NewConnectionCreated then
      begin
        c2logadd('free the new TC2DMVSSvrConnection');
        CurrentDMVSSvrConnection.Free;
      end;

      nxq.Free;
      DMVSResultList.Free;
    end;

  end;
end;

end.
