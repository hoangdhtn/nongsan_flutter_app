import 'package:bannongsan/pages/checkout_base.dart';
import 'package:bannongsan/pages/home_page.dart';
import 'package:bannongsan/pages/login_page.dart';
import 'package:bannongsan/pages/signup_page.dart';
import 'package:bannongsan/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnAuthWidget extends StatefulWidget {
  // const UnAuthWidget({ Key? key }) : super(key: key);

  @override
  _UnAuthWidgetState createState() => _UnAuthWidgetState();
}

class _UnAuthWidgetState extends State<UnAuthWidget> {
  @override
  Widget build(BuildContext context) {
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
                    Icons.lock,
                    color: Colors.white,
                    size: 90,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Align(
              child: Text("Bạn cần phải đăng nhập để thao tác!"),
            ),
            SizedBox(height: 20),
            FlatButton(
              child: Text(
                "Đăng nhập",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              padding: EdgeInsets.all(15),
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Align(
              child: Text("Nếu bạn chưa có tài khoản!"),
            ),
            SizedBox(height: 20),
            FlatButton(
              child: Text(
                "Đăng ký",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              padding: EdgeInsets.all(15),
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
