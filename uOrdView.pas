unit uOrdView;

{ Developed by: Cito IT A/S

  Description: Ordination history

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  06-06-2021/MA   Modified to support various PersonIdentifierSources (X-eCPR, etc.).

  29-01-2021/cjs  New function to manually undo administrations

  06-10-2020/cjs  Adjust the order of the columns and widen the screen to show more
                  info on ordinations oversigt

  14-04-2020/cjs  Correction to iteration number

  08-01-2020/cjs  Fix access violation if there is no effectuation information
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGrids, DB, StdCtrls, uC2FMK.Prescription.Classes,
  uLagerKartotek.Tables,uC2FMK.Package.classes,
  uC2FMK.Common.classes,uC2FMK.Common.types, Datasnap.DBClient, System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.Grids;

type
  TfrmOrdView = class(TForm)
    dbgOrdOversigt: TDBGrid;
    Label1: TLabel;
    edtVarenr: TEdit;
    Label2: TLabel;
    edtNavn: TEdit;
    Label3: TLabel;
    edtForm: TEdit;
    Label4: TLabel;
    edtStyrke: TEdit;
    Label5: TLabel;
    edtPakning: TEdit;
    Label6: TLabel;
    edtAntal: TEdit;
    LabIter: TLabel;
    dsMem: TDataSource;
    mtOrd: TClientDataSet;
    mtOrdID: TStringField;
    mtOrdDateTime: TStringField;
    mtOrdAntal: TStringField;
    mtOrdVarenr: TStringField;
    mtOrdNavn: TStringField;
    mtOrdForm: TStringField;
    mtOrdPakn: TStringField;
    mtOrdLbnr: TStringField;
    mtOrdLinienr: TStringField;
    mtOrdApoName: TStringField;
    mtOrdPrescriptionIdentifier: TLargeintField;
    mtOrdOrderIdentifier: TLargeintField;
    mtOrdEffectuationIdentifier: TLargeintField;
    ActionManager1: TActionManager;
    acUndo: TAction;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure acUndoExecute(Sender: TObject);
  private
    { Private declarations }
    Varenr : string;
    Navn : string;
    VareForm : string;
    Styrke : string;
    Pakning : string;
    Antal : string;
    IterationNr : string;
    IterationInterval : string;
    IterationType : string;
    FCPRNr: string;
    property CPRNr: string read FCPRNr write FCPRNr;
  public
    { Public declarations }
    class procedure ShowOrdView(sl: TStringList); overload;
    class procedure ShowOrdView(APrescription : TC2FMKPrescription;ALagernr : integer; const AKundenr : string); overload;
  end;

implementation

uses C2MainLog, DM,ChkBoxes,uFMKCalls;


{$R *.dfm}

class procedure TfrmOrdView.ShowOrdView(sl: TStringList);
var
  str : string;
begin
  with TfrmOrdView.Create(Nil) do
  begin
    try
      VareNr := '';
      Navn := '';
      VareForm := '';
      Styrke := '';
      Pakning := '';
      Antal := '';
      IterationNr := '';
      IterationInterval := '';
      IterationType := '';
      C2LogAdd('Number of lines in sl is ' + inttostr(sl.count));
      mtOrd.Close;
      mtOrd.Open;
      if mtOrd.RecordCount <> 0 then
      begin
        mtOrd.First;
        while not mtOrd.Eof do
          mtord.Delete;
      end;
      for str in sl do
      begin
        // CJS NEW CODE FOR TOP OF SCREEN
        if copy(str,1,7) =  'VarenNr' then
          Varenr := trim(copy(str,11,30));
        if copy(str,1,4) =  'Navn' then
          Navn := trim(copy(str,8,30));
        if copy(str,1,4) =  'Form' then
          VareForm := trim(copy(str,8,30));
        if copy(str,1,6) =  'Styrke' then
          Styrke := trim(copy(str,10,30));
        if copy(str,1,7) =  'Pakning' then
          Pakning := trim(copy(str,11,30));
        if copy(str,1,5) =  'Antal' then
          Antal := trim(copy(str,9,30));
        if copy(str,1,11) =  'IterationNr' then
          IterationNr := trim(copy(str,15,30));
        if copy(str,1,17) =  'IterationInterval' then
          IterationInterval  := trim(copy(str,21,30));
        if copy(str,1,13) =  'IterationType' then
          IterationType := trim(copy(str,17,30));

        if copy(str,1,9) = 'AdmDoneId' then
        begin
          if mtOrd.State = dsinsert then
            mtOrd.Post;
          mtOrd.Insert;
          mtOrdID.AsString := trim(copy(str,13,20));
        end;
        if copy(str,1,15) =  'AdmDoneDateTime' then
          mtOrdDateTime.AsString := trim(copy(str,19,30));
        if copy(str,1,11) =  'AdmDoneLbnr' then
          mtOrdLbnr.AsString := trim(copy(str,15,30));
        if copy(str,1,14) =  'AdmDoneLinienr' then
          mtOrdLinienr.AsString := trim(copy(str,18,30));
        if copy(str,1,17) =  'AdmDoneApotekName' then
          mtOrdApoName.AsString := trim(copy(str,21,30));
        if copy(str,1,13) =  'AdmDoneVarenr' then
          mtOrdVarenr.AsString := trim(copy(str,17,30));
        if copy(str,1,11) =  'AdmDoneNavn' then
          mtOrdNavn.AsString := trim(copy(str,15,30));
        if copy(str,1,11) =  'AdmDoneForm' then
          mtOrdForm.AsString := trim(copy(str,15,30));
        if copy(str,1,11) =  'AdmDonePakn' then
          mtOrdPakn.AsString := trim(copy(str,15,30));
        if copy(str,1,12) =  'AdmDoneAntal' then
          mtOrdAntal.AsString := trim(copy(str,16,30));


      end;
      if mtOrd.State = dsinsert then
        mtOrd.Post;

      ShowModal;
    finally
      mtOrd.Close;
      Free;
    end;
  end;
end;

procedure TfrmOrdView.FormShow(Sender: TObject);
var
  linetxt : string;
  iterint : integer;
  itertype : string;
begin
  edtVarenr.Text := Varenr;
  edtNavn.Text := Navn;
  edtForm.Text := VareForm;
  edtStyrke.Text := Styrke;
  edtPakning.Text := Pakning;
  edtAntal.Text := Antal;

  try
    linetxt := 'Udleveres ' +  inttostr(strtoint(IterationNr) );
    if strtoint(IterationNr) = 1 then
      linetxt := linetxt + ' gang'
    else
      linetxt := linetxt + ' gange';

    if strtoint(IterationInterval) <> 0 then
    begin
      iterint := strtoint(IterationInterval);
      itertype := IterationType;
      if iterint > 1 then
      begin
        if itertype = 'dag' then
          itertype := 'dages';
        if itertype = 'uge' then
          itertype := 'ugers';

        if itertype = 'måned' then
          itertype := 'måneders';

      end
      else
      begin
        if itertype = 'dag' then
          itertype := 'dags';
        if itertype = 'uge' then
          itertype := 'uges';

        if itertype = 'måned' then
          itertype := 'måneds';

      end;

      linetxt := linetxt + ' med ' + IntToStr(iterint)
                          + ' ' + itertype + ' mellemrum';

      LabIter.Caption := linetxt;
    end;
  except

  end;

end;

class procedure TfrmOrdView.ShowOrdView(APrescription : TC2FMKPrescription; ALagernr : integer; const AKundenr : string);
var
  LOrder : TC2FMKOrder;

  function GetDrugForm(ALager: integer; const AVarenr : string) : string;
  begin
    Result := '';
    try

      with MainDM.nxdb.OpenQuery('#T 30000' + ' select top 1 ' +
        fnLagerKartotekForm + ' from ' + tnLagerKartotek + ' where ' +
        fnLagerKartotekLager_P + ' and ' + fnLagerKartotekVareNr_P,
        [ALagernr, AVarenr]) do
      begin
        if not Eof then
        begin
          Result := FieldByName(fnLagerKartotekForm).AsString;
        end;

        Free;
      end;
    except
      on E: Exception do
        C2LogAdd(Format('Fejl i GetDrugForm %d %s %s',[ALager,AVarenr,e.Message]));
    end;

  end;
begin
  if APrescription = Nil then
    exit;

  with TfrmOrdView.Create(Nil) do
  begin
    FCPRNr := AKundenr;
    mtOrd.Close;
    mtOrd.Open;
    if mtOrd.RecordCount <> 0 then
    begin
      mtOrd.First;
      while not mtOrd.Eof do
        mtOrd.Delete;
    end;
    dbgOrdOversigt.Columns.Items[7].Visible := False;
    dbgOrdOversigt.Columns.Items[8].Visible := False;

    try

      with APrescription do
      begin
        Varenr := '';
        Navn := '';
        VareForm := '';
        Styrke := '';
        Pakning := '';
        Antal := '1';
        IterationNr := '';
        IterationInterval := '';
        IterationType := '';
        if PackageRestriction <> Nil then
        begin
          Varenr := PackageRestriction.PackageNumber.ToVnr;
          Antal := PackageRestriction.PackageQuantity.ToString;
        end;

        with Drug do
        begin
          Navn := Name.trim;
          if Assigned(Drug.Form) then
            VareForm := Drug.Form.Text.trim;
          if Assigned(Strength) then
            Styrke := Strength.Text.trim;

          if (PackageRestriction <> Nil) then
          begin
            if (PackageRestriction.PackageSize <> Nil) then
              Pakning := PackageRestriction.PackageSize.PackageSizeText.trim;

            IterationNr := PackageRestriction.IterationNumber.ToString;
            IterationInterval := PackageRestriction.IterationInterval.ToString;
            IterationType := PackageRestriction.IterationIntervalUnit.tostring;

          end;
        end;

        // if no varenr then get the largest pack using drugid and set the varenr and packsize
        if Varenr = '' then
        begin
          if (Assigned(Drug)) and (Assigned(Drug.Identifier)) then
          begin
            try
              with MainDM.nxdb.OpenQuery('#T 30000' + ' select top 1 ' +
                fnLagerKartotekVareNr + ',' + fnLagerKartotekPakning +
                ' from ' + tnLagerKartotek + ' where ' +
                fnLagerKartotekLager_P + ' and ' + fnLagerKartotekDrugId_P
                + ' and ' + fnLagerKartotekAfmDato + ' is null' +
                ' order by ' + fnLagerKartotekPaknNum + ' desc',
                [ALagernr,
                Drug.Identifier.Identifier.tostring]) do
              begin
                if not Eof then
                begin
                  Varenr := FieldByName(fnLagerKartotekVareNr).AsString;
                  Pakning := FieldByName(fnLagerKartotekPakning).AsString;
                end;

                Free;
              end;
            except
              on e: Exception do
                C2LogAdd(e.Message);

            end;
          end;

        end;

        for LOrder in Orders do
        begin
          if LOrder.Status = osBestilt then
            continue;

          if LOrder.Effectuation = Nil then
          continue;
          if LOrder.Effectuation.PackageDispensed = Nil then
          continue;

          mtOrd.Insert;
          mtOrdID.AsString := LOrder.Identifier.toString;
          mtOrdDateTime.AsString := FormatDateTime('yyyy-mm-dd hh:mm:ss',LOrder.Effectuation.DateTime);
          with LOrder.Effectuation.PackageDispensed do
          begin
            mtOrdAntal.AsString := PackageQuantity.ToString;
            mtOrdVarenr.AsString := PackageNumber.ToVnr;
            mtOrdNavn.AsString := Navn;
            if SubstitutedDrug <> Nil then
              mtOrdNavn.AsString := SubstitutedDrug.Name;

            mtOrdForm.AsString := GetDrugForm(ALagernr,mtOrdVarenr.AsString);
            mtOrdPakn.AsString := PackageSize.PackageSizeText;
            mtOrdLbnr.AsString := '';
            mtOrdLinienr.AsString := '';
            mtOrdApoName.AsString := LOrder.Effectuation.DeliverySite.Name;
            mtOrdPrescriptionIdentifier.AsLargeInt := APrescription.Identifier;
            mtOrdOrderIdentifier.AsLargeInt := LOrder.Identifier;
            mtOrdEffectuationIdentifier.AsLargeInt := LOrder.Effectuation.Identifier;
          end;
          mtord.Post;
        end;

        //
        // if copy(str,1,9) = 'AdmDoneId' then
        // begin
        // if mtOrd.State = dsinsert then
        // mtOrd.Post;
        // mtOrd.Insert;
        // mtOrdID.AsString := trim(copy(str,13,20));
        // end;
        // if copy(str,1,15) =  'AdmDoneDateTime' then
        // mtOrdDateTime.AsString := trim(copy(str,19,30));
        // if copy(str,1,11) =  'AdmDoneLbnr' then
        // mtOrdLbnr.AsString := trim(copy(str,15,30));
        // if copy(str,1,14) =  'AdmDoneLinienr' then
        // mtOrdLinienr.AsString := trim(copy(str,18,30));
        // if copy(str,1,17) =  'AdmDoneApotekName' then
        // mtOrdApoName.AsString := trim(copy(str,21,30));
        // if copy(str,1,13) =  'AdmDoneVarenr' then
        // mtOrdVarenr.AsString := trim(copy(str,17,30));
        // if copy(str,1,11) =  'AdmDoneNavn' then
        // mtOrdNavn.AsString := trim(copy(str,15,30));
        // if copy(str,1,11) =  'AdmDoneForm' then
        // mtOrdForm.AsString := trim(copy(str,15,30));
        // if copy(str,1,11) =  'AdmDonePakn' then
        // mtOrdPakn.AsString := trim(copy(str,15,30));
        // if copy(str,1,12) =  'AdmDoneAntal' then
        // mtOrdAntal.AsString := trim(copy(str,16,30));
        //
        //
        // end;
        // if mtOrd.State = dsinsert then
        // mtOrd.Post;
        //
      end;
      ShowModal;
    finally
      mtOrd.Close;
      Free;
    end;
  end;
end;

procedure TfrmOrdView.acUndoExecute(Sender: TObject);
begin
  if not ChkBoxYesNo('Are you sure that you want to undo administration?',False) then
    exit;

  FMKUndoEffectuation(CPRNr, TFMKPersonIdentifierSource.DetectSource(CPRNr), mtOrdPrescriptionIdentifier.AsLargeInt,
      mtOrdOrderIdentifier.AsLargeInt,mtOrdEffectuationIdentifier.AsLargeInt,False)


end;

procedure TfrmOrdView.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then
    ModalResult := mrCancel;
  if key = #13 then
    ModalResult := mrCancel;
end;

end.
