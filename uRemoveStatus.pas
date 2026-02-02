unit uRemoveStatus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
OverbyteRFormat, OverbyteIcsWndControl,
  OverbyteApsCli, OverbyteIcsHttpProt,
  IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExtCtrls, msxml, Grids, DBGrids,
  StdCtrls, Buttons,
   RpRender, RpRenderCanvas, RpRenderPreview, RpFiler,RpRenderPrinter,
   RpRenderPDF,RpBars,  idmultipartFormdata,
  C2MainLog,DB;


  procedure RemoveStatus(sl:TStringList);
  procedure RemoveStatus2(sl:TStringList);
  procedure RemoveStatus3(sl:TStringList);
  procedure ProcessError(sl: TStringList);
  procedure ProcessError2(sl: TStringList);


implementation

uses DM, main, ChkBoxes;

procedure createXML(sl:TStringList);
var
  requestlist : TStringList;
  doc : IXMLDOMDocument;
  rootelement : IXMLDOMElement;
  newelement : IXMLDOMElement;
  xmlelement : IXMLDOMProcessingInstruction;
  text : IXMLDOMText;
  ReceptId : integer;

begin
  requestlist := TStringList.Create;
  try
    with MainDM do
    begin
      ReceptId := nxRSEkspLinListReceptId.AsInteger;
      doc := CoDOMDocument.Create;
      xmlelement := doc.createProcessingInstruction('xml','version="1.0" encoding="ISO-8859-1"');
      doc.appendChild(xmlelement);

      rootelement := doc.createElement('RemoveStatusInProcessRequest');
      rootelement.setAttribute('xmlns','http://dkma.dk/receptserver/apotekssnitflade/xml/schemas/');
      doc.appendChild(rootelement);

      // location number

      newelement := doc.createElement('LocationNumber');
      text :=doc.createTextNode(nxSettingsLokationNr.AsString);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      // medication id

      newelement := doc.createElement('MedicationID');
      text :=doc.createTextNode(nxRSEkspLinListOrdId.AsString);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      // VersionCheckKey

      newelement := doc.createElement('VersionCheckKey');
      text :=doc.createTextNode(nxRSEkspLinListVersion.AsString);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      C2LogAdd(doc.xml);
      requestlist.Text := doc.xml;
      if StamForm.SendHTTPRequest('RemoveStatusInProcess',requestlist,sl) then
      begin
        try

          nxRSEkspLinList.Delete;

          // check to see if there are no lines with this recept id.
          nxRSEkspLin.IndexName := 'ReceptIDOrder';
          if not nxRSEkspLin.FindKey([ReceptId]) then
          begin
            nxRSEksp.IndexName := 'ReceptIdOrder';
            if nxRSEksp.FindKey([ReceptId]) then
              nxRSEksp.Delete;
          end;




        except
          if nxRSEkspList.State <> dsbrowse then
            nxRSEkspList.Cancel;
          if nxRSEkspLinList.State <> dsbrowse then
            nxRSEkspLinList.Cancel;
        end;
      end
      else
      begin
        if ChkBoxYesNo( 'Ordinationen er ikke under behandling på receptserveren.' +#13#10 +
                        'Skal den bare slettes lokalt?',True) then
        begin
          c2logadd('Receptkvitteringen går i fejl, når den forsøges sendt til receptserveren.' + #13#10+
            'Ønsker du at slette receptkvitteringen lokalt?');
          c2logadd('Recept id is ' + nxRSEkspListReceptId.AsString +
                  ' Medication Id ' + nxRSEkspLinListOrdId.AsString);
          try
            nxRSEkspLinList.Delete;

            // check to see if there are no lines with this recept id.
            nxRSEkspLin.IndexName := 'ReceptIDOrder';
            if not nxRSEkspLin.FindKey([ReceptId]) then
            begin
              nxRSEksp.IndexName := 'ReceptIdOrder';
              if nxRSEksp.FindKey([ReceptId]) then
                nxRSEksp.Delete;
            end;




          except
            if nxRSEkspList.State <> dsbrowse then
              nxRSEkspList.Cancel;
            if nxRSEkspLinList.State <> dsbrowse then
              nxRSEkspLinList.Cancel;
          end;
        end;
        ProcessError(sl);
      end;
    end;
  finally

    requestlist.Free;

  end;

end;

