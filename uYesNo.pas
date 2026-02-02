unit uYesNo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmYesNo = class(TForm)
    Memo1: TMemo;
    btnJa: TButton;
    btnNej: TButton;
    btnOk: TButton;
    Panel1: TPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnJaClick(Sender: TObject);
    procedure btnNejClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function NewYesNoBox(text : string) : boolean;
    function NewOKBox(text: string): boolean;
  end;

var
  frmYesNo: TfrmYesNo;
  messstr : string;
  okbox : boolean;

implementation

{$R *.dfm}

uses C2MainLog;
{ TfrmYesNo }

function TfrmYesNo.NewYesNoBox(text: string): boolean;
begin
  okbox := False;
  C2LogAdd('New YesNoBox : ' + text);
  frmYesNo := TfrmYesNo.Create(Nil);
  try
    messstr := text;
    Result := frmYesNo.ShowModal = mrOk;
    C2LogAdd(' Result in YesNoBox is ' + BoolToStr(Result,True));
  finally
    frmYesNo.Free;
  end;
end;

function TfrmYesNo.NewOKBox(text: string): boolean;
begin
  C2LogAdd('New OKBox : ' + text);
  okbox := true;
  frmYesNo := TfrmYesNo.Create(Nil);
  try
    messstr := text;
    Result := frmYesNo.ShowModal = mrOk;
  finally
    frmYesNo.Free;
  end;
end;

procedure TfrmYesNo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key  in [13,27] then
  begin
    key := 0;
    exit;
  end;

  if okbox then
  begin
    if key = ord('O') then
      ModalResult := mrOk;

  end
  else
  begin
    if key = ord('J') then
      ModalResult := mrOk;



    if Key = ord('N') then
      ModalResult := mrCancel;
  end;



end;
procedure TfrmYesNo.FormShow(Sender: TObject);
begin
  Application.NormalizeTopMosts;
  Memo1.Text := messstr;
  if Memo1.Lines.Count > 7 then
  begin
    frmYesNo.Height := frmYesNo.Height +  (Memo1.Lines.Count -7)  * 15;
    Panel1.Height := Panel1.Height + (Memo1.Lines.Count -7) *15
  end;
  if okbox then
  begin
    btnJa.Visible := False;
    btnNej.Visible := False;
    btnOk.Visible := True;
    frmYesNo.Caption := 'OK?';
  end
  else
  begin
    btnJa.Visible := true;
    btnNej.Visible := True;
    btnOk.Visible := False;
    frmYesNo.Caption := 'Vælg Ja / Nej';
  end;
  Panel1.SetFocus;
end;


procedure TfrmYesNo.btnOkClick(Sender: TObject);
begin
      ModalResult := mrOk;

end;

procedure TfrmYesNo.btnJaClick(Sender: TObject);
begin
      ModalResult := mrOk;

end;

procedure TfrmYesNo.btnNejClick(Sender: TObject);
begin
      ModalResult := mrCancel;

end;

end.


