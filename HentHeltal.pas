unit HentHeltal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TfmTastHeltal = class(TForm)
    Efld: TEdit;
    ButOK: TBitBtn;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ButOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function TastHeltal (S : String; var LbNr : integer) : Boolean;

var
  fmTastHeltal: TfmTastHeltal;


implementation

uses
  ChkBoxes;

{$R *.DFM}

function TastHeltal (S : String; var LbNr : integer) : Boolean;
var
  tmplbnr : integer;
begin
  fmTastHeltal := TfmTastHeltal.Create (NIL);
  try
    fmTastHeltal.Caption   := S;
    fmTastHeltal.Efld.Text := IntToStr (LbNr);
    fmTastHeltal.ShowModal;
  finally
    if fmTastHeltal.ModalResult = mrOk then
    begin
      Lbnr := 0;
      if TryStrToInt (fmTastHeltal.EFld.Text,tmpLbNr) then
        LbNr := tmplbnr;
    end;
    Result := fmTastHeltal.ModalResult = mrOK;
    fmTastHeltal.Free;
    fmTastHeltal := NIL;
  end;
end;

procedure TfmTastHeltal.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key         := #0;
  end;
end;

procedure TfmTastHeltal.ButOKClick(Sender: TObject);
var
  Bel : integer;
begin
  try
    Bel := StrToInt(fmTastHeltal.EFld.Text);
    if Bel > 99999999 then
    begin
      if not ChkBoxYesNo('Er pris korrekt?',False) then
        exit;
    end;
    ModalResult := mrOk;
  except
  end;
end;

end.
