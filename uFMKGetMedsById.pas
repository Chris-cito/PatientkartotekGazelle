unit uFMKGetMedsById;

{ Developed by: Cito IT A/S

  Description: Getmedications from FMK by Id

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  21-02-2022/cjs  Changed Fmkgetmedbyid (used by eordres) to not use consent by default,
                  but if the prescription is  marked as private then try again with consent

  25-08-2021/cjs  Check that ordnations are valid before allowing them to be taksered
  20-08-2021/cjs  Changed FMKGetMedById to check the date validity of the prescription

  15-01-2021/cjs  Fix to asylansøger not gettings prescriptions under behandling

  13-01-2020/cjs  Removed extra logging of FMK data which is already logged in
                  FMK Classes

  14-12-2020/cjs  Check fields exist in clientdatasét in savetorseksplinier fixes
                  issue where fields are added to rs_eksplinier like bestilafpatient

  12-11-2020/cjs  removed messagebox from fmkgetmedbyid as the error message is
                  processed after the call

  07-11-2020/cjs  change to FMKGetMedById to return error string from StartEffectuation
                  request.

  25-09-2020/CJS  Ehandel messages changed to show product name if the ordination
                  is under behandling

  24-09-2020/cjs  Ehandel now correctly deals with under behandling ordinations

  23-04-2020/cjs  Fixed access violation if getmeds by id fails due to exeception

  19-03-2020/cjs  Popup the reasontext if starteffectuation fails

  09-03-2020/cjs  Changed ProcessPrescriptionsForPersonOrOrganisati on in line with changes made by MA
                  in C2HentAdresseret

  26-02-2020/cjs  return false if Starteffectuation does not work

  20-02-2020/cjs  Changed ProcessPrescriptionsForPersonOrOrganisation to only update fields for order
                  that is bestilt.

  01-02-2020/cjs  Copy the processing of a prescription from C2hentaddresseret to incoroprate the
                  new patient and organisation fields (used for kundenr with valid cpr)

  29-01-2020/cjs  Save the ektra bestil info in rs_eksplinier if modified by segment is available
                  from FMK

  14-01-2020/cjs  Use new Drug.DrugName property
}

interface
uses
  System.Classes, System.SysUtils, System.DateUtils, Data.DB, Datasnap.DBClient,
  uC2FMK.Prescription.Classes, uRCPMidCli,winapi.windows;



function FMKGetPrescriptionById(AAfdelingsnr: Integer;
  APrescription: TC2FMKPrescription; ASetUnderBehandling: boolean; var AReceptId : integer; var AErrorString :string): boolean;

function FMKGetMedById(AKundeNr: string; AMedId: string; AAfdelingsnr: Integer;
  var AReceptId: Integer; APrintRecept: boolean;
  ASetInProgress : boolean;  var AErrorString: string): boolean;

function FMKGetPrescriptionByMedId(AKundeNr : string;AMedId: string;  AAfdelingsNr: integer;
  var AErrorString: string): TC2FMKPrescription;

function RefreshReceivedMedications(AKundenr : string;APrivate : integer;AMedId: string;
  AAfdelingsNr: integer;AReceptId : integer;ADosis : boolean = False; ASetInProgress : boolean= True ): boolean;


implementation

uses
  DM, C2MainLog,
  uRS_Ekspeditioner.Tables, uRS_EkspLinier.Tables,
  uC2FMK, uC2Afdeling.Classes, uC2Bruger.Types, uC2FMK.Common.Types,
  uC2FMK.PersonOrganisation.Classes, ChkBoxes,uYesNo,uc2ui.mainlog.procs;


function SaveToDatabase(ARSEkspeditioner, ARSEkspLinier: TClientDataSet;var AReceptid : integer): Boolean;
var
  LFld: TField;
begin
  C2LogAdd('SaveToDatabase - begin');

  with MainDM do
  begin
    ffRcpOpl.DataBase.StartTransactionWith([nxRSEkspeditioner, nxRSEkspLinier, nxSettings]);
    try
      // Now we create RS_Ekspeditioner and RS_EkspLinier from the cds
      ARSEkspeditioner.First;
      while not ARSEkspeditioner.Eof do
      begin
        nxRSEkspeditioner.Append;
        // Get receptid number
        nxSettings.IndexName := 'IdOrder';
        nxSettings.First;
        nxSettings.Edit;
        nxRSEkspeditioner.FieldByName(fnRS_EkspeditionerReceptId).AsInteger := nxSettingsReceptNo.AsInteger;
        nxSettingsReceptNo.AsInteger := nxSettingsReceptNo.AsInteger + 1;
        nxSettings.Post;
        AReceptid := nxRSEkspeditioner.FieldByName(fnRS_EkspeditionerReceptId).AsInteger;
        for LFld in nxRSEkspeditioner.Fields do
        begin
          if not SameText(LFld.FieldName, fnRS_EkspeditionerReceptId) then
            nxRSEkspeditioner.FieldByName(LFld.FieldName).Value := ARSEkspeditioner.FieldByName(LFld.FieldName).Value;
        end;
        // Set ordant to zero at start of adding lines
        nxRSEkspeditioner.FieldByName(fnRS_EkspeditionerOrdant).AsInteger := 0;
        ARSEkspLinier.First;
        while not ARSEkspLinier.Eof do
        begin
          // Increase header ordant by 1 and use that as ordnr
          nxRSEkspeditioner.FieldByName(fnRS_EkspeditionerOrdant).AsInteger :=
            nxRSEkspeditioner.FieldByName(fnRS_EkspeditionerOrdant).AsInteger + 1;
          nxRSEkspLinier.Append;
          for LFld in nxRSEkspLinier.Fields do
          begin

            // new rs_eksplinier fmk field PrescriptionIdientifier
            if SameText(LFld.FieldName, fnRS_EksplinierPrescriptionIdentifier) then
            begin
              nxRSEkspLinier.FieldByName(LFld.FieldName).AsLargeInt := StrToInt64(ARSEkspLinier.FieldByName(fnRS_EkspLinierOrdId).AsString);
              continue;
            end;

            // new rs_eksplinier fmk field OrderIdientifier
            if SameText(LFld.FieldName, fnRS_EksplinierOrderIdentifier) then
            begin
              nxRSEkspLinier.FieldByName(LFld.FieldName).AsLargeInt := ARSEkspLinier.FieldByName(fnRS_EkspLinierAdministrationId).AsLargeInt;
              continue;
            end;

            // new rs_eksplinier fmk field EffectuationIdientifier
            if SameText(LFld.FieldName, fnRS_EksplinierEffectuationIdentifier) then
            begin
              nxRSEkspLinier.FieldByName(LFld.FieldName).AsLargeInt := 0;
              continue;
            end;

            if ARSEkspLinier.FindField(LFld.FieldName) <> Nil then
            begin
              if not SameText(LFld.FieldName, fnRS_EkspLinierReceptId) then
                nxRSEkspLinier.FieldByName(LFld.FieldName).Value := ARSEkspLinier.FieldByName(LFld.FieldName).Value
              else
                nxRSEkspLinier.FieldByName(LFld.FieldName).Value := nxRSEkspeditioner.FieldByName(LFld.FieldName).Value;
            end;
          end;
          nxRSEkspLinier.FieldByName(fnRS_EkspLinierOrdNr).AsInteger := nxRSEkspeditioner.FieldByName(fnRS_EkspeditionerOrdAnt).AsInteger;
          nxRSEkspLinier.Post;
          ARSEkspLinier.Next;
        end;

        nxRSEkspeditioner.Post;

        ARSEkspeditioner.Next;
      end;

      ffRcpOpl.DataBase.Commit;

      Result := True;
    except
      on E: Exception do
      begin
        Result := False;
        C2LogAdd('Exception: "' + E.Message + '"');
        ffRcpOpl.DataBase.Rollback;
      end;
    end;
  end;

  C2LogAdd('SaveToDatabase - end');
end;



/// <summary>Joins prescriptions.</summary>
function CheckFMKcds(ARSEkspeditioner, ARSEkspLinier, ARSJoinedEkspeditioner, ARSJoinedEkspLinier: TClientDataSet;
  AAP4Prescriptions, ADosisPrescriptions: TStrings;
  cprnr, ydernr, ydercprnr, autnr, EftNavn, ForNavn, levinfo, levpri, levadr, levpseu, levpostnr, levkontakt: string): Boolean;
var
  LAP4Found: Boolean;
  LDosisFound: Boolean;
  LFound: Boolean;

  procedure AddEkspeditioner;
  var
    LFld: TField;
  begin
    ARSJoinedEkspeditioner.Append;
    for LFld in ARSEkspeditioner.Fields do
      ARSJoinedEkspeditioner.FieldByName(LFld.FieldName).Value := LFld.Value;
    ARSJoinedEkspeditioner.Post;
  end;

  procedure AddLines;
  var
    LFld: TField;
  begin
    ARSEkspLinier.First;
    while not ARSEkspLinier.Eof do
    begin
      ARSJoinedEkspLinier.Append;
      for LFld in ARSEkspLinier.Fields do
        ARSJoinedEkspLinier.FieldByName(LFld.FieldName).Value := LFld.Value;
      ARSJoinedEkspLinier.Post;
      ARSEkspLinier.Next;
    end;
  end;

  function FMKCheckForAP4(APrescriptionId: string): Boolean;
  var
    LUdlevType: string;
  begin
    C2LogAdd('Check PrescriptionID ' + APrescriptionId + ' for AP4');
    Result := False;

    ARSEkspLinier.First;
    while not ARSEkspLinier.Eof do
    begin
      if (MainDM.GetVareUdlevType(MainDM.nxdb, ARSEkspLinier.FieldByName(fnRS_EkspLinierVarenNr).AsString, LUdlevType)) and
         (LUdlevType = 'AP4') then
      begin
        AAP4Prescriptions.Add(APrescriptionId);
        Result := True;
        Break;
      end;
      ARSEkspLinier.Next;
    end;
  end;

  function FMKCheckForDosis(APrescriptionId: string): Boolean;
  begin
    C2LogAdd('Check PrescriptionID ' + APrescriptionId + ' for dosis dispensering');
    Result := False;

    ARSEkspLinier.First;
    while not ARSEkspLinier.Eof do
    begin
      if ARSEkspLinier.FieldByName(fnRS_EkspLinierDosStartDato).AsString <> '' then
      begin
        C2LogAdd('  Er dosis dispenseret');
        ADosisPrescriptions.Add(APrescriptionId);
        Result := True;
        break;
      end;
      ARSEkspLinier.Next;
    end;
  end;

