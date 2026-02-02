unit ValgForsendelse;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, ComCtrls;

type
  TfmValgFors = class(TForm)
    gbKonto: TGroupBox;
    edtFraKonto: TEdit;
    gbDatoer: TGroupBox;
    dtpFraDato: TDateTimePicker;
    dtpTilDato: TDateTimePicker;
    Label3: TLabel;
    gbTurNr: TGroupBox;
    edtFraTur: TEdit;
    udFraTur: TUpDown;
    Label1: TLabel;
    edtTilTur: TEdit;
    udTilTur: TUpDown;
    paKnapper: TPanel;
    butOK: TBitBtn;
    butFortryd: TBitBtn;
    gbEkspType: TGroupBox;
    cbxEkspTyp: TComboBox;
    cbxKontrol: TCheckBox;
    dtpFraTid: TDateTimePicker;
    dtpTilTid: TDateTimePicker;
    Panel1: TPanel;
    EdtKopi: TEdit;
    Label2: TLabel;
    edtTilKonto: TEdit;
    chkAfslutListe: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure chkAfslutListeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function UdskrivForsendelse(var oFraKonto: String;
                            var oTilKonto: String;
                            var oFraDato: TDateTime;
                            var oTilDato: TDateTime;
                             var oFraTur: Word;
                             var oTilTur: Word;
                            var oEkspTyp: Word;
                            var oKontrol: Boolean;
                            var oKopi : integer;
                            var AfslutList : boolean): Boolean;

var
  fmValgFors: TfmValgFors;

implementation

{$R *.DFM}

uses
  C2Procs,
  C2MainLog;

function UdskrivForsendelse(var oFraKonto: String;
                            var oTilKonto: String;
                          var oFraDato: TDateTime;
                          var oTilDato: TDateTime;
                           var oFraTur: Word;
                           var oTilTur: Word;
                          var oEkspTyp: Word;
                          var oKontrol: Boolean;
                            var oKopi : integer;
                            var AfslutList : boolean): Boolean;
begin
  fmValgFors:= TfmValgFors.Create(NIL);
  with fmValgFors do begin
    try
      edtFraKonto  .Text:= '';
      edtTilKonto  .Text:= '';
      dtpFraDato.Date:= oFraDato;
      dtpTilDato.Date:= oTilDato;
      dtpFraTid.Time := oFraDato;
      dtpTilTid.Time := oTilDato;
      edtFraTur .Text:= IntToStr(oFraTur);
      edtTilTur .Text:= IntToStr(oTilTur);
      cbxKontrol.Checked:= Caps(C2StrPrm('Receptkontrol', 'Forsendelse', '')) =  'JA';
      cbxKontrol.Enabled:= Caps(C2StrPrm('Receptkontrol', 'Forsendelse', '')) <> 'JA';
      fmValgFors.ShowModal;
      C2LogAdd('Leveringsliste parametre efter showmodal');
      C2LogAdd('  FraKonto: '    + edtFraKonto.Text);
      C2LogAdd('  TilKonto: '    + edtTilKonto.Text);
      C2LogAdd('  Fradato: '  + FormatDateTime('dd-mm-yyyy', dtpFraDato.Date));
      C2LogAdd('  Fradato: '  + FormatDateTime('dd-mm-yyyy', dtpTilDato.Date));
      C2LogAdd('  Fratur: '   + edtFraTur.Text);
      C2LogAdd('  Tiltur: '   + edtTilTur.Text);
      C2LogAdd('  Eksptype: ' + IntToStr(cbxEkspTyp.ItemIndex));
    finally
      Result:= fmValgFors.ModalResult = mrOK;
      if Result then begin
        oFraKonto  := edtFraKonto  .Text;
        oTilKonto  := edtTilKonto  .Text;
        if oTilKonto = '' then
          oTilKonto := edtFraKonto.Text;
        oFraDato:= dtpFraDato.Date + frac(dtpFraTid.DateTime);
        oTilDato:= dtpTilDato.Date + frac(dtpTilTid.DateTime);
        oFraTur := StrToInt(edtFraTur.Text);
        oTilTur := StrToInt(edtTilTur.Text);
        oEkspTyp:= cbxEkspTyp.ItemIndex;
        oKontrol:= cbxKontrol.Checked;
        oKopi := StrToInt(EdtKopi.Text);
        AfslutList := chkAfslutListe.Checked;
        C2LogAdd('Leveringsliste parametre efter result');
        C2LogAdd('  FraKonto: '    + oFraKonto);
        C2LogAdd('  TilKonto: '    + oTilKonto);
        C2LogAdd('  Fradato: '  + FormatDateTime('dd-mm-yyyy', oFraDato));
        C2LogAdd('  Fradato: '  + FormatDateTime('dd-mm-yyyy', oTilDato));
        C2LogAdd('  Fratur: '   + IntToStr(oFraTur));
        C2LogAdd('  Tiltur: '   + IntToStr(oTilTur));
        C2LogAdd('  Eksptype: ' + IntToStr(oEkspTyp));
      end else begin
        C2LogAdd('Leveringsliste ikke OK');
      end;
      Free;
    end;
  end;
end;

procedure TfmValgFors.FormKeyPress(Sender: TObject; var Key: Char);
  procedure TabEnter;
  begin
    SelectNext (ActiveControl, TRUE, TRUE);
    Key:= #0;
  end;
begin
  if Key = #13 then begin
    if not (ActiveControl is TRichEdit) then begin
      if (ActiveControl is TComboBox) then begin
        if not (ActiveControl as TComboBox).DroppedDown then
          TabEnter;
      end else
      if (ActiveControl is TDateTimePicker) then begin
        if not (ActiveControl as TDateTimePicker).DroppedDown then
          TabEnter;
      end else
        TabEnter;
    end;
  end else begin
    if Key = #27 then begin
      ModalResult:= mrCancel;
      Key        := #0;
    end;
  end;
  if Key <> #0 then
    Inherited;
end;

procedure TfmValgFors.FormShow(Sender: TObject);
begin
  chkAfslutListe.Checked := Caps(C2StrPrm('Receptur', 'LeveringslisteMarkerListenr', '')) = 'JA';
  edtFraKonto.SetFocus;
end;

procedure TfmValgFors.chkAfslutListeClick(Sender: TObject);
begin
  if chkAfslutListe.Checked then begin
     dtpFraDato.Date := Now - 30;
     dtpFraDato.SetFocus;
  end;
end;

end.
