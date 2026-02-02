unit uNomStk;

{ Developed by: Cito IT A/S

  Description:

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  17-06-2022/cjs  Corrections for new reservation screen in line with Lagerkartotek

  03-06-2022/cjs  Correction to nomeco stock screen to open the lagerkartotek table

  31-05-2022/cjs  Corrected the checked product in Grossist reservation screen and added packsize

  31-05-2022/cjs  Changed the Grossist reservation screen to allow only one item to be selected

  31-03-2022/cjs  Corrected access violation error if no products returned in grossist reservation screen

  05-05-2020/cjs  removed unused variables

  14-08-2019/cjs  Replace in with = in subsdtitution sql which is now embedded in nomstk routine

  14-11-2016/RP   Fixed error, where program would stall if Lageropslag failed.
  07-09-2016/RP   Set warnings to off. Chris needs to review and fix.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPC, ComCtrls,
  DB, nxdb, generics.collections, json, REST.Client, REST.Types,
  REST.Authenticator.OAuth,
  IPPeerClient, REST.Authenticator.Basic, msxml, OverbyteIcsWndControl,
  OverbyteIcsWSocket;

type
  TfrmNomecoStk = class(TForm)
    WSocket1: TWSocket;
    Timer1: TTimer;
    ListView1: TListView;
    nxLag: TnxTable;
    nxLagNavn: TStringField;
    nxLagForm: TStringField;
    nxLagStyrke: TStringField;
    nxLagPakning: TStringField;
    nxLagLager: TWordField;
    nxLagVareNr: TStringField;
    nxQuery1: TnxQuery;
    nxLagAntal: TIntegerField;
    nxLagSubKode: TStringField;
    nxLagSalgsPris: TCurrencyField;
    nxLagBGP: TCurrencyField;
    nxLagSSKode: TStringField;
    nxLagEnhedsPris: TCurrencyField;
    nxLagEgenPris: TCurrencyField;
    nxLagPaknNum: TIntegerField;
    nxLagSubEnhPris: TCurrencyField;
    btnSearch: TButton;
    btnVaelg: TButton;
    procedure btnSearchClick(Sender: TObject);
    procedure WSocket1SessionConnected(Sender: TObject; ErrCode: Word);
    procedure WSocket1DataSent(Sender: TObject; ErrCode: Word);
    procedure Timer1Timer(Sender: TObject);
    procedure WSocket1DataAvailable(Sender: TObject; ErrCode: Word);
    procedure WSocket1Error(Sender: TObject);
    procedure WSocket1BgException(Sender: TObject; E: Exception; var CanClose: Boolean);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure ListView1CustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure ListView1CustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btnVaelgClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ListView1ItemChecked(Sender: TObject; Item: TListItem);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    SocketError: Integer;
    Buffer: array [0 .. 5000] of AnsiChar;
    recvstr: ansistring;
    SelectedVare: STRING;
    FLager: integer;
    FVarenr: string;
    StartUpMode : boolean;
    procedure process_string(instr: ansistring);
    procedure SetLager(const Value: integer);
    procedure SetVarenr(const Value: string);
    property Lager : integer read FLager write SetLager;
    property Varenr : string read FVarenr write SetVarenr;
  public
    { Public declarations }
    class function ShowNomecoStk(ALager: Integer; AVarenr: string): string;
  end;

const { ***************************************************************************** }
  { * EBCDIC to ASCII                                                           * }
  { ***************************************************************************** }

  EtoA: array [0 .. 255] of Word = ($00, $01, $02, $03, $04, $05, $06, $07, { 00 }
    $08, $09, $0A, $0B, $0C, $0D, $0E, $0F, { 08 }
    $10, $11, $12, $13, $14, $15, $16, $17, { 10 }
    $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, { 18 }
    $20, $21, $22, $23, $24, $25, $26, $27, { 20 }
    $28, $29, $2A, $2B, $2C, $2D, $2E, $2F, { 28 }
    $30, $31, $32, $33, $34, $35, $36, $37, { 30 }
    $38, $39, $3A, $3B, $3C, $3D, $3E, $3F, { 38 }
    $20, $FF, $83, $84, $85, $A0, $C6, $86, { 40 }
    $87, $A4, $5B, $2E, $3C, $28, $2B, $21, { 48 }
    $26, $82, $88, $89, $8A, $A1, $8C, $8B, { 50 }
    $8D, $E1, $5D, $24, $2A, $29, $3B, $5E, { 58 }
    $2D, $2F, $B6, $8E, $B7, $B5, $C7, $8F, { 60 }
    $80, $A5, $DD, $2C, $25, $5F, $3E, $3F, { 68 }
    $9B, $90, $D2, $D3, $D4, $D6, $D7, $D8, { 70 }
    $DE, $60, $3A, $23, $40, $27, $3D, $22, { 78 }
    $9D, $61, $62, $63, $64, $65, $66, $67, { 80 }
    $68, $69, $AE, $AF, $D0, $EC, $E8, $F1, { 88 }
    $F8, $6A, $6B, $6C, $6D, $6E, $6F, $70, { 90 }
    $71, $72, $A6, $A7, $91, $F7, $92, $CF, { 98 }
    $E6, $7E, $73, $74, $75, $76, $77, $78, { A0 }
    $79, $7A, $AD, $A8, $D1, $ED, $E7, $A9, { A8 }
    $BD, $9C, $BE, $FA, $9F, $F5, $F4, $AC, { B0 }
    $AB, $F3, $AA, $7C, $EE, $F9, $EF, $F2, { B8 }
    $7B, $41, $42, $43, $44, $45, $46, $47, { C0 }
    $48, $49, $F0, $93, $94, $95, $A2, $E4, { C8 }
    $7D, $4A, $4B, $4C, $4D, $4E, $4F, $50, { D0 }
    $51, $52, $D5, $96, $81, $97, $A3, $98, { D8 }
    $5C, $E1, $53, $54, $55, $56, $57, $58, { E0 }
    $59, $5A, $FD, $E2, $99, $E3, $E0, $E5, { E8 }
    $30, $31, $32, $33, $34, $35, $36, $37, { F0 }
    $38, $39, $FC, $EA, $9A, $EB, $E9, $FF); { F8 }

  { ***************************************************************************** }
  { * ASCII to EBCDIC                                                           * }
  { ***************************************************************************** }

  AtoE: array [0 .. 255] of Word = ($00, $01, $02, $03, $04, $05, $06, $07, { 00 }
    $08, $09, $0A, $0B, $0C, $0D, $0E, $0F, { 08 }
    $10, $11, $12, $13, $B6, $B5, $16, $17, { 10 }
    $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, { 18 }
    $40, $4F, $7F, $7B, $5B, $6C, $50, $7D, { 20 }
    $4D, $5D, $5C, $4E, $6B, $60, $4B, $61, { 28 }
    $F0, $F1, $F2, $F3, $F4, $F5, $F6, $F7, { 30 }
    $F8, $F9, $7A, $5E, $4C, $7E, $6E, $6F, { 38 }
    $7C, $C1, $C2, $C3, $C4, $C5, $C6, $C7, { 40 }
    $C8, $C9, $D1, $D2, $D3, $D4, $D5, $D6, { 48 }
    $D7, $D8, $D9, $E2, $E3, $E4, $E5, $E6, { 50 }
    $E7, $E8, $E9, $4A, $E0, $5A, $5F, $6D, { 58 }
    $79, $81, $82, $83, $84, $85, $86, $87, { 60 }
    $88, $89, $91, $92, $93, $94, $95, $96, { 68 }
    $97, $98, $99, $A2, $A3, $A4, $A5, $A6, { 70 }
    $A7, $A8, $A9, $C0, $BB, $D0, $A1, $41, { 78 }
    $68, $DC, $51, $42, $43, $44, $47, $48, { 80 }
    $52, $53, $54, $57, $56, $58, $63, $67, { 88 }
    $71, $9C, $9E, $CB, $CC, $CD, $DB, $DD, { 90 }
    $DF, $EC, $FC, $70, $B1, $80, $41, $B4, { 98 }
    $45, $55, $CE, $DE, $49, $69, $9A, $9B, { A0 }
    $AB, $AF, $BA, $B8, $B7, $AA, $8A, $8B, { A8 }
    $41, $41, $41, $41, $41, $65, $62, $64, { B0 }
    $41, $41, $41, $41, $41, $B0, $B2, $41, { B8 }
    $41, $41, $41, $41, $41, $41, $46, $66, { C0 }
    $41, $41, $41, $41, $41, $41, $41, $9F, { C8 }
    $08, $AC, $72, $73, $74, $DA, $75, $76, { D0 }
    $77, $41, $41, $41, $41, $6A, $78, $41, { D8 }
    $EE, $59, $EB, $ED, $CF, $EF, $A0, $AE, { E0 }
    $8E, $FE, $FB, $FD, $8D, $AD, $BC, $BE, { E8 }
    $CA, $8F, $BF, $B9, $B6, $B5, $41, $9D, { F0 }
    $90, $BD, $B3, $41, $FA, $EA, $FE, $41); { F8 }


implementation

{$WARN IMPLICIT_STRING_CAST off}
{$WARN IMPLICIT_STRING_CAST_LOSS off}

uses C2MainLog, dm, ChkBoxes,uc2ui.procs;


{$R *.dfm}

function ToAscii(StrObj: ansistring; Len: Integer): ansistring;
var
  i: Integer;
  tmpstr: ansistring;
  ascn: Integer;
begin
  tmpstr := '';
  for i := 1 to Len do
  begin
    ascn := Ord(StrObj[i]);
    case ascn of
      $C0:
        tmpstr := tmpstr + 'æ';
      $7B:
        tmpstr := tmpstr + 'Æ';
      $6A:
        tmpstr := tmpstr + 'ø';
      $7C:
        tmpstr := tmpstr + 'Ø';
      $D0:
        tmpstr := tmpstr + 'å';
      $5B:
        tmpstr := tmpstr + 'Å';
    else
      tmpstr := tmpstr + Chr(EtoA[ascn]);
    end;
  end;
  Result := tmpstr;
end;

function ToEbcdic(StrObj: ansistring; Len: Integer): ansistring;
var
  i: Integer;
  tmpstr: ansistring;
  ascn: Integer;
begin
  tmpstr := '';
  for i := 1 to Len do
  begin
    ascn := Ord(StrObj[i]);
    tmpstr := tmpstr + Chr(AtoE[ascn]);
  end;
  Result := tmpstr;
end;

procedure TfrmNomecoStk.btnSearchClick(Sender: TObject);
var
  sl: TStringList;
  save_cursor: TCursor;
  strVarernr: string;

  procedure CallTMJWebservice;
  var
    json: TJSONObject;
    req: TRESTRequest;
    cli: TRESTClient;
    res: TRESTResponse;
    logsl: TStringList;
    HTTPBasicAuthenticator1: THTTPBasicAuthenticator;
    tempVareNr: string;
    VareListItem: TListItem;
    ftmp: Currency;
    ReturnedVareNr: String;
    ReturnedOnStock: string;
    ReturnedWorstExpiryDate: string;
    ReturnedPhoneUS: string;
    ReturnedRemark: string;
    Antal: Integer;
    j, k: Integer;
    doc: DOMDocument;
    nodelist, HeaderNode: IXMLDOMNodeList;

  begin
    json := TJSONObject.Create;
    req := TRESTRequest.Create(Nil);
    // Test address
    // cli := TRESTClient.Create('https://webplus01.test.tmj.dk/odata/V1/ProductStockInfos/');
    cli := TRESTClient.Create('https://webplus.tmj.dk/odata/V1/ProductStockInfos/');
    res := TRESTResponse.Create(Nil);
    logsl := TStringList.Create;
    try
      try
        cli.ContentType := 'application/xml';
        req.Client := cli;

        // Build request
        req.Resource := 'GetProductStockInfos(AccountNumber=' + MainDm.fqKto.FieldByName('Kontonr').AsString +
          ')?$format=xml';
        req.Response := res;
        req.Method := rmPOST;
        req.AutoCreateParams := False;
        C2Logadd('full req URL: ' + req.GetFullRequestURL(true));

        // Add Authenticator
        HTTPBasicAuthenticator1 := THTTPBasicAuthenticator.Create(Self);
        with HTTPBasicAuthenticator1 do
        begin
          Name := 'HTTPBasicAuthenticator1';
          Username := 'svc@citodata';
          // Test password
          // Password := 'r$tMgYWRkaXR33hbC$7iMjVoYk4CcGJtWnSa2FYUj';
          Password := 'UBwC5lthTYWxac0Fj$sWGJteGxC0!pDRS$XV3WfxbQW$3';
        end;
        cli.Authenticator := HTTPBasicAuthenticator1;

        // Insert Varenr into body
        req.ClearBody;
        req.AddBody('<ArrayOfstring xmlns:i="http://www.w3.org/2001/XMLSchema-instance" ' +
          'xmlns="http://schemas.microsoft.com/2003/10/Serialization/Arrays">', ctAPPLICATION_XML);
        for tempVareNr in sl do
        begin
          req.AddBody('<string>' + tempVareNr + '</string>', ctAPPLICATION_XML);
        end;
        req.AddBody('</ArrayOfstring>', ctAPPLICATION_XML);
        C2Logadd('req.tostring: ' + req.ToString);
        req.Execute;

        C2Logadd(res.Content);
        C2Logadd('Success : ' + inttostr(res.StatusCode));

        // Handle result data

        doc := CoDOMDocument.Create;
        doc.loadXML(res.Content);
        nodelist := doc.documentElement.childNodes;
        if nodelist.length > 0 then
        begin
          for j := 0 to nodelist.length - 1 do
          begin
            if nodelist[j].nodeName = 'ProductStockInfo' then
            begin
              HeaderNode := nodelist[j].childNodes;
              for k := 0 to HeaderNode.length - 1 do
              begin
                if HeaderNode[k].nodeName = 'ItemId' then
                begin
                  ReturnedVareNr := HeaderNode[k].text;
                end;
                if HeaderNode[k].nodeName = 'OnStock' then
                begin
                  ReturnedOnStock := HeaderNode[k].text;
                end;
                if HeaderNode[k].nodeName = 'WorstExpiryDate' then
                begin
                  ReturnedWorstExpiryDate := HeaderNode[k].text;
                end;
                if HeaderNode[k].nodeName = 'PhoneUS' then
                begin
                  ReturnedPhoneUS := HeaderNode[k].text;
                end;
                if HeaderNode[k].nodeName = 'Remark' then
                begin
                  ReturnedRemark := HeaderNode[k].text;
                end;
              end;
              VareListItem := ListView1.Items.Add;
              VareListItem.Caption := ReturnedVareNr;
              VareListItem.Checked := False;
              TryStrToInt(ReturnedOnStock, Antal);
              if VareListItem.Caption = Varenr then
              begin
                if Antal > 0 then
                  VareListItem.Checked := true

              end;
              VareListItem.SubItems.Add(inttostr(Antal));
              nxLag.IndexName := 'NrOrden';
              if nxLag.FindKey([lager, ReturnedVareNr]) then
              begin
                VareListItem.SubItems.Add(nxLagAntal.AsString);
                VareListItem.SubItems.Add(nxLagNavn.AsString);
                VareListItem.SubItems.Add(nxLagForm.AsString);
                VareListItem.SubItems.Add(nxLagStyrke.AsString);
                VareListItem.SubItems.Add(nxLagPakning.AsString);
                VareListItem.SubItems.Add(nxLagSubKode.AsString);
                if pos(nxLagSubKode.AsString, 'BC') <> 0 then
                begin
                  if pos(nxLagSSKode.AsString, 'ASV') <> 0 then
                  begin
                    if nxLagSalgsPris.AsCurrency = nxLagBGP.AsCurrency then
                      VareListItem.SubItems.Add('*')
                    else
                      VareListItem.SubItems.Add('');
                  end
                  else
                    VareListItem.SubItems.Add('');
                end
                else
                  VareListItem.SubItems.Add('');
                C2Logadd('egenpris is ' + nxLagEgenPris.AsString);
                C2Logadd('subenhpris is ' + nxLagSubEnhPris.AsString);
                C2Logadd('paknnum is ' + nxLagPaknNum.AsString);

                if nxLagEgenPris.AsCurrency <> 0 then
                begin
                  if nxLagPaknNum.AsInteger = 0 then
                    VareListItem.SubItems.Add(Format('%8.2f', [nxLagSubEnhPris.AsCurrency]))
                  else
                  begin
                    ftmp := nxLagEgenPris.AsCurrency / (nxLagPaknNum.AsCurrency / 100);
                    VareListItem.SubItems.Add(Format('%8.2f', [ftmp]));
                  end;
                end
                else
                  VareListItem.SubItems.Add(Format('%8.2f', [nxLagSubEnhPris.AsCurrency]));

              end
              else
              begin
                VareListItem.SubItems.Add('');
                VareListItem.SubItems.Add('ingen vare');
                VareListItem.SubItems.Add('');
                VareListItem.SubItems.Add('');
                VareListItem.SubItems.Add('');
                VareListItem.SubItems.Add('');
                VareListItem.SubItems.Add('');
                VareListItem.SubItems.Add('');
              end;

              VareListItem.SubItems.Add(copy(ReturnedWorstExpiryDate, 1, 10));
              VareListItem.SubItems.Add(ReturnedPhoneUS);
              VareListItem.SubItems.Add(ReturnedRemark);
            end;
          end;
        end;
        StartUpMode := False;
      except
        on E: Exception do
        begin
          C2Logadd(res.Content);
          ShowMessage(E.Message);
          C2Logadd('Exception : ' + E.Message);
        end;
      end;
    finally
      json.Free;
      req.Free;
      res.Free;
      cli.Free;
      logsl.Free;
    end;
  end;

{
  procedure CallSocketService;
  var
  str1 : AnsiString;
  sendstr : AnsiString;
  begin
  sendstr := '0000' + 'NOLAGFOR  ' + dmMain.fqKto.FieldByName('Kontonr').AsString;
  for str1 in sl do
  sendstr := sendstr + str1;
  sendstr := sendstr + StringOfChar(' ',4096-length(sendstr));
  C2LogAdd('length of sendstr is ' + IntToStr(length(sendstr)));
  sendstr := ToEbcdic(sendstr,4096);
  SocketError := 0;
  WSocket1.Addr := dmMain.fqKto.FieldByName('VisVareHost').AsString;
  WSocket1.Port := dmMain.fqKto.FieldByName('VisVarePort').AsString;;
  WSocket1.Proto :='tcp';
  Timer1.Enabled := True;
  try
  WSocket1.Connect;
  while (WSocket1.State  in [wsConnecting]) and (SocketError =0) do
  Application.ProcessMessages;
  recvstr := '';
  if SocketError = 1 then begin
  ModalResult := mrCancel;
  exit;
  end;
  if WSocket1.State = wsConnected then begin
  C2LogAdd('Connected');
  WSocket1.SendStr(sendstr);
  while WSocket1.State = wsConnected do
  Application.ProcessMessages;
  end;
  finally
  Timer1.Enabled := False;
  end;
  end; }

  procedure CallSocketService;
  var
    str1: ansistring;
    sendstr: ansistring;
  begin
    sendstr := '0000' + 'NOLAGFOR  ' + MainDm.fqKto.FieldByName('Kontonr').AsString;
    for str1 in sl do
      sendstr := sendstr + str1;
    sendstr := sendstr + StringOfChar(' ', 4096 - length(sendstr));
    C2Logadd('length of sendstr is ' + inttostr(length(sendstr)));
    sendstr := ToEbcdic(sendstr, 4096);
    SocketError := 0;
    WSocket1.Addr := MainDm.fqKto.FieldByName('VisVareHost').AsString;
    WSocket1.Port := MainDm.fqKto.FieldByName('VisVarePort').AsString;;
    WSocket1.Proto := 'tcp';
    Timer1.Enabled := true;
    try
      WSocket1.Connect;
      while (WSocket1.State in [wsConnecting]) and (SocketError = 0) do
        Application.ProcessMessages;
      recvstr := '';
      if SocketError = 1 then
      begin
        ModalResult := mrCancel;
        exit;
      end;
      if WSocket1.State = wsConnected then
      begin
        C2Logadd('Connected');
        WSocket1.sendstr(sendstr);
        while (WSocket1.State = wsConnected) and (SocketError = 0) do
          Application.ProcessMessages;

        if SocketError = 1 then
        begin
          ModalResult := mrCancel;
          exit;
        end;
      end;
    finally
      Timer1.Enabled := False;
    end;
  end;

  procedure send_buffer;
  begin
    if MainDm.fqKto.FieldByName('GrOplNr').AsInteger = 2 then
      CallTMJWebservice
    else
      CallSocketService;
  end;

begin
  sl := TStringList.Create;
  save_cursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  btnSearch.Enabled := False;
  nxLag.Open;
  try
    ListView1.SortType := stNone;
    ListView1.Items.Clear;
    sl.Add(Varenr + StringOfChar(' ', 43));
    nxquery1.SQL.Clear;
    nxquery1.SQL.Add('declare RcpGebyr money;');
    nxquery1.SQL.Add('Set RcpGebyr=(select RcpGebyr from recepturOplysninger);');

    nxquery1.SQL.Add('SELECT');
    nxquery1.SQL.Add('	S.VareNr,');
    nxquery1.SQL.Add('  	S.Subnr,');
    nxquery1.SQL.Add('	(case when s.antpkn = 0');
    nxquery1.SQL.Add('		THEN');
    nxquery1.SQL.Add('	  		V.SubKode');
    nxquery1.SQL.Add('		ELSE');
    nxquery1.SQL.Add('			''(''+v.subkode+'')''');
    nxquery1.SQL.Add('	END) AS Kode,');
    nxquery1.SQL.Add('  	(CASE WHEN V.SletDato IS NULL THEN '''' ELSE ''*'' END) AS MU,');
    nxquery1.SQL.Add('	V.Navn,');
    nxquery1.SQL.Add('  	V.Form,');
    nxquery1.SQL.Add('  	V.Styrke,');
    nxquery1.SQL.Add('  	V.Pakning,');
    nxquery1.SQL.Add('	V.GrLevSvigtDato,');
    nxquery1.SQL.Add('	V.NySubKode,');
    nxquery1.SQL.Add('	(case when s.antpkn = 0');
    nxquery1.SQL.Add('		THEN');
    nxquery1.SQL.Add('	  		V.PaKode');
    nxquery1.SQL.Add('		ELSE');
    nxquery1.SQL.Add('			'' ''');
    nxquery1.SQL.Add('	END) AS PI,');
    nxquery1.SQL.Add('  	COALESCE(V.Antal, 0) AS Antal,');
    nxquery1.SQL.Add('  	V.SubForvalg AS Forvalg,');
    nxquery1.SQL.Add('  	(case when v.egenpris<>0');
    nxquery1.SQL.Add('		THEN');
    nxquery1.SQL.Add('			(case WHEN V.Paknnum = 0');
    nxquery1.SQL.Add('			then');
    nxquery1.SQL.Add('				v.SUBENHpris');
    nxquery1.SQL.Add('			ELSE');
    nxquery1.SQL.Add('				((V.EGENPRIS+RcpGebyr)/(V.PaknNum/100.0))');
    nxquery1.SQL.Add('			END)');

    nxquery1.SQL.Add('		ELSE V.SubEnhPris');
    nxquery1.SQL.Add('	END) as EnhedsPris,');
    nxquery1.SQL.Add('	(CASE WHEN S.antpkn = 0 THEN');
    nxquery1.SQL.Add('	  	(CASE WHEN V.HaType<>''''');
    nxquery1.SQL.Add('	   		THEN');
    nxquery1.SQL.Add('	   			(CASE WHEN V.EgenPris<>0');
    nxquery1.SQL.Add('    					THEN V.Egenpris + RcpGebyr');
    nxquery1.SQL.Add('    					ELSE V.Salgspris + RcpGebyr');
    nxquery1.SQL.Add('    				END)');
    nxquery1.SQL.Add('   			ELSE');
    nxquery1.SQL.Add('   				(CASE WHEN V.EgenPris<>0');
    nxquery1.SQL.Add('    					THEN V.Egenpris');
    nxquery1.SQL.Add('    					ELSE V.Salgspris');
    nxquery1.SQL.Add('    				END)');
    nxquery1.SQL.Add('		END)');
    nxquery1.SQL.Add('	ELSE');
    nxquery1.SQL.Add('		cast((s.LMS32Salgspris / 100.0) as money)');
    nxquery1.SQL.Add('   	END) AS SalgsPris,');
    nxquery1.SQL.Add('   	(case when s.antpkn = 0 then 1 else s.antpkn end) as antpkn,');
    nxquery1.SQL.Add('	(case 	when v.minimum=-1 and v.genbestil=1 then ''-''');
    nxquery1.SQL.Add('		when v.minimum>=0 and v.genbestil>0 then ''+''');
    nxquery1.SQL.Add('		else ''''');
    nxquery1.SQL.Add('   	end) as skaffe,');
    nxquery1.SQL.Add('	(CASE WHEN V.RESTORDRE <> 0 THEN ''RO'' ELSE '''' END) AS RO,');
    nxquery1.SQL.Add('	v.lokation1,');
    nxquery1.SQL.Add('	(case when ((V.subkode=''C'') or (V.subkode=''B'')) and v.sskode in (''A'',''R'',''S'',''V'') AND V.salgspris=V.BGP then');
    nxquery1.SQL.Add('		''*''');
    nxquery1.SQL.Add('	else');
    nxquery1.SQL.Add('		'' ''');
    nxquery1.SQL.Add('	END) AS CTilsk,');
    nxquery1.SQL.Add('	v.doegnet');



    nxquery1.SQL.Add('FROM');
    nxquery1.SQL.Add('(');
    nxquery1.SQL.Add('	select * from LagerSubstListe');
    nxquery1.SQL.Add('where varenr = ''' + Varenr + '''' );

    nxquery1.SQL.Add(') AS S');
    nxquery1.SQL.Add('inner join LagerKartotek AS V on');
    nxquery1.SQL.Add('	V.VareNr=S.SubNr and');
    nxquery1.SQL.Add('	V.Lager=:lager');
    nxquery1.SQL.Add('WHERE');
    nxquery1.SQL.Add('	(V.SLETDATO IS NULL or (V.SLETDATO IS NOT NULL and v.antal>0)) and');
    nxquery1.SQL.Add('  	V.AfmDato IS NULL');
    nxquery1.SQL.Add('ORDER BY');
    nxquery1.SQL.Add('  	S.VareNr,');
    nxquery1.SQL.Add('  	EnhedsPris ASC,');
    nxquery1.SQL.Add('	Salgspris ASC,');
    nxquery1.SQL.Add('	Kode ASC,');
    nxquery1.SQL.Add('  	V.PaKode ASC');
//    C2Logadd(nxquery1.SQL.Text);

            // Parametre
    nxquery1.ParamByName('lager').AsInteger := lager;
    nxQuery1.Open;

    if nxQuery1.RecordCount = 0 then
    begin
      ModalResult := mrCancel;
      exit;
    end;
    nxQuery1.First;
    while not nxQuery1.Eof do
    begin
      strVarernr := nxQuery1.FieldByName('Subnr').AsString + StringOfChar(' ', 43);
      if (sl.IndexOf(strVarernr) = -1) and (nxQuery1.FieldByName('Subnr').AsString <> Varenr) then
        sl.Add(strVarernr);
      if sl.Count = 50 then
      begin
        send_buffer;
        sl.Clear;

      end;
      nxQuery1.Next;
    end;
    if sl.Count <> 0 then
      send_buffer;

    ListView1.SortType := stData;
    if ListView1.Items.Count = 1 then
      ModalResult := mrCancel;

  finally
    sl.Free;
    Screen.Cursor := save_cursor;
    Timer1.Enabled := False;
    nxLag.Close;
    nxQuery1.Close;
    btnSearch.Enabled := true;
    if ListView1.Items.Count <> 0 then
    begin
      ListView1.ItemIndex := 0;
      ListView1.SetFocus;
    end;
  end;

end;

procedure TfrmNomecoStk.btnVaelgClick(Sender: TObject);
var
  ll: TListItem;
  icnt: Integer;
begin
  icnt := 0;
  SelectedVare := '';
  for ll in ListView1.Items do
  begin
    if ll.Checked then
    begin
      SelectedVare := ll.Caption;
      icnt := icnt + 1;
      if icnt <> 1 then
        break;
    end;
  end;
  if icnt <> 1 then
  begin
    ModalResult := mrNone;
    ChkBoxOK('Der skal vælger et (og kun et) varenummer');
    exit;
  end;
  ModalResult := mrOk;
end;

procedure TfrmNomecoStk.FormCreate(Sender: TObject);
begin
  nxQuery1.Database := MainDm.nxdb;
  nxLag.Database := MainDm.nxdb;
  nxLag.Open;
end;

procedure TfrmNomecoStk.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    ModalResult := mrCancel;
  if Key = #13 then
    btnVaelg.Click;
end;

procedure TfrmNomecoStk.FormShow(Sender: TObject);
begin
  PostMessage(btnSearch.Handle, WM_LBUTTONDOWN, 0, 0);
  PostMessage(btnSearch.Handle, WM_LBUTTONUP, 0, 0);
end;

procedure TfrmNomecoStk.ListView1Compare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  qu1, qu2: Integer;
begin
  Compare := 0;
  if (Item1 = Nil) or (Item2 = Nil) then
    exit;
  qu1 := StrToIntDef(Item1.SubItems[0], -1);
  qu2 := StrToIntDef(Item2.SubItems[0], -1);
  if Item1.Caption = Varenr then
    qu1 := 1000000;
  if Item2.Caption = Varenr then
    qu2 := 1000000;
  Compare := qu2 - qu1;
end;

procedure TfrmNomecoStk.ListView1CustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  itst: Integer;
begin
  ListView1.Canvas.Brush.Color := clWindow;
  if Item.Caption = Varenr then
  begin
    if TryStrToInt(Item.SubItems[0], itst) then
    begin
      if itst > 0 then
        ListView1.Canvas.Brush.Color := clLime
      else
        ListView1.Canvas.Brush.Color := clRed;
    end;
  end;
end;

procedure TfrmNomecoStk.ListView1CustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  DefaultDraw := true;
  if Item.Caption = Varenr then
    exit;
  ListView1.Canvas.Brush.Color := clWindow;
  if SubItem = 8 then
  begin
    if trim(Item.SubItems[7]) <> '' then
      ListView1.Canvas.Brush.Color := clYellow;
  end;
end;

procedure TfrmNomecoStk.ListView1ItemChecked(Sender: TObject; Item: TListItem);
var
  ll : TListItem;
begin

  if StartUpMode then
    exit;

  // clear all check marks first
  for ll in ListView1.Items do
    ll.Checked := False;

  // now set the checkmark on the current item
  Item.Checked := True;

end;

procedure TfrmNomecoStk.process_string(instr: ansistring);
var
  ll: TListItem;
  itst: Integer;
  strvarenr: string;
  ftmp: Currency;
begin
  delete(instr, 1, 20);
  C2Logadd(instr);
  while true do
  begin
    try
      if trim(copy(instr, 1, 49)) = '' then
        break;
      if not TryStrToInt(copy(instr, 7, 6), itst) then
        itst := -1;
      if (itst = -1) and (copy(instr, 1, 6) <> Varenr) then
        continue;
      ll := ListView1.Items.Add;
      ll.Caption := copy(instr, 1, 6);
      ll.Checked := False;
      if ll.Caption = Varenr then
      begin
        if itst > 0 then
          ll.Checked := true
      end;
      ll.SubItems.Add(inttostr(itst));
      nxLag.IndexName := 'NrOrden';
      strvarenr := copy(instr, 1, 6);
      try
        if nxLag.FindKey([lager, strvarenr]) then
        begin
          ll.SubItems.Add(nxLagAntal.AsString);
          ll.SubItems.Add(nxLagNavn.AsString);
          ll.SubItems.Add(nxLagForm.AsString);
          ll.SubItems.Add(nxLagStyrke.AsString);
          ll.SubItems.Add(nxLagPakning.AsString);
          ll.SubItems.Add(nxLagSubKode.AsString);
          if pos(nxLagSubKode.AsString, 'BC') <> 0 then
          begin
            if pos(nxLagSSKode.AsString, 'ASV') <> 0 then
            begin
              if nxLagSalgsPris.AsCurrency = nxLagBGP.AsCurrency then
                ll.SubItems.Add('*')
              else
                ll.SubItems.Add('');
            end
            else
              ll.SubItems.Add('');
          end
          else
            ll.SubItems.Add('');
          C2Logadd('egenpris is ' + nxLagEgenPris.AsString);
          C2Logadd('subenhpris is ' + nxLagSubEnhPris.AsString);
          C2Logadd('paknnum is ' + nxLagPaknNum.AsString);

          if nxLagEgenPris.AsCurrency <> 0 then
          begin
            if nxLagPaknNum.AsInteger = 0 then
              ll.SubItems.Add(Format('%8.2f', [nxLagSubEnhPris.AsCurrency]))
            else
            begin
              ftmp := nxLagEgenPris.AsCurrency / (nxLagPaknNum.AsCurrency / 100);
              ll.SubItems.Add(Format('%8.2f', [ftmp]));
            end;
          end
          else
            ll.SubItems.Add(Format('%8.2f', [nxLagSubEnhPris.AsCurrency]));
        end
        else
        begin
          ll.SubItems.Add('');
          ll.SubItems.Add('ingen vare');
          ll.SubItems.Add('');
          ll.SubItems.Add('');
          ll.SubItems.Add('');
          ll.SubItems.Add('');
          ll.SubItems.Add('');
          ll.SubItems.Add('');
        end;
        ll.SubItems.Add(copy(instr, 13, 6));
        ll.SubItems.Add(copy(instr, 19, 1));
        ll.SubItems.Add(copy(instr, 20, 30));
      except
        on E: Exception do
          C2Logadd(E.Message);
      end;
    finally
      delete(instr, 1, 49);
    end;
  end;

end;

procedure TfrmNomecoStk.SetLager(const Value: integer);
begin
  FLager := Value;
end;

procedure TfrmNomecoStk.SetVarenr(const Value: string);
begin
  FVarenr := Value;
end;

class function TfrmNomecoStk.ShowNomecoStk(ALager: Integer; AVarenr: string): string;
begin
  with TfrmNomecoStk.Create(Nil) do
  begin
    try
      Result := '';
      Varenr := AVarenr;
      lager := ALager;
      StartUpMode := True;
      if ShowModal = mrOk then
        Result := SelectedVare;
    finally
      Free;

    end;
  end;

end;

procedure TfrmNomecoStk.Timer1Timer(Sender: TObject);
begin
  SocketError := 1;
  Application.MessageBox('Der kunne ikke oprettes kontakt til grossistens server. ' +
    'Prøv venligst igen og kontakt Cito hvis problemet fortsætter.', 'Fejl');
  Timer1.Enabled := False;
end;

procedure TfrmNomecoStk.WSocket1BgException(Sender: TObject; E: Exception; var CanClose: Boolean);
begin
  Application.MessageBox(pchar(E.Message), 'ok');
end;

procedure TfrmNomecoStk.WSocket1DataAvailable(Sender: TObject; ErrCode: Word);
var
  Len: Integer;
begin
  { We use line mode, we will receive a complete line }
  Len := WSocket1.Receive(@Buffer, SizeOf(Buffer) - 1);
  if Len <= 0 then
    exit;
  C2Logadd('len is ' + inttostr(Len));
  Buffer[Len] := #0; { Nul terminate }
  recvstr := recvstr + string(Buffer);
  if length(recvstr) = 4096 then
  begin
    recvstr := ToAscii(recvstr, 4096);
    C2Logadd(recvstr); { Pass as string }
    process_string(recvstr);
    StartUpMode := False;
    WSocket1.CloseDelayed;
  end;
end;

procedure TfrmNomecoStk.WSocket1DataSent(Sender: TObject; ErrCode: Word);
begin
  C2Logadd('Datasent ' + inttostr(ErrCode));
end;

procedure TfrmNomecoStk.WSocket1Error(Sender: TObject);
begin
  Application.MessageBox('Fejl', 'ok');
  SocketError := 1;
end;

procedure TfrmNomecoStk.WSocket1SessionConnected(Sender: TObject; ErrCode: Word);
begin
  C2Logadd('Session connected ' + inttostr(ErrCode));
end;

end.
