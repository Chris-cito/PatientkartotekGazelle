unit KommuneAfregning;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Gauges, StdCtrls, Buttons, ComCtrls, DB, Menus;

type
  TKommuneForm = class(TForm)
    gbDatoer: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    eFra: TDateTimePicker;
    eTil: TDateTimePicker;
    gbKommuner: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    eFraIn: TEdit;
    eTilIn: TEdit;
    gbPrinter: TGroupBox;
    gbDebitor: TGroupBox;
    cbDeb: TCheckBox;
    meUd: TPopupMenu;
    meUdRegn: TMenuItem;
    meUdFejl: TMenuItem;
    paGentag: TPanel;
    gaMeter: TGauge;
    cbPNr: TComboBox;
    meUdOpg: TMenuItem;
    butAfregn: TBitBtn;
    butDisketter: TBitBtn;
    butEtik: TBitBtn;
    butUdskriv: TBitBtn;
    gbFormat: TGroupBox;
    cbSidCpr: TCheckBox;
    cbSidRegel: TCheckBox;
    Label3: TLabel;
    edtRegel: TEdit;
    procedure DanEkspeditioner;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure butAfregnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure butUdskrivClick(Sender: TObject);
    procedure meUdAfrClick(Sender: TObject);
    procedure meUdFejlClick(Sender: TObject);
    procedure meUdOpgClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FraKom,
    TilKom,
    PNr,
    AfrRes  : Word;
    FraDato,
    TilDato : TDateTime;
  end;

  function KommuneUdskrift : Boolean;

var
  KommuneForm: TKommuneForm;

implementation

uses

  ChkBoxes,

  C2Date,
  C2Procs,

  DM, C2MainLog, PatMatrixPrinter;

{$R *.DFM}

function KommuneUdskrift : Boolean;
begin
  KommuneForm := TKommuneForm.Create (NIL);
  try
    SidsteDatoer (KommuneForm.FraDato, KommuneForm.TilDato);
    KommuneForm.Caption           := 'Kommuneafregning';
    KommuneForm.eFra.DateTime     := KommuneForm.FraDato;
    KommuneForm.eTil.DateTime     := KommuneForm.TilDato;
    KommuneForm.eFraIn.Text       := '100';
    KommuneForm.eTilIn.Text       := '999';
    KommuneForm.cbPNr.ItemIndex   := 0;
    KommuneForm.ShowModal;
  finally
    Result := KommuneForm.AfrRes = 0;
    KommuneForm.Free;
    KommuneForm := NIL;
  end;
end;

procedure TKommuneForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    SelectNext (ActiveControl, TRUE, TRUE);
    Key := #0;
  end;
  if Key = #27 then
  begin
    Key := #0;
    ModalResult := mrCancel;
  end;
end;

procedure TKommuneForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F6 then
  begin
    ButAfregn.Click;
    Key := 0;
  end;
end;

procedure TKommuneForm.butAfregnClick(Sender: TObject);
begin
  FraDato := eFra.Date;
  TilDato := eTil.Date;
  FraKom  := 100;
  TilKom  := 999;
  try
    FraKom := StrToInt (eFraIn.Text);
    TilKom := StrToInt (eTilIn.Text);
  except
  end;
  PNr := cbPNr.ItemIndex + 1;
  if Trunc (TilDato) >= Trunc (FraDato) then
    DanEkspeditioner
  else
    ChkBoxOk ('Fejl i afregningsdatoer !');
end;

procedure TKommuneForm.butUdskrivClick(Sender: TObject);
var
  P : TPoint;
begin
  P.X := butUdskriv.Left + 50;
  P.Y := butUdskriv.Top  + 200 + butUdskriv.Height;
  P   := ClientToScreen (P);
  meUd.Popup (P.X, P.Y);
end;

procedure TKommuneForm.meUdAfrClick(Sender: TObject);
begin
  if not FileExists ('C:\C2\Afregning\Kommuner\Citosys.Lst') then
  begin
    ChkBoxOK ('Der findes ikke en tidligere afregning');
    exit;
  end;
  PNr := cbPNr.ItemIndex + 1;
  Caption := ' Afregningsliste udskrives';
  Update;
  PatMatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Kommuner\Citosys.Lst');
  Caption := ' Afregningsliste er udskrevet';
  Update;
end;

