unit RCPPrinter;

{ Developed by: Cito IT A/S

  Description: View a prescription

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  19-10-2020/cjs  Allow return key to close prescription view screen

  19-10-2020/cjs  Fixed scrolling on prescription view screen

  19-10-2020/cjs  Limit the mximum height of the vis RCP screen to 700

  16-10-2020/cjs  Make screen the max height allowed on desktop plus initial scroll
                  to show more information.

  01-04-2020/cjs  remnoved the message 'direkte forhandlet' from the printing of the prescription.

  18-02-2020/cjs  print udlev information if repeat prescription.

  22-01-2020/cjs  Print the ordination id and add prefix 'Bestilt af:'

  22-01-2020/cjs  bold the "bestiltaf" message on the print of the prescription

  08-01-2020/CJS  Show the ordination id on the print (dosis users need this)
}

interface

uses
  Windows,  Messages, SysUtils, Classes,
  Graphics, Controls, Forms,
   Dialogs, Math,
   RpRenderPreview, RpDefine, RpBase, RpFiler, RpRenderPrinter,
    ExtCtrls, Buttons,urs_eksplinier.tables, RpRender, RpRenderCanvas;

const
  WM_SetScroll =            WM_USER + 100;

type
  TRCPPrnForm = class(TForm)
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    RvNDRWriter1: TRvNDRWriter;
    RvRenderPrinter1: TRvRenderPrinter;
    RvRenderPreview1: TRvRenderPreview;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure buUdskrivClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ReportFiler1Print(Sender: TObject);
    procedure PrintRecept(AReceptId : integer);
    procedure SetupUserPrinter(UserName : string);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    memStream : TMemoryStream;
    procedure WMSetScroll(var Msg: TMessage); message WM_SetScroll;

  public
    { Public declarations }
    class procedure RCPView(ReceptId : integer);
  end;

type
    TStr100 = string;
    TRCPSide = array[1..68] of TStr100;


var
  StdPrintPrn : string;
  StdPrintBin : string;
  StdPrintSize : integer;
  numpages : integer;
  UserRemark : string;
  rcp : array[1..100] of TRCPSide;  // allow up to 100 page of recept print
  CurrentReceptid : integer;
  HeaderLine : integer;
  ReportOrdreInstruks : boolean;
  iReceptId : integer;

implementation

uses
  rpbars,
  ChkBoxes,
  C2MainLog,
  C2Procs, DM, nxdb, Main, uRCPMidCli,
  C2PrinterSelection;

{$R *.DFM}


function Spaces (I : integer) : string;
  var
      formatstring : string;
  begin
	Result := StringOfChar(' ',I);
end;

procedure Str2Pos (IndS : TStr100; var UdS : TStr100; P : Word);
begin
    if UdS = '' then
      UdS := Spaces (62);
    Delete (UdS, P, Length (IndS));
    Insert (IndS, UdS, P);
end;


function ReadByNavn(const IPNr: string): string;
begin
  with MainDM do
  begin
    ffPnLst.IndexName := 'NrOrden';
    if ffPnLst.FindKey ( [IPNr]) then
      ReadByNavn := ffPnLstByNavn.AsString
    else
      ReadByNavn := '';
  end;
end;

procedure TRCPPrnForm.FormShow(Sender: TObject);
begin
    SetupUserPrinter(MainDm.C2UserName);
    C2LogAdd('Stdprintprn is ' + StdPrintPrn);
    C2LogAdd('stdprintbin is ' + StdPrintBin);
    C2LogAdd('stdprintsize is ' + IntToStr(StdPrintSize));
    printRecept(iReceptId);
    RvNDRWriter1.StreamMode := smUser;
    RvNDRWriter1.Stream := memStream;
    c2logadd('devicenme before ' + RvNDRWriter1.DeviceName);
    C2SelectPrinter(StdPrintPrn);
    c2logadd('devicenme after ' + RvNDRWriter1.DeviceName);
    RvNDRWriter1.SetPaperSize(StdPrintSize,0,0);
