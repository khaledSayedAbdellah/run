import 'package:flutter/material.dart';
import 'package:flutter_map_booking/API/services.dart';
import 'package:flutter_map_booking/app_router.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:toast/toast.dart';

class CancellationReasonsScreen extends StatefulWidget {
  final tripID;

  CancellationReasonsScreen({this.tripID});

  @override
  _CancellationReasonsScreenState createState() =>
      _CancellationReasonsScreenState();
}

class _CancellationReasonsScreenState extends State<CancellationReasonsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whiteColor,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        child: ButtonTheme(
          height: 50.0,
          minWidth: MediaQuery.of(context).size.width - 50,
          child: RaisedButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            elevation: 0.0,
            color: primaryColor,
            icon: Text(''),
            label: Text(
              localize(context, 'submit'),
              style: headingWhite,
            ),
            onPressed: () async {
              await Services.cancelTrip(widget.tripID ?? currentTripID)
                  .then((data) {
                Toast.show(data['message'], context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                Navigator.of(context).pushReplacementNamed(AppRoute.homeScreen);
              });
            },
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 50),
              child: Text(
                localize(context, 'selectReason'),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                maxLines: 2,
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.08,
            ),
            RadioButtonGroup(
                activeColor: primaryColor,
                labelStyle: TextStyle(
                  fontSize: 15,
                ),
                labels: <String>[
                  localize(context, 'reason1'),
                  localize(context, 'reason2'),
                  localize(context, 'reason3'),
                  localize(context, 'reason4'),
                ],
                onSelected: (String selected) => print(selected)),
          ],
        ),
      ),
    );
  }
}
