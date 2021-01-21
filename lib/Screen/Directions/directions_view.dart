import 'dart:async';
import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_booking/API/services.dart';
import 'package:flutter_map_booking/Blocs/place_bloc.dart';
import 'package:flutter_map_booking/Components/autoRotationMarker.dart' as rm;
import 'package:flutter_map_booking/Components/loading.dart';
import 'package:flutter_map_booking/Model/bid.dart';
import 'package:flutter_map_booking/Model/taxi_type.dart';
import 'package:flutter_map_booking/Model/user_trip.dart';
import 'package:flutter_map_booking/Prefs/pref_manager.dart';
import 'package:flutter_map_booking/Screen/Directions/screens/chat_screen/chat_screen.dart';
import 'package:flutter_map_booking/Screen/Directions/widgets/arriving_detail_widget.dart';
import 'package:flutter_map_booking/Screen/Directions/widgets/booking_detail_widget.dart';
import 'package:flutter_map_booking/app_router.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/data/Model/direction_model.dart';
import 'package:flutter_map_booking/language/app_language.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Networking/Apis.dart';
import '../../data/Model/direction_model.dart';
import '../../data/Model/get_routes_request_model.dart';
import '../../google_map_helper.dart';
import 'widgets/select_service_widget.dart';

class DirectionsView extends StatefulWidget {
  final PlaceBloc placeBloc;

  DirectionsView({this.placeBloc});

  @override
  _DirectionsViewState createState() => _DirectionsViewState();
}

class _DirectionsViewState extends State<DirectionsView> {
  List<CarType> listService = [];
  CarType selectedTaxi;
  TextEditingController promoController = TextEditingController();
  TextEditingController optionsController = TextEditingController();

  UserTrip currentTrip = UserTrip();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<LatLng> points = <LatLng>[];
  GoogleMapController _mapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;
  BitmapDescriptor markerIcon;

  Map<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;

  bool checkPlatform = Platform.isIOS;
  String distance, duration;
  bool isLoading = false;
  bool isResult = false;
  LatLng positionDriver;
  bool isComplete = false;
  var apis = Apis();
  List<Routes> routesData;
  final GMapViewHelper _gMapViewHelper = GMapViewHelper();
  PanelController panelController = new PanelController();
  String selectedService;

  void _onMapCreated(GoogleMapController controller) {
    this._mapController = controller;
  }

