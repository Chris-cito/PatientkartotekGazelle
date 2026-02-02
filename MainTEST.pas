unit MainTEST;

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, WSocket, HttpProt, ExtCtrls, Buttons, Db, Grids,
  DBGrids, MemTbl, ComCtrls, NMHTTP;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    EUrl: TEdit;
    Label2: TLabel;
    ECpr: TEdit;
    RGPer: TRadioGroup;
    Label3: TLabel;
    EDato: TEdit;
    Http: THttpCli;
    Label4: TLabel;
    EApo: TEdit;
    Label5: TLabel;
    ENr: TEdit;
    Label6: TLabel;
    EOrd: TEdit;
    Label7: TLabel;
    EIBP: TEdit;
    Label8: TLabel;
    EBGP: TEdit;
    Label9: TLabel;
    EIBT: TEdit;
    CBType: TComboBox;
    Label10: TLabel;
    ButSend: TBitBtn;
    Disp: TMemo;
    Label11: TLabel;
    ENytCpr: TEdit;
    EFiktiv: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure ButSendClick(Sender: TObject);
    procedure CBTypeExit(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure DeleteTag (T : String; var S : String);
var
  T1,
  T2 : String;
  P1,
  P2 : Word;
begin
  if S <> '' then begin
    T1 := '<'  + T + '>';
    T2 := '</' + T + '>';
    P1 := Pos (T1, S);
    P2 := Pos (T2, S);
    if (P1 > 0) and (P2 > 0) then begin
      P2 := P2 + Length (T2) - 1;
      Delete (S, P1, P2 - P1);
    end;
  end;
end;

function GetTag (T, S : String) : String;
var
  S2,
  T1,
  T2 : String;
  P1,
  P2 : Word;
begin
  S2 := '';
  if S <> '' then begin
    T1 := '<'  + T + '>';
    T2 := '</' + T + '>';
    P1 := Pos (T1, S);
    P2 := Pos (T2, S);
    if (P1 > 0) and (P2 > 0) then begin
      P1 := P1 + Length (T1);
      S2 := Copy (S, P1, P2 - P1);
    end;
  end;
  Result := S2;
end;


procedure TMainForm.Button1Click(Sender: TObject);
var
  DataUrl,
  DataIn,
  DataOut : String;
  Http    : TNMHttp;

  procedure DeleteTag (T : String; var S : String);
  var
    T1,
    T2 : String;
    P1,
    P2 : Word;
  begin
    if S <> '' then begin
      T1 := '<'  + T + '>';
      T2 := '</' + T + '>';
      P1 := Pos (T1, S);
      P2 := Pos (T2, S);
      if (P1 > 0) and (P2 > 0) then begin
        P2 := P2 + Length (T2) - 1;
        Delete (S, P1, P2 - P1);
      end;
    end;
  end;

  function GetTag (T, S : String) : String;
  var
    S2,
    T1,
    T2 : String;
    P1,
    P2 : Word;
  begin
    S2 := '';
    if S <> '' then begin
      T1 := '<'  + T + '>';
      T2 := '</' + T + '>';
      P1 := Pos (T1, S);
      P2 := Pos (T2, S);
      if (P1 > 0) and (P2 > 0) then begin
        P1 := P1 + Length (T1);
        S2 := Copy (S, P1, P2 - P1);
      end;
    end;
    Result := S2;
  end;

begin
  Http     := Nil;
  Http     := TNMHttp.Create (Nil);
  try
    Http.Host                := '';
    Http.InputFileMode       := FALSE;
    Http.OutputFileMode      := FALSE;
    Http.ReportLevel         := 0;
    Http.HeaderInfo.UserID   := '';
    Http.HeaderInfo.Password := '';
    DataIn                   := 'user=ctr&passwd=ctr' +
                                '&cprnr=' + ECpr.Text +
                                '&periode=aktuelperiode';
    DataUrl                  := 'http://ctr.medicinnet.dk/ctr/mmi/statusreq';
    try
      Http.Post (DataUrl, DataIn);
    finally
      DataOut  := Http.Body;
      Disp.Clear;
      Disp.Lines.Add ('TILSKUDSSTATUS');
      Disp.Lines.Add ('Reply'#9    + IntToStr (Http.ReplyNumber));
      Disp.Lines.Add ('Cprnr'#9    + GetTag ('cprnr', DataOut));
      Disp.Lines.Add ('Barn'#9     + GetTag ('patient_barn', DataOut));
      Disp.Lines.Add ('type'#9     + GetTag ('patient_type', DataOut));
      Disp.Lines.Add ('IBP'#9      + GetTag ('saldo_ibp', DataOut));
      Disp.Lines.Add ('Udlign'#9   + GetTag ('udlign_tilskud', DataOut));
      Disp.Lines.Add ('Start'#9    + GetTag ('startdato', DataOut));
      Disp.Lines.Add ('Slut'#9     + GetTag ('slutdato', DataOut));
      Disp.Lines.Add ('Varighed'#9 + GetTag ('varighed', DataOut));
      Disp.Lines.Add ('Resultat'#9 + GetTag ('message', DataOut));
    end;
  finally
    Http.Free;
  end;
end;

procedure TMainForm.ButSendClick(Sender: TObject);
var
  DataIn  : TMemoryStream;
  DataOut : TMemoryStream;
  Strings : TStringList;
  IBP,
  BGP,
  IBT,
  Buf     : String;
  Idx     : Word;
begin
  DataIn  := TMemoryStream.Create;
  DataOut := TMemoryStream.Create;
  Strings := TStringList.Create;
  try
    IBP := EIBP.Text;
    BGP := EBGP.Text;
    IBT := EIBT.Text;
    Idx := Pos ('+', IBP);
    if Idx > 0 then begin
      Delete (IBP, Idx, 1);
      Insert ('%2B', IBP, Idx);
    end;
    Idx := Pos ('+', BGP);
    if Idx > 0 then begin
      Delete (BGP, Idx, 1);
      Insert ('%2B', BGP, Idx);
    end;
    Idx := Pos ('+', IBT);
    if Idx > 0 then begin
      Delete (IBT, Idx, 1);
      Insert ('%2B', IBT, Idx);
    end;
    if CBType.Text = 'Tilskudsstatus' then begin
      Buf := 'user=aps2' +
             '&passwd=aps2' +
             '&cprnr=' + ECpr.Text +
             '&periode=' + RGPer.Items.Strings [RGPer.ItemIndex] + 'periode';
      Http.URL := EUrl.Text + 'statusreq';
    end;
    if CBType.Text = 'Indberetning' then begin
      Buf := 'user=aps2' +
             '&passwd=aps2' +
             '&cprnr=' + ECpr.Text +
             '&foedselsdato=' + EDato.Text +
             '&apoteksnr=' + EApo.Text +
             '&apoteksekspeditionsnr=' + ENr.Text +
             '&ekspeditionsidentifikationsnr=' + EOrd.Text +
             '&apotekstidsstempel=' + FormatDateTime ('yyyymmddhhmmss', Now) +
             '&indberetningspris=' + IBP +
             '&beregningsgrundlagspris=' + BGP +
             '&indberettettilskud=' + IBT;
      Http.URL := EUrl.Text + 'transind';
    end;
    if CBType.Text = 'Transaktionsliste' then begin
      Buf := 'user=aps2' +
             '&passwd=aps2' +
             '&cprnr=' + ECpr.Text +
             '&aktuelperiode=Y' +
             '&forrigeperiode=N';
      Http.URL := EUrl.Text + 'translst';
    end;
    if CBType.Text = 'Skift Cprnr' then begin
      Buf := 'user=aps2' +
             '&passwd=aps2' +
             '&glcprnr=' + ECpr.Text +
             '&nycprnr=' + ENytCpr.Text;
      Http.URL := EUrl.Text + 'skiftcpr';
    end;
    if CBType.Text = 'Fiktivt Cprnr' then begin
      Buf := 'user=aps2' +
             '&passwd=aps2' +
             '&landekode=' + ECpr.Text;
      Http.URL := EUrl.Text + 'fiktcpr';
    end;
    DataOut.Write (Buf[1], Length (Buf));
    DataOut.Seek  (0, soFromBeginning);
    Http.SendStream := DataOut;
    Http.RcvdStream := DataIn;
    Http.Proxy      := '';
    Http.ProxyPort  := '';
    Http.Cookie     := '';
    ButSend.Enabled := FALSE;
    try
      Http.Post;
    finally
      ButSend.Enabled := TRUE;
      DataIn.Seek (0, 0);
      Strings.LoadFromStream (DataIn);
      Buf := '';
      for Idx := 0 to Strings.Count - 1 do
        Buf := Buf + Strings.Strings [Idx];
      if CBType.Text = 'Tilskudsstatus' then begin
        Disp.Clear;
        Disp.Lines.Add ('TILSKUDSSTATUS');
        Disp.Lines.Add ('Cprnr'#9    + GetTag ('cprnr', Buf));
        Disp.Lines.Add ('Barn'#9     + GetTag ('patient_barn', Buf));
        Disp.Lines.Add ('type'#9     + GetTag ('patient_type', Buf));
        Disp.Lines.Add ('IBP'#9      + GetTag ('saldo_ibp', Buf));
        Disp.Lines.Add ('Udlign'#9   + GetTag ('udlign_tilskud', Buf));
        Disp.Lines.Add ('Start'#9    + GetTag ('startdato', Buf));
        Disp.Lines.Add ('Slut'#9     + GetTag ('slutdato', Buf));
        Disp.Lines.Add ('Varighed'#9 + GetTag ('varighed', Buf));
        Disp.Lines.Add ('Resultat'#9 + GetTag ('message', Buf));
      end;
      if CBType.Text = 'Indberetning' then begin
        Disp.Clear;
        Disp.Lines.Add ('INDBERETNING');
        Disp.Lines.Add ('IBP'#9      + GetTag ('saldo_ibp', Buf));
        Disp.Lines.Add ('Udlign'#9   + GetTag ('udlign_tilskud', Buf));
        Disp.Lines.Add ('Resultat'#9 + GetTag ('message', Buf));
      end;
      if CBType.Text = 'Transaktionsliste' then begin
        Disp.Clear;
        Disp.Lines.Add ('TRANSAKTIONSLISTE');
        Disp.Lines.Add ('Dato'#9     + GetTag ('dagsdato', Buf));
        Disp.Lines.Add ('Resultat'#9 + GetTag ('message', Buf));
        Disp.Lines.Add ('Apotek'#9'Eksp.nr'#9'Tid'#9#9'BGP'#9'IBT'#9'IBP'#9);
        while GetTag ('transaktion', Buf) <> '' do begin
          Disp.Lines.Add (GetTag ('apotek_nr',  Buf) + #9 +
                          GetTag ('eksp_nr',    Buf) + #9 +
                          GetTag ('apotek_tid', Buf) + #9 +
                          GetTag ('eksp_bgp',   Buf) + #9 +
                          GetTag ('eksp_ibt',   Buf) + #9 +
                          GetTag ('eksp_ibp',   Buf) + #9);
          DeleteTag ('transaktion', Buf);
        end;
      end;
      if CBType.Text = 'Skift Cprnr' then begin
        Disp.Clear;
        Disp.Lines.Add ('SKIFT CPRNR');
        Disp.Lines.Add ('Resultat'#9 + GetTag ('message', Buf));
      end;
      if CBType.Text = 'Fiktivt Cprnr' then begin
        Disp.Clear;
        Disp.Lines.Add ('FIKTIVT CPRNR');
        Disp.Lines.Add ('Cprnr'#9    + GetTag ('cprnr', Buf));
        Disp.Lines.Add ('Resultat'#9 + GetTag ('message', Buf));
      end;
    end;
  finally
    DataOut.Free;
    DataIn.Free;
    Strings.Free;
    EUrl.Color    := clSilver;
    ECpr.Color    := clSilver;
    EDato.Color   := clSilver;
    EIBP.Color    := clSilver;
    EBGP.Color    := clSilver;
    EIBT.Color    := clSilver;
    ENr.Color     := clSilver;
    EOrd.Color    := clSilver;
    CBType.SetFocus;
    CBType.SelectAll;
  end;
end;

procedure TMainForm.CBTypeExit(Sender: TObject);
begin
  EUrl.Enabled    := False;
  ECpr.Enabled    := True;
  ENytCpr.Enabled := False;
  ENr.Enabled     := False;
  EOrd.Enabled    := False;
  if CBType.Text = 'Tilskudsstatus' then begin
    EIBP.Enabled := False;
    EBGP.Enabled := False;
    EIBT.Enabled := False;
  end;
  if CBType.Text = 'Indberetning' then begin
    EIBP.Enabled := True;
    EBGP.Enabled := True;
    EIBT.Enabled := True;
    ENr.Enabled  := True;
    EOrd.Enabled := True;
  end;
  if CBType.Text = 'Transaktionsliste' then begin
  end;
  if CBType.Text = 'Skift Cprnr' then begin
    ENytCpr.Enabled := True;
  end;
  if CBType.Text = 'Fiktivt Cprnr' then begin
  end;
  EDato.Enabled   := EFiktiv.Checked ;
  ButSend.Enabled := True;
  if EUrl.Enabled    then EUrl.Color    := clWindow;
  if ECpr.Enabled    then ECpr.Color    := clWindow;
  if ENytCpr.Enabled then ENytCpr.Color := clWindow;
  if EDato.Enabled   then EDato.Color   := clWindow;
  if EIBP.Enabled    then EIBP.Color    := clWindow;
  if EBGP.Enabled    then EBGP.Color    := clWindow;
  if EIBT.Enabled    then EIBT.Color    := clWindow;
  if ENr.Enabled     then ENr.Color     := clWindow;
  if EOrd.Enabled    then EOrd.Color    := clWindow;
  ECpr.SetFocus;
  ECpr.SelectAll;
end;

procedure ButtonLeaks;
var
  Http : TNMHttp;
begin
  Http := Nil;
  Http := TNMHttp.Create (Nil);
  try
  finally
    Http.Free;
  end;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  Nr,
  Ant : Word;
begin
  Ant := 0;
  Disp.Clear;
  Disp.Lines.Add ('Start memoryleak test');
  for Nr := 1 to 10000 do begin
    ButtonLeaks;
  end;
  Disp.Lines.Add ('Stop memoryleak test');
end;

end.