//    RvNDRWriter1.SelectPrinter(StdPrintPrn);
    if StdPrintBin <> '' then
      RvNDRWriter1.SelectBin(StdPrintBin);

    RvNDRWriter1.DeviceName;
    RvNDRWriter1.Execute;


  RvRenderPreview1.Render(memStream);
  RvRenderPreview1.ZoomFactor := RvRenderPreview1.ZoomPageWidthFactor;
//  edtFirst.Text := IntToStr(RvRenderPreview1.FirstPage);
//  edtLast.Text := IntToStr(RvRenderPreview1.Pages);
//
  PostMessage(Handle,WM_SetScroll,0,0);
end;

procedure TRCPPrnForm.Button1Click(Sender: TObject);
begin
 RvRenderPreview1.NextPage;
end;

procedure TRCPPrnForm.buUdskrivClick(Sender: TObject);
begin

  RCPMidCli.SendRequest('GetAddressed',
          [
          '4',
          inttostr(iReceptId),
          IntToStr(MainDm.AfdNr),
          MainDm.C2UserName
          ],
          10);
  ModalResult := mrOk;
end;

procedure TRCPPrnForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if Key = 13 then
  begin
    ModalResult := mrCancel;
    exit;
  end;

  if key = vk_NEXT then
    RvRenderPreview1.NextPage;

  if Key = vk_PRIOR then
    RvRenderPreview1.PrevPage;

//  if Key = vk_HOME then
//    RvRenderPreview1.FirstPage;

//  if Key = vk_END then
//    RvRenderPreview1.LastPage;

//  if key = vk_DOWN then
//    ScrollBox1.ScrollBy(0,-200);
//  if Key = vk_UP then
//    ScrollBox1.ScrollBy(0,200);
//  if Key = VK_DOWN then
//    ScrollBox1.Perform(WM_VSCROLL,MakeWParam(SB_BOTTOM,0),0);
//  if Key = VK_UP then
//    ScrollBox1.Perform(WM_VSCROLL,MakeWParam(SB_TOP,0),0);

  if Key = VK_UP then
    ScrollBox1.VertScrollBar.Position := 0;
  if Key = VK_DOWN then
    ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Range;

end;

procedure TRCPPrnForm.FormCreate(Sender: TObject);

begin
  C2LogAdd('RCPPrinter in');
  // Default
  memStream := TMemoryStream.Create;
  C2LogAdd('RCPPrinter out');

end;

procedure TRCPPrnForm.FormDestroy(Sender: TObject);
begin
  memStream.Free;
end;

procedure TRCPPrnForm.ReportFiler1Print(Sender: TObject);
var
  i,j : integer;
  Bar : TRPBarsBase;
  tmpstr: string;
  ipos: Integer;

