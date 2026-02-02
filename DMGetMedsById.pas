unit DMGetMedsById;

interface

uses
  SysUtils, Classes, DB, nxdb, nxllComponent, Forms, DBClient, msxml, DateUtils,
  Windows,
  OverbyteIcsWndControl, OverbyteIcsHttpProt, idGlobal, IdUri;

type
  TRSLookup = record
    PrescriptId: string;
    ReceptId: integer;
  end;

  TDMRSGetMeds = class(TDataModule)
    nxRSEkspeditioner: TnxTable;
    nxRSEkspLinier: TnxTable;
    nxSettings: TnxTable;
    nxSettingsId: TIntegerField;
    nxSettingsLokationNr: TStringField;
    nxSettingsSubstLokationNr: TStringField;
    nxSettingsAfdeling: TIntegerField;
    nxSettingsPrinterNavn1: TStringField;
    nxSettingsPrinterSkuffe1: TStringField;
    nxSettingsPrinterNavn2: TStringField;
    nxSettingsPrinterSkuffe2: TStringField;
    nxSettingsReceptNo: TIntegerField;
    nxSettingsPNummer: TStringField;
    nxSettingsPapirType1: TIntegerField;
    nxSettingsPapirType2: TIntegerField;
    nxSettingsLager: TIntegerField;
    nxAfdefling: TnxTable;
    nxAfdeflingType: TStringField;
    nxAfdeflingOperation: TStringField;
    nxAfdeflingNavn: TStringField;
    nxAfdeflingRefNr: TIntegerField;
    nxAfdeflingLmsPNr: TStringField;
    nxAfdeflingLmsNr: TStringField;
    nxdb: TnxDatabase;
    mtAfdeling: TClientDataSet;
    mtAfdelingLokationNumber: TStringField;
    mtAfdelingSubstLokationNumber: TStringField;
    mtAfdelingPrinterNavn: TStringField;
    mtAfdelingPrinterSkuffe: TStringField;
    mtAfdelingPNummer: TStringField;
    mtAfdelingAfdelingNr: TIntegerField;
    mtAfdelingPapirType: TIntegerField;
    mtAfdelingLager: TIntegerField;
    mtAfdelingUsername: TStringField;
    mtAfdelingPassword: TStringField;
    mtAfdelingUserId: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    RSLookup: array [1 .. 10] of TRSLookup;
    IdHTTPHost: string;
    IdHTTPPort: string;
    CheckMed: boolean;
    function SendHTTPRequest(reqtype: string; instr: TStringList;
      outsl: TStringList): boolean;
    procedure ParseError(reqtype: string; ErrorString: string);
  public
    { Public declarations }
    function RefreshReceivedMedications(MedId: string;
      AfdelingNr: integer): boolean;
    // function CheckMedbyId(MedId : string;AfdelingNr :integer): integer;
  end;

var
  DMRSGetMeds: TDMRSGetMeds;

implementation

uses DM, C2MainLog, C2Procs, Main, C2WinApi, uRCPMidCli, chkboxes;

{$R *.dfm}

procedure TDMRSGetMeds.DataModuleCreate(Sender: TObject);
var
  cmp: TComponent;
  nxt: TnxTable;
begin

  nxdb.Session := MainDm.nxSess;
  nxdb.AliasName := 'Produktion';
  try
    for cmp in DMRSGetMeds do
    begin
      if cmp is TnxTable then
      begin
        nxt := cmp as TnxTable;
        nxt.Session := MainDm.nxSess;
        nxt.Database := nxdb;

      end;

    end;
    for cmp in DMRSGetMeds do
    begin
      if cmp is TnxTable then
      begin
        nxt := cmp as TnxTable;
        nxt.Open;

      end;

    end;
    IdHTTPHost := C2StrPrm('Ctrserver', 'CtrPemAdr', '147.29.162.198');
    IdHTTPHost := C2StrPrm('Ctrserver', 'TestAdresse', IdHTTPHost);
    IdHTTPPort := C2StrPrm('Ctrserver', 'CtrPemPort', '80');
  except
    on e: exception do
    begin
      c2logadd('Error creating datamodule for rsgetmedsbyid ' + e.message);
      Application.terminate;
    end;

  end;

end;


procedure TDMRSGetMeds.ParseError(reqtype, ErrorString: string);
var
  doc: DOMDocument;
  nodelist: IXMLDOMNodeList;
  i: integer;
