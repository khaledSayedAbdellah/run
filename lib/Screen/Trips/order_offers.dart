import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_booking/API/services.dart';
import 'package:flutter_map_booking/Blocs/place_bloc.dart';
import 'package:flutter_map_booking/Model/bid.dart';
import 'package:flutter_map_booking/Model/place_model.dart';
import 'package:flutter_map_booking/Model/user_trip.dart';
import 'package:flutter_map_booking/Prefs/pref_manager.dart';
import 'package:flutter_map_booking/Screen/Directions/direction_screen.dart';
import 'package:flutter_map_booking/app_router.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/language/app_language.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class OrderOffersPage extends StatefulWidget {
  final tripID;

  OrderOffersPage({@required this.tripID});

  @override
  _OrderOffersPageState createState() => _OrderOffersPageState();
}

class _OrderOffersPageState extends State<OrderOffersPage> {
  List<Bid> tripBids;

  getBids() async {
    await Services.viewTripBids(widget.tripID).then((value) {
      setState(() {
        tripBids = value;
      });
    });
  }

  _buildOffer(index) {
    final lang = Provider.of<AppLanguage>(context, listen: false);
    final placeBloc = Provider.of<PlaceBloc>(context, listen: false);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          color: Color(0xFFE7F4F7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            "https://source.unsplash.com/300x300/?portrait"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        tripBids[index].driverName,
                        style: textBoldBlack.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            localize(context, "bidAmount"),
                            style: textStyle,
                          ),
                          SizedBox(width: 5),
                          Text(
                            tripBids[index].price,
                            style: textStyle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              MaterialButton(
                color: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () async {
                  await Services.acceptBid(widget.tripID, tripBids[index].id,
                          tripBids[index].driverID)
                      .then((value) {
                    print(value);
                    if (value['success'] == 1) {
                      Toast.show(
                        lang.appLanguage == "en"
                            ? value['message']
                            : value['messageAR'],
                        context,
                        gravity: Toast.CENTER,
                        duration: Toast.LENGTH_LONG,
                      );
                      placeBloc.getCurrentLocation(
                        Place(
                          name: CURRENT_TRIP.pickupArea,
                          formattedAddress: CURRENT_TRIP.pickupArea,
                          lat: double.parse(CURRENT_TRIP.pickupLat),
                          lng: double.parse(CURRENT_TRIP.pickupLong),
                        ),
                      );
                      placeBloc
                          .selectLocation(
                        Place(
                          name: CURRENT_TRIP.dropArea,
                          formattedAddress: CURRENT_TRIP.dropArea,
                          lat: double.parse(CURRENT_TRIP.dropLat),
                          lng: double.parse(CURRENT_TRIP.dropLong),
                        ),
                      )
                          .then((value) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DirectionScreen(),
                          ),
                        );
                      });
                    } else {
                      Toast.show(
                        "Something went wrong",
                        context,
                        gravity: Toast.CENTER,
                        duration: Toast.LENGTH_LONG,
                      );
                    }
                  });
                },
                child: Text(
                  localize(context, 'accept'),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: blackColor),
      ],
    );
  }

  Future getCurrentTrip() async {
    await Services.viewCurrentTrip(PrefManager.currentUser.id).then((data) {
      print("DATA => $data");
      setState(() {
        CURRENT_TRIP = data;
      });
    });
  }


  @override
  void initState() {
    super.initState();
    getBids();
    print("CUR => ${CURRENT_TRIP.toJson()}");
    // getCurrentTrip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localize(context, 'offers')),
        centerTitle: true,
      ),
      body:  Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: tripBids != null
            ? tripBids.isNotEmpty
            ? ListView.builder(
          itemCount: tripBids.length,
          itemBuilder: (context, index) {
            return _buildOffer(index);
          },
        )
            : Center(
          child: Text(localize(context, "noBidsYet")),
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