begin
  C2LogAdd('CheckFMKcds ' + cprnr + ' - begin');

  try
    // If patient has no cprnr then dont group together
    LAP4Found := FMKCheckForAP4(ARSEkspeditioner.FieldByName(fnRS_EkspeditionerPrescriptionId).AsString);
    LDosisFound := FMKCheckForDosis(ARSEkspeditioner.FieldByName(fnRS_EkspeditionerPrescriptionId).AsString);
    LFound := False;

    if (not LAP4Found) and (not LDosisFound) then
    begin
      with ARSJoinedEkspeditioner do
      begin
        First;
        while not Eof do
        begin
          try
            if (cprnr <> FieldByName(fnRS_EkspeditionerPatCPR).AsString) or
               (ydernr <> FieldByName(fnRS_EkspeditionerSenderId).AsString) or
               (ydercprnr <> FieldByName(fnRS_EkspeditionerIssuerCPRNr).AsString) or
               (autnr <> FieldByName(fnRS_EkspeditionerIssuerAutNr).AsString) or
               (EftNavn <> FieldByName(fnRS_EkspeditionerPatEftNavn).AsString) or
               (ForNavn <> FieldByName(fnRS_EkspeditionerPatForNavn).AsString) or
               (levinfo <> FieldByName(fnRS_EkspeditionerLeveringsInfo).AsString) or
               (levpri <> FieldByName(fnRS_EkspeditionerLeveringPri).AsString) or
               (levadr <> FieldByName(fnRS_EkspeditionerLeveringAdresse).AsString) or
               (levpseu <> FieldByName(fnRS_EkspeditionerLeveringPseudo).AsString) or
               (levpostnr <> FieldByName(fnRS_EkspeditionerLeveringPostNr).AsString) or
               (levkontakt <> FieldByName(fnRS_EkspeditionerLeveringKontakt).AsString) or
               // Skip over any AP4 prescriptions we might have
               (AAP4Prescriptions.IndexOf(FieldByName(fnRS_EkspeditionerPrescriptionId).AsString) <> -1) or
               // Skip over any dosis prescriptions we might have
               (ADosisPrescriptions.IndexOf(FieldByName(fnRS_EkspeditionerPrescriptionId).AsString) <> -1) then
              Continue;

            // If we get here then everything matches
            LFound := True;
            Break;
          finally
            // Only go to next record if we have not found a matching record
            if not LFound then
              Next;
          end;
        end;
      end;
    end;

    if not LFound then
    begin
      C2LogAdd('Not found in Joined cds... so add it and get out');
      AddEkspeditioner;
      AddLines;
    end
    else
    begin
      C2LogAdd('Found in Joined cds so just add lines');
      AddLines;
    end;

    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
      C2LogAdd('Exception: "' + E.Message + '"');
    end;
  end;

  C2LogAdd('CheckFMKcds ' + cprnr + ' - end');
end;



procedure JoinFMKRecepter(ARSEkspeditioner, ARSEkspLinier, ARSJoinedEkspeditioner, ARSJoinedEkspLinier: TClientDataSet);
var
  LAP4Prescriptions: TStrings;
  LDosisPrescriptions: TStrings;
begin
  C2LogAdd('JoinFMKRecepter - begin');

  LAP4Prescriptions := TStringList.Create;
  LDosisPrescriptions := TStringList.Create;

  // Now join any prescriptions together that we can
  ARSJoinedEkspeditioner.EmptyDataSet;
  ARSJoinedEkspeditioner.LogChanges := False;
  with ARSEkspeditioner do
  begin
    First;
    while not Eof do
    begin
      CheckFMKcds(ARSEkspeditioner, ARSEkspLinier, ARSJoinedEkspeditioner, ARSJoinedEkspLinier,
        LAP4Prescriptions, LDosisPrescriptions,
        FieldByName(fnRS_EkspeditionerPatCPR).AsString,
        FieldByName(fnRS_EkspeditionerSenderId).AsString,
        FieldByName(fnRS_EkspeditionerIssuerCPRNr).AsString,
        FieldByName(fnRS_EkspeditionerIssuerAutNr).AsString,
        FieldByName(fnRS_EkspeditionerPatEftNavn).AsString,
        FieldByName(fnRS_EkspeditionerPatForNavn).AsString,
        FieldByName(fnRS_EkspeditionerLeveringsInfo).AsString,
        FieldByName(fnRS_EkspeditionerLeveringPri).AsString,
        FieldByName(fnRS_EkspeditionerLeveringAdresse).AsString,
        FieldByName(fnRS_EkspeditionerLeveringPseudo).AsString,
        FieldByName(fnRS_EkspeditionerLeveringPostNr).AsString,
        FieldByName(fnRS_EkspeditionerLeveringKontakt).AsString);
      Next;
    end;
  end;

  {$IFDEF DEBUG}
  ARSJoinedEkspeditioner.SaveToFile('C:\C2\Temp\RSEksp2FMK-' + MainDM.FileSuffix + '.xml', dfXML);
  {$ENDIF}

  LAP4Prescriptions.Free;
  LDosisPrescriptions.Free;

  C2LogAdd('JoinFMKRecepter - end');
end;



// This routine will look for the ordination id in rs_eksplinier
// if the rslbnr is 0 and check the version number
// if the version nuimber is the same then delete the newly received ordination
// if the version number s diffrent then delete the one in rs_eksplinier
//  if deleting the line from either table leaves a header with no lines
// then delete the header as well.
procedure HandleExistingOrdinationId(ARSEkspeditioner, ARSEkspLinier: TClientDataSet);
var
  save_RSLinindex: string;
  save_RSIndex: string;
  OrdId: string;
  Receptid: Integer;
begin
  C2LogAdd('HandleExistingOrdinationId - begin');

  with MainDM do
  begin
    ARSEkspeditioner.First;
    while not ARSEkspeditioner.Eof do
    begin
      ARSEkspLinier.First;
      while not ARSEkspLinier.Eof do
      begin
        Receptid := 0;
        OrdId := ARSEkspLinier.FieldByName(fnRS_EkspLinierOrdId).AsString;
        C2LogAdd('Search for ordid ' + OrdId);
        save_RSLinindex := nxRSEkspLinier.IndexName;
        nxRSEkspLinier.IndexName := 'OrdidOrden';
        nxRSEkspLinier.SetRange([OrdId], [OrdId]);
        try
          if not nxRSEkspLinier.IsEmpty then
          begin
            C2LogAdd('Found stored records matching ordid');
            nxRSEkspLinier.First;
            while not nxRSEkspLinier.Eof do
            begin
              // Has the current line been taksered
              if nxRSEkspLinier.FieldByName(fnRS_EkspLinierRSLbnr).AsInteger = 0 then
              begin
                C2LogAdd('Found a line that has not been taksered');
                // check the version number if its the same discard new line
                if ARSEkspLinier.FieldByName(fnRS_EkspLinierVersion).AsString =
                  nxRSEkspLinier.FieldByName(fnRS_EkspLinierVersion).AsString then
                begin
                  C2LogAdd('Same version number already stored so delete newly received one');
                  ARSEkspLinier.Delete;
                end
                else
                begin
                  C2LogAdd('Different version so delete the current saved line');
                  // Store the current receptid this is used to check whether the saved ekspedition is now empty
                  Receptid := nxRSEkspLinier.FieldByName(fnRS_EkspLinierReceptId).AsInteger;
                  // Delete the saved line
                  nxRSEkspLinier.Delete;

                  ARSEkspLinier.Edit;
                  ARSEkspLinier.FieldByName(fnRS_EkspLinierVersion).AsString :=
                    ARSEkspLinier.FieldByName(fnRS_EkspLinierVersion).AsString + ' *';
                  ARSEkspLinier.Post;
                end;

                // Handled the saved ekspedition so get out
                Break;
              end;
              nxRSEkspLinier.Next;
            end;
          end;
        finally
          nxRSEkspLinier.CancelRange;
          nxRSEkspLinier.IndexName := save_RSLinindex;
        end;

        // If we have deleted an RSEksplinier then check to see if the receptid is now empty if it is then delete the header
        if Receptid <> 0 then
        begin
          C2LogAdd('Deleted a line from receptid ' + Receptid.ToString);
          C2LogAdd('Need to check that there are any lines left on the saved RS_Ekspeditioner');
          save_RSLinindex := nxRSEkspLinier.IndexName;
          nxRSEkspLinier.IndexName := 'ReceptIdOrder';
          nxRSEkspLinier.SetRange([Receptid], [Receptid]);
          try
            // no records left so find the header and delete it
            if nxRSEkspLinier.RecordCount = 0 then
            begin
              C2LogAdd('Delete the rs_ekspeditioner header record');

              save_RSIndex := nxRSEkspeditioner.IndexName;
              nxRSEkspeditioner.IndexName := 'ReceptIdOrder';

              try
                if nxRSEkspeditioner.FindKey([ReceptId]) then
                  nxRSEkspeditioner.Delete;
              finally
                nxRSEkspeditioner.IndexName := save_RSIndex;
              end;
            end;
          finally
            nxRSEkspLinier.CancelRange;
            nxRSEkspLinier.IndexName := save_RSLinindex;
          end;
        end;

        ARSEkspLinier.Next;
      end;

      // if there are no lines left under the current received expedition
      // then delete it else get the next
      if ARSEkspLinier.RecordCount = 0 then
      begin
        C2LogAdd('No lines left in received ekspeditioner so delete the header');
        ARSEkspeditioner.Delete;
      end
      else
        ARSEkspeditioner.Next;
    end;
  end;

  C2LogAdd('HandleExistingOrdinationId - end');
