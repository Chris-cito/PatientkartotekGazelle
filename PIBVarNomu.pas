unit PIBVarNomu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OverbyteIcsWndControl, OverbyteIcsWSocket, StdCtrls, ExtCtrls,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPC, ComCtrls,
  DB, nxdb, generics.collections, DBCtrls,TakserHuman, Vcl.Mask;


type
  TfrmPIBNom = class(TForm)
    WSocket1: TWSocket;
    Timer1: TTimer;
    nxLag: TnxTable;
    nxLagNavn: TStringField;
    nxLagForm: TStringField;
    nxLagStyrke: TStringField;
    nxLagPakning: TStringField;
    nxLagLager: TWordField;
    nxLagVareNr: TStringField;
    Panel1: TPanel;
    Panel2: TPanel;
    ListView2: TListView;
    nxLagSalgsTekst: TStringField;
    nxLagVareInfo: TIntegerField;
    DataSource1: TDataSource;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    nxLagLokation1: TIntegerField;
    nxLagAntal: TIntegerField;
    nxLagSalgsPris: TCurrencyField;
    procedure WSocket1SessionConnected(Sender: TObject; ErrCode: Word);
    procedure WSocket1DataSent(Sender: TObject; ErrCode: Word);
    procedure Timer1Timer(Sender: TObject);
    procedure WSocket1DataAvailable(Sender: TObject; ErrCode: Word);
    procedure WSocket1Error(Sender: TObject);
    procedure WSocket1BgException(Sender: TObject; E: Exception;
      var CanClose: Boolean);
    procedure GetPIB;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    SocketError : integer;
    Buffer       : array [0..5000] of AnsiChar;
    recvstr : ansistring;
    procedure process_string(instr : AnsiString);
  public
    { Public declarations }
  end;
const {*****************************************************************************}
{* EBCDIC to ASCII                                                           *}
{*****************************************************************************}

  EtoA: array[0..255] of Word =
       ($00,$01,$02,$03,$04,$05,$06,$07, {00}
          $08,$09,$0A,$0B,$0C,$0D,$0E,$0F, {08}
        $10,$11,$12,$13,$14,$15,$16,$17, {10}
        $18,$19,$1A,$1B,$1C,$1D,$1E,$1F, {18}
        $20,$21,$22,$23,$24,$25,$26,$27, {20}
        $28,$29,$2A,$2B,$2C,$2D,$2E,$2F, {28}
        $30,$31,$32,$33,$34,$35,$36,$37, {30}
        $38,$39,$3A,$3B,$3C,$3D,$3E,$3F, {38}
        $20,$FF,$83,$84,$85,$A0,$C6,$86, {40}
        $87,$A4,$5B,$2E,$3C,$28,$2B,$21, {48}
        $26,$82,$88,$89,$8A,$A1,$8C,$8B, {50}
        $8D,$E1,$5D,$24,$2A,$29,$3B,$5E, {58}
        $2D,$2F,$B6,$8E,$B7,$B5,$C7,$8F, {60}
        $80,$A5,$DD,$2C,$25,$5F,$3E,$3F, {68}
        $9B,$90,$D2,$D3,$D4,$D6,$D7,$D8, {70}
        $DE,$60,$3A,$23,$40,$27,$3D,$22, {78}
        $9D,$61,$62,$63,$64,$65,$66,$67, {80}
        $68,$69,$AE,$AF,$D0,$EC,$E8,$F1, {88}
        $F8,$6A,$6B,$6C,$6D,$6E,$6F,$70, {90}
        $71,$72,$A6,$A7,$91,$F7,$92,$CF, {98}
        $E6,$7E,$73,$74,$75,$76,$77,$78, {A0}
        $79,$7A,$AD,$A8,$D1,$ED,$E7,$A9, {A8}
        $BD,$9C,$BE,$FA,$9F,$F5,$F4,$AC, {B0}
        $AB,$F3,$AA,$7C,$EE,$F9,$EF,$F2, {B8}
        $7B,$41,$42,$43,$44,$45,$46,$47, {C0}
        $48,$49,$F0,$93,$94,$95,$A2,$E4, {C8}
        $7D,$4A,$4B,$4C,$4D,$4E,$4F,$50, {D0}
        $51,$52,$D5,$96,$81,$97,$A3,$98, {D8}
        $5C,$E1,$53,$54,$55,$56,$57,$58, {E0}
        $59,$5A,$FD,$E2,$99,$E3,$E0,$E5, {E8}
        $30,$31,$32,$33,$34,$35,$36,$37, {F0}
        $38,$39,$FC,$EA,$9A,$EB,$E9,$FF);{F8}

