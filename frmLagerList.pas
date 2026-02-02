unit frmLagerList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DBCtrls;

type
  TfrmDebLagListe = class(TForm)
    BitBtn1: TBitBtn;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ShowLagerListe : integer;
  end;

var
  frmDebLagListe: TfrmDebLagListe;

implementation

uses DM;

{$R *.dfm}

function TfrmDebLagListe.ShowLagerListe: integer;
var
  frmDebLagListe : TfrmDebLagListe;
begin
  frmDebLagListe := TfrmDebLagListe.Create(Nil);
  try
    Result := frmDebLagListe.ShowModal;
  finally
    frmDebLagListe.Free;
  end;

end;

procedure TfrmDebLagListe.FormShow(Sender: TObject);

begin
  with MainDm do begin
    nxDebAfd.IndexName := 'NrOrden';
    nxDebAfd.first;
    ListBox1.Clear;
    while not nxDebAfd.Eof do
    begin
      ListBox1.Items.Addobject(nxDebAfdNavn.AsString,TObject(nxDebAfdRefNr.AsInteger));
      if nxDebAfdRefNr.AsInteger = mtEksAfdeling.AsInteger then
        ListBox1.ItemIndex := ListBox1.Count - 1;
      nxDebAfd.Next;

    end;

    nxDebLag.IndexName := 'NrOrden';
    nxDebLag.First;
    while not nxDebLag.Eof do
    begin
      ListBox2.Items.AddObject(nxDebLagNavn.AsString,TObject(nxDebLagRefNr.AsInteger));
      if nxDebLagRefNr.AsInteger = mtEksLager.AsInteger then
        ListBox2.ItemIndex := ListBox2.Count - 1;

      nxDebLag.Next;
    end;
    ListBox1.SetFocus;
  end;
end;

procedure TfrmDebLagListe.BitBtn1Click(Sender: TObject);
var
   i: integer;
begin
  with MainDm do
  begin
    i := integer(ListBox1.Items.Objects[ListBox1.ItemIndex]);
    nxDebAfd.FindKey([i]);

    i := integer(ListBox2.Items.Objects[ListBox2.ItemIndex]);
    nxDebLag.FindKey([i]);


  end;
end;

end.
