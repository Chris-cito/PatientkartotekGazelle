unit MatrixPrinter;

interface

uses
  Windows,  Messages, SysUtils, Classes,
  Graphics, Controls, Forms,    Dialogs,
  ExtCtrls, StdCtrls, Buttons,
   RpRender, RpRenderCanvas, RpRenderPreview, RpDefine, RpBase, RpFiler,RpRenderPrinter,
   RpRenderPDF,RpBars;
type
    TStr100 = string;
    TRCPSide = array[1..68] of TStr100;

type
  TMatrixPrnForm = class(TForm)
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
    procedure PrintMatrix(var PNr: Word; FileName: String);
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
  public
    { Public declarations }
    AktFileName: String;
    rcp : array[1..100] of TRCPSide;  // allow up to 100 page of recept print
    rcppages : integer;
    CPRNr : string;
  end;

var
  MatrixPrnForm: TMatrixPrnForm;
  MemStream: TMemoryStream;
  StdPrintPrn,
  StdPrintBin: String;
  StdPrintSize : integer;

implementation

uses
//  LaserFormularer,
  ChkBoxes,
  C2MainLog,
  C2Procs, DM, Main, uRCPMidCli,C2PrinterSelection;

{$R *.DFM}

procedure TMatrixPrnForm.PrintMatrix (var PNr : Word; FileName : String);
begin
  // Parametre fra inifile
  StdPrintPrn:= C2StrPrm('Systemprinter','Printer'        , '');
  StdPrintBin:= C2StrPrm('Systemprinter','Bakke'          , '');
  StdPrintPrn:= C2StrPrm(C2SysUserName  ,'Standardprinter', StdPrintPrn);
  StdPrintBin:= C2StrPrm(C2SysUserName  ,'Standardbakke'  , StdPrintBin);
  StdPrintSize := DMPAPER_A4;
  RCPPrint := False;
  if PNr = 999 then begin
    with MainDm do begin
      nxSettings.IndexName := 'AfdelingOrder';

      if not nxSettings.FindKey([Maindm.AfdNr]) then begin
        C2LogAdd('No afdeling in RSsettings file');
        nxSettings.First;
      end;
      StdPrintSize := DMPAPER_A5;

      StdPrintPrn := nxSettingsPrinterNavn2.AsString;
      StdPrintBin := nxSettingsPrinterSkuffe2.AsString;
      StdPrintPrn:= C2StrPrm(C2SysUserName  ,'Receptprinter', StdPrintPrn);
      StdPrintBin:= C2StrPrm(C2SysUserName  ,'Receptskuffe'  , StdPrintBin);
      StdPrintPrn:= C2StrPrm(C2SysUserName  ,'ReceptRapportprinter', StdPrintPrn);
      StdPrintBin:= C2StrPrm(C2SysUserName  ,'ReceptRapportskuffe'  , StdPrintBin);
      StdPrintSize:= C2IntPrm(C2SysUserName  ,'ReceptRapportpapir'  , StdPrintSize);

      // get different printers
      RCPPrint := True;
    end;
  end;
  // Check std.printer
  if StdPrintPrn = '' then begin
    ChkBoxOK('Mangler opsætning af standard printer!');
    Exit;
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
    MatrixPrnForm.Visible := False;
  finally
  end;
end;

procedure TMatrixPrnForm.rpsC2Print(Sender: TObject);
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
  begin with (Sender as TBaseReport) do begin
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
  end; end;

procedure LinieUd(S: String);
  var
    SideStr: String;
//  begin with (Sender as TBaseReport) do begin
  begin with (Sender as TBaseReport) do begin
    // Normal
    if S = '[FORMFEED]' then begin
      NewPage;
      Home;
      HeadOut := True;
    end;
    SetFont ('Courier New', 11);
    if HeadOut then begin
      Inc(SideOut);
      SideStr:= 'Side ' + IntToStr(SideOut);
      SideStr:= Spaces(12 - Length(SideStr)) + SideStr;
      PrintLn(Header1);
      NewLine;
      PrintLn(Header2 + SideStr);
      PrintLn(FixStr ('-', 72));
      NewLine;
      if Header3 <> '' then begin
        ChkCond(Header3);
        NewLine;
      end;
      if Header4 <> '' then begin
        ChkCond(Header4);
        if Header5 <> '' then
          ChkCond(Header5);
        NewLine;
      end;
      HeadOut:= False;
    end;
    // Kun hvis der ikke var sideskift
    if S <> '[FORMFEED]' then begin
      ChkCond(S);
      if LinesLeft < 1 then begin
        NewPage;
        Home;
        HeadOut:= True;
      end;
    end;
  end; end;