{*****************************************************************************}
{* ASCII to EBCDIC                                                           *}
{*****************************************************************************}

  AtoE: array[0..255] of Word =
       ($00,$01,$02,$03,$04,$05,$06,$07, {00}
          $08,$09,$0A,$0B,$0C,$0D,$0E,$0F, {08}
        $10,$11,$12,$13,$B6,$B5,$16,$17, {10}
        $18,$19,$1A,$1B,$1C,$1D,$1E,$1F, {18}
        $40,$4F,$7F,$7B,$5B,$6C,$50,$7D, {20}
        $4D,$5D,$5C,$4E,$6B,$60,$4B,$61, {28}
        $F0,$F1,$F2,$F3,$F4,$F5,$F6,$F7, {30}
        $F8,$F9,$7A,$5E,$4C,$7E,$6E,$6F, {38}
        $7C,$C1,$C2,$C3,$C4,$C5,$C6,$C7, {40}
        $C8,$C9,$D1,$D2,$D3,$D4,$D5,$D6, {48}
        $D7,$D8,$D9,$E2,$E3,$E4,$E5,$E6, {50}
        $E7,$E8,$E9,$4A,$E0,$5A,$5F,$6D, {58}
        $79,$81,$82,$83,$84,$85,$86,$87, {60}
        $88,$89,$91,$92,$93,$94,$95,$96, {68}
        $97,$98,$99,$A2,$A3,$A4,$A5,$A6, {70}
        $A7,$A8,$A9,$C0,$BB,$D0,$A1,$41, {78}
        $68,$DC,$51,$42,$43,$44,$47,$48, {80}
        $52,$53,$54,$57,$56,$58,$63,$67, {88}
        $71,$9C,$9E,$CB,$CC,$CD,$DB,$DD, {90}
        $DF,$EC,$FC,$70,$B1,$80,$41,$B4, {98}
        $45,$55,$CE,$DE,$49,$69,$9A,$9B, {A0}
        $AB,$AF,$BA,$B8,$B7,$AA,$8A,$8B, {A8}
        $41,$41,$41,$41,$41,$65,$62,$64, {B0}
        $41,$41,$41,$41,$41,$B0,$B2,$41, {B8}
        $41,$41,$41,$41,$41,$41,$46,$66, {C0}
        $41,$41,$41,$41,$41,$41,$41,$9F, {C8}
        $08,$AC,$72,$73,$74,$DA,$75,$76, {D0}
        $77,$41,$41,$41,$41,$6A,$78,$41, {D8}
        $EE,$59,$EB,$ED,$CF,$EF,$A0,$AE, {E0}
        $8E,$FE,$FB,$FD,$8D,$AD,$BC,$BE, {E8}
        $CA,$8F,$BF,$B9,$B6,$B5,$41,$9D, {F0}
        $90,$BD,$B3,$41,$FA,$EA,$FE,$41);{F8}



var
  frmPIBNom: TfrmPIBNom;
  CopyVareList : TList<TakserHuman.PIBVarType>;
  g_varenr : string;
  function ShowVareinfo(VareList : TList<PIBVarType>): string;



implementation



uses C2MainLog, dm,ChkBoxes, Main;

