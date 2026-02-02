unit uFMKCalls;

{ Developed by: Vitec Cito A/S

  Description: Routines to communicate with FMK

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  06-06-2021/MA   Modified to support various PersonIdentifierSources (X-eCPR, etc.).
  16-03-2020/cjs  Add the Receptid to invalidate call so we point at the correct line
  24-02-2020/cjs  Use the PatPersonIdentifier and source when terminating a prescription
  20-02-2020/cjs  Terminate prescription now being passed the PatCPr field from rs_ekspeditioner
}

interface
uses
  System.Classes, System.SysUtils, Data.DB,
  uC2FMK.Prescription.Classes,nxdb,vcl.comctrls,
  uC2Afdeling.Classes, uC2Bruger.Types, uC2FMK.Common.Types,
  uC2FMK.PersonOrganisation.Classes, ChkBoxes, uC2FMK.Common.classes;


/// <summary>A request to Remove status on on a FMK administration.</summary>
/// <param name="AAfdelingsnr">The afdeling number.</param>
/// <param name="ACPrNr">The patient cpr number.</param>
/// <param name="AReceptId">The receptid of rs_eksplinier.</param>
/// <param name="APrescriptionID">The PrescriptionId to abort.</param>
/// <param name="AAdministrationId">The OrderId to abort on the perscription.</param>
/// <param name="ANxdb">Database component used if deleting local copy of ordination.</param>
function FMKRemoveStatus(AAfdelingsnr: Integer; APersonId: string; APersonIdSource: TFMKPersonIdentifierSource;
  AReceptId: Integer; APrescriptionID: int64; AAdministrationId: int64;
  ANxdb: TnxDatabase = Nil): boolean;


/// <summary>A request to invalidate a prescription.</summary>
/// <param name="ACPrNr">The patient cpr number.</param>
/// <param name="APrescriptionID">The PrescriptionId to abort.</param>
/// <param name="AReceptID">The ReceptId of Rs-ekspinier.</param>
/// <param name="AReasonText">The text for the invalidation.</param>
/// <param name="ANxdb">Database component used if deleting local copy of ordination.</param>
function FMKInvalidate(ACPrNr: string; APrescriptionID: int64; AReceptid : integer;
  AReasonText: string; ANxdb: TnxDatabase = Nil): boolean;

/// <summary>A request to terminate a prescription.</summary>
/// <param name="ACPrNr">The patient cpr number.</param>
/// <param name="APatPersonIdentifier">The patient cpr number could be medicinecardkey</param>
/// <param name="ACPrNr">The patientiderntifer sourcetype.</param>
/// <param name="APrescription">The PrescriptionId to abort.</param>
/// <param name="ASenderId">Doctor or hospital number</param>
/// <param name="ASenderType">Sendertype</param>
/// <param name="ANxdb">Database component used if deleting local copy of ordination.</param>
function FMKTerminatePrescription(ACPrNr: string; APatPersonIdentifier: string;
  APatPersonIdentifierSource: integer; APrescriptionID: int64;
  ASenderId: string; ASenderType: string; ANxdb: TnxDatabase = Nil): boolean;


function FMKSearchPrescriptions(AListView : TListView; AGivenName, ASurname: string;
  ABirthDate: TDate; AWithoutCPR: boolean;
  APostnr: string): boolean;


/// <summary>A request to undo an effectuation.</summary>
/// <param name="ACPrNr">The patient cpr number.</param>
/// <param name="APrescriptionId">The PrescriptionId to abort.</param>
/// <param name="AOderId">The Order Id to abort.</param>
/// <param name="AAdministrationId">The Effectuation id to be aborted.</param>
/// <param name="ATerminate">Whether the ordination should be marked as Terminated.</param>
function FMKUndoEffectuation(APersonId: string; APersonIdSource: TFMKPersonIdentifierSource; APrescriptionID, AOrderId,
  AEffectuationId: int64; ATerminate: boolean = False): boolean;


implementation

