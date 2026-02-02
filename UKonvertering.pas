unit UKonvertering;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, nxdb, StdCtrls, Grids, DBGrids;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ffDos: TnxTable;
    ffDosKode: TStringField;
    ffDosDfdgKode: TStringField;
    ffDosType: TWordField;
    ffDosTekst1: TStringField;
    ffDosTekst2: TStringField;
    ffDosTekst3: TStringField;
    ffDosTekst4: TStringField;
    ffDosTekst5: TStringField;
    ffDosSikret: TBooleanField;
    ffDosDD: TCurrencyField;
    Memo1: TMemo;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ffAtc: TnxTable;
    DataSource2: TDataSource;
    ffAtcKode: TStringField;
    ffAtcTekst: TStringField;
    ffAtcIndikation1: TStringField;
    ffAtcIndikation2: TStringField;
    ffAtcIndikation3: TStringField;
    ffAtcIndikation4: TStringField;
    ffAtcIndikation5: TStringField;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  stBCD;

{$R *.DFM}

type
  STR01           = String [01];
  STR02           = String [02];
  STR03           = String [03];
  STR04           = String [04];
  STR05           = String [05];
  STR06           = String [06];
  STR07           = String [07];
  STR08           = String [08];
  STR09           = String [09];
  STR10           = String [10];
  STR11           = String [11];
  STR12           = String [12];
  STR13           = String [13];
  STR14           = String [14];
  STR15           = String [15];
  STR16           = String [16];
  STR18           = String [18];
  STR19           = String [19];
  STR20           = String [20];
  STR22           = String [22];
  STR24           = String [24];
  STR25           = String [25];
  STR30           = String [30];
  STR37           = String [37];
  STR40           = String [40];
  STR43           = String [43];
  STR50           = String [50];
  STR60           = String [60];
  STR80           = String [80];
  STR255          = String [255];

  TACREC      = PACKED RECORD                    (*   ATC RECORD 197     *)
    AC_NR     : STR10;                           (*   ATC KODE (PRI)     *)
    AC_NAVN   : STR50;                           (*   ATC NAVN           *)
    AC_INDIK  : ARRAY [1..5] OF STR30;           (*   ATC INDIKATIONER   *)
  END;

  TDFREC      = PACKED RECORD                    (*   DISP. RECORD  200  *)
    DF_NR     : STR02;                           (*   DISP. NR  (PRI)    *)
    DF_FORM   : STR30;                           (*   DISP. FORM         *)
    DF_EN     : STR30;                           (*   FORM ENTAL         *)
    DF_FL     : STR30;                           (*   FORM FLERTAL       *)
    DF_TEKST  : STR30;                           (*   FùLGETEKST         *)
    FILLER    : ARRAY [1..73] OF BYTE;           (*   FILLER             *)
  END;

  TDSREC      = PACKED RECORD                    (*   DOSER. RECORD 72   *)
    DS_NR     : STR10;                           (*   DOSNR.    (PRI)    *)
    DS_TEKST  : STR60;                           (*   DOSERINGSFORSLAG   *)
  END;

  TDOREC      = PACKED RECORD                    (*   DOSER. RECORD 250  *)
    DS_NR     : STR10;                           (*   DOSNR.    (PRI)    *)
    DS_TEKST  : STR60;                           (*   DOSERINGSFORSLAG   *)
    DS_TEKST2 : STR60;                           (*   DOSERINGSFORSLAG   *)
    DS_TEKST3 : STR60;                           (*   DOSERINGSFORSLAG   *)
    DS_DD     : TBCD;                            (*   DùGN DOSER         *)
    DS_KODE   : STR10;                           (*   KODE I D.F.D.      *)
    DS_UDLEV  : SMALLINT;                        (*   UDLEVERINGER I DOS.*)
    DS_OK     : SMALLINT;                        (*   KVALITETSSIKRET=1  *)
    FILLER    : ARRAY [1..31] OF BYTE;           (*   FILLER             *)
  END;


function StrOemAnsi (const S : String) : String;
var
  Wi,
  Wo : String;
begin
  Wi := Trim (S);
  Wo := Wi;
  if Wi <> '' then begin
    SetLength (Wo, Length (Wi));
    OemToCharBuff (@Wi [1], @Wo [1], Length (Wi));
    Wo := AnsiUppercase (Wo);
  end;
  Result := Wo;
end;


function BCD2Curr (BCD : TBCD) : Currency;
begin
  Result := BCDExt (BCD);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
//
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  I : Word;
  S : TStringList;
  W,
  IRec : String;
begin
  ffAtc.Exclusive := True;
  ffAtc.Open;
  ffAtc.EmptyTable;
  ffAtc.Close;
  ffAtc.Exclusive := False;
  ffAtc.Open;
  ffAtc.DisableControls;
  S := TStringList.Create;
  S.LoadFromFile ('c:\Apotek\AtcKoderNy.prn');
  for I := 0 to S.Count - 1 do begin
    IRec := S.Strings [I];
    ffAtc.Insert;
    try
      W := Trim (Copy (IRec, 1, 10));
      repeat
        Delete (W, Pos (' ', W), 1);
      until pos (' ', W) = 0;
      ffAtcKode.AsString        := W;
      ffAtcTekst.AsString       := Trim (Copy (IRec,  11, 56));
      ffAtcIndikation1.AsString := Trim (Copy (IRec,  67, 32));
      ffAtcIndikation2.AsString := Trim (Copy (IRec,  99, 36));
      ffAtcIndikation3.AsString := Trim (Copy (IRec, 135, 31));
      ffAtcIndikation4.AsString := Trim (Copy (IRec, 166, 42));
      ffAtcIndikation5.AsString := Trim (Copy (IRec, 208, 30));
      ffAtc.Post;
    except
      ffAtc.Cancel;
    end;
  end;
  S.Free;
  S := NIL;
  ffAtc.EnableControls;
end;

end.
