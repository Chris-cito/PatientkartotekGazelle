unit uTMJ.REST.StockList.Classes;

interface

uses
 Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
 TTMJStockItems = class
 private
 FItemId: string;
 FOnStock: Integer;
 FPhoneUS: string;
 FRemark: string;
 FWorstExpiryDate: string;
 published
 property ItemId: string read FItemId write FItemId;
 property OnStock: Integer read FOnStock write FOnStock;
 property PhoneUS: string read FPhoneUS write FPhoneUS;
 property Remark: string read FRemark write FRemark;
 property WorstExpiryDate: string read FWorstExpiryDate write FWorstExpiryDate;
 End;
 
 TTMJStockList = class(TJsonDTO)  private
 [JSONName('Items'), JSONMarshalled(False)
] 
 FItemsArray: TArray<TTMJStockItems>;
 [GenericListReflect]
 FItems: TObjectList<TTMJStockItems>;
 function GetTMJStockItems: TObjectList<TTMJStockItems>;
 protected
 function GetAsJson: string; override;
 published
 property Items: TObjectList<TTMJStockItems> read GeTTMJStockItems;
 public
 destructor Destroy; override;
 End;
 
implementation

{ TTMJStockList }

destructor TTMJStockList.Destroy;
begin
 GetTMJStockItems.Free;
 inherited;
End;

function TTMJStockList.GetTMJStockItems: TObjectList<TTMJStockItems>;
begin
 Result := ObjectList<TTMJStockItems>(FItems, FItemsArray);
End;

function TTMJStockList.GetAsJson: string;
begin
 RefreshArray<TTMJStockItems>(FItems, FItemsArray);
 Result := inherited;
End;

End.