function ShowVareInfo(VareList : TList<TakserHuman.PIBVarType>): string;
var
  tmpVarenr : TakserHuman.PIBVarType;
  first : boolean;
begin

  Result := '';
  CopyVareList := TList<TakserHuman.PIBVarType>.Create;
  try
    for tmpVarenr in VareList do
      if not tmpVarenr.Checked then
         CopyVareList.Add(tmpVarenr);
    first := True;
    for tmpVarenr in CopyVareList do begin
      if CopyVareList.Count > 1 then begin
        if not first then begin
          if not ChkBoxYesNo('Vis vareinfo for næste vare',True) then
            exit;
        end;
        first := False;
      end;
      frmPIBNom := TfrmPIBNom.Create(Nil);
      try
        g_varenr := tmpVarenr.VareNr;
        frmPIBNom.ShowModal;
      finally
        frmPIBNom.Free;
      end;
    end;
  finally
    CopyVareList.Free;
  end;

end;



{$R *.dfm}

function ToAscii(StrObj: AnsiString; Len: Integer) : AnsiString;
var
  i: Integer;
  tmpstr : AnsiString;
  ascn : integer;
begin
  tmpstr := '';
  for i := 1 to Len do begin
    ascn := Ord(strobj[i]);
    case ascn  of
      $C0 :       tmpstr := tmpstr + 'æ';
      $7B :       tmpstr := tmpstr + 'Æ';
      $6A :       tmpstr := tmpstr + 'ø';
      $7C :       tmpstr := tmpstr + 'Ø';
      $D0 :       tmpstr := tmpstr + 'å';
      $5B :       tmpstr := tmpstr + 'Å';
    else
{$WARNINGS OFF}
      tmpstr := tmpstr + Chr(EtoA[ascn]);
{$WARNINGS ON}
    end;
  end;
  Result := tmpstr;
end;


function ToEbcdic(StrObj: AnsiString; Len: Integer) : AnsiString;
var
  i: Integer;
  tmpstr : AnsiString;
  ascn : integer;
begin
  tmpstr := '';
  for i := 1 to Len do begin
    ascn := Ord(strobj[i]);
{$WARNINGS OFF}
    tmpstr := tmpstr + Chr(AtoE[ascn]);
{$WARNINGS ON}
  end;
  Result := tmpstr;
end;

procedure TfrmPIBNom.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then begin
    ModalResult := mrCancel;
    frmPIBNom.Close;
  end;

end;

procedure TfrmPIBNom.FormShow(Sender: TObject);
var
  book : TBookmark;
begin
  nxLag.Open;
  try
    nxlag.IndexName := 'NrOrden';
    if nxLag.FindKey([stamform.FLagerNr,g_varenr]) then begin
      book := nxlag.Bookmark;
      if (nxLagVareInfo.AsInteger and 1) = 1 then begin
          GetPIB;
      end else
        panel2.Visible := False;
      nxlag.Bookmark := book;

    end;

  finally
//    nxLag.Close;
  end;
end;

procedure TfrmPIBNom.GetPIB;
var
  save_cursor : TCursor;
  procedure send_buffer;
  var
    sendstr : AnsiString;
    found : boolean;

  begin
    with MainDm do begin
      try
        found := false;
        fqKto.First;
        while not fqKto.Eof do begin
          if (fqkto.FieldByName('VisVareHost').AsString <> '') and
             (fqkto.FieldByName('Groplnr').Asinteger = 1)then begin
            found := True;
            break;
          end;
          fqkto.Next;
        end;
        if not found then
          exit;
{$WARNINGS OFF}
        sendstr := '0000' + 'NOPIBFOR  ' + fqKto.FieldByName('Kontonr').AsString + g_varenr;
        sendstr := sendstr + StringOfChar(' ',4096-length(sendstr));
{$WARNINGS ON}
        C2LogAdd('length of sendstr is ' + IntToStr(length(sendstr)));
        sendstr := ToEbcdic(sendstr,4096);
        SocketError := 0;
        WSocket1.Addr := fqKto.FieldByName('VisVareHost').AsString;
        WSocket1.Port := fqKto.FieldByName('VisVarePort').AsString;;
        WSocket1.Proto :='tcp';
        Timer1.Enabled := True;
        WSocket1.Connect;
        while (WSocket1.State  in [wsConnecting]) and (SocketError =0) do
          Application.ProcessMessages;
        recvstr := '';
        if WSocket1.State = wsConnected then begin
          C2LogAdd('Connected');
          WSocket1.SendStr(sendstr);

        end;

        while WSocket1.State = wsConnected do
          Application.ProcessMessages;
      except

      end;
    end;

  end;
