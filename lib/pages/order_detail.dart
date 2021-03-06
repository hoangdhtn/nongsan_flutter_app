import 'package:bannongsan/api_service.dart';
import 'package:bannongsan/models/customer_detail_model.dart';
import 'package:bannongsan/models/order_detail.dart';
import 'package:bannongsan/pages/base_page.dart';
import 'package:bannongsan/widgets/widget_checkponts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config.dart';

class OrderDetailsPage extends BasePage {
  //const
  int orderId;
  OrderDetailsPage({Key key, this.orderId}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends BasePageState<OrderDetailsPage> {
  APIService apiService;

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
  }

  @override
  Widget pageUI() {
    return new FutureBuilder(
      future: apiService.getOrderDetails(this.widget.orderId),
      builder: (
        BuildContext context,
        AsyncSnapshot<OrderDetailModel> orderDetailModel,
      ) {
        if (orderDetailModel.hasData) {
          return orderDetailUI(orderDetailModel.data);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget orderDetailUI(OrderDetailModel model) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "#${model.orderId.toString()}",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            model.orderDate.toString(),
            style: Theme.of(context).textTheme.labelText,
          ),
          SizedBox(height: 20),
          Text(
            "Đã gửi đến",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            model.shipping.address1,
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            model.shipping.address2,
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            "${model.shipping.city}, ${model.shipping.state}",
            style: Theme.of(context).textTheme.labelText,
          ),
          SizedBox(height: 20),
          Text(
            "Thanh toán",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            model.paymentMethod,
            style: Theme.of(context).textTheme.labelText,
          ),
          Divider(color: Colors.grey),
          Divider(color: Colors.grey),
          SizedBox(height: 5),
          CheckPoints(
            checkedTill: 0,
            checkPoints: ["Xử lý", "Giao hàng", "Đã nhận hàng"],
            checkPointFilledColor: Colors.redAccent,
          ),
          Divider(color: Colors.grey),
          _listOrderItems(model),
          Divider(color: Colors.grey),
          _itemTotal(
            "Tổng tiền",
            "${model.itemTotalAmount}",
            textStyle: Theme.of(context).textTheme.itemTotalText,
          ),
          _itemTotal("Tiền vận chuyển", "${model.shippingTotal}",
              textStyle: Theme.of(context).textTheme.itemTotalText),
          _itemTotal(
            "Trả",
            "${model.totalAmount}",
            textStyle: Theme.of(context).textTheme.itemTotalPaidText,
          ),
        ],
      ),
    );
  }

  Widget _listOrderItems(OrderDetailModel model) {
    return ListView.builder(
      itemCount: model.lineItems.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _productItems(model.lineItems[index]);
      },
    );
  }

  Widget _productItems(LineItems product) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.all(2),
      onTap: () {},
      title: new Text(
        product.productName,
        style: Theme.of(context).textTheme.productItemText,
      ),
      subtitle: Padding(
        padding: EdgeInsets.all(1),
        child: new Text("Số lượng: ${product.quantity}"),
      ),
      trailing: new Text(
          "${NumberFormat.simpleCurrency(locale: 'vi').format(int.parse(product.totalAmount.toString()))}"),
    );
  }

  Widget _itemTotal(String label, String value, {TextStyle textStyle}) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: EdgeInsets.fromLTRB(2, -10, 2, -10),
      title: new Text(
        label,
        style: textStyle,
      ),
      trailing: new Text(
          "${NumberFormat.simpleCurrency(locale: 'vi').format(int.parse(value.toString()))}"),
    );
  }
}

extension CustomStyles on TextTheme {
  TextStyle get labelHeading {
    return TextStyle(
      fontSize: 16,
      color: Colors.redAccent,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get labelText {
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get productItemText {
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle get itemTotalText {
    return TextStyle(
      fontSize: 14,
      color: Colors.black,
    );
  }

  TextStyle get itemTotalPaidText {
    return TextStyle(
      fontSize: 16.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }
}
