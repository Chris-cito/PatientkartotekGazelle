unit uInvalidate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExtCtrls, msxml, Grids, DBGrids,
  StdCtrls, Buttons, idmultipartFormdata,
  C2MainLog,DB;


  procedure RCPInvalidate(OrdId, Reason: string;sl:TStringList);
  procedure RCPInvalidate2(OrdId, Reason: string;sl:TStringList);
  procedure ProcessError(sl: TStringList);
  procedure ProcessError2(sl: TStringList);


implementation

uses
  ChkBoxes,
 DM,main;

procedure RCPInvalidate(Ordid,Reason: string; sl: TStringList);
// invalidate
var
  requestlist : TStringList;
  doc : DOMDocument;
  rootelement : IXMLDOMElement;
  newelement : IXMLDOMElement;
  xmlelement : IXMLDOMProcessingInstruction;
  text : IXMLDOMText;
  ReceptId : integer;
begin
  C2LogAdd('invalidate routine called');
  requestlist := TStringList.Create;
  try
    with MainDM do begin
      ReceptId := nxRSEkspLinListReceptId.AsInteger;

      nxRSEkspLin.IndexName := 'OrdIdOrden';

      doc := CoDOMDocument.Create;
      xmlelement := doc.createProcessingInstruction('xml','version="1.0" encoding="ISO-8859-1"');
      doc.appendChild(xmlelement);

      rootelement := doc.createElement('SetStatusInvalidatedRequest');
      rootelement.setAttribute('xmlns','http://dkma.dk/receptserver/apotekssnitflade/xml/schemas/');
      doc.appendChild(rootelement);

      // medication number

      newelement := doc.createElement('MedicationID');
      text :=doc.createTextNode(nxRSEkspLinListOrdId.AsString);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      // VersionCheckKey

      newelement := doc.createElement('VersionCheckKey');
      text :=doc.createTextNode('-1');
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      // invalidation reason

      newelement := doc.createElement('InvalidationReason');
      text :=doc.createTextNode(Reason);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      C2LogAdd(doc.xml);
      requestlist.Text := doc.xml;
      if  StamForm.SendHTTPRequest('Invalidate',requestlist,sl) then begin

        try
          nxRSEkspLinList.Delete;

          // check to see if there are no lines with this recept id.
          nxRSEkspLin.IndexName := 'ReceptIDOrder';
          if not nxRSEkspLin.FindKey([ReceptId]) then begin
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
      end else begin
        if ChkBoxYesNo('Receptkvitteringen går i fejl, når den forsøges sendt til receptserveren.' + #13#10+
            'Ønsker du at slette receptkvitteringen lokalt?',True) then begin
          try
            nxRSEkspLinList.Delete;

            // check to see if there are no lines with this recept id.
            nxRSEkspLin.IndexName := 'ReceptIDOrder';
            if not nxRSEkspLin.FindKey([ReceptId]) then begin
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
      end;
      ProcessError(sl);
    end;
  finally
    requestlist.Free;
  end;



end;

procedure RCPInvalidate2(Ordid,Reason: string; sl: TStringList);
// invalidate
var
  requestlist : TStringList;
  doc : DOMDocument;
  rootelement : IXMLDOMElement;
  newelement : IXMLDOMElement;
  xmlelement : IXMLDOMProcessingInstruction;
  text : IXMLDOMText;
begin
  C2LogAdd('invalidate routine called');
  requestlist := TStringList.Create;
  try

    doc := CoDOMDocument.Create;
    xmlelement := doc.createProcessingInstruction('xml','version="1.0" encoding="ISO-8859-1"');
    doc.appendChild(xmlelement);

    rootelement := doc.createElement('SetStatusInvalidatedRequest');
    rootelement.setAttribute('xmlns','http://dkma.dk/receptserver/apotekssnitflade/xml/schemas/');
    doc.appendChild(rootelement);

    // medication number

    newelement := doc.createElement('MedicationID');
    text :=doc.createTextNode(OrdId);
    newelement.appendChild(text);
    rootelement.appendChild(newelement);

    // VersionCheckKey

    newelement := doc.createElement('VersionCheckKey');
    text :=doc.createTextNode('-1');
    newelement.appendChild(text);
    rootelement.appendChild(newelement);

    // invalidation reason

    newelement := doc.createElement('InvalidationReason');
    text :=doc.createTextNode(Reason);
    newelement.appendChild(text);
    rootelement.appendChild(newelement);

    C2LogAdd(doc.xml);
    requestlist.Text := doc.xml;
    if  not StamForm.SendHTTPRequest('Invalidate',requestlist,sl) then begin
      ProcessError2(sl);
    end;
  finally
    requestlist.Free;
  end;



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
