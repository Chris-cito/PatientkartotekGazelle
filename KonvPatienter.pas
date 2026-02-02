unit KonvPatienter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TKonvPatForm = class(TForm)
    ButOK: TBitBtn;
    cbR3: TCheckBox;
    cbR4: TCheckBox;
    cbR6: TCheckBox;
    cbR7: TCheckBox;
    Label1: TLabel;
    ER3: TEdit;
    Label4: TLabel;
    ER4: TEdit;
    ER6: TEdit;
    ER7: TEdit;
    cbR8: TCheckBox;
    ER8: TEdit;
    cbR5: TCheckBox;
    ER5: TEdit;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function KonverterPatienter (var R3, R4, R5, R6, R7, R8 : Boolean;
                             var W3, W4, W5, W6, W7, W8 : Word) : Boolean;

var
  KonvPatForm: TKonvPatForm;

implementation

uses
  DM;

{$R *.DFM}

function KonverterPatienter (var R3, R4, R5, R6, R7, R8 : Boolean;
                             var W3, W4, W5, W6, W7, W8 : Word) : Boolean;
begin
  KonvPatForm := TKonvPatForm.Create (NIL);
  try
    KonvPatForm.ShowModal;
  finally
    if KonvPatForm.ModalResult = mrOk then begin
      try
        R3 := KonvPatForm.cbR3.Checked;
        R4 := KonvPatForm.cbR4.Checked;
        R6 := KonvPatForm.cbR6.Checked;
        R7 := KonvPatForm.cbR7.Checked;
        R8 := KonvPatForm.cbR8.Checked;
        W3 := StrToInt (KonvPatForm.ER3.Text);
        W4 := StrToInt (KonvPatForm.ER4.Text);
        W6 := StrToInt (KonvPatForm.ER6.Text);
        W7 := StrToInt (KonvPatForm.ER7.Text);
        W8 := StrToInt (KonvPatForm.ER8.Text);
      except
      end;
    end;
    Result := KonvPatForm.ModalResult = mrOK;
    KonvPatForm.Free;
    KonvPatForm := NIL;
  end;
end;

procedure TKonvPatForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then begin
    ModalResult := mrCancel;
    Key         := #0;
  end;
end;

end.
