import 'package:flutter/material.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  @override
  _RestaurantDetailsScreenState createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: body(),
    );
  }
  AppBar _appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("سلطان دي لايت برجر",
            style: TextStyle(fontSize: 18,color: Colors.grey.shade600),),
          Text("مطاعم توصيل مجاني",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
      elevation: 0.4,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: ()=> Navigator.of(context).pop(),
      ),
    );
  }

  Widget body(){
    return Container(
      color: Colors.blueGrey.shade50,
      child: Center(
        child: Text("demo"),
      ),
    );
  }
}
