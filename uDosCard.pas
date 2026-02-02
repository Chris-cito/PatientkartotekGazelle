unit uDosCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Data.DB, nxdb;

type
  TfrmDosKort = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtCardNumber: TEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    edtPakke: TEdit;
    GroupBox3: TGroupBox;
    btnOK: TBitBtn;
    BitBtn2: TBitBtn;
    chkDosis: TCheckBox;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    edtLevnr: TEdit;
    GroupBox5: TGroupBox;
    rgSort: TRadioGroup;
    chkAfstempling: TCheckBox;
    nqSelectDos: TnxQuery;
    procedure btnOKClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    ResultType : integer;
  public
    { Public declarations }
    class function SelectDoskort : integer;
  end;


implementation

uses DM,chkBoxes, Main,uC2ui.procs;

{$R *.dfm}

{ TfrmDosKort }

class function TfrmDosKort.SelectDoskort: integer;
begin
  with TfrmDosKort.Create(Nil) do
  begin
    try
      ShowModal;
      Result := ResultType;
    finally
      Free;
    end;
  end;
end;

procedure TfrmDosKort.btnOKClick(Sender: TObject);
var
  itmp : integer;
  sl : TStringList;
begin
  with MainDm do
  begin
    BusyMouseBegin;
    sl := TStringList.Create;
    btnOK.Enabled := False;
    BitBtn2.Enabled := False;
    try
      ResultType := 0;
      StamForm.TakserDosisKortAuto := chkDosis.Checked;
      StamForm.Undladafstemplingsetiketter := chkAfstempling.Checked;
      if edtCardNumber.Text <> '' then
      begin

        if not TryStrToInt(edtCardNumber.Text,itmp) then
        begin
          ChkBoxOK('Dosiskortnummer skal være et nummer');
          ModalResult := mrNone;
          exit;
        end;

        ffdch.IndexName := 'Cardnumber';
        if not ffdch.FindKey([itmp]) then
        begin
          ChkBoxOK('Dosiskort ikke findes');
          ModalResult := mrNone;
          exit;
        end;
        if ffdchDeleteDate.AsString <> '' then
        begin
          ChkBoxOK('Dosiskortet er slettet og kan derfor ikke takseres');
          ModalResult := mrNone;
          exit;
        end;
        ModalResult := mrOk;
        ResultType := 1;
        exit;
      end;

      if edtPakke.Text <> '' then
      begin
        if not TryStrToInt(edtPakke.Text,itmp) then
        begin
          ChkBoxOK('Pakkegruppe nummer skal være et nummer');
          ModalResult := mrNone;
          exit;
        end;
        StamForm.DosisPakkeGruppeFileName := 'G:\Temp\DosPakkeList' + edtPakke.Text +'.txt';
        if FileExists(StamForm.DosisPakkeGruppeFileName) then
        begin

          if not ChkBoxYesNo('Vil du fortsætte igangværende ekspedition af pakkeliste?',True) then
          begin
            if ChkBoxYesNo('Skal listen nulstilles?',False) then
              DeleteFile(StamForm.DosisPakkeGruppeFileName)
            else
            begin
              ResultType := 0;
              ModalResult := mrCancel;
              exit;
            end;
          end
          else
          begin
            ResultType := 2;
            ModalResult := mrOK;
            exit;
          end;
        end;
        nqSelectDos.Database := nxdb;
        nqSelectDos.Close;
        if edtLevnr.Text = '' then
        begin
          nqSelectDos.SQL.Clear;
          nqSelectDos.SQL.Add('SELECT');
          nqSelectDos.SQL.Add('       cardnumber');
          nqSelectDos.SQL.Add('FROM');
          nqSelectDos.SQL.Add('     "Dosiscardheader"');
          nqSelectDos.SQL.Add('where');
          nqSelectDos.SQL.Add('	parked = false and');
          nqSelectDos.SQL.Add('	packgroupnumber= :packgrnumber and');
          nqSelectDos.SQL.Add('	deletedate is null and');
          nqSelectDos.SQL.Add('	cast(enddate as date) >=current_date');
          nqSelectDos.SQL.Add('order by');
            case rgSort.ItemIndex of
            0: nqSelectDos.SQL.add('Cardnumber');
            1: nqSelectDos.SQL.add('PatientNumber');
            2: nqSelectDos.SQL.add('PatientName ignore case');
          end;
          nqSelectDos.ParamByName('packgrnumber').AsInteger := itmp;

        end
        else
        begin
          nqSelectDos.SQL.Clear;
          nqSelectDos.SQL.Add('SELECT');
          nqSelectDos.SQL.Add('       cardnumber');
          nqSelectDos.SQL.Add('FROM');
          nqSelectDos.SQL.Add('     "Dosiscardheader" as DCH');
          nqSelectDos.SQL.Add('inner join patientkartotek as pat on pat.kundenr=dch.PatientNumber');
          nqSelectDos.SQL.Add('where');
          nqSelectDos.SQL.Add('	parked = false');
          nqSelectDos.SQL.Add('	and deletedate is null');
          nqSelectDos.SQL.Add('	and cast(enddate as date) >=current_date');
          nqSelectDos.SQL.Add('	and PackGroupNumber=:packgrnumber');
          nqSelectDos.SQL.Add('	and pat.levnr=:levnr');
          nqSelectDos.SQL.Add('order by');
          case rgSort.ItemIndex of
            0: nqSelectDos.SQL.Add('CardNumber');
            1: nqSelectDos.SQL.Add('PatientNumber');
            2: nqSelectDos.SQL.Add('PatientName ignore case');
          end;
          nqSelectDos.ParamByName('packgrnumber').AsInteger := itmp;
          nqSelectDos.ParamByName('levnr').AsString := trim(edtLevnr.Text);

        end;
        nqSelectDos.Open;
        if nqSelectDos.RecordCount = 0 then
        begin
          if edtLevnr.Text = '' then
            ChkBoxOK('Der er ingen dosiskort i denne pakkegruppe.')
          else
            ChkBoxOK('Der er ingen dosiskort i denne pakkegruppe/levnr.');
          ModalResult := mrnone;
          exit;
        end;
        nqSelectDos.First;
        while not nqSelectDos.Eof do
        begin
          sl.Add(nqSelectDos.fieldbyname('Cardnumber').AsString);
          nqSelectDos.Next;
        end;
        sl.SaveToFile(StamForm.DosisPakkeGruppeFileName);
        ResultType := 2;

        ModalResult := mrOk;
        exit;
      end;


      if edtLevnr.Text <> '' then
      begin
        if not TryStrToInt(edtLevnr.Text,itmp) then
        begin
          ChkBoxOK('Pakkegruppe nummer skal være et nummer');
          ModalResult := mrNone;
          exit;
        end;
        StamForm.DosisPakkeGruppeFileName := 'G:\Temp\DosPakkeList' + edtPakke.Text +'.txt';
        if FileExists(StamForm.DosisPakkeGruppeFileName) then
        begin

          if not ChkBoxYesNo('Vil du fortsætte igangværende ekspedition af pakkeliste?',True) then
          begin
            if ChkBoxYesNo('Skal listen nulstilles?',False) then
              DeleteFile(StamForm.DosisPakkeGruppeFileName)
            else
            begin
              ResultType := 0;
              ModalResult := mrCancel;
              exit;
            end;
          end
          else
          begin
            ResultType := 2;
            ModalResult := mrOK;
            exit;
          end;
        end;

        nqSelectDos.Database := nxdb;
        nqSelectDos.Close;
        nqSelectDos.SQL.Clear;
        nqSelectDos.SQL.Add('SELECT');
        nqSelectDos.SQL.Add('	cardnumber');
        nqSelectDos.SQL.Add('from');
        nqSelectDos.SQL.Add('     "Dosiscardheader" as dch');
        nqSelectDos.SQL.Add('inner join patientkartotek as pat on pat.kundenr=dch.PatientNumber');
        nqSelectDos.SQL.Add('where');
        nqSelectDos.SQL.Add('	parked = false');
        nqSelectDos.SQL.Add('	and deletedate is null');
        nqSelectDos.SQL.Add('	and cast(enddate as date) >=current_date');
        nqSelectDos.SQL.Add(' and   pat.levnr=:levnr');
        nqSelectDos.SQL.Add('order by');
        case rgSort.ItemIndex of
          0: nqSelectDos.SQL.Add('cardnumber');
          1: nqSelectDos.SQL.Add('PatientNumber');
          2: nqSelectDos.SQL.Add('PatientName ignore case');
        end;
        nqSelectDos.ParamByName('levnr').AsString := trim(edtLevnr.Text);
        try
          nqSelectDos.Open;
        except
          on E: Exception do
            ChkBoxOK(e.Message);
        end;
        if nqSelectDos.RecordCount = 0 then
        begin
          ChkBoxOK('Der er ingen dosiskort i denne levnr.');
          ModalResult := mrnone;
          exit;
        end;
        nqSelectDos.First;
        while not nqSelectDos.Eof do
        begin
          sl.Add(nqSelectDos.fieldbyname('Cardnumber').AsString);
          nqSelectDos.Next;
        end;
        sl.SaveToFile(StamForm.DosisPakkeGruppeFileName);
        ResultType := 2;

        ModalResult := mrOk;
        exit;
      end;


    finally
      sl.Free;
      btnOK.Enabled := True;
      BitBtn2.Enabled := True;
      BusyMouseEnd;
    end;
  end;
end;

procedure TfrmDosKort.BitBtn2Click(Sender: TObject);
begin
  ResultType := 0;
end;

procedure TfrmDosKort.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key,[#13,#27]) then
    exit;
  if key = #27 then
  begin
    ResultType := 0;
    ModalResult := mrCancel;
    exit;
  end;

  if key = #13 then
  begin
      SelectNext (ActiveControl, TRUE, TRUE);
      Key := #0;
  end;

end;

procedure TfrmDosKort.FormActivate(Sender: TObject);
begin
  chkDosis.Checked := True;
  rgSort.ItemIndex := 0;
  ResultType := 0;
end;

end.
