unit uGetMedsById;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExtCtrls, msxml, Grids, DBGrids,
  StdCtrls, Buttons, idmultipartFormdata,
  C2MainLog,db;


    procedure GetMedsById(AMedId : string);
    procedure parsePrescriptionXML(sl:TStringList);
    procedure ProcessError(sl: TStringList);


implementation

uses C2Procs, ChkBoxes, uOrdView, Main,uC2FMK.Prescription.Classes,DM;

procedure GetMedsById(AMedId : string);
// get meds by id
var
  requestlist : TStringList;
  doc : DOMDocument;
  rootelement : IXMLDOMElement;
  newelement : IXMLDOMElement;
  xmlelement : IXMLDOMProcessingInstruction;
  text : IXMLDOMText;
  sl : TStringList;
  LPrescription : tc2fmkPrescription;
  LMedId : int64;
begin
  C2LogAdd('Get meds by medication id routine called');




  requestlist := TStringList.Create;
  sl := TStringList.Create;
  try

    doc := CoDOMDocument.Create;
    xmlelement := doc.createProcessingInstruction('xml','version="1.0" encoding="ISO-8859-1"');
    doc.appendChild(xmlelement);
    rootelement := doc.createElement('GetMedicationsByMedicationIDRequest');
    rootelement.setAttribute('xmlns','http://dkma.dk/receptserver/apotekssnitflade/xml/schemas/');
    doc.appendChild(rootelement);

    // medcation id's

    newelement := doc.createElement('MedicationID');
    text :=doc.createTextNode(AMedId);
    newelement.appendChild(text);
    rootelement.appendChild(newelement);

    C2LogAdd(doc.xml);
    requestlist.Text := doc.xml;
    if StamForm.SendHTTPRequest('GetMedicationsById',requestlist,sl) then
      parseprescriptionXML(sl)
    else
      ProcessError(sl);
  finally
    sl.Free;
    requestlist.Free;
  end;



end;

procedure parsePrescriptionXML(sl: TStringList);
var
  i : integer;
  doc : DOMDocument;
  nodelist : IXMLDOMNodeList;
  fieldname : string;
  dbfieldname : string;
  admsl  : TStringList;

  procedure GetFieldName(xmlfieldname : string; var dbfieldname : string);
  begin