procedure TKommuneForm.meUdOpgClick(Sender: TObject);
begin
  if not FileExists ('C:\C2\Afregning\Kommuner\Citosys.Opg') then
  begin
    ChkBoxOK ('Der findes ikke en tidligere afregning');
    exit;
  end;
  PNr := cbPNr.ItemIndex + 1;
  Caption := ' Samleopgørelse udskrives';
  Update;
  PatMatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Kommuner\Citosys.Opg');
  Caption := ' Samleopgørelse er udskrevet';
  Update;
end;

procedure TKommuneForm.meUdFejlClick(Sender: TObject);
begin
  if not FileExists ('C:\C2\Afregning\Kommuner\Citosys.Err') then
  begin
    ChkBoxOK ('Der findes ikke en tidligere fejlliste');
    exit;
  end;
  PNr := cbPNr.ItemIndex + 1;
  Caption := ' Fejlliste udskrives';
  Update;
  PatMatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Kommuner\Citosys.Err');
  Caption := ' Fejlliste er udskrevet';
  Update;
end;

procedure TKommuneForm.DanEkspeditioner;
const
  MaxPoster = 16300;
var
  LstFil,
  LogFil,
  ErrFil,
  OpgFil,
  DskFil,
  KomFil,
  AfrFil    : TStringList;
  UdDato    : TDateTime;
  Betaling,
  ApoNr,
  AfrMd,
  KomLin,
  AfrLin,
