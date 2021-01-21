import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map_booking/API/services.dart';
import 'package:flutter_map_booking/Components/ink_well_custom.dart';
import 'package:flutter_map_booking/Model/city.dart';
import 'package:flutter_map_booking/Model/user.dart';
import 'package:flutter_map_booking/Prefs/pref_manager.dart';
import 'package:flutter_map_booking/app_router.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/language/app_language.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:flutter_map_booking/Components/validations.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool autoValidate = false;
  Validations validations = new Validations();
  FirebaseMessaging fcm = FirebaseMessaging();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  City selectedCity;
  String selectedGender;
  String deviceID, deviceType;

  List<City> allCities = [];

  Future getAllCities() async {
    allCities = await Services.getAllCities();
  }

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

  initDeviceData() async {
    await fcm.getToken().then((token) => {deviceID = token.toString()});
    deviceType = Platform.isAndroid ? "ANDROID" : "IOS";
  }

  bool registering = false;

  void registerUser() async {
    final langProvider = Provider.of<AppLanguage>(context, listen: false);
    if (formKey.currentState.validate() &&
        selectedCity != null &&
        selectedGender != null) {
      setState(() {
        registering = true;
      });
      await Services.registerUser(
        nameController.text,
        "966${phoneController.text}",
        passwordController.text,
        selectedCity.id,
        selectedGender,
        deviceID,
        deviceType,
        '1',
      ).then((data) {
        print(data);
        if (data['success'] == 0) {
          setState(() {
            registering = false;
          });
          scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                langProvider.appLanguage == "en"
                    ? data['message']
                    : data['messageAR'],
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (data['success'] == 1) {
          setState(() {
            registering = false;
          });
          scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                langProvider.appLanguage == "en"
                    ? data['message']
                    : data['messageAR'],
                textAlign: TextAlign.center,
              ),
            ),
          );
          login();
        }
      });
    }
  }

  bool logging = false;

  void login() async {
    final langProvider = Provider.of<AppLanguage>(context, listen: false);
    if (formKey.currentState.validate()) {
      setState(() {
        logging = true;
      });
      await Services.loginUser(
        "966${phoneController.text}",
        passwordController.text,
        deviceID,
        deviceType,
        '1',
      ).then((data) async {
        if (data['success'] == 0) {
          setState(() {
            logging = false;
          });
          scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                langProvider.appLanguage == "en"
                    ? data['message']
                    : data['messageAR'],
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else if (data['success'] == 1) {
          setState(() {
            logging = false;
          });
          User user = User(
            id: data['UserID'],
            name: data['name'],
            image: data['image'],
            code: data['userCode'],
            mobile: data['Mobile'],
            status: data['user_status'],
            gender: data['user_gender'],
            email: data['Email'],
            password: passwordController.text,
            deviceID: deviceID,
            deviceType: deviceType,
          );
          await PrefManager.setUserData(user).then((value) {
            scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text(
                  localize(context, 'loggedSuccessfully'),
                  textAlign: TextAlign.center,
                ),
              ),
            );
            Navigator.of(context).pushReplacementNamed(AppRoute.homeScreen);
          });
        }
      });
    }
  }

  @override
  void initState() {
    initDeviceData();
    selectedGender = "Male";
    getAllCities().then((value) {
      selectedCity = allCities[0];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      height: MediaQuery.of(context).size.height * 0.77,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: new Form(
                        key: formKey,
                        child: new Container(
                          padding: EdgeInsets.all(32.0),
                          child: new Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                localize(context, 'signUp'),
                                style: heading35Black,
                              ),
                              SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextFormField(
                                    controller: nameController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return localize(
                                            context, 'usernameRequired');
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Color(
                                          getColorHexFromStr(
                                            '#FEDF62',
                                          ),
                                        ),
                                        size: 20.0,
                                      ),
                                      contentPadding: EdgeInsets.only(
                                        left: 10,
                                        top: 15.0,
                                        right: 10,
                                      ),
                                      hintText: localize(context, 'username'),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  // Phone
                                  TextFormField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return localize(
                                            context, 'phoneRequired');
                                      if (value.length != 9)
                                        return localize(
                                            context, 'phoneRequired2');
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      suffixText: "966",
                                      suffixStyle: TextStyle(
                                        color: Color(0xFF121212),
                                        fontSize: 18,
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
                                  SizedBox(height: 20),

                                  // Password
                                  TextFormField(
                                    controller: passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    validator: (value) {
                                      if (value.isEmpty)
                                        return localize(
                                            context, 'passwordRequired');
                                      if (value.length < 8)
                                        return localize(
                                            context, 'passwordRequired2');
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Color(
                                          getColorHexFromStr(
                                            '#FEDF62',
                                          ),
                                        ),
                                        size: 20.0,
                                      ),
                                      contentPadding: EdgeInsets.only(
                                          left: 10, top: 15.0, right: 10),
                                      hintText: localize(context, 'password'),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  // City
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_city),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: DropdownButton(
                                            value: selectedCity,
                                            underline: Container(),
                                            hint: Text(localize(
                                                context, 'chooseCity')),
                                            isExpanded: true,
                                            items: allCities
                                                .map(
                                                  (city) => DropdownMenuItem(
                                                    child: Text(city.name),
                                                    value: city,
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedCity = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),

                                  // Gender
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.wc),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: DropdownButton(
                                            value: selectedGender,
                                            underline: Container(),
                                            hint: Text(localize(
                                                context, 'chooseGender')),
                                            isExpanded: true,
                                            items: [
                                              DropdownMenuItem(
                                                child: Text('Male'),
                                                value: 'Male',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Female'),
                                                value: 'Female',
                                              ),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                selectedGender = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
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
                                          localize(context, 'next'),
                                          style: headingWhite,
                                        ),
                                        onPressed: () {
                                          registerUser();
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
                new Container(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        localize(context, 'haveAccount'),
                        style: textGrey.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 10),
                      new InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed(AppRoute.loginScreen),
                        child: new Text(
                          localize(context, 'login'),
                          style: textStyleActive.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          /*Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: new Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(top: 50.0),
                  child: new Material(
                    borderRadius: BorderRadius.circular(7.0),
                    elevation: 5.0,
                    child: new Container(
                      width: MediaQuery.of(context).size.width - 20.0,
                      height: MediaQuery.of(context).size.height * 0.9,
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
                                localize(context, 'signUp'),
                                style: heading35Black,
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: nameController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return localize(
                                        context, 'usernameRequired');
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Color(
                                      getColorHexFromStr(
                                        '#FEDF62',
                                      ),
                                    ),
                                    size: 20.0,
                                  ),
                                  contentPadding: EdgeInsets.only(
                                    left: 10,
                                    top: 15.0,
                                    right: 10,
                                  ),
                                  hintText: localize(context, 'username'),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15.0),
                              ),

                              // Phone
                              TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value.isEmpty)
                                    return localize(
                                        context, 'phoneRequired');
                                  if (value.length != 9)
                                    return localize(
                                        context, 'phoneRequired2');
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                  ),
                                  suffixText: "966",
                                  suffixStyle: TextStyle(
                                    color: Color(0xFF121212),
                                    fontSize: 18,
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
                              */ /*Row(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: TextFormField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return localize(
                                              context, 'phoneRequired');
                                        if (value.length != 10)
                                          return localize(
                                              context, 'phoneRequired2');
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
                                            getColorHexFromStr('#FEDF62'),
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
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: TextField(
                                      readOnly: true,
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.center,
                                      controller:
                                          TextEditingController.fromValue(
                                        TextEditingValue(text: "+966"),
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 10, top: 15.0, right: 10),
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),*/ /*

                              Padding(
                                padding: EdgeInsets.only(top: 15.0),
                              ),

                              // Password
                              TextFormField(
                                controller: passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty)
                                    return localize(
                                        context, 'passwordRequired');
                                  if (value.length < 8)
                                    return localize(
                                        context, 'passwordRequired2');
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Color(
                                      getColorHexFromStr(
                                        '#FEDF62',
                                      ),
                                    ),
                                    size: 20.0,
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: 10, top: 15.0, right: 10),
                                  hintText: localize(context, 'password'),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 15.0),
                              ),

                              // City
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_city),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: DropdownButton(
                                        value: selectedCity,
                                        underline: Container(),
                                        hint: Text(
                                            localize(context, 'chooseCity')),
                                        isExpanded: true,
                                        items: allCities
                                            .map(
                                              (city) => DropdownMenuItem(
                                                child: Text(city.name),
                                                value: city,
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedCity = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 15.0),
                              ),

                              // Gender
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.wc),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: DropdownButton(
                                        value: selectedGender,
                                        underline: Container(),
                                        hint: Text(
                                            localize(context, 'chooseGender')),
                                        isExpanded: true,
                                        items: [
                                          DropdownMenuItem(
                                            child: Text('Male'),
                                            value: 'Male',
                                          ),
                                          DropdownMenuItem(
                                            child: Text('Female'),
                                            value: 'Female',
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedGender = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              ButtonTheme(
                                height: 50.0,
                                minWidth: MediaQuery.of(context).size.width,
                                child: !registering
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
                                        label: Text(
                                          localize(context, 'register'),
                                          style: headingWhite,
                                        ),
                                        onPressed: () {
                                          registerUser();
                                          */ /*Navigator.of(context)
                                        .pushReplacementNamed(
                                            AppRoute.introScreen);*/ /*
                                        },
                                      )
                                    : _loader(),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      localize(context, 'haveAccount'),
                                      style: textGrey.copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    new InkWell(
                                      onTap: () => Navigator.of(context)
                                          .pushNamed(AppRoute.loginScreen),
                                      child: new Text(
                                        localize(context, 'login'),
                                        style: textStyleActive.copyWith(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),*/
        ],
      ),
    );
  }
}
