import 'package:flutter/material.dart';
import 'package:flutter_map_booking/API/services.dart';
import 'package:flutter_map_booking/Components/animation_list_view.dart';
import 'package:flutter_map_booking/Model/user_trip.dart';
import 'package:flutter_map_booking/Prefs/pref_manager.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/language/app_language.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:flutter_map_booking/Screen/Menu/menu_screen.dart';
import 'package:provider/provider.dart';
import 'detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final String screenName = "HISTORY";
  List<UserTrip> allUserTrips = [];

  navigateToDetail(UserTrip trip) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HistoryDetail(
          trip: trip,
        ),
      ),
    );
  }

  Future getUserTrips() async {
    await Services.getUserTrips(PrefManager.currentUser.id).then((data) {
      setState(() {
        allUserTrips = data;
        if (allUserTrips != null){
          allUserTrips.forEach((element) {
            if (element.status == "0"){
              CURRENT_TRIP = element;
            }
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getUserTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuScreens(activeScreenName: screenName),
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
                  localize(context, 'history'),
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
          child: allUserTrips.length != 0
              ? ListView.separated(
                  itemCount: allUserTrips.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  separatorBuilder: (_, int i) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationListView(
                      index: index,
                      child: GestureDetector(
                        onTap: () {
                          print('$index');
                          navigateToDetail(allUserTrips[index]);
                        },
                        child: rideHistory(allUserTrips[index]),
                      ),
                    );
                  },
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget rideHistory(UserTrip trip) {
    final langProvider = Provider.of<AppLanguage>(context);
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15.0),
      color: whiteColor,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), color: whiteColor),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  trip.bookCreateDateTime,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                Text(
                  trip.statusCode,
                  style: TextStyle(
                    color: redColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                  ),
                )
              ],
            ),
            Divider(),
            Container(
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
                            trip.bookCreateDateTime.substring(11, 16),
                            style: TextStyle(
                              color: Color(0xFF97ADB6),
                              fontSize: 13.0,
                            ),
                          ),
                          Text(
                            trip.departureDateTime.substring(11, 16),
                            style: TextStyle(
                              color: Color(0xFF97ADB6),
                              fontSize: 13.0,
                            ),
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
                          trip.pickupArea,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          trip.dropArea,
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
            )
          ],
        ),
      ),
    );
  }
}
