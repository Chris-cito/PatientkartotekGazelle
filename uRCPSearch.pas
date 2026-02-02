unit uRCPSearch;

{ Developed by: Cito IT A/S

  Description: Search for varenr on ekspedition between date two dates

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  29-10-2020/cjs  Modified to use new property for Recepturplads

  19-07-2019/cjs  Restrict search to current lager.  Sagsnr 10241

}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, DB, nxdb,generics.collections;

type
  TfrmRCPVare = class(TForm)
    Panel1: TPanel;
    dtpStart: TDateTimePicker;
    dtpSlutdato: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtVarenr: TEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    ListView1: TListView;
    btnSoeg: TButton;
    btnUdRCP: TButton;
    btnEtiket: TButton;
    btnCancel: TButton;
    nxQuery1: TnxQuery;
    nxQuery1receptid: TIntegerField;
    nxQuery1Dato: TDateTimeField;
    nxQuery1PatCPr: TStringField;
    nxQuery1Navn: TStringField;
    nxQuery1varennr: TStringField;
    nxQuery1rslbnr: TIntegerField;
    procedure FormActivate(Sender: TObject);
    procedure btnSoegClick(Sender: TObject);
    procedure btnUdRCPClick(Sender: TObject);
    procedure btnEtiketClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FLager: integer;
    { Private declarations }
    procedure UbiPrinter(AfslLbnr : integer);
    procedure UbiAfstempling(AfslLbnr : integer);
    property Lager: integer read FLager write FLager;
  public
    { Public declarations }
    class procedure ShowRCPVarenrSearch(aLager : integer);
  end;

var
  frmRCPVare: TfrmRCPVare;

implementation

uses  DM, uRCPMidCli, Main,C2MainLog,
      C2Procs,UbiPrinter,ChkBoxes,HentHeltal,uc2ui.procs;

{$R *.dfm}


procedure TfrmRCPVare.btnEtiketClick(Sender: TObject);
var
  ll : TListItem;
  ilbnr : integer;
begin
  with MainDm do
  begin

    for ll in ListView1.Items do
    begin

      if not ll.Checked then
        continue;
      if ll.SubItems[0] = '' then
        continue;
      if TryStrToInt(ll.SubItems[0],ilbnr) then
      begin
        if ChkBoxYesNo('Udskriv doseringsetiketter?',False) then
          UbiPrinter(ilbnr);
        if ChkBoxYesNo('Udskriv afstemplingsetiketter?',True) then
          UbiAfstempling(ilbnr);
        fmubi.PrintTotalEtiket;
      end;

    end;


  end;

end;

procedure TfrmRCPVare.btnSoegClick(Sender: TObject);
var
  ivarenr : integer;
  li : TListItem;
begin
  BusyMouseBegin;
  try
    if dtpStart.Date > dtpSlutdato.Date then
    begin
      dtpStart.SetFocus;
      exit;
    end;

    if not length(Trim(edtVarenr.Text)) in [6,7] then
    begin
      edtVarenr.SetFocus;
      exit;
    end;

    if not TryStrToInt(trim(edtVarenr.Text),ivarenr) then
    begin
      edtVarenr.SetFocus;
      exit;
    end;
    nxquery1.SQL.Clear;
    nxQuery1.SQL.Add('#t 100000');

    nxQuery1.SQL.Add('select');
    nxQuery1.SQL.Add('      x.*');
    nxQuery1.SQL.Add('      ,rsl.receptid');

    nxQuery1.SQL.Add('from');
    nxQuery1.SQL.Add('(');
    nxQuery1.SQL.Add('select');
    nxQuery1.SQL.Add('       e.*');
    nxQuery1.SQL.Add('       ,l.subvarenr as Varennr');
    nxQuery1.SQL.Add('       ,l.linienr');

    nxQuery1.SQL.Add('from');
    nxQuery1.SQL.Add('(');
    nxQuery1.SQL.Add('select');
    nxQuery1.SQL.Add('lbnr as rslbnr');
    nxQuery1.SQL.Add(',afsluttetdato as dato');
    nxQuery1.SQL.Add(',kundenr as Patcpr');
    nxQuery1.SQL.Add(',navn');
    nxQuery1.SQL.Add('from');
    nxQuery1.SQL.Add('    ekspeditioner');
    nxQuery1.SQL.Add('where');
    nxQuery1.SQL.Add('     takserdato>=:startdato and takserdato <=:slutdato');
    nxQuery1.SQL.Add('     and lager=:ilager');
    nxQuery1.SQL.Add(') as e');
    nxQuery1.SQL.Add('inner join ekspliniersalg as l on l.lbnr=e.rslbnr');
    nxQuery1.SQL.Add('where l.subvarenr=:strvarenr');
    nxQuery1.SQL.Add(') as x');
    nxQuery1.SQL.Add('inner join rs_eksplinier as rsl on rsl.rslbnr=x.rslbnr and rsl.rslinienr=x.linienr');
    nxQuery1.Session := MainDm.nxSess;
    nxQuery1.AliasName := MainDm.Alias;
    nxQuery1.ParamByName('startdato').AsDateTime := trunc(dtpStart.Date);
    nxQuery1.ParamByName('slutdato').AsDateTime := dtpSlutdato.Date + EncodeTime(23,59,59,999);
    nxQuery1.ParamByName('strvarenr').AsString := trim(edtVarenr.Text);
    nxQuery1.ParamByName('ilager').AsInteger := Lager;
    try
      try
        nxQuery1.Open;
        ListView1.Items.Clear;
        if nxQuery1.RecordCount = 0 then
        begin
          ChkBoxOK('Ingen receptkvitteringer fundet.');
          exit;
        end;

        nxQuery1.First;
        while not nxQuery1.Eof do
        begin
          li:= ListView1.Items.Add;
          li.Checked := True;
          li.Caption := nxQuery1receptid.AsString;
          li.SubItems.Add(nxQuery1rslbnr.AsString);
          if nxQuery1Dato.IsNull then
            li.SubItems.Add('')
          else
            li.SubItems.Add(FormatDateTime('dd/mm/yyyy',nxQuery1Dato.AsDateTime));
          li.SubItems.Add(nxQuery1PatCPr.AsString);
          li.SubItems.Add(nxQuery1Navn.AsString);
          nxQuery1.Next;
        end;

      except
        on E: Exception do
          ChkBoxOK(e.Message);
      end;
    finally
      nxQuery1.Close;
    end;
  finally
    BusyMouseEnd;
  end;