begin
  with (Sender as TBaseReport) do
  begin
    ResetSection;
    Home;
    LinesPerInch := 8;
    MarginLeft   := 0.4;
    MarginRight  := 0.0;
    MarginTop    := 0.4;
    MarginBottom := 0.0;
    for j := 1 to numpages do
    begin
      // Start side
      Bar := TRPBarsEAN.Create(Sender as TBaseReport);
      try
        with Bar do
        begin
          BarHeight       := 0.4;
          BarWidth        := 0.014;
          Text            := Format('99966%7.7d',[CurrentReceptId]);
          TextJustify     := pjCenter;
          UseChecksum     := True;
          PrintReadable   := False;
          PrintChecksum   := True;
          PrintTop        := True;
          BarCodeRotation := Rot0;
          BarCodeJustify  := pjCenter;
          PrintXY (4.6,7.4);
        end;
      finally
        Bar.free;
      end;
      // print a line at the top and just before the products
      SetFont('Courier New',9.0);
      Home;
      NewLine;
      Str2Pos('Side ' + inttostr(j) + ' af ' + inttostr(numpages) +
              '   ' + UserRemark ,rcp[1][59],1);
      for i := 1 to 59 do
      begin
        if i = 6 then
        begin
          SetPen(clBlack,psSolid,-2,pmCopy);
          SetTab(0.4,pjLeft,5,1,BOXLINEBOTTOM,0);
          PrintTab('');
          ClearTabs;
        end;
        if i = 15 then
        begin
          SetPen(clBlack,psSolid,-2,pmCopy);
          SetTab(0.4,pjLeft,5,1,BOXLINEBOTTOM,0);
          PrintTab('');
          ClearTabs;
        end;
        if i = 21 then
        begin
          SetPen(clBlack,psSolid,-2,pmCopy);
          SetTab(0.4,pjLeft,5,1,BOXLINEBOTTOM,0);
          PrintTab('');
          ClearTabs;
        end;
        if (i < 23) or (i > 49) then
        begin
          if i = 59 then
          begin
            Print('Side ' + inttostr(j) + ' af ' + inttostr(numpages));
            if UserRemark <> '' then
            begin
              SetFont('Courier New',12.0);
              Bold := True;
              Print('   ' + UserRemark);
              SetFont('Courier New',9.0);
              Bold := False;
            end;
          end
          else
            Print(rcp[1][i]);
        end
        else
        begin
          tmpstr := rcp[j][i];
          // no bold so just print the line
          if pos('<bold>',tmpstr) = 0 then
            Print(tmpstr)
          else
          begin
            //find the first bold matkers
            ipos:= pos('<bold>',tmpstr);
            while ipos <> 0 do
            begin

              // Print stuff before bold in non bold font
              if ipos > 1 then
              begin
                Bold := False;
                Print(copy(tmpstr,1,ipos-1));
                Delete(tmpstr,1,ipos-1);
              end;

              // print the bold bit
              Bold := true;
              Delete(tmpstr,1,6);
              ipos := pos('</bold>',tmpstr);
              if ipos <> 0 then
              begin
                if ipos > 1 then
                  print(copy(tmpstr,1,ipos-1));
                delete(tmpstr,1,ipos+6);
                Bold := False;
              end;

              // check for any more bold markers
              ipos:= pos('<bold>',tmpstr);


            end;
            if tmpstr <> '' then
              Print('  ' + tmpstr);

          end;
        end;
        NewLine;
      end;
      if j <> numpages then
         NewPage;

    end;
  end;
end;

procedure TRCPPrnForm.PrintRecept(AReceptId: integer);
var
  line_no : integer;
  page_line_no : integer;
  page_no : integer;
  linetxt : string;
  iterint : integer;
  itertype : string;
  string1to60 :string;
  string60toend : string;
  levpri : string;
  By : string;
  linetxt2 : string;
  templist: TStringList;
  temptext: string;
  i : integer;
  wrapsl : TStringList;

  function DeleteLineBreaks(const S: string): string;
  var
     Source, SourceEnd: PChar;
  begin
     Source := Pointer(S) ;
     SourceEnd := Source + Length(S) ;
     while Source < SourceEnd do
     begin
       case Source^ of
         #10: Source^ := #32;
         #13: Source^ := #32;
       end;
       Inc(Source) ;
     end;
     Result := S;
  End;

  procedure getstock(varenr :string; var linetext : string);
  var
    save_index : string;

  begin
    with MainDm do
    begin
      try
        save_index := ffLagKar.IndexName;
        ffLagKar.IndexName := 'NrOrden';

        IF ffLagKar.FindKey([StamForm.FLagerNr,varenr]) then
        begin
          if ffLagKarAntal.AsInteger <= 0 then
            linetext := linetext + '[Ant:0]'
          else
           linetext := linetext + '[Ant:' + ffLagKarAntal.AsString + ']';

        end;

      finally
        ffLagKar.IndexName := save_index;
      end;
    end;
  end;

