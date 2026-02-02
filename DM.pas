{$I bsdefine.inc}
unit DM;

{ Developed by: Cito IT A/S

  Description: Patientkartotek Nexus datamodule

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  04-02-2025/cjs  TakserUdenCTR property added.

  20-11-2023/cjs  New property added to main datamodule EorderPriceWithinLimits

  01-02-2023/cjs  Allow setting of UseTidlPris under the user section so that individual users can use the
                  tisalgspris and tibgp.

  19-01-2023/cjs  Corrections for use of prices if Eordre dato is not today.

  30-06-2022/cjs  Added property TakserC2Nr for current C2Nr being taksered from CF8 screen

  13-12-2021/cjs  Changes for using the new CtrTilskudSatser table

  12-08-2021/cjs  Corrected index on EhordreHeader

  12-08-2021/cjs  Repair dseksp datasource link to mteks

  29-10-2020/cjs  Modified to use new property for Recepturplads

  21-10-2020/cjs  VaccinationPopUp=Nej is now the default

  14-10-2020/cjs  VaccinationPopUp=Nej in [Receptur] blocks over 65 popup

  17-07-2020/cjs  Removed code to get dosiscard innfo from afterscroll event

  12-07-2020/cjs  Added PatientDosisCards for use in dosis info screens

  16-06-2020/MA   Corrected spelling in status panel.
                
  04-05-2020/cjs  Add a property for the number of days to search in CF6 (default 60)

  22-04-2020/cjs  remove the nexus message during exception when adding blank customer

  14-04-2020/cjs  Added exception handling around the eletion and creation of blank customer

  30-03-2020/cjs  KeepReceptLokalt property added. if set to Nej then locsl copy of prescription
                  is kept if removestatus is called

  23-03-2020/cjs  New public property BrugerCertificateValid set by timer which runs every 15 seconds

  11-09-2019/cjs  Corrected mteks kundenavn error on startup.

  28-08-2019/cjs  increased timeout on cf3 sql top display ekspeiditioner for kundenr in cf1 to 30
                  seconds kundenr 90 takes longer than 10 seconds to display

  05-08-2019/cjs  EscapePressedInDMVS boolean property added

  06-05-2019/cjs  remove antpkn=0 from sl_Sql_lms32_label

  06-05-2019/cjs  correction to subst label sql link varenr in lagerkartotek to subnr in
                  lagersubstliste

  03-05-2019/cjs  Corrections to subst label sql's

  26-03-2019/cjs  Added Returdage persistent field to fqeksovr for display in CF3
}

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, Db,
  nxdb, nxdbBase, IniFiles,
  DBClient,
//  IdMessage,
//  IdSmtp,
//  IdAttachmentFile,
  (*
    fflleng,
    ffsrintm,    ffclreng,    ffllcomp,
    ffllcomm,    fflllgcy,
    //  DebitorIntfc,
  *)
  MidClientApi,
  nxsdServerEngine,
  nxreRemoteServerEngine,
  nxllComponent,

  nxllTypes,
  nxllTransport,
  nxptBasePooledTransport, nxllZipCompressor,
  nxtwWinsockTransport, nxllPluginBase, nxsiServerInfoPluginBase,
  nxsiServerInfoPluginClient, generics.collections, generics.defaults,

  uC2DMVSSvrConnection.Classes, CtrTilskudsSatser, uEkspeditioner.Tables,
  uc2bruger.Classes, uc2afdeling.Classes,uC2FMK.Prescription.Classes,uC2FMK,
  uc2llog.types,uLagerKartotek.Tables,uC2FMK.Common.Types,
  uC2FMK.DoseDispensingCard.Classes,
  uRS_Ekspeditioner.Tables,
  uc2bruger.logon.Procs,uC2Bruger.Types,
  Vcl.ExtCtrls,System.RegularExpressions, frmC2Logon, Data.SqlExpr, Data.DbxDatasnap, Data.DBXCommon, IPPeerClient;

const
  KundeKeyBlk = '                    ';
  KundeTypEnk = [1];
  EkspTypAlle = [0 .. 255];
  EkspTypEnk = [1, 4, 6, 7];
  EkspTypVagt = [2];
  EkspTypLev = [3, 4];
  EkspTypHdk = [4];
  EkspTypDyr = [5];
  EkspFrmAlle = [0 .. 255];
  EkspFrmDyr = [0 .. 2];
  EkspFrmEnk = [0 .. 4];
  EkspFrmAndet = [0];
  DyreAnvErhv = 1;
  DyreAnvPriv = 2;
  LinTypAlle = [0 .. 255];
  LinTypRcp = [1, 2, 9];
  LinTypHdk = [2];
  CannabisPrefix = '2911';

  { I c:\Udvikling\CVS_Source\Apotek\Common\MidServerInc }