//  InFilter,
  IdxLag,
  IdxAfr    : String;
  RefTot,
  ErrTot    : Currency;
  SavRecs,
  AktRecs,
  RstRecs,
  CntDisk,
  TotDisk   : Word;
  TotRecs,
  CntRecs,
  MaxRecs   : integer;

  procedure AfrFejl (Tekst : String; Refusion : Currency);
  begin
    with MainDm do
    begin
      Tekst := 'Eksp.nr. ' + IntToStr (ffAfrEksLbNr.Value) + ', ' +
               'cprnr. ' + ffAfrEksKundeNr.AsString + ', ' +
               Tekst + ', beløb ' +
               FormatCurr ('###,###,##0.00', Refusion);
      ErrFil.Add (Tekst);
      ErrTot := ErrTot + Refusion;
    end;
  end;
  procedure AfrKommune (Kommune, Regel : Word; Refusion : Currency; JNr, Afd : String);
  var
    LbNr     : LongInt;
    Antal,
    LinieNr  : Word;
    Fortegn,
    Korr,
    SLbNr,
    Dato,
    SAntal,
    Vare,
    Navn,
    YderNr,
    YderNavn,
    CprNr    : String;
    iregel : integer;
  begin
    with MainDm do
    begin
      if edtRegel.Text <> '' then
      begin
        try
          iregel := strtoint(edtRegel.Text);
        except
          exit;
        end;
        c2logadd( ' iregel is ' + inttostr(iregel));
        c2logadd( ' Regel is ' + inttostr(Regel));
        if iregel <> Regel then
          exit;
      end;
      // Tilbageførsel eller normal
      if Refusion <= 0 then
        exit;
      if edtRegel.Text <> '' then
      begin
        try
          iregel := strtoint(edtRegel.Text);
        except
          exit;
        end;
        c2logadd( ' iregel is ' + inttostr(iregel));
        c2logadd( ' Regel is ' + inttostr(Regel));
        if iregel <> Regel then
          exit;
      end;
      if (Kommune >= 100) and (Kommune <= 999) then
      begin
        if Regel in [61..79] then
        begin
          // Salg/Retur
          Fortegn := '0';
          Korr    := '0';
          if ffAfrEksOrdreType.Value = 2 then
          begin
            // Retur
            Refusion := -Refusion;
            Fortegn  := '-';
            Korr     := '1';
          end;
          LbNr := ffAfrEksLbNr.Value mod 1000000;
          SLbNr := Format('%7d',[Lbnr]);
          LinieNr := ffAfrLinLinieNr.Value;
          // Hvis antal pakninger er 0
          Antal := 1;
          if Abs (ffAfrLinAntal.Value) > 1 then
            Antal := Abs (ffAfrLinAntal.Value);
          SAntal := Format('%2d',[Antal]);
          if Trim (ffAfrLinSubVareNr.AsString) <> '' then
            Vare := Trim (ffAfrLinSubVareNr.AsString)
          else
            Vare := Trim (ffAfrLinVareNr.AsString);
          if ffAfrLinUdLevType.AsString = 'HF' then
          begin
            if ffLagKar.FindKey([ffAfrEksLager.AsInteger, Vare]) then
              Vare := Vare + ' ' + Trim(ffLagKarNavn.AsString) + ' '
                                 + Trim(ffAfrLinPakning.AsString) + ' '
                                 + Trim(ffAfrLinStyrke.AsString)
            else
              Vare := Vare + ' ' + Trim(ffAfrLinTekst.AsString) + ' '
                                 + Trim(ffAfrLinPakning.AsString);
          end
          else
          begin
            Vare := Vare + ' ' + Trim(ffAfrLinTekst.AsString) + ' '
                               + Trim(ffAfrLinPakning.AsString);
          end;
          if Length (Vare) > 57 then
            Vare := Copy (Vare, 1, 57);
          Vare := Vare + Spaces (57 - Length (Vare));
          if Length (Trim (ffAfrEksYderNr.AsString)) = 7 then
          begin
            YderNr   := Trim (ffAfrEksYderNr.AsString);
            YderNavn := Trim (ffAfrEksYderNavn.AsString);
          end
          else
          begin
            YderNr   := '0990027';
            YderNavn := 'Ukendt ydernr';
          end;
          if Length (YderNavn) > 20 then
            YderNavn := Copy (YderNavn, 1, 20);
          YderNavn := YderNavn + Spaces (20 - Length (YderNavn));
          if ffAfrEksCprCheck.AsBoolean then
            CprNr := Trim (ffAfrEksKundeNr.AsString)
          else
            CprNr := '4000000995';
          Navn := BytNavn (ffAfrEksNavn.AsString);
          Navn := Navn + Spaces (30 - Length (Navn));
          JNr  := Trim (JNr);
          JNr  := JNr + Spaces (20 - Length (JNr));
          Afd  := Trim (Afd);
          Afd  := Afd + Spaces (30 - Length (Afd));
          Dato := FormatDateTime ('dd-mm-yyyy', ffAfrEksAfsluttetDato.Value);
          // Afregningslinie til liste
          KomLin := Word2Str (Kommune, 3)                 +
                    Afd                                   +
                    Word2Str (Regel, 2)                   +
                    CprNr                                 +
                    Long2Str (LbNr, 7)                    +
                    Word2Str (LinieNr, 2)                 +
                    Navn                                  +
                    JNr                                   +
                    ' '                                   +
                    Dato                                  +
                    ' '                                   +
                    SLbNr                                 +
                    ' '                                   +
                    YderNr                                +
                    ' '                                   +
                    YderNavn                              +
                    ' '                                   +
                    Vare                                  +
                    ' '                                   +
                    SAntal                                +
                    ' '                                   +
                    FormCurr2Str ('#####00.00', Refusion);
          if Length (KomLin) = 224 then
          begin
              // Linie OK
              KomFil.Add (KomLin);
              RefTot := RefTot + Refusion;
          end
          else
          begin
            // Linie med fejl
            AfrFejl ('fejl i data liste', Refusion);
          end;
        end;
      end;
    end;
  end;

  procedure AfrListe;
  var
    InsLst,
    KomLst   : TStringList;
    LstStr,
    WrkStr,
    KomOvr,
    AfdOvr,
    RegelOvr,
    CprOvr,
    GlKom,
    GlAfd,
    GlRegel,
    GlCpr,
    NyKom,
    NyAfd,
    NyRegel,
    NyCpr    : String;
    Ref,
    GrandTot,
    KomTot,
    AfdTot,
    RegelTot,
    CprTot   : Currency;
    I        : Integer;

    procedure BogInstans (Kom, Reg : String; Bel : Currency);
    begin
      with MainDm do
      begin
        LstFil.Add ('');
        LstFil.Add ('   Afregnes til :');
        LstFil.Add ('');
        LstFil.Add ('   ' + ffFirmaNavn.AsString);
        LstFil.Add ('   ' + ffFirmaAdresse1.AsString);
        if ffFirmaAdresse2.AsString <> '' then
          LstFil.Add ('   ' + ffFirmaAdresse2.AsString);
        LstFil.Add ('   ' + ffFirmaPostNr.AsString + ' ' + ffFirmaByNavn.AsString);
        LstFil.Add ('');
        LstFil.Add ('   Ydernr ........... ' + ffFirmaSpec2.AsString);
        LstFil.Add ('   CVR-nr ........... ' + ffFirmaSeNr.AsString);
        LstFil.Add ('');
        if ffFirmaGiroNr.AsString <> '' then
          LstFil.Add ('   Gironr ........... ' + ffFirmaGiroNr.AsString);
        if ffFirmaBankRegNr1.AsString <> '' then begin
          LstFil.Add ('   Bankregnr ........ ' + ffFirmaBankRegNr1.AsString);
          LstFil.Add ('   Bankkontonr ...... ' + ffFirmaBankKontoNr1.AsString);
        end;
        LstFil.Add ('[FORMFEED]');
        GlCpr := '';
      end;
    end;

    procedure AfdOverskrift;
    begin
      // Navn
      AfdOvr := NyAfd;
      if AfdOvr <> '' then begin
        LstFil.Add ('');
        LstFil.Add (AfdOvr);
      end;
      GlAfd := NyAfd;
    end;

    procedure RegelOverskrift;
    begin
      with MainDm do
      begin
        // Regel + Navn
        if ffReLst.FindKey ([StrToInt (NyRegel)]) then
          // Navn
          RegelOvr := ffReLstNavn.AsString
        else
          RegelOvr := NyRegel + ', regel findes ikke';
  //      if cbSidCpr.Checked then
  //        LstFil.Add ('[FORMFEED]')
  //      else
        LstFil.Add ('');
        LstFil.Add (RegelOvr);
        GlRegel := NyRegel;
      end;
    end;

    procedure KomOverskrift;
    begin
      with MainDm do
      begin
  //      InsLst.Clear;
        // Kommune + Navn
        if ffInLst.FindKey ([StrToInt (NyKom)]) then
          // Navn
          KomOvr := NyKom + ' ' + ffInLstNavn.AsString
        else
          KomOvr := NyKom + ' ' + 'kommune findes ikke';
        LstFil.Add (KomOvr);
        GlKom := NyKom;
      end;
    end;

    procedure CprOverskrift;
    begin
      // Cprnr + Navn + Journalnr
      CprOvr := NyCpr + ' ' + Trim (Copy (WrkStr, 55, 30));
      if GlCpr <> '' then
      begin
        if (NyRegel <> '75') and (NyRegel <>'76') then
          if cbSidCpr.Checked then
            LstFil.Add ('[FORMFEED]');

      end
      else
        LstFil.Add ('');

      KomOverskrift;
      AfdOverskrift;
      RegelOverskrift;
      LstFil.Add ('[SECTION-ON]');
      LstFil.Add (CprOvr);
      if Trim (Copy (WrkStr, 85, 20)) <> '' then
        LstFil.Add ('Journalnr ' + Trim (Copy (WrkStr, 85, 20)));
      if cbPNr.ItemIndex = 5 then
        LstFil.Add ('[COND-ON]' +
                    'Dato   Eksp.nr  Ydernr Lægens navn' +
                    Spaces (10) +
                    'Vare og beskrivelse' +
                    Spaces (33) +
                    'Ant Refusion' +
                    '[COND-OFF]')
      else
        LstFil.Add ('[COND-ON]' +
                    'Dato       Eksp.nr  Ydernr Lægens navn' +
                    Spaces (10) +
                    'Vare og beskrivelse' +
                    Spaces (36) +
                    'Antal       Refusion' +
                    '[COND-OFF]');
      GlCpr := NyCpr;
    end;


    procedure GrandTotal;
    begin
      LstFil.Add ('');
      LstFil.Add ('');
      LstFil.Add ('Alle kommuner');
      LstFil.Add ('');
      LstFil.AddStrings (KomLst);
      LstFil.Add (FixStr ('-', 72));
      LstFil.Add ('Alle kommuner i alt ' +
                  Spaces (38) +
                  FormCurr2Str ('###,###,#00.00', GrandTot));
      LstFil.Add (FixStr ('=', 72));
      GrandTot := 0;
    end;

    procedure KomTotal;
    begin
      with MainDm do
      begin
        LstFil.Add ('');
        LstFil.Add ('');
        LstFil.Add (KomOvr);
        LstFil.Add ('');
        LstFil.AddStrings (InsLst);
        LstFil.Add (FixStr ('-', 72));
        KomOvr := KomOvr + ' i alt';
        KomOvr := KomOvr + Spaces (58 - Length (KomOvr)) +
                  FormCurr2Str ('###,###,#00.00', KomTot);
        LstFil.Add (KomOvr);
        LstFil.Add (FixStr ('=', 72));
        KomLst.Add (KomOvr);
        BogInstans (GlKom, GlRegel, KomTot);
        InsLst.Clear;
        KomTot := 0;
      end;
    end;

    procedure AfdTotal;
    begin
      if AfdOvr <> '' then
      begin
        AfdOvr := AfdOvr + ' i alt';
        AfdOvr := AfdOvr + Spaces (58 - Length (AfdOvr)) +
                    FormCurr2Str ('###,###,#00.00', AfdTot);
        AfdTot := 0;
        LstFil.Add ('');
        LstFil.Add ('');
        LstFil.Add (AfdOvr);
        LstFil.Add (FixStr ('=', 72));
        BogInstans (GlAfd, GlAfd, AfdTot);
      end;
    end;

    procedure RegelTotal;
    begin
      RegelOvr := RegelOvr + ' i alt';
      RegelOvr := RegelOvr + Spaces (58 - Length (RegelOvr)) +
                  FormCurr2Str ('###,###,#00.00', RegelTot);
      RegelTot := 0;
      InsLst.Add (RegelOvr);
      LstFil.Add ('');
      LstFil.Add ('');
      LstFil.Add (RegelOvr);
      LstFil.Add (FixStr ('=', 72));
      BogInstans (GlKom, GlRegel, RegelTot);
    end;

    procedure CprTotal;
    begin
      CprOvr := CprOvr + ' i alt';
      CprOvr := CprOvr + Spaces (58 - Length (CprOvr)) +
                FormCurr2Str ('###,###,#00.00', CprTot);
      CprTot := 0;
      LstFil.Add (FixStr ('-', 72));
      LstFil.Add (CprOvr);
      LstFil.Add (FixStr ('=', 72));
      LstFil.Add ('[SECTION-OFF]');
    end;

  begin
    with MainDm do
    begin
      InsLst := TStringList.Create;
      KomLst := TStringList.Create;
      try
        LstFil.Clear;
        KomOvr   := '';
        AfdOvr   := '';
        RegelOvr := '';
        CprOvr   := '';
        GlKom    := '';
        GlAfd    := '';
        GlRegel  := '';
        GlCpr    := '';
        KomTot   := 0;
        AfdTot   := 0;
        RegelTot := 0;
        CprTot   := 0;
        for I := 0 to KomFil.Count - 1 do
        begin
          WrkStr  := KomFil.Strings [I];
          NyKom   := Trim (Copy (WrkStr,  1,  3));
          NyAfd   := Trim (Copy (WrkStr,  4, 30));
          NyRegel := Trim (Copy (WrkStr, 34,  2));
          NyCpr   := Trim (Copy (WrkStr, 36, 10));
          Ref     := StrToCurr (Trim (Copy (WrkStr, 215, 10)));
          if NyKom <> GlKom then
          begin
            if GlCpr <> '' then
              CprTotal;
            if GlRegel <> '' then
              RegelTotal;
            if GlAfd <> '' then
              AfdTotal;
            if GlKom <> '' then
              KomTotal;
  //          KomOverskrift;
  //          AfdOverskrift;
  //          RegelOverskrift;
            CprOverskrift;
          end
          else
          begin
            if NyAfd <> GlAfd then
            begin
              if GlCpr <> '' then
                CprTotal;
              if GlRegel <> '' then
                RegelTotal;
              AfdTotal;
  //            AfdOverskrift;
  //            RegelOverskrift;
              CprOverskrift;
            end
            else
            begin
              if NyRegel <> GlRegel then
              begin
                if GlCpr <> '' then
                  CprTotal;
                RegelTotal;
  //              RegelOverskrift;
                CprOverskrift;
              end
              else
              begin
                if GlCpr <> NyCpr then
                begin
                  if GlCpr <> '' then
                    CprTotal;
                  CprOverskrift;
                end;
              end;
            end;
          end;
          KomTot   := KomTot   + Ref;
          AfdTot   := AfdTot   + Ref;
          RegelTot := RegelTot + Ref;
          CprTot   := CprTot   + Ref;
          GrandTot := GrandTot + Ref;
          // Sortdel (105 kar) fratrækkes + beløb (10 kar) da det formateres alene
          if cbPNr.ItemIndex = 5 then
          begin
            // Laser
            LstStr:= Copy(WrkStr, 106, Length(WrkStr) - 104);
            Delete(LstStr, 109, 2);
            Delete(LstStr, 102, 5);
            Delete(LstStr,   6, 3);
            Delete(LstStr,   3, 1);
            LstFil.Add ('[COND-ON]' + LstStr + '[COND-OFF]');
          end
          else
          begin
            // Matrix m.m.
            LstFil.Add ('[COND-ON]' +
                        Copy (WrkStr, 106, Length (WrkStr) - (105 + 10)) +
                        FormCurr2Str ('###,###,#00.00', Ref) +
                        '[COND-OFF]');
          end;
        end;
        CprTotal;
        RegelTotal;
        AfdTotal;
        KomTotal;
        GrandTotal;
      finally
        InsLst.Free;
        KomLst.Free;
      end;
    end;
  end;

