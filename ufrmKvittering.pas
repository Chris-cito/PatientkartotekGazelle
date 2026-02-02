unit ufrmKvittering;

{ Developed by: Vitec Cito A/S

  Description: Update eordre based on pakkelist number

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  07-01-2021/cjs  Change cancel to fortryd in ehandel kvittering screen

  19-08-2020/cjs  change to update eorder lines to compare varenr, subvarenr
  and the ordineretvarenummer
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfrmKvittering = class(TForm)
    Label1: TLabel;
    edtLbnr: TEdit;
    Panel1: TPanel;
    BitOK: TBitBtn;
    BitCancel: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BitOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ShowKvittering: Boolean;
  end;

implementation

uses DM, ChkBoxes, C2Procs, C2MainLog, uYesNo, uC2Common.Procs;

{$R *.dfm}
{ TfrmKvittering }

class function TfrmKvittering.ShowKvittering: Boolean;
var
  LFrm: TfrmKvittering;
begin
  LFrm := TfrmKvittering.Create(Nil);
  try
    Result := LFrm.ShowModal = mrOk;
  finally
    LFrm.Free;
  end;
end;

procedure TfrmKvittering.FormShow(Sender: TObject);
begin
  edtLbnr.Text := MainDm.nxOrdEkspLbnr.AsString;
  edtLbnr.SelectAll;
  edtLbnr.SetFocus;
end;

procedure TfrmKvittering.BitOKClick(Sender: TObject);
var
  ilbnr: integer;
  first: Boolean;
  found: Boolean;
  TotalPris: Currency;
  LVarenr: string;
  LSubVarenr: string;
begin
  try
    first := true;
    ilbnr := StrToIntDef(edtLbnr.Text, -1);
    if ilbnr = -1 then
    begin
      ChkBoxOK('Lbnr must be numeric');
      ModalResult := mrNone;
      exit;
    end;
    if ilbnr = 0 then
    begin
      ChkBoxOK('Pakkenr 0 findes ikke');
      ModalResult := mrNone;
      exit;
    end;
    MainDm.nxQryPak.Close;
    MainDm.nxQryPak.SQL.clear;
    MainDm.nxQryPak.SQL.Add('#t 100000');

    MainDm.nxQryPak.SQL.Add('select');
    MainDm.nxQryPak.SQL.Add('       x. *');
    MainDm.nxQryPak.SQL.Add('       ,rsl.ordid');
    MainDm.nxQryPak.SQL.Add('       ,rse.prescriptionid');

    MainDm.nxQryPak.SQL.Add('from');
    MainDm.nxQryPak.SQL.Add('(');
    MainDm.nxQryPak.SQL.Add('select');
    MainDm.nxQryPak.SQL.Add('      e.*');
    MainDm.nxQryPak.SQL.Add('      ,l.linienr');
    MainDm.nxQryPak.SQL.Add('      ,l.varenr');
    MainDm.nxQryPak.SQL.Add('      ,l.subvarenr');
    MainDm.nxQryPak.SQL.Add('      ,l.antal');
    MainDm.nxQryPak.SQL.Add('      ,l.tekst');
    MainDm.nxQryPak.SQL.Add('      ,l.form');
    MainDm.nxQryPak.SQL.Add('      ,l.styrke');
    MainDm.nxQryPak.SQL.Add('      ,l.Pakning');
    MainDm.nxQryPak.SQL.Add('from');
    MainDm.nxQryPak.SQL.Add('(');

    MainDm.nxQryPak.SQL.Add('SELECT');
    MainDm.nxQryPak.SQL.Add('       lbnr');
    MainDm.nxQryPak.SQL.Add('       ,takserdato');
    MainDm.nxQryPak.SQL.Add('       ,brugertakser');
    MainDm.nxQryPak.SQL.Add('       ,andel');
    MainDm.nxQryPak.SQL.Add('       ,tlfgebyr');
    MainDm.nxQryPak.SQL.Add('       ,edbgebyr');
    MainDm.nxQryPak.SQL.Add('       ,udbrgebyr');
    MainDm.nxQryPak.SQL.Add('       ,dktilsk');
    MainDm.nxQryPak.SQL.Add('       ,dkejtilsk');
    MainDm.nxQryPak.SQL.Add('       ,ctrsaldo');
    MainDm.nxQryPak.SQL.Add('	     ,kundenr');
    MainDm.nxQryPak.SQL.Add('FROM');
    MainDm.nxQryPak.SQL.Add('     "Ekspeditioner"');
    MainDm.nxQryPak.SQL.Add('where');
    MainDm.nxQryPak.SQL.Add('     Pakkenr=:InPakkenr');

    MainDm.nxQryPak.SQL.Add(') as e');
    MainDm.nxQryPak.SQL.Add('left join ekspliniersalg as l on l.lbnr=e.lbnr');
    MainDm.nxQryPak.SQL.Add(') as x');
    MainDm.nxQryPak.SQL.Add('left join rs_eksplinier as rsl on rsl.lbnr=x.lbnr and rsl.linienr=x.linienr');
    MainDm.nxQryPak.SQL.Add('left join rs_ekspeditioner as rse on rse.receptid=rsl.receptid');
    MainDm.nxQryPak.SQL.Add('order by lbnr,linienr;');
    MainDm.nxQryPak.ParamByName('InPakkenr').AsInteger := ilbnr;
    MainDm.nxQryPak.Open;
    if MainDm.nxQryPak.RecordCount = 0 then
    begin
      ChkBoxOK('Pakkenr findes ikke');
      ModalResult := mrNone;
      exit;
    end;
    if MainDm.nxOrdKundeCPR.AsString <> '' then
    begin
      C2LogAddF('Record count is %d', [MainDm.nxQryPak.RecordCount]);
      MainDm.nxQryPak.first;
      if MainDm.nxQryPak.FieldByName('Kundenr').AsString <> MainDm.nxOrdKundeCPR.AsString then
      begin
        if not frmYesNo.NewYesNoBox('Ekspeditionen tilhører et andet CPR-nummer. Vil du fortsætte?') then
        begin
          ModalResult := mrNone;
          exit;
        end;
      end;
    end;

    TotalPris := 0.0;
    MainDm.nxOrd.Edit;
    MainDm.nxOrdUdleveringstidspunkt.AsString := FormatDateTime('yyyy-mm-dd', MainDm.nxQryPak.FieldByName('TakserDato').AsDateTime)
      + 'T' + FormatDateTime('hh:mm:ss', MainDm.nxQryPak.FieldByName('TakserDato').AsDateTime);
    MainDm.nxOrdEkspedient.AsString := MainDm.nxQryPak.FieldByName('BrugerTakser').AsString;

    MainDm.nxOrdEkspLbnr.AsInteger := ilbnr;
    MainDm.nxOrdUdleveringsnummer.AsString := IntToStr(ilbnr);
    MainDm.nxOrdSamletKundeandel.AsCurrency := RoundDecCurr(MainDm.nxQryPak.FieldByName('Andel').AsCurrency);
    if MainDm.nxQryPak.FieldByName('TlfGebyr').AsCurrency <> 0 then
      MainDm.nxOrdSamletKundeandel.AsCurrency := MainDm.nxOrdSamletKundeandel.AsCurrency +
        RoundDecCurr(MainDm.nxQryPak.FieldByName('TlfGebyr').AsCurrency);
    if MainDm.nxQryPak.FieldByName('EdbGebyr').AsCurrency <> 0 then
      MainDm.nxOrdSamletKundeandel.AsCurrency := MainDm.nxOrdSamletKundeandel.AsCurrency +
        RoundDecCurr(MainDm.nxQryPak.FieldByName('EdbGebyr').AsCurrency);
    if MainDm.nxQryPak.FieldByName('UdbrGebyr').AsCurrency <> 0 then
      MainDm.nxOrdSamletKundeandel.AsCurrency := MainDm.nxOrdSamletKundeandel.AsCurrency +
        RoundDecCurr(MainDm.nxQryPak.FieldByName('UdbrGebyr').AsCurrency);

    MainDm.nxOrdTilskudsberettiget.AsCurrency := MainDm.nxQryPak.FieldByName('DKTilsk').AsCurrency;
    MainDm.nxOrdIkkeTilskudsberettiget.AsCurrency := MainDm.nxQryPak.FieldByName('DkEjTilsk').AsCurrency;

    MainDm.nxOrdAnvendtCTR.AsCurrency := MainDm.nxQryPak.FieldByName('CTRSaldo').AsCurrency;
    MainDm.nxOrdAfventerKundensGodkendelse.AsBoolean := False;

    MainDm.nxOrdOrdrestatus.AsString := 'KlarTilAfhentning';
    MainDm.nxOrdPrintStatus.AsInteger := 2; // completed

    // run down the eksplinier salg and try and find the product ordered

    while not MainDm.nxQryPak.Eof do
    begin
      LVarenr := MainDm.nxQryPak.FieldByName('Varenr').AsString;
      LSubVarenr := MainDm.nxQryPak.FieldByName('SubVarenr').AsString;
      found := False;
      try
        MainDm.nxOrdLin.first;
        found := False;
        while not MainDm.nxOrdLin.Eof do
        begin
          if (MainDm.nxOrdLinVarenummer.AsString = LVarenr) or (MainDm.nxOrdLinVarenummer.AsString = LSubVarenr) or
            (MainDm.nxOrdLinOrdineretVarenummer.AsString = LVarenr) or (MainDm.nxOrdLinOrdineretVarenummer.AsString = LSubVarenr)
          then
          begin
            adjustindexname(MainDm.nxEkspTil, 'NrOrden');

            if MainDm.nxEkspTil.FindKey([MainDm.nxQryPak.FieldByName('Lbnr').AsInteger, MainDm.nxQryPak.FieldByName('Linienr')
              .AsInteger]) then
            begin
              MainDm.nxOrdLin.Edit;

              if not MainDm.nxQryPak.FieldByName('PrescriptionId').IsNull then
              begin
                MainDm.nxOrdLinOrdinationType.AsString := 'Receptkvittering';
                MainDm.nxOrdLinOrdinationsId.AsString := MainDm.nxQryPak.FieldByName('Ordid').AsString;
                MainDm.nxOrdLinReceptId.AsString := MainDm.nxQryPak.FieldByName('PrescriptionId').AsString;
              end
              else
                MainDm.nxOrdLinOrdinationType.AsString := 'Fysisk';
              if MainDm.C2Web then
                MainDm.nxOrdLinApoteketsOrdinationRef.AsString := IntToStr(ilbnr) + ';' +
                  MainDm.nxQryPak.FieldByName('Lbnr').AsString;
              MainDm.nxOrdLinOrdineretAntal.AsInteger := MainDm.nxQryPak.FieldByName('Antal').AsInteger;
              MainDm.nxOrdLinOrdineretVarenummer.AsString := LSubVarenr;

              MainDm.nxOrdLinSygesikringensAndel.AsCurrency := MainDm.nxEkspTilTilskSyg.AsCurrency;
              MainDm.nxOrdLinKommunensAndel.AsCurrency := MainDm.nxEkspTilTilskKom1.AsCurrency;
              MainDm.nxOrdLinKundeandel.AsCurrency := MainDm.nxEkspTilAndel.AsCurrency;
              TotalPris := TotalPris + MainDm.nxEkspTilAndel.AsCurrency;
              MainDm.nxOrdLinCTRbeloeb.AsCurrency := MainDm.nxEkspTilBGPBel.AsCurrency;
              MainDm.nxOrdLin.Post;

              if first then
              begin
                MainDm.nxOrdNyBeregnetCTRsaldo.AsCurrency := MainDm.nxEkspTilSaldo.AsCurrency;
              end;
            end;
            found := true;
            break;
          end;
          MainDm.nxOrdLin.Next;
        end;
      finally
        // if we do not find the ordination the pharmacy have added a product to the eordre
        if not found then
        begin
          MainDm.nxOrdLin.Append;
          MainDm.nxOrdLinEordrenummer.AsString := MainDm.nxOrdEordrenummer.AsString;
          MainDm.nxOrdLinLinjenummer.AsInteger := MainDm.nxOrdLin.RecordCount + 1;
          MainDm.nxOrdLinAntal.AsInteger := MainDm.nxQryPak.FieldByName('Antal').AsInteger;
          MainDm.nxOrdLinVarenummer.AsString := LSubVarenr;
          MainDm.nxOrdLinErSpeciel.AsBoolean := False;
          MainDm.nxOrdLinVarenavn.AsString := MainDm.nxQryPak.FieldByName('Tekst').AsString;
          MainDm.nxOrdLinForm.AsString := MainDm.nxQryPak.FieldByName('Form').AsString;
          MainDm.nxOrdLinStyrke.AsString := MainDm.nxQryPak.FieldByName('Styrke').AsString;
          MainDm.nxOrdLinPakningsstoerrelse.AsString := MainDm.nxQryPak.FieldByName('Pakning').AsString;
          MainDm.nxOrdLinSubstitution.AsString := 'IngenSubstitution';
          MainDm.nxLager.IndexName := 'NrOrden';
          if MainDm.nxLager.FindKey([0, LSubVarenr]) then
          begin
            MainDm.nxOrdLinListeprisPerStk.AsCurrency := MainDm.nxLagerSalgsPris.AsCurrency;
            MainDm.nxOrdLinTotallistepris.AsCurrency := MainDm.nxLagerSalgsPris.AsCurrency * MainDm.nxQryPak.FieldByName('Antal')
              .AsInteger;
          end;
          if not MainDm.nxQryPak.FieldByName('PrescriptionId').IsNull then
          begin
            MainDm.nxOrdLinOrdinationType.AsString := 'Receptkvittering';
            MainDm.nxOrdLinOrdinationsId.AsString := MainDm.nxQryPak.FieldByName('Ordid').AsString;
            MainDm.nxOrdLinReceptId.AsString := MainDm.nxQryPak.FieldByName('PrescriptionId').AsString;
          end
          else
            MainDm.nxOrdLinOrdinationType.AsString := 'Fysisk';
          MainDm.nxOrdLinOrdineretAntal.AsInteger := MainDm.nxQryPak.FieldByName('Antal').AsInteger;
          if MainDm.C2Web then
            MainDm.nxOrdLinApoteketsOrdinationRef.AsString := IntToStr(ilbnr) + ';' + MainDm.nxQryPak.FieldByName('Lbnr').AsString;
          MainDm.nxOrdLinOrdineretVarenummer.AsString := LSubVarenr;
          if MainDm.nxEkspTil.FindKey([MainDm.nxQryPak.FieldByName('Lbnr').AsInteger, MainDm.nxQryPak.FieldByName('Linienr')
            .AsInteger]) then
          begin
            MainDm.nxOrdLinSygesikringensAndel.AsCurrency := MainDm.nxEkspTilTilskSyg.AsCurrency;
            MainDm.nxOrdLinKommunensAndel.AsCurrency := MainDm.nxEkspTilTilskKom1.AsCurrency;
            MainDm.nxOrdLinKundeandel.AsCurrency := MainDm.nxEkspTilAndel.AsCurrency;
            TotalPris := TotalPris + MainDm.nxEkspTilAndel.AsCurrency;
            MainDm.nxOrdLinCTRbeloeb.AsCurrency := MainDm.nxEkspTilBGPBel.AsCurrency;
          end;
          MainDm.nxOrdLinEkspLinienr.AsInteger := MainDm.nxQryPak.FieldByName('Linienr').AsInteger;
          MainDm.nxOrdLin.Post;
        end;
        first := False;
        MainDm.nxQryPak.Next;
      end;
    end;

    if MainDm.C2Web then
    begin
      MainDm.nxOrdFragtpris.AsCurrency := 0;
      MainDm.nxOrdTotalpris.AsCurrency := TotalPris;
      MainDm.nxOrdEkspedient.AsString := MainDm.C2UserName;
    end
    else
    begin
      MainDm.nxOrdTotalpris.AsCurrency := TotalPris;
    end;
    MainDm.nxOrd.Post;

  except
    on e: exception do
    begin
      ChkBoxOK(e.message);
      ModalResult := mrNone;
    end;
  end;

end;

end.
