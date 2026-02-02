unit TakserLeverancer;

{ Developed by: Vitec Cito A/S

  Description: Ekspedition program

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  10-09-2019/cjs   use the kundenavn specified at the start of taksering

  25-03-2019/cjs  7.2.4.1 pressing enter in vare field with blank caused random vare to be selected

  20-03-2019/BN   7.2.3.7 Changed Name to Vitec Cito and added comments to edited units
                          Remove recepturgebyr if HA håndkøbslinier before moms calculation

}

interface

uses
  Classes,  Graphics, Controls,
  Forms,    Menus,    StdCtrls,
  DBCtrls,  DBGrids,  ComCtrls,
     ExtCtrls, Mask,
  Messages, Windows,  SysUtils,
  Db,       Buttons, ActnList, System.Actions, Vcl.Grids;

type
  TLeveranceForm = class(TForm)
    paTop: TPanel;
    paBund: TPanel;
    paLinier: TPanel;
    grLinier: TDBGrid;
    Label5: TLabel;
    Label7: TLabel;
    gbKunde: TGroupBox;
    eCprNr: TDBEdit;
    eNavn: TDBEdit;
    eDebitorNr: TDBEdit;
    eDebitorNavn: TDBEdit;
    eYderNr: TDBEdit;
    eYderNavn: TDBEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    gbEksp: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EVare: TEdit;
    EAntal: TEdit;
    laSalgRetur: TLabel;
    Label23: TLabel;
    gbAfslut: TGroupBox;
    buGem: TButton;
    buLuk: TButton;
    buVidere: TButton;
    Label15: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBEPris: TDBEdit;
    DBETekst: TDBEdit;
    paLager: TPanel;
    paInfo: TPanel;
    lcbEkspType: TDBComboBox;
    lcbEkspForm: TDBComboBox;
    lcbLinTyp: TDBComboBox;
    lcFakType: TDBComboBox;
    lcLevForm: TDBLookupComboBox;
    ActionList1: TActionList;
    acLager0: TAction;
    acLager1: TAction;
    acLager2: TAction;
    acLager3: TAction;
    acLager4: TAction;
    acLager5: TAction;
    lblMomsType0: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure buLukClick(Sender: TObject);
    procedure DropDown(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EkspFormExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure buGemClick(Sender: TObject);
    procedure FakTypeExit(Sender: TObject);
    function  CheckOrdination : Boolean;
    procedure eDebitorNrExit(Sender: TObject);
    procedure buVidereEnter(Sender: TObject);
    procedure buVidereExit(Sender: TObject);
    procedure buVidereKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure buVidereClick(Sender: TObject);
    procedure EkspTypeEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure eDebitorNrEnter(Sender: TObject);
    procedure acLager0Execute(Sender: TObject);
    procedure acLager1Execute(Sender: TObject);
    procedure acLager2Execute(Sender: TObject);
    procedure acLager3Execute(Sender: TObject);
    procedure acLager4Execute(Sender: TObject);
    procedure acLager5Execute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FirstTime,
    CloseSF6,
    CloseF6 : Boolean;
    LagerListeLagerChk : boolean;
    OldDebitor : string;
  end;

var
  LeveranceForm: TLeveranceForm;
  AllHKlines : boolean;
  ProdDyrPrices : boolean;

procedure EkspLeverancer (LbNr : LongWord);
procedure checkDebitor;

implementation

uses
  C2MainLog,
  HentTekst,
  HentHeltal,


//  VareOversigt,
  SubstOversigt,
  RcpProcs,
  C2Procs,
//  DebitorLst,
  YderLst,
  TakserAfslut,
  ChkBoxes,
  DM,
  uC2Vareidentifikator.Types,  Main, uRowaAppCall, frmLagerList;

{$R *.DFM}

//var
//  VareRec    : TVareRec;
//  DebitorRec : TDebitorRec;
(*
function HentDebitor (var Rec : TDebitorRec) : boolean;
begin with MidClient do begin
  MidClient.HentDeb (Rec);
  Result := Rec.Status = 0;
end; end;
*)
procedure checkDebitor;
var
  i : integer;
  save_index : string;
begin
  with MainDm do begin
    if LeveranceForm.OldDebitor <> mtEksDebitorNr.AsString then
      LeveranceForm.LagerListeLagerChk := False;
    if not ffDebKar.FindKey([mtEksDebitorNr.AsString]) then begin
      ChkBoxOk ('Debitorkonto findes ikke i kartotek !');
      LeveranceForm.eDebitorNr.SetFocus;
      exit;
    end;
    if ffDebKarKontoLukket.AsBoolean then begin
      if trim(ffDebKarLukketGrund.AsString) <> '' then
        ChkBoxOK('Debitorkonto er lukket : ' + ffDebKarLukketGrund.AsString)
      else
        ChkBoxOK('Debitorkonto er lukket.');
      mtEksDebitorNr.AsString := '';
      LeveranceForm.eDebitorNr.SetFocus;
      exit;
    end;
    if ffDebKarKreditMax.AsCurrency <> 0 then begin
      ChkBoxOK('Bemærk kreditmax: ' + format('%8.2f',[ffDebKarKreditMax.AsCurrency]) + #10#13#10#13 +
          'Aktuel saldo: ' + format('%8.2f',[ffDebKarSaldo.AsCurrency]));

    end;
    if (ffDebKarAfdeling.AsString ='' ) or ( ffDebKarLager.AsString = '') then begin
      ChkBoxOK('Afdeling eller lager mangler på debitoren. Ret dette i Debitorkartoteket.');
      mtEksDebitorNr.AsString := '';
      LeveranceForm.eDebitorNr.SetFocus;
      exit;
    end;

    save_index := ffAfdNvn.IndexName;
    ffAfdNvn.IndexName := 'NrOrden';
    try
      if not ffAfdNvn.FindKey([ffDebKarAfdeling.AsInteger]) then begin
        ChkBoxOK('Afdeling eller lager mangler på debitoren. Ret dette i Debitorkartoteket.');
        mtEksDebitorNr.AsString := '';
        LeveranceForm.eDebitorNr.SetFocus;
        exit;
      end;
    finally
      ffAfdNvn.IndexName := save_index;
    end;
    ProdDyrPrices := ffAfdNvnProduktionsDyr.AsBoolean;
    c2logadd('Prod Dyr Prices ' + Bool2Str(ProdDyrPrices));
    if not LeveranceForm.LagerListeLagerChk  then begin
      mtEksAfdeling.Value        := ffDebKarAfdeling     .AsInteger;
      mtEksLager.Value           := ffDebKarLager        .AsInteger;
      StamForm.StockLager := mtEksLager.Value;
    end;
    if (mtEksLager.value <> StamForm.FLagerNr) or (StamForm.Spoerg_Lager_Debitor) then begin
      if (Stamform.DebitorPopup) and (LeveranceForm.LagerListeLagerChk) then
        exit;
      if Stamform.DebitorPopup then
        LeveranceForm.LagerListeLagerChk := True;
      if not StamForm.debitorpopup then
        exit;
      if StamForm.DebitorPopupAutoret then begin
        for i := 1 to 10 do begin
          if StamForm.debitorpopuptype[i] = -1 then
            exit;

          if StamForm.debitorpopuptype[i] = ffDebKarLevForm.AsInteger then begin
            mtEksLager.value := StamForm.FLagerNr;
            mtEksAfdeling.value := MainDm.AfdNr;
            StamForm.StockLager := mtEksLager.Value;
            exit;
          end;
        end;
      end;

      for i := 1 to 10 do begin
        if StamForm.debitorpopuptype[i] = -1 then
          exit;

        if StamForm.debitorpopuptype[i] = ffDebKarLevForm.AsInteger then begin
          if frmDebLagListe.showLagerliste = mrok then begin
            mtEksLager.value := nxDebLagRefNr.asinteger;
            mtEksAfdeling.value := nxDebAfdRefNr.AsInteger;
            StamForm.StockLager := mtEksLager.Value;
          end;
          exit;
        end;

      end;

    end;
  end;
end;


procedure EkspLeverancer (LbNr : LongWord);
begin
  with LeveranceForm, MainDm do
  begin
    // Stop opdater CTR
    StamForm.CtrTimer.Enabled:= FALSE;
    ProdDyrPrices := False;
    LeveranceForm := TLeveranceForm.Create (NIL);
    try
      // Nulstil memtables
      mtEks.Close;
      mtEks.Open;
      if mtEks.RecordCount <> 0 then
      begin
        mtEks.First;
        while not mtEks.Eof do
          mtEks.Delete;
      end;
      mtEks.Insert;
//
//      mtLin.Close;
//      mtLin.Open;
//      if mtLin.recordcount <> 0 then
//      begin
        try
          mtLin.First;
          while not mtLin.Eof do
            mtLin.Delete;
          mtLin.LogChanges:= FALSE;
        except
             on e : Exception do
              C2LogAdd(e.Message);
        end;
//      end;
      // Kundetype m.m.
      mtEksKundeNr.AsString    := ffPatKarKundeNr.AsString;
      mtEksKundeType.Value     := ffPatKarKundeType.Value ;
      // keep the current kundenavn just in case somebody else changes it.

      mtEksKundeNavn.AsString := ffPatKarNavn.AsString;

      mtEksCtrType.Value       := ffPatKarCtrType.Value;
      mtEksDebitorNr.AsString  := ffPatKarDebitorNr.AsString;
      mtEksLeveringsForm.Value := 0;
      mtEksYderNr.AsString     := ffPatKarYderNr.AsString;
      mtEksYderCprNr.AsString  := ffPatKarYderCprNr.AsString;
      mtEksYderNavn.AsString   := ffPatKarLuYdNavn.AsString;
      mtEksNettoPriser.Value   := ffPatKarNettoPriser.Value;
      LeveranceForm.LagerListeLagerChk := False;
      // Eksptyper og Ekspformer
      if mtEksKundeType.Value = 15 then begin
        // Håndkøbsudsalg
        mtEksEkspType.Value := et_Haandkoeb;
        mtEksEkspForm.Value := 0;
        EkspTypFilter       := EkspTypHdk;
        EkspFrmFilter       := EkspFrmAndet;
      end else begin
        // andre leverancer
        mtEksEkspType.Value := et_Leverancer;
        mtEksEkspForm.Value := 0;
        EkspTypFilter       := EkspTypLev;
        EkspFrmFilter       := EkspFrmAndet;
      end;
      AllHKlines := False;

      // Debitorfelter spærres
      eDebitorNr.Color         := clSilver;
      lcLevForm.Color          := clSilver;
      lcLevForm.ReadOnly       := True;
      lcLevForm.TabStop        := False;

      // Debitor checkes
      mtEksAfdeling.Value      := ffAfdNvnRefNr.Value;
      mtEksLager.Value         := ffLagNvnRefNr.Value;
      mtEksAvancePct.Value     := 0;
      LeveranceForm.lblMomsType0.Caption := '';
      if mtEksDebitorNr.AsString <> '' then
      begin
        eDebitorNr.Color       := clYellow;
        eDebitorNr.ReadOnly    := False;
        eDebitorNr.TabStop     := True;
        lcLevForm.Color        := clYellow;
        lcLevForm.ReadOnly     := False;
        lcLevForm.TabStop      := True;
        if ffDebKar.FindKey([mtEksDebitorNr.AsString]) then
        begin
          mtEksAfdeling.Value        := ffDebKarAfdeling     .AsInteger;
          mtEksLager.Value           := ffDebKarLager        .AsInteger;
          StamForm.StockLager := mtEksLager.Value;
          mtEksAvancePct.Value       := ffDebKarAvancePct    .AsCurrency;
          mtEksDebitorNavn.AsString  := BytNavn (ffDebKarNavn.AsString);
          mtEksLeveringsForm.Value   := ffDebKarLevForm      .AsInteger;
          mtEksUdbrGebyr.AsCurrency  := 0.0;
          if ffDebKarMomsType.AsInteger = 0 then
            LeveranceForm.lblMomsType0.Caption := 'leverance uden moms';

          if (ffDebKarLevForm.AsInteger in [5,6]) and (mtEksKundeType.AsInteger <> 15) then begin
//            if AllHKLines then
              mtEksUdbrGebyr.AsCurrency := ffRcpOplHKgebyr.AsCurrency;
          end;
          if ffDebKarUdbrGebyr.AsBoolean then begin
            if mtEksUdbrGebyr.AsCurrency = 0 then
              mtEksUdbrGebyr.AsCurrency := ffRcpOplPlejehjemsgebyr.AsCurrency;
            if ffDebKarLevForm.AsInteger = 2 then
              mtEksUdbrGebyr.AsCurrency:= ffRcpOplUdbrGebyr    .AsCurrency;
          end;
          checkDebitor;
        end
        else
          ChkBoxOk ('Debitorkonto findes ikke i Dos kartotek !');
    (*
        FillChar (DebitorRec, SizeOf (DebitorRec), 0);
        DebitorRec.Nr := mtEksDebitorNr.AsString;
        if HentDebitor (DebitorRec) then begin
          mtEksAfdeling.Value      := DebitorRec.Afdeling;
          mtEksLager.Value         := DebitorRec.Lager;
          mtEksAvancePct.Value     := DebitorRec.AvancePct;
          mtEksDebitorNavn.Text    := DebitorRec.Navn;
          mtEksLeveringsForm.Value := DebitorRec.SendeType;
          if DebitorRec.UdbrGebyr then
            mtEksUdbrGebyr.AsCurrency := ffRcpOplUdbrGebyr.AsCurrency;
        end else
          ChkBoxOk ('Debitorkonto findes ikke i Dos kartotek !');
  *)
      end;

      mtEksOrdreType.Value    := 1;
      mtEksOrdreStatus.Value  := 1;
      mtEksReceptStatus.Value := 0; // Manuel
      mtEksAntLin.Value       := 0;

  //    TableFilter (cdEksTyp);
  //    TableFilter (cdEksFrm);
  {
      PostMessage (lcbEkspType.Handle, wm_KeyDown, VK_DOWN, 0);
      PostMessage (lcbEkspType.Handle, wm_KeyDown, VK_UP,   0);
      PostMessage (lcbEkspForm.Handle, wm_KeyDown, VK_DOWN, 0);
      PostMessage (lcbEkspForm.Handle, wm_KeyDown, VK_UP,   0);
  }
      FakTypeExit (LeveranceForm);

      // Vis form
      if ShowModal =  mrCancel then
        exit;

      AllHKlines := True;
      mtLin.First;
      while not mtLin.Eof do begin
        if mtLinLinieType.AsInteger <> 2 then begin
          AllHKlines := False;
          break;
        end;
        mtLin.Next;

      end;

      if AllHKlines then
      begin
        if mtEksDebitorNr.AsString <> '' then
        begin
          if ffDebKar.FindKey([mtEksDebitorNr.AsString]) then
          begin
            IF not LagerListeLagerChk then
            begin
              mtEksAfdeling.Value        := ffDebKarAfdeling     .AsInteger;
              mtEksLager.Value           := ffDebKarLager        .AsInteger;
            end;
            mtEksAvancePct.Value       := ffDebKarAvancePct    .AsCurrency;
            mtEksDebitorNavn.AsString  := BytNavn (ffDebKarNavn.AsString);
            mtEksLeveringsForm.Value   := ffDebKarLevForm      .AsInteger;
            mtEksUdbrGebyr.AsCurrency  := 0.0;
            if (ffDebKarLevForm.AsInteger in [5,6]) and (mtEksKundeType.AsInteger <> 15) then
            begin
//              if AllHKLines then
                mtEksUdbrGebyr.AsCurrency := ffRcpOplHKgebyr.AsCurrency;
            end;
            if ffDebKarUdbrGebyr.AsBoolean then
            begin
              if mtEksUdbrGebyr.AsCurrency = 0 then
                mtEksUdbrGebyr.AsCurrency := ffRcpOplPlejehjemsgebyr.AsCurrency;
              if ffDebKarLevForm.AsInteger = 2 then
                mtEksUdbrGebyr.AsCurrency:= ffRcpOplUdbrGebyr    .AsCurrency;
            end;
          end;
          // Debitor felter åbnes
          CheckDebitor;
        end;
        if mtEksLevNr.AsString <> '' then
        begin
          if ffDebKar.FindKey([mtEksLevNr.AsString]) then
          begin
            mtEksLevNavn.AsString:= BytNavn(ffDebKarNavn.AsString);
            if ffDebKarLevForm.AsInteger in [5,6] then
            begin
//              if AllHKLines then
                mtEksUdbrGebyr.AsCurrency := ffRcpOplHKgebyr.AsCurrency;
            end;
            if ffDebKarUdbrGebyr.AsBoolean then
            begin
              if mtEksUdbrGebyr.AsCurrency = 0 then
                mtEksUdbrGebyr.AsCurrency := ffRcpOplPlejehjemsgebyr.AsCurrency;
              if ffDebKarLevForm.AsInteger = 2 then
                mtEksUdbrGebyr.AsCurrency:= ffRcpOplUdbrGebyr    .AsCurrency;
            end;
          end;
        end;

      end;


      // Post ekspedition
      mtEks.Post;

      if ModalResult = mrOK then
      begin
        StamForm.Update;
        AfslutEkspedition (FALSE, FALSE, CloseSF6, FALSE,FALSE, 0);
        EkspTypFilter := EkspTypAlle;
        EkspFrmFilter := EkspFrmAlle;
        LinTypFilter  := LinTypAlle;
//      TableFilter (cdEksTyp);
//      TableFilter (cdEksFrm);
//      TableFilter (cdLinTyp);
      end;
//    mtEks.Close;
//    mtLin.Close;
    finally
      LeveranceForm.Free;
      LeveranceForm := NIL;
      // Start opdater CTR
      StamForm.CtrTimer.Enabled:= TRUE;
      StamForm.StockLager := Stamform.Save_StockLager;
    end;
  end;
end;

procedure NyLinie;
begin
  with LeveranceForm, MainDm do begin
    EVare.Text                := '';
    mtEksAntLin.Value         := mtEksAntLin.Value + 1;
    paLager.Caption           := '';
    paInfo .Caption           := '';
    mtLin.Append;
    // setup the incl moms based on the momstype on the debitor
    mtLinInclMoms.AsBoolean := True;

    if mtEksDebitorNr.AsString <> '' then
      mtLinInclMoms.AsBoolean := ffDebKarMomsType.AsInteger <> 0;
    mtLinValideret.AsBoolean  := False;
    mtLinLinieNr.Value        := mtEksAntLin.Value;
    mtLinLager.Value          := ffLagNvnRefNr.Value;
    mtLinAntal.Value          := 1;
    mtLinLinieType.Value      := 1;
    if ffPatKarKundeType.AsInteger = 0 then
      mtLinLinieType.Value      := 2;
{ TODO : etiketter }
    if UdskrivLeverenceEtiketter then
      mtLinEtkMemo.AsString := AnsiUpperCase(BytNavn(ffPatKarNavn.AsString));

    mtLinEjS.Value            := False;
    LinTypFilter              := LinTypRcp;
    if mtEksEkspType.Value = et_Haandkoeb then
    begin
      LinTypFilter            := LinTypHdk;
      mtLinLinieType.Value    := 2;
    end;
  //  TableFilter (cdLinTyp);
  //  PostMessage (lcbLinTyp.Handle, wm_KeyDown, VK_DOWN, 0);
  //  PostMessage (lcbLinTyp.Handle, wm_KeyDown, VK_UP,   0);
    EAntal.Text := '1';
  end;
end;

procedure TLeveranceForm.buLukClick(Sender: TObject);
begin
  Close;
end;

procedure TLeveranceForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (not CloseF6) and (not CloseSF6) then begin
    if ChkBoxYesNo ('Skal ekspedition annulleres ?', TRUE) then begin
      if MainDm.mtLin.State <> dsBrowse then
        MainDm.mtLin.Cancel;
      CanClose    := True;
      ModalResult := mrCancel;
    end else
      CanClose    := False;
  end;
end;

procedure TLeveranceForm.FormActivate(Sender: TObject);
begin
  if FirstTime then
    exit;

  FirstTime := True;
  stamform.Save_StockLager := StamForm.StockLager;
  if (Screen.Height <= 768) and (Screen.Width <= 1024) then
    if (StamForm.FullScreen) or (Screen.Height=600) then
      SendMessage(Self.Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
  PostMessage (lcbEkspType.Handle, wm_KeyDown, VK_DOWN, 0);
  PostMessage (lcbEkspType.Handle, wm_KeyDown, VK_UP,   0);
  PostMessage (lcbEkspForm.Handle, wm_KeyDown, VK_DOWN, 0);
  PostMessage (lcbEkspForm.Handle, wm_KeyDown, VK_UP,   0);
  lcbEkspType.SetFocus;
  if maindm.TakserAutoEnter then
  begin
      SendMessage (buVidere.Handle, WM_LBUTTONDOWN, 0, 0);
      SendMessage (buVidere.Handle, WM_LBUTTONUP, 0,   0);
      evare.SetFocus;
  end;
end;

procedure TLeveranceForm.FormShow(Sender: TObject);
begin
  with MainDm do begin
    buVidere.Tag     := 0;
    buGem.Enabled    := False;
    CloseF6          := False;
    CloseSF6         := False;
  end;
end;

procedure TLeveranceForm.EkspTypeEnter(Sender: TObject);
begin
  with MainDm do begin
    //  TableFilter (cdEksTyp);
    //  lcbEkspType.Update;
  end;
end;

procedure TLeveranceForm.EkspFormExit(Sender: TObject);
begin
  with MainDm do begin
    buVidere.SetFocus;
  end;
end;

procedure TLeveranceForm.buVidereEnter(Sender: TObject);
begin
  with MainDm do begin
    if mtLin.State = dsBrowse then
      mtLin.Edit;
    buGem.Enabled := False;
    if mtEksAntLin.Value = 0 then begin
      buVidere.Tag := 1;
      NyLinie;
    end else begin
      // Kun valider hvis vi kommer fra indikation
      if buVidere.Tag = 2 then begin
        if CheckOrdination then
          buGem.Enabled := True;
      end else
        buGem.Enabled := True;
    end;
  end;
end;

procedure TLeveranceForm.buVidereExit(Sender: TObject);
begin
  with MainDm do begin
    buGem.Enabled := False;
    buVidere.Tag  := 0;
  end;
end;

procedure TLeveranceForm.buVidereClick(Sender: TObject);
begin
  // Kun check ved kontrol med indikation
  if buVidere.Tag = 2 then begin
    // check pris
    if MainDm.MTLinPris.AsCurrency > 1000 then begin
      if not ChkBoxYesNo(' Er prisen korrekt ?',False) then begin
        DBEPris.SetFocus;
        Exit;
      end;
    end;
    if CheckOrdination then
      NyLinie;
  end;
  SelectNext (ActiveControl, TRUE, TRUE);
  if maindm.TakserAutoEnter then
  begin
    evare.SetFocus;
  end;
end;

procedure TLeveranceForm.buVidereKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with MainDm do begin
    if (Key = VK_F6) and ((Shift = []) or (Shift = [ssShift])) then begin
      Key := 0;
      if CheckOrdination then begin
        if Shift = [ssShift] then
          CloseSF6 := True
        else
          CloseF6  := True;
        buGem.Click;
      end;
    end;
  end;
end;

procedure YdLst;
begin
  with LeveranceForm, MainDm do begin
    if ShowYdLst ('YderNr', dsYdLst, ffYdLst) then begin
      mtEksYderNr.AsString    := ffYdLstYderNr.AsString;
      mtEksYderNavn.AsString  := ffYdLstNavn.AsString;
    end;
  end;
end;
(*
 procedure DeLst;
begin with LeveranceForm, MainDm do begin
  mtEksDebitorNr.AsString := ShowDeLst ('KontoNr', mtEksDebitorNr.AsString);
end; end;
*)
function TLeveranceForm.CheckOrdination : Boolean;
var
  VareForSale : boolean;
begin
  with MainDm do begin
    Result := TRUE;
    // Check håndkøb
    if mtLinLinieType.Value = 2 then begin
      VareForSale := False;
      if (Pos ('HA', mtLinUdlevType.AsString) <> 0) then
        VareForSale := True;
      if (Pos ('HV', mtLinUdlevType.AsString) <> 0) then
        VareForSale := True;
      if (Pos ('HF', mtLinUdlevType.AsString) <> 0) then
        VareForSale := True;
      if (Pos ('HP', mtLinUdlevType.AsString) <> 0) then
        VareForSale := True;
      if (Pos ('HPK', mtLinUdlevType.AsString) <> 0) then
        VareForSale := True;

      if (mtLinVareType.AsInteger in [2,8,9,10,11,12]) then
        VareForSale := True;


      IF not VareForSale then begin
        ChkBoxOk ('Vare er IKKE håndkøbsvare !');
        Result := FALSE;
        lcbLinTyp.SetFocus;
        Exit;
      end;
    end;
    // Check antal
    if (mtLinAntal.Value < 1) or (mtLinAntal.Value > 99) then begin
      ChkBoxOk ('Antal pakninger skal være mellem 1 - 99 !');
      Result := FALSE;
      EAntal.SetFocus;
      Exit;
    end;
    // Check varenr
    if mtLinVareNr.AsString = '' then begin
      ChkBoxOk ('Varenr skal indtastes !');
      Result := FALSE;
      EVare.SetFocus;
      Exit;
    end;

    if StamForm.UdlBegrKunTilSygehus then begin
      if mtLinUdLevType.AsString = 'BEGR' then begin
        if mtEksKundeType.AsInteger <> 11 then begin
          ChkBoxOK('NB ! Udlevering BEGR må kun sælges til sygehuse.');
          Result := False;
          EVare.SetFocus;
          Exit;
        end;
      end;
    end;


    mtLinValideret.AsBoolean := True;
  end;
end;

procedure TLeveranceForm.buGemClick(Sender: TObject);
begin
  with MainDm do begin
    if not buGem.Enabled then
      exit;
    // check pris
    if MainDm.MTLinPris.AsCurrency > 1000 then begin
      if not ChkBoxYesNo(' Er prisen korrekt ?',False) then begin
        DBEPris.SetFocus;
        buVidere.Tag := 2;
        Exit;
      end;
    end;
    if mtLin.State <> dsBrowse then
      mtLin.Post;
    mtLin.First;

    while not mtLin.Eof do begin
      if not mtLinValideret.AsBoolean then
        mtLin.Delete
      else
        mtLin.Next;
    end;
    // Check ydernr
    if not CheckYderNr  (mtEksKundeType.Value, mtEksYderNr.AsString) then begin
      eYderNr.SetFocus;
      ChkBoxOk ('Fejl i Lægens ydernr !');
      Exit; // Afbryd F6 og gå til ydernr felt
    end;
    // Check Debitor
    if Trim (mtEksDebitorNr.AsString) <> '' then begin
(*
      FillChar (DebitorRec, SizeOf (DebitorRec), 0);
      DebitorRec.Nr := Trim (mtEksDebitorNr.AsString);
      if not HentDebitor (DebitorRec) then begin
        eDebitorNr.SetFocus;
        ChkBoxOk ('Debitorkonto findes ikke i Dos kartotek !');
        Exit; // Afbryd F6 og gå til debitor felt
      end;
*)
      if not ffDebKar.FindKey([mtEksDebitorNr.AsString]) then begin
        eDebitorNr.SetFocus;
        ChkBoxOk ('Debitorkonto findes ikke i kartotek !');
        Exit; // Afbryd F6 og gå til debitor felt
      end;
    end;
    if not CloseSF6 then
      CloseF6   := True;
    ModalResult := mrOK;
  end;
end;

procedure TLeveranceForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  SearchText : string;
begin
  with MainDm do

  begin
    if Shift = [] then
    begin
      case Key of
        VK_F8 : begin
          Key := 0;
          if mtLinLinieNr.Value > 1 then begin
            // Linie slettes
            if mtLin.State = dsBrowse then
              mtLin.Delete
            else
              mtLin.Cancel;
            mtLin.Edit;
            mtEksAntLin.Value          := mtEksAntLin.Value - 1;
            buVidere.Tag               := 2;
            buVidere.SetFocus;
          end else begin
            if ChkBoxYesNo ('Kan IKKE slette sidste linie, annuller ?', TRUE) then
              buLuk.Click;
          end;
        end;
        VK_UP : begin
          if ActiveControl.Name = 'EVare' then begin
            if mtLinLinieNr.Value > 1 then begin
              Key := 0;
            end else begin
              Beep;
              Key := 0;
            end;
          end;
        end;
        VK_DOWN : begin
          if ActiveControl.Name = 'EVare' then begin
            if mtLinLinieNr.Value < mtLin.RecordCount then begin
              Key := 0;
            end else begin
              Beep;
              Key := 0;
            end;
          end;
        end;
      end;
      exit;
    end;

    if Shift = [ssAlt] then
    begin
      if Key = VK_DOWN then begin
        if ActiveControl.Name = 'eYderNr' then begin
          YdLst;
          Key := 0;
        end else
        if ActiveControl.Name = 'eDebitorNr' then begin
        end else begin
        end;
      end;
      if UpCase (Chr (Key)) = 'I' then begin
        // LinieType
        if mtLinLinieType.Value = 1 then
          mtLinLinieType.Value  := 2
        else
        if mtLinLinieType.Value = 2 then
          mtLinLinieType.Value  := 70
        else
          mtLinLinieType.Value := 1;
        Key := 0;
      end;
      if UpCase (Chr (Key)) = 'R' then begin
        mtEksOrdreType.Value := 2;
        FakTypeExit (Self);
        Key := 0;
      end;
      if UpCase (Chr (Key)) = 'S' then begin
        mtEksOrdreType.Value := 1;
        FakTypeExit (Self);
        Key := 0;
      end;
      exit;
    end;

    if Shift = [ssCtrl] then
    begin
      // Ctrl + tast
      if UpCase(Chr(Key)) = 'S' then
      begin
        if ActiveControl = EVare then
        begin
          SearchText := '';
          if SubstOver(nxdb,mtEksLager.Value,SearchText ) then
          begin
            if (SubstForm.VareNrSub = SubstForm.VareNrOrg) then
            begin
              EVare.Text             := Trim(SubstForm.VareNrOrg);
              mtLinVareNr   .AsString:= EVare.Text;
              mtLinSubVareNr.AsString:= EVare.Text;
            end
            else
            begin
              mtLinVareNr   .AsString:= Trim(SubstForm.VareNrOrg);
              mtLinSubVareNr.AsString:= Trim(SubstForm.VareNrSub);
              EVare.Text             := mtLinSubVareNr.AsString;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TLeveranceForm.FakTypeExit(Sender: TObject);
begin
  with MainDm do begin
    if mtEksOrdreType.Value = 1 then begin
      laSalgRetur.Caption  := '&Retur/Salg';
      lcFakType.Color      := clWindow;
      lcFakType.Font.Color := clWindowText;
    end else begin
      laSalgRetur.Caption  := '&Salg/Retur';
      lcFakType.Color      := clRed;
      lcFakType.Font.Color := clYellow;
    end;
  end;
end;

procedure TLeveranceForm.FormKeyPress(Sender: TObject; var Key: Char);
var
  Bel   : integer;
  Ok    : Boolean;
  WNr   : Int64;
  WrkS,
  GAPO,
  SNr   : String;
  VareForSale : boolean;
  TestDate : TDate;

  procedure TabEnter;
  begin
    SelectNext (ActiveControl, TRUE, TRUE);
    Key := #0;
  end;
begin
  with MainDm do
  begin
    if Key <> #13 then
      exit;

    if ActiveControl = eYderNr then
    begin
      // Ydernr
      if ffYdLst.FindKey ([eYderNr.Text]) then begin
        mtEksYderNr.AsString      := ffYdLstYderNr.AsString;
        if Trim (ffYdLstNavn.AsString)  <> '' then
          mtEksYderNavn.AsString  := ffYdLstNavn.AsString;
      end;
      TabEnter;
      exit;
    end;



    if ActiveControl = EVare then
    begin
      // Hent Vareoversigt
//      FillChar (VareRec, SizeOf (VareRec), 0);
      mtLinVareNr.AsString     := '';
      mtLinSubVareNr.AsString  := '';
      mtLinAntal.Value         := 0;
      SNr := Trim (EVare.Text);
      if SNr = '' then
      begin
        Beep;
        ChkBoxOk('Vare findes IKKE i lagerkartoteket');
        paLager       .Caption := '';
        paInfo        .Caption := ' ' + mtLinSubVareNr.AsString + ' findes IKKE på lager';
        mtLinVareNr   .AsString:= '';
        mtLinSubVareNr.AsString:= '';
        Key := #0;
        exit;
      end;

      try
        if length(SNr) = 12 then begin
          SNr := '0' + SNr;
        end;
        try
          ffLagKar.IndexName := 'EanKodeOrden';
          Ok:= ffLagKar.FindKey([mtEksLager.AsInteger, SNr]);
          if ok then begin
            mtLinVareNr.AsString    := trim(ffLagKarVareNr.AsString);
            mtLinSubVareNr.AsString := trim(ffLagKarVareNr.AsString);
            snr := mtLinVareNr.AsString;
          end;
        finally
          ffLagKar.IndexName := 'NrOrden';
        end;
        if Length(SNr) = 13 then begin
          // Stregkode not ok so see if varenr in there must be cNTIN13Prefix in first 6 characters
          if not Ok then
          begin
            if copy(SNr,1,6) = sNTIN13Prefix then
              SNr := copy(SNr, 7, 6);
          end;
        end;
        if not ok then begin
          // Benyttes til at presse en exception for varesøgning
          if copy(caps(SNr),1,1) = 'X' then
            raise exception.Create('Hexdadecimal');
          if not tryStrToInt64(SNr,Wnr) then
            raise exception.Create('string');
          // Varenr
          mtLinVareNr.AsString    := SNr;
          mtLinSubVareNr.AsString := SNr;
          Ok:= ffLagKar.FindKey([mtEksLager.AsInteger, SNr]);
        end;
        if Ok then begin
          GAPO := '';
          if ffLagKarSubGrp.AsInteger > 0 then
            GAPO:= 'G';
          if GAPO <> '' then begin
            LeveranceForm.Update;
(*
            if TakstOver (SNr) then begin
               if (TakstForm.VareNrSub = ''                 ) or
                  (TakstForm.VareNrSub = TakstForm.VareNrOrg) then begin
                 SNr := Trim (TakstForm.VareNrOrg);
                 mtLinVareNr.AsString    := SNr;
                 mtLinSubVareNr.AsString := SNr;
               end else begin
                 mtLinSubVareNr.AsString := Trim (TakstForm.VareNrSub);
                 mtLinVareNr.AsString    := Trim (TakstForm.VareNrOrg);
                 SNr := mtLinSubVareNr.AsString;
               end;
            end;
*)
            if SubstOver(nxdb,mtEksLager.Value, SNr) then
            begin
              if (SubstForm.VareNrSub = SubstForm.VareNrOrg) then
              begin
                SNr := Trim(SubstForm.VareNrOrg);
                mtLinVareNr.AsString    := SNr;
                mtLinSubVareNr.AsString := SNr;
              end
              else
              begin
                mtLinSubVareNr.AsString := Trim(SubstForm.VareNrSub);
                mtLinVareNr.AsString    := Trim(SubstForm.VareNrOrg);
                SNr := mtLinSubVareNr.AsString;
              end;
            end;
          end;
        end;
      except
        // Ikke Nr, kald søgning
        if SNr <> '' then begin
          LeveranceForm.Update;
(*
          if TakstOver (SNr) then begin
             if (TakstForm.VareNrSub = ''                 ) or
                (TakstForm.VareNrSub = TakstForm.VareNrOrg) then begin
               SNr := Trim (TakstForm.VareNrOrg);
               mtLinVareNr.AsString    := SNr;
               mtLinSubVareNr.AsString := SNr;
             end else begin
               mtLinSubVareNr.AsString := Trim (TakstForm.VareNrSub);
               mtLinVareNr.AsString    := Trim (TakstForm.VareNrOrg);
               SNr := mtLinSubVareNr.AsString;
             end;
          end;
*)
          if SubstOver(nxdb,mtEksLager.Value,SNr) then
          begin
            if (SubstForm.VareNrSub = SubstForm.VareNrOrg) then
            begin
              SNr := Trim(SubstForm.VareNrOrg);
              mtLinVareNr.AsString    := SNr;
              mtLinSubVareNr.AsString := SNr;
            end
            else
            begin
              mtLinSubVareNr.AsString := Trim(SubstForm.VareNrSub);
              mtLinVareNr.AsString    := Trim(SubstForm.VareNrOrg);
              SNr := mtLinSubVareNr.AsString;
            end;
          end;
        end;
      end;
(*
      // Check DOS lager
      FillChar (VareRec, SizeOf (VareRec), 0);
      VareRec.Lager := mtEksLager.Value;
      VareRec.Nr    := mtLinSubVareNr.AsString;
      MidClient.HentVare (VareRec);
      if VareRec.Status = 0 then begin
        if not VareRec.Slettet then begin
          Ok := ffLmsTak.FindKey ([mtLinSubVareNr.AsString]);
*)
      if not ffLagKar.FindKey([stamform.stocklager, mtLinSubVareNr.AsString]) then
      begin
        // Vare findes ikke og skal ikke oprettes
        Beep;
        ChkBoxOk('Vare findes IKKE i lagerkartoteket');
        paLager       .Caption := '';
        paInfo        .Caption := ' ' + mtLinSubVareNr.AsString + ' findes IKKE på lager';
        mtLinVareNr   .AsString:= '';
        mtLinSubVareNr.AsString:= '';
        Key := #0;
        exit;
      end;
      TestDate := EncodeDate(2011,03,01);
      if Date >= TestDate then begin
        if copy(ffLagKarVareNr.AsString,1,2) = '69' then begin
          if ffLagKarVareType.AsInteger in [1,4,5,6,7] then begin
            if ffLagKarIndbNr.AsString = '' then begin
              ChkBoxOK('Før denne vare kan ekspederes, skal der tilknyttes et LMS henvisningsvarenummer i Lagerkartoteket.');
              exit;
            end;

          end;

        end;
      end;
        // check kundetype. if ingen or handkøbsudsalg then warn the user on certain
        // product types
      if maindm.ffPatKarKundeType.AsInteger in [0,15] then begin
        VareForSale := False;
        if  (maindm.ffLagKarUdlevType.AsString = 'HF') or
            (maindm.ffLagKarUdlevType.AsString = 'HX') or
            (maindm.ffLagKarUdlevType.AsString = 'HV') then
              VareForSale := True;

        if (maindm.ffLagKarVareType.AsInteger = 5) and (maindm.ffPatKarKundeType.AsInteger=0) then
          VareForSale := true;
       if (maindm.ffLagKarVareType.AsInteger = 5) and (maindm.ffPatKarKundeType.AsInteger=15) and (MainDm.ffLagKarHaType.AsString <>'') then
           VareForSale := true;

        if maindm.ffLagKarVareType.AsInteger in [2,8,9,10,11,12] then     // kirsten asked me to change this
          VareForSale := True;

        if not VareForSale then begin
            if not ChkBoxYesNo('Varen kan normalt ikke sælges til denne kundetype.' + #13#10 +
              'Vælg Ja, hvis den alligevel ønskes.',false) then begin
              paLager       .Caption := '';
              paInfo        .Caption := ' ' + mtLinSubVareNr.AsString + ' kan normalt ikke sælges til denne kundetype.';
              mtLinVareNr   .AsString:= '';
              mtLinSubVareNr.AsString:= '';
              exit;
            end;
        end;
      end;
      // Vis vare
      if ffLagKarAntal.AsInteger <= 0 then begin
        paLager     .Color:= clRed;
        paLager.Font.Color:= clWhite;
        if StamForm.StockLager <> StamForm.FLagerNr then begin
          paLager     .Color:= clAqua;
          paLager.Font.Color:= clBlack;
        end;
      end else begin
        paLager     .Color:= clBtnFace;
        paLager.Font.Color:= clWindowText;
      end;
      paLager.Caption:= ' ' + mtLinSubVareNr.AsString + ' lager ' + ffLagKarAntal.AsString;
      // Slettemærket ikke ved dosis
      if ffLagKarAfmDato.AsString <> '' then begin
        Beep;
        if ffLagKarAntal.AsInteger > 0 then
          ChkBoxOk('Vare er afregistreret i taksten, ' + ffLagKarAntal.AsString + ' på lager')
        else
          ChkBoxOk('Vare er afregistreret i taksten, ingen på lager');
        paInfo        .Caption := ' Vare er afregistreret i taksten';
        mtLinVareNr   .AsString:= '';
        mtLinSubVareNr.AsString:= '';
        Key := #0;
        exit;
      end;
      // Ikke afregistreret
      if (ffLagKarVareType.AsInteger in [1, 3..7]) and (ffLagKarUdlevType.AsString = '') then begin
        Beep;
        ChkBoxOk('Vare mangler udleveringsbestemmelse, kan ikke takseres');
        paInfo        .Caption := ' Vare mangler udleveringsbestemmelse';
        mtLinVareNr   .AsString:= '';
        mtLinSubVareNr.AsString:= '';
      end else begin
      // Check midlertidigt udgået
        if ffLagKarVareType.AsInteger in [1, 3..7] then begin
          if ffLagKarSletDato.AsString <> '' then begin
            Beep;
            if ffLagKarAntal.AsInteger > 0 then
              ChkBoxOk('Vare er midlertidigt udgået, ' + ffLagKarAntal.AsString + ' på lager')
            else
              ChkBoxOk('Vare er midlertidigt udgået, ingen på lager');
          end;
        end;
        // Udlevering OK
        mtLinNarkoType.AsInteger:= 0;
        GAPO:= '';
        if ffLagKarSubst.AsBoolean then
          GAPO:= ' [G]';
        mtLinLokation1.AsInteger:= ffLagKarLokation1.AsInteger;
        mtLinLokation2.AsInteger:= ffLagKarLokation2.AsInteger;
        mtLinTekst    .AsString := Trim(ffLagKarNavn.AsString);
        mtLinForm     .AsString := Trim(ffLagKarForm.AsString);
        mtLinStyrke   .AsString := Trim(ffLagKarStyrke.AsString);
        mtLinPakning  .AsString := Trim(ffLagKarPakning.AsString);
        mtLinSSKode   .AsString := ffLagKarSSKode.AsString;
        mtLinATCType  .AsString := ffLagKarATCType.AsString;
        mtLinATCKode  .AsString := ffLagKarATCKode.AsString;
        mtLinPAKode   .AsString := ffLagKarPAKode.AsString;
        mtLinUdlevType.AsString := Trim(ffLagKarUdlevType.AsString);
        mtLinHaType   .AsString := Trim(ffLagKarHAType.AsString);
        mtLinVareType.AsInteger := ffLagKarVareType.AsInteger;
        // Evt. 69xxxx vare
        if (copy (mtLinSubVareNr.AsString, 1, 2) = '69') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '222222') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '555555') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '666666') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '685800') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '777777') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '888888') or
            (copy (mtLinSubVareNr.AsString, 1, 6) = '999999') then begin
          WrkS:= mtLinTekst.AsString;
          if TastTekst('Tast evt. anden varetekst ?', WrkS) then
            mtLinTekst.AsString:= WrkS;
        end;
        // Check udlevering
        if mtLinUdlevType.AsString = '' then begin
          if ffLagKarVareType.AsInteger = 2 then
            mtLinUdlevType.AsString:= 'HF';
        end;
        // Salgspris evt. nettopris eller egenpris
        if mtEksNettoPriser.AsBoolean then begin
          mtLinPris.AsCurrency:= ffLagKarSalgsPris2.AsCurrency;
          if mtLinPris.AsCurrency = 0 then begin
            if ffLagKarEgenPris.AsCurrency > 0 then
              mtLinPris.AsCurrency:= ffLagKarEgenPris .AsCurrency
            else
              mtLinPris.AsCurrency:= ffLagKarSalgsPris.AsCurrency;
          end;
        end else begin
          if ffLagKarEgenPris.AsCurrency > 0 then
            mtLinPris.AsCurrency:= ffLagKarEgenPris .AsCurrency
          else
            mtLinPris.AsCurrency:= ffLagKarSalgsPris.AsCurrency;
          // Evt. HX/HV/HF tillægges recepturgebyr
          if mtLinPris.AsCurrency > 0 then
            if (ffLagKarVareType.AsInteger = 5) and (mtLinHatype.AsString <> '') then
              mtLinPris.AsCurrency:= mtLinPris.AsCurrency + ffRcpOplRcpGebyr.AsCurrency;
          if ProdDyrPrices then begin
            c2logadd('proddyr price used !!');
            mtLinPris.AsCurrency:= ffLagKarVetProdPris.AsCurrency;
            if mtLinPris.AsCurrency = 0 then begin
              if ffLagKarEgenPris.AsCurrency > 0 then
                mtLinPris.AsCurrency:= ffLagKarEgenPris .AsCurrency
              else
                mtLinPris.AsCurrency:= ffLagKarSalgsPris.AsCurrency;
              // Evt. HX/HV/HF tillægges recepturgebyr
              if mtLinPris.AsCurrency > 0 then
                if (ffLagKarVareType.AsInteger = 5) and (mtLinHatype.AsString <> '') then
                  mtLinPris.AsCurrency:= mtLinPris.AsCurrency + ffRcpOplRcpGebyr.AsCurrency;
            end;
          end;
        end;
        // Ingen pris måske slettet
        if mtLinPris.AsCurrency = 0 then begin
          Bel:= 0;
          if TastHeltal('Ingen salgspris, tast pris i ører ?', Bel) then begin
            // Omdan til kr og ører
            mtLinPris.AsCurrency:= Bel / 100;
          end;
        end else begin
          // Udligning på 100015
          if mtLinSubVareNr.AsString = '100015' then begin
            Bel:= 0;
            if TastHeltal ('Tast pris på "100015" i ører ?', Bel) then begin
              // Omdan til kr og ører
              mtLinPris.AsCurrency:= Bel / 100;
            end;
          end;
        end;

        // Remove recepturgebyr if HA håndkøbslinier before moms calculation
        if (ffLagKarVareType.AsInteger  = 5) and
           (mtLinPris       .AsCurrency > ffRcpOplRcpGebyr.AsCurrency) and
           (mtLinLinieType  .AsInteger  = 2) then begin
          // Håndkøbslinie
          mtLinPris.AsCurrency:= mtLinPris.AsCurrency - ffRcpOplRcpGebyr.AsCurrency;
        end;
        // Evt. avancepct
