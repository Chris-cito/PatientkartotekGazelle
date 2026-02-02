unit ufrmIndtastTekst;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmIndtastTekst = class(TForm)
    lblVarenavn: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtDoserings: TEdit;
    edtIndtag: TEdit;
    bitOK: TBitBtn;
    procedure bitOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure IndtastTekst(AVareNavn : string;var ADosTekst : string;var AIndTekst : string);
  end;


implementation

{$R *.dfm}

{ TfrmIndtastTekst }

procedure TfrmIndtastTekst.bitOKClick(Sender: TObject);
begin
  if edtDoserings.Text = '' then
  begin
    ModalResult := mrNone;
    edtDoserings.SetFocus;
    exit;
  end;

  if edtIndtag.Text = '' then
  begin
    ModalResult := mrNone;
    edtIndtag.SetFocus;
    exit;
  end;
  ModalResult := mrOk;
end;

class procedure TfrmIndtastTekst.IndtastTekst(AVareNavn : string;var ADosTekst, AIndTekst: string);
begin
  with TfrmIndtastTekst.Create(Nil) do
  begin
    try
      lblVarenavn.Caption := AVareNavn;
      edtDoserings.Text := ADosTekst;
      edtIndtag.Text := AIndTekst;
      ShowModal;
      ADosTekst := edtDoserings.Text;
      ADosTekst := AnsiUpperCase(ADosTekst);
      if ADosTekst = '' then
        ADosTekst := 'IKKE ANGIVET';

      AIndTekst := edtIndtag.Text;
      AIndTekst := AnsiUpperCase(AIndTekst);
      if AIndTekst = '' then
        AIndTekst := 'IKKE ANGIVET';
    finally
      Free;

    end;

  end;
end;

end.
