unit uSynchronise;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExtCtrls, msxml, Grids, DBGrids,
  StdCtrls, Buttons, idmultipartFormdata,
  C2MainLog,comctrls;


    procedure Synchronise(sl:TStringList);
    procedure SyncList(sl: TStringList);
    procedure ProcessError(sl: TStringList);


implementation

uses
  CHKBOXES,
  DM, Main, ufrmSynch;

procedure Synchronise(sl: TStringList);
// synchronise
var
  requestlist : TStringList;
  doc : DOMDocument;
  rootelement : IXMLDOMElement;
  newelement : IXMLDOMElement;
  xmlelement : IXMLDOMProcessingInstruction;
  text : IXMLDOMText;
begin
  C2LogAdd('synchronise routine called');
  with MainDM do begin
    requestlist := TStringList.Create;

    try

      doc := CoDOMDocument.Create;
      xmlelement := doc.createProcessingInstruction('xml','version="1.0" encoding="ISO-8859-1"');
      doc.appendChild(xmlelement);

      rootelement := doc.createElement('GetSynchronizationListRequest');
      rootelement.setAttribute('xmlns','http://dkma.dk/receptserver/apotekssnitflade/xml/schemas/');
      doc.appendChild(rootelement);

      // medication number

      newelement := doc.createElement('LocationNumber');
      text :=doc.createTextNode(nxSettingsLokationNr.AsString);
      newelement.appendChild(text);
      rootelement.appendChild(newelement);
      C2LogAdd(doc.xml);
      requestlist.Text := doc.xml;
      if StamForm.SendHTTPRequest('Synchronization',requestlist,sl) then
        synclist(sl)
      else
        ProcessError(sl);

    finally
      requestlist.Free;
    end;

  end;


end;

procedure SyncList(sl: TStringList);
var
  i : integer;
  doc : DOMDocument;
  nodelist : IXMLDOMNodeList;
  fieldname : string;
  MedicationId : string;
  MedicationStatus : string;
  li : tlistitem;

  procedure searchMedicationStatus(node : IXMLDOMNode);
  var
    i : integer;
    nodelist : IXMLDOMNodeList;
  begin




    if node.nodeType <> node_text then begin
      fieldname := node.nodeName;
    end else begin
      if fieldname = 'MedicationID' then begin
        MedicationId := node.nodeValue;
      end;

      if fieldname = 'StatusCode' then begin
        if node.nodeValue <> 'overfoert_til_dosiskort' then
          MedicationStatus := node.nodeValue;
      end;

      c2logadd(fieldname + ' = ' + node.nodeValue);
    end;
    nodelist := node.childNodes;
    for i := 0 to nodelist.length - 1 do begin
      searchMedicationStatus(nodelist.item[i]);
    end;

  end;




  procedure searchtree(node : IXMLDOMNode);
  var
    i : integer;
    nodelist : IXMLDOMNodeList;
    RSlineindex : string;
    RSEkspindex : string;
    lbnr : integer;
    cprnr : string;
    datostr : string;
  begin
    with MainDm do begin
      if node.nodeType = node_element then begin
        if node.nodeName = 'MedicationStatus' then begin
          C2LogAdd('*********************** start of medication status');
          MedicationId := '';
          MedicationStatus := '';
          nodelist := node.childNodes;
          for i := 0 to nodelist.length - 1 do begin
            searchMedicationStatus(nodelist.item[i]);
          end;
          if MedicationId <> '' then begin
            if MedicationStatus <> '' then begin
              with frmSyncList.ListView1 do begin
                lbnr := 0;
                cprnr := '';
                datostr := '';
                try
                  RSlineindex := nxRSEkspLin.IndexName;
                  RSEkspindex := nxRSEksp.IndexName;
                  nxRSEkspLin.IndexName := 'OrdIdOrden';
                  if nxRSEkspLin.FindKey([medicationid]) then begin
                    lbnr := nxRSEkspLinLbNr.AsInteger;
                    datostr := nxRSEkspDato.AsString;
                    nxRSEksp.IndexName := 'ReceptIdOrder';

                    if nxRSEksp.FindKey([nxRSEkspLinReceptId.AsInteger]) then
                      cprnr := nxRSEkspPatCPR.AsString;
                  end;
                  li := Items.Add;
                  li.Caption := MedicationId;
                  li.SubItems.Add(datostr);
                  li.SubItems.Add(cprnr);
                  li.SubItems.Add(inttostr(lbnr));

                finally
                  nxRSEksp.IndexName := RSEkspindex;
                  nxRSEkspLin.IndexName := RSlineindex;
                end;
              end;
            end;
          end;
          C2LogAdd('******************* end of Medication status');
          exit;
        end;
      end;

      if node.nodeType <> node_text then begin
        fieldname := node.nodeName;
        C2LogAdd(fieldname);
      end else begin
        c2logadd(fieldname + ' = ' + node.nodeValue);
      end;

      nodelist := node.childNodes;
      for i := 0 to nodelist.length - 1 do begin
        searchtree(nodelist.item[i]);
      end;
    end;
  end;


begin
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
    c2logadd(' nodelist length is ' + IntToStr(nodelist.length));

    if nodelist.length <> 0 then begin

      frmSyncList.ListView1.Clear;
      for i:= 0 to nodelist.length - 1 do begin
        searchtree(nodelist.item[i]);
      end;
      frmSyncList.ShowModal;

    end;
  except
    on e : Exception do begin
      C2LogAdd('Error in parse xml ' + e.Message);
    end;
  end;


end;


procedure ProcessError(sl: TStringList);
begin

end;


end.
