import 'package:bannongsan/models/customer_detail_model.dart';

class OrderModel {
  int customerId;
  String paymentMethod;
  String paymentMethodTitle;
  bool setPaid;
  String transactionId;
  List<LineItems> lineItems;

  int orderId;
  String orderNumber;
  String status;
  DateTime orderDate;
  Shipping shipping;

  OrderModel(
      {this.customerId,
      this.paymentMethod,
      this.paymentMethodTitle,
      this.setPaid,
      this.transactionId,
      this.lineItems,
      this.orderId,
      this.orderNumber,
      this.status,
      this.orderDate,
      this.shipping});

  OrderModel.fromJson(Map<String, dynamic> json) {
    customerId = int.parse(json["customer_id"].toString());
    orderId = json["id"];
    status = json["status"];
    orderNumber = json["order_key"];
    orderDate = DateTime.parse(json["date_created"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['payment_method'] = this.paymentMethod;
    data['payment_method_title'] = this.paymentMethodTitle;
    data['set_paid'] = this.setPaid;
    data['transaction_id'] = this.transactionId;
    data['shipping'] = this.shipping;

    if (lineItems != null) {
      data['line_items'] = lineItems.map((e) => e.toJson()).toList();
    }

    return data;
  }
}

class LineItems {
  int productId;
  int quantity;
  int variationId;

  LineItems({this.productId, this.quantity, this.variationId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;

    if (this.variationId != null) {
      data['variation_id'] = this.variationId;
    }

    return data;
  }
}
