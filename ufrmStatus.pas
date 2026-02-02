unit ufrmStatus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Vcl.StdCtrls;

type
  TfrmStatus = class(TForm)
    RadioGroup1: TRadioGroup;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function skiftstatus: boolean;
  end;

implementation

uses DM;

{$R *.dfm}
{ TForm1 }

class function TfrmStatus.skiftstatus: boolean;
var
  LFrm: TfrmStatus;
begin
  LFrm := TfrmStatus.Create(Nil);
  try
    Result := LFrm.ShowModal = mrOk;
  finally
    LFrm.Free;
  end;
end;

procedure TfrmStatus.BitBtn1Click(Sender: TObject);
var
  newstr: string;
  ipos: integer;
  i: integer;
begin
  newstr := RadioGroup1.Items[RadioGroup1.itemindex];
  ipos := pos('&', newstr);
  if ipos <> 0 then
    Delete(newstr, ipos, 1);
  MainDM.nxOrd.Edit;
  MainDM.nxOrdOrdrestatus.AsString := newstr;
  i := RadioGroup1.itemindex;
  case i of
    0:
      MainDM.nxOrdPrintStatus.AsInteger := 0;

    1, 2, 3, 4:
      MainDM.nxOrdPrintStatus.AsInteger := 2;

    5, 6:
      MainDM.nxOrdPrintStatus.AsInteger := 99;

    7:
      begin
        MainDM.nxOrdOrdrestatus.AsString := 'Ekspederet';
        MainDM.nxOrdAfventerKundensGodkendelse.AsBoolean := True;
      end;

  end;
  MainDM.nxOrd.Post;

end;

procedure TfrmStatus.FormShow(Sender: TObject);
begin
  RadioGroup1.itemindex := 0;
  if SameText(MainDM.nxOrdOrdrestatus.AsString, 'Ny') then
    RadioGroup1.itemindex := 0;
  if SameText(MainDM.nxOrdOrdrestatus.AsString, 'UnderBehandling') then
    RadioGroup1.itemindex := 1;
  if SameText(MainDM.nxOrdOrdrestatus.AsString, 'Ekspederet') then
    RadioGroup1.itemindex := 2;
  if SameText(MainDM.nxOrdOrdrestatus.AsString, 'KlarTilAfhentning') then
    RadioGroup1.itemindex := 3;
  if SameText(MainDM.nxOrdOrdrestatus.AsString, 'Afsluttet') then
    RadioGroup1.itemindex := 4;
  if SameText(MainDM.nxOrdOrdrestatus.AsString, 'AnnulleretAfKunde') then
    RadioGroup1.itemindex := 5;
  if SameText(MainDM.nxOrdOrdrestatus.AsString, 'AnnulleretAfApotek') then
    RadioGroup1.itemindex := 6;

end;

end.
