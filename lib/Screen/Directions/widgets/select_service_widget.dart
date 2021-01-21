import 'package:flutter/material.dart';
import 'package:flutter_map_booking/API/services.dart';
import 'package:flutter_map_booking/Model/taxi_type.dart';
import 'package:flutter_map_booking/constants.dart';
import 'package:flutter_map_booking/theme/style.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SelectServiceWidget extends StatefulWidget {
  String serviceSelected;
  final PanelController panelController;

  SelectServiceWidget({this.serviceSelected, this.panelController});

  @override
  _SelectServiceWidgetState createState() => _SelectServiceWidgetState();
}

class _SelectServiceWidgetState extends State<SelectServiceWidget> {
  List<CarType> listService = [];

  CarType selectedTaxi;

  getCarTypes() async{
    await Services.getCarTypes().then((data){
      print(data);
      setState(() {
        selectedTaxi = data[0];
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // initServices();
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
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
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
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
                  isSelect: widget?.serviceSelected == listService[index].cabId,
                  onTap: () {
                    setState(() {
                      widget?.serviceSelected = listService[index].cabId;
                      widget?.panelController?.close();
                      selectedTaxi = listService[index];
                      selectedTaxiType = selectedTaxi.cabId;
                    });
                  },
                );
              },
            ),
          ),
        ],
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
            padding:
                EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        image,
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
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          price ?? '\$0',
                          style: TextStyle(
                              fontSize: 26,
                              color: Color(0Xff3E4958),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Material(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                          ),
                          color: Color(0xFFD5DDE0),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(7.0, 5.0, 7.0, 5.0),
                            child: Text(
                              time ?? "0 min",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
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
}
