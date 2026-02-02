unit uArkivKunde;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TfrmArkivKunde = class(TForm)
    Label1: TLabel;
    edtKundenr: TEdit;
    dtpTidyDate: TDateTimePicker;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowArkivKunde;
  end;

var
  frmArkivKunde: TfrmArkivKunde;

implementation

uses Main,C2WinApi;

{$R *.dfm}

{ TfrmArkivKunde }

procedure TfrmArkivKunde.ShowArkivKunde;
begin
  frmArkivKunde := TfrmArkivKunde.Create(Nil);
  try
    frmArkivKunde.ShowModal;
  finally
    frmArkivKunde.Free;
  end;
end;

procedure TfrmArkivKunde.FormShow(Sender: TObject);
begin
  dtpTidyDate.Date := IncMonth(now,-6);
  edtKundenr.Text := StamForm.SidKundeNr;
end;

procedure TfrmArkivKunde.BitBtn1Click(Sender: TObject);
var
  strparam : string;
begin
  strparam :=     '/KUNDE ' + edtKundenr.Text + ' ' + FormatDateTime('yyyy-mm-dd',dtpTidyDate.Date);
  C2ExecuteCS('G:\TidyTable.exe ' + strparam,1,1);
end;

end.