end;

procedure TfrmRCPVare.btnUdRCPClick(Sender: TObject);
var
  ll : TListItem;
begin
  for ll in ListView1.Items do
  begin
    if not ll.Checked then
      continue;
    RCPMidCli.SendRequest('GetAddressed',
            [
            '4',
            ll.Caption,
            IntToStr(MainDm.AfdNr),
            MainDm.C2UserName
            ],
            10);
  end;

end;

procedure TfrmRCPVare.FormActivate(Sender: TObject);
begin
  dtpStart.Date := Now - 30;
  dtpSlutdato.Date := Now;
  edtVarenr.Text := '';
end;

procedure TfrmRCPVare.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin

    SelectNext (ActiveControl, TRUE, TRUE);
    Key := #0;

  end;
end;

class procedure TfrmRCPVare.ShowRCPVarenrSearch(aLager : integer);
begin
  with TfrmRCPVare.Create(Nil) do
  begin
    try
      Lager := aLager;
      Caption := Caption + ' - Lager ' + Lager.toString;
      ShowModal;
    finally
      Free;
    end;
  end;


end;

procedure TfrmRCPVare.UbiAfstempling(AfslLbnr : integer);
var
  Andel : Currency;
  Lgd1,
  Lgd2,
//  Ant,
  Cnt   : Word;
  DebNr,
  LevNr,
  ChrNr,
  Send,
  Edi,
  Sub1,
  Sub2,
  Wrk,
  Til,
  Nvn,
  ONr,
  LNr,
  Over  : String;
  Lins  : TStringList;
  Danm  : String;
  Ialt  : String;
  udbrtxt : string;
  DetailledAFSLabel : boolean;
  SendDebNr : string;
  CStar : string;
  CredAntal : integer;
  etkAndel : currency;
  etkUdlign : currency;
  etkKom1 : Currency;
  etkKom2 : Currency;
  etkSyg : Currency;

  procedure GetCredTilskValues;
  var
    Credlbnr : integer;
  begin
    with MainDm do
    begin
      Credlbnr := nxEksCred.FieldByName('CreditLbnr').AsInteger;
      ffRetLin.SetRange([Credlbnr],[Credlbnr]);
      try
        if ffRetLin.RecordCount = 0 then
          exit;

        ffRetLin.First;
        while not ffRetLin.Eof do
        begin
          if ffRetLin.FieldByName('Varenr').AsString = ffEksLin.FieldByName('Varenr').AsString then
          begin
            if ffRetTil.FindKey([Credlbnr,ffretlin.FieldByName('LinieNr').AsInteger]) then
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
    DetailledAFSLabel := pos('Detail0',fmUbi.AfsEtkLst.Text) <> 0;
    Lins  := TStringList.Create;
    try
      if not ffEksKar.FindKey ([AfslLbNr]) then
        exit;

      Andel:= 0;
  //      Ant  := 0;
      Send:= '   ';
      if ffEksKarLeveringsForm.AsInteger > 0 then
        Send:= LevForm2Str(ffEksKarLeveringsForm.AsInteger);
      SendDebNr := '';
      if ffEksKarLeveringsForm.AsInteger in [4,5,6] then
        SendDebNr := ffEksKarKontoNr.AsString;
      Edi := '   ';
      if ffEksKarEkspForm.AsInteger = 3 then
        Edi:= 'Edi';
      for Cnt := 1 to ffEksKarAntLin.Value do
      begin
        CredAntal := 0;
        etkAndel := 0;
        etkUdlign := 0;
        etkKom1 := 0;
        etkKom2 := 0;
        etkSyg := 0;
        if not ffEksLin.FindKey ([AfslLbNr, Cnt]) then
          continue;
        if not ffEksTil.FindKey ([AfslLbNr, Cnt]) then
          continue;
        if not StamForm.PrintAllAFSLabel then
        begin
          try
            nxEksCred.IndexName := 'LbnrOrden';
            nxEksCred.SetRange([AfslLbNr, Cnt],[AfslLbNr, Cnt]);
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
  //            Inc (Ant);
        ONr := Trim (ffEksLinVareNr.AsString);
        LNr := Trim (ffEksLinSubVareNr.AsString);
        if ONr <> '' then
        begin
          if ffLagKar.FindKey([ffEksKarLager.AsInteger, ONr]) then
          begin
            c2logadd('point at the right product anyway');
            C2LogAdd('start cstar check');
            CStar := '';
            if (ffLagKarSalgsPris.AsCurrency = ffLagKarBGP.AsCurrency) and
              ((ffLagKarSubKode.AsString = 'C') or (ffLagKarSubKode.AsString = 'B')) and
              ((ffLagKarSSKode.AsString  = 'A') or (ffLagKarSSKode.AsString  = 'R') or
              (ffLagKarSSKode.AsString='S') or
              (ffLagKarSSKode.AsString='V')) then
              CStar := '*';
            C2LogAdd('end of cstar check ' + CStar);
          end;
        end;
        if ONr <> LNr then
        begin
          // Vis ordineret præparat
          if (ONr <> '') and (LNr <> '') then
          begin
            Sub1:= '';
            Sub2:= '';
            if ffLagKar.FindKey([ffEksKarLager.AsInteger, ONr]) then
              Sub1:= Strip4Char('"', ffLagKarNavn.AsString);
            if ffLagKar.FindKey([ffEksKarLager.AsInteger, LNr]) then
              Sub2:= Strip4Char('"', ffLagKarNavn.AsString);
            C2LogAdd('varenr and subvarenr diferent');
            C2LogAdd('start cstar check');
            CStar := '';
            if (ffLagKarSalgsPris.AsCurrency = ffLagKarBGP.AsCurrency) and
              ((ffLagKarSubKode.AsString = 'C') or (ffLagKarSubKode.AsString = 'B')) and
              ((ffLagKarSSKode.AsString  = 'A') or (ffLagKarSSKode.AsString  = 'R') or
              (ffLagKarSSKode.AsString='S') or
              (ffLagKarSSKode.AsString='V')) then
              CStar := '*';
            C2LogAdd('END Of cstar check ' + cstar);
            Lgd1:= Length(Sub1);
            Lgd2:= Length(Sub2);
            while Lgd1 + Lgd2 > 35 do
            begin
              if Lgd1 > Lgd2 then
              begin
                Delete(Sub1, Lgd1, 1);
                Lgd1:= Length(Sub1);
              end
              else
              begin
                Delete(Sub2, Lgd2, 1);
                Lgd2:= Length(Sub2);
              end;
            end;
            Lins.Add ('ORD=' + Sub1 + ' SUB=' + Sub2);
  //                Inc      (Ant);
          end;
        end;
        // Evt. subst. præparat
        if DetailledAFSLabel then
        begin
          Nvn := Format('%6.6s %3.3s/%5.5s',[copy(ffEksLinTekst.AsString,1, 6),
                    Copy (ffEksLinPakning.AsString, 1, 3),
                Copy (ffEksLinStyrke.AsString, 1, 5)]);
        end
        else
        begin
          Nvn := Copy (ffEksLinPakning.AsString, 1, 3);
          Nvn := Copy (ffEksLinTekst.AsString,   1, 6 - Length (Nvn)) + Nvn;
          if Length (Nvn) < 6 then
            Nvn := Nvn + Spaces (6 - Length (Nvn));

        end;
        Wrk := IntToStr (ffEksLinAntal.Value-CredAntal);
        if Length (Wrk) < 3 then
          Wrk := Spaces (3 - Length (Wrk)) + Wrk;
        etkAndel := ffEksTilAndel.AsCurrency - etkAndel;
        etkUdlign := ffEksTilUdligning.AsCurrency - etkUdlign;
        etkKom1 := ffEksTilTilskKom1.AsCurrency - etkKom1;
        etkKom2 := ffEksTilTilskKom2.AsCurrency - etkKom2;
        etkSyg := ffEksTilTilskSyg.AsCurrency - etkSyg;
        if ffEksTilRegelSyg.AsInteger = 44 then
        begin
          if ffEksKarOrdreType.Value = 1 then
          begin
            Til := FormCurr2Str ('####0.00', -etkAndel) +
                   FormCurr2Str ('####0.00',                         0) +
                   FormCurr2Str ('####0.00',  etkAndel);
          end
          else
          begin
            Til := FormCurr2Str ('####0.00',  etkAndel) +
                   FormCurr2Str ('####0.00',                         0) +
                   FormCurr2Str ('####0.00', -etkAndel);
          end;
          Til := FormCurr2Str ('####0.00', etkUdlign) +
                 FormCurr2Str ('####0.00', etkKom1 +
                                           etkKom2) +
                 FormCurr2Str ('####0.00', etkAndel);
        end
        else
        begin
          if ffEksTilIBPBel.AsCurrency = 0 then
          begin
            if etkSyg = 0 then
              Til := '        '
            else
              Til := FormCurr2Str ('####0.00', etkSyg);

            if (etkKom1 +etkKom2) = 0 then
              Til := Til + '        ' +
                   FormCurr2Str ('####0.00', etkAndel)
            else
              Til := Til + FormCurr2Str ('####0.00', etkKom1 +
                                             etkKom2) +
                   FormCurr2Str ('####0.00', etkAndel);

          end
          else
          begin
            Til := FormCurr2Str ('####0.00', etkSyg) +
                   FormCurr2Str ('####0.00', etkKom1 +
                                             etkKom2) +
                   FormCurr2Str ('####0.00', etkAndel);
          end;

        end;
  //            if ffEksLinUdlevNr.Value < ffEksLinUdlevMax.Value then begin
        if (ffEksLinUdlevNr.AsInteger = 1) and (ffEksLinUdlevNr.AsInteger >= ffEksLinUdlevMax.AsInteger) then
          Til := Til + ' A '
        else
        begin
          IF DetailledAFSLabel then
          begin
            if ffEksLinUdlevNr.Value < 10 then
              Til := Til + '  ' + IntToStr (ffEksLinUdlevNr.Value)
            else
              Til := Til + ' '  + IntToStr (ffEksLinUdlevNr.Value);

            Til := Til + '/' + IntToStr (ffEksLinUdlevMax.Value);
          end
          else
          begin
            if ffEksLinUdlevNr.AsInteger >= ffEksLinUdlevMax.AsInteger then
              Til := Til + ' A '
            else
              if ffEksLinUdlevNr.Value < 10 then
                Til := Til + '  ' + IntToStr (ffEksLinUdlevNr.Value)
              else
                Til := Til + ' '  + IntToStr (ffEksLinUdlevNr.Value);
          end;
        end;
        Til := Til + ' ' + ffLagKarSubKode.AsString;

        if CStar <> ''  then
          Til := Til + CStar;
  //            end else
        C2LogAdd('add cstar to end of etiket line ' + cstar);
        Lins.Add (LNr + ' ' + Nvn + Wrk + Til);
        Andel := Andel + etkAndel;
      end;
      (*   UDBR/EDB/TELEFONGEBYR   *)
      if ffEksKarTlfGebyr.AsCurrency <> 0 then
      begin
  //        Inc (Ant);
        Andel := Andel + ffEksKarTlfGebyr.AsCurrency;
        if DetailledAFSLabel then
          Til   := format('%-42s',['Tlf-gebyr']) +
                   FormCurr2Str ('####0.00', ffEksKarTlfGebyr.AsCurrency)
        else
          Til   := format('%-32s',['Tlf-gebyr']) +
                   FormCurr2Str ('####0.00', ffEksKarTlfGebyr.AsCurrency);
        Lins.Add (Til);
      end;
      if ffEksKarEdbGebyr.AsCurrency <> 0 then
      begin
  //        Inc (Ant);
        Andel := Andel + ffEksKarEdbGebyr.AsCurrency;
        if DetailledAFSLabel then
          Til   := format('%-42s',['Tlf-gebyr']) +
                   FormCurr2Str ('####0.00', ffEksKarEdbGebyr.AsCurrency)
        else
          Til   := format('%-32s',['EDB-gebyr']) +
                   FormCurr2Str ('####0.00', ffEksKarEdbGebyr.AsCurrency);
        Lins.Add (Til);
      end;
      if ffEksKarUdbrGebyr.AsCurrency <> 0 then
      begin
        udbrtxt := 'UDBR.GEBYR';
        if (ffEksKarUdbrGebyr.AsCurrency = ffRcpOplHKgebyr.AsCurrency) and
            (ffEksKarLeveringsForm.AsInteger  in [5,6]) then
          udbrtxt := 'HÅNDKØBSGEBYR'
        else
        begin
          if ffEksKarUdbrGebyr.AsCurrency = ffRcpOplPlejehjemsgebyr.AsCurrency then
            udbrtxt := 'UDBR. TIL INSTITUTION';
        end;
  //        Inc (Ant);
        Andel := Andel + ffEksKarUdbrGebyr.AsCurrency;
        if DetailledAFSLabel then
          Til   := format('%-42s',[udbrtxt]) +
                   FormCurr2Str ('####0.00', ffEksKarUdbrGebyr.AsCurrency)
        else
          Til   := format('%-32s',[udbrtxt]) +
                   FormCurr2Str ('####0.00', ffEksKarUdbrGebyr.AsCurrency);
        Lins.Add (Til);
      end;
      if ffEksKarOrdreType.Value = 2 then
      begin
        if Andel = 0 then
          Ialt := 'KR.    -0,00'
        else
          Ialt := 'KR.'+ FormCurr2Str ('#####0.00', -Andel);
      end
      else
        Ialt := 'KR.'+ FormCurr2Str ('#####0.00', Andel);
      if ffEksKarDKMedlem.Value = 1 then
        Danm := 'danmark'
      else
        Danm := '';
      if DetailledAFSLabel then
      begin
        Over := 'PRÆPARAT               ANT  AMT=' + IntToStr (ffEksKarAmt.Value) +
               ' KOM=' + IntToStr (ffEksKarKommune.Value) + ' PATIENT UDL';
      end
      else
      begin
        Over := 'PRÆPARAT     ANT  AMT=' + IntToStr (ffEksKarAmt.Value) +
               ' KOM=' + IntToStr (ffEksKarKommune.Value) + ' PATIENT UDL';
      end;
      Lins.Insert(0, Over);
      DebNr:= Spaces(10);
      LevNr:= Spaces(10);
      ChrNr:= Spaces(6);
      if Trim(ffEksKarKontoNr.AsString) <> '' then
        DebNr:= AddSpaces(Trim(ffEksKarKontoNr.AsString), 10);
      if Trim(ffEksKarLevNavn.AsString) <> '' then
        LevNr:= AddSpaces(Trim(ffEksKarLevNavn.AsString), 10);
      if ffEksKarKundeType.AsInteger = 14 then begin
        ffPatKar.IndexName := 'NrOrden';

        if ffPatKar.FindKey([ffEksKarKundeNr.AsString]) then
        ChrNr := copy(ffPatKarLmsModtager.AsString,5,6);
      end;
      c2logadd('*** Chrnr is ' + ChrNr + ' karkundenr is ' + ffEksKarKundeNr.AsString);

      fmUbi.PrintDosAfst (
        ffFirmaSupNavn.AsString,
        FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
        ffEksKarLbNr.AsString,
        DebNr, LevNr, ChrNr,
        Lins, Edi, Send, Danm, Ialt,SendDebnr);
  {
        if Feed then
          UbiPrinterForm.UbiFeed;
  }
        // Bakkeetiket til hylden
      if Caps(C2StrPrm(MainDm.C2UserName, 'RecepthyldeEtiket', '')) = 'JA' then
      begin
        if ffEksKarKontoNr.AsString = '' then
        begin
          fmUbi.PrintHyldeEtik(
            ffFirmaSupNavn.AsString,
            FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
            ffEksKarLbNr.AsString,
            ffEksKarNavn.AsString, ffEksKarAdr1.AsString, ffEksKarAdr2.AsString,
            ffEksKarPostNr.AsString + ' ' + ffEksKarBy.AsString,
            '', LevNr, '', ffEksKarKundeNr.AsString,1, TRUE);
        end;
      end;

      if Caps(C2StrPrm(MainDm.C2UserName, 'RecepthyldeEtiketApoteksudsalg', '')) <> 'JA' then
        exit;

      if ffEksKarKontoNr.AsString <> '' then
      begin
        if ffDebKar.FindKey([ffEksKarKontoNr.AsString]) then
        begin
          if ffDebKarLevForm.AsInteger = 4 then
          begin // udsalg !!!!
                  fmUbi.PrintHyldeEtik(
                    ffFirmaSupNavn.AsString,
                    FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
                    ffEksKarLbNr.AsString,
                    ffEksKarNavn.AsString, ffEksKarAdr1.AsString, ffEksKarAdr2.AsString,
                    ffEksKarPostNr.AsString + ' ' + ffEksKarBy.AsString,
                    '', LevNr, '', ffEksKarKundeNr.AsString,1, TRUE);
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
                  fmUbi.PrintHyldeEtik(
                    ffFirmaSupNavn.AsString,
                    FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
                    ffEksKarLbNr.AsString,
                    ffEksKarNavn.AsString, ffEksKarAdr1.AsString, ffEksKarAdr2.AsString,
                    ffEksKarPostNr.AsString + ' ' + ffEksKarBy.AsString,
                    '', LevNr, '', ffEksKarKundeNr.AsString,1, TRUE);
             exit;
          end;
        end;
      end;

    finally
      fmUbi.PrintTotalEtiket;
      Lins.Free;
    end;
  end;
