unit PatMatrixPrinter;

{ Developed by: Cito IT A/S

  Description: Shows repports on screen

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  15-01-2020/cjs  Changd print function of Receptoversigt to send a copy of the print displayed
                  on screen rather than get midsrv program to to use fmk calls itself
}

interface

uses
  Windows,  Messages, SysUtils, Classes,
  Graphics, Controls, Forms,    Dialogs,
  ExtCtrls, StdCtrls, Buttons,
   RpRender, RpRenderPreview, RpDefine, RpBase, RpFiler,RpRenderPrinter,
   RpRenderPDF,RpBars, DBXDataSnap, DBXCommon, DB, SqlExpr, IPPeerClient, RpRenderCanvas;
type
    TStr100 = string;
    TRCPSide = array[1..68] of TStr100;

type
  TPatMatrixPrnForm = class(TForm)
    Panel1: TPanel;
    buUdskriv: TBitBtn;
    buFortryd: TBitBtn;
    Label1: TLabel;
    edtFirst: TEdit;
    Label2: TLabel;
    edtLast: TEdit;
    ScrollBox1: TScrollBox;
    SaveDialog1: TSaveDialog;
    BitBtn1: TBitBtn;
    RvRenderPrinter1: TRvRenderPrinter;
    RvRenderPreview1: TRvRenderPreview;
    RvNDRWriter1: TRvNDRWriter;
    RvRenderPDF1: TRvRenderPDF;
    SQLConnection1: TSQLConnection;
    /// <summary>Prints a report to the standard printer
    /// </summary>
    /// <param name="PNr">Pnr is not really used anymore 999 is a receptserver print
    /// </param>
    ///<param name="FileName">Name of the file tat comtains the text to printed 1st 5 lines are header
    ///  </param>
    ///  <param name="APortraitPrint">orientation of the print. True=Portrait false =Ladscape
    ///  Default is True (Portrait)
    ///  </param>
    procedure PrintMatrix(var PNr: Word; FileName: String;APortraitPrint : boolean=True);
    procedure rpsC2Print(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure buUdskrivClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    RCPPrint : boolean;
    procedure PrintRCPReport(Sender: TObject);
    procedure SendReportToKasseDK;
  public
    { Public declarations }
    AktFileName: String;
    rcp : array[1..100] of TRCPSide;  // allow up to 100 page of recept print
    rcppages : integer;
    CPRNr : string;
  end;

var
  PatMatrixPrnForm: TPatMatrixPrnForm;
  MemStream: TMemoryStream;
  StdPrintPrn,
  StdPrintBin: String;
  StdPrintSize : integer;

implementation

uses
//  LaserFormularer,
  ChkBoxes,
  C2MainLog,
  C2Procs, DM, Main, uRCPMidCli,C2PrinterSelection, //MatrixPrinter,
  MatrixClassesu, DSPrintu, BonPrinter;

{$R *.DFM}

function Spaces (I : integer) : string;
var
    formatstring : string;
begin
  formatstring := '%-' + IntToStr(i) + 's';
  Result := Format(formatstring,[' ']);
//    FillChar  (S, I + 1, ' ');
//    SetLength (S, I);
//    Spaces := S;
end;

procedure Str2Pos (IndS : TStr100; var UdS : TStr100; P : Word);
begin
    if UdS = '' then
      UdS := Spaces (62);
    Delete (UdS, P, Length (IndS));
    Insert (IndS, UdS, P);
end;


procedure TPatMatrixPrnForm.PrintMatrix (var PNr : Word; FileName : String;APortraitPrint : boolean=True);
begin
  // Parametre fra inifile
  StdPrintPrn:= C2StrPrm('Systemprinter','Printer'        , '');
  StdPrintBin:= C2StrPrm('Systemprinter','Bakke'          , '');
  StdPrintPrn:= C2StrPrm(MainDm.C2UserName  ,'Standardprinter', StdPrintPrn);
  StdPrintBin:= C2StrPrm(MainDm.C2UserName  ,'Standardbakke'  , StdPrintBin);
  StdPrintSize := DMPAPER_A4;


  // new parameter sets the orientation to portrait or Landscape (default is Portrait)
  if APortraitPrint then
    RvNDRWriter1.Orientation := poPortrait
  else
    RvNDRWriter1.Orientation := poLandScape;

  RCPPrint := False;
  if PNr = 999 then
  begin
    with MainDm do
    begin
      nxSettings.IndexName := 'AfdelingOrder';

      if not nxSettings.FindKey([MainDm.AfdNr]) then
      begin
        C2LogAdd('No afdeling in RSsettings file');
        nxSettings.First;
      end;
      StdPrintSize := DMPAPER_A5;

      StdPrintPrn := nxSettingsPrinterNavn2.AsString;
      StdPrintBin := nxSettingsPrinterSkuffe2.AsString;
      StdPrintPrn:= C2StrPrm(MainDm.C2UserName  ,'Receptprinter', StdPrintPrn);
      StdPrintBin:= C2StrPrm(MainDm.C2UserName  ,'Receptskuffe'  , StdPrintBin);
      StdPrintPrn:= C2StrPrm(MainDm.C2UserName  ,'ReceptRapportprinter', StdPrintPrn);
      StdPrintBin:= C2StrPrm(MainDm.C2UserName  ,'ReceptRapportskuffe'  , StdPrintBin);
      StdPrintSize:= C2IntPrm(MainDm.C2UserName  ,'ReceptRapportpapir'  , StdPrintSize);

      // get different printers
      RCPPrint := True;
    end;
  end;
  // Check std.printer
  if StamForm.PrinterServerIP = '' then
  begin
    if StdPrintPrn = '' then
    begin
      ChkBoxOK('Mangler opsætning af standard printer!');
      Exit;
    end;
  end;
  AktFileName:= Filename;
  try
    RvNDRWriter1.StreamMode := smUser;
    //MatrixPrnForm.Visible := true;
    try
      ShowModal;
    except
      on e : Exception do
        ChkBoxOK(e.Message);
    end;
    PatMatrixPrnForm.Visible := False;
  finally
  end;
end;

procedure TPatMatrixPrnForm.rpsC2Print(Sender: TObject);
var
  SectOn,
  HeadOut: Boolean;
  Header1,
  Header2,
  Header3,
  Header4,
  Header5,
  WrkStr : String;
  SekCnt,
  LinCnt : Integer;
  SideOut: Word;
  Sektion,
  Liste  : TStringList;

  procedure ChkCond(S: String);
  var
    PosOn,
    PosOff: Word;
    Boldon,
    BoldOff : word;
  begin
    with (Sender as TBaseReport) do
    begin
      // Check COND ON
      PosOn:= Pos('[COND-ON]', S);
      if PosOn > 0 then
        Delete(S, PosOn, 9);
      // Check COND OFF
      PosOff:= Pos('[COND-OFF]', S);
      if PosOff > 0 then
        Delete(S, PosOff, 10);

      // check for bold
      Boldon := pos('[BOLD-ON]',S);
      if BoldOn > 0 then
        Delete(S, Boldon, 9);
      BoldOff:= Pos('[BOLD-OFF]', S);
      if BoldOff > 0 then
        Delete(S, BoldOff, 10);

      // Set font for COND ON
      if PosOn > 0 then
        SetFont('Courier New', 7);
      if Boldon > 0 then
        Bold := true;
      PrintLn(S);
      // Set font for COND OFF
      if PosOff > 0 then
        SetFont('Courier New', 11);
      if BoldOff > 0 then
        Bold := False;
    end;
  end;

  procedure LinieUd(S: String);
    var
      SideStr: String;
  //  begin with (Sender as TBaseReport) do begin
    begin with (Sender as TBaseReport) do
    begin
      // Normal
      if S = '[FORMFEED]' then
      begin
        NewPage;
        Home;
        HeadOut := True;
      end;
      SetFont ('Courier New', 11);
      if HeadOut then
      begin
        Inc(SideOut);
        SideStr:= 'Side ' + IntToStr(SideOut);
        SideStr:= Spaces(12 - Length(SideStr)) + SideStr;
        PrintLn(Header1);
        NewLine;
        PrintLn(Header2 + SideStr);
        PrintLn(FixStr ('-', 72));
        NewLine;
        if Header3 <> '' then
        begin
          ChkCond(Header3);
          NewLine;
        end;
        if Header4 <> '' then
        begin
          ChkCond(Header4);
          if Header5 <> '' then
            ChkCond(Header5);
          NewLine;
        end;
        HeadOut:= False;
      end;
      // Kun hvis der ikke var sideskift
      if S <> '[FORMFEED]' then
      begin
        ChkCond(S);
        if LinesLeft < 1 then
        begin
          NewPage;
          Home;
          HeadOut:= True;
        end;
      end;
    end;
  end;

begin
  with (Sender as TBaseReport) do
  begin
    if RCPPrint then
    begin
      PrintRCPReport(Sender);
      exit;
    end;
    Sektion:= TStringList.Create;
    Liste  := TStringList.Create;
    SectOn := False;
    try
      Liste.LoadFromFile (AktFileName);
      if Liste.Count > 0 then
      begin
        Header1:= copy(Trim(Liste.Strings[0]),1,55);
        Header1:= Header1 + Spaces(56 - Length(Header1));
        Header1:= Header1 + FormatDateTime('dd-mm-yyyy hh:mm', Now);
        Header2:= Trim(Liste.Strings[1]);
        Header2:= Header2 + Spaces(60 - Length(Header2));
        Header3:= Trim(Liste.Strings[2]);
        Header4:= Trim(Liste.Strings[3]);
        Header5:= Trim(Liste.Strings[4]);
        HeadOut:= True;
        SideOut:= 0;
        Liste.Delete(0);
        Liste.Delete(0);
        Liste.Delete(0);
        Liste.Delete(0);
        Liste.Delete(0);
        // Udskriv liste
        for LinCnt:= 0 to Liste.Count - 1 do
        begin
          WrkStr:= Liste.Strings[LinCnt];
          try
            if WrkStr = '[SECTION-ON]' then
            begin
              // Start samlet sektion
              Sektion.Clear;
              SectOn:= True;
            end
            else
            begin
              if SectOn then
              begin
                if WrkStr = '[SECTION-OFF]' then
                begin
                  // Sektion afsluttes
                  if LinesLeft < Sektion.Count then
                  begin
                    // Der var ikke plads på samme side
                    LinieUd('[FORMFEED]');
                    if Sektion.Count > 0 then
                    begin
                      // Sektion må ikke være tom
                      while Sektion.Strings [0] = '' do
                        // Tøm for tomme linier efter sideskift
                        if Sektion.Count > 0 then
                          Sektion.Delete(0);
                    end;
                  end;
                  for SekCnt:= 0 to Sektion.Count - 1 do
                  begin
                    // Udskriv sektion evt. efter sideskift
                    WrkStr:= Sektion.Strings[SekCnt];
                    LinieUd(WrkStr);
                  end;
                  SectOn:= False;
                end
                else
                begin
                  // Opsamling i sektion
                  Sektion.Add(WrkStr);
                end;
              end
              else
                // Normal linie udskrives
                LinieUd(WrkStr);
            end;
          except
            ChkBoxOk('Fejl under printning, linie skippes !');
          end;
        end;
        // Udskriv evt formfeed
        if LinesLeft < 1 then
        begin
          NewPage;
          Home;
          HeadOut:= True;
        end;
      end;
    finally
      Sektion.Free;
      Liste  .Free;
    end;
  end;
end;

procedure TPatMatrixPrnForm.SendReportToKasseDK;

var
  i,j : integer;
  ipos : integer;
  tmpstr : string;
  BonList : TStringList;


begin
    BonList := TStringList.Create;
    try
      for j := 1 to rcppages do
      begin
        Str2Pos('Ordinationerne er gyldige i 2 år fra udstedelsesdatoen.',rcp[1][57],1);
        Str2Pos('Side ' + inttostr(j) + ' af ' + inttostr(rcppages) + '      Udskriftsdato ' +
          FormatDateTime('dd.mm.yyyy hh:mm:ss',Now) ,rcp[j][59],1);

        for i := 1 to 59 do
        begin
          tmpstr := rcp[j][i];
          if (i < 9) or (i > 48) then
          begin
            BonList.Add(tmpstr);
            continue;
          end;
//          if i in [1,2] then begin
//  //          LineHeightMethod := lhmFont;
//  //          SetFont('Courier New',14.0);
//  //          Bold := true;
//          end else begin
//  //          LineHeightMethod := lhmLinesPerInch;
//  //          SetFont('Courier New',9.0);
//  //          Bold := False;
//          end;
          if copy(tmpstr,1,6) = '<bold>' then
          begin
//            Bold := true;
            Delete(tmpstr,1,6);
            ipos := pos('</bold>',tmpstr);
            if ipos <> 0 then
            begin
              BonList.Add(copy(tmpstr,1,ipos-1));
              delete(tmpstr,1,ipos+6);
//              Bold := False;
              if tmpstr <> '' then
                BonList.Add(tmpstr);
            end
            else
            begin
              BonList.Add(tmpstr);
            end;
//            Bold := False;
          end
          else
            BonList.Add(tmpstr);
        end;
      end;
    finally
      bonlist.SaveToFile('g:\temp\bonlisttest.txt');
      BonPrinter.UdskrivBon(BonList);
      bonlist.Free;
    end;



end;

procedure TPatMatrixPrnForm.FormShow(Sender: TObject);
var
  tst : boolean;
begin
  RvNDRWriter1.StreamMode := smUser;
  RvNDRWriter1.Stream := memStream;
  c2logadd('matrix printer prn ' + StdPrintPrn);
  c2logadd('matrix printer bin ' + StdPrintBin);
  tst := C2SetPaperSize(StdPrintSize,0,0);
  c2logadd('tst is ' + Bool2Str(tst));
  if StamForm.PrinterServerIP = '' then
  begin

    tst := C2SelectPrinter(StdPrintPrn,RvNDRWriter1,ExtractFileName(AktFileName));
    c2logadd('tst is ' + Bool2Str(tst));
    if StdPrintBin <> '' then
    begin
      tst := C2SelectBin(StdPrintBin);
      c2logadd('select bin tst is ' + Bool2Str(tst));
    end;

  end;
  RvNDRWriter1.Execute;


  RvRenderPreview1.Render(memStream);
  RvRenderPreview1.ZoomFactor := RvRenderPreview1.ZoomPageWidthFactor;
  edtFirst.Text := IntToStr(RvRenderPreview1.FirstPage);
  edtLast.Text := IntToStr(RvRenderPreview1.Pages);
end;

procedure TPatMatrixPrnForm.buUdskrivClick(Sender: TObject);
var
  liste : tstringlist;
  i : integer;
  j : integer;
begin
  IF RCPPrint then
  begin
    If C2StrPrm(MainDm.C2UserName,'RCPPrintOnBonPrinter','') = 'Ja' then
      SendReportToKasseDK
    else
    begin
      liste := TStringList.Create;
      try
        for i := 1 to  rcppages do
        begin
          for j := low(trcpside) to High(TRCPSide) do
          begin
            case j of
              1 .. 8:
                Liste.Add(rcp[1][j]);
              49 .. 58, 60 .. 68:
                Liste.Add(rcp[1][j]);
            else
              Liste.Add(rcp[i][j]);

            end;
          end;

        end;
        C2LogAdd(liste.Count.toString + ':' +liste.Text);
        RCPMidCli.SendRCPRapport(MainDm.C2UserName,CPRNr,MainDm.AfdNr, liste);
//        RCPMidCli.SendRequest('GetAddressed',
//              [
//              '7',
//              CPRNr,
//              IntToStr(MainDm.AfdNr),
//              C2SysUserName,
//              ],
//              10);
      finally
        liste.Free;
      end;
    end;
  end
  else
  begin
    if StamForm.PrinterServerIP <> '' then
    begin
      liste := TStringList.Create;
      try
        liste.LoadFromFile(AktFileName);
        DMDSPrinter.PrintMatrixReport(MainDm.C2UserName,liste.Text,StamForm.PrinterServerIP);
      finally
        liste.Free;
      end;
    end
    else
    begin;
      RvRenderPrinter1.FirstPage :=   StrToInt(edtFirst.Text);
      RvRenderPrinter1.LastPage :=  strtoint(edtLast.Text);
      RvRenderPrinter1.Render(memStream);
    end;
  end;
  ModalResult := mrOk;
end;

procedure TPatMatrixPrnForm.FormCreate(Sender: TObject);
begin
  // Default
  C2LogAdd('MatrixPrnForm create in');
  memStream := TMemoryStream.Create;
  c2logadd('MatrixPrnForm create out');
  C2LogSave;
end;

procedure TPatMatrixPrnForm.FormDestroy(Sender: TObject);
begin
  MemStream.Free;
end;

procedure TPatMatrixPrnForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if key = vk_NEXT then
    RvRenderPreview1.NextPage;

  if Key = vk_PRIOR then
    RvRenderPreview1.PrevPage;

//  if Key = vk_HOME then
//    RvRenderPreview1.FirstPage;

//  if Key = vk_END then
//    RvRenderPreview1.LastPage;

  if key = vk_DOWN then
    ScrollBox1.ScrollBy(0,-200);
  if Key = vk_UP then
    ScrollBox1.ScrollBy(0,200);
end;

procedure TPatMatrixPrnForm.BitBtn1Click(Sender: TObject);
begin
  try
    MemStream.Seek(0,0);
    if SaveDialog1.Execute then
    begin
      RvRenderPDF1.PrintRender(MemStream,SaveDialog1.FileName);
      ModalResult := mrOk;
    end
    else
      ModalResult := mrNone;
  except
    on e : exception do
      ChkBoxOK(e.Message);
  end;

end;

procedure TPatMatrixPrnForm.PrintRCPReport(Sender: TObject);

var
  i,j : integer;
  ipos : integer;
  tmpstr : string;
  Bar : TRPBarsCode128;

begin
  with (Sender as TBaseReport) do begin
    ResetSection;
    Home;
    LinesPerInch := 8;
    MarginLeft   := 10.0;
    MarginRight  := 0.0;
    MarginTop    := 10.0;
    MarginBottom := 0.0;
    for j := 1 to rcppages do
    begin
      Bar := TRPBarsCode128.Create(Sender as TBaseReport);
      try
          with Bar do
          begin
            BarHeight       := 0.4 *25.4;
            BarWidth        := 0.014*25.4;
            Text            := copy(rcp[1][3],1,6) + copy(rcp[1][3],8,4);
            TextJustify     := pjCenter;
            UseChecksum     := False;
            CodePage := cpCodeC;
            PrintReadable   := False;
            PrintChecksum   := False;
            PrintTop        := True;
            BarCodeRotation := Rot0;
            BarCodeJustify  := pjCenter;
            PrintXY (3.5*25.4,1.0*25.4);
          end;
      finally
        Bar.free;
      end;
      SetFont('Courier New',9.0);
      Home;
      NewLine;
      Str2Pos('Ordinationerne er gyldige i 2 år fra udstedelsesdatoen.',rcp[j][57],1);
      Str2Pos('Side ' + inttostr(j) + ' af ' + inttostr(rcppages) + '      Udskriftsdato ' +
        FormatDateTime('dd.mm.yyyy hh:mm:ss',Now) ,rcp[j][59],1);

      for i := 1 to 59 do
      begin
        if i in [1,2] then
        begin
          LineHeightMethod := lhmFont;
          SetFont('Courier New',14.0);
          Bold := true;
        end
        else
        begin
          LineHeightMethod := lhmLinesPerInch;
          SetFont('Courier New',9.0);
          Bold := False;
        end;
        if (i < 9) or (i > 48) then
        begin
          if i = 59 then
            Print(rcp[j][i])
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
      if j <> rcppages then
         NewPage;

    end;
  end;

end;

end.