//            if mtEksAvancePct.Value > 0 then begin
//              // Avanceprocent fra DebitorKartotek
//              if mtLinUdlevType.AsString <> 'HF' then begin
//                Pris:= mtLinKostPris.AsCurrency * mtEksAvancePct.Value / 100;
//                Pris:= mtLinKostPris.AsCurrency + Pris;
//                Moms:= NettoMoms(Pris, MomsPercent);
//                mtLinPris.AsCurrency:= RoundDecCurr(Pris + Moms);
//              end;
//            end;

        // New MOMS code - THIS HAS TO BE LAST OPERATION ON PRICE
        if mtEksDebitorNr.AsString <> '' then
        begin
          if ffDebKarMomsType.AsInteger = 0 then
          begin
            mtLinPris.AsCurrency := mtLinPris.AsCurrency -
              BruttoMoms(mtLinPris.AsCurrency,MomsPercent);
          end;
        end;

        // DONT CHANGE PRICE AFTER THIS POINT

        // Kostpris m.m.
        mtLinKostPris.AsCurrency:= ffLagKarKostPris.AsCurrency;
        mtLinBGP     .AsCurrency:= ffLagKarBGP     .AsCurrency;
        mtLinAndel   .AsCurrency:= mtLinPris       .AsCurrency;
        mtLinESP     .AsCurrency:= mtLinPris       .AsCurrency;

        eVare .Text   := ffLagKarVareNr.AsString;
        paInfo.Caption:= ' ' +
          mtLinTekst.AsString     + ' ' +
          mtLinForm.AsString      + ' ' +
          mtLinStyrke.AsString    + ' ' +
          mtLinPakning.AsString   + ' udlevering ' +
          mtLinUdlevType.AsString + ' ' +
          mtLinHaType.AsString    + GAPO;
        TabEnter;
      end;
      exit;
    end;

    if ActiveControl.Name = 'DBEPris' then begin
      Key := #0;
      TabEnter;
      exit;
    end;

    if ActiveControl.Name = 'DBETekst' then begin
      Key := #0;
      TabEnter;
      exit;
    end;

    if ActiveControl.Name = 'EAntal' then
    begin
      try
        mtLinAntal.Value := StrToInt (EAntal.Text);
      except
        mtLinAntal.Value := 1;
        EAntal.Text      := '1';
      end;
      mtLinAntal.Value   :=  Abs (mtLinAntal.Value);
      if  (StamForm.RowaEnabled) and
          (not StamForm.RowaOrdre) and
          (mtEksEkspType.AsInteger <> et_Dosispakning) and
          (mtEksOrdreType.AsInteger = 1) then  begin
            if mtLinLokation1.AsInteger = StamForm.RowaLokation then
              frmRowaApp.RowaSendARequest(mtLinSubVareNr.AsString,mtLinAntal.AsInteger);
      end;
      if mtLinAntal.Value < 100 then begin
        mtLinTilskType.Value      := 0;
        mtLinRegelSyg.Value       := 0;
        mtLinRegelKom1.Value      := 0;
        mtLinRegelKom2.Value      := 0;
        mtLinTilskSyg.AsCurrency  := 0;
        mtLinTilskKom1.AsCurrency := 0;
        mtLinTilskKom2.AsCurrency := 0;
        mtLinBrutto.AsCurrency    := mtLinPris.AsCurrency * mtLinAntal.Value;
        mtLinAndel.AsCurrency := mtLinBrutto.AsCurrency;
        Key := #0;
        TabEnter;
      end else begin
        ChkBoxOk ('Kun max 99 i antal pr. ordination !');
        mtLinAntal.Value := 99;
        EAntal.Text      := '99';
        mtLinTilskType.Value      := 0;
        mtLinRegelSyg.Value       := 0;
        mtLinRegelKom1.Value      := 0;
        mtLinRegelKom2.Value      := 0;
        mtLinTilskSyg.AsCurrency  := 0;
        mtLinTilskKom1.AsCurrency := 0;
        mtLinTilskKom2.AsCurrency := 0;
        mtLinBrutto.AsCurrency    := mtLinPris.AsCurrency * mtLinAntal.Value;
        mtLinAndel.AsCurrency     := mtLinBrutto.AsCurrency;
        Key := #0;
        TabEnter;
      end;
      buVidere.Tag := 2;
      buVidere.SetFocus;
      exit;
    end;
    if (not (ActiveControl is TDBGrid))     and
       (not (ActiveControl is TDBMemo))     and
       (not (ActiveControl is TMemo))       and
       (not (ActiveControl is TRichEdit))   and
       (not (ActiveControl is TDBRichEdit)) then begin
      if (ActiveControl is TDBLookupComboBox) then begin
        if not (ActiveControl as TDBLookupComboBox).ListVisible then
          TabEnter
      end else
      if (ActiveControl is TDBComboBox) then begin
        if not (ActiveControl as TDBComboBox).DroppedDown then
          TabEnter;
      end else
        TabEnter;
    end;
  end;