uses
  DM, C2MainLog,
  uRS_Ekspeditioner.Tables, uRS_EkspLinier.Tables,
  uC2FMK;





function FMKRemoveStatus(AAfdelingsnr: Integer; APersonId: string;
  APersonIdSource: TFMKPersonIdentifierSource;
  AReceptId : integer; APrescriptionID : int64;
  AAdministrationId : int64; ANxdb : TnxDatabase = Nil): boolean;
var
  LModificator1 : TC2FMKModificator;
  LResult : Boolean;
  LEffectuationsAborted : TC2FMKAbortEffectuationsOnPrescriptionsAndOrders;
  LPrescriptionErrors : TC2FMKPrescriptionErrors;
  LNxQuery : TnxQuery;
  LPrescriptionError : TC2FMKPrescriptionError;
  LReceptId : integer;
begin
  with MainDm do
  begin
      Afdeling.Afdelingsnr := AAfdelingsnr;

      LModificator1 := TC2FMKModificator.Create(Bruger, Afdeling);
      LEffectuationsAborted := TC2FMKAbortEffectuationsOnPrescriptionsAndOrders.Create;
      LPrescriptionErrors := TC2FMKPrescriptionErrors.Create;
      try

//        if ACPrNr.Trim <> '' then
//        begin
//          LPersonId := ACPrNr.Trim;
//          LPersonType := pisCPR;
//        end
//        else
//        begin
//          LPersonId := AprescriptionId.ToString;
//          LPersonType := pisMedicineCardKey;
//        end;

      LResult := C2FMK.AbortEffectuationRequest(Bruger.SOSIId,
        Bruger.FMKRolle.ToSOSIId, APersonId, APersonIdSource,
        LModificator1, APrescriptionID, AAdministrationId,
        LEffectuationsAborted, LPrescriptionErrors);

        if LResult then
        begin

          // check íf any failed

          if LPrescriptionErrors.Count <> 0 then
          begin

            LPrescriptionError := LPrescriptionErrors.First;
            { TODO : error checking removestatus }
            //            if LPrescriptionError.ReasonCode then
            C2LogAdd(LPrescriptionError.ReasonText);
//            ChkBoxOK(LPrescriptionError.ReasonText);
            LResult := False;
            exit;

          end;




          LReceptid := AReceptId;
          if ANxdb <> Nil then
          begin
            if LReceptId = 0  then
            begin

              // get the receptid from rs_eksplinier if not there exit;
              with ANxdb.OpenQuery
                ('select ' + fnRS_EksplinierReceptId + ' from ' + tnRS_Eksplinier
                + ' where  ' + fnRS_EksplinierPrescriptionIdentifier_P + ' and ' +
                fnRS_EksplinierOrderIdentifier_P,
                [ APrescriptionID, AAdministrationId ]) do
              begin
                try
                  C2LogAdd(sql.Text);
                  if Eof then
                    exit;

                  LReceptid := FieldByName('ReceptId').AsInteger;
                  if LReceptid = 0 then
                    exit;

                finally
                  Free;
                end;
              end;
            end;

            // delete the entry rom rs_eksplinier;
            LNxQuery := TnxQuery.Create(Nil);
            try
              with LNxQuery do
              begin
                Database := ANxdb;
                sql.Text := 'delete from ' + tnRS_Eksplinier +  ' where  ' + fnRS_EksplinierPrescriptionIdentifier_P +
                ' and ' + fnRS_EkspLinierOrderIdentifier_P + ' and ' + fnRS_EkspLinierReceptId_P;
                ParamByName(fnRS_EkspLinierPrescriptionIdentifier).AsLargeInt := APrescriptionID;
                ParamByName(fnRS_EkspLinierOrderIdentifier).AsLargeInt := AAdministrationId;
                ParamByName(fnRS_EkspLinierReceptId).AsLargeInt := LReceptid;

                try
                  C2LogAdd(sql.Text);
                  ExecSQL;
                  if RowsAffected = 0 then
                    exit;

                except
                  on E: Exception do
                  begin
                    C2LogAdd('Fejl i delete Rs_eksplinier  ' + e.Message);
                     exit;
                  end;
                end;

              end;
            finally
              LNxQuery.Free;
            end;

            // now check to see if there are any lines in rs_eksplinier left for ReceptId
            with ANxdb.OpenQuery
              ('select ' + fnRS_EksplinierReceptId + ' from ' + tnRS_Eksplinier
              + ' where ' + fnRS_EkspLinierReceptId_P,[LReceptid]) do
            begin
              try

                if not Eof then
                  exit;

              finally
                Free;
              end;
            end;

            // if we get here then there are no lines left so we delete the entry in RS_Ekspeditioner
            LNxQuery := TnxQuery.Create(Nil);
            try
              with LNxQuery do
              begin
                Database := ANxdb;
                sql.Text := 'delete from ' + tnRS_Ekspeditioner + ' where  ' +
                  fnRS_EkspeditionerReceptId + '=:Receptid';
                ParamByName('ReceptId').AsInteger := LReceptid;
                try
                  ExecSQL;
                  if RowsAffected = 0 then
                    exit;

                except
                  on E: Exception do
                  begin
                    C2LogAdd('Fejl i delete Rs_ekspeditioner  ' + e.Message);
                     exit;
                  end;
                end;

              end;
            finally
              LNxQuery.Free;
            end;

          end;

        end;


      finally
        C2FMK.XMLLog.Clear;
        FreeAndNil(LModificator1);
        FreeAndNil(LEffectuationsAborted);
        FreeAndNil(LPrescriptionErrors);
        Result := LResult;
      end;
  end;

