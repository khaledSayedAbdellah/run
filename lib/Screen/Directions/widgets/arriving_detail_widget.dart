import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Model/user_trip.dart';
import 'package:flutter_map_booking/app_router.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'icon_action_widget.dart';

class ArrivingDetail extends StatelessWidget {
  final VoidCallback onTapCall;
  final VoidCallback onTapChat;
  final VoidCallback onTapCancel;
  final UserTrip trip;

  ArrivingDetail({this.trip, this.onTapCall, this.onTapChat, this.onTapCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270.0,
      padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Material(
                      elevation: 10.0,
                      color: Colors.white,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: SizedBox(
                          height: 70,
                          width: 70,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            backgroundImage: CachedNetworkImageProvider(
                              "https://source.unsplash.com/300x300/?portrait",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            trip != null ? trip.driverDetail.driverName : "",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: primaryColor,
                                size: 18,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '4.3',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  // height: 3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          trip != null ? trip.statusCode : "",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconAction(
                  icon: Icons.call,
                  onTap: onTapCall,
                ),
                IconAction(
                  icon: MdiIcons.chatOutline,
                  onTap: onTapChat,
                ),
                IconAction(
                  icon: Icons.clear,
                  onTap: onTapCancel,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigator.of(context).pushNamed(AppRoute.reviewTripScreen);
            },
            child: Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.all(5.0),
              child: Text("Skip"),
            ),
          )
        ],
      ),
    );
  }
}
