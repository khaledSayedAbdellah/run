import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map_booking/API/services.dart';
import 'package:flutter_map_booking/Components/ink_well_custom.dart';
import 'package:flutter_map_booking/Components/inputDropdown.dart';
import 'package:flutter_map_booking/Model/city.dart';
import 'package:flutter_map_booking/Model/user.dart';
import 'package:flutter_map_booking/Prefs/pref_manager.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

const double _kPickerSheetHeight = 216.0;

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> listGender = [
    {
      "id": '0',
      "name": 'Male',
    },
    {
      "id": '1',
      "name": 'Female',
    }
  ];
  String selectedGender;
  String lastSelectedValue;
  DateTime date = DateTime.now();
  var _image;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List<City> allCities = [];
  City selectedCity;

  Future getImageLibrary() async {
    var gallery =
        await ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 700);
    setState(() {
      _image = gallery;
    });
  }

  Future cameraImage() async {
    var image =
        await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 700);
    setState(() {
      _image = image;
    });
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        setState(() {
          lastSelectedValue = value;
        });
      }
    });
  }

  selectCamera() {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: Text(localize(context, 'selectCamera')),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(localize(context, 'camera')),
            onPressed: () {
              Navigator.pop(context, 'Camera');
              cameraImage();
            },
          ),
          CupertinoActionSheetAction(
            child: Text(localize(context, 'photoLibrary')),
            onPressed: () {
              Navigator.pop(context, 'Photo Library');
              getImageLibrary();
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(localize(context, 'cancel')),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
      ),
    );
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

  bool updating = false;

  updateUserDetails() async {
    if (formKey.currentState.validate()) {
      setState(() {
        updating = true;
      });
      await Services.updateUserDetails(
        PrefManager.currentUser.id,
        nameController.text,
        phoneController.text,
        1,
        selectedGender,
        emailController.text,
      ).then((data) async{
        User user = User(
          id: PrefManager.currentUser.id,
          name: nameController.text,
          image: PrefManager.currentUser.image,
          code: PrefManager.currentUser.code,
          mobile: phoneController.text,
          status: PrefManager.currentUser.status,
          gender: selectedGender,
          email: emailController.text,
          password: PrefManager.currentUser.password,
          deviceID: PrefManager.currentUser.deviceID,
          deviceType: PrefManager.currentUser.deviceType,
        );
        setState(() {
          updating = false;
          PrefManager.setUserData(user).then((value){
            // await PrefManager.initUserData();
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text(
                  data['message'],
                  textAlign: TextAlign.center,
                ),
              ),
            );
          });
        });
      });
    }
  }

  getAllCities() async {
    allCities = await Services.getAllCities();
  }

  @override
  void initState() {
    getAllCities();
    selectedGender = PrefManager.currentUser.gender;
    nameController.text = PrefManager.currentUser.name;
    phoneController.text = PrefManager.currentUser.mobile;
    selectedGender = PrefManager.currentUser.gender;
    emailController.text = PrefManager.currentUser.email ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
        title: Text(
          localize(context, 'editProfile'),
          style: TextStyle(color: blackColor),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: ButtonTheme(
          height: 50.0,
          minWidth: MediaQuery.of(context).size.width - 50,
          child: !updating
              ? RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  elevation: 0.0,
                  color: primaryColor,
                  icon: Text(''),
                  label: Text(
                    localize(context, 'save'),
                    style: headingBlack,
                  ),
                  onPressed: () {
                    // submit();
                    updateUserDetails();
                  },
                )
              : _loader(),
        ),
      ),
      body: Scrollbar(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
            child: InkWellCustom(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Form(
                key: formKey,
                child: Container(
                  color: Color(0xffeeeeee),
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: whiteColor,
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.only(bottom: 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(50.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: _image == null
                                    ? GestureDetector(
                                        onTap: () {
                                          selectCamera();
                                        },
                                        child: Container(
                                          height: 80.0,
                                          width: 80.0,
                                          color: primaryColor,
                                          child: Hero(
                                            tag: "avatar_profile",
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                "https://source.unsplash.com/300x300/?portrait",
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          selectCamera();
                                        },
                                        child: Container(
                                          height: 80.0,
                                          width: 80.0,
                                          child: Image.file(
                                            _image,
                                            fit: BoxFit.cover,
                                            height: 800.0,
                                            width: 80.0,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "Username is required";
                                        return null;
                                      },
                                      style: textStyle,
                                      decoration: InputDecoration(
                                        fillColor: whiteColor,
                                        labelStyle: textStyle,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        counterStyle: textStyle,
                                        hintText:
                                            localize(context, 'firstName'),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      controller: nameController,
                                      onChanged: (String _firstName) {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: whiteColor,
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        localize(context, 'phone'),
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "Phone is required";
                                        return null;
                                      },
                                      style: textStyle,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        fillColor: whiteColor,
                                        labelStyle: textStyle,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        counterStyle: textStyle,
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      controller: phoneController,
                                      onChanged: (String _phone) {},
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        localize(context, 'email'),
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      style: textStyle,
                                      decoration: InputDecoration(
                                        fillColor: whiteColor,
                                        labelStyle: textStyle,
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        counterStyle: textStyle,
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      controller: emailController,
                                      onChanged: (String _email) {},
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        localize(context, 'gender'),
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: DropdownButtonHideUnderline(
                                      child: Container(
                                        // padding: EdgeInsets.only(bottom: 12.0),
                                        child: InputDecorator(
                                          decoration: const InputDecoration(),
                                          // isEmpty: selectedGender == null,
                                          child: DropdownButton<String>(
                                            hint: Text(
                                              localize(context, 'gender'),
                                              style: textStyle,
                                            ),
                                            value: selectedGender,
                                            isDense: true,
                                            onChanged: (String newValue) {
                                              setState(() {
                                                selectedGender = newValue;
                                                print(selectedGender);
                                              });
                                            },
                                            items: listGender.map((value) {
                                              return DropdownMenuItem<String>(
                                                value: value['name'],
                                                child: Text(
                                                  value['name'],
                                                  style: textStyle,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        localize(context, 'city'),
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: DropdownButtonHideUnderline(
                                      child: Container(
                                        // padding: EdgeInsets.only(bottom: 12.0),
                                        child: InputDecorator(
                                          decoration: const InputDecoration(),
                                          // isEmpty: selectedGender == null,
                                          child: DropdownButton(
                                            hint: Text(
                                              localize(context, 'chooseCity'),
                                              style: textStyle,
                                            ),
                                            value: selectedCity,
                                            isDense: true,
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
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            /*Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        "Birthday",
                                        style: textStyle,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        showCupertinoModalPopup<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return _buildBottomPicker(
                                              CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .date,
                                                initialDateTime: date,
                                                onDateTimeChanged:
                                                    (DateTime newDateTime) {
                                                  setState(() {
                                                    date = newDateTime;
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: InputDropdown(
                                        valueText:
                                            DateFormat.yMMMMd().format(date),
                                        valueStyle:
                                            TextStyle(color: blackColor),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),*/
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
      ),
    );
  }
}