end;


function FMKInvalidate(ACPrNr: string; APrescriptionID: int64; AReceptid : integer;
  AReasonText: string; ANxdb: TnxDatabase): boolean;
var
  LModificator1 : TC2FMKModificator;
  LOrganisation1 : TC2FMKOrganisation;
  LResult : Boolean;
  LIDs : TC2FMKIDs;
  LReceptId : int64;
  LNxQuery : TnxQuery;
  LPersonId : string;
  LPersonIdSource: TFMKPersonIdentifierSource;

begin
  with MainDm do
  begin


    LModificator1 := TC2FMKModificator.Create(Bruger, Afdeling);
    LOrganisation1 := TC2FMKOrganisation.Create(Afdeling);
    LIDs := TC2FMKIDs.Create;

    try
      if ACPrNr.Trim <> '' then
      begin
        LPersonId := ACPrNr.Trim;
        { TODO : 03-06-2021/MA: Replace constant with real PersonIdSource passed as a parameter to this function }
        LPersonIdSource := TFMKPersonIdentifierSource.DetectSource(LPersonId);
      end
      else
      begin
        LPersonId := AprescriptionId.ToString;
        LPersonIdSource := pisMedicineCardKey;
      end;
      LResult := C2FMK.InvalidatePrescriptionRequest(Bruger.SOSIId,
        Bruger.FMKRolle.ToSOSIId, LPersonId, LPersonIdSource, LModificator1,
        APrescriptionID, AReasonText, LIDs);
//      c2logadd(C2FMK.XMLLog.Text);
      if LResult then
      begin

        LReceptid := AReceptid;
        if ANxdb <> Nil then
        begin