end;

procedure TLeveranceForm.DropDown(Sender: TObject);
begin
  with MainDm do begin
    if (Sender is TDbLookupComboBox) then begin
      (Sender as TDbLookupComboBox).DropDownRows :=
      (Sender as TDbLookupComboBox).ListSource.DataSet.RecordCount;
    end;
    if (Sender is TDbComboBox) then begin
      (Sender as TDbComboBox).DropDownCount :=
      (Sender as TDbComboBox).Items.Count;
    end;
  end;
end;

procedure TLeveranceForm.eDebitorNrExit(Sender: TObject);
begin
  with MainDm do begin
    try
      if (ProdDyrPrices) and (mtLin.RecordCount >= 1) then begin
        if OldDebitor <> eDebitorNr.Text then
          ChkBoxOK('Kontoen er til produktionsdyr med specielle priser.' + #10#13 +
                'Den kan derfor ikke ændres under ekspeditionen.');
        exit;
      end;
      if Trim (eDebitorNr.Text) = '' then begin
        mtEksDebitorNavn.AsString := '';
        mtEksLeveringsForm.Value  := 0;
        // reset everything else back the way it should be on start
        mtEksAfdeling.Value        := MainDm.AfdNr;
        mtEksLager.Value           := StamForm.FLagerNr;
        StamForm.StockLager := mtEksLager.Value;
        mtEksUdbrGebyr.AsCurrency  := 0.0;
        ProdDyrPrices := False;
        exit;
      end;
      if not ffDebKar.FindKey([mtEksDebitorNr.AsString]) then
        exit;

      if not LagerListeLagerChk then begin
        mtEksAfdeling.Value        := ffDebKarAfdeling     .AsInteger;
        mtEksLager.Value           := ffDebKarLager        .AsInteger;
        StamForm.StockLager := mtEksLager.Value;
      end;
      mtEksAvancePct.Value       := ffDebKarAvancePct    .AsCurrency;
      mtEksDebitorNavn.AsString  := BytNavn (ffDebKarNavn.AsString);
      mtEksLeveringsForm.Value   := ffDebKarLevForm      .AsInteger;
      mtEksUdbrGebyr.AsCurrency  := 0.0;
      if (ffDebKarLevForm.AsInteger in [5,6]) and (mtEksKundeType.AsInteger <> 15) then begin
