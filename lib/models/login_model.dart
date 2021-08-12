class LoginResponseModel {
  bool success;
  int statusCode;
  String code;
  String message;
  Data data;

  LoginResponseModel({
    this.success,
    this.statusCode,
    this.code,
    this.message,
    this.data,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    code = json['code'];
    message = json['message'];
    data = json['data'].length > 0 ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['code'] = this.code;
    data['message'] = this.message;

    if (this.data != null) {
      data['data'] = this.data.toJson();
    }

    return data;
  }
}

class Data {
  String token;
  int id;
  String email;
  String niceName;
  String lastName;
  String displayName;

  Data({
    this.token,
    this.displayName,
    this.email,
    this.id,
    this.lastName,
    this.niceName,
  });
  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    displayName = json['displayName'];
    email = json['email'];
    lastName = json['lastName'];
    niceName = json['niceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['id'] = this.id;
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    data['lastName'] = this.lastName;
    data['niceName'] = this.niceName;

    return data;
  }
}
