unit TilstLst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ExtCtrls, Db, nxdb;

type
  TTlLstForm = class(TForm)
    TlLstGrid: TDBGrid;
    procedure TlLstGridTitleClick(Column: TColumn);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TlLstGridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Table : TnxTable;
    SCaption,
    SKey  : String;
  end;

var
  TlLstForm: TTlLstForm;

function ShowTlLst (N : String; Ds : TDataSource; Tb : TnxTable) : Boolean;

implementation

{$R *.DFM}

procedure TableSort (I : Word);
var
  N : String;
begin with TlLstForm do begin
  case I of
    0 : N := 'NrOrden';
    1 : N := 'NavneOrden';
  end;
  Table.IndexName := N;
  Table.Refresh;
  TlLstGrid.Columns [0].Title.Font.Style := [];
  TlLstGrid.Columns [1].Title.Font.Style := [];
  TlLstGrid.Columns [I].Title.Font.Style := [fsBold];
  Caption := SCaption + ' [' + SKey + ']';
end; end;

procedure TTlLstForm.TlLstGridTitleClick(Column: TColumn);
begin
  SKey := '';
  TableSort (Column.Index);
end;

function ShowTlLst (N : String; Ds : TDataSource; Tb : TnxTable) : Boolean;
begin with TlLstForm do begin
  Table                := Tb;
  TlLstGrid.DataSource := Ds;
  SCaption             := Caption;
  TlLstGridTitleClick (TlLstGrid.Columns [0]);
  Result  := ShowModal = MrOK;
  Caption := SCaption;
end; end;

procedure TTlLstForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  BS : Char;
begin
  if Shift = [] then begin
    Case Key of
      VK_HOME   : ;
      VK_END    : ;
      VK_UP     : ;
      VK_DOWN   : ;
      VK_PRIOR  : ;
      VK_NEXT   : ;
      VK_DELETE : begin
        SKey    := ' ';
        BS      := #8;
        FormKeyPress (Self, BS);
      end;
      VK_ESCAPE : begin
        TlLstForm.ModalResult := mrCancel;
        Key     := 0;
      end;
      VK_RETURN : begin
        TlLstForm.ModalResult := mrOk;
        Key     := 0;
      end;
    end;
  end else begin
    if Shift = [ssAlt] then begin
      Case Chr (Key) of
        'r', 'R' : TlLstGridTitleClick (TlLstGrid.Columns [0]);
      end;
    end;
  end;
end;

procedure TTlLstForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#13, #27]) then begin
    if Key = #8 then
      Delete (SKey, Length (SKey), 1)
    else
      SKey := SKey + Key;
    Table.FindNearest([SKey]);
    Caption := SCaption + ' [' + SKey + ']';
  end;
end;

procedure TTlLstForm.TlLstGridDblClick(Sender: TObject);
var
  K : Word;
begin
  K := VK_RETURN;
  FormKeyDown(Self, K, []);
end;

end.
