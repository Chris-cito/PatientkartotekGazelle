unit SygsikAfregning;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FileCtrl, ExtCtrls, Gauges, StdCtrls, Buttons, ComCtrls, DB, Menus;

type
  TOpdAfrForm = class(TForm)
    gbDatoer: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    eFra: TDateTimePicker;
    eTil: TDateTimePicker;
    gbPrinter: TGroupBox;
    gbDebitor: TGroupBox;
    cbDeb: TCheckBox;
    paGentag: TPanel;
    butAfregn: TBitBtn;
    butUdskriv: TBitBtn;
    gbVagt: TGroupBox;
    cbVagt: TCheckBox;
    gbNarko: TGroupBox;
    cbNarko: TCheckBox;
    butDisketter: TBitBtn;
    meUd: TPopupMenu;
    meUdOpg: TMenuItem;
    meUdVagt: TMenuItem;
    meUdNarko: TMenuItem;
    meUdFejl: TMenuItem;
    butEtik: TBitBtn;
    gaMeter: TGauge;
    gbDisks: TGroupBox;
    cbDisks: TCheckBox;
    gbFilial: TGroupBox;
    cbFilial: TCheckBox;
    cbPNr: TComboBox;
    procedure DanEkspeditioner;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ButAfregnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure butDisketterClick(Sender: TObject);
    procedure butUdskrivClick(Sender: TObject);
    procedure meUdOpgClick(Sender: TObject);
    procedure meUdVagtClick(Sender: TObject);
    procedure meUdNarkoClick(Sender: TObject);
    procedure meUdFejlClick(Sender: TObject);
    procedure butEtikClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PNr,
    AfrRes  : Word;
    FraDato,
    TilDato : TDateTime;
  end;

  function SygesikringsAfregning : Boolean;

var
  OpdAfrForm: TOpdAfrForm;

implementation

uses
  MidClientApi,
  MatrixPrinter,
  HentHeltal,
  UbiPrinter,
  ChkBoxes,
  C2Date,
  C2Procs,
  Main,
  DM;

{$R *.DFM}

function SygesikringsAfregning : Boolean;
begin
  OpdAfrForm := TOpdAfrForm.Create (NIL);
  try
    SidsteDatoer (OpdAfrForm.FraDato, OpdAfrForm.TilDato);
    OpdAfrForm.Caption         := 'Sygesikringsafregning';
    OpdAfrForm.eFra.DateTime   := OpdAfrForm.FraDato;
    OpdAfrForm.eTil.DateTime   := OpdAfrForm.TilDato;
    OpdAfrForm.cbPNr.ItemIndex := 0;
    OpdAfrForm.ShowModal;
  finally
    Result := OpdAfrForm.AfrRes = 0;
    OpdAfrForm.Free;
    OpdAfrForm := NIL;
  end;
end;

procedure TOpdAfrForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    SelectNext (ActiveControl, TRUE, TRUE);
    Key := #0;
  end;
  if Key = #27 then begin
    Key := #0;
    ModalResult := mrCancel;
  end;
end;

procedure TOpdAfrForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F6 then begin
    ButAfregn.Click;
    Key := 0;
  end;
end;

procedure TOpdAfrForm.ButAfregnClick(Sender: TObject);
begin
  FraDato := eFra.Date;
  TilDato := eTil.Date;
  PNr     := cbPNr.ItemIndex + 1;
  if Trunc (TilDato) >= Trunc (FraDato) then begin
    DanEkspeditioner;
  end else
    ChkBoxOk ('Fejl i afregningsdatoer !');
end;

procedure TOpdAfrForm.DanEkspeditioner;
const
  MaxPoster = 17500;
var
  SamleOpg  : array [1..103, 1..9] of Currency;
  UdDato    : TDateTime;
  NrkFil,
  VgtFil,
  LogFil,
  OpgFil,
  ErrFil,
  DskFil,
  AfrFil    : TStringList;
  ApoNr,
  AfrMd,
  AfrLin,
  InstNvn,
  SortStr,
//  InFilter,
  IdxName   : String;
  SSPct,
  ErrTot1,
  ErrTot2   : Currency;
  InstUd    : Boolean;
  AmtRegel,
  SamleLin,
  CntInst,
  SavRecs,
  AktRecs,
  RstRecs,
  TotDisk,
  CntDisk   : Word;
  TotRecs,
  CntRecs,
  MaxRecs   : LongWord;

  procedure DanSamleOpg (Refusion : Currency; Instans, Regel : Word);
  var
    Idx : Word;
  begin
    case Regel of
      11, 13, 14, 16 : Idx := 1;
      41             : Idx := 2;
      42, 43         : Idx := 3;
      44             : Idx := 4;
      45             : Idx := 5;
      46             : Idx := 6;
      59             : Idx := 7;
    else
      Idx := 8;
    end;
    SamleOpg [Instans, Idx] := SamleOpg [Instans, Idx] + Refusion;
    SamleOpg [Instans,   9] := SamleOpg [Instans,   9] + Refusion;
    SamleOpg [100    ,   1] := SamleOpg [100    ,   1] + Refusion;
    if Idx in [2, 3, 4] then
      SamleOpg [101  ,   1] := SamleOpg [101    ,   1] + Refusion;
  end;

  procedure AfrFejl (Tekst : String; AmtKom : Word; Refusion : Currency);
  begin with MainDm do begin
    // Tilbageførsel eller normal
    if ffAfrEksOrdreType.Value = 2 then
      Refusion := -Refusion;
    Tekst := 'Eksp.nr. ' + IntToStr (ffAfrEksLbNr.Value) + ', ' +
             'cprnr. ' + ffAfrEksKundeNr.AsString + ', ' +
             Tekst + ', beløb ' +
             FormatCurr ('###,###,##0.00', Refusion);
    ErrFil.Add (Tekst);
    case AmtKom of
      1 : ErrTot1 := ErrTot1 + Refusion;
      2 : ErrTot2 := ErrTot2 + Refusion;
    end;
  end; end;

  procedure AfrAmt (Regel : Word; Refusion : Currency);
  var
    WrkLin,
    WrkStr,
    VareNr,
    YderNr,
    CprNr,
    SubValg : String;
    Procent : Currency;
    DosMark,
    KorrKd,
    Instans,
    Antal,
    Barn,
    UdlevNr : Word;
  begin with MainDm do begin
    // Hvis antal pakninger er 0
    KorrKd := ffAfrEksOrdreType.Value - 1;
    Antal  := 1;
    if Abs (ffAfrLinAntal.Value) > 1 then
      Antal := Abs (ffAfrLinAntal.Value);
    // Dosispakning
    DosMark := 0;
    if (ffAfrEksEkspType.Value = 7) or (ffAfrEksEkspForm.Value = 5) then
      DosMark := 1;
    // Reiterering
    UdlevNr := 0;
    if ffAfrLinUdlevMax.Value > 0 then
      UdlevNr := ffAfrLinUdlevNr.Value;
    SubValg := ' ';
