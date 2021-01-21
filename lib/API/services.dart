import 'dart:convert';

import 'package:flutter_map_booking/Model/bid.dart';
import 'package:flutter_map_booking/Model/city.dart';
import 'package:flutter_map_booking/Model/taxi_type.dart';
import 'package:flutter_map_booking/Model/user_trip.dart';
import 'package:http/http.dart' as http;

class Services {
  static const String BASE_URL = "https://runtaxi.org/LatestApi/RestFul/Users";

  /*
  * 1 => City API
  * */

  static Future<List<City>> getAllCities() async {
    String url =
        "https://runtaxi.org/LatestApi/RestFul/General/ViewAllCity.php";
    http.Response response = await http.get(url);

    var data = jsonDecode(response.body);
    List cities = data['AllCity'];

    List<City> allCities = cities.map((city) => City.fromJson(city)).toList();

    return allCities;
  }

  /*
  * => Car Type API
  * */

  static Future<List<CarType>> getCarTypes() async {
    String url =
        "https://runtaxi.org/LatestApi/RestFul/Users/CarTypePrices.php";
    http.Response response = await http.get(url);

    print("Car Types url => $url");

    var data = jsonDecode(response.body);
    List cars = data['CarTypePrices'];

    List<CarType> allCars = cars.map((car) => CarType.fromJson(car)).toList();

    return allCars;
  }

  /*
  * 2 => Register User (mame, mobile, password, deviceType, deviceId, lang, city)
  * */
  static Future registerUser(
    name,
    mobile,
    password,
    city,
    gender,
    deviceId,
    deviceType,
    lang,
  ) async {
    try {
      String body = "Name=$name" +
          "&Mobile=$mobile" +
          "&Password=$password" +
          "&Devicetype=$deviceType" +
          "&Deviceid=$deviceId" +
          "&lang=$lang" +
          "&City=$city" +
          "&Gender=$gender";
      String url = "$BASE_URL/NewUser.php?$body";
      print('REGISTER URL => $url');

      http.Response response = await http.get(url);

      var data = jsonDecode(response.body);

      return data;
    } catch (ex) {
      print(ex.toString());
    }
  }

  /**
   * 3 => Login User (Mobile, password, deviceId, deviceType, lang)
   */
  static Future loginUser(
    mobile,
    password,
    deviceId,
    deviceType,
    lang,
  ) async {
    try {
      String body = "Mobile=$mobile" +
          "&Password=$password" +
          "&Devicetype=$deviceType" +
          "&Deviceid=$deviceId" +
          "&lang=$lang";
      String url = "$BASE_URL/UserLogin.php?$body";
      print('LOGIN URL => $url');

      http.Response response = await http.get(url);

      var data = jsonDecode(response.body);

      return data;
    } catch (ex) {
      print(ex.toString());
    }
  }

  /**
   * 4 => Update User Details (ID, Mobile, Name, City, Gender, Email)
   */
  static Future updateUserDetails(
      id, name, mobile, cityID, gender, email) async {
    String rawData = "UserID=$id" +
        "&Name=$name" +
        "&Mobile=$mobile" +
        "&Email=$email" +
        "&Gender=$gender" +
        "&City=$cityID";
    String url = "$BASE_URL/UpdateUserDetails.php?$rawData";

    print('UPDATE URL => $url');

    http.Response response = await http.get(url);
    var body = json.decode(response.body);

    return body;
  }

  /**
   * 5 => Forget Password (Mobile)
   */
  static Future forgetPassword(mobile) async {
    String url = "$BASE_URL/ForgetUserPassword.php?Mobile=$mobile";

    http.Response response = await http.get(url);
    var body = json.decode(response.body);

    return body;
  }

