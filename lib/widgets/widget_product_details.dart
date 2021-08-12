import 'package:bannongsan/models/product.dart';
import 'package:bannongsan/models/variable_product.dart';
import 'package:bannongsan/utils/custom_stepper.dart';
import 'package:bannongsan/utils/expand_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bannongsan/widgets/widget_related_products.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bannongsan/models/cart_request_model.dart';
import 'package:provider/provider.dart';
import '../provider/loader_provider.dart';
import '../provider/cart_provider.dart';
import '../api_service.dart';

class ProductDetailsWidget extends StatelessWidget {
  ProductDetailsWidget({Key key, this.data, this.variableProduct})
      : super(key: key);

  Product data;
  List<VariableProduct> variableProduct;
  final CarouselController _controller = CarouselController();
  int qty = 0;

  CartProducts cartProducts = new CartProducts();

  APIService _apiService = new APIService();

  @override
  Widget build(BuildContext context) {
    cartProducts.quantity = 0;
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                productImages(data.images, context),
                SizedBox(height: 10),
                Visibility(
                  visible: data.calculateDisCount() > 0,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.green),
                      child: Text(
                        'Giảm ${data.calculateDisCount()}%',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: data.type != "variable",
                      child: Text(
                        data.attributes != null && data.attributes.length > 0
                            ? (data.attributes[0].options.join("-").toString() +
                                "" +
                                data.attributes[0].name)
                            : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: data.type == "variable",
                      child: selectDropdown(context, "", this.variableProduct,
                          (VariableProduct value) {
                        this.data.price = value.price;
                        this.data.variableProduct = value;
                      }),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          data.attributes != null && data.attributes.length > 0
                              ? (data.attributes[0].options
                                      .join("-")
                                      .toString() +
                                  "" +
                                  data.attributes[0].name)
                              : "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Giá: ${NumberFormat.simpleCurrency(locale: 'vi').format(int.parse(data.price))}',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Số lượng : '),
                        CustomStepper(
                          lowerLimit: 0,
                          upperLimit: 20,
                          stepValue: 1,
                          iconSize: 22.0,
                          value: this.qty,
                          onChanged: (value) {
                            if (value != 0) {
                              cartProducts.quantity = value;
                            } else {
                              cartProducts.quantity = 0;
                            }
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FlatButton(
                          onPressed: () {
                            Provider.of<LoaderProvider>(context, listen: false)
                                .setLoadingStatus(true);
                            var cartProvider = Provider.of<CartProvider>(
                                context,
                                listen: false);
                            cartProducts.productId = data.id;
                            cartProducts.variationId =
                                data.variableProduct != null
                                    ? data.variableProduct.id
                                    : 0;
                            print(cartProducts.toJson());
                            cartProvider.addToCart(cartProducts, (val) {
                              Provider.of<LoaderProvider>(context,
                                      listen: false)
                                  .setLoadingStatus(false);
                            });
                          },
                          child: Text(
                            "Thêm vào giỏ hàng",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.redAccent,
                          padding: EdgeInsets.all(15),
                          shape: StadiumBorder(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                ExpandText(
                  labelHeader: 'Thông tin sản phẩm',
                  desc: data.shortDescription,
                  shortDesc: data.description,
                ),
                Divider(),
                SizedBox(height: 10),
                WidgetRelatedProducts(
                  labelName: "Sản phẩm liên quan",
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget productImages(List<Images> images, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: CarouselSlider.builder(
              itemCount: images.length,
              itemBuilder: (context, index, realIndex) {
                return Container(
                  child: Center(
                    child: Image.network(
                      images[index].src,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 1,
                aspectRatio: 1.0,
              ),
              carouselController: _controller,
            ),
          ),
          Positioned(
            top: 100,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                _controller.previousPage();
              },
            ),
          ),
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width - 80,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                _controller.nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget selectDropdown(
    BuildContext context,
    Object initialValue,
    dynamic data,
    Function onChanged, {
    Function onValidate,
  }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 75,
        width: 100,
        padding: EdgeInsets.only(top: 5),
        child: new DropdownButtonFormField<VariableProduct>(
          hint: new Text("Chọn"),
          value: null,
          isDense: true,
          decoration: fiedDecoration(context, "", ""),
          onChanged: (VariableProduct newValue) {
            FocusScope.of(context).requestFocus(new FocusNode());
            onChanged(newValue);
          },
          items: data != null
              ? data.map<DropdownMenuItem<VariableProduct>>(
                  (VariableProduct data) {
                    return DropdownMenuItem(
                      value: data,
                      child: new Text(
                        data.attributes.first.option +
                            " " +
                            data.attributes.first.name,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ).toList()
              : null,
        ),
      ),
    );
  }

  static InputDecoration fiedDecoration(
    BuildContext context,
    String hintText,
    String helperText, {
    Widget prefixIcon,
    Widget suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(6),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );
  }
}
