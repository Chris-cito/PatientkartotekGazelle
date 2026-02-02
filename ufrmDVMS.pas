unit ufrmDVMS;

{ Developed by: Cito IT A/S

  Description: Form used to scan dmvs data for retur ekspeditions

  Highest assigned Tilstand: 100000.

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  24-11-2020/cjs  Restext line added to the DMVS reactivate fejl details

  05-08-2019/cjs  EscapePressedInDMVS boolean property added

  08-07-2019/cjs  Escape key code added to frmDMVS.new message allowing the press of escape to
                  quit the screen

  02-07-2019/cjs  If product is classified as dmklDMVSVare2DKrav then the 2d barcode must be scanned

  30-04-2019/cjs  Correction sql to update ReturTidspunkt in eksplinierseriumre + copy code into full
                  return of an ekspedition

  30-04-2019/cjs  Update ReturTidspunkt in eksplinierseriumre

  26-04-2019/cjs  Corrected sql in Checkalreadyscanned

  26-04-2019/cjs  add a TC2DMVSSvrConnection to the class procedures and use this connection rather
                  than the one created in Main datamodule

  25-04-2019/cjs  Check to see if DMVS produt has been scanned already

  05-04-2019/cjs  Add an entry in eksplinierserienumre for all entries on the orignal  salg ekspedition

  05-04-2019/cjs  put quotes around strings for sql inserts
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,nxdb, System.Actions, Vcl.ActnList,
  uC2Vareidentifikator.Classes,
  uC2DMVSSvrConnection.Classes,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.StdCtrls;

type
  TfrmDMVS = class(TForm)
    edtScan: TEdit;
    ActionManager1: TActionManager;
    acOpdater: TAction;
    acFortryd: TAction;
    lblLbnr: TLabel;
    lblVarenr: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    procedure acOpdaterExecute(Sender: TObject);
    procedure acFortrydExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtScanKeyPress(Sender: TObject; var Key: Char);
  private
    FNewLbnr: integer;
    FOldLbnr: integer;
    FLinenr: integer;
    FVarenr: string;
    FVareIdent: TC2Vareident;
    FScnVarenr: string;
    FnxDB: TnxDatabase;
    FBrugerNr: integer;
    FLager: integer;
    FTekst: string;
    FDMVSMessage: string;
    FDMVSConnection: TC2DMVSSvrConnection;
    { Private declarations }
    property nxDB : TnxDatabase read FnxDB write FnxDB;
    property BrugerNr: integer read FBrugerNr write FBrugerNr;
    property NewLbnr: integer read FNewLbnr write FNewLbnr;
    property OldLbnr: integer read FOldLbnr write FOldLbnr;
    property Varenr: string read FVarenr write FVarenr;
    property VareIdent: TC2Vareident   read FVareIdent write FVareIdent;
  public
    { Public declarations }
    /// <summary>Shows a form that will allow a DMVS produkt to be scanned
    /// </summary>
    /// <param name="ADatabase">A Nexus database component, already opened.
    /// </param>
    /// <param name="ADMVSConnection">A connection to DMVSServer already created.
    /// </param>
    /// <param name="ABrugernr">Brugernr that created the retur espedition
    /// </param>
    /// <param name="AOldLbnr"> The current lbnr being credited
    /// </param>
    /// <param name="ANewLbnr"> The new lbnr credited as part of the credit
    /// </param>
    /// <param name="ALager"> The lager of the produkt sold
    /// </param>
    /// <param name="ALinienr">The liner number of the eskpedition being credited
    /// </param>
    /// <param name="AVarenr">The varenr to look for
    /// </param>
    /// <param name="ATekst">The name of the product
    /// </param>
    ///  <param name="AResultList">Stringlist with result messages in to be printed
    ///  </param>
    class function UpdateDMVSInfo(Anxdb: TnxDatabase; ADMVSConnection : TC2DMVSSvrConnection;
      ABrugernr, AOldlbnr, ANewLbnr, ALager, Alinienr: integer; Avarenr: string;
      ATekst: string;        AResultList : TStringList) : boolean;


    /// <summary>procedure to recativate all DMVS produkts in an ekspedition
    /// </summary>
    /// <param name="ADatabase">A Nexus database component, already opened.
    /// </param>
    /// <param name="ADMVSConnection">A connection to DMVSServer already created.
    /// </param>
    /// <param name="ABrugernr">Brugernr that created the retur espedition
    /// </param>
    /// <param name="AOldLbnr"> The current lbnr being credited
    /// </param>
    /// <param name="ALinieNr"> The current line being credited. if 0 then all lines
    /// </param>
    /// <param name="ANewLbnr"> The new lbnr credited as part of the credit
    /// </param>
    /// <param name="ALager"> The lager of the produkt sold
    /// </param>
    ///  <param name="AResultList">Stringlist with result messages in to be printed
    ///  </param>
    class function UpdateAllDMVSinfo(Anxdb: TnxDatabase; ADMVSConnection : TC2DMVSSvrConnection;
      ABrugernr, AOldLbnr, ALinieNr, ANewLbnr,  ALager: integer; AResultList : TStringList) :boolean;

  end;


implementation

uses
  uC2Vareidentifikator.Procs, uC2Vareidentifikator.Types,
  ChkBoxes,
  uEkspLinierSerienumre.Tables,
  uC2Environment, uC2DMVS.Procs,uC2DMVS.Types, uC2DMVSSvr.Types, DM, C2MainLog;

{$R *.dfm}

{ TfrmDMVS }

procedure TfrmDMVS.acFortrydExecute(Sender: TObject);
begin
  if ChkBoxYesNo('Du har trykket escape!' +#13#10 +
                  'Er du sikker på, at varen ingen 2D kode har?',True) then
  begin
    C2LogAdd('escape pressed in frmDMVS and accepted');
    MainDm.EscapePressedInDMVS := True;
    ModalResult := mrCancel;
  end;
end;

procedure TfrmDMVS.acOpdaterExecute(Sender: TObject);
var
  nxq : TnxQuery;
  LoggedWith : TDMVSLogStatus;
  OprCode : integer;
  ResText : string;

  function CheckAlreadyScanned : boolean;
  var
    SqlString : string;

  begin
    Result := False;

    try
      SqlString := 'select ' + fnEkspLinierSerienumreProduktKode +
            ' from ' + tnEkspLinierSerienumre +
            ' where ' + fnEkspLinierSerienumreLbNr +'=' +  NewLbnr.toString +
            ' and ' + fnEkspLinierSerienumreProduktKode + '=' + AnsiQuotedStr(VareIdent.Produktkode,'''') +
            ' and ' + fnEkspLinierSerienumreSerieNr + '=' + AnsiQuotedStr(VareIdent.Serienr,'''') +
            ' and ' + fnEkspLinierSerienumreBatchNr + '=' + AnsiQuotedStr(VareIdent.Batchnr,'''') +
            ' and ' + fnEkspLinierSerienumreUdDato + '=' + AnsiQuotedStr(VareIdent.Udloebsdato,'''');
      C2LogAdd(Format('Sqlstring in CheckAlreadyScanned is %s ',[sqlstring]));

      with nxdb.OpenQuery(SqlString,[]) do
      begin
          if RecordCount <> 0 then
            result := True;
          Free;
      end;
    except on E: Exception do
      C2LogAdd(Format('Fejl in checkalready scanned %s',[e.Message]));
    end;

  end;

begin
  // if we get here then we need to know if the scanned info matches a line in
  // eksplinierserienumre, if it does then cool lets delete it and cacel via dmvs server

  nxq := TnxQuery.Create(Nil);
  try
    nxq.Database := nxDB;
    nxq.SQL.Add('select ');
    nxq.SQL.Add(                  fnEkspLinierSerienumreLinieNr);
    nxq.SQL.Add(            ',' + fnEkspLinierSerienumreProduktKode);
    nxq.SQL.Add(            ',' + fnEkspLinierSerienumreSerieNr);
    nxq.SQL.Add(            ',' + fnEkspLinierSerienumreBatchNr);
    nxq.SQL.Add(            ',' + fnEkspLinierSerienumreUdDato);
    nxq.SQL.Add('from ' + tnEkspLinierSerienumre);
    nxq.SQL.Add('where');
    nxq.SQL.Add(fnEkspLinierSerienumreLbNr + '=' + OldLbnr.toString);
    nxq.SQL.Add('and ' + fnEkspLinierSerienumreProduktKode + '=' + AnsiQuotedStr(VareIdent.Produktkode,''''));
    nxq.SQL.Add('and ' + fnEkspLinierSerienumreSerieNr + '=' + AnsiQuotedStr(VareIdent.Serienr,''''));
    nxq.SQL.Add('and ' + fnEkspLinierSerienumreBatchNr + '=' + AnsiQuotedStr(VareIdent.Batchnr,''''));
    nxq.SQL.Add('and ' + fnEkspLinierSerienumreUdDato + '=' + AnsiQuotedStr(VareIdent.Udloebsdato,''''));
    nxq.SQL.Add('and ' + fnEkspLinierSerienumreUdDato + '=' + AnsiQuotedStr(VareIdent.Udloebsdato,''''));
    nxq.SQL.Add('and ' + fnEkspLinierSerienumreReturtidspunkt + ' is null');
    c2logadd(nxq.sql.text);
    nxq.Open;
    if nxq.RecordCount = 0 then
    begin
      C2LogAdd('not found the details in eksplinierserienumre');
      ChkBoxOK('Scan den pakning med korrekt serienummer.');
      edtScan.Text := '';
      edtScan.SetFocus;
      exit;
    end;

    if CheckAlreadyScanned then
    begin
      ChkBoxOK('Denne pakning er allerede scannet');
      edtScan.Text := '';
      edtScan.SetFocus;
      exit;
    end;


    // we need to reactivate the product being scanned
    C2LogAdd('about to call reactivate pack in acOpdateExecute');
    if not  FDMVSConnection.ReactivatePack(BrugerNr,OldLbnr,
              nxq.FieldByName(fnEkspLinierSerienumreLinieNr).AsInteger,dlsSend,False,
              nxq.FieldByName(fnEkspLinierSerienumreProduktKode).AsString,
              nxq.FieldByName(fnEkspLinierSerienumreSerieNr).AsString,
              nxq.FieldByName(fnEkspLinierSerienumreBatchNr).AsString,
              nxq.FieldByName(fnEkspLinierSerienumreUdDato).AsString,
              LoggedWith,OprCode,ResText) then
    begin
      C2LogAdd('oprcode is ' + OprCode.ToString);
      C2LogAdd('restext ' + ResText);
      maindm.FejliDMVS := True;
      FDMVSMessage :=
                              Format('%-8s %-20s %-14s %-20s %-20s %-8s %s',[
                                VareIdent.Vnr,
                                copy(VareIdent.Varebeskrivelse,1,20),
                                nxq.FieldByName(fnEkspLinierSerienumreProduktKode).AsString,
                                nxq.FieldByName(fnEkspLinierSerienumreSerieNr).AsString,
                                nxq.FieldByName(fnEkspLinierSerienumreBatchNr).AsString,
                                nxq.FieldByName(fnEkspLinierSerienumreUdDato).AsString,
                                ResText
                              ]);

//      ChkBoxOK(ResText);
      ModalResult := mrOk;
      exit;

    end
    else
    begin
    // success
{ TODO : what happens if there are multpile errors }
          // success
      if not IsDMVSOperationCodeASuccess(daReactivate,OprCode,dlsSend,LoggedWith) then
      begin
//        ChkBoxOK(ResText);
      FDMVSMessage :=
                              Format('%-8s %-20s %-14s %-20s %-20s %-8s %s',[
                                VareIdent.Vnr,
                                copy(VareIdent.Varebeskrivelse,1,20),
                                nxq.FieldByName(fnEkspLinierSerienumreProduktKode).AsString,
                                nxq.FieldByName(fnEkspLinierSerienumreSerieNr).AsString,
                                nxq.FieldByName(fnEkspLinierSerienumreBatchNr).AsString,
                                nxq.FieldByName(fnEkspLinierSerienumreUdDato).AsString,
                                'Fejl'
                              ]);
        maindm.FejliDMVS := True;
        ModalResult := mrOk;
        exit;
      end;
    end;

    FDMVSMessage :=
                              Format('%-8s %-20s %-14s %-20s %-20s %-8s %s',[
                                VareIdent.Vnr,
                                copy(VareIdent.Varebeskrivelse,1,20),
                              nxq.FieldByName(fnEkspLinierSerienumreProduktKode).AsString,
                              nxq.FieldByName(fnEkspLinierSerienumreSerieNr).AsString,
                              nxq.FieldByName(fnEkspLinierSerienumreBatchNr).AsString,
                              nxq.FieldByName(fnEkspLinierSerienumreUdDato).AsString,
                              'Godkendt'
                            ]);


    // insert an entry into eksplinierserienumre
    C2LogAdd('about to insert the entry in eksplinierserienumre');
    nxq.Close;
    nxq.SQL.Clear;
    nxq.SQL.Add('insert into ' + tnEkspLinierSerienumre + '(');
    nxq.SQL.Add(fnEkspLinierSerienumreLbNr);
    nxq.SQL.Add(',' + fnEkspLinierSerienumreLinieNr);
    nxq.SQL.Add(',' + fnEkspLinierSerienumreProduktKode);
    nxq.SQL.Add(',' + fnEkspLinierSerienumreSerieNr);
    nxq.SQL.Add(',' + fnEkspLinierSerienumreBatchNr);
    nxq.SQL.Add(',' + fnEkspLinierSerienumreUdDato);
    nxq.SQL.Add(',' + fnEkspLinierSerienumreAntal);
    nxq.SQL.Add(') values (');
    nxq.SQL.Add(fnewlbnr.ToString);
    nxq.SQL.Add(',' + flinenr.ToString);
    nxq.SQL.Add(',' + AnsiQuotedStr(VareIdent.Produktkode,''''));
    nxq.SQL.Add(',' + AnsiQuotedStr(VareIdent.Serienr,''''));
    nxq.SQL.Add(',' + AnsiQuotedStr(VareIdent.Batchnr,''''));
    nxq.SQL.Add(',' + AnsiQuotedStr(VareIdent.Udloebsdato,''''));
    nxq.SQL.Add(',1' );
    nxq.SQL.Add(')');
    C2LogAdd(nxq.SQL.Text);
    nxq.ExecSQL;

    // update the old ekspedition eksplinierserienumre entry with a Returtidspunkt

    C2LogAdd('update the old eksplinierserienumre with Returtidspunkt');
    nxq.Close;
    nxq.SQL.Clear;
    nxq.SQL.Add('update ');
    nxq.SQL.Add(tnEkspLinierSerienumre);
    nxq.SQL.Add('set Returtidspunkt=current_timestamp');
    nxq.SQL.Add('where');
    nxq.SQL.Add(fnEkspLinierSerienumreLbNr + '=' + OldLbnr.toString);
    nxq.SQL.Add('and ' + fnEkspLinierSerienumreProduktKode + '=' + AnsiQuotedStr(VareIdent.Produktkode,''''));
    nxq.SQL.Add('and ' + fnEkspLinierSerienumreSerieNr + '=' + AnsiQuotedStr(VareIdent.Serienr,''''));
    nxq.SQL.Add('and ' + fnEkspLinierSerienumreBatchNr + '=' + AnsiQuotedStr(VareIdent.Batchnr,''''));
    nxq.SQL.Add('and ' + fnEkspLinierSerienumreUdDato + '=' + AnsiQuotedStr(VareIdent.Udloebsdato,''''));
    c2logadd(nxq.sql.text);
    nxq.ExecSQL;


    ModalResult := mrOk;




  finally
    nxq.Free;
  end;

end;

procedure TfrmDMVS.edtScanKeyPress(Sender: TObject; var Key: Char);

begin

  if Key <> #13 then
  begin
    EditVareidentKeyPress(Sender, Key);
    exit;
  end;

  // enter pressed or scan complete
  C2LogAdd('scan is ' + edtScan.Text);
  if not Vareident.Parse(edtScan.Text) then
  begin
    ChkBoxOK('Invalid scanning');
    edtScan.SelectAll;
    edtScan.SetFocus;
    exit;
  end;

  // scanning worked
  C2LogAdd('identtype is ' + FVareIdent.IdentType.toString);

  // if the product was scanned with 2d code then ask them to scan again
//  if CheckEksplinierSerieNumre(OldLbnr,Linenr) then
//  begin
  if FVareIdent.DMVSKlassificering in [dmklDMVSVare,dmklDMVSVare2DKrav] then
  begin

    if FVareident.IdentType <> vitGS1DataMatrix then
    begin
      case FVareIdent.DMVSKlassificering of
        dmklDMVSVare:
          begin
            if ChkBoxYesNo('2D-koden skal om muligt scannes.' + #13#10 +
              'Har pakningen en 2D-kode?', True) then
            begin
              edtScan.text := '';
              edtScan.SetFocus;
              exit;
            end;
          end;
        dmklDMVSVare2DKrav:
          begin
            ChkBoxOK('Dette er en DMVS-vare  - Scan 2D koden');
            edtScan.text := '';
            edtScan.SetFocus;
            exit;
          end;
      end;

    end;


  end;

//  end;

  C2LogAdd(' vnr is ' + FVareIdent.Vnr + ' varenr is  ' + Varenr);
  if FVareIdent.Vnr <> Varenr then
  begin
    ChkBoxOK('Forkert vare');
    edtScan.SelectAll;
    edtScan.SetFocus;
    exit;
  end;


  C2LogAdd('DMVS Kassificering ' + FVareIdent.DMVSKlassificering.toString);
  if (FVareIdent.IdentType = vitGS1DataMatrix) and
    (FVareIdent.DMVSKlassificering in [dmklUkendt, dmklIkkeDMVSVare]) then
  begin
    ChkBoxOK('Den scannede vare er ikke en DMVS vare');
    edtScan.SelectAll;
    edtScan.SetFocus;
    exit;
  end;


  // if we get here then we should update dmvs or just get out if not dmvs scanning

  if FVareIdent.IdentType = vitGS1DataMatrix then
    acOpdaterExecute(Sender)
  else
    ModalResult := mrCancel;

end;

procedure TfrmDMVS.FormShow(Sender: TObject);
begin
  lblLbnr.Caption := 'Lbnr. ' + OldLbnr.toString;
  lblVarenr.Caption := 'Varenr. ' + Varenr + ' - ' + FTekst;
  acOpdater.Enabled := False;
  edtScan.SetFocus;
end;


class function TfrmDMVS.UpdateAllDMVSinfo(Anxdb: TnxDatabase; ADMVSConnection : TC2DMVSSvrConnection;
  ABrugernr, AOldLbnr, AlinieNr, ANewLbnr, ALager: integer; AResultList: TStringList) : boolean;
var
  nxq : TnxQuery;
  nxqInsert : TnxQuery;
  LoggedWith : TDMVSLogStatus;
  OprCode : integer;
  ResText : string;
begin
  Result := True;
  with TfrmDMVS.Create(Nil) do
  begin
    try
      FOldLbnr := AOldLbnr;
      FNewLbnr := ANewLbnr;
      FnxDB := Anxdb;
      FBrugerNr := ABrugernr;
      FLager := ALager;
      FVareIdent := TC2Vareident.Create(FnxDB,Flager,'',True);



      nxq := TnxQuery.Create(Nil);
      nxqInsert := TnxQuery.Create(Nil);
      try
        nxq.Database := nxDB;
        nxqInsert.Database := nxDB;

        nxq.SQL.Add('select ');
        nxq.SQL.Add(                  'els.' + fnEkspLinierSerienumreLinieNr);
        nxq.SQL.Add(            ',els.' + fnEkspLinierSerienumreProduktKode);
        nxq.SQL.Add(            ',els.' + fnEkspLinierSerienumreSerieNr);
        nxq.SQL.Add(            ',els.' + fnEkspLinierSerienumreBatchNr);
        nxq.SQL.Add(            ',els.' + fnEkspLinierSerienumreUdDato);
        nxq.SQL.Add(            ',els.' + fnEkspLinierSerienumreAntal);
        nxq.SQL.Add(            ',' + 'sal.subvarenr');
        nxq.SQL.Add(            ',' + 'sal.tekst');
        nxq.SQL.Add('from ' + tnEkspLinierSerienumre + ' as els');
        nxq.SQL.Add('inner join ekspliniersalg as sal on sal.lbnr=els.lbnr and sal.linienr=els.linienr');
        nxq.SQL.Add('where');
        nxq.SQL.Add('els.' + fnEkspLinierSerienumreLbNr + '=' + OldLbnr.toString);
        if AlinieNr <> 0 then
          nxq.SQL.Add('and els.' + fnEkspLinierSerienumreLinieNr + '=' + aLinienr.toString);


        c2logadd(nxq.sql.text);
        nxq.Open;
        if nxq.RecordCount = 0 then
        begin
//          ChkBoxOK('Not found in eksplinierserienumre');
          exit;
        end;

        nxq.First;
        while not nxq.Eof do
        begin

          // first check if the current varenr is a dmvs product

          if not VareIdent.Parse(nxq.FieldByName('subvarenr').AsString) then
          begin
            nxq.Next;
            continue;
          end;

          // if the produktkode is empty or non dmvs then just copy the eksplinierserienumre from
          // the original ekspedition

          if (nxq.FieldByName(fnEkspLinierSerienumreProduktKode).AsString.IsEmpty) or
              (VareIdent.DMVSKlassificering in [dmklUkendt,dmklIkkeDMVSVare]) then
          begin

            // insert an entry into eksplinierserienumre
            C2LogAdd('about to insert a non DMVS entry in eksplinierserienumre');
            nxqInsert.Close;
            nxqInsert.SQL.Clear;
            nxqInsert.SQL.Add('insert into ' + tnEkspLinierSerienumre + '(');
            nxqInsert.SQL.Add(fnEkspLinierSerienumreLbNr);
            nxqInsert.SQL.Add(',' + fnEkspLinierSerienumreLinieNr);
            nxqInsert.SQL.Add(',' + fnEkspLinierSerienumreProduktKode);
            nxqInsert.SQL.Add(',' + fnEkspLinierSerienumreSerieNr);
            nxqInsert.SQL.Add(',' + fnEkspLinierSerienumreBatchNr);
            nxqInsert.SQL.Add(',' + fnEkspLinierSerienumreUdDato);
            nxqInsert.SQL.Add(',' + fnEkspLinierSerienumreAntal);
            nxqInsert.SQL.Add(') values (');
            nxqInsert.SQL.Add(fnewlbnr.ToString);
            nxqInsert.SQL.Add(',' + nxq.FieldByName(fnEkspLinierSerienumreLinieNr).AsString);
            nxqInsert.SQL.Add(',' + AnsiQuotedStr(nxq.FieldByName(fnEkspLinierSerienumreProduktKode).AsString,''''));
            nxqInsert.SQL.Add(',' + AnsiQuotedStr(nxq.FieldByName(fnEkspLinierSerienumreSerieNr).AsString,''''));
            nxqInsert.SQL.Add(',' + AnsiQuotedStr(nxq.FieldByName(fnEkspLinierSerienumreBatchNr).AsString,''''));
            nxqInsert.SQL.Add(',' + AnsiQuotedStr(nxq.FieldByName(fnEkspLinierSerienumreUdDato).AsString,''''));
            nxqInsert.SQL.Add(',' + nxq.FieldByName(fnEkspLinierSerienumreAntal).AsString );
            nxqInsert.SQL.Add(')');
            C2LogAdd(nxqInsert.SQL.Text);
            nxqInsert.ExecSQL;

            nxq.Next;
            continue;
          end;

          // we need to reactivate the product being scanned
          if not  ADMVSConnection.ReactivatePack(BrugerNr,OldLbnr,
                    nxq.FieldByName(fnEkspLinierSerienumreLinieNr).AsInteger,dlsSend,False,
                    nxq.FieldByName(fnEkspLinierSerienumreProduktKode).AsString,
                    nxq.FieldByName(fnEkspLinierSerienumreSerieNr).AsString,
                    nxq.FieldByName(fnEkspLinierSerienumreBatchNr).AsString,
                    nxq.FieldByName(fnEkspLinierSerienumreUdDato).AsString,
                    LoggedWith,OprCode,ResText) then
          begin
            C2LogAdd('oprcode is ' + OprCode.ToString);
            C2LogAdd('restext ' + ResText);
            MainDm.FejliDMVS := True;
            AResultList.Add(
                              Format('%-8s %-20s %-14s %-20s %-20s %-8s %s',[
                                nxq.FieldByName('subvarenr').AsString,
                                copy(nxq.FieldByName('tekst').AsString,1,20),
                                nxq.FieldByName(fnEkspLinierSerienumreProduktKode).AsString,
                                nxq.FieldByName(fnEkspLinierSerienumreSerieNr).AsString,
                                nxq.FieldByName(fnEkspLinierSerienumreBatchNr).AsString,
                                nxq.FieldByName(fnEkspLinierSerienumreUdDato).AsString,
                                ResText
                              ])
                    );

          end
          else
          begin
{ TODO : what happens if there are multpile errors }
          // success
            if not IsDMVSOperationCodeASuccess(daReactivate,OprCode,dlsSend,LoggedWith) then
            begin
              AResultList.Add(
                              Format('%-8s %-20s %-14s %-20s %-20s %-8s',[
                                nxq.FieldByName('subvarenr').AsString,
                                copy(nxq.FieldByName('tekst').AsString,1,20),
                                  nxq.FieldByName(fnEkspLinierSerienumreProduktKode).AsString,
                                  nxq.FieldByName(fnEkspLinierSerienumreSerieNr).AsString,
                                  nxq.FieldByName(fnEkspLinierSerienumreBatchNr).AsString,
                                  nxq.FieldByName(fnEkspLinierSerienumreUdDato).AsString
                                ])
                              );
              AResultList.Add(Format('     %s',[ResText]));
              MainDm.FejliDMVS := True;
            end
            else
            begin

              // insert an entry into eksplinierserienumre
              C2LogAdd('about to insert the entry in eksplinierserienumre');
              nxqInsert.Close;
              nxqInsert.SQL.Clear;
              nxqInsert.SQL.Add('insert into ' + tnEkspLinierSerienumre + '(');
              nxqInsert.SQL.Add(fnEkspLinierSerienumreLbNr);
              nxqInsert.SQL.Add(',' + fnEkspLinierSerienumreLinieNr);
              nxqInsert.SQL.Add(',' + fnEkspLinierSerienumreProduktKode);
              nxqInsert.SQL.Add(',' + fnEkspLinierSerienumreSerieNr);
              nxqInsert.SQL.Add(',' + fnEkspLinierSerienumreBatchNr);
              nxqInsert.SQL.Add(',' + fnEkspLinierSerienumreUdDato);
              nxqInsert.SQL.Add(',' + fnEkspLinierSerienumreAntal);
              nxqInsert.SQL.Add(') values (');
              nxqInsert.SQL.Add(fnewlbnr.ToString);
              nxqInsert.SQL.Add(',' + nxq.FieldByName(fnEkspLinierSerienumreLinieNr).AsString);
              nxqInsert.SQL.Add(',' + AnsiQuotedStr(nxq.FieldByName(fnEkspLinierSerienumreProduktKode).AsString,''''));
              nxqInsert.SQL.Add(',' + AnsiQuotedStr(nxq.FieldByName(fnEkspLinierSerienumreSerieNr).AsString,''''));
              nxqInsert.SQL.Add(',' + AnsiQuotedStr(nxq.FieldByName(fnEkspLinierSerienumreBatchNr).AsString,''''));
              nxqInsert.SQL.Add(',' + AnsiQuotedStr(nxq.FieldByName(fnEkspLinierSerienumreUdDato).AsString,''''));
              nxqInsert.SQL.Add(',' + nxq.FieldByName(fnEkspLinierSerienumreAntal).AsString );
              nxqInsert.SQL.Add(')');
              C2LogAdd(nxqInsert.SQL.Text);
              nxqInsert.ExecSQL;

              // update the old ekspedition eksplinierserienumre entry with a Returtidspunkt

              nxqInsert.Close;
              nxqInsert.SQL.Clear;
              nxqInsert.SQL.Add('update ');
              nxqInsert.SQL.Add(tnEkspLinierSerienumre);
              nxqInsert.SQL.Add('set Returtidspunkt=current_timestamp');
              nxqInsert.SQL.Add('where');
              nxqInsert.SQL.Add(fnEkspLinierSerienumreLbNr + '=' + OldLbnr.toString);
              nxqInsert.SQL.Add('and ' + fnEkspLinierSerienumreProduktKode + '='
                + AnsiQuotedStr(nxq.FieldByName(fnEkspLinierSerienumreProduktKode).AsString, ''''));
              nxqInsert.SQL.Add('and ' + fnEkspLinierSerienumreSerieNr + '=' +
                AnsiQuotedStr(nxq.FieldByName(fnEkspLinierSerienumreSerieNr).AsString, ''''));
              nxqInsert.SQL.Add('and ' + fnEkspLinierSerienumreBatchNr + '=' +
                AnsiQuotedStr(nxq.FieldByName(fnEkspLinierSerienumreBatchNr).AsString, ''''));
              nxqInsert.SQL.Add('and ' + fnEkspLinierSerienumreUdDato + '=' +
                AnsiQuotedStr(nxq.FieldByName(fnEkspLinierSerienumreUdDato).AsString, ''''));
              c2logadd(nxqInsert.sql.text);
              nxqInsert.ExecSQL;


              AResultList.Add(
                              Format('%-8s %-20s %-14s %-20s %-20s %-8s %s',[
                                nxq.FieldByName('subvarenr').AsString,
                                copy(nxq.FieldByName('tekst').AsString,1,20),
                                  nxq.FieldByName(fnEkspLinierSerienumreProduktKode).AsString,
                                  nxq.FieldByName(fnEkspLinierSerienumreSerieNr).AsString,
                                  nxq.FieldByName(fnEkspLinierSerienumreBatchNr).AsString,
                                  nxq.FieldByName(fnEkspLinierSerienumreUdDato).AsString,
                                  'Godkendt'
                                ])
                              );

            end;

          end;
          nxq.Next;
        end;

//        // delete the entry from eksplinierserienumre
//        nxq.Close;
//        nxq.SQL.Clear;
//        nxq.SQL.Add('delete');
//        nxq.SQL.Add('from ' + tnEkspLinierSerienumre);
//        nxq.SQL.Add('where');
//        nxq.SQL.Add(fnEkspLinierSerienumreLbNr + '=' + OldLbnr.toString);
//        nxq.ExecSQL;



      finally
        nxq.Free;
        nxqInsert.Free;
      end;





    finally
      VareIdent.Free;
      Free;

    end;

  end;

end;

class function TfrmDMVS.UpdateDMVSInfo(Anxdb: TnxDatabase; ADMVSConnection : TC2DMVSSvrConnection;
  ABrugernr, AOldlbnr, ANewLbnr, ALager, Alinienr: integer; Avarenr: string;
  ATekst: string; AResultList: TStringList): boolean;
begin
  with TfrmDMVS.Create(Nil) do
  begin
    try
      Result := False;
      FNewLbnr := ANewLbnr;
      FOldLbnr := AOldlbnr;
      FLinenr := Alinienr;
      FVarenr := Avarenr;
      FnxDB := Anxdb;
      FBrugerNr := ABrugernr;
      FLager := ALager;
      FTekst := ATekst;
      FDMVSConnection := ADMVSConnection;
      FVareIdent := TC2Vareident.Create(FnxDB,Flager,'',True);
      acOpdater.Enabled := False;
      Result := ShowModal = mrOk;
      AResultList.Add(FDMVSMessage);
    finally
      VareIdent.Free;
      Free;

    end;

  end;

end;

end.
