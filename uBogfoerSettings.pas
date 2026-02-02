unit uBogfoerSettings;

{ Developed by: Vitec Cito A/S

    Description: Screen to allow selection of parameters before printing faktura

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  29-09-2020/cjs  Initial version.
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, DM;

type
  TfrmBogfoerSettings = class(TForm)
    Panel1: TPanel;
    gbEmail: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    gbEmailTekst: TGroupBox;
    memEmailSubject: TMemo;
    gbCheckBoxes: TGroupBox;
    chkPrint: TCheckBox;
    chkEmailFaktura: TCheckBox;
    ActionManager1: TActionManager;
    acBogfoer: TAction;
    acFortryd: TAction;
    acPrint: TAction;
    acEmail: TAction;
    procedure acPrintExecute(Sender: TObject);
    procedure acEmailExecute(Sender: TObject);
    procedure acBogfoerExecute(Sender: TObject);
    procedure acFortrydExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ShowFakturaSettings(AUdskrivFaktura: boolean;
      AEmailFaktura: boolean): boolean;
  end;

var
  frmBogfoerSettings: TfrmBogfoerSettings;

implementation

{$R *.dfm}

uses
  ChkBoxes;

procedure TfrmBogfoerSettings.acBogfoerExecute(Sender: TObject);
begin
  if chkEmailFaktura.Checked then
  begin

    if memEmailSubject.Lines.Text.IsEmpty then
    begin
      if not ChkBoxYesNo('Text is empty. is that ok?',False) then
      begin
        ModalResult := mrNone;
        exit;
      end;
      maindm.UdskrivFakturaEmailTekst.Clear;

    end
    else
      maindm.UdskrivFakturaEmailTekst.Text := memEmailSubject.Lines.Text;


  end;

  ModalResult := mrOk;
end;

procedure TfrmBogfoerSettings.acEmailExecute(Sender: TObject);
begin
  maindm.UdskrivFakturaEmail := chkEmailFaktura.Checked;
  gbEmail.Enabled := maindm.UdskrivFakturaEmail;
  if not maindm.UdskrivFakturaEmail then
  begin
    memEmailSubject.Clear;
    maindm.UdskrivFakturaEmailTekst.Clear;
  end;
  if chkEmailFaktura.Checked then
    memEmailSubject.SetFocus;


end;

procedure TfrmBogfoerSettings.acFortrydExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmBogfoerSettings.acPrintExecute(Sender: TObject);
begin
  maindm.UdskrivFakturaPrint := acPrint.Checked;
end;

procedure TfrmBogfoerSettings.FormShow(Sender: TObject);
begin
  chkPrint.Checked := MainDm.UdskrivFakturaPrint;
  chkEmailFaktura.Checked := maindm.UdskrivFakturaEmail;
  gbEmail.Enabled := chkEmailFaktura.Checked;
  memEmailSubject.Clear;
end;

class function TfrmBogfoerSettings.ShowFakturaSettings(AUdskrivFaktura: boolean;
  AEmailFaktura: boolean): boolean;
begin
  Result := False;
  with TfrmBogfoerSettings.Create(Nil) do
  begin
    try
      maindm.UdskrivFakturaEmailTekst.Clear;
      maindm.UdskrivFakturaPrint := AUdskrivFaktura;
      MainDm.UdskrivFakturaEmail := AEmailFaktura;
      Result := ShowModal = mrOk;

    finally
      Free;
    end;

  end;
end;

end.