begin
  with MainDM.nxRSEksp do
  begin
    IndexName := 'ReceptIdOrder';
    if not FindKey([AReceptId]) then
      exit;
 // this will build up the necessary and print the document according to
 // standard created by medcom
    CurrentReceptid := fieldbyname('ReceptId').AsInteger;
    C2LogAdd('This will print the prescription ' +
      inttostr(CurrentReceptid));

    FillChar(rcp,sizeof(rcp),0);

    // header  and footer common to all pages

    Str2Pos('RECEPT KVITTERING', rcp[1][1],51);
    Str2Pos('(FMK)', rcp[1][2],52);
      Str2Pos('UNDER',rcp[1][9],53);
      Str2Pos('BEHANDLING',rcp[1][10],53);
      Str2Pos('Nr. ' + fieldbyname('ReceptId').AsString,rcp[1][11],53);
//    Str2Pos(FormatDateTime('dd.mm.yyyy',now),rcp[1][52],1);
    Str2Pos(fieldbyname('SenderId').AsString,rcp[1][1],5);
    Str2Pos(fieldbyname('SenderNavn').AsString,rcp[1][2],5);
    Str2Pos(fieldbyname('SenderVej').AsString,rcp[1][3],5);
    Str2Pos(' ',rcp[1][4],5);
    Str2Pos(fieldbyname('SenderPostNr').AsString,rcp[1][4],5);
    By := ReadByNavn(fieldbyname('SenderPostNr').AsString);
    Str2Pos(By,rcp[1][4],10); // get from postnummer table
    Str2Pos('Tlf.',rcp[1][5],32);
    Str2Pos(fieldbyname('SenderTel').AsString,rcp[1][5],37);
    Str2Pos(fieldbyname('SenderSystem').AsString,rcp[1][1],36);
    if fieldbyname('PatCPR').AsString <> '' then
    begin
      Str2Pos(copy(fieldbyname('PatCPR').AsString,1,6) + '-' +
              copy(fieldbyname('PatCPR').AsString,7,4),rcp[1][8],1);
    end
    else
    begin
      if FieldByName('PatFoed').AsString <> '' then
        Str2Pos(  copy(fieldbyname('PatFoed').AsString,9,2) +
                  copy(fieldbyname('PatFoed').AsString,6,2) +
                  copy(fieldbyname('PatFoed').AsString,3,2),
                  rcp[1][8],1);
    end;
    Str2Pos(fieldbyname('PatForNavn').AsString + ' ' +
            fieldbyname('PatEftNavn').AsString,rcp[1][9],1 );
    Str2Pos(fieldbyname('PatVej').AsString,rcp[1][10],1);
    Str2Pos(' ',rcp[1][11],1);
    By := FieldByName('PatBy').AsString;
    if By = '' then
      By := ReadByNavn(fieldbyname('PatPostNr').AsString);

    Str2Pos(fieldbyname('PatPostNr').AsString + ' ' +
              By,rcp[1][12],1);

    // barn code ??

    Str2Pos(fieldbyname('PatAmt').AsString,rcp[1][14],53);

    line_no := 17;
    if FieldByName('LeveringsInfo').AsString <> '' then
    begin
      linetxt := FieldByName('LeveringsInfo').AsString;
      if length(linetxt) <= 60 then
      begin
        Str2Pos(linetxt,rcp[1][line_no],1);
        line_no := line_no + 1;
      end
      else
      begin
        wrapsl := TStringList.Create;
        try
          wrapsl.Text := WrapText(linetxt,60);
          for linetxt in wrapsl do
          begin
            Str2Pos(linetxt,rcp[1][line_no],1);
            line_no := line_no + 1;
          end;
        finally
          wrapsl.Free;
        end;
      end;
    end;


    levpri := trim(FieldByName('LeveringPri').AsString);
    if levpri <> '' then
    begin
      LineTxt:= '';
      if (levpri = 'send_to_other_address_same_day'  ) or
         (levpri = 'send_to_patient_address_same_day') then
        linetxt := 'Sendes pr. bud';
      if (levpri = 'send_to_other_address_via_mail'  ) or
         (levpri = 'send_to_patient_address_via_mail') then
        linetxt := 'Sendes pr. post';