type
  THaCalcRec = record
    AIP1: Currency;
    Sats1: Currency;
    Gebyr1: Currency;
    AIP2: Currency;
    Sats2: Currency;
    Gebyr2: Currency;
    AIP3: Currency;
    Sats3: Currency;
    Gebyr3: Currency;
    UdPct: Currency;
  end;

  TMainDm = class(TDataModule)
    // TMainDm = class(TDataModule, IDebitorKar)
    nxSess: TnxSession;

    dsYdLst: TDataSource;
    ffYdLst: TnxTable;
    ffYdLstYderNr: TStringField;
    ffYdLstCprNr: TStringField;
    ffYdLstNavn: TStringField;

    dsPatKar: TDataSource;
    ffPatKar: TnxTable;
    ffPatKarOpretDato: TDateTimeField;
    ffPatKarRetDato: TDateTimeField;
    ffPatKarCprCheck: TBooleanField;
    ffPatKarNavn: TStringField;
    ffPatKarAdr1: TStringField;
    ffPatKarAdr2: TStringField;
    ffPatKarPostNr: TStringField;
    ffPatKarTlfNr: TStringField;
    ffPatKarDebitorNr: TStringField;
    ffPatKarYderNr: TStringField;
    ffPatKarYderCprNr: TStringField;
    ffPatKarBy: TStringField;
    ffPatKarLuYdNavn: TStringField;
    ffPatKarKommune: TWordField;
    ffPatKarInstans: TStringField;
    ffPatKarKundeType: TWordField;
    ffPatKarCtrType: TWordField;
    ffPatKarLandekode: TWordField;
    ffPatKarFoedDato: TStringField;
    ffPatKarLmsModtager: TStringField;
    ffPatKarFiktivtCprNr: TBooleanField;
    ffPatKarNettoPriser: TBooleanField;
    ffPatKarDKMedlem: TWordField;
    ffPatKarEjSubstitution: TBooleanField;
    ffPatKarBarn: TBooleanField;
    ffPatKarKundeNr: TStringField;
    ffPatKarVigtigBem: TMemoField;
    ffPatKarAmt: TWordField;

    dsPatTil: TDataSource;
    ffPatTil: TnxTable;
    ffPatTilKundeNr: TStringField;
    ffPatTilOrden: TWordField;
    ffPatTilRegel: TWordField;
    ffPatTilFraDato: TDateTimeField;
    ffPatTilTilDato: TDateTimeField;
    ffPatTilPromille1: TWordField;
    ffPatTilPromille2: TWordField;
    ffPatTilPromille3: TWordField;
    ffPatTilPromille4: TWordField;
    ffPatTilPromille5: TWordField;
    ffPatTilEgenbetaling: TCurrencyField;
    ffPatTilAkkBetaling: TCurrencyField;
    ffPatTilBetalType: TWordField;
    ffPatTilBetalDato: TDateTimeField;
    ffPatTilJournalNr: TStringField;
    ffPatTilRefNr: TStringField;
    ffPatTilChkJournalNr: TBooleanField;
    ffPatTilTilskMetode: TWordField;
    ffPatTilBevilling: TMemoField;
    ffPatTilNavn: TStringField;
    ffPatTilAfdeling: TStringField;

    dsPnLst: TDataSource;

    dsCtrLan: TDataSource;

    dsKar: TDataSource;

    dsInLst: TDataSource;
    ffInLst: TnxTable;
    ffInLstNr: TWordField;
    ffInLstAmtNr: TWordField;
    ffInLstNavn: TStringField;

    dsReLst: TDataSource;
    ffReLst: TnxTable;

    dsEks: TDataSource;

    dsLin: TDataSource;

    dsEksKar: TDataSource;
    ffEksKar: TnxTable;

    dsEksTil: TDataSource;
    ffEksTil: TnxTable;

    dsEksEtk: TDataSource;
    ffEksEtk: TnxTable;
    // ffEksLin
    dsEksLin: TDataSource;
    ffEksLin: TnxTable;
    ffEksLinLbNr: TIntegerField;
    ffEksLinLinieNr: TWordField;
    ffEksLinLinieType: TWordField;
    ffEksLinLager: TWordField;
    ffEksLinVareNr: TStringField;
    ffEksLinSubVareNr: TStringField;
    ffEksLinStatNr: TStringField;
    ffEksLinLokation1: TWordField;
    ffEksLinLokation2: TWordField;
    ffEksLinLokation3: TWordField;
    ffEksLinVareType: TWordField;
    ffEksLinVareGruppe: TWordField;
    ffEksLinStatGruppe: TWordField;
    ffEksLinOmsType: TWordField;
    ffEksLinNarkoType: TWordField;
    ffEksLinTilskType: TWordField;
    ffEksLinDKType: TWordField;
    ffEksLinTekst: TStringField;
    ffEksLinEnhed: TStringField;
    ffEksLinDyreArt: TWordField;
    ffEksLinAldersGrp: TWordField;
    ffEksLinOrdGrp: TWordField;
    ffEksLinUdlevMax: TWordField;
    ffEksLinUdlevNr: TWordField;
    ffEksLinAntal: TIntegerField;
    ffEksLinPris: TCurrencyField;
    ffEksLinKostPris: TCurrencyField;
    ffEksLinVareForbrug: TCurrencyField;
    ffEksLinBrutto: TCurrencyField;
    ffEksLinRabatPct: TCurrencyField;
    ffEksLinRabat: TCurrencyField;
    ffEksLinExMoms: TCurrencyField;
    ffEksLinInclMoms: TBooleanField;
    ffEksLinMomsPct: TCurrencyField;
    ffEksLinMoms: TCurrencyField;
    ffEksLinNetto: TCurrencyField;
    ffEksLinForm: TStringField;
    ffEksLinStyrke: TStringField;
    ffEksLinPakning: TStringField;
    ffEksLinATCType: TStringField;
    ffEksLinATCKode: TStringField;
    ffEksLinSSKode: TStringField;
    ffEksLinKlausul: TStringField;
    ffEksLinPAKode: TStringField;
    ffEksLinDDD: TIntegerField;
    ffEksLinUdLevType: TStringField;
    ffEksLinEjG: TWordField;
    ffEksLinEjO: TWordField;
    ffEksLinEjS: TWordField;
    // EksLin

    // EksTil
    ffEksTilESP: TCurrencyField;
    ffEksTilRFP: TCurrencyField;
    ffEksTilBGP: TCurrencyField;
    ffEksTilSaldo: TCurrencyField;
    ffEksTilIBPBel: TCurrencyField;
    ffEksTilBGPBel: TCurrencyField;
    ffEksTilIBTBel: TCurrencyField;
    ffEksTilUdligning: TCurrencyField;
    ffEksTilAndel: TCurrencyField;
    ffEksTilTilskSyg: TCurrencyField;
    ffEksTilTilskKom1: TCurrencyField;
    ffEksTilTilskKom2: TCurrencyField;
    ffEksTilRegelSyg: TWordField;
    ffEksTilRegelKom1: TWordField;
    ffEksTilRegelKom2: TWordField;
    ffEksTilPromilleSyg: TWordField;
    ffEksTilPromilleKom1: TWordField;
    ffEksTilPromilleKom2: TWordField;
    ffEksTilLbNr: TIntegerField;
    ffEksTilLinieNr: TWordField;
    ffEksTilAfdeling1: TStringField;
    ffEksTilAfdeling2: TStringField;
    ffEksTilCtrIndberettet: TWordField;
    // ffEksTil

    // ffEksEtk
    ffEksEtkLbNr: TIntegerField;
    ffEksEtkLinieNr: TWordField;
    ffEksEtkIndikKode: TStringField;
    ffEksEtkTxtKode: TStringField;
    ffEksEtkEtiket: TMemoField;
    // ffEksEtk

    // ffEksKar
    ffEksKarLbNr: TIntegerField;
    ffEksKarTurNr: TIntegerField;
    ffEksKarPakkeNr: TIntegerField;
    ffEksKarFakturaNr: TIntegerField;
    ffEksKarUdlignNr: TIntegerField;
    ffEksKarKundeNr: TStringField;
    ffEksKarFiktivtCprNr: TBooleanField;
    ffEksKarCprCheck: TBooleanField;
    ffEksKarEjSubstitution: TBooleanField;
    ffEksKarBarn: TBooleanField;
    ffEksKarKundeKlub: TBooleanField;
    ffEksKarKlubNr: TIntegerField;
    ffEksKarAmt: TWordField;
    ffEksKarKommune: TWordField;
    ffEksKarKundeType: TWordField;
    ffEksKarLandeKode: TWordField;
    ffEksKarCtrType: TWordField;
    ffEksKarFoedDato: TStringField;
    ffEksKarNarkoNr: TStringField;
    ffEksKarOrdreType: TWordField;
    ffEksKarOrdreStatus: TWordField;
    ffEksKarReceptStatus: TWordField;
    ffEksKarEkspType: TWordField;
    ffEksKarEkspForm: TWordField;
    ffEksKarDosStyring: TBooleanField;
    ffEksKarIndikStyring: TBooleanField;
    ffEksKarAntLin: TWordField;
    ffEksKarAntVarer: TWordField;
    ffEksKarDKMedlem: TWordField;
    ffEksKarDKAnt: TWordField;
    ffEksKarReceptDato: TDateTimeField;
    ffEksKarOrdreDato: TDateTimeField;
    ffEksKarTakserDato: TDateTimeField;
    ffEksKarKontrolDato: TDateTimeField;
    ffEksKarForfaldsdato: TDateTimeField;
    ffEksKarBrugerTakser: TWordField;
    ffEksKarBrugerKontrol: TWordField;
    ffEksKarBrugerAfslut: TWordField;
    ffEksKarTitel: TStringField;
    ffEksKarNavn: TStringField;
    ffEksKarAdr1: TStringField;
    ffEksKarAdr2: TStringField;
    ffEksKarPostNr: TStringField;
    ffEksKarLand: TStringField;
    ffEksKarKontakt: TStringField;
    ffEksKarTlfNr: TStringField;
    ffEksKarTlfNr2: TStringField;
    ffEksKarYderNr: TStringField;
    ffEksKarYderCprNr: TStringField;
    ffEksKarYderNavn: TStringField;
    ffEksKarKontoNr: TStringField;
    ffEksKarKontoNavn: TStringField;
    ffEksKarSprog: TWordField;
    ffEksKarAfdeling: TWordField;
    ffEksKarLager: TWordField;
    ffEksKarLeveringsForm: TWordField;
    ffEksKarBrutto: TCurrencyField;
    ffEksKarRabatLin: TCurrencyField;
    ffEksKarRabatPct: TCurrencyField;
    ffEksKarRabat: TCurrencyField;
    ffEksKarInclMoms: TBooleanField;
    ffEksKarExMoms: TCurrencyField;
    ffEksKarMomsPct: TCurrencyField;
    ffEksKarMoms: TCurrencyField;
    ffEksKarNetto: TCurrencyField;
    ffEksKarTilskAmt: TCurrencyField;
    ffEksKarDKTilsk: TCurrencyField;
    ffEksKarDKEjTilsk: TCurrencyField;
    ffEksKarNettoPriser: TBooleanField;
    ffEksKarAfsluttetDato: TDateTimeField;
    ffEksKarTilskKom: TCurrencyField;
    ffEksKarCtrIndberettet: TWordField;
    ffEksKarDKIndberettet: TWordField;
    ffEksKarUdbrGebyr: TCurrencyField;
    ffEksKarEdbGebyr: TCurrencyField;
    ffEksKarTlfGebyr: TCurrencyField;
    ffEksKarAndel: TCurrencyField;
    ffEksKarCtrSaldo: TCurrencyField;

    ffLinOvrEjG: TWordField;
    ffLinOvrEjO: TWordField;
    ffLinOvrEjS: TWordField;

    ffLagNvn: TnxTable;

    ffReLstNr: TWordField;
    ffReLstOperation: TStringField;
    ffReLstNavn: TStringField;
    ffReLstOrden: TWordField;

    ffPatUpd: TnxTable;

    ffTilUpd: TnxTable;

    ffPatUpdKundeNr: TStringField;
    ffPatUpdKundeType: TWordField;
    ffPatUpdCtrType: TWordField;
    ffPatUpdLandekode: TWordField;
    ffPatUpdFoedDato: TStringField;
    ffPatUpdLmsModtager: TStringField;
    ffPatUpdLmsUdsteder: TStringField;
    ffPatUpdTitel: TStringField;
    ffPatUpdCprCheck: TBooleanField;
    ffPatUpdFiktivtCprNr: TBooleanField;
    ffPatUpdNettoPriser: TBooleanField;
    ffPatUpdEjSubstitution: TBooleanField;
    ffPatUpdBarn: TBooleanField;
    ffPatUpdKundeKlub: TBooleanField;
    ffPatUpdKlubNr: TIntegerField;
    ffPatUpdNavn: TStringField;
    ffPatUpdAdr1: TStringField;
    ffPatUpdAdr2: TStringField;
    ffPatUpdPostNr: TStringField;
    ffPatUpdLand: TStringField;
    ffPatUpdKontakt: TStringField;
    ffPatUpdTlfNr: TStringField;
    ffPatUpdTlfNr2: TStringField;
    ffPatUpdMobil: TStringField;
    ffPatUpdFaxNr: TStringField;
    ffPatUpdMail: TStringField;
    ffPatUpdLink: TStringField;
    ffPatUpdDebitorNr: TStringField;
    ffPatUpdLevNr: TStringField;
    ffPatUpdYderNr: TStringField;
    ffPatUpdYderCprNr: TStringField;
    ffPatUpdDKMedlem: TWordField;
    ffPatUpdAmt: TWordField;
    ffPatUpdKommune: TWordField;
    ffPatUpdOpretDato: TDateTimeField;
    ffPatUpdRetDato: TDateTimeField;
    ffPatUpdVigtigBem: TMemoField;

    ffTilUpdKundeNr: TStringField;
    ffTilUpdOrden: TWordField;
    ffTilUpdRegel: TWordField;
    ffTilUpdFraDato: TDateTimeField;
    ffTilUpdTilDato: TDateTimeField;
    ffTilUpdPromille1: TWordField;
    ffTilUpdPromille2: TWordField;
    ffTilUpdPromille3: TWordField;
    ffTilUpdPromille4: TWordField;
    ffTilUpdPromille5: TWordField;
    ffTilUpdEgenbetaling: TCurrencyField;
    ffTilUpdAkkBetaling: TCurrencyField;
    ffTilUpdBetalType: TWordField;
    ffTilUpdBetalDato: TDateTimeField;
    ffTilUpdJournalNr: TStringField;
    ffTilUpdRefNr: TStringField;
    ffTilUpdChkJournalNr: TBooleanField;
    ffTilUpdTilskMetode: TWordField;
    ffTilUpdBevilling: TMemoField;

    ffAfdNvn: TnxTable;
    ffAfdNvnOperation: TStringField;
    ffAfdNvnNavn: TStringField;
    ffAfdNvnRefNr: TIntegerField;

    ffArbOpl: TnxTable;
    ffArbOplPladsNr: TIntegerField;
    ffArbOplAfdeling: TStringField;
    ffArbOplLager: TStringField;
    ffArbOplSpecLager: TStringField;
    ffArbOplNavn: TStringField;

    ffLagNvnOperation: TStringField;
    ffLagNvnNavn: TStringField;
    ffLagNvnRefNr: TIntegerField;

    ffReLstRefNr: TWordField;

    ffPatTilRef: TWordField;
    ffPatTilInstans: TStringField;

    ffFirma: TnxTable;
    ffFirmaNavn: TStringField;
    ffFirmaAfdeling: TStringField;
    ffFirmaLager: TStringField;

    ffRcpOpl: TnxTable;
    ffRcpOplLbNr: TIntegerField;
    ffRcpOplTurNr: TIntegerField;
    ffRcpOplPakkeNr: TIntegerField;
    ffRcpOplUdskrivPct: TCurrencyField;
    ffRcpOplAfrPerDKSt: TDateTimeField;
    ffRcpOplAfrPerDKSl: TDateTimeField;
    ffRcpOplAfrDiskDK: TWordField;
    ffRcpOplAfrPostDK: TIntegerField;
    ffRcpOplAfrLbNrDK: TIntegerField;
    ffRcpOplAfrFormDK: TStringField;
    ffRcpOplAfrPerSSSt: TDateTimeField;
    ffRcpOplAfrPerSSSl: TDateTimeField;
    ffRcpOplAfrDiskSS: TWordField;
    ffRcpOplAfrPostSS: TIntegerField;
    ffRcpOplAfrLbNrSS: TIntegerField;
    ffRcpOplAfrFormSS: TStringField;
    ffRcpOplAfrPerLMSSt: TDateTimeField;
    ffRcpOplAfrPerLMSSl: TDateTimeField;
    ffRcpOplAfrDiskLMS: TWordField;
    ffRcpOplAfrPostLMS: TIntegerField;
    ffRcpOplAfrLbNrLMS: TIntegerField;
    ffRcpOplAfrFormLMS: TStringField;
    ffRcpOplAfrPerKOMSt: TDateTimeField;
    ffRcpOplAfrPerKOMSl: TDateTimeField;
    ffRcpOplAfrDiskKOM: TWordField;
    ffRcpOplAfrPostKOM: TIntegerField;
    ffRcpOplAfrLbNrKOM: TIntegerField;
    ffRcpOplAfrFormKOM: TStringField;
    ffRcpOplTakstDatoGl: TDateTimeField;
    ffRcpOplTakstDatoAkt: TDateTimeField;
    ffRcpOplTakstDatoNy: TDateTimeField;
    ffRcpOplInteraktType: TStringField;
    ffRcpOplInteraktMdr: TWordField;
    ffRcpOplInteraktNiveau: TStringField;

    ffEksTilJournalNr1: TStringField;
    ffEksTilJournalNr2: TStringField;

    ffFirmaSpec1: TStringField;

    dsEksOvr: TDataSource;
    ffEksOvr: TnxTable;
    ffEksOvrLbNr: TIntegerField;
    ffEksOvrTurNr: TIntegerField;
    ffEksOvrPakkeNr: TIntegerField;
    ffEksOvrFakturaNr: TIntegerField;
    ffEksOvrUdlignNr: TIntegerField;
    ffEksOvrKundeNr: TStringField;
    ffEksOvrFiktivtCprNr: TBooleanField;
    ffEksOvrCprCheck: TBooleanField;
    ffEksOvrNettoPriser: TBooleanField;
    ffEksOvrEjSubstitution: TBooleanField;
    ffEksOvrBarn: TBooleanField;
    ffEksOvrAmt: TWordField;
    ffEksOvrKommune: TWordField;
    ffEksOvrKundeType: TWordField;
    ffEksOvrLandeKode: TWordField;
    ffEksOvrCtrType: TWordField;
    ffEksOvrCtrIndberettet: TWordField;
    ffEksOvrFoedDato: TStringField;
    ffEksOvrNarkoNr: TStringField;
    ffEksOvrOrdreType: TWordField;
    ffEksOvrOrdreStatus: TWordField;
    ffEksOvrReceptStatus: TWordField;
    ffEksOvrEkspType: TWordField;
    ffEksOvrEkspForm: TWordField;
    ffEksOvrDosStyring: TBooleanField;
    ffEksOvrIndikStyring: TBooleanField;
    ffEksOvrAntLin: TWordField;
    ffEksOvrAntVarer: TWordField;
    ffEksOvrDKMedlem: TWordField;
    ffEksOvrDKAnt: TWordField;
    ffEksOvrDKIndberettet: TWordField;
    ffEksOvrReceptDato: TDateTimeField;
    ffEksOvrOrdreDato: TDateTimeField;
    ffEksOvrTakserDato: TDateTimeField;
    ffEksOvrKontrolDato: TDateTimeField;
    ffEksOvrAfsluttetDato: TDateTimeField;
    ffEksOvrForfaldsdato: TDateTimeField;
    ffEksOvrBrugerTakser: TWordField;
    ffEksOvrBrugerKontrol: TWordField;
    ffEksOvrBrugerAfslut: TWordField;
    ffEksOvrKontrolFejl: TWordField;
    ffEksOvrTitel: TStringField;
    ffEksOvrNavn: TStringField;
    ffEksOvrAdr1: TStringField;
    ffEksOvrAdr2: TStringField;
    ffEksOvrPostNr: TStringField;
    ffEksOvrLand: TStringField;
    ffEksOvrKontakt: TStringField;
    ffEksOvrTlfNr: TStringField;
    ffEksOvrTlfNr2: TStringField;
    ffEksOvrYderNr: TStringField;
    ffEksOvrYderCprNr: TStringField;
    ffEksOvrYderNavn: TStringField;
    ffEksOvrKontoNr: TStringField;
    ffEksOvrKontoNavn: TStringField;
    ffEksOvrPrisGruppe: TWordField;
    ffEksOvrSprog: TWordField;
    ffEksOvrAfdeling: TWordField;
    ffEksOvrLager: TWordField;
    ffEksOvrLeveringsForm: TWordField;
    ffEksOvrVigtigBem: TMemoField;
    ffEksOvrBrutto: TCurrencyField;
    ffEksOvrRabatLin: TCurrencyField;
    ffEksOvrRabatPct: TCurrencyField;
    ffEksOvrRabat: TCurrencyField;
    ffEksOvrInclMoms: TBooleanField;
    ffEksOvrExMoms: TCurrencyField;
    ffEksOvrMomsPct: TCurrencyField;
    ffEksOvrMoms: TCurrencyField;
    ffEksOvrNetto: TCurrencyField;
    ffEksOvrTilskAmt: TCurrencyField;
    ffEksOvrTilskKom: TCurrencyField;
    ffEksOvrDKTilsk: TCurrencyField;
    ffEksOvrDKEjTilsk: TCurrencyField;

    dsLinOvr: TDataSource;
    ffLinOvr: TnxTable;
    ffLinOvrLbNr: TIntegerField;
    ffLinOvrLinieNr: TWordField;
    ffLinOvrLinieType: TWordField;
    ffLinOvrLager: TWordField;
    ffLinOvrVareNr: TStringField;
    ffLinOvrSubVareNr: TStringField;
    ffLinOvrStatNr: TStringField;
    ffLinOvrLokation1: TWordField;
    ffLinOvrLokation2: TWordField;
    ffLinOvrLokation3: TWordField;
    ffLinOvrVareType: TWordField;
    ffLinOvrVareGruppe: TWordField;
    ffLinOvrStatGruppe: TWordField;
    ffLinOvrOmsType: TWordField;
    ffLinOvrNarkoType: TWordField;
    ffLinOvrTilskType: TWordField;
    ffLinOvrDKType: TWordField;
    ffLinOvrTekst: TStringField;
    ffLinOvrEnhed: TStringField;
    ffLinOvrForm: TStringField;
    ffLinOvrStyrke: TStringField;
    ffLinOvrPakning: TStringField;
    ffLinOvrATCType: TStringField;
    ffLinOvrATCKode: TStringField;
    ffLinOvrSSKode: TStringField;
    ffLinOvrKlausul: TStringField;
    ffLinOvrPAKode: TStringField;
    ffLinOvrDDD: TIntegerField;
    ffLinOvrDyreArt: TWordField;
    ffLinOvrAldersGrp: TWordField;
    ffLinOvrOrdGrp: TWordField;
    ffLinOvrUdlevMax: TWordField;
    ffLinOvrUdlevNr: TWordField;
    ffLinOvrAntal: TIntegerField;
    ffLinOvrPris: TCurrencyField;
    ffLinOvrKostPris: TCurrencyField;
    ffLinOvrVareForbrug: TCurrencyField;
    ffLinOvrBrutto: TCurrencyField;
    ffLinOvrRabatPct: TCurrencyField;
    ffLinOvrRabat: TCurrencyField;
    ffLinOvrExMoms: TCurrencyField;
    ffLinOvrInclMoms: TBooleanField;
    ffLinOvrMomsPct: TCurrencyField;
    ffLinOvrMoms: TCurrencyField;
    ffLinOvrNetto: TCurrencyField;

    dsTilOvr: TDataSource;
    ffTilOvr: TnxTable;
    ffTilOvrLbNr: TIntegerField;
    ffTilOvrLinieNr: TWordField;
    ffTilOvrJournalNr1: TStringField;
    ffTilOvrJournalNr2: TStringField;
    ffTilOvrESP: TCurrencyField;
    ffTilOvrRFP: TCurrencyField;
    ffTilOvrBGP: TCurrencyField;
    ffTilOvrSaldo: TCurrencyField;
    ffTilOvrIBPBel: TCurrencyField;
    ffTilOvrBGPBel: TCurrencyField;
    ffTilOvrIBTBel: TCurrencyField;
    ffTilOvrUdligning: TCurrencyField;
    ffTilOvrAndel: TCurrencyField;
    ffTilOvrTilskSyg: TCurrencyField;
    ffTilOvrTilskKom1: TCurrencyField;
    ffTilOvrTilskKom2: TCurrencyField;
    ffTilOvrRegelSyg: TWordField;
    ffTilOvrRegelKom1: TWordField;
    ffTilOvrRegelKom2: TWordField;
    ffTilOvrPromilleSyg: TWordField;
    ffTilOvrPromilleKom1: TWordField;
    ffTilOvrPromilleKom2: TWordField;

    ffFirmaSupNavn: TStringField;

    dsLevFrm: TDataSource;

    ffEksFak: TnxTable;
    ffEksFakFakturaNr: TIntegerField;
    ffEksFakFakturaType: TStringField;
    ffEksFakUdlignNr: TIntegerField;
    ffEksFakKontoNr: TStringField;
    ffEksFakAfsluttetDato: TDateTimeField;
    ffEksFakForfaldsdato: TDateTimeField;
    ffEksFakKontoNavn: TStringField;
    ffEksFakKontoAdr1: TStringField;
    ffEksFakKontoAdr2: TStringField;
    ffEksFakKontoAdr3: TStringField;
    ffEksFakLevNavn: TStringField;
    ffEksFakLevAdr1: TStringField;
    ffEksFakLevAdr2: TStringField;
    ffEksFakLevAdr3: TStringField;
    ffEksFakKontoGruppe: TWordField;
    ffEksFakAfdeling: TWordField;
    ffEksFakLager: TWordField;
    ffEksFakKreditTekst: TStringField;
    ffEksFakLeveringsTekst: TStringField;
    ffEksFakPakkeseddel: TWordField;
    ffEksFakFaktura: TWordField;
    ffEksFakBetalingskort: TWordField;
    ffEksFakLeveringsseddel: TWordField;
    ffEksFakAdrEtiket: TWordField;
    ffEksFakBrutto: TCurrencyField;
    ffEksFakTilskAmt: TCurrencyField;
    ffEksFakTilskKom: TCurrencyField;
    ffEksFakPakkeRabat: TCurrencyField;
    ffEksFakFakturaRabat: TCurrencyField;
    ffEksFakUdbrGebyr: TCurrencyField;
    ffEksFakKontoGebyr: TCurrencyField;
    ffEksFakEDBGebyr: TCurrencyField;
    ffEksFakTlfRcpGebyr: TCurrencyField;
    ffEksFakNetto: TCurrencyField;
    ffEksFakExMoms: TCurrencyField;
    ffEksFakMoms: TCurrencyField;

    dsAfrEks: TDataSource;
    ffAfrEks: TnxTable;
    ffAfrEksLbNr: TIntegerField;
    ffAfrEksKundeNr: TStringField;
    ffAfrEksCprCheck: TBooleanField;
    ffAfrEksBarn: TBooleanField;
    ffAfrEksAmt: TWordField;
    ffAfrEksKommune: TWordField;
    ffAfrEksKundeType: TWordField;
    ffAfrEksCtrType: TWordField;
    ffAfrEksFoedDato: TStringField;
    ffAfrEksOrdreType: TWordField;
    ffAfrEksOrdreStatus: TWordField;
    ffAfrEksEkspType: TWordField;
    ffAfrEksEkspForm: TWordField;
    ffAfrEksAntLin: TWordField;
    ffAfrEksAfsluttetDato: TDateTimeField;
    ffAfrEksBrugerTakser: TWordField;

    dsAfrLin: TDataSource;
    ffAfrLin: TnxTable;
    ffAfrLinLbNr: TIntegerField;
    ffAfrLinLinieNr: TWordField;
    ffAfrLinLinieType: TWordField;
    ffAfrLinVareNr: TStringField;
    ffAfrLinSubVareNr: TStringField;
    ffAfrLinTilskType: TWordField;
    ffAfrLinUdlevMax: TWordField;
    ffAfrLinUdlevNr: TWordField;
    ffAfrLinAntal: TIntegerField;
    ffAfrLinPris: TCurrencyField;

    ffAfrTil: TnxTable;
    ffAfrTilLbNr: TIntegerField;
    ffAfrTilLinieNr: TWordField;
    ffAfrTilESP: TCurrencyField;
    ffAfrTilRFP: TCurrencyField;
    ffAfrTilBGP: TCurrencyField;
    ffAfrTilSaldo: TCurrencyField;
    ffAfrTilIBPBel: TCurrencyField;
    ffAfrTilBGPBel: TCurrencyField;
    ffAfrTilIBTBel: TCurrencyField;
    ffAfrTilUdligning: TCurrencyField;
    ffAfrTilAndel: TCurrencyField;
    ffAfrTilTilskSyg: TCurrencyField;
    ffAfrTilTilskKom1: TCurrencyField;
    ffAfrTilTilskKom2: TCurrencyField;
    ffAfrTilRegelSyg: TWordField;
    ffAfrTilRegelKom1: TWordField;
    ffAfrTilRegelKom2: TWordField;
    ffAfrTilPromilleSyg: TWordField;
    ffAfrTilPromilleKom1: TWordField;
    ffAfrTilPromilleKom2: TWordField;

    ffAfrEksYderNr: TStringField;

    ffFirmaAdresse1: TStringField;
    ffFirmaAdresse2: TStringField;
    ffFirmaPostNr: TStringField;
    ffFirmaByNavn: TStringField;
    ffFirmaSeNr: TStringField;
    ffFirmaGiroNr: TStringField;
    ffFirmaSpec2: TStringField;
    ffFirmaBankRegNr1: TStringField;
    ffFirmaBankKontoNr1: TStringField;

    ffAfrEksNarkoNr: TStringField;
    ffAfrEksYderCprNr: TStringField;
    ffAfrEksYderNavn: TStringField;
    ffAfrEksNavn: TStringField;
    ffAfrEksTakserDato: TDateTimeField;
    ffAfrEksPakkeNr: TIntegerField;
    ffAfrEksFakturaNr: TIntegerField;
    ffAfrEksLeveringsForm: TWordField;
    ffAfrEksFiktivtCprNr: TBooleanField;
    ffAfrEksNettoPriser: TBooleanField;

    ffAfrLinSSKode: TStringField;
    ffAfrLinTekst: TStringField;
    ffAfrLinForm: TStringField;
    ffAfrLinStyrke: TStringField;
    ffAfrLinPakning: TStringField;
    ffAfrLinBrutto: TCurrencyField;
    ffAfrLinDyreArt: TWordField;
    ffAfrLinAldersGrp: TWordField;
    ffAfrLinOrdGrp: TWordField;

    ffAfrTilJournalNr1: TStringField;
    ffAfrTilJournalNr2: TStringField;

    ffYdLstTlfNr: TStringField;

    ffEksFakAntalPakker: TSmallintField;

    cdCtrLan: TClientDataSet;
    cdCtrLanNr: TSmallintField;
    cdCtrLanNavn: TStringField;

    dsDyrArt: TDataSource;
    cdDyrArt: TClientDataSet;
    cdDyrArtNr: TSmallintField;
    cdDyrArtAnvendelse: TSmallintField;
    cdDyrArtAlder: TSmallintField;
    cdDyrArtOrdGrp: TSmallintField;
    cdDyrArtNavn: TStringField;

    dsDyrAld: TDataSource;
    cdDyrAld: TClientDataSet;
    cdDyrAldNr: TSmallintField;
    cdDyrAldGruppe: TSmallintField;
    cdDyrAldNavn: TStringField;

    dsDyrOrd: TDataSource;
    cdDyrOrd: TClientDataSet;
    cdDyrOrdNr: TSmallintField;
    cdDyrOrdGruppe: TSmallintField;
    cdDyrOrdNavn: TStringField;

    ffEksOvrEdbGebyr: TCurrencyField;
    ffEksOvrTlfGebyr: TCurrencyField;
    ffEksOvrUdbrGebyr: TCurrencyField;

    ffPatKarEjCtrReg: TBooleanField;

    ffAfrEksEdbGebyr: TCurrencyField;
    ffAfrEksTlfGebyr: TCurrencyField;
    ffAfrEksUdbrGebyr: TCurrencyField;

    ffEksEtkDosKode1: TStringField;
    ffEksEtkDosKode2: TStringField;

    dsEtkOvr: TDataSource;
    ffEtkOvr: TnxTable;

    ffAfrLinEjS: TWordField;
    ffAfrLinEjO: TWordField;
    ffAfrLinEjG: TWordField;
    ffAfrLinUdLevType: TStringField;

    ffPatTilAfdelingEj: TStringField;

    ffAfrTilAfdeling1: TStringField;
    ffAfrTilAfdeling2: TStringField;

    ffPatKarCtrUdDato: TDateTimeField;
    ffPatKarCtrSaldo: TCurrencyField;
    ffPatKarCtrStempel: TDateTimeField;
    ffPatKarCtrUdlign: TCurrencyField;
    ffPatKarCtrStatus: TSmallintField;

    dsCtrOpd: TDataSource;
    ffCtrOpd: TnxTable;
    ffCtrOpdNr: TIntegerField;
    ffCtrOpdDato: TDateTimeField;

    ffPatUpdEjCtrReg: TBooleanField;
    ffPatUpdCtrUdDato: TDateTimeField;
    ffPatUpdCtrSaldo: TCurrencyField;
    ffPatUpdCtrStempel: TDateTimeField;
    ffPatUpdCtrUdlign: TCurrencyField;
    ffPatUpdCtrStatus: TSmallintField;

    ffLinOvrUdLevType: TStringField;

    ffAfrEksAfdeling: TWordField;
    ffAfrEksKontoNr: TStringField;

    ffAfrLinKostPris: TCurrencyField;
    ffAfrLinVareForbrug: TCurrencyField;

    ffRetEks: TnxTable;

    ffRetLin: TnxTable;

    ffRetTil: TnxTable;

    ffRetEtk: TnxTable;

    ffEksKarOrdreNr: TIntegerField;

    ffTilOvrCtrIndberettet: TWordField;

    ffEksOvrAndel: TCurrencyField;
    ffEksOvrCtrSaldo: TCurrencyField;

    ffAtcTxt: TnxTable;
    ffAtcTxtKode: TStringField;
    ffAtcTxtIndikation1: TStringField;
    ffAtcTxtIndikation2: TStringField;
    ffAtcTxtIndikation3: TStringField;
    ffAtcTxtIndikation4: TStringField;
    ffAtcTxtIndikation5: TStringField;

    ffDosTxt: TnxTable;
    ffDosTxtKode: TStringField;
    ffDosTxtTekst1: TStringField;

    ffEtkOvrLbNr: TIntegerField;
    ffEtkOvrLinieNr: TWordField;
    ffEtkOvrIndikKode: TStringField;
    ffEtkOvrTxtKode: TStringField;
    ffEtkOvrEtiket: TMemoField;
    ffEtkOvrDosKode1: TStringField;
    ffEtkOvrDosKode2: TStringField;
    dsEdiRcp: TDataSource;
    ffRcpOplLmsNr: TStringField;
    ffRcpOplLmsPNr: TStringField;
    ffRcpOplSSRabat: TCurrencyField;
    ffRcpOplApoteksNr: TStringField;
    ffAfdNvnLmsPNr: TStringField;
    ffFirmaTlfNr: TStringField;
    ffFirmaTlfNr2: TStringField;
    ffFirmaMobil: TStringField;
    ffFirmaTelefax: TStringField;
    ffFirmaMail: TStringField;
    ffFrmTxt: TnxTable;
    ffRcpOplMomsPct: TCurrencyField;
    ffRcpOplEdbGebyr: TCurrencyField;
    ffRcpOplTlfGebyr: TCurrencyField;
    ffRcpOplUdbrGebyr: TCurrencyField;
    ffRcpOplKontoGebyr: TCurrencyField;
    ffRcpOplPakkeGebyr: TCurrencyField;
    ffRcpOplRcpGebyr: TCurrencyField;
    ffRcpOplRcpKontrol: TBooleanField;
    ffRcpOplPakSedUdsalg: TBooleanField;
    ffIntAkt: TnxTable;
    ffIntAktAtcKode1: TStringField;
    ffIntAktAtcKode2: TStringField;
    ffIntAktAdvNr: TWordField;
    ffIntAktAdvNiveau: TWordField;
    ffIntAktVejlNr: TWordField;
    ffIntAktStjerne: TBooleanField;
    ffIntTxt: TnxTable;
    ffIntTxtType: TWordField;
    ffIntTxtNr: TWordField;
    ffIntTxtTekst: TMemoField;
    dsIntAkt: TDataSource;
    dsIntTxt: TDataSource;
    ffEngine: TnxRemoteServerEngine;

    ffDebKar: TnxTable;
    ffDebKarKontoNr: TStringField;
    ffDebKarNavn: TStringField;
    ffDebKarAdr1: TStringField;
    ffDebKarAdr2: TStringField;
    ffDebKarPostNr: TStringField;
    ffDebKarLand: TStringField;
    ffDebKarKontakt: TStringField;
    ffDebKarTlfNr: TStringField;
    ffDebKarTlfNr2: TStringField;
    ffDebKarMobil: TStringField;
    ffDebKarFaxNr: TStringField;
    ffDebKarLevNavn: TStringField;
    ffDebKarLevAdr1: TStringField;
    ffDebKarLevAdr2: TStringField;
    ffDebKarLevPostNr: TStringField;
    ffDebKarLevLand: TStringField;
    ffDebKarLevKontakt: TStringField;
    ffDebKarLevTlfNr: TStringField;
    ffDebKarCvrNr: TStringField;
    ffDebKarGiroNr: TStringField;
    ffDebKarAfdeling: TWordField;
    ffDebKarLager: TWordField;
    ffDebKarDebType: TWordField;
    ffDebKarDebGruppe: TWordField;
    ffDebKarKreditForm: TWordField;
    ffDebKarBetalForm: TWordField;
    ffDebKarLevForm: TWordField;
    ffDebKarRabatType: TWordField;
    ffDebKarRenteType: TWordField;
    ffDebKarSaldoType: TWordField;
    ffDebKarValutaType: TWordField;
    ffDebKarMomsType: TWordField;
    ffDebKarKreditMax: TCurrencyField;
    ffDebKarAvancePct: TCurrencyField;
    ffDebKarPrimo: TCurrencyField;
    ffDebKarSaldo: TCurrencyField;
    ffDebKarKontoGebyr: TBooleanField;
    ffDebKarKontoLukket: TBooleanField;
    ffDebKarLukketGrund: TStringField;
    ffDebKarRenteDato: TDateTimeField;
    ffDebKarBevDato: TDateTimeField;
    ffDebKarOpretDato: TDateTimeField;
    ffDebKarRetDato: TDateTimeField;
    ffDebKarGebyrDato: TDateTimeField;
    ffDebKarBem: TMemoField;
    ffPatKarLuDebNavn: TStringField;
    ffDebKarBy: TStringField;
    ffDebKarLuLevTxt: TStringField;
    ffLevFrm: TnxTable;
    ffLevFrmNr: TWordField;
    ffLevFrmOperation: TStringField;
    ffLevFrmNavn: TStringField;
    ffLevFrmUdbringningsGebyr: TBooleanField;
    ffLevFrmPakkeGebyr: TBooleanField;
    ffDebKarLuLevUdbr: TBooleanField;
    ffDebKarLuLevPakke: TBooleanField;
    ffDebKarLuKreditTxt: TStringField;
    dsDebKar: TDataSource;
    ffDebKarFaktForm: TWordField;
    ffDebKarUdbrGebyr: TBooleanField;
    cdCtrBev: TClientDataSet;
    dsCtrBev: TDataSource;
    cdCtrBevRegel: TWordField;
    cdCtrBevFraDato: TDateTimeField;
    cdCtrBevTilDato: TDateTimeField;
    cdCtrBevIndDato: TDateTimeField;
    cdCtrBevAtc: TStringField;
    cdCtrBevLmNavn: TStringField;
    cdCtrBevAdmVej: TStringField;
    cdCtrBevVareNr: TStringField;
    ffPatKarLuDebSaldo: TCurrencyField;
    ffDosTxtTekst2: TStringField;
    ffLagKar: TnxTable;
    ffLagKarLager: TWordField;
    ffLagKarVareNr: TStringField;
    ffLagKarEanKode: TStringField;
    ffLagKarSamPakNr: TStringField;
    ffLagKarSamPakAnt: TWordField;
    ffLagKarGrNr1: TWordField;
    ffLagKarLokation1: TIntegerField;
    ffLagKarLokation2: TIntegerField;
    ffLagKarEgenGrp1: TIntegerField;
    ffLagKarEgenGrp2: TIntegerField;
    ffLagKarEgenGrp3: TIntegerField;
    ffLagKarMinimum: TIntegerField;
    ffLagKarAntal: TIntegerField;
    ffLagKarSampakAfr: TBooleanField;
    ffLagKarKostPris: TCurrencyField;
    ffLagKarVareType: TWordField;
    ffLagKarSalgsPris: TCurrencyField;
    ffLagKarEgenPris: TCurrencyField;
    ffLagKarSletDato: TDateTimeField;
    ffPatKarLevNr: TStringField;
    ffPatKarLuLevNavn: TStringField;
    ffEksKarLevNavn: TStringField;
    ffEksOvrLevNavn: TStringField;
    ffEksKarBy: TStringField;
    cdDspFrm: TClientDataSet;
    cdDspFrmVareNr: TStringField;
    cdDspFrmDispForm: TStringField;
    ffCtrOpdStatus: TIntegerField;
    ffCtrOpdTiNr: TIntegerField;
    ffCtrOpdCtr: TBooleanField;
    ffCtrOpdPem: TBooleanField;
    ffCtrOpdDosKode: TWordField;
    ffCtrOpdIndKode: TWordField;
    cdDosTxt: TClientDataSet;
    cdDosTxtNr: TStringField;
    cdDosTxtTekst: TStringField;
    cdDosTxtEnhDgn: TStringField;
    cdIndTxt: TClientDataSet;
    cdIndTxtNr: TStringField;
    cdIndTxtTekst: TStringField;
    ffAfrEtk: TnxTable;
    ffAfrEtkLbNr: TIntegerField;
    ffAfrEtkLinieNr: TWordField;
    ffAfrEtkIndikKode: TStringField;
    ffAfrEtkDosKode1: TStringField;
    ffAfrEtkDosKode: TStringField;
    ffEksEtkDosKode: TStringField;
    ffPnLst: TnxTable;
    fqKto: TnxQuery;
    dsKto: TDataSource;
    dsGro: TDataSource;
    ffPnLstPostNr: TStringField;
    ffPnLstByNavn: TStringField;
    ffPatTilAtcKode: TStringField;
    ffPatTilVareNr: TStringField;
    ffPatTilProdukt: TStringField;
    ffPatTilDebitorNr: TStringField;
    ffDebKarMaster: TBooleanField;
    ffDebKarMasterFra: TStringField;
    ffDebKarMasterTil: TStringField;
    ffPatKarKontakt: TStringField;

    ffdch: TnxTable;
    ffdchCardNumber: TWordField;
    ffdchPatientNumber: TStringField;
    ffdchPatientName: TStringField;
    ffdchPatientAddress1: TStringField;
    ffdchPatientAddress2: TStringField;
    ffdchPostnummer: TStringField;
    ffdchDeliveryAddress: TStringField;
    ffdchKontaktPerson: TStringField;
    ffdchDoctorNumber: TStringField;
    ffdchDoctorName: TStringField;
    ffdchTelegram: TWordField;
    ffdchStartDate: TDateTimeField;
    ffdchEndDate: TDateTimeField;
    ffdchInterval: TWordField;
    ffdchAddDate: TDateTimeField;
    ffdchAdduser: TIntegerField;
    ffdchChangeDate: TDateTimeField;
    ffdchChangeUser: TIntegerField;
    ffdchDeleteDate: TDateTimeField;
    ffdchDeleteUser: TIntegerField;
    ffdchPackGroupNumber: TIntegerField;
    ffdchDoctorComment: TStringField;
    ffdchPharmacistComment: TStringField;
    ffdchDosiskod: TStringField;
    ffdchSendDate: TDateTimeField;
    ffdchKontroller: TIntegerField;
    ffdchKontrolDate: TDateTimeField;
    ffdchStartDay: TStringField;

    ffdcl: TnxTable;
    ffdclCardNumber: TWordField;
    ffdclVareNummer: TStringField;
    ffdclDrugid: TStringField;
    ffdclRegularDose: TBooleanField;
    ffdclDays: TStringField;
    ffdclQuantity1: TFloatField;
    ffdclQuantity2: TFloatField;
    ffdclQuantity3: TFloatField;
    ffdclQuantity4: TFloatField;
    ffdclQuantity5: TFloatField;
    ffdclQuantity6: TFloatField;
    ffdclQuantity7: TFloatField;
    ffdclQuantity8: TFloatField;
    ffdclVareDescription: TStringField;
    ffdclVareIndikation: TStringField;
    ffdclVareName: TStringField;
    ffdclVareIntake: TStringField;
    ffdclTotalQuantity: TIntegerField;
    dsdch: TDataSource;
    fqSqlSel: TnxQuery;
    ffLagKarAtcKode: TStringField;
    ffLagKarSalgsPris2: TCurrencyField;
    ffLagKarDrugId: TStringField;
    ffLagKarNavn: TStringField;
    ffLagKarForm: TStringField;
    ffLagKarStyrke: TStringField;
    ffLagKarPakning: TStringField;
    ffLagKarPaKode: TStringField;
    ffLagKarUdlevType: TStringField;
    ffLagKarHaType: TStringField;
    ffLagKarSSKode: TStringField;
    ffLagKarSalgsled: TStringField;
    ffLagKarAtcType: TStringField;
    ffLagKarSubEnhPris: TCurrencyField;
    ffLagKarAfmDato: TDateTimeField;
    ffLagKarSubst: TBooleanField;
    ffLagKarDoKostPris: TCurrencyField;
    ffLagKarDoSalgsPris: TCurrencyField;
    ffLagKarDoBGP: TCurrencyField;
    ffLagKarBGP: TCurrencyField;
    ffAfrEksLager: TWordField;
    ffVmLst: TnxTable;
    dsVmLst: TDataSource;
    ffVmLstVareNr: TStringField;
    ffVmLstAtcKode: TStringField;
    ffVmLstKostPris: TCurrencyField;
    ffVmLstSalgsPris: TCurrencyField;
    ffVmLstEgenPris: TCurrencyField;
    ffVmLstNavn: TStringField;
    ffVmLstStyrke: TStringField;
    ffVmLstPakning: TStringField;
    ffVmLstSubGrp: TWordField;
    ffVmLstBGP: TCurrencyField;
    ffVmLstSubForValg: TStringField;
    ffVmLstPaKode: TStringField;
    ffVmLstSubKode: TStringField;
    ffVmLstLager: TWordField;
    ffLagKarDelPakUdskAnt: TWordField;
    ffEksOvrLMSModtager: TStringField;
    ffEksKarLMSModtager: TStringField;
    nxTCPIPTrans: TnxWinsockTransport;
    ffAfrEksLMSModtager: TStringField;
    dsRetLin: TDataSource;
    ffLagKarRestOrdre: TIntegerField;
    nxEksCred: TnxTable;
    ffLagKarSubKode: TStringField;
    nxKombi: TnxQuery;
    ffLagKarPaknNum: TIntegerField;
    fqLevList: TnxQuery;
    fqOpenEDI: TnxQuery;
    fqEksOvr: TnxQuery;
    nxRSEksp: TnxTable;
    nxRSEkspLin: TnxTable;
    dsRSEksp: TDataSource;
    nxRSEkspPrescriptionId: TStringField;
    nxRSEkspReceptId: TIntegerField;
    nxRSEkspLbNr: TIntegerField;
    nxRSEkspDato: TDateTimeField;
    nxRSEkspOrdAnt: TIntegerField;
    nxRSEkspSenderId: TStringField;
    nxRSEkspSenderType: TStringField;
    nxRSEkspSenderNavn: TStringField;
    nxRSEkspSenderVej: TStringField;
    nxRSEkspSenderPostNr: TStringField;
    nxRSEkspSenderTel: TStringField;
    nxRSEkspSenderSpecKode: TStringField;
    nxRSEkspIssuerAutNr: TStringField;
    nxRSEkspIssuerCPRNr: TStringField;
    nxRSEkspIssuerTitel: TStringField;
    nxRSEkspIssuerSpecKode: TStringField;
    nxRSEkspIssuerType: TStringField;
    nxRSEkspSenderSystem: TStringField;
    nxRSEkspPatCPR: TStringField;
    nxRSEkspPatEftNavn: TStringField;
    nxRSEkspPatForNavn: TStringField;
    nxRSEkspPatVej: TStringField;
    nxRSEkspPatBy: TStringField;
    nxRSEkspPatPostNr: TStringField;
    nxRSEkspPatLand: TStringField;
    nxRSEkspPatAmt: TStringField;
    nxRSEkspPatFoed: TStringField;
    nxRSEkspPatKoen: TStringField;
    nxRSEkspOrdreInstruks: TStringField;
    nxRSEkspLeveringsInfo: TStringField;
    nxRSEkspLeveringPri: TStringField;
    nxRSEkspLeveringAdresse: TStringField;
    nxRSEkspLeveringPseudo: TStringField;
    nxRSEkspLeveringPostNr: TStringField;
    nxRSEkspLeveringKontakt: TStringField;
    nxRSEkspLinReceptId: TIntegerField;
    nxRSEkspLinOrdId: TStringField;
    nxRSEkspLinOrdNr: TIntegerField;
    nxRSEkspLinVersion: TStringField;
    nxRSEkspLinOpretDato: TStringField;
    nxRSEkspLinVarenNr: TStringField;
    nxRSEkspLinNavn: TStringField;
    nxRSEkspLinForm: TStringField;
    nxRSEkspLinStyrke: TStringField;
    nxRSEkspLinMagistrel: TStringField;
    nxRSEkspLinPakning: TStringField;
    nxRSEkspLinAntal: TIntegerField;
    nxRSEkspLinImportKort: TStringField;
    nxRSEkspLinImportLangt: TStringField;
    nxRSEkspLinKlausulbetingelse: TStringField;
    nxRSEkspLinSubstKode: TStringField;
    nxRSEkspLinDosKode: TStringField;
    nxRSEkspLinDosTekst: TStringField;
    nxRSEkspLinDosPeriod: TStringField;
    nxRSEkspLinDosEnhed: TStringField;
    nxRSEkspLinIndCode: TStringField;
    nxRSEkspLinIndText: TStringField;
    nxRSEkspLinTakstVersion: TStringField;
    nxRSEkspLinIterationNr: TIntegerField;
    nxRSEkspLinIterationInterval: TIntegerField;
    nxRSEkspLinIterationType: TStringField;
    nxRSEkspLinSupplerende: TStringField;
    nxRSEkspLinDosStartDato: TStringField;
    nxRSEkspLinDosSlutDato: TStringField;
    nxRSEkspLinAdminCount: TIntegerField;
    mtLin: TClientDataSet;
    mtLinLinieNr: TSmallintField;
    mtLinLinieType: TSmallintField;
    mtLinLager: TSmallintField;
    mtLinVareNr: TStringField;
    mtLinSubVareNr: TStringField;
    mtLinEjS: TBooleanField;
    mtLinVareType: TSmallintField;
    mtLinOmsType: TSmallintField;
    mtLinNarkoType: TSmallintField;
    mtLinTilskType: TSmallintField;
    mtLinTekst: TStringField;
    mtLinEnhed: TStringField;
    mtLinDyreArt: TSmallintField;
    mtLinAldersGrp: TSmallintField;
    mtLinOrdGrp: TSmallintField;
    mtLinUdlevNr: TSmallintField;
    mtLinUdlevMax: TSmallintField;
    mtLinAntal: TIntegerField;
    mtLinPris: TCurrencyField;
    mtLinKostPris: TCurrencyField;
    mtLinBrutto: TCurrencyField;
    mtLinRabatPct: TCurrencyField;
    mtLinRabat: TCurrencyField;
    mtLinInclMoms: TBooleanField;
    mtLinSSKode: TStringField;
    mtLinESP: TCurrencyField;
    mtLinBGP: TCurrencyField;
    mtLinUdligning: TCurrencyField;
    mtLinRegelSyg: TSmallintField;
    mtLinTilskSyg: TCurrencyField;
    mtLinRegelKom1: TSmallintField;
    mtLinTilskKom1: TCurrencyField;
    mtLinRegelKom2: TSmallintField;
    mtLinTilskKom2: TCurrencyField;
    mtLinAndel: TCurrencyField;
    mtLinDKType: TSmallintField;
    mtLinDkTilsk: TCurrencyField;
    mtLinDkEjTilsk: TCurrencyField;
    mtLinGlSaldo: TCurrencyField;
    mtLinIBPBel: TCurrencyField;
    mtLinIBTBel: TCurrencyField;
    mtLinBGPBel: TCurrencyField;
    mtLinNySaldo: TCurrencyField;
    mtLinPromilleSyg: TSmallintField;
    mtLinPromilleKom1: TSmallintField;
    mtLinPromilleKom2: TSmallintField;
    mtLinDosering1: TStringField;
    mtLinDosering2: TStringField;
    mtLinIndikation: TStringField;
    mtLinFolgeTxt: TStringField;
    mtLinAfdeling1: TStringField;
    mtLinAfdeling2: TStringField;
    mtLinAfdeling1Ej: TStringField;
    mtLinAfdeling2Ej: TStringField;
    mtLinJournalNr1: TStringField;
    mtLinJournalNr2: TStringField;
    mtLinChkJrnlNr1: TBooleanField;
    mtLinChkJrnlNr2: TBooleanField;
    mtLinForm: TStringField;
    mtLinStyrke: TStringField;
    mtLinPakning: TStringField;
    mtLinATCType: TStringField;
    mtLinATCKode: TStringField;
    mtLinPAKode: TStringField;
    mtLinUdLevType: TStringField;
    mtLinHaType: TStringField;
    mtLinSubstValg: TSmallintField;
    mtLinEtk1: TStringField;
    mtLinEtk2: TStringField;
    mtLinEtk3: TStringField;
    mtLinEtk4: TStringField;
    mtLinEtk5: TStringField;
    mtLinEtk6: TStringField;
    mtLinEtk7: TStringField;
    mtLinEtk8: TStringField;
    mtLinEtk9: TStringField;
    mtLinEtk10: TStringField;
    mtLinEtkLin: TSmallintField;
    mtLinValideret: TBooleanField;
    mtLinReitereret: TBooleanField;
    mtLinLokation1: TIntegerField;
    mtLinLokation2: TIntegerField;
    mtLinEtkMemo: TMemoField;
    nxOpenPakke: TnxQuery;
    ffPatKarLuPbs: TWordField;
    dsKomEan: TDataSource;
    cdKomEan: TClientDataSet;
    nqTilEan: TnxQuery;
    ffTilUpdAfdeling: TStringField;
    nqTilEanKundeNr: TStringField;
    nqTilEanKommune: TWordField;
    cdKomEanKommuneNr: TWordField;
    cdKomEanNavn: TStringField;
    cdKomEanRegelNr: TWordField;
    cdKomEanEanNr: TStringField;
    cdKomEanFriTekst: TStringField;
    ffDebKarEFaktEanKode: TStringField;
    mtLinOrdId: TStringField;
    mtLinReceptId: TIntegerField;
    nxRSEkspLinLbNr: TIntegerField;
    nxRSEkspLinLinieNr: TWordField;
    nxRSEkspLinAdminID: TIntegerField;
    nxRSEkspLinAdminDate: TStringField;
    nxDebAfd: TnxTable;
    nxDebLag: TnxTable;
    dsDebAfd: TDataSource;
    dsDebLag: TDataSource;
    nxDebAfdNavn: TStringField;
    nxDebLagNavn: TStringField;
    nxDebLagRefNr: TIntegerField;
    nxDebAfdRefNr: TIntegerField;
    ffEksOvrReceptId: TIntegerField;
    nxAfdeling: TnxTable;
    nxAfdelingType: TStringField;
    nxAfdelingOperation: TStringField;
    nxAfdelingNavn: TStringField;
    nxAfdelingRefNr: TIntegerField;
    nxAfdelingLmsPNr: TStringField;
    nxAfdelingLmsNr: TStringField;
    nxSettings: TnxTable;
    nxSettingsId: TIntegerField;
    nxSettingsLokationNr: TStringField;
    nxSettingsSubstLokationNr: TStringField;
    nxSettingsAfdeling: TIntegerField;
    nxSettingsPrinterNavn1: TStringField;
    nxSettingsPrinterSkuffe1: TStringField;
    nxSettingsPrinterNavn2: TStringField;
    nxSettingsPrinterSkuffe2: TStringField;
    nxSettingsReceptNo: TIntegerField;
    nxSettingsPNummer: TStringField;
    nxSettingsAfdelingNavn: TStringField;
    nxRSEkspList: TnxTable;
    nxRSEkspListReceptId: TIntegerField;
    nxRSEkspListLbNr: TIntegerField;
    nxRSEkspListDato: TDateTimeField;
    nxRSEkspListOrdAnt: TIntegerField;
    nxRSEkspListPatCPR: TStringField;
    nxRSEkspListPatForNavn: TStringField;
    nxRSEkspListPatEftNavn: TStringField;
    nxRSEkspListSenderId: TStringField;
    nxRSEkspListSenderNavn: TStringField;
    nxRSEkspListIssuerTitel: TStringField;
    nxRSEkspListIssuerAutNr: TStringField;
    nxRSEkspListIssuerCPRNr: TStringField;
    nxRSEkspListIssuerSpecKode: TStringField;
    nxRSEkspListIssuerType: TStringField;
    nxRSEkspListSenderSystem: TStringField;
    nxRSEkspListSenderVej: TStringField;
    nxRSEkspListSenderPostNr: TStringField;
    nxRSEkspListSenderTel: TStringField;
    nxRSEkspListSenderSpecKode: TStringField;
    nxRSEkspListPatLand: TStringField;
    nxRSEkspListPatAmt: TStringField;
    nxRSEkspListPatVej: TStringField;
    nxRSEkspListPatBy: TStringField;
    nxRSEkspListPatPostNr: TStringField;
    nxRSEkspListPatFoed: TStringField;
    nxRSEkspListPatKoen: TStringField;
    nxRSEkspListOrdreInstruks: TStringField;
    nxRSEkspListLeveringsInfo: TStringField;
    nxRSEkspListLeveringPri: TStringField;
    nxRSEkspListLeveringAdresse: TStringField;
    nxRSEkspListLeveringPseudo: TStringField;
    nxRSEkspListLeveringPostNr: TStringField;
    nxRSEkspListLeveringKontakt: TStringField;
    nxRSEkspListPrescriptionId: TStringField;
    nxRSEkspListSenderType: TStringField;
    nxRSEkspLinList: TnxTable;
    nxRSEkspLinListOrdId: TStringField;
    nxRSEkspLinListOrdNr: TIntegerField;
    nxRSEkspLinListVarenNr: TStringField;
    nxRSEkspLinListNavn: TStringField;
    nxRSEkspLinListForm: TStringField;
    nxRSEkspLinListStyrke: TStringField;
    nxRSEkspLinListPakning: TStringField;
    nxRSEkspLinListAntal: TIntegerField;
    nxRSEkspLinListIterationNr: TIntegerField;
    nxRSEkspLinListSubstKode: TStringField;
    nxRSEkspLinListDosStartDato: TStringField;
    nxRSEkspLinListDosSlutDato: TStringField;
    nxRSEkspLinListDosKode: TStringField;
    nxRSEkspLinListIndCode: TStringField;
    nxRSEkspLinListIterationInterval: TIntegerField;
    nxRSEkspLinListIterationType: TStringField;
    nxRSEkspLinListSupplerende: TStringField;
    nxRSEkspLinListImportKort: TStringField;
    nxRSEkspLinListImportLangt: TStringField;
    nxRSEkspLinListKlausulbetingelse: TStringField;
    nxRSEkspLinListDosTekst: TStringField;
    nxRSEkspLinListDosPeriod: TStringField;
    nxRSEkspLinListDosEnhed: TStringField;
    nxRSEkspLinListIndText: TStringField;
    nxRSEkspLinListReceptId: TIntegerField;
    nxRSEkspLinListMagistrel: TStringField;
    nxRSEkspLinListOpretDato: TStringField;
    nxRSEkspLinListAdminCount: TIntegerField;
    nxRSEkspLinListTakstVersion: TStringField;
    nxRSEkspLinListVersion: TStringField;
    dsEkspList: TDataSource;
    dsEkspLinList: TDataSource;
    nxStoredProc1: TnxStoredProc;
    dsStoredProc: TDataSource;
    nxRSEkspListOrdreStatus: TIntegerField;
    nxRSEkspLinListLbNr: TIntegerField;
    nxRSQueue: TnxTable;
    nxRSQueueLbnr: TIntegerField;
    nxRSQueueDato: TDateTimeField;
    nxRSEkspLinListLinieNr: TWordField;
    ffDebKarLuBetalOpr: TStringField;
    ffDebKarLuBetalTxt: TStringField;
    nxCTRinf: TnxTable;
    nxCTRinfKundeNr: TStringField;
    nxCTRinfUpdateTime: TDateTimeField;
    nxCTRinfpt_barn: TBooleanField;
    nxCTRinfpt_type: TIntegerField;
    nxCTRinff_pension: TBooleanField;
    nxCTRinfsaldo: TCurrencyField;
    nxCTRinfudlign_tilskud: TCurrencyField;
    nxCTRinfslutdato: TDateTimeField;
    nxCTRinfstartdato: TDateTimeField;
    nxCTRinfvarighed: TIntegerField;
    nxCTRinfbev_indb: TDateTimeField;
    nxCTRinffor_udlign_tilskud: TCurrencyField;
    nxCTRinffor_slutdato: TDateTimeField;
    nxCTRinfh_komnr: TIntegerField;
    nxCTRinfh_ean_lok: TStringField;
    nxCTRinfh_sats: TIntegerField;
    nxCTRBev: TnxTable;
    nxCTRBevKundeNr: TStringField;
    nxCTRBevRegel: TIntegerField;
    nxCTRBevFraDato: TDateTimeField;
    nxCTRBevTilDato: TDateTimeField;
    nxCTRBevIndbDato: TDateTimeField;
    nxCTRBevVareNr: TStringField;
    nxCTRBevAtc: TStringField;
    nxCTRBevLmNavn: TStringField;
    nxCTRBevAdmVej: TStringField;
    nxCTRBevVarighed: TIntegerField;
    nxCTRBevh_komnr: TIntegerField;
    nxCTRBevh_ean_lok: TStringField;
    nxCTRBevh_sats: TIntegerField;
    dsnxCTRBev: TDataSource;
    cdDrgDos: TClientDataSet;
    cdDrgDosId: TStringField;
    cdDrgDosNr: TStringField;
    cdDrgInd: TClientDataSet;
    cdDrgIndId: TStringField;
    cdDrgIndNr: TStringField;
    nxSettingsPapirType1: TIntegerField;
    nxSettingsPapirType2: TIntegerField;
    nxFaktQuery: TnxQuery;
    nxFaktQueryLbNr: TIntegerField;
    nxFaktQueryTurNr: TIntegerField;
    nxFaktQueryPakkeNr: TIntegerField;
    nxFaktQueryFakturaNr: TIntegerField;
    nxFaktQueryUdlignNr: TIntegerField;
    nxFaktQueryKundeNr: TStringField;
    nxFaktQueryFiktivtCprNr: TBooleanField;
    nxFaktQueryCprCheck: TBooleanField;
    nxFaktQueryNettoPriser: TBooleanField;
    nxFaktQueryEjSubstitution: TBooleanField;
    nxFaktQueryBarn: TBooleanField;
    nxFaktQueryKundeKlub: TBooleanField;
    nxFaktQueryKlubNr: TIntegerField;
    nxFaktQueryAmt: TWordField;
    nxFaktQueryKommune: TWordField;
    nxFaktQueryKundeType: TWordField;
    nxFaktQueryLandeKode: TWordField;
    nxFaktQueryCtrType: TWordField;
    nxFaktQueryCtrIndberettet: TWordField;
    nxFaktQueryAlder: TSmallintField;
    nxFaktQueryFoedDato: TStringField;
    nxFaktQueryNarkoNr: TStringField;
    nxFaktQueryOrdreType: TWordField;
    nxFaktQueryOrdreStatus: TWordField;
    nxFaktQueryReceptStatus: TWordField;
    nxFaktQueryEkspType: TWordField;
    nxFaktQueryEkspForm: TWordField;
    nxFaktQueryDosStyring: TBooleanField;
    nxFaktQueryIndikStyring: TBooleanField;
    nxFaktQueryAntLin: TWordField;
    nxFaktQueryAntVarer: TWordField;
    nxFaktQueryDKMedlem: TWordField;
    nxFaktQueryDKAnt: TWordField;
    nxFaktQueryDKIndberettet: TWordField;
    nxFaktQueryReceptDato: TDateTimeField;
    nxFaktQueryOrdreDato: TDateTimeField;
    nxFaktQueryTakserDato: TDateTimeField;
    nxFaktQueryKontrolDato: TDateTimeField;
    nxFaktQueryAfsluttetDato: TDateTimeField;
    nxFaktQueryForfaldsdato: TDateTimeField;
    nxFaktQueryBrugerTakser: TWordField;
    nxFaktQueryBrugerKontrol: TWordField;
    nxFaktQueryBrugerAfslut: TWordField;
    nxFaktQueryKontrolFejl: TWordField;
    nxFaktQueryTitel: TStringField;
    nxFaktQueryNavn: TStringField;
    nxFaktQueryAdr1: TStringField;
    nxFaktQueryAdr2: TStringField;
    nxFaktQueryPostNr: TStringField;
    nxFaktQueryLand: TStringField;
    nxFaktQueryKontakt: TStringField;
    nxFaktQueryTlfNr: TStringField;
    nxFaktQueryTlfNr2: TStringField;
    nxFaktQueryLevNavn: TStringField;
    nxFaktQueryLevAdr1: TStringField;
    nxFaktQueryLevAdr2: TStringField;
    nxFaktQueryLevPostNr: TStringField;
    nxFaktQueryLevLand: TStringField;
    nxFaktQueryLevKontakt: TStringField;
    nxFaktQueryLevTlfNr: TStringField;
    nxFaktQueryYderNr: TStringField;
    nxFaktQueryYderCprNr: TStringField;
    nxFaktQueryYderNavn: TStringField;
    nxFaktQueryYderTlfNr: TStringField;
    nxFaktQueryKontoNr: TStringField;
    nxFaktQueryKontoNavn: TStringField;
    nxFaktQueryKontoAdr1: TStringField;
    nxFaktQueryKontoAdr2: TStringField;
    nxFaktQueryKontoPostNr: TStringField;
    nxFaktQueryKontoLand: TStringField;
    nxFaktQueryKontoKontakt: TStringField;
    nxFaktQueryKontoTlf: TStringField;
    nxFaktQueryKontoGruppe: TWordField;
    nxFaktQueryRabatGruppe: TWordField;
    nxFaktQueryPrisGruppe: TWordField;
    nxFaktQueryStatGruppe: TWordField;
    nxFaktQuerySprog: TWordField;
    nxFaktQueryAfdeling: TWordField;
    nxFaktQueryLager: TWordField;
    nxFaktQueryKreditForm: TWordField;
    nxFaktQueryBetalingsForm: TWordField;
    nxFaktQueryLeveringsForm: TWordField;
    nxFaktQueryPakkeseddel: TWordField;
    nxFaktQueryFaktura: TWordField;
    nxFaktQueryBetalingskort: TWordField;
    nxFaktQueryLeveringsseddel: TWordField;
    nxFaktQueryAdrEtiket: TWordField;
    nxFaktQueryVigtigBem: TnxMemoField;
    nxFaktQueryAfstempling: TnxMemoField;
    nxFaktQueryBrutto: TCurrencyField;
    nxFaktQueryRabatLin: TCurrencyField;
    nxFaktQueryRabatPct: TCurrencyField;
    nxFaktQueryRabat: TCurrencyField;
    nxFaktQueryInclMoms: TBooleanField;
    nxFaktQueryExMoms: TCurrencyField;
    nxFaktQueryMomsPct: TCurrencyField;
    nxFaktQueryMoms: TCurrencyField;
    nxFaktQueryNetto: TCurrencyField;
    nxFaktQueryTilskAmt: TCurrencyField;
    nxFaktQueryTilskKom: TCurrencyField;
    nxFaktQueryDKTilsk: TCurrencyField;
    nxFaktQueryDKEjTilsk: TCurrencyField;
    nxFaktQueryOrdreNr: TIntegerField;
    nxFaktQueryLMSModtager: TStringField;
    nxFaktQueryEdbGebyr: TCurrencyField;
    nxFaktQueryTlfGebyr: TCurrencyField;
    nxFaktQueryUdbrGebyr: TCurrencyField;
    nxFaktQueryAndel: TCurrencyField;
    nxFaktQueryCtrSaldo: TCurrencyField;
    nxRSEkspLinApotekBem: TStringField;
    nxRSEkspLinOrdreInstruks: TStringField;
    ffLagHis: TnxTable;
    ffLagHisLager: TWordField;
    ffLagHisOrdreStatus: TWordField;
    ffLagHisBestDato: TDateTimeField;
    ffLagHisVareNr: TStringField;
    ffLagHisAntal: TIntegerField;
    ffLagHisLeveret: TIntegerField;
    ffLagHisRestordre: TIntegerField;
    ffLagHisSort: TStringField;
    ffLagHisVareType: TWordField;
    ffLagHisGrNr: TWordField;
    ffLagHisKostPris: TCurrencyField;
    ffLagHisLokation1: TIntegerField;
    ffLagHisLokation2: TIntegerField;
    ffLagHisOptagRO: TWordField;
    ffLagHisAntalSP: TWordField;
    nxAfd: TnxTable;
    nxAfdType: TStringField;
    nxAfdOperation: TStringField;
    nxAfdNavn: TStringField;
    nxAfdRefNr: TIntegerField;
    nxAfdLmsPNr: TStringField;
    nxAfdLmsNr: TStringField;
    nxRSEkspLinListRSLbnr: TIntegerField;
    nxRSEkspLinRSLbnr: TIntegerField;
    nxRSEkspLinRSLinienr: TIntegerField;
    ffRcpOplHKgebyr: TCurrencyField;
    ffRcpOplPlejehjemsgebyr: TCurrencyField;
    nxEkspLinKon: TnxTable;
    nxEkspLinKonLbnr: TIntegerField;
    nxEkspLinKonLinienr: TIntegerField;
    nxEkspLinKonVarenr: TStringField;
    nxEkspLinKonAntal: TIntegerField;
    nxEkspLinKonOpKode: TIntegerField;
    nxEkspLinKonDato: TDateTimeField;
    nxEkspLinKonFejlkode: TIntegerField;
    nxEkspLinKonBemaerk: TnxMemoField;
    ffAfdNvnType: TStringField;
    ffAfdNvnLmsNr: TStringField;
    ffdchFileReceiveDate: TDateTimeField;
    ffdchOrderReceiveDate: TDateTimeField;
    ffdchOrderMemo: TnxMemoField;
    ffdchPackAccept: TBooleanField;
    ffdchBemaerkMemo: TnxMemoField;
    ffdchParked: TBooleanField;
    ffdchYderCprNr: TStringField;
    ffdclKontrolled: TBooleanField;
    ffdclEjSubst: TBooleanField;
    nxRSEkspLinListAdminID: TIntegerField;
    nxRSEkspLinListAdminDate: TStringField;
    nxRSEkspLinListOrdreInstruks: TStringField;
    nxRSEkspLinListApotekBem: TStringField;
    nxRSEkspLinListRSLinienr: TIntegerField;
    ffCtrOpdMessage: TStringField;
    ffdchAndreTilskud: TBooleanField;
    ffdclRegel4243: TBooleanField;
    ffdclAndreTilskud: TBooleanField;
    ffdchKlausuleret: TBooleanField;
    ffdclKlausuleret: TBooleanField;
    nxEkspLevListe: TnxTable;
    nxEkspLevListeListeNr: TIntegerField;
    nxEkspLevListeLbNr: TIntegerField;
    nxEkspLevListeDato: TDateTimeField;
    ffEksOvrListeNr: TIntegerField;
    ffRcpOplListeNr: TIntegerField;
    nxEkspLevListeKonto: TStringField;
    nqEkspLevListe: TnxQuery;
    fqEksOvrLbnr: TIntegerField;
    fqEksOvrKundenr: TStringField;
    fqEksOvrNavn: TStringField;
    fqEksOvrYderNavn: TStringField;
    fqEksOvrBarn: TStringField;
    fqEksOvrTakseret: TDateTimeField;
    fqEksOvrAfsluttet: TDateTimeField;
    fqEksOvrType: TStringField;
    fqEksOvrStatus: TStringField;
    fqEksOvrKonto: TStringField;
    fqEksOvrFaktura: TIntegerField;
    fqEksOvrPakke: TIntegerField;
    fqEksOvrLevnr: TStringField;
    fqEksOvrListenr: TIntegerField;
    fqEksOvrTur: TIntegerField;
    fqEksOvrTa: TWordField;
    fqEksOvrKo: TWordField;
    fqEksOvrAf: TWordField;
    fqEksOvrDKMedlem: TStringField;
    fqEksOvrDK: TStringField;
    fqEksOvrCtrType: TStringField;
    fqEksOvrCP: TStringField;
    fqEksOvrCTRsaldo: TCurrencyField;
    fqEksOvrYdernr: TStringField;
    fqEksOvrKundetype: TStringField;
    fqEksOvrEksptype: TStringField;
    fqEksOvrEkspform: TStringField;
    fqEksOvrReceptId: TIntegerField;
    fqEksOvrAmt: TWordField;
    fqEksOvrKom: TWordField;
    fqEksOvrAfdeling: TWordField;
    fqEksOvrLager: TWordField;
    fqEksOvrUdlignNr: TIntegerField;
    fqEksOvrFiktiv: TStringField;
    fqEksOvrLev: TStringField;
    fqEksOvrBrutto: TCurrencyField;
    fqEksOvrRabat: TCurrencyField;
    fqEksOvrExclmoms: TCurrencyField;
    fqEksOvrMoms: TCurrencyField;
    fqEksOvrNetto: TCurrencyField;
    fqEksOvrAmtet: TCurrencyField;
    fqEksOvrKommunen: TCurrencyField;
    fqEksOvrPatAndel: TCurrencyField;
    fqEksOvrDKTilskud: TCurrencyField;
    fqEksOvrDKEjTilskud: TCurrencyField;
    fqEksOvrEdbgebyr: TCurrencyField;
    fqEksOvrTlfgebyr: TCurrencyField;
    fqEksOvrUdbrgebyr: TCurrencyField;
    fqEksOvrLMSModtager: TStringField;
    fqEksOvrYderCPRNr: TStringField;
    fqEksOvrKontrolFejl: TWordField;
    fqEksOvrKontrolDato: TDateTimeField;
    nqVaelgLevliste: TnxQuery;
    dsVaelgLevliste: TDataSource;
    nqKundeOrd: TnxQuery;
    dsKundeOrd: TDataSource;
    nqKundeOrdDato: TDateTimeField;
    nqKundeOrdVarenr: TStringField;
    nqKundeOrdNavn: TStringField;
    nqKundeOrdType: TStringField;
    nqVaelgLevlistelistenr: TIntegerField;
    nqVaelgLevlistedato: TDateField;
    nqVaelgLevlistekonto: TStringField;
    fqEksOvrOrdreDato: TDateTimeField;
    ffLagKarSubGrp: TWordField;
    ffLagKarOpbevKode: TStringField;
    nxEkspBon: TnxTable;
    nxEkspBonLbNr: TLargeintField;
    nxEkspBonKasseNr: TLargeintField;
    nxEkspBonBonNr: TLargeintField;
    ffEksOvrBonnr: TLargeintField;
    fqEksOvrBonnr: TLargeintField;
    mtLinSaveBGP: TCurrencyField;
    mtLinSaveESP: TCurrencyField;
    nxEksp: TnxTable;
    nxEkspEdbGebyr: TCurrencyField;
    nxEkspTlfGebyr: TCurrencyField;
    nxEkspUdbrGebyr: TCurrencyField;
    nxEkspLbNr: TIntegerField;
    ffPatUpdCtrOrd: TSmallintField;
    ffPatUpdCtrUdDatoB: TDateTimeField;
    ffPatUpdCtrSaldoB: TCurrencyField;
    ffPatUpdCTRUdlignB: TCurrencyField;
    nxCTRinfSaldoB: TCurrencyField;
    nxCTRinfslutdatoB: TDateTimeField;
    nxCTRinffor_udlign_tilskudB: TCurrencyField;
    nxCTRinffor_slutdatoB: TDateTimeField;
    nxCTRinfudlign_tilskudB: TCurrencyField;
    nxRemoteServerInfoPlugin1: TnxRemoteServerInfoPlugin;
    ffPatKarCtrUdDatoB: TDateTimeField;
    ffPatKarCtrSaldoB: TCurrencyField;
    ffPatKarCTRUdlignB: TCurrencyField;
    nxRSEkspLinListAdministrationId: TLargeintField;
    nxRSEkspLinListFrigivStatus: TIntegerField;
    nxRSEkspLinAdministrationId: TLargeintField;
    nxRSEkspLinFrigivStatus: TIntegerField;
    ffLagKarIndbNr: TStringField;
    ffdchLbnr: TIntegerField;
    nqDosETK: TnxQuery;
    mtRei: TClientDataSet;
    mtReiVareNr: TStringField;
    mtReiVareTxt: TStringField;
    mtReiUdlevNr: TWordField;
    mtReiUdlevMax: TWordField;
    mtReiAntal: TIntegerField;
    mtReiEtkLin: TWordField;
    mtReiEtk1: TStringField;
    mtReiEtk2: TStringField;
    mtReiEtk3: TStringField;
    mtReiEtk4: TStringField;
    mtReiEtk5: TStringField;
    mtReiEtk6: TStringField;
    mtReiEtk7: TStringField;
    mtReiEtk8: TStringField;
    mtReiEtk9: TStringField;
    mtReiEtk10: TStringField;
    mtReiDosKode1: TStringField;
    mtReiDosKode2: TStringField;
    mtReiIndikKode: TStringField;
    mtReiTxtKode: TStringField;
    mtReiTilskud: TStringField;
    mtReiSubst: TWordField;
    mtReiOrdId: TStringField;
    mtReiReceptId: TIntegerField;
    mtGro: TClientDataSet;
    mtGroGrNr: TWordField;
    ffRcpOplAfrAmt: TStringField;
    ffAfrEksUdlignNr: TIntegerField;
    ffdchKortStatus: TStringField;
    nxDCH: TnxTable;
    WordField1: TWordField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    StringField9: TStringField;
    WordField2: TWordField;
    DateTimeField1: TDateTimeField;
    DateTimeField2: TDateTimeField;
    WordField3: TWordField;
    DateTimeField3: TDateTimeField;
    IntegerField1: TIntegerField;
    DateTimeField4: TDateTimeField;
    IntegerField2: TIntegerField;
    DateTimeField5: TDateTimeField;
    IntegerField3: TIntegerField;
    IntegerField4: TIntegerField;
    StringField10: TStringField;
    StringField11: TStringField;
    StringField12: TStringField;
    DateTimeField6: TDateTimeField;
    IntegerField5: TIntegerField;
    DateTimeField7: TDateTimeField;
    StringField13: TStringField;
    DateTimeField8: TDateTimeField;
    DateTimeField9: TDateTimeField;
    nxMemoField1: TnxMemoField;
    BooleanField1: TBooleanField;
    nxMemoField2: TnxMemoField;
    BooleanField2: TBooleanField;
    StringField14: TStringField;
    BooleanField3: TBooleanField;
    BooleanField4: TBooleanField;
    IntegerField6: TIntegerField;
    StringField15: TStringField;
    dsnxDCH: TDataSource;
    ffEksKarAlder: TSmallintField;
    ffEksKarKontrolFejl: TWordField;
    ffEksKarLevAdr1: TStringField;
    ffEksKarLevAdr2: TStringField;
    ffEksKarLevPostNr: TStringField;
    ffEksKarLevLand: TStringField;
    ffEksKarLevKontakt: TStringField;
    ffEksKarLevTlfNr: TStringField;
    ffEksKarYderTlfNr: TStringField;
    ffEksKarKontoAdr1: TStringField;
    ffEksKarKontoAdr2: TStringField;
    ffEksKarKontoPostNr: TStringField;
    ffEksKarKontoLand: TStringField;
    ffEksKarKontoKontakt: TStringField;
    ffEksKarKontoTlf: TStringField;
    ffEksKarKontoGruppe: TWordField;
    ffEksKarRabatGruppe: TWordField;
    ffEksKarPrisGruppe: TWordField;
    ffEksKarStatGruppe: TWordField;
    ffEksKarKreditForm: TWordField;
    ffEksKarBetalingsForm: TWordField;
    ffEksKarPakkeseddel: TWordField;
    ffEksKarFaktura: TWordField;
    ffEksKarBetalingskort: TWordField;
    ffEksKarLeveringsseddel: TWordField;
    ffEksKarAdrEtiket: TWordField;
    ffEksKarVigtigBem: TnxMemoField;
    ffEksKarAfstempling: TnxMemoField;
    ffEksKarLMSUdsteder: TStringField;
    ffEksKarCtrBel: TCurrencyField;
    ffEksLinGMark: TBooleanField;
    ffEksLinOMark: TBooleanField;
    ffEksLinAMark: TBooleanField;
    ffEksLinPMark: TBooleanField;
    ffEksTilFraDato1: TDateTimeField;
    ffEksTilTilDato1: TDateTimeField;
    ffEksTilFraDato2: TDateTimeField;
    ffEksTilTilDato2: TDateTimeField;
    ffEksTilAfdeling1Ej: TStringField;
    ffEksTilAfdeling2Ej: TStringField;
    ffBetFrm: TnxTable;
    ffBetFrmNr: TWordField;
    ffBetFrmOperation: TStringField;
    ffBetFrmNavn: TStringField;
    ffKreFrm: TnxTable;
    ffKreFrmNr: TWordField;
    ffKreFrmOperation: TStringField;
    ffKreFrmNavn: TStringField;
    ffKreFrmDage: TWordField;
    ffKreFrmRespit: TWordField;
    ffDebKarKroniker: TBooleanField;
    ffDebKarKronSaldo: TCurrencyField;
    ffDebKarEFaktOrdreNr: TStringField;
    ffDebKarEFaktPersRef: TStringField;
    ffDebKarEFaktKontoNr: TStringField;
    ffDebKarEValgOrdreNr: TWordField;
    ffDebKarEValgPersRef: TWordField;
    ffDebKarEValgKontoNr: TWordField;
    ffDebKarEFaktMdFakt: TBooleanField;
    ffDebKarEValgEanType: TWordField;
    ffDebKarRemoteStatus: TIntegerField;
    nxOrd: TnxTable;
    nxOrdEordrenummer: TStringField;
    nxOrdKundeCPR: TStringField;
    nxOrdHjemNavn: TStringField;
    nxOrdBetalingsmetode: TStringField;
    nxOrdLeveringsmetode: TStringField;
    nxOrdAfhentningssted: TStringField;
    nxOrdOrdredato: TStringField;
    nxOrdKundeeordrenummer: TIntegerField;
    nxOrdApoteketsRef: TStringField;
    nxOrdGenereringsbaggrund: TStringField;
    nxOrdOrdrestatus: TStringField;
    nxOrdAfventerKundensGodkendelse: TBooleanField;
    nxOrdAendringerKanAfvises: TBooleanField;
    nxOrdTotallistepris: TCurrencyField;
    nxOrdFragtpris: TCurrencyField;
    nxOrdTotalpris: TCurrencyField;
    nxOrdFraAbonnement: TBooleanField;
    nxOrdMedlemAfDanmark: TBooleanField;
    nxOrdEmail: TStringField;
    nxOrdTelefon: TStringField;
    nxOrdMobiletelefon: TStringField;
    nxOrdHjemAdresse1: TStringField;
    nxOrdHjemAdresse2: TStringField;
    nxOrdHjemPostnummer: TStringField;
    nxOrdHjemBy: TStringField;
    nxOrdHjemLand: TStringField;
    nxOrdLeveringsNavn: TStringField;
    nxOrdLeveringsAdresse1: TStringField;
    nxOrdLeveringsAdresse2: TStringField;
    nxOrdLeveringsPostnummer: TStringField;
    nxOrdLeveringsBy: TStringField;
    nxOrdLeveringsLand: TStringField;
    nxOrdAfhentningsstedErApotek: TBooleanField;
    nxOrdDibsTransaktionsId: TStringField;
    nxOrdDibsOrdrenummer: TStringField;
    nxOrdDibsMerchantId: TStringField;
    nxOrdAutoriseretBeloeb: TCurrencyField;
    nxOrdHaevetBeloeb: TCurrencyField;
    nxOrdBeskedFraKunde: TnxMemoField;
    nxOrdBeskedFraApotek: TnxMemoField;
    nxOrdUdleveringstidspunkt: TStringField;
    nxOrdEkspedient: TStringField;
    nxOrdUdleveringsnummer: TStringField;
    nxOrdTrackAndTrace: TStringField;
    nxOrdSamletKundeandel: TCurrencyField;
    nxOrdAnvendtCTR: TCurrencyField;
    nxOrdNyBeregnetCTRsaldo: TCurrencyField;
    nxOrdCTRperiodeudloeb: TStringField;
    nxOrdTilskudsberettiget: TCurrencyField;
    nxOrdIkkeTilskudsberettiget: TCurrencyField;
    nxOrdEkspLbnr: TIntegerField;
    nxOrdPrintStatus: TIntegerField;
    nxOrdC2Nr: TIntegerField;
    nxOrdOrdreStatTekst: TStringField;
    nxOrdApotekId: TStringField;
    nxOrdLin: TnxTable;
    nxOrdLinEordrenummer: TStringField;
    nxOrdLinLinjenummer: TIntegerField;
    nxOrdLinAntal: TIntegerField;
    nxOrdLinVarenummer: TStringField;
    nxOrdLinErSpeciel: TBooleanField;
    nxOrdLinVarenavn: TStringField;
    nxOrdLinForm: TStringField;
    nxOrdLinStyrke: TStringField;
    nxOrdLinPakningsstoerrelse: TStringField;
    nxOrdLinSubstitution: TStringField;
    nxOrdLinListeprisPerStk: TCurrencyField;
    nxOrdLinTotallistepris: TCurrencyField;
    nxOrdLinApoteketsLinjeRef: TnxMemoField;
    nxOrdLinOrdinationType: TStringField;
    nxOrdLinOrdinationsId: TStringField;
    nxOrdLinReceptId: TStringField;
    nxOrdLinApoteketsOrdinationRef: TnxMemoField;
    nxOrdLinOrdineretAntal: TIntegerField;
    nxOrdLinOrdineretVarenummer: TStringField;
    nxOrdLinSygesikringensAndel: TCurrencyField;
    nxOrdLinKommunensAndel: TCurrencyField;
    nxOrdLinKundeandel: TCurrencyField;
    nxOrdLinCTRbeloeb: TCurrencyField;
    nxOrdLinEkspLinienr: TIntegerField;
    nxOrdLinC2Nr: TIntegerField;
    dsOrd: TDataSource;
    dsOrdLin: TDataSource;
    nxQryPak: TnxQuery;
    nxEkspLin: TnxTable;
    nxEkspLinLbNr: TIntegerField;
    nxEkspLinLinieNr: TWordField;
    nxEkspLinLinieType: TWordField;
    nxEkspLinLager: TWordField;
    nxEkspLinGMark: TBooleanField;
    nxEkspLinOMark: TBooleanField;
    nxEkspLinAMark: TBooleanField;
    nxEkspLinPMark: TBooleanField;
    nxEkspLinVareNr: TStringField;
    nxEkspLinSubVareNr: TStringField;
    nxEkspLinStatNr: TStringField;
    nxEkspLinLokation1: TWordField;
    nxEkspLinLokation2: TWordField;
    nxEkspLinLokation3: TWordField;
    nxEkspLinVareType: TWordField;
    nxEkspLinVareGruppe: TWordField;
    nxEkspLinStatGruppe: TWordField;
    nxEkspLinOmsType: TWordField;
    nxEkspLinNarkoType: TWordField;
    nxEkspLinTilskType: TWordField;
    nxEkspLinDKType: TWordField;
    nxEkspLinTekst: TStringField;
    nxEkspLinEnhed: TStringField;
    nxEkspLinForm: TStringField;
    nxEkspLinStyrke: TStringField;
    nxEkspLinPakning: TStringField;
    nxEkspLinATCType: TStringField;
    nxEkspLinATCKode: TStringField;
    nxEkspLinSSKode: TStringField;
    nxEkspLinKlausul: TStringField;
    nxEkspLinPAKode: TStringField;
    nxEkspLinDDD: TIntegerField;
    nxEkspLinDyreArt: TWordField;
    nxEkspLinAldersGrp: TWordField;
    nxEkspLinOrdGrp: TWordField;
    nxEkspLinUdlevMax: TWordField;
    nxEkspLinUdlevNr: TWordField;
    nxEkspLinAntal: TIntegerField;
    nxEkspLinPris: TCurrencyField;
    nxEkspLinKostPris: TCurrencyField;
    nxEkspLinVareForbrug: TCurrencyField;
    nxEkspLinBrutto: TCurrencyField;
    nxEkspLinRabatPct: TCurrencyField;
    nxEkspLinRabat: TCurrencyField;
    nxEkspLinExMoms: TCurrencyField;
    nxEkspLinInclMoms: TBooleanField;
    nxEkspLinMomsPct: TCurrencyField;
    nxEkspLinMoms: TCurrencyField;
    nxEkspLinNetto: TCurrencyField;
    nxEkspLinEjS: TWordField;
    nxEkspLinEjO: TWordField;
    nxEkspLinEjG: TWordField;
    nxEkspLinUdLevType: TStringField;
    nxEkspTil: TnxTable;
    nxEkspTilLbNr: TIntegerField;
    nxEkspTilLinieNr: TWordField;
    nxEkspTilFraDato1: TDateTimeField;
    nxEkspTilTilDato1: TDateTimeField;
    nxEkspTilFraDato2: TDateTimeField;
    nxEkspTilTilDato2: TDateTimeField;
    nxEkspTilJournalNr1: TStringField;
    nxEkspTilJournalNr2: TStringField;
    nxEkspTilESP: TCurrencyField;
    nxEkspTilRFP: TCurrencyField;
    nxEkspTilBGP: TCurrencyField;
    nxEkspTilSaldo: TCurrencyField;
    nxEkspTilIBPBel: TCurrencyField;
    nxEkspTilBGPBel: TCurrencyField;
    nxEkspTilIBTBel: TCurrencyField;
    nxEkspTilUdligning: TCurrencyField;
    nxEkspTilAndel: TCurrencyField;
    nxEkspTilTilskSyg: TCurrencyField;
    nxEkspTilTilskKom1: TCurrencyField;
    nxEkspTilTilskKom2: TCurrencyField;
    nxEkspTilRegelSyg: TWordField;
    nxEkspTilRegelKom1: TWordField;
    nxEkspTilRegelKom2: TWordField;
    nxEkspTilPromilleSyg: TWordField;
    nxEkspTilPromilleKom1: TWordField;
    nxEkspTilPromilleKom2: TWordField;
    nxEkspTilAfdeling1: TStringField;
    nxEkspTilAfdeling2: TStringField;
    nxEkspTilCtrIndberettet: TWordField;
    nxEkspTilAfdeling1Ej: TStringField;
    nxEkspTilAfdeling2Ej: TStringField;
    nxLager: TnxTable;
    nxLagerLager: TWordField;
    nxLagerVareNr: TStringField;
    nxLagerEanKode: TStringField;
    nxLagerAtcKode: TStringField;
    nxLagerSamPakNr: TStringField;
    nxLagerTekst: TStringField;
    nxLagerTekst2: TStringField;
    nxLagerPaknNum: TIntegerField;
    nxLagerPaknEnh: TStringField;
    nxLagerKommentar: TStringField;
    nxLagerABCgruppe: TStringField;
    nxLagerGruppe: TWordField;
    nxLagerSamPakAnt: TWordField;
    nxLagerGrNr1: TWordField;
    nxLagerGrNr2: TWordField;
    nxLagerLokation1: TIntegerField;
    nxLagerLokation2: TIntegerField;
    nxLagerEgenGrp1: TIntegerField;
    nxLagerEgenGrp2: TIntegerField;
    nxLagerEgenGrp3: TIntegerField;
    nxLagerMinimum: TIntegerField;
    nxLagerMaximum: TIntegerField;
    nxLagerGenBestil: TIntegerField;
    nxLagerPrimo: TIntegerField;
    nxLagerAntal: TIntegerField;
    nxLagerRestOrdre: TIntegerField;
    nxLagerGrRestOrdre: TIntegerField;
    nxLagerSampakAfr: TBooleanField;
    nxLagerKostPris: TCurrencyField;
    nxLagerKostModel: TWordField;
    nxLagerAvanceModel: TWordField;
    nxLagerLagerMetode: TWordField;
    nxLagerVareType: TWordField;
    nxLagerEgenType: TWordField;
    nxLagerPrisLabel: TWordField;
    nxLagerSalgsPris: TCurrencyField;
    nxLagerSalgsPris2: TCurrencyField;
    nxLagerEgenPris: TCurrencyField;
    nxLagerEnhedsPris: TCurrencyField;
    nxLagerBevDato: TDateTimeField;
    nxLagerOpretDato: TDateTimeField;
    nxLagerRetDato: TDateTimeField;
    nxLagerSletDato: TDateTimeField;
    nxLagerPrisDato: TDateTimeField;
    nxLagerHovedGrp: TStringField;
    nxLagerUnderGrp: TStringField;
    nxLagerDrugId: TStringField;
    nxLagerNavn: TStringField;
    nxLagerForm: TStringField;
    nxLagerStyrke: TStringField;
    nxLagerPakning: TStringField;
    nxLagerPaKode: TStringField;
    nxLagerFirmaReg: TIntegerField;
    nxLagerFirmaImp: TIntegerField;
    nxLagerUdlevType: TStringField;
    nxLagerHaType: TStringField;
    nxLagerSSKode: TStringField;
    nxLagerOpbevKode: TStringField;
    nxLagerSubGrp: TWordField;
    nxLagerSubst: TBooleanField;
    nxLagerSubKode: TStringField;
    nxLagerTiSubKode: TStringField;
    nxLagerTrafikAdv: TBooleanField;
    nxLagerDDD: TCurrencyField;
    nxLagerBGP: TCurrencyField;
    nxLagerKampStart: TDateTimeField;
    nxLagerKampStop: TDateTimeField;
    nxLagerTiKostPris: TCurrencyField;
    nxLagerDoKostPris: TCurrencyField;
    nxLagerDoSalgsPris: TCurrencyField;
    nxLagerDoBGP: TCurrencyField;
    nxLagerDoSubGrp: TWordField;
    nxLagerDoSort: TStringField;
    nxLagerDoEgnet: TBooleanField;
    nxLagerDelPakNr: TStringField;
    nxLagerIndbNr: TStringField;
    nxLagerIndbKode: TStringField;
    nxLagerSalgsled: TStringField;
    nxLagerAtcType: TStringField;
    nxLagerTiSalgsPris: TCurrencyField;
    nxLagerEnhPrisBet: TStringField;
    nxLagerEnhPrisBer: TStringField;
    nxLagerBerMinimum: TIntegerField;
    nxLagerBerGenBestil: TIntegerField;
    nxLagerFormKode: TStringField;
    nxLagerStyrkeNum: TIntegerField;
    nxLagerSubEnhPris: TCurrencyField;
    nxLagerTiBGP: TCurrencyField;
    nxLagerTiSalgsPris2: TCurrencyField;
    nxLagerAfmDato: TDateTimeField;
    nxLagerSubForValg: TStringField;
    nxLagerDelPakUdskAnt: TWordField;
    nxEHSettings: TnxTable;
    nxEHSettingsApotekId: TStringField;
    nxEHSettingsC2Nr: TIntegerField;
    nxEHSettingsBeskedId: TIntegerField;
    nxEHSettingsPrinterName: TStringField;
    nxEHSettingsPrinterSkuffe: TStringField;
    nxEHSettingsPrinterSize: TIntegerField;
    nxEHSettingsLager: TIntegerField;
    nxEHSettingsPassword: TStringField;
    nxEHSettingsDeltaTime: TDateTimeField;
    nxEHSettingsMajor: TIntegerField;
    nxEHSettingsMinor: TIntegerField;
    nxEHSettingsAfdeling: TIntegerField;
    nxRSEkspListAfdeling: TIntegerField;
    nxRSEkspListReceptStatus: TIntegerField;
    ffPatKarMobil: TStringField;
    NxLagerSubstListe: TnxTable;
    ffAfdNvnProduktionsDyr: TBooleanField;
    ffLagKarVetProdPris: TCurrencyField;
    ffDebKarFaktura: TBooleanField;
    ffdclOrdid: TStringField;
    ffEksLinUdDato: TDateTimeField;
    ffEksLinBatchNr: TStringField;
    cdsGeneriske: TClientDataSet;
    cdsGeneriskeDrugID: TStringField;
    cdsGeneriskeVareNr: TStringField;
    cdsGeneriskeNavn: TStringField;
    ffLinOvrUdDato: TDateTimeField;
    ffLinOvrBatchNr: TStringField;
    nxEkspTakserDato: TDateTimeField;
    ffdchAutoEksp: TBooleanField;
    ffdchTerminalStatus: TBooleanField;
    ffdclIndikKode: TIntegerField;
    ffdclGammeltVarenr: TStringField;
    ffdclRetVareNrDato: TDateTimeField;
    ffdclBevilRegelNr: TIntegerField;
    ffdclTerminalStatus: TBooleanField;
    nxDCHAutoEksp: TBooleanField;
    nxDCHTerminalStatus: TBooleanField;
    ffEksFakEFaktOrdreNr: TStringField;
    nxRSEkspReceptStatus: TIntegerField;
    mtLinVareInfo: TBooleanField;
    ffLagKarVareInfo: TIntegerField;
    mtGroGrOplNr: TIntegerField;
    ffLagKarSalgsTekst: TStringField;
    ffEksOvrRSQueueStatus: TIntegerField;
    ffEksKarRSQueueStatus: TIntegerField;
    nxRSEkspListDosis: TStringField;
    ffEksLinOrdinationId: TStringField;
    cdsHenstandsOrdning: TClientDataSet;
    cdsHenstandsOrdningaktiv: TStringField;
    cdsHenstandsOrdningindgaaelsesdato: TStringField;
    cdsHenstandsOrdningophoersdato: TStringField;
    cdsHenstandsOrdningApoteksnr: TStringField;
    cdsHenstandsOrdningophoersaarsag: TStringField;
    mtReiUserPris: TCurrencyField;
    mtReiSubVarenr: TStringField;
    ffDebKarMail: TStringField;
    nxdb: TnxDatabase;
    ffEksKarReturdage: TWordField;
    tbl_MomsTyper: TnxTable;
    tbl_MomsTyperNr: TWordField;
    tbl_MomsTyperOperation: TStringField;
    tbl_MomsTyperNavn: TStringField;
    tbl_MomsTyperMomsKonto: TStringField;
    tbl_MomsTyperSats: TCurrencyField;
    ffEksOvrReturdage: TWordField;
    ffLagKarDMVS: TWordField;
    mtLinDMVS: TBooleanField;
    mtLinDrugid: TStringField;
    ffKasOpl: TnxTable;
    ffKasOplKasseNr: TIntegerField;
    ffKasOplBonNr: TIntegerField;
    ffKasOplSalgMax: TCurrencyField;
    ffKasOplKasseMax: TCurrencyField;
    ffKasOplPrinter: TStringField;
    ffKasOplDisplay: TStringField;
    ffKasOplSkuffe: TStringField;
    ffKasOplPrinterPort: TStringField;
    ffKasOplDisplayPort: TStringField;
    ffKasOplSkuffePort: TStringField;
    ffKasOplBonSti: TStringField;
    ffKasOplBonGemAar: TWordField;
    ffKasOplHovedTxt1: TStringField;
    ffKasOplHovedTxt2: TStringField;
    ffKasOplHovedTxt3: TStringField;
    ffKasOplHovedTxt4: TStringField;
    ffKasOplHovedCenter1: TBooleanField;
    ffKasOplHovedCenter2: TBooleanField;
    ffKasOplHovedCenter3: TBooleanField;
    ffKasOplHovedCenter4: TBooleanField;
    ffKasOplHovedBred1: TBooleanField;
    ffKasOplHovedBred2: TBooleanField;
    ffKasOplHovedBred3: TBooleanField;
    ffKasOplHovedBred4: TBooleanField;
    ffKasOplBundTxt1: TStringField;
    ffKasOplBundTxt2: TStringField;
    ffKasOplBundTxt3: TStringField;
    ffKasOplBundTxt4: TStringField;
    ffKasOplBundCenter1: TBooleanField;
    ffKasOplBundCenter2: TBooleanField;
    ffKasOplBundCenter3: TBooleanField;
    ffKasOplBundCenter4: TBooleanField;
    ffKasOplBundBred1: TBooleanField;
    ffKasOplBundBred2: TBooleanField;
    ffKasOplBundBred3: TBooleanField;
    ffKasOplBundBred4: TBooleanField;
    ffKasOplBonCut: TBooleanField;
    ffKasOplKopierSalg: TWordField;
    ffKasOplKopierIndbet: TWordField;
    ffKasOplKopierUdbet: TWordField;
    ffKasOplHovedTxt5: TStringField;
    ffKasOplHovedTxt6: TStringField;
    ffKasOplHovedTxt7: TStringField;
    ffKasOplHovedTxt8: TStringField;
    ffKasOplHovedTxt9: TStringField;
    ffKasOplHovedTxt10: TStringField;
    ffKasOplHovedCenter5: TBooleanField;
    ffKasOplHovedCenter6: TBooleanField;
    ffKasOplHovedCenter7: TBooleanField;
    ffKasOplHovedCenter8: TBooleanField;
    ffKasOplHovedCenter9: TBooleanField;
    ffKasOplHovedCenter10: TBooleanField;
    ffKasOplHovedBred5: TBooleanField;
    ffKasOplHovedBred6: TBooleanField;
    ffKasOplHovedBred7: TBooleanField;
    ffKasOplHovedBred8: TBooleanField;
    ffKasOplHovedBred9: TBooleanField;
    ffKasOplHovedBred10: TBooleanField;
    ffKasOplBundTxt5: TStringField;
    ffKasOplBundTxt6: TStringField;
    ffKasOplBundTxt7: TStringField;
    ffKasOplBundTxt8: TStringField;
    ffKasOplBundTxt9: TStringField;
    ffKasOplBundTxt10: TStringField;
    ffKasOplBundCenter5: TBooleanField;
    ffKasOplBundCenter6: TBooleanField;
    ffKasOplBundCenter7: TBooleanField;
    ffKasOplBundCenter8: TBooleanField;
    ffKasOplBundCenter9: TBooleanField;
    ffKasOplBundCenter10: TBooleanField;
    ffKasOplBundBred5: TBooleanField;
    ffKasOplBundBred6: TBooleanField;
    ffKasOplBundBred7: TBooleanField;
    ffKasOplBundBred8: TBooleanField;
    ffKasOplBundBred9: TBooleanField;
    ffKasOplBundBred10: TBooleanField;
    ffKasOplDispTekst1Lin1: TStringField;
    ffKasOplDispTekst1Lin2: TStringField;
    ffKasOplDispTekst2Lin1: TStringField;
    ffKasOplDispTekst2Lin2: TStringField;
    ffKasOplDispTekst3Lin1: TStringField;
    ffKasOplDispTekst3Lin2: TStringField;
    ffKasOplC2QKasseType: TStringField;
    ffKasOplMobilePayPosId: TStringField;
    ffKasOplMobilePayPosUnitId: TStringField;
    ffKasOplMobilePayComPort: TStringField;
    ffKasOplMobilePayPosUnitC2Id: TStringField;
    ffKasOplMobilePayOK: TBooleanField;
    ffKasEks: TnxTable;
    ffKasEksKasseNr: TIntegerField;
    ffKasEksBonNr: TIntegerField;
    ffKasEksDato: TDateTimeField;
    ffKasEksBrugerNr: TWordField;
    ffKasEksUdlignNr: TIntegerField;
    ffKasEksType: TStringField;
    ffKasEksAfdeling: TStringField;
    ffKasEksBrutto: TCurrencyField;
    ffKasEksRabatBon: TCurrencyField;
    ffKasEksMoms: TCurrencyField;
    ffKasEksKontant: TCurrencyField;
    ffKasEksCheck: TCurrencyField;
    ffKasEksDankort: TCurrencyField;
    ffKasEksValuta: TCurrencyField;
    ffKasEksAntLin: TWordField;
    ffKasEksAntBet: TWordField;
    ffKasEksAntBon: TWordField;
    ffKasEksRabatLin: TCurrencyField;
    ffKasEksKrKort: TCurrencyField;
    ffKasEksKonto: TCurrencyField;
    ffKasEksKontoNr: TStringField;
    ffKasEksTekst2: TStringField;
    ffKasEksTekst3: TStringField;
    ffKasEksTekst4: TStringField;
    ffKasEksTekst5: TStringField;
    ffKasEksStatus: TIntegerField;
    nxEksbon: TnxTable;
    nxEksbonLbNr: TLargeintField;
    nxEksbonKasseNr: TLargeintField;
    nxEksbonBonNr: TLargeintField;
    fqEksOvrReturdage: TWordField;
    mtLinHeaderCTRUpdated: TBooleanField;
    nxRSEkspeditioner: TnxTable;
    nxRSEkspLinier: TnxTable;
    mtAfdeling: TClientDataSet;
    mtAfdelingLokationNumber: TStringField;
    mtAfdelingSubstLokationNumber: TStringField;
    mtAfdelingPrinterNavn: TStringField;
    mtAfdelingPrinterSkuffe: TStringField;
    mtAfdelingPNummer: TStringField;
    mtAfdelingAfdelingNr: TIntegerField;
    mtAfdelingPapirType: TIntegerField;
    mtAfdelingLager: TIntegerField;
    mtAfdelingUsername: TStringField;
    mtAfdelingPassword: TStringField;
    mtAfdelingUserId: TStringField;
    nxRSEksplinOrd: TnxTable;
    cdsRSEksp: TClientDataSet;
    cdsRSEkspPrescriptionId: TStringField;
    cdsRSEkspReceptId: TIntegerField;
    cdsRSEkspLbNr: TIntegerField;
    cdsRSEkspDato: TDateTimeField;
    cdsRSEkspOrdAnt: TIntegerField;
    cdsRSEkspSenderId: TStringField;
    cdsRSEkspSenderType: TStringField;
    cdsRSEkspSenderNavn: TStringField;
    cdsRSEkspSenderVej: TStringField;
    cdsRSEkspSenderPostNr: TStringField;
    cdsRSEkspSenderTel: TStringField;
    cdsRSEkspSenderSpecKode: TStringField;
    cdsRSEkspIssuerAutNr: TStringField;
    cdsRSEkspIssuerCPRNr: TStringField;
    cdsRSEkspIssuerTitel: TStringField;
    cdsRSEkspIssuerSpecKode: TStringField;
    cdsRSEkspIssuerType: TStringField;
    cdsRSEkspSenderSystem: TStringField;
    cdsRSEkspPatCPR: TStringField;
    cdsRSEkspPatEftNavn: TStringField;
    cdsRSEkspPatForNavn: TStringField;
    cdsRSEkspPatVej: TStringField;
    cdsRSEkspPatBy: TStringField;
    cdsRSEkspPatPostNr: TStringField;
    cdsRSEkspPatLand: TStringField;
    cdsRSEkspPatAmt: TStringField;
    cdsRSEkspPatFoed: TStringField;
    cdsRSEkspPatKoen: TStringField;
    cdsRSEkspOrdreInstruks: TStringField;
    cdsRSEkspLeveringsInfo: TStringField;
    cdsRSEkspLeveringPri: TStringField;
    cdsRSEkspLeveringAdresse: TStringField;
    cdsRSEkspLeveringPseudo: TStringField;
    cdsRSEkspLeveringPostNr: TStringField;
    cdsRSEkspLeveringKontakt: TStringField;
    cdsRSEkspAfdeling: TIntegerField;
    cdsRSEkspReceptStatus: TIntegerField;
    cdsRSEkspLines: TDataSetField;
    cdsRSEkspin: TClientDataSet;
    cdsRSEkspinReceptId: TIntegerField;
    cdsRSEkspinOrdId: TStringField;
    cdsRSEkspinOrdNr: TIntegerField;
    cdsRSEkspinLbNr: TIntegerField;
    cdsRSEkspinLinieNr: TWordField;
    cdsRSEkspinVersion: TStringField;
    cdsRSEkspinOpretDato: TStringField;
    cdsRSEkspinVarenNr: TStringField;
    cdsRSEkspinNavn: TStringField;
    cdsRSEkspinForm: TStringField;
    cdsRSEkspinStyrke: TStringField;
    cdsRSEkspinMagistrel: TStringField;
    cdsRSEkspinPakning: TStringField;
    cdsRSEkspinAntal: TIntegerField;
    cdsRSEkspinImportKort: TStringField;
    cdsRSEkspinImportLangt: TStringField;
    cdsRSEkspinKlausulbetingelse: TStringField;
    cdsRSEkspinSubstKode: TStringField;
    cdsRSEkspinDosKode: TStringField;
    cdsRSEkspinDosTekst: TStringField;
    cdsRSEkspinDosPeriod: TStringField;
    cdsRSEkspinDosEnhed: TStringField;
    cdsRSEkspinIndCode: TStringField;
    cdsRSEkspinIndText: TStringField;
    cdsRSEkspinTakstVersion: TStringField;
    cdsRSEkspinIterationNr: TIntegerField;
    cdsRSEkspinIterationInterval: TIntegerField;
    cdsRSEkspinIterationType: TStringField;
    cdsRSEkspinSupplerende: TStringField;
    cdsRSEkspinDosStartDato: TStringField;
    cdsRSEkspinDosSlutDato: TStringField;
    cdsRSEkspinAdminCount: TIntegerField;
    cdsRSEkspinAdminID: TIntegerField;
    cdsRSEkspinAdminDate: TStringField;
    cdsRSEkspinApotekBem: TStringField;
    cdsRSEkspinOrdreInstruks: TStringField;
    cdsRSEkspinRSLbnr: TIntegerField;
    cdsRSEkspinRSLinienr: TIntegerField;
    cdsRSEkspinAdministrationId: TLargeintField;
    cdsRSEkspinFrigivStatus: TIntegerField;
    cdsRSEkspinRSQueueStatus: TIntegerField;
    cdsRSEkspinPrescriptionIdentifier: TLargeintField;
    cdsRSEkspinOrderIdentifier: TLargeintField;
    cdsRSEkspinEffectuationIdentifier: TLargeintField;
    cdsRSEkspinPrivat: TIntegerField;
    nxRSEkspLinListPrescriptionIdentifier: TLargeintField;
    nxRSEkspLinListOrderIdentifier: TLargeintField;
    nxRSEkspLinListEffectuationIdentifier: TLargeintField;
    nxRSEkspLinListPrivat: TIntegerField;
    cdsRSEkspeditioner: TClientDataSet;
    cdsRSEkspeditionerPrescriptionId: TStringField;
    cdsRSEkspeditionerReceptId: TIntegerField;
    cdsRSEkspeditionerLbNr: TIntegerField;
    cdsRSEkspeditionerDato: TDateTimeField;
    cdsRSEkspeditionerOrdAnt: TIntegerField;
    cdsRSEkspeditionerSenderId: TStringField;
    cdsRSEkspeditionerSenderType: TStringField;
    cdsRSEkspeditionerSenderNavn: TStringField;
    cdsRSEkspeditionerSenderVej: TStringField;
    cdsRSEkspeditionerSenderPostNr: TStringField;
    cdsRSEkspeditionerSenderTel: TStringField;
    cdsRSEkspeditionerSenderSpecKode: TStringField;
    cdsRSEkspeditionerIssuerAutNr: TStringField;
    cdsRSEkspeditionerIssuerCPRNr: TStringField;
    cdsRSEkspeditionerIssuerTitel: TStringField;
    cdsRSEkspeditionerIssuerSpecKode: TStringField;
    cdsRSEkspeditionerIssuerType: TStringField;
    cdsRSEkspeditionerSenderSystem: TStringField;
    cdsRSEkspeditionerPatCPR: TStringField;
    cdsRSEkspeditionerPatEftNavn: TStringField;
    cdsRSEkspeditionerPatForNavn: TStringField;
    cdsRSEkspeditionerPatVej: TStringField;
    cdsRSEkspeditionerPatBy: TStringField;
    cdsRSEkspeditionerPatPostNr: TStringField;
    cdsRSEkspeditionerPatLand: TStringField;
    cdsRSEkspeditionerPatAmt: TStringField;
    cdsRSEkspeditionerPatFoed: TStringField;
    cdsRSEkspeditionerPatKoen: TStringField;
    cdsRSEkspeditionerOrdreInstruks: TStringField;
    cdsRSEkspeditionerLeveringsInfo: TStringField;
    cdsRSEkspeditionerLeveringPri: TStringField;
    cdsRSEkspeditionerLeveringAdresse: TStringField;
    cdsRSEkspeditionerLeveringPseudo: TStringField;
    cdsRSEkspeditionerLeveringPostNr: TStringField;
    cdsRSEkspeditionerLeveringKontakt: TStringField;
    cdsRSEkspeditionerAfdeling: TIntegerField;
    cdsRSEkspeditionerReceptStatus: TIntegerField;
    cdsRSEkspeditionerLines: TDataSetField;
    cdsRSEksplinier: TClientDataSet;
    cdsRSEksplinierReceptId: TIntegerField;
    cdsRSEksplinierOrdId: TStringField;
    cdsRSEksplinierOrdNr: TIntegerField;
    cdsRSEksplinierLbNr: TIntegerField;
    cdsRSEksplinierLinieNr: TWordField;
    cdsRSEksplinierVersion: TStringField;
    cdsRSEksplinierOpretDato: TStringField;
    cdsRSEksplinierVarenNr: TStringField;
    cdsRSEksplinierNavn: TStringField;
    cdsRSEksplinierForm: TStringField;
    cdsRSEksplinierStyrke: TStringField;
    cdsRSEksplinierMagistrel: TStringField;
    cdsRSEksplinierPakning: TStringField;
    cdsRSEksplinierAntal: TIntegerField;
    cdsRSEksplinierImportKort: TStringField;
    cdsRSEksplinierImportLangt: TStringField;
    cdsRSEksplinierKlausulbetingelse: TStringField;
    cdsRSEksplinierSubstKode: TStringField;
    cdsRSEksplinierDosKode: TStringField;
    cdsRSEksplinierDosTekst: TStringField;
    cdsRSEksplinierDosPeriod: TStringField;
    cdsRSEksplinierDosEnhed: TStringField;
    cdsRSEksplinierIndCode: TStringField;
    cdsRSEksplinierIndText: TStringField;
    cdsRSEksplinierTakstVersion: TStringField;
    cdsRSEksplinierIterationNr: TIntegerField;
    cdsRSEksplinierIterationInterval: TIntegerField;
    cdsRSEksplinierIterationType: TStringField;
    cdsRSEksplinierSupplerende: TStringField;
    cdsRSEksplinierDosStartDato: TStringField;
    cdsRSEksplinierDosSlutDato: TStringField;
    cdsRSEksplinierAdminCount: TIntegerField;
    cdsRSEksplinierAdminID: TIntegerField;
    cdsRSEksplinierAdminDate: TStringField;
    cdsRSEksplinierApotekBem: TStringField;
    cdsRSEksplinierOrdreInstruks: TStringField;
    cdsRSEksplinierRSLbnr: TIntegerField;
    cdsRSEksplinierRSLinienr: TIntegerField;
    cdsRSEksplinierAdministrationId: TLargeintField;
    cdsRSEksplinierFrigivStatus: TIntegerField;
    cdsRSEksplinierRSQueueStatus: TIntegerField;
    cdsRSEksplinierPrescriptionIdentifier: TLargeintField;
    cdsRSEksplinierOrderIdentifier: TLargeintField;
    cdsRSEksplinierEffectuationIdentifier: TLargeintField;
    cdsRSEksplinierPrivat: TIntegerField;
    cdsRSEksplinierBestiltAfNavn: TStringField;
    cdsRSEksplinierBestiltAfAutNr: TStringField;
    cdsRSEksplinierBestiltAfOrgNavn: TStringField;
    cdsRSEksplinierBestiltAfAdresse: TStringField;
    cdsRSEksplinierBestiltAfTelefon: TStringField;
    cdsRSEksplinierBestiltAfPostNr: TStringField;
    cdsRSEksplinierBestiltAfId: TStringField;
    cdsRSEksplinierBestiltAfIdType: TStringField;
    nxRSEkspLinPrescriptionIdentifier: TLargeintField;
    nxRSEkspLinOrderIdentifier: TLargeintField;
    nxRSEkspLinEffectuationIdentifier: TLargeintField;
    nxRSEkspLinPrivat: TIntegerField;
    nxRSEkspLinBestiltAfNavn: TStringField;
    nxRSEkspLinBestiltAfAutNr: TStringField;
    nxRSEkspLinBestiltAfOrgNavn: TStringField;
    nxRSEkspLinBestiltAfAdresse: TStringField;
    nxRSEkspLinBestiltAfTelefon: TStringField;
    nxRSEkspLinBestiltAfPostNr: TStringField;
    nxRSEkspLinBestiltAfId: TStringField;
    nxRSEkspLinBestiltAfIdType: TStringField;
    nxRSEkspLinListBestiltAfNavn: TStringField;
    nxRSEkspLinListBestiltAfOrgNavn: TStringField;
    mtReiDosTxt: TStringField;
    mtReiIndTxt: TStringField;
    cdsRSEkspeditionerPatPersonIdentifier: TStringField;
    cdsRSEkspeditionerPatPersonIdentifierSource: TWordField;
    cdsRSEkspeditionerPatOrganisationIdentifier: TStringField;
    cdsRSEkspeditionerPatOrganisationIdentifierSource: TWordField;
    nxRSEkspAfdeling: TIntegerField;
    nxRSEkspPatPersonIdentifier: TStringField;
    nxRSEkspPatPersonIdentifierSource: TWordField;
    nxRSEkspPatOrganisationIdentifier: TStringField;
    nxRSEkspPatOrganisationIdentifierSource: TWordField;
    nxRSEkspListPatPersonIdentifier: TStringField;
    nxRSEkspListPatPersonIdentifierSource: TWordField;
    nxRSEkspListPatOrganisationIdentifier: TStringField;
    nxRSEkspListPatOrganisationIdentifierSource: TWordField;
    timChkCert: TTimer;
    nqKoel: TnxQuery;
    mtLinOrdineretVarenr: TStringField;
    mtLinOrdineretAntal: TIntegerField;
    mtLinOrdineretUdlevType: TStringField;
    mtReiOrdineretVarenr: TStringField;
    mtReiOrdineretAntal: TIntegerField;
    mtReiOrdineretUdlevType: TStringField;
    cdsOrdHeader: TClientDataSet;
    cdsOrdHeaderLbnr: TIntegerField;
    cdsOrdHeaderLines: TDataSetField;
    cdsOrdHeaderAnnuller: TBooleanField;
    cdsOrdHeaderPaCprNr: TStringField;
    cdsOrdHeaderPaNvn: TStringField;
    cdsOrdHeaderForNavn: TStringField;
    cdsOrdHeaderAdr: TStringField;
    cdsOrdHeaderAdr2: TStringField;
    cdsOrdHeaderPostNr: TStringField;
    cdsOrdHeaderBy: TStringField;
    cdsOrdHeaderAmt: TStringField;
    cdsOrdHeaderTlf: TStringField;
    cdsOrdHeaderAlder: TStringField;
    cdsOrdHeaderBarn: TStringField;
    cdsOrdHeaderTilskud: TStringField;
    cdsOrdHeaderTilBrug: TStringField;
    cdsOrdHeaderLevering: TStringField;
    cdsOrdHeaderFriTxt: TStringField;
    cdsOrdHeaderYdNr: TStringField;
    cdsOrdHeaderYderCprNr: TStringField;
    cdsOrdHeaderYdNavn: TStringField;
    cdsOrdHeaderYdSpec: TStringField;
    cdsOrdHeaderOrdAnt: TIntegerField;
    cdsOrdHeaderLevinfo: TStringField;
    cdsOrdHeaderAP4: TBooleanField;
    cdsOrdHeaderDanmark: TBooleanField;
    cdsOrdHeaderKontonr: TStringField;
    cdsOrdHeaderSenderType: TStringField;
    cdsOrdHeaderSenderNavn: TStringField;
    cdsOrdHeaderIssuerTitel: TStringField;
    cdsOrdLinier: TClientDataSet;
    cdsOrdLinierVarenr: TStringField;
    cdsOrdLinierNavn: TStringField;
    cdsOrdLinierDisp: TStringField;
    cdsOrdLinierStrk: TStringField;
    cdsOrdLinierPakn: TStringField;
    cdsOrdLinierSubst: TStringField;
    cdsOrdLinierAntal: TIntegerField;
    cdsOrdLinierTilsk: TStringField;
    cdsOrdLinierIndKode: TStringField;
    cdsOrdLinierIndTxt: TStringField;
    cdsOrdLinierUdlev: TIntegerField;
    cdsOrdLinierForhdl: TStringField;
    cdsOrdLinierDosKode: TStringField;
    cdsOrdLinierDosTxt: TStringField;
    cdsOrdLinierPEMAdmDone: TIntegerField;
    cdsOrdLinierOrdid: TStringField;
    cdsOrdLinierReceptid: TIntegerField;
    cdsOrdLinierKlausulBetingelse: TBooleanField;
    cdsOrdLinierLbnr: TIntegerField;
    cdsOrdLinierUserPris: TCurrencyField;
    cdsOrdLinierSubVarenr: TStringField;
    cdsOrdLinierOrdineretVarenr: TStringField;
    cdsOrdLinierOrdineretAntal: TIntegerField;
    mtEks: TClientDataSet;
    mtEksKundeNr: TStringField;
    mtEksKundeType: TWordField;
    mtEksCtrType: TWordField;
    mtEksNarkoNr: TStringField;
    mtEksOrdreStatus: TWordField;
    mtEksOrdreType: TWordField;
    mtEksReceptStatus: TWordField;
    mtEksEkspType: TWordField;
    mtEksEkspForm: TWordField;
    mtEksAntLin: TWordField;
    mtEksLevNr: TStringField;
    mtEksLevNavn: TStringField;
    mtEksYderNr: TStringField;
    mtEksYderCprNr: TStringField;
    mtEksYderNavn: TStringField;
    mtEksDebitorNr: TStringField;
    mtEksDebitorNavn: TStringField;
    mtEksDebitorGrp: TWordField;
    mtEksAfdeling: TWordField;
    mtEksLager: TWordField;
    mtEksLeveringsForm: TWordField;
    mtEksGlCtrSaldo: TCurrencyField;
    mtEksNyCtrSaldo: TCurrencyField;
    mtEksCtrUdlign: TCurrencyField;
    mtEksYdCprChk: TBooleanField;
    mtEksNettoPriser: TBooleanField;
    mtEksUdbrGebyr: TCurrencyField;
    mtEksAvancePct: TCurrencyField;
    mtEksCtrUdlFor: TCurrencyField;
    mtEksCtrUdlignType: TWordField;
    mtEksCtrUdlignDato: TDateTimeField;
    mtEksPakkeNr: TIntegerField;
    mtEksTurNr: TIntegerField;
    mtEksLuPbs: TWordField;
    mtEksDebProcent: TCurrencyField;
    mtEksDosKortNr: TIntegerField;
    mtEksKontakt: TStringField;
    mtEksGlCtrSaldoB: TCurrencyField;
    mtEksNyCtrSaldoB: TCurrencyField;
    mtEksCtrUdlForB: TCurrencyField;
    mtEksCtrUdlignTypeB: TWordField;
    mtEksCtrUdlignDatoB: TDateTimeField;
    mtEksCtrUdlignB: TCurrencyField;
    mtEksKundeNavn: TStringField;
    mtEksLmsModtager: TStringField;
    cdsOrdHeaderOrdreDato: TDateTimeField;
    mtEksOrdreDato: TDateTimeField;
    ffLagKarTiSalgsPris: TCurrencyField;
    ffLagKarTiBGP: TCurrencyField;
    mtLinPoslistOverride: TBooleanField;
    ffEksLinUdstederAutId: TnxStringField;
    ffEksLinUdstederId: TnxStringField;
    ffEksLinUdstederType: TIntegerField;
    ffEksLinDrugId: TnxStringField;
    ffEksLinOpbevKode: TnxStringField;
    mtLinUdstederAutid: TStringField;
    mtLinUdstederId: TStringField;
    mtLinUdstederType: TIntegerField;
    mtLinOpbevKode: TStringField;
    mtReiUdstederAutid: TStringField;
    mtReiUdstederId: TStringField;
    mtReiUdstederType: TStringField;
    cdsOrdLinierUdstederAutid: TStringField;
    cdsOrdLinierUdstederId: TStringField;
    cdsOrdLinierUdstederType: TIntegerField;
    cdsOrdLinierDrugid: TStringField;
    cdsOrdLinierOpbevKode: TStringField;
    cdCtrLanISo: TClientDataSet;
    cdCtrLanISoNr: TIntegerField;
    cdCtrLanISoOperation: TStringField;
    cdCtrLanISoNavn: TStringField;
    cdCtrLanISoISOKode: TStringField;
    SQLConnection1: TSQLConnection;

    procedure C2Buttons;
    function ValidatePatKar: Boolean;
    procedure AfterScroll(DataSet: TDataSet);
    procedure dsStateChange(Sender: TObject);
    {
      procedure ffPatTilAfterScroll(DataSet: TDataSet);
      procedure dsPatTilStateChange(Sender: TObject);
    }
    procedure TableFilter(Cds: TClientDataSet);
    procedure MainDmCreate(Sender: TObject);
    procedure MainDmDestroy(Sender: TObject);
    procedure KontoNrMinMax(var FraNr, TilNr: String; Lst: TStringList);
    procedure KontoNrMinMax2(var FraNr, TilNr: String; Lst: TStringList);
    procedure cdDyrArtFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure cdDyrAldFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure cdDyrOrdFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure ffPatKarBeforePost(DataSet: TDataSet);
    procedure DKMedlemGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure DKMedlemSetText(Sender: TField; const Text: String);
    procedure TilskMetodeGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure TilskMetodeSetText(Sender: TField; const Text: String);
    procedure CtrTypeGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure CtrTypeSetText(Sender: TField; const Text: String);
    procedure JaNejGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure JaNejSetText(Sender: TField; const Text: String);
    procedure CtrPemGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure CtrPemSetText(Sender: TField; const Text: String);
    procedure EgenBetTypeGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure EgenBetTypeSetText(Sender: TField; const Text: String);
    procedure KundeTypeGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure KundeTypeSetText(Sender: TField; const Text: String);
    procedure OrdreTypeGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure OrdreTypeSetText(Sender: TField; const Text: String);
    procedure OrdreStatusGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure OrdreStatusSetText(Sender: TField; const Text: String);
    procedure EkspTypeGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure EkspTypeSetText(Sender: TField; const Text: String);
    procedure EkspFormGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure EkspFormSetText(Sender: TField; const Text: String);
    procedure LinieTypeGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure LinieTypeSetText(Sender: TField; const Text: String);
    procedure ffCliConnectionLost(aSource: TObject; aStarting: Boolean;
      var aRetry: Boolean);
    procedure DKOpdGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure DKOpdSetText(Sender: TField; const Text: String);
    procedure LevFormGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure LevFormSetText(Sender: TField; const Text: String);
    procedure fqEksOvrAfterScroll(DataSet: TDataSet);
    procedure ffPatKarLuPbsGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure mtEksOldLuPbsGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure ffCtrOpdCalcFields(DataSet: TDataSet);
    procedure ffEksOvrCalcFields(DataSet: TDataSet);
    procedure fqEksOvrCalcFields(DataSet: TDataSet);
    procedure ffdchKortStatusGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure ffLinOvrAfterScroll(DataSet: TDataSet);
    procedure ffDebKarBeforePost(DataSet: TDataSet);
    procedure nxOrdFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure ffLagKarAfterScroll(DataSet: TDataSet);
    procedure ffEksOvrAfterScroll(DataSet: TDataSet);
    procedure ffPatKarBeforeEdit(DataSet: TDataSet);
    procedure ffPatKarBeforeInsert(DataSet: TDataSet);
    procedure mtLinBeforePost(DataSet: TDataSet);
    procedure nxRSEkspListFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure timChkCertTimer(Sender: TObject);
  private
    { Private declarations }
    { I c:\Udvikling\CVS_Source\Apotek\Common\DebitorIntfcHdr }
    PatKtoOrder: string;
    FFejlCF5Ekspedition: Boolean;
    FDMVSSvrConnection: TC2DMVSSvrConnection;
    FDMVSReturDays: integer;
    FFejliDMVS: Boolean;
    FPraeparatnavnPaaEtiket: boolean;
    FMomsPercent: currency;
    FDosispakkegebyrVarenr: string;
    FReturDays: integer;
    FUdskrivLeverenceEtiketter: Boolean;
    FUdbrGebyr: Currency;
    FUdbrGebyrUdenMoms: Currency;
    FHKGebyr: Currency;
    FHKGebyrUdenMoms: Currency;
    FPlejehjemsGebyr: currency;
    FPlejehjemsGebyrUdenMoms: Currency;
    FTlfGebyr: Currency;
    FTlfGebyrUdenMoms: Currency;
    FEdbGebyrUdenMoms: Currency;
    FEdbGebyr: Currency;
    FDisableCPRModulusCheck: boolean;
    FEscapePressedInDMVS: boolean;
    FSpoergUdlA: Boolean;
    FBruger: TC2Bruger;
    FAfdeling: TC2Afdeling;
    FPrescriptionsForPO: TC2FMKPrescriptionsForPersonOrOrganisation;
    FFileSuffix: string;
    FFMKXMLLog: TStringList;
    FBRugerCertificateValid: boolean;
    FKeepReceptLokalt: boolean;
    FCF6DateWarning: boolean;
    FVisRecepterCF6: integer;
    FIsObjectValid: boolean;
    FDosiscardLokation: string;
    FUdskrivFakturaPrint: boolean;
    FUdskrivFakturaEmail: boolean;
    FUdskrivFakturaEmailTekst: TStringList;
    FTakserAutoEnter: boolean;
    FVaccinationPopUp: boolean;
    FRecepturplads: string;
    FAfdNr: word;
    FEHAutoEnter: boolean;
    FEHordre: boolean;
    FEHDibs: boolean;
    FEHCPR: boolean;
    FC2Web: Boolean;
    FC2WebOpdaterKundenr: Boolean;
    FCTRTestYear: integer;
    FTakserC2Nr: integer;
    FEHUseTidlPris: boolean;
    FCheckInteraktion: boolean;
    FC2UserName: string;
    FEorderPriceWithinLimits: Integer;
    FTakserUdenCTR: Boolean;
    FGemNyeRsFornavnEfternavn: Boolean;
    procedure BuildSqlStatements;
    function GetBrugerNr: integer;
    procedure SetBrugerNr(const Value: integer);
    function CreatePatientkartotekRecordFromRS_Ekspeditioner(AReceptid: integer): Boolean;
    function IsCTR2Enabled: Boolean;
    function CTR2GetFiktivId(ALandekode: integer; out ACtrFiktivId: string): Boolean;
    function GetAsylnCpr(ALevInfo: string; out AASylnCPR: string): Boolean;
    function Amt2Region(Amt: word): word;
  public
    { Public declarations }
    EdiDato: TDateTime;
    EdiFilter, EdiFilter2, DyreAnvFilter: Word;
    EkspTypFilter, EkspFrmFilter, LinTypFilter: set of byte;
    TmpSubDs: TDataSource;
    TmpSubFlds: String;
    Rowasl: TStringList;
    RSLokation: string;
    Reservation_Grossist: string;
    Server, Alias: String;
    KlausFlag: Boolean;
    DosisKortAutoExp: Boolean;
    DosiskortHeaderTerminal: integer;
    DosisKortLineBevillingNr: integer;
    DosiskortLineTerminal: integer;
    PatKarYdernr: string;
    PatKarYderCPrNr: string;
    DosisUdlignPatients: TStringList;
    C2GetCTRJobid: DWORD;
    sl_SQL_OpenEdi: TStringList;
    sl_Sql_GetOldOpenPakkenr: TStringList;
    sl_Sql_leveringliste: TStringList;
    sl_Sql_leveringlisteByListenr : TStringList;
    sl_Sql_subst_label : TStringList;
    sl_Sql_lms32_label : TStringList;
    AlleVnr: Boolean;
    PatientDosisCards: TC2FMKDoseDispensingCardList;
    property GemNyeRsFornavnEfternavn: Boolean read FGemNyeRsFornavnEfternavn write FGemNyeRsFornavnEfternavn;
    property FejlCF5Ekspedition: Boolean read FFejlCF5Ekspedition
      write FFejlCF5Ekspedition;
    property DMVSSvrConnection: TC2DMVSSvrConnection read FDMVSSvrConnection;
    property DMVSReturDays: integer read FDMVSReturDays;
    property FejliDMVS: Boolean read FFejliDMVS write FFejliDMVS;
    property PraeparatnavnPaaEtiket: boolean read FPraeparatnavnPaaEtiket write FPraeparatnavnPaaEtiket;
    property MomsPercent: currency read FMomsPercent write FMomsPercent;
    property DosispakkegebyrVarenr: string read FDosispakkegebyrVarenr write FDosispakkegebyrVarenr;
    property ReturDays: integer read FReturDays write FReturDays;
    property UdbrGebyr: Currency read FUdbrGebyr write FUdbrGebyr;
    property UdbrGebyrUdenMoms: Currency read FUdbrGebyrUdenMoms write FUdbrGebyrUdenMoms;
    property HKGebyr: Currency read FHKGebyr write FHKGebyr;
    property HKGebyrUdenMoms: Currency read FHKGebyrUdenMoms write FHKGebyrUdenMoms;
    property PlejehjemsGebyr : Currency read FPlejehjemsGebyr write FPlejehjemsGebyr;
    property PlejehjemsGebyrUdenMoms : Currency read FPlejehjemsGebyrUdenMoms write FPlejehjemsGebyrUdenMoms;
    property TlfGebyrUdenMoms: Currency read FTlfGebyrUdenMoms write FTlfGebyrUdenMoms;
    property TlfGebyr: Currency read FTlfGebyr write FTlfGebyr;
    property EdbGebyrUdenMoms: Currency read FEdbGebyrUdenMoms write FEdbGebyrUdenMoms;
    property EdbGebyr: Currency read FEdbGebyr write FEdbGebyr;
    property UdskrivLeverenceEtiketter: Boolean read FUdskrivLeverenceEtiketter write FUdskrivLeverenceEtiketter;
    property DisableCPRModulusCheck: boolean read FDisableCPRModulusCheck write FDisableCPRModulusCheck;
    property EscapePressedInDMVS : boolean read FEscapePressedInDMVS write FEscapePressedInDMVS;
    property Bruger:  TC2Bruger read FBruger write FBruger;
    property Afdeling: TC2Afdeling read FAfdeling write FAfdeling;
    property SpoergUdlA: Boolean read FSpoergUdlA write FSpoergUdlA;
    property PrescriptionsForPO: TC2FMKPrescriptionsForPersonOrOrganisation read FPrescriptionsForPO write  FPrescriptionsForPO;
    property FileSuffix: string read FFileSuffix write FFileSuffix;
    property FMKXMLLog: TStringList read FFMKXMLLog write FFMKXMLLog;
    property BrugerNr: integer read GetBrugerNr write SetBrugerNr;
    property BrugerCertificateValid: boolean read FBrugerCertificateValid write FBrugerCertificateValid;
    property KeepReceptLokalt: boolean read FKeepReceptLokalt write FKeepReceptLokalt;
    property CF6DateWarning: boolean read FCF6DateWarning write FCF6DateWarning;
    property VisRecepterCF6: integer read FVisRecepterCF6 write FVisRecepterCF6;
    property IsObjectValid: boolean read FIsObjectValid write FIsObjectValid;
    property DosiscardLokation: string read FDosiscardLokation write FDosiscardLokation;
    property UdskrivFakturaPrint: boolean read FUdskrivFakturaPrint write FUdskrivFakturaPrint;
    property UdskrivFakturaEmail: boolean read FUdskrivFakturaEmail write FUdskrivFakturaEmail;
    property UdskrivFakturaEmailTekst: TStringList read FUdskrivFakturaEmailTekst write FUdskrivFakturaEmailTekst;
    property TakserAutoEnter: boolean read FTakserAutoEnter write FTakserAutoEnter;
    property VaccinationPopUp: boolean read FVaccinationPopUp write FVaccinationPopUp;
    property Recepturplads: string read FRecepturplads write FRecepturplads;
    property CTRTestYear: integer read FCTRTestYear write FCTRTestYear;
    function OpdaterZeroBonLevlist(ALbnrList: TList<integer>): Word;
    function CountHandkoebLines(aLbnr : integer) : integer;
    property AfdNr: word read FAfdNr write FAfdNr;
    property EHordre: boolean read FEHordre write FEHordre;
    property EHAutoEnter: boolean read FEHAutoEnter write FEHAutoEnter;
    property EHDibs: boolean read FEHDibs write FEHDibs;
    property EHCPR: boolean read FEHCPR write FEHCPR;
    property C2Web: Boolean read FC2Web write FC2Web;
    property C2WebOpdaterKundenr: Boolean read FC2WebOpdaterKundenr write FC2WebOpdaterKundenr;
    property TakserC2Nr: integer read FTakserC2Nr write FTakserC2Nr;
    property TakserUdenCTR: Boolean read FTakserUdenCTR write FTakserUdenCTR;
    /// <summary>Returns the Vnr. of the largest package with the specified DrugID.</summary>
    /// <returns>True if a record was found in Lagerkartotek.</returns>
    function GetLargestPackByDrugID(ADatabase: TnxDatabase; ADrugID: Int64; out AVarenr: string;
      ALagernr: Integer = 0): Boolean;
    /// <summary>Returns the UdlevType in capitalized form.</summary>
    function GetVareUdlevType(ADatabase: TnxDatabase; AVarenr: string; out AUdlevType: string;
      ALagernr: Integer = 0): Boolean;
    function KoelProductOnEkspeditionSQL(ALbnr : integer) : boolean;
    function KoelProductOnEkspedition(ALbnr : integer) : boolean;
    function UdligningEkspedition( ALbnr : integer ) : boolean;
    function NulPakkelistEkspedition(Albnr : integer) : boolean;
    function FindLevnr(ALbnr: Integer): Boolean;
    function CheckFMKCertificate : boolean;
    function FMKCertificateExpiredSeconds: integer;
    function GetCtrFiktivId(ALandekode: Integer; out ACtrFiktivId: string): Boolean;
    property EHUseTidlPris: boolean read FEHUseTidlPris write FEHUseTidlPris;
    property CheckInteraktion: boolean read FCheckInteraktion write FCheckInteraktion;
    property C2UserName: string read FC2UserName write FC2UserName;
    property EorderPriceWithinLimits: Integer read FEorderPriceWithinLimits write FEorderPriceWithinLimits;
  end;

