import 'package:flutter/cupertino.dart';

import '../provider/razor_payment_service.dart';

class PaymentMethod {
  String id;
  String name;
  String description;
  String logo;
  String route;
  Function onTap;
  bool isRouteRedirect;

  PaymentMethod(
    this.id,
    this.name,
    this.description,
    this.logo,
    this.route,
    this.onTap,
    this.isRouteRedirect,
  );
}

class PaymentMethodList {
  List<PaymentMethod> _paymentsList;
  List<PaymentMethod> _cashList;

  PaymentMethodList(BuildContext _context) {
    this._paymentsList = [
      new PaymentMethod(
        "razorpay",
        "RazorPay",
        "Mua với ví RazorPay",
        "assets/img/razorpay.png",
        "/RazorPay",
        () {
          RazorPaymentService razorPaymentService = new RazorPaymentService();
          razorPaymentService.initPaymentGateway(_context);
          razorPaymentService.getPayment(_context);
        },
        false,
      ),
      new PaymentMethod(
        "paypal",
        "Paypal",
        "Mua với ví Paypal",
        "assets/img/paypal.png",
        "/Paypal",
        () {},
        true,
      )
    ];
    this._cashList = [
      new PaymentMethod(
        "cod",
        "Thanh toán tiền mặt",
        "Mua với ví tiền mặt",
        "assets/img/cash.png",
        "/OrderSuccess",
        () {},
        false,
      )
    ];
  }

  List<PaymentMethod> get paymentsList => _paymentsList;
  List<PaymentMethod> get cashList => _cashList;
}
