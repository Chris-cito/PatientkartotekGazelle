unit UdskrivFaktura;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MatrixPrinter, ExtCtrls, StdCtrls, Buttons;

type
  TFakturaForm = class(TForm)
    gbFakturaNr: TGroupBox;
    eFra: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    eTil: TEdit;
    gbPrinter: TGroupBox;
    cbPrnNr: TComboBox;
    gbFakturaValg: TGroupBox;
    cbFakNr: TComboBox;
    Panel1: TPanel;
    ButOK: TBitBtn;
    laMsg: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButOKClick(Sender: TObject);
    procedure DebitorLinier;
    procedure FormularLinier;
    procedure KolonneLinier (var KolRec : TKolLinRec);
    procedure TekstLinier;
    procedure DanFormular;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    LogLst : TStringList;
    FakNr,
    PrnNr  : Integer;
  end;

  procedure UdskrivFakturaer (FraNr, TilNr : LongWord);
  procedure NTUdskrivFakturaer (FraNr, TilNr : LongWord);

var
  FakturaForm: TFakturaForm;

implementation

uses
  C2MainLog,
  C2WinApi,
  C2Procs,
  DM,
  MidClientApi, UbiPrinter;

{$R *.DFM}

procedure UdskrivFakturaer (FraNr, TilNr : LongWord);
var
  GemIdx : String;
begin with MainDm, MatrixPrnForm do begin
  FakturaForm := TFakturaForm.Create (NIL);
  with FakturaForm do begin
    try
      LogLst             := TStringList.Create;
      GemIdx             := ffEksOvr.IndexName;
      ffEksOvr.IndexName := 'FakturaNrOrden';
      laMsg.Caption      := '';
      eFra.Text          := IntToStr (FraNr);
      eTil.Text          := IntToStr (TilNr);
      PrnNr              := FaktDevNo;
      if ffEksFak.FindKey ([FraNr]) then
        FakNr := ffEksFakFaktura.Value
      else
        FakNr := 0;
      if PrnNr > 0 then
        cbPrnNr.ItemIndex := PrnNr - 1;
      if FakNr > 0 then
        cbFakNr.ItemIndex := FakNr - 1;
      ShowModal;
    finally
      LogLst.Free;
      LogLst := NIL;
      FakturaForm.Free;
      FakturaForm := NIL;
      ffEksOvr.CancelRange;
      ffEksOvr.IndexName := GemIdx;
    end;
  end;
end; end;

procedure NTUdskrivFakturaer (FraNr, TilNr : LongWord);
var
  GemIdx : String;
begin with MainDm, MatrixPrnForm do begin
  FakturaForm := TFakturaForm.Create (NIL);
  with FakturaForm do begin
    try
      gbPrinter.Visible  := FALSE;
      LogLst             := TStringList.Create;
      GemIdx             := ffEksOvr.IndexName;
      ffEksOvr.IndexName := 'FakturaNrOrden';
      laMsg.Caption      := '';
      eFra.Text          := IntToStr (FraNr);
      eTil.Text          := IntToStr (TilNr);
      PrnNr              := -1;
      if ffEksFak.FindKey ([FraNr]) then
        FakNr := ffEksFakFaktura.Value
      else
        FakNr := 0;
      if FakNr > 0 then
        cbFakNr.ItemIndex := FakNr - 1;
      ShowModal;
    finally
      LogLst.Free;
      LogLst := NIL;
      FakturaForm.Free;
      FakturaForm := NIL;
      ffEksOvr.CancelRange;
      ffEksOvr.IndexName := GemIdx;
    end;
  end;
end; end;

procedure TFakturaForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    SelectNext (ActiveControl, TRUE, TRUE);
    Key := #0;
  end;
  if Key = #27 then begin
    ModalResult := mrCancel;
    Key         := #0;
  end;
end;

procedure TFakturaForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F6 then begin
    ButOK.Click;
    Key := 0;
  end;
end;

procedure TFakturaForm.FormActivate(Sender: TObject);
begin
  if (eFra.Text = eTil.Text) and (PrnNr <> 0) and (FakNr > 0) then begin
//    ButOK.Click;
    PostMessage (ButOK.Handle, BM_Click, 0, 0);
  end else
    eFra.SetFocus;
end;

