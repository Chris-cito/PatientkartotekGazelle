unit UdskrivPakke;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MatrixPrinter, ExtCtrls, StdCtrls, Buttons;

type
  TPakkeForm = class(TForm)
    gbPakkeNr: TGroupBox;
    eNr: TEdit;
    gbPrinterValg: TGroupBox;
    cbPrnNr: TComboBox;
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
    PrnNr : Integer;
  end;

  procedure UdskrivPakkeseddel (Nr : LongWord);
  procedure NTUdskrivPakkeseddel (Nr : LongWord);

var
  PakkeForm: TPakkeForm;

implementation

uses
  C2MainLog,
  UbiPrinter,
  C2WinApi,
  C2Procs,
  DM,
  MidClientApi;

{$R *.DFM}

var
  Andel,
  TilskKom,
  TilskSyg,
  MomsPl,
  Moms,
  IAlt,
  Rabat      : Currency;

procedure UdskrivPakkeseddel (Nr : LongWord);
var
  GemIdx : String;
begin with MainDm, MatrixPrnForm do begin
  PakkeForm := TPakkeForm.Create (NIL);
  with PakkeForm do begin
    try
      GemIdx             := ffEksOvr.IndexName;
      ffEksOvr.IndexName := 'PakkeNrOrden';
      laMsg.Caption      := '';
      eNr.Text           := IntToStr (Nr);
      PrnNr              := PakkeDevNo;
      if PrnNr > 0 then
        cbPrnNr.ItemIndex:= PakkeForm.PrnNr - 1;
      ShowModal;
    finally
      PakkeForm.Free;
      PakkeForm := NIL;
      ffEksOvr.CancelRange;
      ffEksOvr.IndexName := GemIdx;
    end;
  end;
end; end;

procedure NTUdskrivPakkeseddel (Nr : LongWord);
var
  GemIdx : String;
begin with MainDm, MatrixPrnForm do begin
  PakkeForm := TPakkeForm.Create (NIL);
  with PakkeForm do begin
    try
      gbPrinterValg.Visible:= FALSE;
      GemIdx               := ffEksOvr.IndexName;
      ffEksOvr.IndexName   := 'PakkeNrOrden';
      laMsg.Caption        := '';
      eNr.Text             := IntToStr (Nr);
      PrnNr                := -1;
      ShowModal;
    finally
      PakkeForm.Free;
      PakkeForm := NIL;
      ffEksOvr.CancelRange;
      ffEksOvr.IndexName   := GemIdx;
    end;
  end;
end; end;

procedure TPakkeForm.FormKeyPress(Sender: TObject; var Key: Char);
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

procedure TPakkeForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F6 then begin
    ButOK.Click;
    Key := 0;
  end;
end;

procedure TPakkeForm.FormActivate(Sender: TObject);
begin
  if (eNr.Text <> '') and (PrnNr <> 0) then begin
//  ButOK.Click;
    PostMessage (ButOK.Handle, BM_Click, 0, 0);
  end else
    eNr.SetFocus;
end;

procedure TPakkeForm.ButOKClick(Sender: TObject);
var
  DevNr: String;
  PakkeNr : LongWord;
begin with MainDm, MatrixPrnForm do begin
  laMsg.Caption := 'Udskrift er igang !';
  PakkeForm.Update;
  Application.ProcessMessages;
  try
    if PrnNr <> -1 then
      PrnNr   := StrToInt (Copy (cbPrnNr.Text, 1, 1));
    PakkeNr := StrToInt (eNr.Text);
    ffEksOvr.SetRange ([PakkeNr], [PakkeNr]);
    try
      if PrnNr in [1..3] then begin
        C2LogAdd ('Printer ' + IntToStr (PrnNr) + ' er valgt');
        AktFormular := Formularer [c2PakkeSeddel];
        AktPrinter  := Printere   [PrnNr];
        DanFormular;
        C2LogAdd ('Udskriv formular start');
        UdskrivFormular (PrnNr);
        C2LogAdd ('Udskriv formular slut');
      end else begin
        if PrnNr = -1 then begin
          DevNr:= C2StrPrm(C2SysUserName, 'Pakkeseddelmatrix', '');
          C2LogAdd ('Printer matrixprinter ' + DevNr);
          AktFormular := Formularer [c2PakkeSeddel];
          DanFormular;
          C2LogAdd ('Udskriv formular start');
          NTUdskrivFormular(DevNr);
          C2LogAdd ('Udskriv formular slut');
        end else
          C2LogAdd ('Printer ' + IntToStr (PrnNr) + ' ikke fundet');
      end;
    finally
      ffEksOvr.CancelRange;
    end;
    laMsg.Caption := 'Udskrift er slut !';
    PakkeForm.Update;
    PakkeForm.ModalResult := mrOK;
  except
  end;
end; end;

procedure TPakkeForm.DebitorLinier;
var
  S : string;
  i : Integer;
