//
// Created by the DataSnap proxy generator.
// 19-01-2026 09:23:11
//

unit uCTRClientMethods;

interface

uses System.JSON, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type
  TServerMethods1Client = class(TDSAdminClient)
  private
    FGetCtrCommand: TDBXCommand;
    FGetTransactionListCommand: TDBXCommand;
    FCreateTransactionCommand: TDBXCommand;
    FCreateFiktivCPRCommand: TDBXCommand;
    FCreateCTRDefermentCommand: TDBXCommand;
    FUpdateCTRDefermentCommand: TDBXCommand;
    FServiceHealthCheckCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function GetCtr(AAfdelingNr: Integer; ABrugerNr: Integer; AKundenr: string; out AResponse: string; out AErrorcode: Integer; out AErrorString: string; out ALogstring: string): Boolean;
    function GetTransactionList(AAfdelingNr: Integer; ABrugerNr: Integer; AKundenr: string; ACTRAccount: string; APeriod: string; out AResponse: string; out AErrorcode: Integer; out AErrorString: string; out ALogstring: string): Boolean;
    function CreateTransaction(AAfdelingNr: Integer; ABrugerNr: Integer; AKundenr: string; ACTRAccountName: string; ALbnr: Integer; ALinienr: Integer; ABGP: Currency; AIBT: Currency; AOrdreDateTime: TDateTime; out AResponse: string; out AErrorcode: Integer; out AErrorString: string; out ALogstring: string): Boolean;
    function CreateFiktivCPR(AAfdelingNr: Integer; ABrugerNr: Integer; ACountryCode: string; ABirthdate: string; out AResponse: string; out AErrorcode: Integer; out AErrorString: string; out ALogstring: string): Boolean;
    function CreateCTRDeferment(AAfdelingNr: Integer; ABrugerNr: Integer; AKundenr: string; AStartDate: TDateTime; AEndDate: TDateTime; ADiscontinuanceReason: string; out AResponse: string; out AErrorcode: Integer; out AErrorString: string; out ALogstring: string): Boolean;
    function UpdateCTRDeferment(AAfdelingNr: Integer; ABrugerNr: Integer; AIdentifier: string; AKundenr: string; AStartDate: TDateTime; AEndDate: TDateTime; ADiscontinuanceReason: string; out AResponse: string; out AErrorcode: Integer; out AErrorString: string; out ALogstring: string): Boolean;
    function ServiceHealthCheck(out ALogstring: string): Boolean;
  end;

implementation

function TServerMethods1Client.GetCtr(AAfdelingNr: Integer; ABrugerNr: Integer; AKundenr: string; out AResponse: string; out AErrorcode: Integer; out AErrorString: string; out ALogstring: string): Boolean;
begin
  if FGetCtrCommand = nil then
  begin
    FGetCtrCommand := FDBXConnection.CreateCommand;
    FGetCtrCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetCtrCommand.Text := 'TServerMethods1.GetCtr';
    FGetCtrCommand.Prepare;
  end;
  FGetCtrCommand.Parameters[0].Value.SetInt32(AAfdelingNr);
  FGetCtrCommand.Parameters[1].Value.SetInt32(ABrugerNr);
  FGetCtrCommand.Parameters[2].Value.SetWideString(AKundenr);
  FGetCtrCommand.ExecuteUpdate;
  AResponse := FGetCtrCommand.Parameters[3].Value.GetWideString;
  AErrorcode := FGetCtrCommand.Parameters[4].Value.GetInt32;
  AErrorString := FGetCtrCommand.Parameters[5].Value.GetWideString;
  ALogstring := FGetCtrCommand.Parameters[6].Value.GetWideString;
  Result := FGetCtrCommand.Parameters[7].Value.GetBoolean;
end;

function TServerMethods1Client.GetTransactionList(AAfdelingNr: Integer; ABrugerNr: Integer; AKundenr: string; ACTRAccount: string; APeriod: string; out AResponse: string; out AErrorcode: Integer; out AErrorString: string; out ALogstring: string): Boolean;
begin
  if FGetTransactionListCommand = nil then
  begin
    FGetTransactionListCommand := FDBXConnection.CreateCommand;
    FGetTransactionListCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetTransactionListCommand.Text := 'TServerMethods1.GetTransactionList';
    FGetTransactionListCommand.Prepare;
  end;
  FGetTransactionListCommand.Parameters[0].Value.SetInt32(AAfdelingNr);
  FGetTransactionListCommand.Parameters[1].Value.SetInt32(ABrugerNr);
  FGetTransactionListCommand.Parameters[2].Value.SetWideString(AKundenr);
  FGetTransactionListCommand.Parameters[3].Value.SetWideString(ACTRAccount);
  FGetTransactionListCommand.Parameters[4].Value.SetWideString(APeriod);
  FGetTransactionListCommand.ExecuteUpdate;
  AResponse := FGetTransactionListCommand.Parameters[5].Value.GetWideString;
  AErrorcode := FGetTransactionListCommand.Parameters[6].Value.GetInt32;
  AErrorString := FGetTransactionListCommand.Parameters[7].Value.GetWideString;
  ALogstring := FGetTransactionListCommand.Parameters[8].Value.GetWideString;
  Result := FGetTransactionListCommand.Parameters[9].Value.GetBoolean;