end;



/// <summary>Processes prescription from FMK like GetNewOrders.</summary>
procedure ProcessPrescription(APrescription: TC2FMKPrescription;
  ARSEkspeditioner, ARSEkspLinier: TClientDataSet);
var
  I: Integer;
  LAdmDateTime: TDateTime;
  LApotekBem: string;
  LIgnorePrescription: Boolean;
  LDosageDatesFound: Boolean;
  LOrder: TC2FMKOrder;
  LVarenr: string;
  S: string;
  LBestiltAfAuthHP: TC2FMKAuthorisedHealthcareProfessional;
  LBestiltAfOrg: TC2FMKOrganisation;
  LBestiltAfOther: TC2FMKModificatorPerson;
begin
  C2LogAdd('ProcessPrescriptionsForPersonOrOrganisation - begin');

    try
      with ARSEkspeditioner do
      begin
        Insert;

        FieldByName(fnRS_EkspeditionerPrescriptionId).AsString := APrescription.Identifier.ToString; // Yes, it's not the same as RS PrescriptionId, but that doesn't exist in FMK
        FieldByName(fnRS_EkspeditionerLbNr).AsInteger := 0;
        FieldByName(fnRS_EkspeditionerOrdant).AsInteger := 0;
        FieldByName(fnRS_EkspeditionerDato).AsDateTime := Now;
        FieldByName(fnRS_EkspeditionerAfdeling).AsInteger := MainDM.mtAfdelingAfdelingNr.AsInteger; { TODO : 04-05-2021/MA: I think this is a copy/paste mistake. This mtAfdeling does not contain any records... }
        FieldByName(fnRS_EkspeditionerReceptStatus).AsInteger := 5;



        // Prescription.Created.By (SearchSender procedure in RS logic)
        with APrescription.Created.By do
        begin
          if Assigned(Organisation) then
          begin
            FieldByName(fnRS_EkspeditionerSenderType).AsString := Organisation.IdentifierSource.ToRSString;
            case Organisation.IdentifierSource of
              oisSKS: FieldByName(fnRS_EkspeditionerSenderId).AsString := Organisation.Identifier.PadRight(7, '0');
              oisEANLokationsnummer: FieldByName(fnRS_EkspeditionerSenderId).AsString := Organisation.Identifier;
              oisSOR: FieldByName(fnRS_EkspeditionerSenderId).AsString := Organisation.Identifier;
            else
              FieldByName(fnRS_EkspeditionerSenderId).AsString := Organisation.Identifier.PadLeft(7, '0');
            end;
            FieldByName(fnRS_EkspeditionerSenderNavn).AsString := Organisation.Name;
            FieldByName(fnRS_EkspeditionerSenderVej).AsString := Organisation.AddressLine1;
            FieldByName(fnRS_EkspeditionerSenderPostNr).AsString := Organisation.PostCodeIdentifier;
            FieldByName(fnRS_EkspeditionerSenderTel).AsString := Organisation.TelephoneNumber;
          end;
          if Assigned(AuthorisedHealthcareProfessional) then
          begin
            FieldByName(fnRS_EkspeditionerIssuerAutNr).AsString := AuthorisedHealthcareProfessional.AuthorisationIdentifier;
            FieldByName(fnRS_EkspeditionerIssuerTitel).AsString := AuthorisedHealthcareProfessional.Name;
            FieldByName(fnRS_EkspeditionerIssuerSpecKode).AsString := AuthorisedHealthcareProfessional.SpecialityCode;
          end;
          // These fields has no match in FMK
          // FieldByName(fnRS_EkspeditionerIssuerCPRNr).AsString := '';
          // FieldByName(fnRS_EkspeditionerIssuerType).AsString := '';
          // FieldByName(fnRS_EkspeditionerSenderSystem).AsString := '';
        end;



        // Patient (SearchPatient procedure in RS logic)
        if Assigned(MainDm.PrescriptionsForPO.Patient) then
        begin
          with MainDm.PrescriptionsForPO.Patient do
          begin
            FieldByName(fnRS_EkspeditionerPatCPR).AsString := CPR;
            if Assigned(Person.Name) then
            begin
              FieldByName(fnRS_EkspeditionerPatEftNavn).AsString := Person.Name.Surname;
              FieldByName(fnRS_EkspeditionerPatForNavn).AsString := (Person.Name.GivenName + ' ' + Person.Name.MiddleName).Trim;
            end;
            if Assigned(Address) then
            begin
              FieldByName(fnRS_EkspeditionerPatVej).AsString := Address.FullStreetBuildingFloorId;
              FieldByName(fnRS_EkspeditionerPatBy).AsString := Address.DistrictName;
              FieldByName(fnRS_EkspeditionerPatPostNr).AsString := Address.PostCodeIdentifier;
              FieldByName(fnRS_EkspeditionerPatLand).AsString := Address.CountryIdentificationCode;
            end;
            FieldByName(fnRS_EkspeditionerPatFoed).AsString := FormatDateTime('YYYY-MM-DD', Person.BirthDate); // Just to mimic the Receptserver
            FieldByName(fnRS_EkspeditionerPatKoen).AsString := Person.Gender.ToRSString;
            FieldByName(fnRS_EkspeditionerPatPersonIdentifier).AsString := Person.PersonIdentifier;
            FieldByName(fnRS_EkspeditionerPatPersonIdentifierSource).AsInteger := Person.PersonIdentifierSource.ToInteger;
            FieldByName(fnRS_EkspeditionerPatOrganisationIdentifier).AsString := '';
            FieldByName(fnRS_EkspeditionerPatOrganisationIdentifierSource).AsInteger := oisUndefined.ToInteger;
          // These fields has no match in FMK
          // FieldByName(fnRS_EkspeditionerPatAmt).AsString := '';
          end;
        end
        else // This is an organisation
        begin
          FieldByName(fnRS_EkspeditionerPatCPR).AsString := '';
          FieldByName(fnRS_EkspeditionerPatForNavn).AsString := '';
          FieldByName(fnRS_EkspeditionerPatVej).AsString := '';
          FieldByName(fnRS_EkspeditionerPatBy).AsString := '';
          FieldByName(fnRS_EkspeditionerPatPostNr).AsString := '';
          FieldByName(fnRS_EkspeditionerPatLand).AsString := '';
          FieldByName(fnRS_EkspeditionerPatFoed).AsString := '';
          FieldByName(fnRS_EkspeditionerPatKoen).AsString := '';

          FieldByName(fnRS_EkspeditionerPatPersonIdentifier).AsString := '';
          FieldByName(fnRS_EkspeditionerPatPersonIdentifierSource).AsInteger := pisUndefined.ToInteger;
          if Assigned(MainDm.PrescriptionsForPO.Organisation) then
            with MainDm.PrescriptionsForPO.Organisation do
            begin
              FieldByName(fnRS_EkspeditionerPatOrganisationIdentifier).AsString := Identifier;
              FieldByName(fnRS_EkspeditionerPatOrganisationIdentifierSource).AsInteger := IdentifierSource.ToInteger;
            end
          else
          begin
            FieldByName(fnRS_EkspeditionerPatOrganisationIdentifier).AsString := '';
            FieldByName(fnRS_EkspeditionerPatOrganisationIdentifierSource).AsInteger := oisUndefined.ToInteger;
          end;
        end;
      end;



      if not LIgnorePrescription then
      begin
        // Prescription (SearchMedication procedure in RS logic)
        with ARSEkspLinier do
        begin
          Insert;
          FieldByName(fnRS_EkspLinierAdminCount).AsInteger := 0;
          FieldByName(fnRS_EkspLinierOrderIdentifier).AsLargeInt := 0;
          FieldByName(fnRS_EkspLinierEffectuationIdentifier).AsLargeInt := 0;

          with APrescription do
          begin
            LAdmDateTime := 0;
            LApotekBem := '';

            FieldByName(fnRS_EkspLinierOrdId).AsString := Identifier.ToString;
            FieldByName(fnRS_EkspLinierVersion).AsString :=  Version.ToString;
            FieldByName(fnRS_EkspLinierOrdNr).AsInteger := 1; // CJS claims this is OK to just set it to 1
            FieldByName(fnRS_EkspLinierPrescriptionIdentifier).AsLargeInt := Identifier;

            if IsPrivatePrescription then
              FieldByName(fnRS_EkspLinierPrivat).AsInteger := 1 { TODO : Optionally: Consider this being an enum }
            else
              FieldByName(fnRS_EkspLinierPrivat).AsInteger := 0;

            // The DateToISO8601 returns milliseconds, but the RS didn't, so just to be 100% sure not to break anything, these are removed
            S := DateToISO8601(Created.DateTime, False);
            // Find the millisecond delimiter and remove the delimiter as well as digits
            I := S.IndexOf('.');
            if I >= 0 then
              while (I < S.Length) and (CharInSet(S.Chars[I], ['.', '0'..'9'])) do
                S := S.Remove(I, 1);
            FieldByName(fnRS_EkspLinierOpretDato).AsString := S;

            // Initial value
            FieldByName(fnRS_EkspLinierAntal).AsInteger := 1;

            if (Assigned(DoseDispensedRestriction)) and (Assigned(DoseDispensedRestriction.PackageNumber)) then
              LVarenr := DoseDispensedRestriction.PackageNumber.ToVnr
            else if Assigned(PackageRestriction) then
            begin
              LVarenr := PackageRestriction.PackageNumber.ToVnr;
              if Assigned(PackageRestriction.PackageSize) then
                FieldByName(fnRS_EkspLinierPakning).AsString := PackageRestriction.PackageSize.PackageSizeText;
              FieldByName(fnRS_EkspLinierAntal).AsInteger := PackageRestriction.PackageQuantity;
              if PackageRestriction.IsIterated then
                FieldByName(fnRS_EkspLinierIterationNr).AsInteger := PackageRestriction.IterationNumberInC2; // See inline XMLDoc on IterationNumberForC2
              if PackageRestriction.IterationInterval > 0 then
                FieldByName(fnRS_EkspLinierIterationInterval).AsInteger := PackageRestriction.IterationInterval;
              FieldByName(fnRS_EkspLinierIterationType).AsString := PackageRestriction.IterationIntervalUnit.ToRSString;
            end
            else
              LVarenr := '';

            // If no Vnr was found by now, try to look it up using the DrugID
            if LVarenr.IsEmpty then
            begin
              if (Assigned(Drug)) and (Assigned(Drug.Identifier)) then
              begin
