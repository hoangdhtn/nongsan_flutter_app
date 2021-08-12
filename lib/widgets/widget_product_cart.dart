import 'package:bannongsan/models/product.dart';
import 'package:bannongsan/pages/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCart extends StatelessWidget {
  ProductCart({Key key, this.data}) : super(key: key);

  Product data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetails(
                product: data,
              ),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
          ],
        ),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Visibility(
                    visible: data.calculateDisCount() > 0,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          '${data.calculateDisCount()}%',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xffE65829).withAlpha(40),
                        ),
                        Image.network(
                          data.images.length > 0
                              ? data.images[0].src
                              : "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/450px-No_image_available.svg.png",
                          height: 160,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    data.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: data.salePrice != data.regularPrice,
                        child: Text(
                          data.type == "variable"
                              ? '${NumberFormat.simpleCurrency(locale: 'vi').format(int.parse(data.price))}'
                              : '${NumberFormat.simpleCurrency(locale: 'vi').format(int.parse(data.regularPrice))}',
                          style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        data.type == "variable"
                            ? '${NumberFormat.simpleCurrency(locale: 'vi').format(int.parse(data.price))}'
                            : '${NumberFormat.simpleCurrency(locale: 'vi').format(int.parse(data.salePrice))}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