begin
  save_cursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    ListView2.SortType := stNone;
    ListView2.Items.Clear;
    send_buffer;
    ListView2.SetFocus;

  finally
    Screen.Cursor := save_cursor;
    Timer1.Enabled := False;
  end;


end;

procedure TfrmPIBNom.process_string(instr: AnsiString);
var
  ll : TListItem;
begin
  C2LogAdd(instr);

  if copy(instr,5,9) <> 'NOPIBFOR ' then
    exit;

  delete(instr,1,27);

  while TRUE do begin

    try
      if trim(copy(instr,1,77)) = '' then
        break;
      ll := ListView2.Items.Add;
      ll.Caption := trim(copy(instr,1,70));
      ll.SubItems.Add(copy(instr,71,6));
      if nxLag.FindKey([stamform.FLagerNr,copy(instr,71,6)]) then begin
        ll.SubItems.Add(trim(nxLagNavn.AsString));
        ll.SubItems.Add(nxLagAntal.AsString);
        ll.SubItems.Add(nxLagLokation1.AsString);
        ll.SubItems.Add(Format('%8.2f',[nxLagSalgsPris.AsCurrency]));
      end else begin
        ll.SubItems.Add('');
        ll.SubItems.Add('');
        ll.SubItems.Add('');
        ll.SubItems.Add('');
      end;

      if copy(instr,77,1) = 'J' then
        ll.SubItems.Add('Ja')
      else
        ll.SubItems.Add('');

    finally
      delete(instr,1,77);
    end;
  end;


end;

procedure TfrmPIBNom.Timer1Timer(Sender: TObject);
begin
  SocketError := 1;
  Application.MessageBox('Timer fired','ok');
  Timer1.Enabled := False;
end;

procedure TfrmPIBNom.WSocket1BgException(Sender: TObject; E: Exception;
  var CanClose: Boolean);
begin
  Application.MessageBox(pchar(e.Message),'ok');
end;

procedure TfrmPIBNom.WSocket1DataAvailable(Sender: TObject; ErrCode: Word);
var
    Len : Integer;
begin
    { We use line mode, we will receive a complete line }
    Len := WSocket1.Receive(@Buffer, SizeOf(Buffer) - 1);
    if Len <= 0 then
        Exit;
    c2logadd('len is ' + inttostr(len));
    Buffer[Len]       := #0;              { Nul terminate  }
{$WARNINGS OFF}
    recvstr := recvstr + string(Buffer);
{$WARNINGS ON}
    if Length(recvstr) = 4096 then begin
      recvstr := ToAscii(recvstr,4096);
      C2LogAdd(string(recvstr));       { Pass as string }
      process_string(recvstr);
      WSocket1.CloseDelayed;
    end;
end;

procedure TfrmPIBNom.WSocket1DataSent(Sender: TObject; ErrCode: Word);
begin
  C2LogAdd('Datasent ' + IntToStr(ErrCode));
end;

procedure TfrmPIBNom.WSocket1Error(Sender: TObject);
begin
  Application.MessageBox('Error event','ok');
end;

procedure TfrmPIBNom.WSocket1SessionConnected(Sender: TObject; ErrCode: Word);
begin
  c2logadd('Session connected ' + IntToStr(ErrCode));
end;


end.
