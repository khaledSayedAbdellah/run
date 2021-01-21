import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map_booking/API/services.dart';
import 'package:flutter_map_booking/Blocs/place_bloc.dart';
import 'package:flutter_map_booking/Components/select_address_view.dart';
import 'package:flutter_map_booking/Model/driver.dart';
import 'package:flutter_map_booking/Model/map_type_model.dart';
import 'package:flutter_map_booking/Model/place_model.dart';
import 'package:flutter_map_booking/Prefs/pref_manager.dart';
import 'package:flutter_map_booking/Screen/Menu/menu_screen.dart';
import 'package:flutter_map_booking/Screen/SearchAddress/search_address_screen.dart';
import 'package:flutter_map_booking/config.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/language/app_language.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import "package:google_maps_webservice/places.dart";

import 'select_map_type.dart';

class HomeView extends StatefulWidget {
  final PlaceBloc placeBloc;

  HomeView({this.placeBloc});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final String screenName = "HOME";
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  CircleId selectedCircle;
  int _markerIdCounter = 0;
  GoogleMapController _mapController;
  BitmapDescriptor markerIcon;
  String _placemark = '';
  GoogleMapController mapController;
  CameraPosition _position;
  bool checkPlatform = Platform.isIOS;
  bool nightMode = false;
  VoidCallback showPersBottomSheetCallBack;
  List<MapTypeModel> sampleData = new List<MapTypeModel>();
  PersistentBottomSheetController _controller;