procedure createXML2(sl:TStringList);
var
  requestlist : TStringList;
  doc : IXMLDOMDocument;
  rootelement : IXMLDOMElement;
  newelement : IXMLDOMElement;
  xmlelement : IXMLDOMProcessingInstruction;
  text : IXMLDOMText;
  ReceptId : integer;

begin
  requestlist := TStringList.Create;
  try
    with MainDM do
    begin

      ReceptId := nxRSEkspLinReceptId.AsInteger;

      doc := CoDOMDocument.Create;
      xmlelement := doc.createProcessingInstruction('xml','version="1.0" encoding="ISO-8859-1"');
      doc.appendChild(xmlelement);

      rootelement := doc.createElement('RemoveStatusInProcessRequest');
      rootelement.setAttribute('xmlns','http://dkma.dk/receptserver/apotekssnitflade/xml/schemas/');
      doc.appendChild(rootelement);

      // location number

      newelement := doc.createElement('LocationNumber');
      text :=doc.createTextNode(nxSettingsLokationNr.AsString);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      // medication id

      newelement := doc.createElement('MedicationID');
      text :=doc.createTextNode(nxRSEkspLinOrdId.AsString);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      // VersionCheckKey

      newelement := doc.createElement('VersionCheckKey');
      text :=doc.createTextNode('-1');
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      C2LogAdd(doc.xml);
      requestlist.Text := doc.xml;
      if StamForm.SendHTTPRequest('RemoveStatusInProcess',requestlist,sl) then
      begin
        try
          nxRSEkspLin.Delete;


          // check to see if there are no lines with this recept id.
          nxRSEkspLin.IndexName := 'ReceptIDOrder';
          if not nxRSEkspLin.FindKey([ReceptId]) then
          begin
            nxRSEksp.IndexName := 'ReceptIdOrder';
            if nxRSEksp.FindKey([ReceptId]) then
              nxRSEksp.Delete;
          end;

        except
          if nxRSEksp.State <> dsbrowse then
            nxRSEksp.Cancel;
          if nxRSEkspLin.State <> dsbrowse then
            nxRSEkspLin.Cancel;
        end;
      end
      else
        ProcessError(sl);
    end;
  finally

    requestlist.Free;

  end;

end;

procedure createXML3(sl:TStringList);
var
  requestlist : TStringList;
  doc : IXMLDOMDocument;
  rootelement : IXMLDOMElement;
  newelement : IXMLDOMElement;
  xmlelement : IXMLDOMProcessingInstruction;
  text : IXMLDOMText;

begin
  requestlist := TStringList.Create;
  try
    with MainDM do
    begin


      doc := CoDOMDocument.Create;
      xmlelement := doc.createProcessingInstruction('xml','version="1.0" encoding="ISO-8859-1"');
      doc.appendChild(xmlelement);

      rootelement := doc.createElement('RemoveStatusInProcessRequest');
      rootelement.setAttribute('xmlns','http://dkma.dk/receptserver/apotekssnitflade/xml/schemas/');
      doc.appendChild(rootelement);

      // location number

      newelement := doc.createElement('LocationNumber');
      text :=doc.createTextNode(nxSettingsLokationNr.AsString);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      // medication id

      newelement := doc.createElement('MedicationID');
      text :=doc.createTextNode(nxRSEkspLinOrdId.AsString);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      // VersionCheckKey

      newelement := doc.createElement('VersionCheckKey');
      text :=doc.createTextNode('-1');
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      C2LogAdd(doc.xml);
      requestlist.Text := doc.xml;
      if StamForm.SendHTTPRequest('RemoveStatusInProcess',requestlist,sl) then
      begin
      end
      else
        ProcessError2(sl);
    end;
  finally

    requestlist.Free;

  end;

end;


procedure RemoveStatus(sl: TStringList);
// remove status
begin

  C2LogAdd('Remove status routine called');
  createXML(sl);


end;

procedure RemoveStatus2(sl: TStringList);
// remove status
begin

  C2LogAdd('Remove status routine called');
  createXML2(sl);


end;

procedure RemoveStatus3(sl: TStringList);
// remove status
begin

  C2LogAdd('Remove status routine called');
  createXML3(sl);


end;

procedure ProcessError(sl: TStringList);
begin
  C2LogAdd(sl.Text);

end;

procedure ProcessError2(sl: TStringList);
begin
  C2LogAdd(sl.Text);

end;

end.
