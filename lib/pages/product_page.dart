import 'dart:async';

//import 'package:bannongsan/api_service.dart';
import 'package:bannongsan/models/product.dart';
import 'package:bannongsan/pages/base_page.dart';
import 'package:bannongsan/provider/products_provider.dart';
import 'package:bannongsan/widgets/widget_product_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SortBy {
  String value;
  String text;
  String sortOrder;

  SortBy(this.value, this.text, this.sortOrder);
}

class ProductPage extends BasePage {
  ProductPage({Key key, this.categoryId}) : super(key: key);

  int categoryId;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends BasePageState<ProductPage> {
  int _page = 1;
  ScrollController _scrollController = new ScrollController();

  final _searchQuery = new TextEditingController();
  Timer _debounce;

  final _sortByOptions = [
    SortBy("popularity", "Popularity", "asc"),
    SortBy("modified", "Latest", "asc"),
    SortBy("price", "Price: High to Low", "desc"),
    SortBy("price", "Price: Low to High", "asc"),
  ];

  @override
  void initState() {
    var productsList = Provider.of<ProductProvider>(context, listen: false);
    productsList.resetStreams();
    productsList.setLoadingState(LoadMoreStatus.INITIAL);
    productsList.fetchProducts(_page,
        categoryId: this.widget.categoryId.toString());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        productsList.setLoadingState(LoadMoreStatus.LOADING);
        productsList.fetchProducts(++_page,
            categoryId: this.widget.categoryId.toString());
      }
    });

    _searchQuery.addListener(_onSearchChange);
    super.initState();
  }

  _onSearchChange() {
    var productsList = Provider.of<ProductProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce.cancel();

    _debounce = Timer(const Duration(milliseconds: 3000), () {
      productsList.resetStreams();
      productsList.setLoadingState(LoadMoreStatus.INITIAL);
      productsList.fetchProducts(_page, strSearch: _searchQuery.text);
    });
  }

  @override
  Widget pageUI() {
    return _productsList();
  }

  Widget _productsList() {
    return new Consumer<ProductProvider>(
      builder: (context, productsModel, child) {
        if (productsModel.allProducts != null &&
            productsModel.allProducts.length > 0 &&
            productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
          return _buildList(productsModel.allProducts,
              productsModel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildList(List<Product> items, bool isLoadMore) {
    return Column(
      children: [
        _productFilter(),
        Flexible(
          child: GridView.count(
            shrinkWrap: true,
            controller: _scrollController,
            crossAxisCount: 2,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: items.map((Product item) {
              return ProductCart(
                data: item,
              );
            }).toList(),
          ),
        ),
        Visibility(
          child: Container(
            padding: EdgeInsets.all(5),
            height: 35.0,
            width: 35.0,
            child: CircularProgressIndicator(),
          ),
          visible: isLoadMore,
        ),
      ],
    );

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: items.map((Product item) {
        return ProductCart(
          data: item,
        );
      }).toList(),
    );
  }

  Widget _productFilter() {
    return Container(
      height: 51,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _searchQuery,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Tìm kiếm",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Color(0xffe6e6ec),
                  filled: true),
            ),
          ),
          SizedBox(width: 15),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffe6e6ec),
              borderRadius: BorderRadius.circular(9.0),
            ),
            child: PopupMenuButton(
              onSelected: (sortBy) {
                setState(() {
                  var productsList =
                      Provider.of<ProductProvider>(context, listen: false);
                  productsList.resetStreams();
                  productsList.setSortOrder(sortBy);
                  productsList.fetchProducts(_page);
                });
                //print(sortBy + ' là giá trị');
              },
              itemBuilder: (BuildContext context) {
                return _sortByOptions.map((item) {
                  return PopupMenuItem(
                    value: item.value,
                    child: Container(
                      child: Text(item.text),
                    ),
                  );
                }).toList();
              },
              icon: Icon(Icons.tune),
            ),
          ),
        ],
      ),
    );
  }
}
