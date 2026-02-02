unit uDebKontrol;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls,System.DateUtils,
  Data.DB, nxdb,uc2Environment;

type
  TfrmDebKont = class(TForm)
    Label1: TLabel;
    edtKonto: TEdit;
    dtpStart: TDateTimePicker;
    dtpSlut: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    nqDebKont: TnxQuery;
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowDebKont;
  end;


implementation

uses DM,ChkBoxes, PatMatrixPrinter,uc2ui.procs;

{$R *.dfm}

{ TfrmDebKont }

class procedure TfrmDebKont.ShowDebKont;
var
  LFrm : TfrmDebKont;
begin
  LFrm := TfrmDebKont.Create(Nil);
    try
    LFrm.ShowModal;
    finally
    LFrm.Free;
  end;
end;

procedure TfrmDebKont.FormActivate(Sender: TObject);
begin
  dtpStart.Date := DateOf(Date) -7;
  dtpSlut.Date := DateOf(Date);
end;

procedure TfrmDebKont.BitBtn1Click(Sender: TObject);
var
  sl : TStringList;
  PNr : word;
  cstar : string;
begin
  BusyMouseBegin;
  BitBtn1.Enabled := False;
  BitBtn2.Enabled := False;
  try

    if edtKonto.Text = '' then
    begin
     ChkBoxOK('Kontonr cannot be blank');
     ModalResult := mrNone;
     exit;
    end;
    nqDebKont.Database := MainDm.nxdb;
    nqDebKont.close;
    nqDebKont.Timeout := 100000;
    nqDebKont.SQL.Clear;
    nqDebKont.SQL.Add('declare startlbnr integer;');
    nqDebKont.SQL.Add('declare endlbnr integer;');
    nqDebKont.SQL.Add('set startlbnr=(select top 1 lbnr from ekspeditioner where cast(takserdato as date) < cast(:startdate as date) order by lbnr desc);');
    nqDebKont.SQL.Add('set endlbnr=(select top 1 lbnr from ekspeditioner where cast(takserdato as date) <= cast(:enddate as date) order by lbnr desc);');

    nqDebKont.SQL.Add('SELECT');
    nqDebKont.SQL.Add('	lbnr');
    nqDebKont.SQL.Add('	,takserdato');
    nqDebKont.SQL.Add('	,kontrolfejl');
    nqDebKont.SQL.Add('	,fakturanr');
    nqDebKont.SQL.Add('	,Pakkenr');
    nqDebKont.SQL.Add('	,navn');
    nqDebKont.SQL.Add('	,kontonr');
    nqDebKont.SQL.Add('FROM');
    nqDebKont.SQL.Add('	"Ekspeditioner"');
    nqDebKont.SQL.Add('WHERE');
    nqDebKont.SQL.Add('	lbnr>startlbnr and lbnr<=endlbnr');
    nqDebKont.SQL.Add('	and kontonr=:kontonr');
    nqDebKont.SQL.Add('	and (brugerkontrol=0 or kontrolfejl=9);');
    nqDebKont.ParamByName('kontonr').AsString := edtKonto.Text;
    nqDebKont.ParamByName('startdate').AsString := FormatDateTime('yyyy-mm-dd',dtpStart.Date);
    nqDebKont.ParamByName('enddate').AsString := FormatDateTime('yyyy-mm-dd',dtpSlut.Date);
    nqDebKont.Open;
    try
      if nqDebKont.RecordCount = 0 then
      begin
        ChkBoxOK('Alle ekspeditioner er kontrollerede.');
        exit;
      end;

      sl := TStringList.Create;
      try
        nqDebKont.First;
        while not nqDebKont.Eof do
        begin
          cstar := '';
          if nqDebKont.FieldByName('KontrolFejl').AsInteger = 9 then
            cstar := 'F9';
          sl.Add(format('%-10s %-10d %-10s %-10s %-30s %s',
                  [
                  formatdatetime('dd-mm-yy',nqDebKont.FieldByName('TakserDato').AsDateTime),
                  nqDebKont.FieldByName('LbNr').AsInteger,
                  nqDebKont.FieldByName('FakturaNr').asstring,
                  nqDebKont.FieldByName('PakkeNr').asstring,
                  nqDebKont.FieldByName('Navn').AsString,
                  cstar
                  ]));
          nqDebKont.Next;
        end;

        sl.Insert(0, '');
        sl.Insert(0, 'Dato       Lbnr       Fakturanr  Pakkenr    Navn');
  //      UdLst.Insert(0, '         1         2         3         4         5         6         7;
  //      UdLst.Insert(0, '123456789012345678901234567890123 xnnnnnnnxnnnnnnnxnnnnnnn nnn,nnn.nn nn;
        sl.Insert(0, '');
        sl.Insert(0, '');
        sl.Insert(0, 'Konto : ' + edtKonto.Text + ' ' + nqDebKont.FieldByName('Navn').AsString);
        sl.Insert(0, '');
        sl.Insert(0, MainDm.ffFirmaNavn.AsString);
        sl.Insert(0, 'D E B I T O R K O N T R O L L I S T E');

        sl.SaveToFile('C:\C2\Temp\DebKontrol.txt');
      finally
        sl.Free;
      end;
      PNr := 0;
      PatMatrixPrnForm.PrintMatrix(Pnr,'C:\C2\Temp\DebKontrol.txt');

    finally
      nqDebKont.Close;
    end;
  finally
    BitBtn1.Enabled := True;
    BitBtn2.Enabled := True;
    BusyMouseEnd;
  end;
end;

procedure TfrmDebKont.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key,[#13,#27]) then
    exit;
  if key = #27 then
  begin
    ModalResult := mrCancel;
    exit;
  end;

  if key = #13 then
  begin
    SelectNext (ActiveControl, TRUE, TRUE);
    key := #0;
    exit;
  end;


end;

end.


