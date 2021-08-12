import 'package:bannongsan/models/order.dart';
import 'package:bannongsan/pages/order_detail.dart';
import 'package:flutter/material.dart';

class WidgetOrderItem extends StatelessWidget {
  //const WidgetOrderItem({ Key? key }) : super(key: key);
  OrderModel orderModel;
  WidgetOrderItem({this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          _orderStatus(this.orderModel.status),
          Divider(color: Colors.grey),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconText(
                Icon(
                  Icons.edit,
                  color: Colors.redAccent,
                ),
                Text(
                  "Mã thanh toán",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                this.orderModel.orderNumber.toString(),
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              iconText(
                Icon(
                  Icons.today,
                  color: Colors.redAccent,
                ),
                Text(
                  "Ngày thanh toán",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                this.orderModel.orderDate.toString(),
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              flatBotton(
                Row(
                  children: [Text("  Chi tiết  "), Icon(Icons.chevron_right)],
                ),
                Colors.green,
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(
                                orderId: this.orderModel.orderId,
                              )));
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget iconText(Icon iconWidget, Text textWidget) {
    return Row(
      children: [iconWidget, SizedBox(width: 5), textWidget],
    );
  }

  Widget _orderStatus(String status) {
    Icon icon;
    Color color;

    if (status == "pending" || status == "processing" || status == "on-hold") {
      icon = Icon(Icons.timer, color: Colors.orange);
      color = Colors.orange;
      status = "Đang chờ";
    } else if (status == "completed") {
      icon = Icon(Icons.check, color: Colors.green);
      color = Colors.green;
      status = "Thành công";
    } else if (status == "cancelled" ||
        status == "refunded" ||
        status == "failed") {
      icon = Icon(Icons.clear, color: Colors.redAccent);
      color = Colors.redAccent;
      status = "Hủy bỏ";
    } else {
      icon = Icon(Icons.clear, color: Colors.redAccent);
      color = Colors.redAccent;
    }

    return iconText(
        icon,
        Text(
          "Thanh toán: $status",
          style: TextStyle(
            fontSize: 15,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  Widget flatBotton(
    Widget iconText,
    Color color,
    Function onPressd,
  ) {
    return FlatButton(
        child: iconText,
        onPressed: onPressd,
        padding: EdgeInsets.all(5),
        color: color,
        shape: StadiumBorder());
  }
}