procedure TFakturaForm.ButOKClick(Sender: TObject);
var
  DevNr: String;
  FrmNr,
  FraNr,
  TilNr,
  FakturaNr : LongWord;
begin with MainDm, MatrixPrnForm do begin
  laMsg.Font.Size := 16;
  laMsg.Caption   := 'Udskrift er igang !';
  FakturaForm.Update;
  Application.ProcessMessages;
  try
    C2LogAdd ('Parameter "PrnNr" konvertering');
    if PrnNr <> -1 then
      PrnNr := StrToInt (Copy (cbPrnNr.Text, 1, 1));
    C2LogAdd ('Parameter "FakNr" konvertering');
    FakNr := StrToInt (Copy (cbFakNr.Text, 1, 1));
    C2LogAdd ('Parameter "FraNr" konvertering');
    FraNr := StrToInt (eFra.Text);
    C2LogAdd ('Parameter "TilNr" konvertering');
    TilNr := StrToInt (eTil.Text);
    if Tilnr < FraNr then
      TilNr := FraNr;
    C2LogAdd ('Faktura gennemløb starter');
    for FakturaNr := FraNr to TilNr do begin
      C2LogAdd ('Fakturanr ' + IntToStr (FakturaNr) + ' behandles');
      if ffEksFak.FindKey ([FakturaNr]) then begin
        C2LogAdd ('Fakturanr ' + IntToStr (FakturaNr) + ' setrange');
        ffEksOvr.SetRange ([FakturaNr], [FakturaNr]);
        try
          if ffEksFakFaktura.Value in [1..3] then
            FrmNr := ffEksFakFaktura.Value
          else
            FrmNr := FakNr;
          C2LogAdd ('Formular ' + IntToStr (FrmNr) + ' behandles');
          if FrmNr in [1..3] then begin
            case FrmNr of
              1 : AktFormular := Formularer [c2Faktura1];
              2 : AktFormular := Formularer [c2Faktura2];
              3 : AktFormular := Formularer [c2Faktura3];
            else
            end;
            C2LogAdd ('Formular ' + IntToStr (FrmNr) + ' er valgt');
            if PrnNr in [1..3] then begin
              C2LogAdd ('Printer ' + IntToStr (PrnNr) + ' er valgt');
              AktPrinter := Printere [PrnNr];
              DanFormular;
              C2LogAdd ('Udskriv formular start');
              UdskrivFormular (PrnNr);
              C2LogAdd ('Udskriv formular slut');
            end else begin
              if PrnNr = -1 then begin
                DevNr:= C2StrPrm(C2SysUserName, 'Faktprivatmatrix', '');
                C2LogAdd ('Printer matrixprinter ' + DevNr);
                DanFormular;
                C2LogAdd ('Udskriv formular start');
                NTUdskrivFormular(DevNr);
                C2LogAdd ('Udskriv formular slut');
              end else
                C2LogAdd ('Printer ' + IntToStr (PrnNr) + ' ikke fundet');
            end;
          end else
            C2LogAdd ('Formular ' + IntToStr (FrmNr) + ' ikke fundet');
        finally
          ffEksOvr.CancelRange;
        end;
      end else
        C2LogAdd ('Fakturanr ' + IntToStr (FakturaNr) + ' ikke fundet');
    end;
    laMsg.Caption := 'Udskrift er slut !';
    FakturaForm.Update;
    FakturaForm.ModalResult := mrOK;
  except
    C2LogAdd ('Exception i UdskrivFaktura ButOKClick');
  end;
end; end;

procedure TFakturaForm.DebitorLinier;
var
  S : string;
  i : Integer;
begin with MainDm, MatrixPrnForm do begin
  C2LogAdd ('DebitorLinier in');
  for i := 1 to 10 do begin
    with AktFormular.Del1 [i] do begin
      case i of
        1  : S := ffEksFakKontoNr.AsString;
        2  : S := BytNavn (ffEksFakKontoNavn.AsString );
        3  : S := ffEksFakKontoAdr1.AsString;
        4  : S := ffEksFakKontoAdr2.AsString;
        5  : S := ffEksFakKontoAdr3.AsString;
        6  : S := BytNavn (ffEksOvrNavn.AsString );
        7  : S := ffEksOvrAdr1.AsString;
        8  : S := ffEksOvrAdr2.AsString;
        9  : begin
          S := Trim (ffEksOvrPostNr.AsString);
          if S <> '' then begin
            try
              if ffPnLst.FindKey ([ffEksOvrPostNr.AsString]) then
                S := S + ' ' + ffPnLstByNavn.AsString;
            except
              S := '';
            end;
          end;
        end;
      end;
      FyldLinie (S, Lin1, Kol1, FLen, PrtK);
      FyldLinie (S, Lin2, Kol2, FLen, PrtK);
      FyldLinie (S, Lin3, Kol3, FLen, PrtK);
    end;
  end;
  C2LogAdd ('DebitorLinier out');