//    C2LogAdd(xmlfieldname);
    dbfieldname := '';

    if xmlfieldname = 'PrescriptionID' then
        dbfieldname := 'PrescriptionId';

    // sender segment field setup

    if xmlfieldname = 'sender/Identifier' then
        dbfieldname := 'SenderId';
    if xmlfieldname = 'sender/IdentifierCode' then
        dbfieldname := 'SenderType';
    if xmlfieldname = 'sender/OrganisationName' then
        dbfieldname := 'SenderNavn';
    if xmlfieldname = 'sender/StreetName' then
        dbfieldname := 'SenderVej';
    if xmlfieldname = 'sender/PostCodeIdentifier' then
        dbfieldname := 'SenderPostNr';
    if xmlfieldname = 'sender/TelephoneSubscriberIdentifier' then
        dbfieldname := 'SenderTel';
    if xmlfieldname = 'sender/MedicalSpecialityCode' then
        dbfieldname := 'SenderSpecKode';
    if xmlfieldname = 'sender/AuthorisationIdentifier' then
        dbfieldname := 'IssuerAutNr';
    if xmlfieldname = 'sender/CivilRegistrationNumber' then
        dbfieldname := 'IssuerCPRNr';
    if xmlfieldname = 'sender/TitleAndName' then
        dbfieldname := 'IssuerTitel';
    if xmlfieldname = 'sender/SpecialityCode' then
        dbfieldname := 'IssuerSpecKode';
    if xmlfieldname = 'sender/Occupation' then
        dbfieldname := 'IssuerType';
    if xmlfieldname = 'sender/SenderSystem' then
        dbfieldname := 'SenderSystem';

    // patient segment

    if xmlfieldname = 'patient/CivilRegistrationNumber' then
      dbfieldname := 'PatCPR';
    if xmlfieldname = 'patient/PersonSurname' then
      dbfieldname := 'PatEftNavn';
    if xmlfieldname = 'patient/PersonGivenName' then
      dbfieldname := 'PatForNavn';
    if xmlfieldname = 'patient/StreetName' then
      dbfieldname := 'PatVej';
    if xmlfieldname = 'patient/DistrictName' then
      dbfieldname := 'PatBy';
    if xmlfieldname = 'patient/PostCodeIdentifier' then
      dbfieldname := 'PatPostNr';
    if xmlfieldname = 'patient/CountryCode' then
      dbfieldname := 'PatLand';
    if xmlfieldname = 'patient/CountyCode' then
      dbfieldname := 'PatAmt';
    if xmlfieldname = 'patient/PatientDateOfBirth' then
      dbfieldname := 'PatFoed';
    if xmlfieldname = 'patient/PatientSex' then
      dbfieldname := 'PatKoen';

    // administrations done segment

    if xmlfieldname = 'AdmDone/AdministrationID' then
      dbfieldname := 'AdmDoneId';
    if xmlfieldname = 'AdmDone/AdministrationDateTime' then
      dbfieldname := 'AdmDoneDateTime';
    if xmlfieldname = 'AdmDone/PharmacyAdministrationNumber' then
      dbfieldname := 'AdmDoneLbnr';
    if xmlfieldname = 'AdmDone/PharmacyMedicationNumber' then
      dbfieldname := 'AdmDoneLinienr';
    if xmlfieldname = 'AdmDone/OrderInstruction' then
      dbfieldname := 'AdmDoneOrdInstruct';
    if xmlfieldname = 'AdmDone/DeliveryInformation' then
      dbfieldname := 'AdmDoneDeliveryInfo';
    if xmlfieldname = 'AdmDone/PharmacyName' then
      dbfieldname := 'AdmDoneApotekName';
    if xmlfieldname = 'AdmDone/PackageIdentifier' then
      dbfieldname := 'AdmDoneVarenr';
    if xmlfieldname = 'AdmDone/NameOfDrug' then
      dbfieldname := 'AdmDoneNavn';
    if xmlfieldname = 'AdmDone/DosageForm' then
      dbfieldname := 'AdmDoneForm';
    if xmlfieldname = 'AdmDone/PackageSize' then
      dbfieldname := 'AdmDonePakn';
    if xmlfieldname = 'AdmDone/NumberOfPackings' then
      dbfieldname := 'AdmDoneAntal';



    // administration ordered segment

    if xmlfieldname = 'AdmOrdered/OrderInstruction' then
      dbfieldname := 'OrdreInstruks';
    if xmlfieldname = 'AdmOrdered/DeliveryInformation' then
      dbfieldname := 'LeveringsInfo';
    if xmlfieldname = 'AdmOrdered/PriorityOfDelivery' then
      dbfieldname := 'LeveringPri';
    if xmlfieldname = 'AdmOrdered/StreetName' then
      dbfieldname := 'LeveringAdresse';
    if xmlfieldname = 'AdmOrdered/PseudoAddress' then
      dbfieldname := 'LeveringPseudo';
    if xmlfieldname = 'AdmOrdered/PostCodeIdentifier' then
      dbfieldname := 'LeveringPostNr';
    if xmlfieldname = 'AdmOrdered/ContactName' then
      dbfieldname := 'LeveringKontakt';

    // medication fields

    if xmlfieldname = 'Medication/MedicationID' then
      dbfieldname := 'OrdId';
    if xmlfieldname = 'Medication/VersionCheckKey' then
      dbfieldname := 'Version';
    if xmlfieldname = 'Medication/MedicationCount' then
      dbfieldname := 'OrdNr';
    if xmlfieldname = 'Medication/MedicationCreatedDateTime' then
      dbfieldname := 'OpretDato';
    if xmlfieldname = 'Medication/PackageIdentifier' then
      dbfieldname := 'VarenNr';
    if xmlfieldname = 'Medication/NameOfDrug' then
      dbfieldname := 'Navn';
    if xmlfieldname = 'Medication/DosageForm' then
      dbfieldname := 'Form';
    if xmlfieldname = 'Medication/DrugStrength' then
      dbfieldname := 'Styrke';
    if xmlfieldname = 'Medication/MagistralFormulation' then
      dbfieldname := 'Magistrel';
    if xmlfieldname = 'Medication/PackageSize' then
      dbfieldname := 'Pakning';
    if xmlfieldname = 'Medication/NumberOfPackings' then
      dbfieldname := 'Antal';
    if xmlfieldname = 'Medication/ShortName' then
      dbfieldname := 'ImportKort';
    if xmlfieldname = 'Medication/LongName' then
      dbfieldname := 'ImportLangt';
    if xmlfieldname = 'Medication/ReimbursementClause' then
      dbfieldname := 'Klausulbetingelse';
    if xmlfieldname = 'Medication/SubstitutionCode' then
      dbfieldname := 'SubstKode';
    if xmlfieldname = 'Medication/MagistralFormulation' then
      dbfieldname := 'Magistrel';
    if xmlfieldname = 'Medication/DrugDatabaseVersion' then
      dbfieldname := 'TakstVersion';
    if xmlfieldname = 'Medication/Number' then
      dbfieldname := 'IterationNr';
    if xmlfieldname = 'Medication/Interval' then
      dbfieldname := 'IterationInterval';
    if xmlfieldname = 'Medication/IntervalUnit' then
      dbfieldname := 'IterationType';
    if xmlfieldname = 'Medication/SupplementaryInformation' then
      dbfieldname := 'Supplerende';
    if xmlfieldname = 'Medication/StartDate' then
      dbfieldname := 'DosStartDato';
    if xmlfieldname = 'Medication/EndDate' then
      dbfieldname := 'DosSlutDato';


    // medication dosage segment

    if xmlfieldname = 'MedDosage/Code' then
      dbfieldname := 'DosKode';
    if xmlfieldname = 'MedDosage/Text' then
      dbfieldname := 'DosTekst';
    if xmlfieldname = 'MedDosage/Period' then
      dbfieldname := 'DosPeriod';
    if xmlfieldname = 'MedDosage/PeriodUnit' then
      dbfieldname := 'DosEnhed';

    // medication indication segment

    if xmlfieldname = 'MedIndication/Code' then
      dbfieldname := 'IndCode';
    if xmlfieldname = 'MedIndication/Text' then
      dbfieldname := 'IndText';




