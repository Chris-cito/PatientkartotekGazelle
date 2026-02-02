unit SletMedkort;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls;

type
  TSletMedkForm = class(TForm)
    ButOK: TBitBtn;
    Label2: TLabel;
    dtpSlDato: TDateTimePicker;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    class function SletMedicinkort (var KommuneNr : Word;
                                 var SlDato : TDateTime) : Boolean;
  end;



implementation

uses
  c2date;

{$R *.DFM}

class function TSletMedkForm.SletMedicinkort (var KommuneNr : Word;
                             var SlDato : TDateTime) : Boolean;
begin
  with TSletMedkForm.Create (NIL) do
  begin
    try
      dtpSlDato.Date := EncodeDate(YearInDate(Date)-1,12,31);
      ShowModal;
    finally
      if ModalResult = mrOk then
      begin
        try
         SlDato    := Trunc    (dtpSlDato.Date);
        except
          KommuneNr := 0;
        end;
      end;
      Result := ModalResult = mrOK;
      Free;
    end;
  end;
end;

procedure TSletMedkForm.FormKeyPress(Sender: TObject; var Key: Char);
begin

  if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key         := #0;
  end
  else
  begin
    if Key = #13 then
    begin
      if ActiveControl <> ButOK then
      begin
        Key := #0;
        SelectNext (ActiveControl, TRUE, TRUE);
      end;
    end;
  end;
end;

end.
