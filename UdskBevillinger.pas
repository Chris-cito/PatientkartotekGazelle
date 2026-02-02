unit UdskBevillinger;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls;

type
  TUdskBevForm = class(TForm)
    ButOK: TBitBtn;
    cbBev: TCheckBox;
    cbMedk: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function UdskMedkBev (var Medk, Bev : Boolean) : Boolean;

var
  UdskBevForm: TUdskBevForm;

implementation

{$R *.DFM}

function UdskMedkBev (var Medk, Bev : Boolean) : Boolean;
begin
  UdskBevForm := TUdskBevForm.Create (NIL);
  try
    UdskBevForm.ShowModal;
  finally
    if UdskBevForm.ModalResult = mrOk then
    begin
      try
        Medk := UdskBevForm.cbMedk.Checked;
        Bev  := UdskBevForm.cbBev.Checked;
      except
        Medk := False;
        Bev  := False;
      end;
    end;
    Result := UdskBevForm.ModalResult = mrOK;
    UdskBevForm.Free;
    UdskBevForm := NIL;
  end;
end;

procedure TUdskBevForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key,[#13,#27]) then
    exit;
  if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key         := #0;
  end;
  if Key = #13 then
  begin
    if ActiveControl.Name <> 'ButOK' then
    begin
      Key := #0;
      SelectNext (ActiveControl, TRUE, TRUE);
    end;
  end;
end;

end.
