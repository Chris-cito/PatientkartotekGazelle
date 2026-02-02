unit BonPrinter;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms,   Dialogs,
  ExtCtrls;

const
  pkF7X9NOR      = #27#85#0#27#33#1;
  pkF9X9NOR      = #27#85#0#27#33#0;
  pkF9X9DW       = #27#85#0#27#33#32;
  pkCUT          = #27#105;
  pkCRLF         = #13#10;
  pkLF           = pkCRLF;
  pkLEFT         = #27#97#0;
  pkCENTER       = #27#97#1;
  pkRIGHT        = #27#97#2;
  pkLF5          = pkLF + pkLF + pkLF + pkLF + pkLF;
  pkAFSLUT       = #10#10#10#10#10#10;
  pkAFSLUTCUT    = #10#10#10#10#10#10#27#105;
  pkKICKDRW      = #27#112#0#50#200;
  pkRESET        = #27#64;
  pkDANSK        = #27#82#4;
  pkINIT         = pkRESET + pkF9X9NOR + pkDANSK;
  pkCLEAR        = #12;
  pkDISPON       = #27#61#2 + pkCLEAR + pkDANSK;
  pkDISPOFF      = #27#61#1;
  pkDISPOPEN     = 1;
  pkDISPSALG     = 2;
  pkDISPBETAL    = 3;
  pkDISPAFSLUT   = 4;
  pkDISPPAUSE    = 5;
  pkDISPANNUL    = 6;
  pkDISPINDBET   = 7;
  pkDISPUDBET    = 8;

type
  EEcrPrintError = class(Exception);
  TPrintForm = class(TDataModule)
    procedure PrintFormCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    BonList : TStringList;
  public

  end;

procedure UdskrivBon (sl : tstringlist);

var
  PrintForm: TPrintForm;

implementation

uses


  C2Procs,
   frmMidCli;

{$R *.DFM}





procedure UdskrivBon (sl: TStringList);
var
  txt : string;

begin
  with PrintForm do
  begin
    try
      BonList.Add(pkINIT);
      BonList.Add(pkLEFT);
      for txt in sl do
      begin
        BonList.Add(pkDANSK + Dos2Iso(txt));
      end;
      bonlist.Add(pkAFSLUTCUT);
    finally
      MidCli.UdskrivBon(BonList);

    end;
  end;
end;


procedure TPrintForm.DataModuleDestroy(Sender: TObject);
begin
  BonList.Free;
end;

procedure TPrintForm.PrintFormCreate(Sender: TObject);
begin
  BonList := TStringList.Create;
end;

end.
