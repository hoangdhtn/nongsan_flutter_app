import 'dart:convert';
import 'dart:io';
import 'package:bannongsan/config.dart';
import 'package:bannongsan/models/customer.dart';
import 'package:bannongsan/models/customer_detail_model.dart';
import 'package:bannongsan/models/login_model.dart';
import 'package:bannongsan/models/category.dart';
import 'package:bannongsan/models/order.dart';
import 'package:bannongsan/models/order_detail.dart';
import 'package:bannongsan/models/product.dart';
import 'package:bannongsan/models/cart_response_model.dart';
import 'package:bannongsan/models/cart_request_model.dart';
import 'package:bannongsan/shared_service.dart';
import 'package:dio/dio.dart';
import 'dart:async';

import 'models/variable_product.dart';

class APIService {
  Future<bool> createCustomer(CustomerModel model) async {
    var authToken = base64.encode(
      utf8.encode(Config.key + ":" + Config.sceret),
    );

    bool ret = false;

    print(authToken);

    try {
      var response = await Dio().post(Config.url + Config.customerURL,
          data: model.toJson(),
          options: new Options(headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json'
          }));

      if (response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        ret = false;
      } else {
        ret = false;
      }
    }

    return ret;
  }

  Future<LoginResponseModel> loginCustomer(
    String username,
    String password,
  ) async {
    LoginResponseModel model;

    try {
      var response = await Dio().post(Config.tokenURL,
          data: {
            "username": username,
            "password": password,
          },
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
          }));

      if (response.statusCode == 200) {
        model = LoginResponseModel.fromJson(response.data);
        print(response);
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return model;
  }

  Future<List<Category>> getCategories() async {
    List<Category> data = new List<Category>();
    //List<Category> data = [];
    try {
      String url = Config.url +
          Config.categoriesURL +
          "?consumer_key=${Config.key}&consumer_secret=${Config.sceret}";
      var response = await Dio().get(
        url,
        options: new Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );

      if (response.statusCode == 200) {
        //print(response.data);
        data = (response.data as List)
            .map(
              (i) => Category.fromJson(i),
            )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<List<Product>> getProducts({
    String tagId,
    int pageNumber,
    int pageSize,
    String strSearch,
    String tagName,
    String categoryId,
    String sortBy,
    String sortOrder = "asc",
    List<int> productsIDs,
  }) async {
    List<Product> data = new List<Product>();
    //List<Product> data = [];
    try {
      String parameter = "";

      if (strSearch != null) {
        parameter += "&search=$strSearch";
      }

      if (pageSize != null) {
        parameter += "&per_page=$pageSize";
      }

      if (pageNumber != null) {
        parameter += "&page=$pageNumber";
      }

      if (tagName != null) {
        parameter += "&tag=$tagName";
      }

      if (categoryId != null) {
        parameter += "&category=$categoryId";
      }

      if (sortBy != null) {
        parameter += "&oderby=$sortBy";
      }

      if (sortOrder != null) {
        parameter += "&oderby=$sortOrder";
      }

      if (productsIDs != null) {
        parameter += "&include=${productsIDs.join(",").toString()}";
      }

      String url = Config.url +
          Config.productsURL +
          "?consumer_key=${Config.key}&consumer_secret=${Config.sceret}${parameter.toString()}";
      var response = await Dio().get(
        url,
        options: new Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );

      if (response.statusCode == 200) {
        //print(response.data);
        data = (response.data as List)
            .map(
              (i) => Product.fromJson(i),
            )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<CartResponseModel> addtoCart(CartRequestModel model) async {
    model.userId = int.parse(Config.userID);

    LoginResponseModel loginResponseModel = await SharedService.loginDetails();

    if (loginResponseModel.data.id != null) {
      model.userId = loginResponseModel.data.id;
    }

    CartResponseModel responseModel;

    try {
      var response = await Dio().post(
        Config.url + Config.addtoCartURL,
        data: model.toJson(),
        options: new Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );

      if (response.statusCode == 200) {
        responseModel = CartResponseModel.fromJson(response.data);
        //print(responseModel.toJson());
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }
    return responseModel;
  }

  Future<CartResponseModel> getCartItems() async {
    CartResponseModel responseModel;

    try {
      LoginResponseModel loginResponseModel =
          await SharedService.loginDetails();

      if (loginResponseModel.data != null) {
        int userId = loginResponseModel.data.id;

        String url = Config.url +
            Config.cartURL +
            "?user_id=$userId&consumer_key=${Config.key}&consumer_secret=${Config.sceret}";

        print(url);

        var response = await Dio().get(
          url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
        );

        if (response.statusCode == 200) {
          //print(response.data);
          responseModel = CartResponseModel.fromJson(response.data);
        }
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return responseModel;
  }

  Future<List<VariableProduct>> getVariableProducts(int productId) async {
    List<VariableProduct> reponseModel;

    try {
      String url = Config.url +
          Config.productsURL +
          "/${productId.toString()}/${Config.variableProductsURL}?consumer_key=${Config.key}&consumer_secret=${Config.sceret}";

      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }));

      if (response.statusCode == 200) {
        reponseModel = (response.data as List)
            .map((e) => VariableProduct.fromJson(e))
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return reponseModel;
  }

  Future<CustomerDetailsModel> customerDetails() async {
    CustomerDetailsModel responseModel;

    try {
      LoginResponseModel loginResponseModel =
          await SharedService.loginDetails();

      if (loginResponseModel.data != null) {
        int userid = loginResponseModel.data.id;

        String url = Config.url +
            Config.customerURL +
            "/${userid}?consumer_key=${Config.key}&consumer_secret=${Config.sceret}";

        var response = await Dio().get(url,
            options: new Options(headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            }));

        if (response.statusCode == 200) {
          responseModel = CustomerDetailsModel.fromJson(response.data);
        }
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }
    return responseModel;
  }

  Future<bool> createOrder(OrderModel model) async {
    // LoginResponseModel loginResponseModel = await SharedService.loginDetails();

    // if (loginResponseModel.data.id != null) {
    //   model.customerId = loginResponseModel.data.id;
    // }

    model.customerId = int.parse(Config.userID);
    print("ccc" + model.customerId.toString());

    bool isOrderCreated = false;
    var authToken =
        base64.encode(utf8.encode(Config.key + ":" + Config.sceret));

    try {
      var response = await Dio().post(
        Config.url + Config.orderURL,
        data: model.toJson(),
        options: new Options(headers: {
          HttpHeaders.authorizationHeader: 'Basic $authToken',
          HttpHeaders.contentTypeHeader: "application/json",
        }),
      );

      if (response.statusCode == 201) {
        isOrderCreated = true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }

    return isOrderCreated;
  }

  Future<List<OrderModel>> getOrders() async {
    List<OrderModel> data = new List<OrderModel>();
    int id;
    LoginResponseModel loginResponseModel = await SharedService.loginDetails();

    if (loginResponseModel.data.id != null) {
      id = loginResponseModel.data.id;
    }

    try {
      String url = Config.url +
          Config.orderURL +
          "?consumer_key=${Config.key}&consumer_secret=${Config.sceret}";

      print(url);

      var response = await Dio().get(
        url,
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        data = (response.data as List)
            .map(
              (i) => OrderModel.fromJson(i),
            )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<OrderDetailModel> getOrderDetails(
    int orderId,
  ) async {
    OrderDetailModel responseModel = new OrderDetailModel();

    try {
      String url = Config.url +
          Config.orderURL +
          "/$orderId?consumer_key=${Config.key}&consumer_secret=${Config.sceret}";

      print(url);

      var response = await Dio().get(
        url,
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        responseModel = OrderDetailModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return responseModel;
  }
}
