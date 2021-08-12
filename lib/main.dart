import 'dart:io';

import 'package:bannongsan/pages/base_page.dart';
import 'package:bannongsan/pages/cart_page.dart';
import 'package:bannongsan/pages/home_page.dart';
import 'package:bannongsan/pages/orders_page.dart';
import 'package:bannongsan/pages/paypal_payment.dart';
import 'package:bannongsan/pages/product_page.dart';
import 'package:bannongsan/provider/order_provider.dart';
import 'package:bannongsan/provider/products_provider.dart';
import 'package:bannongsan/provider/loader_provider.dart';
import 'package:bannongsan/provider/cart_provider.dart';
import 'package:bannongsan/widgets/widget_product_cart.dart';
import 'package:bannongsan/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/signup_page.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
          child: ProductPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
          child: BasePage(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
          child: OrdersPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: ProductCart(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: CartPage(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nông sản',
        home: LoginPage(),
        routes: <String, WidgetBuilder>{
          '/Paypal': (BuildContext context) => new PaypalPaymentScreen(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'ProductSans',
          primaryColor: Colors.white,
          brightness: Brightness.light,
          accentColor: Colors.redAccent,
          dividerColor: Colors.redAccent,
          focusColor: Colors.redAccent,
          hintColor: Colors.redAccent,
          textTheme: TextTheme(
            headline4: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
              height: 1.3,
            ),
            headline2: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
              height: 1.4,
            ),
            headline3: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.3,
            ),
            subtitle1: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.3,
            ),
            caption: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w300,
              color: Colors.grey,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
