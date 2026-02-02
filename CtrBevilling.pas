unit CtrBevilling;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, DBCtrls, StdCtrls, ExtCtrls, Buttons;

type
  TfmCtrBevilling = class(TForm)
    paCtrBev: TPanel;
    buFortryd: TBitBtn;
    buOk: TBitBtn;
    stCtrAtcMatch: TStaticText;
    Label10: TLabel;
    Label11: TLabel;
    edLinVareNr: TEdit;
    edLinAtcKode: TEdit;
    dbgCtrOver: TDBGrid;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure buOkClick(Sender: TObject);
    procedure dbgCtrOverDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmCtrBevilling: TfmCtrBevilling;

function CtrBevValg(VareNr, AtcKode, Produkt: String;DosisKortnr : integer): Boolean;

implementation

uses
  ChkBoxes,
  C2Procs,
  C2MainLog,
  DM;

{$R *.DFM}

function CtrBevValg(VareNr, AtcKode, Produkt: String;DosisKortnr : integer): Boolean;
var
  L: Integer;
  BlankATC : boolean;
  SkipQuestion : boolean;
  save_DCLindex : string;
  Rule43 : boolean;
begin
  with fmCtrBevilling, MainDm do
  begin
    C2LogAdd('  CTR Bevilling check starter /' + VareNr + '/' + AtcKode + '/' + Produkt + '/');
    try
      ModalResult          := mrNone;
      if mtEksReceptStatus.AsInteger = 999 then
      begin
        if (VareNr = '688002') or (Varenr = '688003')then
        begin
          ModalResult := mrCancel;
          Result := False;
          exit;
        end;
      end;
      edLinVareNr  .Text   := VareNr;
      edLinAtcKode .Text   := AtcKode;
      stCtrAtcMatch.Color  := clRed;
      stCtrAtcMatch.Caption:= 'Ulighed';
      BlankATC := False;
      SkipQuestion := False;
      // first look for 43
      Rule43 := False;
      cdCtrBev.First;
      while not cdCtrBev.Eof do
      begin
        C2LogAdd('    Udløb testes ' + cdCtrBevFraDato.AsString + '-' + cdCtrBevTilDato.AsString);
        if (Trunc(Date) >= Trunc(cdCtrBevFraDato.AsDateTime)) and
           (Trunc(Date) <= Trunc(cdCtrBevTilDato.AsDateTime)) then
        begin
          if cdCtrBevRegel.AsInteger = 43 then
          begin
//            if cdCtrBevVareNr.AsString <> '' then begin
            if cdCtrBevVareNr.AsString = VareNr then
                stCtrAtcMatch.Caption:= 'Varenr lighed'
            else begin
              // Check på ATC kode
              L:= Length(cdCtrBevAtc.AsString);
              if L > 0 then
              begin
                if cdCtrBevAtc.AsString = Copy(AtcKode, 1, L) then
                  stCtrAtcMatch.Caption:= 'ATC kode lighed'
              end
              else
              begin
                if cdCtrBevRegel.AsInteger <> 47 then
                  BlankATC := true;
                // Check på navn
                L:= Length(cdCtrBevLmNavn.AsString);
                if L > 0 then
                begin
                  if Pos(Caps(cdCtrBevLmNavn.AsString), Caps(Produkt)) > 0 then
                    stCtrAtcMatch.Caption:= 'Lægemiddelnavn lighed'
                end;
              end;
            end;
            if Pos(' lighed', stCtrAtcMatch.Caption) > 0 then
            begin
              stCtrAtcMatch.Color:= clGreen;
              Rule43 :=  True;
              // Stop på linie med lighed
              Break;
            end;
          end;
          C2LogAdd('    Status ' + stCtrAtcMatch.Caption);
        end;
        cdCtrBev.Next;
      end;
      if not Rule43 then
      begin
        cdCtrBev.First;
        while not cdCtrBev.Eof do
        begin
          C2LogAdd('    Udløb testes ' + cdCtrBevFraDato.AsString + '-' + cdCtrBevTilDato.AsString);
          if (Trunc(Date) >= Trunc(cdCtrBevFraDato.AsDateTime)) and
             (Trunc(Date) <= Trunc(cdCtrBevTilDato.AsDateTime)) then
          begin
            // need to skip 47 if dosiscardlines
            if (cdCtrBevRegel.AsInteger = 47) and ( mtEksReceptStatus.AsInteger = 999) then
            begin
              cdCtrBev.Next;
              Continue;
            end;
