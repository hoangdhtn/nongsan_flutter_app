import 'package:bannongsan/models/customer_detail_model.dart';

class OrderDetailModel {
  int orderId;
  String orderNumber;
  String paymentMethod;
  String orderStatus;
  DateTime orderDate;
  Shipping shipping;
  List<LineItems> lineItems;
  int totalAmount;
  int shippingTotal;
  int itemTotalAmount;

  OrderDetailModel({
    this.orderId,
    this.orderNumber,
    this.paymentMethod,
    this.orderStatus,
    this.orderDate,
    this.shipping,
    this.lineItems,
    this.totalAmount,
    this.shippingTotal,
    this.itemTotalAmount,
  });

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    orderId = json["id"]; //int.parse(json["customer_id"].toString());
    orderNumber = json["order_key"];
    paymentMethod = json["payment_method_title"];
    orderStatus = json["status"];
    orderDate = DateTime.parse(json["date_created"]);
    shipping = json['shipping'] != null
        ? new Shipping.fromJson(json['shipping'])
        : null;

    if (json["line_items"] != null) {
      lineItems = new List<LineItems>();
      json['line_items'].forEach((v) {
        lineItems.add(new LineItems.fromJson(v));
      });
    }

    itemTotalAmount = lineItems != null
        ? lineItems.map<int>((e) => e.totalAmount).reduce((a, b) => a + b)
        : 0;

    totalAmount = int.parse(json['total']);
    shippingTotal = int.parse(json['shipping_total']);
  }
}

class LineItems {
  int productId;
  String productName;
  int quantity;
  int variationId;
  int totalAmount;

  LineItems({
    this.productId,
    this.productName,
    this.quantity,
    this.variationId,
    this.totalAmount,
  });

  LineItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['name'];
    quantity = json['quantity'];
    variationId = json['variation_id'];
    totalAmount = int.parse(json['total']);
  }
}
