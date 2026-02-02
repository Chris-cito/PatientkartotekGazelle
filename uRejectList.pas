unit uRejectList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExtCtrls, msxml, Grids, DBGrids,
  StdCtrls, Buttons, idmultipartFormdata,
  C2MainLog,DB;


  procedure RejectList;
  procedure ProcessError(sl: TStringList);


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
  StartDate : TDateTime;
  EndDate : TDateTime;
  datestr : string;

begin
  requestlist := TStringList.Create;
  try
    with MainDM do begin

      doc := CoDOMDocument.Create;
      xmlelement := doc.createProcessingInstruction('xml','version="1.0" encoding="ISO-8859-1"');
      doc.appendChild(xmlelement);

      rootelement := doc.createElement('SearchRejectedOrdinationsRequest');
      rootelement.setAttribute('xmlns','http://dkma.dk/receptserver/apotekssnitflade/xml/schemas/');
      doc.appendChild(rootelement);

      // location number

      newelement := doc.createElement('LocationNumber');
      text :=doc.createTextNode(nxSettingsLokationNr.AsString);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      // start date
      StartDate := Now - 0.25 ;
      datestr := FormatDateTime('YYYY-MM-DD',StartDate)+ 'T' +
                  FormatDateTime('hh:mm:ss',StartDate) + '+01:00';
      newelement := doc.createElement('StartDateTime');
      text :=doc.createTextNode(datestr);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      // end date

      EndDate := Now;
      datestr := FormatDateTime('YYYY-MM-DD',EndDate) + 'T' +
                  FormatDateTime('hh:mm:ss',EndDate) + '+01:00';
      newelement := doc.createElement('EndDateTime');
      text :=doc.createTextNode(datestr);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);

      C2LogAdd(doc.xml);
//      C2LogSave;
      requestlist.Text := doc.xml;
      if StamForm.SendHTTPRequest('SearchRejectedOrdinations',requestlist,sl) then begin
      end else
        ProcessError(sl);
    end;
  finally

    requestlist.Free;

  end;

end;


procedure RejectList;
var
  sl : TStringList;
begin

  sl := TStringList.Create;
  try
  C2LogAdd('Reject List routine called');
  createXML(sl);
  finally
    sl.free;
  end;


end;

procedure ProcessError(sl: TStringList);
begin

  ChkBoxOK(sl.Text);

end;

end.