//        c2logadd('xmlfieldname ' + xmlfieldname + ' dbfieldname ' + dbfieldname);
  end;

  procedure searchsender(node : IXMLDOMNode);
  var
    i : integer;
    nodelist : IXMLDOMNodeList;
  begin
    if node.nodeType <> node_text then begin
      fieldname := node.nodeName;
    end else begin
      GetFieldName('sender/'+fieldname,dbfieldname);
      admsl.Add(fieldname + ' = ' + node.nodeValue);

    end;

    nodelist := node.childNodes;
    for i := 0 to nodelist.length - 1 do begin
      searchsender(nodelist.item[i]);
    end;
  end;

  procedure searchpatient(node : IXMLDOMNode);
  var
    i : integer;
    nodelist : IXMLDOMNodeList;
  begin

    if node.nodeType <> node_text then begin
      fieldname := node.nodeName;
    end else begin
      GetFieldName('patient/'+fieldname,dbfieldname);
      admsl.Add(fieldname + ' = ' + node.nodeValue);
    end;
    nodelist := node.childNodes;
    for i := 0 to nodelist.length - 1 do begin
      searchpatient(nodelist.item[i]);
    end;
  end;

  procedure searchAdmOrdered(node : IXMLDOMNode);
  var
    i : integer;
    nodelist : IXMLDOMNodeList;
  begin

    if node.nodeType <> node_text then begin
      fieldname := node.nodeName;
    end else begin
//      c2logadd(fieldname + ' = ' + node.nodeValue);
      GetFieldName('AdmOrdered/'+fieldname,dbfieldname);
      admsl.Add(dbfieldname + ' = ' + node.nodeValue);
    end;
    nodelist := node.childNodes;
    for i := 0 to nodelist.length - 1 do begin
      searchAdmOrdered(nodelist.item[i]);
    end;
  end;

  procedure searchAdmDone(node : IXMLDOMNode);
  var
    i : integer;
    nodelist : IXMLDOMNodeList;
  begin

    if node.nodeType <> node_text then begin
      fieldname := node.nodeName;
    end else begin
      GetFieldName('AdmDone/'+fieldname,dbfieldname);
      if dbfieldname <> '' then
        admsl.Add(dbfieldname + ' = ' + node.nodeValue);
    end;
    nodelist := node.childNodes;
    for i := 0 to nodelist.length - 1 do begin
      searchAdmDone(nodelist.item[i]);
    end;
  end;


  procedure searchMedDosage(node : IXMLDOMNode);
  var
    i : integer;
    nodelist : IXMLDOMNodeList;
  begin

    if node.nodeType <> node_text then begin
      fieldname := node.nodeName;
    end else begin
//      c2logadd(fieldname + ' = ' + node.nodeValue);
      GetFieldName('MedDosage/'+fieldname,dbfieldname);
    end;
    nodelist := node.childNodes;
    for i := 0 to nodelist.length - 1 do begin
      searchMedDosage(nodelist.item[i]);
    end;
  end;

  procedure searchMedIndication(node : IXMLDOMNode);
  var
    i : integer;
    nodelist : IXMLDOMNodeList;
  begin

    if node.nodeType <> node_text then begin
      fieldname := node.nodeName;
    end else begin
//      c2logadd(fieldname + ' = ' + node.nodeValue);
      GetFieldName('MedIndication/'+fieldname,dbfieldname);
    end;
    nodelist := node.childNodes;
    for i := 0 to nodelist.length - 1 do begin
      searchMedIndication(nodelist.item[i]);
    end;
  end;

  procedure searchMedication(node : IXMLDOMNode);
  var
    i : integer;
    nodelist : IXMLDOMNodeList;
  begin
    // process the medication dosage subsegments

    if node.nodeName = 'Dosage' then begin

