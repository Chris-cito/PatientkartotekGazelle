unit CtrBevOversigt;

{ Developed by: Vitec Cito A/S

  Description: CtrBeevillings Oversigt screen

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  25-09-2025/cjs  Fixed the ctr bevillingsovesigt screen not showing info when there was something to show.
                  This was due to the way that the date is returned from CTR yyyymmdd not dd-mm-yyyy

  23-09-2025/cjs  Fixed the ctr bevilingsoversigt screen showing test message.

  05-09-2025/cjs  Make the ctr bevillins screen wide enough to show the stats column.

  10-06-2021/MA   To fully support X-eCPR, the LMSModtager is submitted to CTR - not the Kundenr.

  23-04-2020/cjs  Declared CTRBevOvr as class procedure and removed from autocreate
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, System.StrUtils, DBGrids, DBCtrls, StdCtrls,
  ExtCtrls, Buttons, dxSkinsCore, dxSkinBasic, dxSkinLilian, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus, cxButtons,
  Data.DB, Vcl.Grids;

type
  TfmCtrBevOversigt = class(TForm)
    paCtrOver: TPanel;
    dbgCtrOver: TDBGrid;
    Panel1: TPanel;
    lblCpRnr: TLabel;
    lblNavn: TLabel;
    lblType: TLabel;
    lblStart: TLabel;
    lblHenstans: TLabel;
    buLuk: TcxButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    startdato: TDateTime;
    Kundenr : string;
  public
    { Public declarations }
    class procedure CtrBevOver(const AKundenr : string);
  end;

implementation

uses
  c2procs, DM, MidClientApi;

{$R *.DFM}

class procedure TfmCtrBevOversigt.CtrBevOver(const AKundenr : string);
begin
  var LFrm := TfmCtrBevOversigt.Create(Application);
  try
    LFrm.Kundenr := AKundenr;
    MainDm.nxCTRinf.IndexName := 'KundenrOrden';
    if MainDm.nxCTRinf.FindKey([LFrm.Kundenr]) then
      LFrm.startdato := MainDm.nxCTRinfstartdato.AsDateTime
    else
      LFrm.startdato := 0;
    MainDm.nxctrbev.IndexName := 'KundeNrOrden';
    MainDm.nxCTRBev.SetRange([AKundenr],[AKundenr]);
    try
      LFrm.ShowModal;
    finally
      MainDm.nxCTRBev.CancelRange;
    end;
  finally
    LFrm.Free;
  end;
end;

procedure TfmCtrBevOversigt.FormShow(Sender: TObject);
begin
  lblHenstans.Caption := '';
  try
    MidClient.RecvCtrHenstansOrdning(MainDm.ffPatKarLmsModtager.AsString, MainDm.cdsHenstandsOrdning);
  except
    on E: Exception do
    begin
      ShowMessage('Failed to load henstandsordning: ' + E.Message);
      Exit;
    end;
  end;

  lblCpRnr.Caption := Kundenr;
  lblNavn.Caption := MainDm.ffPatKarNavn.AsString;
  lblType.Caption := CtrPatType2Str(MainDm.ffPatKarCtrType.AsInteger);
  if startdato > 0 then
    lblStart.Caption := FormatDateTime('dd-mm-yyyy', startdato)
  else
    lblStart.Caption := '';

  if MainDm.cdsHenstandsOrdning.IsEmpty then
  begin
    lblHenstans.Caption := 'Ingen henstandsordning';
    Exit;
  end;

  MainDm.cdsHenstandsOrdning.First;

  var isActive := MatchText(MainDm.cdsHenstandsOrdningaktiv.AsString, ['TRUE', 'Y']);
  var apotekNr := MainDm.cdsHenstandsOrdningApoteksnr.AsString;
  var indgaaelse := MainDm.cdsHenstandsOrdningindgaaelsesdato.AsString;
  var ophoer :=  MainDm.cdsHenstandsOrdningophoersdato.AsString;

  lblHenstans.Caption := Format('Henstandordning : %s %s %s', [apotekNr, indgaaelse, ophoer]);

  if not isActive then
  begin
    var aarsag := MainDm.cdsHenstandsOrdningophoersaarsag.AsString;
    lblHenstans.Caption := lblHenstans.Caption + '  (Inaktiv - Årsag: ' + aarsag + ')';
  end;

end;

end.

