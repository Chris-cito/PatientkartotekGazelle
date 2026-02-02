unit uSearchByPatient;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExtCtrls, msxml, Grids, DBGrids,
  StdCtrls, Buttons, idmultipartFormdata,
  C2MainLog,comctrls;


  procedure SearchByPatient(fornavn,eftnavn,vej,postnr: string);
  procedure PrescriptIdList(sl: TStringList);
  procedure ProcessError(sl: TStringList);


implementation

uses uCPRlist, Main;



procedure SearchByPatient(fornavn,eftnavn,vej,postnr: string);
// search by patient
var
  requestlist : TStringList;
  doc : DOMDocument;
  rootelement : IXMLDOMElement;
  newelement : IXMLDOMElement;
  xmlelement : IXMLDOMProcessingInstruction;
  text : IXMLDOMText;
  sl : TStringList;

begin
  C2LogAdd('Search by patient routine called');
  requestlist := TStringList.Create;
  sl := TStringList.Create;
  try

    doc := CoDOMDocument.Create;
    xmlelement := doc.createProcessingInstruction('xml','version="1.0" encoding="ISO-8859-1"');
    doc.appendChild(xmlelement);
    rootelement := doc.createElement('SearchMedicationsRequest');
    rootelement.setAttribute('xmlns','http://dkma.dk/receptserver/apotekssnitflade/xml/schemas/');
    doc.appendChild(rootelement);

    // surname
    if eftnavn <> '' then
    begin
      newelement := doc.createElement('PersonSurname');
      text :=doc.createTextNode(eftnavn);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);
    end;


    //fore name

    if fornavn <> '' then
    begin
      newelement := doc.createElement('PersonGivenName');
      text := doc.createTextNode(fornavn);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);
    end;


    //street name

    if vej <> '' then
    begin
      newelement :=doc.createElement('StreetName');
      text := doc.createTextNode(vej);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);
    end;

    // Post code

    if postnr <> '' then
    begin
      newelement := doc.createElement('PostCodeIdentifier');
      text := doc.createTextNode(postnr);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

    end;


    C2LogAdd(doc.xml);
    requestlist.Text := doc.xml;
    if StamForm.SendHTTPRequest('SearchByPatient',requestlist,sl) then
      PrescriptIdList(sl)
    else
      ProcessError(sl);
  finally
    sl.Free;
    requestlist.Free;
  end;


end;


procedure PrescriptIdList(sl: TStringList);
var
  i : integer;
  doc : DOMDocument;
  nodelist : IXMLDOMNodeList;
  fieldname : string;
  Prescriptid : string;
  medCreatetime : string;
  CprNr : string;
  Surname : string;
  GivenName : string;
  StreetName : string;
  PostNr : string;
  li : tlistitem;

  procedure searchItem(node : IXMLDOMNode);
  var
    i : integer;
    nodelist : IXMLDOMNodeList;
  begin




    if node.nodeType <> node_text then
      fieldname := node.nodeName
    else
    begin

      if fieldname = 'PrescriptionID' then
        Prescriptid := node.nodeValue;

      if fieldname = 'MedicationCreatedDateTime' then
        medCreatetime := node.nodeValue;

      if fieldname = 'CivilRegistrationNumber' then
        CprNr := node.nodeValue;

      if fieldname = 'PersonSurname' then
        Surname := node.nodeValue;

      if fieldname = 'PersonGivenName' then
        GivenName := node.nodeValue;

      if fieldname = 'StreetName' then
        StreetName := node.nodeValue;

      if fieldname = 'PostCodeIdentifier' then
        PostNr := node.nodeValue;

    end;
    nodelist := node.childNodes;
    for i := 0 to nodelist.length - 1 do
      searchItem(nodelist.item[i]);

  end;


  procedure searchtree(node : IXMLDOMNode);
  var
    i : integer;
    nodelist : IXMLDOMNodeList;
  begin
    // if we get a civil registration number then there is no need to continue

      if node.nodeType = node_element then
      begin
        if node.nodeName = 'Item' then
        begin
//        C2LogAdd('*********************** start of Item');
          Prescriptid := '';
          medCreatetime := '';
          CprNr := '';
          Surname := '';
          GivenName := '';
          StreetName := '';
          PostNr := '';
          nodelist := node.childNodes;
          for i := 0 to nodelist.length - 1 do
            searchItem(nodelist.item[i]);
//          C2LogAdd('******************* end of Item');
          li := StamForm.ListView2.Items.Add;
          li.Caption := Prescriptid;
          li.SubItems.Add(medCreatetime);
          li.SubItems.Add(CprNr);
          li.SubItems.Add(Surname);
          li.SubItems.Add(GivenName);
          li.SubItems.Add(StreetName);
          li.SubItems.Add(PostNr);
          exit;
        end;
      end;

      if node.nodeType <> node_text then
        fieldname := node.nodeName
//        C2LogAdd(fieldname);
      else begin
//        c2logadd(fieldname + ' = ' + node.nodeValue);
      end;

      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do
        searchtree(nodelist.item[i]);
    end;


begin
  doc := CoDOMDocument.Create;
  try
    doc.loadXML(sl.text);
  except
    on e: Exception do
    begin
      C2LogAdd('error in loadxml ' + e.Message);
      exit;
    end;

  end;
  try
    nodelist := doc.documentElement.childNodes;
//    c2logadd(' nodelist length is ' + IntToStr(nodelist.length));


    for i:= 0 to nodelist.length - 1 do
      searchtree(nodelist.item[i]);
  except
    on e : Exception do
      C2LogAdd('Error in parse xml ' + e.Message);
  end;



end;

procedure ProcessError(sl: TStringList);
begin

end;


end.
