import 'package:bannongsan/api_service.dart';
import 'package:bannongsan/models/order.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  APIService _apiService;

  List<OrderModel> _orderList;
  List<OrderModel> get allOrders => _orderList;
  double get totalRecords => _orderList.length.toDouble();

  OrderProvider() {
    resetStreams();
  }

  void resetStreams() {
    _apiService = APIService();
  }

  fetchOrders() async {
    List<OrderModel> orderList = await _apiService.getOrders();

    if (_orderList == null) {
      _orderList = new List<OrderModel>();
    }

    if (orderList.length > 0) {
      _orderList = [];
      print(orderList);
      _orderList.addAll(orderList);
    }

    notifyListeners();
  }
}
