//import 'package:bannongsan/models/category.dart';
//import 'package:flutter/material.dart';

import 'package:bannongsan/models/variable_product.dart';

class Product {
  int id;
  String name;
  String description;
  String shortDescription;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  String stockStatus;
  String weight;
  List<Images> images;
  List<Categories> categories;
  List<Attributes> attributes;
  List<int> relatedIds;
  String type;
  VariableProduct variableProduct;

  Product({
    this.id,
    this.name,
    this.description,
    this.shortDescription,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.stockStatus,
    this.attributes,
    this.weight,
    this.relatedIds,
    this.type,
    this.variableProduct,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    shortDescription = json['short_description'];
    sku = json['sku'];
    price = json['price'];
    regularPrice = json['regular_price'];
    weight = json['weight'];
    salePrice =
        json['sale_price'] != "" ? json['sale_price'] : json['regula_price'];

    stockStatus = json['stock_status'];
    relatedIds = json['cross_sell_ids'].cast<int>();
    type = json['type'];
    if (json['categories'] != null) {
      //categories = new List<Categories>();
      List<Categories> categories = [];
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }

    if (json['images'] != null) {
      images = new List<Images>();
      //List<Images> images = [];
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }

    if (json["attributes"] != null) {
      attributes = new List<Attributes>();
      //List<Images> images = [];
      json["attributes"].forEach((v) {
        attributes.add(new Attributes.fromJson(v));
      });
    }
  }

  calculateDisCount() {
    double disPercent = 0;
    if (this.regularPrice != "") {
      double regularPrice = double.parse(this.regularPrice);
      double salePrice =
          this.salePrice != "" ? double.parse(this.salePrice) : regularPrice;
      double discount = regularPrice - salePrice;
      disPercent = (discount / regularPrice) * 100;
    }
    return disPercent.round();
  }
}

class Categories {
  int id;
  String name;

  Categories({this.id, this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Images {
  String src;

  Images({
    this.src,
  });

  Images.fromJson(Map<String, dynamic> json) {
    src = json['src'];
  }
}

class Attributes {
  int id;
  String name;
  List<String> options;

  Attributes({this.id, this.name, this.options});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    options = json["options"].cast<String>();
  }
}
