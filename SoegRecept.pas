unit SoegRecept;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TSoegRcpForm = class(TForm)
    Efld: TEdit;
    ButOK: TBitBtn;
    cbType: TComboBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure ButOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    class function SoegRcpt (var AItem : Word; var ALbNr : LongWord) : Boolean;
  end;


implementation

{$R *.DFM}

class function TSoegRcpForm.SoegRcpt (var AItem : Word; var ALbNr : LongWord) : Boolean;
var
  tmpLbnr : integer;
  LFrm : TSoegRcpForm;
begin
  LFrm := TSoegRcpForm.Create (NIL);
    try
    LFrm.ShowModal;
    if LFrm.ModalResult = mrOk then
    begin
      AItem := LFrm.cbType.ItemIndex;

      tmpLbnr := StrToIntDef (LFrm.EFld.Text,-1);
      if tmpLbnr <> -1 then
        ALbNr := tmpLbnr
	  else
	  begin
	    ALbNr := 0;
	    AItem := 0;
	  end;
	end;
    Result := LFrm.ModalResult = mrOK;
  finally
    LFrm.Free;
    end;

end;

procedure TSoegRcpForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key         := #0;
  end;
end;

procedure TSoegRcpForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Shift = [ssAlt] then
  begin
    if UpCase( Chr (Key) ) ='L' then
    begin
      cbType.ItemIndex := 0;
      Key := 0;
    end
    else
    begin
      if UpCase( Chr (Key) ) ='P' then
      begin
        cbType.ItemIndex := 1;
        Key := 0;
      end
      else
      begin
        if UpCase( Chr (Key) ) ='F' then
        begin
          cbType.ItemIndex := 2;
          Key := 0;
        end
        else
          Inherited;
      end;
    end;
  end;
end;

procedure TSoegRcpForm.FormCreate(Sender: TObject);
begin
  cbType.ItemIndex := 0;
end;

procedure TSoegRcpForm.ButOKClick(Sender: TObject);
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
end;

end.
