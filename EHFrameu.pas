unit EHFrameu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Grids, DBGrids, ComCtrls, StdCtrls, ExtCtrls;

type
  TEHFrame = class(TFrame)
    Panel10: TPanel;
    Panel11: TPanel;
    Label63: TLabel;
    lblehlin: TLabel;
    lblehord: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    edtCPR: TEdit;
    btnFilter: TButton;
    chkAabenEordre: TCheckBox;
    dtpEhstart: TDateTimePicker;
    dtpEhSlut: TDateTimePicker;
    pnlEHButtons: TPanel;
    btnSkiftStatus: TButton;
    btnBeskeder: TButton;
    btnSendKvit: TButton;
    btnPrint: TButton;
    btnEHTakser: TButton;
    dbgEHOrd: TDBGrid;
    Panel13: TPanel;
    dbgEHLin: TDBGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