//      if (levpri = 'send_to_other_address_same_day'  ) or
//         (levpri = 'send_to_other_address_via_mail'  ) then begin
        // Other address
       linetxt2:= '';
       if trim(FieldByName('LeveringAdresse').AsString) <> '' then
          linetxt2 := linetxt2 + ' ' + trim(FieldByName('LeveringAdresse').AsString);
        if trim(FieldByName('LeveringPseudo').AsString) <> '' then
          linetxt2 := linetxt2 + ' ' + trim(FieldByName('LeveringPseudo').AsString);
        if trim(FieldByName('LeveringPostnr').AsString) <> '' then
        begin
          linetxt2 := linetxt2 + ' ' + trim(FieldByName('LeveringPostnr').AsString);
          By := ReadByNavn(trim(FieldByName('LeveringPostnr').AsString));
          linetxt2 := linetxt2 + ' ' + by;
        end;
        if trim(FieldByName('LeveringKontakt').AsString) <> '' then
          linetxt2 := linetxt2 + ' ' + trim(FieldByName('LeveringKontakt').AsString);
        if trim(linetxt2) <> '' then
          linetxt:= linetxt + ' til ' + linetxt2;
//      end;
      if length(linetxt) <= 60 then
      begin
        Str2Pos(linetxt,rcp[1][line_no],1);
        line_no := line_no + 1;
      end
      else
      begin
        string1to60 := PartStr(linetxt,string60toend,60);
        Str2Pos(string1to60,rcp[1][line_no],1);
        line_no := line_no + 1;
        Str2Pos(string60toend,rcp[1][line_no],1);
        line_no :=  line_no + 1;
      end;

    end;

    HeaderLine := line_no;

    // footer

//    Str2Pos();
    Str2Pos(fieldbyname('IssuerTitel').AsString,rcp[1][52],12);
    Str2Pos(fieldbyname('IssuerAutNr').AsString,rcp[1][53],1);
    Str2Pos('Gyldig I 2 år fra udst.datoen.',rcp[1][54],1);
    Str2Pos('7 dage for vagtlæge og behandlerfarmaceutordinationer.',rcp[1][55],1);
    Str2Pos(MainDM.ffFirmaNavn.AsString,rcp[1][56],1);
    // need to store datetime received.
    Str2Pos('Modtaget den ' +  fieldbyname('Dato').AsString,rcp[1][57],1);
    numpages := fieldbyname('OrdAnt').AsInteger;
    if numpages mod 3 = 0 then
      numpages := numpages div 3
    else
      numpages := numpages div 3 + 1;


  end;
  ReportOrdreInstruks := True;
  with maindm.nxRSEkspLin do
  begin
    try
      IndexName := 'ReceptIdOrder';
      line_no := 0;
      page_no := 0;
      try
        SetRange([CurrentReceptid],[CurrentReceptid]);
        while not Eof do
        begin
          line_no := line_no + 1;
          if line_no = 1 then
          begin
            linetxt := copy(fieldbyname('OpretDato').AsString,9,2) + '.' +
                        copy(fieldbyname('OpretDato').AsString,6,2) + '.' +
                        copy(fieldbyname('OpretDato').AsString,1,4);
            Str2Pos(linetxt,rcp[1][52],1);

          end;
          if line_no mod 3 = 1 then
          begin
            page_no := page_no + 1;
            line_no := 1;
          end;
          page_line_no := 14 + (line_no * 9);

          linetxt := fieldbyname('VarenNr').AsString;
