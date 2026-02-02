unit uCPRlist;

{ Developed by: Cito IT A/S

  Description: recept oversigt

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  15-04-2020/cjs  get the correct afdelingsnavne for the report

  02-04-2020/cjs  added check if drug.identifier is assigned.   Removes the access violation reported
                  in central log
  22-01-2020/cjs  Correct afdeling navn on the receptoversigt report

  21-01-2020/cjs  Correction to iterationcount if it is 0

  21-01-2020/cjs  Do not increase interationcount by 1

  16-01-2020/cjs  Swap build name and number
  14-01-2020/cjs  Use new Drug.DrugName property

  13-01-2020/cjs  Added  exception handling to Indhold info

  08-01-2020/cjs  Set SaveCPR to ACPRNr passed in procedure call.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ExtCtrls,
  Buttons,
  C2MainLog, Comctrls, generics.collections, generics.defaults,
  uC2FMK, uC2FMK.Prescription.Classes, uC2FMK.Common.Types, System.DateUtils,
  uLagerKartotek.Tables, uC2Bruger.Types;

  procedure GetMedsByCPR(ACPRNr : string; report : boolean = True);
  procedure ProcessError(sl: TStringList);
//  function CheckMedicationUnderBehandling(CPrNr,ordid: string) : boolean;
type
  TStr100 = string;

type
  TRSMedication = record
    FullMedDate : string;
    MedDate : string;
    PrescriptionID : string;
    MedicationID :string;
    NameOfDrug : string;
    DosageForm : string;
    DrugStrength : string;
    PackageSize : string;
    NumberOfPackings : string;
    IterationCount : string;
    AdministationsDoneCount : string;
    Status : string;
    InProgressPharmacyName : string;
    StatusChange : string;
    InvalidReason : string;
    LastAdminDate : string;
    LastVarenr : string;
    DosageText : string;
    IndikationText: string;
    IterationInterval : string;
    IterationIntervalUnit : string;
    Ejs : string;
    Klaus : string;
    Indeholder : string;
    LaegeNavn : string;
    Dosis : string;
    ValidFromDate : TDateTime;
    ValidToDate : TDateTime;
  end;

type
  TStringComparer = TComparer<TRSMedication>;

implementation

uses Main, DM, PatMatrixPrinter;

function Spaces (I : integer) : string;
  var
      formatstring : string;
  begin
    formatstring := '%-' + IntToStr(i) + 's';
    Result := Format(formatstring,[' ']);
//    FillChar  (S, I + 1, ' ');
//    SetLength (S, I);
//    Spaces := S;
end;

procedure Str2Pos (IndS : string; var UdS : TStr100; P : Word);
begin
    if UdS = '' then
      UdS := Spaces (62);
    Delete (UdS, P, Length (IndS));
    Insert (IndS, UdS, P);
end;


procedure GetMedsByCPR(ACPRNr : string; report : boolean);
var
  i : integer;
  intitcount: integer;
  PNr : word;
  CivilRegistrationNumber : string;
  PersonSurname : string;
  PersonGivenName : string;
  StreetName : string;
  DistrictName : String;
  PostCodeIdentifier : string;
  pageno : integer;
  lineno : integer;
//  DosageText : string;
//  IndikationText : string;
  Medlist : TList<TRSMedication>;
  RSMedication : TRSMedication;
  tmpstr : string;
  LAfdelingsNavneIndex : string;

  procedure FMKGetByCPR(AKundenr : string);
  var
    LPrescription : TC2FMKPrescription;
    LOrder : TC2FMKOrder;
    LVarenr : string;
    LAdminCount : integer;
    LStatus : TFMKOrderStatus;
    LBehandleApotek : string;
    LDateTime: string;
  begin
    with MainDm do
    begin


//      LResult := C2FMK.GetPrescriptionRequest(Bruger.SOSIId,
//        Bruger.FMKRolle.ToSOSIId, AKundenr,ctUndefined, ipOpenPrescriptions, True,
//        PrescriptionsForPO);
//      c2logadd(C2FMK.XMLLog.Text);
//      if LResult then
      begin
        try
//         C2LogAdd('fmkGetby cpr 1');
          CivilRegistrationNumber := copy(PrescriptionsForPO.Patient.CPR, 1, 6)
            + '-XXXX';
          PersonSurname := PrescriptionsForPO.Patient.Person.Name.Surname;
          PersonGivenName := PrescriptionsForPO.Patient.Person.Name.GivenName;
          if not PrescriptionsForPO.Patient.Person.Name.MiddleName.IsEmpty then
            PersonGivenName := PersonGivenName + ' ' + PrescriptionsForPO.Patient.Person.Name.MiddleName;


          StreetName :=  PrescriptionsForPO.Patient.Address.StreetName + ' ' +
            PrescriptionsForPO.Patient.Address.StreetBuildingIdentifier;
          DistrictName := PrescriptionsForPO.Patient.Address.DistrictName;
          PostCodeIdentifier := PrescriptionsForPO.Patient.Address.
            PostCodeIdentifier;
        except

        end;
        if PrescriptionsForPO.Prescriptions.Count <> 0 then
        begin
//         C2LogAdd('fmkGetby cpr 2');

          for LPrescription in PrescriptionsForPO.Prescriptions do
          begin
//         C2LogAdd('fmkGetby cpr 3');
            with LPrescription do
            begin
              with RSMedication do
              begin
                FullMedDate := '';
                MedicationID := '';
                NameOfDrug := '';
                DosageForm := '';
                DrugStrength := '';
                PackageSize := '';
                NumberOfPackings := '';
                IterationCount := '';
                AdministationsDoneCount := '';
                Status := '';
                InProgressPharmacyName := '';
                MedDate := '';
                StatusChange := '';
                InvalidReason := '';
                LastAdminDate := '';
                LastVarenr := '';
                IterationInterval := '';
                IterationIntervalUnit := '';
                DosageText := '';
                IndikationText := '';
                Ejs := '';
                Klaus := '';
                Indeholder := '';
                LaegeNavn := '';
                Dosis := '';
                ValidFromDate := 0;
                ValidToDate := 0;

                LAdminCount := 0;
                LStatus := osUndefined;
                // ll := ListView1.Items.add;
                MedicationID := Identifier.toString;
//         C2LogAdd('fmkGetby cpr 4');

                // The DateToISO8601 returns milliseconds, but the RS didn't, so just to be 100% sure not to break anything, these are removed
                LDateTime := DateToISO8601(Created.DateTime, False);
                // Find the millisecond delimiter and remove the delimiter as well as digits
                I := LDateTime.IndexOf('.');
                if I >= 0 then
                  while (I < LDateTime.Length) and
                    (CharInSet(LDateTime.Chars[I], ['.', '0' .. '9'])) do
                    LDateTime := LDateTime.Remove(I, 1);
                FullMedDate := LDateTime;
                MedDate := FormatDateTime('dd.mm.yyyy', Created.DateTime);
//         C2LogAdd('fmkGetby cpr 5');

                LastAdminDate := '';
                if LatestEffectuationDateTime <> 0 then
                  LastAdminDate := FormatDateTime('dd.mm.yyyy',
                    LatestEffectuationDateTime);
                LBehandleApotek := '';
                if Assigned(Orders) and (Orders.Count <> 0) then
                begin
//         C2LogAdd('fmkGetby cpr 6');
                  LOrder := Orders.ObjectList.Last;
                  if LOrder.Status = osEkspeditionPaabegyndt then
                  begin
                    LStatus := LOrder.Status;
                    LBehandleApotek := LOrder.OrderedAtPharmacy.Name;
                  end;

                end;
//         C2LogAdd('fmkGetby cpr 7');

                ValidFromDate := LPrescription.ValidFromDate;
                ValidToDate :=  LPrescription.ValidToDate;


//         C2LogAdd('fmkGetby cpr 8');
                LAdminCount := OrderEffectuationsDoneCount;

                LVarenr := '';
                if PackageRestriction <> Nil then
                  LVarenr := PackageRestriction.PackageNumber.ToVnr;

//         C2LogAdd('fmkGetby cpr 9');
                with Drug do
                begin
                  NameOfDrug := DrugName.Trim;
                  if Assigned(Form) then
                    DosageForm := form.Text.Trim;
                  if Assigned(Strength) then
                    DrugStrength := Strength.Text.Trim;
//         C2LogAdd('fmkGetby cpr 10');

                  if (PackageRestriction <> Nil) and
                    (PackageRestriction.PackageSize <> Nil) then
                    PackageSize :=
                      PackageRestriction.PackageSize.PackageSizeText.Trim;
//         C2LogAdd('fmkGetby cpr 11');
                end;

                // if no varenr then get the largest pack using drugid and set the varenr and packsize
                if LVarenr = '' then
                begin
//         C2LogAdd('fmkGetby cpr 12');
                  if (Assigned(Drug)) and (Assigned(Drug.Identifier)) then
                  begin
                    try
                      with MainDm.nxdb.OpenQuery('#T 30000' + ' select top 1 ' +
                        fnLagerKartotekVareNr + ',' + fnLagerKartotekPakning +
                        ' from ' + tnLagerKartotek + ' where ' +
                        fnLagerKartotekLager_P + ' and ' +
                        fnLagerKartotekDrugId_P + ' and ' +
                        fnLagerKartotekAfmDato + ' is null' + ' order by ' +
                        fnLagerKartotekPaknNum + ' desc',
                        [StamForm.FLagernr,
                        Drug.Identifier.Identifier.toString]) do
                      begin
                        if not Eof then
                        begin
                          LVarenr := FieldByName(fnLagerKartotekVareNr)
                            .AsString;
                          PackageSize :=
                            FieldByName(fnLagerKartotekPakning).AsString;
                        end;

                        Free;
                      end;
                    except
                      on e: Exception do
                        C2LogAdd(e.Message);

                    end;
                  end;

                end;

//         C2LogAdd('fmkGetby cpr 13');
                if PackageRestriction <> Nil then
                begin
//         C2LogAdd('fmkGetby cpr 14');

                  with PackageRestriction do
                  begin
                    NumberOfPackings := PackageQuantity.toString;
                    // number of packings
                    IterationCount := IterationNumber.toString;
                    AdministationsDoneCount := LAdminCount.toString;
                    { TODO : administrationsdone }
//         C2LogAdd('fmkGetby cpr 15');
                    if IterationNumber <> 0 then
                    begin
                      RSMedication.IterationInterval :=
                        IterationInterval.toString;
                      RSMedication.IterationIntervalUnit :=
                        PackageRestriction.IterationIntervalUnit.toString;
                    end;
//         C2LogAdd('fmkGetby cpr 16');

                    LVarenr := PackageNumber.ToVnr;
                  end;
                end
                else
                begin
//         C2LogAdd('fmkGetby cpr 17');
                  NumberOfPackings := '1';
                  IterationCount := '0';
                  AdministationsDoneCount := LAdminCount.toString;
                  { TODO : administrationsdone }
                end;
//         C2LogAdd('fmkGetby cpr 18');
                if LStatus <> osUndefined then
                  Status := LStatus.toString
                else
                  Status := LPrescription.Status.toString;
                InProgressPharmacyName := LBehandleApotek;

//         C2LogAdd('fmkGetby cpr 19');
                IndikationText := Indication.Text;
                DosageText := LPrescription.DosageText;
                if not SubstitutionAllowed then
                  Ejs := 'EjS';
                if ReimbursementClause = rcKlausulbetingelseOpfyldt then
                  Klaus := 'Klausuleret tilskud';
                LaegeNavn := Created.By.AuthorisedHealthcareProfessional.Name;
                if IsDoseDispensed then
                  Dosis := 'Dosis';
//         C2LogAdd('fmkGetby cpr 20');

                try

                  // get the indehold using LVarenr
                  cdsGeneriske.IndexFieldNames := 'Varenr';
                  if cdsGeneriske.FindKey([LVarenr]) then
                  begin
                    Indeholder := 'Indhold : ' +
                      copy(cdsGeneriskeNavn.AsString, 1, 24);
                  end
                  else if Assigned(Drug.Identifier) then
                  begin
                    cdsGeneriske.IndexFieldNames := 'Drugid';
                    if cdsGeneriske.FindKey([Drug.Identifier.Identifier.toString])
                    then
                    begin
                      Indeholder := 'Indhold : ' +
                        copy(cdsGeneriskeNavn.AsString, 1, 24);
                    end

                  end;
                except
                  on E: Exception do
                    C2LogAdd('Error getting Indhold info ' + e.Message);
                end;


              end;
//         C2LogAdd('fmkGetby cpr 21');
              Medlist.Add(RSMedication);
            end;
          end;
        end;
        C2FMK.XMLLog.Clear;
      end;
    end;
  end;

begin
  with PatMatrixPrnForm do
  begin
    C2LogAdd('Get meds by CPR routine called');

    Medlist := TList<TRSMedication>.Create;
    try
      FMKGetByCPR(ACPRNr);
      FillChar(rcp,sizeof(rcp),0);

      with PatMatrixPrnForm do
      begin
        c2logadd('medist count is ' + inttostr(medlist.Count));
////          Medlist.Sort;
//          Medlist.sort(TStringComparer.Construct(
//                  function (const l,r : TRSMedication) : integer
//                  begin
//                    result := CompareText(l.FullMedDate,r.FullMedDate);
//                  end
//                  ));
          Str2Pos(CivilRegistrationNumber,rcp[1][3],1);
          Str2Pos(PersonGivenName + ' ' + PersonSurname,rcp[1][4],1);
          Str2Pos(StreetName,rcp[1][5],1);
          Str2Pos(format('%s %s',[PostCodeIdentifier,DistrictName]),rcp[1][6],1);
          pageno := 1;
          lineno := 8;
          if Medlist.Count <> 0 then
          begin

            for I := 0 to Pred(Medlist.Count) do
            begin
              RSMedication := Medlist[I];
              with RSMedication do
              begin
                if Status = 'ugyldig' then
                  continue;

                if lineno > 40 then
                begin
                  pageno := pageno + 1;
                  lineno := 8;
                end;
                // lineno := 9 + (current_item-1)*9;
                //

                tmpstr := MedDate;
                if (Now < validfromdate) or (Now > ValidToDate) then
                  tmpstr := tmpstr + '  Gyldig fra ' + FormatDateTime('dd.mm.yyyy',ValidFromDate)
                    + ' til ' + FormatDateTime('dd.mm.yyyy', ValidToDate)
                else
                  if LastAdminDate <> '' then
                    tmpstr := tmpstr + '   Sidst ekspederet ' + LastAdminDate;


                inc(lineno);
                Str2Pos(tmpstr, rcp[pageno][lineno], 1);
                tmpstr := Format('<bold>%s</bold> %s %s %s x %s %s %s <bold>%s</bold>',
                  [NameOfDrug.Trim, DosageForm.Trim, DrugStrength.Trim,
                  PackageSize.Trim, NumberOfPackings, Ejs, Klaus,Dosis]);
                // remove any double space
                tmpstr := StringReplace(tmpstr, '  ', ' ', [rfReplaceAll]);

                if Length(tmpstr) > 73 then
                begin
                  tmpstr := Format('<bold>%s</bold> %s %s',
                    [NameOfDrug.Trim, DosageForm.Trim, DrugStrength.Trim]);
                  // remove any double space
                  tmpstr := StringReplace(tmpstr, '  ', ' ', [rfReplaceAll]);
                  inc(lineno);
                  Str2Pos(tmpstr, rcp[pageno][lineno], 1);
                  tmpstr := Format('%s x %s %s %s <bold>%s</bold>',
                    [PackageSize.Trim, NumberOfPackings, Ejs, Klaus,Dosis]);
                  // remove any double space
                  tmpstr := StringReplace(tmpstr, '  ', ' ', [rfReplaceAll]);
                  inc(lineno);
                  Str2Pos(tmpstr, rcp[pageno][lineno], 1);
                end
                else
                begin
                  inc(lineno);
                  Str2Pos(tmpstr, rcp[pageno][lineno], 1);
                end;

                inc(lineno);
                Str2Pos(DosageText, rcp[pageno][lineno], 1);
                inc(lineno);
                Str2Pos(IndikationText, rcp[pageno][lineno], 1);

                if IterationInterval <> '0' then
                begin
                  inc(lineno);
                  tmpstr := 'Udleveringsinterval : ' + IterationInterval + ' ';
                  if IterationInterval <> '1' then
                  begin
                    if IterationIntervalUnit = 'dag' then
                      IterationIntervalUnit := 'dage';
                    if IterationIntervalUnit = 'uge' then
                      IterationIntervalUnit := 'uger';

                    if IterationIntervalUnit = 'måned' then
                      IterationIntervalUnit := 'måneder';

                  end;
                  tmpstr := tmpstr + IterationIntervalUnit;

                  Str2Pos(tmpstr, rcp[pageno][lineno], 1);

                end;
                tmpstr := '';
                intitcount := 0;
                try
                  intitcount := StrToInt(IterationCount);
                  if intitcount = 0 then
                    intitcount := 1;



//                  intitcount := intitcount + 1;
                except
                end;
                IterationCount := IntToStr(intitcount);
                if (StrToInt(AdministationsDoneCount) <> 0) and (intitcount = 1)
                then
                begin
                  inc(lineno);
                  tmpstr := 'Udleveret ' + AdministationsDoneCount +
                    ' af 1 (Mindre pakning)';
                end
                else
                begin
                  if StrToInt(AdministationsDoneCount) >= intitcount then
                  begin
                    inc(lineno);
                    tmpstr := 'Udleveret ' + AdministationsDoneCount + ' af ' +
                      intitcount.ToString + ' (Mindre pakning)';
                  end
                  else
                  begin
                    inc(lineno);
                    tmpstr := 'Udleveret ' + AdministationsDoneCount + ' af ' +
                      intitcount.ToString;
                  end;
                end;
                if tmpstr <> '' then
                  Str2Pos('<bold>' + tmpstr + '</bold>',
                    rcp[pageno][lineno], 1);

                inc(lineno);
                Str2Pos('Lægenavn : ' + LaegeNavn, rcp[pageno][lineno], 1);
                inc(lineno);
                Str2Pos(Indeholder, rcp[pageno][lineno], 1);
                inc(lineno);
                Str2Pos('', rcp[pageno][lineno], 1);
              end;
            end;
          end
          else
          begin
            inc(lineno);
            Str2Pos('ingen recepter', rcp[pageno][lineno], 1);
          end;
        end;

      C2LogAdd('afdnr in getmedsbycpr ' + MainDm.AfdNr.ToString);
      Str2Pos('Receptoversigt', rcp[1][1],1);

      LAfdelingsNavneIndex := MainDm.ffAfdNvn.IndexName;
      maindm.ffAfdNvn.IndexName := 'NrOrden';
      try
        if not maindm.ffAfdNvn.FindKey([MainDm.AfdNr]) then
        begin
          C2LogAdd('AfdelingsNavne record not found. Use first');
          MainDm.ffAfdNvn.First;
        end;

      finally
        MainDm.ffAfdNvn.IndexName := LAfdelingsNavneIndex;
      end;

      Str2Pos(MainDm.ffAfdNvnNavn.AsString,rcp[1][1],20);
      if maindm.ffAfdNvnRefNr.AsInteger = 0 then
      begin
        Str2Pos(MainDm.ffFirmaNavn.AsString,rcp[1][1],20);
        Str2Pos('Tlf. ' + MainDm.ffFirmaTlfNr.AsString,rcp[1][2],20);
      end;

      PatMatrixPrnForm.rcppages := pageno;
      PatMatrixPrnForm.CPRNr := ACPRNr;
      PNr := 999;
      PrintMatrix(PNr,'');


    finally
      FreeAndNil(Medlist);
    end;

  end;
end;


procedure ProcessError(sl: TStringList);
begin

end;

end.