//                MainDM.GetLargestPackByDrugID(MainDM.nxdb, Drug.Identifier.Identifier, LVarenr)
                LVarenr := Drug.GetVarenr(MainDM.nxdb, 0, True);
                if LVarenr.IsEmpty then
                  C2LogAdd(Drug.LastErrorMessage);
              end
              else
                C2LogAdd('I svaret fra FMK er der intet Varenr. og heller ikke et DrugID, så vi kan ikke afgøre hvilken vare det er');
            end;

            FieldByName(fnRS_EkspLinierVarenNr).AsString := LVarenr;

            FieldByName(fnRS_EkspLinierNavn).AsString := Drug.DrugName;
            if Assigned(Drug.Form) then
              FieldByName(fnRS_EkspLinierForm).AsString := Drug.Form.Text;
            if Assigned(Drug.Strength) then
              FieldByName(fnRS_EkspLinierStyrke).AsString := Drug.Strength.Text;
            FieldByName(fnRS_EkspLinierMagistrel).AsString := Drug.DetailedDrugText;

            FieldByName(fnRS_EkspLinierKlausulbetingelse).AsString := ReimbursementClause.ToRSString;

            if not SubstitutionAllowed then
              FieldByName(fnRS_EkspLinierSubstKode).AsString := 'ikke_substitution'; { TODO : If 'ikke_substitution' is used elsewhere, promote it to a Const or Enum }

            FieldByName(fnRS_EkspLinierSupplerende).AsString := SupplementaryInformation;



            // Prescription (SearchMedDosage procedure in RS logic)
            FieldByName(fnRS_EkspLinierDosTekst).AsString := DosageText;

            // These fields are not a part of the GetNewOrdersResponse and doesn't exist in the FMK as such
            // FieldByName(fnRS_EkspLinierDosKode).AsString := '';
            // FieldByName(fnRS_EkspLinierDosPeriod).AsString := '';
            // FieldByName(fnRS_EkspLinierDosEnhed).AsString := '';



            // Indication (SearchMedDosage procedure in RS logic)
            if Assigned(Indication) then
            begin
              FieldByName(fnRS_EkspLinierIndCode).AsString := Indication.Code.ToString;
              FieldByName(fnRS_EkspLinierIndText).AsString := Indication.Text;
            end;

            // Check for dose dispensing
            if (Assigned(DoseDispensedRestriction)) and (DoseDispensedRestriction.StartDate > 0) then
            begin
              FieldByName(fnRS_EkspLinierDosStartDato).AsString :=
                FormatDateTime('YYYY-MM-DD', DoseDispensedRestriction.StartDate);
              if DoseDispensedRestriction.EndDate > 0 then
                FieldByName(fnRS_EkspLinierDosSlutDato).AsString :=
                  FormatDateTime('YYYY-MM-DD', DoseDispensedRestriction.EndDate);
            end;


            // Order.Effectuation (SearchAdmDone and SearchAdmOrdered procedure in RS logic) but done in a specific sequence
            for I := 1 to 3 do
            begin
              for LOrder in Orders do
              begin
                // The orders have to be processed in a certain sequence based on the status. If the status of the
                // current order isn't of the kind we're currently processing, the continue to next order
                if ((I = 1) and (LOrder.Status <> osUdfoert)) or
                   ((I = 2) and (LOrder.Status <> osBestilt)) or
                   ((I = 3) and (LOrder.Status <> osEkspeditionPaabegyndt)) then
                  Continue;

                if LOrder.Status in [osBestilt, osEkspeditionPaabegyndt, osUdfoert] then
                begin
                  // This part honors the logic in SearchAdmDone
                  if LOrder.Status = osUdfoert then
                  begin
                    FieldByName(fnRS_EkspLinierAdminCount).AsInteger :=
                      FieldByName(fnRS_EkspLinierAdminCount).AsInteger + 1;

                    if Assigned(LOrder.Effectuation) then
                    begin
                      LAdmDateTime := LOrder.Effectuation.DateTime;
                      LApotekBem := LOrder.Effectuation.PharmacyComment;
                    end;
                  end
                  else if LOrder.Status IN [osBestilt,osEkspeditionPaabegyndt] then
                  begin
                    FieldByName(fnRS_EkspLinierAdministrationId).AsLargeInt := LOrder.Identifier;
                    FieldByName(fnRS_EkspLinierOrderIdentifier).AsLargeInt := LOrder.Identifier;
                    // Populate the BestiltAf if LOrder.Modified or LOrder.Created is different from LPrescription.Created
                    LBestiltAfAuthHP := nil;
                    LBestiltAfOrg := nil;
                    LBestiltAfOther := nil;
//                    if (Assigned(LOrder.Modified) and not LOrder.Modified.By.Equals(APrescription.Created.By)) then
//                    begin
//                      LBestiltAfAuthHP := LOrder.Modified.By.AuthorisedHealthcareProfessional;
//                      LBestiltAfOrg := LOrder.Modified.By.Organisation;
//                      LBestiltAfOther := LOrder.Modified.By.Other;
//                    end
//                    else
                    if LOrder.Status = osBestilt then
                    begin
                      // 06-03-2020/MA: Added the condition that the organisation and user must not be related a
                      // pharmacy (otApotek, rrApoteker, rrApoteksansat, rrBehandlerfarmaceut)
                      if Assigned(LOrder.CreatedWithoutPerson) and
                        not (LOrder.CreatedWithoutPerson.By.&Type = otApotek) and
                        not LOrder.CreatedWithoutPerson.By.Equals(APrescription.Created.By.Organisation) then
                      begin
                        LBestiltAfOrg := LOrder.CreatedWithoutPerson.By;
                      end
                      else if Assigned(LOrder.Created) and
                        (LOrder.Created.By.Role <> rrApoteker) and
                        (LOrder.Created.By.Role <> rrApoteksansat) and
                        (LOrder.Created.By.Role <> rrBehandlerfarmaceut) and
                        not LOrder.Created.By.Equals(APrescription.Created.By) then
                      begin
                        LBestiltAfAuthHP := LOrder.Created.By.AuthorisedHealthcareProfessional;
                        LBestiltAfOrg := LOrder.Created.By.Organisation;
                        LBestiltAfOther := LOrder.Created.By.Other;
                      end;

