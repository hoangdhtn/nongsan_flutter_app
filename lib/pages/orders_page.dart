import 'package:bannongsan/models/order.dart';
import 'package:bannongsan/pages/base_page.dart';
import 'package:bannongsan/provider/order_provider.dart';
import 'package:bannongsan/widgets/widget_order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends BasePage {
  //const OrdersPage({ Key? key }) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends BasePageState<OrdersPage> {
  @override
  void initState() {
    super.initState();
    var orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrders();
  }

  @override
  Widget pageUI() {
    //return _listView(context, orders);
    return new Consumer<OrderProvider>(builder: (
      context,
      ordersModel,
      child,
    ) {
      if (ordersModel.allOrders != null && ordersModel.allOrders.length > 0) {
        return _listView(context, ordersModel.allOrders);
      }
      print(ordersModel.allOrders);

      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget _listView(BuildContext context, List<OrderModel> order) {
    return ListView(
      children: [
        ListView.builder(
          itemCount: order.length,
          physics: ScrollPhysics(),
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(16.0),
              ),
              child: WidgetOrderItem(
                orderModel: order[index],
              ),
            );
          },
        )
      ],
    );
  }
}