//    if not ffAfrLinOMark.AsBoolean then
//      SubValg := 'O';
    if ffAfrLinEjG.Value = 1 then
      SubValg := 'G';
    if Trim (ffAfrLinSubVareNr.AsString) <> '' then
      VareNr := Trim (ffAfrLinSubVareNr.AsString)
    else
      VareNr := Trim (ffAfrLinVareNr.AsString);
    YderNr := '0990027';
    if Length (Trim (ffAfrEksYderNr.AsString)) = 7 then
      YderNr := Trim (ffAfrEksYderNr.AsString);
    if Regel = 99 then begin
      // Ikke tilskudsberettiget
      Instans := 0;
      CprNr   := '0000000000';
      Barn    := 0;
      Procent := 0;
    end else begin
      // Tilskudsberettiget
      Instans := ffAfrEksAmt.Value;
      if ffAfrEksCprCheck.AsBoolean then begin
        if Length (Trim (ffAfrEksKundeNr.AsString)) = 10 then
          CprNr := Trim (ffAfrEksKundeNr.AsString)
        else
          CprNr := '4000000995';
      end else begin
        if Regel in [11, 13, 14, 16] then
          CprNr := '0000000000'
        else
          CprNr := '4000000995';
      end;
      // Check for narko
      if cbNarko.Checked then begin
        if ffLmsTak.FindKey ([VareNr]) then begin
          if Pos ('P4', ffLmsTakUdlevType.AsString) > 0 then begin
            Str (ffAfrEksLbNr.Value:7, WrkStr);
            WrkLin := WrkStr + '     ';
            Str (ffAfrLinLinieNr.Value:3, WrkStr);
            WrkLin := WrkLin + WrkStr + '  ';
            WrkLin := WrkLin + VareNr + '  ';
            if ffAfrEksOrdreType.Value = 2 then
              Str (-Antal:4, WrkStr)
            else
              Str (Antal:4, WrkStr);
            WrkLin := WrkLin + WrkStr + '  ';
            if Trim (ffAfrEksNarkoNr.AsString) <> '' then
              WrkStr := Trim (ffAfrEksNarkoNr.AsString)
            else
              WrkStr := Trim (ffAfrEksYderCprNr.AsString);
            if Length (WrkStr) < 10 then
              WrkStr := WrkStr + Spaces (10 - Length (WrkStr));
            WrkLin := WrkLin + WrkStr + '  ';
            WrkLin := WrkLin + YderNr + '  ';
            WrkLin := WrkLin +
              FormatDateTime ('dd-mm-yy', ffAfrEksAfsluttetDato.AsDateTime) + '  ';
            WrkLin := WrkLin + CprNr;
            NrkFil.Add (WrkLin);
          end;
        end;
      end;
      // Check for vagtbrug
      if cbVagt.Checked then begin
        if Regel in [11, 13, 14, 16] then begin
          Str (ffAfrEksLbNr.Value:7, WrkStr);
          WrkLin := WrkStr + '     ';
          Str (Regel:6, WrkStr);
          WrkLin := WrkLin + WrkStr + '       ';
          WrkLin := WrkLin + YderNr + '        ';
          WrkLin := WrkLin + VareNr + '    ';
          if ffAfrEksOrdreType.Value = 2 then begin
            Str (-Antal:5, WrkStr);
            WrkLin := WrkLin + WrkStr + '   ';
            WrkLin := WrkLin + FormCurr2Str ('###,###,##0.00', -Refusion);
          end else begin
            Str (Antal:5, WrkStr);
            WrkLin := WrkLin + WrkStr + '   ';
            WrkLin := WrkLin + FormCurr2Str ('###,###,##0.00', Refusion);
          end;
          VgtFil.Add (WrkLin);
        end;
      end;
      // Beregn uhjælpelig procent til amtet
      Procent := 0;
      if ffAfrTilBGPBel.AsCurrency > 0 then
        Procent := (Refusion * 100) / ffAfrTilBGPBel.AsCurrency;
      if Procent > 100 then
        Procent := 100;
      if Regel = 44 then begin
        // Korriger regel 44
        YderNr  := '0000000';
        UdlevNr := 0;
        if KorrKd = 1 then
          KorrKd := 0
        else
          KorrKd := 1;
      end;
    end;
    // Afregningslinie
    AfrLin := '2'                                                         +
              ApoNr                                                       +
              AfrMd                                                       +
              IntToStr (KorrKd)                                           +
              Long2Str (ffAfrEksLbNr.Value mod 100000, 5)                 +
              Word2Str (ffAfrLinLinieNr.Value, 2)                         +
              Word2Str (Regel, 2)                                         +
              Word2Str (Instans, 3)                                       +
              VareNr                                                      +
              Word2Str (Round (Procent * 100), 6)                         +
              FormatDateTime ('yymmdd', ffAfrEksAfsluttetDato.AsDateTime) +
              CprNr                                                       +
              Word2Str (Barn, 1)                                          +
              YderNr                                                      +
              Word2Str (DosMark, 1)                                       +
              Word2Str (UdlevNr, 2)                                       +
              Word2Str (ffAfrEksCtrType.Value, 2)                         +
              Word2Str (Antal, 2)                                         +
              Long2Str (Round (Refusion * 100), 9)                        +
              SubValg                                                     +
              '      ';
    if Length (AfrLin) = 80 then begin
      // Linie OK
      try
        SortStr := Copy (AfrLin,  1, 8) +
                   Copy (AfrLin, 34, 6) +
                   Copy (AfrLin, 10, 7);
        AfrFil.Add (SortStr + AfrLin);
        if Regel <> 99 then begin
          if refusion > 0 then begin
            if Regel = 44 then begin
              if ffAfrEksOrdreType.Value = 2 then
                DanSamleOpg ( Refusion, Instans, Regel)
              else
                DanSamleOpg (-Refusion, Instans, Regel);
            end else begin
              if ffAfrEksOrdreType.Value = 2 then
                DanSamleOpg (-Refusion, Instans, Regel)
              else
                DanSamleOpg ( Refusion, Instans, Regel);
            end;
          end;
        end;
      except
      end;
    end else begin
      // Linie med fejl
      AfrFejl ('fejl i data', 1, Refusion);
    end;
  end; end;

  procedure AfrKommune (Regel : Word; Refusion : Currency);
  var
    VareNr,
    YderNr,
    CprNr,
    SubValg : String;
    Procent : Currency;
    Antal,
    Barn,
    UdlevNr : Word;
  begin with MainDm do begin
    // Hvis antal pakninger er 0
    Antal := 1;
    if Abs (ffAfrLinAntal.Value) > 1 then
      Antal := Abs (ffAfrLinAntal.Value);
    UdlevNr := 0;
    if ffAfrLinUdlevMax.Value > 0 then
      UdlevNr := ffAfrLinUdlevNr.Value;
    SubValg := ' ';
