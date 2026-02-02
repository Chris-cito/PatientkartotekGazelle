unit uRowaUdtag;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, Vcl.StdCtrls;

type
  TfrmRowaUdtag = class(TForm)
    RadioGroup1: TRadioGroup;
    BitBtn1: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowUdtag(loks : string; var outputlok : string);
  end;

var
  frmRowaUdtag: TfrmRowaUdtag;
  processloks : string;
  chosenlok : string;
implementation

{$R *.dfm}

{ TfrmRowaUdtag }

procedure TfrmRowaUdtag.ShowUdtag(loks: string; var outputlok: string);
begin
  if pos('/',loks) = 0 then
  begin
    outputlok := loks;
    exit;
  end;
  processloks := loks;
  frmRowaUdtag := TfrmRowaUdtag.Create(Nil);
  try
    frmRowaUdtag.ShowModal;
    outputlok := chosenlok;
  finally
    frmRowaUdtag.Free;
  end;
end;

procedure TfrmRowaUdtag.FormShow(Sender: TObject);
var
  i : integer;

begin
  i := pos('/',processloks);
  while i <> 0 do
  begin
    RadioGroup1.Items.Add(copy(processloks,1,i-1));
    delete(processloks,1,i);
    i := pos('/',processloks);
  end;
  if processloks <> '' then
    RadioGroup1.Items.Add(trim(processloks));
  RadioGroup1.ItemIndex := 0;
end;

procedure TfrmRowaUdtag.BitBtn1Click(Sender: TObject);
begin
  chosenlok := RadioGroup1.Items[RadioGroup1.Itemindex];

end;

end.