var
  MainDm: TMainDm;

implementation

uses

  ChkBoxes,
  C2Splash,
  C2MainLog,

  C2Procs,
  C2Date,
  RcpProcs,
  Main,
  frmC2CtrCountryList,
  uC2Ui.Procs,
  HentTekst,
  uC2Environment,
  uC2DMVS.Types, uC2DMVSSvr.Types,
  uC2Ui.MainLog.Procs,
  uc2common.procs,
  uCTRClientMethods,
  uCtr2.Connection.Response, uCtr2.Connection.Types,
  uctr2.Fault.Classes, uCtr2.Connection.Constants, uCTR2.CreateFictitiousPersonIdentifier.classes  uYesNo,
  uC2LokalServiceClient.Procs;


{$R *.DFM}

procedure C2ffOpenTables;
var
  nxt: TnxTable;
  nxq: TnxQuery;
  cmp: TComponent;
  arkivlist: TList<string>;
  ArkivMode: Boolean;
  LHeartbeatInterval : integer;
begin
  with MainLog, MainDm do
  begin
    arkivlist := TList<string>.Create;
    try
      C2LogAdd('MainDm read inifile setup');
      Server := C2Env.NexusServerAddress;
      Alias := C2Env.NexusAlias;
      LHeartbeatInterval := C2IntPrm('Database', 'HeartBeatInterval', -1);
      ArkivMode := caps(ExtractFileName(Application.ExeName)) = 'ARKIVPATIENTKARTOTEK.EXE';
      C2LogAdd('  Server ' + Server);
      C2LogAdd('  Alias ' + Alias);
      C2LogAdd('MainDm change aliases');
      nxTCPIPTrans.Close;

      if LHeartbeatInterval <> -1 then
      begin
        nxTCPIPTrans.HeartbeatInterval := LHeartbeatInterval;
        // ChkBoxOK('debug interval set to ' + IntToStr(LHeartbeatInterval));
      end;
