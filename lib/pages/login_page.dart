import 'package:bannongsan/api_service.dart';
import 'package:bannongsan/pages/home_page.dart';
import 'package:bannongsan/shared_service.dart';
import 'package:bannongsan/utils/ProgressHUD.dart';
import 'package:bannongsan/utils/form_helper.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String username;
  String password;
  APIService apiService;

  @override
  void initState() {
    apiService = new APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF7643),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFFFECDF),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                        offset: Offset(0, 10),
                        blurRadius: 20,
                      )
                    ],
                  ),
                  child: Form(
                    key: globalKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text("Đăng nhập",
                            style: TextStyle(
                                color: Color(0xFFFF7643), fontSize: 30)),
                        SizedBox(height: 20),
                        new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => username = input,
                          validator: (input) => !input.contains('@')
                              ? "Email đã được sử dụng"
                              : null,
                          decoration: new InputDecoration(
                              hintText: "Địa chỉ email",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.2),
                              )),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor)),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).accentColor,
                              )),
                        ),
                        SizedBox(height: 20),
                        new TextFormField(
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                          keyboardType: TextInputType.text,
                          onSaved: (input) => password = input,
                          validator: (input) => input.length < 3
                              ? "Mật khẩu phải hơn 3 kí tự"
                              : null,
                          obscureText: hidePassword,
                          decoration: new InputDecoration(
                            hintText: "Mật khẩu",
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.2),
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor)),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Theme.of(context).accentColor,
                            ),
                            suffixIcon: Icon(hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                        SizedBox(height: 30),
                        FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 80),
                          onPressed: () {
                            if (validateAndSave()) {
                              setState(() {
                                isApiCallProcess = true;
                              });

                              apiService
                                  .loginCustomer(username, password)
                                  .then((ret) {
                                setState(() {
                                  isApiCallProcess = false;
                                });

                                if (ret.success) {
                                  print(ret.data.token);
                                  print(ret.data.toJson());

                                  SharedService.setLoginDetails(ret);

                                  FormHelper.showMessage(
                                    context,
                                    "Nông sản việt",
                                    "Đăng nhập thành công",
                                    "OK",
                                    () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HomePage(selectedPage: 3),
                                          ),
                                          ModalRoute.withName('/Home'));
                                    },
                                  );
                                } else {
                                  FormHelper.showMessage(
                                    context,
                                    "Nông sản việt",
                                    "Đăng nhập thất bại",
                                    "OK",
                                    () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                              });
                            }
                          },
                          child: Text(
                            "Đăng nhập",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color(0xFFFF7643),
                          shape: StadiumBorder(),
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
//12p38
