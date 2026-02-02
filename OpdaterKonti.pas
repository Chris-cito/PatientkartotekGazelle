unit OpdaterKonti;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls;

type
  TKontoFraTilForm = class(TForm)
    sbFakt: TStatusBar;
    rgType: TRadioGroup;
    Panel1: TPanel;
    ButOK: TBitBtn;
    Panel2: TPanel;
    gbLevList: TGroupBox;
    gbKonto: TGroupBox;
    gbFaktura: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    eFra: TEdit;
    eTil: TEdit;
    rgHK: TRadioGroup;
    gpbDato: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    chkDato: TCheckBox;
    dtpStart: TDateTimePicker;
    dtpSlut: TDateTimePicker;
    dtpStartTime: TDateTimePicker;
    dtpSlutTime: TDateTimePicker;
    edtLevList: TEdit;
    Label5: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ButOKClick(Sender: TObject);
    procedure chkDatoClick(Sender: TObject);
    procedure rgTypeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure BogfoerLevListe;
    class procedure OpdaterFraTilKonto(const KontoFra: String; const KontoTil: String);

  end;

implementation

uses
  UdskrivFakturaLaser,
  LaserFormularer,

  C2WinApi,
  C2MainLog,
  C2Procs,
  ChkBoxes,
  Main,
  MidClientApi,
  DM;

{$R *.DFM}

class procedure TKontoFraTilForm.OpdaterFraTilKonto(const KontoFra: String; const KontoTil: String);
var
  KontoFraTilForm : TKontoFraTilForm;
begin
  with MainDm do
  begin
    KontoFraTilForm := TKontoFraTilForm.Create(NIL);
    try
      KontoFraTilForm.eFra.Text := KontoFra;
      KontoFraTilForm.eTil.Text := KontoTil;
      KontoFraTilForm.ShowModal;
    finally
      KontoFraTilForm.Free;
      KontoFraTilForm := NIL;
    end;
  end;
end;

procedure TKontoFraTilForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    SelectNext(ActiveControl, TRUE, TRUE);
    Key := #0;
  end;
  if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key := #0;
  end;
end;

procedure TKontoFraTilForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F6 then
  begin
    ButOK.Click;
    Key := 0;
  end;
end;

procedure TKontoFraTilForm.FormShow(Sender: TObject);
begin
  chkDato.Checked := False;
  dtpStart.Enabled := False;
  dtpSlut.Enabled := False;
  dtpStartTime.Enabled := False;
  dtpSlutTime.Enabled := False;
  rgType.ItemIndex := 0;
  eFra.SetFocus;
end;

procedure TKontoFraTilForm.ButOKClick(Sender: TObject);
var
  FakturaNr: LongWord;
  FraNr, TilNr, KontoNr, Txt: String;
  Cnt, Err: Integer;
  HKType, BrNr, Nr: Word;
  DebLst: TStringList;
  StartDateTime: TDateTime;
  SlutDateTime: TDateTime;
  save_index: string;