//      C2LogAdd('************** Medication Dosage Segment');
      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do begin
            searchMedDosage(nodelist.item[i]);
      end;

//      C2LogAdd('******************* end of Medication Dosage Segment');
      exit;


    end;

    // process the medication indication subsegments

    if node.nodeName = 'Indication' then begin

//      C2LogAdd('************** Medication Indication Segment');
      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do begin
            searchMedIndication(nodelist.item[i]);
      end;

//      C2LogAdd('******************* end of Medication Indication Segment');
      exit;


    end;

    // process the medication indication subsegments


    // process the administration done segments for the medication

    if node.nodeName = 'AdministrationDone' then begin
//      C2LogAdd('************** Processing Administration Done');
      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do begin
            searchAdmDone(nodelist.item[i]);
      end;

//      C2LogAdd('******************* end of processing Administration Done');
      exit;


    end;


    if node.nodeName = 'AdministrationOrdered' then begin

//      C2LogAdd('************** Processing Administration Ordered');
      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do begin
            searchAdmOrdered(nodelist.item[i]);
      end;

//      C2LogAdd('******************* end of processing Administration Ordered');
      exit;


    end;

    if node.nodeType <> node_text then begin
      fieldname := node.nodeName;
    end else begin
      GetFieldName('Medication/'+fieldname,dbfieldname);
      admsl.Add(dbfieldname + ' = ' + node.nodeValue);
    end;
    nodelist := node.childNodes;
    for i := 0 to nodelist.length - 1 do begin
      searchMedication(nodelist.item[i]);
    end;
  end;

  procedure searchPrescription(node : IXMLDOMNode);
  var
    i : integer;
    nodelist : IXMLDOMNodeList;
  begin
    if node.nodeName = 'Sender' then begin
//        C2LogAdd('************** Processing sender');
        nodelist := node.childNodes;
        for i := 0 to nodelist.length - 1 do begin
          searchsender(nodelist.item[i]);
        end;
//        C2LogAdd('******************* end of processing sender');
        exit;
    end;

    if node.nodeName = 'PatientOrRelative' then begin
//        C2LogAdd('************** Processing patient or relative');
        nodelist := node.childNodes;
        for i := 0 to nodelist.length - 1 do begin
          searchpatient(nodelist.item[i]);
        end;
//        C2LogAdd('******************* end of processing patient or relative');
        exit;
    end;

    if node.nodeName = 'Medication' then begin
//        C2LogAdd('*************** Processing medication');
          nodelist := node.childNodes;
          for i := 0 to nodelist.length - 1 do begin
            searchMedication(nodelist.item[i]);
          end;
//        C2LogAdd('******************* end of processing medication');
        exit;
    end;



    if node.nodeType <> node_text then begin
      fieldname := node.nodeName;
    end else begin
//      c2logadd(fieldname + ' = ' + node.nodeValue);
      GetFieldName(fieldname,dbfieldname);
    end;
    nodelist := node.childNodes;
    for i := 0 to nodelist.length - 1 do begin
      searchPrescription(nodelist.item[i]);
    end;

  end;



  procedure searchtree(node : IXMLDOMNode);
  var
    i : integer;
    nodelist : IXMLDOMNodeList;
  begin

      if node.nodeType = node_element then begin
        if node.nodeName = 'Prescription' then begin
//          C2LogAdd('************** Processing Prescription');

          nodelist := node.childNodes;
          for i := 0 to nodelist.length - 1 do begin
            searchPrescription(nodelist.item[i]);
          end;
//          C2LogAdd('******************* end of processing Prescription');

          // now acknowledge the received prescription

          exit;
        end;

      end;

//      if node.nodeType <> node_text then
//        C2LogAdd(node.nodeName);
      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do begin
        searchtree(nodelist.item[i]);
      end;
  end;


begin
  admsl := TStringList.Create;
  try

    fieldname := '';
    doc := CoDOMDocument.Create;
    try
      doc.loadXML(sl.text);
    except
      on e: Exception do begin
        C2LogAdd('error in loadxml ' + e.Message);
        exit;
      end;

    end;
    try
      nodelist := doc.documentElement.childNodes;
//      c2logadd(' nodelist length is ' + IntToStr(nodelist.length));
      for i:= 0 to nodelist.length - 1 do begin
        searchtree(nodelist.item[i]);
      end;

    except
      on e : Exception do begin
        C2LogAdd('Error in parse xml ' + e.Message);
      end;
    end;
    TfrmOrdView.ShowOrdView(admsl);

  finally
    admsl.Free;
  end;

end;

procedure ProcessError(sl: TStringList);
begin

end;

end.
