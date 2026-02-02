unit uTerminate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExtCtrls, msxml, Grids, DBGrids,
  StdCtrls, Buttons, idmultipartFormdata,
  C2MainLog,db;


    procedure Terminate(sl:TStringList);
    procedure ProcessError(sl: TStringList);


implementation

uses DM, main,  ChkBoxes;

procedure Terminate(sl: TStringList);
// terminate
var
  requestlist : TStringList;
  doc : DOMDocument;
  rootelement : IXMLDOMElement;
  newelement : IXMLDOMElement;
  xmlelement : IXMLDOMProcessingInstruction;
  text : IXMLDOMText;
  ReceptId : integer;
begin
  C2LogAdd('terminate routine called');


  requestlist := TStringList.Create;
  try
    with MainDM do
    begin
      ReceptId := nxRSEkspLinListReceptId.AsInteger;
      doc := CoDOMDocument.Create;
      xmlelement := doc.createProcessingInstruction('xml','version="1.0" encoding="ISO-8859-1"');
      doc.appendChild(xmlelement);

      rootelement := doc.createElement('SetMedicationTerminatedRequest');
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

      C2LogAdd(doc.xml);
      requestlist.Text := doc.xml;
      if StamForm.SendHTTPRequest('Terminate',requestlist,sl) then
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
          if nxRSEksp.State <> dsbrowse then
            nxRSEksp.Cancel;
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
      end;

    end;
  finally
    requestlist.Free;
  end;


end;

procedure ProcessError(sl: TStringList);
begin

end;

end.
