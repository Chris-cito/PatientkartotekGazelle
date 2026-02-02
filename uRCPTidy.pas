unit uRCPTidy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, uFMKCalls;

type
  TfrmRCPTidy = class(TForm)
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    dtpStartDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    RadioGroup1: TRadioGroup;
    Label3: TLabel;
    edtArsag: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    sl : TStringList;
  public

    { Public declarations }
    procedure RCPTidy(iMode : integer);
  end;

var
  frmRCPTidy: TfrmRCPTidy;
  TidyMode : integer;

implementation

uses DM, C2MainLog, uC2Fmk.Common.Types;

{$R *.dfm}

{ TfrmRCPTidy }

procedure TfrmRCPTidy.RCPTidy(iMode :integer);
begin
  frmRCPTidy := TfrmRCPTidy.Create(Nil);
  try
    TidyMode := iMode;
    frmRCPTidy.ShowModal;
  finally
    frmRCPTidy.Free;
  end;
end;

procedure TfrmRCPTidy.FormShow(Sender: TObject);
begin
  dtpStartDate.Date := Now - 28;
  dtpEndDate.Date := Now - 14;
  RadioGroup1.ItemIndex := 0;
  case TidyMode of
    1:
      Label5.Caption :=
        'Denne funktion vil slette lokale receptkvitteringer, der ikke er ekspederet og sende dem tilbage til FMK.'
        + #13#10 +
        'Hvis nogle receptkvitteringer af en eller anden grund ikke kan returneres til FMK, vil de blot blive slettet lokalt.';
    2:
    begin
          label5.Caption := 'Alle ekspederede receptkvitteringer, ældre end den indtastede dato, vil blive slettet. Bemærk at receptkvitteringerne skal være mindst 3 måneder gamle, før de kan slettes.'
              +#13#10 +'(Reitererede slettes først efter 2 år.)';
          dtpStartDate.Date := Now - 90;
          label2.Enabled := False;
          dtpEndDate.Enabled := False;
          RadioGroup1.Enabled := False;
          Label3.Enabled := False;
          edtArsag.Enabled := False;
    end;
  end;
end;

procedure TfrmRCPTidy.RadioGroup1Click(Sender: TObject);
begin
  edtArsag.Enabled := RadioGroup1.ItemIndex = 1;
  IF edtArsag.Enabled then
    edtArsag.SetFocus;
end;

procedure TfrmRCPTidy.BitBtn1Click(Sender: TObject);
var
  save_RSindex : string;
  save_rslines_index : string;
  ReceptId : Integer;
  save_cursor : TCursor;
begin
  if TidyMode = 1 then
  begin
    // check the startdate is not more recent than end date
    if dtpStartDate.Date > dtpEndDate.Date then
    begin
      dtpEndDate.SetFocus;
      dtpEndDate.Color := clRed;
      ModalResult := mrNone;
      exit;
    end;

    // if invalidate requested then check invalidate edit box
    if RadioGroup1.ItemIndex = 1 then
    begin
      if edtArsag.Text = '' then
      begin
        edtArsag.Color := clRed;
        edtArsag.SetFocus;
        ModalResult := mrNone;
        exit;
      end;
    end;

    //  now we run down the rs_ekspedtioner set looking at start date and
    //  end date.  for each we find if the rseksplinier is lbnr 0 then
    //  send back to receptserver (tilbage or udlygig) and delete the line
    with MainDm do
    begin

      save_RSindex := nxRSEksp.IndexName;
      save_rslines_index := nxRSEkspLin.IndexName;
      nxRSEksp.IndexName := 'ReceptIdOrder';
      nxRSEkspLin.IndexName := 'ReceptIdOrder';
      save_cursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      try
        nxRSEksp.First;
        while not nxRSEksp.Eof do
        begin

          //  less than startdato so get next record
          if int(nxRSEkspDato.AsDateTime) < int(dtpStartDate.Date) then
          begin
            nxRSEksp.Next;
            Continue;
          end;

          // at the end of the date range so get out !!!
          if int(nxRSEkspDato.AsDateTime) > int(dtpEndDate.Date) then
            break;

          ReceptId := nxRSEkspReceptId.AsInteger;
          nxRSEkspLin.SetRange([ReceptId],[ReceptId]);
          try

            // if there are no lines then delete the current RSEKSPEDITIONER and continue
            if nxRSEkspLin.RecordCount = 0 then
            begin
              nxRSEksp.Delete;
              Continue;
            end;
            Label4.Caption := 'Nu slettes nr. ' + nxRSEkspPrescriptionId.AsString;
            Label4.Update;
            // if we get here then we have lines to process
            nxRSEkspLin.First;
            while not nxRSEkspLin.Eof do
            begin
              if nxRSEkspLinLbNr.AsInteger = 0 then
              begin
                if RadioGroup1.ItemIndex = 0 then
                begin
                    if ufmkcalls.FMKRemoveStatus(AfdNr,
                       nxRSEkspPatCPR.AsString,
                  { TODO : 03-06-2021/MA: Replace with real PersonIdSource. Might be available in nxRSEkspPatPersonIdentifierSource }
                       TFMKPersonIdentifierSource.DetectSource(nxRSEkspPatCPR.AsString),
                       nxRSEkspLinReceptId.AsInteger,
                       StrToInt64( nxRSEkspLinOrdId.AsString),
                       nxRSEkspLinAdministrationId.AsLargeInt) then
                    begin
                      C2LogAdd('remove status on Administration successful');

                    end;
                end
                else
                begin
                  if uFMKCalls.FMKInvalidate(nxRSEkspPatCPR.AsString,
                    StrToInt64(nxRSEkspLinOrdId.AsString),nxRSEkspLinReceptId.AsInteger, edtArsag.Text) then
                  begin
                    C2LogAdd('invalidate prescription successful');
                  end;

                end;
