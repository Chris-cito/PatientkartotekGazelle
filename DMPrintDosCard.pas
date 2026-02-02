unit DMPrintDosCard;

interface

uses
  System.SysUtils, System.Classes, Data.DB, nxdb, Datasnap.DBClient, RpRenderPDF, RpConDS,
  RpSystem, RpDefine, RpRave, C2MainLog,Dateutils, RpRender, RpCon, RpBase;

type
  TPrintDosCardDM = class(TDataModule)
    RaveProject1: TRvProject;
    ReportSystem1: TRvSystem;
    rpBRU: TRvDataSetConnection;
    RPDCH: TRvDataSetConnection;
    RPDCL: TRvDataSetConnection;
    RPDCP: TRvDataSetConnection;
    rpMEM: TRvDataSetConnection;
    RpRenderPDF1: TRvRenderPDF;
    MemTable1: TClientDataSet;
    MemTable1Barcode: TStringField;
    MemTable1WeekNumber: TStringField;
    MemTable1PageCount: TStringField;
    MemTable1ApotekName: TStringField;
    MemTable1DebitorNr: TStringField;
    MemTable1CardEditor: TStringField;
    MemTable1Kontroller: TStringField;
    MemTable1TlfNr: TStringField;
    MemTable1Fax: TStringField;
    MemTable1Intake1: TStringField;
    MemTable1intake2: TStringField;
    MemTable1Intake3: TStringField;
    MemTable1Intake4: TStringField;
    MemTable1Intake5: TStringField;
    MemTable1Intake6: TStringField;
    MemTable1Intake7: TStringField;
    MemTable1Intake8: TStringField;
    MemTable1PakkeApotek: TStringField;
    MemTable1Parked: TStringField;
    ffDCP: TnxTable;
    ffDCPDosiskod: TStringField;
    ffDCPDosisPeriods: TWordField;
    ffDCPPeriod1: TStringField;
    ffDCPPeriod2: TStringField;
    ffDCPPeriod3: TStringField;
    ffDCPPeriod4: TStringField;
    ffDCPPeriod5: TStringField;
    ffDCPPeriod6: TStringField;
    ffDCPPeriod7: TStringField;
    ffDCPPeriod8: TStringField;
    ffBRU: TnxTable;
    ffBRUBrugerNr: TWordField;
    ffBRUNavn: TStringField;
    ffDCL: TnxTable;
    ffDCLDrugid: TStringField;
    ffDCLRegularDose: TBooleanField;
    ffDCLDays: TStringField;
    ffDCLQuantity1: TFloatField;
    ffDCLQuantity2: TFloatField;
    ffDCLQuantity3: TFloatField;
    ffDCLQuantity4: TFloatField;
    ffDCLQuantity5: TFloatField;
    ffDCLQuantity6: TFloatField;
    ffDCLQuantity7: TFloatField;
    ffDCLQuantity8: TFloatField;
    ffDCLVareDescription: TStringField;
    ffDCLVareIndikation: TStringField;
    ffDCLVareIntake: TStringField;
    ffDCLCardNumber: TWordField;
    ffDCLVareNummer: TStringField;
    ffDCLTotalQuantity: TIntegerField;
    ffDCLKontrolled: TBooleanField;
    ffDCLtest: TStringField;
    ffDCLVareName: TStringField;
    ffDCLEjSubst: TBooleanField;
    ffDCLKlausuleret: TBooleanField;
    ffDCLRegel4243: TBooleanField;
    ffDCLAndreTilskud: TBooleanField;
    ffDCLIndikKode: TIntegerField;
    ffDCLGammeltVarenr: TStringField;
    ffDCLRetVarenrInfo: TStringField;
    ffDCLRetVareNrDato: TDateTimeField;
    ffDCLLinenumber: TIntegerField;
    ffDCLOrdid: TStringField;
    ffDCLBevilRegelNr: TIntegerField;
    ffDCLTerminalStatus: TBooleanField;
    ffDCLManOrdination: TBooleanField;
    ffDCH: TnxTable;
    ffDCHCardNumber: TWordField;
    ffDCHPatientNumber: TStringField;
    ffDCHPatientName: TStringField;
    ffDCHPatientAddress1: TStringField;
    ffDCHPatientAddress2: TStringField;
    ffDCHPostnummer: TStringField;
    ffDCHDeliveryAddress: TStringField;
    ffDCHKontaktPerson: TStringField;
    ffDCHDoctorNumber: TStringField;
    ffDCHDoctorName: TStringField;
    ffDCHTelegram: TWordField;
    ffDCHStartDate: TDateTimeField;
    ffDCHEndDate: TDateTimeField;
    ffDCHInterval: TWordField;
    ffDCHAddDate: TDateTimeField;
    ffDCHChangeDate: TDateTimeField;
    ffDCHDeleteDate: TDateTimeField;
    ffDCHPackGroupNumber: TIntegerField;
    ffDCHDoctorComment: TStringField;
    ffDCHPharmacistComment: TStringField;
    ffDCHDosiskod: TStringField;
    ffDCHSendDate: TDateTimeField;
    ffDCHAdduser: TIntegerField;
    ffDCHChangeUser: TIntegerField;
    ffDCHDeleteUser: TIntegerField;
    ffDCHKontroller: TIntegerField;
    ffDCHKontrolDate: TDateTimeField;
    ffDCHStartDay: TStringField;
    ffDCHFileReceiveDate: TDateTimeField;
    ffDCHOrderReceiveDate: TDateTimeField;
    ffDCHOrderMemo: TMemoField;
    ffDCHPackAccept: TBooleanField;
    ffDCHBemaerkMemo: TMemoField;
    ffDCHParked: TBooleanField;
    ffDCHYderCprNr: TStringField;
    ffDCHKlausuleret: TBooleanField;
    ffDCHAndreTilskud: TBooleanField;
    ffDCHLbNr: TIntegerField;
    ffDCHAutoEksp: TBooleanField;
    ffDCHTerminalStatus: TBooleanField;
    cdsUdHeader: TClientDataSet;
    cdsUdHeaderCardNumber: TWordField;
    cdsUdHeaderPatientNumber: TStringField;
    cdsUdHeaderPatientName: TStringField;
    cdsUdHeaderPatientAddress1: TStringField;
    cdsUdHeaderPatientAddress2: TStringField;
    cdsUdHeaderPostnummer: TStringField;
    cdsUdHeaderDeliveryAddress: TStringField;
    cdsUdHeaderKontaktPerson: TStringField;
    cdsUdHeaderDoctorNumber: TStringField;
    cdsUdHeaderDoctorName: TStringField;
    cdsUdHeaderTelegram: TWordField;
    cdsUdHeaderStartDate: TDateTimeField;
    cdsUdHeaderEndDate: TDateTimeField;
    cdsUdHeaderInterval: TWordField;
    cdsUdHeaderAddDate: TDateTimeField;
    cdsUdHeaderChangeDate: TDateTimeField;
    cdsUdHeaderDeleteDate: TDateTimeField;
    cdsUdHeaderPackGroupNumber: TIntegerField;
    cdsUdHeaderDoctorComment: TStringField;
    cdsUdHeaderPharmacistComment: TStringField;
    cdsUdHeaderDosiskod: TStringField;
    cdsUdHeaderSendDate: TDateTimeField;
    cdsUdHeaderAdduser: TIntegerField;
    cdsUdHeaderChangeUser: TIntegerField;
    cdsUdHeaderDeleteUser: TIntegerField;
    cdsUdHeaderKontroller: TIntegerField;
    cdsUdHeaderKontrolDate: TDateTimeField;
    cdsUdHeaderStartDay: TStringField;
    cdsUdHeaderFileReceiveDate: TDateTimeField;
    cdsUdHeaderOrderReceiveDate: TDateTimeField;
    cdsUdHeaderOrderMemo: TMemoField;
    cdsUdHeaderPackAccept: TBooleanField;
    cdsUdHeaderBemaerkMemo: TMemoField;
    cdsUdHeaderParked: TBooleanField;
    cdsUdHeaderYderCprNr: TStringField;
    cdsUdHeaderKlausuleret: TBooleanField;
    cdsUdHeaderAndreTilskud: TBooleanField;
    cdsUdLines: TClientDataSet;
    cdsUdLinesDrugid: TStringField;
    cdsUdLinesRegularDose: TBooleanField;
    cdsUdLinesDays: TStringField;
    cdsUdLinesQuantity1: TFloatField;
    cdsUdLinesQuantity2: TFloatField;
    cdsUdLinesQuantity3: TFloatField;
    cdsUdLinesQuantity4: TFloatField;
    cdsUdLinesQuantity5: TFloatField;
    cdsUdLinesQuantity6: TFloatField;
    cdsUdLinesQuantity7: TFloatField;
    cdsUdLinesQuantity8: TFloatField;
    cdsUdLinesVareDescription: TStringField;
    cdsUdLinesVareIndikation: TStringField;
    cdsUdLinesVareIntake: TStringField;
    cdsUdLinesCardNumber: TWordField;
    cdsUdLinesVareNummer: TStringField;
    cdsUdLinesTotalQuantity: TIntegerField;
    cdsUdLinesKontrolled: TBooleanField;
    cdsUdLinestest: TStringField;
    cdsUdLinesVareName: TStringField;
    cdsUdLinesEjSubst: TBooleanField;
    cdsUdLinesKlausuleret: TBooleanField;
    cdsUdLinesRegel4243: TBooleanField;
    cdsUdLinesAndreTilskud: TBooleanField;
    cdsUdLinesIndikKode: TIntegerField;
    cdsUdLinesGammeltVarenr: TStringField;
    cdsUdLinesRetVarenrInfo: TStringField;
    cdsUdLinesRetVareNrDato: TDateTimeField;
    cdsUdLinesLinenumber: TIntegerField;
    cdsUdLinesOrdid: TStringField;
    ffPat: TnxTable;
    ffPatKundeNr: TStringField;
    ffPatNavn: TStringField;
    ffPatAdr1: TStringField;
    ffPatAdr2: TStringField;
    ffPatPostNr: TStringField;
    ffPatYderNr: TStringField;
    ffPatAmt: TWordField;
    ffPatBarn: TBooleanField;
    ffPatDebitorNr: TStringField;
    ffPatYderCprNr: TStringField;
    ffFirm: TnxTable;
    ffFirmNavn: TStringField;
    ffFirmTlfNr: TStringField;
    ffFirmTelefax: TStringField;
    ffDCPARAMS: TnxTable;
    ffDCPARAMSKuvertnr: TIntegerField;
    ffDCPARAMSBrevNr: TIntegerField;
    ffDCPARAMSAfsLok: TStringField;
    ffDCPARAMSAfsIdentifikation: TStringField;
    ffDCPARAMSAfSenderNavn: TStringField;
    ffDCPARAMSModtLok: TStringField;
    ffDCPARAMSModtIdentifikation: TStringField;
    ffDCPARAMSModtagerNavn: TStringField;
    ffDCPARAMSUdlevApoNr: TStringField;
    ffDCPARAMSDAServerUser: TStringField;
    ffDCPARAMSDAServerPass: TStringField;
    ffDCPARAMSPrintPages: TIntegerField;
    ffLag: TnxTable;
    ffLagLager: TWordField;
    ffLagVareNr: TStringField;
    ffLagDrugId: TStringField;
    ffLagNavn: TStringField;
    ffLagForm: TStringField;
    ffLagStyrke: TStringField;
  private
    { Private declarations }
    procedure calculate_total;
  public
    { Public declarations }
    procedure printcard(  sl: TStringList;  sortlist : boolean; PdfFile : boolean;
                          ExtendedBemaerk : boolean; LandscapePrint : boolean;
                          PrintCopies: integer; nxSession : TnxSession);
  end;