end;

procedure TfrmRCPVare.UbiPrinter(AfslLbnr : integer);
var
  Prs1,
  Prs2  : Currency;
  Etk   : TStringList;
  Ok    : Boolean;
  XPos,
  Ant,
  Cnt   : Integer;
  Max   : integer;
  Lok1,
  Lok2,
  DebNr,
  LevNr,
  ChrNr,
  Edi,
  Send,
  Nvn,
  Pkn,
  Sql,
  Atc   : String;
  NumEnh : integer;
  NumOrg : integer;
  CStar : string;
begin
  with MainDm do
  begin
    if not ffEksKar.FindKey ([AfslLbNr]) then
      exit;
    try
      Send:= '   ';
      if ffEksKarLeveringsForm.AsInteger > 0 then
        Send:= LevForm2Str(ffEksKarLeveringsForm.AsInteger);
      Edi := '   ';
      if ffEksKarEkspForm.AsInteger = 3 then
        Edi:= 'Edi';
      for Cnt := 1 to ffEksKarAntLin.Value do
      begin
        if not ffEksLin.FindKey ([AfslLbNr, Cnt]) then
          continue;
        if not ffEksEtk.FindKey ([AfslLbNr, Cnt]) then
          continue;

        Ok := True;
        if Recepturplads = 'AUTO' then
          // spørg om dyr
          Max:= ffEksLinAntal.Value
        else
          if Recepturplads = 'DYR' then
          begin
            // spørg om dyr
            Max:= ffEksLinAntal.Value;
            Ok := TastHeltal ('Etiketter for ' + ffEksLinTekst.AsString, Max);
            if Max < 1 then
              Ok:= False;
          end
          else
          begin
            // Der skal være antal pakninger
            if ffEksLinAntal.Value > 0 then
            begin
              Max := ffEksLinAntal.Value;
              if Caps(C2StrPrm(MainDm.C2UserName, 'Klinikpakninger', '')) = 'JA' then
              begin
                Atc := Copy (ffEksLinAtcKode.AsString, 1, 4);
                if (Atc                      <> 'G03A')    and
                   (ffEksLinAtcKode.AsString <> 'G03FB05') then
                begin
                  Pkn  := Trim (ffEksLinPakning.AsString);
                  XPos := Pos ('x', Pkn);
                  if XPos = 0 then
                    XPos := Pos ('X', Pkn);
                  if XPos > 0 then
                  begin
                    try
                      Ant := StrToInt (Copy (Pkn, 1, XPos - 2));
                    except
                      Ant := 1;
                    end;
                    if Ant > 0 then
                      Max := Ant * ffEksLinAntal.Value + 1;
                    Ok := TastHeltal ('Godkend antal etiketter', Max);
                  end;
                end
                else
                begin
                  if Max > 10 then
                    Ok := TastHeltal ('Godkend antal etiketter', Max);
                end;
              end
              else
              begin
                if Max > 10 then
                  Ok := TastHeltal ('Godkend antal etiketter', Max);
              end;
            end;
          end;
        // Udskriv
        if not Ok then
          continue;

        Etk := TStringList.Create;
        try
          Etk.Assign(ffEksEtkEtiket);
          // Kun receptlinier Evt. hvis der blev ønsket etiketter
          if Etk.Count = 0 then
            continue;
          // Lokationer
          Lok1:= Trim(ffEksLinLokation1.AsString);
          Lok2:= Trim(ffEksLinLokation2.AsString);
          // Atc
          Atc := ffEksLinATCKode.AsString;
          XPos:= C2IntPrm(MainDm.C2UserName, 'AtcLokation', 0);
          if XPos > 0 then
            Atc:= Trim(Copy(Atc, 1, XPos));
          // Forsendelse
          DebNr:= Spaces(10);
          LevNr:= Spaces(10);
          ChrNr := Spaces(6);
          if Trim(ffEksKarKontoNr.AsString) <> '' then
            DebNr:= AddSpaces(Trim(ffEksKarKontoNr.AsString), 10);
          if Trim(ffEksKarLevNavn.AsString) <> '' then
            LevNr:= AddSpaces(Trim(ffEksKarLevNavn.AsString), 10);
          if ffEksKarKundeType.AsInteger = 14 then
          begin
            ffPatKar.IndexName := 'NrOrden';

            if ffPatKar.FindKey([ffEksKarKundeNr.AsString]) then
            ChrNr := copy(ffPatKarLmsModtager.AsString,5,6);
          end;
  c2logadd('*** Chrnr is ' + ChrNr + ' karkundenr is ' + ffEksKarKundeNr.AsString);
          // Print
          try
            ffLagKar.IndexName := 'NrOrden';

            if ffLagKar.FindKey([ffEksLinLager.AsInteger,ffEksLinVareNr.asstring]) then
            begin

              if ffLagKarDelPakUdskAnt.AsInteger <> 0 then
                Max := Max * ffLagKarDelPakUdskAnt.AsInteger;
            end;
          except
          end;

          fmUbi.PrintDosEtik (
            ffFirmaSupNavn.AsString,
            FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
            ffEksKarLbNr.AsString,
            Etk,
            Edi,
            Send,
            ffEksLinSubVareNr.AsString,
            Atc,
            Lok1,
            Lok2,
            DebNr, LevNr, ChrNr,
            Max,
            Cnt = ffEksKarAntLin.Value,TRUE);
          // Substitutions etiket til kunden
          if C2StrPrm(MainDm.C2UserName, 'SubstitutionsEtiket', '') = 'Ja' then
          begin
            if ffEksLinVareNr.AsString <> ffEksLinSubVareNr.AsString then
            begin
              Prs1:= 0;
              Prs2:= 0;
              Etk.Clear;
              NumEnh := 0;
              NumOrg := 0;
              if ffLagKar.FindKey([ffEksKarLager.AsInteger, ffEksLinSubVareNr.AsString]) then
              begin
                Prs2:= ffEksLinAntal.AsInteger * ffLagKarSalgsPris.AsCurrency;
                NumEnh := ffEksLinAntal.AsInteger * ffLagKarPaknNum.AsInteger;
              end;
              Etk.Add('LÆGEN HAR ORDINERET:');
              if ffLagKar.FindKey([ffEksKarLager.AsInteger, ffEksLinVareNr.AsString]) then
              begin
                if ffLagKarPaknNum.AsInteger <> 0 then
                  NumOrg := NumEnh div ffLagKarPaknNum.AsInteger;
                if numorg =0 then
                  numorg := 1;
                Prs1:= numorg * ffLagKarSalgsPris.AsCurrency;
                Nvn := ffLagKarNavn     .AsString;
                if ffLagKarPAKode.AsString <> '' then
                  Nvn:= Nvn + '/' + ffLagKarPaKode.AsString;
                Etk.Add(' ' + Strip4Char('"', Nvn));
              end;
              Etk.Add('APOTEKET HAR UDLEVERET:');
              if ffLagKar.FindKey([ffEksKarLager.AsInteger, ffEksLinSubVareNr.AsString]) then
              begin
                Prs2:= ffEksLinAntal.AsInteger * ffLagKarSalgsPris.AsCurrency;
                Nvn := ffLagKarNavn.AsString;
                if ffLagKarPAKode.AsString <> '' then
                  Nvn:= Nvn + '/' + ffLagKarPaKode.AsString;

                // add the qauantity of the substituted product if greater than 1

                if ffEksLinAntal.AsInteger > 1 then
                  Nvn := Nvn + ' ' + ffEksLinAntal.AsString + ' Pakn';
                Etk.Add(' ' + Strip4Char('"', Nvn));

              end;
              Prs2:= Prs1 - Prs2;
              if Prs2 > 0 then
                Etk.Add('DER SPARES KR. ' + FormatCurr('#####0.00', Prs2));
              fmUbi.PrintDosEtik(
                ffFirmaSupNavn.AsString,
                FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
                ffEksKarLbNr.AsString,
                Etk, '', '', '', '', '', '', '', '','', 1, Cnt = ffEksKarAntLin.Value,TRUE);
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
                    C2LogAdd(' c product in omvendt etiket, check for cstar');
                    CStar := '';
                    if (ffLagKarSalgsPris.AsCurrency = ffLagKarBGP.AsCurrency) and
                      ((ffLagKarSSKode.AsString  = 'A') or (ffLagKarSSKode.AsString  = 'R') or
                       (ffLagKarSSKode.AsString='S') or
                      (ffLagKarSSKode.AsString='V')) then
                      CStar := '*';
                    c2logadd('after cstar ' + CStar);
                    if cstar = '' then
                    begin
                      ETK.Clear;
                      etk.Add('Lovpligtig information');
                      C2LOGADD('ABOUT TO PRINT THE NEW SUBST LABEL');
                      fqSqlSel.Close;
                      Sql :=  sl_Sql_subst_label.Text;
                      fqSqlSel.SQL.Clear;
                      fqSqlSel.SQL.Text := Sql;
                      fqsqlsel.ParamByName('lager').AsString := ffEksKarLager.AsString;
                      fqsqlsel.ParamByName('Varenr').AsString := ffEksLinSubVareNr.AsString;
                      fqSqlSel.Filtered := False;
                      fqSqlSel.Filter := '';
                      fqSqlSel.Open;
                      c2logadd('record count is ' + IntToStr(fqSqlSel.RecordCount));
                      if fqSqlSel.RecordCount >0 then
                      begin

                         fqSqlSel.Filter := 'Antal>0';
                         fqSqlSel.Filtered := True;
                         if fqSqlSel.RecordCount = 0 then
                            fqSqlSel.Filtered := False;
                         fqSqlSel.First;
                         etk.Add('Ekspederet vare');
                         Prs1:= ffEksLinAntal.AsInteger * ffEksLinPris.AsCurrency;
                         Nvn := ffEksLinTekst.AsString;
                         Etk.Add(' ' + Strip4Char('"', Nvn) + ' ' + CStar);
                         C2LogAdd('added cstar ' + cstar);
                         etk.Add('Billigere Vare');
                         Prs2 := ffEksLinAntal.AsInteger *
                            fqSqlSel.fieldbyname('Salgspris').AsCurrency;
                         Nvn := fqSqlSel.fieldbyname('Navn').asstring;
                         Etk.Add(' ' + Strip4Char('"', Nvn));
                         Prs2:= Prs1 - Prs2;

                         if ffEksTil.FindKey([AfslLbNr, Cnt]) then
                          if ffEksTilRegelSyg.AsInteger in  [42,43] then
                            Prs2 := 0;

                         if Prs2 > 0 then
                            Etk.Add('PRISFORSKEL KR. ' + FormatCurr('#####0.00', Prs2)
                              + ' ANT ' + fqSqlSel.fieldbyname('Antal').AsString)
                         else
                            Etk.Add('PRISFORSKEL KR. ' + FormatCurr('#####0.00', Prs2)
                              + '(PAKNSTR) ANT ' + fqSqlSel.fieldbyname('Antal').AsString);

                         fmUbi.PrintDosEtik(
                            ffFirmaSupNavn.AsString,
                            FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
                            ffEksKarLbNr.AsString,
                            Etk, '', '', '', '', '', '', '', '','', 1, Cnt = ffEksKarAntLin.Value,FALSE);
                      end;
                      fqSqlSel.Close;
                    end;
                  end;
                end;
              except
                on e : exception do
                  Application.MessageBox(pchar(e.Message),'erm');
              end;
            end;
          end
          else
            C2LogAdd('Ejsubst was not zero so dont print omvendt label');
          // now we shall print the substitution label for lms32
          if C2StrPrm(MainDm.C2UserName, 'SubstitutionsLMS32', '') = 'Ja' then
          begin
            try
              if ffEksLinVareNr.AsString <> ffEksLinSubVareNr.AsString then
                continue;
              if ffLagKar.FindKey([ffEksKarLager.AsInteger, ffEksLinSubVareNr.AsString]) then
              begin

                ETK.Clear;
                C2LOGADD('about to print lms32 label');
                nxKombi.Close;
                nxKombi.SQL.Clear;
                Sql :=  sl_Sql_lms32_label.Text;
                nxKombi.SQL.Text := Sql;
                C2LogAdd(sql);
                nxKombi.ParamByName('lager').AsString := ffEksKarLager.AsString;
                c2logadd(ffEksKarLager.AsString);
                nxKombi.ParamByName('Varenr').AsString := ffEksLinVareNr.AsString;
                C2LogAdd(ffEksLinVareNr.AsString);
                nxKombi.ParamByName('Drugid').AsString := ffLagKarDrugId.AsString;
                C2LogAdd(fflagkardrugid.AsString);
                nxKombi.Open;
                if nxKombi.RecordCount >0 then
                begin
                   etk.Add('Ekspederet vare');
                   Nvn := ffEksLinTekst.AsString;
                   Etk.Add(' ' + Strip4Char('"', Nvn));
                   etk.Add('DER FINDES BILLIGERE');
                   etk.add('PAKNINGSSTØRELSE');
                    fmUbi.PrintDosEtik(
                      ffFirmaSupNavn.AsString,
                      FormatDateTime('dd-mm-yy', ffEksKarTakserDato.AsDateTime),
                      ffEksKarLbNr.AsString,
                      Etk, '', '', '', '', '', '', '', '','', 1, Cnt = ffEksKarAntLin.Value,TRUE);

                end;
                nxKombi.Close;
              end;
            except
              on e : exception do
                Application.MessageBox(pchar(e.Message),'Fejl');
            end;
          end;


        finally
          Etk.Free;
        end;
      end;
    finally
    end;
  end;
end;


end.
