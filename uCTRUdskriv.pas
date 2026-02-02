unit uCTRUdskriv;

{ Developed by: Vitec Cito A/S

  Description: Ctr print

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  09-10-2020/cjs  Remove the fee from the bottom of ctr-liste report
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls;

type
  TfrmCTRUdskriv = class(TForm)
    rgCTRServer: TRadioGroup;
    rgPeriode: TRadioGroup;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure CTRUdskriv;
  end;


implementation

{$R *.dfm}

uses DM,ChkBoxes,  MidClientApi,
  PatMatrixPrinter,C2Procs, uC2ui.procs;

{ TfrmCTRUdskriv }

procedure TfrmCTRUdskriv.BitBtn1Click(Sender: TObject);
var
  Saldo, UdlFor, Udlign: Currency;
  Forrige, Aktuel: Boolean;
  PNr, CtrTyp, CtrRes: Word;
  CtrLst: TStringList;
  CtrRec: TCtrStatus;
  CTRB: Boolean;
begin
  with MainDm do
  begin
    CTRB := rgCTRServer.ItemIndex = 1;
    Aktuel := rgPeriode.ItemIndex = 0;
    Forrige := rgPeriode.ItemIndex = 1;
    BusyMouseBegin;
    CtrLst := TStringList.Create;
    try
      CtrRes := MidClient.RecvCtrListe(MainDm.nxdb, ffPatKarKundeNr.AsString, Forrige,
        Aktuel, CTRB, CtrLst);
      if CtrRes <> 0 then
      begin
        case CtrRes of
          402:
            ChkBoxOK('Ingen aktuel periode på person!');
          403:
            ChkBoxOK('Ingen forrige periode på person!');
          999:
            ChkBoxOK('Fejl fra CTR, msg. ' + CtrRec.CtrMsg);
        else
          ChkBoxOK('Fejl fra CTR, kode ' + inttostr(CtrRes));
        end;
        ModalResult := mrNone;
        exit;
      end;
      // Saldo
      PNr := 0;
      Saldo := 0;
      Udlign := 0;
      UdlFor := 0;
      CtrTyp := 0;
      FillChar(CtrRec, sizeof(CtrRec), 0);
      cdCtrBev.EmptyDataSet;
      CtrRec.CPRnr := ffPatKarKundeNr.AsString;
      CtrRec.TimeOut := 20000;
      if Forrige then
        MidClient.RecvCtrForrige(CtrRec)
      else
        MidClient.RecvCtrSaldo(CtrRec, cdCtrBev);
      CtrRes := CtrRec.Status;
      if CtrRes = 0 then
      begin
        try
          Saldo := StrToCurr(Trim(CtrRec.Saldo));
        except
        end;
        try
          Udlign := StrToCurr(Trim(CtrRec.Udlign));
        except
        end;
        try
          UdlFor := StrToCurr(Trim(CtrRec.UdlFor));
        except
        end;
        try
          CtrTyp := StrToInt(Trim(CtrRec.PatType));
        except
        end;
        if CTRB then
        begin
          try
            Saldo := StrToCurr(Trim(CtrRec.SaldoB));
          except
          end;
          try
            Udlign := StrToCurr(Trim(CtrRec.UdlignB));
          except
          end;
          try
            UdlFor := StrToCurr(Trim(CtrRec.UdlForB));
          except
          end;

        end;
      end;
      CtrLst.add(FixStr('-', 72));
      CtrLst.add('Aktuel saldo i CTR ' + FixStr('.', 39) +
        FormCurr2Str('###,###,##0.00', Saldo));
      if Udlign <> 0 then
        CtrLst.add('Udligningsbeløb aktuel periode i CTR ' + FixStr('.', 21) +
          FormCurr2Str('###,###,##0.00', Udlign));
      if UdlFor <> 0 then
        CtrLst.add('Udligningsbeløb forrige periode i CTR ' + FixStr('.', 20) +
          FormCurr2Str('###,###,##0.00', UdlFor));
      CtrLst.add(FixStr('=', 72));
      CtrLst.add('');
      CtrLst.add('');
//      CtrLst.add('Vejledende pris for udskrift kr. ' + Trim(stamform.Pris_CTR_ekspliste)
//        + ' incl. moms pr. påbegyndt side dog max.');
//      CtrLst.add('kr. 200 incl. moms for hele listen.');
      CtrLst.add('');
      CtrLst.Insert(0,
        'Filial                               Dato & Tid      Grundlag   Tilskud');
      CtrLst.Insert(0,
        'Apotek/                    Løbenr    Ekspeditionens  Beregnings Indberettet');
      CtrLst.Insert(0, 'Udskrevet for ' + ffPatKarKundeNr.AsString + ' ' +
        BytNavn(ffPatKarNavn.AsString) + ', ' + 'CTR-type ' + inttostr(CtrTyp));
      CtrLst.Insert(0, ffFirmaNavn.AsString);
      if CTRB then
        CtrLst.Insert(0, 'C T R B - T R A N S A K T I O N S L I S T E')
      else
        CtrLst.Insert(0, 'C T R - T R A N S A K T I O N S L I S T E');
      CtrLst.SaveToFile('C:\C2\Temp\CtrListe.Txt');
      PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\CtrListe.Txt');
    finally
      CtrLst.Free;
      BusyMouseEnd;
    end;
  end;
end;

class procedure TfrmCTRUdskriv.CTRUdskriv;
begin
  with TfrmCTRUdskriv.Create(Nil) do
  begin
    try
      ShowModal;
    finally
      Free;
    end;

  end;

end;

procedure TfrmCTRUdskriv.FormShow(Sender: TObject);
begin
  rgCTRServer.ItemIndex := 0;
  rgPeriode.ItemIndex := 0;
end;

end.
