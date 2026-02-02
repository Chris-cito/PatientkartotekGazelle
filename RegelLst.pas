unit RegelLst;

{ Developed by: Vitec Cito A/S

  Description: Tilskud regels screen

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  11-04-2024/cjs  Correction to bug in Tilskud regele screen where it was not possible to select a regel

  09-04-2024/cjs  Changed the navn field field on tilskud regel popup screen
                  to be wide enough for 50 characters
                  C2MM-83


}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBGrids, ExtCtrls, Db, nxdb, Vcl.Grids;

type
  TReLstForm = class(TForm)
    ReLstGrid: TDBGrid;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ReLstGridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Table: TnxTable;
    SCaption, SKey: String;
    class function ShowReLst(Ds: TDataSource; Tb: TnxTable): Boolean;
  end;


implementation

{$R *.DFM}

class function TReLstForm.ShowReLst(Ds: TDataSource; Tb: TnxTable): Boolean;
var
  LFrm: TReLstForm;
begin
  LFrm := TReLstForm.Create(Nil);
  try
    LFrm.Table := Tb;
    LFrm.ReLstGrid.DataSource := Ds;
    LFrm.SCaption := Lfrm.Caption;
    Result := LFrm.ShowModal = MrOK;
    LFrm.Caption := Lfrm.SCaption;
  finally
    LFrm.Free;
  end;
end;

procedure TReLstForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  BS: Char;
begin
  if Shift = [] then
  begin
    Case Key of
      VK_HOME, VK_END, VK_UP, VK_DOWN, VK_PRIOR, VK_NEXT:
        ;
      VK_DELETE:
        begin
          SKey := ' ';
          BS := #8;
          FormKeyPress(Self, BS);
        end;
      VK_ESCAPE:
        begin
          ModalResult := mrCancel;
          Key := 0;
        end;
      VK_RETURN:
        begin
          ModalResult := MrOK;
          Key := 0;
        end;
    end;
  end;
end;

procedure TReLstForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if CharInSet(Key, [#13, #27]) then
    exit;

  if Key = #8 then
    Delete(SKey, Length(SKey), 1)
  else
    SKey := SKey + Key;
  Table.FindNearest([SKey]);
  Caption := SCaption + ' [' + SKey + ']';
end;

procedure TReLstForm.ReLstGridDblClick(Sender: TObject);
var
  K: Word;
begin
  K := VK_RETURN;
  FormKeyDown(Self, K, []);
end;

end.
