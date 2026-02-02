unit uTMJ.REST.Functions;

{ Developed by: Vitec Cito A/S

  Description: Functions for calling TMJ REST APIs

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  21-03-2024/cjs  Change the TMJ stock servers to use production hosts

  05-03-2024/OB   Modified to temporarily use Chilkat for service calls to TMJ.
                  The reason for this is that TMJ is deprecating TLS 1.0 and 1.1 and TRestClient
                  compiled in Delphi XE7 does not support TLS 1.2.
                  Patientkartotek is using these functions as well, and is for now compiled with Delphi XE7.
                  When Patientkartotek is compiled with Delphi 10.4, we can switch back to using TRestClient.

  01-12-2023/OB   Initial version.
}

interface

uses
  System.Classes, System.SysUtils, System.JSON, REST.Types, REST.Client,
  REST.Authenticator.Basic, uTMJ.REST.StockList.Classes,
  Rest, StringBuilder, JSONObject;

type
  TTMJRESTClient = class(TObject)
  private
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
    FAuthenticator: THTTPBasicAuthenticator;
  public
    constructor Create;
    destructor Destroy; override;
    function GetStockInfoList(
      const ACustomerNo: Integer;
      const AProductList: TStringList;
      var StockItems: TTMJStockList;
      var ErrorMsg: string): Boolean;
    function GetStockInfoListJSON(
      const ACustomerNo: Integer;
      const AProductList: TStringList;
      var RESTRespons: TJSONArray;
      var ErrorMsg: string): Boolean;
  end;

const
  // PROD
  ABaseURL:  string = 'https://webplus.tmj.dk';
  ABasePath: string = '/odata/V1/ProductStockInfos';
  AUsername: string = 'svc@citodata';
  APassword: string = 'UBwC5lthTYWxac0Fj$sWGJteGxC0!pDRS$XV3WfxbQW$3';

implementation

constructor TTMJRESTClient.Create;
begin
  FAuthenticator := THTTPBasicAuthenticator.Create(nil);
  FAuthenticator.Username := AUserName;
  FAuthenticator.Password := APassword;

  FRESTClient := TRESTClient.Create(nil);
  FRESTClient.Authenticator := FAuthenticator;
  FRESTClient.BaseURL := ABaseURL;

  FRESTResponse := TRESTResponse.Create(nil);

  FRESTRequest := TRESTRequest.Create(nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
end;

destructor TTMJRESTClient.Destroy;
begin
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
  FAuthenticator.Free;

  inherited Destroy;
end;

function TTMJRESTClient.GetStockInfoList(
  const ACustomerNo: Integer;
  const AProductList: TStringList;
  var StockItems: TTMJStockList;
  var ErrorMsg: string): Boolean;
var
  RESTRespons: TJSONArray;
begin
  RESTRespons := TJSONArray.Create;

  try
    Result := GetStockInfoListJSON
                (ACustomerNo,
                 AProductList,
                 RESTRespons,
                 ErrorMsg);

    if Result then
      StockItems.AsJson := RESTRespons.ToString;
  finally
    RESTRespons.Free;
  end;
end;

function TTMJRESTClient.GetStockInfoListJSON(
  const ACustomerNo: Integer;
  const AProductList: TStringList;
  var RESTRespons: TJSONArray;
  var ErrorMsg: string): Boolean;
var
  REST: HCkRest;
  ProdNo, RESTURL: string;
  RequestBodyString: string;
  RequestBody, ResponseBody: HCkStringBuilder;
  ResponseJson: HCkJsonObject;
begin
  if AProductList.Count = 0 then
  begin
    Result := False;
    ErrorMsg := 'Ingen varenumre i forespørgsel';

    Exit;
  end;

  REST := CkRest_Create;

  RequestBody := CkStringBuilder_Create;

  ResponseJSON := CkJsonObject_Create;
  ResponseBody := CkStringBuilder_Create;

  RESTURL := ABaseURL;

  Result := CkRest_Connect(REST, PWideChar(RESTURL), 443, True, True);

  if Result then
    Result := CkRest_SetAuthBasic(REST, PWideChar(AUserName), PWideChar(APassword));


  RequestBodyString := '<ArrayOfstring xmlns:i="http://www.w3.org/2001/XMLSchema-instance" ' +
                       'xmlns="http://schemas.microsoft.com/2003/10/Serialization/Arrays">';

  CkStringBuilder_Append(RequestBody, PWideChar(RequestBodyString));
  for ProdNo in AProductList do
    CkStringBuilder_Append(RequestBody, PWideChar('<string>' + Trim(ProdNo) + '</string>'));
  CkStringBuilder_Append(RequestBody, '</ArrayOfstring>');

  CkRest_AddHeader(REST, 'Content-Type', 'application/XML');
  CkRest_AddHeader(REST, 'Accept', 'application/json');

  if Result then
    Result := CkRest_FullRequestSb(REST,
                                   'POST',
                                   PWideChar(ABasePath + '/GetProductStockInfos(AccountNumber=' + IntToStr(ACustomerNo) + ')'),
                                   RequestBody,
                                   ResponseBody);

  Result := CkRest_getLastMethodSuccess(REST);

  if Result then
  begin
    if Pos('"ErrorCode"', CkStringBuilder__getAsString(ResponseBody)) > 0 then
    begin
      ErrorMsg := 'Fejl i TMJ vareforespørgsel: ' + #13#10 + CkStringBuilder__getAsString(ResponseBody);
      Result := False;
    end else
    begin
      try
        RESTRespons := System.JSON.TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(CkStringBuilder__getAsString(ResponseBody)), 0) as TJSONArray;
      except
        on E:Exception do
        begin
          ErrorMsg := 'Fejl i TMJ vareforespørgsel: ' + E.Message + #13#10 +
                      CkStringBuilder__getAsString(ResponseBody);
          Result := False;
        end;
      end;
    end;
  end else
    ErrorMsg := CkRest__lastErrorText(REST);

  CkRest_Dispose(REST);
  CkJsonObject_Dispose(ResponseJSON);
  CkStringBuilder_Dispose(RequestBody);
  CkStringBuilder_Dispose(ResponseBody);
