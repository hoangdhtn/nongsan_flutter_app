import 'package:bannongsan/models/cart_response_model.dart';
import 'package:bannongsan/provider/cart_provider.dart';
import 'package:bannongsan/provider/loader_provider.dart';
import 'package:bannongsan/utils/custom_stepper.dart';
import 'package:bannongsan/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatelessWidget {
  //const CartProduct({ Key? key }) : super(key: key);

  CartProduct({this.data});
  CartItem data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: makeListTitle(context),
      ),
    );
  }

  ListTile makeListTitle(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        leading: Container(
          width: 50,
          height: 150,
          alignment: Alignment.center,
          child: Image.network(data.thumbnail),
        ),
        title: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            data.variationId == 0
                ? data.productName
                : "${data.productName} (${data.attributeValue}${data.attribute})",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.all(5),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                '${NumberFormat.simpleCurrency(locale: 'vi').format(int.parse(data.productSalePrice))}',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text(
                      "X??a",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  Utils.showMessage(
                      context,
                      "N??ng s???n",
                      "B???n mu???n x??a s???n ph???m n??y?",
                      "X??a",
                      () {
                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(true);
                        Provider.of<CartProvider>(context, listen: false)
                            .removeItem(data.productId);
                        Provider.of<LoaderProvider>(context, listen: false)
                            .setLoadingStatus(false);

                        Navigator.of(context).pop();
                      },
                      buttonText2: "H???y",
                      isConfirmationDialog: true,
                      onPressed2: () {
                        Navigator.of(context).pop();
                      });
                },
                padding: EdgeInsets.all(8),
                color: Colors.redAccent,
                shape: StadiumBorder(),
              ),
            ],
          ),
        ),
        trailing: Container(
          width: 120,
          child: CustomStepper(
            lowerLimit: 0,
            upperLimit: 20,
            stepValue: 1,
            iconSize: 22.0,
            value: data.qty,
            onChanged: (value) {
              Provider.of<CartProvider>(context, listen: false).updateQty(
                  data.productId, value,
                  variationId: data.variationId);
            },
          ),
        ),
      );
}
