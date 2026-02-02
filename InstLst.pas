unit InstLst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBGrids, ExtCtrls, Db, nxdb, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.Grids;

type
  TInLstForm = class(TForm)
    InLstGrid: TDBGrid;
    ActionManager1: TActionManager;
    acLuk: TAction;
    AcAltK: TAction;
    acAltA: TAction;
    acAltN: TAction;
    AcEnter: TAction;
    procedure InLstGridTitleClick(Column: TColumn);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure InLstGridDblClick(Sender: TObject);
    procedure acLukExecute(Sender: TObject);
    procedure AcAltKExecute(Sender: TObject);
    procedure acAltAExecute(Sender: TObject);
    procedure acAltNExecute(Sender: TObject);
    procedure AcEnterExecute(Sender: TObject);
  private
    Table: TnxTable;
    SCaption, SKey: String;
    procedure TableSort(I: Word);
    { Private declarations }
  public
    { Public declarations }
    class function ShowInLst(const N: String; Ds: TDataSource; Tb: TnxTable): Boolean;
  end;


implementation

{$R *.DFM}

procedure TInLstForm.TableSort(I: Word);
var
  N: String;
begin
  case I of
    0:
      N := 'NrOrden';
    1:
      N := 'AmtOrden';
    2:
      N := 'NavneOrden';
  end;
  Table.IndexName := N;
  Table.Refresh;
  InLstGrid.Columns[0].Title.Font.Style := [];
  InLstGrid.Columns[1].Title.Font.Style := [];
  InLstGrid.Columns[2].Title.Font.Style := [];
  InLstGrid.Columns[I].Title.Font.Style := [fsBold];
  Caption := SCaption + ' [' + SKey + ']';
end;

procedure TInLstForm.InLstGridTitleClick(Column: TColumn);
begin
  SKey := '';
  TableSort(Column.Index);
end;

class function TInLstForm.ShowInLst(const N: String; Ds: TDataSource; Tb: TnxTable): Boolean;
var
  LFrm: TInLstForm;
begin
  LFrm := TInLstForm.Create(Nil);
  try
    LFrm.Table := Tb;
    LFrm.InLstGrid.DataSource := Ds;
    LFrm.SCaption := LFrm.Caption;
    if N = 'AmtNr' then
      LFrm.InLstGridTitleClick(LFrm.InLstGrid.Columns[1])
    else if N = 'Navn' then
      LFrm.InLstGridTitleClick(LFrm.InLstGrid.Columns[2])
    else
      LFrm.InLstGridTitleClick(LFrm.InLstGrid.Columns[0]);
    Result := LFrm.ShowModal = MrOK;
    LFrm.Caption := LFrm.SCaption;
  finally
    LFrm.Free;
  end;

end;

procedure TInLstForm.acAltAExecute(Sender: TObject);
begin
  InLstGridTitleClick(InLstGrid.Columns[1]);
end;

procedure TInLstForm.AcAltKExecute(Sender: TObject);
begin
  InLstGridTitleClick(InLstGrid.Columns[0]);
end;

procedure TInLstForm.acAltNExecute(Sender: TObject);
begin
  InLstGridTitleClick(InLstGrid.Columns[2])
end;

procedure TInLstForm.acLukExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TInLstForm.AcEnterExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TInLstForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  BS: Char;
begin
  if Shift = [] then
  begin
    Case Key of
      VK_DELETE:
        begin
          SKey := ' ';
          BS := #8;
          FormKeyPress(Self, BS);
        end;
    end;
    exit;
  end;
end;

procedure TInLstForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #8 then
    Delete(SKey, Length(SKey), 1)
  else
    SKey := SKey + Key;
  Table.FindNearest([SKey]);
  Caption := SCaption + ' [' + SKey + ']';
end;

procedure TInLstForm.InLstGridDblClick(Sender: TObject);
begin
  ModalResult := MrOK;
end;

end.
