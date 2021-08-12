import 'package:bannongsan/models/cart_response_model.dart';
import 'package:bannongsan/pages/payment_screen.dart';
import 'package:bannongsan/pages/verify_address.dart';
import 'package:bannongsan/provider/cart_provider.dart';
import 'package:bannongsan/provider/loader_provider.dart';
import 'package:bannongsan/shared_service.dart';
import 'package:bannongsan/utils/ProgressHUD.dart';
import 'package:bannongsan/widgets/unauth_widget.dart';
import 'package:bannongsan/widgets/widget_cart_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  //const CartPage({ Key? key }) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    var cartItemsList = Provider.of<CartProvider>(context, listen: false);
    cartItemsList.resetStreams();
    cartItemsList.fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: SharedService.isLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> loginModel) {
        if (loginModel.hasData) {
          if (loginModel.data) {
            return Consumer<LoaderProvider>(
                builder: (context, loaderModel, child) {
              return Scaffold(
                  body: ProgressHUD(
                child: SingleChildScrollView(
                  child: _cartItemsList(),
                ),
                inAsyncCall: loaderModel.isApiCallProcess,
                opacity: 0.3,
              ));
            });
          } else {
            return UnAuthWidget();
          }
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
    //   return Scaffold(
    //       body: ProgressHUD(
    //     child: SingleChildScrollView(
    //       child: _cartItemsList(),
    //     ),
    //     inAsyncCall: loaderModel.isApiCallProcess,
    //     opacity: 0.3,
    //   ));
    // });
  }

  Widget _cartItemsList() {
    return new Consumer<CartProvider>(
      builder: (context, cartModel, child) {
        if (cartModel.cartItems != null && cartModel.cartItems.length > 0) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: cartModel.cartItems.length,
                    itemBuilder: (context, index) {
                      return CartProduct(
                        data: cartModel.cartItems[index],
                      );
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: FlatButton(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Icons.sync,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(
                        "Cập nhật",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Provider.of<LoaderProvider>(context, listen: false)
                        .setLoadingStatus(true);
                    var cartProvider =
                        Provider.of<CartProvider>(context, listen: false);

                    cartProvider.updateCart(
                      (val) {
                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(false);
                      },
                    );
                  },
                  padding: EdgeInsets.all(15),
                  color: Colors.green,
                  shape: StadiumBorder(),
                ),
              ),
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text(
                            'Tổng',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                          new Text(
                            '${cartModel.totalAmount}' + ' đ',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      FlatButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              "Thanh toán",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifyAddress(),
                              ));
                        },
                        padding: EdgeInsets.all(15),
                        color: Colors.redAccent,
                        shape: StadiumBorder(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}

//30.39