//                      if (Assigned(LOrder.CreatedWithoutPerson) and
//                        not LOrder.CreatedWithoutPerson.By.Equals(APrescription.Created.By.Organisation)) then
//                      begin
//                        LBestiltAfOrg := LOrder.CreatedWithoutPerson.By;
//                      end
//                      else if (Assigned(LOrder.Created) and not LOrder.Created.By.Equals(APrescription.Created.By)) then
//                      begin
//                        LBestiltAfAuthHP := LOrder.Created.By.AuthorisedHealthcareProfessional;
//                        LBestiltAfOrg := LOrder.Created.By.Organisation;
//                        LBestiltAfOther := LOrder.Created.By.Other;
//                      end;

                      if Assigned(LBestiltAfOrg) then
                        with LBestiltAfOrg do
                        begin
                          FieldByName(fnRS_EkspLinierBestiltAfIdType).AsString := IdentifierSource.ToRSString;
                          case IdentifierSource of
                            oisSKS: FieldByName(fnRS_EkspLinierBestiltAfId).AsString := Identifier.PadRight(7, '0');
                            oisEANLokationsnummer: FieldByName(fnRS_EkspLinierBestiltAfId).AsString := Identifier;
                          else
                            FieldByName(fnRS_EkspLinierBestiltAfId).AsString := Identifier.PadLeft(7, '0');
                          end;
                          FieldByName(fnRS_EkspLinierBestiltAfOrgNavn).AsString := Name;
                          FieldByName(fnRS_EkspLinierBestiltAfAdresse).AsString := AddressLine1;
                          FieldByName(fnRS_EkspLinierBestiltAfPostNr).AsString := PostCodeIdentifier;
                          FieldByName(fnRS_EkspLinierBestiltAfTelefon).AsString := TelephoneNumber;
                        end;

                      if Assigned(LBestiltAfAuthHP) then
                        with LBestiltAfAuthHP do
                        begin
                          FieldByName(fnRS_EkspLinierBestiltAfAutNr).AsString := AuthorisationIdentifier;
                          FieldByName(fnRS_EkspLinierBestiltAfNavn).AsString := Name;
                        end;

                      if Assigned(LBestiltAfOther) then
                        with LBestiltAfOther do
                        begin
                          FieldByName(fnRS_EkspLinierBestiltAfNavn).AsString := Name.FullName;
                          if (PersonIdentifierSource <> pisUndefined) and not PersonIdentifier.IsEmpty then
                          begin
                            FieldByName(fnRS_EkspLinierBestiltAfIdType).AsString := PersonIdentifierSource.ToString;
                            FieldByName(fnRS_EkspLinierBestiltAfId).AsString := PersonIdentifier;
                          end;
                        end;

                    end;
                  end;


                  // Converts all lines in DeliveryInstructionText to a single string
                  with LOrder.DeliveryInstructionText do
                    S := Text.Replace(LineBreak, ' ');
                  FieldByName(fnRS_EkspLinierOrdreInstruks).AsString := S;
                  // The following is left blank intentionally, as ReceptServer only returns Leveringsinfo in the
                  // OrdreIndstruks field, unless DeliveryInstructionText contains the PersonID: text which
                  // PatientKartotek relies on in this field
                  if S.ToUpper.Contains('PERSONID:') then
                    ARSEkspeditioner.FieldByName(fnRS_EkspeditionerLeveringsInfo).AsString := S
                  else
                    ARSEkspeditioner.FieldByName(fnRS_EkspeditionerLeveringsInfo).AsString := '';


                  if Assigned(LOrder.Delivery) then
                  begin
                    ARSEkspeditioner.FieldByName(fnRS_EkspeditionerLeveringPri).AsString :=
                      LOrder.Delivery.Priority.ToRSString;

                    if Assigned(LOrder.Delivery.DeliverySite) then
                    begin
                      ARSEkspeditioner.FieldByName(fnRS_EkspeditionerLeveringAdresse).AsString :=
                        LOrder.Delivery.DeliverySite.AddressLine1;
                    end
                    else
                    begin
                      ARSEkspeditioner.FieldByName(fnRS_EkspeditionerLeveringAdresse).AsString :=
                        LOrder.Delivery.StreetName;
                      ARSEkspeditioner.FieldByName(fnRS_EkspeditionerLeveringPseudo).AsString :=
                        LOrder.Delivery.PseudoAddress;
                      ARSEkspeditioner.FieldByName(fnRS_EkspeditionerLeveringKontakt).AsString :=
                        LOrder.Delivery.ContactName;
                    end;
                    // Gets the Postnr. from either DeliverySite or PostCode
                    ARSEkspeditioner.FieldByName(fnRS_EkspeditionerLeveringPostNr).AsString :=
                      LOrder.Delivery.PostCodeIdentifier;
                  end;
                end;
              end;
            end;

            if LAdmDateTime > 0 then
              FieldByName(fnRS_EkspLinierAdminDate).AsString := FormatDateTime('DD.MM.YYYY', LAdmDateTime)
            else
              FieldByName(fnRS_EkspLinierAdminDate).AsString := '';
            FieldByName(fnRS_EkspLinierApotekBem).AsString := LApotekBem;
          end;

          Post;
        end;

        with ARSEkspeditioner do
          FieldByName(fnRS_EkspeditionerOrdAnt).AsInteger := FieldByName(fnRS_EkspeditionerOrdAnt).AsInteger + 1;
      end;

      ARSEkspeditioner.Post;
    except
      on E: Exception do
      begin
        if ARSEkspeditioner.State = dsBrowse then
        begin
          C2LogAdd('Cancelling edit on ' + ARSEkspeditioner.Name);
          ARSEkspeditioner.Cancel;
        end;
        if ARSEkspLinier.State = dsBrowse then
        begin
          C2LogAdd('Cancelling edit on ' + ARSEkspLinier.Name);
          ARSEkspLinier.Cancel;
        end;
      end;
    end;
  C2LogAdd('ProcessPrescriptionsForPersonOrOrganisation - end');
end;





function FMKGetPrescriptionById(AAfdelingsnr: Integer;
  APrescription: TC2FMKPrescription; ASetUnderBehandling: boolean;var AReceptId : integer; var AErrorString :string): boolean;
var
  LModificator1 : TC2FMKModificator;
  LOrganisation1 : TC2FMKOrganisation;
  LResult : boolean;
  LPrescriptions: TC2FMKPrescriptions;
  LPrescriptionErrors: TC2FMKPrescriptionErrors;
  LPrescription : TC2FMKPrescription;
  LOrder : TC2FMKOrder;
  LReceptId : integer;
  LPersonId : string;
  LPersonIdSource : TFMKPersonIdentifierSource;

begin
  C2LogAdd('FMKGetPrescriptionById - begin');
  Result := True;
  AErrorString := '';
  try
    // Ensure the current record is the first with the ReceptID field
    try
      MainDM.nxSettings.First;
    except
      on E: Exception do
      begin
        Result := False;
        C2LogAdd('Problem getting RS Settings: ' + E.Message);
        Exit;
      end;
    end;

    maindm.Afdeling.Afdelingsnr := AAfdelingsnr;

    MainDM.cdsRSEkspeditioner.LogChanges := False;
    MainDM.cdsRSEkspeditioner.Open;
    MainDM.cdsRSEkspeditioner.EmptyDataSet;

    // if the presciption is no longer open then return the error

    if APrescription.Status <> psAaben then
    begin
      AErrorString := 'Denne ordination kan ikke takseres. FMK Status er : ' +
        APrescription.Status.ToString;
      Result := False;
      exit;
    end;

    ProcessPrescription(APrescription, MainDM.cdsRSEkspeditioner, MainDM.cdsRSEksplinier);

    C2LogAdd('Antal poster cdsRSEkspeditioner=' + MainDM.cdsRSEkspeditioner.RecordCount.ToString);

    {$IFDEF DEBUG}
    MainDM.cdsRSEkspeditioner.SaveToFile('C:\C2\Temp\RSEkspFMK-' + MainDM.FileSuffix + '.xml', dfXML);
    {$ENDIF}

    // Now have the first cds of the xml. We run down this and create the new combined ver
    // first job is to delete an cdsRSEKspeditioner without any lines
    MainDM.cdsRSEkspeditioner.First;
    while not MainDM.cdsRSEkspeditioner.Eof do
    begin
      if MainDM.cdsRSEksplinier.RecordCount = 0 then
        MainDM.cdsRSEkspeditioner.Delete
      else
        MainDM.cdsRSEkspeditioner.Next;
    end;

    // New routine that will handle existing ordinations
    HandleExistingOrdinationId(MainDM.cdsRSEkspeditioner, MainDM.cdsRSEksplinier);

//    JoinFMKRecepter(MainDM.cdsRSEkspeditioner, MainDM.cdsRSEksplinier, MainDM.cdsRSEksp, MainDM.cdsRSEkspin);
    try
      SaveToDatabase(MainDM.cdsRSEkspeditioner, MainDM.cdsRSEksplinier,LReceptId);
      C2LogAdd('Ekspeditioner saved to database with receptid ' + LReceptId.ToString);
    except
      on E: Exception do
      begin
        C2LogAdd('Fejl i SaveToDatabase ' + e.Message);
        Result := False;
        exit;
      end;
    end;

    // no we have saved the prescription to the database we need to get it underbehandling


    if ASetUnderBehandling then
//      (pos('PersonID:',maindm.cdsRSEkspeditionerLeveringsInfo.AsString) <> 0) then
    begin
      with MainDm do
      begin
        LModificator1 := TC2FMKModificator.Create(Bruger, Afdeling);
        LOrganisation1 := TC2FMKOrganisation.Create(Afdeling);
        LPrescriptions := TC2FMKPrescriptions.Create;
        LPrescriptionErrors := TC2FMKPrescriptionErrors.Create;
        try
          if Assigned(PrescriptionsForPO.Patient) then
          begin
            LPersonId := PrescriptionsForPO.Patient.Person.PersonIdentifier;
            LPersonIdSource := PrescriptionsForPO.Patient.Person.PersonIdentifierSource;
          end
          else
          begin
            LPersonId := APrescription.Identifier.ToString;
            LPersonIdSource := pisMedicineCardKey;
          end;
          LResult := C2FMK.StartEffectuationRequest(Bruger.SOSIId,
            Bruger.FMKRolle.ToSOSIId, LPersonId, LPersonIdSource, LModificator1,
            LOrganisation1, APrescription.Identifier, nil, LPrescriptions,
            LPrescriptionErrors);

          // look for the administratiobn id in the order and update the rs_eksplinier
          if LResult then
          begin
            if LPrescriptionErrors.Count <> 0 then
            begin
              Result := False;
              exit;
            end;

            if (LPrescriptions.Count <> 0) then
            begin
              LPrescription := LPrescriptions.ObjectList.First;
              LOrder := LPrescription.Orders.GetOrderByStatus
                (osEkspeditionPaabegyndt);
              if LOrder <> Nil then
              begin
                nxRSEkspLinier.IndexName := 'OrdIdOrden';
                if nxRSEkspLinier.FindKey([inttostr(LPrescription.Identifier),
                  LReceptId]) then
                begin
                  nxRSEkspLinier.Edit;
                  nxRSEkspLinier.FieldByName(fnRS_EkspLinierAdministrationId)
                    .AsString := inttostr(LOrder.Identifier);
                  nxRSEkspLinier.FieldByName(fnRS_EksplinierOrderIdentifier)
                    .AsLargeInt := LOrder.Identifier;
                  nxRSEkspLinier.Post;
                end;
              end;

            end;

          end
          else
          begin
            Result := False;
            AErrorString := c2fmk.LastErrorDisplayText;
          end;
        finally

          FreeAndNil(LModificator1);
          FreeAndNil(LOrganisation1);
          FreeAndNil(LPrescriptions);
          FreeAndNil(LPrescriptionErrors);
        end;
      end;

    end;

    AReceptId := LReceptId;