  Future getCarTypes() async {
    await Services.getCarTypes().then((data) {
      setState(() {
        listService = data;
        selectedTaxi = data[0];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCarTypes();
    getCurrentTrip();
    addMakers();
    getRouter();
  }

  @override
  void dispose() {
    super.dispose();
  }

  addMakers() {
    checkPlatform ? print('ios') : print("adnroid");
    final MarkerId markerIdFrom = MarkerId("from_address");
    final MarkerId markerIdTo = MarkerId("to_address");

    final Marker marker = Marker(
      markerId: markerIdFrom,
      position: LatLng(widget?.placeBloc?.fromLocation?.lat,
          widget?.placeBloc?.fromLocation?.lng),
      infoWindow: InfoWindow(
          title: widget?.placeBloc?.fromLocation?.name,
          snippet: widget?.placeBloc?.fromLocation?.formattedAddress),
      icon: checkPlatform
          ? BitmapDescriptor.fromAsset("assets/image/marker/ic_dropoff_48.png")
          : BitmapDescriptor.fromAsset("assets/image/marker/ic_dropoff_96.png"),
      onTap: () {},
    );

    final Marker markerTo = Marker(
      markerId: markerIdTo,
      position: LatLng(widget?.placeBloc?.locationSelect?.lat,
          widget?.placeBloc?.locationSelect?.lng),
      infoWindow: InfoWindow(
          title: widget?.placeBloc?.locationSelect?.name,
          snippet: widget?.placeBloc?.locationSelect?.formattedAddress),
      icon: checkPlatform
          ? BitmapDescriptor.fromAsset("assets/image/marker/ic_pick_48.png")
          : BitmapDescriptor.fromAsset("assets/image/marker/ic_pick_48.png"),
      onTap: () {},
    );

    setState(() {
      markers[markerIdFrom] = marker;
      markers[markerIdTo] = markerTo;
    });
  }

  ///Calculate and return the best router
  void getRouter() async {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    final PolylineId polylineId = PolylineId(polylineIdVal);
    polyLines.clear();
    var router;
    LatLng _fromLocation = LatLng(widget?.placeBloc?.fromLocation?.lat,
        widget?.placeBloc?.fromLocation?.lng);
    LatLng _toLocation = LatLng(widget?.placeBloc?.locationSelect?.lat,
        widget?.placeBloc?.locationSelect?.lng);

    await apis
        .getRoutes(
      getRoutesRequest: GetRoutesRequestModel(
          fromLocation: _fromLocation,
          toLocation: _toLocation,
          mode: "driving"),
    )
        .then((data) {
      if (data != null) {
        router = data?.result?.routes[0]?.overviewPolyline?.points;
        routesData = data?.result?.routes;
      }
    }).catchError((error) {
      print("GetRoutesRequest > $error");
    });

    distance = routesData[0]?.legs[0]?.distance?.text;
    duration = routesData[0]?.legs[0]?.duration?.text;

    polyLines[polylineId] = GMapViewHelper.createPolyline(
      polylineIdVal: polylineIdVal,
      router: router,
      formLocation: _fromLocation,
      toLocation: _toLocation,
    );
    setState(() {});
    _gMapViewHelper.cameraMove(
        fromLocation: _fromLocation,
        toLocation: _toLocation,
        mapController: _mapController);
  }

  ///Real-time test of driver's location
  ///My data is demo.
  ///This function works by: every 5 or 2 seconds will request for api and after the data returns,
  ///the function will update the driver's position on the map.

  double valueRotation;

  runTrackingDriver(var _listPosition) {
    int count = 1;
    int two = count;
    const timeRequest = const Duration(seconds: 2);
    Timer.periodic(timeRequest, (Timer t) {
      LatLng positionDriverBefore = _listPosition[two - 1];
      positionDriver = _listPosition[count++];
      print(count);

      valueRotation = rm.calculateangle(
          positionDriverBefore.latitude,
          positionDriverBefore.longitude,
          positionDriver.latitude,
          positionDriver.longitude);
      print(valueRotation);
      addMakersDriver(positionDriver);
      _mapController?.animateCamera(
        CameraUpdate?.newCameraPosition(
          CameraPosition(
            target: positionDriver,
            zoom: 15.0,
          ),
        ),
      );
      if (count == _listPosition.length) {
        setState(() {
          t.cancel();
          isComplete = true;
          // showDialog(context: context, child: dialogInfo());
          Toast.show("Arrived", context, gravity: Toast.CENTER);
        });
      }
    });
  }

  addMakersDriver(LatLng _position) {
    final MarkerId markerDriver = MarkerId("driver");
    final Marker marker = Marker(
      markerId: markerDriver,
      position: _position,
      icon: checkPlatform
          ? BitmapDescriptor.fromAsset("assets/image/icon_car_32.png")
          : BitmapDescriptor.fromAsset("assets/image/icon_car_120.png"),
      draggable: false,
      rotation: 0.0,
      consumeTapEvents: true,
      onTap: () {
        // _onMarkerTapped(markerId);
      },
    );
    setState(() {
      markers[markerDriver] = marker;
    });
  }

  dialogOption() {
    return AlertDialog(
      title: Text(localize(context, 'option')),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: Container(
        child: TextFormField(
          controller: optionsController,
          style: textStyle,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            //border: InputBorder.none,
            hintText: localize(context, 'optionHint'),
            // hideDivider: true
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(localize(context, 'cancel')),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(localize(context, 'ok')),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  dialogPromoCode() {
    return AlertDialog(
      title: Text(localize(context, 'promo')),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: Container(
        child: TextFormField(
          controller: promoController,
          style: textStyle,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            //border: InputBorder.none,
            hintText: localize(context, 'enterPromo'),
            // hideDivider: true
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(localize(context, 'confirm')),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Future getCurrentTrip() async {
    await Services.viewCurrentTrip(PrefManager.currentUser.id).then((data) {
      setState(() {
        currentTrip = data;
      });
    });
  }

  checkCurrentTripStatus() {
    getCurrentTrip().then((value) async {
      if (currentTrip != null) {
        if (currentTrip.statusCode != "pending") {
          /*runTrackingDriver([
            LatLng(29.0761835, 31.0992006),
            LatLng(29.075958440557834, 31.09897931985772),
            LatLng(29.075908626571664, 31.098725180554506),
            LatLng(29.07587756607719, 31.09819276206269),
            LatLng(29.07559860724348, 31.098164598870863),
            LatLng(29.07540429616322, 31.09835073749871),
          ]);*/
          setState(() {
            isLoading = false;
            isResult = true;
          });
        }
      } else {
        await Services.getUserTrips(PrefManager.currentUser.id).then((value) {
          List<UserTrip> allTrips = value;
          allTrips.forEach((element) {
            if (element.status == "5" &&
                element.id == CURRENT_TRIP.id.toString()) {
              Navigator.pushReplacementNamed(context, AppRoute.homeScreen);
            }
          });
        });
      }
    });
  }

  bool isBooking = false;

  handSubmit() async {
    final langProvider = Provider.of<AppLanguage>(context, listen: false);
    if (currentTrip == null) {
      setState(() {
        isBooking = true;
      });
      await Services.createNewTrip(
        PrefManager.currentUser.id,
        widget.placeBloc.fromLocation.formattedAddress,
        widget.placeBloc.locationSelect.formattedAddress,
        selectedTaxi.cartype,
        distance,
        promoController.text,
        duration,
        "0",
        widget.placeBloc.fromLocation.lat.toString(),
        widget.placeBloc.fromLocation.lng.toString(),
        widget.placeBloc.locationSelect.lat.toString(),
        widget.placeBloc.locationSelect.lng.toString(),
      ).then((data) {
        print(data);
        if (data['success'] == 1) {
          Toast.show(
            langProvider.appLanguage == "en"
                ? data['message']
                : data['messageAR'],
            context,
            gravity: Toast.CENTER,
          );
        }
        setState(() {
          currentTripID = data['tripid'];
          isBooking = false;
          isLoading = true;
        });
        /*Timer(Duration(seconds: 20), () {
          setState(() {
            isLoading = false;
            isResult = true;
          });
        });*/
      });
    } else {
      Toast.show(localize(context, "youAlreadyHaveTrip"), context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    }
  }

  dialogInfo() {
    AlertDialog(
      title: Text(localize(context, 'information')),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: Text('Trip completed. Review your trip now!.'),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(AppRoute.reviewTripScreen);
          },
        )
      ],
    );
  }

  List<Bid> tripBids = [];

  getBids() async {
    await Services.viewTripBids(currentTripID.toString()).then((value) {
      setState(() {
        tripBids = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      getBids();
    }
    checkCurrentTripStatus();
    return Stack(
      children: <Widget>[
        buildContent(context),
        Positioned(
          // left: 18,
          top: 10,
          right: 10,
          child: SafeArea(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(AppRoute.homeScreen);
              },
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: blackColor,
                ),
              ),
            ),
          ),
        ),
        tripBids.isNotEmpty
            ? Positioned(
                top: MediaQuery.of(context).size.height * .3,
                left: 10,
                right: 10,
                child: Container(
                  height: MediaQuery.of(context).size.height * .33,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFF444444),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            localize(context, 'offers'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Divider(color: whiteColor),
                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  "https://source.unsplash.com/300x300/?portrait"),
                              /*image: tripBids[0].driverPhoto != null
                                  ? NetworkImage(tripBids[0].driverPhoto)
                                  : CachedNetworkImageProvider(
                                      "https://source.unsplash.com/300x300/?portrait"),*/
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          tripBids[0].driverName,
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localize(context, "bidAmount"),
                              style: textStyle.copyWith(
                                color: whiteColor,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              tripBids[0].price,
                              style: textStyle.copyWith(
                                color: whiteColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        MaterialButton(
                          color: Colors.lightGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoute.offersScreen,
                              arguments: [currentTripID],
                            );
                          },
                          child: Text(
                            localize(context, 'viewOffers'),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget buildContent(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SlidingUpPanel(
      controller: panelController,
      maxHeight: screenSize.height * 0.8,
      minHeight: 0.0,
      parallaxEnabled: false,
      parallaxOffset: 0.8,
      backdropEnabled: false,
      renderPanelSheet: false,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      body: Stack(
        children: <Widget>[
          SizedBox(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(widget?.placeBloc?.locationSelect?.lat,
                    widget?.placeBloc?.locationSelect?.lng),
                zoom: 13,
              ),
              markers: Set<Marker>.of(markers.values),
              polylines: Set<Polyline>.of(polyLines.values),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Material(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: isLoading == true
                  ? searchDriver(context)
                  : isResult == true
                      ? ArrivingDetail(
                          trip: currentTrip ?? null,
                          onTapCall: () {
                            launch('tel:${currentTrip.driverDetail.phone}');
                          },
                          onTapChat: () {
                            Navigator.of(context).push(
                              new MaterialPageRoute<Null>(
                                builder: (BuildContext context) {
                                  return ChatScreen();
                                },
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          onTapCancel: () {
                            Navigator.of(context)
                                .pushNamed(AppRoute.cancellationReasonsScreen);
                          },
                        )
                      : selectedTaxi != null
                          ? BookingDetailWidget(
                              bookingSubmit: handSubmit,
                              panelController: panelController,
                              distance: distance,
                              duration: duration,
                              selectedTaxi: selectedTaxi,
                              isBooking: isBooking,
                              onTapOptionMenu: () => showDialog(
                                context: context,
                                child: dialogOption(),
                              ),
                              onTapPromoMenu: () => showDialog(
                                context: context,
                                child: dialogPromoCode(),
                              ),
                            )
                          : Container(),
            ),
          ),
        ],
      ),
      panel: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xFFD5DDE0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
            //SizedBox(height: 18.0,),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: listService.length,
                itemBuilder: (BuildContext context, int index) {
                  return serviceObject(
                    image: listService[index].icon,
                    name: listService[index].cartype,
                    price: listService[index].seatCapacity,
                    time: listService[index].carRate,
                    isSelect: selectedTaxi.cabId == listService[index].cabId,
                    onTap: () {
                      setState(() {
                        selectedTaxi = listService[index];
                        panelController.close();
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceObject(
      {String image,
      String name,
      String price,
      String time,
      bool isSelect,
      VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            color: isSelect == true
                ? appTheme?.primaryColor?.withOpacity(0.4)
                : whiteColor,
            padding: EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              top: 5.0,
              bottom: 5.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'assets/image/icon_taxi/1.png',
                        height: 60,
                      ),
                      Text(
                        name ?? '',
                        style:
                            TextStyle(fontSize: 15, color: Color(0Xff3E4958)),
                      )
                    ],
                  ),
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group,
                      size: 35,
                      color: isSelect ? activeColor : greyColor2,
                    ),
                    SizedBox(height: 5),
                    Text(
                      price ?? '\$0',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color(0Xff3E4958),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      size: 35,
                      color: isSelect ? activeColor : greyColor2,
                    ),
                    SizedBox(height: 5),
                    Text(
                      time ?? '\$0',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0Xff3E4958),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                /*Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFFD5DDE0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        time ?? "0 min",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.star),
                    ],
                  ),
                )*/
              ],
            ),
          ),
          Divider(
            height: 0,
            color: greyColor,
          )
        ],
      ),
    );
  }

  Widget searchDriver(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: LoadingBuilder(),
          ),
          SizedBox(height: 20),
          Text(
            localize(context, 'searchingForDriver'),
            style: TextStyle(
              fontSize: 18,
              color: greyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