begin with (Sender as TBaseReport) do begin
  if RCPPrint then begin
    PrintRCPReport(Sender);
    exit;
  end;
  Sektion:= TStringList.Create;
  Liste  := TStringList.Create;
  SectOn := False;
  try
    Liste.LoadFromFile (AktFileName);
    if Liste.Count > 0 then begin
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
      for LinCnt:= 0 to Liste.Count - 1 do begin
        WrkStr:= Liste.Strings[LinCnt];
        try
          if WrkStr = '[SECTION-ON]' then begin
            // Start samlet sektion
            Sektion.Clear;
            SectOn:= True;
          end else begin
            if SectOn then begin
              if WrkStr = '[SECTION-OFF]' then begin
                // Sektion afsluttes
                if LinesLeft < Sektion.Count then begin
                  // Der var ikke plads på samme side
                  LinieUd('[FORMFEED]');
                  if Sektion.Count > 0 then begin
                    // Sektion må ikke være tom
                    while Sektion.Strings [0] = '' do
                      // Tøm for tomme linier efter sideskift
                      if Sektion.Count > 0 then
                        Sektion.Delete(0);
                  end;
                end;
                for SekCnt:= 0 to Sektion.Count - 1 do begin
                  // Udskriv sektion evt. efter sideskift
                  WrkStr:= Sektion.Strings[SekCnt];
                  LinieUd(WrkStr);
                end;
                SectOn:= False;
              end else begin
                // Opsamling i sektion
                Sektion.Add(WrkStr);
              end;
            end else begin
              // Normal linie udskrives
              LinieUd(WrkStr);
            end;
          end;
        except
          ChkBoxOk('Fejl under printning, linie skippes !');
        end;
      end;
      // Udskriv evt formfeed
      if LinesLeft < 1 then begin
        NewPage;
        Home;
        HeadOut:= True;
      end;
    end;
  finally
    Sektion.Free;
    Liste  .Free;
  end;
end; end;

procedure TMatrixPrnForm.FormShow(Sender: TObject);
var
  tst : boolean;
begin
    RvNDRWriter1.StreamMode := smUser;
    RvNDRWriter1.Stream := memStream;
    c2logadd('matrix printer prn ' + StdPrintPrn);
    c2logadd('matrix printer bin ' + StdPrintBin);
    tst := C2SetPaperSize(StdPrintSize,0,0);
    c2logadd('tst is ' + Bool2Str(tst));
    tst := C2SelectPrinter(StdPrintPrn);
    c2logadd('tst is ' + Bool2Str(tst));
    if StdPrintBin <> '' then
    begin
      tst := C2SelectBin(StdPrintBin);
    c2logadd('select bin tst is ' + Bool2Str(tst));
    end;
    RvNDRWriter1.Execute;


  RvRenderPreview1.Render(memStream);
  RvRenderPreview1.ZoomFactor := RvRenderPreview1.ZoomPageWidthFactor;
  edtFirst.Text := IntToStr(RvRenderPreview1.FirstPage);
  edtLast.Text := IntToStr(RvRenderPreview1.Pages);
end;

procedure TMatrixPrnForm.buUdskrivClick(Sender: TObject);
begin
  IF RCPPrint then begin
    RCPMidCli.SendRequest('GetAddressed',
          [
          '7',
          CPRNr,
          IntToStr(Maindm.AfdNr),
          C2SysUserName
          ],
          10);
  end else begin
    RvRenderPrinter1.FirstPage :=   StrToInt(edtFirst.Text);
    RvRenderPrinter1.LastPage :=  strtoint(edtLast.Text);
    RvRenderPrinter1.Render(memStream);
  end;
  ModalResult := mrOk;
end;