end;

function TServerMethods1Client.CreateTransaction(AAfdelingNr: Integer; ABrugerNr: Integer; AKundenr: string; ACTRAccountName: string; ALbnr: Integer; ALinienr: Integer; ABGP: Currency; AIBT: Currency; AOrdreDateTime: TDateTime; out AResponse: string; out AErrorcode: Integer; out AErrorString: string; out ALogstring: string): Boolean;
begin
  if FCreateTransactionCommand = nil then
  begin
    FCreateTransactionCommand := FDBXConnection.CreateCommand;
    FCreateTransactionCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FCreateTransactionCommand.Text := 'TServerMethods1.CreateTransaction';
    FCreateTransactionCommand.Prepare;
  end;
  FCreateTransactionCommand.Parameters[0].Value.SetInt32(AAfdelingNr);
  FCreateTransactionCommand.Parameters[1].Value.SetInt32(ABrugerNr);
  FCreateTransactionCommand.Parameters[2].Value.SetWideString(AKundenr);
  FCreateTransactionCommand.Parameters[3].Value.SetWideString(ACTRAccountName);
  FCreateTransactionCommand.Parameters[4].Value.SetInt32(ALbnr);
  FCreateTransactionCommand.Parameters[5].Value.SetInt32(ALinienr);
  FCreateTransactionCommand.Parameters[6].Value.AsCurrency := ABGP;
  FCreateTransactionCommand.Parameters[7].Value.AsCurrency := AIBT;
  FCreateTransactionCommand.Parameters[8].Value.AsDateTime := AOrdreDateTime;
  FCreateTransactionCommand.ExecuteUpdate;
  AResponse := FCreateTransactionCommand.Parameters[9].Value.GetWideString;
  AErrorcode := FCreateTransactionCommand.Parameters[10].Value.GetInt32;
  AErrorString := FCreateTransactionCommand.Parameters[11].Value.GetWideString;
  ALogstring := FCreateTransactionCommand.Parameters[12].Value.GetWideString;
  Result := FCreateTransactionCommand.Parameters[13].Value.GetBoolean;
end;

function TServerMethods1Client.CreateFiktivCPR(AAfdelingNr: Integer; ABrugerNr: Integer; ACountryCode: string; ABirthdate: string; out AResponse: string; out AErrorcode: Integer; out AErrorString: string; out ALogstring: string): Boolean;
begin
  if FCreateFiktivCPRCommand = nil then
  begin
    FCreateFiktivCPRCommand := FDBXConnection.CreateCommand;
    FCreateFiktivCPRCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FCreateFiktivCPRCommand.Text := 'TServerMethods1.CreateFiktivCPR';
    FCreateFiktivCPRCommand.Prepare;
  end;
  FCreateFiktivCPRCommand.Parameters[0].Value.SetInt32(AAfdelingNr);
  FCreateFiktivCPRCommand.Parameters[1].Value.SetInt32(ABrugerNr);
  FCreateFiktivCPRCommand.Parameters[2].Value.SetWideString(ACountryCode);
  FCreateFiktivCPRCommand.Parameters[3].Value.SetWideString(ABirthdate);
  FCreateFiktivCPRCommand.ExecuteUpdate;
  AResponse := FCreateFiktivCPRCommand.Parameters[4].Value.GetWideString;
  AErrorcode := FCreateFiktivCPRCommand.Parameters[5].Value.GetInt32;
  AErrorString := FCreateFiktivCPRCommand.Parameters[6].Value.GetWideString;
  ALogstring := FCreateFiktivCPRCommand.Parameters[7].Value.GetWideString;
  Result := FCreateFiktivCPRCommand.Parameters[8].Value.GetBoolean;
end;