end; end;

procedure TFakturaForm.FormularLinier;
var
  S : string;
  i : Integer;
begin with MainDm, MatrixPrnForm do begin
  C2LogAdd ('FormularLinier in');
  for i := 1 to 18 do begin
    with AktFormular.Del2 [i] do begin
      case i of
        1  : S := ffEksFakFakturaNr.AsString;
        2  : S := FormatDateTime ('ddmmyy', ffEksOvrTakserDato.AsDateTime);
        3  : S := FormatDateTime ('ddmmyy', ffEksOvrAfsluttetDato.AsDateTime);
        4  : S := FormatDateTime ('ddmmyy', ffEksFakForfaldsDato.AsDateTime);
        5  : S := ffEksFakKreditTekst.AsString;
        6  : Str (ffEksFakExMoms.AsCurrency:FLen:FDec, S);
        7  : Str (ffEksFakMoms  .AsCurrency:FLen:FDec, S);
        8  : Str (ffEksFakNetto .AsCurrency:FLen:FDec, S);
        9  : S := ffEksOvrBrugerTakser.AsString;
//      10 : Str (FSideNr:FLen, S);
        11 : S := ffEksFakFakturaType.AsString;
        12 : S := '';
        13 : S := '';
        14 : Str (ffEksFakTilskKom    .AsCurrency:FLen:FDec, S);
        15 : Str (ffEksFakTilskAmt    .AsCurrency:FLen:FDec, S);
        16 : Str (ffEksFakNetto       .AsCurrency:FLen:FDec, S);
        17 : Str (ffEksFakFakturaRabat.AsCurrency:FLen:FDec, S);
        18 : Str (ffEksFakAntalPakker .Value:FLen,           S);
      end;
      FyldLinie (S, Lin1, Kol1, FLen, PrtK);
      FyldLinie (S, Lin2, Kol2, FLen, PrtK);
      FyldLinie (S, Lin3, Kol3, FLen, PrtK);
    end;
  end;
  C2LogAdd ('FormularLinier out');
end; end;

procedure TFakturaForm.KolonneLinier (var KolRec : TKolLinRec);
var
  I,
  J,
  K  : Integer;
  S,
  KS : string [MaxFormKol];
