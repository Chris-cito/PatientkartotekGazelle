unit frmDosis;

{ Developed by: Vitec Cito A/S

  Description: Show dosis info if the patient has a FMK card

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  10-06-2021/MA   Fixed access violation in RefreshDDCardsGrid.

  06-06-2021/MA   Modified to support various PersonIdentifierSources (X-eCPR, etc.).

  11-08-2020/cjs  Added packing group name to dosis card information

  10-08-2020/cjs  return result true if patient is not digits which means that taksering
  is allowed

  10-08-2020/cjs  Changed call to get dosis info so only 10 digit kundenr are accepted

  21-07-2020/cjs  Added routine to check where the dosiscard is being handled at a
  lokation mentioned in RS_Settings

  17-07-2020/cjs  Handle exception when getting dosis info for non fmk patients

  12-07-2020/CJS  Redesigned the dosis warning screen to use info from FMK
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,
  // Grids, DBGrids, DB,
  nxdb,
  cxGraphics,
  cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData,
  cxDataStorage, cxEdit,
  cxNavigator, cxCheckBox, cxGridLevel,
  cxGridCustomTableView,
  cxGridTableView, cxClasses, cxGridCustomView, cxGrid,
  uC2FMK.DoseDispensingCard.Classes, uC2FMK.API.DoseDispensing.Procs, uC2FMK.Common.Types,
  frmFMKMedicineCardAsPDFViewer,
  uRS_Settings.Tables,
  Vcl.PlatformDefaultStyleActnCtrls, System.Actions, Vcl.ActnList, Vcl.ActnMan, C2MainLog, cxFilter, cxData, dxDateRanges,
  dxScrollbarAnnotations;

type
  TfrmDosiskort = class(TForm)
    Panel1: TPanel;
    lblQuestion: TLabel;
    bitJa: TBitBtn;
    bitNej: TBitBtn;
    bitOK: TBitBtn;
    cxGridDDCards: TcxGrid;
    cxGridDDCardsTableView1: TcxGridTableView;
    cxGridDDCardsTableView1Column1: TcxGridColumn;
    cxGridDDCardsTableView1Column2: TcxGridColumn;
    cxGridDDCardsTableView1Column3: TcxGridColumn;
    cxGridDDCardsLevel1: TcxGridLevel;
    btnVisKort: TButton;
    ActionManager1: TActionManager;
    acVisDoskort: TAction;
    cxGridDDCardsTableView1Column4: TcxGridColumn;
    acLuk: TAction;
    procedure FormActivate(Sender: TObject);
    procedure acVisDoskortExecute(Sender: TObject);
    procedure acVisDoskortUpdate(Sender: TObject);
    procedure acLukExecute(Sender: TObject);
  private
    { Private declarations }
    FPersonId: string;
    FPersonIdSource: TFMKPersonIdentifierSource;
    WarnMode: Boolean;

    procedure RefreshDDCardsGrid;
    function CurrentLokation(const ALokation: string): Boolean;

    property PersonId: string read FPersonId write FPersonId;
    property PersonIdSource: TFMKPersonIdentifierSource read FPersonIdSource write FPersonIdSource;
  public
    { Public declarations }
    class function ShowDoskort(const APersonId: string; APersonIdSource: TFMKPersonIdentifierSource): Boolean;
    class procedure WarnDoskort(const APersonId: string; APersonIdSource: TFMKPersonIdentifierSource);
  end;

implementation

uses DM, uYesNo, uC2FMK;

{$R *.dfm}

class function TfrmDosiskort.ShowDoskort(const APersonId: string; APersonIdSource: TFMKPersonIdentifierSource): Boolean;
var
  LFrm: TfrmDosiskort;
begin

  if not(APersonIdSource in [pisCPR, pisXeCPR, pisSORPerson]) then
  // if APersonId.Trim.Length <> 10 then
  begin
    Result := True;
    exit;
  end;

  // 160 are there any dosiscards for the patient?
  C2FMK.LogXMLResponses := False;

  LFrm := TfrmDosiskort.Create(Nil);
  try
    LFrm.PersonId := APersonId;
    LFrm.PersonIdSource := APersonIdSource;
    try
      GetExplicitDoseDispensingCardFromFMK(MainDm.Bruger, MainDm.Afdeling, LFrm.PersonId, LFrm.PersonIdSource,
        MainDm.PatientDosisCards);
    except
      on E: Exception do
        C2LogAdd('Fejl i showdoskort ' + E.Message);
    end;
    if MainDm.PatientDosisCards.Count = 0 then
      exit(True);

    LFrm.WarnMode := False;
    Result := LFrm.ShowModal = mrYes;
    MainDm.PatientDosisCards.Clear;
  finally
    LFrm.Free;
  end;
  C2FMK.LogXMLResponses := True;

end;

class procedure TfrmDosiskort.WarnDoskort(const APersonId: string; APersonIdSource: TFMKPersonIdentifierSource);
var
  LFrm: TfrmDosiskort;
begin
  if not(APersonIdSource in [pisCPR, pisXeCPR, pisSORPerson]) then
    // if APersonId.Trim.Length <> 10 then
    exit;

  C2FMK.LogXMLResponses := False;
  LFrm := TfrmDosiskort.Create(Nil);
  try
    LFrm.PersonId := APersonId;
    LFrm.PersonIdSource := APersonIdSource;
    try
      GetExplicitDoseDispensingCardFromFMK(MainDm.Bruger, MainDm.Afdeling, LFrm.PersonId, LFrm.PersonIdSource,
        MainDm.PatientDosisCards);
    except
      on E: Exception do
        C2LogAdd('Fejl i showdoskort ' + E.Message);
    end;
    if MainDm.PatientDosisCards.Count = 0 then
      exit;
    LFrm.WarnMode := True;
    LFrm.ShowModal;
    MainDm.PatientDosisCards.Clear;
  finally
    LFrm.Free;
  end;
  C2FMK.LogXMLResponses := True;

end;

procedure TfrmDosiskort.RefreshDDCardsGrid;
var
  I: Integer;
  LTC2FMKDoseDispensingCardListEntry: TC2FMKDoseDispensingCardListEntry;
  LDataController: TcxGridDataController;
begin
  LDataController := cxGridDDCardsTableView1.DataController;

  LDataController.RecordCount := MainDm.PatientDosisCards.Count;
  I := 0;
  for LTC2FMKDoseDispensingCardListEntry in MainDm.PatientDosisCards do
  begin
    if I = 0 then
      MainDm.DosiscardLokation := LTC2FMKDoseDispensingCardListEntry.OrderedAtPharmacy.Identifier;
    LDataController.Values[I, 0] := LTC2FMKDoseDispensingCardListEntry.Description;
    LDataController.Values[I, 1] := LTC2FMKDoseDispensingCardListEntry.DoseDispensingOnHold;
    LDataController.Values[I, 2] := LTC2FMKDoseDispensingCardListEntry.OrderedAtPharmacy.Name;
    LDataController.Values[I, 3] := LTC2FMKDoseDispensingCardListEntry.PackingGroupName;
    inc(I);
  end;
end;

function TfrmDosiskort.CurrentLokation(const ALokation: string): Boolean;
var
  LQry: TnxQuery;
begin
  LQry := MainDm.nxdb.OpenQuery('select ' + fnRS_SettingsLokationNr + ' from ' + tnRS_Settings + ' where ' +
    fnRS_SettingsLokationNr_P, [ALokation]);
  try
    Result := not LQry.Eof;
  finally
    LQry.Free;
  end;
end;

procedure TfrmDosiskort.acLukExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmDosiskort.acVisDoskortExecute(Sender: TObject);
begin
  if not CurrentLokation(MainDm.DosiscardLokation) then
  begin
    if not frmYesNo.NewYesNoBox('Har du samtykke fra kunden til at se doseringskortet?') then
      exit;

  end;

  TFormDosiskortPDFViewer.ShowDialog(MainDm.Bruger, MainDm.Afdeling, PersonId, PersonIdSource);
end;

procedure TfrmDosiskort.acVisDoskortUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := MainDm.PatientDosisCards.Count <> 0;
end;

procedure TfrmDosiskort.FormActivate(Sender: TObject);
begin
  if WarnMode then
  begin
    bitJa.Visible := False;
    bitNej.Visible := False;
    bitOK.Visible := True;
    lblQuestion.Caption := 'Kunden har dosiskort. Kontroller om reglen skal gælde for varelinier på kortet.';
    bitOK.SetFocus;
  end
  else
  begin
    bitJa.Visible := True;
    bitNej.Visible := True;
    bitOK.Visible := False;
    bitJa.SetFocus;
  end;
  RefreshDDCardsGrid;

end;

end.
