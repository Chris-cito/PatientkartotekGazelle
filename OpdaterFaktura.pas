unit OpdaterFaktura;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons;

type
  TOpdaterForm = class(TForm)
    ButOK: TBitBtn;
    gbFaktura: TGroupBox;
    eNr: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    eNavn: TEdit;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure meEtiketterExit(Sender: TObject);
    procedure EAntalKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure ButOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure OpdaterFaktura (Auto : Word;
                         KontoNr : String;
                   var FakturaNr : LongWord);

var
  OpdaterForm: TOpdaterForm;

implementation

uses
  DM;

{$R *.DFM}

procedure OpdaterFaktura (Auto : Word;
                       KontoNr : String;
                 var FakturaNr : LongWord);
begin with MainDm do begin
  OpdaterForm := TOpdaterForm.Create (NIL);
  try
    OpdaterForm.Tag := Auto;
    OpdaterForm.ShowModal;
  finally
    OpdaterForm.Free;
    OpdaterForm := NIL;
  end;
end; end;

procedure TOpdaterForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    SelectNext (ActiveControl, TRUE, TRUE);
    Key := #0;
  end;
  if Key = #27 then begin
    ModalResult := mrCancel;
    Key         := #0;
  end;
end;

procedure TOpdaterForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F6 then begin
    ButOK.Click;
    Key := 0;
  end;
end;

procedure TOpdaterForm.FormShow(Sender: TObject);
begin
  eFra.SetFocus;
  if OpdaterForm.Tag > 0 then
    ButOK.Click;
end;

procedure TOpdaterForm.ButOKClick(Sender: TObject);
begin with MainDm do begin
  //
  ModalResult := mrOK;
end; end;

end.
