unit uFejl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons;

type
  TfrmRcpKont = class(TForm)
    pnlParams: TPanel;
    dtpStart: TDateTimePicker;
    dtpEnd: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    rgSortering: TRadioGroup;
    BtnOK: TBitBtn;
    btnFortryd: TBitBtn;
    RadioGroup1: TRadioGroup;
    cboAfdeling: TComboBox;
    Label3: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    procedure PrintReport;
  public
    { Public declarations }
    class procedure showRcpKont(sender : Tobject);
  end;


implementation

uses c2mainlog, uVisEkspFejl,  DM, chkBoxes, DB,
  uc2ui.procs,
  PatMatrixPrinter;

{$R *.dfm}

{ TfrmRcpKont }

class procedure TfrmRcpKont.showRcpKont(Sender : Tobject);
begin
  with TfrmRcpKont.Create(Nil) do
  begin
    try

      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TfrmRcpKont.FormKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if key = #27 then
    ModalResult := mrCancel;
end;

procedure TfrmRcpKont.FormShow(Sender: TObject);
begin
  dtpStart.Date := Now -7;
  dtpEnd.Date := Now;
  rgSortering.ItemIndex := 0;
  RadioGroup1.ItemIndex := 0;
  RadioGroup1Click(Sender);
end;

procedure TfrmRcpKont.RadioGroup1Click(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of

    0: begin
          pnlParams.Enabled := False;
          rgSortering.Enabled := False;
          cboAfdeling.Enabled  := False;
          dtpStart.Enabled := False;
          dtpEnd.Enabled := False;
          Label1.Enabled := False;
          Label2.Enabled := False;
          Label3.Enabled := False;
       end;

    1: begin
          pnlParams.Enabled := True;
          rgSortering.Enabled := True;
          cboAfdeling.Enabled  := True;
          dtpStart.Enabled := True;
          dtpEnd.Enabled := True;
          Label1.Enabled := True;
          Label2.Enabled := True;
          Label3.Enabled := True;
       end;


  end;
end;

procedure TfrmRcpKont.BtnOKClick(Sender: TObject);
begin

  case RadioGroup1.ItemIndex of

     0: begin
          // view current ekspedition details
          TfrmVisEkspKontrol.VisEkspKontrol;
          ModalResult := mrOk;
        end;

     1: begin
          // execute report
          PrintReport;
        end;

  end;





end;

procedure TfrmRcpKont.PrintReport;
var
  sl : TStringList;
  PNr : word;
  sqlsl : TStringList;
  save_lbnr : integer;
  save_linienr : integer;
begin
  with MainDm do
  begin
    ModalResult := mrNone;
    PNr := 0;
    if dtpStart.DateTime > dtpEnd.DateTime then
    begin
      dtpEnd.SetFocus;
      exit;
    end;

    sl := TStringList.Create;
    sqlsl := TStringList.Create;
    BusyMouseBegin;
    BtnOK.Enabled := False;
    try
      sqlsl.Add('select');
      sqlsl.Add('      e.lbnr');
      sqlsl.Add('      ,e.kundenr');
      sqlsl.Add('      ,e.navn');
      sqlsl.Add('      ,e.kontrolfejl');
      sqlsl.Add('      ,e.brugerkontrol');
      sqlsl.Add('      ,e.KontrolDato');
      sqlsl.Add('      ,l.linienr as salglinienr');
      sqlsl.Add('      ,l.subvarenr');
      sqlsl.Add('      ,l.tekst');
      sqlsl.Add('      ,l.antal');
      sqlsl.Add('FROM "Ekspeditioner" as e');
      sqlsl.Add('inner join ekspliniersalg as l on l.lbnr=e.lbnr');
      sqlsl.Add('where e.afsluttetdato >=:startdate and e.afsluttetdato<=:enddate');

      case rgSortering.ItemIndex of
        0: sqlsl.Add('order by e.KontrolDato,e.lbnr,l.linienr');
        1: sqlsl.Add('order by e.BrugerKontrol,e.lbnr,l.linienr');
      end;
      c2logadd('uFejl sql is ' + sqlsl.Text);
      sl.Add('Restscanningsliste');
      sl.Add(ffFirmaNavn.AsString);
      sl.Add('');
      sl.Add('');
      sl.Add('');
      fqSqlSel.SQL.Text := sqlsl.Text;
      fqSqlSel.ParamByName('startdate').AsDateTime := dtpStart.DateTime;
      fqSqlSel.ParamByName('enddate').AsDateTime := dtpEnd.DateTime;
      try
        fqSqlSel.Open;
        if fqSqlSel.RecordCount = 0 then
        begin
          ChkBoxOK('No data to report');
          exit;
        end;
        save_lbnr := 0;
        save_linienr := 0;
        fqSqlSel.First;
        while not fqSqlSel.Eof do
        begin

          if fqSqlSel.FieldByName('BrugerKontrol').AsInteger = 0 then
          begin
            if fqSqlSel.fieldbyname('Lbnr').AsInteger <> save_lbnr then
              sl.Add(fqSqlSel.fieldbyname('Lbnr').AsString + ' er ikke kontrolleret');
            save_lbnr := fqSqlSel.fieldbyname('Lbnr').AsInteger;
            fqSqlSel.Next;
            continue;
          end;

          if fqSqlSel.fieldbyname('Lbnr').AsInteger <> save_lbnr then
          begin
            if save_linienr <> 0 then
            begin
              nxEkspLinKon.IndexName := 'NrOrden';
              nxEkspLinKon.SetRange([fqSqlSel.fieldbyname('Lbnr').asinteger,0],
                                    [fqSqlSel.fieldbyname('Lbnr').asinteger,0]);
              try
                if nxEkspLinKon.RecordCount <> 0 then
                begin
                  nxEkspLinKon.First;
                  while not nxEkspLinKon.Eof do
                  begin
                    sl.Add
                      (
                        inttostr(save_lbnr) + ' ' +
                        '0 ' +
                        fqSqlSel.fieldbyname('subvarenr').AsString + ' ' +
                        fqSqlSel.fieldbyname('tekst').AsString + ' ' +
                        nxEkspLinKonAntal.AsString + ' ' +
                        nxEkspLinKonOpKode.AsString + ' ' +
                        nxEkspLinKonFejlkode.AsString + ' ' +
                        FormatDateTime('yyyy-mm-dd hh:mm:ss', nxEkspLinKonDato.AsDateTime) + ' ' +
                        nxEkspLinKonBemaerk.AsString
                      );
                    nxEkspLinKon.Next;
                  end;
                end;
              finally
                nxEkspLinKon.CancelRange;
                save_linienr := 0;
              end;


            end;
            // check to see if kontrolfejl is 0 that there are some kontrol fejl lines to report

            if fqSqlSel.fieldbyname('KontrolFejl').AsInteger = 0 then
            begin
              nxEkspLinKon.IndexName := 'NrOrden';
              nxEkspLinKon.SetRange([fqSqlSel.fieldbyname('Lbnr').asinteger],
                                    [fqSqlSel.fieldbyname('Lbnr').asinteger]);
              try
                if nxEkspLinKon.RecordCount = 0 then
                begin
                  fqSqlSel.Next;
                  continue;
                end;
              finally
                nxEkspLinKon.CancelRange;
              end;
            end;
            sl.Add(' ');
//              save_linienr := 0;
          end;
          nxEkspLinKon.IndexName := 'NrOrden';
          nxEkspLinKon.SetRange([fqSqlSel.fieldbyname('Lbnr').asinteger,fqSqlSel.fieldbyname('salglinienr').asinteger],
                                [fqSqlSel.fieldbyname('Lbnr').asinteger,fqSqlSel.fieldbyname('salglinienr').asinteger]);
          try
            if nxEkspLinKon.RecordCount <> 0 then
            begin
              nxEkspLinKon.First;
              while not nxEkspLinKon.Eof do
              begin
                sl.Add
                  (
                    fqSqlSel.fieldbyname('Lbnr').AsString + ' ' +
                    nxEkspLinKonLinienr.AsString + ' ' +
                    fqSqlSel.fieldbyname('subvarenr').AsString + ' ' +
                    fqSqlSel.fieldbyname('tekst').AsString + ' ' +
                    nxEkspLinKonAntal.AsString + ' ' +
                    nxEkspLinKonOpKode.AsString + ' ' +
                    nxEkspLinKonFejlkode.AsString + ' ' +
                    FormatDateTime('yyyy-mm-dd hh:mm:ss', nxEkspLinKonDato.AsDateTime) + ' ' +
                    nxEkspLinKonBemaerk.AsString
                  );
                nxEkspLinKon.Next;
              end;
            end;
          finally
            nxEkspLinKon.CancelRange;
          end;

          save_linienr := fqSqlSel.fieldbyname('salglinienr').AsInteger;
          save_lbnr := fqSqlSel.fieldbyname('Lbnr').AsInteger;
          fqSqlSel.Next;
        end;
        if save_linienr <> 0 then
        begin
          nxEkspLinKon.IndexName := 'NrOrden';
          nxEkspLinKon.SetRange([save_lbnr,0],
                                [save_lbnr,0]);
          try
            if nxEkspLinKon.RecordCount <> 0 then
            begin
              nxEkspLinKon.First;
              while not nxEkspLinKon.Eof do
              begin
                sl.Add
                  (
                    inttostr(save_lbnr) + ' ' +
                    '0 ' +
                    fqSqlSel.fieldbyname('subvarenr').AsString + ' ' +
                    fqSqlSel.fieldbyname('tekst').AsString + ' ' +
                    nxEkspLinKonAntal.AsString + ' ' +
                    nxEkspLinKonOpKode.AsString + ' ' +
                    nxEkspLinKonFejlkode.AsString + ' ' +
                    FormatDateTime('yyyy-mm-dd hh:mm:ss', nxEkspLinKonDato.AsDateTime) + ' ' +
                    nxEkspLinKonBemaerk.AsString
                  );
                nxEkspLinKon.Next;
              end;
            end;
          finally
            nxEkspLinKon.CancelRange;
          end;
        end;


        sl.SaveToFile('C:\C2\Temp\FejlListe.Txt');
        PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\FejlListe.Txt');
      except
        on e : Exception do
        begin
          ChkBoxOK(e.Message);
        end;
      end;
    finally
      sl.Free;
      fqSqlSel.Close;
      BtnOK.Enabled := true;
      BusyMouseEnd;
    end;

  end;
end;

end.
