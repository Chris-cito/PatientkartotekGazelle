unit uNomeco.REST.Functions;

{ Developed by: Vitec Cito A/S

  Description: Functions for calling Nomeco REST APIs

  Date/Initials   Description
  -------------   ------------------------------------------------------------------------------------------------------
  19-03-2024/cjs  Created a call for Nomeco dvr service using Chilkat

  14-03-2024/cjs  Corrected the url of the api call for Nomeco.
                  The old service was using port 7016 which was a firewall issue for all users

  01-12-2023/OB   Initial version.
}

interface

uses
  System.Classes, System.SysUtils, System.JSON, REST.Types, REST.Client,
  REST.Authenticator.OAuth, uNomeco.REST.StockList.Classes,
  StringBuilder, JsonObject,  uC2Security.Chilkat.Procs, Http,
  HttpRequest, HttpResponse;

type
  TNomecoRESTClient = class(TObject)
  private
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
    FAuthenticator: TOAuth2Authenticator;
  public
    constructor Create;
    destructor Destroy; override;
    function GetStockInfoList(
      const ACustomerNo: Integer;
      const AProductList: TStringList;
      var StockItems: TNomecoStockList;
      var ErrorMsg: string): Boolean;
    function GetStockInfoListJSON(
      const ACustomerNo: Integer;
      const AProductList: TStringList;
      var RESTRespons: TJSONArray;
      var ErrorMsg: string): Boolean;
    function GetStockInfoListJSONChilkat(
      const ACustomerNo: Integer;
      const AProductList: TStringList;
      var RESTRespons: TJSONArray;
      var ErrorMsg: string): Boolean;
    function SendSMS(
      const ACustomerNo: string;
      const AText: string;
      ARecipient: string;
      var ErrorMsg: string): Boolean;
  end;

const
//  ABaseURL: string = 'https://webservice.nomeco.dk:7016/api/fx';
  cBaseURL: string = 'https://api.nomeco.dk/api/fx/cito/products/stock-info-list';
  cBearerToken: string = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJjaXRvIiwiaXNzIjoiQVM0MDAuQlRDRU5URVIiLCJpYXQiOjE2OTg5Mzc3MjEsImV4cCI6MjAxNDI5NzcyMX0.qN3Skrz5p4WN3rVaKdyWQA8YJevXv7AFoavl94pyZK9V0OyB--MkNIBSvaMTq_b0hwSA16XcnPoTFF8pH6GVPQ';

implementation