end;


//
// Use Chilkat (above) until Patientkartotek Delphi 10 is in production
//
//function TTMJRESTClient.GetStockInfoListJSON(
//  const ACustomerNo: Integer;
//  const AProductList: TStringList;
//  var RESTRespons: TJSONArray;
//  var ErrorMsg: string): Boolean;
//var
//  ProdNo, RequestBody: string;
//begin
//  if AProductList.Count = 0 then
//  begin
//    Result := False;
//    ErrorMsg := 'Ingen varenumre i forespørgsel';
//
//    Exit;
//  end;
//
//  FRESTRequest.Params.Clear;
//
//  FRESTRequest.Method := rmPost;
//  FRESTRequest.Resource := ABasePath + '/GetProductStockInfos(AccountNumber=' + IntToStr(ACustomerNo) + ')';
//
//  RequestBody := '<ArrayOfstring xmlns:i="http://www.w3.org/2001/XMLSchema-instance" ' +
//                 'xmlns="http://schemas.microsoft.com/2003/10/Serialization/Arrays">' + #13#10;
//  for ProdNo in AProductList do
//    RequestBody := RequestBody + '  <string>' + Trim(ProdNo) + '</string>' + #13#10;
//
//  RequestBody := RequestBody + '</ArrayOfstring>';
//
//  FRESTRequest.ClearBody;
//  FRESTRequest.AddBody(RequestBody, ctAPPLICATION_XML);
//
//  try
//    FRESTRequest.Execute;
//
//    ErrorMsg := 'Request: ' + FRESTRequest.GetFullRequestURL(True);
//
//    if (FRESTResponse.StatusCode = 200) and
//       (FRESTResponse.JSONValue <> nil) and
//       (FRESTResponse.JSONValue.ToString <> '') then
//    begin
//      RESTRespons := FRESTResponse.JSONValue as TJSONArray;
//
//      ErrorMsg := '';
//      Result := True;
//    end else
//    begin
//      ErrorMsg := ErrorMsg + #13#10 + #13#10 +
//                  'Response: ' + FRESTResponse.Content + #13#10 + #13#10 +
//                  'Error: ' + FRESTResponse.StatusText + ' - ' + IntToStr(FRESTResponse.StatusCode);
//
//      Result := False;
//    end;
//  except
//    on E: Exception do
//    begin
//      RESTRespons := nil;
//
//      ErrorMsg := ErrorMsg + #13#10 + #13#10 +
//                  'Error: ' + E.Message;
//
//      Result := False;
//    end;
//  end;
//end;

end.
