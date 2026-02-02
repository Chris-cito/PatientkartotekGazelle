unit frmHenstandsOrdning;

{ Developed by: Vitec Cito A/S

  Description: Henstandsordning dialog in PatientKartotek.

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  10-06-2021/MA   To fully support X-eCPR, the LMSModtager is submitted to CTR - not the Kundenr.
                  This is reflected in the change of ShowForm which now expects parameters.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxLayoutContainer, dxLayoutControlAdapters, StdCtrls, Buttons, ExtCtrls,
  ComCtrls, dxLayoutControl, PlatformDefaultStyleActnCtrls, ActnList, ActnMan, System.Actions,
  cxClasses;

type
  TFmHenstandsOrdning = class(TForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    dxLayoutControl1Group2: TdxLayoutGroup;
    EditCPRNr: TEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    DateTimePicker1: TDateTimePicker;
    dxLayoutControl1Item1: TdxLayoutItem;
    DateTimePicker2: TDateTimePicker;
    dxLayoutControl1Item3: TdxLayoutItem;
    RadioGroup1: TRadioGroup;
    dxLayoutControl1Item4: TdxLayoutItem;
    BitBtn1: TBitBtn;
    dxLayoutControl1Item5: TdxLayoutItem;
    BitBtn2: TBitBtn;
    dxLayoutControl1Item6: TdxLayoutItem;
    CheckBoxAktiv: TCheckBox;
    dxLayoutControl1Item8: TdxLayoutItem;
    ActionManager1: TActionManager;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure CheckBoxAktivClick(Sender: TObject);
  private
    { Private declarations }
    FAfdelingLmsNr: string;
    FKundeNr: string;
    FLmsModtager: string;

    property AfdelingLmsNr: string read FAfdelingLmsNr write FAfdelingLmsNr;
    property KundeNr: string read FKundeNr write FKundeNr;
    property LmsModtager: string read FLmsModtager write FLmsModtager;
  public
    { Public declarations }
    class procedure ShowForm(AKundeNr, ALmsModtager, AAfdelingLmsNr: string);
  end;


implementation

uses DM, MidClientApi, ChkBoxes;

{$R *.dfm}

procedure TFmHenstandsOrdning.BitBtn1Click(Sender: TObject);
var
  ResultCode : integer;

  function HenstansKode(IndexNr: integer) : integer;
  begin
    Result := 0;
    case IndexNr of
      0: Result:= 1;
      1: Result := 99;
    end;
  end;

  function HenstandsMessage(Kode : integer) : string;
  begin
    case Kode of
      1800 : Result := 'Alt OK! - Henstandsordning er oprettet i Det Centrale Tilskudsregister.';
      1801 : Result := 'Alt OK! - Henstandsordning er opdateret i Det Centrale Tilskudsregister.';
      1802 : Result := 'Alt OK! - Henstandsordning er ophørt i Det Centrale Tilskudsregister.';
      1852 : Result := 'CPR-nummer er ikke et korrekt CTR-fiktivt CPR nummer.';
      1854 : Result := 'Invalid start date';
      1855 : Result := 'Invalid slut date';
      1860 : Result := 'CPR nummer er ikke gyldigt';
      1862 : Result := 'Ugyldigt apoteksnr.';
      1864 : Result := 'Indgåelsesdato skal være ældre end eller lig med dags dato ved oprettelse af henstandsordning.';
      1867 : Result := 'Indgåelsesdato skal være ældre end ophørsdato.';
      1891 : Result := 'Årsag til ophør er ikke angivet. Henstandsordning er ikke ophørt i Det Centrale Tilskudsregister.';
      1892 : Result := 'Henstandsordning kan ikke oprettes idet patient har en aktiv henstandsordning.';
      1893 : Result := 'Den efterspurgte person har ingen aktuel tilskudsperiode i Det Centrale Tilskudsregister.';
      1894 : Result := 'Henstandsordning kan ikke oprettes da indgåelsesdatoen ligger uden for aktuel tilskudsperiode i Det Centrale Tilskudsregister.';
      1895 : Result := 'Henstandsordning kan ikke oprettes da ophørsdatoen ligger uden for aktuel tilskudsperiode i Det Centrale Tilskudsregister.';
      1896 : Result := 'Henstandsordning kan kun bringes til ophør af ejer apotek i Det Centrale Tilskudsregister.';
    else
      Result := 'Fejl + ' + IntToStr(Kode);
    end;
  end;

begin
  if DateTimePicker1.Date >= DateTimePicker2.Date then
  begin
    ChkBoxOK('Slutdato skal være større end startdato');
    ModalResult := mrNone;
    exit;
  end;

  if CheckBoxAktiv.Checked then
  begin
    ResultCode := MidClient.SendCTRHenstansOrdning(LmsModtager,
                                      DateTimePicker1.Date,
                                      DateTimePicker2.Date,
                                      AfdelingLmsNr,
                                      true,
                                      0);
  end
  else
  begin
    ResultCode := MidClient.SendCTRHenstansOrdning(LmsModtager,
                                      DateTimePicker1.Date,
                                      DateTimePicker2.Date,
                                      AfdelingLmsNr,
                                      False,
                                      HenstansKode(RadioGroup1.ItemIndex));
  end;

  ChkBoxOK(HenstandsMessage(ResultCode));
  if ResultCode > 1802 then
    ModalResult := mrNone;
end;

procedure TFmHenstandsOrdning.CheckBoxAktivClick(Sender: TObject);
begin
  RadioGroup1.Enabled := not CheckBoxAktiv.Checked;
  if RadioGroup1.Enabled then
  begin
    RadioGroup1.ItemIndex := 1;
    RadioGroup1.SetFocus;
  end;
end;

procedure TFmHenstandsOrdning.FormShow(Sender: TObject);
var
  CtrRec: TCtrStatus;
  yyyy,mm,dd : integer;
  StrDate : string;
begin
  with MainDm do
  begin
    EditCPRNr.Text := KundeNr;
    FillChar(CtrRec, SizeOf (CtrRec), 0);
    cdCtrBev.EmptyDataSet;
    CtrRec.CprNr  := LmsModtager;
    CtrRec.TimeOut:= 20000;
    MidClient.RecvCtrSaldo(CtrRec, cdCtrBev);
    if CtrRec.Status = 0 then
    begin
      if CtrRec.pt_henstandsordning_aktiv then
      begin
        CheckBoxAktiv.Checked := true;
        MidClient.RecvCtrHenstansOrdning(LmsModtager, cdsHenstandsOrdning);
        cdsHenstandsOrdning.First;
        while not cdsHenstandsOrdning.Eof do
        begin
          if cdsHenstandsOrdningaktiv.AsString = 'Y' then
          begin
            StrDate := cdsHenstandsOrdningindgaaelsesdato.AsString;
            yyyy := StrToInt(copy(StrDate,1,4));
            mm := StrToInt(copy(StrDate,5,2));
            dd := StrToInt(copy(StrDate,7,2));
            DateTimePicker1.Date := EncodeDate(yyyy,mm,dd);
            StrDate := cdsHenstandsOrdningophoersdato.AsString;
            yyyy := StrToInt(copy(StrDate,1,4));
            mm := StrToInt(copy(StrDate,5,2));
            dd := StrToInt(copy(StrDate,7,2));
            DateTimePicker2.Date := EncodeDate(yyyy,mm,dd);
            break;
          end;
          cdsHenstandsOrdning.Next;
        end;
        CheckBoxAktiv.SetFocus;
      end
      else
      begin
        ChkBoxOK('Ingen eksisterende henstandsordning for denne kunde');
        DateTimePicker1.Date := trunc(date);
        yyyy := strtoint(copy(CtrRec.PerSlut,7,4));
        mm := StrToInt(copy(CtrRec.PerSlut,4,2));
        dd := StrToInt(copy(CtrRec.PerSlut,1,2));
        DateTimePicker2.Date := EncodeDate(yyyy,mm,dd);
        CheckBoxAktiv.Checked := True;
        RadioGroup1.Enabled := False;
        CheckBoxAktiv.SetFocus;
      end;
    end
    else
    begin
      ChkBoxOK('CTR status for kunde ' + CtrRec.CtrMsg);
      PostMessage(Handle,WM_CLOSE,0,0);
    end;
  end;
end;

class procedure TFmHenstandsOrdning.ShowForm(AKundeNr, ALmsModtager, AAfdelingLmsNr: string);
begin
  with TFmHenstandsOrdning.Create(Nil) do
  begin
    try
      FAfdelingLmsNr := AAfdelingLmsNr;
      FKundeNr := AKundeNr;
      FLmsModtager := ALmsModtager;

      ShowModal;
    finally
      Free;
    end;
  end;
end;

end.
