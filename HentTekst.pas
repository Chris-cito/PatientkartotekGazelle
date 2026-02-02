unit HentTekst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TfmTastTekst = class(TForm)
    Efld: TEdit;
    ButOK: TBitBtn;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function TastTekst (S : String; var Txt : String) : Boolean;

var
  fmTastTekst: TfmTastTekst;

implementation

{$R *.DFM}

function TastTekst (S : String; var Txt : String) : Boolean;
begin
  fmTastTekst := TfmTastTekst.Create (NIL);
  try
    fmTastTekst.Caption   := S;
    fmTastTekst.Efld.Text := Txt;
    fmTastTekst.ShowModal;
  finally
    if fmTastTekst.ModalResult = mrOk then
      Txt := fmTastTekst.EFld.Text;
    Result := fmTastTekst.ModalResult = mrOK;
    fmTastTekst.Free;
    fmTastTekst := NIL;
  end;
end;

procedure TfmTastTekst.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key         := #0;
  end;
end;

end.
