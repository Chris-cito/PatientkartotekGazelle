type
  TEdiOrd          = record
    VareNr         : string;
    Navn           : string;
    Disp           : string;
    Strk           : string;
    Pakn           : string;
    Subst          : string;
    Antal          : Word;
    Tilsk          : string;
    IndKode        : String;
    IndTxt         : string;
    Udlev          : Word;
    Forhdl         : string;
    DosKode        : string;
    DosTxt         : string;
    PEMAdmDone     : integer;
    OrdId          : string;
    ReceptId       : integer;
    Klausulbetingelse : boolean;
    UserPris       : currency;
    SubVarenr      : string;
    OrdineretVarenr : string;
    OrdineretAntal : integer;
    OrdineretUdlevType : string;
    UdstederAutId : string;
    UdstederId : string;
    UdstederType : Integer;
    DrugId : string;
    OpbevKode : string;
  end;

  TEdiRcp          = record
    LbNr           : LongWord;
    Annuller       : Boolean;
    PaCprNr        : string;
    PaNavn         : string;
    ForNavn        : string;
    Adr            : string;
    Adr2           : string;
    PostNr         : string;
    By             : string;
    Amt            : string;
    Tlf            : string;
    Alder          : string;
    Barn           : string;
    Tilskud        : string;
    TilBrug        : string;
    Levering       : string;
    FriTxt         : string;
    YdNr           : string;
    YdCprNr        : string;
    YdNavn         : string;
    YdSpec         : string;
    OrdAnt         : Word;
    LevInfo        : string;
    Danmark        : boolean;
    Kontonr        : string;
    OrdreDato      : TDateTime;
    SenderIsInstitution : Boolean;
    Ord            : array [1..99] of TEdiOrd;
  end;

  PEdiRcp          = ^TEdiRcp;

const
// patient type constants
//  if S = 'Ingen'                  then Result:= 0;
//  if S = 'Enkeltperson'           then Result:= 1;
//  if S = 'Læge'                   then Result:= 2;
//  if S = 'Dyrlæge'                then Result:= 3;
//  if S = 'Tandlæge'               then Result:= 4;
//  if S = 'Forsvaret'              then Result:= 5;
//  if S = 'Fængsel/Arresthus'      then Result:= 6;
//  if S = 'Asylcenter'             then Result:= 7;
//  if S = 'Jordemor'               then Result:= 8;
//  if S = 'Hjemmesygeplejerske'    then Result:= 9;
//  if S = 'Skibsfører/Reder'       then Result:= 10;
//  if S = 'Sygehus'                then Result:= 11;
//  if S = 'Plejehjem'              then Result:= 12;
//  if S = 'Hobbydyr'               then Result:= 13;
//  if S = 'Landmand (erhvervsdyr)' then Result:= 14;
//  if S = 'Håndkøbsudsalg'         then Result:= 15;
//  if S = 'Andet apotek'           then Result:= 16;
//  if S = 'Institutioner'          then Result:= 17;
//  if S = 'Asylansøger'            then Result:= 18;
  pt_Ingen = 0;
  pt_Enkeltperson = 1;
  pt_Laege = 2;
  pt_Dyrlaege = 3;
  pt_Tandlaege = 4;
  pt_Forsvaret = 5;
  pt_Faengsel_Arresthus = 6;
  pt_Asylcenter = 7;
  pt_Jordemor = 8;
  pt_Hjemmesygeplejerske = 9;
  pt_Skibsfoerer_Reder = 10;
  pt_Sygehus = 11;
  pt_Plejehjem =12;
  pt_Hobbydyr = 13;
  pt_Landmand = 14;
  pt_Haandkoebsudsalg = 15;
  pt_Andetapotek = 16;
  pt_Institutioner = 17;
  pt_Asylansoeger = 18;


// ekspedition type constants
//    1: Result:= 'Recepter';
//    2: Result:= 'Vagtbrug m.m.';
//    3: Result:= 'Leverancer';
//    4: Result:= 'Håndkøb';
//    5: Result:= 'Dyr';
//    6: Result:= 'Narkoleverance';
//    7: Result:= 'Dosispakning';
//    8: Result:= 'Infertilitet';
  et_Recepter = 1;
  et_Vagtbrugmm = 2;
  et_Leverancer = 3;
  et_Haandkoeb = 4;
  et_Dyr = 5;
  et_Narkoleverance = 6;
  et_Dosispakning = 7;
  et_Infertilitet = 8;  // not used at the moment


// linie type constants
//    1: Result:= 'Recept';
//    2: Result:= 'Håndkøb';
//    9: Result:= 'Tekst';

  lt_Recept = 1;
  lt_Handkoeb = 2;
  lt_Tekst = 9;
