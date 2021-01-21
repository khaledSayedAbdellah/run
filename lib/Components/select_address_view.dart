import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Blocs/place_bloc.dart';
import 'package:flutter_map_booking/Model/place_model.dart';
import 'package:flutter_map_booking/Screen/Directions/direction_screen.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/theme/style.dart';
import "package:google_maps_webservice/places.dart";
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

class SelectAddress extends StatefulWidget {
  final String fromAddress, toAddress;
  final List<PlacesSearchResult> places;
  final VoidCallback onTap;

  SelectAddress({this.fromAddress, this.toAddress, this.places, this.onTap});

  @override
  _SelectAddressState createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  String selectedAddress;

  Widget getOption() {
    final placeBloc = Provider.of<PlaceBloc>(context, listen: false);
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: widget.places.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.all(3),
          child: ChoiceChip(
            key: ValueKey<String>(widget.places[index].id),
            labelStyle: TextStyle(color: whiteColor),
            backgroundColor: whiteColor,
            selectedColor: Color(0xFF888888),
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            selected: selectedAddress == widget.places[index].id,
            label: Text(
              widget.places[index].name,
              style: TextStyle(
                color: selectedAddress == widget.places[index].id
                    ? whiteColor
                    : blackColor,
              ),
            ),
            onSelected: (bool check) {
              print(widget.places[index].name);
              placeBloc
                  .selectLocation(
                Place(
                  name: widget.places[index].name,
                  formattedAddress: widget.places[index].formattedAddress,
                  lat: widget.places[index].geometry.location.lat,
                  lng: widget.places[index].geometry.location.lng,
                ),
              )
                  .then((value) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DirectionScreen(),
                  ),
                );
              });
              // widget?.onTap();
//              setState(() {
//                selectedAddress = check ? listAddress[index]["id"].toString() : '';
//              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(OMIcons.myLocation, color: blackColor),
                      SizedBox(height: 2),
                      Container(
                        height: 40,
                        width: 1.0,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 2),
                      Icon(OMIcons.locationOn, color: blackColor)
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                localize(context, 'pickUp'),
                                style:
                                    TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              Text(
                                widget.fromAddress ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: textStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                localize(context, 'dropOff'),
                                style:
                                    TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                              Text(
                                widget.toAddress != null
                                    ? widget.toAddress
                                    : '',
                                overflow: TextOverflow.ellipsis,
                                style: textStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            widget.places.length != 0
                ? Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overScroll) {
                          overScroll.disallowGlow();
                          return false;
                        },
                        child: getOption(),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