begin
  with MainDm do
  begin
    FraDato:= StrToDateTime(FormatDateTime('dd-mm-yyyy', FraDato) + ' 00:00:00');
    TilDato:= StrToDateTime(FormatDateTime('dd-mm-yyyy', TilDato) + ' 23:59:59');
    IdxAfr := ffAfrEks.IndexName;
    IdxLag := ffLagKar.IndexName;
    AfrRes := 1;
    LstFil := TStringList.Create;
    LogFil := TStringList.Create;
    AfrFil := TStringList.Create;
    KomFil := TStringList.Create;
    ErrFil := TStringList.Create;
    DskFil := TStringList.Create;
    OpgFil := TStringList.Create;
    try
      try
  //      InFilter           := ffInLst.Filter;
  //      ffInLst.Filter     := '';
  //      ffInLst.Filtered   := False;
        ffLagKar.IndexName:= 'NrOrden';
        ffAfrEks.IndexName:= 'DatoOrden';
        ffAfrEks.SetRange([FraDato], [TilDato]);
        Betaling := '4';
        ApoNr    := Copy(Trim (ffFirmaSpec1.AsString), 1, 5);
        AfrMd    := FormatDateTime('yyyymm', FraDato);
        UdDato   := Date;
        TotDisk  := 0;
        TotRecs  := 0;
        CntRecs  := 0;
        MaxRecs  := ffAfrEks.RecordCount;
        ErrTot   := 0;
        LogFil.Add ('Gennemløb af ' + IntToStr (MaxRecs) + ' recepter' + ' startes');
        ffAfrEks.First;
        while not ffAfrEks.Eof do
        begin
          // Opdater meter
          Inc (CntRecs);
          if CntRecs mod 10 = 0 then
          begin
            gaMeter.Progress := (gaMeter.MaxValue * CntRecs) div MaxRecs;
            gaMeter.Update;
          end;
          if (ffAfrEksAfsluttetDato.AsDateTime >= FraDato) and
             (ffAfrEksAfsluttetDato.AsDateTime <= TilDato) and
             (ffAfrEksKommune.Value            >= FraKom)  and
             (ffAfrEksKommune.Value            <= TilKom)  and
             (ffAfrEksOrdreStatus.Value = 2)               then
          begin
            // Gennemløb ordinationer
            C2LogAdd('lbnr is ' + ffAfrEksLbNr.AsString);
            ffAfrLin.Last;
            while not ffAfrLin.Bof do
            begin
              // Kommune 1 og 2
              AfrKommune (ffAfrEksKommune.AsInteger,
                          ffAfrTilRegelKom1.AsInteger,
                          Abs (ffAfrTilTilskKom1.AsCurrency),
                          ffAfrTilJournalNr1.AsString,
                          ffAfrTilAfdeling1.AsString);
              AfrKommune (ffAfrEksKommune.AsInteger,
                          ffAfrTilRegelKom2.AsInteger,
                          Abs (ffAfrTilTilskKom2.AsCurrency),
                          ffAfrTilJournalNr2.AsString,
                          ffAfrTilAfdeling2.AsString);
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
        // Antal poster
        LogFil.Add ('Der blev dannet ' + IntToStr (KomFil.Count) + ' afregningsposter liste');
        LogFil.Add ('Der blev dannet ' + IntToStr (AfrFil.Count) + ' afregningsposter diskette(r)');
        LogFil.Add ('Der blev dannet ' + IntToStr (ErrFil.Count) + ' fejlposter');
        if KomFil.Count > 0 then
        begin
          // Dan kommuneliste
          if DirectoryExists ('C:\C2\Afregning\Kommuner\') then
          begin
            // Afregningsfilen sorteres på de første 25 bytes (måske mere)
            LogFil.Add ('Afregningsfilen sorteres');
            KomFil.Sort;
            KomFil.SaveToFile ('C:\C2\Afregning\Kommuner\Citosys.Afr');
            LogFil.Add ('Afregningsliste dannes');
            Caption := ' Afregningsliste dannes';
            Update;
            AfrListe;
            KomFil.Clear;
            LstFil.Insert (0, '');
            LstFil.Insert (0, '');
            LstFil.Insert (0, 'Udskrevet for perioden' +
                              ' fra ' + FormatDateTime ('dd-mm-yyyy', FraDato) +
                              ' til ' + FormatDateTime ('dd-mm-yyyy', TilDato));
            LstFil.Insert (0, ffFirmaNavn.AsString);
            LstFil.Insert (0, 'K O M M U N E A F R E G N I N G');
            LogFil.Add ('Afregningsliste skrives til disk');
            LstFil.SaveToFile ('C:\C2\Afregning\Kommuner\Citosys.Lst');
            LstFil.Clear;
            Caption := ' Afregningsliste udskrives';
            Update;
            PatMatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Kommuner\Citosys.Lst');
          end
          else
            ErrFil.Add ('Mangler directory C:\C2\Afregning\Kommuner\');
        end;
        if AfrFil.Count > 0 then
        begin
          // Dan disketter
          LogFil.Add ('Disketteantal m.m. beregnes');
          TotRecs := AfrFil.Count;
          if TotRecs <= MaxPoster then
          begin
            // En diskette
            TotDisk := 1;
            RstRecs := TotRecs;
          end
          else
          begin
            // Flere Disketter
            if TotRecs mod MaxPoster = 0 then
            begin
              TotDisk := TotRecs div MaxPoster;
              RstRecs :=             MaxPoster;
            end
            else
            begin
              TotDisk := (TotRecs div MaxPoster) + 1;
              RstRecs :=  TotRecs mod MaxPoster;
            end;
          end;
          LogFil.Add ('Antal poster i alt ' + IntToStr (TotRecs));
          LogFil.Add ('Antal disketter ' + IntToStr (TotDisk));
          LogFil.Add ('Antal poster sidste diskette ' + IntToStr (RstRecs));
          CntRecs := 0;
          for CntDisk := 1 to TotDisk do
          begin
            Caption := ' Diskette ' + IntToStr (CntDisk) + ' dannes';
            Update;
            LogFil.Add ('Dan ' + IntToStr (CntDisk) + '. diskettes indhold');
            DskFil.Clear;
            if CntDisk = TotDisk then
              AktRecs := RstRecs
            else
              AktRecs := MaxPoster;
            LogFil.Add (IntToStr (AktRecs) + ' poster til disketten');
            for SavRecs := 1 to AktRecs do
            begin
              AfrLin := AfrFil.Strings [CntRecs];
              DskFil.Add (AfrLin);
              Inc (CntRecs);
            end;
            // Dan Header
            AfrLin := '1' +
                      'REF002' +
                      FormatDateTime ('yyyymmdd', UdDato) +
                      AfrMd +
                      Word2Str (TotDisk, 2) +
                      Word2Str (CntDisk, 2) +
                      Long2Str (TotRecs + TotDisk, 5) +
                      Long2Str (AktRecs + 1, 5) +
                      ApoNr +
                      ffFirmaSeNr.AsString +
                      '0' + Word2Str (FraKom, 3) +
                      Betaling +
                      Long2Str (Round (RefTot * 100), 11);
            DskFil.Insert (0, AfrLin);
            LogFil.Add ('Header "' + AfrLin + '" til disketten');
            // Gem diskettefil på harddisk
            LogFil.Add ('Disketteindhold skrives til lokal harddisk');
  //          DskFil.SaveToFile ('C:\C2\Afregning\Kommuner\Citosys.' + Word2Str (CntDisk, 3));
            DskFil.SaveToFile ('C:\C2\Afregning\Kommuner\Cul0' + Word2Str (FraKom, 3) + '.Afr');
            // Gem diskettefil på diskette
            DskFil.Clear;
          end;
          // Overskrift samleopgørelse
          OpgFil.Insert (0, '');
          OpgFil.Insert (0, '');
          OpgFil.Insert (0, 'Udskrevet for perioden' +
                            ' fra ' + FormatDateTime ('dd-mm-yyyy', FraDato) +
                            ' til ' + FormatDateTime ('dd-mm-yyyy', TilDato));
          OpgFil.Insert (0, ffFirmaNavn.AsString);
          OpgFil.Insert (0, 'S A M L E O P G Ø R E L S E');
          OpgFil.Add ('');
          OpgFil.Add ('');
          OpgFil.Add ('');
          OpgFil.Add ('');
          OpgFil.Add ('');
          OpgFil.Add ('');
          OpgFil.Add ('I alt afregnet for kommunen   ' + Spaces (28) +
                      FormCurr2Str ('###,###,##0.00', RefTot));
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
          if Trim(ffFirmaSpec2.AsString) <> '' then
            OpgFil.Add ('   Ydernr ........... ' + ffFirmaSpec2.AsString);
          if Trim(ffFirmaGiroNr.AsString) <> '' then
            OpgFil.Add ('   Gironr ........... ' + ffFirmaGiroNr.AsString);
          if Trim(ffFirmaSeNr.AsString) <> '' then
            OpgFil.Add ('   SE-nr. ........... ' + ffFirmaSeNr.AsString);
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
          LogFil.Add ('Samleopgørelse skrives til disk');
          if OpgFil.Count > 0 then
            OpgFil.SaveToFile ('C:\C2\Afregning\Kommuner\Citosys.Opg');
          OpgFil.Clear;
          Caption := ' Samleopgørelse udskrives';
          Update;
          PatMatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Kommuner\Citosys.Opg');
          if ChkBoxYesNo ('Udskriv ekstra kopi af samleopgørelse ?', TRUE) then
            PatMatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Kommuner\Citosys.Opg');
        end;
        // Opdater system
        try
          ffRcpOpl.Edit;
          ffRcpOplAfrPerKOMSt.AsDateTime := Trunc (FraDato) + Frac (0.0);
          ffRcpOplAfrPerKOMSl.AsDateTime := Trunc (TilDato) + Frac (0.0);
          ffRcpOplAfrDiskKOM.Value       := TotDisk;
          ffRcpOplAfrPostKOM.Value       := TotRecs;
          ffRcpOpl.Post;
        except
          if ffRcpOpl.State <> dsBrowse then
            ffRcpOpl.Cancel;
        end;
        if ErrFil.Count > 0 then
        begin
          ErrFil.Insert (0, '');
          ErrFil.Insert (0, '');
          ErrFil.Insert (0, 'Udskrevet for perioden' +
                            ' fra ' + FormatDateTime ('dd-mm-yyyy', FraDato) +
                            ' til ' + FormatDateTime ('dd-mm-yyyy', TilDato));
          ErrFil.Insert (0, ffFirmaNavn.AsString);
          ErrFil.Insert (0, 'F E J L L I S T E   K O M M U N E R');
          ErrFil.Add ('Fejlbeløb ... ' + FormatCurr ('###,###,##0.00', ErrTot));
          ErrFil.Add (FixStr ('=', 72));
          LogFil.Add ('Fejlliste gemmes/udskrives på printer');
          ErrFil.SaveToFile ('C:\C2\Afregning\Kommuner\Citosys.Err');
          ErrfIL.Clear;
          Caption := ' Fejlliste udskrives';
          Update;
          PatMatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Kommuner\Citosys.Err');
        end;
        LogFil.Insert (0, '');
        LogFil.Insert (0, '');
        LogFil.Insert (0, 'Udskrevet for perioden' +
                          ' fra ' + FormatDateTime ('dd-mm-yyyy', FraDato) +
                          ' til ' + FormatDateTime ('dd-mm-yyyy', TilDato));
        LogFil.Insert (0, ffFirmaNavn.AsString);
        LogFil.Insert (0, 'L O G U D S K R I F T   K O M M U N E R');
        LogFil.Add    ('Afregning er afsluttet');
        Caption := ' Afregning er afsluttet';
        Update;
        AfrRes := 0;
      except
        AfrRes := 2;
      end;
    finally
      try
        LogFil.SaveToFile ('C:\C2\Afregning\Kommuner\Citosys.Log');
        LogFil.Clear;
        // Exception
        if AfrRes <> 0 then
        begin
          if ChkBoxYesNo ('Uventet fejl under afregning, udskriv logfil !', TRUE) then
            PatMatrixPrnForm.PrintMatrix (PNr, 'C:\C2\Afregning\Kommuner\Citosys.Log');
        end;
      except
      end;
      OpgFil.Free;
      DskFil.Free;
      LstFil.Free;
      LogFil.Free;
      AfrFil.Free;
      KomFil.Free;
      ErrFil.Free;
      ffAfrEks.CancelRange;
      ffAfrEks.IndexName:= IdxAfr;
      ffLagKar.IndexName:= IdxLag;
  //    ffInLst.Filter     := InFilter;
  //    ffInLst.Filtered   := True;
  //    ModalResult        := mrOK;
    end;
  end;
end;

end.
