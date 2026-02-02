unit ufrmMini;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw;

type
  TfrmMini = class(TForm)
    WebBrowser1: TWebBrowser;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FMiniVarenr: string;
    procedure SetMiniVarenr(const Value: string);
    { Private declarations }
    property   MiniVarenr : string read FMiniVarenr write SetMiniVarenr;
  public
    class procedure ShowMiniInfo(varenr:string);
    { Public declarations }
  end;

implementation

uses DM, C2MainLog;


{$R *.dfm}

procedure TfrmMini.FormActivate(Sender: TObject);
var
  save_index : string;
  weburl : WideString;
  MiniInfoServer : string;

begin
  with MainDm do begin
    save_index := ffLagKar.IndexName;
    ffLagKar.IndexName := 'NrOrden';
    try
      if not ffLagKar.FindKey([0,trim(minivarenr)]) then
        exit;
      MiniInfoServer := C2StrPrm('MiniInfo','Server','10.201.2.65');
      weburl := 'http://' +MiniInfoServer + '/servlet/Miniinf?Varenr=' +
          trim(ffLagKarVareNr.AsString)   +
          '&Atckode=' + Trim(ffLagKarAtcKode.AsString) +
          '&Vareform=' + trim(ffLagKarForm.AsString) +
          '&Ejer=DA';
      c2logadd('webburl is ' + weburl);
       WebBrowser1.navigate(weburl);
    finally
      ffLagKar.IndexName := save_index;
    end;
  end;
end;

procedure TfrmMini.FormKeyPress(Sender: TObject; var Key: Char);
begin

  if key = #27 then
    ModalResult := mrCancel;
end;

procedure TfrmMini.SetMiniVarenr(const Value: string);
begin
  if FMiniVarenr <> Value then
    FMiniVarenr := Value;
end;

class procedure TfrmMini.ShowMiniInfo(varenr:string);
begin
  with TfrmMini.Create(Nil) do
  begin
    try
      MiniVarenr := varenr;
      ShowModal;
    finally
      Free;
    end;
  end;
end;

end.
