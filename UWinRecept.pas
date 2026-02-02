Unit UWinRecept;

{ ØNSKER                                               }
{ - Dataopsamling i FDD-fil}
{ - Datafejl x udskriver med fejlbeskrivelse på recept }
{ - Ønske om akkumuleret statistik i ff fil dd, mm, åå }

Interface

Uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Menus,
  ShellApi, Gauges, IniFiles,
  FileCtrl, Mask, Grids, UPrevInst,
  DBGrids, AdPort, Winshoes, WinshoeMessage, Pop3Winshoe, Psock, NMpop3;

Type
  TFormRecept = Class(TForm)
    Minut : TTimer;
    PageControl1 : TPageControl;
    TabModtag : TTabSheet;
    TabOversigt : TTabSheet;
    DBGrid1 : TDBGrid;
    Panel21 : TPanel;
    ButOversigt : TButton;
    OpenDialog1 : TOpenDialog;
    ButUdskriv : TButton;
    ButVisInfo : TButton;
    OpenDialog2 : TOpenDialog;
    ButTestPrint : TButton;
    ButInfoFiler : TButton;
    OpenDialog3 : TOpenDialog;
    ButDanKvit : TButton;
    PopupMenu1 : TPopupMenu;
    VerMenu : TMenuItem;
    Panel12 : TPanel;
    ButModtag : TButton;
    ButLogfil : TButton;
    Panel11 : TPanel;
    Panel13 : TPanel;
    Label11 : TLabel;
    Label14 : TLabel;
    Label13 : TLabel;
    Label12 : TLabel;
    Label15 : TLabel;
    IniMenu : TMenuItem;
    EditMenu : TMenuItem;
    Memo11 : TMemo;
    Label1 : TLabel;
    Label2 : TLabel;
    Label18 : TLabel;
    Label19 : TLabel;
    Label20 : TLabel;
    Label16 : TLabel;
    Label17 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    Label5 : TLabel;
    Label21 : TLabel;
    Label7 : TLabel;
    Label22 : TLabel;
    Panel2 : TPanel;
    Panel1 : TPanel;
    Label8 : TLabel;
    Label9 : TLabel;
    Label10 : TLabel;
    Label23 : TLabel;
    Label24 : TLabel;
    Label25 : TLabel;
    Label26 : TLabel;
    Label27: TLabel;
    Label28: TLabel;
    POP3: TNMPOP3;
    Label29: TLabel;
    ButVers: TButton;
    Procedure MinutTimer(Sender : TObject);
    Procedure FormCloseQuery(Sender : TObject; Var CanClose : Boolean);
    Procedure FormKeyDown(Sender : TObject; Var Key : Word; Shift : TShiftState);
    Procedure FormShow(Sender : TObject);
    Procedure CheckSletteDato;
    Procedure CheckFilKonvertering;
    Procedure CheckStatistik;
    Procedure CheckIndmappe;
    Procedure WriteLog(IMsg : String);
    Procedure HentOversigt(INvn : String);
    Function SplitFile(INvn : String) : Integer;
    Function ExecTranslate(INvn, UNvn : String) : Integer;
    Procedure HentRecepter;
    Procedure SendKvitteringer;
    Procedure CheckKontrol;
    Procedure BehandlIndmappe;
    Procedure SplitEdifact;
    Procedure UdskrivRecepter(GlDir : Boolean);
    Procedure CheckSekvens;
    Procedure InitComPort;
    Procedure RetOversigt(IRNo : Word; ISta : String; IUds : Word);
    Function  ReadByNavn(IPNr : String) : String;
    Procedure UdskrivRecept(FNr, RNr : Word; INvn : String; ILast : Boolean);
    Procedure PageControl1Enter(Sender : TObject);
    Procedure ButModtagClick(Sender : TObject);
    Procedure ButOversigtClick(Sender : TObject);
    Procedure ButUdskrivClick(Sender : TObject);
    Procedure ButVisInfoClick(Sender : TObject);
    Procedure ButTestPrintClick(Sender : TObject);
    Procedure ButLogfilClick(Sender : TObject);
    Procedure ButInfoFilerClick(Sender : TObject);
    Procedure ButDanKvitClick(Sender : TObject);
    Procedure DBGrid1TitleClick(Column : TColumn);
    Procedure TabOversigtEnter(Sender : TObject);
    Procedure FormDestroy(Sender : TObject);
    Procedure VerMenuClick(Sender : TObject);
    Procedure IniMenuClick(Sender : TObject);
    Procedure EditMenuClick(Sender : TObject);
    Procedure DBGrid1DrawColumnCell(Sender : TObject; Const Rect : TRect;
      DataCol : Integer; Column : TColumn; State : TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure POPConnect(Sender: TObject);
    procedure TabOversigtExit(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure ButVersClick(Sender: TObject);
  private
    { Private declarations }
    ComPort : TApdComPort;
  public
    { Public declarations }
  End;

Var
  FormRecept : TFormRecept;
//  ProcessInfo : TProcessInformation;

Implementation

Uses
  ChkBoxes,
  DWinRecept,
  UC2Procs,
  C2WinApi,
  UC2Date,
  UFilInfo,
  UVersionsInfo,
  UIniFile,
  UPassword;

{$R *.DFM}

Const
  ProgCaption = 'Receptmodtagelse';
  StartDir = '\Edi\Recept';
  IniFileName = 'WinRecept.Ini';
  UNB = 1;
  UNH = 2;
  BGM = 3;
  BRN = 4;
  CTA = 5;
  FTX = 6;
  GEN = 7;
  IMD = 8;
  NAD = 9;
  TSK = 10;
  PDI = 15;
  DTM = 21;
  PNA = 22;
  ADR = 23;
  COM = 24;
  SPR = 25;
  QUA = 26;
  EMP = 27;
  RFF = 28;
  ICD = 29;
  INP = 30;
  GIS = 31;
  CCI = 32;
  LIN = 33;
  MEA = 34;
  PGI = 35;
  QTY = 36;
  ALC = 37;
  CIN = 38;
  EQN = 39;
  DSG = 40;
  TOD = 41;
  UNT = 49;
  UNZ = 50;
  NOS = 99;

Type {Gammelt .INF-format, til brug for evt. konvertering af recordstørrelser
      }
  TFilRecOld = Record         { Information til Filoversigt    }
    Afsender : String[13];    { Afsender lokationsnr           }
    YderNavn : String[70];    { Navn på afsender               }
    EDBsystem : String[35];   { Afsenders systemnavn           }
    MeddID : String[14];      { Meddelelsesnr                  }
    VersNr : Word;            { Versionsnr for database        }
    AfsDato : TDateTime;      { Afsenderdato                   }
    Modtager : String[13];    { Modtager lokationsnr           }
    FilNavn : String[20];     { Modtagefilnavn                 }
    RcpFormat : String[6];    { MEDPRE/RECEPT                  }
    FilNr : Word;             { Internt fil løbenr             }
    RcpAntal : Word;          { Antal recepter i filen         }
    ModtDato : TDateTime;     { Modtagedato fra filnavn        }
    ModtStatus : String[15];  { Modtaget/Konverteret/Fejl XX   }
    KvitDato : TDateTime;     { Kvitteringsdato                }
    KvitStatus : String[15];  { Kvitteret/Afsendt              }
  End;

  TFilRec = Record            { Information til Filoversigt    }
    Afsender : String[13];    { Afsender lokationsnr           }
    YderNavn : String[70];    { Navn på afsender               }
    EDBsystem : String[35];   { Afsenders systemnavn           }
    MeddID : String[14];      { Meddelelsesnr                  }
    VersNr : Word;            { Versionsnr for database        }
    AfsDato : TDateTime;      { Afsenderdato                   }
    Modtager : String[13];    { Modtager lokationsnr           }
    FilNavn : String[20];     { Modtagefilnavn                 }
    RcpFormat : String[6];    { MEDPRE/RECEPT                  }
    FilNr : Word;             { Internt fil løbenr             }
    RcpAntal : Word;          { Antal recepter i filen         }
    ModtDato : TDateTime;     { Modtagedato fra filnavn        }
    ModtStatus : String[15];  { Modtaget/Konverteret/Fejl XX   }
    KvitDato : TDateTime;     { Kvitteringsdato                }
    KvitStatus : String[15];  { Kvitteret/Afsendt              }
  //  FejlType : String[15];    {Fejlbehæftetrecept tilføjet 16.08.1999 AH }
  //  FejlKvitSvar : String[15]; {Fejlbehæftetrecept tilføjet 16.08.1999 AH }
  End;

  TRcpRec = Record            { Information til Receptoversigt }
    RcpStatus : String[15];   { Modtaget/Udskrevet/Fejl XX     }
    UdsAntal : Word;          { Udskrevet antal gange          }
    OrdAntal : Word;          { Antal ordinationer             }
    RcpType : String[15];     { Original/Annullering           }
    YderNr : String[7];       { Ydernr på afsender             }
    YderNavn : String[70];    { Navn på afsender               }
    PatCprNr : String[11];    { Cprnr på receptmodtager        }
    PatNavn : String[70];     { Navn på receptmodtager         }
    FilNr : Word;             { Internt fil løbenr             }
    RcpNr : Word;             { Internt recept løbenr          }
    RcpID : String[14];       { Recept meddelelsesnr           }
  End;

  TStr100 = String[100];
  TRcpSide = Array[1..68] Of TStr100;
{(*} //Udelad sourceformatering efter denne linie
Var
  HentProg, SendProg,
  ReceptDir, KontrolDir, FejlfilDir, LogfilDir, InformationDir,
  UbehandletDir, BehandletDir, OversigtDir,
  Indmappe, Udmappe, KopiIndmappe, KopiUdmappe,
  LogVisning,
  ApoteksNavn,
  OvsDato,
  Konverter,
  PrinterPort,
  EkstraSide, Oversigt_Dir : String;
  Oversigt_OK : Boolean;
  FilLbNr, ReceptLbNr : LongInt;
  MailAntal : Integer;
  SorteretKolonne,
  UdskriftPause,
  SletteDage,
  StatistikDage,
  VenstreMargin,
  TopMargin,
  FormularHjd,
  TxtLbNr, DosLbNr, FriLbNr, ReceptFejl : Word;
 {*)}//Annullér Udelukkelse sourceformatering efter denne linie

{$I uwinrecept.inc}

Function EdifactSegment(S : String) : Word;
Begin
  EdifactSegment := NOS;
  If S = 'UNB' Then EdifactSegment := UNB;
  If S = 'UNH' Then EdifactSegment := UNH;
  If S = 'BGM' Then EdifactSegment := BGM;
  If S = 'BRN' Then EdifactSegment := BRN;
  If S = 'CTA' Then EdifactSegment := CTA;
  If S = 'FTX' Then EdifactSegment := FTX;
  If S = 'GEN' Then EdifactSegment := GEN;
  If S = 'IMD' Then EdifactSegment := IMD;
  If S = 'NAD' Then EdifactSegment := NAD;
  If S = 'TSK' Then EdifactSegment := TSK;
  If S = 'DTM' Then EdifactSegment := DTM;
  If S = 'PNA' Then EdifactSegment := PNA;
  If S = 'PDI' Then EdifactSegment := PDI;
  If S = 'ADR' Then EdifactSegment := ADR;
  If S = 'COM' Then EdifactSegment := COM;
  If S = 'SPR' Then EdifactSegment := SPR;
  If S = 'QUA' Then EdifactSegment := QUA;
  If S = 'EMP' Then EdifactSegment := EMP;
  If S = 'RFF' Then EdifactSegment := RFF;
  If S = 'ICD' Then EdifactSegment := ICD;
  If S = 'INP' Then EdifactSegment := INP;
  If S = 'GIS' Then EdifactSegment := GIS;
  If S = 'CCI' Then EdifactSegment := CCI;
  If S = 'LIN' Then EdifactSegment := LIN;
  If S = 'MEA' Then EdifactSegment := MEA;
  If S = 'PGI' Then EdifactSegment := PGI;
  If S = 'QTY' Then EdifactSegment := QTY;
  If S = 'ALC' Then EdifactSegment := ALC;
  If S = 'CIN' Then EdifactSegment := CIN;
  If S = 'EQN' Then EdifactSegment := EQN;
  If S = 'DSG' Then EdifactSegment := DSG;
  If S = 'TOD' Then EdifactSegment := TOD;
  If S = 'UNT' Then EdifactSegment := UNT;
  If S = 'UNZ' Then EdifactSegment := UNZ;
End;

Function GetSegment(S : String) : String;
Var
  W : String;
  P : Word;
Begin
  P := Pos(#1, S);
  W := Copy(S, 1, P - 1);
  GetSegment := W;
End;

Function GetToken(N : Word; S : String) : String;
Var
  W : String;
  P,
    Q : Integer;
Begin
  For Q := 1 To N + 1 Do
  Begin
    P := Pos(#1, S);
    W := Copy(S, 1, P - 1);
    Delete(S, 1, P);
  End;
  GetToken := W;
End;

Procedure TFormRecept.HentOversigt(INvn : String);
Var                           {Hent oversigt af anden dato og vis den i grid}
  InfNvn, OvsNvn : String;
  OvsRec : TRcpRec;
  OvsAnt : Word;
  OvsHdl : File Of TRcpRec;
  InfRec : TFilRec;
  InfHdl : File Of TFilRec;
Begin With ReceptData Do
  Begin
    mtOvs.Active := False;
    mtOvs.Active := True;
    mtOvs.DisableControls;
    If INvn <> '' Then
    Begin
      OvsNvn := INvn;
      OvsDato := ExtractFileName(OvsNvn);
      OvsDato := Copy(OvsDato, 1, Length(OvsDato) - 4);
    End
    Else
      OvsNvn := OversigtDir + '\' + LogDate + '.Ovs';
    If FileExists(OvsNvn) Then
    Begin
      AssignFile(OvsHdl, OvsNvn);
      Reset(OvsHdl);
      For OvsAnt := 1 To FileSize(OvsHdl) Do
      Begin
        Read(OvsHdl, OvsRec);
        With OvsRec Do
        Begin
          InfNvn := InformationDir + '\' + IntToStr(FilNr) + '.Fif';
          If FileExists(InfNvn) Then
          Begin
            AssignFile(InfHdl, InfNvn);
            Reset(InfHdl);
            Read(InfHdl, InfRec);
            CloseFile(InfHdl);
            mtOvs.Append;
            mtOvsRcpStatus.Value := RcpStatus;
            mtOvsUdsAntal.Value := UdsAntal;
            mtOvsOrdAntal.Value := OrdAntal;
            mtOvsRcpType.Value := RcpType;
            mtOvsYderNr.Value := YderNr;
            mtOvsYderNavn.Value := YderNavn;
            mtOvsPatCprNr.Value := PatCprNr;
            mtOvsPatNavn.Value := PatNavn;
            mtOvsFilNr.Value := FilNr;
            mtOvsRcpNr.Value := RcpNr;
            mtOvsRcpID.Value := RcpID;
            mtOvsRcpDagNr.Value := OvsAnt;
            mtOvsModtDato.Value := InfRec.ModtDato;
            mtOvsRcpFormat.Value := InfRec.RcpFormat;
            mtOvs.Post;
          End;
        End;
      End;
      CloseFile(OvsHdl);
    End;
    mtOvs.EnableControls;
    mtOvs.Refresh;
    mtOvs.First;
    SorteretKolonne := 0;
  End;
End;

Procedure TFormRecept.CheckStatistik;
Var
  OvsRec : TRcpRec;
  OvsHdl : File Of TRcpRec;
  InfRec : TFilRec;
//  InfRecOld : TFilRecOld;
  InfHdl : File Of TFilRec;
  InfNvn, OvsNvn : String;
  RcpAnt1, RcpAnt2, OrdAnt1, OrdAnt2, OvsAnt,
    FejlAnt1, FejlAnt2 : Word;

Begin
//  CheckFilKonvertering;       //Check Records. Ligger i UWinRecept.inc
  RcpAnt1 := 0;
  RcpAnt2 := 0;
  OrdAnt1 := 0;
  OrdAnt2 := 0;
  FejlAnt1 := 0;
  FejlAnt2 := 0;
//  FejlAntIalt := 0;
  OvsNvn := OversigtDir + '\' + LogDate + '.Ovs';
  If FileExists(OvsNvn) Then
  Begin
    AssignFile(OvsHdl, OvsNvn);
    Reset(OvsHdl);
    For OvsAnt := 1 To FileSize(OvsHdl) Do
    Begin
      Read(OvsHdl, OvsRec);
      With OvsRec Do
      Begin
        InfNvn := InformationDir + '\' + IntToStr(FilNr) + '.Fif';
        If FileExists(InfNvn) Then
        Begin
          AssignFile(InfHdl, InfNvn);
          Reset(InfHdl);
          Read(InfHdl, InfRec);
          CloseFile(InfHdl);
          If InfRec.RcpFormat = 'RECEPT' Then
          Begin
            RcpAnt1 := RcpAnt1 + 1;
            OrdAnt1 := OrdAnt1 + OrdAntal;
            FejlAnt1 := FejlAnt1 + ReceptFejl;
          End
          Else
          Begin
            RcpAnt2 := RcpAnt2 + 1;
            OrdAnt2 := OrdAnt2 + OrdAntal;
            FejlAnt2 := FejlAnt2 + ReceptFejl;
          End;
        End;
      End;
    End;
    CloseFile(OvsHdl);
  End;
  Label14.Caption := IntToStr(RcpAnt1); {Recept antal gl. format}
  Label15.Caption := IntToStr(OrdAnt1); {Ordinatonsantal gl. format}
  Label19.Caption := IntToStr(RcpAnt2); {Recept antal Medpre format}
  Label20.Caption := IntToStr(OrdAnt2); {Ordinatonsantal Medpre format}
  Label21.Caption := IntToStr(RcpAnt1 + RcpAnt2); {Recepter ialt}
  Label22.Caption := IntToStr(OrdAnt1 + OrdAnt2); {Orrdinationer ialt}
  Label25.Caption := IntToStr(FejlAnt1 + FejlAnt2); {Fejlrecpter ialt}
End;

Procedure TFormRecept.CheckIndmappe;
Var
  Found : Word;
  FDir : String;
  FRec : TsearchRec;
Begin
  FDir := Indmappe + '\*.Edi';
  Found := FindFirst(FDir, faArchive, FRec);
  While Found = 0 Do
  Begin
    Found := FindNext(FRec);
  End;
  FindClose(FRec);
End;

Procedure TFormRecept.HentRecepter;
Var
  ID : DWord;
  P  : String;
Begin
  P := HentProg;
  ChDir(ExtractFilePath(P));
  WriteLog('Check Kommunedata "Indmappe"');
  if ExecuteJob (P, SW_SHOWMINIMIZED, ID) = 0 then begin
    WriteLog('Der ventes på afslutning af ' + P);
    repeat
      Application.ProcessMessages;
      Sleep (1000);
    until JobFinished (ID);
  end;
End;

Procedure TFormRecept.SendKvitteringer;
Var
  ID : DWord;
  P  : String;
Begin
  P := SendProg;
  ChDir(ExtractFilePath(P));
  WriteLog('Check Kommunedata "Udmappe"');
  if ExecuteJob (P, SW_SHOWMINIMIZED, ID) = 0 then begin
    WriteLog('Der ventes på afslutning af ' + P);
    repeat
      Application.ProcessMessages;
      Sleep (1000);
    until JobFinished (ID);
  end;
End;

Function FileFree(FileName : String) : Boolean;
Var
  I : Word;
  F : TextFile;
Begin
  AssignFile(F, FileName);
{$I-}
  Reset(F);
{$I+}
  I := IOResult;
  If I = 0 Then
    CloseFile(F);
  FileFree := I = 0;
End;

Function TFormRecept.ExecTranslate(INvn, UNvn : String) : Integer;
Const
  (*AH check*)
  ConErr = ' -e Konv.Err';    //
  ConSta = ' -X Konv.Sta';
  ConEdi = ' Edifact';
Var
  ID     : DWord;
  ErrTxt : TStringList;
  EdiFil : TextFile;
  EdiNvn : String;
  LinAnt, EdiRes : Word;
  FejlAnt1 : Word;
Begin
  ChDir(ExtractFilePath(Konverter));
  DeleteFile('Konv.Sta');     //Slet evt. eksisterende konverter
  DeleteFile('Konv.Err');     //fejlmeddelelses filer
  EdiNvn := ExtractFileName(Konverter);
  EdiNvn := EdiNvn + ConSta + ConErr + ' t ' + INvn + ' ' + UNvn + ConEdi;
  if ExecuteJob (EdiNvn, SW_SHOWMINIMIZED, ID) = 0 then begin
    repeat
      WriteLog('Der ventes på afslutning af ' + EdiNvn);
      Application.ProcessMessages;
      Sleep (1000);
    until JobFinished (ID);
  end;
//  WinExec(Addr(EdiNvn[1]), SW_SHOWMINIMIZED); //Start
//  Sleep (2000);
  FejlAnt1 := 0;
  AssignFile(EdiFil, 'Konv.Sta');
{$I-}
  Reset(EdiFil);
{$I+}
  EdiRes := IOResult;
  If EdiRes = 0 Then begin
    ReadLn(EdiFil, EdiRes);
    CloseFile(EdiFil);
  end else
    WriteLog('Uventet I/O fejl ' + IntToStr(EdiRes));
  If EdiRes = 0 Then          //Ingen fejl under konverteringen (EDI-T)
  Begin                       //Slet de oprettede \Edi\Ediconv\Konv.* filer
    DeleteFile('Konv.Sta');
    DeleteFile('Konv.Err');
  End
  Else
  Begin
    ErrTxt := TStringList.Create;
    Try
      ErrTxt.LoadFromFile('Konv.Err'); //Hent oplysninger fra Konv.Err fil
      For LinAnt := 0 To ErrTxt.Count - 1 Do
        WriteLog(ErrTxt.Strings[LinAnt]); //Skriv oplysninger i log-filen

      FejlAnt1 := FejlAnt1 + EdiRes;
      Label25.Caption := IntToStr(FejlAnt1); //Fejlrecpter ialt

    Finally
      ErrTxt.Free;
    End;
    DeleteFile(UNvn);
  End;
  ExecTranslate := EdiRes;
End;

Procedure TFormRecept.CheckKontrol;
Var
  InfRec : TFilRec;
  InfHdl : File Of TFilRec;
  BasNvn,
    EdiPth,
    InfPth,
    KtlPth,
    EdiNvn,
    KvtNvn,
    KtlNvn,
    InfNvn : String;
  Found : Word;
  FDir : String;
  FRec : TsearchRec;
Begin With ReceptData Do
  Begin
    InfPth := InformationDir + '\';
    EdiPth := Udmappe + '\';
    KtlPth := KontrolDir + '\';
    FDir := KtlPth + '*.Ktl';
    WriteLog('Check Kontrolfiler i ' + Udmappe);
    Found := FindFirst(FDir, faArchive, FRec);
    While Found = 0 Do
      With InfRec Do
      Begin
        BasNvn := Copy(FRec.Name, 1, Length(FRec.Name) - 4);
        KtlNvn := KtlPth + FRec.Name;
        KvtNvn := KtlPth + BasNvn + '.Kvt';
        EdiNvn := EdiPth + BasNvn + '.Edi';
        InfNvn := InfPth + BasNvn + '.Fif';
        If Not FileExists(EdiNvn) Then
        Begin
          If RenameFile(KtlNvn, KvtNvn) Then
          Begin
            WriteLog(FRec.Name + ' er kvitteret');
            AssignFile(InfHdl, InfNvn);
            Reset(InfHdl);
            Read(InfHdl, InfRec);
            CloseFile(InfHdl);
            ReWrite(InfHdl);
            InfRec.KvitDato := Now;
            InfRec.KvitStatus := 'Kvitteret';
            Write(InfHdl, InfRec);
            CloseFile(InfHdl);
          End
          Else
            WriteLog(FRec.Name + ' er IKKE kvitteret');
        End;
        Found := FindNext(FRec);
      End;
    FindClose(FRec);
  End;
End;

Procedure TFormRecept.BehandlIndmappe;
Var
  InfRec : TFilRec;
  InfHdl : File Of TFilRec;
  FWord : Word;
  FBool : Boolean;
  Found : Word;
  FDir,
    Nr,
    InfNvn,
    ErrNvn,
    IndNvn,
    TmpNvn : String;
  FRec : TsearchRec;
Begin
  FDir := Indmappe + '\*.Edi';
  WriteLog('Check Edifactfiler i ' + Indmappe);
  Found := FindFirst(FDir, faArchive, FRec);
  While Found = 0 Do begin
    With InfRec Do Begin
      Nr := IntToStr(FilLbNr);
      IndNvn := Indmappe + '\' + FRec.Name; {Meddelelses filnavn}
      InfNvn := InformationDir + '\' + Nr + '.Fif'; {Filinformation}
      ErrNvn := FejlfilDir + '\' + Nr + '.Err'; {Fejlfils navn}
      TmpNvn := UbehandletDir + '\' + Nr + '.Tmp'; {TMP-fils navn}
      FillChar(InfRec, SizeOf(TFilRec), 0);
      AssignFile(InfHdl, InfNvn);
      ReWrite(InfHdl);
      FilNavn := FRec.Name;
      FilNr := FilLbNr;
      AfsDato := Date;
      KvitDato := Date;
      ModtDato := FileDateToDateTime(FRec.Time);
      ModtStatus := 'Modtaget';
      WriteLog(FRec.Name + ' konverteres til ' + ExtractFileName(TmpNvn));
      FWord := ExecTranslate(IndNvn, TmpNvn);
      If FWord = 0 Then
      Begin
        ModtStatus := 'Konverteret';
        DeleteFile(IndNvn);
      End
      Else
      Begin
        ModtStatus := 'Konv.fejl ' + IntToStr(FWord);
        FBool := MoveFile(PChar(IndNvn), PChar(ErrNvn));
        If Not FBool Then
          WriteLog(FRec.Name + ' kan ikke flyttes');
      End;
      Write(InfHdl, InfRec);
      CloseFile(InfHdl);
      Inc(FilLbNr);
      WriteInitKonverter;     {Skriv opdaterede oplysninger i INI-fil}
      Found := FindNext(FRec);
    End;
  end;
  FindClose(FRec);
End;

Function TFormRecept.SplitFile(INvn : String) : Integer;
Var
  KtlRecs : Array[1..100] Of String[100];
  KtlRec : String[100];
  KtlNvn : String;
  KtlHdl : TextFile;
  InfNvn : String;
  InfRec : TFilRec;
  InfHdl : File Of TFilRec;
  OvsNvn : String;
  OvsRec : TRcpRec;
  OvsHdl : File Of TRcpRec;
  MedRec : String;
  MedRes,
    MedAnt : Word;
  MedRcp,
    MedPre : TStringList;
  KtlDate,
    KtlTime,
    KtlRef,
    KtlAfs,
    KtlMod,
    KtlSeg,
    DY,
    DM,
    DD,
    WrkStr,
    EdiNvn,
    EdiType,
    BasNvn,
    RcpNvn,
    Segment,
    RcpType,
    AP4CprNr,
    VareNr,
    VareNavn,
    VareForm,
    VareStrk,
    VarePakn,
    Adr1,
    Adr2,
    Dosering,
    UNBRec : String;
    FBool : Boolean;
Begin With ReceptData Do
  Begin
    FillChar(KtlRecs, SizeOf(KtlRecs), 0);
    BasNvn := ExtractFileName(INvn);
    BasNvn := Copy(BasNvn, 1, Length(BasNvn) - 4);
    InfNvn := InformationDir + '\' + BasNvn + '.Fif';
    KtlNvn := KontrolDir + '\' + BasNvn + '.Ktl';
    EdiNvn := Udmappe + '\' + BasNvn + '.Edi';
    OvsNvn := OversigtDir + '\' + LogDate + '.Ovs';
    RcpNvn := BehandletDir + '\' + LogDate;
    If Not DirectoryExists(RcpNvn) Then
      MkDir(RcpNvn);          {Opret dato-dir til recepter, hvis det ikke findes}
    If Not DirectoryExists(RcpNvn) Then
    Begin
      WriteLog(RcpNvn + ' kunne ikke oprettes');
      Application.Terminate;  {Afslut programmet}
    End;
    If FileExists(OvsNvn) Then
    Begin
      AssignFile(OvsHdl, OvsNvn);
      Reset(OvsHdl);          {Check oversigtsfil}
      Seek(OvsHdl, FileSize(OvsHdl))
    End
    Else
    Begin
      AssignFile(OvsHdl, OvsNvn);
      ReWrite(OvsHdl);        {Opret ny oversigtsfil}
    End;
    AssignFile(InfHdl, InfNvn); {Check INFO-filer}
    Reset(InfHdl);
    Read(InfHdl, InfRec);
    CloseFile(InfHdl);
    MedRes := 0;
    MedRcp := TStringList.Create;
    MedPre := TStringList.Create;
    Try
      MedPre.LoadFromFile(INvn);
        { Check typen, skal være RECEPT eller MEDPRE, samt fejl }
      RcpType := 'Original';
      AP4CprNr := '';
      VareNr := '';
      VareNavn := '';
      VareForm := '';
      VareStrk := '';
      VarePakn := '';
      Adr1 := '';
      Adr2 := '';
      Dosering := '';
      For MedAnt := 0 To MedPre.Count - 1 Do
      Begin
        MedRec := MedPre.Strings[MedAnt];
        Delete(MedRec, 1, 1);
        Delete(MedRec, Length(MedRec), 1);
        MedRec := MedRec + #1;
        Segment := GetSegment(MedRec);
        If Segment = 'UNB' Then
        Begin                 {1. segment}
          InfRec.Afsender := GetToken(03, MedRec);
          InfRec.Modtager := GetToken(06, MedRec);
          InfRec.MeddID := GetToken(11, MedRec);
        End;
        If Segment = 'UNH' Then
        Begin                 {2. segment}
          EdiType := GetToken(2, MedRec);
          If InfRec.RcpFormat = '' Then
            InfRec.RcpFormat := EdiType;
          If InfRec.EDBsystem = '' Then
            InfRec.EDBsystem := GetToken(7, MedRec);
          If EdiType = 'RECEPT' Then
          Begin
            If InfRec.VersNr = 0 Then
            Begin
              WrkStr := GetToken(3, MedRec);
              InfRec.VersNr := StrToInt(WrkStr) * 100;
              WrkStr := GetToken(4, MedRec);
              If WrkStr = '891' Then WrkStr := '1';
              If WrkStr = '1' Then Inc(InfRec.VersNr);
            End;
          End;
        End;
        If Segment = 'RFF' Then
        Begin                 {12. segment (takstversion)}
          If GetToken(1, MedRec) = 'CH' Then
          Begin
            If InfRec.VersNr = 0 Then
              InfRec.VersNr := StrToInt(GetToken(2, MedRec));
          End;
        End;
        If Segment = 'BGM' Then
        Begin                 {3.segment}
          If EdiType = 'MEDPRE' Then
          Begin
            If GetToken(8, MedRec) = '1' Then
              RcpType := 'Annullering'; (*AH Skal muligvis slettes*)
          End;
          If EdiType = 'RECEPT' Then
          Begin
            WrkStr := GetToken(4, MedRec);
            If Length(WrkStr) = 0 Then
              WrkStr := GetToken(6, MedRec);
            DY := Copy(WrkStr, 1, 2);
            DM := Copy(WrkStr, 3, 2);
            DD := Copy(WrkStr, 5, 2);
            If DY > '31' Then
              WrkStr := DD + '-' + DM + '-' + DY
            Else
              WrkStr := DY + '-' + DM + '-' + DD;
            If GetToken(5, MedRec) = '' Then
            Begin
              If GetToken(7, MedRec) <> '' Then
                WrkStr := WrkStr + ' ' + GetToken(7, MedRec);
            End
            Else
              WrkStr := WrkStr + ' ' + GetToken(5, MedRec);
            If Length(WrkStr) = 13 Then
            Begin
              Insert(':', WrkStr, 12);
              Try
                InfRec.AfsDato := StrToDateTime(WrkStr);
              Except
              End;
            End
            Else
            Begin
              Try
                InfRec.AfsDato := StrToDateTime(WrkStr);
              Except
              End;
            End;
          End;
        End;
        If Segment = 'DTM' Then
        Begin                 {4.segment}
          If EdiType = 'MEDPRE' Then
          Begin
            If GetToken(1, MedRec) = '137' Then
            Begin
              WrkStr := GetToken(2, MedRec);
              Delete(WrkStr, 13, 2);
              DY := Copy(WrkStr, 1, 4);
              DM := Copy(WrkStr, 5, 2);
              DD := Copy(WrkStr, 7, 2);
              Delete(WrkStr, 1, 8);
              WrkStr := DD + '-' + DM + '-' + DY + ' ' + WrkStr;
              Insert(':', WrkStr, 14);
              Try
                InfRec.AfsDato := StrToDateTime(WrkStr);
              Except
              End;
            End;
          End;
        End;
        If Segment = 'PNA' Then
        Begin                 {5.segment MEDPRE format}
          If GetToken(1, MedRec) = 'PO' Then
          Begin
            If InfRec.YderNavn = '' Then
            Begin
              InfRec.YderNavn := BytNavn(GetToken(11, MedRec));
              InfRec.YderNavn := Cap1Letter(InfRec.YderNavn);
              InfRec.YderNavn := ConvName(InfRec.YderNavn);
            End;
          End;
        End;
        If Segment = 'NAD' Then
        Begin                 {4.sement gl. format}
          If GetToken(1, MedRec) = 'GR' Then
          Begin
            If InfRec.YderNavn = '' Then
            Begin
              InfRec.YderNavn := GetToken(9, MedRec);
              InfRec.YderNavn := Cap1Letter(InfRec.YderNavn);
              InfRec.YderNavn := ConvName(InfRec.YderNavn);
            End;
          End;
        End;
        If Segment = 'LIN' Then
        Begin
          VareNr := GetToken(3, MedRec);
        End;
        If Segment = 'IMD' Then
        Begin
          If GetToken(2, MedRec) = 'DNM' Then
          Begin
            VareNavn := GetToken(6, MedRec);
          End;
          If GetToken(2, MedRec) = 'DDP' Then
          Begin
            VareForm := GetToken(6, MedRec);
          End;
        End;
        If Segment = 'MEA' Then
        Begin
          If GetToken(1, MedRec) = 'AAU' Then
          Begin
            VarePakn := GetToken(5, MedRec);
          End;
          If GetToken(1, MedRec) = 'DEN' Then
          Begin
            VareStrk := GetToken(5, MedRec);
          End;
        End;
        If Segment = 'DSG' Then
        Begin
          Dosering := GetToken(5, MedRec);
        End;
      End;
      If InfRec.RcpFormat = 'RECEPT' Then
      Begin
      End
      Else
        If InfRec.RcpFormat = 'MEDPRE' Then
        Begin
          If RcpType = 'Original' Then
          Begin
            If InfRec.VersNr = 0 Then MedRes := 3; { Mangler/forkert database version }
            If VareNr = '' Then MedRes := 4; { Mangler varenr }
            If VareNavn = '' Then MedRes := 5; { Mangler vareinformation }
                (*
                        if VareStrk = '' then
                        if VarePakn = '' then
                *)
            If Dosering = '' Then MedRes := 6; { Mangler varepakning }
          End;
        End
        Else
          MedRes := 2;        { Ikke korrekt type, typisk en CONTRL }
        { Hvis rigtig recepttype samt fejlfri }
      If MedRes = 0 Then
      Begin                   {Recept OK}
        For MedAnt := 0 To MedPre.Count - 1 Do
        Begin
          MedRec := MedPre.Strings[MedAnt];
          Delete(MedRec, 1, 1);
          Delete(MedRec, Length(MedRec), 1);
          MedRec := MedRec + #1;
          Segment := GetSegment(MedRec);
          If Segment = 'UNB' Then
          Begin
            UNBRec := MedRec;
          End
          Else
          Begin
            If Segment = 'UNH' Then
            Begin
              FillChar(OvsRec, SizeOf(TRcpRec), 0);
              MedRes := 1;
              EdiType := GetToken(2, MedRec);
              OvsRec.RcpStatus := 'Modtaget';
              OvsRec.RcpType := 'Original';
              OvsRec.FilNr := InfRec.FilNr;
              OvsRec.RcpNr := ReceptLbNr;
              OvsRec.RcpID := GetToken(1, MedRec);
              MedRcp.Add(UNBRec);
            End;
            If (EdiType = 'RECEPT') And (Segment = 'IMD') Then
            Begin
              Inc(OvsRec.OrdAntal);
            End;
            If (EdiType = 'MEDPRE') And (Segment = 'LIN') Then
            Begin
              Inc(OvsRec.OrdAntal);
            End;
            If Segment = 'BGM' Then
            Begin
              If EdiType = 'MEDPRE' Then
              Begin
                If GetToken(8, MedRec) = '1' Then
                  OvsRec.RcpType := 'Annullering';
              End;
            End;
            If Segment = 'PNA' Then
            Begin
              If GetToken(1, MedRec) = 'PO' Then
              Begin
                OvsRec.YderNr := GetToken(5, MedRec);
                OvsRec.YderNavn := BytNavn(GetToken(11, MedRec));
                OvsRec.YderNavn := Cap1Letter(OvsRec.YderNavn);
                OvsRec.YderNavn := ConvName(OvsRec.YderNavn);
                If Length(OvsRec.YderNr) < 6 Then
                  OvsRec.YderNr := Nulls(6 - Length(OvsRec.YderNr))
                    +
                    OvsRec.YderNr;
              End;
              If GetToken(1, MedRec) = 'PAT' Then
              Begin
                OvsRec.PatCprNr := GetToken(2, MedRec);
                OvsRec.PatNavn := BytNavn(GetToken(11, MedRec));
                OvsRec.PatNavn := Cap1Letter(OvsRec.PatNavn);
                OvsRec.PatNavn := ConvName(OvsRec.PatNavn);
                Insert('-', OvsRec.PatCprNr, 7);
              End;
            End;
            If Segment = 'NAD' Then
            Begin
              If GetToken(1, MedRec) = 'GR' Then
              Begin
                OvsRec.YderNr := GetToken(2, MedRec);
                OvsRec.YderNavn := GetToken(9, MedRec);
                OvsRec.YderNavn := Cap1Letter(OvsRec.YderNavn);
                OvsRec.YderNavn := ConvName(OvsRec.YderNavn);
                If Length(OvsRec.YderNr) < 6 Then
                  OvsRec.YderNr := Nulls(6 - Length(OvsRec.YderNr))
                    +
                    OvsRec.YderNr;
              End;
              If GetToken(1, MedRec) = 'BU' Then
              Begin
                OvsRec.PatCprNr := GetToken(2, MedRec);
                OvsRec.PatNavn := GetToken(9, MedRec);
                OvsRec.PatNavn := Cap1Letter(OvsRec.PatNavn);
                OvsRec.PatNavn := ConvName(OvsRec.PatNavn);
              End;
            End;
            MedRcp.Add(MedRec);
            If Segment = 'UNT' Then
            Begin
              Inc(InfRec.RcpAntal);
              If InfRec.RcpFormat = 'RECEPT' Then
              Begin
                KtlRec := 'UCM+' + OvsRec.RcpID + ':' +
                  InfRec.EDBsystem;
                KtlRec := KtlRec + '+RECEPT:' +
                  IntToStr(InfRec.VersNr Div 100);
                KtlRec := KtlRec + ':' + IntToStr(InfRec.VersNr Mod
                  100) + #39;
                KtlRecs[InfRec.RcpAntal] := KtlRec;
              End;
              If InfRec.RcpFormat = 'MEDPRE' Then
              Begin
                KtlRec := 'UCM+' + OvsRec.RcpID +
                  '+MEDPRE:D:93A:UN:M95200+7'#39;
                KtlRecs[InfRec.RcpAntal] := KtlRec;
              End;
                        {
                                    mtOvs.Append;
                                    mtOvsRcpStatus.Value := OvsRec.RcpStatus;
                                    mtOvsUdsAntal.Value  := OvsRec.UdsAntal;
                                    mtOvsOrdAntal.Value  := OvsRec.OrdAntal;
                                    mtOvsRcpType.Value   := OvsRec.RcpType;
                                    mtOvsYderNr.Value    := OvsRec.YderNr;
                                    mtOvsYderNavn.Value  := OvsRec.YderNavn;
                                    mtOvsPatCprNr.Value  := OvsRec.PatCprNr;
                                    mtOvsPatNavn.Value   := OvsRec.PatNavn;
                                    mtOvsFilNr.Value     := OvsRec.FilNr;
                                    mtOvsRcpNr.Value     := OvsRec.RcpNr;
                                    mtOvsRcpID.Value     := OvsRec.RcpID;
                                    mtOvs.Post;
                        }
              Write(OvsHdl, OvsRec);
              MedRcp.SaveToFile(RcpNvn + '\' + IntToStr(ReceptLbNr) +
                '.Rcp');
              MedRcp.Clear;
              MedRes := 0;
              WriteLog(ExtractFileName(INvn) + ' til recept ' +
                IntToStr(ReceptLbNr) + '.Rcp');
              Inc(ReceptLbNr);
              WriteInitKonverter;
            End;
          End;
        End;
      End;
    Finally
      If MedRes = 0 Then
      Begin
        InfRec.KvitStatus := 'Dannet';
        InfRec.KvitDato := Now;
        ReWrite(InfHdl);
        Write(InfHdl, InfRec);
        CloseFile(InfHdl);
        KtlDate := FormatDateTime('yymmdd', Date);
        KtlTime := FormatDateTime('hhmm', Time);
        KtlRef := KtlDate + KtlTime + Format('%4.4d', [InfRec.FilNr]);
        KtlAfs := InfRec.Afsender + ':14+';
        KtlMod := InfRec.Modtager + ':14+';
        KtlSeg := IntToStr(3 + (InfRec.RcpAntal * 2));
        AssignFile(KtlHdl, KtlNvn);
        ReWrite(KtlHdl);
        If InfRec.RcpFormat = 'RECEPT' Then
        Begin
          KtlAfs := InfRec.Afsender + ':14+';
          KtlMod := InfRec.Modtager + ':14+';
          KtlSeg := IntToStr(3 + (InfRec.RcpAntal * 2));
          Write(KtlHdl, 'UNB+UNOA:1+' + KtlMod + KtlAfs + KtlDate +
            ':' + KtlTime + '+' + KtlRef + '++RECEPTCONTRL'#39);
          Write(KtlHdl, 'UNH+' + KtlRef + '+CONTRL:2:0'#39);
          Write(KtlHdl, 'UCI+' + KtlAfs + KtlMod + InfRec.MeddID +
            '+5'#39);
          For MedAnt := 1 To InfRec.RcpAntal Do
          Begin
            KtlRec := KtlRecs[MedAnt];
            Write(KtlHdl, KtlRec);
            Write(KtlHdl, 'UCX+1'#39);
          End;
          Write(KtlHdl, 'UNT+' + KtlSeg + '+' + KtlRef + #39);
          WriteLn(KtlHdl, 'UNZ+1+' + KtlRef + #39);
        End;
        If InfRec.RcpFormat = 'MEDPRE' Then
        Begin
          KtlAfs := InfRec.Afsender + ':14';
          KtlMod := InfRec.Modtager + ':14';
          KtlSeg := IntToStr(3 + InfRec.RcpAntal);
          Write(KtlHdl, 'UNB+UNOC:3+' + KtlMod + '+' + KtlAfs + '+' +
            KtlDate + ':' + KtlTime + '+' + KtlRef + #39);
          Write(KtlHdl, 'UNH+' + KtlRef + '+CONTRL:D:93A:UN:M95200'#39);
          Write(KtlHdl, 'UCI+' + InfRec.MeddID + '+' + KtlAfs + '+' +
            KtlMod +
            '+7'#39);
          For MedAnt := 1 To InfRec.RcpAntal Do
          Begin
            KtlRec := KtlRecs[MedAnt];
            Write(KtlHdl, KtlRec);
          End;
          Write(KtlHdl, 'UNT+' + KtlSeg + '+' + KtlRef + #39);
          WriteLn(KtlHdl, 'UNZ+1+' + KtlRef + #39);
        End;
        CloseFile(KtlHdl);
        CloseFile(OvsHdl);
        FBool := CopyFile(PChar(KtlNvn), PChar(EdiNvn),
          False);
        If Not FBool Then
          WriteLog(KtlNvn + ' kan ikke kopieres');
      End
      Else
      Begin
        InfRec.ModtStatus := 'Datafejl ' + IntToStr(MedRes);
        ReWrite(InfHdl);
        Write(InfHdl, InfRec);
        CloseFile(InfHdl);
      End;
      MedRcp.Free;
      MedPre.Free;
    End;
    SplitFile := MedRes;
  End;
End;

Procedure TFormRecept.SplitEdifact;
Var
  FBool : Boolean;
  FWord,
    Found : Word;
  FDir,
    ErrNvn,
    IndNvn : String;
  FRec : TsearchRec;
Begin
  WriteLog('Check Tempfiler i ' + UbehandletDir);
  FDir := UbehandletDir + '\*.Tmp';
  Found := FindFirst(FDir, faArchive, FRec);
  While Found = 0 Do
  Begin
    IndNvn := UbehandletDir + '\' + FRec.Name;
    ErrNvn := Copy(FRec.Name, 1, Length(FRec.Name) - 4) + '.Err';
    ErrNvn := FejlfilDir + '\' + ErrNvn;
    FWord := SplitFile(IndNvn);
    If FWord = 0 Then
    Begin
      DeleteFile(IndNvn);
    End
    Else
    Begin
      WriteLog(FRec.Name + ' med datafejl ' + IntToStr(FWord));
      FBool := MoveFile(PChar(IndNvn), PChar(ErrNvn));
      If Not FBool Then
        WriteLog(FRec.Name + ' kan ikke flyttes');
    End;
    Found := FindNext(FRec);
  End;
  FindClose(FRec);
End;

procedure TFormRecept.POPConnect(Sender: TObject);
begin
  MailAntal := POP3.MailCount;
  POP3.Disconnect;
end;

Procedure TFormRecept.CheckSekvens;
var
  MsgOk : Boolean;
Begin
  WorkingCursor;
  try
    ButModtag.Enabled := False;
    Minut.Enabled     := False;
    Sleep (2000);
    MailAntal := -1;
    Memo11.Lines.Add ('Mailserver ' + POP3.Host + ' checkes');
    Pop3.Connect;
    if MailAntal > 0 then
      HentRecepter;
//    CheckIndmappe;
//    ChDir(ExtractFilePath(Konverter));
    CheckKontrol;
    BehandlIndmappe;
    SplitEdifact;
    UdskrivRecepter(False);
    CheckStatistik;
    SendKvitteringer;
  finally
    ButModtag.Enabled := True;
    Minut.Enabled     := True;
    Label28.Caption   := FormatDateTime ('dd-mm-yyyy hh:mm', Now);
    NormalCursor;
  end;
End;

Procedure TFormRecept.MinutTimer(Sender : TObject);
Begin
  Minut.Enabled := False;
  CheckSekvens;
End;

Procedure TFormRecept.CheckSletteDato;
Var
  Txt : String;

  Procedure DeleteFiles(P, N : String; A : Word);
  Var
    R : Word;
    F : TsearchRec;
  Begin
    P := P + '\';
    R := FindFirst(P + N, faArchive, F);
    While R = 0 Do
    Begin
      If SubDates(Now, FileDateToDateTime(F.Time)) > A Then
        DeleteFile(P + F.Name);
      R := FindNext(F);
    End;
    FindClose(F);
  End;

  Procedure DeleteDirectory(P : String; A : Word);
  Var
    S : String;
    R : Word;
    D,
    F : TsearchRec;
  Begin
    P := P + '\';
    R := FindFirst(P + '*.*', faDirectory, D);
    While R = 0 Do
    Begin
      If (D.Name <> '.') And (D.Name <> '..') Then
      Begin
        If SubDates(Now, FileDateToDateTime(D.Time)) > A Then
        Begin
          S := P + D.Name + '\';
          R := FindFirst(S + '*.*', faArchive, F);
          While R = 0 Do
          Begin
            Txt := S + F.Name;
            DeleteFile(S + F.Name);
            R := FindNext(F);
            Txt := '';
          End;
          FindClose(F);
          Txt := P + D.Name;
          RmDir(P + D.Name);
          Txt := '';
        End;
      End;
      R := FindNext(D);
    End;
    FindClose(D);
  End;
Begin
  Try
    WriteLog('Slet "gamle" Recept filer');
    Txt := 'Delete OversigtDir';
    DeleteFiles(OversigtDir, '*.Ovs', StatistikDage);
    Txt := 'Delete LogfilDir';
    DeleteFiles(LogfilDir, '*.Log', SletteDage);
    Txt := 'Delete InformationDir';
    DeleteFiles(InformationDir, '*.Fif', SletteDage);
    Txt := 'Delete KontrolDir';
    DeleteFiles(KontrolDir, '*.Kvt', SletteDage);
    Txt := 'Delete BehandletDir';
    DeleteDirectory(BehandletDir, SletteDage);
    WriteLog('Slet "gamle" KMD filer');
    Txt := 'Delete KMD KopiIndmappe';
    DeleteFiles(KopiIndmappe, '*.*', SletteDage);
    Txt := 'Delete KMD KopiUdmappe';
    DeleteFiles(KopiUdmappe, '*.*', SletteDage);
    Txt := 'CheckSletteDato';
  Except
    ChkBoxOK('Exception "' + Txt + '"');
  End;
End;

Procedure TFormRecept.InitComPort;
Begin
  If Copy(PrinterPort, 1, 3) = 'COM' Then
  Begin
    ComPort := TApdComPort.Create(Nil);
    ComPort.ComNumber := Ord(PrinterPort[4]) - 48;
    ComPort.Baud := 9600;
    ComPort.OutSize := 16384;
  End;
End;

Procedure TFormRecept.FormCloseQuery(Sender : TObject; Var CanClose : Boolean);
Begin
  WriteLog('Loggen er lukket');
  ChDir(ReceptDir + '\');
End;

Procedure TFormRecept.FormKeyDown(Sender : TObject; Var Key : Word;
  Shift : TShiftState);
Var
  RcpNr : Word;
Begin
  With ReceptData Do
  Begin
    If Key = VK_Return Then
    Begin
      SelectNext(ActiveControl, True, True);
      Key := 0;
    End;
    If PageControl1.ActivePage = TabOversigt Then
    Begin
      If Key = VK_Space Then
      Begin
        mtSrt.DisableControls;
        mtOvs.DisableControls;
        If SorteretKolonne > 0 Then
        Begin
          RcpNr := mtSrtRcpNr.Value;
          mtOvs.First;
          While mtOvsRcpNr.Value <> RcpNr Do
            mtOvs.Next;
          If mtOvsRcpStatus.Value = 'Udskrevet' Then
          Begin
            mtOvs.Edit;
            mtOvsRcpStatus.Value := 'Udskrives';
            mtOvs.Post;
            mtSrt.Edit;
            mtSrtRcpStatus.Value := 'Udskrives';
            mtSrt.Post;
          End
          Else
          Begin
            If mtOvsRcpStatus.Value = 'Udskrives' Then
            Begin
              mtOvs.Edit;
              mtOvsRcpStatus.Value := 'Udskrevet';
              mtOvs.Post;
              mtSrt.Edit;
              mtSrtRcpStatus.Value := 'Udskrevet';
              mtSrt.Post;
            End;
          End;
        End
        Else
        Begin
          RcpNr := mtOvsRcpNr.Value;
          If mtOvsRcpStatus.Value = 'Udskrevet' Then
          Begin
            mtOvs.Edit;
            mtOvsRcpStatus.Value := 'Udskrives';
            mtOvs.Post;
          End
          Else
          Begin
            If mtOvsRcpStatus.Value = 'Udskrives' Then
            Begin
              mtOvs.Edit;
              mtOvsRcpStatus.Value := 'Udskrevet';
              mtOvs.Post;
            End;
          End;
        End;
        mtSrt.EnableControls;
        mtOvs.EnableControls;
        RetOversigt(mtOvs.RecNo - 1, mtOvsRcpStatus.Value,
          mtOvsUdsAntal.Value);
        If SorteretKolonne > 0 Then
        Begin
          mtSrt.Next;
        End
        Else
        Begin
          mtOvs.Next;
        End;
        Key := 0;
        DBGrid1.SetFocus;
      End;
    End;
  End;
End;

procedure TFormRecept.FormCreate(Sender: TObject);
Var
  nxn,
  Txt : String;
begin
  Try
    Txt := 'CheckDir (StartDir)';
    If CheckDir(StartDir) Then
    Begin
      Txt := 'ChDir (StartDir)';
      ChDir(StartDir);
      Txt := 'CheckFile (IniFilename)';
      If CheckFile(IniFileName) Then
      Begin
        Txt := 'ReadInitFile';
        ReadInitFile;
        Txt := 'Diverse CheckDir og CheckFile';
        If (CheckDir(ExtractFilePath(HentProg))) And
           (CheckDir(ExtractFilePath(SendProg))) And
           (CheckDir(Indmappe)) And
           (CheckDir(Udmappe)) And
           (CheckFile(Konverter)) And
           (CheckDir(OversigtDir)) And
           (CheckDir(ReceptDir)) And
           (CheckDir(KontrolDir)) And
           (CheckDir(FejlfilDir)) And
           (CheckDir(InformationDir)) And
           (CheckDir(UbehandletDir)) And
           (CheckDir(BehandletDir)) Then Begin
          Txt := 'CheckSletteDato';
          CheckSletteDato;
          Txt := 'InitComPort';
          InitComPort;
          Txt := 'Initialiseringer';
          nxn := StartDir + '\' + 'FFServ32.Exe';
          WinExec(Addr(nxn[1]), SW_SHOWMINIMIZED);
          Sleep (3000);
          WriteLog('FF-Server startet');
          Txt := ''; // Alt er ok
        End;
      End;
    End;
  Finally
    if Txt <> '' then begin
      ChkBoxOK ('Exception "' + Txt + '"');
      Application.Terminate;
    end;
    Minut.Enabled := True;
  End;
  Caption := Application.Title;
end;

Procedure TFormRecept.FormDestroy(Sender : TObject);
Begin
  C2ShutDown(Application.Handle, 'ffRecept');
  WriteLog('FF-server er stoppet!');
End;

Procedure TFormRecept.FormShow(Sender : TObject);
Begin
  ChDir(ExtractFilePath(Konverter));
  CheckStatistik;
End;

Procedure UdskrivSide(Var R : TRcpSide; B : Boolean);
Var
  Prt : TextFile;
  Buf : String;
  LIN : Word;
Begin With FormRecept Do
  Begin
    If Copy(PrinterPort, 1, 3) = 'COM' Then
    Begin
      Buf := '';
      For LIN := 1 To TopMargin Do
        Buf := Buf + #13#10;
      For LIN := 1 To FormularHjd Do
        Buf := Buf + RBlkE(Spaces(VenstreMargin) + Win2Dos(R[LIN])) +
          #13#10;
      If B Then
      Begin
        If EkstraSide = 'JA' Then
        Begin
          For LIN := 1 To FormularHjd Do
            Buf := Buf + #13#10;
        End;
      End;
      Repeat
        Application.ProcessMessages;
      Until (ComPort.OutBuffFree > Length(Buf));
      If ComPort.OutBuffFree > Length(Buf) Then
      Begin
        ComPort.PutString(Buf);
      End
      Else
        ChkBoxOK('Printer er IKKE klar!');
    End
    Else
    Begin
      If Copy(PrinterPort, 1, 3) = 'LPT' Then
      Begin
        AssignFile(Prt, PrinterPort);
        ReWrite(Prt);
        For LIN := 1 To TopMargin Do
          Write(Prt, #13#10);
        For LIN := 1 To FormularHjd Do
          Write(Prt, RBlkE(Spaces(VenstreMargin) + Win2Dos(R[LIN])) +
            #13#10);
        If B Then
        Begin
          If EkstraSide = 'JA' Then
          Begin
            For LIN := 1 To FormularHjd Do
              Write(Prt, #13#10);
          End;
        End;
        CloseFile(Prt);
      End
      Else
      Begin
        If FileExists(PrinterPort) Then
        Begin
          AssignFile(Prt, PrinterPort);
          Append(Prt);
        End
        Else
        Begin
          AssignFile(Prt, PrinterPort);
          ReWrite(Prt);
        End;
        For LIN := 1 To TopMargin Do
          Write(Prt, #13#10);
        For LIN := 1 To FormularHjd Do
          Write(Prt, RBlkE(Spaces(VenstreMargin) + Win2Dos(R[LIN])) +
            #13#10);
        If B Then
        Begin
          If EkstraSide = 'JA' Then
          Begin
            For LIN := 1 To FormularHjd Do
              Write(Prt, #13#10);
          End;
        End;
        CloseFile(Prt);
      End;
    End;
  End;
End;

Procedure TFormRecept.ButTestPrintClick(Sender : TObject);
Var
  Rcp : TRcpSide;
  LIN : Word;
Begin With ReceptData Do
  Begin
    For LIN := 1 To FormularHjd Do
      Rcp[LIN] := '';
    Rcp[01] := '    YYYYYY                        EDB-SYSTEM';
    Rcp[02] := '    NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN';
    Rcp[03] := '    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
    Rcp[04] := '    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
    Rcp[05] := '    1234  Bynavn               Tlf. 12345678  EDIFACT';
    Rcp[08] := '123456-1234';
    Rcp[09] := 'NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN          XXXXXXXXXXXXXXX';
    Rcp[10] := 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          XXXXXXXXXXXXXXX';
    Rcp[11] := 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          XXXXXXXXXXXXXXX';
    Rcp[12] := 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA          XXXXXXXXXXXXXXX';
    Rcp[14] := '   Evt. barns navn og fødselsdato                  AMT';
    Rcp[17] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[18] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[19] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[20] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[23] := 'Rp.                         #';
    Rcp[24] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[25] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[26] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[27] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[28] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[29] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[30] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[31] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[32] := '                            #';
    Rcp[33] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[34] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[35] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[36] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[37] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[38] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[39] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[40] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[41] := '                            #';
    Rcp[42] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[43] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[44] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[45] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[46] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[47] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[48] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[49] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
      {Indsat 16-11-98 by AH}
    Rcp[52] := 'DD.MM.HHÅÅ Lægens elektroniske underskrift';
    Rcp[53] := 'CPR: 123456-1234';
    Rcp[56] := 'Apotekets navn';
    Rcp[57] := '          modtaget den. DD/MM/CCÅÅ - TT.MM.      Side 1 af 1';
      //  Rcp [57] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[58] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    Rcp[59] := 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    UdskrivSide(Rcp, True);
  End;
End;

Procedure Str2Pos(IndS : TStr100; Var UdS : TStr100; P : Word);
Begin
  If UdS = '' Then
    UdS := Spaces(62);
  Delete(UdS, P, Length(IndS));
  Insert(IndS, UdS, P);
End;

Procedure TFormRecept.UdskrivRecept(FNr, RNr : Word; INvn : String; ILast :
  Boolean);
Var
  RcpLst : TStringList;
  RcpRes,
    LinCnt : Word;
  FNvn,
    RcpNr,
    Formular,
    EDBsystem,
    Segment,
    RcpRec : String;
  ModtInfo : String;
  InfRec : TFilRec;
  InfHdl : File Of TFilRec;

  Procedure RcpRECEPT;
  Var
    Rcp : Array[1..3] Of TRcpSide;
    Odn : Array[1..8] Of String;
    W,
      Z,
      GenUdlev : String;
    RcpAnt,
      RcpCnt,
      LinCnt,
      OrdLin,
      OrdAnt,
      BEMAnt,
      L,
      N : Word;
    OrdGrp,
      OrdStart : Boolean;

    Procedure HandleOrdination;
    Var
      I, J : Integer;
    Begin
      Inc(OrdAnt);
      OrdGrp := False;
      For I := 1 To OrdAnt Do
      Begin
        Case I Of
          1 :
            Begin
              Str2Pos('#', Rcp[1][23], 29);
              N := 1;
              L := 24;
            End;
          2 :
            Begin
              Str2Pos('#', Rcp[1][32], 29);
              N := 1;
              L := 33;
            End;
          3 :
            Begin
              Str2Pos('#', Rcp[1][41], 29);
              N := 1;
              L := 42;
            End;
          4 :
            Begin
              For J := 1 To 22 Do
                Rcp[2][J] := Rcp[1][J];
              For J := 50 To 68 Do
                Rcp[2][J] := Rcp[1][J];
              Str2Pos('#', Rcp[2][23], 29);
              N := 2;
              L := 24;
            End;
          5 :
            Begin
              Str2Pos('#', Rcp[2][32], 29);
              N := 2;
              L := 33;
            End;
          6 :
            Begin
              Str2Pos('#', Rcp[2][41], 29);
              N := 2;
              L := 42;
            End;
          7 :
            Begin
              For J := 1 To 22 Do
                Rcp[3][J] := Rcp[1][J];
              For J := 50 To 68 Do
                Rcp[3][J] := Rcp[1][J];
              Str2Pos('#', Rcp[3][23], 29);
              N := 3;
              L := 24;
            End;
          8 :
            Begin
              Str2Pos('#', Rcp[3][32], 29);
              N := 3;
              L := 33;
            End;
          9 :
            Begin
              Str2Pos('#', Rcp[3][41], 29);
              N := 3;
              L := 42;
            End;
        End;
      End;
      If OrdLin < 8 Then
        Inc(OrdLin);
      Odn[OrdLin] := GenUdlev;
      Str2Pos(Odn[1], Rcp[N][L + 0], 1);
      Str2Pos(Odn[2], Rcp[N][L + 1], 61 - Length(Odn[2]));
      Str2Pos(Odn[3], Rcp[N][L + 2], 1);
      Str2Pos(Odn[4], Rcp[N][L + 3], 1);
      Str2Pos(Odn[5], Rcp[N][L + 4], 1);
      Str2Pos(Odn[6], Rcp[N][L + 5], 1);
      Str2Pos(Odn[7], Rcp[N][L + 6], 1);
      Str2Pos(Odn[8], Rcp[N][L + 7], 1);
      GenUdlev := '';
      Odn[1] := '';
      Odn[2] := '';
      Odn[3] := '';
      Odn[4] := '';
      Odn[5] := '';
      Odn[6] := '';
      Odn[7] := '';
      Odn[8] := '';
      OrdLin := 0;
    End;
  Begin
    FillChar(Rcp, SizeOf(Rcp), 0);
    OrdGrp := False;
    OrdStart := False;
    OrdAnt := 0;
    GenUdlev := '';
    Odn[1] := '';
    Odn[2] := '';
    Odn[3] := '';
    Odn[4] := '';
    Odn[5] := '';
    Odn[6] := '';
    Odn[7] := '';
    Odn[8] := '';
    OrdLin := 0;
    RcpRes := 1;
    For LinCnt := 0 To RcpLst.Count - 1 Do
    Begin
      RcpRec := RcpLst.Strings[LinCnt];
      Segment := GetSegment(RcpRec);
      Case EdifactSegment(Segment) Of
        UNH :
          Begin
            Str2Pos('EDIFACT', Rcp[1][05], 47);
            Str2Pos(EDBsystem, Rcp[1][01], 45 - Length(EDBsystem));
            Str2Pos('Recept', Rcp[1][10], 50);
            Str2Pos(RcpNr, Rcp[1][11], 50);
            Str2Pos('Rp.', Rcp[1][23], 1);
          End;
        BGM :
          Begin
            W := GetToken(4, RcpRec);
            If Length(W) = 0 Then
              W := GetToken(6, RcpRec);
            If Copy(W, 1, 2) > '31' Then
              W := Copy(W, 5, 2) + '.' + Copy(W, 3, 2) + '.19' + Copy(W, 1, 2)
            Else
              W := Copy(W, 1, 2) + '.' + Copy(W, 3, 2) + '.19' + Copy(W, 5,
                2);
            Str2Pos(W, Rcp[1][52], 1);
          End;
        NAD :
          Begin
            If GetToken(1, RcpRec) = 'GR' Then
            Begin             {Yder}
              Str2Pos(GetToken(02, RcpRec), Rcp[1][1], 5); {Nr}
              W := BytNavn(GetToken(9, RcpRec)); {Navn}
              Str2Pos(Cap1Letter(W), Rcp[1][52], 12);
              If GetToken(10, RcpRec) = '' Then {Praksis}
                Str2Pos(Cap1Letter(W), Rcp[1][2], 5)
              Else
              Begin
                W := GetToken(10, RcpRec);
                Str2Pos(W, Rcp[1][2], 5);
              End;
              Str2Pos(W, Rcp[1][2], 5);
              Str2Pos(GetToken(11, RcpRec), Rcp[1][53], 1); {CprNr}
              W := GetToken(12, RcpRec);
              Str2Pos(Cap1Letter(W), Rcp[1][3], 5); {Adr1}
              W := GetToken(13, RcpRec);
              Str2Pos(Cap1Letter(W), Rcp[1][4], 5); {Adr2}
              W := GetToken(17, RcpRec); {PostNr}
              Str2Pos(W, Rcp[1][5], 5);
              Str2Pos(ReadByNavn(W), Rcp[1][5], 10); {By}
            End;
            If GetToken(1, RcpRec) = 'BU' Then
            Begin             {Patient}
              Str2Pos(GetToken(02, RcpRec), Rcp[1][8], 1); {CprNr}
              W := BytNavn(GetToken(9, RcpRec)); {Navn}
              Str2Pos(Cap1Letter(W), Rcp[1][9], 1);
              W := GetToken(12, RcpRec);
              Str2Pos(Cap1Letter(W), Rcp[1][10], 1); {Adr1}
              W := GetToken(13, RcpRec);
              Str2Pos(Cap1Letter(W), Rcp[1][11], 1); {Adr2}
              W := GetToken(17, RcpRec); {PostNr}
              Str2Pos(W, Rcp[1][12], 1);
              Str2Pos(ReadByNavn(W), Rcp[1][12], 6); {By}
              Str2Pos(GetToken(16, RcpRec), Rcp[1][14], 50); {Amt}
            End;
            If GetToken(1, RcpRec) = 'DP' Then
            Begin             {Levering}
              If GetToken(2, RcpRec) = 'S' Then
              Begin
                W := 'Forsendelse til hjemadressen';
                Str2Pos(W, Rcp[1][17], 1); {Adr1}
              End
              Else
              Begin
                BEMAnt := 17;
                W := GetToken(09, RcpRec);
                If W <> '' Then
                Begin
                  Str2Pos(W, Rcp[1][BEMAnt], 1); {Navn}
                  BEMAnt := BEMAnt + 1;
                End;
                W := GetToken(10, RcpRec);
                If W <> '' Then
                Begin
                  Str2Pos(W, Rcp[1][BEMAnt], 1); {Navn}
                  BEMAnt := BEMAnt + 1;
                End;
                W := GetToken(12, RcpRec);
                If W <> '' Then
                Begin
                  Str2Pos(W, Rcp[1][BEMAnt], 1); {Adr1}
                  BEMAnt := BEMAnt + 1;
                End;
                If BEMAnt < 20 Then
                Begin
                  W := GetToken(13, RcpRec);
                  If W <> '' Then
                  Begin
                    Str2Pos(W, Rcp[1][BEMAnt], 1); {Adr2}
                    BEMAnt := BEMAnt + 1;
                  End;
                End;
              End;
            End;
          End;
        BRN :
          Begin               {Barn}
            W := GetToken(1, RcpRec) + ' ' + GetToken(2, RcpRec);
            Str2Pos(W, Rcp[1][14], 4); {Navn+Cpr}
          End;
        CTA :
          Begin               {Yder}
            W := GetToken(4, RcpRec); {TlfNr}
            Repeat
              L := Pos(' ', W);
              If L > 0 Then
                Delete(W, L, 1);
            Until L = 0;
            Repeat
              L := Pos('-', W);
              If L > 0 Then
                Delete(W, L, 1);
            Until L = 0;
            Str2Pos('Tlf. ' + W, Rcp[1][5], 32);
          End;
        TSK :
          Begin               {Tilskud}
            If Not OrdStart Then
            Begin
              W := GetToken(2, RcpRec);
              If W <> '' Then
              Begin           {Kode}
                If (Copy(Rcp[1][19], 59, 2) = '') Or
                  (Copy(Rcp[1][19], 59, 2) = '  ') Then
                  Str2Pos(W, Rcp[1][19], 59)
                Else
                  Str2Pos(W, Rcp[1][19], 56);
              End
              Else
              Begin           {Tekst}
                W := GetToken(1, RcpRec);
                Str2Pos(W, Rcp[1][19], 61 - Length(W));
              End;
            End
            Else
            Begin
              W := GetToken(2, RcpRec);
              If W <> '' Then
              Begin           {Kode}
                If W = 'VL' Then W := 'Varig lidelse';
                If W = 'KL' Then W := 'Klausuleret';
                If W = 'BL' Then W := 'Tilskud ifølge bistandsloven';
              End
              Else            {Tekst}
                W := GetToken(1, RcpRec);
              If W <> '' Then
              Begin
                Inc(OrdLin);
                Odn[OrdLin] := W;
                W := '';
              End;
            End;
          End;
        IMD :
          Begin               {Ordination}
            OrdStart := True;
            If OrdGrp Then
              HandleOrdination;
            W := '';
            If GetToken(4, RcpRec) = 'NV' Then
              W := GetToken(3, RcpRec);
            If GetToken(5, RcpRec) <> '' Then
            Begin
              If W <> '' Then
                W := W + ' ' + GetToken(5, RcpRec)
              Else
                W := GetToken(5, RcpRec);
            End;
            If GetToken(6, RcpRec) <> '' Then
            Begin
              If W <> '' Then
                W := W + ' ' + GetToken(6, RcpRec)
              Else
                W := GetToken(6, RcpRec);
            End;
            If W <> '' Then
            Begin
              Inc(OrdLin);
              Odn[OrdLin] := W;
              W := '';
            End;
            If GetToken(7, RcpRec) <> '' Then
              W := GetToken(7, RcpRec);
            If GetToken(8, RcpRec) <> '' Then
            Begin
              If W <> '' Then
                W := W + ' ' + GetToken(8, RcpRec)
              Else
                W := GetToken(8, RcpRec);
            End;
            N := 1;
            If GetToken(9, RcpRec) <> '' Then
              N := StrToInt(GetToken(9, RcpRec));
            If N > 1 Then
              W := W + ' X ' + IntToStr(N);
            If W <> '' Then
            Begin
              Inc(OrdLin);
              Odn[OrdLin] := W;
              W := '';
            End;
            If GetToken(2, RcpRec) <> '' Then
            Begin
              W := GetToken(2, RcpRec);
              If W = 'RCP' Then W := '';
              If W = 'HK' Then W := '';
              If W = '-G' Then W := 'Ikke G substitution';
              If W = '-O' Then W := 'Ikke O substitution';
              If W = '-S' Then W := 'Ikke substitution';
              If W = '-P' Then W := 'Importør, gerne O og G substitution';
              If W = '-PG' Then W := 'Importør, ikke G substitution';
              If W = '-PO' Then W := 'Importør, ikke O substitution';
              If W = '-PS' Then W := 'Importør, ingen substitution';
              If W <> '' Then
              Begin
                Inc(OrdLin);
                Odn[OrdLin] := W;
                W := '';
              End;
            End;
            OrdGrp := True;
          End;
        FTX :
          Begin               {Dosering}
            For L := 5 To 9 Do
            Begin
              W := GetToken(L, RcpRec);
              If W <> '' Then
              Begin
                If OrdLin < 8 Then
                Begin
                  Inc(OrdLin);
                  Odn[OrdLin] := W;
                  W := '';
                End;
              End;
            End;
          End;
        GEN :
          Begin               {Genudlev.}
            W := 'Udleveres 1 gang';
            If GetToken(1, RcpRec) <> '0' Then
            Begin
              W := 'Udleveres ';
              N := StrToInt(GetToken(1, RcpRec)) + 1;
              If N = 1 Then
                W := '1 gang med '
              Else
                W := IntToStr(N) + ' gange med ';
              If GetToken(2, RcpRec) <> '' Then
              Begin
                N := StrToInt(GetToken(2, RcpRec));
                If N = 1 Then
                  W := W + '1 '
                Else
                  W := W + IntToStr(N) + ' ';
                If GetToken(3, RcpRec) <> '' Then
                Begin
                  Z := GetToken(3, RcpRec);
                  If Z = 'D' Then
                  Begin
                    If N = 1 Then
                      Z := 'dags mellemrum'
                    Else
                      Z := 'dages mellemrum';
                  End
                  Else
                    If Z = 'M' Then
                    Begin
                      If N = 1 Then
                        Z := 'måneds mellemrum'
                      Else
                        Z := 'måneders mellemrum';
                    End
                    Else
                    Begin
                      If N = 1 Then
                        Z := 'uges mellemrum'
                      Else
                        Z := 'ugers mellemrum';
                    End;
                  W := W + Z
                End;
              End;
            End;
            GenUdlev := W;
          End;
        UNT :
          Begin
            If OrdGrp Then
              HandleOrdination;
            RcpRes := 0;
          End;
      End;
    End;
    If RcpRes = 0 Then
    Begin
      If OrdAnt > 6 Then
        RcpAnt := 3
      Else
        If OrdAnt > 3 Then
          RcpAnt := 2
        Else
          RcpAnt := 1;
      For RcpCnt := 1 To RcpAnt Do
      Begin
        W := 'Modtaget den ' +
          ModtInfo +
          Spaces(20) +
          'Side ' +
          IntToStr(RcpCnt) +
          ' af ' +
          IntToStr(RcpAnt);
        L := Length(W);
            {
                    Str2Pos (W,  Rcp [RcpCnt][21], 61 - L);
            }
        Str2Pos(W, Rcp[RcpCnt][57], 1);
        W := '*** UGYLDIGT RECEPTFORMAT ***';
        Str2Pos(W, Rcp[RcpCnt][59], 1);
        Str2Pos(ApoteksNavn, Rcp[RcpCnt][56], 1);
        UdskrivSide(Rcp[RcpCnt], (RcpCnt = RcpAnt) And (ILast));
      End;
    End;
  End;

  Procedure RcpMEDPRE;
  Type
    TRcpOrd = Record
      VareNr : String;
      NvnAnt : Word;
      NvnTxt : Array[1..3] Of String;
      DspAnt : Word;
      DspTxt : Array[1..3] Of String;
      DenAnt : Word;
      DenTxt : Array[1..3] Of String;
      PakAnt : Word;
      PakTxt : Array[1..3] Of String;
      Subst : String;
      Antal : Word;
      Forhdl : String;
      Tilsk : String;
      KliInfo : String;
      Udlev : String;
      DsgAnt : Word;
      DsgTxt : Array[1..99] Of String;
      DsgTyp : Array[1..99] Of Word;
      Tid : String;
      FriAnt : Word;
      FriTxt : Array[1..9] Of String;
    End;
    TRcpForm = Record
      Annuller : Boolean;
      AnnAnt : Word;
      AnnIDs : Array[1..9] Of String;
      RcpDato : String;
      Tilskud : String;
      Funktion : String;
      LevKode : String;
      LevAnt : Word;
      LevNavn : Array[1..3] Of String;
      LevAdr : String;
      LevAdr2 : String;
      LevPostNr : String;
      LevBy : String;
      DelAnt : Word;
      DelTxt : Array[1..99] Of String;
      OriAnt : Word;
      OriTxt : Array[1..99] Of String;
      OrdAnt : Word;
      Ord : Array[1..99] Of TRcpOrd;
    End;
    TRcpUdsteder = Record
      YderNr : String;
      CprNr : String;
      Praksis : String;
      Navn : String;
      ADR : String;
      Adr2 : String;
      PostNr : String;
      By : String;
      Tlf : String;
      Detaljer : String;
    End;
    TRcpPatient = Record
      Person : Boolean;
      PatRel : Boolean;
      FodDato : String;
      Nr : String;
      ForNavn : String;
      Navn : String;
      ADR : String;
      Adr2 : String;
      PostNr : String;
      By : String;
      Amt : String;
      Land : String;
      Tlf : String;
      RelNr : String;
      RelNavn : String;
      RelAdr : String;
      RelAdr2 : String;
      RelPostNr : String;
      RelBy : String;
      RelAmt : String;
      RelLand : String;
      Detaljer : String;
      Sex : String;
      Alder : String;
      Barn : String;
    End;
  Var
    Rcp : Array[1..100] Of TRcpSide;
    RcpForm : TRcpForm;
    RcpUdsteder : TRcpUdsteder;
    RcpPatient : TRcpPatient;
    SegNvn : String;
    BarnDato1,
    BarnDato2 : TdateTime;
    P,
      SegGrp,
      RcpAnt,
      RcpCnt,
      OrdLin,
      OrdCnt,
      LinCnt : Word;
    Wrk1,
      Wrk2 : String;
    BEMAnt : Word;
    BemTxt : Array[1..99] Of String;
    AnvAnt : Word;
    AnvTxt : Array[1..99] Of String;

    Procedure BemLinier(S : String);
    Begin
      If S <> '' Then
      Begin
        Inc(BEMAnt);
        BemTxt[BEMAnt] := S;
      End;
    End;

    Procedure AnvLinier(S : String);
    Begin
      If S <> '' Then
      Begin
        Inc(AnvAnt);
        AnvTxt[AnvAnt] := S;
      End;
    End;
  Begin
    FillChar(Rcp, SizeOf(Rcp), 0);
    FillChar(RcpForm, SizeOf(TRcpForm), 0);
    FillChar(RcpUdsteder, SizeOf(TRcpUdsteder), 0);
    FillChar(RcpPatient, SizeOf(TRcpPatient), 0);
    FillChar(BemTxt, SizeOf(BemTxt), 0);
    FillChar(AnvTxt, SizeOf(AnvTxt), 0);
    BEMAnt := 0;
    AnvAnt := 0;
    SegGrp := 0;
    SegNvn := 'SG0';
    RcpRes := 1;
    { Gennemløb tekstlinier }
    For LinCnt := 0 To RcpLst.Count - 1 Do
    Begin
      RcpRec := RcpLst.Strings[LinCnt];
      Segment := GetSegment(RcpRec);
      Case EdifactSegment(Segment) Of
        BGM :
          Begin
            RcpForm.Annuller := GetToken(8, RcpRec) = '1';
          End;
        DTM :
          Begin
            Wrk1 := GetToken(1, RcpRec);
            If Wrk1 = '97' Then
            Begin
                  { Receptdato CCYYMMDD }
              SegGrp := 2;
              Wrk1 := GetToken(2, RcpRec);
              Wrk1 := Copy(Wrk1, 7, 2) + '.' +
                Copy(Wrk1, 5, 2) + '.' +
                Copy(Wrk1, 1, 4);
              RcpForm.RcpDato := Wrk1;
            End;
            If Wrk1 = '329' Then
            Begin
                  { Fød.dato CCYYMMDD }
              Wrk1 := GetToken(2, RcpRec);
              If RcpPatient.Alder = '' Then
                RcpPatient.Alder := Copy(Wrk1, 1, 8);
(*
              Wrk1 := GetToken(2, RcpRec);
              If RcpPatient.Alder = '' Then
                RcpPatient.Alder := Copy(Wrk1, 7, 2) +
                  Copy(Wrk1, 5, 2) +
                  Copy(Wrk1, 3, 2);
              Wrk1 := Copy(Wrk1, 7, 2) + Copy(Wrk1, 5, 2) + Copy(Wrk1, 1,
                4);
              RcpPatient.FodDato := Wrk1;
*)
            End;
            If (SegGrp = 6) And (Wrk1 = '264') Then
            Begin
                  { Udlev.hyppighed }
              With RcpForm.Ord[RcpForm.OrdAnt] Do
              Begin
                Wrk1 := GetToken(2, RcpRec);
                Udlev := Udlev + ' med ' + Wrk1 + ' ';
                If StrToInt(Wrk1) > 1 Then
                Begin
                  Wrk1 := GetToken(3, RcpRec);
                  If Wrk1 = '802' Then Wrk1 := 'måneders mellemrum';
                  If Wrk1 = '803' Then Wrk1 := 'ugers mellemrum';
                  If Wrk1 = '804' Then Wrk1 := 'dages mellemrum';
                End
                Else
                Begin
                  Wrk1 := GetToken(3, RcpRec);
                  If Wrk1 = '802' Then Wrk1 := 'måneds mellemrum';
                  If Wrk1 = '803' Then Wrk1 := 'uges mellemrum';
                  If Wrk1 = '804' Then Wrk1 := 'dags mellemrum';
                End;
                Udlev := Udlev + Wrk1;
              End;
            End;
            If (SegGrp = 7) And (Wrk1 = '48') Then
            Begin
                  { Doseringshyppighed }
              With RcpForm.Ord[RcpForm.OrdAnt] Do
              Begin
                Wrk1 := GetToken(2, RcpRec);
                Tid := 'i ' + Wrk1 + ' ';
                If StrToInt(Wrk1) > 1 Then
                Begin
                  Wrk1 := GetToken(3, RcpRec);
                  If Wrk1 = '803' Then Wrk1 := 'uger';
                  If Wrk1 = '804' Then Wrk1 := 'dage';
                End
                Else
                Begin
                  Wrk1 := GetToken(3, RcpRec);
                  If Wrk1 = '803' Then Wrk1 := 'uge';
                  If Wrk1 = '804' Then Wrk1 := 'dag';
                End;
                Tid := Tid + Wrk1;
              End;
            End;
          End;
        PNA :
          Begin
            If SegGrp = 0 Then
              SegGrp := 1;
            SegNvn := Segment + '/' + GetToken(1, RcpRec);
            If SegNvn = 'PNA/PO' Then
            Begin
                  { Udsteder }
              RcpUdsteder.YderNr := GetToken(5, RcpRec);
              RcpUdsteder.Praksis := GetToken(15, RcpRec);
              RcpUdsteder.Navn := BytNavn(GetToken(11, RcpRec));
              RcpUdsteder.CprNr := GetToken(2, RcpRec);
              If Length(RcpUdsteder.CprNr) = 10 Then
                Insert('-', RcpUdsteder.CprNr, 7);
            End;
            If (SegNvn = 'PNA/PAT') Or (SegNvn = 'PNA/ANI') Then
            Begin
                  { Patient/Dyr }
              RcpPatient.Person := SegNvn = 'PNA/PAT';
              RcpPatient.Navn := GetToken(11, RcpRec);
              RcpPatient.Nr := GetToken(2, RcpRec);
              If SegNvn = 'PNA/PAT' Then
              Begin
                If Length(RcpPatient.Nr) = 10 Then
                Begin
                  Insert('-', RcpPatient.Nr, 7);
                End;
                P := Pos(',', RcpPatient.Navn);
                If P > 0 Then
                  RcpPatient.ForNavn := Copy(RcpPatient.Navn,
                    P + 1, Length(RcpPatient.Navn) - P);
                RcpPatient.Navn := BytNavn(RcpPatient.Navn);
              End;
            End;
            If (SegNvn = 'PNA/PAS') Or (SegNvn = 'PNA/AOW') Then
            Begin
                  { Relateret/Dyreejer }
              RcpPatient.PatRel := True;
              RcpPatient.RelNavn := GetToken(11, RcpRec);
              RcpPatient.RelNr := GetToken(2, RcpRec);
              If SegNvn = 'PNA/PAS' Then
              Begin
                If Length(RcpPatient.RelNr) = 10 Then
                  Insert('-', RcpPatient.RelNr, 7);
                RcpPatient.RelNavn := BytNavn(RcpPatient.RelNavn);
              End;
            End;
            If (SegGrp = 4) And (SegNvn = 'PNA/GZ') Then
            Begin
                  { Parallelimportør }
              RcpForm.Ord[RcpForm.OrdAnt].Forhdl := GetToken(11, RcpRec);
            End;
            If (SegGrp = 8) And (SegNvn = 'PNA/AB') Then
            Begin
                  { Leveringsnavn }
              Inc(RcpForm.LevAnt);
              RcpForm.LevNavn[RcpForm.LevAnt] := BytNavn(GetToken(11,
                RcpRec));
            End;
          End;
        ADR :
          Begin
            Case SegGrp Of
              1 :
                Begin
                    { Udsteder }
                  If SegNvn = 'PNA/PO' Then
                  Begin
                    RcpUdsteder.ADR := GetToken(5, RcpRec);
                    RcpUdsteder.PostNr := GetToken(11, RcpRec);
                    RcpUdsteder.By := ReadByNavn(RcpUdsteder.PostNr);
                  End;
                End;
              3 :
                Begin
                    { Patient/Dyr }
                  If (SegNvn = 'PNA/PAT') Or (SegNvn = 'PNA/ANI') Then
                  Begin
                    RcpPatient.ADR := GetToken(5, RcpRec);
                    RcpPatient.Land := GetToken(12, RcpRec);
                    If RcpPatient.Land = '' Then
                    Begin
                      RcpPatient.PostNr := GetToken(11, RcpRec);
                      RcpPatient.By := ReadByNavn(RcpPatient.PostNr);
                      RcpPatient.Amt := GetToken(13, RcpRec);
                    End
                    Else
                    Begin
                      RcpPatient.PostNr := GetToken(11, RcpRec);
                      RcpPatient.By := GetToken(10, RcpRec);
                    End;
                  End;
                  If SegNvn = 'PNA/PAS' Then
                  Begin
                    RcpPatient.RelAdr := GetToken(5, RcpRec);
                    RcpPatient.RelLand := GetToken(12, RcpRec);
                    If RcpPatient.RelLand = '' Then
                    Begin
                      RcpPatient.RelPostNr := GetToken(11, RcpRec);
                      RcpPatient.RelBy :=
                        ReadByNavn(RcpPatient.RelPostNr);
                      RcpPatient.RelAmt := GetToken(13, RcpRec);
                    End
                    Else
                    Begin
                      RcpPatient.RelPostNr := GetToken(11, RcpRec);
                      RcpPatient.RelBy := GetToken(10, RcpRec);
                    End;
                  End;
                End;
              8 :
                Begin
                    { Levering }
                  RcpForm.LevAdr := GetToken(5, RcpRec);
                  RcpForm.LevPostNr := GetToken(11, RcpRec);
                  RcpForm.LevBy := ReadByNavn(RcpForm.LevPostNr);
                End;
            End;
          End;
        COM :
          Begin
              { Udsteder }
            If (SegGrp = 1) And (SegNvn = 'PNA/PO') Then
            Begin
              RcpUdsteder.Tlf := 'Tlf. ' + GetToken(1, RcpRec);
            End;
            If SegGrp = 3 Then
            Begin
              RcpPatient.Tlf := 'Tlf. ' + GetToken(1, RcpRec);
            End;
          End;
        EMP :
          Begin
              { Udsteder }
            If (SegGrp = 1) And (SegNvn = 'PNA/PO') Then
            Begin
              Wrk1 := GetToken(2, RcpRec);
              If Wrk1 = 'DEN' Then Wrk1 := 'Tandlæge';
              If Wrk1 = 'PHY' Then Wrk1 := 'Læge';
              If Wrk1 = 'VET' Then Wrk1 := 'Dyrlæge';
              If Length(RcpUdsteder.Detaljer) = 0 Then
                RcpUdsteder.Detaljer := Wrk1
              Else
                RcpUdsteder.Detaljer := RcpUdsteder.Detaljer + ' ' + Wrk1;
            End;
          End;
        RFF :
          Begin
              { Annullering }
            Wrk1 := GetToken(1, RcpRec);
            If Wrk1 = 'ACW' Then
            Begin
              If RcpForm.AnnAnt < 9 Then
              Begin
                Inc(RcpForm.AnnAnt);
                RcpForm.AnnIDs[RcpForm.AnnAnt] := GetToken(2, RcpRec);
              End;
            End;
          End;
        ICD :
          Begin
              { Tilskud DK/MK/DYK }
            Wrk1 := GetToken(1, RcpRec);
            If Length(RcpForm.Tilskud) = 0 Then
              RcpForm.Tilskud := Wrk1
            Else
              RcpForm.Tilskud := RcpForm.Tilskud + ' ' + Wrk1;
          End;
        INP :
          Begin
              { Instruktion }
            Wrk1 := GetToken(4, RcpRec);
            If Wrk1 = 'AUP' Then Wrk1 := 'Til eget brug';
            If Wrk1 = 'BUS' Then Wrk1 := 'Til erhverv';
            If Wrk1 = 'UIS' Then Wrk1 := 'Til brug i praksis';
            If Length(RcpForm.Funktion) = 0 Then
              RcpForm.Funktion := Wrk1
            Else
              RcpForm.Funktion := RcpForm.Funktion + ' ' + Wrk1;
          End;
        GIS :
          Begin
            SegGrp := 3;
          End;
        FTX :
          Begin
            Case SegGrp Of
              2 :
                Begin
                    { Fritekst}
                  Wrk1 := GetToken(1, RcpRec);
                  If Wrk1 = 'DEL' Then
                  Begin
                    Inc(RcpForm.DelAnt);
                    RcpForm.DelTxt[RcpForm.DelAnt] := GetToken(6, RcpRec);
                  End;
                  If Wrk1 = 'ORI' Then
                  Begin
                    Inc(RcpForm.DelAnt);
                    RcpForm.DelTxt[RcpForm.DelAnt] := GetToken(6, RcpRec);
                  End;
                End;
              7 :
                With RcpForm.Ord[RcpForm.OrdAnt] Do
                Begin
                      { SG7 Fritekst}
                  Inc(FriAnt);
                  FriTxt[FriAnt] := GetToken(6, RcpRec);
                End;
            End;
          End;
        PDI :
          Begin
            Wrk1 := GetToken(1, RcpRec);
            If Wrk1 = '1' Then Wrk1 := 'Hankøn';
            If Wrk1 = '2' Then Wrk1 := 'Hunkøn';
            RcpPatient.Sex := Wrk1;
          End;
        LIN :
          Begin
            SegGrp := 4;
            Inc(RcpForm.OrdAnt);
            RcpForm.Ord[RcpForm.OrdAnt].VareNr := GetToken(3, RcpRec);
            RcpForm.Ord[RcpForm.OrdAnt].Udlev := 'Udleveres 1 gang';
          End;
        IMD :
          With RcpForm.Ord[RcpForm.OrdAnt] Do
          Begin
                { Navn/Form }
            Wrk1 := GetToken(2, RcpRec);
            If Wrk1 = 'DNM' Then
            Begin
              Inc(NvnAnt);
              NvnTxt[NvnAnt] := GetToken(6, RcpRec);
            End;
            If Wrk1 = 'DDP' Then
            Begin
              Inc(DspAnt);
              DspTxt[DspAnt] := GetToken(6, RcpRec);
            End;
          End;
        MEA :
          With RcpForm.Ord[RcpForm.OrdAnt] Do
          Begin
                { Styrke/Pakning }
            Wrk1 := GetToken(1, RcpRec);
            If Wrk1 = 'DEN' Then
            Begin
              Inc(DenAnt);
              DenTxt[DenAnt] := GetToken(5, RcpRec);
            End;
            If Wrk1 = 'AAU' Then
            Begin
              Inc(PakAnt);
              PakTxt[PakAnt] := GetToken(5, RcpRec);
            End;
          End;
        PGI :
          With RcpForm.Ord[RcpForm.OrdAnt] Do
          Begin
                { Substitution }
            Wrk1 := GetToken(2, RcpRec);
            If Subst = '' Then
            Begin
              If Wrk1 = 'NA' Then Wrk1 := 'Ikke analog substitution';
              If Wrk1 = 'NG' Then Wrk1 := 'Ikke generisk substitution';
              If Wrk1 = 'NO' Then Wrk1 := 'Ikke original substitution';
              If Wrk1 = 'NS' Then Wrk1 := 'Ikke substitution';
              Subst := Wrk1;
            End
            Else
            Begin
              If Wrk1 = 'NA' Then Wrk1 := ' og ikke analog substitution';
              If Wrk1 = 'NG' Then
                Wrk1 := ' og ikke generisk substitution';
              If Wrk1 = 'NO' Then
                Wrk1 := ' og ikke original substitution';
              If Wrk1 = 'NS' Then Wrk1 := ' og ikke substitution';
              Subst := Subst + Wrk1;
            End;
          End;
        QTY :
          With RcpForm.Ord[RcpForm.OrdAnt] Do
          Begin
                { Antal }
            Antal := StrToInt(GetToken(2, RcpRec));
          End;
        ALC :
          With RcpForm.Ord[RcpForm.OrdAnt] Do
          Begin
                { Tilskud }
            Wrk1 := GetToken(3, RcpRec);
            If Tilsk = '' Then
            Begin
              If Wrk1 = 'CLA' Then Wrk1 := 'Klausulbetingelse opfyldt';
              If Wrk1 = 'CRD' Then Wrk1 := 'Varig lidelse';
              If Wrk1 = 'PEN' Then Wrk1 := 'Pensionist';
              If Wrk1 = 'SPG' Then
                Wrk1 := 'Bevilling fra lægemiddelstyrelsen';
              Tilsk := Wrk1;
            End
            Else
            Begin
              If Wrk1 = 'CLA' Then Wrk1 := ', klausulbetingelse opfyldt';
              If Wrk1 = 'CRD' Then Wrk1 := ', varig lidelse';
              If Wrk1 = 'PEN' Then Wrk1 := ', pensionist';
              If Wrk1 = 'SPG' Then
                Wrk1 := ', bevilling fra lægemiddelstyrelsen';
              Tilsk := Tilsk + Wrk1;
            End;
          End;
        CIN :
          With RcpForm.Ord[RcpForm.OrdAnt] Do
          Begin
                { Indikation }
            KliInfo := GetToken(5, RcpRec);
          End;
        EQN :
          With RcpForm.Ord[RcpForm.OrdAnt] Do
          Begin
                { Udlevering }
            SegGrp := 6;
            Wrk1 := GetToken(1, RcpRec);
            Wrk1 := IntToStr(StrToInt(Wrk1) + 1);
            Udlev := 'Udleveres ' + Wrk1 + ' gange';
          End;
        DSG :
          With RcpForm.Ord[RcpForm.OrdAnt] Do
          Begin
                { Dosering }
            SegGrp := 7;
            Inc(DsgAnt);
            DsgTyp[DsgAnt] := StrToInt(GetToken(1, RcpRec));
            DsgTxt[DsgAnt] := GetToken(5, RcpRec);
          End;
        TOD :
          Begin
            SegGrp := 8;
            RcpForm.LevKode := GetToken(3, RcpRec);
          End;
        UNT :
          Begin
            RcpRes := 0;
          End;
      End;
    End;
    { Dan blanketter}
    If RcpRes = 0 Then
      With RcpForm Do
      Begin
          { Generelt }
        Str2Pos('EDIFACT', Rcp[1][05], 47);
        Str2Pos(EDBsystem, Rcp[1][01], 45 - Length(EDBsystem));
        Str2Pos('Recept', Rcp[1][10], 50);
        Str2Pos(RcpNr, Rcp[1][11], 50);
        Str2Pos(RcpDato, Rcp[1][52], 1);
        BemLinier(Funktion);
        For LinCnt := 1 To RcpForm.OriAnt Do
          BemLinier(RcpForm.OriTxt[LinCnt]);
        For LinCnt := 1 To RcpForm.DelAnt Do
          BemLinier(RcpForm.DelTxt[LinCnt]);
        If LevKode <> '' Then
        Begin
          If (LevKode = 'OAD') Or (LevKode = 'PAD') Then
            Wrk1 := 'Sendes pr. bud';
          If (LevKode = 'OAM') Or (LevKode = 'PAM') Then
            Wrk1 := 'Sendes pr. post';
          If (LevKode = 'OAD') Or (LevKode = 'OAM') Then
          Begin
            Wrk2 := '';
            For LinCnt := 1 To LevAnt Do
            Begin
              If Length(Wrk2) = 0 Then
                Wrk2 := ' til ' + LevNavn[LinCnt]
              Else
                Wrk2 := Wrk2 + ' ' + LevNavn[LinCnt];
            End;
            If LevAdr <> '' Then
            Begin
              If Length(Wrk2) = 0 Then
                Wrk2 := ' til ' + LevAdr
              Else
                Wrk2 := Wrk2 + ', ' + LevAdr;
            End;
            If LevPostNr <> '' Then
            Begin
              If Length(Wrk2) = 0 Then
                Wrk2 := ' til ' + LevPostNr + ' ' + LevBy
              Else
                Wrk2 := Wrk2 + ', ' + LevPostNr + ' ' + LevBy;
            End;
            Wrk1 := Wrk1 + Wrk2;
            While Length(Wrk1) > 60 Do
              BemLinier(PartStr(Wrk1, Wrk1, 60));
            BemLinier(Wrk1);
          End
          Else
            BemLinier(Wrk1);
        End;
        For LinCnt := 1 To 3 Do
        Begin
          If BEMAnt > 0 Then
          Begin
            Str2Pos(BemTxt[LinCnt], Rcp[1][16 + LinCnt], 1);
            Dec(BEMAnt);
          End;
        End;
        Str2Pos(' ' + Tilskud, Rcp[1][19], 61 - (Length(Tilskud) + 1));
          { Udsteder }
        With RcpUdsteder Do
        Begin
          If Length(Detaljer) > 0 Then
          Begin
            Wrk1 := RBlkE(RBlkF(Detaljer));
            Wrk2 := Copy(Navn, 1, Length(Wrk1));
            Wrk2 := RBlkE(RBlkF(Wrk2));
            Wrk1 := Caps(Wrk1);
            Wrk2 := Caps(Wrk2);
            If Wrk1 <> Wrk2 Then
              Navn := Detaljer + ' ' + Navn;
          End;
          If Praksis = '' Then
            Praksis := Navn;
          Navn := Cap1Letter(Navn);
          ADR := Cap1Letter(ADR);
          ADR := PartStr(ADR, Adr2, 44);
          Str2Pos(YderNr, Rcp[1][01], 5);
          Str2Pos(Praksis, Rcp[1][02], 5);
          Str2Pos(ADR, Rcp[1][03], 5);
          Str2Pos(Adr2, Rcp[1][04], 5);
          Str2Pos(PostNr, Rcp[1][05], 5);
          Str2Pos(By, Rcp[1][05], 10);
          Tlf := Copy(Tlf, 1, 13);
          Str2Pos(Tlf, Rcp[1][05], 32);
          Str2Pos(Navn, Rcp[1][52], 12);
          Str2Pos(CprNr, Rcp[1][53], 1);
        End;
          { Patient/Dyr }
        With RcpPatient Do
        Begin
          If Person Then
          Begin
            Barn := '';
            { RETTES INDEN ÅR 2000 }
            If Nr <> '' Then
            Begin
              // Rettet så der tages højde for Cpr årstal
              if Alder = '' then begin
                Alder := Copy (Nr, 1, 6);
                if Nr [8] in ['4'..'9'] then begin
                  if Copy (Nr, 5, 2) < '37' then
                    Insert ('20', Alder, 5)
                  else begin
                    if Nr [8] in ['5'..'8'] then
                      Insert ('18', Alder, 5)
                    else
                      Insert ('19', Alder, 5);
                  end;
                end else
                  Insert ('19', Alder, 5);
              end;
              Insert('-', Alder, 3);
              Insert('-', Alder, 6);
              BarnDato1 := StrToDate (Alder);
              BarnDato2 := Date;
              if (BarnDato2 - BarnDato1) / 365 < 12 then
                Barn := 'Barn';
(*
              Insert('-', Alder, 3);
              Insert('-', Alder, 6);
              If SubDates(Date, StrToDate(Alder)) Div 365 < 12 Then
                Barn := 'Barn';
*)
              If PatRel Then
              Begin
                Barn := ForNavn + ' f. ' +
                  Copy(FodDato, 1, 2) + '.' +
                  Copy(FodDato, 3, 2) + '.' +
                  Copy(FodDato, 5, 4);
                Nr := RelNr;
                Navn := RelNavn;
                ADR := RelAdr;
                PostNr := RelPostNr;
                By := RelBy;
                Amt := RelAmt;
                Land := RelLand;
              End;
            End
            Else
            Begin
              If PatRel Then
              Begin
                Barn := ForNavn + ' f. ' +
                  Copy(FodDato, 1, 2) + '.' +
                  Copy(FodDato, 3, 2) + '.' +
                  Copy(FodDato, 5, 4);
                Nr := RelNr;
                Navn := RelNavn;
                ADR := RelAdr;
                PostNr := RelPostNr;
                By := RelBy;
                Amt := RelAmt;
                Land := RelLand;
              End
              Else
                Nr := FodDato;
            End;
            If Length(Amt) = 0 Then
              Amt := Land;
            Navn := Cap1Letter(Navn);
            ADR := Cap1Letter(ADR);
            Barn := Cap1Letter(Barn);
            ADR := PartStr(ADR, Adr2, 35);
            Str2Pos(Nr, Rcp[1][08], 1);
            Str2Pos(Navn, Rcp[1][09], 1);
            Str2Pos(ADR, Rcp[1][10], 1);
            Str2Pos(Adr2, Rcp[1][11], 1);
            Str2Pos(PostNr, Rcp[1][12], 1);
            Str2Pos(By, Rcp[1][12], 6);
            Str2Pos(Barn, Rcp[1][14], 4);
            Str2Pos(Amt, Rcp[1][14], 50);
          End
          Else
          Begin
            ADR := PartStr(ADR, Adr2, 35);
            Str2Pos(Nr, Rcp[1][08], 1);
            Str2Pos(Navn, Rcp[1][09], 1);
            Str2Pos(ADR, Rcp[1][10], 1);
            Str2Pos(Adr2, Rcp[1][11], 1);
            Str2Pos(PostNr, Rcp[1][12], 1);
            Str2Pos(By, Rcp[1][12], 6);
          End;
        End;

          { Der skelnes under udskrift mellem annullering og original }
          { Ingen doseringslinier på annulleringer                    }

        If Annuller Then
        Begin
              { Anullering }
          Str2Pos('ANNULLEREDE FORSENDELSESNUMRE', Rcp[1][24], 1);
          Str2Pos('-----------------------------', Rcp[1][25], 1);
          For LinCnt := 1 To AnnAnt Do
            Str2Pos(AnnIDs[LinCnt], Rcp[1][26 + LinCnt], 1);
          RcpAnt := 1;
        End
        Else
        Begin
              { original }
          RcpAnt := 0;
          OrdLin := 50;
          For OrdCnt := 1 To OrdAnt Do
          Begin
            AnvAnt := 0;
            FillChar(AnvTxt, SizeOf(AnvTxt), 0);
            With Ord[OrdCnt] Do
            Begin
              Wrk1 := VareNr;
              For LinCnt := 1 To NvnAnt Do
                Wrk1 := Wrk1 + ' ' + NvnTxt[LinCnt];
              For LinCnt := 1 To DspAnt Do
                Wrk1 := Wrk1 + ' ' + DspTxt[LinCnt];
              For LinCnt := 1 To DenAnt Do
                Wrk1 := Wrk1 + ' ' + DenTxt[LinCnt];
              If Forhdl <> '' Then
                Wrk1 := Wrk1 + ' ' + Caps(Forhdl);
              AnvLinier(PartStr(Wrk1, Wrk2, 60));
              Wrk1 := '';
              For LinCnt := 1 To PakAnt Do
                If Wrk1 = '' Then
                  Wrk1 := PakTxt[LinCnt]
                Else
                  Wrk1 := Wrk1 + ' ' + PakTxt[LinCnt];
              If Antal > 1 Then
                Wrk1 := ' ' + Wrk1 + ' X ' + IntToStr(Antal);
              P := Length(Wrk1) + Length(Wrk2);
              If P > 60 Then
              Begin
                AnvLinier(Wrk2);
                AnvLinier(Spaces(60 - Length(Wrk1)) + Wrk1);
              End
              Else
                AnvLinier(Wrk2 + Spaces(60 - P) + Wrk1);
              AnvLinier(Subst);
              If Length(Tilsk) = 0 Then
                Tilsk := '     ';
              AnvLinier(Tilsk);
              Wrk1 := 'd.s.';
              For LinCnt := 1 To DsgAnt Do
              Begin
                If DsgTyp[LinCnt] = 9 Then
                Begin
                  Wrk1 := Wrk1 + ' ' + #27#45#49;
                  Wrk1 := Wrk1 + DsgTxt[LinCnt];
                  Wrk1 := Wrk1 + #27#45#48;
                End
                Else
                  Wrk1 := Wrk1 + ' ' + DsgTxt[LinCnt];
              End;
              If Tid <> '' Then
                Wrk1 := Wrk1 + ' ' + Tid;
              While Length(Wrk1) > 60 Do
                AnvLinier(PartStr(Wrk1, Wrk1, 60));
              AnvLinier(Wrk1);
              AnvLinier(KliInfo);
              Wrk1 := '';
              For LinCnt := 1 To FriAnt Do
                If Wrk1 = '' Then
                  Wrk1 := FriTxt[LinCnt]
                Else
                  Wrk1 := Wrk1 + ' ' + FriTxt[LinCnt];
              While Length(Wrk1) > 60 Do
                AnvLinier(PartStr(Wrk1, Wrk1, 60));
              AnvLinier(Wrk1);
              AnvLinier(Udlev);
            End;
            If (AnvAnt + 1) > (50 - OrdLin) Then
            Begin
              Inc(RcpAnt);
              If RcpAnt > 1 Then
              Begin
                For LinCnt := 1 To 22 Do
                  Rcp[RcpAnt][LinCnt] := Rcp[1][LinCnt];
                For LinCnt := 50 To 68 Do
                  Rcp[RcpAnt][LinCnt] := Rcp[1][LinCnt];
              End;
              Str2Pos('Rp.' + Spaces(25) + '#', Rcp[RcpAnt][23], 1);
              OrdLin := 24;
            End
            Else
            Begin
              If OrdLin < 41 Then
              Begin
                If OrdLin < 32 Then
                  OrdLin := 32
                Else
                  OrdLin := 41;
              End;
              Str2Pos(Spaces(28) + '#', Rcp[RcpAnt][OrdLin], 1);
              Inc(OrdLin);
            End;
            For LinCnt := 1 To AnvAnt Do
            Begin
              Str2Pos(AnvTxt[LinCnt], Rcp[RcpAnt][OrdLin], 1);
              Inc(OrdLin);
            End;
          End;
          If BEMAnt > 0 Then
          Begin
            Inc(OrdLin);
            For OrdCnt := 1 To BEMAnt Do
            Begin
              If OrdLin > 49 Then
              Begin
                Inc(RcpAnt);
                For LinCnt := 1 To 22 Do
                  Rcp[RcpAnt][LinCnt] := Rcp[1][LinCnt];
                For LinCnt := 50 To 68 Do
                  Rcp[RcpAnt][LinCnt] := Rcp[1][LinCnt];
                OrdLin := 23;
              End;
                      { OrdCnt + 3 fordi der er skrevet 3 linier i linie 17-19 }
              Str2Pos(BemTxt[OrdCnt + 3], Rcp[RcpAnt][OrdLin], 1);
              Inc(OrdLin);
            End;
          End;
        End;

          { Udskriv blanketter}

        For RcpCnt := 1 To RcpAnt Do
        Begin
          Wrk1 := 'Modtaget den ' +
            ModtInfo +
            Spaces(20) +
            'Side ' +
            IntToStr(RcpCnt) +
            ' af ' +
            IntToStr(RcpAnt);
              {
                      Str2Pos (Wrk1,  Rcp [RcpCnt][21], 61 - Length (Wrk1));
              }
          Str2Pos(Wrk1, Rcp[RcpCnt][57], 1);
          Str2Pos(ApoteksNavn, Rcp[RcpCnt][56], 1);
          UdskrivSide(Rcp[RcpCnt], (RcpCnt = RcpAnt) And (ILast));
        End;
      End;
  End;
Begin
  RcpNr := 'Nr. ' + IntToStr(RNr);
  Formular := '';
  EDBsystem := '';
  RcpRes := 1;
  RcpLst := TStringList.Create;
  ModtInfo := '';
  FNvn := InformationDir + '\' + IntToStr(FNr) + '.Fif';
  Try
    If FileExists(FNvn) Then
      With InfRec Do
      Begin
        AssignFile(InfHdl, FNvn);
        Reset(InfHdl);
        Read(InfHdl, InfRec);
        CloseFile(InfHdl);
        ModtInfo := FormatDateTime('dd.mm.yyyy hh:mm', ModtDato);
      End;
    RcpLst.LoadFromFile(INvn);
    For LinCnt := 0 To RcpLst.Count - 1 Do
    Begin
      RcpRec := RcpLst.Strings[LinCnt];
      Segment := GetSegment(RcpRec);
      If EdifactSegment(Segment) = UNH Then
      Begin
        Formular := GetToken(2, RcpRec);
        EDBsystem := GetToken(7, RcpRec);
        RcpRes := 0;
        Break;
      End;
    End;
    If RcpRes = 0 Then
    Begin
      If Formular = 'RECEPT' Then
        RcpRECEPT
      Else
        RcpMEDPRE;
    End;
  Finally
    RcpLst.Free;
  End;
End;

Procedure TFormRecept.RetOversigt(IRNo : Word; ISta : String; IUds : Word);
Var
  OvsNvn : String;
  OvsRec : TRcpRec;
  OvsHdl : File Of TRcpRec;
Begin
  OvsNvn := OversigtDir + '\' + OvsDato + '.Ovs';
  AssignFile(OvsHdl, OvsNvn);
  Reset(OvsHdl);
  Seek(OvsHdl, IRNo);
  Read(OvsHdl, OvsRec);
  OvsRec.RcpStatus := ISta;
  OvsRec.UdsAntal := IUds;
  Seek(OvsHdl, IRNo);
  Write(OvsHdl, OvsRec);
  CloseFile(OvsHdl);
End;

Procedure TFormRecept.ButUdskrivClick(Sender : TObject);
Begin
  WorkingCursor;
  try
    ButModtag.Enabled := False;
    Minut.Enabled     := False;
    UdskrivRecepter(True);
    If Oversigt_OK Then
      HentOversigt(Oversigt_Dir) {Genskriv oversigten fra gl. dato}
    Else
      HentOversigt('');       {Genskriv oversigten}
  finally
    ButModtag.Enabled := True;
    Minut.Enabled     := True;
    NormalCursor;
  end;
End;

Procedure TFormRecept.ButDanKvitClick(Sender : TObject);
Var
  FBool : Boolean;
  KtlNvn,
    KvtNvn,
    EdiNvn : String;
Begin With ReceptData Do
  Begin
    KtlNvn := KontrolDir + '\' + IntToStr(mtOvsFilNr.Value) + '.Ktl';
    KvtNvn := KontrolDir + '\' + IntToStr(mtOvsFilNr.Value) + '.Kvt';
    EdiNvn := Udmappe + '\' + IntToStr(mtOvsFilNr.Value) + '.Edi';
    If FileExists(KvtNvn) Then
    Begin
      FBool := CopyFile(PChar(KvtNvn), PChar(EdiNvn), False);
      If FBool Then
        WriteLog(KvtNvn + ' er gensendt')
      Else
        WriteLog(KvtNvn + ' kan ikke gensendes');
    End
    Else
    Begin
      If FileExists(KtlNvn) Then
      Begin
        FBool := CopyFile(PChar(KtlNvn), PChar(EdiNvn), False);
        If FBool Then
          WriteLog(KtlNvn + ' er gensendt')
        Else
          WriteLog(KtlNvn + ' kan ikke gensendes');
      End
      Else
        WriteLog(KtlNvn + ' kan ikke gensendes mere');
    End;
  End;
End;

Procedure VisInformation(InfNvn : String);
Var
  InfRec : TFilRec;
  InfHdl : File Of TFilRec;
Begin With ReceptData Do
  Begin
    If FileExists(InfNvn) Then
      With InfRec Do
      Begin
        AssignFile(InfHdl, InfNvn);
        Reset(InfHdl);
        Read(InfHdl, InfRec);
        CloseFile(InfHdl);
        FormFilInfo.Edit1.Text := Afsender;
        FormFilInfo.Edit2.Text := YderNavn;
        FormFilInfo.Edit3.Text := EDBsystem;
        FormFilInfo.Edit4.Text := MeddID;
        FormFilInfo.Edit5.Text := IntToStr(VersNr Div 100) + '.' +
          IntToStr(VersNr Mod 100);
        FormFilInfo.Edit6.Text := FormatDateTime('dd.mm.yyyy hh:mm',
          AfsDato);
        FormFilInfo.Edit7.Text := Modtager;
        FormFilInfo.Edit8.Text := FilNavn;
        FormFilInfo.Edit9.Text := RcpFormat;
        FormFilInfo.Edit10.Text := IntToStr(FilNr);
        FormFilInfo.Edit11.Text := IntToStr(RcpAntal);
        FormFilInfo.Edit12.Text := FormatDateTime('dd.mm.yyyy hh:mm',
          ModtDato);
        FormFilInfo.Edit13.Text := ModtStatus;
        FormFilInfo.Edit14.Text := FormatDateTime('dd.mm.yyyy hh:mm',
          KvitDato);
        FormFilInfo.Edit15.Text := KvitStatus;
        FormFilInfo.ShowModal;
      End
    Else
      ChkBoxOK('Informationer til fil findes ikke!');
  End;
End;

Procedure TFormRecept.ButVisInfoClick(Sender : TObject);
Var
  InfNvn : String;
Begin With ReceptData Do
  Begin
    InfNvn := InformationDir + '\' + IntToStr(mtOvsFilNr.Value) + '.Fif';
    VisInformation(InfNvn);
  End;
End;

Procedure TFormRecept.ButModtagClick(Sender : TObject);
Begin
  Minut.Enabled := False;
  CheckSekvens;
End;

Procedure TFormRecept.ButOversigtClick(Sender : TObject);
Var
  N : String;
Begin With ReceptData Do
  Begin
    OpenDialog1.InitialDir := OversigtDir;
    If OpenDialog1.Execute Then
    Begin
      N := OpenDialog1.FileName;
      Oversigt_Dir := N;
      Oversigt_OK := True;
      HentOversigt(N);        {Genskriv oversigt for d.d.}
      DBGrid1TitleClick(DBGrid1.Columns[0]);
      DBGrid1.Refresh;
    End;
  End;
End;

Procedure TFormRecept.ButInfoFilerClick(Sender : TObject);
Var
  InfNvn : String;
Begin With ReceptData Do
  Begin
    OpenDialog3.InitialDir := InformationDir;
    If OpenDialog3.Execute Then
    Begin
      InfNvn := OpenDialog3.FileName;
      VisInformation(InfNvn);
    End;
  End;
End;

Procedure TFormRecept.ButLogfilClick(Sender : TObject);
Begin With ReceptData Do
  Begin
    OpenDialog2.InitialDir := LogfilDir;
    If OpenDialog2.Execute Then
    Begin
      Memo11.Clear;
      Memo11.Lines.LoadFromFile(OpenDialog2.FileName);
    End;
  End;
End;

Procedure TFormRecept.PageControl1Enter(Sender : TObject);
Begin
//  HentOversigt('');           {Genskriv oversigten for dags dato ~ NU}
  PageControl1.ActivePage := TabModtag;
  HentOversigt('');           {Genskriv oversigten for dags dato ~ NU}
End;

procedure TFormRecept.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = TabOversigt then
    DBGrid1.SetFocus;
end;

Procedure TFormRecept.TabOversigtEnter(Sender : TObject);
Begin
  Minut.Enabled     := False;
  ButModtag.Enabled := False;
  ChkBoxOK ('Der er pause i modtagelse!');
  DBGrid1TitleClick(DBGrid1.Columns[0]);
  HentOversigt('');
End;

procedure TFormRecept.TabOversigtExit(Sender: TObject);
begin
  Minut.Enabled     := True;
  ButModtag.Enabled := True;
end;

Procedure TFormRecept.UdskrivRecepter(GlDir : Boolean);
Var
  Temp_Dir : String;
  OvsPos, OvsAnt, RcpSek, RcpAnt, RcpEnd : Word;
  OvsNvn, RcpNvn, RcpPth : String;
  OvsRec : TRcpRec;
  OvsHdl : File Of TRcpRec;

Begin With ReceptData, OvsRec Do
  Begin
    RcpAnt := 0;
    RcpEnd := 0;

    Temp_Dir := Copy(Oversigt_Dir, 1, Length(Oversigt_Dir) - 4);

      {
          RcpPth := BehandletDir + '\' + extractfilename(oversigt_dir);
          OvsNvn := OversigtDir + '\' + extractfilename(oversigt_dir)+ '.Ovs';
          panel1.caption:=rcppth+' '+ovsnvn;
      }

    If (Not GlDir) Or (Not Oversigt_OK) Then
    Begin
      RcpPth := BehandletDir + '\' + LogDate;
      OvsNvn := OversigtDir + '\' + LogDate + '.Ovs';
    End
    Else
    Begin
      RcpPth := BehandletDir + '\' + ExtractFileName(Temp_Dir);
      OvsNvn := OversigtDir + '\' + ExtractFileName(Temp_Dir) + '.Ovs';
    End;
    If FileExists(OvsNvn) Then
    Begin
          //      Panel1.Caption := 'EKSI';
          //      WriteLog(Panel1.Caption);

      AssignFile(OvsHdl, OvsNvn);
      Reset(OvsHdl);
          //      Udtext := IntToStr(SorteretKolonne);
          //      WriteLog('SorteretKolonne = '+Udtext);

      For OvsAnt := 1 To FileSize(OvsHdl) Do
      Begin
        Read(OvsHdl, OvsRec);
        If (RcpStatus = 'Modtaget') Or
          (RcpStatus = 'Udskrives') Then
        Begin
          RcpEnd := RcpNr;
                  //          Panel1.Caption := RcpStatus;
        End;
      End;
          //      WriteLog(OvsNvn);
      If RcpEnd > 0 Then

      Begin
        Reset(OvsHdl);
        For OvsAnt := 1 To FileSize(OvsHdl) Do
        Begin
          OvsPos := FilePos(OvsHdl);
          Read(OvsHdl, OvsRec);
          If (OvsRec.RcpStatus = 'Modtaget') Or
            (OvsRec.RcpStatus = 'Udskrives') Then
          Begin
            RcpNvn := RcpPth + '\' + IntToStr(RcpNr) + '.Rcp';
            If FileExists(RcpNvn) Then
            Begin
              UdskrivRecept(FilNr, RcpNr, RcpNvn, RcpNr = RcpEnd);
              OvsRec.RcpStatus := 'Udskrevet';
              OvsRec.UdsAntal := OvsRec.UdsAntal + 1;
{(*}
//              Panel1.Caption := '1.TALT OP';
//If SorteretKolonne > 0 Then
//  OPDATERING AF ANTAL UDSKREVET MANGLER NÅR DER ER SORTERET PÅ
//  ANDET END LBNR
//srtRec.UdsAntal := srtRec.UdsAntal + 1;
{*)}
              Seek(OvsHdl, OvsPos);
              Write(OvsHdl, OvsRec);
              Inc(RcpAnt);
              If (RcpAnt Mod 10 = 0) And (RcpNr <> RcpEnd) Then
              Begin
                For RcpSek := 1 To UdskriftPause Div 2 Do
                Begin
                  Sleep (500);
                  Application.ProcessMessages;
                  Sleep (500);
                  Application.ProcessMessages;
                End;
              End;
            End;
          End;
{(*}
//      WriteLog(Panel1.Caption);
//      WriteLog(Panel2.Caption);
{*)}
        End;
      End;
      CloseFile(OvsHdl);
    End;
  End;
End;

Function TFormRecept.ReadByNavn(IPNr : String) : String;
Begin With ReceptData Do
  Begin
    If Not ffPostNumre.Active Then
      ffPostNumre.Open;
    If ffPostNumre.FindKey([IPNr]) Then
      ReadByNavn := ffPostNumreByNavn.AsString
    Else
      ReadByNavn := '';
  End;
End;

Procedure TFormRecept.DBGrid1TitleClick(Column : TColumn);
Type
  TSortList = Record
    SortStr : String[70];
    RecNr : Word;
  End;
Var
  Str1, Str2 : String;
  Nr1, Nr2,
    X, Y,
    Idx,
    M : Word;
  SortList : Array[1..1000] Of TSortList;
Begin With ReceptData Do      { Sæt overskrifter til normal }
  Begin
    DBGrid1.Columns[00].Title.Font.Style := []; {LbNr}
    DBGrid1.Columns[01].Title.Font.Style := []; {Tid}
    DBGrid1.Columns[02].Title.Font.Style := []; {Ord}
    DBGrid1.Columns[03].Title.Font.Style := []; {Uds}
    DBGrid1.Columns[04].Title.Font.Style := []; {Ydernr}
    DBGrid1.Columns[05].Title.Font.Style := []; {Ydernavn}
    DBGrid1.Columns[06].Title.Font.Style := []; {Pat.cprnr}
    DBGrid1.Columns[07].Title.Font.Style := []; {Pat.navn}
    DBGrid1.Columns[08].Title.Font.Style := []; {Type}
    DBGrid1.Columns[09].Title.Font.Style := []; {Sattus}
    DBGrid1.Columns[10].Title.Font.Style := []; {Format}
    DBGrid1.Columns[11].Title.Font.Style := []; {Rcp}
    DBGrid1.Columns[12].Title.Font.Style := []; {Filnr}
    DBGrid1.Columns[13].Title.Font.Style := []; {Rcp.ID}
    Idx := Column.Index;
    If Idx In [1..13] Then
    Begin
      FillChar(SortList, SizeOf(SortList), 0);
      M := 0;
      mtSrt.DisableControls;
      mtOvs.DisableControls;
      mtSrt.Active := False;
      mtSrt.Active := True;
      mtOvs.First;
      While Not mtOvs.Eof Do  { Udtræk string og recnr til sortering }
      Begin
        Inc(M);
        SortList[M].SortStr := Caps(mtOvs.Fields[Idx].AsString);
        SortList[M].RecNr := mtOvs.RecNo;
        mtOvs.Next;
      End;
      For X := 2 To M Do      { Sorter SortList }
      Begin
        For Y := M Downto X Do
        Begin
          Str1 := SortList[Y].SortStr;
          Nr1 := SortList[Y].RecNr;
          Str2 := SortList[Y - 1].SortStr;
          Nr2 := SortList[Y - 1].RecNr;
          If Str1 < Str2 Then
          Begin
            SortList[Y].SortStr := Str2;
            SortList[Y].RecNr := Nr2;
            SortList[Y - 1].SortStr := Str1;
            SortList[Y - 1].RecNr := Nr1;
          End;
        End;
      End;
      For X := 1 To M Do      { Overfør data fra original i sorteret rækkefølge}
      Begin
        mtOvs.First;
        While mtOvs.RecNo <> SortList[X].RecNr Do
          mtOvs.Next;
        mtSrt.Append;
        mtSrtRcpNr.Value := mtOvsRcpNr.Value;
        mtSrtOrdAntal.Value := mtOvsOrdAntal.Value;
        mtSrtUdsAntal.Value := mtOvsUdsAntal.Value;
        mtSrtYderNr.Value := mtOvsYderNr.Value;
        mtSrtYderNavn.Value := mtOvsYderNavn.Value;
        mtSrtPatCprNr.Value := mtOvsPatCprNr.Value;
        mtSrtPatNavn.Value := mtOvsPatNavn.Value;
        mtSrtRcpType.Value := mtOvsRcpType.Value;
        mtSrtRcpStatus.Value := mtOvsRcpStatus.Value;
        mtSrtFilNr.Value := mtOvsFilNr.Value;
        mtSrtRcpID.Value := mtOvsRcpID.Value;
        mtSrtRcpDagNr.Value := mtOvsRcpDagNr.Value;
        mtSrtRcpFormat.Value := mtOvsRcpFormat.Value;
        mtSrtModtDato.Value := mtOvsModtDato.Value;
        mtSrt.Post;
      End;
      DBGrid1.DataSource := ReceptData.dsSrt;
      mtSrt.Refresh;
      mtSrt.First;
      mtOvs.EnableControls;
      mtSrt.EnableControls;
          //      Lav en markering i Title overskriften i kolonnen.
          //      DBGrid1.Columns[Idx].Title := '• '+ DBGrid1.Columns[Idx].Title;
      DBGrid1.Columns[Idx].Title.Font.Style := [fsBold];
    End
    Else
    Begin
      mtOvs.DisableControls;
      DBGrid1.DataSource := ReceptData.dsOvs;
      mtOvs.Refresh;
      mtOvs.First;
      mtOvs.EnableControls;
      DBGrid1.Columns[0].Title.Font.Style := [fsBold];
      Idx := 0;
    End;
    SorteretKolonne := Idx;
  End;
End;

Procedure TFormRecept.VerMenuClick(Sender : TObject);
Begin
  FormVersionInfo.ShowModal;
End;

Procedure TFormRecept.IniMenuClick(Sender : TObject);
Begin
  FormInifile.ShowModal;
End;

Procedure TFormRecept.EditMenuClick(Sender : TObject);
Var
  P : String;
  S : Array[0..Max_Path] Of Char;
Begin
  If Passw_F.ShowModal = 1 Then
  Begin
    GetWindowsDirectory(S, SizeOf(S));
    P := S + '\Notepad.exe ' + StartDir + '\' + IniFileName;
    WinExec(Addr(P[1]), SW_SHOW);
  End;
End;

Procedure TFormRecept.DBGrid1DrawColumnCell(Sender : TObject;
  Const Rect : TRect; DataCol : Integer; Column : TColumn;
  State : TGridDrawState);
Begin
  If (Sender Is TDBGrid) Then
  Begin
    If SorteretKolonne > 0 Then
    Begin
      If (ReceptData.mtSrtRcpStatus.Value = 'Udskrives') Then
      Begin
        (Sender As TDBGrid).Canvas.Brush.Color := CLred;
      End;
    End
    Else
    Begin
      If (ReceptData.mtOvsRcpStatus.Value = 'Udskrives') Then
      Begin
        (Sender As TDBGrid).Canvas.Brush.Color := CLred;
      End;
    End;
  End;
  (Sender As TDBGrid).Canvas.TextRect(Rect, Rect.Left + 2, Rect.Top + 2,
    Column.field.AsString);
End;

procedure TFormRecept.ButVersClick(Sender: TObject);
begin
  VerMenu.Click;
end;

Initialization
  Oversigt_OK := False;
End.

