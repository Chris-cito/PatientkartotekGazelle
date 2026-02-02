unit HentFraTilDatoTid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls;

type
  TFraTilDatoTidForm = class(TForm)
    ButOK: TBitBtn;
    dtdpFra: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    dtdpTil: TDateTimePicker;
    dttpFra: TDateTimePicker;
    dttpTil: TDateTimePicker;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function TastDatoerTid (S : String;
       var FraDato, TilDato : TDateTime;
         var FraTid, TilTid : TDateTime) : Boolean;

var
  FraTilDatoTidForm: TFraTilDatoTidForm;

implementation

{$R *.DFM}

function TastDatoerTid (S : String;
     var FraDato, TilDato : TDateTime;
       var FraTid, TilTid : TDateTime) : Boolean;
begin
  FraTilDatoTidForm := TFraTilDatoTidForm.Create (NIL);
  try
    FraTilDatoTidForm.Caption      := S;
    FraTilDatoTidForm.dtdpFra.Date := FraDato;
    FraTilDatoTidForm.dtdpTil.Date := TilDato;
    FraTilDatoTidForm.dttpFra.Time := FraTid;
    FraTilDatoTidForm.dttpTil.Time := TilTid;
    FraTilDatoTidForm.ShowModal;
  finally
    if FraTilDatoTidForm.ModalResult = mrOk then
    begin
      try
        FraDato := FraTilDatoTidForm.dtdpFra.Date;
        TilDato := FraTilDatoTidForm.dtdpTil.Date;
        FraTid  := FraTilDatoTidForm.dttpFra.Time;
        TilTid  := FraTilDatoTidForm.dttpTil.Time;
      except
      end;
    end;
    Result := FraTilDatoTidForm.ModalResult = mrOK;
    FraTilDatoTidForm.Free;
    FraTilDatoTidForm := NIL;
  end;
end;

procedure TFraTilDatoTidForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    SelectNext (ActiveControl, TRUE, TRUE);
    Key := #0;
  end;
  if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key         := #0;
  end;
end;

end.
