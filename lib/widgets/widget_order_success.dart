import 'package:bannongsan/pages/checkout_base.dart';
import 'package:bannongsan/pages/home_page.dart';
import 'package:bannongsan/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSuccessWidget extends CheckoutBasePage {
  //const OrderSuccessWidget({ Key? key }) : super(key: key);

  @override
  _OrderSuccessWidgetState createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState
    extends CheckoutBasePageState<OrderSuccessWidget> {
  @override
  void initState() {
    this.currentPage = 2;
    this.showBackbutton = false;

    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.createOder();
    super.initState();
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(
      builder: (context, orderModel, child) {
        if (orderModel.isOrderCreated) {
          return Center(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Colors.green.withOpacity(1),
                                Colors.green.withOpacity(0.2),
                              ]),
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 90,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Align(
                    child: Text("Bạn đã thanh toán thành công!"),
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                    child: Text(
                      "Xong",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          ModalRoute.withName('/Home'));
                    },
                    padding: EdgeInsets.all(15),
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