// 06-12-2019/MA: DosKode is always blank anyway (FMK doesn't provide it), so this is removed
//            if FieldByName('DosKode').AsString <> '' then
//              linetxt := linetxt.PadLeft(6, '0') + '  [D-'+FieldByName('DosKode').AsString +']';
// 06-12-2019/MA: IndCode is not necessary on the print
//            if FieldByName('IndCode').AsString <> '' then
//              linetxt := linetxt + '[I-'+FieldByName('IndCode').AsString +']';
          getstock(fieldbyname('VarenNr').AsString,linetxt);
          if FieldByName('AdminCount').AsInteger > 0 then
            linetxt := linetxt + ' UDL. ' + IntToStr(FieldByName('AdminCount').AsInteger)
                + '. GANG DEN ' + fieldbyname('AdminDate').AsString
          else
            linetxt := linetxt + '   Ord-ID: ' + trim(fieldbyname('OrdId').asstring);
          Str2Pos(linetxt,rcp[page_no][page_line_no],1);
          page_line_no := page_line_no + 1;

          linetxt := (FieldByName(fnRS_EkspLinierBestiltAfNavn).AsString.Trim + ' ' +
              FieldByName(fnRS_EkspLinierBestiltAfOrgNavn).AsString).Trim;
          if not linetxt.Trim.IsEmpty then
          begin
            linetxt := '<bold>Bestilt af: ' + linetxt.Substring(0, 67) + '</bold>'; // Limits the number of characters, so it doesn't overflow right margin
              Str2Pos(linetxt,rcp[page_no][page_line_no],1);
            page_line_no := page_line_no + 1;
          end;

          linetxt := fieldbyname('Navn').AsString;
          if FieldByName('Form').AsString <> '' then
            linetxt := linetxt + ' ' + FieldByName('Form').AsString;
          if FieldByName('Styrke').AsString <> '' then
            linetxt := linetxt + ' ' + FieldByName('Styrke').AsString;
