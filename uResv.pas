unit uResv;

{ Developed by: Vitec Cito A/S

  Description: Reservation screen

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  21-03-2024/cjs  Changed Reservation form to use the new stock screens as it does in the substitution screen.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Buttons, uGrossistLager;
{$I EdiRcpInc}

type
  TfrmResv = class(TForm)
    buReserv: TBitBtn;
    dblKonti: TDBLookupComboBox;
    laVareNr: TLabel;
    BitBtn1: TBitBtn;
    procedure buReservClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    AutoMode : boolean;
  public
    { Public declarations }
    class procedure ShowResv(Auto : boolean);
  end;

implementation

uses DM, MidClientApi,
  VareReservation,
  chkboxes, SubstOversigt, C2MainLog,uc2common.types;

{$R *.dfm}

procedure TfrmResv.buReservClick(Sender: TObject);
var
  Resv,
  Bekr: Word;
  LVareNr: String;
  Vare: TVareRec;
  LSave_VareNr : string;
begin
  with MidClient, MainDm do
  begin
    Resv:= 1;
    Bekr:= 0;
    LVareNr := mtLinSubVareNr.AsString;

    // Grossist
    if mtGroGrNr.AsInteger = 0 then
    begin
      ChkBoxOk('Der mangler konto for reservation!');
      Exit;
    end;
    // Reservation
    Bekr:=0;
    if mtLinAntal.AsInteger > ffLagKarAntal.AsInteger then
    begin
      Resv := mtLinAntal.AsInteger;
      if ffLagKarAntal.AsInteger >0 then
        Resv := Resv - ffLagKarAntal.AsInteger;

    end;
    c2logadd('1:Shall we show nomeco screen?');
    try
      if MainDm.fqKto.FieldByName('VisVareHost').AsString <> '' then
      begin
        LSave_VareNr := LVareNr;
        c2logadd('about to shownomecostk with ' + mtEksLager.AsString + ' ' + LVareNr);
        LVareNr := TfrmGrossistLager.VisGrossistLager(nxdb,
                                                      MainDm.fqKto.FieldByName('GrOplNr').AsInteger,
                                                      mtEksLager.Value,
                                                      MainDm.fqKto.FieldByName('Kontonr').AsString,
                                                      LVareNr);

        if LVareNr = '' then
          LVareNr := LSave_VareNr;
      end;
    except
      on E: Exception do
        C2LogAdd('1: Vis Vare function not setup !!!! ' + e.Message);
    end;
    mtLinSubVareNr.AsString := LVareNr;
    if LVareNr <> LSave_VareNr then
    begin
      Bekr:=0;
      if ffLagKar.FindKey([mtEksLager.Value,mtlinSubVarenr.AsString]) then
      begin
        mtLinLokation1.AsInteger:= ffLagKarLokation1.AsInteger;
        mtLinLokation2.AsInteger:= ffLagKarLokation2.AsInteger;
        mtLinTekst    .AsString := Trim(ffLagKarNavn.AsString);
        mtLinForm     .AsString := Trim(ffLagKarForm.AsString);
        mtLinStyrke   .AsString := Trim(ffLagKarStyrke.AsString);
        mtLinPakning  .AsString := Trim(ffLagKarPakning.AsString);
        mtLinSSKode   .AsString := ffLagKarSSKode.AsString;
        mtLinATCType  .AsString := ffLagKarATCType.AsString;
        mtLinATCKode  .AsString := ffLagKarATCKode.AsString;
        mtLinPAKode   .AsString := ffLagKarPAKode.AsString;
        mtLinVareType .AsInteger:= ffLagKarVareType.AsInteger;
        mtLinUdlevType.AsString := Trim(ffLagKarUdlevType.AsString);
        mtLinHaType   .AsString := Trim(ffLagKarHAType.AsString);
        if mtLinAntal.AsInteger > ffLagKarAntal.AsInteger then
        begin
          Resv := mtLinAntal.AsInteger;
          if ffLagKarAntal.AsInteger >0 then
            Resv := Resv - ffLagKarAntal.AsInteger;
        end;
      end;
    end;
    if TfrmRes.ReserverVare(fqKto, LVareNr, Resv, Bekr,AutoMode) then
    begin
      FillChar(Vare, SizeOf(Vare), 0);
      Vare.Nr     := LVareNr;
      Vare.Antal  := Bekr;
      Vare.Lager  := fqKto.FieldByName('Lager').AsInteger;
      Vare.EgenGrp:= fqKto.FieldByName('GrNr' ).AsInteger;
      MidClient.BestilVare(Vare);
      if Vare.Status <> AppResOK then
        MidClient.ClientError(Vare.Status);
    end;
    ModalResult := mrOk
  end;
end;


class procedure TfrmResv.ShowResv(Auto : Boolean);
begin
  with MainDm do
  begin
    if mtEksEkspType.AsInteger = et_Dosispakning then
      exit;
    if ffLagKarVareType.AsInteger >= 8 then
      exit;
    if copy(ffLagKarVareNr.AsString,1,2) = '69' then
      exit;
    // cannabis is 68 product so check the drugid and dont exit if cannabis
    if (copy(ffLagKarVareNr.AsString,1,2) = '68')  and
        (copy(ffLagKarDrugId.AsString,1,4) <> SCannabisDrugIdPrefix) then
      exit;
    if SubstForm.SubstResvPressed then
      exit;
    try
      with TfrmResv.Create(Nil) do
      begin
        try
          AutoMode := Auto;
          Showmodal;

        finally
          Free;
        end;
      end;
    except
      on e : exception do
        ChkBoxOK(e.Message);

    end;
  end;
end;

procedure TfrmResv.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    ModalResult := mrCancel;
end;

end.
