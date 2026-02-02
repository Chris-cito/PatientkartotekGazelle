unit CtrBevOversigt;

{ Developed by: Vitec Cito A/S

  Description: CtrBeevillings Oversigt screen

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  23-04-2020/cjs  Declared CTRBevOvr as class procedure and removed from autocreate
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBGrids, DBCtrls, StdCtrls, ExtCtrls, Buttons, Vcl.Grids;

type
  TfmCtrBevOversigt = class(TForm)
    paCtrOver: TPanel;
    dbgCtrOver: TDBGrid;
    buLuk: TBitBtn;
    Panel1: TPanel;
    lblCpRnr: TLabel;
    lblNavn: TLabel;
    lblType: TLabel;
    lblStart: TLabel;
    lblHenstans: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    startdato : string;
  public
    { Public declarations }
    class procedure CtrBevOver;
  end;


implementation

uses
  c2procs,
  DM, MidClientApi;

{$R *.DFM}

class procedure TfmCtrBevOversigt.CtrBevOver;
begin
  with MainDm do
  begin
    with TfmCtrBevOversigt.Create(Nil) do
    begin
      startdato := '';
      nxCTRinf.IndexName := 'KundenrOrden';
      if nxCTRinf.FindKey([ffPatKarKundeNr.AsString]) then
        startdato := nxCTRinfstartdato.AsString;
      nxctrbev.IndexName := 'KundeNrOrden';
      nxCTRBev.SetRange([ffPatKarKundeNr.AsString],[ffPatKarKundeNr.AsString]);
      try
        ShowModal;
      finally
        nxCTRBev.CancelRange;
        Free;
      end;
    end;
  end;

end;

procedure TfmCtrBevOversigt.FormShow(Sender: TObject);
var
  AktivStatus : string;
begin
  with MainDm do
  begin
    MidClient.RecvCtrHenstansOrdning(ffPatKarKundeNr.AsString, cdsHenstandsOrdning);
    lblCpRnr.Caption := ffPatKarKundeNr.AsString;
    lblNavn.Caption := ffPatKarNavn.AsString;
    lblType.Caption :=  CtrPatType2Str(ffPatKarCtrType.AsInteger);
    lblStart.Caption := '';
    if startdato <> '' then
      lblStart.Caption := startdato;

    if cdsHenstandsOrdning.RecordCount <> 0 then
    begin
      cdsHenstandsOrdning.First;
      AktivStatus := caps(cdsHenstandsOrdningaktiv.AsString);
      if ( AktivStatus = 'TRUE' ) or ( AktivStatus = 'Y' ) then
      begin
        lblHenstans.Caption := 'Henstandordning : ' +
              cdsHenstandsOrdningApoteksnr.AsString + ' ' +
              cdsHenstandsOrdningindgaaelsesdato.AsString + ' ' +
              cdsHenstandsOrdningophoersdato.AsString + ' ';
      end
      else
      begin
        lblHenstans.Caption := 'Henstandordning : ' +
              cdsHenstandsOrdningApoteksnr.AsString + ' ' +
              cdsHenstandsOrdningindgaaelsesdato.AsString + ' ' +
              cdsHenstandsOrdningophoersdato.AsString + ' inaktiv Årsag : ' +
              cdsHenstandsOrdningophoersaarsag.AsString;
      end;

    end
    else
    begin
      lblHenstans.Caption := 'Ingen henstandsordning';
    end;

  end;
end;

end.
