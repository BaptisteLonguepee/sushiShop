enum OrderType { dineIn, takeaway }

class OrderTypeModel {
  OrderType? selectedOrderType;
  int? tableNumber;

  OrderTypeModel({this.selectedOrderType, this.tableNumber});

  bool get isValid {
    return selectedOrderType != null;
  }

  void reset() {
    selectedOrderType = null;
    tableNumber = null;
  }
}