var
  PrintDosCardDM: TPrintDosCardDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
uses C2Procs,C2PrinterSelection;

{$R *.dfm}
procedure TPrintDosCardDM.calculate_total;
var
  tmpstr : string;
  qu1 : integer;
  qu2 : integer;
  dotpos :integer;
begin
  FormatSettings.DecimalSeparator := ',';
  tmpstr := format('%6.2f',[ffDCLQuantity1.AsFloat]);
  dotpos := pos(',',tmpstr);
  qu1 := strtoint(copy(tmpstr,1,dotpos-1));
  qu2 := strtoint(copy(tmpstr,dotpos+1,2));
  ffDCLTotalQuantity.AsInteger := qu1 ;
  if qu2 <> 0 then
          ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + 1;
  tmpstr := format('%6.2f',[ffDCLQuantity2.AsFloat]);
  dotpos := pos(',',tmpstr);
  qu1 := strtoint(copy(tmpstr,1,dotpos-1));
  qu2 := strtoint(copy(tmpstr,dotpos+1,2));
  ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + qu1 ;
  if qu2 <> 0 then
          ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + 1;
  tmpstr := format('%6.2f',[ffDCLQuantity3.AsFloat]);
  dotpos := pos(',',tmpstr);
  qu1 := strtoint(copy(tmpstr,1,dotpos-1));
  qu2 := strtoint(copy(tmpstr,dotpos+1,2));
  ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + qu1 ;
  if qu2 <> 0 then
          ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + 1;
  tmpstr := format('%6.2f',[ffDCLQuantity4.AsFloat]);
  dotpos := pos(',',tmpstr);
  qu1 := strtoint(copy(tmpstr,1,dotpos-1));
  qu2 := strtoint(copy(tmpstr,dotpos+1,2));
  ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + qu1 ;
  if qu2 <> 0 then
          ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + 1;
  tmpstr := format('%6.2f',[ffDCLQuantity5.AsFloat]);
  dotpos := pos(',',tmpstr);
  qu1 := strtoint(copy(tmpstr,1,dotpos-1));
  qu2 := strtoint(copy(tmpstr,dotpos+1,2));
  ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + qu1 ;
  if qu2 <> 0 then
          ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + 1;
  tmpstr := format('%6.2f',[ffDCLQuantity6.AsFloat]);
  dotpos := pos(',',tmpstr);
  qu1 := strtoint(copy(tmpstr,1,dotpos-1));
  qu2 := strtoint(copy(tmpstr,dotpos+1,2));
  ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + qu1 ;
  if qu2 <> 0 then
          ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + 1;
  tmpstr := format('%6.2f',[ffDCLQuantity7.AsFloat]);
  dotpos := pos(',',tmpstr);
  qu1 := strtoint(copy(tmpstr,1,dotpos-1));
  qu2 := strtoint(copy(tmpstr,dotpos+1,2));
  ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + qu1 ;
  if qu2 <> 0 then
          ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + 1;
  tmpstr := format('%6.2f',[ffDCLQuantity8.AsFloat]);
  dotpos := pos(',',tmpstr);
  qu1 := strtoint(copy(tmpstr,1,dotpos-1));
  qu2 := strtoint(copy(tmpstr,dotpos+1,2));
  ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + qu1 ;
  if qu2 <> 0 then
          ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger + 1;
  if ffDCLRegularDose.AsBoolean then
  begin

        ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger *
            ffDCHInterval.AsInteger;
  end
  else
  begin
    tmpstr := ffDCLDays.AsString;
    qu1 := 1;
    for qu2 := 1 to length(tmpstr) do
    begin
      if tmpstr[qu2] = ',' then
        qu1 := qu1 + 1;
    end;
    ffDCLTotalQuantity.AsInteger := ffDCLTotalQuantity.AsInteger *
        qu1;



  end;

