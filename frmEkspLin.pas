unit frmEkspLin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ComCtrls, StdCtrls, DBClient, ActnList, System.Actions;

type
  TfrmRetLin = class(TForm)
    dsRetLin: TDataSource;
    ListView1: TListView;
    btnHele: TButton;
    btnAfslut: TButton;
    btnMarkerede: TButton;
    mtRetlin: TClientDataSet;
    mtRetlinLin: TIntegerField;
    mtRetlinVareNr: TStringField;
    mtRetlinTekst: TStringField;
    mtRetlinAntal: TIntegerField;
    mtRetlinSelected: TBooleanField;
    ActionList1: TActionList;
    acF6: TAction;
    lblF6: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnHeleClick(Sender: TObject);
    procedure btnMarkeredeClick(Sender: TObject);
    procedure btnAfslutClick(Sender: TObject);
    procedure acF6Execute(Sender: TObject);
    procedure ListView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    function CheckVareAFM(Varenr : string) : integer;

  public
    { Public declarations }
    AllEkspLinier : Boolean;
  end;

var
  frmRetLin: TfrmRetLin;
  creditedlines : boolean;

implementation

uses DM,chkboxes;

{$R *.dfm}

procedure TfrmRetLin.FormShow(Sender: TObject);
var
  i : integer;
  li : TListItem;
  antalnotcredited : integer;
begin

  mtRetLin.Close;
  mtRetLin.Open;
  ListView1.Items.Clear;
  btnHele.Enabled := true;
  creditedlines := False;
  WITH MainDm do
  begin
    for i := 1 to ffEksOvrAntLin.AsInteger do
    begin
      if not ffRetLin.FindKey([ffEksOvrLbNr.Value,i]) then
        continue;
      antalnotcredited := ffRetLin.FieldByName('Antal').AsInteger;
      try
        nxEksCred.IndexName := 'LbnrOrden';
        nxEksCred.SetRange([ffEksOvrLbNr.AsInteger,i],[ffEksOvrLbNr.AsInteger,i]);
        try
          if nxEksCred.RecordCount <> 0 then
          begin
            nxEksCred.First;
            while not nxEksCred.Eof do
            begin

              if nxEksCred.FieldByName('DelvisAntal').AsInteger = 0 then
              begin
                antalnotcredited := 0;
                break;
              end;

              antalnotcredited := antalnotcredited - nxEksCred.FieldByName('DelvisAntal').AsInteger;
              btnHele.Enabled := False;
              creditedlines := true;
              nxEksCred.Next;
            end;
          end;

        finally
          nxEksCred.CancelRange;
        end;
      except
        on e : exception do
          Application.MessageBox(pchar(e.Message),'Fejl')
      end;

      if antalnotcredited = 0 then
        continue;

//        ListView
      with ListView1 do
      begin
        li := Items.Add;
        li.Caption := inttostr(i);
        li.SubItems.Add(ffRetLin.fieldbyname('SubVareNr').AsString);
        li.SubItems.Add(ffRetLin.fieldbyname('Tekst').AsString);
        li.SubItems.Add(IntToStr(antalnotcredited));
        li.SubItems.Add(IntToStr(antalnotcredited));
      end;
    end;
    ListView1.ItemIndex := 0;
    ListView1.SetFocus;
  end;
end;

procedure TfrmRetLin.ListView1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  li: TListItem;
begin
  li := ListView1.GetItemAt(X, Y);
  if (li <> nil) AND (ListView1.Selected <> li) then
    ListView1.Selected := li;
end;

procedure TfrmRetLin.acF6Execute(Sender: TObject);
var
  li : TListItem;
  newval, max  : integer;
