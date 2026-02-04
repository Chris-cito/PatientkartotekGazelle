unit uCTRUdskriv;

{ Developed by: Vitec Cito A/S

  Description: CTR print

  Highest assigned Tilstand: x00000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  28-01-2026/cjs  Allow bruger 99 to access ctr using the system certificate
                  Correct the columns on the report to show the correct values from CTR-2

  25-09-2025/cjs  Changed 401 message to be as more explantory message when getting ctr for a patient.

  11-06-2021/MA   Incorrect use of KundeNr. Changed to LMSModtager.

  10-06-2021/MA   To fully support X-eCPR, the LMSModtager is submitted to CTR - not the Kundenr.

  09-10-2020/cjs  Remove the fee from the bottom of ctr-liste report
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  SYSTEM.StrUtils,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, dxSkinsCore, dxSkinBasic, dxSkinLilian, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxButtons, Vcl.StdCtrls, Data.DbxDatasnap, Data.DBXCommon, IPPeerClient, Data.DB, Data.SqlExpr;

type
  TfrmCTRUdskriv = class(TForm)
    rgCTRServer: TRadioGroup;
    rgPeriode: TRadioGroup;
    Panel1: TPanel;
    BitBtn2: TcxButton;
    BitBtn1: TcxButton;
    SQLConnection1: TSQLConnection;
    procedure BitBtn1_Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure CTR2TransactionList(const AKundenr: string; ACTRB, ACurrentPeriod: Boolean;  ATransactionList : TStringList);

    { Private declarations }
  public
    { Public declarations }
    class procedure CTRUdskriv;
  end;

implementation

{$R *.dfm}

uses
  uCTRClientMethods, uCtr2.TransactionList.Classes,uCtr2.Connection.Response,uCTr2.CreateTransaction.Classes, uCtr2.Connection.Types,
  uctr2.Fault.Classes, uCtr2.Connection.Constants, uCTR2.CreateFictitiousPersonIdentifier.classes,
  DM, ChkBoxes, MidClientApi, PatMatrixPrinter, C2Procs, uC2ui.procs,uC2Environment,uC2Environment.Classes,C2MainLog;

{ TfrmCTRUdskriv }


procedure TfrmCTRUdskriv.CTR2TransactionList(const AKundenr : string; ACTRB,ACurrentPeriod : Boolean;
  ATransactionList : TStringList);
var
  LCli : TServerMethods1Client;
  Lresponse: string;
  LErrorCode: Integer;
  LErrorstring: string;
  LTransactionsResponse : TGetTransactionsResponse;
  LLogString : string;
  PNr : Word;
  LCtrType : string;
  LSaldo : Currency;
  LLbnrLinenr : string;
begin
  if (MainDm.BrugerNr <> 99) and (not maindm.Bruger.HasValidSosiIdOnServer) then
  begin
    // message about user not being logged in
    TaskMessageDlg('Bemærk',PWideChar('CTR2 : Bruger skal være logget ind med MitID'),TMsgDlgType.mtInformation,
      [TMsgDlgBtn.mbOK],0);
  end;


  SQLConnection1.Params.Values['Hostname'] := C2Env.C2ServerAddress;
  SQLConnection1.Open;
  LCli := TServerMethods1Client.Create(SQLConnection1.DBXConnection);
  var LAccountName := IfThen(ACTRB,'CTR-B','CTR-A');
  var LPeriod := IfThen(ACurrentPeriod,'Aktuel','Forrige');
  try
    // first call getctr from the ctrserver
    var LBrugernr := MainDm.BrugerNr;
    if LBrugernr = 99 then
      LBrugernr := 0;

    LCli.GetCtr(MainDm.AfdNr,LBrugernr,AKundenr,Lresponse,LErrorCode,LErrorstring,LLogString);

    c2logadd(LLogString);



    LCli.GetTransactionList(MainDm.AfdNr,LBrugerNr,AKundenr,LAccountName,LPeriod,
      Lresponse,LErrorCode,LErrorstring,LLogString);
    if LErrorCode <>  TStatusCode.OK then
    begin
      // LResponse is a fault class
      var LFault := TFault.ParseXml(Lresponse);
      try
        ChkBoxOK(LFault.FaultCode + ' ' + LFault.FaultString);
//        cxMemo1.lines.Clear;
//        cxMemo1.Lines.Add(LFault.FaultCode + ' ' + LFault.FaultString);
//        for var LDetails in lfault.Details do
//        begin
//            cxMemo1.Lines.Add(LDetails.Key + ' - ' + LDetails.Value);
//        end;


      finally
        LFault.Free;
      end;
      Exit;
    end;
    C2LogAdd(Lresponse);
    LTransactionsResponse := TGetTransactionsResponse.FromXml(Lresponse);
    try
      LCtrType := LTransactionsResponse.PatientStatus.Status;
//      cxMemo1.Lines.Clear;
//      cxMemo1.Lines.Add(LTransactionsResponse.PersonIdentifier);
//      cxMemo1.Lines.Add(LTransactionsResponse.IsChild.ToString(True));
//      cxMemo1.lines.Add(LTransactionsResponse.PatientStatus.ToString);
      for var LAccount in LTransactionsResponse.Accounts do
      begin
        if LAccount.Period = nil then
        begin
          ChkBoxOK('Der kunne ikke findes nogen transaktioner i denne CTR periode.');
          Exit;
        end;

        for var Transactions in LAccount.Period.Transactions do
        begin
//          cxMemo1.lines.Add(Transactions.TransactionIdentifier + '-' + Transactions.PharmacyName + '-' +
//            Transactions.AdministrationIdentifier)
          var LApoteksnr := Transactions.PharmacyIdentifier;
          var LApotekName := Transactions.PharmacyName;
          var LapoteksEkspedition := Transactions.AdministrationIdentifier;
          var LApotekspeditionBits := LapoteksEkspedition.Split([',']);
          LLbnrLinenr := LApotekspeditionBits[0].PadLeft(9);
          if Length(LApotekspeditionBits) = 2 then
            LLbnrLinenr := LLbnrLinenr + '-' + LApotekspeditionBits[1].PadLeft(2)
          else
            LLbnrLinenr := LLbnrLinenr + '   ';

          var LEkspeditionsTid := Transactions.AdministrationDateTime;
          var LBGP := Transactions.ReimbursementBasePrice;
          var LIBT := Transactions.ReportedReimbursement;
          LSaldo := Transactions.Balance;
          ATransactionList.Add(Format('%-20.20s %s  %s%s%s',
            [LApotekName.Substring(0,20),LLbnrLinenr,FormatDateTime('dd-mm-yyyy hh:nn',LEkspeditionsTid),
            FormCurr2Str('########0.00',LBGP),FormCurr2Str('########0.00',LIBT)]));
        end;

      end;
    finally
      LTransactionsResponse.Free;
    end;
  finally

    LCli.Free;
    SQLConnection1.Close;
  end;

  ATransactionList.add(StringOfChar('-', 75));
  ATransactionList.add('Aktuel saldo i CTR '.PadRight(61, '.') + FormCurr2Str('###,###,##0.00', LSaldo));
//    if Udlign <> 0 then
//      ATransactionList.add('Udligningsbeløb aktuel periode i CTR '.PadRight(61, '.') + FormCurr2Str('###,###,##0.00', Udlign));
//    if UdlFor <> 0 then
//      ATransactionList.add('Udligningsbeløb forrige periode i CTR '.PadRight(61, '.') + FormCurr2Str('###,###,##0.00', UdlFor));
  ATransactionList.add(StringOfChar('=', 75));
  ATransactionList.add('');
  ATransactionList.add('');
//      CtrLst.add('Vejledende pris for udskrift kr. ' + Trim(stamform.Pris_CTR_ekspliste)
//        + ' incl. moms pr. påbegyndt side dog max.');
//      CtrLst.add('kr. 200 incl. moms for hele listen.');
  ATransactionList.add('');
  ATransactionList.Insert(0, 'Filial                               Dato & Tid      Grundlag   Tilskud');
  ATransactionList.Insert(0, 'Apotek/                    Løbenr    Ekspeditionens  Beregnings Indberettet');
  ATransactionList.Insert(0, 'Udskrevet for ' + MainDm.ffPatKarKundeNr.AsString + ' ' + BytNavn(MainDm.ffPatKarNavn.AsString) +
    ', CTR-type ' + LCtrType);
  ATransactionList.Insert(0, MainDm.ffFirmaNavn.AsString);
  if ACTRB then
    ATransactionList.Insert(0, 'C T R B - T R A N S A K T I O N S L I S T E')
  else
    ATransactionList.Insert(0, 'C T R - T R A N S A K T I O N S L I S T E');
  ATransactionList.SaveToFile('C:\C2\Temp\CtrListe.Txt');
  PNr := 0;
  PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\CtrListe.Txt');


end;

procedure TfrmCTRUdskriv.BitBtn1_Click(Sender: TObject);
var
  Saldo, UdlFor, Udlign: Currency;
  Forrige, Aktuel: Boolean;
  PNr, CtrTyp, CtrRes: Word;
  CtrLst: TStringList;
  CtrRec: TCtrStatus;
  CTRB: Boolean;
begin

  CTRB := rgCTRServer.ItemIndex = 1;
  Aktuel := rgPeriode.ItemIndex = 0;
  Forrige := rgPeriode.ItemIndex = 1;
  BitBtn1.Enabled := False;
  BusyMouseBegin;
  CtrLst := TStringList.Create;
  if MainDm.IsCTR2Enabled then
  begin
    if  (MainDm.BrugerNr <> 99) and (not maindm.Bruger.HasValidSosiIdOnServer) then
    begin
      // message about user not being logged in
      TaskMessageDlg('Bemærk',PWideChar('CTR2 : Bruger skal være logget ind med MitID'),TMsgDlgType.mtInformation,
        [TMsgDlgBtn.mbOK],0);
      Exit;
    end;
  end;
  try
    if MainDm.IsCTR2Enabled then
    begin
      CTR2TransactionList(MainDm.ffPatKarLmsModtager.AsString,CTRB,Aktuel,CtrLst);
      Exit;
    end
    else
    begin
      CtrRes := MidClient.RecvCtrListe(MainDm.nxdb, MainDm.ffPatKarLmsModtager.AsString, Forrige, Aktuel, CTRB, CtrLst);
      if CtrRes <> 0 then
      begin
        case CtrRes of
          401:
            ChkBoxOK('Der kunne ikke findes nogen transaktioner i denne CTR periode.');
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

    end;


    // Saldo
    PNr := 0;
    Saldo := 0;
    Udlign := 0;
    UdlFor := 0;
    CtrTyp := 0;
    FillChar(CtrRec, sizeof(CtrRec), 0);
    MainDm.cdCtrBev.EmptyDataSet;
    CtrRec.CPRnr := MainDm.ffPatKarLmsModtager.AsString;
    CtrRec.TimeOut := 20000;
    if Forrige then
      MidClient.RecvCtrForrige(CtrRec)
    else
      MidClient.RecvCtrSaldo(CtrRec, MainDm.cdCtrBev);
    CtrRes := CtrRec.Status;
    if CtrRes = 0 then
    begin
      Saldo := StrToCurrDef(Trim(CtrRec.Saldo), 0.0);
      Udlign := StrToCurrDef(Trim(CtrRec.Udlign), 0.0);
      UdlFor := StrToCurrDef(Trim(CtrRec.UdlFor), 0.0);
      CtrTyp := StrToIntDef(Trim(CtrRec.PatType), 0);
      if CTRB then
      begin
        Saldo := StrToCurrDef(Trim(CtrRec.SaldoB), 0.0);
        Udlign := StrToCurrDef(Trim(CtrRec.UdlignB), 0.0);
        UdlFor := StrToCurrDef(Trim(CtrRec.UdlForB), 0.0);

      end;
    end;
    CtrLst.add(StringOfChar('-', 75));
    CtrLst.add('Aktuel saldo i CTR '.PadRight(61, '.') + FormCurr2Str('###,###,##0.00', Saldo));
    if Udlign <> 0 then
      CtrLst.add('Udligningsbeløb aktuel periode i CTR '.PadRight(61, '.') + FormCurr2Str('###,###,##0.00', Udlign));
    if UdlFor <> 0 then
      CtrLst.add('Udligningsbeløb forrige periode i CTR '.PadRight(61, '.') + FormCurr2Str('###,###,##0.00', UdlFor));
    CtrLst.add(StringOfChar('=', 75));
    CtrLst.add('');
    CtrLst.add('');
//      CtrLst.add('Vejledende pris for udskrift kr. ' + Trim(stamform.Pris_CTR_ekspliste)
//        + ' incl. moms pr. påbegyndt side dog max.');
//      CtrLst.add('kr. 200 incl. moms for hele listen.');
    CtrLst.add('');
    CtrLst.Insert(0, 'Filial                               Dato & Tid      Grundlag   Tilskud');
    CtrLst.Insert(0, 'Apotek/                    Løbenr    Ekspeditionens  Beregnings Indberettet');
    CtrLst.Insert(0, 'Udskrevet for ' + MainDm.ffPatKarKundeNr.AsString + ' ' + BytNavn(MainDm.ffPatKarNavn.AsString) + ', ' +
      'CTR-type ' + inttostr(CtrTyp));
    CtrLst.Insert(0, MainDm.ffFirmaNavn.AsString);
    if CTRB then
      CtrLst.Insert(0, 'C T R B - T R A N S A K T I O N S L I S T E')
    else
      CtrLst.Insert(0, 'C T R - T R A N S A K T I O N S L I S T E');
    CtrLst.SaveToFile('C:\C2\Temp\CtrListe.Txt');
    PatMatrixPrnForm.PrintMatrix(PNr, 'C:\C2\Temp\CtrListe.Txt');
  finally
    CtrLst.Free;
    BusyMouseEnd;
    BitBtn1.Enabled := True;
  end;
end;

class procedure TfrmCTRUdskriv.CTRUdskriv;
begin
  if maindm.ffPatKarLmsModtager.AsString.IsEmpty then
    exit;
  with TfrmCTRUdskriv.Create(Application) do
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