//                C2LogSave;
                // delete the ekspedition line
                nxRSEkspLin.Delete;
              end
              else
                nxRSEkspLin.Next; // get the next line

            end;
            // have we now deleted all lines?
            if nxRSEkspLin.RecordCount = 0 then
            begin
              nxRSEksp.Delete;
              Continue;
            end;
          finally
            nxRSEkspLin.CancelRange;
          end;

          // get the next
          nxRSEksp.Next;

        end;

      finally

        nxRSEksp.IndexName := save_RSindex;
        nxRSEkspLin.IndexName := save_rslines_index;
        Screen.Cursor := save_cursor;
        Label4.Caption := 'Sletning er afsluttet';
        label4.Update;

      end;




    //  delete any rsekspeditioner with no lines


    end;
  end
  else
  begin
    if int(dtpStartDate.Date) > int(now) - 90 then
    begin
      dtpStartDate.SetFocus;
      dtpStartDate.Color := clRed;
      ModalResult := mrNone;
      exit;
    end;
    with MainDm do
    begin

      save_RSindex := nxRSEksp.IndexName;
      save_rslines_index := nxRSEkspLin.IndexName;
      nxRSEksp.IndexName := 'ReceptIdOrder';
      nxRSEkspLin.IndexName := 'ReceptIdOrder';
      save_cursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      try
        nxRSEksp.First;
        while not nxRSEksp.Eof do
        begin
          Application.ProcessMessages;

          // at the end of the date range so get out !!!
          if int(nxRSEkspDato.AsDateTime) > int(dtpStartDate.Date) then
            break;

          ReceptId := nxRSEkspReceptId.AsInteger;
          nxRSEkspLin.SetRange([ReceptId],[ReceptId]);
          try

            // if there are no lines then delete the current RSEKSPEDITIONER and continue
            if nxRSEkspLin.RecordCount = 0 then
            begin
              nxRSEksp.Delete;
              Continue;
            end;
            Label4.Caption := 'Nu slettes nr. ' + nxRSEkspPrescriptionId.AsString;
            Label4.Update;
            // if we get here then we have lines to process
            nxRSEkspLin.First;
            while not nxRSEkspLin.Eof do
            begin
              if nxRSEkspLinLbNr.AsInteger <> 0 then
              begin
                if nxRSEkspLinIterationNr.AsInteger <> 0 then
                begin
                  if int(nxRSEkspDato.AsDateTime) < (int(now) - 730) then
                  begin
                    nxRSEkspLin.Delete;
                    continue;
                  end
                  else
                  begin
                    nxRSEkspLin.Next;
                    continue;
                  end;
                end;
                nxRSEkspLin.Delete;
              end
              else
                nxRSEkspLin.Next;
            end;
            // have we now deleted all lines?
            if nxRSEkspLin.RecordCount = 0 then
            begin
              nxRSEksp.Delete;
              Continue;
            end;
          finally
            nxRSEkspLin.CancelRange;
          end;

          // get the next
          nxRSEksp.Next;

        end;

      finally

        nxRSEksp.IndexName := save_RSindex;
        nxRSEkspLin.IndexName := save_rslines_index;
        Screen.Cursor := save_cursor;
        Label4.Caption := 'Sletning er afsluttet';
        label4.Update;

      end;
    end;

  end;

end;

procedure TfrmRCPTidy.FormCreate(Sender: TObject);
begin
  sl := TStringList.Create;
end;

end.
