import 'package:bannongsan/config.dart';
import 'package:bannongsan/widgets/widget_home_categories.dart';
import 'package:bannongsan/widgets/widget_home_products.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            imageCarousel(context),
            WidgetCategories(),
            WidgetHomeProducts(
              labelName: 'Tiết kiệm nhất!',
              tagId: Config.todayOffersTagId,
            ),
            WidgetHomeProducts(
              labelName: 'Sản phẩm của ngày!',
              tagId: Config.topSellingProductsTagId,
            )
          ],
        ),
      ),
    );
  }

  Widget imageCarousel(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      child: new Carousel(
        overlayShadow: false,
        borderRadius: true,
        boxFit: BoxFit.none,
        autoplay: true,
        dotSize: 4.0,
        images: [
          FittedBox(
            fit: BoxFit.fill,
            child: Image.network(
                "http://openleague.club/bannongsan/wp-content/uploads/2021/04/unnamed-324x324.jpg"),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Image.network(
                "http://openleague.club/bannongsan/wp-content/uploads/2021/04/download.jpg"),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Image.network(
                "http://openleague.club/bannongsan/wp-content/uploads/2021/04/x1331_gia_lua_gao_10.jpgqrt20200923055440.pagespeed.ic_.n3TmB5MUWE-324x324.jpg"),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Image.network(
                "http://openleague.club/bannongsan/wp-content/uploads/2021/04/other-small.jpg"),
          )
        ],
      ),
    );
  }
}
