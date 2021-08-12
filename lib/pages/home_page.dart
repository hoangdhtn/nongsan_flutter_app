import 'package:bannongsan/models/payment_method.dart';
import 'package:bannongsan/pages/cart_page.dart';
import 'package:bannongsan/pages/dashboard_page.dart';
import 'package:bannongsan/pages/my_account.dart';
import 'package:bannongsan/pages/order_detail.dart';
import 'package:bannongsan/pages/orders_page.dart';
import 'package:bannongsan/pages/payment_screen.dart';
import 'package:bannongsan/provider/cart_provider.dart';
import 'package:bannongsan/utils/cart_icons.dart';
import 'package:bannongsan/widgets/widget_order_item.dart';
import 'package:bannongsan/widgets/widget_payment_method_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  int selectedPage;
  HomePage({Key key, this.selectedPage}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _widgetList = [
    DashboardPage(),
    CartPage(),
    OrdersPage(),
    MyAccount(),
    //OrderDetailsPage(),
    // PaymentMethodListItem(
    //   paymentMethod: new PaymentMethod(
    //     "razorpay",
    //     "RazorPay",
    //     "Thanh toán với ví RazorPay",
    //     "assets/img/razorpay.png",
    //     "/RazorPay",
    //     () {},
    //     false,
    //   ),
    // ),
  ];

  int _index = 0;

  @override
  void initState() {
    super.initState();

    if (this.widget.selectedPage != null) {
      _index = this.widget.selectedPage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CartIcons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(CartIcons.cart),
            label: 'Giỏ hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(CartIcons.favourites),
            label: 'Yêu thích',
          ),
          BottomNavigationBarItem(
            icon: Icon(CartIcons.account),
            label: 'Tài khoản',
          ),
        ],
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
      body: _widgetList[_index],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        title: Text(
          "Nông sản",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
            onPressed: null,
          ),
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
              height: 150.0,
              width: 30.0,
              child: new GestureDetector(
                child: new Stack(
                  children: <Widget>[
                    new IconButton(
                      icon: new Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      onPressed: null,
                    ),
                    Provider.of<CartProvider>(context, listen: false)
                                .cartItems
                                .length ==
                            0
                        ? new Container()
                        : new Positioned(
                            child: new Stack(
                            children: <Widget>[
                              new Icon(Icons.brightness_1,
                                  size: 20.0, color: Colors.green[800]),
                              new Positioned(
                                  top: 3.0,
                                  right: 6.0,
                                  child: new Center(
                                    child: new Text(
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .cartItems
                                          .length
                                          .toString(),
                                      style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                            ],
                          )),
                  ],
                ),
              ),
            ),
          ),
        ]);
  }
}
