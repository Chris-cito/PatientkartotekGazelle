unit uFrmPositivlist;

{ Developed by: Vitec Cito A/S

  Description: Form to show the positivlist for the region

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  04-03-2024/cjs  Add form and styrke to the F7 screen for positivlist

  01-03-2024/cjs  New form to show positivlist for the region
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Data.DB, Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids, dbclient, Vcl.Mask;

type
  TDBGrid = class(Vcl.DBGrids.TDBGrid)
  private
    procedure UpdateScrollBar; override;
  end;

type
  TfrmPositivList = class(TForm)
    ActionManager1: TActionManager;
    acClose: TAction;
    DBGrid1: TDBGrid;
    DBMemo1: TDBMemo;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    procedure acCloseExecute(Sender: TObject);
  private
    { Private declarations }
    CDS: TClientDataSet;
  public
    { Public declarations }
    class procedure VisPositivlist(ARegionPosList: string);
  end;

implementation

{$R *.dfm}
{ TfrmPositivList }

procedure TfrmPositivList.acCloseExecute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

class procedure TfrmPositivList.VisPositivlist(ARegionPosList: string);
var
  frmPositivList: TfrmPositivList;

begin
  frmPositivList := TfrmPositivList.Create(Nil);
  try

      frmPositivList.ClientDataSet1.LoadFromFile(ARegionPosList);
      frmPositivList.ClientDataSet1.IndexFieldNames := 'VareId';
      frmPositivList.ClientDataSet1.First;
      frmPositivList.ShowModal;
  finally
    frmPositivList.Free;
  end;
end;

{ TDBGrid }

procedure TDBGrid.UpdateScrollBar;
begin

end;

end.
