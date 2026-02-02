unit uKundeOrd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGrids, Vcl.Grids;

type
  TfrmKundeOrd = class(TForm)
    DBGrid1: TDBGrid;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    FVaretype: integer;
    FATCKode: string;
    FKundenr: string;
    { Private declarations }
    property Varetype : integer read FVaretype write FVaretype;
    property ATCKode : string read FATCKode write FATCKode;
    property Kundenr: string read FKundenr write FKundenr;
  public
    { Public declarations }
    class function ShowKundeOrd(AKundeNr,AATCKode : string;AVareType:integer) : boolean;
  end;


implementation

uses DM;

{$R *.dfm}

procedure TfrmKundeOrd.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key,[#13,#27]) then
    exit;
  if key = #27 then
    ModalResult := mrCancel;
  if key = #13 then
    ModalResult := mrOk;
end;


class function TfrmKundeOrd.ShowKundeOrd(AKundeNr,AATCKode : string;AVareType : integer): boolean;
begin
  with TfrmKundeOrd.Create(Nil) do
  begin
    try
      Kundenr := AKundeNr;
      Atckode := AATCKode;
      VareType := AVareType;

      Result := ShowModal = mrOK;
    finally
      Free;
    end;
  end;
end;

procedure TfrmKundeOrd.FormShow(Sender: TObject);
begin
  with MainDm do
  begin
    nqKundeOrd.Close;
    nqkundeord.SQL.Clear;
    nqKundeOrd.SQL.Add('select');
    nqKundeOrd.SQL.Add('  e.Takserdato as Dato');
    nqKundeOrd.SQL.Add('  ,l.subvarenr as Varenr');
    nqKundeOrd.SQL.Add('  ,l.tekst + '' '' + l.form +'' '' + l.styrke + '' '' + l.pakning as Navn');
    nqKundeOrd.SQL.Add('  ,case when e.ordretype=1 then ''Salg'' else ''Retur'' end as Type');
    nqKundeOrd.SQL.Add('from');
    nqKundeOrd.SQL.Add('  ekspeditioner as e');
    nqKundeOrd.SQL.Add('left join ekspliniersalg as l on l.lbnr=e.lbnr');
    nqKundeOrd.SQL.Add('where e.kundenr=:kundenr');
    nqKundeOrd.SQL.Add('and e.takserdato > current_timestamp - interval ''6'' month');
    if Varetype <> 0 then
      nqKundeOrd.SQL.Add('and l.varetype=2')
    else
      nqKundeOrd.SQL.Add('and l.atckode=:atckode');
    nqKundeOrd.SQL.Add('order by e.takserdato desc');
    nqKundeOrd.ParamByName('kundenr').AsString := Kundenr;

    if Varetype = 0 then
      nqKundeOrd.ParamByName('atckode').AsString := Atckode;
    try
      nqKundeOrd.Open;
    except
      on e : Exception do
        Application.MessageBox(pchar(e.Message),'Fejl');
    end;
  end;
end;

end.