//          // get the receptid from rs_eksplinier if not there exit;
//          with ANxdb.OpenQuery
//            ('select ' + fnRS_EksplinierReceptId + ' from ' + tnRS_Eksplinier
//            + ' where  ' + fnRS_EkspLinierPrescriptionIdentifier_P,
//            [ APrescriptionID ]) do
//          begin
//            try
//              C2LogAdd(sql.Text);
//              if Eof then
//                exit;
//
//              LReceptid := FieldByName('ReceptId').AsInteger;
//              if LReceptid = 0 then
//                exit;
//
//            finally
//              Free;
//            end;
//          end;
//
          // delete the entry rom rs_eksplinier;
          LNxQuery := TnxQuery.Create(Nil);
          try
            with LNxQuery do
            begin
              Database := ANxdb;
              sql.Text := 'delete from ' + tnRS_Eksplinier +  ' where  ' + fnRS_EksplinierPrescriptionIdentifier_P +
              ' and '  + fnRS_EkspLinierReceptId_P;
              ParamByName(fnRS_EkspLinierPrescriptionIdentifier).AsLargeInt := APrescriptionID;
              ParamByName(fnRS_EkspLinierReceptId).AsLargeInt := LReceptid;

              try
                C2LogAdd(sql.Text);
                ExecSQL;
                if RowsAffected = 0 then
                  exit;

              except
                on E: Exception do
                begin
                  C2LogAdd('Fejl i delete Rs_eksplinier  ' + e.Message);
                   exit;
                end;
              end;

            end;
          finally
            LNxQuery.Free;
          end;

          // now check to see if there are any lines in rs_eksplinier left for ReceptId
          with ANxdb.OpenQuery
            ('select ' + fnRS_EksplinierReceptId + ' from ' + tnRS_Eksplinier
            + ' where ' + fnRS_EkspLinierReceptId_P,[LReceptid]) do
          begin
            try

              if not Eof then
                exit;

            finally
              Free;
            end;
          end;

          // if we get here then there are no lines left so we delete the entry in RS_Ekspeditioner
          LNxQuery := TnxQuery.Create(Nil);
          try
            with LNxQuery do
            begin
              Database := ANxdb;
              sql.Text := 'delete from ' + tnRS_Ekspeditioner + ' where  ' +
                fnRS_EkspeditionerReceptId + '=:Receptid';
              ParamByName('ReceptId').AsInteger := LReceptid;
              try
                ExecSQL;
                if RowsAffected = 0 then
                  exit;

              except
                on E: Exception do
                begin
                  C2LogAdd('Fejl i delete Rs_ekspeditioner  ' + e.Message);
                   exit;
                end;
              end;

            end;
          finally
            LNxQuery.Free;
          end;

        end;

      end;
    finally
      C2FMK.XMLLog.Clear;
      FreeAndNil(LModificator1);
      FreeAndNil(LOrganisation1);
      FreeAndNil(LIDs);
    end;

  end;

end;


function FMKTerminatePrescription(ACPrNr: string; APatPersonIdentifier: string;
  APatPersonIdentifierSource: integer; APrescriptionID: int64;
  ASenderId: string; ASenderType: string; ANxdb: TnxDatabase = Nil): boolean;

var
  LModificator1 : TC2FMKModificator;
  LOrganisation1 : TC2FMKOrganisation;
  LResult : Boolean;
  LIDs : TC2FMKIDs;
  LReceptId : int64;
  LNxQuery : TnxQuery;
  LPersonId : string;
  LPersonIdSource : TFMKPersonIdentifierSource;
  LSenderId : string;
  LOrganisationSource : TFMKOrganisationIdentifierSource;
