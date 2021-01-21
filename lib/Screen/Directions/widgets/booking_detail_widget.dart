import 'package:flutter/material.dart';
import 'package:flutter_map_booking/Components/decodePolyline.dart';
import 'package:flutter_map_booking/Model/taxi_type.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/language/app_language.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class BookingDetailWidget extends StatefulWidget {
  @required
  final VoidCallback bookingSubmit;
  @required
  final PanelController panelController;
  @required
  final String distance;
  @required
  final String duration;
  @required
  final bool isBooking;
  final VoidCallback onTapOptionMenu;
  final VoidCallback onTapPromoMenu;
  final CarType selectedTaxi;

  BookingDetailWidget(
      {this.bookingSubmit,
      this.panelController,
      this.distance,
      this.duration,
      this.isBooking,
      this.selectedTaxi,
      this.onTapOptionMenu,
      this.onTapPromoMenu});

  @override
  _BookingDetailWidgetState createState() => _BookingDetailWidgetState();
}

class _BookingDetailWidgetState extends State<BookingDetailWidget> {
  List<String> coded = ["hours", "mins"]; //ABV list
  List<String> decoded = ["ساعة", "دقيقة"];

  String formatTimeIntoArabic() {
    String timeInArabic = widget.duration;
    if (timeInArabic != null) {
      timeInArabic = timeInArabic.replaceAll(coded[0], decoded[0]);
      timeInArabic = timeInArabic.replaceAll(coded[1], decoded[1]);
      print(timeInArabic);
      return timeInArabic;
    } else
      return widget.duration;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<AppLanguage>(context);
    return Container(
      height: 300.0,
      child: Column(
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(left: 20.0, right: 20.0, top: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  localize(context, 'suggestService'),
                  style: TextStyle(
                      fontSize: 18,
                      color: blackColor,
                      fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    widget.panelController?.open();
                  },
                  child: Row(
                    children: <Widget>[
                      Text(
                        localize(context, 'viewAll'),
                        style: TextStyle(
                            fontSize: 18,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Icon(
                        Icons.expand_less,
                        color: greyColor,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.panelController?.open();
            },
            child: Container(
              height: 80.0,
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: primaryColor.withOpacity(0.5), width: 1.0),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/image/icon_taxi/1.png",
                                    height: 50,
                                  ),
                                  Text(
                                    widget.selectedTaxi.cartype ?? "",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0Xff3E4958),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Text(
                        widget.distance != null ? widget.distance : "0 km",
                        style: textGrey,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /*Text(
                              widget.selectedTaxi.carRate,
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0Xff3E4958),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),*/
                            Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                              ),
                              color: Color(0xFFD5DDE0),
                              child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(7.0, 5.0, 7.0, 5.0),
                                child: Text(
                                      langProvider.appLanguage == "en"
                                          ? widget.duration
                                          : formatTimeIntoArabic() ?? "0",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      textDirection:
                                          langProvider.appLanguage == "ar"
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                      textAlign: TextAlign.center,
                                    ),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1.0,
            color: greyColor2,
          ),
          Container(
            color: whiteColor,
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                      onTap: widget.onTapOptionMenu,
                      // ()  =>showDialog(context: context, child: dialogOption()),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.cogs,
                            color: blackColor,
                          ),
                          SizedBox(height: 10),
                          Text(
                            localize(context, 'options'),
                            style: textStyle,
                          ),
                        ],
                      )),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  width: 1.0,
                  height: 30.0,
                  color: Colors.grey.withOpacity(0.4),
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                      onTap: widget.onTapPromoMenu,
                      // () => showDialog(context: context, child: dialogPromoCode()),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.gifts,
                            color: blackColor,
                          ),
                          SizedBox(height: 10),
                          Text(
                            localize(context, 'promo'),
                            style: textStyle,
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width - 50.0,
              height: 50.0,
              child: !widget.isBooking
                  ? RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0.0,
                      color: primaryColor,
                      child: Text(
                        localize(context, 'bookNow'),
                        style: headingWhite,
                      ),
                      onPressed: widget.bookingSubmit,
                    )
                  : _loader(),
            ),
          ),
        ],
      ),
    );
  }
}