//
      nxTCPIPTrans.ServerName := Server;
      nxTCPIPTrans.Open;
      nxdb.AliasName := Alias;
      nxdb.Open;
      if ArkivMode then
      begin
        for cmp in MainDm do
        begin
          if cmp Is TnxTable then
          begin
            nxt := cmp as TnxTable;
            if nxSess.TableExists('Arkiv', nxt.TableName, '') then
              arkivlist.Add(nxt.Name);
          end;
        end;
      end;
      try
        for cmp in MainDm do
        begin
          if cmp is TnxTable then
          begin
            nxt := cmp as TnxTable;
            // Åben kun primære tabeller - benyttes i nogle programmer
            // til forbindelser mod afdelinger
            if nxt.Tag = 0 then
            begin
//              C2LogAdd('before alias ' + nxt.Name + '-' + nxt.TableName);
              if ArkivMode then
              begin
                if arkivlist.IndexOf(nxt.Name) <> -1 then
                  nxt.AliasName := 'Arkiv'
                else
                  nxt.AliasName := Alias;
              end
              else
                nxt.AliasName := Alias;
              nxt.Session := nxSess;
            end;
          end;
          if cmp is TnxQuery then
          begin
            // Åben kun primære tabeller - benyttes i nogle programmer
            // til forbindelser mod afdelinger
            nxq := cmp as TnxQuery;
            if nxq.Tag = 0 then
            begin
              if (ArkivMode) and (caps(nxq.Name) = 'FQEKSOVR') then
                nxq.AliasName := 'Arkiv'

              else
                nxq.AliasName := Alias;

              nxq.Session := nxSess;
            end;
          end;
        end;
        C2LogAdd('MainDm change protocol');
        C2LogAdd('MainDm open transport');
        C2LogAdd('MainDm open session');
        nxSess.Active := True;
        C2LogAdd('MainDm open all fftables');
        for cmp in MainDm do
        begin
          if cmp is TnxTable then
          begin
            nxt := cmp as TnxTable;
            C2LogAdd('before open ' + nxt.Name);
            if nxt.Tag = 0 then
              nxt.Open;
          end;
        end;
        C2LogAdd('MainDm all fftables are open');
      except
        on e: exception do
        begin
          ChkBoxOK('Prøv at starte programmet igen. Hvis problemet fortsætter, så kontakt venligst CITO.' + sLineBreak +
            e.Message);
          C2LogAdd('Fejl i C2ffOpenTables ' + e.Message);
          Application.Terminate;
          exit;
        end;

      end;

      nxRemoteServerInfoPlugin1.Open;
      mtEks.CreateDataSet;
      cdsOrdHeader.Open;
      cdsOrdHeader.LogChanges := False;
      // try
      // SplashScreenUpdate('Henter kundeliste');
      // c2logadd(FormatDateTime('hh:mm:ss.zzz',Now));
      // //    ffPaLst.BlockReadSize := 1024*1024;
      // cdsPalst.IndexDefs.Clear;
      // cdsFileName := 'C:\c2\temp\' + C2SysUserName + '\patlst2.cds';
      // ForceDirectories(ExtractFilePath(cdsFileName));
      // if FileExists(cdsFileName) then
      // begin
      // if FileDateToDateTime( FileAge(cdsFileName)) < now - 6 then
      // DeleteFile(cdsFileName);
      // end;
      // if not FileExists(cdsFileName) then
      // begin
      // cdsPalst.ProviderName := dpPalst.Name;
      // cdsPalst.Open;
      // cdsPalst.LogChanges := False;
      // cdsPalst.SaveToFile(cdsFileName);
      // cdsPalst.Close;
      // end;
      // c2logadd(FormatDateTime('hh:mm:ss.zzz',Now));
      // cdsPalst.LoadFromFile(cdsFileName);
      // cdsPalst.ProviderName := '';
      // cdsPalst.Open;
      // cdsPalst.LogChanges := False;
      // UpdatePalst('6');
      // except
      // on e: exception do begin
      // if FileExists(cdsFileName) then
      // DeleteFile(cdsFileName);
      // C2LogAdd(e.Message);
      // ChkBoxOK('Der er fejl i liste til kundesøgning. Start ekspeditionsprogrammet igen.' + #10#13 +
      // 'Ny liste vil blive dannet. Det vil tage et par minutter.');
      // Application.Terminate;
      // end;
      //
      // end;
    finally
      arkivlist.Free;
      // C2LogSave;
      {
        if Error <> '' then
        raise EnxDatabaseError.Create (Error);
      }
    end;
  end;