end;

procedure TPrintDosCardDM.printcard(  sl: TStringList;  sortlist : boolean; PdfFile : boolean;
                          ExtendedBemaerk : boolean; LandscapePrint : boolean;
                          PrintCopies: integer; nxSession : TnxSession);
var
  i : integer;
  pagecount : integer;
  maxlines : integer;
  intakes : array[1..8] of integer;
  regintakes : array[1..8] of Boolean;
  lasttext : string;
  savecard : string;
  StdPrintPrn : string;
  StdprintBin : string;
  PrintWait : integer;
  procedure OpenTables;
  var
    cmp : TComponent;
    nxt : TnxTable;
  begin
    with MainLog do
    begin
      try
        C2LogAdd ('Dosiskort change aliases');
        for cmp in PrintDosCardDM do
        begin
          if cmp is TnxTable then
          begin
            // Åben kun primære tabeller - benyttes i nogle programmer
            // til forbindelser mod afdelinger
            nxt := (cmp as TnxTable);
            nxt.Session := nxSession;
            nxt.AliasName := 'Produktion';
            nxt.Open;
          end;
        end;

        C2LogAdd ('all fftables are open');
      finally
        C2LogSave;
      end;
    end;

  end;
  procedure CloseTables;
  var
    cmp : TComponent;
    nxt : TnxTable;
  begin
    with MainLog do
    begin
      try
        for cmp in PrintDosCardDM do
        begin
          if cmp is TnxTable then
          begin
            // Åben kun primære tabeller - benyttes i nogle programmer
            // til forbindelser mod afdelinger
            nxt := (cmp as TnxTable);
            nxt.Close;
          end;
        end;

        C2LogAdd ('all fftables are Closed');
      finally
        C2LogSave;
      end;
    end;

  end;

  procedure createCDSCopys;
  var
    fld : TField;
    fldname : string;
  begin

      cdsUdHeader.Open;
      cdsUdHeader.EmptyDataSet;
      cdsUdHeader.Append;
      for fld in cdsUdHeader.Fields do
      begin
        fldname := fld.FieldName;
        cdsUdHeader.FieldByName(fldname).Value := ffDCH.FieldByName(fldname).Value;
      end;
      cdsUdHeader.Post;

      cdsUdLines.Open;
      cdsUdLines.EmptyDataSet;
      ffdcl.DisableControls;
      try
        ffDCL.First;
        while not ffdcl.Eof do
        begin
          if ffDCLCardNumber.AsInteger = ffDCHCardNumber.AsInteger then
          begin
            cdsUdLines.Append;
            for fld in cdsUdLines.Fields do
            begin
              fldname := fld.FieldName;
              cdsUdLines.FieldByName(fldname).Value := ffDCL.FieldByName(fldname).Value;
            end;
            cdsUdLines.Post;
          end;
          ffdcl.Next;
        end;
      finally
        ffdcl.EnableControls;
      end;


  end;
