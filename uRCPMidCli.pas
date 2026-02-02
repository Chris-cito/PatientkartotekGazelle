{$I bsdefine.inc}

{ Developed by: Cito IT A/S

  Description: Used tio communicate with RSMidsrv or C2FMKMidsrv

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  25-03-2020/cjs  Do not close the connect to C2FMKMidsrv for printing reports.  keeps 1 socket open
                  all the time and avoids the time_wait issue

  29-01-2020/CJS  added afdelingnr parameter to SendRCPRapport

  15-01-2020/cjs  added routine to print cprlist using a string list
}

{
Følgende programmer der gør brug af denne unit:

BENYTTES IKKE MERE  - PBSBetaling

  - C2Kasse
  - FinansUdskrifter
  - KasseAfstemning
  - OpdaterCtr
  - PatientKartotek
  - ProgramLinie
  - StregkodeKontrol
  - TakstKartotek
}

unit uRCPMidCli;

interface

uses
  Windows, Messages, SysUtils, Graphics, Controls, Forms, Classes, ExtCtrls,

OverbyteRFormat, OverbyteIcsWndControl,
  OverbyteApsCli, OverbyteIcsHttpProt;

type
  TRCPMidCli = class(TDataModule)
    BufApp: TMWBuffer;
    CliApp: TAppSrvClient;
    TimApp: TTimer;

    procedure MidClientCreate(Sender: TObject);
    procedure TimAppTimer(Sender: TObject);
    procedure CliAppAfterProcessReply(Sender: TObject; var CmdBuf: PAnsiChar;
      var CmdLen: Integer);

    function  WaitAnswer(T: Word) :Word;
    function  SendRequest(F: String; S: array of Const; TimO: Word): Word;
    function SendRCPRapport(AUserName,ACPRNr : string; AAfdelingNr : integer; ARapport : TStringList) : Word;
  private
    AppAdresse,
    AppPort     : String;
    FCloseConnection: boolean;
    property CloseConnection: boolean read FCloseConnection write FCloseConnection;
  public
    Http        : THttpCli;
    MsgAktiv,
    CtrAktiv    : Boolean;
  end;

var
  RCPMidCli: TRCPMidCli;

implementation

uses
  C2MainLog,
  ChkBoxes;

{$R *.DFM}

procedure TRCPMidCli.MidClientCreate(Sender: TObject);
begin
C2LogAdd ('MidClient MidClientCreate in');
  AppAdresse   := C2StrPrm('Applikationsserver', 'Adresse', '');
  AppPort      := '2113';
  MsgAktiv     := False;
  AppAdresse   := C2StrPrm('Receptserver', 'Adresse', AppAdresse);
  AppPort      := C2StrPrm('Receptserver', 'Localport' , AppPort);
  FCloseConnection := CompareText(C2StrPrm(C2SysUserName,'CloseSocketConnections','JA'),'JA') = 0;
C2LogAdd ('MidClient MidClientCreate out');
c2logsave;
end;

procedure TRCPMidCli.CliAppAfterProcessReply(Sender: TObject;
  var CmdBuf: PAnsiChar; var CmdLen: Integer);
begin
  CliApp.Tag := 0;
end;

procedure TRCPMidCli.TimAppTimer(Sender: TObject);
begin
  CliApp.Tag := 999;
  TimApp.Enabled := False;
end;


function TRCPMidCli.WaitAnswer(T: Word): Word;
begin
  C2LogAdd('  WaitAnswer in');
  Result:= 999;
  CliApp.Tag:= 2;
  try
    // Send til AppServer
    C2LogAdd('  Send til AppServer');
    CliApp.Send;
    // Start timeout counter
    TimApp.Interval:= T * 1000;
    TimApp.Enabled := True;
    repeat
//      Sleep (50);
      Application.ProcessMessages;
    until (not TimApp.Enabled) or (CliApp.Tag = 0);
    // Stop timeout counter (kan være stoppet hvis ok)
    C2LogAdd('  Timeout/svar fra AppServer');
    TimApp.Enabled:= False;
    // Mulig connection error
    Result:= 6;
    if CliApp.Connected then
    begin
      C2LogAdd('  Close session til AppServer');
      // Close session
      if CloseConnection then
        CliApp.Close;
      // Gem result fra session
      Result:= CliApp.Tag;
      // Hvis ikke ok så retabler NoAnswer
      if Result <> 0 then
        Result:= 2;
    end
    else
      C2LogAdd('  Tabt session til AppServer');
  except
    on E:Exception do
      C2LogAdd('  Exception, "' + E.Message + '"');
  end;
  C2LogAdd('  WaitAnswer out, result=' + IntToStr(Result));
end;

function TRCPMidCli.SendRCPRapport(AUserName, ACPRNr: string;
  AAfdelingNr: Integer; ARapport: TStringList): Word;
var
  LStream : TStringStream;
begin
  C2LogAdd('MidClient SendRCPRapport in');
  LStream := TStringStream.Create;
  try
    CliApp.Server       := AppAdresse;
    CliApp.Port         := AppPort;
    CliApp.FunctionCode := 'GetAddressed';
    CliApp.Request.Rewrite;
    CliApp.Request.WriteFields(TRUE,['71',AUserName,ACPRNr]);
    ARapport.SaveToStream(LStream);
    LStream.Seek(0,0);
    CliApp.Request.WriteStreamField(False,mwBlob,LStream);

    CliApp.Request.WriteFields(False,[AAfdelingNr.ToString]);
    Result:= WaitAnswer(30);
    if Result = 0 then
    begin
      if StrToInt(BufApp.Fields[0]) <> 0 then
      begin
        ChkBoxOK('FMKMIdsrv error ' + BufApp.Fields[0]);
        Result := strtoint(BufApp.Fields[0]);
      end;
    end;
  finally
    LStream.Free;
    C2LogAdd('MidClient SendRCPRapport out');

  end;

end;

function TRCPMidCli.SendRequest (F: String; S: array of Const; TimO: Word): Word;
begin
  C2LogAdd('MidClient SendRequest in, ' + F + ' timeout=' + IntToStr(TimO));
  CliApp.Server       := AppAdresse;
  CliApp.Port         := AppPort;
  CliApp.FunctionCode := F;
  CliApp.Request.Rewrite;
  CliApp.Request.WriteFields(TRUE, S);
  Result:= WaitAnswer(TimO);
  if Result = 0 then
  begin
    if StrToInt(BufApp.Fields[0]) <> 0 then
    begin
      ChkBoxOK('Recept server update error ' + BufApp.Fields[0]);
      Result := strtoint(BufApp.Fields[0]);
    end;
  end;
  C2LogAdd('MidClient SendRequest out');
end;


end.