end;

procedure C2ffCloseTables;
// var
// cdsFileName : string;
begin
  // with MainDm do
  // begin
  //
  // cdsFileName := 'C:\c2\temp\' + C2SysUserName + '\patlst2.cds';
  // ForceDirectories(ExtractFilePath(cdsFileName));
  // cdsPalst.LogChanges := False;
  //
  // cdsPalst.SaveToFile(cdsFileName);
  // end;
end;

{ I c:\Udvikling\CVS_Source\Apotek\Common\DebitorIntfcImpl }

procedure TMainDm.TableFilter(Cds: TClientDataSet);
begin
  Cds.Filtered := False;
  Cds.Filtered := True;
end;

procedure TMainDm.MainDmCreate(Sender: TObject);
var
  TomPatKey: String;
  FPladsNr: integer;
  AfdNr: integer;
  LAfdNr: Word;
  LLastErrMsg: string;
  j: integer;
  LAlleVarenr: string;
  ErrorString: string;
  LSql : TStringList;
begin
  TSplashScreen.UpdateActionText('Create datamodul');
  C2LogAdd('MainDm create in');
  FIsObjectValid := False;
  try
    // Reference til DebitorKartotek
    // DebitorKar    := Self;
    FC2UserName := C2SysUserName;
    FTakserUdenCTR := False;
    // FMK globals
    // Get the current Afdelingsnr
    C2Env.Log.AddLog('Kontakter C2 LokalService på ' + C2Env.C2ServerAddress + ' for arbejdsstation ' +
      C2Env.Arbejdsstation, 120006);
    if not GetAfdelingsnrFromC2LokalService(C2Env.C2ServerAddress, C2Env.Arbejdsstation, LAfdNr, LLastErrMsg) then
      C2Env.Log.AddLog(LLastErrMsg, 120007, cC2LogPrioritetError);
    FAfdeling := TC2Afdeling.Create(LAfdNr);
    FBruger := TC2Bruger.Create;
    PatientDosisCards := TC2FMKDoseDispensingCardList.Create;
    FPrescriptionsForPO := TC2FMKPrescriptionsForPersonOrOrganisation.Create;
    FMKXMLLog := TStringList.Create;
    if SetupC2FMKConnection then
    begin
      C2FMK.LogXMLRequests := lxrcNormal;
      C2FMK.LogXMLResponses := True;
      C2FMK.XMLLog := FMKXMLLog;
      C2FMK.XmlLogTransformerEnabled := True;
      C2FMK.XmlLogTransformerEnabled := C2FMK.GetXmlLogTransformerEnabledSetting(C2Env.Winpacer,
        C2FMK.XmlLogTransformerEnabled, C2Env.Arbejdsstation);
    end;



    TomPatKey := KundeKeyBlk;
    DyreAnvFilter := DyreAnvErhv;
    EkspTypFilter := EkspTypAlle;
    EkspFrmFilter := EkspFrmAlle;
    LinTypFilter := LinTypAlle;
    BuildSqlStatements;
    // Åben ClientDatasets
    // cdLmsSub.LoadFromFile('LmsSubst.cds');
    cdDspFrm.LoadFromFile('DispFormer.cds');
    // cdPnLst .LoadFromFile('PostNumre.cds');
    cdCtrLan.LoadFromFile('CtrLandeKoder.cds');
    cdCtrLan.IndexName := 'NavnOrden';
    cdDyrArt.LoadFromFile('DyreArter.cds');
    cdDyrAld.LoadFromFile('DyreAldGrp.cds');
    cdDyrOrd.LoadFromFile('DyreOrdGrp.cds');
    cdDosTxt.LoadFromFile('DosTekster.cds');
    cdIndTxt.LoadFromFile('IndikTekster.cds');
    cdKomEan.LoadFromFile('KommuneEan.cds');
    cdDrgDos.LoadFromFile('DrugDosRef.cds');
    cdDrgInd.LoadFromFile('DrugIndikRef.cds');
    if FileExists('GeneriskeNavne.cds') then
      cdsGeneriske.LoadFromFile('GeneriskeNavne.cds');

    if IsCTR2Enabled then
    begin
      if FileExists('CdsLandekodeISo.cds') then
      begin
        cdCtrLanISo.LoadFromFile('CdsLandekodeISo.cds');
        cdCtrLanISo.IndexName := 'NrOrden';
        dsCtrLan.DataSet := cdCtrLanISo;
      end;
    end;


    C2ffOpenTables;


    FCTRTestYear := C2IntPrm('Receptur', 'CTRTestYear', 0);

    if not CtrTilskudsSatser.SetupCTRTilskudValues(nxdb, FCTRTestYear, ErrorString) then
    begin
      ShowMessageBoxWithLogging(ErrorString);
      exit;
    end;
    C2LogAdd('Tilskgrp1 is ' + CurrToStr( TilskudsGrp1));
    C2LogAdd('Tilskgrp2 is ' + CurrToStr( TilskudsGrp2));
    C2LogAdd('Tilskgrp3 is ' + CurrToStr( TilskudsGrp3));
    C2LogAdd('KronikerGrpVoksen is ' + CurrToStr( KronikerGrpVoksen));
    C2LogAdd('KronikerGrpBarn is ' + CurrToStr( KronikerGrpBarn));


    try

      // Slet tomme cprnumre
      C2LogAdd('MainDm slet tomme patientnøgler');
      ffRcpOpl.First;
      ffPatKar.First;
      while not ffPatKar.Eof do
      begin
        if Trim(ffPatKarKundeNr.AsString) = '' then
          ffPatKar.delete
        else
          Break;
      end;
      // Edifact filter
      EdiFilter := 0;
      EdiFilter2 := 0;
      EdiDato := DateMinTime(Now);
      // Opret blank cprnr
      C2LogAdd('MainDm opret blank patientnøgle');
      ffPatKar.Insert;
      ffPatKarKundeNr.AsString := TomPatKey;
      ffPatKarKundeType.Value := 1;
      ffPatKarCprCheck.AsBoolean := True;
      ffPatKarFiktivtCprNr.AsBoolean := False;
      ffPatKarBarn.AsBoolean := False;
      ffPatKarNettoPriser.AsBoolean := False;
      ffPatKarEjSubstitution.AsBoolean := False;
      ffPatKarEjCtrReg.AsBoolean := False;
      ffPatKarDKMedlem.Value := 9;
      ffPatKar.Post;

    except
      on E: Exception do
        C2LogAdd('Error during delete and create of blank customer ');
    end;
    // Tøm ekspeditioner
    C2LogAdd('MainDm mtEks, mtLin, mtTak open');
    mtEks.Open;
    if mtEks.RecordCount <> 0 then
    begin
      mtEks.First;
      while not mtEks.Eof do
        mtEks.delete;
    end;
    // mtLin.Open;
    // mtTak.Open;
    // Start filtre
    // TableFilter (cdEksTyp);
    // TableFilter (cdEksFrm);
    // TableFilter (ffEksFrm);
    // TableFilter (cdLinTyp);
    TableFilter(cdDyrArt);
    // Reservation
    C2LogAdd('Open Grossister');
    mtGro.Open;
    if mtGro.RecordCount <> 0 then
    begin
      mtGro.First;
      while not mtGro.Eof do
        mtGro.delete;
    end;
    mtGro.Insert;
    mtGroGrNr.AsInteger := 0;
    fqKto.Close;
    fqKto.SQL.Add('SELECT');
    fqKto.SQL.Add('	g.GrNr');
    fqKto.SQL.Add('	,g.KontoNr');
    fqKto.SQL.Add('	,g.KortNavn');
    fqKto.SQL.Add('	,g.Lager');
    fqKto.SQL.Add('	,GrOplNr');
    fqKto.SQL.Add('	,g.Reservation');
    fqKto.SQL.Add('	,(g.Kontonr +'' - ''+ g.Navn) FullNavn');
    fqKto.SQL.Add('	,g.VMIStatus');
    fqKto.SQL.Add('	,o.VisVareHost');
    fqKto.SQL.Add('	,o.VisVarePort');
    fqKto.SQL.Add('FROM');
    fqKto.SQL.Add('	Grossister as g');
    fqKto.SQL.Add('inner join');
    fqKto.SQL.Add('	GrosBestOplysninger as o on o.GrNr=g.GrOplnr');
    fqKto.SQL.Add('WHERE');
    fqKto.SQL.Add('	g.Reservation>0');
    PatKtoOrder := C2StrPrm('Lager', 'PatKtoOrder', '');
    if PatKtoOrder <> '' then
      fqKto.SQL.Add('order by ' + PatKtoOrder);

    C2LogAdd('fqkto sql ' + fqKto.SQL.Text);
    fqKto.Open;

    if fqKto.Active then
    begin
      fqKto.Filtered := False;
      Reservation_Grossist := C2StrPrm(FC2UserName, 'Reservation_Grossist', '');
      if Reservation_Grossist <> '' then
      begin
        fqKto.FilterType := ftSqlWhere;
        fqKto.Filter := 'grnr in (' + Reservation_Grossist + ')';
        fqKto.Filtered := True;
      end;
      C2LogAdd('Reservation ' + IntToStr(fqKto.RecordCount));
      fqKto.First;
      mtGroGrNr.AsInteger := fqKto.FieldByName('GrNr').AsInteger;
      mtGroGrOplNr.AsInteger := fqKto.FieldByName('GrOplNr').AsInteger;
    end;
    Rowasl := TStringList.Create;
    // SetupTilskudLevels;
    PatKarYdernr := '';
    PatKarYderCPrNr := '';
    DosisUdlignPatients := TStringList.Create;
    C2GetCTRJobid := 0;

    // need the afdling nr for the dmvs server
    FPladsNr := C2Env.User.Arbejdspladsnr;
    C2LogAdd('MainDM Create PladsNr"' + FPladsNr.ToString + '"');
    // C2LogSave;
    // Test parametre
    if ffArbOpl.FindKey([FPladsNr]) then
    begin
      if ffLagNvn.FindKey([ffArbOplSpecLager.AsString]) then
      begin
        if ffAfdNvn.FindKey([ffArbOplAfdeling.AsString]) then
        begin
          // Husk AfdNr til taksering
          AfdNr := ffAfdNvnRefNr.AsInteger;
        end;
      end;
    end;

    FDMVSSvrConnection := TC2DMVSSvrConnection.Create(MainDm.nxdb, AfdNr, C2Env.Arbejdsstation, C2Env.C2ServerAddress);
    C2LogAdd('*** dmvs integration enablesd is ' + bool2str(FDMVSSvrConnection.DMVSIntegrationEnabled));

    FReturDays := 14;
    FReturDays := C2IntPrm('Receptur', 'ReturDays', FReturDays);
    // if Trunc(Now) > EncodeDate(2019,02,08) then
      if FReturDays > 10 then
        FReturDays := 10;

    if FDMVSSvrConnection.DMVSIntegrationEnabled then
      FDMVSReturDays := C2IntPrm('Receptur', 'DMVSReturDays', 9)
    else
      FDMVSReturDays := FReturDays;
    C2LogAdd('*** DMVSReturs days is ' + FDMVSReturDays.tostring);
    C2LogAdd('*** Returs days is ' + FReturDays.tostring);

    if FReturDays < fdmvsreturdays  then
    begin
      C2LogAdd('*** DMVSReturs days is now been updated to ' + FDMVSReturDays.tostring);
      FDMVSReturDays := FReturDays;
    end;


    FPraeparatnavnPaaEtiket := SameText(C2StrPrm('Receptur','PraeparatnavnPaaEtiket','Nej'),'Ja');

    LAlleVarenr := AnsiUpperCase(C2StrPrm('Receptkontrol', 'Allevarer', ''));
    AlleVnr := SameText(C2StrPrm(FC2UserName, 'StregkodekontrolAlleVarer', LAlleVarenr), 'JA');


    // set up MomsPercent property
    MomsPercent := 25.0;
    tbl_MomsTyper.IndexName := 'NrOrden';
    if tbl_MomsTyper.FindKey([22]) then
      MomsPercent := tbl_MomsTyperSats.AsCurrency;

    // set up the gebyr properties with and without Moms
    FUdbrGebyr := ffRcpOplUdbrGebyr.AsCurrency;
    FUdbrGebyrUdenMoms := FUdbrGebyr - BruttoMoms(FUdbrGebyr,MomsPercent);
    FHKGebyr := ffRcpOplHKgebyr.AsCurrency;
    FHKGebyrUdenMoms := FHKGebyr - BruttoMoms(FHKGebyr,MomsPercent);
    FPlejehjemsGebyr := ffRcpOplPlejehjemsgebyr.AsCurrency;
    FPlejehjemsGebyrUdenMoms := FPlejehjemsGebyr - BruttoMoms(FPlejehjemsGebyr,MomsPercent);
    FEdbGebyr := ffRcpOplEdbGebyr.AsCurrency;
    FEdbGebyrUdenMoms := FEdbGebyr - BruttoMoms(FEdbGebyr,MomsPercent);
    FTlfGebyr := ffRcpOplTlfGebyr.AsCurrency;
    FTlfGebyrUdenMoms := FTlfGebyr - BruttoMoms(FTlfGebyr,MomsPercent);

    // set up the dodis pakke gebyr number
    FDosispakkegebyrVarenr := C2StrPrm('Receptur','DosispakkegebyrVarenr','688002');

    UdskrivLeverenceEtiketter := SameText( C2StrPrm('Receptur','UdskrivLeverenceEtiketter','Nej'),'Ja');

    DisableCPRModulusCheck := SameText(C2StrPrm('Receptur','DisableCPRModulusCheck','Nej'),'Ja');

    SpoergUdlA := SameText(C2StrPrm('Receptur','SpørgUdlA','Ja'),'Ja');
    KeepReceptLokalt := SameText(C2StrPrm('Receptur','KeepReceptLokalt','Nej'),'Ja');
    BrugerCertificateValid := False;
    FCF6DateWarning := True;
    FVisRecepterCF6 := C2IntPrm('Receptur','VisRecepterCF6',60);
    FUdskrivFakturaPrint := False;
    FUdskrivFakturaEmail := False;
    FUdskrivFakturaEmailTekst := TStringList.Create;
    FTakserAutoEnter := SameText(C2StrPrm('Receptur', 'AutoEnter', 'Nej'),'JA');
    FVaccinationPopUp := SameText(C2StrPrm('Receptur','VaccinationPopUp','NEJ'),'JA');
    FRecepturplads := AnsiUpperCase(C2StrPrm(FC2UserName,'Recepturplads',''));

    // set ehandel autoenter if set in ehandel then it can be overriden in user
    // section
    FEHAutoEnter := SameText(C2StrPrm('EHandel', 'AutoEnter', 'Nej'),'Ja');
    if FEHAutoEnter then
      FEHAutoEnter := SameText(C2StrPrm(FC2UserName, 'EHAutoEnter', 'Ja'),'Ja');

    // Ehandel / C2Web settings
    if C2StrPrm('Ehandel', 'C2WebOpdaterKundenr', '') <> '' then
    begin
      FC2WebOpdaterKundenr := SameText(C2StrPrm('Ehandel', 'C2WebOpdaterKundenr', 'NEJ'), 'JA');
      FC2Web := SameText(C2StrPrm('Ehandel', 'C2Web', 'NEJ'),  'JA');
    end
    else
    begin
      FC2WebOpdaterKundenr := SameText(C2StrPrm('Ehandle', 'C2WebOpdaterKundenr', 'NEJ'),'JA');
      FC2Web := SameText(C2StrPrm('Ehandle', 'C2Web', 'NEJ'), 'JA');
    end;

    FEHUseTidlPris := SameText(C2StrPrm('Ehandel','UseTidlPris','Nej'),'Ja');
    if FEHUseTidlPris then
      FEHUseTidlPris := SameText(C2StrPrm(FC2UserName,'UseTidlPris','Ja'),'Ja')
    else
      FEHUseTidlPris := SameText(C2StrPrm(FC2UserName,'UseTidlPris','Nej'),'Ja');

    FCheckInteraktion := not SameText(C2StrPrm(FC2UserName, 'CheckInteraktion', ''),'NEJ');

    FEorderPriceWithinLimits := C2IntPrm('Ehandel','EorderPriceWithinLimits',0);
    FTakserC2Nr := 0;
    C2LogAdd('MainDm alt er klar');
    FIsObjectValid := True;

    LSql := TStringList.Create;
    try
      C2LogAdd('Before build sql ' + FormatDateTime('hh:mm:s.zzz',Now));
      LSql.add('SELECT count(*) as cnt');
      LSql.add('FROM EkspLinierSalg as s');
      LSql.add('where');
      LSql.add('lbnr=:lbnr');
      LSql.add('and');
      LSql.add('exists');
      LSql.add('( select opbevkode from lagerkartotek where lager=s.lager and varenr=s.subvarenr');
      LSql.add('and (opbevkode = ''H'' or opbevkode=''K''))');

      nqKoel.SQL.Text := lsql.text;
      nqKoel.Prepare;
    finally
      lsql.Free;
    end;

  finally
    C2LogAdd('MainDm create out');
  end;