begin

  if sl.Count = 0 then
    exit;
  OpenTables;
  try
    if sortlist then
      sl.Sort;
    savecard := '';
    for lasttext in sl do
    begin
      if savecard = lasttext then
        continue;
      savecard := lasttext;
      c2logadd('Print Cardnumber is ' + lasttext);
      ffdch.IndexName := 'CardNumber';
      if not ffDCH.FindKey([strtoint(lasttext)]) then
        continue;

      ffDCP.IndexName := 'Dosiskod';

      if not ffDCP.FindKey([ffDCHDosiskod.AsString]) then
        continue;

      StdPrintPrn  := C2StrPrm('Systemprinter','Printer'              ,'');
      StdPrintBin  := C2StrPrm('Systemprinter','Bakke'                ,'');
      StdPrintPrn  := C2StrPrm(C2SysUserName  ,'Standardprinter'      ,StdPrintPrn);
      StdPrintBin  := C2StrPrm(C2SysUserName  ,'Standardbakke'        ,StdPrintBin);
      StdPrintPrn  := C2StrPrm(C2SysUserName  ,'DosisPrinter'      ,StdPrintPrn);
      StdPrintBin  := C2StrPrm(C2SysUserName  ,'DosisBakke'        ,StdPrintBin);
      PrintWait := C2IntPrm('Dosiskort','UdskrivPause',0) * 1000;

      if StdPrintPrn <> '' then
        C2SelectPrinter(StdPrintPrn,ReportSystem1,'Dosiskort ' + lasttext);
      if StdPrintBin <> '' then
        C2SelectBin(StdPrintBin);

      // if the number of periods on the card then always select a landscape
      // report
      if ffDCPDosisPeriods.AsInteger > 6 then
      begin
        RaveProject1.SelectReport('Report3', False);
        if ExtendedBemaerk then
          RaveProject1.SelectReport('Report6', False);
        maxlines := 6;
      end
      else
      begin
        if LandscapePrint then
        begin
          RaveProject1.SelectReport('Report3', False);
          if ExtendedBemaerk then
            RaveProject1.SelectReport('Report6', False);
          maxlines := 6;
        end
        else
        begin
          RaveProject1.SelectReport('Report5', False); // 5 BEFORE
          if ExtendedBemaerk then
            RaveProject1.SelectReport('Report4', False);
          maxlines := 8;
        end;

      end;

      if PdfFile then
      begin
        ReportSystem1.DefaultDest := rdFile;
        ReportSystem1.DoNativeOutput := FALSE;
        ReportSystem1.RenderObject := RPRenderPDF1;
        ForceDirectories('C:\C2\Dosiskort');
        ReportSystem1.OutputFileName := 'C:\C2\Dosiskort\kort' +
            format('%4.4d',[ffdchcardnumber.asinteger]) +'.pdf';
        ReportSystem1.SystemSetups := ReportSystem1.SystemSetups - [ssAllowSetup];
    //    ReportSystem1.SystemSetus := ReportSystem1.SystemSetups - ];
      end;

      ffPat.IndexName := 'NrOrden';

      if not ffPat.FindKey([ffDCHPatientNumber.AsString]) then
        Continue;


      // change printed order of cards

      ffDCL.IndexName := 'cardvaren';
      ffdcl.SetRange([ffdchcardnumber.AsInteger],[ffdchcardnumber.AsInteger]);
      i := ffDCL.RecordCount;
      if i mod maxlines = 0 then
        i := i div maxlines
      else
        i := (i div maxlines) + 1;

      ffFirm.First;

      MemTable1.Open;
      MemTable1.EmptyDataSet;
      MemTable1.Insert;
      MemTable1Barcode.AsString := '9600' +
        format('%8.8d',[ffDCHCardNumber.AsInteger]);
      MemTable1Weeknumber.AsString := inttostr(WeekOfTheYear(ffDCHStartDate.AsDateTime));
      MemTable1PageCount.AsString := IntToStr(i);
      MemTable1ApotekName.AsString := ffFirmNavn.AsString;
      MemTable1TlfNr.AsString := ffFirmTlfNr.AsString;
      MemTable1Fax.AsString := ffFirmTelefax.AsString;
      MemTable1DebitorNr.AsString := '';
      if ffPatDebitorNr.AsString <> '' then
        MemTable1DebitorNr.AsString := ' - ' + ffPatDebitorNr.AsString;
      ffBRU.IndexName := 'NrOrden';
      if ffDCHChangeDate.AsString <> '' then
      begin
        if ffBRU.FindKey([ffDCHChangeUser.Asinteger]) then
          MemTable1CardEditor.AsString := ffBRUNavn.AsString;

      end
      else
      begin
        if ffBRU.FindKey([ffDCHAdduser.Asinteger]) then
          MemTable1CardEditor.AsString := ffBRUNavn.AsString;
      end;
      MemTable1Kontroller.AsString := '';

      if ffDCHKontroller.AsInteger <> 0 then
      begin
        ffBRU.IndexName := 'NrOrden';
        if ffBRU.FindKey([ffDCHKontroller.AsInteger])  then
            MemTable1Kontroller.AsString := ffBRUNavn.AsString;
      end;

      ffDCPARAMS.first;
      MemTable1PakkeApotek.AsString := 'Pakkes på ' + ffDCPARAMSModtagerNavn.AsString;
      if ffDCHParked.AsBoolean then
        MemTable1Parked.AsString := 'Parkeret'
      else
        MemTable1Parked.AsString := 'Aktivt';

      //total each period

      for i:= 1 to 8 do
      begin
        intakes[i] := 0;
        regintakes[i] := True;
      end;
      ffdcl.DisableControls;
      try
        ffdcl.First;
        while not ffdcl.Eof do
        begin
          c2logadd('dclvarenr is ' + ffDCLVareNummer.AsString);
          ffdcl.Edit;
          // caps the intake description and indikation fields
          ffDCLVareIntake.AsString := caps(ffDCLVareIntake.AsString);
          ffDCLVareDescription.AsString := Caps(ffDCLVareDescription.AsString);
          ffDCLVareIndikation.AsString := Caps(ffDCLVareIndikation.AsString);
          // upDATE THE product text from lager kartotek

          ffLag.IndexName := 'NrOrden';

          if ffLag.FindKey([0,ffDCLVareNummer.AsString]) then
          begin
            ffDCLVareName.AsString := caps(ffLagNavn.AsString) + ' ' +
                  caps(ffLagStyrke.AsString) + ' ' + caps(ffLagForm.AsString);
                c2logadd('3: updating drugid ' + ffLagDrugId.AsString);
            ffDCLDrugid.AsString := ffLagDrugId.AsString;
          end;

          calculate_total;
          ffDCL.Post;

          if (ffDCLQuantity1.AsFloat <> 0) then
          begin
            if ffDCLRegularDose.AsBoolean then
              intakes[1] := intakes[1] + ffDCLQuantity1.AsInteger;
            if ffDCLQuantity1.AsInteger < ffDCLQuantity1.AsFloat then
              intakes[1] := intakes[1] + 1;
            if not ffDCLRegularDose.AsBoolean then
              regintakes[1] := False;
          end;
          if (ffDCLQuantity2.AsFloat <> 0) then
          begin
            if ffDCLRegularDose.AsBoolean then
              intakes[2] := intakes[2] + ffDCLQuantity2.AsInteger;
            if ffDCLQuantity2.AsInteger < ffDCLQuantity2.AsFloat then
              intakes[2] := intakes[2] + 1;
            if not ffDCLRegularDose.AsBoolean then
              regintakes[2] := False;
          end;
          if (ffDCLQuantity3.AsFloat <> 0) then
          begin
            if ffDCLRegularDose.AsBoolean then
              intakes[3] := intakes[3] + ffDCLQuantity3.AsInteger;
            if ffDCLQuantity3.AsInteger < ffDCLQuantity3.AsFloat then
              intakes[3] := intakes[3] + 1;
            if not ffDCLRegularDose.AsBoolean then
              regintakes[3] := False;
          end;
          if (ffDCLQuantity4.AsFloat <> 0) then
          begin
            if ffDCLRegularDose.AsBoolean then
              intakes[4] := intakes[4] + ffDCLQuantity4.AsInteger;
            if ffDCLQuantity4.AsInteger < ffDCLQuantity4.AsFloat then
              intakes[4] := intakes[4] + 1;
            if not ffDCLRegularDose.AsBoolean then
              regintakes[4] := False;
          end;
          if (ffDCLQuantity5.AsFloat <> 0) then
          begin
            if ffDCLRegularDose.AsBoolean then
              intakes[5] := intakes[5] + ffDCLQuantity5.AsInteger;
            if ffDCLQuantity5.AsInteger < ffDCLQuantity5.AsFloat then
              intakes[5] := intakes[5] + 1;
            if not ffDCLRegularDose.AsBoolean then
              regintakes[5] := False;
          end;
          if (ffDCLQuantity6.AsFloat <> 0) then
          begin
            if ffDCLRegularDose.AsBoolean then
              intakes[6] := intakes[6] + ffDCLQuantity6.AsInteger;
            if ffDCLQuantity6.AsInteger < ffDCLQuantity6.AsFloat then
              intakes[6] := intakes[6] + 1;
            if not ffDCLRegularDose.AsBoolean then
              regintakes[6] := False;
          end;
          if (ffDCLQuantity7.AsFloat <> 0) then
          begin
            if ffDCLRegularDose.AsBoolean then
              intakes[7] := intakes[7] + ffDCLQuantity7.AsInteger;
            if ffDCLQuantity7.AsInteger < ffDCLQuantity7.AsFloat then
              intakes[7] := intakes[7] + 1;
            if not ffDCLRegularDose.AsBoolean then
              regintakes[7] := False;
          end;
          if (ffDCLQuantity8.AsFloat <> 0) then
          begin
            if ffDCLRegularDose.AsBoolean then
              intakes[8] := intakes[8] + ffDCLQuantity8.AsInteger;
            if ffDCLQuantity8.AsInteger < ffDCLQuantity8.AsFloat then
              intakes[8] := intakes[8] + 1;
            if not ffDCLRegularDose.AsBoolean then
              regintakes[8] := False;
          end;
          ffdcl.Next;
        end;
      finally
        ffdcl.EnableControls;
      end;
      // build intake totals for print
      MemTable1Intake1.AsString := '';
      if intakes[1] <>0 then
      begin
        MemTable1Intake1.AsString := inttostr(intakes[1]);
        if not regintakes[1] then
          MemTable1Intake1.AsString := inttostr(intakes[1]) + ' *';
      end;
      MemTable1Intake2.AsString := '';
      if intakes[2] <>0 then
      begin
        MemTable1Intake2.AsString := inttostr(intakes[2]);
        if not regintakes[2] then
          MemTable1Intake2.AsString := inttostr(intakes[2]) + ' *';
      end;
      MemTable1Intake3.AsString := '';
      if intakes[3] <>0 then
      begin
        MemTable1Intake3.AsString := inttostr(intakes[3]);
        if not regintakes[3] then
          MemTable1Intake3.AsString := inttostr(intakes[3]) + ' *';
      end;
      MemTable1Intake4.AsString := '';
      if intakes[4] <>0 then
      begin
        MemTable1Intake4.AsString := inttostr(intakes[4]);
        if not regintakes[4] then
          MemTable1Intake4.AsString := inttostr(intakes[4]) + ' *';
      end;
      MemTable1Intake5.AsString := '';
      if intakes[5] <>0 then
      begin
        MemTable1Intake5.AsString := inttostr(intakes[5]);
        if not regintakes[5] then
          MemTable1Intake5.AsString := inttostr(intakes[5]) + ' *';
      end;
      MemTable1Intake6.AsString := '';
      if intakes[6] <>0 then
      begin
        MemTable1Intake6.AsString := inttostr(intakes[6]);
        if not regintakes[6] then
          MemTable1Intake6.AsString := inttostr(intakes[6]) + ' *';
      end;
      MemTable1Intake7.AsString := '';
      if intakes[7] <>0 then
      begin
        MemTable1Intake7.AsString := inttostr(intakes[7]);
        if not regintakes[7] then
          MemTable1Intake7.AsString := inttostr(intakes[7]) + ' *';
      end;
      MemTable1Intake8.AsString := '';
      if intakes[8] <>0 then
      begin
        MemTable1Intake8.AsString := inttostr(intakes[8]);
        if not regintakes[8] then
          MemTable1Intake8.AsString := inttostr(intakes[8]) + ' *';
      end;


      MemTable1.Post;
      MemTable1.First;
      pagecount := PrintCopies;
      if PrintCopies = 1 then
      begin
        try
          ffDCPARAMS.First;
          pagecount := ffDCPARAMS.Fieldbyname('PrintPages').AsInteger;
          if pagecount = 0 then
            pagecount := 1;
        except
          pagecount := 1;
        end;
      end;
  //    RPDev.Copies := pagecount;
  //    rpPrint.Copies := pagecount;
      try
        ffDCH.IndexName := 'CardNumber';
        ffdcl.IndexName := 'Cardprod';
        if not PDFFile then
          ReportSystem1.DefaultDest  := rdPrinter;
        ffDCH.SetRange([ffDCLCardNumber.AsInteger],[ffDCLCardNumber.AsInteger]);
        ffDCL.SetRange([ffDCHCardNumber.AsInteger],[ffDCHCardNumber.AsInteger]);
        ReportSystem1.SystemSetups := ReportSystem1.SystemSetups -
                [ssAllowSetup,ssAllowDestPreview];
        ReportSystem1.SystemOptions := ReportSystem1.SystemOptions -[soShowStatus];
        createCDSCopys;
        RaveProject1.Open;
        try
          for i := 1 to pagecount do
            RaveProject1.Execute;
        finally
          RaveProject1.Close;
        end;
        if PrintWait <> 0 then
          Sleep(PrintWait);
      finally
        ffDCH.CancelRange;
        ReportSystem1.DefaultDest := rdPreview;
        ReportSystem1.DoNativeOutput := True;
        ReportSystem1.SystemSetups := ReportSystem1.SystemSetups + [ssAllowSetup];
        ReportSystem1.SystemOptions := ReportSystem1.SystemOptions + [soShowStatus];
      end;
      MemTable1.Close;
    end;
  finally
    CloseTables;
  end;

end;

end.
