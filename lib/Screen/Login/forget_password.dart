import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_booking/API/services.dart';
import 'package:flutter_map_booking/Components/ink_well_custom.dart';
import 'package:flutter_map_booking/Model/user.dart';
import 'package:flutter_map_booking/Prefs/pref_manager.dart';
import 'package:flutter_map_booking/app_router.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:flutter_map_booking/Components/validations.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController phoneController = TextEditingController();

  _loader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  bool logging = false;

  void recoverPassword() async {
    if (formKey.currentState.validate()) {
      setState(() {
        logging = true;
      });
      await Services.forgetPassword(phoneController.text).then((data) async {
        setState(() {
          logging = false;
        });
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              data['message'],
              textAlign: TextAlign.center,
            ),
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            height: 250.0,
            width: double.infinity,
            color: Color(0xFFFDD148),
          ),
          Positioned(
            bottom: 450.0,
            right: 100.0,
            child: Container(
              height: 400.0,
              width: 400.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200.0),
                color: Color(0xFFFEE16D),
              ),
            ),
          ),
          Positioned(
            bottom: 500.0,
            left: 150.0,
            child: Container(
              height: 300.0,
              width: 300.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150.0),
                color: Color(0xFFFEE16D).withOpacity(0.5),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  //padding: EdgeInsets.only(top: 100.0),
                  child: new Material(
                    borderRadius: BorderRadius.circular(7.0),
                    elevation: 5.0,
                    child: new Container(
                      width: MediaQuery.of(context).size.width - 20.0,
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: new Form(
                        key: formKey,
                        child: new Container(
                          padding: EdgeInsets.all(32.0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                localize(context, 'forgotPassword'),
                                style: heading35Black,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // Phone
                                  TextFormField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return "Phone number required";
                                      if (value.length != 11)
                                        return 'Mobile Number must be of 11 digit';
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.phone_iphone,
                                        color: Color(
                                          getColorHexFromStr(
                                            '#FEDF62',
                                          ),
                                        ),
                                        size: 20.0,
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          left: 10, top: 15.0, right: 10),
                                      hintText: localize(context, 'phone'),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ButtonTheme(
                                height: 50.0,
                                minWidth: MediaQuery.of(context).size.width,
                                child: !logging
                                    ? RaisedButton.icon(
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(
                                            15.0,
                                          ),
                                        ),
                                        elevation: 0.0,
                                        color: primaryColor,
                                        icon: new Text(''),
                                        label: new Text(
                                          localize(context, 'recoverPassword'),
                                          style: headingWhite,
                                        ),
                                        onPressed: () {
                                          recoverPassword();
                                        },
                                      )
                                    : _loader(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 20.0),
                  child: InkWell(
                    onTap: () => Navigator.of(context)
                        .popAndPushNamed(AppRoute.loginScreen),
                    child: new Text(
                      localize(context, 'backToLogin'),
                      style: textStyleActive.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