end;

procedure TMainDm.MainDmDestroy(Sender: TObject);
begin
  C2LogAdd('MainDm destroy in');
  try
    C2ffCloseTables;
    Rowasl.Free;
    sl_Sql_leveringlisteByListenr.Free;
    sl_Sql_leveringliste.Free;
    sl_SQL_OpenEdi.Free;
    sl_Sql_GetOldOpenPakkenr.Free;
    sl_Sql_subst_label.Free;
    sl_Sql_lms32_label.Free;
    DosisUdlignPatients.Free;
    FDMVSSvrConnection.Free;
    FreeAndNil(FBruger);
    FreeAndNil(FAfdeling);
    FreeAndNil(FPrescriptionsForPO);
    FreeAndNil(FFMKXMLLog);
    FreeAndNil(PatientDosisCards);
    FreeAndNil(FUdskrivFakturaEmailTekst);
  finally
    C2LogAdd('MainDm destroy out');
  end;
end;

function TMainDm.KoelProductOnEkspeditionSQL(ALbnr: integer): boolean;
var
  LSql : TStringList;
begin
  Result := False;
  LSql := TStringList.Create;
  try
//    C2LogAdd('Before build sql ' + FormatDateTime('hh:mm:s.zzz',Now));
//    LSql.add('SELECT count(*) as cnt');
//    LSql.add('FROM EkspLinierSalg as s');
//    LSql.add('where');
//    LSql.add('lbnr=:lbnr');
//    LSql.add('and');
//    LSql.add('exists');
//    LSql.add('( select opbevkode from lagerkartotek where lager=s.lager and varenr=s.subvarenr');
//    LSql.add('and (opbevkode = ''H'' or opbevkode=''K''))');
    try
      with nqKoel do
      begin
        Close;
        ParamByName('lbnr').AsInteger := ALbnr;
        C2LogAdd(sql.Text);
        Open;
        C2LogAdd('after open query ' + FormatDateTime('hh:mm:s.zzz',Now));
        if not Eof then
        begin
          First;
          Result := fieldbyname('cnt').AsInteger <> 0;
        end;
        Close;

      end;

//      with nxdb.OpenQuery(LSql.Text,[ALbnr]) do
//      begin
//        try
//          C2LogAdd('after open query ' + FormatDateTime('hh:mm:s.zzz',Now));
//          if not Eof then
//          begin
//            First;
//            Result := fieldbyname('cnt').AsInteger <> 0;
//          end;
//
//        finally
//          Free;
//        end;
//
//      end;
    except
      on E: Exception do
        C2LogAdd('Fejl i KoelProductOnEkspedition ' + e.Message);
    end;
  finally
    LSql.Free;
    C2LogAdd('result is ' + BoolToStr(Result,true));
  end;
end;

function TMainDm.KoelProductOnEkspedition(ALbnr: integer): boolean;
var
  save_index : string;
begin
  with MainDm do
  begin
    Result := False;
    save_index := ffEksLin.IndexName;
    ffEksLin.IndexName := 'NrOrden';
    ffEksLin.SetRange([albnr],[albnr]);
    try
      ffEksLin.First;
      while not ffEksLin.Eof do
      begin

        if ffLagKar.FindKey([ffEksLinLager.AsInteger, ffEksLinSubVareNr.AsString]) then
        begin
          if (ffLagKarOpbevKode.AsString = 'H') or (ffLagKarOpbevKode.AsString = 'K') then
          begin
            Result := True;
            Break
          end;
        end;
        ffEksLin.Next;
      end;
    finally
      ffEksLin.CancelRange;
      ffEksLin.IndexName := save_index;
//      C2LogAdd('result is ' + BoolToStr(Result,true));
    end;

  end;
end;

procedure TMainDm.KontoNrMinMax(var FraNr, TilNr: String; Lst: TStringList);
var
  Idx: integer;
begin
  try
    ffEksOvr.DisableControls;
    ffEksOvr.IndexName := 'KontoNrOrden';
    if FraNr = '' then
      FraNr := '                   1';
    if TilNr = '' then
      TilNr := '99999999999999999999';
    ffEksOvr.SetRange([FraNr, 1, 1], [TilNr, 1, High(LongInt)]);
    ffEksOvr.First;
    FraNr := ffEksOvrKontoNr.AsString;
    ffEksOvr.Last;
    TilNr := ffEksOvrKontoNr.AsString;
    if Lst <> NIL then
    begin
      Lst.Clear;
      ffEksOvr.First;
      while not ffEksOvr.Eof do
      begin
        if ffEksOvrOrdreStatus.Value = 1 then
        begin
          Idx := Lst.IndexOf(ffEksOvrKontoNr.AsString);
          if Idx = -1 then
            Lst.Add(ffEksOvrKontoNr.AsString);
        end;
        ffEksOvr.Next;
      end;
    end;
  finally
    ffEksOvr.CancelRange;
    ffEksOvr.IndexName := 'KundeNrOrden';
    ffEksOvr.EnableControls;
  end;
end;

procedure TMainDm.KontoNrMinMax2(var FraNr, TilNr: String; Lst: TStringList);
var
  dfra: double;
  dtil: double;
  tst1: double;
begin
  try
    if FraNr = TilNr then
    begin
      Lst.Clear;
      Lst.Add(FraNr);
      exit;
    end;

    try
      dfra := StrToFloat(FraNr);
      dtil := StrToFloat(TilNr);
    except
      on e: exception do
      begin
        ChkBoxOK('Nummerinterval kan kun bestå af tal');
        exit;
      end;
    end;
    fqSqlSel.Close;
    fqSqlSel.SQL.Clear;
    fqSqlSel.SQL.Add('#t 100000');
    fqSqlSel.SQL.Add('select');
    fqSqlSel.SQL.Add('  *');
    fqSqlSel.SQL.Add('from');
    fqSqlSel.SQL.Add('(');
    fqSqlSel.SQL.Add('SELECT distinct kontonr from ekspeditioner');
    fqSqlSel.SQL.Add('union');
    fqSqlSel.SQL.Add('select distinct levnavn from ekspeditioner');
    fqSqlSel.SQL.Add(')');
    fqSqlSel.SQL.Add('where char_length(kontonr) <>0');
    fqSqlSel.SQL.Add('and kontonr  >= :franr');
    fqSqlSel.SQL.Add('and kontonr <= :tilnr');

    fqSqlSel.Filter := '';
    fqSqlSel.Filtered := False;
    fqSqlSel.ParamByName('franr').AsString := FraNr;
    fqSqlSel.ParamByName('tilnr').AsString := TilNr;
    try
      fqSqlSel.Open;
      if fqSqlSel.RecordCount > 0 then
      begin
        fqSqlSel.First;
        while not fqSqlSel.Eof do
        begin
          try
            tst1 := StrToFloat(fqSqlSel.FieldByName('Kontonr').AsString);
            if (tst1 >= dfra) and (tst1 <= dtil) then
              Lst.Add(fqSqlSel.FieldByName('Kontonr').AsString);
          except
          end;
          fqSqlSel.Next;
        end;
      end;
    except
      on e: exception do
      begin
        C2LogAdd('fqsqlsel error ' + e.Message);
      end;

    end;
  finally
    fqSqlSel.Close;
  end;
end;

function TMainDm.ValidatePatKar: Boolean;
var
  Res: Boolean;
  ilen: integer;
  // I: TStamForm;
  function KundeExistsOnInsert(const AKundenr : string) : Boolean;
  var

    LSQl : TnxQuery;
  begin
    try
      LSQl := nxdb.OpenQuery('select kundenr from patientkartotek where kundenr=:kundenr ' , [AKundenr]);
      try
        Result := not LSQl.IsEmpty;


      finally
        LSQl.Free;
      end;

    except
      on E: Exception do
      begin
        C2LogAddF('KundeExistsOnInsert : Kundenr %s : Fejl :"%s"',[AKundenr,e.Message]);
        Result := False;
      end;
    end;

  end;
begin
  with StamForm do
  begin
    Res := True;
    if ffPatKar.State = dsbrowse then
      ffPatKar.Refresh;
    // Check CprNr

    if Trim(EKundeNr.Text) = '' then
    begin
      EKundeNr.Color := clRed;
      EKundeNr.Font.Color := clWhite;
      C2StatusBar.Panels[2].Text := ' Kundenr kan ikke være blank';
      EKundeNr.SetFocus;
      EKundeNr.SelectAll;
      Result := False;
      exit;

    end;


    if ffPatKar.State = dsInsert then
    begin
      if KundeExistsOnInsert(StamForm.EKundeNr.Text) then
      begin
        StamForm.EKundeNr.Color := clRed;
        StamForm.EKundeNr.Font.Color := clWhite;
        StamForm.C2StatusBar.Panels[2].Text := ' Kundenr er allerede oprettet ';
        StamForm.EKundeNr.SetFocus;
        StamForm.EKundeNr.SelectAll;
        ShowMessageBoxWithLogging('Kundenr er allerede oprettet');
        exit(False);

      end;

    end;

    if length(EKundeNr.Text) > 10 then
    begin
      EKundeNr.Color := clRed;
      EKundeNr.Font.Color := clWhite;
      C2StatusBar.Panels[2].Text := ' Fejl i kundenr';
      EKundeNr.SetFocus;
      EKundeNr.SelectAll;
      Result := False;
      exit;

    end;
    if EKundeNr.Text <> '4000000999' then
    begin
      if ffPatKarCprCheck.AsBoolean then
      begin
        // fault 250 only check cprnr if kundenr is 10 digits
        if length(EKundeNr.Text) = 10 then
        begin
          EKundeNr.Color := clRed;
          EKundeNr.Font.Color := clWhite;
          if not DisableCPRModulusCheck then
          begin
            Res := (Res) and (CheckCprNr(ffPatKarKundeType.Value, ffPatKarKundeNr.AsString));
          end;
          if not Res then
          begin
            C2StatusBar.Panels[2].Text := ' Fejl i kundenr';
            EKundeNr.SetFocus;
            EKundeNr.SelectAll;
            Result := Res;
            exit;
          end;
        end;
        EKundeNr.Color := clWindow;
        EKundeNr.Font.Color := clWindowText;
      end;
    end;
    EKundeNr.Color := clWindow;
    EKundeNr.Font.Color := clWindowText;
    // Fiktivt CprNR
    if ffPatKarFiktivtCprNr.AsBoolean then
    begin
      EDato.Color := clRed;
      EDato.Font.Color := clWhite;
      if Trim(EDato.Text) <> '' then
      begin
        Res := (Res) and (CheckFodDato(EDato.Text));
        if not Res then
        begin
          EDato.SetFocus;
          EDato.SelectAll;
          C2StatusBar.Panels[2].Text := ' Fejl i fødselsdato';
          Result := Res;
          exit;
        end;
      end
      else
      begin
        Result := False;
        exit;
      end;
      EDato.Color := clWindow;
      EDato.Font.Color := clWindowText;
    end;
    // Check LmsModtager
    EModtager.Color := clRed;
    EModtager.Font.Color := clWhite;
    Res := (Res) and (CheckModtager(ffPatKarKundeType.Value, ffPatKarLmsModtager.AsString));
    if not Res then
    begin
      C2StatusBar.Panels[2].Text := ' Fejl i lms modtager';
      EModtager.SetFocus;
      EModtager.SelectAll;
      Result := Res;
      exit;
    end;
    if ffPatKarKundeType.AsInteger = 1 then
    begin
      if length(ffPatKarKundeNr.AsString) = 10 then
      begin
        if copy(ffPatKarLmsModtager.AsString, 1, 2) <= '31' then
        begin
          if ffPatKarKundeNr.AsString <> ffPatKarLmsModtager.AsString then
          begin
            C2StatusBar.Panels[2].Text := ' Lms-ID skal normalt være det samme som kundenummeret';
            EModtager.SetFocus;
            EModtager.SelectAll;
            Result := False;
            exit;
          end;
        end;

      end;
    end;
    EModtager.Color := clWindow;
    EModtager.Font.Color := clWindowText;
    // Check YderNr
    EYderNr.Color := clRed;
    EYderNr.Font.Color := clWhite;
    if (ffPatKarKundeType.AsInteger = 1) and
      (ffPatKarYderNr.AsString = '0000000') then
    begin
      EYderNr.SetFocus;
      EYderNr.SelectAll;
      C2StatusBar.Panels[2].Text := ' Fejl i ydernr';
      Result := False;
      exit;
    end;
    if not EHCPR then
    begin

      Res := (Res) and (CheckYderNr(ffPatKarKundeType.Value, ffPatKarYderNr.AsString));
      if not Res then
      begin
        EYderNr.SetFocus;
        EYderNr.SelectAll;
        C2StatusBar.Panels[2].Text := ' Fejl i ydernr';
        Result := Res;
        exit;
      end;
    end;
    EYderNr.Color := clWindow;
    EYderNr.Font.Color := clWindowText;

    // check ydercprnr
    EYderCprNr.Color := clRed;
    EYderCprNr.Font.Color := clWhite;
    C2LogAdd('autnr in validatepatkar is ' + ffPatKarYderCprNr.AsString);
    if ffPatKar.State <> dsbrowse then
      ffPatKarYderCprNr.AsString := caps(ffPatKarYderCprNr.AsString);
    ilen := length(Trim(ffPatKarYderCprNr.AsString));
    if ffPatKarKundeType.AsInteger in [1, 2] then
    begin

      if not(ilen in [0, 5, 10]) then
      begin
        C2LogAdd('autnr failed on length check');
        EYderCprNr.SetFocus;
        EYderCprNr.SelectAll;
        C2StatusBar.Panels[2].Text := ' Fejl i Aut.Nr.';
        Result := False;
        exit;
      end;

      if ilen = 5 then
      begin
        if not TRegEx.IsMatch(ffPatKarYderCprNr.AsString, '([0-9]|(B|C|D|F|G|H|J|K|L|M|N|P|Q|R|S|T|V|W|X|Y|Z)){5}') then
        begin
          C2LogAdd('autnr failed on valid char check');
          EYderCprNr.SetFocus;
          EYderCprNr.SelectAll;
          C2StatusBar.Panels[2].Text := ' Fejl i Aut.Nr. Kun vokalen Y er tilladt';
          Result := False;
          exit;
        end;

      end;

      if ilen = 10 then
      begin
        if not DisableCPRModulusCheck then
        begin

          if not(CheckCprNr(1, ffPatKarYderCprNr.AsString)) then
          begin
            C2LogAdd('autnr failed on checkcprnr');
            EYderCprNr.SetFocus;
            EYderCprNr.SelectAll;
            C2StatusBar.Panels[2].Text := ' Fejl i Aut.Nr.';
            Result := False;
            exit;
          end;
        end;
      end;
    end;
    EYderCprNr.Color := clWindow;
    EYderCprNr.Font.Color := clWindowText;

    // Check Instans
    // Ant := 0;
    // ffPatTil.First;
    // while not ffPatTil.Eof do begin
    // if ffPatTilInstans.AsString = 'Kommune' then
    // Inc (Ant);
    // ffPatTil.Next;
    // end;
    if ffPatKarKommune.AsInteger > 0 then
    begin
      // Der er kommunale bevillinger
      EKommune.Color := clRed;
      EKommune.Font.Color := clWhite;
      Res := (Res) and (CheckKommune(ffPatKarKundeType.Value, ffPatKarKommune.Value));
      ffInLst.IndexName := 'NrOrden';
      if not ffInLst.FindKey([ffPatKarKommune.Value]) then
        Res := False;

      if not Res then
      begin
        EKommune.SetFocus;
        EKommune.SelectAll;
        C2StatusBar.Panels[2].Text := ' Fejl i kommunenr';
        Result := Res;
        exit;
      end;
      EKommune.Color := clWindow;
      EKommune.Font.Color := clWindowText;
    end;
    // Check Amt
    if ffPatKar.State <> dsbrowse then
    begin
      EAmt.Color := clRed;
      EAmt.Font.Color := clWhite;

      Res := (Res) and (CheckAmt(ffPatKarKundeType.Value, ffPatKarAmt.Value));
      if not Res then
      begin
        EAmt.SetFocus;
        EAmt.SelectAll;
        C2StatusBar.Panels[2].Text := ' Fejl i regionsnummer';
        Result := Res;
        exit;
      end;
    end;
    EAmt.Color := clWindow;
    EAmt.Font.Color := clWindowText;
    C2StatusBar.Panels[2].Text := '';
    Result := Res;
  end;
end;

procedure TMainDm.ffPatKarBeforeEdit(DataSet: TDataSet);
begin
  PatKarYdernr := ffPatKarYderNr.AsString;
  PatKarYderCPrNr := ffPatKarYderCprNr.AsString;
end;

procedure TMainDm.ffPatKarBeforeInsert(DataSet: TDataSet);
begin
  PatKarYdernr := '';
  PatKarYderCPrNr := '';
end;

procedure TMainDm.ffPatKarBeforePost(DataSet: TDataSet);
var
  DebOk, DebJN: Boolean;
  DebNr: String;
  NytNr: integer;
  save_index: string;
  debgruppe: integer;
  deblager: integer;
  debafdeling: integer;
  ServerDateTime: TDateTime;