begin
  if pos('<?xml', ErrorString) = 0 then
    exit;
  doc := CoDOMDocument.Create;
  try
    doc.loadXML(ErrorString);
  except
    on e: exception do
    begin
      c2logadd('error in loadxml ' + e.message);
      exit;
    end;

  end;

  nodelist := doc.documentElement.selectNodes('/ErrorResponse/ErrorCode');
  if nodelist.length > 0 then
  begin
    for i := 0 to nodelist.length - 1 do
      c2logadd('ERRORKODE=' + nodelist.item[i].text);
  end;

  nodelist := doc.documentElement.selectNodes('/ErrorResponse/Description');
  if nodelist.length > 0 then
  begin
    for i := 0 to nodelist.length - 1 do
      c2logadd('ERRORDESC=' + nodelist.item[i].text);
  end;

  nodelist := doc.documentElement.selectNodes('/ErrorResponse/Details');
  if nodelist.length > 0 then
  begin
    for i := 0 to nodelist.length - 1 do
      c2logadd('ERRORDETAILS=' + nodelist.item[i].text);
  end;

end;


function TDMRSGetMeds.RefreshReceivedMedications(MedId: string;
  AfdelingNr: integer): boolean;
var
  requestlist: TStringList;
  doc: DOMDocument;
  rootelement: IXMLDOMElement;
  newelement: IXMLDOMElement;
  xmlelement: IXMLDOMProcessingInstruction;
  text: IXMLDOMText;
  sl: TStringList;
  ErrorString: string;

  procedure ParseError(XMLString: string; var ErrorString: string);
  var
    doc: DOMDocument;
    nodelist: IXMLDOMNodeList;
    i: integer;
  begin
    if pos('<?xml', XMLString) = 0 then
      exit;
    doc := CoDOMDocument.Create;
    try
      doc.loadXML(XMLString);
    except
      on e: exception do
      begin
        c2logadd('error in loadxml ' + e.message);
        exit;
      end;

    end;

    nodelist := doc.documentElement.selectNodes('/ErrorResponse/ErrorCode');
    if nodelist.length > 0 then
    begin
      for i := 0 to nodelist.length - 1 do
        c2logadd('ERRORKODE=' + nodelist.item[i].text);
    end;

    nodelist := doc.documentElement.selectNodes('/ErrorResponse/Description');
    if nodelist.length > 0 then
    begin
      for i := 0 to nodelist.length - 1 do
      begin
        c2logadd('ERRORDESC=' + nodelist.item[i].text);
      end;
    end;

    nodelist := doc.documentElement.selectNodes('/ErrorResponse/Details');
    if nodelist.length > 0 then
    begin
      for i := 0 to nodelist.length - 1 do
      begin
        c2logadd('ERRORDETAILS=' + nodelist.item[i].text);
        ErrorString := nodelist.item[i].text;
      end;
    end;

  end;

  procedure parsePrescriptionXML(sl: TStringList; AfdelingNr: integer);
  var
    i: integer;
    doc: DOMDocument;
    nodelist: IXMLDOMNodeList;
    fieldname: string;
    dbfieldname: string;
    admDateTime: string;
    ApotekBem: string;
    ServerDateTime: TDateTime;

    procedure GetFieldName(xmlfieldname: string; var dbfieldname: string);
    begin
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

      // administration ordered segment

      if xmlfieldname = 'AdmOrdered/AdministrationID' then
        dbfieldname := 'AdministrationID';
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


      // Adm done segment only want the last date

      if xmlfieldname = 'AdmDone/AdministrationDateTime' then
        dbfieldname := 'AdminDate';
      if xmlfieldname = 'AdmDone/PharmacyComment' then
        dbfieldname := 'ApotekBem';
      if xmlfieldname = 'AdmDone/AdministrationID' then
        dbfieldname := 'AdministrationID';
      if xmlfieldname = 'AdmDone/OrderInstruction' then
        dbfieldname := 'OrdreInstruks';
      if xmlfieldname = 'AdmDone/DeliveryInformation' then
        dbfieldname := 'LeveringsInfo';
      if xmlfieldname = 'AdmDone/PriorityOfDelivery' then
        dbfieldname := 'LeveringPri';
      if xmlfieldname = 'AdmDone/StreetName' then
        dbfieldname := 'LeveringAdresse';
      if xmlfieldname = 'AdmDone/PseudoAddress' then
        dbfieldname := 'LeveringPseudo';
      if xmlfieldname = 'AdmDone/PostCodeIdentifier' then
        dbfieldname := 'LeveringPostNr';
      if xmlfieldname = 'AdmDone/ContactName' then
        dbfieldname := 'LeveringKontakt';

    end;

    procedure searchsender(node: IXMLDOMNode);
    var
      i: integer;
      nodelist: IXMLDOMNodeList;
    begin
      if node.nodeType <> node_text then
        fieldname := node.nodeName
      else
        c2logadd(fieldname + ' = ' + node.nodeValue);

      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do
        searchsender(nodelist.item[i]);
    end;

    procedure searchpatient(node: IXMLDOMNode);
    var
      i: integer;
      nodelist: IXMLDOMNodeList;
    begin

      if node.nodeType <> node_text then
        fieldname := node.nodeName
      else
        c2logadd(fieldname + ' = ' + node.nodeValue);

      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do
        searchpatient(nodelist.item[i]);
    end;

    procedure searchAdmOrdered(node: IXMLDOMNode);
    var
      i: integer;
      nodelist: IXMLDOMNodeList;
    begin

      if node.nodeType <> node_text then
        fieldname := node.nodeName
      else
      begin
        c2logadd(fieldname + ' = ' + node.nodeValue);
        GetFieldName('AdmOrdered/' + fieldname, dbfieldname);
        if dbfieldname <> '' then
        begin
          if (dbfieldname = 'AdministrationID') or
            (dbfieldname = 'OrdreInstruks') then
            if dbfieldname = 'AdministrationID' then
              nxRSEkspLinier.FieldByName(dbfieldname).AsString := node.nodeValue
            else
              nxRSEkspLinier.FieldByName(dbfieldname).AsString :=
                node.nodeValue;
        end;
      end;
      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do
        searchAdmOrdered(nodelist.item[i]);
    end;

    procedure searchAdmDone(node: IXMLDOMNode);
    var
      i: integer;
      nodelist: IXMLDOMNodeList;
    begin

      if node.nodeType <> node_text then
        fieldname := node.nodeName
      else
      begin
        c2logadd(fieldname + ' = ' + node.nodeValue);
        GetFieldName('AdmDone/' + fieldname, dbfieldname);
        if dbfieldname <> '' then
        begin
          if dbfieldname = 'AdminDate' then
            admDateTime := node.nodeValue
          else
          begin
            if dbfieldname = 'ApotekBem' then
              ApotekBem := node.nodeValue
            else
            begin
              if (dbfieldname = 'AdministrationID') or
                (dbfieldname = 'OrdreInstruks') then
                if dbfieldname = 'AdministrationID' then
                  nxRSEkspLinier.FieldByName(dbfieldname).AsString :=
                    node.nodeValue
                else
                  nxRSEkspLinier.FieldByName(dbfieldname).AsString :=
                    node.nodeValue;
            end;
          end;
        end;
      end;
      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do
        searchAdmDone(nodelist.item[i]);
    end;

    procedure searchMedDosage(node: IXMLDOMNode);
    var
      i: integer;
      nodelist: IXMLDOMNodeList;
    begin

      if node.nodeType <> node_text then
        fieldname := node.nodeName
      else
      begin
        c2logadd(fieldname + ' = ' + node.nodeValue);
        GetFieldName('MedDosage/' + fieldname, dbfieldname);
        if dbfieldname <> '' then
          nxRSEkspLinier.FieldByName(dbfieldname).AsString := node.nodeValue;
      end;
      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do
        searchMedDosage(nodelist.item[i]);
    end;

    procedure searchMedIndication(node: IXMLDOMNode);
    var
      i: integer;
      nodelist: IXMLDOMNodeList;
    begin

      if node.nodeType <> node_text then
        fieldname := node.nodeName
      else
      begin
        c2logadd(fieldname + ' = ' + node.nodeValue);
        GetFieldName('MedIndication/' + fieldname, dbfieldname);
        if dbfieldname <> '' then
          nxRSEkspLinier.FieldByName(dbfieldname).AsString := node.nodeValue;
      end;
      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do
        searchMedIndication(nodelist.item[i]);
    end;

    procedure searchMedication(node: IXMLDOMNode);
    var
      i: integer;
      nodelist: IXMLDOMNodeList;
    begin
      // process the medication dosage subsegments

      if node.nodeName = 'Dosage' then
      begin

        c2logadd('************** Medication Dosage Segment');
        nodelist := node.childNodes;
        for i := 0 to nodelist.length - 1 do
          searchMedDosage(nodelist.item[i]);

        c2logadd('******************* end of Medication Dosage Segment');
        exit;

      end;

      // process the medication indication subsegments

      if node.nodeName = 'Indication' then
      begin

        c2logadd('************** Processing medication indication');
        nodelist := node.childNodes;
        for i := 0 to nodelist.length - 1 do
          searchMedIndication(nodelist.item[i]);

        c2logadd('******************* end of medication indication');
        exit;

      end;

      // process the administration done segments for the medication

      if node.nodeName = 'AdministrationDone' then
      begin
        nxRSEkspLinier.FieldByName('AdminCount').AsInteger :=
          nxRSEkspLinier.FieldByName('AdminCount').AsInteger + 1;
        c2logadd('************** Processing Administration Done');
        nodelist := node.childNodes;
        for i := 0 to nodelist.length - 1 do
          searchAdmDone(nodelist.item[i]);

        c2logadd('******************* end of processing Administration Done');
        exit;

      end;

      if node.nodeName = 'AdministrationOrdered' then
      begin

        c2logadd('************** Processing Administration Ordered');
        nodelist := node.childNodes;
        for i := 0 to nodelist.length - 1 do
          searchAdmOrdered(nodelist.item[i]);

        c2logadd('******************* end of processing Administration Ordered');
        exit;

      end;
      if node.nodeName = 'AdministrationInProgress' then
      begin

        c2logadd('************** Processing Administration In Progress');
        nodelist := node.childNodes;
        for i := 0 to nodelist.length - 1 do
          searchAdmOrdered(nodelist.item[i]);

        c2logadd('******************* end of processing Administration In Progress');
        exit;

      end;

      if node.nodeType <> node_text then
        fieldname := node.nodeName
      else
      begin
        GetFieldName('Medication/' + fieldname, dbfieldname);
        if dbfieldname <> '' then
        begin
          if dbfieldname <> 'OrdNr' then
          begin
            if dbfieldname = 'VarenNr' then
              nxRSEkspLinier.FieldByName(dbfieldname).AsString :=
                FixLFill('0', 6, node.nodeValue)
            else
              nxRSEkspLinier.FieldByName(dbfieldname).AsString :=
                node.nodeValue;
          end;
        end;
      end;
      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do
        searchMedication(nodelist.item[i]);
    end;

    procedure searchPrescription(node: IXMLDOMNode);
    var
      i: integer;
      nodelist: IXMLDOMNodeList;
    begin
      if node.nodeName = 'Sender' then
      begin
        c2logadd('************** Processing sender');
        nodelist := node.childNodes;
        for i := 0 to nodelist.length - 1 do
          searchsender(nodelist.item[i]);
        c2logadd('******************* end of processing sender');
        exit;
      end;

      if node.nodeName = 'PatientOrRelative' then
      begin
        c2logadd('************** Processing patient or relative');
        nodelist := node.childNodes;
        for i := 0 to nodelist.length - 1 do
          searchpatient(nodelist.item[i]);
        c2logadd('******************* end of processing patient or relative');
        exit;
      end;

      if node.nodeName = 'Medication' then
      begin
        c2logadd('*************** Processing medication');
        admDateTime := '';
        ApotekBem := '';
        nxRSEkspLinier.IndexName := 'OrdIdOrden';
        if nxRSEkspLinier.FindKey([MedId]) then
        begin

          nxRSEkspLinier.Edit;
          nxRSEkspLinier.FieldByName('AdminCount').AsInteger := 0;
          nodelist := node.childNodes;
          for i := 0 to nodelist.length - 1 do
            searchMedication(nodelist.item[i]);
          if admDateTime = '' then
            nxRSEkspLinier.FieldByName('AdminDate').AsString := ''
          else
            nxRSEkspLinier.FieldByName('AdminDate').AsString :=
              copy(admDateTime, 9, 2) + '.' + copy(admDateTime, 6, 2) + '.' +
              copy(admDateTime, 1, 4);
          nxRSEkspLinier.FieldByName('ApotekBem').AsString := ApotekBem;
          nxRSEkspLinier.Post;
          c2logadd('******************* end of processing medication');
          exit;
        end;
      end;

      if node.nodeType <> node_text then
        fieldname := node.nodeName
      else
      begin
        c2logadd(fieldname + ' = ' + node.nodeValue);
        GetFieldName(fieldname, dbfieldname);
      end;
      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do
        searchPrescription(nodelist.item[i]);

    end;

    procedure searchtree(node: IXMLDOMNode);
    var
      i: integer;
      nodelist: IXMLDOMNodeList;
    begin

      if node.nodeType = node_element then
      begin
        if node.nodeName = 'Prescription' then
        begin
          c2logadd('************** Processing Prescription');
          nodelist := node.childNodes;
          for i := 0 to nodelist.length - 1 do
            searchPrescription(nodelist.item[i]);
          c2logadd('******************* end of processing Prescription');

          exit;
        end;

      end;

      if node.nodeType <> node_text then
        c2logadd(node.nodeName);
      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do
        searchtree(nodelist.item[i]);
    end;

  begin
    fieldname := '';
    // if we get a different presccription id then print the script
    // not the first one though
    doc := CoDOMDocument.Create;
    try
      doc.loadXML(sl.text);
    except
      on e: exception do
      begin
        c2logadd('error in loadxml ' + e.message);
        exit;
      end;

    end;

    MainDm.nxRemoteServerInfoPlugin1.GetServerDateTime(ServerDateTime);
    nxdb.StartTransactionWith([nxRSEkspeditioner, nxRSEkspLinier, nxSettings]);
    if nxdb.InTransaction then
    begin
      try
        try
          nodelist := doc.documentElement.childNodes;
          c2logadd(' nodelist length is ' + IntToStr(nodelist.length));
          for i := 0 to nodelist.length - 1 do
            searchtree(nodelist.item[i]);
          nxdb.Commit;
        except
          try
            c2logadd('Transaction failed. Cancelling Edit on nxRSEkspLinier');
            if nxRSEkspLinier.State <> dsbrowse then
              nxRSEkspLinier.Cancel;
          except
            on e: exception do
              c2logadd('Cancel on nxRSEkspLinier failed. Error: ' + e.message);
          end;
          raise;
        end;
      except
        on e: exception do
        begin
          try
            c2logadd('Transaction failed. Rolling back');
            nxdb.Rollback;
          except
            on e: exception do
            begin
              c2logadd('Rollback failed. Error: ' + e.message);
              SendC2ErrorMail('RSMidserv: Rollback failed',
                'Rollback failed in ParsePrescriptionXML. Error: ' + e.message);
              Application.terminate;
            end;
          end;
        end;
      end;
    end;
  end;