//    if not ffAfrLinOMark.AsBoolean then
//      SubValg := 'O';
    if ffAfrLinEjG.Value = 1 then
      SubValg := 'G';
    if Trim (ffAfrLinSubVareNr.AsString) <> '' then
      VareNr := Trim (ffAfrLinSubVareNr.AsString)
    else
      VareNr := Trim (ffAfrLinVareNr.AsString);
    YderNr := '0990027';
    if Length (Trim (ffAfrEksYderNr.AsString)) = 7 then
      YderNr := Trim (ffAfrEksYderNr.AsString);
    if ffAfrEksCprCheck.AsBoolean then
      CprNr := Trim (ffAfrEksKundeNr.AsString)
    else
      CprNr := '4000000995';
    Procent := 0;
    if ffAfrTilBGPBel.AsCurrency > 0 then
      Procent := (Refusion * 100) / ffAfrTilBGPBel.AsCurrency;
    if Procent > 100 then
      Procent := 100;
    Barn := 0;
    // Afregningslinie
    AfrLin := '2'                                                         +
              ApoNr                                                       +
              AfrMd                                                       +
              IntToStr (ffAfrEksOrdreType.Value - 1)                      +
              Long2Str (ffAfrEksLbNr.Value mod 100000, 5)                 +
              Word2Str (ffAfrLinLinieNr.Value, 2)                         +
              Word2Str (Regel, 2)                                         +
              Word2Str (ffAfrEksKommune.Value, 3)                         +
              VareNr                                                      +
              Word2Str (Round (Procent * 100), 6)                         +
              FormatDateTime ('yymmdd', ffAfrEksAfsluttetDato.AsDateTime) +
              CprNr                                                       +
              Word2Str (Barn, 1)                                          +
              YderNr                                                      +
              '0'                                                         +
              Word2Str (UdlevNr, 2)                                       +
              Word2Str (ffAfrEksCtrType.Value, 2)                         +
              Word2Str (Antal, 2)                                         +
              Long2Str (Round (Refusion * 100), 9)                        +
              SubValg                                                     +
              '      ';
    if Length (AfrLin) = 80 then begin
      // Linie OK
      SortStr := Copy (AfrLin,  1, 8) +
                 Copy (AfrLin, 34, 6) +
                 Copy (AfrLin, 10, 7);
      AfrFil.Add (SortStr + AfrLin);
    end else begin
      // Linie med fejl
      AfrFejl ('fejl i data', 2, Refusion);
    end;
  end; end;

  function Aponr2Filial (S : String) : String;
  var
    ApoNr : Integer;
  begin
    try
      ApoNr  := StrToInt (S);
      Result := Word2Str (ApoNr + 400, 3);
    except
      Result := S;
    end;
  end;

