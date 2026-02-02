unit C2Qtnsu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Buttons, ExtCtrls, System.Actions;

type
  TfrmC2Q = class(TForm)
    pnlC2Qbuts: TPanel;
    bitRec: TSpeedButton;
    bitHkb: TSpeedButton;
    bitFort: TSpeedButton;
    bitLukke: TSpeedButton;
    bitNaeste: TSpeedButton;
    ActionList1: TActionList;
    acC2qRec: TAction;
    acC2QHkb: TAction;
    acC2QFort: TAction;
    acC2QLuk: TAction;
    acC2QNaeste: TAction;
    procedure acC2qRecExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure acC2QHkbExecute(Sender: TObject);
    procedure acC2QFortExecute(Sender: TObject);
    procedure acC2QLukExecute(Sender: TObject);
    procedure acC2QNaesteExecute(Sender: TObject);
  private
    { Private declarations }
    procedure SendMess( mess : string);
  public
    { Public declarations }
  end;

var
  frmC2Q: TfrmC2Q;

implementation

uses Main;

{$R *.dfm}

procedure TfrmC2Q.acC2QFortExecute(Sender: TObject);
begin
  SendMess('C2QF3');

end;

procedure TfrmC2Q.acC2QHkbExecute(Sender: TObject);
begin
  SendMess('C2QF2');

end;

procedure TfrmC2Q.acC2QLukExecute(Sender: TObject);
begin
  SendMess('C2QF4');

end;

procedure TfrmC2Q.acC2QNaesteExecute(Sender: TObject);
begin
  SendMess('C2QF5');

end;

procedure TfrmC2Q.acC2qRecExecute(Sender: TObject);
begin
  SendMess('C2QF1');
end;

procedure TfrmC2Q.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then
    ModalResult := mrCancel;
end;

procedure TfrmC2Q.SendMess(mess: string);
var
   stringToSend : Ansistring;
   copyDataStruct : TCopyDataStruct;

  procedure SendData(const copyDataStruct: TCopyDataStruct) ;
  var
    receiverHandle : THandle;
  begin
    receiverHandle := FindWindow(PChar('TStamForm'),PChar('Kasse')) ;
    if receiverHandle = 0 then
    begin
      Exit;
    end;
    SendMessage(receiverHandle, WM_COPYDATA, Integer(Handle), Integer(@copyDataStruct)) ;
  end;
begin
  StamForm.C2QButtonPressed := True;
  stringToSend := ansistring(mess);
  copyDataStruct.dwData := 0; //use it to identify the message contents
  copyDataStruct.cbData := 1 + Length(stringToSend) ;
  copyDataStruct.lpData := PAnsiChar(stringToSend) ;

  SendData(copyDataStruct) ;

  ModalResult := mrOK;
end;

end.