begin
  c2logadd('RefreshReceivedMedications routine called');

  nxSettings.IndexName := 'AfdelingOrder';
  c2logadd('afdeling number is ' + IntToStr(AfdelingNr));
  if not nxSettings.FindKey([AfdelingNr]) then
    nxSettings.FindKey([0]);
  c2logadd('nxsettings lokationnr is ' + nxSettingsLokationNr.AsString);
  mtAfdeling.Close;
  mtAfdeling.Open;
  mtAfdeling.EmptyDataSet;

  mtAfdeling.Append;
  mtAfdelingUserId.AsString := IntToStr(StamForm.FBrNr);
  mtAfdelingLokationNumber.AsString := nxSettingsLokationNr.AsString;
  mtAfdelingSubstLokationNumber.AsString := nxSettingsSubstLokationNr.AsString;
  mtAfdelingPrinterNavn.AsString := nxSettingsPrinterNavn2.AsString;
  if nxSettingsPrinterNavn2.AsString = '' then
    mtAfdelingPrinterNavn.AsString := nxSettingsPrinterNavn1.AsString;
  mtAfdelingPrinterSkuffe.AsString := nxSettingsPrinterSkuffe2.AsString;
  if nxSettingsPrinterSkuffe2.AsString = '' then
    mtAfdelingPrinterSkuffe.AsString := nxSettingsPrinterSkuffe1.AsString;
  mtAfdelingPNummer.AsString := nxSettingsPNummer.AsString;
  mtAfdelingAfdelingNr.AsInteger := nxSettingsAfdeling.AsInteger;
  mtAfdelingPapirType.AsInteger := nxSettingsPapirType2.AsInteger;
  if nxSettingsPapirType2.AsInteger = 0 then
    mtAfdelingPapirType.AsInteger := nxSettingsPapirType1.AsInteger;
  mtAfdeling.Post;
  mtAfdeling.First;

  requestlist := TStringList.Create;
  sl := TStringList.Create;
  try
    doc := CoDOMDocument.Create;
    xmlelement := doc.createProcessingInstruction('xml',
      'version="1.0" encoding="ISO-8859-1"');
    doc.appendChild(xmlelement);
    rootelement := doc.createElement('GetMedicationsByMedicationIDRequest');
    rootelement.setAttribute('xmlns',
      'http://dkma.dk/receptserver/apotekssnitflade/xml/schemas/');
    doc.appendChild(rootelement);
    // medcation id's
    newelement := doc.createElement('MedicationID');
    text := doc.createTextNode(MedId);
    newelement.appendChild(text);
    rootelement.appendChild(newelement);
    // add the markinprogress
    newelement := doc.createElement('MarkInProgress');
    text := doc.createTextNode('true');
    newelement.appendChild(text);
    rootelement.appendChild(newelement);
    // add the locaton number
    newelement := doc.createElement('MarkInProgressLocationNumber');
    text := doc.createTextNode(mtAfdelingLokationNumber.AsString);
    newelement.appendChild(text);
    rootelement.appendChild(newelement);
    // add the version check key
    newelement := doc.createElement('VersionCheckKey');
    text := doc.createTextNode('-1');
    newelement.appendChild(text);
    rootelement.appendChild(newelement);
    requestlist.text := doc.xml;
    CheckMed := False;
    Result := True;
    if SendHTTPRequest('GetMedicationsById', requestlist, sl) then
      parsePrescriptionXML(sl, AfdelingNr)
    else
    begin
      ParseError(sl.text, ErrorString);
      Application.MessageBox(PWideChar(ErrorString),
        'Ordinationen kan ikke findes på receptserveren.', MB_OK);
      Result := False;
    end;
  finally
    sl.Free;
    requestlist.Free;
  end;