begin with MainDm{, MidClient} do begin
  FillChar (SamleOpg, SizeOf (SamleOpg), 0);
  SSPct   := ffRcpOplSSRabat.AsCurrency;
  FraDato := StrToDateTime (FormatDateTime ('dd-mm-yyyy', FraDato) + ' 00:00:00');
  TilDato := StrToDateTime (FormatDateTime ('dd-mm-yyyy', TilDato) + ' 23:59:59');
  IdxName := ffAfrEks.IndexName;
  AfrRes  := 1;
  NrkFil  := TStringList.Create;
  VgtFil  := TStringList.Create;
  LogFil  := TStringList.Create;
  DskFil  := TStringList.Create;
  AfrFil  := TStringList.Create;
  ErrFil  := TStringList.Create;
  OpgFil  := TStringList.Create;
  try
    try
//      InFilter           := ffInLst.Filter;
//      ffInLst.Filter     := '';
//      ffInLst.Filtered   := False;
      ffAfrEks.IndexName := 'DatoOrden';
      ffAfrEks.SetRange ([FraDato], [TilDato]);
//      ApoNr    := Copy (Trim (ffFirmaSpec1.AsString), 1, 3);
      ApoNr    := ffRcpOplApoteksNr.AsString;
      AfrMd    := FormatDateTime ('yymm', FraDato);
      UdDato   := Date;
      CntRecs  := 0;
      MaxRecs  := ffAfrEks.RecordCount;
      ErrTot1  := 0;
      ErrTot2  := 0;
      // Check for filial
      if cbFilial.Checked then begin
        ApoNr := Aponr2Filial (ApoNr);
        LogFil.Add ('Underafdeling ' + ApoNr);
      end else
        LogFil.Add ('Hovedafdeling ' + ApoNr);
      LogFil.Add ('Gennemløb af ' + IntToStr (MaxRecs) + ' recepter' + ' startes');
      ffAfrEks.First;
      while not ffAfrEks.Eof do begin
        if (ffAfrEksAfsluttetDato.AsDateTime >= FraDato) and
           (ffAfrEksAfsluttetDato.AsDateTime <= TilDato) and
           (ffAfrEksOrdreStatus.Value = 2)               then begin
          // Opdater meter
          Inc (CntRecs);
          if CntRecs mod 10 = 0 then begin
            gaMeter.Progress := (gaMeter.MaxValue * CntRecs) div MaxRecs;
            gaMeter.Update;
          end;
          // Gennemløb ordinationer
          ffAfrLin.Last;
          while not ffAfrLin.Bof do begin
            // Sygesikring
            AmtRegel := ffAfrTilRegelSyg.Value;
            if AmtRegel = 44 then
              AfrAmt (AmtRegel, Abs (ffAfrTilAndel.AsCurrency))
            else
            if Abs (ffAfrTilTilskSyg.AsCurrency) > 0 then begin
              if ffAfrEksAmt.Value in [1..99] then begin
                if AmtRegel = 0 then begin
                  // Check regel for terminal
                  if ffAfrEksCtrType.Value = 99 then
                    AmtRegel := 41;
                  // Check regel for vagtbrug
                  if ffAfrEksEkspType.Value in EkspTypVagt then
                    AmtRegel := 11;
                end;
                if AmtRegel > 0 then begin
                  // Amt ok
                  AfrAmt (AmtRegel, Abs (ffAfrTilTilskSyg.AsCurrency));
                end else begin
                  // Fejl amt regel
                  AfrFejl ('mangler amtsregel', 1,
                           Abs (ffAfrTilTilskSyg.AsCurrency));
                end;
              end else begin
                // Fejl amt instans
                AfrFejl ('mangler amtsinstans', 1,
                         Abs (ffAfrTilTilskSyg.AsCurrency));
              end;
            end else begin
              // Enten optjent CTR eller ikke tilskudsberettiget
              // - skal være enkeltpersoner og eksp.typer for samme
              if (ffAfrEksKundeType.Value in KundeTypEnk) then begin
                // Enkeltpersoner
                if AmtRegel in [41, 42, 43] then begin
                  // Tilskudsberettiget optjent CTR
                  AfrAmt (AmtRegel, 0);
                end else begin
                  // Ikke tilskudsberettiget
                  AfrAmt (99, Abs (ffAfrTilAndel.AsCurrency));
                end;
              end;
            end;
            // Kommune 1
            if Abs (ffAfrTilTilskKom1.AsCurrency) > 0 then begin
              if ffAfrEksKommune.Value > 99 then begin
                if ffAfrTilRegelKom1.Value > 0 then begin
                  // Kommune ok
                  AfrKommune (ffAfrTilRegelKom1.Value,
                              Abs (ffAfrTilTilskKom1.AsCurrency));
                end else begin
                  // Fejl kommune regel
                  AfrFejl ('mangler kommuneregel1', 2,
                           Abs (ffAfrTilTilskKom1.AsCurrency));
                end;
              end else begin
                // Fejl kommune instans
                AfrFejl ('mangler kommuneinstans1', 2,
                         Abs (ffAfrTilTilskKom1.AsCurrency));
              end;
            end;
            // Kommune 2
            if Abs (ffAfrTilTilskKom2.AsCurrency) > 0 then begin
              if ffAfrEksKommune.Value > 99 then begin
                if ffAfrTilRegelKom2.Value > 0 then begin
                  // Kommune ok
                  AfrKommune (ffAfrTilRegelKom2.Value,
                              Abs (ffAfrTilTilskKom2.AsCurrency));
                end else begin
                  // Fejl kommune regel
                  AfrFejl ('mangler kommuneregel2', 2,
                           Abs (ffAfrTilTilskKom2.AsCurrency));
                end;
              end else begin
                // Fejl kommune instans
                AfrFejl ('mangler kommuneinstans2', 2,
                         Abs (ffAfrTilTilskKom2.AsCurrency));
              end;
            end;
            // Næste linie
            ffAfrLin.Prior;
          end;
        end;
        ffAfrEks.Next;
      end;
      gaMeter.Progress := 100;
      Caption          := ' Recepter sorteres';
      Update;
      LogFil.Add ('Gennemløb af recepter afsluttes');
      if AfrFil.Count > 0 then begin
        LogFil.Add ('Der blev dannet ' + IntToStr (AfrFil.Count) + ' afregningsposter');
        LogFil.Add ('Der blev dannet ' + IntToStr (ErrFil.Count) + ' fejlposter');
        // Dan diskettefiler
        if DirectoryExists ('C:\C2\Afregning\Sygesikring\') then begin
          // Afregningsfilen sorteres på de første 21 bytes (måske mere)
          LogFil.Add ('Afregningsfilen sorteres');
          AfrFil.Sort;
          // Fjern første 21 bytes
          LogFil.Add ('Afregningsfilen trunceres for sorteringsdel');
          for CntRecs := 0 to AfrFil.Count - 1 do
            AfrFil.Strings [CntRecs] := Copy (AfrFil.Strings [CntRecs], 22, 80);
          // Dan disketter
          LogFil.Add ('Disketteantal m.m. beregnes');
          TotRecs := AfrFil.Count;
          if TotRecs <= MaxPoster then begin
            // En diskette
            TotDisk := 1;
            RstRecs := TotRecs;
          end else begin
            // Flere Disketter
            if TotRecs mod MaxPoster = 0 then begin
              TotDisk := TotRecs div MaxPoster;
              RstRecs :=             MaxPoster;
            end else begin
              TotDisk := (TotRecs div MaxPoster) + 1;
              RstRecs :=  TotRecs mod MaxPoster;
            end;
          end;
          LogFil.Add ('Antal poster i alt ' + IntToStr (TotRecs));
          LogFil.Add ('Antal disketter ' + IntToStr (TotDisk));
          LogFil.Add ('Antal poster sidste diskette ' + IntToStr (RstRecs));
          CntRecs := 0;
          for CntDisk := 1 to TotDisk do begin
            Caption := ' Diskette ' + IntToStr (CntDisk) + ' dannes';
            Update;
            LogFil.Add ('Dan ' + IntToStr (CntDisk) + '. diskettes indhold');
            DskFil.Clear;
            if CntDisk = TotDisk then
              AktRecs := RstRecs
            else
              AktRecs := MaxPoster;
            LogFil.Add (IntToStr (AktRecs) + ' poster til disketten');
            for SavRecs := 1 to AktRecs do begin
              AfrLin := AfrFil.Strings [CntRecs];
              DskFil.Add (AfrLin);
              Inc (CntRecs);
            end;
            // Dan Header
            AfrLin := '1' +
                      'MEDDP008' +
                      FormatDateTime ('yyyymmdd', UdDato) +
                      Word2Str (TotDisk, 2) +
                      Word2Str (CntDisk, 2) +
                      Long2Str (TotRecs, 5) +
                      Long2Str (AktRecs, 5);
            DskFil.Insert (0, AfrLin);
            LogFil.Add ('Header "' + AfrLin + '" til disketten');
            // Gem diskettefil på harddisk
            LogFil.Add ('Disketteindhold skrives til lokal harddisk');
            DskFil.SaveToFile ('C:\C2\Afregning\Sygesikring\Citosys.' + Word2Str (CntDisk, 3));
            // Gem diskettefil på diskette
            if cbDisks.Checked then begin
              ChkBoxOk ('Indsæt diskette ' + IntToStr (CntDisk) + ' i drev A:');
              Update;
              LogFil.Add ('Disketteindhold skrives til diskettedrev');
              try
                Screen.Cursor  := crHourGlass;
                DskFil.SaveToFile ('A:\Citosys.' + Word2Str (CntDisk, 3));
                Screen.Cursor  := crDefault;
                Caption := ' Diskette ' + IntToStr (CntDisk) + ' er klar';
                Update;
              except
                Screen.Cursor  := crDefault;
                LogFil.Add ('Fejl under overførsel til diskette');
                ChkBoxOK   ('Fejl under overførsel til diskette !');
              end;
            end;
            DskFil.Clear;
          end;
          // Opdater system
          try
            ffRcpOpl.Edit;
            ffRcpOplAfrPerSSSt.AsDateTime := Trunc (FraDato) + Frac (0.0);
            ffRcpOplAfrPerSSSl.AsDateTime := Trunc (TilDato) + Frac (0.0);
            ffRcpOplAfrDiskSS.Value       := TotDisk;
            ffRcpOplAfrPostSS.Value       := TotRecs;
            ffRcpOpl.Post;
          except
            if ffRcpOpl.State <> dsBrowse then
              ffRcpOpl.Cancel;
          end;
          AfrFil.Clear;
          Caption := ' Samleopgørelse dannes';
          Update;
          LogFil.Add ('Samleopgørelse dannes');
          // Dan samleopgørelse
          for CntInst := 1 to 99 do begin
            InstUd := False;
            for SamleLin := 1 to 8 do begin
              if SamleOpg [CntInst, SamleLin] <> 0 then begin
                // Evt. overskrift
                InstNvn := '';
                if not InstUd then begin
                  if ffInLst.FindKey ([CntInst]) then
                    InstNvn := ffInLstNavn.AsString
                  else
                    InstNvn := 'Ukendt amt';
                  InstNvn := InstNvn + Spaces (54 - Length (InstNvn));
                  InstUd  := True;
                  OpgFil.Add (Word2Str (CntInst, 3) + ' ' + InstNvn +
                    FormCurr2Str ('###,###,##0.00', SamleOpg [CntInst, 9]));
                  LogFil.Add (OpgFil.Strings [OpgFil.Count - 1]);
                end;
                // Refusion pr. regel
                case SamleLin of
                  1 : InstNvn := 'Vagtbrug, forbindsstoffer m.m.  ';
                  2 : InstNvn := 'Almindelig sygesikring          ';
                  3 : InstNvn := 'Bevillinger enkelt- og forhøjet ';
                  4 : InstNvn := 'Udligning i CTR                 ';
                  5 : InstNvn := 'Ernæringspræparater             ';
                  6 : InstNvn := 'Antikonception                  ';
                  7 : InstNvn := 'Uspecificeret tilskud           ';
                  8 : InstNvn := 'Andet (fejlagtigt regel)        ';
                end;
                OpgFil.Add ('    ' + InstNvn + Spaces (10) +
                  FormCurr2Str ('###,###,##0.00', SamleOpg [CntInst, SamleLin]));
                LogFil.Add (OpgFil.Strings [OpgFil.Count - 1]);
              end;
            end;
          end;
          LogFil.Add ('Samleopgørelse totaler dannes');
          // Total > 0
          if SamleOpg [100, 1] <> 0 then begin
            LogFil.Add ('Samleopgørelse rabat beregnes');
            if SamleOpg [101, 1] <> 0 then
              SamleOpg  [102, 1] := (SamleOpg [101, 1] * SSPct) / 100;
            SamleOpg  [103, 1] := SamleOpg [100, 1] - SamleOpg [102, 1];
            LogFil.Add ('Samleopgørelse totaler skrives');
            // Overskrift samleopgørelse
            OpgFil.Insert (0, '');
            OpgFil.Insert (0, '');
            OpgFil.Insert (0, 'Udskrevet for perioden' +
                              ' fra ' + FormatDateTime ('dd-mm-yyyy', FraDato) +
                              ' til ' + FormatDateTime ('dd-mm-yyyy', TilDato));
            OpgFil.Insert (0, ffFirmaNavn.AsString);
            OpgFil.Insert (0, 'S A M L E O P G Ø R E L S E');
            // Rest samleopgørelse
            OpgFil.Add (FixStr ('-', 72));
            OpgFil.Add ('I alt for alle amter          ' + Spaces (28) +
                        FormCurr2Str ('###,###,##0.00', SamleOpg [100, 1]));
            OpgFil.Add ('Rabatgrundlag                 ' + Spaces (28) +
                        FormCurr2Str ('###,###,##0.00', SamleOpg [101, 1]));
            OpgFil.Add ('- Beregnet rabat              ' + Spaces (28) +
                        FormCurr2Str ('###,###,##0.00', SamleOpg [102, 1]));
            OpgFil.Add (FixStr ('-', 72));
            OpgFil.Add ('Afregnet nettobeløb           ' + Spaces (28) +
                        FormCurr2Str ('###,###,##0.00', SamleOpg [103, 1]));
            OpgFil.Add (FixStr ('=', 72));
            OpgFil.Add ('');
            OpgFil.Add ('');
            LogFil.Add ('Samleopgørelse disketteinformation skrives');
            OpgFil.Add ('   Diskette 3 1/2" 1,44 Mb, diskfil(er) "Citosys.00n"');
            OpgFil.Add ('   Antal disketter .. ' + IntToStr (TotDisk));
            OpgFil.Add ('   Antal poster ..... ' + IntToStr (TotRecs));
            OpgFil.Add ('');
            OpgFil.Add ('');
            LogFil.Add ('Samleopgørelse apoteksinformation skrives');
            OpgFil.Add ('   Ydernr ........... ' + ffFirmaSpec2.AsString);
            OpgFil.Add ('   Gironr ........... ' + ffFirmaGiroNr.AsString);
            OpgFil.Add ('   Cvrnr. ........... ' + ffFirmaSeNr.AsString);
            OpgFil.Add ('');
            OpgFil.Add ('   ' + ffFirmaNavn.AsString);
            OpgFil.Add ('   ' + ffFirmaAdresse1.AsString);
            if ffFirmaAdresse2.AsString <> '' then
              OpgFil.Add ('   ' + ffFirmaAdresse2.AsString);
            OpgFil.Add ('   ' + ffFirmaPostNr.AsString + ' ' + ffFirmaByNavn.AsString);
            OpgFil.Add ('');
            OpgFil.Add ('');
            OpgFil.Add ('');
            OpgFil.Add ('');
            OpgFil.Add ('');
            OpgFil.Add ('');
            OpgFil.Add ('   .................................................');
            OpgFil.Add ('                     Apotekeren');
            OpgFil.Add ('');
          end;
          LogFil.Add ('Samleopgørelse skrives til disk');
          if OpgFil.Count > 0 then
            OpgFil.SaveToFile ('C:\C2\Afregning\Sygesikring\Citosys.Opg');
          OpgFil.Clear;
          Caption := ' Samleopgørelse udskrives';
          Update;
          MatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Sygesikring\Citosys.Opg');
          if ChkBoxYesNo ('Udskriv ekstra kopi af samleopgørelse ?') then
            MatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Sygesikring\Citosys.Opg');
        end else
          ErrFil.Add ('Mangler directory C:\C2\Afregning\Sygesikring\');
      end;
      // Check narkospecifikation
      if NrkFil.Count > 0 then begin
        NrkFil.Sort;
        NrkFil.Insert (0, '');
        NrkFil.Insert (0, 'Eksp.nr     Ord  Varenr Antal  Lbnr/' +
                          'Cprnr   Ydernr      Dato       Cprnr');
        NrkFil.Insert (0, 'Udskrevet for perioden' +
                          ' fra ' + FormatDateTime ('dd-mm-yyyy', FraDato) +
                          ' til ' + FormatDateTime ('dd-mm-yyyy', TilDato));
        NrkFil.Insert (0, ffFirmaNavn.AsString);
        NrkFil.Insert (0, 'N A R K O - S P E C I F I K A T I O N');
        LogFil.Add ('Narko-specifikation gemmes/udskrives på printer');
        NrkFil.SaveToFile ('C:\C2\Afregning\Sygesikring\Citosys.Nrk');
        NrkFil.Clear;
        Caption := ' Narko-specifikation udskrives';
        Update;
        MatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Sygesikring\Citosys.Nrk');
        if ChkBoxYesNo ('Udskriv ekstra kopi af narko-specifikation ?') then
          MatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Sygesikring\Citosys.Nrk');
      end;
      // Check vagtspecifikation
      if VgtFil.Count > 0 then begin
        VgtFil.Sort;
        VgtFil.Insert (0, '');
        VgtFil.Insert (0, 'Eksp.nr      Regel        Ydernr    ' +
                          '    Varenr    Antal         Refusion');
        VgtFil.Insert (0, 'Udskrevet for perioden' +
                          ' fra ' + FormatDateTime ('dd-mm-yyyy', FraDato) +
                          ' til ' + FormatDateTime ('dd-mm-yyyy', TilDato));
        VgtFil.Insert (0, ffFirmaNavn.AsString);
        VgtFil.Insert (0, 'V A G T - S P E C I F I K A T I O N');
        LogFil.Add ('Vagt-specifikation gemmes/udskrives på printer');
        VgtFil.SaveToFile ('C:\C2\Afregning\Sygesikring\Citosys.Vgt');
        VgtFil.Clear;
        Caption := ' Vagt-specifikation udskrives';
        Update;
        MatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Sygesikring\Citosys.Vgt');
        if ChkBoxYesNo ('Udskriv ekstra kopi af vagt-specifikation ?') then
          MatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Sygesikring\Citosys.Vgt');
      end;
      if ErrFil.Count > 0 then begin
        ErrFil.Insert (0, '');
        ErrFil.Insert (0, '');
        ErrFil.Insert (0, 'Udskrevet for perioden' +
                          ' fra ' + FormatDateTime ('dd-mm-yyyy', FraDato) +
                          ' til ' + FormatDateTime ('dd-mm-yyyy', TilDato));
        ErrFil.Insert (0, ffFirmaNavn.AsString);
        ErrFil.Insert (0, 'F E J L L I S T E   S Y G E S I K R I N G');
        ErrFil.Add ('Fejlbeløb amter ... ' + FormatCurr ('###,###,##0.00', ErrTot1));
        ErrFil.Add ('Fejlbeløb andet ... ' + FormatCurr ('###,###,##0.00', ErrTot2));
        ErrFil.Add (FixStr ('=', 72));
        LogFil.Add ('Fejlliste gemmes/udskrives på printer');
        ErrFil.SaveToFile ('C:\C2\Afregning\Sygesikring\Citosys.Err');
        ErrFil.Clear;
        Caption := ' Fejlliste udskrives';
        Update;
        MatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Sygesikring\Citosys.Err');
      end;
      LogFil.Insert (0, '');
      LogFil.Insert (0, '');
      LogFil.Insert (0, 'Udskrevet for perioden' +
                        ' fra ' + FormatDateTime ('dd-mm-yyyy', FraDato) +
                        ' til ' + FormatDateTime ('dd-mm-yyyy', TilDato));
      LogFil.Insert (0, ffFirmaNavn.AsString);
      LogFil.Insert (0, 'L O G U D S K R I F T   S Y G E S I K R I N G');
      LogFil.Add    ('Afregning er afsluttet');
      Caption := ' Afregning er afsluttet';
      Update;
      AfrRes := 0;
    except
      AfrRes := 2;
    end;
  finally
    try
      LogFil.SaveToFile ('C:\C2\Afregning\Sygesikring\Citosys.Log');
      LogFil.Clear;
      // Exception
      if AfrRes <> 0 then begin
        if ChkBoxYesNo ('Uventet fejl under afregning, udskriv logfil !') then
          MatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Sygesikring\Citosys.Log');
      end;
    except
    end;
    NrkFil.Free;
    VgtFil.Free;
    LogFil.Free;
    AfrFil.Free;
    DskFil.Free;
    ErrFil.Free;
    OpgFil.Free;
    NrkFil := NIL;
    VgtFil := NIL;
    LogFil := NIL;
    AfrFil := NIL;
    DskFil := NIL;
    ErrFil := NIL;
    OpgFil := NIL;
    ffAfrEks.CancelRange;
    ffAfrEks.IndexName := IdxName;
//    ffInLst.Filter     := InFilter;
//    ffInLst.Filtered   := True;
  end;
end; end;

procedure TOpdAfrForm.butDisketterClick(Sender: TObject);
var
  DskFil : TStringList;
  DskNvn : String;
  DskNr  : LongWord;
begin
  DskNr := 1;
  if TastHeltal ('Vælg diskettenr', DskNr) then begin
    DskNvn := 'C:\C2\Afregning\Sygesikring\Citosys.' + Word2Str (DskNr, 3);
    if FileExists (DskNvn) then begin
      DskFil := TStringList.Create;
      try
        DskFil.LoadFromFile (DskNvn);
        try
          Caption := ' Diskette ' + IntToStr (DskNr) + ' dannes';
          Update;
          Screen.Cursor := crHourGlass;
          DskFil.SaveToFile ('A:\Citosys.' + Word2Str (DskNr, 3));
          Screen.Cursor := crDefault;
          Caption := ' Diskette ' + IntToStr (DskNr) + ' er klar';
          Update;
        except
          Screen.Cursor := crDefault;
          ChkBoxOK ('Fejl under overførsel til diskette !');
        end;
      finally
        DskFil.Free;
        DskFil := NIL;
      end;
    end;
  end;
end;

procedure TOpdAfrForm.butUdskrivClick(Sender: TObject);
var
  P : TPoint;
begin
  P.X := butUdskriv.Left + 50;
  P.Y := butUdskriv.Top  + 200 + butUdskriv.Height;
  P   := ClientToScreen (P);
  meUd.Popup (P.X, P.Y);
end;

procedure TOpdAfrForm.meUdOpgClick(Sender: TObject);
begin
  if FileExists ('C:\C2\Afregning\Sygesikring\Citosys.Opg') then begin
    PNr := cbPNr.ItemIndex + 1;
    Caption := ' Samleopgørelse udskrives';
    Update;
    MatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Sygesikring\Citosys.Opg');
    Caption := ' Samleopgørelse er udskrevet';
    Update;
  end else
    ChkBoxOK ('Der findes ikke en tidligere afregning');
end;

procedure TOpdAfrForm.meUdVagtClick(Sender: TObject);
begin
  if FileExists ('C:\C2\Afregning\Sygesikring\Citosys.Vgt') then begin
    PNr := cbPNr.ItemIndex + 1;
    Caption := ' Vagtspecifikation udskrives';
    Update;
    MatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Sygesikring\Citosys.Vgt');
    Caption := ' Vagtspecifikation er udskrevet';
    Update;
  end else
    ChkBoxOK ('Der findes ikke en tidligere vagtspecifikation');
end;

procedure TOpdAfrForm.meUdNarkoClick(Sender: TObject);
begin
  if FileExists ('C:\C2\Afregning\Sygesikring\Citosys.Nrk') then begin
    PNr := cbPNr.ItemIndex + 1;
    Caption := ' Narkospecifikation udskrives';
    Update;
    MatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Sygesikring\Citosys.Nrk');
    Caption := ' Narkospecifikation er udskrevet';
    Update;
  end else
    ChkBoxOK ('Der findes ikke en tidligere narkospecifikation');
end;

procedure TOpdAfrForm.meUdFejlClick(Sender: TObject);
begin
  if FileExists ('C:\C2\Afregning\Sygesikring\Citosys.Err') then begin
    PNr := cbPNr.ItemIndex + 1;
    Caption := ' Fejlliste udskrives';
    Update;
    MatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Sygesikring\Citosys.Err');
    Caption := ' Fejlliste er udskrevet';
    Update;
  end else
    ChkBoxOK ('Der findes ikke en tidligere fejlliste');
end;

procedure TOpdAfrForm.butEtikClick(Sender: TObject);
var
  I, J : LongWord;
  S    : TStringList;
begin with MainDm do begin
  I := ffRcpOplAfrDiskSS.Value;
  if I = 0 then
    I := 1;
  if TastHeltal ('Vælg disketteantal', I) then begin
    if I in [1..9] then begin
      S := TStringList.Create;
      try
        J := I;
        repeat
          S.Clear;
          S.Add ('Apoteksnr ' + Copy (Trim (ffFirmaSpec1.AsString), 1, 5));
          S.Add ('Sygesikringsafregning');
          S.Add ('Diskette ' + IntToStr (J) + ' af ' + IntToStr (I));
          S.Add ('Periode :');
          S.Add ('   '   + FormatDateTime ('dd-mm-yyyy',
                           ffRcpOplAfrPerSSSt.AsDateTime) +
                 ' til ' + FormatDateTime ('dd-mm-yyyy',
                           ffRcpOplAfrPerSSSl.AsDateTime));
          UbiPrinterForm.PrintFriEtik (
            ffFirmaSupNavn.AsString,
            FormatDateTime ('dd-mm-yy', Date), S, 1, True);
            {
            'Apoteksnr ' + Copy (Trim (ffFirmaSpec1.AsString), 1, 5),
            'Sygesikringsafregning',
            'Diskette ' + IntToStr (J) + ' af ' + IntToStr (I),
            'Periode :',
            '   ' +
            FormatDateTime ('dd-mm-yyyy', ffRcpOplAfrPerSSSt.AsDateTime) +
            ' til ' +
            FormatDateTime ('dd-mm-yyyy', ffRcpOplAfrPerSSSl.AsDateTime));
}
          Dec (J);
        until J = 0;
//        UbiPrinterForm.UbiFeed;
      finally
        S.Free;
        S := NIL;
      end;
    end;
  end;
end; end;

end.
