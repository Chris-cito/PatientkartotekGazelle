unit uVisEkspFejl;

{ Developed by: Cito IT A/S

  Description: Show stregkodekontrol sdata for an ekspedition

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  30-04-2019/cjs  Added returtidspunkt field to sql and mark any lines that have an entry in that
                  field in Red.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, Data.DB, Vcl.Grids, Vcl.DBGrids, nxdb;

type
  TfrmVisEkspKontrol = class(TForm)
    Panel1: TPanel;
    ListView1: TListView;
    Label1: TLabel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    nxqDMVS: TnxQuery;
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure VisEkspKontrol;
  end;


implementation

uses DM,
  uEkspLinierSerienumre.Tables,
  C2MainLog;

{$R *.dfm}

{ TfrmVisEkspKontrol }

class procedure TfrmVisEkspKontrol.VisEkspKontrol;
begin
  with TfrmVisEkspKontrol.Create(Nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TfrmVisEkspKontrol.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
//    try
//      if not nxqDMVS.fieldbyname('Returtidspunkt').AsString.IsEmpty then
//      begin
//        DBGrid1.Canvas.Brush.Color := clRed;
//        DBGrid1.Canvas.Font.Color := clBlack;
//      end;
//
//    finally
//      if gdSelected in State then
//      begin
//        DBGrid1.Canvas.Brush.Color := clBlue;
//        DBGrid1.Canvas.Font.Color := clWhite;
//      end;
//
//      DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
//    end;
//
end;

procedure TfrmVisEkspKontrol.FormCreate(Sender: TObject);
var
  ll : TListItem;
  ll2 : TListItem;
begin
  with MainDm do
  begin
    c2logadd('VisEkspKontrol in');
    if dsEksOvr.DataSet = ffEksOvr then
    begin
      if ffEksOvrOrdreType.AsInteger = 2 then
        label1.Caption := 'Løbenr. ' + ffEksOvrLbNr.AsString + ' (retur)'
      else
        label1.Caption := 'Løbenr. ' + ffEksOvrLbNr.AsString;

      if ffEksOvrBrugerKontrol.AsInteger = 0 then
        label1.Caption := label1.Caption + ' er ikke kontrolleret'
      else
        Label1.Caption := Label1.Caption + ' er kontrolleret af bruger ' +
              ffEksOvrBrugerKontrol.AsString + '         ' +
              FormatDateTime('yyyy-mm-dd hh:mm:ss',ffEksOvrKontrolDato.AsDateTime) +
              ' Status ' + ffEksOvrKontrolFejl.AsString;
    end
    else
    begin
      if fqEksOvrType.AsString = 'Retur' then
        label1.Caption := 'Løbenr. ' + fqEksOvrLbnr.AsString  + ' (retur)'
      else
        label1.Caption := 'Løbenr. ' + fqEksOvrLbnr.AsString;
      if fqEksOvrKo.AsInteger = 0 then
        label1.Caption := label1.Caption + ' er ikke kontrolleret'
      else
        Label1.Caption := Label1.Caption + ' er kontrolleret af bruger ' +
              fqEksOvrKo.AsString + '         ' +
              FormatDateTime('yyyy-mm-dd hh:mm:ss',fqEksOvrKontrolDato.AsDateTime) +
              ' Status ' + inttostr(fqEksOvrKontrolFejl.AsInteger);
    end;


    if ffLinOvr.RecordCount <> 0 then
    begin
      ffLinOvr.Last;
      while not ffLinOvr.Bof do
      begin
        ll := ListView1.Items.Add;
        ll.Caption := ffLinOvrLinieNr.AsString;
        ll.SubItems.Add(ffLinOvrSubVareNr.AsString);
        ll.SubItems.Add(ffLinOvrTekst.AsString);
        ll.SubItems.Add(ffLinOvrAntal.AsString);
        if dsEksOvr.DataSet = ffEksOvr then
        begin
          ll.SubItems.Add(ffEksOvrBrugerKontrol.AsString);
          ll.SubItems.Add('');
        end
        else
        begin
          ll.SubItems.Add(fqEksOvrKo.AsString);
          ll.SubItems.Add('');
        end;
        nxEkspLinKon.IndexName := 'NrOrden';
        nxEkspLinKon.SetRange([fflinovrlbnr.asinteger,ffLinOvrLinieNr.asinteger],
                              [fflinovrlbnr.asinteger,ffLinOvrLinieNr.asinteger]);
        try
        if nxEkspLinKon.RecordCount <> 0 then
        begin
          nxEkspLinKon.First;
          while not nxEkspLinKon.Eof do
          begin
            ll2 := ListView1.Items.Add;
            ll2.Caption := '';
            ll2.SubItems.Add(ffLinOvrSubVareNr.AsString);
            ll2.SubItems.Add(ffLinOvrTekst.AsString);
            ll2.SubItems.Add(nxEkspLinKonAntal.AsString);
            ll2.SubItems.Add(nxEkspLinKonOpKode.AsString);
            ll2.SubItems.Add(nxEkspLinKonFejlkode.AsString);
            ll2.SubItems.Add(FormatDateTime('yyyy-mm-dd hh:mm:ss', nxEkspLinKonDato.AsDateTime));
            ll2.SubItems.Add(nxEkspLinKonBemaerk.AsString);
            nxEkspLinKon.Next;
          end;
        end;
        finally
          nxEkspLinKon.CancelRange;
        end;
        ffLinOvr.Prior;
      end;
      nxEkspLinKon.IndexName := 'NrOrden';
      nxEkspLinKon.SetRange([fflinovrlbnr.asinteger,0],
                            [fflinovrlbnr.asinteger,0]);
      try
        if nxEkspLinKon.RecordCount <> 0 then
        begin
          nxEkspLinKon.First;
          while not nxEkspLinKon.Eof do
          begin
            ll2 := ListView1.Items.Add;
            ll2.Caption := nxEkspLinKonLinienr.AsString;
            ll2.SubItems.Add(nxEkspLinKonVarenr.AsString);
            ll2.SubItems.Add('');
            ll2.SubItems.Add(nxEkspLinKonAntal.AsString);
            ll2.SubItems.Add(nxEkspLinKonOpKode.AsString);
            ll2.SubItems.Add(nxEkspLinKonFejlkode.AsString);
            ll2.SubItems.Add(FormatDateTime('yyyy-mm-dd hh:mm:ss', nxEkspLinKonDato.AsDateTime));
            ll2.SubItems.Add(nxEkspLinKonBemaerk.AsString);
            nxEkspLinKon.Next;
          end;
        end;
      finally
        nxEkspLinKon.CancelRange;
      end;


    end;


    // build up the dbgrid at the bottom of the screen with DMVS info
    nxqDMVS.Database := nxDB;
    nxqDMVS.SQL.Add('select');
    nxqDMVS.SQL.Add(fnEkspLinierSerienumreLinieNr);
    nxqDMVS.SQL.Add(',' + fnEkspLinierSerienumreProduktKode);
    nxqDMVS.SQL.Add(',' + fnEkspLinierSerienumreSerieNr);
    nxqDMVS.SQL.Add(',' + fnEkspLinierSerienumreBatchNr);
    nxqDMVS.SQL.Add(',' + fnEkspLinierSerienumreUdDato);
    nxqDMVS.SQL.Add(',' + fnEkspLinierSerienumreAntal);
    nxqDMVS.SQL.Add(',' + fnEkspLinierSerienumreReturtidspunkt);
    nxqDMVS.SQL.add('from ' + tnEkspLinierSerienumre);
    nxqDMVS.SQL.Add('where ' + fnEkspLinierSerienumreLbNr + '=:ilbnr');
    nxqDMVS.ParamByName('ilbnr').AsInteger := ffEksOvrLbNr.AsInteger;
    nxqDMVS.Open;
    if nxqDMVS.Eof then
    begin
      DBGrid1.Visible := False;
    end
    else
    begin
      DBGrid1.Visible := True;
    end;




    c2logadd('VisEkspKontrol out');
    c2logsave;
  end;

end;

end.