end;

function TDMRSGetMeds.SendHTTPRequest(reqtype: string;
  instr, outsl: TStringList): boolean;
var
  httpparams: TStringList;
  datain: TMemoryStream;
  dataout: TMemoryStream;
  httpcli: THttpCli;
  // xxxx : tid
begin
  c2logadd('XML=' + instr.text);
  c2logadd('REQTYPE=' + reqtype);
  httpparams := TStringList.Create;
  datain := TMemoryStream.Create;
  dataout := TMemoryStream.Create;
  httpcli := THttpCli.Create(Nil);
  try
    httpparams.text := 'user=' + StamForm.FPemUserName + '&localuser=' +
      'Cito:Bruger=' + IntToStr(StamForm.FBrNr) + '&pnumber=' +
      mtAfdelingPNummer.AsString + '&password=' + StamForm.FPemPassWord +
      '&locationnumber=' + mtAfdelingLokationNumber.AsString + '&requestdata=' +
      tiduri.URLEncode(instr.text);
    c2logadd('httparams is ' + httpparams.text);
    httpparams.SaveToStream(dataout);
    dataout.Seek(0, 0);
    httpcli.Accept :=
      'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*';
    httpcli.Agent := 'Mozilla/3.0 (compatible)';
    httpcli.ContentTypePost := 'application/x-www-form-urlencoded';
    httpcli.Cookie := '';
    httpcli.MultiThreaded := False;
    httpcli.NoCache := False;
    httpcli.Proxy := '';
    httpcli.ProxyPort := '';
    httpcli.Timeout := 10000;
    IdHTTPHost := C2StrPrm('Ctrserver', 'CtrPemAdr', '147.29.162.198');
    IdHTTPHost := C2StrPrm('Ctrserver', 'TestAdresse', IdHTTPHost);
    IdHTTPPort := C2StrPrm('Ctrserver', 'CtrPemPort', '80');
    httpcli.URL := 'http://' + IdHTTPHost + ':' + IdHTTPPort +
      '/apoteksnitflade/' + reqtype;
    c2logadd('URL is ' + httpcli.URL);
    httpcli.SendStream := dataout;
    httpcli.RcvdStream := datain;
    try
      httpcli.Post;
      // test what happens if http waits
      // for i := 1 to 100 do
      // begin
      // Application.ProcessMessages;
      // sleep(50);
      // end;
      // read down xml creating class list for each file

      datain.Position := 0;
      outsl.LoadFromStream(datain);
      c2logadd(outsl.text);
      Result := True;
    except
      on e: exception do
      begin
        c2logadd('HTTP exception : ' + e.message);
        datain.Position := 0;
        outsl.LoadFromStream(datain);
        c2logadd(outsl.text);
        ParseError(reqtype, outsl.text);
        Result := False;
        if CheckMed then
          if pos('<?xml', outsl.text) <> 0 then
            Result := True;

      end;
    end;
  finally
    datain.Free;
    dataout.Free;
    httpparams.Free;
    httpcli.Free;
  end;

end;


end.