begin
  with MainDm do
  begin
    LModificator1 := TC2FMKModificator.Create(Bruger, Afdeling);
    LOrganisation1 := TC2FMKOrganisation.Create(Afdeling);
    LIDs := TC2FMKIDs.Create;
    try
      if ACPRnr.Trim <> '' then
      begin
        LPersonId := ACPRnr.Trim;
        LPersonIdSource := TFMKPersonIdentifierSource.DetectSource(LPersonId);
      end
      else
      begin
        LPersonId := APatPersonIdentifier;
        LPersonIdSource := TFMKPersonIdentifierSource.Parse(APatPersonIdentifierSource);
      end;
      LResult := C2FMK.TerminatePrescriptionRequest(Bruger.SOSIId,
        Bruger.FMKRolle.ToSOSIId, LPersonId, LPersonIdSource, LModificator1,
        APrescriptionID, LIDs);

      // try using organisation rather than patientdetails
      if not LResult then
      begin
        if ACPRnr.Trim = '' then
        begin
          LSenderId := ASenderId;
          while LSenderId.StartsWith('0') do
          begin
              LSenderId := LSenderId.Remove(0,1)
          end;

          LOrganisationSource := TFMKOrganisationIdentifierSource.ParseRSString(ASenderType);
          LResult := C2FMK.TerminatePrescriptionRequest(Bruger.SOSIId,
            Bruger.FMKRolle.ToSOSIId, '', pisCPR, LModificator1, // The use of blank PersonId is intentional to force the function to use the Org.id instead
            APrescriptionID, LIDs,LSenderId,LOrganisationSource);
          if not LResult then
          begin
            ChkBoxOK(C2FMK.LastErrorDisplayText);
            exit;
          end;


        end;


      end;


      if LResult then
      begin
        if LIDs.Count <> 1 then
        begin
          LResult := False;
          exit;
        end;

        LReceptid := 0;
        if ANxdb <> Nil then
        begin
          // get the receptid from rs_eksplinier if not there exit;
          with ANxdb.OpenQuery
            ('select ' + fnRS_EksplinierReceptId + ' from ' + tnRS_Eksplinier
            + ' where  ' + fnRS_EkspLinierPrescriptionIdentifier_P,
            [ APrescriptionID ]) do
          begin
            try
              C2LogAdd(sql.Text);
              if Eof then
                exit;

              LReceptid := FieldByName('ReceptId').AsInteger;
              if LReceptid = 0 then
                exit;

            finally
              Free;
            end;
          end;

          // delete the entry rom rs_eksplinier;
          LNxQuery := TnxQuery.Create(Nil);
          try
            with LNxQuery do
            begin
              Database := ANxdb;
              sql.Text := 'delete from ' + tnRS_Eksplinier +  ' where  ' + fnRS_EksplinierPrescriptionIdentifier_P +
              ' and '  + fnRS_EkspLinierReceptId_P;
              ParamByName(fnRS_EkspLinierPrescriptionIdentifier).AsLargeInt := APrescriptionID;
              ParamByName(fnRS_EkspLinierReceptId).AsLargeInt := LReceptid;

              try
                C2LogAdd(sql.Text);
                ExecSQL;
                if RowsAffected = 0 then
                  exit;

              except
                on E: Exception do
                begin
                  C2LogAdd('Fejl i delete Rs_eksplinier  ' + e.Message);
                   exit;
                end;
              end;

            end;
          finally
            LNxQuery.Free;
          end;

          // now check to see if there are any lines in rs_eksplinier left for ReceptId
          with ANxdb.OpenQuery
            ('select ' + fnRS_EksplinierReceptId + ' from ' + tnRS_Eksplinier
            + ' where ' + fnRS_EkspLinierReceptId_P,[LReceptid]) do
          begin
            try

              if not Eof then
                exit;

            finally
              Free;
            end;
          end;

          // if we get here then there are no lines left so we delete the entry in RS_Ekspeditioner
          LNxQuery := TnxQuery.Create(Nil);
          try
            with LNxQuery do
            begin
              Database := ANxdb;
              sql.Text := 'delete from ' + tnRS_Ekspeditioner + ' where  ' +
                fnRS_EkspeditionerReceptId + '=:Receptid';
              ParamByName('ReceptId').AsInteger := LReceptid;
              try
                ExecSQL;
                if RowsAffected = 0 then
                  exit;

              except
                on E: Exception do
                begin
                  C2LogAdd('Fejl i delete Rs_ekspeditioner  ' + e.Message);
                   exit;
                end;
              end;

            end;
          finally
            LNxQuery.Free;
          end;


        end;

      end;
    finally
      if (C2FMK.LogXMLRequests <> lxrcNone) or (C2FMK.LogXMLResponses) then
      begin
        C2LogAdd('FMK XML - begin');
//        C2LogAdd(C2FMK.XMLLog.Text);
        C2LogAdd('FMK XML - end');
      end;
      C2FMK.XMLLog.Clear;
      FreeAndNil(LModificator1);
      FreeAndNil(LOrganisation1);
      FreeAndNil(LIDs);
      Result := LResult;
    end;

  end;

end;

