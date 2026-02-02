unit BevillingsOversigt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, StdCtrls, ExtCtrls, Buttons, Vcl.Mask;

type
  TBevillingsForm = class(TForm)
    paBevBut: TPanel;
    buFortryd: TBitBtn;
    buOk: TBitBtn;
    meBev: TDBMemo;
    Label3: TLabel;
    TilERegel: TDBEdit;
    TilENavn: TDBEdit;
    Label8: TLabel;
    TilFraDato: TDBEdit;
    Label9: TLabel;
    TilTilDato: TDBEdit;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    TilPrm1: TDBEdit;
    TilPrm2: TDBEdit;
    TilPrm3: TDBEdit;
    TilPrm4: TDBEdit;
    TilPrm5: TDBEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BevillingsForm: TBevillingsForm;

function BevOversigt(VareNr, AtcKode, Produkt: String): Boolean;

implementation

uses
  C2MainLog,
  C2Procs,
  DM;

{$R *.DFM}

function BevOversigt(VareNr, AtcKode, Produkt: String): Boolean;
var
  TilATCkode : string;
  ilen : integer;
  linATCkode : string;
begin
  with BevillingsForm, MainDm do
  begin
    C2LogAdd('  Bevilling check starter /' + VareNr + '/' + AtcKode + '/' + Produkt + '/');
    ModalResult:= mrNone;
    linATCkode := AtcKode;
    TilATCkode := trim(ffPatTilAtcKode.AsString);
    ilen := length(TilATCkode);
    if ilen <> 0 then
      linATCkode := trim(mtLinATCKode.AsString);
    if ((VareNr <> '') or (linATCkode <> '') or (Produkt <> '')) and
       (ffPatTilTilskMetode.AsInteger = 0)                    then
    begin
      C2LogAdd('    Check automatisk bevilling');
      C2LogAdd('      Bevilling varenr  "' + ffPatTilVareNr .AsString + '"');
      C2LogAdd('      Bevilling atckode "' + TilATCkode + '"');
      C2LogAdd('      Bevilling produkt "' + ffPatTilProdukt.AsString + '"');
      if (ffPatTilVareNr .AsString= VareNr) and (VareNr  <> '') then
        ModalResult := mrOk;
      if  TilATCkode <> '' then
      begin
        if copy(TilATCkode,1,ilen) = copy(linATCkode,1,ilen) then
          ModalResult := mrOk;
      end;
      if (Pos(Caps(ffPatTilProdukt.AsString), Caps(Produkt)) > 0) and (Produkt <> '') then
        ModalResult:= mrOK;
      // Automatisk aktiveret eller ej
      if ModalResult = mrOK then
        C2LogAdd('    Bevilling "aktiveret"')
      else
        C2LogAdd('    Bevilling "ikke aktiveret"');
    end;
    // Vis form hvis den ikke er automatisk aktiveret
    if ModalResult <> mrOK then
    begin
      C2LogAdd('    Bevilling vises for operatør');
      ShowModal;
    end;
    // Returner resultat
    Result:= ModalResult = mrOK;
    // Log resultat
    if Result then
      C2LogAdd('  Bevilling check slut "aktiveret"')
    else
      C2LogAdd('  Bevilling check slut "ikke aktiveret"');
  end;
end;

procedure TBevillingsForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F6 then
  begin
    ModalResult:= mrOK;
    Key        := 0;
  end;
end;

end.
