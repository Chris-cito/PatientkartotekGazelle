unit RSEkspFejlu;

{ Developed by: Cito IT A/S

  Description: FMK failures screen

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  11-02-2020/cjs  Show bruger afslut column and all ret on 4202 to resubmit with reported by current
                  bruger (like 1 does)

  10-02-2020/cjs  Enable Ret button for 109 and 851

  05-02-2020/cjs  Ret button now will allow function if sygehus is not valid

  05-02-2020/cjs  Enable ret button if invalid sygehus nummer

  23-01-2020/cjs  Fixed error that did not enable ret button correctly in FMK Fejl screen

  22-01-2020/cjs  Changed text on question after slet button

  22-01-2020/cjs  Enable ret button if fmk error is 107 and 'er ikke et gyldigt ydernummer'

  22-01-2020/cjs  Enable ret button if fmk error is 119332 (bad authorisation number)
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB,
  nxdb, StdCtrls, cxGraphics,  ExtCtrls, cxControls,  cxDataStorage, cxEdit,
  cxNavigator, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxMemo, dxLayoutContainer,
  dxLayoutControl, dxLayoutControlAdapters, dxPSGlbl, dxPSUtl, dxPSEngn,
  dxPrnPg, dxBkgnd, dxWrap, dxPrnDev, dxPSFillPatterns,
  dxPSEdgePatterns, cxDrawTextUtils,
  dxPSPrVwStd, dxPSPrVwAdv, dxPSPrVwRibbon, dxPScxPageControlProducer,
  dxPScxEditorProducers, dxPScxExtEditorProducers, dxPSCore, dxPScxGridLnk,
  dxPScxGridLayoutViewLnk, dxPScxCommon,
  cxDataControllerConditionalFormattingRulesManagerDialog,uRS_Ekspqueue.tables, cxCustomData, cxFilter, cxData, dxDateRanges,
  dxScrollbarAnnotations, dxPSCompsProvider, dxPSPDFExportCore, dxPSPDFExport;

type
  TfrmRSEkspFejl = class(TForm)
    dsEkspFejl: TDataSource;
    tblRS_EkspQueueFejl1: TnxTable;
    tblRS_EkspQueueFejl1reqtype: TStringField;
    tblRS_EkspQueueFejl1Lbnr: TIntegerField;
    tblRS_EkspQueueFejl1Linienr: TIntegerField;
    tblRS_EkspQueueFejl1OrdinationId: TLargeintField;
    tblRS_EkspQueueFejl1ErrorKode: TIntegerField;
    tblRS_EkspQueueFejl1ErrorDesc: TStringField;
    tblRS_EkspQueueFejl1ErrorDetails: TnxMemoField;
    tblRS_EkspQueueFejl1Dato: TDateTimeField;
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    dxLayoutControl1Group2: TdxLayoutGroup;
    dxLayoutControl1Item1: TdxLayoutItem;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1DBTableView1reqtype: TcxGridDBColumn;
    cxGrid1DBTableView1Lbnr: TcxGridDBColumn;
    cxGrid1DBTableView1Linienr: TcxGridDBColumn;
    cxGrid1DBTableView1OrdinationId: TcxGridDBColumn;
    cxGrid1DBTableView1ErrorKode: TcxGridDBColumn;
    cxGrid1DBTableView1ErrorDetails: TcxGridDBColumn;
    cxGrid1DBTableView1Dato: TcxGridDBColumn;
    cxGrid1Level1: TcxGridLevel;
    btnSlet: TButton;
    dxLayoutControl1Item2: TdxLayoutItem;
    btnRet: TButton;
    dxLayoutControl1Item3: TdxLayoutItem;
    Button3: TButton;
    dxLayoutControl1Item4: TdxLayoutItem;
    dxComponentPrinter1: TdxComponentPrinter;
    Udskriv: TButton;
    dxLayoutControl1Item5: TdxLayoutItem;
    dxComponentPrinter1Link1: TdxGridReportLink;
    tblEkspeditioner: TnxTable;
    tblEkspeditionerLbNr: TIntegerField;
    tblEkspeditionerBrugerTakser: TWordField;
    tblRS_EkspQueueFejl1BrugerTakser: TIntegerField;
    cxGrid1DBTableView1TakserBruger: TcxGridDBColumn;
    tblEkspeditionerTurNr: TIntegerField;
    tblEkspeditionerPakkeNr: TIntegerField;
    tblEkspeditionerFakturaNr: TIntegerField;
    tblEkspeditionerUdlignNr: TIntegerField;
    tblEkspeditionerKundeNr: TStringField;
    tblEkspeditionerFiktivtCprNr: TBooleanField;
    tblEkspeditionerCprCheck: TBooleanField;
    tblEkspeditionerNettoPriser: TBooleanField;
    tblEkspeditionerEjSubstitution: TBooleanField;
    tblEkspeditionerBarn: TBooleanField;
    tblEkspeditionerKundeKlub: TBooleanField;
    tblEkspeditionerKlubNr: TIntegerField;
    tblEkspeditionerAmt: TWordField;
    tblEkspeditionerKommune: TWordField;
    tblEkspeditionerKundeType: TWordField;
    tblEkspeditionerLandeKode: TWordField;
    tblEkspeditionerCtrType: TWordField;
    tblEkspeditionerCtrIndberettet: TWordField;
    tblEkspeditionerAlder: TSmallintField;
    tblEkspeditionerFoedDato: TStringField;
    tblEkspeditionerNarkoNr: TStringField;
    tblEkspeditionerOrdreType: TWordField;
    tblEkspeditionerOrdreStatus: TWordField;
    tblEkspeditionerReceptStatus: TWordField;
    tblEkspeditionerEkspType: TWordField;
    tblEkspeditionerEkspForm: TWordField;
    tblEkspeditionerDosStyring: TBooleanField;
    tblEkspeditionerIndikStyring: TBooleanField;
    tblEkspeditionerAntLin: TWordField;
    tblEkspeditionerAntVarer: TWordField;
    tblEkspeditionerDKMedlem: TWordField;
    tblEkspeditionerDKAnt: TWordField;
    tblEkspeditionerDKIndberettet: TWordField;
    tblEkspeditionerReceptDato: TDateTimeField;
    tblEkspeditionerOrdreDato: TDateTimeField;
    tblEkspeditionerTakserDato: TDateTimeField;
    tblEkspeditionerKontrolDato: TDateTimeField;
    tblEkspeditionerAfsluttetDato: TDateTimeField;
    tblEkspeditionerForfaldsdato: TDateTimeField;
    tblEkspeditionerBrugerKontrol: TWordField;
    tblEkspeditionerBrugerAfslut: TWordField;
    tblEkspeditionerKontrolFejl: TWordField;
    tblEkspeditionerTitel: TStringField;
    tblEkspeditionerNavn: TStringField;
    tblEkspeditionerAdr1: TStringField;
    tblEkspeditionerAdr2: TStringField;
    tblEkspeditionerPostNr: TStringField;
    tblEkspeditionerLand: TStringField;
    tblEkspeditionerKontakt: TStringField;
    tblEkspeditionerTlfNr: TStringField;
    tblEkspeditionerTlfNr2: TStringField;
    tblEkspeditionerLevNavn: TStringField;
    tblEkspeditionerLevAdr1: TStringField;
    tblEkspeditionerLevAdr2: TStringField;
    tblEkspeditionerLevPostNr: TStringField;
    tblEkspeditionerLevLand: TStringField;
    tblEkspeditionerLevKontakt: TStringField;
    tblEkspeditionerLevTlfNr: TStringField;
    tblEkspeditionerYderNr: TStringField;
    tblEkspeditionerYderCprNr: TStringField;
    tblEkspeditionerYderNavn: TStringField;
    tblEkspeditionerYderTlfNr: TStringField;
    tblEkspeditionerKontoNr: TStringField;
    tblEkspeditionerKontoNavn: TStringField;
    tblEkspeditionerKontoAdr1: TStringField;
    tblEkspeditionerKontoAdr2: TStringField;
    tblEkspeditionerKontoPostNr: TStringField;
    tblEkspeditionerKontoLand: TStringField;
    tblEkspeditionerKontoKontakt: TStringField;
    tblEkspeditionerKontoTlf: TStringField;
    tblEkspeditionerKontoGruppe: TWordField;
    tblEkspeditionerRabatGruppe: TWordField;
    tblEkspeditionerPrisGruppe: TWordField;
    tblEkspeditionerStatGruppe: TWordField;
    tblEkspeditionerSprog: TWordField;
    tblEkspeditionerAfdeling: TWordField;
    tblEkspeditionerLager: TWordField;
    tblEkspeditionerKreditForm: TWordField;
    tblEkspeditionerBetalingsForm: TWordField;
    tblEkspeditionerLeveringsForm: TWordField;
    tblEkspeditionerPakkeseddel: TWordField;
    tblEkspeditionerFaktura: TWordField;
    tblEkspeditionerBetalingskort: TWordField;
    tblEkspeditionerLeveringsseddel: TWordField;
    tblEkspeditionerAdrEtiket: TWordField;
    tblEkspeditionerVigtigBem: TnxMemoField;
    tblEkspeditionerAfstempling: TnxMemoField;
    tblEkspeditionerBrutto: TCurrencyField;
    tblEkspeditionerRabatLin: TCurrencyField;
    tblEkspeditionerRabatPct: TCurrencyField;
    tblEkspeditionerRabat: TCurrencyField;
    tblEkspeditionerInclMoms: TBooleanField;
    tblEkspeditionerExMoms: TCurrencyField;
    tblEkspeditionerMomsPct: TCurrencyField;
    tblEkspeditionerMoms: TCurrencyField;
    tblEkspeditionerNetto: TCurrencyField;
    tblEkspeditionerTilskAmt: TCurrencyField;
    tblEkspeditionerTilskKom: TCurrencyField;
    tblEkspeditionerDKTilsk: TCurrencyField;
    tblEkspeditionerDKEjTilsk: TCurrencyField;
    tblEkspeditionerOrdreNr: TIntegerField;
    tblEkspeditionerLMSUdsteder: TStringField;
    tblEkspeditionerLMSModtager: TStringField;
    tblEkspeditionerEdbGebyr: TCurrencyField;
    tblEkspeditionerTlfGebyr: TCurrencyField;
    tblEkspeditionerUdbrGebyr: TCurrencyField;
    tblEkspeditionerAndel: TCurrencyField;
    tblEkspeditionerCtrBel: TCurrencyField;
    tblEkspeditionerCtrSaldo: TCurrencyField;
    tblEkspeditionerRSQueueStatus: TIntegerField;
    tblEkspeditionerReturdage: TWordField;
    tblRS_EkspQueueFejl1Afslut: TIntegerField;
    cxGrid1DBTableView1Afslut: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure tblRS_EkspQueueFejl1reqtypeGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure btnSletClick(Sender: TObject);
    procedure btnRetClick(Sender: TObject);
    procedure tblRS_EkspQueueFejl1AfterScroll(DataSet: TDataSet);
    procedure UdskrivClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function InputCombo(const ACaption, APrompt: string; const AList: TStrings): string;
  public
    { Public declarations }
    class procedure ShowRSEkspFejl;
  end;



implementation

uses c2Mainlog,DM,chkBoxes,c2procs;

{$R *.dfm}

{ TfrmRSEkspFejl }

class procedure TfrmRSEkspFejl.ShowRSEkspFejl;
begin
  try

    with TfrmRSEkspFejl.Create(Nil) do
    begin
      try
        ShowModal;
      finally
        Free;

      end;
    end;
  except
    on E: Exception do
      Application.MessageBox(pchar(e.Message),'Fejl');
  end;

end;

procedure TfrmRSEkspFejl.btnSletClick(Sender: TObject);
begin
  if not ChkBoxYesNo('OK til at slette fejlbesked',False) then
    exit;

  try
    tblRS_EkspQueueFejl1.Delete;
  except
    on E: Exception do
    begin
      ChkBoxOK('Fejl i slet message : ' + e.Message);
      C2LogAdd('Fejl i slet message : ' + e.Message);
    end;
  end;

end;

procedure TfrmRSEkspFejl.btnRetClick(Sender: TObject);
  procedure DeleteLbnrFromRSEkspFejl(lbnr : integer);
  begin
    tblRS_EkspQueueFejl1.DisableControls;
    try
      tblRS_EkspQueueFejl1.First;
      while not tblRS_EkspQueueFejl1.Eof do
      begin
        if tblRS_EkspQueueFejl1Lbnr.AsInteger = lbnr then
          tblRS_EkspQueueFejl1.Delete
        else
          tblRS_EkspQueueFejl1.Next;
      end;
    finally
      tblRS_EkspQueueFejl1.First;
      tblRS_EkspQueueFejl1.EnableControls;
    end;

  end;
  procedure ResubmitLbnr;
  begin
    with MainDm do
    begin
      try
        try
          with nxdb.OpenQuery('insert into ' + tnRS_EkspQueue + '(' +
            fnRS_EkspQueueLbnr + fnRS_EkspQueueDato_K + fnRS_EkspQueueReportedBy_K +
            ') values(' + tblRS_EkspQueueFejl1Lbnr.AsString + ',' +
            'current_timestamp,' + Bruger.Brugernr.ToString + ')', []) do
          begin
            try
              C2LogAdd(sql.Text);
              if RowsAffected = 0 then
                ChkBoxOK('Not added');

            except
              on E: Exception do
                ChkBoxOK('fejl i resubmit ' + E.Message);
            end;
            Free;
          end;
          DeleteLbnrFromRSEkspFejl(tblRS_EkspQueueFejl1Lbnr.AsInteger);
        except
          on e : Exception do
          begin
            ChkBoxOK(e.Message);
            C2LogAdd(e.Message);
          end;
        end;
      finally
        if nxRSQueue.State <> dsbrowse then
          nxRSQueue.Cancel;
        tblRS_EkspQueueFejl1.Refresh;
      end;


    end;
  end;
  procedure RetYderDetails;
  var
    OldYdernr : string;
    OldAutNr : string;
    NewYderNr : string;
    NewYderNavn : string;
    NewAutNr : string;
    save_index : string;
    autlist : tstringlist;
    save_yderindex : string;
    i : integer;

  begin
    with MainDm do
    begin
      c2logadd('Top of RetYderDetails');
      if tblRS_EkspQueueFejl1ErrorKode.AsInteger = 107 then
      begin
        if (AnsiPos('er ikke et gyldigt ydernummer',
          tblRS_EkspQueueFejl1ErrorDetails.AsString) = 0) and
          (AnsiPos('er ikke et gyldigt sygehus',
          tblRS_EkspQueueFejl1ErrorDetails.AsString) = 0) then

          exit;
      end;

      autlist := TStringList.Create;
      save_index := ffEksKar.IndexName;
      ffEksKar.IndexName := 'NrOrden';
      try

        if not ffEksKar.FindKey([tblRS_EkspQueueFejl1Lbnr.AsInteger]) then
          exit;
        OldYdernr := ffEksKarYderNr.AsString;
        OldAutNr := ffEksKarYderCprNr.AsString;
        NewYderNr := InputBox('YderNr','Indtast nyt ydernr.',OldYdernr);
        autlist.Add(OldAutNr);
        save_yderindex := ffYdLst.IndexName;
        ffYdLst.IndexName := 'YderNrOrden';
        ffYdLst.SetRange([NewYderNr],[NewYderNr]);
        try
          if ffYdLst.RecordCount <> 0 then
          begin
            ffYdLst.First;
            while not ffYdLst.Eof do
            begin
              if autlist.IndexOf(ffYdLstCprNr.AsString) = -1 then
                autlist.Add(ffYdLstCprNr.AsString);
              ffYdLst.Next;
            end;
          end;
        finally
          ffydlst.CancelRange;
          ffYdLst.IndexName := save_yderindex;
        end;
        NewAutNr := CAPS(trim(InputCombo('AutNr','Indtast nyt aut.nr.',autlist)));
        if Length(NewAutNr) = 5 then
        begin

          for i := 1 to 5 do
          begin
            if pos(copy(NewAutNr,i,1),'BCDFGHJKLMNPQRSTVWXYZ0123456789') = 0 then
            begin
              ChkBoxOK('Fejl i Aut.Nr. Kun vokalen Y er tilladt.');
              exit;
            end;
          end;
        end;


        if NewAutNr = '' then
        begin
          if ChkBoxYesNo('Vil du bruge erstatnings nr 09YM9?',true) then
            NewAutNr := '09YM9';
        end;
        if (OldYdernr = NewYderNr) and (OldAutNr = NewAutNr) then
          exit;

        if not ChkBoxYesNo('Vil du opdatere og sende til FMK?',true) then
          exit;

        NewYderNavn := '';
        save_yderindex := ffYdLst.IndexName;
        ffYdLst.IndexName := 'YderNrOrden';
        try
          if ffYdLst.FindKey([NewYderNr,NewAutNr]) then
            NewYderNavn := ffYdLstNavn.AsString
          else
            if ffYdLst.FindKey([NewYderNr]) then
              NewYderNavn := ffYdLstNavn.AsString;

        finally
          ffYdLst.IndexName := save_yderindex;
        end;

        try
          try
            ffEksKar.Edit;
            if NewYderNr <> '' then
            begin
              ffEksKarYderNr.AsString := NewYderNr;
            end;
            ffEksKarYderCprNr.AsString := NewAutNr;

            if NewYderNavn <> '' then
              ffEksKarYderNavn.AsString := NewYderNavn;

            ffEksKar.Post;
          except
            on E: Exception do
            begin
              ChkBoxOK(e.Message);
              C2LogAdd(e.Message);
            end;
          end;
        finally
          if ffEksKar.State <> dsBrowse then
            ffEksKar.Cancel;

        end;

        ResubmitLbnr;
      finally
        ffekskar.IndexName := save_index;
        autlist.Free;
        C2LogAdd('Bottom of RetYderNr');
      end;

    end;
  end;


begin
  case tblRS_EkspQueueFejl1ErrorKode.AsInteger of
    107, 109, 851, 119332:
    begin
      RetYderDetails;
      exit;
    end;
    4202:
    begin
      ResubmitLbnr;
      exit;
    end;

  end;

  if tblRS_EkspQueueFejl1ErrorDetails.AsString = 'Certifikat udløbet' then
  begin
    ResubmitLbnr;
    exit;
  end;

end;

procedure TfrmRSEkspFejl.Button3Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmRSEkspFejl.FormCreate(Sender: TObject);
begin
  with MainDm do
  begin
    tblEkspeditioner.Session := nxSess;
    tblEkspeditioner.AliasName := 'Produktion';
    tblEkspeditioner.Open;
    tblEkspeditioner.IndexName :='NrOrden';
    tblRS_EkspQueueFejl1.Session := nxSess;
    tblRS_EkspQueueFejl1.AliasName := 'Produktion';
    tblRS_EkspQueueFejl1.Open;
    tblRS_EkspQueueFejl1.IndexName :='NrOrden';
  end;
end;

procedure TfrmRSEkspFejl.FormShow(Sender: TObject);
begin
//  cxGrid1DBTableView1.ApplyBestFit();
end;

function TfrmRSEkspFejl.InputCombo(const ACaption, APrompt: string;
  const AList: TStrings): string;

  function GetCharSize(Canvas: TCanvas): TPoint;
  var
    I: Integer;
    Buffer: array[0..51] of Char;
  begin
    for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
    for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
    GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
    Result.X := Result.X div 52;
  end;

var
  Form: TForm;
  Prompt: TLabel;
  Combo: TComboBox;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
  Result := '';
  Form   := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption     := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      Position    := poScreenCenter;
      Prompt      := TLabel.Create(Form);
      with Prompt do
      begin
        Parent   := Form;
        Caption  := APrompt;
        Left     := MulDiv(8, DialogUnits.X, 4);
        Top      := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Combo := TComboBox.Create(Form);
      with Combo do
      begin
        Parent := Form;
//        Style  := csDropDownList;
        //für Eingabemöglichkeit in Combo verwende
        //For input possibility in combo uses
        Style := csDropDown;
        Items.Assign(AList);
        ItemIndex := 0;
        Left      := Prompt.Left;
        Top       := Prompt.Top + Prompt.Height + 5;
        Width     := MulDiv(164, DialogUnits.X, 4);
      end;
      ButtonTop    := Combo.Top + Combo.Height + 15;
      ButtonWidth  := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent      := Form;
        Caption     := '&OK';
        ModalResult := mrOk;
        default     := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent      := Form;
        Caption     := '&Afslut';
        ModalResult := mrCancel;
        Cancel      := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), Combo.Top + Combo.Height + 15,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      if ShowModal = mrOk then
        Result := Combo.Text;
    finally
      Form.Free;
    end;
