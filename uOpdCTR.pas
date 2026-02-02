unit uOpdCTR;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, Grids, DBGrids;

type
  TfrmOpdCTR = class(TForm)
    dbgOpdCTR: TDBGrid;
    Panel1: TPanel;
    btnSlet: TButton;
    BitBtn1: TBitBtn;
    timOpdCTR: TTimer;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure timOpdCTRTimer(Sender: TObject);
    procedure dbgOpdCTRDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnSletClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowOpdCTR;
  end;

implementation

uses DM;

{$R *.dfm}
{ TfrmOpdCTR }

class procedure TfrmOpdCTR.ShowOpdCTR;
var
  LFrm: TfrmOpdCTR;
begin
  LFrm := TfrmOpdCTR.Create(Nil);
  try
    LFrm.ShowModal;
  finally
    LFrm.Free;
  end;
end;

procedure TfrmOpdCTR.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    ModalResult := mrCancel;
end;

procedure TfrmOpdCTR.FormShow(Sender: TObject);
begin
  MainDm.ffCtrOpd.Last;
  btnSlet.SetFocus;

end;

procedure TfrmOpdCTR.timOpdCTRTimer(Sender: TObject);
begin
  MainDm.ffCtrOpd.Refresh;
  MainDm.ffCtrOpd.Last;

end;

procedure TfrmOpdCTR.dbgOpdCTRDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  LStatus: Integer;
begin
  try
    LStatus := MainDm.ffCtrOpdStatus.AsInteger;
    if LStatus <> 0 then
    begin
      case LStatus of
        2:
          dbgOpdCTR.Canvas.Brush.Color := clYellow;
      else
        dbgOpdCTR.Canvas.Brush.Color := clRed;
      end;
    end;
  finally
    dbgOpdCTR.Canvas.Font.Color := clBlack;
    dbgOpdCTR.DefaultDrawColumnCell(Rect, DataCol, Column, State);

  end;
end;

procedure TfrmOpdCTR.btnSletClick(Sender: TObject);
begin
  timOpdCTR.Enabled := False;
  try
    MainDm.ffCtrOpd.Last;
    if (MainDm.ffCtrOpdStatus.AsInteger <> 0) and (MainDm.ffCtrOpdStatus.AsInteger <> 2) then
      MainDm.ffCtrOpd.Delete;
  finally
    timOpdCTR.Enabled := True;
  end;
end;

end.