begin with MatrixPrnForm do begin
  C2LogAdd  ('KolonneLinier in');
  FillChar  (KS [1], MaxFormKol, ' ');
  SetLength (KS,     MaxFormKol);
  C2LogAdd  ('KolonneLinier før feltgennemløb');
  if KolRec.LinTyp = 2 then begin
    // Find MostLeft kolonne i kolonnelinier
    K := MaxFormKol;
    for I := 1 to 9 do begin
      with AktFormular.Del3 [I] do begin
        if (Kol < K) and (FLen > 0) then
          K := Kol;
      end;
    end;
    if K < MaxFormKol then begin
      S := KolRec.Tekst;
      C2LogAdd ('KolonneLinier S "' + S + '"');
      for J := 1 to Length (S) do
        KS [K + J - 1] := S [J];
      C2LogAdd ('KolonneLinier KS "' + KS + '"');
    end;
  end else begin
    for i := 1 to 9 do begin
      with AktFormular.Del3[ i ] do begin
        try
          case I of
            1 : begin
              C2LogAdd ('KolonneLinier feltdata ' + IntToStr (I) + '"' + KolRec.VareNr + '"');
              if KolRec.VareNr = '' then
                S := Spaces (FLen)
              else
                S := KolRec.VareNr;
            end;
            2 : begin
              C2LogAdd ('KolonneLinier feltdata ' + IntToStr (I) + '"' + KolRec.Tekst + '"');
              S := KolRec.Tekst;
              if KolRec.LinTyp = 90 then
                for j := Length (S) to 52 do
                  S := S + ' '
              else
                for j := Length (S) to FLen do
                  S := S + ' ';
            end;
            3 : begin
              C2LogAdd ('KolonneLinier feltdata ' + IntToStr (I) + '"' + IntToStr (KolRec.Antal) + '"');
              if KolRec.Antal = 0 then
                S := Spaces (FLen)
              else
                Str (KolRec.Antal:FLen, S);
            end;
            4 : S := '';
            5 : begin
              C2LogAdd ('KolonneLinier feltdata ' + IntToStr (I) + '"' + CurrToStr (KolRec.Pris) + '"');
              if KolRec.Pris = 0 then
                S := Spaces (FLen)
              else
                Str (Kolrec.Pris:FLen:FDec, S);
            end;
            6 : S := '';
            7 : begin
              C2LogAdd ('KolonneLinier feltdata ' + IntToStr (I) + '"' + CurrToStr (KolRec.Andel) + '"');
              if KolRec.Andel = 0 then
                S := Spaces (FLen)
              else
                Str (KolRec.Andel:FLen:FDec, S);
            end;
            8 : begin
              C2LogAdd ('KolonneLinier feltdata ' + IntToStr (I) + '"' + CurrToStr (KolRec.Tilsk1) + '"');
              if KolRec.Tilsk1 = 0 then
                S := Spaces (FLen)
              else
                Str (KolRec.Tilsk1:FLen:FDec, S);
            end;
            9 : begin
              C2LogAdd ('KolonneLinier feltdata ' + IntToStr (I) + '"' + CurrToStr (KolRec.Tilsk2) + '"');
              if KolRec.Tilsk2 = 0 then
                S := Spaces (FLen)
              else
                Str (KolRec.Tilsk2:FLen:FDec, S);
            end;
          end;
          C2LogAdd ('KolonneLinier S data ' + IntToStr (I) + '"' + S + '"');
          if FLen > 0 then
            for J := Kol to Kol + FLen -1 do
              KS [J] := S [J - Kol + 1];
          C2LogAdd ('KolonneLinier KS data ' + IntToStr (I) + '"' + KS + '"');
        except
          C2LogAdd ('KolonneLinier exception for felt ' + IntToStr (I));
        end;
      end;
    end;
  end;
  C2LogAdd ('KolonneLinier før FKolDef.Add (KS)');
  FKolDef.Add (KS);
  C2LogAdd ('KolonneLinier out');
end; end;

procedure TFakturaForm.TekstLinier;
var
  i, j : Integer;
begin with MatrixPrnForm do begin
  C2LogAdd ('TekstLinier in');
  for i := 1 to 12 do begin
    with AktFormular.Del4 [i] do begin
      j := Length (Str);
      FyldLinie (Str, Lin, Kol, j, PrtK);
    end;
    with AktFormular.Del5 [i] do begin
      j := Length (Str);
      FyldLinie (Str, Lin, Kol, j, PrtK);
    end;
    with AktFormular.Del6 [i] do begin
      j := Length (Str);
      FyldLinie (Str, Lin, Kol, j, PrtK);
    end;
  end;
  C2LogAdd ('TekstLinier out');
end; end;

procedure TFakturaForm.DanFormular;
var
  CtrUdDato : String;
  CtrSaldo,
  CtrInBel  : Currency;
  LinNr     : Word;
  KolRec    : TKolLinRec;
  LevNr : string;
begin with MidClient, MainDm, MatrixPrnForm do begin
  // Slå log fra
  C2LogAdd ('DanFormular in');
  FillChar (FFormDef, SizeOf (FFormDef), 32);
  FillChar (FPrnDef , SizeOf (FPrnDef ), 0);
  C2LogAdd ('DanFormular initialiser');
  for LinNr := 1 to MaxFormLin do
    SetLength (FFormDef [LinNr], MaxFormKol);
  FKolDef.Clear;
  // Husk First før DebitorLinier da receptdata benyttes
  ffEksOvr.First;
  DebitorLinier;
  FormularLinier;
  TekstLinier;
  C2LogAdd ('DanFormular før receptgennemløb');
  while not ffEksOvr.Eof do begin
    C2LogAdd ('DanFormular løbenr ' + IntToStr (ffEksOvrLbNr.Value) + ' behandles');
    if ffEksOvrOrdreStatus.Value = 2 then begin
