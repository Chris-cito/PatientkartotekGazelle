unit FriDosEtiket;

{ Developed by: Vitec Cito A/S

  Description: Print dosis etikets

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  29-10-2020/cjs  Modified to use new property for Recepturplads
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TfmEtk = class(TForm)
    buEtk: TBitBtn;
    meEtk: TMemo;
    eAntal: TEdit;
    Label1: TLabel;
    buGem: TBitBtn;
    bitLuk: TBitBtn;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure eAntalKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure buSletClick(Sender: TObject);
    procedure buEtkClick(Sender: TObject);
    procedure bitLukClick(Sender: TObject);
    procedure buGemClick(Sender: TObject);
  private
    { Private declarations }
    FFirma, FDato, FLbNr, FEdi, FSend, FVareNr, FAtc, FLok1, FLok2, FDebNr, FChrNr, FLevNr: String;
  public
    class function FriEtiket(Etk: TStringList; Ena: Boolean): Boolean;
  end;

implementation

uses



  DM,
  ChkBoxes,
  UbiPrinter;

{$R *.DFM}

procedure TfmEtk.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key := #0;
  end;
end;

procedure TfmEtk.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_F5 then
  begin
    buGem.Click;
    Key := 0;
  end;
  if Key = VK_F6 then
  begin
    buEtk.Click;
    Key := 0;
  end;
end;

procedure TfmEtk.eAntalKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    meEtk.SetFocus;
    Key := #0;
  end;
end;

procedure TfmEtk.FormShow(Sender: TObject);
begin
  eAntal.SetFocus;
  eAntal.SelectAll;
end;

class function TfmEtk.FriEtiket(Etk: TStringList; Ena: Boolean): Boolean;
var
  I: Integer;
  LfmEtk: TfmEtk;
begin
  Result := False;
  LfmEtk := TfmEtk.Create(NIL);
  try
    // Etiketareal afhængig af printer
    // Dyr
    if MainDm.Recepturplads = 'DYR' then
      LfmEtk.meEtk.Width := LfmEtk.meEtk.Tag;

    if Etk.Text <> '' then
    begin
      LfmEtk.FFirma := Etk.Strings[0];
      LfmEtk.FDato := Etk.Strings[1];
      LfmEtk.FLbNr := Etk.Strings[2];
      LfmEtk.FEdi := Etk.Strings[3];
      LfmEtk.FSend := Etk.Strings[4];
      LfmEtk.FVareNr := Etk.Strings[5];
      LfmEtk.FAtc := Etk.Strings[6];
      LfmEtk.FLok1 := Etk.Strings[7];
      LfmEtk.FLok2 := Etk.Strings[8];
      LfmEtk.FDebNr := Etk.Strings[9];
      LfmEtk.FLevNr := Etk.Strings[10];
      LfmEtk.FChrNr := Etk.Strings[11];
      for I := 1 to 12 do
        Etk.Delete(0);
      LfmEtk.meEtk.Lines.Assign(Etk);
    end;
    LfmEtk.buGem.Enabled := Ena;
    if LfmEtk.ShowModal = mrOk then
    begin
      Etk.Assign(LfmEtk.meEtk.Lines);
      Result := True;
    end;
  finally
    LfmEtk.Free;
  end;

end;

procedure TfmEtk.buSletClick(Sender: TObject);
begin
  meEtk.Clear;
end;

procedure TfmEtk.bitLukClick(Sender: TObject);
begin
  Close;
end;

procedure TfmEtk.buEtkClick(Sender: TObject);
var
  Etk: TStringList;
  Ant: Word;
begin
  Etk := TStringList.Create;
  try
    Ant := StrToIntDef(eAntal.Text,1);
    Etk.Assign(meEtk.Lines);
    if FDebNr <> '' then
      FDebNr := FDebNr.PadRight(10, ' ');
    if FLevNr <> '' then
      FLevNr := FLevNr.PadRight(10, ' ');
    if FChrNr <> '' then
      FChrNr := FChrNr.PadRight(10, ' ');
    fmUbi.PrintDosEtik(FFirma, FDato, FLbNr, Etk, FEdi, FSend, FVareNr, FAtc, FLok1, FLok2, FDebNr, FLevNr, FChrNr, Ant,
      True, True);
    fmUbi.PrintTotalEtiket;
  finally
    Etk.Free;
  end;
end;

procedure TfmEtk.buGemClick(Sender: TObject);
begin
  MainDm.ffEksEtk.Edit;
  MainDm.ffEksEtkEtiket.Assign(meEtk.Lines);
  MainDm.ffEksEtk.Post;

  if MainDm.ffEksOvrOrdreStatus.AsInteger = 2 then
  begin
    ChkBoxOK('Du er ved at ændre etiketten på en afsluttet ekspedition.' + sLineBreak +
      'Bemærk, at den ændrede etikettekst IKKE sendes til FMK.' + sLineBreak + sLineBreak +
      'Ønskes etiketten i FMK opdateret, skal ekspeditionen tilbageføres og genekspederes !');
  end;

end;

end.