//            if cdCtrBevVareNr.AsString <> '' then begin
            if cdCtrBevVareNr.AsString = VareNr then
                stCtrAtcMatch.Caption:= 'Varenr lighed'
            else
            begin
              // Check på ATC kode
              L:= Length(cdCtrBevAtc.AsString);
              if L > 0 then
              begin
                if cdCtrBevAtc.AsString = Copy(AtcKode, 1, L) then
                  stCtrAtcMatch.Caption:= 'ATC kode lighed'
              end
              else
              begin
                if cdCtrBevRegel.AsInteger <> 47 then
                  BlankATC := true;
                // Check på navn
                L:= Length(cdCtrBevLmNavn.AsString);
                if L > 0 then
                begin
                  if Pos(Caps(cdCtrBevLmNavn.AsString), Caps(Produkt)) > 0 then
                    stCtrAtcMatch.Caption:= 'Lægemiddelnavn lighed'
                end;
              end;
            end;
            if Pos(' lighed', stCtrAtcMatch.Caption) > 0 then
            begin
              stCtrAtcMatch.Color:= clGreen;
              // Stop på linie med lighed
              Break;
            end;
      C2LogAdd('    Status ' + stCtrAtcMatch.Caption);
          end;
          cdCtrBev.Next;
        end;


      end;

      if (stCtrAtcMatch.Caption = 'Ulighed') and (not BlankATC) then
      begin
        if mtEksReceptStatus.AsInteger = 999 then
        begin
          save_DCLindex := ffdcl.IndexName;
          ffdcl.IndexName := 'cardvaren';
          try
            if ffdcl.FindKey([DosisKortnr,VareNr]) then
            begin
              ffdcl.Edit;
              ffdclRegel4243.Clear;
              ffdcl.Post;
            end;
          finally
            ffdcl.IndexName := save_DCLindex;
          end;
        end;
        Result := False;
        exit;
      end;
      if (stCtrAtcMatch.Caption <> 'Ulighed') then
      begin
        if mtEksReceptStatus.AsInteger = 999 then
        begin
          save_DCLindex := ffdcl.IndexName;
          ffdcl.IndexName := 'cardvaren';
          try
            if ffdcl.FindKey([DosisKortnr,VareNr]) then
            begin
              if not ffdclRegel4243.IsNull then
              begin
                if ffdclRegel4243.AsBoolean then
                begin
                  mtLinTilskType.Value := 1;
                  mtLinRegelSyg.Value := cdCtrBevRegel.Value;
                  ModalResult := mrOK;
                end
                else
                begin
                  ModalResult := mrCancel;
                end;
                SkipQuestion := True;
              end;

            end;
          finally
            ffdcl.IndexName := save_DCLindex;
          end;
        end;
      end
      else
      begin
        if mtEksReceptStatus.AsInteger = 999 then
        begin
          save_DCLindex := ffdcl.IndexName;
          ffdcl.IndexName := 'cardvaren';
          try
            if ffdcl.FindKey([DosisKortnr,VareNr]) then
            begin
              if ffdclRegel4243.IsNull  then
              begin
                if cdCtrBevLmNavn.AsString = '' then
                begin
                  Result := False;
                  exit;
                end;
              end
              else
              begin
                Result := ffdclRegel4243.AsBoolean;
                exit;
              end;
            end;
          finally
            ffdcl.IndexName := save_DCLindex;
          end;
        end;

      end;
      if not SkipQuestion then
        ShowModal;
      Result:= ModalResult = mrOK;
      if ModalResult = mrOK then
      begin
        if mtEksReceptStatus.AsInteger = 999 then
        begin
          save_DCLindex := ffdcl.IndexName;
          ffdcl.IndexName := 'cardvaren';
          try
            if ffdcl.FindKey([DosisKortnr,VareNr]) then
            begin
              ffdcl.Edit;
              ffdclRegel4243.AsBoolean := True;
              ffdcl.Post;
            end;
          finally
            ffdcl.IndexName := save_DCLindex;
          end;
        end;
      end
      else
      begin
        if mtEksReceptStatus.AsInteger = 999 then
        begin
          save_DCLindex := ffdcl.IndexName;
          ffdcl.IndexName := 'cardvaren';
          try
            if ffdcl.FindKey([DosisKortnr,VareNr]) then
            begin
              ffdcl.Edit;
              ffdclRegel4243.AsBoolean := False;
              ffdcl.Post;
            end;
          finally
            ffdcl.IndexName := save_DCLindex;
          end;
        end;


      end;
    finally
      C2LogAdd('  CTR Bevilling check slutter');
    end;
  end;
end;

procedure TfmCtrBevilling.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F6 then begin
    buOk.Click;
    Key:= 0;
  end;
end;

procedure TfmCtrBevilling.buOkClick(Sender: TObject);
begin
  with MainDm do begin
    if cdCtrBevRegel.AsInteger = 47 then begin
      ChkBoxOK('Regel 47 kan ikke vælges som tilskudsregel. Vælg en anden linie.');
      dbgCtrOver.SetFocus;
      ModalResult := mrnone;
      exit;
    end;


  end;
  if Pos(' lighed', stCtrAtcMatch.Caption) > 0 then begin
    // Der peges på godkendt bevilling
    ModalResult:= mrOK;
  end else begin
    ChkBoxOk('Bevilling er valgt, selv om der er ulighed');
  end;
end;

procedure TfmCtrBevilling.dbgCtrOverDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  with MainDm do begin
    if (Trunc(Date) >= Trunc(cdCtrBevFraDato.AsDateTime)) and
       (Trunc(Date) <= Trunc(cdCtrBevTilDato.AsDateTime)) then begin
      // Bevilling OK
    end else begin
      // Bevilling udløbet
      dbgCtrOver.Canvas.Brush.Color:= clRed;
    end;
    dbgCtrOver.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

end.