  /**
   * 6 => Show Near Drivers (Latitude & Longitude)
   */
  static Future showNearDrivers(latitude, longitude) async {
    String url = "$BASE_URL/ShowNearDriver.php?Lat=$latitude&Lon=$longitude";
    print("NEAR DRIVERS URL => $url");

    http.Response response = await http.get(url);
    var body = json.decode(response.body);

    print(body);

    return body;
  }

  /**
   * 7 => New Trip (userID, pickArea, dropArea, taxiType, distance,
      promoCode, approxTime, amount, pickLat, pickLon, dropLat, dropLon)
   */
  static Future createNewTrip(userID, pickArea, dropArea, taxiType, distance,
      promoCode, approxTime, amount, pickLat, pickLon, dropLat, dropLon) async {
    print("PICK UP AREA => $pickArea");
    String rawData = "user_id=$userID" +
        "&pickup_area=$pickArea" +
        "&drop_area=$dropArea" +
        "&taxi_type=$taxiType" +
        "&distance=$distance" +
        "&promo_code=$promoCode" +
        "&approx_time=$approxTime" +
        "&amount=$amount" +
        "&pickup_lat=$pickLat" +
        "&pickup_long=$pickLon" +
        "&drop_lat=$dropLat" +
        "&drop_long=$dropLon";
    String url = "$BASE_URL/NewTrip.php?$rawData";

    print("TRIP => ${url + rawData}");

    http.Response response = await http.get(url);
    var body = json.decode(response.body);

    return body;
  }

  /**
   * 8 => Get User Trips ()
   */
  static Future<List<UserTrip>> getUserTrips(userID) async {
    String rawData = "UserID=$userID";
    String url = "$BASE_URL/ViewAllUserTrips.php?$rawData";
    print("User Trips Url => " + url);

    http.Response response = await http.get(url);
    var body = json.decode(response.body);
    if (body['success'] != 0) {
      List trips = body["AllTrip"];

      List<UserTrip> userTrips =
          trips.map((trip) => UserTrip.fromJson(trip)).toList();

      return userTrips;
    } else {
      return null;
    }
  }

  /**
   * 9 => View Current Trip (UserID)
   */
  static Future<UserTrip> viewCurrentTrip(userID) async {
    String url = "$BASE_URL/ViewCurrentTrip.php?UserID=$userID";
    print("Current Trip Url => " + url);

    http.Response response = await http.get(url);
    var body = json.decode(response.body);

    if (body['success'] != 0) {
      List trips = body["AllTrip"];

      List<UserTrip> userTrips =
          trips.map((trip) => UserTrip.fromJson(trip)).toList();

      UserTrip currentTrip = userTrips[0];

      return currentTrip;
    } else {
      return null;
    }
  }

  /**
   * 10 => Cancel Trip (TripID)
   */
  static Future cancelTrip(tripID) async {
    String rawData = "TripID=$tripID";
    String url = "$BASE_URL/CanceTrip.php?$rawData";
    print("Cancel Trip Url => " + url);

    http.Response response = await http.get(url);
    var body = json.decode(response.body);

    return body;
  }

  /**
   * 11 => View all bids (TripID)
   */
  static Future<List<Bid>> viewTripBids(tripID) async {
    String rawData = "TripID=$tripID";
    String url = "$BASE_URL/ViewPids.php?$rawData";
    print("Trip Bids Url => " + url);

    http.Response response = await http.get(url);
    var body = json.decode(response.body);
    List bids = body['AllPids'];
    List<Bid> tripBids = bids.map((bid) => Bid.fromJson(bid)).toList();

    return tripBids;
  }

  /**
   * 12 => Accept a bid (tripID, pidID, cabID)
   */
  static Future acceptBid(tripID, pidID, cabID) async {
    String rawData = "TripID=$tripID&PidID=$pidID&CapID=$cabID";
    String url = "$BASE_URL/AcceptedPid.php?$rawData";
    print("Accept Bid Url => " + url);

    http.Response response = await http.get(url);
    var body = json.decode(response.body);

    return body;
  }
}
