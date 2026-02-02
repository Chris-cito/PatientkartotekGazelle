unit uRCPRelease;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExtCtrls,msxml, Grids, DBGrids,
  StdCtrls, Buttons, idmultipartFormdata,
  C2MainLog,Comctrls;

  procedure RCPReleaseOrdination(OrdId,Lokation : string);
  procedure parsePrescriptionXML(sl:TStringList);
  procedure ProcessError(sl: TStringList);

implementation

uses Main,ChkBoxes, DM;
var SaveOrdid : string;

procedure RCPReleaseOrdination(OrdId,Lokation : string);
var
  sl : TStringList;
  requestlist : TStringList;
  doc : DOMDocument;
  rootelement : IXMLDOMElement;
  newelement : IXMLDOMElement;
  xmlelement : IXMLDOMProcessingInstruction;
  text : IXMLDOMText;


begin
  SaveOrdid := Ordid;
  sl := TStringList.Create;
  requestlist := TStringList.Create;
  try
    doc := CoDOMDocument.Create;
    xmlelement := doc.createProcessingInstruction('xml','version="1.0" encoding="ISO-8859-1"');
    doc.appendChild(xmlelement);
    rootelement := doc.createElement('ReleaseMedicationRequest');
    rootelement.setAttribute('xmlns','http://dkma.dk/receptserver/apotekssnitflade/xml/schemas/');
    doc.appendChild(rootelement);

    // medcation id's

    newelement := doc.createElement('MedicationID');
    text :=doc.createTextNode(OrdId);
    newelement.appendChild(text);
    rootelement.appendChild(newelement);

    newelement := doc.createElement('RequestorLocationNumber');
    text :=doc.createTextNode(Lokation);
    newelement.appendChild(text);
    rootelement.appendChild(newelement);

    C2LogAdd(doc.xml);
    requestlist.Text := doc.xml;
    if StamForm.SendHTTPRequest('ReleaseMedication',requestlist,sl) then
      parseprescriptionXML(sl)
    else
      ProcessError(sl);

  finally
    requestlist.Free;
    sl.Free;
  end;


end;

procedure parsePrescriptionXML(sl:TStringList);
begin
  C2LogAdd(sl.Text);
  if pos('afsendt',sl.Text) <> 0 then begin
    with MainDm do begin
      nxFrigivne.Append;
      nxFrigivneOrdId.AsString := SaveOrdid;
      nxFrigivneDato.AsString := '';
      nxFrigivne.Post;
    end;
    ChkBoxOK('Afsendt : OK');
  end else
    ChkBoxOK('Fejl i afsendelse.'+ #10#13+ sl.Text);
end;

procedure ProcessError(sl: TStringList);
begin
  C2LogAdd(sl.Text);
  ChkBoxOK('Fejl i afsendelse.'+ #10#13+ sl.Text);
end;
end.