function TServerMethods1Client.CreateCTRDeferment(AAfdelingNr: Integer; ABrugerNr: Integer; AKundenr: string; AStartDate: TDateTime; AEndDate: TDateTime; ADiscontinuanceReason: string; out AResponse: string; out AErrorcode: Integer; out AErrorString: string; out ALogstring: string): Boolean;
begin
  if FCreateCTRDefermentCommand = nil then
  begin
    FCreateCTRDefermentCommand := FDBXConnection.CreateCommand;
    FCreateCTRDefermentCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FCreateCTRDefermentCommand.Text := 'TServerMethods1.CreateCTRDeferment';
    FCreateCTRDefermentCommand.Prepare;
  end;
  FCreateCTRDefermentCommand.Parameters[0].Value.SetInt32(AAfdelingNr);
  FCreateCTRDefermentCommand.Parameters[1].Value.SetInt32(ABrugerNr);
  FCreateCTRDefermentCommand.Parameters[2].Value.SetWideString(AKundenr);
  FCreateCTRDefermentCommand.Parameters[3].Value.AsDateTime := AStartDate;
  FCreateCTRDefermentCommand.Parameters[4].Value.AsDateTime := AEndDate;
  FCreateCTRDefermentCommand.Parameters[5].Value.SetWideString(ADiscontinuanceReason);
  FCreateCTRDefermentCommand.ExecuteUpdate;
  AResponse := FCreateCTRDefermentCommand.Parameters[6].Value.GetWideString;
  AErrorcode := FCreateCTRDefermentCommand.Parameters[7].Value.GetInt32;
  AErrorString := FCreateCTRDefermentCommand.Parameters[8].Value.GetWideString;
  ALogstring := FCreateCTRDefermentCommand.Parameters[9].Value.GetWideString;
  Result := FCreateCTRDefermentCommand.Parameters[10].Value.GetBoolean;
end;

function TServerMethods1Client.UpdateCTRDeferment(AAfdelingNr: Integer; ABrugerNr: Integer; AIdentifier: string; AKundenr: string; AStartDate: TDateTime; AEndDate: TDateTime; ADiscontinuanceReason: string; out AResponse: string; out AErrorcode: Integer; out AErrorString: string; out ALogstring: string): Boolean;
begin
  if FUpdateCTRDefermentCommand = nil then
  begin
    FUpdateCTRDefermentCommand := FDBXConnection.CreateCommand;
    FUpdateCTRDefermentCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FUpdateCTRDefermentCommand.Text := 'TServerMethods1.UpdateCTRDeferment';
    FUpdateCTRDefermentCommand.Prepare;
  end;
  FUpdateCTRDefermentCommand.Parameters[0].Value.SetInt32(AAfdelingNr);
  FUpdateCTRDefermentCommand.Parameters[1].Value.SetInt32(ABrugerNr);
  FUpdateCTRDefermentCommand.Parameters[2].Value.SetWideString(AIdentifier);
  FUpdateCTRDefermentCommand.Parameters[3].Value.SetWideString(AKundenr);
  FUpdateCTRDefermentCommand.Parameters[4].Value.AsDateTime := AStartDate;
  FUpdateCTRDefermentCommand.Parameters[5].Value.AsDateTime := AEndDate;
  FUpdateCTRDefermentCommand.Parameters[6].Value.SetWideString(ADiscontinuanceReason);
  FUpdateCTRDefermentCommand.ExecuteUpdate;
  AResponse := FUpdateCTRDefermentCommand.Parameters[7].Value.GetWideString;
  AErrorcode := FUpdateCTRDefermentCommand.Parameters[8].Value.GetInt32;
  AErrorString := FUpdateCTRDefermentCommand.Parameters[9].Value.GetWideString;
  ALogstring := FUpdateCTRDefermentCommand.Parameters[10].Value.GetWideString;
  Result := FUpdateCTRDefermentCommand.Parameters[11].Value.GetBoolean;
end;

function TServerMethods1Client.ServiceHealthCheck(out ALogstring: string): Boolean;
begin
  if FServiceHealthCheckCommand = nil then
  begin
    FServiceHealthCheckCommand := FDBXConnection.CreateCommand;
    FServiceHealthCheckCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FServiceHealthCheckCommand.Text := 'TServerMethods1.ServiceHealthCheck';
    FServiceHealthCheckCommand.Prepare;
  end;
  FServiceHealthCheckCommand.ExecuteUpdate;
  ALogstring := FServiceHealthCheckCommand.Parameters[0].Value.GetWideString;
  Result := FServiceHealthCheckCommand.Parameters[1].Value.GetBoolean;
end;

constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;

constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;

destructor TServerMethods1Client.Destroy;
begin
  FGetCtrCommand.DisposeOf;
  FGetTransactionListCommand.DisposeOf;
  FCreateTransactionCommand.DisposeOf;
  FCreateFiktivCPRCommand.DisposeOf;
  FCreateCTRDefermentCommand.DisposeOf;
  FUpdateCTRDefermentCommand.DisposeOf;
  FServiceHealthCheckCommand.DisposeOf;
  inherited;
end;

end.

