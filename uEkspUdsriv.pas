unit uEkspUdsriv;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TfrmEkspUdskriv = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    eFra: TDateTimePicker;
    eTil: TDateTimePicker;
    rgDetailedList: TRadioGroup;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
    class function ShowForm(var AFraDato: tdatetime; var aTilDato: tdatetime;
      var aDetailedList: boolean): boolean;
  end;


implementation

{$R *.dfm}

{ TfrmEkspUdskriv }

class function TfrmEkspUdskriv.ShowForm(var AFraDato, aTilDato: TDateTime;
  var aDetailedList: boolean): boolean;
begin

  Result := False;
  with TfrmEkspUdskriv.Create(Nil) do
  begin
    try
      eFra.Date := AFraDato;
      eTil.Date := aTilDato;
      rgDetailedList.ItemIndex := 0;
      if ShowModal = mrOk then
      begin
        AFraDato := eFra.Date;
        aTilDato := eTil.Date;
        aDetailedList := rgDetailedList.ItemIndex = 1;
        Result := True;
      end;
    finally
      Free;
    end;

  end;
end;

end.
