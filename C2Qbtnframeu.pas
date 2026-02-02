unit C2Qbtnframeu;

{ Developed by: Vitec Cito A/S

  Description: Frame that shows the buttons for C2Kø system

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  20-11-2020/cjs  Changed c2kø buttons to be speedbutton so that they do not keep focus
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, ActnList, System.Actions, C2MainLog;

type
  TC2QFrame = class(TFrame)
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
    procedure acC2QHkbExecute(Sender: TObject);
    procedure acC2QFortExecute(Sender: TObject);
    procedure acC2QLukExecute(Sender: TObject);
    procedure acC2QNaesteExecute(Sender: TObject);
  private
    { Private declarations }
    procedure SendMess( AMess : string);
  public
    { Public declarations }
  end;

implementation

uses Main;

{$R *.dfm}

procedure TC2QFrame.acC2QFortExecute(Sender: TObject);
begin
  SendMess('C2QF3');

end;

procedure TC2QFrame.acC2QHkbExecute(Sender: TObject);
begin
  SendMess('C2QF2');

end;

procedure TC2QFrame.acC2QLukExecute(Sender: TObject);
begin
  SendMess('C2QF4');

end;

procedure TC2QFrame.acC2QNaesteExecute(Sender: TObject);
begin
  SendMess('C2QF5');

end;

procedure TC2QFrame.acC2qRecExecute(Sender: TObject);
begin
  SendMess('C2QF1');

end;

procedure TC2QFrame.SendMess(AMess: string);
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
  C2logadd('C2KØ : Sendmess : ' + AMess);
  StamForm.C2QButtonPressed := True;
  stringToSend := ansistring(AMess);
  copyDataStruct.dwData := 0; //use it to identify the message contents
  copyDataStruct.cbData := 1 + Length(stringToSend) ;
  copyDataStruct.lpData := PAnsiChar(stringToSend) ;

  SendData(copyDataStruct) ;

end;

end.