function FMKSearchPrescriptions(AListView : TListView;AGivenName, ASurname: string;
  ABirthDate: TDate; AWithoutCPR: boolean;
  APostnr: string): boolean;
var
  LResult : boolean;
  LSearchResult: TC2FMKPrescriptionSearchResult;
  LSearchResults: TC2FMKPrescriptionSearchResults;
  LListitem : TListItem;
begin
  with MainDm do
  begin
    LSearchResults := TC2FMKPrescriptionSearchResults.Create;
    try
      LResult := C2FMK.SearchMedicineCardRequest(Bruger.SOSIId, Bruger.FMKRolle.ToSOSIId, LSearchResults,
        AGivenName, ASurname, ABirthDate,AWithoutCPR, '', '', APostnr);
//      c2logadd(C2FMK.XMLLog.Text);
      if not LResult then
        ChkBoxOK(C2FMK.LastErrorDisplayText)
      else
      begin
        if LSearchResults.Count  = 0 then
        begin
          LResult := False;
          exit;
        end;

        for LSearchResult in LSearchResults do
        begin
          with LSearchResult.Patient do
          begin
            if Assigned(Person) then
            begin

              LListitem := AListView.Items.Add;
              with Person do
              begin
                if PersonIdentifierSource <> pisMedicineCardKey then
                  LListitem.Caption := PersonIdentifier;
                LListitem.SubItems.Add(Name.Surname);
                LListitem.SubItems.Add((Name.GivenName + ' ' + Name.MiddleName).Trim);
              end;

              if assigned(Address) then
              begin

                LListitem.SubItems.Add(Address.StreetName + ' ' + Address.StreetBuildingIdentifier);
                LListitem.SubItems.Add(Address.PostCodeIdentifier);
              end
              else
              begin
                LListitem.SubItems.Add('');
                LListitem.SubItems.Add('');
              end;


             if Person.PersonIdentifierSource in [pisMedicineCardKey, pisXeCPR, pisSORPerson] then
             begin
              LListitem.SubItems.Add(Person.PersonIdentifier);
              LListitem.SubItems.Add(FormatDateTime('yyyy-mm-dd', LSearchResult.Created.DateTime));
             end
             else
             begin
              LListitem.SubItems.Add('');
              LListitem.SubItems.Add('');
             end;


            end;

          end;

        end;


        LResult := AListView.Items.Count <> 0;

      end;



    finally
      Result := LResult;
      LSearchResults.Free;
      C2FMK.XMLLog.Clear;
    end;

  end;

end;


function FMKUndoEffectuation(APersonId: string; APersonIdSource: TFMKPersonIdentifierSource;
  APrescriptionID, AOrderId,
  AEffectuationId: int64; ATerminate: boolean): boolean;
var
  LModificator1: TC2FMKModificator;
  LResult: boolean;
  LUndoneEffectuations: TC2FMKPrescriptionOrderAndEffectuationIDs;
begin
  with MainDm do
  begin

    LResult := False;
    if AEffectuationId = 0 then
      exit;


    LUndoneEffectuations :=
      TC2FMKPrescriptionOrderAndEffectuationIDs.Create;
    LModificator1 := TC2FMKModificator.Create(Bruger, Afdeling);
    try
      LResult := C2FMK.UndoEffectuationRequest(Bruger.SOSIId,
        Bruger.FMKRolle.ToSOSIId, APersonId, APersonIdSource, LModificator1, APrescriptionID,
        AOrderId, AEffectuationId, ATerminate, LUndoneEffectuations);
      if LResult then
      begin
        if LUndoneEffectuations.Count <> 1 then
        begin
          ChkBoxOK('UndoneEffectuations count ' + LUndoneEffectuations.Count.ToString );
        end;
      end
      else
      begin
        ChkBoxOK(C2FMK.LastErrorDisplayText);
      end;

    finally
      Result := LResult;
      FreeAndNil(LUndoneEffectuations);
      FreeAndNil(LModificator1);
      C2FMK.XMLLog.Clear;
    end;

  end;

end;

end.
