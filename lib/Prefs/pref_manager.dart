import 'package:flutter_map_booking/Model/user.dart';
import 'package:flutter_map_booking/Prefs/pref_keys.dart';
import 'package:flutter_map_booking/Prefs/pref_utils.dart';

class PrefManager{
  static User currentUser = User();

  static Future initUserData() async{
    currentUser.id = await getUserID();
    currentUser.name = await getUserName();
    currentUser.image = await getUserImage();
    currentUser.email = await getUserEmail();
    currentUser.mobile = await getUserMobile();
    currentUser.password = await getUserPassword();
    currentUser.gender = await getUserGender();
    currentUser.code = await getUserCode();
    currentUser.status = await getUserStatus();
    currentUser.deviceID = await getUserDeviceID();
    currentUser.deviceType = await getUserDeviceType();
  }

  // SETTERS
  static Future setUserData(User user) async{
    await setUserID(user.id);
    await setUserName(user.name);
    await setUserStatus(user.status);
    await setUserCode(user.code);
    await setUserEmail(user.email);
    await setUserImage(user.image);
    await setUserGender(user.gender);
    await setUserMobile(user.mobile);
    await setUserPassword(user.password);
    await setUserDeviceID(user.deviceID);
    await setUserDeviceType(user.deviceType);
  }

  static Future setUserID(String id) async{
    currentUser.id = id;
    await PrefUtils.setString(PrefKeys.USER_ID, id);
  }

  static Future setUserName(String name) async{
    currentUser.name = name;
    await PrefUtils.setString(PrefKeys.USER_NAME, name);
  }

  static Future setUserImage(String image) async{
    currentUser.image = image;
    await PrefUtils.setString(PrefKeys.USER_IMAGE, image);
  }

  static Future setUserCode(String code) async{
    currentUser.code = code;
    await PrefUtils.setString(PrefKeys.USER_CODE, code);
  }

  static Future setUserStatus(String status) async{
    currentUser.status = status;
    await PrefUtils.setString(PrefKeys.USER_STATUS, status);
  }

  static Future setUserPassword(String password) async{
    currentUser.password = password;
    await PrefUtils.setString(PrefKeys.USER_PASSWORD, password);
  }

  static Future setUserDeviceID(String deviceID) async{
    currentUser.deviceID = deviceID;
    await PrefUtils.setString(PrefKeys.USER_DEVICE_ID, deviceID);
  }

  static Future setUserDeviceType(String deviceType) async{
    currentUser.deviceType = deviceType;
    await PrefUtils.setString(PrefKeys.USER_DEVICE_TYPE, deviceType);
  }

  static Future setUserGender(String gender) async{
    currentUser.gender = gender;
    await PrefUtils.setString(PrefKeys.USER_GENDER, gender);
  }

  static Future setUserMobile(String mobile) async{
    currentUser.mobile = mobile;
    await PrefUtils.setString(PrefKeys.USER_MOBILE, mobile);
  }

  static Future setUserEmail(String email) async{
    currentUser.email = email;
    await PrefUtils.setString(PrefKeys.USER_EMAIL, email);
  }

  // GETTERS
  static Future<String> getUserID() async{
    return await PrefUtils.getString(PrefKeys.USER_ID);
  }

  static Future<String> getUserName() async{
    return await PrefUtils.getString(PrefKeys.USER_NAME);
  }

  static Future<String> getUserImage() async{
    return await PrefUtils.getString(PrefKeys.USER_IMAGE);
  }

  static Future<String> getUserStatus() async{
    return await PrefUtils.getString(PrefKeys.USER_STATUS);
  }

  static Future<String> getUserCode() async{
    return await PrefUtils.getString(PrefKeys.USER_CODE);
  }

  static Future<String> getUserPassword() async{
    return await PrefUtils.getString(PrefKeys.USER_PASSWORD);
  }

  static Future<String> getUserGender() async{
    return await PrefUtils.getString(PrefKeys.USER_GENDER);
  }

  static Future<String> getUserDeviceID() async{
    return await PrefUtils.getString(PrefKeys.USER_DEVICE_ID);
  }

  static Future<String> getUserDeviceType() async{
    return await PrefUtils.getString(PrefKeys.USER_DEVICE_TYPE);
  }

  static Future<String> getUserMobile() async{
    return await PrefUtils.getString(PrefKeys.USER_MOBILE);
  }

  static Future<String> getUserEmail() async{
    return await PrefUtils.getString(PrefKeys.USER_EMAIL);
  }
}