unit VisInteraktion;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, DBCtrls, ComCtrls, Vcl.Mask;

type
  TfmInteraktion = class(TForm)
    pcInt: TPageControl;
    tsChk: TTabSheet;
    tsLst: TTabSheet;
    gbInt: TGroupBox;
    meChkInt: TMemo;
    gbVej: TGroupBox;
    gbBut: TGroupBox;
    buOk: TBitBtn;
    Label1: TLabel;
    dbeLstAtc1: TDBEdit;
    Label2: TLabel;
    dbeLstAtc2: TDBEdit;
    Label3: TLabel;
    dbeLstAdvNr: TDBEdit;
    Label4: TLabel;
    dbeLstVejNr: TDBEdit;
    Label5: TLabel;
    dbeLstNiveau: TDBEdit;
    dbcbLstStar: TDBCheckBox;
    dbmeLstVej: TDBMemo;
    buUdEtk: TBitBtn;
    buA4: TBitBtn;
    sbOver: TSpeedButton;
    dbmeChkVej: TDBMemo;
    procedure tsLstEnter(Sender: TObject);
    procedure buUdEtkClick(Sender: TObject);
    procedure buA4Click(Sender: TObject);
    procedure sbOverClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ScrollVej(dbMe: TDBMemo);
    procedure tsChkEnter(Sender: TObject);
    procedure tsChkExit(Sender: TObject);
    procedure tsLstShow(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure VisIntTekst(APage: Integer; const ATxt: String);
  end;

var
  fmInteraktion: TfmInteraktion;

implementation

uses
  DM, UbiPrinter, PatMatrixPrinter;

{$R *.DFM}

class procedure TfmInteraktion.VisIntTekst(APage: Integer; const ATxt: String);
var
  fmInteraktion: TfmInteraktion;
begin
  fmInteraktion := TfmInteraktion.Create(NIL);
  try
    fmInteraktion.meChkInt.Text := ATxt;
    case APage of
      0:
        fmInteraktion.pcInt.ActivePage := fmInteraktion.tsChk;
      1:
        fmInteraktion.pcInt.ActivePage := fmInteraktion.tsLst;
    end;
    fmInteraktion.ShowModal;
  finally
    fmInteraktion.Free;
  end;
end;

procedure TfmInteraktion.buUdEtkClick(Sender: TObject);
var
  lns: TStringList;
  tmpsl: TStringList;
  i: Integer;
  labstr: string;
  deleting: boolean;
  tmpstr: string;
  LString: string;
begin
  lns := TStringList.Create;
  tmpsl := TStringList.Create;
  try
    lns.Add('INTERAKTIONER');
    tmpsl.Assign(meChkInt.Lines);
    for LString in tmpsl do
    begin
      tmpstr := copy(LString, 1, 34);
      lns.Add(StringReplace(tmpstr, '"', '', [rfReplaceAll]));
    end;
    if MainDm.ffIntTxtType.AsInteger = 1 then
    begin
      tmpstr := MainDm.ffIntTxtTekst.AsString;
      labstr := StringReplace(tmpstr, '"', '', [rfReplaceAll]);
      if length(labstr) <= 34 then
        lns.Add(labstr)
      else
      begin
        lns.Add(copy(labstr, 1, 34));
        lns.Add(copy(labstr, 35, 30));
      end;
    end
    else
    begin
      tmpsl.Text := MainDm.ffIntTxtTekst.AsString;
      deleting := true;
      while deleting do
      begin
        if tmpsl.Strings[0] = 'ADVARSEL:' then
        begin
          labstr := trim(tmpsl.Strings[1]);
          deleting := false;
        end;
        tmpsl.Delete(0);
      end;
      labstr := StringReplace(labstr, '"', '', [rfReplaceAll]);
      if length(labstr) <= 34 then
        lns.Add(labstr)
      else
      begin
        lns.Add(copy(labstr, 1, 34));
        lns.Add(copy(labstr, 35, 30));
      end;

    end;
    fmUbi.PrintDosEtik('A P O T E K E T', FormatDateTime('dd-mm-yy', Date), 'INIT', lns, '', '', '', '', '', '', '', '', '', 1,
      true, true);
    fmUbi.PrintTotalEtiket;
  finally
    tmpsl.Free;
    lns.Free;
    ModalResult := mrOK;
  end;
end;

procedure TfmInteraktion.buA4Click(Sender: TObject);
var
  lns: TStringList;
  tmpsl: TStringList;
  i: Integer;
  labstr: string;
  pnr: Word;
begin
  lns := TStringList.Create;
  tmpsl := TStringList.Create;
  try
    lns.Add('INTERAKTIONER');
    lns.Add(meChkInt.Text);
    tmpsl.Assign(dbmeChkVej.Lines);

    for labstr in tmpsl do
      lns.Add(labstr);
    lns.SaveToFile('C:\C2\Temp\Interaktlist.Txt');
    patMatrixPrnForm.PrintMatrix(pnr, 'C:\C2\Temp\Interaktlist.Txt');

  finally
    tmpsl.Free;
    lns.Free;
    ModalResult := mrOK;
  end;
end;

procedure TfmInteraktion.sbOverClick(Sender: TObject);
begin
  //
end;

procedure TfmInteraktion.ScrollVej(dbMe: TDBMemo);
var
  Key1, Key2: Word;
begin
  dbMe.DataSource := NIL;
  Key1 := 2;
  Key2 := MainDm.ffIntAktVejlNr.AsInteger;
  if Key2 = 0 then
  begin
    // Benyt advarsel
    Key1 := 1;
    Key2 := MainDm.ffIntAktAdvNr.AsInteger;
  end;
  // Find text
  if MainDm.ffIntTxt.FindKey([Key1, Key2]) then
    dbMe.DataSource := MainDm.dsIntTxt;
end;

procedure TfmInteraktion.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if pcInt.ActivePage <> tsLst then
    exit;

  // Kun bladre taster på denne page
  if Shift = [] then
  begin
    if Key in [VK_HOME, VK_NEXT, VK_PRIOR, VK_END] then
    begin
      case Key of
        VK_HOME:
          MainDm.ffIntAkt.First;
        VK_NEXT:
          MainDm.ffIntAkt.Next;
        VK_PRIOR:
          MainDm.ffIntAkt.Prior;
        VK_END:
          MainDm.ffIntAkt.Last;
      end;
      ScrollVej(dbmeLstVej);
      Key := 0;
    end;
  end
  else
  begin
    if (Shift = [ssAlt]) and (Key = VK_DOWN) then
    begin
      if ActiveControl = dbeLstAtc1 then
        Key := 0;
    end;
  end;
end;

procedure TfmInteraktion.tsChkEnter(Sender: TObject);
begin
  MainDm.ffIntAkt.Refresh;
  ScrollVej(dbmeChkVej);
end;

procedure TfmInteraktion.tsChkExit(Sender: TObject);
begin
  MainDm.ffIntAkt.CancelRange;
end;

procedure TfmInteraktion.tsLstEnter(Sender: TObject);
begin
  MainDm.ffIntAkt.Refresh;
  ScrollVej(dbmeLstVej);
end;

procedure TfmInteraktion.tsLstShow(Sender: TObject);
begin
  dbeLstAtc1.SetFocus;
end;

procedure TfmInteraktion.FormShow(Sender: TObject);
begin
  MainDm.ffIntAkt.Refresh;
  ScrollVej(dbmeChkVej);
end;

end.
