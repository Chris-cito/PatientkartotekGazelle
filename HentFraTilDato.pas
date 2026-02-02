unit HentFraTilDato;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls, DBCtrls;

type
  TFraTilDatoForm = class(TForm)
    ButOK: TBitBtn;
    eFra: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    eTil: TDateTimePicker;
    lbAfd: TComboBox;
    rgSort: TRadioGroup;
    Label3: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    AfdSl : TStringList;
  public
    { Public declarations }
  end;

  function TastDatoer (S : String; var FraDato, TilDato : TDateTime) : Boolean; overload;
  function TastDatoer (S : String; var FraDato, TilDato : TDateTime;
        var afdeling : integer; var sortype : integer) : Boolean; overload;

var
  FraTilDatoForm: TFraTilDatoForm;
implementation

uses DM;

{$R *.DFM}

function TastDatoer (S : String; var FraDato, TilDato : TDateTime) : Boolean;
begin
  FraTilDatoForm := TFraTilDatoForm.Create (NIL);
  try
    FraTilDatoForm.Caption   := S;
    FraTilDatoForm.eFra.Date := FraDato;
    FraTilDatoForm.eTil.Date := TilDato;
    FraTilDatoForm.lbAfd.Enabled := False;
    FraTilDatoForm.rgSort.Enabled := False;
    FraTilDatoForm.Height := 91;
    FraTilDatoForm.ShowModal;
  finally
    if FraTilDatoForm.ModalResult = mrOk then
    begin
      try
        FraDato := FraTilDatoForm.eFra.Date;
        TilDato := FraTilDatoForm.eTil.Date;
      except
      end;
    end;
    Result := FraTilDatoForm.ModalResult = mrOK;
    FraTilDatoForm.Free;
    FraTilDatoForm := NIL;
  end;
end;

function TastDatoer (S : String; var FraDato, TilDato : TDateTime;
        var afdeling : integer; var sortype : integer) : Boolean;
begin
  FraTilDatoForm := TFraTilDatoForm.Create (NIL);
  try
    FraTilDatoForm.AfdSl := TStringList.Create;
    FraTilDatoForm.Caption   := S;
    FraTilDatoForm.eFra.Date := FraDato;
    FraTilDatoForm.eTil.Date := TilDato;
    FraTilDatoForm.lbAfd.Enabled := true;
    FraTilDatoForm.rgSort.Enabled := true;
    FraTilDatoForm.lbAfd.Items.Clear;
    with maindm do
    begin
      nxAfd.First;
      while not nxAfd.Eof do
      begin
        FraTilDatoForm.lbAfd.Items.Add(trim(nxAfdNavn.AsString));
        FraTilDatoForm.AfdSl.Add(inttostr(nxAfdRefNr.AsInteger));
        nxAfd.Next;
      end;


    end;
    FraTilDatoForm.lbAfd.ItemIndex := 0;
    FraTilDatoForm.ShowModal;
  finally
    if FraTilDatoForm.ModalResult = mrOk then
    begin
      try
        FraDato := FraTilDatoForm.eFra.Date;
        TilDato := FraTilDatoForm.eTil.Date;
        afdeling := strtoint(FraTilDatoForm.AfdSl.Strings[FraTilDatoForm.lbAfd.ItemIndex]);
        sortype := FraTilDatoForm.rgSort.ItemIndex;
      except
      end;
    end;
    Result := FraTilDatoForm.ModalResult = mrOK;
    FraTilDatoForm.AfdSl.Free;
    FraTilDatoForm.Free;
    FraTilDatoForm := NIL;
  end;
end;


procedure TFraTilDatoForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key,[#13,#27]) then
      exit;

  if Key = #13 then begin
    if ActiveControl.Name = 'eFra' then
    begin
      eTil.SetFocus;
      Key := #0;
      exit;
    end;
    if ActiveControl.Name = 'eTil' then
    begin
      ButOk.SetFocus;
      Key := #0;
      exit;
    end;
  end;
  if Key = #27 then
  begin
    ModalResult := mrCancel;
    Key         := #0;
  end;
end;

end.
