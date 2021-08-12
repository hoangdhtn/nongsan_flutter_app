import 'package:bannongsan/api_service.dart';
import 'package:bannongsan/models/product.dart';
import 'package:bannongsan/pages/base_page.dart';
import 'package:bannongsan/widgets/widget_product_details.dart';
import 'package:flutter/material.dart';
import '../models/variable_product.dart';

class ProductDetails extends BasePage {
  ProductDetails({Key key, this.product}) : super(key: key);

  Product product;
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends BasePageState<ProductDetails> {
  APIService apiService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget pageUI() {
    return this.widget.product.type == "variable"
        ? _varialbeProductList()
        : ProductDetailsWidget(
            data: this.widget.product,
          );
  }

  Widget _varialbeProductList() {
    apiService = new APIService();
    return new FutureBuilder(
      future: apiService.getVariableProducts(this.widget.product.id),
      builder:
          (BuildContext context, AsyncSnapshot<List<VariableProduct>> model) {
        if (model.hasData) {
          return ProductDetailsWidget(
            data: this.widget.product,
            variableProduct: model.data,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