begin
  with MainDm, dmFormularer do
  begin
    if rgType.ItemIndex = 1 then
    begin
      BogfoerLevListe;
      exit;
    end;
    C2LogAdd('KontoFraTil in');
    if trim(eFra.Text) = '' then
    begin
      ChkBoxOK('Indtast debitornr.');
      exit;
    end;
    if trim(eTil.Text) = '' then
    begin
      eTil.Text := eFra.Text;
    end;
    if chkDato.Checked then
    begin
      StartDateTime := trunc(dtpStart.Date) + frac(dtpStartTime.Time);
      SlutDateTime := trunc(dtpSlut.Date) + frac(dtpSlutTime.Time);
      if StartDateTime > SlutDateTime then
      begin
        ChkBoxOK('Startdato skal være mindre end slutdato');
        exit;
      end;
    end;
    DebLst := TStringList.Create;
    ButOK.Enabled := False;
    try
      FraNr := eFra.Text;
      TilNr := eTil.Text;
      C2LogAdd('Før KontoNrMinMax out');
      KontoNrMinMax(FraNr, TilNr, DebLst);
      C2LogAdd('Efter KontoNrMinMax out');
      for Nr := 1 to DebLst.Count do
      begin
        FakturaNr := 0;
        KontoNr := trim(DebLst.Strings[Nr - 1]);
        BrNr := BrugerNr;
        HKType := rgHK.ItemIndex + 1;
        // Afslut faktura
        MidClient.MsgAktiv := False;
        Err := DBMSResRollback; // Start loop
        Cnt := 1;
        while (Err = DBMSResRollback) and (Cnt < 6) do
        begin
          C2LogAdd('  Bogfør konto "' + KontoNr + '" forsøg ' + IntToStr(Cnt));
          if chkDato.Checked then
          begin
            StartDateTime := trunc(dtpStart.Date) + frac(dtpStartTime.Time);
            SlutDateTime := trunc(dtpSlut.Date) + frac(dtpSlutTime.Time);
            Err := MidClient.AfslutFaktDato(KontoNr, BrNr, HKType, StartDateTime, SlutDateTime, FakturaNr);

          end
          else
            Err := MidClient.AfslutFakt(KontoNr, BrNr, HKType, FakturaNr);
          // Vent tre sekunder før nyt forsøg
          Inc(Cnt);
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
          C2LogAdd('  Bogfør konto fejl "' + Txt + '"');
        end
        else
        begin
          // Udskriv faktura
          if FakturaNr > 0 then
          begin
            // start danxmlfaktura first to update ekspforsendelse
            C2LogAdd('about to check whether we should send xml faktura for konto ' + KontoNr);
            save_index := ffDebKar.IndexName;
            ffDebKar.IndexName := 'NrOrden';
            try
              if ffDebKar.FindKey([KontoNr]) then
              begin
                C2LogAdd('ok we found the entry in debitorkartotek eankode is ' + ffDebKarEFaktEanKode.AsString);
                if CheckNumerisk(ffDebKarEFaktEanKode.AsString) = 13 then
                begin
                  if not StamForm.SpoergSendFakturaElektronisk then
                    C2ExecuteCS('G:\DanXMLFaktura.exe ' + KontoNr + ' 0 ' + IntToStr(FakturaNr), SW_SHOWNORMAL, 3)
                  else if ChkBoxYesNo('Send faktura elektronisk?', TRUE) then
                  begin
                    C2ExecuteCS('G:\DanXMLFaktura.exe ' + KontoNr + ' 0 ' + IntToStr(FakturaNr), SW_SHOWNORMAL, 3);
                  end;

                end;

              end;
            finally
              ffDebKar.IndexName := save_index;
            end;

            C2LogAdd('  Fakturanr ' + IntToStr(FakturaNr) + ' udskrives');
            if (FaktPrivPrn <> '') or (FaktInstPrn <> '') or (FaktLevPrn <> '') or (FaktPakkePrn <> '') then
              TfmFakturaLaser.UdskrivFaktLaser(FakturaNr, FakturaNr);

          end;

        end;
        (*
          MidClient.AfslutFakt(KontoNr, BrNr, HKType);
          if FaktRec.Status = 0 then begin
          C2LogAdd ('KontoNr ' + FaktRec.KontoNr + ' er bogført med faktura ' + IntToStr(FaktRec.FakturaNr));
          // Udskriv faktura
          if FaktRec.FakturaNr > 0 then begin
          C2LogAdd ('Fakturanr ' + IntToStr(FaktRec.FakturaNr) + ' godkendt');
          if (FaktPrivPrn <> '') or (FaktInstPrn <> '') or (FaktLevPrn <> '') or (FaktPakkePrn <> '') then
          UdskrivFaktLaser(FaktRec.FakturaNr, FaktRec.FakturaNr)
          else
          UdskrivFakturaer(FaktRec.FakturaNr, FaktRec.FakturaNr);
          end;
          end else begin
          // Fejl fra fakturering
          ChkBoxOk('Konto ikke faktureret, kode ' + IntToStr(FaktRec.Status));
          C2LogAdd('Konto ikke faktureret, kode ' + IntToStr(FaktRec.Status));
          end;
        *)
      end;
    finally
      DebLst.Free;
      ButOK.Enabled := TRUE;
      ModalResult := mrOK;
    end;
    C2LogAdd('KontoFraTil out');
  end;