  Position currentLocation;
  Position _lastKnownPosition;
  final Geolocator _locationService = Geolocator();
  PermissionStatus permission;
  bool isEnabledLocation = false;

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Config.apiKey);
  List<PlacesSearchResult> places = [];
  bool isLoading = false;
  String errorMessage;

  void getNearbyPlaces() async {
    /*setState(() {
      this.isLoading = true;
      this.errorMessage = null;
    });*/
    final location = Location(
      widget.placeBloc.fromLocation.lat,
      widget.placeBloc.fromLocation.lng,
    );
    final result = await _places.searchNearbyWithRadius(location, 2500);
    List<String> addresses = [];
    setState(() {
      this.isLoading = false;
      if (result.status == "OK") {
        this.places = result.results;
        /*places.forEach((element) async {
          var address = await Geocoder.local.findAddressesFromCoordinates(
            Coordinates(
              element.geometry.location.lat,
              element.geometry.location.lng,
            ),
          );
          addresses.add(address.first.countryName);
        });*/

        /*result.results.forEach((f) {
          final markerOptions = MarkerOptions(
              position:
              LatLng(f.geometry.location.lat, f.geometry.location.lng),
              infoWindowText: InfoWindowText("${f.name}", "${f.types?.first}"));
          mapController.addMarker(markerOptions);
        });*/
      } else {
        this.errorMessage = result.errorMessage;
      }
    });
  }

  initMapTypes() {
    setState(() {
      sampleData.add(MapTypeModel(1, true, 'assets/style/maptype_nomal.png',
          localize(context, 'normal'), 'assets/style/nomal_mode.json'));
      sampleData.add(MapTypeModel(2, false, 'assets/style/maptype_silver.png',
          localize(context, 'silver'), 'assets/style/sliver_mode.json'));
      sampleData.add(MapTypeModel(3, false, 'assets/style/maptype_dark.png',
          localize(context, 'dark'), 'assets/style/dark_mode.json'));
      sampleData.add(MapTypeModel(4, false, 'assets/style/maptype_night.png',
          localize(context, 'light'), 'assets/style/night_mode.json'));
      sampleData.add(MapTypeModel(5, false, 'assets/style/maptype_netro.png',
          localize(context, 'netro'), 'assets/style/netro_mode.json'));
      sampleData.add(MapTypeModel(
          6,
          false,
          'assets/style/maptype_aubergine.png',
          localize(context, 'aubergine'),
          'assets/style/aubergine_mode.json'));
    });
  }

  @override
  void initState() {
    super.initState();
//    _initLastKnownLocation();
//    _initCurrentLocation();
    fetchLocation();
    showPersBottomSheetCallBack = _showBottomSheet;
    // print("Current location : ${widget.placeBloc.formLocation.lat} / ${widget.placeBloc.formLocation.lng}");
    /*sampleData.add(MapTypeModel(1, true, 'assets/style/maptype_nomal.png',
        'عادي', 'assets/style/nomal_mode.json'));
    sampleData.add(MapTypeModel(2, false, 'assets/style/maptype_silver.png',
        'فضي', 'assets/style/sliver_mode.json'));
    sampleData.add(MapTypeModel(3, false, 'assets/style/maptype_dark.png',
        'مظلم', 'assets/style/dark_mode.json'));
    sampleData.add(MapTypeModel(4, false, 'assets/style/maptype_night.png',
        'واضح', 'assets/style/night_mode.json'));
    sampleData.add(MapTypeModel(5, false, 'assets/style/maptype_netro.png',
        'نيترو', 'assets/style/netro_mode.json'));
    sampleData.add(MapTypeModel(6, false, 'assets/style/maptype_aubergine.png',
        'اوبيرجين', 'assets/style/aubergine_mode.json'));*/
  }

  ///Get last known location
  Future<void> _initLastKnownLocation() async {
    Position position;
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;
      position = await geolocator?.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }
    if (!mounted) {
      return;
    }
    _lastKnownPosition = position;
  }

  Future<void> checkPermission() async {
    isEnabledLocation = await Permission.location.serviceStatus.isEnabled;
  }

  void fetchLocation() {
    checkPermission()?.then((_) {
      if (isEnabledLocation) {
        _initCurrentLocation();
      }
    });
  }

  /// Get current location
  Future<void> _initCurrentLocation() async {
    currentLocation = await _locationService.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    List<Placemark> placemarks = await Geolocator()?.placemarkFromCoordinates(
        currentLocation?.latitude, currentLocation?.longitude);
    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      setState(() {
        _placemark = pos.name + ', ' + pos.thoroughfare;
      });

      List<Address> address = await Geocoder.local.findAddressesFromCoordinates(
        Coordinates(
          pos.position.latitude,
          pos.position.longitude,
        ),
      );

      print("ADDRESS => ${address.first.addressLine}");

      widget?.placeBloc?.getCurrentLocation(
        Place(
          name: _placemark,
          formattedAddress: address.first.addressLine,
          lat: currentLocation?.latitude,
          lng: currentLocation?.longitude,
        ),
      ).then((value) {
        showNearDrivers(currentLocation.latitude, currentLocation.longitude)
            .then((value) {
          getNearbyPlaces();
          for (Driver driver in allNearDrivers) {
            print(driver.name);
          }
        });
      });
    }
    if (currentLocation != null) {
      moveCameraToMyLocation();
    }
  }

  void moveCameraToMyLocation() {
    _mapController?.animateCamera(
      CameraUpdate?.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation?.latitude, currentLocation?.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  /// Get current location name
  void getLocationName(double lat, double lng) async {
    if (lat != null && lng != null) {
      List<Placemark> placemarks =
          await Geolocator()?.placemarkFromCoordinates(lat, lng);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        _placemark = pos.name + ', ' + pos.thoroughfare;
        List<Address> address =
            await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(
            pos.position.latitude,
            pos.position.longitude,
          ),
        );
        print(_placemark);
        widget?.placeBloc?.getCurrentLocation(Place(
            name: _placemark,
            formattedAddress: address.first.addressLine,
            lat: lat,
            lng: lng));
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position = LatLng(
        currentLocation != null ? currentLocation?.latitude : 0.0,
        currentLocation != null ? currentLocation?.longitude : 0.0);
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      draggable: false,
      icon: checkPlatform
          ? BitmapDescriptor.fromAsset("assets/image/marker/ic_pick_48.png")
          : BitmapDescriptor.fromAsset("assets/image/marker/ic_pick_96.png"),
    );
    setState(() {
      _markers[markerId] = marker;
    });
    Future.delayed(Duration(milliseconds: 200), () async {
      _mapController = controller;
      controller?.animateCamera(
        CameraUpdate?.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 15.0,
          ),
        ),
      );
    });
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    setState(() {
      nightMode = true;
      _mapController.setMapStyle(mapStyle);
    });
  }

  void changeMapType(int id, String fileName) {
    if (fileName == null) {
      setState(() {
        nightMode = false;
        _mapController.setMapStyle(null);
      });
    } else {
      _getFileData(fileName)?.then(_setMapStyle);
    }
  }

  void _showBottomSheet() async {
    setState(() {
      showPersBottomSheetCallBack = null;
    });
    _controller = await _scaffoldKey.currentState.showBottomSheet((context) {
      return new Container(
          height: 300.0,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        localize(context, 'mapType'),
                        style: heading18Black,
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: blackColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: new GridView.builder(
                    itemCount: sampleData.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        highlightColor: Colors.red,
                        splashColor: Colors.blueAccent,
                        onTap: () {
                          _closeModalBottomSheet();
                          sampleData
                              .forEach((element) => element.isSelected = false);
                          sampleData[index].isSelected = true;
                          changeMapType(
                              sampleData[index].id, sampleData[index].fileName);
                        },
                        child: new SelectMapTypeView(sampleData[index]),
                      );
                    },
                  ),
                )
              ],
            ),
          ));
    });
  }

  void _closeModalBottomSheet() {
    if (_controller != null) {
      _controller.close();
      _controller = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<AppLanguage>(context);
    initMapTypes();
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuScreens(activeScreenName: screenName),
      body: Stack(
        children: <Widget>[
          SizedBox(
            //height: MediaQuery.of(context).size.height - 180,
            child: GoogleMap(
              markers: Set<Marker>.of(_markers.values),
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation != null
                        ? currentLocation?.latitude
                        : _lastKnownPosition?.latitude ?? 0.0,
                    currentLocation != null
                        ? currentLocation?.longitude
                        : _lastKnownPosition?.longitude ?? 0.0),
                zoom: 12.0,
              ),
              onCameraMove: (CameraPosition position) {
                if (_markers.length > 0) {
                  MarkerId markerId = MarkerId(_markerIdVal());
                  Marker marker = _markers[markerId];
                  Marker updatedMarker = marker?.copyWith(
                    positionParam: position?.target,
                  );
                  setState(() {
                    _markers[markerId] = updatedMarker;
                    _position = position;
                  });
                }
              },
              onCameraIdle: () => getLocationName(
                  _position?.target?.latitude != null
                      ? _position?.target?.latitude
                      : currentLocation?.latitude,
                  _position?.target?.longitude != null
                      ? _position?.target?.longitude
                      : currentLocation?.longitude),
            ),
          ),
          Positioned(
            bottom: 30.0,
            left: 20.0,
            right: 20.0,
            child: Container(
              height: 160.0,
              child: SelectAddress(
                fromAddress: widget?.placeBloc?.fromLocation?.formattedAddress,
                toAddress: localize(context, 'toAddress'),
                places: places,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SearchAddressScreen(),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            right: 20,
            child: GestureDetector(
              onTap: () {
                fetchLocation();
              },
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(100.0),
                  ),
                ),
                child: Icon(
                  Icons.my_location,
                  size: 20.0,
                  color: blackColor,
                ),
              ),
            ),
          ),
          langProvider.appLanguage == "en"
              ? Positioned(
                  top: 60,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      _showBottomSheet();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white),
                      child: Icon(
                        Icons.layers,
                        color: blackColor,
                      ),
                    ),
                  ),
                )
              : Positioned(
                  top: 60,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      _showBottomSheet();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white),
                      child: Icon(
                        Icons.layers,
                        color: blackColor,
                      ),
                    ),
                  ),
                ),
          langProvider.appLanguage == "en"
              ? Positioned(
                  top: 60,
                  left: 10,
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(100.0),
                        ),
                      ),
                      child: Icon(
                        Icons.menu,
                        color: blackColor,
                      ),
                    ),
                  ),
                )
              : Positioned(
                  top: 60,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState.openDrawer();
                    },
                    child: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(100.0),
                        ),
                      ),
                      child: Icon(
                        Icons.menu,
                        color: blackColor,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  List<Driver> allNearDrivers = [];

  Future showNearDrivers(lat, lng) async {
    var data = await Services.showNearDrivers(lat, lng);

    List drivers = data["AllNearDrivers"];
    allNearDrivers =
    drivers != null ? drivers.map((e) => Driver.fromJson(e)).toList() : [];
  }
}
