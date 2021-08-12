import 'package:bannongsan/models/login_model.dart';
import 'package:bannongsan/pages/orders_page.dart';
import 'package:bannongsan/shared_service.dart';
import 'package:bannongsan/utils/cart_icons.dart';
import 'package:bannongsan/widgets/unauth_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  //const MyAccount({ Key? key }) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class OptionList {
  String optionTitle;
  String optionSubTitle;
  IconData optionIcon;
  Function onTap;

  OptionList(
    this.optionIcon,
    this.optionTitle,
    this.optionSubTitle,
    this.onTap,
  );
}

class _MyAccountPageState extends State<MyAccount> {
  List<OptionList> options = new List<OptionList>();

  @override
  void initState() {
    super.initState();
    options.add(
      new OptionList(CartIcons.cart, "Order", "Check my order", () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrdersPage()));
      }),
    );
    options.add(
      new OptionList(Icons.edit, "Edit Profile", "Update your profile", () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => OrdersPage()));
      }),
    );
    options.add(
      new OptionList(Icons.notifications, "Notifications",
          "Check the latest notifications", () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => OrdersPage()));
      }),
    );
    options.add(
      new OptionList(
          Icons.power_settings_new, "Singout", "Check the latest notifications",
          () {
        SharedService.logout().then((value) => {setState(() {})});
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: SharedService.isLoggedIn(),
      builder: (
        BuildContext context,
        AsyncSnapshot<bool> loginModel,
      ) {
        if (loginModel.hasData) {
          if (loginModel.data) {
            return _listView(context);
          } else {
            return UnAuthWidget();
          }
        }
      },
    );
  }

  Widget _buildRow(OptionList optionList, int index) {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10),
          child: Icon(
            optionList.optionIcon,
            size: 30,
          ),
        ),
        onTap: () {
          return optionList.onTap();
        },
        title: new Text(
          optionList.optionTitle,
          style: new TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            optionList.optionSubTitle,
            style: new TextStyle(
              color: Colors.redAccent,
              fontSize: 14,
            ),
          ),
        ),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Widget _listView(BuildContext context) {
    return new FutureBuilder(
      future: SharedService.loginDetails(),
      builder:
          (BuildContext cotext, AsyncSnapshot<LoginResponseModel> loginModel) {
        if (loginModel.hasData) {
          return ListView(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chào mừng, ${loginModel.data.data.displayName}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                itemCount: options.length,
                physics: ScrollPhysics(),
                padding: EdgeInsets.all(8.0),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(16.0)),
                    child: _buildRow(options[index], index),
                  );
                },
              ),
            ],
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
