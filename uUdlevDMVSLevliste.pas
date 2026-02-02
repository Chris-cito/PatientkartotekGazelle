unit uUdlevDMVSLevliste;

{ Developed by: Cito IT A/S

  Description: Form shows dmvs levliste that have not been completed in kasse program

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  10-08-2022/cjs  Even more efficient sql for DMVS levliste

  28-04-2019/cjs  More efficient sql for DMVS levliste

  03-10-2019/cjs  After all dmvs products have been checked we need to get the full list of lbnr in
  the leveringsliste for the zero bon.

  24-09-2019/cjs  Changed sql to only handle the lbnr that have an entry in dmvslog in UdlevDMVS

  28-08-2019/cjs  Changed sql that displays the "open" levlistes to check for a matching entry in
  DMVSLog table
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.DBGrids, Data.DB, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  nxdb, generics.collections, Vcl.Grids;
{$I EdiRcpInc}

const
  WM_AppStart = WM_USER + 101;

type

  TfrmUdlevDMVS = class(TForm)
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    btnUdlev: TButton;
    BitBtn1: TBitBtn;
    ActionManager1: TActionManager;
    acUdlev: TAction;
    dsLevListe: TDataSource;
    nxQuery1: TnxQuery;
    procedure acUdlevExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FAfdelingNr: integer;
    { Private declarations }
    procedure HandleLevListe(aListenr: integer);
    property AfdelingNr: integer read FAfdelingNr write FAfdelingNr;
    procedure ApplicationStart(var AMsg: TMessage); message WM_AppStart;
  public
    { Public declarations }
    class procedure ShowForm(aAdelingNr: integer);
  end;

implementation

{$R *.dfm}

uses DM, ChkBoxes, C2MainLog, uc2ui.procs;

{ TfrmUdlevDMVS }

procedure TfrmUdlevDMVS.acUdlevExecute(Sender: TObject);
begin
  HandleLevListe(nxQuery1.fieldbyname('Listenr').AsInteger);
end;

procedure TfrmUdlevDMVS.ApplicationStart(var AMsg: TMessage);
begin
  BusyMouseBegin;
  try
    nxQuery1.Database := MainDm.nxdb;
    nxQuery1.SQL.Clear;
    // nxQuery1.SQL.add('#t 100000');
    // nxquery1.sql.add('select x.*');
    // nxQuery1.SQL.Add(',afd.navn');
    // nxQuery1.SQL.Add('from');
    // nxQuery1.SQL.Add('(');
    // nxQuery1.SQL.add('select distinct lev.listenr');
    // nxQuery1.SQL.add(',cast(lev.dato as  date) as dato');
    // nxQuery1.SQL.add(',lev.konto');
    // nxQuery1.SQL.add('from ekspleveringsliste as lev');
    // nxQuery1.SQL.add('inner join ekspeditioner as e on e.lbnr=lev.lbnr');
    // nxQuery1.SQL.Add('left JOIN DMVSLOG as dmvs on dmvs.lbnr=e.lbnr');
    // nxQuery1.SQL.add('left join ekspeditionerbon as bon on bon.lbnr=e.lbnr');
    // nxquery1.sql.add('where   lev.dato >= cast(''2019-02-09 00:00:00.000'' as datetime)');
    // nxQuery1.SQL.add('and (bon.bonnr=0 or bon.bonnr is null)');
    // nxQuery1.SQL.Add('and dmvs.lbnr is not null');
    // nxquery1.SQL.Add(') as x');
    // nxquery1.SQL.Add('left join debitorkartotek as deb on deb.kontonr=x.konto');
    // nxquery1.SQL.Add('left join afdelingsnavne as afd on afd.refnr=deb.afdeling');
    //

    // more efficient sql
    nxQuery1.SQL.add('#T 100000');
    nxQuery1.SQL.add('');
    nxQuery1.SQL.add('select x.*');
    nxQuery1.SQL.add(',afd.navn');
    nxQuery1.SQL.add('from');
    nxQuery1.SQL.add('(');
    nxQuery1.SQL.add('select distinct lev.listenr,lev.dato,lev.konto');
    nxQuery1.SQL.add('from');
    nxQuery1.SQL.add('(');
    nxQuery1.SQL.add('select listenr');
    nxQuery1.SQL.add(',lbnr');
    nxQuery1.SQL.add(',cast(dato as  date) as dato');
    nxQuery1.SQL.add(',konto');
    nxQuery1.SQL.add('from ekspleveringsliste');
    nxQuery1.SQL.add(') as lev');
    nxQuery1.SQL.add('inner JOIN DMVSLOG as dmvs on dmvs.lbnr=lev.lbnr');
    nxQuery1.SQL.add('left join ekspeditionerbon as bon on bon.lbnr=lev.lbnr');
    nxQuery1.SQL.add('where');
    nxQuery1.SQL.add('(bon.bonnr=0 or bon.bonnr is null)');
    nxQuery1.SQL.add(') as x');
    nxQuery1.SQL.add('left join debitorkartotek as deb on deb.kontonr=x.konto');
    nxQuery1.SQL.add('left join afdelingsnavne as afd on afd.refnr=deb.afdeling');

    C2LogAdd(nxQuery1.SQL.Text);
    try
      nxQuery1.Open;
    except
      on e: Exception do
        C2LogAdd(e.Message);

    end;
  finally
    BusyMouseEnd;
  end;

end;

procedure TfrmUdlevDMVS.FormShow(Sender: TObject);
begin

  PostMessage(self.Handle, WM_AppStart,0,0);
end;

procedure TfrmUdlevDMVS.HandleLevListe(aListenr: integer);
var
  ListeNr: integer;
  nxq: TnxQuery;
  LevLbnrList: TList<integer>;

  function CheckKontrol: boolean;
  var
    lbnr: integer;
    sl: TStringList;

  begin
    with MainDm do
    begin
      sl := TStringList.Create;
      try
        for lbnr in LevLbnrList do
        begin
          nxq.Close;
          nxq.SQL.Clear;
          nxq.SQL.add('SELECT s.lbnr,count(lag.dmvs),e.brugerkontrol as dmvs FROM EkspLinierSalg as s');
          nxq.SQL.add('inner join lagerkartotek as lag on lag.lager=s.lager and lag.varenr=s.subvarenr');
          nxq.SQL.add('left join ekspeditioner as e on e.lbnr=s.lbnr');
          nxq.SQL.add('where lag.dmvs<> 0');
          nxq.SQL.add('and s.lbnr=:ilbnr');
          nxq.SQL.add('and e.brugerkontrol=0');
          nxq.SQL.add('and e.ordretype=1');
          nxq.SQL.add('and e.eksptype<>' + IntToStr(et_Dosispakning));
          nxq.SQL.add('group by s.lbnr,e.brugerkontrol');
          nxq.ParamByName('ilbnr').AsInteger := lbnr;
          nxq.Open;
          if not nxq.Eof then
            sl.add(lbnr.ToString);
        end;

        if sl.Count <> 0 then
          ChkBoxOK('Følgende løbenumre mangler stregkodekontrol: ' + #13#10 + sl.Text)

      finally

        Result := sl.Count = 0;
        sl.Free
      end;

    end;
  end;

  function CheckBogfoer: boolean;
  var
    lbnr: integer;
    counter: integer;
    sl: TStrings;
  begin
    with MainDm do
    begin
      sl := TStringList.Create;
      try
        Result := True;
        counter := 0;
        for lbnr in LevLbnrList do
        begin
          nxq.Close;
          nxq.SQL.Clear;
          nxq.SQL.add('SELECT e.Afsluttetdato,b.bonnr FROM Ekspeditioner as E');
          nxq.SQL.add('left join Ekspeditionerbon as b on b.lbnr=e.lbnr');
          nxq.SQL.add('where e.lbnr=:ilbnr');
          nxq.ParamByName('ilbnr').AsInteger := lbnr;
          nxq.Open;
          if nxq.Eof then
            continue;

          if nxq.fieldbyname('Afsluttetdato').IsNull then
          begin
            sl.add(lbnr.ToString);
          end;

          if not nxq.fieldbyname('Bonnr').IsNull then
          begin
            // count how many lines have a bonnr
            inc(counter);
            // ChkBoxOK('Udlevering af denne lev.liste er allerede registreret.');
            // Result := False;
            // exit;
          end;

        end;

        if sl.Count <> 0 then
        begin
          ChkBoxOK('Leveringsliste er ikke bogført ' + #13#10 + sl.Text);
          Result := False;
          exit;
        end;

        // if the counter is all of the lbnr in the list then message box
        if counter = LevLbnrList.Count then
          ChkBoxOK('Udlevering af denne lev.liste er allerede registreret.');

        // return true if something on the list is valid
        Result := counter <> LevLbnrList.Count;

      finally
        sl.Free;
      end;
    end;
  end;

begin
  with MainDm do
  begin
    // Løbenr muligvis stregkode
    ListeNr := ffEksOvrListeNr.AsInteger;


    // Søg løbenr

    LevLbnrList := TList<integer>.Create;
    nxq := TnxQuery.Create(Nil);
    try
      // here we use the levliste sql to return the lbnr's in the leversingslist
      nxq.Database := nxdb;

      try
        nxq.Close;
        nxq.SQL.Clear;
        nxq.SQL.add('select distinct lev.LbNr from ekspleveringsliste as lev');
        nxq.SQL.add('inner join dmvslog as dmvs on dmvs.lbnr=lev.lbnr');
        nxq.SQL.add('where listenr=:listenr');
        nxq.ParamByName('listenr').AsInteger := aListenr;
        nxq.Open;
        if nxq.RecordCount = 0 then
        begin
          ChkBoxOK('There are no Leveringslistenr findes IKKE i kartoteket!');

          exit;
        end;
        nxq.first;
        while not nxq.Eof do
        begin
          LevLbnrList.add(nxq.fieldbyname('Lbnr').AsInteger);
          nxq.Next;
        end;

        // check each lbnr for existence of DMVS product. if there is at least 1 then
        // must check kontrol has been done

        if not CheckKontrol then
          exit;

        // check that all have been afsluttet
        if not CheckBogfoer then
          exit;

        // if we get here then we need the full list of lbnr including those without dmvs

        nxq.Close;
        nxq.SQL.Clear;
        nxq.SQL.add('select distinct lev.LbNr from ekspleveringsliste as lev');
        nxq.SQL.add('where listenr=:listenr');
        nxq.ParamByName('listenr').AsInteger := aListenr;
        nxq.Open;
        if nxq.RecordCount = 0 then
        begin
          ChkBoxOK('There are no Leveringslistenr findes IKKE i kartoteket!');

          exit;
        end;

        LevLbnrList.Clear;
        nxq.first;
        while not nxq.Eof do
        begin
          LevLbnrList.add(nxq.fieldbyname('Lbnr').AsInteger);
          nxq.Next;
        end;

        if OpdaterZeroBonLevlist(LevLbnrList) = 0 then
        begin
          ChkBoxOK('Løbenr/Listenr er nu registreret udleveret i DMVS');
        end;
      except
        on e: Exception do
        begin
          ChkBoxOK('Exception under søgning recept "' + e.Message);
          exit;
        end;

      end;
    finally
      nxq.Free;
      LevLbnrList.Free;
    end;

  end;

end;

class procedure TfrmUdlevDMVS.ShowForm(aAdelingNr: integer);
begin
  with TfrmUdlevDMVS.Create(Nil) do
  begin

    try
      AfdelingNr := aAdelingNr;
      ShowModal;
    finally
      Free;
    end;

  end;
end;

end.