//          if FieldByName('ImportLangt').AsString <> '' then
//            linetxt := linetxt + ' ' + FieldByName('ImportLangt').AsString
//          else
//            linetxt := linetxt + ' direkte forhandlet';
          if Length(linetxt) > 60 then
          begin
            string1to60 := PartStr(linetxt,string60toend,60);
            Str2Pos(string1to60,rcp[page_no][page_line_no],1);
            page_line_no := page_line_no + 1;
            linetxt := string60toend + ' ' + fieldbyname('Pakning').AsString + ' x ' +
              IntToStr(fieldbyname('Antal').AsInteger);

            if length(linetxt) > 60 then
            begin
              string1to60 := PartStr(linetxt,string60toend,60);
              Str2Pos(string1to60,rcp[page_no][page_line_no],1);
              page_line_no := page_line_no + 1;
              linetxt := string60toend;
              Str2Pos(linetxt,rcp[page_no][page_line_no],1);

              page_line_no := page_line_no + 1;


            end
            else
            begin
              Str2Pos(linetxt,rcp[page_no][page_line_no],1);

              page_line_no := page_line_no + 1;

            end;

          end
          else
          begin
            Str2Pos(linetxt,rcp[page_no][page_line_no],1);
            page_line_no := page_line_no + 1;

            linetxt := fieldbyname('Pakning').AsString + ' x ' +
              IntToStr(fieldbyname('Antal').AsInteger);

            Str2Pos(linetxt,rcp[page_no][page_line_no],1);

            page_line_no := page_line_no + 1;
          end;

          if FieldByName('SubstKode').AsString <> '' then
            linetxt := 'Ej S'
          else
            linetxt := '';
          if linetxt <> '' then
          begin
            Str2Pos(linetxt,rcp[page_no][page_line_no],1);

            page_line_no := page_line_no + 1;
          end;

          linetxt := fieldbyname('Klausulbetingelse').AsString;
          if linetxt = 'klausulbetingelse_opfyldt' then
            linetxt := 'Klausulbetingelse opfyldt';
          if linetxt = 'bevilling_fra_laegemiddelstyrelsen' then
            linetxt := 'Bevilling fra lægemiddelstyrelsen';
          if linetxt <> '' then
          begin
            Str2Pos(linetxt,rcp[page_no][page_line_no],1);

            page_line_no := page_line_no + 1;
          end;

          linetxt := fieldbyname('DosTekst').AsString;
          if linetxt <> '' then
          begin
            if fieldbyname('Dosperiod').AsString <> '' then
              linetxt := linetxt + ' i ' + fieldbyname('DosPeriod').AsString +
                ' ' + fieldbyname('DosEnhed').AsString;
            Str2Pos(linetxt,rcp[page_no][page_line_no],1);

            page_line_no := page_line_no + 1;
          end;

          linetxt := fieldbyname('IndText').AsString;
          if linetxt <> '' then
          begin
            Str2Pos(linetxt,rcp[page_no][page_line_no],1);

            page_line_no := page_line_no + 1;
          end;
          if FieldByName('DosStartDato').AsString <> '' then
          begin
            linetxt := 'Startdato: ' + fieldbyname('DosStartDato').AsString;
            linetxt := linetxt + ' Slutdato: ' + fieldbyname('DosSlutDato').AsString;
            linetxt := linetxt + ' DOSISPAKKES';
          end
          else
          begin

            if FieldByName('IterationNr').AsInteger <> 0 then
            begin

              linetxt := 'Udleveres ' +  inttostr(fieldbyname('IterationNr').AsInteger + 1);

              if fieldbyname('IterationNr').AsInteger = 1 then
                linetxt := linetxt + ' gang'
              else
                linetxt := linetxt + ' gange';

              if FieldByName('IterationInterval').AsInteger <> 0 then
              begin
                iterint := FieldByName('IterationInterval').AsInteger;
                itertype := FieldByName('IterationType').AsString;
                if iterint > 1 then
                begin
                  if itertype = 'dag' then
                    itertype := 'dages';
                  if itertype = 'uge' then
                    itertype := 'ugers';

                  if itertype = 'måned' then
                    itertype := 'måneders';

                end
                else
                begin
                  if itertype = 'dag' then
                    itertype := 'dags';
                  if itertype = 'uge' then
                    itertype := 'uges';

                  if itertype = 'måned' then
                    itertype := 'måneds';

                end;

                linetxt := linetxt + ' med ' + IntToStr(iterint)
                        + ' ' + itertype + ' mellemrum';

              end;

            end
            else
            begin
              linetxt := 'Udleveres 1 gang';

            end;


          end;
          if linetxt <> '' then
          begin
            Str2Pos(linetxt,rcp[page_no][page_line_no],1);
            page_line_no := page_line_no + 1;
          end;
          // ADD THE SUPPLEMENTARY TEXT
          linetxt := trim(Fieldbyname('Supplerende').AsString);
          if linetxt <> '' then
          begin

            if length(linetxt) <= 60 then
            begin
              Str2Pos(linetxt,rcp[page_no][page_line_no],1);
              page_line_no := page_line_no + 1;
            end
            else
            begin
              string1to60 := PartStr(linetxt,string60toend,60);
              Str2Pos(string1to60,rcp[page_no][page_line_no],1);
              page_line_no := page_line_no + 1;
              Str2Pos(string60toend,rcp[page_no][page_line_no],1);
              page_line_no := page_line_no + 1;
            end;


          end;

          // ADD THE OrdreInstruks
          try
            linetxt := trim(Fieldbyname('OrdreInstruks').AsString);
            if linetxt <> '' then
            begin
              templist := TStringList.Create;
              try
                templist.StrictDelimiter := true;
                templist.Delimiter := Chr(10);
                templist.DelimitedText := WrapText(linetxt, 60);
                for I := 0 to templist.Count - 1 do
                begin
                  temptext := DeleteLineBreaks(templist[i]);
                  Str2Pos(temptext,rcp[page_no][page_line_no],1);
                  page_line_no := page_line_no + 1;
                end;
              finally
                templist.Free;
              end;
            end;
          except  // just in case the field is not there
          end;

          if ReportOrdreInstruks then
          begin
            try
              linetxt := trim(Fieldbyname('OrdreInstruks').AsString);
              if linetxt <> '' then
              begin
                ReportOrdreInstruks := False;
                templist := TStringList.Create;
                try
                  templist.StrictDelimiter := true;
                  templist.Delimiter := Chr(10);
                  templist.DelimitedText := WrapText(linetxt, 60);
                  for I := 0 to templist.Count - 1 do
                  begin
                    temptext := DeleteLineBreaks(templist[i]);
                    Str2Pos(temptext,rcp[page_no][HeaderLine],1);
                    HeaderLine := HeaderLine + 1;
                  end;
                finally
                  templist.Free;
                end;
              end;
            except  // just in case the field is not there
            end;
          end;

          // ADD THE ApotekBem
          try
            linetxt := trim(Fieldbyname('ApotekBem').AsString);
            if linetxt <> '' then
            begin

              if length(linetxt) <= 60 then
              begin
                Str2Pos(linetxt,rcp[page_no][page_line_no],1);
              end
              else
              begin
                string1to60 := PartStr(linetxt,string60toend,60);
                Str2Pos(string1to60,rcp[page_no][page_line_no],1);
                page_line_no := page_line_no + 1;
                Str2Pos(string60toend,rcp[page_no][page_line_no],1);
              end;
            end;
          except  // just in case the field is not there
          end;
          Next;
        end;
      finally
        CancelRange;
      end;
    except
      on e : Exception do
        C2LogAdd('Error processing lines ' + e.Message);
    end
  end;