//        if AllHKLines then
          mtEksUdbrGebyr.AsCurrency := ffRcpOplHKgebyr.AsCurrency;
      end;
      if ffDebKarUdbrGebyr.AsBoolean then begin
        if mtEksUdbrGebyr.AsCurrency = 0 then
          mtEksUdbrGebyr.AsCurrency := ffRcpOplPlejehjemsgebyr.AsCurrency;
        if ffDebKarLevForm.AsInteger = 2 then
          mtEksUdbrGebyr.AsCurrency:= ffRcpOplUdbrGebyr    .AsCurrency;
      end;
    finally
      checkDebitor;
    end
  end;
end;

procedure TLeveranceForm.eDebitorNrEnter(Sender: TObject);
begin
  with MainDm do begin
    OldDebitor := mtEksDebitorNr.AsString;

  end;
end;

procedure TLeveranceForm.acLager0Execute(Sender: TObject);
begin
  StamForm.StockLager := 0;
end;

procedure TLeveranceForm.acLager1Execute(Sender: TObject);
begin
  StamForm.StockLager := 1;

end;

procedure TLeveranceForm.acLager2Execute(Sender: TObject);
begin
  StamForm.StockLager := 2;

end;

procedure TLeveranceForm.acLager3Execute(Sender: TObject);
begin
  StamForm.StockLager := 3;

end;

procedure TLeveranceForm.acLager4Execute(Sender: TObject);
begin
  StamForm.StockLager := 4;

end;

procedure TLeveranceForm.acLager5Execute(Sender: TObject);
begin
  StamForm.StockLager := 5;

end;

end.


