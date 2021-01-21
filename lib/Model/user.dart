import 'package:flutter_map_booking/Model/city.dart';

class User {
  String id;
  String name;
  String code;
  String status;
  String password;
  String mobile;
  String deviceID;
  String deviceType;
  String gender;
  String image;
  String email;
  City city;

  User({
    this.id,
    this.name,
    this.code,
    this.status,
    this.password,
    this.mobile,
    this.deviceID,
    this.deviceType,
    this.gender,
    this.image,
    this.email,
    this.city,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['UserID'];
    name = json['name'];
    code = json['userCode'];
    status = json['user_status'];
    password = json['password'];
    mobile = json['Mobile'];
    deviceID = json['deviceID'];
    deviceType = json['deviceType'];
    gender = json['gender'];
    image = json['image'];
    email = json['email'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.id;
    data['name'] = this.name;
    data['userCode'] = this.code;
    data['user_status'] = this.status;
    data['password'] = this.password;
    data['Mobile'] = this.mobile;
    data['deviceID'] = this.deviceID;
    data['deviceType'] = this.deviceType;
    data['gender'] = this.gender;
    data['image'] = this.image;
    data['email'] = this.email;
    data['city'] = this.email;
    return data;
  }
}
