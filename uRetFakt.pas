unit uRetFakt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, Grids, DBGrids, ExtCtrls, nxdb, nxdbBase, IniFiles;

type
  TForm1 = class(TForm)
    ffComm: TnxCommsEngine;
    nxSess: TnxSession;
    ffFakt: TnxTable;
    ffEksp: TnxTable;
    Panel1: TPanel;
    grEksp: TDBGrid;
    grFakt: TDBGrid;
    dsFakt: TDataSource;
    dsEksp: TDataSource;
    butRet: TButton;
    eFra: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    eUnder: TEdit;
    procedure butRetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.butRetClick(Sender: TObject);
var
  UnderNr,
  FakturaNr : LongWord;
begin
  FakturaNr := StrToInt (eFra.Text);
  UnderNr   := StrToInt (eUnder.Text);
  while not ffFakt.Eof do begin
    if ffFakt ['FakturaNr'] <= UnderNr then begin
      // Ret alle ekspeditioner
      ffEksp.First;
      while not ffEksp.Eof do begin
        if ffFakt ['FakturaNr'] = ffEksp ['FakturaNr'] then begin
          ffEksp.Edit;
          ffEksp ['FakturaNr'] := FakturaNr;
          ffEksp.Post;
        end;
        ffEksp.Next;
      end;
      // Ret forsendelsespost
      ffFakt.Edit;
      ffFakt ['FakturaNr'] := FakturaNr;
      ffFakt.Post;
      Inc (FakturaNr);
    end;
    ffFakt.Next;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  IniFile   : TIniFile;
  Protocol,
  Server,
  Alias,
  Afsnit,
  Error     : String;
  Cnt       : Word;
begin
  if ffComm.Active then begin
    nxSess.Active := False;
    ffComm.Active := False;
  end;
  Error   := 'Read "WinPacer.Ini"';
  IniFile := TIniFile.Create (ExpandFileName ('WinPacer.Ini'));
  try
    with IniFile do begin
      Afsnit   := 'Database';
      Server   := ReadString  (Afsnit, 'Connect',  'ffWinPacer');
      Protocol := ReadString  (Afsnit, 'Protocol', 'SingleUser');
      Alias    := ReadString  (Afsnit, 'Alias',    'Produktion');
    end;
    for Cnt := 0 to ComponentCount -1 do begin
      if Components [Cnt] is TnxTable then begin
        Error := 'Table alias ' + (Components [Cnt] as TnxTable).Name;
        (Components [Cnt] as TnxTable).DatabaseName := Alias;
      end;
    end;
    Error := 'Open communication';
    if Protocol = 'SingleUser' then ffComm.Protocol := ptSingleUser;
    if Protocol = 'TCP/IP'     then ffComm.Protocol := ptTCPIP;
    if Protocol = 'IPX/SPX'    then ffComm.Protocol := ptIPXSPX;
    if Protocol = 'NetBIOS'    then ffComm.Protocol := ptNetBIOS;
    if Protocol = 'Registry'   then ffComm.Protocol := ptRegistry;
    ffComm.ServerName := Server;
    ffComm.Active     := True;
    Error             := 'Open session';
    nxSess.Active     := True;
    for Cnt := 0 to ComponentCount -1 do begin
      if Components [Cnt] is TnxTable then begin
        Error := 'Open table '  + (Components [Cnt] as TnxTable).Name;
        (Components [Cnt] as TnxTable).Open;
      end;
    end;
    Error := '';
  finally
    IniFile.Free;
    IniFile := NIL;
    if Error <> '' then
      raise EnxDatabaseError.Create (Error);
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ffComm.Close;
end;

end.