begin
  with MainDm do
  begin
    if ffEksOvrOrdreStatus.AsInteger = 2 then
    begin
      ChkBoxOK('Ekspeditionen er afsluttet. Der kan kun ændres i pakningsantal for åbne ekspeditioner.');
      exit;
    end;

  end;
  if ListView1.ItemIndex < 0 then
    exit;
  li := ListView1.Selected;
  max := StrToInt(li.SubItems[3]);
  try
    repeat
      newval := ChkBoxInt('Indtast antal pakninger, der skal tilbageføres (max ' + li.SubItems[3]+ ')',strtoint(li.SubItems[2]));
      // 0 is not allowed!!!
      if newval = 0 then
        exit;

      if (newval > max) or (newval<0) then
        ChkBoxOK('Det tastede antal kan ikke krediteres.');
    until newval <= max;
    Li.SubItems[2] := inttostr(newval);
  finally
    ListView1.Refresh;
    if newval <> max then
    begin
      btnHele.Enabled := False;
      li.Checked := True;
    end;

  end;
end;

procedure TfrmRetLin.btnHeleClick(Sender: TObject);
var
  ll : TListItem;
  sl : TStringList;

begin
  sl := TStringList.Create;
  try
    AllEkspLinier := True;
    for ll in ListView1.Items do
    begin
      case CheckVareAFM(ll.SubItems[0])  of
        1 : sl.Add(ll.SubItems[0] + ' - '  + ll.SubItems[1] + ' har leveringssvigtdato.');
        2 : sl.Add(ll.SubItems[0] + ' - '  + ll.SubItems[1] + ' er afregistreret.');
      end;
    end;
    if sl.Count <> 0 then
    begin
      if not ChkBoxYesNo(sl.Text + #10#13 +
                          'Ønsker du alligevel at tilbageføre?',False) then
      begin
        ModalResult := mrNone;
        exit;
      end;
    end;
    ModalResult := mrOk;
  finally
    sl.Free;
  end;
end;

procedure TfrmRetLin.btnMarkeredeClick(Sender: TObject);
var
  recSelected : boolean;
  allselected : boolean;
  ival,imax : integer;
  ll : TListItem;
  sl : TStringList;
begin
  sl := TStringList.Create;
  try
    recSelected := False;
    allselected := True;
    if creditedlines then
      allselected := False;
    for ll in  ListView1.Items do
    begin
      if ll.Checked then
      begin
        if not TryStrToInt(ll.SubItems[2],ival) then
        begin
          ChkBoxOK('Det tastede antal kan ikke krediteres.');
          ModalResult := mrNone;
          exit;
        end;
        if not TryStrToInt(ll.SubItems[3],imax) then
        begin
          ChkBoxOK('Det tastede antal kan ikke krediteres.');
          ModalResult := mrNone;
          exit;
        end;
        if (ival<0) or (ival>imax) then
        begin
          ChkBoxOK('Det tastede antal kan ikke krediteres.');
          ModalResult := mrNone;
          exit;
        end;
        case CheckVareAFM(ll.SubItems[0])  of
          1 : sl.Add(ll.SubItems[0] + ' - '  + ll.SubItems[1] + ' har leveringssvigtdato.');
          2 : sl.Add(ll.SubItems[0] + ' - '  + ll.SubItems[1] + ' er afregistreret.');
        end;
        recSelected := True;
      end
      else
        allselected := False;
    end;
    if sl.Count <> 0 then
    begin
      if not ChkBoxYesNo(sl.Text + #10#13 +
                          'Ønsker du alligevel at tilbageføre?',False) then
      begin
        ModalResult := mrNone;
        exit;
      end;
    end;
    AllEkspLinier := False;
    if allselected then
      AllEkspLinier := True;
    if not btnHele.Enabled then
      AllEkspLinier := False;
    if  not recSelected then
      ModalResult := mrCancel
    else
      ModalResult := mrOk;
  finally
    sl.Free;
  end;
end;

function TfrmRetLin.CheckVareAFM(Varenr : string): integer;
var
  save_index : string;
begin
  with MainDm do
  begin
    Result := 0;
    save_index := ffLagKar.IndexName;
    fflagkar.IndexName := 'NrOrden';
    try
      if ffLagKar.FindKey([ffeksovrlager.AsInteger,Varenr]) then
      begin
        if not ffLagKarSletDato.IsNull then
          Result := 1;
        if not ffLagKarAfmDato.IsNull then
          Result := 2;


      end;
    finally
      ffLagKar.IndexName := save_index;
    end;

  end;
end;

procedure TfrmRetLin.btnAfslutClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