constructor TNomecoRESTClient.Create;
begin
  FAuthenticator := TOAuth2Authenticator.Create(nil);
  FAuthenticator.TokenType := TOAuth2TokenType.ttBEARER;
  FAuthenticator.AccessToken := cBearerToken;

  FRESTClient := TRESTClient.Create(nil);
  FRESTClient.Authenticator := FAuthenticator;
  FRESTClient.BaseURL := cBaseURL;

  FRESTResponse := TRESTResponse.Create(nil);

  FRESTRequest := TRESTRequest.Create(nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
end;

destructor TNomecoRESTClient.Destroy;
begin
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
  FAuthenticator.Free;

  inherited Destroy;
end;

function TNomecoRESTClient.GetStockInfoList(
  const ACustomerNo: Integer;
  const AProductList: TStringList;
  var StockItems: TNomecoStockList;
  var ErrorMsg: string): Boolean;
var
  RESTRespons: TJSONArray;
begin
  Result := GetStockInfoListJSONChilkat
              (ACustomerNo,
               AProductList,
               RESTRespons,
               ErrorMsg);

  if Result then
    StockItems.AsJson := RESTRespons.ToString;
end;

function TNomecoRESTClient.GetStockInfoListJSON(
  const ACustomerNo: Integer;
  const AProductList: TStringList;
  var RESTRespons: TJSONArray;
  var ErrorMsg: string): Boolean;
var
  ProdNo, ProdNoString: string;
begin
  if AProductList.Count = 0 then
  begin
    Result := False;
    ErrorMsg := 'Ingen varenumre i forespørgsel';

    Exit;
  end;

  FRESTRequest.Params.Clear;

  FRESTRequest.Method := rmGET;
  FRESTRequest.Resource := 'cito/products/stock-info-list';
  FRESTRequest.AddParameter('account', IntToStr(ACustomerNo));

  for ProdNo in AProductList do
    if ProdNoString = '' then
      ProdNoString := Trim(ProdNo)
    else
      ProdNoString := ProdNoString + '&prodNo=' + Trim(ProdNo);

  FRESTRequest.Params.AddItem('prodNo', ProdNoString, TRESTRequestParameterKind.pkGETorPOST, [poDoNotEncode]);

  try
    FRESTRequest.Execute;

    ErrorMsg := 'Request: ' + FRESTRequest.GetFullRequestURL(True);

    if (FRESTResponse.StatusCode = 200) and
       (FRESTResponse.JSONValue <> nil) and
       (FRESTResponse.JSONValue.ToString <> '') then
    begin
      RESTRespons := FRESTResponse.JSONValue as TJSONArray;

      ErrorMsg := '';
      Result := True;
    end else
    begin
      ErrorMsg := ErrorMsg + #13#10 + #13#10 +
                  'Response: ' + FRESTResponse.JSONText + #13#10 + #13#10 +
                  'Error: ' + FRESTResponse.StatusText + ' - ' + IntToStr(FRESTResponse.StatusCode);

      Result := False;
    end;
  except
    on E: Exception do
    begin
      RESTRespons := nil;

      ErrorMsg := ErrorMsg + #13#10 + #13#10 +
                  'Error: ' + E.Message;

      Result := False;
    end;
  end;
end;

function TNomecoRESTClient.GetStockInfoListJSONChilkat(const ACustomerNo: Integer; const AProductList: TStringList;
  var RESTRespons: TJSONArray; var ErrorMsg: string): Boolean;
var
  ProdNo, ProdNoString: string;
  Http: HCkHttp;
  req: HCkHttpRequest;
  resp: HCkHttpResponse;
  LResponseText: string;
  LJson: HCkJsonObject;
  LJsonArray : HCkJsonArray;
  LErrorCode: Integer;
  LErrorString: string;
  LEndpointHost: string;
  LEndpointPath: string;
  LEndpointPort: Integer;
  LSsl: Boolean;
begin
  if AProductList.Count = 0 then
  begin
    Result := False;
    ErrorMsg := 'Ingen varenumre i forespørgsel';

    Exit;
  end;

  try
    Http := CkHttp_Create();
    // Create an HTTP request that has two additional params
    req := CkHttpRequest_Create();
    try
//      if chkFiddler.Checked then
//      begin
//        CkHttp_putProxyDomain(Http, pwidechar('127.0.0.1'));
//        CkHttp_putProxyPort(Http, 8888);
//      end;
//
      // To use HTTP Basic authentication..
      CkHttp_putAuthToken(Http, pwidechar(cBearerToken));

      CkHttpRequest_putHttpVerb(req, 'GET');
      CkHttpRequest_putContentType(req, 'application/json');

      CkHttpRequest_AddParam(req,'account', pwidechar(IntToStr(ACustomerNo)));

      for ProdNo in AProductList do
        CkHttpRequest_AddParam(req,'prodNo', pwidechar(ProdNo.Trim));

      SplitEndpointAddressIntoComponents(cBaseURL, LEndpointHost, LEndpointPath, LEndpointPort, LSsl);
      CkHttpRequest_putPath(req, pwidechar(LEndpointPath));

      // Send the HTTP GET and get the response.
      resp := CkHttp_SynchronousRequest(Http, pwidechar(LEndpointHost), LEndpointPort, LSsl, req);
      if (CkHttp_getLastMethodSuccess(Http) = False) then
      begin
        LErrorCode := CkHttp_getLastStatus(Http);
        LErrorString := CkHttp__lastErrorText(Http);
        ErrorMsg := Format('Http fejl : %d : Message : %s',[LErrorCode,LErrorString]);
        Exit;
      end;
      LResponseText := CkHttpResponse__bodyStr(resp);
      if CkHttpResponse_getStatusCode(resp) = 200 then
      begin
        RESTRespons := System.JSON.TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(LResponseText), 0) as TJSONArray;
        Result := True;
      end
      else
      begin
        LErrorCode := CkHttp_getLastStatus(Http);
        ErrorMsg := Format('Http fejl : %d : Message : %s',[LErrorCode,LResponseText]);
        Result :=  False;

//        AErrorCode := CkHttpResponse_getStatusCode(resp);
//        AErrorString := LResponseText;
      end;


      CkHttpResponse_Dispose(resp);
    finally
      CkHttp_Dispose(Http);
      CkHttpRequest_Dispose(req);
    end;


  except
    on E: Exception do
    begin
      RESTRespons := nil;

      ErrorMsg := ErrorMsg + #13#10 + #13#10 +
                  'Error: ' + E.Message;

      Result := False;
    end;
  end;

end;

function TNomecoRESTClient.SendSMS(
  const ACustomerNo: string;
  const AText: string;
  ARecipient: string;
  var ErrorMsg: string): Boolean;
var
  JSONObject: TJSONObject;
  CustomerNoNumeric: Integer;
begin
  FRESTRequest.Method := rmPost;
  FRESTRequest.Resource := 'sms/send';
  FRESTRequest.Params.Clear;

  try
    Result := True;

    // Make sure that the recipient phone number only contains 8 digits
    if Length(ARecipient) > 8 then
      ARecipient := Copy(ARecipient, Length(ARecipient) - 7, 8);

    // Make sure that the CustomerNo is numeric. If not, set it to zero.
    CustomerNoNumeric := StrToIntDef(ACustomerNo, 0);

    // The SMS parameters are passed as JSON in the body
    JSONObject := TJSONObject.Create;
    JSONObject.AddPair('customerNo', IntToStr(CustomerNoNumeric));
    JSONObject.AddPair('phoneNumber', ARecipient);
    JSONObject.AddPair('message', AText);

    FRESTRequest.AddBody(JSONObject.ToString, ctAPPLICATION_JSON);

    FRESTRequest.Execute;

//    // If the JSON response does not contain the key "msid", an error has occurred
//    if (FRESTResponse.JSONValue as TJSONObject).FindValue('msid') = nil then
//    begin
//      ErrorMsg := 'Request: ' + FRESTRequest.GetFullRequestURL(True) + #13#10 +
//                  'Body: ' + JSONObject.ToString + #13#10 +
//                  'Response: ' + FRESTResponse.Content;
//
//      Result := False;
//    end;

    JSONObject.Free;
  except
    on E: Exception do
    begin
      ErrorMsg := 'Error: ' + E.Message;

      Result := False;
    end;
  end;
end;

end.
