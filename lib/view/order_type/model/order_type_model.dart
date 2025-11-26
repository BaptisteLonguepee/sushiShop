enum OrderType { dineIn, takeaway }

class OrderTypeModel {
  OrderType? selectedOrderType;
  int? tableNumber;

  OrderTypeModel({this.selectedOrderType, this.tableNumber});

  bool get isValid {
    if (selectedOrderType == null) return false;
    if (selectedOrderType == OrderType.dineIn && tableNumber == null) {
      return false;
    }
    return true;
  }

  void reset() {
    selectedOrderType = null;
    tableNumber = null;
  }
}