begin with MainDm, MatrixPrnForm do begin
  for i := 1 to 10 do begin
    with AktFormular.Del1 [i] do begin
      case i of
        1  : S := ffDebKarKontoNr.AsString;
        2  : S := BytNavn (ffDebKarNavn.AsString);
        3  : S := ffDebKarAdr1.AsString;
        4  : S := ffDebKarAdr2.AsString;
        5  : S := ffDebKarPostNr.AsString + ' ' + ffDebKarBy.AsString;
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
end; end;

procedure TPakkeForm.FormularLinier;
var
  S : string;
  i : Integer;
begin with MainDm, MatrixPrnForm do begin
  for i := 1 to 16 do begin
    with AktFormular.Del2 [i] do begin
      case i of
        1  : S := IntToStr (ffEksOvrPakkeNr.Value);
        2  : S := FormatDateTime ('ddmmyy', ffEksOvrTakserDato.AsDateTime);
        3  : S := FormatDateTime ('ddmmyy', ffEksOvrTakserDato.AsDateTime);
        4  : S := FormatDateTime ('ddmmyy', ffEksOvrTakserDato.AsDateTime + 14);
        5  : if ffEksOvrDKMedlem.Value = 1 then
               S := 'DK'
             else
               S := '';
        6  : Str (MomsPl:FLen:FDec, S);
        7  : Str (Moms:FLen:FDec, S);
        8  : Str (Andel:FLen:FDec, S);
        9  : S := ffEksOvrBrugerTakser.AsString;
//      10 : Str (FSideNr:FLen, S);
        11 : Str (Andel:FLen:FDec, S);
        12 : S := '';
        13 : Str (TilskKom:FLen:FDec, S);
        14 : Str (TilskSyg:FLen:FDec, S);
        15 : Str (IAlt:FLen:FDec, S);
        16 : Str (Rabat:FLen:FDec, S);
      end;
      FyldLinie (S, Lin1, Kol1, FLen, PrtK);
      FyldLinie (S, Lin2, Kol2, FLen, PrtK);
      FyldLinie (S, Lin3, Kol3, FLen, PrtK);
    end;
  end;
end; end;

procedure TPakkeForm.KolonneLinier (var KolRec : TKolLinRec);
var
  I,
  J,
  K  : Integer;
  S,
  KS : string [MaxFormKol];
begin with MainDm, MatrixPrnForm do begin
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
          case i of
            1  : if KolRec.VareNr = '' then
                   S := Spaces (FLen)
                 else
                   S := KolRec.VareNr;
            2  : begin
              S := KolRec.Tekst;
              if KolRec.LinTyp = 90 then
                for j := Length (S) to 52 do
                  S := S + ' '
              else
                for j := Length (S) to FLen do
                  S := S + ' ';
            end;
            3  : if KolRec.Antal = 0 then
                   S := Spaces (FLen)
                 else
                   Str (KolRec.Antal:FLen, S);
            4  : S := '';
            5  : if KolRec.Pris = 0 then
                   S := Spaces (FLen)
                 else
                   Str (Kolrec.Pris:FLen:FDec, S);
            6  : S := '';
            7  : if KolRec.Andel = 0 then
                   S := Spaces (FLen)
                 else
                   Str (KolRec.Andel:FLen:FDec, S);
            8  : if KolRec.Tilsk1 = 0 then
                   S := Spaces (FLen)
                 else
                   Str (KolRec.Tilsk1:FLen:FDec, S);
            9  : if KolRec.Tilsk2 = 0 then
                   S := Spaces (FLen)
                 else
                   Str (KolRec.Tilsk2:FLen:FDec, S);
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

procedure TPakkeForm.TekstLinier;
var
  i, j : Integer;
begin with MatrixPrnForm do begin
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
end; end;

procedure TPakkeForm.DanFormular;
var
  PostBy,
  CtrUdDato : String;
  CtrSaldo,
  CtrInBel,
  MomsPct   : Currency;
  LinNr     : Word;
  KolRec    : TKolLinRec;
  LevNr : string;