//    if (C2FMK.LogXMLRequests <> lxrcNone) or (C2FMK.LogXMLResponses) then
//    begin
//      C2LogAdd('FMK XML - begin');
//      C2LogAdd(c2fmk.XMLLog.Text);
//      C2LogAdd('FMK XML - end');
//    end;
  finally
    C2FMK.XMLLog.Clear;
    C2LogAdd('FMKGetPrescriptionById - end');
  end;

end;


function FMKGetMedById(AKundeNr: string; AMedId: string; AAfdelingsnr: Integer;
  var AReceptId: Integer; APrintRecept: boolean;
  ASetInProgress : boolean;  var AErrorString: string): boolean;
var
  LModificator1 : TC2FMKModificator;
  LOrganisation1 : TC2FMKOrganisation;
  LResult : boolean;
  LPrescriptions: TC2FMKPrescriptions;
  LPrescriptionErrors: TC2FMKPrescriptionErrors;
  LPrescription : TC2FMKPrescription;
  LOrder : TC2FMKOrder;
  LPrescriptionIdentifier : int64;
  LReceptId : integer;
  LPersonId : string;
  LPersonIdSource : TFMKPersonIdentifierSource;
  LDrugNameForm : string;
  LConsentGiven : TFMKConsentType;
begin
  C2LogAdd(Format('FMKGetPrescriptionById - direct call for %s begin',[AMedid]));
  Result := True;

  MainDm.Afdeling.Afdelingsnr := AAfdelingsnr;


  try
    // covert the passed medid to int64
    if not TryStrToInt64(AMedId.Trim,LPrescriptionIdentifier) then
    begin
      AErrorString := 'Invalid PrescriptionId';
      Result := False;
      exit;
    end;

    // Ensure the current record is the first with the ReceptID field
    try
      MainDM.nxSettings.First;
    except
      on E: Exception do
      begin
        Result := False;
        C2LogAdd('Problem getting RS Settings: ' + E.Message);
        Exit;
      end;
    end;


    MainDM.cdsRSEkspeditioner.LogChanges := False;
    MainDM.cdsRSEkspeditioner.Open;
    MainDM.cdsRSEkspeditioner.EmptyDataSet;

    // get the prescription direct from FMK
    with MainDm do
    begin
      if AKundeNr.Trim <> '' then
      begin
        LPersonId := AKundeNr.Trim;
        { TODO : 03-06-2021/MA: Replace constant with real PersonIdSource }
        LPersonIdSource := TFMKPersonIdentifierSource.DetectSource(LPersonId);
      end
      else
      begin
        LPersonId := LPrescriptionIdentifier.ToString;
        LPersonIdSource := pisMedicineCardKey;
      end;

      LConsentGiven := ctUndefined;
      { TODO : 03-06-2021/MA: Replace constant with real PersonIdSource }
      LResult := C2FMK.GetPrescriptionRequest(Bruger.SOSIId,
        Bruger.FMKRolle.ToSOSIId, AKundeNr, TFMKPersonIdentifierSource.DetectSource(AKundeNr), LConsentGiven,
        LPrescriptionIdentifier, True, PrescriptionsForPO);
      // c2logadd(C2FMK.XMLLog.Text);
      C2FMK.XMLLog.Clear;

      //  first we check if the prescription is private marked
      //  if it is then we get the prescription again with consent
      if Lresult then
      begin
        if PrescriptionsForPO.PrivatePrescriptions.IndexOf(LPrescriptionIdentifier) >=0 then
        begin
          C2LogAdd('Private prescription requested.  Try again with consent');
          LConsentGiven := ctPrivateDataConsentGiven;
          LResult := C2FMK.GetPrescriptionRequest(Bruger.SOSIId,
            Bruger.FMKRolle.ToSOSIId, AKundeNr, TFMKPersonIdentifierSource.DetectSource(AKundeNr), LConsentGiven,
            LPrescriptionIdentifier, True, PrescriptionsForPO);

        end;

      end;

      if LResult then
      begin
        // if the result is empty then warn and get out ... in fact it should always be 1
        if PrescriptionsForPO.Prescriptions.Count = 0 then
        begin
          result := False;
          AErrorString := 'No prescription returned from FMK';
          exit;
        end;

        // point at the first (and only !!!!) prescription
        LPrescription := PrescriptionsForPO.Prescriptions[0];

        if LPrescription.Status <> psAaben then
        begin
          result := False;
          AErrorString := 'Denne ordination kan ikke takseres. FMK Status er : '
            + LPrescription.Status.ToString;
          exit;
        end;

        // check the valid date is current

        if not DateInRange(Date, LPrescription.ValidFromDate, LPrescription.ValidToDate) then
        begin
          Result := False;
          AErrorString := 'Recepten er gyldig i perioden fra ' + FormatDateTime('dd/mm/yyyy',
            LPrescription.ValidFromDate) + ' til ' + FormatDateTime('dd/mm/yyyy', LPrescription.ValidToDate);

          Exit;
        end;


        with LPrescription do
        begin
          if (Orders <> Nil) and (Orders.Count <> 0) then
          begin
            LOrder := Orders.ObjectList.Last;
            if LOrder.Status = osEkspeditionPaabegyndt then
            begin
              Result := False;
              // get the drug nanme and form to display in errostring
              LDrugNameForm := '';
              LDrugNameForm := drug.Name;
              if Assigned(drug.Form) then
                LDrugNameForm := LDrugNameForm + ' ' + drug.Form.Text;

//              if LOrder.OrderedAtPharmacy.Identifier <> RSLokation then
                AErrorString := LDrugNameForm +
                  ' kan ikke ekspederes, da recepten allerede er påbegyndt på '
                  + LOrder.OrderedAtPharmacy.Name;
//              else
//                AErrorString := LDrugNameForm +
//                  ' kan ikke ekspederes, da recepten allerede er påbegyndt på '
//                  + 'Gazelle Online Apotek';

              Exit;
            end;

          end;
        end;

      end
      else
      begin
        AErrorString := C2FMK.LastErrorDisplayText;
        Result := False;
        exit;
      end;
    end;


    ProcessPrescription(LPrescription, MainDM.cdsRSEkspeditioner, MainDM.cdsRSEksplinier);

    C2LogAdd('Antal poster cdsRSEkspeditioner=' + MainDM.cdsRSEkspeditioner.RecordCount.ToString);

    {$IFDEF DEBUG}
    MainDM.cdsRSEkspeditioner.SaveToFile('C:\C2\Temp\RSEkspFMK-' + MainDM.FileSuffix + '.xml', dfXML);
    {$ENDIF}

    // Now have the first cds of the xml. We run down this and create the new combined ver
    // first job is to delete an cdsRSEKspeditioner without any lines
    MainDM.cdsRSEkspeditioner.First;
    while not MainDM.cdsRSEkspeditioner.Eof do
    begin
      if MainDM.cdsRSEksplinier.RecordCount = 0 then
        MainDM.cdsRSEkspeditioner.Delete
      else
        MainDM.cdsRSEkspeditioner.Next;
    end;

    // New routine that will handle existing ordinations
    HandleExistingOrdinationId(MainDM.cdsRSEkspeditioner, MainDM.cdsRSEksplinier);

    try


      SaveToDatabase(MainDM.cdsRSEkspeditioner, MainDM.cdsRSEksplinier,LReceptId);
      C2LogAdd('Ekspeditioner saved to database with receptid ' + LReceptId.ToString);

    except
      on E: Exception do
        C2LogAdd('Fejl i SaveToDatabase ' + e.Message);
    end;

    // no we have saved the prescription to the database we need to get it underbehandling
    if ASetInProgress then
    begin

      with MainDm do
      begin
        LModificator1 := TC2FMKModificator.Create(Bruger, Afdeling);
        LOrganisation1 := TC2FMKOrganisation.Create(Afdeling);
        LPrescriptions := TC2FMKPrescriptions.Create;
        LPrescriptionErrors := TC2FMKPrescriptionErrors.Create;
        try
          LResult := C2FMK.StartEffectuationRequest(Bruger.SOSIId,
            Bruger.FMKRolle.ToSOSIId, LPersonId, LPersonIdSource, LModificator1,
            LOrganisation1, LPrescriptionIdentifier, nil, LPrescriptions,
            LPrescriptionErrors);

          // look for the administratiobn id in the order and update the rs_eksplinier
          if LResult then
          begin
            if LPrescriptionErrors.Count <> 0 then
            begin
              Result := False;
              exit;
            end;

            if LPrescriptions.Count <> 0 then
            begin

              LPrescription := LPrescriptions.ObjectList.First;
              LOrder := LPrescription.Orders.GetOrderByStatus
                (osEkspeditionPaabegyndt);
              if LOrder <> Nil then
              begin
                  nxRSEkspLinier.IndexName := 'OrdIdOrden';
                  if nxRSEkspLinier.FindKey([inttostr(LPrescription.Identifier),LReceptId]) then
                  begin
                    nxRSEkspLinier.Edit;
                    nxRSEkspLinier.FieldByName(fnRS_EksplinierAdministrationId).AsString := IntToStr(LOrder.Identifier);
                    nxRSEkspLinier.FieldByName(fnRS_EksplinierOrderIdentifier).AsLargeInt := LOrder.Identifier;
                    nxRSEkspLinier.Post;
                  end;


              end;

            end;
          end
          else
          begin
            if LPrescriptionErrors.Count <> 0 then
              AErrorString := LPrescriptionErrors.First.ReasonText
            else
              AErrorString := C2FMK.LastErrorDisplayText;
  // removed so that calling routine will message it
  //          ChkBoxOK(AErrorString);
            Result := False;
            exit;
          end;

        finally

          FreeAndNil(LModificator1);
          FreeAndNil(LOrganisation1);
          FreeAndNil(LPrescriptions);
          FreeAndNil(LPrescriptionErrors);
        end;

      end;
    end;

    if aPrintRecept then
    begin
      C2LogAdd('Call C2FMKMidSrv with receptid ' + LReceptId.ToString);

      RCPMidCli.SendRequest('GetAddressed',
        ['4', LReceptId.ToString,
        IntToStr(AAfdelingsNr), MainDm.C2UserName, 'True'], 10);
      with MainDm do
      begin
        try
          nxRSEkspeditioner.Edit;
          nxRSEkspeditioner.FieldByName('ReceptStatus').AsInteger := 4;
          nxRSEkspeditioner.Post;
        except
          if nxRSEkspeditioner.State <> dsbrowse then
            nxRSEkspeditioner.Cancel;
        end;
      end;
    end
    else
    begin
      with MainDm do
      begin
        try
          nxRSEkspeditioner.Edit;
          nxRSEkspeditioner.FieldByName('ReceptStatus').AsInteger := 5;
          nxRSEkspeditioner.Post;
        except
          if nxRSEkspeditioner.State <> dsbrowse then
            nxRSEkspeditioner.Cancel;
        end;
      end;
    end;


    AReceptId := LReceptId;

