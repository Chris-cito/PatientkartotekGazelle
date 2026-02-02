unit uRowaAppCall;

{ Developed by: Vitec Cito A/S

  Description: Robot communication module

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  25-03-2020/cjs  Do not close the connect to Robot interface.  keeps 1 socket open
                  all the time and avoids the time_wait issue
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OverbyteRFormat, OverbyteIcsWndControl,
  OverbyteApsCli, ExtCtrls;

type
  TfrmRowaApp = class(TForm)
    CliApp: TAppSrvClient;
    BuffApp: TMWBuffer;
    Button1: TButton;
    TimApp: TTimer;
    Memo1: TMemo;
    Button2: TButton;
    edtVarenr: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtAntal: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure CliAppAfterProcessReply(Sender: TObject; var CmdBuf: PAnsiChar;
      var CmdLen: Integer);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimAppTimer(Sender: TObject);
  private
    FCloseConnection: boolean;
    property CloseConnection: boolean read FCloseConnection write FCloseConnection;
    function  WaitAnswer(T: Word) :Word;
    { Private declarations }
  public
    { Public declarations }
    procedure RowaSendARequest(varenr: string; Antal:integer);
    procedure RowaSendAXRequest(sl : TStringList;RobotUdtag: string);
  end;

var
  frmRowaApp: TfrmRowaApp;

implementation

uses C2MainLog, Main;

{$R *.dfm}


procedure TfrmRowaApp.Button1Click(Sender: TObject);
var
  varenr : string;
  Antal : integer;
begin
    varenr := edtVarenr.Text;
    Antal := strtoint(edtAntal.Text);
    RowaSendARequest(Varenr,Antal);

end;

function TfrmRowaApp.WaitAnswer(T: Word): Word;
begin
  Result:= 999;
  CliApp.Tag:= 2;
  try
    // Send til AppServer
    CliApp.Send;
    // Start timeout counter
    TimApp.Interval:= T * 1000;
    TimApp.Enabled := True;
    repeat
//      Sleep (50);
      Application.ProcessMessages;
    until (not TimApp.Enabled) or (CliApp.Tag = 0);
    // Stop timeout counter (kan være stoppet hvis ok)
    TimApp.Enabled:= False;
    // Mulig connection error
    Result:= 6;
    if CliApp.Connected then
    begin
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
    begin
    end;
  except
    on E:Exception do
      Application.MessageBox(pchar(e.Message),'Fejl');
  end;

end;

procedure TfrmRowaApp.CliAppAfterProcessReply(Sender: TObject;
  var CmdBuf: PAnsiChar; var CmdLen: Integer);
begin
  CliApp.Tag := 0;

end;

procedure TfrmRowaApp.Button2Click(Sender: TObject);
var
  Result : integer;
  str : string;
begin
    CliApp.FunctionCode := 'KRequest';
    CliApp.Request.Rewrite;
    str := '';
    CliApp.Request.WriteFields(TRUE,[str]);
    Result := WaitAnswer (10);
    C2LogAdd('Result in Button2 Click is ' + IntToStr(Result));
//    if Result = 0 then begin
//      Result := StrToInt (BuffApp.Fields[0]);
//    end;

end;

procedure TfrmRowaApp.FormCreate(Sender: TObject);
begin
  CliApp.Server := C2StrPrm(StamForm.RobotSection,'AppAdresse','127.0.0.1');
  CliApp.Port := C2StrPrm(StamForm.RobotSection,'AppPort','2112');
  FCloseConnection := CompareText(C2StrPrm(C2SysUserName,'CloseSocketConnections','JA'),'JA') = 0;
end;

procedure TfrmRowaApp.RowaSendARequest(varenr: string; Antal: integer);
var
  Result : integer;
  str : string;
begin
    CliApp.FunctionCode := 'ARequest';
    CliApp.Request.Rewrite;
    str := Format('%-20s %-6s %4.4d',[C2SysUserName,Varenr,Antal]);
    CliApp.Request.WriteFields(TRUE,[str]);
    Result := WaitAnswer (10);
    C2LogAdd('RowaSendARequest : result : ' + inttostr(Result));;
end;

procedure TfrmRowaApp.RowaSendAXRequest(sl : TStringList;RobotUdtag: string);
var
  W: string;
  Result : integer;
  stream : TMemoryStream;
begin
  stream := TMemoryStream.Create;
  try
    CliApp.FunctionCode := 'AXRequest';
    CliApp.Request.Rewrite;
    W:= Format('%-20s%-3s',[C2SysUserName,RobotUdtag]);
    CliApp.Request.WriteFields(TRUE,[W]);
    sl.SaveToStream(stream);
    stream.Seek(0,0);
    CliApp.Request.WriteStreamField(FALSE,mwBlob,stream);
    Result:= WaitAnswer(10);
    C2LogAdd('RowaSendAXRequest : result : ' + inttostr(Result));;
  finally
    stream.Free;
  end;
end;


procedure TfrmRowaApp.TimAppTimer(Sender: TObject);
begin
  (Sender as TTimer).Enabled := False;
end;

end.
