import 'package:bannongsan/provider/loader_provider.dart';
import 'package:bannongsan/utils/ProgressHUD.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/widget_checkponts.dart';

class CheckoutBasePage extends StatefulWidget {
  // const CheckoutBasePage({ Key? key }) : super(key: key);

  @override
  CheckoutBasePageState createState() => CheckoutBasePageState();
}

class CheckoutBasePageState<T extends CheckoutBasePage> extends State<T> {
  int currentPage = 0;
  bool showBackbutton = true;

  @override
  void initState() {
    super.initState();
    print("CheckoutBasePage: initState");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (context, loaderModel, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: Colors.white,
          body: ProgressHUD(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CheckPoints(
                    checkedTill: currentPage,
                    checkPoints: [
                      "Đang chuyển hàng",
                      "Thanh toán",
                      "Đặt hàng",
                    ],
                    checkPointFilledColor: Colors.green,
                  ),
                  Divider(color: Colors.white),
                  pageUI(),
                ],
              ),
            ),
            inAsyncCall: loaderModel.isApiCallProcess,
            opacity: 0.3,
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      brightness: Brightness.dark,
      elevation: 0,
      backgroundColor: Colors.redAccent,
      automaticallyImplyLeading: showBackbutton,
      title: Text(
        "Thanh toán",
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[],
    );
  }

  Widget pageUI() {
    return null;
  }
}