procedure TMatrixPrnForm.FormCreate(Sender: TObject);
begin
  // Default
  C2LogAdd('MatrixPrnForm create in');
  memStream := TMemoryStream.Create;
  c2logadd('MatrixPrnForm create out');
  C2LogSave;
end;

procedure TMatrixPrnForm.FormDestroy(Sender: TObject);
begin
  MemStream.Free;
end;

procedure TMatrixPrnForm.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TMatrixPrnForm.BitBtn1Click(Sender: TObject);
begin
  try
    MemStream.Seek(0,0);
    if SaveDialog1.Execute then begin
      RvRenderPDF1.PrintRender(MemStream,SaveDialog1.FileName);
      ModalResult := mrOk;
    end else
      ModalResult := mrNone;
  except
    on e : exception do
      ChkBoxOK(e.Message);
  end;

end;

procedure TMatrixPrnForm.PrintRCPReport(Sender: TObject);

var
  i,j : integer;
  ipos : integer;
  tmpstr : string;
  Bar : TRPBarsCode128;
  function Spaces (I : integer) : string;
  var
      formatstring : string;
  begin
    formatstring := '%-' + IntToStr(i) + 's';
    Result := Format(formatstring,[' ']);
//      FillChar  (S, I + 1, ' ');
//      SetLength (S, I);
//      Spaces := S;
  end;

  procedure Str2Pos (IndS : TStr100; var UdS : TStr100; P : Word);
  begin
      if UdS = '' then
        UdS := Spaces (62);
      Delete (UdS, P, Length (IndS));
      Insert (IndS, UdS, P);
  end;


begin
  with (Sender as TBaseReport) do begin
    ResetSection;
    Home;
    LinesPerInch := 8;
    MarginLeft   := 10.0;
    MarginRight  := 0.0;
    MarginTop    := 10.0;
    MarginBottom := 0.0;
    for j := 1 to rcppages do begin
      Bar := TRPBarsCode128.Create(Sender as TBaseReport);
      try
          with Bar do begin
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
            PrintXY (3.5*25.4,0.70*25.4);
          end;
      finally
        Bar.free;
      end;
      SetFont('Courier New',9.0);
      Home;
      NewLine;
      Str2Pos('Ordinationerne er gyldige i 2 år fra udstedelsesdatoen.',rcp[1][57],1);
      Str2Pos('Side ' + inttostr(j) + ' af ' + inttostr(rcppages) + '      Udskriftsdato ' +
        FormatDateTime('dd.mm.yyyy hh:mm:ss',Now) ,rcp[1][59],1);

      for i := 1 to 59 do begin
        if i = 1 then begin
          SetFont('Courier New',14.0);
          Bold := true;
        end else begin
          SetFont('Courier New',9.0);
          Bold := False;
        end;
{
        if i = 8 then begin
          SetPen(clBlack,psSolid,-2,pmCopy);
          SetTab(0.4,pjLeft,5,1,BOXLINEBOTTOM,0);
          PrintTab('');
          ClearTabs;
        end;
        if i = 15 then begin
          SetPen(clBlack,psSolid,-2,pmCopy);
          SetTab(0.4,pjLeft,5,1,BOXLINEBOTTOM,0);
          PrintTab('');
          ClearTabs;
        end;
        if i = 21 then begin
          SetPen(clBlack,psSolid,-2,pmCopy);
          SetTab(0.4,pjLeft,5,1,BOXLINEBOTTOM,0);
          PrintTab('');
          ClearTabs;
        end;
}
        if (i < 9) or (i > 48) then
          Print(rcp[1][i])
        else begin
          if copy(rcp[j][i],1,6) = '<bold>' then begin
            tmpstr := rcp[j][i];
            Bold := true;
            Delete(tmpstr,1,6);
            ipos := pos('</bold>',tmpstr);
            if ipos <> 0 then begin
              print(copy(tmpstr,1,ipos-1));
              delete(tmpstr,1,ipos+6);
              Bold := False;
              if tmpstr <> '' then
                Print(tmpstr);
            end else begin
              Print(tmpstr);
            end;
            Bold := False;
          end else
            Print(rcp[j][i]);
        end;
        NewLine;
      end;
      if j <> rcppages then
         NewPage;

    end;
  end;

end;

end.

