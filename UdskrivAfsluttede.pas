unit UdskrivAfsluttede;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MatrixPrinter, ExtCtrls, StdCtrls, Buttons, ComCtrls;

type
  TUdAfslutForm = class(TForm)
    gbDatoer: TGroupBox;
    GroupBox1: TGroupBox;
    cbPrnNr: TComboBox;
    Panel1: TPanel;
    ButOK: TBitBtn;
    laMsg: TLabel;
    Label3: TLabel;
    dtFra: TDateTimePicker;
    Label1: TLabel;
    dtTil: TDateTimePicker;
    tpFra: TDateTimePicker;
    tpTil: TDateTimePicker;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButOKClick(Sender: TObject);
    procedure UdskrivListe;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PrnNr : Word;
  end;

  procedure UdskrivAfsluttedeListe;

var
  UdAfslutForm: TUdAfslutForm;

implementation

uses
  uC2Procs,
  DM;

{$R *.DFM}

procedure UdskrivAfsluttedeListe;
var
  GemIdx : String;
begin with MainDm, MatrixPrnForm do begin
  UdUafslutForm := TUdUafslutForm.Create (NIL);
  try
    GemIdx                          := ffEksOvr.IndexName;
    ffEksOvr.IndexName              := 'PakkeNrOrden';
    UdUafslutForm.laMsg.Caption     := '';
    UdUafslutForm.dtFra.Date        := Date;
    UdUafslutForm.dtTil.Date        := Date;
    UdUafslutForm.cbPrnNr.ItemIndex := 0;
    UdUafslutForm.ShowModal;
  finally
    UdUafslutForm.Free;
    UdUafslutForm := NIL;
    ffEksOvr.IndexName := GemIdx;
  end;
end; end;

procedure TUdAfslutForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    SelectNext (ActiveControl, TRUE, TRUE);
    Key := #0;
  end;
  if Key = #27 then begin
    ModalResult := mrCancel;
    Key         := #0;
  end;
end;

procedure TUdAfslutForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F6 then begin
    ButOK.Click;
    Key := 0;
  end;
end;

procedure TUdAfslutForm.FormActivate(Sender: TObject);
begin
  dtFra.SetFocus;
end;

procedure TUdAfslutForm.ButOKClick(Sender: TObject);
var
  PakkeNr : LongWord;
begin with MainDm, MatrixPrnForm do begin
  laMsg.Caption := 'Udskrift er igang !';
  UdUafslutForm.Update;
  Application.ProcessMessages;
  try
    PrnNr := StrToInt (Copy (cbPrnNr.Text, 1, 1));
    ffEksOvr.SetRange ([], []);
    try
      if PrnNr in [1..3] then begin
        AktPrinter  := Printere [PrnNr];
        UdskrivListe;
      end;
    finally
      ffEksOvr.CancelRange;
    end;
    laMsg.Caption := 'Udskrift er slut !';
    UdUafslutForm.Update;
    UdUafslutForm.ModalResult := mrOK;
  except
  end;
end; end;

procedure TUdAfslutForm.UdskrivListe;
var
  LinNr : Word;
begin with MainDm, MatrixPrnForm do begin
  ffEksOvr.First;
  while not ffEksOvr.Eof do begin
    for LinNr := 1 to ffEksOvrAntLin.Value do begin
      if ffEksLin.FindKey ([ffEksOvrLbNr.Value, LinNr]) then begin
        if ffEksTil.FindKey ([ffEksOvrLbNr.Value, LinNr]) then begin
          if ffEksOvrOrdreType.Value = 1 then begin
{
            Andel    := Andel     + ffEksTilAndel.AsCurrency;
            TilskSyg := TilskSyg  + ffEksTilTilskSyg.AsCurrency;
            TilskKom := TilskKom  + ffEksTilTilskKom1.AsCurrency;
            TilskKom := TilskKom  + ffEksTilTilskKom2.AsCurrency;
}
          end else begin
{
            Andel    := Andel     - ffEksTilAndel.AsCurrency;
            TilskSyg := TilskSyg  - ffEksTilTilskSyg.AsCurrency;
            TilskKom := TilskKom  - ffEksTilTilskKom1.AsCurrency;
            TilskKom := TilskKom  - ffEksTilTilskKom2.AsCurrency;
}
          end;
        end;
      end;
    end;
    ffEksOvr.Next;
  end;
end; end;

end.
