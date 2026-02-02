unit ReRecept;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TReRcpForm = class(TForm)
    Efld: TEdit;
    ButOK: TBitBtn;
    chkDosis: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ButOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function RcptLbnr (C : String; var LbNr : LongWord) : Boolean;

var
  ReRcpForm: TReRcpForm;

implementation

uses
  C2MainLog,
  Main;

{$R *.DFM}

function RcptLbnr (C : String; var LbNr : LongWord) : Boolean;
var
  tmplbnr : integer;
begin
  C2LogAdd('Edifact in');
  ReRcpForm := TReRcpForm.Create (NIL);
  try
    ReRcpForm.Caption := C;
    ReRcpForm.ShowModal;
  finally
    if ReRcpForm.ModalResult = mrOk then
    begin
      C2LogAdd('  EFld "' + ReRcpForm.EFld.Text + '"');
      Lbnr := 0;
      if tryStrToInt (ReRcpForm.EFld.Text,tmpLbnr) then
        LbNr := tmplbnr;
      C2LogAdd('  LbNr "' + IntToStr(LbNr) + '"');
    end;
    Result := ReRcpForm.ModalResult = mrOK;
    ReRcpForm.Free;
    ReRcpForm := NIL;
  end;
  C2LogAdd('Edifact out');
end;

procedure TReRcpForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key         := #0;
  end;
end;

procedure TReRcpForm.ButOKClick(Sender: TObject);
var
  S : String;
begin
  // Check for stregkode som omsættes til LbNr
  S := EFld.Text;
  if Length (S) > 0 then
  begin
    if Length (S) = 13 then
    begin
      Delete  (S, 13, 1);
      Delete  (S, 1,  2);
    end;
  end
  else
    S := '0';
  EFld.Text := S;
  StamForm.save_ediNr := 0;
  StamForm.TakserDosisKortAuto := chkDosis.Checked;
end;

procedure TReRcpForm.FormShow(Sender: TObject);
begin
  chkDosis.Checked := True;
  if pos('dosiskort',Caption) = 0 then
    chkDosis.Visible :=  False;
//  if pos('Ehandel',Caption) <> 0 then begin
//
//    if StamForm.Save_EordreNr <> 0  then begin
//      Efld.Text := inttostr(StamForm.Save_EordreNr);
//      efld.SelectAll;
//    end;
//    exit;
//  end;
  if StamForm.save_ediNr <> 0 then
  begin
    Efld.Text := inttostr(StamForm.save_ediNr);
    efld.SelectAll;
    exit;
  end;
end;

end.

