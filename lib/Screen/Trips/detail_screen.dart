import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Blocs/place_bloc.dart';
import 'package:flutter_map_booking/Components/ink_well_custom.dart';
import 'package:flutter_map_booking/Model/place_model.dart';
import 'package:flutter_map_booking/Model/user_trip.dart';
import 'package:flutter_map_booking/Screen/Directions/direction_screen.dart';
import 'package:flutter_map_booking/app_router.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class HistoryDetail extends StatefulWidget {
  final UserTrip trip;

  HistoryDetail({this.trip});

  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  String yourReview;
  double ratingScore;

  @override
  void initState() {
    super.initState();
    print('code ${widget.trip.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: widget.trip.statusCode == "FINISHED"
          ? Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: ButtonTheme(
                minWidth: screenSize.width,
                height: 50.0,
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0)),
                  elevation: 0.0,
                  color: primaryColor,
                  child: new Text(
                    localize(context, 'submit'),
                    style: headingWhite.copyWith(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
//              Navigator.of(context).pushReplacementNamed('/history');
//              //and
//              Navigator.popAndPushNamed(context, '/history');
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoute.historyScreen);
                  },
                ),
              ),
            )
          : Container(height: 0),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 100.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  localize(context, 'orderDetails'),
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 16.0,
                  ),
                ),
                background: Container(
                  color: blackColor,
                ),
              ),
            ),
          ];
        },
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
            child: InkWellCustom(
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.trip.statusCode != "pending"
                        ? GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoute.driverDetailScreen);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              color: whiteColor,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Material(
                                    elevation: 5.0,
                                    borderRadius: BorderRadius.circular(70.0),
                                    child: SizedBox(
                                      height: 70,
                                      width: 70,
                                      child: Hero(
                                        tag: "avatar_profile",
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                            "https://source.unsplash.com/300x300/?portrait",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width: screenSize.width - 100,
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                widget.trip.driverDetail
                                                        .driverName ??
                                                    "",
                                                style: textBoldBlack,
                                              ),
                                            ),
                                            Text(
                                              widget.trip.bookCreateDateTime ??
                                                  "",
                                              style: textStyle,
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(height: 15),
                    rideHistory(),
                    new Container(
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                      color: whiteColor,
                      child: Column(
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Text(
                                localize(context, 'billDetails'),
                                style: TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  localize(context, 'rideFare'),
                                  style: textStyle,
                                ),
                                new Text(
                                  "${widget.trip.amount}",
                                  style: textStyle,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  localize(context, 'taxes'),
                                  style: textStyle,
                                ),
                                new Text(
                                  "\١٫٩٩",
                                  style: textStyle,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  localize(context, 'discount'),
                                  style: textStyle,
                                ),
                                new Text(
                                  "- \٥٫٩٩ ",
                                  style: textStyle,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  localize(context, 'totalBill'),
                                  style: TextStyle(
                                      color: blackColor, fontSize: 16),
                                ),
                                new Text(
                                  "${widget.trip.finalAmount}",
                                  style: TextStyle(
                                    color: blackColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    widget.trip.statusCode == "pending"
                        ? Container(
                            padding: EdgeInsets.only(
                                top: 20, left: 20.0, right: 20.0, bottom: 20.0),
                            child: ButtonTheme(
                              minWidth: screenSize.width,
                              height: 50.0,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0)),
                                elevation: 0.0,
                                color: primaryColor,
                                child: new Text(
                                  localize(context, 'viewOffers'),
                                  style: headingWhite.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoute.offersScreen,
                                    arguments: [widget.trip.id],
                                  );
                                },
                              ),
                            ),
                          )
                        : Container(),
                    Divider(),
                    widget.trip.statusCode == "FINISHED"
                        ? Container(
                            padding: EdgeInsets.only(left: 20.0),
                            child: Text(
                              localize(context, 'review'),
                              style: TextStyle(
                                  color: blackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          )
                        : Container(),
                    widget.trip.statusCode == "FINISHED"
                        ? Form(
                            key: formKey,
                            child: Container(
                              padding:
                                  EdgeInsets.only(left: 20, top: 10, right: 20),
                              color: whiteColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RatingBar(
                                    initialRating: 4,
                                    allowHalfRating: true,
                                    itemSize: 25.0,
                                    glowColor: whiteColor,
                                  ratingWidget: RatingWidget(
                                      half: Icon(
                                        Icons.star_half,
                                        color: Colors.amber,
                                      ),
                                      empty: Icon(
                                        Icons.star_border_outlined,
                                        color: Colors.amber,
                                      ),
                                      full: Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      )
                                  ),
                                    onRatingUpdate: (rating) {
                                      ratingScore = rating;
                                    },
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: new SizedBox(
                                      height: 100.0,
                                      child: new TextField(
                                        style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                        ),
                                        decoration: InputDecoration(
                                          hintText:
                                              localize(context, 'writeReview'),
                                          hintStyle: TextStyle(
                                            color: Colors.black38,
                                            fontFamily: 'Akrobat-Bold',
                                            fontSize: 16.0,
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                        ),
                                        maxLines: 2,
                                        keyboardType: TextInputType.multiline,
                                        onChanged: (String value) {
                                          setState(() => yourReview = value);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    widget.trip.statusCode == "FINISHED" ||
                            widget.trip.statusCode == "user-cancelled"
                        ? Container()
                        : Container(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 20.0, bottom: 20.0),
                            child: ButtonTheme(
                              minWidth: screenSize.width,
                              height: 50.0,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                elevation: 0.0,
                                color: primaryColor,
                                child: new Text(
                                  localize(context, 'cancelTrip'),
                                  style: headingWhite.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoute.cancellationReasonsScreen,
                                    arguments: [widget.trip.id],
                                  );
                                },
                              ),
                            ),
                          ),
                    (widget.trip.statusCode != "FINISHED" &&
                            widget.trip.statusCode == "Accepted")
                        ? Container(
                            padding: EdgeInsets.only(
                                top: 20, left: 20.0, right: 20.0, bottom: 20.0),
                            child: ButtonTheme(
                              minWidth: screenSize.width,
                              height: 50.0,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0)),
                                elevation: 0.0,
                                color: primaryColor,
                                child: new Text(
                                  localize(context, 'viewTrip'),
                                  style: headingWhite.copyWith(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    currentTripID = int.parse(widget.trip.id);
                                  });
                                  viewTrip();
                                },
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  viewTrip() {
    final placeBloc = Provider.of<PlaceBloc>(context, listen: false);
    placeBloc.getCurrentLocation(
      Place(
        name: widget.trip.pickupArea,
        formattedAddress: widget.trip.pickupArea,
        lat: double.parse(widget.trip.pickupLat),
        lng: double.parse(widget.trip.pickupLong),
      ),
    );
    placeBloc
        .selectLocation(
      Place(
        name: widget.trip.dropArea,
        formattedAddress: widget.trip.dropArea,
        lat: double.parse(widget.trip.dropLat),
        lng: double.parse(widget.trip.dropLong),
      ),
    )
        .then((value) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DirectionScreen(),
        ),
      );
    });
  }

  Widget rideHistory() {
    return Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(15.0),
      color: whiteColor,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        margin: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: greyColor, width: 1.0),
          color: whiteColor,
        ),
        child: Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.trip.bookCreateDateTime.substring(11, 16),
                        style:
                            TextStyle(color: Color(0xFF97ADB6), fontSize: 13.0),
                      ),
                      Text(
                        widget.trip.departureDateTime.substring(11, 16),
                        style:
                            TextStyle(color: Color(0xFF97ADB6), fontSize: 13.0),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.my_location,
                      color: blackColor,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      height: 25,
                      width: 1.0,
                      color: Colors.grey,
                    ),
                    Icon(
                      Icons.location_on,
                      color: blackColor,
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.trip.pickupArea,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      widget.trip.dropArea,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