//    if (C2FMK.LogXMLRequests <> lxrcNone) or (C2FMK.LogXMLResponses) then
//    begin
//      C2LogAdd('FMK XML - begin');
//      C2LogAdd(MainDm.FMKXMLLog.Text);
//      C2LogAdd('FMK XML - end');
//    end;
  finally
    C2FMK.XMLLog.Clear;
    MainDm.FMKXMLLog.Clear;
    C2LogAdd('FMKGetPrescriptionById - end');
  end;


end;

function SaveToRSEksplinier(AReceptid : integer;ARSEkspeditioner, ARSEkspLinier: TClientDataSet): Boolean;
var
  LFld: TField;
begin
  C2LogAdd('SaveToRSEksplinier - begin');

  with MainDM do
  begin
    ffRcpOpl.DataBase.StartTransactionWith([nxRSEkspeditioner, nxRSEkspLinier, nxSettings]);
    try
      // Now we update RS_EkspLinier from the cds
      ARSEkspeditioner.First;
      while not ARSEkspeditioner.Eof do
      begin
        // should only be 1 but testing will determine this
        ARSEkspLinier.First;
        while not ARSEkspLinier.Eof do
        begin

          nxRSEkspLinier.IndexName := 'OrdIdOrden';
          if nxRSEkspLinier.FindKey([ARSEkspLinier.FieldByName('Ordid').AsString,AReceptId]) then
          begin
            nxRSEkspLinier.Edit;
            for LFld in nxRSEkspLinier.Fields do
            begin
              // new rs_eksplinier fmk field PrescriptionIdientifier
              if SameText(LFld.FieldName, fnRS_EksplinierPrescriptionIdentifier) then
              begin
                nxRSEkspLinier.FieldByName(LFld.FieldName).AsLargeInt := StrToInt64(ARSEkspLinier.FieldByName(fnRS_EkspLinierOrdId).AsString);
                continue;
              end;

              // new rs_eksplinier fmk field OrderIdientifier
              if SameText(LFld.FieldName, fnRS_EksplinierOrderIdentifier) then
              begin
                nxRSEkspLinier.FieldByName(LFld.FieldName).AsLargeInt := ARSEkspLinier.FieldByName(fnRS_EkspLinierAdministrationId).AsLargeInt;
                continue;
              end;

              // new rs_eksplinier fmk field EffectuationIdientifier
              if SameText(LFld.FieldName, fnRS_EksplinierEffectuationIdentifier) then
              begin
                nxRSEkspLinier.FieldByName(LFld.FieldName).AsLargeInt := 0;
                continue;
              end;
              if SameText(LFld.FieldName, fnRS_EkspLinierReceptId) then
                continue;
              if SameText(LFld.FieldName, fnRS_EkspLinierOrdNr) then
                continue;
              if ARSEkspLinier.FindField(LFld.FieldName) <> Nil then
              begin
                nxRSEkspLinier.FieldByName(LFld.FieldName).Value := ARSEkspLinier.FieldByName(LFld.FieldName).Value
              end;
            end;
            nxRSEkspLinier.Post;
          end;
          ARSEkspLinier.Next;
        end;

        ARSEkspeditioner.Next;
      end;

      ffRcpOpl.DataBase.Commit;

      Result := True;
    except
      on E: Exception do
      begin
        Result := False;
        C2LogAdd('Exception: "' + E.Message + '"');
        ffRcpOpl.DataBase.Rollback;
      end;
    end;
  end;

  C2LogAdd('SaveToRSEksplinier - end');
end;

function UpdateDosisRSEksplinier(ARSEkspeditioner, ARSEkspLinier: TClientDataSet): Boolean;
var
  LFld: TField;
  LOrdid : string;
begin
  C2LogAdd('UpdateDosisRSEksplinier - begin');

  with MainDM do
  begin
    ffRcpOpl.DataBase.StartTransactionWith([nxRSEkspeditioner, nxRSEkspLinier, nxSettings]);
    try
      // Now we update RS_EkspLinier from the cds
      ARSEkspeditioner.First;
      while not ARSEkspeditioner.Eof do
      begin
        // should only be 1 but testing will determine this
        ARSEkspLinier.First;
        while not ARSEkspLinier.Eof do
        begin
          LOrdid := ARSEkspLinier.FieldByName('Ordid').AsString;

          // look at all rseksplinier for one with 0 in rslbnr

          nxRSEkspLinier.IndexName := 'OrdIdOrden';
          nxRSEkspLinier.SetRange([LOrdid],[LOrdid]);
          try
            nxRSEkspLinier.First;
            while not nxRSEkspLinier.Eof do
            begin
              // found a zero
              if nxRSEkspLinier.FieldByName(fnRS_EkspLinierRSLbnr).AsInteger = 0 then
              begin
                C2LogAdd('found a dosisline in Rs_eksplinier to update');
                // edit the record and get out
                nxRSEkspLinier.Edit;
                for LFld in nxRSEkspLinier.Fields do
                begin
                  // new rs_eksplinier fmk field PrescriptionIdientifier
                  if SameText(LFld.FieldName, fnRS_EksplinierPrescriptionIdentifier) then
                  begin
                    nxRSEkspLinier.FieldByName(LFld.FieldName).AsLargeInt := StrToInt64(ARSEkspLinier.FieldByName(fnRS_EkspLinierOrdId).AsString);
                    continue;
                  end;

                  // new rs_eksplinier fmk field OrderIdientifier
                  if SameText(LFld.FieldName, fnRS_EksplinierOrderIdentifier) then
                  begin
                    nxRSEkspLinier.FieldByName(LFld.FieldName).AsLargeInt := ARSEkspLinier.FieldByName(fnRS_EkspLinierAdministrationId).AsLargeInt;
                    continue;
                  end;

                  // new rs_eksplinier fmk field EffectuationIdientifier
                  if SameText(LFld.FieldName, fnRS_EksplinierEffectuationIdentifier) then
                  begin
                    nxRSEkspLinier.FieldByName(LFld.FieldName).AsLargeInt := 0;
                    continue;
                  end;
                  if SameText(LFld.FieldName, fnRS_EkspLinierReceptId) then
                    continue;
                  if SameText(LFld.FieldName, fnRS_EkspLinierOrdNr) then
                    continue;
                  nxRSEkspLinier.FieldByName(LFld.FieldName).Value := ARSEkspLinier.FieldByName(LFld.FieldName).Value
                end;
                nxRSEkspLinier.Post;

                break;
              end;


              nxRSEkspLinier.Next;
            end;
          finally
            nxRSEkspLinier.CancelRange;
          end;

          ARSEkspLinier.Next;  // go get the next line
        end;

        ARSEkspeditioner.Next;
      end;

      ffRcpOpl.DataBase.Commit;

      Result := True;
    except
      on E: Exception do
      begin
        Result := False;
        C2LogAdd('Exception: "' + E.Message + '"');
        ffRcpOpl.DataBase.Rollback;
      end;
    end;
  end;

  C2LogAdd('UpdateDosisRSEksplinier - end');
end;



function RefreshReceivedMedications(AKundenr : string;APrivate : integer; AMedId: string;
  AAfdelingsNr: integer;AReceptId : integer; ADosis : boolean; ASetInProgress : boolean): boolean;
var
  LModificator1 : TC2FMKModificator;
  LOrganisation1 : TC2FMKOrganisation;
  LResult : boolean;
  LPrescriptions: TC2FMKPrescriptions;
  LPrescriptionErrors: TC2FMKPrescriptionErrors;
  LPrescription : TC2FMKPrescription;
  LOrder : TC2FMKOrder;
  LPrescriptionIdentifier : int64;
  LConsent : TFMKConsentType;
  LPersonId : string;
  LPersonType : TFMKPersonIdentifierSource;