begin
  with StamForm do
  begin
    C2LogAdd('PatKar before Post in');
    nxRemoteServerInfoPlugin1.GetServerDateTime(ServerDateTime);
    if ffPatKar.State = dsInsert then
      ffPatKarOpretDato.AsDateTime := ServerDateTime
    else
      ffPatKarRetDato.AsDateTime := ServerDateTime;

    save_index := ffDebKar.IndexName;
    ffDebKar.IndexName := 'NrOrden';
    try
      ffPatKarDebitorNr.AsString := Trim(ffPatKarDebitorNr.AsString);
      if not Assigned(StamForm) then
        exit;
      C2LogAdd('  Assigned(Stamform)');
      if not KartotekPage.Visible then
        exit;
      C2LogAdd('  KartotekPage.Visible');
      if ffPatKarKundeType.AsInteger <> 1 then // Enkeltperson
        exit;
      if ffDebKar.FindKey([ffPatKarDebitorNr.AsString]) then
      begin
        C2LogAdd('  Debitor findes');
        // Debitor findes - ret stamoplysninger hvis privat
        if ffDebKarLevForm.AsInteger <> 1 then
          exit;
        C2LogAdd('  ffDebKarLevForm.AsInteger = 1');
        if (caps(C2StrPrm('Debitor', 'Autoret', 'Nej')) <> 'JA') then
          exit;
        if (ffDebKarNavn.AsString <> ffPatKarNavn.AsString) or
          (ffDebKarAdr1.AsString <> ffPatKarAdr1.AsString) or
          (ffDebKarAdr2.AsString <> ffPatKarAdr2.AsString) or
          (ffDebKarPostNr.AsString <> ffPatKarPostNr.AsString) or
          (ffDebKarTlfNr.AsString <> ffPatKarTlfNr.AsString) then
        begin
          if ChkBoxYesNo('Ajourfør debitor navn/adr1/adr2/postnr/tlf?', False)
          then
          begin
            C2LogAdd('  Ret debitor');
            // Ret debitor
            ffDebKar.Edit;
            ffDebKarNavn.AsString := ffPatKarNavn.AsString;
            ffDebKarAdr1.AsString := ffPatKarAdr1.AsString;
            ffDebKarAdr2.AsString := ffPatKarAdr2.AsString;
            ffDebKarPostNr.AsString := ffPatKarPostNr.AsString;
            ffDebKarTlfNr.AsString := ffPatKarTlfNr.AsString;
            ffDebKar.Post;
          end;
        end;
        exit;
      end;

      C2LogAdd('  Debitor findes IKKE');
      if (caps(C2StrPrm('Debitor', 'Autoopret', 'Nej')) <> 'JA') then
        exit;
      C2LogAdd('  STDsetup/Autodebitor = JA');
      if (ffPatKarNavn.AsString <> '') and (ffPatKarAdr1.AsString <> '') and
        (ffPatKarLevNr.AsString <> '') and (ffPatKarDebitorNr.AsString = '')
      then
      begin
        C2LogAdd('  Adresse oplysninger m.m.');
        // Evt. benyt gammelt PASYS fra STD
        DebOk := False;
        DebJN := False;
        DebNr := Trim(ffPatKarKontakt.AsString);
        if ffDebKar.FindKey([DebNr]) then
        begin
          // Vis debitor og spørg om opret
          DebOk := True;
          DebJN := frmYesNo.NewYesNoBox('Opret enkeltdebitor til kunde?' + sLineBreak +
            '  tidligere debitoroplysninger:' + sLineBreak + '  kontonr:' + #9 + ffDebKarKontoNr.AsString + sLineBreak +
            '  navn:' + #9 + ffDebKarNavn.AsString);
          if not DebJN then
          begin
            DebNr := '';
            DebOk := False;
          end;
        end;
        // Spørg om opret
        if not DebJN then
          DebJN := ChkBoxYesNo('Opret enkeltdebitor til kunde?', False);
        // Fortsæt hvis opret er ok
        if not DebJN then
          exit;
        C2LogAdd('  Opret debitor');
        if (ffPatKarNavn.AsString = '') or (ffPatKarAdr1.AsString = '') or (ffPatKarPostNr.AsString = '') then
        begin
          ChkBoxOK('Debitor ikke oprettet, mangler navn/adresse/postnr!');
          Abort;
          exit;
        end;
        // Check vi har basisoplysninger fra SQL
        fqSqlSel.Close;
        fqSqlSel.SQL.Clear;
        fqSqlSel.SQL.Text := 'SELECT * FROM DebitorKartotek WHERE KontoNr=''99999999'';';
        C2LogAdd(fqSqlSel.SQL.Text);
        try
          fqSqlSel.Filter := '';
          fqSqlSel.Filtered := False;
          fqSqlSel.Prepare;
          fqSqlSel.Open;
        except
          on e: exception do
          begin
            ChkBoxOK('Søgning afbrudt af server!' + sLineBreak + 'årsag "' + e.Message + '"' + sLineBreak +
              'Sql forespørgsel' + sLineBreak + fqSqlSel.SQL.Text);
          end;
        end;
        if fqSqlSel.RecordCount = 0 then
        begin
          ChkBoxOK('Debitor ikke oprettet, ingen master!');
          exit;
        end;
        // Nyt nr fra master
        if DebNr = '' then
        begin
          NytNr := fqSqlSel.FieldByName('MasterFra').AsInteger;
          while ffDebKar.FindKey([IntToStr(NytNr)]) do
          begin
            Inc(NytNr);
            if NytNr > fqSqlSel.FieldByName('MasterTil').AsInteger then
              Break;
          end;
          if NytNr > fqSqlSel.FieldByName('MasterTil').AsInteger then
          begin
            ChkBoxOK('Debitor ikke oprettet, ingen ledige numre!');
            exit;
          end;
          DebNr := IntToStr(NytNr);
        end;
        // Opret debitor
        if DebOk then
        begin
          C2LogAdd('  Before edit');
          if ffDebKar.FindKey([DebNr]) then
          begin
            ffDebKar.Edit;
            ffDebKarNavn.AsString := ffPatKarNavn.AsString;
            ffDebKarAdr1.AsString := ffPatKarAdr1.AsString;
            ffDebKarAdr2.AsString := ffPatKarAdr2.AsString;
            ffDebKarPostNr.AsString := ffPatKarPostNr.AsString;
            ffDebKarTlfNr.AsString := ffPatKarTlfNr.AsString;
            ffDebKar.Post;
          end;
        end
        else
        begin
          debgruppe := fqSqlSel.FieldByName('DebGruppe').AsInteger;
          deblager := fqSqlSel.FieldByName('Lager').AsInteger;
          debafdeling := fqSqlSel.FieldByName('Afdeling').AsInteger;
          if (caps(C2StrPrm('Debitor', 'AutoopretValg', 'Nej')) = 'JA') then
          begin
            debgruppe := ChkBoxInt('Debitor gruppe', debgruppe);
            deblager := ChkBoxInt('Debitor Lager', deblager);
            debafdeling := ChkBoxInt('Debitor Afdeling', debafdeling);
          end;
          C2LogAdd('  Before insert');
          ffDebKar.Insert;
          C2LogAdd('  After insert');
          ffDebKarKontoNr.AsString := DebNr;
          ffDebKarNavn.AsString := ffPatKarNavn.AsString;
          ffDebKarAdr1.AsString := ffPatKarAdr1.AsString;
          ffDebKarAdr2.AsString := ffPatKarAdr2.AsString;
          ffDebKarPostNr.AsString := ffPatKarPostNr.AsString;
          ffDebKarTlfNr.AsString := ffPatKarTlfNr.AsString;
          C2LogAdd('  After stamoplysninger');
          ffDebKarDebGruppe.AsInteger := debgruppe;
          ffDebKarDebType.AsInteger := fqSqlSel.FieldByName('DebType').AsInteger;
          ffDebKarLager.AsInteger := deblager;
          ffDebKarAfdeling.AsInteger := debafdeling;
          ffDebKarKreditForm.AsInteger := fqSqlSel.FieldByName('KreditForm').AsInteger;
          ffDebKarMomsType.AsInteger := fqSqlSel.FieldByName('MomsType').AsInteger;
          ffDebKarBetalForm.AsInteger := fqSqlSel.FieldByName('BetalForm').AsInteger;
          C2LogAdd('  After betalingsform');
          ffDebKarLevForm.AsInteger := fqSqlSel.FieldByName('LevForm').AsInteger;
          C2LogAdd('  After leveringsform');
          ffDebKarRenteType.AsInteger := fqSqlSel.FieldByName('RenteType').AsInteger;
          ffDebKarRabatType.AsInteger := fqSqlSel.FieldByName('RabatType').AsInteger;
          C2LogAdd('  After Rabattype');
          ffDebKarSaldoType.AsInteger := fqSqlSel.FieldByName('SaldoType').AsInteger;
          C2LogAdd('  After Saldotype');
          ffDebKarUdbrGebyr.AsBoolean := fqSqlSel.FieldByName('UdbrGebyr').AsBoolean;
          C2LogAdd('  After udbr.gebyr');
          ffDebKarKontoGebyr.AsBoolean := fqSqlSel.FieldByName('KontoGebyr').AsBoolean;
          C2LogAdd('  After kontogebyr');
          ffDebKarFaktForm.AsInteger := fqSqlSel.FieldByName('FaktForm').AsInteger;
          ffDebKarKreditMax.AsCurrency := fqSqlSel.FieldByName('KreditMax').AsCurrency;
          ffDebKarAvancePct.AsCurrency := fqSqlSel.FieldByName('AvancePct').AsCurrency;
          C2LogAdd('  After avanceprocent');
          ffDebKarOpretDato.AsDateTime := ServerDateTime;
          ffDebKarKontoLukket.AsBoolean := False;
          ffDebKarMaster.AsBoolean := False;
          ffDebKarMasterFra.AsString := '';
          ffDebKarMasterTil.AsString := '';
          C2LogAdd('  Before post');
          ffDebKar.Post;
          C2LogAdd('  After post');
        end;
        // Opdater patient med debitornr
        ffPatKarDebitorNr.AsString := ffDebKarKontoNr.AsString;
        ffPatKarKontakt.AsString := ffDebKarKontoNr.AsString;
        fqSqlSel.Close;
      end;
    finally
      ffDebKar.IndexName := save_index;
    end;
    C2LogAdd('PatKar before Post out');
  end;
end;

procedure TMainDm.BuildSqlStatements;
begin
  // SQL_Openedi
  sl_SQL_OpenEdi := TStringList.Create;
  sl_SQL_OpenEdi.Add('select');
  sl_SQL_OpenEdi.Add('	top 1 *');
  sl_SQL_OpenEdi.Add('from');
  sl_SQL_OpenEdi.Add('(');
  sl_SQL_OpenEdi.Add('SELECT');
  sl_SQL_OpenEdi.Add('	PatCPR as PatCPRnr');
  sl_SQL_OpenEdi.Add('	,dato');
  sl_SQL_OpenEdi.Add('	,ReceptId');
  sl_SQL_OpenEdi.Add('	,Lbnr as Status');
  sl_SQL_OpenEdi.Add('FROM');
  sl_SQL_OpenEdi.Add('	RS_Ekspeditioner as rs');

  sl_SQL_OpenEdi.Add('WHERE');
  sl_SQL_OpenEdi.Add('	PatCPR=:CPRNr');
  sl_SQL_OpenEdi.Add('	and dato > current_timestamp - interval ''6'' month');
  sl_SQL_OpenEdi.Add(') as x');
  sl_SQL_OpenEdi.Add('left join');
  sl_SQL_OpenEdi.Add('	rs_Eksplinier as lin on lin.receptid=x.receptid');
  sl_SQL_OpenEdi.Add('where');
  sl_SQL_OpenEdi.Add
    ('	coalesce(lin.frigivstatus,0) <> 1 and lin.dosstartdato is null and coalesce(lin.RSLbnr,0) =0 and lin.receptid is not null');
  sl_SQL_OpenEdi.Add('order by');
  sl_SQL_OpenEdi.Add('	dato desc');
//  C2LogAdd(sl_SQL_OpenEdi.Text);


  // sql_leveringlist
  sl_Sql_leveringliste := TStringList.Create;

  sl_Sql_leveringliste.Add('declare ilbnr integer;');
  sl_Sql_leveringliste.Add('set ilbnr=');
  sl_Sql_leveringliste.Add('(');                            // Sql_GetOldOpenPakkenr
  sl_Sql_GetOldOpenPakkenr := TStringList.Create;
  sl_Sql_GetOldOpenPakkenr.Add('SELECT');
  sl_Sql_GetOldOpenPakkenr.Add('	Kundenr');
  sl_Sql_GetOldOpenPakkenr.Add('	,PakkeNr');
  sl_Sql_GetOldOpenPakkenr.Add('	,OrdreStatus');
  sl_Sql_GetOldOpenPakkenr.Add('	,Sum(udbrGebyr) as Udbg');
  sl_Sql_GetOldOpenPakkenr.Add('FROM');
  sl_Sql_GetOldOpenPakkenr.Add('	ekspeditioner');
  sl_Sql_GetOldOpenPakkenr.Add('where');
  sl_Sql_GetOldOpenPakkenr.Add('	Pakkenr<>0');
  sl_Sql_GetOldOpenPakkenr.Add('	and OrdreStatus=1');
  sl_Sql_GetOldOpenPakkenr.Add('	and Kundenr=:Kundenr');
  sl_Sql_GetOldOpenPakkenr.Add('	and Kontonr=:kontonr');

  sl_Sql_GetOldOpenPakkenr.Add('group by');
  sl_Sql_GetOldOpenPakkenr.Add('	Kundenr');
  sl_Sql_GetOldOpenPakkenr.Add('	,Pakkenr');
  sl_Sql_GetOldOpenPakkenr.Add('	,Ordrestatus');
  sl_Sql_GetOldOpenPakkenr.Add('order by');
  sl_Sql_GetOldOpenPakkenr.Add('	Kundenr');
  sl_Sql_GetOldOpenPakkenr.Add('	,Pakkenr');

  sl_Sql_leveringliste.Add('SELECT top 1  ' + fnEkspeditionerLbNr + ' FROM 	' + tnEkspeditioner + ' where');
  sl_Sql_leveringliste.Add('				' + fnEkspeditionerTakserDato + '<cast(:fradato as datetime)');
  sl_Sql_leveringliste.Add('				order by ' + fnEkspeditionerLbNr + ' desc');
  sl_Sql_leveringliste.Add(');');

  sl_Sql_leveringliste.Add('if ilbnr is null then');
  sl_Sql_leveringliste.Add('set ilbnr=1;');
  sl_Sql_leveringliste.Add('end if;');


  sl_Sql_leveringliste.Add('SELECT');
  sl_Sql_leveringliste.Add('	Navn');
  sl_Sql_leveringliste.Add('	,Address');
  sl_Sql_leveringliste.Add('	,Lbnr');
  sl_Sql_leveringliste.Add('	,Pakkenr');
  sl_Sql_leveringliste.Add('	,FakturaNr');
  sl_Sql_leveringliste.Add('	,Andel');
  sl_Sql_leveringliste.Add('	,BrugerKontrol');
  sl_Sql_leveringliste.Add('	,OrdreStatus');
  sl_Sql_leveringliste.Add('	,Kontonr');
  sl_Sql_leveringliste.Add('	,Kundenr');
  sl_Sql_leveringliste.Add('	,EkspType');
  sl_Sql_leveringliste.Add('	,OrdreType');
  sl_Sql_leveringliste.Add('	 ,antlin');
  sl_Sql_leveringliste.Add('from');
  sl_Sql_leveringliste.Add('	(');
  sl_Sql_leveringliste.Add('	Select');
  sl_Sql_leveringliste.Add('		' + fnEkspeditionerNavn);
  sl_Sql_leveringliste.Add('		,(' + fnEkspeditionerAdr1 + '+ '' '' +'+ fnEkspeditionerPostNr + ') as Address');
  sl_Sql_leveringliste.Add('		,' + fnEkspeditionerLbNr);
  sl_Sql_leveringliste.Add('		,' + fnEkspeditionerPakkenr);
  sl_Sql_leveringliste.Add('		,' + fnEkspeditionerFakturaNr);
  sl_Sql_leveringliste.Add('		,case');
  sl_Sql_leveringliste.Add('			when ' + fnEkspeditionerOrdreType +' = 2');
  sl_Sql_leveringliste.Add('				then');
  sl_Sql_leveringliste.Add('					0 - (' +fnEkspeditionerAndel+ '+' + fnEkspeditionerTlfGebyr + '+' + fnEkspeditionerEdbGebyr + '+' + fnEkspeditionerUdbrGebyr +')');
  sl_Sql_leveringliste.Add('				else');
  sl_Sql_leveringliste.Add('					(' +fnEkspeditionerAndel+ '+' + fnEkspeditionerTlfGebyr + '+' + fnEkspeditionerEdbGebyr + '+' + fnEkspeditionerUdbrGebyr + ')');
  sl_Sql_leveringliste.Add('		end as Andel');
  sl_Sql_leveringliste.Add('		,'+ fnEkspeditionerBrugerKontrol);
  sl_Sql_leveringliste.Add('		,'+ fnEkspeditionerLevNavn);
  sl_Sql_leveringliste.Add('		,'+ fnEkspeditionerKontonr);
  sl_Sql_leveringliste.Add('		,'+ fnEkspeditionerOrdreStatus);
  sl_Sql_leveringliste.Add('		,case');
  sl_Sql_leveringliste.Add('			when '+ fnEkspeditionerOrdreStatus +'=2');
  sl_Sql_leveringliste.Add('	 			then');
  sl_Sql_leveringliste.Add('				 '+	fnEkspeditionerAfsluttetDato);
  sl_Sql_leveringliste.Add('				else');
  sl_Sql_leveringliste.Add('				 '+	fnEkspeditionerTakserDato);
  sl_Sql_leveringliste.Add('		end as Dato');
  sl_Sql_leveringliste.Add('		,' + fnEkspeditionerTurNr);
  sl_Sql_leveringliste.Add('		,' + fnEkspeditionerOrdreType);
  sl_Sql_leveringliste.Add('		,' + fnEkspeditionerKundenr);
  sl_Sql_leveringliste.Add('		,' + fnEkspeditionerEkspType);
  sl_Sql_leveringliste.Add('    ,antlin');
  sl_Sql_leveringliste.Add('	FROM');
  sl_Sql_leveringliste.Add('		' + tnEkspeditioner + ' as eksp');
  sl_Sql_leveringliste.Add('	where');
  sl_Sql_leveringliste.Add('		' + fnEkspeditionerlbnr +'>= ilbnr');
  sl_Sql_leveringliste.Add('	order by');
  sl_Sql_leveringliste.Add('		' + fnEkspeditionerlbnr);
  sl_Sql_leveringliste.Add('');
  sl_Sql_leveringliste.Add('	) as E');
  sl_Sql_leveringliste.Add('where');
  sl_Sql_leveringliste.Add('		E.Dato >= cast(:Fradato as datetime) and');
  sl_Sql_leveringliste.Add('		E.Dato<= cast(:TilDato as datetime) and');
  sl_Sql_leveringliste.Add('		(e.levnavn=:konto or kontonr=:konto) and');
  sl_Sql_leveringliste.Add('		e.turnr>=:StartTur and e.Turnr<=:EndTur');
  sl_Sql_leveringliste.Add('');
  sl_Sql_leveringliste.Add('');
  sl_Sql_leveringliste.Add('order by');
  sl_Sql_leveringliste.Add('	Navn');
  sl_Sql_leveringliste.Add('	,Kundenr');
  sl_Sql_leveringliste.Add('	,PakkeNr');
//  C2LogAdd(sl_Sql_leveringliste.Text);

  // sql_leveringlistByLiastenr
  sl_Sql_leveringlisteByListenr := TStringList.Create;


  sl_Sql_leveringlisteByListenr.Add('SELECT');
  sl_Sql_leveringlisteByListenr.Add('	Navn');
  sl_Sql_leveringlisteByListenr.Add('	,Address');
  sl_Sql_leveringlisteByListenr.Add('	,Lbnr');
  sl_Sql_leveringlisteByListenr.Add('	,Pakkenr');
  sl_Sql_leveringlisteByListenr.Add('	,FakturaNr');
  sl_Sql_leveringlisteByListenr.Add('	,Andel');
  sl_Sql_leveringlisteByListenr.Add('	,BrugerKontrol');
  sl_Sql_leveringlisteByListenr.Add('	,OrdreStatus');
  sl_Sql_leveringlisteByListenr.Add('	,Kontonr');
  sl_Sql_leveringlisteByListenr.Add('	,Kundenr');
  sl_Sql_leveringlisteByListenr.Add('	,EkspType');
  sl_Sql_leveringlisteByListenr.Add('	,OrdreType');
  sl_Sql_leveringlisteByListenr.Add('	 ,antlin');
  sl_Sql_leveringlisteByListenr.Add('from');
  sl_Sql_leveringlisteByListenr.Add('	(');
  sl_Sql_leveringlisteByListenr.Add('	Select');
  sl_Sql_leveringlisteByListenr.Add('		' + fnEkspeditionerNavn);
  sl_Sql_leveringlisteByListenr.Add('		,(' + fnEkspeditionerAdr1 + '+ '' '' +'+ fnEkspeditionerPostNr + ') as Address');
  sl_Sql_leveringlisteByListenr.Add('		,' + fnEkspeditionerLbNr);
  sl_Sql_leveringlisteByListenr.Add('		,' + fnEkspeditionerPakkenr);
  sl_Sql_leveringlisteByListenr.Add('		,' + fnEkspeditionerFakturaNr);
  sl_Sql_leveringlisteByListenr.Add('		,case');
  sl_Sql_leveringlisteByListenr.Add('			when ' + fnEkspeditionerOrdreType +' = 2');
  sl_Sql_leveringlisteByListenr.Add('				then');
  sl_Sql_leveringlisteByListenr.Add('					0 - (' +fnEkspeditionerAndel+ '+' + fnEkspeditionerTlfGebyr + '+' + fnEkspeditionerEdbGebyr + '+' + fnEkspeditionerUdbrGebyr +')');
  sl_Sql_leveringlisteByListenr.Add('				else');
  sl_Sql_leveringlisteByListenr.Add('					(' +fnEkspeditionerAndel+ '+' + fnEkspeditionerTlfGebyr + '+' + fnEkspeditionerEdbGebyr + '+' + fnEkspeditionerUdbrGebyr + ')');
  sl_Sql_leveringlisteByListenr.Add('		end as Andel');
  sl_Sql_leveringlisteByListenr.Add('		,'+ fnEkspeditionerBrugerKontrol);
  sl_Sql_leveringlisteByListenr.Add('		,'+ fnEkspeditionerLevNavn);
  sl_Sql_leveringlisteByListenr.Add('		,'+ fnEkspeditionerKontonr);
  sl_Sql_leveringlisteByListenr.Add('		,'+ fnEkspeditionerOrdreStatus);
  sl_Sql_leveringlisteByListenr.Add('		,case');
  sl_Sql_leveringlisteByListenr.Add('			when '+ fnEkspeditionerOrdreStatus +'=2');
  sl_Sql_leveringlisteByListenr.Add('	 			then');
  sl_Sql_leveringlisteByListenr.Add('				 '+	fnEkspeditionerAfsluttetDato);
  sl_Sql_leveringlisteByListenr.Add('				else');
  sl_Sql_leveringlisteByListenr.Add('				 '+	fnEkspeditionerTakserDato);
  sl_Sql_leveringlisteByListenr.Add('		end as Dato');
  sl_Sql_leveringlisteByListenr.Add('		,' + fnEkspeditionerTurNr);
  sl_Sql_leveringlisteByListenr.Add('		,' + fnEkspeditionerOrdreType);
  sl_Sql_leveringlisteByListenr.Add('		,' + fnEkspeditionerKundenr);
  sl_Sql_leveringlisteByListenr.Add('		,' + fnEkspeditionerEkspType);
  sl_Sql_leveringlisteByListenr.Add('    ,antlin');
  sl_Sql_leveringlisteByListenr.Add('	FROM');
  sl_Sql_leveringlisteByListenr.Add('		' + tnEkspeditioner + ' as eksp');
  sl_Sql_leveringlisteByListenr.Add('	where');
  sl_Sql_leveringlisteByListenr.Add('		' + fnEkspeditionerlbnr +' in (select lbnr from EkspLeveringsListe where Listenr=:listenr)');
  sl_Sql_leveringlisteByListenr.Add('	order by');
  sl_Sql_leveringlisteByListenr.Add('		' + fnEkspeditionerlbnr);
  sl_Sql_leveringlisteByListenr.Add('');
  sl_Sql_leveringlisteByListenr.Add('	) as E');
  sl_Sql_leveringlisteByListenr.Add('');
  sl_Sql_leveringlisteByListenr.Add('order by');
  sl_Sql_leveringlisteByListenr.Add('	Navn');
  sl_Sql_leveringlisteByListenr.Add('	,Kundenr');
  sl_Sql_leveringlisteByListenr.Add('	,PakkeNr');
//  C2LogAdd(sl_Sql_leveringlisteByListenr.Text);


  sl_Sql_subst_label := TStringList.Create;
  sl_Sql_subst_label.Add('declare gebyr money;');
  sl_Sql_subst_label.Add('set gebyr=(select rcpgebyr from recepturoplysninger);');
  sl_Sql_subst_label.Add('');
  sl_Sql_subst_label.Add('SELECT');
  sl_Sql_subst_label.Add('  Sub.SubNr,');
  sl_Sql_subst_label.Add('  V.Navn,');
  sl_Sql_subst_label.Add('  COALESCE(V.Antal, 0) AS Antal,');
  sl_Sql_subst_label.Add('  (CASE WHEN V.HaType<>''''');
  sl_Sql_subst_label.Add('   THEN');
  sl_Sql_subst_label.Add('   (CASE WHEN V.EgenPris<>0');
  sl_Sql_subst_label.Add('    THEN V.Egenpris + gebyr');
  sl_Sql_subst_label.Add('    ELSE V.Salgspris + gebyr');
  sl_Sql_subst_label.Add('    END)');
  sl_Sql_subst_label.Add('   ELSE');
  sl_Sql_subst_label.Add('   (CASE WHEN V.EgenPris<>0');
  sl_Sql_subst_label.Add('    THEN V.Egenpris');
  sl_Sql_subst_label.Add('    ELSE V.Salgspris');
  sl_Sql_subst_label.Add('    END)');
  sl_Sql_subst_label.Add('   END) AS SalgsPris');
  sl_Sql_subst_label.Add('FROM');
  sl_Sql_subst_label.Add(' LagerSubstListe  as sub');
  sl_Sql_subst_label.Add('INNER join LagerKartotek AS V on v.varenr=sub.subnr and v.lager=cast(:lager as integer)');
  sl_Sql_subst_label.Add('WHERE');
  sl_Sql_subst_label.Add('  sub.varenr=:varenr and');
  sl_Sql_subst_label.Add('  V.AfmDato IS NULL and');
  sl_Sql_subst_label.Add('  v.sletdato is null and');
  sl_Sql_subst_label.Add('  V.SubKode=''A''');
  sl_Sql_subst_label.Add('  and   sub.antpkn=0');
  sl_Sql_subst_label.Add('');
  sl_Sql_subst_label.Add('ORDER BY');
  sl_Sql_subst_label.Add('	V.Salgspris,');
  sl_Sql_subst_label.Add('	V.Antal desc;');
//  C2LogAdd(sl_Sql_subst_label.Text);

  sl_Sql_lms32_label := TStringList.Create;
  sl_Sql_lms32_label.Add('declare pakn integer;');
  sl_Sql_lms32_label.Add('set pakn = (select paknnum from lagerkartotek where varenr=:varenr and lager=:lager) /100;');
  sl_Sql_lms32_label.Add('declare spris money;');
  sl_Sql_lms32_label.Add('set spris=(select salgspris from lagerkartotek  where varenr=:varenr and lager=:lager);');
  sl_Sql_lms32_label.Add('if pakn<>0 then');
  sl_Sql_lms32_label.Add('  set spris=spris/pakn;');
  sl_Sql_lms32_label.Add('end if;');
  sl_Sql_lms32_label.Add('');
  sl_Sql_lms32_label.Add('select');
  sl_Sql_lms32_label.Add('x.*');
  sl_Sql_lms32_label.Add('from');
  sl_Sql_lms32_label.Add('(');
  sl_Sql_lms32_label.Add('SELECT');
  sl_Sql_lms32_label.Add('	L.Lager,');
  sl_Sql_lms32_label.Add('	L.Varenr,');
  sl_Sql_lms32_label.Add('	L.Drugid,');
  sl_Sql_lms32_label.Add('  l.salgspris,');
  sl_Sql_lms32_label.Add('  l.paknnum,');
  sl_Sql_lms32_label.Add('	(case when l.paknnum= 0 then l.salgspris else l.salgspris / (paknnum /100) end) as pakpris');
  sl_Sql_lms32_label.Add('from');
  sl_Sql_lms32_label.Add('    LagerSubstListe as sub');
  sl_Sql_lms32_label.Add('inner join	LagerKartotek AS L on l.varenr=sub.subnr and l.lager=:lager');
  sl_Sql_lms32_label.Add('');
  sl_Sql_lms32_label.Add('WHERE');
  sl_Sql_lms32_label.Add('  sub.varenr=:varenr');
  sl_Sql_lms32_label.Add('	and L.Drugid=:Drugid');
  sl_Sql_lms32_label.Add('	and L.SletDato is null');
  sl_Sql_lms32_label.Add('	and L.AfmDato is null');
  sl_Sql_lms32_label.Add(') as x');
  sl_Sql_lms32_label.Add('where x.pakpris<spris');
  sl_Sql_lms32_label.Add('');
  sl_Sql_lms32_label.Add('ORDER BY VARENR;');
//  C2LogAdd(sl_Sql_lms32_label.Text);
end;

procedure TMainDm.C2Buttons;
begin
  with StamForm do
  begin
    if not Assigned(StamForm) then
      exit;
    try
      if (StamPages.ActivePage = KartotekPage) or (StamPages.ActivePage = TilskudsPage) then
      begin
        case dsKar.State of
          dsInsert:
            C2StatusBar.Panels.Items[1].Text := ' Opret';
          dsEdit:
            C2StatusBar.Panels.Items[1].Text := ' Ret';
        else
          C2StatusBar.Panels.Items[1].Text := ' Læsning';
        end;
        // Aktiver knapper
        C2ButF5.Enabled := True;
        C2ButF6.Enabled := True;
        C2ButF7.Enabled := True;
        C2ButF8.Enabled := True;
        C2ButEsc.Enabled := True;
        // Sæt knapper efter status
        C2ButF5.Enabled := dsKar.State in [dsEdit, dsInsert];
        C2ButF6.Enabled := not C2ButF5.Enabled;
        C2ButF7.Enabled := C2ButF6.Enabled;
        C2ButF8.Enabled := C2ButF6.Enabled;
        C2ButEsc.Enabled := C2ButF5.Enabled;
        exit;
      end;
      // Andre sider - disable knapper
      C2StatusBar.Panels.Items[1].Text := ' Læsning';
      C2ButF5.Enabled := False;
      C2ButF6.Enabled := False;
      C2ButF7.Enabled := False;
      C2ButF8.Enabled := False;
      C2ButEsc.Enabled := False;
    finally
//      AfterScroll(dsKar.DataSet);
    end;
    (* 2.2.1.7 *)
  end;
end;

procedure TMainDm.AfterScroll(DataSet: TDataSet);
begin
  with StamForm do
  begin
    if not Assigned(StamForm) then
      exit;
    edtCprNr.Text := ffPatKarKundeNr.AsString;
    if CallEnabled then
    begin
      if DataSet = ffPatKar then
      begin
        C2LogAdd('After scroll : ' + ffPatKarKundeNr.AsString);
        if DataSet.State <> dsInsert then
        begin
          EKundeNr.Text := ffPatKarKundeNr.AsString;
          edtCPRNr1.Text := ffPatKarKundeNr.AsString;
          edtCprNr.Text := ffPatKarKundeNr.AsString;
        end;
        if ffPatKarFiktivtCprNr.AsBoolean then
        begin
          ECtrLand.Color := clWindow;
          ECtrLand.ReadOnly := False;
          ECtrLand.TabStop := True;
          EDato.Color := clWindow;
          EDato.ReadOnly := False;
          EDato.TabStop := False;
        end
        else
        begin
          ECtrLand.Color := clSilver;
          ECtrLand.ReadOnly := True;
          ECtrLand.TabStop := False;
          EDato.Color := clSilver;
          EDato.ReadOnly := True;
          EDato.TabStop := False;
        end;
        EModtager.Color := clWindow;
        EModtager.Font.Color := clWindowText;
        if EBem.Lines.Count > 0 then
          EBem.Color := clYellow
        else
          EBem.Color := clWindow;

        lblCF5name.Caption := ffPatKarNavn.AsString;
        lblCF5name.Update;

        C2LogAdd('pat : ' + Curr2Str(ffPatKarCtrSaldo.AsCurrency));
        C2LogAdd('voksen : ' + Curr2Str(KronikerGrpVoksen));
        C2LogAdd('barn : ' + Curr2Str(KronikerGrpBarn));
        ECtrSaldo.Color := clLime;
        if ffPatKarCtrType.AsInteger = 0 then
          if ffPatKarCtrSaldo.AsCurrency > KronikerGrpVoksen then
            ECtrSaldo.Color := clYellow;
        if ffPatKarCtrType.AsInteger = 1 then
          if ffPatKarCtrSaldo.AsCurrency > KronikerGrpBarn then
            ECtrSaldo.Color := clYellow;

        // mark terminal patients with dosis blue
        ECtrStatus.Color := clLime;
        ECtrType.Color := clLime;
        if ffPatKarCtrType.AsInteger = 99 then
        begin
          ECtrStatus.Color := clAqua;
          ECtrType.Color := clAqua;
        end;

        lblMomsType.Visible := False;

        if ffPatKarDebitorNr.AsString <> '' then
        begin
          if ffDebKar.FindKey([ffPatKarDebitorNr.AsString]) then
          begin
            if ffDebKarMomsType.AsInteger = 0 then
              lblMomsType.Visible := True;
          end;
        end;



        // ctr b fields

        ECtrBSaldo.Color := clLime;
        ECtrBUdlign.Color := clLime;
        ECtrBUdDato.Color := clLime;
        if ffPatKarCtrSaldoB.AsCurrency <> 0 then
          ECtrBSaldo.Color := clWebOrange;
        if ffPatKarCTRUdlignB.AsCurrency <> 0 then
          ECtrBUdlign.Color := clWebOrange;
        if ffPatKarCtrUdDatoB.AsString <> '' then
          ECtrBUdDato.Color := clWebOrange;

      end;
    end;

    if Trim(ffPatKarKundeNr.AsString) = '' then
    begin
      C2StatusBar.Panels[2].Text := '';
      C2StatusBar.Panels[3].Text := '';
    end;

    // check for open edi for the patient
    fqOpenEDI.Close;
    fqOpenEDI.SQL.Text := sl_SQL_OpenEdi.Text;
    fqOpenEDI.ParamByName('CPRNr').AsString :=
      Trim(copy(ffPatKarKundeNr.AsString, 1, 10));
    fqOpenEDI.Open;

    if fqOpenEDI.RecordCount > 0 then
    begin
      fqOpenEDI.Last;
      C2StatusBar.Panels[2].Text := 'Ikke takseret receptkvitt. ' +
        fqOpenEDI.FieldByName('dato').AsString + '  ' + fqOpenEDI.FieldByName
        ('ReceptId').AsString;

    end
    else
      C2StatusBar.Panels[2].Text := '';

    if ffPatKarKundeType.AsInteger <> 1 then
      exit;

    fqOpenEDI.Close;
    fqOpenEDI.SQL.Clear;
    fqOpenEDI.SQL.Add('SELECT	top 1');
    fqOpenEDI.SQL.Add('	Kundenr');
    fqOpenEDI.SQL.Add('	,takserdato as dato');
    fqOpenEDI.SQL.Add('	,lbnr');
    fqOpenEDI.SQL.Add
      ('	,case when brugerkontrol=0 then ''*'' else '''' end as kontrol');
    fqOpenEDI.SQL.Add('FROM');
    fqOpenEDI.SQL.Add('        Ekspeditioner');
    fqOpenEDI.SQL.Add('WHERE');
    fqOpenEDI.SQL.Add('	ordrestatus=1');
    fqOpenEDI.SQL.Add('	and Kundenr=:CPRNr');
    fqOpenEDI.SQL.Add('order by');
    fqOpenEDI.SQL.Add('	takserdato desc');
    fqOpenEDI.ParamByName('CPRNr').AsString := Trim(ffPatKarKundeNr.AsString);
    fqOpenEDI.Prepare;
    fqOpenEDI.Open;
    try
      if fqOpenEDI.RecordCount = 0 then
      begin
        if pos('CTR', C2StatusBar.Panels[3].Text) = 0 then
          if pos('Kø', C2StatusBar.Panels[3].Text) = 0 then
            C2StatusBar.Panels[3].Text := '';
        exit;
      end;
      if C2StatusBar.Panels[2].Text <> '' then
      begin
        C2StatusBar.Panels[3].Text := 'Åben ekspedition ' +
          fqOpenEDI.FieldByName('dato').AsString + ' ' +
          fqOpenEDI.FieldByName('lbnr').AsString + ' ' +
          fqOpenEDI.FieldByName('kontrol').AsString;
        exit;
      end;
      C2StatusBar.Panels[2].Text := 'Åben ekspedition ' +
        fqOpenEDI.FieldByName('dato').AsString + ' ' +
        fqOpenEDI.FieldByName('lbnr').AsString + ' ' +
        fqOpenEDI.FieldByName('kontrol').AsString;
      if pos('CTR', C2StatusBar.Panels[3].Text) = 0 then
        if pos('Kø', C2StatusBar.Panels[3].Text) = 0 then
          C2StatusBar.Panels[3].Text := '';
    finally
      fqOpenEDI.Close;
    end;

  end;
end;

procedure TMainDm.dsStateChange(Sender: TObject);
begin
  with StamForm do
  begin
    if not Assigned(StamForm) then
      exit;
    try
      if not(Sender is TDataSource) then
        exit;
      dsKar.DataSet := (Sender as TDataSource).DataSet;
      if dsKar.DataSet = ffPatTil then
      begin
        if dsKar.State in [dsInsert, dsEdit] then
        begin
          if Trim(ffPatKarKundeNr.AsString) <> '' then
          begin
            if dsKar.State = dsInsert then
            begin
              ffPatTilKundeNr.AsString := ffPatKarKundeNr.AsString;
              ffPatTilChkJournalNr.AsBoolean := False;
              ffPatTilEgenbetaling.AsCurrency := 0;
              ffPatTilAkkBetaling.AsCurrency := 0;
              ffPatTilBetalType.AsInteger := 0;
              ffPatTilTilskMetode.AsInteger := 1;
            end;
            if ffPatKarKommune.AsInteger = 101 then
              ffPatTilChkJournalNr.AsBoolean := True;
          end
          else
          begin
            dsKar.DataSet.Cancel;
            ChkBoxOK('Find kunde frem før rettelse !');
          end;
        end;
      end;
      if dsKar.DataSet = ffPatKar then
      begin
        case dsKar.State of
          dsInsert:
            begin
              // OpdaterEksW ('CtrType', 1);
              ffPatKarKundeType.Value := 1;
              ffPatKarCprCheck.AsBoolean := True;
              ffPatKarFiktivtCprNr.AsBoolean := False;
              ffPatKarBarn.AsBoolean := False;
              ffPatKarNettoPriser.AsBoolean := False;
              ffPatKarEjSubstitution.AsBoolean := False;
              ffPatKarEjCtrReg.AsBoolean := False;
              ffPatKarDKMedlem.Value := 9;
              EKundeNr.Text := '';
              EKundeNr.ReadOnly := False;
              EKundeNr.Color := clWindow;
            end;
          dsEdit:
            begin
              EKundeNr.ReadOnly := True;
              EKundeNr.Color := clSilver;
            end;
        else
          EKundeNr.ReadOnly := False;
          EKundeNr.Color := clWindow;
        end;
      end;
    finally
      C2Buttons;
    end;
  end;
end;

procedure TMainDm.cdDyrArtFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  if DyreAnvFilter = 0 then
    Accept := True
  else
    Accept := cdDyrArtAnvendelse.Value = DyreAnvFilter;
end;

procedure TMainDm.cdDyrAldFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := cdDyrAldGruppe.Value = cdDyrArtAlder.Value;
end;

procedure TMainDm.cdDyrOrdFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := cdDyrOrdGruppe.Value = cdDyrArtOrdGrp.Value;
end;

procedure TMainDm.DKMedlemGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := DKMedlem2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.DKMedlemSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := DKMedlem2Int(Text);
end;

procedure TMainDm.TilskMetodeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := TilskType2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.TilskMetodeSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := TilskType2Int(Text);
end;

procedure TMainDm.timChkCertTimer(Sender: TObject);
begin
  timChkCert.Enabled := False;
  try
    BrugerCertificateValid :=  Bruger.BrugerNr <> 0;
    if not BrugerCertificateValid then
        exit;

    BrugerCertificateValid := Bruger.HasUserCertificate;
    if not BrugerCertificateValid then
        exit;
    BrugerCertificateValid := Bruger.SOSIIdIsValid;
    if not BrugerCertificateValid then
        exit;
    BrugerCertificateValid := Bruger.HasValidSOSIIdOnServer;

  finally
    timChkCert.Enabled := True;
  end;
end;

function TMainDm.UdligningEkspedition(ALbnr: integer): boolean;
begin
  Result := False;
  try
    with maindm.nxdb.OpenQuery('select subvarenr from ekspliniersalg where lbnr= :ilbnr and varenr=''100015''',[ALbnr]) do
    begin
      try
        Result := not eof;

      finally
        Free;
      end;
    end;
  except
    on E: Exception do
      C2LogAdd('fejl i UdligningEkspedition ' + e.Message);
  end;

end;

procedure TMainDm.CtrTypeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := CtrPatType2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.CtrTypeSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := CtrPatType2Int(Text);
end;

procedure TMainDm.JaNejGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := JaNej2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.JaNejSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := JaNej2Int(Text);
end;

procedure TMainDm.DKOpdGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := DKOpd2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.DKOpdSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := DKOpd2Int(Text);
end;

function TMainDm.CheckFMKCertificate: boolean;
begin
  // does the user still have a certificate before we call fmk routines
  Result := False;
  if not CurrentLogonIsValid(Bruger, Afdeling, ltAllRequired) then
  begin
    Application.Terminate;
    exit;
  end
  else
  begin
    C2LogAdd('Certificate is valid  until ' + FormatDateTime('dd.mm.yyyy hh:nn:ss', Bruger.SOSIId.ValidTo));

    // will the certificate expire within 30 minutes or is test enabled

    if Bruger.SOSIId.ExpiresWithin(FMKCertificateExpiredSeconds) then
    begin
      C2LogAdd('SOSIId will expire within 30 minutes');
      TFormC2Logon.ConsiderSosiIdInvalidWhenExpiresWithin := FMKCertificateExpiredSeconds;
      if PromptForLogon(Bruger, Afdeling, ltAllRequiredKodeCleared) then
      begin
        Bruger.SyncSosiIdFromServer(Afdeling);
        C2LogAdd('Certificate is refreshed and is now valid until ' + FormatDateTime('dd.mm.yyyy hh:nn:ss',
          Bruger.SOSIId.ValidTo));
      end
      else
      begin
        C2LogAdd('User did not login');
        Application.Terminate;
        exit;
      end;

    end;

  end;
  C2Env.Log.BrugerNr := Bruger.BrugerNr;
  Result := True;
end;

function TMainDm.CreatePatientkartotekRecordFromRS_Ekspeditioner(AReceptid: integer): Boolean;
var
  LPersonId: string;
  LPersonIdSource: TFMKPersonIdentifierSource;
  LSaveIndex: string;
  itst: integer;
  LSenderId: string;
  LSenderType: string;
  LLeveringsInfo: string;
  LAsylnSoeger: Boolean;
  LAsylnKundenr: string;
  LCtrCountryCode: integer;
  LLmsModtagerId: string;
  LQry: TnxQuery;
begin
  Result := False;
  try

    LQry := nxdb.OpenQuery('select ' + fnRS_EkspeditionerReceptId + fnRS_EkspeditionerPatPersonIdentifier_K +
      fnRS_EkspeditionerPatPersonIdentifierSource_K + fnRS_EkspeditionerPatEftNavn_K + fnRS_EkspeditionerPatForNavn_K +
      fnRS_EkspeditionerPatVej_K + fnRS_EkspeditionerPatPostNr_K + fnRS_EkspeditionerPatAmt_K + fnRS_EkspeditionerSenderId_K +
      fnRS_EkspeditionerIssuerAutNr_K + fnRS_EkspeditionerIssuerCPRNr_K + fnRS_EkspeditionerSenderType_K +
      fnRS_EkspeditionerIssuerTitel_K + fnRS_EkspeditionerLeveringsInfo_K + ' from ' + tnRS_Ekspeditioner + ' where ' +
      fnRS_EkspeditionerReceptId_P, [AReceptid]);
    try
      if not LQry.Eof then
      begin
        LPersonId := LQry.FieldByName(fnRS_EkspeditionerPatPersonIdentifier).AsString;
        LPersonIdSource := TFMKPersonIdentifierSource.parse(LQry.FieldByName(fnRS_EkspeditionerPatPersonIdentifierSource).AsInteger,
          pisUndefined);
        LLeveringsInfo := LQry.FieldByName(fnRS_EkspeditionerLeveringsInfo).AsString;

        case LPersonIdSource of
          pisUndefined:
            exit;
        end;

        LAsylnSoeger := False;
        if pos('PERSONID:', caps(LLeveringsInfo)) <> 0 then
        begin
          if GetAsylnCpr(LLeveringsInfo, LAsylnKundenr) then
          begin
            C2LogAdd('Asylnkundenr is ' + LAsylnKundenr);
            LAsylnSoeger := True;
          end;
        end;

        LSaveIndex := SaveAndAdjustIndexName(ffPatUpd,'NrOrden');
        try
					// if the patient pointed at by PatPersonIdentifier does not exist then
					// create a new record
          if LAsylnSoeger then
          begin
            if ffPatUpd.FindKey([LAsylnKundenr]) then
            begin
              C2LogAdd('Patient already exists : ' + LAsylnKundenr);
              exit;
            end;

          end
          else
          begin

            if ffPatUpd.FindKey([LPersonId]) then
            begin
              C2LogAdd('Patient already exists : ' + LPersonId);
              exit;
            end;
          end;

          if (LPersonIdSource = pisXeCPR) and (not LAsylnSoeger) then
          begin

//            LAsylnSoeger := ChkBoxYesNo('Er denne person asylansøger?' + #13#13 +
//              'Hvis Nej, så oprettes automatisk et fiktivt CPR-nr. til brug for statistik og CTR for ' + LPersonId, False);

						// Don't request a CtrFiktivId if it's an asylumn seeker. Thats set to a fixed value later in this method
            if not LAsylnSoeger then
            begin
							// Prompt for the Country code
              if IsCTR2Enabled then
              begin
                if not maindm.Bruger.HasValidSosiIdOnServer then
                begin
                  // message about user not being logged in
                  TaskMessageDlg('Bemærk',PWideChar('CTR2 : Bruger skal være logget ind med MitID'),TMsgDlgType.mtInformation,
                    [TMsgDlgBtn.mbOK],0);
                  Exit;
                end;
                TFormC2CtrCountryList.ShowDialog(cdCtrLanISo, LCtrCountryCode);
                if not CTR2GetFiktivId(LCtrCountryCode, LLmsModtagerId) then
                  ChkBoxOK('Der kunne ikke tildeles et Lms-ID til denne kunde');

              end
              else
              begin
                TFormC2CtrCountryList.ShowDialog(cdCtrLan, LCtrCountryCode);
                if not GetCtrFiktivId(LCtrCountryCode, LLmsModtagerId) then
                  ChkBoxOK('Der kunne ikke tildeles et Lms-ID til denne kunde');
              end;
            end;
          end;

          ffPatUpd.Append;
          ffPatUpdKundeNr.AsString := LPersonId;
          case LPersonIdSource of
            pisCPR:
              ffPatUpdKundeType.AsInteger := 1;
            pisSORPerson:
              begin
                ffPatUpdKundeType.AsInteger := 17;
                ffPatUpdLmsModtager.AsString := '4600000000';
              end;
            pisXeCPR:
              ffPatUpdKundeType.AsInteger := 1;
          end;

					// asylansøger

          if LAsylnSoeger then
          begin
            ffPatUpdLmsModtager.AsString := '4000005555';
            ffPatUpdCprCheck.AsBoolean := False;
            ffPatUpdEjCtrReg.AsBoolean := True;
            ffPatUpdKundeType.AsInteger := 1;
            if LPersonIdSource <> pisXeCPR then
              ffPatUpdKundeNr.AsString := LAsylnKundenr;

          end;

          if LCtrCountryCode > 0 then
            ffPatUpdLandekode.Value := LCtrCountryCode;
          if (LPersonIdSource = pisXeCPR) then
          begin
            ffPatUpdFiktivtCprNr.AsBoolean := False;
            ffPatUpdCprCheck.AsBoolean := False;
          end
          else
          begin
            ffPatUpdCprCheck.AsBoolean := True;
            ffPatUpdFiktivtCprNr.AsBoolean := False;
          end;
          ffPatUpdBarn.AsBoolean := False;
          ffPatUpdNettoPriser.AsBoolean := False;
          ffPatUpdEjSubstitution.AsBoolean := False;
          ffPatUpdEjCtrReg.AsBoolean := False;
          if GemNyeRsFornavnEfternavn then
          begin
            if LQry.FieldByName(fnRS_EkspeditionerPatForNavn).AsString <> '' then
              ffPatUpdNavn.AsString := LQry.FieldByName(fnRS_EkspeditionerPatForNavn).AsString + ' ' + LQry.FieldByName(fnRS_EkspeditionerPatEftNavn).AsString
          end
          else
          begin
            ffPatUpdNavn.AsString := LQry.FieldByName(fnRS_EkspeditionerPatEftNavn).AsString;
            if LQry.FieldByName(fnRS_EkspeditionerPatForNavn).AsString <> '' then
              ffPatUpdNavn.AsString := ffPatUpdNavn.AsString + ',' + LQry.FieldByName(fnRS_EkspeditionerPatForNavn).AsString;
          end;
          ffPatUpdAdr1.AsString := LQry.FieldByName(fnRS_EkspeditionerPatVej).AsString;
          ffPatUpdAdr2.AsString := '';
          ffPatUpdPostNr.AsString := LQry.FieldByName(fnRS_EkspeditionerPatPostNr).AsString;
          ffPatUpdTlfNr.AsString := '';
          try
            itst := StrToIntDef(LQry.FieldByName(fnRS_EkspeditionerPatAmt).AsString, -1);
            if itst = -1 then
              ffPatUpdAmt.AsInteger := Amt2Region(StrToInt(ffRcpOplAfrAmt.AsString))
            else
              ffPatUpdAmt.AsInteger := Amt2Region(itst);
          except
            ffPatKarAmt.AsInteger := 0;
          end;
          if LQry.FieldByName(fnRS_EkspeditionerIssuerCPRNr).AsString <> '' then
            ffPatUpdYderCprNr.AsString := LQry.FieldByName(fnRS_EkspeditionerIssuerCPRNr).AsString
          else
            ffPatUpdYderCprNr.AsString := LQry.FieldByName(fnRS_EkspeditionerIssuerAutNr).AsString;
          LSenderId := LQry.FieldByName(fnRS_EkspeditionerSenderId).AsString.PadLeft(7, '0');
          LSenderType := LQry.FieldByName(fnRS_EkspeditionerSenderType).AsString;
          if LSenderType = 'lokationsnummer' then
            ffPatUpdYderNr.AsString := 'F' + ffPatUpdYderCprNr.AsString.PadLeft(6, '0')
          else if LSenderType = 'SOR' then
            ffPatUpdYderNr.AsString := ''
          else
            ffPatUpdYderNr.AsString := LSenderId;
          ffPatUpdOpretDato.AsDateTime := Now;
          ffPatUpd.Post;

					// now we have saved the patient
          if LPersonIdSource = pisSORPerson then
            ShowMessageBoxWithLogging('SOR kunde er oprettet og klar til brug fra C2 dosisprogram');

          Result := True;


					// reset current patient to the one just created

          ffPatKar.FindKey([ffPatUpdKundeNr.AsString])
        finally
          AdjustIndexName(ffpatupd, LSaveIndex);
        end;
      end;

    finally
      LQry.Free;
    end;
  except
    on E: Exception do
      ChkBoxOK('Fejl in CreatePatientkartotekRecordFromRS_Ekspeditioner' + sLineBreak + E.Message);
  end;

end;

function TMainDm.CountHandkoebLines(aLbnr: integer): integer;
begin
  Result :=0;
  with nxdb.OpenQuery('select count(lbnr) as hkcnt from ekspliniersalg where lbnr=:ilbnr' +
                ' and linietype=2',[aLbnr]) do
  begin
    if RecordCount <> 0 then
    begin
      First;
      Result := FieldByName('hkcnt').AsInteger;
    end;


    Free;

  end;
end;

procedure TMainDm.CtrPemGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := CtrPem2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.CtrPemSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := CtrPem2Int(Text);
end;

procedure TMainDm.EgenBetTypeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := EgenBetType2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.EgenBetTypeSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := EgenBetType2Int(Text);
end;

procedure TMainDm.KundeTypeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := KundeType2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.KundeTypeSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := KundeType2Int(Text);
end;

procedure TMainDm.OrdreTypeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := OrdreType2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.OrdreTypeSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := OrdreType2Int(Text);
end;

procedure TMainDm.SetBrugerNr(const Value: integer);
begin
end;

procedure TMainDm.OrdreStatusGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := OrdreStatus2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.OrdreStatusSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := OrdreStatus2Int(Text);
end;

procedure TMainDm.EkspTypeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := EkspType2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.EkspTypeSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := EkspType2Int(Text);
end;

procedure TMainDm.EkspFormGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := EkspForm2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.EkspFormSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := EkspForm2Int(Text);
end;

procedure TMainDm.LinieTypeGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := LinieType2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.LinieTypeSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := LinieType2Int(Text);
end;

procedure TMainDm.ffCliConnectionLost(aSource: TObject; aStarting: Boolean; var aRetry: Boolean);
begin
  StamForm.ffConnLost := not aRetry;
  aRetry := True;
end;

procedure TMainDm.LevFormGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := LevForm2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.LevFormSetText(Sender: TField; const Text: String);
begin
  (Sender as TField).AsInteger := LevForm2Int(Text);
end;

procedure TMainDm.fqEksOvrAfterScroll(DataSet: TDataSet);
var
  oldindex: string;
begin

  try
    oldindex := ffEksOvr.IndexName;
    try
      ffEksOvr.IndexName := 'NrOrden';
      ffEksOvr.FindKey([fqEksOvrLbnr.AsInteger]);
    except

    end;
  finally
    ffEksOvr.IndexName := oldindex;
  end;

  if not nxEkspLinKon.Active then
    exit;

  with StamForm.butKontrol.Font do
  begin
    Color := clWindowText;
    Style := [];
  end;

  if StamForm.StamPages.ActivePage <> StamForm.EkspPage then
    exit;

  oldindex := nxEkspLinKon.IndexName;
  nxEkspLinKon.IndexName := 'NrOrden';
  nxEkspLinKon.SetRange([fqEksOvrLbnr.AsInteger], [fqEksOvrLbnr.AsInteger]);
  try
    if nxEkspLin.RecordCount = 0 then
      exit;
    nxEkspLinKon.First;
    while not nxEkspLinKon.Eof do
    begin
      if not nxEkspLinKonBemaerk.IsNull then
      begin
        with StamForm.butKontrol.Font do
        begin
          Color := clRed;
          Style := [fsBold];
        end;
        exit;
      end;

      nxEkspLinKon.Next;
    end;

  finally
    nxEkspLinKon.CancelRange;
    nxEkspLinKon.IndexName := oldindex;
  end;

end;

procedure TMainDm.ffPatKarLuPbsGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := BetFormPbs2Str((Sender as TField).AsInteger);
end;

function TMainDm.FindLevnr(ALbnr: Integer): Boolean;
var
  save_index: string;
begin
  Result := False;
  save_index := nxEkspLevListe.IndexName;
  nxEkspLevListe.IndexName := 'LbNrOrden';
  try
    if nxEkspLevListe.FindKey([ALbnr]) then
      Result := True;
  finally
    nxEkspLevListe.IndexName := save_index;
  end;

end;

function TMainDm.FMKCertificateExpiredSeconds: integer;
var
  LInifile: TMemIniFile;
begin
  Result := 1800;
  try
    LInifile := TMemIniFile.Create('winpacer.ini');
    try
      Result := LInifile.ReadInteger('Receptur', 'TestFMKCertificateExpired', 1800);
    finally
      LInifile.Free;
    end;

  except
    on e: exception do
      C2LogAdd('Fejl in TestFMKCertificateExpired : ' + e.Message);
  end;


end;

procedure TMainDm.mtEksOldLuPbsGetText(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  Text := BetFormPbs2Str((Sender as TField).AsInteger);
end;

procedure TMainDm.mtLinBeforePost(DataSet: TDataSet);
begin
  if not mtLinValideret.AsBoolean then
  begin
    ChkBoxOK('Der er sket en fejl i ekspeditionen. Luk og start forfra.');
    C2LogAdd(' *** Der er sket en fejl i ekspeditionen. Luk og start forfra. ***');
  end;
end;

function TMainDm.NulPakkelistEkspedition(Albnr: integer): boolean;
begin

  Result := False;
  try

    with MainDm.nxdb.OpenQuery
      ('select lbnr from ekspliniersalg where lbnr= :ilbnr', [aLbnr]) do
    begin
      try
        Result := Eof;
      finally
        Free;
      end;
    end;
  except
    on e: exception do
      C2LogAdd('Fejl i NulPakkelistEkspedition ' + e.Message);
  end;

end;

procedure TMainDm.nxOrdFilterRecord(DataSet: TDataSet; var Accept: Boolean);
var
  mm, dd, yy: integer;
  testdate: TDate;
begin
  with StamForm do
  begin
    Accept := True;
    if edtCPR.Text <> '' then
      Accept := Accept and (Trim(nxOrdKundeCPR.AsString) = Trim(edtCPR.Text));
    if chkAabenEordre.Checked then
      Accept := Accept and (nxOrdPrintStatus.AsInteger in [0, 1]);
    if not TryStrToInt(copy(nxOrdOrdredato.AsString, 1, 4), yy) then
      exit;
    if not TryStrToInt(copy(nxOrdOrdredato.AsString, 6, 2), mm) then
      exit;
    if not TryStrToInt(copy(nxOrdOrdredato.AsString, 9, 2), dd) then
      exit;
    testdate := EncodeDate(yy, mm, dd);
    Accept := Accept and (testdate >= dtpEhstart.Date);
    Accept := Accept and (testdate <= dtpEhSlut.Date);

  end;
end;

procedure TMainDm.nxRSEkspListFilterRecord(DataSet: TDataSet; var Accept: Boolean);
var
  save_index: string;
  dosstartdate: string;
begin
  with StamForm do
  begin
    try
      Accept := True;
      if StamForm.cboVisDosis.ItemIndex <= 0 then
        exit;
      if StamForm.cboVisDosis.ItemIndex = 1 then
      begin
        Accept := nxRSEkspListPatCPR.AsString.IsEmpty;
        exit;
      end;
      Accept := False;
      save_index := nxRSEkspLin.IndexName;
      nxRSEkspLin.IndexName := 'ReceptIdOrder';
      try
        dosstartdate := '';
        if not nxRSEkspLin.FindKey([nxRSEkspListReceptId.AsInteger]) then
          exit;
        dosstartdate := nxRSEkspLinDosStartDato.AsString;

      finally
        if nxRSEkspLin.IndexName <> save_index then
          nxRSEkspLin.IndexName := save_index;

      end;

      case StamForm.cboVisDosis.ItemIndex of
        3:
          Accept := dosstartdate <> '';
        2, 4:
          Accept := dosstartdate = '';
      end;
      if not Accept then
        exit;

    except
      on e: exception do
        C2LogAdd(e.Message)
    end;

  end;

end;

procedure TMainDm.ffCtrOpdCalcFields(DataSet: TDataSet);
var
  istat: integer;
begin
  ffCtrOpdMessage.AsString := '';

  istat := ffCtrOpdStatus.AsInteger;
  if istat = 2 then
    ffCtrOpdMessage.AsString := 'Der er ikke forbindelse til CTR - Afvent';
  if (istat > 300) and (istat < 399) then
    ffCtrOpdMessage.AsString := ctrmsgcodes0300[istat];
  if (istat > 9900) and (istat < 9999) then
    ffCtrOpdMessage.AsString := ctrmsgcodes9900[istat];

end;

procedure TMainDm.ffdchKortStatusGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := 'Aktiv';
  if nxDCH.FieldByName('Parked').AsBoolean then
    Text := 'Parkeret';
  if nxDCH.FieldByName('EndDate').AsDateTime < Now then
    Text := 'Udløbet';
  if not nxDCH.FieldByName('DeleteDate').IsNull then
    Text := 'Slettet';

end;

procedure TMainDm.ffDebKarBeforePost(DataSet: TDataSet);
begin
  DataSet['RemoteStatus'] := 0;
end;

procedure TMainDm.ffEksOvrAfterScroll(DataSet: TDataSet);
var
  oldindex: string;
begin
  if not nxEkspLinKon.Active then
    exit;
  with StamForm.butKontrol.Font do
  begin
    Color := clWindowText;
    Style := [];
  end;
  if StamForm.StamPages.ActivePage <> StamForm.EkspPage then
    exit;

  oldindex := nxEkspLinKon.IndexName;
  nxEkspLinKon.IndexName := 'NrOrden';
  nxEkspLinKon.SetRange([ffEksOvrLbNr.AsInteger], [ffEksOvrLbNr.AsInteger]);
  try
    if nxEkspLin.RecordCount = 0 then
      exit;
    nxEkspLinKon.First;
    while not nxEkspLinKon.Eof do
    begin
      if not nxEkspLinKonBemaerk.IsNull then
      begin
        with StamForm.butKontrol.Font do
        begin
          Color := clRed;
          Style := [fsBold];
        end;
        exit;
      end;

      nxEkspLinKon.Next;
    end;

  finally
    nxEkspLinKon.CancelRange;
    nxEkspLinKon.IndexName := oldindex;
  end;
end;

procedure TMainDm.ffEksOvrCalcFields(DataSet: TDataSet);
begin
  try
    if not nxEkspBon.Active then
      exit;
    if nxEkspBon.FindKey([ffEksOvrLbNr.AsInteger]) then
      ffEksOvrBonnr.AsLargeInt := nxEkspBonBonNr.AsLargeInt;
  except
  end;
end;

procedure TMainDm.ffLagKarAfterScroll(DataSet: TDataSet);
begin
  C2LogAdd('scroll fflagkar ' + ffLagKarVareNr.AsString);
end;

procedure TMainDm.ffLinOvrAfterScroll(DataSet: TDataSet);
begin
  if not ffTilOvr.Active then
    exit;

  try

    ffTilOvr.FindKey([ffLinOvrLbNr.AsInteger, ffLinOvrLinieNr.AsInteger]);
  except

  end;
end;

procedure TMainDm.fqEksOvrCalcFields(DataSet: TDataSet);
begin
  try
    if nxEkspBon.FindKey([fqEksOvrLbnr.AsInteger]) then
      fqEksOvrBonnr.AsLargeInt := nxEkspBonBonNr.AsLargeInt;
  except
  end;

end;

function TMainDm.GetBrugerNr: integer;
begin
  Result := Bruger.BrugerNr;

end;

function TMainDm.GetCtrFiktivId(ALandekode: Integer; out ACtrFiktivId: string): Boolean;
var
  LCtrRec: TCtrFiktiv;
begin
  C2LogAdd('TMainDm.GetCtrFiktivId - begin');
  ACtrFiktivId := '';

  try
    FillChar(LCtrRec, SizeOf(LCtrRec), 0);
    LCtrRec.TimeOut := 20000;
    LCtrRec.Land := ALandekode.ToString;
    BusyMouseBegin;
    try
      if MidClient.CtrAdresse <> '' then
        MidClient.RecvCtrFiktiv(LCtrRec)
      else
      begin
        C2LogAdd('MidClient.CtrAdresse er ikke angivet. Bruger skal indtaste fiktivt CPR-nr.');
        TastTekst('Indtast fiktivt cpr nr.', LCtrRec.CprNr);
        LCtrRec.Status := 0;
      end;
    finally
      BusyMouseEnd;
    end;

    C2LogAdd('Status=' + LCtrRec.Status.ToString + '. CprNr=' + LCtrRec.CprNr);

    Result := LCtrRec.Status = 0;

    if Result then
      ACtrFiktivId := LCtrRec.CprNr
    else
      ChkBoxOK('Fiktivt cprnr ikke tildelt (mulig CTR fejl) !');
  except
    on E: Exception do
    begin
      Result := False;
      C2LogAdd('Exception: "' + E.Message + '"');
    end;
  end;

  C2LogAdd('TMainDm.GetCtrFiktivId - end');

end;


function TMainDm.CTR2GetFiktivId(ALandekode: integer; out ACtrFiktivId: string): Boolean;
var
  LCli : TServerMethods1Client;
  Lresponse: string;
  LErrorCode: Integer;
  LErrorstring: string;
  LCreateFictitiousPersonIdentifierResponse : TCreateFictitiousPersonIdentifierResponse;
  LLogString : string;
  idd,imm,iyy : integer;
  LCurrentYear : integer;
  Save_Index : string;
  ISOCountryCode : string;
  LBirthdate : string;
  LFault : tfault;
  LDetails : tfault.Details;
const
  SBadDate = 'Fejl i fødselsdato';
begin
  ACtrFiktivId := '';
  Result := False;
  Save_Index := cdCtrLanISo.IndexName;
  cdCtrLanISo.IndexName := 'NrOrden';
  try
    if not cdCtrLanISo.FindKey([ALandekode]) then
      Exit;

  finally
    cdCtrLanISo.IndexName := Save_Index;
  end;

  ISOCountryCode := cdCtrLanISoISOKode.AsString;

  // need to make birthdate to format dd-mm-yyyy for call to fiktivcpr. in the database we store it as ddmmyyyy
  try

    if ffPatKarFoedDato.asstring.IsEmpty then
      raise exception.Create(SBadDate);

    if not TryStrToInt(copy(ffPatKarFoedDato.asstring, 1, 2), idd) then
      raise exception.Create(SBadDate);
    if not TryStrToInt(copy(ffPatKarFoedDato.asstring, 3, 2), imm) then
      raise exception.Create(SBadDate);

    case ffPatKarFoedDato.asstring.trim.Length of
      8:
        if not TryStrToInt(copy(ffPatKarFoedDato.asstring, 5, 4), iyy) then
          raise exception.Create(SBadDate);
      6:
        begin
          if not TryStrToInt(copy(ffPatKarFoedDato.asstring, 5, 2), iyy) then
            raise exception.Create(SBadDate);
          LCurrentYear := YearInDate(Now) - 2000;
          if iyy <= LCurrentYear then
            iyy := iyy + 2000
          else
            iyy := iyy + 1900;

        end;
    end;
  except
    on E: Exception do
    begin
      ChkBoxOK(e.Message);
      exit(False);
    end;
  end;

  LBirthdate := format('%4.4d-%2.2d-%2.2d',[iyy,imm,idd]);

  SQLConnection1.Params.Values['Hostname'] := C2Env.C2ServerAddress;

  SQLConnection1.Open;
  LCli := TServerMethods1Client.Create(SQLConnection1.DBXConnection);
  try
    LCli.CreateFiktivCPR(Fafdnr,BrugerNr,ISOCountryCode,LBirthDate,Lresponse,LErrorCode,LErrorstring,LLogString);
    C2LogAdd(LLogString);
    C2LogAddF('Errorcode %d Lresponse %s',[LErrorCode,Lresponse]);
    if LErrorCode <>  tstatuscode.OK then
    begin
      // LResponse is a fault class
      LFault := TFault.ParseXml(Lresponse);
      try
        C2LogAddF('Fault : %s %s',[LFault.FaultCode, LFault.FaultString]);
        for LDetails in lfault.Details do
        begin
            C2LogAddF('Details %s - %s',[LDetails.Key, LDetails.Value]);
        end;


      finally
        LFault.Free;
      end;
      Exit;
    end;

    LCreateFictitiousPersonIdentifierResponse := TCreateFictitiousPersonIdentifierResponse.Create;
    try
      LCreateFictitiousPersonIdentifierResponse.LoadFromXML(Lresponse);
      ACtrFiktivId := LCreateFictitiousPersonIdentifierResponse.PersonIdentifier;
    finally
      LCreateFictitiousPersonIdentifierResponse.Free;
    end;
    Result := not ACtrFiktivId.IsEmpty;
  finally

    LCli.Free;
    SQLConnection1.Close;
  end;



end;


function TMainDm.GetLargestPackByDrugID(ADatabase: TnxDatabase; ADrugID: Int64; out AVarenr: string;
  ALagernr: Integer): Boolean;
var
  LQuery: TnxQuery;
begin
  C2LogAdd('GetLargestPackByDrugID - begin');
  C2LogAdd('  Søger efter største pakning af DrugID=' + ADrugID.ToString);

  LQuery := nil;
  AVarenr := '';

  try
    // Get the Vare on lager 0 with a specific DrugID ordered by PaknNum with the largest first
    LQuery := ADatabase.OpenQuery('#T 30000' +
      ' select top 1 ' + fnLagerKartotekVareNr + ' from ' + tnLagerKartotek +
      ' where ' + fnLagerKartotekLager_P +
      ' and ' + fnLagerKartotekDrugId_P +
      ' and ' + fnLagerKartotekAfmDato + ' is null' +
      ' order by ' + fnLagerKartotekPaknNum + ' desc',
      [ALagernr, ADrugID.ToString]);

    Result := not LQuery.Eof;

    if Result then
      AVarenr := LQuery.FieldByName(fnLagerKartotekVareNr).AsString;
  except
    on E: Exception do
    begin
      Result := False;
      C2LogAdd('Exception: "' + E.Message + '"');
    end;
  end;

  LQuery.Free;

  if Result then
    C2LogAdd('  Valgte Varenr=' + AVarenr)
  else
    C2LogAdd('  Ingen fundet');

  C2LogAdd('GetLargestPackByDrugID - end');

end;

function TMainDm.GetVareUdlevType(ADatabase: TnxDatabase; AVarenr: string; out AUdlevType: string;
  ALagernr: Integer): Boolean;
var
  LQuery: TnxQuery;
begin
  C2LogAdd('GetVareUdlevType (' + AVarenr + ') - begin');

  LQuery := nil;
  AUdlevType := '';

  try
    // Get the Vare on lager 0 with a specific DrugID ordered by PaknNum with the largest first
    LQuery := ADatabase.OpenQuery('#T 30000' +
      ' select ' + fnLagerKartotekUdlevType + ' from ' + tnLagerKartotek +
      ' where ' + fnLagerKartotekLager_P +
      ' and ' + fnLagerKartotekVarenr_P,
      [ALagernr, AVarenr]);

    Result := not LQuery.Eof;

    if Result then
      AUdlevType := LQuery.FieldByName(fnLagerKartotekUdlevType).AsString.ToUpper;
  except
    on E: Exception do
    begin
      Result := False;
      C2LogAdd('Exception: "' + E.Message + '"');
    end;
  end;

  LQuery.Free;

  if Result then
    C2LogAdd('  UdlevType=' + AUdlevType)
  else
    C2LogAdd('  Ikke fundet');

  C2LogAdd('GetVareUdlevType (' + AVarenr + ') - end');

end;

function TMainDm.IsCTR2Enabled: Boolean;
var
  LParam : TC2EnvironmentParam;
begin
//  Exit(False);
  Lparam := C2Env.GetAktivIndstilling('Enabled','CTR2',False);

  if LParam = Nil then
    Exit(False);

  Result := SameText(LParam.AsString,'Ja');


end;

function TMainDm.OpdaterZeroBonLevlist(ALbnrList: TList<integer>): Word;
var
  Err: Word;
  servertime : TDateTime;
  save_index : string;
  VarerSent: Integer;
  VarerNotSent: Integer;
  Restxt: string;
  lbnr : integer;
  Bonnr : integer;
  KasseNr : integer;
  procedure tr_EditKasseOplysninger;
  begin
    try
      Err:= 206;
      // if there is no kasse oplysninger record for the create one
      if not ffkasopl.FindKey([Kassenr]) then
      begin
        ffKasOpl.Append;
        ffKasOplKasseNr.AsInteger := KasseNr;
        ffKasOplBonNr.AsInteger := (KasseNr * 1000000) + 1;
        ffKasOpl.Post;
        Bonnr := ffKasOplBonNr.AsInteger;
      end
      else
      begin
        Bonnr := ffKasOplBonNr.AsInteger;
        ffKasOpl.Edit;
        ffKasOplBonNr.Value := ffKasOplBonNr.Value + 1;
        ffKasOpl.Post;
      end;
    except
      on e: exception do
      begin
        C2LogAdd('Error in EditKasseOplysninger ' + e.Message);
        try
          ffKasOpl.Cancel;
        except
          on E: Exception do
            C2LogAdd('Error calling cancel in EditKasseOplysninger ' + e.Message);
        end;
        raise;
      end;
    end;
  end;

  procedure tr_InsertKasseEkspeditioner;
  begin
    try
      Err:= 202;
C2LogAdd ('    Kasse ekspedition');
      ffKasEks.Insert;
      Err:= 203;
      ffKasOpl.Refresh;
      ffKasEksKasseNr.Value     := ffKasOplKasseNr.Value;
      ffKasEksBonNr.Value       := Bonnr;
      nxRemoteServerInfoPlugin1.GetServerDateTime(servertime);
      ffKasEksDato.Value        := servertime;

      ffKasEksBrugerNr.Value    :=  BrugerNr;
      ffKasEksUdlignNr.Value    := 0;
      ffKasEksAfdeling.AsString :=  StamForm.AfdelNavn;
      ffKasEksAntLin.Value      := 0;
      ffKasEksAntBet.Value      := 0;
      ffKasEksAntBon.Value      := 0;
      ffKasEksBrutto.Value      := 0;
      ffKasEksRabatBon.Value    := 0;
      ffKasEksRabatLin.Value    := 0;
      ffKasEksMoms.Value        := 0;
      ffKasEksKontant.Value     := 0;
      ffKasEksCheck.Value       := 0;
      ffKasEksDankort.Value     := 0;
      ffKasEksKrKort.Value      := 0;
      ffKasEksValuta.Value      := 0;
      ffKasEksKontoNr.AsString  := ''; //nxEkspKontoNr.AsString;
      ffKasEkstekst2.AsString   := '';
      ffKasEkstekst3.AsString   := '';
      ffKasEkstekst4.AsString   := '';
      ffKasEkstekst5.AsString   := C2UserName;
      Err:= 204;
      ffKasEks.Post;
    except
      on e: exception do
      begin
        c2logadd('Error in InsertKasseEkspeditioner ' + e.Message);
        try
          ffKasEks.Cancel;
        except
          on E: Exception do
            c2logadd('Error calling cancel in InsertKasseEkspeditioner ' + e.Message);
        end;
        raise;
      end;
    end;
  end;

  procedure tr_AddEkpspeditionerBon(ALbnr : integer);
  begin
    try
      // if he lbnr is not in  nexus table ekspeditionerbon then add it
      nxEksbon.IndexName := 'LbnrOrden';
      if not nxEksbon.FindKey([ALbnr]) then
      begin
        nxEksbon.Append;
        nxEksbonLbNr.AsInteger := ALbnr;
        nxEksbonKasseNr.AsInteger := ffKasEksKasseNr.AsInteger;
        nxEksbonBonNr.AsInteger := ffKasEksBonNr.AsInteger;
        nxEksbon.Post;
      end;

    except
      on e : Exception do
      begin
        C2LogAdd('Error in tr_AddEkpspeditionerBon ' + e.Message);
        try
          nxEksbon.Cancel;
        except
          on E: Exception do
            C2LogAdd('Error calling cancel in tr_AddEkpspeditionerBon ' + e.Message);
        end;
        raise;
      end;

    end;
  end;

  // this will try to get the first kassenr from the current arbejdspladsnr in winpacer and
  // write the LevListeKassenr back into winpacer
  function SetupLevListeKassenr : boolean;
  var
    LstNvn: string;
    winpacer : TIniFile;
    sections : TStringList;
    sectionname : string;
    tmpkassenr : integer;
  begin
    Result := False;
    LstNvn := GetCurrentDir + '\' + 'Winpacer.ini';
    if not FileExists(LstNvn) then
    begin
      LstNvn := 'G:\Winpacer.ini';
      if not FileExists(LstNvn) then
        exit;
    end;
    sections := TStringList.Create;
    winpacer := TIniFile.Create(LstNvn);
    try

      winpacer.ReadSections(sections);
      sections.sort;
      for sectionname in sections do
      begin
//        // look for userxx segments only
//        if CompareText(copy(sectionname,1,4), 'USER') = 0  then
//        begin
          // if the arbejdsplads number is the same as the current user then write
          // LevListeKassenr back to current user

          if winpacer.ReadInteger(sectionname,'Arbejdsplads',0) = StamForm.FPladsNr then
          begin
            tmpkassenr := winpacer.ReadInteger(sectionname,'Kasse',0);
            if tmpkassenr <> 0 then
            begin
              winpacer.WriteInteger(C2UserName,'LevListeKassenr',tmpkassenr);
              MainLog.C2IniReload;
              KasseNr := tmpkassenr;
              Result := True;
              exit;
            end;

          end;

//        end;

      end;

    finally
      winpacer.Free;
      sections.Free;
    end;
  end;

begin

  C2LogAdd ('  MainDm OpdaterZeroBonLevlist in');
  Err:= 201;
  KasseNr := C2IntPrm(C2UserName,'Kasse',0);
  KasseNr := C2IntPrm(C2UserName,'LevListeKassenr',KasseNr);
  if KasseNr = 0  then
  begin
    if not SetupLevListeKassenr then
    begin
      ChkBoxOK('Fejl i LevListeKassenr. Kontakt Cito');
      C2LogAdd('Fejl i LevListeKassenr. Kontakt Cito');
      exit;
    end;

  end;


  C2LogAdd('kassenr is now ' + IntToStr(KasseNr));
  save_index := nxEksp.IndexName;
  nxEksp.IndexName := 'NrOrden';
  try
    try
      C2LogAdd ('    StartTransAction');
      ffKasOpl.Database.StartTransactionWith([nxEksbon,ffKasEks,ffKasOpl]);
      if ffKasOpl.Database.InTransaction then
      begin
        C2LogAdd ('    InTransaction');
        // Ret tekst
        tr_EditKasseOplysninger;
        Err:= 207;
        tr_InsertKasseEkspeditioner;
        for lbnr in ALbnrList do
          tr_AddEkpspeditionerBon(lbnr);
        C2LogAdd ('    Commit');
        Err:= 208;
        ffKasOpl.Database.Commit;
        Err:= 0;
      end;
    except
      on E: Exception do
      begin
        C2LogAdd ('    Exception, err ' + IntToStr(Err));
        C2LogAdd ('      Message "' + E.Message + '"');
        try
          C2LogAdd ('    Rollback');
          ffKasOpl.Database.Rollback;
        except
          on E: Exception do
            C2LogAdd('Error calling Rollback ' + e.Message);
        end;
      end;
    end;

    for lbnr in ALbnrList do
    begin
      if not DMVSSvrConnection.SendRequestsByLbnr(ffKasEksBrugerNr.AsInteger,
            lbnr,
            VarerSent,VarerNotSent,Restxt) then
      begin
        ChkBoxOK(Restxt);
      end;
    end;




  finally
    nxeksp.IndexName := save_index;
    Result:= Err;
  end;
  C2LogAdd ('  MainDm OpdaterZeroBonLevlist out');
end;

function TMainDm.GetAsylnCpr(ALevInfo: string; out AASylnCPR: string): Boolean;
var
  sl: TStringList;
  LTmpstr: string;
  LSetAsynCPR: Boolean;
  i: integer;
  LVal: int64;
begin
  Result := False;
  AASylnCPR := '';
  LSetAsynCPR := False;
  sl := TStringList.Create;
  try
    sl.Delimiter := ':';
    sl.StrictDelimiter := False; // delimiters are space and :
    sl.DelimitedText := ALevInfo;
    for LTmpstr in sl do
    begin
			// if personid : then we are interested so get the text after the :
      if CompareText(LTmpstr, 'PersonId') = 0 then
      begin
        LSetAsynCPR := True;
        continue;
      end;

			// if the set flag is true then return the current bit up to 1st non digit
      if LSetAsynCPR then
      begin
        if TryStrToInt64(LTmpstr, LVal) then
        begin
          AASylnCPR := LTmpstr;
          Result := True;
          exit;
        end;

				// build up result until we get a non digit
        for i := 1 to length(LTmpstr) do
        begin
          if (copy(LTmpstr, i, 1) >= '0') and (copy(LTmpstr, i, 1) <= '9') then
          begin
            AASylnCPR := AASylnCPR + copy(LTmpstr, i, 1);
          end
          else
            Break;
        end;
        Result := True;
        exit;
      end;

    end;

  finally
    sl.Free;
  end;

end;


function TMainDm.Amt2Region(Amt: word): word;
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



end.