end;


procedure TfrmRSEkspFejl.tblRS_EkspQueueFejl1AfterScroll(DataSet: TDataSet);
var
  LErrorKode : integer;
begin
  LErrorKode := tblRS_EkspQueueFejl1ErrorKode.AsInteger;
  case LErrorKode of
    109,851,4202,119332  : btnRet.Enabled := True;
  else
    btnRet.Enabled := False;
  end;
  if tblRS_EkspQueueFejl1ErrorDetails.AsString = 'Certifikat udløbet' then
    btnRet.Enabled := True;
  if tblRS_EkspQueueFejl1ErrorKode.AsInteger = 107 then
  begin
    if AnsiPos('er ikke et gyldigt ydernummer',tblRS_EkspQueueFejl1ErrorDetails.AsString) <> 0 then
      btnRet.Enabled := True;
    if AnsiPos('er ikke et gyldigt sygehus',tblRS_EkspQueueFejl1ErrorDetails.AsString) <> 0 then
      btnRet.Enabled := True;
  end;

end;

procedure TfrmRSEkspFejl.tblRS_EkspQueueFejl1reqtypeGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if tblRS_EkspQueueFejl1reqtype.AsString ='CreateAndAdminister' then
    Text := 'Manual recept';
  if tblRS_EkspQueueFejl1reqtype.AsString ='Administer' then
    Text := 'Receptordination';
  if tblRS_EkspQueueFejl1reqtype.AsString ='UndoAdministration' then
    Text := 'Returekspedition';
  if tblRS_EkspQueueFejl1reqtype.AsString ='RemoveStatusInProces' then
    Text := 'Tilbage';


end;

procedure TfrmRSEkspFejl.UdskrivClick(Sender: TObject);
begin
  with dxComponentPrinter1 do
  begin
    dxComponentPrinter1Link1.ReportTitleText := 'FMK fejlrapport'  ;

    PrintEx(pnAll,1,true,dxComponentPrinter1Link1);
  end;
end;

end.
