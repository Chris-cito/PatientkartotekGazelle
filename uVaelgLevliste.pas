unit uVaelgLevliste;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, DBGrids, Vcl.StdCtrls, Vcl.Grids;

type
  TfrmVaelgLevliste = class(TForm)
    dbgLevliste: TDBGrid;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    class function VaelgLeveringste : integer;
  end;


implementation

uses DM;

{$R *.dfm}

{ TForm1 }

class function TfrmVaelgLevliste.VaelgLeveringste : integer;
begin
  with TfrmVaelgLevliste.Create(Nil) do
  begin
    try
      Result := 0;
      if ShowModal = mrok then
        Result := MainDm.nqVaelgLevliste.fieldbyname('Listenr').AsInteger;

    finally
      Free;
    end;
  end;
end;

procedure TfrmVaelgLevliste.FormShow(Sender: TObject);
begin
  with MainDm do
  begin
    nqVaelgLevliste.Close;
    nqVaelgLevliste.Open;
  end;
end;

procedure TfrmVaelgLevliste.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    ModalResult := mrOk
  else
    if key = #27 then
      ModalResult := mrCancel;

end;

end.