begin with MidClient, MainDm, MatrixPrnForm do begin
  FillChar (FFormDef, SizeOf (FFormDef), 32);
  FillChar (FPrnDef , SizeOf (FPrnDef ), 0);
  MomsPct := ffRcpOplMomsPct.AsCurrency;
  for LinNr := 1 to MaxFormLin do
    SetLength (FFormDef [LinNr], MaxFormKol);
  FKolDef.Clear;
  // Beregn alle totaler
  Andel    := 0;
  TilskKom := 0;
  TilskSyg := 0;
  MomsPl   := 0;
  Moms     := 0;
  IAlt     := 0;
  Rabat    := 0;
  ffEksOvr.First;
  while not ffEksOvr.Eof do begin
    if ffEksOvrOrdreType.Value = 1 then begin
      Andel := Andel + ffEksOvrTlfGebyr.AsCurrency;
      Andel := Andel + ffEksOvrEdbGebyr.AsCurrency;
      Andel := Andel + ffEksOvrUdbrGebyr.AsCurrency;
    end else begin
      Andel := Andel - ffEksOvrTlfGebyr.AsCurrency;
      Andel := Andel - ffEksOvrEdbGebyr.AsCurrency;
      Andel := Andel - ffEksOvrUdbrGebyr.AsCurrency;
    end;
    for LinNr := 1 to ffEksOvrAntLin.Value do begin
      if ffEksLin.FindKey ([ffEksOvrLbNr.Value, LinNr]) then begin
        if ffEksTil.FindKey ([ffEksOvrLbNr.Value, LinNr]) then begin
          if ffEksOvrOrdreType.Value = 1 then begin
            Andel    := Andel    + ffEksTilAndel.AsCurrency;
            TilskSyg := TilskSyg + ffEksTilTilskSyg.AsCurrency;
            TilskKom := TilskKom + ffEksTilTilskKom1.AsCurrency;
            TilskKom := TilskKom + ffEksTilTilskKom2.AsCurrency;
          end else begin
            Andel    := Andel    - ffEksTilAndel.AsCurrency;
            TilskSyg := TilskSyg - ffEksTilTilskSyg.AsCurrency;
            TilskKom := TilskKom - ffEksTilTilskKom1.AsCurrency;
            TilskKom := TilskKom - ffEksTilTilskKom2.AsCurrency;
          end;
        end;
      end;
    end;
    ffEksOvr.Next;
  end;
  Moms   := RoundDecCurr ((Andel * MomsPct) / 100.0 + MomsPct);
  MomsPl := Andel - Moms;
  IAlt   := MomsPl;
  // Husk ffEksOvr.First før DebitorLinier da receptdata benyttes
  ffEksOvr.First;
(*
  FillChar (DebitorRec, SizeOf (DebitorRec), 0);
  DebitorRec.Nr := ffEksOvrKontoNr.AsString;
  if HentDebitor (DebitorRec) then begin
*)
  // Forsendelses etiket til pakken
  if Caps(C2StrPrm(C2SysUserName, 'ForsendelsesEtiket', '')) = 'JA' then begin
    PostBy:= ffEksOvrPostNr.AsString;
    if ffPnLst.FindKey([PostBy]) then
      PostBy:= PostBy + ' ' + ffPnLstByNavn.AsString;
    LevNr := Spaces(10);
    if Trim(ffEksKarLevNavn.AsString) <> '' then
        LevNr:= AddSpaces(Trim(ffEksKarLevNavn.AsString), 10);
    fmUbi.PrintHyldeEtik(
      ffFirmaSupNavn.AsString,
      FormatDateTime('dd-mm-yy', ffEksOvrTakserDato.AsDateTime),
      ffEksOvrPakkeNr.AsString,
      ffEksOvrNavn.AsString,
      ffEksOvrAdr1.AsString,
      ffEksOvrAdr2.AsString,
      PostBy,
      ffEksOvrKontoNr.AsString,
      LevNr,
      FormatCurr('###,###,##0.00', Andel), 1, TRUE);
  end;
  if ffDebKar.FindKey([ffEksOvrKontoNr.AsString]) then begin
    DebitorLinier;
    FormularLinier;
    TekstLinier;
    while not ffEksOvr.Eof do begin
      // Specifikation af linier
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
            // Første linie
            if LinNr = 1 then begin
              if ffEksOvrOrdreType.Value = 2 then
                CtrSaldo := ffEksTilSaldo.AsCurrency + ffEksTilBGPBel.AsCurrency
              else
                CtrSaldo := ffEksTilSaldo.AsCurrency - ffEksTilBGPBel.AsCurrency;
            end;
            NulstilKolRec (KolRec, 1);
            KolRec.VareNr := ffEksLinSubVareNr.AsString;
            KolRec.Tekst  := ffEksLinTekst.AsString;
            KolRec.Antal  := ffEksLinAntal.Value;
            KolRec.Pris   := ffEksLinPris.AsCurrency;
            KolRec.Andel  := ffEksTilAndel.AsCurrency;
            KolRec.Tilsk1 := ffEksTilTilskSyg.AsCurrency;
            KolRec.Tilsk2 := ffEksTilTilskKom1.AsCurrency +
                             ffEksTilTilskKom2.AsCurrency;
            KolonneLinier (KolRec);
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
      if ffEksOvrTlfGebyr.AsCurrency <> 0 then begin
        NulstilKolRec (KolRec, 1);
        KolRec.Tekst := 'Tlf.gebyr';
        KolRec.Andel := ffEksOvrTlfGebyr.AsCurrency;
        KolonneLinier (KolRec);
      end;
      if ffEksOvrEdbGebyr.AsCurrency <> 0 then begin
        NulstilKolRec (KolRec, 1);
        KolRec.Tekst := 'Edb-gebyr';
        KolRec.Andel := ffEksOvrEdbGebyr.AsCurrency;
        KolonneLinier (KolRec);
      end;
      if ffEksOvrUdbrGebyr.AsCurrency <> 0 then begin
        NulstilKolRec (KolRec, 1);
        KolRec.Tekst := 'Udbr.gebyr';
        KolRec.Andel := ffEksOvrUdbrGebyr.AsCurrency;
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
      ffEksOvr.Next;
    end;
  end;
end; end;

end.
