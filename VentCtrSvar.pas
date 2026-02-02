unit VentCtrSvar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,  ComCtrls;

type
  TCallBackProc   = procedure;
  TfrmVentCtrSvar = class(TForm)
    paCtr1: TPanel;
    paCtgr2: TPanel;
    laCtr2: TLabel;
    amCtr: TAnimate;
    laCtr1: TLabel;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CallBackProc : TCallBackProc;
  end;

var
  frmVentCtrSvar: TfrmVentCtrSvar;

  procedure CtrWaitForCallBack (P : TCallBackProc);

implementation

{$R *.DFM}

procedure CtrWaitForCallBack (P : TCallBackProc);
begin
  FrmVentCtrSvar := TfrmVentCtrSvar.Create (NIL);
  try
    frmVentCtrSvar.CallBackProc := P;
    frmVentCtrSvar.amCtr.Active := True;
    frmVentCtrSvar.ShowModal;
  finally
    frmVentCtrSvar.Free;
    frmVentCtrSvar := NIL;
  end;
end;

procedure TfrmVentCtrSvar.FormActivate(Sender: TObject);
begin
  CallBackProc;
  PostMessage (frmVentCtrSvar.Handle, WM_CLOSE, 0, 0);
end;

end.
