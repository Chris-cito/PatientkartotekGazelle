unit SMSDMu;

interface

uses
  SysUtils, Classes, DBXDataSnap, DBXCommon, DB, DBClient, DSConnect, SqlExpr,DateUtils,
  nxdb, IPPeerClient;

type
  TSMSDM = class(TDataModule)
    SQLConnection1: TSQLConnection;
    DSProviderConnection1: TDSProviderConnection;
    ClientDataSet1: TClientDataSet;
    nxQuery1: TnxQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SendKontrolSMS;
  end;

var
  SMSDM: TSMSDM;

implementation

uses DM, C2MainLog, uSMSMethods,ChkBoxes;

{$R *.dfm}

{ TSMSDM }

procedure TSMSDM.DataModuleCreate(Sender: TObject);
begin
  SQLConnection1.Params.Values['HostName'] := C2StrPrm('SMS','Server','');
  nxQuery1.Session := MainDm.nxSess;
  nxQuery1.AliasName := 'Produktion';
end;

procedure TSMSDM.SendKontrolSMS;
var
  Temp: TServerMethods1Client;
  memmess : TStringList;
  counter : integer;
  function formatmobilnr : string;
  begin
    // remove space from number
    result := StringReplace(nxQuery1.FieldByName('Mobil').AsString,' ','',[rfReplaceAll]);
    if pos('+',Result) = 0 then
      result := '+45' + Result;

  end;

  function RecentMessageSent(CPRNr:string) : boolean;
  begin
    Result := False;
    with ClientDataSet1 do
    begin
      Filter := 'kundenr=''' + CPRNR + '''';
      Filtered := true;
      Open;
      try
        if RecordCount = 0 then
          exit;
        First;
        while not Eof do
        begin
          if pos('Der er medicin klar til afhentning.',FieldByName('Message').AsString) = 0 then
          begin
            Next;
            Continue;
          end;
          if FieldByName('SendTime').AsDateTime > IncMinute(Now,-60)  then
          begin
            Result := true;
            break;
          end;
          Next;
        end;


      finally
        ClientDataSet1.Close;
      end;
    end;
  end;
begin
  c2logadd('in sendsms  ');
  nxQuery1.SQL.clear;
  nxQuery1.SQL.add('select distinct pat.kundenr,pat.mobil');
  nxQuery1.SQL.add('from patientkartotek as pat');
  nxQuery1.SQL.add('inner join');
  nxQuery1.SQL.add('(');
  nxQuery1.SQL.add('select kundenr,brugerkontrol,kontrolfejl,afsluttetdato from EKSPEDITIONER where afsluttetdato is null');
  nxQuery1.SQL.add(')');
  nxQuery1.SQL.add('as eks on eks.kundenr=pat.kundenr');
  nxQuery1.SQL.add('and eks.brugerkontrol<>0 and eks.kontrolfejl=0 and pat.kundetype=1');
  nxQuery1.SQL.add('and pat.mobil is not null');
  nxQuery1.Open;
  try

    if nxQuery1.RecordCount = 0 then
    begin
      ChkBoxOK('Der er ikke fundet kunder med mobiltelefonnr at sende besked til.');
    end;
    counter := 0;
    nxQuery1.First;
    while not nxQuery1.Eof do
    begin

      if RecentMessageSent(nxQuery1.FieldByName('Kundenr').AsString) then
      begin
        nxQuery1.Next;
        Continue;
      end;

      c2logadd('no recent message so ok to send');
      try

        SQLConnection1.Open;
      except
        on e : exception do
        begin
          C2LogAdd('SMS service er ikke startet. Kontakt Cito');
          exit;
        end;

      end;
      memmess := TStringList.Create;
      Temp := TServerMethods1Client.Create(SQLConnection1.DBXConnection);
      try
        memmess.Add('Der er medicin klar til afhentning.');
        memMess.Add('');
        memMess.Add('Mvh Apoteket');
        memMess.Add('Sms kan ikke besvares');
        C2LogAdd('about to send the message ' + memmess.Text);
        try
          if Temp.AddSMS( nxQuery1.FieldByName('Kundenr').AsString,
                          formatmobilnr,'Apotek',
                          memMess.Text,
                          Now) then
            inc(counter);

        except
          on E: Exception do
            C2LogAdd(e.Message);
        end;

      finally
        Temp.Free;
        memmess.Free;
        SQLConnection1.Close;
      end;
      nxQuery1.Next;
    end;

    if counter <> 0 then
      ChkBoxOK('SMSer er blevet sendt.')
    else
      ChkBoxOK('Der er ikke fundet kunder med mobiltelefonnr at sende besked til.');



  finally

    nxQuery1.Close;
    c2logadd('end of send sms');

  end;

end;

end.
