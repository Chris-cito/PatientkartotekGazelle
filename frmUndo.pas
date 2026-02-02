unit frmUndo;

{ Developed by: Vitec Cito A/S

  Description: Unit in PatientKartotek.

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  06-06-2021/MA   Modified to support various PersonIdentifierSources (X-eCPR, etc.).
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFMKCalls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Buttons, DM;

type
  TfmUndo = class(TForm)
    lbeKundenr: TLabeledEdit;
    lbePrescriptionIdentifier: TLabeledEdit;
    lbeOrderIdentifier: TLabeledEdit;
    lbeEffectuationIdentifier: TLabeledEdit;
    btnUndo: TButton;
    BitBtn1: TBitBtn;
    procedure btnUndoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    Kundenr : string;
    PrescriptionIdentifier : int64;
    OrderIdentifier : int64;
    EffectuationIdentifier : int64;
  public
    { Public declarations }
    class procedure Showform(AKundenr: string;
      APrescriptionIdentifier, AOrderIdentifier,
      AEffectuationIdentifier: int64);
  end;

implementation

{$R *.dfm}
{ TfmUndo }

uses ChkBoxes, uC2Fmk.Common.Types;

procedure TfmUndo.btnUndoClick(Sender: TObject);
var
  LPrescriptionIdentifier: int64;
  LOrderIdentifier: int64;
  LEffectuationIdentifier: int64;

begin
  with MainDm do
  begin
    if not ChkBoxYesNo('Are you sure that you want to undo administration?',
      False) then
      exit;
    try

      LPrescriptionIdentifier := StrToInt64(lbePrescriptionIdentifier.Text);
      LOrderIdentifier := StrToInt64(lbeOrderIdentifier.Text);
      LEffectuationIdentifier := StrToInt64(lbeEffectuationIdentifier.Text);

      FMKUndoEffectuation(lbeKundenr.Text, TFMKPersonIdentifierSource.DetectSource(lbeKundenr.Text),
        LPrescriptionIdentifier, LOrderIdentifier, LEffectuationIdentifier, False);

    except
      on E: Exception do
        ChkBoxOK(E.Message);
    end;

  end;
end;

procedure TfmUndo.FormShow(Sender: TObject);
begin
  if not Kundenr.IsEmpty then
    lbeKundenr.Text := Kundenr;

  if PrescriptionIdentifier <> 0 then
    lbePrescriptionIdentifier.Text := PrescriptionIdentifier.ToString;

  if OrderIdentifier <> 0 then
    lbeOrderIdentifier.Text := OrderIdentifier.ToString;

  if EffectuationIdentifier <> 0 then
    lbeEffectuationIdentifier.Text := EffectuationIdentifier.ToString;


end;

class procedure TfmUndo.Showform(AKundenr: string;
      APrescriptionIdentifier, AOrderIdentifier,
      AEffectuationIdentifier: int64);
begin
  with TfmUndo.Create(Nil) do
  begin
    try
      PrescriptionIdentifier := APrescriptionIdentifier;
      OrderIdentifier := AOrderIdentifier;
      EffectuationIdentifier := AEffectuationIdentifier;
      Kundenr := AKundenr;
      ShowModal;
    finally
      Free;
    end;
  end;
end;

end.