end;

procedure TKontoFraTilForm.chkDatoClick(Sender: TObject);
begin
  if chkDato.Checked then
  begin
    dtpStart.Enabled := TRUE;
    dtpStart.DateTime := now;
    dtpSlut.Enabled := TRUE;
    dtpSlut.DateTime := now;
    dtpStartTime.Enabled := TRUE;
    dtpStartTime.Time := 0;
    dtpSlutTime.Enabled := TRUE;
    dtpSlutTime.Time := now;
  end
  else
  begin
    dtpStart.Enabled := False;
    dtpSlut.Enabled := False;
    dtpStartTime.Enabled := False;
    dtpSlutTime.Enabled := False;

  end;

end;

procedure TKontoFraTilForm.rgTypeClick(Sender: TObject);
begin
  case rgType.ItemIndex of
    0:
      begin
        gbLevList.Enabled := False;
        gbKonto.Enabled := TRUE;
        eFra.SetFocus;
      end;

    1:
      begin
        gbLevList.Enabled := TRUE;
        gbKonto.Enabled := False;
        edtLevList.SetFocus;
      end;
  end;
end;

procedure TKontoFraTilForm.BogfoerLevListe;
var
  levnr: Integer;
  save_index: string;
  FakturaNr: LongWord;
  KontoNr: string;
  HKType, BrNr: Word;
  Err: Integer;
  Cnt: Integer;
  Txt: string;
  save_index1: string;
begin
  with MainDm, dmFormularer do
  begin
    ModalResult := mrNone;
    save_index := nxEkspLevListe.IndexName;
    nxEkspLevListe.IndexName := 'ListeNrOrden';
    if edtLevList.Text = '' then
    begin
      ChkBoxOK('Leveringslistenr mut not be blank');
      exit;
    end;
    try
      try
        levnr := StrToInt(edtLevList.Text);
      except
        on e: Exception do
        begin
          ChkBoxOK('Leveringslistenr skal være et nummer');
          exit;
        end;
      end;

      if not nxEkspLevListe.FindKey([levnr]) then
      begin
        ChkBoxOK('Leveringsliste findes ikke');
        exit;
      end;

      FakturaNr := 0;
      KontoNr := nxEkspLevListeKonto.AsString;
      BrNr := BrugerNr;
      HKType := 1;
      // Afslut faktura
      MidClient.MsgAktiv := False;
      Err := DBMSResRollback; // Start loop
      Cnt := 1;
      while (Err = DBMSResRollback) and (Cnt < 6) do
      begin
        C2LogAdd('  Bogfør levlistenr "' + IntToStr(levnr) + '" forsøg ' + IntToStr(Cnt));
        Err := MidClient.AfslutFaktLev(KontoNr, levnr, BrNr, HKType, FakturaNr);
        // Vent tre sekunder før nyt forsøg
        Inc(Cnt);
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
        C2LogAdd('  Bogfør konto fejl "' + Txt + '"');
      end
      else
      begin
        // Udskriv faktura
        if FakturaNr > 0 then
        begin
          C2LogAdd('  Fakturanr ' + IntToStr(FakturaNr) + ' udskrives');
          if (FaktPrivPrn <> '') or (FaktInstPrn <> '') or (FaktLevPrn <> '') or (FaktPakkePrn <> '') then
            TfmFakturaLaser.UdskrivFaktLaser(FakturaNr, FakturaNr);
          save_index1 := ffDebKar.IndexName;
          ffDebKar.IndexName := 'NrOrden';
          try
            if ffDebKar.FindKey([KontoNr]) then
            begin
              if CheckNumerisk(ffDebKarEFaktEanKode.AsString) = 13 then
              begin

                if ChkBoxYesNo('Send faktura elektronisk?', TRUE) then
                begin
                  C2ExecuteCS('G:\DanXMLFaktura.exe ' + KontoNr + ' 0 ' + IntToStr(FakturaNr), SW_SHOWNORMAL, -1);
                end;

              end;

            end;
          finally
            ffDebKar.IndexName := save_index1;
          end;
        end;
      end;
      ModalResult := mrOK;

    finally

    end;
  end;
end;

end.
