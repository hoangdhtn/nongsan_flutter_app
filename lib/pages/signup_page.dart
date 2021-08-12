import 'package:bannongsan/api_service.dart';
import 'package:bannongsan/models/customer.dart';
import 'package:bannongsan/utils/ProgressHUD.dart';
import 'package:bannongsan/utils/form_helper.dart';
import 'package:bannongsan/utils/validator_service.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  APIService apiService;
  CustomerModel model;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool hidePassword = true;
  bool isApiCallProcess = false;

  @override
  void initState() {
    apiService = new APIService();
    model = new CustomerModel();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text("Đăng kí"),
      ),
      body: ProgressHUD(
        child: new Form(
          key: globalKey,
          child: _formUI(),
        ),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormHelper.fieldLabel('Họ'),
              FormHelper.textInput(
                context,
                model.lastName,
                (value) {
                  this.model.lastName = value;
                },
                onValidate: (value) {
                  return null;
                },
              ),
              FormHelper.fieldLabel("Tên"),
              FormHelper.textInput(
                context,
                model.firstName,
                (value) {
                  this.model.firstName = value;
                },
                onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return 'Vui lòng nhập Tên của bạn';
                  }
                  return null;
                },
              ),
              FormHelper.fieldLabel('Email'),
              FormHelper.textInput(
                context,
                model.lastName,
                (value) {
                  this.model.email = value;
                },
                onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return "Vui lòng nhập email của bạn";
                  }
                  if (value.toString().isNotEmpty &&
                      !value.toString().isValidEmail()) {
                    return "Vui lòng nhập đúng email";
                  }
                  return null;
                },
              ),
              FormHelper.fieldLabel('Mật khẩu'),
              FormHelper.textInput(
                context,
                model.password,
                (value) {
                  this.model.password = value;
                },
                onValidate: (value) {
                  if (value.toString().isEmpty) {
                    return "Vui lòng nhập mật khẩu";
                  }
                  return null;
                },
                obscureText: hidePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  color: Theme.of(context).accentColor.withOpacity(0.4),
                  icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              new Center(
                child: FormHelper.saveButton(
                  "Đăng kí",
                  () {
                    if (validateAndSave()) {
                      print(model.toJson());
                      setState(() {
                        isApiCallProcess = true;
                      });

                      apiService.createCustomer(model).then((ret) {
                        setState(() {
                          isApiCallProcess = false;
                        });
                        if (ret) {
                          FormHelper.showMessage(context, "Ứng dụng nông sản",
                              "Đăng kí thành công", "OK", () {
                            Navigator.of(context).pop();
                          });
                        } else {
                          FormHelper.showMessage(context, "Ứng dụng nông sản",
                              "Email đã được sử dụng", "OK", () {
                            Navigator.of(context).pop();
                          });
                        }
                      });
                    }
                  },
                ),
              )
            ],
          ),
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
//17p33
