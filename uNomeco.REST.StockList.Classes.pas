unit uNomeco.REST.StockList.Classes;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TNomecoStockItems = class
  private
    FBackorderCode: string;
    FBackorderText: string;
    FCustomerNo: string;
    FDateDiscontinued: TDateTime;
    FDateExpiry: TDateTime;
    FNeverOnStock: Boolean;
    FProductNo: string;
    FQtyInStock: Integer;
    FQtyInStockBranches: Integer;
    FQtyInSupplierStock: Integer;
    FTemporaryExpired: Boolean;
  published
    property BackorderCode: string read FBackorderCode write FBackorderCode;
    property BackorderText: string read FBackorderText write FBackorderText;
    property CustomerNo: string read FCustomerNo write FCustomerNo;
    property DateDiscontinued: TDateTime read FDateDiscontinued write FDateDiscontinued;
    property DateExpiry: TDateTime read FDateExpiry write FDateExpiry;
    property NeverOnStock: Boolean read FNeverOnStock write FNeverOnStock;
    property ProductNo: string read FProductNo write FProductNo;
    property QtyInStock: Integer read FQtyInStock write FQtyInStock;
    property QtyInStockBranches: Integer read FQtyInStockBranches write FQtyInStockBranches;
    property QtyInSupplierStock: Integer read FQtyInSupplierStock write FQtyInSupplierStock;
    property TemporaryExpired: Boolean read FTemporaryExpired write FTemporaryExpired;
  end;
  
  TNomecoStockList = class(TJsonDTO)
  private
    [JSONName('Items'), JSONMarshalled(False)]
    FItemsArray: TArray<TNomecoStockItems>;
    [GenericListReflect]
    FItems: TObjectList<TNomecoStockItems>;
    function GetNomecoStockItems: TObjectList<TNomecoStockItems>;
  protected
    function GetAsJson: string; override;
  published
    property Items: TObjectList<TNomecoStockItems> read GeTNomecoStockItems;
  public
    destructor Destroy; override;
  end;
  
implementation

{ TNomecoStockList }

destructor TNomecoStockList.Destroy;
begin
  GetNomecoStockItems.Free;
  inherited;
end;

function TNomecoStockList.GetNomecoStockItems: TObjectList<TNomecoStockItems>;
begin
  Result := ObjectList<TNomecoStockItems>(FItems, FItemsArray);
end;

function TNomecoStockList.GetAsJson: string;
begin
  RefreshArray<TNomecoStockItems>(FItems, FItemsArray);
  Result := inherited;
end;

end.
