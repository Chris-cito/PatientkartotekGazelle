{$I bsdefine.inc}

unit VareOversigt;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms,   Dialogs,  StdCtrls,
  Buttons, DB,       DBCtrls,
  MemTbl60,
  DBGrids, Grids{, C2StdMain};

type
{
  TKontoIUForm = class(TFrmC2StdMain)
}
  TVareForm = class(TForm)
    ButFortryd: TBitBtn;
    ButGodkend: TBitBtn;
    DBGrid1: TDBGrid;
    ButNavn: TBitBtn;
    EFind: TEdit;
    Label1: TLabel;
    tbVar: TMemTable;
    tbVarVareNr: TStringField;
    tbVarNavn: TStringField;
    tbVarAntal: TLargeintField;
    tbVarPris: TCurrencyField;
    dsVar: TDataSource;
    tbVarDato: TStringField;
    tbVarLok1: TWordField;
    tbVarLok2: TWordField;
    tbVarAPris: TCurrencyField;
    tbVarTilsk: TCurrencyField;
    ButNr: TBitBtn;
    ButMJ: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure ButNavnClick(Sender: TObject);
    procedure tbVarAfterScroll(DataSet: TDataSet);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure ButGodkendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButNrClick(Sender: TObject);
    procedure ButMJClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    VareLager: Word;
    VareNavn,
    VareNr   : String;
  end;

var
  VareForm: TVareForm;

implementation

uses
  C2Procs,
  ChkBoxes,
  DM,
  MidClientApi;

{$R *.DFM}

var
  Kritisk    : Boolean;
  VareRec    : TVareRec;
  VareLstRec : TVareLstRec;

procedure TVareForm.FormShow(Sender: TObject);
begin
  Kritisk := True;
  tbVar.Close;
  tbVar.Open;
  Kritisk := False;
  VareNr  := '';
  ButGodkend.Default := False;
  ButNavn   .Default := True;
  if VareNavn <> '' then begin
    EFind.Text := VareNavn;
    ButNavn.Click;
  end else begin
    EFind.Clear;
    EFind.SetFocus;
  end;
end;

procedure AddTabel (var VareRec : TVareRec);
begin with VareForm, VareRec do begin
  Kritisk := True;
  tbVar.Append;
  tbVarVareNr.AsString    := Nr;
  tbVarNavn.AsString      := Navn + ' ' + DispV + ' ' + DispH;
  if VareRec.Slettet then
    tbVarNavn.AsString    := '*' + tbVarNavn.AsString;
  tbVarAntal.AsLargeInt   := Antal;
  tbVarDato.AsString      := BestDatoS;
  tbVarAPris.Value        := VareRec.AltPris;
  tbVarTilsk.Value        := VareRec.Tilskud;
  tbVarPris.AsCurrency    := Pris;
  if VareRec.Skranke then begin
    if VareRec.Gebyr > 0 then
      tbVarPris.AsCurrency  := tbVarPris.AsCurrency - VareRec.Gebyr;
  end;
  tbVarLok1.Value         := Lokat1;
  tbVarLok2.Value         := Lokat2;
  tbVar.Post;
  Kritisk := False;
end; end;

procedure TVareForm.ButNavnClick(Sender: TObject);
var
  Antal : Word;
begin with MidClient, VareLstRec do begin
  FillChar (VareLstRec, SizeOf (VareLstRec), 0);
  Antal    := 0;
//  Lager    := MainDm.ffLagNvnRefNr.Value;
  Lager    := VareLager;
  Argument := AnsiUpperCase (Trim (EFind.Text));
//  Argument := Dos2Iso (Win2Dos (Argument));
  MidClient.HentVareLst (VareLstRec);
  if VareLstRec.Status = AppResOK then begin
    Kritisk := True;
    tbVar.Close;
    tbVar.Open;
    Kritisk := False;
    Inc (Antal);
    AddTabel (VareRec);
    while (VareLstRec.Status = AppResOk) and (Antal < 11) do begin
      MidClient.HentVareLst (VareLstRec);
      if VareLstRec.Status = AppResOK then begin
        Inc (Antal);
        AddTabel (VareRec);
      end;
    end;
    DBGrid1.SetFocus;
    ButGodkend.Default := True;
    ButNavn   .Default := False;
  end else begin
    if VareLstRec.Status <> DBMSResNotFound then
      MidClient.ClientError (VareLstRec.Status);
  end;
  tbVar.First;
end; end;

procedure TVareForm.ButNrClick(Sender: TObject);
begin with MidClient, VareRec do begin
  FillChar (VareRec, SizeOf (VareRec), 0);
//  Lager := MainDm.ffLagNvnRefNr.Value;
  Lager := VareLager;
  Nr    := Trim (EFind.Text);
  MidClient.HentVare (VareRec);
  if VareRec.Status = AppResOK then begin
    Kritisk := True;
    tbVar.Close;
    tbVar.Open;
    Kritisk := False;
    AddTabel (VareRec);
    DBGrid1.SetFocus;
    ButGodkend.Default := True;
    ButNavn   .Default := False;
  end else begin
    if VareLstRec.Status <> DBMSResNotFound then
      MidClient.ClientError (VareLstRec.Status);
  end;
  tbVar.First;
end; end;

procedure TVareForm.tbVarAfterScroll(DataSet: TDataSet);
begin
  if not Kritisk then begin
    if tbVar.Eof then begin
      if VareLstRec.Status = AppResOK then begin
        VareLstRec.Lager:= VareLager;
        MidClient.HentVareLst (VareLstRec);
        if VareLstRec.Status = AppResOK then
          AddTabel (VareLstRec.VareRec);
      end;
    end;
  end;
end;

procedure TVareForm.DBGrid1DblClick(Sender: TObject);
begin
  ButGodkend.Click;
end;

procedure TVareForm.ButGodkendClick(Sender: TObject);
begin
  VareNr := tbVarVareNr.AsString;
end;

procedure TVareForm.FormCreate(Sender: TObject);
begin
  VareNr   := '';
  VareNavn := '';
  Kritisk  := True;
  tbVar.Open;
  Kritisk  := False;
end;

procedure TVareForm.ButMJClick(Sender: TObject);
var
  ApoNr,
  VareNr,
  MJStr  : String;
begin with MainDm do begin
  if tbVar.RecordCount > 0 then
    VareNr := tbVarVareNr.AsString
  else
    VareNr := EFind.Text;
  ApoNr  := Copy (ffFirmaSpec1.AsString, 1, 4);
  MJStr  := 'http://www.maxjenne.dk/login/apoteksinfo/'   +
            'showresults.php3?streng='           + VareNr +
            '&hvad=A&select=Varenummer&accmain=' + ApoNr  +
            '&pharmasys=1&searchform=on';
  WinExec (PChar ('mp.exe 1000 ' + MjStr), SW_NORMAL);
end; end;

end.


