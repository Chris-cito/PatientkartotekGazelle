unit uGebyr;

{ Developed by: Cito IT A/S

  Description: Select a gebyr value for udbrgebyr

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  10-08-2020/cjs  Changed last gebyr date format to be dd-mm-yy

  03-08-2020/cjs  Added check for varenr 100030 and 680018 for gebyr numbers

  24-07-2020/cjs  New sql to look for gebyr in ekspliniersalg for varenr 688017

  04-07-2019/cjs  Correction to sql in checking udbrgebyr

  22-03-2019/cjs  7.2.3.9 use gebyr properties for comparsion based on inclmoms on each line
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,uEkspeditioner.tables,uEksplinierSalg.tables,nxdb;

type
  TfrmGebyr = class(TForm)
    rgGebyr: TRadioGroup;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure rgGebyrClick(Sender: TObject);
  private
    { Private declarations }
    gebyrvaelg : integer;
    levform : integer;
  public
    { Public declarations }
    class function VaelgGebyr(aLevform :integer;var value : Currency) : boolean;
  end;


implementation

uses DM, C2MainLog;

{$R *.dfm}

{ TfrmGebyr }

class function TfrmGebyr.VaelgGebyr(aLevform : integer;var value: Currency): boolean;
Var
  Lfrm : TfrmGebyr;
begin
  C2LogAdd('Top of VaelgGebyr');
  Lfrm := TfrmGebyr.Create(Nil);
  try
    value := 0;
    Lfrm.levform := aLevform;
    Result := Lfrm.ShowModal = mryes;
    if Result then
    begin
      case Lfrm.gebyrvaelg of
        0 : value := MainDm.UdbrGebyr;
        1 : value := MainDm.HKgebyr;
        2 : value := MainDm.Plejehjemsgebyr;
      end;
    end;
  finally
    Lfrm.Free;
    C2LogAdd('Bottom of VaelgGebyr ' + CurrToStr(value));
  end;
end;

procedure TfrmGebyr.FormActivate(Sender: TObject);
var
  LLastEkspDate : TDateTime;
  LLastEksplinDate : TDateTime;
  LQry : TnxQuery;
begin
  rgGebyr.Items[0] := rgGebyr.Items[0] + ' ' + FormatCurr('0.00', MainDm.UdbrGebyr);
  rgGebyr.Items[1] := rgGebyr.Items[1] + ' ' + FormatCurr('0.00', MainDm.HKGebyr);
  rgGebyr.Items[2] := rgGebyr.Items[2] + ' ' + FormatCurr('0.00', MainDm.PlejehjemsGebyr);
  Label1.Caption := '';
  LLastEkspDate := 0;
  LLastEksplinDate := 0;
  try
    LQry := MainDm.nxdb.OpenQuery('SElECT top 1 ' + fnEkspeditionerTakserDato + ' FROM '
      + tnEkspeditioner + ' WHERE ' + fnEkspeditionerUdbrGebyr + '<>0 AND ' +
      fnEkspeditionerKundeNr_P + ' and ' + fnEkspeditionerLbNr + ' <> :lbnr '
      + 'order by ' + fnEkspeditionerTakserDato + ' desc',
      [trim(MainDm.ffEksKarKundeNr.AsString), MainDm.ffEksKarLbNr.AsInteger]);
      try
        C2LogAdd(LQry.SQL.Text);
        if LQry.RecordCount > 0 then
          LLastEkspDate := LQry.FieldByName(fnEkspeditionerTakserDato).AsDateTime;

      finally
        LQry.Free;
      end;

  except
    on e: Exception do
      C2LogAdd('frmGebyr sql1 ' + e.Message);

  end;

//SELECT top 1 e.kundenr, e.lbnr,e.takserdato FROM "Ekspeditioner" as e
//inner join ekspliniersalg as l on l.lbnr=e.lbnr
//where e.eksptype=7
//and l.varenr='688017'
//order by lbnr desc
  try
    LQry := MainDm.nxdb.OpenQuery('SElECT top 1 e.' + fnEkspeditionerKundeNr + ',e.' +
      fnEkspeditionerLbNr + ',e.' + fnEkspeditionerTakserDato + ' FROM ' +
      tnEkspeditioner + ' as e' + ' inner join ' + tnEkspLinierSalg +
      ' as l on l.lbnr=e.lbnr' + ' where e.' + fnEkspeditionerEkspType + '=7'
      + ' and (l.' + fnEkspLinierSalgVareNr + '=''688017'' or l.' +
      fnEkspLinierSalgVareNr + '=''688018'' or l.' + fnEkspLinierSalgVareNr +
      '=''100030''' + ') and e.' + fnEkspeditionerKundeNr_P + ' and e.' +
      fnEkspeditionerLbNr + ' <> :lbnr ' + 'order by e.' + fnEkspeditionerLbNr
      + ' desc', [trim(MainDm.ffEksKarKundeNr.AsString), MainDm.ffEksKarLbNr.AsInteger]);
    try
      C2LogAdd(LQry.sql.Text);
      if LQry.RecordCount > 0 then
        LLastEksplinDate := LQry.FieldByName(fnEkspeditionerTakserDato).AsDateTime;

    finally
      LQry.Free;
    end;

  except
    on e: Exception do
      C2LogAdd('frmGebyr sql1 ' + e.Message);

  end;




  if LLastEkspDate > LLastEksplinDate then
    Label1.Caption := 'Sidste gebyr: ' + FormatDateTime('dd-mm-yy hh:mm:ss', LLastEkspDate);

  if LLastEksplinDate > LLastEkspDate then
    Label1.Caption := 'Sidste gebyr: ' + FormatDateTime('dd-mm-yy hh:mm:ss', LLastEksplinDate);


  if MainDm.ffEksKarUdbrGebyr.AsCurrency = MainDm.UdbrGebyr then
    rgGebyr.ItemIndex := 0
  else
  begin
    if levform in [5,6] then
      rgGebyr.ItemIndex := 1
    else
      rgGebyr.ItemIndex := 2;
  end;
 SetWindowPos(Handle,HWND_TOPMOST,Left,Top,Width,Height,0);
end;

procedure TfrmGebyr.rgGebyrClick(Sender: TObject);
begin
  gebyrvaelg := rgGebyr.ItemIndex;
end;

end.
