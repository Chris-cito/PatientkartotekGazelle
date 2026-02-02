unit uEDIRcp.classes;

interface

uses Classes,uc2object.classes,generics.collections;

type


TEdiOrd = class;

TEdiRCP = class(TC2object)
private
    FLbnr: int64;
    FAnnuller: boolean;
    FPaCprNr: string;
    FPaNavn: string;
    FForNavn: string;
    FAdr: string;
    FAdr2: string;
    FPostNr: string;
    FBy: string;
    FAmt: string;
    FTlf: string;
    FAlder: string;
    FBarn: string;
    FTilskud: string;
    FTilBrug: string;
    FLevering: string;
    FFriTxt: string;
    FYdnr: string;
    FYdrCprNr: string;
    FYdNavn: string;
    FYdSpec: string;
    FOrdAnt: integer;
    FLevinfo: string;
    FDanmark: boolean;
    FKontonr: string;
    FOrd: TObjectList<TEdiOrd>;
  { private declarations }
protected
  { protected declarations }
public
  { public declarations }
  property Lbnr: int64 read FLbnr write FLbnr;
  property Annuller: boolean read FAnnuller write FAnnuller;
  property PaCprNr: string read FPaCprNr write FPaCprNr;
  property PaNavn: string read FPaNavn write FPaNavn;
  property ForNavn: string read FForNavn write FForNavn;
  property Adr: string read FAdr write FAdr;
  property Adr2: string read FAdr2 write FAdr2;
  property PostNr: string read FPostNr write FPostNr;
  property By: string read FBy write FBy;
  property Amt: string read FAmt write FAmt;
  property Tlf: string read FTlf write FTlf;
  property Alder: string read FAlder write FAlder;
  property Barn: string read FBarn write FBarn;
  property Tilskud: string read FTilskud write FTilskud;
  property TilBrug: string read FTilBrug write FTilBrug;
  property Levering: string read FLevering write FLevering;
  property FriTxt: string read FFriTxt write FFriTxt;
  property Ydnr: string read FYdnr write FYdnr;
  property YdrCprNr: string read FYdrCprNr write FYdrCprNr;
  property YdNavn: string read FYdNavn write FYdNavn;
  property YdSpec: string read FYdSpec write FYdSpec;
  property OrdAnt: integer read FOrdAnt write FOrdAnt;
  property Levinfo: string read FLevinfo write FLevinfo;
  property Danmark: boolean read FDanmark write FDanmark;
  property Kontonr: string read FKontonr write FKontonr;
  property Ord: TObjectList<TEdiOrd> read FOrd write FOrd;


end;

TEdiOrd = class(TC2Object)
private
    FVarenr: string;
    FNavn: string;
    FDisp: string;
    FStrk: string;
    FPakn: string;
    FSubst: string;
    FAntal: integer;
    FTilsk: string;
    FIndKode: string;
    FIndTxt: string;
    FUdlev: integer;
    FForhdl: string;
    FDoskode: string;
    FDosTxt: string;
    FPEMAdmDone: integer;
    FOrdId: string;
    FReceptId: integer;
    FKlausulbetingelse: boolean;
    FUserPris: currency;
    FSubVarenr: string;
  { private declarations }
protected
  { protected declarations }
public
  { public declarations }
  property Varenr: string read FVarenr write FVarenr;
  property Navn: string read FNavn write FNavn;
  property Disp: string read FDisp write FDisp;
  property Strk: string read FStrk write FStrk;
  property Pakn: string read FPakn write FPakn;
  property Subst: string read FSubst write FSubst;
  property Antal: integer read FAntal write FAntal;
  property Tilsk: string read FTilsk write FTilsk;
  property IndKode: string read FIndKode write FIndKode;
  property IndTxt: string read FIndTxt write FIndTxt;
  property Udlev: integer read FUdlev write FUdlev;
  property Forhdl: string read FForhdl write FForhdl;
  property Doskode: string read FDoskode write FDoskode;
  property DosTxt: string read FDosTxt write FDosTxt;
  property PEMAdmDone: integer read FPEMAdmDone write FPEMAdmDone;
  property OrdId: string read FOrdId write FOrdId;
  property ReceptId: integer read FReceptId write FReceptId;
  property Klausulbetingelse: boolean read FKlausulbetingelse write FKlausulbetingelse;
  property UserPris: currency read FUserPris write FUserPris;
  property SubVarenr: string read FSubVarenr write FSubVarenr;
end;

implementation

end.