end;



class procedure TRCPPrnForm.RCPView(ReceptId : integer);
begin
  with TRCPPrnForm.Create(Nil) do
  begin
    iReceptId := ReceptId;
    try
      //MatrixPrnForm.Visible := true;
      try
        Height := min(Screen.WorkAreaHeight,700);
        ShowModal;
      except
        on e : Exception do
          ChkBoxOK(e.Message);
      end;
    finally
      Free;
    end;
  end;
end;



procedure TRCPPrnForm.SetupUserPrinter(UserName: string);
begin
  C2LogAdd('setupuserprinter ' + Username);
  with MainDm do
  begin
    StdPrintPrn := '';
    StdPrintBin := '';
    StdPrintSize := 11;

    nxSettings.IndexName := 'AfdelingOrder';

    if nxSettings.FindKey([MainDm.AfdNr]) then
    begin
      StdPrintPrn := C2StrPrm(UserName,'Receptprinter',nxSettingsPrinterNavn2.AsString);
      StdPrintBin := C2StrPrm(UserName,'Receptskuffe',nxSettingsPrinterSkuffe2.AsString);
      StdPrintSize := C2IntPrm(UserName,'Receptpapir',nxSettingsPapirType2.AsInteger);
    end;

    StdPrintPrn := C2StrPrm(UserName,'Receptprinter',StdPrintPrn);
    StdPrintBin := C2StrPrm(UserName,'Receptskuffe',StdPrintBin);
    StdPrintSize := C2IntPrm(UserName,'Receptpapir',StdPrintSize);



    UserRemark := C2StrPrm(UserName,'Recepttekst','');

  end;

end;

procedure TRCPPrnForm.SpeedButton2Click(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

procedure TRCPPrnForm.WMSetScroll(var Msg: TMessage);
begin
//  if StdPrintSize = 11 then
//    ScrollBox1.ScrollBy(0,-350)
//  else
//    ScrollBox1.ScrollBy(0,-250);
//
    ScrollBox1.VertScrollBar.Position := trunc(0.35 * ScrollBox1.VertScrollBar.Range);
//     else
//    ScrollBox1.VertScrollBar.Position := trunc(0.30 * ScrollBox1.VertScrollBar.Range);



end;

procedure TRCPPrnForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    ModalResult := mrCancel;

end;

end.

