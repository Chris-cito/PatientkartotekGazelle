unit ufrmBeskeder;

{ Developed by: Vitec Cito A/S

  Description: Show messages in eordre and allow editing

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  07-01-2021/cjs  Change ok button in FrmBeskeder to always return Modalresult=mrOK

}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,System.StrUtils;

type
  TfrmBeskeder = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel3: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function updateBeskeder: boolean;
  end;

implementation

uses DM;

{$R *.dfm}

procedure TfrmBeskeder.FormShow(Sender: TObject);
begin
  Memo1.Lines.Text := MainDM.nxOrdBeskedFraKunde.AsString;
  Memo2.Lines.Text := MainDM.nxOrdBeskedFraApotek.AsString;
  Memo2.SetFocus;
end;

class function TfrmBeskeder.updateBeskeder: boolean;
var
  LFrm: TfrmBeskeder;
begin
  LFrm := TfrmBeskeder.Create(Nil);
  try
    Result := LFrm.ShowModal = mrOk;
  finally
    LFrm.Free;
  end;
end;

procedure TfrmBeskeder.BitBtn1Click(Sender: TObject);
begin
  MainDM.nxOrd.Edit;
  MainDM.nxOrdBeskedFraApotek.AsString := Memo2.Lines.Text;
  // set status to klartilafhenting so message will get through
  if MatchText(MainDM.nxOrdOrdrestatus.AsString, ['KlarTilAfhentning', 'Ekspederet']) then
    MainDM.nxOrdOrdrestatus.AsString := 'KlarTilAfhentning';

  MainDM.nxOrd.Post;
end;

end.