begin
  C2LogAdd(Format('RefreshReceivedMedications - direct call for %s %d begin',[AMedId,AReceptId]));
  Result := True;

  MainDm.Afdeling.Afdelingsnr := AAfdelingsnr;

  try
    // covert the passed medid to int64
    if not TryStrToInt64(AMedId.Trim,LPrescriptionIdentifier) then
    begin
      C2LogAdd('Invalid Prescription identifier ' + AMedId.Trim);
      Result := False;
      exit;
    end;

    // Ensure the current record is the first with the ReceptID field
    try
      MainDM.nxSettings.First;
    except
      on E: Exception do
      begin
        Result := False;
        C2LogAdd('Problem getting RS Settings: ' + E.Message);
        Exit;
      end;
    end;


    MainDM.cdsRSEkspeditioner.LogChanges := False;
    MainDM.cdsRSEkspeditioner.Open;
    MainDM.cdsRSEkspeditioner.EmptyDataSet;


    // get the prescription direct from FMK
    with MainDm do
    begin
      LConsent := ctUndefined;
      if APrivate <> 0 then
        LConsent := ctPrivateDataConsentGiven;

      LPrescription := Nil;
      LResult := C2FMK.GetPrescriptionRequest(Bruger.SOSIId,
        Bruger.FMKRolle.ToSOSIId, AKundenr, pisCPR, LConsent, LPrescriptionIdentifier, True,
        PrescriptionsForPO);
      if LResult then
      begin

        // if the result is empty then warn and get out ... in fact it should always be 1
        if PrescriptionsForPO.Prescriptions.Count = 0 then
        begin
          result := False;
          exit;
        end;

        if PrescriptionsForPO.MedicineCardIsInvalid then
            frmYesNo.NewOKBox('Ugyldigt medicinkort indikerer tvivl om dataindhold' + #13#10 +
            'og data kan være misvisende.' +#13#10+
            ' Kun Sundhedsdatastyrelsen kan ugyldiggøre medicinkort.' + #13#10 +
              'Ugyldighedsmarkeringen fjernes automatisk ved lægens første' + #13#10
              + 'ajourføring af medicinkortet foretaget efter ugyldiggørelsen.' +
              #13#10 + 'Ved tvivl bør apoteket søge recepternes indhold verificeret'
              + #13#10 + 'hos receptudsteder eller borgerens egen læge.');
        // point at the first (and only !!!!) prescription
        LPrescription := PrescriptionsForPO.Prescriptions.ObjectList.First;

        // chweck the orders for a påbegynd ekspedition (not dosis)
        if not ADosis then
        begin

//          if LPrescription.Orders.GetOrderByStatus(osEkspeditionPaabegyndt) <> Nil then
//          begin
//            ChkBoxOK('Denne ordination kan ikke takseres. FMK Status er : Ekspedition påbegyndt');
//            Result := False;
//            exit;
//          end;

          if LPrescription.Status <> psAaben  then
          begin
            ChkBoxOK('Denne ordination kan ikke takseres. FMK Status er : '
             + LPrescription.Status.ToString);
            Result := False;
            exit;

          end;

        end;

      end
      else
      begin
        C2LogAdd('Error returned from  C2FMK.GetPrescriptionRequest ' + C2FMK.LastErrorMessage);
        Result := False;
      end;
    end;


    ProcessPrescription(LPrescription, MainDM.cdsRSEkspeditioner, MainDM.cdsRSEksplinier);

    C2LogAdd('Antal poster cdsRSEkspeditioner=' + MainDM.cdsRSEkspeditioner.RecordCount.ToString);

    {$IFDEF DEBUG}
    MainDM.cdsRSEkspeditioner.SaveToFile('C:\C2\Temp\RSEkspFMK-' + MainDM.FileSuffix + '.xml', dfXML);
    {$ENDIF}

    // Now have the first cds of the xml. We run down this and create the new combined ver
    // first job is to delete an cdsRSEKspeditioner without any lines
    MainDM.cdsRSEkspeditioner.First;
    while not MainDM.cdsRSEkspeditioner.Eof do
    begin
      if MainDM.cdsRSEksplinier.RecordCount = 0 then
        MainDM.cdsRSEkspeditioner.Delete
      else
        MainDM.cdsRSEkspeditioner.Next;
    end;

    try

      if ADosis then
         UpdateDosisRSEksplinier(Maindm.cdsRSEkspeditioner,MainDm.cdsRSEksplinier)
      else
        SaveToRSEksplinier(AReceptId,Maindm.cdsRSEkspeditioner,MainDm.cdsRSEksplinier);

    except
      on E: Exception do
        C2LogAdd('Fejl i SaveToDatabase ' + e.Message);
    end;

    // check the valid date is current

    if not DateInRange(Date, LPrescription.ValidFromDate, LPrescription.ValidToDate) then
    begin
      ShowMessageBoxWithLogging('Recepten ' + LPrescription.Identifier.ToString + ' er gyldig i perioden fra ' +
        FormatDateTime('dd/mm/yyyy', LPrescription.ValidFromDate) + ' til ' + FormatDateTime('dd/mm/yyyy',
        LPrescription.ValidToDate), 'Meddelelse', mb_ok);
      Result := False;
      Exit;
    end;


    // dosis ekspeditions are already under behandling from dosiskort program
    if ADosis then
      exit;


    if not ASetInProgress then
      exit;


    // no we have saved the prescription to the database we need to get it underbehandling

    with MainDm do
    begin
      LModificator1 := TC2FMKModificator.Create(Bruger, Afdeling);
      LOrganisation1 := TC2FMKOrganisation.Create(Afdeling);
      LPrescriptions := TC2FMKPrescriptions.Create;
      LPrescriptionErrors := TC2FMKPrescriptionErrors.Create;
      try
        if AKundenr.Trim <> '' then
        begin
          LPersonId := AKundenr.Trim;
          LPersonType := pisCPR;
        end
        else
        begin
          LPersonId := LPrescriptionIdentifier.ToString;
          LPersonType := pisMedicineCardKey;
        end;
        LResult := C2FMK.StartEffectuationRequest(Bruger.SOSIId,
          Bruger.FMKRolle.ToSOSIId, LPersonId, LPersonType, LModificator1,
          LOrganisation1, LPrescriptionIdentifier, nil, LPrescriptions,
          LPrescriptionErrors);

        // look for the administratiobn id in the order and update the rs_eksplinier
        if LResult and (LPrescriptions.Count <> 0) then
        begin
          LPrescription := LPrescriptions.ObjectList.First;
          for LOrder in LPrescription.Orders do
          begin
            if LOrder.Status = osEkspeditionPaabegyndt then
            begin
              nxRSEkspLinier.IndexName := 'OrdIdOrden';
              if nxRSEkspLinier.FindKey([inttostr(LPrescription.Identifier),AReceptId]) then
              begin
                nxRSEkspLinier.Edit;
                nxRSEkspLinier.FieldByName(fnRS_EkspLinierAdministrationID).AsString := IntToStr(LOrder.Identifier);
                nxRSEkspLinier.FieldByName(fnRS_EksplinierOrderIdentifier).AsLargeInt := LOrder.Identifier;
                nxRSEkspLinier.Post;
              end;



            end;

          end;


        end
        else
        begin
          if LPrescriptionErrors.Count <> 0 then
            ChkBoxOK(LPrescriptionErrors.First.ReasonText)
          else
            ChkBoxOK(C2FMK.LastErrorDisplayText);

          Result := False;
        end;

      finally

        FreeAndNil(LModificator1);
        FreeAndNil(LOrganisation1);
        FreeAndNil(LPrescriptions);
        FreeAndNil(LPrescriptionErrors);
      end;

    end;


//    if (C2FMK.LogXMLRequests <> lxrcNone) or (C2FMK.LogXMLResponses) then
//    begin
//      C2LogAdd('FMK XML - begin');
//      C2LogAdd(C2FMK.XMLLog.Text);
//      C2LogAdd('FMK XML - end');
//    end;
  finally
    C2FMK.XMLLog.Clear;
    C2LogAdd('FMKGetPrescriptionById - end');
  end;



end;


function FMKGetPrescriptionByMedId(AKundeNr : string;AMedId: string;  AAfdelingsNr: integer;
  var AErrorString: string): TC2FMKPrescription;
var
  LResult : boolean;
  LPrescription : TC2FMKPrescription;
  LPrescriptionIdentifier : int64;
  LPersonId : string;
  LPersonType : TFMKPersonIdentifierSource;
begin
  C2LogAdd(Format('FMKGetPrescriptionById - direct call for %s begin',[AMedid]));
  Result := Nil;

  MainDm.Afdeling.Afdelingsnr := AAfdelingsnr;


  try
    // covert the passed medid to int64
    if not TryStrToInt64(AMedId.Trim,LPrescriptionIdentifier) then
    begin
      AErrorString := 'Invalid PrescriptionId';
      exit;
    end;

    // Ensure the current record is the first with the ReceptID field
    try
      MainDM.nxSettings.First;
    except
      on E: Exception do
      begin
        C2LogAdd('Problem getting RS Settings: ' + E.Message);
        Exit;
      end;
    end;


    MainDM.cdsRSEkspeditioner.LogChanges := False;
    MainDM.cdsRSEkspeditioner.Open;
    MainDM.cdsRSEkspeditioner.EmptyDataSet;

    // get the prescription direct from FMK
    with MainDm do
    begin
      if AKundeNr.Trim <> '' then
      begin
        LPersonId := AKundeNr.Trim;
        LPersonType := pisCPR;
      end
      else
      begin
        LPersonId := LPrescriptionIdentifier.ToString;
        LPersonType := pisMedicineCardKey;
      end;

      LResult := C2FMK.GetPrescriptionRequest(Bruger.SOSIId,
        Bruger.FMKRolle.ToSOSIId, AKundenr,pisCPR, ctUndefined, LPrescriptionIdentifier, True,
        PrescriptionsForPO);
//      c2logadd(C2FMK.XMLLog.Text);
      C2FMK.XMLLog.Clear;
      if LResult then
      begin
        // if the result is empty then warn and get out ... in fact it should always be 1
        if PrescriptionsForPO.Prescriptions.Count = 0 then
        begin
          AErrorString := 'No prescription returned from FMK';
          exit;
        end;

        // point at the first (and only !!!!) prescription
        LPrescription := PrescriptionsForPO.Prescriptions[0];
        Result := LPrescription;
      end
      else
      begin
        AErrorString := C2FMK.LastErrorDisplayText;
        exit;
      end;
    end;



  finally
    C2FMK.XMLLog.Clear;
    MainDm.FMKXMLLog.Clear;
    C2LogAdd('FMKGetPrescriptionById - end');

  end;

end;



end.
