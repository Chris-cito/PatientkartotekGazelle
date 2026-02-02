{$I bsdefine.inc}

unit UdlignCtr;

{ Developed by: Cito IT A/S

  Description: Show udligning details

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  12-04-2019/cjs  new format for the udligning grid
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, Mask, Db,
  DBGrids, DBCtrls, DBClient, Vcl.Grids;

type
  TCtrUdlignForm = class(TForm)
    dbgUdlign: TDBGrid;
    gbUdlign: TGroupBox;
    laUdlign: TLabel;
    laSaldo: TLabel;
    laUdlign2: TLabel;
    meUdlign: TMaskEdit;
    meSaldo: TMaskEdit;
    buGodkend: TBitBtn;
    buFortryd: TBitBtn;
    dsUdl: TDataSource;
    laStempel: TLabel;
    buListe: TBitBtn;
    dbeStempel: TDBEdit;
    paPeriode: TPanel;
    rbForrige: TRadioButton;
    rbAktuelle: TRadioButton;
    mtUdl: TClientDataSet;
    mtUdlApoNr: TStringField;
    mtUdlEkspNr: TIntegerField;
    mtUdlOrdNr: TWordField;
    mtUdlStempel: TDateTimeField;
    mtUdlBGP: TCurrencyField;
    mtUdlIBT: TCurrencyField;
    mtUdlSaldo: TCurrencyField;
    mtUdlFejl: TStringField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure buListeClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure rbForrigeClick(Sender: TObject);
    procedure rbAktuelleClick(Sender: TObject);
    procedure buGodkendClick(Sender: TObject);
  private
    { Private declarations }
    useCTRB : boolean;
  public
    { Public declarations }
    WrkFor, WrkAkt  : Currency;
    UdlType : Word;
    class function CtrUdlignValg (var Stempel : TDateTime;
                                DatoFor : TDateTime;
                                DatoAkt : TDateTime;
                             var Udlign : Currency;
                                 UdlFor : Currency;
                                 UdlAkt : Currency;
                                  Saldo : Currency;
                                  CTRB  : Boolean) : Boolean;
  end;



implementation

uses
  DM,
  ChkBoxes,
  MidClientApi;

{$R *.DFM}

class function TCtrUdlignForm.CtrUdlignValg (var Stempel : TDateTime;
                            DatoFor : TDateTime;
                            DatoAkt : TDateTime;
                         var Udlign : Currency;
                             UdlFor : Currency;
                             UdlAkt : Currency;
                              Saldo : Currency;
                              CTRB : boolean) : Boolean;
begin
  with TCtrUdlignForm.Create (NIL) do
  begin
    try
      WrkFor       := UdlFor;
      WrkAkt       := UdlAkt;
      meSaldo.Text := FormatCurr ('###,###,##0.00', Saldo);
      useCTRB := CTRB;
      ShowModal;
      try
        if ModalResult = mrOK then begin
          Udlign := StrToInt (meUdlign.Text) / 100;
          if mtUdl.RecordCount = 0 then begin
            case UdlType of
              1 : Stempel := DatoFor;
              2 : Stempel := DatoAkt;
            end;
          end else
            Stempel := mtUdlStempel.AsDateTime;
        end;
      except
        Udlign := 0;
      end;
    finally
      Result := ModalResult = mrOK;
      if not Result then
        Udlign := 0;
      Free;
    end;
  end;
end;

procedure TCtrUdlignForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F6 then begin
    Key := 0;
    buGodkend.Click;
  end;
end;

procedure TCtrUdlignForm.buListeClick(Sender: TObject);
var
  AkkSaldo : Currency;
  KnvStr,
  ErrStr,
  CtrStr   : String;
  CtrRes   : Word;
  CtrLst   : TStringList;

begin
  with MidClient, MainDm do
  begin
    Screen.Cursor := crHourGlass;
    CtrLst        := TStringList.Create;
    try
      AkkSaldo := 0;
      CtrRes   := RecvCtrListe (maindm.nxdb, ffPatKarKundeNr.AsString,
                  UdlType = 1, UdlType = 2,UseCTRB, CtrLst);
      if CtrRes = 0 then
      begin
        mtUdl.EmptyDataSet;
        for CtrStr in CtrLst do
        begin
          ErrStr   := '';
          mtUdl.Append;
          try
            KnvStr                  := Trim (Copy (CtrStr,  1, 15));
            ErrStr                  := 'apnr=' + KnvStr;
            mtUdlApoNr.AsString     := KnvStr;

            KnvStr                  := Trim (Copy (CtrStr, 19, 12));
            ErrStr                  := 'apekspnr=' + KnvStr;
            mtUdlEkspNr.Value       := StrToInt (KnvStr);

            KnvStr                  := Trim (Copy (CtrStr, 33, 2));
            ErrStr                  := 'apordnr=' + KnvStr;
            mtUdlOrdNr.Value        := StrToInt (KnvStr);

            KnvStr                  := Trim (Copy (CtrStr, 36, 16));
            ErrStr                  := 'aptid' + KnvStr;
            mtUdlStempel.AsDateTime := StrToDateTime (KnvStr);

            KnvStr                  := Trim (Copy (CtrStr, 52, 12));
            ErrStr                  := 'bgp=' + KnvStr;
            mtUdlBGP.AsCurrency     := StrToCurr (KnvStr);

            KnvStr                  := Trim (Copy (CtrStr, 64, 12));
            ErrStr                  := 'ibt=' + KnvStr;
            mtUdlIBT.AsCurrency     := StrToCurr (KnvStr);

            ErrStr                  := 'akk.saldo';
            AkkSaldo                := AkkSaldo + mtUdlBGP.AsCurrency;
            mtUdlSaldo.AsCurrency   := AkkSaldo;

            ErrStr                  := '';
          except
            mtUdlApoNr.AsString     := 'Fejl';
            mtUdlFejl.AsString      := 'Fejl i feltet "' + ErrStr + '"';
          end;
          mtUdl.Post;
        end;
      end
      else
      begin
        if CtrRes > 9900 then
          ChkBoxOK ('CTR-problem ' + CtrMsgCodes9900 [CtrRes])
        else
          ChkBoxOK ('CTR-problem ' + CtrMsgCodes0400 [CtrRes]);
      end;
    finally
      CtrLst.Free;
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TCtrUdlignForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    SelectNext (ActiveControl, True, True);
  end
  else
  begin
    if Key = #27 then begin
      Key := #0;
      buFortryd.Click;
    end;
  end;
  if Key <> #0 then
    Inherited;
end;

procedure TCtrUdlignForm.FormActivate(Sender: TObject);
begin
  if WrkFor <> 0 then
  begin
    UdlType := 1;
    rbForrige.Caption  := '&Forrige '  + FormatCurr ('###,##0.00', WrkFor);
  end
  else
    rbForrige.Enabled  := False;
  if WrkAkt <> 0 then
  begin
    UdlType := 2;
    rbAktuelle.Caption := '&Aktuelle ' + FormatCurr ('###,##0.00', WrkAkt);
  end
  else
    rbAktuelle.Enabled := False;
  case UdlType of
    1 : rbForrige .Checked := True;
    2 : rbAktuelle.Checked := True;
  end;
  if useCTRB then
  begin
    gbUdlign.Color := clWebOrange;
    Caption := 'Foretag udligning i CTR B';
  end;

//  PostMessage(buListe.Handle, WM_LBUTTONDOWN, 0, 0);
//  PostMessage(buListe.Handle, WM_LBUTTONUP, 0, 0);

end;

procedure TCtrUdlignForm.rbForrigeClick(Sender: TObject);
begin
  UdlType       := 1;
  meUdlign.Text := IntToStr (Round (WrkFor * 100));
  if mtUdl.RecordCount > 0 then begin
    mtUdl.First;
    while not mtUdl.Eof do
      mtUdl.Delete;
    mtUdl.Close;
    mtUdl.Open;
    buListe.Click;
  end;
end;

procedure TCtrUdlignForm.rbAktuelleClick(Sender: TObject);
begin
  UdlType       := 2;
  meUdlign.Text := IntToStr (Round (WrkAkt * 100));
  if mtUdl.RecordCount > 0 then begin
    mtUdl.First;
    while not mtUdl.Eof do
      mtUdl.Delete;
    mtUdl.Close;
    mtUdl.Open;
    buListe.Click;
  end;
end;

procedure TCtrUdlignForm.buGodkendClick(Sender: TObject);
var
  belob : integer;
begin

  try
    belob := StrToInt(meudlign.Text);
    if (belob > 99999999) or (belob < -99999999) then begin
      ChkBoxOK('Beløb må ikke være større end kr 999.999,99');
      ModalResult := mrNone;
      meUdlign.SetFocus;
      exit;
    end;
  except
    on e : Exception do begin
      ChkBoxOK('Fejl i beløbet');
      ModalResult := mrNone;
      meUdlign.SetFocus;
      exit;
    end;
  end;

end;

end.