//      if ((ffEksOvrKundeType.Value in [1]) and
//          (ffEksOvrTurNr.Value   = 0))     or
//          (ffEksOvrPakkeNr.Value > 0)      then begin
      if (ffEksOvrKundeType.Value in [1]) or (ffEksOvrPakkeNr.Value > 0) then begin
        // Enkeltpersoner m.m. i forskellige udgaver
        if (ffEksFakLeveringsTekst.AsString = 'Håndkøbsudsalg')  or
           (ffEksFakLeveringsTekst.AsString = 'Udleveringssted') or
           (ffEksFakLeveringsTekst.AsString = 'Bud')             then begin
          // Pakkeoversigt
          C2LogAdd ('DanFormular pakkeoversigt');
          NulstilKolRec (KolRec, 1);
          if ffEksOvrOrdreType.Value = 1 then begin
            KolRec.Andel := KolRec.Andel + ffEksOvrTlfGebyr.AsCurrency;
            KolRec.Andel := KolRec.Andel + ffEksOvrEdbGebyr.AsCurrency;
            KolRec.Andel := KolRec.Andel + ffEksOvrUdbrGebyr.AsCurrency;
          end else begin
            KolRec.Andel := KolRec.Andel - ffEksOvrTlfGebyr.AsCurrency;
            KolRec.Andel := KolRec.Andel - ffEksOvrEdbGebyr.AsCurrency;
            KolRec.Andel := KolRec.Andel - ffEksOvrUdbrGebyr.AsCurrency;
          end;
          try
            KolRec.Tekst := IntToStr (ffEksOvrPakkeNr.Value) +
                            '/' + BytNavn (ffEksOvrNavn.AsString);
          except
          end;
          for LinNr := 1 to ffEksOvrAntLin.Value do begin
            if ffEksTil.FindKey ([ffEksOvrLbNr.Value, LinNr]) then
              if ffEksOvrOrdreType.Value = 1 then
                KolRec.Andel := KolRec.Andel + ffEksTilAndel.Value
              else
                KolRec.Andel := KolRec.Andel - ffEksTilAndel.Value;
          end;
          KolonneLinier (KolRec);
        end else begin
          // Specifikation af cprnr
          C2LogAdd ('DanFormular specifikation af cprnr');
          if ffEksFakLeveringsTekst.AsString = 'Institution' then begin
            NulstilKolRec (KolRec, 1);
            KolRec.Tekst := ffEksOvrKundeNr.AsString +
                            '/' +
                            BytNavn (ffEksOvrNavn.AsString);
            KolonneLinier (KolRec);
          end;
          // Specifikation af linier
          C2LogAdd ('DanFormular specifikation af varelinier');
          CtrUdDato := '';
          CtrSaldo  := 0;
          CtrInBel  := 0;
          if CtrUdDato = '' then begin
            if ffPatUpd.FindKey ([ffEksOvrKundeNr.AsString]) then
              if not ffPatUpdCtrUdDato.IsNull then
                CtrUdDato := FormatDateTime ('dd-mm-yyyy', ffPatUpdCtrUdDato.AsDateTime);
          end;
          for LinNr := 1 to ffEksOvrAntLin.Value do begin
            if ffEksLin.FindKey ([ffEksOvrLbNr.Value, LinNr]) then begin
              if ffEksTil.FindKey ([ffEksOvrLbNr.Value, LinNr]) then begin
                // Første linie beregn anvendt saldo
                if LinNr = 1 then begin
                  if ffEksOvrOrdreType.Value = 2 then
                    CtrSaldo := ffEksTilSaldo.AsCurrency + ffEksTilBGPBel.AsCurrency
                  else
                    CtrSaldo := ffEksTilSaldo.AsCurrency - ffEksTilBGPBel.AsCurrency;
                end;
                NulstilKolRec (KolRec, 1);
                KolRec.VareNr := ffEksLinSubVareNr.AsString;
                if C2StrPrm(C2SysUserName, 'Faktprivatmatrix', '') <> '' then
                  KolRec.Tekst:= ffEksLinTekst  .AsString + ' ' +
                                 ffEksLinPakning.AsString + ' ' +
                                 ffEksLinForm   .AsString + ' ' +
                                 ffEksLinStyrke .AsString
                else
                  KolRec.Tekst:= ffEksLinTekst.AsString;
                KolRec.Pris   := ffEksLinPris.AsCurrency;
                KolRec.Antal  := ffEksLinAntal.Value;
                KolRec.Andel  := ffEksTilAndel.AsCurrency;
                KolRec.Tilsk1 := ffEksTilTilskSyg.AsCurrency;
                KolRec.Tilsk2 := ffEksTilTilskKom1.AsCurrency +
                                 ffEksTilTilskKom2.AsCurrency;
                if ffEksOvrOrdreType.Value = 2 then begin
                  KolRec.Antal  := -KolRec.Antal;
                  KolRec.Andel  := -KolRec.Andel;
                  KolRec.Tilsk1 := -KolRec.Tilsk1;
                  KolRec.Tilsk2 := -KolRec.Tilsk2;
                end;
                KolonneLinier (KolRec);
                // Akkumuler BGP til indberettet beløb
                if ffEksTilBGPBel.AsCurrency <> 0 then begin
                  if ffEksOvrOrdreType.Value = 2 then
                    CtrInBel := CtrInBel - ffEksTilBGPBel.AsCurrency
                  else
                    CtrInBel := CtrInBel + ffEksTilBGPBel.AsCurrency;
                end;
              end;
            end;
          end;
          // Tlf/EDB/Udbr.gebyr
          C2LogAdd ('DanFormular tlf.gebyr');
          if ffEksOvrTlfGebyr.AsCurrency <> 0 then begin
            NulstilKolRec (KolRec, 1);
            KolRec.Tekst := 'Tlf.gebyr';
            KolRec.Andel := ffEksOvrTlfGebyr.AsCurrency;
            if ffEksOvrOrdreType.Value = 2 then
              KolRec.Andel := -KolRec.Andel;
            KolonneLinier (KolRec);
          end;
          C2LogAdd ('DanFormular edb.gebyr');
          if ffEksOvrEdbGebyr.AsCurrency <> 0 then begin
            NulstilKolRec (KolRec, 1);
            KolRec.Tekst := 'Edb-gebyr';
            KolRec.Andel := ffEksOvrEdbGebyr.AsCurrency;
            if ffEksOvrOrdreType.Value = 2 then
              KolRec.Andel := -KolRec.Andel;
            KolonneLinier (KolRec);
          end;
          C2LogAdd ('DanFormular udbr.gebyr');
          if ffEksOvrUdbrGebyr.AsCurrency <> 0 then begin
            NulstilKolRec (KolRec, 1);
            KolRec.Tekst := 'Udbr.gebyr';
            KolRec.Andel := ffEksOvrUdbrGebyr.AsCurrency;
            if ffEksOvrOrdreType.Value = 2 then
              KolRec.Andel := -KolRec.Andel;
            KolonneLinier (KolRec);
          end;
          // CTR
          if CtrInBel <> 0 then begin
            NulstilKolRec (KolRec, 1);
            KolonneLinier (KolRec);
            NulstilKolRec (KolRec, 2);
            KolRec.Tekst := 'Oplysninger til CTR';
            KolonneLinier (KolRec);
            NulstilKolRec (KolRec, 2);
            KolRec.Tekst := ' for løbenr ' + IntToStr (ffEksOvrLbNr.Value);
            KolonneLinier (KolRec);
            NulstilKolRec (KolRec, 2);
            KolRec.Tekst := ' Anvendt saldo ' +
                            FormCurr2Str ('###,##0.00', CtrSaldo);
            KolonneLinier (KolRec);
            NulstilKolRec (KolRec, 2);
            KolRec.Tekst := ' Indberettet   ' +
                            FormCurr2Str ('###,##0.00', CtrInBel);
            KolonneLinier (KolRec);
            NulstilKolRec (KolRec, 2);
            KolRec.Tekst := ' Ny CTR saldo  ' +
                            FormCurr2Str ('###,##0.00', CtrSaldo + CtrInBel);
            KolonneLinier (KolRec);
            if CtrUdDato <> '' then begin
              NulstilKolRec (KolRec, 2);
              KolRec.Tekst := ' CTR udløbsdato ' + CtrUdDato;
              KolonneLinier (KolRec);
            end;
          end;
          // Danmark
          C2LogAdd ('DanFormular "danmark"');
          if (ffEksOvrDKTilsk.Value   <> 0) or
             (ffEksOvrDKEjTilsk.Value <> 0) then begin
            if ffEksOvrDKmedlem.Value = 1 then begin
              NulstilKolRec (KolRec, 1);
              KolonneLinier (KolRec);
              NulstilKolRec (KolRec, 2);
              KolRec.Tekst := 'Indberettet til Danmark';
              KolonneLinier (KolRec);
              NulstilKolRec (KolRec, 2);
              KolRec.Tekst := ' for løbenr ' + IntToStr (ffEksOvrLbNr.Value);
              KolonneLinier (KolRec);
              if ffEksOvrDKTilsk.Value <> 0 then begin
                NulstilKolRec (KolRec, 2);
                KolRec.Tekst := ' Tilskud       ' +
                                FormCurr2Str ('###,##0.00', ffEksOvrDKTilsk.Value);
                KolonneLinier (KolRec);
              end;
              if ffEksOvrDKEjTilsk.Value <> 0 then begin
                NulstilKolRec (KolRec, 2);
                KolRec.Tekst := ' Ej tilskud    ' +
                                FormCurr2Str ('###,##0.00', ffEksOvrDKEjTilsk.Value);
                KolonneLinier (KolRec);
              end;
            end;
          end;
        end;
        // Forsendelses etiket til pakken
        if Caps(C2StrPrm(C2SysUserName, 'ForsendelsesEtiket', '')) = 'JA' then begin
          LevNr := Spaces(10);
          if Trim(ffEksKarLevNavn.AsString) <> '' then
            LevNr:= AddSpaces(Trim(ffEksKarLevNavn.AsString), 10);
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
            FormatCurr('###,###,##0.00', ffEksFakNetto.AsCurrency), 1, TRUE);
        end;
      end else begin
        // Institutioner m.m. leverencer
        C2LogAdd ('DanFormular specifikation af leverencer');
        for LinNr := 1 to ffEksOvrAntLin.Value do begin
          if ffEksLin.FindKey ([ffEksOvrLbNr.Value, LinNr]) then begin
            NulstilKolRec (KolRec, 1);
            KolRec.VareNr := ffEksLinSubVareNr.AsString;
            KolRec.Tekst  := ffEksLinTekst.AsString;
            KolRec.Antal  := ffEksLinAntal.Value;
            KolRec.Pris   := ffEksLinPris.AsCurrency;
{
            KolRec.Andel  := ffEksTilAndel.AsCurrency;
            KolRec.Tilsk1 := ffEksTilTilskSyg.AsCurrency;
            KolRec.Tilsk2 := ffEksTilTilskKom1.AsCurrency +
                             ffEksTilTilskKom2.AsCurrency;
}
            KolRec.Andel  := ffEksLinBrutto.AsCurrency;
            KolRec.Tilsk1 := 0;
            KolRec.Tilsk2 := 0;
            if ffEksOvrOrdreType.Value = 2 then begin
              KolRec.Antal  := -KolRec.Antal;
              KolRec.Andel  := -KolRec.Andel;
              KolRec.Tilsk1 := -KolRec.Tilsk1;
              KolRec.Tilsk2 := -KolRec.Tilsk2;
            end;
            KolonneLinier (KolRec);
          end;
        end;
        C2LogAdd ('DanFormular udbr.gebyr');
        if ffEksOvrUdbrGebyr.AsCurrency <> 0 then begin
          NulstilKolRec (KolRec, 1);
          KolRec.Tekst := 'Udbr.gebyr';
          KolRec.Andel := ffEksOvrUdbrGebyr.AsCurrency;
          if ffEksOvrOrdreType.Value = 2 then
            KolRec.Andel := -KolRec.Andel;
          KolonneLinier (KolRec);
        end;
      end;
    end;
    ffEksOvr.Next;
  end;
  // Kontogebyr
  C2LogAdd ('DanFormular kontogebyr');
  if ffEksFakKontoGebyr.Value <> 0 then begin
    NulstilKolRec (KolRec, 1);
    try
      KolRec.Tekst := 'Kontogebyr';
    except
    end;
    KolRec.Andel := ffEksFakKontoGebyr.Value;
    KolonneLinier (KolRec);
  end;
  C2LogAdd ('DanFormular out');
  C2LogSave;
end; end;

end.
