unit frmKomLst;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGrids, Vcl.Grids;

type
  TfrmKomEanLst = class(TForm)
    DBGrid1: TDBGrid;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    class function KomLst : integer ;
  end;


implementation



{$R *.dfm}

{ TForm1 }

class function TfrmKomEanLst.KomLst : integer ;

begin
  with TfrmKomEanLst.Create(Nil) do
  begin
    try
      Result := ShowModal;
    finally
      Free;
    end;

  end;

end;

procedure TfrmKomEanLst.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key,[#13,#27]) then
    exit;
  if key = #13 then
    ModalResult := mrOk;

  if Key = #27 then
    ModalResult := mrCancel;
end;

end.
